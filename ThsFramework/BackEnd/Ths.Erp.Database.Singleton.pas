{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit Ths.Erp.Database.Singleton;

interface

uses
  IniFiles, SysUtils, WinTypes, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.StdCtrls,
  Data.DB, FireDAC.Stan.Param, FireDAC.Comp.Client, System.Variants,
  Vcl.ImgList,
  Ths.Erp.Database,
  Ths.Erp.Database.Table.Field,
  Ths.Erp.Database.Table.SysUser,
  Ths.Erp.Database.Table.AyarHaneSayisi,
  Ths.Erp.Database.Table.SysApplicationSettings;

type
  TSingletonDB = class(TObject)
  strict private
    class var FInstance: TSingletonDB;
    constructor CreatePrivate;
  private
    FDataBase: TDatabase;
    FUser: TSysUser;
    FHaneMiktari: TAyarHaneSayisi;
    FApplicationSetting: TSysApplicationSettings;
    FImageList32: TImageList;
    FImageList16: TImageList;
  public
    property DataBase: TDatabase read FDataBase write FDataBase;
    property User: TSysUser read FUser write FUser;
    property HaneMiktari: TAyarHaneSayisi read FHaneMiktari write FHaneMiktari;
    property ApplicationSetting: TSysApplicationSettings read FApplicationSetting write FApplicationSetting;
    property ImageList32: TImageList read FImageList32 write FImageList32;
    property ImageList16: TImageList read FImageList16 write FImageList16;

    constructor Create;
    class function GetInstance(): TSingletonDB;

    destructor Destroy; override;

    function GetGridDefaultOrderFilter(pKey: string; pIsOrder: Boolean): string;
    function GetIsRequired(pTableName, pFieldName: string): Boolean;
    function GetMaxLength(pTableName, pFieldName: string): Integer;
    function GetQualityFormNo(pTableName: string): string;

    procedure FillTableName(var pComboBox: TComboBox);
    procedure FillColName(var pComboBox: TComboBox; pTableName: string);
    procedure FillColNameForColWidth(var pComboBox: TComboBox; pTableName: string);
    function GetDistinctColumnName(pTableName: string): TStringList;

    function AddImalgeToImageList(pFileName: string; pList: TImageList;
        out pImageIndex: Integer): Boolean;

    function FillComboFromLangData(pComboBox: TComboBox; pBaseTableName, pBaseColName: string; pRowID: Integer): string;
  end;


  function ColumnFromIDCol(pRawTableColName, pRawTableName, pDataColName,
      pVirtualColName, pDataTableName: string; pIsNumericVal: Boolean = False): string;
  function TranslateText(pDefault, pCode, pTip: string; pTable: string=''): string;
  function FormatedVariantVal(pType: TFieldType; pVal: Variant): Variant;
  function Login(pUserName,pPassword: string): Integer;
  function ReplaceToRealColOrTableName(const pTableName: string): string;
  function ReplaceRealColOrTableNameTo(const pTableName: string): string;
  function GetRawDataSQLByLang(pBaseTableName, pBaseColName: string): string;
  procedure NewParamForQuery(pQuery: TFDQuery; pField: TFieldDB);

  /// <summary>
  ///   A��k olan ekrandaki se�ili olan s�tunun geni�lik bilgisini,
  ///  h�zl� bir �ekilde DB taraf�nda g�ncellenmesi i�lemini yap�yor.
  ///  ��lemin normal yoldan yap�lmas� i�in ana formda �ablon ayarlar�ndan
  ///  Grid Kolon Geni�likleri i�ine girip gerekli kayd� bulduktan sonra
  //   g�ncelleme i�leminin yap�lmas� ile oluyor.
  /// </summary>
  /// <remarks>
  ///   A��k ekrandaki s�tun geni�li�inin DB kayd�n� g�ncellemek i�in bu fonksiyon yazildi.
  /// </remarks>
  function UpdateColWidth(pTableName, pColName: string; pColWidth: Integer): Boolean;
var
  SingletonDB: TSingletonDB;
  vLangContent, vLangContent2: string;

implementation

uses
  Ths.Erp.Database.Table.View.SysViewColumns,
  Ths.Erp.Database.Table.SysGridDefaultOrderFilter,
  Ths.Erp.Constants, Ths.Erp.Database.Table, Ths.Erp.Database.Table.SysGridColWidth;

function FormatedVariantVal(pType: TFieldType; pVal: Variant): Variant;
var
  vValueInt: Integer;
  vValueDouble: Double;
  vValueBool: Boolean;
  vValueDateTime: TDateTime;
begin
  if (pType = ftString)
  or (pType = ftMemo)
  or (pType = ftWideString)
  or (pType = ftWideMemo)
  or (pType = ftWideString)
  then
  begin
    if not VarIsNull(pVal) then
    begin
      Result := VarToStr(pVal)
    end
    else
      Result := '';
  end
  else
  if (pType = ftSmallint)
  or (pType = ftShortint)
  or (pType = ftInteger)
  or (pType = ftLargeint)
  or (pType = ftWord)
  or (pType = ftBCD)
  then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToInt(pVal, vValueInt) then
        Result := VarToStr(pVal).ToInteger
      else
        Result := 0;
    end
    else
      Result := 0;
  end
  else
  if (pType = ftDate) then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToDate(pVal, vValueDateTime) then
        Result := StrToDate(VarToStr(pVal))
      else
        Result := 0;
    end
    else
      Result := 0;
  end
  else
  if (pType = ftDateTime) then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToDateTime(pVal, vValueDateTime) then
        Result := StrToDateTime(VarToStr(pVal))
      else
        Result := 0;
    end
    else
      Result := 0;
  end
  else
  if (pType = ftTime)
  or (pType = ftTimeStamp)
  then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToTime(pVal, vValueDateTime) then
        Result := StrToTime(VarToStr(pVal))
      else
        Result := 0;
    end
    else
      Result := 0;
  end
  else
  if (pType = ftFloat)
  or (pType = ftCurrency)
  or (pType = ftSingle)
  then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToFloat(pVal, vValueDouble) then
        Result := VarToStr(pVal).ToDouble
      else
        Result := 0.0;
    end
    else
      Result := 0.0;
  end
  else
  if (pType = ftBoolean) then
  begin
    if not VarIsNull(pVal) then
    begin
      if TryStrToBool(pVal, vValueBool) then
        Result := VarToStr(pVal).ToBoolean
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
  if (pType = ftBlob) then
    Result := pVal
  else
    Result := pVal;
end;

function ColumnFromIDCol(pRawTableColName, pRawTableName, pDataColName,
    pVirtualColName, pDataTableName: string; pIsNumericVal: Boolean = False): string;
begin
  if pIsNumericVal then
    Result := '(SELECT raw' + pRawTableName + '.' + pRawTableColName + ' FROM ' + pRawTableName + ' as raw' + pRawTableName +
              ' WHERE raw' + pRawTableName + '.id=' + pDataTableName + '.' + pDataColName + ') as ' + pVirtualColName
  else
    Result :=
        '(SELECT get_lang_text(' +
          '(SELECT raw' + pRawTableName + '.' + pRawTableColName + ' FROM ' + pRawTableName + ' as raw' + pRawTableName +
          ' WHERE raw' + pRawTableName + '.id=' + pDataTableName + '.' + pDataColName + ')' + ',' +
          QuotedStr(ReplaceRealColOrTableNameTo(pRawTableName) ) + ',' +
          QuotedStr(ReplaceRealColOrTableNameTo(pRawTableColName)) + ', ' +
          pDataColName + ', ' +
          QuotedStr(TSingletonDB.GetInstance.DataBase.ConnSetting.Language) + ')) as ' + pVirtualColName;
end;

//function ColumnFromOtherTable(pTableNameData, pColNameData, pKeyColNameData,
//    pTableNameOther, pColNameOtherData, pTableName, pVirtualColName: string): string;
//begin
//
// 'SELECT bolum FROM ayar_personel_bolum WHERE id=(SELECT bolum_id FROM ayar_personel_birim WHERE id=2)'
//
//  Result := '(SELECT raw' + pRawTableName + '.' + pRawTableColName + ' FROM ' + pRawTableName + ' as raw' + pRawTableName +
//            ' WHERE raw' + pRawTableName + '.id=' + pDataTableName + '.' + pDataColName + ') as ' + pVirtualColName
//end;

function TranslateText(pDefault, pCode, pTip: string; pTable: string=''): string;
var
  Query: TFDQuery;
  vFilter: string;
begin
  Result := pDefault;

  vFilter := 'lang=' + QUERY_PARAM_CHAR + 'lang AND code=' + QUERY_PARAM_CHAR + 'code AND content_type=' + QUERY_PARAM_CHAR + 'content_type';

  if pTable <> '' then
    vFilter := vFilter + ' AND table_name=' + QUERY_PARAM_CHAR + 'table_name';

  if TSingletonDB.GetInstance.DataBase.Connection.Connected then
  begin
    Query := TSingletonDB.GetInstance.DataBase.NewQuery;
    try
      with Query do
      begin
        Close;
        SQL.Text := 'SELECT value FROM sys_lang_gui_content ' +
                    'WHERE 1=1 AND ' + vFilter;
        ParamByName('lang').Value := TSingletonDB.GetInstance.DataBase.ConnSetting.Language;
        ParamByName('code').Value := pCode;
        ParamByName('content_type').Value := pTip;
        if pTable <> '' then
          ParamByName('table_name').Value := pTable;
        Open;

        if not (Fields.Fields[0].IsNull) then
          Result := Fields.Fields[0].AsString;

        if Result = '' then
          Result := pDefault;

        EmptyDataSet;
        Close;
      end;
    finally
      Query.Free;
    end;
  end;
end;

function Login(pUserName,pPassword: string): Integer;
begin
  Result := 0;
end;

function ReplaceToRealColOrTableName(const pTableName: string): string;
begin
  Result := StringReplace(pTableName, ' ', '_', [rfReplaceAll]);
  Result := LowerCase(Result);
end;

function ReplaceRealColOrTableNameTo(const pTableName: string): string;
var
  n1: Integer;
  vDump: string;
begin
  vDump := StringReplace(pTableName, '_', ' ', [rfReplaceAll]);

  if vDump = '' then
    Result := ''
  else
  begin
    Result := Uppercase(vDump[1]);
    for n1 := 2 to Length(vDump) do
    begin
      if vDump[n1-1] = ' ' then
        Result := Result + Uppercase(vDump[n1])
      else
        Result := Result + Lowercase(vDump[n1]);
    end;
  end;

end;

function GetRawDataSQLByLang(pBaseTableName, pBaseColName: string): string;
begin
  Result :=
    '(SELECT ' +
    '  CASE WHEN ' +
		'    (SELECT b.value FROM sys_lang_data_content b WHERE b.table_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pBaseTableName)) +
                                                       ' AND b.column_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pBaseColName)) +
                                                       ' AND b.lang=' + QuotedStr(TSingletonDB.GetInstance.DataBase.ConnSetting.Language) +
                                                       ' AND b.row_id = ' + pBaseTableName + '.id) IS NULL THEN ' + pBaseTableName + '.' + pBaseColName +
		'  ELSE ' +
		'    (SELECT b.value FROM sys_lang_data_content b WHERE b.table_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pBaseTableName)) +
                                                       ' AND b.column_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pBaseColName)) +
                                                       ' AND b.lang=' + QuotedStr(TSingletonDB.GetInstance.DataBase.ConnSetting.Language) +
                                                       ' AND b.row_id = ' + pBaseTableName + '.id)' +
		'  END ' +
	  ')::varchar as ' + pBaseColName
end;

procedure NewParamForQuery(pQuery: TFDQuery; pField: TFieldDB);
begin
  pQuery.Params.ParamByName(pField.FieldName).Value := FormatedVariantVal(pField.FieldType, pField.Value);
  if pField.IsNullable or pField.IsForeignKey then
  begin

    if (pField.FieldType = ftString)
    or (pField.FieldType = ftMemo)
    or (pField.FieldType = ftWideString)
    or (pField.FieldType = ftWideMemo)
    or (pField.FieldType = ftWideString)
    then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = '' then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null
    end
    else
    if (pField.FieldType = ftSmallint)
    or (pField.FieldType = ftShortint)
    or (pField.FieldType = ftInteger)
    or (pField.FieldType = ftLargeint)
    or (pField.FieldType = ftWord)
    or (pField.FieldType = ftBCD)
    then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = 0 then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null
    end
    else
    if (pField.FieldType = ftDate) then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = 0 then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null
    end
    else if (pField.FieldType = ftDateTime) then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = 0 then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null
    end;
    if (pField.FieldType = ftTime)
    or (pField.FieldType = ftTimeStamp)
    then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = 0 then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null;
    end
    else
    if (pField.FieldType = ftFloat)
    or (pField.FieldType = ftCurrency)
    or (pField.FieldType = ftSingle)
    then
    begin
      if pQuery.Params.ParamByName(pField.FieldName).Value = 0 then
        pQuery.Params.ParamByName(pField.FieldName).Value := Null;
    end;
  end;
end;

function UpdateColWidth(pTableName, pColName: string; pColWidth: Integer): Boolean;
var
  vSysGridColWidth: TSysGridColWidth;
begin
  Result := False;
  vSysGridColWidth := TSysGridColWidth.Create(TSingletonDB.GetInstance.DataBase);
  try
    vSysGridColWidth.Clear;
    vSysGridColWidth.SelectToList(
      ' AND ' + vSysGridColWidth.TableName + '.' + vSysGridColWidth.TableName1.FieldName + '=' + QuotedStr(ReplaceRealColOrTableNameTo(pTableName)) +
      ' AND ' + vSysGridColWidth.TableName + '.' + vSysGridColWidth.ColumnName.FieldName + '=' + QuotedStr(ReplaceRealColOrTableNameTo(pColName)),
      False, False);

    if vSysGridColWidth.List.Count = 1 then
    begin
      vSysGridColWidth.ColumnWidth.Value := pColWidth;
      vSysGridColWidth.Update(False);
      Result := True;
      end;
  finally
    vSysGridColWidth.Free;
  end;
end;

function TSingletonDB.AddImalgeToImageList(pFileName: string; pList: TImageList;
  out pImageIndex: Integer): Boolean;
var
  mImage: TPicture;
  mBitmap: TBitmap;
Begin
  Result := False;
  pImageIndex := -1;
  if pList <> nil then
  begin
    if FileExists(pFilename, True) then
    begin
      mImage := TPicture.Create;
      try
        try
          mImage.LoadFromFile(pFileName);
        except
        end;

        if (mImage.Width > 0) and (mImage.Height > 0) then
        begin
          mBitmap := TBitmap.Create;
          try
            mBitmap.Assign(mImage.Graphic);

            pImageIndex := pList.add(mBitmap, nil);
            Result := True;
          finally
            mBitmap.Free;
          end;
        end
      finally
        mImage.Free;
      end;
    end;
  end;
end;

constructor TSingletonDB.Create();
begin
  raise Exception.Create('Object Singleton');
end;

constructor TSingletonDB.CreatePrivate;
var
  nIndex: Integer;
  vPath: string;
begin
  inherited Create;

  if Self.FDataBase = nil then
    FDataBase := TDatabase.Create;

  if Self.FUser = nil then
    FUser := TSysUser.Create(Self.FDataBase);

  if Self.FHaneMiktari = nil then
    FHaneMiktari := TAyarHaneSayisi.Create(Self.FDataBase);

  if Self.FApplicationSetting = nil then
    FApplicationSetting := TSysApplicationSettings.Create(Self.FDataBase);

  if Self.ImageList32 = nil then
  begin
    FImageList32 := TImageList.Create(nil);
    FImageList32.Clear;
    FImageList32.SetSize(32, 32);
    FImageList32.Masked := False;
    FImageList32.ColorDepth := cd32Bit;
    FImageList32.DrawingStyle := dsTransparent;

    vPath := ExtractFilePath(Application.ExeName) + PATH_ICONS_32 + '/';

    AddImalgeToImageList(vPath + 'accept' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'add' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'application' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'archive' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'attachment' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'back' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'calculator' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'calendar' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'chart' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'clock' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'comment' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'community_users' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'computer' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'money' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'database' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'down' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'close' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'excel_exports' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'favorite' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'folder' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'forward_new_mail' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'help' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'home' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'image' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'info' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'lock' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'lock_disabled' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'lock_off' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'lock_off_disabled' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'mail' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'movie_track' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'next' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'note_edit' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'page' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'page_search' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'pause' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'pdf' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'play' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'printer' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'printer_search' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'process' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'record' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'remove' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'repeat' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'rewind' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'rss' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'search' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'she_user' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'shopping_cart' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'skip_backward' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'skip_forward' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'stock' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'stock_add' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'stock_delete' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'sum' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'up' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'user' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'user_comments' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'users' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'warning' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'window' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'word' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'filter' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'filter_add' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'filter_clear' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'excel_imports' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'preview' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'copy' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'add_data' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
    AddImalgeToImageList(vPath + 'col_width' + '.' + FILE_EXTENSION_PNG, FImageList32, nIndex);
  end;

  if Self.ImageList16 = nil then
  begin
    FImageList16 := TImageList.Create(nil);
    FImageList16.Clear;
    FImageList16.SetSize(16, 16);
    FImageList16.Masked := False;
    FImageList16.ColorDepth := cd32Bit;
    FImageList16.DrawingStyle := dsTransparent;

    vPath := ExtractFilePath(Application.ExeName) + PATH_ICONS_16 + '/';

    AddImalgeToImageList(vPath + 'accept' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'add' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'application' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'archive' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'attachment' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'back' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'calculator' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'calendar' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'chart' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'clock' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'comment' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'community_users' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'computer' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'money' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'database' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'down' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'close' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'excel_exports' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'favorite' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'folder' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'forward_new_mail' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'help' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'home' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'image' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'info' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'lock' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'lock_disabled' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'lock_off' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'lock_off_disabled' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'mail' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'movie_track' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'next' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'note_edit' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'page' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'page_search' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'pause' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'pdf' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'play' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'printer' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'printer_search' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'process' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'record' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'remove' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'repeat' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'rewind' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'rss' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'search' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'she_user' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'shopping_cart' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'skip_backward' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'skip_forward' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'stock' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'stock_add' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'stock_delete' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'sum' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'up' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'user' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'user_comments' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'users' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'warning' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'window' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'word' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'filter' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'filter_add' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'filter_clear' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'excel_imports' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'preview' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'copy' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'add_data' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
    AddImalgeToImageList(vPath + 'col_width' + '.' + FILE_EXTENSION_PNG, FImageList16, nIndex);
  end;
end;

destructor TSingletonDB.Destroy();
begin
  if SingletonDB <> Self then
  begin
    SingletonDB := nil;
  end;

  FUser.Free;
  FHaneMiktari.Free;
  FDataBase.Free;
  FApplicationSetting.Free;
  FImageList32.Free;
  FImageList16.Free;

  inherited Destroy;
end;

class function TSingletonDB.GetInstance: TSingletonDB;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonDB.CreatePrivate;
  Result := FInstance;
end;

function TSingletonDB.GetGridDefaultOrderFilter(pKey: string; pIsOrder: Boolean): string;
var
  vSysGridDefaultOrderFilter: TSysGridDefaultOrderFilter;
  vOrderFilter: string;
begin
  Result := '';
  if pIsOrder then
    vOrderFilter := ' and is_order=True'
  else
    vOrderFilter := ' and is_order=False';

  vSysGridDefaultOrderFilter := TSysGridDefaultOrderFilter.Create(TSingletonDB.GetInstance.DataBase);
  try
    vSysGridDefaultOrderFilter.SelectToList(vOrderFilter + ' and key=' + QuotedStr(pKey), False, False);
    if vSysGridDefaultOrderFilter.List.Count=1 then
      Result := TSysGridDefaultOrderFilter(vSysGridDefaultOrderFilter.List[0]).Value.Value;
  finally
    vSysGridDefaultOrderFilter.Free;
  end;

  if Trim(Result) <> '' then
    if not pIsOrder then
      Result := ' AND ' + Result;
end;

function TSingletonDB.GetIsRequired(pTableName, pFieldName: string): Boolean;
var
  vSysInputGui: TSysViewColumns;
begin
  Result := False;

  vSysInputGui := TSysViewColumns.Create(TSingletonDB.GetInstance.DataBase);
  try
    vSysInputGui.SelectToList(' and table_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pTableName)) +
                              ' and column_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pFieldName)), False, False);
    if vSysInputGui.List.Count=1 then
      Result := TSysViewColumns(vSysInputGui.List[0]).IsNullable.Value = 'NO';
  finally
    vSysInputGui.Free;
  end;
end;

function TSingletonDB.FillComboFromLangData(pComboBox: TComboBox; pBaseTableName,
    pBaseColName: string; pRowID: Integer): string;
begin
  pComboBox.Clear;
  with DataBase.NewQuery do
  try
    Close;
    SQL.Text :=
        'SELECT ' +
        ' CASE ' +
        '   WHEN b.value IS NULL THEN a.' + pBaseColName + ' ' +
        '   ELSE b.value ' +
        ' END as value ' +
        'FROM public.' + pBaseTableName + ' a ' +
        'LEFT JOIN sys_lang_data_content b ON b.row_id = a.id ' +
        '   AND b.table_name = ' + QuotedStr( ReplaceRealColOrTableNameTo(pBaseTableName) ) + ' ' +
        '   AND b.lang=' + QuotedStr(Self.FInstance.DataBase.ConnSetting.Language);
    Open;
    while NOT EOF do
    begin
      pComboBox.Items.Add(Fields.Fields[0].AsString);
      Next;
    end;
    EmptyDataSet;
    Close;
  finally
    Free;
  end;
end;

function TSingletonDB.GetMaxLength(pTableName, pFieldName: string): Integer;
var
  vSysInputGui: TSysViewColumns;
begin
  Result := 0;

  vSysInputGui := TSysViewColumns.Create(TSingletonDB.GetInstance.DataBase);
  try
    vSysInputGui.SelectToList(' and table_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pTableName)) +
                              ' and column_name=' + QuotedStr(ReplaceRealColOrTableNameTo(pFieldName)), False, False);
    if vSysInputGui.List.Count=1 then
      Result := TSysViewColumns(vSysInputGui.List[0]).CharacterMaximumLength.Value;
  finally
    vSysInputGui.Free;
  end;
end;

function TSingletonDB.GetQualityFormNo(pTableName: string): string;
var
  Query: TFDQuery;
begin
  Result := '';

  pTableName := ReplaceRealColOrTableNameTo(pTableName);

  if Self.FInstance.DataBase.Connection.Connected then
  begin
    Query := Self.FInstance.DataBase.NewQuery;
    try
      with Query do
      begin
        Close;
        SQL.Text := 'SELECT form_no FROM sys_quality_form_number WHERE table_name=:table_name;';
        ParamByName('table_name').Value := pTableName;
        Open;

        if (not (Fields.Fields[0].IsNull)) and (Fields.Fields[0].AsString <> '') then
          Result := Fields.Fields[0].AsString;

        EmptyDataSet;
        Close;
      end;
    finally
      Query.Free;
    end;
  end;
end;

procedure TSingletonDB.FillTableName(var pComboBox: TComboBox);
begin
  pComboBox.Clear;
  with Self.DataBase.NewQuery do
  try
    Close;
    SQL.Text := 'SELECT distinct table_name, table_type FROM sys_view_columns ' +
                'GROUP BY table_name, table_type ' +
                'ORDER BY table_type, table_name ASC';
    Open;
    while NOT EOF do
    begin
      pComboBox.Items.Add(Fields.Fields[0].AsString);
      Next;
    end;
    EmptyDataSet;
    Close;
  finally
    Free;
  end;
end;

function TSingletonDB.GetDistinctColumnName(pTableName: string): TStringList;
begin
  Result := TStringList.Create;
  with DataBase.NewQuery do
  try
    Close;
    SQL.Text := 'SELECT distinct v.column_name FROM sys_view_columns v ' +
                ' LEFT JOIN sys_grid_col_width a ON a.table_name=v.table_name and a.column_name = v.column_name ' +
                ' WHERE v.table_name=' + QuotedStr(pTableName) + ' and a.column_name is null ';
    Open;
    while NOT EOF do
    begin
      Result.Add( Fields.Fields[0].AsString );
      Next;
    end;
    EmptyDataSet;
    Close;
  finally
    Free;
  end;
end;

procedure TSingletonDB.FillColName(var pComboBox: TComboBox; pTableName: string);
begin
  pComboBox.Clear;

  with DataBase.NewQuery do
  try
    Close;
    SQL.Text := 'SELECT distinct column_name, ordinal_position FROM sys_view_columns ' +
                'WHERE table_name=' + QuotedStr(pTableName) + ' ' +
                'GROUP BY column_name, ordinal_position ' +
                'ORDER BY ordinal_position ASC ';
    Open;
    while NOT EOF do
    begin
      pComboBox.Items.Add( Fields.Fields[0].AsString );
      Next;
    end;
    EmptyDataSet;
    Close;
  finally
    Free;
  end;
end;

procedure TSingletonDB.FillColNameForColWidth(var pComboBox: TComboBox; pTableName: string);
begin
  pComboBox.Clear;

  with DataBase.NewQuery do
  try
    Close;
    SQL.Text := 'SELECT distinct v.column_name, ordinal_position FROM sys_view_columns v ' +
                'LEFT JOIN sys_grid_col_width a ON a.table_name=v.table_name and a.column_name = v.column_name ' +
                'WHERE v.table_name=' + QuotedStr(pTableName) + ' and a.column_name is null ' +
                'GROUP BY v.column_name, ordinal_position ' +
                'ORDER BY ordinal_position ASC ';
    Open;
    while NOT EOF do
    begin
      pComboBox.Items.Add( Fields.Fields[0].AsString );
      Next;
    end;
    EmptyDataSet;
    Close;
  finally
    Free;
  end;
end;

end.
