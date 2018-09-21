unit ufrmPersonelKarti;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils,
  Vcl.AppEvnts, Vcl.Menus, Vcl.Samples.Spin, Vcl.Mask,
  thsEdit, thsComboBox, thsMemo,

  ufrmBase, ufrmBaseInputDB,
  Ths.Erp.Database.Table.AyarPersonelTipi,
  Ths.Erp.Database.Table.AyarPersonelBolum,
  Ths.Erp.Database.Table.AyarPersonelBirim,
  Ths.Erp.Database.Table.AyarPersonelGorev,
  Ths.Erp.Database.Table.AyarPersonelKanGrubu,
  Ths.Erp.Database.Table.AyarPersonelCinsiyet,
  Ths.Erp.Database.Table.AyarPersonelAskerlikDurumu,
  Ths.Erp.Database.Table.AyarPersonelMedeniDurum;

type
  TfrmPersonelKarti = class(TfrmBaseInputDB)
    pgcPersonel: TPageControl;
    tsGenel: TTabSheet;
    tsAyrinti: TTabSheet;
    tsOzel: TTabSheet;
    LabelBrutMaas: TLabel;
    LabelOzelNot: TLabel;
    LabelIkramiyeSayisi: TLabel;
    LabelIkramiyeMiktar: TLabel;
    EditBrutMaas: TEdit;
    EditIkramiyeSayisi: TEdit;
    EditIkramiyeMiktar: TEdit;
    MemoOzelNot: TMemo;
    LabelAyakkabiNo: TLabel;
    LabelElbiseBedeni: TLabel;
    LabelTCKimlikNo: TLabel;
    LabelSemt: TLabel;
    LabelEgitimDurumu: TLabel;
    LabelBitirdigiOkul: TLabel;
    LabelBitirdigiBolum: TLabel;
    LabelEgitimDiger: TLabel;
    LabelServisNo: TLabel;
    EditSemt: TEdit;
    EditBitirdigiOkul: TEdit;
    EditBitirdigiBolum: TEdit;
    EditEgitimDiger: TEdit;
    EditTcKimlikNo: TEdit;
    EditAyakkabiNo: TEdit;
    EditElbiseBedeni: TEdit;
    ComboBoxServisNo: TComboBox;
    LabelPersonelNo: TLabel;
    LabelKartNo: TLabel;
    LabelIseGirisTarihi: TLabel;
    LabelValueKidem: TLabel;
    LabelKidem: TLabel;
    LabelAyrilmaNedeni: TLabel;
    LabelGenelNot: TLabel;
    LabelAyrilmaNedeniAciklamasi: TLabel;
    ImagePersonelResim: TImage;
    MemoGenelNot: TMemo;
    MemoAyrilmaNedeniAciklamasi: TMemo;
    lblPersonelAd: TLabel;
    lblPersonelSoyad: TLabel;
    edtPersonelAd: TthsEdit;
    edtPersonelSoyad: TthsEdit;
    lblTelefon1: TLabel;
    lblTelefon2: TLabel;
    edtTelefon1: TthsEdit;
    edtTelefon2: TthsEdit;
    lblPersonelTipi: TLabel;
    lblBolum: TLabel;
    lblBirim: TLabel;
    lblGorev: TLabel;
    cbbPersonelTipi: TthsCombobox;
    cbbBolum: TthsCombobox;
    cbbBirim: TthsCombobox;
    cbbGorev: TthsCombobox;
    cbbKartNo: TthsCombobox;
    edtPersonelNo: TthsEdit;
    lblIsActive: TLabel;
    chkIsActive: TCheckBox;
    edtYakinAdSoyad: TthsEdit;
    edtYakinTelefon: TthsEdit;
    lblYakinTelefon: TLabel;
    lblYakinAdSoyad: TLabel;
    lblEvAdresi: TLabel;
    edtEvAdresi: TthsEdit;
    lblMailAdresi: TLabel;
    edtMailAdresi: TthsEdit;
    lblDogumTarihi: TLabel;
    lblKanGrubu: TLabel;
    edtDogumTarihi: TthsEdit;
    cbbKanGrubu: TthsCombobox;
    lblCinsiyet: TLabel;
    lblMedeniDurumu: TLabel;
    cbbCinsiyet: TthsCombobox;
    cbbMedeniDurumu: TthsCombobox;
    lblAskerlikDurumu: TLabel;
    cbbAskerlikDurumu: TthsCombobox;
    lblCocukSayisi: TLabel;
    edtCocukSayisi: TthsEdit;
    edtIseGirisTarihi: TthsEdit;
    edtIstenCikisTarihi: TthsEdit;
    cbbEgitimDurumu: TthsCombobox;
    cbbAyrilmaNedeni: TthsCombobox;
    procedure FormCreate(Sender: TObject);override;
    procedure RefreshData();override;
    procedure btnAcceptClick(Sender: TObject);override;
    procedure FormDestroy(Sender: TObject);override;
  private
    vAyarPersonelTipi: TAyarPersonelTipi;
    vAyarPersonelBolum: TAyarPersonelBolum;
    vAyarPersonelBirim: TAyarPersonelBirim;
    vAyarPersonelGorev: TAyarPersonelGorev;
    vAyarPersonelKanGrubu: TAyarPersonelKanGrubu;
    vAyarPersonelCinsiyet: TAyarPersonelCinsiyet;
    vAyarPersonelAskerlikDurumu: TAyarPersonelAskerlikDurumu;
    vAyarPersonelMedeniDurum: TAyarPersonelMedeniDurum;
  public
  protected
  published
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  Ths.Erp.Database.Table.PersonelKarti;

