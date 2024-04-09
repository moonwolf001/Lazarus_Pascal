//
// (c) 2023 MoonWolf 
// Book : https://www.amazon.co.jp/dp/B0CDSCVNC8
//

unit Unit1;
{$mode objfpc}{$H+}
interface
uses
  // VF keyのため　uses に　LCLTypeをマニュアルで追加
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,LCLType;
type
  TATE_bar_record = record     // たて四角のレコード型データを定義
    visible_flag : integer;   // 0 = 非表示 , 1 = 表示
    X            : integer;   // たて四角Imageの左上 X座標
    Y            : integer;   // たて四角Imageの左上 Y座標
    x_bar_cnt    : integer;   // たて四角のImageの中心 X座標
    y_bar_cnt    : integer;   // たて四角Imageの中心 Y座標
    x_bar_star   : integer;   // クリックしたときの、たて四角と星とのX座標の差
    y_bar_star   : integer;   // クリックしたときの、たて四角と星とのY座標の差
    x_delta      : integer;   // Timer2にて、このデルタの値で、星に近づける（X座標）
    y_delta      : integer;   // Timer2にて、このデルタの値で、星に近づける（Y座標）
    count        : integer;   // Timer2にて、このカウント回数、星に近づける動きを行う
    heght        : integer;   // たて四角Imageの高さ
    width        : integer;   // たて四角Imageの幅
    end;

  Aim_Score_record = record
    X            : integer;  // 当たり判定に使うX座標
    Y            : integer;  // 当たり判定に使うY座標
    count        : integer;  // 当たり判定後の「 Nice!! 」表示のカウント
    Score        : integer;  // スコア
    Comment    : string;   // コメント
    Treasure     : string;   // 今回の練習で得た宝物
  end;
  { TForm1 }
  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation
var
  X,Y              : integer; // Timer1, Timer2などで扱われる「純粋なXY座標」
  x_star, y_star   : integer; // 星のFrom1上での座標
  GM_Level         : integer; // ゲームのレベル
  Fx_name          : string ; // 現在描いている y=f(x)　を文字列で表したもの
  Tate_Bar         : array[1..5] of tate_bar_record ;  // レコード型配列
  x_mouse, y_mouse : integer; // マウスクリック時のForm1上のポインタのX,Y座標
  AIM_SCORE        : array[1..2] of Aim_Score_record ;    // レコード型配列
const
  x_cnt          = 363;          // image1 座標平面の原点のX座標
  y_cnt          = 190;          // image2 座標平面の原点のY座標
  bar_star_step  = 20;           // 四角と星を何回のSTEPで近づけるかを決める定数
  version        = 'Ver 1.00';   // プログラムのVersion管理
                                 // 2023.07,20 : Version 1.00  : プログラムのリリース
                                 //
                                 // 記入例
                                 // 2024.02.20 : Version 1.10  : 効果音を追加
                                 // 2025.03.18 : Version 2.00  : Timer1のGM_lv 11～50の関数を追加
{$R *.lfm}
{ TForm1 }
Procedure GAME_OVER_COMMENT ;  // GAME OVER時のコメント処理
var
  Item1    : array[1..10] of string;
  Item2    : array[1..10] of string;
  Mary     : array[1..10] of string;
  MoonWolf : array[1..10] of string;
  item1_name        : string;
  item2_name        : string;
  Mary_comment      : string;
  MoonWolf_Comment  : string;
