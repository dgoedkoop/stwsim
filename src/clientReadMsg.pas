unit clientReadMsg;

interface

uses lists, stwvCore, clientSendMsg, stwvMeetpunt, stwvSeinen,
	stwvSporen, stwvScore, stwvTreinComm;

const
	LF = #$0A;
	clientversie = '0.3';

type
	TSeinbeeld = (sbGroen, sbGeel, sbRood);

	TConfirmEvent = procedure(cmdsoort: byte; cmddata: pointer; okmsg: string) of object;
	TChangeWisselEvent = procedure(Wissel: PvWissel) of object;
	TChangeSeinEvent = procedure(Sein: PvSein) of object;
	TChangeMeetpuntEvent = procedure(Meetpunt: PvMeetpunt; Oudebezet: boolean; Oudetreinnr: string) of object;
	TChangeRichtingEvent = procedure(Erlaubnis: PvErlaubnis) of object;
	TChangeOverwegEvent = procedure(Overweg: PvOverweg) of object;
	TsmsgEvent = procedure(tekst: string) of object;

	TTelefoonBelEvent = procedure(van: TvMessageWie) of object;
	TTelefoonOpneemEvent = procedure(van: TvMessageWie) of object;
	TTelefoonMsgEvent = procedure(van: TvMessageWie; soort: TvMessageSoort; tekst: string) of object;
	TTelefoonOphangEvent = procedure(van: TvMessageWie) of object;

	TTijdEvent = procedure(u,m,s: integer) of object;
	TScoreEvent = procedure of object;
	TDefectSeinEvent = procedure(Sein: PvSein; defectSeinbeeld: TSeinbeeld) of object;

	PvReadMsg = ^TvReadMsg;
	TvReadMsg = class
	private
		ClaimsSent: boolean;
	public
		// De volgende variabelen MOETEN juist geïnitialiseerd worden:
		Core:	PvCore;
		SendMsg: TvSendMsg;
		// De volgende events zijn voor de gebruiker:
		ConfirmEvent: TConfirmEvent;
		ChangeWisselEvent: TChangeWisselEvent;
		ChangeSeinEvent: TChangeSeinEvent;
		ChangeMeetpuntEvent: TChangeMeetpuntEvent;
		ChangeRichtingEvent: TChangeRichtingEvent;
		ChangeOverwegEvent: TChangeOverwegEvent;
		smsgEvent: TsmsgEvent;
		TelefoonBelEvent: TTelefoonBelEvent;
		TelefoonOpneemEvent: TTelefoonOpneemEvent;
		TelefoonMsgEvent: TTelefoonMsgEvent;
		TelefoonOphangEvent: TTelefoonOphangEvent;
		TijdEvent: TTijdEvent;
		ScoreEvent: TScoreEvent;
		DefectSeinEvent: TDefectSeinEvent;
		procedure ReadMsg(msg: string);
		constructor Create;
	end;

procedure SplitOff(s: string; var first,rest: string);

implementation

procedure SplitOff;
var
	p: integer;
begin
	p := pos(',',s);
	if p=0 then begin
		first := s;
		rest := '';
	end else begin
		first := copy(s,1,p-1);
		rest := copy(s,p+1,length(s)-p);
	end;
end;

constructor TvReadMsg.Create;
begin
	inherited;
	ChangeWisselEvent := nil;
	ChangeSeinEvent := nil;
	ChangeMeetpuntEvent := nil;
	smsgEvent := nil;
	TelefoonBelEvent := nil;
	TelefoonOpneemEvent := nil;
	TelefoonMsgEvent := nil;
	TelefoonOphangEvent := nil;
	TijdEvent := nil;
	ClaimsSent := false;
	ScoreEvent := nil;
	DefectSeinEvent := nil;
end;

