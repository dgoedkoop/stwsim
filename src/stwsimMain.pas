unit stwsimMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ActnList, Buttons,
  stwvMeetpunt, clientReadMsg, clientSendMsg, stwvCore,
  stwvGleisplan, stwvHokjes, stwvSporen, stwpTijd, stwvRijwegen, stwvSeinen,
  stwvMisc, stwvRijveiligheid, stwvRijwegLogica, stwvLog,
  stwvProcesPlan, stwsimComm, stwpCore, serverSendMsg, serverReadMsg,
  stwpTreinen, stwvTreinComm, stwpTreinPhysics, stwpMonteurPhysics,
  stwpCommPhysics;

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
	 SimOpenen: TAction;
	 Afsluiten: TAction;
    TreinInterpose: TAction;
    TreinBellen: TAction;
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
    TelefoonShow: TAction;
    Broadcast: TAction;
    Hulpmiddelen1: TMenuItem;
    Splitter1: TSplitter;
    tijdLabel: TLabel;
	 voerInBut: TButton;
    cancelBut: TButton;
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
    Dienstregelingopslaan1: TMenuItem;
    PauzeAction: TAction;
    Starten1: TMenuItem;
	 DoorspoelAction: TAction;
	 Bestand2: TMenuItem;
    ToonToolsAction: TAction;
    ToolsPanel: TPanel;
    SpeedButton1: TSpeedButton;
	 Label1: TLabel;
	 SpeedTrack: TTrackBar;
    Label2: TLabel;
	 Label3: TLabel;
	 Hulpmiddelentonen1: TMenuItem;
    DienstEdit: TAction;
	 Dienstregelingbewerken1: TMenuItem;
    DoorspoelBut: TButton;
	 PauzePanel: TPanel;
    SimOpenPanel: TPanel;
    SimOpenBut: TBitBtn;
    SimStartPanel: TPanel;
	 BitBtn1: TBitBtn;
    StartMetDienstAction: TAction;
    BitBtn2: TBitBtn;
    EerstDienstBewerkenAction: TAction;
    telBtn: TSpeedButton;
    hsepPanel: TPanel;
    GameOpenDialog: TOpenDialog;
    DienstOpenDialog: TOpenDialog;
    GameSaveDialog: TSaveDialog;
    BitBtn3: TBitBtn;
    SGOpenen: TAction;
	 SGSave: TAction;
    Spelopslaanals1: TMenuItem;
	 Wisselreparatie: TAction;
	 invoerEdit: TEdit;
    RijwegVoerin: TAction;
    ScenOpen: TAction;
    Scenarioopenen1: TMenuItem;
    ScenOpenDialog: TOpenDialog;
	 procedure FormCreate(Sender: TObject);
	 procedure TijdTimerTimer(Sender: TObject);
	 procedure SimOpenenExecute(Sender: TObject);
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
	 procedure TreinBellenExecute(Sender: TObject);
	 procedure TelefoonShowExecute(Sender: TObject);
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
	 procedure PauzeActionExecute(Sender: TObject);
	 procedure DoorspoelActionExecute(Sender: TObject);
	 procedure ToonToolsActionExecute(Sender: TObject);
	 procedure DienstEditExecute(Sender: TObject);
	 procedure FormResize(Sender: TObject);
	 procedure StartMetDienstActionExecute(Sender: TObject);
	 procedure EerstDienstBewerkenActionExecute(Sender: TObject);
	 procedure SGSaveExecute(Sender: TObject);
	 procedure SGOpenenExecute(Sender: TObject);
    procedure invoerEditChange(Sender: TObject);
	 procedure invoerEditEnter(Sender: TObject);
    procedure invoerEditExit(Sender: TObject);
    procedure RijwegVoerinExecute(Sender: TObject);
    procedure ScenOpenExecute(Sender: TObject);
	private
		// Belangrijkste
		pCore:		PpCore;
		vCore:		PvCore;
		SimComm:		TStringComm;
		// Berekeningen
		TreinPhysics:	TpTreinPhysics;
		MonteurPhysics:TpMonteurPhysics;
		CommPhysics:	TpCommPhysics;
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
		Scenario:		TStringList;
		Scenario_leesfout: string;
		ScenarioToegepast: boolean;
		// Bediening
		gselx, gsely:integer;
		selHokje:	 TvHokje;
		selMeetpunt: PvMeetpunt;
		selWissel:	 PvWissel;
		selSein:		 PvSein;
		// Telefoon
		rinkelen: boolean;
		rinkelsound: THandle;
		rinkelstapjes: integer;
		// Sim-bediening
		pauze: 	boolean;
		gestart:	boolean;
		closewarn:boolean;
		// Intern
		FormShown: boolean;
		TimeSet: boolean;
	public
		// Beginnen
		procedure LoadInfra(var f: file);
		procedure LoadFile(filename: string);
		procedure AddScherm(ID: integer; titel: string; showdetails: boolean);
		function GetScherm(ID: Integer): PTabList;
		// Scenario
		function vLoadScenarioString(s: string): boolean;
		procedure ScenarioToepassen(vToepassen: boolean);
		// Tekenen
		procedure UpdateControls;
		procedure SetSeltabVisible;
		procedure LogMsg(s: string);
		procedure SetPanelsPos;
		procedure EnableControls;
		// Intern
		function OpenDienstregeling: boolean;
		function OpenGame: boolean;
		function SaveGame: boolean;
		procedure DoeStapje;
		// Event handlers voor binnenkomende berichten
		procedure ChangeMeetpunt(Meetpunt: PvMeetpunt; Oudebezet: boolean; Oudetreinnr: string);
		procedure ChangeWissel(Wissel: PvWissel);
		procedure ChangeSein(Sein: PvSein);
		procedure ChangeErlaubnis(Erlaubnis: PvErlaubnis);
		procedure ChangeOverweg(Overweg: PvOverweg);
		procedure smsg(tekst: string);
		procedure TelefoonGaat(van: TvMessageWie);
		procedure TelefoonOpgenomen(van: TvMessageWie);
		procedure TelefoonMsg(van: TvMessageWie; soort: TvMessageSoort; tekst: string);
		procedure TelefoonOpgehangen(van: TvMessageWie);
		procedure OntvangDefectSein(Sein: PvSein; defectSeinbeeld: TSeinbeeld);
		procedure Tijd(u,m,s: integer);
		procedure Score;
		// Bediening
		procedure GleisplanMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure GleisplanClick(Sender: TObject);
	end;

