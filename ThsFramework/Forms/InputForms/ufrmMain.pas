unit ufrmMain;

interface

{$I ThsERP.inc}

uses
  Winapi.Windows, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.Menus, Math, StrUtils, Vcl.ActnList, System.Actions,
  Vcl.AppEvnts, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ExtCtrls, System.Classes,
  Vcl.DBCtrls, Dialogs, System.SysUtils, Data.DB, Vcl.Styles.Utils.SystemMenu,
  System.Rtti,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.DApt.Intf, FireDAC.DatS, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.Intf

  , Ths.Erp.Helper.BaseTypes
  , Ths.Erp.Helper.Edit
  , ufrmBase

  , Ths.Erp.Constants
  , Ths.Erp.Functions

  , Ths.Erp.Database.Singleton
  , Ths.Erp.Database.Table
  ;

type
  TfrmMain = class(TfrmBase)
    mmMain: TMainMenu;
    mniApplication: TMenuItem;
    mniAbout: TMenuItem;
    mniSettings: TMenuItem;
    mniChangePassword: TMenuItem;
    mniAdministration: TMenuItem;
    mniClose: TMenuItem;
    pmButtons: TPopupMenu;
    mniAddLanguageContent: TMenuItem;
    pb1: TProgressBar;
    Button1: TButton;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    tsBuying: TTabSheet;
    tsSales: TTabSheet;
    btnTeklifler: TButton;
    tsStock: TTabSheet;
    btnStokHareketi: TButton;
    btnStokKartlari: TButton;
    tsAccounting: TTabSheet;
    btnDovizKurlari: TButton;
    btnHesapKartlari: TButton;
    tsProduction: TTabSheet;
    tsEquipment: TTabSheet;
    tsEmployee: TTabSheet;
    btnPersonelKartlari: TButton;
    btnPersonelDilBilgileri: TButton;
    tsAracTakip: TTabSheet;
    btnAracTakipArac: TButton;
    tsSettings: TTabSheet;
    pgcSettings: TPageControl;
    tsSettingGeneral: TTabSheet;
    btnParaBirimleri: TButton;
    btnAmbarlar: TButton;
    btnAyarFirmaTuru: TButton;
    btnAyarFirmaTipi: TButton;
    btnBankalar: TButton;
    btnBankaSubeleri: TButton;
    btnUrunKabulRedNedenleri: TButton;
    btnQualityFormMailRecievers: TButton;
    btnOdemeBaslangicDonemi: TButton;
    btnTeklifTipleri: TButton;
    btnAyarTeklifDurumlar: TButton;
    btnMusteriTemsilciGruplari: TButton;
    tsSettingStock: TTabSheet;
    btnAyarStokHareketTipi: TButton;
    btnStokTipi: TButton;
    btnStokGrubuTurleri: TButton;
    btnStokGruplari: TButton;
    btnAyarBarkodUrunTuru: TButton;
    btnAyarBarkodSeriNoTuru: TButton;
    btnAyarBarkodHazirlikDosyaTurleri: TButton;
    btnAyarBarkodTezgahlar: TButton;
    btnServis: TButton;
    tsSettingAccount: TTabSheet;
    btnHesapPlani: TButton;
    btnAyarHesapTipleri: TButton;
    btnHesapGrubu: TButton;
    btnBolgeTuru: TButton;
    btnBolge: TButton;
    btnAyarVergiOrani: TButton;
    tsSettingEmployee: TTabSheet;
    btnAyarPersonelBolum: TButton;
    btnAyarPersonelBirim: TButton;
    btnAyarPersonelGorev: TButton;
    btnAyarPersonelTipi: TButton;
    btnAyarPersonelCinsiyet: TButton;
    btnblaa: TButton;
    btnAyarPersonelAskerlikDurumu: TButton;
    btnAyarPersonelRaporTipi: TButton;
    btnAyarPersonelIzinTipi: TButton;
    btnAyarPersonelMedeniDurum: TButton;
    btnAyarPersonelDil: TButton;
    btnAyarPersonelDilSeviyesi: TButton;
    btnAyarPersonelEhliyetTipi: TButton;
    btnAyarPersonelMykTipi: TButton;
    btnAyarPersonelSrcTipi: TButton;
    btnAyarPersonelAyarilmaNedeniTipi: TButton;
    btnAyarPersonelMektupTipi: TButton;
    btnAyarPersonelTatilTipi: TButton;
    tsSettingEInvoice: TTabSheet;
    btnAyarEFaturaFaturaTipi: TButton;
    btnAyarEfaturaIletisimKanali: TButton;
    btnAyarEfaturaIstisnaKodu: TButton;
    tsFrameworkSettings: TTabSheet;
    btnSysPermissionSourceGroup: TButton;
    btnSysPermissionSource: TButton;
    btnSysUserAccessRight: TButton;
    btnSysUser: TButton;
    btnSysGridColWidth: TButton;
    btnSysGridColPercent: TButton;
    btnSysGridColColor: TButton;
    btnSysDefaultOrderFilter: TButton;
    btnSysLang: TButton;
    btnSysLangContent: TButton;
    btnSysQualityFormNumber: TButton;
    btnSysApplicationSettings: TButton;
    btnSysUserMacAddressExceptions: TButton;
    btnPersonelTasimaServisi: TButton;
    btnSysTaxpayerTypes: TButton;
    btnSysCountries: TButton;
    btnSysCities: TButton;
    btnEgitimSeviyeleri: TButton;
    btnCinsAileleri: TButton;
    btnCinsOzellikleri: TButton;
    btnOlcuBirimleri: TButton;
    btnAyarStkUrunTipi: TButton;
    btnAyarEFaturaKimlikSemasi: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);override;
    procedure FormCreate(Sender: TObject);override;
    procedure FormShow(Sender: TObject);override;
    procedure btnSysCountriesClick(Sender: TObject);
    procedure AppEvntsBaseIdle(Sender: TObject; var Done: Boolean);
    procedure btnSysCitiesClick(Sender: TObject);
    procedure btnParaBirimleriClick(Sender: TObject);

