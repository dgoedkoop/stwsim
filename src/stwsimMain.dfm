object stwsimMainForm: TstwsimMainForm
  Left = 215
  Top = 167
  Width = 729
  Height = 547
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object BedienPanel: TPanel
    Left = 0
    Top = 0
    Width = 721
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 210
      Top = 0
      Width = 3
      Height = 77
      Cursor = crHSplit
      Align = alRight
    end
    object msgMemo: TMemo
      Left = 0
      Top = 0
      Width = 210
      Height = 77
      Align = alClient
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object statPanel: TPanel
      Left = 213
      Top = 0
      Width = 508
      Height = 77
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
      object telBtn: TSpeedButton
        Left = 384
        Top = 52
        Width = 115
        Height = 25
        Action = TelefoonShow
        Anchors = [akRight, akBottom]
        Enabled = False
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
      object voerInBut: TButton
        Left = 8
        Top = 52
        Width = 75
        Height = 25
        Action = RijwegVoerin
        Anchors = [akLeft, akBottom]
        Caption = 'Voer in'
        TabOrder = 0
      end
      object cancelBut: TButton
        Left = 88
        Top = 52
        Width = 75
        Height = 25
        Action = RijwegHo
        Anchors = [akLeft, akBottom]
        Enabled = False
        TabOrder = 1
      end
      object invoerEdit: TEdit
        Left = 8
        Top = 20
        Width = 490
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        ParentColor = True
        TabOrder = 2
        OnChange = invoerEditChange
        OnEnter = invoerEditEnter
        OnExit = invoerEditExit
      end
    end
    object hsepPanel: TPanel
      Left = 0
      Top = 77
      Width = 721
      Height = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object SchermenTab: TTabControl
    Left = 0
    Top = 81
    Width = 721
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
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 8
      Width = 177
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
  object PauzePanel: TPanel
    Left = 392
    Top = 120
    Width = 121
    Height = 41
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'PAUZE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  object SimOpenPanel: TPanel
    Left = 520
    Top = 120
    Width = 161
    Height = 88
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 4
    Visible = False
    object SimOpenBut: TBitBtn
      Left = 8
      Top = 8
      Width = 141
      Height = 68
      Action = SimOpenen
      Caption = 'Simulatie laden'
      TabOrder = 0
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000084
        8400FF00FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222222222222222222200000000000222220011111111102222030111111111
        0222043011111111102203430111111111020434300000000000034343434302
        2222043434343402222203430000000222222000222222220002222222222222
        2002222222220222020222222222200022222222222222222222}
      Layout = blGlyphTop
    end
  end
  object SimStartPanel: TPanel
    Left = 384
    Top = 216
    Width = 233
    Height = 240
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 5
    Visible = False
    object BitBtn1: TBitBtn
      Left = 8
      Top = 8
      Width = 213
      Height = 68
      Action = StartMetDienstAction
      Caption = 'Start met dienstregeling'
      TabOrder = 0
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000084
        8400FF00FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222222222222222222222222222202222222222222220022222222222222030
        2222222222222033022200000000003330220333333333333302033333333333
        3330033333333333330200000000003330222222222220330222222222222030
        2222222222222002222222222222202222222222222222222222}
      Layout = blGlyphTop
    end
    object BitBtn2: TBitBtn
      Left = 8
      Top = 84
      Width = 213
      Height = 68
      Action = SGOpenen
      Caption = 'Opgeslagen spel laden'
      TabOrder = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000084
        8400FF00FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222222222222222222200000000000222220011111111102222030111111111
        0222043011111111102203430111111111020434300000000000034343434302
        2222043434343402222203430000000222222000222222220002222222222222
        2002222222220222020222222222200022222222222222222222}
      Layout = blGlyphTop
    end
    object BitBtn3: TBitBtn
      Left = 8
      Top = 160
      Width = 213
      Height = 68
      Action = EerstDienstBewerkenAction
      Caption = 'Dienstregeling bewerken'
      TabOrder = 2
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000084
        8400FF00FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222222222222222222222000000000022222222222222222222220000000002
        2222222222222222222222000000000002222222222222222222220000002022
        2222222222222200222222000000020002222222222222200022220000002222
        0022222222222222202222222222222222222222222222222222}
      Layout = blGlyphTop
    end
  end
  object MainMenu: TMainMenu
    Left = 56
    Top = 320
    object Bestand2: TMenuItem
      Caption = '&Bestand'
      object Starten1: TMenuItem
        Action = PauzeAction
      end
      object Spelopslaanals1: TMenuItem
        Action = SGSave
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
      Action = TreinBellen
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
    object SimOpenen: TAction
      Category = 'Hoofdmenu'
      Caption = 'Simulatie laden'
      ShortCut = 16463
      OnExecute = SimOpenenExecute
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
    object TreinBellen: TAction
      Category = 'Popup'
      Caption = 'Trein bellen...'
      OnExecute = TreinBellenExecute
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
      Caption = 'Herstel'
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
    object TelefoonShow: TAction
      Category = 'Tools'
      Caption = 'Telefoon'
      OnExecute = TelefoonShowExecute
    end
    object Broadcast: TAction
      Category = 'Tools'
      Caption = 'Verzend broadcast'
      OnExecute = BroadcastExecute
    end
    object LaatProcesplanZien: TAction
      Category = 'Tools'
      Caption = 'Toon Procesplan Rijwegen'
      Enabled = False
      ShortCut = 120
      OnExecute = LaatProcesplanZienExecute
    end
    object GetScore: TAction
      Category = 'Tools'
      Caption = 'Prestatie-beoordeling'
      Enabled = False
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
    object PauzeAction: TAction
      Category = 'Hoofdmenu'
      Caption = 'Pauze'
      Checked = True
      Enabled = False
      ShortCut = 80
      OnExecute = PauzeActionExecute
    end
    object DoorspoelAction: TAction
      Category = 'Tools'
      Caption = 'Tijdversnelling'
      Enabled = False
      OnExecute = DoorspoelActionExecute
    end
    object ToonToolsAction: TAction
      Category = 'Misc'
      Caption = 'Hulpmiddelen tonen'
      Enabled = False
      ShortCut = 119
      OnExecute = ToonToolsActionExecute
    end
    object DienstEdit: TAction
      Category = 'Dienstregeling'
      Caption = '&Bewerken...'
      Enabled = False
      OnExecute = DienstEditExecute
    end
    object StartMetDienstAction: TAction
      Category = 'Hoofdmenu'
      Caption = 'Start met dienstregeling'
      OnExecute = StartMetDienstActionExecute
    end
    object EerstDienstBewerkenAction: TAction
      Category = 'Hoofdmenu'
      Caption = 'Dienstregeling bewerken'
      OnExecute = EerstDienstBewerkenActionExecute
    end
    object SGOpenen: TAction
      Category = 'Hoofdmenu'
      Caption = 'Opgeslagen spel laden'
      OnExecute = SGOpenenExecute
    end
    object SGSave: TAction
      Category = 'Hoofdmenu'
      Caption = 'Spel opslaan a&ls...'
      Enabled = False
      ShortCut = 16467
      OnExecute = SGSaveExecute
    end
    object Wisselreparatie: TAction
      Category = 'Tools'
      Caption = 'Wissel repareren...'
    end
    object RijwegVoerin: TAction
      Category = 'Rijweg'
      Caption = 'RijwegVoerin'
      OnExecute = RijwegVoerinExecute
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
  object GameOpenDialog: TOpenDialog
    DefaultExt = 'sso'
    Filter = 'StwSim Opgeslagen Spel|*.sso'
    Title = 'Opgeslagen spel openen'
    Left = 248
    Top = 320
  end
  object DienstOpenDialog: TOpenDialog
    DefaultExt = 'ssd'
    Filter = 'StwSim Server Dienstregeling|*.ssd'
    Title = 'Dienstregeling openen'
    Left = 216
    Top = 320
  end
  object GameSaveDialog: TSaveDialog
    DefaultExt = 'sso'
    Filter = 'StwSim Opgeslagen Spel|*.sso'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Spel opslaan'
    Left = 248
    Top = 352
  end
end
