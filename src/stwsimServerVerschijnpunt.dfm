object stwssVerschijnpuntForm: TstwssVerschijnpuntForm
  Left = 197
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Verschijn-item bewerken'
  ClientHeight = 296
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 108
    Top = 36
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label3: TLabel
    Left = 8
    Top = 36
    Width = 20
    Height = 13
    Caption = 'Tijd:'
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object Label2: TLabel
    Left = 8
    Top = 60
    Width = 32
    Height = 13
    Caption = 'Plaats:'
  end
  object Label5: TLabel
    Left = 144
    Top = 36
    Width = 43
    Height = 13
    Caption = '(uu : mm)'
  end
  object Label6: TLabel
    Left = 80
    Top = 212
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object Label7: TLabel
    Left = 8
    Top = 212
    Width = 59
    Height = 13
    Caption = 'Verdwijn-eis:'
  end
  object Label8: TLabel
    Left = 200
    Top = 236
    Width = 43
    Height = 13
    Caption = '(minuten)'
  end
  object Label9: TLabel
    Left = 180
    Top = 108
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label10: TLabel
    Left = 80
    Top = 236
    Width = 48
    Height = 13
    Caption = 'Wachttijd:'
  end
  object Label11: TLabel
    Left = 8
    Top = 84
    Width = 43
    Height = 13
    Caption = 'Wagons:'
  end
  object minedit: TEdit
    Left = 112
    Top = 32
    Width = 25
    Height = 21
    TabOrder = 2
    OnChange = uureditChange
  end
  object uuredit: TEdit
    Left = 80
    Top = 32
    Width = 25
    Height = 21
    TabOrder = 1
    OnChange = uureditChange
  end
  object treinnredit: TEdit
    Left = 80
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 0
    OnChange = treinnreditChange
  end
  object plaatsCombo: TComboBox
    Left = 80
    Top = 56
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = plaatsComboChange
  end
  object vdwTreinnrEdit: TEdit
    Left = 152
    Top = 208
    Width = 145
    Height = 21
    TabOrder = 11
  end
  object vdwWachtEdit: TEdit
    Left = 152
    Top = 232
    Width = 41
    Height = 21
    TabOrder = 12
    Text = '0'
  end
  object okbut: TButton
    Left = 232
    Top = 264
    Width = 75
    Height = 25
    Caption = '&Sluiten'
    Default = True
    ModalResult = 1
    TabOrder = 13
  end
  object matList: TListBox
    Left = 80
    Top = 80
    Width = 113
    Height = 121
    ItemHeight = 13
    TabOrder = 4
  end
  object matCombo: TComboBox
    Left = 198
    Top = 80
    Width = 107
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object andersomCheck: TCheckBox
    Left = 200
    Top = 104
    Width = 97
    Height = 17
    Caption = 'Achterstevoren'
    TabOrder = 8
  end
  object matToevBut: TButton
    Left = 230
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Toevoegen'
    TabOrder = 9
    OnClick = matToevButClick
  end
  object matDelBut: TButton
    Left = 230
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Verwijderen'
    TabOrder = 10
    OnClick = matDelButClick
  end
  object hbut: TButton
    Left = 196
    Top = 128
    Width = 21
    Height = 25
    Caption = '^'
    TabOrder = 5
    OnClick = hbutClick
  end
  object lbut: TButton
    Left = 196
    Top = 160
    Width = 21
    Height = 25
    Caption = 'v'
    TabOrder = 6
    OnClick = lbutClick
  end
end
