unit stwsimClientInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TstwscInfoForm = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    VerLabel: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  stwscInfoForm: TstwscInfoForm;

implementation

{$R *.DFM}

uses KkVersion;

procedure TstwscInfoForm.Button1Click(Sender: TObject);
begin
	Close;
end;

procedure TstwscInfoForm.FormCreate(Sender: TObject);
begin
	VerLabel.Caption := FileVersion;
end;

end.
