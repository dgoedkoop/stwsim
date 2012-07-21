unit stwvTreinInfo;

interface

type
	TVertragingSoort = (vsSchatting, vsExact);
	TvTreinInfo = record
		Treinnummer:		string;
		Vertraging:			integer;
		Vertragingsoort:	TVertragingSoort;
	end;

implementation

end.
