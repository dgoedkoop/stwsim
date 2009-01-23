unit stwsimClientMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ActnList, Buttons, 
  stwvMeetpunt, clientReadMsg, clientSendMsg, stwvCore,
  stwvGleisplan, stwvHokjes, stwvSporen, stwpTijd, stwvRijwegen, stwvSeinen,
  stwvMisc, stwvRijveiligheid, stwvRijwegLogica, stwvLog,
  stwvProcesPlan, stwsimComm, stwpCore, serverSendMsg, serverReadMsg,
  stwpTreinen;

type
	TUpdateChg = record
		Rijweg: boolean;
		Schermaantal: boolean;
		Schermen: boolean;
		Vannaar: boolean;
		Berichten: boolean;
		Menus: boolean;
	end;

  TstwsimMainForm = class(TForm)
    MainMenu: TMainMenu;
    BedienPanel: TPanel;
	 TijdTimer: TTimer;
    BlinkTimer: TTimer;
	 SpoorPopup: TPopupMenu;
	 Actions: TActionList;
	 Openen: TAction;
	 Afsluiten: TAction;
    TreinInterpose: TAction;
	 TreinBericht: TAction;
	 WisselSwitch: TAction;
    WisselBedienVerh: TAction;
	 WisselRijwegVerh: TAction;
    Berichtnaartreinsturen1: TMenuItem;
    Treinnummerwijzigen1: TMenuItem;
    N1: TMenuItem;
	 Wisselomzetten1: TMenuItem;
    Verhinderbedieningwissel1: TMenuItem;
	 Verhinderrijwegoverwissel1: TMenuItem;
	 Bestand1: TMenuItem;
	 Help1: TMenuItem;
    Openen1: TMenuItem;
    Afsluiten1: TMenuItem;
	 SchermenTab: TTabControl;
	 OpenDialog: TOpenDialog;
	 Info1: TMenuItem;
	 msgMemo: TMemo;
	 TreinStatus: TAction;
	 Treinstatus1: TMenuItem;
	 statPanel: TPanel;
	 RijwegHo: TAction;
    RijwegNormaal: TAction;
	 RijwegROZ: TAction;
    RijwegAuto: TAction;
	 RijwegCancel: TAction;
	 NNormalerijweg1: TMenuItem;
    Rijweg1: TMenuItem;
    ROZRijwegnaarbezetspoor1: TMenuItem;
    ARijwegmetautomatischeseinen1: TMenuItem;
    HRijwegherroepen1: TMenuItem;
	 NieuwBericht: TAction;
    Broadcast: TAction;
    Hulpmiddelen1: TMenuItem;
    vannaarPanel: TPanel;
    vanVeld: TLabel;
    naarVeld: TLabel;
    Splitter1: TSplitter;
    tijdLabel: TLabel;
	 Button1: TButton;
    Button2: TButton;
    LaatProcesplanZien: TAction;
    N2: TMenuItem;
    LaatProcesplanZien1: TMenuItem;
    GetScore: TAction;
	 Prestaties1: TMenuItem;
    fullscreenAction: TAction;
    DienstOpen: TAction;
    Dienstregelingopenen1: TMenuItem;
    DienstSave: TAction;
    DienstSaveDialog: TSaveDialog;
    DienstOpenDialog: TOpenDialog;
    Dienstregelingopslaan1: TMenuItem;
    StartAction: TAction;
    Starten1: TMenuItem;
    DoorspoelAction: TAction;
    Bestand2: TMenuItem;
    ToonToolsAction: TAction;
    ToolsPanel: TPanel;
    telBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    SpeedTrack: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    Hulpmiddelentonen1: TMenuItem;
    DienstEdit: TAction;
    Dienstregelingbewerken1: TMenuItem;
    DoorspoelBut: TButton;
	 procedure FormCreate(Sender: TObject);
	 procedure TijdTimerTimer(Sender: TObject);
	 procedure OpenenExecute(Sender: TObject);
	 procedure Info1Click(Sender: TObject);
	 procedure BlinkTimerTimer(Sender: TObject);
	 procedure WisselSwitchExecute(Sender: TObject);
    procedure WisselBedienVerhExecute(Sender: TObject);
    procedure WisselRijwegVerhExecute(Sender: TObject);
    procedure TreinInterposeExecute(Sender: TObject);
    procedure AfsluitenExecute(Sender: TObject);
	 procedure TreinStatusExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RijwegHoExecute(Sender: TObject);
    procedure RijwegNormaalExecute(Sender: TObject);
	 procedure RijwegROZExecute(Sender: TObject);
	 procedure RijwegAutoExecute(Sender: TObject);
    procedure RijwegCancelExecute(Sender: TObject);
	 procedure TreinBerichtExecute(Sender: TObject);
	 procedure NieuwBerichtExecute(Sender: TObject);
	 procedure SchermenTabChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
	 procedure BroadcastExecute(Sender: TObject);
	 procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	 procedure LaatProcesplanZienExecute(Sender: TObject);
	 procedure FormDestroy(Sender: TObject);
	 procedure HerkenProcesplanClose;
    procedure GetScoreExecute(Sender: TObject);
    procedure fullscreenActionExecute(Sender: TObject);
    procedure DienstOpenExecute(Sender: TObject);
    procedure DienstSaveExecute(Sender: TObject);
    procedure StartActionExecute(Sender: TObject);
    procedure DoorspoelActionExecute(Sender: TObject);
    procedure ToonToolsActionExecute(Sender: TObject);
    procedure DienstEditExecute(Sender: TObject);
	private
		// Belangrijkste
		pCore:		PpCore;
		vCore:		PvCore;
		SimComm:		TStringComm;
		// Tekenen
		UpdateChg:	TUpdateChg;
		VisibleTab: PTabList;
		// Event handlers voor binnenkomende berichten
		pReadMsg:	TpReadMsg;
		pSendMsg:	TpSendMsg;
		vReadMsg:	TvReadMsg;
		vSendMsg:	TvSendMsg;
		// Dingen
		Log:				TLog;
		RijwegLogica:	TRijwegLogica;
		// Bediening
		gselx, gsely:integer;
		selHokje:	 TvHokje;
		selMeetpunt: PvMeetpunt;
		selWissel:	 PvWissel;
		selSein:		 PvSein;
		selVan,
		selNaar:		 string;
		// Telefoon
		rinkelsound: THandle;
		rinkelstapjes: integer;
		// Sim-bediening
		pauze: 	boolean;
		gestart:	boolean;
	public
		// Beginnen
		procedure LoadInfra(var f: file);
		procedure LoadFile(filename: string);
		procedure AddScherm(ID: integer; titel: string; showdetails: boolean);
		function GetScherm(ID: Integer): PTabList;
		// Tekenen
		procedure UpdateControls;
		procedure SetSeltabVisible;
		procedure LogMsg(s: string);
		// Event handlers voor binnenkomende berichten
		procedure ChangeMeetpunt(Meetpunt: PvMeetpunt; Oudebezet: boolean; Oudetreinnr: string);
		procedure ChangeWissel(Wissel: PvWissel);
		procedure ChangeSein(Sein: PvSein);
		procedure ChangeErlaubnis(Erlaubnis: PvErlaubnis);
		procedure ChangeOverweg(Overweg: PvOverweg);
		procedure smsg(tekst: string);
		procedure OntvangDefectSein(Sein: PvSein; defectSeinbeeld: TSeinbeeld);
		procedure OntvangTreinBericht(treinnr, tekst: string);
		procedure Tijd(u,m,s: integer);
		procedure Score;
		// Bediening
		procedure GleisplanMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure GleisplanClick(Sender: TObject);
	end;

