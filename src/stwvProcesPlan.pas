unit stwvProcesplan;

interface

uses sysutils, stwvHokjes, stwvRijwegen, stwvRijwegLogica, stwpTijd, stwvCore,
	stwvMeetpunt, stwvTreinInfo, stwvRijVeiligheid, clientSendMsg, stwvLog,
	stwvSeinen, stwvMisc;

const
	TeVroegTijd					= 5;
	DoorkomstRijwegMaxWacht	= 10;
	VertrekRijwegMaxWacht   = 5;

type
	EProcesplanSyntaxError = class(Exception);

	TActiviteitSoort = (asDoorkomst, asVertrek, asAankomst, asKortestop, asRangeren, asNul);
	TGetriggerd = (trNiet, trGetriggerd, trAanwezig, trAndereInDeWeg);

	TInstelResultaat = (irNiets, irInBehandeling, irDeels, irHelemaal);
	TVolgordeOK = (voOK, voAnderSpoor, voZelfdeSpoor);

	PvProcesPlanPunt = ^TvProcesPlanPunt;
	TvProcesPlanPunt = record
		// Statische informatie
		Treinnr:		  		String;	// Welke trein?
		ActiviteitSoort:	TActiviteitSoort;	// Wat gaan we doen?
		Plantijd:			integer;	// Wanneer bereikt de trein deze rijweg?
		Insteltijd:			integer;	// Wanneer moet de rijweg ingesteld worden?
		van, naar:			string;	// Klikpuntstring (met r of s ervoor)
		dwang:				byte;		// 0=geen dwang
		ROZ:					boolean;	// Moeten we ROZ instellen?
		H:						boolean; // Vertrekregel moet met hoog groen worden ingesteld
		// Onderstaande valt allemaal onder Bijzondere Informatie //
		ARI_toegestaan:	boolean;
		NieuwNummer:		string;	// De trein krijgt een nieuw nummer bij aankomst
		NieuwNummerGedaan:boolean;
		RestNummer:			string;	// Een achtergebleven, afgekoppeld treindeel
											// krijgt dit nummer bij vertrek van het andere
											// treindeel.
      CombineerNummer:	string;
		// Voor de volgorde
		VolgordeOK:			TVolgordeOK;
		RestNummerGedaan:	boolean;

		Volgende:			PvProcesPlanPunt;

		// Vertragingsinfo
		GemetenVertraging:		integer;
		GemetenVertragingSoort: TVertragingSoort;
		GemetenVertragingPlaats:string;
		VerwerkteVertraging:		integer;
		VertragingTNVPos:			PvMeetpunt;	// Bij deelrijwegen kan <> TNVNaar
		VertragingTNVPosHandm:	boolean;		// VertragingTNVPos niet autom. bijw.
		// Dynamische informatie
		InBehandeling:		boolean;
		Bewerkt:				boolean;
		AnalyseGedaan:		boolean;
		Getriggerd:			TGetriggerd;
		TNVVan:				PvMeetpunt;
		TNVNaar:				PvMeetpunt;
		TriggerPunt:		PvMeetpunt;
		PrlRijweg:			PvPrlRijweg;
	end;

	TProcesPlan = class
	private
		// Een lock die ervoor zorgt dat nooit twee ProbeerPlanpuntUitTeVoeren
		// daadwerkelijk iets aan het veranderen zijn. De tweede aanroep zal
		// 'false' retourneren.
		Lock: Boolean;
		TreinnrAfgehandeld: boolean;
		function SplitsPunt(ProcesPlanPunt: PvProcesPlanPunt; Splitsspoor: string): PvProcesPlanPunt;
		function Sort_Merge(links, rechts: PvProcesPlanPunt): PvProcesPlanPunt;
		function Sort_List(PPP: PvProcesPlanPunt): PvProcesPlanPunt;
	public
		ARI: Boolean;
		ProcesPlanPuntenKlaar:		PvProcesPlanPunt;
		KlaarAantal:					integer;
		ProcesPlanPuntenPending:	PvProcesPlanPunt;
		Gewijzigd:						boolean;
		Locatienaam:					string;
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
		procedure UpdateVolgordeVoorPunt(ProcesPlanPunt: PvProcesPlanPunt);
		procedure UpdateVolgordeAfhVanPunt(ProcesPlanPunt: PvProcesPlanPunt);
		procedure UpdateVolgordes;
		procedure MarkeerOudeKlaar;
		procedure SavePlanpunt(var f: file; ProcesPlanPunt: PvProcesPlanPunt; SaveVertraging: boolean);
		procedure LoadPlanpunt(var f: file; SgVersion: integer; ProcesPlanPunt: PvProcesPlanPunt; LoadVertraging: boolean);
		// Extern
		procedure LaadProcesplan(filename: string);
		procedure Sorteer;
		procedure LoadBinair(var f: file; SgVersion: integer);
		procedure SaveBinair(var f: file);
		// Gebeurtenissen
		function IsTreinAanwezig(ProcesPlanPunt: PvProcesPlanPunt; strikt: boolean): boolean;
      function ControleerCombineerTrein(ProcesPlanPunt: PvProcesPlanPunt): boolean;
		function ProbeerPlanpuntUitTeVoeren(ProcesPlanPunt: PvProcesPlanPunt; CheckVolgorde: boolean): TInstelResultaat;
		function ControleerTijdvenster(ProcesPlanPunt: PvProcesPlanPunt): boolean;
		function NeemInBehandeling(ProcesPlanPunt: PvProcesPlanPunt): boolean;
		function HandelPlanregelAf(ProcesPlanPunt: PvProcesPlanPunt): TInstelResultaat;
		procedure DoeStapje;
		function TreinIsAfgehandeld: boolean;
		procedure TreinnummerNieuw(Meetpunt: PvMeetpunt);
		procedure TreinnummerWeg(Meetpunt: PvMeetpunt);
		procedure TreinInfo(TreinInfoData: TvTreinInfo);
		procedure RegelsKlaarBijwerken(OudeTriggerTNV, NieuweTriggerTNV: PvMeetpunt);
		function MagHandmatigUitvoeren(ProcesPlanPunt: PvProcesPlanPunt): boolean;
	end;

