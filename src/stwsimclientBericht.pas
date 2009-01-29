unit stwsimclientBericht;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, clientSendMsg, stwvCore, stwvTreinComm, stwpTijd;

type
  TstwscBerichtForm = class(TForm)
	 berichtenList: TListBox;
	 berichtMemo: TMemo;
	 replyBut: TButton;
	 treinCaption: TLabel;
	 cancelBut: TButton;
	 procedure FormShow(Sender: TObject);
	 procedure berichtenListClick(Sender: TObject);
	private
		procedure Reshow;
	public
//		SendMsg:	PvSendMsg;
		Core:		PvCore;
	end;

var
  stwscBerichtForm: TstwscBerichtForm;

implementation

{$R *.DFM}

procedure TstwscBerichtForm.Reshow;
var
	u,m,s: integer;
	us,ms,ss: string;
begin
end;

procedure TstwscBerichtForm.FormShow(Sender: TObject);
begin
	Reshow;
	ActiveControl := berichtenList;
end;

procedure TstwscBerichtForm.berichtenListClick(Sender: TObject);
var
	i: integer;
begin
end;

end.