var
  stwsimMainForm: TstwsimMainForm;

implementation

uses stwsimClientInfo, stwsimClientConnect, stwsimClientInterpose,
  stwsimclientTreinMsg, stwsimclientBericht, clientProcesplanForm,
  stwsimclientScore, stwsimclientTreinStatus, stwsimServerDienstreg;

{$R *.DFM}

{$R clientRes.res}

const
	MagicCode = 'StwSim Client Beta 6';

procedure TstwsimMainForm.LoadInfra;
var
	i: integer;
	aantal: integer;
	s: string;
begin
	intread(f, aantal);
	for i := 1 to aantal do begin
		stringread(f, s);
		case i of
			1: pCore.simnaam := s;
			2: pCore.simversie := s;
		else
			pCore.LoadRailString(s);
		end;
	end;
end;

procedure TstwsimMainForm.LoadFile;
var
	f: file;
	magic, schermnaam: string;
	schermID: integer;
	schermdetails: boolean;
begin
	assignfile(f, Filename);
	reset(f, 1);
	stringread(f, magic);
	if magic <> magicCode then begin
		Application.MessageBox('Dit is geen geldig bestand.', 'Fout', MB_ICONERROR);
		exit;
	end;

	LoadInfra(f);

	LoadThings(vCore, f);

	repeat
		intread(f, schermID);
		if schermID > 0 then begin
			stringread(f, schermnaam);
			boolread(f, schermdetails);
			AddScherm(schermID, Schermnaam, Schermdetails);
			GetScherm(schermID).Gleisplan.LoadPlan(f);
		end;
	until schermID = 0;

	CloseFile(f);

	BerekenAankondigingen(vCore);

	UpdateChg.Schermaantal := true;
	UpdateChg.Schermen := true;
	UpdateChg.Rijweg := true;
	UpdateChg.Vannaar := false;
	UpdateChg.Menus := false;
	UpdateControls;

	Openen.Enabled := false;
	DienstOpen.Enabled := true;
	DienstSave.Enabled := true;
	DienstEdit.Enabled := true;