const
	AsVertragingBijEersteSein = [asVertrek, asDoorkomst, asKortestop];
	AsVertragingBijLaatsteSein = [asAankomst];

function ActiviteitSoortStr(ActiviteitSoort: TActiviteitSoort): string;

implementation

function ActiviteitSoortStr;
begin
	case ActiviteitSoort of
	asDoorkomst: result := 'D';
	asVertrek:	 result := 'V';
	asAankomst:	 result := 'A';
	asKortestop: result := 'K';
	asRangeren:  result := 'R';
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

procedure TProcesPlan.RegelsKlaarBijwerken(OudeTriggerTNV, NieuweTriggerTNV: PvMeetpunt);
var
	PPP: PvProcesPlanPunt;
begin
	if not assigned(OudeTriggerTNV) then exit;
	PPP := ProcesPlanPuntenKlaar;
	while assigned(PPP) do begin
		if (PPP^.VertragingTNVPos = OudeTriggerTNV) and PPP^.VertragingTNVPosHandm then
			PPP^.VertragingTNVPos := NieuweTriggerTNV;
		PPP := PPP^.Volgende;
	end;
end;

function TProcesPlan.MagHandmatigUitvoeren;
begin
	result := not (ProcesPlanPunt^.ARI_toegestaan and ProcesPlanPunt^.InBehandeling)
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
	// Gegevens nieuwe procesplanpunt instellen (dat is het deel dat al is
   // afgehandeld).
	new(NieuwPunt);
	NieuwPunt^.Treinnr := ProcesPlanPunt^.Treinnr;
	NieuwPunt^.ActiviteitSoort := ProcesPlanPunt^.ActiviteitSoort;
	NieuwPunt^.Plantijd := ProcesPlanPunt^.Plantijd;
	NieuwPunt^.Insteltijd := ProcesPlanPunt^.Insteltijd;
	NieuwPunt^.van := ProcesPlanPunt^.van;
	NieuwPunt^.dwang := ProcesPlanPunt^.dwang;
	NieuwPunt^.ARI_toegestaan := ProcesPlanPunt^.ARI_toegestaan;
	NieuwPunt^.H := ProcesPlanPunt^.H;
	NieuwPunt^.NieuwNummer := '';
	NieuwPunt^.NieuwNummerGedaan := false;
	NieuwPunt^.RestNummer := '';
	NieuwPunt^.RestNummerGedaan := false;
   NieuwPunt^.CombineerNummer := '';
	NieuwPunt^.AnalyseGedaan := false;
	NieuwPunt^.InBehandeling := false;
	NieuwPunt^.Bewerkt := false;
	// Bij het splitsen slaan we in NieuwePunt (dus het eerste deel van de
	// rijweg) het sein op, en later ook in het oude planpunt (het tweede deel
	// van de rijweg). Nadat het eerste deel van de rijweg wordt afgereden zijn
	// er twee opties. Of het tweede deel is dan intussen ook al ingesteld en
	// wordt dan dus ook voor bijwerking getriggerd. Of het tweede deel is nog
	// niet ingesteld, maar dan wordt via de vertragingsmeting de vertraging aan
	// dat planpunt doorgegeven.
	NieuwPunt^.GemetenVertraging := ProcesPlanPunt^.GemetenVertraging;
	NieuwPunt^.GemetenVertragingSoort := ProcesPlanPunt^.GemetenVertragingSoort;
	NieuwPunt^.GemetenVertragingPlaats := ProcesPlanPunt^.GemetenVertragingPlaats;
	NieuwPunt^.VerwerkteVertraging := ProcesPlanPunt^.VerwerkteVertraging;
	NieuwPunt^.VertragingTNVPos := ProcesPlanPunt^.VertragingTNVPos;
	NieuwPunt^.VertragingTNVPosHandm := ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijLaatsteSein;
	NieuwPunt^.TNVVan := nil;
	NieuwPunt^.TNVNaar := nil;
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
			inc(Dwang)
	until OK or (Dwang = 11);
	if not OK then
		Dwang := 0;
	// En de gegevens bijwerken
	ProcesPlanPunt^.van := Splitsspoor;
	ProcesPlanPunt^.dwang := Dwang;
	ProcesPlanPunt^.AnalyseGedaan := false;
	ProcesPlanPunt^.VertragingTNVPosHandm := ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijEersteSein;
	UpdatePlanpunt(ProcesPlanPunt);

	Log.Log('Procesplan: Regel aangepast: trein '+ProcesPlanPunt^.Treinnr+
	' moet verder van spoor '+ProcesPlanPunt^.van+' naar spoor '+ProcesPlanPunt^.naar);

	result := NieuwPunt;
end;

