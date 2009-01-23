unit stwvTreinComm;

interface

type
	PvMessage = ^TvMessage;
	TvMessage = record
		Trein:	string;
		Bericht:	string;
		Tijd:		integer;
		volgende: PvMessage;
	end;

implementation

end.
