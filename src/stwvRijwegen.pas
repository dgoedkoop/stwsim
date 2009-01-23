unit stwvRijwegen;

interface

uses stwvSporen, stwvHokjes, stwvSeinen, stwvMeetpunt, stwvMisc;

type
	PvWisselstand = ^TvWisselstand;
	TvWisselstand = record
		Wissel:	PvWissel;	// Welke wissel bedienen we?
		Rechtdoor:	boolean;	// Welke wisselstand?
		volgende: PvWisselstand;
	end;

	PvInactiefHokje = ^TvInactiefHokje;
	TvInactiefHokje = record
		schermID: integer;
		x, y:	Integer;	// Locatie van het hokje
		Meetpunt: PvMeetpunt;	// Bijbehorend meetpunt
		volgende: PvInactiefHokje;
	end;

	PvKruisingHokje = ^TvKruisingHokje;
	TvKruisingHokje = record
		schermID: integer;
		x, y:	Integer;	// Locatie van het hokje
		Meetpunt: PvMeetpunt;	// Bijbehorend meetpunt
		RechtsonderKruisRijweg: boolean; // Zie stwvHokjes
		volgende: PvKruisingHokje;
	end;

	PvRijweg = ^TvRijweg;
	TvRijweg = record
		// Spoortechnisch-functionele statische gegevens
		Meetpunten:			PvMeetpuntLijst;	// Uit welke meetpunten bestaat de rijweg?
		Wisselstanden:		PvWisselstand;		// Hoe moeten de wissels staan?
		Sein:					PvSein;				// Welk sein gaan we op groen zetten?
		NaarSein:			PvSein;				// Naar welk sein gaat deze rijweg?
		NaarOnbeveiligd:	boolean;				// Rijweg naar onbeveiligd spoor?
		Erlaubnis:			PvErlaubnis;		// Deze rijrichting moeten we claimen.
														// Mag ook nil zijn.
		Erlaubnisstand:	byte;					// En hoe-om dan wel niet.

		NaarTNVMeetpunt:	PvMeetpunt;			// Voor het verplaatsen van het treinnummer.

		// Statische gegevens mbt. bediening
		Naar:			string;						// Voor het bedienen.

		// Statische gegevens mbt. weergave
		InactieveHokjes:	PvInactiefHokje;	// Welke hokjes die bij een gebruikt
														// meetpunt horen, horen toch niet bij
														// deze rijweg?
		KruisingHokjes:	PvKruisingHokje;	// Welke hokjes geven een kruising weer
														// en hoe moet de kruising worden
														// weergegeven als de rijweg actief is?

		Volgende:	PvRijweg;
	end;

	// Deze lijst bevat geactiveerde rijwegen.
	// Een rijweg wordt van deze lijst gewist als het sein op groen geschakeld
	// is, want dan is alles reeds op andere plaatsen gereserveerd etc.
	// Dit geldt niet voor flankbeveiliging-wissels. Die zijn nergens speciaal
	// gereserveerd. Hiervoor geldt echter dat helemaal geen rijweg over de
	// verkeerde stand kan worden ingesteld - flankbeveiliging immers.
	THerroep = record
		herroep:		boolean;		// Herroepen we uberhaupt?
		seinwacht:	boolean;		// Geen approach-locking - in principe dan, wacht
										// nog even voordat het sein rood is en kijk dan of
										// approach-locking nodig is.
		t:				integer;		// Wel approach-locking: tot wanneer wachten?
	end;
	PvActieveRijwegLijst = ^TvActieveRijwegLijst;
	TvActieveRijwegLijst = record
		Rijweg		:	PvRijweg;
		ROZ			:	boolean;		// Rijweg naar bezet spoor ROZ - geel knipper
		Autorijweg	:	boolean;		// Een autorijweg blijft altijd actief
											// en wordt dus telkens weer opnieuw ingesteld.
		Pending		:  byte;			// Status. 0=wissels instellen en meetpunten
											// claimen, 1=overwegen sluiten, 2= sein is
											// op groen, 3=sein is weer op rood.
		Herroep		:	THerroep;	// Herroep-gegevens
		Volgende		:	PvActieveRijwegLijst;
	end;

	PvRijwegLijst = ^TvRijwegLijst;
	TvRijwegLijst = record
		Rijweg:		PvRijweg;		// Welke rijweg?
		Volgende:	PvRijwegLijst;
	end;

	// PRLRijweg is een rijweg met enkele extra gegevens.
	// Het kan een enkelvoudige of een meervoudige rijweg zijn.
	// Beide is mogelijk.
	PvPrlRijweg = ^TvPrlRijweg;
	TvPrlRijweg = record
		van, naar:			string;	// Klikpuntstring (met r of s ervoor)
		Rijwegen:			PvRijwegLijst;
		Dwang:				Byte;		// 0=geen dwang
		Volgende:			PvPrlRijweg;
	end;


