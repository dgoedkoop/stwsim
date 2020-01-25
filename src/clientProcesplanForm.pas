unit clientProcesplanForm;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	clientProcesPlanFrame, stwvProcesplan, stwvRijwegLogica, stwvCore, stwvLog,
	clientSendMsg, stwvMeetpunt, stwvMisc, stwvSeinen, stwvTreinInfo, StdCtrls,
	stwpTijd, ExtCtrls;

type
	TLinksRechts = (lrLinks, lrRechts);

	PFrameList = ^TFrameList;
	TFrameList = record
		PPFrame:		TstwscProcesPlanFrame;
		Volgende:	PFrameList;
	end;
	TOnHerkenProcesplanClose = procedure of object;

	TstwscProcesplanForm = class(TForm)
		LiPanel: TPanel;
		RePanel: TPanel;
		OpenDialog: TOpenDialog;
		LiBtnPanel: TPanel;
		ProcesplanToevBtn: TButton;
		procedure ProcesplanToevBtnClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
	private
		PPFramesLinks,
		PPFramesRechts:	PFrameList;
		FramesLinks,
		FramesRechts:		integer;
		VorigeTijd:		integer;
		procedure AddFrame(PPFrame: PFrameList; waar: tLinksRechts);
	public
		RijwegLogica:	TRijwegLogica;
		Core:				PvCore;
		SendMsg:			TvSendMsg;
		Log:				TLog;
		// Event
		OnHerkenProcesplanClose : TOnHerkenProcesplanClose;
		// Dit moeten we doorgeven aan ieder procesplan(frame)
		procedure UpdateLijst;
		procedure DoeStapje;
		function TreinIsAfgehandeld: boolean;
		procedure TreinnummerNieuw(Meetpunt: PvMeetpunt);
		procedure TreinnummerWeg(Meetpunt: PvMeetpunt);
		procedure MarkeerVrij(Meetpunt: PvMeetpunt);
		procedure TreinInfo(TreinInfoData: TvTreinInfo);
		function CreateFrame(Filename: string): PFrameList;
		procedure RecalcSizes;
		procedure SaveStatus(var f: file);
		procedure LoadStatus(var f: file; SgVersion: integer);
		procedure ProcesplannenReset;
	end;

var
	stwscProcesplanForm: TstwscProcesplanForm;

implementation

{$R *.DFM}

procedure TstwscProcesplanForm.UpdateLijst;
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ProcesPlan.Gewijzigd then
			Frame^.PPFrame.UpdateLijst;
		Frame^.PPFrame.ProcesPlan.Gewijzigd := false;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ProcesPlan.Gewijzigd then
			Frame^.PPFrame.UpdateLijst;
		Frame^.PPFrame.ProcesPlan.Gewijzigd := false;
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.DoeStapje;
var
	Frame: PFrameList;
	minuutstap: boolean;
	u,m,s,ou,om,os: integer;
begin
	FmtTijd(GetTijd, u,m,s);
	FmtTijd(VorigeTijd, ou,om,os);
	VorigeTijd := GetTijd;
	minuutstap := om <> m;
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then begin
			Frame^.PPFrame.ProcesPlan.DoeStapje;
		end;
		if minuutstap then
			Frame^.PPFrame.RegelList.Invalidate;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then begin
			Frame^.PPFrame.ProcesPlan.DoeStapje;
		end;
		if minuutstap then
			Frame^.PPFrame.RegelList.Invalidate;
		Frame := Frame^.Volgende;
	end;
end;

function TstwscProcesplanForm.TreinIsAfgehandeld;
var
	Frame: PFrameList;
begin
	result := false;
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		result := result or Frame^.PPFrame.ProcesPlan.TreinIsAfgehandeld;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		result := result or Frame^.PPFrame.ProcesPlan.TreinIsAfgehandeld;
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.MarkeerVrij;
begin
	// Misschien kunnen we nu een in behandeling zijnde rijweg instellen.
	DoeStapje;
end;

procedure TstwscProcesplanForm.TreinnummerNieuw;
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinnummerNieuw(Meetpunt);
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinnummerNieuw(Meetpunt);
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.TreinnummerWeg;
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinnummerWeg(Meetpunt);
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinnummerWeg(Meetpunt);
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.TreinInfo;
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinInfo(TreinInfoData);
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.TreinInfo(TreinInfoData);
		Frame := Frame^.Volgende;
	end;
end;

function TstwscProcesplanForm.CreateFrame;
var
	PPFrame: PFrameList;
	s: string;
begin
	new(PPFrame);
	PPFrame^.PPFrame := TstwscProcesPlanFrame.Create(Self);
	PPFrame^.PPFrame.Name := 'PPFrame'+IntToStr(FramesLinks+FramesRechts);
	PPFrame^.PPFrame.Visible := true;
	PPFrame^.PPFrame.Core := Core;
	s := copy(Filename, 1, length(Filename)-length(ExtractFileExt(Filename)));
	PPFrame^.PPFrame.FName := Uppercase(copy(s,1,1))+LowerCase(copy(s,2,length(s)-1));
	PPFrame^.PPFrame.titelLabel.Caption := PPFrame^.PPFrame.FName;
	PPFrame^.PPFrame.ProcesPlan := TProcesPlan.Create;
	PPFrame^.PPFrame.ProcesPlan.Core := Core;
	PPFrame^.PPFrame.ProcesPlan.SendMsg := SendMsg;
	PPFrame^.PPFrame.ProcesPlan.Log := Log;
	PPFrame^.PPFrame.ProcesPlan.RijwegLogica := RijwegLogica;
	PPFrame^.PPFrame.ProcesPlan.Locatienaam := PPFrame^.PPFrame.FName;
	PPFrame^.Volgende := nil;
	PPFrame^.PPFrame.UpdateLijst;
	result := PPFrame;