end;

procedure TstwsimMainForm.OpenenExecute(Sender: TObject);
begin
	if OpenDialog.Execute then
		LoadFile(OpenDialog.Filename);
end;

procedure TstwsimMainForm.AddScherm;
var
	Tab, l: PTabList;
begin
	new(Tab);
	Tab^.Titel := Titel;
	Tab^.ID := ID;
	Tab^.Scrollbox := TScrollBox.Create(Self);
	Tab^.Scrollbox.Parent := stwscMainForm;
	Tab^.Scrollbox.HorzScrollBar.Tracking := true;
	Tab^.Scrollbox.VertScrollBar.Tracking := true;
	Tab^.Scrollbox.BorderStyle := bsNone;
	Tab^.Scrollbox.Align := alClient;
	Tab^.Scrollbox.Color := clBlack;
	Tab^.Scrollbox.Visible := false;
	Tab^.Gleisplan := TvGleisplan.Create(Self);
	Tab^.Gleisplan.Parent := Tab^.Scrollbox;
	Tab^.Gleisplan.PopupMenu := SpoorPopup;
	Tab^.Gleisplan.OnMouseDown := GleisplanMouseDown;
//	Tab^.Gleisplan.OnMouseMove := GleisplanMouseMove;
	Tab^.Gleisplan.OnClick := GleisplanClick;
	Tab^.Gleisplan.OnDblClick := GleisplanClick;
	Tab^.Gleisplan.Top := 0;
	Tab^.Gleisplan.Left := 0;
	Tab^.Gleisplan.MaxX := 125;
	Tab^.Gleisplan.MaxY := 36;
	Tab^.Gleisplan.Core := vCore;
	Tab^.Gleisplan.ShowPointPositions := ShowDetails;
	Tab^.Gleisplan.ShowSeinen := ShowDetails;
	Tab^.Gleisplan.ShowSeinWisselNummers := ShowDetails;
	Tab^.Gleisplan.ShowInactieveRichtingen := false;
	Tab^.Gleisplan.Visible := true;
	Tab^.Volgende := nil;
	l := RijwegLogica.Tabs;
	if not assigned(l) then
		RijwegLogica.Tabs := Tab
	else begin
		while assigned(l^.volgende) do
			l := l^.volgende;
		l^.volgende := Tab;
	end;
end;

function TstwsimMainForm.GetScherm;
var
	l: PTabList;
begin
	result := nil;
	l := RijwegLogica.Tabs;
	while assigned(l) do begin
		if l^.ID = ID then begin
			result := l;
			exit;
		end;
		l := l^.Volgende;
	end;
end;

procedure TstwsimMainForm.UpdateControls;
var
	Tab:			PTablist;
	i: 			integer;
