object stwscProcesplanForm: TstwscProcesplanForm
  Left = 192
  Top = 106
  Width = 492
  Height = 353
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
    Width = 234
    Height = 301
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object RePanel: TPanel
    Left = 234
    Top = 25
    Width = 250
    Height = 301
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
  end
  object LiBtnPanel: TPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 484
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Procesplan toevoegen'
      TabOrder = 0
      OnClick = Button1Click
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
