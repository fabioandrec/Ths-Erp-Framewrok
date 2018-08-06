unit ufrmStokKarti;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils, Vcl.Menus,
  Vcl.AppEvnts, System.ImageList, Vcl.ImgList, Vcl.Samples.Spin,
  thsBaseTypes, thsEdit, thsComboBox, thsMemo,

  ufrmBase, ufrmBaseInputDB,
  Ths.Erp.Constants,
  Ths.Erp.Database.Table.OlcuBirimi,
  Ths.Erp.Database.Table.StokGrubu,
  Ths.Erp.Database.Table.Ulke,
  Ths.Erp.Database.Table.ParaBirimi,
  Ths.Erp.Database.Table.CinsOzelligi,
  Ths.Erp.Database.Table.AyarBarkodSeriNoTuru;

type
  TfrmStokKarti = class(TfrmBaseInputDB)
    pgcStokKarti: TPageControl;
    tsGenel: TTabSheet;
    tsCinsOzelligi: TTabSheet;
    tsDiger: TTabSheet;
    lblSeriNoTuru: TLabel;
    lblIsHariciSeriNoIcerir: TLabel;
    lblHariciSerinoStokKodu: TLabel;
    lblOncekiDonemCikanMiktar: TLabel;
    lblTeminSuresi: TLabel;
    lblDoubleDegisken3: TLabel;
    lblDoubleDegisken2: TLabel;
    lblDoubleDegisken1: TLabel;
    lblIntegerDegisken3: TLabel;
    lblIntegerDegisken2: TLabel;
    lblIntegerDegisken1: TLabel;
    lblStringDegisken6: TLabel;
    lblStringDegisken5: TLabel;
    lblStringDegisken4: TLabel;
    lblStringDegisken3: TLabel;
    lblStringDegisken2: TLabel;
    lblStringDegisken1: TLabel;
    lblCins: TLabel;
    tsOzetler: TTabSheet;
    imgStokResim: TImage;
    lblOrtalamaMaliyetBirim: TLabel;
    lblMarka: TLabel;
    lblAgirlik: TLabel;
    lblKapasite: TLabel;
    lblStokKodu: TLabel;
    edtStokKodu: TthsEdit;
    lblStokAdi: TLabel;
    edtStokAdi: TthsEdit;
    lblDiibUrunTanimi: TLabel;
    edtDiibUrunTanimi: TthsEdit;
    lblStokGrubu: TLabel;
    lblOlcuBirimi: TLabel;
    lblEsikDeger: TLabel;
    edtEsikDeger: TthsEdit;
    lblPaketMiktari: TLabel;
    edtPaketMiktari: TthsEdit;
    lblLotPartiMiktari: TLabel;
    edtLotPartiMiktari: TthsEdit;
    lblAlisIskonto: TLabel;
    edtAlisIskonto: TthsEdit;
    lblSatisIskonto: TLabel;
    edtSatisIskonto: TthsEdit;
    lblYetkiliIskonto: TLabel;
    edtYetkiliIskonto: TthsEdit;
    lblSatisFiyat: TLabel;
    edtSatisFiyat: TthsEdit;
    cbbSatisParaBirimi: TthsCombobox;
    lblAlisFiyat: TLabel;
    edtAlisFiyat: TthsEdit;
    cbbAlisParaBirimi: TthsCombobox;
    lblHamAlisFiyat: TLabel;
    edtHamAlisFiyat: TthsEdit;
    cbbHamAlisParaBirimi: TthsCombobox;
    lblIhracFiyat: TLabel;
    edtIhracFiyat: TthsEdit;
    cbbIhracParaBirimi: TthsCombobox;
    lblOrtalamaMaliyet: TLabel;
    edtOrtalamaMaliyet: TthsEdit;
    lblIsAnaUrun: TLabel;
    lblIsSatilabilir: TLabel;
    lblIsYariMamul: TLabel;
    lblIsOzetUrun: TLabel;
    lblOzelKod: TLabel;
    lblVarsayilanRecete: TLabel;
    lblEn: TLabel;
    lblBoy: TLabel;
    lblYukseklik: TLabel;
    lblEnXBoy: TLabel;
    lblBoyxYukseklik: TLabel;
    lblHacim: TLabel;
    lblValueHacim: TLabel;
    lblMensei: TLabel;
    lblGtipNo: TLabel;
    lblTasiyiciPaket: TLabel;
    lblTanim: TLabel;
    edtOzelKod: TthsEdit;
    chkIsAnaUrun: TCheckBox;
    chkIsYariMamul: TCheckBox;
    chkIsOzetUrun: TCheckBox;
    chkIsSatilabilir: TCheckBox;
    cbbVarsayilanRecete: TthsCombobox;
    edtEn: TthsEdit;
    edtBoy: TthsEdit;
    edtYukseklik: TthsEdit;
    cbbMensei: TthsCombobox;
    edtGtipNo: TthsEdit;
    cbbTasiyiciPaket: TthsCombobox;
    pnlCins: TPanel;
    mmoTanim: TthsMemo;
    btnGirisHareketleri: TButton;
    btnCikisHareketleri: TButton;
    btnTumHareketler: TButton;
    btnReceteyeGit: TButton;
    cbbCins: TthsCombobox;
    edtMarka: TthsEdit;
    edtAgirlik: TthsEdit;
    edtKapasite: TthsEdit;
    edtStringDegisken1: TthsEdit;
    edtStringDegisken2: TthsEdit;
    edtStringDegisken3: TthsEdit;
    edtStringDegisken4: TthsEdit;
    edtStringDegisken5: TthsEdit;
    edtStringDegisken6: TthsEdit;
    edtIntegerDegisken1: TthsEdit;
    edtIntegerDegisken2: TthsEdit;
    edtIntegerDegisken3: TthsEdit;
    edtDoubleDegisken1: TthsEdit;
    edtDoubleDegisken2: TthsEdit;
    edtDoubleDegisken3: TthsEdit;
    btnResimEkleDil: TButton;
    cbbSeriNoTuru: TthsCombobox;
    chkIsHariciSeriNoIcerir: TCheckBox;
    cbbHariciSerinoStokKodu: TthsCombobox;
    edtOncekiDonemCikanMiktar: TthsEdit;
    edtTeminSuresi: TthsEdit;
    pnlOzetHeader: TPanel;
    pnlOzetTop: TPanel;
    lblSerbestStokBirim: TLabel;
    lblSerbestStokToplam: TLabel;
    lblBlokajBirim: TLabel;
    lblBlokajToplam: TLabel;
    lblDonemBasiBirim: TLabel;
    lblGirenToplamBirim: TLabel;
    lblCikanToplamBirim: TLabel;
    lblStokMiktariBirim: TLabel;
    LabelStokMiktari: TLabel;
    LabelCikanToplam: TLabel;
    LabelGirenToplam: TLabel;
    LabelDonemBasiMiktar: TLabel;
    pnlOzetMiddle: TPanel;
    lblStokDegeriOrtPara: TLabel;
    lblStokDegeriSonPara: TLabel;
    lblDonemBasiDegerPara: TLabel;
    LabelStokDegeri2: TLabel;
    LabelStokDegeri1: TLabel;
    LabelDonemBasiDeger: TLabel;
    lblDonemBasiFiyatPara: TLabel;
    lblToplamAlisPara: TLabel;
    lblToplamSatisPara: TLabel;
    LabelToplamSatis: TLabel;
    LabelToplamAlis: TLabel;
    LabelDonemBasiFiyat: TLabel;
    pnlOzetBottom: TPanel;
    lblOncekiDonemCikanBirim: TLabel;
    lblSonAlisFiyatiPara: TLabel;
    lblAlisPara: TLabel;
    lblOrtalamaMaliyetPara: TLabel;
    lblSatisPara: TLabel;
    LabelOncekiDonemCikan: TLabel;
    LabelSonAlisFiyati: TLabel;
    LabelOzetOrtalamaMaliyet: TLabel;
    LabelOzetAlis: TLabel;
    LabelOzetSatis: TLabel;
    EditDonemBasiMiktar: TEdit;
    EditGirenToplam: TEdit;
    EditCikanToplam: TEdit;
    EditStokMiktari: TEdit;
    edtBlokajToplam: TEdit;
    edtSerbestStokToplam: TEdit;
    EditDonemBasiFiyat: TEdit;
    EditDonembasiDeger: TEdit;
    EditStokDegerOrt: TEdit;
    EditStokDegerSon: TEdit;
    EditToplamAlis: TEdit;
    EditToplamSatis: TEdit;
    EditOzetSatis: TEdit;
    EditOzetAlis: TEdit;
    EditOzetOrtalamaMaliyet: TEdit;
    EditSonAlisFiyati: TEdit;
    EditOncekiDonemCikan: TEdit;
    edtStokGrubu: TthsEdit;
    edtOlcuBirimi: TthsEdit;
    procedure FormCreate(Sender: TObject);override;
    procedure RefreshData();override;
    procedure btnAcceptClick(Sender: TObject);override;
    procedure cbbCinsChange(Sender: TObject);
    procedure pgcStokKartiChange(Sender: TObject);
    procedure btnGirisHareketleriClick(Sender: TObject);
    procedure btnCikisHareketleriClick(Sender: TObject);
    procedure btnTumHareketlerClick(Sender: TObject);
    procedure btnReceteyeGitClick(Sender: TObject);
  private
    vOlcuBirimi: TOlcuBirimi;
    vStokGrubu: TStokGrubu;
    vUlke: TUlke;
    vParaBirimi: TParaBirimi;
    vCinsOzelligi: TCinsOzelligi;
    vBarkodSeriNoTuru: TAyarBarkodSeriNoTuru;
  public
  protected
  published
    procedure FormDestroy(Sender: TObject); override;
    procedure FormShow(Sender: TObject); override;
    procedure HelperProcess(Sender: TObject);
  end;

