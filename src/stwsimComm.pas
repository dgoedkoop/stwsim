unit stwsimComm;

interface

{//$DEFINE LogFile}

type
	TReceiveEvent = procedure(s: string) of object;

	TStringComm = class
		{$IFDEF LogFile}
		logfile: textfile;
		{$ENDIF}
		ReceiveEventServer, ReceiveEventClient: TReceiveEvent;
		procedure SendStringToServer(s: string);
		procedure SendStringToClient(s: string);
		constructor Create;
	end;

implementation

constructor TStringComm.Create;
begin
	ReceiveEventServer := nil;
	ReceiveEventClient := nil;
	{$IFDEF LogFile}
	assignfile(logfile, 'log.txt');
	rewrite(logfile);
	{$ENDIF}
end;

procedure TStringComm.SendStringToServer;
begin
	{$IFDEF LogFile}writeln(logfile, '>' + s);{$ENDIF}
	if assigned(ReceiveEventServer) then
		ReceiveEventServer(s);
end;

procedure TStringComm.SendStringToClient;
begin
	{$IFDEF LogFile}writeln(logfile,'<' + s);{$ENDIF}
	if assigned(ReceiveEventClient) then
		ReceiveEventClient(s);
end;

end.
