// マウスクリック時の弾のビジュアル効果
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math;

type
  TForm1 = class(TForm)
    Timer1: TTimer; 

    // 以下太字の４つはオブジェクトインスペクターのイベント設定が必要
    // form1 の onCreate, onPaint , onMouseDown
    // timer1 の onTimer
    // 設定方法は、これらのイベントを見つけて右端の「…」を押す

    procedure FormCreate(Sender: TObject); 
    procedure FormPaint(Sender: TObject); 
    procedure Timer1Timer(Sender: TObject); 
    procedure FormMouseDown(
      Sender: TObject; 
      Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); 
  private

    // 弾丸の状態と位置を管理する変数。
    BulletActiveLeft, BulletActiveRight: Boolean;
    BulletXLeft, BulletYLeft: Integer;
    BulletXRight, BulletYRight: Integer;

    // スコアリングとターゲット位置の変数。
    TargetX, TargetY: Integer;
    Score: Integer;
    ShowTargetMark: Boolean;

    // 動的な弾丸の挙動に関する追加変数。
    BulletRadiusLeft, BulletRadiusRight: Integer; // 弾丸の半径。
    DeltaXLeft, DeltaYLeft: Integer; // 左の弾丸のフレームごとの移動。
    DeltaXRight, DeltaYRight: Integer; // 右の弾丸のフレームごとの移動。
    DeltaRadiusLeft, DeltaRadiusRight: Integer; // フレームごとの半径減少。

    procedure DrawAxes;
    procedure DrawGrid;
    procedure DrawBullet(const X, Y, Radius: Integer);
    procedure DrawTargetMark(const X, Y: Integer);

  public
  end;

var
  Form1: TForm1;

const

  // UI要素のための追加定数。

  AxisLabelFontColor = clWhite;
  AxisLabelFontSize = 8;
  ArrowSize = 10;
  GridColor = clGray;
  GridSpacing = 50;
  GridLabelFontSize = 8;

  TimerInterval = 40;

  // 弾丸の動きとゲームスコアリングのための定数。
  InitialBulletRadius = 50; // 弾丸の初期半径。
  FinalBulletRadius = 10;   // 弾丸の最終半径。
  BulletShrinkRate = 5;     // 弾丸が縮小する速度。
  BulletSpeed = 5;          // 弾丸の速度。
  HitTolerance = 10;        // ヒット判定の許容範囲。
  ScoreHit = 100;           // ヒットに対するポイント。
  ScoreMiss = -10;          // ミスに対するポイント減少。
  BulletColor = clRed;      // 弾丸の色。
  BulletBorderWidth = 5;    // 弾丸の外枠の幅。
  TargetHitTolerance = 15;  // ターゲットを打つための許容範囲。
  TargetMarkColor = clLime; // ターゲットマークの色。
  TargetMarkSize = 10;      // ターゲットマークのサイズ。
  TargetMarkAdjustX = 0;    // ターゲットマークのX座標調整。
  TargetMarkAdjustY = 0;    // ターゲットマークのY座標調整。
  TotalFrames = 20;         // 弾丸の移動のためのフレーム数。


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'Bullet moving effect using Lazarus (PASCAL) by MoonWolf - Dec 27, 2023, Version 1.00';
  Timer1.Interval := TimerInterval;
  Timer1.Enabled := True;
  BulletActiveLeft := False;
  BulletActiveRight := False;
  Score := 0;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(ClientRect);
  DrawGrid;
  DrawAxes;

  if BulletActiveLeft then
    DrawBullet(BulletXLeft, BulletYLeft, BulletRadiusLeft);
  if BulletActiveRight then
    DrawBullet(BulletXRight, BulletYRight, BulletRadiusRight);
  if ShowTargetMark then
    DrawTargetMark(TargetX + TargetMarkAdjustX, TargetY + TargetMarkAdjustY);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

  // 左の弾丸の動きを調整
  if BulletActiveLeft then
  begin
    BulletXLeft := BulletXLeft + DeltaXLeft;
    BulletYLeft := BulletYLeft + DeltaYLeft;
    BulletRadiusLeft := Max(BulletRadiusLeft - DeltaRadiusLeft, 10);

    if (Abs(BulletXLeft - TargetX) <= TargetHitTolerance) and
       (Abs(BulletYLeft - TargetY) <= TargetHitTolerance) then
    begin
      BulletActiveLeft := False;
      BulletXLeft := TargetX;
      BulletYLeft := TargetY;
      BulletRadiusLeft := 10;
      if not BulletActiveRight then
        ShowTargetMark := False;
    end;
  end;

  // 右の弾丸の動きを調整
  if BulletActiveRight then
  begin
    BulletXRight := BulletXRight + DeltaXRight;
    BulletYRight := BulletYRight + DeltaYRight;
    BulletRadiusRight := Max(BulletRadiusRight - DeltaRadiusRight, 10);

    if (Abs(BulletXRight - TargetX) <= TargetHitTolerance) and
       (Abs(BulletYRight - TargetY) <= TargetHitTolerance) then
    begin
      BulletActiveRight := False;
      BulletXRight := TargetX;
      BulletYRight := TargetY;
      BulletRadiusRight := 10;
      if not BulletActiveLeft then
        ShowTargetMark := False;
    end;
  end;

  Invalidate; // 画面を再描画
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  InitialBulletRadius = 100; // 弾丸の初期半径。
  FinalBulletRadius = 10;    // 弾丸の最終半径。
  TotalFrames = 10;          // 弾丸の移動のためのフレーム数。
