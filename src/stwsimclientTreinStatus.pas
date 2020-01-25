unit stwsimclientTreinStatus;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, StdCtrls, serverSendMsg;

type
	TstwscTreinStatusForm = class(TForm)
		statusMemo: TMemo;
		closeBut: TButton;
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
	private
		Regels: integer;
	public
		Treinnr: string;
		procedure Bericht(s: string);
		procedure BerichtEinde;
		procedure Wissen;
	end;

var
  stwscTreinStatusForm: TstwscTreinStatusForm;

implementation

{$R *.DFM}

procedure TstwscTreinStatusForm.Bericht;
begin
	if Regels < statusMemo.Lines.Count then
		statusMemo.Lines[Regels] := s
	else
		statusMemo.Lines.Add(s);
	inc(Regels);
	// Haal laatste lege regel weg
	if copy(statusMemo.Text, length(statusMemo.Text)-1, 2) = #13#10 then
		statusMemo.Text := copy(statusMemo.Text, 1, length(statusMemo.Text)-2);
end;

procedure TstwscTreinStatusForm.BerichtEinde;
begin
	while statusMemo.Lines.Count > Regels do
		statusMemo.Lines.Delete(statusMemo.Lines.Count-1);
	Regels := 0;
end;

procedure TstwscTreinStatusForm.Wissen;
begin
	statusMemo.Lines.Clear;
	Regels := 0;
end;

procedure TstwscTreinStatusForm.FormCreate(Sender: TObject);
begin
	Regels := 0;
end;

procedure TstwscTreinStatusForm.FormShow(Sender: TObject);
begin
	ActiveControl := closeBut;
end;

end.
