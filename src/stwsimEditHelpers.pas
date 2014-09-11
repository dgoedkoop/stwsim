unit stwsimEditHelpers;

interface

uses forms, stwvCore, stwvMeetpunt, stwvGleisplan, stwvHokjes, stwvSporen,
	stwvRijwegen, stwvRijwegLogica;

procedure WisRijwegenVanPlan(Gleisplan: TvGleisplan; paint: boolean);
procedure RijwegVoegInactiefHokjeToe(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer);
function RijwegVerwijderInactiefHokje(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer): boolean;
function ZoekSubrouteBijHokje(RijwegLogica: TRijweglogica; Tab: PTabList; x,y: integer): PvSubroute;
function VerwijderHokjeRijwegdata(RijwegLogica: TRijwegLogica; Tab: PTabList; x, y: integer): boolean;
function KopieerHokjeRijwegdata(RijwegLogica: TRijwegLogica; SrcTab: PTabList; srcx, srcy: integer; DestTab: PTabList; destx, desty: integer): boolean;
function VerplaatsHokjeRijwegdata(RijwegLogica: TRijwegLogica; SrcTab: PTabList; srcx, srcy: integer; DestTab: PTabList; destx, desty: integer): boolean;

implementation

function VerwijderHokjeRijwegdata;
var
	Rijweg: PvRijweg;
   Subroute: PvSubroute;
	KruisingHokje, vKruisingHokje: PvKruisingHokje;
	InactiefHokje, vInactiefHokje: PvInactiefHokje;
begin
	result := false;
	Rijweg := RijwegLogica.Core.vAlleRijwegen;
   while assigned(rijweg) do begin
		KruisingHokje := Rijweg.KruisingHokjes;
      vKruisingHokje := nil;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = Tab^.ID) and
				(KruisingHokje^.x = x) and
				(KruisingHokje^.y = y) then begin
            if assigned(vKruisingHokje) then begin
            	vKruisingHokje^.volgende := KruisingHokje^.Volgende;
               dispose(KruisingHokje);
               KruisingHokje := vKruisingHokje^.volgende;
            end else begin
            	Rijweg.KruisingHokjes := KruisingHokje^.volgende;
               dispose(KruisingHokje);
               KruisingHokje := Rijweg.KruisingHokjes;
            end;
           	result := true;
         end else begin
         	vKruisingHokje := KruisingHokje;
            KruisingHokje := KruisingHokje^.volgende;
         end;
		end;
   	Rijweg := Rijweg^.Volgende;
   end;
   Subroute := RijwegLogica.Core.vAlleSubroutes;
   while assigned(Subroute) do begin
		InactiefHokje := Subroute.EersteHokje;
      vInactiefHokje := nil;
		while assigned(InactiefHokje) do begin
			if (InactiefHokje^.schermID = Tab^.ID) and
				(InactiefHokje^.x = x) and
				(InactiefHokje^.y = y) then begin
            if assigned(vInactiefHokje) then begin
            	vInactiefHokje^.volgende := InactiefHokje^.Volgende;
               dispose(InactiefHokje);
               InactiefHokje := vInactiefHokje^.volgende;
            end else begin
            	Subroute.EersteHokje := InactiefHokje^.volgende;
               dispose(InactiefHokje);
               InactiefHokje := Subroute.EersteHokje;
            end;
            result := true;
			end else begin
         	vInactiefHokje := InactiefHokje;
				InactiefHokje := InactiefHokje^.Volgende;
         end;
		end;
		KruisingHokje := Subroute.KruisingHokjes;
      vKruisingHokje := nil;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = Tab^.ID) and
				(KruisingHokje^.x = x) and
				(KruisingHokje^.y = y) then begin
            if assigned(vKruisingHokje) then begin
            	vKruisingHokje^.volgende := KruisingHokje^.Volgende;
               dispose(KruisingHokje);
               KruisingHokje := vKruisingHokje^.volgende;
            end else begin
            	Subroute.KruisingHokjes := KruisingHokje^.volgende;
               dispose(KruisingHokje);
               KruisingHokje := Subroute.KruisingHokjes;
            end;
           	result := true;
         end else begin
         	vKruisingHokje := KruisingHokje;
            KruisingHokje := KruisingHokje^.volgende;
         end;
		end;
   	Subroute := Subroute^.Volgende;
   end;
end;

function KopieerHokjeRijwegdata;
var
	Rijweg: PvRijweg;
   Subroute: PvSubroute;
	KruisingHokje, nKruisingHokje: PvKruisingHokje;
	InactiefHokje, nInactiefHokje: PvInactiefHokje;
