unit stwsimclientScore;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, stwvScore;

type
  TstwscScoreForm = class(TForm)
    OpTijdProgress: TProgressBar;
    Label1: TLabel;
	 OpTijdLabel: TLabel;
    DrieLabel: TLabel;
    DrieProgress: TProgressBar;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
	 CorrectPerronLabel: TLabel;
    CorrectPerronProgress: TProgressBar;
    VertragingVerminderLabel: TLabel;
    VertragingVeroorzaakLabel: TLabel;
    OKBut: TButton;
  private
	 { Private declarations }
	public
		{ Public declarations }
		ScoreInfo: TScoreInfo;
		procedure UpdateDingen;
	end;

var
  stwscScoreForm: TstwscScoreForm;

implementation

{$R *.DFM}

procedure TstwscScoreForm.UpdateDingen;
var
	VertrPunten: integer;
	PerronPunten: integer;
	x: integer;
begin
	VertrPunten := ScoreInfo.AankomstOpTijd+ScoreInfo.AankomstBinnenDrie+
						ScoreInfo.AankomstTeLaat;
	PerronPunten := ScoreInfo.PerronCorrect+ScoreInfo.PerronFout;

	if VertrPunten > 0 then x := round(100 / VertrPunten * ScoreInfo.AankomstOpTijd)
	else x := 0;
	OpTijdProgress.Position := x; OpTijdLabel.Caption := inttostr(x)+'% van '+inttostr(VertrPunten);
	if VertrPunten > 0 then x := round(100 / VertrPunten * (ScoreInfo.AankomstOpTijd+ScoreInfo.AankomstBinnenDrie))
	else x := 0;
	DrieProgress.Position := x; DrieLabel.Caption := inttostr(x)+'%';

	VertragingVeroorzaakLabel.Caption := inttostr(ScoreInfo.VertragingVeroorzaakt);
	VertragingVerminderLabel.Caption := inttostr(ScoreInfo.VertragingVerminderd);

	if PerronPunten > 0 then x := round(100 / PerronPunten * ScoreInfo.PerronCorrect)
	else x := 0;
	CorrectPerronProgress.Position := x; CorrectPerronLabel.Caption := inttostr(x)+'% van '+inttostr(PerronPunten);
end;

end.
