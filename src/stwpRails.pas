unit stwpRails;

interface

uses stwpDatatypes;

type
	PpRegLijst = ^TpRegLijst;
	TpRegLijst = record
		vanwie: pointer;	// ^TClient;
		vorige: PpRegLijst;
		volgende: PpRegLijst;
	end;

	PpRail = ^TpRail;
	PpRailConn = ^TpRailConn;
	PpWissel = ^TpWissel;

	TpRail = record
		Lengte:		integer;	// Lengte in meters
		MaxSnelheid:integer;	// Max snelheid in km/u
		Naam:			string;	// Hoe heet dit spoor?
		elektrif:	boolean;	// Ge-elektrificieerd?
		// Automatische relaties
		meetpunt:			pointer;
		Volgende,
		Vorige:		PpRailConn;
	end;

	TpRailConn = record
		VanRail:		  		PpRail;
		isolatiepunt:		boolean;
		wissel:				boolean;
		recht, aftakkend:	PpRail;
		r_foutom,a_foutom:boolean;	// Zitten de rails 'goedom' gemonteerd?
		// Voor een kruising:
		kruising:			boolean;
		kr3rail:				PpRail;
		kr3_foutom:			boolean;
		// Automatische relaties
		WisselData:			PpWissel;
		sein:					pointer;
	end;

	TpWissel = record
		w_naam:				String;
		stand:				TWisselstand;	// Bij niet-wissels altijd niet-aftakkend!
		nw_stand:			TWisselstand;	// Gewenste wisselstand.
		nw_tijd:				integer;	// Wanneer de wissel omgezet wordt.
		Meetpunt:			pointer;	// Welk meetpunt moet vrij zijn om de wissel
												// om te kunnen zetten?
		// Defecten
		defect:		TpWisselDefect;
		Monteur:		pointer;
		// OVERIG
		veranderd:	boolean;
		vanwie:		pointer;	  		// TClient

		volgende:	PpWissel;
	end;

	// Raillijst is voor allerlei dingen nuttig.
	// Bijvoorbeeld als lijst welke sporen een trein bezet.
	// Of als lijst welke sporen een meetpunt kan zien
	// Als lijst van alle sporen die een naam hebben
	// Of gewoon als lijst met alle bestaande sporen.
	PpRailLijst = ^TpRailLijst;
	TpRailLijst = record
		Rail:			PpRail;
		volgende:	PpRailLijst;
	end;

procedure WisselOpenrijden(Conn: PpRailConn);
function WisselWerkzaamheden(Conn: PpRailConn): boolean;
procedure VolgendeRail(Conn: PpRailConn; var Rail: PpRail; var Achteruit: boolean);
procedure RaillijstWissen(var Raillijst: PpRailLijst);
function RaillijstenSnijden(Raillijst1, Raillijst2: PpRailLijst): boolean;

function RailOpLijst(Rail: PpRail; Lijst: PpRailLijst): boolean;

function ZoekRail(pAlleRails: PpRailLijst; Naam: string): PpRail;

function IsHierHoofdsein(Conn: PpRailConn): boolean;
function IsHierSnelheidsbordje(Conn: PpRailConn): boolean;

function ZoekOmgekeerdeConnectie(Conn: PpRailConn): PpRailConn;

implementation

uses stwpSeinen;

function ZoekRail;
var
	tmpRailL: PpRailLijst;
begin
	result := nil;
	tmpRailL := pAlleRails;
	while assigned(tmpRailL) do begin
		if tmpRailL^.Rail^.Naam = Naam then
			result := tmpRailL^.Rail;
		tmpRailL := tmpRailL^.Volgende;
	end;
end;

function ZoekOmgekeerdeConnectie;
var
	naarRail: 		PpRail;
	naarAchteruit:	boolean;
begin
	result := nil;
	// Voor het openrijden moeten we de OMGEKEERDE connectie bekijken.
	VolgendeRail(Conn, naarRail, naarAchteruit);
	if not assigned(naarRail) then exit;	// Zou niet voor mogen komen, de trein
														// moet dan al gecrasht zijn.
	if naarAchteruit then
		result := naarRail^.Volgende
	else
		result := naarRail^.Vorige;
