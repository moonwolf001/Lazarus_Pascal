//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
// 重要事項:
//
// 全著作権所有
// (c)2024 MoonWolf（むーんうるふ）
//
// プログラム: ChatGPT4による数学関数を使った2Dゲーム
// バージョン: 1.00
// 作成者: MoonWolf / ChatGPT4のアシスト
// Twitter: MoonWolf_001
// 開発環境: Window11 + Lazarus 2.2.6
// リリース日: 2024年2月18日
//
// 本プログラムを使用する際はこのコメントを削除しないでください。
// 削除すると著作権の侵害となる可能性があります。
// 本コメントが残っている限り、開発者MoonWolf(むーんうるふ)は、
// 教育目的にて、このプログラムを自由に利用することを許可します。
//
// 使用例: 個人的なプログラム学習、友人への見せること、
// 学校でのプレゼンテーション、
// 冬季または夏季休暇の自由課題としての提出、
// 卒業論文の参考資料、
// 教師がこのプログラムを使用して生徒に機能を見せること。
// MoonWolfの同意なしに自由に使用できます。
//
// プログラムは部分的に修正して、
// グラフの形状などをカスタマイズして構いません。
// 特に、Constセクションの定数定義を通じて、
// 様々な微調整が可能です。
//
// Lazarus公式ウェブサイト:
// https://lazarus-ide.org
//
// 参考図書:
//
// [1] 超入門 Lazarus( PASCAL ) 最初の一歩
// [2] きみもPASCALでWindowsゲームを作ってみないか？
// [3] ChatGPT4 PASCAL GAME
//
// 著者 MoonWolf JP. 2023年出版
// Kindle電子書籍およびペーパーバックで入手可能。
// Kindle Unlimited加入者は無料で読めます。
// https://www.amazon.co.jp/stores/MoonWolf/author/B0CD3151FX
//
// 免責事項:
// MoonWolfは、Windowsの知識、Lazarusのインストール、
// Lazarusに関する質問、発生するエラー、
// およびこれらに関連するその他の問題や
// 質問についてのサポートを提供しません。
// これらの問題をご自身で調査し解決してください。
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math, LCLType, Dialogs;

type
  TForm1 = class(TForm)
    Timer1: TTimer; 
    procedure FormCreate(Sender: TObject); 
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject); 
    procedure Timer1Timer(Sender: TObject); 
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); 
  private
    ShowHitMessage: Boolean; // ヒットメッセージを表示するかどうか
    HitMessageTimer: Integer; // ヒットメッセージの表示期間を管理
    FunctionRepeatCount: Integer; // 関数が繰り返された回数を追跡する変数
    GameOver: Boolean; // ゲームオーバー状態を追跡

    // 星の位置と現在の数学関数を追跡する変数
    StarX, StarY: Integer;
    CurrentFunctionIndex: Integer;

    // 弾丸の状態と位置を管理する変数
    BulletActiveLeft, BulletActiveRight: Boolean;
    BulletXLeft, BulletYLeft: Integer;
    BulletXRight, BulletYRight: Integer;

    // スコアリングとターゲット位置設定の変数
    TargetX, TargetY: Integer;
    Score: Integer;
    ShowTargetMark: Boolean;

    // 弾丸の動的な挙動を管理する追加の変数
    BulletRadiusLeft, BulletRadiusRight: Integer; // 弾丸の半径
    DeltaXLeft, DeltaYLeft: Integer; // 左の弾丸のフレームごとの移動
    DeltaXRight, DeltaYRight: Integer; // 右の弾丸のフレームごとの移動
    DeltaRadiusLeft, DeltaRadiusRight: Integer; // 半径の減少

    InitialMessageFontSize: Integer; // メッセージの初期フォントサイズ
    MaxHitMessageTimer: Integer; // メッセージの最大表示時間
    FirstClickOccurred: Boolean; // 最初のマウスクリックが発生したかどうかを追跡する変数

    // フォーム上にさまざまな要素を描画するための手続き
    procedure DisplayGameOverMessage;
    procedure DrawStar(const CenterX, CenterY, Size: Integer;
                       const LineColor: TColor; const LineWidth: Integer);
    procedure DrawAxes;
    procedure DrawGrid;
    procedure DrawFunctionText;
    procedure DrawStarCoordinates(X, Y: Integer);
    procedure DrawBullet(const X, Y, Radius: Integer);
    procedure DrawScore;
    procedure DrawTargetMark(const X, Y: Integer);

    // 数学関数に基づいてY座標を計算する関数
    function CalculateY(X: Integer): Integer;
  public
  end;

