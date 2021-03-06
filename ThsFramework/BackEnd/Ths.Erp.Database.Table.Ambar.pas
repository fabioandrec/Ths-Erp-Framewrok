unit Ths.Erp.Database.Table.Ambar;

interface

{$I ThsERP.inc}

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table;

type
  TAmbar = class(TTable)
  private
    FAmbarAdi: TFieldDB;
    FIsVarsayılanHammaddeAmbari: TFieldDB;
    FIsVarsayilanUretimAmbari: TFieldDB;
    FIsVarsayilanSatisAmbari: TFieldDB;
  protected
  published
    constructor Create(OwnerDatabase:TDatabase);override;
  public
    procedure SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True); override;
    procedure SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True); override;
    procedure Insert(out pID: Integer; pPermissionControl: Boolean=True); override;
    procedure Update(pPermissionControl: Boolean=True); override;

    function Clone():TTable;override;

    Property AmbarAdi: TFieldDB read FAmbarAdi write FAmbarAdi;
    Property IsVarsayılanHammaddeAmbari: TFieldDB read FIsVarsayılanHammaddeAmbari write FIsVarsayılanHammaddeAmbari;
    Property IsVarsayilanUretimAmbari: TFieldDB read FIsVarsayilanUretimAmbari write FIsVarsayilanUretimAmbari;
    Property IsVarsayilanSatisAmbari: TFieldDB read FIsVarsayilanSatisAmbari write FIsVarsayilanSatisAmbari;
  end;

implementation

uses
  Ths.Erp.Constants,
  Ths.Erp.Database.Singleton;

constructor TAmbar.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'ambar';
  SourceCode := '1000';

  FAmbarAdi := TFieldDB.Create('ambar_adi', ftString, '');
  FIsVarsayılanHammaddeAmbari := TFieldDB.Create('is_varsayilan_hammadde_ambari', ftBoolean, 0);
  FIsVarsayilanUretimAmbari := TFieldDB.Create('is_varsayilan_uretim_ambari', ftBoolean, 0);
  FIsVarsayilanSatisAmbari := TFieldDB.Create('is_varsayilan_satis_ambari', ftBoolean, 0);
end;

procedure TAmbar.SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
    with QueryOfDS do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLSelectCmd(TableName, [
        TableName + '.' + Self.Id.FieldName,
        TableName + '.' + FAmbarAdi.FieldName,
        TableName + '.' + FIsVarsayılanHammaddeAmbari.FieldName,
        TableName + '.' + FIsVarsayilanUretimAmbari.FieldName,
        TableName + '.' + FIsVarsayilanSatisAmbari.FieldName
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;
      Active := True;

      Self.DataSource.DataSet.FindField(Self.Id.FieldName).DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField(FAmbarAdi.FieldName).DisplayLabel := 'Ambar Adı';
      Self.DataSource.DataSet.FindField(FIsVarsayılanHammaddeAmbari.FieldName).DisplayLabel := 'Varsayılan Hammadde Ambarı?';
      Self.DataSource.DataSet.FindField(FIsVarsayilanUretimAmbari.FieldName).DisplayLabel := 'Varsayılan Üretim Ambarı?';
      Self.DataSource.DataSet.FindField(FIsVarsayilanSatisAmbari.FieldName).DisplayLabel := 'Varsayılan Satış Ambarı?';
    end;
  end;
end;

procedure TAmbar.SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
    if (pLock) then
		  pFilter := pFilter + ' FOR UPDATE OF ' + TableName + ' NOWAIT';

    with QueryOfList do
    begin
      Close;
      SQL.Text := Database.GetSQLSelectCmd(TableName, [
        TableName + '.' + Self.Id.FieldName,
        TableName + '.' + FAmbarAdi.FieldName,
        TableName + '.' + FIsVarsayılanHammaddeAmbari.FieldName,
        TableName + '.' + FIsVarsayilanUretimAmbari.FieldName,
        TableName + '.' + FIsVarsayilanSatisAmbari.FieldName
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;

      FreeListContent();
      List.Clear;
      while NOT EOF do
      begin
        Self.Id.Value := FormatedVariantVal(FieldByName(Self.Id.FieldName).DataType, FieldByName(Self.Id.FieldName).Value);

        FAmbarAdi.Value := FormatedVariantVal(FieldByName(FAmbarAdi.FieldName).DataType, FieldByName(FAmbarAdi.FieldName).Value);
        FIsVarsayılanHammaddeAmbari.Value := FormatedVariantVal(FieldByName(FIsVarsayılanHammaddeAmbari.FieldName).DataType, FieldByName(FIsVarsayılanHammaddeAmbari.FieldName).Value);
        FIsVarsayilanUretimAmbari.Value := FormatedVariantVal(FieldByName(FIsVarsayilanUretimAmbari.FieldName).DataType, FieldByName(FIsVarsayilanUretimAmbari.FieldName).Value);
        FIsVarsayilanSatisAmbari.Value := FormatedVariantVal(FieldByName(FIsVarsayilanSatisAmbari.FieldName).DataType, FieldByName(FIsVarsayilanSatisAmbari.FieldName).Value);

        List.Add(Self.Clone());

        Next;
      end;
      Close;
    end;
  end;
end;

procedure TAmbar.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
    with QueryOfInsert do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLInsertCmd(TableName, QUERY_PARAM_CHAR, [
        FAmbarAdi.FieldName,
        FIsVarsayılanHammaddeAmbari.FieldName,
        FIsVarsayilanUretimAmbari.FieldName,
        FIsVarsayilanSatisAmbari.FieldName
      ]);

      NewParamForQuery(QueryOfInsert, FAmbarAdi);
      NewParamForQuery(QueryOfInsert, FIsVarsayılanHammaddeAmbari);
      NewParamForQuery(QueryOfInsert, FIsVarsayilanUretimAmbari);
      NewParamForQuery(QueryOfInsert, FIsVarsayilanSatisAmbari);

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

procedure TAmbar.Update(pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptUpdate, pPermissionControl) then
  begin
    with QueryOfUpdate do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLUpdateCmd(TableName, QUERY_PARAM_CHAR, [
        FAmbarAdi.FieldName,
        FIsVarsayılanHammaddeAmbari.FieldName,
        FIsVarsayilanUretimAmbari.FieldName,
        FIsVarsayilanSatisAmbari.FieldName
      ]);

      NewParamForQuery(QueryOfUpdate, FAmbarAdi);
      NewParamForQuery(QueryOfUpdate, FIsVarsayılanHammaddeAmbari);
      NewParamForQuery(QueryOfUpdate, FIsVarsayilanUretimAmbari);
      NewParamForQuery(QueryOfUpdate, FIsVarsayilanSatisAmbari);

      NewParamForQuery(QueryOfUpdate, Id);

      ExecSQL;
      Close;
    end;
    Self.notify;
  end;
end;

function TAmbar.Clone():TTable;
begin
  Result := TAmbar.Create(Database);

  Self.Id.Clone(TAmbar(Result).Id);

  FAmbarAdi.Clone(TAmbar(Result).FAmbarAdi);
  FIsVarsayılanHammaddeAmbari.Clone(TAmbar(Result).FIsVarsayılanHammaddeAmbari);
  FIsVarsayilanUretimAmbari.Clone(TAmbar(Result).FIsVarsayilanUretimAmbari);
  FIsVarsayilanSatisAmbari.Clone(TAmbar(Result).FIsVarsayilanSatisAmbari);
end;

end.
