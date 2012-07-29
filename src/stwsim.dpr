program stwsim;

uses
{	FastMM4,}
  Forms,
  stwsimMain in 'stwsimMain.pas' {stwsimMainForm},
  stwsimClientInfo in 'stwsimClientInfo.pas' {stwscInfoForm},
  stwsimClientStringInput in 'stwsimClientStringInput.pas' {stwscStringInputForm},
  stwsimclientTelefoongesprek in 'stwsimclientTelefoongesprek.pas' {stwscTelefoonGesprekForm},
  stwsimclientTelefoon in 'stwsimclientTelefoon.pas' {stwscTelefoonForm},
  clientProcesplanForm in 'clientProcesplanForm.pas' {stwscProcesplanForm},
  clientProcesPlanFrame in 'clientProcesPlanFrame.pas' {stwscProcesPlanFrame: TFrame},
  clientPlanregelEdit in 'clientPlanregelEdit.pas' {stwscPlanregelEditForm},
  stwsimClientNieuwPlanpunt in 'stwsimClientNieuwPlanpunt.pas' {stwscNieuwPlanpuntForm},
  stwsimclientNieuweDienst in 'stwsimclientNieuweDienst.pas' {stwscNieuweDienstForm},
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
  stwsimComm in 'stwsimComm.pas',
  serverReadMsg in 'serverReadMsg.pas',
  serverSendMsg in 'serverSendMsg.pas',
  stwpTreinPhysics in 'stwpTreinPhysics.pas',
  stwpDatatypes in 'stwpDatatypes.pas',
  stwpTelefoongesprek in 'stwpTelefoongesprek.pas',
  stwpCommPhysics in 'stwpCommPhysics.pas',
  stwpMonteur in 'stwpMonteur.pas',
  stwpMonteurPhysics in 'stwpMonteurPhysics.pas',
  stwsimclientTelefoonBel in 'stwsimclientTelefoonBel.pas' {stwscTelefoonBelForm},
  stwvMisc in 'stwvMisc.pas',
  stwvRijwegen in 'stwvRijwegen.pas',
  stwvSporen in 'stwvSporen.pas',
  stwvTNV in 'stwvTNV.pas',
  stwvGleisplan in 'stwvGleisplan.pas',
  stwvSeinen in 'stwvSeinen.pas',
  stwpTreinInfo in 'stwpTreinInfo.pas',
  stwvTreinInfo in 'stwvTreinInfo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'StwSim';
  Application.CreateForm(TstwsimMainForm, stwsimMainForm);
  Application.CreateForm(TstwscInfoForm, stwscInfoForm);
  Application.CreateForm(TstwscStringInputForm, stwscStringInputForm);
  Application.CreateForm(TstwscTelefoonForm, stwscTelefoonForm);
  Application.CreateForm(TstwscTelefoonGesprekForm, stwscTelefoonGesprekForm);
  Application.CreateForm(TstwscProcesplanForm, stwscProcesplanForm);
  Application.CreateForm(TstwscPlanregelEditForm, stwscPlanregelEditForm);
  Application.CreateForm(TstwscNieuwPlanpuntForm, stwscNieuwPlanpuntForm);
  Application.CreateForm(TstwscNieuweDienstForm, stwscNieuweDienstForm);
  Application.CreateForm(TstwscScoreForm, stwscScoreForm);
  Application.CreateForm(TstwscTreinStatusForm, stwscTreinStatusForm);
  Application.CreateForm(TstwssDienstregForm, stwssDienstregForm);
  Application.CreateForm(TstwssTreinCopyForm, stwssTreinCopyForm);
  Application.CreateForm(TstwssTreinDienstForm, stwssTreinDienstForm);
  Application.CreateForm(TstwssTreinnrForm, stwssTreinnrForm);
  Application.CreateForm(TstwssVerschijnpuntForm, stwssVerschijnpuntForm);
  Application.CreateForm(TstwscTelefoonBelForm, stwscTelefoonBelForm);
  Application.Run;
end.
