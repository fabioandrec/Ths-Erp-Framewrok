PGDMP     ;                    v            ths_erp2018    9.5.13    9.5.13 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    49539    ths_erp2018    DATABASE     �   CREATE DATABASE ths_erp2018 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Turkish_Turkey.1254' LC_CTYPE = 'Turkish_Turkey.1254';
    DROP DATABASE ths_erp2018;
             postgres    false            �           0    0    DATABASE ths_erp2018    COMMENT     6   COMMENT ON DATABASE ths_erp2018 IS 'THS ERP Systems';
                  postgres    false    4260                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
          	   ths_admin    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
               	   ths_admin    false    8            �           0    0    SCHEMA public    ACL     ~   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM ths_admin;
GRANT ALL ON SCHEMA public TO ths_admin;
               	   ths_admin    false    8                        3079    12355    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    49542    dblink 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;
    DROP EXTENSION dblink;
                  false    8            �           0    0    EXTENSION dblink    COMMENT     _   COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';
                       false    2            �           1255    133774    audit()    FUNCTION     2  CREATE FUNCTION public.audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
declare
_username varchar;
_ip varchar;
_database varchar;
_sql text;
_old_val text[];
_test text;
_tarih timestamp without time zone;
BEGIN

	IF (TG_OP = 'INSERT') OR (TG_OP = 'DELETE') OR ((TG_OP = 'UPDATE') AND (ARRAY[OLD] <> ARRAY[NEW])) THEN

		_username 	:= (upper(session_user)); 
		_ip 		:= (inet_client_addr());
		_database	:= (SELECT current_database());
		_tarih		:= (SELECT NOW());

		IF (TG_OP = 'INSERT') THEN
			_old_val	:= (SELECT array[NEW]);
		ELSE
			_old_val	:= (SELECT array[OLD]);
		END IF;

		_test		:= (SELECT array_to_string(_old_val, ', '));

--		raise exception 'Mesaj =%', _test;

		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, ',,', ', null,');
		_test := replace(_test, '"', '''');
		_test := replace(_test, '(', '''');
		_test := replace(_test, ')', '''');
		_test := replace(_test, ',', ''', ''');
		_test := replace(_test, '''''', '''');
		_test := replace(_test, ''' null''', ' null');

--		raise exception 'Mesaj =%', _test;

		_sql		:= (SELECT format('INSERT INTO %I.%I VALUES (%L, %L, %L, %L, %s)', _database, TG_TABLE_NAME, _username, _ip, _tarih, TG_OP, _test));

		PERFORM dblink(
			'host=localhost user=postgres password=123 dbname=ths_erp_log port=5432', 
			' ' || _sql || ';'
		);

	END IF;

	RETURN NULL;
/*
	EXECUTE format('INSERT INTO %I.%I VALUES ($1.*)', (SELECT current_database()), TG_TABLE_NAME, _username, _ip)
	USING OLD;
	RETURN OLD;

	RETURN null;
	IF OLD IS NOT DISTINCT FROM NEW THEN
*/

END
$_$;
    DROP FUNCTION public.audit();
       public       postgres    false    1    8            �           1255    133773    audit_old()    FUNCTION     �  CREATE FUNCTION public.audit_old() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$DECLARE
	_username varchar;
	_ip varchar;
	_table_name varchar;
	_orj_table_name varchar;
	_row_id integer;
	_access_type varchar;
	_time_of_change timestamp without time zone;
	_db_name varchar;
	_old_data text;
    BEGIN
	_username 		:= (upper(session_user)); 
	_ip 			:= (inet_client_addr());
	_table_name 		:= (upper(TG_TABLE_NAME)); 
	_orj_table_name		:= (TG_TABLE_NAME);
	_time_of_change 	:= (now());
	_db_name 		:= (current_database());
	_old_data		:= '';

	IF (TG_OP = 'INSERT') THEN
		_access_type 	:= (TG_OP);
		_row_id 	:= (NEW.id);
        END IF;

        IF (TG_OP = 'UPDATE') THEN
	    IF (OLD.validity = TRUE  AND  NEW.validity = FALSE) THEN
		_access_type 	:= quote_literal('VIRTUAL_DELETE');
		_row_id 	:= quote_literal(OLD.id);
	    ELSE
		_access_type 	:= (TG_OP);
		_row_id 	:= (OLD.id);
		--_old_data	:= (SELECT * FROM _orj_table_name);
	    END IF;
	END IF;

	IF (TG_OP = 'DELETE') THEN
            _access_type	:= (TG_OP);
            _row_id 		:= (OLD.id);
        END IF;


	PERFORM dblink('host=localhost user=postgres password=123 dbname=ths_erp2017_log port=5432', 
	'INSERT INTO audit(username, ip, table_name, access_type, time_of_change, row_id, db_name, old_data) ' || 
	'VALUES(' || 
		(quote_literal(_username)) || ',' || 
		(quote_literal(_ip)) || ',' ||  
		(quote_literal(upper(_table_name))) || ',' || 
		(quote_literal(_access_type)) || ',' || 
		(quote_literal(_time_of_change)) || ',' ||
		(quote_literal(_row_id)) || ',' || 
		(quote_literal(_db_name)) || ',' ||
		(quote_literal(_old_data)) || ');');
	    
        RETURN NULL;
    END;
$$;
 "   DROP FUNCTION public.audit_old();
       public       postgres    false    1    8            �           1255    123127    delete_table_lang_content()    FUNCTION     ^  CREATE FUNCTION public.delete_table_lang_content() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$DECLARE
    BEGIN
    
	IF (TG_OP = 'DELETE') THEN
            DELETE FROM sys_table_lang_content WHERE table_name=initcap(replace(TG_TABLE_NAME, '_', ' ')) AND row_id=OLD.id;
        END IF;

        RETURN NULL;
    END;
$$;
 2   DROP FUNCTION public.delete_table_lang_content();
       public       postgres    false    8    1            �           1255    131324    get_default_para_birimi()    FUNCTION     �   CREATE FUNCTION public.get_default_para_birimi() RETURNS character varying
    LANGUAGE sql
    AS $$SELECT kod FROM public.para_birimi WHERE is_varsayilan limit 1$$;
 0   DROP FUNCTION public.get_default_para_birimi();
       public       postgres    false    8            �           1255    131326    get_default_para_birimi_id()    FUNCTION     �   CREATE FUNCTION public.get_default_para_birimi_id() RETURNS integer
    LANGUAGE sql
    AS $$SELECT id FROM public.para_birimi WHERE is_varsayilan limit 1$$;
 3   DROP FUNCTION public.get_default_para_birimi_id();
       public       postgres    false    8            �           1255    49589    get_default_stok_tipi()    FUNCTION     �   CREATE FUNCTION public.get_default_stok_tipi() RETURNS integer
    LANGUAGE sql
    AS $$SELECT id FROM stok_tipi WHERE is_default=true$$;
 .   DROP FUNCTION public.get_default_stok_tipi();
       public       postgres    false    8            �           0    0     FUNCTION get_default_stok_tipi()    ACL     �   REVOKE ALL ON FUNCTION public.get_default_stok_tipi() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_default_stok_tipi() FROM postgres;
            public       postgres    false    497            �           1255    103396 .   get_lang_text(text, text, text, integer, text)    FUNCTION     �  CREATE FUNCTION public.get_lang_text(_default_value text, _table_name text, _column_name text, _row_id integer, _lang text) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$declare
	dmp text;
begin
	SELECT INTO dmp value FROM sys_lang_data_content 
	WHERE	1=1
		AND row_id = $4
		AND lang =$5
		AND column_name = $3
		AND table_name = $2
	LIMIT 1;

	IF (dmp is null) OR (dmp = '') THEN
		return _default_value;
	ELSE
		return dmp;
	END IF;

end
$_$;
 {   DROP FUNCTION public.get_lang_text(_default_value text, _table_name text, _column_name text, _row_id integer, _lang text);
       public       postgres    false    1    8            �           1255    49591    login(text, text, text, text)    FUNCTION     �  CREATE FUNCTION public.login(kullanici_adi text, pwd text, surum text, mac_adres text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$declare 
	id integer;
	kullanici record;
begin
	select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1;
	IF NOT FOUND THEN
		return -1;
		--RAISE EXCEPTION 'kullanici % bulunamadi', $1;
	ELSE
		IF kullanici.is_active = false THEN
			return -2;
			--RAISE EXCEPTION 'kullanici % aktif değil', $1;
		ELSE
			select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1 and kullanicilar.surum = crypt($3, kullanicilar.surum);
			IF NOT FOUND THEN
				return -6;
			--geçersiz sürüm
			ELSE
			--IF kullanici.cevrim_ici = false THEN
				select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1 and kullanicilar.ip = text(inet_client_addr());
				IF NOT FOUND THEN
					return -3;
					--RAISE EXCEPTION 'ip % hatalı!', text(inet_client_addr());
				ELSE
					select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1 and kullanicilar.mac_address = $4;
					IF NOT FOUND THEN
						return -7;
						--geçersiz mac_adresi;
					ELSE				
					
						select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1 and kullanicilar.pwd = crypt($2, kullanicilar.pwd);
						IF NOT FOUND THEN
							--RAISE EXCEPTION 'şifre hatalı!';
							select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1;
							IF kullanici.login_deneme_sayisi = 3 THEN
									UPDATE kullanicilar SET is_active=false WHERE kullanicilar.kullanici_adi = $1;
									return -8;
							END IF;
							select into kullanici * from kullanicilar where kullanicilar.kullanici_adi = $1;
							UPDATE kullanicilar SET login_deneme_sayisi=(kullanici.login_deneme_sayisi +1) WHERE kullanicilar.kullanici_adi = $1;
							return -4;
						ELSE
							UPDATE kullanicilar SET cevrim_ici=true, login_deneme_sayisi = 0 WHERE kullanicilar.id = kullanici.id;	
							return kullanici.id;
						END IF;
					END IF;
				END IF;
			--ELSE
			--	return -5;
				--RAISE EXCEPTION 'kullanici % zaten çevrim içi!', $1;
			--END IF;
			END IF;
		END IF;

	END IF;
	--return 0;
end
$_$;
 V   DROP FUNCTION public.login(kullanici_adi text, pwd text, surum text, mac_adres text);
       public       postgres    false    8    1            �           0    0 H   FUNCTION login(kullanici_adi text, pwd text, surum text, mac_adres text)    ACL     �   REVOKE ALL ON FUNCTION public.login(kullanici_adi text, pwd text, surum text, mac_adres text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.login(kullanici_adi text, pwd text, surum text, mac_adres text) FROM postgres;
            public       postgres    false    498            �           1255    142365    mal_ortalama_maliyet_2()    FUNCTION     �	  CREATE FUNCTION public.mal_ortalama_maliyet_2() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$DECLARE
    stok_hareketi RECORD;
    stok_hareketi_donem_basi RECORD;
    _miktar float;
    _ortalama_maliyet numeric;
    _stok_kodu character varying;
    _bHesapla boolean;
    ondalikli_hane RECORD;
BEGIN
	_miktar := 0;
	_ortalama_maliyet := 0;
	_bHesapla := true;

	IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
		_stok_kodu := NEW.stok_kodu;
	ELSIF (TG_OP = 'DELETE') THEN
		_stok_kodu := OLD.stok_kodu;
	END IF;

	IF _bHesapla = true THEN
		--her ambarın ayrıdönem başı hareketi var(fiyat aynıdır, miktarlar toplanır)
		FOR stok_hareketi_donem_basi IN SELECT miktar, tutar FROM stok_hareketi WHERE stok_kodu=_stok_kodu AND stok_hareketi.is_donem_basi_hareket = true AND stok_hareketi.miktar > 0 
		LOOP
			_miktar := _miktar + stok_hareketi_donem_basi.miktar;
			_ortalama_maliyet := stok_hareketi_donem_basi.tutar;
		END LOOP;
	

		FOR stok_hareketi IN SELECT giris_cikis, miktar, tutar FROM stok_hareketi WHERE stok_kodu= _stok_kodu AND stok_hareketi.is_donem_basi_hareket = FALSE AND stok_hareketi.miktar <> 0 ORDER BY tarih, id
		LOOP
			IF (mal_hareketi.giris_cikis_tip_id = 1)  THEN	--giriş
				IF _miktar > 0 THEN
					IF _miktar + stok_hareketi.miktar <= 0 THEN
						_ortalama_maliyet := 0;	
					ELSIF _miktar + stok_hareketi.miktar > 0 THEN
						_ortalama_maliyet := (_miktar * _ortalama_maliyet + mal_hareketi.miktar * mal_hareketi.tl_fiyat) / ( _miktar + mal_hareketi.miktar );
					END IF;
				ELSIF _miktar <= 0 THEN
					IF _miktar + mal_hareketi.miktar <= 0 THEN
						_ortalama_maliyet := 0;
					ELSIF (_miktar + mal_hareketi.miktar) > 0 THEN
						_ortalama_maliyet := mal_hareketi.tl_fiyat;
					END IF;
				END IF;
			END IF;	
			--miktar çıkışta negatif girişte pozitif o yüzden sadece topla
			_miktar := _miktar + mal_hareketi.miktar;
		END LOOP;
		
		SELECT mallar_fiyat, alim_fiyat, satim_fiyat into ondalikli_hane FROM ondalikli_haneler;
		 
		_ortalama_maliyet := round(_ortalama_maliyet, greatest(ondalikli_hane.mallar_fiyat, ondalikli_hane.alim_fiyat, ondalikli_hane.satim_fiyat));

		UPDATE mallar SET ortalama_maliyet=_ortalama_maliyet WHERE mal_kodu = _mal_kodu;
		
	END IF;
	
	IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		RETURN OLD;
	END IF;
END$$;
 /   DROP FUNCTION public.mal_ortalama_maliyet_2();
       public       postgres    false    8    1            �           0    0 !   FUNCTION mal_ortalama_maliyet_2()    COMMENT     �   COMMENT ON FUNCTION public.mal_ortalama_maliyet_2() IS 'mal_hareketleri tablosunda 
after insert, update, delete 
işlemden sonra malın tüm hareketlerinden ortalama maliyet hesaplar
şu an kullanılan trigger';
            public       postgres    false    504            �           0    0 !   FUNCTION mal_ortalama_maliyet_2()    ACL     �  REVOKE ALL ON FUNCTION public.mal_ortalama_maliyet_2() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.mal_ortalama_maliyet_2() FROM postgres;
GRANT ALL ON FUNCTION public.mal_ortalama_maliyet_2() TO postgres;
GRANT ALL ON FUNCTION public.mal_ortalama_maliyet_2() TO PUBLIC;
GRANT ALL ON FUNCTION public.mal_ortalama_maliyet_2() TO guest;
GRANT ALL ON FUNCTION public.mal_ortalama_maliyet_2() TO elektromed_admin;
            public       postgres    false    504            �           1255    217948    personel_adsoyad()    FUNCTION     ]  CREATE FUNCTION public.personel_adsoyad() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$DECLARE
    BEGIN
	IF (TG_OP = 'UPDATE') OR (TG_OP = 'INSERT') THEN
		UPDATE personel_karti SET 
			personel_ad_soyad=personel_ad || ' ' || personel_soyad
		WHERE personel_karti.id=NEW.id;
	END IF;
	
        RETURN NULL;
    END;
$$;
 )   DROP FUNCTION public.personel_adsoyad();
       public       postgres    false    1    8            �           0    0    FUNCTION personel_adsoyad()    ACL     �   REVOKE ALL ON FUNCTION public.personel_adsoyad() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.personel_adsoyad() FROM postgres;
GRANT ALL ON FUNCTION public.personel_adsoyad() TO postgres;
GRANT ALL ON FUNCTION public.personel_adsoyad() TO PUBLIC;
            public       postgres    false    507            �           1255    88195    table_notify()    FUNCTION     �  CREATE FUNCTION public.table_notify() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$    BEGIN
        IF (TG_OP = 'INSERT') THEN
		PERFORM pg_notify(TG_TABLE_NAME, NEW.id::varchar);
        ELSIF (TG_OP = 'UPDATE') THEN
		PERFORM pg_notify(TG_TABLE_NAME, OLD.id::varchar);
        ELSIF (TG_OP = 'DELETE') THEN
		PERFORM pg_notify(TG_TABLE_NAME, '');
        END IF;
        RETURN NEW;
    END;$$;
 %   DROP FUNCTION public.table_notify();
       public       postgres    false    8    1            �           0    0    FUNCTION table_notify()    ACL     v   REVOKE ALL ON FUNCTION public.table_notify() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.table_notify() FROM postgres;
            public       postgres    false    499            �            1259    49593    alis_teklif    TABLE     �  CREATE TABLE public.alis_teklif (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    teklif_no integer NOT NULL,
    teklif_tarihi timestamp without time zone NOT NULL,
    cari_kod character varying(16),
    firma character varying(128),
    vergi_dairesi character varying(32),
    vergi_no character varying(16),
    aciklama character varying(128),
    referans character varying(32),
    teslim_tarihi timestamp without time zone,
    son_gecerlilik_tarihi timestamp without time zone,
    para_birimi character varying(3) NOT NULL,
    odeme_baslangic_donemi character varying(8),
    toplam_tutar double precision DEFAULT 0 NOT NULL,
    toplam_iskonto_tutar double precision DEFAULT 0 NOT NULL,
    toplam_kdv_tutar double precision DEFAULT 0 NOT NULL,
    genel_toplam double precision DEFAULT 0 NOT NULL,
    musteri_temsilcisi_id integer,
    ulke character varying(64),
    sehir character varying(32),
    adres character varying(80),
    posta_kodu character varying(7),
    yurtici_ihracat character varying(24),
    ortalama_opsiyon double precision,
    fatura_tipi character varying(16),
    tevkifat_kodu character varying(3),
    ihrac_kayit_kodu character varying(3),
    tevkifat_pay integer,
    tevkifat_payda integer,
    genel_iskonto_orani double precision DEFAULT 0 NOT NULL,
    genel_iskonto_tutar double precision DEFAULT 0 NOT NULL,
    is_e_fatura boolean DEFAULT false NOT NULL,
    siparislesti boolean NOT NULL
);
    DROP TABLE public.alis_teklif;
       public         postgres    false    8            �           0    0    TABLE alis_teklif    ACL     �   REVOKE ALL ON TABLE public.alis_teklif FROM PUBLIC;
REVOKE ALL ON TABLE public.alis_teklif FROM postgres;
GRANT ALL ON TABLE public.alis_teklif TO postgres;
GRANT ALL ON TABLE public.alis_teklif TO PUBLIC;
            public       postgres    false    183            �            1259    49607    alis_teklif_detay    TABLE     �   CREATE TABLE public.alis_teklif_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer
);
 %   DROP TABLE public.alis_teklif_detay;
       public         postgres    false    8            �           0    0    TABLE alis_teklif_detay    ACL     �   REVOKE ALL ON TABLE public.alis_teklif_detay FROM PUBLIC;
REVOKE ALL ON TABLE public.alis_teklif_detay FROM postgres;
GRANT ALL ON TABLE public.alis_teklif_detay TO postgres;
GRANT ALL ON TABLE public.alis_teklif_detay TO PUBLIC;
            public       postgres    false    184            �            1259    49611    alis_teklif_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.alis_teklif_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.alis_teklif_detay_id_seq;
       public       postgres    false    8    184            �           0    0    alis_teklif_detay_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.alis_teklif_detay_id_seq OWNED BY public.alis_teklif_detay.id;
            public       postgres    false    185            �           0    0 !   SEQUENCE alis_teklif_detay_id_seq    ACL       REVOKE ALL ON SEQUENCE public.alis_teklif_detay_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.alis_teklif_detay_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.alis_teklif_detay_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.alis_teklif_detay_id_seq TO PUBLIC;
            public       postgres    false    185            �            1259    49613    alis_teklif_id_seq    SEQUENCE     {   CREATE SEQUENCE public.alis_teklif_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.alis_teklif_id_seq;
       public       postgres    false    8    183            �           0    0    alis_teklif_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.alis_teklif_id_seq OWNED BY public.alis_teklif.id;
            public       postgres    false    186            �           0    0    SEQUENCE alis_teklif_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.alis_teklif_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.alis_teklif_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.alis_teklif_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.alis_teklif_id_seq TO PUBLIC;
            public       postgres    false    186            �            1259    49615    alis_tsif_kur    TABLE        CREATE TABLE public.alis_tsif_kur (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    alis_teklif_id integer,
    alis_siparis_id integer,
    alis_irsaliye_id integer,
    alis_fatura_id integer,
    para_birimi character varying(3),
    deger double precision
);
 !   DROP TABLE public.alis_tsif_kur;
       public         postgres    false    8            �           0    0    TABLE alis_tsif_kur    ACL     �   REVOKE ALL ON TABLE public.alis_tsif_kur FROM PUBLIC;
REVOKE ALL ON TABLE public.alis_tsif_kur FROM postgres;
GRANT ALL ON TABLE public.alis_tsif_kur TO postgres;
GRANT ALL ON TABLE public.alis_tsif_kur TO PUBLIC;
            public       postgres    false    187            �            1259    49619    alis_tsif_kur_id_seq    SEQUENCE     }   CREATE SEQUENCE public.alis_tsif_kur_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.alis_tsif_kur_id_seq;
       public       postgres    false    187    8            �           0    0    alis_tsif_kur_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.alis_tsif_kur_id_seq OWNED BY public.alis_tsif_kur.id;
            public       postgres    false    188            �           0    0    SEQUENCE alis_tsif_kur_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.alis_tsif_kur_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.alis_tsif_kur_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.alis_tsif_kur_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.alis_tsif_kur_id_seq TO PUBLIC;
            public       postgres    false    188            �            1259    49621    ambar    TABLE     I  CREATE TABLE public.ambar (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    ambar_adi character varying(32),
    is_varsayilan_hammadde_ambari boolean DEFAULT false NOT NULL,
    is_varsayilan_uretim_ambari boolean DEFAULT false NOT NULL,
    is_varsayilan_satis_ambari boolean DEFAULT false NOT NULL
);
    DROP TABLE public.ambar;
       public         postgres    false    8            �           0    0    TABLE ambar    COMMENT     Q   COMMENT ON TABLE public.ambar IS 'Stok hareketlerinin tutulduğu ambar bilgisi';
            public       postgres    false    189            �           0    0    TABLE ambar    ACL     �   REVOKE ALL ON TABLE public.ambar FROM PUBLIC;
REVOKE ALL ON TABLE public.ambar FROM postgres;
GRANT ALL ON TABLE public.ambar TO postgres;
GRANT ALL ON TABLE public.ambar TO PUBLIC;
            public       postgres    false    189            �            1259    49626    ambar_id_seq    SEQUENCE     u   CREATE SEQUENCE public.ambar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.ambar_id_seq;
       public       postgres    false    8    189            �           0    0    ambar_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.ambar_id_seq OWNED BY public.ambar.id;
            public       postgres    false    190            �           0    0    SEQUENCE ambar_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.ambar_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ambar_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ambar_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ambar_id_seq TO PUBLIC;
            public       postgres    false    190            [           1259    142417    ayar_barkod_hazirlik_dosya_turu    TABLE     �   CREATE TABLE public.ayar_barkod_hazirlik_dosya_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(32) NOT NULL
);
 3   DROP TABLE public.ayar_barkod_hazirlik_dosya_turu;
       public         postgres    false    8            Z           1259    142415 &   ayar_barkod_hazirlik_dosya_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_barkod_hazirlik_dosya_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.ayar_barkod_hazirlik_dosya_turu_id_seq;
       public       postgres    false    8    347            �           0    0 &   ayar_barkod_hazirlik_dosya_turu_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.ayar_barkod_hazirlik_dosya_turu_id_seq OWNED BY public.ayar_barkod_hazirlik_dosya_turu.id;
            public       postgres    false    346            U           1259    142379    ayar_barkod_serino_turu    TABLE     �   CREATE TABLE public.ayar_barkod_serino_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(4) NOT NULL,
    aciklama character varying(16) NOT NULL
);
 +   DROP TABLE public.ayar_barkod_serino_turu;
       public         postgres    false    8            T           1259    142377    ayar_barkod_serino_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_barkod_serino_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_barkod_serino_turu_id_seq;
       public       postgres    false    8    341            �           0    0    ayar_barkod_serino_turu_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_barkod_serino_turu_id_seq OWNED BY public.ayar_barkod_serino_turu.id;
            public       postgres    false    340            W           1259    142390    ayar_barkod_tezgah    TABLE     �   CREATE TABLE public.ayar_barkod_tezgah (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tezgah_adi character varying(32) NOT NULL,
    ambar_id integer NOT NULL
);
 &   DROP TABLE public.ayar_barkod_tezgah;
       public         postgres    false    8            V           1259    142388    ayar_barkod_tezgah_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_barkod_tezgah_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.ayar_barkod_tezgah_id_seq;
       public       postgres    false    343    8            �           0    0    ayar_barkod_tezgah_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.ayar_barkod_tezgah_id_seq OWNED BY public.ayar_barkod_tezgah.id;
            public       postgres    false    342            Y           1259    142406    ayar_barkod_urun_turu    TABLE     �   CREATE TABLE public.ayar_barkod_urun_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(16) NOT NULL
);
 )   DROP TABLE public.ayar_barkod_urun_turu;
       public         postgres    false    8            X           1259    142404    ayar_barkod_urun_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_barkod_urun_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.ayar_barkod_urun_turu_id_seq;
       public       postgres    false    8    345            �           0    0    ayar_barkod_urun_turu_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.ayar_barkod_urun_turu_id_seq OWNED BY public.ayar_barkod_urun_turu.id;
            public       postgres    false    344            i           1259    157512    ayar_bordro_tipi    TABLE     �   CREATE TABLE public.ayar_bordro_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 $   DROP TABLE public.ayar_bordro_tipi;
       public         postgres    false    8            h           1259    157510    ayar_bordro_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_bordro_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ayar_bordro_tipi_id_seq;
       public       postgres    false    361    8            �           0    0    ayar_bordro_tipi_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ayar_bordro_tipi_id_seq OWNED BY public.ayar_bordro_tipi.id;
            public       postgres    false    360            �           1259    157836    ayar_cek_senet_cash_edici_tipi    TABLE     �   CREATE TABLE public.ayar_cek_senet_cash_edici_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32)
);
 2   DROP TABLE public.ayar_cek_senet_cash_edici_tipi;
       public         postgres    false    8            �           1259    157834 %   ayar_cek_senet_cash_edici_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_cek_senet_cash_edici_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.ayar_cek_senet_cash_edici_tipi_id_seq;
       public       postgres    false    8    393            �           0    0 %   ayar_cek_senet_cash_edici_tipi_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.ayar_cek_senet_cash_edici_tipi_id_seq OWNED BY public.ayar_cek_senet_cash_edici_tipi.id;
            public       postgres    false    392            �           1259    157847     ayar_cek_senet_tahsil_odeme_tipi    TABLE     �   CREATE TABLE public.ayar_cek_senet_tahsil_odeme_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 4   DROP TABLE public.ayar_cek_senet_tahsil_odeme_tipi;
       public         postgres    false    8            �           1259    157845 '   ayar_cek_senet_tahsil_odeme_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_cek_senet_tahsil_odeme_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public.ayar_cek_senet_tahsil_odeme_tipi_id_seq;
       public       postgres    false    8    395            �           0    0 '   ayar_cek_senet_tahsil_odeme_tipi_id_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public.ayar_cek_senet_tahsil_odeme_tipi_id_seq OWNED BY public.ayar_cek_senet_tahsil_odeme_tipi.id;
            public       postgres    false    394            �           1259    157819    ayar_cek_senet_tipi    TABLE     �   CREATE TABLE public.ayar_cek_senet_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 '   DROP TABLE public.ayar_cek_senet_tipi;
       public         postgres    false    8            �           1259    157817    ayar_cek_senet_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_cek_senet_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.ayar_cek_senet_tipi_id_seq;
       public       postgres    false    8    391            �           0    0    ayar_cek_senet_tipi_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.ayar_cek_senet_tipi_id_seq OWNED BY public.ayar_cek_senet_tipi.id;
            public       postgres    false    390            _           1259    157414    ayar_diger_database_bilgisi    TABLE     :  CREATE TABLE public.ayar_diger_database_bilgisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    db_name character varying(64),
    host_name character varying(64),
    db_user character varying(64),
    db_pass character varying(64),
    db_port integer,
    firma_adi character varying(64),
    is_aybey_teklif_hesapla boolean DEFAULT false NOT NULL,
    is_bulut_teklif_hesapla boolean DEFAULT false NOT NULL,
    is_maliyet_analiz boolean DEFAULT false NOT NULL,
    is_siparis_kopyala boolean DEFAULT false NOT NULL,
    is_otomatik_doviz_kaydet boolean DEFAULT false NOT NULL,
    is_staff_personel_bilgisi boolean DEFAULT false NOT NULL,
    is_uretim_takip boolean DEFAULT false NOT NULL,
    is_pano_uretim boolean DEFAULT false NOT NULL,
    is_nakit_akis boolean DEFAULT false NOT NULL
);
 /   DROP TABLE public.ayar_diger_database_bilgisi;
       public         postgres    false    8            ^           1259    157412 "   ayar_diger_database_bilgisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_diger_database_bilgisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.ayar_diger_database_bilgisi_id_seq;
       public       postgres    false    351    8            �           0    0 "   ayar_diger_database_bilgisi_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.ayar_diger_database_bilgisi_id_seq OWNED BY public.ayar_diger_database_bilgisi.id;
            public       postgres    false    350            a           1259    157434    ayar_edefter_donem_raporu    TABLE       CREATE TABLE public.ayar_edefter_donem_raporu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    rapor_baslangic_donemi date,
    rapor_bitis_donemi date,
    rapor_alma_tarihi date,
    yevmiye_no_baslangic integer,
    yevmiye_no_bitis integer
);
 -   DROP TABLE public.ayar_edefter_donem_raporu;
       public         postgres    false    8            `           1259    157432     ayar_edefter_donem_raporu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_edefter_donem_raporu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.ayar_edefter_donem_raporu_id_seq;
       public       postgres    false    353    8            �           0    0     ayar_edefter_donem_raporu_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.ayar_edefter_donem_raporu_id_seq OWNED BY public.ayar_edefter_donem_raporu.id;
            public       postgres    false    352            e           1259    157483    ayar_efatura_alici_bilgisi    TABLE     �  CREATE TABLE public.ayar_efatura_alici_bilgisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    alias character varying(128),
    title character varying(256),
    type_ character varying(128),
    first_creation_time character varying(32),
    alias_creation_time character varying(32),
    register_time character varying(32),
    identifier character varying(11)
);
 .   DROP TABLE public.ayar_efatura_alici_bilgisi;
       public         postgres    false    8            d           1259    157481 !   ayar_efatura_alici_bilgisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_alici_bilgisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_efatura_alici_bilgisi_id_seq;
       public       postgres    false    357    8            �           0    0 !   ayar_efatura_alici_bilgisi_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_efatura_alici_bilgisi_id_seq OWNED BY public.ayar_efatura_alici_bilgisi.id;
            public       postgres    false    356            o           1259    157599    ayar_efatura_evrak_cinsi    TABLE     �   CREATE TABLE public.ayar_efatura_evrak_cinsi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    evrak_cinsi character varying(32)
);
 ,   DROP TABLE public.ayar_efatura_evrak_cinsi;
       public         postgres    false    8            n           1259    157597    ayar_efatura_evrak_cinsi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_evrak_cinsi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.ayar_efatura_evrak_cinsi_id_seq;
       public       postgres    false    8    367            �           0    0    ayar_efatura_evrak_cinsi_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.ayar_efatura_evrak_cinsi_id_seq OWNED BY public.ayar_efatura_evrak_cinsi.id;
            public       postgres    false    366            m           1259    157588    ayar_efatura_evrak_tipi    TABLE     �   CREATE TABLE public.ayar_efatura_evrak_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    evrak_tipi character varying(32)
);
 +   DROP TABLE public.ayar_efatura_evrak_tipi;
       public         postgres    false    8            q           1259    157610    ayar_efatura_evrak_tipi_cinsi    TABLE     �   CREATE TABLE public.ayar_efatura_evrak_tipi_cinsi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    evrak_tipi_id integer,
    evrak_cinsi_id integer
);
 1   DROP TABLE public.ayar_efatura_evrak_tipi_cinsi;
       public         postgres    false    8            p           1259    157608 $   ayar_efatura_evrak_tipi_cinsi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_evrak_tipi_cinsi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.ayar_efatura_evrak_tipi_cinsi_id_seq;
       public       postgres    false    369    8            �           0    0 $   ayar_efatura_evrak_tipi_cinsi_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.ayar_efatura_evrak_tipi_cinsi_id_seq OWNED BY public.ayar_efatura_evrak_tipi_cinsi.id;
            public       postgres    false    368            l           1259    157586    ayar_efatura_evrak_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_evrak_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_efatura_evrak_tipi_id_seq;
       public       postgres    false    8    365            �           0    0    ayar_efatura_evrak_tipi_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_efatura_evrak_tipi_id_seq OWNED BY public.ayar_efatura_evrak_tipi.id;
            public       postgres    false    364                       1259    103564    ayar_efatura_fatura_tipi    TABLE     �   CREATE TABLE public.ayar_efatura_fatura_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tip character varying(32) NOT NULL
);
 ,   DROP TABLE public.ayar_efatura_fatura_tipi;
       public         postgres    false    8            �           0    0    TABLE ayar_efatura_fatura_tipi    COMMENT     J   COMMENT ON TABLE public.ayar_efatura_fatura_tipi IS 'eFatura Evrak Tipi';
            public       postgres    false    285                       1259    103562    ayar_efatura_fatura_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_fatura_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.ayar_efatura_fatura_tipi_id_seq;
       public       postgres    false    285    8            �           0    0    ayar_efatura_fatura_tipi_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.ayar_efatura_fatura_tipi_id_seq OWNED BY public.ayar_efatura_fatura_tipi.id;
            public       postgres    false    284            g           1259    157495    ayar_efatura_gonderici_bilgisi    TABLE     �  CREATE TABLE public.ayar_efatura_gonderici_bilgisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    alias character varying(128),
    title character varying(256),
    type_ character varying(128),
    first_creation_time character varying(32),
    alias_creation_time character varying(32),
    register_time character varying(32),
    identifier character varying(11)
);
 2   DROP TABLE public.ayar_efatura_gonderici_bilgisi;
       public         postgres    false    8            f           1259    157493 %   ayar_efatura_gonderici_bilgisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_gonderici_bilgisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.ayar_efatura_gonderici_bilgisi_id_seq;
       public       postgres    false    359    8            �           0    0 %   ayar_efatura_gonderici_bilgisi_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.ayar_efatura_gonderici_bilgisi_id_seq OWNED BY public.ayar_efatura_gonderici_bilgisi.id;
            public       postgres    false    358            }           1259    157707    ayar_efatura_gonderim_sekli    TABLE       CREATE TABLE public.ayar_efatura_gonderim_sekli (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(8),
    kod_adi character varying(64),
    aciklama character varying(1024),
    is_active boolean DEFAULT true NOT NULL
);
 /   DROP TABLE public.ayar_efatura_gonderim_sekli;
       public         postgres    false    8            |           1259    157705 "   ayar_efatura_gonderim_sekli_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_gonderim_sekli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.ayar_efatura_gonderim_sekli_id_seq;
       public       postgres    false    381    8            �           0    0 "   ayar_efatura_gonderim_sekli_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.ayar_efatura_gonderim_sekli_id_seq OWNED BY public.ayar_efatura_gonderim_sekli.id;
            public       postgres    false    380            c           1259    157469 (   ayar_efatura_ihrac_kayitli_fatura_sebebi    TABLE     �   CREATE TABLE public.ayar_efatura_ihrac_kayitli_fatura_sebebi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(3),
    aciklama character varying(256)
);
 <   DROP TABLE public.ayar_efatura_ihrac_kayitli_fatura_sebebi;
       public         postgres    false    8            b           1259    157467 /   ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 F   DROP SEQUENCE public.ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq;
       public       postgres    false    355    8            �           0    0 /   ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq OWNED BY public.ayar_efatura_ihrac_kayitli_fatura_sebebi.id;
            public       postgres    false    354            �            1259    49628    ayar_efatura_iletisim_kanali    TABLE     �   CREATE TABLE public.ayar_efatura_iletisim_kanali (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(2) NOT NULL,
    aciklama character varying(512)
);
 0   DROP TABLE public.ayar_efatura_iletisim_kanali;
       public         postgres    false    8            �           0    0 "   TABLE ayar_efatura_iletisim_kanali    ACL       REVOKE ALL ON TABLE public.ayar_efatura_iletisim_kanali FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_iletisim_kanali FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_iletisim_kanali TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_iletisim_kanali TO PUBLIC;
            public       postgres    false    191            �            1259    49635 #   ayar_efatura_iletisim_kanali_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq;
       public       postgres    false    191    8            �           0    0 #   ayar_efatura_iletisim_kanali_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq OWNED BY public.ayar_efatura_iletisim_kanali.id;
            public       postgres    false    192            �           0    0 ,   SEQUENCE ayar_efatura_iletisim_kanali_id_seq    ACL     :  REVOKE ALL ON SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_iletisim_kanali_id_seq TO PUBLIC;
            public       postgres    false    192            �            1259    49643    ayar_efatura_istisna_kodu    TABLE     "  CREATE TABLE public.ayar_efatura_istisna_kodu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(4) NOT NULL,
    aciklama character varying(512) NOT NULL,
    is_tam_istisna boolean DEFAULT true NOT NULL,
    fatura_tip_id integer NOT NULL
);
 -   DROP TABLE public.ayar_efatura_istisna_kodu;
       public         postgres    false    8            �           0    0    TABLE ayar_efatura_istisna_kodu    ACL       REVOKE ALL ON TABLE public.ayar_efatura_istisna_kodu FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_istisna_kodu FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_istisna_kodu TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_istisna_kodu TO PUBLIC;
            public       postgres    false    193            �            1259    49651     ayar_efatura_istisna_kodu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_istisna_kodu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.ayar_efatura_istisna_kodu_id_seq;
       public       postgres    false    8    193            �           0    0     ayar_efatura_istisna_kodu_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.ayar_efatura_istisna_kodu_id_seq OWNED BY public.ayar_efatura_istisna_kodu.id;
            public       postgres    false    194            �           0    0 )   SEQUENCE ayar_efatura_istisna_kodu_id_seq    ACL     .  REVOKE ALL ON SEQUENCE public.ayar_efatura_istisna_kodu_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_istisna_kodu_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_istisna_kodu_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_istisna_kodu_id_seq TO PUBLIC;
            public       postgres    false    194            �            1259    49653    ayar_efatura_kimlik_semalari    TABLE     �   CREATE TABLE public.ayar_efatura_kimlik_semalari (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16),
    aciklama character varying(64)
);
 0   DROP TABLE public.ayar_efatura_kimlik_semalari;
       public         postgres    false    8            �           0    0 "   TABLE ayar_efatura_kimlik_semalari    ACL       REVOKE ALL ON TABLE public.ayar_efatura_kimlik_semalari FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_kimlik_semalari FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_kimlik_semalari TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_kimlik_semalari TO PUBLIC;
            public       postgres    false    195            �            1259    49657 #   ayar_efatura_kimlik_semalari_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq;
       public       postgres    false    195    8            �           0    0 #   ayar_efatura_kimlik_semalari_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq OWNED BY public.ayar_efatura_kimlik_semalari.id;
            public       postgres    false    196            �           0    0 ,   SEQUENCE ayar_efatura_kimlik_semalari_id_seq    ACL     :  REVOKE ALL ON SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_kimlik_semalari_id_seq TO PUBLIC;
            public       postgres    false    196            �           1259    157755    ayar_efatura_odeme_sekli    TABLE     >  CREATE TABLE public.ayar_efatura_odeme_sekli (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(16),
    odeme_sekli character varying(96),
    aciklama character varying(512),
    is_efatura boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);
 ,   DROP TABLE public.ayar_efatura_odeme_sekli;
       public         postgres    false    8            �           1259    157753    ayar_efatura_odeme_sekli_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_odeme_sekli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.ayar_efatura_odeme_sekli_id_seq;
       public       postgres    false    8    387            �           0    0    ayar_efatura_odeme_sekli_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.ayar_efatura_odeme_sekli_id_seq OWNED BY public.ayar_efatura_odeme_sekli.id;
            public       postgres    false    386            �           1259    157771    ayar_efatura_paket_tipi    TABLE       CREATE TABLE public.ayar_efatura_paket_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(2),
    paket_adi character varying(128),
    aciklama character varying(512),
    is_active boolean DEFAULT true NOT NULL
);
 +   DROP TABLE public.ayar_efatura_paket_tipi;
       public         postgres    false    8            �           1259    157769    ayar_efatura_paket_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_paket_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_efatura_paket_tipi_id_seq;
       public       postgres    false    8    389            �           0    0    ayar_efatura_paket_tipi_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_efatura_paket_tipi_id_seq OWNED BY public.ayar_efatura_paket_tipi.id;
            public       postgres    false    388            �            1259    49659    ayar_efatura_response_code    TABLE     �   CREATE TABLE public.ayar_efatura_response_code (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(8)
);
 .   DROP TABLE public.ayar_efatura_response_code;
       public         postgres    false    8            �           0    0     TABLE ayar_efatura_response_code    ACL     
  REVOKE ALL ON TABLE public.ayar_efatura_response_code FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_response_code FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_response_code TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_response_code TO PUBLIC;
            public       postgres    false    197            �            1259    49663 !   ayar_efatura_response_code_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_response_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_efatura_response_code_id_seq;
       public       postgres    false    8    197            �           0    0 !   ayar_efatura_response_code_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_efatura_response_code_id_seq OWNED BY public.ayar_efatura_response_code.id;
            public       postgres    false    198            �           0    0 *   SEQUENCE ayar_efatura_response_code_id_seq    ACL     2  REVOKE ALL ON SEQUENCE public.ayar_efatura_response_code_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_response_code_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_response_code_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_response_code_id_seq TO PUBLIC;
            public       postgres    false    198                       1259    103299    ayar_efatura_senaryo_tipi    TABLE     �   CREATE TABLE public.ayar_efatura_senaryo_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tip character varying(32) NOT NULL,
    aciklama character varying(64)
);
 -   DROP TABLE public.ayar_efatura_senaryo_tipi;
       public         postgres    false    8            �           0    0    TABLE ayar_efatura_senaryo_tipi    COMMENT     P   COMMENT ON TABLE public.ayar_efatura_senaryo_tipi IS 'eFatura Senaryo tipleri';
            public       postgres    false    274            �           0    0    TABLE ayar_efatura_senaryo_tipi    ACL       REVOKE ALL ON TABLE public.ayar_efatura_senaryo_tipi FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_senaryo_tipi FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_senaryo_tipi TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_senaryo_tipi TO PUBLIC;
            public       postgres    false    274                       1259    103297     ayar_efatura_senaryo_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_senaryo_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.ayar_efatura_senaryo_tipi_id_seq;
       public       postgres    false    8    274            �           0    0     ayar_efatura_senaryo_tipi_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.ayar_efatura_senaryo_tipi_id_seq OWNED BY public.ayar_efatura_senaryo_tipi.id;
            public       postgres    false    273            �           1259    184604    ayar_efatura_teslim_sarti    TABLE     (  CREATE TABLE public.ayar_efatura_teslim_sarti (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(16) NOT NULL,
    aciklama character varying(64) NOT NULL,
    is_efatura boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);
 -   DROP TABLE public.ayar_efatura_teslim_sarti;
       public         postgres    false    8            �           1259    184602     ayar_efatura_teslim_sarti_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_teslim_sarti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.ayar_efatura_teslim_sarti_id_seq;
       public       postgres    false    397    8            �           0    0     ayar_efatura_teslim_sarti_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.ayar_efatura_teslim_sarti_id_seq OWNED BY public.ayar_efatura_teslim_sarti.id;
            public       postgres    false    396            �            1259    49671    ayar_efatura_tevkifat_kodu    TABLE     �   CREATE TABLE public.ayar_efatura_tevkifat_kodu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kodu character varying(3),
    adi character varying(256),
    orani character varying(32),
    pay integer,
    payda integer
);
 .   DROP TABLE public.ayar_efatura_tevkifat_kodu;
       public         postgres    false    8            �           0    0     TABLE ayar_efatura_tevkifat_kodu    ACL     
  REVOKE ALL ON TABLE public.ayar_efatura_tevkifat_kodu FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_tevkifat_kodu FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_tevkifat_kodu TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_tevkifat_kodu TO PUBLIC;
            public       postgres    false    199            �            1259    49675 !   ayar_efatura_tevkifat_kodu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq;
       public       postgres    false    8    199            �           0    0 !   ayar_efatura_tevkifat_kodu_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq OWNED BY public.ayar_efatura_tevkifat_kodu.id;
            public       postgres    false    200            �           0    0 *   SEQUENCE ayar_efatura_tevkifat_kodu_id_seq    ACL     2  REVOKE ALL ON SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_tevkifat_kodu_id_seq TO PUBLIC;
            public       postgres    false    200            �            1259    49677    ayar_efatura_vergi_kodu    TABLE       CREATE TABLE public.ayar_efatura_vergi_kodu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kodu character varying(4),
    adi character varying(128),
    kisaltma character varying(32),
    tevkifat boolean DEFAULT false NOT NULL
);
 +   DROP TABLE public.ayar_efatura_vergi_kodu;
       public         postgres    false    8            �           0    0    TABLE ayar_efatura_vergi_kodu    ACL     �   REVOKE ALL ON TABLE public.ayar_efatura_vergi_kodu FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_efatura_vergi_kodu FROM postgres;
GRANT ALL ON TABLE public.ayar_efatura_vergi_kodu TO postgres;
GRANT ALL ON TABLE public.ayar_efatura_vergi_kodu TO PUBLIC;
            public       postgres    false    201            �            1259    49682    ayar_efatura_vergi_kodu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_efatura_vergi_kodu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_efatura_vergi_kodu_id_seq;
       public       postgres    false    8    201            �           0    0    ayar_efatura_vergi_kodu_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_efatura_vergi_kodu_id_seq OWNED BY public.ayar_efatura_vergi_kodu.id;
            public       postgres    false    202            �           0    0 '   SEQUENCE ayar_efatura_vergi_kodu_id_seq    ACL     &  REVOKE ALL ON SEQUENCE public.ayar_efatura_vergi_kodu_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_efatura_vergi_kodu_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_vergi_kodu_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_efatura_vergi_kodu_id_seq TO PUBLIC;
            public       postgres    false    202            w           1259    157664    ayar_fatura_no_serisi    TABLE     �   CREATE TABLE public.ayar_fatura_no_serisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    fatura_seri_id integer NOT NULL,
    deger character varying(16) NOT NULL
);
 )   DROP TABLE public.ayar_fatura_no_serisi;
       public         postgres    false    8            v           1259    157662    ayar_fatura_no_serisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_fatura_no_serisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.ayar_fatura_no_serisi_id_seq;
       public       postgres    false    375    8            �           0    0    ayar_fatura_no_serisi_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.ayar_fatura_no_serisi_id_seq OWNED BY public.ayar_fatura_no_serisi.id;
            public       postgres    false    374            �            1259    49690    ayar_firma_tipi    TABLE     �   CREATE TABLE public.ayar_firma_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tip character varying(32) NOT NULL
);
 #   DROP TABLE public.ayar_firma_tipi;
       public         postgres    false    8            �           0    0    TABLE ayar_firma_tipi    ACL     �   REVOKE ALL ON TABLE public.ayar_firma_tipi FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_firma_tipi FROM postgres;
GRANT ALL ON TABLE public.ayar_firma_tipi TO postgres;
GRANT ALL ON TABLE public.ayar_firma_tipi TO PUBLIC;
            public       postgres    false    203            �            1259    49694    ayar_firma_tipi_detay    TABLE     �   CREATE TABLE public.ayar_firma_tipi_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(48),
    firma_tipi character varying(32)
);
 )   DROP TABLE public.ayar_firma_tipi_detay;
       public         postgres    false    8            �           0    0    TABLE ayar_firma_tipi_detay    ACL     �   REVOKE ALL ON TABLE public.ayar_firma_tipi_detay FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_firma_tipi_detay FROM postgres;
GRANT ALL ON TABLE public.ayar_firma_tipi_detay TO postgres;
GRANT ALL ON TABLE public.ayar_firma_tipi_detay TO PUBLIC;
            public       postgres    false    204            �            1259    49698    ayar_firma_tipi_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_firma_tipi_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.ayar_firma_tipi_detay_id_seq;
       public       postgres    false    8    204            �           0    0    ayar_firma_tipi_detay_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.ayar_firma_tipi_detay_id_seq OWNED BY public.ayar_firma_tipi_detay.id;
            public       postgres    false    205            �           0    0 %   SEQUENCE ayar_firma_tipi_detay_id_seq    ACL       REVOKE ALL ON SEQUENCE public.ayar_firma_tipi_detay_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_firma_tipi_detay_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_firma_tipi_detay_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_firma_tipi_detay_id_seq TO PUBLIC;
            public       postgres    false    205            �            1259    49700    ayar_firma_tipi_id_seq    SEQUENCE        CREATE SEQUENCE public.ayar_firma_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ayar_firma_tipi_id_seq;
       public       postgres    false    203    8            �           0    0    ayar_firma_tipi_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ayar_firma_tipi_id_seq OWNED BY public.ayar_firma_tipi.id;
            public       postgres    false    206            �           0    0    SEQUENCE ayar_firma_tipi_id_seq    ACL       REVOKE ALL ON SEQUENCE public.ayar_firma_tipi_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_firma_tipi_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_firma_tipi_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_firma_tipi_id_seq TO PUBLIC;
            public       postgres    false    206            {           1259    157696    ayar_fis_tipi    TABLE     �   CREATE TABLE public.ayar_fis_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 !   DROP TABLE public.ayar_fis_tipi;
       public         postgres    false    8            z           1259    157694    ayar_fis_tipi_id_seq    SEQUENCE     }   CREATE SEQUENCE public.ayar_fis_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.ayar_fis_tipi_id_seq;
       public       postgres    false    8    379            �           0    0    ayar_fis_tipi_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.ayar_fis_tipi_id_seq OWNED BY public.ayar_fis_tipi.id;
            public       postgres    false    378            �            1259    49702    ayar_genel_ayarlar    TABLE     (  CREATE TABLE public.ayar_genel_ayarlar (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    donem integer,
    unvan character varying(256),
    vergi_no character varying(10),
    tc_no character varying(11),
    firma_tipi character varying(32),
    diger_ayarlar json
);
 &   DROP TABLE public.ayar_genel_ayarlar;
       public         postgres    false    8            �           0    0    TABLE ayar_genel_ayarlar    ACL     �   REVOKE ALL ON TABLE public.ayar_genel_ayarlar FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_genel_ayarlar FROM postgres;
GRANT ALL ON TABLE public.ayar_genel_ayarlar TO postgres;
GRANT ALL ON TABLE public.ayar_genel_ayarlar TO PUBLIC;
            public       postgres    false    207            �            1259    49709    ayar_genel_ayarlar_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_genel_ayarlar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.ayar_genel_ayarlar_id_seq;
       public       postgres    false    8    207            �           0    0    ayar_genel_ayarlar_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.ayar_genel_ayarlar_id_seq OWNED BY public.ayar_genel_ayarlar.id;
            public       postgres    false    208            �           0    0 "   SEQUENCE ayar_genel_ayarlar_id_seq    ACL       REVOKE ALL ON SEQUENCE public.ayar_genel_ayarlar_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_genel_ayarlar_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_genel_ayarlar_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_genel_ayarlar_id_seq TO PUBLIC;
            public       postgres    false    208                       1259    96411    ayar_hane_sayisi    TABLE     �  CREATE TABLE public.ayar_hane_sayisi (
    id integer NOT NULL,
    validity boolean DEFAULT true,
    hesap_bakiye integer DEFAULT 2,
    alis_miktar integer DEFAULT 2,
    alis_fiyat integer DEFAULT 2,
    alis_tutar integer DEFAULT 2,
    satis_miktar integer DEFAULT 2,
    satis_fiyat integer DEFAULT 2,
    satis_tutar integer DEFAULT 2,
    stok_miktar integer DEFAULT 2,
    stok_fiyat integer DEFAULT 2
);
 $   DROP TABLE public.ayar_hane_sayisi;
       public         postgres    false    8                       1259    96409    ayar_hane_sayisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_hane_sayisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ayar_hane_sayisi_id_seq;
       public       postgres    false    264    8            �           0    0    ayar_hane_sayisi_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ayar_hane_sayisi_id_seq OWNED BY public.ayar_hane_sayisi.id;
            public       postgres    false    263            M           1259    133805    ayar_hesap_tipi    TABLE     �   CREATE TABLE public.ayar_hesap_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16) NOT NULL
);
 #   DROP TABLE public.ayar_hesap_tipi;
       public         postgres    false    8            L           1259    133803    ayar_hesap_tipi_id_seq    SEQUENCE        CREATE SEQUENCE public.ayar_hesap_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ayar_hesap_tipi_id_seq;
       public       postgres    false    8    333            �           0    0    ayar_hesap_tipi_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ayar_hesap_tipi_id_seq OWNED BY public.ayar_hesap_tipi.id;
            public       postgres    false    332            s           1259    157640    ayar_irsaliye_fatura_no_serisi    TABLE     �   CREATE TABLE public.ayar_irsaliye_fatura_no_serisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(8),
    is_fatura boolean DEFAULT false NOT NULL,
    is_irsaliye boolean DEFAULT false NOT NULL
);
 2   DROP TABLE public.ayar_irsaliye_fatura_no_serisi;
       public         postgres    false    8            r           1259    157638 %   ayar_irsaliye_fatura_no_serisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_irsaliye_fatura_no_serisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.ayar_irsaliye_fatura_no_serisi_id_seq;
       public       postgres    false    371    8            �           0    0 %   ayar_irsaliye_fatura_no_serisi_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.ayar_irsaliye_fatura_no_serisi_id_seq OWNED BY public.ayar_irsaliye_fatura_no_serisi.id;
            public       postgres    false    370            u           1259    157653    ayar_irsaliye_no_serisi    TABLE     �   CREATE TABLE public.ayar_irsaliye_no_serisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    irsaliye_seri_id integer NOT NULL,
    deger character varying(16) NOT NULL
);
 +   DROP TABLE public.ayar_irsaliye_no_serisi;
       public         postgres    false    8            t           1259    157651    ayar_irsaliye_no_serisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_irsaliye_no_serisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_irsaliye_no_serisi_id_seq;
       public       postgres    false    8    373            �           0    0    ayar_irsaliye_no_serisi_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_irsaliye_no_serisi_id_seq OWNED BY public.ayar_irsaliye_no_serisi.id;
            public       postgres    false    372            k           1259    157549    ayar_modul_tipi    TABLE     �   CREATE TABLE public.ayar_modul_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16)
);
 #   DROP TABLE public.ayar_modul_tipi;
       public         postgres    false    8            j           1259    157547    ayar_modul_tipi_id_seq    SEQUENCE        CREATE SEQUENCE public.ayar_modul_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ayar_modul_tipi_id_seq;
       public       postgres    false    363    8            �           0    0    ayar_modul_tipi_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ayar_modul_tipi_id_seq OWNED BY public.ayar_modul_tipi.id;
            public       postgres    false    362            y           1259    157685    ayar_musteri_firma_turu    TABLE     �   CREATE TABLE public.ayar_musteri_firma_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(64) NOT NULL
);
 +   DROP TABLE public.ayar_musteri_firma_turu;
       public         postgres    false    8            x           1259    157683    ayar_musteri_firma_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_musteri_firma_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_musteri_firma_turu_id_seq;
       public       postgres    false    8    377            �           0    0    ayar_musteri_firma_turu_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_musteri_firma_turu_id_seq OWNED BY public.ayar_musteri_firma_turu.id;
            public       postgres    false    376            �           1259    217660    ayar_odeme_baslangic_donemi    TABLE     �   CREATE TABLE public.ayar_odeme_baslangic_donemi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL,
    aciklama character varying(64),
    is_active boolean DEFAULT true NOT NULL
);
 /   DROP TABLE public.ayar_odeme_baslangic_donemi;
       public         postgres    false    8            �           1259    217658 "   ayar_odeme_baslangic_donemi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_odeme_baslangic_donemi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.ayar_odeme_baslangic_donemi_id_seq;
       public       postgres    false    407    8            �           0    0 "   ayar_odeme_baslangic_donemi_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.ayar_odeme_baslangic_donemi_id_seq OWNED BY public.ayar_odeme_baslangic_donemi.id;
            public       postgres    false    406            ]           1259    157398    ayar_odeme_sekli    TABLE     >  CREATE TABLE public.ayar_odeme_sekli (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    kod character varying(8),
    odeme_sekli character varying(96) NOT NULL,
    aciklama character varying(512),
    is_efatura boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);
 $   DROP TABLE public.ayar_odeme_sekli;
       public         postgres    false    8            \           1259    157396    ayar_odeme_sekli_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_odeme_sekli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ayar_odeme_sekli_id_seq;
       public       postgres    false    8    349            �           0    0    ayar_odeme_sekli_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ayar_odeme_sekli_id_seq OWNED BY public.ayar_odeme_sekli.id;
            public       postgres    false    348            �           1259    217748    ayar_personel_askerlik_durumu    TABLE     �   CREATE TABLE public.ayar_personel_askerlik_durumu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16) NOT NULL
);
 1   DROP TABLE public.ayar_personel_askerlik_durumu;
       public         postgres    false    8            �           1259    217746 $   ayar_personel_askerlik_durumu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_askerlik_durumu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.ayar_personel_askerlik_durumu_id_seq;
       public       postgres    false    413    8            �           0    0 $   ayar_personel_askerlik_durumu_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.ayar_personel_askerlik_durumu_id_seq OWNED BY public.ayar_personel_askerlik_durumu.id;
            public       postgres    false    412            �           1259    217939 !   ayar_personel_ayrilma_nedeni_tipi    TABLE     �   CREATE TABLE public.ayar_personel_ayrilma_nedeni_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 5   DROP TABLE public.ayar_personel_ayrilma_nedeni_tipi;
       public         postgres    false    8            �           1259    217937 (   ayar_personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_ayrilma_nedeni_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.ayar_personel_ayrilma_nedeni_tipi_id_seq;
       public       postgres    false    441    8            �           0    0 (   ayar_personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.ayar_personel_ayrilma_nedeni_tipi_id_seq OWNED BY public.ayar_personel_ayrilma_nedeni_tipi.id;
            public       postgres    false    440            #           1259    114935    ayar_personel_birim    TABLE     �   CREATE TABLE public.ayar_personel_birim (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    bolum_id integer NOT NULL,
    birim character varying(32) NOT NULL
);
 '   DROP TABLE public.ayar_personel_birim;
       public         postgres    false    8            �           0    0    TABLE ayar_personel_birim    COMMENT     �   COMMENT ON TABLE public.ayar_personel_birim IS 'Personelin şirket içindeki bölüm içindeki birimi(Departman içindeki alt kol)';
            public       postgres    false    291            "           1259    114933    ayar_personel_birim_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_birim_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.ayar_personel_birim_id_seq;
       public       postgres    false    291    8            �           0    0    ayar_personel_birim_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.ayar_personel_birim_id_seq OWNED BY public.ayar_personel_birim.id;
            public       postgres    false    290            !           1259    114924    ayar_personel_bolum    TABLE     �   CREATE TABLE public.ayar_personel_bolum (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    bolum character varying(32) NOT NULL
);
 '   DROP TABLE public.ayar_personel_bolum;
       public         postgres    false    8            �           0    0    TABLE ayar_personel_bolum    COMMENT     u   COMMENT ON TABLE public.ayar_personel_bolum IS 'Personelin şirket içindeki çalıştığı bölüme ait bilgiler';
            public       postgres    false    289                        1259    114922    ayar_personel_bolum_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_bolum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.ayar_personel_bolum_id_seq;
       public       postgres    false    8    289                        0    0    ayar_personel_bolum_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.ayar_personel_bolum_id_seq OWNED BY public.ayar_personel_bolum.id;
            public       postgres    false    288            �           1259    217759    ayar_personel_cinsiyet    TABLE     �   CREATE TABLE public.ayar_personel_cinsiyet (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 *   DROP TABLE public.ayar_personel_cinsiyet;
       public         postgres    false    8            �           1259    217757    ayar_personel_cinsiyet_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_cinsiyet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.ayar_personel_cinsiyet_id_seq;
       public       postgres    false    8    415                       0    0    ayar_personel_cinsiyet_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.ayar_personel_cinsiyet_id_seq OWNED BY public.ayar_personel_cinsiyet.id;
            public       postgres    false    414            �           1259    217849    ayar_personel_dil    TABLE     �   CREATE TABLE public.ayar_personel_dil (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16) NOT NULL
);
 %   DROP TABLE public.ayar_personel_dil;
       public         postgres    false    8            �           1259    217847    ayar_personel_dil_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_dil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.ayar_personel_dil_id_seq;
       public       postgres    false    8    425                       0    0    ayar_personel_dil_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.ayar_personel_dil_id_seq OWNED BY public.ayar_personel_dil.id;
            public       postgres    false    424            �           1259    217860    ayar_personel_dil_seviyesi    TABLE     �   CREATE TABLE public.ayar_personel_dil_seviyesi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16) NOT NULL
);
 .   DROP TABLE public.ayar_personel_dil_seviyesi;
       public         postgres    false    8            �           1259    217858 !   ayar_personel_dil_seviyesi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_dil_seviyesi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_personel_dil_seviyesi_id_seq;
       public       postgres    false    427    8                       0    0 !   ayar_personel_dil_seviyesi_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_personel_dil_seviyesi_id_seq OWNED BY public.ayar_personel_dil_seviyesi.id;
            public       postgres    false    426            �           1259    217737    ayar_personel_egitim_durumu    TABLE     �   CREATE TABLE public.ayar_personel_egitim_durumu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 /   DROP TABLE public.ayar_personel_egitim_durumu;
       public         postgres    false    8            �           1259    217735 "   ayar_personel_egitim_durumu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_egitim_durumu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.ayar_personel_egitim_durumu_id_seq;
       public       postgres    false    411    8                       0    0 "   ayar_personel_egitim_durumu_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.ayar_personel_egitim_durumu_id_seq OWNED BY public.ayar_personel_egitim_durumu.id;
            public       postgres    false    410            �           1259    217882    ayar_personel_ehliyet_tipi    TABLE     �   CREATE TABLE public.ayar_personel_ehliyet_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 .   DROP TABLE public.ayar_personel_ehliyet_tipi;
       public         postgres    false    8            �           1259    217880 !   ayar_personel_ehliyet_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_ehliyet_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_personel_ehliyet_tipi_id_seq;
       public       postgres    false    431    8                       0    0 !   ayar_personel_ehliyet_tipi_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_personel_ehliyet_tipi_id_seq OWNED BY public.ayar_personel_ehliyet_tipi.id;
            public       postgres    false    430            %           1259    114951    ayar_personel_gorev    TABLE     �   CREATE TABLE public.ayar_personel_gorev (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    gorev character varying(32) NOT NULL
);
 '   DROP TABLE public.ayar_personel_gorev;
       public         postgres    false    8                       0    0    TABLE ayar_personel_gorev    COMMENT     W   COMMENT ON TABLE public.ayar_personel_gorev IS 'Personelin şirket içindeki görevi';
            public       postgres    false    293            $           1259    114949    ayar_personel_gorev_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_gorev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.ayar_personel_gorev_id_seq;
       public       postgres    false    293    8                       0    0    ayar_personel_gorev_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.ayar_personel_gorev_id_seq OWNED BY public.ayar_personel_gorev.id;
            public       postgres    false    292            �           1259    217792    ayar_personel_izin_tipi    TABLE     �   CREATE TABLE public.ayar_personel_izin_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 +   DROP TABLE public.ayar_personel_izin_tipi;
       public         postgres    false    8            �           1259    217790    ayar_personel_izin_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_izin_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_personel_izin_tipi_id_seq;
       public       postgres    false    421    8                       0    0    ayar_personel_izin_tipi_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_personel_izin_tipi_id_seq OWNED BY public.ayar_personel_izin_tipi.id;
            public       postgres    false    420            �           1259    217770    ayar_personel_kan_grubu    TABLE     �   CREATE TABLE public.ayar_personel_kan_grubu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 +   DROP TABLE public.ayar_personel_kan_grubu;
       public         postgres    false    8            �           1259    217768    ayar_personel_kan_grubu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_kan_grubu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_personel_kan_grubu_id_seq;
       public       postgres    false    8    417            	           0    0    ayar_personel_kan_grubu_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_personel_kan_grubu_id_seq OWNED BY public.ayar_personel_kan_grubu.id;
            public       postgres    false    416            �           1259    217803    ayar_personel_medeni_durum    TABLE     �   CREATE TABLE public.ayar_personel_medeni_durum (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 .   DROP TABLE public.ayar_personel_medeni_durum;
       public         postgres    false    8            �           1259    217801 !   ayar_personel_medeni_durum_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_medeni_durum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.ayar_personel_medeni_durum_id_seq;
       public       postgres    false    423    8            
           0    0 !   ayar_personel_medeni_durum_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.ayar_personel_medeni_durum_id_seq OWNED BY public.ayar_personel_medeni_durum.id;
            public       postgres    false    422            �           1259    217928    ayar_personel_mektup_tipi    TABLE     �   CREATE TABLE public.ayar_personel_mektup_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 -   DROP TABLE public.ayar_personel_mektup_tipi;
       public         postgres    false    8            �           1259    217926     ayar_personel_mektup_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_mektup_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.ayar_personel_mektup_tipi_id_seq;
       public       postgres    false    8    439                       0    0     ayar_personel_mektup_tipi_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.ayar_personel_mektup_tipi_id_seq OWNED BY public.ayar_personel_mektup_tipi.id;
            public       postgres    false    438            �           1259    217893    ayar_personel_myk_tipi    TABLE     �   CREATE TABLE public.ayar_personel_myk_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 *   DROP TABLE public.ayar_personel_myk_tipi;
       public         postgres    false    8            �           1259    217891    ayar_personel_myk_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_myk_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.ayar_personel_myk_tipi_id_seq;
       public       postgres    false    433    8                       0    0    ayar_personel_myk_tipi_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.ayar_personel_myk_tipi_id_seq OWNED BY public.ayar_personel_myk_tipi.id;
            public       postgres    false    432            �           1259    217781    ayar_personel_rapor_tipi    TABLE     �   CREATE TABLE public.ayar_personel_rapor_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 ,   DROP TABLE public.ayar_personel_rapor_tipi;
       public         postgres    false    8            �           1259    217779    ayar_personel_rapor_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_rapor_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.ayar_personel_rapor_tipi_id_seq;
       public       postgres    false    419    8                       0    0    ayar_personel_rapor_tipi_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.ayar_personel_rapor_tipi_id_seq OWNED BY public.ayar_personel_rapor_tipi.id;
            public       postgres    false    418            �           1259    217904    ayar_personel_src_tipi    TABLE     �   CREATE TABLE public.ayar_personel_src_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 *   DROP TABLE public.ayar_personel_src_tipi;
       public         postgres    false    8            �           1259    217902    ayar_personel_src_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_src_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.ayar_personel_src_tipi_id_seq;
       public       postgres    false    435    8                       0    0    ayar_personel_src_tipi_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.ayar_personel_src_tipi_id_seq OWNED BY public.ayar_personel_src_tipi.id;
            public       postgres    false    434            �           1259    217915    ayar_personel_tatil_tipi    TABLE     �   CREATE TABLE public.ayar_personel_tatil_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL,
    is_resmi_tatil boolean DEFAULT true NOT NULL
);
 ,   DROP TABLE public.ayar_personel_tatil_tipi;
       public         postgres    false    8            �           1259    217913    ayar_personel_tatil_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_tatil_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.ayar_personel_tatil_tipi_id_seq;
       public       postgres    false    437    8                       0    0    ayar_personel_tatil_tipi_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.ayar_personel_tatil_tipi_id_seq OWNED BY public.ayar_personel_tatil_tipi.id;
            public       postgres    false    436            �           1259    217690    ayar_personel_tipi    TABLE     �   CREATE TABLE public.ayar_personel_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);
 &   DROP TABLE public.ayar_personel_tipi;
       public         postgres    false    8                       0    0    TABLE ayar_personel_tipi    COMMENT     Z   COMMENT ON TABLE public.ayar_personel_tipi IS 'Personelin tipi (Beyaz Yaka - Mavi Yaka)';
            public       postgres    false    409            �           1259    217688    ayar_personel_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_personel_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.ayar_personel_tipi_id_seq;
       public       postgres    false    409    8                       0    0    ayar_personel_tipi_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.ayar_personel_tipi_id_seq OWNED BY public.ayar_personel_tipi.id;
            public       postgres    false    408            �            1259    49726    ayar_sabit_degisken    TABLE     �   CREATE TABLE public.ayar_sabit_degisken (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(16) NOT NULL
);
 '   DROP TABLE public.ayar_sabit_degisken;
       public         postgres    false    8                       0    0    TABLE ayar_sabit_degisken    ACL     �   REVOKE ALL ON TABLE public.ayar_sabit_degisken FROM PUBLIC;
REVOKE ALL ON TABLE public.ayar_sabit_degisken FROM postgres;
GRANT ALL ON TABLE public.ayar_sabit_degisken TO postgres;
GRANT ALL ON TABLE public.ayar_sabit_degisken TO PUBLIC;
            public       postgres    false    209            �            1259    49730    ayar_sabit_degisken_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_sabit_degisken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.ayar_sabit_degisken_id_seq;
       public       postgres    false    8    209                       0    0    ayar_sabit_degisken_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.ayar_sabit_degisken_id_seq OWNED BY public.ayar_sabit_degisken.id;
            public       postgres    false    210                       0    0 #   SEQUENCE ayar_sabit_degisken_id_seq    ACL       REVOKE ALL ON SEQUENCE public.ayar_sabit_degisken_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.ayar_sabit_degisken_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.ayar_sabit_degisken_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.ayar_sabit_degisken_id_seq TO PUBLIC;
            public       postgres    false    210                       1259    157724    ayar_sevkiyat_hazirlama_durumu    TABLE     �   CREATE TABLE public.ayar_sevkiyat_hazirlama_durumu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL
);
 2   DROP TABLE public.ayar_sevkiyat_hazirlama_durumu;
       public         postgres    false    8            ~           1259    157722 %   ayar_sevkiyat_hazirlama_durumu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_sevkiyat_hazirlama_durumu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.ayar_sevkiyat_hazirlama_durumu_id_seq;
       public       postgres    false    383    8                       0    0 %   ayar_sevkiyat_hazirlama_durumu_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.ayar_sevkiyat_hazirlama_durumu_id_seq OWNED BY public.ayar_sevkiyat_hazirlama_durumu.id;
            public       postgres    false    382            �           1259    157735    ayar_stok_hareket_ayari    TABLE     �   CREATE TABLE public.ayar_stok_hareket_ayari (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    giris_ayari character varying(16),
    cikis_ayari character varying(16)
);
 +   DROP TABLE public.ayar_stok_hareket_ayari;
       public         postgres    false    8            �           1259    157733    ayar_stok_hareket_ayari_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_stok_hareket_ayari_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.ayar_stok_hareket_ayari_id_seq;
       public       postgres    false    8    385                       0    0    ayar_stok_hareket_ayari_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.ayar_stok_hareket_ayari_id_seq OWNED BY public.ayar_stok_hareket_ayari.id;
            public       postgres    false    384                       1259    103326    ayar_stok_hareket_tipi    TABLE     �   CREATE TABLE public.ayar_stok_hareket_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(8) NOT NULL,
    is_input boolean DEFAULT false NOT NULL
);
 *   DROP TABLE public.ayar_stok_hareket_tipi;
       public         postgres    false    8                       1259    103324    ayar_stok_hareket_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_stok_hareket_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.ayar_stok_hareket_tipi_id_seq;
       public       postgres    false    276    8                       0    0    ayar_stok_hareket_tipi_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.ayar_stok_hareket_tipi_id_seq OWNED BY public.ayar_stok_hareket_tipi.id;
            public       postgres    false    275            �           1259    184698    ayar_teklif_durum    TABLE     �   CREATE TABLE public.ayar_teklif_durum (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL,
    aciklama character varying(64),
    is_active boolean DEFAULT true NOT NULL
);
 %   DROP TABLE public.ayar_teklif_durum;
       public         postgres    false    8            �           1259    184696    ayar_teklif_durum_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_teklif_durum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.ayar_teklif_durum_id_seq;
       public       postgres    false    8    399                       0    0    ayar_teklif_durum_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.ayar_teklif_durum_id_seq OWNED BY public.ayar_teklif_durum.id;
            public       postgres    false    398            �           1259    217648    ayar_teklif_tipi    TABLE     �   CREATE TABLE public.ayar_teklif_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(32) NOT NULL,
    aciklama character varying(64),
    is_active boolean DEFAULT true NOT NULL
);
 $   DROP TABLE public.ayar_teklif_tipi;
       public         postgres    false    8            �           1259    217646    ayar_teklif_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_teklif_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ayar_teklif_tipi_id_seq;
       public       postgres    false    405    8                       0    0    ayar_teklif_tipi_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ayar_teklif_tipi_id_seq OWNED BY public.ayar_teklif_tipi.id;
            public       postgres    false    404            '           1259    114975    ayar_vergi_orani    TABLE     �   CREATE TABLE public.ayar_vergi_orani (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    vergi_orani double precision NOT NULL,
    vergi_hesap_kodu character varying(16) NOT NULL
);
 $   DROP TABLE public.ayar_vergi_orani;
       public         postgres    false    8            &           1259    114973    ayar_vergi_orani_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ayar_vergi_orani_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.ayar_vergi_orani_id_seq;
       public       postgres    false    8    295                       0    0    ayar_vergi_orani_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.ayar_vergi_orani_id_seq OWNED BY public.ayar_vergi_orani.id;
            public       postgres    false    294                       1259    88300    banka    TABLE     �   CREATE TABLE public.banka (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    adi character varying(64) NOT NULL,
    swift_kodu character varying(16),
    is_active boolean DEFAULT true NOT NULL
);
    DROP TABLE public.banka;
       public         postgres    false    8                       1259    88298    banka_id_seq    SEQUENCE     u   CREATE SEQUENCE public.banka_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.banka_id_seq;
       public       postgres    false    262    8                       0    0    banka_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.banka_id_seq OWNED BY public.banka.id;
            public       postgres    false    261            A           1259    131292    banka_subesi    TABLE     �   CREATE TABLE public.banka_subesi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    banka_id integer NOT NULL,
    sube_kodu integer NOT NULL,
    sube_adi character varying(64) NOT NULL,
    sube_il_id integer NOT NULL
);
     DROP TABLE public.banka_subesi;
       public         postgres    false    8            @           1259    131290    banka_subesi_id_seq    SEQUENCE     |   CREATE SEQUENCE public.banka_subesi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.banka_subesi_id_seq;
       public       postgres    false    8    321                       0    0    banka_subesi_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.banka_subesi_id_seq OWNED BY public.banka_subesi.id;
            public       postgres    false    320            K           1259    133704    barkod_hazirlik_dosya_turu    TABLE     �   CREATE TABLE public.barkod_hazirlik_dosya_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(32)
);
 .   DROP TABLE public.barkod_hazirlik_dosya_turu;
       public         postgres    false    8            J           1259    133702 !   barkod_hazirlik_dosya_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.barkod_hazirlik_dosya_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.barkod_hazirlik_dosya_turu_id_seq;
       public       postgres    false    8    331                       0    0 !   barkod_hazirlik_dosya_turu_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.barkod_hazirlik_dosya_turu_id_seq OWNED BY public.barkod_hazirlik_dosya_turu.id;
            public       postgres    false    330            G           1259    133675    barkod_serino_turu    TABLE     �   CREATE TABLE public.barkod_serino_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(4),
    aciklama character varying(32)
);
 &   DROP TABLE public.barkod_serino_turu;
       public         postgres    false    8            F           1259    133673    barkod_serino_turu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.barkod_serino_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.barkod_serino_turu_id_seq;
       public       postgres    false    327    8                       0    0    barkod_serino_turu_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.barkod_serino_turu_id_seq OWNED BY public.barkod_serino_turu.id;
            public       postgres    false    326            I           1259    133687    barkod_tezgah    TABLE     �   CREATE TABLE public.barkod_tezgah (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tezgah_adi character varying(32) NOT NULL,
    ambar_id integer NOT NULL
);
 !   DROP TABLE public.barkod_tezgah;
       public         postgres    false    8            H           1259    133685    barkod_tezgah_id_seq    SEQUENCE     }   CREATE SEQUENCE public.barkod_tezgah_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.barkod_tezgah_id_seq;
       public       postgres    false    8    329                       0    0    barkod_tezgah_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.barkod_tezgah_id_seq OWNED BY public.barkod_tezgah.id;
            public       postgres    false    328            )           1259    114990    bolge    TABLE     F  CREATE TABLE public.bolge (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    bolge_adi character varying(24) NOT NULL,
    bolge_turu_id character varying(24),
    hedef_ocak double precision DEFAULT 0 NOT NULL,
    hedef_subat double precision DEFAULT 0 NOT NULL,
    hedef_mart double precision DEFAULT 0 NOT NULL,
    hedef_nisan double precision DEFAULT 0 NOT NULL,
    hedef_mayis double precision DEFAULT 0 NOT NULL,
    hedef_haziran double precision DEFAULT 0 NOT NULL,
    hedef_temmuz double precision DEFAULT 0 NOT NULL,
    hedef_agustos double precision DEFAULT 0 NOT NULL,
    hedef_eylul double precision DEFAULT 0 NOT NULL,
    hedef_ekim double precision DEFAULT 0 NOT NULL,
    hedef_kasim double precision DEFAULT 0 NOT NULL,
    hedef_aralik double precision DEFAULT 0 NOT NULL,
    hedef_mamul_ocak double precision DEFAULT 0 NOT NULL,
    hedef_mamul_subat double precision DEFAULT 0 NOT NULL,
    hedef_mamul_mart double precision DEFAULT 0 NOT NULL,
    hedef_mamul_nisan double precision DEFAULT 0 NOT NULL,
    hedef_mamul_mayis double precision DEFAULT 0 NOT NULL,
    hedef_mamul_haziran double precision DEFAULT 0 NOT NULL,
    hedef_mamul_temmuz double precision DEFAULT 0 NOT NULL,
    hedef_mamul_agustos double precision DEFAULT 0 NOT NULL,
    hedef_mamul_eylul double precision DEFAULT 0 NOT NULL,
    hedef_mamul_ekim double precision DEFAULT 0 NOT NULL,
    hedef_mamul_kasim double precision DEFAULT 0 NOT NULL,
    hedef_mamul_aralik double precision DEFAULT 0 NOT NULL,
    gecen_ocak double precision DEFAULT 0 NOT NULL,
    gecen_subat double precision DEFAULT 0 NOT NULL,
    gecen_mart double precision DEFAULT 0 NOT NULL,
    gecen_nisan double precision DEFAULT 0 NOT NULL,
    gecen_mayis double precision DEFAULT 0 NOT NULL,
    gecen_haziran double precision DEFAULT 0 NOT NULL,
    gecen_temmuz double precision DEFAULT 0 NOT NULL,
    gecen_agustos double precision DEFAULT 0 NOT NULL,
    gecen_eylul double precision DEFAULT 0 NOT NULL,
    gecen_ekim double precision DEFAULT 0 NOT NULL,
    gecen_kasim double precision DEFAULT 0 NOT NULL,
    gecen_aralik double precision DEFAULT 0 NOT NULL,
    gecen_mamul_ocak double precision DEFAULT 0 NOT NULL,
    gecen_mamul_subat double precision DEFAULT 0 NOT NULL,
    gecen_mamul_mart double precision DEFAULT 0 NOT NULL,
    gecen_mamul_nisan double precision DEFAULT 0 NOT NULL,
    gecen_mamul_mayis double precision DEFAULT 0 NOT NULL,
    gecen_mamul_haziran double precision DEFAULT 0 NOT NULL,
    gecen_mamul_temmuz double precision DEFAULT 0 NOT NULL,
    gecen_mamul_agustos double precision DEFAULT 0 NOT NULL,
    gecen_mamul_eylul double precision DEFAULT 0 NOT NULL,
    gecen_mamul_ekim double precision DEFAULT 0 NOT NULL,
    gecen_mamul_kasim double precision DEFAULT 0 NOT NULL,
    gecen_mamul_aralik double precision DEFAULT 0 NOT NULL
);
    DROP TABLE public.bolge;
       public         postgres    false    8            (           1259    114988    bolge_id_seq    SEQUENCE     u   CREATE SEQUENCE public.bolge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.bolge_id_seq;
       public       postgres    false    8    297                        0    0    bolge_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.bolge_id_seq OWNED BY public.bolge.id;
            public       postgres    false    296            �            1259    49744 
   bolge_turu    TABLE     �   CREATE TABLE public.bolge_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tur character varying(32) NOT NULL
);
    DROP TABLE public.bolge_turu;
       public         postgres    false    8            !           0    0    TABLE bolge_turu    ACL     �   REVOKE ALL ON TABLE public.bolge_turu FROM PUBLIC;
REVOKE ALL ON TABLE public.bolge_turu FROM postgres;
GRANT ALL ON TABLE public.bolge_turu TO postgres;
GRANT ALL ON TABLE public.bolge_turu TO PUBLIC;
            public       postgres    false    211            �            1259    49748    bolge_turu_id_seq    SEQUENCE     z   CREATE SEQUENCE public.bolge_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.bolge_turu_id_seq;
       public       postgres    false    8    211            "           0    0    bolge_turu_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.bolge_turu_id_seq OWNED BY public.bolge_turu.id;
            public       postgres    false    212            #           0    0    SEQUENCE bolge_turu_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.bolge_turu_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.bolge_turu_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.bolge_turu_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.bolge_turu_id_seq TO PUBLIC;
            public       postgres    false    212            C           1259    131329    cins_ailesi    TABLE     �   CREATE TABLE public.cins_ailesi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    aile character varying(16) NOT NULL
);
    DROP TABLE public.cins_ailesi;
       public         postgres    false    8            B           1259    131327    cins_ailesi_id_seq    SEQUENCE     {   CREATE SEQUENCE public.cins_ailesi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.cins_ailesi_id_seq;
       public       postgres    false    323    8            $           0    0    cins_ailesi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.cins_ailesi_id_seq OWNED BY public.cins_ailesi.id;
            public       postgres    false    322            E           1259    131382    cins_ozelligi    TABLE     �  CREATE TABLE public.cins_ozelligi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    cins_aile_id integer NOT NULL,
    cins character varying(32) NOT NULL,
    aciklama character varying(128),
    string1 character varying(24),
    string2 character varying(24),
    string3 character varying(24),
    string4 character varying(24),
    string5 character varying(24),
    string6 character varying(24),
    string7 character varying(24),
    string8 character varying(24),
    string9 character varying(24),
    string10 character varying(16),
    string11 character varying(16),
    string12 character varying(16),
    is_serino_icerir boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.cins_ozelligi;
       public         postgres    false    8            D           1259    131380    cins_ozelligi_id_seq    SEQUENCE     }   CREATE SEQUENCE public.cins_ozelligi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.cins_ozelligi_id_seq;
       public       postgres    false    8    325            %           0    0    cins_ozelligi_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.cins_ozelligi_id_seq OWNED BY public.cins_ozelligi.id;
            public       postgres    false    324            ?           1259    123264 
   doviz_kuru    TABLE     �   CREATE TABLE public.doviz_kuru (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tarih date NOT NULL,
    para_birimi character varying(3) NOT NULL,
    kur double precision NOT NULL
);
    DROP TABLE public.doviz_kuru;
       public         postgres    false    8            >           1259    123262    doviz_kuru_id_seq    SEQUENCE     z   CREATE SEQUENCE public.doviz_kuru_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.doviz_kuru_id_seq;
       public       postgres    false    8    319            &           0    0    doviz_kuru_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.doviz_kuru_id_seq OWNED BY public.doviz_kuru.id;
            public       postgres    false    318            �            1259    49768    hesap    TABLE     �  CREATE TABLE public.hesap (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    firma_tipi character varying(32),
    firma_tipi_detay character varying(64),
    hesap_kodu character varying(16) NOT NULL,
    hesap_ismi character varying(128) NOT NULL,
    mukellef_tipi character varying(8),
    hesap_grubu character varying(16),
    yetkili_adi character varying(32),
    yetkili_soyadi character varying(32),
    tel1 character varying(16),
    tel2 character varying(16),
    tel3 character varying(16),
    faks1 character varying(16),
    faks2 character varying(16),
    faks3 character varying(16),
    web_uri character varying(48),
    eposta character varying(80),
    muhasebe_tel character varying(16),
    muhasebe_eposta character varying(80),
    sokak character varying(40),
    cadde character varying(40),
    mahalle character varying(40),
    ilce character varying(32),
    sehir character varying(24),
    bolge character varying(32),
    bina character varying(40),
    kapi_no character varying(6),
    posta_kutusu character varying(8),
    posta_kodu character varying(7),
    ulke character varying(32),
    vergi_dairesi character varying(32),
    vergi_no character varying(32),
    nace_kodu character varying(16),
    iskonto double precision DEFAULT 0 NOT NULL,
    muhasebe_kodu character varying(16),
    ana_hesap_muhasebe_kodu character varying(16),
    plan_kodu character varying(3),
    ozel_bilgi character varying(400),
    para_birimi character varying(3) DEFAULT public.get_default_para_birimi() NOT NULL,
    temsilci character varying(64),
    ortalama_vade character varying,
    is_efatura boolean DEFAULT false NOT NULL
);
    DROP TABLE public.hesap;
       public         postgres    false    502    8            '           0    0    TABLE hesap    ACL     ^   REVOKE ALL ON TABLE public.hesap FROM PUBLIC;
REVOKE ALL ON TABLE public.hesap FROM postgres;
            public       postgres    false    213            �            1259    49778    hesap_grubu    TABLE     �   CREATE TABLE public.hesap_grubu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    grup character varying(16) NOT NULL
);
    DROP TABLE public.hesap_grubu;
       public         postgres    false    8            (           0    0    TABLE hesap_grubu    ACL     �   REVOKE ALL ON TABLE public.hesap_grubu FROM PUBLIC;
REVOKE ALL ON TABLE public.hesap_grubu FROM postgres;
GRANT ALL ON TABLE public.hesap_grubu TO postgres;
GRANT ALL ON TABLE public.hesap_grubu TO PUBLIC;
            public       postgres    false    214            �            1259    49782    hesap_grubu_id_seq    SEQUENCE     {   CREATE SEQUENCE public.hesap_grubu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.hesap_grubu_id_seq;
       public       postgres    false    214    8            )           0    0    hesap_grubu_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.hesap_grubu_id_seq OWNED BY public.hesap_grubu.id;
            public       postgres    false    215            *           0    0    SEQUENCE hesap_grubu_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.hesap_grubu_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.hesap_grubu_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.hesap_grubu_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.hesap_grubu_id_seq TO PUBLIC;
            public       postgres    false    215            �            1259    49784    hesap_id_seq    SEQUENCE     u   CREATE SEQUENCE public.hesap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.hesap_id_seq;
       public       postgres    false    213    8            +           0    0    hesap_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.hesap_id_seq OWNED BY public.hesap.id;
            public       postgres    false    216            ,           0    0    SEQUENCE hesap_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.hesap_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.hesap_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.hesap_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.hesap_id_seq TO PUBLIC;
            public       postgres    false    216            +           1259    115049    hesap_karti    TABLE     �  CREATE TABLE public.hesap_karti (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    hesap_kodu character varying(16) NOT NULL,
    hesap_ismi character varying(128) NOT NULL,
    hesap_grubu_id character varying(16),
    yetkili character varying(32),
    tel1 character varying(24),
    tel2 character varying(24),
    tel3 character varying(24),
    faks character varying(24),
    hesap_iskonto double precision DEFAULT 0 NOT NULL,
    ozel_bilgi character varying(512),
    para_birimi character varying(3) NOT NULL,
    hesap_tipi character varying(8) NOT NULL,
    temsilci_id integer,
    bolge_id integer,
    muhasebe_kodu character varying(16),
    gecmis_donem_ciro double precision,
    kredi_limiti double precision,
    e_fatura_hesabi boolean DEFAULT false NOT NULL,
    doviz_hesabi boolean,
    odeme_vadesi integer,
    varsayilan_musteri boolean DEFAULT false NOT NULL,
    varsayilan_satici boolean DEFAULT false NOT NULL,
    is_sair_hesap boolean DEFAULT false NOT NULL,
    vergi_dairesi character varying(32),
    vergi_no character varying(16),
    mukellef_tipi character varying(8),
    nace_kodu character varying(16),
    web_sitesi character varying(48),
    eposta_adresi character varying(80),
    ulke_kodu_id integer,
    sehir_id integer,
    ilce character varying(32),
    mahalle character varying(40),
    cadde character varying(40),
    sokak character varying(40),
    bina character varying(40),
    kapi_no character varying(6),
    posta_kutusu character varying(8),
    posta_kodu character varying(7),
    statu character varying(10),
    iban_no character varying(32),
    iban_para_birimi character varying(3),
    hesap_kategori character varying(1),
    person_first_name character varying(32),
    person_family_name character varying(32),
    person_middle_name character varying(32),
    muhasebe_eposta character varying(80),
    muhasebe_tel character varying(16),
    temsilci_grubu_id integer
);
    DROP TABLE public.hesap_karti;
       public         postgres    false    8            *           1259    115047    hesap_karti_id_seq    SEQUENCE     {   CREATE SEQUENCE public.hesap_karti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.hesap_karti_id_seq;
       public       postgres    false    8    299            -           0    0    hesap_karti_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.hesap_karti_id_seq OWNED BY public.hesap_karti.id;
            public       postgres    false    298            �            1259    49786    hesap_plani    TABLE     �   CREATE TABLE public.hesap_plani (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    plan_kodu character varying(3) NOT NULL,
    seviye_sayisi smallint NOT NULL
);
    DROP TABLE public.hesap_plani;
       public         postgres    false    8            .           0    0    TABLE hesap_plani    ACL     �   REVOKE ALL ON TABLE public.hesap_plani FROM PUBLIC;
REVOKE ALL ON TABLE public.hesap_plani FROM postgres;
GRANT ALL ON TABLE public.hesap_plani TO postgres;
GRANT ALL ON TABLE public.hesap_plani TO PUBLIC;
            public       postgres    false    217            �            1259    49790    hesap_plani_id_seq    SEQUENCE     {   CREATE SEQUENCE public.hesap_plani_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.hesap_plani_id_seq;
       public       postgres    false    8    217            /           0    0    hesap_plani_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.hesap_plani_id_seq OWNED BY public.hesap_plani.id;
            public       postgres    false    218            0           0    0    SEQUENCE hesap_plani_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.hesap_plani_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.hesap_plani_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.hesap_plani_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.hesap_plani_id_seq TO PUBLIC;
            public       postgres    false    218                       1259    114913    medeni_durum    TABLE     �   CREATE TABLE public.medeni_durum (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    durum character varying(16) NOT NULL
);
     DROP TABLE public.medeni_durum;
       public         postgres    false    8            1           0    0    TABLE medeni_durum    COMMENT     F   COMMENT ON TABLE public.medeni_durum IS 'Medeni Durumu (Evli-Bekar)';
            public       postgres    false    287                       1259    114911    medeni_durum_id_seq    SEQUENCE     |   CREATE SEQUENCE public.medeni_durum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.medeni_durum_id_seq;
       public       postgres    false    287    8            2           0    0    medeni_durum_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.medeni_durum_id_seq OWNED BY public.medeni_durum.id;
            public       postgres    false    286            �            1259    49792    muhasebe_hesap_plani    TABLE     �   CREATE TABLE public.muhasebe_hesap_plani (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    plan_kodu character varying(3) NOT NULL,
    seviye_sayisi smallint NOT NULL
);
 (   DROP TABLE public.muhasebe_hesap_plani;
       public         postgres    false    8            3           0    0    TABLE muhasebe_hesap_plani    ACL     �   REVOKE ALL ON TABLE public.muhasebe_hesap_plani FROM PUBLIC;
REVOKE ALL ON TABLE public.muhasebe_hesap_plani FROM postgres;
GRANT ALL ON TABLE public.muhasebe_hesap_plani TO postgres;
GRANT ALL ON TABLE public.muhasebe_hesap_plani TO PUBLIC;
            public       postgres    false    219            �            1259    49796    muhasebe_hesap_plani_id_seq    SEQUENCE     �   CREATE SEQUENCE public.muhasebe_hesap_plani_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.muhasebe_hesap_plani_id_seq;
       public       postgres    false    219    8            4           0    0    muhasebe_hesap_plani_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.muhasebe_hesap_plani_id_seq OWNED BY public.muhasebe_hesap_plani.id;
            public       postgres    false    220            5           0    0 $   SEQUENCE muhasebe_hesap_plani_id_seq    ACL       REVOKE ALL ON SEQUENCE public.muhasebe_hesap_plani_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.muhasebe_hesap_plani_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.muhasebe_hesap_plani_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.muhasebe_hesap_plani_id_seq TO PUBLIC;
            public       postgres    false    220            -           1259    123081    olcu_birimi    TABLE       CREATE TABLE public.olcu_birimi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    birim character varying(16) NOT NULL,
    efatura_birim character varying(3),
    birim_aciklama character varying(64),
    is_float_tip boolean DEFAULT false NOT NULL
);
    DROP TABLE public.olcu_birimi;
       public         postgres    false    8            ,           1259    123079    olcu_birimi_id_seq    SEQUENCE     {   CREATE SEQUENCE public.olcu_birimi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.olcu_birimi_id_seq;
       public       postgres    false    301    8            6           0    0    olcu_birimi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.olcu_birimi_id_seq OWNED BY public.olcu_birimi.id;
            public       postgres    false    300            
           1259    96431    para_birimi    TABLE     �   CREATE TABLE public.para_birimi (
    id integer NOT NULL,
    kod character varying(3) NOT NULL,
    sembol character varying(3) NOT NULL,
    aciklama character varying(128),
    is_varsayilan boolean DEFAULT false NOT NULL
);
    DROP TABLE public.para_birimi;
       public         postgres    false    8            7           0    0    TABLE para_birimi    ACL     �   REVOKE ALL ON TABLE public.para_birimi FROM PUBLIC;
REVOKE ALL ON TABLE public.para_birimi FROM postgres;
GRANT ALL ON TABLE public.para_birimi TO postgres;
GRANT ALL ON TABLE public.para_birimi TO PUBLIC;
            public       postgres    false    266            	           1259    96429    para_birimi_id_seq    SEQUENCE     {   CREATE SEQUENCE public.para_birimi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.para_birimi_id_seq;
       public       postgres    false    266    8            8           0    0    para_birimi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.para_birimi_id_seq OWNED BY public.para_birimi.id;
            public       postgres    false    265            �            1259    49812    personel_ayrilma_nedeni_tipi    TABLE     �   CREATE TABLE public.personel_ayrilma_nedeni_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tip character varying(32)
);
 0   DROP TABLE public.personel_ayrilma_nedeni_tipi;
       public         postgres    false    8            9           0    0 "   TABLE personel_ayrilma_nedeni_tipi    ACL       REVOKE ALL ON TABLE public.personel_ayrilma_nedeni_tipi FROM PUBLIC;
REVOKE ALL ON TABLE public.personel_ayrilma_nedeni_tipi FROM postgres;
GRANT ALL ON TABLE public.personel_ayrilma_nedeni_tipi TO postgres;
GRANT ALL ON TABLE public.personel_ayrilma_nedeni_tipi TO PUBLIC;
            public       postgres    false    221            �            1259    49816 #   personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq;
       public       postgres    false    8    221            :           0    0 #   personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq OWNED BY public.personel_ayrilma_nedeni_tipi.id;
            public       postgres    false    222            ;           0    0 ,   SEQUENCE personel_ayrilma_nedeni_tipi_id_seq    ACL     :  REVOKE ALL ON SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.personel_ayrilma_nedeni_tipi_id_seq TO PUBLIC;
            public       postgres    false    222            �            1259    49841    personel_calisma_gecmisi    TABLE     �  CREATE TABLE public.personel_calisma_gecmisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    personel_id integer,
    personel_birim character varying(32),
    personel_gorev character varying(32),
    ise_giris_tarihi date NOT NULL,
    isten_cikis_tarihi date,
    ayrilma_nedeni_tipi character varying(32),
    ayrilma_nedeni_aciklama character varying(80)
);
 ,   DROP TABLE public.personel_calisma_gecmisi;
       public         postgres    false    8            <           0    0    TABLE personel_calisma_gecmisi    ACL     �  REVOKE ALL ON TABLE public.personel_calisma_gecmisi FROM PUBLIC;
REVOKE ALL ON TABLE public.personel_calisma_gecmisi FROM postgres;
GRANT ALL ON TABLE public.personel_calisma_gecmisi TO postgres;
GRANT ALL ON TABLE public.personel_calisma_gecmisi TO elektromed_admin;
GRANT ALL ON TABLE public.personel_calisma_gecmisi TO PUBLIC;
GRANT ALL ON TABLE public.personel_calisma_gecmisi TO guest;
            public       postgres    false    223            �            1259    49845    personel_calisma_gecmisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_calisma_gecmisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.personel_calisma_gecmisi_id_seq;
       public       postgres    false    8    223            =           0    0    personel_calisma_gecmisi_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.personel_calisma_gecmisi_id_seq OWNED BY public.personel_calisma_gecmisi.id;
            public       postgres    false    224            >           0    0 (   SEQUENCE personel_calisma_gecmisi_id_seq    ACL     *  REVOKE ALL ON SEQUENCE public.personel_calisma_gecmisi_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.personel_calisma_gecmisi_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.personel_calisma_gecmisi_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.personel_calisma_gecmisi_id_seq TO PUBLIC;
            public       postgres    false    224            �           1259    217871    personel_dil_bilgisi    TABLE     �   CREATE TABLE public.personel_dil_bilgisi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    dil_id integer,
    okuma_seviyesi_id integer,
    yazma_seviyesi_id integer,
    konusma_seviyesi_id integer,
    personel_id integer
);
 (   DROP TABLE public.personel_dil_bilgisi;
       public         postgres    false    8            �           1259    217869    personel_dil_bilgisi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_dil_bilgisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.personel_dil_bilgisi_id_seq;
       public       postgres    false    8    429            ?           0    0    personel_dil_bilgisi_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.personel_dil_bilgisi_id_seq OWNED BY public.personel_dil_bilgisi.id;
            public       postgres    false    428            �           1259    217953    personel_karti    TABLE     �  CREATE TABLE public.personel_karti (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    personel_ad character varying(32) NOT NULL,
    personel_soyad character varying(32) NOT NULL,
    telefon1 character varying(24) NOT NULL,
    telefon2 character varying(24),
    personel_tipi_id integer NOT NULL,
    birim_id integer NOT NULL,
    gorev_id integer NOT NULL,
    mail_adresi character varying(64),
    dogum_tarihi date NOT NULL,
    kan_grubu_id integer NOT NULL,
    cinsiyet_id integer NOT NULL,
    askerlik_durumu_id integer,
    medeni_durumu_id integer NOT NULL,
    cocuk_sayisi integer DEFAULT 0 NOT NULL,
    yakin_ad_soyad character varying(48),
    yakin_telefon character varying(24),
    ev_adresi character varying(256),
    ayakkabi_no integer,
    elbise_bedeni character varying(8),
    genel_not character varying(256),
    servis_id integer,
    personel_gecmisi_id integer,
    ozel_not character varying(256),
    brut_maas double precision DEFAULT 0 NOT NULL,
    ikramiye_sayisi integer,
    ikramiye_miktar double precision,
    tc_kimlik_no character varying(11),
    personel_ad_soyad character varying(64),
    bolum_id integer
);
 "   DROP TABLE public.personel_karti;
       public         postgres    false    8            �           1259    217951    personel_karti_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.personel_karti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.personel_karti_id_seq;
       public       postgres    false    8    443            @           0    0    personel_karti_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.personel_karti_id_seq OWNED BY public.personel_karti.id;
            public       postgres    false    442            �            1259    49853    personel_tasima_servis    TABLE     �   CREATE TABLE public.personel_tasima_servis (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    servis_no smallint NOT NULL,
    servis_adi character varying(32) NOT NULL,
    rota character varying[]
);
 *   DROP TABLE public.personel_tasima_servis;
       public         postgres    false    8            A           0    0    TABLE personel_tasima_servis    ACL     �   REVOKE ALL ON TABLE public.personel_tasima_servis FROM PUBLIC;
REVOKE ALL ON TABLE public.personel_tasima_servis FROM postgres;
GRANT ALL ON TABLE public.personel_tasima_servis TO postgres;
GRANT ALL ON TABLE public.personel_tasima_servis TO PUBLIC;
            public       postgres    false    225            �            1259    49860    personel_tasima_servis_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_tasima_servis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personel_tasima_servis_id_seq;
       public       postgres    false    8    225            B           0    0    personel_tasima_servis_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personel_tasima_servis_id_seq OWNED BY public.personel_tasima_servis.id;
            public       postgres    false    226            C           0    0 &   SEQUENCE personel_tasima_servis_id_seq    ACL     "  REVOKE ALL ON SEQUENCE public.personel_tasima_servis_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.personel_tasima_servis_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.personel_tasima_servis_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.personel_tasima_servis_id_seq TO PUBLIC;
            public       postgres    false    226            1           1259    123117    quality_form_mail_reciever    TABLE     �   CREATE TABLE public.quality_form_mail_reciever (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    mail_adresi character varying(128) NOT NULL
);
 .   DROP TABLE public.quality_form_mail_reciever;
       public         postgres    false    8            0           1259    123115 !   quality_form_mail_reciever_id_seq    SEQUENCE     �   CREATE SEQUENCE public.quality_form_mail_reciever_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.quality_form_mail_reciever_id_seq;
       public       postgres    false    8    305            D           0    0 !   quality_form_mail_reciever_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.quality_form_mail_reciever_id_seq OWNED BY public.quality_form_mail_reciever.id;
            public       postgres    false    304            �            1259    49862    recete    TABLE     B  CREATE TABLE public.recete (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    mamul_stok_kodu character varying(32) NOT NULL,
    ornek_uretim_miktari double precision NOT NULL,
    fire_orani double precision,
    aciklama character varying(128),
    recete_adi character varying(128) NOT NULL
);
    DROP TABLE public.recete;
       public         postgres    false    8            E           0    0    TABLE recete    ACL     �   REVOKE ALL ON TABLE public.recete FROM PUBLIC;
REVOKE ALL ON TABLE public.recete FROM postgres;
GRANT ALL ON TABLE public.recete TO postgres;
GRANT ALL ON TABLE public.recete TO PUBLIC;
            public       postgres    false    227            �            1259    49866    recete_hammadde    TABLE       CREATE TABLE public.recete_hammadde (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer NOT NULL,
    stok_kodu character varying(32) NOT NULL,
    miktar double precision NOT NULL,
    fire_orani double precision,
    recete_id integer
);
 #   DROP TABLE public.recete_hammadde;
       public         postgres    false    8            F           0    0    TABLE recete_hammadde    ACL     �   REVOKE ALL ON TABLE public.recete_hammadde FROM PUBLIC;
REVOKE ALL ON TABLE public.recete_hammadde FROM postgres;
GRANT ALL ON TABLE public.recete_hammadde TO postgres;
GRANT ALL ON TABLE public.recete_hammadde TO PUBLIC;
            public       postgres    false    228            �            1259    49870    recete_hammadde_id_seq    SEQUENCE        CREATE SEQUENCE public.recete_hammadde_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.recete_hammadde_id_seq;
       public       postgres    false    8    228            G           0    0    recete_hammadde_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.recete_hammadde_id_seq OWNED BY public.recete_hammadde.id;
            public       postgres    false    229            H           0    0    SEQUENCE recete_hammadde_id_seq    ACL       REVOKE ALL ON SEQUENCE public.recete_hammadde_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.recete_hammadde_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.recete_hammadde_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.recete_hammadde_id_seq TO PUBLIC;
            public       postgres    false    229            �            1259    49872    recete_id_seq    SEQUENCE     v   CREATE SEQUENCE public.recete_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.recete_id_seq;
       public       postgres    false    8    227            I           0    0    recete_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.recete_id_seq OWNED BY public.recete.id;
            public       postgres    false    230            J           0    0    SEQUENCE recete_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.recete_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.recete_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.recete_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.recete_id_seq TO PUBLIC;
            public       postgres    false    230            �            1259    49874    satis_fatura    TABLE       CREATE TABLE public.satis_fatura (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    fatura_no character varying(16),
    fatura_tarihi timestamp without time zone,
    teklif_id integer,
    siparis_id integer,
    irsaliye_id integer
);
     DROP TABLE public.satis_fatura;
       public         postgres    false    8            K           0    0    TABLE satis_fatura    ACL     �   REVOKE ALL ON TABLE public.satis_fatura FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_fatura FROM postgres;
GRANT ALL ON TABLE public.satis_fatura TO postgres;
GRANT ALL ON TABLE public.satis_fatura TO PUBLIC;
            public       postgres    false    231            �            1259    49878    satis_fatura_detay    TABLE     �   CREATE TABLE public.satis_fatura_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer,
    teklif_detay_id integer,
    siparis_detay_id integer,
    irsaliye_detay_id integer
);
 &   DROP TABLE public.satis_fatura_detay;
       public         postgres    false    8            L           0    0    TABLE satis_fatura_detay    ACL     �   REVOKE ALL ON TABLE public.satis_fatura_detay FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_fatura_detay FROM postgres;
GRANT ALL ON TABLE public.satis_fatura_detay TO postgres;
GRANT ALL ON TABLE public.satis_fatura_detay TO PUBLIC;
            public       postgres    false    232            �            1259    49882    satis_fatura_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.satis_fatura_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.satis_fatura_detay_id_seq;
       public       postgres    false    8    232            M           0    0    satis_fatura_detay_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.satis_fatura_detay_id_seq OWNED BY public.satis_fatura_detay.id;
            public       postgres    false    233            N           0    0 "   SEQUENCE satis_fatura_detay_id_seq    ACL       REVOKE ALL ON SEQUENCE public.satis_fatura_detay_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_fatura_detay_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_fatura_detay_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_fatura_detay_id_seq TO PUBLIC;
            public       postgres    false    233            �            1259    49884    satis_fatura_id_seq    SEQUENCE     |   CREATE SEQUENCE public.satis_fatura_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.satis_fatura_id_seq;
       public       postgres    false    8    231            O           0    0    satis_fatura_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.satis_fatura_id_seq OWNED BY public.satis_fatura.id;
            public       postgres    false    234            P           0    0    SEQUENCE satis_fatura_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.satis_fatura_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_fatura_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_fatura_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_fatura_id_seq TO PUBLIC;
            public       postgres    false    234            �            1259    49886    satis_irsaliye    TABLE     
  CREATE TABLE public.satis_irsaliye (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    irsaliye_no character varying(16),
    irsaliye_tarihi timestamp without time zone,
    teklif_id integer,
    siparis_id integer,
    fatura_id integer
);
 "   DROP TABLE public.satis_irsaliye;
       public         postgres    false    8            Q           0    0    TABLE satis_irsaliye    ACL     �   REVOKE ALL ON TABLE public.satis_irsaliye FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_irsaliye FROM postgres;
GRANT ALL ON TABLE public.satis_irsaliye TO postgres;
GRANT ALL ON TABLE public.satis_irsaliye TO PUBLIC;
            public       postgres    false    235            �            1259    49890    satis_irsaliye_detay    TABLE     �   CREATE TABLE public.satis_irsaliye_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer,
    teklif_detay_id integer,
    siparis_detay_id integer,
    fatura_detay_id integer
);
 (   DROP TABLE public.satis_irsaliye_detay;
       public         postgres    false    8            R           0    0    TABLE satis_irsaliye_detay    ACL     �   REVOKE ALL ON TABLE public.satis_irsaliye_detay FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_irsaliye_detay FROM postgres;
GRANT ALL ON TABLE public.satis_irsaliye_detay TO postgres;
GRANT ALL ON TABLE public.satis_irsaliye_detay TO PUBLIC;
            public       postgres    false    236            �            1259    49894    satis_irsaliye_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.satis_irsaliye_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.satis_irsaliye_detay_id_seq;
       public       postgres    false    236    8            S           0    0    satis_irsaliye_detay_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.satis_irsaliye_detay_id_seq OWNED BY public.satis_irsaliye_detay.id;
            public       postgres    false    237            T           0    0 $   SEQUENCE satis_irsaliye_detay_id_seq    ACL       REVOKE ALL ON SEQUENCE public.satis_irsaliye_detay_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_irsaliye_detay_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_irsaliye_detay_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_irsaliye_detay_id_seq TO PUBLIC;
            public       postgres    false    237            �            1259    49896    satis_irsaliye_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.satis_irsaliye_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.satis_irsaliye_id_seq;
       public       postgres    false    235    8            U           0    0    satis_irsaliye_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.satis_irsaliye_id_seq OWNED BY public.satis_irsaliye.id;
            public       postgres    false    238            V           0    0    SEQUENCE satis_irsaliye_id_seq    ACL       REVOKE ALL ON SEQUENCE public.satis_irsaliye_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_irsaliye_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_irsaliye_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_irsaliye_id_seq TO PUBLIC;
            public       postgres    false    238            �            1259    49898    satis_siparis    TABLE       CREATE TABLE public.satis_siparis (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    siparis_no character varying(16),
    siparis_tarihi timestamp without time zone,
    teklif_id integer,
    irsaliye_id integer,
    fatura_id integer
);
 !   DROP TABLE public.satis_siparis;
       public         postgres    false    8            W           0    0    TABLE satis_siparis    ACL     �   REVOKE ALL ON TABLE public.satis_siparis FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_siparis FROM postgres;
GRANT ALL ON TABLE public.satis_siparis TO postgres;
GRANT ALL ON TABLE public.satis_siparis TO PUBLIC;
            public       postgres    false    239            �            1259    49902    satis_siparis_detay    TABLE     �   CREATE TABLE public.satis_siparis_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer,
    teklif_detay_id integer,
    irsaliye_detay_id integer,
    fatura_detay_id integer
);
 '   DROP TABLE public.satis_siparis_detay;
       public         postgres    false    8            X           0    0    TABLE satis_siparis_detay    ACL     �   REVOKE ALL ON TABLE public.satis_siparis_detay FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_siparis_detay FROM postgres;
GRANT ALL ON TABLE public.satis_siparis_detay TO postgres;
GRANT ALL ON TABLE public.satis_siparis_detay TO PUBLIC;
            public       postgres    false    240            �            1259    49906    satis_siparis_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.satis_siparis_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.satis_siparis_detay_id_seq;
       public       postgres    false    240    8            Y           0    0    satis_siparis_detay_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.satis_siparis_detay_id_seq OWNED BY public.satis_siparis_detay.id;
            public       postgres    false    241            Z           0    0 #   SEQUENCE satis_siparis_detay_id_seq    ACL       REVOKE ALL ON SEQUENCE public.satis_siparis_detay_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_siparis_detay_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_siparis_detay_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_siparis_detay_id_seq TO PUBLIC;
            public       postgres    false    241            �            1259    49908    satis_siparis_id_seq    SEQUENCE     }   CREATE SEQUENCE public.satis_siparis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.satis_siparis_id_seq;
       public       postgres    false    239    8            [           0    0    satis_siparis_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.satis_siparis_id_seq OWNED BY public.satis_siparis.id;
            public       postgres    false    242            \           0    0    SEQUENCE satis_siparis_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.satis_siparis_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.satis_siparis_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.satis_siparis_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.satis_siparis_id_seq TO PUBLIC;
            public       postgres    false    242            �           1259    184737    satis_teklif    TABLE     �  CREATE TABLE public.satis_teklif (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    siparis_id integer,
    irsaliye_id integer,
    fatura_id integer,
    is_siparislesti boolean NOT NULL,
    is_taslak boolean DEFAULT false NOT NULL,
    is_efatura boolean DEFAULT false NOT NULL,
    tutar double precision DEFAULT 0 NOT NULL,
    iskonto_tutar double precision DEFAULT 0 NOT NULL,
    ara_toplam double precision DEFAULT 0 NOT NULL,
    genel_iskonto_tutar double precision DEFAULT 0 NOT NULL,
    kdv_tutar double precision DEFAULT 0 NOT NULL,
    genel_toplam double precision DEFAULT 0 NOT NULL,
    islem_tipi_id integer,
    teklif_no character varying(16),
    teklif_tarihi timestamp without time zone,
    teslim_tarihi timestamp without time zone,
    gecerlilik_tarihi timestamp without time zone,
    musteri_kodu character varying(16),
    musteri_adi character varying(128),
    adres_musteri character varying(128),
    sehir_musteri character varying(32),
    posta_kodu character varying(16),
    vergi_dairesi character varying(32),
    vergi_no character varying(32),
    musteri_temsilcisi_id integer,
    teklif_tipi_id integer,
    adres_sevkiyat character varying(128),
    sehir_sevkiyat character varying(32),
    muhattap_ad character varying(32),
    muhattap_soyad character varying(32),
    odeme_vadesi character varying(32),
    referans character varying(128),
    teslimat_suresi character varying(32),
    teklif_durum_id integer,
    sevk_tarihi timestamp without time zone,
    vade_gun_sayisi integer,
    fatura_sevk_tarihi character varying(64),
    para_birimi character varying(3) NOT NULL,
    dolar_kur double precision DEFAULT 1,
    euro_kur double precision DEFAULT 1,
    odeme_baslangic_donemi_id integer,
    teslim_sarti_id integer,
    gonderim_sekli_id integer,
    gonderim_sekli_detay character varying(128),
    odeme_sekli_id integer,
    aciklama character varying(128),
    proforma_no integer,
    arayan_kisi_id integer,
    arama_tarihi timestamp without time zone,
    sonraki_aksiyon_tarihi timestamp without time zone,
    aksiyon_notu character varying(128),
    tevkifat_kodu character varying(3),
    tevkifat_pay integer,
    tevkifat_payda integer,
    ihrac_kayit_kodu character varying(3)
);
     DROP TABLE public.satis_teklif;
       public         postgres    false    8            ]           0    0    TABLE satis_teklif    ACL     �   REVOKE ALL ON TABLE public.satis_teklif FROM PUBLIC;
REVOKE ALL ON TABLE public.satis_teklif FROM postgres;
GRANT ALL ON TABLE public.satis_teklif TO postgres;
GRANT ALL ON TABLE public.satis_teklif TO PUBLIC;
            public       postgres    false    401            �           1259    184819    satis_teklif_detay    TABLE     �  CREATE TABLE public.satis_teklif_detay (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    header_id integer,
    siparis_detay_id integer,
    irsaliye_detay_id integer,
    fatura_detay_id integer,
    stok_kodu character varying(32),
    stok_aciklama character varying(128),
    aciklama character varying(128),
    referans character varying(128),
    miktar double precision NOT NULL,
    olcu_birimi character varying(8),
    fiyat double precision DEFAULT 0,
    tutar double precision DEFAULT 0 NOT NULL,
    iskonto double precision DEFAULT 0,
    net_fiyat double precision DEFAULT 0 NOT NULL,
    net_tutar double precision DEFAULT 0 NOT NULL,
    iskonto_tutar double precision DEFAULT 0 NOT NULL,
    kdv integer DEFAULT 0,
    kdv_tutar double precision DEFAULT 0 NOT NULL,
    toplam_tutar double precision DEFAULT 0 NOT NULL,
    vade_gun double precision DEFAULT 0,
    is_ana_urun boolean DEFAULT false NOT NULL,
    ana_urun_id integer,
    reference_ana_urun_id integer,
    transfer_hesap_kodu character varying(16),
    kdv_transfer_hesap_kodu character varying(16),
    vergi_kodu character varying(4),
    vergi_muafiyet_kodu character varying(4),
    diger_vergi_kodu character varying(4),
    gtip_no character varying(16)
);
 &   DROP TABLE public.satis_teklif_detay;
       public         postgres    false    8            �           1259    184817    satis_teklif_detay_id_seq    SEQUENCE     �   CREATE SEQUENCE public.satis_teklif_detay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.satis_teklif_detay_id_seq;
       public       postgres    false    8    403            ^           0    0    satis_teklif_detay_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.satis_teklif_detay_id_seq OWNED BY public.satis_teklif_detay.id;
            public       postgres    false    402            �           1259    184735    satis_teklif_id_seq    SEQUENCE     |   CREATE SEQUENCE public.satis_teklif_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.satis_teklif_id_seq;
       public       postgres    false    401    8            _           0    0    satis_teklif_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.satis_teklif_id_seq OWNED BY public.satis_teklif.id;
            public       postgres    false    400                       1259    96455    sehir    TABLE     �   CREATE TABLE public.sehir (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    sehir_adi character varying(32) NOT NULL,
    ulke_adi character varying(128) NOT NULL,
    plaka_kodu integer
);
    DROP TABLE public.sehir;
       public         postgres    false    8            `           0    0    TABLE sehir    ACL     �   REVOKE ALL ON TABLE public.sehir FROM PUBLIC;
REVOKE ALL ON TABLE public.sehir FROM postgres;
GRANT ALL ON TABLE public.sehir TO postgres;
            public       postgres    false    270                       1259    96453    sehir_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sehir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sehir_id_seq;
       public       postgres    false    8    270            a           0    0    sehir_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sehir_id_seq OWNED BY public.sehir.id;
            public       postgres    false    269            Q           1259    134020 
   stok_grubu    TABLE     �  CREATE TABLE public.stok_grubu (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    grup character varying(32) NOT NULL,
    alis_hesabi character varying(16),
    satis_hesabi character varying(16),
    hammadde_hesabi character varying(16),
    mamul_hesabi character varying(16),
    kdv_orani_id integer NOT NULL,
    tur_id integer,
    is_iskonto_aktif boolean DEFAULT false NOT NULL,
    iskonto_satis double precision DEFAULT 0 NOT NULL,
    iskonto_mudur double precision DEFAULT 0 NOT NULL,
    is_satis_fiyatini_kullan boolean DEFAULT false NOT NULL,
    yari_mamul_hesabi character varying(16),
    is_maliyet_analiz_farkli_db boolean DEFAULT false NOT NULL
);
    DROP TABLE public.stok_grubu;
       public         postgres    false    8            P           1259    134018    stok_grubu_id_seq    SEQUENCE     z   CREATE SEQUENCE public.stok_grubu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.stok_grubu_id_seq;
       public       postgres    false    8    337            b           0    0    stok_grubu_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.stok_grubu_id_seq OWNED BY public.stok_grubu.id;
            public       postgres    false    336            O           1259    133957    stok_grubu_turu    TABLE     �   CREATE TABLE public.stok_grubu_turu (
    id integer NOT NULL,
    validity boolean DEFAULT true,
    tur character varying(32) NOT NULL
);
 #   DROP TABLE public.stok_grubu_turu;
       public         postgres    false    8            N           1259    133955    stok_grubu_turu_id_seq    SEQUENCE        CREATE SEQUENCE public.stok_grubu_turu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.stok_grubu_turu_id_seq;
       public       postgres    false    335    8            c           0    0    stok_grubu_turu_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.stok_grubu_turu_id_seq OWNED BY public.stok_grubu_turu.id;
            public       postgres    false    334                       1259    103356    stok_hareketi    TABLE     �  CREATE TABLE public.stok_hareketi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    stok_kodu character varying(32) NOT NULL,
    miktar double precision NOT NULL,
    tutar double precision NOT NULL,
    giris_cikis_tip_id integer NOT NULL,
    alan_ambar character varying(32),
    veren_ambar character varying(32),
    tarih timestamp without time zone NOT NULL,
    is_donem_basi_hareket boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.stok_hareketi;
       public         postgres    false    8                       1259    103354    stok_hareketi_id_seq    SEQUENCE     }   CREATE SEQUENCE public.stok_hareketi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.stok_hareketi_id_seq;
       public       postgres    false    8    278            d           0    0    stok_hareketi_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.stok_hareketi_id_seq OWNED BY public.stok_hareketi.id;
            public       postgres    false    277            S           1259    134132 
   stok_karti    TABLE     @  CREATE TABLE public.stok_karti (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    stok_kodu character varying(32) NOT NULL,
    stok_adi character varying(128) NOT NULL,
    stok_grubu_id integer NOT NULL,
    olcu_birimi_id integer NOT NULL,
    alis_iskonto double precision,
    satis_iskonto double precision,
    yetkili_iskonto double precision,
    stok_tipi_id integer DEFAULT public.get_default_stok_tipi() NOT NULL,
    ham_alis_fiyat double precision DEFAULT 0 NOT NULL,
    ham_alis_para_birim character varying(3) DEFAULT public.get_default_para_birimi() NOT NULL,
    alis_fiyat double precision NOT NULL,
    alis_para_birim character varying(3) DEFAULT public.get_default_para_birimi() NOT NULL,
    satis_fiyat double precision NOT NULL,
    satis_para_birim character varying(3) DEFAULT public.get_default_para_birimi() NOT NULL,
    ihrac_fiyat double precision DEFAULT 0 NOT NULL,
    ihrac_para_birim character varying(3) DEFAULT public.get_default_para_birimi() NOT NULL,
    ortalama_maliyet double precision DEFAULT 0,
    varsayilan_recete_id integer,
    en double precision,
    boy double precision,
    yukseklik double precision,
    mensei_id integer,
    gtip_no character varying(16),
    diib_urun_tanimi character varying(64),
    en_az_stok_seviyesi double precision,
    tanim character varying(384),
    ozel_kod character varying(16),
    marka character varying(32),
    agirlik double precision,
    kapasite double precision,
    cins_id integer,
    string_degisken1 character varying(32),
    string_degisken2 character varying(32),
    string_degisken3 character varying(32),
    string_degisken4 character varying(32),
    string_degisken5 character varying(32),
    string_degisken6 character varying(32),
    integer_degisken1 integer,
    integer_degisken2 integer,
    integer_degisken3 integer,
    double_degisken1 double precision,
    double_degisken2 double precision,
    double_degisken3 double precision,
    is_satilabilir boolean DEFAULT true NOT NULL,
    is_ana_urun boolean DEFAULT false NOT NULL,
    is_yari_mamul boolean DEFAULT false NOT NULL,
    is_otomatik_uretim_urunu boolean DEFAULT false NOT NULL,
    is_ozet_urun boolean DEFAULT false NOT NULL,
    lot_parti_miktari double precision,
    paket_miktari integer,
    seri_no_turu character varying(4),
    is_harici_seri_no_icerir boolean DEFAULT false NOT NULL,
    harici_serino_stok_kodu_id integer,
    tasiyici_paket_id integer,
    onceki_donem_cikan_miktar double precision,
    temin_suresi integer,
    stock_name character varying(128),
    en_string_degisken1 character varying(32),
    en_string_degisken2 character varying(32),
    en_string_degisken3 character varying(32),
    en_string_degisken4 character varying(32),
    en_string_degisken5 character varying(32),
    en_string_degisken6 character varying(32)
);
    DROP TABLE public.stok_karti;
       public         postgres    false    497    502    502    502    502    8            R           1259    134130    stok_karti_id_seq    SEQUENCE     z   CREATE SEQUENCE public.stok_karti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.stok_karti_id_seq;
       public       postgres    false    339    8            e           0    0    stok_karti_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.stok_karti_id_seq OWNED BY public.stok_karti.id;
            public       postgres    false    338            �            1259    49941 	   stok_tipi    TABLE     �   CREATE TABLE public.stok_tipi (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    tip character varying(16) NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_stok_hareketi_yap boolean DEFAULT false NOT NULL
);
    DROP TABLE public.stok_tipi;
       public         postgres    false    8            f           0    0    TABLE stok_tipi    ACL     �   REVOKE ALL ON TABLE public.stok_tipi FROM PUBLIC;
REVOKE ALL ON TABLE public.stok_tipi FROM postgres;
GRANT ALL ON TABLE public.stok_tipi TO postgres;
GRANT ALL ON TABLE public.stok_tipi TO PUBLIC;
            public       postgres    false    243            �            1259    49947    stok_tipi_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stok_tipi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stok_tipi_id_seq;
       public       postgres    false    8    243            g           0    0    stok_tipi_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stok_tipi_id_seq OWNED BY public.stok_tipi.id;
            public       postgres    false    244            h           0    0    SEQUENCE stok_tipi_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.stok_tipi_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.stok_tipi_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.stok_tipi_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.stok_tipi_id_seq TO PUBLIC;
            public       postgres    false    244                       1259    88214    sys_application_settings    TABLE     �  CREATE TABLE public.sys_application_settings (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    logo bytea,
    unvan character varying(128) NOT NULL,
    tel1 character varying(24) NOT NULL,
    tel2 character varying(24),
    tel3 character varying(24),
    tel4 character varying(24),
    tel5 character varying(24),
    fax1 character varying(24),
    fax2 character varying(24),
    mersis_no character varying(16),
    web_sitesi character varying(48),
    eposta_adresi character varying(80),
    vergi_dairesi character varying(32),
    vergi_no character varying(16),
    form_rengi integer,
    donem integer DEFAULT 2014 NOT NULL,
    mukellef_tipi character varying(16),
    tam_adres character varying(160),
    ticaret_sicil_no character varying(24),
    ilce character varying(32),
    mahalle character varying(40),
    cadde character varying(40),
    sokak character varying(40),
    posta_kodu character varying(7),
    bina character varying(40),
    kapi_no character varying(6),
    ulke_id integer,
    sehir_id integer,
    sistem_dili character varying(16) NOT NULL,
    mail_sunucu_adres character varying(32),
    mail_sunucu_kullanici character varying(32),
    mail_sunucu_sifre character varying(16),
    mail_sunucu_port integer,
    grid_color_1 integer DEFAULT 13171168 NOT NULL,
    grid_color_2 integer DEFAULT 7467153 NOT NULL,
    grid_color_active integer DEFAULT 14605509 NOT NULL,
    edefter_gonderilen_son date
);
 ,   DROP TABLE public.sys_application_settings;
       public         postgres    false    8                       1259    88212    sys_application_settings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_application_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.sys_application_settings_id_seq;
       public       postgres    false    8    260            i           0    0    sys_application_settings_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.sys_application_settings_id_seq OWNED BY public.sys_application_settings.id;
            public       postgres    false    259                       1259    103483    sys_application_settings_other    TABLE     �  CREATE TABLE public.sys_application_settings_other (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    is_edefter_aktif boolean DEFAULT false NOT NULL,
    mail_sender_address character varying(32),
    mail_sender_username character varying(32),
    mail_sender_password character varying(16),
    mail_sender_port integer,
    varsayilan_satis_cari_kod character varying(16),
    varsayilan_alis_cari_kod character varying(16),
    is_bolum_ambarda_uretim_yap boolean DEFAULT false NOT NULL,
    is_uretim_muhasebe_kaydi_olustursun boolean DEFAULT true NOT NULL,
    is_stok_satimda_negatife_dusebilir boolean DEFAULT false NOT NULL,
    is_mal_satis_sayilarini_goster boolean DEFAULT false NOT NULL,
    is_pcb_uretim boolean DEFAULT false NOT NULL,
    is_proforma_no_goster boolean DEFAULT false NOT NULL,
    is_satis_takip boolean DEFAULT false NOT NULL,
    is_hammadde_girise_gore_sirala boolean DEFAULT false NOT NULL,
    is_uretim_entegrasyon_hammadde_kullanim_hesabi_iscilikle boolean DEFAULT false NOT NULL,
    is_tahsilat_listesi_virmanli boolean DEFAULT false NOT NULL,
    is_ortalama_vade_0_ise_sevkiyata_izin_verme boolean DEFAULT false NOT NULL,
    is_sipariste_teslim_tarihi_yazdir boolean DEFAULT false NOT NULL,
    is_teklif_ayrintilarini_goster boolean DEFAULT false NOT NULL,
    is_fatura_irsaliye_no_0_ile_baslasin boolean DEFAULT false NOT NULL,
    is_excel_ekli_irsaliye_yazdirma boolean DEFAULT false NOT NULL,
    is_ambarlararasi_transfer_numara_otomatik_gelsin boolean DEFAULT false NOT NULL,
    is_ambarlararasi_transfer_onayli_calissin boolean DEFAULT false NOT NULL,
    is_alis_teklif_alis_sipariste_ham_alis_fiyatini_kullan boolean DEFAULT false NOT NULL,
    is_tahsilat_listesine_120_bulut_hesabini_dahil_etme boolean DEFAULT false NOT NULL,
    is_satis_listesi_varsayilan_filtre_mamul_hammadde boolean DEFAULT false NOT NULL,
    is_recete_maliyet_analizi_baska_db_kullanarak_yap boolean DEFAULT false NOT NULL,
    is_efatura_aktif boolean DEFAULT false NOT NULL,
    is_stok_transfer_fiyati_kullanici_degistirebilir boolean DEFAULT false NOT NULL,
    is_hesaplar_rapolarda_cikmasin boolean DEFAULT false NOT NULL,
    is_siparisi_baska_programa_otomatik_kayit_yap boolean DEFAULT false NOT NULL,
    is_active_uretim_takip boolean DEFAULT false NOT NULL,
    is_pano_programina_otomatik_kayit boolean DEFAULT false NOT NULL,
    is_nakit_akista_farkli_db_kullan boolean DEFAULT false NOT NULL,
    is_ihrac_fiyati_yerine_satis_fiyatini_kullan boolean DEFAULT false NOT NULL,
    is_statik_iskonto_orani_kullan boolean DEFAULT false NOT NULL,
    is_eirsaliye_aktif boolean DEFAULT false NOT NULL,
    is_stok_recete_adi_birlikte_guncellensin boolean DEFAULT false NOT NULL,
    is_kur_bilgisini_1_olarak_kullan boolean DEFAULT false NOT NULL,
    is_genel_kdv_orani_kullan boolean DEFAULT false NOT NULL,
    xslt_sablon_adi character varying(32),
    genel_iskonto_gecerlilik_tarihi date,
    en_fazla_fatura_satir_sayisi integer DEFAULT 0 NOT NULL,
    en_fazla_e_fatura_satir_sayisi integer DEFAULT 0 NOT NULL,
    en_fazla_irsaliye_satir_sayisi integer DEFAULT 0 NOT NULL,
    en_fazla_e_irsaliye_satir_sayisi integer DEFAULT 0 NOT NULL,
    siparis_kopyalanacak_kaynak_cari_kod character varying(16),
    siparis_kopyalanacak_hedef_cari_kod character varying(16),
    maliyet_analizi_iskonto_orani double precision,
    genel_kdv_orani double precision DEFAULT 18 NOT NULL,
    path_teklif_hesaplama_conf character varying(255),
    path_proforma_file character varying(255),
    path_mal_stok_seviyesi_eord_rapor character varying(255),
    path_update character varying(255),
    path_stok_karti_resim character varying(255),
    path_proforma_pdf_kayit character varying(255)
);
 2   DROP TABLE public.sys_application_settings_other;
       public         postgres    false    8                       1259    103481 %   sys_application_settings_other_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_application_settings_other_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.sys_application_settings_other_id_seq;
       public       postgres    false    8    280            j           0    0 %   sys_application_settings_other_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.sys_application_settings_other_id_seq OWNED BY public.sys_application_settings_other.id;
            public       postgres    false    279            �            1259    65741    sys_grid_col_color    TABLE     �  CREATE TABLE public.sys_grid_col_color (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    table_name character varying NOT NULL,
    column_name character varying NOT NULL,
    min_value double precision DEFAULT 0 NOT NULL,
    min_color integer DEFAULT 0 NOT NULL,
    max_value double precision DEFAULT 0 NOT NULL,
    max_color integer DEFAULT 0 NOT NULL
);
 &   DROP TABLE public.sys_grid_col_color;
       public         postgres    false    8            k           0    0    TABLE sys_grid_col_color    ACL     �   REVOKE ALL ON TABLE public.sys_grid_col_color FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_grid_col_color FROM postgres;
GRANT ALL ON TABLE public.sys_grid_col_color TO postgres;
GRANT ALL ON TABLE public.sys_grid_col_color TO PUBLIC;
            public       postgres    false    254            �            1259    65739    sys_grid_col_color_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_grid_col_color_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.sys_grid_col_color_id_seq;
       public       postgres    false    8    254            l           0    0    sys_grid_col_color_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.sys_grid_col_color_id_seq OWNED BY public.sys_grid_col_color.id;
            public       postgres    false    253                        1259    65760    sys_grid_col_percent    TABLE     �  CREATE TABLE public.sys_grid_col_percent (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    table_name character varying,
    column_name character varying,
    max_value double precision DEFAULT 0 NOT NULL,
    color_bar integer DEFAULT 0 NOT NULL,
    color_bar_back integer DEFAULT 0 NOT NULL,
    color_bar_text integer DEFAULT 0 NOT NULL,
    color_bar_text_active integer DEFAULT 0 NOT NULL
);
 (   DROP TABLE public.sys_grid_col_percent;
       public         postgres    false    8            m           0    0    TABLE sys_grid_col_percent    ACL     �   REVOKE ALL ON TABLE public.sys_grid_col_percent FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_grid_col_percent FROM postgres;
GRANT ALL ON TABLE public.sys_grid_col_percent TO postgres;
GRANT ALL ON TABLE public.sys_grid_col_percent TO PUBLIC;
            public       postgres    false    256            �            1259    65758    sys_grid_col_percent_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_grid_col_percent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.sys_grid_col_percent_id_seq;
       public       postgres    false    8    256            n           0    0    sys_grid_col_percent_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.sys_grid_col_percent_id_seq OWNED BY public.sys_grid_col_percent.id;
            public       postgres    false    255            �            1259    65726    sys_grid_col_width    TABLE        CREATE TABLE public.sys_grid_col_width (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    table_name character varying NOT NULL,
    column_name character varying NOT NULL,
    column_width integer DEFAULT 0 NOT NULL,
    sequence_no integer DEFAULT 1 NOT NULL
);
 &   DROP TABLE public.sys_grid_col_width;
       public         postgres    false    8            o           0    0    TABLE sys_grid_col_width    ACL     �   REVOKE ALL ON TABLE public.sys_grid_col_width FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_grid_col_width FROM postgres;
GRANT ALL ON TABLE public.sys_grid_col_width TO postgres;
GRANT ALL ON TABLE public.sys_grid_col_width TO PUBLIC;
            public       postgres    false    252            �            1259    65724    sys_grid_col_width_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_grid_col_width_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.sys_grid_col_width_id_seq;
       public       postgres    false    252    8            p           0    0    sys_grid_col_width_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.sys_grid_col_width_id_seq OWNED BY public.sys_grid_col_width.id;
            public       postgres    false    251                       1259    88199    sys_grid_default_order_filter    TABLE     �   CREATE TABLE public.sys_grid_default_order_filter (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    key character varying(32),
    value character varying,
    is_order boolean DEFAULT false NOT NULL
);
 1   DROP TABLE public.sys_grid_default_order_filter;
       public         postgres    false    8                       1259    88197 $   sys_grid_default_order_filter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_grid_default_order_filter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.sys_grid_default_order_filter_id_seq;
       public       postgres    false    258    8            q           0    0 $   sys_grid_default_order_filter_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.sys_grid_default_order_filter_id_seq OWNED BY public.sys_grid_default_order_filter.id;
            public       postgres    false    257            �            1259    51760    sys_lang    TABLE     �   CREATE TABLE public.sys_lang (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    language character varying(16)
);
    DROP TABLE public.sys_lang;
       public         postgres    false    8            r           0    0    TABLE sys_lang    ACL     �   REVOKE ALL ON TABLE public.sys_lang FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_lang FROM postgres;
GRANT ALL ON TABLE public.sys_lang TO postgres;
GRANT ALL ON TABLE public.sys_lang TO PUBLIC;
            public       postgres    false    250            5           1259    123148    sys_lang_data_content    TABLE        CREATE TABLE public.sys_lang_data_content (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    lang character varying(16) NOT NULL,
    table_name character varying NOT NULL,
    column_name character varying NOT NULL,
    row_id integer NOT NULL,
    value text
);
 )   DROP TABLE public.sys_lang_data_content;
       public         postgres    false    8            4           1259    123146    sys_lang_data_content_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_lang_data_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sys_lang_data_content_id_seq;
       public       postgres    false    8    309            s           0    0    sys_lang_data_content_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sys_lang_data_content_id_seq OWNED BY public.sys_lang_data_content.id;
            public       postgres    false    308            7           1259    123162    sys_lang_gui_content    TABLE     b  CREATE TABLE public.sys_lang_gui_content (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    lang character varying(16) NOT NULL,
    code character varying(64) NOT NULL,
    value text,
    is_factory_setting boolean DEFAULT false NOT NULL,
    content_type character varying(32) NOT NULL,
    table_name character varying(64)
);
 (   DROP TABLE public.sys_lang_gui_content;
       public         postgres    false    8            6           1259    123160    sys_lang_gui_content_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_lang_gui_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.sys_lang_gui_content_id_seq;
       public       postgres    false    311    8            t           0    0    sys_lang_gui_content_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.sys_lang_gui_content_id_seq OWNED BY public.sys_lang_gui_content.id;
            public       postgres    false    310            �            1259    51758    sys_lang_id_seq    SEQUENCE     x   CREATE SEQUENCE public.sys_lang_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.sys_lang_id_seq;
       public       postgres    false    250    8            u           0    0    sys_lang_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.sys_lang_id_seq OWNED BY public.sys_lang.id;
            public       postgres    false    249            v           0    0    SEQUENCE sys_lang_id_seq    ACL     �   REVOKE ALL ON SEQUENCE public.sys_lang_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.sys_lang_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.sys_lang_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.sys_lang_id_seq TO PUBLIC;
            public       postgres    false    249            3           1259    123134    sys_multi_lang_data_table_list    TABLE     �   CREATE TABLE public.sys_multi_lang_data_table_list (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    table_name character varying DEFAULT 128 NOT NULL
);
 2   DROP TABLE public.sys_multi_lang_data_table_list;
       public         postgres    false    8            2           1259    123132 %   sys_multi_lang_data_table_list_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_multi_lang_data_table_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.sys_multi_lang_data_table_list_id_seq;
       public       postgres    false    8    307            w           0    0 %   sys_multi_lang_data_table_list_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.sys_multi_lang_data_table_list_id_seq OWNED BY public.sys_multi_lang_data_table_list.id;
            public       postgres    false    306            �            1259    49949    sys_permission_source    TABLE     �   CREATE TABLE public.sys_permission_source (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    source_code character varying(16),
    source_name character varying(64),
    source_group_id integer
);
 )   DROP TABLE public.sys_permission_source;
       public         postgres    false    8            x           0    0    TABLE sys_permission_source    ACL     �   REVOKE ALL ON TABLE public.sys_permission_source FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_permission_source FROM postgres;
GRANT ALL ON TABLE public.sys_permission_source TO postgres;
GRANT ALL ON TABLE public.sys_permission_source TO PUBLIC;
            public       postgres    false    245            �            1259    49953    sys_permission_source_group    TABLE     �   CREATE TABLE public.sys_permission_source_group (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    source_group character varying(64)
);
 /   DROP TABLE public.sys_permission_source_group;
       public         postgres    false    8            y           0    0 !   TABLE sys_permission_source_group    ACL       REVOKE ALL ON TABLE public.sys_permission_source_group FROM PUBLIC;
REVOKE ALL ON TABLE public.sys_permission_source_group FROM postgres;
GRANT ALL ON TABLE public.sys_permission_source_group TO postgres;
GRANT ALL ON TABLE public.sys_permission_source_group TO PUBLIC;
            public       postgres    false    246            �            1259    49957 "   sys_permission_source_group_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_permission_source_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.sys_permission_source_group_id_seq;
       public       postgres    false    8    246            z           0    0 "   sys_permission_source_group_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.sys_permission_source_group_id_seq OWNED BY public.sys_permission_source_group.id;
            public       postgres    false    247            {           0    0 +   SEQUENCE sys_permission_source_group_id_seq    ACL     6  REVOKE ALL ON SEQUENCE public.sys_permission_source_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.sys_permission_source_group_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.sys_permission_source_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.sys_permission_source_group_id_seq TO PUBLIC;
            public       postgres    false    247            �            1259    49959    sys_permission_source_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_permission_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sys_permission_source_id_seq;
       public       postgres    false    245    8            |           0    0    sys_permission_source_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sys_permission_source_id_seq OWNED BY public.sys_permission_source.id;
            public       postgres    false    248            }           0    0 %   SEQUENCE sys_permission_source_id_seq    ACL       REVOKE ALL ON SEQUENCE public.sys_permission_source_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.sys_permission_source_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.sys_permission_source_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.sys_permission_source_id_seq TO PUBLIC;
            public       postgres    false    248                       1259    96485    sys_quality_form_number    TABLE     �   CREATE TABLE public.sys_quality_form_number (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    table_name character varying NOT NULL,
    form_no character varying(16) NOT NULL
);
 +   DROP TABLE public.sys_quality_form_number;
       public         postgres    false    8                       1259    96483    sys_quality_form_number_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_quality_form_number_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.sys_quality_form_number_id_seq;
       public       postgres    false    272    8            ~           0    0    sys_quality_form_number_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.sys_quality_form_number_id_seq OWNED BY public.sys_quality_form_number.id;
            public       postgres    false    271            9           1259    123186    sys_user    TABLE     �  CREATE TABLE public.sys_user (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    user_name character varying(32) NOT NULL,
    user_password text NOT NULL,
    is_active_user boolean DEFAULT false NOT NULL,
    is_online boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    is_super_user boolean DEFAULT false NOT NULL,
    ip_address character varying(32) DEFAULT '127.0.0.1'::character varying NOT NULL,
    mac_address character varying(32),
    email_address character varying(64),
    app_version text,
    personel_bilgisi_id integer NOT NULL,
    invoice_no_serie character varying(1),
    dispatch_no_serie character varying(1),
    default_qrcode_size integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public.sys_user;
       public         postgres    false    8            ;           1259    123206    sys_user_access_right    TABLE     �  CREATE TABLE public.sys_user_access_right (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    source_code character varying(8) NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    is_add_record boolean DEFAULT false NOT NULL,
    is_update boolean DEFAULT false NOT NULL,
    is_delete boolean DEFAULT false NOT NULL,
    is_special boolean DEFAULT false NOT NULL,
    user_name character varying(32) NOT NULL
);
 )   DROP TABLE public.sys_user_access_right;
       public         postgres    false    8            :           1259    123204    sys_user_access_right_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_user_access_right_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.sys_user_access_right_id_seq;
       public       postgres    false    315    8                       0    0    sys_user_access_right_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.sys_user_access_right_id_seq OWNED BY public.sys_user_access_right.id;
            public       postgres    false    314            8           1259    123184    sys_user_id_seq    SEQUENCE     x   CREATE SEQUENCE public.sys_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.sys_user_id_seq;
       public       postgres    false    313    8            �           0    0    sys_user_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.sys_user_id_seq OWNED BY public.sys_user.id;
            public       postgres    false    312            =           1259    123248    sys_user_mac_address_exception    TABLE     �   CREATE TABLE public.sys_user_mac_address_exception (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    user_name character varying(32) NOT NULL,
    ip_address character varying(32) NOT NULL
);
 2   DROP TABLE public.sys_user_mac_address_exception;
       public         postgres    false    8            <           1259    123246 %   sys_user_mac_address_exception_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sys_user_mac_address_exception_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.sys_user_mac_address_exception_id_seq;
       public       postgres    false    317    8            �           0    0 %   sys_user_mac_address_exception_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.sys_user_mac_address_exception_id_seq OWNED BY public.sys_user_mac_address_exception.id;
            public       postgres    false    316                       1259    103534    sys_view_tables    VIEW       CREATE VIEW public.sys_view_tables AS
 SELECT initcap(replace((tables.table_name)::text, '_'::text, ' '::text)) AS table_name,
    tables.table_type
   FROM information_schema.tables
  WHERE ((tables.table_schema)::text = 'public'::text)
  ORDER BY tables.table_type, tables.table_name;
 "   DROP VIEW public.sys_view_tables;
       public       postgres    false    8                       1259    103557    sys_view_columns    VIEW     �  CREATE VIEW public.sys_view_columns AS
 SELECT initcap(replace((columns.table_name)::text, '_'::text, ' '::text)) AS table_name,
    initcap(replace((columns.column_name)::text, '_'::text, ' '::text)) AS column_name,
    columns.is_nullable,
    (columns.data_type)::text AS data_type,
    (columns.character_maximum_length)::integer AS character_maximum_length,
    (columns.ordinal_position)::integer AS ordinal_position,
    (vt.table_type)::text AS table_type
   FROM (information_schema.columns
     JOIN public.sys_view_tables vt ON ((( SELECT lower(replace(vt.table_name, ' '::text, '_'::text)) AS lower) = (columns.table_name)::text)))
  ORDER BY vt.table_type, columns.table_name, columns.ordinal_position;
 #   DROP VIEW public.sys_view_columns;
       public       postgres    false    281    281    8                       1259    103538    sys_view_databases    VIEW     6  CREATE VIEW public.sys_view_databases AS
 SELECT pg_database.datname AS database_name,
    pg_shdescription.description AS aciklama
   FROM (pg_shdescription
     JOIN pg_database ON ((pg_shdescription.objoid = pg_database.oid)))
  WHERE ((1 = 1) AND (pg_shdescription.description = 'THS ERP Systems'::text));
 %   DROP VIEW public.sys_view_databases;
       public       postgres    false    8                       1259    96442    ulke    TABLE     8  CREATE TABLE public.ulke (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    ulke_kodu character varying(2) NOT NULL,
    ulke_adi character varying(128) NOT NULL,
    iso_year integer,
    iso_cctld_code character varying(3),
    is_avrupa_birligi_uyesi boolean DEFAULT false NOT NULL
);
    DROP TABLE public.ulke;
       public         postgres    false    8            �           0    0 
   TABLE ulke    ACL     �   REVOKE ALL ON TABLE public.ulke FROM PUBLIC;
REVOKE ALL ON TABLE public.ulke FROM postgres;
GRANT ALL ON TABLE public.ulke TO postgres;
            public       postgres    false    268                       1259    96440    ulke_id_seq    SEQUENCE     t   CREATE SEQUENCE public.ulke_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.ulke_id_seq;
       public       postgres    false    268    8            �           0    0    ulke_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.ulke_id_seq OWNED BY public.ulke.id;
            public       postgres    false    267            /           1259    123106    urun_kabul_red_nedeni    TABLE     �   CREATE TABLE public.urun_kabul_red_nedeni (
    id integer NOT NULL,
    validity boolean DEFAULT true NOT NULL,
    deger character varying(64) NOT NULL
);
 )   DROP TABLE public.urun_kabul_red_nedeni;
       public         postgres    false    8            .           1259    123104    urun_kabul_red_nedeni_id_seq    SEQUENCE     �   CREATE SEQUENCE public.urun_kabul_red_nedeni_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.urun_kabul_red_nedeni_id_seq;
       public       postgres    false    303    8            �           0    0    urun_kabul_red_nedeni_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.urun_kabul_red_nedeni_id_seq OWNED BY public.urun_kabul_red_nedeni.id;
            public       postgres    false    302            '           2604    50015    id    DEFAULT     p   ALTER TABLE ONLY public.alis_teklif ALTER COLUMN id SET DEFAULT nextval('public.alis_teklif_id_seq'::regclass);
 =   ALTER TABLE public.alis_teklif ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    186    183            )           2604    50016    id    DEFAULT     |   ALTER TABLE ONLY public.alis_teklif_detay ALTER COLUMN id SET DEFAULT nextval('public.alis_teklif_detay_id_seq'::regclass);
 C   ALTER TABLE public.alis_teklif_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    185    184            +           2604    50017    id    DEFAULT     t   ALTER TABLE ONLY public.alis_tsif_kur ALTER COLUMN id SET DEFAULT nextval('public.alis_tsif_kur_id_seq'::regclass);
 ?   ALTER TABLE public.alis_tsif_kur ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    188    187            .           2604    50018    id    DEFAULT     d   ALTER TABLE ONLY public.ambar ALTER COLUMN id SET DEFAULT nextval('public.ambar_id_seq'::regclass);
 7   ALTER TABLE public.ambar ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    190    189            l           2604    142420    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_barkod_hazirlik_dosya_turu ALTER COLUMN id SET DEFAULT nextval('public.ayar_barkod_hazirlik_dosya_turu_id_seq'::regclass);
 Q   ALTER TABLE public.ayar_barkod_hazirlik_dosya_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    347    346    347            f           2604    142382    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_barkod_serino_turu ALTER COLUMN id SET DEFAULT nextval('public.ayar_barkod_serino_turu_id_seq'::regclass);
 I   ALTER TABLE public.ayar_barkod_serino_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    341    340    341            h           2604    142393    id    DEFAULT     ~   ALTER TABLE ONLY public.ayar_barkod_tezgah ALTER COLUMN id SET DEFAULT nextval('public.ayar_barkod_tezgah_id_seq'::regclass);
 D   ALTER TABLE public.ayar_barkod_tezgah ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    343    342    343            j           2604    142409    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_barkod_urun_turu ALTER COLUMN id SET DEFAULT nextval('public.ayar_barkod_urun_turu_id_seq'::regclass);
 G   ALTER TABLE public.ayar_barkod_urun_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    345    344    345            �           2604    157515    id    DEFAULT     z   ALTER TABLE ONLY public.ayar_bordro_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_bordro_tipi_id_seq'::regclass);
 B   ALTER TABLE public.ayar_bordro_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    361    360    361            �           2604    157839    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_cek_senet_cash_edici_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_cek_senet_cash_edici_tipi_id_seq'::regclass);
 P   ALTER TABLE public.ayar_cek_senet_cash_edici_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    393    392    393            �           2604    157850    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_cek_senet_tahsil_odeme_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_cek_senet_tahsil_odeme_tipi_id_seq'::regclass);
 R   ALTER TABLE public.ayar_cek_senet_tahsil_odeme_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    395    394    395            �           2604    157822    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_cek_senet_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_cek_senet_tipi_id_seq'::regclass);
 E   ALTER TABLE public.ayar_cek_senet_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    391    390    391            r           2604    157417    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_diger_database_bilgisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_diger_database_bilgisi_id_seq'::regclass);
 M   ALTER TABLE public.ayar_diger_database_bilgisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    351    350    351            }           2604    157437    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_edefter_donem_raporu ALTER COLUMN id SET DEFAULT nextval('public.ayar_edefter_donem_raporu_id_seq'::regclass);
 K   ALTER TABLE public.ayar_edefter_donem_raporu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    352    353    353            �           2604    157486    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_alici_bilgisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_alici_bilgisi_id_seq'::regclass);
 L   ALTER TABLE public.ayar_efatura_alici_bilgisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    356    357    357            �           2604    157602    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_cinsi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_evrak_cinsi_id_seq'::regclass);
 J   ALTER TABLE public.ayar_efatura_evrak_cinsi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    367    366    367            �           2604    157591    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_evrak_tipi_id_seq'::regclass);
 I   ALTER TABLE public.ayar_efatura_evrak_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    364    365    365            �           2604    157613    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_evrak_tipi_cinsi_id_seq'::regclass);
 O   ALTER TABLE public.ayar_efatura_evrak_tipi_cinsi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    369    368    369            �           2604    103567    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_fatura_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_fatura_tipi_id_seq'::regclass);
 J   ALTER TABLE public.ayar_efatura_fatura_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    284    285    285            �           2604    157498    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_gonderici_bilgisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_gonderici_bilgisi_id_seq'::regclass);
 P   ALTER TABLE public.ayar_efatura_gonderici_bilgisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    359    358    359            �           2604    157710    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_gonderim_sekli ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_gonderim_sekli_id_seq'::regclass);
 M   ALTER TABLE public.ayar_efatura_gonderim_sekli ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    381    380    381                       2604    157472    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_ihrac_kayitli_fatura_sebebi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq'::regclass);
 Z   ALTER TABLE public.ayar_efatura_ihrac_kayitli_fatura_sebebi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    355    354    355            2           2604    50019    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_iletisim_kanali ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_iletisim_kanali_id_seq'::regclass);
 N   ALTER TABLE public.ayar_efatura_iletisim_kanali ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    192    191            5           2604    50021    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_istisna_kodu ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_istisna_kodu_id_seq'::regclass);
 K   ALTER TABLE public.ayar_efatura_istisna_kodu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    194    193            7           2604    50022    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_kimlik_semalari ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_kimlik_semalari_id_seq'::regclass);
 N   ALTER TABLE public.ayar_efatura_kimlik_semalari ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    196    195            �           2604    157758    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_odeme_sekli ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_odeme_sekli_id_seq'::regclass);
 J   ALTER TABLE public.ayar_efatura_odeme_sekli ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    386    387    387            �           2604    157774    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_paket_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_paket_tipi_id_seq'::regclass);
 I   ALTER TABLE public.ayar_efatura_paket_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    389    388    389            9           2604    50023    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_response_code ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_response_code_id_seq'::regclass);
 L   ALTER TABLE public.ayar_efatura_response_code ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    197            �           2604    103302    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_senaryo_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_senaryo_tipi_id_seq'::regclass);
 K   ALTER TABLE public.ayar_efatura_senaryo_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    274    273    274            �           2604    184607    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_teslim_sarti ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_teslim_sarti_id_seq'::regclass);
 K   ALTER TABLE public.ayar_efatura_teslim_sarti ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    397    396    397            ;           2604    50025    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_tevkifat_kodu ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_tevkifat_kodu_id_seq'::regclass);
 L   ALTER TABLE public.ayar_efatura_tevkifat_kodu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    200    199            >           2604    50026    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_efatura_vergi_kodu ALTER COLUMN id SET DEFAULT nextval('public.ayar_efatura_vergi_kodu_id_seq'::regclass);
 I   ALTER TABLE public.ayar_efatura_vergi_kodu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    201            �           2604    157667    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_fatura_no_serisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_fatura_no_serisi_id_seq'::regclass);
 G   ALTER TABLE public.ayar_fatura_no_serisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    375    374    375            @           2604    50028    id    DEFAULT     x   ALTER TABLE ONLY public.ayar_firma_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_firma_tipi_id_seq'::regclass);
 A   ALTER TABLE public.ayar_firma_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    206    203            B           2604    50029    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_firma_tipi_detay ALTER COLUMN id SET DEFAULT nextval('public.ayar_firma_tipi_detay_id_seq'::regclass);
 G   ALTER TABLE public.ayar_firma_tipi_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    205    204            �           2604    157699    id    DEFAULT     t   ALTER TABLE ONLY public.ayar_fis_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_fis_tipi_id_seq'::regclass);
 ?   ALTER TABLE public.ayar_fis_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    378    379    379            D           2604    50030    id    DEFAULT     ~   ALTER TABLE ONLY public.ayar_genel_ayarlar ALTER COLUMN id SET DEFAULT nextval('public.ayar_genel_ayarlar_id_seq'::regclass);
 D   ALTER TABLE public.ayar_genel_ayarlar ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    208    207            �           2604    96414    id    DEFAULT     z   ALTER TABLE ONLY public.ayar_hane_sayisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_hane_sayisi_id_seq'::regclass);
 B   ALTER TABLE public.ayar_hane_sayisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    264    263    264            K           2604    133808    id    DEFAULT     x   ALTER TABLE ONLY public.ayar_hesap_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_hesap_tipi_id_seq'::regclass);
 A   ALTER TABLE public.ayar_hesap_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    333    332    333            �           2604    157643    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_irsaliye_fatura_no_serisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_irsaliye_fatura_no_serisi_id_seq'::regclass);
 P   ALTER TABLE public.ayar_irsaliye_fatura_no_serisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    371    370    371            �           2604    157656    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi ALTER COLUMN id SET DEFAULT nextval('public.ayar_irsaliye_no_serisi_id_seq'::regclass);
 I   ALTER TABLE public.ayar_irsaliye_no_serisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    373    372    373            �           2604    157552    id    DEFAULT     x   ALTER TABLE ONLY public.ayar_modul_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_modul_tipi_id_seq'::regclass);
 A   ALTER TABLE public.ayar_modul_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    363    362    363            �           2604    157688    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_musteri_firma_turu ALTER COLUMN id SET DEFAULT nextval('public.ayar_musteri_firma_turu_id_seq'::regclass);
 I   ALTER TABLE public.ayar_musteri_firma_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    377    376    377            �           2604    217663    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_odeme_baslangic_donemi ALTER COLUMN id SET DEFAULT nextval('public.ayar_odeme_baslangic_donemi_id_seq'::regclass);
 M   ALTER TABLE public.ayar_odeme_baslangic_donemi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    407    406    407            n           2604    157401    id    DEFAULT     z   ALTER TABLE ONLY public.ayar_odeme_sekli ALTER COLUMN id SET DEFAULT nextval('public.ayar_odeme_sekli_id_seq'::regclass);
 B   ALTER TABLE public.ayar_odeme_sekli ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    348    349    349            �           2604    217751    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_askerlik_durumu ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_askerlik_durumu_id_seq'::regclass);
 O   ALTER TABLE public.ayar_personel_askerlik_durumu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    413    412    413            �           2604    217942    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_ayrilma_nedeni_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_ayrilma_nedeni_tipi_id_seq'::regclass);
 S   ALTER TABLE public.ayar_personel_ayrilma_nedeni_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    441    440    441            �           2604    114938    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_birim ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_birim_id_seq'::regclass);
 E   ALTER TABLE public.ayar_personel_birim ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    290    291    291            �           2604    114927    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_bolum ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_bolum_id_seq'::regclass);
 E   ALTER TABLE public.ayar_personel_bolum ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    289    288    289            �           2604    217762    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_cinsiyet ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_cinsiyet_id_seq'::regclass);
 H   ALTER TABLE public.ayar_personel_cinsiyet ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    415    414    415            �           2604    217852    id    DEFAULT     |   ALTER TABLE ONLY public.ayar_personel_dil ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_dil_id_seq'::regclass);
 C   ALTER TABLE public.ayar_personel_dil ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    425    424    425            �           2604    217863    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_dil_seviyesi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_dil_seviyesi_id_seq'::regclass);
 L   ALTER TABLE public.ayar_personel_dil_seviyesi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    427    426    427            �           2604    217740    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_egitim_durumu ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_egitim_durumu_id_seq'::regclass);
 M   ALTER TABLE public.ayar_personel_egitim_durumu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    411    410    411            �           2604    217885    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_ehliyet_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_ehliyet_tipi_id_seq'::regclass);
 L   ALTER TABLE public.ayar_personel_ehliyet_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    431    430    431            �           2604    114954    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_gorev ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_gorev_id_seq'::regclass);
 E   ALTER TABLE public.ayar_personel_gorev ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    293    292    293            �           2604    217795    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_izin_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_izin_tipi_id_seq'::regclass);
 I   ALTER TABLE public.ayar_personel_izin_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    420    421    421            �           2604    217773    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_kan_grubu ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_kan_grubu_id_seq'::regclass);
 I   ALTER TABLE public.ayar_personel_kan_grubu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    417    416    417            �           2604    217806    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_medeni_durum ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_medeni_durum_id_seq'::regclass);
 L   ALTER TABLE public.ayar_personel_medeni_durum ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    423    422    423            �           2604    217931    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_mektup_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_mektup_tipi_id_seq'::regclass);
 K   ALTER TABLE public.ayar_personel_mektup_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    439    438    439            �           2604    217896    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_myk_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_myk_tipi_id_seq'::regclass);
 H   ALTER TABLE public.ayar_personel_myk_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    432    433    433            �           2604    217784    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_rapor_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_rapor_tipi_id_seq'::regclass);
 J   ALTER TABLE public.ayar_personel_rapor_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    419    418    419            �           2604    217907    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_src_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_src_tipi_id_seq'::regclass);
 H   ALTER TABLE public.ayar_personel_src_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    434    435    435            �           2604    217918    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_personel_tatil_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_tatil_tipi_id_seq'::regclass);
 J   ALTER TABLE public.ayar_personel_tatil_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    436    437    437            �           2604    217693    id    DEFAULT     ~   ALTER TABLE ONLY public.ayar_personel_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_personel_tipi_id_seq'::regclass);
 D   ALTER TABLE public.ayar_personel_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    409    408    409            F           2604    50032    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_sabit_degisken ALTER COLUMN id SET DEFAULT nextval('public.ayar_sabit_degisken_id_seq'::regclass);
 E   ALTER TABLE public.ayar_sabit_degisken ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    210    209            �           2604    157727    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_sevkiyat_hazirlama_durumu ALTER COLUMN id SET DEFAULT nextval('public.ayar_sevkiyat_hazirlama_durumu_id_seq'::regclass);
 P   ALTER TABLE public.ayar_sevkiyat_hazirlama_durumu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    383    382    383            �           2604    157738    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_stok_hareket_ayari ALTER COLUMN id SET DEFAULT nextval('public.ayar_stok_hareket_ayari_id_seq'::regclass);
 I   ALTER TABLE public.ayar_stok_hareket_ayari ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    385    384    385            �           2604    103329    id    DEFAULT     �   ALTER TABLE ONLY public.ayar_stok_hareket_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_stok_hareket_tipi_id_seq'::regclass);
 H   ALTER TABLE public.ayar_stok_hareket_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    275    276    276            �           2604    184701    id    DEFAULT     |   ALTER TABLE ONLY public.ayar_teklif_durum ALTER COLUMN id SET DEFAULT nextval('public.ayar_teklif_durum_id_seq'::regclass);
 C   ALTER TABLE public.ayar_teklif_durum ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    398    399    399            �           2604    217651    id    DEFAULT     z   ALTER TABLE ONLY public.ayar_teklif_tipi ALTER COLUMN id SET DEFAULT nextval('public.ayar_teklif_tipi_id_seq'::regclass);
 B   ALTER TABLE public.ayar_teklif_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    405    404    405            �           2604    114978    id    DEFAULT     z   ALTER TABLE ONLY public.ayar_vergi_orani ALTER COLUMN id SET DEFAULT nextval('public.ayar_vergi_orani_id_seq'::regclass);
 B   ALTER TABLE public.ayar_vergi_orani ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    295    294    295            �           2604    88303    id    DEFAULT     d   ALTER TABLE ONLY public.banka ALTER COLUMN id SET DEFAULT nextval('public.banka_id_seq'::regclass);
 7   ALTER TABLE public.banka ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    262    261    262            >           2604    131295    id    DEFAULT     r   ALTER TABLE ONLY public.banka_subesi ALTER COLUMN id SET DEFAULT nextval('public.banka_subesi_id_seq'::regclass);
 >   ALTER TABLE public.banka_subesi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    320    321    321            I           2604    133707    id    DEFAULT     �   ALTER TABLE ONLY public.barkod_hazirlik_dosya_turu ALTER COLUMN id SET DEFAULT nextval('public.barkod_hazirlik_dosya_turu_id_seq'::regclass);
 L   ALTER TABLE public.barkod_hazirlik_dosya_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    330    331    331            E           2604    133678    id    DEFAULT     ~   ALTER TABLE ONLY public.barkod_serino_turu ALTER COLUMN id SET DEFAULT nextval('public.barkod_serino_turu_id_seq'::regclass);
 D   ALTER TABLE public.barkod_serino_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    326    327    327            G           2604    133690    id    DEFAULT     t   ALTER TABLE ONLY public.barkod_tezgah ALTER COLUMN id SET DEFAULT nextval('public.barkod_tezgah_id_seq'::regclass);
 ?   ALTER TABLE public.barkod_tezgah ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    329    328    329            �           2604    114993    id    DEFAULT     d   ALTER TABLE ONLY public.bolge ALTER COLUMN id SET DEFAULT nextval('public.bolge_id_seq'::regclass);
 7   ALTER TABLE public.bolge ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    296    297    297            H           2604    50035    id    DEFAULT     n   ALTER TABLE ONLY public.bolge_turu ALTER COLUMN id SET DEFAULT nextval('public.bolge_turu_id_seq'::regclass);
 <   ALTER TABLE public.bolge_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    211            @           2604    131332    id    DEFAULT     p   ALTER TABLE ONLY public.cins_ailesi ALTER COLUMN id SET DEFAULT nextval('public.cins_ailesi_id_seq'::regclass);
 =   ALTER TABLE public.cins_ailesi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    323    322    323            B           2604    131385    id    DEFAULT     t   ALTER TABLE ONLY public.cins_ozelligi ALTER COLUMN id SET DEFAULT nextval('public.cins_ozelligi_id_seq'::regclass);
 ?   ALTER TABLE public.cins_ozelligi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    325    324    325            <           2604    123267    id    DEFAULT     n   ALTER TABLE ONLY public.doviz_kuru ALTER COLUMN id SET DEFAULT nextval('public.doviz_kuru_id_seq'::regclass);
 <   ALTER TABLE public.doviz_kuru ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    318    319    319            L           2604    50039    id    DEFAULT     d   ALTER TABLE ONLY public.hesap ALTER COLUMN id SET DEFAULT nextval('public.hesap_id_seq'::regclass);
 7   ALTER TABLE public.hesap ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    216    213            O           2604    50040    id    DEFAULT     p   ALTER TABLE ONLY public.hesap_grubu ALTER COLUMN id SET DEFAULT nextval('public.hesap_grubu_id_seq'::regclass);
 =   ALTER TABLE public.hesap_grubu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    215    214                       2604    115052    id    DEFAULT     p   ALTER TABLE ONLY public.hesap_karti ALTER COLUMN id SET DEFAULT nextval('public.hesap_karti_id_seq'::regclass);
 =   ALTER TABLE public.hesap_karti ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    299    298    299            Q           2604    50041    id    DEFAULT     p   ALTER TABLE ONLY public.hesap_plani ALTER COLUMN id SET DEFAULT nextval('public.hesap_plani_id_seq'::regclass);
 =   ALTER TABLE public.hesap_plani ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    218    217            �           2604    114916    id    DEFAULT     r   ALTER TABLE ONLY public.medeni_durum ALTER COLUMN id SET DEFAULT nextval('public.medeni_durum_id_seq'::regclass);
 >   ALTER TABLE public.medeni_durum ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    286    287    287            S           2604    50042    id    DEFAULT     �   ALTER TABLE ONLY public.muhasebe_hesap_plani ALTER COLUMN id SET DEFAULT nextval('public.muhasebe_hesap_plani_id_seq'::regclass);
 F   ALTER TABLE public.muhasebe_hesap_plani ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    220    219                       2604    123084    id    DEFAULT     p   ALTER TABLE ONLY public.olcu_birimi ALTER COLUMN id SET DEFAULT nextval('public.olcu_birimi_id_seq'::regclass);
 =   ALTER TABLE public.olcu_birimi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    300    301    301            �           2604    96434    id    DEFAULT     p   ALTER TABLE ONLY public.para_birimi ALTER COLUMN id SET DEFAULT nextval('public.para_birimi_id_seq'::regclass);
 =   ALTER TABLE public.para_birimi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    265    266    266            U           2604    50045    id    DEFAULT     �   ALTER TABLE ONLY public.personel_ayrilma_nedeni_tipi ALTER COLUMN id SET DEFAULT nextval('public.personel_ayrilma_nedeni_tipi_id_seq'::regclass);
 N   ALTER TABLE public.personel_ayrilma_nedeni_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    221            W           2604    50049    id    DEFAULT     �   ALTER TABLE ONLY public.personel_calisma_gecmisi ALTER COLUMN id SET DEFAULT nextval('public.personel_calisma_gecmisi_id_seq'::regclass);
 J   ALTER TABLE public.personel_calisma_gecmisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    224    223            �           2604    217874    id    DEFAULT     �   ALTER TABLE ONLY public.personel_dil_bilgisi ALTER COLUMN id SET DEFAULT nextval('public.personel_dil_bilgisi_id_seq'::regclass);
 F   ALTER TABLE public.personel_dil_bilgisi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    428    429    429            �           2604    217956    id    DEFAULT     v   ALTER TABLE ONLY public.personel_karti ALTER COLUMN id SET DEFAULT nextval('public.personel_karti_id_seq'::regclass);
 @   ALTER TABLE public.personel_karti ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    442    443    443            Y           2604    50051    id    DEFAULT     �   ALTER TABLE ONLY public.personel_tasima_servis ALTER COLUMN id SET DEFAULT nextval('public.personel_tasima_servis_id_seq'::regclass);
 H   ALTER TABLE public.personel_tasima_servis ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    226    225            !           2604    123120    id    DEFAULT     �   ALTER TABLE ONLY public.quality_form_mail_reciever ALTER COLUMN id SET DEFAULT nextval('public.quality_form_mail_reciever_id_seq'::regclass);
 L   ALTER TABLE public.quality_form_mail_reciever ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    305    304    305            [           2604    50052    id    DEFAULT     f   ALTER TABLE ONLY public.recete ALTER COLUMN id SET DEFAULT nextval('public.recete_id_seq'::regclass);
 8   ALTER TABLE public.recete ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    230    227            ]           2604    50053    id    DEFAULT     x   ALTER TABLE ONLY public.recete_hammadde ALTER COLUMN id SET DEFAULT nextval('public.recete_hammadde_id_seq'::regclass);
 A   ALTER TABLE public.recete_hammadde ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    229    228            _           2604    50054    id    DEFAULT     r   ALTER TABLE ONLY public.satis_fatura ALTER COLUMN id SET DEFAULT nextval('public.satis_fatura_id_seq'::regclass);
 >   ALTER TABLE public.satis_fatura ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    234    231            a           2604    50055    id    DEFAULT     ~   ALTER TABLE ONLY public.satis_fatura_detay ALTER COLUMN id SET DEFAULT nextval('public.satis_fatura_detay_id_seq'::regclass);
 D   ALTER TABLE public.satis_fatura_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    233    232            c           2604    50056    id    DEFAULT     v   ALTER TABLE ONLY public.satis_irsaliye ALTER COLUMN id SET DEFAULT nextval('public.satis_irsaliye_id_seq'::regclass);
 @   ALTER TABLE public.satis_irsaliye ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    238    235            e           2604    50057    id    DEFAULT     �   ALTER TABLE ONLY public.satis_irsaliye_detay ALTER COLUMN id SET DEFAULT nextval('public.satis_irsaliye_detay_id_seq'::regclass);
 F   ALTER TABLE public.satis_irsaliye_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    237    236            g           2604    50058    id    DEFAULT     t   ALTER TABLE ONLY public.satis_siparis ALTER COLUMN id SET DEFAULT nextval('public.satis_siparis_id_seq'::regclass);
 ?   ALTER TABLE public.satis_siparis ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    242    239            i           2604    50059    id    DEFAULT     �   ALTER TABLE ONLY public.satis_siparis_detay ALTER COLUMN id SET DEFAULT nextval('public.satis_siparis_detay_id_seq'::regclass);
 E   ALTER TABLE public.satis_siparis_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    240            �           2604    184740    id    DEFAULT     r   ALTER TABLE ONLY public.satis_teklif ALTER COLUMN id SET DEFAULT nextval('public.satis_teklif_id_seq'::regclass);
 >   ALTER TABLE public.satis_teklif ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    401    400    401            �           2604    184822    id    DEFAULT     ~   ALTER TABLE ONLY public.satis_teklif_detay ALTER COLUMN id SET DEFAULT nextval('public.satis_teklif_detay_id_seq'::regclass);
 D   ALTER TABLE public.satis_teklif_detay ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    403    402    403            �           2604    96458    id    DEFAULT     d   ALTER TABLE ONLY public.sehir ALTER COLUMN id SET DEFAULT nextval('public.sehir_id_seq'::regclass);
 7   ALTER TABLE public.sehir ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    270    269    270            O           2604    134023    id    DEFAULT     n   ALTER TABLE ONLY public.stok_grubu ALTER COLUMN id SET DEFAULT nextval('public.stok_grubu_id_seq'::regclass);
 <   ALTER TABLE public.stok_grubu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    336    337    337            M           2604    133960    id    DEFAULT     x   ALTER TABLE ONLY public.stok_grubu_turu ALTER COLUMN id SET DEFAULT nextval('public.stok_grubu_turu_id_seq'::regclass);
 A   ALTER TABLE public.stok_grubu_turu ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    335    334    335            �           2604    103359    id    DEFAULT     t   ALTER TABLE ONLY public.stok_hareketi ALTER COLUMN id SET DEFAULT nextval('public.stok_hareketi_id_seq'::regclass);
 ?   ALTER TABLE public.stok_hareketi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    277    278    278            V           2604    134135    id    DEFAULT     n   ALTER TABLE ONLY public.stok_karti ALTER COLUMN id SET DEFAULT nextval('public.stok_karti_id_seq'::regclass);
 <   ALTER TABLE public.stok_karti ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    339    338    339            m           2604    50065    id    DEFAULT     l   ALTER TABLE ONLY public.stok_tipi ALTER COLUMN id SET DEFAULT nextval('public.stok_tipi_id_seq'::regclass);
 ;   ALTER TABLE public.stok_tipi ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    244    243            �           2604    88217    id    DEFAULT     �   ALTER TABLE ONLY public.sys_application_settings ALTER COLUMN id SET DEFAULT nextval('public.sys_application_settings_id_seq'::regclass);
 J   ALTER TABLE public.sys_application_settings ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    259    260    260            �           2604    103486    id    DEFAULT     �   ALTER TABLE ONLY public.sys_application_settings_other ALTER COLUMN id SET DEFAULT nextval('public.sys_application_settings_other_id_seq'::regclass);
 P   ALTER TABLE public.sys_application_settings_other ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    280    279    280            x           2604    65744    id    DEFAULT     ~   ALTER TABLE ONLY public.sys_grid_col_color ALTER COLUMN id SET DEFAULT nextval('public.sys_grid_col_color_id_seq'::regclass);
 D   ALTER TABLE public.sys_grid_col_color ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    253    254    254            ~           2604    65763    id    DEFAULT     �   ALTER TABLE ONLY public.sys_grid_col_percent ALTER COLUMN id SET DEFAULT nextval('public.sys_grid_col_percent_id_seq'::regclass);
 F   ALTER TABLE public.sys_grid_col_percent ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    255    256    256            t           2604    65729    id    DEFAULT     ~   ALTER TABLE ONLY public.sys_grid_col_width ALTER COLUMN id SET DEFAULT nextval('public.sys_grid_col_width_id_seq'::regclass);
 D   ALTER TABLE public.sys_grid_col_width ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    252    251    252            �           2604    88202    id    DEFAULT     �   ALTER TABLE ONLY public.sys_grid_default_order_filter ALTER COLUMN id SET DEFAULT nextval('public.sys_grid_default_order_filter_id_seq'::regclass);
 O   ALTER TABLE public.sys_grid_default_order_filter ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    258    257    258            r           2604    51763    id    DEFAULT     j   ALTER TABLE ONLY public.sys_lang ALTER COLUMN id SET DEFAULT nextval('public.sys_lang_id_seq'::regclass);
 :   ALTER TABLE public.sys_lang ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    250    249    250            &           2604    123151    id    DEFAULT     �   ALTER TABLE ONLY public.sys_lang_data_content ALTER COLUMN id SET DEFAULT nextval('public.sys_lang_data_content_id_seq'::regclass);
 G   ALTER TABLE public.sys_lang_data_content ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    308    309    309            (           2604    123165    id    DEFAULT     �   ALTER TABLE ONLY public.sys_lang_gui_content ALTER COLUMN id SET DEFAULT nextval('public.sys_lang_gui_content_id_seq'::regclass);
 F   ALTER TABLE public.sys_lang_gui_content ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    310    311    311            #           2604    123137    id    DEFAULT     �   ALTER TABLE ONLY public.sys_multi_lang_data_table_list ALTER COLUMN id SET DEFAULT nextval('public.sys_multi_lang_data_table_list_id_seq'::regclass);
 P   ALTER TABLE public.sys_multi_lang_data_table_list ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    306    307    307            o           2604    50066    id    DEFAULT     �   ALTER TABLE ONLY public.sys_permission_source ALTER COLUMN id SET DEFAULT nextval('public.sys_permission_source_id_seq'::regclass);
 G   ALTER TABLE public.sys_permission_source ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    248    245            q           2604    50067    id    DEFAULT     �   ALTER TABLE ONLY public.sys_permission_source_group ALTER COLUMN id SET DEFAULT nextval('public.sys_permission_source_group_id_seq'::regclass);
 M   ALTER TABLE public.sys_permission_source_group ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    247    246            �           2604    96488    id    DEFAULT     �   ALTER TABLE ONLY public.sys_quality_form_number ALTER COLUMN id SET DEFAULT nextval('public.sys_quality_form_number_id_seq'::regclass);
 I   ALTER TABLE public.sys_quality_form_number ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    272    271    272            0           2604    123189    id    DEFAULT     j   ALTER TABLE ONLY public.sys_user ALTER COLUMN id SET DEFAULT nextval('public.sys_user_id_seq'::regclass);
 :   ALTER TABLE public.sys_user ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    313    312    313            3           2604    123209    id    DEFAULT     �   ALTER TABLE ONLY public.sys_user_access_right ALTER COLUMN id SET DEFAULT nextval('public.sys_user_access_right_id_seq'::regclass);
 G   ALTER TABLE public.sys_user_access_right ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    315    314    315            :           2604    123251    id    DEFAULT     �   ALTER TABLE ONLY public.sys_user_mac_address_exception ALTER COLUMN id SET DEFAULT nextval('public.sys_user_mac_address_exception_id_seq'::regclass);
 P   ALTER TABLE public.sys_user_mac_address_exception ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    316    317    317            �           2604    96445    id    DEFAULT     b   ALTER TABLE ONLY public.ulke ALTER COLUMN id SET DEFAULT nextval('public.ulke_id_seq'::regclass);
 6   ALTER TABLE public.ulke ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    267    268    268                       2604    123109    id    DEFAULT     �   ALTER TABLE ONLY public.urun_kabul_red_nedeni ALTER COLUMN id SET DEFAULT nextval('public.urun_kabul_red_nedeni_id_seq'::regclass);
 G   ALTER TABLE public.urun_kabul_red_nedeni ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    303    302    303            �          0    49593    alis_teklif 
   TABLE DATA                 COPY public.alis_teklif (id, validity, teklif_no, teklif_tarihi, cari_kod, firma, vergi_dairesi, vergi_no, aciklama, referans, teslim_tarihi, son_gecerlilik_tarihi, para_birimi, odeme_baslangic_donemi, toplam_tutar, toplam_iskonto_tutar, toplam_kdv_tutar, genel_toplam, musteri_temsilcisi_id, ulke, sehir, adres, posta_kodu, yurtici_ihracat, ortalama_opsiyon, fatura_tipi, tevkifat_kodu, ihrac_kayit_kodu, tevkifat_pay, tevkifat_payda, genel_iskonto_orani, genel_iskonto_tutar, is_e_fatura, siparislesti) FROM stdin;
    public       postgres    false    183   ��      �          0    49607    alis_teklif_detay 
   TABLE DATA               D   COPY public.alis_teklif_detay (id, validity, header_id) FROM stdin;
    public       postgres    false    184   ��      �           0    0    alis_teklif_detay_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.alis_teklif_detay_id_seq', 1, false);
            public       postgres    false    185            �           0    0    alis_teklif_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.alis_teklif_id_seq', 6, true);
            public       postgres    false    186            �          0    49615    alis_tsif_kur 
   TABLE DATA               �   COPY public.alis_tsif_kur (id, validity, alis_teklif_id, alis_siparis_id, alis_irsaliye_id, alis_fatura_id, para_birimi, deger) FROM stdin;
    public       postgres    false    187   Տ      �           0    0    alis_tsif_kur_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.alis_tsif_kur_id_seq', 1, false);
            public       postgres    false    188            �          0    49621    ambar 
   TABLE DATA               �   COPY public.ambar (id, validity, ambar_adi, is_varsayilan_hammadde_ambari, is_varsayilan_uretim_ambari, is_varsayilan_satis_ambari) FROM stdin;
    public       postgres    false    189   �      �           0    0    ambar_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.ambar_id_seq', 2, true);
            public       postgres    false    190            >          0    142417    ayar_barkod_hazirlik_dosya_turu 
   TABLE DATA               L   COPY public.ayar_barkod_hazirlik_dosya_turu (id, validity, tur) FROM stdin;
    public       postgres    false    347   +�      �           0    0 &   ayar_barkod_hazirlik_dosya_turu_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.ayar_barkod_hazirlik_dosya_turu_id_seq', 3, true);
            public       postgres    false    346            8          0    142379    ayar_barkod_serino_turu 
   TABLE DATA               N   COPY public.ayar_barkod_serino_turu (id, validity, tur, aciklama) FROM stdin;
    public       postgres    false    341   ��      �           0    0    ayar_barkod_serino_turu_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.ayar_barkod_serino_turu_id_seq', 3, true);
            public       postgres    false    340            :          0    142390    ayar_barkod_tezgah 
   TABLE DATA               P   COPY public.ayar_barkod_tezgah (id, validity, tezgah_adi, ambar_id) FROM stdin;
    public       postgres    false    343   ��      �           0    0    ayar_barkod_tezgah_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.ayar_barkod_tezgah_id_seq', 1, true);
            public       postgres    false    342            <          0    142406    ayar_barkod_urun_turu 
   TABLE DATA               B   COPY public.ayar_barkod_urun_turu (id, validity, tur) FROM stdin;
    public       postgres    false    345   ߐ      �           0    0    ayar_barkod_urun_turu_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.ayar_barkod_urun_turu_id_seq', 2, true);
            public       postgres    false    344            L          0    157512    ayar_bordro_tipi 
   TABLE DATA               ?   COPY public.ayar_bordro_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    361   �      �           0    0    ayar_bordro_tipi_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.ayar_bordro_tipi_id_seq', 1, false);
            public       postgres    false    360            l          0    157836    ayar_cek_senet_cash_edici_tipi 
   TABLE DATA               M   COPY public.ayar_cek_senet_cash_edici_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    393   0�      �           0    0 %   ayar_cek_senet_cash_edici_tipi_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.ayar_cek_senet_cash_edici_tipi_id_seq', 1, false);
            public       postgres    false    392            n          0    157847     ayar_cek_senet_tahsil_odeme_tipi 
   TABLE DATA               O   COPY public.ayar_cek_senet_tahsil_odeme_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    395   M�      �           0    0 '   ayar_cek_senet_tahsil_odeme_tipi_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.ayar_cek_senet_tahsil_odeme_tipi_id_seq', 1, false);
            public       postgres    false    394            j          0    157819    ayar_cek_senet_tipi 
   TABLE DATA               B   COPY public.ayar_cek_senet_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    391   j�      �           0    0    ayar_cek_senet_tipi_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.ayar_cek_senet_tipi_id_seq', 1, false);
            public       postgres    false    390            B          0    157414    ayar_diger_database_bilgisi 
   TABLE DATA               ;  COPY public.ayar_diger_database_bilgisi (id, validity, db_name, host_name, db_user, db_pass, db_port, firma_adi, is_aybey_teklif_hesapla, is_bulut_teklif_hesapla, is_maliyet_analiz, is_siparis_kopyala, is_otomatik_doviz_kaydet, is_staff_personel_bilgisi, is_uretim_takip, is_pano_uretim, is_nakit_akis) FROM stdin;
    public       postgres    false    351   ��      �           0    0 "   ayar_diger_database_bilgisi_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.ayar_diger_database_bilgisi_id_seq', 1, false);
            public       postgres    false    350            D          0    157434    ayar_edefter_donem_raporu 
   TABLE DATA               �   COPY public.ayar_edefter_donem_raporu (id, validity, rapor_baslangic_donemi, rapor_bitis_donemi, rapor_alma_tarihi, yevmiye_no_baslangic, yevmiye_no_bitis) FROM stdin;
    public       postgres    false    353   ��      �           0    0     ayar_edefter_donem_raporu_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_edefter_donem_raporu_id_seq', 1, false);
            public       postgres    false    352            H          0    157483    ayar_efatura_alici_bilgisi 
   TABLE DATA               �   COPY public.ayar_efatura_alici_bilgisi (id, validity, alias, title, type_, first_creation_time, alias_creation_time, register_time, identifier) FROM stdin;
    public       postgres    false    357   ��      �           0    0 !   ayar_efatura_alici_bilgisi_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.ayar_efatura_alici_bilgisi_id_seq', 1, false);
            public       postgres    false    356            R          0    157599    ayar_efatura_evrak_cinsi 
   TABLE DATA               M   COPY public.ayar_efatura_evrak_cinsi (id, validity, evrak_cinsi) FROM stdin;
    public       postgres    false    367   ޑ      �           0    0    ayar_efatura_evrak_cinsi_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.ayar_efatura_evrak_cinsi_id_seq', 1, false);
            public       postgres    false    366            P          0    157588    ayar_efatura_evrak_tipi 
   TABLE DATA               K   COPY public.ayar_efatura_evrak_tipi (id, validity, evrak_tipi) FROM stdin;
    public       postgres    false    365   ��      T          0    157610    ayar_efatura_evrak_tipi_cinsi 
   TABLE DATA               d   COPY public.ayar_efatura_evrak_tipi_cinsi (id, validity, evrak_tipi_id, evrak_cinsi_id) FROM stdin;
    public       postgres    false    369   �      �           0    0 $   ayar_efatura_evrak_tipi_cinsi_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.ayar_efatura_evrak_tipi_cinsi_id_seq', 1, false);
            public       postgres    false    368            �           0    0    ayar_efatura_evrak_tipi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_efatura_evrak_tipi_id_seq', 1, false);
            public       postgres    false    364                       0    103564    ayar_efatura_fatura_tipi 
   TABLE DATA               E   COPY public.ayar_efatura_fatura_tipi (id, validity, tip) FROM stdin;
    public       postgres    false    285   5�      �           0    0    ayar_efatura_fatura_tipi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_efatura_fatura_tipi_id_seq', 7, true);
            public       postgres    false    284            J          0    157495    ayar_efatura_gonderici_bilgisi 
   TABLE DATA               �   COPY public.ayar_efatura_gonderici_bilgisi (id, validity, alias, title, type_, first_creation_time, alias_creation_time, register_time, identifier) FROM stdin;
    public       postgres    false    359   ��      �           0    0 %   ayar_efatura_gonderici_bilgisi_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.ayar_efatura_gonderici_bilgisi_id_seq', 1, false);
            public       postgres    false    358            `          0    157707    ayar_efatura_gonderim_sekli 
   TABLE DATA               f   COPY public.ayar_efatura_gonderim_sekli (id, validity, kod, kod_adi, aciklama, is_active) FROM stdin;
    public       postgres    false    381   ��      �           0    0 "   ayar_efatura_gonderim_sekli_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.ayar_efatura_gonderim_sekli_id_seq', 1, false);
            public       postgres    false    380            F          0    157469 (   ayar_efatura_ihrac_kayitli_fatura_sebebi 
   TABLE DATA               _   COPY public.ayar_efatura_ihrac_kayitli_fatura_sebebi (id, validity, kod, aciklama) FROM stdin;
    public       postgres    false    355   Β      �           0    0 /   ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq    SEQUENCE SET     ^   SELECT pg_catalog.setval('public.ayar_efatura_ihrac_kayitli_fatura_sebebi_id_seq', 1, false);
            public       postgres    false    354            �          0    49628    ayar_efatura_iletisim_kanali 
   TABLE DATA               S   COPY public.ayar_efatura_iletisim_kanali (id, validity, kod, aciklama) FROM stdin;
    public       postgres    false    191   �      �           0    0 #   ayar_efatura_iletisim_kanali_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.ayar_efatura_iletisim_kanali_id_seq', 92, true);
            public       postgres    false    192            �          0    49643    ayar_efatura_istisna_kodu 
   TABLE DATA               o   COPY public.ayar_efatura_istisna_kodu (id, validity, kod, aciklama, is_tam_istisna, fatura_tip_id) FROM stdin;
    public       postgres    false    193   ѕ      �           0    0     ayar_efatura_istisna_kodu_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_efatura_istisna_kodu_id_seq', 65, true);
            public       postgres    false    194            �          0    49653    ayar_efatura_kimlik_semalari 
   TABLE DATA               U   COPY public.ayar_efatura_kimlik_semalari (id, validity, deger, aciklama) FROM stdin;
    public       postgres    false    195   ��      �           0    0 #   ayar_efatura_kimlik_semalari_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.ayar_efatura_kimlik_semalari_id_seq', 17, true);
            public       postgres    false    196            f          0    157755    ayar_efatura_odeme_sekli 
   TABLE DATA               s   COPY public.ayar_efatura_odeme_sekli (id, validity, kod, odeme_sekli, aciklama, is_efatura, is_active) FROM stdin;
    public       postgres    false    387   ۤ      �           0    0    ayar_efatura_odeme_sekli_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.ayar_efatura_odeme_sekli_id_seq', 1, false);
            public       postgres    false    386            h          0    157771    ayar_efatura_paket_tipi 
   TABLE DATA               d   COPY public.ayar_efatura_paket_tipi (id, validity, kod, paket_adi, aciklama, is_active) FROM stdin;
    public       postgres    false    389   ��      �           0    0    ayar_efatura_paket_tipi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_efatura_paket_tipi_id_seq', 1, false);
            public       postgres    false    388            �          0    49659    ayar_efatura_response_code 
   TABLE DATA               I   COPY public.ayar_efatura_response_code (id, validity, deger) FROM stdin;
    public       postgres    false    197   �      �           0    0 !   ayar_efatura_response_code_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_efatura_response_code_id_seq', 3, true);
            public       postgres    false    198            �          0    103299    ayar_efatura_senaryo_tipi 
   TABLE DATA               P   COPY public.ayar_efatura_senaryo_tipi (id, validity, tip, aciklama) FROM stdin;
    public       postgres    false    274   J�      �           0    0     ayar_efatura_senaryo_tipi_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.ayar_efatura_senaryo_tipi_id_seq', 5, true);
            public       postgres    false    273            p          0    184604    ayar_efatura_teslim_sarti 
   TABLE DATA               g   COPY public.ayar_efatura_teslim_sarti (id, validity, kod, aciklama, is_efatura, is_active) FROM stdin;
    public       postgres    false    397   �      �           0    0     ayar_efatura_teslim_sarti_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_efatura_teslim_sarti_id_seq', 1, false);
            public       postgres    false    396            �          0    49671    ayar_efatura_tevkifat_kodu 
   TABLE DATA               `   COPY public.ayar_efatura_tevkifat_kodu (id, validity, kodu, adi, orani, pay, payda) FROM stdin;
    public       postgres    false    199   �      �           0    0 !   ayar_efatura_tevkifat_kodu_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.ayar_efatura_tevkifat_kodu_id_seq', 1, false);
            public       postgres    false    200            �          0    49677    ayar_efatura_vergi_kodu 
   TABLE DATA               ^   COPY public.ayar_efatura_vergi_kodu (id, validity, kodu, adi, kisaltma, tevkifat) FROM stdin;
    public       postgres    false    201   ��      �           0    0    ayar_efatura_vergi_kodu_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_efatura_vergi_kodu_id_seq', 27, true);
            public       postgres    false    202            Z          0    157664    ayar_fatura_no_serisi 
   TABLE DATA               T   COPY public.ayar_fatura_no_serisi (id, validity, fatura_seri_id, deger) FROM stdin;
    public       postgres    false    375   k�      �           0    0    ayar_fatura_no_serisi_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.ayar_fatura_no_serisi_id_seq', 1, false);
            public       postgres    false    374            �          0    49690    ayar_firma_tipi 
   TABLE DATA               <   COPY public.ayar_firma_tipi (id, validity, tip) FROM stdin;
    public       postgres    false    203   ��      �          0    49694    ayar_firma_tipi_detay 
   TABLE DATA               P   COPY public.ayar_firma_tipi_detay (id, validity, deger, firma_tipi) FROM stdin;
    public       postgres    false    204   ��      �           0    0    ayar_firma_tipi_detay_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.ayar_firma_tipi_detay_id_seq', 6, true);
            public       postgres    false    205            �           0    0    ayar_firma_tipi_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ayar_firma_tipi_id_seq', 2, true);
            public       postgres    false    206            ^          0    157696    ayar_fis_tipi 
   TABLE DATA               <   COPY public.ayar_fis_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    379   #�      �           0    0    ayar_fis_tipi_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.ayar_fis_tipi_id_seq', 1, false);
            public       postgres    false    378            �          0    49702    ayar_genel_ayarlar 
   TABLE DATA               t   COPY public.ayar_genel_ayarlar (id, validity, donem, unvan, vergi_no, tc_no, firma_tipi, diger_ayarlar) FROM stdin;
    public       postgres    false    207   @�      �           0    0    ayar_genel_ayarlar_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.ayar_genel_ayarlar_id_seq', 1, true);
            public       postgres    false    208            �          0    96411    ayar_hane_sayisi 
   TABLE DATA               �   COPY public.ayar_hane_sayisi (id, validity, hesap_bakiye, alis_miktar, alis_fiyat, alis_tutar, satis_miktar, satis_fiyat, satis_tutar, stok_miktar, stok_fiyat) FROM stdin;
    public       postgres    false    264   ��      �           0    0    ayar_hane_sayisi_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.ayar_hane_sayisi_id_seq', 1, true);
            public       postgres    false    263            0          0    133805    ayar_hesap_tipi 
   TABLE DATA               >   COPY public.ayar_hesap_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    333   ݮ      �           0    0    ayar_hesap_tipi_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ayar_hesap_tipi_id_seq', 3, true);
            public       postgres    false    332            V          0    157640    ayar_irsaliye_fatura_no_serisi 
   TABLE DATA               e   COPY public.ayar_irsaliye_fatura_no_serisi (id, validity, deger, is_fatura, is_irsaliye) FROM stdin;
    public       postgres    false    371   �      �           0    0 %   ayar_irsaliye_fatura_no_serisi_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.ayar_irsaliye_fatura_no_serisi_id_seq', 1, false);
            public       postgres    false    370            X          0    157653    ayar_irsaliye_no_serisi 
   TABLE DATA               X   COPY public.ayar_irsaliye_no_serisi (id, validity, irsaliye_seri_id, deger) FROM stdin;
    public       postgres    false    373   +�      �           0    0    ayar_irsaliye_no_serisi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_irsaliye_no_serisi_id_seq', 1, false);
            public       postgres    false    372            N          0    157549    ayar_modul_tipi 
   TABLE DATA               >   COPY public.ayar_modul_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    363   H�      �           0    0    ayar_modul_tipi_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ayar_modul_tipi_id_seq', 4, true);
            public       postgres    false    362            \          0    157685    ayar_musteri_firma_turu 
   TABLE DATA               F   COPY public.ayar_musteri_firma_turu (id, validity, deger) FROM stdin;
    public       postgres    false    377   ��      �           0    0    ayar_musteri_firma_turu_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_musteri_firma_turu_id_seq', 1, false);
            public       postgres    false    376            z          0    217660    ayar_odeme_baslangic_donemi 
   TABLE DATA               _   COPY public.ayar_odeme_baslangic_donemi (id, validity, deger, aciklama, is_active) FROM stdin;
    public       postgres    false    407   ��      �           0    0 "   ayar_odeme_baslangic_donemi_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.ayar_odeme_baslangic_donemi_id_seq', 8, true);
            public       postgres    false    406            @          0    157398    ayar_odeme_sekli 
   TABLE DATA               k   COPY public.ayar_odeme_sekli (id, validity, kod, odeme_sekli, aciklama, is_efatura, is_active) FROM stdin;
    public       postgres    false    349   ,�      �           0    0    ayar_odeme_sekli_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.ayar_odeme_sekli_id_seq', 1, false);
            public       postgres    false    348            �          0    217748    ayar_personel_askerlik_durumu 
   TABLE DATA               L   COPY public.ayar_personel_askerlik_durumu (id, validity, deger) FROM stdin;
    public       postgres    false    413   I�      �           0    0 $   ayar_personel_askerlik_durumu_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.ayar_personel_askerlik_durumu_id_seq', 4, true);
            public       postgres    false    412            �          0    217939 !   ayar_personel_ayrilma_nedeni_tipi 
   TABLE DATA               P   COPY public.ayar_personel_ayrilma_nedeni_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    441   ��      �           0    0 (   ayar_personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.ayar_personel_ayrilma_nedeni_tipi_id_seq', 4, true);
            public       postgres    false    440                      0    114935    ayar_personel_birim 
   TABLE DATA               L   COPY public.ayar_personel_birim (id, validity, bolum_id, birim) FROM stdin;
    public       postgres    false    291   �      �           0    0    ayar_personel_birim_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.ayar_personel_birim_id_seq', 3, true);
            public       postgres    false    290                      0    114924    ayar_personel_bolum 
   TABLE DATA               B   COPY public.ayar_personel_bolum (id, validity, bolum) FROM stdin;
    public       postgres    false    289   7�      �           0    0    ayar_personel_bolum_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.ayar_personel_bolum_id_seq', 4, true);
            public       postgres    false    288            �          0    217759    ayar_personel_cinsiyet 
   TABLE DATA               E   COPY public.ayar_personel_cinsiyet (id, validity, deger) FROM stdin;
    public       postgres    false    415   i�      �           0    0    ayar_personel_cinsiyet_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.ayar_personel_cinsiyet_id_seq', 2, true);
            public       postgres    false    414            �          0    217849    ayar_personel_dil 
   TABLE DATA               @   COPY public.ayar_personel_dil (id, validity, deger) FROM stdin;
    public       postgres    false    425   ��      �           0    0    ayar_personel_dil_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.ayar_personel_dil_id_seq', 3, true);
            public       postgres    false    424            �          0    217860    ayar_personel_dil_seviyesi 
   TABLE DATA               I   COPY public.ayar_personel_dil_seviyesi (id, validity, deger) FROM stdin;
    public       postgres    false    427   ۱      �           0    0 !   ayar_personel_dil_seviyesi_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_personel_dil_seviyesi_id_seq', 5, true);
            public       postgres    false    426            ~          0    217737    ayar_personel_egitim_durumu 
   TABLE DATA               J   COPY public.ayar_personel_egitim_durumu (id, validity, deger) FROM stdin;
    public       postgres    false    411   $�      �           0    0 "   ayar_personel_egitim_durumu_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.ayar_personel_egitim_durumu_id_seq', 1, false);
            public       postgres    false    410            �          0    217882    ayar_personel_ehliyet_tipi 
   TABLE DATA               I   COPY public.ayar_personel_ehliyet_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    431   A�      �           0    0 !   ayar_personel_ehliyet_tipi_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.ayar_personel_ehliyet_tipi_id_seq', 17, true);
            public       postgres    false    430                      0    114951    ayar_personel_gorev 
   TABLE DATA               B   COPY public.ayar_personel_gorev (id, validity, gorev) FROM stdin;
    public       postgres    false    293   ��      �           0    0    ayar_personel_gorev_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.ayar_personel_gorev_id_seq', 6, true);
            public       postgres    false    292            �          0    217792    ayar_personel_izin_tipi 
   TABLE DATA               F   COPY public.ayar_personel_izin_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    421   ��      �           0    0    ayar_personel_izin_tipi_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.ayar_personel_izin_tipi_id_seq', 2, true);
            public       postgres    false    420            �          0    217770    ayar_personel_kan_grubu 
   TABLE DATA               F   COPY public.ayar_personel_kan_grubu (id, validity, deger) FROM stdin;
    public       postgres    false    417   0�      �           0    0    ayar_personel_kan_grubu_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.ayar_personel_kan_grubu_id_seq', 8, true);
            public       postgres    false    416            �          0    217803    ayar_personel_medeni_durum 
   TABLE DATA               I   COPY public.ayar_personel_medeni_durum (id, validity, deger) FROM stdin;
    public       postgres    false    423   {�      �           0    0 !   ayar_personel_medeni_durum_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.ayar_personel_medeni_durum_id_seq', 2, true);
            public       postgres    false    422            �          0    217928    ayar_personel_mektup_tipi 
   TABLE DATA               H   COPY public.ayar_personel_mektup_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    439   ��      �           0    0     ayar_personel_mektup_tipi_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.ayar_personel_mektup_tipi_id_seq', 2, true);
            public       postgres    false    438            �          0    217893    ayar_personel_myk_tipi 
   TABLE DATA               E   COPY public.ayar_personel_myk_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    433   ݳ      �           0    0    ayar_personel_myk_tipi_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.ayar_personel_myk_tipi_id_seq', 1, true);
            public       postgres    false    432            �          0    217781    ayar_personel_rapor_tipi 
   TABLE DATA               G   COPY public.ayar_personel_rapor_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    419   �      �           0    0    ayar_personel_rapor_tipi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_personel_rapor_tipi_id_seq', 3, true);
            public       postgres    false    418            �          0    217904    ayar_personel_src_tipi 
   TABLE DATA               E   COPY public.ayar_personel_src_tipi (id, validity, deger) FROM stdin;
    public       postgres    false    435   Y�      �           0    0    ayar_personel_src_tipi_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.ayar_personel_src_tipi_id_seq', 4, true);
            public       postgres    false    434            �          0    217915    ayar_personel_tatil_tipi 
   TABLE DATA               W   COPY public.ayar_personel_tatil_tipi (id, validity, deger, is_resmi_tatil) FROM stdin;
    public       postgres    false    437   ��      �           0    0    ayar_personel_tatil_tipi_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.ayar_personel_tatil_tipi_id_seq', 8, true);
            public       postgres    false    436            |          0    217690    ayar_personel_tipi 
   TABLE DATA               L   COPY public.ayar_personel_tipi (id, validity, deger, is_active) FROM stdin;
    public       postgres    false    409   �      �           0    0    ayar_personel_tipi_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.ayar_personel_tipi_id_seq', 2, true);
            public       postgres    false    408            �          0    49726    ayar_sabit_degisken 
   TABLE DATA               B   COPY public.ayar_sabit_degisken (id, validity, deger) FROM stdin;
    public       postgres    false    209   P�      �           0    0    ayar_sabit_degisken_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.ayar_sabit_degisken_id_seq', 2, true);
            public       postgres    false    210            b          0    157724    ayar_sevkiyat_hazirlama_durumu 
   TABLE DATA               M   COPY public.ayar_sevkiyat_hazirlama_durumu (id, validity, deger) FROM stdin;
    public       postgres    false    383   ��      �           0    0 %   ayar_sevkiyat_hazirlama_durumu_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.ayar_sevkiyat_hazirlama_durumu_id_seq', 1, false);
            public       postgres    false    382            d          0    157735    ayar_stok_hareket_ayari 
   TABLE DATA               Y   COPY public.ayar_stok_hareket_ayari (id, validity, giris_ayari, cikis_ayari) FROM stdin;
    public       postgres    false    385   ��      �           0    0    ayar_stok_hareket_ayari_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.ayar_stok_hareket_ayari_id_seq', 1, true);
            public       postgres    false    384            �          0    103326    ayar_stok_hareket_tipi 
   TABLE DATA               O   COPY public.ayar_stok_hareket_tipi (id, validity, deger, is_input) FROM stdin;
    public       postgres    false    276   ҵ      �           0    0    ayar_stok_hareket_tipi_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.ayar_stok_hareket_tipi_id_seq', 10, true);
            public       postgres    false    275            r          0    184698    ayar_teklif_durum 
   TABLE DATA               U   COPY public.ayar_teklif_durum (id, validity, deger, aciklama, is_active) FROM stdin;
    public       postgres    false    399   
�      �           0    0    ayar_teklif_durum_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.ayar_teklif_durum_id_seq', 11, true);
            public       postgres    false    398            x          0    217648    ayar_teklif_tipi 
   TABLE DATA               T   COPY public.ayar_teklif_tipi (id, validity, deger, aciklama, is_active) FROM stdin;
    public       postgres    false    405   g�      �           0    0    ayar_teklif_tipi_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.ayar_teklif_tipi_id_seq', 2, true);
            public       postgres    false    404            
          0    114975    ayar_vergi_orani 
   TABLE DATA               W   COPY public.ayar_vergi_orani (id, validity, vergi_orani, vergi_hesap_kodu) FROM stdin;
    public       postgres    false    295   ��      �           0    0    ayar_vergi_orani_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.ayar_vergi_orani_id_seq', 9, true);
            public       postgres    false    294            �          0    88300    banka 
   TABLE DATA               I   COPY public.banka (id, validity, adi, swift_kodu, is_active) FROM stdin;
    public       postgres    false    262   �      �           0    0    banka_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.banka_id_seq', 1, true);
            public       postgres    false    261            $          0    131292    banka_subesi 
   TABLE DATA               _   COPY public.banka_subesi (id, validity, banka_id, sube_kodu, sube_adi, sube_il_id) FROM stdin;
    public       postgres    false    321   ,�      �           0    0    banka_subesi_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.banka_subesi_id_seq', 3, true);
            public       postgres    false    320            .          0    133704    barkod_hazirlik_dosya_turu 
   TABLE DATA               G   COPY public.barkod_hazirlik_dosya_turu (id, validity, tur) FROM stdin;
    public       postgres    false    331   `�      �           0    0 !   barkod_hazirlik_dosya_turu_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.barkod_hazirlik_dosya_turu_id_seq', 1, false);
            public       postgres    false    330            *          0    133675    barkod_serino_turu 
   TABLE DATA               I   COPY public.barkod_serino_turu (id, validity, tur, aciklama) FROM stdin;
    public       postgres    false    327   }�      �           0    0    barkod_serino_turu_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.barkod_serino_turu_id_seq', 1, false);
            public       postgres    false    326            ,          0    133687    barkod_tezgah 
   TABLE DATA               K   COPY public.barkod_tezgah (id, validity, tezgah_adi, ambar_id) FROM stdin;
    public       postgres    false    329   ��      �           0    0    barkod_tezgah_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.barkod_tezgah_id_seq', 1, false);
            public       postgres    false    328                      0    114990    bolge 
   TABLE DATA               S  COPY public.bolge (id, validity, bolge_adi, bolge_turu_id, hedef_ocak, hedef_subat, hedef_mart, hedef_nisan, hedef_mayis, hedef_haziran, hedef_temmuz, hedef_agustos, hedef_eylul, hedef_ekim, hedef_kasim, hedef_aralik, hedef_mamul_ocak, hedef_mamul_subat, hedef_mamul_mart, hedef_mamul_nisan, hedef_mamul_mayis, hedef_mamul_haziran, hedef_mamul_temmuz, hedef_mamul_agustos, hedef_mamul_eylul, hedef_mamul_ekim, hedef_mamul_kasim, hedef_mamul_aralik, gecen_ocak, gecen_subat, gecen_mart, gecen_nisan, gecen_mayis, gecen_haziran, gecen_temmuz, gecen_agustos, gecen_eylul, gecen_ekim, gecen_kasim, gecen_aralik, gecen_mamul_ocak, gecen_mamul_subat, gecen_mamul_mart, gecen_mamul_nisan, gecen_mamul_mayis, gecen_mamul_haziran, gecen_mamul_temmuz, gecen_mamul_agustos, gecen_mamul_eylul, gecen_mamul_ekim, gecen_mamul_kasim, gecen_mamul_aralik) FROM stdin;
    public       postgres    false    297   ��      �           0    0    bolge_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.bolge_id_seq', 1, true);
            public       postgres    false    296            �          0    49744 
   bolge_turu 
   TABLE DATA               7   COPY public.bolge_turu (id, validity, tur) FROM stdin;
    public       postgres    false    211   �      �           0    0    bolge_turu_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.bolge_turu_id_seq', 2, true);
            public       postgres    false    212            &          0    131329    cins_ailesi 
   TABLE DATA               9   COPY public.cins_ailesi (id, validity, aile) FROM stdin;
    public       postgres    false    323   �      �           0    0    cins_ailesi_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.cins_ailesi_id_seq', 14, true);
            public       postgres    false    322            (          0    131382    cins_ozelligi 
   TABLE DATA               �   COPY public.cins_ozelligi (id, validity, cins_aile_id, cins, aciklama, string1, string2, string3, string4, string5, string6, string7, string8, string9, string10, string11, string12, is_serino_icerir) FROM stdin;
    public       postgres    false    325   4�      �           0    0    cins_ozelligi_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.cins_ozelligi_id_seq', 68, true);
            public       postgres    false    324            "          0    123264 
   doviz_kuru 
   TABLE DATA               K   COPY public.doviz_kuru (id, validity, tarih, para_birimi, kur) FROM stdin;
    public       postgres    false    319   Q�      �           0    0    doviz_kuru_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.doviz_kuru_id_seq', 38, true);
            public       postgres    false    318            �          0    49768    hesap 
   TABLE DATA               �  COPY public.hesap (id, validity, firma_tipi, firma_tipi_detay, hesap_kodu, hesap_ismi, mukellef_tipi, hesap_grubu, yetkili_adi, yetkili_soyadi, tel1, tel2, tel3, faks1, faks2, faks3, web_uri, eposta, muhasebe_tel, muhasebe_eposta, sokak, cadde, mahalle, ilce, sehir, bolge, bina, kapi_no, posta_kutusu, posta_kodu, ulke, vergi_dairesi, vergi_no, nace_kodu, iskonto, muhasebe_kodu, ana_hesap_muhasebe_kodu, plan_kodu, ozel_bilgi, para_birimi, temsilci, ortalama_vade, is_efatura) FROM stdin;
    public       postgres    false    213   ��      �          0    49778    hesap_grubu 
   TABLE DATA               9   COPY public.hesap_grubu (id, validity, grup) FROM stdin;
    public       postgres    false    214   ��      �           0    0    hesap_grubu_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.hesap_grubu_id_seq', 3, true);
            public       postgres    false    215            �           0    0    hesap_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.hesap_id_seq', 1, false);
            public       postgres    false    216                      0    115049    hesap_karti 
   TABLE DATA               �  COPY public.hesap_karti (id, validity, hesap_kodu, hesap_ismi, hesap_grubu_id, yetkili, tel1, tel2, tel3, faks, hesap_iskonto, ozel_bilgi, para_birimi, hesap_tipi, temsilci_id, bolge_id, muhasebe_kodu, gecmis_donem_ciro, kredi_limiti, e_fatura_hesabi, doviz_hesabi, odeme_vadesi, varsayilan_musteri, varsayilan_satici, is_sair_hesap, vergi_dairesi, vergi_no, mukellef_tipi, nace_kodu, web_sitesi, eposta_adresi, ulke_kodu_id, sehir_id, ilce, mahalle, cadde, sokak, bina, kapi_no, posta_kutusu, posta_kodu, statu, iban_no, iban_para_birimi, hesap_kategori, person_first_name, person_family_name, person_middle_name, muhasebe_eposta, muhasebe_tel, temsilci_grubu_id) FROM stdin;
    public       postgres    false    299   �      �           0    0    hesap_karti_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.hesap_karti_id_seq', 1, false);
            public       postgres    false    298            �          0    49786    hesap_plani 
   TABLE DATA               M   COPY public.hesap_plani (id, validity, plan_kodu, seviye_sayisi) FROM stdin;
    public       postgres    false    217   ��      �           0    0    hesap_plani_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.hesap_plani_id_seq', 1, false);
            public       postgres    false    218                      0    114913    medeni_durum 
   TABLE DATA               ;   COPY public.medeni_durum (id, validity, durum) FROM stdin;
    public       postgres    false    287   �      �           0    0    medeni_durum_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.medeni_durum_id_seq', 1, false);
            public       postgres    false    286            �          0    49792    muhasebe_hesap_plani 
   TABLE DATA               V   COPY public.muhasebe_hesap_plani (id, validity, plan_kodu, seviye_sayisi) FROM stdin;
    public       postgres    false    219   9�      �           0    0    muhasebe_hesap_plani_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.muhasebe_hesap_plani_id_seq', 1, false);
            public       postgres    false    220                      0    123081    olcu_birimi 
   TABLE DATA               g   COPY public.olcu_birimi (id, validity, birim, efatura_birim, birim_aciklama, is_float_tip) FROM stdin;
    public       postgres    false    301   V�      �           0    0    olcu_birimi_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.olcu_birimi_id_seq', 3, true);
            public       postgres    false    300            �          0    96431    para_birimi 
   TABLE DATA               O   COPY public.para_birimi (id, kod, sembol, aciklama, is_varsayilan) FROM stdin;
    public       postgres    false    266   ��      �           0    0    para_birimi_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.para_birimi_id_seq', 3, true);
            public       postgres    false    265            �          0    49812    personel_ayrilma_nedeni_tipi 
   TABLE DATA               I   COPY public.personel_ayrilma_nedeni_tipi (id, validity, tip) FROM stdin;
    public       postgres    false    221   �      �           0    0 #   personel_ayrilma_nedeni_tipi_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.personel_ayrilma_nedeni_tipi_id_seq', 4, true);
            public       postgres    false    222            �          0    49841    personel_calisma_gecmisi 
   TABLE DATA               �   COPY public.personel_calisma_gecmisi (id, validity, personel_id, personel_birim, personel_gorev, ise_giris_tarihi, isten_cikis_tarihi, ayrilma_nedeni_tipi, ayrilma_nedeni_aciklama) FROM stdin;
    public       postgres    false    223   x�      �           0    0    personel_calisma_gecmisi_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.personel_calisma_gecmisi_id_seq', 1, false);
            public       postgres    false    224            �          0    217871    personel_dil_bilgisi 
   TABLE DATA               �   COPY public.personel_dil_bilgisi (id, validity, dil_id, okuma_seviyesi_id, yazma_seviyesi_id, konusma_seviyesi_id, personel_id) FROM stdin;
    public       postgres    false    429   ��      �           0    0    personel_dil_bilgisi_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.personel_dil_bilgisi_id_seq', 1, false);
            public       postgres    false    428            �          0    217953    personel_karti 
   TABLE DATA               �  COPY public.personel_karti (id, validity, is_active, personel_ad, personel_soyad, telefon1, telefon2, personel_tipi_id, birim_id, gorev_id, mail_adresi, dogum_tarihi, kan_grubu_id, cinsiyet_id, askerlik_durumu_id, medeni_durumu_id, cocuk_sayisi, yakin_ad_soyad, yakin_telefon, ev_adresi, ayakkabi_no, elbise_bedeni, genel_not, servis_id, personel_gecmisi_id, ozel_not, brut_maas, ikramiye_sayisi, ikramiye_miktar, tc_kimlik_no, personel_ad_soyad, bolum_id) FROM stdin;
    public       postgres    false    443   ��      �           0    0    personel_karti_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.personel_karti_id_seq', 1, true);
            public       postgres    false    442            �          0    49853    personel_tasima_servis 
   TABLE DATA               [   COPY public.personel_tasima_servis (id, validity, servis_no, servis_adi, rota) FROM stdin;
    public       postgres    false    225   2�      �           0    0    personel_tasima_servis_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.personel_tasima_servis_id_seq', 1, true);
            public       postgres    false    226                      0    123117    quality_form_mail_reciever 
   TABLE DATA               O   COPY public.quality_form_mail_reciever (id, validity, mail_adresi) FROM stdin;
    public       postgres    false    305   t�      �           0    0 !   quality_form_mail_reciever_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.quality_form_mail_reciever_id_seq', 1, true);
            public       postgres    false    304            �          0    49862    recete 
   TABLE DATA               w   COPY public.recete (id, validity, mamul_stok_kodu, ornek_uretim_miktari, fire_orani, aciklama, recete_adi) FROM stdin;
    public       postgres    false    227   ��      �          0    49866    recete_hammadde 
   TABLE DATA               l   COPY public.recete_hammadde (id, validity, header_id, stok_kodu, miktar, fire_orani, recete_id) FROM stdin;
    public       postgres    false    228   ϻ      �           0    0    recete_hammadde_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.recete_hammadde_id_seq', 1, false);
            public       postgres    false    229            �           0    0    recete_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.recete_id_seq', 1, false);
            public       postgres    false    230            �          0    49874    satis_fatura 
   TABLE DATA               r   COPY public.satis_fatura (id, validity, fatura_no, fatura_tarihi, teklif_id, siparis_id, irsaliye_id) FROM stdin;
    public       postgres    false    231   �      �          0    49878    satis_fatura_detay 
   TABLE DATA               {   COPY public.satis_fatura_detay (id, validity, header_id, teklif_detay_id, siparis_detay_id, irsaliye_detay_id) FROM stdin;
    public       postgres    false    232   	�      �           0    0    satis_fatura_detay_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.satis_fatura_detay_id_seq', 1, false);
            public       postgres    false    233            �           0    0    satis_fatura_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.satis_fatura_id_seq', 1, false);
            public       postgres    false    234            �          0    49886    satis_irsaliye 
   TABLE DATA               v   COPY public.satis_irsaliye (id, validity, irsaliye_no, irsaliye_tarihi, teklif_id, siparis_id, fatura_id) FROM stdin;
    public       postgres    false    235   &�      �          0    49890    satis_irsaliye_detay 
   TABLE DATA               {   COPY public.satis_irsaliye_detay (id, validity, header_id, teklif_detay_id, siparis_detay_id, fatura_detay_id) FROM stdin;
    public       postgres    false    236   C�      �           0    0    satis_irsaliye_detay_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.satis_irsaliye_detay_id_seq', 1, false);
            public       postgres    false    237            �           0    0    satis_irsaliye_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.satis_irsaliye_id_seq', 1, false);
            public       postgres    false    238            �          0    49898    satis_siparis 
   TABLE DATA               t   COPY public.satis_siparis (id, validity, siparis_no, siparis_tarihi, teklif_id, irsaliye_id, fatura_id) FROM stdin;
    public       postgres    false    239   `�      �          0    49902    satis_siparis_detay 
   TABLE DATA               {   COPY public.satis_siparis_detay (id, validity, header_id, teklif_detay_id, irsaliye_detay_id, fatura_detay_id) FROM stdin;
    public       postgres    false    240   }�      �           0    0    satis_siparis_detay_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.satis_siparis_detay_id_seq', 1, false);
            public       postgres    false    241            �           0    0    satis_siparis_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.satis_siparis_id_seq', 1, false);
            public       postgres    false    242            t          0    184737    satis_teklif 
   TABLE DATA               j  COPY public.satis_teklif (id, validity, siparis_id, irsaliye_id, fatura_id, is_siparislesti, is_taslak, is_efatura, tutar, iskonto_tutar, ara_toplam, genel_iskonto_tutar, kdv_tutar, genel_toplam, islem_tipi_id, teklif_no, teklif_tarihi, teslim_tarihi, gecerlilik_tarihi, musteri_kodu, musteri_adi, adres_musteri, sehir_musteri, posta_kodu, vergi_dairesi, vergi_no, musteri_temsilcisi_id, teklif_tipi_id, adres_sevkiyat, sehir_sevkiyat, muhattap_ad, muhattap_soyad, odeme_vadesi, referans, teslimat_suresi, teklif_durum_id, sevk_tarihi, vade_gun_sayisi, fatura_sevk_tarihi, para_birimi, dolar_kur, euro_kur, odeme_baslangic_donemi_id, teslim_sarti_id, gonderim_sekli_id, gonderim_sekli_detay, odeme_sekli_id, aciklama, proforma_no, arayan_kisi_id, arama_tarihi, sonraki_aksiyon_tarihi, aksiyon_notu, tevkifat_kodu, tevkifat_pay, tevkifat_payda, ihrac_kayit_kodu) FROM stdin;
    public       postgres    false    401   ��      v          0    184819    satis_teklif_detay 
   TABLE DATA               �  COPY public.satis_teklif_detay (id, validity, header_id, siparis_detay_id, irsaliye_detay_id, fatura_detay_id, stok_kodu, stok_aciklama, aciklama, referans, miktar, olcu_birimi, fiyat, tutar, iskonto, net_fiyat, net_tutar, iskonto_tutar, kdv, kdv_tutar, toplam_tutar, vade_gun, is_ana_urun, ana_urun_id, reference_ana_urun_id, transfer_hesap_kodu, kdv_transfer_hesap_kodu, vergi_kodu, vergi_muafiyet_kodu, diger_vergi_kodu, gtip_no) FROM stdin;
    public       postgres    false    403   ��      �           0    0    satis_teklif_detay_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.satis_teklif_detay_id_seq', 1, false);
            public       postgres    false    402            �           0    0    satis_teklif_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.satis_teklif_id_seq', 1, false);
            public       postgres    false    400            �          0    96455    sehir 
   TABLE DATA               N   COPY public.sehir (id, validity, sehir_adi, ulke_adi, plaka_kodu) FROM stdin;
    public       postgres    false    270   Լ      �           0    0    sehir_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sehir_id_seq', 4, true);
            public       postgres    false    269            4          0    134020 
   stok_grubu 
   TABLE DATA                 COPY public.stok_grubu (id, validity, grup, alis_hesabi, satis_hesabi, hammadde_hesabi, mamul_hesabi, kdv_orani_id, tur_id, is_iskonto_aktif, iskonto_satis, iskonto_mudur, is_satis_fiyatini_kullan, yari_mamul_hesabi, is_maliyet_analiz_farkli_db) FROM stdin;
    public       postgres    false    337   5�      �           0    0    stok_grubu_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stok_grubu_id_seq', 691, true);
            public       postgres    false    336            2          0    133957    stok_grubu_turu 
   TABLE DATA               <   COPY public.stok_grubu_turu (id, validity, tur) FROM stdin;
    public       postgres    false    335   R�      �           0    0    stok_grubu_turu_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.stok_grubu_turu_id_seq', 29, true);
            public       postgres    false    334            �          0    103356    stok_hareketi 
   TABLE DATA               �   COPY public.stok_hareketi (id, validity, stok_kodu, miktar, tutar, giris_cikis_tip_id, alan_ambar, veren_ambar, tarih, is_donem_basi_hareket) FROM stdin;
    public       postgres    false    278   ��      �           0    0    stok_hareketi_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.stok_hareketi_id_seq', 5001, true);
            public       postgres    false    277            6          0    134132 
   stok_karti 
   TABLE DATA               (  COPY public.stok_karti (id, validity, stok_kodu, stok_adi, stok_grubu_id, olcu_birimi_id, alis_iskonto, satis_iskonto, yetkili_iskonto, stok_tipi_id, ham_alis_fiyat, ham_alis_para_birim, alis_fiyat, alis_para_birim, satis_fiyat, satis_para_birim, ihrac_fiyat, ihrac_para_birim, ortalama_maliyet, varsayilan_recete_id, en, boy, yukseklik, mensei_id, gtip_no, diib_urun_tanimi, en_az_stok_seviyesi, tanim, ozel_kod, marka, agirlik, kapasite, cins_id, string_degisken1, string_degisken2, string_degisken3, string_degisken4, string_degisken5, string_degisken6, integer_degisken1, integer_degisken2, integer_degisken3, double_degisken1, double_degisken2, double_degisken3, is_satilabilir, is_ana_urun, is_yari_mamul, is_otomatik_uretim_urunu, is_ozet_urun, lot_parti_miktari, paket_miktari, seri_no_turu, is_harici_seri_no_icerir, harici_serino_stok_kodu_id, tasiyici_paket_id, onceki_donem_cikan_miktar, temin_suresi, stock_name, en_string_degisken1, en_string_degisken2, en_string_degisken3, en_string_degisken4, en_string_degisken5, en_string_degisken6) FROM stdin;
    public       postgres    false    339   �c      �           0    0    stok_karti_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.stok_karti_id_seq', 32319, true);
            public       postgres    false    338            �          0    49941 	   stok_tipi 
   TABLE DATA               X   COPY public.stok_tipi (id, validity, tip, is_default, is_stok_hareketi_yap) FROM stdin;
    public       postgres    false    243   �c      �           0    0    stok_tipi_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.stok_tipi_id_seq', 12, true);
            public       postgres    false    244            �          0    88214    sys_application_settings 
   TABLE DATA               �  COPY public.sys_application_settings (id, validity, logo, unvan, tel1, tel2, tel3, tel4, tel5, fax1, fax2, mersis_no, web_sitesi, eposta_adresi, vergi_dairesi, vergi_no, form_rengi, donem, mukellef_tipi, tam_adres, ticaret_sicil_no, ilce, mahalle, cadde, sokak, posta_kodu, bina, kapi_no, ulke_id, sehir_id, sistem_dili, mail_sunucu_adres, mail_sunucu_kullanici, mail_sunucu_sifre, mail_sunucu_port, grid_color_1, grid_color_2, grid_color_active, edefter_gonderilen_son) FROM stdin;
    public       postgres    false    260   Md      �           0    0    sys_application_settings_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.sys_application_settings_id_seq', 1, true);
            public       postgres    false    259            �          0    103483    sys_application_settings_other 
   TABLE DATA               q  COPY public.sys_application_settings_other (id, validity, is_edefter_aktif, mail_sender_address, mail_sender_username, mail_sender_password, mail_sender_port, varsayilan_satis_cari_kod, varsayilan_alis_cari_kod, is_bolum_ambarda_uretim_yap, is_uretim_muhasebe_kaydi_olustursun, is_stok_satimda_negatife_dusebilir, is_mal_satis_sayilarini_goster, is_pcb_uretim, is_proforma_no_goster, is_satis_takip, is_hammadde_girise_gore_sirala, is_uretim_entegrasyon_hammadde_kullanim_hesabi_iscilikle, is_tahsilat_listesi_virmanli, is_ortalama_vade_0_ise_sevkiyata_izin_verme, is_sipariste_teslim_tarihi_yazdir, is_teklif_ayrintilarini_goster, is_fatura_irsaliye_no_0_ile_baslasin, is_excel_ekli_irsaliye_yazdirma, is_ambarlararasi_transfer_numara_otomatik_gelsin, is_ambarlararasi_transfer_onayli_calissin, is_alis_teklif_alis_sipariste_ham_alis_fiyatini_kullan, is_tahsilat_listesine_120_bulut_hesabini_dahil_etme, is_satis_listesi_varsayilan_filtre_mamul_hammadde, is_recete_maliyet_analizi_baska_db_kullanarak_yap, is_efatura_aktif, is_stok_transfer_fiyati_kullanici_degistirebilir, is_hesaplar_rapolarda_cikmasin, is_siparisi_baska_programa_otomatik_kayit_yap, is_active_uretim_takip, is_pano_programina_otomatik_kayit, is_nakit_akista_farkli_db_kullan, is_ihrac_fiyati_yerine_satis_fiyatini_kullan, is_statik_iskonto_orani_kullan, is_eirsaliye_aktif, is_stok_recete_adi_birlikte_guncellensin, is_kur_bilgisini_1_olarak_kullan, is_genel_kdv_orani_kullan, xslt_sablon_adi, genel_iskonto_gecerlilik_tarihi, en_fazla_fatura_satir_sayisi, en_fazla_e_fatura_satir_sayisi, en_fazla_irsaliye_satir_sayisi, en_fazla_e_irsaliye_satir_sayisi, siparis_kopyalanacak_kaynak_cari_kod, siparis_kopyalanacak_hedef_cari_kod, maliyet_analizi_iskonto_orani, genel_kdv_orani, path_teklif_hesaplama_conf, path_proforma_file, path_mal_stok_seviyesi_eord_rapor, path_update, path_stok_karti_resim, path_proforma_pdf_kayit) FROM stdin;
    public       postgres    false    280   ��      �           0    0 %   sys_application_settings_other_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.sys_application_settings_other_id_seq', 1, false);
            public       postgres    false    279            �          0    65741    sys_grid_col_color 
   TABLE DATA                  COPY public.sys_grid_col_color (id, validity, table_name, column_name, min_value, min_color, max_value, max_color) FROM stdin;
    public       postgres    false    254   ؒ      �           0    0    sys_grid_col_color_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sys_grid_col_color_id_seq', 4, true);
            public       postgres    false    253            �          0    65760    sys_grid_col_percent 
   TABLE DATA               �   COPY public.sys_grid_col_percent (id, validity, table_name, column_name, max_value, color_bar, color_bar_back, color_bar_text, color_bar_text_active) FROM stdin;
    public       postgres    false    256   ��      �           0    0    sys_grid_col_percent_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sys_grid_col_percent_id_seq', 1, true);
            public       postgres    false    255            �          0    65726    sys_grid_col_width 
   TABLE DATA               n   COPY public.sys_grid_col_width (id, validity, table_name, column_name, column_width, sequence_no) FROM stdin;
    public       postgres    false    252   �      �           0    0    sys_grid_col_width_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sys_grid_col_width_id_seq', 238, true);
            public       postgres    false    251            �          0    88199    sys_grid_default_order_filter 
   TABLE DATA               [   COPY public.sys_grid_default_order_filter (id, validity, key, value, is_order) FROM stdin;
    public       postgres    false    258   Ӝ      �           0    0 $   sys_grid_default_order_filter_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.sys_grid_default_order_filter_id_seq', 8, true);
            public       postgres    false    257            �          0    51760    sys_lang 
   TABLE DATA               :   COPY public.sys_lang (id, validity, language) FROM stdin;
    public       postgres    false    250   _�                0    123148    sys_lang_data_content 
   TABLE DATA               k   COPY public.sys_lang_data_content (id, validity, lang, table_name, column_name, row_id, value) FROM stdin;
    public       postgres    false    309   ��      �           0    0    sys_lang_data_content_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sys_lang_data_content_id_seq', 24, true);
            public       postgres    false    308                      0    123162    sys_lang_gui_content 
   TABLE DATA               }   COPY public.sys_lang_gui_content (id, validity, lang, code, value, is_factory_setting, content_type, table_name) FROM stdin;
    public       postgres    false    311   0�      �           0    0    sys_lang_gui_content_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sys_lang_gui_content_id_seq', 588, true);
            public       postgres    false    310            �           0    0    sys_lang_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.sys_lang_id_seq', 3, true);
            public       postgres    false    249                      0    123134    sys_multi_lang_data_table_list 
   TABLE DATA               R   COPY public.sys_multi_lang_data_table_list (id, validity, table_name) FROM stdin;
    public       postgres    false    307   ��      �           0    0 %   sys_multi_lang_data_table_list_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.sys_multi_lang_data_table_list_id_seq', 10, true);
            public       postgres    false    306            �          0    49949    sys_permission_source 
   TABLE DATA               h   COPY public.sys_permission_source (id, validity, source_code, source_name, source_group_id) FROM stdin;
    public       postgres    false    245   '�      �          0    49953    sys_permission_source_group 
   TABLE DATA               Q   COPY public.sys_permission_source_group (id, validity, source_group) FROM stdin;
    public       postgres    false    246   �      �           0    0 "   sys_permission_source_group_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.sys_permission_source_group_id_seq', 6, true);
            public       postgres    false    247            �           0    0    sys_permission_source_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.sys_permission_source_id_seq', 24, true);
            public       postgres    false    248            �          0    96485    sys_quality_form_number 
   TABLE DATA               T   COPY public.sys_quality_form_number (id, validity, table_name, form_no) FROM stdin;
    public       postgres    false    272   s�                  0    0    sys_quality_form_number_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.sys_quality_form_number_id_seq', 2, true);
            public       postgres    false    271                      0    123186    sys_user 
   TABLE DATA                 COPY public.sys_user (id, validity, user_name, user_password, is_active_user, is_online, is_admin, is_super_user, ip_address, mac_address, email_address, app_version, personel_bilgisi_id, invoice_no_serie, dispatch_no_serie, default_qrcode_size) FROM stdin;
    public       postgres    false    313   ��                0    123206    sys_user_access_right 
   TABLE DATA               �   COPY public.sys_user_access_right (id, validity, source_code, is_read, is_add_record, is_update, is_delete, is_special, user_name) FROM stdin;
    public       postgres    false    315   +�                 0    0    sys_user_access_right_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.sys_user_access_right_id_seq', 7, true);
            public       postgres    false    314                       0    0    sys_user_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.sys_user_id_seq', 1, true);
            public       postgres    false    312                       0    123248    sys_user_mac_address_exception 
   TABLE DATA               ]   COPY public.sys_user_mac_address_exception (id, validity, user_name, ip_address) FROM stdin;
    public       postgres    false    317   |�                 0    0 %   sys_user_mac_address_exception_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.sys_user_mac_address_exception_id_seq', 1, true);
            public       postgres    false    316            �          0    96442    ulke 
   TABLE DATA               t   COPY public.ulke (id, validity, ulke_kodu, ulke_adi, iso_year, iso_cctld_code, is_avrupa_birligi_uyesi) FROM stdin;
    public       postgres    false    268   ��                 0    0    ulke_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.ulke_id_seq', 1, true);
            public       postgres    false    267                      0    123106    urun_kabul_red_nedeni 
   TABLE DATA               D   COPY public.urun_kabul_red_nedeni (id, validity, deger) FROM stdin;
    public       postgres    false    303   ��                 0    0    urun_kabul_red_nedeni_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.urun_kabul_red_nedeni_id_seq', 7, true);
            public       postgres    false    302                       2606    50072    alis_teklif_detay_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.alis_teklif_detay
    ADD CONSTRAINT alis_teklif_detay_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.alis_teklif_detay DROP CONSTRAINT alis_teklif_detay_pkey;
       public         postgres    false    184    184            �           2606    50074    alis_teklif_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.alis_teklif
    ADD CONSTRAINT alis_teklif_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.alis_teklif DROP CONSTRAINT alis_teklif_pkey;
       public         postgres    false    183    183                       2606    50076 ,   alis_tsif_kur_alis_fatura_id_para_birimi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_alis_fatura_id_para_birimi_key UNIQUE (alis_fatura_id, para_birimi);
 d   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_alis_fatura_id_para_birimi_key;
       public         postgres    false    187    187    187                       2606    50078 .   alis_tsif_kur_alis_irsaliye_id_para_birimi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_alis_irsaliye_id_para_birimi_key UNIQUE (alis_irsaliye_id, para_birimi);
 f   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_alis_irsaliye_id_para_birimi_key;
       public         postgres    false    187    187    187                       2606    50080 -   alis_tsif_kur_alis_siparis_id_para_birimi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_alis_siparis_id_para_birimi_key UNIQUE (alis_siparis_id, para_birimi);
 e   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_alis_siparis_id_para_birimi_key;
       public         postgres    false    187    187    187            	           2606    50082 ,   alis_tsif_kur_alis_teklif_id_para_birimi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_alis_teklif_id_para_birimi_key UNIQUE (alis_teklif_id, para_birimi);
 d   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_alis_teklif_id_para_birimi_key;
       public         postgres    false    187    187    187                       2606    50084    alis_tsif_kur_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_pkey;
       public         postgres    false    187    187                       2606    123064    ambar_ambar_adi_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.ambar
    ADD CONSTRAINT ambar_ambar_adi_key UNIQUE (ambar_adi);
 C   ALTER TABLE ONLY public.ambar DROP CONSTRAINT ambar_ambar_adi_key;
       public         postgres    false    189    189                       2606    50088 
   ambar_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.ambar
    ADD CONSTRAINT ambar_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.ambar DROP CONSTRAINT ambar_pkey;
       public         postgres    false    189    189            7           2606    142423 $   ayar_barkod_hazirlik_dosya_turu_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_barkod_hazirlik_dosya_turu
    ADD CONSTRAINT ayar_barkod_hazirlik_dosya_turu_pkey PRIMARY KEY (id);
 n   ALTER TABLE ONLY public.ayar_barkod_hazirlik_dosya_turu DROP CONSTRAINT ayar_barkod_hazirlik_dosya_turu_pkey;
       public         postgres    false    347    347            9           2606    142425 '   ayar_barkod_hazirlik_dosya_turu_tur_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_barkod_hazirlik_dosya_turu
    ADD CONSTRAINT ayar_barkod_hazirlik_dosya_turu_tur_key UNIQUE (tur);
 q   ALTER TABLE ONLY public.ayar_barkod_hazirlik_dosya_turu DROP CONSTRAINT ayar_barkod_hazirlik_dosya_turu_tur_key;
       public         postgres    false    347    347            +           2606    142385    ayar_barkod_serino_turu_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_barkod_serino_turu
    ADD CONSTRAINT ayar_barkod_serino_turu_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_barkod_serino_turu DROP CONSTRAINT ayar_barkod_serino_turu_pkey;
       public         postgres    false    341    341            -           2606    142387    ayar_barkod_serino_turu_tur_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.ayar_barkod_serino_turu
    ADD CONSTRAINT ayar_barkod_serino_turu_tur_key UNIQUE (tur);
 a   ALTER TABLE ONLY public.ayar_barkod_serino_turu DROP CONSTRAINT ayar_barkod_serino_turu_tur_key;
       public         postgres    false    341    341            /           2606    142396    ayar_barkod_tezgah_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.ayar_barkod_tezgah
    ADD CONSTRAINT ayar_barkod_tezgah_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.ayar_barkod_tezgah DROP CONSTRAINT ayar_barkod_tezgah_pkey;
       public         postgres    false    343    343            1           2606    142398 *   ayar_barkod_tezgah_tezgah_adi_ambar_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_barkod_tezgah
    ADD CONSTRAINT ayar_barkod_tezgah_tezgah_adi_ambar_id_key UNIQUE (tezgah_adi, ambar_id);
 g   ALTER TABLE ONLY public.ayar_barkod_tezgah DROP CONSTRAINT ayar_barkod_tezgah_tezgah_adi_ambar_id_key;
       public         postgres    false    343    343    343            3           2606    142412    ayar_barkod_urun_turu_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.ayar_barkod_urun_turu
    ADD CONSTRAINT ayar_barkod_urun_turu_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.ayar_barkod_urun_turu DROP CONSTRAINT ayar_barkod_urun_turu_pkey;
       public         postgres    false    345    345            5           2606    142414    ayar_barkod_urun_turu_tur_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_barkod_urun_turu
    ADD CONSTRAINT ayar_barkod_urun_turu_tur_key UNIQUE (tur);
 ]   ALTER TABLE ONLY public.ayar_barkod_urun_turu DROP CONSTRAINT ayar_barkod_urun_turu_tur_key;
       public         postgres    false    345    345            O           2606    157546    ayar_bordro_tipi_deger_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.ayar_bordro_tipi
    ADD CONSTRAINT ayar_bordro_tipi_deger_key UNIQUE (deger);
 U   ALTER TABLE ONLY public.ayar_bordro_tipi DROP CONSTRAINT ayar_bordro_tipi_deger_key;
       public         postgres    false    361    361            Q           2606    157518    ayar_bordro_tipi_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ayar_bordro_tipi
    ADD CONSTRAINT ayar_bordro_tipi_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ayar_bordro_tipi DROP CONSTRAINT ayar_bordro_tipi_pkey;
       public         postgres    false    361    361            �           2606    157844 (   ayar_cek_senet_cash_edici_tipi_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_cek_senet_cash_edici_tipi
    ADD CONSTRAINT ayar_cek_senet_cash_edici_tipi_deger_key UNIQUE (deger);
 q   ALTER TABLE ONLY public.ayar_cek_senet_cash_edici_tipi DROP CONSTRAINT ayar_cek_senet_cash_edici_tipi_deger_key;
       public         postgres    false    393    393            �           2606    157842 #   ayar_cek_senet_cash_edici_tipi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_cek_senet_cash_edici_tipi
    ADD CONSTRAINT ayar_cek_senet_cash_edici_tipi_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.ayar_cek_senet_cash_edici_tipi DROP CONSTRAINT ayar_cek_senet_cash_edici_tipi_pkey;
       public         postgres    false    393    393            �           2606    157855 *   ayar_cek_senet_tahsil_odeme_tipi_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_cek_senet_tahsil_odeme_tipi
    ADD CONSTRAINT ayar_cek_senet_tahsil_odeme_tipi_deger_key UNIQUE (deger);
 u   ALTER TABLE ONLY public.ayar_cek_senet_tahsil_odeme_tipi DROP CONSTRAINT ayar_cek_senet_tahsil_odeme_tipi_deger_key;
       public         postgres    false    395    395            �           2606    157853 %   ayar_cek_senet_tahsil_odeme_tipi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_cek_senet_tahsil_odeme_tipi
    ADD CONSTRAINT ayar_cek_senet_tahsil_odeme_tipi_pkey PRIMARY KEY (id);
 p   ALTER TABLE ONLY public.ayar_cek_senet_tahsil_odeme_tipi DROP CONSTRAINT ayar_cek_senet_tahsil_odeme_tipi_pkey;
       public         postgres    false    395    395            �           2606    157827    ayar_cek_senet_tipi_deger_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_cek_senet_tipi
    ADD CONSTRAINT ayar_cek_senet_tipi_deger_key UNIQUE (deger);
 [   ALTER TABLE ONLY public.ayar_cek_senet_tipi DROP CONSTRAINT ayar_cek_senet_tipi_deger_key;
       public         postgres    false    391    391            �           2606    157825    ayar_cek_senet_tipi_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ayar_cek_senet_tipi
    ADD CONSTRAINT ayar_cek_senet_tipi_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.ayar_cek_senet_tipi DROP CONSTRAINT ayar_cek_senet_tipi_pkey;
       public         postgres    false    391    391            ?           2606    157431 1   ayar_diger_database_bilgisi_db_name_host_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_diger_database_bilgisi
    ADD CONSTRAINT ayar_diger_database_bilgisi_db_name_host_name_key UNIQUE (db_name, host_name);
 w   ALTER TABLE ONLY public.ayar_diger_database_bilgisi DROP CONSTRAINT ayar_diger_database_bilgisi_db_name_host_name_key;
       public         postgres    false    351    351    351            A           2606    157429     ayar_diger_database_bilgisi_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.ayar_diger_database_bilgisi
    ADD CONSTRAINT ayar_diger_database_bilgisi_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.ayar_diger_database_bilgisi DROP CONSTRAINT ayar_diger_database_bilgisi_pkey;
       public         postgres    false    351    351            C           2606    157440    ayar_edefter_donem_raporu_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ayar_edefter_donem_raporu
    ADD CONSTRAINT ayar_edefter_donem_raporu_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY public.ayar_edefter_donem_raporu DROP CONSTRAINT ayar_edefter_donem_raporu_pkey;
       public         postgres    false    353    353            E           2606    157442 ?   ayar_edefter_donem_raporu_rapor_baslangic_donemi_rapor_biti_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_edefter_donem_raporu
    ADD CONSTRAINT ayar_edefter_donem_raporu_rapor_baslangic_donemi_rapor_biti_key UNIQUE (rapor_baslangic_donemi, rapor_bitis_donemi);
 �   ALTER TABLE ONLY public.ayar_edefter_donem_raporu DROP CONSTRAINT ayar_edefter_donem_raporu_rapor_baslangic_donemi_rapor_biti_key;
       public         postgres    false    353    353    353            K           2606    157492    ayar_efatura_alici_bilgisi_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_efatura_alici_bilgisi
    ADD CONSTRAINT ayar_efatura_alici_bilgisi_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_efatura_alici_bilgisi DROP CONSTRAINT ayar_efatura_alici_bilgisi_pkey;
       public         postgres    false    357    357            [           2606    157607 (   ayar_efatura_evrak_cinsi_evrak_cinsi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_cinsi_evrak_cinsi_key UNIQUE (evrak_cinsi);
 k   ALTER TABLE ONLY public.ayar_efatura_evrak_cinsi DROP CONSTRAINT ayar_efatura_evrak_cinsi_evrak_cinsi_key;
       public         postgres    false    367    367            ]           2606    157605    ayar_efatura_evrak_cinsi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.ayar_efatura_evrak_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_cinsi_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.ayar_efatura_evrak_cinsi DROP CONSTRAINT ayar_efatura_evrak_cinsi_pkey;
       public         postgres    false    367    367            _           2606    157618 >   ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_evrak_cinsi_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_evrak_cinsi_id_key UNIQUE (evrak_tipi_id, evrak_cinsi_id);
 �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi DROP CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_evrak_cinsi_id_key;
       public         postgres    false    369    369    369            a           2606    157616 "   ayar_efatura_evrak_tipi_cinsi_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_cinsi_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi DROP CONSTRAINT ayar_efatura_evrak_tipi_cinsi_pkey;
       public         postgres    false    369    369            W           2606    157596 &   ayar_efatura_evrak_tipi_evrak_tipi_key 
   CONSTRAINT        ALTER TABLE ONLY public.ayar_efatura_evrak_tipi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_evrak_tipi_key UNIQUE (evrak_tipi);
 h   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi DROP CONSTRAINT ayar_efatura_evrak_tipi_evrak_tipi_key;
       public         postgres    false    365    365            Y           2606    157594    ayar_efatura_evrak_tipi_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi DROP CONSTRAINT ayar_efatura_evrak_tipi_pkey;
       public         postgres    false    365    365            �           2606    103570    ayar_efatura_fatura_tipi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.ayar_efatura_fatura_tipi
    ADD CONSTRAINT ayar_efatura_fatura_tipi_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.ayar_efatura_fatura_tipi DROP CONSTRAINT ayar_efatura_fatura_tipi_pkey;
       public         postgres    false    285    285            �           2606    103572     ayar_efatura_fatura_tipi_tip_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_efatura_fatura_tipi
    ADD CONSTRAINT ayar_efatura_fatura_tipi_tip_key UNIQUE (tip);
 c   ALTER TABLE ONLY public.ayar_efatura_fatura_tipi DROP CONSTRAINT ayar_efatura_fatura_tipi_tip_key;
       public         postgres    false    285    285            M           2606    157504 #   ayar_efatura_gonderici_bilgisi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_gonderici_bilgisi
    ADD CONSTRAINT ayar_efatura_gonderici_bilgisi_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.ayar_efatura_gonderici_bilgisi DROP CONSTRAINT ayar_efatura_gonderici_bilgisi_pkey;
       public         postgres    false    359    359            w           2606    157719 #   ayar_efatura_gonderim_sekli_kod_key 
   CONSTRAINT     y   ALTER TABLE ONLY public.ayar_efatura_gonderim_sekli
    ADD CONSTRAINT ayar_efatura_gonderim_sekli_kod_key UNIQUE (kod);
 i   ALTER TABLE ONLY public.ayar_efatura_gonderim_sekli DROP CONSTRAINT ayar_efatura_gonderim_sekli_kod_key;
       public         postgres    false    381    381            y           2606    157717     ayar_efatura_gonderim_sekli_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.ayar_efatura_gonderim_sekli
    ADD CONSTRAINT ayar_efatura_gonderim_sekli_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.ayar_efatura_gonderim_sekli DROP CONSTRAINT ayar_efatura_gonderim_sekli_pkey;
       public         postgres    false    381    381            G           2606    157477 0   ayar_efatura_ihrac_kayitli_fatura_sebebi_kod_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_ihrac_kayitli_fatura_sebebi
    ADD CONSTRAINT ayar_efatura_ihrac_kayitli_fatura_sebebi_kod_key UNIQUE (kod);
 �   ALTER TABLE ONLY public.ayar_efatura_ihrac_kayitli_fatura_sebebi DROP CONSTRAINT ayar_efatura_ihrac_kayitli_fatura_sebebi_kod_key;
       public         postgres    false    355    355            I           2606    157475 -   ayar_efatura_ihrac_kayitli_fatura_sebebi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_ihrac_kayitli_fatura_sebebi
    ADD CONSTRAINT ayar_efatura_ihrac_kayitli_fatura_sebebi_pkey PRIMARY KEY (id);
 �   ALTER TABLE ONLY public.ayar_efatura_ihrac_kayitli_fatura_sebebi DROP CONSTRAINT ayar_efatura_ihrac_kayitli_fatura_sebebi_pkey;
       public         postgres    false    355    355                       2606    50090 $   ayar_efatura_iletisim_kanali_kod_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.ayar_efatura_iletisim_kanali
    ADD CONSTRAINT ayar_efatura_iletisim_kanali_kod_key UNIQUE (kod);
 k   ALTER TABLE ONLY public.ayar_efatura_iletisim_kanali DROP CONSTRAINT ayar_efatura_iletisim_kanali_kod_key;
       public         postgres    false    191    191                       2606    50092 !   ayar_efatura_iletisim_kanali_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.ayar_efatura_iletisim_kanali
    ADD CONSTRAINT ayar_efatura_iletisim_kanali_pkey PRIMARY KEY (id);
 h   ALTER TABLE ONLY public.ayar_efatura_iletisim_kanali DROP CONSTRAINT ayar_efatura_iletisim_kanali_pkey;
       public         postgres    false    191    191                       2606    50100    ayar_efatura_istisna_kodu_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ayar_efatura_istisna_kodu
    ADD CONSTRAINT ayar_efatura_istisna_kodu_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY public.ayar_efatura_istisna_kodu DROP CONSTRAINT ayar_efatura_istisna_kodu_pkey;
       public         postgres    false    193    193                       2606    50102 &   ayar_efatura_kimlik_semalari_deger_key 
   CONSTRAINT        ALTER TABLE ONLY public.ayar_efatura_kimlik_semalari
    ADD CONSTRAINT ayar_efatura_kimlik_semalari_deger_key UNIQUE (deger);
 m   ALTER TABLE ONLY public.ayar_efatura_kimlik_semalari DROP CONSTRAINT ayar_efatura_kimlik_semalari_deger_key;
       public         postgres    false    195    195                       2606    50104 !   ayar_efatura_kimlik_semalari_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.ayar_efatura_kimlik_semalari
    ADD CONSTRAINT ayar_efatura_kimlik_semalari_pkey PRIMARY KEY (id);
 h   ALTER TABLE ONLY public.ayar_efatura_kimlik_semalari DROP CONSTRAINT ayar_efatura_kimlik_semalari_pkey;
       public         postgres    false    195    195            �           2606    157768 (   ayar_efatura_odeme_sekli_odeme_sekli_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_odeme_sekli
    ADD CONSTRAINT ayar_efatura_odeme_sekli_odeme_sekli_key UNIQUE (odeme_sekli);
 k   ALTER TABLE ONLY public.ayar_efatura_odeme_sekli DROP CONSTRAINT ayar_efatura_odeme_sekli_odeme_sekli_key;
       public         postgres    false    387    387            �           2606    157766    ayar_efatura_odeme_sekli_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.ayar_efatura_odeme_sekli
    ADD CONSTRAINT ayar_efatura_odeme_sekli_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.ayar_efatura_odeme_sekli DROP CONSTRAINT ayar_efatura_odeme_sekli_pkey;
       public         postgres    false    387    387            �           2606    157783    ayar_efatura_paket_tipi_kod_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.ayar_efatura_paket_tipi
    ADD CONSTRAINT ayar_efatura_paket_tipi_kod_key UNIQUE (kod);
 a   ALTER TABLE ONLY public.ayar_efatura_paket_tipi DROP CONSTRAINT ayar_efatura_paket_tipi_kod_key;
       public         postgres    false    389    389            �           2606    157781    ayar_efatura_paket_tipi_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_efatura_paket_tipi
    ADD CONSTRAINT ayar_efatura_paket_tipi_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_efatura_paket_tipi DROP CONSTRAINT ayar_efatura_paket_tipi_pkey;
       public         postgres    false    389    389                       2606    50106 $   ayar_efatura_response_code_deger_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.ayar_efatura_response_code
    ADD CONSTRAINT ayar_efatura_response_code_deger_key UNIQUE (deger);
 i   ALTER TABLE ONLY public.ayar_efatura_response_code DROP CONSTRAINT ayar_efatura_response_code_deger_key;
       public         postgres    false    197    197                       2606    50108    ayar_efatura_response_code_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_efatura_response_code
    ADD CONSTRAINT ayar_efatura_response_code_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_efatura_response_code DROP CONSTRAINT ayar_efatura_response_code_pkey;
       public         postgres    false    197    197            �           2606    103305    ayar_efatura_senaryo_tipi_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ayar_efatura_senaryo_tipi
    ADD CONSTRAINT ayar_efatura_senaryo_tipi_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY public.ayar_efatura_senaryo_tipi DROP CONSTRAINT ayar_efatura_senaryo_tipi_pkey;
       public         postgres    false    274    274            �           2606    103307 !   ayar_efatura_senaryo_tipi_tip_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.ayar_efatura_senaryo_tipi
    ADD CONSTRAINT ayar_efatura_senaryo_tipi_tip_key UNIQUE (tip);
 e   ALTER TABLE ONLY public.ayar_efatura_senaryo_tipi DROP CONSTRAINT ayar_efatura_senaryo_tipi_tip_key;
       public         postgres    false    274    274            �           2606    184614 !   ayar_efatura_teslim_sarti_kod_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.ayar_efatura_teslim_sarti
    ADD CONSTRAINT ayar_efatura_teslim_sarti_kod_key UNIQUE (kod);
 e   ALTER TABLE ONLY public.ayar_efatura_teslim_sarti DROP CONSTRAINT ayar_efatura_teslim_sarti_kod_key;
       public         postgres    false    397    397            �           2606    184612    ayar_efatura_teslim_sarti_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ayar_efatura_teslim_sarti
    ADD CONSTRAINT ayar_efatura_teslim_sarti_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY public.ayar_efatura_teslim_sarti DROP CONSTRAINT ayar_efatura_teslim_sarti_pkey;
       public         postgres    false    397    397                       2606    50114 -   ayar_efatura_tevkifat_kodu_kodu_pay_payda_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_tevkifat_kodu
    ADD CONSTRAINT ayar_efatura_tevkifat_kodu_kodu_pay_payda_key UNIQUE (kodu, pay, payda);
 r   ALTER TABLE ONLY public.ayar_efatura_tevkifat_kodu DROP CONSTRAINT ayar_efatura_tevkifat_kodu_kodu_pay_payda_key;
       public         postgres    false    199    199    199    199            !           2606    50116    ayar_efatura_tevkifat_kodu_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_efatura_tevkifat_kodu
    ADD CONSTRAINT ayar_efatura_tevkifat_kodu_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_efatura_tevkifat_kodu DROP CONSTRAINT ayar_efatura_tevkifat_kodu_pkey;
       public         postgres    false    199    199            k           2606    157672 .   ayar_fatura_no_serisi_fatura_seri_id_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_fatura_no_serisi
    ADD CONSTRAINT ayar_fatura_no_serisi_fatura_seri_id_deger_key UNIQUE (fatura_seri_id, deger);
 n   ALTER TABLE ONLY public.ayar_fatura_no_serisi DROP CONSTRAINT ayar_fatura_no_serisi_fatura_seri_id_deger_key;
       public         postgres    false    375    375    375            m           2606    157670    ayar_fatura_no_serisi_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.ayar_fatura_no_serisi
    ADD CONSTRAINT ayar_fatura_no_serisi_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.ayar_fatura_no_serisi DROP CONSTRAINT ayar_fatura_no_serisi_pkey;
       public         postgres    false    375    375            +           2606    50122 *   ayar_firma_tipi_detay_firma_tipi_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_firma_tipi_detay
    ADD CONSTRAINT ayar_firma_tipi_detay_firma_tipi_deger_key UNIQUE (firma_tipi, deger);
 j   ALTER TABLE ONLY public.ayar_firma_tipi_detay DROP CONSTRAINT ayar_firma_tipi_detay_firma_tipi_deger_key;
       public         postgres    false    204    204    204            -           2606    50124    ayar_firma_tipi_detay_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.ayar_firma_tipi_detay
    ADD CONSTRAINT ayar_firma_tipi_detay_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.ayar_firma_tipi_detay DROP CONSTRAINT ayar_firma_tipi_detay_pkey;
       public         postgres    false    204    204            '           2606    50126    ayar_firma_tipi_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ayar_firma_tipi
    ADD CONSTRAINT ayar_firma_tipi_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ayar_firma_tipi DROP CONSTRAINT ayar_firma_tipi_pkey;
       public         postgres    false    203    203            )           2606    50128    ayar_firma_tipi_tip_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.ayar_firma_tipi
    ADD CONSTRAINT ayar_firma_tipi_tip_key UNIQUE (tip);
 Q   ALTER TABLE ONLY public.ayar_firma_tipi DROP CONSTRAINT ayar_firma_tipi_tip_key;
       public         postgres    false    203    203            s           2606    157704    ayar_fis_tipi_deger_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.ayar_fis_tipi
    ADD CONSTRAINT ayar_fis_tipi_deger_key UNIQUE (deger);
 O   ALTER TABLE ONLY public.ayar_fis_tipi DROP CONSTRAINT ayar_fis_tipi_deger_key;
       public         postgres    false    379    379            u           2606    157702    ayar_fis_tipi_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.ayar_fis_tipi
    ADD CONSTRAINT ayar_fis_tipi_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.ayar_fis_tipi DROP CONSTRAINT ayar_fis_tipi_pkey;
       public         postgres    false    379    379            /           2606    50130    ayar_genel_ayarlar_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.ayar_genel_ayarlar
    ADD CONSTRAINT ayar_genel_ayarlar_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.ayar_genel_ayarlar DROP CONSTRAINT ayar_genel_ayarlar_pkey;
       public         postgres    false    207    207            1           2606    50132 '   ayar_genel_ayarlar_tc_no_firma_tipi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_genel_ayarlar
    ADD CONSTRAINT ayar_genel_ayarlar_tc_no_firma_tipi_key UNIQUE (tc_no, firma_tipi);
 d   ALTER TABLE ONLY public.ayar_genel_ayarlar DROP CONSTRAINT ayar_genel_ayarlar_tc_no_firma_tipi_key;
       public         postgres    false    207    207    207            3           2606    50134 *   ayar_genel_ayarlar_vergi_no_firma_tipi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_genel_ayarlar
    ADD CONSTRAINT ayar_genel_ayarlar_vergi_no_firma_tipi_key UNIQUE (vergi_no, firma_tipi);
 g   ALTER TABLE ONLY public.ayar_genel_ayarlar DROP CONSTRAINT ayar_genel_ayarlar_vergi_no_firma_tipi_key;
       public         postgres    false    207    207    207            �           2606    96426    ayar_hane_sayisi_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ayar_hane_sayisi
    ADD CONSTRAINT ayar_hane_sayisi_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ayar_hane_sayisi DROP CONSTRAINT ayar_hane_sayisi_pkey;
       public         postgres    false    264    264            �           2606    96428    ayar_hane_sayisi_ukey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_hane_sayisi
    ADD CONSTRAINT ayar_hane_sayisi_ukey UNIQUE (hesap_bakiye, alis_miktar, alis_fiyat, alis_tutar, satis_miktar, satis_fiyat, satis_tutar, stok_miktar, stok_fiyat);
 P   ALTER TABLE ONLY public.ayar_hane_sayisi DROP CONSTRAINT ayar_hane_sayisi_ukey;
       public         postgres    false    264    264    264    264    264    264    264    264    264    264                       2606    133813    ayar_hesap_tipi_deger_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.ayar_hesap_tipi
    ADD CONSTRAINT ayar_hesap_tipi_deger_key UNIQUE (deger);
 S   ALTER TABLE ONLY public.ayar_hesap_tipi DROP CONSTRAINT ayar_hesap_tipi_deger_key;
       public         postgres    false    333    333                       2606    133811    ayar_hesap_tipi_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ayar_hesap_tipi
    ADD CONSTRAINT ayar_hesap_tipi_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ayar_hesap_tipi DROP CONSTRAINT ayar_hesap_tipi_pkey;
       public         postgres    false    333    333            c           2606    157650 (   ayar_irsaliye_fatura_no_serisi_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_irsaliye_fatura_no_serisi
    ADD CONSTRAINT ayar_irsaliye_fatura_no_serisi_deger_key UNIQUE (deger);
 q   ALTER TABLE ONLY public.ayar_irsaliye_fatura_no_serisi DROP CONSTRAINT ayar_irsaliye_fatura_no_serisi_deger_key;
       public         postgres    false    371    371            e           2606    157648 #   ayar_irsaliye_fatura_no_serisi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_irsaliye_fatura_no_serisi
    ADD CONSTRAINT ayar_irsaliye_fatura_no_serisi_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.ayar_irsaliye_fatura_no_serisi DROP CONSTRAINT ayar_irsaliye_fatura_no_serisi_pkey;
       public         postgres    false    371    371            g           2606    157661 2   ayar_irsaliye_no_serisi_irsaliye_seri_id_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi
    ADD CONSTRAINT ayar_irsaliye_no_serisi_irsaliye_seri_id_deger_key UNIQUE (irsaliye_seri_id, deger);
 t   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi DROP CONSTRAINT ayar_irsaliye_no_serisi_irsaliye_seri_id_deger_key;
       public         postgres    false    373    373    373            i           2606    157659    ayar_irsaliye_no_serisi_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi
    ADD CONSTRAINT ayar_irsaliye_no_serisi_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi DROP CONSTRAINT ayar_irsaliye_no_serisi_pkey;
       public         postgres    false    373    373            S           2606    157557    ayar_modul_tipi_deger_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.ayar_modul_tipi
    ADD CONSTRAINT ayar_modul_tipi_deger_key UNIQUE (deger);
 S   ALTER TABLE ONLY public.ayar_modul_tipi DROP CONSTRAINT ayar_modul_tipi_deger_key;
       public         postgres    false    363    363            U           2606    157555    ayar_modul_tipi_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ayar_modul_tipi
    ADD CONSTRAINT ayar_modul_tipi_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ayar_modul_tipi DROP CONSTRAINT ayar_modul_tipi_pkey;
       public         postgres    false    363    363            o           2606    157693 !   ayar_musteri_firma_turu_deger_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.ayar_musteri_firma_turu
    ADD CONSTRAINT ayar_musteri_firma_turu_deger_key UNIQUE (deger);
 c   ALTER TABLE ONLY public.ayar_musteri_firma_turu DROP CONSTRAINT ayar_musteri_firma_turu_deger_key;
       public         postgres    false    377    377            q           2606    157691    ayar_musteri_firma_turu_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_musteri_firma_turu
    ADD CONSTRAINT ayar_musteri_firma_turu_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_musteri_firma_turu DROP CONSTRAINT ayar_musteri_firma_turu_pkey;
       public         postgres    false    377    377            �           2606    217669 %   ayar_odeme_baslangic_donemi_deger_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.ayar_odeme_baslangic_donemi
    ADD CONSTRAINT ayar_odeme_baslangic_donemi_deger_key UNIQUE (deger);
 k   ALTER TABLE ONLY public.ayar_odeme_baslangic_donemi DROP CONSTRAINT ayar_odeme_baslangic_donemi_deger_key;
       public         postgres    false    407    407            �           2606    217667     ayar_odeme_baslangic_donemi_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.ayar_odeme_baslangic_donemi
    ADD CONSTRAINT ayar_odeme_baslangic_donemi_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.ayar_odeme_baslangic_donemi DROP CONSTRAINT ayar_odeme_baslangic_donemi_pkey;
       public         postgres    false    407    407            ;           2606    157411     ayar_odeme_sekli_odeme_sekli_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_odeme_sekli
    ADD CONSTRAINT ayar_odeme_sekli_odeme_sekli_key UNIQUE (odeme_sekli);
 [   ALTER TABLE ONLY public.ayar_odeme_sekli DROP CONSTRAINT ayar_odeme_sekli_odeme_sekli_key;
       public         postgres    false    349    349            =           2606    157409    ayar_odeme_sekli_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ayar_odeme_sekli
    ADD CONSTRAINT ayar_odeme_sekli_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ayar_odeme_sekli DROP CONSTRAINT ayar_odeme_sekli_pkey;
       public         postgres    false    349    349            �           2606    217756 '   ayar_personel_askerlik_durumu_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_personel_askerlik_durumu
    ADD CONSTRAINT ayar_personel_askerlik_durumu_deger_key UNIQUE (deger);
 o   ALTER TABLE ONLY public.ayar_personel_askerlik_durumu DROP CONSTRAINT ayar_personel_askerlik_durumu_deger_key;
       public         postgres    false    413    413            �           2606    217754 "   ayar_personel_askerlik_durumu_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.ayar_personel_askerlik_durumu
    ADD CONSTRAINT ayar_personel_askerlik_durumu_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.ayar_personel_askerlik_durumu DROP CONSTRAINT ayar_personel_askerlik_durumu_pkey;
       public         postgres    false    413    413            �           2606    217947 +   ayar_personel_ayrilma_nedeni_tipi_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_personel_ayrilma_nedeni_tipi
    ADD CONSTRAINT ayar_personel_ayrilma_nedeni_tipi_deger_key UNIQUE (deger);
 w   ALTER TABLE ONLY public.ayar_personel_ayrilma_nedeni_tipi DROP CONSTRAINT ayar_personel_ayrilma_nedeni_tipi_deger_key;
       public         postgres    false    441    441            �           2606    217945 &   ayar_personel_ayrilma_nedeni_tipi_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_personel_ayrilma_nedeni_tipi
    ADD CONSTRAINT ayar_personel_ayrilma_nedeni_tipi_pkey PRIMARY KEY (id);
 r   ALTER TABLE ONLY public.ayar_personel_ayrilma_nedeni_tipi DROP CONSTRAINT ayar_personel_ayrilma_nedeni_tipi_pkey;
       public         postgres    false    441    441            �           2606    114943 &   ayar_personel_birim_bolum_id_birim_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_personel_birim
    ADD CONSTRAINT ayar_personel_birim_bolum_id_birim_key UNIQUE (bolum_id, birim);
 d   ALTER TABLE ONLY public.ayar_personel_birim DROP CONSTRAINT ayar_personel_birim_bolum_id_birim_key;
       public         postgres    false    291    291    291            �           2606    114941    ayar_personel_birim_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ayar_personel_birim
    ADD CONSTRAINT ayar_personel_birim_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.ayar_personel_birim DROP CONSTRAINT ayar_personel_birim_pkey;
       public         postgres    false    291    291            �           2606    114932    ayar_personel_bolum_bolum_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_personel_bolum
    ADD CONSTRAINT ayar_personel_bolum_bolum_key UNIQUE (bolum);
 [   ALTER TABLE ONLY public.ayar_personel_bolum DROP CONSTRAINT ayar_personel_bolum_bolum_key;
       public         postgres    false    289    289            �           2606    114930    ayar_personel_bolum_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ayar_personel_bolum
    ADD CONSTRAINT ayar_personel_bolum_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.ayar_personel_bolum DROP CONSTRAINT ayar_personel_bolum_pkey;
       public         postgres    false    289    289            �           2606    217767     ayar_personel_cinsiyet_deger_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_personel_cinsiyet
    ADD CONSTRAINT ayar_personel_cinsiyet_deger_key UNIQUE (deger);
 a   ALTER TABLE ONLY public.ayar_personel_cinsiyet DROP CONSTRAINT ayar_personel_cinsiyet_deger_key;
       public         postgres    false    415    415            �           2606    217765    ayar_personel_cinsiyet_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.ayar_personel_cinsiyet
    ADD CONSTRAINT ayar_personel_cinsiyet_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.ayar_personel_cinsiyet DROP CONSTRAINT ayar_personel_cinsiyet_pkey;
       public         postgres    false    415    415            �           2606    217857    ayar_personel_dil_deger_key 
   CONSTRAINT     i   ALTER TABLE ONLY public.ayar_personel_dil
    ADD CONSTRAINT ayar_personel_dil_deger_key UNIQUE (deger);
 W   ALTER TABLE ONLY public.ayar_personel_dil DROP CONSTRAINT ayar_personel_dil_deger_key;
       public         postgres    false    425    425            �           2606    217855    ayar_personel_dil_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.ayar_personel_dil
    ADD CONSTRAINT ayar_personel_dil_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.ayar_personel_dil DROP CONSTRAINT ayar_personel_dil_pkey;
       public         postgres    false    425    425            �           2606    217868 $   ayar_personel_dil_seviyesi_deger_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.ayar_personel_dil_seviyesi
    ADD CONSTRAINT ayar_personel_dil_seviyesi_deger_key UNIQUE (deger);
 i   ALTER TABLE ONLY public.ayar_personel_dil_seviyesi DROP CONSTRAINT ayar_personel_dil_seviyesi_deger_key;
       public         postgres    false    427    427            �           2606    217866    ayar_personel_dil_seviyesi_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_personel_dil_seviyesi
    ADD CONSTRAINT ayar_personel_dil_seviyesi_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_personel_dil_seviyesi DROP CONSTRAINT ayar_personel_dil_seviyesi_pkey;
       public         postgres    false    427    427            �           2606    217745 %   ayar_personel_egitim_durumu_deger_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.ayar_personel_egitim_durumu
    ADD CONSTRAINT ayar_personel_egitim_durumu_deger_key UNIQUE (deger);
 k   ALTER TABLE ONLY public.ayar_personel_egitim_durumu DROP CONSTRAINT ayar_personel_egitim_durumu_deger_key;
       public         postgres    false    411    411            �           2606    217743     ayar_personel_egitim_durumu_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.ayar_personel_egitim_durumu
    ADD CONSTRAINT ayar_personel_egitim_durumu_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.ayar_personel_egitim_durumu DROP CONSTRAINT ayar_personel_egitim_durumu_pkey;
       public         postgres    false    411    411            �           2606    217890 $   ayar_personel_ehliyet_tipi_deger_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.ayar_personel_ehliyet_tipi
    ADD CONSTRAINT ayar_personel_ehliyet_tipi_deger_key UNIQUE (deger);
 i   ALTER TABLE ONLY public.ayar_personel_ehliyet_tipi DROP CONSTRAINT ayar_personel_ehliyet_tipi_deger_key;
       public         postgres    false    431    431            �           2606    217888    ayar_personel_ehliyet_tipi_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_personel_ehliyet_tipi
    ADD CONSTRAINT ayar_personel_ehliyet_tipi_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_personel_ehliyet_tipi DROP CONSTRAINT ayar_personel_ehliyet_tipi_pkey;
       public         postgres    false    431    431            �           2606    114959    ayar_personel_gorev_gorev_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_personel_gorev
    ADD CONSTRAINT ayar_personel_gorev_gorev_key UNIQUE (gorev);
 [   ALTER TABLE ONLY public.ayar_personel_gorev DROP CONSTRAINT ayar_personel_gorev_gorev_key;
       public         postgres    false    293    293            �           2606    114957    ayar_personel_gorev_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ayar_personel_gorev
    ADD CONSTRAINT ayar_personel_gorev_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.ayar_personel_gorev DROP CONSTRAINT ayar_personel_gorev_pkey;
       public         postgres    false    293    293            �           2606    217800 !   ayar_personel_izin_tipi_deger_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.ayar_personel_izin_tipi
    ADD CONSTRAINT ayar_personel_izin_tipi_deger_key UNIQUE (deger);
 c   ALTER TABLE ONLY public.ayar_personel_izin_tipi DROP CONSTRAINT ayar_personel_izin_tipi_deger_key;
       public         postgres    false    421    421            �           2606    217798    ayar_personel_izin_tipi_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_personel_izin_tipi
    ADD CONSTRAINT ayar_personel_izin_tipi_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_personel_izin_tipi DROP CONSTRAINT ayar_personel_izin_tipi_pkey;
       public         postgres    false    421    421            �           2606    217778 !   ayar_personel_kan_grubu_deger_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.ayar_personel_kan_grubu
    ADD CONSTRAINT ayar_personel_kan_grubu_deger_key UNIQUE (deger);
 c   ALTER TABLE ONLY public.ayar_personel_kan_grubu DROP CONSTRAINT ayar_personel_kan_grubu_deger_key;
       public         postgres    false    417    417            �           2606    217776    ayar_personel_kan_grubu_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_personel_kan_grubu
    ADD CONSTRAINT ayar_personel_kan_grubu_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_personel_kan_grubu DROP CONSTRAINT ayar_personel_kan_grubu_pkey;
       public         postgres    false    417    417            �           2606    217811 $   ayar_personel_medeni_durum_deger_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.ayar_personel_medeni_durum
    ADD CONSTRAINT ayar_personel_medeni_durum_deger_key UNIQUE (deger);
 i   ALTER TABLE ONLY public.ayar_personel_medeni_durum DROP CONSTRAINT ayar_personel_medeni_durum_deger_key;
       public         postgres    false    423    423            �           2606    217809    ayar_personel_medeni_durum_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.ayar_personel_medeni_durum
    ADD CONSTRAINT ayar_personel_medeni_durum_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.ayar_personel_medeni_durum DROP CONSTRAINT ayar_personel_medeni_durum_pkey;
       public         postgres    false    423    423            �           2606    217936 #   ayar_personel_mektup_tipi_deger_key 
   CONSTRAINT     y   ALTER TABLE ONLY public.ayar_personel_mektup_tipi
    ADD CONSTRAINT ayar_personel_mektup_tipi_deger_key UNIQUE (deger);
 g   ALTER TABLE ONLY public.ayar_personel_mektup_tipi DROP CONSTRAINT ayar_personel_mektup_tipi_deger_key;
       public         postgres    false    439    439            �           2606    217934    ayar_personel_mektup_tipi_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.ayar_personel_mektup_tipi
    ADD CONSTRAINT ayar_personel_mektup_tipi_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY public.ayar_personel_mektup_tipi DROP CONSTRAINT ayar_personel_mektup_tipi_pkey;
       public         postgres    false    439    439            �           2606    217901     ayar_personel_myk_tipi_deger_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_personel_myk_tipi
    ADD CONSTRAINT ayar_personel_myk_tipi_deger_key UNIQUE (deger);
 a   ALTER TABLE ONLY public.ayar_personel_myk_tipi DROP CONSTRAINT ayar_personel_myk_tipi_deger_key;
       public         postgres    false    433    433            �           2606    217899    ayar_personel_myk_tipi_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.ayar_personel_myk_tipi
    ADD CONSTRAINT ayar_personel_myk_tipi_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.ayar_personel_myk_tipi DROP CONSTRAINT ayar_personel_myk_tipi_pkey;
       public         postgres    false    433    433            �           2606    217789 "   ayar_personel_rapor_tipi_deger_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.ayar_personel_rapor_tipi
    ADD CONSTRAINT ayar_personel_rapor_tipi_deger_key UNIQUE (deger);
 e   ALTER TABLE ONLY public.ayar_personel_rapor_tipi DROP CONSTRAINT ayar_personel_rapor_tipi_deger_key;
       public         postgres    false    419    419            �           2606    217787    ayar_personel_rapor_tipi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.ayar_personel_rapor_tipi
    ADD CONSTRAINT ayar_personel_rapor_tipi_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.ayar_personel_rapor_tipi DROP CONSTRAINT ayar_personel_rapor_tipi_pkey;
       public         postgres    false    419    419            �           2606    217912     ayar_personel_src_tipi_deger_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_personel_src_tipi
    ADD CONSTRAINT ayar_personel_src_tipi_deger_key UNIQUE (deger);
 a   ALTER TABLE ONLY public.ayar_personel_src_tipi DROP CONSTRAINT ayar_personel_src_tipi_deger_key;
       public         postgres    false    435    435            �           2606    217910    ayar_personel_src_tipi_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.ayar_personel_src_tipi
    ADD CONSTRAINT ayar_personel_src_tipi_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.ayar_personel_src_tipi DROP CONSTRAINT ayar_personel_src_tipi_pkey;
       public         postgres    false    435    435            �           2606    217924 "   ayar_personel_tatil_tipi_deger_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.ayar_personel_tatil_tipi
    ADD CONSTRAINT ayar_personel_tatil_tipi_deger_key UNIQUE (deger);
 e   ALTER TABLE ONLY public.ayar_personel_tatil_tipi DROP CONSTRAINT ayar_personel_tatil_tipi_deger_key;
       public         postgres    false    437    437            �           2606    217922    ayar_personel_tatil_tipi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.ayar_personel_tatil_tipi
    ADD CONSTRAINT ayar_personel_tatil_tipi_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.ayar_personel_tatil_tipi DROP CONSTRAINT ayar_personel_tatil_tipi_pkey;
       public         postgres    false    437    437            �           2606    217699    ayar_personel_tipi_deger_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.ayar_personel_tipi
    ADD CONSTRAINT ayar_personel_tipi_deger_key UNIQUE (deger);
 Y   ALTER TABLE ONLY public.ayar_personel_tipi DROP CONSTRAINT ayar_personel_tipi_deger_key;
       public         postgres    false    409    409            �           2606    217697    ayar_personel_tipi_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.ayar_personel_tipi
    ADD CONSTRAINT ayar_personel_tipi_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.ayar_personel_tipi DROP CONSTRAINT ayar_personel_tipi_pkey;
       public         postgres    false    409    409            5           2606    50140    ayar_sabit_degisken_deger_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_sabit_degisken
    ADD CONSTRAINT ayar_sabit_degisken_deger_key UNIQUE (deger);
 [   ALTER TABLE ONLY public.ayar_sabit_degisken DROP CONSTRAINT ayar_sabit_degisken_deger_key;
       public         postgres    false    209    209            7           2606    50142    ayar_sabit_degisken_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.ayar_sabit_degisken
    ADD CONSTRAINT ayar_sabit_degisken_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.ayar_sabit_degisken DROP CONSTRAINT ayar_sabit_degisken_pkey;
       public         postgres    false    209    209            {           2606    157732 (   ayar_sevkiyat_hazirlama_durumu_deger_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_sevkiyat_hazirlama_durumu
    ADD CONSTRAINT ayar_sevkiyat_hazirlama_durumu_deger_key UNIQUE (deger);
 q   ALTER TABLE ONLY public.ayar_sevkiyat_hazirlama_durumu DROP CONSTRAINT ayar_sevkiyat_hazirlama_durumu_deger_key;
       public         postgres    false    383    383            }           2606    157730 #   ayar_sevkiyat_hazirlama_durumu_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.ayar_sevkiyat_hazirlama_durumu
    ADD CONSTRAINT ayar_sevkiyat_hazirlama_durumu_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.ayar_sevkiyat_hazirlama_durumu DROP CONSTRAINT ayar_sevkiyat_hazirlama_durumu_pkey;
       public         postgres    false    383    383                       2606    157741    ayar_stok_hareket_ayari_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.ayar_stok_hareket_ayari
    ADD CONSTRAINT ayar_stok_hareket_ayari_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.ayar_stok_hareket_ayari DROP CONSTRAINT ayar_stok_hareket_ayari_pkey;
       public         postgres    false    385    385            �           2606    103334     ayar_stok_hareket_tipi_deger_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_stok_hareket_tipi
    ADD CONSTRAINT ayar_stok_hareket_tipi_deger_key UNIQUE (deger);
 a   ALTER TABLE ONLY public.ayar_stok_hareket_tipi DROP CONSTRAINT ayar_stok_hareket_tipi_deger_key;
       public         postgres    false    276    276            �           2606    142363 #   ayar_stok_hareket_tipi_is_input_key 
   CONSTRAINT     y   ALTER TABLE ONLY public.ayar_stok_hareket_tipi
    ADD CONSTRAINT ayar_stok_hareket_tipi_is_input_key UNIQUE (is_input);
 d   ALTER TABLE ONLY public.ayar_stok_hareket_tipi DROP CONSTRAINT ayar_stok_hareket_tipi_is_input_key;
       public         postgres    false    276    276            �           2606    103332    ayar_stok_hareket_tipi_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.ayar_stok_hareket_tipi
    ADD CONSTRAINT ayar_stok_hareket_tipi_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.ayar_stok_hareket_tipi DROP CONSTRAINT ayar_stok_hareket_tipi_pkey;
       public         postgres    false    276    276            �           2606    184707    ayar_teklif_durum_deger_key 
   CONSTRAINT     i   ALTER TABLE ONLY public.ayar_teklif_durum
    ADD CONSTRAINT ayar_teklif_durum_deger_key UNIQUE (deger);
 W   ALTER TABLE ONLY public.ayar_teklif_durum DROP CONSTRAINT ayar_teklif_durum_deger_key;
       public         postgres    false    399    399            �           2606    184705    ayar_teklif_durum_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.ayar_teklif_durum
    ADD CONSTRAINT ayar_teklif_durum_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.ayar_teklif_durum DROP CONSTRAINT ayar_teklif_durum_pkey;
       public         postgres    false    399    399            �           2606    217657    ayar_teklif_tipi_deger_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.ayar_teklif_tipi
    ADD CONSTRAINT ayar_teklif_tipi_deger_key UNIQUE (deger);
 U   ALTER TABLE ONLY public.ayar_teklif_tipi DROP CONSTRAINT ayar_teklif_tipi_deger_key;
       public         postgres    false    405    405            �           2606    217655    ayar_teklif_tipi_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ayar_teklif_tipi
    ADD CONSTRAINT ayar_teklif_tipi_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ayar_teklif_tipi DROP CONSTRAINT ayar_teklif_tipi_pkey;
       public         postgres    false    405    405            �           2606    114981    ayar_vergi_orani_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ayar_vergi_orani
    ADD CONSTRAINT ayar_vergi_orani_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.ayar_vergi_orani DROP CONSTRAINT ayar_vergi_orani_pkey;
       public         postgres    false    295    295            �           2606    114983     ayar_vergi_orani_vergi_orani_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.ayar_vergi_orani
    ADD CONSTRAINT ayar_vergi_orani_vergi_orani_key UNIQUE (vergi_orani);
 [   ALTER TABLE ONLY public.ayar_vergi_orani DROP CONSTRAINT ayar_vergi_orani_vergi_orani_key;
       public         postgres    false    295    295            �           2606    88309    banka_adi_key 
   CONSTRAINT     M   ALTER TABLE ONLY public.banka
    ADD CONSTRAINT banka_adi_key UNIQUE (adi);
 =   ALTER TABLE ONLY public.banka DROP CONSTRAINT banka_adi_key;
       public         postgres    false    262    262            �           2606    88307 
   banka_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.banka
    ADD CONSTRAINT banka_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.banka DROP CONSTRAINT banka_pkey;
       public         postgres    false    262    262                       2606    131298    banka_subesi_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.banka_subesi
    ADD CONSTRAINT banka_subesi_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.banka_subesi DROP CONSTRAINT banka_subesi_pkey;
       public         postgres    false    321    321                       2606    133710    barkod_hazirlik_dosya_turu_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.barkod_hazirlik_dosya_turu
    ADD CONSTRAINT barkod_hazirlik_dosya_turu_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.barkod_hazirlik_dosya_turu DROP CONSTRAINT barkod_hazirlik_dosya_turu_pkey;
       public         postgres    false    331    331                       2606    133712 "   barkod_hazirlik_dosya_turu_tur_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.barkod_hazirlik_dosya_turu
    ADD CONSTRAINT barkod_hazirlik_dosya_turu_tur_key UNIQUE (tur);
 g   ALTER TABLE ONLY public.barkod_hazirlik_dosya_turu DROP CONSTRAINT barkod_hazirlik_dosya_turu_tur_key;
       public         postgres    false    331    331                       2606    133681    barkod_serino_turu_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.barkod_serino_turu
    ADD CONSTRAINT barkod_serino_turu_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.barkod_serino_turu DROP CONSTRAINT barkod_serino_turu_pkey;
       public         postgres    false    327    327                       2606    133683    barkod_serino_turu_tur_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.barkod_serino_turu
    ADD CONSTRAINT barkod_serino_turu_tur_key UNIQUE (tur);
 W   ALTER TABLE ONLY public.barkod_serino_turu DROP CONSTRAINT barkod_serino_turu_tur_key;
       public         postgres    false    327    327                       2606    133693    barkod_tezgah_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.barkod_tezgah
    ADD CONSTRAINT barkod_tezgah_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.barkod_tezgah DROP CONSTRAINT barkod_tezgah_pkey;
       public         postgres    false    329    329                       2606    133695 %   barkod_tezgah_tezgah_adi_ambar_id_key 
   CONSTRAINT     ~   ALTER TABLE ONLY public.barkod_tezgah
    ADD CONSTRAINT barkod_tezgah_tezgah_adi_ambar_id_key UNIQUE (tezgah_adi, ambar_id);
 ]   ALTER TABLE ONLY public.barkod_tezgah DROP CONSTRAINT barkod_tezgah_tezgah_adi_ambar_id_key;
       public         postgres    false    329    329    329            �           2606    115046    bolge_bolge_adi_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.bolge
    ADD CONSTRAINT bolge_bolge_adi_key UNIQUE (bolge_adi);
 C   ALTER TABLE ONLY public.bolge DROP CONSTRAINT bolge_bolge_adi_key;
       public         postgres    false    297    297            �           2606    115044 
   bolge_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.bolge
    ADD CONSTRAINT bolge_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.bolge DROP CONSTRAINT bolge_pkey;
       public         postgres    false    297    297            9           2606    50150    bolge_turu_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.bolge_turu
    ADD CONSTRAINT bolge_turu_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.bolge_turu DROP CONSTRAINT bolge_turu_pkey;
       public         postgres    false    211    211            ;           2606    50152    bolge_turu_tur_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.bolge_turu
    ADD CONSTRAINT bolge_turu_tur_key UNIQUE (tur);
 G   ALTER TABLE ONLY public.bolge_turu DROP CONSTRAINT bolge_turu_tur_key;
       public         postgres    false    211    211                       2606    131337    cins_ailesi_aile_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.cins_ailesi
    ADD CONSTRAINT cins_ailesi_aile_key UNIQUE (aile);
 J   ALTER TABLE ONLY public.cins_ailesi DROP CONSTRAINT cins_ailesi_aile_key;
       public         postgres    false    323    323            	           2606    131335    cins_ailesi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cins_ailesi
    ADD CONSTRAINT cins_ailesi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.cins_ailesi DROP CONSTRAINT cins_ailesi_pkey;
       public         postgres    false    323    323                       2606    131391    cins_ozelligi_cins_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.cins_ozelligi
    ADD CONSTRAINT cins_ozelligi_cins_key UNIQUE (cins);
 N   ALTER TABLE ONLY public.cins_ozelligi DROP CONSTRAINT cins_ozelligi_cins_key;
       public         postgres    false    325    325                       2606    131389    cins_ozelligi_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.cins_ozelligi
    ADD CONSTRAINT cins_ozelligi_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cins_ozelligi DROP CONSTRAINT cins_ozelligi_pkey;
       public         postgres    false    325    325                       2606    123270    doviz_kuru_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.doviz_kuru
    ADD CONSTRAINT doviz_kuru_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.doviz_kuru DROP CONSTRAINT doviz_kuru_pkey;
       public         postgres    false    319    319                       2606    123280     doviz_kuru_tarih_para_birimi_key 
   CONSTRAINT     t   ALTER TABLE ONLY public.doviz_kuru
    ADD CONSTRAINT doviz_kuru_tarih_para_birimi_key UNIQUE (tarih, para_birimi);
 U   ALTER TABLE ONLY public.doviz_kuru DROP CONSTRAINT doviz_kuru_tarih_para_birimi_key;
       public         postgres    false    319    319    319            #           2606    50168    efatura_vergi_kodu_kodu_key 
   CONSTRAINT     n   ALTER TABLE ONLY public.ayar_efatura_vergi_kodu
    ADD CONSTRAINT efatura_vergi_kodu_kodu_key UNIQUE (kodu);
 ]   ALTER TABLE ONLY public.ayar_efatura_vergi_kodu DROP CONSTRAINT efatura_vergi_kodu_kodu_key;
       public         postgres    false    201    201            %           2606    50170    efatura_vergi_kodu_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ayar_efatura_vergi_kodu
    ADD CONSTRAINT efatura_vergi_kodu_pkey PRIMARY KEY (id);
 Y   ALTER TABLE ONLY public.ayar_efatura_vergi_kodu DROP CONSTRAINT efatura_vergi_kodu_pkey;
       public         postgres    false    201    201            C           2606    50172    hesap_grubu_grup_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.hesap_grubu
    ADD CONSTRAINT hesap_grubu_grup_key UNIQUE (grup);
 J   ALTER TABLE ONLY public.hesap_grubu DROP CONSTRAINT hesap_grubu_grup_key;
       public         postgres    false    214    214            E           2606    50174    hesap_grubu_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.hesap_grubu
    ADD CONSTRAINT hesap_grubu_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.hesap_grubu DROP CONSTRAINT hesap_grubu_pkey;
       public         postgres    false    214    214            =           2606    50176    hesap_hesap_kodu_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.hesap
    ADD CONSTRAINT hesap_hesap_kodu_key UNIQUE (hesap_kodu);
 D   ALTER TABLE ONLY public.hesap DROP CONSTRAINT hesap_hesap_kodu_key;
       public         postgres    false    213    213            �           2606    115065    hesap_karti_hesap_kodu_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.hesap_karti
    ADD CONSTRAINT hesap_karti_hesap_kodu_key UNIQUE (hesap_kodu);
 P   ALTER TABLE ONLY public.hesap_karti DROP CONSTRAINT hesap_karti_hesap_kodu_key;
       public         postgres    false    299    299            �           2606    115063    hesap_karti_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.hesap_karti
    ADD CONSTRAINT hesap_karti_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.hesap_karti DROP CONSTRAINT hesap_karti_pkey;
       public         postgres    false    299    299            ?           2606    50178    hesap_muhasebe_kodu_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.hesap
    ADD CONSTRAINT hesap_muhasebe_kodu_key UNIQUE (muhasebe_kodu);
 G   ALTER TABLE ONLY public.hesap DROP CONSTRAINT hesap_muhasebe_kodu_key;
       public         postgres    false    213    213            A           2606    50180 
   hesap_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.hesap
    ADD CONSTRAINT hesap_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.hesap DROP CONSTRAINT hesap_pkey;
       public         postgres    false    213    213            G           2606    50182    hesap_plani_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.hesap_plani
    ADD CONSTRAINT hesap_plani_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.hesap_plani DROP CONSTRAINT hesap_plani_pkey;
       public         postgres    false    217    217            I           2606    50184    hesap_plani_plan_kodu_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.hesap_plani
    ADD CONSTRAINT hesap_plani_plan_kodu_key UNIQUE (plan_kodu);
 O   ALTER TABLE ONLY public.hesap_plani DROP CONSTRAINT hesap_plani_plan_kodu_key;
       public         postgres    false    217    217            �           2606    114921    medeni_durum_durum_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.medeni_durum
    ADD CONSTRAINT medeni_durum_durum_key UNIQUE (durum);
 M   ALTER TABLE ONLY public.medeni_durum DROP CONSTRAINT medeni_durum_durum_key;
       public         postgres    false    287    287            �           2606    114919    medeni_durum_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.medeni_durum
    ADD CONSTRAINT medeni_durum_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.medeni_durum DROP CONSTRAINT medeni_durum_pkey;
       public         postgres    false    287    287            K           2606    50186    muhasebe_hesap_plani_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.muhasebe_hesap_plani
    ADD CONSTRAINT muhasebe_hesap_plani_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.muhasebe_hesap_plani DROP CONSTRAINT muhasebe_hesap_plani_pkey;
       public         postgres    false    219    219            M           2606    50188 "   muhasebe_hesap_plani_plan_kodu_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.muhasebe_hesap_plani
    ADD CONSTRAINT muhasebe_hesap_plani_plan_kodu_key UNIQUE (plan_kodu);
 a   ALTER TABLE ONLY public.muhasebe_hesap_plani DROP CONSTRAINT muhasebe_hesap_plani_plan_kodu_key;
       public         postgres    false    219    219            �           2606    123090    olcu_birimi_birim_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.olcu_birimi
    ADD CONSTRAINT olcu_birimi_birim_key UNIQUE (birim);
 K   ALTER TABLE ONLY public.olcu_birimi DROP CONSTRAINT olcu_birimi_birim_key;
       public         postgres    false    301    301            �           2606    123092    olcu_birimi_efatura_birim_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.olcu_birimi
    ADD CONSTRAINT olcu_birimi_efatura_birim_key UNIQUE (efatura_birim);
 S   ALTER TABLE ONLY public.olcu_birimi DROP CONSTRAINT olcu_birimi_efatura_birim_key;
       public         postgres    false    301    301            �           2606    123088    olcu_birimi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.olcu_birimi
    ADD CONSTRAINT olcu_birimi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.olcu_birimi DROP CONSTRAINT olcu_birimi_pkey;
       public         postgres    false    301    301            �           2606    96439    para_birimi_kod_ukey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.para_birimi
    ADD CONSTRAINT para_birimi_kod_ukey UNIQUE (kod);
 J   ALTER TABLE ONLY public.para_birimi DROP CONSTRAINT para_birimi_kod_ukey;
       public         postgres    false    266    266            �           2606    96437    para_birimi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.para_birimi
    ADD CONSTRAINT para_birimi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.para_birimi DROP CONSTRAINT para_birimi_pkey;
       public         postgres    false    266    266            O           2606    50198 !   personel_ayrilma_nedeni_tipi_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.personel_ayrilma_nedeni_tipi
    ADD CONSTRAINT personel_ayrilma_nedeni_tipi_pkey PRIMARY KEY (id);
 h   ALTER TABLE ONLY public.personel_ayrilma_nedeni_tipi DROP CONSTRAINT personel_ayrilma_nedeni_tipi_pkey;
       public         postgres    false    221    221            Q           2606    50200 $   personel_ayrilma_nedeni_tipi_tip_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.personel_ayrilma_nedeni_tipi
    ADD CONSTRAINT personel_ayrilma_nedeni_tipi_tip_key UNIQUE (tip);
 k   ALTER TABLE ONLY public.personel_ayrilma_nedeni_tipi DROP CONSTRAINT personel_ayrilma_nedeni_tipi_tip_key;
       public         postgres    false    221    221            S           2606    50212    personel_calisma_gecmisi_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.personel_calisma_gecmisi
    ADD CONSTRAINT personel_calisma_gecmisi_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.personel_calisma_gecmisi DROP CONSTRAINT personel_calisma_gecmisi_pkey;
       public         postgres    false    223    223            �           2606    217879 +   personel_dil_bilgisi_dil_id_personel_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.personel_dil_bilgisi
    ADD CONSTRAINT personel_dil_bilgisi_dil_id_personel_id_key UNIQUE (dil_id, personel_id);
 j   ALTER TABLE ONLY public.personel_dil_bilgisi DROP CONSTRAINT personel_dil_bilgisi_dil_id_personel_id_key;
       public         postgres    false    429    429    429            �           2606    217877    personel_dil_bilgisi_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.personel_dil_bilgisi
    ADD CONSTRAINT personel_dil_bilgisi_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.personel_dil_bilgisi DROP CONSTRAINT personel_dil_bilgisi_pkey;
       public         postgres    false    429    429            �           2606    217965    personel_karti_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.personel_karti
    ADD CONSTRAINT personel_karti_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.personel_karti DROP CONSTRAINT personel_karti_pkey;
       public         postgres    false    443    443            U           2606    50218    personel_servis_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.personel_tasima_servis
    ADD CONSTRAINT personel_servis_pkey PRIMARY KEY (id);
 U   ALTER TABLE ONLY public.personel_tasima_servis DROP CONSTRAINT personel_servis_pkey;
       public         postgres    false    225    225            W           2606    50220 $   personel_tasima_servis_servis_no_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.personel_tasima_servis
    ADD CONSTRAINT personel_tasima_servis_servis_no_key UNIQUE (servis_no);
 e   ALTER TABLE ONLY public.personel_tasima_servis DROP CONSTRAINT personel_tasima_servis_servis_no_key;
       public         postgres    false    225    225            �           2606    123125 *   quality_form_mail_reciever_mail_adresi_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.quality_form_mail_reciever
    ADD CONSTRAINT quality_form_mail_reciever_mail_adresi_key UNIQUE (mail_adresi);
 o   ALTER TABLE ONLY public.quality_form_mail_reciever DROP CONSTRAINT quality_form_mail_reciever_mail_adresi_key;
       public         postgres    false    305    305            �           2606    123123    quality_form_mail_reciever_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.quality_form_mail_reciever
    ADD CONSTRAINT quality_form_mail_reciever_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.quality_form_mail_reciever DROP CONSTRAINT quality_form_mail_reciever_pkey;
       public         postgres    false    305    305            ]           2606    50222    recete_hammadde_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.recete_hammadde
    ADD CONSTRAINT recete_hammadde_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.recete_hammadde DROP CONSTRAINT recete_hammadde_pkey;
       public         postgres    false    228    228            _           2606    50224 '   recete_hammadde_stok_kodu_header_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.recete_hammadde
    ADD CONSTRAINT recete_hammadde_stok_kodu_header_id_key UNIQUE (stok_kodu, header_id);
 a   ALTER TABLE ONLY public.recete_hammadde DROP CONSTRAINT recete_hammadde_stok_kodu_header_id_key;
       public         postgres    false    228    228    228            Y           2606    50226    recete_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.recete DROP CONSTRAINT recete_pkey;
       public         postgres    false    227    227            [           2606    50228    recete_recete_adi_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_recete_adi_key UNIQUE (recete_adi);
 F   ALTER TABLE ONLY public.recete DROP CONSTRAINT recete_recete_adi_key;
       public         postgres    false    227    227            c           2606    50230    satis_fatura_detay_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.satis_fatura_detay
    ADD CONSTRAINT satis_fatura_detay_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.satis_fatura_detay DROP CONSTRAINT satis_fatura_detay_pkey;
       public         postgres    false    232    232            a           2606    50232    satis_fatura_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.satis_fatura
    ADD CONSTRAINT satis_fatura_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.satis_fatura DROP CONSTRAINT satis_fatura_pkey;
       public         postgres    false    231    231            g           2606    50234    satis_irsaliye_detay_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.satis_irsaliye_detay
    ADD CONSTRAINT satis_irsaliye_detay_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.satis_irsaliye_detay DROP CONSTRAINT satis_irsaliye_detay_pkey;
       public         postgres    false    236    236            e           2606    50236    satis_irsaliye_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.satis_irsaliye
    ADD CONSTRAINT satis_irsaliye_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.satis_irsaliye DROP CONSTRAINT satis_irsaliye_pkey;
       public         postgres    false    235    235            k           2606    50238    satis_siparis_detay_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.satis_siparis_detay
    ADD CONSTRAINT satis_siparis_detay_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.satis_siparis_detay DROP CONSTRAINT satis_siparis_detay_pkey;
       public         postgres    false    240    240            i           2606    50240    satis_siparis_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.satis_siparis
    ADD CONSTRAINT satis_siparis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.satis_siparis DROP CONSTRAINT satis_siparis_pkey;
       public         postgres    false    239    239            �           2606    184839    satis_teklif_detay_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.satis_teklif_detay
    ADD CONSTRAINT satis_teklif_detay_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.satis_teklif_detay DROP CONSTRAINT satis_teklif_detay_pkey;
       public         postgres    false    403    403            �           2606    184756    satis_teklif_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_pkey;
       public         postgres    false    401    401            �           2606    96461 
   sehir_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.sehir DROP CONSTRAINT sehir_pkey;
       public         postgres    false    270    270            �           2606    96463    sehir_sehir_adi_ulke_adi_key 
   CONSTRAINT     l   ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_sehir_adi_ulke_adi_key UNIQUE (sehir_adi, ulke_adi);
 L   ALTER TABLE ONLY public.sehir DROP CONSTRAINT sehir_sehir_adi_ulke_adi_key;
       public         postgres    false    270    270    270            #           2606    134033    stok_grubu_grup_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.stok_grubu
    ADD CONSTRAINT stok_grubu_grup_key UNIQUE (grup);
 H   ALTER TABLE ONLY public.stok_grubu DROP CONSTRAINT stok_grubu_grup_key;
       public         postgres    false    337    337            %           2606    134031    stok_grubu_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.stok_grubu
    ADD CONSTRAINT stok_grubu_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.stok_grubu DROP CONSTRAINT stok_grubu_pkey;
       public         postgres    false    337    337                       2606    133963    stok_grubu_turu_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.stok_grubu_turu
    ADD CONSTRAINT stok_grubu_turu_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.stok_grubu_turu DROP CONSTRAINT stok_grubu_turu_pkey;
       public         postgres    false    335    335            !           2606    133965    stok_grubu_turu_tur_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.stok_grubu_turu
    ADD CONSTRAINT stok_grubu_turu_tur_key UNIQUE (tur);
 Q   ALTER TABLE ONLY public.stok_grubu_turu DROP CONSTRAINT stok_grubu_turu_tur_key;
       public         postgres    false    335    335            �           2606    103362    stok_hareketi_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.stok_hareketi
    ADD CONSTRAINT stok_hareketi_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.stok_hareketi DROP CONSTRAINT stok_hareketi_pkey;
       public         postgres    false    278    278            '           2606    134155    stok_karti_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.stok_karti
    ADD CONSTRAINT stok_karti_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.stok_karti DROP CONSTRAINT stok_karti_pkey;
       public         postgres    false    339    339            )           2606    134157    stok_karti_stok_kodu_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.stok_karti
    ADD CONSTRAINT stok_karti_stok_kodu_key UNIQUE (stok_kodu);
 M   ALTER TABLE ONLY public.stok_karti DROP CONSTRAINT stok_karti_stok_kodu_key;
       public         postgres    false    339    339            m           2606    50258    stok_tipi_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.stok_tipi
    ADD CONSTRAINT stok_tipi_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.stok_tipi DROP CONSTRAINT stok_tipi_pkey;
       public         postgres    false    243    243            o           2606    50260    stok_tipi_tip_is_default_key 
   CONSTRAINT     l   ALTER TABLE ONLY public.stok_tipi
    ADD CONSTRAINT stok_tipi_tip_is_default_key UNIQUE (tip, is_default);
 P   ALTER TABLE ONLY public.stok_tipi DROP CONSTRAINT stok_tipi_tip_is_default_key;
       public         postgres    false    243    243    243            q           2606    50262    stok_tipi_tip_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.stok_tipi
    ADD CONSTRAINT stok_tipi_tip_key UNIQUE (tip);
 E   ALTER TABLE ONLY public.stok_tipi DROP CONSTRAINT stok_tipi_tip_key;
       public         postgres    false    243    243            �           2606    103533 #   sys_application_settings_other_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_application_settings_other
    ADD CONSTRAINT sys_application_settings_other_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.sys_application_settings_other DROP CONSTRAINT sys_application_settings_other_pkey;
       public         postgres    false    280    280            �           2606    88225    sys_application_settings_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.sys_application_settings
    ADD CONSTRAINT sys_application_settings_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.sys_application_settings DROP CONSTRAINT sys_application_settings_pkey;
       public         postgres    false    260    260            �           2606    65754    sys_grid_col_color_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.sys_grid_col_color
    ADD CONSTRAINT sys_grid_col_color_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.sys_grid_col_color DROP CONSTRAINT sys_grid_col_color_pkey;
       public         postgres    false    254    254            �           2606    65756 -   sys_grid_col_color_table_name_column_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_grid_col_color
    ADD CONSTRAINT sys_grid_col_color_table_name_column_name_key UNIQUE (table_name, column_name);
 j   ALTER TABLE ONLY public.sys_grid_col_color DROP CONSTRAINT sys_grid_col_color_table_name_column_name_key;
       public         postgres    false    254    254    254            �           2606    65773    sys_grid_col_percent_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.sys_grid_col_percent
    ADD CONSTRAINT sys_grid_col_percent_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.sys_grid_col_percent DROP CONSTRAINT sys_grid_col_percent_pkey;
       public         postgres    false    256    256            �           2606    65775 /   sys_grid_col_percent_table_name_column_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_grid_col_percent
    ADD CONSTRAINT sys_grid_col_percent_table_name_column_name_key UNIQUE (table_name, column_name);
 n   ALTER TABLE ONLY public.sys_grid_col_percent DROP CONSTRAINT sys_grid_col_percent_table_name_column_name_key;
       public         postgres    false    256    256    256                       2606    65736    sys_grid_col_width_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.sys_grid_col_width
    ADD CONSTRAINT sys_grid_col_width_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.sys_grid_col_width DROP CONSTRAINT sys_grid_col_width_pkey;
       public         postgres    false    252    252            �           2606    65738 -   sys_grid_col_width_table_name_column_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_grid_col_width
    ADD CONSTRAINT sys_grid_col_width_table_name_column_name_key UNIQUE (table_name, column_name);
 j   ALTER TABLE ONLY public.sys_grid_col_width DROP CONSTRAINT sys_grid_col_width_table_name_column_name_key;
       public         postgres    false    252    252    252            �           2606    65802 -   sys_grid_col_width_table_name_sequence_no_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_grid_col_width
    ADD CONSTRAINT sys_grid_col_width_table_name_sequence_no_key UNIQUE (table_name, sequence_no);
 j   ALTER TABLE ONLY public.sys_grid_col_width DROP CONSTRAINT sys_grid_col_width_table_name_sequence_no_key;
       public         postgres    false    252    252    252            �           2606    103474 .   sys_grid_default_order_filter_key_is_order_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_grid_default_order_filter
    ADD CONSTRAINT sys_grid_default_order_filter_key_is_order_key UNIQUE (key, is_order);
 v   ALTER TABLE ONLY public.sys_grid_default_order_filter DROP CONSTRAINT sys_grid_default_order_filter_key_is_order_key;
       public         postgres    false    258    258    258            �           2606    88209 "   sys_grid_default_order_filter_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.sys_grid_default_order_filter
    ADD CONSTRAINT sys_grid_default_order_filter_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.sys_grid_default_order_filter DROP CONSTRAINT sys_grid_default_order_filter_pkey;
       public         postgres    false    258    258            �           2606    123159 <   sys_lang_data_content_lang_table_name_column_name_row_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_lang_data_content
    ADD CONSTRAINT sys_lang_data_content_lang_table_name_column_name_row_id_key UNIQUE (lang, table_name, column_name, row_id);
 |   ALTER TABLE ONLY public.sys_lang_data_content DROP CONSTRAINT sys_lang_data_content_lang_table_name_column_name_row_id_key;
       public         postgres    false    309    309    309    309    309            �           2606    123157    sys_lang_data_content_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.sys_lang_data_content
    ADD CONSTRAINT sys_lang_data_content_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.sys_lang_data_content DROP CONSTRAINT sys_lang_data_content_pkey;
       public         postgres    false    309    309            �           2606    123174 :   sys_lang_gui_content_lang_code_content_type_table_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_lang_gui_content
    ADD CONSTRAINT sys_lang_gui_content_lang_code_content_type_table_name_key UNIQUE (lang, code, content_type, table_name);
 y   ALTER TABLE ONLY public.sys_lang_gui_content DROP CONSTRAINT sys_lang_gui_content_lang_code_content_type_table_name_key;
       public         postgres    false    311    311    311    311    311            �           2606    123172    sys_lang_gui_content_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.sys_lang_gui_content
    ADD CONSTRAINT sys_lang_gui_content_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.sys_lang_gui_content DROP CONSTRAINT sys_lang_gui_content_pkey;
       public         postgres    false    311    311            {           2606    65804    sys_lang_language_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.sys_lang
    ADD CONSTRAINT sys_lang_language_key UNIQUE (language);
 H   ALTER TABLE ONLY public.sys_lang DROP CONSTRAINT sys_lang_language_key;
       public         postgres    false    250    250            }           2606    51766    sys_lang_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sys_lang
    ADD CONSTRAINT sys_lang_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sys_lang DROP CONSTRAINT sys_lang_pkey;
       public         postgres    false    250    250            �           2606    123143 #   sys_multi_lang_data_table_list_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_multi_lang_data_table_list
    ADD CONSTRAINT sys_multi_lang_data_table_list_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.sys_multi_lang_data_table_list DROP CONSTRAINT sys_multi_lang_data_table_list_pkey;
       public         postgres    false    307    307            �           2606    123145 -   sys_multi_lang_data_table_list_table_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_multi_lang_data_table_list
    ADD CONSTRAINT sys_multi_lang_data_table_list_table_name_key UNIQUE (table_name);
 v   ALTER TABLE ONLY public.sys_multi_lang_data_table_list DROP CONSTRAINT sys_multi_lang_data_table_list_table_name_key;
       public         postgres    false    307    307            w           2606    50264 #   sys_permission_source_group_id_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.sys_permission_source_group
    ADD CONSTRAINT sys_permission_source_group_id_pkey PRIMARY KEY (id);
 i   ALTER TABLE ONLY public.sys_permission_source_group DROP CONSTRAINT sys_permission_source_group_id_pkey;
       public         postgres    false    246    246            y           2606    50266 -   sys_permission_source_group_source_group_ukey 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_permission_source_group
    ADD CONSTRAINT sys_permission_source_group_source_group_ukey UNIQUE (source_group);
 s   ALTER TABLE ONLY public.sys_permission_source_group DROP CONSTRAINT sys_permission_source_group_source_group_ukey;
       public         postgres    false    246    246            s           2606    50268    sys_permission_source_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.sys_permission_source
    ADD CONSTRAINT sys_permission_source_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.sys_permission_source DROP CONSTRAINT sys_permission_source_pkey;
       public         postgres    false    245    245            u           2606    50270 %   sys_permission_source_source_code_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.sys_permission_source
    ADD CONSTRAINT sys_permission_source_source_code_key UNIQUE (source_code);
 e   ALTER TABLE ONLY public.sys_permission_source DROP CONSTRAINT sys_permission_source_source_code_key;
       public         postgres    false    245    245            �           2606    96494    sys_quality_form_number_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.sys_quality_form_number
    ADD CONSTRAINT sys_quality_form_number_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.sys_quality_form_number DROP CONSTRAINT sys_quality_form_number_pkey;
       public         postgres    false    272    272            �           2606    103476 &   sys_quality_form_number_table_name_key 
   CONSTRAINT        ALTER TABLE ONLY public.sys_quality_form_number
    ADD CONSTRAINT sys_quality_form_number_table_name_key UNIQUE (table_name);
 h   ALTER TABLE ONLY public.sys_quality_form_number DROP CONSTRAINT sys_quality_form_number_table_name_key;
       public         postgres    false    272    272            �           2606    123217    sys_user_access_right_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.sys_user_access_right
    ADD CONSTRAINT sys_user_access_right_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.sys_user_access_right DROP CONSTRAINT sys_user_access_right_pkey;
       public         postgres    false    315    315            �           2606    123219 /   sys_user_access_right_source_code_user_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_access_right
    ADD CONSTRAINT sys_user_access_right_source_code_user_name_key UNIQUE (source_code, user_name);
 o   ALTER TABLE ONLY public.sys_user_access_right DROP CONSTRAINT sys_user_access_right_source_code_user_name_key;
       public         postgres    false    315    315    315            �           2606    123254 #   sys_user_mac_address_exception_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_mac_address_exception
    ADD CONSTRAINT sys_user_mac_address_exception_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.sys_user_mac_address_exception DROP CONSTRAINT sys_user_mac_address_exception_pkey;
       public         postgres    false    317    317            �           2606    123256 7   sys_user_mac_address_exception_user_name_ip_address_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_mac_address_exception
    ADD CONSTRAINT sys_user_mac_address_exception_user_name_ip_address_key UNIQUE (user_name, ip_address);
 �   ALTER TABLE ONLY public.sys_user_mac_address_exception DROP CONSTRAINT sys_user_mac_address_exception_user_name_ip_address_key;
       public         postgres    false    317    317    317            �           2606    123201    sys_user_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sys_user DROP CONSTRAINT sys_user_pkey;
       public         postgres    false    313    313            �           2606    123203    sys_user_user_name_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_user_name_key UNIQUE (user_name);
 I   ALTER TABLE ONLY public.sys_user DROP CONSTRAINT sys_user_user_name_key;
       public         postgres    false    313    313            �           2606    96448 	   ulke_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.ulke
    ADD CONSTRAINT ulke_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.ulke DROP CONSTRAINT ulke_pkey;
       public         postgres    false    268    268            �           2606    96452    ulke_ulke_adi_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.ulke
    ADD CONSTRAINT ulke_ulke_adi_key UNIQUE (ulke_adi);
 @   ALTER TABLE ONLY public.ulke DROP CONSTRAINT ulke_ulke_adi_key;
       public         postgres    false    268    268            �           2606    96450    ulke_ulke_kodu_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.ulke
    ADD CONSTRAINT ulke_ulke_kodu_key UNIQUE (ulke_kodu);
 A   ALTER TABLE ONLY public.ulke DROP CONSTRAINT ulke_ulke_kodu_key;
       public         postgres    false    268    268            �           2606    123114    urun_kabul_red_nedeni_deger_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.urun_kabul_red_nedeni
    ADD CONSTRAINT urun_kabul_red_nedeni_deger_key UNIQUE (deger);
 _   ALTER TABLE ONLY public.urun_kabul_red_nedeni DROP CONSTRAINT urun_kabul_red_nedeni_deger_key;
       public         postgres    false    303    303            �           2606    123112    urun_kabul_red_nedeni_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.urun_kabul_red_nedeni
    ADD CONSTRAINT urun_kabul_red_nedeni_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.urun_kabul_red_nedeni DROP CONSTRAINT urun_kabul_red_nedeni_pkey;
       public         postgres    false    303    303                        2620    133775    audit    TRIGGER     }   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.cins_ozelligi FOR EACH ROW EXECUTE PROCEDURE public.audit();
 ,   DROP TRIGGER audit ON public.cins_ozelligi;
       public       postgres    false    325    506                       2620    133799    audit    TRIGGER     �   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.urun_kabul_red_nedeni FOR EACH ROW EXECUTE PROCEDURE public.audit();
 4   DROP TRIGGER audit ON public.urun_kabul_red_nedeni;
       public       postgres    false    303    506            !           2620    134040    audit    TRIGGER        CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.stok_grubu_turu FOR EACH ROW EXECUTE PROCEDURE public.audit();
 .   DROP TRIGGER audit ON public.stok_grubu_turu;
       public       postgres    false    506    335            %           2620    142426    audit    TRIGGER     �   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.ayar_barkod_hazirlik_dosya_turu FOR EACH ROW EXECUTE PROCEDURE public.audit();
 >   DROP TRIGGER audit ON public.ayar_barkod_hazirlik_dosya_turu;
       public       postgres    false    506    347            #           2620    142428    audit    TRIGGER     �   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.ayar_barkod_tezgah FOR EACH ROW EXECUTE PROCEDURE public.audit();
 1   DROP TRIGGER audit ON public.ayar_barkod_tezgah;
       public       postgres    false    343    506            $           2620    142429    audit    TRIGGER     �   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.ayar_barkod_urun_turu FOR EACH ROW EXECUTE PROCEDURE public.audit();
 4   DROP TRIGGER audit ON public.ayar_barkod_urun_turu;
       public       postgres    false    345    506            "           2620    142445    audit    TRIGGER     �   CREATE TRIGGER audit AFTER INSERT OR DELETE OR UPDATE ON public.ayar_barkod_serino_turu FOR EACH ROW EXECUTE PROCEDURE public.audit();
 6   DROP TRIGGER audit ON public.ayar_barkod_serino_turu;
       public       postgres    false    341    506                       2620    123128    delete_table_lang_content    TRIGGER     �   CREATE TRIGGER delete_table_lang_content AFTER DELETE ON public.ayar_personel_birim FOR EACH ROW EXECUTE PROCEDURE public.delete_table_lang_content();
 F   DROP TRIGGER delete_table_lang_content ON public.ayar_personel_birim;
       public       postgres    false    291    500                       2620    123129    delete_table_lang_content    TRIGGER     �   CREATE TRIGGER delete_table_lang_content AFTER DELETE ON public.ayar_personel_bolum FOR EACH ROW EXECUTE PROCEDURE public.delete_table_lang_content();
 F   DROP TRIGGER delete_table_lang_content ON public.ayar_personel_bolum;
       public       postgres    false    500    289                       2620    123130    delete_table_lang_content    TRIGGER     �   CREATE TRIGGER delete_table_lang_content AFTER DELETE ON public.ayar_personel_gorev FOR EACH ROW EXECUTE PROCEDURE public.delete_table_lang_content();
 F   DROP TRIGGER delete_table_lang_content ON public.ayar_personel_gorev;
       public       postgres    false    293    500                       2620    123131    delete_table_lang_content    TRIGGER     �   CREATE TRIGGER delete_table_lang_content AFTER DELETE ON public.ayar_stok_hareket_tipi FOR EACH ROW EXECUTE PROCEDURE public.delete_table_lang_content();
 I   DROP TRIGGER delete_table_lang_content ON public.ayar_stok_hareket_tipi;
       public       postgres    false    276    500            &           2620    217966    insert_after_personel_adsoyad    TRIGGER     �   CREATE TRIGGER insert_after_personel_adsoyad AFTER INSERT ON public.personel_karti FOR EACH ROW EXECUTE PROCEDURE public.personel_adsoyad();
 E   DROP TRIGGER insert_after_personel_adsoyad ON public.personel_karti;
       public       postgres    false    507    443                       2620    88196    sys_grid_col_width_table_notify    TRIGGER     �   CREATE TRIGGER sys_grid_col_width_table_notify AFTER INSERT OR DELETE OR UPDATE ON public.sys_grid_col_width FOR EACH ROW EXECUTE PROCEDURE public.table_notify();
 K   DROP TRIGGER sys_grid_col_width_table_notify ON public.sys_grid_col_width;
       public       postgres    false    252    499            '           2620    217967    update_after_personel_adsoyad    TRIGGER     �   CREATE TRIGGER update_after_personel_adsoyad AFTER UPDATE ON public.personel_karti FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE PROCEDURE public.personel_adsoyad();
 E   DROP TRIGGER update_after_personel_adsoyad ON public.personel_karti;
       public       postgres    false    443    507            �           2606    50300     alis_teklif_detay_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alis_teklif_detay
    ADD CONSTRAINT alis_teklif_detay_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.alis_teklif(id) ON UPDATE CASCADE ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.alis_teklif_detay DROP CONSTRAINT alis_teklif_detay_header_id_fkey;
       public       postgres    false    183    3327    184            �           2606    50305 !   alis_tsif_kur_alis_teklif_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alis_tsif_kur
    ADD CONSTRAINT alis_tsif_kur_alis_teklif_id_fkey FOREIGN KEY (alis_teklif_id) REFERENCES public.alis_teklif(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.alis_tsif_kur DROP CONSTRAINT alis_tsif_kur_alis_teklif_id_fkey;
       public       postgres    false    3327    187    183                       2606    142399     ayar_barkod_tezgah_ambar_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_barkod_tezgah
    ADD CONSTRAINT ayar_barkod_tezgah_ambar_id_fkey FOREIGN KEY (ambar_id) REFERENCES public.ambar(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 ]   ALTER TABLE ONLY public.ayar_barkod_tezgah DROP CONSTRAINT ayar_barkod_tezgah_ambar_id_fkey;
       public       postgres    false    189    343    3343                       2606    157619 1   ayar_efatura_evrak_tipi_cinsi_evrak_cinsi_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_cinsi_id_fkey FOREIGN KEY (evrak_cinsi_id) REFERENCES public.ayar_efatura_evrak_cinsi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 y   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi DROP CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_cinsi_id_fkey;
       public       postgres    false    367    369    3677            	           2606    157624 0   ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi
    ADD CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_fkey FOREIGN KEY (evrak_tipi_id) REFERENCES public.ayar_efatura_evrak_tipi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 x   ALTER TABLE ONLY public.ayar_efatura_evrak_tipi_cinsi DROP CONSTRAINT ayar_efatura_evrak_tipi_cinsi_evrak_tipi_id_fkey;
       public       postgres    false    365    3673    369            �           2606    103574 ,   ayar_efatura_istisna_kodu_fatura_tip_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_efatura_istisna_kodu
    ADD CONSTRAINT ayar_efatura_istisna_kodu_fatura_tip_id_fkey FOREIGN KEY (fatura_tip_id) REFERENCES public.ayar_efatura_fatura_tipi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 p   ALTER TABLE ONLY public.ayar_efatura_istisna_kodu DROP CONSTRAINT ayar_efatura_istisna_kodu_fatura_tip_id_fkey;
       public       postgres    false    3515    193    285                       2606    157678 )   ayar_fatura_no_serisi_fatura_seri_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_fatura_no_serisi
    ADD CONSTRAINT ayar_fatura_no_serisi_fatura_seri_id_fkey FOREIGN KEY (fatura_seri_id) REFERENCES public.ayar_irsaliye_fatura_no_serisi(id) ON UPDATE CASCADE ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.ayar_fatura_no_serisi DROP CONSTRAINT ayar_fatura_no_serisi_fatura_seri_id_fkey;
       public       postgres    false    375    371    3685            �           2606    50310 %   ayar_firma_tipi_detay_firma_tipi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_firma_tipi_detay
    ADD CONSTRAINT ayar_firma_tipi_detay_firma_tipi_fkey FOREIGN KEY (firma_tipi) REFERENCES public.ayar_firma_tipi(tip) ON UPDATE CASCADE ON DELETE RESTRICT;
 e   ALTER TABLE ONLY public.ayar_firma_tipi_detay DROP CONSTRAINT ayar_firma_tipi_detay_firma_tipi_fkey;
       public       postgres    false    203    3369    204            
           2606    157673 -   ayar_irsaliye_no_serisi_irsaliye_seri_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi
    ADD CONSTRAINT ayar_irsaliye_no_serisi_irsaliye_seri_id_fkey FOREIGN KEY (irsaliye_seri_id) REFERENCES public.ayar_irsaliye_fatura_no_serisi(id) ON UPDATE CASCADE ON DELETE CASCADE;
 o   ALTER TABLE ONLY public.ayar_irsaliye_no_serisi DROP CONSTRAINT ayar_irsaliye_no_serisi_irsaliye_seri_id_fkey;
       public       postgres    false    371    3685    373            �           2606    114944 !   ayar_personel_birim_bolum_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_personel_birim
    ADD CONSTRAINT ayar_personel_birim_bolum_id_fkey FOREIGN KEY (bolum_id) REFERENCES public.ayar_personel_bolum(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 _   ALTER TABLE ONLY public.ayar_personel_birim DROP CONSTRAINT ayar_personel_birim_bolum_id_fkey;
       public       postgres    false    291    3525    289                       2606    157742 (   ayar_stok_hareket_ayari_cikis_ayari_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_stok_hareket_ayari
    ADD CONSTRAINT ayar_stok_hareket_ayari_cikis_ayari_fkey FOREIGN KEY (cikis_ayari) REFERENCES public.ayar_modul_tipi(deger) ON UPDATE CASCADE ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.ayar_stok_hareket_ayari DROP CONSTRAINT ayar_stok_hareket_ayari_cikis_ayari_fkey;
       public       postgres    false    385    363    3667                       2606    157747 (   ayar_stok_hareket_ayari_giris_ayari_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ayar_stok_hareket_ayari
    ADD CONSTRAINT ayar_stok_hareket_ayari_giris_ayari_fkey FOREIGN KEY (giris_ayari) REFERENCES public.ayar_modul_tipi(deger) ON UPDATE CASCADE ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.ayar_stok_hareket_ayari DROP CONSTRAINT ayar_stok_hareket_ayari_giris_ayari_fkey;
       public       postgres    false    363    385    3667                       2606    131299    banka_subesi_banka_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.banka_subesi
    ADD CONSTRAINT banka_subesi_banka_id_fkey FOREIGN KEY (banka_id) REFERENCES public.banka(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.banka_subesi DROP CONSTRAINT banka_subesi_banka_id_fkey;
       public       postgres    false    262    3477    321                       2606    131314    banka_subesi_sube_il_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.banka_subesi
    ADD CONSTRAINT banka_subesi_sube_il_id_fkey FOREIGN KEY (sube_il_id) REFERENCES public.sehir(id) ON UPDATE CASCADE;
 S   ALTER TABLE ONLY public.banka_subesi DROP CONSTRAINT banka_subesi_sube_il_id_fkey;
       public       postgres    false    3493    270    321                       2606    133696    barkod_tezgah_ambar_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.barkod_tezgah
    ADD CONSTRAINT barkod_tezgah_ambar_id_fkey FOREIGN KEY (ambar_id) REFERENCES public.ambar(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 S   ALTER TABLE ONLY public.barkod_tezgah DROP CONSTRAINT barkod_tezgah_ambar_id_fkey;
       public       postgres    false    329    3343    189                       2606    131392    cins_ozelligi_cins_aile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cins_ozelligi
    ADD CONSTRAINT cins_ozelligi_cins_aile_id_fkey FOREIGN KEY (cins_aile_id) REFERENCES public.cins_ailesi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 W   ALTER TABLE ONLY public.cins_ozelligi DROP CONSTRAINT cins_ozelligi_cins_aile_id_fkey;
       public       postgres    false    325    323    3593                       2606    123274    doviz_kuru_para_birimi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.doviz_kuru
    ADD CONSTRAINT doviz_kuru_para_birimi_fkey FOREIGN KEY (para_birimi) REFERENCES public.para_birimi(kod) ON UPDATE CASCADE ON DELETE RESTRICT;
 P   ALTER TABLE ONLY public.doviz_kuru DROP CONSTRAINT doviz_kuru_para_birimi_fkey;
       public       postgres    false    3483    319    266            �           2606    50345    recete_hammadde_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recete_hammadde
    ADD CONSTRAINT recete_hammadde_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.recete(id) ON UPDATE RESTRICT ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.recete_hammadde DROP CONSTRAINT recete_hammadde_header_id_fkey;
       public       postgres    false    227    228    3417            �           2606    50350    recete_hammadde_recete_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.recete_hammadde
    ADD CONSTRAINT recete_hammadde_recete_id_fkey FOREIGN KEY (recete_id) REFERENCES public.recete(id) ON UPDATE CASCADE ON DELETE SET NULL;
 X   ALTER TABLE ONLY public.recete_hammadde DROP CONSTRAINT recete_hammadde_recete_id_fkey;
       public       postgres    false    228    227    3417            �           2606    50365 !   satis_fatura_detay_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_fatura_detay
    ADD CONSTRAINT satis_fatura_detay_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.satis_fatura(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.satis_fatura_detay DROP CONSTRAINT satis_fatura_detay_header_id_fkey;
       public       postgres    false    3425    231    232            �           2606    50370 #   satis_irsaliye_detay_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_irsaliye_detay
    ADD CONSTRAINT satis_irsaliye_detay_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.satis_irsaliye(id) ON UPDATE CASCADE ON DELETE CASCADE;
 b   ALTER TABLE ONLY public.satis_irsaliye_detay DROP CONSTRAINT satis_irsaliye_detay_header_id_fkey;
       public       postgres    false    236    3429    235            �           2606    50375 "   satis_siparis_detay_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_siparis_detay
    ADD CONSTRAINT satis_siparis_detay_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.satis_siparis(id) ON UPDATE CASCADE ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.satis_siparis_detay DROP CONSTRAINT satis_siparis_detay_header_id_fkey;
       public       postgres    false    240    239    3433                       2606    184840 !   satis_teklif_detay_header_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif_detay
    ADD CONSTRAINT satis_teklif_detay_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.satis_teklif(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.satis_teklif_detay DROP CONSTRAINT satis_teklif_detay_header_id_fkey;
       public       postgres    false    403    401    3741                       2606    184782    satis_teklif_fatura_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_fatura_id_fkey FOREIGN KEY (fatura_id) REFERENCES public.satis_fatura(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_fatura_id_fkey;
       public       postgres    false    401    231    3425                       2606    184757 #   satis_teklif_gonderim_sekli_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_gonderim_sekli_id_fkey FOREIGN KEY (gonderim_sekli_id) REFERENCES public.ayar_efatura_gonderim_sekli(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_gonderim_sekli_id_fkey;
       public       postgres    false    3705    401    381                       2606    184762 "   satis_teklif_ihrac_kayit_kodu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_ihrac_kayit_kodu_fkey FOREIGN KEY (ihrac_kayit_kodu) REFERENCES public.ayar_efatura_ihrac_kayitli_fatura_sebebi(kod) ON UPDATE CASCADE ON DELETE RESTRICT;
 Y   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_ihrac_kayit_kodu_fkey;
       public       postgres    false    355    3655    401                       2606    184787    satis_teklif_irsaliye_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_irsaliye_id_fkey FOREIGN KEY (irsaliye_id) REFERENCES public.satis_irsaliye(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 T   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_irsaliye_id_fkey;
       public       postgres    false    401    235    3429                       2606    184767    satis_teklif_islem_tipi_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_islem_tipi_id_fkey FOREIGN KEY (islem_tipi_id) REFERENCES public.ayar_efatura_fatura_tipi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 V   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_islem_tipi_id_fkey;
       public       postgres    false    401    285    3515                       2606    184792    satis_teklif_musteri_kodu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_musteri_kodu_fkey FOREIGN KEY (musteri_kodu) REFERENCES public.hesap_karti(hesap_kodu) ON UPDATE CASCADE ON DELETE RESTRICT;
 U   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_musteri_kodu_fkey;
       public       postgres    false    299    401    3543                       2606    184772     satis_teklif_odeme_sekli_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_odeme_sekli_id_fkey FOREIGN KEY (odeme_sekli_id) REFERENCES public.ayar_efatura_odeme_sekli(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 W   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_odeme_sekli_id_fkey;
       public       postgres    false    3715    401    387                       2606    184802    satis_teklif_para_birimi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_para_birimi_fkey FOREIGN KEY (para_birimi) REFERENCES public.para_birimi(kod) ON UPDATE CASCADE ON DELETE RESTRICT;
 T   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_para_birimi_fkey;
       public       postgres    false    401    266    3483                       2606    184807    satis_teklif_siparis_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_siparis_id_fkey FOREIGN KEY (siparis_id) REFERENCES public.satis_siparis(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 S   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_siparis_id_fkey;
       public       postgres    false    401    239    3433                       2606    184812 !   satis_teklif_teklif_durum_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_teklif_durum_id_fkey FOREIGN KEY (teklif_durum_id) REFERENCES public.ayar_teklif_durum(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 X   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_teklif_durum_id_fkey;
       public       postgres    false    3739    399    401                       2606    184777 !   satis_teklif_teslim_sarti_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.satis_teklif
    ADD CONSTRAINT satis_teklif_teslim_sarti_id_fkey FOREIGN KEY (teslim_sarti_id) REFERENCES public.ayar_efatura_teslim_sarti(id) ON UPDATE CASCADE ON DELETE RESTRICT;
 X   ALTER TABLE ONLY public.satis_teklif DROP CONSTRAINT satis_teklif_teslim_sarti_id_fkey;
       public       postgres    false    3735    397    401            �           2606    96464    sehir_ulke_adi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_ulke_adi_fkey FOREIGN KEY (ulke_adi) REFERENCES public.ulke(ulke_adi) ON UPDATE CASCADE ON DELETE RESTRICT;
 C   ALTER TABLE ONLY public.sehir DROP CONSTRAINT sehir_ulke_adi_fkey;
       public       postgres    false    268    270    3489            �           2606    50400    stok_tipi_tip_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stok_tipi
    ADD CONSTRAINT stok_tipi_tip_fkey FOREIGN KEY (tip) REFERENCES public.stok_tipi(tip) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stok_tipi DROP CONSTRAINT stok_tipi_tip_fkey;
       public       postgres    false    3441    243    243            �           2606    103595 <   sys_application_settings_other_varsayilan_alis_cari_kod_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_application_settings_other
    ADD CONSTRAINT sys_application_settings_other_varsayilan_alis_cari_kod_fkey FOREIGN KEY (varsayilan_alis_cari_kod) REFERENCES public.hesap(hesap_kodu) ON UPDATE CASCADE ON DELETE SET NULL;
 �   ALTER TABLE ONLY public.sys_application_settings_other DROP CONSTRAINT sys_application_settings_other_varsayilan_alis_cari_kod_fkey;
       public       postgres    false    3389    280    213            �           2606    103590 =   sys_application_settings_other_varsayilan_satis_cari_kod_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_application_settings_other
    ADD CONSTRAINT sys_application_settings_other_varsayilan_satis_cari_kod_fkey FOREIGN KEY (varsayilan_satis_cari_kod) REFERENCES public.hesap(hesap_kodu) ON UPDATE CASCADE ON DELETE SET NULL;
 �   ALTER TABLE ONLY public.sys_application_settings_other DROP CONSTRAINT sys_application_settings_other_varsayilan_satis_cari_kod_fkey;
       public       postgres    false    213    280    3389            �           2606    103600 -   sys_application_settings_system_language_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_application_settings
    ADD CONSTRAINT sys_application_settings_system_language_fkey FOREIGN KEY (sistem_dili) REFERENCES public.sys_lang(language) ON UPDATE CASCADE ON DELETE RESTRICT;
 p   ALTER TABLE ONLY public.sys_application_settings DROP CONSTRAINT sys_application_settings_system_language_fkey;
       public       postgres    false    250    3451    260            �           2606    123175    sys_lang_gui_content_lang_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_lang_gui_content
    ADD CONSTRAINT sys_lang_gui_content_lang_fkey FOREIGN KEY (lang) REFERENCES public.sys_lang(language) ON UPDATE CASCADE ON DELETE RESTRICT;
 ]   ALTER TABLE ONLY public.sys_lang_gui_content DROP CONSTRAINT sys_lang_gui_content_lang_fkey;
       public       postgres    false    3451    250    311            �           2606    50405 6   sys_permission_source_sys_permission_source_group_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_permission_source
    ADD CONSTRAINT sys_permission_source_sys_permission_source_group_fkey FOREIGN KEY (source_group_id) REFERENCES public.sys_permission_source_group(id) ON UPDATE CASCADE ON DELETE CASCADE;
 v   ALTER TABLE ONLY public.sys_permission_source DROP CONSTRAINT sys_permission_source_sys_permission_source_group_fkey;
       public       postgres    false    3447    246    245            �           2606    123220 &   sys_user_access_right_source_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_access_right
    ADD CONSTRAINT sys_user_access_right_source_code_fkey FOREIGN KEY (source_code) REFERENCES public.sys_permission_source(source_code) ON UPDATE CASCADE ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.sys_user_access_right DROP CONSTRAINT sys_user_access_right_source_code_fkey;
       public       postgres    false    3445    245    315                        2606    123225 "   sys_user_access_right_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_access_right
    ADD CONSTRAINT sys_user_access_right_user_id_fkey FOREIGN KEY (user_name) REFERENCES public.sys_user(user_name) ON UPDATE CASCADE ON DELETE CASCADE;
 b   ALTER TABLE ONLY public.sys_user_access_right DROP CONSTRAINT sys_user_access_right_user_id_fkey;
       public       postgres    false    315    3575    313                       2606    123257 -   sys_user_mac_address_exception_user_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sys_user_mac_address_exception
    ADD CONSTRAINT sys_user_mac_address_exception_user_name_fkey FOREIGN KEY (user_name) REFERENCES public.sys_user(user_name) ON UPDATE CASCADE ON DELETE CASCADE;
 v   ALTER TABLE ONLY public.sys_user_mac_address_exception DROP CONSTRAINT sys_user_mac_address_exception_user_name_fkey;
       public       postgres    false    317    313    3575            �      x������ � �      �      x������ � �      �      x������ � �      �   )   x�3�,�tq�Ri�i\F@���)��oG� P(F��� �	      >   E   x�3�,�tr>�!D��1�3���[��?8�1ؓ�(�������rd�#��G'L�=... 
�      8      x�3�,�400s�ttQ�v
����� 8v      :       x�3�,��vvQ���q��4����� E�      <   $   x�3�,��u�=<Ǉ���p��utqq����� r��      L      x������ � �      l      x������ � �      n      x������ � �      j      x������ � �      B      x������ � �      D      x������ � �      H      x������ � �      R      x������ � �      P      x������ � �      T      x������ � �          O   x��K
�0�u�0���o4�!Q!�cx��U��\�J�`��AÕd�bj��?o>��wja��V,\o�,x; ?>�      J      x������ � �      `      x������ � �      F      x������ � �      �   �  x�}T�n�0<s�bOEr1�9�6�(�m�blzQ$:&bI-E7�_�#�a�2u�m��ݝ١�3,��X�j����T[���0������6c-���3�MX$>	lJ�����S��Lj�m+u��Z�P��Nbv;�8���sWH�8����]j�����e0r'��i���J������7��#x�Hݺ3�����6�U�o�~�����	zâ�+T��߶]k���l�j�y�v��I�#<�#��=����A[L��䘳� �A6��ń�1V;�B�m��3ݙ��v��;A2����ku��X��{�VOx���OQ���>��;q��b0<;ò���{�t��o���0K��G�N�ܮ����C���{�{e�6��K�<j�c����9^	�5O�$h�c�������c'�"�},����(��H4�l��>.���7��|:cS��x2����v0ZU���|�悹���7+�0�,�P} �C�-�{	1�F,�zc/��D)�YVV��[�9���Rkb�vTB2����I�"�}RR�bj3��:WT�����^�u��ኞU����=xE�7�}�P6>�+JRi���Jb�H���/�Q��J,�])�si�b���eCHb��6)0�X��E�9_�^�s�t��g<O_�g�H�w���Z#�90ec��Z��ʂ�.S\�F�%� �Y����k\/���Ʉ� �'��rU      �   �  x��Y�RI]�_�K������m���a�#�Y���H׋ȪRDiջ��^�4Ko��+v?�_2���zH`�^LL��mD�}�=�>�u��u��'NW�Q��7b������u,�c9Y߉K�p��+e"�_n#G�tf����$�ߓ�B�o��]����Q�iV�H\I3]߱��g�ٖ����4��LH�+}���u(��@�[Y��8-LGҬ����9�! F�d}�D�����8�!t_/c���ȝX߱	=6�oM�:��X.��|�8�g��\�p�D\�,��E�L���ӄ�5k賆�Հs��B͎D�3�c{k���t+�Y���96:�](6�L�=�W_�Rѽ�B�,䐄�ߑ6�z��UW�Rm���k���]��$lY��$V�$��#+	eJ�q��ɥ8+d#�<�m�:���&�1��D�(��H��Y���m�nR�h�)�
/�������)� ���E����8YW���EQ"��B�5�V#�Pf�������S�^�#[�������^�$F�)��y�I���S�I9�N�D6�Pp��ӊcy=+�e�^�l��R7�dJ�r���pSK�ǣФI�[#���F�g����]�T/��@��֜��xq��PD	hڜN��3�Q���^gҘb�d_LIA�����"&�ЊH�a2g�P�0;%���2+�D��)p������58i=��[0�Q�C*N��fu��$7�&ev!z�YO4 B�R\)C2����3]K\ �\�/�YN��d��H.�&m�#�s����K�pM/~>#=�-��B�`��D�\�X\�q�˪�(Ů��8��6��ΥW�e�E�s�aL�q�{�*T^�����L5' 3�-��B% ����_��[)��R^_��s;��X���
� ��R�I��(h��p&V�hj3�fYc���Fb R��fUa�P&�0�4�x�L�H�V	���z�sV3����X�~#V;��%���D/��:�|�B�e*L������rq����(+{�A��ַ�!��!�+���t��d�5�A�rH�BX���Q+9�a$J�����>s����C��.@2���悰N��Ɠ�Vj��i��1��G�����TڂՐ0J����9+��I�+�Z�뻙U[�(aiT�c�D� eb/]!=ЋX��@3��sn+V���J���D/T���NuI�OXQ�N$�F�U"�TD��d��Iw��b���PBt�O�������8�=ͦpf�����EX�eW�C0�0�x.�;�z��-�Q���]a]K(�	0OA���m�9$p�N[y��,�h�\Z�:)�	x��%�:��M�#�t���D<�P�L���=tA�:tN"�k�x�>���b@���3���)Ue�P�ɘ)���h>�2��& ���}�!+"�_p�0�ME�:�D&>DEF�h�.���s�۬��n<~��ov�_�:�0�~>a�GG�k�`

\��E?88p $'�Jg�+j�^Q3a�����kh�����H��G��$xlZ�+m)[	BZ�2�~l�c�
\�.6��E9E��i�(����G?tu���EzaeɈ(�Q��⭕Lo���e��:m6�e����o�\O�����V:��{�q�@n�b���D&�)y#�R�Ug�F��rۚnNdi4���r��v]�	�Kp-B���?��L�"��fOP�<�!u� t�ÑC>�WG�ض}�Oթ��G��E����h&اGC�W��+֦L����)S1{Գ�ClUũ�˩���
�`9�	]�#�U��>);�TI��x`A������8x��J�O[�FS[Y�Ϫ�jRM;�A����W�C<�"��޺ؘp���lA��H`����*l]6'Bc�؃�g�{ۋ�4�����NhP��B�^� �Ou�v�ٞě1�v���ɇ˽���?�������c{�^L�P����(��wl�M�|��W��z湚�2D��  �M���]�}d%\L��<c��h��������I��x�Rl��=��9�O�xb�r�)���~
0i4�#�7�o4pߕ�g��T��e�r�/�E��QJ#oo?�����=DV�ט���v`�2FDx�RK��a�}�&�t�,�S�^�w�3\iL�������Xl�c*xԒ��,�f�>c��3L�i�r�����qg��$���
^���~�Ij� ���C͜�Τs#[��g`a���#��P��=��=�i��G�l�/�Pp�?���5������A�?������JC�X��Pm�N񬖗�T:{�+�"�~���4q�n#;O)��R���jTk��y��È��c���R=܎����D��X2�:"�k�������	�v=�����<���x��.�^�k��1'�qAE>r���"��fI�j��ؽj�QJ����Fǀ��L�!%b���I깞&�oEf@�x�?�v���̥�`�'�N��36̵��?���DH�1`�bgt�+4�报*1o!�$��%)���!��?�/�wi��t4�����9X�9�.���`cۍo�Vؖ���~5�\q�0��|��er㺕;�z���(�ii��T��;��7���:�87�n�1��nD��0M�X�������������ls�b�I������R�u7z�
"GŔC)���@�08m��ȼ�&�^7�����&%�kq������1�Y����1_7��Giw$H��opc矻�49#�6��Aa�x��\I��;Qme���v�௒���{��i
R�3�-=�ql�w)Q�
����J�����z+��&%�<�:�f�]��0�����şsI@σ�X�ՌT�>@��D}/�̀A�}����E��#>�봇����q����w�^p�̛�oy]��?����9������ag�/��Fm��9�kژ�K{�/]��{�����Ì��"C�"�o}���2n7�΂�f"���G}��T�r��̎�7x1�T������wyΑSI5�\zKf��B�,$��2��il;Ds~���QV�]�Q���<��&5{9�e2u��2�V5���i��������,�t���#�w�sQ$�z�S��k��:����W9R�Z���G,���E�ՙ"%`�L&�Ѓs�*!PFS��y���&�,c�1޴���I�d��Z�*�31k���]��ƫ�O��p�սN�ΜV�gQ��
�_���Di�V(�<�� �>K�w�O �%�P�.%��O�F���K�(��%j�P485�F��P����&}�_�]�/`}�*FN�j�ڟ�D���0���7��j�9\���a�D.U�����u;�n�2������Λ�>�<�T�y��_4��U�:���J��X�Q��-W���:����*�(�4�8���0=I�:,�2֑�RN-i���X�z[QVo��.��wй�E�4���T��_�����N]��Hgh9\f��t�ܘ�7xucFVH怛%��<�O�taa�:�6]5�gF�֭�u�~v����/�W�Q      �     x�m��m�0��PD!�c��+��/���@9���p�����\��|�^3u�U\���X��S5�4�9ռN�%��Ѡ#��=h�>&��s���|�?�!Z� �������G�h��!�� I����[f%��Z�w��b(���<������ig���q#��I�v��F���M�ہ��f}����E�>��aJ���Vu�H�M\�sW�Q�؅� ��K2�xe{N]�W�p��r�Ș�ܝRf�.a�4�����j��yS��Y݋�      f      x������ � �      h      x������ � �      �   %   x�3�,��vt
��2��\]�������+W� o1L      �   �   x���M
1�u{��@�� �1P�΢�1<�x���̽���rt�{�#[�p/��3$��RP��JŐ�OƨrU	Z����y�22t��φ"0-HŒ�vstf�P�J[:ɴ����-�q@���[���^�|�o��K�i&      p      x������ � �      �   �  x��VKr�6]ӧ�2����Y˖	KHP���*�A��	f��J�3p�Uv���-��lSɦE��{�������0����
�6/�\���U�բ~��m��1^��gR:�g�*�a�-߽/ڦ �gFm��>��ڕ�j�j�]��	��Wq<�_������~=$�_��k<��(�%�,�c��9��@�d��cA4Xi�=X�p��N.l�R%��3՜�FB5�
2mcA�u�3y�ǖ܂^�L����)j�5�a�d2QPZr����&,a��"amu����� ��(A�;��D�[�e�ն��b*ӈ����p@*�}{�~&���i��;�+`m������Ey�G��K���L;(sA�G�T!!%�(@��e�*l�T ι|���X�����d=��%ch=�˹�fsm<��)c'��uʀ_(F�5�`mF�iG�y:{���vQ���H�w���8�8�֥S���a-/[n�-m3;PN�<|�N�2�ґ���y>����<��ϻ��xDi��-��0c�� ���^oP ���8������Րb�B���^yq���Pĕv���CY����6�IT<�8Ə�B��L��ň6H�z�~�s ���dO�aƙ��RG�@����g��v{�ȋ��t�X,�G\�.%�7)�k�F|;/L8�\�����=F?dO��'�,4�ѐٔG��ݱyѕ��"�<ж���V"�sx8��Ag��8�eMd ��_Y¡�6�[�h�gTuJ�z���n�q;�$R�W4�va���/�7t�g�'*���V�)񊊂�T�)������qM�B��I�yd>�'����$j]V�*���ױ{�$2.y�����_ו��´�Tq�d�$����ݿ̛d���+����_��~{������b      �   �  x��UKn�0]ӧ�ZA�$�c�QT��AQbt���AV���;H�W��R��HR$��ޛg�\�?l��L7�1�㖞Ε�dhxPd���xQ���,�K͇ǣP�')�xѼ�/�x�߬h��
H�pn��ΆG��e��
v�X���,fZ�7M�;�	�q�������6�U���~B�Ó���t� �9!��fx�wm�
�%YM��Y�4�,z�^Hp3�]&lG�$�;�B����D����cW��j�\v
%�t��TB�3���>����t���Y'� �i��ϤJ:��d�S����:�LY)�虪8t��N
g5���2�J)_����k��I}�w:���+�őp?��b��~hB���b�M^��K����s���&q�]��/�n&& C9o�g�O�3E7$I��Qf]��|v�4`6,�Ӝ�tW�����
(�G��5�[�o����̽TL����t-����A�f�B��9{S�r���YH�-�R�i��⨫@M�O䟚����>7 Y�	D��q�![��5?�����9pS��Nb�ƴğ7)���E8]G��!mc�D-�/l�<_����gy�	��/��˘5�P���e�����٦����#���a�ۖ�|�r�,�7�٣[VhpTxN���9�F���$�mW	в1��U������;Z,m�m#      Z      x������ � �      �   #   x�3�,�<:���3���v�u�t����� n��      �   X   x�3�,�tt9����<G�`.# �����;��7��1X����0&h�"�����e
�9��(��5���������qqq %�'      ^      x������ � �      �   _  x�]Q�n�0<�W �#y5�T�pjB���)Z�$�D�EU���G��Uh��3�;�Y��4Ǝ�0VAl˷��l�O�����s�}h��Sxi7�6x�����@5-"��-�_��F�*j�쭛�!%��חVQ�{��D\��" J M1ZZ�k�@�:&D��/*�P8����<��pƔ#�����W��d�k�H��v��ok�Q=*��O���9��r2�f����ԉ��;��1���Zx�;*��x���qrȁ0;)s%48�*��5Mc�*5��@8D/���K�x�tv��+tl�� 	a���<$������g +Q^Q��)Z�
�{�4�8��i      �      x�3�,�4�4B# 4bN�=... 4��      0   !   x�3�,�t�s�2�A�\�@:�ߏ+F��� V��      V      x������ � �      X      x������ � �      N   >   x�3�,�q��9�����>�!�1�Ȇ�󸌁�#������\&@��cHh�#W� K��      \      x������ � �      z   i   x�3�,�p=:��?�?�.#�������9~>��x+��z+nw���e���X$M�Zu�t,�@ț"��aUc��F���:s�CpXd��ق&����  �I�      @      x������ � �      �   3   x�3�,�t��2��|]<���l�PG7. #�����#�b���� 2��      �   g   x�3�,�tq�s�uU><'�5���#��sr�Sps�8�������@T�1P͑�!G6�9r��9G�)@�	qrt��sq�S8������������� +�.H         $   x�3�,�4�t������2�\�����=... x��         "   x�3�,�t:������#���q������ �"�      �      x�3�,�t�v��2��]<��b���� FL      �   3   x�3�,�<������#��]����>��~Ύ\�@vPh��vG�=... ^��      �   9   x�3�,����2�އ����ed��8r� G6D��e
dn��V�pc���� �~      ~      x������ � �      �   Q   x�̹�0��ð�m��e���u��I�����CL�`�,n�VN�5�ݢ�R�B��ȟ�����	���OE�=��cj         L   x�3�,�t�q�u��22}��p�s9�!���=:�Ս�"�rxN�)������ 1��8zE�q��qqq 6_      �   "   x�3�,�������22}�\�\C�b���� ]�      �   ;   x�3�,�tT�P��22� Lc�(�md@��0ź\f0ź\�pź\0ź\1z\\\ U�i      �       x�3�,�t�9����rr�v����� V2�      �   "   x�3�,�qu
:������t������ f��      �   !   x�3�,�tw�Rp�	�T�v��s������ K�u      �   ;   x�3�,�t���Rr�
�2���px���k�\��`� �`O�=... C�>      �   %   x�3�,�rV0�2������,c.(˄+F��� ���      �   z   x�U��� c�b+8��.'$#�`�\��q���%��7�7�8�G�hL<�8�b�F��d˲�d7��I�`֒	ޑ��KN&�}�jт+yC�<2'�����{���!�;��R���(�      |   (   x�3�,��u;�A!��ۑ���(�������� Ѭ	�      �   '   x�3�,�vt:�!���tq=2�Ȇ��]��b���� �c
j      b      x������ � �      d      x�3�,�<�!(���ȆHW$&W� ��
�      �   (   x�3�,�<����ytg�!��~dCБ@n	W� ���      r   M   x�3�,�tr<:��1��ϑ3Ə���(vdC@���oh �8�ptT�(���X�ގ��Pn� 2��      x   <   x�3�,�tw�s���
!��>G6�q�pe�]C ��c��_��iA0%G6 ��qqq �g�      
   ,   x�3�,��440�2�ALs.cȲ���,�=... ��;      �   -   x�3�,�twr�9�A�����1ؓ3$�����ݐ��+F��� ��	      $   $   x�3�,�4�41626��v��srv�4����� N�1      .      x������ � �      *      x������ � �      ,      x������ � �            x�3�,�tuw�4�4�-����� �%      �   %   x�3�,�
9��p��\FP����y�\1z\\\ �	?      &      x������ � �      (      x������ � �      "   )   x�3�,�420��50"��`N=#cS0����� �B�      �      x������ � �      �   +   x�3�,�t��t��q�2r�C�<c �����ĉ���� �
            x������ � �      �      x������ � �            x������ � �      �      x������ � �         .   x�3�,�ttq����0Ҹ��b��`td���{��/g	W� �      �   j   x�3�v�T�t�u:����O����1ȓ3�˘�54��Q�Nǰ�� G�#�|�l82��� � ����G6 Ur�� ��9<'�[�.�1ؓ��+F���  #�      �   Z   x�3�,�<�!8��7G.# ������U!�� ��#���B������sr�Sqrt��sq�S 	B�� �nw��<:���=... ��&      �      x������ � �      �      x������ � �      �   p   x�3�,B7� ��HO� O_NSSSCCC0���4�4�4�LK-�H,���I�,��5��0sH�M���K���qu���Z!�Ĉ���gB�W�[o����� i�$      �   2   x�3�,�4�p�s9��[������X����T���T����Ԭ�+F��� ۅ	t         .   x�3�,�LK-�H,���I�,��5��0sH�M���K������� ��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      t      x������ � �      v      x������ � �      �   Q   x�3�,�<�!8���)ԇ3�� �#"]9�M�L�R����=�<�d-�����|�lB�b�e� jprD7����� ��#      4      x������ � �      2   T   x�ǻ�0�:o
�/-�D�D�1�y���Q���lZ@C�iL��}�ǘ@S��#��f�o���+�Vg5ݸ��� �W'E      �      x���Q�,KNl�/�`��%�G�`|3��mV��K�KM�ԩ�+3������������'_�[������=���?���^k�����������������ݞ��wϿ��r��k݆;������
�����Z��:��������zh9|u�����<|���)�#�}�������m���7�O)^�ҋ2��RE��k*�O�6_���Ky��ׄ/emZ��	������_;|��W��:����/^��w�v������_;|��W��ݯ��ͫ���	_��տ}�넯~��߾�u�W�y�o��:�߼���~��{$����_O��7����_O��7����_O��7����_O������_O��������ë�����ë�����ë�����ë�����ë�����ë�����ë�����ë������W��ݯ/|�7�����P_�������������|����Y��x��/܀����~�_�[מ��Jo>���|[^�l��6ޯ��-�l�m�_+�e��6ޯ��=8�����jv؃�x�V�{p؃�x�ѥ�R��6ޯ�^�{p�QS���6ޯ��{p��J���=���k�����F~����=���k�7��=���k�W��=���k�w��=����L/�{p��Jo�{p��J��{p�>����F~P�=���k�7=���k�W=���k�w=x}%H/�/{p��Jo�/{p��J��/{p��J�/{p�|�×=���k�7×=���k�W×=��/3���_�_]s�����������������������������F.T��cn��Z��cn��Z��cn��Z��cn#W�������~�������~����E�6}|����~f7�'VzW�H�RUz]\?a�_�����Z�֪J/���6�J�\Ji۪J������^����O����+��.-��Wz]\zU_��O���J1��_����WDU�����f���',Ǣܪ
��f���ƦpSv,&�/�RU�:-W�	�\c�j�
v�������z�?]�e`��U1�5����U1�5���ު���Boy��k�2���ު��q��7Hnzy_�4S���W�˗��^ᗀ.�T���%���0��["�K��M�Dp�f�u3��/^��Jo�K�WI�����%�K3U�~	�Ҭ��W�%�K3U��~	��/Ʒ*���opZU�	�Ҭ�V���% L3U�M	�/�*��/�`��J��K0�f�U>��/a��Jo�KPX �V��%0L3U��	�,|�^�� 1�T�X��Ԩ*�K�(�����K��f!���K��f�ҿ,Ac��[��@��f���Lu�W�c����J �,�r���"�Lu�W�d����J�������K8Y@�VǷWe����B�-)����*�L3���UhY�VǷW�e���o��4S�^Ři�:ۀ���k�:���4�Lu|{=~��Qu|{o�����*�,Xv��۫�3�TǷW�g���o�b�4S�^���nu|{������*M3���U�f��۫P��୎o��ߜ�:��
H�Lu|{������*,-y��۫�4�TǷW�i���o���4S�^��?ou|{������*PM3���U��f�����1���o�"�4S�^�i�:���[�Lu|{�����U��f��۫ 6�TǷW1�%�}�$��
c,����*��ı�ķW��%�}�$����ox�T��^��7�fOz{-��^�-}����Io�%�]��}�Rx*�]��s����	h�LMz{-�W��[��^K�fj��k���LMz{-�W��Io�%�*�k��k-�=r�&����+�Ԥ��{�����Zb��޷&����+�Ԥ��{�����Zb�4S��^K�U�����{������~m��O�Zm	ܕ�����{#m�&~/��Lw�����i��Z�+o���S�7��]�wץ[�7ֲ·&~o��\w�5����[��Io��7��]oMz{-�W���֤��{�����Zb�4S��^����VMz{-�W�j�֤��{�����Zb�4S��^K�fj��k���1�&����+�Ԥ��{�����Zb�4S��^K�U���ݹ����^i�&����������Zb�4S��^K�U�d�ݺ����^i�&����+��ķW�W�K��M�D�U��һw�-{�����U�fjǷW�W���^�^��[;��n�c�v|{{�����U�fjǷW�W���w�ƷW�W���^�^i�v|{{�����U�U�<��;��W���^�^i�v|{{�������?G��۫�+�Ԏo�b�4S;�����L���*��_|����U�fjǷW�W���^�^i�v|{{կY>�n��+���?�-y�jǷ��{T;����ꗺ�v|{{�����U�fjǷW�W���^�^�+�[;�����L���*�J3��۫�+�Ԏo�b������^�^i�v|{}�!�W��۫�+�Ԏo�b������^�^i�v|{{�����U�fjǷW�W�2�֎o�b�4S;�����L���*�J3��۫ث~�k�����㦟j�����#�~��Io�-�J3u��k���L����b�4S'����+��Io�-�J3u��k���L����b�4S'����+��Io�-�J3u��k���L�����N^���^[�fꤷ�{��:����^i�Nz{m�W����^[�fꤷ�{��:����^i�Nz{m�W����^[�fꤷ�{��:����c/�Io�-�J3u��k���L����b�4S'����+��Io�-�J3u��k���L���b�4S'~Ɓr�Sx�A��?�'��Y��v�����=�U'~�z�Sx�A��?��'�:����~p���?�xB���tK���p뤷���x­��^[�fꤷ�{��:����^i�Nz{m�W����^{�h�Q����b�4S'����+��Io�-�J3u��k���L���*�J3u�۫�+���^�^i����*�J3�ķW�W��'�����L=��u�!*[�ķW�W��'�����L=��U�f�o�b�4SO|{{��z�۫�+���^�^i����*�J3�ķW�W��'�����L=����q;G�ķW�W��'�����L=��U�f�o�b�4SO|{{��z�۫�+���^�^i����*�Js�	閈���zC�L&m	�y�9������^�^i����*�J3�ķW�W��'�����L=��U�f�o�b�4SO|{{��z�۫�+���^�^i����]�������tK^?��U=��U�f�o�b�4SO|{{��z�۫�+���^�^i����*�J3�ķW���{^�ķW���{^�ķW���{^�ķW���{^����ao��Io�������7������=�붥��{��n[�%#�:z�k߶��ob�����mK�'�J3����{��z��눽�L���u�^i����:b�4Soz{�W��7�����ꍟ!�J3����{��z��눽�L���u�^i����:b�4Soz{�W��7����+�ԛ�^G�f�Mo�#�J3����{=:�nIz{��C$K����{��z��눽�L���u�^i����:b�4Soz{�W��7����+�ԛ�^G�f�Mo�#�J3����{��z��눽�L���uڏm՛�^G�f�Mo�#�J3����{��z��눽�L���u�^i����b�4So�Z?�v���7~�F�{^ym�<Z?�����H��������ci����=�vTo�lZ?�����z���������?����=����9�~P-�y��ƷW?������K�D�f�o�b�4S_|{{����۫�+���^�^i���������۫�+���^�^i����*�J3�ŷW�W��/�����L}��U�f�o�b�4S_|{{����۫�+���^�^i����z�����۫�+���^�^i����*�J3�ŷW�W��/�����L}��U�f�o�b�4S_|{{����۫�+���^�^i���������o�b�4S_|{{����۫�+���^�^i����*�J3�ŷW�W��/�����L}��U�f    �o�b�4S_|{{�������迪/�����L}��U�f�o�b�4S_|{{����۫�+���^�^i����*�J3�ŷW�W��/�����L}�eA[�/7-X��ض�n��[�ظ �J�֓tc��+�[�ҍ�¯to=K7�/��ҭψ�b� ,�[OӍ-"�to=�561�ҽ����� K�>��K��[�����-
K��5+���eE�Rݾt_�a����~�Uv��Mݾt_Db�n_�/B�tS��f�X,����/��n�X��ۗ�h,���K�E8�n����"K�>��K��[@�n����Rֺ�����"$K7u��}��[�.����-(K7�~�v��nI�ؗ�b��e�n_�/�t���j�f�n_�/"�tS�^n��,���-@ڗۭOP����n��Zu��}����}���M�_z���t�3���h�n_�/"�tS�/�!Z��ۗ�-����/��nAZ��ۗ�(-���K�E��n����2�G�?��K��[��nj�һ�����}���Mݾt_�j��'a�uW��n����b�O(�zz}�/V���[Ƭ�|��Mc�tS��aӾ���Z�q�O9�U+��Y;�s
$��V��������c<�@���k�*��,���ҭ��&�-pK7�b����Z��l��M��J��n��'�c3����Z��lk�jņ�-|K7�bK���[���Me[ �njŶ�-�K7�bc�¥�Z��l��ҭOm��-�K7�b{�ť�Z��l��M��b��q����c��~�6|T+��m�\��ͶP.�Ԋ�f[,�n}2=6�m�\���Ͷh.�Ԋg[8�njŖ�-�K�>�ζ�.�Ԋmg[D�nj�Ƴ-�K7�b��~��|����|�u�Vl?ۢ�tS+6�ma]��[ж�.���lB��tS+��m�]��Ѷ����ؗ��+���<�%��
�n=Ѐ}�ﻢ�[O4`_����Y���V,I;?kT��i[Ҏ���C���#�{�TL<�}���=� Oz�=�G�5�R���.�ԊUiG|�nj�Z�#�K7�b��ߥ[�m��^G|�nj�f�#�K7�b��YV�.Պ�^G|�n=)"�{�]��۽��.�Ԋ�^G|�nj�~�#�K��M���.�Ԋ_G|�njŊ�#�K7�b��ߥ[OÈ%_G|��#�Wz�=e]s�V��:�t�����ߥ������.�ǲ�t_�w�>�}���#�K���+���]��ďX�u�w�>~���#�K7�b��ߥ�Z����ҭg��¯�V|�j�Ư#�K7�b��ߥ�Z����ҭ���ү#�K7�b��ߥ�Z�����M���u�w��sTb��ߥ�Z�����M�X�u�w�V��:c-���-�����M���u�w�V��:�tS+��]����X v�w�Vl ;�tS+V��]��;���.�z:M,;�tS+���]��k���.�Ԋ=`G|�n='��]������.�ԊU`G|�nj�.�#�K�������.�Ԋm`G|�nj�:�#�K7�b�ߥ[����`G|�nj�F�#�K7�b%�ߥ�Z���ҭ��R�#�K7�b+�ߥ�Z����M��v�w��s�b1�ߥ�Z����M�Xv�w�V�;�t�IJ����M��v�w�V�;�tS+���]���Xv�w�Vl;�tS+V��]��;�.�zZT,	;�tS+���]��k�.�Ԋ=aG|�n=�*��]����.�ԊUaG|�njŮ�#�K�����.�ԊmaG|�njź�#�K7�b_�ߥ[����aG|�nj�ư#�K7�be�#�K7�bg�#�K���K��]��[��]��k��]��{��]����X����M������M�X����M�����ҭ'���G|�nj���G|�nj���G|�nj���G|�n=K-�=�tS+6�=�tS+V�=�tS+v�=�t��m�D�ߥ�Z�E�ߥ�Z�F�ߥ�Z�G�ߥ[ϋ�Eb��.�ԊMb��.�ԊUb��.�Ԋ]b��.�zB],{�w�Vl{�w�V�{�w�V�{�w��3�b��#�K7�b��#�K7�b��#�K7�b��#�K���K��]��[��]��k��]��{��]��ܿX,����M��,����M�X-����M��-���ҭ'�r�G|�nj�v�G|�nj�z�G|�nj�~�G|�n=�0�=�tS+6�=�tS+V�=�tS+v�=�t�i��d�ߥ�Z�e�ߥ�Z�f�ߥ�Z�g�ߥ[�o�Ec��.�ԊMc��.�ԊUc��.�Ԋ]c��.�zbd,{�w�Vl{�w�V�{�w�V�{�w��3*c��#�K7�b��#�K7�b��#�K7�b��#�K���K��]��[��]��k��]��{��]���X<����M��<����M�X=����M��=���ҭ'��G|�nj���G|�nj���G|�nj���G|�n=k4�=�tS����/<�+��]��;��]��t�XB����M��B����M�XC����M��C���ҭ��"�G|�nj�&�G|�nj�*�G|�nj�.�G|�n=�5��=�tS+��=�tS+֑=�tS+��=�t뙱���ߥ�Z���ߥ�Z����}�H\�%���>z&.��w�w=�}��⻏��˾���W|��cqٗ�������\�XL���z0�/ܗW|�Փq��p_^��W��m��}y�w_=w���ߥ�Z���ߥ�Z���ߥ�Z���ߥ[���e��.�Ԋe��.�Ԋe��.�Ԋe��.�z�p,){�w�Vl){�w�V�){�w�V�){�w���cQ�+�K7�bS�+�K7�bU�+�K7�bW�+�K�����^�]����^�]����^�]����^�]���XX����M��X����M�XY����M��Y���ҭ�F�ҲW|�nj�ֲW|�nj�ڲW|�nj�޲W|�n=�:���tS+6���tS+V���tS+v���t��ر��ߥ�Z���ߥ�Z���ߥ�Z���ߥ[��f��.�Ԋf��.�Ԋf��.�Ԋf��.�z�w,1{�w�Vl1{�w�V�1{�w�V�1{�w����c��+�K7�b��+�K7�b��+�K7�b��+�K��p��^�]����^�]����^�]����^�]��L�Xh����M��h����M�Xi����M��i���ҭ���R�W|�nj�V�W|�nj�Z�W|�nj�^�W|�n=7>���tS+6���tS+V���tS+v���t�I����ߥ�Z���ߥ�Z���ߥ�Z���ߥ[�Əg��.�Ԋg��.�Ԋg��.�Ԋg��.�z,9{�w�Vl9{�w�V�9{�w�V�9{�w����c��+�K7�b��+�K7�b��+�K7�b��+�K�����ߥ�Z���ߥ�Z���ߥ�Z���ߥ[��Xx����M��x����M�Xy����M��y����-�B,={�w�Vl={�w�V�={�w�V�={�w��!���tS+6���tS+V�}�tS+v�}�t���>�]����>�]����>�]����>�]�媈h��.�Ԋh��.�Ԋh��.�Ԋh��.ݲc��O|�nj��O|�nj��O|�nj��O|�n�8b�'�K7�b�'�K7�b�'�K7�b�'�K� ��ߥ�Z��ߥ�Z��ߥ�Z��ߥ[ΑX�����M�؈����M�X�����M�؉����-�I,E��w�VlE��w�V�E��w�V�E��w�W%�}�tS+6�}�tS+V�}�tS+v�}�t����>�]����>�]����>�]����>�]�厉i��.�Ԋi��.�Ԋi��.�Ԋi��.ݲ�Ē�O|�njŖ�O|�njŚ�O|�njŞ�O|�n�qbQ�'�K7�bS�'�K7�bU�'�K7�bW�'�K��<�,�ߥ�Z�-�ߥ�Z�.�ߥ�Z�/�ߥ[�X�����M�ؘ����M�X�����M�ؙ����-�P,M��w�VlM��w�V�M��w�V�M��w��(�}�tS+6�}�tS+V�}�tS+v�}�tˬ��>�]����>�]����>�]����>�]��r�j��.�Ԋj��.�Ԋj��.��    �j��.ݲG��O|�nj��O|�nj��O|�nj��O|�n��b��'�K7�b��'�K7�b��'�K7�b��'�K�Y�L�ߥ�Z�M�ߥ�Z�N�ߥ�Z�O�ߥ[N�X�����M�ب����M�X�����M�ة����-X,U��w�VlU��w�V�U��w�V�U��w�w,�}�tS+6�}�tS+V�}⻟�j�K|����Uc_�����'���w�w?��ؗ��+3��jł����جFT�X�UM��Q�f�o�֟�-6��ɦ�vT,[�Ƿ[�Q�oMF7�nG�ʵ{�q�����5����8*���[_G��5����98���.o��k��lrѩu9*�����&)�۔ދe�Sk;*V����&��x]b�<xjݎ��l���I:��6�wdY���8*ֲ���&I�؆��&�Z?G�r���m�?�_�~6�Ժ+��qo�m�`li��O���X�v�{��i+�)�;�����X�v�{�$kc�cc�܃j}K��qo��m�6��h���9*V��Vo��m�y��m��u9*����&�ۚmJ�Բ&��k��qo�$n�)�Mnr.�u;*�����&�ܚmJ��26��qT�t�ǽM��%�������Q����z��OY��M�H�.G�z�{��$���bÛ\�jmGŒ�{��$�۰M�[�J�nGŪ�{��$��Gcۛ<�j}��qo�to�6�w��m��mئ���M@g}���orl�u9*�����&����d�Tk;*V����& �~f�8�=պ���qo�>��]p����qT���ǽM�uTl��[T���b)�m�6�?Ei�^8�Iպ���qo�)G�v8yM�ڎ�q������DŎ8YQպk��qo�Z?�cS���j}���qo?ˉ�}q2���sT�����&����5N>W�.G��{������'�Z�Q�>��6�u�rrɪu;*����ަ�8*���D���Q�J��6=��b��<�j��n������V씓W��Q�V��6���,'��Z�Q�\��6qG#*��������X1w�{� ܺ�Ŗ9�{��8*����&n�DŮ9���9*���Vo�[7��8'w�Z��b��=�m�>JT읓yX���X=w�{� ߺ���9y�պ��qo�w;�d=V��XCw�{���Q��N�d�~��et�Uۤ�7Q��N�e�.G�J�{��Z���J'_�Z�Q����nG�n:ٞպ����ǭ�O��V��XRw�n}{�d�V��XUw[�M�p�=%���S���XXwO{���JT쬓�Z���X[w�{�`���Ql��#[��Q����6���_'öZG�
�{�۴�?Qwl���[���b��m�6՟�b����j]��uv�����O��Wk;*�����&6���k'��Z��b��=�m����N^r�>��w����?/DŎ;Y���9*���Vo,\�Mwr��u9*�����&����dTWk;*V����&X���[��cW�vT,��ǽM}��dsW��Xw�{������<����9*���Vo��)�+���$���X�w�{������Oz���b!�=�m�� Q�O{�nG�Z�{��͈�xk��3AQ���6�ݗ�؏��Y8+����6���PbK�Zf�LPT,ʻ�����|�bW�Zf�LPT����u��2g��bi����&~�{��2g��bu����&X�xQl�[�,�	��z�����7�b��Zf�LPT�ѻǽM�pQ�ؤ��Y8���qo?U��}zk��3AQ�R��6����b��Zf�LPT,ֻǽM�,'*v�e�E�z���m����ņ�����X�w�{��A{��2g��b��=�m���ƶ�����X�w�{���;��2g��b��=�m���>�潵���X�w[�Mܖ���{k��3AQ����6���<c�Zf�LPT,�ǽM�ш�]|k��3AQ����6��EZc#�Zf�LPT,�ǽM����|k��3AQ���z�`�⻱�o-�p&(*����&�DŎ�����X�w�{�`�ʱ�o-�p&(*�����&n�Dž�����X�w�{�`�bٱ�o�Y8��n��I���ݷ�,�	���}�x���V��3AQ����nG��Uf�LPT����G�6�Uf�LPT,���?�����~����X�w[�M�p�� 6��2g��b��=�m�+Q��o�Y8+��qo,\���-����X�w�{�x5��]����X�w�{�`���Hl�[e�E�ҿ��mb��������X�w�{�`��}Ll�[e�E��{����; W��3AQ���6���[����,�	��e�����?/D�>�Uf�LPT����&X�~�[W��3AQ���6񧔨���,�	�������	��xņ�Uf�LPT,	�ǽM|o *��2g��bU�=�m����l�-p�Y8o����HD���Uf�LPT��ǽM�p�v/6�2g��by�=�m�� Q�?p�Y8+�qo,\�S�-�����X$x�{���KT�\e�E�:���m���7��Qp�Y8K�qo�󉊽�����X-x�{�`���il\e�Eł�{���O�b��*�p&(*����&X�~k�W��3AQ�l�z���FT�\e�E���{����c��*�p&(*���&~��W��3AQ�~��6�����@��,�	��%�������D��Uf�LPT�"���&X�~/�W��3AQ����6q� *v�2g��b-�=�m����p�Y8�	�qo��b?�*�p&(j�p�p&(*��2g��bQ�m�6q["*v�2g��b]�=�m�����p�Y8K�qow4�bo�*�p&(*V���&X����W��3AQ����6q3$*v�2g��b��m�6���.��d��,�	��e������(Q��p�Y8+�qo,\�툭�����Xlx�{���W��3AQ����6������p��,�	��%��Uۤ��{W��3AQ���o���b��j�p&(*��ۭ��y��,�	����������|��,�	��������Q��p�Y8+o��	������f�LPT,B�ǽM�s%*v!�6g��b�=�m���B�q�Y8K�qo�&Q�q�Y8��qo,\�O�툫���X�x[�M�Q�#q�Y8k�qo,\M�����X�x�{��\�b_�j�p&(*V&���&X�ދ[W��3AQ�8��6�煨؝��,�	��������;�b��j�p&(*�(���&��{W��3AQ�J��6�����ئ��,�	���������D�N��f�LPT�U�ǽM�p��-6+�6g��b��m�6���د��,�	������	���Ŗ��f�LPT,Z�ǽM|$*v-�6g��b��=�m���}�qq�Y8K�qo�}��������X�x[�M�p��0�/�6g��b�=�m�{>Q��q�Y8k�qo,\�b�M�����X�x�{��ICT�c\m�E�J�{���{'c+�j�p&(*3�Vo?߈�݌����X�x�{�`�z�flh\m�EŒ�{���OU�bO�j�p&(*V5���&X��'�W��3AQ����6񳜨�ٸ�,�	�������׻Scs�j�p&(*�7���&nD����f�LPT�p�ǽM�p�'6�8�6g��b��=�m��BT�r\m�E�:�{���;qc��j�p&(*�:�Vo�%�b��j�p&(*V;���&X����W��3AQ����6qG#*v<�6g��b��=�m���]Ǳ�q�Y8��qo7C�b��j�p&(*V>�Vo,\�u�������X�x�{����W��3AQ����6����� ��,�	��%�����[0Q�r�Y8� �qo,\��m�k���Xy[�Mz78Q�r�Y8k!��vk9*6C�1g��b9�=��:����k���Xy�?n=��-�k���Xy�n}�"ט�3AQ�.�z�`�z�|l�\c�E���{���?W�bo��p&(*VG���&X�ޯ�#ט�3AQ�@��6�j;$ט�3AQ�F��    6���)��$��,�	��e������$ט�3AQ�R��6���ل�*��,�	��Œ�����%*vK�1g��b��=�m����ar�Y8K&�qo^��=�k���X5y[�M�p}#�M�1g��b��=�m�O)Q�sr�Y8k'�qo,\���͓k���X>y�{���@T�\c�E�
�{���gNb��p&(*Q�Voߑ��]�k���XGy�{�`���Kl�\c�E�R�{����A�b/��p&(*VS���&X�>_�)ט�3AQ����6�ݗ��Q��,�	��5����קzbS��p&(*�U���&���*ט�3AQ����6���Y��Z��,�	��ŕ�����4D���5f�LPT���ǽM�p}�)6X�1g��b��m�6���c��,�	��U����	��M�6�5f�LPT,��ǽM�T%*vZ�1g��b��=�m����Z��r�Y8�-�qo?ˉ���k���Xqy[�M�p}F,�\�1g��b��=�m�AT�\c�Eź�{���'�b���p&(*�^���&�-D���5f�LPT���ǽM�p}.�_�1g��b�m�6q["*v`�1g��b�=�m���Sx�	s�Y8�0�qow4�b��p&(*Vb���&X�>�[1ט�3AQ���6q3$*vc�1g��b=�m�6�����ؐ��,�	��%������(Q�'s�Y8�2�qo,\�s�m�k���X�y�{��;3ט�3AQ�6��6�����ܜ����ܝ�����L�sw�6g��sw�6g��sw�6g��sw�6�'A��ݙ�,�	��ݙ�,�	��ݙ�,�	��ݙ�,\�?%:wgn�p&(nk�Mf�LPt���f�LPt���f���+ѹ;s��3Aѹ;s��3Aѹ;s��3Aѹ;s��볶D���m�E���m�E���m�E���m�O���3�Y8��3�Y8��3�Y8��3�Y�>WLt���f�LPt���f�LPt���f�LPt���f��43ѹ;s��3Aѹ;s��3Aѹ;s��3Aѹ;s���3�D���m�E���m�E���m�E���m�On��3�Y8��3�Y8��3�Y8��3�Y�>/Nt���f�LPt���f�LPt���f�LPt���f���:ѹ;s��3Aѹ;s��3Aѹ;s��3Aѹ;s����D���m�E���m�E���m�E���m�O���3�Y8��3�Y8�/E���m�E���m�� ��3�Y8��3�Y8��3�Y8��3�Y��>@t���f�LPt���f�LPt���f�LPt���f�z�ѹ;s��3Aѹ;s��3Aѹ;s��3Aѹ;s���ID���m�E���m�E���m�E���m��;��3�Y8��3�Y8��3�Y8��3�Y��*At���f�LPt���f�LPt���f�LPt���f�z�ѹ;s��3Aѹ;s��3Aѹ;s��3Aѹ;s���	D���m�E���m�E���m�E���m��v��3�Y8��3�Y8��3�Y8��3�Y��Bt���f�LPt���f�LPt���f�LPt���f�zF	ѹ;s��3Aѹ;s��3Aѹ;�3Aѹ;���(D���c�E���c�E���c�E���c����3�Y8��3�Y8��3�Y8��3�Y��Ct��<f�LPt��<f�LPt��<f�LPt��<f�z�ѹ;�3Aѹ;�3Aѹ;�3Aѹ;��7D���c�E���c�E���c�E���c�����3�Y8��3�Y8��3�Y8��3�Y���Ct��<f�LPt��<f�LPt��<f�LPt��<f�z�ѹ;�3Aѹ;�3Aѹ;�3Aѹ;��IFD���c�E���c�E���c�E���c��'��3�Y8��3�Y8��3�Y8��3�Y���Dt��<f�LPt��<f�LPt��<f�LPt��<f�zVѹ;�3Aѹ;�3Aѹ;�3Aѹ;��	UD���c�E���c�E���c�E���c��b��3�Y8��3�Y8��3�Y8��3�Y���Et��<f�LPt��<f�LPt��<f�LPt��<f�zѹ;�3Aѹ;�3Aѹ;�3Aѹ;���cD���c�E���c�E���c�E���c����3�Y8��3�Y8��3�Y8��3�Y���Ft��<f�LPt��<f�LPt��<f�LPt��<f�z�ѹ;�3Aѹ;�3Aѹ;�3Aѹ;��rD���c�E���c�E���c�E���c�����3�Y8��3�Y8��3�Y8��3�Y���Gt��<f�LPt��<f�LPt��<f�LPt��<f�zfѹ;�3Aѹ;�3Aѹ;�3Aѹ;��I�D���c�E���c�E����,�	��ݙ�Y��OHt��|���ܝ���3Aѹ;�1g��sw�c��"��3�p&(:wg>f�LPt��|���ܝ����Y�D����,�	��ݙ�Y8��3�p&(:wg>f�z$ѹ;�1g��sw�c�E����,�	��ݙ�Y��;It��|���ܝ���3Aѹ;�1g��sw�c��]��3�p&(:wg>f�LPt��|���ܝ�����D����,�	��ݙ�Y8��3�p&(:wg>f�z�'ѹ;�1g��sw�c�E����,�	��ݙ�Y��'Jt��|���ܝ���3Aѹ;�1g��sw�c�����3�p&(:wg>f�LPt��|���ܝ����٩D����,�	��ݙ�Y8��3�p&(:wg>f�zb+ѹ;�1g��sw�c�E����,�	��ݙ�Y��Kt��|���ܝ���3Aѹ;�1g��sw�c�����3�p&(:wg>f�LPt��|���ܝ���뙸D����,�	��ݙ�Y8��3�p&(:wg>f�z/ѹ;�1g��sw�c�E����,�	��ݙ�Y���Kt��|���ܝ���3Aѹ;�1g��sw�c����3�p&(:wg>f�LPt��|���ܝ����Y�D����,�	��ݙ�Y8��3�p&(:wg>f�z�2ѹ;�1g��w~7g��sw�c�E����,\�u&:wg>f�LPt��|���ܝ���3Aѹ;�1�Ӥ��ݙ�Y8��3�p&(:wg>f�LPt��|���k�sw�c�E����,�	��ݙ�Y8��3�p=9��ܝ���3Aѹ;�1g��sw�c�E����,\��&:wg>f�LPt��|���ܝ���3Aѹ;�5�S�ݙ�Y8��3_�p&(:wg�f�LPt��|���lr�sw�k�E����,�	��ݙ�Y8��3_�p=��ܝ���3Aѹ;�5g��sw�k�E����,\�a':wg�f�LPt��|���ܝ���3Aѹ;�5��߉�ݙ�Y8��3_�p&(:wg�f�LPt��|����y�sw�k�E����,�	��ݙ�Y8��3_�p=��ܝ���3Aѹ;�5g��sw�k�E����,\��':wg�f�LPt��|���ܝ���3Aѹ;�5�S���ݙ�Y8��3_�p&(:wg�f�LPt��|��� :wg�f�LPt��|���ܝ���3Aѹ;�5����ܝ���3Aѹ;�5g��sw�k�E����,\��sw�k�E����,�	��ݙ�Y8��3_�p���ݙ�Y8��3_�p&(:wg�f�LPt��|��� :wg�f�LPt��|���ܝ���3Aѹ;�5����ܝ���3Aѹ;�5g��sw�k�E����,\>�sw�k�E����,�	��ݙ�Y8��3_�pY8��ݙ�Y8��3_�p&(:wg�f�LPt��|���� :wg�f�LPt��|���ܝ���3Aѹ;�5�q��ܝ���3Aѹ;�5g��sw�k�E����,\��sw�k�E����,�	��ݙ�Y8��3_�p�U��ݙ�Y8��3_�p&(:wg�f�LPt��|���t!:wg�f�LPt��|���ܝ���3Aѹ;�5�I��ܝ���3Aѹ;�5g��sw�k�E����,\��sw�k�E����,�	��ݙ�Y8��3_�pYs��ݙ�Y8��3_�    p&(:wg~f�LPt�������!:wg~f�LPt������ܝ���3Aѹ;�3�!��ܝ���3Aѹ;�3g��sw�g�E����,\^"�sw�g�E����,�	��ݙ�Y8��3?�pِ��ݙ�Y8��3?�p&(:wg~f�LPt������`":wg~f�LPt������ܝ���3Aѹ;�3����ܝ���3Aѹ;�3g��sw�g�E����,\�)�sw�g�E����,�	��ݙ�Y8��3?�pY���ݙ�Y8��3?�p&(:wg~f�LPt�������":wg~f�LPt������ܝ���3Aѹ;�3�ы�ܝ���3Aѹ;�3g��sw�g�E����,\1�sw�g�E����,�	��ݙ�Y8��3?�p�ˈ�ݙ�Y8��3?�p&(:wg~f�LPt������L#:wg~f�LPt������ܝ���3Aѹ;�3����ܝ���3Aѹ;�3g��sw�g�E����,\~8�sw�g�E����,�	��ݙ�Y8��3?�pY��ݙ�Y8��3?�p&(:wg~f�LPt�������#:wg~f�LPt������ܝ���3Aѹ;�3����ܝ���3Aѹ;�3g��sw�g�E����,\�?�sw�g�E����,�	��ݙ�Y8��3?�p���ݙ�Y8��3?�p&(:wg~f�LPt������8$:wg~f�LPt������ܝ���3Aѹ;�3�Y��ܝ���3Aѹ;�3g��sw�g�E����,\>G�sw�g�E����,�	��ݙ�Y8��3?�pY$��ݙ�Y8��3?�p&(:wg~f�LPt������$:wg~f�LPt������؝Y?�p&(:vg�V�I�3�'�	��ݙ�x���3�'�	��ݙ��v�8&vg�O,\�3��ǭ�1�;�~bᚠ�؝y�n}�3�'�	��o��6���؝Y��mZ�1�;���ަU��ݙ�[ަՎ�ݙ���6��3뷼Mk;&vg��۴�cbw&��[�����oz�Xbbwf��۴>������m��cbwf���T�1�;��6�~���������1�;��6�8&vg֯�M��3�qoKOL�ά_y��qL�μǽM�:&vg֯�M�9&vg�VoԈ�ݙ�koS/����{����؝Y��6u;&vg���&���3��ަގ�ݙ�����cbwf���ԏcbw�=�m��
1�;�~�m��1�;�z���؝Y��6�rL�μǽM|3#&vg�o�Mӎ�ݙ���i�1�;�~�m��؝y�{��JL�ά�x��qL�μǽM�:&vg�o{��sL�μ��&�q�3뷽M{9&vg��ަ]��ݙ��ަݎ�ݙ���������mo�ގ�ݙ���i�����mo�~�3�qo?���ݙ�;ަ�9&vg�Vo��9&vg��x��rL�μǽM�h$&vg��x�N;&vg��ަ3��ݙ�;ަ��3�qo?���ݙ�;ަ�8&vg��ަ�:&vg���6��1�;�z���3��x���؝y�{��rL�ά��mz�1�;��6q� &vg���6=�1�;��6=�1�;�~���y�3�qoWbbwf�^o��9&vg�Vo��sL�ά��mz�cbw�=�m�EL�ά��mz�1�;��6��؝Y����n����{������؝Y����>��ݙ����}�3��y���1�;�z��T�3��y���؝y�{��rL�ά��m��1�;��6q�%&vg���6}�1�;��6}�1�;�~���{�3�qohbbwf������3o���	��ݙ����؝y��[�1�;��Y8�3����qL�άe�����{�q�qL�άe�����{�s��؝Y�,�	��ݙ����?bbwf-�p&(&vg���&X81�;��Y8�3�qo/	1�;��Y8�3�qo,��؝Y�,�	��ݙ����E &vg�2g�bbw�m�6��ݙ����؝y�{�X?bbwf-�p&(&vg���&X81�;��Y8�3�qoKOL�άe�����{��'&vg�2g�bbw�m�6�G��؝Y�,�	��ݙ���	NL�άe�����{���pbbwf-�p&(&vg���&X81�;��Y8�3�qo�V��ݙ����؝y[�M�pbbwf-�p&(&vg���&���3k��3A1�;��6��ݙ����؝y�{��JL�άe�����{��'&vg�2g�bbw�m�6񍛘؝Y�,�	��ݙ���	NL�άe�����{��ďbbwf-�p&(&vg���&X81�;��Y8�3�qo?���ݙ����؝y[�M�pbbwf-�p&(&vg���&~4�3k��3A1�;��6��ݙ����؝y�{���LL�άe�����{��'&vg�2g�bbw�m�6q &vg�2g�bbw�=�m���3k��3A1�;��6q� &vg�2g�bbw�=�m���3k��3A1�;��6q�!&vg�2g�bbw�m�6��ݙ����؝y�{��h�3k��3A1�;��6��ݙ����؝y�{����3k��3A1�;��6��ݙ����؝y[�M\*��ݙ����؝y�{�`�����Zf�LPL�μǽM\e��ݙ����؝y�{�`�����Zf�LPL�μǽM\���ݙUf�LPL�μ��&&(&vgV��3A1�;�o��cbwf�Y8�3����qL�ά2g�bbw�=���8&vgV��3A1�;����:&vgV��3A1�;�z���CL�ά2g�bbw�=�m���3����؝y�{�xI��ݙUf�LPL�μǽM�pbbwf�Y8�3�qo�@L�ά2g�bbw�m�6��ݙUf�LPL�μǽM�1�;��,�	��ݙ���	NL�ά2g�bbw�=�mb鉉ݙUf�LPL�μǽM�pbbwf�Y8�3o���?j����*�p&(&vg���&X81�;��,�	��ݙ����?�����*�p&(&vg���&X81�;��,�	��ݙ����o+����*�p&(&vg�Vo,��؝Ye�����{���73bbwf�Y8�3�qo,��؝Ye�����{��ķPbbwf�Y8�3�qo,��؝Ye�������m�71�;��,�	��ݙ���	NL�ά2g�bbw�=�m��1�;��,�	��ݙ���	NL�ά2g�bbw�=�m�1�;��,�	��ݙ���'&vgV��3A1�;��6񣑘؝Ye�����{��'&vgV��3A1�;��6���؝Ye�����{��'&vgV��3A1�;�z���3����؝y�{�`�����*�p&(&vg���&.����*�p&(&vg���&X81�;��,�	���-�,\��'&vgV��3A1�;�z�`�����*�p&(&vg���&.Z����*�p&(&vg���&X81�;��,�	��ݙ�����1�;��,�	��ݙ���	NL�ά2g�bbw�m�6q�$&vgV��3A1�;��6��ݙUf�LPL�μǽM\e��ݙUf�LPL�μǽM�pbbwf�Y8�3�qohbbwf�Y8�3o���	��ݙ�f�LPL�μ�ۭ�؝Ym�����{|�u�3����؝y�?n=��ݙ�f�LPL�μ�?����ݙ�f�LPL�μ��&���3����؝y�{�`�����j�p&(&vg���&^bbwf�Y8�3�qo,��؝Ym�����{���"�3����؝y[�M�pbbwf�Y8�3�qo�GL�ά6g�bbw�=�m���3����؝y�{�Xzbbwf�Y8�3�qo,��؝Ym�������m�1�;��,�	��ݙ���	NL�ά6g�bbw�=�m�81�;��,�	��ݙ���	NL�ά6g�bbw�=�m��
1�;��,�	��ݙ���'&vgV��3A1�;��6�͌�؝Ym�����{��'&vgV��3A1�;��6�-��؝Ym�����{��'&vgV��3A1�;�z���ML�ά6g�bbw�=�m���3����؝y�{��qAL�ά6g�bbw�=�m���3����؝y�{��!EL�ά6g�bbw�m�6��ݙ�f�LPL��    �ǽM�h$&vgV��3A1�;��6��ݙ�f�LPL�μǽM�@&&vgV��3A1�;��6��ݙ�f�LPL�μ��&�����j�p&(&vg���&X81�;��,�	��ݙ�����1�;��,�	��ݙ���	NL�ά6g�bbw�=�m��CL�ά6g�bbw�m�6��ݙ�f�LPL�μǽM\���ݙ�f�LPL�μǽM�pbbwf�Y8�3�qo�;bbwf�Y8�3�qo,��؝Ym�������m�RIL�ά6g�bbw�=�m���3����؝y�{����3����؝y�{�`�����j�p&(&vg���&.������p&(&vg�Vm�3k���؝y��[�1�;��,�	��ݙ��v�8&vg֘�3A1�;��z�3k���؝y�n}�3k���؝y[�M��!&vg֘�3A1�;��6��ݙ5f�LPL�μǽM�$�����p&(&vg���&X81�;��,�	��ݙ����E &vg֘�3A1�;�z�`������p&(&vg���&֏�؝Yc�����{��'&vg֘�3A1�;��6�������p&(&vg���&X81�;��,�	��ݙ����5bbwf�Y8�3�qo,��؝Yc�����{���pbbwf�Y8�3�qo,��؝Yc�����{��ķbbwf�Y8�3o��	NL�ά1g�bbw�=�m�1�;��,�	��ݙ���	NL�ά1g�bbw�=�m�[(1�;��,�	��ݙ���	NL�ά1g�bbw�m�6񍛘؝Yc�����{��'&vg֘�3A1�;��6�゘؝Yc�����{��'&vg֘�3A1�;��6�C��؝Yc�������m���3k���؝y�{���HL�ά1g�bbw�=�m���3k���؝y�{���LL�ά1g�bbw�=�m���3k���؝y[�M\��ݙ5f�LPL�μǽM�pbbwf�Y8�3�qo�bbwf�Y8�3�qo,��؝Yc�����{��ĕ��؝Yc�������m���3k���؝y�{��h�3k���؝y�{�`������p&(&vg���&�w�����p&(&vg���&X81�;��,�	��ݙ���ĥ��؝Yc�����{��'&vg֘�3A1�;��6q�%&vg֘�3A1�;��6��ݙ5f�LPL�μǽM\���ݙ�,�	��ݙ�,�	���3�Y8;wgn�p}��ع;s��3A�sw�6g�b���m���ݙ�,\"%v���f�LP�ܝ���ع;s��3Aq[�m2�GW���3�Y8;wgn�p&(v���f�LP�ܝ�����Yb���m���ݙ�,�	���3�Y8;wgn�p}L�ع;s��3A�sw�6g�b���m���ݙ�,\&v���f�LP�ܝ���ع;s��3A�sw�6�G����3�Y8;wgn�p&(v���f�LP�ܝ����Ahb���m���ݙ�,�	���3�Y8;wgn�p}��ع;s��3A�sw�6g�b���m���ݙ�,\�&v���f�LP�ܝ���ع;s��3A�sw�6�G͉��3�Y8;wgn�p&(v���f�LP�ܝ����wb���m���ݙ�,�	���3�Y8;wgn�p}��ع;s��3A�sw�6g�b���m���ݙ�,���b���m���ݙ�,�	���3�Y8;wgn�p=B�ع;s��3A�sw�6g�b���m���ݙ�,\. v���f�LP�ܝ���ع;s��3A�sw�6�����3�Y8;wgn�p&(v���f�LP�ܝ�����b���m���ݙ�,�	���3�Y8;wgn�p=�ع;s��3A�sw�6g�b���m���ݙ�,\� v���f�LP�ܝ���ع;s��3A�sw�6�c0���3�Y8;wgn�p&(v���f�LP�ܝ�����b���m���ݙ�,�	���3�Y8;wgn�p=�ع;s��3A�sw�6g�b���m���ݙ�,\!v���f�LP�ܝ���ع;s��3A�sw�6��M���3�Y8;wg�p&(v��<f�LP�ܝy���Pb���c���ݙ�,�	���3�Y8;wg�p=ʅع;�3A�sw�1g�b���c���ݙ�,\�!v��<f�LP�ܝy��ع;�3A�sw�1�ck���3�Y8;wg�p&(v��<f�LP�ܝy����b���c���ݙ�,�	���3�Y8;wg�p=��ع;�3A�sw�1g�b���c���ݙ�,\"v��<f�LP�ܝy��ع;�3A�sw�1�㈈��3�Y8;wg�p&(v��<f�LP�ܝy���$b���c���ݙ�,�	���3�Y8;wg�p=z�ع;�3A�sw�1g�b���c���ݙ�,\|"v��<f�LP�ܝy��ع;�3A�sw�1�c����3�Y8;wg�p&(v��<f�LP�ܝy���p+b���c���ݙ�,�	���3�Y8;wg�p=R�ع;�3A�sw�1g�b���c���ݙ�,\�"v��<f�LP�ܝy��ع;�3A�sw�1��È��3�Y8;wg�p&(v��<f�LP�ܝy����2b���c���ݙ�,�	���3�Y8;wg�p=*�ع;�3A�sw�1g�b���c���ݙ�,\h#v��<f�LP�ܝy��ع;�3A�sw�1�cም�3�Y8;wg�p&(v��<f�LP�ܝy���0:b���c���ݙ�,�	���3�Y8;wg�p=�ع;�3A�sw�1g�b���c���ݙ�,\�#v��<f�LP�ܝy��ع;�3A�sw�1������3�Y8;wg�p&(v��<f�LP�ܝy����Ab����,�	���3�p&(v��|��ع;�1ף���3�p&(v��|��ع;�1g�b����,\T$v��|��ع;�1g�b����,�	���3�p=Ƒع;�1�����F�%	��
�0]��]N9.�Mg�@�SA�hӂq�vf�µ`���Y�p-'og.�?)���Y�p-'og.\��ۙ�ׂq�vf�������ۙ�ׂq�vf�µ`���Y�p-'og.�?�)���Y�p-'og.\��ۙ�ׂq�vf������ۙ�ׂq�vf�µ`���Y�p-'og.�?
*���Y�p-'og.\��ۙ�ׂq�vf���S���ۙ�ׂq�vf�µ`���Y�p-'og.�?�*���Y�p-'og.\��ۙ�ׂq�vf�������ۙ�ׂq�vf�µ`���Y�p-'og.�?�*���Y�p-'og.\��ۙ�ׂq�vf������ۙ�ׂq�vf�µ`���Y�p-'og.�?l+���Y�p-'og.\��ۙ�ׂq�vf���s���ۙ�ׂq�vf�µ`���Y�p-'og.�?�+���Y�p-'og.\��ۙ�ׂq�vf�������ۙ�ׂq�vf�µ`���Y�p-'og.�?X,���Y�p-'og.\��ۙ�ׂq�vf���3���ۙ�ׂq�vf�µ`���Y�p-����������ۙ�ׂq�vf�µ`���Y�p-'og.�?	-���Y�p-'og.\��ۙ�ׂq�vf���C���ۙ�ׂq�vf�µ`���Y�p-'og.�?-���Y�p-'og.\��ۙ�ׂq�vf�������ۙ�ׂq�vf�µ`���Y�p-'og.�?�-���ٸp-'og6.\��ۙ�ׂq�vf������ۙ�ׂq�vf�µ`���ٸp-'og6.�?k.���ٸp-'og6.\��ۙ�ׂq�vf���c���ۙ�ׂq�vf�µ`���ٸp-'og6.�?�.���ٸp-'og6.\��ۙ�ׂq�vf�������ۙ�ׂq�vf�µ`���ٸp-'og6.�?W/���ٸp-'og6.\��ۙ�ׂq�vf���#���ۙ�ׂq�vf�µ`���ٸp-'og6.�?�/���ٸp-'og6.\��ۙ�ׂq�vf��N��l\����3�����ƅk�8y;�q��'og6.\��ۙ�    ׂq�vf�µ`���ٸp����3�����ƅk�8y;�q�Z0N��l\����ۙ�ׂq�vf�µ`���ٸp-'og6.ܡ����ƅk�8y;�q�Z0N��l\����3p�vf�µ`���ٸp-'og6.\��ۙ�w�B8y;�q�Z0N��l\����3�����ƅ;�!���ٸp-'og6.\��ۙ�ׂq�vf���N��l\����3�����ƅk�8y;�q�Ά'og6.\��ۙ�ׂq�vf�µ`���ٸp�J���3�����ƅk�8y;�q�Z0N��l\�)��ۙ�ׂq�vf�µ`���ٸp-'og6.�a����ƅk�8y;�q�Z0N��l\����3��p�vf�µ`���ٸp-'og6.\��ۙ�w�F8y;�q�Z0N��l\����3�����ƅ;}#���ٸp-'og6.\��ۙ�ׂq�vf���N��\����3�������k�8y;sp���'og.\��ۙ�ׂq�v��µ`���9�pǅ���3�������k�8y;sp�Z0N��\��F��ۙ�ׂq�v��µ`���9�p-'og.�!%������k�8y;sp�Z0N��\����3�|�p�v��µ`���9�p-'og.\��ۙ�w4J8y;sp�Z0N��\����3�������;U%���9�p-'og.\��ۙ�ׂq�v����N��\����3�������k�8y;sp��r	'og.\��ۙ�ׂq�v��µ`���9�p�����3�������k�8y;sp�Z0N��\�d��ۙ�ׂq�v��µ`���9�p-'og.��3������k�8y;sp�Z0N��\����3�ܚp�v��µ`���9�p-'og.\��ۙ�w�M8y;sp�Z0N��\����3�������;-'���9�p-'og.\��ۙ�ׂq�v����N��\����3�������k�8y;sp���	'og.\��ۙ�ׂq�v��µ`���9�p�����3�������k�8y;sp�Z0N��\�����ۙ�ׂq�v��µ`���9�p-'og.ܡB������k�8y;sp�Z0N��\����3�<�p�v��µ`���9�p-'og.\��ۙ�w�Q8y;sp�Z0N��\����3�������;)���9�p-'og.\��ۙ�ׂq�v����N��\����3�������k�8y;sp��^
'ng�?\���3ߧ�&/7ng�?�p/7ng��O?p�v�����q�v�{~�t��3ן]���3����n��\v�^0n��|χOܸ����½`�O�k�qM�?p�v���qM��q;�=�~�q;s�����7ng��\�o��3�ߏk�p�v�{�5�.�q;s����_��3�s���������qM�7ng�O���ܸ���>�����3�s�����ۙ��㚾n��|Ϲ�o��3���5}ܸ���sM�7ng���k�
ܸ���sM_��3��⚾7ng�O���n��\�kZ?p�v�{�5�ܸ���״�q;�=��7ng���5�n��|Ϲ�u��ۙ�oqM���ۙ�9״ܸ���6״ܸ��>���q;s�m�i���ۙ�9״?p�v���\�^������k�ܸ���6״�q;�=��7ng���5�7ng��\�np�v��;\�p�v���k:�����w���7ng��\����ۙ��pMg��3�s��lp�v��;\�9������k:ܸ����t
ܸ���sM���ۙ��rMg��ۙ�S�����3����ܸ���sM�7ng���5�n��|Ϲ����ۙ��rM���3�s��^p�v���\�-p�v�{�5�7ng�����3ߧ\S���3�_qM�7ng��\S}�����W\S-p�v�{�5�7ng�����3�s��.�q;s��Tn��|Ϲ�jp�v��k��ܸ��>��ܸ����k��q;�=��7ng���z��3�s��7�q;s�5��ܸ���sM}��ۙ믹�.p�v�{�5u��3��pM=�����)�4�����7\����ۙ�9�4�q;s��4ܸ���sM���ۙ�o��9������k�n��\�5M��3�s�iܸ��~\��q;�}�k҂q�v���µ`ܸ���/>���ۙ�ׂq�v�{~�t��3�����������3�������|����ۙ�ׂq�v���$.ܸ��~�p-7ng�pMr�ۙ�ׂq�v����ܸ��~�p-7ng�pMr�ۙ�ׂq�v���$.ܸ��~�p-7ng�O�&�p�����Åk��q;�=���3��������k�n��\?\���3�s�I.\�q;s�p�Z0n��|Ϲ&�p�����Åk��q;�}�5Ʌ7ng�.\ƍۙ�9�$.ܸ��~�p-7ng��\�\�p�v���µ`ܸ���sMr�ۙ�ׂq�v�{�5Ʌ7ng�.\ƍۙ�S�I.\�q;s�p�Z0n��|Ϲ&�p�����Åk��q;�=���3��������k�n��\?\���3�s�I.\�q;s�p�Z0n��|�rMr�ۙ�ׂq�v�{�5Ʌ7ng�.\ƍۙ�9�$.ܸ��~�p-7ng��\�\�p�v���µ`ܸ���sMr�ۙ�ׂq�v���k�n��\?\���3�s�I.\�q;s�p�Z0n��|Ϲ&�p�����Åk��q;�=���3��������k�n��\?\���3ߧ\�\�p�v���µ`ܸ���sMr�ۙ�ׂq�v�{�5Ʌ7ng�.\ƍۙ�9�$.ܸ��~�p-7ng��\�\�p�v���µ`ܸ��>���3��������k�n��\?\���3�s�I.\�q;s�p�Z0n��|Ϲ&�p�����Åk��q;�=���3�������)�$.ܸ��~�p-7ng��\�\�p�v���µ`ܸ���sMr�ۙ�ׂq�v�{�5Ʌ7ng�.\ƍۙ�9�$.ܸ��>\���3ߧ�&-7ng�������|��n��\.\ƍۙ����n��\.\ƍۙ�y��7ng�������|����ۙ�Åk��q;�}�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��>\���3�s�I.\�q;s}�p-7ng��\�\�p�v��p�Z0n��|�rMr�ۙ�Åk��q;�=���3ׇׂq�v�{�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��>\���3ߧ\�\�p�v��p�Z0n��|Ϲ&�p������µ`ܸ���sMr�ۙ�Åk��q;�=���3ׇׂq�v�{�5Ʌ7ng�������)�$.ܸ��>\���3�s�I.\�q;s}�p-7ng��\�\�p�v��p�Z0n��|Ϲ&�p������µ`ܸ���sMr�ۙ�Åk��q;�}�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��>\���3�s�I.\�q;s}�p-7ng��\�\�p�v��p�Z0n��|�rMr�ۙ�Åk��q;�=���3ׇׂq�v�{�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��>\���3ߧ\�\�p�v��p�Z0n��|Ϲ&�p������µ`ܸ���sMr�ۙ�Åk��q;�=���3ׇׂqO�W8.\ƍۙ�Åk��q;�}�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��>\���3�s�I.\�q;s}�p-7ng��\�\�p�v��p�Z0n��|�rMr�ۙ�Åk��q;�=���3ׇׂq�v�{�5Ʌ7ng��������k�n��\.\ƍۙ�9�$.ܸ��.\ƍۙ�S_���3�k��q;�=_|���3�k��q;�=?|���ۙk�µ`ܸ����^p�v�Z�p-7ng��çn��\������)�$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�9    �$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�S�I.\�q;s-\���3�s�I.\�q;s-\���3�s�I.\�q;s-\���3�s�I.\�q;s-\���3�s�I.\�q;s-\���3ߧ\�\�p�v�Z�p-7ng��\�\�p�v�Z�p-7ng��\�\�p�v�Z�p-7ng��\�\�p�v�Z�p-7ng��\�\�p�v�Z�p-7ng�O�&�p���̵p�Z0n��|Ϲ&�p���̵p�Z0n��|Ϲ&�p���̵p�Z0n��|Ϲ&�p���̵p�Z0n��|Ϲ&�p���̵p�Z0n��|�rMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ��>���3�k��q;�=���3�k��q;�=���3�k��q;�=���3�k��q;�=���3�k��q;�}�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v���k�n��\�������k�n��\�������k�n��\�������k�n��\�������k�n��\������)�$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�9�$.ܸ��.\ƍۙ�9�$.ܸ��6.\ƍۙ�S_���3�ƅk��q;�=_|���3�ƅk��q;�=?|���ۙk�µ`ܸ����^p�v�ڸp-7ng��çn��\������)�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�S�I.\�q;sm\���3�s�I.\�q;sm\���3�s�I.\�q;sm\���3�s�I.\�q;sm\���3�s�I.\�q;sm\���3ߧ\�\�p�v�ڸp-7ng��\�\�p�v�ڸp-7ng��\�\�p�v�ڸp-7ng��\�\�p�v�ڸp-7ng��\�\�p�v�ڸp-7ng�O�&�p���̵q�Z0n��|Ϲ&�p���̵q�Z0n��|Ϲ&�p���̵q�Z0n��|Ϲ&�p���̵q�Z0n��|Ϲ&�p���̵q�Z0n��|�rMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ���sMr�ۙk�µ`ܸ��>���3�ƅk��q;�=���3�ƅk��q;�=���3�ƅk��q;�=���3�ƅk��q;�=���3�ƅk��q;�}�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v�{�5Ʌ7ng��ׂq�v���k�n��\�������k�n��\�������k�n��\�������k�n��\�������k�n��\������)�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܸ��6.\ƍۙ�9�$.ܼ�yp�Z0n��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\��4�&\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\���ۙ���v���k����yp�Z0*og\��gT��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T��<�p-��3.\F��̃ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T�μ�p-��3/.\F��̋ׂQy;��µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3��N�W8.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��,\���ۙ�ׂQy;�p�Z0*og.\F���k����Y�p-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��    l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F���ƅk����ٸp-��3���vf�µ`T��l\���ۙ�ׂQy;�q�Z0*og6.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T��\���ۙ�ׂQy;sp�Z0*og.\F�����k����9�p-��3���v��µ`T����p-�3ߧ�&/�3��]���ۙ����t���v�^0:ng��O7踝���½`t��|ϋO/踝���½`t��|χOt���v�^0ާ�5����踝��~\��:ng��\���3�ߏk�-�q;�=�~t���?��w@�����k�]�q;s����_��ۙ�9��k�q;s�}\�o@����)�����ۙ��㚾踝��sM�:ngk�踝��sM��3���5}t��|Ϲ�ۙ��㚾�3�s��k�q;s�-���q;�}�5�?�q;s�-�i�@�����kZ踝��״踝��sMk��ۙ�oqM뀎ۙ�9״.踝��״
t��|Ϲ�ՠ�v���\��q;�}�5�?�q;s�m�i�@�����k�踝��6״踝��sM{��ۙ�osM���ۙ�9״/踝��6״t��|Ϲ�ݠ�v��;\��q;�}�5�?�q;s����@�����k:踝���t踝��sMg��ۙ��pM瀎ۙ�9�t.踝���t
t��|Ϲ�Ӡ�v���\��q;�}�5�?�q;s�]���@�����k�踝��.�t踝��sMw��ۙ��rM���ۙ�9�t/踝��.�tt��|Ϲ�۠�v��+��踝�>��t����5�t��|Ϲ��@����W\S-�q;�=�j��ۙ����:��v�{�5��3�_qMU��v�{�5U��ۙ�����q;�}�5�踝���k�踝��sM���ۙ����^��v�{�5��3�_sM}@�����k�:ng�暺@�����k��3��pM=��v���k�?�q;s��4?�q;�=���3��pM�@�����k�:ng��怎ۙ�9�4t����5M��ۙ�9�4:ng���4:ng�O}MZ0:ng�.\F����|��:ng�.\F��������3����v�{^|zA����Åk�踝���6踝��p-�3ߧ\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng�O�&�p��v���µ`t��|Ϲ&�p��v���µ`t��|Ϲ&�p��v���µ`t��|Ϲ&�p��v���µ`t��|Ϲ&�p��v���µ`t��|�rMr�B����Åk�踝��sMr�B����Åk�踝��sMr�B����Åk�踝��sMr�B����Åk�踝��sMr�B����Åk�踝�>���ۙ��ׂ�q;�=���ۙ��ׂ�q;�=���ۙ��ׂ�q;�=���ۙ��ׂ�q;�=���ۙ��ׂ�q;�}�5Ʌ�3����v�{�5Ʌ�3����v�{�5Ʌ�3����v�{�5Ʌ�3����v�{�5Ʌ�3����v���k�:ng�.\F�����k�:ng�.\F�����k�:ng�.\F�����k�:ng�.\F�����k�:ng�.\F����)�$.t���?\���ۙ�9�$.t���?\���ۙ�9�$.t���?\���ۙ�9�$.t���?\���ۙ�9�$.t���?\���ۙ�S�I.\踝��p-�3�s�I.\踝��p-�3�s�I.\踝��p-�3�s�I.\踝��p-�3�s�I.\踝��p-�3ߧ\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p�Z0:ng��\�\��q;s�p-�3ߧ�&-�3��ׂ�q;�=_|���ۙ�Åk�踝��>ݠ�v��p�Z0:ng��ŧt���.\F����|��A�����µ`t��|�rMr�B�����µ`t��|Ϲ&�p��v��p�Z0:ng��\�\��q;s�p-�3�s�I.\踝�?\���ۙ�9�$.t���.\F����)�$.t���.\F�����k�:ng����v�{�5Ʌ�3��ׂ�q;�=���ۙ�Åk�踝��sMr�B�����µ`t��|�rMr�B�����µ`t��|Ϲ&�p��v��p�Z0:ng��\�\��q;s�p-�3�s�I.\踝�?\���ۙ�9�$.t���.\F����)�$.t���.\F�����k�:ng����v�{�5Ʌ�3��ׂ�q;�=���ۙ�Åk�踝��sMr�B�����µ`t��|�rMr�B�����µ`t��|Ϲ&�p��v��p�Z0:ng��\�\��q;s�p-�3�s�I.\踝�?\���ۙ�9�$.t���.\F����)�$.t���.\F�����k�:ng����v�{�5Ʌ�3��ׂ�q;�=���ۙ�Åk�踝��sMr�B�����µ`t��|�rMr�B�����µ`t��|Ϲ&�p��v��p�Z0:ng��\�\��q;s�p-�3�s�I.\踝�?\��>�_�p-�3��ׂ�q;�}�5Ʌ�3��ׂ�q;�=���ۙ�Åk�踝��sMr�B�����µ`t��|Ϲ&�p��v��p�Z0:ng��\�\��q;s�p-�3ߧ\�\��q;s�p-�3�s�I.\踝�?\���ۙ�9�$.t���.\F�����k�:ng����v�{�5Ʌ�3�k�踝�>�5i�踝�.\F����|��    :ng�ׂ�q;�=?|�A��̽p�Z0:ng��ŧt������v�{>|ڠ�v�^�p-�3ߧ\�\��q;s/\���ۙ�9�$.t������v�{�5Ʌ�3�k�踝��sMr�B��̽p�Z0:ng��\�\��q;s/\���ۙ�S�I.\踝�.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�^�p-�3�s�I.\踝�.\F����)�$.t������v�{�5Ʌ�3�k�踝��sMr�B��̽p�Z0:ng��\�\��q;s/\���ۙ�9�$.t������v���k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�^�p-�3�s�I.\踝�.\F�����k�:ng�ׂ�q;�}�5Ʌ�3�k�踝��sMr�B��̽p�Z0:ng��\�\��q;s/\���ۙ�9�$.t������v�{�5Ʌ�3�k�踝�>���ۙ{�µ`t��|Ϲ&�p��v�^�p-�3�s�I.\踝�.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|�rMr�B��̽p�Z0:ng��\�\��q;s/\���ۙ�9�$.t������v�{�5Ʌ�3�k�踝��sMr�B��̽p�Z0:ng�O�&�p��v�^�p-�3�s�I.\踝�.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�^�p-�3ߧ\�\��q;s/\���ۙ�9�$.t������v�{�5Ʌ�3�k�踝��sMr�B��̽p�Z0:ng��\�\��q;so\���ۙ�S_���ۙ{�µ`t��|��~��v�޸p-�3��çt������v�{^|zA��̽q�Z0:ng��ç:ng�ׂ�q;�}�5Ʌ�3�ƅk�踝��sMr�B��̽q�Z0:ng��\�\��q;so\���ۙ�9�$.t������v�{�5Ʌ�3�ƅk�踝�>���ۙ{�µ`t��|Ϲ&�p��v�޸p-�3�s�I.\踝�7.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|�rMr�B��̽q�Z0:ng��\�\��q;so\���ۙ�9�$.t������v�{�5Ʌ�3�ƅk�踝��sMr�B��̽q�Z0:ng�O�&�p��v�޸p-�3�s�I.\踝�7.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�޸p-�3ߧ\�\��q;so\���ۙ�9�$.t������v�{�5Ʌ�3�ƅk�踝��sMr�B��̽q�Z0:ng��\�\��q;so\���ۙ�S�I.\踝�7.\F�����k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�޸p-�3�s�I.\踝�7.\F����)�$.t������v�{�5Ʌ�3�ƅk�踝��sMr�B��̽q�Z0:ng��\�\��q;so\���ۙ�9�$.t������v���k�:ng�ׂ�q;�=���ۙ{�µ`t��|Ϲ&�p��v�޸p-�3�s�I.\踝�7.\F�����k�:ng�ׂ�q;�}�5Ʌ�3�ƅk�踝��sMr�B��̽q�Z0:ng��\�\��q;so\���ۙ�9�$.t������v�{�5Ʌ��3.\F��̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`�O�kk����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v���k����yp�Z0&og\���ۙ�c�v�������̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̃ׂ1y;��µ`L��<�p-��3.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\���̋ׂ1y;��µ`L�μ�p-��3/.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0����µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����k����Y�p-��3�c�vf�µ`L��,\���ۙ�ׂ1y;�p�Z0&og.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y; �  �q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��l\���ۙ�ׂ1y;�q�Z0&og6.\����ƅk����ٸp-��3�c�vf�µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\������k����9�p-��3�c�v��µ`L��\���ۙ�ׂ1y;sp�Z0&og.\�����ׂ1q;�}�k��������߿���      6      x������ � �      �   A   x���,��8�!��5�3�3���w�v��J����o ��ǣ�<#=�=�
b���� `��      �      x��}ˮ�:����W��RJ�����e\�ը	%R�v�@��r�����x���2c-fn�Hʭ�)ej��ݼY�dJ��RDp���?���O��**oMY+��(�[���U�תH_��K�o�7��/T����1�h~h�.�0��:T�*�J�}�*S��+S)�:�7�Z�Z�m�+_�PնV�n����Fۢ�8}�����8,##����2-?�ڕ��N[_��=Zə"9�Cn7���٣��`�A�����c���2�����/5c����_����-G���j?+�F��>c������G.���p��[��Wb��X��s��pf�S���G3bC{-�7��=�յS߸��N��`-���NfG���6��g��y"m:��ݗ�
x|˻�K}coy�7�wno�'O?|��(�x����b{�HO����0n���DJ��jU�ٿх��AE��jB��j��ܾ��Xu��t)UЍ���1,tǳV��32��kJ3�k��^u�z���k1^�� V�/5�tbu#v��Ɗ��X�~�D+`Z�,�����b��)F7݊�.��M!V60E�q�}�0��d|�y�WvDpa�%�k��p�	^���;��E;p�[���1�Iً�N�c�t^̔b��1�FZ��b'#�e�e+�Xm��J�s�ǎ����(�j�X|�6ë�#8d��:���?7��9o좰b|Z�.���ۊ�VcOx<~���Vbid�Ou��_Ȝ�Z�jT��q�W�S�zY�!+�}�̶�톖ceb�*Z���%�8�}�62�2��V��r���O��	>�е�:���^ԯ���Xx@��_� Y[2>Wǿ�Vl���.���^�zH�Xw�q�|rNF����|�o��F�;�����o@щ���Tbwlpa��.���Sg��+�v���#�wk����c�����l$l�l@o�_��[��P�Dz1��1^M�6ڮ��ʿ�x��!2��4`Y�@n�hF�Oc�^�j #���R!E��%xB��Ȳ\:����o���<A�v����ꎾ!�k��+�����w,�!���_��W�Vė�h���3��Ŏ����9M����G@���x�p��̣� n�q���Ķof�=���c�9��SJ�n3�Ľ,k��P�b��?������G��`�v˖�[���l��|��}`XX5��N�!��J]���R�����Mm��í}�G�ůe��KeT�-#��Ҡ�r��Ư8���-݂!7�������s�9�Zn�
����^�	n瓬�+<������Z}�cRwZ������aGx1�B����&<̯�fR�e$�,*��ѽX��ۀ�+<�ZyEKf_L� ��+$�m�����~pѭ��Z�9*�l̪x��Rձm�E�d~uH�Q
m�Uő��8y}�/.+���ī�
9��sO,�+���a�_!9�՝����+洴��<
v9�b��>��̯� ���G�=W�_o��y"�[���ؖ-��_���.�e�S�qX_�_����Ӛ��ǉ�{ۏ�<4$�m:�_9���Y���ş��|���uxcY�3�����w��py�_%\�W�#��/��Rσ5~Ո��s7�D~��[�[�R.�zg�����j�+�O5�[�Gw6�Bl>�nς{-�JyD+>+Չ9+��FMy�g�WdVpE$�D�W@͕��\�v����QE(3�:��#�ui�_���kV�U9:o��3�Z������~��Ư�Ww�&�¯�)M˶V@/��3�E��j�K��7I+�n���8g!���/������&W)WtnQ�y�³�+���5�^����X�Q�6&\����~e��C�W�eY�v̯�	�2�ZG�W�0~���^{�q��`_��6C�Wspe����$�3��2�y>� � ���kH�ܠ��~���o1XN���/ȯ��]�6<�H��a6����\+�!��/��3M�HD�deM�i����[5G�WspƜ�V𙱿՟a��d<�׮���O���o�n������2\�;��(���|��lU�W�W}!�w��6	f�움��U�W�k,�����+86<�Y�W0������Wȸ>n���:e�'c�;��X�V�&��ҵS���?9�3�C��o��9��7bk+pq�����l�������8�N:w U���-oG�W�_���7Q�s��3hn����l�k$!�����|j7�-���g�W̨��$�Tf��X�$i�2�}���T	�6V�WH!��W��r�<H�p�����TW��v|?�_����W����7C�_��?���[��2�Z3��3Y�r_ѓ��z1s#������G�q_|^~�*�Ww�&V���w�,�и�Lc|p����l���ur7O��
؋_Q�".>�(u�U��՚��HW��S\	i��w��P��FS�(�-5�b��=R��g�^ѩ�n�w�G�>���Jd4dLƊb�^5�v>n'�WLvd�zR��c0 O'i�~v��_q5�n`Ǎ�ذ��D������+�PYΉd���s��g�iĞ2�"�U�QqGM�̯��������6ת>'�buڪ��~L+:����oڲ�}1�W5���.1�
ŕ�)��>�T_o����ӳ���g����d����&����+��ݰvs��5~{�~��a|z�m}�����K�*�l�������R�q�_}�?g�W�\U������bu�w�n��Ӄ��Ta��
x�_Qa ]��Mβ�����^�&��F�q|��e���T��L�o�߅qY��$>�\�o�Ư�g����T�i��_���.���v��mk2b.���ml�O.�i����z/y(]�0+w�g웾�9�T�ғ|x�%76����_�_�F8��#����L��m�ʯj+Zw�s;�ƯXO����u��cB�sg~Ż�C�
�b��a3Ы�k�#���� ��ʯJF�R�FeC��}�qf
�(���������ە�cV����x�pu�=�M^�۸��{尅�v����^w��Ş4��!��ٟ��E�2�U9X�cAs<����XO��ּl��|^~��,|F=il�����x�Z~;�뗻�E�4������QR;�)�NǯN���k���㾡v������t'��0�Jr'߃��^����W���'�e�qU���o�x$?�һ�� ��t��tq�7<�i9���E7I`I>�K6QJ�m�~�\<�~,N7bV�J���
Y:�Ɖ��6�k�N9d�p�X�O�Z�C\!c��,h���6�eFk�"�\qΩ���	M�K�c�p���}3W����m-v�����W)���X�W�n�����O9�)��ae���^��j�sb�<O�2�:�Q�a�_��zJ,�3���W])�zO͟~9��_�����3_+�b��m��#����<!�bh"'��;T.�#���h�x��6�����[B�>jUt�k=¯F��Ar��a_�s�M���M��ߚ�ö�K9akT�jW�P���)����/��m_�!TCU�x�u�s��CS����4�^e򰝍_e�������
�[{�}��!�5p!��~D�V��Ws�+�'k�<��a��+��ۿ�����D�����j2��*�1[j})>T\d2=�<�udpURQf;�.�4���K�D�<W�!O�yH-�k��+0%F'ͨ?誮c�Ro�v�=����ŧ���ԡ.�����#�X�FK��*��7g�f~�~x}Q"�ā8��S��b����_��'ޕw��M)6�� Htj~��q��fd��{/�b�������Z矝_�A���#y遄�[A>�^U��q)۪BL�7Gr�D�W,���$�Տ��cjT^S�@�����2N�ʯy��#�a�=���:�	ψM�G��3�[�L��	�����:%��$�8�%�_=�̯���h���Jj��9G+�5,�� �p;ץ&�p�x>��N�2�T�ۿ�ίR�C�Ԓݮ��1|%~Ep�    -kF̷��)�_�����=⃑�l"]�ڄ�l��f_�UH1;5H�KI��3�H|P��v"ic+䣽��SS��Q����]��<� d{��P�ζ�q�k��+\?�N�t>n���J����d�l��*��)�,�?�O̯�;��3��xfA�=����5P�"�5�Alr?B��'*��j�cߖvx-�5�n�^o���¯�s,R9�g5���W.Ւ:Zk��g��Jȳ�����\q]Ǜ������q�%��8#yB��>�+s��4�o?X��lSu���^x��yB>�F�*R�x�񝠻xD�b�*Vu]�"�`�铿�1G?j�����!^6�SVҖ�أ>���x'X_�}u�i�����p���̯�B�_���Ƞ���S.��i*
aI��R"n���*�B|���n�p�k�P���o�@y��WK~�X�v I'���5�-[X�W�#M1��� �B�<���U��i�+lV��&�c�����K,���{M�Ko��/��]�rƿ�Q��p}�w!w��V��*��ϯ�Ӯt�l�0�hma�rY�ZӛH�*qUQ�!�ʀ��N|,�6�+>��>Rֆ9Z��JI���*�{Z�%i%������Eޢ�K��F|��EMA��\��g�g���{���_�/��j�J\��W*H�%&�JjA�Ї��Mz�P�nz+,t�_����7�-08���;�;ݲ�9k%X�`�H���d������\�n�_���ڕ��'Ə���s�\���@r����Re�,ZCu�*V�iA#�(]���f �2��2�H��~5U͂n'�d}b���<W)+�� �o�"�@aޤ���j|��M՘m���N����m/�yJ�Ց��q$�X���~��B�^����W�gs��:�bߕ�D�*������˯�n�>�珰���:�՞?�_%`.K�8��k��~�ĴD��T�������tZFl�ԅ�9g�t����\n�_1:��e;_-�T�D�W
�%������*C�+���ǖ��c���(���8\k�����>s~�ʀ����-O�����U��pc��a��u�G�q��A������y�G�|��56'�o���d"��i��/��ҫ/�f��b�(� k6\|�mU�{Q`E�hD�Z�˯޲��GV8�e���A�G��k����|�wa~��i���Я���E/g��C0��v���3���c�A��>�W���"��b�_�]<g��Vl��2����^�"�e�{yj`Vej��P>A�A )m���4�86YӚ>�ِ�S�G���5l�!�I��ف����[���q��Ϸ��1md���-
FY�*�m�;�՘9H��Ͻ������r��ul�wC����wD��+��U�7CN{�u���Zh�x:ڤ���?�|>��"��h��O�W��2`�U�f6���159r�X�0աNմ_Ư��^}{z)�[�ƿ��c�1���Ucx����䂢��9��͟�s�M�B����Z�!rf��r��zu���� ��v�;��{@�<�Þ|m;��.�fWݚ>���c�|�$�Ǜ�3�(̏n{.��[����g���J/ � ךkt|Wp�⯿�-t��f�,�$�(��N4"B|��I�R��{���LƁ�F'eMj(kWAV�^t�P��8��;%��A$B*Ϻ����}�/�w�J�X;I__�hi�*�+>��8o��\y��gj�q=W���*p�`}[��)a�*'�n�!c�1��оxl�#�3~�		��WU�>�D��O5���O���e����k G��ްS��9�+^(��;�V�؟,��>B�j/�-γ̃��n����x�c/���W�h�� �Sk|cT�^r> �}8��zCo���⃬�~��lW��*?��q/��|�5�x�^,��?�f�j���E����R7ǫĠ�mu��1�r�����5�dp5�G5�i�H�����]����u����IK�*9At!\Rw�����-��zįXI�jT����ss�:S�J:���X=�ʤ�^\ǡ��y��_edddddd�[�*��2ylL�	Cd���x��.�����sCS���i�X��*Ef���f��PQZ�I]��Nj���e0#K�t��}�U�&��k��W��Mu�o�*�ރ��J�A>{�D_�|Y��m]�U䢥�,d釫2�%:��������q�áJ*���:�W�՝{n���XJD��O��.�b)۴C���g��Ka��%�(������Z�>�Sz�3�5�'��EoK)�G~�������6�B��+�X�U�I���&�d�I��܎��#-��o�wC��~Ld�E��Qxt�R�
��-㒯ο������8v�� %���\}��CL5k�\4����ݫ�Q<p!�U�K���'���h!^�ҕ�wU�_T�Ѣ������u�����h���J�Ey6�gz����\��Jd���m�� �S�hV��W35���\�Uɤ0�*U�^�ϐ�����q���~=+�jM?�⃒�,*���m��]�����/};-j���Q������BdD���۾�\�%�Ն�M[���tR~R��6����*�
oyb�Bo۾E��j��~B�E*���=�,��Pl`n|�_edddd|% |�_�^ݹ�a���k�۠�_�I:}�W�uEIbz(��e�adY��5���e��PZIU/��Їf0eW��i���K6���@�-��W��`���C~(Cd{�u�ƿ��vw������qr�v�� p��C�
�El�.���`FFFF�����(�	����������~E���,��&2��z�JU��H��ょ�Evd/�OW��"�f���H�k��m�PGf%�j0؎�0��������%����`K]� e5��-�n�fck�&�"��ȵ���Qt���C(�Br��k�>e���`FFFF�WU�F���k�}�ɯ�kTˆF����^��|7�`���4���I�.�H�]<W����o����ѐ.��j=+M�B��5�
x��f~5�gP�NUu�R��7׶�ܺ��|���*�R����uS�!���R�!~'�ث�}�����322222�,>į��J�ҵhi^�)w����6�A�vm�*J�Bs�N��TU��l��`��KU#���Б�Y�1��Ng|���_��۩�.#"4� ��u�����!��E��K��v�����`oC��W-����t�z=Bm�K3Q��B�A}��C��{lB�OWe�E��L�5����R�MjXc�� k
�E���������k�hڪ�{��ⱠΠ�l|d�uW%|?K~�#�zn~{]���	����)C��^v�Y���b��C��{|'U'VR2�kYA�����f�g��H��p�q_,���j,�_s�a�K�N8j��{t(Q���S�k�Hy��;+v�9�5Y3��3Y%��G�<##�������4�<��[�N2�lc�:q�F{U
:�C��kyO�]�DD�fP&?πx"��H��u��Qo*�mҍ�|���P���Q�Q��a\��մ�\ߙ���2����/XA�[�I5+VJ���b]���k/�L�(^�J`��X���
)M!��#XU�;�+����aSŐ���υ��׶I+���|/^�T����^�T���V��a��{��O����\�=�cṺ�)5�������+�l!(�U÷V���@U�![,x��pex�^�>5��X��,�*�}��โ�BoS������d���k�[�g�.�ɡҩ��o扆j�k��Eɶ{>QRrAo01g��gG������T}F����������N~5]E���a�.>9����|��o!4��˛�h��%j*T!ed�p�:ɋ��^O��H�;�*�ǉ�nG�?R���%jIΆ-�����rh�(ߎ�]�����+��/0�Lx\8z�J���%4�rՈ����Rl2�:�T��ӫc�����b�������c!�ɏ�3�˷ T  b�:}�ѥcLŃ�����*#�������b�O�`�%�󩛞]7�=zzѹ�w�*TU�x/�[��cЯ���2��ɺ�*>�\���TP��J�����L0�����Hr²,�޹�߻�YѯЪo���t'�Q��D�P���z&��lZl>cr6?b��b���uf~u���sA_Ж(���l�0T� �_ed�h؉_���:](��������9'���t3�:Q�2j|�V����(��F��k���`,��N'~���o�y[�HetUU��Eb4HR�m]�P���#�+L�kOȦF�jL(�(���Ǥ��U�k1$�L�|��nh�����IO���'��j+��_��s
E>f���K_�����Bd.������_ed�h؝_5�b\3��m|�5��)^�0������n�@R�0Y�� �]�9��3֋�v�yM�!n�Z�p�I/�h����PkG��u��~���k"��J�CvV~U����3t�|Ɯ��g���f�z���3�ڂΊ��� ��m�W�_ed�h؝_Ց�4��T�	M��jo}��<(�!2���ȧ�%YI�*�%�:}f�[��BFӀ������%)n����������W`��o����m0R��^ƣ��
Z�/ɿ����?���%�R���j�B��)�S���̯2����Ѱ��
u��p||zb��5Ep��jh#�(��wCoZ#ʜ9W�(����DK�Kup���]V�1JH�I�º��ٲ-$e68�KK�t�t�D��PK.����՝m���m��
�&^4��&D�W&�7B��	�3��&�<��j�$��5"�]�k���7�-�z�~�����f~��UFƏ�]��Eu��[�M^Y��0b�z7u�\�:a����<ʠ�`��Rl�_3xۗU�;d�i/Y�v�G�fԓ�[���	MWE�V.r,�w��W�3ި�,�����W�+ N���S*K�#�w,R�r�_2��;p���*Ŏ��'�W\hЋ���@�no&�̯22~4��ƙQ�R�H_)�	��|@}Y�׌�?/��S�0��է�T�c=j/�h+Zuұ��A�Ǿ-BQ��0ڱfPo�Jq�Z�&��������|� ���|�m-v��z��𫧫>����{S3JĂ���~%��$z�R��+J�J��{u�222��a�j���E�t��{�������E!qLx�Щ��KTF�u'�r���:��
H�S,d2u>��W���9���w_���+�/%Q��3!!��U���җ�S,�w�Q����㱏k�
;Hzk��x��i؆��Y	�V"xN222�����WmG>7��:�EdYJ��J}T��U�Pۑ����;�{0�j2�b])�׮�:�q���XM�����{�rt�{N�5~Ub�RKYp�)/>34��Π1,��t��8|�ߌ�v�9FVx���p�vl$�\ X����G#�Y�����D Y�<�E��+d�}�<�z+F��,�ڸi�x@.�J��Y!�Ãa����_��%`G�j�_��v���/��5bǝS�yLpHB�!�V32~d~�ckR�_�v�����_�X�Z�;��|��Y^�|rF�X'e�c��f7��ߘ�+=6)�t V�r�R^�s���BY�e=L[�W�#���J����q��Ϋu���}�W����:�o�A�W/m����2�Tȹ��{7���;�XX�i���� [X�wa���m��`)�E��?Θx���	�B��ifh(�Xn?���v����<��ƆՎ]+vD����������7yM���5I_��edd|Bd~���m �|a�@�;�Z]�I���ݝ��8w���,���)Ef�Ø�3��9)Gz'l�o:�X*�ɸa@����_�����[+z�5�_%���Z��KFF����*�-����Km�X��(5�[GG�;oĊFl��~��f�B���k�I�� �4j��-����^���<��[�J����X����q4���̯2��.��k)0~t��i��L�!��2ؽ��l��'0cMs�4���}>3�"�6�4�۲��ʯ\cVphݱ
�Q`��/������c�����e3�z"��k�W�j��N���$�4C,� N"*�5 �ɸ�|_i��ݳ��I0��ca�qp������[f}�-[�z�����{>���~WM޾pC�b`�6##�Ĉ�<���hr�8�R[D~����K6K�
�'�V�P�aJ�pfU�kٴR#h!��5������+9+��5�F��W���;��S�+8V2�"�϶ʬ����0b��6bG��ddd�8��T���U�M�DI �{�U�pMu�8!�_������eѴ�qN�	�����/���D^ӈ���O���,e��0�����j��>�m�1ˢJ؝�۫�
K����� W��k�ٲ�U��q�W�7bs��t�#�p�=r	���*�1xJЦ����E�mp���F~�\53_�F�^K]� f��Z+/:<&���W��K<-|J���<��r!뛲�Xq�Յs�Vl�>�|�f����_��)��^]?���'@!V}2�k߶lga� Ҍ���^ mY[xHqΑ�4�������0#�0Mm="�_1n�Vs�QK�s��}��+�2��#.�N2�C�Q:��J9�|��Q{:�iu�"3��.�ݎ�J������`�M-�Ɔ�"��:}�q��yӣ�5��4�]���8����B0��q�v�1&C��]�9��kGzVG�� ׮4V��v}�{1##� �]o���J"��_��K�V�K��t�s{���S�Q:�=r�6r��z�e0.o剟ԟ��C?��90Z[7�^ �Z���<�AD~���{|/ۺ��ˢ�Ú�H�Nu�V ��~M��<`���Ķ�̫����)�YͫD(��>�Ìb�)�²������'AzS�����#���mC]hx����k�Pno�Mje��ѓ��c(̪S}����E�5�����a5�p>��(�#��Ě�⽸��º6������ �~��	D#Br��@Eq�`g =��!i.|l��z�W��9`�[2�U��Ο��4Wͅ�>+B�{���m>�����~��ƨ:^K-�V
y�x�����ֶ�C(���
����ҕ��y��TeL�a��烕G����w����C��^\!F�K�`�H���Y�8�/�����'�ǅ�!�a�8 ��>�� �T�b����|�^{\���3�"��gŬ�ɕ�s���q�KG�������f��_�ό�B�|r�ﺲ��T��ۛ7�qJ�!��Zv�%8U)+|Q��E6��=�<΂?�:����x|�Ϲym��q�s4�b��3�/? ������?�����w����o��O������B��J[�T����۟~}���?��]�Um���o��_~v�օ�������?�����_����>�~���T�)�o�������~���/?9����ߚ�*ʶ�����������������������((��[�0�t�?��������~���'=ץn�6mܿUE��oWFյ�����t�w��͟~��o~���B      �      x������ � �      �      x������ � �      �      x������ � �      �   �	  x��Y�r۸}���_pK �Gَ��Iƒs+U��`�M����o7 � �Sy���ӧ!Bb�q�nY&��{_V���D�����r�ͱ�ph�v�*\��K��Ŋ���
��,^4�my�DWq�����r�Y�o�%�O����a�`�K��ڽg���.�7�(N!k'\E���;ְ�Ȟ�P���]|�Om�:;V��N���x������ƚ�b0��؉�pࢭ��9�1㍨E�>���<�G'�P�tsi�r��53��~�.��7��sSfm���d	$�j$������+����z(+��k�
;�O^����b�p�����_y��.ئu�K$r���U�
�'�	!�3p�OV��"2V�_Y��㑻���Xt�Z���1�����2p��C��i��`�Hik�o��zS\t���|Ê�9��Ѡ���W�5�.j/4���6�F�s(o�U�����ul1��Vm��o1���7~���;~��4N�JS�C`w#��'0�cm�t�9@~��*����_�,C��}�Rޯ��|�3��GH��J�Q��������qUJ#ݣq���kQ�˶:px�l��䋲��,�a���x�E�~��Y&NB}ۈi͂v���.8�l��}ګ��i,�ٱ}��o,�:��L�-�t1 �*z��X�T��Ҳtٲ�L�q�d��H:y�1	^��t�"�*�5�:'��Q�������|j	��(��V���B�*1U$J;�t����ŁBY�ƷoM�6�rc����0��F�B8T��7�n;�����h��5�\>x]�/��[V��d�W�^�m�G��e%���z�Я�#k$��+�_C�q(V��h��k{Ԉ���c�{�D�H��Q���@(ݘ�&�<�DL|��I�R���Y�ײ1wMp*�f�E].����Z^�%J�g�o�dU_�=�*����٪�<ߗ���՘��A�G|c�p����K؁��,f�N"�~�ɢY�F#�Kw���5�'�̹Un�5�P`5T�B�!:UK���3;`^U�_������<������Zxu���TL�DW_��۱���+\\}g&!��b��Α���R�l�����y��e�W7��1���'$�*�Gq'':��)-� �yi�*M5��x�k�c���$�Q������Ⱦ ���'ɩ(�#ǘ�`�'~�Z �?k�!����q�|��ڿ�mya�ذ�FOK�5z�ww�-j;$k���U�o�v�E.�{vh;>R-�N)؞�����=�����J&}$]��=���\�3R��|��Ceћ�M�m@Ü< �A�Xm  �@�� � D@ Sh*@� ��)2"�܇�3"���T)6�!����H9�K*!�2��zV�`4K7����,FE&��P\������`<��0@�ٛ��"h&6�*"��I�T�X�+پ��v�Y�z������c =l +���0���"3I|`V�����(b�p���D=٧�2���Tw8��=���s�K�C����g�PF.��i�w��l6ꞇ�犌4݄t�{��ߋ|z��%�I��g�% ���|���J3����+1����P�X��d�[Yt{��#�9��<��{/��J�W�D/�ڮ�#�3�T�0�cqn\@�^A�Nˣ+��*�Ed��-�P
4�^�M�C�ڛ���Qe"�m�f.�w��Ġi�}�#2�#�y�.*��~EgS�X�����R�(�H�S��XzSn�E��m(��50k� w`�|M^�[�C+l�0�儁�g�8cDI���}�v(����}�41�$�5��u����M�aT�Q��*G�.��c�� ��Lk���q	�S����1�l�X�!]Y
�T�t(uH$%(�b�N�V{O�"a8��Q(YmP�
�Y0c{��
O>@����Iv@�A9��_���!�6�4Il2�c�B���&mě7A4�m2�V���n�5�"��
�d
�ρ5
�.�1\Oar�&QA����>���6�����$%����A��8-Q�l���ƪN�bAL�>@��C,g���0����?˳�i"k05�w"���0���P���q]o��rL����=m�S�ևF�G+����=�GK���h��>�/��ݔ i��/��40}AL�m��hq�%�M�m.��`O�D�����g�6�ن��+rDO�/�΅��D!z�X�ֆW��#j�dQ$�<AB2�d0�<�a�� 83���+8�'X�(�� 7��q������E������<4 �0�)��k��xl�ǻ��ӹu��<ٵ����Ц@Nd(�l�Yl���@%�cwD c����*���<0�}{�	��>��8�o����)�/���d_�b�/�^� ԏV	v�,�����oe��&�ͳX[�h��کea��h���)�L7�s����J}+��Z�~U�}�����j��?0�2A      �   |   x�3�,��,Vp/�LQp��Q�L)��,IL�I��K�MUpv�Q(N-,M�K
�8K��AK�<�R�SK29�@�,�f��fg��)�%�r������������=... �2/e      �   9   x�3�,�9��(���T�� .# �5/='�8C�Տ��uI--)N�Ppq����� �*         x  x��SKN�0]ϜbN�pZ~K���JbG�6�Z��P��,�܂-�`Wq/܀��
-�Yz���1��Ŵv�	��m��yw�mAW�0�~����%Sn�� b',���.�V�cO��~Nco�vE�=8H��� �G���` �v	#�,(�45�vB�N���!�U%Ր�9����/*����_?�,��/x��/��*x�������AR�:��\�:ņdE�D)�A����C��	���҆�p�	#�E?�ho��Iet�"�u�Z��77��.��܈R�Y���bI��ֵ����2] �v(�c?��P��i|��,���e+1|�� ���+l�ɪ�Y��6�+Kl�Z��(�P.u���>@��n%            x��]Ks9�>ӿ=}�˶l=��FlLPm+��v�7����e��S��y#��i�}و��/}�M���L ��D�URG��z ?d�D� 6{iot�-������7X�x�V�Y,�ߑ^���'{#�<T�{��n��Q�;�:|�X��*�ɵ�4@]�4���t�Dz�D�;Z.A��q75`�Ju��2�A�Ç����/z.̫@�_	쎇Q/*gv/�ϳP�e��P�]�0T���:�PF��ʲ}*౏ݗ��V�8���jaٌ&�d_yx|�㹭$s�P˯97%a�>�U�O�g*N"(�]�y/���'�/x�u�� � Z*%>�:�(����������7+��c0V��B��\��!���`�Xݔ����=�x�����%E��E���X�Tj��{� '��e0�x>��Q,�D��Ȣ�$�v_ei2��C/�JRN�+���o�&P���?��J��w��Q�[����I���J��8롴\�3x�S�/�{��Ż8��쥀�/�-*�g2�y��N����j�t/�c�5+�-*��Z�W����_
"���N=�T�*�Y1�7�uybYS�X&�j*� =�'
4Z��e�����@����k,	z�F	|S�����ń����F\��gP�JpI�z'He��z����U84�A��J��M�U���τy��o6�B#�l52jf�J������
�����&nr�*?�Y?;����'�u�� ީ��	�+��d�Z�v��5�F

慩��)����r,��$�*J����
�E,��T�v^x3ً´R�y^�=�y�PtP�s�$Ѐ.���7��i�^μ���A8v��¾`�0�����Q��25{�ڨAw�rj�k�P�׌O�����20���(��d�˲ѻ�����fp#y(O������U@�!�30�Ç�c�o����L"�$�d�jR��0K�xr���1�@r����*kb����B�h���υyAK�����*T�Mw�U���$V�딶�>��>3������IO$(O�ea�~�όw�p��NO���G��~֧�M�wz�����'g6�d�;|:���ѐ�IrH>���ý��}����=	j3�=�~6��D���{����'5�{A�(��l0≉>�i��N/<I�tj*���w�>]����p䁦�錀� =:�J�ThNpp4��Դ>Og���x�k��IHxz�S�
���H��w���:����ԡ#�p�?��+6�4�B�_[]-S�����"�{��+:����o�T� �G�u�w�/�Q�*h�<K�^�2j���f�/�� ��21�:T�,�}D������|��/��'�ޜ��1pbW����w�-�Fbl���%�TL������<�� �Z����Jz:����&�Qt�ÚZ�g=����Rj`}��� ������K��G���Ĭ�9�����g2In�x"�(���(��;���^�$X��Ug�Ċ�\-���������/_��;q�,&:���9��oH� �n�,���^���	p<�������su3�RW$��ç�5��}��Ō)j�w����F:��>~�T�����Jż�U����G�1J�9X^�_��B���C|�
�K�8.6R[�y�d�Xn���U$%o8m�zM�:WcE�L�d��nL͕P��8���L�b������/3Y41l0)�=5	�RԸP���d=�V"��ne�d�˥��P@\D�V��5�e��[�,���hu+�q�T�s��W�Z��3*�Д�H��c1�Z�#�HC�2_���v�Z�������}g"���R	t�G�x������/��D�r���Jɟ�zXF�8���N�J'�Z�$
c��D�j�y��j�>� \�E*�a��c�F��r� ����4j'h�.��0ȬB�<�MZ�<|6vc[3P�1ֿKAA��̡����c
N��T�%��g����UΛm�fl�_~�7h$�z�N�A��O)��l�@�7Pl�L�,��(nh�߿�lE2ڼGQ$�e���mһ�G4��.�yc�R� �C5�P�=CJ���:5�����Ə��5������L��L����(�qhh~�{�G�^��U݁�TƔ�{1h�X�S T��vh� Ym�������<�(�����(�,�ABy�~8�c�1k��y���Rc�H�TOc�BOrb����Ii��~����/b�Dh�4dĺH�703�ǿ�*�$E����fyS���ߴ�:��u��S�M�i>�I!����S��kcc��� #>V��U�n�Z�,Cv�����R�R��©��Bl�L��O�ƿQ8E��q{E���X��\���@ �;�0ZJ:*��G>6R�B|X,,���+�0� �C�I�����ć@e�n��{���G� Gq�RS��䖳��M�>������RS):Mz�����C�Eǥw?��T\��b憠�Y@7�##B�`(�#�2�I%�p�7*�Q	(	>��\���7��~�|/y�����V�H/̿i'�7�fړ�/n�~¹�+�`��p��Uz�����˵�y4��D@X֛E�;�
=��2� L*l�2�]wť�A"Fr����u����Tjۗi��k%����� �#Cl��P)���`��2JI �N�+��D��z��6���(�#Z�`M�w�v����X�����N��~�X�#����*��S����u�|�2����g==�n:�eKr:X9��6��� ��
����7xci�0�s���`�]T��Y\�@�����N�|%}*��1�ƽ�6�>ܺ{Z0@��j���?P��C�Rڱ�����[&�T����Է��mX�	�h�U�Cը��5�n��&jt��w���iCO���75b�	�kw��6���-Y��^�ƣ�ñ�l�����l���\�W�~�L}xU���55"�v@����[��1�j�Eͅc�ߪ�'�mDخEH�d�p\�=�K�]ص��m��$�eԭ�Po&ASݚ�v��b�@�E�Ӷ삐�mR�h	]�SjS�%"�p��o<�=�Q6=PCŋΜ���s�>��O'�;3�fj���;��m[�oTo0K�T<�헫�.r0?�q�g�D%�����ިT��UT���uV�%m[�TS%�֟��J<O�zT�(D���q5��yR�Hb+��h?9.o=%l��5"���A�'Q�D{�Ek4�W�\�ƣ�䑂��޼�S�0G����&Z�W�;��X�l�� pIc)`���A����9�ϣ�H{A8��(�T��j���Hy*my�ho_������������XC���j�,��`�g[�}g�Ǔ ��_��q\�<������v���6���0���p�'`���M�����6D�wXS���=4�{��N�� /�t���*��$�I�
F�߶�5����6ڀB��~�n�\�r�b�X0<`�`�
d��$�����|��R]P��T�v����-���,�+�·I����uHf=�D-1`SC���Z@�vcc��^%�/YQ���϶�﵎�l����6��c>i��|� �\c�k�|�@Ëٹ'�<�;�"�h��VLz2�X�wC�1���tDz�`��������V��i�{�����W��Dظ�<�s8È�f뇭 `n\Up��n��1$"_p��~��^2�)�m8*'��Y�j��z��2H��[��!"nM�7���\�tEe�h��=���a>���A6�^����jm�� ��:Lc�$�K:��5xjy����H��`b�eoot��\���B<���0x��'�������%�j�nqtlyXK��#�k�Z{�=�b`
�濦̩#�$�XS�l�g�:����L��i9�/'@F�Bebe��ĎY��,h��S:���m����zJ�4c�L�=�ڮ�i��mt��Pj��& �n9���b�L����4S���0�$�$4���7�h..��+�͗b����"�A���qۈfTϦ    �/Rc�l'ь�w�� 7n,ш�ʳ��B��˜"�v�1kcf|��W�-(�د9�|A���fj��^���h����'r^�{;4��;|����R�FD_�j����@�&Sa=-�	�����7B���M��VXY���Ł��&<�<�N�?7�K��א�>����z�k	��
r��p�-��GîäA�[l�nH��-K[����-ꕭ0�"_w܄���^7C��u�]�Y�z�}<�;���u8lYfcr�61�mp�c�ג6!�%]��`M�Zz���=@6~v�U�����TB�#� o�*�q��O�G��hk����-����bF��������-p�T�B[�����  ���C���t�Ф��l��N@�.r2Qf�
/V���f@�\#\\�֌u�"���Y��r0�U�{�'ಡ��d��y������:��G ��L��,W[���W[���HDʍ�bT�m��	väs��#;�4��β�I���\�D.�����;��2��i	���w�v����K0B��Ȥ]�fa���U�J�5������Z"Q��E4�����	w]�`��)���И��ήAG=�� �U�ֹ�QO�A��u�b��
�ֶ;�Q{�,kݱX �
v
�v:��D��u�b�J���]ᘯ�,kݱڌ(�b�i���yb,p_��\3"�(̆��R�~��`�\��F����;x���揺"���guy�S��^vF�������$�u�9/-^s<s[\�$��ĕ�Ǖ����^G?��������n3�f=(��t\Kb�H��ڀh�W�ٲ�J��
�2�n�9,�+o�iKH�0��"V�%4�4]p��P�YTBzZ"���l����IV������m3/gu�`U���̛|L�[�I��(�m�귺�r=��34s��v~���`_0�v���B�n�p?��Wi�Ky��ݛ��?h8\��lk���`���<پ"����8�P<Zl0����O`"0�B��헴+9HhPW0"V��� �{���k���y��uD��/�������}��{�4M�D�a�Ӹ!ŃhBH�٪�|w_�!��mlK]܆um-������J����۳�r2�-�����Y�ָ��L'tl�NfㄆmF+�m���Zl�~b�����u�u���e��ْ��F)̼,'�S���f	�
�<T<�Ť~�`,�`��ơ����|���������������$��ͭW/�M�I��<F�2/��-[�YI�иQ���U,�+� y���نp�p�m���	F�8'*
0):�+�o7[0@7���_}��O'b�]v��]��0c܈^Ȓƛ1[Wg�~�����?��V~��#���.�z���nC�Ȕ��T��K��ֲ�O	�Y����_�nQ���ps���l�&�1eh��J������[���u��/�[&�ͅ��,1L���l�҆]d���C�ϧ0��ν�O�=`�g��Ś��II^�=t�<�]������X��M��Di#7�����*=A/|���[ˬDq��X����y�5��^fAڝ���v^�^��{������ F��l��@E-^��;<�4K=!2;��ꉖ�'�4��2`Ҟu�D�B�sdu~�s�V�M�B����6r�I��>��'���M�;�O��z^;�P���/>�EY?����ߔ#?��)�����sJ�t�4!�c�������*�r]1��EU�����Z�U�O�j����&�*���^M����:�r�̻�.�r���[�X�T�ԙ[q��T��Ϸ-�y����f�M�Cx-΢Eq�ڳ�ܫB�k���*��1 ����� ���\Ŝ�.��o"���B 0�QS�0���*xr��[�$	�͸FY�a�TTS�ٍ/�`���ϔ��1�����0������<���e[n�sIz��q#������/K���:4;�M��$9]nbRۿ,-�s5�n
Ir'�����:q����3iL�����4����eJ��5�[qZ��He�%e�u����kO�#t];���_y^���h9J��غ��s��JG��9��H=e�&g�:�Ǩ��[hN���2?V��\&�\�(h5�fK�ܜ�UOJ�إt?���v���m��X4�Cjt�Y�����gA�x��mϊ�￢C"���T�����xR�� �J�w��ߠ���x5e,IZ6EG��.%��Wc�y==��-�W.k̐��J�G��
5�\�@��`6�-1'r9��,�� ��4X��]�Q�⓮���^�^�b�YK�\alV��)�S�E���On��KeF�fT\O���S9�6|(�7I��Z:�ițFA����tlYP��fe�ݶ:J+;]�IF���8b��L�Е���̹_?�8�ŀ
�!�_�lF�x�N����+�m�⑅�ԩ��8I��P��g��M'��6�5T8������cٓ��z��3����e���	�&�}��K��¸S�e:w���ic"f1��C$���8΂T[ls>�|i@M��\�H�Y/�sk&��r�H�Bs0�YՉ�pl�gz�K����m���L�>�OXW<�ύ?Y��g�����y��3���yw�	��;f�nY�%v$qeV0G����h���Ml�j��*�
�r2pyknŵLĥ����Ţ�Ǿ=w3ɕ։�B��y^�ej�=�I��z١59����L6�Gќɼ�Q�ؖ�X�s�^�7f �,
G���p�7���?fCo&�v��
�u��Bf��^������]������F,
��&��z��0 ⴟ� Yt�i0�ʩ�c%�G�������\U<��;����Y�j�R"���J�����ڲ�a� �'�(!�v��J��8�q�vQp*���$2Qȧ����h�_�Z3�cF|��W�9�ϩDl���'0��R�D��2��)�ցH�[���ՏTLq|0���O��ځ��<�F�G��#��y& ��w���ZA�YE71���W�h�}9��x�Q~��nB���q���l�W0掤�r\�'CqX��ğ��`�n�h�%���T[l������>]��ᡞ|'�t��\�6s��N�
A����.J����JW����y7xa�j	T�Pe���0a<���c(W�fGUi�����F�f�i�K4�toC�ӣ�>�Yx(/3P����6�m�01�h�Ѕ	=�����1X6&7%��\J����y�,~�`ܰ[�K���a{���x%�RYr�|(q@�wf箊3x�}�aA��^;]���j��.�*0���fo_f�0�z昷�f v�����}ٕ�g}6h����Ԍ��\��{��3�cn��G���}:�g��BFF��5�L���MH�29��{��)=Gx�AaD�B,���| 93���k���H�4ߞ��;h��qo>�h&$�@⭜�`��H�\V'��
�.��]�||4t�O�6N����w*LX�|.��&F��T��a�A�1��i]�'=U	9��K�#��9�|��xMP�snǸ�����
�!�5��L�"0�@9�WY�������D�Y��\��a�$�p�N[Z^,b9�f!n}3�X!(��,�����ͬb��!(�%�!""Ʒzg�z64���J��<c�����	H'��웙����"*� �)�ea(���P�q�
��A������D���}3�Y���/v�������=|A�NcB�z{��>
3�Y"�� ��k��9t�~8}��T�c�\C�!��n_a1��J�b�]��kTz��0�1��s�j��zf�A/���z)�b6{-�^5 e0���Z��;Gj��Մ��hnӛ�g��|�h;,�rqs���F+�:���$6�I�v��t��^1N+��Y��3�k�Řu3:tUـ?i-Bc�}��f:�NB�)���X�"���<��@k_�'�6pk�L�.���̄jL��_�����cg��2��FD�^�S^Ǩ����*���N��GW�\�mUto�]xO���ubɂ��L�Vf�/+�ۡ 6   Ѷr���cU����X�l&.`T�ht�]; j��cxw���嗍gϞ�?R���         �   x�]��
�@E��W���vi:��Lm*afZ��B��q�w9�\r��JW,X80L"oBe���m/}��`��h��0��*���V��L5����aM��b��h�������凼��j�(�����Ԩ(�c�ynp� ��/N3� |?"=f      �   �   x�EP�m1|SU��@�&N��"���� ���e���נ,���ȃ 1����h�BB��Irs�lc,<~���7���OeP�6� }�x� 4CG>���0�X�a#��]�g�O$�8�K-ź�Uo8�|����1�1��*�m�5���yb��]�S�������s���*k	�o�z��3��<�kϞ�z�vKg��r$q�Na���]y�?��l�n/J�?��V      �   K   x�3�,�t9���<� .# ����Շ��r�t�q�2�݂}]�����̀� נ`�2c '8�ߛ+F��� b�      �   9   x�3�,���N�J-S0�3�71�w�2�$%*8ee�f�%u��b���� |w5         _   x�3�,�ts�p�42Ӏ�����\� 9�������LL�LM���8�R�2K*3sR2�2s--��s3s���s9�����!W� $ �         A   x�3�,�4bts�p�2	`�Cd,1eL�2�X���e��Ș�e��ȘC�`q[� ��(:          &   x�3�,�ts�p�4�4�34��32�31����� a��      �   )   x�3�,�	�9<'��ȆHWNCKsN��"�4�=... �?�         \   x�3�,�t�>��[���s����"�>�~P7� oO.�����]�@�C}\\��;����(�����x�������<�=... � $     