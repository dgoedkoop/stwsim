unit stwvSporen;

interface

uses stwvMeetpunt, Graphics;

type
	PvWisselGroep = ^TvWisselGroep;

	TWisselStand = (wsRechtdoor, wsAftakkend, wsOnbekend, wsEgal);
	TWisselstandType = (ftEis, ftVerzoek);

	PvWissel = ^TvWissel;
	TvWissel = record
		WisselID			: string;
		Groep				: PvWisselGroep;
		BasisstandRecht: boolean;		// Is de basisstand rechtdoor?
												// (Een wissel moet precies in ��n groep zitten)
		Stand				: TWisselStand;
		WensStand		: TWisselStand;
		Meetpunt			: PvMeetpunt;	// Welk meetpunt mag niet bezet zijn?
		RijwegOnderdeel: pointer;
		rijwegverh		: boolean;
		registered		: boolean;
		changed			: boolean;
		volgende			: PvWissel;
	end;

	PWisselstandLijst = ^TWisselstandLijst;
	TWisselstandLijst = record
		Wissel	: PvWissel;
		Stand		: TWisselstand;
		StandType: TWisselstandType;
		Volgende	: PWisselstandLijst;
	end;

	PvFlankbeveiliging = ^TvFlankbeveiliging;
	TvFlankbeveiliging = record
		Soort				: TWisselstandType;
		OnafhWissel		: PvWissel;
		OnafhStand		: TWisselStand;
		AfhWissel		: PvWissel;
		AfhStand			: TWisselStand;
		volgende			: PvFlankbeveiliging;
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
function StandTypeNr(StandType: TWisselstandType): byte;
function NrStandType(nr: integer): TWisselstandType;
function OmgekeerdeFlankbeveiliging(Flankbeveiliging: TvFlankbeveiliging): TvFlankbeveiliging;
function MergeType(eerste, tweede: TWisselstandType): TWisselstandType;

implementation

function StandNr;
begin
	case Stand of
	wsRechtdoor: result := 0;
	wsAftakkend: result := 1;
	wsOnbekend : result := 2;
	wsEgal	  : result := 3;
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

function StandTypeNr;
begin
	case StandType of
	ftEis		  : result := 0;
	ftVerzoek  : result := 1;
	else
		result := 3;
	end;
end;

function NrStandType;
begin
	case Nr of
	0: result := ftEis;
	1: result := ftVerzoek;
	else
		result := ftEis; // Dit hoort eigenlijk niet voor te komen!
	end;
end;

function OmgekeerdeFlankbeveiliging;
begin
	Result.Soort := Flankbeveiliging.Soort;
	Result.OnafhWissel := Flankbeveiliging.AfhWissel;
	Result.OnafhStand := wsEgal;
	Result.AfhWissel := Flankbeveiliging.OnafhWissel;
	Result.AfhStand := wsEgal;
	if Flankbeveiliging.OnafhStand = wsRechtdoor then
		Result.AfhStand := wsAftakkend
	else if Flankbeveiliging.OnafhStand = wsAftakkend then
		Result.AfhStand := wsRechtdoor;
	if Flankbeveiliging.AfhStand = wsRechtdoor then
		Result.OnafhStand := wsAftakkend
	else if Flankbeveiliging.AfhStand = wsAftakkend then
		Result.OnafhStand := wsRechtdoor;
	Result.Volgende := Flankbeveiliging.Volgende;
end;

function MergeType;
begin
	if ((eerste = ftVerzoek) or (tweede = ftVerzoek)) then
		result := ftVerzoek
	else
		result := ftEis;
end;

end.
