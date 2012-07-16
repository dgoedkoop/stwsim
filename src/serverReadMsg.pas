unit serverReadMsg;

interface

uses lists, stwpCore, serverSendMsg, stwpSeinen, stwpMeetpunt,
	stwpRails, stwpTreinen, sysutils, stwpRijplan, stwpTijd, stwpOverwegen,
	stwsimComm, stwpDatatypes, stwpTelefoongesprek, stwpMonteur,
	stwpMonteurPhysics, stwpCommPhysics, stwpTreinInfo;

const
	LF = #$0A;
	serverversie = '0.3';
	unknowntrainerror = 'unknown train';

type
	PpReadMsg = ^TpReadMsg;
	TpReadMsg = class
	private
		procedure SendTreinDienst(Planpunten: PpRijplanPunt; maxaantal: integer);
		function MaakRijplanpunt(s: string): PpRijplanPunt;
		procedure SendOK;
		procedure SendError(msg: string);
	public
		Core:	PpCore;
		MonteurPhysics: PpMonteurPhysics;
		CommPhysics: PpCommPhysics;
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

procedure TpReadMsg.SendOK;
begin
	SendMsg.SendPlainString('ok');
end;

procedure TpReadMsg.SendError;
begin
	SendMsg.SendPlainString('err:'+msg);
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
	// Gesprek
	Gesprek: PpTelefoongesprek;
	// Trein-msg
	tcmd: string;
	nwn_nr, nwn_vanaf: string;
	rppunt:	PpRijplanPunt;
	v_rppunt:	PpRijplanPunt;
	rppunt_na: string;
	ok: boolean;
	statusstr: string;
	// Monteur
	Opdracht: TpMonteurOpdracht;
	// Telefoonwachten
	tm, code: integer;
	// Broadcast-bericht
	RailLijst: PpRailLijst;
	Trein: PpTrein;
	// Treininfo
	vertrsoort: string;
	minuten: integer;
	TreinInfo: PpTreinInfo;
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
				if Core.ZetWissel(tmpWissel, wsRechtdoor) then
					SendOK
				else
					SendError('could not change point')
			end else if stand = 'a' then begin
				if Core.ZetWissel(tmpWissel, wsAftakkend) then
					SendOK
				else
					SendError('could not change point')
			end else
				SendError('unknown direction')
		else
			SendError('unknown point');
	end else if cmd = 's' then begin
		SplitOff(tail, nummer, stand);
		tmpSein := Core.ZoekSein(nummer);
		if assigned(tmpSein) then
			if stand = 'g' then begin
				tmpSein^.Bediend_Stand := 1;
				SendOK
			end else if stand = 'gk' then begin
				tmpSein^.Bediend_Stand := 2;
				SendOK
			end else if stand = 'r' then begin
				tmpSein^.Bediend_Stand := 0;
				SendOK
			end else
				SendError('unknown signal message')
		else
			SendError('unknown signal');
	end else if cmd = 'm' then begin
		SplitOff(tail, nummer, naam);
		tmpMeetpunt := Core.ZoekMeetpunt(nummer);
		if assigned(tmpMeetpunt) then begin
			tmpMeetpunt^.Treinnaam := naam;
			tmpMeetpunt^.veranderd := true;
			SendOK;
		end else
			SendError('unknown detector');
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
					Core.StelErlaubnisIn(tmpErlaubnis, standnr);
					tmpErlaubnis^.voorvergendeld := true;
					SendOK
				end else
					SendError('direction can not be changed like this now.')
			end else if (wat = 'r') then begin
				if (tmpErlaubnis^.richting = standnr) then begin
					Core.GeefErlaubnisVrij(tmpErlaubnis);
					SendOK
				end else
					SendError('direction can only be released by owner.')
			end else
				SendError('unknown action for direction.')
		end else
			SendError('unknown direction');
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
					SendOK
				end else if tmpOverweg^.Status = 1 then begin
					tmpOverweg^.Status := 0;
					tmpOverweg^.VolgendeStatusTijd := -1;
					SendOK
				end else
					SendOK
			end else if (stand = 's') then begin
				if tmpOverweg^.Status = 0 then begin
					tmpOverweg^.Status := 1;
					with core^ do
						tmpOverweg^.VolgendeStatusTijd := GetTijd+ovAankTijd;
					SendOK
				end else if tmpOverweg^.Status = 4 then begin
					tmpOverweg^.Status := 2;
					with core^ do
						tmpOverweg^.VolgendeStatusTijd := GetTijd+ovSluitTijd;
					SendOK
				end else
					SendOK
			end else
				SendError('unknown level crossing message')
		else
			SendError('unknown level crossing');
	end else	if cmd = 'tsr' then begin	// TreinStatus Rapporteren
		nummer := tail;
		Trein := Core.ZoekTrein(nummer);
		if assigned(Trein) then begin
			SendOK;
			statusstr := 'smsg:TREIN '+Trein^.Treinnummer+' ('+
				inttostr(round(Trein^.Snelheid))+' km/u';
			if Trein^.huidigemaxsnelheid = 0 then
				statusstr := statusstr + ' - STS gepasseerd';
			if Trein^.doorroodopdracht then
				statusstr := statusstr + ' - bezit aanwijzing STS-passage voor sein '+Trein^.doorroodopd_sein^.naam;
			statusstr := statusstr + ')';
			if Trein^.Vertraging = 0 then
				statusstr := statusstr + ' (op tijd)';
			if Trein^.Vertraging >= 1 then
				statusstr := statusstr + ' (+'+inttostr(Trein^.Vertraging)+')';
			if Trein^.Vertraging <= -1 then
				statusstr := statusstr + ' ('+inttostr(Trein^.Vertraging)+')';
			SendMsg.SendPlainString(statusstr);
			case Trein^.Modus of
			tmRijden:
				if assigned(Trein^.Planpunten) then begin
					SendMsg.SendPlainString('smsg:'+rlsStatusHeading);
					SendMsg.SendPlainString('smsg:Op weg naar:');
					SendTreinDienst(Trein^.Planpunten, 4);
				end else
					SendMsg.SendPlainString('smsg:Rijden zonder rijplan.');
			tmStilstaan:
				if assigned(Trein^.StationModusPlanpunt) then begin
					SendMsg.SendPlainString('smsg:'+rlsStatusHeading);
					SendMsg.SendPlainString('smsg:'+RijpuntLijstStr(Trein^.StationModusPlanpunt, rlsStatus));
					SendMsg.SendPlainString('smsg:Daarna verder naar:');
					SendTreinDienst(Trein^.Planpunten, 3);
				end else
					SendMsg.SendPlainString('smsg:Stilstaan zonder rijplan.');
			tmGecrasht:
				SendMsg.SendPlainString('smsg:Trein is gecrasht');
			end;
			SendMsg.SendPlainString('smsg:--');
		end else
			SendError(unknowntrainerror+'.');
	end else if cmd = 'comm_bel' then begin
		SplitOff(tail, wat, nummer);
		if Wat = 't' then begin
			Trein := Core.ZoekTrein(nummer);
			if assigned(Trein) then begin
				Gesprek := Core.NieuwTelefoongesprek(Trein, tgtGebeldWorden, true);
				Gesprek^.tekstX := 'Hier trein '+Trein^.Treinnummer+'. Zegt u het maar.';
				Gesprek^.tekstXsoort := pmsTreinOpdracht;
				SendOK
			end else
				SendError(unknowntrainerror+'.');
		end else if Wat = 'r' then begin
			Gesprek := Core.NieuwTelefoongesprek(Core.pMonteur, tgtGebeldWorden, true);
			Gesprek^.tekstX := 'Met de storingsdienst. Waarmee kan ik u van dienst zijn?';
			Gesprek^.tekstXsoort := pmsMonteurOpdracht;
			SendOK
		end else
			SendError('unknown telephone nr');
	end else if cmd = 'comm_opn' then begin
		SplitOff(tail, wat, nummer);
		if Wat = 't' then begin
			Trein := Core.ZoekTrein(nummer);
			if assigned(Trein) then begin
				Gesprek := Core.ZoekTelefoongesprek(Trein);
				if assigned(Gesprek) then begin
					SendOK;
					CommPhysics.TrdlNeemtOp(Gesprek)
				end else
					SendError('unknown conversation.')
			end else
				SendError(unknowntrainerror+'.');
		end else	if Wat = 'r' then begin
			Gesprek := Core.ZoekTelefoongesprek(Core.pMonteur);
			if assigned(Gesprek) then begin
				CommPhysics.TrdlNeemtOp(Gesprek);
				SendMsg.SendPlainString('ok')
			end else
				SendMsg.SendPlainString('err:unknown conversation.')
		end else
			SendError('unknown telephone nr');
	end else if cmd = 'comm_oph' then begin
		// Niet echt slimme code-reuse... ;-)
		SplitOff(tail, wat, nummer);
		if Wat = 't' then begin
			Trein := Core.ZoekTrein(nummer);
			if assigned(Trein) then begin
				Gesprek := Core.ZoekTelefoongesprek(Trein);
				if assigned(Gesprek) then begin
					SendOK;
					CommPhysics.TrdlHangtOp(Gesprek)
				end else
					SendError('unknown conversation.')
			end else
				SendError(unknowntrainerror+'.');
		end else	if Wat = 'r' then begin
			Gesprek := Core.ZoekTelefoongesprek(Core.pMonteur);
			if assigned(Gesprek) then begin
				SendOK;
				CommPhysics.TrdlHangtOp(Gesprek)
			end else
				SendError('unknown conversation.')
		end;
	end else if cmd = 'comm_msg' then begin
		// Niet echt slimme code-reuse... ;-)
		SplitOff(tail, wat, tail);
		if Wat = 't' then begin
			SplitOff(tail, nummer, tail);
			Trein := Core.ZoekTrein(nummer);
			if assigned(Trein) then begin
				Gesprek := Core.ZoekTelefoongesprek(Trein);
				if assigned(Gesprek) then
					if Gesprek^.Status = tgsWachtOpAntwoord then begin

						// inspringen

						SplitOff(tail, tcmd, tail);
						if tcmd = 'ok' then begin
							if Gesprek^.tekstXsoort = pmsVraagOK then begin
								SendOK;
								CommPhysics.AntwoordGegeven(Gesprek);
							end else
								SendError('wrong kind of answer.');
						end else
						if tcmd = 'rl' then begin	// Rijplan Laden
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							SplitOff(tail, nwn_nr, nwn_vanaf);
							Trein^.Treinnummer := nwn_nr;
							Trein^.WisPlanpunten;
							Trein^.Planpunten := Core^.CopyDienstFrom(nwn_nr, nwn_vanaf);
							if assigned(Trein^.StationModusPlanpunt) then begin
								dispose(Trein^.StationModusPlanpunt);
								Trein^.StationModusPlanpunt := Trein^.GetVolgendRijplanpunt;
							end;
						end else if tcmd = 'stsp' then begin	// StopTonend Sein Passeren
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							SplitOff(tail, nummer, tail);
							tmpSein := Core.ZoekSein(nummer);
							if assigned(tmpSein) then begin
								Trein^.doorroodopdracht := true;
								Trein^.doorroodopd_sein := tmpSein;
							end else
								Gesprek^.tekstOK := 'Sorry, maar volgens mij bestaat sein '+nummer+' niet.';
						end else if tcmd = 'stspa' then begin	// STSP-opdracht Annuleren
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							Trein^.doorroodopdracht := false;
						end else if tcmd = 'vnstsp' then begin	// Verderrijden Na STS-Passage
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							Trein^.doorroodverderrijden := true;
						end else if tcmd = 'ra' then begin		// Rijplanpunt Annuleren
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							v_rppunt := nil;
							if tail <> '' then begin
								rppunt := Trein^.Planpunten;
								while assigned(rppunt) do begin
									if rppunt^.Station = tail then break;
									v_rppunt := rppunt;
									rppunt := rppunt^.volgende;
								end;
							end else
								rppunt := Trein^.Planpunten;
							if assigned(rppunt) then begin
								if assigned(v_rppunt) then
									v_rppunt^.volgende := rppunt^.volgende
								else
									Trein^.Planpunten := rppunt^.volgende;
							end else
								Gesprek^.tekstOK := 'Sorry, maar ik kom niet langs station '+tail+'.';
						end else if tcmd = 'nr' then begin		// Nieuw Rijplanpunt
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
							ok := true;
							SplitOff(tail, rppunt_na, tail);
							if rppunt_na = '-' then
								v_rppunt := nil
							else begin
								v_rppunt := Trein^.Planpunten;
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
										rppunt^.Volgende := Trein^.Planpunten;
										Trein^.Planpunten := rppunt;
									end else begin
										rppunt^.volgende := v_rppunt^.volgende;
										v_rppunt^.volgende := rppunt;
									end;
								end else
									Gesprek^.tekstOK := 'Sorry, maar dat snap ik niet!';
							end else
								Gesprek^.tekstOK := 'Sorry, maar ik kom niet langs station '+rppunt_na+'.';
						end else if tcmd = 'wtt' then begin		// WachT met Telefoneren
							val(tail,tm,code);
							if code = 0 then begin
								Gesprek^.WachtMetBellen := GetTijd+MkTijd(0,tm,0);
								Gesprek^.WachtOpdracht := true;
								CommPhysics.AntwoordGegeven(Gesprek);
								SendOK
							end else
								SendError('wrong number of minutes');
						end else
							SendError('unknown train command');

					end else
						SendError('answer cannot be heard now.')
				else
					SendError('unknown conversation.')
			end else
				SendError(unknowntrainerror+'.');
		end else if Wat = 'r' then begin
			Gesprek := Core.ZoekTelefoongesprek(Core.pMonteur);
			if assigned(Gesprek) then
				if Gesprek^.Status = tgsWachtOpAntwoord then begin

					SplitOff(tail, wat, nummer);
					if wat = 'ok' then begin
						if Gesprek^.tekstXsoort = pmsVraagOK then begin
							SendOK;
							CommPhysics.AntwoordGegeven(Gesprek);
						end else
							SendError('wrong kind of answer.');
					end else
					if wat = 'w' then begin
						SendOK;
						CommPhysics.AntwoordGegeven(Gesprek);
						Opdracht.Wat := mrwWissel;
						Opdracht.ID := nummer;
						if not MonteurPhysics.StuurMonteur(Core.pMonteur, Opdracht) then
							Gesprek^.tekstOK := 'Sorry, maar ik heb nu geen tijd.';
						CommPhysics.AntwoordGegeven(Gesprek)
					end else
						SendError('unknown repair thing');

				end else
					SendError('answer cannot be heard now.')
			else
				SendError('unknown conversation.')
		end else
			SendError('unknown telephone nr');
	end else if cmd = 'bc' then begin
		SendOK;
		tmpMeetpunt := Core^.pAlleMeetpunten;
		while assigned(tmpMeetpunt) do begin
			RailLijst := tmpMeetpunt^.ZichtbaarLijst;
			while assigned(RailLijst) do begin
				Trein := Core^.pAlleTreinen;
				while assigned(Trein) do begin
					if Trein^.pos_rail = RailLijst^.Rail then
						if not assigned(Core.ZoekTelefoongesprek(Trein)) then begin
							Gesprek := Core.NieuwTelefoongesprek(Trein, tgtBellen, true);
							Gesprek^.tekstX := 'Trein '+Trein^.Treinnummer+' meldt zich!';
							Gesprek^.tekstXsoort := pmsInfo;
						end;
					Trein := Trein^.Volgende;
				end;
				RailLijst := RailLijst^.Volgende;
			end;
			tmpMeetpunt := tmpMeetpunt^.Volgende;
		end;
	end else if cmd = 'ti' then begin
		SplitOff(tail, nummer, tail);
		SplitOff(tail, wat, tail);
		if wat = 'v' then begin
			SplitOff(tail, vertrsoort, tail);
			val(tail, minuten, code);
			if (vertrsoort = 'st') or (vertrsoort = 'ex') then
				if code = 0 then begin
					TreinInfo := Core.ZoekOfMaakTreininfo(nummer);
					if vertrsoort = 'st' then
						ScoreVertraging(TreinInfo, minuten, vtSchatting);
					if vertrsoort = 'ex' then
						ScoreVertraging(TreinInfo, minuten, vtExact);
					SendOK;
				end else
					SendError('delay is invalid number.')
			else
				SendError('invalid delay type.')
		end else
			SendError('invalid type of train information.')
	end else if cmd = 'score' then begin
		SendOK;
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
		SendError('unknown command');
end;

end.
