unit Unit1;

////////////////////////////////////////////////////////
/// Programed by MoonWolf with ChatGPT4
/// (c)2023MoonWolf
///『ChatGPT PASCAL GAME』 Amazon Kindle
/// Program 3 : Circle move shooting
/// Amazon link   : amazon.co.jp/MoonWolf/e/B0CD3151FX
/// Twitter(X)     : MoonWolf_001
////////////////////////////////////////////////////////

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Math, Types;

type
  { TForm1 }
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
  private
    Player: TRect;
    Missile: TRect;
    Enemies: array[1..20] of TRect; // 敵の数を20に設定
    EnemyCenters: array[1..20] of TPoint;
    EnemyAngles: array[1..20] of Double;
    EnemyRadius: array[1..20] of Integer;
    EnemyColors: array[1..20] of TColor;
    MissileFired: Boolean;
    GameOver: Boolean;
    procedure ProcessInput(var Key: char);
    procedure CheckCollisions;
    procedure Render;
    procedure MoveEnemies;
    procedure CheckGameOver;
    procedure UpdateEnemyPosition(Index: Integer);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Caption := '円を描いて迫りくる敵を撃つ by Programed by MoonWolf with ChatGPT4 2023';
  // Initialize player
  Player := Rect(100, Height - 50, 120, Height - 30);
  Missile := Rect(0, 0, 0, 0);
  MissileFired := False;
  GameOver := False;

  // Initialize 20 enemies, their centers, angles, and colors
  for i := 1 to 20 do
  begin
    EnemyCenters[i] := Point(Random(Width), Random(Height div 2));
    EnemyRadius[i] := Random(50) + 50; // Random radius between 50 and 100
    EnemyAngles[i] := Random * 2 * Pi; // Random angle
    Enemies[i] := Rect(0, 0, 30, 30); // 敵のサイズを大きくする
    UpdateEnemyPosition(i); // Set initial position
    EnemyColors[i] := RGBToColor(Random(256), Random(256), Random(256)); // Random color for each enemy
  end;

  // Set up timer
  Timer1.Interval := 16; // Approximately 60 frames per second
  Timer1.Enabled := True;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Player.Left := X;
  Player.Right := X + 20;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  ProcessInput(Key);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if GameOver then
  begin
    Timer1.Enabled := False;
    ShowMessage('Game Over!');
    Exit;
  end;

  MoveEnemies;
  CheckCollisions;
  CheckGameOver;
  Render;

  // Update Missile Position
  if MissileFired then
  begin
    Missile.Top := Missile.Top - 50; // ミサイルの移動速度を増加
    if Missile.Top < 0 then MissileFired := False;
  end;
end;

procedure TForm1.ProcessInput(var Key: char);
begin
  if Key = ' ' then
  begin
    if not MissileFired then
    begin
      Missile := Rect(Player.Left + 5, Player.Top - 10, Player.Left + 10, Player.Top);
      MissileFired := True;
    end;
  end;
end;

procedure TForm1.CheckCollisions;
var
  i: Integer;
  Intersection: TRect;
begin
  if MissileFired then
  begin
    for i := 1 to 20 do
    begin
      if IntersectRect(Intersection, Missile, Enemies[i]) then
      begin
        MissileFired := False;
        // Reset enemy position
        EnemyCenters[i] := Point(Random(Width), Random(Height div 2));
        EnemyRadius[i] := Random(50) + 50;
        EnemyAngles[i] := Random * 2 * Pi;
        UpdateEnemyPosition(i);
        EnemyColors[i] := RGBToColor(Random(256), Random(256), Random(256)); // Change color on hit
        Break;
      end;
    end;
  end;
end;

procedure TForm1.Render;
var
  i: Integer;
begin
  with Canvas do
  begin
    // Clear screen
    Brush.Color := clBlack;
    FillRect(ClientRect);

    // Draw Player
    Brush.Color := clWhite;
    FillRect(Player);

    // Draw Missile
    if MissileFired then
    begin
      Brush.Color := clRed;
      FillRect(Missile);
    end;

    // Draw Enemies
    for i := 1 to 20 do
    begin
      Brush.Color := EnemyColors[i];
      Ellipse(Enemies[i]);
    end;
  end;
end;

procedure TForm1.MoveEnemies;
var
  i: Integer;
begin
  for i := 1 to 20 do
  begin
    // Update angle for elliptical movement
    EnemyAngles[i] := EnemyAngles[i] + 0.05;
    if EnemyAngles[i] > 2 * Pi then
      EnemyAngles[i] := EnemyAngles[i] - 2 * Pi;

    // Update enemy position
    UpdateEnemyPosition(i);

    // Move enemy center downwards
    Inc(EnemyCenters[i].Y, 1);
    if EnemyCenters[i].Y > Height then
      EnemyCenters[i].Y := -20;
  end;
end;

procedure TForm1.CheckGameOver;
var
  i: Integer;
  ExpandedPlayer, Intersection: TRect;
begin
  ExpandedPlayer := Player;
  InflateRect(ExpandedPlayer, 5, 5); // プレイヤーの当たり判定領域を拡大

  for i := 1 to 20 do
  begin
    if IntersectRect(Intersection, ExpandedPlayer, Enemies[i]) then
    begin
      GameOver := True;
      Break;
    end;
  end;
end;

procedure TForm1.UpdateEnemyPosition(Index: Integer);
var
  CenterX, CenterY: Integer;
begin
  CenterX := EnemyCenters[Index].X + Round(EnemyRadius[Index] * Cos(EnemyAngles[Index]));
  CenterY := EnemyCenters[Index].Y + Round(EnemyRadius[Index] * Sin(EnemyAngles[Index]));

  Enemies[Index] := Rect(CenterX - 15, CenterY - 15, CenterX + 15, CenterY + 15); // 敵のサイズを大きくする
end;

end.
