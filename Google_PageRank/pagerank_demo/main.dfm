object MainForm: TMainForm
  Left = 223
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Google PageRank'
  ClientHeight = 105
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    427
    105)
  PixelsPerInch = 120
  TextHeight = 16
  object URLLabel: TLabel
    Left = 8
    Top = 16
    Width = 79
    Height = 16
    Caption = 'URL of page:'
  end
  object PageRankControl: TPageRankControl
    Left = 320
    Top = 48
    Width = 97
    Height = 49
    PageRank = PageRank
    BorderColor = clBlack
    FillerColor = clWhite
    FilledColor = 6203998
  end
  object Label1: TLabel
    Left = 208
    Top = 56
    Width = 37
    Height = 16
    Caption = 'Width:'
  end
  object URLEdit: TEdit
    Left = 96
    Top = 16
    Width = 321
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'http://www.delphisources.ru'
  end
  object CheckButton: TButton
    Left = 8
    Top = 48
    Width = 185
    Height = 25
    Caption = 'Check PageRank'
    TabOrder = 0
    OnClick = CheckButtonClick
  end
  object ShowTextBox: TCheckBox
    Left = 224
    Top = 78
    Width = 89
    Height = 19
    Caption = 'Show text'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = ShowTextBoxClick
  end
  object NonBlockBox: TCheckBox
    Left = 8
    Top = 80
    Width = 145
    Height = 17
    Caption = 'Non-blocking mode'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = NonBlockBoxClick
  end
  object WidthEdit: TEdit
    Left = 255
    Top = 48
    Width = 41
    Height = 25
    TabOrder = 4
    Text = '7'
    OnChange = WidthEditChange
  end
  object WidthSpin: TUpDown
    Left = 296
    Top = 48
    Width = 17
    Height = 25
    Associate = WidthEdit
    Position = 7
    TabOrder = 5
  end
  object PageRank: TPageRank
    Auto = False
    NonBlock = False
    OldVersion = False
    OnGetRank = OnGetRank
    Left = 328
    Top = 8
  end
end
