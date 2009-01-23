unit stwsimserverBewerkPlanpunt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TstwssPlanpuntBewerkForm = class(TForm)
    stationEdit: TEdit;
    Label1: TLabel;
    perronEdit: TEdit;
    Label2: TLabel;
    aanUurEdit: TEdit;
    Label4: TLabel;
    aanMinEdit: TEdit;
    vertrMinEdit: TEdit;
    Label5: TLabel;
    vertrUurEdit: TEdit;
    wachtSecEdit: TEdit;
    Label7: TLabel;
    wachtMinEdit: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    StopCheck: TCheckBox;
    kerenCheck: TCheckBox;
    Label12: TLabel;
    nieuwnrEdit: TEdit;
    loskAantalEdit: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    loskTreinnrEdit: TEdit;
    loskKerenCheck: TCheckBox;
    koppelCheck: TCheckBox;
    okBut: TButton;
    cancelBut: TButton;
    aankCheck: TCheckBox;
    vertrCheck: TCheckBox;
    procedure aankCheckClick(Sender: TObject);
    procedure vertrCheckClick(Sender: TObject);
    procedure StopCheckClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
	 { Public declarations }
		procedure UpdEnable;
  end;

var
  stwssPlanpuntBewerkForm: TstwssPlanpuntBewerkForm;

implementation

{$R *.DFM}

procedure TstwssPlanpuntBewerkForm.UpdEnable;
begin
	aanUurEdit.Enabled := aankCheck.Checked;
	aanMinEdit.Enabled := aankCheck.Checked;
	vertrUurEdit.Enabled := vertrCheck.Checked;
	vertrMinEdit.Enabled := vertrCheck.Checked;
	wachtMinEdit.Enabled := StopCheck.Checked and aankCheck.Checked;
	wachtSecEdit.Enabled := StopCheck.Checked and aankCheck.Checked;
	StopCheck.Enabled := aankCheck.Checked;
end;

procedure TstwssPlanpuntBewerkForm.aankCheckClick(Sender: TObject);
begin
	UpdEnable;
end;

procedure TstwssPlanpuntBewerkForm.vertrCheckClick(Sender: TObject);
begin
	UpdEnable;
end;

procedure TstwssPlanpuntBewerkForm.StopCheckClick(Sender: TObject);
begin
	UpdEnable;
end;

procedure TstwssPlanpuntBewerkForm.FormShow(Sender: TObject);
begin
	UpdEnable;
end;

end.
