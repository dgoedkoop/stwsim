program stwsimedit;

uses
  Forms,
  stwsimEditMain in 'stwsimEditMain.pas' {stwseMain},
  stwsimClientEditInfo in 'stwsimClientEditInfo.pas' {stwsceInfoForm},
  stwsimEditHelpers in 'stwsimEditHelpers.pas',
  stwvMisc in 'stwvMisc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'StwSim Editor';
  Application.CreateForm(TstwseMain, stwseMain);
  Application.CreateForm(TstwsceInfoForm, stwsceInfoForm);
  Application.Run;
end.
