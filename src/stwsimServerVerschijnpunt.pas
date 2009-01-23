unit stwsimServerVerschijnpunt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, stwpCore, stwpVerschijnLijst, stwpTijd, stwpTreinen;

type
  TstwssVerschijnpuntForm = class(TForm)
    minedit: TEdit;
    Label4: TLabel;
    uuredit: TEdit;
    Label3: TLabel;
    Label1: TLabel;
    treinnredit: TEdit;
    Label2: TLabel;
    plaatsCombo: TComboBox;
    Label5: TLabel;
    vdwTreinnrEdit: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
	 vdwWachtEdit: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    okbut: TButton;
    matList: TListBox;
    matCombo: TComboBox;
    andersomCheck: TCheckBox;
	 matToevBut: TButton;
	 matDelBut: TButton;
	 Label11: TLabel;
    hbut: TButton;
    lbut: TButton;
    procedure treinnreditChange(Sender: TObject);
    procedure uureditChange(Sender: TObject);
    procedure plaatsComboChange(Sender: TObject);
    procedure matToevButClick(Sender: TObject);
    procedure matDelButClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure hbutClick(Sender: TObject);
    procedure lbutClick(Sender: TObject);
	private
		{ Private declarations }
		VerschijnItem: PpVerschijnItem;
	public
		Core: TpCore;
		procedure UpdateWagons;
		procedure SetEntries(VI: PpVerschijnItem);
	end;

var
  stwssVerschijnpuntForm: TstwssVerschijnpuntForm;

implementation

{$R *.DFM}

procedure TstwssVerschijnpuntForm.UpdateWagons;
var
	WagonConn: 	PpWagonConn;
	voorstr, achterstr: string;
begin
	matList.Items.Clear;
	WagonConn := VerschijnItem^.wagons;
	while assigned(WagonConn) do begin
		if not WagonConn^.omgekeerd then begin
			if WagonConn^.wagon^.bedienbaar then
				VoorStr := '<<'
			else
				VoorStr := '';
			if WagonConn^.wagon^.twbedienbaar then
				AchterStr := '>'
			else
				AchterStr := '';
		end else begin
			if WagonConn^.wagon^.twbedienbaar then
				VoorStr := '<'
			else
				VoorStr := '';
			if WagonConn^.wagon^.bedienbaar then
				AchterStr := '>>'
			else
				AchterStr := '';
		end;
		matList.Items.Add(VoorStr+WagonConn^.Wagon^.naam+AchterStr);
		WagonConn := WagonConn^.Volgende;
	end;
end;

procedure TstwssVerschijnpuntForm.SetEntries;
var
	VP: 			PpVerschijnPunt;
	Matfile: 	PpMaterieelFile;
	Wagon: 		PpWagon;
	u,m,s: 		integer;
	us,ms: 		string;
	i:				integer;
begin
	VerschijnItem := VI;
	// Eerst bepaalde vakjes initialiseren
	plaatsCombo.Items.Clear;
	VP := Core.pAlleVerschijnpunten;
	while assigned(VP) do begin
		plaatsCombo.Items.Add(VP^.Naam);
		VP := VP^.Volgende;
	end;
	matCombo.Items.Clear;
	Matfile := Core.pMaterieel;
	while assigned(Matfile) do begin
		Wagon := Matfile^.Wagons;
		while assigned(Wagon) do begin
			matCombo.Items.Add(Wagon^.naam);
			Wagon := Wagon^.Volgende;
		end;
		Matfile := Matfile^.Volgende;
	end;
	// Dan alle ingevulde gegevens weergeven
	treinnrEdit.Text := VerschijnItem^.Treinnummer;
	FmtTijd(VerschijnItem^.Tijd, u, m, s);
	str(u,us); str(m,ms); if length(ms)=1 then ms := '0'+ms;
	UurEdit.Text := us;
	MinEdit.Text := ms;
	if assigned(VerschijnItem^.Plaats) then begin
		for i := 0 to plaatsCombo.Items.Count-1 do
			if plaatsCombo.Items[i] = VerschijnItem^.Plaats^.Naam then
				plaatsCombo.ItemIndex := i
	end else
		plaatsCombo.ItemIndex := -1;
	UpdateWagons;
	vdwTreinnrEdit.Text := VerschijnItem^.treinweg_naam;
	str(VerschijnItem^.treinweg_wachten, ms);
	vdwWachtEdit.Text := ms;
end;

procedure TstwssVerschijnpuntForm.treinnreditChange(Sender: TObject);
begin
	VerschijnItem^.Treinnummer := treinnrEdit.Text;
end;

procedure TstwssVerschijnpuntForm.uureditChange(Sender: TObject);
var
	u,m, code: integer;
begin
	val(UurEdit.Text, u, code);
	val(MinEdit.Text, m, code);
	VerschijnItem^.Tijd := MkTijd(u,m,0);
