// 星が数学の関数にしたがってXY座標平面を移動するロジック
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math;

type
  TForm1 = class(TForm)
    Timer1: TTimer;

    // 以下の３つはオブジェクトインスペクターのイベントの設定が必要です
    // Form1 にて、onCreate , onPaint
    // Timer1 にて、onTimer

    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    StarX: Integer;
    CurrentFunctionIndex: Integer;
    procedure DrawStar(const CenterX, CenterY, Size: Integer;
                       const LineColor: TColor; const LineWidth: Integer);
    procedure DrawAxes;
    procedure DrawGrid;
    procedure DrawFunctionText;
    procedure DrawStarCoordinates(X, Y: Integer);
    function CalculateY(X: Integer): Integer;
  public
  end;

var
  Form1: TForm1;

const
  StarSize = 20;
  StarColor = clYellow;
  StarLineWidth = 2;
  GraphScale = 50;
  GraphFunctions: array[0..4] of Integer = (0, 1, 2, 3, 4);
  FunctionTexts: array[0..4] of string = (
    'Y = 0.0077 * X^2 - 150',
    'Y = |0.5 * X + 100|',
    'Y = 150 * Sin(0.03 * X)',
    'Y = 7000 / X (X ≠ 0)',
    'Y = 20 * tan(0.0099 * X) (cos(0.0099X) ≠ 0)'
  );
  FunctionTextFontColor = clWhite;
  FunctionTextFontSize = 25;
  FunctionTextPositionX = 10;
  FunctionTextPositionY = 400;
  AxisLabelFontColor = clWhite;
  AxisLabelFontSize = 8;
  ArrowSize = 10;
  GridColor = clGray;
  GridSpacing = 50;
  GridLabelFontSize = 8;
  GridLabelPositionY = 420;
  GridLabelPositionX = 10;
  TimerInterval = 40;
  StarMoveStep = 5;
  StarCoordFontColor = clWhite;
  StarCoordFontSize = 25;
  StarCoordPositionX = 10;
  StarCoordPositionY = 450;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  StarX := -ClientWidth div 2;
  CurrentFunctionIndex := 0;
  Timer1.Interval := TimerInterval;
  Timer1.Enabled := True;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  StarY: Integer;
begin
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(ClientRect);
  DrawGrid;
  DrawAxes;
  DrawFunctionText;

  StarY := CalculateY(StarX) + (ClientHeight div 2);
  DrawStar(StarX + (ClientWidth div 2), StarY, StarSize, StarColor, StarLineWidth);
  DrawStarCoordinates(StarX, StarY);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Inc(StarX, StarMoveStep);
  if StarX > ClientWidth div 2 then
  begin
    StarX := -ClientWidth div 2;
    CurrentFunctionIndex := (CurrentFunctionIndex + 1) mod Length(GraphFunctions);
  end;
  Invalidate;
end;

procedure TForm1.DrawStar(const CenterX, CenterY, Size: Integer;
                          const LineColor: TColor; const LineWidth: Integer);
var
  Points: array[0..9] of TPoint;
  i: Integer;
  Angle: Double;
begin
  for i := 0 to 4 do
  begin
    Angle := -Pi / 2 + (i * 2 * Pi / 5);
    Points[i * 2].X := CenterX + Round(Size * Cos(Angle));
    Points[i * 2].Y := CenterY + Round(Size * Sin(Angle));

    Angle := -Pi / 2 + ((i + 0.5) * 2 * Pi / 5);
    Points[i * 2 + 1].X := CenterX + Round(Size * Cos(Angle) / 2);
    Points[i * 2 + 1].Y := CenterY + Round(Size * Sin(Angle) / 2);
  end;

  Canvas.Pen.Color := LineColor;
  Canvas.Pen.Width := LineWidth;
  Canvas.Brush.Style := bsClear;

  Canvas.MoveTo(Points[0].X, Points[0].Y);
  for i := 1 to 10 do
  begin
    Canvas.LineTo(Points[i mod 10].X, Points[i mod 10].Y);
  end;
end;

procedure TForm1.DrawAxes;
begin
  Canvas.Pen.Color := clWhite;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(0, ClientHeight div 2);
  Canvas.LineTo(ClientWidth, ClientHeight div 2);
  Canvas.MoveTo(ClientWidth div 2, 0);
  Canvas.LineTo(ClientWidth div 2, ClientHeight);

  Canvas.Font.Color := AxisLabelFontColor;
  Canvas.Font.Size := AxisLabelFontSize;
  Canvas.TextOut(ClientWidth - 20, ClientHeight div 2 + 5, 'X');
  Canvas.TextOut(ClientWidth div 2 + 5, 5, 'Y');
  Canvas.TextOut(ClientWidth div 2 + 5, ClientHeight div 2 + 5, 'O');
end;

procedure TForm1.DrawGrid;
var
  i: Integer;
  GridX, GridY: Integer;
begin
  Canvas.Pen.Color := GridColor;
  Canvas.Pen.Width := 1;
  Canvas.Font.Size := GridLabelFontSize;

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

procedure TForm1.DrawFunctionText;
begin
  Canvas.Font.Color := FunctionTextFontColor;
  Canvas.Font.Size := FunctionTextFontSize;
  Canvas.TextOut(FunctionTextPositionX, FunctionTextPositionY, FunctionTexts[CurrentFunctionIndex]);
end;

procedure TForm1.DrawStarCoordinates(X, Y: Integer);
var
  CoordText: String;
begin
  Y := -Y + (ClientHeight div 2); // convert math coordinate plane
  Canvas.Font.Color := StarCoordFontColor;
  Canvas.Font.Size := StarCoordFontSize;
  CoordText := Format('(X=%d, Y=%d)', [X, Y]);
  Canvas.TextOut(StarCoordPositionX, StarCoordPositionY, CoordText);
end;

function TForm1.CalculateY(X: Integer): Integer;
var
  XValue: Double;
begin

  case GraphFunctions[CurrentFunctionIndex] of
    0: Result := Round(0.0077 * Power(X, 2)-150);
    1: Result := Round(Abs(0.5 * X +100 ));
    2: Result := Round(150 * Sin(0.03 * X));
    3: if X <> 0 then
         //Result := Round(7000 / X)
         Result := Round(9000 / X)

       else
         Result := 0;
    4: if Cos(2 + X) <> 0 then
         Result := Round(10*Sin(0.0099 * X) / Cos(0.0099 * X))
       else
         Result := 0;
  else
    Result := 0;
  end;
  Result := - Result; // From1's Y direction is downward
end;

end.
