unit stwvProcesplan;

interface

uses stwvHokjes, stwvRijwegen, stwvRijwegLogica, stwpTijd, stwvCore,
	stwvMeetpunt, stwvRijVeiligheid, clientSendMsg, stwvLog;

const
	DoorkomstRijwegMaxWacht	= 10;
	VertrekRijwegMaxWacht   = 0;

type
	TActiviteitSoort = (asDoorkomst, asVertrek, asAankomst, asKortestop, asNul);

	PvProcesPlanPunt = ^TvProcesPlanPunt;
	TvProcesPlanPunt = record
		// Statische informatie
		Treinnr:		  		String;	// Welke trein?
		ActiviteitSoort:	TActiviteitSoort;	// Wat gaan we doen?
		Plantijd:			integer;	// Wanneer bereikt de trein deze rijweg?
		// XXX Hier moet nog vertraginsinfo. ///
		// Vertraging:		integer;
		// Waargemeten:	string;
		Insteltijd:			integer;	// Wanneer moet de rijweg ingesteld worden?
		van, naar:			string;	// Klikpuntstring (met r of s ervoor)
		dwang:				byte;		// 0=geen dwang
		ROZ:					boolean;	// Moeten we ROZ instellen?
		gefaseerd:			boolean;	// Mogen de rijwegen een voor een worden
											// ingesteld of alleen allemaal tegelijk?
		// Onderstaande valt allemaal onder Bijzondere Informatie //
		ARI_toegestaan:	boolean;
		NieuwNummer:		string;	// De trein krijgt een nieuw nummer bij aankomst
		NieuwNummerGedaan:boolean;
		RestNummer:			string;	// Een achtergebleven, afgekoppeld treindeel
											// krijgt dit nummer bij vertrek van het andere
											// treindeel.
		RestNummerGedaan:	boolean;

		Volgende:			PvProcesPlanPunt;

		// Dynamische informatie
		TNVVan:				PvMeetpunt;
		TriggerPunt:		PvMeetpunt;
		PrlRijweg:			PvPrlRijweg;
	end;

	TProcesPlan = class
	private
		function SplitsPunt(ProcesPlanPunt: PvProcesPlanPunt; Splitsspoor: string): PvProcesPlanPunt;
		function Sort_Merge(links, rechts: PvProcesPlanPunt): PvProcesPlanPunt;
		function Sort_List(PPP: PvProcesPlanPunt): PvProcesPlanPunt;
	public
		ProcesPlanPuntenKlaar:		PvProcesPlanPunt;
		KlaarAantal:					integer;
		ProcesPlanPuntenPending:	PvProcesPlanPunt;
		// Externe zaken
		RijwegLogica:	TRijwegLogica;
		Core:				PvCore;
		SendMsg:			TvSendMsg;
		Log:				TLog;
		// Intern
		constructor Create;
		destructor Destroy; override;
		procedure UpdatePlanpunt(ProcesPlanPunt: PvProcesPlanPunt);
		procedure MarkeerKlaar(ProcesPlanPunt: PvProcesPlanPunt);
		// Extern
		procedure LaadProcesplan(filename: string);
		procedure Sorteer;
		// Gebeurtenissen
		function ProbeerPlanpuntUitTeVoeren(ProcesPlanPunt: PvProcesPlanPunt): boolean;
		procedure DoeStapje;
		procedure TreinnummerNieuw(Meetpunt: PvMeetpunt);
		procedure TreinnummerWeg(Meetpunt: PvMeetpunt);
	end;

implementation

function TProcesPlan.Sort_Merge;
var
	first, last: PvProcesPlanPunt;
begin
	first := nil;
	last := nil;
	while assigned(Links) and assigned(Rechts) do
		if Links^.Insteltijd <= Rechts^.Insteltijd then begin
			if assigned(first) then begin
				last^.Volgende := Links;
				Last := Last^.Volgende;
				Links := Links^.Volgende;
			end else begin
				first := links;
				last := links;
				Links := Links^.Volgende;
			end;
			Last^.Volgende := nil;
		end else begin
			if assigned(first) then begin
				last^.Volgende := Rechts;
				Last := Last^.Volgende;
				Rechts := Rechts^.Volgende;
			end else begin
				first := Rechts;
				last := Rechts;
				Rechts := Rechts^.Volgende;
			end;
			Last^.Volgende := nil;
		end;
	while assigned(Links) do begin
		if assigned(first) then begin
			last^.Volgende := Links;
			Last := Last^.Volgende;
			Links := Links^.Volgende;
		end else begin
			first := links;
			last := links;
			Links := Links^.Volgende;
		end;
		Last^.Volgende := nil;
	end;
	while assigned(Rechts) do begin
		if assigned(first) then begin
			last^.Volgende := Rechts;
			Last := Last^.Volgende;
			Rechts := Rechts^.Volgende;
		end else begin
			first := Rechts;
			last := Rechts;
			Rechts := Rechts^.Volgende;
		end;
		Last^.Volgende := nil;
	end;
	result := first;