end;

procedure TstwssVerschijnpuntForm.plaatsComboChange(Sender: TObject);
var
	Plaats: PpVerschijnPunt;
	i: integer;
begin
	Plaats := Core.pAlleVerschijnpunten;
	for i := 1 to plaatsCombo.ItemIndex do
		Plaats := Plaats^.Volgende;
	VerschijnItem^.Plaats := Plaats;
end;

procedure TstwssVerschijnpuntForm.matToevButClick(Sender: TObject);
var
	Matfile: PpMaterieelFile;
	Wagon: PpWagon;
	i: integer;
	WagonConn: PpWagonConn;
	lastConn: PpWagonConn;
begin
	Matfile := Core.pMaterieel;
	Wagon := Matfile^.Wagons;
	for i := 1 to matCombo.ItemIndex do begin
		Wagon := Wagon^.Volgende;
		if not assigned(Wagon) then begin
			Matfile := Matfile^.Volgende;
			Wagon := Matfile^.Wagons;
		end;
	end;
	new(WagonConn);
	WagonConn^.volgende := nil;
	WagonConn^.wagon := Wagon;
	WagonConn^.omgekeerd := andersomCheck.Checked;
	lastConn := VerschijnItem^.wagons;
	if not assigned(lastConn) then begin
		WagonConn^.vorige := nil;
		VerschijnItem^.wagons := WagonConn;
	end else begin
		while assigned(lastConn^.Volgende) do
			lastConn := lastConn^.Volgende;
		lastConn^.Volgende := WagonConn;
		WagonConn^.Vorige := lastConn;
	end;
	UpdateWagons;
end;

procedure TstwssVerschijnpuntForm.matDelButClick(Sender: TObject);
var
	i: integer;
	Conn: PpWagonConn;
begin
	if matList.ItemIndex = -1 then exit;
	Conn := VerschijnItem^.wagons;
	for i := 1 to matList.ItemIndex do
		Conn := Conn^.Volgende;
	if assigned(Conn^.Volgende) then
		Conn^.Volgende^.Vorige := Conn^.Vorige;
	if assigned(Conn^.Vorige) then begin
		Conn^.Vorige^.Volgende := Conn^.Volgende;
		dispose(Conn);
	end else begin
		VerschijnItem^.wagons := Conn^.Volgende;
		dispose(Conn);
	end;
	UpdateWagons;
end;

procedure TstwssVerschijnpuntForm.FormShow(Sender: TObject);
begin
	ActiveControl := treinnredit;
end;

procedure TstwssVerschijnpuntForm.hbutClick(Sender: TObject);
var
	i: integer;
	Conn1, Conn2, Conn3, Conn4: PpWagonConn;
	vorIndex: integer;
begin
	if matList.ItemIndex < 1 then exit;
	vorIndex := matList.ItemIndex;
	Conn3 := VerschijnItem^.wagons;
	for i := 1 to matList.ItemIndex do
		Conn3 := Conn3^.Volgende;
	Conn2 := Conn3^.Vorige;
	Conn1 := Conn2^.Vorige;
	Conn4 := Conn3^.Volgende;
	if assigned(Conn1) then
		Conn1^.Volgende := Conn3
	else
		VerschijnItem^.wagons := Conn3;
	Conn2^.Vorige := Conn3;
	Conn2^.Volgende := Conn4;
	Conn3^.Vorige := Conn1;
	Conn3^.Volgende := Conn2;
	if assigned(Conn4) then
		Conn4^.Vorige := Conn2;
	UpdateWagons;
	matList.ItemIndex := vorIndex-1
end;

procedure TstwssVerschijnpuntForm.lbutClick(Sender: TObject);
var
	i: integer;
	Conn1, Conn2, Conn3, Conn4: PpWagonConn;
	vorIndex: integer;
begin
	if (matList.ItemIndex = -1) or
		(matList.ItemIndex = matList.Items.Count-1) then exit;
	vorIndex := matList.ItemIndex;
	Conn2 := VerschijnItem^.wagons;
	for i := 1 to matList.ItemIndex do
		Conn2 := Conn2^.Volgende;
	Conn3 := Conn2^.Volgende;
	Conn1 := Conn2^.Vorige;
	Conn4 := Conn3^.Volgende;
	if assigned(Conn1) then
		Conn1^.Volgende := Conn3
	else
		VerschijnItem^.wagons := Conn3;
	Conn2^.Vorige := Conn3;
	Conn2^.Volgende := Conn4;
	Conn3^.Vorige := Conn1;
	Conn3^.Volgende := Conn2;
	if assigned(Conn4) then
		Conn4^.Vorige := Conn2;
	UpdateWagons;
	matList.ItemIndex := vorIndex+1;
end;

end.
