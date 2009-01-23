unit clientProcesPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, stwvProcesPlan, stwvCore, stwvMisc, stwpTijd, stwvRijwegen;

type
  TstwscProcesPlanFrame = class(TFrame)
	 RegelList: TListBox;
	 btnPanel: TPanel;
	 ExecBut: TButton;
	 EditBut: TButton;
	 DelBut: TButton;
	 ARICheck: TCheckBox;
    TitelPanel: TPanel;
    titelLabel: TLabel;
    HistList: TListBox;
    procedure ExecButClick(Sender: TObject);
    procedure DelButClick(Sender: TObject);
    procedure EditButClick(Sender: TObject);
    procedure RegelListDblClick(Sender: TObject);
	private
		{ Private declarations }
		selPunt:	PvProcesPlanPunt;
		function MkLijstString(PPP: PvProcesPlanPunt): string;
		function FindSelected: PvProcesPlanPunt;
		procedure Markeer(PPP: PvProcesPlanPunt);
		// Intern
		function GetARI: boolean;
		procedure SetARI(auto: boolean);
	public
		FName:			string;
		ProcesPlan:		TProcesPlan;
		Core:				PvCore;
		procedure UpdateLijst;
		property ARI: boolean read GetARI write SetARI default true;
	end;

implementation

uses clientPlanregelEdit;

{$R *.DFM}

function TstwscProcesPlanFrame.GetARI;
begin
	result := ARICheck.Checked;
end;

procedure TstwscProcesPlanFrame.SetARI;
begin
	ARICheck.Checked := Auto;
end;

function TstwscProcesPlanFrame.FindSelected;
var
	i: integer;
begin
	result := nil;
	if RegelList.ItemIndex = -1 then exit;
	result := ProcesPlan.ProcesPlanPuntenPending;
	for i := 1 to RegelList.ItemIndex do
		result := result^.Volgende;
	if MkLijstString(result) <> RegelList.Items[RegelList.ItemIndex] then begin
		result := nil;
		exit;
	end;
end;

procedure TstwscProcesPlanFrame.Markeer;
var
	i: integer;
begin
	for i := 0 to RegelList.Items.Count-1 do
		if MkLijstString(PPP) = RegelList.Items[i] then
			RegelList.ItemIndex := i;
end;

function TstwscProcesPlanFrame.MkLijstString;
var
	s: string;
