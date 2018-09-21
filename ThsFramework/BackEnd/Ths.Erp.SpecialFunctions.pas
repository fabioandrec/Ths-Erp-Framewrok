unit Ths.Erp.SpecialFunctions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Types,
  Dialogs, StdCtrls, Strutils, ExtCtrls, DB, nb30, Grids,
  System.Hash,
  TypInfo, RTTI;

const
  CKEY1 = 53761;
  CKEY2 = 32618;

type
  ArrayInteger = array of Integer;

type
  TLang = record
    StatusAccept: string;
    StatusAdd: string;
    StatusCancel: string;
    StatusDelete: string;

    ButtonAccept: string;
    ButtonAdd: string;
    ButtonCancel: string;
    ButtonClose: string;
    ButtonDelete: string;
    ButtonFilter: string;
    ButtonOK: string;
    ButtonUpdate: string;

    ErrorAccessRight: string;
    ErrorDatabaseConnection: string;
    ErrorLogin: string;
    ErrorDBOther: string;
    ErrorDBNoDataFound: string;
    ErrorDBTooManyRows: string;
    ErrorDBRecordLocked: string;
    ErrorDBUnique: string;
    ErrorDBForeignKeyDeleteUpdate: string;
    ErrorDBForeignKeyUnique: string;
    ErrorDBObjectNotExist: string;
    ErrorDBUserPasswordInvalid: string;
    ErrorDBUserPasswordExpired: string;
    ErrorDBUserPasswordWillExpire: string;
    ErrorDBCmdAborted: string;
    ErrorDBServerGone: string;
    ErrorDBServerOutput: string;
    ErrorDBArrExecMalFunc: string;
    ErrorDBInvalidParams: string;
    ErrorRecordDeleted: string;
    ErrorRecordDeletedMessage: string;
    ErrorRedInputsRequired: string;
    ErrorRequiredData: string;

    GeneralConfirmationLower: string;
    GeneralConfirmationUpper: string;
    GeneralNoUpper: string;
    GeneralNoLower: string;
    GeneralYesUpper: string;
    GeneralYesLower: string;
    GeneralRecordCount: string;
    GeneralPeriod: string;

    FilterFilterCriteriaTitle: string;
    FilterLike: string;
    FilterNotLike: string;
    FilterSelectFilterFields: string;
    FilterWithEnd: string;
    FilterWithStart: string;

    MessageApplicationTerminate: string;
    MessageCloseWindow: string;
    MessageDeleteRecord: string;
    MessageUnsupportedProcess: string;
    MessageUpdateRecord: string;
    MessageUpdateColumnWidth: string;

    MessageTitleOther: string;
    MessageTitleNoDataFound: string;
    MessageTitleDataAlreadyExists: string;
    MessageTitleInsertUpdate: string;
    MessageTitleUpdateDelete: string;
    MessageTitleObjectNotFound: string;
    MessageTitleError: string;

    PopupAddLangGuiContent: string;
    PopupAddLangDataContent: string;
    PopupAddUseMultiLangData: string;

    PopupCopyRecord: string;
    PopupExcludeFilter: string;
    PopupExportExcel: string;
    PopupExportExcelAll: string;
    PopupFilter: string;
    PopupPreview: string;
    PopupPrint: string;
    PopupRemoveFilter: string;
    PopupRemoveSort: string;

    WarningActiveTransaction: string;
    WarningLockedRecord: string;
    WarningOpenWindow: string;
  end;

type
  TRoundToRange = -37..37;

type
  TObjectClone = record
    class function From<T: class>(Source: T): T; static;
  end;

