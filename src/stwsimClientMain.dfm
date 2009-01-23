object stwsimMainForm: TstwsimMainForm
  Left = 262
  Top = 154
  Width = 732
  Height = 496
  Caption = 'StwSim'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Fixedsys'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object BedienPanel: TPanel
    Left = 0
    Top = 0
    Width = 724
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 213
      Top = 0
      Width = 3
      Height = 81
      Cursor = crHSplit
      Align = alRight
    end
    object msgMemo: TMemo
      Left = 0
      Top = 0
      Width = 213
      Height = 81
      Align = alClient
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object statPanel: TPanel
      Left = 216
      Top = 0
      Width = 508
      Height = 81
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object tijdLabel: TLabel
        Left = 8
        Top = 2
        Width = 40
        Height = 15
        Caption = '00:00'
      end
      object vannaarPanel: TPanel
        Left = 8
        Top = 24
        Width = 491
        Height = 25
        Anchors = [akLeft, akRight, akBottom]
        BevelOuter = bvNone
        BorderStyle = bsSingle
        TabOrder = 0
        object vanVeld: TLabel
          Left = 0
          Top = 3
          Width = 80
          Height = 15
          AutoSize = False
        end
        object naarVeld: TLabel
          Left = 96
          Top = 3
          Width = 80
          Height = 15
          AutoSize = False
        end
      end
      object Button1: TButton
        Left = 8
        Top = 56
        Width = 75
        Height = 25
        Action = RijwegNormaal
        Anchors = [akLeft, akBottom]
        Caption = 'Rijweg'
        TabOrder = 1
      end
      object Button2: TButton
        Left = 88
        Top = 56
        Width = 75
        Height = 25
        Action = RijwegHo
        Anchors = [akLeft, akBottom]
        TabOrder = 2
      end
    end
  end
  object SchermenTab: TTabControl
    Left = 0
    Top = 81
    Width = 724
    Height = 25
    Align = alTop
    Style = tsButtons
    TabOrder = 1
    OnChange = SchermenTabChange
  end
  object ToolsPanel: TPanel
    Left = 8
    Top = 144
    Width = 369
    Height = 121
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 2
    Visible = False
    object telBtn: TSpeedButton
      Left = 8
      Top = 40
      Width = 169
      Height = 25
      Action = NieuwBericht
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000
        0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
        0000000000000000000000000000000000000000000000000000000000000000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000000000000000000000000000000000000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
        0000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000000000000000000000000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFF00000000000000
        0000000000000000FFFFFF000000000000000000000000FFFFFF000000000000
        000000000000FFFFFF000000000000000000000000000000FFFFFF0000000000
        00000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
        0000000000000000000000000000000000FFFFFFFFFFFFFFFFFF}
      ParentFont = False
    end
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 8
      Width = 169
      Height = 25
      Action = Broadcast
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000
        0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
        0000000000000000000000000000000000000000000000000000000000000000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000000000000000000000000000000000000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF000000FF
        FFFF000000FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
        0000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000000000000000000000000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFF00000000000000
        0000000000000000FFFFFF000000000000000000000000FFFFFF000000000000
        000000000000FFFFFF000000000000000000000000000000FFFFFF0000000000
        00000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
        0000000000000000000000000000000000FFFFFFFFFFFFFFFFFF}
      ParentFont = False
    end
    object Label1: TLabel
      Left = 197
      Top = 8
      Width = 144
      Height = 15
      Caption = 'Simulatiesnelheid:'
    end
    object Label2: TLabel
      Left = 200
      Top = 64
      Width = 16
      Height = 15
      Caption = '1x'
    end
    object Label3: TLabel
      Left = 328
      Top = 64
      Width = 24
      Height = 15
      Caption = '10x'
    end
    object SpeedTrack: TTrackBar
      Left = 195
      Top = 32
      Width = 150
      Height = 33
      Min = 1
      Orientation = trHorizontal
      Frequency = 1
      Position = 1
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
    end
    object DoorspoelBut: TButton
      Left = 200
      Top = 88
      Width = 137
      Height = 25
      Action = DoorspoelAction
      TabOrder = 1
    end
  end
  object MainMenu: TMainMenu
    Left = 56
    Top = 320
    object Bestand2: TMenuItem
      Caption = '&Simulatie'
      object Openen1: TMenuItem
        Action = Openen
      end
      object Starten1: TMenuItem
        Action = StartAction
      end
      object Afsluiten1: TMenuItem
        Action = Afsluiten
      end
    end
    object Bestand1: TMenuItem
      Caption = '&Dienstregeling'
      object Dienstregelingopenen1: TMenuItem
        Action = DienstOpen
      end
      object Dienstregelingopslaan1: TMenuItem
        Action = DienstSave
      end
      object Dienstregelingbewerken1: TMenuItem
        Action = DienstEdit
      end
    end
    object Rijweg1: TMenuItem
      Caption = '&Rijweg'
      object NNormalerijweg1: TMenuItem
        Action = RijwegNormaal
      end
      object ROZRijwegnaarbezetspoor1: TMenuItem
        Action = RijwegROZ
      end
      object ARijwegmetautomatischeseinen1: TMenuItem
        Action = RijwegAuto
      end
      object HRijwegherroepen1: TMenuItem
        Action = RijwegCancel
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object LaatProcesplanZien1: TMenuItem
        Action = LaatProcesplanZien
      end
    end
    object Hulpmiddelen1: TMenuItem
      Caption = '&Hulpmiddelen'
      object Prestaties1: TMenuItem
        Action = GetScore
      end
      object Hulpmiddelentonen1: TMenuItem
        Action = ToonToolsAction
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Info1: TMenuItem
        Caption = '&Info'
        OnClick = Info1Click
      end
    end
  end
  object TijdTimer: TTimer
    Interval = 100
    OnTimer = TijdTimerTimer
    Left = 88
    Top = 320
  end
  object BlinkTimer: TTimer
    Interval = 300
    OnTimer = BlinkTimerTimer
    Left = 120
    Top = 320
  end
  object SpoorPopup: TPopupMenu
    Left = 152
    Top = 320
    object Treinstatus1: TMenuItem
      Action = TreinStatus
    end
    object Treinnummerwijzigen1: TMenuItem
      Action = TreinInterpose
    end
    object Berichtnaartreinsturen1: TMenuItem
      Action = TreinBericht
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Wisselomzetten1: TMenuItem
      Action = WisselSwitch
    end
    object Verhinderbedieningwissel1: TMenuItem
      Action = WisselBedienVerh
    end
    object Verhinderrijwegoverwissel1: TMenuItem
      Action = WisselRijwegVerh
    end
  end
  object Actions: TActionList
    Left = 24
    Top = 320
    object TreinStatus: TAction
      Category = 'Popup'
      Caption = 'Treinstatus'
      OnExecute = TreinStatusExecute
    end
    object Openen: TAction
      Category = 'Hoofdmenu'
      Caption = 'Openen...'
      ShortCut = 16463
      OnExecute = OpenenExecute
    end
    object Afsluiten: TAction
      Category = 'Hoofdmenu'
      Caption = 'Afsluiten'
      ShortCut = 32883
      OnExecute = AfsluitenExecute
    end
    object TreinInterpose: TAction
      Category = 'Popup'
      Caption = 'Treinnummer wijzigen...'
      OnExecute = TreinInterposeExecute
    end
    object TreinBericht: TAction
      Category = 'Popup'
      Caption = 'Bericht naar trein sturen...'
      OnExecute = TreinBerichtExecute
    end
    object WisselSwitch: TAction
      Category = 'Popup'
      Caption = 'Wissel omzetten'
      OnExecute = WisselSwitchExecute
    end
    object WisselBedienVerh: TAction
      Category = 'Popup'
      Caption = 'Verhinder bediening wissel'
      OnExecute = WisselBedienVerhExecute
    end
    object WisselRijwegVerh: TAction
      Category = 'Popup'
      Caption = 'Verhinder rijweg over wissel'
      OnExecute = WisselRijwegVerhExecute
    end
    object RijwegHo: TAction
      Category = 'Rijweg'
      Caption = 'Annuleer'
      ShortCut = 27
      OnExecute = RijwegHoExecute
    end
    object RijwegNormaal: TAction
      Category = 'Rijweg'
      Caption = 'Normale rijweg'
      ShortCut = 112
      OnExecute = RijwegNormaalExecute
    end
    object RijwegROZ: TAction
      Category = 'Rijweg'
      Caption = 'Rijweg naar bezet spoor'
      ShortCut = 113
      OnExecute = RijwegROZExecute
    end
    object RijwegAuto: TAction
      Category = 'Rijweg'
      Caption = 'Rijweg met automatische seinen'
      ShortCut = 114
      OnExecute = RijwegAutoExecute
    end
    object RijwegCancel: TAction
      Category = 'Rijweg'
      Caption = 'Rijweg herroepen'
      ShortCut = 115
      OnExecute = RijwegCancelExecute
    end
    object NieuwBericht: TAction
      Category = 'Tools'
      Caption = 'Toon oproepen'
      OnExecute = NieuwBerichtExecute
    end
    object Broadcast: TAction
      Category = 'Tools'
      Caption = 'Verzend Broadcast'
      OnExecute = BroadcastExecute
    end
    object LaatProcesplanZien: TAction
      Category = 'Tools'
      Caption = 'Toon Procesplan Rijwegen'
      ShortCut = 120
      OnExecute = LaatProcesplanZienExecute
    end
    object GetScore: TAction
      Category = 'Tools'
      Caption = 'Prestatie-beoordeling'
      ShortCut = 116
      OnExecute = GetScoreExecute
    end
    object fullscreenAction: TAction
      Category = 'Misc'
      Caption = 'Volledig scherm'
      ShortCut = 122
      OnExecute = fullscreenActionExecute
    end
    object DienstOpen: TAction
      Category = 'Dienstregeling'
      Caption = '&Openen...'
      Enabled = False
      OnExecute = DienstOpenExecute
    end
    object DienstSave: TAction
      Category = 'Dienstregeling'
      Caption = 'Opslaan a&ls...'
      Enabled = False
      OnExecute = DienstSaveExecute
    end
    object StartAction: TAction
      Category = 'Hoofdmenu'
      Caption = 'Simulatie starten'
      OnExecute = StartActionExecute
    end
    object DoorspoelAction: TAction
      Category = 'Tools'
      Caption = 'Tijdversnelling'
      OnExecute = DoorspoelActionExecute
    end
    object ToonToolsAction: TAction
      Category = 'Misc'
      Caption = 'Hulpmiddelen tonen'
      ShortCut = 119
      OnExecute = ToonToolsActionExecute
    end
    object DienstEdit: TAction
      Category = 'Dienstregeling'
      Caption = '&Bewerken...'
      Enabled = False
      OnExecute = DienstEditExecute
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'sts'
    Filter = 'StwSim Client Files|*.sts'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Simulatie openen'
    Left = 184
    Top = 320
  end
  object DienstSaveDialog: TSaveDialog
    DefaultExt = 'ssd'
    Filter = 'StwSim Server Dienstregeling|*.ssd'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Dienstregeling opslaan'
    Left = 216
    Top = 352
  end
  object DienstOpenDialog: TOpenDialog
    DefaultExt = 'ssd'
    Filter = 'StwSim Server Dienstregeling|*.ssd'
    Title = 'Dienstregeling openen'
    Left = 184
    Top = 352
  end
end