end;

function TProcesPlan.Sort_List;
var
	count, helft, i: integer;
	tmpPPP, hpPPP,
	links,rechts: PvProcesPlanPunt;
begin
	result := PPP;
	if not assigned(PPP) then exit;
	if not assigned(PPP^.Volgende) then exit;

	tmpPPP := PPP;
	count := 0;
	while assigned(tmpPPP) do begin
		inc(count);
		tmpPPP := tmpPPP^.Volgende;
	end;

	helft := count div 2;
	tmpPPP := PPP;
	for i := 2 to helft do
		tmpPPP := tmpPPP^.Volgende;
	hpPPP := tmpPPP^.Volgende;
	tmpPPP^.Volgende := nil;

	links := Sort_List(PPP);
	rechts := Sort_List(hpPPP);
	result := Sort_Merge(links, rechts);
end;

// Het oude punt wordt gewijzigd in Splitsspoor -> Naar
// Het nieuwe punt wordt Van -> Splitsspoor.
function TProcesPlan.SplitsPunt;
var
	NieuwPunt:	PvProcesPlanPunt;
	dwang: 		integer;
	PrlRijweg1,
	PrlRijweg2:	PvPrlRijweg;
	RijwegL1,
	RijwegL2:	PvRijwegLijst;
	Doe, OK:		boolean;
begin
	// Gegevens nieuwe punt instellen
	new(NieuwPunt);
	NieuwPunt^.Treinnr := ProcesPlanPunt^.Treinnr;
	NieuwPunt^.ActiviteitSoort := ProcesPlanPunt^.ActiviteitSoort;
	NieuwPunt^.Plantijd := ProcesPlanPunt^.Plantijd;
	NieuwPunt^.Insteltijd := ProcesPlanPunt^.Insteltijd;
	NieuwPunt^.van := ProcesPlanPunt^.van;
	NieuwPunt^.dwang := ProcesPlanPunt^.dwang;
	NieuwPunt^.gefaseerd := ProcesPlanPunt^.gefaseerd;
	NieuwPunt^.ARI_toegestaan := ProcesPlanPunt^.ARI_toegestaan;
	NieuwPunt^.NieuwNummer := '';
	NieuwPunt^.NieuwNummerGedaan := false;
	NieuwPunt^.RestNummer := '';
	NieuwPunt^.RestNummerGedaan := false;
	NieuwPunt^.TNVVan := nil;
	NieuwPunt^.TriggerPunt := nil;
	NieuwPunt^.PrlRijweg := nil;

	NieuwPunt^.ROZ := false;
	NieuwPunt^.naar := Splitsspoor;

	// Oude punt bijwerken
	// Eerst moeten we het juiste nieuwe 'dwang'-nummer zoeken.
	PrlRijweg1 := ZoekPrlRijweg(Core, ProcesPlanPunt^.van, ProcesPlanPunt^.naar,
		ProcesPlanPunt^.dwang);
	dwang := 0;
	repeat
		OK := false;
		// Zoek de rijweg Splitsspoor->Naar met de geitereerde dwang.
		Doe := false;
		PrlRijweg2 := ZoekPrlRijweg(Core, Splitsspoor, ProcesPlanPunt^.naar, Dwang);
		// Bestaat die niet? Dan zijn we klaar.
		if (not assigned(PrlRijweg1)) or (not assigned(PrlRijweg2)) then
			break;
		// Zoek het punt vanaf waar de rijwegen overeenkomen.
		RijwegL1 := PrlRijweg1^.Rijwegen;
		RijwegL2 := PrlRijweg2^.Rijwegen;
		repeat
			RijwegL1 := RijwegL1^.Volgende;
			// Is dat punt er niet? Dan de volgende dwang nemen.
			if not assigned(RijwegL1) then
				break;
			if RijwegL1^.Rijweg = RijwegL2^.Rijweg then
				doe := true;
		until doe;
		if doe then begin
			// We hebben een overeenkomst gevonden. Kijk of verder de hele rijweg
			// overeenkomt.
			OK := true;
			while assigned(RijwegL1) and assigned(RijwegL2) do begin
				OK := OK and (RijwegL1^.Rijweg = RijwegL2^.Rijweg);
				RijwegL1 := RijwegL1^.Volgende;
				RijwegL2 := RijwegL2^.Volgende;
			end;
		end;
		if not OK then
			inc(Dwang);
	until OK or (Dwang = 11);
	if not OK then
		Dwang := 0;
	// En de gegevens bijwerken
	ProcesPlanPunt^.van := Splitsspoor;
	ProcesPlanPunt^.dwang := Dwang;

	Log.Log('ProcesPlan: Regel aangepast: trein '+ProcesPlanPunt^.Treinnr+
	' moet verder van spoor '+ProcesPlanPunt^.van+' naar spoor '+ProcesPlanPunt^.naar);

	result := NieuwPunt;
