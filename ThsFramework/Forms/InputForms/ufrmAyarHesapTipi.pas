unit ufrmAyarHesapTipi;

interface

{$I ThsERP.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils, Vcl.Menus,
  Vcl.AppEvnts,
  Ths.Erp.Helper.Edit, Ths.Erp.Helper.ComboBox, Ths.Erp.Helper.Memo,

  ufrmBase, ufrmBaseInputDB, Vcl.Samples.Spin;

type
  TfrmAyarHesapTipi = class(TfrmBaseInputDB)
    edtDeger: TEdit;
    lblDeger: TLabel;
    procedure FormCreate(Sender: TObject);override;
    procedure RefreshData();override;
    procedure btnAcceptClick(Sender: TObject);override;
  private
  public
  protected
  published
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  Ths.Erp.Database.Table.AyarHesapTipi;

{$R *.dfm}

procedure TfrmAyarHesapTipi.FormCreate(Sender: TObject);
begin
  TAyarHesapTipi(Table).HesapTipi.SetControlProperty(Table.TableName, edtDeger);

  inherited;
end;

procedure TfrmAyarHesapTipi.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  edtDeger.Text := FormatedVariantVal(TAyarHesapTipi(Table).HesapTipi.FieldType, TAyarHesapTipi(Table).HesapTipi.Value);
end;

procedure TfrmAyarHesapTipi.btnAcceptClick(Sender: TObject);
begin
  if (FormMode = ifmNewRecord) or (FormMode = ifmCopyNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TAyarHesapTipi(Table).HesapTipi.Value := edtDeger.Text;
      inherited;
    end;
  end
  else
    inherited;
end;

end.
