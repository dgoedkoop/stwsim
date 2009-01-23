object stwscTreinStatusForm: TstwscTreinStatusForm
  Left = 274
  Top = 203
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Treinstatus'
  ClientHeight = 162
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object statusMemo: TMemo
    Left = 8
    Top = 8
    Width = 609
    Height = 113
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object closeBut: TButton
    Left = 544
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Sluiten'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