begin
  TargetX := X; // クリックされた位置にターゲットX座標を設定。
  TargetY := Y; // クリックされた位置にターゲットY座標を設定。

  // フォームの左端で左の弾丸を初期化。
  BulletActiveLeft := True;
  BulletXLeft := 0; // 左端から開始。
  BulletYLeft := Form1.Height div 2; // 垂直中央から開始。
  BulletRadiusLeft := InitialBulletRadius; // 初期半径を設定。
  DeltaRadiusLeft := (InitialBulletRadius - FinalBulletRadius) div TotalFrames; // フレームごとの半径減少を設定。
  DeltaXLeft := (TargetX - BulletXLeft) div TotalFrames; // フレームごとの水平移動を設定。
  DeltaYLeft := (TargetY - BulletYLeft) div TotalFrames; // フレームごとの垂直移動を設定。

  // フォームの右端で右の弾丸を初期化。
  BulletActiveRight := True;
  BulletXRight := Form1.Width; // 右端から開始。
  BulletYRight := Form1.Height div 2; // 垂直中央から開始。
  BulletRadiusRight := InitialBulletRadius; // 初期半径を設定。
  DeltaRadiusRight := (InitialBulletRadius - FinalBulletRadius) div TotalFrames; // フレームごとの半径減少を設定。
  DeltaXRight := (TargetX - BulletXRight) div TotalFrames; // フレームごとの水平移動を設定。
  DeltaYRight := (TargetY - BulletYRight) div TotalFrames; // フレームごとの垂直移動を設定。

  ShowTargetMark := True; // クリックされた位置にターゲットマークを表示。
end;

// フォーム上に座標軸を描画。
procedure TForm1.DrawAxes;
begin
  // X軸とY軸を白で描画。
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(0, ClientHeight div 2);
  Canvas.LineTo(ClientWidth, ClientHeight div 2);
  Canvas.MoveTo(ClientWidth div 2, 0);
  Canvas.LineTo(ClientWidth div 2, ClientHeight);

  // 軸にラベルを付ける。
  Canvas.Font.Color := AxisLabelFontColor;
  Canvas.Font.Size := AxisLabelFontSize;
  Canvas.TextOut(ClientWidth - 20, ClientHeight div 2 + 5, 'X');
  Canvas.TextOut(ClientWidth div 2 + 5, 5, 'Y');
  Canvas.TextOut(ClientWidth div 2 + 5, ClientHeight div 2 + 5, 'O');
end;

// フォーム上にグリッドを描画。
procedure TForm1.DrawGrid;
var
  i: Integer;
  GridX, GridY: Integer;
begin
  // グリッドの色と線幅を設定。
  Canvas.Pen.Color := GridColor;
  Canvas.Pen.Width := 1;
  Canvas.Font.Size := GridLabelFontSize;

  // X軸に沿ってグリッド線を描画し、それらにラベルを付ける。
  for i := -ClientWidth div 2 to ClientWidth div 2 do
  begin
    if (i mod GridSpacing = 0) and (i <> 0) then
    begin
      GridX := i + (ClientWidth div 2);
      Canvas.MoveTo(GridX, 0);
      Canvas.LineTo(GridX, ClientHeight);
      Canvas.TextOut(GridX - 10, ClientHeight div 2 + 5, IntToStr(i));
    end;
  end;

  // Y軸に沿ってグリッド線を描画し、それらにラベルを付ける。
  for i := -ClientHeight div 2 to ClientHeight div 2 do
  begin
    if (i mod GridSpacing = 0) and (i <> 0) then
    begin
      GridY := i + (ClientHeight div 2);
      Canvas.MoveTo(0, GridY);
      Canvas.LineTo(ClientWidth, GridY);
      Canvas.TextOut(ClientWidth div 2 + 5, GridY - 10, IntToStr(-i));
    end;
  end;
end;

// 指定された位置に指定された半径の弾丸を描画。
procedure TForm1.DrawBullet(const X, Y, Radius: Integer);
begin
  // 弾丸の色と境界線の幅を設定。
  Canvas.Pen.Color := BulletColor;
  Canvas.Pen.Width := BulletBorderWidth;
  Canvas.Brush.Style := bsClear;

  // 弾丸を楕円として描画。
  Canvas.Ellipse(X - Radius, Y - Radius, X + Radius, Y + Radius);
end;

// 指定された位置にターゲットマークを描画。
procedure TForm1.DrawTargetMark(const X, Y: Integer);
begin
  // ターゲットマークの色を設定。
  Canvas.Pen.Color := TargetMarkColor;

  // ターゲットマークを表すために水平および垂直線を描画。
  Canvas.MoveTo(X - TargetMarkSize, Y);
  Canvas.LineTo(X + TargetMarkSize, Y);
  Canvas.MoveTo(X, Y - TargetMarkSize);
  Canvas.LineTo(X, Y + TargetMarkSize);
end;

end.
