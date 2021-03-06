unit stwpTreinen;

interface

uses sysutils, stwpRails, stwpRijplan, stwpTijd, stwpSeinen, stwvMisc,
	stwpDatatypes, stwpTelefoongesprek;

const
	RemwegSnelheid	 		 = 40;

type
	ETreinWarning = class(Exception);

	TWaaromStilstaan = (stWeetniet, stSein, stTrein, stStroom, stDoorrood,
							  stWissel, stStuurstand, stUndef);

	PpWagon = ^TpWagon;
	TpWagon = record
		lengte:		double;	// m
		gewicht:		integer;	// kg
		vermogen:	integer;	// W
		trekkracht:	integer;	// N
		remkracht:	integer;	// N
		maxsnelheid:integer;	// km/u
		cw:			double;	// Luchtweerstandscoefficient
		elektrisch:	boolean;	// Elektrolok?
		bedienbaar:	boolean;	// Lok of stuurstandrijtuig
		twbedienbaar:	boolean;	// Cabine voor en achter, bij false alleen voor.
		naam:			string;	// Type-herkenning
		volgende:	PpWagon;
	end;

	PpWagonConn = ^TpWagonConn;
	TpWagonConn = record
		vorige:		PpWagonConn;
		wagon:		PpWagon;
		omgekeerd:	boolean;
		volgende:	PpWagonConn;
	end;

	PpMaterieelFile = ^TpMaterieelFile;
	TpMaterieelFile = record
		Filename:	string;
		Wagons:		PpWagon;
		Volgende:	PpMaterieelFile;
	end;

	PpTrein = ^TpTrein;
	TpTrein = class
		EersteWagon:		PpWagonConn;

		Treinnummer:		string;

		Planpunten:			PpRijplanPunt;
		StationModusPlanpunt:	PpRijplanpunt;	// Rijplanpunt van het station
															// waar we bij stilstaan.

		kannietwegvoor:	integer;
		klaarmeldingvereist: boolean;

		defect				: boolean;
		defecttot			: integer;

		doorroodgereden:		boolean;
		doorroodgereden_sein:PpSein;
		doorroodopdracht:		boolean;
		doorroodopd_sein:		PpSein;
		doorroodverderrijden:boolean;

		vorigewaaromstilstaan:	TWaaromStilstaan;

		// Berekende algemene gegevens
		bedienbaar:	boolean;
		aantalwagons:	integer;
		lengte:		double;	// m
		gewicht:		integer;	// kg
		vermogen:	integer;	// W
		trekkracht:	integer;	// N
		remkracht:	integer;	// N
		cw:			double;
		elektrisch: boolean;
		matmaxsnelheid: integer;	// km/u
		maxsnelheid:integer;	// km/u. Materieel + Seinbeeld + Rails
		el_ok:		boolean;

		berichtwachttijd: integer;

		// De volgende dynamische gegevens betrekken zich op de voorkant
		// van de trein
		snelheid:	double;	// Snelheid in m/s
		pos_rail:	PpRail;	// Positie: rails
		pos_dist:	double;	// Positie in m binnen deze rail.
		achteruit:	boolean;	// eind->begin

		modus:		TpTreinmodus;

		vorigeaankomstvertraging: integer;
		vertraging:		integer;	// Vertraging in minuten

		bezetterails:	  		PpRailLijst;

		baanvaksnelheid:		integer;	// Baanvaksnelheid

		huidigemaxsnelheid:	integer;	// Huidige max. snelheid in km/u. Sein.
		// Het volgende is nodig omdat een snelheidsverhoging pas geldt wanneer
		// de hele trein het snelheidsverhogingspunt voorbij is gereden.
		vorigebaanvaksnelheid:	integer;
		vorigemaxhsnelheid:		integer;
		afstandsindsvorige_b:	double;	// Aantal meters sinds verandering.
		afstandsindsvorige_h:	double;	// Aantal meters sinds verandering.

		V_Adviessnelheid:	integer;	// De adviessnelheid van het vorige
											//	voorsein, bijvoorbeeld 40 km/u bij een
											// oranje voorsein (rood hoofdsein).
		B_Adviessnelheid:	integer;	// Snelheid van het vorige bordje.
		S_Adviessnelheid: integer;	// We gaan langzaam rijden, want er komt een
											// station aan!
		ROZ:					boolean;

		// Algemene gegevens
		Wissen:		boolean;
		Vorige:		PpTrein;
		Volgende:	PpTrein;

		// Deze functie berekent welke rails door de trein bezet worden. Elke
		// rail waar de trein ook maar 1 mm op staat, wordt geretourneerd.
		procedure CalcBezetteRails;
		Procedure Update;
		Procedure ZoekEinde(var GevRail: PpRail; var GevAchteruit: boolean;
			var GevPos: double);

		procedure NieuweMaxsnelheid(snelheid: integer; steltbaanvaksnelheidin: boolean);

		procedure ZieVoorsein(Sein: PpSein);

		Procedure DraaiOm(SnelhedenAanpassen: boolean);
		function GetVolgendRijplanpunt: PpRijplanpunt;
		Procedure Moetwachten(tijdsduur: integer);

		procedure WisPlanpunten;
		procedure WisBezetteRails;
		procedure WisWagons;

		constructor Create;
		destructor Destroy; override;
	end;

