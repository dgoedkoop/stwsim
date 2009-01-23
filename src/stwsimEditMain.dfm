object stwseMain: TstwseMain
  Left = 22
  Top = 173
  Width = 1002
  Height = 547
  Caption = 'StwSim Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 261
    Width = 994
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object SchermenTab: TTabControl
    Left = 0
    Top = 0
    Width = 994
    Height = 261
    Align = alClient
    TabOrder = 0
    OnChange = SchermenTabChange
  end
  object bottomPanel: TPanel
    Left = 0
    Top = 264
    Width = 994
    Height = 237
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object editPC: TPageControl
      Left = 0
      Top = 0
      Width = 825
      Height = 237
      ActivePage = algTab
      Align = alClient
      Constraints.MinHeight = 193
      TabOrder = 0
      OnChange = editPCChange
      object algTab: TTabSheet
        Caption = 'Infrastructuur'
        ImageIndex = 5
        object infraStatus: TLabel
          Left = 8
          Top = 8
          Width = 50
          Height = 13
          Caption = 'infraStatus'
        end
        object InfraOpenBut: TButton
          Left = 8
          Top = 32
          Width = 121
          Height = 25
          Caption = 'Infrastructuur laden...'
          TabOrder = 0
          OnClick = InfraOpenButClick
        end
      end
      object mtab: TTabSheet
        Caption = 'Treindetectie en seinen'
        object mgroup: TGroupBox
          Left = 0
          Top = 0
          Width = 265
          Height = 209
          Caption = 'Treindetectiepunten'
          TabOrder = 0
          object mdBut: TButton
            Left = 182
            Top = 72
            Width = 75
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 0
            OnClick = mdButClick
          end
          object mtBut: TButton
            Left = 182
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 1
            OnClick = mtButClick
          end
          object mEdit: TEdit
            Left = 136
            Top = 16
            Width = 121
            Height = 21
            TabOrder = 2
          end
          object mList: TListBox
            Left = 8
            Top = 16
            Width = 121
            Height = 185
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 3
          end
        end
        object Rijrichtingsvelden: TGroupBox
          Left = 272
          Top = 0
          Width = 265
          Height = 209
          Caption = 'Rijrichtingsvelden'
          TabOrder = 1
          object edBut: TButton
            Left = 182
            Top = 72
            Width = 75
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 0
            OnClick = edButClick
          end
          object etBut: TButton
            Left = 182
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 1
            OnClick = etButClick
          end
          object eEdit: TEdit
            Left = 136
            Top = 16
            Width = 121
            Height = 21
            TabOrder = 2
          end
          object eList: TListBox
            Left = 8
            Top = 16
            Width = 121
            Height = 185
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 3
          end
        end
        object sGroup: TGroupBox
          Left = 544
          Top = 0
          Width = 273
          Height = 209
          Caption = 'Bediende seinen'
          TabOrder = 2
          object sEdit: TEdit
            Left = 136
            Top = 16
            Width = 121
            Height = 21
            TabOrder = 0
          end
          object stBut: TButton
            Left = 182
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 1
            OnClick = stButClick
          end
          object sdBut: TButton
            Left = 182
            Top = 72
            Width = 75
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 2
            OnClick = sdButClick
          end
          object sList: TListBox
            Left = 8
            Top = 16
            Width = 121
            Height = 185
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 3
          end
        end
      end
      object wTab: TTabSheet
        Caption = 'Wissels'
        ImageIndex = 2
        object Label3: TLabel
          Left = 200
          Top = 12
          Width = 14
          Height = 13
          Caption = 'ID:'
        end
        object Label4: TLabel
          Left = 200
          Top = 60
          Width = 89
          Height = 13
          Caption = 'Treindetectie-punt:'
        end
        object Label28: TLabel
          Left = 200
          Top = 36
          Width = 61
          Height = 13
          Caption = 'Wisselgroep:'
        end
        object wdBut: TButton
          Left = 344
          Top = 120
          Width = 75
          Height = 25
          Caption = 'Verwijderen'
          TabOrder = 0
          OnClick = wdButClick
        end
        object wtBut: TButton
          Left = 344
          Top = 88
          Width = 75
          Height = 25
          Caption = 'Toevoegen'
          Default = True
          TabOrder = 1
          OnClick = wtButClick
        end
        object wnEdit: TEdit
          Left = 296
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 2
          OnChange = wnEditChange
        end
        object wList: TListBox
          Left = 8
          Top = 8
          Width = 185
          Height = 197
          Anchors = [akLeft, akTop, akBottom]
          ItemHeight = 13
          TabOrder = 3
        end
        object wmBox: TComboBox
          Left = 296
          Top = 56
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
        end
        object wgBox: TComboBox
          Left = 296
          Top = 32
          Width = 121
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Items.Strings = (
            '')
        end
        object basisRechtdoor: TCheckBox
          Left = 424
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Basisstand is rechtdoor'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
      end
      object ovTab: TTabSheet
        Caption = 'Overwegen'
        ImageIndex = 1
        object ovmgroep: TGroupBox
          Left = 272
          Top = 0
          Width = 265
          Height = 209
          Caption = 'Treindetectiepunten van geselecteerde overweg:'
          TabOrder = 0
          object Label33: TLabel
            Left = 8
            Top = 40
            Width = 65
            Height = 13
            Caption = 'Overweg zelf:'
          end
          object Label34: TLabel
            Left = 136
            Top = 40
            Width = 68
            Height = 13
            Caption = 'Aankondiging:'
          end
          object movdbut: TButton
            Left = 8
            Top = 88
            Width = 121
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 0
            OnClick = movdbutClick
          end
          object movtbut: TButton
            Left = 8
            Top = 56
            Width = 121
            Height = 25
            Caption = 'Toevoegen'
            TabOrder = 1
            OnClick = movtbutClick
          end
          object ovmList: TListBox
            Left = 8
            Top = 120
            Width = 121
            Height = 81
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 2
          end
          object mOvBox: TComboBox
            Left = 72
            Top = 16
            Width = 121
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 3
          end
          object ovmaDBut: TButton
            Left = 136
            Top = 88
            Width = 121
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 4
            OnClick = ovmaDButClick
          end
          object ovmaTBut: TButton
            Left = 136
            Top = 56
            Width = 121
            Height = 25
            Caption = 'Toevoegen'
            TabOrder = 5
            OnClick = ovmaTButClick
          end
          object ovmaList: TListBox
            Left = 136
            Top = 120
            Width = 121
            Height = 81
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 6
          end
        end
        object ovGroup: TGroupBox
          Left = 0
          Top = 0
          Width = 265
          Height = 209
          Caption = 'Overwegen:'
          TabOrder = 1
          object ovList: TListBox
            Left = 8
            Top = 16
            Width = 121
            Height = 185
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
            OnClick = ovListClick
          end
          object ovdbut: TButton
            Left = 182
            Top = 72
            Width = 75
            Height = 25
            Caption = 'Verwijderen'
            TabOrder = 1
            OnClick = ovdbutClick
          end
          object ovtbut: TButton
            Left = 182
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 2
            OnClick = ovtbutClick
          end
          object ovEdit: TEdit
            Left = 136
            Top = 16
            Width = 121
            Height = 21
            TabOrder = 3
            OnChange = wnEditChange
          end
        end
      end
      object gplTab: TTabSheet
        Caption = 'Schermen'
        ImageIndex = 3
        object tsBut: TButton
          Left = 136
          Top = 8
          Width = 81
          Height = 25
          Caption = 'Nieuw scherm'
          Default = True
          TabOrder = 0
          OnClick = tsButClick
        end
        object nsEdit: TEdit
          Left = 8
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object dsBut: TButton
          Left = 8
          Top = 40
          Width = 81
          Height = 25
          Caption = 'Scherm wissen'
          Enabled = False
          TabOrder = 2
        end
        object nsBut: TButton
          Left = 224
          Top = 8
          Width = 81
          Height = 25
          Caption = 'Naam wijzigen'
          TabOrder = 3
          OnClick = nsButClick
        end
        object tsLast: TCheckBox
          Left = 136
          Top = 40
          Width = 81
          Height = 17
          Caption = 'Achteraan'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object GroupBox1: TGroupBox
          Left = 136
          Top = 72
          Width = 153
          Height = 65
          Caption = 'Soort scherm:'
          TabOrder = 5
          object detailsOff: TRadioButton
            Left = 8
            Top = 40
            Width = 113
            Height = 17
            Caption = 'Overzichtscherm'
            TabOrder = 0
            OnClick = detailsOffClick
          end
          object detailsOn: TRadioButton
            Left = 8
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Detailscherm'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = detailsOnClick
          end
        end
      end
      object reTab: TTabSheet
        Caption = 'Elementen plaatsen'
        ImageIndex = 4
        object knoppenPanel: TPanel
          Left = 0
          Top = 0
          Width = 841
          Height = 233
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clSilver
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object SpeedButton12: TSpeedButton
            Left = 240
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Perron'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000830B0000830B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton12Click
          end
          object SpeedButton11: TSpeedButton
            Left = 416
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Vakje wissen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
              0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
              0000000000FFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF000000C0FFFFC0FFFFC0FFFFC0FFFFC0FFFFC0FFFFFFFFFFFFFFFFFFFF
              FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000C0FFFFC0FFFFC0
              FFFFC0FFFFC0FFFFC0FFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF000000C0FFFFC0FFFFC0FFFFC0FFFFC0FFFFC0FFFFFFFF
              FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000C0
              FFFFC0FFFFC0FFFFC0FFFFC0FFFFC0FFFF000000FF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000000000
              00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton11Click
          end
          object SpeedButton1: TSpeedButton
            Left = 144
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton1Click
          end
          object SpeedButton2: TSpeedButton
            Left = 192
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000830B0000830B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFF000000
              000000909090909090909090909090000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton2Click
          end
          object SpeedButton3: TSpeedButton
            Left = 216
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton3Click
          end
          object SpeedButton4: TSpeedButton
            Left = 240
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton4Click
          end
          object SpeedButton5: TSpeedButton
            Left = 264
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton5Click
          end
          object SpeedButton6: TSpeedButton
            Left = 288
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton6Click
          end
          object SpeedButton10: TSpeedButton
            Left = 288
            Top = 80
            Width = 23
            Height = 22
            Hint = 'Wissel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000B30B0000B30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton10Click
          end
          object SpeedButton9: TSpeedButton
            Left = 264
            Top = 80
            Width = 23
            Height = 22
            Hint = 'Wissel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000A30B0000A30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton9Click
          end
          object SpeedButton8: TSpeedButton
            Left = 240
            Top = 80
            Width = 23
            Height = 22
            Hint = 'Wissel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton8Click
          end
          object SpeedButton7: TSpeedButton
            Left = 216
            Top = 80
            Width = 23
            Height = 22
            Hint = 'Wissel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton7Click
          end
          object SpeedButton16: TSpeedButton
            Left = 264
            Top = 128
            Width = 23
            Height = 22
            Hint = 'Sein'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              26040000424D2604000000000000360000002800000012000000120000000100
              180000000000F0030000130B0000130B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF0000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000FFFFFF0000FFFFFF00000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000FFFFFF
              0000FFFFFF000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000FFFFFF0000FFFFFF0000000000000000FF0000
              FF0000FF0000FF0000000000000000000000000000000000FF0000FF00000000
              0000000000FFFFFF0000FFFFFF0000000000FF0000FF0000FF0000FF0000FF00
              00FF0000000000000000000000000000FF0000FF000000000000000000FFFFFF
              0000FFFFFF0000FF0000FF0000FF0000000000000000FF0000FF0000FF000000
              0000000000000000FF0000FF000000000000000000FFFFFF0000FFFFFF0000FF
              0000FF0000000000000000000000000000FF0000FF0000FF0000FF0000FF0000
              FF0000FF000000000000000000FFFFFF0000FFFFFF0000FF0000FF0000000000
              000000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF00000000
              0000000000FFFFFF0000FFFFFF0000FF0000FF0000FF0000000000000000FF00
              00FF0000FF0000000000000000000000FF0000FF000000000000000000FFFFFF
              0000FFFFFF0000000000FF0000FF0000FF0000FF0000FF0000FF000000000000
              0000000000000000FF0000FF000000000000000000FFFFFF0000FFFFFF000000
              0000000000FF0000FF0000FF0000FF0000000000000000000000000000000000
              FF0000FF000000000000000000FFFFFF0000FFFFFF0000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000FFFFFF0000FFFFFF00000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000FFFFFF
              0000FFFFFF000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton16Click
          end
          object SpeedButton15: TSpeedButton
            Left = 288
            Top = 128
            Width = 23
            Height = 22
            Hint = 'Sein'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              26040000424D2604000000000000360000002800000012000000120000000100
              180000000000F0030000130B0000130B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF0000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000FFFFFF0000FFFFFF00000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000FFFFFF
              0000FFFFFF000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000FFFFFF0000FFFFFF0000000000000000000000
              FF0000FF0000000000000000000000000000000000FF0000FF0000FF0000FF00
              0000000000FFFFFF0000FFFFFF0000000000000000000000FF0000FF00000000
              00000000000000000000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF
              0000FFFFFF0000000000000000000000FF0000FF0000000000000000000000FF
              0000FF0000FF0000000000000000FF0000FF0000FFFFFFFF0000FFFFFF000000
              0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000
              000000000000000000FF0000FFFFFFFF0000FFFFFF0000000000000000000000
              FF0000FF0000FF0000FF0000FF0000FF0000FF00000000000000000000000000
              00FF0000FFFFFFFF0000FFFFFF0000000000000000000000FF0000FF00000000
              00000000000000FF0000FF0000FF0000000000000000FF0000FF0000FFFFFFFF
              0000FFFFFF0000000000000000000000FF0000FF000000000000000000000000
              0000FF0000FF0000FF0000FF0000FF0000FF000000FFFFFF0000FFFFFF000000
              0000000000000000FF0000FF0000000000000000000000000000000000FF0000
              FF0000FF0000FF000000000000FFFFFF0000FFFFFF0000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000FFFFFF0000FFFFFF00000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000FFFFFF
              0000FFFFFF000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              0000000000000000000000000000000000000000000000000000000000000000
              00000000000000000000000000FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton15Click
          end
          object SpeedButton17: TSpeedButton
            Left = 288
            Top = 152
            Width = 23
            Height = 22
            Hint = 'Tekst'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000130B0000130B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00000000FFFF00FFFF00FFFF00FFFF000000000000FFFFFF0000FFFFFF000000
              00000000000000FFFF00FFFF000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton17Click
          end
          object Label1: TLabel
            Left = 312
            Top = 40
            Width = 89
            Height = 13
            Caption = 'Treindetectie-punt:'
          end
          object Label2: TLabel
            Left = 8
            Top = 84
            Width = 34
            Height = 13
            Caption = 'Wissel:'
          end
          object Label5: TLabel
            Left = 8
            Top = 132
            Width = 24
            Height = 13
            Caption = 'Sein:'
          end
          object Label6: TLabel
            Left = 8
            Top = 156
            Width = 30
            Height = 13
            Caption = 'Tekst:'
          end
          object Label11: TLabel
            Left = 8
            Top = 36
            Width = 26
            Height = 13
            Caption = 'Rails:'
          end
          object SpeedButton18: TSpeedButton
            Left = 288
            Top = 176
            Width = 23
            Height = 22
            Hint = 'Tekst'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000130B0000130B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00FFFF00FFFF00000000000000FFFF00FFFF000000FFFFFF0000FFFFFF000000
              00000000FFFF00FFFF00FFFF00FFFF000000000000FFFFFF0000FFFFFF000000
              00000000000000FFFF00FFFF000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton18Click
          end
          object Label12: TLabel
            Left = 8
            Top = 180
            Width = 64
            Height = 13
            Caption = 'Treinnummer:'
          end
          object Label13: TLabel
            Left = 568
            Top = 180
            Width = 36
            Height = 13
            Caption = 'Lengte:'
          end
          object Label14: TLabel
            Left = 312
            Top = 180
            Width = 89
            Height = 13
            Caption = 'Treindetectie-punt:'
          end
          object SpeedButton19: TSpeedButton
            Left = 192
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000094949400000000000000000000000000000000000094
              9494949494000000000000000000000000000000000000949494949494949494
              0000000000000000000000009494949494949494949494940000000000000000
              0000000094949494949494949494949494949400000000000094949494949494
              9494949494949494949494000000000000949494949494949494000000949494
              9494949494949494949494949494940000000000009494949494949494949494
              9494949494949400000000000000000094949494949494949494949400000000
              0000000000000000949494949494949494949494000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton19Click
          end
          object SpeedButton20: TSpeedButton
            Left = 168
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              9494949494949494949494940000000000000000000000009494949494949494
              9494949400000000000000000094949494949494949494949494949494949400
              0000000000949494949494949494949494949494949494000000949494949494
              9494940000000000009494949494949494949494949494949494940000000000
              0094949494949494949494949494949400000000000000000000000094949494
              9494949494949494000000000000000000000000949494949494949494000000
              0000000000000000000000000000009494949494940000000000000000000000
              0000000000000094949400000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton20Click
          end
          object SpeedButton21: TSpeedButton
            Left = 144
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              9494949494949494940000000000000000000000000000009494949494949494
              9400000000000000000000000094949494949494949400000000000000000000
              0000000000949494949494949494000000000000000000000000949494949494
              9494940000000000000000000000000000009494949494949494940000000000
              0000000000000000000094949494949400000000000000000000000000000000
              0000949494949494000000000000000000000000000000000000949494949494
              0000000000000000000000000000000000009494949494940000000000000000
              0000000000000000000094949494949494949400000000000000000000000000
              0000949494949494949494000000000000000000000000000000000000949494
              9494949494940000000000000000000000000000009494949494949494940000
              0000000000000000000000000000000094949494949494949400000000000000
              0000000000000000949494949494949494000000000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton21Click
          end
          object SpeedButton22: TSpeedButton
            Left = 120
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              0000009494949494949494940000000000000000000000000000009494949494
              9494949494949400000000000000000000000000000094949494949494949400
              0000000000000000000000000000949494949494949494949494000000000000
              0000000000000000009494949494949494940000000000000000000000000000
              0094949494949494949400000000000000000000000000000000000094949494
              9494000000000000000000000000000000000000949494949494000000000000
              0000000000000000000000009494949494940000000000000000000000000000
              0000000094949494949400000000000000000000000000000094949494949494
              9494000000000000000000000000000000949494949494949494000000000000
              0000000000009494949494949494940000000000000000000000000000009494
              9494949494949400000000000000000000000094949494949494949400000000
              0000000000000000000000949494949494949494000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton22Click
          end
          object Label15: TLabel
            Left = 312
            Top = 84
            Width = 34
            Height = 13
            Caption = 'Wissel:'
          end
          object Label16: TLabel
            Left = 312
            Top = 132
            Width = 24
            Height = 13
            Caption = 'Sein:'
          end
          object Label17: TLabel
            Left = 312
            Top = 156
            Width = 30
            Height = 13
            Caption = 'Tekst:'
          end
          object drawNiks: TSpeedButton
            Left = 392
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Niets doen'
            GroupIndex = 1
            Down = True
            Caption = 'X'
            Flat = True
            ParentShowHint = False
            ShowHint = True
            OnClick = drawNiksClick
          end
          object SpeedButton26: TSpeedButton
            Left = 216
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton26Click
          end
          object SpeedButton27: TSpeedButton
            Left = 240
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000930B0000930B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton27Click
          end
          object SpeedButton28: TSpeedButton
            Left = 264
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000A30B0000A30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF949494
              949494949494000000000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              949494949494949494000000000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFF000000
              000000949494949494949494000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton28Click
          end
          object SpeedButton29: TSpeedButton
            Left = 288
            Top = 56
            Width = 23
            Height = 22
            Hint = 'Kruisende sporen'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000B30B0000B30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000949494949494949494000000000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000949494949494949494000000FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF949494
              949494949494949494949494949494949494949494FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton29Click
          end
          object Label22: TLabel
            Left = 8
            Top = 60
            Width = 71
            Height = 13
            Caption = 'Kruisende rails:'
          end
          object Label23: TLabel
            Left = 8
            Top = 12
            Width = 49
            Height = 13
            Caption = 'Decoratie:'
          end
          object Label24: TLabel
            Left = 312
            Top = 12
            Width = 65
            Height = 13
            Caption = 'Overige tools:'
          end
          object SpeedButton31: TSpeedButton
            Left = 216
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Kader voor brug/tunnel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000909090909090909090909090909090909090909090909090909090909090
              9090909090909090909090909090909090900000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton31Click
          end
          object SpeedButton34: TSpeedButton
            Left = 192
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Kader voor brug/tunnel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000830B0000830B00000000000000000000000000000000
              0000009090909090900000000000000000000000000000000000009090909090
              9000000000000000000000000000000000000090909090909000000000000000
              0000000000000000000000909090909090000000000000000000000000000000
              0000009090909090900000000000000000000000000000000000009090909090
              9000000000000000000000000000000000000090909090909000000000000000
              0000000000000000000000909090909090000000000000000000000000000000
              0000009090909090900000000000000000000000000000000000009090909090
              9000000000000000000000000000000000000090909090909000000000000000
              0000000000000000000000909090909090000000000000000000000000000000
              0000009090909090900000000000000000000000000000000000009090909090
              9000000000000000000000000000000000000090909090909000000000000000
              0000000000000000000000909090909090000000000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton34Click
          end
          object SpeedButton36: TSpeedButton
            Left = 120
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor (zonder detectie)'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              B6010000424DB601000000000000360000002800000008000000100000000100
              18000000000080010000930B0000930B00000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000009090909090900000000000009090
              9090909000000000000090909090909000000000000090909090909000000000
              0000909090909090000000000000909090909090000000000000909090909090
              0000000000009090909090900000000000009090909090900000000000009090
              9090909000000000000090909090909000000000000090909090909000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton36Click
          end
          object Label25: TLabel
            Left = 8
            Top = 108
            Width = 74
            Height = 13
            Caption = 'Rijrichtingsveld:'
          end
          object SpeedButton38: TSpeedButton
            Left = 264
            Top = 104
            Width = 23
            Height = 22
            Hint = 'Rijrichtingsveld'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              02050000424D020500000000000036040000280000000A000000110000000100
              080000000000CC000000D30B0000D30B000000010000000100000000000042C6
              4200FF848400949494000000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00060606060606
              0606060600000600000000000000030600000600000000000003030600000600
              0000000003030306000006000000000303030306000006000000030303030306
              0000060000030303000303060000060003030300000303060000060303030000
              0003030600000603030300000003030600000600030303000003030600000600
              0003030300030306000006000000030303030306000006000000000303030306
              0000060000000000030303060000060000000000000303060000060000000000
              000003060000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton38Click
          end
          object SpeedButton39: TSpeedButton
            Left = 288
            Top = 104
            Width = 23
            Height = 22
            Hint = 'Rijrichtingsveld'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              02050000424D020500000000000036040000280000000A000000110000000100
              080000000000CC000000D30B0000D30B000000010000000100000000000042C6
              4200FF848400949494000000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00060606060606
              0606060600000603000000000000000600000603030000000000000600000603
              0303000000000006000006030303030000000006000006030303030300000006
              0000060303000303030000060000060303000003030300060000060303000000
              0303030600000603030000000303030600000603030000030303000600000603
              0300030303000006000006030303030300000006000006030303030000000006
              0000060303030000000000060000060303000000000000060000060300000000
              000000060000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton39Click
          end
          object Label26: TLabel
            Left = 312
            Top = 108
            Width = 74
            Height = 13
            Caption = 'Rijrichtingsveld:'
          end
          object SpeedButton40: TSpeedButton
            Left = 264
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Perron'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000C30B0000C30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton40Click
          end
          object SpeedButton41: TSpeedButton
            Left = 288
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Perron'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              76020000424D760200000000000036000000280000000A000000120000000100
              18000000000040020000C30B0000C30B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF909090
              909090909090909090909090909090909090909090FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFF000000
              000000000000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton41Click
          end
          object SpeedButton13: TSpeedButton
            Left = 168
            Top = 32
            Width = 23
            Height = 22
            Hint = 'Spoor'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              F6040000424DF60400000000000036040000280000000A000000100000000100
              080000000000C0000000F30B0000F30B000000010000000100000000000042C6
              4200FF848400949494000000FF000084FF0000FFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00070000000505
              0000000700000700000005050000000700000700000005050000000700000700
              0000050500000007000007000000050500000007000007000000050500000007
              0000070303030505030303070000070303030505030303070000070303030505
              0303030700000703030305050303030700000700000005050000000700000700
              0000050500000007000007000000050500000007000007000000050500000007
              0000070000000505000000070000070000000505000000070000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton13Click
          end
          object SpeedButton14: TSpeedButton
            Left = 168
            Top = 8
            Width = 23
            Height = 22
            Hint = 'Kader voor brug/tunnel'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              F6040000424DF60400000000000036040000280000000A000000100000000100
              080000000000C0000000E30B0000E30B000000010000000100000000000042C6
              4200FF848400949494000000FF000084FF0000FFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00070000000505
              0000000700000700000005050000000700000700000005050000000700000700
              0000050500000007000007000000050500000007000007000000050500000007
              0000070000000505000000070000070000000505000000070000070000000505
              0000000700000700000005050000000700000700000005050000000700000700
              0000050500000007000007000000050500000007000007000000050500000007
              0000070000000505000000070000070000000505000000070000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton14Click
          end
          object SpeedButton42: TSpeedButton
            Left = 240
            Top = 128
            Width = 23
            Height = 22
            Hint = 'Sein'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              0E050000424D0E0500000000000036040000280000000A000000120000000100
              080000000000D8000000030C0000030C000000010000000100000000000042C6
              4200FF848400949494000000FF000084FF0000FFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00070707070707
              0707070700000700000000000000000700000701000000000000000700000701
              0100000000000007000007010101000000000007000007010101010000000007
              0000070101010101000000070000070101010101010101070000070101010101
              0101010700000701010101010101010700000701010101010101010700000701
              0101010100000007000007010101010000000007000007010101000000000007
              0000070101000000000000070000070100000000000000070000070000000000
              000000070000070707070707070707070000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton42Click
          end
          object SpeedButton43: TSpeedButton
            Left = 216
            Top = 128
            Width = 23
            Height = 22
            Hint = 'Sein'
            GroupIndex = 1
            Flat = True
            Glyph.Data = {
              0E050000424D0E0500000000000036040000280000000A000000120000000100
              080000000000D8000000030C0000030C000000010000000100000000000042C6
              4200FF848400949494000000FF000084FF0000FFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00070707070707
              0707070700000700000000000000000700000700000000000000010700000700
              0000000000010107000007000000000001010107000007000000000101010107
              0000070000000101010101070000070101010101010101070000070101010101
              0101010700000701010101010101010700000701010101010101010700000700
              0000010101010107000007000000000101010107000007000000000001010107
              0000070000000000000101070000070000000000000001070000070000000000
              000000070000070707070707070707070000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton43Click
          end
          object mElBox: TComboBox
            Left = 408
            Top = 36
            Width = 145
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 0
            OnChange = mElBoxChange
          end
          object elCheck: TCheckBox
            Left = 408
            Top = 60
            Width = 113
            Height = 17
            Caption = 'Ge�lektrificeerd'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object wElBox: TComboBox
            Left = 408
            Top = 80
            Width = 145
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 2
            OnChange = wElBoxChange
          end
          object sElBox: TComboBox
            Left = 408
            Top = 128
            Width = 145
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 3
            OnChange = sElBoxChange
          end
          object txTxt: TEdit
            Left = 408
            Top = 152
            Width = 145
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object lenEdit: TSpinEdit
            Left = 616
            Top = 176
            Width = 97
            Height = 22
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxValue = 0
            MinValue = 0
            ParentFont = False
            TabOrder = 5
            Value = 5
          end
          object mTnBox: TComboBox
            Left = 408
            Top = 176
            Width = 145
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 6
            OnChange = mTnBoxChange
          end
          object eElBox: TComboBox
            Left = 408
            Top = 104
            Width = 145
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 7
            OnChange = eElBoxChange
          end
          object Panel1: TPanel
            Left = 568
            Top = 96
            Width = 65
            Height = 41
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 8
            object eDownBut: TRadioButton
              Left = 0
              Top = 0
              Width = 65
              Height = 17
              Caption = 'Down'
              TabOrder = 0
            end
            object eUpBut: TRadioButton
              Left = 0
              Top = 24
              Width = 65
              Height = 17
              Caption = 'Up'
              Checked = True
              TabOrder = 1
              TabStop = True
            end
          end
          object textBox: TGroupBox
            Left = 656
            Top = 32
            Width = 145
            Height = 137
            Caption = 'Opties voor tekst:'
            TabOrder = 9
            object Label7: TLabel
              Left = 8
              Top = 92
              Width = 27
              Height = 13
              Caption = 'Kleur:'
            end
            object txNormal: TRadioButton
              Left = 8
              Top = 16
              Width = 129
              Height = 17
              Caption = 'Normaal'
              Checked = True
              TabOrder = 0
              TabStop = True
            end
            object txSpoornummer: TRadioButton
              Left = 8
              Top = 40
              Width = 129
              Height = 17
              Caption = 'Spoornummer'
              TabOrder = 1
            end
            object txSeinWisselNr: TRadioButton
              Left = 8
              Top = 64
              Width = 129
              Height = 17
              Caption = 'Sein- of wisselnummer'
              TabOrder = 2
            end
            object txKleur: TComboBox
              Left = 8
              Top = 108
              Width = 121
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 3
              Items.Strings = (
                'Zwart'
                'Donkerblauw'
                'Donkergroen'
                'Cyaan'
                'Donkerrood'
                'Donkerpaars'
                'Bruin'
                'Wit'
                'Grijs'
                'Blauw'
                'Lichtgroen'
                'Lichtcyaan'
                'Rood'
                'Paars'
                'Geel'
                'Felwit')
            end
          end
        end
      end
      object rijwegTab: TTabSheet
        Caption = 'Rijwegen'
        ImageIndex = 6
        object rijwegbox: TGroupBox
          Left = 0
          Top = 0
          Width = 193
          Height = 209
          Anchors = [akLeft, akTop, akBottom]
          Caption = 'Rijwegen'
          TabOrder = 0
          object rList: TListBox
            Left = 8
            Top = 16
            Width = 177
            Height = 153
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
            OnClick = rListClick
          end
          object rtBut: TButton
            Left = 8
            Top = 176
            Width = 75
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 1
            OnClick = rtButClick
          end
          object rdBut: TButton
            Left = 88
            Top = 176
            Width = 75
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Verwijderen'
            TabOrder = 2
            OnClick = rdButClick
          end
        end
        object rijwegeditbox: TGroupBox
          Left = 200
          Top = 0
          Width = 617
          Height = 209
          Anchors = [akLeft, akTop, akBottom]
          Caption = 'Rijweg bewerken'
          TabOrder = 1
          object Label18: TLabel
            Left = 8
            Top = 16
            Width = 154
            Height = 13
            Caption = 'Geselecteerde rijweg bestaat uit:'
          end
          object Label19: TLabel
            Left = 248
            Top = 20
            Width = 22
            Height = 13
            Caption = 'Van:'
          end
          object Label20: TLabel
            Left = 248
            Top = 44
            Width = 26
            Height = 13
            Caption = 'Naar:'
          end
          object rijwegVanWijzig: TSpeedButton
            Left = 392
            Top = 16
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = rijwegVanWijzigClick
          end
          object rijwegNaarWijzig: TSpeedButton
            Left = 392
            Top = 40
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = rijwegNaarWijzigClick
          end
          object SpeedButton23: TSpeedButton
            Left = 8
            Top = 160
            Width = 121
            Height = 21
            GroupIndex = 2
            Caption = 'Meetpunten en wissels'
            OnClick = SpeedButton23Click
          end
          object SpeedButton24: TSpeedButton
            Left = 8
            Top = 184
            Width = 121
            Height = 21
            GroupIndex = 2
            Caption = '(In)actieve hokjes'
            OnClick = SpeedButton24Click
          end
          object SpeedButton25: TSpeedButton
            Left = 136
            Top = 184
            Width = 105
            Height = 21
            GroupIndex = 2
            Caption = 'Kruisingen uitleggen'
            OnClick = SpeedButton25Click
          end
          object rijwegNiks: TSpeedButton
            Left = 584
            Top = 16
            Width = 23
            Height = 22
            Hint = 'Niets doen'
            GroupIndex = 2
            Down = True
            Caption = 'X'
            Flat = True
            ParentShowHint = False
            ShowHint = True
            OnClick = drawNiksClick
          end
          object seinWijzigKlik: TSpeedButton
            Left = 392
            Top = 136
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = seinWijzigKlikClick
          end
          object Label21: TLabel
            Left = 248
            Top = 140
            Width = 44
            Height = 13
            Caption = 'Van sein:'
          end
          object SpeedButton37: TSpeedButton
            Left = 136
            Top = 160
            Width = 105
            Height = 21
            GroupIndex = 2
            Caption = 'Approach-locking'
            OnClick = SpeedButton37Click
          end
          object richtingWijzigBut: TSpeedButton
            Left = 392
            Top = 184
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = richtingWijzigButClick
          end
          object Label27: TLabel
            Left = 248
            Top = 188
            Width = 42
            Height = 13
            Caption = 'Richting:'
          end
          object richtingWisBut: TSpeedButton
            Left = 456
            Top = 184
            Width = 57
            Height = 21
            Caption = 'Wissen'
            OnClick = richtingWisButClick
          end
          object Label32: TLabel
            Left = 248
            Top = 92
            Width = 47
            Height = 13
            Caption = 'TNV-Van:'
          end
          object tnvvanwijzig: TSpeedButton
            Left = 392
            Top = 88
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = tnvvanwijzigClick
          end
          object tnvvanwis: TSpeedButton
            Left = 456
            Top = 88
            Width = 57
            Height = 21
            Caption = 'Wissen'
            OnClick = tnvvanwisClick
          end
          object Label35: TLabel
            Left = 248
            Top = 116
            Width = 51
            Height = 13
            Caption = 'TNV-Naar:'
          end
          object tnvnaarwijzig: TSpeedButton
            Left = 392
            Top = 112
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = tnvnaarwijzigClick
          end
          object tnvnaarwis: TSpeedButton
            Left = 456
            Top = 112
            Width = 57
            Height = 21
            Caption = 'Wissen'
            OnClick = tnvnaarwisClick
          end
          object naarSeinWijzigBut: TSpeedButton
            Left = 392
            Top = 160
            Width = 57
            Height = 21
            GroupIndex = 2
            Caption = 'Wijzigen'
            OnClick = naarSeinWijzigButClick
          end
          object Label36: TLabel
            Left = 248
            Top = 164
            Width = 48
            Height = 13
            Caption = 'Naar sein:'
          end
          object naarseinWisBut: TSpeedButton
            Left = 456
            Top = 160
            Width = 57
            Height = 21
            Caption = 'Wissen'
            OnClick = naarseinWisButClick
          end
          object triggerDelBut: TSpeedButton
            Left = 456
            Top = 64
            Width = 57
            Height = 21
            Caption = 'Wissen'
            OnClick = triggerDelButClick
          end
          object triggerChgBut: TSpeedButton
            Left = 392
            Top = 64
            Width = 57
            Height = 21
            GroupIndex = 3
            Caption = 'Wijzigen'
            OnClick = triggerChgButClick
          end
          object Label30: TLabel
            Left = 248
            Top = 68
            Width = 36
            Height = 13
            Caption = 'Trigger:'
          end
          object rijwegVanEdit: TEdit
            Left = 304
            Top = 16
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object rijwegNaarEdit: TEdit
            Left = 304
            Top = 40
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
          object seinEdit: TEdit
            Left = 304
            Top = 136
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
          end
          object rijwegBestaatUit: TListBox
            Left = 8
            Top = 32
            Width = 233
            Height = 121
            TabStop = False
            ItemHeight = 13
            ParentColor = True
            TabOrder = 3
          end
          object richtingEdit: TEdit
            Left = 304
            Top = 184
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
          end
          object rijwegtnvvanedit: TEdit
            Left = 304
            Top = 88
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 5
          end
          object rijwegtnvnaaredit: TEdit
            Left = 304
            Top = 112
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 6
          end
          object naarSeinEdit: TEdit
            Left = 304
            Top = 160
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 7
          end
          object triggerEdit: TEdit
            Left = 304
            Top = 64
            Width = 81
            Height = 21
            TabStop = False
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 8
          end
          object onbevCheck: TCheckBox
            Left = 456
            Top = 40
            Width = 113
            Height = 17
            Caption = 'Onbeveiligd spoor'
            TabOrder = 9
            OnClick = onbevCheckClick
          end
        end
      end
      object PrlRijwegTab: TTabSheet
        Caption = 'Procesleiding'
        ImageIndex = 8
        object prlRBox: TGroupBox
          Left = 0
          Top = 0
          Width = 193
          Height = 209
          Anchors = [akLeft, akTop, akBottom]
          Caption = 'Rijwegen voor Procesleiding'
          TabOrder = 0
          object prlRlist: TListBox
            Left = 8
            Top = 16
            Width = 177
            Height = 121
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
            OnClick = prlRlistClick
          end
          object prlrtBut: TButton
            Left = 8
            Top = 144
            Width = 75
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Toevoegen'
            Default = True
            TabOrder = 1
            OnClick = prlrtButClick
          end
          object prlrdBut: TButton
            Left = 88
            Top = 144
            Width = 75
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Verwijderen'
            TabOrder = 2
            OnClick = prlrdButClick
          end
          object rtpCopyBut: TButton
            Left = 8
            Top = 176
            Width = 153
            Height = 25
            Caption = 'Gewone rijwegen kopi�ren'
            TabOrder = 3
            OnClick = rtpCopyButClick
          end
        end
        object prlreditbox: TGroupBox
          Left = 200
          Top = 0
          Width = 481
          Height = 209
          Caption = 'Rijweg voor Procesleiding bewerken'
          TabOrder = 1
          object Label29: TLabel
            Left = 8
            Top = 16
            Width = 47
            Height = 13
            Caption = 'Rijwegen:'
          end
          object AddPrlSpoorBut: TSpeedButton
            Left = 192
            Top = 56
            Width = 281
            Height = 21
            GroupIndex = 3
            Caption = 'Rijweg aan lijst toevoegen'
            OnClick = AddPrlSpoorButClick
          end
          object RmPrlSpoorBut: TSpeedButton
            Left = 192
            Top = 104
            Width = 281
            Height = 21
            Caption = 'Laatste rijweg uit lijst verwijderen'
            OnClick = RmPrlSpoorButClick
          end
          object Label31: TLabel
            Left = 192
            Top = 36
            Width = 37
            Height = 13
            Caption = 'Dwang:'
          end
          object prlRijwegNiks: TSpeedButton
            Left = 192
            Top = 128
            Width = 23
            Height = 22
            Hint = 'Niets doen'
            GroupIndex = 3
            Down = True
            Caption = 'X'
            Flat = True
            ParentShowHint = False
            ShowHint = True
            OnClick = prlRijwegNiksClick
          end
          object prlrtStatus: TLabel
            Left = 192
            Top = 80
            Width = 38
            Height = 13
            Caption = 'Gereed.'
          end
          object prlSpoorLijst: TListBox
            Left = 8
            Top = 32
            Width = 177
            Height = 169
            ItemHeight = 13
            TabOrder = 0
          end
          object DwangEdit: TEdit
            Left = 264
            Top = 32
            Width = 81
            Height = 21
            TabOrder = 1
            Text = '0'
            OnChange = DwangEditChange
          end
        end
      end
    end
    object infoBox: TGroupBox
      Left = 825
      Top = 0
      Width = 169
      Height = 237
      Align = alRight
      Caption = 'Informatie'
      TabOrder = 1
      object infoMemo: TMemo
        Left = 8
        Top = 16
        Width = 153
        Height = 209
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 40
    object Bestand1: TMenuItem
      Caption = '&Bestand'
      object Openen1: TMenuItem
        Action = Openen
      end
      object Opslaan1: TMenuItem
        Action = Opslaan
      end
      object OpslaanAls1: TMenuItem
        Action = OpslaanAls
      end
      object Afsluiten1: TMenuItem
        Action = exitAct
      end
    end
    object Beeld1: TMenuItem
      Caption = 'Bee&ld'
      object Treinnummersweergeven1: TMenuItem
        Action = TreinnrWeergeven
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Info1: TMenuItem
        Caption = '&Info'
        ShortCut = 112
        OnClick = Info1Click
      end
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 40
    object TreinnrWeergeven: TAction
      Caption = 'Treinnummer-posities weergeven'
      Checked = True
      OnExecute = TreinnrWeergevenExecute
    end
    object OpslaanAls: TAction
      Caption = 'Opslaan Als...'
      OnExecute = OpslaanAlsExecute
    end
    object Opslaan: TAction
      Caption = 'O&pslaan'
      ShortCut = 16467
      OnExecute = OpslaanExecute
    end
    object Openen: TAction
      Caption = 'Openen...'
      ShortCut = 16463
      OnExecute = OpenenExecute
    end
    object exitAct: TAction
      Caption = 'Afsluiten'
      ShortCut = 32883
      OnExecute = exitActExecute
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'sts'
    Filter = 'StwSim Client Files|*.sts'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 80
    Top = 40
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'sts'
    Filter = 'StwSim Client Files|*.sts'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 112
    Top = 40
  end
  object InfraOpenDialog: TOpenDialog
    DefaultExt = 'sss'
    Filter = 'StwSim Server Simulatie|*.sss'
    Left = 144
    Top = 40
  end
end
