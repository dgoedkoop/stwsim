unit clientProcesPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, stwvProcesPlan, stwvCore, stwvMisc, stwpTijd,
  stwvTreinInfo, stwvRijwegen, ActnList, Menus;

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
    PopupMenu: TPopupMenu;
    ActionList: TActionList;
    VoernuuitAct: TAction;
    BewerkAct: TAction;
    DelAct: TAction;
    VVAct: TAction;
    Voernuuit1: TMenuItem;
	 Verwerkvertraging1: TMenuItem;
    Bewerk1: TMenuItem;
    Verwijder1: TMenuItem;
    procedure RegelListDblClick(Sender: TObject);
    procedure VoernuuitActExecute(Sender: TObject);
    procedure BewerkActExecute(Sender: TObject);
    procedure DelActExecute(Sender: TObject);
    procedure VVActExecute(Sender: TObject);
    procedure RegelListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RegelListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure HistListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
	private
		{ Private declarations }
		selPunt:	PvProcesPlanPunt;
		PendingLijst: TStringList;
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
		constructor Create(AOwner: TComponent); override;
		procedure UpdateLijst;
		property ARI: boolean read GetARI write SetARI default true;
	end;

implementation

uses clientPlanregelEdit;

{$R *.DFM}

constructor TstwscProcesPlanFrame.Create;
begin
	inherited Create(AOwner);
	PendingLijst := TStringList.Create;
end;

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
	if MkLijstString(result) <> PendingLijst.Strings[RegelList.ItemIndex] then
		result := nil;
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
	tstr: string;
	vstr: string;
