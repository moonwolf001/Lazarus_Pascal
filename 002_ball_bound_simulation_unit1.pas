unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    BallX, BallY: Double;       // ボールの位置 (浮動小数点数型)
    BallSize: Integer;          // ボールのサイズ
    BallSpeedX, BallSpeedY: Double;  // ボールの速度 (浮動小数点数型)
    const
      Gravity = 0.1;            // 重力の強さを調整するための値
      InitialX = 100;           // ボールの初期X座標
      InitialY = 100;           // ボールの初期Y座標
      InitialSpeedX = 2.5;      // ボールの初期X方向速度
      InitialSpeedY = 0;        // ボールの初期Y方向速度
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ボールの初期設定
  BallSize := 20;
  BallX := InitialX;
  BallY := InitialY;
  BallSpeedX := InitialSpeedX;
  BallSpeedY := InitialSpeedY;

  // タイマーを有効にする
  Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // 重力を適用してボールの速度を更新
  BallSpeedY := BallSpeedY + Gravity;

  // ボールの位置を更新
  BallX := BallX + BallSpeedX;
  BallY := BallY + BallSpeedY;

  // 画面端に到達したら反転
  if (BallX < 0) or (BallX + BallSize > ClientWidth) then
    BallSpeedX := -BallSpeedX;

  if (BallY < 0) or (BallY + BallSize > ClientHeight) then
  begin
    BallSpeedY := -BallSpeedY;
    // ボールが床に着いた場合、少し跳ねさせる
    BallY := ClientHeight - BallSize;
  end;

  // Form1を再描画
  Invalidate;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  // ボールを描画
  Canvas.Brush.Color := clRed;
  Canvas.Ellipse(Round(BallX), Round(BallY), Round(BallX + BallSize), Round(BallY + BallSize));
end;

end.
