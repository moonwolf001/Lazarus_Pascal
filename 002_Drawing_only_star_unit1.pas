// Canvasで星のみ描写
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    // フォームの中心に星を描画する手順です。
    procedure DrawStar;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// フォームが再描画を必要とする時に呼ばれます。
procedure TForm1.FormPaint(Sender: TObject);
begin
  DrawStar; // フォームの中心に星を描画します
end;

// フォームの中心に五芒星を描画します。
procedure TForm1.DrawStar;
const
  StarSize = 50; // 星のサイズ
  NumPoints = 5; // 星の点の数
var
  Points: array[0..9] of TPoint; // 星の点の格納配列
  i: Integer;
  Angle: Double;
begin
  // 星の点を計算します
  for i := 0 to NumPoints - 1 do
  begin
    Angle := -Pi / 2 + (i * 2 * Pi / NumPoints);
    Points[i * 2].X := Round(ClientWidth / 2 + StarSize * Cos(Angle));
    Points[i * 2].Y := Round(ClientHeight / 2 + StarSize * Sin(Angle));

    Angle := -Pi / 2 + ((i + 0.5) * 2 * Pi / NumPoints);
    Points[i * 2 + 1].X := Round(ClientWidth / 2 + StarSize * Cos(Angle) / 2);
    Points[i * 2 + 1].Y := Round(ClientHeight / 2 + StarSize * Sin(Angle) / 2);
  end;

  // 点を繋いで星を描画します。
  form1.color := clblack;
  Canvas.Pen.Color := clyellow; // 星の色
  Canvas.Pen.Width := 4;     // 星の線の幅
  Canvas.Brush.Style := bsClear; // ブラシスタイル
  Canvas.Polygon(Points); // 星を描画します。
end;

end.       