begin
	if UpdateChg.Schermaantal then begin
		Openen.Enabled := false;
		i := 0;
		Tab := RijwegLogica.Tabs;
		while assigned(Tab) do begin
			if SchermenTab.Tabs.Count-1 >= i then
				SchermenTab.Tabs[i] := Tab^.Titel
			else
				SchermenTab.Tabs.Add(Tab^.Titel);
			Tab := Tab.Volgende;
			i := i + 1;
		end;
		while SchermenTab.Tabs.Count-1 >= i do
			SchermenTab.Tabs.Delete(SchermenTab.Tabs.Count-1);

		SetSeltabVisible;

		UpdateChg.Schermaantal := false;
	end;
	if UpdateChg.Schermen then begin
		Tab := RijwegLogica.Tabs;
		while assigned(Tab) do begin
			Tab^.Gleisplan.LaatAlleTreinnrPosZien := false;
			Tab^.Gleisplan.Repaint;
			Tab := Tab.Volgende;
		end;
		UpdateChg.Schermen := false;
	end;
	if UpdateChg.Vannaar then begin
		vanVeld.Caption := KlikpuntTekst(selVan, false);
		naarVeld.Caption := KlikpuntTekst(selNaar, false);
		RijwegNormaal.Enabled := (selVan<>'') and (selNaar<>'');
		RijwegROZ.Enabled := (selVan<>'') and (selNaar<>'');
		RijwegAuto.Enabled := (selVan<>'') and (selNaar<>'');
		RijwegHo.Enabled := (selVan<>'') or (selNaar<>'');
		RijwegCancel.Enabled := (selVan<>'');
		UpdateChg.Vannaar := false;
	end;
	if UpdateChg.Menus then begin
		if assigned(selMeetpunt) then begin
			TreinStatus.Enabled := selMeetpunt^.treinnummer <> '';
			TreinInterpose.Enabled := true;
			TreinBericht.Enabled := selMeetpunt^.treinnummer <> '';
		end else begin
			TreinStatus.Enabled := false;
			TreinInterpose.Enabled := false;
			TreinBericht.Enabled := false;
		end;
		if assigned(selWissel) then begin
			WisselSwitch.Enabled := WisselKanOmgezet(selWissel, true);
			WisselBedienVerh.Enabled := true;
			WisselBedienVerh.Checked := selWissel^.Groep^.bedienverh;
			WisselRijwegVerh.Enabled := true;
			WisselRijwegVerh.Checked := selWissel^.rijwegverh;
		end else begin
			WisselSwitch.Enabled := false;
			WisselBedienVerh.Enabled := false;
			WisselBedienVerh.Checked := false;
			WisselRijwegVerh.Enabled := false;
			WisselRijwegVerh.Checked := false;
		end;
		UpdateChg.Menus := false;
	end;
	if UpdateChg.Berichten then begin
		NieuwBericht.Enabled := assigned(vCore.vAlleBerichten);
		UpdateChg.Berichten := false;
	end;
end;

procedure tstwsimMainForm.SetSeltabVisible;
var
	Tab:			PTablist;
	sel: 			string;
begin
	sel := SchermenTab.Tabs[SchermenTab.TabIndex];
	Tab := RijwegLogica.Tabs;
	while assigned(Tab) do begin
		Tab^.Scrollbox.Visible := (Tab^.Titel = sel);
		if Tab^.Scrollbox.Visible then
			visibleTab := Tab;
		Tab := Tab^.Volgende;
	end;
end;

procedure tstwsimMainForm.LogMsg;
begin
	// Haal overvloedige regels weg.
	if msgMemo.Lines.Count >= 10 then
		msgMemo.Lines.Delete(0);
	// Voeg bericht toe
	msgMemo.Lines.Add(TijdStr(GetTijd, false)+'  '+s);
	// Haal laatste lege regel weg
	if copy(msgMemo.Text, length(msgMemo.Text)-1, 2) = #13#10 then
		msgMemo.Text := copy(msgMemo.Text, 1, length(msgMemo.Text)-2);
end;

procedure TstwsimMainForm.FormCreate(Sender: TObject);
begin
	vReadMsg := TvReadMsg.Create;
	vSendMsg := TvSendMsg.Create;
	new(vCore);
	vCore^.vAlleWisselGroepen := nil;
	vCore^.vAlleMeetpunten := nil;
	vCore^.vAlleSeinen := nil;
	vCore^.vAlleRijwegen := nil;
	vCore^.vAllePrlRijwegen := nil;
	vCore^.vAlleErlaubnisse := nil;
	vCore^.vActieveRijwegen := nil;
	vCore^.vAlleBerichten := nil;
	vCore^.vAlleOverwegen := nil;
	vReadMsg.SendMsg := vSendMsg;
	vReadMsg.Core := vCore;

	new(pCore);
	pCore^ := TpCore.Create;

	pReadMsg := TpReadMsg.Create;
	pReadMsg.Core := pCore;
	pReadMsg.SendMsg := @pSendMsg;
	pSendMsg := TpSendMsg.Create;
	pCore.SendMsg := @pSendMsg;

	SimComm := TStringComm.Create;
	vSendMsg.SimComm := SimComm;
	pSendMsg.SimComm := SimComm;
	SimComm.ReceiveEventClient := vReadMsg.ReadMsg;
	SimComm.ReceiveEventServer := pReadMsg.ReadMsg;

	vReadMsg.ChangeMeetpuntEvent := ChangeMeetpunt;
	vReadMsg.ChangeWisselEvent := ChangeWissel;
	vReadMsg.ChangeSeinEvent := ChangeSein;
	vReadMsg.ChangeRichtingEvent := ChangeErlaubnis;
	vReadMsg.ChangeOverwegEvent := ChangeOverweg;
	vReadMsg.smsgEvent := smsg;
	vReadMsg.mmsgEvent := OntvangTreinBericht;
	vReadMsg.TijdEvent := Tijd;
	vReadMsg.ScoreEvent := Score;
	vReadMsg.DefectSeinEvent := OntvangDefectSein;

	Log := TLog.Create;
	Log.OnLog := LogMsg;

	RijwegLogica := TRijwegLogica.Create;
	RijwegLogica.Core := vCore;
	RijwegLogica.Log := Log;
	RijwegLogica.SendMsg := vSendMsg;

	RinkelStapjes := 0;
	RinkelSound := LoadSound('snd_tele');

	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateChg.Berichten := true;
	UpdateControls;

	gestart := false;
	pauze := false;