constructor TProcesPlan.Create;
begin
	inherited;
	Lock := false;
	ARI := true;
	ProcesPlanPuntenPending := nil;
	ProcesPlanPuntenKlaar := nil;
	Gewijzigd := false;
	KlaarAantal := 0;
	Locatienaam := '';
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
var
	RijwegL: PvRijwegLijst;
	OudeTNVNaar: PvMeetpunt;
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

	// Zoek het tnv-naar-punt
	OudeTNVNaar := ProcesPlanPunt^.TNVNaar;
	if assigned(ProcesPlanPunt^.PrlRijweg) then begin
		RijwegL := ProcesPlanPunt^.PrlRijweg^.Rijwegen;
		if assigned(RijwegL) then begin
			while assigned(RijwegL^.Volgende) do
				RijwegL := RijwegL^.Volgende;
			ProcesPlanPunt^.TNVNaar := RijwegL^.Rijweg^.NaarTNVMeetpunt
		end else
			ProcesPlanPunt^.TNVNaar := nil;
	end else
		ProcesPlanPunt^.TNVNaar := nil;
	if OudeTNVNaar <> ProcesPlanPunt^.TNVNaar then
		RegelsKlaarBijwerken(OudeTNVNaar, ProcesPlanPunt^.TNVNaar);

	// Zoek het tnv-trigger-punt
	if assigned(ProcesPlanPunt^.PrlRijweg) then
		ProcesPlanPunt^.TriggerPunt := ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein^.TriggerMeetpunt
	else
		ProcesPlanPunt^.TriggerPunt := nil;

	ProcesPlanPunt^.AnalyseGedaan := true;
	Gewijzigd := true;
end;

procedure TProcesPlan.UpdateVolgordeVoorPunt;
var
	tmpPlanPunt: PvProcesPlanPunt;
begin
	ProcesPlanPunt^.VolgordeOK := voOK;
	// We kijken of er niet nog andere, eerdere planpunten zijn van hetzelfde
	// bronspoor of naar hetzelfde doelspoor etc.
	tmpPlanPunt := ProcesPlanPuntenPending;
	while assigned(tmpPlanPunt) do begin
		if (tmpPlanPunt^.Insteltijd < ProcesPlanPunt^.Insteltijd) and
			((tmpPlanPunt^.naar = ProcesPlanPunt^.naar) or
			 (tmpPlanPunt^.Treinnr = ProcesPlanPunt^.Treinnr))then begin
			if tmpPlanPunt^.van = ProcesPlanPunt^.van then
				ProcesPlanPunt^.VolgordeOK := voZelfdeSpoor
			else
				ProcesPlanPunt^.VolgordeOK := voAnderSpoor;
			break;
		end;
		tmpPlanPunt := tmpPlanPunt^.Volgende;
	end;
end;

procedure TProcesPlan.UpdateVolgordes;
var
	ProcesPlanPunt: PvProcesPlanPunt;
begin
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		UpdateVolgordeVoorPunt(ProcesPlanPunt);
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
end;

procedure TProcesPlan.UpdateVolgordeAfhVanPunt;
var
	tmpPlanPunt: PvProcesPlanPunt;
begin
	tmpPlanPunt := ProcesPlanPuntenPending;
	while assigned(tmpPlanPunt) do begin
		if (ProcesPlanPunt^.Insteltijd < tmpPlanPunt^.Insteltijd) and
			(tmpPlanPunt^.VolgordeOK = voOK) then
			UpdateVolgordeVoorPunt(tmpPlanPunt)
		else if tmpPlanPunt^.VolgordeOK <> voOK then
			UpdateVolgordeVoorPunt(tmpPlanPunt);
		tmpPlanPunt := tmpPlanPunt^.Volgende;
	end;
end;

procedure TProcesPlan.MarkeerOudeKlaar;
var
	ProcesPlanPunt: PvProcesPlanPunt;
	tmpVolgende: PvProcesPlanPunt;
	u,m,s: integer;
begin
	FmtTijd(GetTijd,u,m,s);
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		if ProcesPlanPunt^.Insteltijd < MkTijd(u,m,0) then begin
			tmpVolgende := ProcesPlanPunt^.Volgende;
			MarkeerKlaar(ProcesPlanPunt);
			ProcesPlanPunt := tmpVolgende;
		end else
			ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
end;

function TProcesPlan.IsTreinAanwezig;
var
	ActieveRijweg: PvActieveRijwegLijst;