procedure SaveWagons(var f: file; Wagons: PpWagonConn);
function LoadWagons(var f: file; pMaterieel: PpMaterieelFile): PpWagonConn;

procedure SaveTrein(var f: file; Trein: PpTrein);
procedure LoadTrein(var f: file; SgVersion: integer; pMaterieel: PpMaterieelFile; pAlleRails: PpRailLijst; Trein: PpTrein);

procedure SaveTreinen(var f: file; Treinen: PpTrein);
function LoadTreinen(var f: file; SgVersion: integer; pMaterieel: PpMaterieelFile; pAlleRails: PpRailLijst): PpTrein;

function TreinnummerGt(moetgroter, moetkleiner: string): boolean;

implementation

function TreinnummerGt;
var
	gti, kli, code1, code2: integer;
begin
	Val(moetgroter, gti, code1);
	Val(moetkleiner, kli, code2);
	if code1+code2=0 then
		result := gti > kli
	else
		result := moetgroter > moetkleiner
end;

function ZoekWagonType(pMaterieel: PpMaterieelFile; naam: string): PpWagon;
var
	tmpMatFile: PpMaterieelFile;
	tmpWag:	 	PpWagon;
begin
	result := nil;
	tmpMatfile := pMaterieel;
	while assigned(tmpMatfile) do begin
		tmpWag := tmpMatfile^.Wagons;
		while assigned(tmpWag) do begin
			if tmpWag^.naam = Naam then begin
				result := tmpWag;
				exit;
			end;
			tmpWag := tmpWag^.Volgende;
		end;
		tmpMatfile := tmpMatfile^.Volgende;
	end;
end;

procedure SaveWagons;
var
	wagoncount: integer;
	WagonConn: PpWagonConn;
begin
	wagoncount := 0;
	WagonConn := Wagons;
	while assigned(WagonConn) do begin
		inc(wagoncount);
		WagonConn := WagonConn^.Volgende;
	end;
	intwrite(f, wagoncount);
	WagonConn := Wagons;
	while assigned(WagonConn) do begin
		stringwrite(f, WagonConn^.Wagon^.naam);
		boolwrite(f, WagonConn^.Omgekeerd);
		WagonConn := WagonConn^.Volgende;
	end;
end;

function LoadWagons;
var
	wagoncount, j: integer;
	WagonConn: PpWagonConn;
	WagonTypeStr: string;
	Omgekeerd: boolean;
	Wagon:			PpWagon;
	nietgevonden: boolean;
	nietgevondens: string;
