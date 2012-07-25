unit stwsimComm;

interface

uses stwpTijd;

type
	TReceiveEvent = procedure(s: string) of object;

	TStringComm = class
	private
		dolog: boolean;
		logfile: textfile;
	public
		ReceiveEventServer, ReceiveEventClient: TReceiveEvent;
		procedure SendStringToServer(s: string);
		procedure SendStringToClient(s: string);
		procedure SetLog(value: boolean);
		constructor Create;
	end;

implementation

constructor TStringComm.Create;
begin
	ReceiveEventServer := nil;
	ReceiveEventClient := nil;
	dolog := false;
end;

procedure TStringComm.SendStringToServer;
begin
	if dolog then writeln(logfile, TijdStr(GetTijd,true)+': >' + s);
	if assigned(ReceiveEventServer) then
		ReceiveEventServer(s);
end;

procedure TStringComm.SendStringToClient;
begin
	if dolog then writeln(logfile,TijdStr(GetTijd,true)+': <' + s);
	if assigned(ReceiveEventClient) then
		ReceiveEventClient(s);
end;

procedure TStringComm.SetLog;
begin
	if (not dolog) and value then begin
		assignfile(logfile, 'log.txt');
		rewrite(logfile);
		dolog := true
	end else if dolog and not value then begin
		closefile(logfile);
		dolog := false;
	end;
end;

end.
