unit stwsimServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, stwpCore, serverServerIO, serverSendMsg, serverReadMsg,
  stwpTijd, stwpTreinen, stwvMisc, ComCtrls, Menus, ActnList;

type
  TstwssMainForm = class(TForm)
    OpenButton: TButton;
    StartButton: TButton;
    Timer: TTimer;
	 OpenDialog: TOpenDialog;
    SpeedTrack: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Bestand1: TMenuItem;
    Afsluiten1: TMenuItem;
    Help1: TMenuItem;
    Info1: TMenuItem;
    ActionList: TActionList;
    OpenAction: TAction;
    StartAction: TAction;
    Openen1: TMenuItem;
    Simulatie1: TMenuItem;
    Start1: TMenuItem;
    StatusBar: TStatusBar;
    Bevel1: TBevel;
    dienstBut: TButton;
    DienstOpenAction: TAction;
    N2Dienstregelingopenen1: TMenuItem;
    DienstOpenDialog: TOpenDialog;
    Button1: TButton;
    DienstEditAction: TAction;
    DienstSaveAction: TAction;
    DienstSaveDialog: TSaveDialog;
    Dienstregelingopslaanals1: TMenuItem;
    doorspoelBut: TButton;
    DoorspoelAction: TAction;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Afsluiten1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure StartActionExecute(Sender: TObject);
    procedure DienstOpenActionExecute(Sender: TObject);
    procedure DienstEditActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DienstSaveActionExecute(Sender: TObject);
    procedure DoorspoelActionExecute(Sender: TObject);
	private
		server:	TStwServer;
		core:		TpCore;
		SendMsg:	TSendMsg;
		ReadMsg:	TReadMsg;
		gestart: boolean;
		pauze: 	boolean;
		pauzewens: boolean;
	public
	 { Public declarations }
  end;

var
  stwssMainForm: TstwssMainForm;

implementation

uses stwsimServerInfo, stwsimServerDienstreg;

{$R *.DFM}

procedure TstwssMainForm.FormCreate(Sender: TObject);
begin
	Core := TpCore.Create;

	gestart := false;
	pauzewens := true;
end;

procedure TstwssMainForm.TimerTimer(Sender: TObject);

	function mtl(s: string; g: integer): string;
	begin
		result := s;
		while length(result)<g do
			result := '0'+result;
	end;

var
	i: integer;
begin
	if not gestart then exit;
	if Core.compleet and (not pauzewens) and pauze then begin
		pauze := false;
		Core.StwServer.SendBroadcastString('pause:n');
	end;
	if ((not Core.compleet) or pauzewens) and (not pauze) then begin
		pauze := true;
		Core.StwServer.SendBroadcastString('pause:j');
	end;
	if Timer.Interval <> (1000 div tps) then
		Timer.Interval := 1000 div tps;
	if pauze then begin
		StatusBar.SimpleText := 'Gepauzeerd. Tijd: '+inttostr(Core.Tijd_U)+
		':'+mtl(inttostr(core.Tijd_m),2)+':'+mtl(inttostr(core.Tijd_s),2);
	end else begin
		StatusBar.SimpleText := 'Simulatie loopt. Tijd: '+inttostr(Core.Tijd_U)+
		':'+mtl(inttostr(core.Tijd_m),2)+':'+mtl(inttostr(core.Tijd_s),2);
		for i := 1 to SpeedTrack.Position do
			Core.DoeStapje
	end;
end;

