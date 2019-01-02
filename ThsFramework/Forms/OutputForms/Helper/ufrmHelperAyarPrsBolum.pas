unit ufrmHelperAyarPrsBolum;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Data.DB,
  Vcl.DBGrids, Vcl.Menus, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.Grids,

  ufrmBase,
  ufrmBaseHelper,
  
  Ths.Erp.Database.Singleton,
  Ths.Erp.Database.Table,
  Ths.Erp.Database.Table.AyarPrsBolum;

type
  TfrmHelperAyarPrsBolum = class(TfrmBaseHelper)
  private
  published
    function getFilterEditData: string; override;
    constructor Create(AOwner: TComponent; pParentForm: TForm=nil;
      pTable: TTable=nil; pIsPermissionControl: Boolean=False;
      pFormMode: TInputFormMod=ifmNone;
      pFormOndalikMode: TFormOndalikMod=fomNormal); override;
  public
  end;

implementation

{$R *.dfm}

constructor TfrmHelperAyarPrsBolum.Create(AOwner: TComponent; pParentForm: TForm;
  pTable: TTable; pIsPermissionControl: Boolean; pFormMode: TInputFormMod;
  pFormOndalikMode: TFormOndalikMod);
begin
  pTable := TAyarPrsBolum.Create(TSingletonDB.GetInstance.DataBase);
  inherited Create(AOwner, pParentForm, pTable, pIsPermissionControl, pFormMode, pFormOndalikMode);
end;

function TfrmHelperAyarPrsBolum.getFilterEditData: string;
begin
  Result := FormatedVariantVal(dbgrdBase.DataSource.DataSet.FindField(TAyarPrsBolum(Table).Bolum.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TAyarPrsBolum(Table).Bolum.FieldName).Value);
end;

end.
