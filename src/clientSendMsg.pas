unit clientSendMsg;

interface

uses stwvSporen, stwvMeetpunt, stwvSeinen, stwsimComm, stwvTreinComm;

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
		function SendRawStr(s: string): TvReturned;
	public
		// Dit MOET ingesteld worden:
		SimComm:	TStringComm;
		procedure SendString(s: string);
		procedure SendWisselChg(Wissel: PvWissel);
		procedure SendWissel(Wissel: PvWissel; Stand: TWisselStand);
		procedure SendSetSein(Sein: PvSein; stand: string);
		procedure SendSetOverweg(Overweg: PvOverweg; gesloten: boolean);
		procedure SendSetTreinnr(Meetpunt: PvMeetpunt; treinnr: string);

		procedure SendBel(naar: TvMessageWie);
		procedure SendOpnemen(naar: TvMessageWie);
		procedure SendOphangen(naar: TvMessageWie);
		procedure SendMsg(naar: TvMessageWie; msg: string);

		procedure SendGetTreinStatus(treinnr: string);
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
	if Returned.Status = rsError then
		Application.MessageBox(pchar('Fout opgetreden: '+Returned.msg), 'Fout', 0);
	result := Returned;
end;

procedure TvSendMsg.SendString;
begin
	SendRawStr(s);
end;

procedure TvSendMsg.SendWisselChg;
begin
	if Wissel^.WensStand = wsRechtdoor then
		SendWissel(Wissel, wsAftakkend)
	else
		SendWissel(Wissel, wsRechtdoor);
end;

procedure TvSendMsg.SendWissel;
var
	basisstand: boolean;
	tmpWissel: PvWissel;
begin
	// Als we niks hoeven te doen, hoeven we niks te doen.
	if Wissel^.WensStand = Stand then exit;	// Staat al goed of wordt goedgezet
	// En DOEN! We zetten de hele wisselgroep om.
	basisstand := ((Stand = wsRechtdoor) = Wissel^.BasisstandRecht);
	tmpWissel := Wissel^.Groep^.EersteWissel;
	while assigned(tmpWissel) do begin
		if tmpWissel^.BasisstandRecht = basisstand then
			tmpWissel^.WensStand := wsRechtdoor
		else
			tmpWissel^.WensStand := wsAftakkend;
		if tmpWissel^.Stand <> tmpWissel^.WensStand then begin
			if tmpWissel^.WensStand = wsRechtdoor then
				SendRawStr('w:'+tmpWissel^.WisselID+',r')
			else
				SendRawStr('w:'+tmpWissel^.WisselID+',a');
		end;
		tmpWissel := tmpWissel^.Volgende;
	end;
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

procedure TvSendMsg.SendGetTreinStatus;
begin
	if treinnr = '' then exit;
	SendRawStr('tsr:'+Treinnr);
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
