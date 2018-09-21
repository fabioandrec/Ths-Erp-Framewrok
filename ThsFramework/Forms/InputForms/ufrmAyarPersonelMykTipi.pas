unit ufrmAyarPersonelMykTipi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils, Vcl.Menus,
  Vcl.AppEvnts, System.ImageList, Vcl.ImgList, Vcl.Samples.Spin,
  thsEdit, thsComboBox, thsMemo,

  ufrmBase, ufrmBaseInputDB;

type
  TfrmAyarPersonelMykTipi = class(TfrmBaseInputDB)
    lblDeger: TLabel;
    edtDeger: TthsEdit;
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
  Ths.Erp.Database.Table.AyarPersonelMykTipi;

{$R *.dfm}

procedure TfrmAyarPersonelMykTipi.FormCreate(Sender: TObject);
begin
  TAyarPersonelMykTipi(Table).Deger.SetControlProperty(Table.TableName, edtDeger);

  inherited;
end;

procedure TfrmAyarPersonelMykTipi.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  edtDeger.Text := FormatedVariantVal(TAyarPersonelMykTipi(Table).Deger.FieldType, TAyarPersonelMykTipi(Table).Deger.Value);
end;

procedure TfrmAyarPersonelMykTipi.btnAcceptClick(Sender: TObject);
begin
  if (FormMode = ifmNewRecord) or (FormMode = ifmCopyNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TAyarPersonelMykTipi(Table).Deger.Value := edtDeger.Text;
      inherited;
    end;
  end
  else
    inherited;
end;

end.