var
  Form1: TForm1;

const
  // グラフィカル要素とゲームメカニクスに関する定数
  StarSize = 20; // 星のサイズ
  StarColor = clYellow; // 星の色
  StarLineWidth = 7; // 星の輪郭の幅
  GraphScale = 100; // 関数のスケーリングファクター

  // ゲームで表現される数学関数の配列
  GraphFunctions: array[0..4] of Integer = (0, 1, 2, 3, 4);
  FunctionTexts: array[0..4] of string = (
    'Y = 0.0077 * X^2 - 150',
    'Y = |0.5 * X + 100|', 
    'Y = 150 * Sin(0.03 * X)', 
    'Y = 9000 / X (X ≠ 0)', 
    'Y = 10 * tan(0.0099 * X) (cos(0.0099X) ≠ 0)' 
  );

  // UI要素に関する追加の定数
  FunctionTextFontColor = clWhite; // 関数テキストのフォント色
  FunctionTextFontSize = 25; // 関数テキストのフォントサイズ
  FunctionTextPositionX = 10; // 関数テキスト位置のX座標
  FunctionTextPositionY = 400; // 関数テキスト位置のY座標
  AxisLabelFontColor = clWhite; // 軸ラベルのフォント色
  AxisLabelFontSize = 8; // 軸ラベルのフォントサイズ
  ArrowSize = 10; // 軸矢印のサイズ
  GridColor = clGray; // グリッド線の色
  GridSpacing = 50; // グリッド線の間隔
  GridLabelFontSize = 8; // グリッドラベルのフォントサイズ
  TimerInterval = 40; // ゲームタイマーの間隔
  StarMoveStep = 5; // 星の移動ステップサイズ
  StarCoordFontColor = clWhite; // 星座標のフォント色
  StarCoordFontSize = 25; // 星座標のフォントサイズ
  StarCoordPositionX = 10; // 星座標位置のX座標
  StarCoordPositionY = 450; // 星座標位置のY座標。
  HitMessageDuration = 14; // ヒットメッセージを表示するフレーム数
  InitialBulletRadius = 50; // 弾丸の初期半径
  FinalBulletRadius = 10; // 弾丸の最終半径
  BulletShrinkRate = 5; // 弾丸が縮小する率
  BulletSpeed = 5; // 弾丸の速度
  HitTolerance = 15; // ヒット検出の許容範囲
  ScoreHit = 100; // ヒットに対するポイント
  ScoreMiss = -10; // ミスに対するポイント減点
  BulletColor = clRed; // 弾丸の色
  BulletBorderWidth = 5; // 弾丸の輪郭の幅
  TargetHitTolerance = 15; // 当たり判定の許容範囲
  TargetMarkColor = clLime; // ターゲットマーカーの色
  TargetMarkSize = 10; // ターゲットマーカーのサイズ
  TargetMarkAdjustX = 0; // ターゲットマーカーのX座標調整
  TargetMarkAdjustY = 0; // ターゲットマーカーのY座標調整
  TotalFrames = 20; // 弾丸の移動のためのフレーム数


implementation

{$R *.lfm}

{ TForm1 }

// フォームが作成されたときにゲーム設定を初期化し星を配置
procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'Simple 2D Game with Math function with GPT4 by MoonWolf - Jan 26, 2024, Version 1.00';
  StarX := -ClientWidth div 2;
  CurrentFunctionIndex := 0;
  Timer1.Interval := TimerInterval;
  Timer1.Enabled := True;
  BulletActiveLeft := False;
  BulletActiveRight := False;
  Score := 0;
  ShowHitMessage := False;
  HitMessageTimer := 0;

  InitialMessageFontSize := 120; // ヒットメッセージの初期フォントサイズ
  MaxHitMessageTimer := 15;   // ヒットメッセージの最大表示時間を設定
  FirstClickOccurred := False;   // 最初のマウスクリックが発生を追跡
  FunctionRepeatCount := 0;
  GameOver := False;
end;

