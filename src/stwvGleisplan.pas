unit stwvGleisplan;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	stwvCore, stwvHokjes, stwvMeetpunt, stwvSeinen, stwvSporen, stwvMisc;

type
	LiRe = (links,rechts);

	TvGleisplan = class(TGraphicControl)
	private
		imaxx, imaxy: integer;
		fLaatAlleTreinnrPosZien: boolean;
		ispp: boolean;
		isseinen, isswnr: boolean;
		isinactrichting: boolean;
		blinkUit: boolean;
		wisselblinkonbekend: boolean;
		hokjes:		PvHokjesArray;
		grimg: TPicture;
		function GetWisselBlinkOnbekend: boolean;
		procedure SetWisselBlinkOnbekend(waarde: boolean);
		function GetMaxX: integer;
		procedure SetMaxX(nmaxx: integer);
		function GetMaxY: integer;
		procedure SetMaxY(nmaxy: integer);
		function GetSPP: boolean;
		procedure SetSPP(spp: boolean);
		function GetSSeinen: boolean;
		procedure SetSSeinen(sseinen: boolean);
		function GetSSWnr: boolean;
		procedure SetSSWnr(showseinwisselnrs: boolean);
		function GetSInachtRichting: boolean;
		procedure SetSInachtRichting(ShowInachtRichting: boolean);
		function GetBlinkUit: boolean;
		procedure SetBlinkUit(uit: boolean);
		function GetLATPZ: boolean;
		procedure SetLATPZ(waarde: boolean);
		procedure CopyPlaatje(nx,ny,vx,vy: integer);
	protected
		procedure Paint; override;
	public
		Core: PvCore;
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		procedure Empty(x,y: integer);
		procedure PutText(x,y: integer; text: string; kleur: byte; spoornummer: string; seinwisselnr: boolean);
		procedure PutSpoor(x,y: integer; grx,gry: integer; meetpunt: PvMeetpunt);
		procedure PutTreinnummer(x,y: integer; meetpunt: PvMeetpunt; maxlen: integer);
		procedure PutTreinnummerX(x,y: integer; meetpunt: PvMeetpunt; index: integer; maxlen: integer);
		procedure PutSein(x,y: integer; grx,gry: integer; Sein: PvSein);
		procedure PutSeinDriehoekje(x,y: integer; Sein: PvSein);
		procedure PutErlaubnis(x,y: integer; grx,gry: integer; Erlaubnis: PvErlaubnis; ActiefStand: byte);
		procedure PutLandschap(x,y: integer; grx,gry: integer);
		procedure PutWissel(x,y: integer; grx,gry: integer; meetpunt: PvMeetpunt; wissel: PvWissel; schuinisrecht: boolean);
		procedure MeetpuntGrensCorrectie(x,y: integer; var grx,gry: integer; meetpunt: PvMeetpunt);
		procedure MeetpuntResetInactief(meetpunt: PvMeetpunt);
		procedure MeetpuntResetKruis(meetpunt: PvMeetpunt);
		procedure PaintMeetpunt(meetpunt: PvMeetpunt);
		procedure PaintWissel(wissel: PvWissel);
		procedure PaintWisselGroep(Groep: PvWisselGroep);
		procedure PaintSein(Sein: PvSein);
		procedure PaintErlaubnis(Erlaubnis: PvErlaubnis);
		procedure PaintHokje(x,y: integer);
		procedure PaintBlink;
		function GetHokje(x,y: integer): TvHokje;
		procedure WatHier(mx,my: integer; var x,y: integer; var Hokje: TvHokje);
		procedure SavePlan(var f: file);
		procedure LoadPlan(var f: file);
		procedure SaveInactieveEnKruisingHokjes(var f: file);
		procedure LoadInactieveEnKruisingHokjes(var f: file);
	published
		property KnipperGedoofd: boolean read GetBlinkUit write SetBlinkUit default false;
		property OnbekendeWisselsKnipperen: boolean read GetWisselBlinkOnbekend write SetWisselBlinkOnbekend default true;
		property MaxX: integer read GetMaxX write SetMaxX;
		property MaxY: integer read GetMaxY write SetMaxY;
		property ShowPointPositions: boolean read GetSPP write SetSPP default false;
		property ShowSeinen: boolean read GetSSeinen write SetSSeinen default false;
		property ShowSeinWisselNummers: boolean read GetSSWnr write SetSSWnr default true;
		property ShowInactieveRichtingen: boolean read GetSInachtRichting write SetSInachtRichting default true;
		property LaatAlleTreinnrPosZien: boolean read GetLATPZ write SetLATPZ;
		property OnClick;
		property OnDblClick;
		property OnMouseMove;
		property OnMouseDown;
		property OnMouseUp;
		property PopupMenu;
	end;

procedure Register;

implementation

{$R gleisplanRes.res}

function MeetpuntenVerschillen(eerste, tweede: PvMeetpunt): boolean;
begin
	result := (eerste <> tweede) and assigned(eerste) and assigned(tweede);
end;

