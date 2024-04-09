unit Unit1;

////////////////////////////////////////////////////////
/// Programed by MoonWolf with ChatGPT4
/// (c)2023MoonWolf
/// Program 1 : Yoko Scroll Game
///『ChatGPT PASCAL GAME Vol.1』 Amazon Kindle
/// Amazon link   : amazon.co.jp/MoonWolf/e/B0CD3151FX
/// Twitter(X)    : MoonWolf_001
////////////////////////////////////////////////////////

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math;

const
  NumStars = 100; // 星の数
  MaxStarRadius = 5; // 星の最大半径
  MinStarRadius = 2; // 星の最小半径
  MaxStarSpeed = 3; // 星の最大速度
  MinStarSpeed = 1; // 星の最小速度
  TimerInterval = 20; // タイマーの間隔（ミリ秒）

  PlayerSize = 30; // プレイヤーの機体の大きさ
  BeamWidth = 5;   // 弾の幅
  BeamLength = 23; // 弾の長さ
  EnemySpeedMax = 10; // 敵の最大速度
  EnemySpeedMin = 3; // 敵の最小速度
  MaxBeams = 5; // 弾の最大数
  BeamSpeed = 15; // 弾の速度

  NumEnemies = 55; // 敵の数
  MinEnemySize = 20; // 敵の最小サイズ
  MaxEnemySize = 70; // 敵の最大サイズ

  CollisionMargin = 20; // 当たり判定の余裕（小さいほど厳しい）

type
  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
  private
    type
      TStar = record
        X, Y: Integer;
        Radius: Integer;
        Speed: Integer;
        Color: TColor;
      end;

      TPlayer = record
        X, Y: Integer;
      end;

      TBeam = record
        X, Y: Integer;
        Active: Boolean;
      end;

      TEnemy = record
        X, Y, Size, Speed: Integer;
        Color: TColor;
        Active: Boolean;
      end;

    var
      FStars: array of TStar;
      FPlayer: TPlayer;
      FBeams: array[0..MaxBeams - 1] of TBeam;
      FEnemies: array[0..NumEnemies - 1] of TEnemy;
      FGameOver: Boolean;

    procedure InitializeStars;
    procedure MoveStars;
  public
    { public declarations }
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
  Caption := '横スクロールゲーム Programed by MoonWolf with ChatGPT4 2023';
  Color := clBlack;
  InitializeStars;
  Timer1.Interval := TimerInterval;
  FGameOver := False;

  FPlayer.X := Width div 2;
  FPlayer.Y := Height div 2;

  for i := 0 to High(FBeams) do
    FBeams[i].Active := False;

  for i := 0 to High(FEnemies) do
    with FEnemies[i] do
    begin
      X := Width + Random(100);
      Y := Random(Height);
      Size := Random(MaxEnemySize - MinEnemySize + 1) + MinEnemySize;
      Speed := Random(EnemySpeedMax - EnemySpeedMin + 1) + EnemySpeedMin;
      Color := RGBToColor(Random(256), Random(256), Random(256));
      Active := True;
    end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FPlayer.X := X;
  FPlayer.Y := Y;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to High(FStars) do
    with Canvas, FStars[i] do
    begin
      Brush.Color := Color;
      Ellipse(X - Radius, Y - Radius, X + Radius, Y + Radius);
    end;

  with Canvas do
  begin
    Brush.Color := clWhite;
    Ellipse(FPlayer.X - PlayerSize div 2, FPlayer.Y - PlayerSize div 2,
            FPlayer.X + PlayerSize div 2, FPlayer.Y + PlayerSize div 2);

    Brush.Color := clBlue;
    Ellipse(FPlayer.X - PlayerSize div 4, FPlayer.Y - PlayerSize div 4,
            FPlayer.X + PlayerSize div 4, FPlayer.Y + PlayerSize div 4);

    for i := 0 to High(FBeams) do
      if FBeams[i].Active then
      begin
        Brush.Color := clWhite;
        Rectangle(FBeams[i].X, FBeams[i].Y - BeamWidth, FBeams[i].X + BeamLength, FBeams[i].Y + BeamWidth);
      end;

    for i := 0 to High(FEnemies) do
      with FEnemies[i] do
        if Active then
        begin
          Brush.Color := Color;
          Rectangle(X - Size div 2, Y - Size div 2, X + Size div 2, Y + Size div 2);
        end;

    if FGameOver then
    begin
      Font.Size := 20;
      Font.Color := clRed;
      TextOut(Width div 2 - 50, Height div 2, 'Game Over');
    end;
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  i: Integer;
begin
  if Key = ' ' then
  begin
    for i := 0 to High(FBeams) do
      if not FBeams[i].Active then
      begin
        FBeams[i].X := FPlayer.X + PlayerSize div 2;
        FBeams[i].Y := FPlayer.Y;
        FBeams[i].Active := True;
        Break;
      end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i, j: Integer;
