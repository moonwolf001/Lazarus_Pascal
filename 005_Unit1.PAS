unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  DBGrids, DBCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure SQLQuery1AfterDelete(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  // 変更にこれが必要適用
  SQLQuery1.ApplyUpdates;  
  SQLTransaction1.CommitRetaining;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // フォーム作成時のクエリ―表示
  SQLQuery1.SQL.Text := 'SELECT * FROM student_profiles';
  SQLQuery1.Open;
end;

procedure TForm1.SQLQuery1AfterDelete(DataSet: TDataSet);
begin
  // 削除時にこれが必要
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.CommitRetaining;
end;

end.