destructor TvGleisplan.Destroy;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			Dispose(Hokje.DynData);
			case Hokje.Soort of
				1: Dispose(PvHokjeSpoor(Hokje.grdata));
				2: Dispose(PvHokjeLetter(Hokje.grdata));
				3: Dispose(PvHokjeSein(Hokje.grdata));
				4: Dispose(PvHokjeLS(Hokje.grdata));
				5: Dispose(PvHokjeWissel(Hokje.grdata));
				6: Dispose(PvHokjeErlaubnis(Hokje.grdata));
			end;
		end;

	FreeMem(hokjes, sizeof(TvHokje)*(imaxx+1)*(imaxy+1));

	grimg.Destroy;

	inherited;
end;

function TvGleisplan.GetMaxX;
begin
	result := imaxx;
end;

procedure TvGleisplan.SetMaxX;
var
	NewHokjes: PvHokjesArray;
	x, y: integer;
begin
	if nmaxx = imaxx then exit;

	// Nieuw geheugen claimen
	GetMem(NewHokjes, sizeof(TvHokje)*(nmaxx+1)*(imaxy+1));
	// Gegevens overkopiëren & nieuwe lege hokjes initialiseren
	for y := 0 to imaxy do
		if nmaxx > imaxx then begin
			move(hokjes^[y*(imaxx+1)], NewHokjes^[y*(nmaxx+1)], imaxx*sizeof(TvHokje));
			for x := imaxx+1 to nmaxx do begin
				NewHokjes^[y*(nmaxx+1)+x].soort := 0;
				NewHokjes^[y*(nmaxx+1)+x].grdata := nil;
				NewHokjes^[y*(nmaxx+1)+x].dyndata := nil;
			end;
		end else
			move(hokjes^[y*(imaxx+1)], NewHokjes^[y*(nmaxx+1)], nmaxx*sizeof(TvHokje));
	// Oude geheugen vrijgeven
	FreeMem(hokjes, sizeof(TvHokje)*(imaxx+1)*(imaxy+1));
	// Instellen
	imaxx := nmaxx;
	hokjes := NewHokjes;
	Constraints.MinWidth := (imaxx+1)*8;
	Constraints.MaxWidth := Constraints.MinWidth;
	Repaint;
end;

function TvGleisplan.GetMaxY;
begin
	result := imaxy;
end;

procedure TvGleisplan.SetMaxY;
var
	NewHokjes: PvHokjesArray;
	x, y: integer;
begin
	if nmaxy = imaxy then exit;

	// Nieuw geheugen claimen
	GetMem(NewHokjes, sizeof(TvHokje)*(imaxx+1)*(nmaxy+1));
	// Gegevens overkopiëren & nieuwe lege hokjes initialiseren
	if nmaxy < imaxy then
		move(hokjes^[0], newHokjes^[0], (imaxx+1)*(nmaxy+1)*sizeof(TvHokje))
	else begin
		move(hokjes^[0], newHokjes^[0], (imaxx+1)*(imaxy+1)*sizeof(TvHokje));
		for y := imaxy+1 to nmaxy do
			for x := 0 to imaxx do begin
				NewHokjes^[y*(imaxx+1)+x].soort := 0;
				NewHokjes^[y*(imaxx+1)+x].grdata := nil;
				NewHokjes^[y*(imaxx+1)+x].dyndata := nil;
			end;
	end;
	// Oude geheugen vrijgeven
	FreeMem(hokjes, sizeof(TvHokje)*(imaxx+1)*(imaxy+1));
	// Instellen
	imaxy := nmaxy;
	hokjes := NewHokjes;
	Constraints.MinHeight := (imaxy+1)*16;
	Constraints.MaxHeight := Constraints.MinHeight;
	Repaint;
end;

function TvGleisplan.GetWisselBlinkOnbekend;
begin
	result := wisselblinkonbekend;
end;

procedure TvGleisplan.SetWisselBlinkOnbekend;
begin
	wisselblinkonbekend := waarde;
end;

function TvGleisplan.GetSPP;
begin
	result := ispp;
end;

procedure TvGleisplan.SetSPP;
begin
	ispp := spp;
	Paint;
end;

function TvGleisplan.GetSSeinen;
begin
	result := isseinen;
end;

procedure TvGleisplan.SetSSeinen;
var
	Sein: PvSein;
begin
	isseinen := sseinen;
	Sein := Core^.vAlleSeinen;
	while assigned(Sein) do begin
		PaintSein(Sein);
		Sein := Sein^.Volgende;
	end;
	PaintSein(nil);
end;

function TvGleisplan.GetSSWnr;
begin
	result := isswnr;
end;

procedure TvGleisplan.SetSSWnr;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	isswnr := showseinwisselnrs;
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 2 then
				PaintHokje(x,y);
		end;
end;

function TvGleisplan.GetSInachtRichting;
begin
	result := isinactrichting;
end;

procedure TvGleisplan.SetSInachtRichting;
var
	Erlaubnis: PvErlaubnis;
begin
	isinactrichting := ShowInachtRichting;
	Erlaubnis := Core^.vAlleErlaubnisse;
	while assigned(Erlaubnis) do begin
		PaintErlaubnis(Erlaubnis);
		Erlaubnis := Erlaubnis^.Volgende;
	end;
