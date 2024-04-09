unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);

var
  i, j, result: Integer;

begin
  // メモリコンポーネントをクリア
  Memo1.Clear;

  // かけ算の九九を計算してMemo1に表示
  for i := 1 to 9 do
  begin
    for j := 1 to 9 do
    begin
      result := i * j;
      Memo1.Lines.Add(Format('%d x %d = %d', [i, j, result]));
    end;
  end;
end;
end.
