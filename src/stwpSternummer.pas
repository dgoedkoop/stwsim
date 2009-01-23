unit stwpSternummer;

interface

uses Sysutils;

var
	sternr: integer = 1;

function Sternummer: string;

implementation

function Sternummer;
begin
	result := '*'+inttostr(sternr);
	inc(sternr);
end;

end.
