// 念のため載せておきます。Lazarusが自動生成しています。私は指一本触れていません。MoonWolf, 2024.11

object Form1: TForm1
  Left = 345
  Height = 476
  Top = 112
  Width = 1010
  Caption = 'Form1 ToDoList V 009_1'
  ClientHeight = 476
  ClientWidth = 1010
  OnCreate = FormCreate
  LCLVersion = '3.6.0.0'
  object DBGrid1: TDBGrid
    Left = 688
    Height = 184
    Top = 40
    Width = 256
    Color = clWindow
    Columns = <>
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisplayMemoText]
    TabOrder = 0
  end
  object DBNavigator1: TDBNavigator
    Left = 72
    Height = 25
    Top = 264
    Width = 241
    BevelOuter = bvNone
    ChildSizing.EnlargeHorizontal = crsScaleChilds
    ChildSizing.EnlargeVertical = crsScaleChilds
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 100
    ClientHeight = 25
    ClientWidth = 241
    DataSource = DataSource5
    Options = []
    TabOrder = 1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbRefresh]
  end
  object Edit1: TEdit
    Left = 24
    Height = 23
    Top = 352
    Width = 280
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 312
    Height = 25
    Top = 350
    Width = 75
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Shape1: TShape
    Left = 392
    Height = 7
    Top = 240
    Width = 584
  end
  object Shape2: TShape
    Left = 664
    Height = 440
    Top = 8
    Width = 9
  end
  object DBGrid2: TDBGrid
    Left = 400
    Height = 180
    Top = 44
    Width = 256
    Color = clWindow
    Columns = <>
    DataSource = DataSource2
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisplayMemoText]
    TabOrder = 4
  end
  object DBGrid3: TDBGrid
    Left = 400
    Height = 168
    Top = 256
    Width = 256
    Color = clWindow
    Columns = <>
    DataSource = DataSource3
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisplayMemoText]
    TabOrder = 5
  end
  object DBGrid4: TDBGrid
    Left = 688
    Height = 168
    Top = 256
    Width = 256
    Color = clWindow
    Columns = <>
    DataSource = DataSource4
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisplayMemoText]
    TabOrder = 6
  end
  object DBGrid5: TDBGrid
    Left = 16
    Height = 248
    Top = 8
    Width = 360
    Color = clWindow
    Columns = <>
    DataSource = DataSource5
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisplayMemoText]
    TabOrder = 7
  end
  object Label1: TLabel
    Left = 24
    Height = 15
    Top = 297
    Width = 48
    Caption = '優先順位'
  end
  object Label2: TLabel
    Left = 184
    Height = 15
    Top = 297
    Width = 36
    Caption = '緊急度'
  end
  object ComboBox1: TComboBox
    Left = 24
    Height = 23
    Top = 312
    Width = 100
    ItemHeight = 15
    ItemIndex = 0
    Items.Strings = (
      'high'
      'low'
    )
    TabOrder = 8
    Text = 'high'
  end
  object ComboBox2: TComboBox
    Left = 184
    Height = 23
    Top = 312
    Width = 100
    ItemHeight = 15
    ItemIndex = 0
    Items.Strings = (
      'high'
      'low'
    )
    TabOrder = 9
    Text = 'high'
  end
  object Label3: TLabel
    Left = 952
    Height = 15
    Top = 256
    Width = 48
    Caption = '優先順位'
  end
  object Label4: TLabel
    Left = 680
    Height = 15
    Top = 16
    Width = 36
    Caption = '緊急度'
  end
  object SQLite3Connection1: TSQLite3Connection
    Connected = False
    LoginPrompt = False
    DatabaseName = 'test01'
    KeepConnection = False
    Transaction = SQLTransaction1
    AlwaysUseBigint = False
    Left = 48
    Top = 400
  end
  object SQLTransaction1: TSQLTransaction
    Active = False
    Database = SQLite3Connection1
    Left = 160
    Top = 400
  end
  object SQLQuery1: TSQLQuery
    IndexName = 'DEFAULT_ORDER'
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'id'
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Pri'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'Urg'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ToDo'
        DataType = ftMemo
        Precision = -1
      end>
    Database = SQLite3Connection1
    Transaction = SQLTransaction1
    SQL.Strings = (
      'SELECT * FROM todolist10 where pri="high" and urg="high"'
    )
    Params = <>
    Macros = <>
    Left = 736
    Top = 112
  end
  object DataSource1: TDataSource
    DataSet = SQLQuery1
    Left = 816
    Top = 112
  end
  object SQLQuery2: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'id'
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Pri'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'Urg'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ToDo'
        DataType = ftMemo
        Precision = -1
      end>
    Database = SQLite3Connection1
    Transaction = SQLTransaction1
    SQL.Strings = (
      'SELECT * FROM todolist10 where pri="low" and urg="high"'
      ''
    )
    Params = <>
    Macros = <>
    Left = 464
    Top = 128
  end
  object SQLQuery3: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'id'
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Pri'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'Urg'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ToDo'
        DataType = ftMemo
        Precision = -1
      end>
    Database = SQLite3Connection1
    Transaction = SQLTransaction1
    SQL.Strings = (
      'SELECT * FROM todolist10 where pri="low" and urg="low"'
      ''
    )
    Params = <>
    Macros = <>
    Left = 472
    Top = 336
  end
  object SQLQuery4: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'id'
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Pri'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'Urg'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ToDo'
        DataType = ftMemo
        Precision = -1
      end>
    Database = SQLite3Connection1
    Transaction = SQLTransaction1
    SQL.Strings = (
      'SELECT * FROM todolist10 where pri="high" and urg="low"'
      ''
    )
    Params = <>
    Macros = <>
    Left = 752
    Top = 338
  end
  object SQLQuery5: TSQLQuery
    MaxIndexesCount = 4
    FieldDefs = <    
      item
        Name = 'id'
        DataType = ftAutoInc
        Precision = -1
      end    
      item
        Name = 'Pri'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'Urg'
        DataType = ftMemo
        Precision = -1
      end    
      item
        Name = 'ToDo'
        DataType = ftMemo
        Precision = -1
      end>
    AfterDelete = SQLQuery5AfterDelete
    AfterPost = SQLQuery5AfterPost
    Database = SQLite3Connection1
    Transaction = SQLTransaction1
    SQL.Strings = (
      'select * from todolist10'
    )
    Params = <>
    Macros = <>
    Left = 248
    Top = 400
  end
  object DataSource2: TDataSource
    DataSet = SQLQuery2
    Left = 545
    Top = 125
  end
  object DataSource3: TDataSource
    DataSet = SQLQuery3
    Left = 552
    Top = 336
  end
  object DataSource4: TDataSource
    DataSet = SQLQuery4
    Left = 837
    Top = 338
  end
  object DataSource5: TDataSource
    DataSet = SQLQuery5
    Left = 328
    Top = 400
  end
end
