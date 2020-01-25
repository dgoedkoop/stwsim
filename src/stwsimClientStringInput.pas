unit stwsimClientStringInput;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

type
	TstwscStringInputForm = class(TForm)
		InputLabel: TLabel;
		InputEdit: TEdit;
		okBut: TButton;
		cancelBut: TButton;
		procedure FormShow(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	stwscStringInputForm: TstwscStringInputForm;

implementation

{$R *.DFM}

procedure TstwscStringInputForm.FormShow(Sender: TObject);
begin
	InputEdit.SelStart := 0;
	InputEdit.SelLength := length(InputEdit.Text);
	ActiveControl := InputEdit;
end;

end.
