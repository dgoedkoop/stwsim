unit stwsimclientTelefoon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, clientSendMsg, stwvCore, stwvTreinComm, stwpTijd;

type
  TstwscTelefoonForm = class(TForm)
	 gesprekkenList: TListBox;
	 opneemBut: TButton;
	 treinCaption: TLabel;
	 cancelBut: TButton;
	 belBut: TButton;
	 weigerBut: TButton;
	 procedure FormShow(Sender: TObject);
	 procedure gesprekkenListClick(Sender: TObject);
	 procedure opneemButClick(Sender: TObject);
	 procedure gesprekkenListDblClick(Sender: TObject);
	 procedure weigerButClick(Sender: TObject);
    procedure belButClick(Sender: TObject);
	private
		selGesprek: PvBinnenkomendGesprek;
	public
		Core:		PvCore;
		SendMsg:	TvSendMsg;
		procedure Reshow;
 	end;

var
  stwscTelefoonForm: TstwscTelefoonForm;

implementation

uses stwsimclientTelefoonGesprek, stwsimclientTelefoonBel;

{$R *.DFM}

procedure TstwscTelefoonForm.Reshow;
var
	Gesprek: PvBinnenkomendGesprek;
begin
	gesprekkenList.Items.Clear;
	Gesprek := Core^.vAlleBinnenkomendeGesprekken;
	if not assigned(Gesprek) then
		ModalResult := mrCancel;
	while assigned(Gesprek) do begin
		if Gesprek^.MetWie.wat = 't' then
			gesprekkenList.Items.Add('Trein '+Gesprek^.MetWie.ID);
		if Gesprek^.MetWie.wat = 'r' then
			gesprekkenList.Items.Add('Storingsdienst');
		Gesprek := Gesprek^.Volgende;
	end;
	selGesprek := nil;

	OpneemBut.Enabled := false;
   weigerBut.Enabled := false;
end;

procedure TstwscTelefoonForm.FormShow(Sender: TObject);
begin
	Reshow;
	ActiveControl := gesprekkenList;
end;

procedure TstwscTelefoonForm.gesprekkenListClick(Sender: TObject);
var
	i: integer;
begin
	selGesprek := Core^.vAlleBinnenkomendeGesprekken;
	for i := 1 to GesprekkenList.ItemIndex do
		selGesprek := selGesprek^.Volgende;

	OpneemBut.Enabled := true;
	weigerBut.Enabled := true;
end;

procedure TstwscTelefoonForm.opneemButClick(Sender: TObject);
var
	metwie:  TvMessageWie;
begin
	if not assigned(selGesprek) then exit;
	// Bericht uit rij halen
	metwie := selGesprek^.MetWie;
	DeleteBinnenkomendGesprek(Core, selGesprek^.MetWie);
	Reshow;
	// En verwerken.
	SendMsg.SendOpnemen(MetWie);
	stwscTelefoonGesprekForm.metwie := MetWie;
	stwscTelefoongesprekForm.GesprekInit;
	stwscTelefoongesprekForm.GesprekStart;
	stwscTelefoonGesprekForm.ShowModal;
end;

procedure TstwscTelefoonForm.gesprekkenListDblClick(Sender: TObject);
begin
	opneemButClick(Sender);
end;

procedure TstwscTelefoonForm.weigerButClick(Sender: TObject);
var
	metwie:  TvMessageWie;
begin
	if not assigned(selGesprek) then exit;
	// Bericht uit rij halen
	metwie := selGesprek^.MetWie;
	DeleteBinnenkomendGesprek(Core, selGesprek^.MetWie);
	Reshow;
	SendMsg.SendOphangen(MetWie);
end;

procedure TstwscTelefoonForm.belButClick(Sender: TObject);
begin
	if stwscTelefoonBelForm.ShowModal = mrOK then
		if stwscTelefoonBelForm.monteurRadio.Checked then begin
			stwscTelefoongesprekForm.metwie.wat := 'r';
			stwscTelefoongesprekForm.GesprekInit;
			SendMsg.SendBel(stwscTelefoongesprekForm.metwie);
			stwscTelefoongesprekForm.GaatOver;
			stwscTelefoongesprekForm.ShowModal;
		end;
end;

end.
