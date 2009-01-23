object stwssPlanpuntBewerkForm: TstwssPlanpuntBewerkForm
  Left = 240
  Top = 122
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dienstregelingpunt bewerken'
  ClientHeight = 333
  ClientWidth = 344
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
    Top = 12
    Width = 36
    Height = 13
    Caption = 'Station:'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 34
    Height = 13
    Caption = 'Perron:'
  end
  object Label4: TLabel
    Left = 156
    Top = 60
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label5: TLabel
    Left = 156
    Top = 84
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label7: TLabel
    Left = 156
    Top = 108
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label8: TLabel
    Left = 8
    Top = 108
    Width = 103
    Height = 13
    Caption = 'Minimale verblijfsduur:'
  end
  object Label9: TLabel
    Left = 192
    Top = 60
    Width = 43
    Height = 13
    Caption = '(uu : mm)'
  end
  object Label10: TLabel
    Left = 192
    Top = 84
    Width = 43
    Height = 13
    Caption = '(uu : mm)'
  end
  object Label11: TLabel
    Left = 192
    Top = 108
    Width = 41
    Height = 13
    Caption = '(mm : ss)'
  end
  object Label12: TLabel
    Left = 8
    Top = 276
    Width = 93
    Height = 13
    Caption = 'Nieuw treinnummer:'
  end
  object Label13: TLabel
    Left = 8
    Top = 204
    Width = 103
    Height = 13
    Caption = 'Wagons loskoppelen:'
  end
  object Label14: TLabel
    Left = 128
    Top = 204
    Width = 33
    Height = 13
    Caption = 'Aantal:'
  end
  object Label15: TLabel
    Left = 128
    Top = 228
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object stationEdit: TEdit
    Left = 128
    Top = 8
    Width = 137
    Height = 21
    TabOrder = 0
  end
  object perronEdit: TEdit
    Left = 128
    Top = 32
    Width = 33
    Height = 21
    TabOrder = 1
  end
  object aanUurEdit: TEdit
    Left = 128
    Top = 56
    Width = 25
    Height = 21
    TabOrder = 3
  end
  object aanMinEdit: TEdit
    Left = 160
    Top = 56
    Width = 25
    Height = 21
    TabOrder = 4
  end
  object vertrMinEdit: TEdit
    Left = 160
    Top = 80
    Width = 25
    Height = 21
    TabOrder = 7
  end
  object vertrUurEdit: TEdit
    Left = 128
    Top = 80
    Width = 25
    Height = 21
    TabOrder = 6
  end
  object wachtSecEdit: TEdit
    Left = 160
    Top = 104
    Width = 25
    Height = 21
    TabOrder = 9
  end
  object wachtMinEdit: TEdit
    Left = 128
    Top = 104
    Width = 25
    Height = 21
    TabOrder = 8
  end
  object StopCheck: TCheckBox
    Left = 128
    Top = 128
    Width = 105
    Height = 17
    Caption = 'Stop bij dit station'
    TabOrder = 10
    OnClick = StopCheckClick
  end
  object kerenCheck: TCheckBox
    Left = 128
    Top = 176
    Width = 105
    Height = 17
    Caption = 'Kopmaken'
    TabOrder = 12
  end
  object nieuwnrEdit: TEdit
    Left = 128
    Top = 272
    Width = 137
    Height = 21
    TabOrder = 16
  end
  object loskAantalEdit: TEdit
    Left = 200
    Top = 200
    Width = 33
    Height = 21
    TabOrder = 13
  end
  object loskTreinnrEdit: TEdit
    Left = 200
    Top = 224
    Width = 137
    Height = 21
    TabOrder = 14
  end
  object loskKerenCheck: TCheckBox
    Left = 128
    Top = 248
    Width = 169
    Height = 17
    Caption = 'Losgekoppelde wagons keren'
    TabOrder = 15
  end
  object koppelCheck: TCheckBox
    Left = 128
    Top = 152
    Width = 121
    Height = 17
    Caption = 'Koppelen'
    TabOrder = 11
  end
  object okBut: TButton
    Left = 264
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 17
  end
  object cancelBut: TButton
    Left = 184
    Top = 304
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 18
  end
  object aankCheck: TCheckBox
    Left = 8
    Top = 60
    Width = 105
    Height = 17
    Caption = 'Aan-/Doorkomst:'
    TabOrder = 2
    OnClick = aankCheckClick
  end
  object vertrCheck: TCheckBox
    Left = 8
    Top = 84
    Width = 97
    Height = 17
    Caption = 'Vertrek:'
    TabOrder = 5
    OnClick = vertrCheckClick
  end
end
