object stwscNieuweDienstForm: TstwscNieuweDienstForm
  Left = 192
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Andere dienstregeling'
  ClientHeight = 97
  ClientWidth = 241
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
    Top = 12
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object treinnrEdit: TEdit
    Left = 112
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object okBut: TButton
    Left = 160
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cancelBut: TButton
    Left = 80
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 2
  end
  object vanEdit: TEdit
    Left = 112
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object vanCheck: TCheckBox
    Left = 8
    Top = 32
    Width = 97
    Height = 17
    Caption = 'Van station:'
    TabOrder = 4
    OnClick = vanCheckClick
  end
end
