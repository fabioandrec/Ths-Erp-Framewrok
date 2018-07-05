unit Ths.Erp.Database.Table.View.SysViewColumns;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table,
  Ths.Erp.Database.Table.View,
  Ths.Erp.Database.Table.Field;

type
  TSysViewColumns = class(TView)
  private
    FTableName: TFieldDB;
    FColumnName: TFieldDB;
    FIsNullable: TFieldDB;
    FDataType: TFieldDB;
    FCharacterMaximumLength: TFieldDB;
  protected
  published
    constructor Create(OwnerDatabase:TDatabase);override;
  public
    procedure SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True); override;
    procedure SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True); override;

    procedure Clear();override;
    function Clone():TTable;override;

    function GetDistinctTableName(): TStringList;
    function GetDistinctColumnName(pTableName: string): TStringList;

    Property TableName1: TFieldDB read FTableName write FTableName;
    Property ColumnName: TFieldDB read FColumnName write FColumnName;
    property IsNullable: TFieldDB read FIsNullable write FIsNullable;
    property DataType: TFieldDB read FDataType write FDataType;
    property CharacterMaximumLength: TFieldDB read FCharacterMaximumLength write FCharacterMaximumLength;
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  Ths.Erp.Constants;

constructor TSysViewColumns.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'sys_view_columns';
  SourceCode := '1000';

  FTableName  := TFieldDB.Create('table_name', ftString, '');
  FColumnName := TFieldDB.Create('column_name', ftString, '');
  FIsNullable := TFieldDB.Create('is_nullable', ftString, 'YES');
  FDataType := TFieldDB.Create('data_type', ftString, '');
  FCharacterMaximumLength := TFieldDB.Create('character_maximum_length', ftInteger, 0);
end;

procedure TSysViewColumns.SelectToDatasource(pFilter: string;
  pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + FTableName.FieldName,
          TableName + '.' + FColumnName.FieldName,
          TableName + '.' + FIsNullable.FieldName,
          TableName + '.' + FDataType.FieldName,
          TableName + '.' + FCharacterMaximumLength.FieldName
        ]) +
        'WHERE 1=1 ' + pFilter;
		  Open;
		  Active := True;

      Self.DataSource.DataSet.FindField(FTableName.FieldName).DisplayLabel := 'TABLE NAME';
      Self.DataSource.DataSet.FindField(FColumnName.FieldName).DisplayLabel := 'COLUMN NAME';
      Self.DataSource.DataSet.FindField(FIsNullable.FieldName).DisplayLabel := 'NULLABLE?';
      Self.DataSource.DataSet.FindField(FDataType.FieldName).DisplayLabel := 'DATA TYPE';
      Self.DataSource.DataSet.FindField(FCharacterMaximumLength.FieldName).DisplayLabel := 'CHARECTER MAX LENGTH';
	  end;
  end;
end;

procedure TSysViewColumns.SelectToList(pFilter: string; pLock: Boolean;
  pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
	  if (pLock) then
		  pFilter := pFilter + ' FOR UPDATE NOWAIT; ';

	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + FTableName.FieldName,
          TableName + '.' + FColumnName.FieldName,
          TableName + '.' + FIsNullable.FieldName,
          TableName + '.' + FDataType.FieldName,
          TableName + '.' + FCharacterMaximumLength.FieldName
        ]) +
        'WHERE 1=1 ' + pFilter;
		  Open;

		  FreeListContent();
		  List.Clear;
		  while NOT EOF do
		  begin
		    FTableName.Value := GetVarToFormatedValue(FieldByName(FTableName.FieldName).DataType, FieldByName(FTableName.FieldName).Value);
        FColumnName.Value := GetVarToFormatedValue(FieldByName(FColumnName.FieldName).DataType, FieldByName(FColumnName.FieldName).Value);
        FIsNullable.Value := GetVarToFormatedValue(FieldByName(FIsNullable.FieldName).DataType, FieldByName(FIsNullable.FieldName).Value);
        FDataType.Value := GetVarToFormatedValue(FieldByName(FDataType.FieldName).DataType, FieldByName(FDataType.FieldName).Value);
        FCharacterMaximumLength.Value := GetVarToFormatedValue(FieldByName(FCharacterMaximumLength.FieldName).DataType, FieldByName(FCharacterMaximumLength.FieldName).Value);

		    List.Add(Self.Clone());

		    Next;
		  end;
		  EmptyDataSet;
		  Close;
	  end;
  end;
end;

procedure TSysViewColumns.Clear();
begin
  inherited;
  FTableName.Value := '';
  FColumnName.Value := '';
  FIsNullable.Value := 'NO';
  FDataType.Value := '';
  FCharacterMaximumLength.Value := 0;
end;

function TSysViewColumns.Clone():TTable;
begin
  Result := TSysViewColumns.Create(Database);

  FTableName.Clone(TSysViewColumns(Result).FTableName);
  FColumnName.Clone(TSysViewColumns(Result).FColumnName);
  FIsNullable.Clone(TSysViewColumns(Result).FIsNullable);
  FDataType.Clone(TSysViewColumns(Result).FDataType);
  FCharacterMaximumLength.Clone(TSysViewColumns(Result).FCharacterMaximumLength);
end;

function TSysViewColumns.GetDistinctTableName(): TStringList;
begin
  Result := TStringList.Create;
  with QueryOfOther do
  begin
    Close;
    SQL.Text := 'SELECT distinct ' + FTableName.FieldName + ' FROM ' + TableName;
    Open;
    while NOT EOF do
    begin
      Result.Add( Fields.Fields[0].AsString );
      Next;
    end;
    EmptyDataSet;
    Close;
  end;
end;

function TSysViewColumns.GetDistinctColumnName(pTableName: string): TStringList;
begin
  Result := TStringList.Create;
  with QueryOfOther do
  begin
    Close;
    SQL.Text := 'SELECT distinct v.' + ColumnName.FieldName + ' FROM ' + TableName + ' v ' +
                ' LEFT JOIN sys_grid_col_width a ON a.table_name=v.table_name and a.column_name = v.column_name ' +
                ' WHERE v.' + TableName1.FieldName + '=' + QuotedStr(pTableName) + ' and a.column_name is null ';
    Open;
    while NOT EOF do
    begin
      Result.Add( Fields.Fields[0].AsString );
      Next;
    end;
    EmptyDataSet;
    Close;
  end;
end;

end.