procedure DisposeRijweg(rijweg: PvRijweg);
function KlikpuntTekst(s: string; nietniks:boolean): string;
function MaakKlikpunt(hokje: TvHokje): string;
function KlikpuntSpoor(s: string): string;

procedure RijwegVoegMeetpuntToe(Rijweg: PvRijweg; Meetpunt: PvMeetpunt);
procedure RijwegVerwijderMeetpunt(Rijweg: PvRijweg; Meetpunt: PvMeetpunt);
procedure RijwegVoegWisselToe(Rijweg: PvRijweg; Wissel: PvWissel; Rechtdoor: boolean);
procedure RijwegVerwijderWissel(Rijweg: PvRijweg; Wissel: PvWissel);
procedure RijwegVoegInactiefHokjeToe(Rijweg: PvRijweg; schermID: integer; x,y: integer; meetpunt: PvMeetpunt);
function RijwegVerwijderInactiefHokje(Rijweg: PvRijweg; schermID: integer; x,y: integer): boolean;
procedure RijwegVoegKruisingHokjeToe(Rijweg: PvRijweg; schermID: integer; x,y: integer; meetpunt: PvMeetpunt; RechtsonderKruisRijweg: boolean);
function RijwegVerwijderKruisingHokje(Rijweg: PvRijweg; schermID: integer; x,y: integer): boolean;
function RijwegWisselstandVereist(Rijweg: PvRijweg; Wissel: PvWissel): byte;

procedure DisposePrlRijweg(PrlRijweg: PvPrlRijweg);
procedure PrlRijwegVoegRijwegToe(PrlRijweg: PvPrlRijweg; Rijweg: PvRijweg);

implementation

procedure DisposeRijweg;
var
	vMeetpunten: PvMeetpuntLijst;
	vWisselstanden: PvWisselstand;
	vInactiefHokje: PvInactiefHokje;
	vKruisingHokje: PvKruisingHokje;
begin
	while assigned(rijweg.Meetpunten) do begin
		vMeetpunten := rijweg.Meetpunten;
		rijweg.Meetpunten := vMeetpunten.Volgende;
		dispose(vMeetpunten)
	end;
	while assigned(rijweg.Wisselstanden) do begin
		vWisselstanden := rijweg.Wisselstanden;
		rijweg.Wisselstanden := vWisselstanden.Volgende;
		dispose(vWisselstanden)
	end;
	while assigned(rijweg.InactieveHokjes) do begin
		vInactiefHokje := rijweg.InactieveHokjes;
		rijweg.InactieveHokjes := vInactiefHokje.volgende;
		dispose(vInactiefHokje)
	end;
	while assigned(rijweg.KruisingHokjes) do begin
		vKruisingHokje := rijweg.KruisingHokjes;
		rijweg.KruisingHokjes := vKruisingHokje.volgende;
		dispose(vKruisingHokje)
	end;
	dispose(Rijweg);
end;

function KlikpuntTekst;
begin
	if s = '' then
		if nietniks then
			result := '<niks>'
		else
			result := ''
	else
		case s[1] of
			'r': result := 'spoor '+copy(s, 2, length(s));
			's': result := 'sein '+copy(s, 2, length(s));
		end;
end;

function KlikpuntSpoor;
begin
	if copy(s,1,1)='r' then
		result := copy(s,2,length(s)-1)
	else
		result := '';
end;

function MaakKlikpunt;
begin
	result := '';
	case Hokje.Soort of
		2: if PvHokjeLetter(Hokje.grdata)^.Spoornummer <> '' then begin
			result := 'r'+PvHokjeLetter(Hokje.grdata)^.Spoornummer;
		end;
		3: if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then begin
			result := 's'+PvHokjeSein(Hokje.grdata)^.Sein^.Naam;
		end;
	end;
end;

procedure RijwegVoegMeetpuntToe;
var
	Punt, NieuwMeetpunt: PvMeetpuntLijst;
begin
	Punt := Rijweg.Meetpunten;
	while assigned(Punt) do begin
		if Punt.Meetpunt = Meetpunt then
			exit;
		Punt := Punt^.Volgende;
	end;
	new(NieuwMeetpunt);
	NieuwMeetpunt^.Meetpunt := Meetpunt;
	NieuwMeetpunt^.Volgende := Rijweg.Meetpunten;
	Rijweg.Meetpunten := NieuwMeetpunt;
end;