var
  stwsimMainForm: TstwsimMainForm;

implementation

uses stwsimClientInfo, stwsimClientConnect, clientProcesplanForm,
	stwsimclientScore, stwsimclientTreinStatus, stwsimServerDienstreg,
	stwsimclientTelefoongesprek, stwsimclientTelefoon, stwsimClientStringInput;

{$R *.DFM}

{$R clientRes.res}
{$R xpthemes.res}

const
	MagicCode = 'StwSim Client Beta 8';

procedure TstwsimMainForm.DoeStapje;
begin
	try
		pCore.DoeStapje;
		TreinPhysics.DoeTreinen;
		CommPhysics.DoeGesprekken;
		MonteurPhysics.CheckWacht(pCore.pMonteur);
	except
		on EAccessViolation do begin
			// Zet de simulatie op pauze
			TijdTimer.Enabled := false;
			if not pauze then
				PauzeAction.Execute;
			PauzeAction.Enabled := false;
			// Foutmelding weergeven.
			Application.MessageBox('Er is een interne fout opgetreden. De simulatie kan niet verder gaan.'+#13#10+#13#10+
				'U kunt nog wel proberen de simulatie op te slaan.','Fout',MB_ICONERROR);
		end;
	end;
end;

procedure TstwsimMainForm.EnableControls;
begin
	SGSave.Enabled := true;
	DienstOpen.Enabled := true;
	DienstSave.Enabled := true;
	DienstEdit.Enabled := true;

	GetScore.Enabled := true;
	ToonToolsAction.Enabled := true;
	LaatProcesplanZien.Enabled := true;
	PauzeAction.Enabled := true;
end;

procedure TstwsimMainForm.SetPanelsPos;
	function GetLeft(panelwidth: integer): integer;
	begin
		result := (ClientWidth div 2) - (panelWidth div 2);
	end;
	function GetTop(panelheight: integer): integer;
	begin
		result := ((ClientHeight - BedienPanel.Height) div 2) - (PanelHeight div 2) + BedienPanel.Height;
	end;
begin
	PauzePanel.Left := GetLeft(PauzePanel.Width);
	PauzePanel.Top := GetTop(PauzePanel.Height);
	SimOpenPanel.Left := GetLeft(SimOpenPanel.Width);
	SimOpenPanel.Top := GetTop(SimOpenPanel.Height);
	SimStartPanel.Left := GetLeft(SimStartPanel.Width);
	SimStartPanel.Top := GetTop(SimStartPanel.Height);
end;

procedure TstwsimMainForm.LoadInfra;
var
	i,j: integer;
	aantal: integer;
	s,r: string;