begin
	nietgevonden := false;
	nietgevondens := '';
	intread(f, wagoncount);
	WagonConn := nil;
	result := nil;
	for j := 1 to wagoncount do begin
		stringread(f, WagonTypeStr);
		boolread(f, Omgekeerd);
		Wagon := ZoekWagonType(pMaterieel, WagonTypeStr);
		if assigned(Wagon) then begin
			if not assigned(WagonConn) then begin
				new(WagonConn);
				WagonConn^.Vorige := nil;
				result := WagonConn;
			end else begin
				new(WagonConn^.Volgende);
				WagonConn^.Volgende^.Vorige := WagonConn;
				WagonConn := WagonConn^.Volgende;
			end;
			WagonConn^.Volgende := nil;
			WagonConn^.wagon := Wagon;
			WagonConn^.Omgekeerd := Omgekeerd;
		end else begin
			nietgevonden := true;
			if nietgevondens <> '' then
				nietgevondens := nietgevondens + ', ' + WagonTypeStr
			else
				nietgevondens := WagonTypeStr;
		end;
	end;
	if nietgevonden then
		raise ETreinWarning.Create('Kon wagontype niet vinden: '+nietgevondens);
end;

procedure SaveTrein;
begin
	if Trein^.Wissen then exit;

	SaveWagons(f, Trein^.EersteWagon);
	stringwrite(f, Trein^.Treinnummer);
	SaveTreindienst(f, swStatus, Trein^.Planpunten);
	boolwrite(f, assigned(Trein^.StationModusPlanpunt));
	if assigned(Trein^.StationModusPlanpunt) then
		SaveRijpunt(f, swStatus, Trein^.StationModusPlanpunt);

	intwrite (f, Trein^.kannietwegvoor);
	boolwrite(f, Trein^.klaarmeldingvereist);
	boolwrite(f, Trein^.defect);
	intwrite (f, Trein^.defecttot);
	boolwrite(f, Trein^.doorroodgereden);
	boolwrite(f, Trein^.doorroodopdracht);
	boolwrite(f, Trein^.doorroodverderrijden);
	intwrite (f, Trein^.berichtwachttijd);
	doublewrite(f, Trein^.snelheid);
	stringwrite(f, Trein^.pos_rail^.Naam);
	doublewrite(f, Trein^.pos_dist);
	boolwrite(f, Trein^.achteruit);
	bytewrite (f, Ord(Trein^.modus));
	intwrite (f, Trein^.vorigeaankomstvertraging);
	intwrite (f, Trein^.vertraging);
	intwrite (f, Trein^.baanvaksnelheid);
	intwrite (f, Trein^.huidigemaxsnelheid);
	intwrite (f, Trein^.vorigemaxhsnelheid);
	intwrite (f, Trein^.vorigebaanvaksnelheid);
	doublewrite(f, Trein^.afstandsindsvorige_h);
	doublewrite(f, Trein^.afstandsindsvorige_b);
	intwrite (f, Trein^.V_Adviessnelheid);
	intwrite (f, Trein^.B_Adviessnelheid);
	intwrite (f, Trein^.S_Adviessnelheid);
	boolwrite(f, Trein^.ROZ);
end;

procedure LoadTrein;
var
	StationmodusPlanpuntAssigned: boolean;
	RailNaam: string;
	modus: byte;
begin
	Trein^.EersteWagon := LoadWagons(f, pMaterieel);
	stringread(f, Trein^.Treinnummer);
	Trein^.Planpunten := LaadTreindienst(f, swStatus);
	boolread(f, StationmodusPlanpuntAssigned);
	if StationmodusPlanpuntAssigned then begin
		new(Trein^.StationModusPlanpunt);
		LaadRijpunt(f, swStatus, Trein^.StationModusPlanpunt)
	end else
		Trein^.StationModusPlanpunt := nil;

	intread (f, Trein^.kannietwegvoor);
	if SgVersion >= 15 then
		boolread(f, Trein^.klaarmeldingvereist);
	boolread(f, Trein^.defect);
	intread (f, Trein^.defecttot);
	boolread(f, Trein^.doorroodgereden);
	boolread(f, Trein^.doorroodopdracht);
	boolread(f, Trein^.doorroodverderrijden);
	intread (f, Trein^.berichtwachttijd);
	doubleread(f, Trein^.snelheid);
	stringread(f, RailNaam);
	Trein^.pos_rail := ZoekRail(pAlleRails, RailNaam);
	doubleread(f, Trein^.pos_dist);
	boolread(f, Trein^.achteruit);
	byteread (f, modus); Trein^.modus := TpTreinModus(Modus);
	intread (f, Trein^.vorigeaankomstvertraging);
	intread (f, Trein^.vertraging);
	intread (f, Trein^.baanvaksnelheid);
	intread (f, Trein^.huidigemaxsnelheid);
	intread (f, Trein^.vorigemaxhsnelheid);
	intread (f, Trein^.vorigebaanvaksnelheid);
	doubleread(f, Trein^.afstandsindsvorige_h);
	doubleread(f, Trein^.afstandsindsvorige_b);
	intread (f, Trein^.V_Adviessnelheid);
	intread (f, Trein^.B_Adviessnelheid);
	intread (f, Trein^.S_Adviessnelheid);
	boolread(f, Trein^.ROZ);