begin
	UpdatePlanpunt(ProcesPlanPunt);

	(* NOOT:
	Wat niet helemaal goed wordt afgevangen zijn situaties met seinen op verkorte
	remwegafstand waarbij het triggerpunt en het TNV-van-punt niet direct op
	elkaar volgen. Stel nu dus, we hebben de volgende situatie:

	<trein A> | <trein B> | <leeg baanvak> | <doelspoor>
	 ^trigger                ^tnv-van         ^tnv-naar

	In deze situatie is trein B getriggerd, maar kan niet worden opgemerkt. Staat
	dus trein A in het procesplan eerder genoemd dan trein B (en rijden ze in de
	verkeerde volgorde) dan wordt niet, zoals de bedoeling is, helemaal geen
	rijweg ingesteld, maar krijgt in plaats daarvan trein B de rijweg van trein
	A ingesteld.
	Met een echt juiste TNV-implementatie zou dit probleem zich niet voordoen,
	dus voor nu moet dit maar goed genoeg zijn.
	*)

	if assigned(ProcesPlanPunt^.TNVVan) then begin
		if (ProcesPlanPunt^.TNVVan^.treinnummer = ProcesPlanPunt^.Treinnr) then
			ProcesPlanPunt^.Getriggerd := trAanwezig;
		if (ProcesPlanPunt^.TNVVan^.treinnummer = '') and
			(ProcesPlanPunt^.Getriggerd in [trAanwezig, trAndereInDeWeg]) then
			// Als eerst de juiste trein aanwezig was, maar nu helemaal geen trein
			// dan moeten we de trigger weer uitschakelen.
			// En als eerst een foute trein aanwezig was, maar nu helemaal geen
			// trein, dan moeten we de trigger ook weer resetten.
			ProcesPlanPunt^.Getriggerd := trNiet
	end;

	// Kijk - indien nodig - op TriggerPunt.
	if (ProcesPlanPunt^.Getriggerd = trNiet) and assigned(ProcesPlanPunt^.TriggerPunt) and
		(ProcesPlanPunt^.TriggerPunt^.treinnummer = ProcesPlanPunt^.Treinnr) then
		ProcesPlanPunt^.Getriggerd := trGetriggerd;
	// Of misschien is er wel een rijweg naar dit sein ingesteld? We willen
	// immers met hoog groen door een emplacement als het even kan.
	if (ProcesPlanPunt^.Getriggerd = trNiet) and assigned(ProcesPlanPunt^.PrlRijweg) then
		if assigned(ProcesPlanPunt^.PrlRijweg^.Rijwegen) then
			if assigned(ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg) then
				if assigned(ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein) then
					if assigned(ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein^.DoelVanRijweg) then begin
						ActieveRijweg := ProcesPlanPunt^.PrlRijweg^.Rijwegen^.Rijweg^.Sein^.DoelVanRijweg;
						if (ActieveRijweg^.Pending = 2) and assigned(ActieveRijweg^.Rijweg^.Sein^.VanTNVMeetpunt) then
							if (ActieveRijweg^.Rijweg^.Sein^.VanTNVMeetpunt^.treinnummer = ProcesPlanPunt^.Treinnr) then
								ProcesPlanPunt^.Getriggerd := trAanwezig
					end;

	// Als de gezochte trein aanwezig is, wel even kijken of niet een andere
	// trein in de weg staat.
	if assigned(ProcesPlanPunt^.TNVVan) and
	(ProcesPlanPunt^.Getriggerd in [trAanwezig, trGetriggerd]) then
	if (ProcesPlanPunt^.TNVVan^.treinnummer <> '') and
		(ProcesPlanPunt^.TNVVan^.treinnummer <> ProcesPlanPunt^.Treinnr) then
		ProcesPlanPunt^.Getriggerd := trAndereInDeWeg;

	if strikt then
		result := ProcesPlanPunt^.Getriggerd in [trGetriggerd, trAanwezig]
	else
		result := ProcesPlanPunt^.Getriggerd in [trGetriggerd, trAanwezig, trAndereInDeWeg];
end;

function TProcesPlan.ControleerCombineerTrein;
begin
   if ProcesPlanPunt^.CombineerNummer <> '' then
   	if assigned(ProcesPlanPunt^.TNVNaar) then
      	result := ProcesPlanPunt^.TNVNaar.treinnummer =
	         ProcesPlanPunt^.CombineerNummer
      else
      	// Laten we alles fail-safe doen.
      	result := false
   else
   	result := true;
end;

function TProcesPlan.ProbeerPlanpuntUitTeVoeren;
var
	PrlRijweg: PvPrlRijweg;
	PPP: PvProcesPlanPunt;
   ROZ: Boolean;
begin
	if ProcesPlanPunt^.InBehandeling then
		result := irInBehandeling
	else
		result := irNiets;

	// Strikte check of de trein aanwezig is
	if not IsTreinAanwezig(ProcesPlanPunt, true) then exit;

   // Als we gaan combineren, maar de trein waarmee gecombineerd moet worden is
   // er nog niet, dan moeten we nog even niks doen.
   if not ControleerCombineerTrein(ProcesPlanPunt) then
      exit;

	// Controleer ook de volgorde.
	if CheckVolgorde and (ProcesPlanPunt^.VolgordeOK <> voOK) then exit;

   // Hulpvariabele voor rijden op zicht goed instellen.
   ROZ := ProcesPlanPunt^.ROZ or (ProcesPlanPunt^.CombineerNummer <> '');

	// Okee, alle checks zijn positief verlopen. We proberen de rijweg in te stellen.
	PrlRijweg := ZoekPrlRijweg(Core, ProcesPlanPunt^.van, ProcesPlanPunt^.naar, ProcesPlanPunt^.Dwang);
	if not assigned(PrlRijweg) then
		exit;
	if Lock then exit;
	Lock := true;
	if RijwegLogica.StelPrlRijwegIn(PrlRijweg, ROZ, ProcesPlanPunt^.Dwang) then begin
		if not ProcesPlanPunt^.VertragingTNVPosHandm then begin
			if ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijEersteSein then
				ProcesPlanPunt^.VertragingTNVPos := RijwegLogica.Prl_EersteTNVStap;
			if ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijLaatsteSein then
				ProcesPlanPunt^.VertragingTNVPos := ProcesPlanPunt^.TNVNaar;
		end;
		result := irHelemaal
	end else
		if RijwegLogica.Prl_IngesteldTot <> '' then begin
			// Procesplanpunt opdelen en bijwerken
			if not ProcesPlanPunt^.VertragingTNVPosHandm then begin
				if ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijEersteSein then
					ProcesPlanPunt^.VertragingTNVPos := RijwegLogica.Prl_EersteTNVStap;
				if ProcesPlanPunt^.ActiviteitSoort in AsVertragingBijLaatsteSein then
					ProcesPlanPunt^.VertragingTNVPos := ProcesPlanPunt^.TNVNaar;
			end;
			PPP := SplitsPunt(ProcesPlanPunt, RijwegLogica.Prl_IngesteldTot);
			MarkeerKlaar(PPP);
			result := irDeels
		end;
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

	// En volgordes aanpassen.
	UpdateVolgordeAfhVanPunt(ProcesPlanPunt);

	Gewijzigd := true;
end;

function TProcesPlan.ControleerTijdvenster;
var
	DoorkomstVerlopen: 		boolean;
	VertrekVerlopen:			boolean;
	TeVroeg:						boolean;
	Aanwezig:					boolean;