// グリッド、軸、関数、星、弾丸、ターゲットマークを含むフォームを再描画
procedure TForm1.FormPaint(Sender: TObject);
var
  CurrentFontSize: Integer;
  TextPosX, TextPosY: Integer;
begin
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(ClientRect);
  DrawGrid;
  DrawAxes;
  DrawFunctionText;

  StarY := CalculateY(StarX) + (ClientHeight div 2);
  DrawStar(StarX + (
     ClientWidth div 2), StarY, StarSize, StarColor, StarLineWidth);
  DrawStarCoordinates(StarX, StarY);

  if BulletActiveLeft then
    DrawBullet(BulletXLeft, BulletYLeft, BulletRadiusLeft);
  if BulletActiveRight then
    DrawBullet(BulletXRight, BulletYRight, BulletRadiusRight);
  if ShowTargetMark then
    DrawTargetMark(TargetX + TargetMarkAdjustX, TargetY + TargetMarkAdjustY);
  DrawScore;

  if ShowHitMessage then
  begin
    CurrentFontSize := Max(
 12, InitialMessageFontSize * HitMessageTimer div MaxHitMessageTimer);
    Canvas.Font.Size := CurrentFontSize;
    Canvas.Font.Color := clWhite;
    Canvas.TextOut(
          StarX + (ClientWidth div 2) - CurrentFontSize * 2, 
          StarY + 20, 'Nice Hit!');
  end;
end;

// 星と弾丸の動き、スコアの更新、ゲームオーバー条件を処理
procedure TForm1.Timer1Timer(Sender: TObject);
var
  TextPosX, TextPosY: Integer;
begin
  // 星の独立した動き
  Inc(StarX, StarMoveStep);
  if StarX > ClientWidth div 2 then
  begin
    StarX := -ClientWidth div 2;
    Inc(CurrentFunctionIndex);
    if CurrentFunctionIndex >= Length(GraphFunctions) then
    begin
      CurrentFunctionIndex := 0;
      Inc(FunctionRepeatCount);
      if FunctionRepeatCount >= 2 then // ゲームオーバーの条件を設定
      begin
        GameOver := True;
        DisplayGameOverMessage; // ゲームオーバーメッセージを表示
        Timer1.Enabled := False; // タイマーを停止
        Exit; // これ以降のコードを実行しない
      end;
    end;
  end
  else if StarX < -ClientWidth div 2 then
  begin
    StarX := ClientWidth div 2;
    CurrentFunctionIndex := (CurrentFunctionIndex + 1) mod Length(GraphFunctions);
  end;

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

  // 弾丸の動きが終わった後にスコアを更新
  if (not BulletActiveLeft) and (not BulletActiveRight) and FirstClickOccurred then
  begin
    // ヒット検出
    if (Abs(StarX + (ClientWidth div 2) - TargetX) <= HitTolerance) and
       (Abs(StarY - TargetY) <= HitTolerance) then
    begin
      Score := Score + ScoreHit;
      ShowHitMessage := True; // ヒットメッセージを表示
      HitMessageTimer := HitMessageDuration; // メッセージ表示期間を設定
    end
    else
      Score := Score + ScoreMiss;

    // 弾丸を再活性化させない
    BulletActiveLeft := True;
    BulletActiveRight := True;
  end;

  if ShowHitMessage then
  begin
    Dec(HitMessageTimer);
    if HitMessageTimer <= 0 then
    begin
      ShowHitMessage := False;
    end;
  end;
  Invalidate; // 画面を再描画
end;

// マウスボタンが押されたときに弾丸を初期化し、軌道を設定
procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  InitialBulletRadius = 100; // 弾丸の初期半径
  FinalBulletRadius = 10;    // 弾丸の最終半径
  TotalFrames = 10;      // 弾丸の移動フレーム数
