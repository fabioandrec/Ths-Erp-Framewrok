unit Ths.Erp.Database.Table.AyarStkCinsOzelligi;

interface

{$I ThsERP.inc}

uses
  SysUtils, Classes, Dialogs, Forms, Windows, Controls, Types, DateUtils,
  FireDAC.Stan.Param, System.Variants, Data.DB,
  Ths.Erp.Database,
  Ths.Erp.Database.Table;

type
  TAyarStkCinsOzelligi = class(TTable)
  private
    FAyarStkCinsAileID: TFieldDB;
    FCins: TFieldDB;
    FAciklama: TFieldDB;
    FString1: TFieldDB;
    FString2: TFieldDB;
    FString3: TFieldDB;
    FString4: TFieldDB;
    FString5: TFieldDB;
    FString6: TFieldDB;
    FString7: TFieldDB;
    FString8: TFieldDB;
    FString9: TFieldDB;
    FString10: TFieldDB;
    FString11: TFieldDB;
    FString12: TFieldDB;
  protected
  published
    constructor Create(OwnerDatabase:TDatabase);override;
  public
    procedure SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True); override;
    procedure SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True); override;
    procedure Insert(out pID: Integer; pPermissionControl: Boolean=True); override;
    procedure Update(pPermissionControl: Boolean=True); override;

    function Clone():TTable;override;

    Property AyarStkCinsAileID: TFieldDB read FAyarStkCinsAileID write FAyarStkCinsAileID;
    Property Cins: TFieldDB read FCins write FCins;
    Property Aciklama: TFieldDB read FAciklama write FAciklama;
    Property String1: TFieldDB read FString1 write FString1;
    Property String2: TFieldDB read FString2 write FString2;
    Property String3: TFieldDB read FString3 write FString3;
    Property String4: TFieldDB read FString4 write FString4;
    Property String5: TFieldDB read FString5 write FString5;
    Property String6: TFieldDB read FString6 write FString6;
    Property String7: TFieldDB read FString7 write FString7;
    Property String8: TFieldDB read FString8 write FString8;
    Property String9: TFieldDB read FString9 write FString9;
    Property String10: TFieldDB read FString10 write FString10;
    Property String11: TFieldDB read FString11 write FString11;
    Property String12: TFieldDB read FString12 write FString12;
  end;

implementation

uses
  Ths.Erp.Constants,
  Ths.Erp.Database.Singleton,
  Ths.Erp.Database.Table.AyarStkCinsAilesi;

constructor TAyarStkCinsOzelligi.Create(OwnerDatabase:TDatabase);
begin
  inherited Create(OwnerDatabase);
  TableName := 'ayar_stk_cins_ozelligi';
  SourceCode := '1000';

  FAyarStkCinsAileID := TFieldDB.Create('ayar_stk_cins_aile_id', ftInteger, 0, 0, True);
  FAyarStkCinsAileID.FK.FKTable := TAyarStkCinsAilesi.Create(Database);
  FAyarStkCinsAileID.FK.FKCol := TFieldDB.Create(TAyarStkCinsAilesi(FAyarStkCinsAileID.FK.FKTable).Aile.FieldName, TAyarStkCinsAilesi(FAyarStkCinsAileID.FK.FKTable).Aile.FieldType, '');
  FCins := TFieldDB.Create('cins', ftString, '');
  FAciklama := TFieldDB.Create('aciklama', ftString, '');
  FString1 := TFieldDB.Create('string1', ftString, '');
  FString2 := TFieldDB.Create('string2', ftString, '');
  FString3 := TFieldDB.Create('string3', ftString, '');
  FString4 := TFieldDB.Create('string4', ftString, '');
  FString5 := TFieldDB.Create('string5', ftString, '');
  FString6 := TFieldDB.Create('string6', ftString, '');
  FString7 := TFieldDB.Create('string7', ftString, '');
  FString8 := TFieldDB.Create('string8', ftString, '');
  FString9 := TFieldDB.Create('string9', ftString, '');
  FString10 := TFieldDB.Create('string10', ftString, '');
  FString11 := TFieldDB.Create('string11', ftString, '');
  FString12 := TFieldDB.Create('string12', ftString, '');
end;

