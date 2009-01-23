program stwsimserver;

uses
  Forms,
  stwsimServerMain in 'stwsimServerMain.pas' {stwssMainForm},
  stwsimServerInfo in 'stwsimServerInfo.pas' {stwssInfoForm},
  stwpCore in 'stwpCore.pas',
  stwpTijd in 'stwpTijd.pas',
  stwpRails in 'stwpRails.pas',
  stwpMeetpunt in 'stwpMeetpunt.pas',
  stwpTreinen in 'stwpTreinen.pas',
  stwpRijplan in 'stwpRijplan.pas',
  serverReadMsg in 'serverReadMsg.pas',
  stwpSeinen in 'stwpSeinen.pas',
  stwpVerschijnlijst in 'stwpVerschijnLijst.pas',
  stwsimServerDienstreg in 'stwsimServerDienstreg.pas' {stwssDienstregForm},
  stwsimServerTreinDienst in 'stwsimServerTreinDienst.pas' {stwssTreinDienstForm},
  stwsimserverBewerkPlanpunt in 'stwsimserverBewerkPlanpunt.pas' {stwssPlanpuntBewerkForm},
  stwsimServerVerschijnpunt in 'stwsimServerVerschijnpunt.pas' {stwssVerschijnpuntForm},
  stwsimserverAddMat in 'stwsimserverAddMat.pas' {stwssAddMatForm},
  stwsimserverTreinnr in 'stwsimserverTreinnr.pas' {stwssTreinnrForm},
  stwsimserverTreinCopy in 'stwsimserverTreinCopy.pas' {stwssTreinCopyForm},
  stwpOverwegen in 'stwpOverwegen.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'StwSim Server';
  Application.CreateForm(TstwssMainForm, stwssMainForm);
  Application.CreateForm(TstwssInfoForm, stwssInfoForm);
  Application.CreateForm(TstwssDienstregForm, stwssDienstregForm);
  Application.Run;
end.