end;

function TvGleisplan.GetBlinkUit;
begin
	result := blinkUit;
end;

procedure TvGleisplan.SetBlinkUit;
begin
	blinkUit := uit;
	PaintBlink;
end;

function TvGleisplan.GetLATPZ;
begin
	result := fLaatAlleTreinnrPosZien;
end;

procedure TvGleisplan.SetLATPZ;
begin
	fLaatAlleTreinnrPosZien := waarde;
end;

procedure TvGleisplan.Empty;
var
	hokje: TvHokje;
begin
	hokje := hokjes^[y*(imaxx+1)+x];
	if Hokje.soort = 1 then begin
		dispose(PvHokjeSpoor(Hokje.grdata));
	end else if Hokje.soort = 2 then begin
		dispose(PvHokjeLetter(Hokje.grdata));
	end else if Hokje.soort = 3 then begin
		dispose(PvHokjeSein(Hokje.grdata));
	end else if Hokje.soort = 4 then begin
		dispose(PvHokjeLS(Hokje.grdata));
	end else if Hokje.soort = 5 then begin
		dispose(PvHokjeWissel(Hokje.grdata));
	end;
	Hokje.grdata := nil;
	if assigned(Hokje.DynData) then begin
		dispose(Hokje.DynData);
		Hokje.DynData := nil;
	end;
	Hokje.soort := 0;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.CopyPlaatje;
var
	nrect, vrect: TRect;
begin
	nrect.Left := nx*8;
	nrect.Right := nx*8+8;
	nrect.Top := ny*16;
	nrect.Bottom := ny*16+16;
	vrect.Left := vx*9;
	vrect.Right := vx*9+8;
	vrect.Top := vy*17;
	vrect.Bottom := vy*17+16;
	Canvas.CopyRect(nrect, grimg.Bitmap.Canvas, vrect);
end;

procedure TvGleisplan.MeetpuntGrensCorrectie;
var
	tmpHokje: TvHokje;

begin
	if (grx = 0) or (grx = 1) then begin
		if x < MaxX then begin
			tmpHokje := GetHokje(x+1, y);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := 18;
		end;
		if x > 0 then begin
			tmpHokje := GetHokje(x-1, y);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := 19;
		end;
	end;
	if (grx = 4) or (grx = 6) then begin
		if x < MaxX then begin
			tmpHokje := GetHokje(x+1, y);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := grx + 21;
		end;
	end;
	if (grx = 3) or (grx = 5) then begin
		if x > 0 then begin
			tmpHokje := GetHokje(x-1, y);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := grx + 21;
		end;
	end;
	if (grx = 3) or (grx = 6) then begin
		if y < MaxY then begin
			tmpHokje := GetHokje(x, y+1);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := grx + 17;
		end;
	end;
	if (grx = 4) or (grx = 5) then begin
		if y > 0 then begin
			tmpHokje := GetHokje(x, y-1);
			if tmpHokje.soort = 1 then
				if MeetpuntenVerschillen(PvHokjeSpoor(tmpHokje.grdata)^.Meetpunt, Meetpunt) then
					grx := grx + 17;
		end;
	end;
end;

procedure TvGleisplan.PaintHokje;
const
	DOSTransArr: array[0..15] of TColor =
	(clBlack, clNavy, clGreen, clTeal, clMaroon, clPurple, clOlive, clLtGray,
	 clDkGray, clBlue, clLime, clAqua, clRed, clFuchsia, clYellow, clWhite);
var
	hokje: TvHokje;
	grx,gry: integer;
	Meetpunt : PvMeetpunt;
	Sein: PvSein;
	Wissel: PvWissel;
	Erlaubnis: PvErlaubnis;
	ErlaubnisActive: boolean;
	Teken: char;
	welkeletter: byte;
	showdriehoekje: boolean;
	WisselShowStand: boolean;
	WisselBlink: boolean;