/// <summary>
///   Kullan�c�n�n eri�im yetkisine g�re yap�lacak i�lemler burada olacak
/// </summary>
/// <remarks>
///   Login olan kullan�c�ya ait haklara g�re yap�lacak i�lemler burada yap�l�yor.
///   Ana formda kullan�c�n�n sahip oldu�u yetkilere g�re butonlar a��l�yor.
/// </remarks>
/// <example>
///   Yeni Kay�t Ekle Buton ba�l��� i�in ButtonAdd
/// </example>
    procedure SetSession();
    procedure ResetSession(pPanelGroupboxPagecontrolTabsheet: TWinControl);
    procedure mniAboutClick(Sender: TObject);
    procedure btnSysPermissionSourceGroupClick(Sender: TObject);
    procedure btnSysPermissionSourceClick(Sender: TObject);
    procedure btnSysUserAccessRightClick(Sender: TObject);
    procedure btnSysLangClick(Sender: TObject);
    procedure btnSysGridColWidthClick(Sender: TObject);
    procedure btnSysGridColColorClick(Sender: TObject);
    procedure btnSysGridColPercentClick(Sender: TObject);
    procedure btnSysLangContentClick(Sender: TObject);
    procedure btnSysQualityFormNumberClick(Sender: TObject);
    procedure btnSysTableLangContentClick(Sender: TObject);
    procedure btnAyarStokHareketTipiClick(Sender: TObject);
    procedure btnStokHareketiClick(Sender: TObject);
    procedure btnSysDefaultOrderFilterClick(Sender: TObject);
    procedure mniAddLanguageContentClick(Sender: TObject);
    procedure btnSysUserClick(Sender: TObject);
    procedure btnAyarEFaturaFaturaTipiClick(Sender: TObject);
    procedure btnAyarFirmaTipiClick(Sender: TObject);
    procedure btnAyarEfaturaIletisimKanaliClick(Sender: TObject);
    procedure btnAyarEfaturaIstisnaKoduClick(Sender: TObject);
    procedure btnSysApplicationSettingsClick(Sender: TObject);
    procedure btnPersonelKartlariClick(Sender: TObject);
    procedure btnAyarPersonelBolumClick(Sender: TObject);
    procedure btnAyarPersonelBirimClick(Sender: TObject);
    procedure btnAyarPersonelGorevClick(Sender: TObject);
    procedure btnAyarVergiOraniClick(Sender: TObject);
    procedure btnHesapGrubuClick(Sender: TObject);
    procedure btnBolgeTuruClick(Sender: TObject);
    procedure btnAmbarlarClick(Sender: TObject);
    procedure btnOlcuBirimleriClick(Sender: TObject);
    procedure btnQualityFormMailRecieversClick(Sender: TObject);
    procedure mniCloseClick(Sender: TObject);
    procedure btnSysUserMacAddressExceptionsClick(Sender: TObject);
    procedure btnDovizKurlariClick(Sender: TObject);
    procedure btnBankalarClick(Sender: TObject);
    procedure btnBankaSubeleriClick(Sender: TObject);
    procedure btnUrunKabulRedNedenleriClick(Sender: TObject);
    procedure btnSysMultiLangDataTableListsClick(Sender: TObject);
    procedure btnStokTipiClick(Sender: TObject);
    procedure btnCinsAileleriClick(Sender: TObject);
    procedure btnCinsOzellikleriClick(Sender: TObject);
    procedure btnAyarHesapTipleriClick(Sender: TObject);
    procedure btnStokKartlariClick(Sender: TObject);
    procedure btnStokGrubuTurleriClick(Sender: TObject);
    procedure btnStokGruplariClick(Sender: TObject);
    procedure btnAyarBarkodUrunTuruClick(Sender: TObject);
    procedure btnAyarBarkodSeriNoTuruClick(Sender: TObject);
    procedure btnAyarBarkodHazirlikDosyaTurleriClick(Sender: TObject);
    procedure btnAyarBarkodTezgahlarClick(Sender: TObject);
    procedure btnServisClick(Sender: TObject);
    procedure btnTekliflerClick(Sender: TObject);
    procedure btnAyarTeklifDurumlarClick(Sender: TObject);
    procedure btnOdemeBaslangicDonemiClick(Sender: TObject);
    procedure btnTeklifTipleriClick(Sender: TObject);
    procedure btnAyarPersonelTipiClick(Sender: TObject);
    procedure btnAyarPersonelCinsiyetClick(Sender: TObject);
    procedure btnAyarPersonelAskerlikDurumuClick(Sender: TObject);
    procedure btnAyarPersonelRaporTipiClick(Sender: TObject);
    procedure btnAyarPersonelIzinTipiClick(Sender: TObject);
    procedure btnAyarPersonelMedeniDurumClick(Sender: TObject);
    procedure btnAyarPersonelDilClick(Sender: TObject);
    procedure btnAyarPersonelDilSeviyesiClick(Sender: TObject);
    procedure btnPersonelDilBilgileriClick(Sender: TObject);
    procedure btnAyarPersonelEhliyetTipiClick(Sender: TObject);
    procedure btnAyarPersonelMykTipiClick(Sender: TObject);
    procedure btnAyarPersonelSrcTipiClick(Sender: TObject);
    procedure btnAyarPersonelAyarilmaNedeniTipiClick(Sender: TObject);
    procedure btnAyarPersonelMektupTipiClick(Sender: TObject);
    procedure btnAyarPersonelTatilTipiClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnSysTaxpayerTypesClick(Sender: TObject);
    procedure btnHesapPlaniClick(Sender: TObject);
    procedure btnHesapKartlariClick(Sender: TObject);
    procedure btnBolgeClick(Sender: TObject);
    procedure btnAyarFirmaTuruClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure btnAracTakipAracClick(Sender: TObject);
    procedure btnMusteriTemsilciGruplariClick(Sender: TObject);
    procedure btnPersonelTasimaServisiClick(Sender: TObject);
    procedure btnEgitimSeviyeleriClick(Sender: TObject);
    procedure btnAyarStkUrunTipiClick(Sender: TObject);
    procedure btnAyarEFaturaKimlikSemasiClick(Sender: TObject);

  private
    procedure SetTitleFromLangContent(Sender: TControl = nil);
    procedure SetButtonPopup(Sender: TControl = nil);
  protected
  published
    procedure btnCloseClick(Sender: TObject); override;
    procedure FormKeyPress(Sender: TObject; var Key: Char);override;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);override;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
  public
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
    ufrmAbout
  , ufrmCalculator
  , ufrmSysLangGuiContent

  , Ths.Erp.Database.Table.PersonelKarti, ufrmPersonelKartlari
  , Ths.Erp.Database.Table.ParaBirimi, ufrmParaBirimleri
  , Ths.Erp.Database.Table.SysCountry, ufrmSysCountries
  , Ths.Erp.Database.Table.SysCity, ufrmSysCities
  , Ths.Erp.Database.Table.SysUserAccessRight, ufrmSysUserAccessRights
  , Ths.Erp.Database.Table.SysPermissionSourceGroup, ufrmSysPermissionSourceGroups
  , Ths.Erp.Database.Table.SysPermissionSource, ufrmSysPermissionSources
  , Ths.Erp.Database.Table.SysLang, ufrmSysLangs
  , Ths.Erp.Database.Table.SysLangGuiContent, ufrmSysLangGuiContents
  , Ths.Erp.Database.Table.SysGridColWidth, ufrmSysGridColWidths
  , Ths.Erp.Database.Table.SysGridColColor, ufrmSysGridColColors
  , Ths.Erp.Database.Table.SysGridColPercent, ufrmSysGridColPercents
  , Ths.Erp.Database.Table.SysLangDataContent, ufrmSysLangDataContents
  , Ths.Erp.Database.Table.SysQualityFormNumber, ufrmSysQualityFormNumbers
  , Ths.Erp.Database.Table.AyarStokHareketTipi, ufrmAyarStokHareketTipleri
  , Ths.Erp.Database.Table.StokHareketi, ufrmStokHareketleri
  , Ths.Erp.Database.Table.SysGridDefaultOrderFilter, ufrmSysGridDefaultOrderFilters
  , Ths.Erp.Database.Table.AyarEFaturaFaturaTipi, ufrmAyarEFaturaFaturaTipleri
  , Ths.Erp.Database.Table.AyarFirmaTuru, ufrmAyarFirmaTurleri
  , Ths.Erp.Database.Table.AyarFirmaTipi, ufrmAyarFirmaTipleri
  , Ths.Erp.Database.Table.AyarEFaturaIletisimKanali, ufrmAyarEFaturaIletisimKanallari
  , Ths.Erp.Database.Table.AyarEFaturaIstisnaKodu, ufrmAyarEFaturaIstisnaKodlari
  , Ths.Erp.Database.Table.SysApplicationSettings, ufrmSysApplicationSetting
  , Ths.Erp.Database.Table.AyarPrsBolum, ufrmAyarPrsBolumler
  , Ths.Erp.Database.Table.AyarPrsBirim, ufrmAyarPrsBirimler
  , Ths.Erp.Database.Table.AyarPrsGorev, ufrmAyarPrsGorevler
  , Ths.Erp.Database.Table.AyarVergiOrani, ufrmAyarVergiOranlari
  , Ths.Erp.Database.Table.Bolge, ufrmBolgeler
  , Ths.Erp.Database.Table.BolgeTuru, ufrmBolgeTurleri
  , Ths.Erp.Database.Table.HesapGrubu, ufrmHesapGruplari
  , Ths.Erp.Database.Table.Ambar, ufrmAmbarlar
  , Ths.Erp.Database.Table.OlcuBirimi, ufrmOlcuBirimleri
  , Ths.Erp.Database.Table.UrunKabulRedNedeni, ufrmUrunKabulRedNedenleri
  , Ths.Erp.Database.Table.QualityFormMailReciever, ufrmQualityFormMailRecievers
  , Ths.Erp.Database.Table.SysUserMacAddressException, ufrmSysUserMacAddressExceptions
  , Ths.Erp.Database.Table.DovizKuru, ufrmDovizKurlari
  , Ths.Erp.Database.Table.Banka, ufrmBankalar
  , Ths.Erp.Database.Table.BankaSubesi, ufrmBankaSubeleri
  , Ths.Erp.Database.Table.SysMultiLangDataTableList, ufrmSysMultiLangDataTableLists
  , Ths.Erp.Database.Table.AyarStkStokTipi, ufrmStokTipleri
  , Ths.Erp.Database.Table.AyarStkCinsAilesi, ufrmStokCinsAileleri
  , Ths.Erp.Database.Table.AyarStkCinsOzelligi, ufrmStokCinsOzellikleri
  , Ths.Erp.Database.Table.AyarHesapTipi, ufrmAyarHesapTipleri
  , Ths.Erp.Database.Table.StokKarti, ufrmStokKartlari
  , Ths.Erp.Database.Table.AyarStkStokGrubuTuru, ufrmStokGrubuTurleri
  , Ths.Erp.Database.Table.AyarStkStokGrubu, ufrmStokGruplari
  , Ths.Erp.Database.Table.AyarBarkodUrunTuru, ufrmAyarBarkodUrunTurleri
  , Ths.Erp.Database.Table.AyarBarkodHazirlikDosyaTuru, ufrmAyarBarkodHazirlikDosyaTurleri
  , Ths.Erp.Database.Table.AyarBarkodSeriNoTuru, ufrmAyarBarkodSeriNoTurleri
  , Ths.Erp.Database.Table.AyarBarkodTezgah, ufrmAyarBarkodTezgahlar
  , Ths.Erp.Database.Table.SatisTeklif, ufrmSatisTeklifler
  , Ths.Erp.Database.Table.AyarTeklifDurum, ufrmAyarTeklifDurumlar
  , Ths.Erp.Database.Table.AyarTeklifTipi, ufrmAyarTeklifTipleri
  , Ths.Erp.Database.Table.AyarOdemeBaslangicDonemi, ufrmAyarOdemeBaslangicDonemleri
  , Ths.Erp.Database.Table.AyarPrsPersonelTipi, ufrmAyarPrsPersonelTipleri
  , Ths.Erp.Database.Table.AyarPrsCinsiyet, ufrmAyarPrsCinsiyetler
  , Ths.Erp.Database.Table.AyarPrsAskerlikDurumu, ufrmAyarPrsAskerlikDurumlari
  , Ths.Erp.Database.Table.AyarPrsRaporTipi, ufrmAyarPrsRaporTipleri
  , Ths.Erp.Database.Table.AyarPrsIzinTipi, ufrmAyarPrsIzinTipleri
  , Ths.Erp.Database.Table.AyarPrsMedeniDurum, ufrmAyarPrsMedeniDurumlar
  , Ths.Erp.Database.Table.AyarPrsYabanciDil, ufrmAyarPrsYabanciDiller
  , Ths.Erp.Database.Table.AyarPrsYabanciDilSeviyesi, ufrmAyarPrsYabanciDilSeviyeleri
  , Ths.Erp.Database.Table.PersonelDilBilgisi, ufrmPersonelDilBilgileri
  , Ths.Erp.Database.Table.AyarPrsEhliyetTipi, ufrmAyarPrsEhliyetTipleri
  , Ths.Erp.Database.Table.AyarPrsMykTipi, ufrmAyarPrsMykTipleri
  , Ths.Erp.Database.Table.AyarPrsSrcTipi, ufrmAyarPrsSrcTipleri
  , Ths.Erp.Database.Table.AyarPrsAyrilmaNedeni, ufrmAyarPrsAyrilmaNedenleri
  , Ths.Erp.Database.Table.AyarPrsMektupTipi, ufrmAyarPrsMektupTipleri
  , Ths.Erp.Database.Table.AyarPrsTatilTipi, ufrmAyarPrsTatilTipleri
  , Ths.Erp.Database.Table.SysTaxpayerType, ufrmSysTaxpayerTypes
  , Ths.Erp.Database.Table.HesapPlani, ufrmHesapPlanlari
  , Ths.Erp.Database.Table.HesapKarti, ufrmHesapKartlari
  , Ths.Erp.Database.Table.Arac.Arac, ufrmAracTakipAraclar
  , Ths.Erp.Database.Table.MusteriTemsilciGrubu, ufrmMusteriTemsilciGruplari
  , Ths.Erp.Database.Table.PersonelTasimaServisi, ufrmPersonelTasimaServisleri
  , Ths.Erp.Database.Table.AyarPrsEgitimSeviyesi, ufrmAyarPrsEgitimSeviyeleri
  , Ths.Erp.Database.Table.AyarStkUrunTipi, ufrmAyarStkUrunTipleri
  , Ths.Erp.Database.Table.AyarEFaturaKimlikSemasi, ufrmAyarEFaturaKimlikSemalari
  ;