begin
  // ゲームオーバーの場合、処理を行わない
  if FGameOver then Exit;

  // 星の移動
  MoveStars;

  // 弾の移動と敵への当たり判定
  for i := 0 to High(FBeams) do
    if FBeams[i].Active then
    begin
      FBeams[i].X := FBeams[i].X + BeamSpeed;

      // 画面外に出たら弾を非表示に
      if FBeams[i].X > Width then
        FBeams[i].Active := False;

      // 敵との当たり判定
      for j := 0 to High(FEnemies) do
        with FEnemies[j] do
          if Active and (FBeams[i].X + BeamLength > X - Size div 2) and
             (FBeams[i].X < X + Size div 2) and
             (FBeams[i].Y > Y - Size div 2) and
             (FBeams[i].Y < Y + Size div 2) then
          begin
            Active := False; // 敵を非表示にする
            FBeams[i].Active := False; // 弾も非表示にする
            Break;
          end;
    end;

  // 敵の移動
  for j := 0 to High(FEnemies) do
  with FEnemies[j] do
  begin
    if Active then
    begin
      X := X - Speed;
      if X < -Size then
        Active := False; // 画面外に出たら非表示に
    end
    else
    begin
      // 再出現
      X := Width + Random(100);
      Y := Random(Height);
      Size := Random(MaxEnemySize - MinEnemySize + 1) + MinEnemySize;
      Speed := Random(EnemySpeedMax - EnemySpeedMin + 1) + EnemySpeedMin;
      Color := RGBToColor(Random(256), Random(256), Random(256));
      Active := True;
    end;
  end;

  // プレイヤーと敵の当たり判定（ゲームオーバーのチェック）
  for j := 0 to High(FEnemies) do
  with FEnemies[j] do
    if Active and
       (FPlayer.X + PlayerSize div 2 > X - Size div 2) and
       (FPlayer.X - PlayerSize div 2 < X + Size div 2) and
       (FPlayer.Y + PlayerSize div 2 > Y - Size div 2) and
       (FPlayer.Y - PlayerSize div 2 < Y + Size div 2) then
    begin
      FGameOver := True;
      Break;
    end;

  Invalidate;
end;



procedure TForm1.InitializeStars;
var
  i: Integer;
begin
  SetLength(FStars, NumStars);

  for i := 0 to High(FStars) do
  with FStars[i] do
  begin
    X := Random(Width);
    Y := Random(Height);
    Radius := Random(MaxStarRadius - MinStarRadius + 1) + MinStarRadius;
    Speed := Random(MaxStarSpeed - MinStarSpeed + 1) + MinStarSpeed;
    if Random(2) = 0 then
      Color := clYellow
    else
      Color := clWhite;
  end;
end;

procedure TForm1.MoveStars;
var
  i: Integer;
begin
  for i := 0 to High(FStars) do
  with FStars[i] do
  begin
    X := X - Speed;
    if X < -20 then
      X := Width + 20;
  end;
end;

end.