begin
  FirstClickOccurred := True; // マウスがクリックされたときにTrue設定

  TargetX := X; // クリックされた位置にターゲットX座標を設定
  TargetY := Y; // クリックされた位置にターゲットY座標を設定

  // フォームの左端で左の弾丸を初期化
  BulletActiveLeft := True;
  BulletXLeft := 0; // 左端から開始
  BulletYLeft := Form1.Height div 2; // 垂直中央から開始
  BulletRadiusLeft := InitialBulletRadius; // 初期半径を設定
  DeltaRadiusLeft := (InitialBulletRadius - FinalBulletRadius) div TotalFrames; // フレームごとの半径減少を設定
  DeltaXLeft := (TargetX - BulletXLeft) div TotalFrames; // フレームごとの水平移動を設定
  DeltaYLeft := (TargetY - BulletYLeft) div TotalFrames; // フレームごとの垂直移動を設定

  // フォームの右端で右の弾丸を初期化
  BulletActiveRight := True;
  BulletXRight := Form1.Width; // 右端から開始
  BulletYRight := Form1.Height div 2; // 垂直中央から開始
  BulletRadiusRight := InitialBulletRadius; // 初期半径を設定
  DeltaRadiusRight := (InitialBulletRadius - FinalBulletRadius) div TotalFrames; // フレームごとの半径減少を設定
  DeltaXRight := (TargetX - BulletXRight) div TotalFrames; // フレームごとの水平移動を設定
  DeltaYRight := (TargetY - BulletYRight) div TotalFrames; // フレームごとの垂直移動を設定

  ShowTargetMark := True; // クリックされた位置にターゲットマークを表示
end;

// 指定された位置に特定のサイズ、色、線幅で星を描画
procedure TForm1.DrawStar(const CenterX, CenterY, Size: Integer;
                          const LineColor: TColor; const LineWidth: Integer);
var
  Points: array[0..9] of TPoint; // 星の点を格納する配列
  i: Integer;
  Angle: Double;
begin
  // 星の点を計算
  for i := 0 to 4 do
  begin
    Angle := -Pi / 2 + (i * 2 * Pi / 5);
    Points[i * 2].X := CenterX + Round(Size * Cos(Angle));
    Points[i * 2].Y := CenterY + Round(Size * Sin(Angle));

    Angle := -Pi / 2 + ((i + 0.5) * 2 * Pi / 5);
    Points[i * 2 + 1].X := CenterX + Round(Size * Cos(Angle) / 2);
    Points[i * 2 + 1].Y := CenterY + Round(Size * Sin(Angle) / 2);
  end;

  // 点をつないで星を描画
  Canvas.Pen.Color := LineColor;
  Canvas.Pen.Width := LineWidth;
  Canvas.Brush.Style := bsClear;

  Canvas.MoveTo(Points[0].X, Points[0].Y);
  for i := 1 to 10 do
  begin
    Canvas.LineTo(Points[i mod 10].X, Points[i mod 10].Y);
  end;
end;

// フォーム上に座標軸を描画
procedure TForm1.DrawAxes;
begin
  // 白でX軸とY軸を描画
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(0, ClientHeight div 2);
  Canvas.LineTo(ClientWidth, ClientHeight div 2);
  Canvas.MoveTo(ClientWidth div 2, 0);
  Canvas.LineTo(ClientWidth div 2, ClientHeight);

  // 軸にラベルを付ける
  Canvas.Font.Color := AxisLabelFontColor;
  Canvas.Font.Size := AxisLabelFontSize;
  Canvas.TextOut(ClientWidth - 20, ClientHeight div 2 + 5, 'X');
  Canvas.TextOut(ClientWidth div 2 + 5, 5, 'Y');
  Canvas.TextOut(ClientWidth div 2 + 5, ClientHeight div 2 + 5, 'O');
end;

// フォーム上にグリッドを描画
procedure TForm1.DrawGrid;
var
  i: Integer;
  GridX, GridY: Integer;
begin
  // グリッドの色と線幅を設定
  Canvas.Pen.Color := GridColor;
  Canvas.Pen.Width := 1;
  Canvas.Font.Size := GridLabelFontSize;

  // X軸に沿ってグリッド線を描画し、それらにラベルを付ける
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

  // Y軸に沿ってグリッド線を描画し、それらにラベルを付ける
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

// フォーム上に現在の数学関数をテキストとして表示
procedure TForm1.DrawFunctionText;
begin
  // 関数テキストのフォント色とサイズを設定
  Canvas.Font.Color := FunctionTextFontColor;
  Canvas.Font.Size := FunctionTextFontSize;

  // 現在の関数インデックスに基づいて関数テキストを表示
  Canvas.TextOut(
       FunctionTextPositionX, FunctionTextPositionY,  
       FunctionTexts[CurrentFunctionIndex]);