begin
	Hokje := hokjes^[y*(imaxx+1)+x];
	// Kijk of we een treinnummer moeten tekenen
	if assigned(Hokje.DynData) then begin
		Meetpunt := Hokje.DynData^.Meetpunt;
		if assigned(Meetpunt) then begin
			welkeletter := Hokje.Dyndata^.TekstIndex - (Hokje.DynData^.MaxTextIndex-length(Meetpunt^.treinnummer)) div 2;
			if ((welkeletter > 0) and (welkeletter <= length(Meetpunt^.treinnummer))) or
				fLaatAlleTreinnrPosZien then begin
				if not fLaatAlleTreinnrPosZien then
					Teken := Meetpunt^.Treinnummer[WelkeLetter]
				else
					Teken := 'X';
				Canvas.Font.Name := 'Fixedsys';
				Canvas.Font.Size := 9;
				Canvas.Font.Color := DOSTransArr[15];
				Canvas.Brush.Style := bsSolid;
				Canvas.Brush.Color := clSilver;
				Canvas.Textout(x*8, y*16, Teken);
				Canvas.Brush.Style := bsSolid;
				Canvas.Brush.Color := clBlack;
				Canvas.Rectangle(x*8, y*16+15, x*8+8, y*16+16);
				exit;
			end;
		end;
	end;
	if Hokje.soort = 0 then begin
		Canvas.Brush.Style := bsSolid;
		Canvas.Brush.Color := clBlack;
		Canvas.Rectangle(x*8, y*16, x*8+8, y*16+16);
	end else if Hokje.Soort = 1 then begin
		grx := PvHokjeSpoor(Hokje.grdata)^.GrX;
		gry := PvHokjeSpoor(Hokje.grdata)^.GrY;
		// BEZET- EN MEETPUNTDINGEN
		Meetpunt := PvHokjeSpoor(Hokje.grdata)^.Meetpunt;
		if (gry=0) or (gry=1) then
			if not PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg
				and assigned(Meetpunt) then begin
				if assigned(Meetpunt^.RijwegOnderdeel) then begin
					if Meetpunt^.bezet then
						gry := 2
					else
						gry := 3;
					if PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg = 1 {\}then begin
						if (grx = 7) or (grx = 10) or (grx = 12) then grx := 4;
						if (grx = 8) or (grx = 9) or (grx = 11) then grx := 3;
						if (grx = 13) or (grx = 14) then grx := 0;
					end else if PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg = 2 {/}then begin
						if (grx = 7) or (grx = 9) or (grx = 13) then grx := 6;
						if (grx = 8) or (grx = 10) or (grx = 14) then grx := 5;
						if (grx = 11) or (grx = 12) then grx := 0;
					end;
				end else
					if Meetpunt^.bezet then
						gry := 2
			end;
		if (grx in [16,17]) then begin
			if ispp then
				showdriehoekje := false
			else
				if (gry <= 2) then
					showdriehoekje := fLaatAlleTreinnrPosZien
				else
					if (not assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein))
						 or (not assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.RijwegOnderdeel)) then
						showdriehoekje := false
					else
						showdriehoekje := true;
			if not showdriehoekje then
				grx := 0;
		end;
		if ispp then
			MeetpuntGrensCorrectie(x,y,grx, gry, Meetpunt);
		if assigned(Meetpunt) and BlinkUit and not ispp and
			not PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg then
			if Meetpunt^.Knipperen then begin
				grx := 0;
				gry := 4;
			end;
		CopyPlaatje(x,y,grx,gry);
	end else if Hokje.Soort = 3 then begin // SEIN
		if isseinen then begin
			grx := PvHokjeSpoor(Hokje.grdata)^.GrX;
			gry := PvHokjeSpoor(Hokje.grdata)^.GrY;
			Sein := PvHokjeSein(Hokje.grdata)^.Sein;
			if not assigned(Sein) then
				grx := grx + 6
			else begin
				if Sein^.Stand = 'g' then
					grx := grx + 2
				else if not assigned(Sein^.RijwegOnderdeel) then
					grx := grx + 4;
				if (Sein^.herroepen or (sein^.Stand_wens='gk')) and blinkUit then begin
					grx := 0;
					gry := 4;
				end;
			end;
		end else begin
			grx := 0;
			gry := 4;
		end;
		CopyPlaatje(x,y,grx,gry);
	end else if Hokje.Soort = 4 then begin
		grx := PvHokjeSpoor(Hokje.grdata)^.GrX;
		gry := PvHokjeSpoor(Hokje.grdata)^.GrY;
		CopyPlaatje(x,y,grx,gry);
	end else if Hokje.Soort = 5 then begin
		grx := PvHokjeWissel(Hokje.grdata)^.GrX;
		gry := PvHokjeWissel(Hokje.grdata)^.GrY;
		Meetpunt := PvHokjeWissel(Hokje.grdata)^.Meetpunt;
		Wissel := PvHokjeWissel(Hokje.grdata)^.Wissel;
		// Bezetmelding
		if (gry=0) or (gry=1) then begin
			if not PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg then begin
				if assigned(Meetpunt^.RijwegOnderdeel) then
					gry := 3;
				if assigned(Meetpunt) then
					if Meetpunt^.bezet then
						gry := 2;
			end;
		end;
		// Wisselstand tonen
		if ispp then
			if PvHokjeWissel(Hokje.grdata)^.Wissel^.Stand <> wsOnbekend then begin
				WisselShowStand := true;
				WisselBlink := false;
			end else begin
				WisselShowStand := false;
				WisselBlink := wisselblinkonbekend;
			end
		else
			if PvHokjeWissel(Hokje.grdata)^.Wissel^.Stand <> wsOnbekend then begin
				WisselBlink := false;
				WisselShowStand := assigned(PvHokjeWissel(Hokje.grdata)^.Wissel^.RijwegOnderdeel);
			end else begin
				WisselShowStand := false;
				WisselBlink := wisselblinkonbekend;
			end;

		if WisselShowStand then begin
			if (Wissel^.Stand = wsRechtdoor) xor PvHokjeWissel(Hokje.grdata)^.SchuinIsRecht then
				grx := 0;
			if (Wissel^.Stand = wsAftakkend) xor PvHokjeWissel(Hokje.grdata)^.SchuinIsRecht then
				grx := grx - 8
		end;
		if WisselBlink then
			if blinkUit and (Wissel^.Stand = wsOnbekend) then begin
				grx := 0;
				gry := 4;
			end;
		if assigned(Meetpunt) and BlinkUit and not PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg then
			if Meetpunt^.Knipperen then begin
				grx := 0;
				gry := 4;
			end;
		CopyPlaatje(x,y,grx,gry);
	end else if Hokje.Soort = 6 then begin
		grx := PvHokjeErlaubnis(Hokje.grdata)^.GrX;
		gry := PvHokjeErlaubnis(Hokje.grdata)^.GrY;
		Erlaubnis := PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis;
		ErlaubnisActive := false;
		if assigned(Erlaubnis) then
			if (Erlaubnis^.richting = PvHokjeErlaubnis(Hokje.grdata)^.ActiefStand) or
				(Erlaubnis^.richting = 4) then
				ErlaubnisActive := true;
		if ErlaubnisActive then
			grx := grx - 2
		else
			if not isinactrichting then begin
				grx := 0;
				gry := 4;
			end;
		CopyPlaatje(x,y,grx,gry);
	end else if Hokje.Soort = 2 then begin	// TEKST
		if (not PvHokjeLetter(Hokje.grdata)^.SeinWisselNr) or isswnr then begin
			Canvas.Font.Name := 'Fixedsys';
			Canvas.Font.Size := 9;
			Canvas.Font.Color := DOSTransArr[PvHokjeLetter(Hokje.grdata)^.Kleur];
			Canvas.Brush.Style := bsSolid;
			Canvas.Brush.Color := clBlack;
			Canvas.Textout(x*8, y*16, PvHokjeLetter(Hokje.grdata)^.Letter);
			Canvas.Brush.Style := bsSolid;
			Canvas.Brush.Color := clBlack;
			Canvas.Rectangle(x*8, y*16+15, x*8+8, y*16+16);
		end else begin
			grx := 0;
			gry := 4;
			CopyPlaatje(x,y,grx,gry);
		end;
	end;
