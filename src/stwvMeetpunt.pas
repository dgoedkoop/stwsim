unit stwvMeetpunt;

interface

type
	PvErlaubnis = ^TvErlaubnis;
	TvErlaubnis = record
		erlaubnisID		: string;
		richting			: byte;
		vergrendeld		: boolean;
		registered		: boolean;
		changed			: boolean;
		volgende			: PvErlaubnis;
	end;

	PvMeetpunt = ^TvMeetpunt;
	TvMeetpunt = record
		meetpuntID		: string;
		bezet				: boolean;
		treinnummer		: string;
		RijwegOnderdeel: pointer;
		registered		: boolean;
		changed			: boolean;
		volgende			: PvMeetpunt;
		// Gegevens voor aankondiging
		Aankondiging	: boolean;
		Aank_Spoor		: string;
		Aank_Erlaubnis : PvErlaubnis;
		Aank_Erlaubnisstand:	byte;
	end;

function OmgekeerdeErlaubnisstand(stand: byte): byte;

implementation

function OmgekeerdeErlaubnisstand;
begin
	case stand of
	1: result := 2;
	2: result := 1;
	else
		result := 0;
	end;
end;


end.
