unit stwpOverwegen;

interface

const
	ovAankTijd = 12;
	ovSluitTijd = 10;
	ovOpenTijd = 10;

type
	PpOverweg = ^TpOverweg;
	TpOverweg = record
		Naam:			string;
		Status:		byte;			// 0=open, 1=aankondiging, 2=sluiten, 3=dicht, 4=openen.
		VolgendeStatusTijd:	integer;
		Veranderd:	boolean;

		vanwie:				pointer;				// TClient

		Volgende:	PpOverweg;
	end;

implementation

end.
