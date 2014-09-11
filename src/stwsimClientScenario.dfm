object stwscScenarioForm: TstwscScenarioForm
  Left = 234
  Top = 154
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Scenario kiezen'
  ClientHeight = 233
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 112
    Height = 13
    Caption = 'Beschikbare scenario'#39's:'
  end
  object Label2: TLabel
    Left = 168
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Beschrijving:'
  end
  object okBut: TButton
    Left = 297
    Top = 199
    Width = 80
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object ScenList: TListBox
    Left = 8
    Top = 24
    Width = 145
    Height = 169
    ItemHeight = 13
    TabOrder = 1
    OnClick = ScenListClick
  end
  object ScenDescr: TMemo
    Left = 168
    Top = 24
    Width = 209
    Height = 169
    Lines.Strings = (
      'ScenDescr')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object cancelBut: TButton
    Left = 208
    Top = 199
    Width = 80
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 3
  end
end