end;

procedure TstwsimMainForm.ChangeMeetpunt;
begin
	if (not Meetpunt^.Bezet) and Oudebezet then
		RijwegLogica.MarkeerVrij(Meetpunt);

	if Meetpunt^.Bezet and not Oudebezet then
		RijwegLogica.MarkeerBezet(Meetpunt);

	// Voor het procesplan
	if Meetpunt^.treinnummer <> Oudetreinnr then
		if Meetpunt^.treinnummer <> '' then begin
			RijwegLogica.Aankondigen(Meetpunt);
			stwscProcesplanForm.TreinnummerNieuw(Meetpunt)
		end else
			stwscProcesplanForm.TreinnummerWeg(Meetpunt);

	// Meetpunt tekenen.
	VisibleTab^.Gleisplan.PaintMeetpunt(Meetpunt);

	// En rijwegen herberekenen
	RijwegLogica.DoeActieveRijwegen;
end;

procedure TstwsimMainForm.ChangeWissel;
begin
	if Wissel^.Groep^.CommandsSent > 0 then
		dec(Wissel^.Groep^.CommandsSent);
	Wissel^.CommandSent := false;

	// Rijwegen herberekenen
	RijwegLogica.DoeActieveRijwegen;

	// En wissel tekenen;
	VisibleTab^.Gleisplan.PaintWisselGroep(Wissel^.Groep);
end;

procedure TstwsimMainForm.ChangeSein;
begin
	Sein^.Changed := false;
	VisibleTab^.Gleisplan.PaintSein(Sein);
end;

procedure TstwsimMainForm.ChangeErlaubnis;
begin
	Erlaubnis^.Changed := false;
	VisibleTab^.Gleisplan.PaintErlaubnis(Erlaubnis);
end;

procedure TstwsimMainForm.ChangeOverweg;
begin
	Overweg^.Changed := false;
end;

procedure TstwsimMainForm.smsg;
begin
	if tekst <> '--' then
		stwscTreinStatusForm.Bericht(tekst)
	else
		stwscTreinStatusForm.BerichtEinde;
end;

procedure TstwsimMainForm.OntvangDefectSein;
var
	lampkleur: string;
begin
	lampkleur := '';
	if defectSeinbeeld = sbGroen then
		lampkleur := 'groene';
	if defectSeinbeeld = sbGeel then
		lampkleur := 'gele';
	if lampkleur <> '' then
		LogMsg('Sein '+Sein^.naam+' heeft een defecte '+lampkleur+' lamp.');
end;

procedure TstwsimMainForm.OntvangTreinBericht;
begin
	AddBericht(vCore, treinnr, tekst, GetTijd);
	UpdateChg.Berichten := true;
	UpdateControls;
end;

procedure TstwsimMainForm.Tijd;
begin
	SetTijd(MkTijd(u,m,s));
end;

procedure TstwsimMainForm.Score;
begin
	stwscScoreForm.ScoreInfo := vCore^.vScore;
	stwscScoreForm.UpdateDingen;
	stwscScoreForm.ShowModal;
end;

procedure TstwsimMainForm.TijdTimerTimer(Sender: TObject);

	function mtl(s: string; g: integer): string;
	begin
		result := s;
		while length(result)<g do
			result := '0'+result;
	end;

var
	i: integer;
	VorigeTijd: integer;
begin
	if (not gestart) or pauze then exit;

	VorigeTijd := GetTijd;

	if TijdTimer.Interval <> (1000 div tps) then
		TijdTimer.Interval := 1000 div tps;
	for i := 1 to SpeedTrack.Position do
		pCore.DoeStapje;

	if GetTijd <> VorigeTijd then begin
		tijdLabel.Caption := TijdStr(GetTijd, false);

		RijwegLogica.DoeActieveRijwegen;
		RijwegLogica.DoeOverwegen;

		stwscProcesplanForm.DoeStapje;
		stwscProcesplanForm.UpdateLijst;

