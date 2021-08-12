unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  lNetComponents, lNet;

type

  { TForm1 }

  TForm1 = class(TForm)
    btConnect: TButton;
    btSave: TButton;
    btLoad: TButton;
    labelObj: TLabel;
    Memo1: TMemo;
    inputGrid: TStringGrid;
    btClear: TToggleBox;
    UDPComponent: TLUDPComponent;


    procedure btClearClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UDPComponentError(const msg: string; aSocket: TLSocket);
    procedure UDPComponentReceive(aSocket: TLSocket);
  private

  public

  end;

var
  Form1: TForm1;
  listen_addr: string;
  pub_addr: string;
  msgbuf: string;
  msg: string;
  listen_port : integer;
  pub_port : integer;
  first : Boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.UDPComponentError(const msg: string; aSocket: TLSocket);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

    inputGrid.LoadFromCSVFile('conf.config', ',');
    Memo1.Clear;
    first := True;
    btConnectClick(Sender);


end;

procedure TForm1.btConnectClick(Sender: TObject);
begin

    listen_addr := inputGrid.Cells[1, 0];
    listen_port := StrToInt(inputGrid.Cells[1, 1]);
    pub_addr := inputGrid.Cells[1, 2];
    pub_port := StrToInt(inputGrid.Cells[1, 3]);
    msg := inputGrid.Cells[1, 4];

    Memo1.Clear;

    UDPComponent.Listen(StrToIntDef(listen_addr, listen_port));
    Memo1.Append('Waiting Request at:');
    Memo1.Append(listen_addr + ':' + IntToStr(listen_port) );

    first := False;
end;

procedure TForm1.btClearClick(Sender: TObject);
begin
    Memo1.Clear;
    if not first then
    begin
             UDPComponent.Listen(StrToIntDef(listen_addr, listen_port));
             Memo1.Append('Waiting Request at:');
             Memo1.Append(listen_addr + ':' + IntToStr(listen_port) );
    end;
end;

procedure TForm1.btSaveClick(Sender: TObject);
begin
      inputGrid.SaveToCSVFile('conf.config', ',',true,false);
end;

procedure TForm1.UDPComponentReceive(aSocket: TLSocket);
var
  aux:string;
begin
    msgbuf := '';
    Memo1.Append('-------------------------');
    Memo1.Append('Request received. Input message: ');
    UDPComponent.GetMessage(msgbuf);
    Memo1.Append(msgbuf);
    Memo1.Append('Send message back to: ');
    Memo1.Append(pub_addr + ':' + IntToStr(pub_port) );
    aux := pub_addr + ':' + IntToStr(pub_port);
    UDPComponent.SendMessage(msg,aux);
    //UDPComponent.SendMessage('ACK from Lazarus',addr);
end;

end.

