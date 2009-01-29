unit stwsimEditHelpers;

interface

uses forms, stwvCore, stwvMeetpunt, stwvGleisplan, stwvHokjes, stwvSporen,
	stwvRijwegen, stwvRijwegLogica;

procedure WisRijwegenVanPlan(Gleisplan: TvGleisplan);
procedure RijwegVoegInactiefHokjeToe(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer);
function RijwegVerwijderInactiefHokje(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer): boolean;
function ZoekSubrouteBijHokje(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer): PvSubroute;

implementation

procedure WisRijwegenVanPlan;
var
	x,y: integer;
	Hokje: TvHokje;
	repaint: boolean;
begin
	for x := 0 to Gleisplan.MaxX do
		for y := 0 to Gleisplan.MaxY do begin
			Hokje := Gleisplan.GetHokje(x,y);
			case Hokje.Soort of
				1: begin
					PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg := false;
					PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg := 0;
					repaint := false;
					if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt) then begin
						if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.RijwegOnderdeel) then begin
							PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.RijwegOnderdeel := nil;
							repaint := true;
						end;
						if PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.bezet then begin
							PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.bezet := false;
							repaint := true;
						end;
					end;
					if assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein) then begin
						if assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.RijwegOnderdeel) then begin
							PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.RijwegOnderdeel := nil;
							repaint := true;
						end;
					end;
					if repaint then
						Gleisplan.PaintMeetpunt(PvHokjeSpoor(Hokje.grdata)^.Meetpunt);
				end;
				3: begin
					if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then
						if PvHokjeSein(Hokje.grdata)^.Sein^.Stand <> 'r' then begin
							PvHokjeSein(Hokje.grdata)^.Sein^.Stand := 'r';
							PvHokjeSein(Hokje.grdata)^.Sein^.RijwegOnderdeel := nil;
							Gleisplan.PaintSein(PvHokjeSein(Hokje.grdata)^.Sein);
						end;
				end;
				5: begin
					PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg := false;
					if assigned(PvHokjeWissel(Hokje.grdata)^.Wissel^.RijwegOnderdeel) then begin
						PvHokjeWissel(Hokje.grdata)^.Wissel^.RijwegOnderdeel := nil;
						PvHokjeWissel(Hokje.grdata)^.Wissel^.Stand := wsOnbekend;
						Gleisplan.PaintWissel(PvHokjeWissel(Hokje.grdata)^.Wissel);
					end;
				end;
				6: begin
					if assigned(PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis) then
						if PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.richting <> 0 then begin
							PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.richting := 0;
							Gleisplan.PaintErlaubnis(PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis);
						end;
				end;
			end;
		end;
end;

function ZoekSubrouteBijHokje;
var
	Hokje:		TvHokje;
	Meetpunt:	PvMeetpunt;
	Subroute: 	PvSubroute;
begin
	result := nil;
	// Zoek het tab.
	Hokje := Tab^.Gleisplan.GetHokje(x,y);
	case Hokje.Soort of
	1:	Meetpunt := PvHokjeSpoor(Hokje.grdata)^.Meetpunt;
	5: Meetpunt := PvHokjeWissel(Hokje.grdata)^.Meetpunt;
	else
		Meetpunt := nil;
	end;
	if not assigned(meetpunt) then exit;

	Subroute := RijwegLogica.ZoekSubroute(Meetpunt, true);
	if not assigned(Subroute) then
		Subroute := RijwegLogica.CreateSubrouteFrom(Meetpunt);

	if not assigned(Subroute) then
		Application.MessageBox('Interne fout: subroute niet gevonden, maar kon ook niet gemaakt worden?','Fout',0);

	result := subroute;
end;

procedure RijwegVoegInactiefHokjeToe;
var
	nInactiefHokje: PvInactiefHokje;
	Subroute: 	PvSubroute;
begin
	Subroute := ZoekSubrouteBijHokje(RijwegLogica, Tab, x, y);

	if not assigned(Subroute) then exit;

	// Kijk of het hokje niet al in de subroute zit.
	nInactiefHokje := Subroute.EersteHokje;
	while assigned(nInactiefHokje) do begin
		if (nInactiefHokje^.schermID = Tab^.ID) and
			(nInactiefHokje^.x = x) and
			(nInactiefHokje^.y = y) then begin
			exit;
		end;
		nInactiefHokje := nInactiefHokje^.Volgende;
	end;
	// En toevoegen maar.
	new(nInactiefHokje);
	nInactiefHokje^.schermID := Tab^.ID;
	nInactiefHokje^.x := x;
	nInactiefHokje^.y := y;
	nInactiefHokje^.volgende := Subroute.EersteHokje;
	Subroute.EersteHokje := nInactiefHokje;
end;

function RijwegVerwijderInactiefHokje;
var
	vInactiefHokje, InactiefHokje: PvInactiefHokje;
	Subroute: PvSubroute;
begin
	result := false;

	Subroute := ZoekSubrouteBijHokje(RijwegLogica, Tab, x, y);

	if not assigned(Subroute) then exit;

	vInactiefHokje := nil;
	InactiefHokje := Subroute.EersteHokje;
	while assigned(InactiefHokje) do begin
		if (InactiefHokje^.schermID = Tab^.ID) and
			(InactiefHokje^.x = x) and
			(InactiefHokje^.y = y) then begin
			if assigned(vInactiefHokje) then
				vInactiefHokje.Volgende := InactiefHokje.Volgende
			else
				Subroute.EersteHokje := InactiefHokje.Volgende;
			dispose(InactiefHokje);
			result := true;
			exit;
		end;
		vInactiefHokje := InactiefHokje;
		InactiefHokje := InactiefHokje^.Volgende;
	end;
end;

end.
