unit stwvTreinComm;

interface

type
	TvMessageSoort = (vmsTreinStoptonend, vmsTreinSTSpassage, vmsTreinOpdracht,
		vmsVraagOK, vmsMonteurOpdracht, vmsInfo);

	TvMessageWie = record
		wat: string;
		ID:  string;
	end;

	PvBinnenkomendGesprek = ^TvBinnenkomendGesprek;
	TvBinnenkomendGesprek = record
		MetWie:		TvMessageWie;
		Volgende:	PvBinnenkomendGesprek;
	end;

function CmpMessageWie(eerste, tweede: TvMessageWie): Boolean;

implementation

function CmpMessageWie;
begin
	result := false;
	if (eerste.wat='r') and (tweede.wat='r') then
		result := true;
	if (eerste.wat='t') and (tweede.wat='t') and (eerste.ID = tweede.ID) then
		result := true;
end;

end.