implementation

uses
  Ths.Erp.Database.Singleton,
  Ths.Erp.Database.Table.StokKarti,
  ufrmHelperOlcuBirimi,
  ufrmHelperStokGrubu;

{$R *.dfm}

procedure TfrmStokKarti.btnCikisHareketleriClick(Sender: TObject);
begin
  ShowMessage('��k�� hareketlerini g�sterecek');
end;

procedure TfrmStokKarti.btnGirisHareketleriClick(Sender: TObject);
begin
  ShowMessage('Giri� hareketlerini g�sterecek');
end;

procedure TfrmStokKarti.btnReceteyeGitClick(Sender: TObject);
begin
  ShowMessage('re�ete detaylar ekran�n� g�sterecek');
end;

procedure TfrmStokKarti.btnTumHareketlerClick(Sender: TObject);
begin
  ShowMessage('t�m hareketleri g�sterecek');
end;

procedure TfrmStokKarti.cbbCinsChange(Sender: TObject);
begin
  lblStringDegisken1.Visible := False;
  lblStringDegisken2.Visible := False;
  lblStringDegisken3.Visible := False;
  lblStringDegisken4.Visible := False;
  lblStringDegisken5.Visible := False;
  lblStringDegisken6.Visible := False;
  lblIntegerDegisken1.Visible := False;
  lblIntegerDegisken2.Visible := False;
  lblIntegerDegisken3.Visible := False;
  lblDoubleDegisken1.Visible := False;
  lblDoubleDegisken2.Visible := False;
  lblDoubleDegisken3.Visible := False;

  edtStringDegisken1.Visible := False;
  edtStringDegisken2.Visible := False;
  edtStringDegisken3.Visible := False;
  edtStringDegisken4.Visible := False;
  edtStringDegisken5.Visible := False;
  edtStringDegisken6.Visible := False;
  edtIntegerDegisken1.Visible := False;
  edtIntegerDegisken2.Visible := False;
  edtIntegerDegisken3.Visible := False;
  edtDoubleDegisken1.Visible := False;
  edtDoubleDegisken2.Visible := False;
  edtDoubleDegisken3.Visible := False;

  if (cbbCins.ItemIndex > -1) and Assigned(cbbCins.Items.Objects[cbbCins.ItemIndex]) then
  begin
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String1.Value <> '' then
    begin
      lblStringDegisken1.Visible := True;
      edtStringDegisken1.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String2.Value <> '' then
    begin
      lblStringDegisken2.Visible := True;
      edtStringDegisken2.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String3.Value <> '' then
    begin
      lblStringDegisken3.Visible := True;
      edtStringDegisken3.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String4.Value <> '' then
    begin
      lblStringDegisken4.Visible := True;
      edtStringDegisken4.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String5.Value <> '' then
    begin
      lblStringDegisken5.Visible := True;
      edtStringDegisken5.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String6.Value <> '' then
    begin
      lblStringDegisken6.Visible := True;
      edtStringDegisken6.Visible := True;
    end;

    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String7.Value <> '' then
    begin
      lblIntegerDegisken1.Visible := True;
      edtIntegerDegisken1.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String8.Value <> '' then
    begin
      lblIntegerDegisken2.Visible := True;
      edtIntegerDegisken2.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String9.Value <> '' then
    begin
      lblIntegerDegisken3.Visible := True;
      edtIntegerDegisken3.Visible := True;
    end;

    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String10.Value <> '' then
    begin
      lblDoubleDegisken1.Visible := True;
      edtDoubleDegisken1.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String11.Value <> '' then
    begin
      lblDoubleDegisken2.Visible := True;
      edtDoubleDegisken2.Visible := True;
    end;
    if TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String12.Value <> '' then
    begin
      lblDoubleDegisken3.Visible := True;
      edtDoubleDegisken3.Visible := True;
    end;

    lblStringDegisken1.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String1.Value;
    lblStringDegisken2.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String2.Value;
    lblStringDegisken3.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String3.Value;
    lblStringDegisken4.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String4.Value;
    lblStringDegisken5.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String5.Value;
    lblStringDegisken6.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String6.Value;
    lblIntegerDegisken1.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String7.Value;
    lblIntegerDegisken2.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String8.Value;
    lblIntegerDegisken3.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String9.Value;
    lblDoubleDegisken1.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String10.Value;
    lblDoubleDegisken2.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String11.Value;
    lblDoubleDegisken3.Caption := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).String12.Value;
  end;