begin
  // 取得アイテム１　候補
  item1[1]  := '不思議な鉱石';
  item1[2]  := '地球外の美しい宝石';
  item1[3]  := '地球外生物の化石';
  item1[4]  := '地球外植物の化石';
  item1[5]  := '希少価値の鉱石10ｇ';
  item1[6]  := '空間がゆがむ鉱石';
  item1[7]  := 'ほのかに温かい鉱石';
  item1[8]  := '宇宙人に目をつけられる鉱石';
  item1[9]  := 'いい香りがする鉱石';
  item1[10] := '良い音がする鉱石';
  // 取得アイテム２　候補
  item2[1]  := '5分透明チケット(2枚)';
  item2[2]  := '勇気10倍チケット(12枚)';
  item2[3]  := '新発見チケット(37枚)';
  item2[4]  := '数学力UPチケット(5枚)';
  item2[5]  := '宇宙旅行2泊3日(2枚)';
  item2[6]  := '10分間 未来社会体験(2枚)';
  item2[7]  := '動物と会話チケット(4枚)';
  item2[8]  := '空中散歩チケット(5枚)';
  item2[9]  := 'プログラミング力UP (10枚)';
  item2[10] := '瞬間移動チケット(3枚)';
  // Ｃ２２５メアリーからのコメント　候補
  Mary[1]   := 'つかれたでしょう？';
  Mary[2]   := 'コーヒーでも一緒に飲みましょう';
  Mary[3]   := 'なかなか、やるわね！';
  Mary[4]   := 'ミッション完了！';
  Mary[5]   := 'まだまだ、できるわ！';
  Mary[6]   := '良い一日が過ごせそうね';
  Mary[7]   := '時々私の事を思い出してね';
  Mary[8]   := 'いい感じね';
  Mary[9]   := 'まだまだ訓練が足りないわ';
  Mary[10]  := 'この様子では人類全滅ね.....';
  // MoonWolf隊長からのコメント　候補
  MoonWolf[1]  := 'いい感じだ！';
  MoonWolf[2]  := 'ナイス　チャレンジ！';
  MoonWolf[3]  := '見どころがあるな！';
  MoonWolf[4]  := '君のような人を待っていた！';
  MoonWolf[5]  := 'うん！　すばらしい！';
  MoonWolf[6]  := '私の部隊に入らないか？';
  MoonWolf[7]  := '君の努力は素晴らしい！';
  MoonWolf[8]  := 'いい未来が開けそうだ！';
  MoonWolf[9]  := '全く価値のある人間だぜ！';
  MoonWolf[10] := '素晴らしい集中力だな！';
  randomize;        // 乱数の初期化
  item1_name        := item1[   random(10)+1   ] ;   // ランダムでアイテム１決定
  item2_name        := item2[   random(10)+1   ] ;   // ランダムでアイテム２決定
  Mary_comment      := Mary[    random(10)+1   ] ;   // ランダムでメアリのコメント決定
  MoonWolf_Comment  := MoonWolf[  random(10)+1   ] ;   // ランダムで隊長のコメント決定

  // ゲーム終了時のMEMO１へのユーザーへのコメント
  form1.Memo1.Append( '=====================');
  form1.Memo1.Append( 'Your SCORE = ' + IntToStr(AIM_SCORE[1].Score) );
  form1.Memo1.Append( '');
  form1.Memo1.Append( '取得アイテム１つ目：');
  form1.Memo1.Append( item1_name  );
  form1.Memo1.Append( '');
  form1.Memo1.Append( '取得アイテム２つ目：');
  form1.Memo1.Append( item2_name );
  form1.Memo1.Append( '');
  form1.Memo1.Append( 'C225メアリーからのコメント：' );
  form1.Memo1.Append( Mary_comment );
  form1.Memo1.Append( '');
  form1.Memo1.Append( 'MoonWolf隊長からのコメント：' );
  form1.Memo1.Append( MoonWolf_Comment );
  form1.Memo1.Append( '======================');
// 画面に大きく GAME OVER文字と、諸データの表示    
  Form1.Label3.Font.Color := clYellow ;
  Form1.Label3.Visible := true ;
  Form1.Label3.top     := 45 ;
  Form1.Label3.left    := 100 ;
  Form1.Label3.Caption := '             << GAME OVER >>' + #13#10
            +   #13#10
            +  'YOUR SCORE = ' +  IntToStr(AIM_SCORE[1].Score)  + #13#10
            +  '取得アイテム 1 = ' + Item1_name +  #13#10
            +  '取得アイテム 2 = ' + Item2_name +  #13#10
            +  'C225メアリーのコメント： ' + Mary_Comment +  #13#10
            +  'MoonWolf隊長のコメント： ' + MoonWolf_Comment +  #13#10
            +   #13#10
            +   '         HIT SPACE KEY  to  RESTART !!' ;
AIM_SCORE[1].Score := 0; // リスタート時のスコア初期化
end;

