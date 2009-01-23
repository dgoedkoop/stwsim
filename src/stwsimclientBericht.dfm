object stwscBerichtForm: TstwscBerichtForm
  Left = 351
  Top = 185
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Binnengekomen berichten'
  ClientHeight = 209
  ClientWidth = 329
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
  object treinCaption: TLabel
    Left = 8
    Top = 8
    Width = 127
    Height = 13
    Caption = 'Binnengekomen berichten:'
  end
  object berichtenList: TListBox
    Left = 8
    Top = 24
    Width = 313
    Height = 97
    ItemHeight = 13
    TabOrder = 0
    OnClick = berichtenListClick
    OnDblClick = berichtenListDblClick
  end
  object berichtMemo: TMemo
    Left = 8
    Top = 128
    Width = 313
    Height = 41
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object replyBut: TButton
    Left = 248
    Top = 176
    Width = 73
    Height = 25
    Caption = 'Beantwoord'
    Default = True
    TabOrder = 2
    OnClick = replyButClick
  end
  object wisBut: TButton
    Left = 168
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Negeer'
    TabOrder = 3
    OnClick = wisButClick
  end
  object cancelBut: TButton
    Left = 8
    Top = 176
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Sluiten'
    ModalResult = 2
    TabOrder = 4
  end
end
