object stwssMainForm: TstwssMainForm
  Left = 192
  Top = 106
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'StwSim Server'
  ClientHeight = 165
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 168
    Top = 16
    Width = 84
    Height = 13
    Caption = 'Simulatiesnelheid:'
  end
  object Label2: TLabel
    Left = 168
    Top = 72
    Width = 11
    Height = 13
    Caption = 'x1'
  end
  object Label3: TLabel
    Left = 304
    Top = 72
    Width = 17
    Height = 13
    Caption = 'x10'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 328
    Height = 2
    Align = alTop
  end
  object OpenButton: TButton
    Left = 8
    Top = 16
    Width = 153
    Height = 25
    Action = OpenAction
    TabOrder = 0
  end
  object StartButton: TButton
    Left = 8
    Top = 112
    Width = 153
    Height = 25
    Action = StartAction
    TabOrder = 1
  end
  object SpeedTrack: TTrackBar
    Left = 168
    Top = 32
    Width = 150
    Height = 33
    Min = 1
    Orientation = trHorizontal
    Frequency = 1
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 2
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 146
    Width = 328
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Open eerst een simulatie'
  end
  object dienstBut: TButton
    Left = 8
    Top = 48
    Width = 153
    Height = 25
    Action = DienstOpenAction
    TabOrder = 4
  end
  object Button1: TButton
    Left = 8
    Top = 80
    Width = 153
    Height = 25
    Action = DienstEditAction
    TabOrder = 5
  end
  object doorspoelBut: TButton
    Left = 168
    Top = 112
    Width = 153
    Height = 25
    Action = DoorspoelAction
    TabOrder = 6
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 256
    Top = 40
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'sss'
    Filter = 'StwSim Server Simulatie|*.sss'
    Left = 288
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 256
    Top = 8
    object Bestand1: TMenuItem
      Caption = '&Bestand'
      object Openen1: TMenuItem
        Action = OpenAction
      end
      object N2Dienstregelingopenen1: TMenuItem
        Action = DienstOpenAction
      end
      object Dienstregelingopslaanals1: TMenuItem
        Action = DienstSaveAction
      end
      object Afsluiten1: TMenuItem
        Caption = '&Afsluiten'
        ShortCut = 32883
        OnClick = Afsluiten1Click
      end
    end
    object Simulatie1: TMenuItem
      Caption = '&Simulatie'
      object Start1: TMenuItem
        Action = StartAction
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Info1: TMenuItem
        Caption = '&Info'
        ShortCut = 112
        OnClick = Info1Click
      end
    end
  end
  object ActionList: TActionList
    Left = 256
    Top = 72
    object OpenAction: TAction
      Caption = 'Infrastructuur openen...'
      ShortCut = 16463
      OnExecute = OpenActionExecute
    end
    object DienstOpenAction: TAction
      Caption = 'Dienstregeling openen...'
      Enabled = False
      OnExecute = DienstOpenActionExecute
    end
    object DienstSaveAction: TAction
      Caption = 'Dienstregeling opslaan als...'
      OnExecute = DienstSaveActionExecute
    end
    object DienstEditAction: TAction
      Caption = 'Dienstregeling bewerken...'
      Enabled = False
      OnExecute = DienstEditActionExecute
    end
    object StartAction: TAction
      Caption = '&Start'
      Enabled = False
      OnExecute = StartActionExecute
    end
    object DoorspoelAction: TAction
      Caption = '&Doorspoelen'
      Enabled = False
      OnExecute = DoorspoelActionExecute
    end
  end
  object DienstOpenDialog: TOpenDialog
    DefaultExt = 'ssd'
    Filter = 'StwSim Server Dienstregeling|*.ssd'
    Left = 288
    Top = 40
  end
  object DienstSaveDialog: TSaveDialog
    DefaultExt = 'ssd'
    Filter = 'StwSim Server Dienstregeling|*.ssd'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 288
    Top = 72
  end
end
