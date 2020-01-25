unit stwsimserverAddMat;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, stwpCore;

type
	TstwssAddMatForm = class(TForm)
		Matcombo: TComboBox;
		Label1: TLabel;
		OKBut: TButton;
		CancelBut: TButton;
		procedure FormShow(Sender: TObject);
  private
	 { Private declarations }
	public
		Core: TpCore;
	end;

var
	stwssAddMatForm: TstwssAddMatForm;

implementation

{$R *.DFM}

procedure TstwssAddMatForm.FormShow(Sender: TObject);
var
	Rec: TSearchRec;
	Naam: string;
begin
	MatCombo.Items.Clear;
	if FindFirst(Core.Filedir+'\*.ssm', $2F, Rec) < 0 then exit;
	repeat
		Naam := ExtractFileName(Rec.Name);
		Naam := copy(Naam, 1, length(Naam)-length(ExtractFileExt(Naam)));
		MatCombo.Items.Add(Naam);
	until FindNext(Rec) <> 0;
	FindClose(Rec);
	MatCombo.Text := '';
	ActiveControl := MatCombo;
end;

end.
