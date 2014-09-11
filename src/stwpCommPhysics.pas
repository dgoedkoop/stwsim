unit stwpCommPhysics;

interface

uses serverSendMsg, stwpTreinen, stwpDatatypes, stwpTelefoongesprek, stwpCore,
	stwpTijd;

type
	PpCommPhysics = ^TpCommPhysics;
	TpCommPhysics = class
	private
		pSendMsg: PpSendMsg;
		Core: PpCore;
		// Functies
		procedure NeemTelefoonOp(Gesprek: PpTelefoongesprek; Owner: TSender);
		procedure SendMsg(Gesprek: PpTelefoongesprek; Owner: TSender; soort: TpMsgSoort; Msg: string);
		procedure BelTreindienstleider(Gesprek: PpTelefoongesprek; Owner: TSender);
		procedure VoerStapjeUit(Gesprek: PpTelefoongesprek);
		procedure HangOp(Gesprek: PpTelefoongesprek; Owner: TSender);
	public
		constructor Create(Core: PpCore; SendMsg: PpSendMsg);
		// Events
		procedure CheckWacht(Gesprek: PpTelefoongesprek);
		procedure TrdlNeemtOp(Gesprek: PpTelefoongesprek);
		procedure TrdlHangtOp(Gesprek: PpTelefoongesprek);
		procedure ProbleemOpgelost(Gesprek: PpTelefoongesprek);
		procedure AntwoordGegeven(Gesprek: PpTelefoongesprek);
		// Simulatie
		procedure DoeGesprekken;
	end;

implementation

const
	mintijd_opnieuwbellen	= 5/60;
	maxtijd_opnieuwbellen	= 8/60;
	mintijd_zegx				= 1/60;
	maxtijd_zegx				= 4/60;
	mintijd_zegok				= 1/60;
	maxtijd_zegok				= 10/60;

constructor TpCommPhysics.Create;
begin
	self.Core := Core;
	self.pSendMsg := SendMsg;
end;

procedure TpCommPhysics.DoeGesprekken;
var
	Gesprek: PpTelefoongesprek;
begin
	Gesprek := Core.pAlleGesprekken;
	while assigned(Gesprek) do begin
		CheckWacht(Gesprek);
		Gesprek := Gesprek^.Volgende;
	end;

	Core^.RuimAfgelopenTelefoongesprekkenOp;
end;

procedure TpCommPhysics.NeemTelefoonOp;
begin
	if assigned(Owner) and (Owner^ is TpTrein) then
		pSendMsg.SendOpnemen(PpTrein(Owner))
	else
		pSendMsg.SendOpnemen('');
end;

procedure TpCommPhysics.HangOp;
begin
	if assigned(Owner) and (Owner^ is TpTrein) then
		pSendMsg.SendOphangen(PpTrein(Owner))
	else
		pSendMsg.SendOphangen('');
end;

procedure TpCommPhysics.SendMsg;
begin
	if assigned(Owner) and (Owner^ is TpTrein) then
		pSendMsg.SendMsg(PpTrein(Owner), soort, Msg)
	else
		pSendMsg.SendMsg('', soort, Msg);
end;

procedure TpCommPhysics.BelTreindienstleider;
begin
	if assigned(Owner) and (Owner^ is TpTrein) then
		pSendMsg.SendBel(PpTrein(Owner))
	else
		pSendMsg.SendBel('');
end;

procedure TpCommPhysics.AntwoordGegeven;
begin
	Gesprek^.VolgendeStatusTijd := RandomWachtTijd(mintijd_zegok, maxtijd_zegok);
	Gesprek^.Status := tgsG4;
end;

procedure TpCommPhysics.ProbleemOpgelost;
begin
	if Gesprek^.Status in [tgsSS, tgsSS2] then
		Gesprek^.Status := tgsE
	else
		// Niet ophangen als we nog even netjes het laatste stukje van het gesprek
		// moeten afmaken.
		if not (Gesprek^.Status in [tgsG4,tgsG5]) then
			Gesprek^.Status := tgsH;

	VoerStapjeUit(Gesprek);
end;

procedure TpCommPhysics.TrdlNeemtOp;
begin
	if Gesprek^.Status = tgsSS3 then begin
		Gesprek^.VolgendeStatusTijd := RandomWachtTijd(mintijd_zegx, maxtijd_zegx);
		Gesprek^.Status := tgsG1;
	end;

	VoerStapjeUit(Gesprek);
end;

procedure TpCommPhysics.TrdlHangtOp;
begin
	case Gesprek^.Status of
	tgsSS3,tgsG1, tgsG2, tgsWachtOpAntwoord:
		if Gesprek^.OphangenErg then begin
			Gesprek^.VolgendeStatusTijd := RandomWachtTijd(mintijd_opnieuwbellen, maxtijd_opnieuwbellen);
			Gesprek^.Status := tgsSS
		end else
			Gesprek^.Status := tgsE;
	tgsSB, tgsSB2,tgsG4: Gesprek^.Status := tgsE;
	end;

	VoerStapjeUit(Gesprek);
end;

procedure TpCommPhysics.VoerStapjeUit;
begin
	case Gesprek^.Status of
	tgsSS2: begin
		BelTreindienstleider(Gesprek, Gesprek^.Owner);
		Gesprek^.Status := tgsSS3;
	end;
	tgsSB2: begin
		NeemTelefoonOp(Gesprek, Gesprek^.Owner);
		Gesprek^.VolgendeStatusTijd := RandomWachtTijd(mintijd_zegx, maxtijd_zegx);
		Gesprek^.Status := tgsG1;
	end;
	tgsG2:  begin
		SendMsg(Gesprek, Gesprek^.Owner, Gesprek^.tekstXsoort, Gesprek^.tekstX);
		Gesprek^.Status := tgsWachtOpAntwoord;
	end;
	tgsG5: begin
		if (Gesprek^.tekstXsoort <> pmsVraagOK) and
      	(Gesprek^.tekstXsoort <> pmsKlaarmelding) then
			SendMsg(Gesprek, Gesprek^.Owner, pmsInfo, Gesprek^.tekstOK);
		HangOp(Gesprek, Gesprek^.Owner);
		if Gesprek^.WachtOpdracht then begin
			Gesprek^.Status := tgsSS;
			Gesprek^.VolgendeStatusTijd := Gesprek^.WachtMetBellen;
			Gesprek^.WachtOpdracht := false
		end else
			Gesprek^.Status := tgsE;
	end;
	tgsH: begin
		HangOp(Gesprek, Gesprek^.Owner);
		Gesprek^.Status := tgsE;
	end;
	end;
end;

procedure TpCommPhysics.CheckWacht;
begin
	if not (Gesprek^.Status in [tgsSS, tgsSB, tgsG1, tgsG4, tgsAbort]) then exit;
	if not TijdVerstreken(Gesprek^.VolgendeStatusTijd) then exit;

	case Gesprek^.Status of
	tgsSS: Gesprek^.Status := tgsSS2;
	tgsSB: Gesprek^.Status := tgsSB2;
	tgsG1: Gesprek^.Status := tgsG2;
	tgsG4: Gesprek^.Status := tgsG5;
	tgsAbort: Gesprek^.Status := tgsH;
	end;

	VoerStapjeUit(Gesprek);
end;

end.