end;

// 星の座標表示
procedure TForm1.DrawStarCoordinates(X, Y: Integer);
var
  CoordText: String;
begin
  // 星の座標をフォーマットして表示
  Y := -Y + (ClientHeight div 2); // 数学座標平面に変換
  Canvas.Font.Color := StarCoordFontColor;
  Canvas.Font.Size := StarCoordFontSize;
  CoordText := Format('(X=%d, Y=%d)', [X, Y]);
  Canvas.TextOut(StarCoordPositionX, StarCoordPositionY, CoordText);
end;

// 指定された位置、半径で弾丸を描画
procedure TForm1.DrawBullet(const X, Y, Radius: Integer);
begin
  // 弾丸の色と輪郭幅を設定
  Canvas.Pen.Color := BulletColor;
  Canvas.Pen.Width := BulletBorderWidth;
  Canvas.Brush.Style := bsClear;

  // 弾丸を楕円として描画
  Canvas.Ellipse(X - Radius, Y - Radius, X + Radius, Y + Radius);
end;

// スコアを表示します
procedure TForm1.DrawScore;
begin
  // スコアのフォント色とサイズを設定
  Canvas.Font.Color := clWhite;
  Canvas.Font.Size := 20;

  // スコアテキストを表示
  Canvas.TextOut(10, 10, 'Score: ' + IntToStr(Score));
end;

// クリックされた位置にターゲットマークを描画
procedure TForm1.DrawTargetMark(const X, Y: Integer);
begin
  // ターゲットマークの色を設定
  Canvas.Pen.Color := TargetMarkColor;

  // ターゲットマークを表すために水平および垂直線を描画
  Canvas.MoveTo(X - TargetMarkSize, Y);
  Canvas.LineTo(X + TargetMarkSize, Y);
  Canvas.MoveTo(X, Y - TargetMarkSize);
  Canvas.LineTo(X, Y + TargetMarkSize);
end;

// 与えられたX座標に基づいて現在の関数のY座標を計算
function TForm1.CalculateY(X: Integer): Integer;
begin

// 選択された関数に基づいてY座標を計算

  case GraphFunctions[CurrentFunctionIndex] of

      0: Result := Round(0.0077 * Power(X, 2)-150);
      1: Result := Round(Abs(0.5 * X +100 ));
      2: Result := Round(150 * Sin(0.03 * X));
      3: if X <> 0 then
           //Result := Round(7000 / X)
           Result := Round(9000 / X)
         else
           Result := 0;
      4: if Cos(0.0099 * X) <> 0 then
           Result := Round(10*Sin(0.0099 * X) / Cos(0.0099 * X))
         else
           Result := 0;
    else
      Result := 0;
    end;

    Result := - Result; // Form1のY方向は下向き補正


end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // ゲームオーバー後にスペースキーが押されたらゲームをリセット
  if (Key = VK_SPACE) and GameOver then
  begin
    Score := 0;
    FunctionRepeatCount := 0;
    GameOver := False;
    Timer1.Enabled := True;
  end;

  // 星を特定の位置に移動するショートカット
  // これは星の移動時間を短縮するための隠しコマンドです
  // 右カーソールを押すと星が右はしまでワープします

  if (Key = VK_Right) then
  begin
    StarX := 300;
  end;

end;

// ゲームオーバーメッセージを表示
procedure TForm1.DisplayGameOverMessage;
begin
  // ゲームオーバーメッセージのフォントプロパティを設定
  Canvas.Font.Size := 30;
  Canvas.Font.Color := clyellow;

  // 画面中央にゲームオーバーメッセージとスコアを表示

  Canvas.TextOut((
     ClientWidth - Canvas.TextWidth('Game Over')) div 2, 
     (ClientHeight div 2) - 50, 'Game Over');

  Canvas.TextOut((
     ClientWidth - Canvas.TextWidth('Your Score = '
    + IntToStr(Score))) div 2, ClientHeight div 2, 'Your Score = ' 
    + IntToStr(Score));

  Canvas.TextOut((
     ClientWidth - Canvas.TextWidth('Hit Space Key to replay')) div 2,
    (ClientHeight div 2) + 50, 'Hit Space Key to replay');

end;

end.
