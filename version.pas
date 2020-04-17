unit version;

interface

uses
  Classes, Forms, dialogs, sysutils, StrUtils;

var
  vNVIDIA, vATI, vCPU, vWFF: Integer;
  OnlineVersion: String;

procedure CheckVersion;
function HttpToMemory(fileURL: String): boolean;

implementation
uses unit1;
const CR = #13#10;


type
  TVersionThread = class(TThread)
  protected
    Log: String;
    procedure Execute; override;
    procedure LogSomething;
  public
  end;


procedure CheckVersion;
begin
  TVersionThread.Create(false);
end;

procedure TVersionThread.LogSomething;
begin
  frmMain.memoChat.Lines.add(Log);
  Log := '';
end;

procedure TVersionThread.Execute;
var
  iOnlineVersion: Integer;
begin
  //Log := 'Checking for new version...';
  //Synchronize(LogSomething);

  sleep(30000);
  try
    if HttpToMemory('http://www.jshipp.com/programs/lanmsgr/version.txt') then begin
      if OnlineVersion = '' then exit;
      if not TryStrToInt(OnlineVersion, iOnlineVersion) then exit;
      if iOnlineVersion > frmMain.ver then begin
        Log := 'New Version Detected!  Download the upgrade at www.jshipp.com';
        Synchronize(LogSomething);
        end;
      end;
    except
    end;
end;

function HttpToMemory(fileURL: String): boolean;
var StringList: TStringList;
begin
  result := true;
  StringList := TStringList.Create;
  try
    StringList.text := frmMain.IdHTTP1.get(fileURL);
    OnlineVersion := StringList[0];
  except
    result := false;
  end;
  StringList.Destroy;
end;

end.
