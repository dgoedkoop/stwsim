unit stwsimclientTelefoongesprek;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, clientSendMsg, stwvTreinComm, stwpTijd;

type
	TGesprekStatus = (gsOvergaan, gsVerbonden, gsVerwachtAntwoord, gsOpgehangen);

	TstwscTelefoonGesprekForm = class(TForm)
		okBut: TButton;
		ophangBut: TButton;
		watList: TListBox;
		Label1: TLabel;
		berichtMemo: TMemo;
		Label2: TLabel;
		procedure okButClick(Sender: TObject);
		procedure watListDblClick(Sender: TObject);
		procedure ophangButClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure FormCreate(Sender: TObject);
	private
		{ Private declarations }
		procedure AddLine(msg: String);
		procedure UpdateControls;
	public
		GesprekStatus:	TGesprekStatus;
		SendMsg:	TvSendMsg;
		metwie:  TvMessageWie;

		procedure GesprekInit;
		procedure GaatOver;
		procedure GesprekStart;
		procedure Bericht(Soort: TvMessageSoort; msg: string);
		procedure Opgehangen;
	end;

var
	stwscTelefoonGesprekForm: TstwscTelefoonGesprekForm;

implementation

uses stwsimclientNieuweDienst, stwsimClientNieuwPlanpunt,
	stwsimClientStringInput;

{$R *.DFM}

const
	stsp	 = 'Aanwijzing STS-passage verstrekken... Over.';
	stspa	 = 'Aanwijzing STS-passage intrekken. Over.';
	vnstsp = 'Rijd voorzichtig op zicht verder. Over.';
	wtt2	 = 'Wacht nog even, u kunt zometeen verder. Over.';
	wtt5	 = 'Wacht nog even, u kunt binnen 5 minuten verder. Over.';
	wtt15	 = 'Wacht, het kan nog wel een kwartier duren voordat u verder kunt. Over.';
	ra		 = 'Sla het huidige dienstregelingpunt over. Over.';
	raw	 = 'Sla dienstregelingpunt ... over. Over.';
	nr		 = 'Nieuw dienstregelingpunt ... Over.';
	lr		 = 'Rijd verder met nieuwe dienstregeling en nieuw treinnummer ... Over.';
	rw		 = 'Wissel ... repareren. Over.';
   kmb	 = 'Klaarmelding ontvangen! Over en sluiten.';
	ok		 = 'Begrepen! Over en sluiten.';