begin
	intread(f, aantal);
	for i := 1 to aantal do begin
		stringread(f, s);
		case i of
			1: pCore.simnaam := s;
			2: pCore.simversie := s;
		else
			if not pCore.LoadRailString(s) then begin
				for j := 1 to length(s) do
					if s[j]=#9 then s[j] := #32;
				str(i,r);
				Application.MessageBox(pchar('Regel: '+r+' ('+s+')'+#13#10+'Fout: '+pCore.Leesfout_melding),'Fout bij laden simulatie', MB_OK+MB_ICONERROR);
				halt;
			end;
		end;
	end;
end;

procedure TstwsimMainForm.LoadFile;
var
	f: file;
	magic, schermnaam: string;
	naam: string;
	schermID: integer;
	schermdetails: boolean;
begin
	pCore.Filedir := ExtractFileDir(ExpandFileName(Filename));

	assignfile(f, Filename);
	Filemode := 0;
	{$I-}reset(f, 1);{$I+}
	if ioresult <> 0 then begin
		Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
		exit;
	end;
	stringread(f, magic);
	if magic <> magicCode then begin
		Application.MessageBox('Dit is geen geldig bestand.', 'Fout', MB_ICONERROR);
		exit;
	end;

	LoadInfra(f);

	naam := pCore.simnaam;
	Caption := naam;
	Application.Title := naam;

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
	BerekenRijwegenNaarSeinen(vCore);

	UpdateChg.Schermaantal := true;
	UpdateChg.Schermen := true;
	UpdateChg.Rijweg := true;
	UpdateChg.Vannaar := false;
	UpdateChg.Menus := false;
	UpdateControls;

	SimOpenen.Enabled := false;
   ScenOpen.Enabled := true;

	SetPanelsPos;
	SimOpenPanel.Visible := false;
	SimStartPanel.Visible := true;
	SimStartPanel.BringToFront;
end;

procedure TstwsimMainForm.SimOpenenExecute(Sender: TObject);
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
	Tab^.Scrollbox.Parent := stwsimMainForm;
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
	Tab^.Gleisplan.OnbekendeWisselsKnipperen := false;
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
		SimOpenen.Enabled := false;
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
		RijwegVoerin.Enabled := (invoerEdit.Text<>'');
		RijwegHo.Enabled := (invoerEdit.Text<>'');
		UpdateChg.Vannaar := false;
	end;
	if UpdateChg.Menus then begin
		TreinStatus.Visible := assigned(selMeetpunt);
		TreinInterpose.Visible := assigned(selMeetpunt);
		TreinBellen.Visible := assigned(selMeetpunt);
		WisselSwitch.Visible := assigned(selWissel);
		WisselBedienVerh.Visible := assigned(selWissel);
		WisselRijwegVerh.Visible := assigned(selWissel);

		if assigned(selMeetpunt) then begin
			TreinStatus.Enabled := selMeetpunt^.treinnummer <> '';
			TreinInterpose.Enabled := true;
			TreinBellen.Enabled := selMeetpunt^.treinnummer <> '';
		end else begin
			TreinStatus.Enabled := false;
			TreinInterpose.Enabled := false;
			TreinBellen.Enabled := false;
		end;
		if assigned(selWissel) then begin
			WisselSwitch.Enabled := WisselKanOmgezet(selWissel, vCore.vFlankbeveiliging);
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
		Rinkelen := assigned(vCore.vAlleBinnenkomendeGesprekken);
		if assigned(stwscTelefoonForm) and stwscTelefoonForm.Visible then
			stwscTelefoonForm.reshow;
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
	vCore_Create(vCore);
	vReadMsg.SendMsg := vSendMsg;
	vReadMsg.Core := vCore;

	new(pCore);
	pCore^ := TpCore.Create;

	CommPhysics := TpCommPhysics.Create(pCore, @pSendMsg);
	TreinPhysics := TpTreinPhysics.Create(pCore, @CommPhysics);
	MonteurPhysics := TpMonteurPhysics.Create(pCore);

	pReadMsg := TpReadMsg.Create;
	pReadMsg.Core := pCore;
	pReadMsg.SendMsg := @pSendMsg;
	pReadMsg.MonteurPhysics := @MonteurPhysics;
	pReadMsg.CommPhysics := @CommPhysics;
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
	vReadMsg.TelefoonBelEvent := TelefoonGaat;
	vReadMsg.TelefoonOpneemEvent := TelefoonOpgenomen;
	vReadMsg.TelefoonMsgEvent := TelefoonMsg;
	vReadMsg.TelefoonOphangEvent := TelefoonOpgehangen;
	vReadMsg.TijdEvent := Tijd;
	vReadMsg.ScoreEvent := Score;
	vReadMsg.DefectSeinEvent := OntvangDefectSein;

	Log := TLog.Create;
	Log.OnLog := LogMsg;

	RijwegLogica := TRijwegLogica.Create;
	RijwegLogica.Core := vCore;
	RijwegLogica.Log := Log;
	RijwegLogica.SendMsg := vSendMsg;

	Scenario := TStringList.Create;
	ScenarioToegepast := false;

	RinkelStapjes := 0;
	RinkelSound := LoadSound('snd_tele');

	UpdateChg.Vannaar := true;
	UpdateChg.Berichten := true;
	UpdateControls;

	FormShown := false;
	TimeSet := false;
	closewarn := false;
	gestart := false;
	pauze := true;
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
	if gestart then
		RijwegLogica.DoeActieveRijwegen;
end;

procedure TstwsimMainForm.ChangeWissel;
begin
	if Wissel^.Wensstand = wsEgal then
		Wissel^.Wensstand := Wissel^.Stand;

	// Berekenen of in de groep een onbekend wisselaanwezig is.
	BerekenOnbekendAanwezig(Wissel^.Groep);

	// Rijwegen herberekenen
	RijwegLogica.WisselOm(Wissel);
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

procedure TstwsimMainForm.TelefoonGaat;
begin
	AddBinnenkomendGesprek(vCore, van);
	UpdateChg.Berichten := true;
	UpdateControls;
end;

procedure TstwsimMainForm.TelefoonOpgenomen;
begin
	if stwscTelefoonGesprekForm.GesprekStatus <> gsOpgehangen then
		stwscTelefoonGesprekForm.GesprekStart;
end;

procedure TstwsimMainForm.TelefoonMsg;
begin
	if stwscTelefoonGesprekForm.GesprekStatus <> gsOpgehangen then
		stwscTelefoonGesprekForm.Bericht(soort, tekst);
end;

procedure TstwsimMainForm.TelefoonOpgehangen;
begin
	if (stwscTelefoonGesprekForm.GesprekStatus <> gsOpgehangen) and
		CmpMessageWie(stwscTelefoonGesprekForm.metwie, van) then
		// Het huidige gesprek is beeindigd
		stwscTelefoonGesprekForm.Opgehangen
	else begin
		// Een gesprek in de wachtrij is beeindigd.
		DeleteBinnenkomendGesprek(vCore, van);
		UpdateChg.Berichten := true;
		UpdateControls;
	end;
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
		DoeStapje;

	if GetTijd <> VorigeTijd then begin
		tijdLabel.Caption := TijdStr(GetTijd, false);

		RijwegLogica.DoeActieveRijwegen;
		RijwegLogica.DoeOverwegen;

		stwscProcesplanForm.DoeStapje;
		stwscProcesplanForm.UpdateLijst;

		if (GetTijd mod 2 = 0) and stwscTreinStatusForm.Visible then
			if vSendMsg.SendGetTreinStatus(stwscTreinStatusForm.treinnr).status <> rsOK then
         	stwscTreinStatusForm.ModalResult := mrOK;
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

	if rinkelen then begin
		if telBtn.Font.Color = clBlack then
			telBtn.Font.Color := clWhite
		else
			telBtn.Font.Color := clBlack;

		if (rinkelstapjes = 0) and not stwscTelefoonForm.Visible then
			PlaySound(rinkelsound);
		inc(rinkelstapjes);
		if rinkelstapjes = 15 then
			rinkelstapjes := 0;
	end else begin
		rinkelstapjes := 0;
		telBtn.Font.Color := clBlack;
	end;
end;

procedure TstwsimMainForm.WisselSwitchExecute(Sender: TObject);
begin
	if assigned(selWissel) then
		RijwegLogica.ZetWisselOm(selWissel);
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
			if (PvHokjeLetter(selHokje.grdata)^.Spoornummer <> '') and not pauze then begin
				if invoerEdit.Text <> '' then
					if invoerEdit.Text[length(invoerEdit.Text)] <> ' ' then
						invoerEdit.Text := invoerEdit.Text + ' ';
				invoerEdit.Text := invoerEdit.Text + PvHokjeLetter(selHokje.grdata)^.Spoornummer;
				invoerEdit.SelStart := length(invoerEdit.Text);
				UpdateChg.Vannaar := true;
				UpdateControls;
			end;
		end;
		3: begin
			if not pauze then begin
				if invoerEdit.Text <> '' then
					if invoerEdit.Text[length(invoerEdit.Text)] <> ' ' then
						invoerEdit.Text := invoerEdit.Text + ' ';
				invoerEdit.Text := invoerEdit.Text + PvHokjeSein(selHokje.grdata)^.Sein^.Naam;
				invoerEdit.SelStart := length(invoerEdit.Text);
				UpdateChg.Vannaar := true;
				UpdateControls;
			end;
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
		stwscStringInputForm.Caption := 'Treinnummer wijzigen';
		stwscStringInputForm.Inputlabel.Caption := 'Nieuw treinnummer:';
		stwscStringInputForm.InputEdit.Text := selMeetpunt^.treinnummer;
		if stwscStringInputForm.showModal = mrOK then
			vSendMsg.SendSetTreinnr(selMeetpunt, stwscStringInputForm.InputEdit.Text);
	end;
end;

procedure TstwsimMainForm.AfsluitenExecute(Sender: TObject);
begin
	Close;
end;

procedure TstwsimMainForm.TreinStatusExecute(Sender: TObject);
var
	resultaat: TvReturned;
begin
	if assigned(selMeetpunt) then begin
		stwscTreinStatusForm.Treinnr := selMeetpunt^.treinnummer;
		stwscTreinStatusForm.Wissen;
		resultaat := vSendMsg.SendGetTreinStatus(selMeetpunt^.treinnummer);
		if resultaat.status = rsOK then
			stwscTreinStatusForm.ShowModal
		else if ((resultaat.status = rsError) and (resultaat.msg = unknowntrainerror+'.')) then
			Application.MessageBox(pchar('Trein '+selMeetpunt^.treinnummer+' is niet bekend.'), 'Fout', 0);
	end;
end;

procedure TstwsimMainForm.FormShow(Sender: TObject);
begin
	if FormShown then exit;
	FormShown := true;
	stwscProcesPlanForm.Core := vCore;
	stwscProcesPlanForm.SendMsg := vSendMsg;
	stwscProcesPlanForm.Log := Log;
	stwscProcesPlanForm.RijwegLogica := RijwegLogica;
	stwscProcesPlanForm.OnHerkenProcesplanClose := HerkenProcesplanClose;
	stwscProcesplanForm.WindowState := wsMaximized;

	stwscTelefoonGesprekForm.SendMsg := vSendMsg;
	stwscTelefoonForm.SendMsg := vSendMsg;
	stwscTelefoonForm.Core := vCore;

	stwssDienstregForm.Core := pCore^;

	SimOpenPanel.Visible := true;
	ActiveControl := SimOpenBut;

	if paramCount = 1 then
		LoadFile(ParamStr(1))
end;

procedure TstwsimMainForm.RijwegHoExecute(Sender: TObject);
begin
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegNormaalExecute(Sender: TObject);
begin
	if invoerEdit.Text = '' then exit;
	if invoerEdit.Text[1] <> ' ' then
		invoerEdit.Text := ' '+invoerEdit.Text;
	invoerEdit.Text := 'n'+invoerEdit.Text;
	RijwegLogica.VoerStringUit(invoerEdit.Text);
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegROZExecute(Sender: TObject);
begin
	if invoerEdit.Text = '' then exit;
	if invoerEdit.Text[1] <> ' ' then
		invoerEdit.Text := ' '+invoerEdit.Text;
	invoerEdit.Text := 'roz'+invoerEdit.Text;
	RijwegLogica.VoerStringUit(invoerEdit.Text);
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegAutoExecute(Sender: TObject);
begin
	if invoerEdit.Text = '' then exit;
	if invoerEdit.Text[1] <> ' ' then
		invoerEdit.Text := ' '+invoerEdit.Text;
	invoerEdit.Text := 'a'+invoerEdit.Text;
	RijwegLogica.VoerStringUit(invoerEdit.Text);
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.RijwegCancelExecute(Sender: TObject);
begin
	if invoerEdit.Text = '' then exit;
	if invoerEdit.Text[1] <> ' ' then
		invoerEdit.Text := ' '+invoerEdit.Text;
	invoerEdit.Text := 'h'+invoerEdit.Text;
	RijwegLogica.VoerStringUit(invoerEdit.Text);
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.TreinBellenExecute(Sender: TObject);
begin
	if assigned(selMeetpunt) then
		if selMeetpunt^.treinnummer <> '' then
			if stwscTelefoongesprekForm.GesprekStatus = gsOpgehangen then begin
				stwscTelefoongesprekForm.metwie.wat := 't';
				stwscTelefoongesprekForm.metwie.ID := selMeetpunt^.treinnummer;
				stwscTelefoongesprekForm.GesprekInit;
				vSendMsg.SendBel(stwscTelefoongesprekForm.metwie);
				stwscTelefoongesprekForm.GaatOver;
				stwscTelefoongesprekForm.ShowModal;
			end;
end;

procedure TstwsimMainForm.TelefoonShowExecute(Sender: TObject);
begin
	stwscTelefoonForm.ShowModal;
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
	if closewarn then
		CanClose := Application.MessageBox('Weet u zeker dat u de simulatie wilt afsluiten?',
			'Afsluiten', MB_ICONWARNING+MB_YESNO) = mrYes
	else
		CanClose := true;
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

function TstwsimMainForm.OpenDienstregeling;
var
	f: file;
	s: string;
begin
	result := false;
	if DienstOpenDialog.Execute then begin
		assignfile(f, DienstOpenDialog.Filename);
		Filemode := 0;
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
			Application.Messagebox(pchar('Deze dienstregeling is niet voor deze simulatie, maar voor de simulatie '+s+'.'), 'Fout', MB_ICONERROR);
			exit;
		end;
		stringread(f, s);
		if s <> pCore.simversie then begin
			Application.Messagebox('Deze dienstregeling is voor een andere versie van deze simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Dan de dienstregeling laden
		pCore.LaadMatDienstVerschijn(f, swBasis);
		closefile(f);
		DienstOpen.Enabled := false;
		result := true;
	end;
end;

function TstwsimMainForm.OpenGame;
var
	f: file;
	s: string;
	i,n: integer;
	Tijd: integer;
begin
	result := false;
	if GameOpenDialog.Execute then begin
		assignfile(f, GameOpenDialog.Filename);
		Filemode := 0;
		{$I-}reset(f, 1);{$I+}
		if ioresult <> 0 then begin
			Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Lees de MAGIC
		stringread(f, s);
		if s <> SaveIOMagic then begin
			Application.Messagebox('Ongeldig bestandstype.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Lees simnaam en simversie
		stringread(f, s);
		if s <> pCore.simnaam then begin
			Application.Messagebox(pchar('Deze savegame is niet voor deze simulatie, maar voor de simulatie '+s+'.'), 'Fout', MB_ICONERROR);
			exit;
		end;
		stringread(f, s);
		if s <> pCore.simversie then begin
			Application.Messagebox('Deze savegame is voor een andere versie van deze simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Dan de dienstregeling laden
		pCore.LaadMatDienstVerschijn(f, swStatus);
		// Huidige tijd lezen
		intread(f, Tijd);
		SetTijd(Tijd);
		TimeSet := true;
		// Treinen laden
		pCore.pAlleTreinen := LoadTreinen(f, pCore.pMaterieel, pCore.pAlleRails);
		// Overige infrastatus laden
		pCore.LoadInfraStatus(f);
		// Actieve rijwegen laden
		RijwegLogica.LoadActieveRijwegen(f);
		LoadWisselStatus(f, vCore);
		// Scenario laden
		Scenario.Clear;
		intread(f, n);
		for i := 1 to n do begin
			stringread(f, s);
			Scenario.Add(s);
		end;
		ScenarioToepassen(false);

		closefile(f);
		SGOpenen.Enabled := false;
		result := true;
	end;
end;

procedure TstwsimMainForm.DienstOpenExecute(Sender: TObject);
begin
	OpenDienstregeling
end;

procedure TstwsimMainForm.DienstSaveExecute(Sender: TObject);
var
	f: file;
begin
	if DienstSaveDialog.Execute then begin
		assignfile(f, DienstSaveDialog.Filename);
		filemode := 2;
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
		// Dienstregeling opslaan
		pCore.SaveMatDienstVerschijn(f, swBasis);
		closefile(f);
	end;
end;

function TstwsimMainForm.SaveGame;
var
	f: file;
	i: integer;
	oudepauze: boolean;
begin
	oudepauze := pauze;
	if not pauze then
		PauzeActionExecute(Self);
	result := false;
	if GameSaveDialog.Execute then begin
		assignfile(f, GameSaveDialog.Filename);
		filemode := 2;
		{$I-}rewrite(f, 1);{$I+}
		if ioresult <> 0 then begin
			Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Schrijf de MAGIC
		stringwrite(f, SaveIOMagic);
		// Schrijf simnaam en simversie
		stringwrite(f, pCore.simnaam);
		stringwrite(f, pCore.simversie);
		// Dan de dienstregeling opslaan
		pCore.SaveMatDienstVerschijn(f, swStatus);
		// Huidige tijd schrijven
		intwrite(f, GetTijd);
		// Treinen opslaan
		SaveTreinen(f, pCore.pAlleTreinen);
		// Overige infrastatus opslaan
		pCore.SaveInfraStatus(f);
		// Actieve rijwegen opslaan
		RijwegLogica.SaveActieveRijwegen(f);
		SaveWisselStatus(f, vCore);
		// Scenario opslaan
		intwrite(f, Scenario.Count);
		for i := 1 to Scenario.Count do
			stringwrite(f, Scenario[i-1]);

		closefile(f);
		result := true;
	end;
	if not oudepauze then
		PauzeActionExecute(Self);
end;

procedure TstwsimMainForm.SGSaveExecute(Sender: TObject);
begin
	SaveGame;
end;

function TstwsimMainForm.vLoadScenarioString;
const
	ws = [#9, ' '];
var
	// Algemene variabelen
	waarde: string;
	index: integer;
	p: integer;
	soort: string;
	// Wissel
	tmpvWissel: PvWissel;
begin
	result := false;
	// Even dat de compiler niet zeurt
	tmpvWissel := nil;

	index := 0;
	if copy(s,1,1)<>'#' then
		while s <> '' do begin
			// Whitespace van het begin schrappen.
			while (s <> '') and (s[1] in ws) do
				s := copy(s, 2, length(s)-1);
			if s='' then break;
			p := 1;
			while (p <= length(s)) and not(s[p] in ws) do
				inc(p);
			waarde := copy(s, 1, p-1);
			s := copy(s, p+1, length(s)-p);
			// Als eerste bepalen we wat voor soort ding we maken.
			if index = 0 then
				soort := waarde
			// En dan komt een reuzen-IF voor de rest!
			else if soort = 'c' then begin				// COMMANDO
				case index of
				1: begin
					if s <> '' then waarde := waarde + ' '+s;
					RijwegLogica.VoerStringUit(waarde);
					s := '';
				end else
					begin Scenario_leesfout := 'Te veel parameters'; exit end;
				end;
			end else if soort = 'w' then begin	// WISSELSTAND
				case index of
				1: begin
					tmpvWissel := stwvCore.ZoekWissel(vCore, waarde);
					if not assigned(tmpvWissel) then
						begin Scenario_leesfout := 'Wissel '+waarde+' niet gevonden.'; exit end;
				end;
				2: begin
					if waarde = 'r' then begin
						if not RijwegLogica.StelWisselIn(tmpvWissel, wsRechtdoor) then
							begin Scenario_leesfout := 'Deze wisselstand kan niet.'; exit end;
					end else if waarde = 'a' then begin
						if not RijwegLogica.StelWisselIn(tmpvWissel, wsAftakkend) then
							begin Scenario_leesfout := 'Deze wisselstand kan niet.'; exit end;
					end else
						begin Scenario_leesfout := 'Wisselstand moet recht (r) of afbuigend (a) zijn.'; exit end;
				end else
					begin Scenario_leesfout := 'Te veel parameters'; exit end;
				end;
			end else if (soort <> 'k') and (soort <> 'vsv') then
				begin Scenario_leesfout := 'Dit commando bestaat niet.'; exit end;	// Verkeerde 'soort' opgegeven.
			inc(index);
		end;
	result := true;
end;

procedure TstwsimMainForm.ScenarioToepassen;
var
	i: integer;
begin
	if ScenarioToegepast then exit;
	for i := 1 to Scenario.Count do
		if not pCore.LoadScenarioString(Scenario[i-1]) then begin
			Application.MessageBox(pchar('Regel: '+Scenario[i-1]+#13#10+pCore.Leesfout_melding),'Fout in scenario', MB_OK+MB_ICONWARNING);
		end;
	if vToepassen then
		for i := 1 to Scenario.Count do
			if not vLoadScenarioString(Scenario[i-1]) then begin
				Application.MessageBox(pchar('Regel: '+Scenario[i-1]+#13#10+Scenario_leesfout),'Fout in scenario', MB_OK+MB_ICONWARNING);
			end;
	ScenarioToegepast := true;
end;

procedure TstwsimMainForm.PauzeActionExecute(Sender: TObject);
var
	Tab: PTablist;
begin
	if not gestart then begin
		// Sim initialiseren
		pCore.StartUp;
		rijwegLogica.StartupBezig := false;
		if not TimeSet then begin
			SetTijd(PCore.StartTijd);
			TimeSet := true;
		end;
		Randomize;

		// Scenario uitvoeren
		ScenarioToepassen(true);

		// UI updaten.
		DienstOpen.Enabled := false;
      ScenOpen.Enabled := false;

		Tab := RijwegLogica.Tabs;
		while assigned(Tab) do begin
			Tab^.Gleisplan.OnbekendeWisselsKnipperen := true;
			Tab := Tab^.Volgende;
		end;

      closewarn := true;

		gestart := true;
	end;

	pauze := not pauze;

	PauzeAction.Checked := pauze;
	PauzePanel.Visible := pauze;
	if pauze then
		PauzePanel.BringToFront;
	DoorspoelAction.Enabled := not pauze;
	telBtn.Enabled := not pauze;

	RijwegNormaal.Enabled := not Pauze;
	RijwegROZ.Enabled := not Pauze;
	RijwegAuto.Enabled := not Pauze;
	invoerEdit.Enabled := not Pauze;
	if Pauze then begin
		RijwegVoerin.Enabled := false;
		RijwegHo.Enabled := false
	end else begin
		UpdateChg.Vannaar := true;
		UpdateControls;
	end;

	tijdLabel.Caption := TijdStr(GetTijd, false);
end;

procedure TstwsimMainForm.DoorspoelActionExecute(Sender: TObject);
var
	i: integer;
begin
	DoorspoelAction.Enabled := false;
	i := 0;
	while (not pCore.TreinenDoenIets) and (not pauze) do begin
		DoeStapje;
		inc(i);
		if i = tps * 60 then begin
			Application.ProcessMessages;
			i := 0;
		end;
	end;
	DoorspoelAction.Enabled := not pauze;
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

procedure TstwsimMainForm.FormResize(Sender: TObject);
begin
	SetPanelsPos;
end;

procedure TstwsimMainForm.StartMetDienstActionExecute(Sender: TObject);
begin
	if OpenDienstregeling then begin
		SimStartPanel.Visible := false;
		EnableControls;
		PauzeAction.Execute;
	end;
end;

procedure TstwsimMainForm.EerstDienstBewerkenActionExecute(
  Sender: TObject);
begin
	closewarn := true;
	EnableControls;
	SimStartPanel.Visible := false;
	PauzePanel.Visible := true;
	PauzePanel.BringToFront;
end;

procedure TstwsimMainForm.SGOpenenExecute(Sender: TObject);
begin
	if OpenGame then begin
		SimStartPanel.Visible := false;
		EnableControls;
		PauzeAction.Execute;
	end;
end;

procedure TstwsimMainForm.invoerEditChange(Sender: TObject);
begin
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.invoerEditEnter(Sender: TObject);
begin
	voerInBut.Default := true;
	cancelBut.Cancel := true;
end;

procedure TstwsimMainForm.invoerEditExit(Sender: TObject);
begin
	voerInBut.Default := false;
	cancelBut.Cancel := false;
end;

procedure TstwsimMainForm.RijwegVoerinExecute(Sender: TObject);
var
	commando: string;
begin
	commando := invoerEdit.Text;
	if commando = 'CheatGeenDefecten' then
		pCore.CheatGeenDefecten := true
	else
		RijwegLogica.VoerStringUit(commando);
	invoerEdit.Text := '';
	UpdateChg.Vannaar := true;
	UpdateControls;
end;

procedure TstwsimMainForm.ScenOpenExecute(Sender: TObject);
var
	f: textfile;
	s: string;
	ok: boolean;
begin
	if not ScenOpenDialog.Execute then exit;
	assignfile(f, ScenOpenDialog.Filename);
	{$I-}reset(f);{$I+}
	if ioresult <> 0 then begin
		Application.Messagebox('Fout bij openen bestand.', 'Fout', MB_ICONERROR);
		exit;
	end;
	Scenario.Clear;
	ok := false;
	if not eof(f) then begin
		readln(f, s);
		if (s = pCore.simnaam) and not eof(f) then
			ok := true;
	end;
	if not ok then begin
		Application.Messagebox(pchar('Dit is geen geldig scenario.'), 'Fout', MB_ICONERROR);
		exit;
	end;
	readln(f, s);
	if s <> pCore.simversie then begin
		Application.Messagebox('Deze savegame is voor een andere versie van deze simulatie.', 'Fout', MB_ICONERROR);
		exit;
	end;
	while not eof(f) do begin
		readln(f, s);
		Scenario.Add(s);
	end;
	closefile(f);

	ScenOpen.Enabled := false;
end;

end.
