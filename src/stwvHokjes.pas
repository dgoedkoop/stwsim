unit stwvHokjes;

interface

uses stwvMeetpunt, stwvSeinen, stwvSporen;

type
	// Een bedienscherm bestaat uit 127 x 40 hokjes.

	PvHokjeTreinNummer = ^TvHokjeTreinNummer;
	TvHokjeTreinNummer = record
		Meetpunt: PvMeetpunt;	// Voor treinnummerweergave
		TekstIndex: integer;		// Welke letter uit treinnummer
		MaxTextIndex: integer;	// Hoeveel hokjes zijn er?
	end;

	// Een TvHokje heeft niks met fysieke hokjes te maken...
	// Soorten:
	// 0 = leeg
	// 1 = spoor (evt. vervangbaar door trein/spoornummer)
	// 2 = vaste tekst (letter)
	// 3 = sein
	// 4 = landschap
	// 5 = wissel
	// 6 = rijrichtingsveld
	TvHokje = record
		soort:	integer;
		grdata:	pointer;	// ^TvHokjeSpoor of ^TvHokjeLetter of ^TvHokjeSein
								// of ^TvHokjeLS
		dyndata:	PvHokjeTreinNummer; // ^TvHokjeTreinNummer
	end;

	PvHokjesArray = ^TvHokjesArray;
	TvHokjesArray = array[0..0] of TvHokje;

	PvHokjeSpoor = ^TvHokjeSpoor;
	TvHokjeSpoor = record
		GrX, GrY: integer;		// Welk plaatje uit de bitmap? Beginnen bij 0,0
		InactiefWegensRijweg: boolean;
										// Niet bezet tonen omdat een rijweg is ingesteld
										// die niet langs dit vakje komt.
		RechtsonderKruisRijweg: byte;
										// Voor als hier een kruising is: gaat de huidige
										// rijweg naar rechtsonder (\ = 1) of naar
										// linksonder (/ = 2)?
		DriehoekjeSein:	PvSein;
										// Welk sein voor een rijwegrichtingdriehoekje?
		Meetpunt: PvMeetpunt;	// Voor bezetmelding
	end;

	PvHokjeWissel = ^TvHokjeWissel;
	TvHokjeWissel = record
		GrX, GrY: integer;		// Welk plaatje uit de bitmap? Beginnen bij 0,0
		Meetpunt: PvMeetpunt;	// Voor bezetmelding
		InactiefWegensRijweg: boolean;
										// Niet bezet tonen omdat een rijweg is ingesteld
										// die niet langs dit vakje komt.
		SchuinIsRecht: boolean;	// Als de rechte stand op het scherm diagonaal loopt.
		Wissel:	 PvWissel;
	end;

	PvHokjeSein = ^TvHokjeSein;
	TvHokjeSein = record
		GrX, GrY: integer;		// Welk plaatje uit de bitmap? Beginnen bij 0,0
		Sein: 	 PvSein;			// Voor seinbeeldweergave.
	end;

	PvHokjeErlaubnis = ^TvHokjeErlaubnis;
	TvHokjeErlaubnis = record
		GrX, GrY: integer;			// Welk plaatje uit de bitmap? Beginnen bij 0,0
		Erlaubnis: 	 PvErlaubnis;	// Voor weergave.
		ActiefStand: byte;			// Bij welke stand oplichten?
	end;

	PvHokjeLS = ^TvHokjeLS;
	TvHokjeLS = record
		GrX, GrY: integer;		// Welk plaatje uit de bitmap? Beginnen bij 0,0
	end;

	PvHokjeLetter = ^TvHokjeLetter;
	TvHokjeLetter = record
		Letter:	string;
		Kleur:	byte;				// DOS-kleurnummer
		Spoornummer:	string;
		SeinWisselNr:	boolean;
	end;

implementation

end.
