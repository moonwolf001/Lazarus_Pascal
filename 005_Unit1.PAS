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
  // 変更を適用
  SQLQuery1.ApplyUpdates;  // 変更をデータベースに適用
  SQLTransaction1.CommitRetaining;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // クエリ実行
  SQLQuery1.SQL.Text := 'SELECT * FROM student_profiles';
  SQLQuery1.Open;
end;

procedure TForm1.SQLQuery1AfterDelete(DataSet: TDataSet);
begin
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.CommitRetaining;
end;

end.

