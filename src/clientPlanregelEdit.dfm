object stwscPlanregelEditForm: TstwscPlanregelEditForm
  Left = 620
  Top = 154
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Planregel bewerken'
  ClientHeight = 264
  ClientWidth = 368
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
    Left = 16
    Top = 12
    Width = 64
    Height = 13
    Caption = 'Treinnummer:'
  end
  object Label2: TLabel
    Left = 208
    Top = 12
    Width = 43
    Height = 13
    Caption = 'Activiteit:'
  end
  object Label4: TLabel
    Left = 16
    Top = 36
    Width = 51
    Height = 13
    Caption = 'Van spoor:'
  end
  object Label5: TLabel
    Left = 208
    Top = 36
    Width = 55
    Height = 13
    Caption = 'Naar spoor:'
  end
  object Label3: TLabel
    Left = 16
    Top = 60
    Width = 37
    Height = 13
    Caption = 'Dwang:'
  end
  object Label6: TLabel
    Left = 16
    Top = 132
    Width = 41
    Height = 13
    Caption = 'Insteltijd:'
  end
  object Label7: TLabel
    Left = 146
    Top = 132
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label8: TLabel
    Left = 16
    Top = 156
    Width = 73
    Height = 13
    Caption = 'Nieuw nummer:'
  end
  object Label9: TLabel
    Left = 16
    Top = 180
    Width = 178
    Height = 13
    Caption = 'Nummer voor achterblijvend treindeel:'
  end
  object Label10: TLabel
    Left = 16
    Top = 204
    Width = 162
    Height = 13
    Caption = 'Combineren met trein met nummer:'
  end
  object treinnrEdit: TEdit
    Left = 112
    Top = 8
    Width = 89
    Height = 21
    TabOrder = 0
  end
  object rozCheck: TCheckBox
    Left = 112
    Top = 80
    Width = 97
    Height = 17
    Caption = 'Rijden op Zicht'
    TabOrder = 5
  end
  object vanEdit: TEdit
    Left = 112
    Top = 32
    Width = 89
    Height = 21
    TabOrder = 2
    OnChange = vanEditChange
  end
  object naarEdit: TEdit
    Left = 272
    Top = 32
    Width = 89
    Height = 21
    TabOrder = 3
    OnChange = naarEditChange
  end
  object dwangBox: TComboBox
    Left = 112
    Top = 56
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object actBox: TComboBox
    Left = 272
    Top = 8
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Doorkomst'
      'Vertrek'
      'Aankomst'
      'Korte stop'
      'Rangeren'
      '0')
  end
  object instelUurEdit: TEdit
    Left = 112
    Top = 128
    Width = 33
    Height = 21
    TabOrder = 6
  end
  object instelMinEdit: TEdit
    Left = 152
    Top = 128
    Width = 33
    Height = 21
    TabOrder = 7
  end
  object nieuwNrEdit: TEdit
    Left = 200
    Top = 152
    Width = 89
    Height = 21
    TabOrder = 8
  end
  object RestNrEdit: TEdit
    Left = 200
    Top = 176
    Width = 89
    Height = 21
    TabOrder = 9
  end
  object Button1: TButton
    Left = 288
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Opslaan'
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object CancelBut: TButton
    Left = 208
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuleren'
    ModalResult = 2
    TabOrder = 11
  end
  object HCheck: TCheckBox
    Left = 112
    Top = 104
    Width = 97
    Height = 17
    Caption = 'H-criterium'
    TabOrder = 12
  end
  object CombineerNrEdit: TEdit
    Left = 200
    Top = 200
    Width = 89
    Height = 21
    TabOrder = 13
  end
end