begin
	result := false;
	Rijweg := RijwegLogica.Core.vAlleRijwegen;
   while assigned(rijweg) do begin
		KruisingHokje := Rijweg.KruisingHokjes;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = SrcTab^.ID) and
				(KruisingHokje^.x = srcx) and
				(KruisingHokje^.y = srcy) then begin
				new(nKruisingHokje);
            nKruisingHokje^ := KruisingHokje^;
            nKruisingHokje^.schermID := DestTab^.ID;
            nKruisingHokje^.x := destx;
            nKruisingHokje^.y := desty;
            KruisingHokje^.Volgende := nKruisingHokje;
            KruisingHokje := nKruisingHokje;
           	result := true;
			end;
			KruisingHokje := KruisingHokje^.Volgende;
		end;
   	Rijweg := Rijweg^.Volgende;
   end;
   Subroute := RijwegLogica.Core.vAlleSubroutes;
   while assigned(Subroute) do begin
		InactiefHokje := Subroute.EersteHokje;
		while assigned(InactiefHokje) do begin
			if (InactiefHokje^.schermID = SrcTab^.ID) and
				(InactiefHokje^.x = srcx) and
				(InactiefHokje^.y = srcy) then begin
				new(nInactiefHokje);
            nInactiefHokje^ := InactiefHokje^;
            nInactiefHokje^.schermID := DestTab^.ID;
            nInactiefHokje^.x := destx;
            nInactiefHokje^.y := desty;
            InactiefHokje^.Volgende := nInactiefHokje;
            InactiefHokje := nInactiefHokje;
           	result := true;
			end;
			InactiefHokje := InactiefHokje^.Volgende;
		end;
		KruisingHokje := Subroute.KruisingHokjes;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = SrcTab^.ID) and
				(KruisingHokje^.x = srcx) and
				(KruisingHokje^.y = srcy) then begin
				new(nKruisingHokje);
            nKruisingHokje^ := KruisingHokje^;
            nKruisingHokje^.schermID := DestTab^.ID;
            nKruisingHokje^.x := destx;
            nKruisingHokje^.y := desty;
            KruisingHokje^.Volgende := nKruisingHokje;
            KruisingHokje := nKruisingHokje;
           	result := true;
			end;
			KruisingHokje := KruisingHokje^.Volgende;
		end;
   	Subroute := Subroute^.Volgende;
   end;
end;

function VerplaatsHokjeRijwegdata;
var
	Rijweg: PvRijweg;
   Subroute: PvSubroute;
	KruisingHokje: PvKruisingHokje;
	InactiefHokje: PvInactiefHokje;
begin
	result := false;
	Rijweg := RijwegLogica.Core.vAlleRijwegen;
   while assigned(rijweg) do begin
		KruisingHokje := Rijweg.KruisingHokjes;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = SrcTab^.ID) and
				(KruisingHokje^.x = srcx) and
				(KruisingHokje^.y = srcy) then begin
            KruisingHokje^.schermID := DestTab^.ID;
            KruisingHokje^.x := destx;
            KruisingHokje^.y := desty;
           	result := true;
			end;
			KruisingHokje := KruisingHokje^.Volgende;
		end;
   	Rijweg := Rijweg^.Volgende;
   end;
   Subroute := RijwegLogica.Core.vAlleSubroutes;
   while assigned(Subroute) do begin
		InactiefHokje := Subroute.EersteHokje;
		while assigned(InactiefHokje) do begin
			if (InactiefHokje^.schermID = SrcTab^.ID) and
				(InactiefHokje^.x = srcx) and
				(InactiefHokje^.y = srcy) then begin
            InactiefHokje^.schermID := DestTab^.ID;
            InactiefHokje^.x := destx;
            InactiefHokje^.y := desty;
           	result := true;
			end;
			InactiefHokje := InactiefHokje^.Volgende;
		end;
		KruisingHokje := Subroute.KruisingHokjes;
		while assigned(KruisingHokje) do begin
			if (KruisingHokje^.schermID = SrcTab^.ID) and
				(KruisingHokje^.x = srcx) and
				(KruisingHokje^.y = srcy) then begin
            KruisingHokje^.schermID := DestTab^.ID;
            KruisingHokje^.x := destx;
            KruisingHokje^.y := desty;
           	result := true;
			end;
			KruisingHokje := KruisingHokje^.Volgende;
		end;
   	Subroute := Subroute^.Volgende;
   end;
end;

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
						if PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.Knipperen then begin
							PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.Knipperen := false;
							repaint := true;
						end;
					end;
					if assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein) then begin
						if assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.RijwegOnderdeel) then begin
							PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.RijwegOnderdeel := nil;
							repaint := true;
						end;
					end;
					if paint and repaint then
						Gleisplan.PaintMeetpunt(PvHokjeSpoor(Hokje.grdata)^.Meetpunt);
				end;
				3: begin
					if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then
						if PvHokjeSein(Hokje.grdata)^.Sein^.Stand <> 'r' then begin
							PvHokjeSein(Hokje.grdata)^.Sein^.Stand := 'r';
							PvHokjeSein(Hokje.grdata)^.Sein^.RijwegOnderdeel := nil;
							if paint then
								Gleisplan.PaintSein(PvHokjeSein(Hokje.grdata)^.Sein);
						end;
				end;
				5: begin
					PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg := false;
					if assigned(PvHokjeWissel(Hokje.grdata)^.Wissel^.RijwegOnderdeel) then begin
						PvHokjeWissel(Hokje.grdata)^.Wissel^.RijwegOnderdeel := nil;
						PvHokjeWissel(Hokje.grdata)^.Wissel^.Stand := wsOnbekend;
						if paint then
							Gleisplan.PaintWissel(PvHokjeWissel(Hokje.grdata)^.Wissel);
					end;
				end;
				6: begin
					if assigned(PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis) then
						if PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.richting <> 0 then begin
							PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.richting := 0;
							if paint then
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

	// Als niet gevonden werd en ook niet gemaakt kan worden, dan komt dat
	// doordat de subroute geen wissels of kruisingen zou hebben en dus totaal
	// nutteloos zou zijn.

//	if not assigned(Subroute) then
//		Application.MessageBox('Interne fout: subroute niet gevonden, maar kon ook niet gemaakt worden?','Fout',0);

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