begin
	if not ProcesPlanPunt^.ARI_toegestaan then begin
		result := true;
		exit;
	end;
	TeVroeg := (ProcesPlanPunt^.ActiviteitSoort in [asAankomst,asDoorkomst,asKorteStop]) and
		(GetTijd < ProcesPlanPunt^.Insteltijd-MkTijd(0,TeVroegTijd, 0));
	DoorkomstVerlopen := (ProcesPlanPunt^.ActiviteitSoort = asDoorkomst) and
		(GetTijd > ProcesPlanPunt^.Insteltijd+MkTijd(0,DoorkomstRijwegMaxWacht, 0));
	VertrekVerlopen := (ProcesPlanPunt^.ActiviteitSoort = asVertrek) and
		(GetTijd > ProcesPlanPunt^.Insteltijd+MkTijd(0,VertrekRijwegMaxWacht, 59));
	Aanwezig := IsTreinAanwezig(ProcesPlanPunt, false) and ControleerCombineerTrein(ProcesPlanPunt);
	if Aanwezig and TeVroeg then begin
		ProcesPlanPunt^.ARI_toegestaan := false;
		Log.Log(Locatienaam + ' ' + ProcesPlanPunt^.Treinnr+' '+ActiviteitSoortStr(ProcesPlanPunt^.ActiviteitSoort)+' uitgezet voor ARI; aankondiging te vroeg.');
		result := false
	end else if (not Aanwezig) and (DoorkomstVerlopen or VertrekVerlopen) then begin
		ProcesPlanPunt^.ARI_toegestaan := false;
		Log.Log(Locatienaam + ' ' + ProcesPlanPunt^.Treinnr+' '+ActiviteitSoortStr(ProcesPlanPunt^.ActiviteitSoort)+' uitgezet voor ARI; vertraging te groot.');
		result := false
	end else
		result := true;
end;

function TProcesPlan.NeemInBehandeling;
var
	TijdvensterOK: boolean;
begin
	if ProcesPlanPunt^.ARI_toegestaan then
		if ProcesPlanPunt^.InBehandeling then
			result := true
		else begin
			TijdvensterOK := ControleerTijdvenster(ProcesPlanPunt);
			if IsTreinAanwezig(ProcesPlanPunt, false) and
            ControleerCombineerTrein(ProcesPlanPunt) and
				TijdvensterOK and
				(ProcesPlanPunt^.VolgordeOK <> voZelfdeSpoor) and
				((GetTijd >= ProcesPlanPunt^.Insteltijd) or
				 ((ProcesPlanPunt^.ActiviteitSoort = asVertrek) and ProcesPlanPunt^.H) or
				 not (ProcesPlanPunt^.ActiviteitSoort in [asVertrek, asRangeren]))
				then begin
				if not ProcesPlanPunt.InBehandeling then begin
					ProcesPlanPunt.InBehandeling := true;
					Gewijzigd := true
				end;
				result := true
			end else
				result := false
		end
	else
		result := false;
end;

function TProcesPlan.HandelPlanregelAf;
begin
	result := irNiets;

	if not ProcesPlanPunt^.ARI_toegestaan then
		exit;

	if NeemInBehandeling(ProcesPlanPunt) then
		result := irInBehandeling
	else
		exit;

	if (GetTijd >= ProcesPlanPunt^.Insteltijd) or
		((ProcesPlanPunt^.ActiviteitSoort = asVertrek) and ProcesPlanPunt^.H) then
		result := ProbeerPlanpuntUitTeVoeren(ProcesPlanPunt, true)
end;

procedure TProcesPlan.DoeStapje;
var
	ProcesPlanPunt,
	tmpVolgende:				PvProcesPlanPunt;
	klaar:						TInstelResultaat;
begin
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		tmpVolgende := ProcesPlanPunt^.Volgende;
		klaar := HandelPlanregelAf(ProcesPlanPunt);
		if klaar = irHelemaal then
			MarkeerKlaar(ProcesPlanPunt);
		if (GetTijd < ProcesPlanPunt^.Insteltijd) then
			// De planregels zijn op insteltijd gesorteerd. De eerste planregel
			// met een insteltijd in de toekomst betekent dus dat we kunnen
			// stoppen.
			break;
		ProcesPlanPunt := tmpVolgende;
	end;
end;

function TProcesPlan.TreinIsAfgehandeld;
begin
	result := TreinnrAfgehandeld;
end;

procedure TProcesPlan.TreinnummerNieuw;
var
	ProcesPlanPunt: 	PvProcesPlanPunt;
	TreinInfo: 			TvTreinInfo;
	tmpVolgende:		PvProcesPlanPunt;
	klaar:				TInstelResultaat;
