unit stwsimComm;

interface

type
	TReceiveEvent = procedure(s: string) of object;

	TStringComm = class
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
end;

procedure TStringComm.SendStringToServer;
begin
	if assigned(ReceiveEventServer) then
		ReceiveEventServer(s);
end;

procedure TStringComm.SendStringToClient;
begin
	if assigned(ReceiveEventClient) then
		ReceiveEventClient(s);
end;

end.
