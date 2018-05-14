unit ufrmCountry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils,

  fyEdit,
  ufrmBase, ufrmBaseInputDB, Vcl.AppEvnts, Vcl.Buttons,
  Vcl.Samples.Spin;

type
  TfrmCountry = class(TfrmBaseInputDB)
    lblCountryCode: TLabel;
    lblCountryName: TLabel;
    lblISOYear: TLabel;
    edtCountryCode: TfyEdit;
    edtCountryName: TfyEdit;
    edtISOYear: TfyEdit;
    lblISOCCTLDCode: TLabel;
    edtISOCCTLDCode: TfyEdit;
    destructor Destroy; override;
    procedure FormCreate(Sender: TObject);override;
    procedure Repaint(); override;
    procedure RefreshData();override;
    procedure btnAcceptClick(Sender: TObject);override;
  private
  public

  protected
  published
    procedure FormShow(Sender: TObject); override;
  end;

implementation

uses
  uConstGenel,
  Ths.Erp.Database.Table.Country;

{$R *.dfm}

Destructor TfrmCountry.Destroy;
begin
  //
  inherited;
end;

procedure TfrmCountry.FormCreate(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfrmCountry.FormShow(Sender: TObject);
begin
  inherited;

  edtCountryCode.MaxLength := Table.Database.GetMaxChar(Table.TableName, 'country_code', 2);
  edtCountryName.MaxLength := Table.Database.GetMaxChar(Table.TableName, 'country_name', 64);
  edtISOYear.MaxLength := Table.Database.GetMaxChar(Table.TableName, 'iso_year', 4);
  edtISOCCTLDCode.MaxLength := Table.Database.GetMaxChar(Table.TableName, 'iso_cctld_code', 3);
end;

procedure TfrmCountry.Repaint();
begin
  inherited;
  //
end;

procedure TfrmCountry.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  edtCountryCode.Text := TCountry(Table).CountryCode;
  edtCountryName.Text := TCountry(Table).CountryName;
  edtISOYear.Text := TCountry(Table).ISOYear.ToString;
  edtISOCCTLDCode.Text := TCountry(Table).ISOCCTLDCode;
end;

procedure TfrmCountry.btnAcceptClick(Sender: TObject);
begin
  if  (FormMode = ifmNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TCountry(Table).CountryCode     := edtCountryCode.Text;
      TCountry(Table).CountryName     := edtCountryName.Text;
      TCountry(Table).ISOYear         := StrToIntDef(edtISOYear.Text, 0);
      TCountry(Table).ISOCCTLDCode    := edtISOCCTLDCode.Text;
      inherited;
    end;
  end
  else
    inherited;
end;

end.
