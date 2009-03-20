unit stwsimEditMain;

interface

{$DEFINE EDITOR}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, stwvGleisplan, StdCtrls, Buttons, ExtCtrls, Spin,
  stwvCore, stwvMeetpunt, stwvSeinen, stwvSporen, Menus, stwvHokjes, Mask,
  ActnList, stwvRijwegen, stwsimEditHelpers, stwvMisc, stwvRijwegLogica;

type
	firstlast = (flFirst, flLast);

	TUpdateChg = record
		Infra: boolean;
		Meetpunten: boolean;
		Erlaubnisse: boolean;
		Seinen: boolean;
		Wissels: boolean;
		Overweg: boolean;
		Overwegen: boolean;
		Rijwegen: boolean;
		Rijweg: boolean;
		PrlRijwegen: boolean;
		PrlRijweg: boolean;
		Schermaantal: boolean;
		Schermen: boolean;
	end;

	TstwseMain = class(TForm)
	 SchermenTab: TTabControl;
	 Splitter1: TSplitter;
	 MainMenu1: TMainMenu;
	 Bestand1: TMenuItem;
	 Help1: TMenuItem;
	 Info1: TMenuItem;
	 Beeld1: TMenuItem;
    Treinnummersweergeven1: TMenuItem;
	 ActionList: TActionList;
    TreinnrWeergeven: TAction;
    bottomPanel: TPanel;
    editPC: TPageControl;
	 algTab: TTabSheet;
    mtab: TTabSheet;
    ovTab: TTabSheet;
	 wTab: TTabSheet;
    Label3: TLabel;
	 Label4: TLabel;
	 wdBut: TButton;
    wtBut: TButton;
    wnEdit: TEdit;
	 wList: TListBox;
	 wmBox: TComboBox;
	 gplTab: TTabSheet;
	 tsBut: TButton;
	 nsEdit: TEdit;
    dsBut: TButton;
	 nsBut: TButton;
    reTab: TTabSheet;
    knoppenPanel: TPanel;
    SpeedButton12: TSpeedButton;
	 SpeedButton11: TSpeedButton;
	 SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
	 SpeedButton5: TSpeedButton;
	 SpeedButton6: TSpeedButton;
	 SpeedButton10: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton16: TSpeedButton;
	 SpeedButton15: TSpeedButton;
	 SpeedButton17: TSpeedButton;
    Label1: TLabel;
	 Label2: TLabel;
    Label5: TLabel;
	 Label6: TLabel;
    Label11: TLabel;
	 SpeedButton18: TSpeedButton;
	 Label12: TLabel;
	 Label13: TLabel;
	 Label14: TLabel;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
	 SpeedButton21: TSpeedButton;
	 SpeedButton22: TSpeedButton;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    mElBox: TComboBox;
    elCheck: TCheckBox;
	 wElBox: TComboBox;
	 sElBox: TComboBox;
	 txTxt: TEdit;
    lenEdit: TSpinEdit;
    mTnBox: TComboBox;
	 infoBox: TGroupBox;
    infoMemo: TMemo;
    OpslaanAls: TAction;
    Openen: TAction;
	 Openen1: TMenuItem;
    OpslaanAls1: TMenuItem;
	 exitAct: TAction;
    Afsluiten1: TMenuItem;
	 OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    rijwegTab: TTabSheet;
	 rijwegbox: TGroupBox;
	 rList: TListBox;
	 rtBut: TButton;
	 rdBut: TButton;
    drawNiks: TSpeedButton;
	 SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    Label22: TLabel;
    Label23: TLabel;
	 Label24: TLabel;
    SpeedButton31: TSpeedButton;
    SpeedButton34: TSpeedButton;
	 SpeedButton36: TSpeedButton;
    Label25: TLabel;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    Label26: TLabel;
    eElBox: TComboBox;
    Panel1: TPanel;
	 eDownBut: TRadioButton;
	 eUpBut: TRadioButton;
	 wgBox: TComboBox;
    Label28: TLabel;
    basisRechtdoor: TCheckBox;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    textBox: TGroupBox;
    txNormal: TRadioButton;
    txSpoornummer: TRadioButton;
    txSeinWisselNr: TRadioButton;
    txKleur: TComboBox;
	 Label7: TLabel;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
	 tsLast: TCheckBox;
    rijwegeditbox: TGroupBox;
    Label18: TLabel;
	 Label19: TLabel;
    Label20: TLabel;
	 rijwegVanWijzig: TSpeedButton;
    rijwegNaarWijzig: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    rijwegNiks: TSpeedButton;
    seinWijzigKlik: TSpeedButton;
	 Label21: TLabel;
    SpeedButton37: TSpeedButton;
    richtingWijzigBut: TSpeedButton;
    Label27: TLabel;
    richtingWisBut: TSpeedButton;
    rijwegVanEdit: TEdit;
    rijwegNaarEdit: TEdit;
    seinEdit: TEdit;
    rijwegBestaatUit: TListBox;
    richtingEdit: TEdit;
    PrlRijwegTab: TTabSheet;
	 prlRBox: TGroupBox;
	 prlRlist: TListBox;
    prlrtBut: TButton;
    prlrdBut: TButton;
    prlreditbox: TGroupBox;
	 Label29: TLabel;
    prlSpoorLijst: TListBox;
    AddPrlSpoorBut: TSpeedButton;
	 RmPrlSpoorBut: TSpeedButton;
    Label31: TLabel;
	 DwangEdit: TEdit;
    prlRijwegNiks: TSpeedButton;
    prlrtStatus: TLabel;
    rtpCopyBut: TButton;
    mgroup: TGroupBox;
    mdBut: TButton;
    mtBut: TButton;
    mEdit: TEdit;
    mList: TListBox;
    Rijrichtingsvelden: TGroupBox;
	 edBut: TButton;
    etBut: TButton;
    eEdit: TEdit;
    eList: TListBox;
    sGroup: TGroupBox;
    sEdit: TEdit;
	 stBut: TButton;
    sdBut: TButton;
    sList: TListBox;
    ovmgroep: TGroupBox;
	 movdbut: TButton;
    movtbut: TButton;
    ovmList: TListBox;
    mOvBox: TComboBox;
    ovGroup: TGroupBox;
	 ovList: TListBox;
    ovdbut: TButton;
    ovtbut: TButton;
    ovEdit: TEdit;
	 ovmaDBut: TButton;
    ovmaTBut: TButton;
    ovmaList: TListBox;
    Label33: TLabel;
    Label34: TLabel;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    GroupBox1: TGroupBox;
    detailsOff: TRadioButton;
    detailsOn: TRadioButton;
    Label32: TLabel;
    rijwegtnvvanedit: TEdit;
    tnvvanwijzig: TSpeedButton;
	 tnvvanwis: TSpeedButton;
    Label35: TLabel;
    rijwegtnvnaaredit: TEdit;
	 tnvnaarwijzig: TSpeedButton;
    tnvnaarwis: TSpeedButton;
    naarSeinWijzigBut: TSpeedButton;
	 naarSeinEdit: TEdit;
    Label36: TLabel;
    naarseinWisBut: TSpeedButton;
    triggerDelBut: TSpeedButton;
    triggerChgBut: TSpeedButton;
    triggerEdit: TEdit;
    Label30: TLabel;
    onbevCheck: TCheckBox;
    InfraOpenDialog: TOpenDialog;
    InfraOpenBut: TButton;
    infraStatus: TLabel;
    Opslaan: TAction;
	 Opslaan1: TMenuItem;
    Label8: TLabel;
    RijwegSubroutes: TListBox;
    SubrouteUp: TBitBtn;
    SubrouteDown: TBitBtn;
    BlinkTimer: TTimer;
	 procedure mtButClick(Sender: TObject);
	 procedure mdButClick(Sender: TObject);
	 procedure FormCreate(Sender: TObject);
	 procedure Info1Click(Sender: TObject);
	 procedure stButClick(Sender: TObject);
	 procedure sdButClick(Sender: TObject);
	 procedure wtButClick(Sender: TObject);
	 procedure wdButClick(Sender: TObject);
	 procedure tsButClick(Sender: TObject);
	 procedure SchermenTabChange(Sender: TObject);
	 procedure nsButClick(Sender: TObject);
	 procedure GleisplanMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	 procedure GleisplanMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
	 procedure GleisplanClick(Sender: TObject);
	 procedure SpeedButton11Click(Sender: TObject);
	 procedure SpeedButton12Click(Sender: TObject);
	 procedure mElBoxChange(Sender: TObject);
    procedure wElBoxChange(Sender: TObject);
    procedure sElBoxChange(Sender: TObject);
	 procedure SpeedButton1Click(Sender: TObject);
	 procedure SpeedButton2Click(Sender: TObject);
	 procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
	 procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
	 procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
	 procedure SpeedButton16Click(Sender: TObject);
	 procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
	 procedure mTnBoxChange(Sender: TObject);
	 procedure SpeedButton18Click(Sender: TObject);
	 procedure TreinnrWeergevenExecute(Sender: TObject);
	 procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
	 procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure OpslaanAlsExecute(Sender: TObject);
	 procedure OpenenExecute(Sender: TObject);
    procedure exitActExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	 procedure rtButClick(Sender: TObject);
	 procedure rdButClick(Sender: TObject);
	 procedure editPCChange(Sender: TObject);
	 procedure drawNiksClick(Sender: TObject);
	 procedure rListClick(Sender: TObject);
	 procedure rijwegVanWijzigClick(Sender: TObject);
	 procedure rijwegNaarWijzigClick(Sender: TObject);
	 procedure seinWijzigKlikClick(Sender: TObject);
	 procedure SpeedButton23Click(Sender: TObject);
	 procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
	 procedure SpeedButton26Click(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
	 procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
	 procedure SpeedButton34Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
	 procedure SpeedButton37Click(Sender: TObject);
    procedure etButClick(Sender: TObject);
    procedure edButClick(Sender: TObject);
    procedure eElBoxChange(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure SpeedButton39Click(Sender: TObject);
	 procedure richtingWijzigButClick(Sender: TObject);
    procedure richtingWisButClick(Sender: TObject);
    procedure wnEditChange(Sender: TObject);
    procedure SpeedButton40Click(Sender: TObject);
    procedure SpeedButton41Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure prlrtButClick(Sender: TObject);
    procedure prlRlistClick(Sender: TObject);
    procedure prlrdButClick(Sender: TObject);
    procedure DwangEditChange(Sender: TObject);
	 procedure RmPrlSpoorButClick(Sender: TObject);
	 procedure AddPrlSpoorButClick(Sender: TObject);
    procedure triggerDelButClick(Sender: TObject);
    procedure triggerChgButClick(Sender: TObject);
	 procedure prlRijwegNiksClick(Sender: TObject);
	 procedure rtpCopyButClick(Sender: TObject);
    procedure ovtbutClick(Sender: TObject);
    procedure ovdbutClick(Sender: TObject);
    procedure ovListClick(Sender: TObject);
    procedure movtbutClick(Sender: TObject);
    procedure movdbutClick(Sender: TObject);
    procedure ovmaTButClick(Sender: TObject);
    procedure ovmaDButClick(Sender: TObject);
	 procedure SpeedButton43Click(Sender: TObject);
	 procedure SpeedButton42Click(Sender: TObject);
    procedure detailsOnClick(Sender: TObject);
    procedure detailsOffClick(Sender: TObject);
    procedure tnvvanwisClick(Sender: TObject);
    procedure tnvnaarwisClick(Sender: TObject);
	 procedure tnvvanwijzigClick(Sender: TObject);
    procedure tnvnaarwijzigClick(Sender: TObject);
    procedure naarSeinWijzigButClick(Sender: TObject);
    procedure naarseinWisButClick(Sender: TObject);
    procedure onbevCheckClick(Sender: TObject);
    procedure InfraOpenButClick(Sender: TObject);
    procedure OpslaanExecute(Sender: TObject);
	 procedure RijwegSubroutesClick(Sender: TObject);
	 procedure SubrouteUpClick(Sender: TObject);
	 procedure SubrouteDownClick(Sender: TObject);
	 procedure BlinkTimerTimer(Sender: TObject);
	private
		FirstTab:		PTablist;
		VisibleTab: 	PTabList;
		Core:				TvCore;
		RijwegLogica: 	TRijwegLogica;
		UpdateChg:		TUpdateChg;
		Modified: 		boolean;
		FTreinnrWeergeven: boolean;
		p_mode:			integer;
		p_gix,
		p_giy:			integer;
		gselx,
		gsely: 			integer;
		selMeetpunt:	PvMeetpunt;
		selTnMeetpunt:	PvMeetpunt;
		selErlaubnis:	PvErlaubnis;
		selSein:			PvSein;
		selWissel:		PvWissel;
		selOverweg:		PvOverweg;
		selRijweg:		PvRijweg;
		selPrlRijweg:	PvPrlRijweg;
		klikVan:			string;
		filename:		string;
		// Fysieke infrastructuur
		Infrastructuur:	TStringList;
		procedure UpdateSubrouteUpDownCtls;
		procedure UpdateControls;
		procedure SwapSubroutes(eersteIdx, tweedeIdx: integer);
		procedure AddScherm(ID: integer; titel: string; waar: firstlast; details: boolean);
		function GetScherm(ID: Integer): PTabList;
		function SchermTitel(ID: integer): string;
		function SchermNieuwID: integer;
		procedure SaveInfra(var f: file; Infra: TStringList);
		procedure LoadInfra(var f: file; Infra: TStringList);
	public
	end;

var
  stwseMain: TstwseMain;

implementation

uses stwsimClientEditInfo;

{$R *.DFM}

const
	MagicCode = 'StwSim Client Beta 7';

procedure TstwseMain.UpdateSubrouteUpDownCtls;
begin
	SubrouteUp.Enabled := RijwegSubroutes.ItemIndex >= 1;
	SubrouteDown.Enabled := (RijwegSubroutes.ItemIndex >= 0) and
									(RijwegSubroutes.ItemIndex <= RijwegSubroutes.Items.Count-2);
end;

procedure TstwseMain.UpdateControls;
var
	Meetpunt:	PvMeetpunt;
	Sein:			PvSein;
	WisselGroep:PvWisselGroep;
	Wissel:		PvWissel;
	Tab:			PTablist;
	Rijweg:		PvRijweg;
	Erlaubnis:	PvErlaubnis;
	Overweg:		PvOverweg;
	MeetpuntL:	PvMeetpuntLijst;
	rDesc:		string;
	PrlrDesc:	string;
	sel: 			string;
	wsk, wsl:	string;
	i,j: 			integer;
	Hokje:			TvHokje;
	InactiefHokje:	PvInactiefHokje;
	KruisingHokje:	PvKruisingHokje;
	rMeetpunt:	PvMeetpuntLijst;
	rWissel:		PvWisselstand;
	PrlRijweg:	PvPrlRijweg;
	RijwegLijst:	PvRijwegLijst;
begin
	if UpdateChg.Infra then begin
		if Infrastructuur.Count < 2 then
			infraStatus.Caption := 'GEEN INFRASTRUCTUUR GELADEN!'
		else
			infraStatus.Caption := 'Infrastructuur geladen: '+Infrastructuur[0]+' '+Infrastructuur[1];
		UpdateChg.Infra := false;
	end;
	if UpdateChg.Meetpunten then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		Meetpunt := Core.vAlleMeetpunten;
		if mElBox.Items.Count = 0 then
			mElBox.Items.Add('-');
		while assigned(Meetpunt) do begin
			if mList.Items.Count-1 >= i then
				mList.Items[i] := Meetpunt^.meetpuntID
			else
				mList.Items.Add(Meetpunt^.meetpuntID);
			if mElBox.Items.Count-1 >= i+1 then
				mElBox.Items[i+1] := Meetpunt^.meetpuntID
			else
				mElBox.Items.Add(Meetpunt^.meetpuntID);
			if mTnBox.Items.Count-1 >= i then
				mTnBox.Items[i] := Meetpunt^.meetpuntID
			else
				mTnBox.Items.Add(Meetpunt^.meetpuntID);
			if wmBox.Items.Count-1 >= i then
				wmBox.Items[i] := Meetpunt^.meetpuntID
			else
				wmBox.Items.Add(Meetpunt^.meetpuntID);
			if mOvBox.Items.Count-1 >= i then
				mOvBox.Items[i] := Meetpunt^.meetpuntID
			else
				mOvBox.Items.Add(Meetpunt^.meetpuntID);
			Meetpunt := Meetpunt.Volgende;
			i := i + 1;
		end;
		while mList.Items.Count-1 >= i do
			mList.Items.Delete(mList.Items.Count-1);
		while mElBox.Items.Count-1 >= i+1 do
			mElBox.Items.Delete(mElBox.Items.Count-1);
		while mTnBox.Items.Count-1 >= i do
			mTnBox.Items.Delete(mTnBox.Items.Count-1);
		while wmBox.Items.Count-1 >= i do
			wmBox.Items.Delete(wmBox.Items.Count-1);
		while mOvBox.Items.Count-1 >= i do
			mOvBox.Items.Delete(mOvBox.Items.Count-1);
		mElBox.ItemIndex := 0;
		selMeetpunt := nil;
		selTnMeetpunt := nil;
		UpdateChg.Meetpunten := false;
	end;
	if UpdateChg.Erlaubnisse then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		Erlaubnis := Core.vAlleErlaubnisse;
		while assigned(Erlaubnis) do begin
			if eList.Items.Count-1 >= i then
				eList.Items[i] := Erlaubnis^.erlaubnisID
			else
				eList.Items.Add(Erlaubnis^.erlaubnisID);
			if eElBox.Items.Count-1 >= i then
				eElBox.Items[i] := Erlaubnis^.erlaubnisID
			else
				eElBox.Items.Add(Erlaubnis^.erlaubnisID);
			Erlaubnis := Erlaubnis.Volgende;
			i := i + 1;
		end;
		while eList.Items.Count-1 >= i do
			eList.Items.Delete(eList.Items.Count-1);
		while eElBox.Items.Count-1 >= i do
			eElBox.Items.Delete(eElBox.Items.Count-1);
		selErlaubnis := nil;
		UpdateChg.Erlaubnisse := false;
	end;
	if UpdateChg.Seinen then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		Sein := Core.vAlleSeinen;
		if sElBox.Items.Count = 0 then
			sElBox.Items.Add('-');
		while assigned(Sein) do begin
			if sList.Items.Count-1 >= i then
				sList.Items[i] := Sein^.Naam
			else
				sList.Items.Add(Sein^.Naam);
			if sElBox.Items.Count-1 >= i+1 then
				sElBox.Items[i+1] := Sein^.Naam
			else
				sElBox.Items.Add(Sein^.Naam);
			Sein := Sein.Volgende;
			i := i + 1;
		end;
		while sList.Items.Count-1 >= i do
			sList.Items.Delete(sList.Items.Count-1);
		while sElBox.Items.Count-1 >= i+1 do
			sElBox.Items.Delete(sElBox.Items.Count-1);
		selSein := nil;
		UpdateChg.Seinen := false;
	end;
	if UpdateChg.Wissels then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		j := 0;
		WisselGroep := Core.vAlleWisselGroepen;
		while assigned(Wisselgroep) do begin
			if wgBox.Items.Count-1 >= j+1 then
				wgBox.Items[j+1] := WisselGroep^.GroepID
			else
				wgBox.Items.Add(WisselGroep^.GroepID);
			j := j + 1;
			Wissel := WisselGroep^.EersteWissel;
			while assigned(Wissel) do begin
				wsk := Wissel^.WisselID+' @ '+Wissel^.Meetpunt^.meetpuntID;
				if Wissel^.BasisstandRecht then
					wsl := WisselGroep.GroepID+' : '+Wissel^.WisselID+' @ '+Wissel^.Meetpunt^.meetpuntID
				else
					wsl := WisselGroep.GroepID+' : '+Wissel^.WisselID+' (aftakkend) @ '+Wissel^.Meetpunt^.meetpuntID;
				if wList.Items.Count-1 >= i then
					wList.Items[i] := wsl
				else
					wList.Items.Add(wsl);
				if wElBox.Items.Count-1 >= i then
					wElBox.Items[i] := wsk
				else
					wElBox.Items.Add(wsk);
				i := i + 1;
				Wissel := Wissel.Volgende;
			end;
			WisselGroep := WisselGroep^.Volgende;
		end;
		while wList.Items.Count-1 >= i do
			wList.Items.Delete(wList.Items.Count-1);
		while wgBox.Items.Count-1 >= j+1 do
			wgBox.Items.Delete(wgBox.Items.Count-1);
		while wElBox.Items.Count-1 >= i do
			wElBox.Items.Delete(wElBox.Items.Count-1);
		selWissel := nil;
		UpdateChg.Wissels := false;
	end;
	if UpdateChg.Schermaantal then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		Tab := FirstTab;
		while assigned(Tab) do begin
			if SchermenTab.Tabs.Count-1 >= i then
				SchermenTab.Tabs[i] := Tab^.Titel
			else
				SchermenTab.Tabs.Add(Tab^.Titel);
			Tab := Tab.Volgende;
			i := i + 1;
		end;
		while SchermenTab.Tabs.Count-1 >= i do
			SchermenTab.Tabs.Delete(SchermenTab.Tabs.Count-1);

		sel := SchermenTab.Tabs[SchermenTab.TabIndex];
		Tab := FirstTab;
		while assigned(Tab) do begin
			Tab^.Scrollbox.Visible := (Tab^.Titel = sel);
			if Tab^.Scrollbox.Visible then
				visibleTab := Tab;
			Tab := Tab^.Volgende;
		end;

		detailsOn.Checked := visibleTab^.Details;
		detailsOff.Checked := not visibleTab^.Details;

		UpdateChg.Schermaantal := false;
	end;
	if UpdateChg.Overwegen then begin
		Overweg := Core.vAlleOverwegen;
		i := 0;
		while assigned(Overweg) do begin
			if ovList.Items.Count-1 >= i then
				ovList.Items[i] := Overweg^.Naam
			else
				ovList.Items.Add(Overweg^.Naam);
			inc(i);
			Overweg := Overweg^.Volgende;
		end;
		while ovList.Items.Count-1 >= i do
			ovList.Items.Delete(ovList.Items.Count-1);
		selOverweg := nil;
		UpdateChg.Overwegen := false;
	end;
	if UpdateChg.Overweg then begin
		ovmList.Items.Clear;
		if assigned(selOverweg) then begin
			MeetpuntL := selOverweg^.Meetpunten;
			while assigned(MeetpuntL) do begin
				ovmList.Items.Add(MeetpuntL^.Meetpunt^.meetpuntID);
				MeetpuntL := MeetpuntL^.Volgende;
			end;
		end;
		ovmaList.Items.Clear;
		if assigned(selOverweg) then begin
			MeetpuntL := selOverweg^.AankMeetpunten;
			while assigned(MeetpuntL) do begin
				ovmaList.Items.Add(MeetpuntL^.Meetpunt^.meetpuntID);
				MeetpuntL := MeetpuntL^.Volgende;
			end;
		end;
		UpdateChg.Overweg := false;
	end;
	if UpdateChg.Schermen then begin
		Tab := FirstTab;
		while assigned(Tab) do begin
			Tab^.Gleisplan.LaatAlleTreinnrPosZien := FTreinnrWeergeven;
			Tab^.Gleisplan.Repaint;
			Tab := Tab.Volgende;
		end;
		UpdateChg.Schermen := false;
	end;
	if UpdateChg.Rijwegen then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		Rijweg := Core.vAlleRijwegen;
		while assigned(Rijweg) do begin
			if assigned(Rijweg^.Sein) then
				rDesc := 'Van '+KlikpuntTekst(Rijweg^.Sein^.Van, true)+' naar '+KlikpuntTekst(Rijweg^.Naar, true)
			else
				rDesc := 'Van '+KlikpuntTekst('', true)+' naar '+KlikpuntTekst(Rijweg^.Naar, true);
			if rList.Items.Count >= i then
				rList.Items[i] := rDesc
			else
				rList.Items.Add(rDesc);
			Rijweg := Rijweg^.Volgende;
			i := i + 1;
		end;
		while rList.Items.Count-1 >= i do
			rList.Items.Delete(rList.Items.Count-1);
		UpdateChg.Rijwegen := false;
	end;
	if UpdateChg.Rijweg then begin
		WisRijwegenVanPlan(VisibleTab^.Gleisplan);

		Rijweg := selRijweg;

		if assigned(Rijweg) and assigned(VisibleTab^.Gleisplan) then begin
			// En deze rijweg weergeven.
			KruisingHokje := Rijweg.KruisingHokjes;
			while assigned(KruisingHokje) do begin
				if KruisingHokje.schermID = VisibleTab^.ID then begin
					Hokje := VisibleTab^.Gleisplan.GetHokje(KruisingHokje.x, KruisingHokje.y);
					case Hokje.Soort of
						1: if KruisingHokje.RechtsonderKruisRijweg then
								PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg := 1
							else
								PvHokjeSpoor(Hokje.grdata).RechtsonderKruisRijweg := 2;
					end;
				end;
				KruisingHokje := KruisingHokje.Volgende;
			end;
			rWissel := Rijweg.Wisselstanden;
			while assigned(rWissel) do begin
				Wissel := rWissel^.Wissel;
				Wissel^.RijwegOnderdeel := Rijweg;
				if rWissel^.Rechtdoor then
					Wissel^.Stand := wsRechtdoor
				else
					Wissel^.Stand := wsAftakkend;
				VisibleTab^.Gleisplan.PaintWissel(Wissel);
				rWissel := rWissel^.volgende;
			end;
			rMeetpunt := Rijweg.Meetpunten;
			while assigned(rMeetpunt) do begin
				Meetpunt := rMeetpunt^.Meetpunt;
				Meetpunt^.RijwegOnderdeel := Rijweg;
				RijwegLogica.DoeHokjes(Meetpunt, true);
				VisibleTab^.Gleisplan.PaintMeetpunt(Meetpunt);
				rMeetpunt := rMeetpunt^.volgende;
			end;
			if assigned(Rijweg^.Sein) then begin
				Rijweg^.Sein^.Stand := 'g';
				Rijweg^.Sein^.RijwegOnderdeel := Rijweg;
				VisibleTab^.Gleisplan.PaintSein(Rijweg^.Sein);
			end;
			if assigned(Rijweg^.Erlaubnis) then begin
				Rijweg^.Erlaubnis^.richting := Rijweg^.Erlaubnisstand;
				VisibleTab^.Gleisplan.PaintErlaubnis(Rijweg^.Erlaubnis);
			end;
			if assigned(Rijweg^.Sein) then begin
				rMeetpunt := Rijweg^.Sein^.HerroepMeetpunten;
				while assigned(rMeetpunt) do begin
					Meetpunt := rMeetpunt^.Meetpunt;
					Meetpunt^.bezet := true;
					VisibleTab^.Gleisplan.PaintMeetpunt(Meetpunt);
					rMeetpunt := rMeetpunt^.volgende;
				end;
			end;
		end;

		RijwegSubroutes.Items.Clear;
		RijwegBestaatUit.Items.Clear;
		RijwegVanEdit.Text := '';
		RijwegNaarEdit.Text := '';
		RijwegTNVVanEdit.Text := '';
		RijwegTNVNaarEdit.Text := '';
		seinEdit.Text := '';
		NaarseinEdit.Text := '';
		UpdateSubrouteUpDownCtls;
		if assigned(Rijweg) then begin
			// Inhoudsopgave bijwerken
			rMeetpunt := Rijweg.Meetpunten;
			while assigned(rMeetpunt) do begin
				Meetpunt := rMeetpunt^.Meetpunt;
				RijwegSubroutes.Items.Add(Meetpunt^.meetpuntID);
				rMeetpunt := rMeetpunt^.volgende;
			end;
			RijwegBestaatUit.Items.Add('APPROACH-LOCKING-MEETPUNTEN:');
			if assigned(Rijweg^.Sein) then begin
				rMeetpunt := Rijweg^.Sein^.HerroepMeetpunten;
				while assigned(rMeetpunt) do begin
					Meetpunt := rMeetpunt^.Meetpunt;
					RijwegBestaatUit.Items.Add(Meetpunt^.meetpuntID);
					rMeetpunt := rMeetpunt^.volgende;
				end;
			end;
			RijwegBestaatUit.Items.Add('WISSELS:');
			rWissel := Rijweg.Wisselstanden;
			while assigned(rWissel) do begin
				Wissel := rWissel^.Wissel;
				if rWissel^.Rechtdoor then
					RijwegBestaatUit.Items.Add(Wissel^.WisselID+' in rechtdoor-stand')
				else
					RijwegBestaatUit.Items.Add(Wissel^.WisselID+' in aftakkende stand');
				rWissel := rWissel^.volgende;
			end;
			RijwegBestaatUit.Items.Add('KRUISING-INFORMATIE:');
			KruisingHokje := Rijweg.KruisingHokjes;
			while assigned(KruisingHokje) do begin
				if KruisingHokje.RechtsonderKruisRijweg then
					RijwegBestaatUit.Items.Add('['+inttostr(KruisingHokje.x)+','+
					inttostr(KruisingHokje.y)+'] op scherm '+SchermTitel(KruisingHokje.schermID)+
					' van linksboven naar rechtsonder (\)')
				else
					RijwegBestaatUit.Items.Add('['+inttostr(KruisingHokje.x)+','+
					inttostr(KruisingHokje.y)+'] op scherm '+SchermTitel(KruisingHokje.schermID)+
					' van linksonder naar rechtsboven (/)');
				KruisingHokje := KruisingHokje.Volgende;
			end;
			// Van-Naar etc. bijwerken
			if assigned(Rijweg^.Sein) then
				rijwegVanEdit.Text := KlikpuntTekst(Rijweg^.Sein^.Van, true)
			else
				rijwegVanEdit.Text := KlikpuntTekst('', true);
			rijwegNaarEdit.Text := KlikpuntTekst(Rijweg.Naar, true);
         onbevCheck.Checked := Rijweg^.NaarOnbeveiligd;
			if assigned(Rijweg^.Sein) and assigned(Rijweg^.Sein^.TriggerMeetpunt) then
				triggerEdit.Text := Rijweg^.Sein^.TriggerMeetpunt^.meetpuntID
			else
				triggerEdit.Text := '';
			if assigned(Rijweg.Sein) then
				seinEdit.Text := Rijweg.Sein^.Naam
			else
				seinEdit.Text := '';
			if assigned(Rijweg.NaarSein) then
				NaarseinEdit.Text := Rijweg.NaarSein^.Naam
			else
				NaarseinEdit.Text := '';
			if assigned(Rijweg^.Sein) and assigned(Rijweg^.Sein^.VanTNVMeetpunt) then
				RijwegTNVVanEdit.Text := Rijweg^.Sein^.VanTNVMeetpunt^.meetpuntID;
			if assigned(Rijweg^.NaarTNVMeetpunt) then
				RijwegTNVNaarEdit.Text := Rijweg^.NaarTNVMeetpunt^.meetpuntID;
			if assigned(Rijweg^.Erlaubnis) then begin
				if Rijweg^.Erlaubnisstand = 1 then
					richtingEdit.Text := Rijweg^.Erlaubnis^.erlaubnisID+' - Up'
				else if Rijweg^.Erlaubnisstand = 2 then
					richtingEdit.Text := Rijweg^.Erlaubnis^.erlaubnisID+' - Down';
			end else
				richtingEdit.Text := '';
		end;
		UpdateChg.Rijweg := false;
	end;
	if UpdateChg.PrlRijwegen then begin
		modified := true; Openen.Enabled := false;
		i := 0;
		PrlRijweg := Core.vAllePrlRijwegen;
		while assigned(PrlRijweg) do begin
			PrlrDesc := 'Van '+KlikpuntTekst(PrlRijweg^.Van, true)+' naar '+KlikpuntTekst(PrlRijweg^.Naar, true);
			if PrlrList.Items.Count >= i then
				PrlrList.Items[i] := PrlrDesc
			else
				PrlrList.Items.Add(rDesc);
			PrlRijweg := PrlRijweg^.Volgende;
			i := i + 1;
		end;
		while PrlrList.Items.Count-1 >= i do
			PrlrList.Items.Delete(PrlrList.Items.Count-1);
		UpdateChg.PrlRijwegen := false;
	end;
	if UpdateChg.PrlRijweg then begin
		prlSpoorLijst.Items.Clear;
		triggerEdit.Text := '';
		DwangEdit.Text := '';
		prlrtStatus.Caption := 'Gereed.';
		if assigned(selPrlRijweg) then begin
			RijwegLijst := selPrlRijweg^.Rijwegen;
			while assigned(RijwegLijst) do begin
				prlSpoorLijst.Items.Add('Van '+KlikpuntTekst(RijwegLijst^.Rijweg^.Sein^.Van, true)+
					' naar '+KlikpuntTekst(RijwegLijst^.Rijweg^.Naar, true));
				RijwegLijst := RijwegLijst^.Volgende;
			end;
			dwangEdit.Text := inttostr(selPrlRijweg^.Dwang);
		end;
		UpdateChg.PrlRijweg := false;
	end;
end;

procedure TstwseMain.SwapSubroutes;
var
	Eerste, nEerste: PvMeetpuntLijst;
	Tweede, nTweede: PvMeetpuntLijst;
	tmpMeetpuntL: PvMeetpuntLijst;
	i: integer;
begin
	if not assigned(selRijweg) then exit;
	if eersteIdx = tweedeIdx then exit;
	// Zoek het eerste ding
	Eerste := selRijweg^.Meetpunten;
	for i := 1 to eersteIdx do
		Eerste := Eerste^.Volgende;
	nEerste := Eerste^.Volgende;
	// Zoek het tweede ding
	Tweede := selRijweg^.Meetpunten;
	for i := 1 to tweedeIdx do
		Tweede := Tweede^.Volgende;
	nTweede := Tweede^.Volgende;
	// Wissel om
	new(tmpMeetpuntL);
	tmpMeetpuntL^ := Eerste^;
	Eerste^ := Tweede^;
	Tweede^ := tmpMeetpuntL^;
	Eerste^.Volgende := nEerste;
	Tweede^.Volgende := nTweede;
	dispose(tmpMeetpuntL);
	// De lijst bijwerken
	RijwegSubroutes.Items[eersteIdx] := Eerste^.Meetpunt^.meetpuntID;
	RijwegSubroutes.Items[tweedeIdx] := Tweede^.Meetpunt^.meetpuntID;
	// En dit nog doen.
   Modified := true;
end;

procedure TstwseMain.AddScherm;
var
	Tab, l: PTabList;
begin
	new(Tab);
	Tab^.Titel := Titel;
	Tab^.ID := ID;
	Tab^.Details := Details;
	Tab^.Scrollbox := TScrollBox.Create(Self);
	Tab^.Scrollbox.Parent := SchermenTab;
	Tab^.Scrollbox.HorzScrollBar.Tracking := true;
	Tab^.Scrollbox.VertScrollBar.Tracking := true;
	Tab^.Scrollbox.Align := alClient;
	Tab^.Scrollbox.Color := clBlack;
	Tab^.Scrollbox.Visible := false;
	Tab^.Gleisplan := TvGleisplan.Create(Self);
	Tab^.Gleisplan.Parent := Tab^.Scrollbox;
	Tab^.Gleisplan.OnMouseDown := GleisplanMouseDown;
	Tab^.Gleisplan.OnMouseMove := GleisplanMouseMove;
	Tab^.Gleisplan.OnClick := GleisplanClick;
	Tab^.Gleisplan.Top := 0;
	Tab^.Gleisplan.Left := 0;
	Tab^.Gleisplan.MaxX := 125;
	Tab^.Gleisplan.MaxY := 36;
	Tab^.Gleisplan.Core := @Core;
	Tab^.Gleisplan.ShowSeinen := true;
	Tab^.Gleisplan.ShowSeinWisselNummers := true;
	Tab^.Gleisplan.ShowInactieveRichtingen := true;
	Tab^.Gleisplan.ShowPointPositions := false;
	Tab^.Gleisplan.OnbekendeWisselsKnipperen := false;
	Tab^.Gleisplan.Visible := true;
	if waar = flLast then begin
		Tab^.Volgende := nil;
		l := FirstTab;
		if not assigned(l) then
			FirstTab := Tab
		else begin
			while assigned(l^.volgende) do
				l := l^.volgende;
			l^.volgende := Tab;
		end;
	end;
	if waar = flFirst then begin
		Tab^.Volgende := FirstTab;
		FirstTab := Tab;
	end;
	RijwegLogica.Tabs := FirstTab;
end;

function TstwseMain.GetScherm;
var
	l: PTabList;
begin
	result := nil;
	l := FirstTab;
	while assigned(l) do begin
		if l^.ID = ID then begin
			result := l;
			exit;
		end;
		l := l^.Volgende;
	end;
end;

function TstwseMain.SchermTitel;
var
	l: PTabList;
begin
	l := GetScherm(ID);
	if assigned(l) then
		result := l^.Titel
	else
		result := '';
end;

function TstwseMain.SchermNieuwID;
var
	l: PTabList;
begin
	result := 1;
	l := FirstTab;
	while assigned(l) do begin
		if l^.ID >= result then
			result := l^.ID + 1;
		l := l^.Volgende;
	end;
end;

procedure TstwseMain.mtButClick(Sender: TObject);
var
	Meetpunt:	PvMeetpunt;
	found:		boolean;
	nID:			string;
begin
	nID := mEdit.Text;
	if nID = '' then begin
		Application.MessageBox('Er is geen treindetectiepunt ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	found := false;
	Meetpunt := Core.vAlleMeetpunten;
	while assigned(Meetpunt) do begin
		if Meetpunt.meetpuntID = nID then found := true;
		Meetpunt := Meetpunt.Volgende;
	end;
	if found then begin
		Application.MessageBox('Dit treindetectiepunt is al ingevoerd.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	AddMeetpunt(@Core, nID);
	mEdit.Text := '';
	UpdateChg.Meetpunten := true;
	UpdateControls;
end;

procedure TstwseMain.mdButClick(Sender: TObject);
var
	tmpMeetpunt:	PvMeetpunt;
	vMeetpunt:	PvMeetpunt;
	Meetpunt:	PvMeetpunt;
	sID:			string;
	i: integer;
begin
	for i := 0 to mList.Items.Count-1 do
		if mList.Selected[i] then begin
			sID := mList.Items[i];
			vMeetpunt := nil;
			Meetpunt := Core.vAlleMeetpunten;
			while assigned(Meetpunt) do begin
				if Meetpunt.meetpuntID = sID then begin
					if assigned(vMeetpunt) then
						vMeetpunt.Volgende := Meetpunt.Volgende
					else
						Core.vAlleMeetpunten := Meetpunt.Volgende;
					tmpMeetpunt := Meetpunt;
					Meetpunt := Meetpunt.Volgende;
					dispose(tmpMeetpunt);
				end else begin
					vMeetpunt := Meetpunt;
					Meetpunt := Meetpunt.Volgende;
				end;
			end;
	end;
	UpdateChg.Meetpunten := true;
	UpdateControls;
end;

procedure TstwseMain.FormCreate(Sender: TObject);
begin
	Infrastructuur := TStringList.Create;
	EditPC.ActivePage := algTab;
	vCore_Create(@Core);
	RijwegLogica := TRijwegLogica.Create;
	RijwegLogica.Core := @Core;
	FTreinnrWeergeven := true;
	UpdateChg.Infra := true;
	UpdateChg.Meetpunten := false;
	UpdateChg.Seinen := false;
	UpdateChg.Wissels := false;
	UpdateChg.Schermaantal := false;
	UpdateChg.Schermen := false;
	UpdateControls;
	filename := '';
	p_mode := -1;
	modified := false;
end;

procedure TstwseMain.Info1Click(Sender: TObject);
begin
	stwsceInfoForm.ShowModal;
end;

procedure TstwseMain.stButClick(Sender: TObject);
var
	Sein:			PvSein;
	found:		boolean;
	nID:			string;
begin
	nID := sEdit.Text;
	if nID = '' then begin
		Application.MessageBox('Er is geen sein ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	found := false;
	Sein := Core.vAlleSeinen;
	while assigned(Sein) do begin
		if Sein.Naam = nID then found := true;
		Sein := Sein.Volgende;
	end;
	if found then begin
		Application.MessageBox('Dit sein is al ingevoerd.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	Sein := NieuwSein(@Core);
	Sein^.Naam := nID;
	sEdit.Text := '';
	UpdateChg.Seinen := true;
	UpdateControls;
end;

procedure TstwseMain.sdButClick(Sender: TObject);
var
	tmpSein:	PvSein;
	vSein:	PvSein;
	Sein:		PvSein;
	sID:		string;
	i: integer;
begin
	for i := 0 to sList.Items.Count-1 do
		if sList.Selected[i] then begin
			sID := sList.Items[i];
			vSein := nil;
			Sein := Core.vAlleSeinen;
			while assigned(Sein) do begin
				if Sein.Naam = sID then begin
					if assigned(vSein) then
						vSein.Volgende := Sein.Volgende
					else
						Core.vAlleSeinen := Sein.Volgende;
					tmpSein := Sein;
					Sein := Sein.Volgende;
					dispose(tmpSein);
				end else begin
					vSein := Sein;
					Sein := Sein.Volgende;
				end;
			end;
	end;
	UpdateChg.Seinen := true;
	UpdateControls;
end;

procedure TstwseMain.wtButClick(Sender: TObject);
var
	nID,mID,gID:string;
begin
	nID := wnEdit.Text;
	if nID = '' then begin
		Application.MessageBox('Er is geen wissel ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	if assigned(zoekWissel(@Core, nID)) then begin
		Application.MessageBox('Deze wissel is al ingevoerd.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	if wmBox.ItemIndex = -1 then begin
		Application.MessageBox('Er is geen meetpunt ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	gID := wgBox.Text;
	if gID='' then gID := nID;
	mID := wmBox.Items[wmBox.ItemIndex];
	AddWisselGroep(@core, gID);
	AddWissel(@Core, nID, mID, gID, basisRechtdoor.Checked);
	wnEdit.Text := '';
	wmBox.ItemIndex := -1;
	UpdateChg.Wissels := true;
	UpdateControls;
end;

procedure TstwseMain.wdButClick(Sender: TObject);
var
	Wissel:	PvWissel;
	i,j: 		integer;
begin
	for i := wList.Items.Count-1 downto 0 do
		if wList.Selected[i] then begin
			Wissel := EersteWissel(@Core);
			for j := 1 to i do
				Wissel := VolgendeWissel(Wissel);
			if assigned(Wissel) then
				DeleteWissel(@Core, Wissel^.WisselID);
		end;

	UpdateChg.Wissels := true;
	UpdateControls;
end;

procedure TstwseMain.tsButClick(Sender: TObject);
begin
	if nsEdit.Text <> '' then begin
		if tsLast.checked then
			AddScherm(SchermNieuwID, nsEdit.Text, flLast, detailsOn.Checked)
		else
			AddScherm(SchermNieuwID, nsEdit.Text, flFirst, detailsOn.Checked);
		UpdateChg.Schermaantal := true;
		UpdateChg.Schermen := true;
		UpdateControls;
		nsEdit.Text := '';
	end else begin
		Application.MessageBox('Er is geen titel ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
end;

procedure TstwseMain.SchermenTabChange(Sender: TObject);
begin
	selRijweg := nil;
	UpdateChg.Rijweg := true;
	UpdateChg.Schermaantal := true;
	UpdateControls;
end;

procedure TstwseMain.nsButClick(Sender: TObject);
begin
	if nsEdit.Text = '' then begin
		Application.MessageBox('Er is geen titel ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	VisibleTab^.Titel := nsEdit.Text;
	nsEdit.Text := '';
	UpdateChg.Schermaantal := true;
	UpdateControls;
end;

procedure TstwseMain.GleisplanMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
	Gleisplan: ^TvGleisplan;
	Hokje: TvHokje;
begin
	Gleisplan := @Sender;
	Gleisplan^.WatHier(x,y, gselx, gsely, hokje);
end;

procedure TstwseMain.GleisplanMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
	Gleisplan: ^TvGleisplan;
	Hokje: TvHokje;
	selx,sely: integer;
begin
	Gleisplan := @Sender;
	Gleisplan^.WatHier(x,y, selx, sely, hokje);
	infoMemo.Lines.Clear;
	infoMemo.Lines.Add('Hokje ['+inttostr(selx)+','+inttostr(sely)+']');
	infoMemo.Lines.Add('');
	case hokje.soort of
	0: infoMemo.Lines.Add('Leeg');
	1: begin
		infoMemo.Lines.Add('Spoor');
		if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt) then
			infoMemo.Lines.Add('Meetpunt: '+PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.meetpuntID);
		if assigned(PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein) then
			infoMemo.Lines.Add('Driehoekje-Sein: '+PvHokjeSpoor(Hokje.grdata)^.DriehoekjeSein^.Naam);
	end;
	2: begin
		infoMemo.Lines.Add('Tekst');
		if PvHokjeLetter(Hokje.grdata)^.Spoornummer <> '' then
			infoMemo.Lines.Add('Spoornummer: '+PvHokjeLetter(Hokje.grdata)^.Spoornummer);
		if PvHokjeLetter(Hokje.grdata)^.SeinWisselNr then
			infoMemo.Lines.Add('Sein- of wisselnummer.');
	end;
	3: begin
		infoMemo.Lines.Add('Sein');
		if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then
			infoMemo.Lines.Add('Sein: '+PvHokjeSein(Hokje.grdata)^.Sein^.Naam);
	end;
	4: infoMemo.Lines.Add('Decoratie');
	5: begin
		infoMemo.Lines.Add('Wissel');
		if assigned(PvHokjeWissel(Hokje.grdata)^.Wissel) then
			infoMemo.Lines.Add('Wissel: '+PvHokjeWissel(Hokje.grdata)^.Wissel^.WisselID);
		if assigned(PvHokjeWissel(Hokje.grdata)^.Meetpunt) then
			infoMemo.Lines.Add('Meetpunt: '+PvHokjeWissel(Hokje.grdata)^.Meetpunt^.meetpuntID);
	end;
	6: begin
		infoMemo.Lines.Add('Rijrichtingsveld');
		if assigned(PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis) then
			if PvHokjeErlaubnis(Hokje.grdata)^.ActiefStand = 1 then
				infoMemo.Lines.Add('Veld: '+PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.erlaubnisID+' (Up)')
			else if PvHokjeErlaubnis(Hokje.grdata)^.ActiefStand = 2 then
				infoMemo.Lines.Add('Veld: '+PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis^.erlaubnisID+' (Down)')
	end;
	end;
	if assigned(Hokje.dyndata) then begin
		infoMemo.Lines.Add('');
		infoMemo.Lines.Add('Hier staat karakter '+inttostr(Hokje.Dyndata.TekstIndex));
		infoMemo.Lines.Add('van het treinnumer van');
		infoMemo.Lines.Add('meetpunt '+Hokje.DynData.Meetpunt^.meetpuntID);
	end;
end;

procedure TstwseMain.GleisplanClick(Sender: TObject);
var
	Gleisplan: ^TvGleisplan;
	ep: byte;
	i: integer;
	Hokje: TvHokje;
	klikpunt: string;
	meetpunt: PvMeetpunt;
	wissel: PvWissel;
	rechtdoor: boolean;
	rijweg: PvRijweg;
	richting: byte;
begin
	modified := true;
	Gleisplan := @Sender;
	if (p_mode <= 49) then begin
		// TEKENEN
		case p_mode of
		0: begin	// Wis hokje
				Gleisplan^.Empty(gselx,gsely);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		1: begin	// Plaats simpel spoor met treindetectie
				if not elCheck.Checked then
					ep := 1
				else
					ep := 0;
				Gleisplan^.PutSpoor(gselx,gsely,p_gix,p_giy+ep,selMeetpunt);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		11: begin	// Plaats simpel spoor zonder treindetectie
				if not elCheck.Checked then
					ep := 1
				else
					ep := 0;
				Gleisplan^.PutSpoor(gselx,gsely,p_gix,p_giy+ep,nil);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		31: begin	// Plaats spoor met seindriehoekje
				if not assigned(selSein) then begin
					Application.MessageBox('Er is geen sein geselecteerd.','Foutmelding',MB_ICONEXCLAMATION);
					exit;
				end;
				if not elCheck.Checked then
					ep := 1
				else
					ep := 0;
				Gleisplan^.PutSpoor(gselx,gsely,p_gix,p_giy+ep,selMeetpunt);
				Gleisplan^.PutSeinDriehoekje(gselx, gsely, selSein);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		3: begin		// Plaats simpel sein
				Gleisplan^.PutSein(gselx,gsely,p_gix,p_giy, selSein);
				Gleisplan^.PutSein(gselx+1,gsely,p_gix+1,p_giy, selSein);
				Gleisplan^.PaintHokje(gselx, gsely);
				Gleisplan^.PaintHokje(gselx+1, gsely);
			end;
		4: begin		// Plaats decoratie, 1 hokje
				Gleisplan^.PutLandschap(gselx,gsely,p_gix,p_giy);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		41: begin	// Plaats decoratie, 2 hokjes
				Gleisplan^.PutLandschap(gselx,gsely,p_gix,p_giy);
				Gleisplan^.PutLandschap(gselx+1,gsely,p_gix+1,p_giy);
				Gleisplan^.PaintHokje(gselx, gsely);
				Gleisplan^.PaintHokje(gselx+1, gsely);
			end;
		42: begin	// Plaats tekst
				if txSpoornummer.Checked then
					Gleisplan^.PutText(gselx, gsely, txTxt.text, txKleur.ItemIndex, txTxt.text,
						txSeinWisselNr.Checked)
				else
					Gleisplan^.PutText(gselx, gsely, txTxt.text, txKleur.ItemIndex, '',
						txSeinWisselNr.Checked);
				for i := 1 to length(txTxt.text) do
					Gleisplan^.PaintHokje(gselx+i-1,gsely);
			end;
		5: begin		// Plaats wissel
				if not assigned(selWissel) then begin
					Application.MessageBox('Er is geen wissel geselecteerd.','Foutmelding',MB_ICONEXCLAMATION);
					exit;
				end;
				if not elCheck.Checked then
					ep := 1
				else
					ep := 0;
				Gleisplan^.PutWissel(gselx,gsely,p_gix,p_giy+ep, selWissel^.Meetpunt, selWissel);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		6: begin		// Plaats rijrichting-driehoekje
				if not assigned(selErlaubnis) then begin
					Application.MessageBox('Er is geen rijrichtingsveld geselecteerd.','Foutmelding',MB_ICONEXCLAMATION);
					exit;
				end;
				richting := 0;
				if eUpBut.Checked then richting := 1;
				if eDownBut.Checked then richting := 2;
				Gleisplan^.PutErlaubnis(gselx,gsely,p_gix,p_giy, selErlaubnis, richting);
				Gleisplan^.PaintHokje(gselx, gsely);
			end;
		10: begin	// Plaats TNV-venster
				Gleisplan^.PutTreinnummer(gselx, gsely, selTnMeetpunt, lenEdit.Value);
				for i := 1 to lenEdit.Value do
					Gleisplan^.PaintHokje(gselx+i-1,gsely);
			end;
		end;
		// Nog eventjes eventuele troep weghalen.
		Rijweg := Core.vAlleRijwegen;
		while assigned(rijweg) do begin
			if (RijwegVerwijderInactiefHokje(RijwegLogica, visibleTab, gselx, gsely)
			or RijwegVerwijderKruisingHokje(Rijweg, visibleTab^.ID, gselx, gsely))
			and (Rijweg = selRijweg) then begin
				UpdateChg.Rijweg := true;
				UpdateControls;
			end;
			Rijweg := Rijweg^.Volgende;
		end;
	end;
	if (p_mode >= 50) and (p_mode <= 69) then begin
		if not assigned(selRijweg) then exit;
		case p_mode of
			// RIJWEGEN !!!
			51: begin	// Instellen van-spoor -> sein
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				klikpunt := MaakKlikpunt(hokje);
				if klikpunt <> '' then begin
					if assigned(selRijweg^.Sein) then begin
						selRijweg^.Sein^.Van := klikpunt;
						UpdateChg.Rijweg := true;
						UpdateChg.Rijwegen := true;
						UpdateControls;
					end else
						Application.Messagebox('De rijweg heeft nog geen sein.','Fout',MB_ICONERROR);
				end else
					Application.Messagebox('Dit is geen geldig klikpunt.','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			52: begin	// Instellen naar-spoor
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				klikpunt := MaakKlikpunt(hokje);
				if klikpunt <> '' then begin
					selRijweg^.Naar := klikpunt;
					UpdateChg.Rijweg := true;
					UpdateChg.Rijwegen := true;
					UpdateControls;
				end else
					Application.Messagebox('Dit is geen geldig klikpunt.','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			53: begin	// Instellen van-sein
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if Hokje.Soort = 3 then
					if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then begin
						selRijweg^.Sein := PvHokjeSein(Hokje.grdata)^.Sein;
						UpdateChg.Rijweg := true;
						UpdateControls;
					end else
						Application.Messagebox('Dit is geen goed sein.','Fout',MB_ICONERROR)
				else
					Application.Messagebox('Dit is helemaal geen sein!','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			55: begin	// Toevoegen / verwijderen van meetpunten en wissels
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				case Hokje.Soort of
					1: begin
						Meetpunt := PvHokjeSpoor(Hokje.grdata)^.Meetpunt;
						if assigned(Meetpunt) then begin
							if not assigned(Meetpunt.RijwegOnderdeel) then begin
								RijwegVoegMeetpuntToe(selRijweg, Meetpunt);
								UpdateChg.Rijweg := true;
								UpdateChg.Rijwegen := true;
								UpdateControls;
							end else begin
								RijwegVerwijderMeetpunt(selRijweg, Meetpunt);
								UpdateChg.Rijweg := true;
								UpdateChg.Rijwegen := true;
								UpdateControls;
							end;
						end else
							Application.Messagebox('Dit spoor heeft geen detectiepunt.','Fout',MB_ICONERROR);
					end;
					5: begin
						Wissel := PvHokjeWissel(Hokje.grdata)^.Wissel;
						if not assigned(Wissel.RijwegOnderdeel) then begin
							case RijwegWisselstandVereist(selRijweg, Wissel) of
							0: rechtdoor := Application.MessageBox('Moet deze wissel voor deze rijweg in de rechte stand staan?', 'Wissel', MB_ICONQUESTION+MB_YESNO) = IDYES;
							1: rechtdoor := true;
							2: rechtdoor := false;
							else
								exit;
							end;
							RijwegVoegWisselToe(selRijweg, Wissel, rechtdoor);
							UpdateChg.Rijweg := true;
							UpdateChg.Rijwegen := true;
							UpdateControls;
						end else begin
							RijwegVerwijderWissel(selRijweg, Wissel);
							UpdateChg.Rijweg := true;
							UpdateChg.Rijwegen := true;
							UpdateControls;
						end;
					end;
				end;
			end;
			56: begin	// Instellen van inactieve hokjes
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				case Hokje.Soort of
					1: begin
						if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.RijwegOnderdeel) then begin
							if not PvHokjeSpoor(Hokje.grdata)^.InactiefWegensRijweg then
								RijwegVoegInactiefHokjeToe(RijwegLogica, visibleTab, gselx, gsely)
							else
								RijwegVerwijderInactiefHokje(RijwegLogica, visibleTab, gselx, gsely);
							UpdateChg.Rijweg := true;
							UpdateChg.Rijwegen := true;
							UpdateControls;
						end else
							Application.Messagebox('Deze bloksectie hoort niet bij de rijweg.','Fout',MB_ICONERROR);
					end;
					5: begin
						if assigned(PvHokjeWissel(Hokje.grdata)^.Meetpunt^.RijwegOnderdeel) then begin
							if not PvHokjeWissel(Hokje.grdata)^.InactiefWegensRijweg then
								RijwegVoegInactiefHokjeToe(RijwegLogica, visibleTab, gselx, gsely)
							else
								RijwegVerwijderInactiefHokje(RijwegLogica, visibleTab, gselx, gsely);
							UpdateChg.Rijweg := true;
							UpdateChg.Rijwegen := true;
							UpdateControls;
						end else
							Application.Messagebox('Deze bloksectie hoort niet bij de rijweg.','Fout',MB_ICONERROR);
					end;
					else
						Application.Messagebox('Dit kan niet.','Fout',MB_ICONERROR);
				end;
			end;
			57: begin	// Instellen van kruisinghokjes
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if Hokje.Soort = 1 then begin
					if assigned(PvHokjeSpoor(Hokje.grdata)^.Meetpunt^.RijwegOnderdeel) and
						(PvHokjeSpoor(Hokje.grdata)^.grx >= 6) and
						(PvHokjeSpoor(Hokje.grdata)^.grx <= 13) and
						(PvHokjeSpoor(Hokje.grdata)^.gry <= 1) then begin
						case PvHokjeSpoor(Hokje.grdata)^.RechtsonderKruisRijweg of
						0:
							RijwegVoegKruisingHokjeToe(selRijweg, visibleTab^.ID, gselx, gsely, PvHokjeSpoor(Hokje.grdata)^.Meetpunt, true);
						1:
							RijwegVoegKruisingHokjeToe(selRijweg, visibleTab^.ID, gselx, gsely, PvHokjeSpoor(Hokje.grdata)^.Meetpunt, false);
						2:
							RijwegVerwijderKruisingHokje(selRijweg, visibleTab^.ID, gselx, gsely);
						end;
						UpdateChg.Rijweg := true;
						UpdateChg.Rijwegen := true;
						UpdateControls;
					end else
						Application.Messagebox('Deze bloksectie hoort niet bij de rijweg.','Fout',MB_ICONERROR);
				end else begin
					Application.Messagebox('Dit kan niet.','Fout',MB_ICONERROR);
				end;
			end;
			58: begin	// Toevoegen / verwijderen van approach locking secties
				if assigned(selRijweg^.Sein) then begin
					Hokje := Gleisplan^.GetHokje(gselx, gsely);
					if Hokje.Soort = 1 then begin
						Meetpunt := PvHokjeSpoor(Hokje.grdata)^.Meetpunt;
						if assigned(Meetpunt) then begin
							if not SeinZoekHerroepMeetpunt(selRijweg^.Sein, Meetpunt) then begin
								SeinVoegHerroepMeetpuntToe(selRijweg^.Sein, Meetpunt);
								UpdateChg.Rijweg := true;
								UpdateChg.Rijwegen := true;
								UpdateControls;
							end else begin
								SeinVerwijderHerroepMeetpunt(selRijweg^.Sein, Meetpunt);
								UpdateChg.Rijweg := true;
								UpdateChg.Rijwegen := true;
								UpdateControls;
							end;
						end else
							Application.Messagebox('Dit spoor heeft geen detectiepunt.','Fout',MB_ICONERROR);
					end else
						Application.Messagebox('Dit kan niet.','Fout',MB_ICONERROR);
				end else
					Application.Messagebox('De rijweg heeft nog geen sein!','Fout',MB_ICONERROR);
			end;
			59: begin	// Instellen van de rijrichting
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if Hokje.Soort = 6 then
					if assigned(PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis) then begin
						selRijweg^.Erlaubnis := PvHokjeErlaubnis(Hokje.grdata)^.Erlaubnis;
						selRijweg^.Erlaubnisstand := PvHokjeErlaubnis(Hokje.grdata)^.ActiefStand;
						UpdateChg.Rijweg := true;
						UpdateControls;
					end else
						Application.Messagebox('Dit is geen goed rijwegveld.','Fout',MB_ICONERROR)
				else
					Application.Messagebox('Dit is helemaal geen rijwegveld!','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			60: begin	// Instellen van-TNV-venster -> sein
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if assigned(Hokje.Dyndata) then begin
					if assigned(selRijweg^.Sein) then begin
						selRijweg^.Sein^.VanTNVMeetpunt := Hokje.Dyndata^.Meetpunt;
						UpdateChg.Rijweg := true;
						UpdateControls;
					end else
						Application.Messagebox('De rijweg heeft nog geen sein.','Fout',MB_ICONERROR);
				end else
					Application.Messagebox('Hier staat geen treinnummer.','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			61: begin	// Instellen naar-TNV-venster
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if assigned(Hokje.Dyndata) then begin
					selRijweg^.NaarTNVMeetpunt := Hokje.Dyndata^.Meetpunt;
					UpdateChg.Rijweg := true;
					UpdateControls;
				end else
					Application.Messagebox('Hier staat geen treinnummer.','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			62: begin	// Instellen naar-sein
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if Hokje.Soort = 3 then
					if assigned(PvHokjeSein(Hokje.grdata)^.Sein) then begin
						selRijweg^.NaarSein := PvHokjeSein(Hokje.grdata)^.Sein;
						UpdateChg.Rijweg := true;
						UpdateControls;
					end else
						Application.Messagebox('Dit is geen goed sein.','Fout',MB_ICONERROR)
				else
					Application.Messagebox('Dit is helemaal geen sein!','Fout',MB_ICONERROR);
				rijwegNiks.Down := true;
				p_mode := -1;
			end;
			63: begin	// Instellen ARI-triggerpunt -> sein
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				if Hokje.Soort = 1 then begin
					Meetpunt := PvHokjeSpoor(Hokje.grdata)^.Meetpunt;
					if assigned(Meetpunt) then begin
						if assigned(selRijweg^.Sein) then begin
							selRijweg^.Sein^.TriggerMeetpunt := Meetpunt;
							RijwegNiks.Down := true;
							p_mode := -1;
							UpdateChg.Rijweg := true;
							UpdateControls;
						end else
							Application.Messagebox('De rijweg heeft nog geen sein.','Fout',MB_ICONERROR);
					end else
						Application.Messagebox('Dit spoor heeft geen detectiepunt.','Fout',MB_ICONERROR);
				end else
					Application.Messagebox('Dit kan niet.','Fout',MB_ICONERROR);
			end;
		end;
	end;
	if (p_mode > 70) then begin
		if not assigned(selPrlRijweg) then exit;
		case p_mode of
			71: begin
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				klikVan := MaakKlikpunt(hokje);
				if klikVan <> '' then begin
					prlrtStatus.Caption := 'Klik op het einde van de rijweg...';
					p_mode := 72;
				end else
					Application.Messagebox('Dit is geen geldig klikpunt.','Fout',MB_ICONERROR);
			end;
			72: begin
				Hokje := Gleisplan^.GetHokje(gselx, gsely);
				klikpunt := MaakKlikpunt(hokje);
				if klikpunt <> '' then begin
					Rijweg := ZoekRijweg(@Core, klikVan, klikPunt);
					if assigned(Rijweg) then begin
						if not assigned(selPrlRijweg^.Rijwegen) then
							selPrlRijweg^.Van := klikVan;
						selPrlRijweg^.Naar := klikPunt;
						PrlRijwegVoegRijwegToe(selPrlRijweg, rijweg);
						PrlRijwegNiks.Down := true;
						p_mode := -1;
						UpdateChg.PrlRijwegen := true;
						UpdateChg.PrlRijweg := true;
						UpdateControls;
					end else begin
						prlrtStatus.Caption := 'Deze rijweg bestaat niet.';
						PrlRijwegNiks.Down := true;
						p_mode := -1;
					end;
				end else
					Application.Messagebox('Dit is geen geldig klikpunt.','Fout',MB_ICONERROR);
			end;
		end;
	end;
end;

procedure TstwseMain.mElBoxChange(Sender: TObject);
var
	i: integer;
begin
	if mElBox.ItemIndex = 0 then
		selMeetpunt := nil
	else begin
		selMeetpunt := Core.vAlleMeetpunten;
		for i := 1 to mElBox.ItemIndex-1 do
			selMeetpunt := selMeetpunt.volgende;
	end;
end;

procedure TstwseMain.wElBoxChange(Sender: TObject);
var
	i: integer;
begin
	selWissel := EersteWissel(@Core);
	for i := 1 to wElBox.ItemIndex do
		selWissel := VolgendeWissel(selWissel);
end;

procedure TstwseMain.sElBoxChange(Sender: TObject);
var
	i: integer;
begin
	if sElBox.ItemIndex = 0 then
		selSein := nil
	else begin
		selSein := Core.vAlleSeinen;
		for i := 1 to sElBox.ItemIndex-1 do
			selSein := selSein.volgende;
	end;
end;

procedure TstwseMain.mTnBoxChange(Sender: TObject);
var
	i: integer;
begin
	selTnMeetpunt := Core.vAlleMeetpunten;
	for i := 1 to mTnBox.ItemIndex do
		selTnMeetpunt := selTnMeetpunt.volgende;
end;

procedure TstwseMain.SpeedButton11Click(Sender: TObject);
begin
  	p_mode := 0;
end;

procedure TstwseMain.SpeedButton12Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 1;
	p_giy := 4;
end;


procedure TstwseMain.SpeedButton1Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 0;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton2Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 2;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton3Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 3;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton4Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 4;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton5Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 5;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton6Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 6;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton7Click(Sender: TObject);
begin
	p_mode := 5;
	p_gix := 11;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton8Click(Sender: TObject);
begin
	p_mode := 5;
	p_gix := 12;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton9Click(Sender: TObject);
begin
	p_mode := 5;
	p_gix := 13;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton10Click(Sender: TObject);
begin
	p_mode := 5;
	p_gix := 14;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton16Click(Sender: TObject);
begin
	p_mode := 3;
	p_gix := 0;
	p_giy := 5;
end;

procedure TstwseMain.SpeedButton15Click(Sender: TObject);
begin
	p_mode := 3;
	p_gix := 8;
	p_giy := 5;
end;

procedure TstwseMain.SpeedButton17Click(Sender: TObject);
begin
	p_mode := 42;
end;

procedure TstwseMain.SpeedButton18Click(Sender: TObject);
begin
	p_mode := 10;
end;

procedure TstwseMain.SpeedButton26Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 11;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton27Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 12;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton28Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 13;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton29Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 14;
	p_giy := 0;
end;

procedure TstwseMain.rijwegVanWijzigClick(Sender: TObject);
begin
	p_mode := 51;
end;

procedure TstwseMain.rijwegNaarWijzigClick(Sender: TObject);
begin
	p_mode := 52;
end;

procedure TstwseMain.seinWijzigKlikClick(Sender: TObject);
begin
	p_mode := 53;
end;

procedure TstwseMain.SpeedButton23Click(Sender: TObject);
begin
	p_mode := 55;
end;

procedure TstwseMain.SpeedButton24Click(Sender: TObject);
begin
	p_mode := 56;
end;

procedure TstwseMain.SpeedButton25Click(Sender: TObject);
begin
	p_mode := 57;
end;

procedure TstwseMain.TreinnrWeergevenExecute(Sender: TObject);
begin
	TreinnrWeergeven.Checked := not TreinnrWeergeven.Checked;
	FTreinnrWeergeven := TreinnrWeergeven.Checked;
	UpdateChg.Schermen := true;
   UpdateControls;
end;

procedure TstwseMain.SpeedButton22Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 7;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton21Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 8;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton20Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 9;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton19Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 10;
	p_giy := 0;
end;

procedure TstwseMain.OpslaanAlsExecute(Sender: TObject);
begin
	if SaveDialog.Execute then begin
		filename := SaveDialog.Filename;
		OpslaanExecute(Sender);
	end;
end;

procedure TstwseMain.OpenenExecute(Sender: TObject);
var
	f: file;
	magic, schermnaam: string;
	schermID: integer;
	details: boolean;
begin
	if OpenDialog.Execute then begin
		filename := OpenDialog.Filename;
		assignfile(f, filename);
		reset(f, 1);
		stringread(f, magic);
		if magic <> magicCode then begin
			Application.MessageBox('Dit is geen geldig bestand.', 'Fout', MB_ICONERROR);
			exit;
		end;

		LoadInfra(f, Infrastructuur);

		LoadThings(@Core, f);

		repeat
			intread(f, schermID);
			if schermID > 0 then begin
				stringread(f, schermnaam);
				boolread(f, details);
				AddScherm(schermID, Schermnaam, flLast, details);
				GetScherm(schermID).Gleisplan.LoadPlan(f);
			end;
		until schermID = 0;
	end;

	UpdateChg.Infra := true;
	UpdateChg.Meetpunten := true;
	UpdateChg.Erlaubnisse := true;
	UpdateChg.Seinen := true;
	UpdateChg.Wissels := true;
	UpdateChg.Overweg := true;
	UpdateChg.Overwegen := true;
	UpdateChg.Schermaantal := true;
	UpdateChg.Schermen := true;
	UpdateChg.Rijwegen := true;
	UpdateChg.Rijweg := true;
	UpdateChg.PrlRijwegen := true;
	UpdateChg.PrlRijweg := true;
	UpdateControls;

	modified := false;
	Openen.Enabled := false;
end;

procedure TstwseMain.exitActExecute(Sender: TObject);
begin
	if modified then begin
		if Application.MessageBox('Misschien niet opgeslagen. Toch beëindigen?', 'Afsluiten', MB_ICONWARNING+MB_YESNO) = IDYES then
			halt
	end else
		halt;
end;

procedure TstwseMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	exitAct.Execute;
	canclose := false;
end;

procedure TstwseMain.rtButClick(Sender: TObject);
begin
	NieuweRijweg(@Core);
	
	selRijweg := nil;
	UpdateChg.Rijweg := true;
	UpdateChg.Rijwegen := true;
	UpdateControls;
end;

procedure TstwseMain.rdButClick(Sender: TObject);
var
	i, j: integer;
	Rijweg, vRijweg: PvRijweg;
begin
	for i := rList.Items.Count-1 downto 0 do
		if rList.Selected[i] then begin
			// Geselecteerde rijweg zoeken!
			vRijweg := nil;
			Rijweg := Core.vAlleRijwegen;
			for j := 1 to i do begin
				vRijweg := Rijweg;
				Rijweg := Rijweg^.Volgende;
			end;
			if assigned(vRijweg) then
				vRijweg.Volgende := Rijweg.Volgende
			else
				Core.vAlleRijwegen := Rijweg.Volgende;
			// Rijweg netjes verwijderen
			disposeRijweg(Rijweg);
	end;

	selRijweg := nil;
	UpdateChg.Rijwegen := true;
	UpdateChg.Rijweg := true;
	UpdateControls;
end;

procedure TstwseMain.editPCChange(Sender: TObject);
begin
	drawNiks.Down := true;
	rijwegNiks.Down := true;
	PrlRijwegNiks.Down := true;
	prlrtStatus.Caption := 'Gereed.';
	if assigned(selRijweg) then begin
		selRijweg := nil;
		UpdateChg.Rijweg := true;
		UpdateControls;
	end;
	p_mode := -1;
end;

procedure TstwseMain.drawNiksClick(Sender: TObject);
begin
	p_mode := -1;
end;

procedure TstwseMain.rListClick(Sender: TObject);
var
	i, j: integer;
begin
	selRijweg := nil;
	for i := rList.Items.Count-1 downto 0 do
		if rList.Selected[i] then begin
			selRijweg := Core.vAlleRijwegen;
			for j := 1 to i do begin
				selRijweg := selRijweg^.Volgende;
			end;
		end;

	UpdateChg.Rijweg := true;
	UpdateControls;
end;

procedure TstwseMain.SpeedButton31Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 9;
	p_giy := 4;
end;

procedure TstwseMain.SpeedButton34Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 12;
	p_giy := 4;
end;

procedure TstwseMain.SpeedButton36Click(Sender: TObject);
begin
	p_mode := 11;
	p_gix := 15;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton37Click(Sender: TObject);
begin
	p_mode := 58;
end;

procedure TstwseMain.etButClick(Sender: TObject);
var
	Erlaubnis:	PvErlaubnis;
	found:		boolean;
	nID:			string;
begin
	nID := eEdit.Text;
	if nID = '' then begin
		Application.MessageBox('Er is geen rijrichtingsveld ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	found := false;
	Erlaubnis := Core.vAlleErlaubnisse;
	while assigned(Erlaubnis) do begin
		if Erlaubnis.erlaubnisID = nID then found := true;
		Erlaubnis := Erlaubnis.Volgende;
	end;
	if found then begin
		Application.MessageBox('Dit rijrichtingsveld is al ingevoerd.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	AddErlaubnis(@Core, nID);
	eEdit.Text := '';
	UpdateChg.Erlaubnisse := true;
	UpdateControls;
end;

procedure TstwseMain.edButClick(Sender: TObject);
var
	tmpErlaubnis:	PvErlaubnis;
	vErlaubnis:		PvErlaubnis;
	Erlaubnis:		PvErlaubnis;
	eID:		string;
	i: integer;
begin
	for i := 0 to eList.Items.Count-1 do
		if eList.Selected[i] then begin
			eID := eList.Items[i];
			vErlaubnis := nil;
			Erlaubnis := Core.vAlleErlaubnisse;
			while assigned(Erlaubnis) do begin
				if Erlaubnis^.erlaubnisID = eID then begin
					if assigned(vErlaubnis) then
						vErlaubnis.Volgende := Erlaubnis.Volgende
					else
						Core.vAlleErlaubnisse := Erlaubnis.Volgende;
					tmpErlaubnis := Erlaubnis;
					Erlaubnis := Erlaubnis.Volgende;
					dispose(tmpErlaubnis);
				end else begin
					vErlaubnis := Erlaubnis;
					Erlaubnis := Erlaubnis.Volgende;
				end;
			end;
	end;
	UpdateChg.Erlaubnisse := true;
	UpdateControls;
end;

procedure TstwseMain.eElBoxChange(Sender: TObject);
var
	i: integer;
begin
	selErlaubnis := Core.vAlleErlaubnisse;
	for i := 1 to eElBox.ItemIndex do
		selErlaubnis := selErlaubnis.volgende;
end;

procedure TstwseMain.SpeedButton38Click(Sender: TObject);
begin
	p_mode := 6;
	p_gix := 18;
	p_giy := 4;
end;

procedure TstwseMain.SpeedButton39Click(Sender: TObject);
begin
	p_mode := 6;
	p_gix := 19;
	p_giy := 4;
end;

procedure TstwseMain.richtingWijzigButClick(Sender: TObject);
begin
	p_mode := 59;
end;

procedure TstwseMain.richtingWisButClick(Sender: TObject);
begin
	if assigned(selRijweg) then begin
		selRijweg^.Erlaubnis := nil;
		selRijweg^.Erlaubnisstand := 0;
		UpdateChg.Rijweg := true;
		UpdateControls;
	end;
end;

procedure TstwseMain.wnEditChange(Sender: TObject);
begin
	wgBox.Items[0] := wnEdit.Text;
	wgBox.Text := wnEdit.Text;
end;

procedure TstwseMain.SpeedButton40Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 2;
	p_giy := 4;
end;

procedure TstwseMain.SpeedButton41Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 3;
	p_giy := 4;
end;

procedure TstwseMain.SpeedButton13Click(Sender: TObject);
begin
	p_mode := 1;
	p_gix := 1;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton14Click(Sender: TObject);
begin
	p_mode := 4;
	p_gix := 14;
	p_giy := 4;
end;

procedure TstwseMain.prlrtButClick(Sender: TObject);
begin
	NieuwePrlRijweg(@Core);

	selPrlRijweg := nil;
	UpdateChg.PrlRijweg := true;
	UpdateChg.PrlRijwegen := true;
	UpdateControls;
end;

procedure TstwseMain.prlRlistClick(Sender: TObject);
var
	i, j: integer;
begin
	selPrlRijweg := nil;
	for i := prlrList.Items.Count-1 downto 0 do
		if prlrList.Selected[i] then begin
			selPrlRijweg := Core.vAllePrlRijwegen;
			for j := 1 to i do begin
				selPrlRijweg := selPrlRijweg^.Volgende;
			end;
		end;

	UpdateChg.PrlRijweg := true;
	UpdateControls;
end;

procedure TstwseMain.prlrdButClick(Sender: TObject);
var
	i, j: integer;
	PrlRijweg, vPrlRijweg: PvPrlRijweg;
begin
	for i := PrlrList.Items.Count-1 downto 0 do
		if PrlrList.Selected[i] then begin
			// Geselecteerde rijweg zoeken!
			vPrlRijweg := nil;
			PrlRijweg := Core.vAllePrlRijwegen;
			for j := 1 to i do begin
				vPrlRijweg := PrlRijweg;
				PrlRijweg := PrlRijweg^.Volgende;
			end;
			if assigned(vPrlRijweg) then
				vPrlRijweg.Volgende := PrlRijweg.Volgende
			else
				Core.vAllePrlRijwegen := PrlRijweg.Volgende;
			// Rijweg netjes verwijderen
			disposePrlRijweg(PrlRijweg);
	end;

	selPrlRijweg := nil;
	UpdateChg.PrlRijwegen := true;
	UpdateChg.PrlRijweg := true;
	UpdateControls;
end;

procedure TstwseMain.DwangEditChange(Sender: TObject);
var
	x, code: integer;
begin
	if DwangEdit.Text = '' then exit;
	val(DwangEdit.Text, x, code);
	if (code <> 0) or (x < 0) or (x > 10) then
		if assigned(selPrlRijweg) then begin
			DwangEdit.Text := inttostr(SelPrlRijweg^.Dwang);
			exit;
		end else
			DwangEdit.Text := '0';
	if assigned(selprlRijweg) then
		SelPrlRijweg^.Dwang := x;
end;

procedure TstwseMain.RmPrlSpoorButClick(Sender: TObject);
var
	RijwegL, vRijwegL: PvRijwegLijst;
begin
	if assigned(selPrlRijweg) then begin
		RijwegL := selPrlRijweg^.Rijwegen;
		if not assigned(RijwegL.Volgende) then begin
			selPrlRijweg^.Rijwegen := nil;
			selPrlRijweg^.Van := '';
			selPrlRijweg^.Naar := '';
			dispose(RijwegL);
		end else begin
			vRijwegL := nil;
			while assigned(RijwegL.Volgende) do begin
				vRijwegL := RijwegL;
				RijwegL := RijwegL^.Volgende;
			end;
			vRijwegL.Volgende := nil;
			dispose(RijwegL);
			selPrlRijweg^.Naar := vRijwegL^.Rijweg^.Naar;
		end;
		UpdateChg.PrlRijwegen := true;
		UpdateChg.PrlRijweg := true;
		UpdateControls;
	end;
end;

procedure TstwseMain.AddPrlSpoorButClick(Sender: TObject);
var
	RijwegLijst: PvRijwegLijst;
begin
	if not assigned(selPrlRijweg) then exit;
	if not assigned(selPrlRijweg^.Rijwegen) then begin
		prlrtStatus.Caption := 'Klik op het begin van de rijweg...';
		p_mode := 71;
	end else begin
		RijwegLijst := selPrlRijweg^.Rijwegen;
		while assigned(RijwegLijst^.Volgende) do
			RijwegLijst := RijwegLijst^.Volgende;
		klikVan := RijwegLijst^.Rijweg^.Naar;
		p_mode := 72;
		prlrtStatus.Caption := 'Klik op het einde van de rijweg...';
	end;
end;

procedure TstwseMain.triggerDelButClick(Sender: TObject);
begin
	if assigned(selRijweg) then begin
		if assigned(selRijweg^.Sein) then begin
			selRijweg^.Sein^.TriggerMeetpunt := nil;
			UpdateChg.Rijweg := true;
			UpdateControls;
		end;
	end;
end;

procedure TstwseMain.triggerChgButClick(Sender: TObject);
begin
	p_mode := 63;
end;

procedure TstwseMain.prlRijwegNiksClick(Sender: TObject);
begin
	prlrtStatus.Caption := 'Gereed.';
	p_mode := -1;
end;

procedure TstwseMain.rtpCopyButClick(Sender: TObject);
var
	Rijweg: PvRijweg;
	prlRijweg: PvPrlRijweg;
begin
	Rijweg := Core.vAlleRijwegen;
	while assigned(Rijweg) do begin
		prlRijweg := ZoekPrlRijweg(@Core, Rijweg^.Sein^.Van, Rijweg^.Naar, 0);
		if not assigned(prlRijweg) then begin
			prlRijweg := NieuwePrlRijweg(@Core);
			prlRijweg^.Van := Rijweg^.Sein^.Van;
			prlRijweg^.Naar := Rijweg^.Naar;
			prlRijweg^.Dwang := 0;
			PrlRijwegVoegRijwegToe(prlRijweg, Rijweg);
		end;
		Rijweg := Rijweg^.Volgende;
	end;
	UpdateChg.PrlRijwegen := true;
	UpdateControls;
end;

procedure TstwseMain.ovtbutClick(Sender: TObject);
var
	Overweg:		PvOverweg;
	found:		boolean;
	nID:			string;
begin
	nID := ovEdit.Text;
	if nID = '' then begin
		Application.MessageBox('Er is geen overweg ingevuld.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	found := false;
	Overweg := Core.vAlleOverwegen;
	while assigned(Overweg) do begin
		if Overweg.Naam = nID then found := true;
		Overweg := Overweg^.Volgende;
	end;
	if found then begin
		Application.MessageBox('Deze overweg is al ingevoerd.','Foutmelding',MB_ICONEXCLAMATION);
		exit;
	end;
	AddOverweg(@Core, nID);
	ovEdit.Text := '';
	UpdateChg.Overwegen := true;
	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.ovdbutClick(Sender: TObject);
var
	Overweg:	PvOverweg;
	i,j: 		integer;
begin
	for i := ovList.Items.Count-1 downto 0 do
		if ovList.Selected[i] then begin
			Overweg := Core.vAlleOverwegen;
			for j := 1 to i do
				Overweg := Overweg^.Volgende;
			if assigned(Overweg) then
				DeleteOverweg(@Core, Overweg^.Naam);
		end;

	UpdateChg.Overwegen := true;
	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.ovListClick(Sender: TObject);
var
	i: integer;
begin
	if ovList.ItemIndex = -1 then
		selOverweg := nil
	else begin
		selOverweg := Core.vAlleOverwegen;
		for i := 1 to ovList.ItemIndex do
			selOverweg := selOverweg.volgende;
	end;
	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.movtbutClick(Sender: TObject);
var
	nID: string;
	MeetpuntL: PvMeetpuntLijst;
begin
	if not assigned(selOverweg) then exit;
	if mOvBox.ItemIndex = -1 then exit;
	nID := mOvBox.Items[mOvBox.ItemIndex];

	MeetpuntL := selOverweg^.Meetpunten;
	while assigned(MeetpuntL) do begin
		if MeetpuntL^.Meetpunt^.meetpuntID = nID then begin
			Application.MessageBox('Dit meetpunt hoort al bij deze overweg.','Foutmelding',MB_ICONEXCLAMATION);
			exit;
		end;
		MeetpuntL := MeetpuntL^.Volgende;
	end;

	new(MeetpuntL);
	MeetpuntL^.Meetpunt := ZoekMeetpunt(@Core, nID);
	MeetpuntL^.Volgende := selOverweg^.Meetpunten;
	selOverweg^.Meetpunten := MeetpuntL;

	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.movdbutClick(Sender: TObject);
var
	i: integer;
	MeetpuntL, vMeetpuntL: PvMeetpuntLijst;
begin
	if ovmList.ItemIndex = -1 then exit;
	if not assigned(selOverweg) then exit;

	MeetpuntL := selOverweg^.Meetpunten;
	vMeetpuntL := nil;
	for i := 1 to ovmList.ItemIndex do begin
		vMeetpuntL := MeetpuntL;
		MeetpuntL := MeetpuntL^.Volgende;
	end;
	if assigned(vMeetpuntL) then
		vMeetpuntL^.Volgende := MeetpuntL^.Volgende
	else
		selOverweg^.Meetpunten := MeetpuntL^.Volgende;
	dispose(MeetpuntL);
	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.ovmaTButClick(Sender: TObject);
var
	nID: string;
	MeetpuntL: PvMeetpuntLijst;
begin
	if not assigned(selOverweg) then exit;
	if mOvBox.ItemIndex = -1 then exit;
	nID := mOvBox.Items[mOvBox.ItemIndex];

	MeetpuntL := selOverweg^.AankMeetpunten;
	while assigned(MeetpuntL) do begin
		if MeetpuntL^.Meetpunt^.meetpuntID = nID then begin
			Application.MessageBox('Dit meetpunt hoort al bij de aankondiging van deze overweg.','Foutmelding',MB_ICONEXCLAMATION);
			exit;
		end;
		MeetpuntL := MeetpuntL^.Volgende;
	end;

	new(MeetpuntL);
	MeetpuntL^.Meetpunt := ZoekMeetpunt(@Core, nID);
	MeetpuntL^.Volgende := selOverweg^.AankMeetpunten;
	selOverweg^.AankMeetpunten := MeetpuntL;

	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.ovmaDButClick(Sender: TObject);
var
	i: integer;
	MeetpuntL, vMeetpuntL: PvMeetpuntLijst;
begin
	if ovmaList.ItemIndex = -1 then exit;
	if not assigned(selOverweg) then exit;

	MeetpuntL := selOverweg^.AankMeetpunten;
	vMeetpuntL := nil;
	for i := 1 to ovmaList.ItemIndex do begin
		vMeetpuntL := MeetpuntL;
		MeetpuntL := MeetpuntL^.Volgende;
	end;
	if assigned(vMeetpuntL) then
		vMeetpuntL^.Volgende := MeetpuntL^.Volgende
	else
		selOverweg^.AankMeetpunten := MeetpuntL^.Volgende;
	dispose(MeetpuntL);
	UpdateChg.Overweg := true;
	UpdateControls;
end;

procedure TstwseMain.SpeedButton43Click(Sender: TObject);
begin
	p_mode := 31;
	p_gix := 16;
	p_giy := 0;
end;

procedure TstwseMain.SpeedButton42Click(Sender: TObject);
begin
	p_mode := 31;
	p_gix := 17;
	p_giy := 0;
end;

procedure TstwseMain.detailsOnClick(Sender: TObject);
begin
	VisibleTab^.Details := detailsOn.Checked;
end;

procedure TstwseMain.detailsOffClick(Sender: TObject);
begin
	VisibleTab^.Details := detailsOn.Checked;
end;

procedure TstwseMain.tnvvanwisClick(Sender: TObject);
begin
	if assigned(selRijweg) then begin
		if assigned(selRijweg^.Sein) then begin
			selRijweg^.Sein^.VanTNVMeetpunt := nil;
			UpdateChg.Rijweg := true;
			UpdateControls;
		end;
	end;
end;

procedure TstwseMain.tnvnaarwisClick(Sender: TObject);
begin
	if assigned(selRijweg) then begin
		selRijweg^.NaarTNVMeetpunt := nil;
		UpdateChg.Rijweg := true;
		UpdateControls;
	end;
end;

procedure TstwseMain.tnvvanwijzigClick(Sender: TObject);
begin
	p_mode := 60;
end;

procedure TstwseMain.tnvnaarwijzigClick(Sender: TObject);
begin
	p_mode := 61;
end;

procedure TstwseMain.naarSeinWijzigButClick(Sender: TObject);
begin
	p_mode := 62;
end;

procedure TstwseMain.naarseinWisButClick(Sender: TObject);
begin
	if assigned(selRijweg) then begin
		selRijweg^.NaarSein := nil;
		UpdateChg.Rijweg := true;
		UpdateControls;
	end;
end;

procedure TstwseMain.onbevCheckClick(Sender: TObject);
begin
	if assigned(selRijweg) then
		selRijweg^.NaarOnbeveiligd := onbevCheck.Checked;
end;

procedure TstwseMain.InfraOpenButClick(Sender: TObject);
var
	f: textfile;
	s: string;
begin
	if not InfraOpenDialog.Execute then exit;
	assignfile(f, InfraOpenDialog.Filename);
	{$I-}reset(f);{$I+}
	if ioresult <> 0 then exit;
	Infrastructuur.Clear;
	while not eof(f) do begin
		readln(f, s);
		Infrastructuur.Add(s);
	end;
	closefile(f);
	UpdateChg.Infra := true;
	UpdateControls;
end;

procedure TstwseMain.SaveInfra;
var
	i: integer;
begin
	intwrite(f, Infra.Count);
	for i := 0 to Infra.Count-1 do
		stringwrite(f, Infra[i]);
end;

procedure TstwseMain.LoadInfra;
var
	i: integer;
	aantal: integer;
	s: string;
begin
	intread(f, aantal);
	Infra.Clear;
	for i := 1 to aantal do begin
		stringread(f, s);
		Infra.Add(s);
	end;
end;

procedure TstwseMain.OpslaanExecute(Sender: TObject);
var
	f: file;
	magic, schermnaam: shortstring;
	schermID: integer;
	details: boolean;
	Tab:			PTablist;
begin
	if filename = '' then begin
		OpslaanAlsExecute(Sender);
		exit;
	end;

	assignfile(f, filename);
	rewrite(f,1);

	magic := MagicCode;
	stringwrite(f, magic);

	SaveInfra(f, Infrastructuur);

	SaveThings(@Core, f);

	Tab := FirstTab;
	while assigned(Tab) do begin
		schermID := Tab^.ID;
		schermnaam := Tab^.Titel;
		details := Tab^.Details;
		intwrite(f, schermID);
		stringwrite(f, schermnaam);
		boolwrite(f, details);
		Tab^.Gleisplan.SavePlan(f);
		Tab := Tab.Volgende;
	end;
	schermID := 0;
	intwrite(f, schermID);
	closefile(f);

	Modified := false;
end;

procedure TstwseMain.RijwegSubroutesClick(Sender: TObject);
var
	i: integer;
	MeetpuntL: PvMeetpuntLijst;
	DoeKnipper: Boolean;
begin
	UpdateSubrouteUpDownCtls;
	if assigned(selRijweg) then begin
		MeetpuntL := selRijweg^.Meetpunten;
		for i := 0 to RijwegSubroutes.Items.Count-1 do begin
			DoeKnipper := i = RijwegSubroutes.ItemIndex;
			if MeetpuntL^.Meetpunt^.Knipperen <> DoeKnipper then begin
				MeetpuntL^.Meetpunt^.Knipperen := DoeKnipper;
				VisibleTab^.Gleisplan.PaintMeetpunt(MeetpuntL^.Meetpunt);
			end;
			MeetpuntL := MeetpuntL^.Volgende;
		end;
	end;
end;

procedure TstwseMain.SubrouteUpClick(Sender: TObject);
begin
	SwapSubroutes(RijwegSubroutes.ItemIndex-1,RijwegSubroutes.ItemIndex);
	RijwegSubroutes.ItemIndex := RijwegSubroutes.ItemIndex - 1;
	UpdateSubrouteUpDownCtls;
end;

procedure TstwseMain.SubrouteDownClick(Sender: TObject);
begin
	SwapSubroutes(RijwegSubroutes.ItemIndex,RijwegSubroutes.ItemIndex+1);
	RijwegSubroutes.ItemIndex := RijwegSubroutes.ItemIndex + 1;
	UpdateSubrouteUpDownCtls;
end;

procedure TstwseMain.BlinkTimerTimer(Sender: TObject);
begin
	if assigned(VisibleTab) then
		VisibleTab^.Gleisplan.KnipperGedoofd := not VisibleTab^.Gleisplan.KnipperGedoofd;
end;

end.