end;

procedure TfrmStokKarti.FormCreate(Sender: TObject);
var
  n1, nVarsayilan: Integer;
begin
  TStokKarti(Table).StokKodu.SetControlProperty(Table.TableName, edtStokKodu);
  TStokKarti(Table).StokAdi.SetControlProperty(Table.TableName, edtStokAdi);
  TStokKarti(Table).StokGrubu.SetControlProperty(Table.TableName, edtStokGrubu);
  TStokKarti(Table).OlcuBirimi.SetControlProperty(Table.TableName, edtOlcuBirimi);
  TStokKarti(Table).AlisIskonto.SetControlProperty(Table.TableName, edtAlisIskonto);
  TStokKarti(Table).SatisIskonto.SetControlProperty(Table.TableName, edtSatisIskonto);
  TStokKarti(Table).YetkiliIskonto.SetControlProperty(Table.TableName, edtYetkiliIskonto);
  TStokKarti(Table).HamAlisFiyat.SetControlProperty(Table.TableName, edtHamAlisFiyat);
  TStokKarti(Table).HamAlisParaBirimi.SetControlProperty(Table.TableName, cbbHamAlisParaBirimi);
  TStokKarti(Table).AlisFiyat.SetControlProperty(Table.TableName, edtAlisFiyat);
  TStokKarti(Table).AlisParaBirimi.SetControlProperty(Table.TableName, cbbAlisParaBirimi);
  TStokKarti(Table).SatisFiyat.SetControlProperty(Table.TableName, edtSatisFiyat);
  TStokKarti(Table).SatisParaBirimi.SetControlProperty(Table.TableName, cbbSatisParaBirimi);
  TStokKarti(Table).IhracFiyat.SetControlProperty(Table.TableName, edtIhracFiyat);
  TStokKarti(Table).VarsayilanRecete.SetControlProperty(Table.TableName, cbbVarsayilanRecete);
  TStokKarti(Table).En.SetControlProperty(Table.TableName, edtEn);
  TStokKarti(Table).Boy.SetControlProperty(Table.TableName, edtBoy);
  TStokKarti(Table).Yukseklik.SetControlProperty(Table.TableName, edtYukseklik);
  TStokKarti(Table).Mensei.SetControlProperty(Table.TableName, cbbMensei);
  TStokKarti(Table).GtipNo.SetControlProperty(Table.TableName, edtGtipNo);
  TStokKarti(Table).DiibUrunTanimi.SetControlProperty(Table.TableName, edtDiibUrunTanimi);
  TStokKarti(Table).EsikDeger.SetControlProperty(Table.TableName, edtEsikDeger);
  TStokKarti(Table).Tanim.SetControlProperty(Table.TableName, mmoTanim);
  TStokKarti(Table).OzelKod.SetControlProperty(Table.TableName, edtOzelKod);
  TStokKarti(Table).Marka.SetControlProperty(Table.TableName, edtMarka);
  TStokKarti(Table).Agirlik.SetControlProperty(Table.TableName, edtAgirlik);
  TStokKarti(Table).Kapasite.SetControlProperty(Table.TableName, edtKapasite);
  TStokKarti(Table).Cins.SetControlProperty(Table.TableName, cbbCins);
  TStokKarti(Table).StringDegisken1.SetControlProperty(Table.TableName, edtStringDegisken1);
  TStokKarti(Table).StringDegisken2.SetControlProperty(Table.TableName, edtStringDegisken2);
  TStokKarti(Table).StringDegisken3.SetControlProperty(Table.TableName, edtStringDegisken3);
  TStokKarti(Table).StringDegisken4.SetControlProperty(Table.TableName, edtStringDegisken4);
  TStokKarti(Table).StringDegisken5.SetControlProperty(Table.TableName, edtStringDegisken5);
  TStokKarti(Table).StringDegisken6.SetControlProperty(Table.TableName, edtStringDegisken6);
  TStokKarti(Table).IntegerDegisken1.SetControlProperty(Table.TableName, edtIntegerDegisken1);
  TStokKarti(Table).IntegerDegisken2.SetControlProperty(Table.TableName, edtIntegerDegisken2);
  TStokKarti(Table).IntegerDegisken3.SetControlProperty(Table.TableName, edtIntegerDegisken3);
  TStokKarti(Table).DoubleDegisken1.SetControlProperty(Table.TableName, edtDoubleDegisken1);
  TStokKarti(Table).DoubleDegisken2.SetControlProperty(Table.TableName, edtDoubleDegisken2);
  TStokKarti(Table).DoubleDegisken3.SetControlProperty(Table.TableName, edtDoubleDegisken3);
  TStokKarti(Table).LotPartiMiktari.SetControlProperty(Table.TableName, edtLotPartiMiktari);
  TStokKarti(Table).PaketMiktari.SetControlProperty(Table.TableName, edtPaketMiktari);
  TStokKarti(Table).SeriNoTuru.SetControlProperty(Table.TableName, cbbSeriNoTuru);
  TStokKarti(Table).HariciSerinoStokKodu.SetControlProperty(Table.TableName, cbbHariciSerinoStokKodu);
  TStokKarti(Table).TasiyiciPaket.SetControlProperty(Table.TableName, cbbTasiyiciPaket);
  TStokKarti(Table).OncekiDonemCikanMiktar.SetControlProperty(Table.TableName, edtOncekiDonemCikanMiktar);
  TStokKarti(Table).TeminSuresi.SetControlProperty(Table.TableName, edtTeminSuresi);

  inherited;

  nVarsayilan := -1;

  vStokGrubu := TStokGrubu.Create(Table.Database);
  vOlcuBirimi := TOlcuBirimi.Create(Table.Database);
  vUlke := TUlke.Create(Table.Database);
  vParaBirimi := TParaBirimi.Create(Table.Database);
  vCinsOzelligi := TCinsOzelligi.Create(Table.Database);
  vBarkodSeriNoTuru := TAyarBarkodSeriNoTuru.Create(Table.Database);

  vUlke.SelectToList('', False, False);
  cbbMensei.Clear;
  for n1 := 0 to vUlke.List.Count-1 do
    cbbMensei.AddItem(FormatedVariantVal(TUlke(vUlke.List[n1]).UlkeAdi.FieldType, TUlke(vUlke.List[n1]).UlkeAdi.Value), TUlke(vUlke.List[n1]));

  vParaBirimi.SelectToList('', False, False);
  cbbHamAlisParaBirimi.Clear;
  cbbAlisParaBirimi.Clear;
  cbbSatisParaBirimi.Clear;
  cbbHamAlisParaBirimi.Clear;
  for n1 := 0 to vParaBirimi.List.Count-1 do
  begin
    if TParaBirimi(vParaBirimi.List[n1]).IsVarsayilan.Value then
      nVarsayilan := n1;
    cbbHamAlisParaBirimi.AddItem(FormatedVariantVal(TParaBirimi(vParaBirimi.List[n1]).Kod.FieldType, TParaBirimi(vParaBirimi.List[n1]).Kod.Value), TParaBirimi(vParaBirimi.List[n1]));
    cbbAlisParaBirimi.AddItem(FormatedVariantVal(TParaBirimi(vParaBirimi.List[n1]).Kod.FieldType, TParaBirimi(vParaBirimi.List[n1]).Kod.Value), TParaBirimi(vParaBirimi.List[n1]));
    cbbSatisParaBirimi.AddItem(FormatedVariantVal(TParaBirimi(vParaBirimi.List[n1]).Kod.FieldType, TParaBirimi(vParaBirimi.List[n1]).Kod.Value), TParaBirimi(vParaBirimi.List[n1]));
    cbbIhracParaBirimi.AddItem(FormatedVariantVal(TParaBirimi(vParaBirimi.List[n1]).Kod.FieldType, TParaBirimi(vParaBirimi.List[n1]).Kod.Value), TParaBirimi(vParaBirimi.List[n1]));
  end;
  cbbHamAlisParaBirimi.ItemIndex := nVarsayilan;
  cbbAlisParaBirimi.ItemIndex := nVarsayilan;
  cbbSatisParaBirimi.ItemIndex := nVarsayilan;
  cbbIhracParaBirimi.ItemIndex := nVarsayilan;

  vCinsOzelligi.SelectToList('', False, False);
  cbbCins.Clear;
  for n1 := 0 to vCinsOzelligi.List.Count-1 do
    cbbCins.AddItem(FormatedVariantVal(TCinsOzelligi(vCinsOzelligi.List[n1]).Cins.FieldType, TCinsOzelligi(vCinsOzelligi.List[n1]).Cins.Value), TCinsOzelligi(vCinsOzelligi.List[n1]));
  cbbCins.ItemIndex := -1;
  cbbCinsChange(cbbCins);

  vBarkodSeriNoTuru.SelectToList('', False, False);
  cbbSeriNoTuru.Clear;
  for n1 := 0 to vBarkodSeriNoTuru.List.Count-1 do
    cbbSeriNoTuru.AddItem(FormatedVariantVal(TAyarBarkodSeriNoTuru(vBarkodSeriNoTuru.List[n1]).Tur.FieldType, TAyarBarkodSeriNoTuru(vBarkodSeriNoTuru.List[n1]).Tur.Value), TAyarBarkodSeriNoTuru(vBarkodSeriNoTuru.List[n1]));
  cbbSeriNoTuru.ItemIndex := -1;
