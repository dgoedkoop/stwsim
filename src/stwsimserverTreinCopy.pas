unit stwsimserverTreinCopy;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

type
	TstwssTreinCopyForm = class(TForm)
		Label1: TLabel;
		countEdit: TEdit;
		minEdit: TEdit;
		Label2: TLabel;
		nrupedit: TEdit;
		Label3: TLabel;
		okBut: TButton;
		cancelBut: TButton;
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	stwssTreinCopyForm: TstwssTreinCopyForm;

implementation

{$R *.DFM}

end.
