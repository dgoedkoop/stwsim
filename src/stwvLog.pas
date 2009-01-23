unit stwvLog;

interface

type
	TLogEvent = procedure(msg: string) of object;

	TLog = class
		OnLog:	TLogEvent;
		procedure Log(msg: string);
		constructor Create;
	end;

implementation

constructor TLog.Create;
begin
	inherited;
	OnLog := nil;
end;

procedure TLog.Log;
begin
	if assigned(OnLog) then
		OnLog(msg);
end;

end.
