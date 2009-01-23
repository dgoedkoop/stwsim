unit stwsimClientConnect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TstwscConnectForm = class(TForm)
    okBut: TButton;
    cancelBut: TButton;
    Label1: TLabel;
    Label2: TLabel;
    serverEdit: TEdit;
    userEdit: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwscConnectForm: TstwscConnectForm;

implementation

{$R *.DFM}

procedure TstwscConnectForm.FormShow(Sender: TObject);
begin
	ActiveControl := userEdit;
	serverEdit.SelStart := 0;
	serverEdit.SelLength := length(serverEdit.Text);
end;

end.
