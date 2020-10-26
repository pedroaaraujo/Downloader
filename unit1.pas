unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  fphttpclient;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnBaixar: TButton;
    edtUrl: TEdit;
    pgbProgresso: TProgressBar;
    SaveDialog1: TSaveDialog;
    procedure btnBaixarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure ClientDataReceived(Sender: TObject; const ContentLength,
      CurrentPos: Int64);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnBaixarClick(Sender: TObject);
var
  Client: TFPHTTPClient;
  FS: TFileStream;
begin
  SaveDialog1.FileName := ExtractFileName(edtUrl.Text);
  if not SaveDialog1.Execute then
  begin
    Exit;
  end;

  Client := TFPHTTPClient.Create(Self);
  FS     := TFileStream.Create(SaveDialog1.FileName, fmCreate or fmOpenWrite);
  try
    Client.OnDataReceived := @ClientDataReceived;
    Client.Get(edtUrl.Text, FS);
  finally
    FS.Free;
    Client.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnException:=@ApplicationException;
end;

procedure TForm1.ApplicationException(Sender: TObject; E: Exception);
begin
  ShowMessage(E.Message);
end;

procedure TForm1.ClientDataReceived(Sender: TObject; const ContentLength,
  CurrentPos: Int64);
begin
  pgbProgresso.Max      := ContentLength;
  pgbProgresso.Position := CurrentPos;
end;

end.

