unit stwsimServerTreinDienst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, stwpCore, stwpRijplan, stwvMisc, stwpTijd;

type
  TstwssTreinDienstForm = class(TForm)
	 puntenList: TListBox;
	 puntAddBut: TButton;
	 puntEditbut: TButton;
	 puntDelBut: TButton;
	 okBut: TButton;
    TreinnrLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure puntAddButClick(Sender: TObject);
	 procedure puntEditbutClick(Sender: TObject);
	 procedure puntDelButClick(Sender: TObject);
	private
		{ Private declarations }
		function Sort_Merge(links, rechts: PpRijplanpunt): PpRijplanpunt;
		function Sort_List(Punt: PpRijplanpunt): PpRijplanPunt;
	public
		Core: TpCore;
		Dienst: PpTreindienst;
		procedure UpdateLijst;
		procedure PropagEditWindow(Punt: PpRijplanPunt);
		function FmtPuntFromEdit(var Punt: PpRijplanPunt): boolean;
		procedure Sorteer;
	end;

var
  stwssTreinDienstForm: TstwssTreinDienstForm;

implementation

uses stwsimserverBewerkPlanpunt;

{$R *.DFM}

function TstwssTreinDienstForm.Sort_Merge;
var
	first, last: PpRijplanpunt;
	lmt, rmt: integer;
begin
	first := nil;
	last := nil;
	while assigned(Links) and assigned(Rechts) do begin
		if (Links^.Aankomst > -1) and (Links^.Vertrek > -1) then
			lmt := (Links^.Aankomst+Links^.Vertrek) div 2
		else if Links^.Aankomst > -1 then
			lmt := Links^.Aankomst
		else if Links^.Vertrek > -1 then
			lmt := Links^.Vertrek
		else
			lmt := -1;
		if (Rechts^.Aankomst > -1) and (Rechts^.Vertrek > -1) then
			rmt := (Rechts^.Aankomst+Rechts^.Vertrek) div 2
		else if Rechts^.Aankomst > -1 then
			rmt := Rechts^.Aankomst
		else if Rechts^.Vertrek > -1 then
			rmt := Rechts^.Vertrek
		else
			rmt := -1;
		if (lmt <= rmt) then begin
			if assigned(first) then begin
				last^.Volgende := Links;
				Last := Last^.Volgende;
				Links := Links^.Volgende;
			end else begin
				first := links;
				last := links;
				Links := Links^.Volgende;
			end;
			Last^.Volgende := nil;
		end else begin
			if assigned(first) then begin
				last^.Volgende := Rechts;
				Last := Last^.Volgende;
				Rechts := Rechts^.Volgende;
			end else begin
				first := Rechts;
				last := Rechts;
				Rechts := Rechts^.Volgende;
			end;
			Last^.Volgende := nil;
		end;
	end;
	while assigned(Links) do begin
		if assigned(first) then begin
			last^.Volgende := Links;
			Last := Last^.Volgende;
			Links := Links^.Volgende;
		end else begin
			first := links;
			last := links;
			Links := Links^.Volgende;
		end;
		Last^.Volgende := nil;
	end;
	while assigned(Rechts) do begin
		if assigned(first) then begin
			last^.Volgende := Rechts;
			Last := Last^.Volgende;
			Rechts := Rechts^.Volgende;
		end else begin
			first := Rechts;
			last := Rechts;
			Rechts := Rechts^.Volgende;
		end;
		Last^.Volgende := nil;
	end;
	result := first;
end;

function TstwssTreinDienstForm.Sort_List;
var
	count, helft, i: integer;
	tmpPunt, hpPunt,
	links,rechts: PpRijplanPunt;
begin
	result := Punt;
	if not assigned(Punt) then exit;
	if not assigned(Punt^.Volgende) then exit;

	tmpPunt := Punt;
	count := 0;
	while assigned(tmpPunt) do begin
		inc(count);
		tmpPunt := tmpPunt^.Volgende;
	end;

	helft := count div 2;
	tmpPunt := Punt;
	for i := 2 to helft do
		tmpPunt := tmpPunt^.Volgende;
	hpPunt := tmpPunt^.Volgende;
	tmpPunt^.Volgende := nil;

	links := Sort_List(Punt);
	rechts := Sort_List(hpPunt);
	result := Sort_Merge(links, rechts);