end;

constructor TProcesPlan.Create;
begin
	inherited;
	ProcesPlanPuntenPending := nil;
	ProcesPlanPuntenKlaar := nil;
	KlaarAantal := 0;
end;

destructor TProcesPlan.Destroy;
var
	tmpPPP: PvProcesPlanPunt;
begin
	while assigned(ProcesPlanPuntenPending) do begin
		tmpPPP := ProcesPlanPuntenPending;
		ProcesPlanPuntenPending := ProcesPlanPuntenPending^.Volgende;
		dispose(tmpPPP);
	end;
	while assigned(ProcesPlanPuntenKlaar) do begin
		tmpPPP := ProcesPlanPuntenKlaar;
		ProcesPlanPuntenKlaar := ProcesPlanPuntenKlaar^.Volgende;
		dispose(tmpPPP);
	end;
	inherited Destroy;
end;

procedure TProcesPlan.UpdatePlanpunt;
begin
	// Zoek de PrlRijweg
	if assigned(ProcesPlanPunt^.PrlRijweg) then begin
		if (ProcesPlanPunt^.PrlRijweg^.van <> ProcesPlanPunt^.Van) or
			(ProcesPlanPunt^.PrlRijweg^.naar <> ProcesPlanPunt^.Naar) then
			ProcesPlanPunt^.PrlRijweg := ZoekPrlRijweg(Core,ProcesPlanPunt^.Van,
				ProcesPlanPunt^.Naar, ProcesPlanPunt^.Dwang);
	end else
		ProcesPlanPunt^.PrlRijweg := ZoekPrlRijweg(Core,ProcesPlanPunt^.Van,
			ProcesPlanPunt^.Naar, ProcesPlanPunt^.Dwang);

	// Zoek het tnv-van-punt
	if assigned(ProcesPlanPunt^.PrlRijweg) then
		ProcesPlanPunt^.TNVVan := ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein^.VanTNVMeetpunt
	else
		ProcesPlanPunt^.TNVVan := nil;

	// Zoek het tnv-trigger-punt
	if assigned(ProcesPlanPunt^.PrlRijweg) then
		ProcesPlanPunt^.TriggerPunt := ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein^.TriggerMeetpunt
	else
		ProcesPlanPunt^.TriggerPunt := nil;
end;

function TProcesPlan.ProbeerPlanpuntUitTeVoeren;
var
	PrlRijweg: PvPrlRijweg;
	TreinIsEr: boolean;
