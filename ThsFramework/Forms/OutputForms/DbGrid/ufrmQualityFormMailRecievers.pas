unit ufrmQualityFormMailRecievers;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Data.DB,
  Vcl.DBGrids, Vcl.Menus, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.ExtCtrls,
  ufrmBase, ufrmBaseDBGrid, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.Grids;

type
  TfrmQualityFormMailRecievers = class(TfrmBaseDBGrid)
  private
    { Private declarations }
  protected
    function CreateInputForm(pFormMode: TInputFormMod):TForm; override;
  public
    procedure SetSelectedItem();override;
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  ufrmQualityFormMailReciever,
  Ths.Erp.Database.Table.QualityFormMailReciever;

{$R *.dfm}

{ TfrmQualityFormMailRecievers }

function TfrmQualityFormMailRecievers.CreateInputForm(pFormMode: TInputFormMod): TForm;
begin
  Result:=nil;
  if (pFormMode = ifmRewiev) then
    Result := TfrmQualityFormMailReciever.Create(Application, Self, Table.Clone(), True, pFormMode)
  else
  if (pFormMode = ifmNewRecord) then
    Result := TfrmQualityFormMailReciever.Create(Application, Self, TQualityFormMailReciever.Create(Table.Database), True, pFormMode)
  else
  if (pFormMode = ifmCopyNewRecord) then
    Result := TfrmQualityFormMailReciever.Create(Application, Self, Table.Clone(), True, pFormMode);
end;

procedure TfrmQualityFormMailRecievers.SetSelectedItem;
begin
  inherited;

  TQualityFormMailReciever(Table).MailAdresi.Value := FormatedVariantVal(dbgrdBase.DataSource.DataSet.FindField(TQualityFormMailReciever(Table).MailAdresi.FieldName).DataType, dbgrdBase.DataSource.DataSet.FindField(TQualityFormMailReciever(Table).MailAdresi.FieldName).Value);
end;

end.
