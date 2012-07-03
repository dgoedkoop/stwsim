unit stwpMeetpunt;

interface

uses stwpRails, stwpTreinen, stwpSeinen;

type
	PpErlaubnis = ^TpErlaubnis;
	PpMeetpunt = ^TpMeetpunt;

	TpMeetpunt = class
		// SIMULATIE
		// Vooraf ingestelde dingen
		Rail:			PpRail;			// Waar is het meetpunt bevestigd?
		Naam:			string;			// Hoe heet dit meetpunt?
		Erlaubnis:	PpErlaubnis;	// Bijbehorende Erlaubnis.
		// Dynamische informatie
		Bezet: boolean;				// Bezet?
		Elektrif: boolean;			// Geëlektrificieerd?
		Treinnaam:	string;			// Toch maar wel hier bijhouden.
		ZichtbaarLijst:	PpRaillijst;	// Wordt éénmalig bijgewerkt.
		rijrichting:	byte;			// 0=geen, 1=up, 2=down (voor vrije banen)
		// Defecten
		defect:		boolean;

		// OVERIG
		veranderd:	boolean;
		vanwies:		PpRegLijst;

		// Intern

		volgende: PpMeetpunt;

		constructor Create;
		destructor Destroy; override;

		procedure ZichtbaarToevRec(var Lijst: PpRailLijst; Rail: PpRail);
		function ZichtbareRails: PpRaillijst;
		procedure Update(Treinen:	PpTrein);
		procedure StartUp;
	end;

	PpMeetpuntLijst = ^TpMeetpuntLijst;
	TpMeetpuntLijst = record
		Meetpunt:	PpMeetpunt;
		volgende: PpMeetpuntLijst;
	end;

	TpErlaubnis = record
		// SIMULATIE
		// Vooraf ingestelde dingen
		naam:			String;
		Meetpunten:	PpMeetpuntLijst;
		standaardrichting:	byte;	// 0=geen, 1=up, 2=down
		// Dynamische informatie
		richting:				byte;	// 0=geen, 1=up, 2=down, 3=beide
		vergrendeld:		boolean;	// Voorvergrendeld of bezet.
		voorvergendeld:	boolean;	// Een voorvergrendelde Erlaubnis kan niet
											// gewijzigd worden, ook niet als de meetpunten
											// vrij zijn.
		bezet: boolean;				// Geaggregeerd gegeven van een vrije baan
		// Overige
		check:		boolean;
		r_veranderd:	boolean;    // Is de richting veranderd?
		b_veranderd:	boolean;		// Is de bezet-status veranderd?
		vanwies:		PpRegLijst;
		// Intern
		volgende:	PpErlaubnis;
	end;

implementation

constructor TpMeetpunt.Create;
begin
	ZichtbaarLijst := nil;
	bezet := false;
end;

destructor TpMeetpunt.Destroy;
begin
	if assigned(ZichtbaarLijst) then
		RaillijstWissen(ZichtbaarLijst);
	inherited Destroy;
end;

procedure TpMeetpunt.Update;
var
	tmpRail: PpRailLijst;
	tmpTrein: PpTrein;
	oudebezet: boolean;
begin
	oudebezet := bezet;
	Bezet := false;
	Elektrif := true;

	// Zijn die rails elektrisch?
	tmpRail := Zichtbaarlijst;
	while assigned(tmpRail) do begin
		Elektrif := Elektrif and tmpRail^.Rail^.elektrif;
		tmpRail := tmpRail^.volgende;
	end;

	if not defect then begin
		// Dan nu kijken of nog andere treinen zich binnen het meetbereik bevinden.
		tmpTrein := Treinen;
		while assigned(tmpTrein) do begin
			if RaillijstenSnijden(ZichtbaarLijst, tmpTrein^.BezetteRails) then
				Bezet := true;
			tmpTrein := tmpTrein^.Volgende;
		end;
	end else
		Bezet := true;

	if bezet <> oudebezet then begin
		// Dan zijn we veranderd...
		veranderd := true;
		// Moeten we eene evt. Erlaubnis opnieuw berekenen
		if assigned(Erlaubnis) then
			Erlaubnis^.check := true;
		// Als het meetpunt vrij is moeten we de rijrichting resetten
		if not bezet then
			rijrichting := 0;
	end;
end;

procedure TpMeetpunt.ZichtbaarToevRec;
var
	tmpConn: PpRailConn;
	tmpLijst: PpRailLijst;
	i: integer;
begin
	if RailOpLijst(Rail, Lijst) then
		exit;

	// Eerst zetten we eens de nu gevonden rail op de lijst.
	new(tmpLijst);
	tmpLijst^.Rail := Rail;
	tmpLijst^.volgende := Lijst;
	Lijst := tmpLijst;

	for i := 1 to 2 do begin
		if i = 1 then
			tmpConn := Rail^.Volgende
		else
			tmpConn := Rail^.Vorige;

		if assigned(tmpConn) then if not tmpConn.Isolatiepunt then begin
			ZichtbaarToevRec(Lijst, tmpConn^.recht);
			// Wissel? Dan recursief het afbuigende spoor behandelen.
			if tmpConn.wissel or tmpConn.Kruising then
				ZichtbaarToevRec(Lijst, tmpConn^.aftakkend);
			if tmpConn.Kruising then
				ZichtbaarToevRec(Lijst, tmpConn^.kr3rail);
		end;
	end;
end;

function TpMeetpunt.ZichtbareRails;
var
	tmpLijst: PpRaillijst;
begin
	tmpLijst := nil;
	ZichtbaarToevRec(tmpLijst, Rail);
	result := tmpLijst;
end;

procedure TpMeetpunt.Startup;
begin
	// Welke sporen meten we eigenlijk?
	if not assigned(ZichtbaarLijst) then
		ZichtbaarLijst := ZichtbareRails;
end;

end.
