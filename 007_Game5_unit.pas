unit Unit1;

////////////////////////////////////////////////////////
/// Programed by MoonWolf with ChatGPT4
/// (c)2023MoonWolf
///『ChatGPT PASCAL GAME Vol.1』 Amazon Kindle
/// Program 5 : Blocks Game
/// Amazon link   : amazon.co.jp/MoonWolf/e/B0CD3151FX
/// Twitter(X)    : MoonWolf_001
////////////////////////////////////////////////////////

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TBlock = record
    Active: Boolean;
    Rect: TRect;
    Color: TColor;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    Paddle: TRect;
    Ball: TRect;
    BallSpeedX, BallSpeedY: Integer;
    Blocks: array of array of TBlock;
    GameOver, GameClear: Boolean;
    procedure InitializeGame;
    procedure MoveBall;
    procedure CheckCollision;
    function AllBlocksCleared: Boolean;
    procedure DrawGame;
  public

  end;

var
  Form1: TForm1;

const
  PaddleWidth = 100;
  PaddleHeight = 20;
  BallSize = 15;
  BlockWidth = 60;
  BlockHeight = 20;
  BallSpeedInitialX = 8;
  BallSpeedInitialY = -8;
  BlockColumns = 10;
  BlockRows = 6;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitializeGame;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SetLength(Blocks, 0, 0);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  DrawGame;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not (GameOver or GameClear) then
  begin
    MoveBall;
    CheckCollision;
    Invalidate;
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Paddle.Left := X - (PaddleWidth div 2);
  Paddle.Right := X + (PaddleWidth div 2);
  Invalidate;
end;

procedure TForm1.InitializeGame;
var
  i, j: Integer;
begin
  // Initialize paddle
  Paddle := Rect((ClientWidth div 2) - (PaddleWidth div 2), ClientHeight - PaddleHeight - 10,
                 (ClientWidth div 2) + (PaddleWidth div 2), ClientHeight - 10);

  // Initialize ball
  Ball := Rect((ClientWidth div 2) - (BallSize div 2), Paddle.Top - BallSize,
               (ClientWidth div 2) + (BallSize div 2), Paddle.Top);

  BallSpeedX := BallSpeedInitialX;
  BallSpeedY := BallSpeedInitialY;

  // Initialize blocks
  SetLength(Blocks, BlockColumns, BlockRows);
  for i := 0 to High(Blocks) do
    for j := 0 to High(Blocks[i]) do
    begin
      Blocks[i, j].Active := True;
      Blocks[i, j].Rect := Rect(i * BlockWidth, j * BlockHeight,
                                (i + 1) * BlockWidth, (j + 1) * BlockHeight);
      Blocks[i, j].Color := RGBToColor(Random(255), Random(255), Random(255));
    end;

  GameOver := False;
  GameClear := False;
end;

procedure TForm1.MoveBall;
begin
  // Move ball
  Ball.Left := Ball.Left + BallSpeedX;
  Ball.Right := Ball.Right + BallSpeedX;
  Ball.Top := Ball.Top + BallSpeedY;
  Ball.Bottom := Ball.Bottom + BallSpeedY;
end;

procedure TForm1.CheckCollision;
var
  i, j: Integer;
begin
  // Check collision with walls
  if (Ball.Left <= 0) or (Ball.Right >= ClientWidth) then
    BallSpeedX := -BallSpeedX;
  if Ball.Top <= 0 then
    BallSpeedY := -BallSpeedY;

  // Check collision with paddle
  if (Ball.Bottom >= Paddle.Top) and (Ball.Right >= Paddle.Left) and (Ball.Left <= Paddle.Right) then
  begin
    BallSpeedY := -BallSpeedY;
    Ball.Top := Paddle.Top - BallSize;
  end
  else if Ball.Bottom >= ClientHeight then
  begin
    GameOver := True;
    Exit;
  end;

  // Check collision with blocks
  for i := 0 to High(Blocks) do
    for j := 0 to High(Blocks[i]) do
      if Blocks[i, j].Active and (Ball.Top <= Blocks[i, j].Rect.Bottom) and
         (Ball.Bottom >= Blocks[i, j].Rect.Top) and
         (Ball.Right >= Blocks[i, j].Rect.Left) and
         (Ball.Left <= Blocks[i, j].Rect.Right) then
      begin
        Blocks[i, j].Active := False;
        BallSpeedY := -BallSpeedY;
        if AllBlocksCleared then
        begin
          GameClear := True;
          Exit;
        end;
        Break;
      end;
end;

function TForm1.AllBlocksCleared: Boolean;
var
  i, j: Integer;
begin
  for i := 0 to High(Blocks) do
    for j := 0 to High(Blocks[i]) do
      if Blocks[i, j].Active then
        Exit(False);
  Result := True;
end;

procedure TForm1.DrawGame;
var
  i, j: Integer;
begin
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(ClientRect);

  // Draw paddle
  Canvas.Brush.Color := clBlue;
  Canvas.FillRect(Paddle);

  // Draw ball
  Canvas.Brush.Color := clRed;
  Canvas.Ellipse(Ball);

  // Draw blocks
  for i := 0 to High(Blocks) do
    for j := 0 to High(Blocks[i]) do
      if Blocks[i, j].Active then
      begin
        Canvas.Brush.Color := Blocks[i, j].Color;
        Canvas.FillRect(Blocks[i, j].Rect);
      end;

  // Draw game over or game clear message
  if GameOver then
  begin
    Canvas.Font.Size := 20;
    Canvas.TextOut((ClientWidth div 2) - 50, (ClientHeight div 2) - 10, 'Game Over');
  end
  else if GameClear then
  begin
    Canvas.Font.Size := 20;
    Canvas.TextOut((ClientWidth div 2) - 60, (ClientHeight div 2) - 10, 'Game Clear');
  end;
end;

end.
