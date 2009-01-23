program stwsim;

{%File 'rijweg.txt'}

uses
  Forms,
  stwsimMain in 'stwsimMain.pas' {stwsimMainForm},
  stwsimClientInfo in 'stwsimClientInfo.pas' {stwscInfoForm},
  stwsimClientConnect in 'stwsimClientConnect.pas' {stwscConnectForm},
  stwsimClientInterpose in 'stwsimClientInterpose.pas' {stwscInterposeForm},
  stwsimclientTreinMsg in 'stwsimclientTreinMsg.pas' {stwscTreinMsgForm},
  stwsimclientBericht in 'stwsimclientBericht.pas' {stwscBerichtForm},
  clientProcesplanForm in 'clientProcesplanForm.pas' {stwscProcesplanForm},
  clientProcesPlanFrame in 'clientProcesPlanFrame.pas' {stwscProcesPlanFrame: TFrame},
  clientPlanregelEdit in 'clientPlanregelEdit.pas' {stwscPlanregelEditForm},
  stwsimClientNieuwPlanpunt in 'stwsimClientNieuwPlanpunt.pas' {stwscNieuwPlanpuntForm},
  stwsimclientNieuweDienst in 'stwsimclientNieuweDienst.pas' {stwscNieuweDienstForm},
  stwsimclientRA in 'stwsimclientRA.pas' {stwscRAform},
  stwsimclientScore in 'stwsimclientScore.pas' {stwscScoreForm},
  stwsimclientTreinStatus in 'stwsimclientTreinStatus.pas' {stwscTreinStatusForm},
  stwvMeetpunt in 'stwvMeetpunt.pas',
  stwvCore in 'stwvCore.pas',
  clientReadMsg in 'clientReadMsg.pas',
  clientSendMsg in 'clientSendMsg.pas',
  stwvRijveiligheid in 'stwvRijveiligheid.pas',
  stwvTreinComm in 'stwvTreinComm.pas',
  stwvRijwegLogica in 'stwvRijwegLogica.pas',
  stwvLog in 'stwvLog.pas',
  stwvProcesplan in 'stwvProcesPlan.pas',
  stwvSternummer in 'stwvSternummer.pas',
  stwvScore in 'stwvScore.pas',
  stwpTijd in 'stwpTijd.pas',
  stwpVerschijnlijst in 'stwpVerschijnLijst.pas',
  stwpMeetpunt in 'stwpMeetpunt.pas',
  stwpOverwegen in 'stwpOverwegen.pas',
  stwpRails in 'stwpRails.pas',
  stwpRijplan in 'stwpRijplan.pas',
  stwpSeinen in 'stwpSeinen.pas',
  stwpSternummer in 'stwpSternummer.pas',
  stwpTreinen in 'stwpTreinen.pas',
  stwpCore in 'stwpCore.pas',
  stwsimServerDienstreg in 'stwsimServerDienstreg.pas' {stwssDienstregForm},
  stwsimserverTreinCopy in 'stwsimserverTreinCopy.pas' {stwssTreinCopyForm},
  stwsimServerTreinDienst in 'stwsimServerTreinDienst.pas' {stwssTreinDienstForm},
  stwsimserverTreinnr in 'stwsimserverTreinnr.pas' {stwssTreinnrForm},
  stwsimServerVerschijnpunt in 'stwsimServerVerschijnpunt.pas' {stwssVerschijnpuntForm},
  stwsimComm in 'stwsimComm.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'StwSim';
  Application.CreateForm(TstwsimMainForm, stwsimMainForm);
  Application.CreateForm(TstwscInfoForm, stwscInfoForm);
  Application.CreateForm(TstwscConnectForm, stwscConnectForm);
  Application.CreateForm(TstwscInterposeForm, stwscInterposeForm);
  Application.CreateForm(TstwscTreinMsgForm, stwscTreinMsgForm);
  Application.CreateForm(TstwscBerichtForm, stwscBerichtForm);
  Application.CreateForm(TstwscProcesplanForm, stwscProcesplanForm);
  Application.CreateForm(TstwscPlanregelEditForm, stwscPlanregelEditForm);
  Application.CreateForm(TstwscNieuwPlanpuntForm, stwscNieuwPlanpuntForm);
  Application.CreateForm(TstwscNieuweDienstForm, stwscNieuweDienstForm);
  Application.CreateForm(TstwscRAform, stwscRAform);
  Application.CreateForm(TstwscScoreForm, stwscScoreForm);
  Application.CreateForm(TstwscTreinStatusForm, stwscTreinStatusForm);
  Application.CreateForm(TstwssDienstregForm, stwssDienstregForm);
  Application.CreateForm(TstwssTreinCopyForm, stwssTreinCopyForm);
  Application.CreateForm(TstwssTreinDienstForm, stwssTreinDienstForm);
  Application.CreateForm(TstwssTreinnrForm, stwssTreinnrForm);
  Application.CreateForm(TstwssVerschijnpuntForm, stwssVerschijnpuntForm);
  Application.Run;
end.
