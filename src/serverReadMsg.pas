unit serverReadMsg;

interface

uses lists, stwpCore, serverSendMsg, stwpSeinen, stwpMeetpunt,
	stwpRails, stwpTreinen, sysutils, stwpRijplan, stwpTijd, stwpOverwegen,
	stwsimComm;

const
	LF = #$0A;
	serverversie = '0.3';

type
	PpReadMsg = ^TpReadMsg;
	TpReadMsg = class
	private
		procedure SendTreinDienst(Planpunten: PpRijplanPunt; maxaantal: integer);
		function MaakRijplanpunt(s: string): PpRijplanPunt;
	public
		Core:	PpCore;
		SendMsg: PpSendMsg;
		procedure ReadMsg(msg: string);
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

procedure TpReadMsg.SendTreinDienst(Planpunten: PpRijplanPunt; maxaantal: integer);
var
	i: integer;
	Planpunt: PpRijplanPunt;
begin
	i := 1;
	Planpunt := Planpunten;
	while assigned(Planpunt) and (i <= maxaantal) do begin
		SendMsg.SendPlainString('smsg:'+RijpuntLijstStr(Planpunt, rlsStatus));
		inc(i);
		Planpunt := Planpunt^.Volgende;
	end;
end;

function TpReadMsg.MaakRijplanpunt;
var
	tmpPunt: PpRijplanPunt;
	p, code, index: integer;
	waarde: string;
	u, m: integer;
	us, ms: string;
begin
	new(tmpPunt);
	tmpPunt^.volgende := nil;
	tmpPunt^.spc_gedaan := false;
	tmpPunt^.minwachttijd := -1;
	index := 0;
	while s <> '' do begin
		p := pos(',',s);
		if p=0 then p := length(s)+1;
		waarde := copy(s, 1, p-1);
		s := copy(s, p+1, length(s)-p);
		case index of
			0: begin
				if waarde = '-' then
					tmppunt.Aankomst := -1
				else begin
					p := pos(':', waarde);
					us := copy(waarde,1,p-1);
					ms := copy(waarde, p+1, length(waarde)-p);
					val(us, u, code); if code <> 0 then begin dispose(tmpPunt); result := nil; exit;end;
					val(ms, m, code); if code <> 0 then begin dispose(tmpPunt); result := nil; exit;end;
					tmppunt.Aankomst := MkTijd(u, m, 0);
				end;
			end;
			1: begin
				if waarde = '-' then
					tmppunt.Vertrek := -1
				else begin
					p := pos(':', waarde);
					us := copy(waarde,1,p-1);
					ms := copy(waarde, p+1, length(waarde)-p);
					val(us, u, code); if code <> 0 then begin dispose(tmpPunt); result := nil; exit;end;
					val(ms, m, code); if code <> 0 then begin dispose(tmpPunt); result := nil; exit;end;
					tmppunt.Vertrek := MkTijd(u, m, 0);
				end;
			end;
			2: if waarde <> '-' then
					tmppunt.Station := waarde
				else
					tmpPunt.Station := '';
			3: if waarde <> '-' then
					tmppunt.Perron := waarde
				else
					tmpPunt.Perron := '';
			4: begin
				tmpPunt.stoppen := (waarde = 'j') or (waarde = 'J');
				tmpPunt^.minwachttijd := MkTijd(0,0,30);
			end;
			5: begin
				tmpPunt.samenvoegen := (waarde = 'j') or (waarde = 'J');
				tmpPunt^.minwachttijd := tmpPunt^.minwachttijd + MkTijd(0,1,0);
			end;
			6: begin
				tmpPunt.keren := (waarde = 'j') or (waarde = 'J');
				tmpPunt^.minwachttijd := tmpPunt^.minwachttijd + MkTijd(0,4,0);
			end;
			7: begin
				val(waarde, tmppunt.loskoppelen, code);
				if code <> 0 then begin
					dispose(tmpPunt); result := nil; exit;
				end;
				tmpPunt^.minwachttijd := tmpPunt^.minwachttijd + MkTijd(0,2,0);
			end;
			8: tmpPunt.loskoppelen_keren := (waarde = 'j') or (waarde = 'J');
			9: if waarde <> '-' then
					tmppunt.loskoppelen_w := waarde
				else
					tmpPunt.loskoppelen_w := '';
			10: if waarde <> '-' then begin
					tmppunt.nieuwetrein_w := waarde; tmppunt.nieuwetrein := true;
				end else begin
					tmpPunt.nieuwetrein_w := ''; tmppunt.nieuwetrein := false;
				end;
		else
			begin
				dispose(tmpPunt); result := nil; exit;
			end;
		end;
		inc(index);
	end; // while s <> ''
	result := tmpPunt;