{		if (GetTijd mod 2 = 0) and stwscTreinStatusForm.Visible then
			SendMsg.SendTreinMsg(stwscTreinStatusForm.treinnr, 'tsr');}
	end;
end;

procedure TstwsimMainForm.Info1Click(Sender: TObject);
begin
	stwscInfoForm.ShowModal;
end;

procedure TstwsimMainForm.BlinkTimerTimer(Sender: TObject);
var
	Tab: PTabList;
begin
	Tab := RijwegLogica.Tabs;
	while assigned(Tab) do begin
		if Tab^.Scrollbox.Visible then
			Tab^.Gleisplan.KnipperGedoofd := not Tab^.Gleisplan.KnipperGedoofd;
		Tab := Tab^.Volgende;
	end;

	if telBtn.Enabled then begin
		if telBtn.Font.Color = clBlack then
			telBtn.Font.Color := clWhite
		else
			telBtn.Font.Color := clBlack;

		if (rinkelstapjes = 0) and not stwscBerichtForm.Visible then
			PlaySound(rinkelsound);
		inc(rinkelstapjes);
		if rinkelstapjes = 15 then
			rinkelstapjes := 0;
	end else
		rinkelstapjes := 0;
end;

procedure TstwsimMainForm.WisselSwitchExecute(Sender: TObject);
begin
	if assigned(selWissel) then
		if WisselKanOmgezet(selWissel, true) then
			vSendMsg.SendWisselChg(selWissel);
end;

procedure tstwsimMainForm.GleisplanMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
	Gleisplan: ^TvGleisplan;
begin
	Gleisplan := @Sender;
	Gleisplan^.WatHier(x,y, gselx, gsely, selHokje);
	selMeetpunt := nil;
	selWissel := nil;
	selSein := nil;
	case selHokje.Soort of
		1: begin
			selMeetpunt := PvHokjeSpoor(selHokje.grdata)^.Meetpunt;
		end;
		3: begin
			selSein := PvHokjeSein(selHokje.grdata)^.Sein;
		end;
		5: begin
			selWissel := PvHokjeWissel(selHokje.grdata)^.Wissel;
			selMeetpunt := PvHokjeWissel(selHokje.grdata)^.Meetpunt;
		end;
	end;
	UpdateChg.Menus := true;
	UpdateControls;
end;

procedure tstwsimMainForm.GleisplanClick(Sender: TObject);
begin
	case selHokje.Soort of
		1: begin
			if assigned(selMeetpunt) then
				if selMeetpunt^.treinnummer <> '' then
               TreinStatus.Execute;
		end;
		2: begin
			if PvHokjeLetter(selHokje.grdata)^.Spoornummer <> '' then begin
				if selVan = '' then
					selVan := MaakKlikpunt(selHokje)
				else if selNaar = '' then
					selNaar := MaakKlikpunt(selHokje);
				UpdateChg.Vannaar := true;
				UpdateControls;
			end;
		end;
		3: begin
			if selVan = '' then
				selVan := MaakKlikpunt(selHokje)
			else if selNaar = '' then
				selNaar := MaakKlikpunt(selHokje);
			UpdateChg.Vannaar := true;
			UpdateControls;
		end;
	end;
end;

procedure TstwsimMainForm.WisselBedienVerhExecute(Sender: TObject);
begin
	if assigned(selWissel) then begin
		selWissel^.Groep^.bedienverh := not selWissel^.Groep^.bedienverh;
		UpdateChg.Menus := true;
		UpdateControls;
	end;
end;

procedure TstwsimMainForm.WisselRijwegVerhExecute(Sender: TObject);
begin
	if assigned(selWissel) then begin
		selWissel^.rijwegverh := not selWissel^.rijwegverh;
		UpdateChg.Menus := true;
		UpdateControls;
	end;
end;

procedure TstwsimMainForm.TreinInterposeExecute(Sender: TObject);
begin
	if assigned(selMeetpunt) then begin
		stwscInterposeForm.treinnrEdit.Text := selMeetpunt^.treinnummer;
		if stwscInterposeForm.showModal = mrOK then
			vSendMsg.SendSetTreinnr(selMeetpunt, stwscInterposeForm.treinnrEdit.Text);
	end;
end;

procedure TstwsimMainForm.AfsluitenExecute(Sender: TObject);
begin
	Close;
end;

procedure TstwsimMainForm.TreinStatusExecute(Sender: TObject);
begin
	if assigned(selMeetpunt) then begin
		stwscTreinStatusForm.Treinnr := selMeetpunt^.treinnummer;
		stwscTreinStatusForm.Wissen;
		vSendMsg.SendTreinMsg(selMeetpunt^.treinnummer, 'tsr');
		stwscTreinStatusForm.ShowModal;
	end;