Procedure AIM_Judgement ;  // 当たり判定
begin
  // // // 当たり判定の本体　（　以下のIf文　）// // //

  if ( ( abs( Form1.Image2.Left + 25 - AIM_SCORE[1].x ) < 25 ) and ( abs( Form1.Image2.Top + 25 - AIM_SCORE[1].y) < 30 ) ) = true then

    begin                          // 　<< 当たりの場合の処理ルーチン  >>
      //　＜開発者向け動作チェック＞
      // Form1.memo1.Append('判定 AIM X='+inttostr(AIM_SCORE[1].x)+' AIM Y='+inttostr(AIM_SCORE[1].y));
      // Form1.memo1.Append('判定 STR_X='+inttostr(form1.image2.Left) + ' STR_Y=' +inttostr(form1.image2.Top));
      // Form1.memo1.Append( 'HIT !! ' );
      ////////////////////////


      Form1.Label3.Font.Color := clYellow;    // Label3に黄色でNice!! とスコアを表示
      Form1.Label3.Visible := true;
      Form1.Label3.Left := AIM_SCORE[1].x;
      Form1.Label3.top := AIM_SCORE[1].y + 20;
      AIM_SCORE[1].count := 30;
      Form1.Label3.caption :='Nice!!' +#13#10 + '+' + inttostr(GM_Level*10);
      AIM_SCORE[1].Score := AIM_SCORE[1].Score + GM_Level*10 ;    // スコアの加算ロジック
      Form1.Label4.Caption := 'Score = ' + IntToStr( AIM_SCORE[1].Score );
      Form1.Memo1.Append('当たり：( ' + IntToStr(X) + ',' + IntToStr(Y)+' ) ' + IntToStr(GM_Level*10)+' 点 加算');
    end else
    begin                             //  <<　外れの場合の処理ルーチン  >>
      Form1.Label3.Font.Color := clRed;         // 赤色で Oh, No.. を表記
      Form1.Label3.Visible := true;
      Form1.Label3.Left := AIM_SCORE[1].x;
      Form1.Label3.top := AIM_SCORE[1].y + 20;
      AIM_SCORE[1].count := 30;
      Form1.Label3.caption :='Oh,No..' +#13#10 + '-10';
      AIM_SCORE[1].Score := AIM_SCORE[1].Score - 10 ;    // スコア減点ロジック
      Form1.Label4.Caption := 'Score = ' + IntToStr( AIM_SCORE[1].Score );
      Form1.Memo1.Append('外れ：( ' + IntToStr(X) + ',' + IntToStr(Y)+' ) ' + '- 10 点 減点');
    end;
end;

Procedure Label2_Display ;       // Label2にGM_Lv, y=f(x), X,Y座標表示
begin
  Form1.Label2.caption := '<< Game Level=' + IntToStr( GM_Level )
                                  + '>>    [ 　 関数　：　' + Fx_name  + '　 ]'
                                  + '  ( X = ' + IntToStr(X) + ' '
                                  + '    Y = ' + IntToStr(Y) + ' )';
end;