procedure TAyarStkCinsOzelligi.SelectToDatasource(pFilter: string; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptRead, pPermissionControl) then
  begin
    with QueryOfDS do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLSelectCmd(TableName, [
        TableName + '.' + Self.Id.FieldName,
        TableName + '.' + FAyarStkCinsAileID.FieldName,
        ColumnFromIDCol(FAyarStkCinsAileID.FK.FKCol.FieldName, FAyarStkCinsAileID.FK.FKTable.TableName, FAyarStkCinsAileID.FieldName, FAyarStkCinsAileID.FK.FKCol.FieldName, TableName),
        getRawDataByLang(TableName, FCins.FieldName),
        getRawDataByLang(TableName, FAciklama.FieldName),
        getRawDataByLang(TableName, FString1.FieldName),
        getRawDataByLang(TableName, FString2.FieldName),
        getRawDataByLang(TableName, FString3.FieldName),
        getRawDataByLang(TableName, FString4.FieldName),
        getRawDataByLang(TableName, FString5.FieldName),
        getRawDataByLang(TableName, FString6.FieldName),
        getRawDataByLang(TableName, FString7.FieldName),
        getRawDataByLang(TableName, FString8.FieldName),
        getRawDataByLang(TableName, FString9.FieldName),
        getRawDataByLang(TableName, FString10.FieldName),
        getRawDataByLang(TableName, FString11.FieldName),
        getRawDataByLang(TableName, FString12.FieldName)
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;
      Active := True;

      Self.DataSource.DataSet.FindField(Self.Id.FieldName).DisplayLabel := 'ID';
      Self.DataSource.DataSet.FindField(FAyarStkCinsAileID.FieldName).DisplayLabel := 'Ayar Stk Cins Aile ID';
      Self.DataSource.DataSet.FindField(FAyarStkCinsAileID.FK.FKCol.FieldName).DisplayLabel := 'Cins Ailesi';
      Self.DataSource.DataSet.FindField(FCins.FieldName).DisplayLabel := 'Cins';
      Self.DataSource.DataSet.FindField(FAciklama.FieldName).DisplayLabel := 'A��klama';
      Self.DataSource.DataSet.FindField(FString1.FieldName).DisplayLabel := 'String 1';
      Self.DataSource.DataSet.FindField(FString2.FieldName).DisplayLabel := 'String 2';
      Self.DataSource.DataSet.FindField(FString3.FieldName).DisplayLabel := 'String 3';
      Self.DataSource.DataSet.FindField(FString4.FieldName).DisplayLabel := 'String 4';
      Self.DataSource.DataSet.FindField(FString5.FieldName).DisplayLabel := 'String 5';
      Self.DataSource.DataSet.FindField(FString6.FieldName).DisplayLabel := 'String 6';
      Self.DataSource.DataSet.FindField(FString7.FieldName).DisplayLabel := 'String 7';
      Self.DataSource.DataSet.FindField(FString8.FieldName).DisplayLabel := 'String 8';
      Self.DataSource.DataSet.FindField(FString9.FieldName).DisplayLabel := 'String 9';
      Self.DataSource.DataSet.FindField(FString10.FieldName).DisplayLabel := 'String 10';
      Self.DataSource.DataSet.FindField(FString11.FieldName).DisplayLabel := 'String 11';
      Self.DataSource.DataSet.FindField(FString12.FieldName).DisplayLabel := 'String 12';
    end;
  end;
end;

procedure TAyarStkCinsOzelligi.SelectToList(pFilter: string; pLock: Boolean; pPermissionControl: Boolean=True);
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
        TableName + '.' + FAyarStkCinsAileID.FieldName,
        ColumnFromIDCol(FAyarStkCinsAileID.FK.FKCol.FieldName, FAyarStkCinsAileID.FK.FKTable.TableName, FAyarStkCinsAileID.FieldName, FAyarStkCinsAileID.FK.FKCol.FieldName, TableName),
        getRawDataByLang(TableName, FCins.FieldName),
        getRawDataByLang(TableName, FAciklama.FieldName),
        getRawDataByLang(TableName, FString1.FieldName),
        getRawDataByLang(TableName, FString2.FieldName),
        getRawDataByLang(TableName, FString3.FieldName),
        getRawDataByLang(TableName, FString4.FieldName),
        getRawDataByLang(TableName, FString5.FieldName),
        getRawDataByLang(TableName, FString6.FieldName),
        getRawDataByLang(TableName, FString7.FieldName),
        getRawDataByLang(TableName, FString8.FieldName),
        getRawDataByLang(TableName, FString9.FieldName),
        getRawDataByLang(TableName, FString10.FieldName),
        getRawDataByLang(TableName, FString11.FieldName),
        getRawDataByLang(TableName, FString12.FieldName)
      ]) +
      'WHERE 1=1 ' + pFilter;
      Open;

      FreeListContent();
      List.Clear;
      while NOT EOF do
      begin
        Self.Id.Value := FormatedVariantVal(FieldByName(Self.Id.FieldName).DataType, FieldByName(Self.Id.FieldName).Value);

        FAyarStkCinsAileID.Value := FormatedVariantVal(FieldByName(FAyarStkCinsAileID.FieldName).DataType, FieldByName(FAyarStkCinsAileID.FieldName).Value);
        FAyarStkCinsAileID.FK.FKCol.Value := FormatedVariantVal(FieldByName(FAyarStkCinsAileID.FK.FKCol.FieldName).DataType, FieldByName(FAyarStkCinsAileID.FK.FKCol.FieldName).Value);
        FCins.Value := FormatedVariantVal(FieldByName(FCins.FieldName).DataType, FieldByName(FCins.FieldName).Value);
        FAciklama.Value := FormatedVariantVal(FieldByName(FAciklama.FieldName).DataType, FieldByName(FAciklama.FieldName).Value);
        FString1.Value := FormatedVariantVal(FieldByName(FString1.FieldName).DataType, FieldByName(FString1.FieldName).Value);
        FString2.Value := FormatedVariantVal(FieldByName(FString2.FieldName).DataType, FieldByName(FString2.FieldName).Value);
        FString3.Value := FormatedVariantVal(FieldByName(FString3.FieldName).DataType, FieldByName(FString3.FieldName).Value);
        FString4.Value := FormatedVariantVal(FieldByName(FString4.FieldName).DataType, FieldByName(FString4.FieldName).Value);
        FString5.Value := FormatedVariantVal(FieldByName(FString5.FieldName).DataType, FieldByName(FString5.FieldName).Value);
        FString6.Value := FormatedVariantVal(FieldByName(FString6.FieldName).DataType, FieldByName(FString6.FieldName).Value);
        FString7.Value := FormatedVariantVal(FieldByName(FString7.FieldName).DataType, FieldByName(FString7.FieldName).Value);
        FString8.Value := FormatedVariantVal(FieldByName(FString8.FieldName).DataType, FieldByName(FString8.FieldName).Value);
        FString9.Value := FormatedVariantVal(FieldByName(FString9.FieldName).DataType, FieldByName(FString9.FieldName).Value);
        FString10.Value := FormatedVariantVal(FieldByName(FString10.FieldName).DataType, FieldByName(FString10.FieldName).Value);
        FString11.Value := FormatedVariantVal(FieldByName(FString11.FieldName).DataType, FieldByName(FString11.FieldName).Value);
        FString12.Value := FormatedVariantVal(FieldByName(FString12.FieldName).DataType, FieldByName(FString12.FieldName).Value);

        List.Add(Self.Clone());

        Next;
      end;
      Close;
    end;
  end;