end;

procedure SaveTreinen;
var
	treincount:		integer;
	Trein: 			PpTrein;
begin
	treincount := 0;
	Trein := Treinen;
	while assigned(Trein) do begin
		inc(treincount);
		Trein := Trein^.Volgende;
	end;
	intwrite(f, treincount);
	Trein := Treinen;
	while assigned(Trein) do begin
		SaveTrein(f, Trein);
		Trein := Trein^.Volgende;
	end;
end;

function LoadTreinen;
var
	i, treincount:	integer;
	Trein: 			PpTrein;
begin
	result := nil;
	Trein := nil;
	intread(f, treincount);
	for i := 1 to treincount do begin
		if not assigned(Trein) then begin
			new(Trein);
			Trein^ := TpTrein.Create;
			result := Trein;
		end else begin
			new(Trein^.Volgende);
			Trein^.Volgende^ := TpTrein.Create;
			Trein^.Volgende^.Vorige := Trein;
			Trein := Trein^.Volgende;
		end;
		LoadTrein(f, SgVersion, pMaterieel, pAlleRails, Trein);
	end;
end;

constructor TpTrein.Create;
begin
	// Dienst instellen
	Treinnummer := '';
	Planpunten := nil;
	StationModusPlanpunt := nil;
	// Modus instellen: wachten op vertrektijd.
	Modus := tmStilstaan;
	// Dynamische gegevens instellen
	snelheid := 0;
	vorigeaankomstvertraging := 0;
	vertraging := 0;
	vorigebaanvaksnelheid := -1;
	vorigemaxhsnelheid := -1;
	huidigemaxsnelheid := -1;
	baanvaksnelheid := -1;
	B_Adviessnelheid := -1;
	V_Adviessnelheid := -1;
	S_Adviessnelheid := -1;
	ROZ := false;
	kannietwegvoor := -1;
	klaarmeldingvereist := false;
	berichtwachttijd := -1;
	doorroodgereden := false;
	doorroodopdracht := false;
	doorroodverderrijden := false;
	vorigewaaromstilstaan := stUndef;
	bezetterails := nil;
	defect := false;
	wissen := false;
end;

destructor TpTrein.Destroy;
begin
	WisPlanpunten;
	if assigned(StationModusPlanpunt) then begin
		dispose(StationModusPlanpunt);
		StationModusPlanpunt := nil;
	end;
	WisBezetteRails;
	WisWagons;
	inherited Destroy;
end;

procedure TpTrein.Wisplanpunten;
var
	tmpPunt: PpRijplanpunt;
begin
	while assigned(Planpunten) do begin
		tmpPunt := Planpunten;
		Planpunten := Planpunten^.Volgende;
		dispose(tmpPunt);
	end;
end;

procedure TpTrein.WisBezetteRails;
var
	tmpRail: PpRailLijst;
begin
	while assigned(BezetteRails) do begin
		tmpRail := BezetteRails;
		BezetteRails := BezetteRails^.Volgende;
		dispose(tmpRail);
	end;
end;

