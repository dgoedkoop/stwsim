unit stwpCore;

interface

uses SysUtils, math, stwpRails, stwpMeetpunt, stwpSeinen,
	stwpTreinen, stwpSternummer, stwpVerschijnLijst, serverSendMsg,
	stwpTijd, stwpRijplan, stwpOverwegen, stwvMisc, stwpDatatypes,
	stwpTelefoongesprek, stwpMonteur, stwpTreinInfo;

// Een paar nuttige algemene definities.
const
	DienstIOMagic		= 'STWSIMDIENST.1';
	SaveIOMagic			= 'STWSIMSAVE.';
	CurrentSgVersion	= 15;
	ScenIOMagic			= 'STWSIMSCEN.';
	CurrentScVersion	= 1;

	tps					= 10;

	cr						= 0.0015;	// Rolweerstandscoefficient
	frontaal				= 3*3;		// Frontaal oppvervlak
	dichtheid			= 1.293;		// Luchtdichtheid

	stationkijkafstand		= 20;
	maxkoppelkijkafstand		= 10;	// Hoeveel meter afstand is nodig om een koppeling
											// toe te staan?
	koppelafstanddoel			= 3;	// Hoe dicht rijden we naar een andere trein toe?
	kopstaartbotsingafstand	= 5;  // Hoe dicht moeten de treinen op elkaar komen
											// (en niet meer kunnen remmen) voor we een
											// kopstaartbotsing registreren?
	SnelheidTargetAfwijking	=0.05;// Met hoe veel snelheidsverschil zijn we tevreden?
	Treinvooruitblik			= 250;
	JuistePerronVooruitblik	= 750;
	WensMaxRemvertraging		= 1.0;
	berichtsturenwachten		= 1;		// Bericht sturen na zoveel minuten voor rood.
	doorroodrozsnelheid		= 40;
	rozsnelheid 				= 40; 	// Snelheid voor geel-knipper

	// Punctualiteit is zo ongeveer 87,5% volgens de 3-minuten-norm.
   df_punctualiteit					= 0.875;

	df_wisseldefectkans				= 1/400;
	df_wisselechtdefectkans			= 1/5;	// in de overige gevallen helpt omzetten
	wisseldefectonderwegmintijd	= 10;
	wisseldefectonderwegmaxtijd	= 20;
	wisseldefectreparatiemintijd	= 3;
	wisseldefectreparatiemaxtijd	= 10;
	storingsdienstnaam				= 'Storingsdienst';

	df_meetpuntdefectbijtreinkans	= 1/1500;
	df_seindefectkans					= 1/4000;
	seindefectmintijd					= 10;
	seindefectmaxtijd					= 20;

	df_treindefectkans				= 1/200;
	tekstberichtover					= 'Over.';
	treindefectberichtstart			= 'Sorry, we kunnen nog niet weg, want ';
	treindefectberichtaantal		= 5;
	treindefectberichten: array[1..treindefectberichtaantal] of string = (
	'hij doet het niet.',
	'de HC is koffie aan het halen.',
	'de HC moet naar de WC.',
	'er is een storing met de deuren.',
	'er moet een schoolklas mee.');
	treindefectmintijd			= 5;
	treindefectmaxtijd			= 15;

	treinklaarmeldingbericht	= 'We kunnen nu vertrekken! ' + tekstberichtover;

	zstvhHoofdsein = 1;
	zstvhSnelheidsbordje = 2;
	zvsHoofdsein = 1;
	zvsVoorsein = 2;

