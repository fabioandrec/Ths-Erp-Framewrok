inherited frmBaseDBGrid: TfrmBaseDBGrid
  Caption = 'frmBaseDBGrid'
  ClientHeight = 476
  ClientWidth = 806
  Constraints.MinHeight = 350
  Constraints.MinWidth = 450
  OldCreateOrder = True
  ExplicitWidth = 822
  ExplicitHeight = 515
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TPanel
    Width = 802
    Height = 409
    ExplicitWidth = 802
    ExplicitHeight = 409
    inherited splLeft: TSplitter
      Height = 292
      ExplicitHeight = 280
    end
    inherited splHeader: TSplitter
      Width = 800
      ExplicitWidth = 568
    end
    inherited pnlLeft: TPanel
      Height = 289
      Caption = ''
      ExplicitHeight = 289
    end
    inherited pnlHeader: TPanel
      Width = 796
      Caption = ''
      ExplicitWidth = 796
    end
    inherited pnlContent: TPanel
      Width = 691
      Height = 289
      ExplicitWidth = 691
      ExplicitHeight = 289
      object dbgrdBase: TDBGrid
        Left = 1
        Top = 1
        Width = 689
        Height = 287
        Align = alClient
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        PopupMenu = pmDB
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgrdBaseCellClick
        OnColumnMoved = dbgrdBaseColumnMoved
        OnDrawDataCell = dbgrdBaseDrawDataCell
        OnDrawColumnCell = dbgrdBaseDrawColumnCell
        OnDblClick = dbgrdBaseDblClick
        OnExit = dbgrdBaseExit
        OnKeyDown = dbgrdBaseKeyDown
        OnMouseLeave = dbgrdBaseMouseLeave
        OnMouseMove = dbgrdBaseMouseMove
        OnMouseUp = dbgrdBaseMouseUp
        OnTitleClick = dbgrdBaseTitleClick
      end
    end
    object pnlButtons: TPanel
      Left = 1
      Top = 329
      Width = 800
      Height = 79
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object flwpnlLeft: TFlowPanel
        Left = 0
        Top = 0
        Width = 209
        Height = 79
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object btnAddNew: TBitBtn
          AlignWithMargins = True
          Left = 2
          Top = 2
          Width = 100
          Height = 36
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Add New'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 0
          Visible = False
          OnClick = btnAddNewClick
        end
        object btnTest: TBitBtn
          AlignWithMargins = True
          Left = 104
          Top = 2
          Width = 100
          Height = 36
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Test'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
          Visible = False
          OnClick = btnAddNewClick
        end
      end
      object flwpnlRight: TFlowPanel
        Left = 209
        Top = 0
        Width = 591
        Height = 79
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
  end
  inherited pnlBottom: TPanel
    Top = 413
    Width = 802
    ExplicitTop = 413
    ExplicitWidth = 802
    inherited btnAccept: TBitBtn
      Left = 593
      Caption = 'ACCEPT'
      ExplicitLeft = 593
    end
    inherited btnErase: TBitBtn
      Left = 489
      Caption = 'DELETE'
      ExplicitLeft = 489
    end
    inherited btnClose: TBitBtn
      Left = 697
      Caption = 'CLOSE'
      ExplicitLeft = 697
    end
  end
  object stbDBGrid: TStatusBar [2]
    Left = 0
    Top = 457
    Width = 806
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Width = 100
      end
      item
        Alignment = taRightJustify
        Width = 100
      end
      item
        Alignment = taRightJustify
        Width = 100
      end
      item
        Alignment = taRightJustify
        Width = 100
      end>
  end
  inherited pmDB: TPopupMenu
    object mniIncele: TMenuItem
      Caption = #304'ncele'
      ShortCut = 16397
      OnClick = mniInceleClick
    end
    object mniSeperator1: TMenuItem
      Caption = '-'
    end
    object mniSiralamayiIptalEt: TMenuItem
      Caption = 'S'#305'ralamay'#305' '#304'ptal Et'
      Visible = False
      OnClick = mniSiralamayiIptalEtClick
    end
    object mniExcelKaydet: TMenuItem
      Caption = 'Excel Kaydet'
      ShortCut = 16453
      OnClick = mniExcelKaydetClick
    end
    object mniYazdir: TMenuItem
      Caption = 'Yazd'#305'r'
      ShortCut = 16464
      OnClick = mniYazdirClick
    end
    object mniSeperator2: TMenuItem
      Caption = '-'
    end
  end
end