procedure TfrmMain.AppEvntsBaseIdle(Sender: TObject; var Done: Boolean);
begin
  inherited;
  //
end;

procedure TfrmMain.btnSysCitiesClick(Sender: TObject);
begin
  TfrmSysCities.Create(Self, Self, TSysCity.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnServisClick(Sender: TObject);
{$IFDEF MIGRATE}
var
  vID: Integer;
  vOld: TFDQuery;
  vCon: TFDConnection;
  vStokGrubuTuru: TAyarStkStokGrubuTuru;
  vStokGrubu: TAyarStkStokGrubu;
  vKDV: TAyarVergiOrani;
  vStokKarti, vStokKarti2: TStokKarti;
  vOlcuBirimi: TOlcuBirimi;
  vStokTipi: TAyarStkStokTipi;
  vSysCountry: TSysCountry;
  vCins: TAyarStkCinsOzelligi;
{$ENDIF}
begin
{$IFDEF MIGRATE}
  vCon := TSingletonDB.GetInstance.DataBase.NewConnection;
  if vCon.Connected then
    vCon.Close;
  vCon.Name := 'ConnectionMigrate';
  vCon.Params.Clear;
  vCon.Params.Add('DriverID=PG');
  vCon.Params.Add('CharacterSet=UTF8');
  vCon.Params.Add('Server=' + '192.168.20.213');
  vCon.Params.Add('Database=' + 'elektromed_as');
  vCon.Params.Add('User_Name=' + 'guest');
  vCon.Params.Add('Password=' + '123');
  vCon.Params.Add('Port=' + '5432');
  vCon.Params.Add('ApplicationName=' + 'THS ERP Framework Migrate');
  vCon.LoginPrompt := False;
  vCon.Open;

  vOld := TSingletonDB.GetInstance.DataBase.NewQuery(vCon);

  vStokGrubuTuru := TAyarStkStokGrubuTuru.Create(TSingletonDB.GetInstance.DataBase);
  vStokGrubu := TAyarStkStokGrubu.Create(TSingletonDB.GetInstance.DataBase);
  vKDV := TAyarVergiOrani.Create(TSingletonDB.GetInstance.DataBase);
  vStokKarti := TStokKarti.Create(TSingletonDB.GetInstance.DataBase);
  vStokKarti2 := TStokKarti.Create(TSingletonDB.GetInstance.DataBase);
  vOlcuBirimi := TOlcuBirimi.Create(TSingletonDB.GetInstance.DataBase);
  vStokTipi := TAyarStkStokTipi.Create(TSingletonDB.GetInstance.DataBase);
  vSysCountry := TSysCountry.Create(TSingletonDB.GetInstance.DataBase);
  vCins := TAyarStkCinsOzelligi.Create(TSingletonDB.GetInstance.DataBase);
  try
    vStokGrubuTuru.Database.Connection.StartTransaction;
    //buras� stok grubu turlerini getirir
{    vOld.Close;
    vOld.SQL.Clear;
    vOld.SQL.Text := 'SELECT tur FROM mal_grubu_turleri ORDER BY tur ASC';
    vOld.Open;
    vOld.First;

    pb1.Max := vOld.RecordCount;
    pb1.Step := 1;
    pb1.Position := 1;
    pb1.Enabled := True;

    while not vOld.Eof do
    begin
      if not vOld.Fields.Fields[0].IsNull then
      begin
        vStokGrubuTuru.Clear;
        vStokGrubuTuru.Tur.Value := vOld.Fields.Fields[0].AsString;
        vStokGrubuTuru.Insert(vID, False);
      end;

      vOld.Next;
      pb1.Position := pb1.Position + 1;
    end;
}

    //buras� stok gruplar�n� getirir
    vOld.Close;
    vOld.SQL.Clear;
    vOld.SQL.Text :=
      'SELECT grup, alim_hesabi, satim_hesabi, hammadde_hesabi, mamul_hesabi, kdv, tur, ' +
        'iskonto_aktif, satis_iskontosu, mudur_iskontosu, satis_fiyatini_kullan, yarimamul_hesabi, ' +
        'is_maliyet_analizde_diger_db_kullan ' +
      'FROM mal_gruplari ORDER BY grup ASC';
    vOld.Open;
    vOld.First;

    pb1.Max := vOld.RecordCount;
    pb1.Step := 1;
    pb1.Position := 1;
    pb1.Enabled := True;

    while not vOld.Eof do
    begin
      if not vOld.Fields.Fields[0].IsNull then
      begin
        vKDV.SelectToList(' and ' + vKDV.VergiOrani.FieldName + '=' + QuotedStr(vOld.Fields.Fields[5].AsString), False, False);
        vStokGrubuTuru.SelectToList(' and ' + vStokGrubuTuru.StokGrubuTur.FieldName + '=' + QuotedStr(vOld.Fields.Fields[6].AsString), False, False);

        vStokGrubu.Clear;
        vStokGrubu.AyarStkStokGrubuTuruID.Value := vStokGrubuTuru.Id.Value;
        vStokGrubu.Grup.Value := vOld.Fields.Fields[0].AsString;
        vStokGrubu.AlisHesabi.Value := vOld.Fields.Fields[1].AsString;
        vStokGrubu.SatisHesabi.Value := vOld.Fields.Fields[2].AsString;
        vStokGrubu.HammaddeHesabi.Value := vOld.Fields.Fields[3].AsString;
        vStokGrubu.MamulHesabi.Value := vOld.Fields.Fields[4].AsString;
        vStokGrubu.KDVOrani.Value := vKDV.Id.Value;
        vStokGrubu.IsIskontoAktif.Value := vOld.Fields.Fields[7].AsBoolean;
        vStokGrubu.IskontoSatis.Value := vOld.Fields.Fields[8].AsFloat;
        vStokGrubu.IskontoMudur.Value := vOld.Fields.Fields[9].AsFloat;
        vStokGrubu.IsSatisFiyatiniKullan.Value := vOld.Fields.Fields[10].AsBoolean;
        vStokGrubu.IsMaliyetAnalizFarkliDB.Value := vOld.Fields.Fields[12].AsBoolean;
        vStokGrubu.Insert(vID, False);
      end;

      vOld.Next;
      pb1.Position := pb1.Position + 1;
    end;


    //buras� stok kart�lar�n� getirir
    vOld.Close;
    vOld.SQL.Clear;
    vOld.SQL.Text :=
      'SELECT ' +
        'mal_kodu, mal_adi, grup, olcu_birimi, alis_iskonto, stok_tipi, ' +
        'ham_alis_fiyati, ham_alis_para_birimi, alis, alis_para_birimi, ' +
        'satis, satis_para_birimi, ihrac_fiyati, ihrac_para_birimi, ortalama_maliyet, ' +
        'default_recete_id, en, boy, yukseklik, mensei, gtip_no, ' +
        'diib_urun_tanimi, esik_deger, tanim, ozel, marka, ' +
        'agirlik, kapasite, cins, string_degisken1, string_degisken2, ' +
        'string_degisken3, string_degisken4, string_degisken5, string_degisken6, ' +
        'integer_degisken1, integer_degisken2, integer_degisken3, double_degisken1, ' +
        'double_degisken2, double_degisken3, is_teklif_siparis_alinabilir, is_ana_urun, ' +
        'is_yari_mamul, is_otomatik_uretim_urunu, is_aybey_ozet_urun, lot_parti_miktari, ' +
        'paket_miktari, serino_turu, is_harici_serino_icerir, harici_serino_mal_kodu, ' +
        'tasiyici_paket_id, onceki_donem_cikan, temin_suresi, ' +
        'stock_name, en_string_degisken1, en_string_degisken2, en_string_degisken3, ' +
        'en_string_degisken4, en_string_degisken5, en_string_degisken6 ' +
      'FROM mallar ORDER BY mal_kodu ASC';
    vOld.Open;
    vOld.First;

    pb1.Max := vOld.RecordCount;
    pb1.Step := 1;
    pb1.Position := 1;
    pb1.Enabled := True;

    while not vOld.Eof do
    begin
      if not vOld.Fields.Fields[0].IsNull then
      begin
        vStokGrubu.SelectToList(' and ' + vStokGrubu.Grup.FieldName + '=' + QuotedStr(vOld.Fields.Fields[2].AsString), False, False);
        vOlcuBirimi.SelectToList(' and ' + vOlcuBirimi.Birim.FieldName + '=' + QuotedStr(vOld.Fields.Fields[3].AsString), False, False);
        vStokTipi.SelectToList(' and ' + vStokTipi.Tip.FieldName + '=' + QuotedStr(vOld.Fields.Fields[5].AsString), False, False);
        vSysCountry.SelectToList(' and ' + vSysCountry.CountryName.FieldName + '=' + QuotedStr(vOld.Fields.Fields[19].AsString), False, False);
        vCins.SelectToList(' and ' + vCins.Cins.FieldName + '=' + QuotedStr(vOld.Fields.Fields[28].AsString), False, False);

        vStokKarti.StokKodu.Value := vOld.Fields.Fields[0].AsString;
        vStokKarti.StokAdi.Value := vOld.Fields.Fields[1].AsString;
        if vStokGrubu.Id.Value > 0 then
          vStokKarti.StokGrubuID.Value := vStokGrubu.Id.Value
        else
          vStokKarti.StokGrubuID.Value := 0;

        if vOlcuBirimi.Id.Value > 0 then
          vStokKarti.OlcuBirimiID.Value := vOlcuBirimi.Id.Value
        else
          vStokKarti.OlcuBirimiID.Value := 0;

        vStokKarti.AlisIskonto.Value := vOld.Fields.Fields[4].AsFloat;
        vStokKarti.SatisIskonto.Value := 0.0;
        vStokKarti.YetkiliIskonto.Value := 0.0;

        if vStokTipi.Id.Value > 0 then
          vStokKarti.StokTipiID.Value := vStokTipi.Id.Value
        else
          vStokKarti.StokTipiID.Value := 0;
        vStokKarti.HamAlisFiyat.Value := vOld.Fields.Fields[6].AsFloat;
        vStokKarti.HamAlisParaBirimi.Value := vOld.Fields.Fields[7].AsString;
        vStokKarti.AlisFiyat.Value := vOld.Fields.Fields[8].AsFloat;
        vStokKarti.AlisParaBirimi.Value := vOld.Fields.Fields[9].AsString;
        vStokKarti.SatisFiyat.Value := vOld.Fields.Fields[10].AsFloat;
        vStokKarti.SatisParaBirimi.Value := vOld.Fields.Fields[11].AsString;
        vStokKarti.IhracFiyat.Value := vOld.Fields.Fields[12].AsFloat;
        vStokKarti.IhracParaBirimi.Value := vOld.Fields.Fields[13].AsString;
        vStokKarti.OrtalamaMaliyet.Value := vOld.Fields.Fields[14].AsFloat;
        vStokKarti.VarsayilaReceteID.Value := vOld.Fields.Fields[15].AsInteger;
        vStokKarti.En.Value := vOld.Fields.Fields[16].AsFloat;
        vStokKarti.Boy.Value := vOld.Fields.Fields[17].AsFloat;
        vStokKarti.Yukseklik.Value := vOld.Fields.Fields[18].AsFloat;
        if vSysCountry.Id.Value > 0 then
          vStokKarti.MenseiID.Value := vSysCountry.Id.Value
        else
          vStokKarti.MenseiID.Value := 0;
        vStokKarti.GtipNo.Value := vOld.Fields.Fields[20].AsString;
        vStokKarti.DiibUrunTanimi.Value := vOld.Fields.Fields[21].AsString;
        vStokKarti.EnAzStokSeviyesi.Value := vOld.Fields.Fields[22].AsFloat;
        vStokKarti.Tanim.Value := vOld.Fields.Fields[23].AsString;
        vStokKarti.OzelKod.Value := vOld.Fields.Fields[24].AsString;
        vStokKarti.Marka.Value := vOld.Fields.Fields[25].AsString;
        vStokKarti.Agirlik.Value := vOld.Fields.Fields[26].AsFloat;
        vStokKarti.Kapasite.Value := vOld.Fields.Fields[27].AsFloat;
        if vCins.Id.Value > 0 then
          vStokKarti.CinsID.Value := vCins.Id.Value
        else
          vStokKarti.CinsID.Value := 0;
        vStokKarti.StringDegisken1.Value := vOld.Fields.Fields[29].AsString;
        vStokKarti.StringDegisken2.Value := vOld.Fields.Fields[30].AsString;
        vStokKarti.StringDegisken3.Value := vOld.Fields.Fields[31].AsString;
        vStokKarti.StringDegisken4.Value := vOld.Fields.Fields[32].AsString;
        vStokKarti.StringDegisken5.Value := vOld.Fields.Fields[33].AsString;
        vStokKarti.StringDegisken6.Value := vOld.Fields.Fields[34].AsString;
        vStokKarti.IntegerDegisken1.Value := vOld.Fields.Fields[35].AsInteger;
        vStokKarti.IntegerDegisken2.Value := vOld.Fields.Fields[36].AsInteger;
        vStokKarti.IntegerDegisken3.Value := vOld.Fields.Fields[37].AsInteger;
        vStokKarti.DoubleDegisken1.Value := vOld.Fields.Fields[38].AsFloat;
        vStokKarti.DoubleDegisken2.Value := vOld.Fields.Fields[39].AsFloat;
        vStokKarti.DoubleDegisken3.Value := vOld.Fields.Fields[40].AsFloat;

        vStokKarti.IsSatilabilir.Value := vOld.Fields.Fields[41].AsBoolean;
//        vStokKarti.IsAnaUrun.Value := vOld.Fields.Fields[42].AsBoolean;
//        vStokKarti.IsYariMamul.Value := vOld.Fields.Fields[43].AsBoolean;
        vStokKarti.IsOtomatikUretimUrunu.Value := vOld.Fields.Fields[44].AsBoolean;
//        vStokKarti.IsOzetUrun.Value := vOld.Fields.Fields[45].AsBoolean;
        vStokKarti.LotPartiMiktari.Value := vOld.Fields.Fields[46].AsFloat;
        vStokKarti.PaketMiktari.Value := vOld.Fields.Fields[47].AsFloat;
        vStokKarti.SeriNoTuru.Value := vOld.Fields.Fields[48].AsString;

        vStokKarti.IsHariciSeriNoIcerir.Value := vOld.Fields.Fields[49].AsBoolean;
        vStokKarti.HariciSeriNoStokKoduID.Value := 0;
        vStokKarti.TasiyiciPaketID.Value := 0;
        vStokKarti.OncekiDonemCikanMiktar.Value := vOld.Fields.Fields[52].AsFloat;
        vStokKarti.TeminSuresi.Value := vOld.Fields.Fields[53].AsInteger;

        vStokKarti.StockName.Value := vOld.Fields.Fields[54].AsString;
        vStokKarti.EnStringDegisken1.Value := vOld.Fields.Fields[55].AsString;
        vStokKarti.EnStringDegisken2.Value := vOld.Fields.Fields[56].AsString;
        vStokKarti.EnStringDegisken3.Value := vOld.Fields.Fields[57].AsString;
        vStokKarti.EnStringDegisken4.Value := vOld.Fields.Fields[58].AsString;
        vStokKarti.EnStringDegisken5.Value := vOld.Fields.Fields[59].AsString;
        vStokKarti.EnStringDegisken6.Value := vOld.Fields.Fields[60].AsString;

        vStokKarti.Insert(vID);

        vOld.Next;
        pb1.Position := pb1.Position + 1;
      end;
    end;

    //buras� stok kart�lar�n� getirir
    vOld.Close;
    vOld.SQL.Clear;
    vOld.SQL.Text :=
      'SELECT ' +
        'mal_kodu, harici_serino_mal_kodu ' +
      'FROM mallar WHERE harici_serino_mal_kodu is not null ORDER BY mal_kodu ASC';
    vOld.Open;
    vOld.First;

    pb1.Max := vOld.RecordCount;
    pb1.Step := 1;
    pb1.Position := 1;
    pb1.Enabled := True;

    while not vOld.Eof do
    begin
      if not vOld.Fields.Fields[0].IsNull then
      begin
        //harici serino mal kodu i�in id bilgisi bulunacak
        vStokKarti2.SelectToList(' and ' + vStokKarti2.StokKodu.FieldName + '=' + QuotedStr(vOld.Fields.Fields[1].AsString), False, False);
        //normal stok kart� �ekilecek ve hariciserino id bilgisi g�ncellenecek
        vStokKarti.SelectToList(' and ' + vStokKarti.StokKodu.FieldName + '=' + QuotedStr(vOld.Fields.Fields[0].AsString), False, False);
        vStokKarti.HariciSeriNoStokKoduID.Value := vStokKarti2.Id.Value;
        vStokKarti.Update(False);
      end;
      vOld.Next;
      pb1.Position := pb1.Position + 1;
    end;

    vStokGrubuTuru.Database.Connection.Commit;
  finally
    vOld.Free;
    vCon.Close;
    vCon.Free;
    vStokGrubuTuru.Free;
    vStokGrubu.Free;
    vKDV.Free;
    vStokKarti.Free;
    vStokKarti2.Free;
    vOlcuBirimi.Free;
    vStokTipi.Free;
    vSysCountry.Free;
    vCins.Free;
  end;
{$ENDIF}
end;

procedure TfrmMain.btnAyarStokHareketTipiClick(Sender: TObject);
begin
  TfrmAyarStokHareketTipleri.Create(Self, Self,
      TAyarStokHareketTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarTeklifDurumlarClick(Sender: TObject);
begin
  TfrmAyarTeklifDurumlar.Create(Self, Self, TAyarTeklifDurum.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarVergiOraniClick(Sender: TObject);
begin
  TfrmAyarVergiOranlari.Create(Self, Self, TAyarVergiOrani.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnBankalarClick(Sender: TObject);
begin
  TfrmBankalar.Create(Self, Self, TBanka.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnBankaSubeleriClick(Sender: TObject);
begin
  TfrmBankaSubeleri.Create(Self, Self, TBankaSubesi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnBolgeClick(Sender: TObject);
begin
  TfrmBolgeler.Create(Self, Self, TBolge.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnBolgeTuruClick(Sender: TObject);
begin
  TfrmBolgeTurleri.Create(Self, Self, TBolgeTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnCinsAileleriClick(Sender: TObject);
begin
  TfrmStokCinsAileleri.Create(Self, Self, TAyarStkCinsAilesi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnCinsOzellikleriClick(Sender: TObject);
begin
  TfrmStokCinsOzellikleri.Create(Self, Self, TAyarStkCinsOzelligi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  if CustomMsgDlg(
    TranslateText('Application terminated. Are you sure you want close application?', FrameworkLang.MessageApplicationTerminate, LngMsgData, LngSystem),
    mtConfirmation, mbYesNo, [TranslateText('Yes', FrameworkLang.GeneralYesLower, LngGeneral, LngSystem),
                              TranslateText('No', FrameworkLang.GeneralNoLower, LngGeneral, LngSystem)], mbNo,
                              TranslateText('Confirmation', FrameworkLang.GeneralConfirmationLower, LngGeneral, LngSystem)) = mrYes
  then
    inherited;
end;

procedure TfrmMain.btnDovizKurlariClick(Sender: TObject);
begin
  TfrmDovizKurlari.Create(Self, Self, TDovizKuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnEgitimSeviyeleriClick(Sender: TObject);
begin
  TfrmAyarPrsEgitimSeviyeleri.Create(Application, Self, TAyarPrsEgitimSeviyesi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnHesapGrubuClick(Sender: TObject);
begin
  TfrmHesapGruplari.Create(Self, Self, THesapGrubu.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnHesapKartlariClick(Sender: TObject);
begin
  TfrmHesapKartlari.Create(Application, Self, THesapKarti.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnHesapPlaniClick(Sender: TObject);
begin
  TfrmHesapPlanlari.Create(Self, Self, THesapPlani.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnMusteriTemsilciGruplariClick(Sender: TObject);
begin
  TfrmMusteriTemsilciGruplari.Create(Self, Self, TMusteriTemsilciGrubu.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnOdemeBaslangicDonemiClick(Sender: TObject);
begin
  TfrmAyarOdemeBaslangicDonemleri.Create(Self, Self, TAyarOdemeBaslangicDonemi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnOlcuBirimleriClick(Sender: TObject);
begin
  TfrmOlcuBirimleri.Create(Self, Self, TOlcuBirimi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAmbarlarClick(Sender: TObject);
begin
  TfrmAmbarlar.Create(Self, Self, TAmbar.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAracTakipAracClick(Sender: TObject);
begin
  TfrmAracTakipAraclar.Create(Self, Self, TArac.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelAskerlikDurumuClick(Sender: TObject);
begin
  TfrmAyarPrsAskerlikDurumlari.Create(Self, Self, TAyarPrsAskerlikDurumu.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelAyarilmaNedeniTipiClick(Sender: TObject);
begin
  TfrmAyarPrsAyrilmaNedenleri.Create(Self, Self, TAyarPrsAyrilmaNedeni.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarBarkodHazirlikDosyaTurleriClick(Sender: TObject);
begin
  TfrmAyarBarkodHazirlikDosyaTurleri.Create(Self, Self, TAyarBarkodHazirlikDosyaTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarBarkodSeriNoTuruClick(Sender: TObject);
begin
  TfrmAyarBarkodSeriNoTurleri.Create(Self, Self, TAyarBarkodSeriNoTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarBarkodTezgahlarClick(Sender: TObject);
begin
  TfrmAyarBarkodTezgahlar.Create(Self, Self, TAyarBarkodTezgah.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarBarkodUrunTuruClick(Sender: TObject);
begin
  TfrmAyarBarkodUrunTurleri.Create(Self, Self, TAyarBarkodUrunTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelCinsiyetClick(Sender: TObject);
begin
  TfrmAyarPrsCinsiyetler.Create(Self, Self, TAyarPrsCinsiyet.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelDilClick(Sender: TObject);
begin
  TfrmAyarPrsYabanciDilleri.Create(Self, Self, TAyarPrsYabanciDil.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelDilSeviyesiClick(Sender: TObject);
begin
  TfrmAyarPrsYabanciDilSeviyeleri.Create(Self, Self, TAyarPrsYabanciDilSeviyesi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelEhliyetTipiClick(Sender: TObject);
begin
  TfrmAyarPrsEhliyetTipleri.Create(Self, Self, TAyarPrsEhliyetTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarEFaturaFaturaTipiClick(Sender: TObject);
begin
  TfrmAyarEFaturaFaturaTipleri.Create(Self, Self, TAyarEFaturaFaturaTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarEfaturaIletisimKanaliClick(Sender: TObject);
begin
  TfrmAyarEFaturaIletisimKanallari.Create(Self, Self, TAyarEFaturaIletisimKanali.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarEfaturaIstisnaKoduClick(Sender: TObject);
begin
  TfrmAyarEFaturaIstisnaKodlari.Create(Self, Self, TAyarEFaturaIstisnaKodu.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarEFaturaKimlikSemasiClick(Sender: TObject);
begin
  TfrmAyarEFaturaKimlikSemalari.Create(Self, Self, TAyarEFaturaKimlikSemasi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarFirmaTipiClick(Sender: TObject);
begin
  TfrmAyarFirmaTipleri.Create(Self, Self, TAyarFirmaTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarFirmaTuruClick(Sender: TObject);
begin
  TfrmAyarFirmaTurleri.Create(Self, Self, TAyarFirmaTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarHesapTipleriClick(Sender: TObject);
begin
  TfrmAyarHesapTipleri.Create(Self, Self, TAyarHesapTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysTaxpayerTypesClick(Sender: TObject);
begin
  TfrmSysTaxPayerTypes.Create(Self, Self, TSysTaxpayerType.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelMedeniDurumClick(Sender: TObject);
begin
  TfrmAyarPrsMedeniDurumlar.Create(Self, Self, TAyarPrsMedeniDurum.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelMektupTipiClick(Sender: TObject);
begin
  TfrmAyarPrsMektupTipleri.Create(Self, Self, TAyarPrsMektupTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelMykTipiClick(Sender: TObject);
begin
  TfrmAyarPrsMykTipleri.Create(Self, Self, TAyarPrsMykTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelRaporTipiClick(Sender: TObject);
begin
  TfrmAyarPrsRaporTipleri.Create(Self, Self, TAyarPrsRaporTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelSrcTipiClick(Sender: TObject);
begin
  TfrmAyarPrsSrcTipleri.Create(Self, Self, TAyarPrsSrcTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelBirimClick(Sender: TObject);
begin
  TfrmAyarPrsBirimler.Create(Self, Self, TAyarPrsBirim.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelBolumClick(Sender: TObject);
begin
  TfrmAyarPrsBolumler.Create(Self, Self, TAyarPrsBolum.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelGorevClick(Sender: TObject);
begin
  TfrmAyarPrsGorevler.Create(Self, Self, TAyarPrsGorev.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelIzinTipiClick(Sender: TObject);
begin
  TfrmAyarPrsIzinTipleri.Create(Self, Self, TAyarPrsIzinTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelTatilTipiClick(Sender: TObject);
begin
  TfrmAyarPrsTatilTipleri.Create(Self, Self, TAyarPrsTatilTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarPersonelTipiClick(Sender: TObject);
begin
  TfrmAyarPrsPersonelTipleri.Create(Self, Self, TAyarPrsPersonelTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysUserClick(Sender: TObject);
begin
  //
end;

procedure TfrmMain.btnSysUserMacAddressExceptionsClick(Sender: TObject);
begin
  TfrmSysUserMacAddressExceptions.Create(Self, Self, TSysUserMacAddressException.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnTekliflerClick(Sender: TObject);
begin
  TfrmSatisTeklifler.Create(Application, Self, TSatisTeklif.Create(TSingletonDB.GetInstance.DataBase), True, ifmNewRecord, fomSatis).Show;
end;

procedure TfrmMain.btnTeklifTipleriClick(Sender: TObject);
begin
  TfrmAyarTeklifTipleri.Create(Self, Self, TAyarTeklifTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysCountriesClick(Sender: TObject);
begin
  TfrmSysCountries.Create(Self, Self, TSysCountry.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnUrunKabulRedNedenleriClick(Sender: TObject);
begin
  TfrmUrunKabulRedNedenleri.Create(Self, Self, TUrunKabulRedNedeni.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnAyarStkUrunTipiClick(Sender: TObject);
begin
  TfrmAyarStkUrunTipleri.Create(Self, Self, TAyarStkUrunTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  TfrmCalculator.Create(Owner).Show;
end;

procedure TfrmMain.btnParaBirimleriClick(Sender: TObject);
begin
  TfrmParaBirimleri.Create(Self, Self, TParaBirimi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnPersonelDilBilgileriClick(Sender: TObject);
begin
  TfrmPersonelDilBilgileri.Create(Self, Self, TPersonelDilBilgisi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnPersonelKartlariClick(Sender: TObject);
begin
  TfrmPersonelKartlari.Create(Self, Self, TPersonelKarti.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnPersonelTasimaServisiClick(Sender: TObject);
begin
  TfrmPersonelTasimaServisleri.Create(Self, Self, TPersonelTasimaServis.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnQualityFormMailRecieversClick(Sender: TObject);
begin
  TfrmQualityFormMailRecievers.Create(Self, Self, TQualityFormMailReciever.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysApplicationSettingsClick(Sender: TObject);
var
  vApplicationSetting: TSysApplicationSettings;
begin
  vApplicationSetting := TSysApplicationSettings.Create(TSingletonDB.GetInstance.DataBase);
  vApplicationSetting.SelectToList('', False);
  if vApplicationSetting.List.Count = 0 then
  begin
    vApplicationSetting.Clear;
    TfrmSysApplicationSetting.Create(Self, nil, vApplicationSetting, True, ifmNewRecord).ShowModal
  end
  else if vApplicationSetting.List.Count = 1 then
  begin
    TfrmSysApplicationSetting.Create(Self, nil, vApplicationSetting, True, ifmRewiev).ShowModal;
  end;
end;

procedure TfrmMain.btnSysDefaultOrderFilterClick(Sender: TObject);
begin
  TfrmSysGridDefaultOrderFilters.Create(Self, Self, TSysGridDefaultOrderFilter.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysGridColColorClick(Sender: TObject);
begin
  TfrmSysGridColColors.Create(Self, Self, TSysGridColColor.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysGridColPercentClick(Sender: TObject);
begin
  TfrmSysGridColPercents.Create(Self, Self, TSysGridColPercent.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysGridColWidthClick(Sender: TObject);
begin
  TfrmSysGridColWidths.Create(Self, Self, TSysGridColWidth.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysPermissionSourceClick(Sender: TObject);
begin
  TfrmSysPermissionSources.Create(Self, Self, TSysPermissionSource.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysPermissionSourceGroupClick(Sender: TObject);
begin
  TfrmSysPermissionSourceGroups.Create(Self, Self, TSysPermissionSourceGroup.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysQualityFormNumberClick(Sender: TObject);
begin
  TfrmSysQualityFormNumbers.Create(Self, Self, TSysQualityFormNumber.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysTableLangContentClick(Sender: TObject);
begin
  TfrmSysLangDataContents.Create(Self, Self, TSysLangDataContent.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysLangClick(Sender: TObject);
begin
  TfrmSysLangs.Create(Self, Self, TSysLang.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysLangContentClick(Sender: TObject);
begin
  TfrmSysLangGuiContents.Create(Self, Self, TSysLangGuiContent.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysMultiLangDataTableListsClick(Sender: TObject);
begin
  TfrmSysMultiLangDataTableLists.Create(Self, Self, TSysMultiLangDataTableList.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnSysUserAccessRightClick(Sender: TObject);
begin
  TfrmSysUserAccessRights.Create(Self, Self, TSysUserAccessRight.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.SetTitleFromLangContent(Sender: TControl);
var
  n1: Integer;
begin
  //Ana formdaki butonlar�n isimleri �u formata uygun olacak. btn + herhangi bir isim btnCity veya btncity
  //dil dosyas�na bakarken de "ButonCaption.Main.city" �eklinde olacak
  if Sender = nil then
  begin
    Sender := pnlMain;
    SetTitleFromLangContent(Sender);
  end;


  for n1 := 0 to TWinControl(Sender).ControlCount-1 do
  begin
    if TWinControl(Sender).Controls[n1].ClassType = TPageControl then
      SetTitleFromLangContent(TWinControl(Sender).Controls[n1])
    else if TWinControl(Sender).Controls[n1].ClassType = TTabSheet then
    begin
      TTabSheet(TWinControl(Sender).Controls[n1]).Caption :=
        TranslateText(
          TTabSheet(TWinControl(Sender).Controls[n1]).Caption,
          StringReplace(TTabSheet(TWinControl(Sender).Controls[n1]).Name, PREFIX_TABSHEET, '', [rfReplaceAll]),
          LngTab, LngMainTable
        );
      SetTitleFromLangContent(TWinControl(Sender).Controls[n1])
    end
    else if TWinControl(Sender).Controls[n1].ClassType = TButton then
    begin
      TButton(TWinControl(Sender).Controls[n1]).Caption :=
          TranslateText(
              TButton(TWinControl(Sender).Controls[n1]).Caption,
              StringReplace(TButton(TWinControl(Sender).Controls[n1]).Name, PREFIX_BUTTON, '', [rfReplaceAll]),
              LngButton, LngMainTable
          );
    end;
  end;

end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmMain.SetButtonPopup(Sender: TControl = nil);
var
  n1: Integer;
begin
  if Sender = nil then
  begin
    Sender := pnlMain;
    SetButtonPopup(Sender);
  end;


  for n1 := 0 to TWinControl(Sender).ControlCount-1 do
  begin
    if TWinControl(Sender).Controls[n1].ClassType = TPageControl then
      SetButtonPopup(TWinControl(Sender).Controls[n1])
    else if TWinControl(Sender).Controls[n1].ClassType = TTabSheet then
    begin
      TTabSheet(TWinControl(Sender).Controls[n1]).PopupMenu := pmButtons;
      SetButtonPopup(TWinControl(Sender).Controls[n1])
    end
    else if TWinControl(Sender).Controls[n1].ClassType = TButton then
    begin
      TButton(TWinControl(Sender).Controls[n1]).PopupMenu := pmButtons;
    end;
  end;

end;

procedure TfrmMain.btnStokGrubuTurleriClick(Sender: TObject);
begin
  TfrmStokGrubuTurleri.Create(Self, Self, TAyarStkStokGrubuTuru.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnStokGruplariClick(Sender: TObject);
begin
  TfrmStokGruplari.Create(Self, Self, TAyarStkStokGrubu.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnStokHareketiClick(Sender: TObject);
begin
  TfrmStokHareketleri.Create(Self, Self, TStokHareketi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnStokKartlariClick(Sender: TObject);
begin
  TfrmStokKartlari.Create(Self, Self, TStokKarti.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

procedure TfrmMain.btnStokTipiClick(Sender: TObject);
begin
  TfrmStokTipleri.Create(Self, Self, TAyarStkStokTipi.Create(TSingletonDB.GetInstance.DataBase), True).Show;
end;

destructor TfrmMain.Destroy;
begin
  if stbBase.Panels.Count > 0 then
  begin
    repeat
      stbBase.Panels.Items[stbBase.Panels.Count-1].Free;
    until (stbBase.Panels.Count = 0);
  end;
  stbBase.Free;

  TSingletonDB.GetInstance.Free;

  inherited;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  inherited;
  Application.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;

  TVclStylesSystemMenu.Create(Self);
  btnClose.Visible := True;
  pnlBottom.Visible := False;
  stbBase.Visible := True;
  pnlBottom.Visible := True;

  pmButtons.Images := TSingletonDB.GetInstance.ImageList16;
  mniAddLanguageContent.ImageIndex := IMG_ADD_DATA;

  SetButtonImages32(btnClose, IMG_CLOSE);
  SetButtonImages32(btnSysLang, IMG_LANG);
  SetButtonImages32(btnSysLangContent, IMG_LANG);
  SetButtonImages32(btnParaBirimleri, IMG_EXCHANGE_RATE);
  SetButtonImages32(btnDovizKurlari, IMG_MONEY);
  SetButtonImages32(btnBankalar, IMG_BANK);
  SetButtonImages32(btnBankaSubeleri, IMG_BANK_BRANCH);
  SetButtonImages32(btnSysCities, IMG_CITY);
  SetButtonImages32(btnSysCountries, IMG_COUNTRY);
  SetButtonImages32(btnAmbarlar, IMG_STOCK_ROOM);
  SetButtonImages32(btnOlcuBirimleri, IMG_MEASURE_UNIT);
  SetButtonImages32(btnOdemeBaslangicDonemi, IMG_DURATION_FINANCE);
  SetButtonImages32(btnQualityFormMailRecievers, IMG_MAIL);
  SetButtonImages32(btnSysApplicationSettings, IMG_SETTINGS);
  SetButtonImages32(btnSysQualityFormNumber, IMG_QUALITY);
  SetButtonImages32(btnSysDefaultOrderFilter, IMG_SORT_ASC);


//  todo
//  1 yap�ld� permision code listesini duzenle butun erisim izinleri kodlar �zerinden y�r�yecek �ekilde de�i�klik yap
//  2 standart erisim kodlar� i�in d�k�man ayarla sabit bilgi olarak girilsin
//  3 yap�ld� sys visible colum s�n�f� i�in �n y�z haz�rla
//  4 k�smen sistem ayarlar� i�in s�n�f tan�mla. ondal�kl� hane format�, para format�, tarih format�, butun sistem bu formatlar �zerinde ilerleyecek
//  5 yap�ld� Output formda arama penceresini ayarla k�smen yap�ld�. kontrol edilecek
//  6 input formlar icin helper penceresi tasarla
//  7 yap�ld� excel rapor
//  8 yaz�c� ekran�
//  9 detayl� form
//  10 stringgrid base form
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Key := 0;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_ESCAPE) then
    inherited;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F6 then
    inherited;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  inherited;

  if stbBase.Panels.Count >= STATUS_SQL_SERVER+1 then
    if TSingletonDB.GetInstance.DataBase.Connection.Connected then
      stbBase.Panels.Items[STATUS_SQL_SERVER].Text :=
          TSingletonDB.GetInstance.DataBase.Connection.Params.Values['Server'];

  if stbBase.Panels.Count >= STATUS_DATE+1 then
    if TSingletonDB.GetInstance.DataBase.Connection.Connected then
      stbBase.Panels.Items[STATUS_DATE].Text :=
          DateToStr(TSingletonDB.GetInstance.DataBase.GetToday(False));

  if stbBase.Panels.Count >= STATUS_USERNAME+1 then
    if TSingletonDB.GetInstance.DataBase.Connection.Connected then
      stbBase.Panels.Items[STATUS_USERNAME].Text := TSingletonDB.GetInstance.User.UserName.Value;

  if stbBase.Panels.Count >= STATUS_KEY_F4+1 then
    stbBase.Panels.Items[STATUS_KEY_F4].Text := 'F4 ' + TranslateText('DELETE', FrameworkLang.StatusDelete, LngStatus, LngSystem);
  if stbBase.Panels.Count >= STATUS_KEY_F5+1 then
    stbBase.Panels.Items[STATUS_KEY_F5].Text := 'F5 ' + TranslateText('CONFIRM', FrameworkLang.StatusAccept, LngStatus, LngSystem);
  if stbBase.Panels.Count >= STATUS_KEY_F6+1 then
    stbBase.Panels.Items[STATUS_KEY_F6].Text := 'F6 ' + TranslateText('CANCEL', FrameworkLang.StatusCancel, LngStatus, LngSystem);
  if stbBase.Panels.Count >= STATUS_KEY_F7+1 then
    stbBase.Panels.Items[STATUS_KEY_F7].Text := 'F7 ' + TranslateText('ADD RECORD', FrameworkLang.StatusAdd, LngStatus, LngSystem);


  SetSession();

  SetTitleFromLangContent();

  Self.Caption := getFormCaptionByLang(Self.Name, Self.Caption);

  if TSingletonDB.GetInstance.User.IsSuperUser.Value then
  begin
    SetButtonPopup();
    tsFrameworkSettings.TabVisible := True;
  end
  else
    tsFrameworkSettings.TabVisible := False;

  mniAddLanguageContent.Caption := TranslateText(mniAddLanguageContent.Caption, FrameworkLang.PopupAddLangGuiContent, LngPopup, LngSystem);
end;

procedure TfrmMain.mniAboutClick(Sender: TObject);
begin
  TfrmAbout.Create(Application).ShowModal;
  SetSession;
end;

procedure TfrmMain.mniAddLanguageContentClick(Sender: TObject);
var
  vSysLangGuiContent: TSysLangGuiContent;
  vCode, vValue, vContentType, vTableName: string;
begin
  if pmButtons.PopupComponent.ClassType = TButton then
  begin
    vCode := StringReplace(pmButtons.PopupComponent.Name, PREFIX_BUTTON, '', [rfReplaceAll]);
    vContentType := LngButton;
    vTableName := LngMainTable;
    vValue := TButton(pmButtons.PopupComponent).Caption;
  end
  else
  if pmButtons.PopupComponent.ClassType = TTabSheet then
  begin
    vCode := StringReplace(pmButtons.PopupComponent.Name, PREFIX_TABSHEET, '', [rfReplaceAll]);
    vContentType := LngTab;
    vTableName := LngMainTable;
    vValue := TTabSheet(pmButtons.PopupComponent).Caption;
  end;


  vSysLangGuiContent := TSysLangGuiContent.Create(TSingletonDB.GetInstance.DataBase);

  vSysLangGuiContent.Lang.Value := TSingletonDB.GetInstance.DataBase.ConnSetting.Language;
  vSysLangGuiContent.Code.Value := vCode;
  vSysLangGuiContent.ContentType.Value := vContentType;
  vSysLangGuiContent.TableName1.Value := vTableName;
  vSysLangGuiContent.Val.Value := vValue;

  TfrmSysLangGuiContent.Create(Self, nil, vSysLangGuiContent, True, ifmCopyNewRecord).ShowModal;


  SetTitleFromLangContent();
end;

procedure TfrmMain.mniCloseClick(Sender: TObject);
begin
  btnCloseClick(btnClose);
end;

procedure TfrmMain.ResetSession(pPanelGroupboxPagecontrolTabsheet: TWinControl);
var
  nIndex, nIndex2: Integer;
  PanelContainer: TWinControl;

  procedure DisableButtons(Sender: TWinControl);
  var
    nIndex: Integer;
  begin
    if (Sender.ClassType = TButton) then
    begin
      TButton(Sender).Enabled := False;
    end
    else
    begin
      for nIndex := 0 to Sender.ControlCount -1 do
      begin
        if Sender.Controls[nIndex].ClassType = TButton then
          TButton(Sender.Controls[nIndex]).Enabled := False
      end;
    end;
  end;

begin
  PanelContainer := nil;

  if pPanelGroupboxPagecontrolTabsheet = nil then
    PanelContainer := pnlMain
  else
  begin
    if pPanelGroupboxPagecontrolTabsheet.ClassType = TPanel then
      PanelContainer := pPanelGroupboxPagecontrolTabsheet as TPanel
    else if pPanelGroupboxPagecontrolTabsheet.ClassType = TGroupBox then
      PanelContainer := pPanelGroupboxPagecontrolTabsheet as TGroupBox
    else if pPanelGroupboxPagecontrolTabsheet.ClassType = TPageControl then
      PanelContainer := pPanelGroupboxPagecontrolTabsheet as TPageControl
    else if pPanelGroupboxPagecontrolTabsheet.ClassType = TTabSheet then
      PanelContainer := pPanelGroupboxPagecontrolTabsheet as TTabSheet;
  end;

  if (FormMode=ifmNone) then
  begin
    for nIndex := 0 to PanelContainer.ControlCount -1 do
    begin
      if PanelContainer.Controls[nIndex].ClassType = TPanel then
        DisableButtons(PanelContainer.Controls[nIndex] as TPanel);

      if PanelContainer.Controls[nIndex].ClassType = TGroupBox then
        DisableButtons(PanelContainer.Controls[nIndex] as TGroupBox);

      if PanelContainer.Controls[nIndex].ClassType = TPageControl then
        for nIndex2 := 0 to (PanelContainer.Controls[nIndex] as TPageControl).PageCount-1 do
          DisableButtons((PanelContainer.Controls[nIndex] as TPageControl).Pages[nIndex2]);

      if PanelContainer.Controls[nIndex].ClassType = TTabSheet then
        DisableButtons(PanelContainer.Controls[nIndex] as TTabSheet);

      if PanelContainer.Controls[nIndex].ClassType = TButton then
        DisableButtons( TButton(PanelContainer.Controls[nIndex]) );
    end;
  end;
end;

procedure TfrmMain.SetSession;
var
  vAccessRight: TSysUserAccessRight;
  n1: Integer;
begin
  ResetSession(pnlMain);

  vAccessRight := TSysUserAccessRight.Create(TSingletonDB.GetInstance.DataBase);
  try
    vAccessRight.SelectToList(' and user_name=' + QuotedStr(TSingletonDB.GetInstance.User.UserName.Value), False, False);
    for n1 := 0 to vAccessRight.List.Count-1 do
    begin
      if (TSysUserAccessRight(vAccessRight.List[n1]).IsRead.Value)
      or (TSysUserAccessRight(vAccessRight.List[n1]).IsAddRecord.Value)
      or (TSysUserAccessRight(vAccessRight.List[n1]).IsUpdate.Value)
      or (TSysUserAccessRight(vAccessRight.List[n1]).IsDelete.Value)
      or (TSysUserAccessRight(vAccessRight.List[n1]).IsSpecial.Value)
      then
      begin
        if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1' then
        begin
          btnSysPermissionSourceGroup.Enabled := True;
          btnSysPermissionSource.Enabled := True;
          btnSysUserAccessRight.Enabled := True;
          btnSysLang.Enabled := True;
          btnSysGridColWidth.Enabled := True;
          btnSysGridColColor.Enabled := True;
          btnSysGridColPercent.Enabled := True;
          btnSysLangContent.Enabled := True;
          btnStokHareketi.Enabled := True;
          btnSysDefaultOrderFilter.Enabled := True;
          btnSysApplicationSettings.Enabled := True;
          btnSysUser.Enabled := True;
          btnSysUserMacAddressExceptions.Enabled := True;
          btnSysTaxpayerTypes.Enabled := True;
          btnSysCountries.Enabled := True;
          btnSysCities.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1000' then
        begin
          btnParaBirimleri.Enabled := True;
          btnAyarEFaturaFaturaTipi.Enabled := True;
          btnAyarFirmaTipi.Enabled := True;
          btnAyarEfaturaIletisimKanali.Enabled := True;
          btnAyarEfaturaIstisnaKodu.Enabled := True;
          btnAyarVergiOrani.Enabled := True;
          btnBolge.Enabled := True;
          btnBolgeTuru.Enabled := True;
          btnHesapGrubu.Enabled := True;
          btnAyarStokHareketTipi.Enabled := True;
          btnSysQualityFormNumber.Enabled := True;
          btnAmbarlar.Enabled := True;
          btnQualityFormMailRecievers.Enabled := True;
          btnUrunKabulRedNedenleri.Enabled := True;
          btnStokTipi.Enabled := True;
          btnAyarStkUrunTipi.Enabled := True;
          btnCinsAileleri.Enabled := True;
          btnStokGrubuTurleri.Enabled := True;
          btnStokGruplari.Enabled := True;
          btnAyarBarkodUrunTuru.Enabled := True;
          btnAyarBarkodSeriNoTuru.Enabled := True;
          btnAyarBarkodHazirlikDosyaTurleri.Enabled := True;
          btnAyarBarkodTezgahlar.Enabled := True;
          btnHesapKartlari.Enabled := True;
          btnAracTakipArac.Enabled := True;
          btnMusteriTemsilciGruplari.Enabled := True;
          btnPersonelTasimaServisi.Enabled := True;
          btnEgitimSeviyeleri.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1009' then
        begin
          btnDovizKurlari.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1020' then
        begin
          btnAyarPersonelBolum.Enabled := True;
          btnAyarPersonelBirim.Enabled := True;
          btnAyarPersonelGorev.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1021' then
        begin
          btnPersonelKartlari.Enabled := True;
          btnPersonelDilBilgileri.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1011' then
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1013' then
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1030' then
        begin
          btnStokKartlari.Enabled := True;
        end
        else if TSysUserAccessRight(vAccessRight.List[n1]).PermissionCode.Value = '1001' then
        begin
        end;
      end;
    end;
  finally
    vAccessRight.Free;
  end;

  btnTeklifler.Enabled := True;
end;

Initialization

end.

