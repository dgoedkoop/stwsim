unit stwsimclientTreinMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, clientSendMsg;

type
  TstwscTreinMsgForm = class(TForm)
	 okBut: TButton;
	 cancelBut: TButton;
	 watList: TListBox;
	 Label1: TLabel;
	 procedure okButClick(Sender: TObject);
	 procedure FormShow(Sender: TObject);
    procedure watListDblClick(Sender: TObject);
  private
	 { Private declarations }
	public
		SendMsg:	TvSendMsg;
		treinnr:	string;
	end;

var
  stwscTreinMsgForm: TstwscTreinMsgForm;

implementation

uses stwsimClientNieuwPlanpunt, stwsimclientRA, stwsimclientNieuweDienst;

{$R *.DFM}

const
	stsp   = 'Lastgeving STS-passage verstrekken';
	stspa  = 'Lastgeving STS-passage intrekken';
	vnstsp = 'Rijd voorzichtig op zicht verder (na STS-passage zonder lastgeving)';
	wtt2   = 'Wacht nog even, u kunt zometeen verder.';
	wtt5   = 'Wacht nog even, u kunt binnen 5 minuten verder.';
	wtt15  = 'Wacht, het kan nog wel een kwartier duren voordat u verder kunt.';
	ra		 = 'Sla het huidige dienstregelingpunt over';
	raw	 = 'Sla dienstregelingpunt ... over';
	nr		 = 'Nieuw dienstregelingpunt ...';
	lr		 = 'Rijd verder met nieuwe dienstregeling en nieuw treinnummer ...';

function CheckInput(s: string): boolean;
begin
	result :=
	(pos(#$0A, s)=0) and
	(pos(',', s)=0) and
	(pos(':', s)=0)
end;

procedure TstwscTreinMsgForm.okButClick(Sender: TObject);
var
	msg: string;
	wat: string;
begin
	if watList.ItemIndex = -1 then exit;
	msg := '';
	wat := watList.Items[watList.ItemIndex];
	if wat = stsp then 	msg := 'stsp';
	if wat = stspa then	msg := 'stspa';
	if wat = vnstsp then msg := 'vnstsp';
	if wat = wtt2 then msg := 'wtt,2';
	if wat = wtt5 then msg := 'wtt,5';
	if wat = wtt15 then msg := 'wtt,15';
	if wat = ra then msg := 'ra,';
	if wat = raw then
		if stwscRAform.showmodal = mrOK then
			if CheckInput(stwscRAform.stationEdit.Text) then
				msg := 'ra,'+stwscRAform.stationEdit.Text
			else
				Application.MessageBox('Ongeldige invoer.','Fout',mb_iconerror);
	if wat = lr then
		if stwscNieuweDienstForm.showmodal = mrOK then
			if CheckInput(stwscNieuweDienstForm.treinnrEdit.Text) then
				if stwscNieuweDienstForm.vanCheck.Checked then
					if CheckInput(stwscNieuweDienstForm.vanEdit.Text) then
						msg := 'rl,'+stwscNieuweDienstForm.treinnrEdit.Text+','+
							stwscNieuweDienstForm.vanEdit.Text
					else
						Application.MessageBox('Ongeldig vanaf-station.','Fout',mb_iconerror)
				else
					msg := 'rl,'+stwscNieuweDienstForm.treinnrEdit.Text
			else
				Application.MessageBox('Ongeldig treinnummer.','Fout',mb_iconerror);
	if wat = nr then with stwscNieuwPlanpuntForm do begin
		if stwscNieuwPlanpuntForm.ShowModal = mrOK then begin
			msg := 'nr,';
			if not
				CheckInput(invStationEdit.Text+StationEdit.Text+PerronEdit.Text+
				aanUurEdit.Text+aanMinEdit.Text+vertrUurEdit.Text+vertrMinEdit.Text+
				loskAantalEdit.Text+loskTreinnrEdit.Text+nieuwnrEdit.Text) then begin
				Application.MessageBox('Ongeldige invoer.','Fout',mb_iconerror);
				exit;
			end;
			if invStationEdit.Text = '' then
				msg := msg + '-,'
			else
				msg := msg + invStationEdit.Text+',';
			if not aankCheck.Checked then
				msg := msg + '-,'
			else
				msg := msg + aanUurEdit.Text+':'+aanMinEdit.Text+',';
			if not vertrCheck.Checked then
				msg := msg + '-,'
			else
				msg := msg + vertrUurEdit.Text+':'+vertrMinEdit.Text+',';
			if StationEdit.Text = '' then
				msg := msg + '-,'
			else
				msg := msg + StationEdit.Text+',';
			if PerronEdit.Text = '' then
				msg := msg + '-,'
			else
				msg := msg + PerronEdit.Text+',';
			if StopCheck.Checked then
				msg := msg + 'j,'
			else
				msg := msg + 'n,';
			if koppelCheck.Checked then
				msg := msg + 'j,'
			else
				msg := msg + 'n,';
			if kerenCheck.Checked then
				msg := msg + 'j,'
			else
				msg := msg + 'n,';
			msg := msg + loskAantalEdit.Text+',';
			if loskKerenCheck.Checked then
				msg := msg + 'j,'
			else
				msg := msg + 'n,';
			if loskTreinnrEdit.Text = '' then
				msg := msg + '-,'
			else
				msg := msg + loskTreinnrEdit.Text+',';
			if nieuwnrEdit.Text = '' then
				msg := msg + '-'
			else
				msg := msg + nieuwnrEdit.Text;
		end;
	end;
	if msg = '' then exit;
	SendMsg.SendTreinMsg(treinnr, msg);
	modalResult := mrOK;
end;

procedure TstwscTreinMsgForm.FormShow(Sender: TObject);
begin
	watList.Items.Clear;
	watList.Items.Add(stsp);
	watList.Items.Add(stspa);
	watList.Items.Add(vnstsp);
	watList.Items.Add(wtt2);
	watList.Items.Add(wtt5);
	watList.Items.Add(wtt15);
	watList.Items.Add(ra);
	watList.Items.Add(raw);
	watList.Items.Add(nr);
	watList.Items.Add(lr);
	watList.ItemIndex := -1;
	ActiveControl := okBut;
end;

procedure TstwscTreinMsgForm.watListDblClick(Sender: TObject);
begin
	okButClick(Sender);
end;

end.