end;

procedure TfrmStokKarti.FormDestroy(Sender: TObject);
begin
  if Assigned(vOlcuBirimi) then
    vOlcuBirimi.Free;
  if Assigned(vStokGrubu) then
    vStokGrubu.Free;

  vUlke.Free;
  vParaBirimi.Free;
  vCinsOzelligi.Free;
  if Assigned(vBarkodSeriNoTuru) then
    vBarkodSeriNoTuru.Free;

  inherited;
end;

procedure TfrmStokKarti.FormShow(Sender: TObject);
begin
  pgcStokKarti.ActivePage := tsGenel;
  pgcStokKartiChange(pgcStokKarti);

  inherited;

  btnGirisHareketleri.Images := TSingletonDB.GetInstance.ImageList32;
  btnGirisHareketleri.HotImageIndex := IMG_STOCK_ADD;
  btnGirisHareketleri.ImageIndex := IMG_STOCK_ADD;
  btnGirisHareketleri.Caption := '';

  btnCikisHareketleri.Images := TSingletonDB.GetInstance.ImageList32;
  btnCikisHareketleri.HotImageIndex := IMG_STOCK_DELETE;
  btnCikisHareketleri.ImageIndex := IMG_STOCK_DELETE;
  btnCikisHareketleri.Caption := '';

  btnTumHareketler.Images := TSingletonDB.GetInstance.ImageList32;
  btnTumHareketler.HotImageIndex := IMG_STOCK;
  btnTumHareketler.ImageIndex := IMG_STOCK;
  btnTumHareketler.Caption := '';

  edtOrtalamaMaliyet.ReadOnly := False;

  edtStokGrubu.OnHelperProcess := HelperProcess;
  edtStokGrubu.thsInputDataType := itString;
  edtStokGrubu.ReadOnly := True;

  edtOlcuBirimi.OnHelperProcess := HelperProcess;
  edtOlcuBirimi.thsInputDataType := itString;
  edtOlcuBirimi.ReadOnly := True;

  {$ifdef DEBUG}
    edtStokKodu.Text := 'ELMAK';
    edtStokAdi.Text := 'ELMA KIRMIZI';
    edtSatisFiyat.Text := '3';
    edtAlisFiyat.Text := '2,1';
    edtHamAlisFiyat.Text := '2';
    edtIhracFiyat.Text := '3';
    cbbIhracParaBirimi.ItemIndex := cbbIhracParaBirimi.Items.IndexOf('EUR');
    edtOrtalamaMaliyet.Text := '2';
  {$EndIf}
