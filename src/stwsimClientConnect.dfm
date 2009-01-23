object stwscConnectForm: TstwscConnectForm
  Left = 335
  Top = 262
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Verbinding maken'
  ClientHeight = 105
  ClientWidth = 234
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
    Width = 34
    Height = 13
    Caption = 'Server:'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 80
    Height = 13
    Caption = 'Gebruikersnaam:'
  end
  object okBut: TButton
    Left = 152
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Verbind'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object cancelBut: TButton
    Left = 72
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 3
  end
  object serverEdit: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object userEdit: TEdit
    Left = 104
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 1
  end
end