procedure TvReadMsg.ReadMsg;
var
	p: integer;
	cmd: string;
	tail: string;
	// Voor het claimen.
	Sein: PvSein;
	Wissel: PvWissel;
	Meetpunt: PvMeetpunt;
	Erlaubnis: PvErlaubnis;
	Overweg: PvOverweg;
	oudebezet: boolean;
	oudetreinnr: string;
	// Voor terugmelding
	ID, waarde, waarde2: string;
	// Voor telefoon
	Metwie: TvMessageWie;
	// Voor mmsg
	soortstr, tekst: string;
	// Voor defecten
	DefectWat, DefectID, DefectRest: string;
	// Voor t
	us,ms,ss: string;
	u,m,s, code: integer;
	// Voor erlaubnis
	stand, vergrendeld: string;
begin
	p := pos(':', msg);
	if p <> 0 then begin
		cmd := copy(msg,1,p-1);
		tail := copy(msg,p+1,length(msg)-p);
	end else begin
		cmd := msg;
		tail := '';
	end;
	if cmd = 'err' then
		SendMsg.SetReturned(false, tail)
	else if cmd = 'ok' then
		SendMsg.SetReturned(true, tail)
	else if cmd = 'pause' then begin
		if tail='n' then Core^.pauze := false;
		if tail='j' then Core^.pauze := true;
	end else if cmd = 'w' then begin
		SplitOff(tail, ID, waarde);
		Wissel := EersteWissel(Core);
		while assigned(Wissel) do begin
			if Wissel^.WisselID = ID then break;
			Wissel := VolgendeWissel(Wissel);
		end;
		if assigned(Wissel) then begin
			if waarde = 'r' then Wissel^.Stand := wsRechtdoor;
			if waarde = 'a' then Wissel^.Stand := wsAftakkend;
			if waarde = 'u' then Wissel^.Stand := wsOnbekend;
			Wissel^.changed := true;
			if assigned(ChangeWisselEvent) then
				ChangeWisselEvent(Wissel);
		end;
	end else if cmd = 'm' then begin
		SplitOff(tail, ID, tail);
		SplitOff(tail, waarde, waarde2);
		Meetpunt := Core^.vAlleMeetpunten;
		while assigned(Meetpunt) do begin
			if Meetpunt^.meetpuntID = ID then break;
			Meetpunt := Meetpunt^.Volgende;
		end;
		if assigned(Meetpunt) then begin
			oudebezet := Meetpunt^.bezet;
			oudetreinnr := Meetpunt^.treinnummer;
			Meetpunt^.bezet := waarde = 'b';
			Meetpunt^.treinnummer := waarde2;
			Meetpunt^.changed := true;
			if assigned(ChangeMeetpuntEvent) then
				ChangeMeetpuntEvent(Meetpunt, Oudebezet, Oudetreinnr);
		end;
	end else if cmd = 's' then begin
		SplitOff(tail, ID, waarde);
		Sein := Core^.vAlleSeinen;
		while assigned(Sein) do begin
			if Sein^.Naam = ID then break;
			Sein := Sein^.Volgende;
		end;
		if assigned(Sein) then begin
			Sein^.Stand := waarde;
			Sein^.changed := true;
			if assigned(ChangeSeinEvent) then
				ChangeSeinEvent(Sein);
		end;
	end else if cmd = 'e' then begin
		SplitOff(tail, ID, tail);
		SplitOff(tail, stand, vergrendeld);
		Erlaubnis := Core^.vAlleErlaubnisse;
		while assigned(Erlaubnis) do begin
			if Erlaubnis^.erlaubnisID = ID then break;
			Erlaubnis := Erlaubnis^.Volgende;
		end;
		if assigned(Erlaubnis) then begin
			val(stand, Erlaubnis^.richting, code);
			Erlaubnis^.vergrendeld := vergrendeld = 'j';
			Erlaubnis^.changed := true;
			if assigned(ChangeRichtingEvent) then
				ChangeRichtingEvent(Erlaubnis);
		end;
	end else if cmd = 'o' then begin
		SplitOff(tail, ID, waarde);
		Overweg := ZoekOverweg(Core, ID);
		if assigned(Overweg) then begin
			if waarde = 'o' then
				Overweg^.Gesloten := false
			else if waarde = 's' then
				Overweg^.Gesloten := true;
			Overweg^.changed := true;
			if assigned(ChangeOverwegEvent) then
				ChangeOverwegEvent(Overweg);
		end;
	end else if cmd = 'smsg' then begin
		if assigned(smsgEvent) then
			smsgEvent(tail);
	end else if cmd = 'comm_bel' then begin
		SplitOff(tail, Metwie.wat, Metwie.ID);
		if assigned(TelefoonBelEvent) then
			TelefoonBelEvent(Metwie);
	end else if cmd = 'comm_opn' then begin
		SplitOff(tail, Metwie.wat, Metwie.ID);
		if assigned(TelefoonOpneemEvent) then
			TelefoonOpneemEvent(Metwie);
	end else if cmd = 'comm_msg' then begin
		SplitOff(tail, Metwie.wat, tail);
		if Metwie.wat = 't' then
			SplitOff(tail, Metwie.ID, tail);
		SplitOff(tail, soortstr, tekst);
		if assigned(TelefoonMsgEvent) then begin
			if soortstr = 'r' then TelefoonMsgEvent(Metwie, vmsTreinStoptonend, tekst);
			if soortstr = 'sts' then TelefoonMsgEvent(Metwie, vmsTreinSTSpassage, tekst);
			if soortstr = 'ok' then TelefoonMsgEvent(Metwie, vmsVraagOK, tekst);
			if soortstr = 'tact' then TelefoonMsgEvent(Metwie, vmsTreinOpdracht, tekst);
			if soortstr = 'mact' then TelefoonMsgEvent(Metwie, vmsMonteurOpdracht, tekst);
			if soortstr = 'i' then TelefoonMsgEvent(Metwie, vmsInfo, tekst);
		end
	end else if cmd = 'comm_oph' then begin
		SplitOff(tail, Metwie.wat, Metwie.ID);
		if assigned(TelefoonOphangEvent) then
			TelefoonOphangEvent(Metwie);
	end else if cmd = 'score' then begin
		SplitOff(tail, ID, waarde);
		if ID = 'punct0' then val(waarde, Core.vScore.AankomstOpTijd, code);
		if ID = 'punct3' then val(waarde, Core.vScore.AankomstBinnenDrie, code);
		if ID = 'punctn' then val(waarde, Core.vScore.AankomstTeLaat, code);
		if ID = 'delayad' then val(waarde, Core.vScore.VertragingVeroorzaakt, code);
		if ID = 'delayrm' then val(waarde, Core.vScore.VertragingVerminderd, code);
		if ID = 'platfj' then val(waarde, Core.vScore.PerronCorrect, code);
		if ID = 'platfn' then val(waarde, Core.vScore.PerronFout, code);
		if ID = 'done' then
			if assigned(ScoreEvent) then ScoreEvent;
	end else if cmd = 'defect' then begin
		SplitOff(tail, DefectWat, tail);
		if DefectWat = 's' then begin
			SplitOff(tail, DefectID, DefectRest);
			Sein := ZoekSein(Core, DefectID);
			if assigned(Sein) and assigned(DefectSeinEvent) then begin
				if DefectRest = 'g' then
					DefectSeinEvent(Sein, sbGroen);
				if DefectRest = 'gl' then
					DefectSeinEvent(Sein, sbGeel);
			end;
		end;
	end else if cmd = 't' then begin
		SplitOff(tail, us, tail);
		SplitOff(tail, ms, ss);
		val(us,u,code);
		val(ms,m,code);
		val(ss,s,code);
		if assigned(TijdEvent) then
			TijdEvent(u,m,s);
	end;
end;

end.