end;

procedure TvGleisplan.PaintBlink;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 1 then
				if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt) then
					if PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.Knipperen then
						PaintHokje(x,y);
			if Hokje.Soort = 3 then
				if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then
					if PvHokjeSein(Hokje.grdata)^.Sein^.herroepen
					or (PvHokjeSein(Hokje.grdata)^.Sein^.Stand_wens = 'gk' )then
						PaintHokje(x,y);
			if Hokje.Soort = 5 then
				if (PvHokjeWissel(Hokje.grdata)^.Wissel^.Stand = wsOnbekend) or
					(assigned(PvHokjeWissel(Hokje.grdata)^.Wissel^.Meetpunt) and
					PvHokjeWissel(Hokje.grdata)^.Wissel^.Meetpunt^.Knipperen) then
					PaintHokje(x,y);
		end;
end;

procedure TvGleisplan.Paint;
var
	bx, by, ex, ey: integer;
	x,y: integer;
begin
	width := (imaxx+1)*8;
	height := (imaxy+1)*16;

	bx := Canvas.ClipRect.Left div 8;
	by := Canvas.ClipRect.Top div 16;

	ex := Canvas.ClipRect.Right div 8;
	ey := Canvas.ClipRect.Bottom div 16;

	for x := bx to ex do
		for y := by to ey do
			if (x <= imaxx) and (y <= imaxy) then
				PaintHokje(x,y);
end;

constructor TvGleisplan.Create;
begin
	inherited Create(AOwner);
	imaxx := -1;
	imaxy := -1;
	hokjes := nil;
	grimg := TPicture.Create;
	grimg.Bitmap.Handle := LoadBitmap(hInstance, 'gr_bmp');
end;

procedure TvGleisplan.PutText;
var
	xx: integer;
	hokje: TvHokje;
begin
	for xx := 1 to length(text) do begin
		Empty(x+xx-1, y);
		hokje := hokjes^[y*(imaxx+1)+x+xx-1];
		hokje.Soort := 2;
		new(PvHokjeLetter(Hokje.grdata));
		PvHokjeLetter(Hokje.grdata)^.Letter := text[xx];
		PvHokjeLetter(Hokje.grdata)^.Kleur := kleur;
		PvHokjeLetter(Hokje.grdata)^.Spoornummer := Spoornummer;
		PvHokjeLetter(Hokje.grdata)^.SeinWisselNr := seinwisselnr;
		hokjes^[y*(imaxx+1)+x+xx-1] := hokje;
	end;
	Repaint;
end;

procedure TvGleisplan.PutSpoor;
var
	hokje: TvHokje;
begin
	Empty(x, y);
	hokje := hokjes^[y*(imaxx+1)+x];
	hokje.Soort := 1;
	new(PvHokjeSpoor(Hokje.grdata));
	PvHokjeSpoor(Hokje.grdata)^.GrX := grx;
	PvHokjeSpoor(Hokje.grdata)^.GrY := gry;
	PvHokjeSpoor(Hokje.grdata)^.Meetpunt := Meetpunt;
	PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg := false;
	PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg := 0;
	PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein := nil;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutTreinnummer;
var
	xx: integer;
