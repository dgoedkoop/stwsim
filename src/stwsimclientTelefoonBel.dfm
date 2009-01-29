object stwscTelefoonBelForm: TstwscTelefoonBelForm
  Left = 192
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Opbellen...'
  ClientHeight = 90
  ClientWidth = 169
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
    Width = 92
    Height = 13
    Caption = 'Wie wilt u opbellen:'
  end
  object monteurRadio: TRadioButton
    Left = 8
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Storingsdienst'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object cancelBut: TButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 1
  end
  object okBut: TButton
    Left = 88
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
