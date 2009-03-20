object stwscInfoForm: TstwscInfoForm
  Left = 404
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Over StwSim'
  ClientHeight = 359
  ClientWidth = 281
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 321
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 1
    object Shape1: TShape
      Left = 8
      Top = 8
      Width = 89
      Height = 89
      Brush.Style = bsClear
      Pen.Color = clBlue
      Pen.Width = 8
      Shape = stCircle
    end
    object Label1: TLabel
      Left = 32
      Top = 24
      Width = 115
      Height = 36
      Caption = 'StwSim'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -32
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 32
      Top = 56
      Width = 115
      Height = 16
      Caption = '© Daan Goedkoop'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 168
      Top = 80
      Width = 88
      Height = 16
      Caption = 'BETA-VERSIE'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Memo1: TMemo
      Left = 8
      Top = 104
      Width = 265
      Height = 209
      BorderStyle = bsNone
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'StwSim'
        'Copyright © 2007, 2008, 2009, Daan Goedkoop. '
        'Alle rechten voorbehouden.'
        ''
        'StwSim mag gratis gebruikt worden voor  '
        'privé-doeleinden. Het gebruik voor commerciële of '
        'educatieve doeleinden, alsmede het wijzigen van '
        'het programma is niet toegestaan.'
        ''
        'De correctheid van StwSim kan niet worden '
        'gegarandeerd. Gebruik van StwSim voor '
        'veiligheidskritische toepassingen is daarom niet '
        'toegestaan.'
        ''
        'StwSim wordt geleverd zonder enige garantie, in '
        'welke vorm dan ook. Het gebruik ervan geschiedt '
        'op eigen risico. De auteur accepteert geen enkele '
        'aansprakelijkheid voor welke schade dan ook die '
        'direct of indirect door StwSim zou kunnen zijn '
        'veroorzaakt.')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 104
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
end