end;

procedure TfrmStokKarti.HelperProcess(Sender: TObject);
var
  vHelperStokGrubu: TfrmHelperStokGrubu;
  vHelperOlcuBirimi: TfrmHelperOlcuBirimi;
begin
  if Sender.ClassType = TthsEdit then
  begin
    if TthsEdit(Sender).Name = edtStokGrubu.Name then
    begin
      vHelperStokGrubu := TfrmHelperStokGrubu.Create(edtStokGrubu, Self, TStokGrubu.Create(Table.Database), True, ifmNone, fomNormal);
      try
        vHelperStokGrubu.ShowModal;

        if Assigned(vStokGrubu) then
          vStokGrubu.Free;

        vStokGrubu := TStokGrubu(TStokGrubu(vHelperStokGrubu.Table).Clone);
      finally
        vHelperStokGrubu.Free;
      end;
    end
    else
    if TthsEdit(Sender).Name = edtOlcuBirimi.Name then
    begin
      vHelperOlcuBirimi := TfrmHelperOlcuBirimi.Create(edtOlcuBirimi, Self, TOlcuBirimi.Create(Table.Database), True, ifmNone, fomNormal);
      try
        vHelperOlcuBirimi.ShowModal;

        if Assigned(vOlcuBirimi) then
          vOlcuBirimi.Free;

        vOlcuBirimi := TOlcuBirimi(TOlcuBirimi(vHelperOlcuBirimi.Table).Clone);
      finally
        vHelperOlcuBirimi.Free;
      end;
    end;
  end
end;

