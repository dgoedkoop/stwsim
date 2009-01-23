unit clientSendMsg;

interface

uses stwvSporen, stwvMeetpunt, stwvSeinen, stwsimComm;

type
	// Soort:
	// 0=niks
	// 1=niet zeer functionele string
	// 2=wissel-zetten
	// 3=meetpunt
	// 4=erlaubnis
	// 5=sein
	// 6=broadcast
	// 7=overweg
	// 8=score
	PvSentMsg = ^TvSentMsg;
	TvSentMsg = record
		soort: byte;
		data:	pointer;
		vorige, volgende: PvSentMsg;
	end;

	RichtingWat = (rwClaim, rwRelease);

	TvSendMsg = class
	private
		function NewSent: PvSentMsg;
	public
		FirstSent, LastSent: PvSentMsg;
		// Dit MOET ingesteld worden:
		SimComm:	TStringComm;
		procedure SendString(s: string);
		procedure SendWisselChg(Wissel: PvWissel);
		procedure SendWissel(Wissel: PvWissel; Stand: TWisselStand);
		procedure SendSetSein(Sein: PvSein; stand: string);
		procedure SendSetOverweg(Overweg: PvOverweg; gesloten: boolean);
		procedure SendSetTreinnr(Meetpunt: PvMeetpunt; treinnr: string);
		procedure SendTreinMsg(treinnr: string; bericht: string);
		procedure SendRichting(Erlaubnis: PvErlaubnis; richting: byte; hoe: RichtingWat);
		procedure SendBroadcast;
		procedure SendGetScore;
		procedure GetFirst(var soort: byte; var data:pointer);
		procedure DropOne;
	end;

implementation

function TvSendMsg.NewSent;
var
	tmpSent: PvSentMsg;
begin
	new(tmpSent);
	tmpSent^.soort := 1;
	tmpSent^.data := nil;
	tmpSent^.Volgende := nil;
	if not assigned(firstSent) then
		firstSent := tmpSent;
	if not assigned(lastSent) then begin
		tmpSent^.Vorige := nil;
		lastSent := tmpSent;
	end else begin
		lastSent^.Volgende := tmpSent;
		tmpSent^.Vorige := lastSent;
		lastSent := tmpSent;
	end;
	result := tmpSent;
end;

procedure TvSendMsg.SendString;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 1;
	tmpSent^.data := nil;
	SimComm.SendStringToServer(s);
end;

procedure TvSendMsg.SendWisselChg;
begin
	if Wissel^.Stand = wsRechtdoor then
		SendWissel(Wissel, wsAftakkend)
	else
		SendWissel(Wissel, wsRechtdoor);
end;

procedure TvSendMsg.SendWissel;
var
	tmpSent: PvSentMsg;
	basisstand: boolean;
	tmpWissel: PvWissel;
begin
	if Wissel^.Groep^.OnbekendAanwezig then exit;			// Wordt al goedgezet.
	// Als we niks hoeven te doen, hoeven we niks te doen.
	if Wissel^.Stand = Stand then exit;	// Staat al goed.
	// En DOEN! We zetten de hele wisselgroep om.
	basisstand := ((Stand = wsRechtdoor) = Wissel^.BasisstandRecht);
	tmpWissel := Wissel^.Groep^.EersteWissel;
	while assigned(tmpWissel) do begin
		tmpSent := NewSent;
		tmpSent^.soort := 2;
		tmpSent^.data := Wissel;
		if tmpWissel^.BasisstandRecht = basisstand then
			tmpWissel^.WensStand := wsRechtdoor
		else
			tmpWissel^.WensStand := wsAftakkend;
		if tmpWissel^.Stand <> tmpWissel^.WensStand then begin
			if tmpWissel^.WensStand = wsRechtdoor then
				SimComm.SendStringToServer('w:'+tmpWissel^.WisselID+',r')
			else
				SimComm.SendStringToServer('w:'+tmpWissel^.WisselID+',a');
		end;
		tmpWissel := tmpWissel^.Volgende;
	end;
end;

procedure TvSendMsg.SendSetSein;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 5;
	tmpSent^.data := Sein;
	Sein^.Stand_wens := stand;
	SimComm.SendStringToServer('s:'+Sein^.Naam+','+Sein^.Stand_wens)
end;

procedure TvSendMsg.SendSetOverweg;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 7;
	tmpSent^.data := Overweg;
	Overweg^.Gesloten_Wens := Gesloten;
	if Gesloten then
		SimComm.SendStringToServer('o:'+Overweg^.Naam+',s')
	else
		SimComm.SendStringToServer('o:'+Overweg^.Naam+',o');
end;

procedure TvSendMsg.SendRichting;
var
	tmpSent: PvSentMsg;
	richtingstr: string;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 4;
	tmpSent^.data := Erlaubnis;
	str(richting, richtingstr);
	if (hoe = rwClaim) then
		SimComm.SendStringToServer('e:'+Erlaubnis^.erlaubnisID+',c,'+richtingstr)
	else if (hoe = rwRelease) then
		SimComm.SendStringToServer('e:'+Erlaubnis^.erlaubnisID+',r,'+richtingstr)
end;

procedure TvSendMsg.SendSetTreinnr;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 3;
	tmpSent^.data := Meetpunt;
	SimComm.SendStringToServer('m:'+Meetpunt^.meetpuntID+','+treinnr)
end;

procedure TvSendMsg.SendTreinMsg;
var
	tmpSent: PvSentMsg;
begin
	if treinnr = '' then exit;
	tmpSent := NewSent;
	tmpSent^.soort := 1;
	tmpSent^.data := nil;
	SimComm.SendStringToServer('mmsg:'+Treinnr+','+bericht);
end;

procedure TvSendMsg.SendBroadcast;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 6;
	tmpSent^.data := nil;
	SimComm.SendStringToServer('bc');
end;

procedure TvSendMsg.SendGetScore;
var
	tmpSent: PvSentMsg;
begin
	tmpSent := NewSent;
	tmpSent^.soort := 8;
	tmpSent^.data := nil;
	SimComm.SendStringToServer('score');
end;

procedure TvSendMsg.GetFirst;
begin
	soort := 0;
	data := nil;
	if assigned(FirstSent) then begin
		soort := FirstSent.soort;
		data := FirstSent.data;
	end;
end;

procedure TvSendMsg.DropOne;
var
	tmpSent: PvSentMsg;
begin
	if assigned(FirstSent) then begin
		tmpSent := FirstSent;
		FirstSent := FirstSent^.Volgende;
		if not assigned(FirstSent) then
			LastSent := nil;
		dispose(tmpSent);
	end;
end;

end.