end;

// Een client mag de server niet zomaar kunnen crashen
// ReadMsg moet daarom stabiel werken en alle mogelijke fouten netjes
// afhandelen.
procedure TpReadMsg.ReadMsg;
var
	p: integer;
	cmd: string;
	tail: string;
	// simversie
	// Claim
	wat: string;
	tmpWissel: PpWissel;
	tmpMeetpunt: PpMeetpunt;
	tmpSein:	PpSein;
	tmpErlaubnis: PpErlaubnis;
	tmpOverweg: PpOverweg;
	// Wissel & sein
	nummer, stand: string;
	// Meetpunt
	naam: string;
	// Erlaubnis
	standnr: byte;
	// Trein-msg
	tmpTrein: PpTrein;
	tcmd: string;
	nwn_nr, nwn_vanaf: string;
	rppunt:	PpRijplanPunt;
	v_rppunt:	PpRijplanPunt;
	rppunt_na: string;
	ok: boolean;
	statusstr: string;
	// Telefoonwachten
	tm, code: integer;
	// Broadcast-bericht
	RailLijst: PpRailLijst;
	Trein: PpTrein;
begin
	p := pos(':', msg);
	if p <> 0 then begin
		cmd := copy(msg,1,p-1);
		tail := copy(msg,p+1,length(msg)-p);
	end else begin
		cmd := msg;
		tail := '';
	end;
	if cmd = 'w' then begin
		SplitOff(tail, nummer, stand);
		tmpWissel := Core.ZoekWissel(nummer);
		if assigned(tmpWissel) then
			if stand = 'r' then begin
				if not tmpWissel^.stand_aftakkend then
					SendMsg.SendPlainString('ok:nothing to do')
				else
					if Core.ZetWissel(tmpWissel, false) then
						SendMsg.SendPlainString('ok:please wait')
					else
						SendMsg.SendPlainString('err:could not change switch')
			end else if stand = 'a' then begin
				if tmpWissel^.stand_aftakkend then
					SendMsg.SendPlainString('ok:nothing to do')
				else
					if Core.ZetWissel(tmpWissel, true) then
						SendMsg.SendPlainString('ok:please wait')
					else
						SendMsg.SendPlainString('err:could not change switch')
			end else
				SendMsg.SendPlainString('err:unknown direction')
		else
			SendMsg.SendPlainString('err:unknown switch');
	end else if cmd = 's' then begin
		SplitOff(tail, nummer, stand);
		tmpSein := Core.ZoekSein(nummer);
		if assigned(tmpSein) then
			if stand = 'g' then begin
				tmpSein^.Bediend_Stand := 1;
				SendMsg.SendPlainString('ok')
			end else if stand = 'gk' then begin
				tmpSein^.Bediend_Stand := 2;
				SendMsg.SendPlainString('ok')
			end else if stand = 'r' then begin
				tmpSein^.Bediend_Stand := 0;
				SendMsg.SendPlainString('ok')
			end else
				SendMsg.SendPlainString('err:unknown signal message')
		else
			SendMsg.SendPlainString('err:unknown signal');
	end else if cmd = 'm' then begin
		SplitOff(tail, nummer, naam);
		tmpMeetpunt := Core.ZoekMeetpunt(nummer);
		if assigned(tmpMeetpunt) then begin
			tmpMeetpunt^.Treinnaam := naam;
			tmpMeetpunt^.veranderd := true;
			SendMsg.SendPlainString('ok');
		end else
			SendMsg.SendPlainString('err:unknown detector');
	end else if cmd = 'e' then begin
		SplitOff(tail, nummer, tail);
		SplitOff(tail, wat, stand);
		tmpErlaubnis := Core.ZoekErlaubnis(nummer);
		if assigned(tmpErlaubnis) then begin
			val(stand, standnr, code);
			if (wat = 'c') then begin
				// We kunnen claimen als de rijrichting al goed staat,
				// of als hij vrij is en niet voorvergrendeld is.
				if	(tmpErlaubnis^.richting = standnr)
					or (Core.ErlaubnisVrij(tmpErlaubnis) and
					not tmpErlaubnis^.voorvergendeld) then begin
					// We gaan een rijrichting claimen. We stellen hem in en
					// vergrendelen deze.
					tmpErlaubnis^.veranderd := tmpErlaubnis^.richting <> standnr;
					tmpErlaubnis^.richting := standnr;
					tmpErlaubnis^.voorvergendeld := true;
					tmpErlaubnis^.vergrendeld := true;
					SendMsg.SendPlainString('ok');
				end else
					SendMsg.SendPlainString('err:direction can not be changed like this now.')
			end else if (wat = 'r') then begin
				if (tmpErlaubnis^.richting = standnr) then begin
					// We geven een reeds geclaimde rijrichting vrij. In ieder
					// geval heffen we de vergrendeling op.
					tmpErlaubnis^.voorvergendeld := false;
					// Is de rijrichting helemaal vrij, dan kan hij meteen worden
					// vrijgegeven.
					if Core.ErlaubnisVrij(tmpErlaubnis) then begin
						tmpErlaubnis^.richting := tmpErlaubnis^.standaardrichting;
						tmpErlaubnis^.vergrendeld := false;
						tmpErlaubnis^.veranderd := true;
					end;
					SendMsg.SendPlainString('ok');
				end else
					SendMsg.SendPlainString('err:direction can only be released by owner.')
			end else
				SendMsg.SendPlainString('err:unknown action for direction.')
		end else
			SendMsg.SendPlainString('err:unknown direction');
	end else if cmd = 'o' then begin
		SplitOff(tail, nummer, stand);
		tmpOverweg := Core.ZoekOverweg(nummer);
		if assigned(tmpOverweg) then
			if (stand = 'o') then begin
				if tmpOverweg^.Status in [2,3] then begin
					if tmpOverweg^.Status = 3 then
						tmpOverweg^.Veranderd := true;
					tmpOverweg^.Status := 4;
					with core^ do
						tmpOverweg^.VolgendeStatusTijd := GetTijd+ovOpenTijd;
					SendMsg.SendPlainString('ok')
				end else if tmpOverweg^.Status = 1 then begin
					tmpOverweg^.Status := 0;
					tmpOverweg^.VolgendeStatusTijd := -1;
					SendMsg.SendPlainString('ok')
				end else
					SendMsg.SendPlainString('ok:nothing to do')
			end else if (stand = 's') then begin
				if tmpOverweg^.Status = 0 then begin
					tmpOverweg^.Status := 1;
					with core^ do
						tmpOverweg^.VolgendeStatusTijd := GetTijd+ovAankTijd;
					SendMsg.SendPlainString('ok')
				end else if tmpOverweg^.Status = 4 then begin
					tmpOverweg^.Status := 2;
					with core^ do
						tmpOverweg^.VolgendeStatusTijd := GetTijd+ovSluitTijd;
					SendMsg.SendPlainString('ok')
				end else
					SendMsg.SendPlainString('ok:nothing to do')
			end else
				SendMsg.SendPlainString('err:unknown lc message')
		else
			SendMsg.SendPlainString('err:unknown lc');
	end else if cmd = 'mmsg' then begin
		SplitOff(tail, nummer, tail);
		tmpTrein := Core.ZoekTrein(nummer);
		if assigned(tmpTrein) then begin
			SplitOff(tail, tcmd, tail);
			if tcmd = 'rl' then begin	// Rijplan Laden
				SplitOff(tail, nwn_nr, nwn_vanaf);
				tmpTrein^.Treinnummer := nwn_nr;
				tmpTrein^.WisPlanpunten;
				tmpTrein^.Planpunten := Core^.CopyDienstFrom(nwn_nr, nwn_vanaf);
				if assigned(tmpTrein^.StationModusPlanpunt) then begin
					dispose(tmpTrein^.StationModusPlanpunt);
					tmpTrein^.StationModusPlanpunt := tmpTrein^.GetVolgendRijplanpunt;
				end;
				SendMsg.SendPlainString('ok');
			end else	if tcmd = 'tsr' then begin	// TreinStatus Rapporteren
				SendMsg.SendPlainString('ok');
				statusstr := 'smsg:TREIN '+nummer+' ('+
					inttostr(round(tmpTrein^.Snelheid))+' km/u';
				if tmpTrein^.huidigemaxsnelheid = 0 then
					statusstr := statusstr + ' - STS gepasseerd';
				if tmpTrein^.doorroodopdracht then
					statusstr := statusstr + ' - bezit lastgeving STS-passage';
				statusstr := statusstr + ')';
				if tmpTrein^.Vertraging = 0 then
					statusstr := statusstr + ' (op tijd)';
				if tmpTrein^.Vertraging >= 1 then
					statusstr := statusstr + ' (+'+inttostr(tmpTrein^.Vertraging)+')';
				if tmpTrein^.Vertraging <= -1 then
					statusstr := statusstr + ' ('+inttostr(tmpTrein^.Vertraging)+')';
				SendMsg.SendPlainString(statusstr);
				if tmpTrein^.modus = 2 then
					if assigned(tmpTrein^.Planpunten) then begin
						SendMsg.SendPlainString('smsg:'+rlsStatusHeading);
						SendMsg.SendPlainString('smsg:Op weg naar:');
						SendTreinDienst(tmpTrein^.Planpunten, 4);
					end else
						SendMsg.SendPlainString('smsg:Rijden zonder rijplan.');
				if tmpTrein^.modus = 1 then
					if assigned(tmpTrein^.StationModusPlanpunt) then begin
						SendMsg.SendPlainString('smsg:'+rlsStatusHeading);
						SendMsg.SendPlainString('smsg:'+RijpuntLijstStr(tmpTrein^.StationModusPlanpunt, rlsStatus));
						SendMsg.SendPlainString('smsg:Daarna verder naar:');
						SendTreinDienst(tmpTrein^.Planpunten, 3);
					end else
						SendMsg.SendPlainString('smsg:Stilstaan zonder rijplan.');
				if tmpTrein^.modus = 0 then
					SendMsg.SendPlainString('smsg:Trein is gecrasht');
				SendMsg.SendPlainString('smsg:--');
			end else if tcmd = 'stsp' then begin	// StopTonend Sein Passeren
				tmpTrein^.doorroodopdracht := true;
				SendMsg.SendPlainString('ok');
			end else if tcmd = 'stspa' then begin	// STSP-opdracht Annuleren
				tmpTrein^.doorroodopdracht := false;
				SendMsg.SendPlainString('ok');
			end else if tcmd = 'vnstsp' then begin	// Verderrijden Na STS-Passage
				tmpTrein^.doorroodverderrijden := true;
				SendMsg.SendPlainString('ok');
			end else if tcmd = 'ra' then begin		// Rijplanpunt Annuleren
				v_rppunt := nil;
				if tail <> '' then begin
					rppunt := tmpTrein^.Planpunten;
					while assigned(rppunt) do begin
						if rppunt^.Station = tail then break;
						v_rppunt := rppunt;
						rppunt := rppunt^.volgende;
					end;
				end else
					rppunt := tmpTrein^.Planpunten;
				if assigned(rppunt) then begin
					if assigned(v_rppunt) then
						v_rppunt^.volgende := rppunt^.volgende
					else
						tmpTrein^.Planpunten := rppunt^.volgende;
					SendMsg.SendPlainString('ok');
				end else
					SendMsg.SendPlainString('err:station not on plan');
			end else if tcmd = 'nr' then begin		// Nieuw Rijplanpunt
				ok := true;
				SplitOff(tail, rppunt_na, tail);
				if rppunt_na = '-' then
					v_rppunt := nil
				else begin
					v_rppunt := tmpTrein^.Planpunten;
					while assigned(v_rppunt) do begin
						if v_rppunt.Station = rppunt_na then break;
						v_rppunt := v_rppunt^.Volgende;
					end;
					if not assigned(v_rppunt) then ok := false;
				end;
				if ok then begin
					rppunt := MaakRijplanpunt(tail);
					if assigned(rppunt) then begin
						if not assigned(v_rppunt) then begin
							rppunt^.Volgende := tmpTrein^.Planpunten;
							tmpTrein^.Planpunten := rppunt;
						end else begin
							rppunt^.volgende := v_rppunt^.volgende;
							v_rppunt^.volgende := rppunt;
						end;
						SendMsg.SendPlainString('ok');
					end else
						SendMsg.SendPlainString('err:incorrect plan entry');
				end else
					SendMsg.SendPlainString('err:given after-station does not exist');
			end else if tcmd = 'wtt' then begin		// WachT met Telefoneren
				val(tail,tm,code);
				if code = 0 then
					tmpTrein^.berichtwachttijd := GetTijd + MkTijd(0,tm,0)
				else
					SendMsg.SendPlainString('err:wrong number of minutes');
			end else
				SendMsg.SendPlainString('err:unknown train command');
		end else
			SendMsg.SendPlainString('err:unknown train');
	end else if cmd = 'bc' then begin
		SendMsg.SendPlainString('ok');
		tmpMeetpunt := Core^.pAlleMeetpunten;
		while assigned(tmpMeetpunt) do begin
			RailLijst := tmpMeetpunt^.ZichtbaarLijst;
			while assigned(RailLijst) do begin
				Trein := Core^.pAlleTreinen;
				while assigned(Trein) do begin
					if Trein^.pos_rail = RailLijst^.Rail then
						SendMsg.SendPlainString('mmsg:'+Trein^.Treinnummer+
							',Meldt!');
					Trein := Trein^.Volgende;
				end;
				RailLijst := RailLijst^.Volgende;
			end;
			tmpMeetpunt := tmpMeetpunt^.Volgende;
		end;
	end else if cmd = 'score' then begin
		SendMsg.SendPlainString('score:start');
		SendMsg.SendPlainString('score:punct0,'+inttostr(Core.ScoreInfo.AankomstOpTijd));
		SendMsg.SendPlainString('score:punct3,'+inttostr(Core.ScoreInfo.AankomstBinnenDrie));
		SendMsg.SendPlainString('score:punctn,'+inttostr(Core.ScoreInfo.AankomstTeLaat));
		SendMsg.SendPlainString('score:delayad,'+inttostr(Core.ScoreInfo.VertragingVeroorzaakt));
		SendMsg.SendPlainString('score:delayrm,'+inttostr(Core.ScoreInfo.VertragingVerminderd));
		SendMsg.SendPlainString('score:platfj,'+inttostr(Core.ScoreInfo.PerronCorrect));
		SendMsg.SendPlainString('score:platfn,'+inttostr(Core.ScoreInfo.PerronFout));
		SendMsg.SendPlainString('score:done');
	end else
		SendMsg.SendPlainString('err:unknown command');
end;

end.
