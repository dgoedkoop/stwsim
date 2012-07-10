unit clientProcesplanForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  clientProcesPlanFrame, stwvProcesplan, stwvRijwegLogica, stwvCore, stwvLog,
  clientSendMsg, stwvMeetpunt, stwvMisc, StdCtrls, ExtCtrls;

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
		procedure TreinnummerNieuw(Meetpunt: PvMeetpunt);
		procedure TreinnummerWeg(Meetpunt: PvMeetpunt);
		function CreateFrame(Filename: string; waar: tLinksRechts): PFrameList;
		procedure RecalcSizes;
		procedure SaveStatus(var f: file);
		procedure LoadStatus(var f: file);
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
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then begin
			Frame^.PPFrame.ProcesPlan.DoeStapje;
		end;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then begin
			Frame^.PPFrame.ProcesPlan.DoeStapje;
		end;
		Frame := Frame^.Volgende;
	end;
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

function TstwscProcesplanForm.CreateFrame;
var
	PPFrame: PFrameList;
	tmpFrame: PFrameList;
begin
	new(PPFrame);
	PPFrame^.PPFrame := TstwscProcesPlanFrame.Create(Self);
	PPFrame^.PPFrame.Name := 'PPFrame'+IntToStr(FramesLinks+FramesRechts);
	PPFrame^.PPFrame.Visible := true;
	PPFrame^.PPFrame.Core  := Core;
	PPFrame^.PPFrame.ProcesPlan := TProcesPlan.Create;
	PPFrame^.PPFrame.ProcesPlan.Core := Core;
	PPFrame^.PPFrame.ProcesPlan.SendMsg := SendMsg;
	PPFrame^.PPFrame.ProcesPlan.Log := Log;
	PPFrame^.PPFrame.ProcesPlan.RijwegLogica := RijwegLogica;
	PPFrame^.PPFrame.FName := Filename;
	PPFrame^.PPFrame.titelLabel.Caption :=
		UpperCase(copy(Filename, 1, length(Filename)-length(ExtractFileExt(Filename))));
	PPFrame^.Volgende := nil;
	PPFrame^.PPFrame.UpdateLijst;
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
	result := PPFrame;
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
		PPFrame := CreateFrame(Filename, lrLinks);
		PPFrame^.PPFrame.ProcesPlan.LoadBinair(f);
	end;
	intread(f, count);
	for i := 1 to count do begin
		stringread(f, Filename);
		PPFrame := CreateFrame(Filename, lrRechts);
		PPFrame^.PPFrame.ProcesPlan.LoadBinair(f);
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
		if FramesLinks = FramesRechts then
			PPFrame := CreateFrame(Filename, lrLinks)
		else
			PPFrame := CreateFrame(Filename, lrRechts);
		PPFrame^.PPFrame.ProcesPlan.LaadProcesplan(OpenDialog.Filename);
	end;
end;

procedure TstwscProcesplanForm.FormCreate(Sender: TObject);
begin
	PPFramesLinks := nil;
	PPFramesRechts := nil;
	FramesLinks := 0;
	FramesRechts := 0;
end;

procedure TstwscProcesplanForm.FormResize(Sender: TObject);
begin
	RecalcSizes;
end;

procedure TstwscProcesplanForm.FormDestroy(Sender: TObject);
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.Destroy;
		Frame^.PPFrame.Destroy;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.ProcesPlan.Destroy;
		Frame^.PPFrame.Destroy;
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	OnHerkenProcesplanClose;
end;

end.
