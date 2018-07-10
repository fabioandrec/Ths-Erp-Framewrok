unit ufrmAyarEFaturaIletisimKanali;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils,
  Vcl.AppEvnts, System.ImageList, Vcl.ImgList, Vcl.Samples.Spin,
  thsEdit, thsComboBox, thsMemo,

  ufrmBase, ufrmBaseInputDB;

type
  TfrmAyarEFaturaIletisimKanali = class(TfrmBaseInputDB)
    lblKod: TLabel;
    edtKod: TthsEdit;
    lblAciklama: TLabel;
    edtAciklama: TthsEdit;
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
  Ths.Erp.Database.Table.AyarEFaturaIletisimKanali;

{$R *.dfm}

procedure TfrmAyarEFaturaIletisimKanali.FormCreate(Sender: TObject);
begin
  TAyarEFaturaIletisimKanali(Table).Kod.SetControlProperty(Table.TableName, edtKod);
  TAyarEFaturaIletisimKanali(Table).Aciklama.SetControlProperty(Table.TableName, edtAciklama);

  inherited;
end;

procedure TfrmAyarEFaturaIletisimKanali.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  edtKod.Text := TAyarEFaturaIletisimKanali(Table).Kod.Value;
  edtAciklama.Text := TAyarEFaturaIletisimKanali(Table).Aciklama.Value;
end;

procedure TfrmAyarEFaturaIletisimKanali.btnAcceptClick(Sender: TObject);
begin
  if (FormMode = ifmNewRecord) or (FormMode = ifmCopyNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TAyarEFaturaIletisimKanali(Table).Kod.Value := edtKod.Text;
      TAyarEFaturaIletisimKanali(Table).Aciklama.Value := edtAciklama.Text;
      inherited;
    end;
  end
  else
    inherited;
end;

end.