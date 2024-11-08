// To do List Lv1 by MoonWolf 2024

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, DBCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
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


procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLite3Connection1.DatabaseName:='test02';
  SQLite3Connection1.Connected:=True;
  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'SELECT * FROM todolist1';
  SQLQuery1.Open;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'INSERT INTO ToDoList1 (ToDo) VALUES (''' + Edit1.Text + ''')';
  SQLQuery1.ExecSQL;
  SQLTransaction1.Commit;

  // データセットを再度開いて、DBGridを更新
  SQLQuery1.SQL.Text := 'SELECT * FROM ToDoList1';
  SQLQuery1.Open;
end;

procedure TForm1.SQLQuery1AfterDelete(DataSet: TDataSet);
begin
  //削除時にはこれが必要
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.CommitRetaining;
end;

procedure TForm1.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  //変更時にはこれが必要
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.CommitRetaining;
end;

end.