begin
	s := Pad(PPP^.Treinnr, 8, #32, vaVoor) + '  ';
	case PPP^.ActiviteitSoort of
	asDoorkomst:s := s + Pad('D', 3, #32, vaAchter);
	asVertrek:	s := s + Pad('V', 3, #32, vaAchter);
	asAankomst:	s := s + Pad('A', 3, #32, vaAchter);
	asKortestop:s := s + Pad('K', 3, #32, vaAchter);
	asNul:		s := s + Pad('*', 3, #32, vaAchter);
	end;
	s := s + Pad(TijdStr(PPP^.Plantijd, false), 8, #32, vaAchter);
	s := s + Pad(TijdStr(PPP^.Insteltijd, false), 8, #32, vaAchter);
	s := s + Pad(PPP^.van, 7, #32, vaAchter);
	s := s + Pad(PPP^.naar, 7, #32, vaAchter);
	if PPP^.Dwang > 0 then
		s := s + Pad(inttostr(PPP^.Dwang), 5, #32, vaAchter)
	else
		s := s + Pad('', 5, #32, vaAchter);
	if (PPP^.NieuwNummer <> '') or (PPP^.RestNummer <> '') then
		s := s + 'm';
	result := s;
end;

procedure TstwscProcesPlanFrame.UpdateLijst;
var
	i: 		integer;
	aantal:	integer;
	PPP: 		PvProcesPlanPunt;
	s:			string;
begin
	i := 0;
	PPP := ProcesPlan.ProcesPlanPuntenPending;
	while assigned(PPP) do begin
		s := MkLijstString(PPP);
		if RegelList.Items.Count > i then begin
			if RegelList.Items[i] <> s then
				RegelList.Items[i] := s
		end else
			RegelList.Items.Add(s);
		inc(i);
		PPP := PPP^.Volgende;
	end;
	while RegelList.Items.Count > i do
		RegelList.Items.Delete(i);

	if ProcesPlan.KlaarAantal <= 5 then
		Aantal := ProcesPlan.KlaarAantal
	else
		Aantal := 5;

	while HistList.Items.Count > aantal do
		HistList.Items.Delete(aantal);
	while HistList.Items.Count < aantal do
		HistList.Items.Add('');

	i := 0;
	PPP := ProcesPlan.ProcesPlanPuntenKlaar;
	while assigned(PPP) and (i < aantal) do begin
		s := MkLijstString(PPP);
		if HistList.Items[aantal-i-1] <> s then
			HistList.Items[aantal-i-1] := s;
		inc(i);
		PPP := PPP^.Volgende;
	end;
end;

procedure TstwscProcesPlanFrame.ExecButClick(Sender: TObject);
begin
	selPunt := FindSelected;
	if assigned(selPunt) then
		if ProcesPlan.ProbeerPlanpuntUitTeVoeren(selPunt) then
			ProcesPlan.MarkeerKlaar(selPunt);
	UpdateLijst;
end;

procedure TstwscProcesPlanFrame.DelButClick(Sender: TObject);
begin
	selPunt := FindSelected;
	if assigned(selPunt) then
		if Application.MessageBox('Deze planregel echt verwijderen?', 'Planregel verwijderen', MB_YESNO+MB_ICONWARNING) = mrYes then
			ProcesPlan.MarkeerKlaar(selPunt);
	UpdateLijst;
end;

procedure TstwscProcesPlanFrame.EditButClick(Sender: TObject);
var
	u,m,s, code: integer;
	us, ms: string;
	van, naar: string;
	Dwang: byte;
	ari_oud: boolean;
begin
	selPunt := FindSelected;
	if assigned(selPunt) then begin
		stwscPlanregelEditForm.Core := Core;
		stwscPlanregelEditForm.treinnrEdit.Text := selPunt^.Treinnr;
		case selPunt^.ActiviteitSoort of
		asDoorkomst: stwscPlanregelEditForm.actBox.ItemIndex := 0;
		asVertrek:   stwscPlanregelEditForm.actBox.ItemIndex := 1;
		asAankomst:  stwscPlanregelEditForm.actBox.ItemIndex := 2;
		asKortestop: stwscPlanregelEditForm.actBox.ItemIndex := 3;
		asNul:       stwscPlanregelEditForm.actBox.ItemIndex := 4;
		end;
		stwscPlanregelEditForm.vanEdit.Text := selPunt^.van;
		stwscPlanregelEditForm.naarEdit.Text := selPunt^.naar;
		stwscPlanregelEditForm.rozCheck.Checked := selPunt^.ROZ;
		stwscPlanregelEditForm.gefaseerdCheck.Checked := selPunt^.gefaseerd;
		stwscPlanregelEditForm.ariCheck.Checked := selPunt^.ARI_toegestaan;
		FmtTijd(selPunt^.Insteltijd, u, m, s);
		us := inttostr(u); if length(us)=1 then us := '0'+us;
		ms := inttostr(m); if length(ms)=1 then ms := '0'+ms;
		stwscPlanregelEditForm.instelUurEdit.Text := us;
		stwscPlanregelEditForm.instelMinEdit.Text := ms;
		stwscPlanregelEditForm.nieuwNrEdit.Text := selPunt^.NieuwNummer;
		stwscPlanregelEditForm.RestNrEdit.Text := selPunt^.RestNummer;
		stwscPlanregelEditForm.UpdateDwangen;
		if stwscPlanregelEditForm.dwangBox.Items.Count >= selPunt^.Dwang+1 then
			stwscPlanregelEditForm.dwangBox.ItemIndex := selPunt^.Dwang
		else
			stwscPlanregelEditForm.dwangBox.ItemIndex := -1;
		// Tijdens het bewerken mag de regel niet automatisch worden uitgevoerd.
		Ari_Oud := selPunt^.ARI_toegestaan;
		selPunt^.ARI_toegestaan := false;
		// En GO
		if stwscPlanregelEditForm.ShowModal = mrOK then begin
			val(stwscPlanregelEditForm.instelUurEdit.Text, u, code);
			if code <> 0 then begin
				Application.MessageBox('Ongeldige insteltijd opgegeven','Fout',MB_ICONERROR);
				exit;
			end;
			val(stwscPlanregelEditForm.instelMinEdit.Text, m, code);
			if code <> 0 then begin
				Application.MessageBox('Ongeldige insteltijd opgegeven','Fout',MB_ICONERROR);
				exit;
			end;
			Van := stwscPlanregelEditForm.vanEdit.Text;
			Naar := stwscPlanregelEditForm.naarEdit.Text;
			Dwang := stwscPlanregelEditForm.dwangBox.ItemIndex;
			if not assigned(ZoekPrlRijweg(Core, Van, Naar, Dwang)) then begin
				Application.MessageBox('Ongeldige rijweg opgegeven','Fout',MB_ICONERROR);
				exit;
			end;
			selPunt^.Insteltijd := MkTijd(u,m,0);
			selPunt^.Treinnr := stwscPlanregelEditForm.treinnrEdit.Text;
			case stwscPlanregelEditForm.actBox.ItemIndex of
			0: selPunt^.ActiviteitSoort := asDoorkomst;
			1: selPunt^.ActiviteitSoort := asVertrek;
			2: selPunt^.ActiviteitSoort := asAankomst;
			3: selPunt^.ActiviteitSoort := asKortestop;
			4: selPunt^.ActiviteitSoort := asNul;
			end;
			selPunt^.van := Van;
			selPunt^.naar := Naar;
			selPunt^.Dwang := Dwang;
			selPunt^.ROZ := stwscPlanregelEditForm.rozCheck.Checked;
			selPunt^.gefaseerd := stwscPlanregelEditForm.gefaseerdCheck.Checked;
			selPunt^.ARI_toegestaan := stwscPlanregelEditForm.ariCheck.Checked;
			selPunt^.NieuwNummer := stwscPlanregelEditForm.nieuwNrEdit.Text;
			selPunt^.RestNummer := stwscPlanregelEditForm.RestNrEdit.Text;
		end else
			// Bij CANCEL moeten we de oude ARI-instelling terugzetten.
			selPunt^.ARI_toegestaan := ari_oud;
	end;
	ProcesPlan.Sorteer;
	UpdateLijst;
	Markeer(selPunt);
end;

procedure TstwscProcesPlanFrame.RegelListDblClick(Sender: TObject);
begin
	EditButClick(Sender);
end;

end.
