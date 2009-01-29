object stwscTelefoonForm: TstwscTelefoonForm
  Left = 450
  Top = 102
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Telefoon'
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
    Width = 177
    Height = 13
    Caption = 'Binnenkomende telefoongesprekken:'
  end
  object gesprekkenList: TListBox
    Left = 8
    Top = 24
    Width = 313
    Height = 145
    ItemHeight = 13
    TabOrder = 0
    OnClick = gesprekkenListClick
    OnDblClick = gesprekkenListDblClick
  end
  object opneemBut: TButton
    Left = 248
    Top = 176
    Width = 73
    Height = 25
    Caption = 'Opnemen...'
    Default = True
    TabOrder = 4
    OnClick = opneemButClick
  end
  object cancelBut: TButton
    Left = 8
    Top = 176
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Sluiten'
    ModalResult = 2
    TabOrder = 1
  end
  object belBut: TButton
    Left = 88
    Top = 176
    Width = 73
    Height = 25
    Caption = 'Opbellen...'
    TabOrder = 2
    OnClick = belButClick
  end
  object weigerBut: TButton
    Left = 168
    Top = 176
    Width = 73
    Height = 25
    Caption = 'Weigeren'
    TabOrder = 3
    OnClick = weigerButClick
  end
end
