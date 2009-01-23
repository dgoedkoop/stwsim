object stwssTreinCopyForm: TstwssTreinCopyForm
  Left = 304
  Top = 299
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Kopiëren en herhalen'
  ClientHeight = 122
  ClientWidth = 259
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
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 91
    Height = 13
    Caption = 'Aantal herhalingen:'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 89
    Height = 13
    Caption = 'Interval in minuten:'
  end
  object Label3: TLabel
    Left = 8
    Top = 60
    Width = 101
    Height = 13
    Caption = 'Treinnr ophogen met:'
  end
  object countEdit: TEdit
    Left = 128
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object minEdit: TEdit
    Left = 128
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object nrupedit: TEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object okBut: TButton
    Left = 176
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object cancelBut: TButton
    Left = 96
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 4
  end
end
