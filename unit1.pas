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
    btForceSend: TButton;
    btForceClose: TButton;
    labelObj: TLabel;
    LUDPComponent1: TLUDPComponent;
    Memo1: TMemo;
    inputGrid: TStringGrid;
    btClear: TToggleBox;
    UDPComponent: TLUDPComponent;


    procedure btClearClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btForceSendClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btForceCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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

    UDPComponent.Host:= listen_addr;
    UDPComponent.Port:= listen_port;
    UDPComponent.Listen();

    //UDPComponent.Listen(StrToIntDef(listen_addr, listen_port));
    //UDPComponent.Connect(listen_addr, listen_port);
    LUDPComponent1.Connect(pub_addr,pub_port);
    //LUDPComponent1.Listen(StrToIntDef(pub_addr, pub_port));
    Memo1.Append('Waiting Request at:');
    Memo1.Append(listen_addr + ':' + IntToStr(listen_port) );

    first := False;
end;

procedure TForm1.btForceSendClick(Sender: TObject);
var
  aux:string;
begin
    Memo1.Clear;
    Memo1.Append('Forcing send message to: ');
    aux := pub_addr + ':' + IntToStr(pub_port);
    Memo1.Append(aux);
    LUDPComponent1.SendMessage(msg);
end;

procedure TForm1.btLoadClick(Sender: TObject);
begin
     inputGrid.LoadFromCSVFile('conf.config', ',');
     Memo1.Clear;
     Memo1.Append('Loading saved config');

end;

procedure TForm1.btClearClick(Sender: TObject);
begin
    Memo1.Clear;
    if not first then
    begin
              UDPComponent.Host:= listen_addr;
              UDPComponent.Port:= listen_port;
              UDPComponent.Listen();
             //UDPComponent.Listen(StrToIntDef(listen_addr, listen_port));
             //UDPComponent.Connect(listen_addr, listen_port);
             //LUDPComponent1.Listen(StrToIntDef(pub_addr, pub_port));
             LUDPComponent1.Connect(pub_addr,pub_port);
             Memo1.Append('Waiting Request at:');
             Memo1.Append(listen_addr + ':' + IntToStr(listen_port) );
    end;
end;

procedure TForm1.btSaveClick(Sender: TObject);
begin
      inputGrid.SaveToCSVFile('conf.config', ',',true,false);
end;

procedure TForm1.btForceCloseClick(Sender: TObject);
begin
    Memo1.Append('Closing sockets');
    UDPComponent.Disconnect();
    LUDPComponent1.Disconnect();
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   UDPComponent.Disconnect();
   LUDPComponent1.Disconnect();
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
    aux := pub_addr + ':' + IntToStr(pub_port);
    Memo1.Append(aux);

    LUDPComponent1.SendMessage(msg);


    //UDPComponent.SendMessage('ACK from Lazarus',addr);
end;

end.