type
  TSpecialFunctions = class
    class function IsNumeric(const S: string):Boolean;

    class procedure TutarHesapla(const fiyat:double; const miktar:double; const iskontoOrani:double; const kdvOrani:double; Out tutar:double; out netFiyat:double; out iskontoTutar:double; out kdvTutar:double; out toplamTutar:double; ondalikli_hane:integer);

    class function SayiyiYaziyaCevir(Num : Double) : String;
    class function SayiyiYaziyaCevir2(tutar:double; tur:integer; tam_birim:string='TL'; ondalikli_birim:string='KR�'):string;
    class function VirguldenSonraHaneSayisi(deger:double; hanesayisi:integer):string;
    class function GetMACAddress: TStringList;
    class function GetAdapterInfo(Lana: AnsiChar): String;
    class function CountNumOfCharacter(s: string; delimeter:string):integer;
    class function FloatKeyControl2(Sender:TObject; Key:Char):Char;
    class function GetSimdikiTarih(date_now:TDate):TStringList;

    class function LastPos(const SubStr: String; const strData: String): Integer;

    class function isAltDown():Boolean;
    class function isCtrlDown():Boolean;
    class function isShiftDown():Boolean;

    class function GetMikroRaporTarihFormat(tarih : TDateTime):string;

    class function CLEN(S:string; N:integer):string;
    class function FILLSTR(C : Char; N :Integer):string;
    class function RSET(S :string; N: integer):string;
    class function LSET(ST:STRING):STRING;

    class function FileToByteArray(const FileName: WideString): TArray<Byte>;
    class procedure ByteArrayToFile(const ByteArray: TBytes; const FileName: string);
    {$IFDEF MSWINDOWS}
    class function GetFileSize(pFileName: string): Int64;
    {$ENDIF MSWINDOWS}

    class function UpperCaseTr(S:String):String;
    class function LowerCaseTr(S:String):String;
    class function myBoolToStr(pBool: Boolean): string;

    class function CheckIntegerInArray(pArr: ArrayInteger; pKey: Integer): Boolean;
    class function CheckStringInArray(pArr: TArray<string>; pKey: string): Boolean;


    class function GetStrHashSHA512(Str: String): String;
    class function GetFileHashSHA512(FileName: WideString): String;
    class function GetStrFromHashSHA512(pString: WideString): String;

    class function EncryptStr(const S :WideString; Key: Word): String;
    class function DecryptStr(const S: String; Key: Word): String;

    class function FirstCaseUpper(const vStr : string) : string;

    class function GetDialogColor(pColor: TColor): TColor;
    class function GetDiaglogOpen(pFilter: string; pInitialDir: string=''): string;
    class function GetDiaglogSave(pFileName, pFilter: string; pInitialDir: string=''): string;
  private
    { Private declarations }
  public
    //
  end;

/// <summary>
///   Framework i�inde kullan�lan sabit dil i�eriklieri i�in bilgilerin oldu�u record.
/// </summary>
/// <remarks>
///   Burada framework i�inde kullan�lan ve tekrar eden dil database tablosundan
///   �ekilecek olan datalar i�in sabit bilgiler yaz�ld�.
/// </remarks>
/// <example>
///   Yeni Kay�t Ekle Buton ba�l��� i�in ButtonAdd
/// </example>
/// <seealso href="http://www.aaa.xxx/test">
///   Link verilmedi. Buradan U�ur Parlayan hocama selamlar
/// </seealso>
  function FrameworkLang: TLang;
/// <summary>
///   Birden fazla sLineBreak eklemek i�in kullan�l�r.
/// </summary>
/// <remarks>
///   Birden fazla sLineBreak kullan�lmak istenildi�inde bu fonksiyon yard�mc� oluyor.
///  3 tane slinebreak yazmak yerine bu fonksiyonu kullanabilirsin.
///  slinebreak + slinebreak + slinebreak
/// </remarks>
/// <example>
///   AddLBs(3)
/// </example>
  function AddLBs(pCount: Integer = 1): string;
/// <summary>
///   Butonlar�n ba�l�klar�n� �zelle�tirebildi�imiz Mesaj ekran�
/// </summary>
/// <remarks>
///   Buton ba�l�klar�n� �zelle�tirilebildi�imiz �zel MesajDiaglog formu.
///  Mesaj, Ba�l�k, Buton Yaz�lar� gibi her�eyi istedi�imiz �ekilde yazabildi�imiz
///  �zel Mesaj formu
/// </remarks>
/// <example>
///   CustomMsgDlg('Are you sure you want to update record?', mtConfirmation, mbYesNo, ['Yes', 'No'], mbNo, 'Confirmation') = mrYes
/// </example>
  function CustomMsgDlg(const pMsg: string; pDlgType: TMsgDlgType;
    pButtons: TMsgDlgButtons; pCaptions: array of string;
    pDefaultButton:TMsgDlgBtn;
    pCustomTitle: string = ''): Integer;
  function ReplaceMessages(Source: string; Old, New: array of string; IsIgnoreCase: Boolean= False): String;
  function EnDeCrypt(const Value: string): string;
  function CheckString(const pStr: string): Boolean;

implementation

uses
  Math;

