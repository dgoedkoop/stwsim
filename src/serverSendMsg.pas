unit serverSendMsg;

interface

uses lists, stwpMeetpunt, stwpSeinen, stwpRails, stwpTreinen, stwpOverwegen,
	stwsimComm;

const
	LF = #$0A;

type
	PpSendMsg = ^TpSendMsg;
	TpSendMsg = class
		// privé
		msgstr:	string;
		// publiek
		pAlleMeetpunten: 		PpMeetpunt;
		SimComm: TStringComm;
		procedure SendMeetpuntMsg(Meetpunt: PpMeetpunt);
		procedure SendErlaubnisMsg(Erlaubnis: PpErlaubnis);
		procedure SendWisselMsg(Wissel: PpWissel);
		procedure SendSeinMsg(Sein: PpSein);
		procedure SendOverwegMsg(Overweg: PpOverweg);
		procedure SendMsgVanTrein(Trein: Pptrein; s: string);
		procedure SendDefectSeinMsg(Sein: PpSein; seinbeeldDefect: TSeinbeeld);
		procedure SendPlainString(s: string);
	end;

implementation

procedure TpSendMsg.SendPlainString;
begin
	SimComm.SendStringToClient(s);
end;

procedure TpSendMsg.SendDefectSeinMsg;
begin
	// Bericht sturen.
	if (sein^.bediend or sein^.autosein) then begin
		if seinbeeldDefect = sbGroen then
			SendPlainString('defect:s,'+Sein^.naam+',g');
		if seinbeeldDefect = sbGeel then
			SendPlainString('defect:s,'+Sein^.naam+',gl');
	end;
end;

procedure TpSendMsg.SendMeetpuntMsg;
begin
	if not Meetpunt^.veranderd then exit;
	Meetpunt^.Veranderd := false;
	if not Meetpunt^.Bezet then
		SendPlainString('m:'+Meetpunt^.Naam+',v,'+Meetpunt^.Treinnaam)
	else
		SendPlainString('m:'+Meetpunt^.Naam+',b,'+Meetpunt^.Treinnaam);
end;

procedure TpSendMsg.SendErlaubnisMsg;
var
	richtingstr: string;
begin
	if not Erlaubnis^.veranderd then exit;
	Erlaubnis^.Veranderd := false;
	str(Erlaubnis^.richting, richtingstr);
	if Erlaubnis^.vergrendeld then
		SendPlainString('e:'+Erlaubnis^.Naam+','+richtingstr+',j')
	else
		SendPlainString('e:'+Erlaubnis^.Naam+','+richtingstr+',n');
end;

procedure TpSendMsg.SendWisselMsg;
begin
	if not Wissel^.veranderd then exit;
	Wissel^.Veranderd := false;
	if Wissel^.stand_aftakkend <> Wissel^.nw_aftakkend then
		SendPlainString('w:'+Wissel^.w_naam+',u')
	else if Wissel^.stand_aftakkend then
		SendPlainString('w:'+Wissel^.w_naam+',a')
	else
		SendPlainString('w:'+Wissel^.w_naam+',r');
end;

procedure TpSendMsg.SendSeinMsg;
begin
	if not Sein^.veranderd then exit;
	Sein^.Veranderd := false;
	if (sein^.bediend or sein^.autosein) then begin
		if Sein^.H_Maxsnelheid <> 0 then
			SendPlainString('s:'+Sein^.naam+',g')
		else
			SendPlainString('s:'+Sein^.naam+',r');
	end;
end;

procedure TpSendMsg.SendOverwegMsg;
var
	statusstr: string;
begin
	if not Overweg^.veranderd then exit;
	Overweg^.Veranderd := false;
	str(Overweg^.Status, statusstr);
	if Overweg^.Status in [0,4] then
		SendPlainString('o:'+Overweg^.Naam+',o')
	else if Overweg^.Status = 3 then
		SendPlainString('o:'+Overweg^.Naam+',s');
end;

procedure TpSendMsg.SendMsgVanTrein;
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := Trein^.pos_rail^.meetpunt;
	if not assigned(Meetpunt) then exit;
	SendPlainString('mmsg:'+Trein^.Treinnummer+','+s);
end;

end.
