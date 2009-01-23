unit stwsimServerInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TstwssInfoForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwssInfoForm: TstwssInfoForm;

implementation

{$R *.DFM}

procedure TstwssInfoForm.Button1Click(Sender: TObject);
begin
	Close;
end;

end.