procedure TForm1.FormCreate(Sender: TObject);    // form1 create 時の初期化
begin
  KeyPreview               := True;      // Key 入力にはこれが必要！
  GM_Level                 := 1;         // Form1 開始時にゲームレベルを１とする
  X                        := -360;      // From1 開示時にX= -360 とする
  TATE_Bar[1].visible_flag := 0 ;        // たて四角１（左下）初期化　
  TATE_Bar[2].visible_flag := 0 ;        // たて四角１（右下）初期化　
  AIM_SCORE[1].count       := 0;         // 当たり判定時の「Nice!!」表示カウント
  Label3.Visible           := false;     // 当たり判定時の「Nice!!」非表示
  Panel2.Caption           := '';        // Panel2 という文字を消す
  Memo1.Caption            := '＜星型飛行物体の射撃訓練 '+ Version + '＞';   // プログラム起動時のMemo1表示
  Image3.Visible           := false;     // Image3(小さい丸)を消す
  Label4.Caption           := 'Score ='; // Label4 初期化
  Image5.Visible           := false;     // Image5(たて四角：上)を消す
  Label1.Caption           := 'メッセージ・ウィンドウ'; // Label1のゲーム向け表示
  Image2.Visible           := true;      // 星画像を見えるようにする
  Form1.Caption            := '関数移動の★ 射撃訓練 ' + Version + '    Created by MoonWolf 2023';
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState  );  // form1 key down イベント時の処理
begin
  ///  < 開発者向けデータ : キーボードの読み取りのサンプル　>
  //
  //  注意： 「　Uses に　LCLType　を加えること　」＋「 Form1 onCreate に  KeyPreview  := True; を入れること」
  //
  // if (Key = VK_RIGHT)or(Key = VK_p) then
  //  image3.Left := image3.Left + 1;
  //
  //  if Key = VK_LEFT then
  //  image3.Left := image3.Left - 1;
  //
  //  if Key = VK_UP then
  //  image3.top := image3.Top - 1;
  //
  //  if Key = VK_DOWN then
  //  image3.top := image3.Top + 1;
  ////////////////////////////

  if Key = VK_p then                    // 開発者向けImage2(星)のワープ
    X := 300 ;

  if ( Key = VK_SPACE ) and ( GM_Level = 11 ) then    // GAME OVER後、ReStartの受付
    begin
      // Restart用に、プログラムの初期化を実施していきます
      GM_Level           := 1;         // Form1 開始時にゲームレベルを１とする
      X                   := -360;      // From1 開示時にX= -360 とする
      TATE_Bar[1].visible_flag := 0 ;        // たて四角１（左下）初期化　
      TATE_Bar[2].visible_flag := 0 ;        // たて四角１（右下）初期化　
      AIM_SCORE[1].count  := 0;         // 当たり判定時の「Nice!!」表示カウント
      Label3.Visible         := false;     // 当たり判定時の「Nice!!」非表示
      Panel2.Caption       := '';        // Panel2 という文字を消す
      Memo1.Caption        := '＜星型飛行物体の射撃訓練 Ver 1.0＞';   // プログラム起動時のMemo1表示
      Image3.Visible           := false;     // Image3(小さい丸)を消す
      Label4.Caption           := 'Score ='; // Label4 初期化
      Image5.Visible           := false;     // Image5(たて四角：上)を消す
      Label1.Caption           := 'メッセージ・ウィンドウ'; // Label1のゲーム向け表示
      Image2.Visible           := true;      //
      Form1.Caption           := '関数移動の★ 射撃訓練 ' + Version + '    Created by MoonWolf 2023';  // フォーム１のタイトル
      Memo1.Caption          := '＜関数移動の★ 射撃訓練 '+ Version + '＞';   // プログラム起動時のMemo1表示
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);        // image1(XY座標画面)クリック処理
var
  pt: TPoint;