begin
	for xx := 1 to maxlen do begin
		PutTreinnummerX(x+xx-1, y, meetpunt, xx, maxlen);
	end;
end;

procedure TvGleisplan.PutTreinnummerX;
var
	hokje: TvHokje;
begin
	hokje := hokjes^[y*(imaxx+1)+x];
	if not assigned(hokje.dyndata) then
		new(Hokje.DynData);
	Hokje.DynData^.Meetpunt := Meetpunt;
	Hokje.DynData^.TekstIndex := index;
	Hokje.DynData^.MaxTextIndex := maxlen;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutSein;
var
	hokje: TvHokje;
begin
	Empty(x, y);
	hokje := hokjes^[y*(imaxx+1)+x];
	hokje.Soort := 3;
	new(PvHokjeSein(Hokje.grdata));
	PvHokjeSein(Hokje.grdata)^.GrX := grx;
	PvHokjeSein(Hokje.grdata)^.GrY := gry;
	PvHokjeSein(Hokje.grdata)^.Sein := Sein;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutSeinDriehoekje;
var
	hokje: TvHokje;
begin
	hokje := hokjes^[y*(imaxx+1)+x];
	if hokje.soort <> 1 then exit;
	PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein := Sein;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutErlaubnis;
var
	hokje: TvHokje;
begin
	Empty(x, y);
	hokje := hokjes^[y*(imaxx+1)+x];
	hokje.Soort := 6;
	new(PvHokjeErlaubnis(Hokje.grdata));
	PvHokjeErlaubnis(Hokje.grdata)^.GrX := grx;
	PvHokjeErlaubnis(Hokje.grdata)^.GrY := gry;
	PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis := Erlaubnis;
	PvHokjeErlaubnis(Hokje.grdata)^.ActiefStand := ActiefStand;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutWissel;
var
	hokje: TvHokje;
begin
	Empty(x, y);
	hokje := hokjes^[y*(imaxx+1)+x];
	hokje.Soort := 5;
	new(PvHokjeWissel(Hokje.grdata));
	PvHokjeWissel(Hokje.grdata)^.GrX := grx;
	PvHokjeWissel(Hokje.grdata)^.GrY := gry;
	PvHokjeWissel(Hokje.grdata)^.Meetpunt := meetpunt;
	PvHokjeWissel(Hokje.grdata)^.Wissel := wissel;
	PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg := false;
	PvHokjeWissel(Hokje.grdata)^.SchuinIsRecht := schuinisrecht;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.PutLandschap;
var
	hokje: TvHokje;
begin
	Empty(x, y);
	hokje := hokjes^[y*(imaxx+1)+x];
	hokje.Soort := 4;
	new(PvHokjeLS(Hokje.grdata));
	PvHokjeLS(Hokje.grdata)^.GrX := grx;
	PvHokjeLS(Hokje.grdata)^.GrY := gry;
	hokjes^[y*(imaxx+1)+x] := hokje;
end;

procedure TvGleisplan.MeetpuntResetInactief;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 1 then
				if PvHokjeSpoor(Hokje.grdata)^.Meetpunt = Meetpunt then
					PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg := false;
			if Hokje.Soort = 5 then
				if PvHokjeWissel(Hokje.grdata)^.Meetpunt = Meetpunt then
					PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg := false;
		end;
end;

procedure TvGleisplan.MeetpuntResetKruis;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 1 then
				if PvHokjeSpoor(Hokje.grdata)^.Meetpunt = Meetpunt then
					PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg := 0;
		end;
end;

procedure TvGleisplan.PaintMeetpunt;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 1 then
				if PvHokjeSpoor(Hokje.grdata)^.Meetpunt = Meetpunt then
					PaintHokje(x,y);
			if Hokje.Soort = 5 then
				if PvHokjeWissel(Hokje.grdata)^.Meetpunt = Meetpunt then
					PaintHokje(x,y);
			if assigned(Hokje.dyndata) then
				if Hokje.DynData.Meetpunt = Meetpunt then
					PaintHokje(x,y);
		end;
end;

procedure TvGleisplan.PaintWissel;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 5 then
				if PvHokjeWissel(Hokje.grdata)^.Wissel = Wissel then
					PaintHokje(x,y);
		end;
end;

procedure TvGleisplan.PaintWisselGroep;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 5 then
				if PvHokjeWissel(Hokje.grdata)^.Wissel^.Groep = Groep then
					PaintHokje(x,y);
		end;
end;

procedure TvGleisplan.PaintSein;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 3 then
				if PvHokjeSein(Hokje.grdata)^.Sein = Sein then
					PaintHokje(x,y);
			if Hokje.Soort = 1 then
				if PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein = Sein then
					PaintHokje(x,y);
		end;
end;

procedure TvGleisplan.PaintErlaubnis;
var
	x,y: integer;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 6 then
				if PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis = Erlaubnis then
					PaintHokje(x,y);
		end;
end;

function TvGleisplan.GetHokje;
begin
	result := Hokjes^[y*(imaxx+1)+x];
end;

procedure TvGleisplan.WatHier;
begin
	x := mx div 8;
	y := my div 16;
	Hokje := Hokjes^[y*(imaxx+1)+x];
