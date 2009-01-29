object stwscTelefoonGesprekForm: TstwscTelefoonGesprekForm
  Left = 266
  Top = 142
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Telefoongesprek'
  ClientHeight = 274
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Gesprek:'
  end
  object Label2: TLabel
    Left = 8
    Top = 128
    Width = 107
    Height = 13
    Caption = 'Mogelijke antwoorden:'
  end
  object okBut: TButton
    Left = 320
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Stuur bericht'
    Default = True
    TabOrder = 3
    OnClick = okButClick
  end
  object ophangBut: TButton
    Left = 8
    Top = 240
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ophangen'
    TabOrder = 2
    OnClick = ophangButClick
  end
  object watList: TListBox
    Left = 8
    Top = 144
    Width = 385
    Height = 89
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = watListDblClick
  end
  object berichtMemo: TMemo
    Left = 8
    Top = 24
    Width = 385
    Height = 97
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
