PGDMP     
                    v            ths_erp_log    9.5.13    9.5.13     U           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            V           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            W           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            X           1262    133746    ths_erp_log    DATABASE     �   CREATE DATABASE ths_erp_log WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Turkish_Turkey.1254' LC_CTYPE = 'Turkish_Turkey.1254';
    DROP DATABASE ths_erp_log;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            Y           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            Z           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        2615    133747    ths_erp2018    SCHEMA        CREATE SCHEMA ths_erp2018;
    DROP SCHEMA ths_erp2018;
             postgres    false                        3079    12355    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            [           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    142446    ayar_barkod_hazirlik_dosya_turu    TABLE       CREATE TABLE ths_erp2018.ayar_barkod_hazirlik_dosya_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(32)
);
 8   DROP TABLE ths_erp2018.ayar_barkod_hazirlik_dosya_turu;
       ths_erp2018         postgres    false    8            �            1259    142449    ayar_barkod_serino_turu    TABLE     ,  CREATE TABLE ths_erp2018.ayar_barkod_serino_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(4),
    aciklama character varying(16)
);
 0   DROP TABLE ths_erp2018.ayar_barkod_serino_turu;
       ths_erp2018         postgres    false    8            �            1259    142452    ayar_barkod_tezgah    TABLE     !  CREATE TABLE ths_erp2018.ayar_barkod_tezgah (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tezgah_adi character varying(32),
    ambar_id integer
);
 +   DROP TABLE ths_erp2018.ayar_barkod_tezgah;
       ths_erp2018         postgres    false    8            �            1259    142455    ayar_barkod_urun_turu    TABLE       CREATE TABLE ths_erp2018.ayar_barkod_urun_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(16)
);
 .   DROP TABLE ths_erp2018.ayar_barkod_urun_turu;
       ths_erp2018         postgres    false    8            �            1259    133780    cins_ozelligi    TABLE       CREATE TABLE ths_erp2018.cins_ozelligi (
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
 &   DROP TABLE ths_erp2018.cins_ozelligi;
       ths_erp2018         postgres    false    8            �            1259    134037 
   stok_grubu    TABLE     �  CREATE TABLE ths_erp2018.stok_grubu (
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
 #   DROP TABLE ths_erp2018.stok_grubu;
       ths_erp2018         postgres    false    8            �            1259    134034    stok_grubu_turu    TABLE       CREATE TABLE ths_erp2018.stok_grubu_turu (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer,
    validity boolean,
    tur character varying(32)
);
 (   DROP TABLE ths_erp2018.stok_grubu_turu;
       ths_erp2018         postgres    false    8            �            1259    133800    urun_kabul_red_nedeni    TABLE     $  CREATE TABLE ths_erp2018.urun_kabul_red_nedeni (
    username character varying(32),
    ip character varying(32),
    tarih timestamp without time zone,
    islem_tipi character varying(16),
    id integer NOT NULL,
    validity boolean NOT NULL,
    deger character varying(64) NOT NULL
);
 .   DROP TABLE ths_erp2018.urun_kabul_red_nedeni;
       ths_erp2018         postgres    false    8            O          0    142446    ayar_barkod_hazirlik_dosya_turu 
   TABLE DATA               r   COPY ths_erp2018.ayar_barkod_hazirlik_dosya_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
    ths_erp2018       postgres    false    186   �#       P          0    142449    ayar_barkod_serino_turu 
   TABLE DATA               t   COPY ths_erp2018.ayar_barkod_serino_turu (username, ip, tarih, islem_tipi, id, validity, tur, aciklama) FROM stdin;
    ths_erp2018       postgres    false    187   r$       Q          0    142452    ayar_barkod_tezgah 
   TABLE DATA               v   COPY ths_erp2018.ayar_barkod_tezgah (username, ip, tarih, islem_tipi, id, validity, tezgah_adi, ambar_id) FROM stdin;
    ths_erp2018       postgres    false    188   �$       R          0    142455    ayar_barkod_urun_turu 
   TABLE DATA               h   COPY ths_erp2018.ayar_barkod_urun_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
    ths_erp2018       postgres    false    189   �$       K          0    133780    cins_ozelligi 
   TABLE DATA               �   COPY ths_erp2018.cins_ozelligi (username, ip, tarih, islem_tipi, id, validity, cins_aile_id, cins, aciklama, string1, string2, string3, string4, string5, string6, string7, string8, string9, string10, string11, string12, is_serino_icerir) FROM stdin;
    ths_erp2018       postgres    false    182   %       N          0    134037 
   stok_grubu 
   TABLE DATA               (  COPY ths_erp2018.stok_grubu (username, ip, tarih, islem_tipi, id, validity, grup, alis_hesabi, satis_hesabi, hammadde_hesabi, mamul_hesabi, kdv_orani_id, tur_id, is_iskonto_aktif, iskonto_satis, iskonto_mudur, is_satis_fiyatini_kullan, yari_mamul_hesabi, is_maliyet_analiz_farkli_db) FROM stdin;
    ths_erp2018       postgres    false    185   r&       M          0    134034    stok_grubu_turu 
   TABLE DATA               b   COPY ths_erp2018.stok_grubu_turu (username, ip, tarih, islem_tipi, id, validity, tur) FROM stdin;
    ths_erp2018       postgres    false    184   �&       L          0    133800    urun_kabul_red_nedeni 
   TABLE DATA               j   COPY ths_erp2018.urun_kabul_red_nedeni (username, ip, tarih, islem_tipi, id, validity, deger) FROM stdin;
    ths_erp2018       postgres    false    183   	)       O   �   x���;n1���^�7����c��HX�aSE�&�0��2J45�D��_��m�,�Ά8.�Wa�H���C�>dETCPS�6��!�e6�ݮ�m�{=��΍�v)���(:�FEO+���f|֌8�pXMY���P汸6����|��%��00���X��o�`��$���Mw��0��� :D/+��пf̌�ɣ�}��Xk��p�o      P   Y   x��K
� ��sn �~�r�Ƞ%�fA�h�$���z9潐6^�ѽ5d����p:8�a�����\W��02�Re�3��2�Yţ�?G��      Q      x������ � �      R      x������ � �      K   M  x���Kn�0@דS���b�s��F��#���	�Co����`�CA��*����Ʊߛ��K�f�(YBh;��3`��&�1�)W)�D+)P�zi��A%p ���]90_7y��G~$N���P`�y�����I��i"9e��<(��f�a���=�%)�亭�Z�aL�%��zo<�8�,b�^��v'��b�!n;ULu*uJ����]�KSV�ͱ� o�ywq�*�q��\]LrW�r�qŢ��q�5{�lݺ�>���$���<�B���6o�%�j�P�e�}e��a�AY#���4�Ys?�ȋ��=M)%\0�lL���C�#Q}se�      N      x������ � �      M   j  x���Mn�0F��)|�(�Cr�������V�(
�=N�3�q��ql�ʢ)iXo�9�o��a�sӏ�O��`?�ejPo@n�ր��C�BN�y|���	ͯf��j*5�VH}���o���@�����~�������n�n�qX~۟�a��u?��}�ux���=qM�y�JKQEӮČ_�o�����üg��^���3�k5�/V�����0�GX�t��Zz�S%����f�����:���38�6��*��W�g�R��O���� B�a>m{3���
y/!/�����î����fO�����[��Aԙ�Q�N����P��H�ف��B�F[FVH����K�8Y��J'.@6p�
��<�ᄮ�+O���蘽�����ު9������e�
�؈J�2�����Osl�4T� ��{�Ѣ�@�	�U���.��`�5
��|iu0Ԯ��M*J�X�w��!55Ae0�D�'��5�=���q� m���bE49���KU,b��R2[zIf>.�����xg3A����)�pk����t����
�s>b�ErW��s����u�� yC�6]�bH_O$5�:�K��CZ��Cّ����ѮV�����      L   q   x���1�0@��9��IL6��	P�V�KpS�V~��ާy\�% ]qc�Xk
�pE>���G�N�¸ly-���#���@#Ydq$�~���={�V;�������Ƙ�C)�     