unit clientSendMsg;

interface

uses stwvSporen, stwvMeetpunt, stwvSeinen, stwvTreinInfo, stwsimComm, stwvTreinComm;

type
	TvReturnedStatus = (rsWacht, rsOK, rsError);
	TvReturned = record
		status:	TvReturnedStatus;
		msg:		string;
	end;

	RichtingWat = (rwClaim, rwRelease);

	TvSendMsg = class
	private
		Returned: TvReturned;
		function SendRawStr(s: string; displayError: boolean): TvReturned;
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

procedure TvSendMsg.SetReturned;
begin
	if success then Returned.status := rsOK
	else Returned.Status := rsError;
	Returned.MSG := msg;
end;

function TvSendMsg.SendRawStr;
begin
	Returned.status := rsWacht;
	SimComm.SendStringToServer(s);
	repeat
		Application.HandleMessage
	until Returned.status in [rsOK, rsError];
	if (Returned.Status = rsError) and DisplayError then
		Application.MessageBox(pchar('Fout opgetreden: '+Returned.msg), 'Fout', 0);
	result := Returned;
end;

procedure TvSendMsg.SendString;
begin
	SendRawStr(s,true);
end;

procedure TvSendMsg.SendWissel;
begin
	// Als we niks hoeven te doen, hoeven we niks te doen.
	if Wissel^.WensStand = Stand then exit;	// Staat al goed of wordt goedgezet

	// Wissel omzetten
	Wissel^.WensStand := Stand;
	if Wissel^.WensStand = wsRechtdoor then
		SendRawStr('w:'+Wissel^.WisselID+',r',true)
	else
		SendRawStr('w:'+Wissel^.WisselID+',a',true);
end;

procedure TvSendMsg.SendSetSein;
begin
	Sein^.Stand_wens := stand;
	SendRawStr('s:'+Sein^.Naam+','+Sein^.Stand_wens,true)
end;

procedure TvSendMsg.SendSetOverweg;
begin
	Overweg^.Gesloten_Wens := Gesloten;
	if Gesloten then
		SendRawStr('o:'+Overweg^.Naam+',s',true)
	else
		SendRawStr('o:'+Overweg^.Naam+',o',true);
end;

procedure TvSendMsg.SendRichting;
var
	richtingstr: string;
begin
	str(richting, richtingstr);
	if (hoe = rwClaim) then
		SendRawStr('e:'+Erlaubnis^.erlaubnisID+',c,'+richtingstr,true)
	else if (hoe = rwRelease) then
		SendRawStr('e:'+Erlaubnis^.erlaubnisID+',r,'+richtingstr,true)
end;

procedure TvSendMsg.SendSetTreinnr;
begin
	SendRawStr('m:'+Meetpunt^.meetpuntID+','+treinnr,true)
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
	SendRawStr('ti:'+TreinInfo.Treinnummer+',v,'+vertrtstr+','+vertrstr, true);
end;

procedure TvSendMsg.SendBel;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_bel:r',true);
	if naar.wat = 't' then
		SendRawStr('comm_bel:t,'+naar.ID,true);
end;

procedure TvSendMsg.SendOpnemen;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_opn:r',true);
	if naar.wat = 't' then
		SendRawStr('comm_opn:t,'+naar.ID,true);
end;

procedure TvSendMsg.SendMsg;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_msg:r,'+msg,true);
	if naar.wat = 't' then
		SendRawStr('comm_msg:t,'+naar.ID+','+msg,true);
end;

procedure TvSendMsg.SendOphangen;
begin
	if naar.wat = 'r' then
		SendRawStr('comm_oph:r',true);
	if naar.wat = 't' then
		SendRawStr('comm_oph:t,'+naar.ID,true);
end;

function TvSendMsg.SendGetTreinStatus;
begin
	result.status := rsOK;
	result.msg := '';
	if treinnr = '' then exit;
	result := SendRawStr('tsr:'+Treinnr,false);
end;

procedure TvSendMsg.SendBroadcast;
begin
	SendRawStr('bc',true);
end;

procedure TvSendMsg.SendGetScore;
begin
	SendRawStr('score',true);
end;

end.
