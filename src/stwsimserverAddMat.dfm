object stwssAddMatForm: TstwssAddMatForm
  Left = 192
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Materieel laden'
  ClientHeight = 88
  ClientWidth = 168
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
    Width = 84
    Height = 13
    Caption = 'Materieelbestand:'
  end
  object Matcombo: TComboBox
    Left = 8
    Top = 24
    Width = 153
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object OKBut: TButton
    Left = 88
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Toevoegen'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBut: TButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 2
  end
end
