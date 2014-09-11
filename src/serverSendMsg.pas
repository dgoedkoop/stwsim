unit serverSendMsg;

interface

uses lists, stwpMeetpunt, stwpSeinen, stwpRails, stwpTreinen, stwpOverwegen,
	stwpTreinInfo, stwsimComm, stwpDatatypes;

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
		procedure SendErlaubnisAlsMeetpuntMsg(Erlaubnis: PpErlaubnis);
		procedure SendErlaubnisMsg(Erlaubnis: PpErlaubnis);
		procedure SendWisselMsg(Wissel: PpWissel);
		procedure SendSeinMsg(Sein: PpSein);
		procedure SendOverwegMsg(Overweg: PpOverweg);
		procedure SendTreinInfo(TreinInfo: PpTreinInfo);

		procedure SendBel(van: PpTrein); overload;
		procedure SendBel(van: string); overload;
		procedure SendOpnemen(van: PpTrein); overload;
		procedure SendOpnemen(van: string); overload;
		procedure SendOphangen(van: PpTrein); overload;
		procedure SendOphangen(van: string); overload;
		procedure SendMsg(van: PpTrein; soort: TpMsgSoort; s: string); overload;
		procedure SendMsg(van: string; soort: TpMsgSoort; s: string); overload;

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

procedure TpSendMsg.SendErlaubnisAlsMeetpuntMsg;
begin
	if not Erlaubnis^.b_veranderd then exit;
	Erlaubnis^.b_Veranderd := false;
	if not Erlaubnis^.bezet then
		SendPlainString('m:'+Erlaubnis^.Naam+',v')
	else
		SendPlainString('m:'+Erlaubnis^.Naam+',b');
end;

procedure TpSendMsg.SendErlaubnisMsg;
var
	richtingstr: string;
begin
	if not Erlaubnis^.r_veranderd then exit;
	Erlaubnis^.r_Veranderd := false;
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
	case Wissel^.defect of
	wdHeel:
		case Wissel^.stand of
		wsRechtdoor: SendPlainString('w:'+Wissel^.w_naam+',r');
		wsAftakkend: SendPlainString('w:'+Wissel^.w_naam+',a');
		wsOnbekend: SendPlainString('w:'+Wissel^.w_naam+',u')
		end;
	else
		SendPlainString('w:'+Wissel^.w_naam+',u')
	end;
end;

procedure TpSendMsg.SendSeinMsg;
begin
	if not Sein^.veranderd then exit;
	Sein^.Veranderd := false;
	if (sein^.bediend or sein^.autosein) then begin
		if Sein^.H_MovementAuthority.HasAuthority then
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

procedure TpSendMsg.SendTreinInfo;
var
	vertrstr: string;
	vertrtstr: string;
begin
	if not TreinInfo^.gewijzigd then exit;
	TreinInfo^.gewijzigd := false;
	str(TreinInfo^.Vertraging, vertrstr);
	case TreinInfo^.Vertragingtype of
	vtExact: vertrtstr := 'ex';
	vtSchatting: vertrtstr := 'st';
	else exit
	end;
	SendPlainString('ti:'+TreinInfo^.Treinnummer+','+vertrtstr+','+vertrstr+','+TreinInfo^.Vertragingplaats);
end;

procedure TpSendMsg.SendBel(van: PpTrein);
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := Van^.pos_rail^.meetpunt;
	if not assigned(Meetpunt) then exit;
	SendPlainString('comm_bel:t,'+Van^.Treinnummer);
end;

procedure TpSendMsg.SendBel(van: string);
begin
	SendPlainString('comm_bel:r');
end;

procedure TpSendMsg.SendOpnemen(van: PpTrein);
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := Van^.pos_rail^.meetpunt;
	if not assigned(Meetpunt) then exit;
	SendPlainString('comm_opn:t,'+Van^.Treinnummer);
end;

procedure TpSendMsg.SendOpnemen(van: string);
begin
	SendPlainString('comm_opn:r');
end;

procedure TpSendMsg.SendOphangen(van: PpTrein);
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := Van^.pos_rail^.meetpunt;
	if not assigned(Meetpunt) then exit;
	SendPlainString('comm_oph:t,'+Van^.Treinnummer);
end;

procedure TpSendMsg.SendOphangen(van: string);
begin
	SendPlainString('comm_oph:r');
end;

procedure TpSendMsg.SendMsg(Van: PpTrein; soort: TpMsgSoort; s: string);
var
	Meetpunt: PpMeetpunt;
begin
	Meetpunt := Van^.pos_rail^.meetpunt;
	if not assigned(Meetpunt) then exit;
	case soort of
	pmsStoptonend:	 	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',r,'+s);
	pmsSTSpassage:	 	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',sts,'+s);
	pmsKlaarmelding:	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',km,'+s);
	pmsVraagOK:		 	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',ok,'+s);
	pmsTreinOpdracht:	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',tact,'+s);
	pmsInfo:			  	SendPlainString('comm_msg:t,'+Van^.Treinnummer+',i,'+s);
	end;
end;

procedure TpSendMsg.SendMsg(van: string; soort: TpMsgSoort; s: string);
begin
	case soort of
	pmsMonteurOpdracht:	SendPlainString('comm_msg:r,mact,'+s);
	pmsVraagOK:		SendPlainString('comm_msg:r,ok,'+s);
	pmsInfo:			SendPlainString('comm_msg:r,i,'+s);
	end;
end;

end.