end;

procedure TAyarStkCinsOzelligi.Insert(out pID: Integer; pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptAddRecord, pPermissionControl) then
  begin
    with QueryOfInsert do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLInsertCmd(TableName, QUERY_PARAM_CHAR, [
        FAyarStkCinsAileID.FieldName,
        FCins.FieldName,
        FAciklama.FieldName,
        FString1.FieldName,
        FString2.FieldName,
        FString3.FieldName,
        FString4.FieldName,
        FString5.FieldName,
        FString6.FieldName,
        FString7.FieldName,
        FString8.FieldName,
        FString9.FieldName,
        FString10.FieldName,
        FString11.FieldName,
        FString12.FieldName
      ]);

      NewParamForQuery(QueryOfInsert, FAyarStkCinsAileID);
      NewParamForQuery(QueryOfInsert, FCins);
      NewParamForQuery(QueryOfInsert, FAciklama);
      NewParamForQuery(QueryOfInsert, FString1);
      NewParamForQuery(QueryOfInsert, FString2);
      NewParamForQuery(QueryOfInsert, FString3);
      NewParamForQuery(QueryOfInsert, FString4);
      NewParamForQuery(QueryOfInsert, FString5);
      NewParamForQuery(QueryOfInsert, FString6);
      NewParamForQuery(QueryOfInsert, FString7);
      NewParamForQuery(QueryOfInsert, FString8);
      NewParamForQuery(QueryOfInsert, FString9);
      NewParamForQuery(QueryOfInsert, FString10);
      NewParamForQuery(QueryOfInsert, FString11);
      NewParamForQuery(QueryOfInsert, FString12);

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

