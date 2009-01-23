unit stwsimClientNieuwPlanpunt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TstwscNieuwPlanpuntForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    stationEdit: TEdit;
    perronEdit: TEdit;
    aanUurEdit: TEdit;
    aanMinEdit: TEdit;
    vertrMinEdit: TEdit;
    vertrUurEdit: TEdit;
    StopCheck: TCheckBox;
    kerenCheck: TCheckBox;
    nieuwnrEdit: TEdit;
    loskAantalEdit: TEdit;
    loskTreinnrEdit: TEdit;
    loskKerenCheck: TCheckBox;
    koppelCheck: TCheckBox;
    okBut: TButton;
    cancelBut: TButton;
    aankCheck: TCheckBox;
    vertrCheck: TCheckBox;
    invStationEdit: TEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwscNieuwPlanpuntForm: TstwscNieuwPlanpuntForm;

implementation

{$R *.DFM}

procedure TstwscNieuwPlanpuntForm.FormShow(Sender: TObject);
begin
	invStationEdit.Text := '';
	StationEdit.Text := '';
	perronEdit.Text := '';
	aankCheck.Checked := true;
	aanUurEdit.Text := '0';
	aanMinEdit.Text := '00';
	vertrCheck.Checked := true;
	vertrUurEdit.Text := '0';
	vertrMinEdit.Text := '00';
	StopCheck.Checked := true;
	koppelCheck.Checked := false;
	kerenCheck.Checked := false;
	loskAantalEdit.Text := '0';
	loskTreinnrEdit.Text := '';
	loskKerenCheck.Checked := false;
	nieuwnrEdit.Text := '';
	ActiveControl := okBut;
end;

end.