procedure TstwssMainForm.Afsluiten1Click(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TstwssMainForm.Info1Click(Sender: TObject);
begin
	stwssInfoForm.ShowModal;
end;

procedure TstwssMainForm.OpenActionExecute(Sender: TObject);
var
	f: textfile;
	s: string;
begin
	if OpenDialog.Execute then begin
		randomize;
		Core.FileDir := ExtractFileDir(openDialog.FileName);
		assignfile(f, openDialog.FileName);
		reset(f);
		// 1: Simnaam
		readln(f, s); Core.simnaam := s;
		// 2: Simversie
		readln(f, s); Core.simversie := s;
		// En de rails laden
		Core.RailsLaden(f);
		closefile(f);

		core.Starttijd := MkTijd(0,0,0);
		core.Stoptijd := MkTijd(23,59,59);

		// UI updaten
		OpenAction.Enabled := false;
		DienstOpenAction.Enabled := true;
		DienstEditAction.Enabled := true;
		StartAction.Enabled := true;
		StatusBar.SimpleText := 'Sim geladen.';
	end;
end;

procedure TstwssMainForm.StartActionExecute(Sender: TObject);
begin
	// Een en ander initialiseren
	Server := TStwServer.Create(self);
	SendMsg := TSendMsg.Create;
	SendMsg.ClientList := @Server.ClientList;
	Core.SendMsg := @SendMsg;
	ReadMsg := TReadMsg.Create;
	ReadMsg.Core := @Core;
	ReadMsg.SendMsg := @SendMsg;
	Server.ReadMsg := ReadMsg.ReadMsg;
	Server.Unregister := ReadMsg.Unregister;
	Core.StwServer := @Server;
	Core.StartUp;
	Pauze := true;

	server.Addr := '0.0.0.0';
	server.Port := '6327';
	server.Listen(5);
	// UI updaten.
	DienstOpenAction.Enabled := false;
	StartAction.Enabled := false;
   DoorspoelAction.Enabled := true;
	gestart := true;
	pauzewens := false;
end;

procedure TstwssMainForm.DienstOpenActionExecute(Sender: TObject);
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
		if s <> Core.simnaam then begin
			Application.Messagebox('Dienstregeling niet voor deze simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		stringread(f, s);
		if s <> Core.simversie then begin
			Application.Messagebox('Dienstregeling niet voor deze versie van de simulatie.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Begin- en eindtijd lezen
		intread(f, Core.starttijd);
		intread(f, Core.stoptijd);
		// Zo. Nu gaan we beginnen. Eerst materieel inladen.
		intread(f, matfilecount);
		for i := 1 to matfilecount do begin
			stringread(f, s);
			if not core.WagonsLaden(s) then begin
				Application.Messagebox(pchar('Wagonbestand "'+s+'" niet gevonden.'), 'Fout', MB_ICONERROR);
				exit;
			end;
		end;
		// Dan de dienstregeling laden
		Core.LaadDienstEnVerschijn(f);
		closefile(f);
		DienstOpenAction.Enabled := false;
	end;
end;

procedure TstwssMainForm.DienstEditActionExecute(Sender: TObject);
var
	oudePauzewens: boolean;
begin
	oudePauzewens := pauzewens;
	pauzewens := true;
	stwssDienstregForm.ShowModal;
	pauzewens := oudePauzewens;
end;

procedure TstwssMainForm.FormShow(Sender: TObject);
begin
	stwssDienstregForm.Core := Core;
end;

procedure TstwssMainForm.DienstSaveActionExecute(Sender: TObject);
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
		stringwrite(f, Core.simnaam);
		stringwrite(f, Core.simversie);
		// Begin- en eindtijd schrijven
		intwrite(f, Core.starttijd);
		intwrite(f, Core.stoptijd);
		// Zo. Eerst materieel opslaan
		matfilecount := 0;
		Matfile := Core.pMaterieel;
		while assigned(Matfile) do begin
			inc(matfilecount);
			Matfile := Matfile^.Volgende;
		end;
		intwrite(f, matfilecount);
		Matfile := Core.pMaterieel;
		while assigned(Matfile) do begin
			stringwrite(f, Matfile^.Filename);
			Matfile := Matfile^.Volgende;
		end;
		// Dan de dienstregeling opslaan
		Core.SaveDienstEnVerschijn(f);
		closefile(f);
	end;
end;

procedure TstwssMainForm.DoorspoelActionExecute(Sender: TObject);
var
	i: integer;
begin
	DoorspoelAction.Enabled := false;
	i := 0;
	while not Core.TreinenDoenIets do begin
		Core.DoeStapje;
		inc(i);
		if i = tps * 60 then begin
			Application.ProcessMessages;
			i := 0;
		end;
	end;
	DoorspoelAction.Enabled := true;
end;

end.