{$R *.dfm}

procedure TfrmPersonelKarti.FormCreate(Sender: TObject);
begin
  TPersonelKarti(Table).PersonelAd.SetControlProperty(Table.TableName, edtPersonelAd);
  TPersonelKarti(Table).PersonelSoyad.SetControlProperty(Table.TableName, edtPersonelSoyad);
  TPersonelKarti(Table).Telefon1.SetControlProperty(Table.TableName, edtTelefon1);
  TPersonelKarti(Table).Telefon2.SetControlProperty(Table.TableName, edtTelefon2);
  TPersonelKarti(Table).PersonelTipi.SetControlProperty(Table.TableName, cbbPersonelTipi);
  TPersonelKarti(Table).Bolum.SetControlProperty(Table.TableName, cbbBolum);
  TPersonelKarti(Table).Birim.SetControlProperty(Table.TableName, cbbBirim);
  TPersonelKarti(Table).Gorev.SetControlProperty(Table.TableName, cbbGorev);
  TPersonelKarti(Table).MailAdresi.SetControlProperty(Table.TableName, edtMailAdresi);
  TPersonelKarti(Table).DogumTarihi.SetControlProperty(Table.TableName, edtDogumTarihi);
  TPersonelKarti(Table).KanGrubu.SetControlProperty(Table.TableName, cbbKanGrubu);
  TPersonelKarti(Table).Cinsiyet.SetControlProperty(Table.TableName, cbbCinsiyet);
  TPersonelKarti(Table).AskerlikDurumu.SetControlProperty(Table.TableName, cbbAskerlikDurumu);
  TPersonelKarti(Table).MedeniDurumu.SetControlProperty(Table.TableName, cbbMedeniDurumu);
  TPersonelKarti(Table).CocukSayisi.SetControlProperty(Table.TableName, edtCocukSayisi);
  TPersonelKarti(Table).YakinAdSoyad.SetControlProperty(Table.TableName, edtYakinAdSoyad);
  TPersonelKarti(Table).YakinTelefon.SetControlProperty(Table.TableName, edtYakinTelefon);
  TPersonelKarti(Table).EvAdresi.SetControlProperty(Table.TableName, edtEvAdresi);

  inherited;

  vAyarPersonelTipi := TAyarPersonelTipi.Create(Table.Database);
  vAyarPersonelBolum := TAyarPersonelBolum.Create(Table.Database);
  vAyarPersonelBirim := TAyarPersonelBirim.Create(Table.Database);
  vAyarPersonelGorev := TAyarPersonelGorev.Create(Table.Database);
  vAyarPersonelKanGrubu := TAyarPersonelKanGrubu.Create(Table.Database);
  vAyarPersonelCinsiyet := TAyarPersonelCinsiyet.Create(Table.Database);
  vAyarPersonelAskerlikDurumu := TAyarPersonelAskerlikDurumu.Create(Table.Database);
  vAyarPersonelMedeniDurum := TAyarPersonelMedeniDurum.Create(Table.Database);

  edtMailAdresi.CharCase := ecNormal;
  edtEvAdresi.CharCase := ecNormal;
end;

procedure TfrmPersonelKarti.FormDestroy(Sender: TObject);
begin
  vAyarPersonelTipi.Free;
  vAyarPersonelBolum.Free;
  vAyarPersonelBirim.Free;
  vAyarPersonelGorev.Free;
  vAyarPersonelKanGrubu.Free;
  vAyarPersonelCinsiyet.Free;
  vAyarPersonelAskerlikDurumu.Free;
  vAyarPersonelMedeniDurum.Free;

  inherited;
end;

