object stwscProcesPlanFrame: TstwscProcesPlanFrame
  Left = 0
  Top = 0
  Width = 498
  Height = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Fixedsys'
  Font.Style = []
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object RegelList: TListBox
    Left = 0
    Top = 129
    Width = 498
    Height = 187
    Align = alClient
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    PopupMenu = PopupMenu
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnClick = RegelListClick
    OnDblClick = RegelListDblClick
    OnDrawItem = RegelListDrawItem
    OnMouseDown = RegelListMouseDown
  end
  object btnPanel: TPanel
    Left = 0
    Top = 17
    Width = 498
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object ExecBut: TButton
      Left = 8
      Top = 0
      Width = 105
      Height = 25
      Action = VoernuuitAct
      TabOrder = 0
    end
    object EditBut: TButton
      Left = 240
      Top = 0
      Width = 81
      Height = 25
      Action = BewerkAct
      TabOrder = 1
    end
    object DelBut: TButton
      Left = 328
      Top = 0
      Width = 81
      Height = 25
      Action = DelAct
      TabOrder = 2
    end
    object ARICheck: TCheckBox
      Left = 120
      Top = 4
      Width = 113
      Height = 17
      Caption = 'Automatisch'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = ARICheckClick
    end
  end
  object TitelPanel: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object titelLabel: TLabel
      Left = 0
      Top = 0
      Width = 80
      Height = 15
      Caption = 'titelLabel'
    end
  end
  object HistList: TListBox
    Left = 0
    Top = 42
    Width = 498
    Height = 87
    Align = alTop
    Color = clBlack
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 15
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 3
    OnDrawItem = HistListDrawItem
  end
  object PopupMenu: TPopupMenu
    Left = 48
    Top = 168
    object Voernuuit1: TMenuItem
      Action = VoernuuitAct
    end
    object UitschakelenvoorARI1: TMenuItem
      Action = GeenARIAct
    end
    object Verwerkvertraging1: TMenuItem
      Action = VVAct
      Caption = 'Vertraging verwerken'
    end
    object Bewerk1: TMenuItem
      Action = BewerkAct
      Caption = 'Bewerken...'
    end
    object Verwijder1: TMenuItem
      Action = DelAct
      Caption = 'Verwijderen...'
    end
  end
  object ActionList: TActionList
    Left = 88
    Top = 168
    object VoernuuitAct: TAction
      Caption = 'Voer nu uit'
      OnExecute = VoernuuitActExecute
    end
    object BewerkAct: TAction
      Caption = 'Bewerk'
      OnExecute = BewerkActExecute
    end
    object DelAct: TAction
      Caption = 'Verwijder'
      OnExecute = DelActExecute
    end
    object VVAct: TAction
      Caption = 'Verwerk vertraging'
      OnExecute = VVActExecute
    end
    object GeenARIAct: TAction
      Caption = 'Uitschakelen voor ARI'
      OnExecute = GeenARIActExecute
    end
  end
end
