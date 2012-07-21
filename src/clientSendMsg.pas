unit clientSendMsg;

interface

uses sysutils, stwvSporen, stwvMeetpunt, stwvSeinen, stwvTreinInfo, stwsimComm,
	stwvTreinComm;

const
	unknowntrainerror = 'unknown train';

type
	TvReturnedStatus = (rsWacht, rsOK, rsError);
	PvReturned = ^TvReturned;
	TvReturned = record
		status:	TvReturnedStatus;
		msg:		string;
		volgende:PvReturned;
	end;

	RichtingWat = (rwClaim, rwRelease);

	EVCommandRefused = class(Exception);
	EVTrainNotFound = class(Exception);

	TvSendMsg = class
	private
		ReturnedList: PvReturned;
		procedure SendRawStr(s: string);
		function PushReturned: PvReturned;
		function PopReturned: PvReturned;
	public
		// Dit MOET ingesteld worden:
		SimComm:	TStringComm;
		procedure SendString(s: string);
		procedure SendWissel(Wissel: PvWissel; Stand: TWisselStand);
		procedure SendSetSein(Sein: PvSein; stand: string);
		procedure SendSetOverweg(Overweg: PvOverweg; gesloten: boolean);
		procedure SendSetTreinnr(Meetpunt: PvMeetpunt; treinnr: string);
		procedure SendVertraging(TreinInfo: TvTreinInfo);

		procedure SendBel(naar: TvMessageWie);
		procedure SendOpnemen(naar: TvMessageWie);
		procedure SendOphangen(naar: TvMessageWie);
		procedure SendMsg(naar: TvMessageWie; msg: string);

		function SendGetTreinStatus(treinnr: string): TvReturned;
		procedure SendRichting(Erlaubnis: PvErlaubnis; richting: byte; hoe: RichtingWat);
		procedure SendBroadcast;
		procedure SendGetScore;
		procedure SetReturned(success: boolean; msg: string);
	end;

implementation

uses Forms;

function TvSendMsg.PushReturned;
begin
	new(result);
	result^.volgende := ReturnedList;
	ReturnedList := result;
end;

function TvSendMsg.PopReturned;
begin
	result := ReturnedList;
	if assigned(ReturnedList) then
		ReturnedList := ReturnedList^.volgende;
end;

procedure TvSendMsg.SetReturned;
var
	Returned: PvReturned;
begin
	Returned := PushReturned;
	Returned^.MSG := msg;
	if success then begin
		Returned^.status := rsOK;
	end else begin
		Returned^.Status := rsError;
	end;
end;

procedure TvSendMsg.SendRawStr;
var
	Returned: PvReturned;
	tmpReturned: TvReturned;
begin
	SimComm.SendStringToServer(s);
	repeat
		Application.HandleMessage;
		Returned := PopReturned
	until assigned(Returned);
	tmpReturned := Returned^;
	dispose(Returned);

	if Returned^.Status = rsError then
		raise EVCommandRefused.Create(tmpReturned.msg);
end;

procedure TvSendMsg.SendString;
begin
	SendRawStr(s);
end;

procedure TvSendMsg.SendWissel;
begin
	// Als we niks hoeven te doen, hoeven we niks te doen.
	if Wissel^.WensStand = Stand then exit;	// Staat al goed of wordt goedgezet

	// Wissel omzetten
	Wissel^.WensStand := Stand;
	if Wissel^.WensStand = wsRechtdoor then
		SendRawStr('w:'+Wissel^.WisselID+',r')
	else
		SendRawStr('w:'+Wissel^.WisselID+',a');
end;

procedure TvSendMsg.SendSetSein;
begin
	Sein^.Stand_wens := stand;
	SendRawStr('s:'+Sein^.Naam+','+Sein^.Stand_wens)
end;

procedure TvSendMsg.SendSetOverweg;
begin
	Overweg^.Gesloten_Wens := Gesloten;
	if Gesloten then
		SendRawStr('o:'+Overweg^.Naam+',s')
	else
		SendRawStr('o:'+Overweg^.Naam+',o');
end;

procedure TvSendMsg.SendRichting;
var
	richtingstr: string;
begin
	str(richting, richtingstr);
	if (hoe = rwClaim) then
		SendRawStr('e:'+Erlaubnis^.erlaubnisID+',c,'+richtingstr)
	else if (hoe = rwRelease) then
		SendRawStr('e:'+Erlaubnis^.erlaubnisID+',r,'+richtingstr)
end;

procedure TvSendMsg.SendSetTreinnr;
begin
	SendRawStr('m:'+Meetpunt^.meetpuntID+','+treinnr)
end;

procedure TvSendMsg.SendVertraging;
var
	vertrstr: string;
	vertrtstr: string;
begin
	str(TreinInfo.Vertraging, vertrstr);
	case TreinInfo.Vertragingsoort of
	vsExact: vertrtstr := 'ex';
	vsSchatting: vertrtstr := 'st';
	else exit
	end;
	SendRawStr('ti:'+TreinInfo.Treinnummer+',v,'+vertrtstr+','+vertrstr);
end;

procedure TvSendMsg.SendBel;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_bel:r');
	if naar.wat = 't' then
		SendRawStr('comm_bel:t,'+naar.ID);
end;

procedure TvSendMsg.SendOpnemen;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_opn:r');
	if naar.wat = 't' then
		SendRawStr('comm_opn:t,'+naar.ID);
end;

procedure TvSendMsg.SendMsg;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_msg:r,'+msg);
	if naar.wat = 't' then
		SendRawStr('comm_msg:t,'+naar.ID+','+msg);
end;

procedure TvSendMsg.SendOphangen;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_oph:r');
	if naar.wat = 't' then
		SendRawStr('comm_oph:t,'+naar.ID);
end;

function TvSendMsg.SendGetTreinStatus;
begin
	result.status := rsOK;
	result.msg := '';
	if treinnr = '' then exit;
	try
		SendRawStr('tsr:'+Treinnr)
	except
		on E: EVCommandRefused do
			if E.Message = unknowntrainerror then
				raise EVTrainNotFound.Create('Er is geen trein onder nummer '+treinnr+'.')
			else
				raise
	end;
end;

procedure TvSendMsg.SendBroadcast;
begin
	SendRawStr('bc');
end;

procedure TvSendMsg.SendGetScore;
begin
	SendRawStr('score');
end;

end.
