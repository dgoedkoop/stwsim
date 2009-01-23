unit stwvRijveiligheid;

interface

uses stwvCore, stwvSporen, stwvRijwegen;

// Deze functie kijkt of een wissel in de gewenste stand kan worden
// gezet en een rijweg erover mag worden ingesteld.
// De functie levert ook 'true' als de wissel al goed ligt en er reeds
// een rijweg over ligt.
// Met 'Flankbeveiliging' wordt de hele wisselgroep gecontroleerd.
function WisselStandKan(Wissel: PvWissel; Rechtdoor: boolean; Flankbeveiliging: boolean): boolean;
function WisselKanOmgezet(Wissel: PvWissel; Flankbeveiliging: boolean): boolean;

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

function WisselStandKan;
var
	tmpWissel: PvWissel;
begin
	if Flankbeveiliging then begin
		result := true;
		tmpWissel := Wissel^.Groep^.EersteWissel;
		while assigned(tmpWissel) do begin
			result := result and
				WisselStandKan(tmpWissel,
				(rechtdoor xor Wissel^.BasisstandRecht xor tmpWissel^.BasisstandRecht)
				, false);
			tmpWissel := tmpWissel^.Volgende;
		end;
	end else begin

		result := false;

		// Wissel staat al goed
		if
		(((Wissel^.Stand = wsAftakkend) and not rechtdoor) or
		((Wissel^.Stand = wsRechtdoor) and rechtdoor))
		 and ((Wissel^.Wensstand = Wissel^.Stand) or (Wissel^.Wensstand = wsEgal))
		 and (not Wissel^.rijwegverh) then
			result := true;

		// Wissel wordt momenteel goed gezet
		if
		(((Wissel^.WensStand = wsAftakkend) and not rechtdoor) or
		((Wissel^.WensStand = wsRechtdoor) and rechtdoor))
		 and (Wissel^.Stand = wsOnbekend)
		 and (not Wissel^.rijwegverh) then
			result := true;
			
		// Wissel kan goed worden gezet
		if
		assigned(Wissel^.Meetpunt) and not(assigned(Wissel^.RijwegOnderdeel) or
		 Wissel^.Groep^.bedienverh or Wissel^.rijwegverh or Wissel^.Meetpunt^.bezet
		 or Wissel^.Groep^.OnbekendAanwezig)
		then
			result := true;
	end;
end;

function WisselKanOmgezet;
begin
	result := WisselStandKan(Wissel, Wissel^.Stand <> wsRechtdoor, Flankbeveiliging) and not (Wissel^.Groep^.OnbekendAanwezig);
end;

function RijwegKan;
var
	Stand:		PvWisselstand;
begin
	// Alle wissels moeten in de goede stand gelegd kunnen worden.
	wisselok := true;
	Stand := Rijweg.Wisselstanden;
	while assigned(Stand) do begin
		wisselok := wisselok and WisselStandKan(Stand^.Wissel, Stand^.Rechtdoor, true);
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
