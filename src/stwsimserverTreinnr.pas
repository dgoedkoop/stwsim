unit stwsimserverTreinnr;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

type
	TstwssTreinnrForm = class(TForm)
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
	stwssTreinnrForm: TstwssTreinnrForm;

implementation

{$R *.DFM}

procedure TstwssTreinnrForm.FormShow(Sender: TObject);
begin
	ActiveControl := treinnrEdit;
end;

end.
