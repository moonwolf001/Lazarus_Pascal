// Game Over 処理
unit Unit1;

interface

// ... [他のインターフェース宣言]

type
  TForm1 = class(TForm)
    // ... [他のコンポーネント宣言]
  private
    GameOver: Boolean; // ゲームオーバー状態を追跡
    // ... [他のプライベート宣言]

    procedure DisplayGameOverMessage; // ゲームオーバーメッセージを表示する手続き

    // ... [他の手続き及び関数宣言]
  public
    // ... [パブリック宣言]
  end;

var
  Form1: TForm1;

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ... [初期化コード]
  GameOver := False; // ゲームオーバー状態を初期化
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // ... [その他のタイマー関連コード]

  // ゲームオーバー条件をチェック
  if FunctionRepeatCount >= 2 then
  begin
    GameOver := True; // ゲームオーバー状態を設定
    DisplayGameOverMessage; // ゲームオーバーメッセージを表示
    Timer1.Enabled := False; // タイマーを停止
    Exit; // 手続きから抜ける
  end;

  // ... [その他のタイマー関連コード]
end;

procedure TForm1.DisplayGameOverMessage;
begin
  // ゲームオーバーメッセージのフォントプロパティを設定
  Canvas.Font.Size := 30;
  Canvas.Font.Color := clyellow;

  // ゲームオーバーメッセージとスコアを画面中央に表示
  Canvas.TextOut((ClientWidth - Canvas.TextWidth('Game Over')) div 2, (ClientHeight div 2) - 50, 'Game Over');
  Canvas.TextOut((ClientWidth - Canvas.TextWidth('Your Score = ' + IntToStr(Score))) div 2, ClientHeight div 2, 'Your Score = ' + IntToStr(Score));
  Canvas.TextOut((ClientWidth - Canvas.TextWidth('Hit Space Key to replay')) div 2, (ClientHeight div 2) + 50, 'Hit Space Key to replay');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // ... [その他のキー処理コード]

  // ゲームオーバー後にスペースキーが押されたらゲームをリセット
  if (Key = VK_SPACE) and GameOver then
  begin
    Score := 0;
    FunctionRepeatCount := 0;
    GameOver := False; // ゲームオーバー状態をリセット
    Timer1.Enabled := True; // タイマーを再度有効にする
  end;