end;

procedure WisselOpenrijden;
var
	wConn:			PpRailConn;
begin
	// Voor het openrijden moeten we de OMGEKEERDE connectie bekijken.
	wConn := ZoekOmgekeerdeConnectie(Conn);
	if not assigned(wConn) then exit;	// Zou niet voor mogen komen, de trein
													// moet dan al gecrasht zijn of er zit
													// een fout in de simulatie-data
	// En nu ons ding doen.
	if not assigned(wConn^.WisselData) then exit;
	if (wConn^.recht = Conn^.VanRail) and (wConn^.WisselData^.stand <> wsRechtdoor) then begin
		wConn^.WisselData^.stand := wsRechtdoor;
		wConn^.WisselData^.nw_stand := wsRechtdoor;
		if wConn^.WisselData^.defect = wdHeel then
			wConn^.WisselData^.defect := wdEenmalig;
		wConn^.WisselData^.veranderd := true;
	end;
	if (wConn^.aftakkend = Conn^.VanRail) and (wConn^.WisselData^.stand <> wsAftakkend) then begin
		wConn^.WisselData^.stand := wsAftakkend;
		wConn^.WisselData^.nw_stand := wsAftakkend;
		if wConn^.WisselData^.defect = wdHeel then
			wConn^.WisselData^.defect := wdEenmalig;
		wConn^.WisselData^.veranderd := true;
	end;
end;

function WisselWerkzaamheden;
var
	naarRail: 		PpRail;
	naarAchteruit:	boolean;
	wConn:			PpRailConn;
begin
	result := false;

	// Vooruit kijken
	if assigned(Conn^.Wisseldata) then
		if assigned(Conn^.Wisseldata^.Monteur) then
			result := true;

	// Achteruit kijken
	VolgendeRail(Conn, naarRail, naarAchteruit);
	if not assigned(naarRail) then exit;	// Zou niet voor mogen komen, de trein
														// moet dan al gecrasht zijn.
	if naarAchteruit then
		wConn := naarRail^.Volgende
	else
		wConn := naarRail^.Vorige;
	// En nu ons ding doen.
	if assigned(wConn^.WisselData) then
		if assigned(wConn^.Wisseldata^.Monteur) then
			result := true;
end;

function RailOpLijst;
var
	tmpRail: PpRailLijst;
begin
	result := false;
	tmpRail := Lijst;
	while assigned(tmpRail) do begin
		if tmpRail^.Rail = Rail then begin
			result := true;
			exit;
		end;
		tmpRail := tmpRail^.Volgende;
	end;
end;

procedure VolgendeRail;
var
	tmpaft: TWisselStand;
begin
	if not Conn^.wissel then
		tmpaft := wsRechtdoor
	else
		tmpaft := Conn^.WisselData^.stand;

	case tmpaft of
	wsRechtdoor: begin
		Rail := Conn.recht;
		achteruit := Conn.r_foutom;
	end;
	wsAftakkend: begin
		Rail := Conn.aftakkend;
		achteruit := Conn.a_foutom;
	end;
	else
		Rail := nil;
	end;
end;

function RaillijstenSnijden;
var
	tmprail1, tmprail2: PpRailLijst;
begin
	result := false;
	tmprail1 := Raillijst1;
	while assigned(tmprail1) do begin
		tmprail2 := Raillijst2;
		while assigned(tmprail2) do begin
			if tmprail1^.Rail = tmprail2^.Rail then
           	result := true;
			tmprail2 := tmprail2^.volgende;
      end;
      tmprail1 := tmprail1^.volgende;
   end;
end;

procedure RaillijstWissen;
var
	tmp, tmp2: PpRaillijst;
begin
	tmp := Raillijst;
   while assigned(tmp) do begin
   	tmp2 := tmp;
      tmp := tmp^.volgende;
      dispose(tmp2);
	end;
	Raillijst := nil;
end;

function IsHierHoofdsein;
begin
	result := IsHoofdsein(PpSein(Conn^.sein));
end;

function IsHierSnelheidsbordje;
begin
	result := IsSnelheidsbordje(PpSein(Conn^.sein));
end;

end.
