object stwssDienstregForm: TstwssDienstregForm
  Left = 205
  Top = 130
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Dienstregeling bewerken'
  ClientHeight = 360
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 73
    Caption = 'Tijden'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 43
      Height = 13
      Caption = 'Begintijd:'
    end
    object Label2: TLabel
      Left = 84
      Top = 24
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label3: TLabel
      Left = 84
      Top = 48
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label5: TLabel
      Left = 8
      Top = 48
      Width = 37
      Height = 13
      Caption = 'Eindtijd:'
    end
    object startUurEdit: TEdit
      Left = 56
      Top = 20
      Width = 25
      Height = 21
      TabOrder = 0
      OnChange = startUurEditChange
    end
    object startMinEdit: TEdit
      Left = 88
      Top = 20
      Width = 25
      Height = 21
      TabOrder = 1
      OnChange = startUurEditChange
    end
    object stopMinEdit: TEdit
      Left = 88
      Top = 44
      Width = 25
      Height = 21
      TabOrder = 3
      OnChange = stopUurEditChange
    end
    object stopUurEdit: TEdit
      Left = 56
      Top = 44
      Width = 25
      Height = 21
      TabOrder = 2
      OnChange = stopUurEditChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 88
    Width = 169
    Height = 233
    Caption = 'Materieel'
    TabOrder = 1
    object matLoadBut: TButton
      Left = 8
      Top = 200
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Laden...'
      TabOrder = 1
      OnClick = matLoadButClick
    end
    object matDelBut: TButton
      Left = 88
      Top = 200
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Verwijderen'
      TabOrder = 2
      OnClick = matDelButClick
    end
    object matList: TListBox
      Left = 8
      Top = 16
      Width = 153
      Height = 177
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 184
    Top = 8
    Width = 225
    Height = 313
    Caption = 'Treinen'
    TabOrder = 2
    object newTreinBut: TButton
      Left = 120
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Nieuwe trein...'
      TabOrder = 1
      OnClick = newTreinButClick
    end
    object editTreinBut: TButton
      Left = 120
      Top = 80
      Width = 97
      Height = 25
      Caption = 'Trein bewerken...'
      TabOrder = 3
      OnClick = editTreinButClick
    end
    object delTreinBut: TButton
      Left = 120
      Top = 112
      Width = 97
      Height = 25
      Caption = 'Trein verwijderen'
      TabOrder = 4
      OnClick = delTreinButClick
    end
    object treinList: TListBox
      Left = 8
      Top = 16
      Width = 105
      Height = 289
      ItemHeight = 13
      TabOrder = 0
    end
    object copyTreinBut: TButton
      Left = 120
      Top = 144
      Width = 97
      Height = 25
      Caption = 'Trein kopiëren...'
      TabOrder = 5
      OnClick = copyTreinButClick
    end
    object treinNrBut: TButton
      Left = 120
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Treinnr wijzigen...'
      TabOrder = 2
      OnClick = treinNrButClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 416
    Top = 8
    Width = 345
    Height = 313
    Caption = 'Verschijnen van treinen'
    TabOrder = 3
    object nieuwVerschijnBut: TButton
      Left = 240
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Nieuw item...'
      TabOrder = 1
      OnClick = nieuwVerschijnButClick
    end
    object editVerschijnBut: TButton
      Left = 240
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Item bewerken...'
      TabOrder = 2
      OnClick = editVerschijnButClick
    end
    object delVerschijnBut: TButton
      Left = 240
      Top = 80
      Width = 97
      Height = 25
      Caption = 'Item verwijderen'
      TabOrder = 3
      OnClick = delVerschijnButClick
    end
    object verschijnList: TListBox
      Left = 8
      Top = 16
      Width = 225
      Height = 289
      ItemHeight = 13
      TabOrder = 0
    end
    object copyVerschijnBut: TButton
      Left = 240
      Top = 112
      Width = 97
      Height = 25
      Caption = 'Item kopiëren...'
      TabOrder = 4
      OnClick = copyVerschijnButClick
    end
  end
  object okBut: TButton
    Left = 688
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Sluiten'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
end
