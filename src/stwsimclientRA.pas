unit stwsimclientRA;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

type
	TstwscRAform = class(TForm)
		Label1: TLabel;
		stationEdit: TEdit;
		okBut: TButton;
		cancelBut: TButton;
		procedure FormShow(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	stwscRAform: TstwscRAform;

implementation

{$R *.DFM}

procedure TstwscRAform.FormShow(Sender: TObject);
begin
	ActiveControl := stationEdit;
end;

end.
