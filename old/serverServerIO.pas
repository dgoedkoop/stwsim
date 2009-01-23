unit serverServerIO;

interface

uses Classes, WSocket, Lists, serverClientIO, Messages, Winsock, SysUtils;

type
	PStwServer = ^TStwServer;
	TStwServer = class(TWSocket)
	private
		ListeningSocketNo: integer;
		(* Socket events *)
		procedure SessionAvailable(Sender: TObject; Error : word);
		procedure SockChangeState(Sender: TObject; OldState, NewState : TSocketState);
		procedure SockError(Sender: TObject);
	public
		ClientList: tPointerList;
		// Dingen voor de client
		ReadMsg		:  TReadMsgEvent;
		Unregister	:  TUnregisterEvent;
		LastSetPhase:	integer;
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		procedure ClientClosed(Sender: TObject; Error: word);
		procedure SendBroadcastString(s: string);
		procedure SetPhase(Phase: integer);
	end;

implementation

procedure TStwServer.SetPhase;
var
	i: integer;
	client: PClient;
begin
	LastSetPhase := Phase;
	for i := 0 to ClientList.count - 1 do begin
		client := ClientList.Get(i);
		Client^.ConnInfo.Fase := Phase;
	end;
end;

procedure TStwServer.SendBroadcastString;
var
	i: integer;
	client: PClient;
begin
	for i := 0 to ClientList.count - 1 do begin
		client := ClientList.Get(i);
		Client^.SendString(s);
	end;
end;

constructor TStwServer.Create;
begin
	inherited Create(AOwner);
	ClientList := TPointerList.Create(10);
	OnSessionAvailable := SessionAvailable;
	OnChangeState := SockChangeState;
	OnError := SockError;
	ListeningSocketNo := 0;
	LastSetPhase := 1;
   ReadMsg := nil;
end;

destructor TStwServer.Destroy;
var
	x: integer;
	client: ^TClient;
begin
	for x := ClientList.Count-1 downto 0 do begin
		client := ClientList.Remove(x);
		client^.Free;
		dispose(client);
	end;
	ClientList.Free;
	inherited;
end;

// Gracefully recover from errors. Without it, socket errors can lead to hard
// crashes of the server!

procedure TStwServer.SockError;
begin with TWSocket(Sender) do begin
	case LastError of
	10048: begin // addr+port already in use
		Close;
		end;
	10049: begin // addr not available
		Close;
		end;
	else /// unknown
	end;
end end;

procedure TStwServer.SessionAvailable;
var
	HSocket: TSocket;
	client: ^TClient;
	clientaddr: string;
begin
	// Accept the connection
	HSocket := Accept;
	// Assign it to a new client socket
	new(client);
	client^ := TClient.Create(Self);
	client^.Dup(HSocket);
	// Register the client socket
	ClientList.Add(client);
	// Check whether the client is allowed access
	Client.BufSize := 128*KB;
	clientaddr := Client.GetPeerAddr;
	// Setup properties
	Client.Server := Self;			// We register ourselves
	Client.ClientSelf := client;	// and the client's object address.
	Client.OnSessionClosed := ClientClosed;
	Client.ReadMsg := ReadMsg;
	Client.Unregister := Unregister;
	Client.ConnInfo.Username := '';
	Client.ConnInfo.Gebied := '';
	Client.ConnInfo.Fase := 1;
end;

procedure TStwServer.ClientClosed;
var
	Client: pClient;
	x: integer;
begin
	Client := TClient(Sender).ClientSelf;	// Get the client address
											// @Sender does NOT match!!!
	for x := 0 to ClientList.Count-1 do
		if ClientList.Get(x)=Client then
			ClientList.Remove(x);
	Client^.Release;
	Client^.Unregister(Client);
	dispose(client);
end;

procedure TStwServer.SockChangeState;
begin
	if NewState = wsListening then
		inc(ListeningSocketNo);
	if NewState = wsClosed then
		dec(ListeningSocketNo);
end;

end.

