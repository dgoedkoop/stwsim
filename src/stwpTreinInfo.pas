unit stwpTreinInfo;

interface

type
	TpVertragingType = (vtExact, vtSchatting);
	PpTreinInfo = ^TpTreinInfo;
	TpTreinInfo = record
		Treinnummer: 		string;
		Vertraging: 		integer;
		Vertragingtype: 	TpVertragingtype;
		gewijzigd:			boolean;
		Volgende: 			PpTreinInfo;
	end;

procedure ScoreVertraging(TreinInfo: PpTreinInfo; vertraging: integer;
	vertragingtype: TpVertragingType);

implementation

procedure ScoreVertraging;
begin
	if (TreinInfo.Vertragingtype = vtExact) and
		(vertragingtype = vtSchatting) then exit;
	if TreinInfo.Vertragingtype <> vertragingtype then begin
		TreinInfo.Vertragingtype := vertragingtype;
		TreinInfo.gewijzigd := true
	end;
	if TreinInfo.Vertraging <> vertraging then begin
		TreinInfo.Vertraging := vertraging;
		TreinInfo.gewijzigd := true
	end;
end;

end.
