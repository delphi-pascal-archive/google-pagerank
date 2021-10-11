unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, PageRank;

type
  TMainForm = class(TForm)
    URLLabel: TLabel;
    URLEdit: TEdit;
    CheckButton: TButton;
    PageRank: TPageRank;
    PageRankControl: TPageRankControl;
    ShowTextBox: TCheckBox;
    NonBlockBox: TCheckBox;
    WidthEdit: TEdit;
    WidthSpin: TUpDown;
    Label1: TLabel;
    function OnGetRank(const URL: string; var Rank: string): Boolean;
    procedure CheckButtonClick(Sender: TObject);
    procedure ShowTextBoxClick(Sender: TObject);
    procedure NonBlockBoxClick(Sender: TObject);
    procedure WidthEditChange(Sender: TObject);
  private
    procedure RaiseError(Error: LongWord);
    procedure Check(Error: Boolean);
  end;

var
  MainForm: TMainForm;

implementation
// ========================================================================
uses
  WinInet;
{$R *.dfm}

procedure TMainForm.RaiseError(Error: LongWord);
var
  S: string;
  I: LongWord;
begin
  I := 1024; SetLength(S, I);
  if Error = ERROR_INTERNET_EXTENDED_ERROR then
  repeat
    if InternetGetLastResponseInfo(Error, PChar(S), I) then Break;
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then SetLength(S, I) else Break;
  until FALSE
  else FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_FROM_HMODULE,
    Pointer(GetModuleHandle('wininet.dll')), Error, 0, PChar(S), I, nil);
  S := PChar(S) + ' (' + IntToStr(Error) + ')';
  if PageRank.NonBlock then
    MessageBox(0, PChar(S), nil, MB_ICONERROR or MB_OK or MB_TASKMODAL);
  raise Exception.Create(S);
end;

procedure TMainForm.Check(Error: Boolean);
begin
  if Error then RaiseError(Windows.GetLastError);
end;

function TMainForm.OnGetRank(const URL: string; var Rank: string): Boolean;
var
  Root, Connect, Request: HINTERNET;
  I, L, RetVal: Longword;
  S, Server, Document: string;
  P: Pointer;
begin
  Result := FALSE; if UpperCase(Copy(URL, 1, 7)) <> 'HTTP://' then Exit;

  I := 8; L := Length(URL); while (I <= L) and (URL[I] <> '/') do Inc(I);
  if I > L then Exit;

  Server := Copy(URL, 8, I - 8); Document := Copy(URL, I, L - I + 1);

  RetVal := InternetAttemptConnect(0);
  if RetVal <> ERROR_SUCCESS then RaiseError(RetVal);

  Root := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  Check(Root = nil);
  try
    Connect := InternetConnect(Root, PChar(Server), INTERNET_DEFAULT_HTTP_PORT,
      nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    Check(Connect = nil);
    try
      Request := HttpOpenRequest(Connect, nil, PChar(Document), nil, nil,
        nil, INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD, 0);
      Check(Request = nil);
      try
        SetLength(S, 1024);
        repeat
          Check(not HttpSendRequest(Request, nil, 0, nil, 0));
          RetVal := InternetErrorDlg(GetDesktopWindow(), Request, GetLastError,
            FLAGS_ERROR_UI_FILTER_FOR_ERRORS or
            FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS or
            FLAGS_ERROR_UI_FLAGS_GENERATE_DATA, P);
          if RetVal = ERROR_CANCELLED then Exit;
        until RetVal = ERROR_SUCCESS;

        Rank := '';
        repeat
          SetLength(S, 1024);
          Check(not InternetReadFile(Request, PChar(S), 1024, L));
          SetLength(S, L); Rank := Rank + S
        until L < 1024;
        Result := TRUE
      finally
        InternetCloseHandle(Request);
      end
    finally
      InternetCloseHandle(Connect)
    end
  finally
    InternetCloseHandle(Root)
  end
end;

procedure TMainForm.CheckButtonClick(Sender: TObject);
begin
  PageRank.Page := URLEdit.Text;
  PageRank.NonBlock := NonBlockBox.Checked;
  PageRank.UpdatePageRank;
end;

procedure TMainForm.ShowTextBoxClick(Sender: TObject);
begin
  PageRankControl.ShowText := ShowTextBox.Checked
end;

procedure TMainForm.NonBlockBoxClick(Sender: TObject);
begin
  PageRank.NonBlock := NonBlockBox.Checked
end;

procedure TMainForm.WidthEditChange(Sender: TObject);
begin
  PageRankControl.BarWidth := WidthSpin.Position;
end;

end.