procedure TpTrein.WisWagons;
var
	tmpWagon: PpWagonConn;
begin
	while assigned(EersteWagon) do begin
		tmpWagon := EersteWagon;
		EersteWagon := EersteWagon^.Volgende;
		dispose(tmpWagon);
	end;
end;

function TpTrein.GetVolgendRijplanpunt;
var
	tmpPunt: PpRijplanPunt;
begin
	// Volgend rijplan-punt activeren.
	tmpPunt := Planpunten;
	if assigned(tmpPunt) then
		Planpunten := tmpPunt^.volgende;
	result := tmpPunt;
end;

procedure TpTrein.Moetwachten;
var
	kannietwegvoor_nieuw: integer;
begin
	kannietwegvoor_nieuw := GetTijd+tijdsduur;
	if kannietwegvoor_nieuw > kannietwegvoor then
		kannietwegvoor := kannietwegvoor_nieuw;
end;

procedure TpTrein.DraaiOm;
var
	tmpRail:	PpRail;
	tmpPos:	double;
	tmpAchteruit:	boolean;
	tmpWagon, volgende:	PpWagonConn;
begin
	ZoekEinde(tmpRail, tmpAchteruit, tmpPos);
	// Eerst het 'hoofd' goed zetten.
	pos_rail := tmpRail;
	pos_dist := tmpPos;
	achteruit := tmpAchteruit;
	// Dan alle wagons achterstevoren doen, zodat die in feite weer net zo
	// staan als ze al stonden.
	tmpWagon := EersteWagon;
	EersteWagon := nil;
	while assigned(tmpWagon) do begin
		volgende := tmpWagon^.Volgende;
		tmpWagon^.Volgende := EersteWagon;
		tmpWagon^.Vorige := nil;
		if assigned(eersteWagon) then
			eersteWagon^.Vorige := tmpWagon;
		EersteWagon := tmpWagon;
		tmpWagon.omgekeerd := not tmpWagon.omgekeerd;
		tmpWagon := Volgende;
	end;
	// Snelheidsbeperking instellen
	if snelhedenaanpassen then begin
		huidigemaxsnelheid := RemwegSnelheid;
		V_Adviessnelheid := -1;
		B_Adviessnelheid := -1;
		vorigemaxhsnelheid := -1;
		vorigebaanvaksnelheid := -1;
	end;
end;

procedure TpTrein.Update;
var
	tmpWag: PpWagonConn;
	laatsteWagon: PpWagon;
	tmpRail: PpRailLijst;
	elrails: boolean;
	tmphmaxsnelheid: integer;
	tmpbaanvaksnelheid: integer;