begin
	result := false;
	UpdatePlanpunt(ProcesPlanPunt);
	// Eerst eens kijken of de juiste trein op de juiste plaats staat.
	// WaarNietPunt is de eerste plaats waar we kijken. Daar mag geen andere trein staan.
	TreinIsEr := false;
	if assigned(ProcesPlanPunt^.TNVVan) then begin
		if (ProcesPlanPunt^.TNVVan^.treinnummer <> '') then
			if (ProcesPlanPunt^.TNVVan^.treinnummer = ProcesPlanPunt^.Treinnr) then
				TreinIsEr := true
			else
				// We doen niks als nog een andere trein in de weg staat.
				exit;
	end;
	// Kijk - indien nodig - op WaarWelPunt.
	if (not TreinIsEr) and assigned(ProcesPlanPunt^.TriggerPunt) then
		TreinIsEr := ProcesPlanPunt^.TriggerPunt^.treinnummer = ProcesPlanPunt^.Treinnr;
	// We doen niks als de trein niet aanwezig is.
	if not TreinIsEr then exit;

	// Okee, alle checks zijn positief verlopen. We proberen de rijweg in te stellen.
	// Er zijn twee strategieen. Ofwel we mogen een deelrijweg instellen, ofwel
	// we moeten alles in een keer doen. Dat zijn heel verschillende dingen.
	PrlRijweg := ZoekPrlRijweg(Core, ProcesPlanPunt^.van, ProcesPlanPunt^.naar, ProcesPlanPunt^.Dwang);
	if not assigned(PrlRijweg) then
		exit;
	if RijwegLogica.StelPrlRijwegIn(PrlRijweg, ProcesPlanPunt^.ROZ,
		ProcesPlanPunt^.gefaseerd, ProcesPlanPunt^.Dwang) then
		result := true
	else
		if ProcesPlanPunt^.gefaseerd and
			(RijwegLogica.Prl_IngesteldTot <> '') then
			// Procesplanpunt opdelen en bijwerken
			MarkeerKlaar(SplitsPunt(ProcesPlanPunt, RijwegLogica.Prl_IngesteldTot));
end;

procedure TProcesPlan.MarkeerKlaar;
var
	tmpPPP: PvProcesPlanPunt;
begin
	// Haal het punt uit de pending-lijst
	if ProcesPlanPuntenPending = ProcesPlanPunt then
		ProcesPlanPuntenPending := ProcesPlanPunt^.Volgende
	else begin
		tmpPPP := ProcesPlanPuntenPending;
		while assigned(tmpPPP) do begin
			if tmpPPP^.Volgende = ProcesPlanPunt then begin
				tmpPPP^.Volgende := ProcesPlanPunt^.Volgende;
				break;
			end;
			tmpPPP := tmpPPP^.Volgende;
		end;
	end;
	// Voeg het punt aan de klaar-lijst toe
	ProcesPlanPunt^.Volgende := ProcesPlanPuntenKlaar;
	ProcesPlanPuntenKlaar := ProcesPlanPunt;
	inc(KlaarAantal);
end;

procedure TProcesPlan.DoeStapje;
var
	ProcesPlanPunt,
	tmpPPP: 						PvProcesPlanPunt;
	TijdBereikt: 				boolean;
	DoorkomstNietVerlopen: 	boolean;
	VertrekNietVerlopen:		boolean;
	klaar:						boolean;
begin
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		TijdBereikt := (GetTijd >= ProcesPlanPunt^.Insteltijd);
		DoorkomstNietVerlopen := ((ProcesPlanPunt^.ActiviteitSoort <> asDoorkomst) or
		(GetTijd <= ProcesPlanPunt^.Insteltijd+MkTijd(0,DoorkomstRijwegMaxWacht, 0)));
		VertrekNietVerlopen := ((ProcesPlanPunt^.ActiviteitSoort <> asVertrek) or
		(GetTijd <= ProcesPlanPunt^.Insteltijd+MkTijd(0,DoorkomstRijwegMaxWacht, 59)));
		klaar := false;
		if TijdBereikt and DoorkomstNietVerlopen and VertrekNietVerlopen and
			ProcesPlanPunt^.ARI_toegestaan then begin
			// Dit is een procesplanpunt waarvoor we iets moeten doen.
			klaar := ProbeerPlanpuntUitTeVoeren(ProcesPlanPunt);
		end;
		if not klaar then
			ProcesPlanPunt := ProcesPlanPunt^.Volgende
		else begin
			tmpPPP := ProcesPlanPunt^.Volgende;
			MarkeerKlaar(ProcesPlanPunt);
			ProcesPlanPunt := tmpPPP;
		end;
	end;
end;

procedure TProcesPlan.TreinnummerNieuw;
var
	ProcesPlanPunt: PvProcesPlanPunt;
begin
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		if (Meetpunt^.meetpuntID = ProcesPlanPunt^.naar) and
			(Meetpunt^.treinnummer = ProcesPlanPunt^.Treinnr) and
			(ProcesPlanPunt^.NieuwNummer <> '') and
			(not ProcesPlanPunt^.NieuwNummerGedaan) then begin
			SendMsg.SendSetTreinnr(Meetpunt, ProcesPlanPunt^.NieuwNummer);
			ProcesPlanPunt^.NieuwNummerGedaan := true;
		end;
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
end;

procedure TProcesPlan.TreinnummerWeg;
var
	ProcesPlanPunt: PvProcesPlanPunt;
