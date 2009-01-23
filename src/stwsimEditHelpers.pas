unit stwsimEditHelpers;

interface

uses stwvCore, stwvMeetpunt, stwvGleisplan, stwvHokjes;

procedure WisRijwegenVanPlan(Gleisplan: TvGleisplan);

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

end.