end;

procedure TvGleisplan.SavePlan;
var
	x, y: integer;
	Hokje: TvHokje;
	wat: char;
	grx, gry: integer;
	meetpuntnaam: string;
	letter: char;
	kleur: byte;
	spoornummer: string;
	seinwisselnr: boolean;
	seinnaam: string;
	wisselnaam: string;
	erlaubnisnaam: string;
	positie: byte;
	maxlen: byte;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
	case hokje.soort of
//		0: 			// LEEG
		1: begin    // SPOOR
			wat := 'r';
			grx := PvHokjeSpoor(hokje.grdata)^.GrX;
			gry := PvHokjeSpoor(hokje.grdata)^.Gry;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, grx, sizeof(grx));
			blockwrite(f, gry, sizeof(gry));
			if assigned(PvHokjeSpoor(hokje.grdata)^.Meetpunt) then
				meetpuntnaam := PvHokjeSpoor(hokje.grdata)^.Meetpunt.meetpuntID
			else
				meetpuntnaam := '';
			stringwrite(f, meetpuntnaam);
			if assigned(PvHokjeSpoor(hokje.grdata)^.DriehoekjeSein) then
				seinnaam := PvHokjeSpoor(hokje.grdata)^.DriehoekjeSein^.Naam
			else
				seinnaam := '';
			stringwrite(f, seinnaam);
		end;
		2: begin		// TEKST
			wat := 't';
			if length(PvHokjeLetter(hokje.grdata)^.Letter)=0 then halt; // bork
			letter := PvHokjeLetter(hokje.grdata)^.Letter[1];
			kleur := PvHokjeLetter(hokje.grdata)^.Kleur;
			spoornummer := PvHokjeLetter(hokje.grdata)^.Spoornummer;
			seinwisselnr := PvHokjeLetter(hokje.grdata)^.SeinWisselNr;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, letter, sizeof(letter));
			blockwrite(f, kleur, sizeof(kleur));
			stringwrite(f, spoornummer);
			boolwrite(f, seinwisselnr);
		end;
		3: begin		// SEIN
			wat := 's';
			grx := PvHokjeSein(hokje.grdata)^.GrX;
			gry := PvHokjeSein(hokje.grdata)^.Gry;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, grx, sizeof(grx));
			blockwrite(f, gry, sizeof(gry));
			if assigned(PvHokjeSein(hokje.grdata)^.Sein) then
				seinnaam := PvHokjeSein(hokje.grdata)^.Sein^.Naam
			else
				seinnaam := '';
			stringwrite(f, seinnaam);
		end;
		4: begin		// LANDSCHAP
			wat := 'l';
			grx := PvHokjeLS(hokje.grdata)^.GrX;
			gry := PvHokjeLS(hokje.grdata)^.Gry;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, grx, sizeof(grx));
			blockwrite(f, gry, sizeof(gry));
		end;
		5: begin		// WISSEL
			wat := 'w';
			grx := PvHokjeWissel(hokje.grdata)^.GrX;
			gry := PvHokjeWissel(hokje.grdata)^.Gry;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, grx, sizeof(grx));
			blockwrite(f, gry, sizeof(gry));
			boolwrite(f, PvHokjeWissel(hokje.grdata)^.SchuinIsRecht);
			if not assigned(PvHokjeWissel(hokje.grdata)^.Wissel) then halt; // bork
			if not assigned(PvHokjeWissel(hokje.grdata)^.Meetpunt) then halt; // bork
			wisselnaam := PvHokjeWissel(hokje.grdata)^.Wissel^.WisselID;
			meetpuntnaam := PvHokjeWissel(hokje.grdata)^.Meetpunt^.meetpuntID;
			stringwrite(f, meetpuntnaam);
			stringwrite(f, wisselnaam);
		end;
		6: begin		// RIJRICHTINGSVELD
			wat := 'e';
			grx := PvHokjeErlaubnis(hokje.grdata)^.GrX;
			gry := PvHokjeErlaubnis(hokje.grdata)^.Gry;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			blockwrite(f, grx, sizeof(grx));
			blockwrite(f, gry, sizeof(gry));
			if not assigned(PvHokjeErlaubnis(hokje.grdata)^.Erlaubnis) then halt; // bork
			Erlaubnisnaam := PvHokjeErlaubnis(hokje.grdata)^.Erlaubnis^.erlaubnisID;
			positie := PvHokjeErlaubnis(hokje.grdata)^.ActiefStand;
			stringwrite(f, Erlaubnisnaam);
			bytewrite(f,positie);
		end;
		end;
		if assigned(Hokje.dyndata) then begin
			wat := 'd';
			positie := Hokje.Dyndata.TekstIndex;
			maxlen := Hokje.Dyndata.MaxTextIndex;
			meetpuntnaam := Hokje.DynData.Meetpunt^.meetpuntID;
			blockwrite(f, wat, sizeof(wat));
			blockwrite(f, x, sizeof(x));
			blockwrite(f, y, sizeof(y));
			stringwrite(f, meetpuntnaam);
			blockwrite(f, positie, sizeof(positie));
			blockwrite(f, maxlen, sizeof(maxlen));
		end;
	end;
	wat := 'p';
	blockwrite(f, wat, sizeof(wat));