type
	EFysiekeError = class(Exception);
	EFysiekeWarning = class(Exception);
	EMatfileError = class(Exception);

	TScoreInfo = record
		AankomstOpTijd			: integer;
		AankomstBinnenDrie	: integer;
		AankomstTeLaat			: integer;
		VertragingVeroorzaakt: integer;
		VertragingVerminderd	: integer;
		PerronCorrect			: integer;
		PerronFout				: integer;
	end;

	PpCore = ^TpCore;
	TpCore = class
		// Systeemdingen
		Filedir:	string;				// Waar zijn de bestanden opgeslagen?
		simnaam: string;
		simversie:	string;
		SendMsg:	PpSendMsg;

		// Interne gegevens: Infrastructuur
		pAlleRails:				PpRailLijst;
		pAlleMeetpunten:		PpMeetpunt;
		pAlleErlaubnisse:		PpErlaubnis;
		pAlleSeinen:			PpSein;
		pAlleSeinBeperkingen:PpSeinBeperking;
		pAlleWissels:			PpWissel;
		pAlleVerschijnpunten:PpVerschijnPunt;
		pAlleVerdwijnpunten:	PpVerdwijnPunt;
		pAlleOverwegen:		PpOverweg;
		pAlleGesprekken:		PpTelefoongesprek;
		// Interne gegevens: Materieel
		pMaterieel:				PpMaterieelFile;
		// Interne gegevens: Dienstregeling
		pAlleDiensten:			PpTreindienst;
		VerschijnLijst:		PpVerschijnItem;
		Starttijd:				integer;
		Stoptijd:				integer;
		// Dynamische gegevens: Treinen
		pAlleTreinen:			PpTrein;
		pAlleTreinInfo:		PpTreinInfo;
		// Dynamische gegevens: cheat
		CheatGeenDefecten:	boolean;
		//
		pMonteur:				PpMonteur;

		ScoreInfo:				TScoreInfo;

		Tijd_t:					integer;	// Huidig stapje binnen de seconde.

		Leesfout_melding:		string;

		// Instelbare defecten
		punctualiteit					: double;
		wisseldefectkans				: double;
		wisselechtdefectkans			: double;
		meetpuntdefectbijtreinkans	: double;
		seindefectkans					: double;
		treindefectkans				: double;
	private
		procedure InitStateVars;
		procedure InitMeetpuntState(Meetpunt: PpMeetpunt);
		procedure InitWisselState(Wissel: PpWissel);
		procedure InitSeinState(Sein: PpSein);
		procedure InitErlaubnisState(Erlaubnis: PpErlaubnis);
		procedure InitOverwegState(Overweg: PpOverweg);
	public
		constructor Create;
		destructor Destroy; override;
		// Wat nuttige algemene interne functies
		function NieuwTelefoongesprek(Sender: TSender; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek; overload;
		function NieuwTelefoongesprek(Trein: PpTrein; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek; overload;
		function NieuwTelefoongesprek(Monteur: PpMonteur; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek; overload;
		function ZoekTelefoongesprek(Sender: TSender): PpTelefoongesprek; overload;
		function ZoekTelefoongesprek(Trein: PpTrein): PpTelefoongesprek; overload;
		function ZoekTelefoongesprek(Monteur: PpMonteur): PpTelefoongesprek; overload;
		procedure RuimAfgelopenTelefoongesprekkenOp;

		function ZoekMeetpunt(naam: string): PpMeetpunt;
		function ZoekErlaubnis(naam: string): PpErlaubnis;
		function ZoekRail(naam: string): PpRail;
		function ZoekSein(naam: string): PpSein;
		function ZoekWissel(naam: string): PpWissel;
		function ZoekOverweg(naam: string): PpOverweg;
		function ZoekTrein(nummer: string): PpTrein;
		function ZoekOfMaakTreininfo(treinnr: string): PpTreinInfo;
		procedure DeleteTreininfo(treinnr: string);
		function CopyDienst(Dienst: PpTreindienst): PpRijplanPunt;
		function CopyDienstFrom(nummer, beginstation: string): PpRijplanPunt;
		function CopyWagons(WagonConn: PpWagonConn): PpWagonConn;
		function ZoekVolgendeConn(Rail: PpRail; achteruit: boolean): PpRailConn;
		function ZoekSporenTotVolgendHoofdsein(Conn: PpRailConn; flags: byte): PpRailLijst;
		function ZoekSporenTotVolgendHoofdseinR(Rail: PpRail; achteruit: boolean): PpRailLijst;

		// ZoekVolgendSein en ZoekVolgendeWissel zetten via de var-parameters de
		// positie precies achter de gevonden plek. Als de gevonden plek dus
		// (tegelijk) een wissel is dat niet in een eenduidige stand staat, dan
		// is de geretourneerde rail dus =nil.

		procedure ZoekVolgendSein(var Rail: PpRail; var achteruit: boolean; var positie: double;
			maxafstand: double; var GevSein: PpSein; var GevAfstand: double);
		procedure ZoekVolgendVoorOfHoofdsein(Conn: PpRailConn; var GevSein: PpSein; niksmagook: boolean; flags: byte);
		procedure ZoekVolgendeWissel(var Rail: PpRail; var achteruit: boolean; var positie: double;
			maxafstand: double; var GevWissel: PpWissel; var GevAfstand: double);
		procedure ZoekVolgendeTrein(Trein: PpTrein; maxafstand: double;
			var GevTrein: PpTrein; var GevAfstand: double; var GevOmgekeerd: boolean);
		procedure WisTrein(Trein: PpTrein);

		procedure ScoreAankomstVertraging(Trein: PpTrein; nieuwevertraging: integer);
		procedure ScorePerrongebruik(Trein: PpTrein; correct: boolean);

		function GaatDefect(kans: double): boolean;
		procedure DoeMeetpuntDefect(Meetpunt: PpMeetpunt);
		procedure DoeWisselDefect(Wissel: PpWissel; magechtdefect: boolean);

		function CalcSeinbeeld(Sein: PpSein): TSeinbeeld;
		function CalcBeperking(Vansein, Naarsein: PpSein): integer;

		procedure StelErlaubnisIn(Erlaubnis: PpErlaubnis; stand: byte);
		procedure GeefErlaubnisVrij(Erlaubnis: PpErlaubnis);

		// Wat functies voor eenmalig intern gebruik
		procedure DoeSein(Sein: PpSein);
		procedure DoeWissel(Wissel: PpWissel);
		procedure DoeErlaubnis(Erlaubnis: PpErlaubnis);
		procedure DoeOverweg(Overweg: PpOverweg);
		procedure DoeVerschijnen;

		// Publieke functies
		function ErlaubnisVrij(Erlaubnis: PpErlaubnis): boolean;
		function LoadRailString(s: string): boolean;
		function LoadScenarioString(s: string): boolean;
		procedure WagonsLaden(filenaam: string);
		procedure WagonsWissen;
		function ZetWissel(Wissel: PpWissel; stand: TWisselstand): boolean;
		procedure DoeSeinen;
		procedure ZendSeinen;
		procedure DoeMeetpunten;
		procedure ZendMeetpunten;
		procedure DoeErlaubnisse;
		procedure ZendErlaubnisse;
		procedure DoeWissels;
		procedure ZendWissels;
		procedure ZendTreinInfo;
		function TreinenDoenIets: boolean;
		procedure DoeStapje;
		procedure StartUp;

		procedure SaveInfraStatus(var f: file);
		procedure LoadInfraStatus(var f: file);

		procedure LaadMatDienstVerschijn(var f: file; wat: TSaveWhat);
		procedure SaveMatDienstVerschijn(var f: file; wat: TSaveWhat);
		procedure DestroyState;
	end;


implementation

constructor TpCore.Create;
begin
	pAlleRails				:= nil;
	pAlleMeetpunten		:= nil;
	pAlleErlaubnisse		:= nil;
	pAlleSeinen				:= nil;
	pAlleSeinBeperkingen := nil;
	pAlleWissels			:= nil;
	pAlleVerschijnpunten	:= nil;
	pAlleVerdwijnpunten	:= nil;
	pAlleOverwegen			:= nil;
	pAlleGesprekken		:= nil;
	pMaterieel				:= nil;
	pAlleDiensten			:= nil;
	VerschijnLijst			:= nil;
	pAlleTreinen			:= nil;
	pAlleTreinInfo			:= nil;

   InitStateVars;
end;

procedure TpCore.InitStateVars;
begin
	new(pMonteur);
	pMonteur^ := TpMonteur.Create;

	CheatGeenDefecten := false;

	ScoreInfo.AankomstOpTijd := 0;
	ScoreInfo.AankomstBinnenDrie := 0;
	ScoreInfo.AankomstTeLaat := 0;
	ScoreInfo.PerronCorrect := 0;
	ScoreInfo.PerronFout := 0;

	starttijd := 0;
	stoptijd := 0;
	Tijd_t := 0;

	Leesfout_melding := '';

	punctualiteit := df_punctualiteit;
	wisseldefectkans := df_wisseldefectkans;
	wisselechtdefectkans	:= df_wisselechtdefectkans;
	meetpuntdefectbijtreinkans	:= df_meetpuntdefectbijtreinkans;
	seindefectkans	:= df_seindefectkans;
	treindefectkans := df_treindefectkans;
end;

function TpCore.NieuwTelefoongesprek(Sender: TSender; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek;
var
	Telefoongesprek: PpTelefoongesprek;
begin
	new(Telefoongesprek);
	Telefoongesprek^ := TpTelefoongesprek.Create(Sender, Soort, Meteen);
	Telefoongesprek^.Volgende := pAlleGesprekken;
	pAlleGesprekken := Telefoongesprek;
	result := Telefoongesprek;
end;

function TpCore.NieuwTelefoongesprek(Trein: PpTrein; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek;
begin
	result := Self.NieuwTelefoongesprek(TSender(Trein), Soort, Meteen);
end;

function TpCore.NieuwTelefoongesprek(Monteur: PpMonteur; Soort: TpTelefoongesprekType; Meteen: boolean): PpTelefoongesprek;
begin
	result := Self.NieuwTelefoongesprek(TSender(Monteur), Soort, Meteen);
end;

function TpCore.ZoekTelefoongesprek(Sender: TSender): PpTelefoongesprek;
var
	Gesprek: PpTelefoongesprek;
begin
	result := nil;
	Gesprek := pAlleGesprekken;
	while assigned(Gesprek) do begin
		if Gesprek^.Owner = Sender then begin
			result := Gesprek;
			exit;
		end;
		Gesprek := Gesprek^.Volgende;
	end;
end;

function TpCore.ZoekTelefoongesprek(Trein: PpTrein): PpTelefoongesprek;
begin
	result := ZoekTelefoongesprek(TSender(Trein));
end;

function TpCore.ZoekTelefoongesprek(Monteur: PpMonteur): PpTelefoongesprek;
begin
	result := ZoekTelefoongesprek(TSender(Monteur));
end;

procedure TpCore.RuimAfgelopenTelefoongesprekkenOp;
var
	vGesprek, Gesprek, nGesprek: PpTelefoongesprek;
begin
	vGesprek := nil;
	Gesprek := pAlleGesprekken;
	while assigned(Gesprek) do begin
		if Gesprek.Status = tgsE then begin
			nGesprek := Gesprek^.Volgende;
			if assigned(vGesprek) then
				vGesprek^.Volgende := Gesprek^.Volgende
			else
				pAlleGesprekken := Gesprek^.Volgende;
			Gesprek^.Free;
			dispose(Gesprek);
			Gesprek := nGesprek;
		end else begin
			vGesprek := Gesprek;
			Gesprek := Gesprek^.Volgende;
		end;
	end;
end;


function TpCore.CalcSeinbeeld;
begin
	result := sbRood;
	if (Sein^.Bediend or Sein^.Autosein) and not Sein^.Autovoorsein then
		if Sein^.H_MovementAuthority.HasAuthority then
			result := sbGroen
		else
			result := sbRood;
	if Sein^.Autovoorsein and not (Sein^.Bediend or Sein^.Autosein) then
		if Sein^.V_AdviesAuthority.HasAuthority then
			result := sbGroen
		else
			result := sbGeel;
	if (Sein^.Bediend or Sein^.Autosein) and Sein^.Autovoorsein then begin
		if not Sein^.H_MovementAuthority.HasAuthority then
			result := sbRood
		else if Sein^.V_AdviesAuthority.HasAuthority then
			result := sbGeel
		else
			result := sbGroen;
	end;
end;

function TpCore.CalcBeperking;
var
	tmpSeinBeperking: PpSeinBeperking;
begin
	result := -1;
	tmpSeinBeperking := pAlleSeinBeperkingen;
	// Voor de verduidelijking van het onderstaande:
	// Per combinatie kunnen meerdere beperkingen van toepassing zijn.
	// Bijv. 40 -> 0 en 120 -> 60, om maar wat te noemen. Het is dan uiteraard
	// de bedoeling dat de meest restrictieve beperking die van toepassing is
	// gebruikt wordt.
	while assigned(tmpSeinBeperking) do begin
		if // Betreft het deze combinatie?
			(Vansein = tmpSeinBeperking^.Vansein) and
			(Naarsein = tmpSeinBeperking^.Naarsein) and
			// Is aan deze trigger voldaan?
			((not Naarsein^.H_MovementAuthority.HasAuthority) or
			((not Naarsein^.H_MovementAuthority.Baanvaksnelheid) and
			(Naarsein^.H_MovementAuthority.Snelheidsbeperking <= tmpSeinBeperking^.Triggersnelheid))) and
			// Is deze beperking strenger dan wat we evt. eerder vonden?
			((tmpSeinBeperking^.Beperking < result) or (result = -1)) then
			result := tmpSeinBeperking^.Beperking;
		tmpSeinBeperking := tmpSeinBeperking^.volgende;
	end;
end;

function TpCore.GaatDefect;
begin
	result := (random < kans) and not CheatGeenDefecten;
end;

procedure TpCore.DoeMeetpuntDefect;
begin
	if assigned(Meetpunt) then
		Meetpunt^.defect := false;
		if GaatDefect(meetpuntdefectbijtreinkans) and Meetpunt^.magdefect then begin
			Meetpunt^.defect := true;
		end;
end;

function TpCore.ZoekRail;
begin
	result := stwpRails.ZoekRail(pAlleRails, Naam);
end;

function TpCore.ZoekSein;
var
	tmpSein: PpSein;
begin
	result := nil;
	tmpSein := pAlleSeinen;
	while assigned(tmpSein) do begin
		if tmpSein^.Naam = Naam then
			result := tmpSein;
		tmpSein := tmpSein^.Volgende;
	end;
end;

function TpCore.ZoekMeetpunt;
var
	tmpMeetpunt: PpMeetpunt;
begin
	result := nil;
	tmpMeetpunt := pAlleMeetpunten;
	while assigned(tmpMeetpunt) do begin
		if tmpMeetpunt^.Naam = Naam then
			result := tmpMeetpunt;
		tmpMeetpunt := tmpMeetpunt^.Volgende;
	end;
end;

function TpCore.ZoekErlaubnis;
var
	tmpErlaubnis: PpErlaubnis;
begin
	result := nil;
	tmpErlaubnis := pAlleErlaubnisse;
	while assigned(tmpErlaubnis) do begin
		if tmpErlaubnis^.Naam = Naam then
			result := tmpErlaubnis;
		tmpErlaubnis := tmpErlaubnis^.Volgende;
	end;
end;

function TpCore.ZoekWissel;
var
	tmpWissel: PpWissel;
begin
	result := nil;
	tmpWissel := pAlleWissels;
	while assigned(tmpWissel) do begin
		if tmpWissel^.w_naam = Naam then
			result := tmpWissel;
		tmpWissel := tmpWissel^.Volgende;
	end;
end;

function TpCore.ZoekOverweg;
var
	tmpOverweg: PpOverweg;
begin
	result := nil;
	tmpOverweg := pAlleOverwegen;
	while assigned(tmpOverweg) do begin
		if tmpOverweg^.naam = Naam then
			result := tmpOverweg;
		tmpOverweg := tmpOverweg^.Volgende;
	end;
end;

function TpCore.ZoekTrein;
var
	tmpTrein: PpTrein;
begin
	result := nil;
	tmpTrein := pAlleTreinen;
	while assigned(tmpTrein) do begin
		if tmpTrein^.Treinnummer = nummer then
			result := tmpTrein;
		tmpTrein := tmpTrein^.Volgende;
	end;
end;

function TpCore.ZoekOfMaakTreininfo;
var
	tmpTreinInfo: PpTreinInfo;
begin
	result := nil;
	tmpTreinInfo := pAlleTreinInfo;
	while assigned(tmpTreinInfo) do begin
		if tmpTreinInfo^.Treinnummer = treinnr then begin
			result := tmpTreinInfo;
			break;
		end;
		tmpTreinInfo := tmpTreinInfo^.Volgende;
	end;
	if not assigned(result) then begin
		if not assigned(pAlleTreinInfo) then begin
			new(pAlleTreinInfo);
			tmpTreinInfo := pAlleTreinInfo;
		end else begin
			tmpTreinInfo := pAlleTreinInfo;
			while assigned(tmpTreinInfo^.volgende) do
				tmpTreinInfo := tmpTreinInfo^.Volgende;
			new(tmpTreinInfo^.Volgende);
			tmpTreinInfo := tmpTreinInfo^.Volgende;
		end;
		tmpTreinInfo^.Treinnummer := treinnr;
		tmpTreinInfo^.Vertraging := 0;
		tmpTreinInfo^.Vertragingtype := vtSchatting;
		tmpTreinInfo^.Vertragingplaats := '';
		tmpTreinInfo^.gewijzigd := false;
		tmpTreinInfo^.Volgende := nil;
		result := tmpTreinInfo;
	end;
end;

procedure TpCore.DeleteTreininfo;
var
	tmpTreinInfo: PpTreinInfo;
	vorigeTreinInfo: PpTreinInfo;
begin
	tmpTreinInfo := pAlleTreinInfo;
	vorigeTreinInfo := nil;
	while assigned(tmpTreinInfo) do begin
		if tmpTreinInfo^.Treinnummer = treinnr then
			break;
		vorigeTreinInfo := tmpTreinInfo;
		tmpTreinInfo := tmpTreinInfo^.Volgende;
	end;
	if not assigned(tmpTreinInfo) then
		exit;
	if assigned(vorigeTreinInfo) then
		vorigeTreinInfo^.Volgende := tmpTreinInfo^.Volgende
	else
		pAlleTreinInfo := tmpTreinInfo^.Volgende;
	dispose(tmpTreinInfo);
end;

function TpCore.CopyDienst;
var
	TPunt, NPunt: PpRijplanpunt;
begin
	result := nil;
	NPunt := nil;
	TPunt := Dienst^.Planpunten;
	while assigned(TPunt) do begin
		if not assigned(Result) then begin
			new(NPunt);
			result := NPunt;
		end else begin
			new(NPunt^.Volgende);
			NPunt := NPunt^.Volgende;
		end;
		NPunt^ := TPunt^;
		NPunt^.Volgende := nil;	// Eigenlijk niet echt nodig.
		TPunt := TPunt^.Volgende;
	end;
end;

function TpCore.CopyDienstFrom;
var
	Dienst: PpTreindienst;
	TPunt, NPunt: PpRijplanpunt;
begin
	result := nil;
	NPunt := nil;
	Dienst := pAlleDiensten;
	while assigned(Dienst) do begin
		if Dienst^.Treinnummer = nummer then begin
			TPunt := Dienst^.Planpunten;
			// Zoek (eventueel) het beginstation
			if beginstation <> '' then
				while assigned(TPunt) and (TPunt^.Station <> beginstation) do
					TPunt := TPunt^.Volgende;
			// En nu kopieren maar!
			while assigned(TPunt) do begin
				if not assigned(Result) then begin
					new(NPunt);
					result := NPunt;
				end else begin
					new(NPunt^.Volgende);
					NPunt := NPunt^.Volgende;
				end;
				NPunt^ := TPunt^;

				// Dynamische gegevens initialiseren
				NPunt^.spc_gedaan := false;
				NPunt^.Volgende := nil; // Eigenlijk niet nodig.
				
				TPunt := TPunt^.Volgende;
			end;
			exit;
		end else
			Dienst := Dienst^.Volgende;
	end;
end;

function TpCore.CopyWagons;
var
	tmpConn, lastConn: PpWagonConn;
begin
	result := nil;
	lastConn := nil;
	while assigned(WagonConn) do begin
		new(tmpConn);
		tmpConn^ := WagonConn^;
		tmpConn^.Vorige := lastConn;
		tmpConn^.Volgende := nil;
		if assigned(lastConn) then
			lastConn^.Volgende := tmpConn
		else begin
			result := tmpConn;
		end;
		lastConn := tmpConn;
		WagonConn := WagonConn^.Volgende;
	end;
end;

function TpCore.ZoekVolgendeConn;
begin
	if not achteruit then
		result := Rail^.Volgende
	else
		result := Rail^.Vorige;
end;

function TpCore.ZoekSporenTotVolgendHoofdsein;
var
	tmpRail: PpRail;
	tmpAchteruit: boolean;
	tmpConn: PpRailConn;
	tmpLijst2: PpRailLijst;
begin
	if ((flags and zstvhHoofdsein)=0) and ((flags and zstvhSnelheidsbordje)=0) then begin
		result := nil;
		exit
	end;
	// Pak de volgende rail.
	VolgendeRail(Conn, tmpRail, tmpAchteruit);
	// Het spoor waaraan het sein staat sowieso.
	result := new(PpRailLijst);
	result^.Rail := tmpRail;
	result^.volgende := nil;
	repeat
		if not tmpAchteruit then
			tmpConn := tmpRail.Volgende
		else
			tmpConn := tmpRail.Vorige;
		if (flags and zstvhHoofdsein)>0 then
			if IsHierHoofdsein(tmpConn) then
				exit;
		if (flags and zstvhSnelheidsbordje)>0 then
			if IsHierSnelheidsbordje(tmpConn) then
				exit;

		// Pak de volgende rail.
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if assigned(tmpRail) then begin
			if RailOpLijst(tmpRail, result) then
				exit;
			// Nieuwe rail, die moet dan in de lijst.
			new(tmpLijst2);
			tmpLijst2^.Rail := tmpRail;
			tmpLijst2^.volgende := result;
			result := tmpLijst2;
		end;
	until not assigned(tmpRail);
end;

function TpCore.ZoekSporenTotVolgendHoofdseinR;
var
	tmpRail: PpRail;
	tmpAchteruit: boolean;
	tmpConn: PpRailConn;
	tmpLijst2: PpRailLijst;
begin
	tmpRail := Rail;
	tmpAchteruit := Achteruit;
	// Het spoor waar we beginnen met zoeken sowieso.
	result := new(PpRailLijst);
	result^.Rail := tmpRail;
	result^.volgende := nil;
	repeat
		if not tmpAchteruit then
			tmpConn := tmpRail.Volgende
		else
			tmpConn := tmpRail.Vorige;
		if IsHierHoofdsein(tmpConn) then
			exit;

		// Pak de volgende rail.
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if RailOpLijst(tmpRail, result) then
			exit;
		// Nieuwe rail, die moet dan in de lijst.
		new(tmpLijst2);
		tmpLijst2^.Rail := tmpRail;
		tmpLijst2^.volgende := result;
		result := tmpLijst2;
	until not assigned(tmpRail);
	raise EFysiekeError.Create('ZoekSporenTotVolgendHoofdseinR: Voorbij einde van rails.');
end;

procedure TpCore.ZoekVolgendSein;
var
	tmpRail, vRail: PpRail;
	tmpAchteruit: boolean;
	tmpConn: PpRailConn;
begin
	GevSein := nil;
	tmpRail := Rail;
	tmpAchteruit := Achteruit;
	if tmpAchteruit then
		GevAfstand := positie
	else
		GevAfstand := tmpRail^.Lengte-positie;
	repeat
		if GevAfstand > maxafstand then exit;
		if not tmpAchteruit then
			tmpConn := tmpRail.Volgende
		else
			tmpConn := tmpRail.Vorige;
		if tmpConn^.sein <> nil then begin
			GevSein := tmpConn^.Sein;
			VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
			Rail := tmpRail;
			Achteruit := tmpAchteruit;
			if achteruit and assigned(tmpRail) then
				Positie := tmpRail^.Lengte
			else
				Positie := 0;
			exit;
		end;

		// Pak de volgende rail.
		if tmpAchteruit then
			tmpConn := tmpRail.Vorige
		else
			tmpConn := tmpRail.Volgende;
		vRail := tmpRail;
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if (tmpRail = vRail) or (tmpRail = Rail) then exit;
		if assigned(tmpRail) then
			GevAfstand := GevAfstand + tmpRail.Lengte;
	until not assigned(tmpRail);
end;

procedure TpCore.ZoekVolgendVoorOfHoofdsein;
var
	tmpRail, vRail: PpRail;
	tmpAchteruit: boolean;
	tmpConn: PpRailConn;
begin
	if niksmagook and
	( (IsHierHoofdsein(Conn) and ((flags and zvsHoofdsein) > 0)) or
	  (IsHierVoorsein(Conn) and ((flags and zvsVoorsein) > 0)) )
	then begin
		GevSein := Conn^.Sein;
		exit;
	end;
	GevSein := nil;
	tmpRail := Conn^.recht;
	tmpAchteruit := Conn^.r_foutom;
	repeat
		// Let's take the connection
		if not tmpAchteruit then
			tmpConn := tmpRail.Volgende
		else
			tmpConn := tmpRail.Vorige;
		if (IsHierHoofdsein(tmpConn) and ((flags and zvsHoofdsein) > 0)) or
			(IsHierVoorsein(tmpConn) and ((flags and zvsVoorsein) > 0)) then begin
			GevSein := tmpConn^.Sein;
			exit;
		end;

		// Pak de volgende rail.
		if tmpAchteruit then
			tmpConn := tmpRail.Vorige
		else
			tmpConn := tmpRail.Volgende;
		vRail := tmpRail;
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if tmpRail = vRail then exit;
	until not assigned(tmpRail);
end;

procedure TpCore.ZoekVolgendeWissel;
var
	tmpRail, vRail: PpRail;
	tmpAchteruit: boolean;
	tmpConn: PpRailConn;
begin
	GevWissel := nil;
	tmpRail := Rail;
	tmpAchteruit := Achteruit;
	if tmpAchteruit then
		GevAfstand := positie
	else
		GevAfstand := tmpRail^.Lengte-positie;
	repeat
		if GevAfstand > maxafstand then exit;
		if not tmpAchteruit then
			tmpConn := tmpRail.Volgende
		else
			tmpConn := tmpRail.Vorige;
		if tmpConn^.wissel then begin
			GevWissel := tmpConn^.WisselData;
			VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
			Rail := tmpRail;
			Achteruit := tmpAchteruit;
			if achteruit and assigned(tmpRail) then
				Positie := tmpRail^.Lengte
			else
				Positie := 0;
			exit;
		end;

		// Pak de volgende rail.
		if tmpAchteruit then
			tmpConn := tmpRail.Vorige
		else
			tmpConn := tmpRail.Volgende;
		vRail := tmpRail;
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if (tmpRail = vRail) or (tmpRail = Rail) then exit;
		if assigned(tmpRail) then
			GevAfstand := GevAfstand + tmpRail.Lengte;
	until not assigned(tmpRail);
end;

procedure TpCore.ZoekVolgendeTrein;
var
	tmpRail: PpRail;
	tmpAchteruit: boolean;
	tmpPos:	double;
	tmpConn: PpRailConn;
	tmpTrein:	PpTrein;
	tmpHRail, tmpTRail: PpRail;
	tmpHAchteruit, tmpTAchteruit: boolean;
	tmpHPos, tmpTPos: double;
	tmpAfstand: double;
	BasisAfstand:	double;
begin
	GevTrein := nil;
	GevAfstand := -1;
	GevOmgekeerd := false;
	tmpRail := Trein^.pos_rail;
	tmpAchteruit := Trein^.achteruit;
	tmpPos := Trein^.pos_dist;
	BasisAfstand := 0;
	repeat
		tmpTrein := pAlleTreinen;
		while assigned(tmpTrein) do begin
			if tmpTrein <> Trein then begin
				tmpHRail := tmpTrein^.pos_rail;
				tmpHAchteruit := tmpTrein^.achteruit;
				tmpHPos := tmpTrein^.pos_dist;
				tmpTrein^.ZoekEinde(tmpTRail, tmpTAchteruit, tmpTPos);
				// Kijk naar de kop
				if (tmpRail = tmpHRail) and (tmpAchteruit <> tmpHAchteruit) and
					(((tmpHPos >= tmpPos) and not tmpAchteruit) or
					 ((tmpHPos <= tmpPos) and tmpAchteruit)) then begin
					tmpAfstand := abs(tmpHPos - tmpPos) + BasisAfstand;
					if ((tmpAfstand < GevAfstand) or (GevAfstand = -1))
						and (tmpAfstand < maxafstand) then begin
						GevAfstand := round(tmpAfstand);
						GevTrein := tmpTrein;
						GevOmgekeerd := true;
					end;
				end;
				// Kijk naar de staart
				if (tmpRail = tmpTRail) and (tmpAchteruit <> tmpTAchteruit) and
					(((tmpTPos >= tmpPos) and not tmpAchteruit) or
					 ((tmpTPos <= tmpPos) and tmpAchteruit)) then begin
					tmpAfstand := abs(tmpTPos - tmpPos) + BasisAfstand;
					if ((tmpAfstand < GevAfstand) or (GevAfstand = -1))
						and (tmpAfstand < maxafstand) then begin
						GevAfstand := round(tmpAfstand);
						GevTrein := tmpTrein;
						GevOmgekeerd := false;
					end;
				end;
			end;
			tmpTrein := tmpTrein^.Volgende;
		end;

		// Pak de volgende rail.
		if not tmpAchteruit then begin
			Basisafstand := Basisafstand + tmpRail^.Lengte - tmpPos;
			tmpConn := tmpRail.Volgende;
		end else begin
			Basisafstand := Basisafstand + tmpPos;
			tmpConn := tmpRail.Vorige;
		end;
		if Basisafstand > maxafstand then exit;	// Dan is het zinloos.
		VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
		if assigned(tmpRail) then
			if tmpAchteruit then
				tmpPos := tmpRail^.Lengte
			else
				tmpPos := 0;
	until not assigned(tmpRail);
end;

procedure TpCore.WisTrein;
var
	tmpTrein: PpTrein;
	gesprek: PpTelefoongesprek;
	gesprekgevonden: boolean;
begin
	// Telefoongesprekken van deze trein be�indigen
	gesprekgevonden := false;
	gesprek := pAlleGesprekken;
	while assigned(gesprek) do begin
		if PpTrein(gesprek^.Owner) = Trein then begin
			gesprek^.Status := tgsAbort;
			gesprekgevonden := true;
		end;
		gesprek := gesprek^.Volgende;
	end;

	// Zolang gesprek nog niet be�indigd, moeten we wachten.
	if gesprekgevonden then exit;

	tmpTrein := pAlleTreinen;
	while assigned(tmpTrein) do begin
		if tmpTrein = Trein then begin
			if assigned(tmpTrein^.Vorige) then
				tmpTrein^.Vorige^.Volgende := tmpTrein^.Volgende;
			if assigned(tmpTrein^.Volgende) then
				tmpTrein^.Volgende^.Vorige := tmpTrein^.Vorige;
			if tmpTrein = pAlleTreinen then
				pAlleTreinen := tmpTrein^.Volgende;
		end;
		tmpTrein := tmpTrein^.Volgende;
	end;
	Trein^.Destroy;
	Dispose(Trein);
end;

procedure TpCore.ScoreAankomstVertraging;
var
	vertragingsverschil: integer;
begin
	vertragingsverschil := nieuwevertraging - Trein^.vorigeaankomstvertraging;
	Trein^.vorigeaankomstvertraging := nieuwevertraging;
	if Trein^.vertraging <= 0 then
		inc(ScoreInfo.AankomstOpTijd)
	else if Trein^.vertraging < 3 then
		inc(ScoreInfo.AankomstBinnenDrie)
	else
		inc(ScoreInfo.AankomstTeLaat);
	if vertragingsverschil > 0 then
		inc(ScoreInfo.VertragingVeroorzaakt, vertragingsverschil)
	else if vertragingsverschil < 0 then
		inc(ScoreInfo.VertragingVerminderd, -vertragingsverschil);
end;

procedure TpCore.StelErlaubnisIn;
var
	Meetpunt: PpMeetpuntLijst;
begin
	If Erlaubnis^.standaardrichting > 0 then begin
		// Dubbelspoor met beveiligd links rijden: harde erlaubnis
		Erlaubnis^.richting := stand;
		Erlaubnis^.vergrendeld := true;
		Erlaubnis^.r_veranderd := true;
	end else begin
		// Enkelspoor of dubbelenkelspoor: zachte erlaubnis
		// Dat we hier zijn betekent dat hetzij alle meetpunten vrij zijn, of
		// hetzij dat alle treinen op de vrije baan eenduidig de juiste kant op
		// bewegen.
		// Hoe dan ook, het betekent dat we alle meetpunten met onze richting
		// mogen vastleggen. Eigenlijk zou alleen de eerste al genoeg zijn, maar
		// omdat we niet weten welke dat is doen we ze allemaal maar.
		Meetpunt := Erlaubnis^.Meetpunten;
		while assigned(Meetpunt) do begin
			Meetpunt^.Meetpunt^.rijrichting := stand;
			Meetpunt := Meetpunt^.Volgende;
		end;
		// En vergrendelen.
		Erlaubnis^.check := true;
		Erlaubnis^.vergrendeld := true;
	end;
end;

procedure TpCore.GeefErlaubnisVrij;
var
	Meetpunt: PpMeetpuntLijst;
begin
	// We geven een reeds geclaimde rijrichting vrij. In ieder
	// geval heffen we de vergrendeling op.
	Erlaubnis^.voorvergendeld := false;
	// Is de rijrichting helemaal vrij, dan kan hij meteen worden
	// vrijgegeven.
	if ErlaubnisVrij(Erlaubnis) then
		if Erlaubnis^.standaardrichting > 0 then begin
			// Dubbelspoor met beveiligd links rijden: harde erlaubnis
			Erlaubnis^.richting := Erlaubnis^.standaardrichting;
			Erlaubnis^.vergrendeld := false;
			Erlaubnis^.r_veranderd := true;
		end else begin
			// Enkelspoor of dubbelenkelspoor: zachte erlaubnis
			// Dat we hier zijn betekent dat hetzij alle meetpunten vrij zijn.
			// Dan mogen we de rijrichting van al die meetpunten resetten.
			Meetpunt := Erlaubnis^.Meetpunten;
			while assigned(Meetpunt) do begin
				Meetpunt^.Meetpunt^.rijrichting := 0;
				Meetpunt := Meetpunt^.Volgende;
			end;
			// En vergrendelen.
			Erlaubnis^.vergrendeld := false;
			Erlaubnis^.check := true;
		end;
end;

procedure TpCore.ScorePerrongebruik;
begin
	if correct then
		inc(ScoreInfo.PerronCorrect)
	else
		inc(ScoreInfo.PerronFout);
end;

procedure TpCore.DoeSein;
var
	Sein2: PpSein;
	SporenTotVolgendSeinLijst, tmpRail: PpRaillijst;
	VolgendSein: PpSein;
	VolgendeMeetpunt: PpMeetpunt;
	Beperking: integer;
	RailsBezet: boolean;
	ErlaubnisOK: boolean;
	Meetpunt: PpMeetpunt;
	//////
	MovementAuthority: THMovementAuthority;
	Vorige_H_MovementAuthority: THMovementAuthority;
	VorigeSeinbeeld: TSeinbeeld;
	H_terugoprood:	boolean;
	tmpNaam: string;
	// Defecten
	Seinbeeld:	TSeinbeeld;
begin
	// Moeten we wel iets doen?
	if not (Sein^.Bediend or Sein^.Autosein or Sein^.Autovoorsein) then exit;

	// Om te kijken of het verandert
	Vorige_H_MovementAuthority := Sein^.H_MovementAuthority;
	VorigeSeinbeeld := CalcSeinbeeld(Sein);

	// Is het een autovoorsein, dan zoeken we het bijbehorende hoofdsein op
	// en geven het seinbeeld door.
	if Sein^.Autovoorsein then
		if IsHoofdsein(Sein) then begin
			ZoekVolgendVoorOfHoofdSein(Sein^.Plaats, Sein2, false, zvsHoofdsein+zvsVoorsein);
			if assigned(Sein2) then
				if IsHoofdsein(Sein2) then
					Sein^.V_AdviesAuthority := Sein2^.H_MovementAuthority
				else begin
					Sein^.V_AdviesAuthority.HasAuthority := true;
					Sein^.V_AdviesAuthority.Baanvaksnelheid := true
				end
			else
				Sein^.V_AdviesAuthority.HasAuthority := false
		end else begin
			ZoekVolgendVoorOfHoofdSein(Sein^.Plaats, Sein2, false, zvsHoofdsein);
			if assigned(Sein2) then
				Sein^.V_AdviesAuthority := Sein2^.H_MovementAuthority
			else
				Sein^.V_AdviesAuthority.HasAuthority := false
		end;

	// Sowieso eerst maar eens e.e.a. opzoeken.
	ZoekVolgendVoorOfHoofdsein(Sein^.Plaats, VolgendSein, false, zvsHoofdsein);
	if assigned(VolgendSein) then
		VolgendeMeetpunt := VolgendSein^.B_Meetpunt
	else
		VolgendeMeetpunt := nil;

	// Zowel voor een autosein als voor een bediend sein moeten we de snelheid
	// weten die na het sein gereden mag worden.
	SporenTotVolgendSeinLijst := ZoekSporenTotVolgendHoofdsein(Sein^.Plaats, zstvhHoofdsein+zstvhSnelheidsbordje);
	tmpRail := SporenTotVolgendSeinLijst;
	MovementAuthority.Baanvaksnelheid := true;
	while assigned(tmpRail) do begin
		if (tmpRail^.Rail^.MaxSnelheid >= 0) then
			if MovementAuthority.Baanvaksnelheid then begin
				MovementAuthority.Baanvaksnelheid := false;
				MovementAuthority.Snelheidsbeperking := tmpRail^.Rail^.MaxSnelheid
			end else if tmpRail^.Rail^.MaxSnelheid < MovementAuthority.Snelheidsbeperking then
				MovementAuthority.Snelheidsbeperking := tmpRail^.Rail^.MaxSnelheid;
		tmpRail := tmpRail^.volgende;
	end;
	// Raillijst aanpassen, vanaf nu gaan we kijken of sporen vrij zijn en dan
	// moeten we echt helemaal tot het volgende sein kijken.
	RaillijstWissen(SporenTotVolgendSeinLijst);
	SporenTotVolgendSeinLijst := ZoekSporenTotVolgendHoofdsein(Sein^.Plaats, zstvhHoofdsein);
	// Is het een autosein, dan zoeken we het meetpunt op en passen het seinbeeld
	// aan.
	if Sein^.Autosein then begin
		H_terugoprood := false;
		// Kijk of de rails na het autosein vrij zijn.
		RailsBezet := false;
		tmpRail := SporenTotVolgendSeinLijst;
		while assigned(tmpRail) do begin
			if assigned(tmpRail^.Rail^.Meetpunt) then begin
				Meetpunt := tmpRail^.Rail^.Meetpunt;
				// We moeten het meetpunt negeren als het een meetpunt is dat van
				// voor tot achter het sein doorloopt. Sein moet ook in dat geval
				// namelijk wel op groen kunnen als er een trein vlak voor staat.
				if Meetpunt <> Sein^.B_Meetpunt then
					RailsBezet := RailsBezet or Meetpunt^.Bezet;
			end;
			tmpRail := tmpRail^.volgende;
		end;

		Meetpunt := Sein^.B_Meetpunt;

		// Rijrichting controleren
		if assigned(Sein^.A_Erlaubnis) then begin
			if PpErlaubnis(Sein^.A_Erlaubnis)^.richting = Sein^.A_Erlaubnisstand then
				// De Erlaubnis voor de hele vrije baan staat op de goede stand -> OK
				ErlaubnisOK := true
			else if PpErlaubnis(Sein^.A_Erlaubnis)^.standaardrichting = 0 then begin
				// Dit is een (dubbel-)enkelspoorbeveiliging.
				// Het werkt eigenlijk heel simpel. In de meetpunten wordt de
				// rijrichting opgeslagen, die plant zichzelf ook vanzelf voort.
				// Wij moeten dus alleen checken of dit sein overeenkomt met de
				// rijrichting van de meetpunten voor en na dit sein.
				// Uitzondering: in de hele vrije baan is geen rijrichting in-
				// gesteld. Dan is het ook goed.
				if PpErlaubnis(Sein^.A_Erlaubnis)^.richting = 0 then
					ErlaubnisOK := true
				else begin
					ErlaubnisOK := (Meetpunt^.rijrichting = Sein^.A_Erlaubnisstand);
					if assigned(VolgendeMeetpunt) then
						ErlaubnisOK := ErlaubnisOK and (VolgendeMeetpunt^.rijrichting = Sein^.A_Erlaubnisstand);
				end
			end else
				// De Erlaubnis staat op de verkeerde stand -> NIET OK
				ErlaubnisOK := false;
		end else
			// Dit sein heeft geen Erlaubnis -> OK
			ErlaubnisOK := true;

		// SEINBEELD INSTELLEN
		if (not RailsBezet) and ErlaubnisOK then begin
			// Yo! Spoor vrij! Sein op groen!
			MovementAuthority.HasAuthority := true;
			Sein^.H_MovementAuthority := MovementAuthority;
			// Bij een (dubbel-)enkelspoorbeveiliging moeten we de rijrichting
			// laten voortplanten.
			if assigned(Sein^.A_Erlaubnis) and assigned(VolgendeMeetpunt) then
				if (Meetpunt^.rijrichting = Sein^.A_Erlaubnisstand) and
					(VolgendeMeetpunt^.Erlaubnis = Sein^.A_Erlaubnis) and
					(VolgendeMeetpunt^.rijrichting <> Meetpunt^.rijrichting) then
						VolgendeMeetpunt^.rijrichting := Meetpunt^.rijrichting;
		end else
			if Sein^.H_MovementAuthority.HasAuthority then begin
				Sein^.H_MovementAuthority.HasAuthority := false;
				if RailsBezet then
					H_terugoprood := true;
			end;
		// Het sein is terug op rood gesprongen. Er is dus een trein gepasseerd.
		// We moeten dus het nummer mee-verplaatsen. Daarvoor moeten we twee
		// meetpunten vinden: die voor het sein en die na het sein.
		if H_terugoprood and Meetpunt^.Bezet then begin
			// Oude meetpunt: treinnaam wissen
			tmpNaam := Meetpunt^.Treinnaam;
			Meetpunt^.Treinnaam := '';
			Meetpunt^.veranderd := true;
			if assigned(VolgendeMeetpunt) then begin
				// Nieuwe meetpunt: treinnaam registreren.
				if (copy(tmpNaam,1,1)<>'*') or (copy(VolgendeMeetpunt^.Treinnaam,1,1)='*') or
					(VolgendeMeetpunt^.Treinnaam = '') then begin
					if tmpNaam <> '' then
						VolgendeMeetpunt^.Treinnaam := tmpNaam
					else
						if (VolgendeMeetpunt^.Treinnaam = '') or (copy(VolgendeMeetpunt^.Treinnaam,1,1)='*') then
							VolgendeMeetpunt^.Treinnaam := Sternummer;
					VolgendeMeetpunt^.veranderd := true;
				end;
				// Indien nodig een rijrichting instellen.
				if VolgendeMeetpunt^.rijrichting = 0 then begin
					ZoekVolgendVoorOfHoofdsein(VolgendSein^.Plaats, Sein2, false, zvsHoofdsein);
					if (not assigned(Sein2)) or (not Sein2^.Autosein) or Sein2^.H_MovementAuthority.HasAuthority then
						VolgendeMeetpunt^.rijrichting := Sein^.A_Erlaubnisstand;
				end;
			end;
		end;
		// En ook nog eventjes rijrichtingen doorgeven.
		if (PpMeetpunt(Sein^.B_Meetpunt)^.rijrichting = Sein^.A_Erlaubnisstand)
			and assigned(VolgendeMeetpunt) and (VolgendeMeetpunt^.rijrichting = 0) then
			VolgendeMeetpunt^.rijrichting := Sein^.A_Erlaubnisstand;
	end;
	// De stand van een bediend sein moeten we eventueel aanpassen.
	if Sein^.Bediend then begin
		case Sein^.Bediend_Stand of
			0: Sein^.H_MovementAuthority.HasAuthority := false;
			1: begin
				// Kijk of de rails na het sein vrij zijn.
				RailsBezet := false;
				tmpRail := SporenTotVolgendSeinLijst;
				while assigned(tmpRail) do begin
					if assigned(tmpRail^.Rail^.Meetpunt) then begin
						Meetpunt := tmpRail^.Rail^.Meetpunt;
						// We moeten het meetpunt negeren als het een meetpunt is dat
						// van voor tot achter het sein doorloopt. Sein moet ook in
						// dat geval namelijk wel op groen kunnen als er een trein
						// vlak voor staat.
						if Meetpunt <> Sein^.B_Meetpunt then
							RailsBezet := RailsBezet or Meetpunt^.Bezet;
					end;
					tmpRail := tmpRail^.volgende;
				end;
				if not RailsBezet then begin
					MovementAuthority.HasAuthority := true;
					Sein^.H_MovementAuthority := MovementAuthority;
				end;
			end;
			2: begin
				MovementAuthority.HasAuthority := true;
				if MovementAuthority.Baanvaksnelheid then begin
					MovementAuthority.Baanvaksnelheid := false;
					MovementAuthority.Snelheidsbeperking := rozsnelheid
				end else if MovementAuthority.Snelheidsbeperking > rozsnelheid then
					MovementAuthority.Snelheidsbeperking := rozsnelheid;
				Sein^.H_MovementAuthority := MovementAuthority;
			end;
		end;
	end;

	// Beperking checken
	Beperking := CalcBeperking(Sein, VolgendSein);
	if Beperking = 0 then
		Sein^.H_MovementAuthority.HasAuthority := false;
	if Beperking > 0 then
		if Sein^.H_MovementAuthority.Baanvaksnelheid then begin
			Sein^.H_MovementAuthority.Baanvaksnelheid := false;
			Sein^.H_MovementAuthority.Snelheidsbeperking := Beperking
		end else
			if Sein^.H_MovementAuthority.Snelheidsbeperking > Beperking then
				Sein^.H_MovementAuthority.Snelheidsbeperking := Beperking;

	// Defecten eventueel oplossen
	if Sein^.groendefect and (GetTijd > Sein^.groendefecttot) then
		Sein^.groendefect := false;
	if Sein^.geeldefect and (GetTijd > Sein^.geeldefecttot) then
		Sein^.geeldefect := false;
	// Defecten uitvoeren
	if (Sein^.Bediend or Sein^.Autosein) and not Sein^.Autovoorsein then begin
		if Sein^.groendefect then
			Sein^.H_MovementAuthority.HasAuthority := false;
	end;
	if Sein^.Autovoorsein and not (Sein^.Bediend or Sein^.Autosein) then begin
		if Sein^.groendefect then
			Sein^.V_AdviesAuthority.HasAuthority := false;
	end;
	if (Sein^.Bediend or Sein^.Autosein) and Sein^.Autovoorsein then begin
		if Sein^.groendefect and Sein^.V_AdviesAuthority.HasAuthority then
			Sein^.V_AdviesAuthority.HasAuthority := false;
		if Sein^.geeldefect and not Sein^.V_AdviesAuthority.HasAuthority then
			Sein^.H_MovementAuthority.HasAuthority := false;
	end;
	// Defecten eventueel maken
	Seinbeeld := CalcSeinbeeld(Sein);
	if Seinbeeld <> VorigeSeinbeeld then
		if GaatDefect(seindefectkans) then begin
			if Seinbeeld = sbGroen then begin
				Sein^.groendefect := true;
				Sein^.groendefecttot := GetTijd + MkTijd(0,seindefectmintijd,0)+
					round(random * (seindefectmaxtijd-seindefectmintijd)*MkTijd(0,1,0));
				SendMsg.SendDefectSeinMsg(Sein, sbGroen);
			end;
			if Seinbeeld = sbGeel then begin
				Sein^.geeldefect := true;
				Sein^.geeldefecttot := GetTijd + MkTijd(0,seindefectmintijd,0)+
					round(random * (seindefectmaxtijd-seindefectmintijd)*MkTijd(0,1,0));
				SendMsg.SendDefectSeinMsg(Sein, sbGeel);
			end;
		end;

	// Veranderd-status instellen
	if (Sein^.Bediend or Sein^.Autosein) then
		if not AuthorityIdentical(Sein^.H_MovementAuthority, Vorige_H_MovementAuthority) then
			Sein^.veranderd := true;

	// En opruimen.
	RaillijstWissen(SporenTotVolgendSeinLijst);
end;

procedure TpCore.DoeWissel;
begin
	case Wissel^.defect of
	wdHeel:
		if (Wissel^.stand <> Wissel^.nw_stand) and (GetTijd >= Wissel^.nw_tijd) then begin
			Wissel^.stand := Wissel^.nw_stand;
			Wissel^.veranderd := true;
		end;
	wdEenmalig:;	// niks, want de wissel doet pas weer wat als ie wordt omgezet
	wdDefect:;		// niks, want moet gerepareerd worden.
	end;
end;

function TpCore.ErlaubnisVrij;
var
	tmpMeetpuntl: PpMeetpuntLijst;
begin
	result := true;
	tmpMeetpuntl := Erlaubnis^.Meetpunten;
	while assigned(tmpMeetpuntl) do begin
		result := result and (not tmpMeetpuntl^.Meetpunt^.Bezet);
		tmpMeetpuntl := tmpMeetpuntl^.volgende;
	end;
end;

procedure TpCore.DoeErlaubnis;
var
	vrij: boolean;
	Meetpunt: PpMeetpuntLijst;
	richting: byte;
begin
	if not Erlaubnis^.check then exit;
	vrij := ErlaubnisVrij(Erlaubnis);
	if Erlaubnis^.vergrendeld then begin
		if vrij and (not Erlaubnis^.voorvergendeld) then begin
			// Vrije Erlaubnis die niet is voorvergrendeld vrijgeven
			Erlaubnis^.richting := Erlaubnis^.standaardrichting;
			Erlaubnis^.vergrendeld := false;
			Erlaubnis^.r_veranderd := true;
		end;
	end;
	// Niet vrije Erlaubnis vergrendelen
	if (not vrij) and (not Erlaubnis^.Vergrendeld) then begin
		Erlaubnis^.Vergrendeld := true;
		Erlaubnis^.r_veranderd := true;
	end;
	// Geaggregeerde rijrichting bijwerken
	if Erlaubnis^.standaardrichting = 0 then begin
		richting := 0;
		Meetpunt := Erlaubnis^.Meetpunten;
		while assigned(Meetpunt) do begin
			if Meetpunt^.Meetpunt^.rijrichting <> 0 then
				if richting = 0 then
					richting := Meetpunt^.Meetpunt^.rijrichting
				else if richting <> Meetpunt^.Meetpunt^.rijrichting then
					richting := 4;
			Meetpunt := Meetpunt^.Volgende;
		end;
		if (Erlaubnis^.richting <> richting) and not
			((richting = 0) and Erlaubnis^.voorvergendeld)  then begin
			Erlaubnis^.richting := richting;
			Erlaubnis^.r_veranderd := true; 
		end;
	end;
	// Geaggregeerde bezet-status bijwerken
	if Erlaubnis^.bezet = vrij then begin
		Erlaubnis^.bezet := not vrij;
		Erlaubnis^.b_veranderd := true;
	end;
end;

procedure TpCore.DoeOverweg;
begin
	if not (Overweg^.Status in [1,2,4]) then exit;
	if GetTijd > Overweg^.VolgendeStatusTijd then begin
		case Overweg^.Status of
			1: begin
				Overweg^.Status := 2;
				Overweg^.VolgendeStatusTijd := GetTijd+ovSluitTijd;
			end;
			2: begin
				Overweg^.Status := 3;
				Overweg^.VolgendeStatusTijd := -1;
				Overweg^.Veranderd := true;
			end;
			4: begin
				Overweg^.Status := 0;
				Overweg^.VolgendeStatusTijd := -1;
			end;
		end;
	end;
end;

procedure TpCore.DoeVerschijnen;
const
	ws = [#9, ' '];
var
	tmpTrein: PpTrein;
	tmpRail: PpRail;
	tmpPos: double;
	tmpAchteruit: boolean;

	k: double;
	magversch: boolean;

	VerschijnItem: PpVerschijnItem;
	tmpVerschijnItem: PpVerschijnItem;
	VerdwijnPunt: PpVerdwijnPunt;
	vt, rt: integer;
	Plaats: PpVerschijnPunt;
	// Veiligheid
	SporenTotVolgendSein: PpRailLijst;
	tmpRailL: PpRailLijst;
	tmpSein: PpSein;

	// Treinnummer op juiste plaats zetten!
	tmpConn: PpRailConn;
	Sein: PpSein;
	tmpRail2: PpRail;
	Meetpunt: PpMeetpunt;
	// Vertraging
	TreinInfo: PpTreinInfo;
begin
	VerschijnItem := VerschijnLijst;
	while assigned(VerschijnItem) do begin
		Plaats := VerschijnItem^.Plaats;
      if assigned(Plaats^.ScenarioVS) then
      	Plaats := Plaats^.ScenarioVS;
		if VerschijnItem^.gedaan or
			not (assigned(Plaats) and assigned(VerschijnItem^.wagons)) then begin
			VerschijnItem := VerschijnItem^.Volgende;
			continue;
		end;

		vt := VerschijnItem^.Tijd;
		magversch := GetTijd>=vt;
		if not magversch then
			// De lijst is gesorteerd op tijd. Zijn we dus aan dit item nog niet
			// toe, dan zijn we nog aan geen enkel volgend item toe.
			break;

		tmpRail := Plaats^.Rail;
		if not assigned(tmpRail) then begin
			VerschijnItem^.gedaan := true;
			raise EFysiekeWarning.Create('Rail van verschijnpunt '+Plaats^.Naam+' bestaat niet. Trein '+VerschijnItem^.Treinnummer+' is daarom niet verschenen.');
		end;

		magversch := true;
		rt := VerschijnItem^.Treinweg_Tijd;
		if (VerschijnItem^.treinweg_naam <> '-') and
			VerschijnItem^.treinweg_voldaan then
			magversch := GetTijd >= (rt + VerschijnItem^.treinweg_wachten);

		// Punctualiteit wordt gegeven volgens de norm van max. 2:59 minuten vertraagd
		k := Power(1-Punctualiteit, 1/(tps*60*3));
		magversch := magversch and ((random>=k) or (not Plaats^.vertragingmag) or CheatGeenDefecten);

		if magversch then begin
			// Weg tot volgend sein checken
			SporenTotVolgendSein := ZoekSporenTotVolgendHoofdseinR(tmpRail, Plaats^.achteruit);
			tmpRailL := SporenTotVolgendSein;
			while assigned(tmpRailL) do begin
				if assigned(tmpRailL^.Rail^.meetpunt) then
					magversch := magversch and not PpMeetpunt(tmpRailL^.Rail^.meetpunt)^.Bezet
				else
					// Op onbeveiligde rails kunnen we niet checken of het veilig is
					// om te verschijnen. Daar zou je wel wat op kunnen bedenken,
					// maar voor nu maar gewoon weigeren.
					magversch := false;
				tmpRailL := tmpRailL^.volgende;
			end;
			RaillijstWissen(SporenTotVolgendSein);

			if assigned(Plaats^.erlaubnis) then
				if (Plaats^.erlaubnis^.richting <> Plaats^.Erlaubnisstand) and
					Plaats^.erlaubnis^.vergrendeld then
					magversch := false;
		end;

		if magversch then begin
			VerschijnItem^.gedaan := true;

			// Alvast het volgende sein opvragen.
			// Mag ook slechts een voorsein zijn, in dat geval doen we straks niks
			// omdat we dan tot daar eerst maar gewoon baanvaksnelheid rijden.
			ZoekVolgendVoorOfHoofdsein(ZoekVolgendeConn(tmpRail, Plaats^.achteruit), tmpSein, true, zvsHoofdsein+zvsVoorsein);

			// Nieuwe trein maken
			new(tmpTrein);
			tmpTrein^ := TpTrein.Create;
			tmpTrein^.vorige := nil;
			tmpTrein^.volgende := pAlleTreinen;
			if assigned(pAlleTreinen) then
				pAlleTreinen^.Vorige := tmpTrein;
			pAlleTreinen := tmpTrein;

			tmpTrein^.vertraging := (GetTijd - vt) div MkTijd(0,1,0);
			tmpTrein^.vorigeaankomstvertraging := tmpTrein^.vertraging;

			// Rijplan instellen
			tmpTrein^.Treinnummer := VerschijnItem^.Treinnummer;
			tmpTrein^.Planpunten := CopyDienstFrom(tmpTrein^.Treinnummer,
				VerschijnItem^.vanafstation);

			// Trein op rails neerzetten
			tmpTrein^.pos_rail := tmpRail;

			tmpTrein^.pos_dist := Plaats^.afstand;
			tmpTrein^.achteruit := Plaats^.achteruit;
			case Plaats^.modus of
			1: tmpTrein^.Modus := tmStilstaan;
			2: tmpTrein^.Modus := tmRijden;
			end;
			if (tmpTrein^.Modus = tmStilstaan) then
				tmpTrein^.StationModusPlanpunt := tmpTrein^.GetVolgendRijplanpunt;

			tmpTrein^.CalcBezetteRails;

			// Snelheid instellen. Niet te snel.
			// Niet te snel houdt in dat we niet harder mogen rijden dan het
			// eerstvolgende sein aangeeft.
			tmpTrein^.baanvaksnelheid := Plaats^.baanvaksnelheid;
			tmpTrein^.snelheid := Plaats^.startsnelheid;
			if IsHoofdsein(tmpSein) then begin
				if tmpSein^.H_MovementAuthority.HasAuthority then
					if tmpSein^.H_MovementAuthority.Baanvaksnelheid then
						tmpTrein^.V_Adviessnelheid := -1
					else
						tmpTrein^.V_Adviessnelheid := tmpSein^.H_MovementAuthority.Snelheidsbeperking
				else
					tmpTrein^.V_Adviessnelheid := RemwegSnelheid
			end;
			if (tmpTrein^.snelheid > tmpTrein^.V_Adviessnelheid) and
				(tmpTrein^.V_Adviessnelheid > -1) then
				tmpTrein^.snelheid := tmpTrein^.V_Adviessnelheid;

			// Dit is al voorbereid
			tmpTrein^.EersteWagon := CopyWagons(VerschijnItem^.wagons);

			// Erlaubnis eventueel claimen.
			if assigned(Plaats^.erlaubnis) then
				// Checks hebben we eerder al gedaan!
				StelErlaubnisIn(Plaats^.erlaubnis, Plaats^.erlaubnisstand);

			// Treinnummer instellen
			if VerschijnItem^.Treinnummer <> '' then begin
				// Nieuwe meetpunt zoeken!
				if tmpTrein^.achteruit then
					tmpConn := tmpTrein^.pos_rail^.Vorige
				else
					tmpConn := tmpTrein^.pos_rail^.Volgende;
				ZoekVolgendVoorOfHoofdsein(tmpConn, Sein, true, zvsHoofdsein);
				tmpConn := Sein^.Plaats;
				tmpRail2 := tmpConn^.VanRail;

				// Nieuwe meetpunt: treinnaam registreren.
				Meetpunt := tmpRail2^.Meetpunt;
				Meetpunt^.Treinnaam := VerschijnItem^.Treinnummer;
				Meetpunt^.veranderd := true;
			end;

			// Vertraging bijwerken van onszelf en van evt. andere treinen die
			// eerder hadden moeten verschijnen.
			TreinInfo := ZoekOfMaakTreininfo(VerschijnItem^.Treinnummer);
			ScoreVertraging(TreinInfo, GetTijd-VerschijnItem^.Tijd, vtSchatting, '');
			tmpVerschijnItem := VerschijnLijst;
			while assigned(tmpVerschijnItem) and
				(tmpVerschijnItem <> VerschijnItem) do begin
				// Als tmpVerschijnItem = VerschijnItem, dan hebben we alle eerdere
				// items gehad.
				if not tmpVerschijnItem.gedaan then begin
					TreinInfo := ZoekOfMaakTreininfo(tmpVerschijnItem^.Treinnummer);
					ScoreVertraging(TreinInfo, GetTijd+MkTijd(0,1,0)-tmpVerschijnItem^.Tijd, vtSchatting, '');
				end;
				tmpVerschijnItem := tmpVerschijnItem^.Volgende;
			end;

			// En e.e.a. bijwerken
			DoeMeetpunten;
			DoeSeinen;
		end;
		VerschijnItem := VerschijnItem^.Volgende;
	end;

	VerdwijnPunt := pAlleVerdwijnpunten;
	while assigned(VerdwijnPunt) do begin
		tmpTrein := pAlleTreinen;
		while assigned(tmpTrein) do begin
			tmpTrein^.ZoekEinde(tmpRail, tmpAchteruit, tmpPos);
			if (tmpRail = VerdwijnPunt^.rail) and
				(tmpAchteruit = not VerdwijnPunt^.achteruit) then begin
				// De trein heeft zelfs met het einde de rail bereikt

				// Eerst de verschijnitems updaten;
				VerschijnItem := VerschijnLijst;
				while assigned(VerschijnItem) do begin
					if VerschijnItem^.treinweg_naam = tmpTrein^.Treinnummer then begin
						VerschijnItem^.treinweg_voldaan := true;
						VerschijnItem^.treinweg_tijd := GetTijd;
					end;
					VerschijnItem := VerschijnItem^.Volgende;
				end;

				// Vertragingsinformatie verwijderen
				DeleteTreininfo(tmpTrein^.Treinnummer);

				// Nu de trein wissen
				// We moeten dit netjes op deze manier afhandelen omdat er nog
				// telefoongesprekken actief kunnen zijn. En om een gesprek goed te
				// kunnen ophangen moet bekend zijn bij welke trein dat gesprek hoort.
				tmpTrein^.Wissen := true;
				tmpTrein^.modus := tmGecrasht;
			end;
			tmpTrein := tmpTrein^.Volgende;
		end;
		VerdwijnPunt := VerdwijnPunt^.Volgende;
	end;
end;

function TpCore.LoadRailString;
const
	ws = [#9, ' '];
var
	// Algemene variabelen
	waarde: string;
	index: integer;
	p: integer;
	code: integer;
	soort: string;
	// Spoor
	tmpRail: PpRailLijst;
	tmpConn: PpRailConn;
	i: integer;
	// Connectie
	rail1, rail2: PpRail;
	tmpConn1, tmpConn2: PpRailConn;
	tmpaft: boolean;
	f1, f2: boolean;
	tmpWissel: PpWissel;
	// Kruising
	rail3, rail4: PpRail;
	tmpConn3, tmpConn4: PpRailConn;
	f3, f4: boolean;
	// Seinen
	tmpSein: PpSein;
	tmpMeetpunt: PpMeetpunt;
	// Seinbeperking
	tmpSeinBeperking: PpSeinBeperking;
	// Erlaubnis
	tmpErlaubnis: PpErlaubnis;
	tmpMeetpuntLijst: PpMeetpuntLijst;
	// Verschijnen en verdwijnen
	tmpVerschijnpunt: PpVerschijnpunt;
	tmpVerdwijnpunt: PpVerdwijnpunt;
	// Overweg
	tmpOverweg:	PpOverweg;
begin
	result := false;
	// Even dat de compiler niet zeurt.
	tmpRail := nil;
	tmpConn1 := nil;
	tmpConn2 := nil;
	tmpConn3 := nil;
	tmpWissel := nil;
	rail1 := nil;
	rail2 := nil;
	rail3 := nil;
	rail4 := nil;
	tmpaft := false;
	f1 := false;
	f2 := false;
	f3 := false;
	tmpSein := nil;
	tmpSeinBeperking := nil;
	tmpMeetpunt := nil;
	tmpVerschijnpunt := nil;
	tmpVerdwijnpunt := nil;
	tmpErlaubnis := nil;

	index := 0;
	if copy(s,1,1)<>'#' then
		while s <> '' do begin
			// Whitespace van het begin schrappen.
			while (s <> '') and (s[1] in ws) do
				s := copy(s, 2, length(s)-1);
			if s='' then break;
			p := 1;
			while (p <= length(s)) and not(s[p] in ws) do
				inc(p);
			waarde := copy(s, 1, p-1);
			s := copy(s, p+1, length(s)-p);
			// Als eerste bepalen we wat voor soort ding we maken.
			if index = 0 then
				soort := waarde
			// En dan komt een reuzen-IF voor de rest!
			else if soort = 'r' then begin				// RAIL!
				case index of
				1: begin
						// Nieuwe rail maken.
						new(tmpRail);
						tmpRail.Volgende := pAlleRails;
						pAlleRails := tmpRail;
						new(tmpRail^.Rail);
						// Twee nieuwe connecties maken.
						for i := 1 to 2 do begin
							new(tmpConn);
							tmpConn^.isolatiepunt := true; // Anders loopt meetpunt vast.
							tmpConn^.VanRail := tmpRail^.Rail;
							tmpConn^.sein := nil;
							tmpConn^.wissel := false;
							tmpConn^.kruising := false;
							tmpConn^.recht := tmpRail^.Rail;
							tmpConn^.aftakkend := nil;
							// Een trein die voorbij het einde van het spoor
							// probeert te rijden veert zo terug en blijft dus
							// op een gedefinieerde plaats.
							tmpConn^.r_foutom := i=2;
							tmpConn^.a_foutom := false;
							tmpConn^.WisselData := nil;
							if i=1 then tmpRail^.Rail^.Vorige := tmpConn;
							if i=2 then tmpRail^.Rail^.Volgende := tmpConn;
						end;
						tmpRail^.Rail^.Naam := Waarde;
						tmpRail^.Rail^.meetpunt := nil;
						tmpRail^.Rail^.MaxSnelheid := -1;
					end;
				2: begin
						val(waarde, tmpRail^.Rail^.Lengte, code);
						if code <> 0 then
							begin Leesfout_melding := 'Lengte is geen getal'; exit end;
					end;
				3: if waarde <> '-' then begin
						val(waarde, tmpRail^.Rail^.MaxSnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Maximumsnelheid is geen getal'; exit end;
					end;
				4: tmpRail^.Rail^.elektrif := (waarde = 'j') or (waarde = 'J');
				else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'c' then begin	// CONNECTIE!
				case index of
				1: begin
						rail1 := ZoekRail(waarde);
						if not assigned(rail1) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				2: if (waarde='e') or (waarde='E') then begin
						tmpConn1 := rail1^.Volgende;
						f1 := true;
					end else begin
						tmpConn1 := rail1^.Vorige;
						f1 := false;
					end;
				3: begin
						rail2 := ZoekRail(waarde);
						if not assigned(rail2) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				4: if (waarde='e') or (waarde='E') then begin
						tmpConn2 := rail2^.Volgende;
						f2 := true;
					end else begin
						tmpConn2 := rail2^.Vorige;
						f2 := false;
					end;
				5: begin
						tmpaft := (waarde = 'j') or (waarde = 'J');
						tmpConn2.recht := rail1;
						tmpConn2.r_foutom := f1;
						if not tmpaft then begin
							tmpConn1.recht := rail2;
							tmpConn1.r_foutom := f2;
							tmpConn2.recht := rail1;
							tmpConn2.r_foutom := f1;
						end else begin
							tmpConn1.wissel := true;
							tmpConn1.aftakkend := rail2;
							tmpConn1.a_foutom := f2;
						end;
						if tmpAft then begin
							new(tmpWissel);
                     InitWisselState(tmpWissel);
							tmpWissel^.vanwie := nil;
						end;
					end;
				6: if not tmpaft then begin
						tmpConn1.isolatiepunt := (waarde = 'j') or (waarde = 'J');
						tmpConn2.isolatiepunt := (waarde = 'j') or (waarde = 'J');
					end;
				7: if tmpaft then begin
						tmpConn1^.WisselData := ZoekWissel(waarde);
						if assigned(tmpConn1^.WisselData) then
							dispose(tmpWissel)
						else begin
							tmpWissel^.w_naam := waarde;
							tmpWissel^.volgende := pAlleWissels;
							pAlleWissels := tmpWissel;
							tmpConn1^.WisselData := tmpWissel;
						end;
					end;
				8: if waarde <> '-' then
						if tmpaft then begin
							tmpMeetpunt := ZoekMeetpunt(waarde);
							if not assigned(tmpMeetpunt) then
								begin Leesfout_melding := 'Meetpunt '+waarde+' niet gevonden.'; exit end;
							tmpConn1^.WisselData^.Meetpunt := tmpMeetpunt;
						end else
							begin Leesfout_melding := 'Meetpunt opgegeven terwijl hier geen wissel is.'; exit end;
				else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'x' then begin	// KRUISING!
				(*   *  ***  *   *  ***  ***** ***  *   * **** *   *  ***
				 ** ** *   * **  * *       *   *  * *   * *    *   * *
				 * * * *   * * * *  ***    *   ***  *   * ***  *   *  ***
				 *   * *   * *  **     *   *   *  * *   * *    *   *     *
				 *   *  ***  *   *  ***    *   *  *  **** ****  ****  ***   *)
				// Want een kruising is een ontiegelijk irritant kutding,
				// bestaande uit vier niet-bedienbare driewegwissels.
				case index of
				1: begin
						rail1 := ZoekRail(waarde);
						if not assigned(rail1) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				2: if (waarde='e') or (waarde='E') then begin
						tmpConn1 := rail1^.Volgende;
						f1 := true;
					end else begin
						tmpConn1 := rail1^.Vorige;
						f1 := false;
					end;
				3: begin
						rail2 := ZoekRail(waarde);
						if not assigned(rail2) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				4: if (waarde='e') or (waarde='E') then begin
						tmpConn2 := rail2^.Volgende;
						f2 := true;
					end else begin
						tmpConn2 := rail2^.Vorige;
						f2 := false;
					end;
				5: begin
						rail3 := ZoekRail(waarde);
						if not assigned(rail3) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				6: if (waarde='e') or (waarde='E') then begin
						tmpConn3 := rail3^.Volgende;
						f3 := true;
					end else begin
						tmpConn3 := rail3^.Vorige;
						f3 := false;
					end;
				7: begin
						rail4 := ZoekRail(waarde);
						if not assigned(rail4) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				8: begin
						if (waarde='e') or (waarde='E') then begin
							tmpConn4 := rail4^.Volgende;
							f4 := true;
						end else begin
							tmpConn4 := rail4^.Vorige;
							f4 := false;
						end;
						// ZOOOOOO!!! EINDELIJK HEBBEN WE ALLE GEGEVENS DIE WE
						// NODIG HEBBEN! JOEPIE! HOEZEE!
						tmpConn1.recht := rail2;
						tmpConn1.r_foutom := f2;
						tmpConn1.aftakkend := rail4;
						tmpConn1.a_foutom := f4;
						tmpConn1.kr3rail := rail3;
						tmpConn1.kr3_foutom := f3;
						tmpConn1.isolatiepunt := false;
						tmpConn1.kruising := true;
						tmpConn2.recht := rail1;
						tmpConn2.r_foutom := f1;
						tmpConn2.aftakkend := rail3;
						tmpConn2.a_foutom := f3;
						tmpConn2.kr3rail := rail4;
						tmpConn2.kr3_foutom := f4;
						tmpConn2.isolatiepunt := false;
						tmpConn2.kruising := true;
						tmpConn3.recht := rail4;
						tmpConn3.r_foutom := f4;
						tmpConn3.aftakkend := rail2;
						tmpConn3.a_foutom := f2;
						tmpConn3.kr3rail := rail1;
						tmpConn3.kr3_foutom := f1;
						tmpConn3.isolatiepunt := false;
						tmpConn3.kruising := true;
						tmpConn4.recht := rail3;
						tmpConn4.r_foutom := f3;
						tmpConn4.aftakkend := rail1;
						tmpConn4.a_foutom := f1;
						tmpConn4.kr3rail := rail2;
						tmpConn4.kr3_foutom := f2;
						tmpConn4.isolatiepunt := false;
						tmpConn4.kruising := true;
					end;
				else
					begin Leesfout_melding := 'Te veel parameters.'; exit end;
				end;
			end else if soort = 's' then begin	// SEIN!
				case index of
				1: begin
						new(tmpSein);
						tmpSein^.volgende := pAlleSeinen;
						pAlleSeinen := tmpSein;
						tmpSein^.Autosein := false;
						tmpSein^.A_Erlaubnis := nil;
						tmpSein^.A_Erlaubnisstand := 0;
						tmpSein^.Stationsnaam := '';
						tmpSein^.vanwie := nil;
						tmpSein^.Autovoorsein := false;
						tmpSein^.H_Baanmaxsnelheid := -1;
						tmpSein^.V_Baanmaxsnelheid := -1;
						tmpSein^.B_Meetpunt := nil;
						InitSeinState(tmpSein);
						rail1 := ZoekRail(waarde);
						if not assigned(rail1) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					end;
				2: if (waarde='e') or (waarde='E') then begin
						tmpConn1 := rail1^.Volgende;
						f1 := true;
					end else begin
						tmpConn1 := rail1^.Vorige;
						f1 := false;
					end;
				3: begin
						rail2 := ZoekRail(waarde);
						if not assigned(rail2) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
						if rail2 <> tmpConn1.recht then
							begin Leesfout_melding := 'Genoemde sporen zitten niet (of niet recht) aan elkaar bevestigd.'; exit end;
					end;
				4: begin
						if (waarde='e') or (waarde='E') then begin
							if not tmpConn1.r_foutom then
								begin Leesfout_melding := 'De rails zitten andersom aan elkaar bevestigd.'; exit end;
						end else begin
							if tmpConn1.r_foutom then
								begin Leesfout_melding := 'De rails zitten andersom aan elkaar bevestigd.'; exit end;
						end;
						// Nu is alles correct.
						TmpConn1.sein := tmpSein;
						tmpSein^.Plaats := tmpConn1;
					end;
				5: tmpSein^.naam := waarde;
				6: begin
						tmpSein^.Bediend := (waarde = 'j') or (waarde = 'J');
						tmpSein^.Autosein := (waarde = 'a') or (waarde = 'A')
					end;
				7: if waarde <> '-' then begin
						tmpErlaubnis := ZoekErlaubnis(waarde);
						if not assigned(tmpErlaubnis) then
							begin Leesfout_melding := 'Rijrichtingsveld '+waarde+' niet gevonden.'; exit end;
						tmpSein^.A_Erlaubnis := tmpErlaubnis;
					end;
				8: if waarde <> '-' then begin
						val(waarde, tmpSein^.A_Erlaubnisstand, code);
						if (code <> 0) or (not assigned(tmpSein^.A_Erlaubnis)) then
							begin Leesfout_melding := 'Stand voor rijrichtingsveld: Is geen getal, of er is geen rijrichtingsveld opgegeven.'; exit end;
					end else
						if assigned(tmpSein^.A_Erlaubnis) then
							begin Leesfout_melding := 'Als een sein aan een rijrichtingsveld gekoppeld wordt, moet ook een richting worden opgegeven.'; exit end;
				9: if waarde <> '-' then begin
						val(waarde, tmpSein^.H_Baanmaxsnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Maximumsnelheid sein: Is geen getal, of het sein is bediend of een autosein.'; exit end;
					end;
				10: tmpSein^.Autovoorsein := (waarde = 'j') or (waarde = 'J');
				11: if waarde <> '-' then begin
						val(waarde, tmpSein^.V_Baanmaxsnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Snelheidsaankondiging sein: Is geen getal, of het sein is een autovoorsein.'; exit end;
					end;
				12: tmpSein^.Haltevoorsein := (waarde = 'j') or (waarde = 'J');
				13: if waarde <> '-' then begin
						if tmpSein^.Haltevoorsein then
							begin Leesfout_melding := 'Bij een stationsaankondiging hoort geen perronnummer.'; exit end;
						tmpSein^.Perronnummer := waarde;
					end;
				14: if waarde <> '-' then begin
						tmpSein^.Stationsnaam := waarde;
						if not tmpSein^.Haltevoorsein then
							tmpSein^.Perronpunt := true
						else
							tmpSein^.Perronpunt := false
					end;
				else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'b' then begin	// SEINBEPERKING!
				case index of
				1: begin
						new(tmpSeinBeperking);
						tmpSeinBeperking^.volgende := pAlleSeinBeperkingen;
						pAlleSeinBeperkingen := tmpSeinBeperking;
						tmpSein := ZoekSein(waarde);
						if not assigned(tmpSein) then
							begin Leesfout_melding := 'Sein '+waarde+' niet gevonden.'; exit end;
						tmpSeinBeperking^.Vansein := tmpSein;
					end;
				2: begin
						val(waarde, tmpSeinBeperking^.Beperking, code);
						if code <> 0 then
							begin Leesfout_melding := 'Beperking is geen getal (km/u).'; exit end;
					end;
				3: begin
						tmpSein := ZoekSein(waarde);
						if not assigned(tmpSein) then
							begin Leesfout_melding := 'Sein '+waarde+' niet gevonden.'; exit end;
						tmpSeinBeperking^.Naarsein := tmpSein;
					end;
				4: begin
						val(waarde, tmpSeinBeperking^.Triggersnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Triggersnelheid van doelsein is geen getal (km/u).'; exit end;
					end;
				else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'm' then begin	// MEETPUNT!
				case index of
				1: begin
						new(tmpMeetpunt);
						tmpMeetpunt^ := TpMeetpunt.Create;
						rail1 := ZoekRail(waarde);
						if not assigned(rail1) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
						tmpMeetpunt^.Rail := rail1;
						tmpMeetpunt^.vanwies := nil;
						tmpMeetpunt^.volgende := pAlleMeetpunten;
						tmpMeetpunt^.Erlaubnis := nil;
						InitMeetpuntState(tmpMeetpunt);
						pAlleMeetpunten := tmpMeetpunt;
					end;
				2:	tmpMeetpunt^.Naam := waarde;
				3: begin
						if waarde <> '-' then begin
							tmpErlaubnis := ZoekErlaubnis(waarde);
							if not assigned(tmpErlaubnis) then
								begin Leesfout_melding := 'Rijrichtingsveld '+waarde+' niet gevonden.'; exit end;
							new(tmpMeetpuntLijst);
							tmpMeetpuntLijst^.Meetpunt := tmpMeetpunt;
							tmpMeetpuntLijst^.Volgende := tmpErlaubnis^.Meetpunten;
							tmpErlaubnis^.Meetpunten := tmpMeetpuntLijst;
							tmpMeetpunt^.Erlaubnis := tmpErlaubnis;
						end;
					end;
				else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'e' then begin	// RIJRICHTING!
				case index of
				1: begin
					new(tmpErlaubnis);
					tmpErlaubnis^.Meetpunten := nil;
					tmpErlaubnis^.standaardrichting := 0;
					tmpErlaubnis^.naam := waarde;
					tmpErlaubnis^.volgende := pAlleErlaubnisse;
					tmpErlaubnis^.vanwies := nil;
					InitErlaubnisState(tmpErlaubnis);
					pAlleErlaubnisse := tmpErlaubnis;
				end;
				2: begin
					val(waarde, tmpErlaubnis^.standaardrichting, code);
					if (code <> 0) then
						begin Leesfout_melding := 'Standaardrichting is geen getal.'; exit end;
					tmpErlaubnis^.richting := tmpErlaubnis^.standaardrichting;
				end
				else
					begin Leesfout_melding := 'Te veel parameters.'; exit end;
				end;
			end else if soort = 'o' then begin	// OVERWEG
				if index = 1 then begin
					new(tmpOverweg);
					tmpOverweg^.Naam := waarde;
					tmpOverweg^.volgende := pAlleOverwegen;
					tmpOverweg^.vanwie := nil;
					InitOverwegState(tmpOverweg);
					pAlleOverwegen := tmpOverweg;
				end else
					begin Leesfout_melding := 'Te veel parameters.'; exit end;
			end else if soort = 'vs' then begin	// VERSCHIJNPUNT
				case index of
				1: begin
						new(tmpVerschijnpunt);
						tmpVerschijnpunt^.Naam := Waarde;
						tmpVerschijnpunt^.rail := nil;
						tmpVerschijnpunt^.vertragingmag := false;
						tmpVerschijnpunt^.afstand := 0;
						tmpVerschijnpunt^.achteruit := false;
						tmpVerschijnpunt^.modus := 1;
						tmpVerschijnpunt^.startsnelheid := 0;
						tmpVerschijnpunt^.erlaubnis := nil;
						tmpVerschijnpunt^.erlaubnisstand := 0;
						tmpVerschijnpunt^.ScenarioVS := nil;
						tmpVerschijnpunt^.Volgende := pAlleVerschijnpunten;
						pAlleVerschijnpunten := tmpVerschijnpunt;
					end;
				2: tmpVerschijnpunt^.vertragingmag := (waarde='j') or (waarde='J');
				3: begin
						tmpVerschijnpunt^.rail := ZoekRail(waarde);
						if not assigned(tmpVerschijnpunt^.rail) then
							begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
						if assigned(tmpVerschijnpunt^.rail^.Meetpunt) then
							PpMeetpunt(tmpVerschijnpunt^.rail^.Meetpunt)^.magdefect := false;
					end;
				4: begin
						val(waarde, tmpVerschijnpunt^.afstand, code);
						if code <> 0 then
							begin Leesfout_melding := 'Afstand is geen getal.'; exit end;
					end;
				5: if (waarde = 'A') or (waarde = 'a') then
						tmpVerschijnpunt^.achteruit := true
					else if (waarde = 'V') or (waarde = 'v') then
						tmpVerschijnpunt^.achteruit := false
					else
						begin Leesfout_melding := 'Richting moet a (van achteruit) of v (van vooruit) zijn.'; exit end;
				6: if (waarde = 'R') or (waarde = 'r') then
						tmpVerschijnpunt^.Modus := 2
					else if (waarde = 'S') or (waarde = 's') then
						tmpVerschijnpunt^.Modus := 1
					else
						begin Leesfout_melding := 'Modus moet r (van rijdend) of s (van stilstaand) zijn.'; exit end;
				7: begin
						val(waarde, tmpVerschijnpunt^.startsnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Startsnelheid is geen getal.'; exit end;
					end;
				8: begin
						val(waarde, tmpVerschijnpunt^.baanvaksnelheid, code);
						if code <> 0 then
							begin Leesfout_melding := 'Baanvaksnelheid is geen getal.'; exit end;
					end;
				9: begin
						if waarde <> '-' then begin
							tmpVerschijnpunt^.erlaubnis := ZoekErlaubnis(waarde);
							if not assigned(tmpVerschijnpunt^.erlaubnis) then
								begin Leesfout_melding := 'Rijrichtingsveld '+waarde+' niet gevonden.'; exit end;
						end;
					end;
				10: begin
						if waarde <> '-' then begin
							val(waarde, tmpVerschijnpunt^.erlaubnisstand, code);
							if code <> 0 then
								begin Leesfout_melding := 'Rijrichting is geen getal.'; exit end;
						end else
							if assigned(tmpVerschijnpunt^.erlaubnis) then
								begin Leesfout_melding := 'Rijrichting opgegeven zonder bijbehorend rijrichtingsveld.'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'vd' then begin	// VERDWIJNPUNT
				case index of
				1: begin
					new(tmpVerdwijnpunt);
					tmpVerdwijnpunt^.rail := ZoekRail(waarde);
					if not assigned(tmpVerdwijnpunt^.rail) then
						begin Leesfout_melding := 'Rail '+waarde+' niet gevonden.'; exit end;
					tmpVerdwijnpunt^.Volgende := pAlleVerdwijnpunten;
					pAlleVerdwijnpunten := tmpVerdwijnpunt;
				end;
				2: begin
					if (waarde = 'V') or (waarde = 'v') then
						tmpVerdwijnpunt^.achteruit := false
					else if (waarde = 'A') or (waarde = 'a') then
						tmpVerdwijnpunt^.achteruit := true
					else
						begin Leesfout_melding := 'Richting moet a (van achteruit) of v (van vooruit) zijn.'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else
				begin Leesfout_melding := 'Dit commando bestaat niet.'; exit end;	// Verkeerde 'soort' opgegeven.
			inc(index);
		end;
	result := true;
end;

function TpCore.LoadScenarioString;
const
	ws = [#9, ' '];
var
	// Algemene variabelen
	waarde: string;
	index: integer;
	p: integer;
	soort: string;
	kommagetal: double;
	code: integer;
	// Seinen
	tmpMeetpunt: PpMeetpunt;
	// Verschijnen
	tmpOudeVerschijnpunt: PpVerschijnpunt;
	tmpVerschijnpuntBkp: PpVerschijnpunt;
	tmpHierVerschijnpunt: PpVerschijnpunt;
begin
	result := false;
	// Even dat de compiler niet zeurt.
	tmpOudeVerschijnpunt := nil;

	index := 0;
	if copy(s,1,1)<>'#' then
		while s <> '' do begin
			// Whitespace van het begin schrappen.
			while (s <> '') and (s[1] in ws) do
				s := copy(s, 2, length(s)-1);
			if s='' then break;
			p := 1;
			while (p <= length(s)) and not(s[p] in ws) do
				inc(p);
			waarde := copy(s, 1, p-1);
			s := copy(s, p+1, length(s)-p);
			// Als eerste bepalen we wat voor soort ding we maken.
			if index = 0 then
				soort := waarde
			// En dan komt een reuzen-IF voor de rest!
			else if soort = 'k' then begin				// KORTSLUITLANS
				case index of
				1: begin
					tmpMeetpunt := ZoekMeetpunt(waarde);
					if not assigned(tmpMeetpunt) then
						begin Leesfout_melding := 'Meetpunt '+waarde+' niet gevonden'; exit end;
					// Stel de kortsluitlans in
					tmpMeetpunt^.kortsluitlans := true;
					tmpMeetpunt^.kortsluitlansiswegensscenario := true;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'vsv' then begin	// VERSCHIJN VERKEERD SPOOR
				case index of
				1: begin
					tmpOudeVerschijnpunt := pAlleVerschijnpunten;
					while assigned(tmpOudeVerschijnpunt) do
						if tmpOudeVerschijnpunt^.Naam = waarde then
							break
						else
							tmpOudeVerschijnpunt := tmpOudeVerschijnpunt^.Volgende;
					if not assigned(tmpOudeVerschijnpunt) then
						begin Leesfout_melding := 'Verschijnpunt '+waarde+' niet gevonden'; exit end;
				end;
				2: begin
					tmpHierVerschijnpunt := pAlleVerschijnpunten;
					while assigned(tmpHierVerschijnpunt) do
						if tmpHierVerschijnpunt^.Naam = waarde then
							break
						else
							tmpHierVerschijnpunt := tmpHierVerschijnpunt^.Volgende;
					if not assigned(tmpHierVerschijnpunt) then
						begin Leesfout_melding := 'Verschijnpunt '+waarde+' niet gevonden'; exit end;
					new(tmpVerschijnpuntBkp);
					tmpVerschijnpuntBkp^ := tmpOudeVerschijnpunt^;
					tmpOudeVerschijnpunt^ := tmpHierVerschijnpunt^;
					tmpOudeVerschijnpunt^.Naam := tmpVerschijnpuntBkp^.Naam;
					tmpOudeVerschijnpunt^.Volgende := tmpVerschijnpuntBkp^.Volgende;
					dispose(tmpVerschijnpuntBkp);
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'pct' then begin	// PUNCTUALITEIT
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if code = 0 then
						punctualiteit := kommagetal / 100
					else
						begin Leesfout_melding := 'Punctualiteitswaarde '+waarde+' is geen getal'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'wdk' then begin	// WISSEL-DEFECT-KANS
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if (code = 0) or (kommagetal < 1) then
						wisseldefectkans := 1 / kommagetal
					else
						begin Leesfout_melding := 'De waarde '+waarde+' voor de wissel-defect-kans is geen getal groter dan 1'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'wde' then begin	// WISSEL-ECHT-DEFECT-KANS
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if (code = 0) or (kommagetal < 1) then
						wisselechtdefectkans := 1 / kommagetal
					else
						begin Leesfout_melding := 'De waarde '+waarde+' voor de wissel-echt-defect-kans is geen getal groter dan 1'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'mdk' then begin	// MEETPUNT-DEFECT-KANS
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if (code = 0) or (kommagetal < 1) then
						meetpuntdefectbijtreinkans := 1 / kommagetal
					else
						begin Leesfout_melding := 'De waarde '+waarde+' voor de sectiestoring-kans is geen getal groter dan 1'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'sdk' then begin	// SEINSTORING-KANS
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if (code = 0) or (kommagetal < 1) then
						seindefectkans := 1 / kommagetal
					else
						begin Leesfout_melding := 'De waarde '+waarde+' voor de seinstoring-kans is geen getal groter dan 1'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'tdk' then begin	// TREIN-DEFECT-KANS
				case index of
				1: begin
					val(waarde, kommagetal, code);
					if (code = 0) or (kommagetal < 1) then
						treindefectkans := 1 / kommagetal
					else
						begin Leesfout_melding := 'De waarde '+waarde+' voor de trein-defect-kans is geen getal groter dan 1'; exit end;
				end else
					begin Leesfout_melding := 'Te veel parameters'; exit end;
				end;
			end else if (soort <> 'c') and (soort <> 'w') then
				begin Leesfout_melding := 'Dit commando bestaat niet.'; exit end;	// Verkeerde 'soort' opgegeven.
			inc(index);
		end;
	result := true;
end;

procedure TpCore.WagonsLaden;
const
	ws = [#9, ' '];
var
	f: text;
	s: string;
	tmpWagon: PpWagon;
	waarde: string;
	index: integer;
	p: integer;
	code: integer;
	Matfile:	PpMaterieelFile;
begin
	// Probeer het bestand te openen
	if (copy(FileDir, length(FileDir), 1) <> '\') and
		(FileDir <> '') then FileDir := FileDir + '\';
	Assign(f, FileDir+filenaam+'.ssm');
	Reset(f);
	new(Matfile);
	Matfile^.Filename := filenaam;
	Matfile^.Wagons := nil;
	Matfile^.Volgende := pMaterieel;
	pMaterieel := Matfile;
	tmpWagon := nil;
	while not eof(f) do begin
		// Maak een nieuwe wagon aan.
		if not assigned(tmpWagon) then begin
			new(tmpWagon);
			Matfile^.Wagons := tmpWagon;
		end else begin
			new(tmpWagon^.volgende);
			tmpWagon := tmpWagon^.volgende;
		end;
		tmpWagon^.volgende := nil;
		index := 0;
		readln(f, s);
		if copy(s,1,1)<>'#' then
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
				0: begin
						if pos(',', waarde) > 0 then
							raise EMatfileError.Create('Materieeltype mag geen komma bevatten: '+waarde);
						if copy(waarde,1,1) = '-' then
							raise EMatfileError.Create('Materieeltype mag niet ''-'' zijn');
						tmpWagon.naam := waarde;
					end;
				1: begin
						val(waarde, tmpWagon.lengte, code);
						if code <> 0 then
							raise EMatfileError.Create('Materieellengte is geen getal: '+waarde);
					end;
				2: begin
						val(waarde, tmpWagon.gewicht, code);
						if code <> 0 then
							raise EMatfileError.Create('Gewicht van materieel is geen getal: '+waarde);
						tmpWagon.gewicht := tmpWagon.gewicht * 1000;
					end;
				3: begin
						val(waarde, tmpWagon.vermogen, code);
						if code <> 0 then
							raise EMatfileError.Create('Vermogen van materieel is geen getal: '+waarde);
						tmpWagon.vermogen := tmpWagon.vermogen * 1000;
					end;
				4: begin
						val(waarde, tmpWagon.trekkracht, code);
						if code <> 0 then
							raise EMatfileError.Create('Trekkracht van materieel is geen getal: '+waarde);
						tmpWagon.trekkracht := tmpWagon.trekkracht * 1000;
					end;
				5: begin
						val(waarde, tmpWagon.remkracht, code);
						if code <> 0 then
							raise EMatfileError.Create('Remkracht van materieel is geen getal: '+waarde);
						tmpWagon.remkracht := tmpWagon.remkracht * 1000;
					end;
				6: begin
						val(waarde, tmpWagon.maxsnelheid, code);
						if code <> 0 then
							raise EMatfileError.Create('Maximumsnelheid van materieel is geen getal: '+waarde);
					end;
				7: begin
						val(waarde, tmpWagon.cw, code);
						if code <> 0 then
							raise EMatfileError.Create('cw-Waarde van materieel is geen getal: '+waarde);
					end;
				8: tmpWagon.elektrisch := (waarde = 'j') or (waarde = 'J');
				9: tmpWagon.bedienbaar := (waarde = 'j') or (waarde = 'J');
				10: tmpWagon.twbedienbaar := (waarde = 'j') or (waarde = 'J');
				else
					raise EMatfileError.Create('Te veel parameters voor materieel opgegeven');
				end;
				inc(index);
			end;
	end;
	closefile(f);
end;

procedure TpCore.WagonsWissen;
var
	tmpWagon: PpWagon;
	tmpMatfile: PpMaterieelFile;
begin
	while assigned(pMaterieel) do begin
		tmpMatfile := pMaterieel;
		while assigned(tmpMatfile^.Wagons) do begin
			tmpWagon := tmpMatfile^.Wagons;
			tmpMatfile^.Wagons := tmpMatfile^.Wagons^.volgende;
			dispose(tmpWagon);
		end;
		pMaterieel := pMaterieel^.Volgende;
		dispose(tmpMatfile);
	end;
end;

procedure TpCore.SaveInfraStatus;
var
	MeetpuntCount,
	ErlaubnisCount,
	SeinenCount,
	WisselCount,
	OverwegenCount,
	TreinInfoCount: integer;
	Meetpunt:		PpMeetpunt;
	Erlaubnis:		PpErlaubnis;
	Sein:				PpSein;
	Wissel:			PpWissel;
	Overweg:			PpOverweg;
	TreinInfo:		PpTreinInfo;
	i: integer;

	function VertragingTypeNaarByte(Soort: TpVertragingType): byte;
	begin
		case Soort of
			vtExact: result := 1;
			vtSchatting: result := 2;
			else result := 255;
		end;
	end;

begin
	// Aantallen uitrekenen
	MeetpuntCount := 0;
	Meetpunt := pAlleMeetpunten;
	while assigned(Meetpunt) do begin
		inc(MeetpuntCount);
		Meetpunt := Meetpunt^.Volgende;
	end;
	ErlaubnisCount := 0;
	Erlaubnis := pAlleErlaubnisse;
	while assigned(Erlaubnis) do begin
		inc(ErlaubnisCount);
		Erlaubnis := Erlaubnis^.Volgende;
	end;
	SeinenCount := 0;
	Sein := pAlleSeinen;
	while assigned(Sein) do begin
		inc(SeinenCount);
		Sein := Sein^.Volgende;
	end;
	WisselCount := 0;
	Wissel := pAlleWissels;
	while assigned(Wissel) do begin
		inc(WisselCount);
		Wissel := Wissel^.Volgende;
	end;
	OverwegenCount := 0;
	Overweg := pAlleOverwegen;
	while assigned(Overweg) do begin
		inc(OverwegenCount);
		Overweg := Overweg^.Volgende;
	end;
	TreinInfoCount := 0;
	TreinInfo := pAlleTreinInfo;
	while assigned(TreinInfo) do begin
		inc(TreinInfoCount);
		TreinInfo := TreinInfo^.Volgende;
	end;

	intwrite(f, MeetpuntCount);
	Meetpunt := pAlleMeetpunten;
	for i := 1 to MeetpuntCount do begin
		stringwrite(f, Meetpunt^.Naam);
		stringwrite(f, Meetpunt^.Treinnaam);
		boolwrite  (f, Meetpunt^.Defect);
		bytewrite  (f, Meetpunt^.rijrichting);
		Meetpunt := Meetpunt^.Volgende;
	end;

	intwrite(f, ErlaubnisCount);
	Erlaubnis := pAlleErlaubnisse;
	for i := 1 to ErlaubnisCount do begin
		stringwrite(f, Erlaubnis^.naam);
		bytewrite  (f, Erlaubnis^.richting);
		boolwrite  (f, Erlaubnis^.vergrendeld);
		boolwrite  (f, Erlaubnis^.voorvergendeld);
		Erlaubnis := Erlaubnis^.Volgende;
	end;

	intwrite(f, SeinenCount);
	Sein := pAlleSeinen;
	for i := 1 to SeinenCount do begin
		stringwrite(f, Sein^.naam);
		intwrite   (f, Sein^.Bediend_Stand);
		SaveMA     (f, Sein^.H_MovementAuthority); // Voor terug-op-rood-berekening
		boolwrite  (f, Sein^.groendefect);
		intwrite   (f, Sein^.groendefecttot);
		boolwrite  (f, Sein^.geeldefect);
		intwrite   (f, Sein^.geeldefecttot);
		Sein := Sein^.Volgende;
	end;

	intwrite(f, WisselCount);
	Wissel := pAlleWissels;
	for i := 1 to WisselCount do begin
		stringwrite(f, Wissel^.w_naam);
		bytewrite  (f, Ord(Wissel^.stand));
		bytewrite  (f, Ord(Wissel^.nw_stand));
		intwrite   (f, Wissel^.nw_tijd);
		bytewrite  (f, Ord(Wissel^.defect));
		boolwrite  (f, assigned(Wissel^.Monteur));
		Wissel := Wissel^.Volgende;
	end;

	intwrite(f, OverwegenCount);
	Overweg := pAlleOverwegen;
	for i := 1 to OverwegenCount do begin
		stringwrite(f, Overweg^.Naam);
		bytewrite  (f, Overweg^.Status);
		intwrite   (f, Overweg^.VolgendeStatusTijd);
		Overweg := Overweg^.Volgende;
	end;

	intwrite(f, TreinInfoCount);
	TreinInfo := pAlleTreinInfo;
	for i := 1 to TreinInfoCount do begin
		stringwrite(f, TreinInfo^.Treinnummer);
		intwrite(f, TreinInfo^.Vertraging);
		bytewrite(f, VertragingTypeNaarByte(TreinInfo^.Vertragingtype));
		stringwrite(f, TreinInfo^.Vertragingplaats);
		TreinInfo := TreinInfo^.Volgende;
	end;

	bytewrite	(f, Ord(pMonteur.Status));
	intwrite		(f, pMonteur.VolgendeStatusTijd);
	bytewrite	(f, Ord(pMonteur.Opdracht.Wat));
	stringwrite	(f, pMonteur.Opdracht.ID);

	intwrite(f, ScoreInfo.AankomstOpTijd);
	intwrite(f, ScoreInfo.AankomstBinnenDrie);
	intwrite(f, ScoreInfo.AankomstTeLaat);
	intwrite(f, ScoreInfo.VertragingVeroorzaakt);
	intwrite(f, ScoreInfo.VertragingVerminderd);
	intwrite(f, ScoreInfo.PerronCorrect);
	intwrite(f, ScoreInfo.PerronFout);

	intwrite(f, Tijd_t);
end;

procedure TpCore.LoadInfraStatus;
var
	MeetpuntCount,
	ErlaubnisCount,
	SeinenCount,
	WisselCount,
	OverwegenCount,
	TreinInfoCount:integer;
	MeetpuntNaam,
	ErlaubnisNaam,
	SeinNaam,
	WisselNaam,
	OverwegNaam,
	Treinnummer: 	string;
	Meetpunt:		PpMeetpunt;
	Erlaubnis:		PpErlaubnis;
	Sein:				PpSein;
	Wissel:			PpWissel;
	Overweg:			PpOverweg;
	TreinInfo:		PpTreinInfo;
	x:					byte;
	i: integer;
	ordnr:			byte;
	monteur:			boolean;

	function ByteNaarVertragingType(x: byte): TpVertragingType;
	begin
		case x of
			1: result := vtExact;
			2: result := vtSchatting;
			else result := vtSchatting;
		end;
	end;

begin
	intread(f, MeetpuntCount);
	for i := 1 to MeetpuntCount do begin
		stringread(f, MeetpuntNaam);	Meetpunt := ZoekMeetpunt(MeetpuntNaam);
		stringread(f, Meetpunt^.Treinnaam);
		boolread  (f, Meetpunt^.Defect);
		byteread  (f, Meetpunt^.rijrichting);
	end;

	intread(f, ErlaubnisCount);
	for i := 1 to ErlaubnisCount do begin
		stringread(f, ErlaubnisNaam);	Erlaubnis := ZoekErlaubnis(ErlaubnisNaam);
		byteread  (f, Erlaubnis^.richting);
		boolread  (f, Erlaubnis^.vergrendeld);
		boolread  (f, Erlaubnis^.voorvergendeld);
		Erlaubnis^.r_veranderd := true;
	end;

	intread(f, SeinenCount);
	for i := 1 to SeinenCount do begin
		stringread(f, SeinNaam);		Sein := ZoekSein(SeinNaam);
		intread   (f, Sein^.Bediend_Stand);
		Sein^.H_MovementAuthority := LoadMA(f);	// Voor terug-op-rood-berekening
		boolread  (f, Sein^.groendefect);
		intread   (f, Sein^.groendefecttot);
		boolread  (f, Sein^.geeldefect);
		intread   (f, Sein^.geeldefecttot);
	end;

	intread(f, WisselCount);
	for i := 1 to WisselCount do begin
		stringread(f, WisselNaam);		Wissel := ZoekWissel(WisselNaam);
		byteread  (f, ordnr);			Wissel^.Stand := TWisselStand(ordnr);
		byteread  (f, ordnr);			Wissel^.nw_stand := TWisselStand(ordnr);
		intread   (f, Wissel^.nw_tijd);
		byteread	 (f, ordnr);			Wissel^.defect := TpWisselDefect(ordnr);
		boolread	 (f, monteur);			if monteur then Wissel^.Monteur := pMonteur;
	end;

	intread(f, OverwegenCount);
	for i := 1 to OverwegenCount do begin
		stringread(f, OverwegNaam);	Overweg := ZoekOverweg(OverwegNaam);
		byteread  (f, Overweg^.Status);
		intread   (f, Overweg^.VolgendeStatusTijd);
	end;

	intread(f, TreinInfoCount);
	for i := 1 to TreinInfoCount do begin
		stringread(f, Treinnummer);   TreinInfo := ZoekOfMaakTreininfo(Treinnummer);
		intread(f, TreinInfo^.Vertraging);
		byteread(f, x); TreinInfo^.Vertragingtype := ByteNaarVertragingType(x);
		stringread(f, TreinInfo^.Vertragingplaats);
		TreinInfo^.gewijzigd := true;
	end;

	byteread		(f, ordnr);	pMonteur.Status := TpMonteurStatus(ordnr);
	intread		(f, pMonteur.VolgendeStatusTijd);
	byteread		(f, ordnr);	pMonteur.Opdracht.Wat := TpMonteurRepareerWat(ordnr);
	stringread	(f, pMonteur.Opdracht.ID);

	intread(f, ScoreInfo.AankomstOpTijd);
	intread(f, ScoreInfo.AankomstBinnenDrie);
	intread(f, ScoreInfo.AankomstTeLaat);
	intread(f, ScoreInfo.VertragingVeroorzaakt);
	intread(f, ScoreInfo.VertragingVerminderd);
	intread(f, ScoreInfo.PerronCorrect);
	intread(f, ScoreInfo.PerronFout);

	intread(f, Tijd_t);
end;

procedure TpCore.LaadMatDienstVerschijn;
var
	i, matfilecount: integer;
	s: string;
begin
	// Begin- en eindtijd lezen
	intread(f, starttijd);
	intread(f, stoptijd);
	// Zo. Nu gaan we beginnen. Eerst materieel inladen.
	intread(f, matfilecount);
	for i := 1 to matfilecount do begin
		stringread(f, s);
		try
			WagonsLaden(s)
		except
			on EInOutError do
				raise EFysiekeError.Create('Materieelbestand voor dienstregeling ontbreekt: '+s);
			on E: EMatfileError do
				raise EFysiekeError.Create(E.Message);
		end;
	end;
	// En de rest.
	pAlleDiensten := LaadTreindiensten(f, wat);
	VerschijnLijst := LaadVerschijnitems(f, wat, pMaterieel, pAlleVerschijnpunten);
end;

procedure TpCore.SaveMatDienstVerschijn;
var
	Matfilecount: integer;
	Matfile: PpMaterieelFile;
begin
	// Begin- en eindtijd schrijven
	intwrite(f, starttijd);
	intwrite(f, stoptijd);
	// Zo. Eerst materieel opslaan
	matfilecount := 0;
	Matfile := pMaterieel;
	while assigned(Matfile) do begin
		inc(matfilecount);
		Matfile := Matfile^.Volgende;
	end;
	intwrite(f, matfilecount);
	Matfile := pMaterieel;
	while assigned(Matfile) do begin
		stringwrite(f, Matfile^.Filename);
		Matfile := Matfile^.Volgende;
	end;
	// En de rest.
	SaveTreindiensten(f, wat, pAlleDiensten);
	SaveVerschijnitems(f, wat, VerschijnLijst);
end;

function TpCore.ZetWissel;
var
	zettijd: integer; // secondes
	Meetpunt: PpMeetpunt;
	Gesprek: PpTelefoongesprek;
begin
	Meetpunt := Wissel^.Meetpunt;
	if Meetpunt^.Bezet then begin
		result := false;
		exit;
	end else
		result := true;
	zettijd := round(random * 3)+3;
	Wissel^.nw_tijd := GetTijd + ZetTijd;
	Wissel^.nw_stand := stand;
	Wissel^.stand := wsOnbekend;
	Wissel^.veranderd := true;
	// Als er een monteur bezig is dan gaat het fout.
	if assigned(Wissel^.Monteur) then begin
		Wissel^.defect := wdDefect;
		Gesprek := NieuwTelefoongesprek(PpMonteur(Wissel^.Monteur), tgtBellen, true);
		Gesprek^.tekstX := 'Auw, dat waren mijn vingers!';
		Gesprek^.tekstXsoort := pmsVraagOK;
		Gesprek^.OphangenErg := true;
		PpMonteur(Wissel^.Monteur)^.Status := msWachten;
		exit;
	end;
	// Een 'eenmalig' defecte wissel werkt in principe weer.
	if Wissel^.defect = wdEenmalig then
		Wissel^.defect := wdHeel;
	// Maar een wissel kan ook stuk gaan.
	DoeWisselDefect(Wissel, true);
end;

procedure TpCore.DoeWisselDefect;
begin
	// Een wissel die werkt kan stuk gaan.
	if GaatDefect(wisseldefectkans) then begin
		if GaatDefect(wisselechtdefectkans) and magechtdefect then
			Wissel^.defect := wdDefect
		else
			Wissel^.defect := wdEenmalig;
		Wissel^.veranderd := true;
	end;
end;

procedure TpCore.DoeMeetpunten;
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := pAlleMeetpunten;
	while assigned(Meetpunt) do begin
		// Laat een meetpunt zichzelf updaten
		Meetpunt^.Update(pAlleTreinen);
		// Als er uit het niets patsboem een trein op een vrije baan met
		// enkelspoorbeveiliging staat, dan gingen we in eerdere versies een
		// rijrichting gokken, maar dat is toch geen slim idee.
		Meetpunt := Meetpunt^.Volgende;
	end;
end;

procedure TpCore.DoeSeinen;
var
	Sein:		PpSein;
begin
	Sein := pAlleSeinen;
	while assigned(Sein) do begin
		DoeSein(Sein);
		Sein := Sein^.volgende;
	end;
end;

procedure TpCore.DoeErlaubnisse;
var
	Erlaubnis: PpErlaubnis;
begin
	Erlaubnis := pAlleErlaubnisse;
	while assigned(Erlaubnis) do begin
		DoeErlaubnis(Erlaubnis);
		Erlaubnis := Erlaubnis^.Volgende;
	end;
end;

procedure TpCore.ZendErlaubnisse;
var
	Erlaubnis: PpErlaubnis;
begin
	Erlaubnis := pAlleErlaubnisse;
	while assigned(Erlaubnis) do begin
		SendMsg^.SendErlaubnisMsg(Erlaubnis);
		SendMsg^.SendErlaubnisAlsMeetpuntMsg(Erlaubnis);
		Erlaubnis := Erlaubnis^.Volgende;
	end;
end;

procedure TpCore.DoeWissels;
var
	Wissel: PpWissel;
begin
	Wissel := pAlleWissels;
	while assigned(Wissel) do begin
		DoeWissel(Wissel);
		Wissel := Wissel^.Volgende;
	end;
end;

procedure TpCore.ZendWissels;
var
	Wissel: PpWissel;
begin
	Wissel := pAlleWissels;
	while assigned(Wissel) do begin
		SendMsg^.SendWisselMsg(Wissel);
		Wissel := Wissel^.Volgende;
	end;
end;

procedure TpCore.ZendMeetpunten;
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := pAlleMeetpunten;
	while assigned(Meetpunt) do begin
		SendMsg^.SendMeetpuntMsg(Meetpunt);
		Meetpunt := Meetpunt^.Volgende;
	end;
end;

procedure TpCore.ZendTreinInfo;
var
	TreinInfo: PpTreinInfo;
begin
	TreinInfo := pAlleTreinInfo;
	while assigned(TreinInfo) do begin
		SendMsg^.SendTreinInfo(TreinInfo);
		TreinInfo := TreinInfo^.Volgende;
	end;
end;

procedure TpCore.ZendSeinen;
var
	Sein:		PpSein;
begin
	Sein := pAlleSeinen;
	while assigned(Sein) do begin
		SendMsg^.SendSeinMsg(Sein);
		Sein := Sein^.volgende;
	end;
end;

function TpCore.TreinenDoenIets;
var
	Trein: PpTrein;
begin
	result := false;
	Trein := pAlleTreinen;
	while assigned(Trein) do begin
		if Trein^.modus = tmRijden then begin
			result := true;
			exit;
		end;
		Trein := Trein^.Volgende;
	end;
end;

// We moeten hier doen:
// - Automatische hoofd- en voorseinen schakelen
// - Externe connecties afhandelen
procedure TpCore.DoeStapje;
var
	Overweg:		PpOverweg;
begin

	DoeVerschijnen;
	DoeWissels;
	DoeMeetpunten;
	DoeErlaubnisse;
	DoeSeinen;

	// ZendErlaubnisse moet voor ZendMeetpunten, zodat bij het registreren van
	// een treinnummer altijd de stand van de erlaubnis bekend is en er dus
	// correct bepaald kan worden of een aankondiging nodig is.
	ZendErlaubnisse;
	ZendMeetpunten;
	ZendWissels;
	ZendSeinen;
	ZendTreinInfo;

	// Overwegen doen
	Overweg := pAlleOverwegen;
	while assigned(Overweg) do begin
		DoeOverweg(Overweg);
		SendMsg^.SendOverwegMsg(Overweg);
		Overweg := Overweg^.Volgende;
	end;

	// Zet de huidige tijd een stapje verder.
	inc(Tijd_t);
	if Tijd_t = tps then begin
		Tijd_t := 0;
		SetTijd(GetTijd+1);
	end;
end;

procedure TpCore.StartUp;
var
	Meetpunt: PpMeetpunt;
	Raillijst: PpRailLijst;
	VerschijnItem: PpVerschijnItem;
	Trein: PpTrein;

	function mtl(s: string; g: integer): string;
	begin
		result := s;
		while length(result)<g do
			result := '0'+result;
	end;

begin
	// Dit verandert toch niet meer.
	SendMsg.pAlleMeetpunten := pAlleMeetpunten;

	// Meetpunten en seinen actualiseren
	Meetpunt := pAlleMeetpunten;
	while assigned(Meetpunt) do begin
		// Meetpunt initialiseren
		Meetpunt^.StartUp;
		// Bijbehorende seinen en rails actualiseren
		Raillijst := Meetpunt^.ZichtbaarLijst;
		while assigned(Raillijst) do begin
			// Meetpunt van elke rails instellen
			Raillijst^.Rail^.meetpunt := Meetpunt;
			// Meetpunt v��r het sein instellen
			if assigned(Raillijst^.Rail^.Vorige^.Sein) then
				PpSein(Raillijst^.Rail^.Vorige^.Sein)^.B_Meetpunt := Meetpunt;
			if assigned(Raillijst^.Rail^.Volgende^.Sein) then
				PpSein(Raillijst^.Rail^.Volgende^.Sein)^.B_Meetpunt := Meetpunt;
			Raillijst := Raillijst^.Volgende;
		end;
		Meetpunt := Meetpunt^.Volgende;
	end;

	Trein := pAlleTreinen;
	while assigned(Trein) do begin
		Trein^.CalcBezetteRails;
		Trein := Trein^.Volgende;
	end;

	DoeMeetpunten;
	DoeErlaubnisse;
	DoeSeinen;
	DoeWissels;

	// ZendErlaubnisse moet voor ZendMeetpunten, zodat bij het registreren van
	// een treinnummer altijd de stand van de erlaubnis bekend is en er dus
	// correct bepaald kan worden of een aankondiging nodig is.
	ZendErlaubnisse;
	ZendMeetpunten;
	ZendSeinen;
	ZendWissels;

	Tijd_t := 0;

	VerschijnItem := VerschijnLijst;
	while assigned(VerschijnItem) do begin
		if (VerschijnItem^.Tijd < Starttijd) and assigned(VerschijnItem^.Plaats) then
			VerschijnItem^.gedaan := true;
		VerschijnItem := VerschijnItem^.Volgende;
	end;
end;

destructor TpCore.Destroy;
var
	tmp, tmp2: pointer;
begin
	while assigned(pAlleRails) do begin
		tmp := pAlleRails^.Volgende;
		dispose(pAlleRails.Rail.Vorige);
		dispose(pAlleRails.Rail.Volgende);
		dispose(pAlleRails.Rail);
		dispose(pAlleRails);
		pAlleRails := tmp;
	end;
	pAlleRails := nil;
	while assigned(pAlleMeetpunten) do begin
		tmp := pAlleMeetpunten^.Volgende;
		pAlleMeetpunten^.Destroy;
		dispose(pAlleMeetpunten);
		pAlleMeetpunten := tmp;
	end;
	pAlleMeetpunten := nil;
	while assigned(pAlleErlaubnisse) do begin
		tmp := pAlleErlaubnisse^.Volgende;
		while assigned(pAlleErlaubnisse^.Meetpunten) do begin
			tmp2 := pAlleErlaubnisse^.Meetpunten^.Volgende;
			dispose(pAlleErlaubnisse^.Meetpunten);
			pAlleErlaubnisse^.Meetpunten := tmp2;
		end;
		dispose(pAlleErlaubnisse);
		pAlleErlaubnisse := tmp;
	end;
	pAlleErlaubnisse := nil;
	while assigned(pAlleSeinen) do begin
		tmp := pAlleSeinen^.Volgende;
		dispose(pAlleSeinen);
		pAlleSeinen := tmp;
	end;
	pAlleSeinen := nil;
	while assigned(pAlleSeinBeperkingen) do begin
		tmp := pAlleSeinBeperkingen^.Volgende;
		dispose(pAlleSeinBeperkingen);
		pAlleSeinBeperkingen := tmp;
	end;
	pAlleSeinBeperkingen := nil;
	while assigned(pAlleWissels) do begin
		tmp := pAlleWissels^.Volgende;
		dispose(pAlleWissels);
		pAlleWissels := tmp;
	end;
	pAlleWissels := nil;
	while assigned(pAlleVerschijnpunten) do begin
		tmp := pAlleVerschijnpunten^.Volgende;
		dispose(pAlleVerschijnpunten);
		pAlleVerschijnpunten := tmp;
	end;
	pAlleVerschijnpunten := nil;
	while assigned(pAlleVerdwijnpunten) do begin
		tmp := pAlleVerdwijnpunten^.Volgende;
		dispose(pAlleVerdwijnpunten);
		pAlleVerdwijnpunten := tmp;
	end;
	pAlleVerdwijnpunten := nil;
	while assigned(pAlleOverwegen) do begin
		tmp := pAlleOverwegen^.Volgende;
		dispose(pAlleOverwegen);
		pAlleOverwegen := tmp;
	end;
	pAlleOverwegen := nil;

	DestroyState;
	inherited;
end;

procedure TpCore.InitMeetpuntState;
begin
	Meetpunt^.Bezet := false;
	Meetpunt^.Treinnaam := '';
	Meetpunt^.magdefect := true;
	Meetpunt^.defect := false;
	Meetpunt^.rijrichting := 0;
	Meetpunt^.kortsluitlans := false;
	Meetpunt^.kortsluitlansiswegensscenario := false;
	Meetpunt^.veranderd := true;
end;

procedure TpCore.InitErlaubnisState;
begin
	Erlaubnis^.richting := 0;
	Erlaubnis^.bezet := false;
	Erlaubnis^.voorvergendeld := false;
	Erlaubnis^.vergrendeld := false;
	Erlaubnis^.r_veranderd := true;
	Erlaubnis^.b_veranderd := true;
end;

procedure TpCore.InitSeinState;
begin
	Sein^.H_MovementAuthority.HasAuthority := false;
	Sein^.V_AdviesAuthority.HasAuthority := false;
	Sein^.Bediend_Stand := 0;
	Sein^.groendefect := false;
	Sein^.geeldefect := false;
	Sein^.veranderd := true;
end;

procedure TpCore.InitWisselState;
begin
	Wissel^.stand := wsRechtdoor;
	Wissel^.nw_stand := wsRechtdoor;
	Wissel^.defect := wdHeel;
	Wissel^.Monteur := nil;
	Wissel^.veranderd := true;
end;

procedure TpCore.InitOverwegState;
begin
	Overweg^.Status := 0;
	Overweg^.VolgendeStatusTijd := -1;
   Overweg^.veranderd := false;
end;

procedure TpCore.DestroyState;
var
	tmpMeetpunt: PpMeetpunt;
	tmpErlaubnis: PpErlaubnis;
	tmpSein: PpSein;
	tmpWissel: PpWissel;
	tmpOverweg: PpOverweg;
	tmp, tmp2: Pointer;
begin
	// Deze dingen moeten alleen worden gereset.
	// pAlleRails heeft geen status.
	tmpMeetpunt := pAlleMeetpunten;
	while assigned(tmpMeetpunt) do begin
		InitMeetpuntState(tmpMeetpunt);
		tmpMeetpunt := tmpMeetpunt^.volgende;
	end;
	tmpErlaubnis := pAlleErlaubnisse;
	while assigned(tmpErlaubnis) do begin
		InitErlaubnisState(tmpErlaubnis);
		tmpErlaubnis := tmpErlaubnis^.Volgende;
	end;
	tmpSein := pAlleSeinen;
	while assigned(tmpSein) do begin
		InitSeinState(tmpSein);
		tmpSein := tmpSein^.Volgende;
	end;
	// pAlleSeinbeperkingen heeft geen status.
	tmpWissel := pAlleWissels;
	while assigned(tmpWissel) do begin
		InitWisselState(tmpWissel);
		tmpWissel := tmpWissel^.Volgende;
	end;
	(*
	while assigned(pAlleVerschijnpunten) do begin
		tmp := pAlleVerschijnpunten^.Volgende;
		dispose(pAlleVerschijnpunten);
		pAlleVerschijnpunten := tmp;
	end;
	pAlleVerschijnpunten := nil; *)

	// pAlleVerdwijnpunten heeft geen status
	tmpOverweg := pAlleOverwegen;
	while assigned(tmpOverweg) do begin
		InitOverwegState(tmpOverweg);
		tmpOverweg := tmpOverweg^.Volgende;
	end;

	// De volgende dingen moeten helemaal worden gewist
	while assigned(pAlleGesprekken) do begin
		tmp := pAlleGesprekken^.Volgende;
		pAlleGesprekken^.Destroy;
		dispose(pAlleGesprekken);
		pAlleGesprekken := tmp;
	end;
	while assigned(pMaterieel) do begin
		tmp := pMaterieel^.Volgende;
		while assigned(pMaterieel^.Wagons) do begin
			tmp2 := pMaterieel^.Wagons^.Volgende;
			dispose(pMaterieel^.Wagons);
			pMaterieel^.Wagons := tmp2;
		end;
		dispose(pMaterieel);
		pMaterieel := tmp;
	end;
	while assigned(pAlleDiensten) do begin
		tmp := pAlleDiensten^.Volgende;
		while assigned(pAlleDiensten^.Planpunten) do begin
			tmp2 := pAlleDiensten^.Planpunten^.Volgende;
			dispose(pAlleDiensten^.Planpunten);
			pAlleDiensten^.Planpunten := tmp2;
		end;
		dispose(pAlleDiensten);
		pAlleDiensten := tmp;
	end;
	while assigned(VerschijnLijst) do begin
		tmp := VerschijnLijst^.Volgende;
		while assigned(VerschijnLijst^.wagons) do begin
			tmp2 := VerschijnLijst^.wagons^.Volgende;
			dispose(VerschijnLijst^.wagons);
			VerschijnLijst^.wagons := tmp2;
		end;
		dispose(VerschijnLijst);
		VerschijnLijst := tmp;
	end;
	while assigned(pAlleTreinen) do begin
		tmp := pAlleTreinen^.Volgende;
		pAlleTreinen^.Free;
		dispose(pAlleTreinen);
		pAlleTreinen := tmp;
	end;
	while assigned(pAlleTreinInfo) do begin
		tmp := pAlleTreinInfo^.Volgende;
		dispose(pAlleTreinInfo);
		pAlleTreinInfo := tmp;
	end;

	pMonteur^.Destroy;
	dispose(pMonteur);
	pMonteur := nil;

	InitStateVars;
end;

end.
