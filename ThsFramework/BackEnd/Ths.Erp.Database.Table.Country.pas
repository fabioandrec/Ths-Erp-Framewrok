unit Ths.Erp.Database.Table.Country;

interface

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants,
  Ths.Erp.Database,
  Ths.Erp.Database.Table;

type
  TCountry = class(TTable)
  private
    FCountryCode       : string;
    FCountryName       : string;
    FISOYear           : Integer;
    FISOCCTLDCode      : string;
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

    Property CountryCode    : string    read FCountryCode        write FCountryCode;
    Property CountryName    : string    read FCountryName        write FCountryName;
    Property ISOYear        : Integer   read FISOYear            write FISOYear;
    Property ISOCCTLDCode   : string    read FISOCCTLDCode       write FISOCCTLDCode;
  end;

implementation

uses
  Ths.Erp.Constants;

constructor TCountry.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'country';
end;

procedure TCountry.SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True);
begin
  if Self.IsAuthorized(ptRead, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Self.Database.GetSQLSelectCmd(TableName,
        [TableName + '.' + 'id',
        TableName + '.' + 'country_code',
        TableName + '.' + 'country_name',
        TableName + '.' + 'iso_year',
        TableName + '.' + 'iso_cctld_code']) +
        'WHERE 1=1 ' + pFilter;
		  Open;
		  Active := True;

      Self.DataSource.DataSet.FindField('id').DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField('country_code').DisplayLabel := 'COUNTRY CODE';
      Self.DataSource.DataSet.FindField('country_name').DisplayLabel := 'COUNTRY NAME';
      Self.DataSource.DataSet.FindField('iso_year').DisplayLabel := 'YEAR';
      Self.DataSource.DataSet.FindField('iso_cctld_code').DisplayLabel := 'CCTLD CODE';
	  end;
  end;
end;

procedure TCountry.SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True);
begin
  if Self.IsAuthorized(ptRead, pPermissionControl) then
  begin
	  if (pLock) then
		  pFilter := pFilter + ' FOR UPDATE NOWAIT; ';

	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Text := Self.Database.GetSQLSelectCmd(TableName,
        [TableName + '.' + 'id',
        TableName + '.' + 'country_code',
        TableName + '.' + 'country_name',
        TableName + '.' + 'iso_year',
        TableName + '.' + 'iso_cctld_code']) +
        ' WHERE 1=1 ' + pFilter;
		  Open;

		  FreeListContent();
		  List.Clear;
		  while NOT EOF do
		  begin
		    Self.Id           := FieldByName('id').AsInteger;

		    Self.FCountryCode     := FieldByName('country_code').AsString;
        Self.FCountryName     := FieldByName('country_name').AsString;
        Self.FISOYear         := FieldByName('iso_year').AsInteger;
        Self.FISOCCTLDCode    := FieldByName('iso_cctld_code').AsString;

		    List.Add(Self.Clone());

		    Next;
		  end;
		  EmptyDataSet;
		  Close;
	  end;
  end;
end;

procedure TCountry.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if Self.IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
      Close;
      SQL.Clear;
      SQL.Text := Self.Database.GetSQLInsertCmd(TableName, SQL_PARAM_SEPERATE,
        ['country_code', 'country_name', 'iso_year', 'iso_cctld_code']);

      ParamByName('country_code').Value := Self.FCountryCode;
      ParamByName('country_name').Value := Self.FCountryName;
      ParamByName('iso_year').Value := Self.FISOYear;
      ParamByName('iso_cctld_code').Value := Self.ISOCCTLDCode;

      Database.SetQueryParamsDefaultValue(QueryOfTable);

      Open;
      if (Fields.Count > 0) and (not Fields.Fields[0].IsNull) then
        pID := Fields.FieldByName('id').AsInteger
      else
        pID := 0;

      EmptyDataSet;
      Close;
	  end;
    Self.notify;
  end;
end;

procedure TCountry.Update(pPermissionControl: Boolean=True);
begin
  if Self.IsAuthorized(ptUpdate, pPermissionControl) then
  begin
	  with QueryOfTable do
	  begin
		  Close;
		  SQL.Clear;
		  SQL.Text := Self.Database.GetSQLUpdateCmd(TableName, SQL_PARAM_SEPERATE,
		    ['country_code', 'country_name', 'iso_year', 'iso_cctld_code']);

      ParamByName('country_code').Value := Self.FCountryCode;
      ParamByName('country_name').Value := Self.FCountryName;
      ParamByName('iso_year').Value := Self.FISOYear;
      ParamByName('iso_cctld_code').Value := Self.FISOCCTLDCode;

		  ParamByName('id').Value := Self.Id;

      Database.SetQueryParamsDefaultValue(QueryOfTable);

		  ExecSQL;
		  Close;
	  end;
    Self.notify;
  end;
end;

procedure TCountry.Clear();
begin
  inherited;
  self.FCountryCode := '';
  self.FCountryName := '';
  self.FISOYear := 0;
  self.FISOCCTLDCode := '';
end;

function TCountry.Clone():TTable;
begin
  Result := TCountry.Create(Database);
  TCountry(Result).FCountryCode          := Self.FCountryCode;
  TCountry(Result).FCountryName          := Self.FCountryName;
  TCountry(Result).FISOYear              := Self.FISOYear;
  TCountry(Result).FISOCCTLDCode         := Self.FISOCCTLDCode;

  TCountry(Result).Id              := Self.Id;
end;

end.
