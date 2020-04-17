unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IdSocketHandle,
  mmsystem, registry, version, IdTCPConnection, IdTCPClient, IdHTTP, StrUtils;

type
  TfrmMain = class(TForm)
    txtNick: TEdit;
    Label1: TLabel;
    memoChat: TMemo;
    txtSend: TEdit;
    cmdClear: TButton;
    IdUDPServer1: TIdUDPServer;
    IdHTTP1: TIdHTTP;
    procedure cmdClearClick(Sender: TObject);
    procedure txtSendKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure txtNickExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function GetNick: String;
    procedure SetNick(Nick: String);
    procedure blink;
    procedure SendMsg(Msg: String);
  public
    ver: integer;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  txtNick.Text := GetNick;
  ver := 3;
  caption := caption+' - version '+IntToStr(ver);
  checkversion;
  if length(txtNick.text) > 0 then
    SendMsg(txtNick.text+' has joined the chat.');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if length(txtNick.text) > 0 then
    SendMsg(txtNick.text+' has left the chat.');
end;

procedure TfrmMain.cmdClearClick(Sender: TObject);
begin
  memoChat.Clear;
end;

procedure TfrmMain.txtSendKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then exit;
  if length(trim(txtNick.text)) = 0 then begin
    showmessage('You must enter a nickname before you can send messages!');
    exit;
    end;
  SendMsg(txtNick.text+': '+txtSend.text);
  txtSend.clear;
end;

procedure TfrmMain.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  msg: string;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    msg := DataStringStream.DataString;
//    showmessage(msg);
    if length(msg)=0 then exit;
    memoChat.Lines.Add(msg);
    if leftstr(msg,(length(txtNick.Text))) <> txtNick.Text then begin
      playSound('default', hInstance, SND_ASYNC);
      blink;
      end;

  except
    on E: Exception do
      memoChat.Lines.Add('ERROR: '+e.message);
  end;
  DataStringStream.Free;
end;


procedure TfrmMain.txtNickExit(Sender: TObject);
var OldNick: String;
begin
  OldNick := GetNick;
  txtNick.text := trim(txtNick.text);
  if txtNick.text = OldNick then exit;
  if length(OldNick) > 0 then
    SendMsg(OldNick+' has left the chat.');
  if length(txtNick.text) > 0 then begin
    SendMsg(txtNick.text+' has joined the chat.');
    SetNick(txtNick.text);
    end;
end;

function TfrmMain.GetNick: String;
var Reg: TRegistry;
begin
  result := '';
  try
    Reg := TRegistry.Create(KEY_READ);
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\SOFTWARE\JShippLanMessenger\', true) then
      begin
        result := Reg.ReadString('Nick');
        Reg.CloseKey;
      end;
    except
      on E: Exception do
      memoChat.Lines.Add('Error while attempting to save nickname in registry- '+E.Message);
    end;
    Reg.Free;
  except
    on E: Exception do
      memoChat.Lines.Add('Error while attempting to save nickname in registry - '+E.Message)
  end;

end;

procedure TfrmMain.SetNick(Nick: String);
var Reg: TRegistry;
begin
  try
    Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\SOFTWARE\JShippLanMessenger\', true) then
      begin
        Reg.WriteString('Nick', Nick);
        Reg.CloseKey;
      end;
    except
      on E: Exception do
      memoChat.Lines.Add('Error while attempting to save nickname in registry- '+E.Message);
    end;
    Reg.Free;
  except
    on E: Exception do
      memoChat.Lines.Add('Error while attempting to save nickname in registry - '+E.Message)
  end;
end;

procedure TfrmMain.SendMsg(Msg: String);
begin
  try
    IdUDPServer1.Send('255.255.255.255',5456,Msg);
  except;
  end;
end;

procedure TfrmMain.blink;
begin
  visible := false;
  sleep(100);
  visible := true;
  sleep(100);
  visible := false;
  sleep(100);
  visible := true;
  sleep(100);
  visible := false;
  sleep(100);
  visible := true;
  sleep(100);
end;

end.
