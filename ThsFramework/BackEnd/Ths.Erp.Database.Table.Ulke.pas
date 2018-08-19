unit Ths.Erp.Database.Table.Ulke;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table,
  Ths.Erp.Database.Table.Field;

type
  TUlke = class(TTable)
  private
    FUlkeKodu: TFieldDB;
    FUlkeAdi: TFieldDB;
    FISOYear: TFieldDB;
    FISOCCTLDCode: TFieldDB;
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

    property UlkeKodu: TFieldDB read FUlkeKodu write FUlkeKodu;
    Property UlkeAdi: TFieldDB read FUlkeAdi write FUlkeAdi;
    Property ISOYear: TFieldDB read FISOYear write FISOYear;
    Property ISOCCTLDCode: TFieldDB read FISOCCTLDCode write FISOCCTLDCode;
  end;

implementation

uses
  Ths.Erp.Constants,
  Ths.Erp.Database.Singleton;

constructor TUlke.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'ulke';
  SourceCode := '1000';

  FUlkeKodu := TFieldDB.Create('ulke_kodu', ftString, '');
  FUlkeAdi := TFieldDB.Create('ulke_adi', ftString, '');
  FISOYear := TFieldDB.Create('iso_year', ftInteger, '');
  FISOCCTLDCode := TFieldDB.Create('iso_cctld_code', ftString, '');
end;

procedure TUlke.SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + Self.Id.FieldName,
          TableName + '.' + FUlkeKodu.FieldName,
          TableName + '.' + FUlkeAdi.FieldName,
          TableName + '.' + FIsoYear.FieldName,
          TableName + '.' + FISOCCTLDCode.FieldName
        ]) +
        'WHERE 1=1 ' + pFilter;
		  Open;
		  Active := True;

      Self.DataSource.DataSet.FindField(Self.Id.FieldName).DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField(FUlkeKodu.FieldName).DisplayLabel := '�LKE KODU';
      Self.DataSource.DataSet.FindField(FUlkeAdi.FieldName).DisplayLabel := '�LKE ADI';
      Self.DataSource.DataSet.FindField(FISOYear.FieldName).DisplayLabel := 'YEAR';
      Self.DataSource.DataSet.FindField(FISOCCTLDCode.FieldName).DisplayLabel := 'CCTLD CODE';
	  end;
  end;
end;

procedure TUlke.SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
	  if (pLock) then
		  pFilter := pFilter + ' FOR UPDATE NOWAIT; ';

	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Text := Database.GetSQLSelectCmd(TableName, [
          TableName + '.' + Self.Id.FieldName,
          TableName + '.' + FUlkeKodu.FieldName,
          TableName + '.' + FUlkeAdi.FieldName,
          TableName + '.' + FISOYear.FieldName,
          TableName + '.' + FISOCCTLDCode.FieldName
        ]) +
        'WHERE 1=1 ' + pFilter;
		  Open;

		  FreeListContent();
		  List.Clear;
		  while NOT EOF do
		  begin
		    Self.Id.Value := FormatedVariantVal(FieldByName(Self.Id.FieldName).DataType, FieldByName(Self.Id.FieldName).Value);

		    FUlkeKodu.Value := FormatedVariantVal(FieldByName(FUlkeKodu.FieldName).DataType, FieldByName(FUlkeKodu.FieldName).Value);
        FUlkeAdi.Value := FormatedVariantVal(FieldByName(FUlkeAdi.FieldName).DataType, FieldByName(FUlkeAdi.FieldName).Value);
        FISOYear.Value := FormatedVariantVal(FieldByName(FISOYear.FieldName).DataType, FieldByName(FISOYear.FieldName).Value);
        FISOCCTLDCode.Value := FormatedVariantVal(FieldByName(FISOCCTLDCode.FieldName).DataType, FieldByName(FISOCCTLDCode.FieldName).Value);

		    List.Add(Self.Clone());

		    Next;
		  end;
		  EmptyDataSet;
		  Close;
	  end;
  end;
end;

procedure TUlke.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLInsertCmd(TableName, QUERY_PARAM_CHAR, [
        FUlkeKodu.FieldName,
        FUlkeAdi.FieldName,
        FISOYear.FieldName,
        FISOCCTLDCode.FieldName
      ]);

      NewParamForQuery(QueryOfTable, FUlkeKodu);
      NewParamForQuery(QueryOfTable, FUlkeAdi);
      NewParamForQuery(QueryOfTable, FISOYear);
      NewParamForQuery(QueryOfTable, FISOCCTLDCode);
      
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

procedure TUlke.Update(pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptUpdate, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Database.GetSQLUpdateCmd(TableName, QUERY_PARAM_CHAR, [
		    FUlkeKodu.FieldName,
        FUlkeAdi.FieldName,
        FISOYear.FieldName,
        FISOCCTLDCode.FieldName
      ]);

      NewParamForQuery(QueryOfTable, FUlkeKodu);
      NewParamForQuery(QueryOfTable, FUlkeAdi);
      NewParamForQuery(QueryOfTable, FISOYear);
      NewParamForQuery(QueryOfTable, FISOCCTLDCode);

      NewParamForQuery(QueryOfTable, Id);

		  ExecSQL;
		  Close;
	  end;
    Self.notify;
  end;
end;

procedure TUlke.Clear();
begin
  inherited;
  FUlkeKodu.Value := '';
  FUlkeAdi.Value := '';
  FISOYear.Value := 0;
  FISOCCTLDCode.Value := '';
end;

function TUlke.Clone():TTable;
begin
  Result := TUlke.Create(Database);

  Self.Id.Clone(TUlke(Result).Id);

  FUlkeKodu.Clone(TUlke(Result).FUlkeKodu);
  FUlkeAdi.Clone(TUlke(Result).FUlkeAdi);
  FISOYear.Clone(TUlke(Result).FISOYear);
  FISOCCTLDCode.Clone(TUlke(Result).FISOCCTLDCode);
end;

end.