end;

procedure TvGleisplan.LoadPlan;
var
	x, y: integer;
	wat: char;
	grx, gry: integer;
	meetpuntnaam: string;
	letter: char;
	kleur: byte;
	spoornummer: string;
	seinwisselnr: boolean;
	seinnaam: string;
	wisselnaam: string;
	erlaubnisnaam: string;
	positie: byte;
	maxlen: byte;
	klaar: boolean;
	schuinisrecht: boolean;
begin
	klaar := false;
	while not klaar do begin
		blockread(f, wat, sizeof(wat));
		case wat of
//			'n': 			// LEEG
			'r': begin    // SPOOR
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, grx, sizeof(grx));
				blockread(f, gry, sizeof(gry));
				stringread(f, meetpuntnaam);
				if meetpuntnaam <> '' then
					PutSpoor(x, y, grx, gry, ZoekMeetpunt(Core, Meetpuntnaam))
				else
					PutSpoor(x, y, grx, gry, nil);
				stringread(f, seinnaam);
				if seinnaam <> '' then
					PutSeinDriehoekje(x, y, ZoekSein(Core, Seinnaam));
			end;
			't': begin		// TEKST
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, letter, sizeof(letter));
				blockread(f, kleur, sizeof(kleur));
				stringread(f, spoornummer);
				boolread(f, seinwisselnr);
				PutText(x, y, letter, kleur, spoornummer, seinwisselnr);
			end;
			'e': begin		// RIJRICHTINGSVELD
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, grx, sizeof(grx));
				blockread(f, gry, sizeof(gry));
				stringread(f, erlaubnisnaam);
				byteread(f, positie);
				PutErlaubnis(x, y, grx, gry, ZoekErlaubnis(Core, erlaubnisnaam), positie);
			end;
			's': begin		// SEIN
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, grx, sizeof(grx));
				blockread(f, gry, sizeof(gry));
				stringread(f, seinnaam);
				if seinnaam <> '' then
					PutSein(x, y, grx, gry, ZoekSein(Core, seinnaam))
				else
					PutSein(x, y, grx, gry, nil);
			end;
			'l': begin		// LANDSCHAP
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, grx, sizeof(grx));
				blockread(f, gry, sizeof(gry));
				PutLandschap(x, y, grx, gry);
			end;
			'w': begin		// WISSEL
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				blockread(f, grx, sizeof(grx));
				blockread(f, gry, sizeof(gry));
				boolread(f, schuinisrecht);
				stringread(f, meetpuntnaam);
				stringread(f, wisselnaam);
				PutWissel(x,y,grx,gry,ZoekMeetpunt(core, meetpuntnaam), ZoekWissel(Core,Wisselnaam), schuinisrecht);
			end;
			'd': begin		// DYNDATA
				blockread(f, x, sizeof(x));
				blockread(f, y, sizeof(y));
				stringread(f, meetpuntnaam);
				blockread(f, positie, sizeof(positie));
				blockread(f, maxlen, sizeof(maxlen));
				PutTreinnummerX(x, y, ZoekMeetpunt(core, meetpuntnaam), positie, maxlen);
			end;
			'p': klaar := true;
		end;
	end;
end;

procedure TvGleisplan.SaveInactieveEnKruisingHokjes;
var
	x,y: integer;
	wat: char;
	Hokje: TvHokje;
begin
	for x := 0 to imaxx do
		for y := 0 to imaxy do begin
			Hokje := Hokjes^[y*(imaxx+1)+x];
			if Hokje.Soort = 1 then begin
				if PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg then begin
					wat := 'i';
					blockwrite(f, wat, sizeof(wat));
					intwrite(f, x);
					intwrite(f, y);
				end;
				if PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg <> 0 then begin
					wat := 'k';
					blockwrite(f, wat, sizeof(wat));
					intwrite(f, x);
					intwrite(f, y);
					bytewrite(f, PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg);
				end;
			end;
			if Hokje.Soort = 5 then begin
				if PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg then begin
					wat := 'i';
					blockwrite(f, wat, sizeof(wat));
					intwrite(f, x);
					intwrite(f, y);
				end;
			end;
		end;
	wat := 'p';
	blockwrite(f, wat, sizeof(wat));
end;

procedure TvGleisplan.LoadInactieveEnKruisingHokjes;
var
	wat: char;
	x, y: integer;
	Hokje: TvHokje;
begin
	repeat
		blockread(f, wat, sizeof(wat));
		if wat = 'p' then break;
		intread(f, x);
		intread(f, y);
		Hokje := Hokjes^[y*(imaxx+1)+x];
		if Hokje.Soort = 1 then begin
			if wat = 'i' then
				PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg := true;
			if wat = 'k' then
				byteread(f, PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg);
		end;
		if Hokje.Soort = 5 then begin
			if wat = 'i' then
				PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg := true;
		end;
      PaintHokje(x,y);
	until wat = 'p';
end;

procedure Register;
begin
	RegisterComponents('Samples', [TvGleisplan]);
end;

end.
