unit stwvRijveiligheid;

interface

uses stwvCore, stwvSporen, stwvRijwegen;

procedure WisselstandenLijstDispose(StandenLijst: PWisselstandLijst);

function WisselstandenLijstBereken(Wissel: PvWissel; Stand: TWisselStand;
	Flankbeveiliging: PvFlankbeveiliging; TotNuToe: PWisselstandLijst; WensenRespecteren: boolean): PWisselstandLijst;

// De functies WisselstandKan, WisselKanOmgezet, RijwegKan en WisselsLiggenGoed
// zijn beveiligd met een lock. Als het lock gezet is dan retourneren ze 'false'

// Wanneer moet nu het lock worden gezet? Dat moet als volgt:
// 1. <kijk of iets kan>
// 2. RijveiligheidLock();
// 3. <doe iets dat SendMsg veroorzaakt>
// 4. RijveiligheidUnlock();
// Zo wordt namelijk verhinderd dat bij een interruptie van SendMsg iets wordt
// gedaan dat het resultaat van de gedane checks be�nvloedt.

// Deze functie kijkt of een wissel in de gewenste stand kan worden
// gezet en een rijweg erover mag worden ingesteld.
// De functie levert ook 'true' als de wissel al goed ligt en er reeds
// een rijweg over ligt.
function WisselStandKan(Wissel: PvWissel; Stand: TWisselstand;
	Flankbeveiliging: PvFlankbeveiliging): boolean;
function WisselKanOmgezet(Wissel: PvWissel;
	Flankbeveiliging: PvFlankbeveiliging): boolean;

// Deze functie controleert of het wissel goed ligt, inclusief alle andere
// wissels in de groep en relevante eiswissels.
function WisselsLiggenGoed(Wissel: PvWissel; Stand: TWisselstand;
	Flankbeveiliging: PvFlankbeveiliging): boolean;

// Deze functie kijkt of een rijweg ingesteld kan worden.
// De rijweg hoeft niet vrij te zijn, maar de wissels moeten wel goed
// kunnen worden gezet en tenminste ��n meetpunt van de rijweg moet geheel
// vrij zijn. Dit laatste om te voorkomen dat we een rijweg direct twee keer
// na elkaar kunnen instellen.
function RijwegKan(Rijweg: PvRijweg; ROZ: boolean;
	Flankbeveiliging: PvFlankbeveiliging): boolean;

// Deze functie zegt waarom de laatste aanroep naar RijwegKan mislukte.
// 0 = succes
// 1 = wissel kan niet goed worden gelegd
// 2 = rijweg is reeds ingesteld
// 3 = rijrichting is momenteel niet toegestaan.
// 4 = rijweg naar onbeveiligd spoor alleen met ROZ
// 9 = lock
function RijwegKanWaaromNiet: byte;

// Vertel of de rijweg meteen geannuleerd mag worden of dat we approach
// locking moeten toepassen.
function MoetHerroepMetApproachLock(Rijweg: PvRijweg): boolean;

function RijveiligheidLock: boolean;
procedure RijveiligheidUnlock;

implementation

var
	wisselok,
	richtingok,
	rozok,
	lock:	boolean;


// Dit is de basale domme functie die alleen naar dit ene wissel kijkt
function IndividueleWisselStandKan(Wissel: PvWissel; Stand: TWisselstand): boolean;
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

procedure WisselstandenLijstDispose;
var
	tmpCheck, disposeLijst: PWisselstandLijst;
begin
	tmpCheck := StandenLijst;
	while assigned(tmpCheck) do begin
		disposeLijst := tmpCheck;
		tmpCheck := tmpCheck^.Volgende;
		dispose(disposeLijst);
	end;
end;

// Deze functie retourneert nul als het wissel niet kan worden omgezet, of anders
// een lijst met om te zetten wissels te beginnen met het gekozen wissel maar
// exclusief de wissels uit TotNuToe.
// Deze functie maakt de lijst per recursieve oproep hooguit ��n wissel langer.
function WisselstandenLijstBereken;
var
	EisenLijst: PWisselstandLijst;
	tmpEisenLijst: PWisselstandLijst;
	WensenLijst: PWisselstandLijst;
	tmpWensenLijst: PWisselstandLijst;
	tmpLijst: PWisselstandLijst;
	tmpLijstEind: PWisselstandLijst;
	tmpCheck: PWisselstandLijst;
	tmpWissel: PvWissel;
	tmpRechtdoor: boolean;
	tmpStand: TWisselstand;
	tmpZoekLijst: PWisselstandLijst;
	gevonden: boolean;
	tmpFlankLijst: PvFlankbeveiliging;
	tmpFlank: TvFlankbeveiliging;
	omgekeerd: integer;
	TotNuToeEind: PWisselstandLijst;
	tmpTotNuToe: PWisselstandLijst;