begin
  //　＜開発者向け動作チェック＞
  // プログラム実行時は以下は表示しない。しかし、いつでも表示に戻せるようにしておきたい。
  //
  //
  //    memo1.Append('<マウス・クリック時の座標取得>');
  //
  //    pt := Mouse.CursorPos;           // windows 全体画面のマウス・ポインタ座標
  //    memo1.Append('Windows :: mouse cursorPos pt.x='+inttostr(pt.x)+',pt.y='+inttostr(pt.y));
  //
  //    pt := ScreenToClient(pt);         // form1の中のマウス・ポインタ座標
  //    memo1.Append('from1 :: screenToClient x='+inttostr(pt.x)+' y='+inttostr(pt.y));
  //
  //    memo1.Append('AIM X='+inttostr(AIM_SCORE[1].x)+' AIM Y='+inttostr(AIM_SCORE[1].y));
  //    memo1.Append('STR_X='+inttostr(image2.Left) + ' STR_Y=' +inttostr(image2.Top));
  //
  ////////////////////

  pt := Mouse.CursorPos;          // No.1　Windows定の座標を計算
  pt := ScreenToClient(pt);       // No.2　Form1上の座標を計算
                                  // No1.の計算結果を利用して、No.2を計算。No.2単独では動かない。　
  if TATE_Bar[1].visible_flag =0 then
    begin
     x_mouse := pt.x;       // クリック時のForm1 X座標の保存
     y_mouse := pt.y;       // クリック時のForm1 X座標の保存
     TATE_Bar[1].x_bar_star := x_mouse - 10 ;   // 星とたて四角の座標の差(X座標)
     TATE_Bar[1].y_bar_star := 384 - y_mouse ;  // 星とたて四角の座標の差(Y座標)
     TATE_Bar[1].count := bar_star_step ;
     TATE_Bar[1].x_delta := round(TATE_Bar[1].x_bar_star / bar_star_step) ;
     TATE_Bar[1].y_delta := round(TATE_Bar[1].y_bar_star / bar_star_step) ;
     TATE_Bar[2].x_bar_star := 720 - x_mouse  ;   // 星とたて四角の座標の差(X座標) << 950 -> 720に調整 >>
     TATE_Bar[2].y_bar_star := 384 - y_mouse ;  // 星とたて四角の座標の差(Y座標)
     TATE_Bar[2].count := bar_star_step ;
     TATE_Bar[2].x_delta := round(TATE_Bar[2].x_bar_star / bar_star_step) ;
     TATE_Bar[2].y_delta := round(TATE_Bar[2].y_bar_star / bar_star_step) ;

     //　＜開発者向け動作チェック＞
     //  memo1.Append( '素直な　from1 :: screenToClient x='+inttostr(pt.x)+' y='+inttostr(pt.y));
     //  memo1.Append( '素直な　IMAGE1 :: TATE_Bar[1].x_bar_star=' + inttostr(TATE_Bar[1].x_bar_star));
     //  memo1.Append( '素直な　IMAGE1 :: TATE_Bar[1].y_bar_star=' + inttostr(TATE_Bar[1].y_bar_star));
     //  memo1.Append( '素直な　IMAGE1 :: TATE_Bar[2].x_bar_star=' + inttostr(TATE_Bar[2].x_bar_star));
     //  memo1.Append( '素直な　IMAGE1 :: TATE_Bar[2].y_bar_star=' + inttostr(TATE_Bar[2].y_bar_star));
     ////////////////////

         TATE_Bar[1].visible_flag := 1;
         TATE_Bar[2].visible_flag := 1;
         image3.Visible  := true;     // クリック時にImage3(小さい丸)を表示
         image3.left     := x_mouse - 10 ;    // ポインタの先にImage3(小さい丸)とする微調整
         image3.top      := y_mouse - 4 ;     // ポインタの先にImage3(小さい丸)とする微調整
         AIM_SCORE[1].X  := x_mouse - 7;     //  AIM_SCOREのXに代入(当たり判定座標）
         AIM_SCORE[1].Y  := y_mouse - 1 ;     // AIM_SCOREのYに代入(当たり判定座標）
    end;
end;

procedure TForm1.Image2Click(Sender: TObject);    // Image1(XY座標)クリック時と同じ反応をImage2(星)に適応
var
  pt: TPoint;

begin
  pt := Mouse.CursorPos;          // No.1　Windows定の座標を計算
  pt := ScreenToClient(pt);       // No.2　Form1上の座標を計算
                                  // No1.の計算結果を利用して、No.2を計算。No.2単独では動かない。　
  if TATE_Bar[1].visible_flag =0 then
    begin
     x_mouse := pt.x;       // クリック時のForm1 X座標の保存
     y_mouse := pt.y;       // クリック時のForm1 X座標の保存
     TATE_Bar[1].x_bar_star := x_mouse - 10 ;   // 星とたて四角の座標の差(X座標)
     TATE_Bar[1].y_bar_star := 384 - y_mouse ;  // 星とたて四角の座標の差(Y座標)
     TATE_Bar[1].count := bar_star_step ;
     TATE_Bar[1].x_delta := round(TATE_Bar[1].x_bar_star / bar_star_step) ;
     TATE_Bar[1].y_delta := round(TATE_Bar[1].y_bar_star / bar_star_step) ;
     TATE_Bar[2].x_bar_star := 720 - x_mouse  ;   // 星とたて四角の座標の差(X座標) << 950 -> 720に調整 >>
     TATE_Bar[2].y_bar_star := 384 - y_mouse ;  // 星とたて四角の座標の差(Y座標)
     TATE_Bar[2].count := bar_star_step ;
     TATE_Bar[2].x_delta := round(TATE_Bar[2].x_bar_star / bar_star_step) ;
     TATE_Bar[2].y_delta := round(TATE_Bar[2].y_bar_star / bar_star_step) ;
     TATE_Bar[1].visible_flag := 1;
     TATE_Bar[2].visible_flag := 1;
     image3.Visible  := true;     // クリック時にImage3(小さい丸)を表示
     image3.left     := x_mouse - 10 ;    // ポインタの先にImage3(小さい丸)とする微調整
     image3.top      := y_mouse - 4 ;     // ポインタの先にImage3(小さい丸)とする微調整
     AIM_SCORE[1].X  := x_mouse - 7;     //  AIM_SCOREのXに代入(当たり判定座標）
     AIM_SCORE[1].Y  := y_mouse - 1 ;     // AIM_SCOREのYに代入(当たり判定座標）
    end;
