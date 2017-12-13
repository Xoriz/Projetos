object FrmPrincipal: TFrmPrincipal
  Left = 506
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Assistente do Release Intime'
  ClientHeight = 493
  ClientWidth = 560
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 493
    Align = alClient
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 558
      Height = 375
      Align = alClient
      DataSource = DtsArquivos
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Nome'
          Width = 345
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Caminho'
          Width = 158
          Visible = True
        end>
    end
    object Panel2: TPanel
      Left = 1
      Top = 376
      Width = 558
      Height = 116
      Align = alBottom
      TabOrder = 1
      object Label1: TLabel
        Left = 10
        Top = 4
        Width = 359
        Height = 20
        AutoSize = False
        Caption = 'Caminho da pasta com os arquivos:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 10
        Top = 52
        Width = 191
        Height = 20
        AutoSize = False
        Caption = 'Onde colocar arquivo final:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Button2: TButton
        Left = 453
        Top = 14
        Width = 89
        Height = 41
        Caption = 'Gerar Arquivo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button2Click
      end
      object Edt_PathPasta: TEdit
        Left = 13
        Top = 25
        Width = 428
        Height = 26
        AutoSize = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Edt_PathFinal: TEdit
        Left = 13
        Top = 73
        Width = 428
        Height = 26
        AutoSize = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object Edt_Cam: TDirectoryEdit
        Left = 417
        Top = 27
        Width = 22
        Height = 22
        DialogKind = dkWin32
        AutoSelect = False
        BorderStyle = bsNone
        NumGlyphs = 1
        TabOrder = 3
        Text = ''
        OnChange = Edt_CamChange
      end
      object Edt_CamFinal: TDirectoryEdit
        Left = 417
        Top = 75
        Width = 22
        Height = 22
        DialogKind = dkWin32
        AutoSelect = False
        BorderStyle = bsNone
        NumGlyphs = 1
        TabOrder = 4
        Text = ''
        OnChange = Edt_CamFinalChange
      end
      object Button1: TButton
        Left = 453
        Top = 58
        Width = 89
        Height = 41
        Caption = 'Tirar das Pastas'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = Button1Click
      end
    end
  end
  object TblArquivos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 296
    object TblArquivosNome: TStringField
      FieldName = 'Nome'
      Size = 100
    end
    object TblArquivosCaminho: TStringField
      FieldName = 'Caminho'
      Size = 50
    end
  end
  object DtsArquivos: TDataSource
    DataSet = TblArquivos
    Left = 288
    Top = 296
  end
end
