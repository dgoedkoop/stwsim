unit stwsimServerDienstreg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, stwpCore, stwpTijd, stwpTreinen, stwpVerschijnLijst, stwpRijplan;

type
  TstwssDienstregForm = class(TForm)
	 GroupBox1: TGroupBox;
	 Label1: TLabel;
	 Label2: TLabel;
	 startUurEdit: TEdit;
	 startMinEdit: TEdit;
	 GroupBox2: TGroupBox;
    matLoadBut: TButton;
    matDelBut: TButton;
    GroupBox3: TGroupBox;
    newTreinBut: TButton;
	 editTreinBut: TButton;
    delTreinBut: TButton;
    treinList: TListBox;
    GroupBox4: TGroupBox;
    nieuwVerschijnBut: TButton;
    editVerschijnBut: TButton;
	 delVerschijnBut: TButton;
    verschijnList: TListBox;
    copyTreinBut: TButton;
	 okBut: TButton;
    copyVerschijnBut: TButton;
	 stopMinEdit: TEdit;
	 Label3: TLabel;
	 stopUurEdit: TEdit;
	 Label5: TLabel;
	 matList: TListBox;
    treinNrBut: TButton;
	 procedure FormShow(Sender: TObject);
	 procedure startUurEditChange(Sender: TObject);
	 procedure stopUurEditChange(Sender: TObject);
	 procedure matLoadButClick(Sender: TObject);
	 procedure matDelButClick(Sender: TObject);
    procedure newTreinButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure nieuwVerschijnButClick(Sender: TObject);
    procedure editVerschijnButClick(Sender: TObject);
    procedure delVerschijnButClick(Sender: TObject);
    procedure copyVerschijnButClick(Sender: TObject);
    procedure treinNrButClick(Sender: TObject);
    procedure editTreinButClick(Sender: TObject);
    procedure delTreinButClick(Sender: TObject);
    procedure copyTreinButClick(Sender: TObject);
	private
		function Trn_Sort_Merge(links, rechts: PpTreindienst): PpTreindienst;
		function Trn_Sort_List(Dienst: PpTreindienst): PpTreindienst;
		function Vrs_Sort_Merge(links, rechts: PpVerschijnItem): PpVerschijnItem;
		function Vrs_Sort_List(VerschijnItem: PpVerschijnItem): PpVerschijnItem;
		procedure IncTreinnr(var treinnr: string; nrup: integer);
	public
		Core: TpCore;
		procedure UpdateDingen;
		procedure SorteerTreinen;
		procedure SorteerVerschijnitems;
		function MkVerschijnStr(VerschijnItem: PpVerschijnItem): string;
	end;

var
  stwssDienstregForm: TstwssDienstregForm;

implementation

uses stwsimserverAddMat, stwsimserverTreinnr, stwsimServerVerschijnpunt,
  stwsimserverTreinCopy, stwsimServerTreinDienst;

{$R *.DFM}

procedure TstwssDienstregForm.IncTreinnr;
var
	i: integer;
	si: string;
	code: integer;
begin
	if length(treinnr) = 0 then begin
		str(nrup, treinnr);
		exit;
	end;
	if length(treinnr) = 1 then begin
		val(treinnr,i,code);
		i := i + nrup;
		if i >= 0 then
			str(i, treinnr)
		else
			str(-i, treinnr);
		exit;
	end;
	val(copy(treinnr, length(treinnr)-1, 2), i, code);
	i := i + nrup;
	if i >= 0 then
		str(i, si)
	else
		str(-i, si);
	if length(si)=1 then si := '0'+si;
	treinnr := copy(treinnr, 1, length(treinnr)-2)+si;
end;

procedure TstwssDienstregForm.SorteerTreinen;
begin
	Core.pAlleDiensten := Trn_Sort_List(Core.pAlleDiensten);
end;

procedure TstwssDienstregForm.SorteerVerschijnitems;
begin
	Core.VerschijnLijst := Vrs_Sort_List(Core.VerschijnLijst);
end;

