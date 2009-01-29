unit stwsimclientTelefoonBel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TstwscTelefoonBelForm = class(TForm)
    Label1: TLabel;
    monteurRadio: TRadioButton;
    cancelBut: TButton;
    okBut: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwscTelefoonBelForm: TstwscTelefoonBelForm;

implementation

{$R *.DFM}

procedure TstwscTelefoonBelForm.FormShow(Sender: TObject);
begin
	ActiveControl := okBut;
end;

end.
