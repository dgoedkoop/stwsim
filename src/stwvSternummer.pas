unit stwvSternummer;

interface

uses Sysutils, stwvMisc;

var
	sternr: integer = 1;

function Sternummer: string;

implementation

function Sternummer;
begin
	result := '*'+Pad(inttostr(sternr), 5, '0', vaVoor);
	inc(sternr);
end;

end.