function TstwssDienstregForm.MkVerschijnStr;
var
	treinnr: string;
	entrypoint: string;
	entrytime: string;
	donestr: string;
begin
	treinnr := VerschijnItem^.Treinnummer;
	if assigned(VerschijnItem^.Plaats) then
		entrypoint := VerschijnItem^.Plaats^.Naam
	else
		entrypoint := 'ERR';
	entrytime := TijdStr(VerschijnItem^.Tijd, false);
	if VerschijnItem^.gedaan then
		donestr := ' GEDAAN'
	else
		donestr := '';
	result := treinnr + ' ('+entrytime+' - '+entrypoint+')'+donestr;
end;

procedure TstwssDienstregForm.UpdateDingen;
var
	u,m,s: integer;
	us,ms: string;
	MatFile: PpMaterieelFile;
	i: integer;
	Dienst: PpTreindienst;
	VerschijnItem: PpVerschijnItem;
begin
	// Begin- en eindtijd
	FmtTijd(Core.Starttijd, u, m, s);
	str(u, us); str(m, ms); if length(ms)=1 then ms := '0'+ms;
	startUurEdit.Text := us;
	startMinEdit.Text := ms;
	FmtTijd(Core.Stoptijd, u, m, s);
	str(u, us); str(m, ms); if length(ms)=1 then ms := '0'+ms;
	stopUurEdit.Text := us;
	stopMinEdit.Text := ms;
	// Materieel
	Matfile := Core.pMaterieel;
	i := 0;
	while assigned(Matfile) do begin
		inc(i);
		if MatList.Items.Count >= i then
			MatList.Items[i-1] := Matfile^.Filename
		else
			Matlist.Items.Add(Matfile^.Filename);
		Matfile := Matfile^.Volgende;
	end;
	while Matlist.Items.Count > i do
		Matlist.Items.Delete(Matlist.Items.Count-1);
	// Treinen
	Dienst := Core.pAlleDiensten;
	i := 0;
	while assigned(Dienst) do begin
		inc(i);
		if treinList.Items.Count >= i then
			treinList.Items[i-1] := Dienst^.Treinnummer
		else
			treinList.Items.Add(Dienst^.Treinnummer);
		Dienst := Dienst^.Volgende;
	end;
	while treinList.Items.Count > i do
		treinList.Items.Delete(treinList.Items.Count-1);
	// Verschijnen
	VerschijnItem := Core.VerschijnLijst;
	i := 0;
	while assigned(VerschijnItem) do begin
		inc(i);
		if verschijnList.Items.Count >= i then
			verschijnList.Items[i-1] := MkVerschijnStr(VerschijnItem)
		else
			verschijnList.Items.Add(MkVerschijnStr(VerschijnItem));
		VerschijnItem := VerschijnItem^.Volgende;
	end;
	while verschijnList.Items.Count > i do
		verschijnList.Items.Delete(verschijnList.Items.Count-1);
end;

procedure TstwssDienstregForm.FormShow(Sender: TObject);
begin
	stwssAddMatForm.Core := Core;
	stwssVerschijnpuntForm.Core := Core;
	stwssTreinDienstForm.Core := Core;

	UpdateDingen;
end;

procedure TstwssDienstregForm.startUurEditChange(Sender: TObject);
var
	u,m, code: integer;
begin
	val(startUurEdit.Text, u, code);
	val(startMinEdit.Text, m, code);
	Core.Starttijd := MkTijd(u,m,0);
end;

procedure TstwssDienstregForm.stopUurEditChange(Sender: TObject);
var
	u,m, code: integer;
begin
	val(stopUurEdit.Text, u, code);
	val(stopMinEdit.Text, m, code);
	Core.Stoptijd := MkTijd(u,m,0);
end;

procedure TstwssDienstregForm.matLoadButClick(Sender: TObject);
var
	matfn: string;
	Matfile: PpMaterieelFile;
	iseral: boolean;