procedure TfrmStokKarti.pgcStokKartiChange(Sender: TObject);
begin
  if pgcStokKarti.ActivePage.Name = tsOzetler.Name then
  begin
    lblStokKodu.Parent := pnlOzetHeader;
    edtStokKodu.Parent := pnlOzetHeader;
    lblStokAdi.Parent := pnlOzetHeader;
    edtStokAdi.Parent := pnlOzetHeader;
  end
  else
  begin
    lblStokKodu.Parent := pgcStokKarti.ActivePage;
    edtStokKodu.Parent := pgcStokKarti.ActivePage;
    lblStokAdi.Parent := pgcStokKarti.ActivePage;
    edtStokAdi.Parent := pgcStokKarti.ActivePage;
  end;

  if pgcStokKarti.ActivePage.Name = tsGenel.Name then
  begin
    edtStokKodu.ReadOnly := False;
    edtStokKodu.TabStop := True;
    edtStokAdi.ReadOnly := False;
    edtStokAdi.TabStop := True;

    edtStokKodu.TabOrder := 0;
    edtStokAdi.TabOrder := 1;
    edtStokKodu.SetFocus;
  end
  else
  begin
    edtStokKodu.ReadOnly := True;
    edtStokKodu.TabStop := False;
    edtStokAdi.ReadOnly := True;
    edtStokAdi.TabStop := False;
  end;
end;

procedure TfrmStokKarti.RefreshData();
begin
  //control i�eri�ini table class ile doldur
  edtStokKodu.Text := FormatedVariantVal(TStokKarti(Table).StokKodu.FieldType, TStokKarti(Table).StokKodu.Value);
  edtStokAdi.Text := FormatedVariantVal(TStokKarti(Table).StokAdi.FieldType, TStokKarti(Table).StokAdi.Value);

  edtStokGrubu.Text := FormatedVariantVal(TStokKarti(Table).StokGrubu.FieldType, TStokKarti(Table).StokGrubu.Value);
  vStokGrubu.SelectToList(' AND ' + vStokGrubu.TableName + '.' + vStokGrubu.Id.FieldName + '=' + IntToStr(TStokKarti(Table).StokGrubuID.Value), False, False);

  edtOlcuBirimi.Text := FormatedVariantVal(TStokKarti(Table).OlcuBirimi.FieldType, TStokKarti(Table).OlcuBirimi.Value);
  vOlcuBirimi.SelectToList(' AND ' + vOlcuBirimi.TableName + '.' + vOlcuBirimi.Id.FieldName + '=' + IntToStr(TStokKarti(Table).OlcuBirimiID.Value), False, False);

  edtAlisIskonto.Text := FormatedVariantVal(TStokKarti(Table).AlisIskonto.FieldType, TStokKarti(Table).AlisIskonto.Value);
  edtSatisIskonto.Text := FormatedVariantVal(TStokKarti(Table).SatisIskonto.FieldType, TStokKarti(Table).SatisIskonto.Value);
  edtYetkiliIskonto.Text := FormatedVariantVal(TStokKarti(Table).YetkiliIskonto.FieldType, TStokKarti(Table).YetkiliIskonto.Value);

  edtHamAlisFiyat.Text := FormatedVariantVal(TStokKarti(Table).HamAlisFiyat.FieldType, TStokKarti(Table).HamAlisFiyat.Value);
  cbbHamAlisParaBirimi.Text := FormatedVariantVal(TStokKarti(Table).HamAlisParaBirimi.FieldType, TStokKarti(Table).HamAlisParaBirimi.Value);
  edtAlisFiyat.Text := FormatedVariantVal(TStokKarti(Table).AlisFiyat.FieldType, TStokKarti(Table).AlisFiyat.Value);
  cbbAlisParaBirimi.Text := FormatedVariantVal(TStokKarti(Table).AlisParaBirimi.FieldType, TStokKarti(Table).AlisParaBirimi.Value);
  edtSatisFiyat.Text := FormatedVariantVal(TStokKarti(Table).SatisFiyat.FieldType, TStokKarti(Table).SatisFiyat.Value);
  cbbSatisParaBirimi.Text := FormatedVariantVal(TStokKarti(Table).SatisParaBirimi.FieldType, TStokKarti(Table).SatisParaBirimi.Value);
  edtIhracFiyat.Text := FormatedVariantVal(TStokKarti(Table).IhracFiyat.FieldType, TStokKarti(Table).IhracFiyat.Value);
  cbbIhracParaBirimi.Text := FormatedVariantVal(TStokKarti(Table).IhracParaBirimi.FieldType, TStokKarti(Table).IhracParaBirimi.Value);