begin
	if round(PPP^.GemetenVertraging/60) > round(PPP^.VerwerkteVertraging/60) then
		tstr := '!'
	else if PPP^.Bewerkt then
		tstr := '+'
	else
		tstr := '';
	if (PPP^.GemetenVertraging >= 30) or
	   (PPP^.GemetenVertraging <= -31) then begin
		str(round(PPP^.GemetenVertraging/60), vstr);
		if PPP^.GemetenVertraging > 0 then
			vstr := '+'+vstr;
		if PPP^.GemetenVertragingSoort = vsSchatting then
			vstr := 'V'+vstr;
	end;

	s := s + Pad(tstr, 1, #32, vaVoor);
	s := s + Pad(PPP^.Treinnr, 7, #32, vaVoor) + '  ';
	s := s + Pad(ActiviteitSoortStr(PPP^.ActiviteitSoort), 3, #32, vaAchter);
	s := s + Pad(TijdStr(PPP^.Plantijd, false), 8, #32, vaAchter);
	s := s + Pad(vstr, 5, #32, vaAchter);
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
	// Hier werken we de inhoud niet bij. Kost veel te veel rekentijd. Dat doen
	// we wel op het moment dat we een item tekenen.
	RegelList.Items.BeginUpdate;
	i := 0;
	PPP := ProcesPlan.ProcesPlanPuntenPending;
	while assigned(PPP) do begin
		inc(i);
		PPP := PPP^.Volgende;
	end;
	while RegelList.Items.Count < i do begin
		RegelList.Items.Add('');
		PendingLijst.Add('');
	end;
	while RegelList.Items.Count > i do begin
		RegelList.Items.Delete(i);
		PendingLijst.Delete(i);
	end;
	RegelList.Items.EndUpdate;

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

procedure TstwscProcesPlanFrame.RegelListDblClick(Sender: TObject);
begin
	BewerkActExecute(Sender);
end;

procedure TstwscProcesPlanFrame.VoernuuitActExecute(Sender: TObject);
begin
	selPunt := FindSelected;
	if assigned(selPunt) then
		if ProcesPlan.ProbeerPlanpuntUitTeVoeren(selPunt, false) then
			ProcesPlan.MarkeerKlaar(selPunt);
	UpdateLijst;
end;

procedure TstwscProcesPlanFrame.BewerkActExecute(Sender: TObject);
var
	u,m,s, code: integer;
	us, ms: string;
	van, naar: string;
	Dwang: byte;
	ari_oud: boolean;
	nwtijd: integer;
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
		asRangeren:  stwscPlanregelEditForm.actBox.ItemIndex := 4;
		asNul:       stwscPlanregelEditForm.actBox.ItemIndex := 5;
		end;
		stwscPlanregelEditForm.vanEdit.Text := selPunt^.van;
		stwscPlanregelEditForm.naarEdit.Text := selPunt^.naar;
		stwscPlanregelEditForm.rozCheck.Checked := selPunt^.ROZ;
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
			nwtijd := MkTijd(u,m,0);
			if selPunt^.Insteltijd <> nwtijd then begin
				selPunt^.VerwerkteVertraging := selPunt^.VerwerkteVertraging + nwtijd - selPunt^.Insteltijd;
				selPunt^.Insteltijd := nwtijd;
			end;
			selPunt^.Treinnr := stwscPlanregelEditForm.treinnrEdit.Text;
			case stwscPlanregelEditForm.actBox.ItemIndex of
			0: selPunt^.ActiviteitSoort := asDoorkomst;
			1: selPunt^.ActiviteitSoort := asVertrek;
			2: selPunt^.ActiviteitSoort := asAankomst;
			3: selPunt^.ActiviteitSoort := asKortestop;
			4: selPunt^.ActiviteitSoort := asRangeren;
			5: selPunt^.ActiviteitSoort := asNul;
			end;
			selPunt^.van := Van;
			selPunt^.naar := Naar;
			selPunt^.Dwang := Dwang;
			selPunt^.ROZ := stwscPlanregelEditForm.rozCheck.Checked;
			selPunt^.ARI_toegestaan := stwscPlanregelEditForm.ariCheck.Checked;
			selPunt^.NieuwNummer := stwscPlanregelEditForm.nieuwNrEdit.Text;
			selPunt^.RestNummer := stwscPlanregelEditForm.RestNrEdit.Text;
			selPunt^.AnalyseGedaan := false;
			selPunt^.Bewerkt := true;
		end else
			// Bij CANCEL moeten we de oude ARI-instelling terugzetten.
			selPunt^.ARI_toegestaan := ari_oud;
		ProcesPlan.Sorteer;
		UpdateLijst;
		Markeer(selPunt);
	end;
end;

procedure TstwscProcesPlanFrame.DelActExecute(Sender: TObject);
begin
	selPunt := FindSelected;
	if assigned(selPunt) then
		if Application.MessageBox('Deze planregel echt verwijderen?', 'Planregel verwijderen', MB_YESNO+MB_ICONWARNING) = mrYes then
			ProcesPlan.MarkeerKlaar(selPunt);
	UpdateLijst;
end;

procedure TstwscProcesPlanFrame.VVActExecute(Sender: TObject);
begin
	selPunt := FindSelected;
	if assigned(selPunt) then begin
		selPunt^.Insteltijd := selPunt^.Insteltijd +
			selPunt^.GemetenVertraging - selPunt^.VerwerkteVertraging;
		selPunt^.VerwerkteVertraging := selPunt^.GemetenVertraging;
		selPunt^.Bewerkt := true;
		ProcesPlan.Sorteer;
		UpdateLijst;
	end;
end;

procedure TstwscProcesPlanFrame.RegelListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
	APoint: TPoint;
	Index: integer;
begin
	if Button = mbRight then begin
		APoint.X := X;
		APoint.Y := Y;
		Index := RegelList.ItemAtPos(APoint, True);
		if Index > -1 then
			RegelList.ItemIndex := Index;
	end;
end;

procedure TstwscProcesPlanFrame.RegelListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
	TopDif: Integer;
	PPP: PvProcesPlanPunt;
	i: integer;
begin
	with (Control as TListbox) do begin
		PPP := ProcesPlan.ProcesPlanPuntenPending;
		for i := 1 to index do
			if assigned(PPP) then
				PPP := PPP^.Volgende;
		if not assigned(PPP) then exit;
		// Als een ander item geselecteerd wordt, dan wordt geen DrawItem-oproep
		// gedaan voor het oude, gedeselecteerde item. Daarom kunnen we maar beter
		// geselecteerde items niet markeren.
{		if Index <> RegelList.ItemIndex then}
			Canvas.Brush.Color := clBlack
{		else
			Canvas.Brush.Color := clHighlight};
		if GetTijd >= PPP^.Insteltijd - MkTijd(0,1,0) then
			if GetTijd >= PPP^.Insteltijd + MkTijd(0,1,0) then
				Canvas.Font.Color := clRed
			else
				Canvas.Font.Color := clYellow
		else
			Canvas.Font.Color := clWhite;
		TopDif := (ItemHeight div 2) - (Canvas.TextHeight(#32) div 2);
		if PendingLijst.Strings[Index] <> MkLijstString(PPP) then
			PendingLijst.Strings[Index] := MkLijstString(PPP);
		Canvas.TextRect(Rect, Rect.Left+2, Rect.Top + TopDif, PendingLijst.Strings[Index]);
	end;
end;

procedure TstwscProcesPlanFrame.HistListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
	TopDif: Integer;
begin
	with (Control as TListbox) do begin
		// Als een ander item geselecteerd wordt, dan wordt geen DrawItem-oproep
		// gedaan voor het oude, gedeselecteerde item. Daarom kunnen we maar beter
		// geselecteerde items niet markeren.
{		if Index <> RegelList.ItemIndex then}
			Canvas.Brush.Color := clBlack
{		else
			Canvas.Brush.Color := clHighlight};
		Canvas.Font.Color := clTeal;
		TopDif := (ItemHeight div 2) - (Canvas.TextHeight(#32) div 2);
		Canvas.TextRect(Rect, Rect.Left+2, Rect.Top + TopDif, Items[Index]);
	end;
end;

end.