end;

procedure TForm1.Panel1Click(Sender: TObject);     // Panel1 クリック時の処理
  // var
  // pt: TPoint;
begin
  //　＜開発者向け動作チェック＞
  // プログラム実行時は以下は表示しない。しかし、いつでも表示に戻せるようにしておきたい。
  //
  // pt := Mouse.CursorPos;           // win10全体画面の座標
  // memo1.Append('PANEL1　Windows :: mouse cursorPos pt.x='+inttostr(pt.x)+',pt.y='+inttostr(pt.y));
  //
  // pt := ScreenToClient(pt);         // form1の中の座標
  // memo1.Append('PANEL1　from1 :: screenToClient x='+inttostr(pt.x)+' y='+inttostr(pt.y));
  //
  /////////////////////////////////////
end;

procedure TForm1.Timer1Timer(Sender: TObject);  // Timer1 : ゲームレベル管理、星の動きを関数で計算
begin
  If X > 360 then      // 星が右はしまできたら、星の位置を左はしに戻し、ゲームレベルを１上げる
    begin
      X := -360 ;

      if GM_Level < 11 then
        begin
          GM_Level := GM_Level + 1 ;
        end;

      If GM_Level = 11 then    // GAME_OVER 処理開始の判定
        begin
          GAME_OVER_COMMENT;        // GAME_OVER_COKMMENT 処理（スコア表示、取得アイテム、メアリ ＭＦコメント）
          Image2.Visible := false;
          Label2.Caption := '';     // GAME OVER 時に GAME Lv11と表示してしまうのを防ぐ
        end;
    end;

  if ( ( X = -360 ) and ( GM_Level < 11 ) ) = true then      // ゲーム実行時に、Memo1にGame Levelを表示
    begin
         Memo1.Append('[ Game Level ' + IntToStr( GM_Level ) + ' ]');
    end;

  If GM_Level < 11 then    // GM_Level 1～10だけ星を動かす制限
    begin
      X := X + 5 ;       // 星を５ピクセルだけ、右に動かす。動かすタイミングはTimer1のInterval設定による
    end;

  // Game Level 1～10までの、星の動きを計算する。

  if GM_Level=1 then
    begin
      if X<>0 then
        begin
          Y := round( 3500 * 1 / X )*(-1);
          Fx_name := 'Y = - 3500 * 1/x';
        end;
    end;

  if GM_Level=2 then
    begin
      Y := abs( round( 0.3 * X + 30 ) );
      Fx_name := 'Y = ┃　0.3X + 30　┃';
    end;

  if GM_Level=3 then
    begin
      if X<>0 then
        begin
          Y := round( 3500 * 1 / X );
          Fx_name := 'Y = 3500 * 1 / X';
        end;
    end;

  if GM_Level=4 then
    begin
      Y := round( 0.003 * X * X )*(-1) ;
      Fx_name := 'Y = - 0.003 * X ^2' ;
    end;

  if GM_Level=5 then
    begin
      Y := round( 0.007 * ( X-50 ) * ( X-50) - 150 ) ;
      Fx_name := 'Y = 0.007 * ( X - 50 )^2 - 150' ;
    end;

  if GM_Level=6 then
    begin
      Y := round( 0.006 * ( X+70 ) * ( X+70) - 200 )*(-1) ;
      Fx_name := 'Y = - 0.006 * ( X + 70 )^2 + 200' ;
    end;

  if GM_Level=7 then
    begin
      y:= round( 120*sin(x*0.05) );
      Fx_name := 'Y = 120 * sin( X * 0.05 )' ;
    end;

  if GM_Level=8 then
    begin
      y:= round( 10*sin(x*0.0098)/cos(x*0.0098) )  ;
      Fx_name := 'Y = 10 * tan( X * 0.098 )' ;
    end;

  if GM_Level=9 then
    begin
      y:=round(x*sin(x*0.05));
      Fx_name := 'Y = X * sin( X * 0.05 )' ;
    end;

  if GM_Level=10 then
    begin
      if X <> 0 then
        begin
          y:= round( 5000/x *sin(x*0.05) );
          Fx_name := 'Y = 5000/X * sin( X * 0.05 )' ;
        end;
    end;

  Image2.Left := x_cnt + X-25;      // Image2 Center補正（X座標）
  Image2.Top  := y_cnt - Y-25;      // Image2 Center補正（Y座標）

  //Label2に、GM_Level , f=(x) , (X,Y) 座標を表示する Label2_displayを作ったので、以下のデータは不要となったのでコメントアウト。
  //memo1.Append( 'GM_Lv='+ inttostr(GM_Level)+ ' X=' + inttostr(X) + ' Y=' + inttostr(Y) );  // X, Y の値をMEMO1に表示

  If GM_Level < 11 then
    begin
      Label2_display;
    end;