begin
	result := nil;

	TotNuToeEind := TotNuToe;
	if assigned(TotNuToeEind) then
		while assigned(TotNuToeEind^.volgende) do
			TotNuToeEind := TotNuToeEind^.Volgende;
	// Eerst even kijken of er wel om een geldige stand is gevraagd.
	if not (Stand in [wsRechtdoor, wsAftakkend]) then
		exit;
	// Tweede check: kan dit wissel niet in de gewenste stand, dan houdt het op.
	if not IndividueleWisselStandKan(Wissel, Stand) then
		exit;
	// Basischeck is afgerond. Het wissel zelf kan in de gewenste stand. Nu de
	// afhankelijkheden controleren.

	EisenLijst := nil;
	WensenLijst := nil;

	// EERST GAAN WE DE EISEN DOEN

	// Eerste type eis-afhankelijkheid: de wisselgroep.
	tmpWissel := Wissel^.Groep^.EersteWissel;
	tmpRechtdoor := Stand = wsRechtdoor;
	while assigned(tmpWissel) do begin
		// Bereken in welke stand dit wissel gezet moet worden
		if (tmpRechtdoor xor Wissel^.BasisstandRecht xor tmpWissel^.BasisstandRecht) then
			tmpStand := wsRechtdoor
		else
			tmpStand := wsAftakkend;

		// We gaan onszelf in principe toch al op de lijst zetten dus dat hoeven
		// we niet nog eens extra te gaan checken.
		if (tmpWissel <> Wissel) then begin
			tmpEisenLijst := EisenLijst;
			new(EisenLijst);
			EisenLijst^.Wissel := tmpWissel;
			EisenLijst^.Stand := tmpStand;
			EisenLijst^.StandType := ftEis;
			EisenLijst^.Volgende := tmpEisenLijst;
		end;

		tmpWissel := tmpWissel^.Volgende;
	end;

	// Tweede type eis-afhankelijkheid: flankbeveiliging.
	tmpFlankLijst := Flankbeveiliging;
	while assigned(tmpFlankLijst) do begin
		tmpFlank := tmpFlankLijst^;

		for omgekeerd := 1 to 2 do begin
			if omgekeerd = 2 then TmpFlank := OmgekeerdeFlankbeveiliging(TmpFlank);
			if tmpFlank.Soort = ftEis then
				if ((tmpFlank.OnafhWissel = Wissel) and (tmpFlank.OnafhStand = Stand)) then begin
					tmpEisenLijst := EisenLijst;
					new(EisenLijst);
					EisenLijst^.Wissel := tmpFlank.AfhWissel;
					EisenLijst^.Stand := tmpFlank.AfhStand;
					EisenLijst^.StandType := tmpFlank.Soort;
					EisenLijst^.Volgende := tmpEisenLijst;
				end;
		end;

		tmpFlankLijst := tmpFlankLijst^.Volgende;
	end;

	// Eerst zetten we onszelf maar eens op de lijst. Werkt het later allemaal
	// toch niet, dan ruimen we alles weer op.
	new(tmpLijst);
	tmpLijst^.Wissel := Wissel;
	tmpLijst^.Stand := Stand;
	tmpLijst^.StandType := ftEis;
	tmpLijst^.Volgende := nil;
	tmpLijstEind := tmpLijst;

	// En we plakken alles samen tot ��n lange totnutoe-lijst. Dat herstellen we
	// later weer.
	if assigned(TotNuToe) then begin
		tmpTotNuToe := TotNuToe;
		TotNuToeEind^.Volgende := tmpLijst;
	end else
		tmpTotNuToe := tmpLijst;

	// Nu de gevonden afhankelijkheden checken. We vergelijken alle te checken
	// afhankelijkheden met alle wisselstanden die tot nu toe al berekend zijn.
	tmpCheck := EisenLijst;
	while assigned(tmpCheck) do begin

		// Eerst kijken of dit wissel niet al op de lijst staat.
		gevonden := false;
		tmpZoekLijst := TotNuToe;
		while assigned(tmpZoekLijst) do begin
			if tmpZoekLijst^.Wissel = tmpCheck^.Wissel then begin
				// Bij een gevonden match zijn er verschillende opties.
				// 1. De standen zijn incompatible en we hebben te maken met een
				//	 eis. In dat geval kan deze oplossing niet -> afbreken.
				// 3. De standen zijn compatible -> geen actie nodig.
				gevonden := true;
				if tmpZoekLijst^.Stand <> tmpCheck^.Stand then begin
					dispose(tmpLijst);
					WisselstandenLijstDispose(EisenLijst);
					WisselstandenLijstDispose(WensenLijst);
					if assigned(TotNuToe) then TotNuToeEind^.Volgende := nil;
					exit;
				end;
			end;
			tmpZoekLijst := tmpZoekLijst^.Volgende;
		end;

		if not gevonden then begin
			// Het wissel in tmpCheck komt nog niet voor in TotNogToe.
			// Dan moeten we dus gaan kijken of het in de juiste stand gezet kan
			// worden.
			// Mogelijke opties:
			// 1. Het wissel kan in de goede stand gezet worden. Dan gaan we dat
			//	 ook doen -> dit retourneren.
			// 2. Het wissel kan niet in de goede stand gezet worden en er is
			//	 sprake van een eis -> oplossing onmogelijk -> afbreken.

			// Recursie doen
			tmpZoekLijst := WisselstandenLijstBereken(tmpCheck^.Wissel, tmpCheck^.Stand, Flankbeveiliging, tmpTotNuToe, false);

			if assigned(tmpZoekLijst) then begin
				// Hadden we een succes? Dan voegen we het resultaat aan de lijst
				// toe.
				tmpLijstEind^.Volgende := tmpZoekLijst;
				while assigned(tmpLijstEind^.Volgende) do
					tmpLijstEind := tmpLijstEind^.Volgende;
			end else begin
				// Geen succes? Dan alles opruimen.
				WisselstandenLijstDispose(tmpZoekLijst);
				WisselstandenLijstDispose(EisenLijst);
				WisselstandenLijstDispose(WensenLijst);
				if assigned(TotNuToe) then TotNuToeEind^.Volgende := nil;
				// Ook de tijdelijke lijst.
				WisselstandenLijstDispose(tmpLijst);
				exit;
			end;
		end;

		tmpCheck := tmpCheck^.Volgende;
	end;

	// NU DE WENSEN
	// tmpLijst bevat alle vereiste wisselstanden. Nu moeten we dus alle
	// van die standen bijlangs gaan om te kijken of er wensen bij horen.

	if WensenRespecteren then begin

		// Verzoek-afhankelijkheid: flankbeveiliging
		tmpCheck := tmpLijst;
		while assigned(tmpCheck) do begin
			tmpFlankLijst := Flankbeveiliging;
			while assigned(tmpFlankLijst) do begin
				tmpFlank := tmpFlankLijst^;

				for omgekeerd := 1 to 2 do begin
					if omgekeerd = 2 then TmpFlank := OmgekeerdeFlankbeveiliging(TmpFlank);
					if tmpFlank.Soort = ftVerzoek then
						if ((tmpFlank.OnafhWissel = tmpCheck^.Wissel) and (tmpFlank.OnafhStand = tmpCheck^.Stand)) then begin
							tmpWensenLijst := WensenLijst;
							new(WensenLijst);
							WensenLijst^.Wissel := tmpFlank.AfhWissel;
							WensenLijst^.Stand := tmpFlank.AfhStand;
							WensenLijst^.StandType := tmpFlank.Soort;
							WensenLijst^.Volgende := tmpWensenLijst;
						end;
				end;

				tmpFlankLijst := tmpFlankLijst^.Volgende;
			end;
			tmpCheck := tmpCheck^.Volgende;
		end;

		tmpCheck := WensenLijst;
		while assigned(tmpCheck) do begin

			// Eerst kijken of dit wissel niet al op de lijst staat.
			gevonden := false;
			tmpZoekLijst := TotNuToe;
			while assigned(tmpZoekLijst) do begin
				if tmpZoekLijst^.Wissel = tmpCheck^.Wissel then begin
					// Bij een gevonden match zijn er verschillende opties.
					// 2. De standen zijn incompatible en we hebben te maken met een
					//	 verzoek. In dat geval -> verzoek niet inwilligen -> niks doen.
					// 3. De standen zijn compatible -> geen actie nodig.
					gevonden := true;
					break;
				end;
				tmpZoekLijst := tmpZoekLijst^.Volgende;
			end;

			if not gevonden then begin
				// Het wissel in tmpCheck komt nog niet voor in TotNogToe.
				// Dan moeten we dus gaan kijken of het in de juiste stand gezet kan
				// worden.
				// Mogelijke opties:
				// 1. Het wissel kan in de goede stand gezet worden. Dan gaan we dat
				//	 ook doen -> dit retourneren.
				// 3. Het wissel kan niet in de goede stand gezet worden en er is
				//	 sprake van een verzoek -> niet inwilligen -> niks doen.

				// Recursie doen
				tmpZoekLijst := WisselstandenLijstBereken(tmpCheck^.Wissel, tmpCheck^.Stand, Flankbeveiliging, tmpTotNuToe, false);

				if assigned(tmpZoekLijst) then begin
					// Hadden we een succes? Dan voegen we het resultaat aan de lijst
					// toe.
					tmpLijstEind^.Volgende := tmpZoekLijst;
					while assigned(tmpLijstEind^.Volgende) do
						tmpLijstEind := tmpLijstEind^.Volgende;
				end;
			end;

			tmpCheck := tmpCheck^.Volgende;
		end;
	end;

	// Als we hier komen dan hebben we niks gedaan omdat alle afhankelijkheden al
	// op de lijst staan. Behalve dit wissel zelf dan, want we gaan alleen de
	// recursie in als we nog niet op de lijst staan. Dus onszelf als resultaat
	// retourneren.
	result := tmpLijst;

	if assigned(TotNuToe) then TotNuToeEind^.Volgende := nil;
	WisselstandenLijstDispose(EisenLijst);
	WisselstandenLijstDispose(WensenLijst);
