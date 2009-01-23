unit serverClientIO;

interface

uses SysUtils, Classes, WSocket;

const
	KB			 = 1024;
	BlockSize = 128*KB;
	LFd = #$0A;
	LFs = #$0D#$0A;

type
	PArray = ^TArray;
	TArray = array[0..0] of byte;

	TConnInfo = record
		Username:	string;
		Gebied:		string;
		user_ok:		boolean;
		area_ok:		boolean;
		swver_ok:	boolean;
		simver_ok:	boolean;
		claim_klaar:	boolean;
		Fase:			integer;
	end;

	pClient = ^tClient;
	TReadMsgEvent = procedure(sender: pClient; msg: string) of object;
	TUnregisterEvent = procedure(sender: pClient) of object;

	tClient = class(TWSocket)
	private
		ReadQueue	:	PString;	// Contains ALL data received.
		WriteQueue	:	PString;
		WriteQueuePos:	integer;
		SendReady	:	Boolean;	// Can we send data?
	public
		ClientSelf	:	Pointer;
		Server		:	Pointer;
		ConnInfo		:  TConnInfo;
		ReadMsg		:  TReadMsgEvent;
		Unregister	:  TUnregisterEvent;
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		(* Sending of data *)
		procedure AddToQueue(s: string);
		procedure SendString(s: string);
		procedure SendNext;			// Send the next piece of data
		procedure StartSending;
		procedure DataSent(Sender: TObject; Error: Word);
		(* Receiving of data *)
		procedure DataAvailable(Sender : TObject; Error: Word);
		(* Error handling *)
		procedure SockError(Sender: TObject);
	end;

implementation

constructor tClient.Create;
begin
	inherited;
	// Make a new queue for read data
	New(ReadQueue);
	ReadQueue^ := '';
	// Indicate we can start sending without DataSent event
	SendReady := true;
	// Point the data to write to NIL as we haven't had a request yet
	new(WriteQueue);
	WriteQueue^ := '';
	WriteQueuePos := 1;
	// And assign the right events.
	OnDataSent := DataSent;
	OnDataAvailable := DataAvailable;
	OnError := SockError;	// Gracefully handle errors from clients

	ConnInfo.user_ok := false;
	ConnInfo.area_ok := false;
	ConnInfo.swver_ok := false;
	ConnInfo.simver_ok := false;
	ConnInfo.claim_klaar := false;

	ScoreInfo.AankomstOpTijd := 0;
	ScoreInfo.AankomstBinnenDrie := 0;
	ScoreInfo.AankomstTeLaat := 0;
	ScoreInfo.PerronCorrect := 0;
	ScoreInfo.PerronFout := 0;
end;

destructor TClient.Destroy;
begin
	// Clean up memory
	dispose(readqueue);
	ReadQueue := nil;
	if assigned(WriteQueue) then
		dispose(writeQueue);
	inherited;
end;

procedure TClient.AddToQueue;
var
	oldlen: integer;
begin
	oldlen := length(WriteQueue^);
	SetLength(WriteQueue^, length(WriteQueue^)+length(s));
	move(s[1], WriteQueue^[oldlen+1], length(s));
	StartSending;
end;

procedure TClient.SendString;
begin
	AddToQueue(s+LFs);
end;

procedure TClient.SendNext;
var
	buffer: PArray;
	buffer2: ansistring;
	sendsize: longint;
begin
	// Don't do anything when there's nothing to do
	if not assigned(WriteQueue) or (WriteQueuePos = Length(WriteQueue^)+1) then
		exit;
	// Indicate we are sending data
	SendReady := false;
	// Calculate size of data to send
	if Length(WriteQueue^)-WriteQueuePos+1 >= BlockSize then
		SendSize := BlockSize
	else
		SendSize := Length(WriteQueue^)-WriteQueuePos+1;
	// Claim enough memory
	Getmem(buffer, SendSize);
	// Fill buffer
	buffer2 := Copy(WriteQueue^, WriteQueuePos, SendSize);
	move(buffer2[1], Buffer^, SendSize);
	// Increase counter
	inc(WriteQueuePos, SendSize);
	// And send
	Send(buffer, SendSize);
	// Free memory
	Freemem(buffer, BlockSize);
	// If we are finished, clean up WriteQueue etc.
	if (WriteQueuePos = Length(WriteQueue^)+1) then begin
		SetLength(WriteQueue^,0);
		WriteQueuePos := 1;
	end;
end;

procedure TClient.StartSending;
begin
	if SendReady then
		SendNext;
end;

procedure TClient.DataSent;
begin
	// Indicating data was sent
	SendReady := true;
	// Send the next piece of data. No if's required as SendNext will just
	// do nothing when nothing needs to be done.
	SendNext;
end;

procedure TClient.DataAvailable;
var
	buffer: PArray;
	recvsize: longint;
	oldlength: longint;
	// Interpreteren
	p: integer;
	t: string;
begin
	// If ReadQueue is not assigned, that means that Unregister has already
	// been called. Let's close the socket, discard any data left and do
	// nothing more.
	if not assigned(ReadQueue) then begin
		CloseDelayed;
		getmem(buffer, BlockSize);
		repeat
			recvsize := receive(buffer, BlockSize);
		until recvsize <= 0;
		freemem(buffer, BlockSize);
		exit;
	end;
	// Allocate memory for buffer
	getmem(buffer, BlockSize);
	// Get the received data
	repeat
		recvsize := receive(buffer, BlockSize);
		if recvsize > 0 then begin
			oldlength := length(ReadQueue^);
			setLength(ReadQueue^, oldLength+recvsize);
			move(buffer^, ReadQueue^[oldLength+1], recvsize);
		end;
	until recvsize <= 0;

	// Free buffer
	freemem(buffer, BlockSize);

	// If we did not recieve anything at all, better do nothing.
	if readqueue^='' then
		exit;

	// Interprete received data which is in ReadQueue^ now.

	repeat
		p := pos(LFd, readqueue^);
		if p <> 0 then begin
			t := copy(ReadQueue^,1,p-1);
			if t[length(t)] = #$D then
				setlength(t, length(t)-1);
			Move(ReadQueue^[p+1], ReadQueue^[1], length(ReadQueue^)-p);
			SetLength(ReadQueue^, length(ReadQueue^)-p);
			ReadMsg(ClientSelf, t);
		end;
	until p = 0;
end;

procedure TClient.SockError;
begin
	case LastError of
	10057:		(* Socket was closed while sending *)
	else
	end;
end;

end.