begin
	if stwssAddMatForm.ShowModal = mrOK then begin
		matfn := stwssAddMatForm.MatCombo.Text;
		matFile := Core.pMaterieel;
		iseral := false;
		while assigned(Matfile) do begin
			iseral := iseral or (Uppercase(Matfile^.Filename) = uppercase(matfn));
			Matfile := Matfile^.Volgende;
		end;
		if iseral then begin
			Application.Messagebox('Bestand is al geladen.', 'Fout', MB_ICONERROR);
			exit;
		end;
		if not Core.WagonsLaden(matfn) then begin
			Application.Messagebox('Bestand kon niet geladen worden.', 'Fout', MB_ICONERROR);
			exit;
		end;
		UpdateDingen;
	end;
end;

procedure TstwssDienstregForm.matDelButClick(Sender: TObject);
var
	matfn: string;
	vMatfile,
	tMatfile,
	Matfile: PpMaterieelFile;
	VerschijnItem: PpVerschijnItem;
	TreinL: PpTrein;
	WagonConn: PpWagonConn;
	Wagon: PpWagon;
begin
	// Matfile zoeken
	if matlist.itemindex < 0 then exit;
	matfn := matlist.items[matlist.itemindex];
	Matfile := core.pMaterieel;
	while assigned(Matfile) and (Matfile^.Filename <> matfn) do
		Matfile := Matfile^.Volgende;
	if not assigned(Matfile) then begin
		Application.Messagebox('Interne fout: kan materieel niet vinden!', 'Fout', MB_ICONERROR);
		exit;
	end;
	// Alle verschijn-items controleren!
	VerschijnItem := Core.VerschijnLijst;
	while assigned(VerschijnItem) do begin
		WagonConn := VerschijnItem^.wagons;
		while assigned(WagonConn) do begin
			Wagon := Matfile^.Wagons;
			while assigned(Wagon) do begin
				if WagonConn^.wagon = Wagon then begin
					Application.Messagebox(pchar('Kan materieelbestand niet verwijderen omdat het nog in gebruik is, '+
						'o.a. door verschijnitem voor trein '+VerschijnItem^.Treinnummer+'.'), 'Fout', MB_ICONERROR);
					exit;
				end;
				Wagon := Wagon^.Volgende;
			end;
			WagonConn := WagonConn^.Volgende;
		end;
		VerschijnItem := VerschijnItem^.Volgende;
	end;
	// Alle treinen controleren!
	TreinL := Core.pAlleTreinen;
	while assigned(TreinL) do begin
		WagonConn := TreinL^.EersteWagon;
		while assigned(WagonConn) do begin
			Wagon := Matfile^.Wagons;
			while assigned(Wagon) do begin
				if WagonConn^.wagon = Wagon then begin
					Application.Messagebox(pchar('Kan materieelbestand niet verwijderen omdat het nog in gebruik is, '+
						'o.a. door trein '+TreinL^.Treinnummer+'.'), 'Fout', MB_ICONERROR);
					exit;
				end;
				Wagon := Wagon^.Volgende;
			end;
			WagonConn := WagonConn^.Volgende;
		end;
		TreinL := TreinL^.Volgende;
	end;
	// Nu kunnen we het bestand ont-laden
	while assigned(Matfile^.Wagons) do begin
		Wagon := Matfile^.Wagons;
		Matfile^.Wagons := Wagon^.Volgende;
		dispose(Wagon);
	end;
	if Core.pMaterieel = Matfile then
		Core.pMaterieel := Matfile^.Volgende
	else begin
		vMatfile := Core.pMaterieel;
		tMatfile := vMatfile^.Volgende;
		while assigned(tMatfile) do begin
			if tMatfile = Matfile then begin
				vMatfile^.Volgende := tMatfile^.Volgende;
				break;
			end else begin
				vMatfile := tMatfile;
				tMatfile := tMatfile^.Volgende;
			end;
		end;
		dispose(Matfile);
	end;
	// En weergeven
   UpdateDingen;
end;

procedure TstwssDienstregForm.newTreinButClick(Sender: TObject);
var
	nieuwnr: string;
	Dienst: PpTreindienst;