procedure TfrmPersonelKarti.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  chkIsActive.Checked := FormatedVariantVal(TPersonelKarti(Table).IsActive.FieldType, TPersonelKarti(Table).IsActive.Value);
  edtPersonelAd.Text := FormatedVariantVal(TPersonelKarti(Table).PersonelAd.FieldType, TPersonelKarti(Table).PersonelAd.Value);
  edtPersonelSoyad.Text := FormatedVariantVal(TPersonelKarti(Table).PersonelSoyad.FieldType, TPersonelKarti(Table).PersonelSoyad.Value);
  edtTelefon1.Text := FormatedVariantVal(TPersonelKarti(Table).Telefon1.FieldType, TPersonelKarti(Table).Telefon1.Value);
  edtTelefon2.Text := FormatedVariantVal(TPersonelKarti(Table).Telefon2.FieldType, TPersonelKarti(Table).Telefon2.Value);
  cbbPersonelTipi.Text := FormatedVariantVal(TPersonelKarti(Table).PersonelTipi.FieldType, TPersonelKarti(Table).PersonelTipi.Value);
  cbbBolum.Text := FormatedVariantVal(TPersonelKarti(Table).Bolum.FieldType, TPersonelKarti(Table).Bolum.Value);
  cbbBirim.Text := FormatedVariantVal(TPersonelKarti(Table).Birim.FieldType, TPersonelKarti(Table).Birim.Value);
  cbbGorev.Text := FormatedVariantVal(TPersonelKarti(Table).Gorev.FieldType, TPersonelKarti(Table).Gorev.Value);
  edtMailAdresi.Text := FormatedVariantVal(TPersonelKarti(Table).MailAdresi.FieldType, TPersonelKarti(Table).MailAdresi.Value);
  edtDogumTarihi.Text := FormatedVariantVal(TPersonelKarti(Table).DogumTarihi.FieldType, TPersonelKarti(Table).DogumTarihi.Value);
  cbbKanGrubu.Text := FormatedVariantVal(TPersonelKarti(Table).KanGrubu.FieldType, TPersonelKarti(Table).KanGrubu.Value);
  cbbCinsiyet.Text := FormatedVariantVal(TPersonelKarti(Table).Cinsiyet.FieldType, TPersonelKarti(Table).Cinsiyet.Value);
  cbbAskerlikDurumu.Text := FormatedVariantVal(TPersonelKarti(Table).AskerlikDurumu.FieldType, TPersonelKarti(Table).AskerlikDurumu.Value);
  cbbMedeniDurumu.Text := FormatedVariantVal(TPersonelKarti(Table).MedeniDurumu.FieldType, TPersonelKarti(Table).MedeniDurumu.Value);
  edtCocukSayisi.Text := FormatedVariantVal(TPersonelKarti(Table).CocukSayisi.FieldType, TPersonelKarti(Table).CocukSayisi.Value);
  edtYakinAdSoyad.Text := FormatedVariantVal(TPersonelKarti(Table).YakinAdSoyad.FieldType, TPersonelKarti(Table).YakinAdSoyad.Value);
  edtYakinTelefon.Text := FormatedVariantVal(TPersonelKarti(Table).YakinTelefon.FieldType, TPersonelKarti(Table).YakinTelefon.Value);
  edtEvAdresi.Text := FormatedVariantVal(TPersonelKarti(Table).EvAdresi.FieldType, TPersonelKarti(Table).EvAdresi.Value);
end;

procedure TfrmPersonelKarti.btnAcceptClick(Sender: TObject);
begin
  if (FormMode = ifmNewRecord) or (FormMode = ifmCopyNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TPersonelKarti(Table).IsActive.Value := chkIsActive.Checked;
      TPersonelKarti(Table).PersonelAd.Value := edtPersonelAd.Text;
      TPersonelKarti(Table).PersonelSoyad.Value := edtPersonelSoyad.Text;
      TPersonelKarti(Table).Telefon1.Value := edtTelefon1.Text;
      TPersonelKarti(Table).Telefon2.Value := edtTelefon2.Text;
      TPersonelKarti(Table).PersonelTipi.Value := cbbPersonelTipi.Text;
      TPersonelKarti(Table).Bolum.Value := cbbBolum.Text;
      TPersonelKarti(Table).Birim.Value := cbbBirim.Text;
      TPersonelKarti(Table).Gorev.Value := cbbGorev.Text;
      TPersonelKarti(Table).MailAdresi.Value := edtMailAdresi.Text;
      TPersonelKarti(Table).DogumTarihi.Value := edtDogumTarihi.Text;
      TPersonelKarti(Table).KanGrubu.Value := cbbKanGrubu.Text;
      TPersonelKarti(Table).Cinsiyet.Value := cbbCinsiyet.Text;
      TPersonelKarti(Table).AskerlikDurumu.Value := cbbAskerlikDurumu.Text;
      TPersonelKarti(Table).MedeniDurumu.Value := cbbMedeniDurumu.Text;
      TPersonelKarti(Table).CocukSayisi.Value := edtCocukSayisi.Text;
      TPersonelKarti(Table).YakinAdSoyad.Value := edtYakinAdSoyad.Text;
      TPersonelKarti(Table).YakinTelefon.Value := edtYakinTelefon.Text;
      TPersonelKarti(Table).EvAdresi.Value := edtEvAdresi.Text;
      inherited;
    end;
  end
  else
    inherited;
end;

end.