end;

procedure TstwsimMainForm.FormShow(Sender: TObject);
begin
	stwscProcesPlanForm.Core := vCore;
	stwscProcesPlanForm.SendMsg := vSendMsg;
	stwscProcesPlanForm.Log := Log;
	stwscProcesPlanForm.RijwegLogica := RijwegLogica;
	stwscProcesPlanForm.OnHerkenProcesplanClose := HerkenProcesplanClose;
	stwscProcesplanForm.WindowState := wsMaximized;

	stwscTreinMsgForm.SendMsg := vSendMsg;
	stwscBerichtForm.Core := vCore;

	stwssDienstregForm.Core := pCore^;

	if paramCount = 1 then
		LoadFile(ParamStr(1));
end;

procedure TstwsimMainForm.RijwegHoExecute(Sender: TObject);
begin
	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegNormaalExecute(Sender: TObject);
begin
	RijwegLogica.DoeRijweg(selVan, selNaar, false, false);
	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegROZExecute(Sender: TObject);
begin
	RijwegLogica.DoeRijweg(selVan, selNaar, true, false);
	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegAutoExecute(Sender: TObject);
begin
	RijwegLogica.DoeRijweg(selVan, selNaar, false, true);
	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegCancelExecute(Sender: TObject);
begin
	RijwegLogica.HerroepRijweg(selVan);
	selVan := '';
	selNaar := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.TreinBerichtExecute(Sender: TObject);
begin
	if assigned(selMeetpunt) then
		if selMeetpunt^.treinnummer <> '' then begin
			stwscTreinMsgForm.treinnr := selMeetpunt^.treinnummer;
			stwscTreinMsgForm.ShowModal;
		end;
end;

procedure TstwsimMainForm.NieuwBerichtExecute(Sender: TObject);
begin
	stwscBerichtForm.ShowModal;
	UpdateChg.Berichten := true;
	UpdateControls;
end;

procedure TstwsimMainForm.SchermenTabChange(Sender: TObject);
begin
   SetSeltabVisible;
end;

procedure TstwsimMainForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
	handled := true;
	if WheelDelta < 0 then begin
		 if SchermenTab.TabIndex < SchermenTab.Tabs.Count-1 then
			SchermenTab.TabIndex := SchermenTab.TabIndex + 1;
//		 else
//			SchermenTab.TabIndex := 0;
		 SchermenTabChange(Sender);
	end;
	if WheelDelta > 0 then begin
		 if SchermenTab.TabIndex > 0 then
			SchermenTab.TabIndex := SchermenTab.TabIndex - 1;
//		 else
//			SchermenTab.TabIndex := SchermenTab.Tabs.Count-1;
		 SchermenTabChange(Sender);
	end;
end;

procedure TstwsimMainForm.BroadcastExecute(Sender: TObject);
begin
	vSendMsg.SendBroadcast;
end;

procedure TstwsimMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	CanClose := Application.MessageBox('Weet u zeker dat u StwSim Client wilt afsluiten?',
		'Afsluiten', MB_ICONQUESTION+MB_YESNO) = mrYes;
end;

procedure TstwsimMainForm.LaatProcesplanZienExecute(Sender: TObject);
begin
	LaatProcesplanZien.Checked := not LaatProcesplanZien.Checked;
	stwscProcesplanForm.Visible := LaatProcesplanZien.Checked;
end;

procedure TstwsimMainForm.HerkenProcesplanClose;
begin
	LaatProcesplanZien.Checked := false;
end;

procedure TstwsimMainForm.FormDestroy(Sender: TObject);
var
	Tab, tmpTab: PTablist;
begin
	Tab := RijwegLogica.Tabs;
	while assigned(Tab) do begin
		Tab^.Gleisplan.Destroy;
		Tab^.Scrollbox.Destroy;
		tmpTab := Tab;
		Tab := Tab^.Volgende;
		dispose(tmpTab);
	end;
	dispose(vCore);
	vReadMsg.Destroy;
	vSendMsg.Destroy;
	pCore.Destroy;
	pReadMsg.Destroy;
	pSendMsg.Destroy;
	SimComm.Destroy;
	RijwegLogica.Destroy;
	Log.Destroy;
end;

procedure TstwsimMainForm.GetScoreExecute(Sender: TObject);
begin
   vSendMsg.SendGetScore;
end;

procedure TstwsimMainForm.fullscreenActionExecute(Sender: TObject);
var
	fs: boolean;