procedure RijwegVerwijderMeetpunt;
var
	vorigePunt, Punt: PvMeetpuntLijst;
	vInactiefHokje,tInactiefHokje,InactiefHokje: PvInactiefHokje;
	vKruisingHokje,tKruisingHokje,KruisingHokje: PvKruisingHokje;
begin
	vorigePunt := nil;
	Punt := Rijweg.Meetpunten;
	while assigned(Punt) do begin
		if Punt.Meetpunt = Meetpunt then begin
			// We hebben het punt! Nu moeten we nog eventjes bijbehorende
			// hokjesdingen opruimen.
			vInactiefHokje := nil;
			InactiefHokje := Rijweg.InactieveHokjes;
			while assigned(InactiefHokje) do begin
				if InactiefHokje^.Meetpunt = Meetpunt then begin
					if assigned(vInactiefHokje) then
						vInactiefHokje.Volgende := InactiefHokje.Volgende
					else
						Rijweg.InactieveHokjes := InactiefHokje.Volgende;
					tInactiefHokje := InactiefHokje.Volgende;
					Dispose(InactiefHokje);
					InactiefHokje := tInactiefHokje;
				end else begin
					vInactiefHokje := InactiefHokje;
					InactiefHokje := vInactiefHokje.Volgende;
				end;
			end;
			vKruisingHokje := nil;
			KruisingHokje := Rijweg.KruisingHokjes;
			while assigned(KruisingHokje) do begin
				if KruisingHokje^.Meetpunt = Meetpunt then begin
					if assigned(vKruisingHokje) then
						vKruisingHokje.Volgende := KruisingHokje.Volgende
					else
						Rijweg.KruisingHokjes := KruisingHokje.Volgende;
					tKruisingHokje := KruisingHokje.Volgende;
					Dispose(KruisingHokje);
					KruisingHokje := tKruisingHokje;
				end else begin
					vKruisingHokje := KruisingHokje;
					KruisingHokje := vKruisingHokje.Volgende;
				end;
			end;
			// En tenslotte het punt wissen.
			if assigned(vorigePunt) then
				vorigePunt.volgende := Punt.volgende
			else
				Rijweg.Meetpunten := Punt.volgende;
			dispose(Punt);
			exit;
		end;
		vorigePunt := Punt;
		Punt := Punt^.Volgende;
	end;
end;

procedure RijwegVoegWisselToe;
var
	tmpWissel, NieuweWissel: PvWisselstand;
begin
	tmpWissel := Rijweg.Wisselstanden;
	while assigned(tmpWissel) do begin
		if tmpWissel.Wissel = Wissel then
			exit;
		tmpWissel := tmpWissel^.Volgende;
	end;
	new(NieuweWissel);
	NieuweWissel^.Wissel := Wissel;
	NieuweWissel^.Rechtdoor := Rechtdoor;
	NieuweWissel^.Volgende := Rijweg.Wisselstanden;
	Rijweg.Wisselstanden := NieuweWissel;
end;

procedure RijwegVerwijderWissel;
var
	vorigeWissel, tmpWissel: PvWisselstand;
begin
	vorigeWissel := nil;
	tmpWissel := Rijweg.Wisselstanden;
	while assigned(tmpWissel) do begin
		if tmpWissel.Wissel = Wissel then begin
			if assigned(vorigeWissel) then
				vorigeWissel.volgende := tmpWissel.volgende
			else
				Rijweg.Wisselstanden := tmpWissel.volgende;
			dispose(tmpWissel);
			exit;
		end;
		vorigeWissel := tmpWissel;
		tmpWissel := tmpWissel^.Volgende;
	end;
end;

procedure RijwegVoegInactiefHokjeToe;
var
	nInactiefHokje: PvInactiefHokje;
begin
	nInactiefHokje := Rijweg.InactieveHokjes;
	while assigned(nInactiefHokje) do begin
		if (nInactiefHokje^.schermID = schermID) and
			(nInactiefHokje^.x = x) and
			(nInactiefHokje^.y = y) then begin
			nInactiefHokje^.Meetpunt := meetpunt;
			exit;
		end;
		nInactiefHokje := nInactiefHokje^.Volgende;
	end;
	new(nInactiefHokje);
	nInactiefHokje^.schermID := schermID;
	nInactiefHokje^.x := x;
	nInactiefHokje^.y := y;
	nInactiefHokje^.Meetpunt := Meetpunt;
	nInactiefHokje^.volgende := Rijweg.InactieveHokjes;
	Rijweg.InactieveHokjes := nInactiefHokje;
end;

function RijwegVerwijderInactiefHokje;
var
	vInactiefHokje, InactiefHokje: PvInactiefHokje;