function FrameworkLang: TLang;
begin
  if Result.StatusAccept = '' then
  begin
    Result.StatusAccept := 'Accept';
    Result.StatusAdd := 'Add';
    Result.StatusCancel := 'Cancel';
    Result.StatusDelete := 'Delete';

    Result.ButtonAccept := 'Accept';
    Result.ButtonAdd := 'Add';
    Result.ButtonCancel := 'Cancel';
    Result.ButtonClose := 'Close';
    Result.ButtonDelete := 'Delete';
    Result.ButtonFilter := 'Filter';
    Result.ButtonOK := 'Ok';
    Result.ButtonUpdate := 'Update';

    Result.ErrorAccessRight := 'Access Right';
    Result.ErrorDatabaseConnection := 'Database Connection';
    Result.ErrorLogin := 'Login';
    Result.ErrorDBOther := 'Other';
    Result.ErrorDBNoDataFound := 'No Data Found';
    Result.ErrorDBTooManyRows := 'Too Many Rows';
    Result.ErrorDBRecordLocked := 'Record Locked';
    Result.ErrorDBUnique := 'Unique';
    Result.ErrorDBForeignKeyDeleteUpdate := 'Foreign Key Delete Update';
    Result.ErrorDBForeignKeyUnique := 'Foreign Key Unique';
    Result.ErrorDBObjectNotExist := 'Object Not Exist';
    Result.ErrorDBUserPasswordInvalid := 'User Password Invalid';
    Result.ErrorDBUserPasswordExpired := 'User Password Expired';
    Result.ErrorDBUserPasswordWillExpire := 'User Password Will Expire';
    Result.ErrorDBCmdAborted := 'CMD Aborted';
    Result.ErrorDBServerGone := 'Server Gone';
    Result.ErrorDBServerOutput := 'Server Output';
    Result.ErrorDBArrExecMalFunc := 'Arr Exec Mal Func';
    Result.ErrorDBInvalidParams := 'Invalid Params';
    Result.ErrorRecordDeleted := 'Record Deleted';
    Result.ErrorRecordDeletedMessage := 'Record Deleted Message';
    Result.ErrorRedInputsRequired := 'Red Inputs Required';
    Result.ErrorRequiredData := 'Required Data';

    Result.GeneralConfirmationLower := 'Confirmation Lower';
    Result.GeneralConfirmationUpper := 'Confirmation Upper';
    Result.GeneralNoLower := 'No Lower';
    Result.GeneralNoUpper := 'No Upper';
    Result.GeneralRecordCount := 'Record Count';
    Result.GeneralYesLower := 'Yes Lower';
    Result.GeneralYesUpper := 'Yes Upper';
    Result.GeneralPeriod := 'Period';

    Result.MessageApplicationTerminate := 'Application Terminate';
    Result.MessageCloseWindow := 'Close Window';
    Result.MessageDeleteRecord := 'Delete Record';
    Result.MessageUnsupportedProcess := 'Unsupported Process';
    Result.MessageUpdateRecord := 'Update Record';
    Result.MessageUpdateColumnWidth := 'Update Column Width';

    Result.MessageTitleOther := 'Other';
    Result.MessageTitleNoDataFound := 'No Data Found';
    Result.MessageTitleDataAlreadyExists := 'Data Already Exists';
    Result.MessageTitleInsertUpdate := 'Insert/Update Record';
    Result.MessageTitleUpdateDelete := 'Update/Delete Record';
    Result.MessageTitleObjectNotFound := 'Object Not Found';
    Result.MessageTitleError := 'Error';

    Result.PopupAddLangGuiContent := 'Add Lang Gui Content';
    Result.PopupAddLangDataContent := 'Add Lang Data Content';
    Result.PopupAddUseMultiLangData := 'Add Use Multi Lang Data';
    Result.PopupCopyRecord := 'Copy Record';
    Result.PopupExcludeFilter := 'Exclude Filter';
    Result.PopupExportExcel := 'Export Excel';
    Result.PopupExportExcelAll := 'Export Excel All';
    Result.PopupFilter := 'Filter';
    Result.PopupPreview := 'Preview';
    Result.PopupPrint := 'Print';
    Result.PopupRemoveFilter := 'Remove Filter';
    Result.PopupRemoveSort := 'Remove Sort';

    Result.WarningActiveTransaction := 'Active Transaction';
    Result.WarningLockedRecord := 'Locked Record';
    Result.WarningOpenWindow := 'Open Window';
  end;
end;

function AddLBs(pCount: Integer): string;
var
  n1: Integer;
begin
  for n1 := 0 to pCount-1 do
    Result := Result + sLineBreak;
end;

function CustomMsgDlg(const pMsg: string;
  pDlgType: TMsgDlgType; pButtons: TMsgDlgButtons; pCaptions: array of string;
  pDefaultButton:TMsgDlgBtn;
  pCustomTitle: string = ''): Integer;
var
  vMsgDlg: TForm;
  n1, vCaptionIndex: Integer;
  vDlgButton: TButton;
begin
  vMsgDlg := CreateMessageDialog(pMsg, pDlgType, pButtons, pDefaultButton);
  vCaptionIndex := 0;

  if pCustomTitle <> '' then
    vMsgDlg.Caption := pCustomTitle;

  for n1 := 0 to vMsgDlg.ComponentCount - 1 do
  begin
   { If the object is of type TButton, then }
   { Wenn es ein Button ist, dann...}
    if (vMsgDlg.Components[n1] is TButton) then
    begin
      vDlgButton := TButton(vMsgDlg.Components[n1]);
      if vCaptionIndex > High(pCaptions) then Break;
      { Give a new caption from our Captions array}
      { Schreibe Beschriftung entsprechend Captions array}
      vDlgButton.Caption := pCaptions[vCaptionIndex];
      Inc(vCaptionIndex);
    end;
  end;
  Result := vMsgDlg.ShowModal;
