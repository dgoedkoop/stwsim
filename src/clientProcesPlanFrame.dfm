object stwscProcesPlanFrame: TstwscProcesPlanFrame
  Left = 0
  Top = 0
  Width = 496
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
    Width = 496
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
    TabOrder = 0
    OnDblClick = RegelListDblClick
  end
  object btnPanel: TPanel
    Left = 0
    Top = 17
    Width = 496
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object ExecBut: TButton
      Left = 8
      Top = 0
      Width = 105
      Height = 25
      Caption = 'Voer nu uit'
      TabOrder = 0
      OnClick = ExecButClick
    end
    object EditBut: TButton
      Left = 240
      Top = 0
      Width = 81
      Height = 25
      Caption = 'Bewerk'
      TabOrder = 1
      OnClick = EditButClick
    end
    object DelBut: TButton
      Left = 328
      Top = 0
      Width = 81
      Height = 25
      Caption = 'Verwijder'
      TabOrder = 2
      OnClick = DelButClick
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
    end
  end
  object TitelPanel: TPanel
    Left = 0
    Top = 0
    Width = 496
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
    Width = 496
    Height = 87
    Align = alTop
    Color = clBlack
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
    TabOrder = 3
  end
end
