object stwscInterposeForm: TstwscInterposeForm
  Left = 216
  Top = 282
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Treinnummer wijzigen'
  ClientHeight = 74
  ClientWidth = 243
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
    Width = 93
    Height = 13
    Caption = 'Nieuw treinnummer:'
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
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Wijzig'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cancelBut: TButton
    Left = 80
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 2
  end
end
