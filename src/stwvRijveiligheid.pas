unit stwvRijveiligheid;

interface

uses stwvCore, stwvSporen, stwvRijwegen;

// Deze functie kijkt of een wissel in de gewenste stand kan worden
// gezet en een rijweg erover mag worden ingesteld.
// De functie levert ook 'true' als de wissel al goed ligt en er reeds
// een rijweg over ligt.
// Met 'Flankbeveiliging' wordt de hele wisselgroep gecontroleerd.
function WisselStandKan(Wissel: PvWissel; Stand: TWisselstand): boolean;
function WisselKanOmgezet(Wissel: PvWissel): boolean;

// Deze functie controleert of het wissel goed ligt, inclusief alle andere
// wissels in de groep.
function WisselsLiggenGoed(Wissel: PvWissel; Stand: TWisselstand): boolean;

// Deze functie kijkt of een rijweg ingesteld kan worden.
// De rijweg hoeft niet vrij te zijn, maar de wissels moeten wel goed
// kunnen worden gezet en tenminste één meetpunt van de rijweg moet geheel
// vrij zijn. Dit laatste om te voorkomen dat we een rijweg direct twee keer
// na elkaar kunnen instellen.
function RijwegKan(Rijweg: PvRijweg; ROZ: boolean): boolean;

// Deze functie zegt waarom de laatste aanroep naar RijwegKan mislukte.
// 0 = succes
// 1 = wissel kan niet goed worden gelegd
// 2 = rijweg is reeds ingesteld
// 3 = rijrichting is momenteel niet toegestaan.
// 4 = rijweg naar onbeveiligd spoor alleen met ROZ
function RijwegKanWaaromNiet: byte;

// Vertel of de rijweg meteen geannuleerd mag worden of dat we approach
// locking moeten toepassen.
function MoetHerroepMetApproachLock(Rijweg: PvRijweg): boolean;

implementation

var
	wisselok,
	richtingok,
	rozok:	boolean;

function WisselStandKan2(Wissel: PvWissel; Stand: TWisselstand): boolean;
var
	tmpBezet: boolean;
begin
	result := false;

	if not (Stand in [wsRechtdoor, wsAftakkend]) then exit;

	// Als de wensstand goed is, is alles in orde.
	if Wissel^.WensStand = Stand then
		result := true;

	// Aangenomen de wensstand klopt eventueel niet. Wanneer mogen we het
	// wissel dan omzetten?
	// - Meetpunten vrij
	// - Niet onderdeel van een rijweg
	// - Niet bedienverhinderd

	// Wissel kan goed worden gezet
	if assigned(Wissel^.Meetpunt) then
		tmpBezet := Wissel^.Meetpunt^.bezet
	else
		tmpBezet := false;
	if (not assigned(Wissel^.RijwegOnderdeel)) and
		(not Wissel^.Groep.Bedienverh) and
		(not tmpBezet) then
		result := true;
end;

function WisselStandKan;
var
	tmpWissel: PvWissel;
	tmpRechtdoor: boolean;
begin
	if not (Stand in [wsRechtdoor, wsAftakkend]) then begin
		result := false;
		exit;
	end;

	result := true;
	tmpWissel := Wissel^.Groep^.EersteWissel;
	tmpRechtdoor := Stand = wsRechtdoor;
	while assigned(tmpWissel) do begin
		if (tmpRechtdoor xor Wissel^.BasisstandRecht xor tmpWissel^.BasisstandRecht) then
			result := result and WisselStandKan2(tmpWissel, wsRechtdoor)
		else
			result := result and WisselStandKan2(tmpWissel, wsAftakkend);
		tmpWissel := tmpWissel^.Volgende;
	end;
end;

function WisselsLiggenGoed2(Wissel: PvWissel; Stand: TWisselstand): boolean;
begin
	result := false;

	if not (Stand in [wsRechtdoor, wsAftakkend]) then exit;

	result := (Wissel^.Stand = Stand) and (Wissel^.Wensstand = Stand);
end;

function WisselsLiggenGoed;
var
	tmpWissel: PvWissel;
	tmpRechtdoor: boolean;
begin
	if not (Stand in [wsRechtdoor, wsAftakkend]) then begin
		result := false;
		exit;
	end;

	result := true;
	tmpWissel := Wissel^.Groep^.EersteWissel;
	tmpRechtdoor := Stand = wsRechtdoor;
	while assigned(tmpWissel) do begin
		if (tmpRechtdoor xor Wissel^.BasisstandRecht xor tmpWissel^.BasisstandRecht) then
			result := result and WisselsLiggenGoed2(tmpWissel, wsRechtdoor)
		else
			result := result and WisselsLiggenGoed2(tmpWissel, wsAftakkend);
		tmpWissel := tmpWissel^.Volgende;
	end;
end;

function WisselKanOmgezet;
begin
	case Wissel^.Wensstand of
	wsRechtdoor: result := WisselStandKan(Wissel, wsAftakkend);
	wsAftakkend: result := WisselStandKan(Wissel, wsRechtdoor);
	wsEgal:
		case Wissel^.Stand of
		wsRechtdoor: result := WisselStandKan(Wissel, wsAftakkend);
		wsAftakkend: result := WisselStandKan(Wissel, wsRechtdoor);
		else
			result := false;
		end;
	else
		result := false;
	end;
end;

function RijwegKan;
var
	Stand:		PvWisselstand;
begin
	// Alle wissels moeten in de goede stand gelegd kunnen worden.
	wisselok := true;
	Stand := Rijweg.Wisselstanden;
	while assigned(Stand) do begin
		if Stand^.Rechtdoor then
			wisselok := wisselok and WisselStandKan(Stand^.Wissel, wsRechtdoor)
		else
			wisselok := wisselok and WisselStandKan(Stand^.Wissel, wsAftakkend);
		wisselok := wisselok and not Stand^.Wissel^.rijwegverh;
		Stand := Stand^.Volgende;
	end;

	// De richting van het spoor moet juist zijn
	richtingok := true;
	if assigned(Rijweg^.Erlaubnis) then
		richtingok := (Rijweg^.Erlaubnis^.richting = Rijweg^.Erlaubnisstand) or
							not Rijweg^.Erlaubnis^.vergrendeld;

	rozok := ROZ or (not Rijweg^.NaarOnbeveiligd);

	result := wisselok and richtingok and rozok;
end;

function RijwegKanWaaromNiet;
begin
	result := 0;
	if not richtingok then result := 3;
	if not wisselok then result := 1;
	if not rozok then result := 4;
end;

function MoetHerroepMetApproachLock;
var
	Meetpunt: PvMeetpuntLijst;
	ok: boolean;
begin
	ok := true;
	Meetpunt := Rijweg^.Sein^.HerroepMeetpunten;
	while assigned(Meetpunt) do begin
		ok := ok and (not Meetpunt^.Meetpunt^.bezet);
		Meetpunt := Meetpunt^.volgende;
	end;
	result := ok;
end;

end.
