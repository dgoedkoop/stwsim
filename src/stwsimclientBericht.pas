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
	 wisBut: TButton;
	 treinCaption: TLabel;
	 cancelBut: TButton;
	 procedure FormShow(Sender: TObject);
	 procedure berichtenListClick(Sender: TObject);
    procedure replyButClick(Sender: TObject);
    procedure wisButClick(Sender: TObject);
    procedure berichtenListDblClick(Sender: TObject);
	private
		selMsg: PvMessage;
		procedure Reshow;
	public
//		SendMsg:	PvSendMsg;
		Core:		PvCore;
	end;

var
  stwscBerichtForm: TstwscBerichtForm;

implementation

uses stwsimclientTreinMsg;

{$R *.DFM}

procedure TstwscBerichtForm.Reshow;
var
	Msg: PvMessage;
	u,m,s: integer;
	us,ms,ss: string;
begin
	berichtenList.Items.Clear;
	berichtMemo.Lines.Clear;
	Msg := Core^.vAlleBerichten;
	if not assigned(msg) then
		ModalResult := mrCancel;
	while assigned(msg) do begin
		FmtTijd(Msg^.Tijd, u,m,s);
		str(u,us); if length(us)=1 then us := '0'+us;
		str(m,ms); if length(ms)=1 then ms := '0'+ms;
		str(s,ss); if length(ss)=1 then ss := '0'+ss;
		berichtenList.Items.Add(us+':'+ms+':'+ss+'   Trein: '+Msg^.Trein);
		msg := msg^.Volgende;
	end;
	selMsg := nil;
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
	selMsg := Core^.vAlleBerichten;
	for i := 1 to berichtenList.ItemIndex do
		selmsg := selmsg^.Volgende;
	berichtMemo.Lines.Clear;
	berichtMemo.Lines.Add(selmsg^.Bericht);
	if copy(berichtMemo.Text, length(berichtMemo.Text)-1, 2) = #13#10 then
		berichtMemo.Text := copy(berichtMemo.Text, 1, length(berichtMemo.Text)-2);
end;

procedure TstwscBerichtForm.replyButClick(Sender: TObject);
begin
	if not assigned(selMsg) then exit;
	stwscTreinMsgForm.treinnr := selMsg^.Trein;
	if stwscTreinMsgForm.ShowModal = mrOK then begin
		DeleteBericht(Core, selMsg);
		Reshow;
	end;
end;

procedure TstwscBerichtForm.wisButClick(Sender: TObject);
begin
	if not assigned(selMsg) then exit;
	DeleteBericht(Core, selMsg);
	Reshow;
end;

procedure TstwscBerichtForm.berichtenListDblClick(Sender: TObject);
begin
	replyButClick(Sender);
end;

end.
