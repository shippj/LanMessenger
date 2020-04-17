object frmMain: TfrmMain
  Left = 292
  Top = 251
  Width = 567
  Height = 324
  Caption = 'Lan Messenger: by John Shipp - www.jshipp.com'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    551
    286)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 57
    Height = 13
    Caption = 'Nickname'
  end
  object txtNick: TEdit
    Left = 88
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    OnExit = txtNickExit
  end
  object memoChat: TMemo
    Left = 8
    Top = 40
    Width = 533
    Height = 207
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 3
  end
  object txtSend: TEdit
    Left = 8
    Top = 254
    Width = 533
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    OnKeyUp = txtSendKeyUp
  end
  object cmdClear: TButton
    Left = 248
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = cmdClearClick
  end
  object IdUDPServer1: TIdUDPServer
    BroadcastEnabled = True
    Bindings = <>
    DefaultPort = 5456
    OnUDPRead = IdUDPServer1UDPRead
    Left = 352
    Top = 8
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 400
    Top = 8
  end
end