end;

procedure TstwscProcesplanForm.AddFrame;
var
	tmpFrame: PFrameList;
begin
	if waar = lrLinks then begin
		PPFrame^.PPFrame.Parent := LiPanel;
		if assigned(PPFramesLinks) then begin
			tmpFrame := PPFramesLinks;
			while assigned(tmpFrame^.Volgende) do
				tmpFrame := tmpFrame^.Volgende;
			tmpFrame^.PPFrame.Align := alTop;
			tmpFrame^.Volgende := PPFrame;
		end else
			PPFramesLinks := PPFrame;
		PPFrame^.PPFrame.Align := alClient;
		inc(FramesLinks);
	end else begin
		PPFrame^.PPFrame.Parent := RePanel;
		RePanel.Visible := true;
		if assigned(PPFramesRechts) then begin
			tmpFrame := PPFramesRechts;
			while assigned(tmpFrame^.Volgende) do
				tmpFrame := tmpFrame^.Volgende;
			tmpFrame^.PPFrame.Align := alTop;
			tmpFrame^.Volgende := PPFrame;
		end else
			PPFramesRechts := PPFrame;
		PPFrame^.PPFrame.Align := alClient;
		inc(FramesRechts);
	end;
	RecalcSizes;
end;

procedure TstwscProcesplanForm.SaveStatus;
var
	count, countpos, nupos: integer;
	Frame: PFrameList;
begin
	countpos := filepos(f);
	count := 0;
	intwrite(f, 0); // Plaatshouder
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		stringwrite(f, Frame^.PPFrame.FName);
		Frame^.PPFrame.ProcesPlan.SaveBinair(f);
		inc(count);
		Frame := Frame^.Volgende;
	end;
	nupos := filepos(f);
	seek(f, countpos);
	intwrite(f, count);
	seek(f, nupos);
	countpos := nupos;
	count := 0;
	intwrite(f, 0); // Plaatshouder
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		stringwrite(f, Frame^.PPFrame.FName);
		Frame^.PPFrame.ProcesPlan.SaveBinair(f);
		inc(count);
		Frame := Frame^.Volgende;
	end;
	nupos := filepos(f);
	seek(f, countpos);
	intwrite(f, count);
	seek(f, nupos);
end;

procedure TstwscProcesplanForm.LoadStatus;
var
	i, count: integer;
	PPFrame: PFrameList;
	Filename: string;
begin
	intread(f, count);
	for i := 1 to count do begin
		stringread(f, Filename);
		PPFrame := CreateFrame(Filename);
		PPFrame^.PPFrame.ProcesPlan.LoadBinair(f, SgVersion);
		AddFrame(PPFrame, lrLinks);
	end;
	intread(f, count);
	for i := 1 to count do begin
		stringread(f, Filename);
		PPFrame := CreateFrame(Filename);
		PPFrame^.PPFrame.ProcesPlan.LoadBinair(f, SgVersion);
		AddFrame(PPFrame, lrRechts);
	end;
end;

procedure TstwscProcesplanForm.RecalcSizes;
var
	Frame: PFrameList;
begin
	RePanel.Width := Width div 2;
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.Height := LiPanel.Height div FramesLinks;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.Height := RePanel.Height div FramesRechts;
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.ProcesplanToevBtnClick(Sender: TObject);
var
	PPFrame: PFrameList;
	Filename: string;
begin
	if OpenDialog.Execute then begin
		Filename := ExtractFileName(OpenDialog.Filename);
		PPFrame := CreateFrame(Filename);
		try
			PPFrame^.PPFrame.ProcesPlan.LaadProcesplan(OpenDialog.Filename);
			if FramesLinks = FramesRechts then
				AddFrame(PPFrame, lrLinks)
			else
				AddFrame(PPFrame, lrRechts);
		except
			on E: EProcesplanSyntaxError do begin
				Application.MessageBox(pchar(E.Message), 'Fout bij laden procesplan', MB_OK+MB_ICONWARNING);
				PPFrame^.PPFrame.ProcesPlan.Destroy;
				PPFrame^.PPFrame.Destroy;
				dispose(PPFrame);
			end;
		end;
	end;
end;

procedure TstwscProcesplanForm.FormCreate(Sender: TObject);
begin
	PPFramesLinks := nil;
	PPFramesRechts := nil;
	FramesLinks := 0;
	FramesRechts := 0;
	VorigeTijd := -1;
end;

procedure TstwscProcesplanForm.FormResize(Sender: TObject);
begin
	RecalcSizes;
end;

procedure TstwscProcesplanForm.FormDestroy(Sender: TObject);
begin
	ProcesplannenReset;
end;

procedure TstwscProcesplanForm.ProcesplannenReset;
var
	Frame: PFrameList;
	tmp: pointer;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.Free;
		Frame^.PPFrame.Free;
		tmp := Frame^.Volgende;
		Dispose(Frame);
		Frame := tmp;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.Free;
		Frame^.PPFrame.Free;
		tmp := Frame^.Volgende;
		Dispose(Frame);
		Frame := tmp;
	end;
	PPFramesLinks := nil;
	PPFramesRechts := nil;
	FramesLinks := 0;
	FramesRechts := 0;
	VorigeTijd := -1;
end;

procedure TstwscProcesplanForm.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	OnHerkenProcesplanClose;
end;

end.
