--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

-- Started on 2018-11-21 17:55:07

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 133747)
-- Name: ths_erp2018; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ths_erp2018;


ALTER SCHEMA ths_erp2018 OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2139 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 186 (class 1259 OID 142446)
-- Name: ayar_barkod_hazirlik_dosya_turu; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.ayar_barkod_hazirlik_dosya_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(32)
);


ALTER TABLE ths_erp2018.ayar_barkod_hazirlik_dosya_turu OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 142449)
-- Name: ayar_barkod_serino_turu; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.ayar_barkod_serino_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(4),
    aciklama character varying(16)
);


ALTER TABLE ths_erp2018.ayar_barkod_serino_turu OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 142452)
-- Name: ayar_barkod_tezgah; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.ayar_barkod_tezgah (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tezgah_adi character varying(32),
    ambar_id integer
);


ALTER TABLE ths_erp2018.ayar_barkod_tezgah OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 142455)
-- Name: ayar_barkod_urun_turu; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.ayar_barkod_urun_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(16)
);


ALTER TABLE ths_erp2018.ayar_barkod_urun_turu OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 133780)
-- Name: cins_ozelligi; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.cins_ozelligi (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    cins_aile_id integer,
    cins character varying(32),
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
    is_serino_icerir boolean
);


ALTER TABLE ths_erp2018.cins_ozelligi OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 134037)
-- Name: stok_grubu; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.stok_grubu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    grup character varying(32),
    alis_hesabi character varying(16),
    satis_hesabi character varying(16),
    hammadde_hesabi character varying(16),
    mamul_hesabi character varying(16),
    kdv_orani_id integer,
    tur_id integer,
    is_iskonto_aktif boolean,
    iskonto_satis double precision,
    iskonto_mudur double precision,
    is_satis_fiyatini_kullan boolean,
    yari_mamul_hesabi character varying(16),
    is_maliyet_analiz_farkli_db boolean
);


ALTER TABLE ths_erp2018.stok_grubu OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 134034)
-- Name: stok_grubu_turu; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.stok_grubu_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(32)
);


ALTER TABLE ths_erp2018.stok_grubu_turu OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 133800)
-- Name: urun_kabul_red_nedeni; Type: TABLE; Schema: ths_erp2018; Owner: postgres
--

CREATE TABLE ths_erp2018.urun_kabul_red_nedeni (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer NOT NULL,
    validity boolean NOT NULL,
    deger character varying(64) NOT NULL
);


ALTER TABLE ths_erp2018.urun_kabul_red_nedeni OWNER TO postgres;

--
-- TOC entry 2127 (class 0 OID 142446)
-- Dependencies: 186
-- Data for Name: ayar_barkod_hazirlik_dosya_turu; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.ayar_barkod_hazirlik_dosya_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
THS_ADMIN	127.0.0.1/32	2018-08-04 04:56:40.944664	INSERT	1	t	BASİT HAZIRLIK DOSYASI
THS_ADMIN	127.0.0.1/32	2018-08-04 04:56:49.474051	INSERT	2	t	TABLO HAZIRLIK DOSYASI
THS_ADMIN	127.0.0.1/32	2018-08-04 04:57:00.283326	INSERT	3	t	KUMANDA SETİ HAZIRLIK DOSYASI
THS_ADMIN	127.0.0.1/32	2018-08-04 15:18:36.526922	UPDATE	3	t	KUMANDA SETİ HAZIRLIK DOSYASI
THS_ADMIN	127.0.0.1/32	2018-08-04 15:30:51.483858	UPDATE	3	t	KUMANDA SETİ HAZIRLIK DOSYASI1
THS_ADMIN	127.0.0.1/32	2018-08-06 08:56:47.349753	UPDATE	2	t	TABLO HAZIRLIK DOSYASI
THS_ADMIN	127.0.0.1/32	2018-08-06 08:57:20.515042	UPDATE	2	t	TABLO HAZIRLIK DOSYASI2
\.


--
-- TOC entry 2128 (class 0 OID 142449)
-- Dependencies: 187
-- Data for Name: ayar_barkod_serino_turu; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.ayar_barkod_serino_turu (username, ip, tarih, islem_tipi, id, validity, tur, aciklama) FROM stdin;
THS_ADMIN	127.0.0.1/32	2018-08-04 04:01:40.590707	UPDATE	3	t	006A	ACT KUMANDA KART
\.