begin
	// Registreer vertraging
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		if (ProcesPlanPunt^.VertragingTNVPos = Meetpunt) and
			(ProcesPlanPunt^.Treinnr = Meetpunt^.treinnummer) then begin
			// Bereken vertraging
			TreinInfo.Treinnummer := ProcesPlanPunt^.Treinnr;
			TreinInfo.Vertragingsoort := vsExact;
			TreinInfo.Vertraging := GetTijd - ProcesPlanPunt^.Plantijd;
			TreinInfo.Vertragingplaats := Locatienaam;
			// Werk onszelf bij
			Gewijzigd := false;
			if (round(ProcesPlanPunt^.GemetenVertraging/MkTijd(0,1,0)) <> round(TreinInfo.Vertraging/MkTijd(0,1,0))) or
				((ProcesPlanPunt^.GemetenVertragingPlaats = '') and
				 (round(TreinInfo.Vertraging/MkTijd(0,1,0)) <> 0)) then begin
				ProcesPlanPunt^.GemetenVertragingPlaats := Locatienaam;
				Gewijzigd := true;
			end;
			ProcesPlanPunt^.GemetenVertraging := TreinInfo.Vertraging;
			if ProcesPlanPunt^.GemetenVertragingSoort <> TreinInfo.Vertragingsoort then begin
				ProcesPlanPunt^.GemetenVertragingSoort := TreinInfo.Vertragingsoort;
				Gewijzigd := true;
			end;
			// Verstuur vertraging
			SendMsg.SendVertraging(TreinInfo);
			// Deregistreren
			ProcesPlanPunt^.VertragingTNVPos := nil;
		end;
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
	// Misschien is er nog een oud planpunt dat een niet-uitgevoerde
	// omnummeropdracht voor deze trein heeft.
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		if assigned(ProcesPlanPunt^.TNVNaar) then
			if (Meetpunt^.meetpuntID = ProcesPlanPunt^.TNVNaar^.meetpuntID) and
				(Meetpunt^.treinnummer = ProcesPlanPunt^.Treinnr) and
				(ProcesPlanPunt^.NieuwNummer <> '') and
				(not ProcesPlanPunt^.NieuwNummerGedaan) then begin
				SendMsg.SendSetTreinnr(Meetpunt, ProcesPlanPunt^.NieuwNummer);
				ProcesPlanPunt^.NieuwNummerGedaan := true;
			end;
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
	// Misschien kan nu wel een nieuw planpunt worden afgehandeld.
	TreinnrAfgehandeld := false;
	if ARI then begin
		ProcesPlanPunt := ProcesPlanPuntenPending;
		while assigned(ProcesPlanPunt) do begin
			tmpVolgende := ProcesPlanPunt^.Volgende;
			if ProcesPlanPunt^.Treinnr = Meetpunt^.treinnummer then begin
				klaar := HandelPlanregelAf(ProcesPlanPunt);
				TreinnrAfgehandeld := TreinnrAfgehandeld or (klaar <> irNiets);
				if klaar = irHelemaal then
					MarkeerKlaar(ProcesPlanPunt)
			end;
			ProcesPlanPunt := tmpVolgende;
		end;
	end;
end;

procedure TProcesPlan.TreinnummerWeg;
var
	ProcesPlanPunt: PvProcesPlanPunt;
begin
	// Geef een achtergebleven treindeel een nummer als dat nodig is.
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		if assigned(ProcesPlanPunt^.TNVNaar) then
			if (Meetpunt^.meetpuntID = ProcesPlanPunt^.TNVNaar^.meetpuntID) and
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
	PPP:		PvProcesPlanPunt;
	i: integer;
begin
	PPP := nil;
	Assign(f, filename);
	{$I-}Reset(f);{$I+}
	if ioresult <> 0 then exit;
	while not eof(f) do begin
		index := 0;
		readln(f, s);
		if copy(s,1,1)<>'#' then begin
			while s <> '' do begin
				// Whitespace van het begin schrappen.
				while (s <> '') and (s[1] in ws) do
					s := copy(s, 2, length(s)-1);
				p := 1;
				while (p <= length(s)) and not(s[p] in ws) do
					inc(p);
				waarde := copy(s, 1, p-1);
				s := copy(s, p+1, length(s)-p);
				case index of
					0: if waarde <> '' then begin
							if assigned(PPP) then begin
								new(PPP^.Volgende);
								PPP := PPP^.volgende
							end else begin
								new(PPP);
								ProcesPlanPuntenPending := PPP
							end;
							PPP^.Treinnr := '';
							PPP^.ActiviteitSoort := asDoorkomst;
							PPP^.Plantijd := -1;
							PPP^.Insteltijd := -1;
							PPP^.van := '';
							PPP^.naar := '';
							PPP^.dwang := 0;
							PPP^.ROZ := false;
							PPP^.H := false;
							PPP^.ARI_toegestaan := true;
							PPP^.NieuwNummer := '';
							PPP^.NieuwNummerGedaan := false;
							PPP^.RestNummer := '';
							PPP^.RestNummerGedaan := false;
                     PPP^.CombineerNummer := '';
							PPP^.GemetenVertraging := 0;
							PPP^.GemetenVertragingSoort := vsSchatting;
							PPP^.GemetenVertragingPlaats := '';
							PPP^.VerwerkteVertraging := 0;
							PPP^.VertragingTNVPos := nil;
							PPP^.VertragingTNVPosHandm := false;
							PPP^.Bewerkt := false;
							PPP^.VolgordeOK := voOK;
							PPP^.InBehandeling := false;
							PPP^.AnalyseGedaan := false;
							PPP^.Getriggerd := trNiet;
							PPP^.TNVVan := nil;
							PPP^.TNVNaar := nil;
							PPP^.TriggerPunt := nil;
							PPP^.PrlRijweg := nil;
							PPP^.Volgende := nil;
							PPP^.Treinnr := Waarde;
						end;
					1:	if waarde <> '' then begin
						case waarde[1] of
						'd','D': PPP^.ActiviteitSoort := asDoorkomst;
						'v','V': PPP^.ActiviteitSoort := asVertrek;
						'a','A': PPP^.ActiviteitSoort := asAankomst;
						'k','K': PPP^.ActiviteitSoort := asKortestop;
						'r','R': PPP^.ActiviteitSoort := asRangeren;
						else
							PPP^.ActiviteitSoort := asNul;
						end;
					end;
					2: begin
						p := pos(':', waarde);
						us := copy(waarde,1,p-1);
						ms := copy(waarde, p+1, length(waarde)-p);
						val(us, u, code); if code <> 0 then
							raise EProcesplanSyntaxError.Create('Onjuiste tijd in procesplan: '+waarde);
						val(ms, m, code); if code <> 0 then
							raise EProcesplanSyntaxError.Create('Onjuiste tijd in procesplan: '+waarde);
						PPP^.Plantijd := MkTijd(u, m, 0);
					end;
					3: begin
						p := pos(':', waarde);
						us := copy(waarde,1,p-1);
						ms := copy(waarde, p+1, length(waarde)-p);
						val(us, u, code); if code <> 0 then
							raise EProcesplanSyntaxError.Create('Onjuiste tijd in procesplan: '+waarde);
						val(ms, m, code); if code <> 0 then
							raise EProcesplanSyntaxError.Create('Onjuiste tijd in procesplan: '+waarde);
						PPP^.Insteltijd := MkTijd(u, m, 0);
					end;
					4:	PPP^.van := waarde;
					5:	PPP^.naar := waarde;
					6: if waarde <> '-' then PPP^.NieuwNummer := waarde;
					7: if waarde <> '-' then PPP^.RestNummer := waarde;
					8: if waarde <> '-' then PPP^.CombineerNummer := waarde;
					9: for i := 1 to length(waarde) do begin
							if waarde[i] = 'Z' then
								PPP^.ROZ := true;
							if waarde[i] = 'H' then
								PPP^.H := true;
							if waarde[i] in ['0'..'9'] then
								PPP^.dwang := ord(waarde[i])-ord('0');
						end;
					else
						raise EProcesplanSyntaxError.Create('Procesplanregel heeft te veel parameters');
				end;
				inc(index);
			end; // while s <> ''
		end;
	end;
	closefile(f);

	Sorteer;
	MarkeerOudeKlaar;