//  cbbVarsayilanRecete.Text := FormatedVariantVal(TStokKarti(Table).VarsayilanRecete.FieldType, TStokKarti(Table).VarsayilanRecete.Value);

  edtEn.Text := FormatedVariantVal(TStokKarti(Table).En.FieldType, TStokKarti(Table).En.Value);
  edtBoy.Text := FormatedVariantVal(TStokKarti(Table).Boy.FieldType, TStokKarti(Table).Boy.Value);
  edtYukseklik.Text := FormatedVariantVal(TStokKarti(Table).Yukseklik.FieldType, TStokKarti(Table).Yukseklik.Value);
  cbbMensei.ItemIndex := cbbMensei.Items.IndexOf( FormatedVariantVal(TStokKarti(Table).Mensei.FieldType, TStokKarti(Table).Mensei.Value) );
  edtGtipNo.Text := FormatedVariantVal(TStokKarti(Table).GtipNo.FieldType, TStokKarti(Table).GtipNo.Value);
  edtDiibUrunTanimi.Text := FormatedVariantVal(TStokKarti(Table).DiibUrunTanimi.FieldType, TStokKarti(Table).DiibUrunTanimi.Value);

  edtEsikDeger.Text := FormatedVariantVal(TStokKarti(Table).EsikDeger.FieldType, TStokKarti(Table).EsikDeger.Value);
  mmoTanim.Text := FormatedVariantVal(TStokKarti(Table).Tanim.FieldType, TStokKarti(Table).Tanim.Value);
  edtOzelKod.Text := FormatedVariantVal(TStokKarti(Table).OzelKod.FieldType, TStokKarti(Table).OzelKod.Value);
  edtMarka.Text := FormatedVariantVal(TStokKarti(Table).Marka.FieldType, TStokKarti(Table).Marka.Value);
  edtAgirlik.Text := FormatedVariantVal(TStokKarti(Table).Agirlik.FieldType, TStokKarti(Table).Agirlik.Value);
  edtKapasite.Text := FormatedVariantVal(TStokKarti(Table).Kapasite.FieldType, TStokKarti(Table).Kapasite.Value);

  cbbCins.ItemIndex := cbbCins.Items.IndexOf( FormatedVariantVal(TStokKarti(Table).Cins.FieldType, TStokKarti(Table).Cins.Value) );
  cbbCinsChange(cbbCins);
  edtStringDegisken1.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken1.FieldType, TStokKarti(Table).StringDegisken1.Value);
  edtStringDegisken2.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken2.FieldType, TStokKarti(Table).StringDegisken2.Value);
  edtStringDegisken3.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken3.FieldType, TStokKarti(Table).StringDegisken3.Value);
  edtStringDegisken4.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken4.FieldType, TStokKarti(Table).StringDegisken4.Value);
  edtStringDegisken5.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken5.FieldType, TStokKarti(Table).StringDegisken5.Value);
  edtStringDegisken6.Text := FormatedVariantVal(TStokKarti(Table).StringDegisken6.FieldType, TStokKarti(Table).StringDegisken6.Value);
  edtIntegerDegisken1.Text := FormatedVariantVal(TStokKarti(Table).IntegerDegisken1.FieldType, TStokKarti(Table).IntegerDegisken1.Value);
  edtIntegerDegisken2.Text := FormatedVariantVal(TStokKarti(Table).IntegerDegisken2.FieldType, TStokKarti(Table).IntegerDegisken2.Value);
  edtIntegerDegisken3.Text := FormatedVariantVal(TStokKarti(Table).IntegerDegisken3.FieldType, TStokKarti(Table).IntegerDegisken3.Value);
  edtDoubleDegisken1.Text := FormatedVariantVal(TStokKarti(Table).DoubleDegisken1.FieldType, TStokKarti(Table).DoubleDegisken1.Value);
  edtDoubleDegisken2.Text := FormatedVariantVal(TStokKarti(Table).DoubleDegisken2.FieldType, TStokKarti(Table).DoubleDegisken2.Value);
  edtDoubleDegisken3.Text := FormatedVariantVal(TStokKarti(Table).DoubleDegisken3.FieldType, TStokKarti(Table).DoubleDegisken3.Value);

  chkIsSatilabilir.Checked := FormatedVariantVal(TStokKarti(Table).IsSatilabilir.FieldType, TStokKarti(Table).IsSatilabilir.Value);
  chkIsAnaUrun.Checked := FormatedVariantVal(TStokKarti(Table).IsAnaUrun.FieldType, TStokKarti(Table).IsAnaUrun.Value);
  chkIsYariMamul.Checked := FormatedVariantVal(TStokKarti(Table).IsYariMamul.FieldType, TStokKarti(Table).IsYariMamul.Value);
  chkIsOzetUrun.Checked := FormatedVariantVal(TStokKarti(Table).IsOzetUrun.FieldType, TStokKarti(Table).IsOzetUrun.Value);
  edtLotPartiMiktari.Text := FormatedVariantVal(TStokKarti(Table).LotPartiMiktari.FieldType, TStokKarti(Table).LotPartiMiktari.Value);
  edtPaketMiktari.Text := FormatedVariantVal(TStokKarti(Table).PaketMiktari.FieldType, TStokKarti(Table).PaketMiktari.Value);
  cbbSeriNoTuru.Text := FormatedVariantVal(TStokKarti(Table).SeriNoTuru.FieldType, TStokKarti(Table).SeriNoTuru.Value);
  chkIsHariciSeriNoIcerir.Checked := FormatedVariantVal(TStokKarti(Table).IsHariciSeriNoIcerir.FieldType, TStokKarti(Table).IsHariciSeriNoIcerir.Value);
//  cbbHariciSerinoStokKodu.Text := FormatedVariantVal(TStokKarti(Table).HariciSerinoStokKodu.FieldType, TStokKarti(Table).HariciSerinoStokKodu.Value);
//  cbbTasiyiciPaket.Text := FormatedVariantVal(TStokKarti(Table).TasiyiciPaket.FieldType, TStokKarti(Table).TasiyiciPaket.Value);

  edtOncekiDonemCikanMiktar.Text := FormatedVariantVal(TStokKarti(Table).OncekiDonemCikanMiktar.FieldType, TStokKarti(Table).OncekiDonemCikanMiktar.Value);
  edtTeminSuresi.Text := FormatedVariantVal(TStokKarti(Table).TeminSuresi.FieldType, TStokKarti(Table).TeminSuresi.Value);
end;

