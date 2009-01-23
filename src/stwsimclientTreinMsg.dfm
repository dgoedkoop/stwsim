object stwscTreinMsgForm: TstwscTreinMsgForm
  Left = 207
  Top = 116
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Bericht naar trein sturen'
  ClientHeight = 148
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Bericht:'
  end
  object okBut: TButton
    Left = 320
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Stuur bericht'
    Default = True
    TabOrder = 0
    OnClick = okButClick
  end
  object cancelBut: TButton
    Left = 240
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 1
  end
  object watList: TListBox
    Left = 8
    Top = 24
    Width = 385
    Height = 89
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = watListDblClick
  end
end