end;

function ReplaceMessages(Source: string; Old, New: array of string; IsIgnoreCase: Boolean= False): String;
var
  n1: Integer;
begin
  Result := Source;
  if (Length(Old) > 0) and (Old[0] <> '') then
  begin
    for n1 := 0 to Length(Old)-1 do
    begin
      if n1 = 0 then
        Result := '';

      if Old[n1] <> '' then
        if IsIgnoreCase then
          Result := Result + StringReplace(Source, Old[n1], New[n1], [rfIgnoreCase])
        else
          Result := Result + StringReplace(Source, Old[n1], New[n1], [rfReplaceAll]);
    end;
  end;

  Result := StringReplace(Result, '#br#', AddLBs, [rfReplaceAll]);
end;

function EnDeCrypt(const Value : String) : String;
var
  CharIndex : integer;
begin
  Result := Value;
  for CharIndex := 1 to Length(Value) do
    Result[CharIndex] := chr(not(ord(Value[CharIndex])));
end;

function CheckString(const pStr: string): Boolean;
var
  n1: Integer;
begin
  for n1 := 1 to Length(pStr) do
    if not CharInSet(pStr[n1], ['a'..'z', 'A'..'Z', '_']) then
      Exit(False);
  Result := True;
end;

class function TObjectClone.From<T>(Source: T): T;
var
  Context: TRttiContext;
  IsComponent, LookOutForNameProp: Boolean;
  RttiType: TRttiType;
  Method: TRttiMethod;
  MinVisibility: TMemberVisibility;
  Params: TArray<TRttiParameter>;
  Prop: TRttiProperty;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  RttiType := Context.GetType(Source.ClassType);
  //find a suitable constructor, though treat components specially
  IsComponent := (Source is TComponent);
  for Method in RttiType.GetMethods do
    if Method.IsConstructor then
    begin
      Params := Method.GetParameters;
      if Params = nil then Break;
      if (Length(Params) = 1) and IsComponent and
         (Params[0].ParamType is TRttiInstanceType) and
         SameText(Method.Name, 'Create') then Break;
    end;
  if Params = nil then
    Result := Method.Invoke(Source.ClassType, []).AsType<T>
  else
    Result := Method.Invoke(Source.ClassType, [TComponent(Source).Owner]).AsType<T>;
  try
    //many VCL control properties require the Parent property to be set first
    if Source is TControl then TControl(Result).Parent := TControl(Source).Parent;
    //loop through the props, copying values across for ones that are read/write
    Move(Source, SourceAsPointer, SizeOf(Pointer));
    Move(Result, ResultAsPointer, SizeOf(Pointer));
    LookOutForNameProp := IsComponent and (TComponent(Source).Owner <> nil);
    if IsComponent then
      MinVisibility := mvPublished //an alternative is to build an exception list
    else
      MinVisibility := mvPublic;
    for Prop in RttiType.GetProperties do
      if (Prop.Visibility >= MinVisibility) and Prop.IsReadable and Prop.IsWritable then
        if LookOutForNameProp and (Prop.Name = 'Name') and
          (Prop.PropertyType is TRttiStringType) then
          LookOutForNameProp := False
        else
          Prop.SetValue(ResultAsPointer, Prop.GetValue(SourceAsPointer));
  except
    Result.Free;
    raise;
  end;
end;

class function TSpecialFunctions.IsNumeric(const S: string):Boolean;
begin
  Result := True;
  try
    StrToInt(S);
  except
    Result := False;
  end;
end;

class procedure TSpecialFunctions.TutarHesapla(const fiyat:double; const miktar:double; const iskontoOrani:double; const kdvOrani:double; Out tutar:double; out netFiyat:double; out iskontoTutar:double; out kdvTutar:double; out toplamTutar:double; ondalikli_hane:integer);
begin
  tutar         := miktar * fiyat;
  netFiyat      := fiyat * (100.0 - iskontoOrani) / 100.0;
  iskontoTutar  := (tutar * iskontoOrani) / 100.0;
  kdvTutar      := (netFiyat * miktar * kdvOrani) / 100.0;
  toplamTutar   := (netFiyat * miktar ) + kdvTutar;
end;

