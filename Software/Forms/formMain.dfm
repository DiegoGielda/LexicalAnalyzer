object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 807
  ClientWidth = 1518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gridMain: TGridPanel
    Left = 0
    Top = 0
    Width = 1518
    Height = 807
    Align = alClient
    Caption = 'gridMain'
    ColumnCollection = <
      item
        Value = 27.272727272727270000
      end
      item
        Value = 72.727272727272730000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = gridResult
        Row = 0
      end
      item
        Column = 0
        Control = gridSearchedWord
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 0
    object gridResult: TGridPanel
      Left = 414
      Top = 1
      Width = 1103
      Height = 805
      Align = alClient
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = sgridResult
          Row = 0
        end>
      ParentBackground = False
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      object sgridResult: TStringGrid
        Left = 1
        Top = 1
        Width = 1101
        Height = 803
        ParentCustomHint = False
        TabStop = False
        Align = alClient
        BiDiMode = bdLeftToRight
        ColCount = 27
        Ctl3D = True
        DefaultColWidth = 39
        DefaultDrawing = False
        DoubleBuffered = False
        DragMode = dmAutomatic
        DrawingStyle = gdsGradient
        FixedColor = clBlack
        RowCount = 100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnDrawCell = sgridResultDrawCell
      end
    end
    object gridSearchedWord: TGridPanel
      Left = 1
      Top = 1
      Width = 413
      Height = 805
      Align = alClient
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = -1
          Row = 0
        end
        item
          Column = 0
          Control = edtAdd
          Row = 0
        end
        item
          Column = 0
          Control = btnAdd
          Row = 1
        end
        item
          Column = 0
          Control = lbxWords
          Row = 2
        end
        item
          Column = 0
          Control = edtSearch
          Row = 4
        end
        item
          Column = 0
          Control = lblReconhecidas
          Row = 5
        end
        item
          Column = 0
          Control = lblIdentifier
          Row = 3
        end>
      RowCollection = <
        item
          Value = 3.000000000000000000
        end
        item
          Value = 4.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end
        item
          Value = 3.000000000000000000
        end
        item
          Value = 3.000000000000000000
        end
        item
          Value = 37.000000000000000000
        end>
      TabOrder = 1
      DesignSize = (
        413
        805)
      object edtAdd: TEdit
        Left = 1
        Top = 1
        Width = 411
        Height = 24
        Align = alClient
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = 'Digite aqui ...'
      end
      object btnAdd: TButton
        Left = 1
        Top = 25
        Width = 411
        Height = 32
        Align = alClient
        Caption = 'ADICIONAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnAddClick
      end
      object lbxWords: TListBox
        Left = 1
        Top = 57
        Width = 411
        Height = 376
        Align = alTop
        BiDiMode = bdLeftToRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 19
        Items.Strings = (
          'PROCEDURE'
          'BEGIN'
          'END'
          'VARCHAR'
          'INTEGER')
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 2
        OnClick = lbxWordsClick
      end
      object edtSearch: TEdit
        Left = 1
        Top = 482
        Width = 411
        Height = 24
        Align = alClient
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        TextHint = 'Digite aqui ...'
        OnKeyPress = edtSearchKeyPress
      end
      object lblReconhecidas: TLabel
        Left = 204
        Top = 647
        Width = 4
        Height = 16
        Anchors = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblIdentifier: TLabel
        Left = 1
        Top = 458
        Width = 411
        Height = 24
        Align = alClient
        Caption = 'Identificador:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
