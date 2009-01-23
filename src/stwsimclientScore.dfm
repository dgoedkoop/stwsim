object stwscScoreForm: TstwscScoreForm
  Left = 192
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Prestatie-beoordeling'
  ClientHeight = 170
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Geen vertraging:'
  end
  object OpTijdLabel: TLabel
    Left = 272
    Top = 16
    Width = 57
    Height = 13
    Caption = 'OpTijdLabel'
  end
  object DrieLabel: TLabel
    Left = 272
    Top = 40
    Width = 45
    Height = 13
    Caption = 'DrieLabel'
  end
  object Label3: TLabel
    Left = 8
    Top = 40
    Width = 91
    Height = 13
    Caption = 'Vertraging < 3 min.:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 150
    Height = 13
    Caption = 'Minuten vertraging veroorzaakt:'
  end
  object Label4: TLabel
    Left = 8
    Top = 88
    Width = 140
    Height = 13
    Caption = 'Minuten vertraging ingelopen:'
  end
  object Label6: TLabel
    Left = 8
    Top = 112
    Width = 76
    Height = 13
    Caption = 'Correcte perron:'
  end
  object CorrectPerronLabel: TLabel
    Left = 272
    Top = 112
    Width = 91
    Height = 13
    Caption = 'CorrectPerronLabel'
  end
  object VertragingVerminderLabel: TLabel
    Left = 272
    Top = 88
    Width = 121
    Height = 13
    Caption = 'VertragingVerminderLabel'
  end
  object VertragingVeroorzaakLabel: TLabel
    Left = 272
    Top = 64
    Width = 128
    Height = 13
    Caption = 'VertragingVeroorzaakLabel'
  end
  object OpTijdProgress: TProgressBar
    Left = 112
    Top = 16
    Width = 150
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object DrieProgress: TProgressBar
    Left = 112
    Top = 40
    Width = 150
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 1
  end
  object CorrectPerronProgress: TProgressBar
    Left = 112
    Top = 112
    Width = 150
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 2
  end
  object OKBut: TButton
    Left = 272
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
end