class function TSpecialFunctions.SayiyiYaziyaCevir(Num: Double): string;
const
  BIRLER: array[0..9] of string = ('', 'B�R ', '�K� ', '�� ', 'D�RT ', 'BE� ', 'ALTI ', 'YED� ', 'SEK�Z ', 'DOKUZ ');
  ONLAR: array[0..9] of string = ('', 'ON ', 'Y�RM� ', 'OTUZ ', 'KIRK ', 'ELL� ', 'ALTMI� ', 'YETM�� ', 'SEKSEN ', 'DOKSAN ');
  DIGER: array[0..5] of string = ('', 'B�N ', 'M�LYON ', 'M�LYAR ', 'TR�LYON ', 'KATR�LYON ');

  function SmallNum(Num: Int64): string;
  var
    S: string;
  begin
    Result := '';
    S := IntToStr(Num);
    if (Length(S) = 1) then
      S := '00' + S
    else
    begin
      if (Length(S) = 2) then
        S := '0' + S;
    end;
    if S[1] <> '0' then
    begin
      if S[1] <> '1' then
        Result := BIRLER[StrToInt(string(S[1]))] + 'Y�Z '
      else
        Result := 'Y�Z ';
    end;
    Result := Result + ONLAR[StrToInt(string(S[2]))];
    Result := Result + BIRLER[StrToInt(string(S[3]))];
  end;

var
  i, j, n, Nm: Int64;
  S, Sn: string;
begin
  S := FormatFloat('0', Num);
  Sn := '';
  if Num = 0 then
    Sn := 'SIFIR'
  else if Length(S) < 4 then
    Sn := SmallNum(Round(Num))
  else
  begin
    I := 1;
    J := Length(S) mod 3;
    if J = 0 then
    begin
      J := 3;
      N := Length(S) div 3 - 1;
    end
    else
      N := Length(S) div 3;

    while i < Length(S) do
    begin
      Nm := StrToInt(Copy(S, I, J));

      if (Nm = 1) and (N = 1) then
      begin
        Nm := 0;
        Sn := Sn + SmallNum(Nm) + Diger[N];
      end;

      if Nm <> 0 then
        Sn := Sn + SmallNum(Nm) + Diger[N];

      I := I + J;
      J := 3;
      N := N - 1;
    end;
  end;
  Result := Sn;
end;

class function TSpecialFunctions.SayiyiYaziyaCevir2(tutar: double; tur: integer; tam_birim: string = 'TL'; ondalikli_birim: string = 'KR�'): string;
const
  b1: array[1..9] of string = ('B�R', '�K�', '��', 'D�RT', 'BE�', 'ALTI', 'YED�', 'SEK�Z', 'DOKUZ');
  b2: array[1..9] of string = ('ON', 'Y�RM�', 'OTUZ', 'KIRK', 'ELL�', 'ALTMI�', 'YETM��', 'SEKSEN', 'DOKSAN');
  b3: array[1..6] of string = ('KATR�LYON', 'TR�LYON', 'M�LYAR', 'M�LYON', 'B�N', '');
var
  gr: array[1..6] of string;
  sn: array[1..6] of string;
  bs: array[1..3] of integer;
  tutars, tutart, tutark, sonuct, sonuck: string;
  i, l: integer;
begin
  tutars := floattostr(tutar);
  if pos(',', tutars) = 0 then
    tutars := tutars + ',00';

  tutart := copy(tutars, 1, (pos(',', tutars) - 1));
  tutark := copy(tutars, (pos(',', tutars) + 1), 2);
  tutart := stringofchar('0', (18 - (length(trim(tutart))))) + tutart;
  tutark := tutark + stringofchar('0', (2 - (length(trim(tutark)))));

  for i := 1 to 6 do
    gr[i] := copy(tutart, 1 + (3 * (i - 1)), 3);

  for l := 1 to 6 do
  begin
    bs[1] := StrToInt(Copy(gr[l], 1, 1));
    if bs[1] <> 0 then
    begin
      if bs[1] <> 1 then
        sn[l] := sn[l] + b1[bs[1]] + 'Y�Z'
      else
        sn[l] := sn[l] + 'Y�Z';
    end;

    bs[2] := strtoint(copy(gr[l], 2, 1));

    if bs[2] <> 0 then
      sn[l] := sn[l] + b2[bs[2]];

    bs[3] := strtoint(copy(gr[l], 3, 1));

    if bs[3] <> 0 then
      sn[l] := sn[l] + b1[bs[3]];

    if Length(Trim(sn[l])) <> 0 then
      sn[l] := sn[l] + b3[l];
  end;

  if sn[5] = 'B�RB�N' then
    sn[5] := 'B�N';

  for i := 1 to 6 do
    sonuct := sonuct + sn[i];

  if strtoint(copy(tutark, 1, 1)) <> 0 then
    sonuck := sonuck + b2[strtoint(copy(tutark, 1, 1))];

  if strtoint(copy(tutark, 2, 1)) <> 0 then
    sonuck := sonuck + b1[strtoint(copy(tutark, 2, 1))];

  if tur = 0 then
    result := sonuct + ' ' + tam_birim + ' / ' + sonuck + ' ' + ondalikli_birim;

  if tur = 1 then
    result := sonuct + ' ' + tam_birim;

  if tur = 2 then
    result := sonuck + ' ' + ondalikli_birim;
