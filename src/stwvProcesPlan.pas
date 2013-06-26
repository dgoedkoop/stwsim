unit stwvProcesplan;

interface

uses stwvHokjes, stwvRijwegen, stwvRijwegLogica, stwpTijd, stwvCore,
	stwvMeetpunt, stwvRijVeiligheid, clientSendMsg, stwvLog;

const
	DoorkomstRijwegMaxWacht	= 10;
	VertrekRijwegMaxWacht   = 5;

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
		AnalyseGedaan:		boolean;
		TNVVan:				PvMeetpunt;
		TriggerPunt:		PvMeetpunt;
		PrlRijweg:			PvPrlRijweg;
	end;

	TProcesPlan = class
	private
		// Een lock die ervoor zorgt dat nooit twee ProbeerPlanpuntUitTeVoeren
		// daadwerkelijk iets aan het veranderen zijn. De tweede aanroep zal
		// 'false' retourneren.
		Lock: Boolean;
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

function ActiviteitSoortStr(ActiviteitSoort: TActiviteitSoort): string;

implementation

function ActiviteitSoortStr;
begin
	case ActiviteitSoort of
	asDoorkomst: result := 'D';
	asVertrek:	 result := 'V';
	asAankomst:	 result := 'A';
	asKortestop: result := 'K';
	asNul:		 result := '*';
	end;
end;

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
	EentjeTerugRijweg:PvRijweg;
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
	NieuwPunt^.AnalyseGedaan := false;
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
	EentjeTerugRijweg := nil;
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
			EentjeTerugRijweg := RijwegL1^.Rijweg;
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
			inc(Dwang)
	until OK or (Dwang = 11);
	if not OK then
		Dwang := 0;
	// En de gegevens bijwerken
	ProcesPlanPunt^.van := Splitsspoor;
	ProcesPlanPunt^.dwang := Dwang;
	ProcesPlanPunt^.AnalyseGedaan := false;
	UpdatePlanpunt(ProcesPlanPunt);
	// Als triggerpunt stellen we het van-punt van de laatste reeds uitgevoerde
	// rijweg in zodat dit laatste stuk indien mogelijk vroeg genoeg wordt
	// ingesteld dat de trein niet met gele signalen te maken krijgt.
	if assigned(EentjeTerugRijweg) then
		if assigned(EentjeTerugRijweg^.Sein) then
			ProcesPlanPunt^.TriggerPunt := EentjeTerugRijweg^.Sein^.VanTNVMeetpunt;

	Log.Log('Procesplan: Regel aangepast: trein '+ProcesPlanPunt^.Treinnr+
	' moet verder van spoor '+ProcesPlanPunt^.van+' naar spoor '+ProcesPlanPunt^.naar);

	result := NieuwPunt;
end;

constructor TProcesPlan.Create;
begin
	inherited;
	Lock := false;
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
	if ProcesPlanPunt^.AnalyseGedaan then
		exit;

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

	ProcesPlanPunt^.AnalyseGedaan := true;
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
	// Kijk - indien nodig - op TriggerPunt.
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
	if Lock then exit;
	Lock := true;
	if RijwegLogica.StelPrlRijwegIn(PrlRijweg, ProcesPlanPunt^.ROZ,
		ProcesPlanPunt^.gefaseerd, ProcesPlanPunt^.Dwang) then
		result := true
	else
		if ProcesPlanPunt^.gefaseerd and
			(RijwegLogica.Prl_IngesteldTot <> '') then
			// Procesplanpunt opdelen en bijwerken
			MarkeerKlaar(SplitsPunt(ProcesPlanPunt, RijwegLogica.Prl_IngesteldTot));
	Lock := false;
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
	DoorkomstVerlopen: 		boolean;
	VertrekVerlopen:			boolean;
	klaar:						boolean;
begin
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		klaar := false;
		if ProcesPlanPunt^.ARI_toegestaan then begin
			TijdBereikt := (GetTijd >= ProcesPlanPunt^.Insteltijd);
			DoorkomstVerlopen := ((ProcesPlanPunt^.ActiviteitSoort = asDoorkomst) and
			(GetTijd > ProcesPlanPunt^.Insteltijd+MkTijd(0,DoorkomstRijwegMaxWacht, 0)));
			VertrekVerlopen := ((ProcesPlanPunt^.ActiviteitSoort = asVertrek) and
			(GetTijd > ProcesPlanPunt^.Insteltijd+MkTijd(0,VertrekRijwegMaxWacht, 59)));
			if TijdBereikt then
				if VertrekVerlopen or DoorkomstVerlopen then begin
					ProcesPlanPunt^.ARI_toegestaan := false;
					Log.Log(ProcesPlanPunt^.Treinnr+' '+ActiviteitSoortStr(ProcesPlanPunt^.ActiviteitSoort)+' uitgezet voor ARI; vertraging te groot.');
				end else
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
			PPP^.AnalyseGedaan := false;
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
