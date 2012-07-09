object stwscProcesplanForm: TstwscProcesplanForm
  Left = 194
  Top = 108
  Width = 488
  Height = 349
  Caption = 'Procesplan Rijwegen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Fixedsys'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object LiPanel: TPanel
    Left = 0
    Top = 25
    Width = 225
    Height = 290
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object RePanel: TPanel
    Left = 225
    Top = 25
    Width = 255
    Height = 290
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
  end
  object LiBtnPanel: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object ProcesplanToevBtn: TButton
      Left = 0
      Top = 0
      Width = 480
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Procesplan toevoegen'
      TabOrder = 0
      OnClick = ProcesplanToevBtnClick
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'stp'
    Filter = 'StwSim Procesplan|*.stp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Procesplan'
    Left = 40
    Top = 136
  end
end