--
-- TOC entry 2129 (class 0 OID 142452)
-- Dependencies: 188
-- Data for Name: ayar_barkod_tezgah; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.ayar_barkod_tezgah (username, ip, tarih, islem_tipi, id, validity, tezgah_adi, ambar_id) FROM stdin;
\.


--
-- TOC entry 2130 (class 0 OID 142455)
-- Dependencies: 189
-- Data for Name: ayar_barkod_urun_turu; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.ayar_barkod_urun_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
\.


--
-- TOC entry 2123 (class 0 OID 133780)
-- Dependencies: 182
-- Data for Name: cins_ozelligi; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.cins_ozelligi (username, ip, tarih, islem_tipi, id, validity, cins_aile_id, cins, aciklama, string1, string2, string3, string4, string5, string6, string7, string8, string9, string10, string11, string12, is_serino_icerir) FROM stdin;
THS_ADMIN	127.0.0.1/32	2018-07-21 05:36:28.865416	UPDATE	67	t	1	A1SD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	QWE	\N	f
THS_ADMIN	127.0.0.1/32	2018-07-21 05:36:50.130146	DELETE	67	t	1	A1SD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	QWE	DS	f
THS_ADMIN	127.0.0.1/32	2018-07-21 05:36:55.739753	INSERT	68	t	1	FF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	DSA	\N	f
THS_ADMIN	127.0.0.1/32	2018-07-21 05:37:08.863867	DELETE	68	t	1	FF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	DSA	\N	f
THS_ADMIN	127.0.0.1/32	2018-07-21 05:37:24.585082	UPDATE	3	t	12	KAPI KUMANDA	\N	TÜR	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	DD	f
THS_ADMIN	127.0.0.1/32	2018-08-06 08:58:06.321456	UPDATE	14	t	1	PANOGÜÇ	TABLO GÜÇ 	KONTAKTÖR	TÜR	EKS	KONTAKTÖR AKIMI	\N	\N	AKIM [A]	GÜÇ [KW]	\N	KONT.BOBİNİ	\N	SERİ	f
THS_ADMIN	127.0.0.1/32	2018-08-06 08:58:35.069218	UPDATE	14	t	1	PANOGÜÇ1	TABLO GÜÇ1	KONTAKTÖR1	TÜR1	EKS1	KONTAKTÖR AKIMI1	2	2	AKIM [A]3	GÜÇ [KW]3	4	KONT.BOBİNİ4	5	SERİ6	f
THS_ADMIN	127.0.0.1/32	2018-08-06 08:59:00.342512	UPDATE	14	t	1	PANOGÜÇ	TABLO GÜÇ	KONTAKTÖR	TÜR	EKS	KONTAKTÖR AKIMI	\N	\N	AKIM [A]	GÜÇ [KW]	\N	KONT.BOBİNİ	\N	SERİ	t
\.


--
-- TOC entry 2126 (class 0 OID 134037)
-- Dependencies: 185
-- Data for Name: stok_grubu; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.stok_grubu (username, ip, tarih, islem_tipi, id, validity, grup, alis_hesabi, satis_hesabi, hammadde_hesabi, mamul_hesabi, kdv_orani_id, tur_id, is_iskonto_aktif, iskonto_satis, iskonto_mudur, is_satis_fiyatini_kullan, yari_mamul_hesabi, is_maliyet_analiz_farkli_db) FROM stdin;
\.


