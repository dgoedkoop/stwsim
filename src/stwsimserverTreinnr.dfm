object stwssTreinnrForm: TstwssTreinnrForm
  Left = 192
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Treinnummer'
  ClientHeight = 89
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object treinnrEdit: TEdit
    Left = 8
    Top = 24
    Width = 185
    Height = 21
    TabOrder = 0
  end
  object okBut: TButton
    Left = 120
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cancelBut: TButton
    Left = 40
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 2
  end
end