end;

procedure TstwssTreinDienstForm.Sorteer;
begin
	Dienst^.Planpunten := Sort_List(Dienst^.Planpunten);
end;

function TstwssTreinDienstForm.FmtPuntFromEdit;
var
	i, u,m,s, code: integer;
begin with stwssPlanpuntBewerkForm do begin
	result := false;
	Punt^.Station := stationEdit.Text;
	Punt^.Perron := perronEdit.Text;
	if aankCheck.Checked then begin
		val(aanUurEdit.Text, u, code); if code <> 0 then exit;
		val(aanMinEdit.Text, m, code); if code <> 0 then exit;
		Punt^.Aankomst := MkTijd(u,m,0);
	end else
		Punt^.Aankomst := -1;
	if vertrCheck.Checked then begin
		val(vertrUurEdit.Text, u, code); if code <> 0 then exit;
		val(vertrMinEdit.Text, m, code); if code <> 0 then exit;
		Punt^.Vertrek := MkTijd(u,m,0);
	end else
		Punt^.Vertrek := -1;
	if AankCheck.Checked and StopCheck.Checked then begin
		val(wachtMinEdit.Text, m, code); if code <> 0 then exit;
		val(wachtSecEdit.Text, s, code); if code <> 0 then exit;
		Punt^.minwachttijd := MkTijd(0,m,s);
		Punt^.stoppen := StopCheck.Checked;
	end else begin
		Punt^.minwachttijd := -1;
		Punt^.stoppen := false;
	end;
	Punt^.samenvoegen := koppelCheck.Checked;
	Punt^.keren := kerenCheck.Checked;
	val(loskAantalEdit.Text,i, code); if code <> 0 then exit;
	Punt^.loskoppelen := i;
	Punt^.loskoppelen_w := loskTreinnrEdit.Text;
	Punt^.loskoppelen_keren := loskKerenCheck.Checked;
	Punt^.nieuwetrein_w := nieuwnrEdit.Text;
	Punt^.nieuwetrein := Punt^.nieuwetrein_w <> '';
	result := true;
end end;

procedure TstwssTreinDienstForm.PropagEditWindow;
var
	u,m,s: integer;
	us,ms,ss: string;
begin with stwssPlanpuntBewerkForm do begin
	stationEdit.Text := Punt^.Station;
	perronEdit.Text := Punt^.Perron;
	if Punt^.Aankomst >= 0 then begin
		FmtTijd(Punt^.Aankomst, u, m, s);
		str(u, us); str(m, ms); if length(ms)=1 then ms:='0'+ms;
		aanUurEdit.Text := us;
		aanMinEdit.Text := ms;
		aankCheck.Checked := true;
	end else begin
		aanUurEdit.Text := '';
		aanMinEdit.Text := '';
		aankCheck.Checked := false;
	end;
	if Punt^.Vertrek >= 0 then begin
		FmtTijd(Punt^.Vertrek, u, m, s);
		str(u, us); str(m, ms); if length(ms)=1 then ms:='0'+ms;
		vertrUurEdit.Text := us;
		vertrMinEdit.Text := ms;
		vertrCheck.Checked := true;
	end else begin
		vertrUurEdit.Text := '';
		vertrMinEdit.Text := '';
		vertrCheck.Checked := false;
	end;
	if Punt^.stoppen then begin
		FmtTijd(Punt^.minwachttijd, u, m, s); m := u*60+m;
		str(m, ms); str(s, ss); if length(ss)=1 then ss:='0'+ss;
		wachtMinEdit.Text := ms;
		wachtSecEdit.Text := ss;
	end else begin
		wachtMinEdit.Text := '';
		wachtSecEdit.Text := '';
	end;
	StopCheck.Checked := Punt^.stoppen;
	koppelCheck.Checked := Punt^.samenvoegen;
	kerenCheck.Checked := Punt^.keren;
	loskAantalEdit.Text := inttostr(Punt^.loskoppelen);
	loskTreinnrEdit.Text := Punt^.loskoppelen_w;
	loskKerenCheck.Checked := Punt^.loskoppelen_keren;
	nieuwnrEdit.Text := Punt^.nieuwetrein_w;
end end;

procedure TstwssTreinDienstForm.UpdateLijst;
var
	i: integer;
	Punt: PpRijplanPunt;
