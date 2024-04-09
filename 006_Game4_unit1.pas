unit Unit1;

////////////////////////////////////////////////////////
/// Programed by MoonWolf with ChatGPT4
/// (c)2023MoonWolf
///『ChatGPT PASCAL GAME Vol.1』 Amazon Kindle
/// Program 4 : Tate Scroll Game
/// Amazon link   : amazon.co.jp/MoonWolf/e/B0CD3151FX
/// Twitter(X)    : MoonWolf_001
////////////////////////////////////////////////////////

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls,dialogs;

type
  TAsteroid = record
    X, Y, Size, Speed: Integer;
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
    Asteroids: array of TAsteroid;
    GameOver: Boolean;
    procedure InitializeGame;
    procedure MoveAsteroids;
    procedure CheckCollision;
    procedure DrawGame;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := '縦スクロールゲーム by Programed by MoonWolf with ChatGPT4 2023';
  InitializeGame;
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
    Invalidate;
  end;
end;

procedure TForm1.InitializeGame;
var
  i: Integer;
begin
  ShipX := ClientWidth div 2;
  ShipY := ClientHeight - 50;
  SetLength(Asteroids, 30); // アステロイドの数を2倍に
  for i := Low(Asteroids) to High(Asteroids) do
  begin
    Asteroids[i].X := Random(ClientWidth);
    Asteroids[i].Y := Random(200) - 200;
    Asteroids[i].Size := 10 + Random(20);
    Asteroids[i].Speed := (1 + Random(5)) * 3;
  end;
  GameOver := False;
end;

procedure TForm1.MoveAsteroids;
var
  i: Integer;
begin
  for i := Low(Asteroids) to High(Asteroids) do
  begin
    Asteroids[i].Y := Asteroids[i].Y + Asteroids[i].Speed;
    if Asteroids[i].Y > ClientHeight then
    begin
      Asteroids[i].X := Random(ClientWidth);
      Asteroids[i].Y := -Asteroids[i].Size;
    end;
  end;
end;

procedure TForm1.CheckCollision;
var
  i: Integer;
begin
  for i := Low(Asteroids) to High(Asteroids) do
  begin
    if (Abs(ShipX - Asteroids[i].X) < Asteroids[i].Size + 5) and
       (Abs(ShipY - Asteroids[i].Y) < Asteroids[i].Size + 5) then
    begin
      GameOver := True;
      ShowMessage('Game Over!');
      Break;
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
  Canvas.Rectangle(ShipX - 15, ShipY - 15, ShipX + 15, ShipY + 15);

  // Draw Asteroids
  for i := Low(Asteroids) to High(Asteroids) do
  begin
    Canvas.Brush.Color := clGray;
    Canvas.Ellipse(Asteroids[i].X - Asteroids[i].Size, Asteroids[i].Y - Asteroids[i].Size,
                   Asteroids[i].X + Asteroids[i].Size, Asteroids[i].Y + Asteroids[i].Size);
  end;
end;

end.