function CheckInput(s: string): boolean;
begin
	result :=
	(pos(#$0A, s)=0) and
	(pos(',', s)=0) and
	(pos(':', s)=0)
end;

procedure TstwscTelefoonGesprekForm.AddLine;
var
	u,m,s: integer;
	us,ms,ss: string;
begin
	FmtTijd(GetTijd, u,m,s);
	str(u,us); if length(us)=1 then us := '0'+us;
	str(m,ms); if length(ms)=1 then ms := '0'+ms;
	str(s,ss); if length(ss)=1 then ss := '0'+ss;
	berichtMemo.Lines.Add(us+':'+ms+':'+ss+'   '+msg);
end;

procedure TstwscTelefoonGesprekForm.UpdateControls;
begin
	watList.Enabled := GesprekStatus = gsVerwachtAntwoord;
	if watList.Enabled then begin
		watList.Color := clWindow;
		activeControl := watList
	end else
		watList.Color := clBtnFace;
	okBut.Enabled := GesprekStatus = gsVerwachtAntwoord;
	if not (GesprekStatus = gsVerwachtAntwoord) then
		watList.Items.Clear;
	if GesprekStatus = gsOpgehangen then
		activeControl := ophangBut;
end;

procedure TstwscTelefoonGesprekForm.GesprekInit;
begin
	berichtMemo.Lines.Clear;
	GesprekStatus := gsOpgehangen;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.GaatOver;
begin
	AddLine('Telefoon gaat over...');
	GesprekStatus := gsOvergaan;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.GesprekStart;
begin
	AddLine('Verbonden.');
	GesprekStatus := gsVerbonden;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.Bericht;
begin
	AddLine(msg);
	watList.Items.Clear;
	if Soort = vmsTreinStoptonend then begin
		watList.Items.Add(stsp);
		watList.Items.Add(wtt2);
		watList.Items.Add(wtt5);
		watList.Items.Add(wtt15);
		GesprekStatus := gsVerwachtAntwoord;
	end else
	if Soort = vmsTreinSTSpassage then begin
		watList.Items.Add(vnstsp);
		watList.Items.Add(wtt2);
		watList.Items.Add(wtt5);
		GesprekStatus := gsVerwachtAntwoord;
	end else
	if Soort = vmsKlaarmelding then begin
		watList.Items.Add(kmb);
		GesprekStatus := gsVerwachtAntwoord;
	end else
	if Soort = vmsVraagOK then begin
		watList.Items.Add(ok);
		GesprekStatus := gsVerwachtAntwoord;
	end else
	if Soort = vmsMonteurOpdracht then begin
		watList.Items.Add(rw);
		GesprekStatus := gsVerwachtAntwoord;
	end else
	if Soort = vmsTreinOpdracht then begin
		watList.Items.Add(stsp);
		watList.Items.Add(stspa);
		watList.Items.Add(ra);
		watList.Items.Add(raw);
		watList.Items.Add(nr);
		watList.Items.Add(lr);
		GesprekStatus := gsVerwachtAntwoord;
	end;
	watList.ItemIndex := -1;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.Opgehangen;
begin
	AddLine('Verbinding verbroken.');
	GesprekStatus := gsOpgehangen;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.okButClick(Sender: TObject);
var
	msg: string;
	wat: string;
	nieuwemetwie: TvMessageWie;
begin
	if watList.ItemIndex = -1 then exit;
	msg := '';
	nieuwemetwie := metwie;
	wat := watList.Items[watList.ItemIndex];
	if wat = stsp then begin
		stwscStringInputForm.Caption := 'Aanwijzing STS-passage';
		stwscStringInputForm.Inputlabel.Caption := 'Seinnummer:';
		stwscStringInputForm.InputEdit.Text := '';
		if stwscStringInputForm.showmodal = mrOK then
			if CheckInput(stwscStringInputForm.InputEdit.Text) then
				msg := 'stsp,'+stwscStringInputForm.InputEdit.Text
			else
				Application.MessageBox('Ongeldige invoer.','Fout',mb_iconerror);
	end;
	if wat = stspa then	msg := 'stspa';
	if wat = vnstsp then msg := 'vnstsp';
	if wat = kmb then msg := 'kmb';
	if wat = wtt2 then msg := 'wtt,2';
	if wat = wtt5 then msg := 'wtt,5';
	if wat = wtt15 then msg := 'wtt,15';
	if wat = ra then msg := 'ra,';
	if wat = raw then begin
		stwscStringInputForm.Caption := 'Rijplanpunt annuleren';
		stwscStringInputForm.Inputlabel.Caption := 'Station:';
		stwscStringInputForm.InputEdit.Text := '';
		if stwscStringInputForm.showmodal = mrOK then
			if CheckInput(stwscStringInputForm.InputEdit.Text) then
				msg := 'ra,'+stwscStringInputForm.InputEdit.Text
			else
				Application.MessageBox('Ongeldige invoer.','Fout',mb_iconerror);
	end else
	if wat = lr then
		if stwscNieuweDienstForm.showmodal = mrOK then
			if CheckInput(stwscNieuweDienstForm.treinnrEdit.Text) then
				if stwscNieuweDienstForm.vanCheck.Checked then
					if CheckInput(stwscNieuweDienstForm.vanEdit.Text) then begin
						nieuwemetwie.ID := stwscNieuweDienstForm.treinnrEdit.Text;
						msg := 'rl,'+stwscNieuweDienstForm.treinnrEdit.Text+','+
							stwscNieuweDienstForm.vanEdit.Text
					end else
						Application.MessageBox('Ongeldig vanaf-station.','Fout',mb_iconerror)
				else begin
					nieuwemetwie.ID := stwscNieuweDienstForm.treinnrEdit.Text;
					msg := 'rl,'+stwscNieuweDienstForm.treinnrEdit.Text
				end
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
	end else
	if wat = rw then begin
		stwscStringInputForm.Caption := 'Wissel repareren';
		stwscStringInputForm.Inputlabel.Caption := 'Wissel:';
		stwscStringInputForm.InputEdit.Text := '';
		if stwscStringInputForm.showmodal = mrOK then
			if CheckInput(stwscStringInputForm.InputEdit.Text) then
				msg := 'w,'+stwscStringInputForm.InputEdit.Text
			else
				Application.MessageBox('Ongeldige invoer.','Fout',mb_iconerror);
	end else
	if wat = ok then begin
		msg := 'ok';
	end;
	if (msg = '') and not (wat = ok) then exit;

	AddLine(wat);
	SendMsg.SendMsg(metwie, msg);
	metwie := nieuwemetwie;
	GesprekStatus := gsVerbonden;
	UpdateControls;
end;

procedure TstwscTelefoonGesprekForm.watListDblClick(Sender: TObject);
begin
	okButClick(Sender);
end;

procedure TstwscTelefoonGesprekForm.ophangButClick(Sender: TObject);
begin
	if GesprekStatus <> gsOpgehangen then begin
		AddLine('Verbinding verbroken.');
		SendMsg.SendOphangen(metwie);
		GesprekStatus := gsOpgehangen;
		UpdateControls;
	end;
	Close;
end;

procedure TstwscTelefoonGesprekForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	ophangButClick(Sender);
end;

procedure TstwscTelefoonGesprekForm.FormCreate(Sender: TObject);
begin
	GesprekStatus := gsOpgehangen;
end;

end.
