unit clientPlanregelEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, stwvCore, stwvRijwegen;

type
  TstwscPlanregelEditForm = class(TForm)
    treinnrEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
	 rozCheck: TCheckBox;
    vanEdit: TEdit;
    Label4: TLabel;
    naarEdit: TEdit;
    Label5: TLabel;
    Label3: TLabel;
    dwangBox: TComboBox;
    actBox: TComboBox;
    instelUurEdit: TEdit;
	 Label6: TLabel;
    instelMinEdit: TEdit;
    Label7: TLabel;
    nieuwNrEdit: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    RestNrEdit: TEdit;
    Button1: TButton;
    CancelBut: TButton;
    HCheck: TCheckBox;
    procedure vanEditChange(Sender: TObject);
    procedure naarEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
	private
	public
		Core: PvCore;
		procedure UpdateDwangen;
	end;

var
  stwscPlanregelEditForm: TstwscPlanregelEditForm;

implementation

{$R *.DFM}

procedure TstwscPlanregelEditForm.UpdateDwangen;
var
	van, naar:	string;
	dwang:		byte;
	PrlRijweg:	PvPrlRijweg;
	RijwegL:		PvRijwegLijst;
	s, spoor:	string;
begin
	van := vanEdit.Text;
	naar := naarEdit.Text;
	dwangBox.Items.Clear;
	for dwang := 0 to 10 do begin
		PrlRijweg := ZoekPrlRijweg(Core, Van, Naar, Dwang);
		if assigned(PrlRijweg) then begin
			s := inttostr(Dwang)+': ';
			RijwegL := PrlRijweg^.Rijwegen;
			while assigned(RijwegL) do begin
				spoor := KlikpuntSpoor(RijwegL^.Rijweg^.Sein^.Van);
				s := s + spoor + ' - ';
				if not assigned(RijwegL^.Volgende) then begin
					spoor := KlikpuntSpoor(RijwegL^.Rijweg^.Naar);
					s := s + spoor;
					dwangBox.Items.Add(s);
				end;
				RijwegL := RijwegL^.Volgende;
			end;
		end else
			break;
	end;
	if dwangBox.Items.Count > 0 then
		dwangBox.ItemIndex := 0;
end;

procedure TstwscPlanregelEditForm.vanEditChange(Sender: TObject);
begin
	UpdateDwangen;
end;

procedure TstwscPlanregelEditForm.naarEditChange(Sender: TObject);
begin
UpdateDwangen;
end;

procedure TstwscPlanregelEditForm.FormShow(Sender: TObject);
begin
	ActiveControl := treinnrEdit;
end;

end.
