// ToDoList Lv10 , MoonWolf 2024
// ToDoList + 重要度＆緊急度マップ

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  DBGrids, DBCtrls, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    DataSource5: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;
    SQLQuery4: TSQLQuery;
    SQLQuery5: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SQLQuery5AfterDelete(DataSet: TDataSet);
    procedure SQLQuery5AfterPost(DataSet: TDataSet);
  private

  public

  end;

var
  Form1: TForm1;

const
  Prog_Name = 'ToDoList Version 10.00 by MoonWolf 2024.11' ;

implementation

{$R *.lfm}

{ TForm1 }

Procedure ResetDisplay;
begin
  // DGGrid １～５の内容を最新情報で表示
  Form1.SQLQuery5.Close;
  Form1.SQLQuery5.SQL.Text := 'SELECT * FROM ToDoList10';
  Form1.SQLQuery5.Open;

  Form1.SQLQuery1.Close;
  Form1.SQLQuery1.SQL.Text := 'SELECT * FROM todolist10 where pri="high" and urg="high"';
  Form1.SQLQuery1.Open;

  Form1.SQLQuery2.Close;
  Form1.SQLQuery2.SQL.Text := 'SELECT * FROM todolist10 where pri="low" and urg="high"';
  Form1.SQLQuery2.Open;

  Form1.SQLQuery3.Close;
  Form1.SQLQuery3.SQL.Text := 'SELECT * FROM todolist10 where pri="low" and urg="low"';
  Form1.SQLQuery3.Open;

  Form1.SQLQuery4.Close;
  Form1.SQLQuery4.SQL.Text := 'SELECT * FROM todolist10 where pri="high" and urg="low"';
  Form1.SQLQuery4.Open;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // 一時的にデータセットを閉じる
  SQLQuery5.Close;

  // INSERT クエリを設定して実行
  SQLQuery5.SQL.Text := 'INSERT INTO ToDoList10 (Pri, Urg, ToDo) VALUES (:Pri, :Urg, :ToDo)';
  SQLQuery5.Params.ParamByName('Pri').AsString := ComboBox1.Text;   // 重要度
  SQLQuery5.Params.ParamByName('Urg').AsString := ComboBox2.Text;   // 緊急度
  SQLQuery5.Params.ParamByName('ToDo').AsString := Edit1.Text;      // ToDoの内容
  SQLQuery5.ExecSQL;

  // トランザクションをコミットして変更を保存
  SQLTransaction1.Commit;

  ResetDisplay; // DBGrid1 to DBGrid5 をリフレッシュ
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption:= Prog_Name;
  ResetDisplay; // DBGrid1 to DBGrid5 をリフレッシュ
end;

procedure TForm1.SQLQuery5AfterDelete(DataSet: TDataSet);
begin
  SQLQuery5.ApplyUpdates;  // 変更をデータベースに適用
  SQLTransaction1.CommitRetaining;  // トランザクションをコミットして再利用可能に
  ResetDisplay; // DBGrid1 to DBGrid5 をリフレッシュ
end;

procedure TForm1.SQLQuery5AfterPost(DataSet: TDataSet);
begin
  SQLQuery5.ApplyUpdates;  // 変更をデータベースに適用
  SQLTransaction1.CommitRetaining;  // トランザクションをコミットして再利用可能に
  ResetDisplay; // DBGrid1 to DBGrid5 をリフレッシュ
end;

end.