procedure TfrmStokKarti.btnAcceptClick(Sender: TObject);
begin
  if (FormMode = ifmNewRecord) or (FormMode = ifmCopyNewRecord) or (FormMode = ifmUpdate) then
  begin
    if (ValidateInput) then
    begin
      TStokKarti(Table).StokKodu.Value := edtStokKodu.Text;
      TStokKarti(Table).StokAdi.Value := edtStokAdi.Text;

      TStokKarti(Table).StokGrubu.Value := edtStokGrubu.Text;
      TStokKarti(Table).StokGrubuID.Value := vStokGrubu.Id.Value;

      TStokKarti(Table).OlcuBirimi.Value := edtOlcuBirimi.Text;
      TStokKarti(Table).OlcuBirimiID.Value := vOlcuBirimi.Id.Value;

      TStokKarti(Table).AlisIskonto.Value := StrToFloatDef(edtAlisIskonto.Text, 0);
      TStokKarti(Table).SatisIskonto.Value := StrToFloatDef(edtSatisIskonto.Text, 0);
      TStokKarti(Table).YetkiliIskonto.Value := StrToFloatDef(edtYetkiliIskonto.Text, 0);

      TStokKarti(Table).HamAlisFiyat.Value := StrToFloatDef(edtHamAlisFiyat.Text, 0);
      TStokKarti(Table).HamAlisParaBirimi.Value := cbbHamAlisParaBirimi.Text;

      TStokKarti(Table).AlisFiyat.Value := StrToFloatDef(edtAlisFiyat.Text, 0);
      TStokKarti(Table).AlisParaBirimi.Value := cbbAlisParaBirimi.Text;

      TStokKarti(Table).SatisFiyat.Value := StrToFloatDef(edtSatisFiyat.Text, 0);
      TStokKarti(Table).SatisParaBirimi.Value := cbbSatisParaBirimi.Text;

      TStokKarti(Table).IhracFiyat.Value := StrToFloatDef(edtIhracFiyat.Text, 0);
      TStokKarti(Table).IhracParaBirimi.Value := cbbIhracParaBirimi.Text;

      TStokKarti(Table).VarsayilanRecete.Value := cbbVarsayilanRecete.Text;
      TStokKarti(Table).En.Value := StrToFloatDef(edtEn.Text, 0);
      TStokKarti(Table).Boy.Value := StrToFloatDef(edtBoy.Text, 0);
      TStokKarti(Table).Yukseklik.Value := StrToFloatDef(edtYukseklik.Text, 0);

      if Assigned(cbbMensei.Items.Objects[cbbMensei.ItemIndex]) then
        TStokKarti(Table).MenseiID.Value := TUlke(cbbMensei.Items.Objects[cbbMensei.ItemIndex]).Id.Value;
      TStokKarti(Table).Mensei.Value := cbbMensei.Text;

      TStokKarti(Table).GtipNo.Value := edtGtipNo.Text;
      TStokKarti(Table).DiibUrunTanimi.Value := edtDiibUrunTanimi.Text;
      TStokKarti(Table).EsikDeger.Value := StrToFloatDef(edtEsikDeger.Text, 0);
      TStokKarti(Table).Tanim.Value := mmoTanim.Text;
      TStokKarti(Table).OzelKod.Value := edtOzelKod.Text;
      TStokKarti(Table).Marka.Value := edtMarka.Text;
      TStokKarti(Table).Agirlik.Value := StrToFloatDef(edtAgirlik.Text, 0);
      TStokKarti(Table).Kapasite.Value := StrToFloatDef(edtKapasite.Text, 0);


      TStokKarti(Table).Cins.Value := cbbCins.Text;
      if Assigned(cbbCins.Items.Objects[cbbCins.ItemIndex]) then
        TStokKarti(Table).CinsID.Value := TCinsOzelligi(cbbCins.Items.Objects[cbbCins.ItemIndex]).Id.Value;

      TStokKarti(Table).StringDegisken1.Value := edtStringDegisken1.Text;
      TStokKarti(Table).StringDegisken2.Value := edtStringDegisken2.Text;
      TStokKarti(Table).StringDegisken3.Value := edtStringDegisken3.Text;
      TStokKarti(Table).StringDegisken4.Value := edtStringDegisken4.Text;
      TStokKarti(Table).StringDegisken5.Value := edtStringDegisken5.Text;
      TStokKarti(Table).StringDegisken6.Value := edtStringDegisken6.Text;
      TStokKarti(Table).IntegerDegisken1.Value := edtIntegerDegisken1.Text;
      TStokKarti(Table).IntegerDegisken2.Value := edtIntegerDegisken2.Text;
      TStokKarti(Table).IntegerDegisken3.Value := edtIntegerDegisken3.Text;
      TStokKarti(Table).DoubleDegisken1.Value := StrToFloatDef(edtDoubleDegisken1.Text, 0);
      TStokKarti(Table).DoubleDegisken2.Value := StrToFloatDef(edtDoubleDegisken2.Text, 0);
      TStokKarti(Table).DoubleDegisken3.Value := StrToFloatDef(edtDoubleDegisken3.Text, 0);

      TStokKarti(Table).IsSatilabilir.Value := chkIsSatilabilir.Checked;
      TStokKarti(Table).IsAnaUrun.Value := chkIsAnaUrun.Checked;
      TStokKarti(Table).IsYariMamul.Value := chkIsYariMamul.Checked;
      TStokKarti(Table).IsOzetUrun.Value := chkIsOzetUrun.Checked;
      TStokKarti(Table).LotPartiMiktari.Value := StrToFloatDef(edtLotPartiMiktari.Text, 0);
      TStokKarti(Table).PaketMiktari.Value := StrToFloatDef(edtPaketMiktari.Text, 0);
      TStokKarti(Table).SeriNoTuru.Value := cbbSeriNoTuru.Text;
      TStokKarti(Table).IsHariciSeriNoIcerir.Value := chkIsHariciSeriNoIcerir.Checked;
      TStokKarti(Table).HariciSerinoStokKodu.Value := cbbHariciSerinoStokKodu.Text;
      TStokKarti(Table).TasiyiciPaket.Value := cbbTasiyiciPaket.Text;
      TStokKarti(Table).OncekiDonemCikanMiktar.Value := StrToFloatDef(edtOncekiDonemCikanMiktar.Text, 0);
      TStokKarti(Table).TeminSuresi.Value := StrToFloatDef(edtTeminSuresi.Text, 0);
      inherited;
    end;
  end
  else
    inherited;
end;

end.