begin
	i := 0;
	Punt := Dienst^.Planpunten;
	while assigned(Punt) do begin
		inc(i);
		if i < puntenList.Items.Count then
			puntenList.Items[i] := RijpuntLijstStr(Punt, rlsEdit)
		else
			puntenList.Items.Add(RijpuntLijstStr(Punt, rlsEdit));
		Punt := Punt^.Volgende;
	end;
	while puntenList.Items.Count > i+1 do
		puntenList.Items.Delete(puntenList.Items.Count-1);
end;

procedure TstwssTreinDienstForm.FormShow(Sender: TObject);
begin
	TreinnrLabel.Font.Name := 'Verdana';
	TreinnrLabel.Font.Size := 14;
	TreinnrLabel.Font.Style := [fsBold];
	TreinnrLabel.Caption := 'Trein '+Dienst^.Treinnummer;
	UpdateLijst;
	ActiveControl := PuntenList;
end;

procedure TstwssTreinDienstForm.FormCreate(Sender: TObject);
begin
	stwssPlanpuntBewerkForm := TstwssPlanpuntBewerkForm.Create(Self);
end;

procedure TstwssTreinDienstForm.puntAddButClick(Sender: TObject);
var
	Punt, tmpPunt: PpRijplanPunt;
begin
	new(Punt);
	Punt^.Station := '';
	Punt^.Perron := '';
	Punt^.Aankomst := 0;
	Punt^.Vertrek := 0;
	Punt^.minwachttijd := MkTijd(0,0,30);
	Punt^.stoppen := true;
	Punt^.spc_gedaan := false;
	Punt^.keren := false;
	Punt^.nieuwetrein := false;
	Punt^.nieuwetrein_w := '';
	Punt^.loskoppelen := 0;
	Punt^.loskoppelen_w := '';
	Punt^.loskoppelen_keren := false;
	Punt^.samenvoegen := false;
	Punt^.volgende := nil;
	PropagEditWindow(Punt);
	if stwssPlanpuntBewerkForm.ShowModal = mrOK then begin
		if FmtPuntFromEdit(Punt) then begin
			if not assigned(Dienst^.Planpunten) then
				Dienst^.Planpunten := Punt
			else begin
				tmpPunt := Dienst^.Planpunten;
				while assigned(tmpPunt^.Volgende) do
					tmpPunt := tmpPunt^.Volgende;
				tmpPunt^.Volgende := Punt;
			end;
			Sorteer;
			UpdateLijst;
		end else begin
			Application.MessageBox('Ongeldige invoer.', 'Fout!', MB_ICONERROR);
			dispose(Punt);
		end;
	end else
		dispose(Punt);
end;

procedure TstwssTreinDienstForm.puntEditbutClick(Sender: TObject);
var
	i: integer;
	Punt, tmpPunt, tmpVolgende: PpRijplanPunt;
begin
	if puntenList.ItemIndex < 1 then exit;
	Punt := Dienst^.Planpunten;
	for i := 2 to puntenList.ItemIndex do
		Punt := Punt^.Volgende;
	PropagEditWindow(Punt);
	if stwssPlanpuntBewerkForm.ShowModal = mrOK then begin
		new(tmpPunt);
		if FmtPuntFromEdit(tmpPunt) then begin
			tmpVolgende := Punt^.Volgende;
			Punt^ := tmpPunt^;
			Punt^.Volgende := tmpVolgende;
		end else begin
			Application.MessageBox('Ongeldige invoer.', 'Fout!', MB_ICONERROR);
			dispose(tmpPunt);
		end;
	end;
	Sorteer;
	UpdateLijst;
end;

procedure TstwssTreinDienstForm.puntDelButClick(Sender: TObject);
var
	i: integer;
	Punt, vPunt: PpRijplanPunt;
begin
	if puntenList.ItemIndex < 1 then exit;
	Punt := Dienst^.Planpunten;
	vPunt := nil;
	for i := 2 to puntenList.ItemIndex do begin
		vPunt := Punt;
		Punt := Punt^.Volgende;
	end;
	// En het item zelf wissen.
	if assigned(vPunt) then begin
		vPunt^.Volgende := Punt^.Volgende;
		dispose(Punt);
	end else begin
		Dienst^.Planpunten := Punt^.Volgende;
		dispose(Punt);
	end;
	UpdateLijst;
end;

end.
