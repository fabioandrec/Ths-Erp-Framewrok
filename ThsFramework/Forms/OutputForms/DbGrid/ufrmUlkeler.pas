unit ufrmUlkeler;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Data.DB,
  Vcl.DBGrids, Vcl.Menus, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.ExtCtrls,
  ufrmBase, ufrmBaseDBGrid, System.ImageList, Vcl.ImgList, Vcl.Samples.Spin,
  Vcl.StdCtrls, Vcl.Grids;

type
  TfrmUlkeler = class(TfrmBaseDBGrid)
  private
    { Private declarations }
  protected
    function CreateInputForm(pFormMode: TInputFormMod):TForm; override;
  public
    procedure SetSelectedItem();override;
  published
    procedure FormCreate(Sender: TObject); override;
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  ufrmUlke,
  Ths.Erp.Database.Table.Ulke;

{$R *.dfm}

{ TfrmCountries }

function TfrmUlkeler.CreateInputForm(pFormMode: TInputFormMod): TForm;
begin
  Result:=nil;
  if (pFormMode = ifmRewiev) then
    Result := TfrmUlke.Create(Application, Self, Table.Clone(), True, pFormMode)
  else
  if (pFormMode = ifmNewRecord) then
    Result := TfrmUlke.Create(Application, Self, TUlke.Create(Table.Database), True, pFormMode);
end;

procedure TfrmUlkeler.FormCreate(Sender: TObject);
begin
  inherited;
  TIntegerField(dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).ISOYear.FieldName)).DisplayFormat := '';
end;

procedure TfrmUlkeler.SetSelectedItem;
begin
  inherited;

  TUlke(Table).UlkeKodu.Value := GetVarToFormatedValue(dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).UlkeKodu.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).UlkeKodu.FieldName).Value);
  TUlke(Table).UlkeAdi.Value := GetVarToFormatedValue(dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).UlkeAdi.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).UlkeAdi.FieldName).Value);
  TUlke(Table).ISOYear.Value := GetVarToFormatedValue(dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).ISOYear.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).ISOYear.FieldName).Value);
  TUlke(Table).ISOCCTLDCode.Value := GetVarToFormatedValue(dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).ISOCCTLDCode.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TUlke(Table).ISOCCTLDCode.FieldName).Value);
end;

end.
