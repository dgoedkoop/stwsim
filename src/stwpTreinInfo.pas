unit stwpTreinInfo;

interface

uses stwpTijd;

type
	TpVertragingType = (vtExact, vtSchatting);
	PpTreinInfo = ^TpTreinInfo;
	TpTreinInfo = record
		Treinnummer: 		string;
		Vertraging: 		integer;
		Vertragingtype: 	TpVertragingtype;
		Vertragingplaats:	string;
		gewijzigd:			boolean;
		Volgende: 			PpTreinInfo;
	end;

procedure ScoreVertraging(TreinInfo: PpTreinInfo; vertraging: integer;
	vertragingtype: TpVertragingType; Locatienaam: string);

implementation

procedure ScoreVertraging;
begin
	if (TreinInfo.Vertragingtype = vtExact) and
		(vertragingtype = vtSchatting) then exit;
	if TreinInfo.Vertragingtype <> vertragingtype then begin
		TreinInfo.Vertragingtype := vertragingtype;
		TreinInfo.gewijzigd := true
	end;
	// De locatie werken we alleen bij als het tijdsverschil een minutensprong
	// veroorzaakt
	if (round(TreinInfo.Vertraging / MkTijd(0,1,0)) <> round(vertraging / MkTijd(0,1,0))) or
		((TreinInfo.Vertragingplaats = '') and (Locatienaam <> '')) then begin
		TreinInfo.Vertragingplaats := Locatienaam;
		TreinInfo.gewijzigd := true;
	end;
	// Maar de vertraging zelf werken we altijd bij!
	if TreinInfo.Vertraging <> vertraging then begin
		TreinInfo.Vertraging := vertraging;
		TreinInfo.gewijzigd := true
	end;
end;

end.