end;

class function TSpecialFunctions.VirguldenSonraHaneSayisi(deger: double; hanesayisi: integer): string;
var
  strDeger: string;
begin
  if deger <> 0 then
  begin
    strDeger := FloatToStr(deger);
    if Pos(',', strDeger) > 0 then
      Result := LeftStr(strDeger, Pos(',', strDeger) + hanesayisi)
    else
      Result := strDeger;
  end
  else if deger = 0 then
  begin
    Result := '0';
  end;
end;

class function TSpecialFunctions.GetAdapterInfo(Lana: AnsiChar):String;
var
  Adapter: TAdapterStatus;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBRESET);
  NCB.ncb_lana_num := Lana;
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := 'Mac Adres bulunamad�';
    Exit;
  end;
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBASTAT);
  NCB.ncb_lana_num := Lana;
  NCB.ncb_callname := '*';
  FillChar(Adapter, SizeOf(Adapter), 0);
  NCB.ncb_buffer := @Adapter;
  NCB.ncb_length := SizeOf(Adapter);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin
    Result := 'Mac Adres bulunamad�';
    Exit;
  end;
  Result :=
    IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
    IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
    IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
    IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
    IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
    IntToHex(Byte(Adapter.adapter_address[5]), 2);
end;

class function TSpecialFunctions.GetDialogColor(pColor: TColor): TColor;
var
  vColorDialog: TColorDialog;
begin
  vColorDialog := TColorDialog.Create(nil);
  try
    vColorDialog.Color := pColor;
    vColorDialog.Execute(Application.Handle);
    Result := vColorDialog.Color;
  finally
    vColorDialog.Free;
  end;
end;

class function TSpecialFunctions.GetDiaglogOpen(pFilter: string;
    pInitialDir: string=''): string;
var
  vOpenDialog: TOpenDialog;
begin
  vOpenDialog := TOpenDialog.Create(nil);
  try
    vOpenDialog.InitialDir := '%USERPROFILE%\desktop';
    vOpenDialog.Filter := pFilter;
    vOpenDialog.Execute(Application.Handle);
    Result := vOpenDialog.FileName;
  finally
    vOpenDialog.Free;
  end;
end;

class function TSpecialFunctions.GetDiaglogSave(pFileName, pFilter: string;
    pInitialDir: string=''): string;
var
  vSaveDialog: TOpenDialog;
begin
  vSaveDialog := TSaveDialog.Create(nil);
  try
    vSaveDialog.Filter     := pFilter;
    vSaveDialog.FileName   := pFileName;
    if pInitialDir = '' then
      vSaveDialog.InitialDir := '%USERPROFILE%\desktop'
    else
      vSaveDialog.InitialDir := pInitialDir;

    vSaveDialog.Execute(Application.Handle);
    Result := vSaveDialog.FileName;
  finally
    vSaveDialog.Free;
  end;
end;

class function TSpecialFunctions.GetMACAddress: TStringList;
var
  AdapterList: TLanaEnum;
  NCB: TNCB;
  nIndex:integer;
begin
  Result := TStringList.Create;
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBENUM);
  NCB.ncb_buffer := @AdapterList;
  NCB.ncb_length := SizeOf(AdapterList);
  Netbios(@NCB);
  if Byte(AdapterList.length) > 0 then
  begin
    for nIndex := 0 to Byte(AdapterList.length) - 1 do
    begin
      Result.Add(GetAdapterInfo(AdapterList.lana[nIndex]));
    end;
  end
//  else
//    Result := 'Mac Adres bulunamad�';
end;

class function TSpecialFunctions.CountNumOfCharacter(s: string; delimeter:string):integer;
var
  i,nFind : integer;
  letter : string;
begin
  //count := 0;
  nFind := 0;
  for i := 1 to length(s) do
  begin
    letter := s[i];
    if letter = delimeter then
      nFind := nFind + 1;
  end;
  result := nFind;
end;

class function TSpecialFunctions.GetSimdikiTarih(date_now: TDate): TStringList;
var
  wGun, wAy, wYil: word;
begin
  Result := TStringList.Create;

  DecodeDate(date_now, wYil, wAy, wGun);

  Result.Add(IntToStr(wGun));
  Result.Add(IntToStr(wAy));
  Result.Add(IntToStr(wYil));
end;