begin
	elrails := true;
	tmpRail := BezetteRails;
	while assigned(tmpRail) do begin
		elrails := elrails and tmpRail^.Rail^.elektrif;
		tmpRail := tmpRail^.volgende;
	end;

	aantalwagons := 0;
	lengte := 0;
	gewicht := 0;
	vermogen := 0;
	trekkracht := 0;
	remkracht := 0;
	elektrisch := false;
	matmaxsnelheid := -1;
	tmpWag := EersteWagon;
	laatsteWagon := nil;
	if assigned(tmpWag) then
		bedienbaar := tmpWag^.wagon^.bedienbaar
	else
		bedienbaar := false;
	while assigned(tmpWag) do begin
		inc(aantalwagons);
		lengte := lengte + tmpWag^.wagon^.lengte;
		gewicht := gewicht + tmpWag^.wagon^.gewicht;
		vermogen := vermogen + tmpWag^.wagon^.vermogen;
		remkracht := remkracht + tmpWag^.wagon^.remkracht;
		if (tmpWag^.wagon^.trekkracht>0) and tmpWag^.wagon^.elektrisch then begin
			elektrisch := true;
			if elrails then
				trekkracht := trekkracht + tmpWag^.wagon^.trekkracht;
		end else
			trekkracht := trekkracht + tmpWag^.wagon^.trekkracht;
		if (matmaxsnelheid > tmpWag^.wagon^.maxsnelheid) or
			(matmaxsnelheid = -1) then
			matmaxsnelheid := tmpWag^.wagon^.maxsnelheid;
		laatsteWagon := tmpWag^.wagon;
		tmpWag := tmpWag^.volgende;
	end;
	if assigned(laatsteWagon) then
		cw := (EersteWagon^.Wagon.cw + LaatsteWagon^.cw) / 2;

	if (not elrails) and elektrisch and (trekkracht = 0) then
		el_ok := false
	else
		el_ok := true;

	maxsnelheid := matmaxsnelheid;

	if (afstandsindsvorige_h <= lengte) and (vorigemaxhsnelheid < huidigemaxsnelheid) and
		(vorigemaxhsnelheid <> -1) then
		tmphmaxsnelheid := vorigemaxhsnelheid
	else
		tmphmaxsnelheid := huidigemaxsnelheid;

	if (afstandsindsvorige_b <= lengte) and (vorigebaanvaksnelheid < baanvaksnelheid) and
		(vorigebaanvaksnelheid <> -1) then
		tmpbaanvaksnelheid := vorigebaanvaksnelheid
	else
		tmpbaanvaksnelheid := baanvaksnelheid;

	if (maxsnelheid > tmphmaxsnelheid) and (tmphmaxsnelheid > -1) then
		maxsnelheid := tmphmaxsnelheid;

	if (maxsnelheid > tmpbaanvaksnelheid) and (tmpbaanvaksnelheid > -1) then
		maxsnelheid := tmpbaanvaksnelheid;

	if doorroodgereden then
		if not doorroodverderrijden then
			huidigemaxsnelheid := 0
		else
			huidigemaxsnelheid := RemwegSnelheid;

	CalcBezetteRails;
end;

procedure TpTrein.ZoekEinde;
var
	tmpWagon:	PpWagonConn;
	tmpRail:		PpRail;
	tmppos:		double;
	tmpachteruit:	boolean;
	tmplengte:	double;
	tmpConn:		PpRailConn;
begin
	tmpWagon := EersteWagon;
	tmpRail := pos_rail;
	tmppos := pos_dist;
	tmpachteruit := achteruit;
	while (tmpWagon <> nil) do begin
		// Nu doorlopen we de hele wagon.
		tmplengte := tmpWagon^.Wagon^.lengte;
		while (tmplengte > 0) do begin
			if tmpachteruit then begin
				tmppos := tmppos + tmplengte;
				if tmppos > tmpRail.Lengte then begin
					// We zijn voorbij het einde van de rails!
					tmplengte := tmppos - tmpRail.Lengte;	// Overschot onthouden.
					tmpConn := tmpRail.Volgende;
					VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
					if tmpAchteruit then
						tmpPos := tmpRail^.lengte
					else
						tmpPos := 0;
					tmpAchteruit := not tmpAchteruit;
				end else
					tmplengte := 0;
			end else begin
				tmppos := tmppos - tmplengte;
				if tmppos < 0 then begin
					// We zijn voorbij het einde van de rails!
					tmplengte := - tmppos;	// Overschot onthouden.
					tmpConn := tmpRail.Vorige;
					VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
					if tmpAchteruit then
						tmpPos := tmpRail^.lengte
					else
						tmpPos := 0;
					tmpAchteruit := not tmpAchteruit;
				end else
					tmplengte := 0;
			end;
		end;
		tmpWagon := tmpWagon^.volgende;
	end;
	GevRail := tmpRail;
	GevAchteruit := not tmpAchteruit;
	GevPos := tmpPos;
end;

procedure TpTrein.CalcBezetteRails;
var
	tmpLijst:	PpRailLijst;
	tmpLijst2:	PpRailLijst;
	tmpWagon:	PpWagonConn;
	tmpRail:		PpRail;
	tmppos:		double;
	tmpachteruit:	boolean;
	tmplengte:	double;
	tmpConn:		PpRailConn;