end;

function WisselStandKan;
var
	StandenLijst: PWisselstandLijst;
begin
	if Lock then begin
		result := false;
		exit;
	end;

	// Eerst berekenen we alle standen die bij deze wisselstand horen.
	StandenLijst := WisselstandenLijstBereken(Wissel, Stand, Flankbeveiliging, nil, false);

	result := assigned(StandenLijst);

	WisselstandenLijstDispose(StandenLijst);
end;

function WisselsLiggenGoed2(Wissel: PvWissel; Stand: TWisselstand): boolean;
begin
	result := false;

	if not (Stand in [wsRechtdoor, wsAftakkend]) then exit;

	result := (Wissel^.Stand = Stand) and (Wissel^.Wensstand = Stand);
end;

function WisselsLiggenGoed;
var
	StandenLijst: 	PWisselstandLijst;
	tmpStand:		PWisselstandLijst;
begin
	if Lock then begin
		result := false;
		exit;
	end;

	if not (Stand in [wsRechtdoor, wsAftakkend]) then begin
		result := false;
		exit;
	end;

	// Eerst berekenen we alle standen die bij deze wisselstand horen.
	StandenLijst := WisselstandenLijstBereken(Wissel, Stand, Flankbeveiliging, nil, false);
	if not assigned(StandenLijst) then begin
		result := false;
		exit;
	end;
	tmpStand := StandenLijst;
	result := true;
	while assigned(tmpStand) do begin
		result := result and WisselsLiggenGoed2(tmpStand^.Wissel, tmpStand^.Stand);
		tmpStand := tmpStand^.Volgende;
	end;

	WisselstandenLijstDispose(StandenLijst);