//todo ferhat
class function TSpecialFunctions.CheckIntegerInArray(pArr: ArrayInteger;
  pKey: Integer): Boolean;
var
  n1: Integer;
begin
  Result := False;
  for n1 := 0 to Length(pArr)-1 do
  begin
    if pKey = pArr[n1] then
      Result := True;
      Exit;
  end;
end;

class function TSpecialFunctions.CheckStringInArray(pArr: TArray<string>;
  pKey: string): Boolean;
var
  n1: Integer;
begin
  Result := False;
  for n1 := 0 to Length(pArr)-1 do
  begin
    if pKey = pArr[n1] then
      Result := True;
      Exit;
  end;
end;

class function TSpecialFunctions.CLEN(S: string; N: INTEGER): string;
var
  X: integer;
begin
  X := LENGTH(S);
  if X < N then
    CLEN := S + FILLSTR(' ', N - X)
  else
    CLEN := COPY(S, 1, N);
end;

class function TSpecialFunctions.RSET(S: string; N: integer): string;
var
  X: INTEGER;
begin
  X := LENGTH(S);
  if X < N then
    RSET := FILLSTR(' ', N - X) + S
  else
    RSET := COPY(S, 1, N);
end;

class function TSpecialFunctions.FILLSTR(C : Char; N :Integer):string;
var
  s:string;
begin
  if N < 0 then
    N := 0;
  Setlength(s, n);
  FillChar(S[1],N,C);
  FillStr:= s;
end;

class function TSpecialFunctions.FirstCaseUpper(const vStr: string): string;
var
  n1: Integer;
begin
  if vStr = '' then
    Result := ''
  else
  begin
    Result := Uppercase(vStr[1]);
    for n1 := 2 to Length(vStr) do
    begin
      if vStr[n1-1] = ' ' then
        Result := Result + Uppercase(vStr[n1])
      else
        Result := Result + Lowercase(vStr[n1]);
    end;
  end;
end;

class function TSpecialFunctions.LSet(st:string):string;
var
//  ch:char;
  bCon:boolean;
  i:integer;
begin
  I:=0;
  bCon:=FALSE;
  repeat
    I:=I+1;
    if (I>Length(st)) or (Copy(st,I,1)<>' ') then
      bCon:=TRUE;
  until bCon;
  Delete(st,1,I-1);
  LSet:=st;
end;

class function TSpecialFunctions.FloatKeyControl2(Sender:TObject; Key:Char):Char;
begin
  if not CharInSet(Key, [#8, '0'..'9', FormatSettings.DecimalSeparator]) then
  begin
    Key := #0; //sadece say� ve virg�lle backspace kabul et
  end
  else
  if (Key = FormatSettings.DecimalSeparator)
  and (Pos(Key, TStringGrid(Sender).Cells[TStringGrid(Sender).Col, TStringGrid(Sender).Row]) > 0) then
  begin
    Key := #0; //ikinci virg�l� alma
  end
  else
  if (Key = FormatSettings.DecimalSeparator)
  and (Length(TStringGrid(Sender).Cells[TStringGrid(Sender).Col, TStringGrid(Sender).Row]) = 0) then
  begin
    Key := #0; //, ile ba�latma
  end;
  Result := Key;
end;

class function TSpecialFunctions.LastPos(const SubStr: String; const strData: String): Integer;
begin
  Result := Pos(ReverseString(SubStr), ReverseString(strData)) ;

  if (Result <> 0) then
    Result := ((Length(strData) - Length(SubStr)) + 1) - Result + 1;
end;

class function TSpecialFunctions.isAltDown : Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_MENU] and 128)<>0);
end;

class function TSpecialFunctions.isCtrlDown : Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128)<>0);
end;

class function TSpecialFunctions.isShiftDown : Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_SHIFT] and 128)<>0);
end;

class function TSpecialFunctions.GetMikroRaporTarihFormat(tarih : TDateTime):string;
begin
  if tarih <> 0 then
    Result := StringReplace(DateToStr(tarih), '.', '', [rfReplaceAll])
  else
    Result := '';
end;

class function TSpecialFunctions.FileToByteArray(const FileName: WideString): TArray<Byte>;
const BLOCK_SIZE = 1024;
var   BytesRead, BytesToWrite, Count : integer;
      F : File of Byte;
      pTemp : Pointer;
begin
  AssignFile(F, FileName);
  Reset(F);
  try
    Count := FileSize(F);
    SetLength(Result, Count);
    pTemp := @Result[0];
    BytesRead := BLOCK_SIZE;
    while (BytesRead = BLOCK_SIZE) do
    begin
      BytesToWrite := Min(Count, BLOCK_SIZE);
      BlockRead(F, pTemp^, BytesToWrite, BytesRead);
      pTemp := Pointer(LongInt(pTemp) + BLOCK_SIZE);
      Count := Count-BytesRead;
    end;
  finally
    CloseFile(F);
  end;