end;

procedure TProcesPlan.LoadPlanpunt;
var
	x: byte;
	dummy: boolean;
	s: string;
	function ByteNaarActiviteitsoort(x: byte): TActiviteitSoort;
	begin
		case x of
			1: result := asDoorkomst;
			2: result := asVertrek;
			3: result := asAankomst;
			4: result := asKortestop;
			5: result := asRangeren;
			else result := asNul;
		end;
	end;
	function ByteNaarGetriggerd(x: byte): TGetriggerd;
	begin
		case x of
			1: result := trGetriggerd;
			2: result := trAanwezig;
			3: result := trAndereInDeWeg;
			else result := trNiet;
		end;
	end;
	function ByteNaarVertragingSoort(x: byte): TVertragingSoort;
	begin
		case x of
			1: result := vsExact;
			2: result := vsSchatting;
			else result := vsSchatting;
		end;
	end;
begin
	stringread(f, ProcesPlanPunt^.Treinnr);
	byteread(f, x); ProcesPlanPunt^.ActiviteitSoort := ByteNaarActiviteitsoort(x);
	intread(f, ProcesPlanPunt^.Plantijd);
	intread(f, ProcesPlanPunt^.Insteltijd);
	stringread(f, ProcesPlanPunt^.van);
	stringread(f, ProcesPlanPunt^.naar);
	byteread(f, ProcesPlanPunt^.dwang);
	boolread(f, ProcesPlanPunt^.ROZ);
	boolread(f, dummy);
	boolread(f, ProcesPlanPunt^.ARI_toegestaan);
	stringread(f, ProcesPlanPunt^.NieuwNummer);
	boolread(f, ProcesPlanPunt^.NieuwNummerGedaan);
	stringread(f, ProcesPlanPunt^.RestNummer);
	boolread(f, ProcesPlanPunt^.RestNummerGedaan);
   if SgVersion >= 13 then
	   stringread(f, ProcesPlanPunt^.CombineerNummer)
   else
   	ProcesPlanPunt^.CombineerNummer := '';
	boolread(f, ProcesPlanPunt^.H);
	byteread(f, x); ProcesPlanPunt^.Getriggerd := ByteNaarGetriggerd(x);
	if LoadVertraging then begin
		intread(f, ProcesPlanPunt^.GemetenVertraging);
		byteread(f, x); ProcesPlanPunt^.GemetenVertragingSoort := ByteNaarVertragingSoort(x);
		stringread(f, ProcesPlanPunt^.GemetenVertragingPlaats);
	end else begin
		ProcesPlanPunt^.GemetenVertraging := 0;
		ProcesPlanPunt^.GemetenVertragingSoort := vsSchatting;
		ProcesPlanPunt^.GemetenVertragingPlaats := '';
	end;
	intread(f, ProcesPlanPunt^.VerwerkteVertraging);
	stringread(f, s);
	if s <> '' then
		ProcesPlanPunt^.VertragingTNVPos := ZoekMeetpunt(Core, s)
	else
		ProcesPlanPunt^.VertragingTNVPos := nil;
	boolread(f, ProcesPlanPunt^.VertragingTNVPosHandm);
	boolread(f, ProcesPlanPunt^.Bewerkt);
	ProcesPlanPunt^.InBehandeling := false;
	ProcesPlanPunt^.AnalyseGedaan := false;
	ProcesPlanPunt^.PrlRijweg := nil;
	ProcesPlanPunt^.TNVVan := nil;
	ProcesPlanPunt^.TNVNaar := nil;
	ProcesPlanPunt^.TriggerPunt := nil;
	ProcesPlanPunt^.Volgende := nil;
	UpdatePlanpunt(ProcesPlanPunt);
end;

procedure TProcesPlan.LoadBinair;
var
	i, count: integer;
	PPP: PvProcesPlanPunt;