end;

function WisselKanOmgezet;
begin
	case Wissel^.Wensstand of
	wsRechtdoor: result := WisselStandKan(Wissel, wsAftakkend, Flankbeveiliging);
	wsAftakkend: result := WisselStandKan(Wissel, wsRechtdoor, Flankbeveiliging);
	wsEgal:
		case Wissel^.Stand of
		wsRechtdoor: result := WisselStandKan(Wissel, wsAftakkend, Flankbeveiliging);
		wsAftakkend: result := WisselStandKan(Wissel, wsRechtdoor, Flankbeveiliging);
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
	DeStand:		  TWisselstand;
	StandenLijst: PWisselstandLijst;
	StandenLijstEind: PWisselstandLijst;
	ExtraLijst: PWisselstandLijst;
begin
	if Lock then begin
		result := false;
		exit;
	end;
	// Alle wissels moeten in de goede stand gelegd kunnen worden.
	wisselok := true;
	StandenLijst := nil;
	StandenLijstEind := nil;
	Stand := Rijweg.Wisselstanden;
	while assigned(Stand) do begin
		if Stand^.Rechtdoor then
			DeStand := wsRechtdoor
		else
			DeStand := wsAftakkend;
		// Eerst even kijken of wel een rijweg over dit wissel mag worden gelegd.
		if stand^.Wissel^.rijwegverh then begin
			wisselok := false;
			break;
		end;
		// Dan kijken of alle wissels in de goede stand kunnen.
		ExtraLijst := WisselstandenLijstBereken(Stand^.Wissel, DeStand, Flankbeveiliging, StandenLijst, false);
		if assigned(ExtraLijst) then begin
			if assigned(StandenLijstEind) then
				StandenLijstEind^.Volgende := ExtraLijst
			else begin
				StandenLijst := ExtraLijst;
				StandenLijstEind := StandenLijst;
			end;
			while assigned(StandenLijstEind^.Volgende) do
				StandenLijstEind := StandenLijstEind^.Volgende;
		end else begin
			wisselok := false;
			WisselstandenLijstDispose(ExtraLijst);
			break;
		end;
		Stand := Stand^.Volgende;
	end;
	WisselstandenLijstDispose(StandenLijst);

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
	if lock then result := 9;
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

function RijveiligheidLock;
begin
	if Lock then
		result := false
	else begin
		Lock := true;
		result := true;
	end;
end;

procedure RijveiligheidUnlock;
begin
	Lock := false;
end;


begin
	Lock := false;
end.