end;

{$IFDEF MSWINDOWS}
class function TSpecialFunctions.GetFileSize(pFileName: string): Int64;
var
  vSearchRec: TSearchRec;
begin
{$WARN SYMBOL_PLATFORM OFF}
  //SearchRec.Size property works, but only for files less than 2GB
  if FindFirst(pFileName, faAnyFile, vSearchRec) = 0 then
    Result := Int64(vSearchRec.FindData.nFileSizeHigh) shl Int64(32) + Int64(vSearchRec.FindData.nFileSizeLow)
  else
    Result := 0;
  FindClose(vSearchRec);
{$WARN SYMBOL_PLATFORM ON}
end;
{$ENDIF MSWINDOWS}

class procedure TSpecialFunctions.ByteArrayToFile(const ByteArray: TBytes; const FileName: string);
var Count : Integer;
    F : File of Byte;
    pTemp : Pointer;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  try
    Count := Length(ByteArray);
    pTemp := @ByteArray[0];
    BlockWrite(F, pTemp^, Count);
  finally
    CloseFile(F);
  end;
end;

class function TSpecialFunctions.UpperCaseTr(S:String):String;
begin
  Result := AnsiUpperCase(StringReplace(StringReplace(S,'�','I',[rfReplaceAll]),'i','�',[rfReplaceAll]));
end;

class function TSpecialFunctions.LowerCaseTr(S:String):String;
begin
  Result := AnsiLowerCase(StringReplace(StringReplace(S,'I','�',[rfReplaceAll]),'�','i',[rfReplaceAll]));
end;

class function TSpecialFunctions.myBoolToStr(pBool: Boolean): string;
begin
  Result := IfThen(pBool, 'TRUE', 'FALSE');
end;

class function TSpecialFunctions.GetStrHashSHA512(Str: String): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create;
  HashSHA.GetHashString(Str);
  Result := HashSHA.GetHashString(Str,SHA512);
end;

class function TSpecialFunctions.GetFileHashSHA512(FileName: WideString): String;
var
  HashSHA: THashSHA2;
  Stream: TStream;
  Readed: Integer;
  Buffer: PByte;
  BufLen: Integer;
begin
  HashSHA := THashSHA2.Create(SHA512);
  BufLen := 16 * 1024;
  Buffer := AllocMem(BufLen);
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      while Stream.Position < Stream.Size do
      begin
        Readed := Stream.Read(Buffer^, BufLen);
        if Readed > 0 then
        begin
          HashSHA.update(Buffer^, Readed);
        end;
      end;
    finally
      Stream.Free;
    end;
  finally
    FreeMem(Buffer)
  end;
  Result := HashSHA.HashAsString;
end;

class function TSpecialFunctions.GetStrFromHashSHA512(pString: WideString): String;
var
  HashSHA: THashSHA2;
begin
  HashSHA := THashSHA2.Create(SHA512);
  HashSHA.Update(pString);
  Result := HashSHA.GetHashString(pString);
end;

class function TSpecialFunctions.EncryptStr(const S :WideString; Key: Word): String;
var
  n1: Integer;
  vRStr: RawByteString;
  vRStrB: TBytes Absolute vRStr;
begin
  Result := '';
  vRStr := UTF8Encode(S);
  for n1 := 0 to Length(vRStr)-1 do
  begin
    vRStrB[n1] := vRStrB[n1] xor (Key shr 8);
    Key := (vRStrB[n1] + Key) * CKEY1 + CKEY2;
  end;

  for n1 := 0 to Length(vRStr)-1 do
  begin
    Result:= Result + IntToHex(vRStrB[n1], 2);
  end;
end;

class function TSpecialFunctions.DecryptStr(const S: String; Key: Word): String;
var
  n1,
  vTmpKey: Integer;
  vRStr: RawByteString;
  vRStrB: TBytes Absolute vRStr;
  vTmpStr: string;
begin
  vTmpStr := UpperCase(S);
  SetLength(vRStr, Length(vTmpStr) div 2);
  n1 := 1;
  try
    while (n1 < Length(vTmpStr)) do
    begin
      vRStrB[n1 div 2]:= StrToInt('$' + vTmpStr[n1] + vTmpStr[n1+1]);
      Inc(n1, 2);
    end;
  except
    Result := '';
    Exit;
  end;

  for n1 := 0 to Length(vRStr)-1 do
  begin
    vTmpKey := vRStrB[n1];
    vRStrB[n1] := vRStrB[n1] xor (Key shr 8);
    Key := (vTmpKey + Key) * CKEY1 + CKEY2;
  end;

  Result := UTF8ToString(vRStr);
end;

end.
