unit stwsimClientInterpose;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

type
	TstwscInterposeForm = class(TForm)
		Label1: TLabel;
		treinnrEdit: TEdit;
		okBut: TButton;
		cancelBut: TButton;
		procedure FormShow(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	stwscInterposeForm: TstwscInterposeForm;

implementation

{$R *.DFM}

procedure TstwscInterposeForm.FormShow(Sender: TObject);
begin
	treinnrEdit.SelStart := 0;
	treinnrEdit.SelLength := length(treinnrEdit.Text);
	ActiveControl := treinnrEdit;
end;

end.
