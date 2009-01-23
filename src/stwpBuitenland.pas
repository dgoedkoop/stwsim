unit stwpBuitenland;

interface

uses stwpRails;

// Dit is een hele simpele interface.
// Het meeste moet namelijk door het hoofdprogramma worden gedaan.

// Het werkt zo: als een trein niet weet waar hij heen moet rijden, omdat
// het spoor ophoudt maar de snelheid niet 0 is, dan rijdt deze voorbij het
// einde van het spoor.
// Op dat moment komt het hoofdprogramma in actie. Is het namelijk een spoor
// met een externe connectie, dan wordt de trein van het spoor gehaald en aan
// deze connectie gegeven.
// Omgekeerd kan helemaal aan het puntje van een extern spoor ook een nieuwe
// trein worden neergezet.
// Het verdient dus aanbeveling dat het meetpuntbereik van een extern spoor
// lang genoeg is om een hele trein te bevatten - anders zal het er op het
// beeldscherm allemaal niet heel mooi uitzien.

// Uiteindelijk is het de bedoeling dat er twee libraries bestaan:
// Voor off-line gebruik: op vastgestelde tijden worden nieuwe treinen op
//   het spoor gezet. Treinen die buiten bereik rijden verdwijnen.
// Voor on-line gebruik: sporen van verschillende partijen moeten aan elkaar
//   gekoppeld kunnen worden. Treinen die bij de een buiten beeld rijden
//   komen dan op hetzelfde moment bij de andere speler op het scherm. 

type
	PpRailExtConn = ^TpRailExtConn;
	TpRailExtConn = record
		Soort:		integer;	// Wat voor connectie hebben we hier?
									// 0 = Verschijnplan-connectie
									// 1 = Buurseinhuis-connectie
		Spoor:		PpRail;	// Met welk spoor is deze connectie verbonden?
		data:			pointer;
      volgende:	PpRailExtConn;
   end;

implementation

end.
