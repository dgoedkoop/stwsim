unit stwvSporen;

interface

uses stwvMeetpunt, Graphics;

type
	PvWisselGroep = ^TvWisselGroep;

	TWisselStand = (wsRechtdoor, wsAftakkend, wsOnbekend, wsEgal);

	PvWissel = ^TvWissel;
	TvWissel = record
		WisselID			: string;
		Groep				: PvWisselGroep;
		BasisstandRecht: boolean;		// Is de basisstand rechtdoor?
												// (Een wissel moet precies in één groep zitten)
		Stand				: TWisselStand;
		WensStand		: TWisselStand;
		Meetpunt			: PvMeetpunt;	// Welk meetpunt mag niet bezet zijn?
		RijwegOnderdeel: pointer;
		rijwegverh		: boolean;
		registered		: boolean;
		changed			: boolean;
		volgende			: PvWissel;
	end;

	TvWisselGroep = record
		GroepID			: string;
		EersteWissel	: PvWissel;
		OnbekendAanwezig:	boolean;
		bedienverh		: boolean;
		Volgende			: PvWisselGroep;
	end;

	PvMeetpuntLijst = ^TvMeetpuntLijst;
	TvMeetpuntLijst = record
		Meetpunt			: PvMeetpunt;
		Volgende			: PvMeetpuntLijst;
	end;

	PvOverweg = ^TvOverweg;
	TvOverweg = record
		Naam				: string;
		Gesloten			: boolean;
		Gesloten_Wens	: boolean;
		Meetpunten		: PvMeetpuntLijst;
		AankMeetpunten	: PvMeetpuntLijst;

		registered		: boolean;
		changed			: boolean;
		volgende			: PvOverweg;
	end;

function StandNr(Stand: TWisselStand): byte;
function NrStand(nr: integer): TWisselStand;

implementation

function StandNr;
begin
	case Stand of
	wsRechtdoor: result := 0;
	wsAftakkend: result := 1;
	wsOnbekend : result := 2;
	wsEgal     : result := 3;
	else
		result := 4;
	end;
end;

function NrStand;
begin
	case Nr of
	0: result := wsRechtdoor;
	1: result := wsAftakkend;
	2: result := wsOnbekend;
	3: result := wsEgal;
	else
		result := wsOnbekend;
	end;
end;

end.