--
-- TOC entry 2125 (class 0 OID 134034)
-- Dependencies: 184
-- Data for Name: stok_grubu_turu; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.stok_grubu_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
THS_ADMIN	127.0.0.1/32	2018-07-22 01:09:50.872478	INSERT	6	t	TEST
THS_ADMIN	127.0.0.1/32	2018-07-22 01:09:54.730285	UPDATE	6	t	TEST
THS_ADMIN	127.0.0.1/32	2018-07-22 01:20:21.117341	DELETE	6	t	TEST GÜNCELLEME İŞLEMİ
POSTGRES	::1/128	2018-08-09 21:51:27.298788	INSERT	7	t	KDV
POSTGRES	::1/128	2018-08-09 21:51:40.222136	UPDATE	4	t	MAMÜL
POSTGRES	::1/128	2018-08-09 21:51:50.678889	INSERT	8	t	HİZMET
POSTGRES	::1/128	2018-08-10 17:03:54.548391	DELETE	8	t	HİZMET
POSTGRES	::1/128	2018-08-10 17:03:54.610582	DELETE	7	t	KDV
POSTGRES	::1/128	2018-08-10 17:03:54.647783	DELETE	5	t	TİCARİ
POSTGRES	::1/128	2018-08-10 17:03:54.683745	DELETE	4	t	MAMUL
POSTGRES	::1/128	2018-08-10 17:03:54.720906	DELETE	3	t	HAMMADDE
POSTGRES	::1/128	2018-08-10 17:03:54.757683	DELETE	2	t	GELİR
POSTGRES	::1/128	2018-08-10 17:03:54.793874	DELETE	1	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:42.14714	INSERT	9	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:45.167767	INSERT	10	t	HAMMADDE
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:48.313808	INSERT	11	t	HİZMET
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:48.395863	INSERT	12	t	KDV
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:48.474603	INSERT	13	t	MAMUL
THS_ADMIN	127.0.0.1/32	2018-08-10 22:17:48.554878	INSERT	14	t	TİCARİ
POSTGRES	::1/128	2018-08-10 22:18:10.643357	DELETE	14	t	TİCARİ
POSTGRES	::1/128	2018-08-10 22:18:10.755508	DELETE	13	t	MAMUL
POSTGRES	::1/128	2018-08-10 22:18:10.833648	DELETE	12	t	KDV
POSTGRES	::1/128	2018-08-10 22:18:10.918276	DELETE	11	t	HİZMET
POSTGRES	::1/128	2018-08-10 22:18:10.995136	DELETE	10	t	HAMMADDE
POSTGRES	::1/128	2018-08-10 22:18:11.071976	DELETE	9	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:19.798023	INSERT	16	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:19.901284	INSERT	17	t	HAMMADDE
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:19.980557	INSERT	18	t	HİZMET
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:20.059062	INSERT	19	t	KDV
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:20.149368	INSERT	20	t	MAMUL
THS_ADMIN	127.0.0.1/32	2018-08-10 22:18:20.226115	INSERT	21	t	TİCARİ
POSTGRES	::1/128	2018-08-10 22:18:37.091436	DELETE	21	t	TİCARİ
POSTGRES	::1/128	2018-08-10 22:18:37.161185	DELETE	20	t	MAMUL
POSTGRES	::1/128	2018-08-10 22:18:37.240991	DELETE	19	t	KDV
POSTGRES	::1/128	2018-08-10 22:18:37.319771	DELETE	18	t	HİZMET
POSTGRES	::1/128	2018-08-10 22:18:37.39874	DELETE	17	t	HAMMADDE
POSTGRES	::1/128	2018-08-10 22:18:37.475584	DELETE	16	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.339381	INSERT	23	t	GELİR
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.445912	INSERT	24	t	GİDER
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.523378	INSERT	25	t	HAMMADDE
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.602601	INSERT	26	t	HİZMET
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.68169	INSERT	27	t	KDV
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.757303	INSERT	28	t	MAMUL
THS_ADMIN	127.0.0.1/32	2018-08-10 22:26:17.834246	INSERT	29	t	TİCARİ
\.


--
-- TOC entry 2124 (class 0 OID 133800)
-- Dependencies: 183
-- Data for Name: urun_kabul_red_nedeni; Type: TABLE DATA; Schema: ths_erp2018; Owner: postgres
--

COPY ths_erp2018.urun_kabul_red_nedeni (username, ip, tarih, islem_tipi, id, validity, deger) FROM stdin;
THS_ADMIN	127.0.0.1/32	2018-07-21 06:15:46.385883	INSERT	7	t	GFD
THS_ADMIN	127.0.0.1/32	2018-07-21 06:18:03.12502	UPDATE	7	t	GFD
THS_ADMIN	127.0.0.1/32	2018-07-21 06:18:16.84898	DELETE	7	t	GFDGFD
THS_ADMIN	127.0.0.1/32	2018-09-27 09:33:49.475886	UPDATE	2	t	EKSİK ÜRÜN
THS_ADMIN	127.0.0.1/32	2018-09-27 09:36:27.468769	UPDATE	2	t	EKSİK ÜRÜN
THS_ADMIN	127.0.0.1/32	2018-09-27 09:36:32.054847	UPDATE	2	t	EKSİK ÜRÜN3
\.


--
-- TOC entry 2138 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-11-21 17:55:07

--
-- PostgreSQL database dump complete
--

