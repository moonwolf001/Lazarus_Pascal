unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  i    : integer; // ボタンを押した回数を保存する整数の変数
  y    : integer; // button1 のY 座標

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Append('世界の皆様こんにちは！');
  Memo1.Append('私の名前はMoonWolfです');
  Memo1.Append('これが初めてのプログラムです');

  Button1.caption := IntToStr( i ) ;
  i := i + 1;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  timer1.interval := 50;
  y := button1.top ;

  if ( y < 300 ) and ( i < 11 ) then
  begin
    y := y + 15;
  end
    else
  begin
    y := 10;
  end;
  button1.Top := y ;
end;

end.          
