unit Unit1;

////////////////////////////////////////////////////////
/// Programed by MoonWolf with ChatGPT4
/// (c)2023MoonWolf
///『ChatGPT PASCAL GAME Vol.1』 Amazon Kindle
/// Program 2 : Escape Game
/// Amazon link   : amazon.co.jp/MoonWolf/e/B0CD3151FX
/// Twitter(X)    : MoonWolf_001
////////////////////////////////////////////////////////


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math, Dialogs;

const
  NumAsteroids = 50; // アステロイドの数
  ShipSize = 8; // 宇宙船のサイズ


type
  TAsteroid = record
    X, Y: Integer;
    Size: Integer;
    Color: TColor;
    SpeedX, SpeedY: Integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    ShipX, ShipY: Integer;
    Asteroids: array[1..NumAsteroids] of TAsteroid;
    GameOver: Boolean;
    procedure InitializeAsteroids;
    procedure MoveAsteroids;
    procedure DrawGame;
    function GetRandomColor: TColor;
    procedure CheckCollision;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := '迫りくる〇から逃げるゲーム by Programed by MoonWolf with ChatGPT4 2023';
  Randomize;
  ShipX := ClientWidth div 2;
  ShipY := ClientHeight div 2;
  InitializeAsteroids;
  GameOver := False;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ShipX := X;
  ShipY := Y;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  DrawGame;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not GameOver then
  begin
    MoveAsteroids;
    CheckCollision;
  end;
  Invalidate;
end;

procedure TForm1.InitializeAsteroids;
var
  i: Integer;
  Distance: Integer;
begin
  for i := 1 to NumAsteroids do
  begin
    repeat
      Asteroids[i].X := Random(ClientWidth);
      Asteroids[i].Y := Random(ClientHeight);
      Asteroids[i].Size := Random(15) + 10;
      Asteroids[i].Color := GetRandomColor;

      // 速度をランダムに設定し、0にならないようにする
      repeat
        Asteroids[i].SpeedX := Random(8) - 4; // -3 から +3 の範囲
        Asteroids[i].SpeedY := Random(8) - 4;
      until (Asteroids[i].SpeedX <> 0) and (Asteroids[i].SpeedY <> 0);

      // プレイヤーからの距離を計算
      Distance := Max(Abs(ShipX - Asteroids[i].X), Abs(ShipY - Asteroids[i].Y));
    until Distance > 100; // プレイヤーから一定距離以上離れるまで再試行
  end;
end;


procedure TForm1.MoveAsteroids;
var
  i: Integer;
begin
  for i := 1 to NumAsteroids do
  begin
    Asteroids[i].X := (Asteroids[i].X + Asteroids[i].SpeedX + ClientWidth) mod ClientWidth;
    Asteroids[i].Y := (Asteroids[i].Y + Asteroids[i].SpeedY + ClientHeight) mod ClientHeight;
  end;
end;

function TForm1.GetRandomColor: TColor;
begin
  Result := RGBToColor(Random(256), Random(256), Random(256));
end;

procedure TForm1.CheckCollision;
var
  i: Integer;
  Distance: Integer;
begin
  for i := 1 to NumAsteroids do
  begin
    Distance := Round(Sqrt(Sqr(ShipX - Asteroids[i].X) + Sqr(ShipY - Asteroids[i].Y)));
    if Distance < Asteroids[i].Size + ShipSize then
    begin
      if not GameOver then
      begin
        GameOver := True;
        ShowMessage('Game Over!');
        Timer1.Enabled := False; // ゲームオーバー時にタイマーを停止
        Break;
      end;
    end;
  end;
end;

procedure TForm1.DrawGame;
var
  i: Integer;
begin
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(ClientRect);

  // Draw Ship
  Canvas.Brush.Color := clWhite;
  Canvas.Rectangle(ShipX - ShipSize, ShipY - ShipSize, ShipX + ShipSize, ShipY + ShipSize);

  // Draw Asteroids
  for i := 1 to NumAsteroids do
  begin
    Canvas.Brush.Color := Asteroids[i].Color;
    Canvas.Ellipse(Asteroids[i].X - Asteroids[i].Size, Asteroids[i].Y - Asteroids[i].Size,
                   Asteroids[i].X + Asteroids[i].Size, Asteroids[i].Y + Asteroids[i].Size);
  end;
end;

end.