begin
	vInactiefHokje := nil;
	InactiefHokje := Rijweg.InactieveHokjes;
	while assigned(InactiefHokje) do begin
		if (InactiefHokje^.schermID = schermID) and
			(InactiefHokje^.x = x) and
			(InactiefHokje^.y = y) then begin
			if assigned(vInactiefHokje) then
				vInactiefHokje.Volgende := InactiefHokje.Volgende
			else
				Rijweg.InactieveHokjes := InactiefHokje.Volgende;
			dispose(InactiefHokje);
			result := true;
			exit;
		end;
		vInactiefHokje := InactiefHokje;
		InactiefHokje := InactiefHokje^.Volgende;
	end;
	result := false;
end;

procedure RijwegVoegKruisingHokjeToe;
var
	nKruisingHokje: PvKruisingHokje;
begin
	nKruisingHokje := Rijweg.KruisingHokjes;
	while assigned(nKruisingHokje) do begin
		if (nKruisingHokje^.schermID = schermID) and
			(nKruisingHokje^.x = x) and
			(nKruisingHokje^.y = y) then begin
			nKruisingHokje^.RechtsonderKruisRijweg := RechtsonderKruisRijweg;
			exit;
		end;
		nKruisingHokje := nKruisingHokje^.Volgende;
	end;
	new(nKruisingHokje);
	nKruisingHokje^.schermID := schermID;
	nKruisingHokje^.x := x;
	nKruisingHokje^.y := y;
	nKruisingHokje^.Meetpunt := meetpunt;
	nKruisingHokje^.RechtsonderKruisRijweg := RechtsonderKruisRijweg;
	nKruisingHokje^.volgende := Rijweg.KruisingHokjes;
	Rijweg.KruisingHokjes := nKruisingHokje;
end;

function RijwegVerwijderKruisingHokje;
var
	vKruisingHokje, KruisingHokje: PvKruisingHokje;
begin
	vKruisingHokje := nil;
	KruisingHokje := Rijweg.KruisingHokjes;
	while assigned(KruisingHokje) do begin
		if (KruisingHokje^.schermID = schermID) and
			(KruisingHokje^.x = x) and
			(KruisingHokje^.y = y) then begin
			if assigned(vKruisingHokje) then
				vKruisingHokje.Volgende := KruisingHokje.Volgende
			else
				Rijweg.KruisingHokjes := KruisingHokje.Volgende;
			dispose(KruisingHokje);
			result := true;
			exit;
		end;
		vKruisingHokje := KruisingHokje;
		KruisingHokje := KruisingHokje^.Volgende;
	end;
	result := false;
end;

// Retourneert:
// 0=vrije keus
// 1=rechtdoor
// 2=afbuigend
function RijwegWisselstandVereist;
var
	Stand: PvWisselStand;
begin
	Stand := Rijweg^.Wisselstanden;
	result := 0;
	while assigned(Stand) do begin
		if Stand^.Wissel^.Groep = Wissel^.Groep then begin
			if Stand^.Wissel^.Stand = wsRechtdoor then
				if not (Stand^.Wissel^.BasisstandRecht xor Wissel^.BasisstandRecht) then
					result := 1
				else
					result := 2;
			if Stand^.Wissel^.Stand = wsAftakkend then
				if not (Stand^.Wissel^.BasisstandRecht xor Wissel^.BasisstandRecht) then
					result := 2
				else
					result := 1;
		end;
		Stand := Stand^.Volgende;
	end;
end;

procedure DisposePrlRijweg;
var
	tmpRijwegLijst: PvRijwegLijst;
begin
	while assigned(PrlRijweg^.Rijwegen) do begin
		tmpRijwegLijst := PrlRijweg^.Rijwegen;
		PrlRijweg^.Rijwegen := tmpRijwegLijst^.Volgende;
		dispose(tmpRijwegLijst);
	end;
	dispose(PrlRijweg);
end;

procedure PrlRijwegVoegRijwegToe;
var
	RijwegLijst,
	tmpRijwegLijst: PvRijwegLijst;
begin
	new(RijwegLijst);
	RijwegLijst^.Rijweg := Rijweg;
	RijwegLijst^.Volgende := nil;
	if not assigned(PrlRijweg^.Rijwegen) then
		PrlRijweg^.Rijwegen := RijwegLijst
	else begin
		tmpRijwegLijst := PrlRijweg^.Rijwegen;
		while assigned(tmpRijwegLijst^.Volgende) do
			tmpRijwegLijst := tmpRijwegLijst^.Volgende;
		tmpRijwegLijst^.Volgende := RijwegLijst;
	end;
end;

end.
