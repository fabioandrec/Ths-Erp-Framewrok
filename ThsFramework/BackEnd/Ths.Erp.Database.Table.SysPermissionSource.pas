unit Ths.Erp.Database.Table.SysPermissionSource;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, StrUtils, RTTI, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table,
  Ths.Erp.Database.Table.Field;

type
  TSysPermissionSource = class(TTable)
  private
    FSourceCode: TFieldDB;
    FSourceName: TFieldDB;
    FSourceGroupID: TFieldDB;
    //not a database field
    FSourceGroup: TFieldDB;
  protected
  published
    constructor Create(OwnerDatabase: TDatabase);override;
  public
    procedure SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True); override;
    procedure SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True); override;
    procedure Insert(out pID: Integer; pPermissionControl: Boolean=True); override;
    procedure Update(pPermissionControl: Boolean=True); override;

    procedure Clear();override;
    function Clone():TTable;override;

    property SourceCode: TFieldDB read FSourceCode write FSourceCode;
    property SourceName: TFieldDB read FSourceName write FSourceName;
    property SourceGroupID: TFieldDB read FSourceGroupID write FSourceGroupID;
    //not a database field
    property SourceGroup: TFieldDB read FSourceGroup write FSourceGroup;
  end;

implementation

uses
  Ths.Erp.Constants,
  Ths.Erp.Database.Singleton;

constructor TSysPermissionSource.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'sys_permission_source';
  TTable(Self).SourceCode := '1';

  FSourceCode := TFieldDB.Create('source_code', ftString, '');
  FSourceName := TFieldDB.Create('source_name', ftString, '');
  FSourceGroupID := TFieldDB.Create('source_group_id', ftInteger, 0);
  FSourceGroup := TFieldDB.Create('source_group', ftString, '');
end;

procedure TSysPermissionSource.SelectToDatasource(pFilter: string;
  pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + Self.Id.FieldName,
          'pg' + '.' + FSourceGroup.FieldName,
          TableName + '.' + FSourceCode.FieldName,
          TableName + '.' + FSourceName.FieldName,
          TableName + '.' + FSourceGroupID.FieldName
        ]) +
        'LEFT JOIN sys_permission_source_group pg ON pg.id =' + TableName + '.' + FSourceGroupID.FieldName +
        ' WHERE 1=1 ' + pFilter;
		  Open;
		  Active := True;

      Self.DataSource.DataSet.FindField(Self.Id.FieldName).DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField(FSourceCode.FieldName).DisplayLabel := 'SOURCE CODE';
      Self.DataSource.DataSet.FindField(FSourceName.FieldName).DisplayLabel := 'SOURCE NAME';
      Self.DataSource.DataSet.FindField(FSourceGroupID.FieldName).DisplayLabel := 'SOURCE GROUP ID';
      Self.DataSource.DataSet.FindField(FSourceGroup.FieldName).DisplayLabel := 'SOURCE GROUP';
	  end;
  end;
end;

procedure TSysPermissionSource.SelectToList(pFilter: string; pLock:
  Boolean; pPermissionControl: Boolean=True);
begin
  if Self.IsAuthorized(ptRead, pPermissionControl) then
  begin
	  if (pLock) then
		  pFilter := pFilter + ' FOR UPDATE NOWAIT; ';

	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + Self.Id.FieldName,
          TableName + '.' + FSourceCode.FieldName,
          TableName + '.' + FSourceName.FieldName,
          TableName + '.' + FSourceGroupID.FieldName
        ]) +
        'WHERE 1=1 ' + pFilter;
		  Open;

		  FreeListContent();
		  List.Clear;
		  while NOT EOF do
		  begin
		    Self.Id.Value := FormatedVariantVal(FieldByName(Self.Id.FieldName).DataType, FieldByName(Self.Id.FieldName).Value);

		    FSourceCode.Value := FormatedVariantVal(FieldByName(FSourceCode.FieldName).DataType, FieldByName(FSourceCode.FieldName).Value);
		    FSourceName.Value := FormatedVariantVal(FieldByName(FSourceName.FieldName).DataType, FieldByName(FSourceName.FieldName).Value);
		    FSourceGroupID.Value := FormatedVariantVal(FieldByName(FSourceGroupID.FieldName).DataType, FieldByName(FSourceGroupID.FieldName).Value);

		    List.Add(Self.Clone());

		    Next;
		  end;
		  EmptyDataSet;
		  Close;
	  end;
  end;
end;

procedure TSysPermissionSource.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLInsertCmd(TableName, QUERY_PARAM_CHAR, [
        FSourceCode.FieldName,
        FSourceName.FieldName,
        FSourceGroupID.FieldName
      ]);

      NewParamForQuery(QueryOfTable, FSourceCode);
      NewParamForQuery(QueryOfTable, FSourceName);
      NewParamForQuery(QueryOfTable, FSourceGroupID);

		  Open;

      if (Fields.Count > 0) and (not Fields.FieldByName(Self.Id.FieldName).IsNull) then
        pID := Fields.FieldByName(Self.Id.FieldName).AsInteger
      else
        pID := 0;

		  EmptyDataSet;
		  Close;
	  end;

    Self.notify;
  end;
end;

procedure TSysPermissionSource.Update(pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptUpdate, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLUpdateCmd(TableName, QUERY_PARAM_CHAR, [
        FSourceCode.FieldName,
        FSourceName.FieldName,
        FSourceGroupID.FieldName
      ]);

      NewParamForQuery(QueryOfTable, FSourceCode);
      NewParamForQuery(QueryOfTable, FSourceName);
      NewParamForQuery(QueryOfTable, FSourceGroupID);

      NewParamForQuery(QueryOfTable, Id);
      
		  ExecSQL;
		  Close;
	  end;

    Self.notify;
  end;
end;

procedure TSysPermissionSource.Clear();
begin
  inherited;
  FSourceCode.Value := '';
  FSourceName.Value := '';
  FSourceGroupID.Value := 0;
  FSourceGroup.Value := '';
end;

function TSysPermissionSource.Clone():TTable;
begin
  Result := TSysPermissionSource.Create(Database);

  Self.Id.Clone(TSysPermissionSource(Result).Id);

  FSourceCode.Clone(TSysPermissionSource(Result).FSourceCode);
  FSourceName.Clone(TSysPermissionSource(Result).FSourceName);
  FSourceGroupID.Clone(TSysPermissionSource(Result).FSourceGroupID);
  FSourceGroup.Clone(TSysPermissionSource(Result).FSourceGroup);
end;

end.
