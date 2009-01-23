unit stwsimClientEditInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TstwsceInfoForm = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwsceInfoForm: TstwsceInfoForm;

implementation

{$R *.DFM}

procedure TstwsceInfoForm.Button1Click(Sender: TObject);
begin
	Close;
end;

end.