begin
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		if (Meetpunt^.meetpuntID = ProcesPlanPunt^.van) and
			(Meetpunt^.bezet) and
			(ProcesPlanPunt^.RestNummer <> '') and
			(not ProcesPlanPunt^.RestNummerGedaan) then begin
			SendMsg.SendSetTreinnr(Meetpunt, ProcesPlanPunt^.RestNummer);
			ProcesPlanPunt^.RestNummerGedaan := true;
		end;
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
end;

procedure TProcesPlan.LaadProcesplan;
const
	ws = [#9, ' '];
var
	f: text;
	s, us, ms: string;
	u, m: integer;
	waarde: string;
	index: integer;
	p: integer;
	code: integer;
	tmpPPP,
	PPP:		PvProcesPlanPunt;
	i: integer;
begin
	Assign(f, filename);
	{$I-}Reset(f);{$I+}
	if ioresult <> 0 then exit;
	while not eof(f) do begin
		index := 0;
		readln(f, s);
		if copy(s,1,1)<>'#' then begin
			new(PPP);
			PPP^.Treinnr := '';
			PPP^.ActiviteitSoort := asDoorkomst;
			PPP^.Plantijd := -1;
			PPP^.Insteltijd := -1;
			PPP^.van := '';
			PPP^.naar := '';
			PPP^.dwang := 0;
			PPP^.ROZ := false;
			PPP^.gefaseerd := false;
			PPP^.ARI_toegestaan := true;
			PPP^.NieuwNummer := '';
			PPP^.NieuwNummerGedaan := false;
			PPP^.RestNummer := '';
			PPP^.RestNummerGedaan := false;
			PPP^.TNVVan := nil;
			PPP^.TriggerPunt := nil;
			PPP^.PrlRijweg := nil;
			PPP^.Volgende := nil;
			if not assigned(ProcesPlanPuntenPending) then
				ProcesPlanPuntenPending := PPP
			else begin
				tmpPPP := ProcesPlanPuntenPending;
				while assigned(tmpPPP^.Volgende) do
					tmpPPP := tmpPPP^.Volgende;
				tmpPPP^.Volgende := PPP;
			end;
			while s <> '' do begin
				// Whitespace van het begin schrappen.
				while s[1] in ws do
					s := copy(s, 2, length(s)-1);
				p := 1;
				while (p <= length(s)) and not(s[p] in ws) do
					inc(p);
				waarde := copy(s, 1, p-1);
				s := copy(s, p+1, length(s)-p);
				case index of
					0: PPP^.Treinnr := Waarde;
					1:	if waarde <> '' then begin
						case waarde[1] of
						'd','D': PPP^.ActiviteitSoort := asDoorkomst;
						'v','V': PPP^.ActiviteitSoort := asVertrek;
						'a','A': PPP^.ActiviteitSoort := asAankomst;
						'k','K': PPP^.ActiviteitSoort := asKortestop;
						else
							PPP^.ActiviteitSoort := asNul;
						end;
					end;
					2: begin
						p := pos(':', waarde);
						us := copy(waarde,1,p-1);
						ms := copy(waarde, p+1, length(waarde)-p);
						val(us, u, code); if code <> 0 then halt;
						val(ms, m, code); if code <> 0 then halt;
						PPP^.Plantijd := MkTijd(u, m, 0);
					end;
					3: begin
						p := pos(':', waarde);
						us := copy(waarde,1,p-1);
						ms := copy(waarde, p+1, length(waarde)-p);
						val(us, u, code); if code <> 0 then halt;
						val(ms, m, code); if code <> 0 then halt;
						PPP^.Insteltijd := MkTijd(u, m, 0);
					end;
					4:	PPP^.van := waarde;
					5:	PPP^.naar := waarde;
					6: PPP^.gefaseerd := (waarde = 'j') or (waarde = 'J');
					7: if waarde <> '-' then PPP^.NieuwNummer := waarde;
					8: if waarde <> '-' then PPP^.RestNummer := waarde;
					9: for i := 1 to length(waarde) do begin
							if waarde[i] = 'Z' then
								PPP^.ROZ := true;
						end;
					else
						halt;
				end;
				inc(index);
			end; // while s <> ''
		end;
	end;
	closefile(f);

	Sorteer;
end;

procedure TProcesPlan.Sorteer;
begin
	ProcesPlanPuntenPending := Sort_List(ProcesPlanPuntenPending);
end;

end.
