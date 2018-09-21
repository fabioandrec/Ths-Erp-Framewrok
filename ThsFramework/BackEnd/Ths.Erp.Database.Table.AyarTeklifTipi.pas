unit Ths.Erp.Database.Table.AyarTeklifTipi;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table,
  Ths.Erp.Database.Table.Field;

type
  TAyarTeklifTipi = class(TTable)
  private
    FDeger: TFieldDB;
    FAciklama: TFieldDB;
    FIsActive: TFieldDB;
  protected
  published
    constructor Create(OwnerDatabase:TDatabase);override;
  public
    procedure SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True); override;
    procedure SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True); override;
    procedure Insert(out pID: Integer; pPermissionControl: Boolean=True); override;
    procedure Update(pPermissionControl: Boolean=True); override;

    procedure Clear();override;
    function Clone():TTable;override;

    Property Deger: TFieldDB read FDeger write FDeger;
    Property Aciklama: TFieldDB read FAciklama write FAciklama;
    Property IsActive: TFieldDB read FIsActive write FIsActive;
  end;

implementation

uses
  Ths.Erp.Constants,
  Ths.Erp.Database.Singleton;

constructor TAyarTeklifTipi.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'ayar_teklif_tipi';
  SourceCode := '1000';

  FDeger := TFieldDB.Create('deger', ftString, '');
  FAciklama := TFieldDB.Create('aciklama', ftString, '');
  FIsActive := TFieldDB.Create('is_active', ftBoolean, 0);
end;

procedure TAyarTeklifTipi.SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
    with QueryOfDS do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLSelectCmd(TableName, [
        TableName + '.' + Self.Id.FieldName,
        GetRawDataSQLByLang(TableName, FDeger.FieldName),
        GetRawDataSQLByLang(TableName, FAciklama.FieldName),
        TableName + '.' + FIsActive.FieldName
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;
      Active := True;

      Self.DataSource.DataSet.FindField(Self.Id.FieldName).DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField(FDeger.FieldName).DisplayLabel := 'De�er';
      Self.DataSource.DataSet.FindField(FAciklama.FieldName).DisplayLabel := 'A��klama';
      Self.DataSource.DataSet.FindField(FIsActive.FieldName).DisplayLabel := 'Aktif?';
    end;
  end;
end;

procedure TAyarTeklifTipi.SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
    if (pLock) then
      pFilter := pFilter + ' FOR UPDATE NOWAIT; ';

    with QueryOfList do
    begin
      Close;
      SQL.Text := Database.GetSQLSelectCmd(TableName, [
        TableName + '.' + Self.Id.FieldName,
        GetRawDataSQLByLang(TableName, FDeger.FieldName),
        GetRawDataSQLByLang(TableName, FAciklama.FieldName),
        TableName + '.' + FIsActive.FieldName
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;

      FreeListContent();
      List.Clear;
      while NOT EOF do
      begin
        Self.Id.Value := FormatedVariantVal(FieldByName(Self.Id.FieldName).DataType, FieldByName(Self.Id.FieldName).Value);

        FDeger.Value := FormatedVariantVal(FieldByName(FDeger.FieldName).DataType, FieldByName(FDeger.FieldName).Value);
        FAciklama.Value := FormatedVariantVal(FieldByName(FAciklama.FieldName).DataType, FieldByName(FAciklama.FieldName).Value);
        FIsActive.Value := FormatedVariantVal(FieldByName(FIsActive.FieldName).DataType, FieldByName(FIsActive.FieldName).Value);

        List.Add(Self.Clone());

        Next;
      end;
      Close;
    end;
  end;
end;

procedure TAyarTeklifTipi.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
    with QueryOfInsert do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLInsertCmd(TableName, QUERY_PARAM_CHAR, [
        FDeger.FieldName,
        FAciklama.FieldName,
        FIsActive.FieldName
      ]);

      NewParamForQuery(QueryOfInsert, FDeger);
      NewParamForQuery(QueryOfInsert, FAciklama);
      NewParamForQuery(QueryOfInsert, FIsActive);

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

procedure TAyarTeklifTipi.Update(pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptUpdate, pPermissionControl) then
  begin
    with QueryOfUpdate do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLUpdateCmd(TableName, QUERY_PARAM_CHAR, [
        FDeger.FieldName,
        FAciklama.FieldName,
        FIsActive.FieldName
      ]);

      NewParamForQuery(QueryOfUpdate, FDeger);
      NewParamForQuery(QueryOfInsert, FAciklama);
      NewParamForQuery(QueryOfInsert, FIsActive);

      NewParamForQuery(QueryOfUpdate, Id);

      ExecSQL;
      Close;
    end;
    Self.notify;
  end;
end;

procedure TAyarTeklifTipi.Clear();
begin
  inherited;

  FDeger.Value := '';
  FAciklama.Value := '';
  FIsActive.Value := 0;
end;

function TAyarTeklifTipi.Clone():TTable;
begin
  Result := TAyarTeklifTipi.Create(Database);

  Self.Id.Clone(TAyarTeklifTipi(Result).Id);

  FDeger.Clone(TAyarTeklifTipi(Result).FDeger);
  FAciklama.Clone(TAyarTeklifTipi(Result).FAciklama);
  FIsActive.Clone(TAyarTeklifTipi(Result).FIsActive);
end;

end.