procedure TAyarStkCinsOzelligi.Update(pPermissionControl: Boolean=True);
begin
  if IsAuthorized(ptUpdate, pPermissionControl) then
  begin
    with QueryOfUpdate do
    begin
      Close;
      SQL.Clear;
      SQL.Text := Database.GetSQLUpdateCmd(TableName, QUERY_PARAM_CHAR, [
        FAyarStkCinsAileID.FieldName,
        FCins.FieldName,
        FAciklama.FieldName,
        FString1.FieldName,
        FString2.FieldName,
        FString3.FieldName,
        FString4.FieldName,
        FString5.FieldName,
        FString6.FieldName,
        FString7.FieldName,
        FString8.FieldName,
        FString9.FieldName,
        FString10.FieldName,
        FString11.FieldName,
        FString12.FieldName
      ]);

      NewParamForQuery(QueryOfUpdate, FAyarStkCinsAileID);
      NewParamForQuery(QueryOfUpdate, FCins);
      NewParamForQuery(QueryOfUpdate, FAciklama);
      NewParamForQuery(QueryOfUpdate, FString1);
      NewParamForQuery(QueryOfUpdate, FString2);
      NewParamForQuery(QueryOfUpdate, FString3);
      NewParamForQuery(QueryOfUpdate, FString4);
      NewParamForQuery(QueryOfUpdate, FString5);
      NewParamForQuery(QueryOfUpdate, FString6);
      NewParamForQuery(QueryOfUpdate, FString7);
      NewParamForQuery(QueryOfUpdate, FString8);
      NewParamForQuery(QueryOfUpdate, FString9);
      NewParamForQuery(QueryOfUpdate, FString10);
      NewParamForQuery(QueryOfUpdate, FString11);
      NewParamForQuery(QueryOfUpdate, FString12);

      NewParamForQuery(QueryOfUpdate, Id);

      ExecSQL;
      Close;
    end;
    Self.notify;
  end;
end;

function TAyarStkCinsOzelligi.Clone():TTable;
begin
  Result := TAyarStkCinsOzelligi.Create(Database);

  Self.Id.Clone(TAyarStkCinsOzelligi(Result).Id);

  FAyarStkCinsAileID.Clone(TAyarStkCinsOzelligi(Result).FAyarStkCinsAileID);
  FCins.Clone(TAyarStkCinsOzelligi(Result).FCins);
  FAciklama.Clone(TAyarStkCinsOzelligi(Result).FAciklama);
  FString1.Clone(TAyarStkCinsOzelligi(Result).FString1);
  FString2.Clone(TAyarStkCinsOzelligi(Result).FString2);
  FString3.Clone(TAyarStkCinsOzelligi(Result).FString3);
  FString4.Clone(TAyarStkCinsOzelligi(Result).FString4);
  FString5.Clone(TAyarStkCinsOzelligi(Result).FString5);
  FString6.Clone(TAyarStkCinsOzelligi(Result).FString6);
  FString7.Clone(TAyarStkCinsOzelligi(Result).FString7);
  FString8.Clone(TAyarStkCinsOzelligi(Result).FString8);
  FString9.Clone(TAyarStkCinsOzelligi(Result).FString9);
  FString10.Clone(TAyarStkCinsOzelligi(Result).FString10);
  FString11.Clone(TAyarStkCinsOzelligi(Result).FString11);
  FString12.Clone(TAyarStkCinsOzelligi(Result).FString12);
end;

end.