begin
	fs := not fullscreenAction.Checked;
	fullscreenAction.Checked := fs;

	SchermenTab.Visible := not fs;
//	BedienPanel.Visible := not fs;
	if fs then
		Menu := nil
	else
		Menu := MainMenu;
	if fs then begin
		BorderStyle := bsNone;
		WindowState := wsMaximized;
	end else begin
		BorderStyle := bsSizeable;
		WindowState := wsMaximized;
	end;
end;

procedure TstwsimMainForm.DienstOpenExecute(Sender: TObject);
var
	f: file;
	s: string;
	i: integer;
	matfilecount: integer;
begin
	if DienstOpenDialog.Execute then begin
		assignfile(f, DienstOpenDialog.Filename);
		{$I-}reset(f, 1);{$I+}
		if ioresult <> 0 then begin
			Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Lees de MAGIC
		stringread(f, s);
		if s <> DienstIOMagic then begin
			Application.Messagebox('Ongeldig bestandstype.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Lees simnaam en simversie
		stringread(f, s);
		if s <> pCore.simnaam then begin
			Application.Messagebox('Dienstregeling niet voor deze simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		stringread(f, s);
		if s <> pCore.simversie then begin
			Application.Messagebox('Dienstregeling niet voor deze versie van de simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Begin- en eindtijd lezen
		intread(f, pCore.starttijd);
		intread(f, pCore.stoptijd);
		// Zo. Nu gaan we beginnen. Eerst materieel inladen.
		intread(f, matfilecount);
		for i := 1 to matfilecount do begin
			stringread(f, s);
			if not pcore.WagonsLaden(s) then begin
				Application.Messagebox(pchar('Wagonbestand "'+s+'" niet gevonden.'), 'Fout', MB_ICONERROR);
				exit;
			end;
		end;
		// Dan de dienstregeling laden
		pCore.LaadDienstEnVerschijn(f);
		closefile(f);
		DienstOpen.Enabled := false;
	end;
end;

procedure TstwsimMainForm.DienstSaveExecute(Sender: TObject);
var
	f: file;
	matfilecount: integer;
	Matfile: PpMaterieelFile;
begin
	if DienstSaveDialog.Execute then begin
		assignfile(f, DienstSaveDialog.Filename);
		{$I-}rewrite(f, 1);{$I+}
		if ioresult <> 0 then begin
			Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Schrijf de MAGIC
		stringwrite(f, DienstIOMagic);
		// Schrijf simnaam en simversie
		stringwrite(f, pCore.simnaam);
		stringwrite(f, pCore.simversie);
		// Begin- en eindtijd schrijven
		intwrite(f, pCore.starttijd);
		intwrite(f, pCore.stoptijd);
		// Zo. Eerst materieel opslaan
		matfilecount := 0;
		Matfile := pCore.pMaterieel;
		while assigned(Matfile) do begin
			inc(matfilecount);
			Matfile := Matfile^.Volgende;
		end;
		intwrite(f, matfilecount);
		Matfile := pCore.pMaterieel;
		while assigned(Matfile) do begin
			stringwrite(f, Matfile^.Filename);
			Matfile := Matfile^.Volgende;
		end;
		// Dan de dienstregeling opslaan
		pCore.SaveDienstEnVerschijn(f);
		closefile(f);
	end;
end;

procedure TstwsimMainForm.StartActionExecute(Sender: TObject);
begin
	// Een en ander initialiseren
	pCore.StartUp;

	// UI updaten.
	DienstOpen.Enabled := false;
	StartAction.Enabled := false;
	DoorspoelAction.Enabled := true;
	gestart := true;
	pauze := false;
end;

procedure TstwsimMainForm.DoorspoelActionExecute(Sender: TObject);
var
	i: integer;
begin
	DoorspoelAction.Enabled := false;
	i := 0;
	while not pCore.TreinenDoenIets do begin
		pCore.DoeStapje;
		inc(i);
		if i = tps * 60 then begin
			Application.ProcessMessages;
			i := 0;
		end;
	end;
	DoorspoelAction.Enabled := true;
end;

procedure TstwsimMainForm.ToonToolsActionExecute(Sender: TObject);
var
	nw: boolean;
begin
	nw := not ToonToolsAction.Checked;
	ToonToolsAction.Checked := nw;
	ToolsPanel.Visible := nw;
	if nw then
		ToolsPanel.BringToFront;
end;

procedure TstwsimMainForm.DienstEditExecute(Sender: TObject);
var
	oudepauze: boolean;
begin
	oudepauze := pauze;
	pauze := true;
	stwssDienstregForm.ShowModal;
	pauze := oudepauze;
end;

end.