begin
	if assigned(BezetteRails) then
		RaillijstWissen(BezetteRails);
	tmpWagon := EersteWagon;
	tmpRail := pos_rail;
	tmppos := pos_dist;
	tmpachteruit := achteruit;
	new(tmpLijst);
	BezetteRails := tmpLijst;
	tmpLijst^.Rail := tmpRail;
	tmpLijst^.volgende := nil;
	while (tmpWagon <> nil) do begin
		// Nu doorlopen we de hele wagon en markeren alle rails waar deze op staat.
		tmplengte := tmpWagon^.Wagon^.lengte;
		while (tmplengte > 0) do begin
			if tmpachteruit then begin
				tmppos := tmppos + tmplengte;
				if tmppos > tmpRail.Lengte then begin
					// We zijn voorbij het einde van de rails!
					tmplengte := tmppos - tmpRail.Lengte;	// Overschot onthouden.
					tmpConn := tmpRail.Volgende;
					VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
					if tmpAchteruit then
						tmpPos := tmpRail^.lengte
					else
						tmpPos := 0;
					tmpAchteruit := not tmpAchteruit;
				end else
					tmplengte := 0;
			end else begin
				tmppos := tmppos - tmplengte;
				if tmppos < 0 then begin
					// We zijn voorbij het einde van de rails!
					tmplengte := - tmppos;	// Overschot onthouden.
					tmpConn := tmpRail.Vorige;
					VolgendeRail(tmpConn, tmpRail, tmpAchteruit);
					if tmpAchteruit then
						tmpPos := tmpRail^.lengte
					else
						tmpPos := 0;
					tmpAchteruit := not tmpAchteruit;
				end else
					tmplengte := 0;
			end;
			if tmpRail <> tmpLijst^.Rail then begin
				new(tmpLijst2);
				tmpLijst^.volgende := tmpLijst2;
				tmpLijst2^.volgende := nil;
				tmpLijst := tmpLijst2;
				tmpLijst^.Rail := tmpRail;
			end;
		end;
		tmpWagon := tmpWagon^.volgende;
	end;
end;

procedure TpTrein.NieuweMaxsnelheid;
begin
	if not steltbaanvaksnelheidin then begin
		// Niks te doen? Dan niks doen.
		if (snelheid = huidigemaxsnelheid) or
			( ((snelheid >= baanvaksnelheid) or (snelheid = -1)) and
			  (huidigemaxsnelheid = baanvaksnelheid) and
			  (baanvaksnelheid > -1)
			) then
			exit;
		vorigemaxhsnelheid := huidigemaxsnelheid;
		afstandsindsvorige_h := 0;
		if ((snelheid < baanvaksnelheid) and (snelheid > -1)) or
			(baanvaksnelheid = -1) then
			huidigemaxsnelheid := snelheid
		else
			huidigemaxsnelheid := baanvaksnelheid;
	end else begin
		if (huidigemaxsnelheid <> snelheid) then begin
			vorigemaxhsnelheid := huidigemaxsnelheid;
			afstandsindsvorige_h := 0;
			huidigemaxsnelheid := snelheid
		end;
		if snelheid <> baanvaksnelheid then begin
			vorigebaanvaksnelheid := baanvaksnelheid;
			afstandsindsvorige_b := 0;
			baanvaksnelheid := snelheid;
		end;
	end;
end;

procedure TpTrein.ZieVoorsein;
begin
	if not assigned(Sein) then exit;
	// Een sein annuleert geen vertraag-opdracht van een bordje.
	// En omgekeerd ook niet!
	if Sein^.Autovoorsein then begin
		if Sein^.V_AdviesAuthority.HasAuthority then
			if Sein^.V_AdviesAuthority.Baanvaksnelheid then
				V_Adviessnelheid := -1
			else
				V_Adviessnelheid := Sein^.V_AdviesAuthority.Snelheidsbeperking
		else
			V_Adviessnelheid := RemwegSnelheid
	end;
	if (Sein^.V_Baanmaxsnelheid > 0) and
		((Sein^.V_Baanmaxsnelheid < B_Adviessnelheid) or
		(B_Adviessnelheid = -1)) then
		B_Adviessnelheid := Sein^.V_Baanmaxsnelheid
end;

end.