begin
	PPP := nil;
	intread(f, count);
	for i := 1 to count do begin
		if assigned(PPP) then begin
			new(PPP^.Volgende);
			PPP := PPP^.volgende
		end else begin
			new(PPP);
			ProcesPlanPuntenKlaar := PPP
		end;
		LoadPlanpunt(f, SgVersion, PPP, true);
	end;
	KlaarAantal := count;
	PPP := nil;
	intread(f, count);
	for i := 1 to count do begin
		if assigned(PPP) then begin
			new(PPP^.Volgende);
			PPP := PPP^.volgende
		end else begin
			new(PPP);
			ProcesPlanPuntenPending := PPP
		end;
		LoadPlanpunt(f, SgVersion, PPP, false);
	end;
	UpdateVolgordes;
	Gewijzigd := true;
end;

procedure TProcesPlan.SavePlanpunt;
	function ActiviteitsoortNaarByte(Soort: TActiviteitSoort): byte;
	begin
		case Soort of
			asNul: result := 0;
			asDoorkomst: result := 1;
			asVertrek: result := 2;
			asAankomst: result := 3;
			asKortestop: result := 4;
			asRangeren: result := 5;
			else result := 255;
		end;
	end;
	function GetriggerdNaarByte(Getriggerd: TGetriggerd): byte;
	begin
		case Getriggerd of
			trNiet: result := 0;
			trGetriggerd: result := 1;
			trAanwezig: result := 2;
			trAndereInDeWeg: result := 3;
			else result := 255;
		end;
	end;
	function VertragingSoortNaarByte(Soort: TVertragingSoort): byte;
	begin
		case Soort of
			vsExact: result := 1;
			vsSchatting: result := 2;
			else result := 255;
		end;
	end;
begin
	stringwrite(f, ProcesPlanPunt^.Treinnr);
	bytewrite(f, ActiviteitsoortNaarByte(ProcesPlanPunt^.ActiviteitSoort));
	intwrite(f, ProcesPlanPunt^.Plantijd);
	intwrite(f, ProcesPlanPunt^.Insteltijd);
	stringwrite(f, ProcesPlanPunt^.van);
	stringwrite(f, ProcesPlanPunt^.naar);
	bytewrite(f, ProcesPlanPunt^.dwang);
	boolwrite(f, ProcesPlanPunt^.ROZ);
	boolwrite(f, true);
	boolwrite(f, ProcesPlanPunt^.ARI_toegestaan);
	stringwrite(f, ProcesPlanPunt^.NieuwNummer);
	boolwrite(f, ProcesPlanPunt^.NieuwNummerGedaan);
	stringwrite(f, ProcesPlanPunt^.RestNummer);
	boolwrite(f, ProcesPlanPunt^.RestNummerGedaan);
   stringwrite(f, ProcesPlanPunt^.CombineerNummer);
	boolwrite(f, ProcesPlanPunt^.H);
	bytewrite(f, GetriggerdNaarByte(ProcesPlanPunt^.Getriggerd));
	if SaveVertraging then begin
		intwrite(f, ProcesPlanPunt^.GemetenVertraging);
		bytewrite(f, VertragingSoortNaarByte(ProcesPlanPunt^.GemetenVertragingSoort));
		stringwrite(f, ProcesPlanPunt^.GemetenVertragingPlaats);
	end;
	intwrite(f, ProcesPlanPunt^.VerwerkteVertraging);
	if assigned(ProcesPlanPunt^.VertragingTNVPos) then
		stringwrite(f, ProcesPlanPunt^.VertragingTNVPos^.meetpuntID)
	else
		stringwrite(f, '');
	boolwrite(f, ProcesPlanPunt^.VertragingTNVPosHandm);
	boolwrite(f, ProcesPlanPunt^.Bewerkt);
end;

procedure TProcesPlan.SaveBinair;
var
	count, countpos, nupos: integer;
	ProcesPlanPunt: PvProcesPlanPunt;
begin
	countpos := filepos(f);
	count := 0;
	intwrite(f, 0); // Plaatshouder
	ProcesPlanPunt := ProcesPlanPuntenKlaar;
	while assigned(ProcesPlanPunt) do begin
		SavePlanpunt(f, ProcesPlanPunt, true);
		inc(count);
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
	nupos := filepos(f);
	seek(f, countpos);
	intwrite(f, count);
	seek(f, nupos);
	countpos := nupos;
	count := 0;
	intwrite(f, 0); // Plaatshouder
	ProcesPlanPunt := ProcesPlanPuntenPending;
	while assigned(ProcesPlanPunt) do begin
		SavePlanpunt(f, ProcesPlanPunt, false);
		inc(count);
		ProcesPlanPunt := ProcesPlanPunt^.Volgende;
	end;
	nupos := filepos(f);
	seek(f, countpos);
	intwrite(f, count);
	seek(f, nupos);
end;

procedure TProcesPlan.Sorteer;
begin
	ProcesPlanPuntenPending := Sort_List(ProcesPlanPuntenPending);
	UpdateVolgordes;
	Gewijzigd := true;
end;

procedure TProcesPlan.TreinInfo;
var
	PPP: PvProcesPlanPunt;
begin
	PPP := ProcesPlanPuntenPending;
	while assigned(PPP) do begin
		if PPP^.Treinnr = TreinInfoData.Treinnummer then begin
			if PPP^.GemetenVertraging <> TreinInfoData.Vertraging then begin
				PPP^.GemetenVertraging := TreinInfoData.Vertraging;
				Gewijzigd := true
			end;
			if PPP^.GemetenVertragingSoort <> TreinInfoData.Vertragingsoort then begin
				PPP^.GemetenVertragingSoort := TreinInfoData.Vertragingsoort;
				Gewijzigd := true
			end;
			if PPP^.GemetenVertragingPlaats <> TreinInfoData.Vertragingplaats then begin
				PPP^.GemetenVertragingPlaats := TreinInfoData.Vertragingplaats;
				Gewijzigd := true
			end;
		end;
		PPP := PPP^.Volgende;
	end;
end;

end.

