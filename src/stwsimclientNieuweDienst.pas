unit stwsimclientNieuweDienst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TstwscNieuweDienstForm = class(TForm)
    Label1: TLabel;
    treinnrEdit: TEdit;
    okBut: TButton;
    cancelBut: TButton;
    vanEdit: TEdit;
    vanCheck: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure vanCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
	 { Public declarations }
		procedure UpdateDingen;
  end;

var
  stwscNieuweDienstForm: TstwscNieuweDienstForm;

implementation

{$R *.DFM}

procedure TstwscNieuweDienstForm.UpdateDingen;
begin
	vanEdit.Enabled := vanCheck.Checked;
	if vanEdit.Enabled then
		vanEdit.Color := clWindow
	else
		vanEdit.Color := clBtnFace;
end;

procedure TstwscNieuweDienstForm.FormShow(Sender: TObject);
begin
	treinnrEdit.Text := '';
	vanCheck.Checked := false;
	vanEdit.Text := '';
	UpdateDingen;
	ActiveControl := treinnrEdit;
end;

procedure TstwscNieuweDienstForm.vanCheckClick(Sender: TObject);
begin
	UpdateDingen;
end;

end.
