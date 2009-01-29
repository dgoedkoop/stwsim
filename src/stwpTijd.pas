unit stwpTijd;

interface

function MkTijd(u,m,s: integer): integer;
procedure FmtTijd(tt: integer; var u,m,s: integer);
function TijdStr(t: integer; seconden: boolean): string;
function MinSecStr(t: integer): string;

procedure SetTijd(tt: integer);
function GetTijd: integer;
function TijdVerstreken(tt: integer): boolean;

function RandomWachtTijd(mint, maxt: double): integer;

implementation

var
	t:	integer;

function MkTijd;
begin
	result := s+m*60+u*60*60;
end;

procedure FmtTijd;
begin
	s := tt mod 60;
	tt := (tt - s) div 60;
	m := tt mod 60;
	tt := (tt - m) div 60;
	u := tt mod 24;
end;

function TijdStr;
var
	u,m,s: integer;
	us,ms,ss: string;
begin
	if t = -1 then begin
		us := '--';
		ms := '--';
		ss := '--';
	end else begin
		FmtTijd(t, u, m, s);
		str(u,us); if length(us)=1 then us:='0'+us;
		str(m,ms); if length(ms)=1 then ms:='0'+ms;
		str(s,ss); if length(ss)=1 then ss:='0'+ss;
	end;
	if seconden then
		result := us+':'+ms+':'+ss
	else
		result := us+':'+ms;
end;

function MinSecStr;
var
	u,m,s: integer;
	ms,ss: string;
begin
	if t = -1 then begin
		result := '--:--';
		exit;
	end;
	FmtTijd(t, u, m, s);
	str(u*60+m,ms); if length(ms)=1 then ms:='0'+ms;
	str(s,ss); if length(ss)=1 then ss:='0'+ss;
	result := ms+':'+ss;
end;

procedure SetTijd;
begin
	t := tt;
end;

function GetTijd;
begin
	result := t;
end;

function TijdVerstreken;
begin
	result := t >= tt;
end;

function RandomWachtTijd;
begin
	result := GetTijd + round(mint*60) + round(random * (maxt-mint)*60);
end;

end.
