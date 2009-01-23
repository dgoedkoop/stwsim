unit clientProcesplanForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  clientProcesPlanFrame, stwvProcesplan, stwvRijwegLogica, stwvCore, stwvLog,
  clientSendMsg, stwvMeetpunt, StdCtrls, ExtCtrls;

type
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
    Button1: TButton;
	 procedure Button1Click(Sender: TObject);
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
		Frame^.PPFrame.UpdateLijst;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		Frame^.PPFrame.UpdateLijst;
		Frame := Frame^.Volgende;
	end;
end;

procedure TstwscProcesplanForm.DoeStapje;
var
	Frame: PFrameList;
begin
	Frame := PPFramesLinks;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then
			Frame^.PPFrame.ProcesPlan.DoeStapje;
		Frame := Frame^.Volgende;
	end;
	Frame := PPFramesRechts;
	while assigned(Frame) do begin
		if Frame^.PPFrame.ARI then
			Frame^.PPFrame.ProcesPlan.DoeStapje;
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

procedure TstwscProcesplanForm.Button1Click(Sender: TObject);
var
	PPFrame: PFrameList;
	FName: string;
begin
	if OpenDialog.Execute then begin
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
		PPFrame^.PPFrame.ProcesPlan.LaadProcesplan(OpenDialog.Filename);
		FName := ExtractFileName(OpenDialog.Filename);
		PPFrame^.PPFrame.FName := FName;
		PPFrame^.PPFrame.titelLabel.Caption :=
			UpperCase(copy(FName, 1, length(FName)-length(ExtractFileExt(FName))));
		PPFrame^.PPFrame.UpdateLijst;
		if FramesLinks = FramesRechts then begin
			PPFrame^.PPFrame.Parent := LiPanel;
			if assigned(PPFramesLinks) then
				PPFrame^.PPFrame.Align := alTop
			else
				PPFrame^.PPFrame.Align := alClient;
			PPFrame.Volgende := PPFramesLinks;
			PPFramesLinks := PPFrame;
			inc(FramesLinks);
		end else begin
			PPFrame^.PPFrame.Parent := RePanel;
			RePanel.Visible := true;
			if assigned(PPFramesRechts) then
				PPFrame^.PPFrame.Align := alTop
			else
				PPFrame^.PPFrame.Align := alClient;
			PPFrame.Volgende := PPFramesRechts;
			PPFramesRechts := PPFrame;
			inc(FramesRechts);
		end;
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
	RePanel.Width := Width div 2;
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
