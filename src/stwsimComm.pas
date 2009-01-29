unit stwsimComm;

interface

type
	TReceiveEvent = procedure(s: string) of object;

	TStringComm = class
//		log: string;
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
//	log := log + '>' + s + #13#10;
	if assigned(ReceiveEventServer) then
		ReceiveEventServer(s);
end;

procedure TStringComm.SendStringToClient;
begin
//	log := log + '<' + s + #13#10;
	if assigned(ReceiveEventClient) then
		ReceiveEventClient(s);
end;

end.
