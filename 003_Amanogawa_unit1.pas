unit Unit1;
/////////////////////////////////////////////////////////////
/// 天の川シミュレーション
/// Version 0.01
/// ChatGPT4 アシストにより作成
/// Lazarus( 言語：PASCAL ) by MoonWolf(むーん)うるふ
/// 2023年12月13日
/////////////////////////////////////////////////////////////

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, Math;

type
  { TForm1 }
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    Stars: array of record
      X, Y, Z, Speed, Size: Double; // 星の位置、速度、サイズ
    end;
    ViewAngleX, ViewAngleY: Double; // 視点の角度
    Zoom: Double; // ズームレベル
    LastMouseX, LastMouseY: Integer; // 最後のマウス位置
    procedure InitializeStars;
    procedure RotateStars;
    procedure DrawStars;
    procedure UpdateViewAngle(DeltaX, DeltaY: Integer);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
  NumStars = 2000;             // 星の数
  GalaxyRadius = 400;          // 銀河の半径
  GalaxyThickness = 100;       // 銀河の厚さ
  InitialZoom = 1.0;           // 初期ズームレベル
  MinStarSize = 1;             // 最小の星のサイズ
  MaxStarSize = 3;             // 最大の星のサイズ
  StarDensityFactor = 1.5;     // 星の密度係数（中心に近いほど密）
  MinRotationSpeed = 0.0005;   // 最小の回転速度
  MaxRotationSpeed = 0.0015;   // 最大の回転速度

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Timer1.Interval := 50;
  Timer1.Enabled := True;
  Color := clBlack;
  SetLength(Stars, NumStars);
  InitializeStars;
  ViewAngleX := 0;
  ViewAngleY := 0;
  Zoom := InitialZoom;
end;

procedure TForm1.InitializeStars;
var
  i: Integer;
  Theta, Radius, DensityFactor, SpeedFactor: Double;
begin
  Randomize;
  for i := 0 to High(Stars) do
  begin
    Theta := Random * 2 * Pi;
    Radius := Random * GalaxyRadius;
    DensityFactor := Power((GalaxyRadius - Radius) / GalaxyRadius, StarDensityFactor);
    SpeedFactor := MinRotationSpeed + (Radius / GalaxyRadius) * (MaxRotationSpeed - MinRotationSpeed);
    Stars[i].X := Radius * Cos(Theta);
    Stars[i].Y := Radius * Sin(Theta);
    Stars[i].Z := (Random - 0.5) * GalaxyThickness * DensityFactor;
    Stars[i].Speed := SpeedFactor;
    Stars[i].Size := MinStarSize + Random * (MaxStarSize - MinStarSize);
  end;
end;

procedure TForm1.RotateStars;
var
  i: Integer;
  NewX, NewY: Double;
begin
  for i := 0 to High(Stars) do
  begin
    NewX := Stars[i].X * Cos(Stars[i].Speed) - Stars[i].Y * Sin(Stars[i].Speed);
    NewY := Stars[i].X * Sin(Stars[i].Speed) + Stars[i].Y * Cos(Stars[i].Speed);
    Stars[i].X := NewX;
    Stars[i].Y := NewY;
  end;
end;

procedure TForm1.DrawStars;
var
  i: Integer;
  ScreenX, ScreenY, StarSize: Integer;
  CosX, SinX, CosY, SinY: Double;
begin
  CosX := Cos(ViewAngleX);
  SinX := Sin(ViewAngleX);
  CosY := Cos(ViewAngleY);
  SinY := Sin(ViewAngleY);

  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(0, 0, Width, Height);

  Canvas.Brush.Color := clWhite;
  for i := 0 to High(Stars) do
  begin
    StarSize := Round(Stars[i].Size);
    ScreenX := Round((Width / 2) + Zoom * (Stars[i].X * CosY - Stars[i].Z * SinY));
    ScreenY := Round((Height / 2) + Zoom * (Stars[i].X * SinX * SinY + Stars[i].Y * CosX + Stars[i].Z * CosY * SinX));
    Canvas.FillRect(ScreenX, ScreenY, ScreenX + StarSize, ScreenY + StarSize);
  end;
end;

procedure TForm1.UpdateViewAngle(DeltaX, DeltaY: Integer);
begin
  ViewAngleX := ViewAngleX + DeltaY * 0.01;
  ViewAngleY := ViewAngleY + DeltaX * 0.01;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LastMouseX := X;
  LastMouseY := Y;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    UpdateViewAngle(X - LastMouseX, Y - LastMouseY);
    LastMouseX := X;
    LastMouseY := Y;
  end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Zoom := Zoom + WheelDelta / 1200;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  RotateStars;
  DrawStars;
end;

end.