end;

procedure TForm1.Timer2Timer(Sender: TObject); // たて四角の制御＋（あたり判定：予定）
begin
  // たて四角(左下)が、すこしずつ、クリックした座標に近づく処理　
  if ( ( TATE_Bar[1].visible_flag =1 ) and ( TATE_Bar[1].count > 0  ) ) = true then
    begin
      image4.Left  := image4.Left + TATE_Bar[1].x_delta;
      image4.Top   := image4.Top  - TATE_Bar[1].y_delta;
      image4.Height := round( image4.Height *  (TATE_Bar[1].count+5) / bar_star_step ) ; //大きさ調整
      image4.Top   := image4.Top  +4 ; // 位置補正
      TATE_Bar[1].count := TATE_Bar[1].count - 1;
      if TATE_Bar[1].count=0 then
        begin
          TATE_Bar[1].visible_flag :=0;  // たて四角(左下)を元の位置、もとの大きさに戻し
          Image4.Left := 5;
          Image4.top  := 300;
          Image4.Height := 200;
          Image4.Width := 20;
          Image3.visible := false;  // Image3(小さいたま）を見えなくする
          AIM_Judgement;            // 当たり判定の実施
        end;
    end;

  // たて四角(右下)が、すこしずつ、クリックした座標に近づく処理　
  if ( ( TATE_Bar[2].visible_flag =1 ) and ( TATE_Bar[2].count > 0  ) ) = true then  // たて四角(右下)処理
    begin
      image6.Left  := image6.Left - TATE_Bar[2].x_delta;
      image6.Top   := image6.Top  - TATE_Bar[2].y_delta;
      image6.Height := round( image6.Height *  (TATE_Bar[2].count+5) / bar_star_step ) ; // 大きさ調整
      image6.Top   := image6.Top  +4 ; // 位置補正
      TATE_Bar[2].count := TATE_Bar[2].count - 1;
      if TATE_Bar[2].count=0 then       // たて四角(右下)を元の位置、もとの大きさに戻し
        begin
          TATE_Bar[2].visible_flag :=0;
          //Image6.Left := 950;        // だめなら戻す準備
          //Image6.top  := 300;
          Image6.Left := 704;   // 950 -> 704に調整(右下たて四角標準の位置)
          Image6.top  := 296;   // 300 -> 296に調整(右下たて四角標準の位置)
          Image6.Height := 200;
          Image6.Width := 20;
        end;
    end;

  // 当たり判定後、「Nice!!」表示時間の制御
  if AIM_SCORE[1].count > 0 then
    begin
      AIM_SCORE[1].count := AIM_SCORE[1].count - 1;
      if AIM_SCORE[1].count = 0 then
        begin
          Label3.Visible := false;
        end;
    end;
end;
end.
