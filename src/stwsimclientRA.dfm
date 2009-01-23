object stwscRAform: TstwscRAform
  Left = 264
  Top = 229
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dienstregelingpunt overslaan'
  ClientHeight = 73
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
    Width = 67
    Height = 13
    Caption = 'Stationsnaam:'
  end
  object stationEdit: TEdit
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
    Caption = 'OK'
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