begin
	stwssTreinnrForm.treinnrEdit.Text := '';
	if stwssTreinnrForm.ShowModal = mrOK then begin
		nieuwnr := stwssTreinnrForm.treinnrEdit.Text;
		if nieuwnr = '' then begin
			Application.Messagebox('Geen treinnummer opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		Dienst := Core.pAlleDiensten;
		while assigned(Dienst) do begin
			if Dienst^.Treinnummer = nieuwnr then begin
				Application.Messagebox('Dit treinnummer bestaat al.', 'Fout', MB_ICONERROR);
				exit;
			end;
			Dienst := Dienst^.Volgende;
		end;
		new(Dienst);
		Dienst^.Treinnummer := nieuwnr;
		Dienst^.Planpunten := nil;
		Dienst^.Volgende := nil;
		Dienst^.Volgende := Core.pAlleDiensten;
		Core.pAlleDiensten := Dienst;
		SorteerTreinen;
		UpdateDingen;
	end;
end;

function TstwssDienstregForm.Trn_Sort_Merge;
var
	first, last: PpTreindienst;
begin
	first := nil;
	last := nil;
	while assigned(Links) and assigned(Rechts) do
		if Links^.Treinnummer <= Rechts^.Treinnummer then begin
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

function TstwssDienstregForm.Trn_Sort_List;
var
	count, helft, i: integer;
	tmpDienst, hpDienst,
	links,rechts: PpTreindienst;
begin
	result := Dienst;
	if not assigned(Dienst) then exit;
	if not assigned(Dienst^.Volgende) then exit;

	tmpDienst := Dienst;
	count := 0;
	while assigned(tmpDienst) do begin
		inc(count);
		tmpDienst := tmpDienst^.Volgende;
	end;

	helft := count div 2;
	tmpDienst := Dienst;
	for i := 2 to helft do
		tmpDienst := tmpDienst^.Volgende;
	hpDienst := tmpDienst^.Volgende;
	tmpDienst^.Volgende := nil;

	links := Trn_Sort_List(Dienst);
	rechts := Trn_Sort_List(hpDienst);
	result := Trn_Sort_Merge(links, rechts);
end;

function TstwssDienstregForm.Vrs_Sort_Merge;
var
	first, last: PpVerschijnItem;
begin
	first := nil;
	last := nil;
	while assigned(Links) and assigned(Rechts) do
		if Links^.Tijd <= Rechts^.Tijd then begin
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

function TstwssDienstregForm.Vrs_Sort_List;
var
	count, helft, i: integer;
	tmpVerschijnItem, hpVerschijnItem,
	links,rechts: PpVerschijnItem;
begin
	result := VerschijnItem;
	if not assigned(VerschijnItem) then exit;
	if not assigned(VerschijnItem^.Volgende) then exit;

	tmpVerschijnItem := VerschijnItem;
	count := 0;
	while assigned(tmpVerschijnItem) do begin
		inc(count);
		tmpVerschijnItem := tmpVerschijnItem^.Volgende;
	end;

	helft := count div 2;
	tmpVerschijnItem := VerschijnItem;
	for i := 2 to helft do
		tmpVerschijnItem := tmpVerschijnItem^.Volgende;
	hpVerschijnItem := tmpVerschijnItem^.Volgende;
	tmpVerschijnItem^.Volgende := nil;

	links := Vrs_Sort_List(VerschijnItem);
	rechts := Vrs_Sort_List(hpVerschijnItem);
	result := Vrs_Sort_Merge(links, rechts);
end;

procedure TstwssDienstregForm.FormCreate(Sender: TObject);
begin
	stwssTreinnrForm := TstwssTreinnrForm.Create(Self);
	stwssAddMatForm := TstwssAddMatForm.Create(Self);
	stwssVerschijnpuntForm := TstwssVerschijnpuntForm.Create(Self);
	stwssTreinCopyForm := TstwssTreinCopyForm.Create(Self);
	stwssTreinDienstForm := TstwssTreinDienstForm.Create(Self); 
end;

procedure TstwssDienstregForm.nieuwVerschijnButClick(Sender: TObject);
var
	VI: PpVerschijnItem;
begin
	new(VI);
	VI^.Volgende := Core.VerschijnLijst;
	Core.VerschijnLijst := VI;
	VI^.Treinnummer := '';
	VI^.Tijd := 0;
	VI^.Plaats := nil;
	VI^.vanafstation := '';
	VI^.wagons := nil;
	VI^.treinweg_naam := '';
	VI^.treinweg_wachten := 0;
	VI^.gedaan := false;
	VI^.treinweg_voldaan := false;
	VI^.treinweg_tijd := 0;
	stwssVerschijnpuntForm.SetEntries(VI);
	stwssVerschijnpuntForm.ShowModal;
	SorteerVerschijnitems;
	UpdateDingen;
end;

procedure TstwssDienstregForm.editVerschijnButClick(Sender: TObject);
var
	i: integer;
	VI: PpVerschijnItem;
begin
	if verschijnList.ItemIndex = -1 then exit;
	VI := Core.VerschijnLijst;
	for i := 1 to verschijnList.ItemIndex do
		VI := VI^.Volgende;
	stwssVerschijnpuntForm.SetEntries(VI);
	stwssVerschijnpuntForm.ShowModal;
	SorteerVerschijnitems;
	UpdateDingen;
end;

procedure TstwssDienstregForm.delVerschijnButClick(Sender: TObject);
var
	i: integer;
	VI, vVI: PpVerschijnItem;
	tmpConn: PpWagonConn;
begin
	if verschijnList.ItemIndex = -1 then exit;
	VI := Core.VerschijnLijst;
	vVI := nil;
	for i := 1 to verschijnList.ItemIndex do begin
		vVI := VI;
		VI := VI^.Volgende;
	end;
	// We hebben het item maar we moeten eerst de wagons wissen.
	while assigned(VI^.Wagons) do begin
		tmpConn := VI^.Wagons;
		VI^.Wagons := tmpConn^.Volgende;
		dispose(tmpConn);
	end;
	// En het item zelf wissen.
	if assigned(vVI) then begin
		vVI^.Volgende := VI^.Volgende;
		dispose(VI);
	end else begin
		Core.VerschijnLijst := VI^.Volgende;
		dispose(VI);
	end;
	// We hoeven nu niet te sorteren.
	UpdateDingen;
end;

procedure TstwssDienstregForm.copyVerschijnButClick(Sender: TObject);
var
	i: integer;
	VI, nVI: PpVerschijnItem;
	count, min, nrup, code: integer;
	treinnr: string;
	tijd: integer;
begin
	if verschijnList.ItemIndex = -1 then exit;
	VI := Core.VerschijnLijst;
	for i := 1 to verschijnList.ItemIndex do
		VI := VI^.Volgende;
	stwssTreinCopyForm.countEdit.Text := '1';
	stwssTreinCopyForm.minEdit.Text := '60';
	stwssTreinCopyForm.nrupedit.Text := '2';
	if stwssTreinCopyForm.ShowModal = mrOK then begin
		val(stwssTreinCopyForm.countEdit.Text, count, code);
		if (code <> 0) or (count < 0) then begin
			Application.Messagebox('Ongeldig aantal herhalingen opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		val(stwssTreinCopyForm.minEdit.Text, min, code);
		if code <> 0 then begin
			Application.Messagebox('Ongeldig aantal minuten opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		val(stwssTreinCopyForm.nrUpEdit.Text, nrup, code);
		if code <> 0 then begin
			Application.Messagebox('Ongeldige ophoging van het treinnummer opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Zo, nu hebben we alles.
		treinnr := VI^.Treinnummer;
		Tijd := VI^.Tijd;
		for i := 1 to count do begin
			Tijd := Tijd + MkTijd(0,min,0);
			IncTreinnr(treinnr, nrup);
			new(nVI);
			nVI^ := VI^;
			nVI^.wagons := Core.CopyWagons(VI^.Wagons);
			nVI^.Treinnummer := treinnr;
			nVI^.Tijd := Tijd;
			nVI^.Volgende := Core.VerschijnLijst;
			Core.VerschijnLijst := nVI;
		end;
		SorteerVerschijnitems;
		UpdateDingen;
	end;
end;

procedure TstwssDienstregForm.treinNrButClick(Sender: TObject);
var
	i: integer;
	selDienst, Dienst: PpTreindienst;
	nieuwnr: string;
begin
	if treinList.ItemIndex = -1 then exit;
	selDienst := Core.pAlleDiensten;
	for i := 1 to treinList.ItemIndex do
		selDienst := selDienst^.Volgende;
	stwssTreinnrForm.treinnrEdit.Text := selDienst^.Treinnummer;
	if stwssTreinnrForm.ShowModal = mrOK then begin
		nieuwnr := stwssTreinnrForm.treinnrEdit.Text;
		if nieuwnr = '' then begin
			Application.Messagebox('Geen treinnummer opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		Dienst := Core.pAlleDiensten;
		while assigned(Dienst) do begin
			if Dienst^.Treinnummer = nieuwnr then begin
				Application.Messagebox('Dit treinnummer bestaat al.', 'Fout', MB_ICONERROR);
				exit;
			end;
			Dienst := Dienst^.Volgende;
		end;
		selDienst^.Treinnummer := nieuwnr;
		SorteerTreinen;
		UpdateDingen;
	end;
end;

procedure TstwssDienstregForm.editTreinButClick(Sender: TObject);
var
	i: integer;
	Dienst: PpTreindienst;
begin
	if treinList.ItemIndex = -1 then exit;
	Dienst := Core.pAlleDiensten;
	for i := 1 to treinList.ItemIndex do
		Dienst := Dienst^.Volgende;
	stwssTreinDienstForm.Dienst := Dienst;
	stwssTreinDienstForm.ShowModal;
	UpdateDingen;
end;

procedure TstwssDienstregForm.delTreinButClick(Sender: TObject);
var
	i: integer;
	Dienst, vDienst, tmpDienst: PpTreindienst;
	Punt: PpRijplanPunt;
	VerschijnItem: PpVerschijnItem;
begin
	if treinList.ItemIndex = -1 then exit;
	// Vraag
	if Application.Messagebox('Deze trein verwijderen?','Verwijderen', MB_OKCANCEL+MB_ICONWARNING) <> idOK then
		exit;
	// Zoek de dienst
	Dienst := Core.pAlleDiensten;
	vDienst := nil;
	for i := 1 to treinList.ItemIndex do begin
		vDienst := Dienst;
		Dienst := Dienst^.Volgende;
	end;
	// Kijk of de dienst niet nodig is.
	// Andere treinen
	tmpDienst := Core.pAlleDiensten;
	while assigned(tmpDienst) do begin
		Punt := tmpDienst^.Planpunten;
		while assigned(Punt) do begin
			if Punt^.nieuwetrein and (Punt^.nieuwetrein_w = Dienst^.Treinnummer) then
				if Application.Messagebox(pchar('Trein '+tmpDienst^.Treinnummer+' wordt omgenummerd in dit treinnummer. Toch verwijderen?'),
					'Fout', MB_ICONWARNING+MB_YESNO) <> idYES then
					exit;
			if (Punt^.loskoppelen>0) and (Punt^.loskoppelen_w = Dienst^.Treinnummer) then
				if Application.Messagebox(pchar('Afgekoppelde wagons van trein '+tmpDienst^.Treinnummer+' krijgen dit treinnummer. Toch verwijderen?'),
					'Fout', MB_ICONWARNING+MB_YESNO) <> idYES then
					exit;
			Punt := Punt^.Volgende;
		end;
		tmpDienst := tmpDienst^.Volgende;
	end;
	// Verschijnen
	VerschijnItem := Core.VerschijnLijst;
	while assigned(VerschijnItem) do begin
		if VerschijnItem^.Treinnummer = Dienst^.Treinnummer then
			if Application.Messagebox(pchar('Deze trein staat nog op de verschijn-lijst. Toch verwijderen?'),
				'Fout', MB_ICONWARNING+MB_YESNO) <> idYES then
				exit;
		VerschijnItem := VerschijnItem^.Volgende;
	end;
	// Planpunten wissen
	while assigned(Dienst^.Planpunten) do begin
		Punt := Dienst^.Planpunten;
		Dienst^.Planpunten := Punt^.Volgende;
		dispose(Punt);
	end;
	// En de dienst wissen.
	if assigned(vDienst) then
		vDienst^.Volgende := Dienst^.Volgende
	else
		Core.pAlleDiensten := Dienst^.Volgende;
	dispose(Dienst);
	UpdateDingen;
end;

procedure TstwssDienstregForm.copyTreinButClick(Sender: TObject);
var
	i: integer;
	Dienst, nDienst: PpTreindienst;
	count, min, nrup, code: integer;
	Punt: PpRijplanPunt;
	found: boolean;
	treinnr: string;
begin
	if treinList.ItemIndex = -1 then exit;
	Dienst := Core.pAlleDiensten;
	for i := 1 to treinList.ItemIndex do
		Dienst := Dienst^.Volgende;
	stwssTreinCopyForm.countEdit.Text := '1';
	stwssTreinCopyForm.minEdit.Text := '60';
	stwssTreinCopyForm.nrupedit.Text := '2';
	if stwssTreinCopyForm.ShowModal = mrOK then begin
		val(stwssTreinCopyForm.countEdit.Text, count, code);
		if (code <> 0) or (count < 0) then begin
			Application.Messagebox('Ongeldig aantal herhalingen opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		val(stwssTreinCopyForm.minEdit.Text, min, code);
		if code <> 0 then begin
			Application.Messagebox('Ongeldig aantal minuten opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		val(stwssTreinCopyForm.nrUpEdit.Text, nrup, code);
		if code <> 0 then begin
			Application.Messagebox('Ongeldige ophoging van het treinnummer opgegeven.', 'Fout', MB_ICONERROR);
			exit;
		end;
		// Zo, nu hebben we alles.
		// Dienst = de trein die we kopieren. Deze vervangen we bij iedere iteratie!
		// count, min, nrup
		treinnr := Dienst^.Treinnummer;
		for i := 1 to count do begin
			// Treinnummer berekenen
			IncTreinnr(treinnr, nrup);

			// Kijken of dit treinnummer al bestaat.
			nDienst := Core.pAlleDiensten;
			found := false;
			while assigned(nDienst) do begin
				if nDienst^.Treinnummer = treinnr then found := true;
				nDienst := nDienst^.Volgende;
			end;

			if not found then begin
				new(nDienst);
				nDienst^.Volgende := Core.pAlleDiensten;
				Core.pAlleDiensten := nDienst;

				nDienst^.Treinnummer := treinnr;
				nDienst^.Planpunten := Core.CopyDienst(Dienst);
				// En de tijden bijwerken
				Punt := nDienst^.Planpunten;
				while assigned(Punt) do begin
					if Punt^.Aankomst <> -1 then
						Punt^.Aankomst := Punt^.Aankomst + MkTijd(0,min,0);
					if Punt^.Vertrek <> -1 then
						Punt^.Vertrek := Punt^.Vertrek + MkTijd(0,min,0);
					if Punt^.nieuwetrein and (Punt^.nieuwetrein_w <> '') then
						IncTreinnr(Punt^.nieuwetrein_w, nrup);
					if (Punt^.loskoppelen>0) and (Punt^.loskoppelen_w <> '') then
						IncTreinnr(Punt^.loskoppelen_w, nrup);
					Punt := Punt^.Volgende;
				end;
				Dienst := nDienst;
			end else
				Application.Messagebox(pchar('Trein '+treinnr+' bestaat al - genegeerd.'),'Info', MB_ICONASTERISK);
		end;
		SorteerTreinen;
		UpdateDingen;
	end;
end;

end.
