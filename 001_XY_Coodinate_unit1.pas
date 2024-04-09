// XY座標平面＋グリッドの描写
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    procedure DrawAxes;
    procedure DrawGrid;
    procedure DrawAxisNumbers;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// フォームを初期化します。
procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'XY 座標平面';
end;

// フォームの描画を処理します。
procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color := clBlack; // 背景色を黒に設定
  Canvas.FillRect(ClientRect);   // フォームを背景色で塗りつぶす
  DrawGrid;                      // グリッドを描画
  DrawAxes;                      // 座標軸を描画
  DrawAxisNumbers;               // 座標軸に数値を描画
end;

// X軸とY軸をラベルと矢印付きで描画します。
procedure TForm1.DrawAxes;
const
  ArrowSize = 10; // 軸の矢印のサイズ
begin
  Canvas.Pen.Color := clWhite; // 軸のペンの色を白に設定
  Canvas.Pen.Width := 2;       // 軸のペンの幅を設定
  Canvas.Font.Color := clWhite; // ラベルのフォント色を白に設定

  // X軸を描画
  Canvas.MoveTo(0, ClientHeight div 2);
  Canvas.LineTo(ClientWidth, ClientHeight div 2);
  // X軸の矢印を描画
  Canvas.LineTo(ClientWidth - ArrowSize, (ClientHeight div 2) - ArrowSize);
  Canvas.MoveTo(ClientWidth, ClientHeight div 2);
  Canvas.LineTo(ClientWidth - ArrowSize, (ClientHeight div 2) + ArrowSize);

  // Y軸を描画
  Canvas.MoveTo(ClientWidth div 2, ClientHeight);
  Canvas.LineTo(ClientWidth div 2, 0);
  // Y軸の矢印を描画
  Canvas.LineTo((ClientWidth div 2) - ArrowSize, ArrowSize);
  Canvas.MoveTo(ClientWidth div 2, 0);
  Canvas.LineTo((ClientWidth div 2) + ArrowSize, ArrowSize);

  // 軸のラベルを描画
  Canvas.TextOut(ClientWidth - 20, ClientHeight div 2 + 5, 'X');
  Canvas.TextOut(ClientWidth div 2 + 5, 10, 'Y');
  Canvas.TextOut(ClientWidth div 2 + 5, ClientHeight div 2 + 5, 'O');
end;

// フォーム上にグリッドを描画します。
procedure TForm1.DrawGrid;
var
  i: Integer;
  GridSpacing: Integer = 50; // グリッド線の間隔
begin
  Canvas.Pen.Color := clGray; // グリッド線のペンの色を灰色に設定
  Canvas.Pen.Width := 1;      // グリッド線のペンの幅を設定

  // グリッド線を描画
  for i := -ClientWidth div 2 to ClientWidth div 2 do
  begin
    if (i mod GridSpacing = 0) and (i <> 0) then
    begin
      Canvas.MoveTo(i + (ClientWidth div 2), 0);
      Canvas.LineTo(i + (ClientWidth div 2), ClientHeight);
      Canvas.MoveTo(0, i + (ClientHeight div 2));
      Canvas.LineTo(ClientWidth, i + (ClientHeight div 2));
    end;
  end;
end;

// 50単位ごとに軸上に数値を描画します。
procedure TForm1.DrawAxisNumbers;
var
  i: Integer;
  GridSpacing: Integer = 50; // 数値を描画するグリッド線の間隔
begin
  Canvas.Font.Color := clWhite; // 数値のフォント色を白に設定

  // X軸に沿って数値を描画
  for i := -ClientWidth div 2 to ClientWidth div 2 do
  begin
    if (i mod GridSpacing = 0) and (i <> 0) then
    begin
      Canvas.TextOut(i + (ClientWidth div 2) - 10, (ClientHeight div 2) + 5, IntToStr(i));
    end;
  end;

  // Y軸に沿って数値を描画
  for i := -ClientHeight div 2 to ClientHeight div 2 do
  begin
    if (i mod GridSpacing = 0) and (i <> 0) then
    begin
      Canvas.TextOut((ClientWidth div 2) + 5, i + (ClientHeight div 2) - 10, IntToStr(-i));
    end;
  end;
end;

end. 
