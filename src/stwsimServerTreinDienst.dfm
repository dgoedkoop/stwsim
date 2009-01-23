object stwssTreinDienstForm: TstwssTreinDienstForm
  Left = 273
  Top = 106
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dienstregeling van trein bewerken'
  ClientHeight = 288
  ClientWidth = 712
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreinnrLabel: TLabel
    Left = 256
    Top = 8
    Width = 59
    Height = 13
    Caption = 'TreinnrLabel'
  end
  object puntenList: TListBox
    Left = 8
    Top = 40
    Width = 697
    Height = 209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 15
    Items.Strings = (
      
        'STATION        SPOOR AANKOMST VERTREK WACHTTIJD STOP KOPPELEN KE' +
        'REN BIJZONDERHEDEN'
      
        'Groningen       3b    11:00    --:--    3:00     j      n       ' +
        'j   N:23015')
    ParentFont = False
    TabOrder = 0
  end
  object puntAddBut: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Toevoegen...'
    TabOrder = 1
    OnClick = puntAddButClick
  end
  object puntEditbut: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Bewerken...'
    TabOrder = 2
    OnClick = puntEditbutClick
  end
  object puntDelBut: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Verwijderen...'
    TabOrder = 3
    OnClick = puntDelButClick
  end
  object okBut: TButton
    Left = 632
    Top = 256
    Width = 75
    Height = 25
    Caption = '&Sluiten'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
end
