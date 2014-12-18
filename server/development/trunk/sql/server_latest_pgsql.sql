DROP TABLE IF EXISTS allkiri;
DROP TABLE IF EXISTS allyksus;
DROP TABLE IF EXISTS ametikoht;
DROP TABLE IF EXISTS ametikoht_taitmine;
DROP TABLE IF EXISTS asutus;
DROP TABLE IF EXISTS dokumendi_ajalugu;
DROP TABLE IF EXISTS dokumendi_fail;
DROP TABLE IF EXISTS dokumendi_fragment;
DROP TABLE IF EXISTS dokument;
DROP TABLE IF EXISTS ehak;
DROP TABLE IF EXISTS isik;
DROP TABLE IF EXISTS kaust;
DROP TABLE IF EXISTS klassifikaator;
DROP TABLE IF EXISTS klassifikaatori_tyyp;
DROP TABLE IF EXISTS konversioon;
DROP TABLE IF EXISTS logi;
DROP TABLE IF EXISTS oigus_antud;
DROP TABLE IF EXISTS oigus_objektile;
DROP TABLE IF EXISTS parameetrid;
DROP TABLE IF EXISTS saatja;
DROP TABLE IF EXISTS server;
DROP TABLE IF EXISTS staatuse_ajalugu;
DROP TABLE IF EXISTS transport;
DROP TABLE IF EXISTS vahendaja;
DROP TABLE IF EXISTS vastuvotja;
DROP TABLE IF EXISTS vastuvotja_mall;
DROP TABLE IF EXISTS vastuvotja_staatus;


DROP SEQUENCE IF EXISTS sq_allkiri_id;
DROP SEQUENCE IF EXISTS sq_allyksus_id;
DROP SEQUENCE IF EXISTS sq_ametikoht_id;
DROP SEQUENCE IF EXISTS sq_ametikoht_taitmine_id;
DROP SEQUENCE IF EXISTS sq_asutus_id;
DROP SEQUENCE IF EXISTS sq_dokumendi_ajalugu_id;
DROP SEQUENCE IF EXISTS sq_dokumendi_fail_id;
DROP SEQUENCE IF EXISTS sq_dokumendi_fragment_id;
DROP SEQUENCE IF EXISTS sq_dokument_id;
DROP SEQUENCE IF EXISTS sq_isik_id;
DROP SEQUENCE IF EXISTS sq_kaust_id;
DROP SEQUENCE IF EXISTS sq_konv_id;
DROP SEQUENCE IF EXISTS sq_logi_id;
DROP SEQUENCE IF EXISTS sq_oigus_antud_id;
DROP SEQUENCE IF EXISTS sq_oigus_objektile_id;
DROP SEQUENCE IF EXISTS sq_saatja_id;
DROP SEQUENCE IF EXISTS sq_staatuse_ajalugu_id;
DROP SEQUENCE IF EXISTS sq_transport_id;
DROP SEQUENCE IF EXISTS sq_vahendaja_id;
DROP SEQUENCE IF EXISTS sq_vastuvotja_id;
DROP SEQUENCE IF EXISTS sq_vastuvotja_mall_id;

DROP SCHEMA IF EXISTS dvk;
DROP SCHEMA IF EXISTS dvklog;

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE SCHEMA dvk;
CREATE SCHEMA dvklog;

SET dvkxtee.xtee_asutus = '';
SET dvkxtee.xtee_isikukood = '';

SET search_path = dvk, dvklog, pg_catalog;
ALTER USER postgres SET search_path = dvk, dvklog, public;


CREATE SEQUENCE sq_allyksus_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_vahendaja_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_allkiri_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_ametikoht_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_ametikoht_taitmine_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_asutus_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_dokumendi_ajalugu_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_dokumendi_fail_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_dokumendi_fragment_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_dokument_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_isik_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_kaust_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_konv_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 2 CACHE 1;
CREATE SEQUENCE sq_logi_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 4 CACHE 1;
CREATE SEQUENCE sq_oigus_antud_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_oigus_objektile_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_saatja_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_staatuse_ajalugu_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_transport_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_vastuvotja_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;
CREATE SEQUENCE sq_vastuvotja_mall_id INCREMENT 1 MINVALUE 1 NO MAXVALUE START 1 CACHE 1;



CREATE TABLE allkiri (
	allkiri_id integer default nextval('sq_allkiri_id') NOT NULL,
	dokument_id integer NOT NULL,
	eesnimi varchar(50) NULL,
	perenimi varchar(50) NULL,
	isikukood varchar(20) NULL,
	kuupaev timestamp NULL,
	roll varchar(1000) NULL,
	riik varchar(100) NULL,
	maakond varchar(100) NULL,
	linn varchar(100) NULL,
	indeks varchar(20) NULL
) ;
ALTER TABLE allkiri ADD CONSTRAINT allkiri_id_pkey PRIMARY KEY (allkiri_id);


CREATE TABLE allyksus (
	id integer default nextval('sq_allyksus_id') NOT NULL,
	asutus_id integer NOT NULL,
	vanem_id integer NULL,
	allyksus varchar(200) NOT NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL,
	muutm_arv integer NOT NULL DEFAULT 0,
	aar_id integer NULL,
	lyhinimetus varchar(60) NULL,
	adr_uri varchar(500) NULL
);
ALTER TABLE allyksus ADD CONSTRAINT allyksus_pkey_id_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX allyksus_unq_idx ON allyksus (asutus_id, upper(allyksus));
CREATE INDEX allyksus_lyhinimetus_idx ON allyksus (coalesce(lyhinimetus,' '));


CREATE TABLE vahendaja (
	vahendaja_id integer default nextval('sq_vahendaja_id') NOT NULL,
	transport_id integer NOT NULL,
	asutus_id integer NULL,
	ametikoht_id integer NULL,
	isikukood varchar(20) NULL,
	nimi varchar(500) NULL,
	email varchar(100) NULL,
	osakonna_nr varchar(100) NULL,
	osakonna_nimi varchar(500) NULL,
	asutuse_nimi varchar(500) NULL,
	allyksus_id integer NULL,
	allyksuse_lyhinimetus varchar(60) NULL,
	ametikoha_lyhinimetus varchar(25) NULL
) ;
ALTER TABLE vahendaja ADD CONSTRAINT vahendaja_id_pkey PRIMARY KEY (vahendaja_id);


CREATE TABLE oigus_antud (
	oigus_antud_id integer default nextval('sq_oigus_antud_id') NOT NULL,
	asutus_id integer NULL,
	muu_asutus_id integer NULL,
	ametikoht_id integer NULL,
	roll varchar(100) NOT NULL,
	alates timestamp NULL,
	kuni timestamp NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL,
	peatatud smallint DEFAULT 0,
	allyksus_id integer NULL
) ;
ALTER TABLE oigus_antud ADD CONSTRAINT oigus_antud_id_pkey PRIMARY KEY (oigus_antud_id);
CREATE INDEX ametikoht_id_idx ON oigus_antud (ametikoht_id);
CREATE INDEX oigus_antud_asutus_id_idx ON oigus_antud (asutus_id);
CREATE INDEX roll_idx ON oigus_antud (roll);


CREATE TABLE ametikoht (
	ametikoht_id integer default nextval('sq_ametikoht_id') NOT NULL,
	ks_ametikoht_id integer NULL,
	asutus_id integer NOT NULL,
	ametikoht_nimetus varchar(255) NOT NULL,
	alates timestamp NULL,
	kuni timestamp NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL,
	allyksus_id integer NULL,
	params varchar(1000) NULL,
	aar_id integer NULL,
	lyhinimetus varchar(25) NULL
) ;
ALTER TABLE ametikoht ADD CONSTRAINT ametikoht_id_pkey PRIMARY KEY (ametikoht_id);
CREATE INDEX ametikoht_asutus_id_idx ON ametikoht (asutus_id);
CREATE INDEX ks_ametikoht_id_idx ON ametikoht (ks_ametikoht_id);
CREATE INDEX ametikoht_lyhinimetus_idx ON ametikoht (coalesce(lyhinimetus,' '));


CREATE TABLE dokumendi_fragment (
	fragment_id integer default nextval('sq_dokumendi_fragment_id') NOT NULL,
	sissetulev smallint NOT NULL,
	asutus_id integer NOT NULL,
	edastus_id varchar(50) NOT NULL,
	fragment_nr integer NOT NULL,
	fragmente_kokku integer NOT NULL,
	loodud timestamp NULL,
	sisu bytea NULL
) ;
ALTER TABLE dokumendi_fragment ADD CONSTRAINT dokumendi_fragment_fragment_id_pkey PRIMARY KEY (fragment_id);
CREATE INDEX dokumendi_fragment_idx ON dokumendi_fragment (asutus_id,edastus_id,sissetulev);


CREATE TABLE vastuvotja_staatus (
	vastuvotja_staatus_id integer NOT NULL,
	nimetus varchar(100) NOT NULL
) ;
ALTER TABLE vastuvotja_staatus ADD CONSTRAINT vastuvotja_staatus_id_pkey PRIMARY KEY (vastuvotja_staatus_id);


CREATE TABLE klassifikaator (
	klassifikaator_id integer NOT NULL,
	nimetus varchar(1000) NULL,
	klassifikaatori_tyyp_id integer NOT NULL
) ;
ALTER TABLE klassifikaator ADD CONSTRAINT klassifikaator_id_pkey PRIMARY KEY (klassifikaator_id);


CREATE TABLE dokumendi_fail (
	fail_id integer default nextval('sq_dokumendi_fail_id') NOT NULL,
	dokument_id integer NOT NULL,
	nimi varchar(250) NULL,
	suurus integer NULL,
	mime_tyyp varchar(50) NULL,
	sisu text,
	pohifail smallint NOT NULL DEFAULT 0,
	valine_manus smallint NOT NULL DEFAULT 0
) ;
ALTER TABLE dokumendi_fail ADD CONSTRAINT dokumendi_fail_id_pkey PRIMARY KEY (fail_id);


CREATE TABLE vastuvotja_mall (
	vastuvotja_mall_id integer default nextval('sq_vastuvotja_mall_id') NOT NULL,
	asutus_id integer NOT NULL,
	ametikoht_id integer,
	isikukood varchar(20),
	nimi varchar(500),
	email varchar(100),
	osakonna_nr varchar(100),
	osakonna_nimi varchar(500),
	saatmisviis_id integer NOT NULL,
	asutuse_nimi varchar(500),
	allyksus_id integer,
	tingimus_xpath varchar(4000),
	allyksuse_lyhinimetus varchar(60) NULL,
	ametikoha_lyhinimetus varchar(25) NULL
) ;
ALTER TABLE vastuvotja_mall ADD CONSTRAINT vastuvotja_mall_id_pkey PRIMARY KEY (vastuvotja_mall_id);


CREATE TABLE saatja (
	saatja_id integer default nextval('sq_saatja_id') NOT NULL,
	transport_id integer NOT NULL,
	asutus_id integer NULL,
	ametikoht_id integer NULL,
	isikukood varchar(20) NULL,
	nimi varchar(500) NULL,
	email varchar(100) NULL,
	osakonna_nr varchar(100) NULL,
	osakonna_nimi varchar(500) NULL,
	asutuse_nimi varchar(500) NULL,
	allyksus_id integer NULL,
	allyksuse_lyhinimetus varchar(60) NULL,
	ametikoha_lyhinimetus varchar(25) NULL
) ;
ALTER TABLE saatja ADD CONSTRAINT saatja_id_pkey PRIMARY KEY (saatja_id);
CREATE UNIQUE INDEX saatja_transport_id_unq_idx ON saatja (transport_id);
CREATE INDEX saatja_asutus_id_idx ON saatja (asutus_id);


CREATE TABLE parameetrid (
	aar_viimane_sync timestamp NULL
) ;


CREATE TABLE vastuvotja (
	vastuvotja_id integer default nextval('sq_vastuvotja_id') NOT NULL,
	transport_id integer NOT NULL,
	asutus_id integer NOT NULL,
	ametikoht_id integer NULL,
	isikukood varchar(20) NULL,
	nimi varchar(500) NULL,
	email varchar(100) NULL,
	osakonna_nr varchar(100) NULL,
	osakonna_nimi varchar(500) NULL,
	saatmisviis_id integer NOT NULL,
	staatus_id integer NOT NULL,
	saatmise_algus timestamp NULL,
	saatmise_lopp timestamp NULL,
	fault_code varchar(50) NULL,
	fault_actor varchar(250) NULL,
	fault_string varchar(500) NULL,
	fault_detail varchar(2000) NULL,
	vastuvotja_staatus_id integer NULL,
	metaxml text NULL,
	asutuse_nimi varchar(500) NULL,
	allyksus_id integer NULL,
	dok_id_teises_serveris integer NULL,
	allyksuse_lyhinimetus varchar(60) NULL,
	ametikoha_lyhinimetus varchar(25) NULL
) ;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_id_pkey PRIMARY KEY (vastuvotja_id);
CREATE INDEX vastuvotja_transport_id_idx ON vastuvotja (transport_id);
CREATE INDEX vastuvotja_asutus_id_idx ON vastuvotja (asutus_id);


CREATE TABLE staatuse_ajalugu (
	staatuse_ajalugu_id integer default nextval('sq_staatuse_ajalugu_id') NOT NULL,
	vastuvotja_id integer NOT NULL,
	staatus_id integer NOT NULL,
	staatuse_muutmise_aeg timestamp NULL,
	fault_code varchar(50) NULL,
	fault_actor varchar(250) NULL,
	fault_string varchar(500) NULL,
	fault_detail varchar(2000) NULL,
	vastuvotja_staatus_id integer NULL,
	metaxml text NULL
) ;
ALTER TABLE staatuse_ajalugu ADD CONSTRAINT staatuse_ajalugu_id_pkey PRIMARY KEY (staatuse_ajalugu_id);
CREATE INDEX staatuse_ajalugu_vastuvotja_id_idx ON staatuse_ajalugu (vastuvotja_id);


CREATE TABLE dynaamilised_metaandmed (
	dokument_id integer NOT NULL,
	nimi varchar(50) NOT NULL,
	vaartus varchar(2000) NULL
) ;
ALTER TABLE dynaamilised_metaandmed ADD CONSTRAINT dynaamilised_metaandmed_pkey PRIMARY KEY (dokument_id,nimi);


CREATE TABLE isik (
	i_id integer default nextval('sq_isik_id') NOT NULL,
	kood varchar(11) NOT NULL,
	perenimi varchar(30) NOT NULL,
	eesnimi varchar(30) NOT NULL,
	maakond varchar(20) NULL,
	aadress varchar(200) NULL,
	postikood varchar(5) NULL,
	telefon varchar(40) NULL,
	e_post varchar(100) NULL,
	www varchar(100) NULL,
	params varchar(1000) NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL
) ;
COMMENT ON TABLE isik IS 'Sisaldab infot koigi isikute kohta';
COMMENT ON COLUMN isik.params IS 'eelistused';
COMMENT ON COLUMN isik.postikood IS 'Postiindeks';
COMMENT ON COLUMN isik.aadress IS 'Aadress (tanav, maja)';
COMMENT ON COLUMN isik.i_id IS 'Isikute tabeli unikaalne identifikaator';
COMMENT ON COLUMN isik.telefon IS 'telefon';
COMMENT ON COLUMN isik.kood IS 'Isikukood';
COMMENT ON COLUMN isik.e_post IS 'e-posti aadress';
COMMENT ON COLUMN isik.perenimi IS 'Perekonnanimi';
COMMENT ON COLUMN isik.eesnimi IS 'Eesnimi';
COMMENT ON COLUMN isik.www IS 'kodulehekulg';
COMMENT ON COLUMN isik.maakond IS 'Maakond (vald), EHAK alusel';
ALTER TABLE isik ADD CONSTRAINT isiki_id_pkey PRIMARY KEY (i_id);
ALTER TABLE isik ADD UNIQUE (kood);
CREATE INDEX perenimi_idx ON isik (perenimi);


CREATE TABLE ametikoht_taitmine (
	taitmine_id integer default nextval('sq_ametikoht_taitmine_id') NOT NULL,
	ametikoht_id integer NULL,
	i_id integer NULL,
	alates timestamp NULL,
	kuni timestamp NULL,
	roll varchar(10) DEFAULT 'PK',
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL,
	peatatud smallint DEFAULT 0,
	aar_id integer NULL
) ;
ALTER TABLE ametikoht_taitmine ADD CONSTRAINT ametikoht_taitmine_id_pkey PRIMARY KEY (taitmine_id);
CREATE INDEX ametikoht_taitmine_id_idx ON ametikoht_taitmine (ametikoht_id);
CREATE INDEX ametikoht_taitmine_i_id_idx ON ametikoht_taitmine (i_id);


CREATE TABLE asutus (
	asutus_id integer default nextval('sq_asutus_id') NOT NULL,
	registrikood varchar(12) NOT NULL,
	e_registrikood varchar(8) NULL,
	ks_asutus_id integer NULL,
	ks_asutus_kood varchar(20) NULL,
	nimetus varchar(1000) NOT NULL,
	lnimi varchar(20) NULL,
	liik1 varchar(20) NULL,
	liik2 varchar(50) NULL,
	tegevusala varchar(20) NULL,
	tegevuspiirkond varchar(1000) NULL,
	maakond varchar(20) NULL,
	asukoht varchar(20) NULL,
	aadress varchar(1000) NULL,
	postikood varchar(5) NULL,
	telefon varchar(40) NULL,
	faks varchar(40) NULL,
	e_post varchar(100) NULL,
	www varchar(100) NULL,
	logo varchar(500) NULL,
	asutamise_kp timestamp NULL,
	mood_akt_nimi varchar(1000) NULL,
	mood_akt_nr varchar(100) NULL,
	mood_akt_kp timestamp NULL,
	pm_akt_nimi varchar(1000) NULL,
	pm_akt_nr varchar(100) NULL,
	pm_kinnitamise_kp timestamp NULL,
	pm_kande_kp timestamp NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(20) NULL,
	params varchar(2000) NULL,
	dhl_otse_saatmine smallint NULL,
	dhl_saatmine smallint DEFAULT 1,
	dhs_nimetus varchar(150) NULL,
	toetatav_dvk_versioon varchar(20) NULL,
	server_id integer NULL,
	aar_id integer NULL
) ;
COMMENT ON COLUMN asutus.asutus_id IS 'asutuste tabeli primary key';
COMMENT ON COLUMN asutus.registrikood IS 'asutuse registrikood';
COMMENT ON COLUMN asutus.e_registrikood IS 'asutuse varasem registrikood';
COMMENT ON COLUMN asutus.ks_asutus_id IS 'kõrgemalseisva asutuse asutus_id';
COMMENT ON COLUMN asutus.ks_asutus_kood IS 'selle alusel on tekitatud ks_asutus_id. Viitab kõrgemalseisva asutuse väljale registrikood';
COMMENT ON COLUMN asutus.nimetus IS 'asutuse nimetus (suurtähtedega)';
COMMENT ON COLUMN asutus.lnimi IS 'asutuse nime lühend (see väli on meie enda tekitatud ja kasutame sisemisteks vajadusteks näit e-vormide jaoks. täidetud 13 -l asutusel)';
COMMENT ON COLUMN asutus.maakond IS 'asutuse asukoha maakond';
COMMENT ON COLUMN asutus.asukoht IS 'asutuse juriidiline asukoht EHAK klassifikaatori alusel';
COMMENT ON COLUMN asutus.aadress IS 'EHAK klassifikaatori täpsustus (linnas tänava nimi ja maja nr)';
COMMENT ON COLUMN asutus.postikood IS 'postiindeks';
COMMENT ON COLUMN asutus.telefon IS 'asutuse üldtelefoni nr';
COMMENT ON COLUMN asutus.faks IS 'asutuse faksi number';
COMMENT ON COLUMN asutus.e_post IS 'asutuse üldine e-posti aadress';
COMMENT ON COLUMN asutus.www IS 'asutuse veebilehe URL';
COMMENT ON COLUMN asutus.logo IS 'asutuse logo faili nimi RIA failisüsteemis (sisemises kasutuses)';
COMMENT ON COLUMN asutus.asutamise_kp IS 'asutuse asutamise kuupäev';
COMMENT ON COLUMN asutus.mood_akt_nimi IS 'asutuse moodustamise õigusakti nimi';
COMMENT ON COLUMN asutus.mood_akt_nr IS 'asutuse moodustamise akti nr';
COMMENT ON COLUMN asutus.mood_akt_kp IS 'asutuse moodustamise akti kuupäev';
COMMENT ON COLUMN asutus.pm_akt_nimi IS 'põhimääruse õigusakti nimi';
COMMENT ON COLUMN asutus.pm_akt_nr IS 'põhimääruse akti number';
COMMENT ON COLUMN asutus.pm_kinnitamise_kp IS 'põhimääruse akti kuupäev';
COMMENT ON COLUMN asutus.pm_kande_kp IS 'Rahandusministeeriumi registrisse kandmise kuupäev';
COMMENT ON COLUMN asutus.created IS 'selles baasis kirje loomise aeg';
COMMENT ON COLUMN asutus.last_modified IS 'selles baasis kirje viimase muutmise aeg';
COMMENT ON COLUMN asutus.username IS 'selles baasis kirje viimase muutja, selle puudumisel kirje looja isikukood. Isikukoodi puudumisel andmebaasi kasutajanimi';
ALTER TABLE asutus ADD CONSTRAINT asutus_id_pkey PRIMARY KEY (asutus_id);
ALTER TABLE asutus ADD CONSTRAINT asutus_registrikood_un UNIQUE (registrikood);
CREATE INDEX asutuse_nimi ON asutus (nimetus);
CREATE INDEX asutus_ks_asutus_id ON asutus (ks_asutus_id);


CREATE TABLE dokumendi_ajalugu (
	ajalugu_id integer default nextval('sq_dokumendi_ajalugu_id') NOT NULL,
	dokument_id integer NOT NULL,
	metainfo text NULL,
	transport text NULL,
	metaxml text NULL
) ;
ALTER TABLE dokumendi_ajalugu ADD CONSTRAINT dokumendi_ajalugu_id_pkey PRIMARY KEY (ajalugu_id);


CREATE TABLE dokument (
	dokument_id integer default nextval('sq_dokument_id') NOT NULL,
	asutus_id integer NOT NULL,
	kaust_id integer NOT NULL,
	sisu bytea NOT NULL,
	sailitustahtaeg timestamp NULL,
	eelmise_versiooni_id integer NULL,
	suurus bigint NULL,
	guid varchar(36),
	versioon integer DEFAULT 1
) ;
COMMENT ON COLUMN dokument.suurus IS 'Dokumendi suurus baitides.';
COMMENT ON COLUMN dokument.guid IS 'Dokumendi Globaalselt Unikaalne Identifikaator.';
ALTER TABLE dokument ADD CONSTRAINT dokumendi_id_pkey PRIMARY KEY (dokument_id);
CREATE INDEX dokument_asutus_id_idx ON dokument (asutus_id);


CREATE TABLE ehak (
	ehak_id varchar(20) NOT NULL,
	nimi varchar(1000) NOT NULL,
	roopnimi varchar(1000) NULL,
	tyyp varchar(20) NOT NULL,
	maakond varchar(20) NOT NULL,
	vald varchar(20) NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL
) ;
ALTER TABLE ehak ADD CONSTRAINT ehak_id_pkey PRIMARY KEY (ehak_id);
CREATE INDEX ehak_nimi_idx ON ehak (nimi);
CREATE INDEX ehak_maakond_idx ON ehak (maakond);


CREATE TABLE kaust (
	kaust_id integer default nextval('sq_kaust_id') NOT NULL,
	nimi varchar(1000) NULL,
	ylemkaust_id integer NULL,
	asutus_id integer NULL,
	kausta_number varchar(50) NULL
) ;
ALTER TABLE kaust ADD CONSTRAINT kaust_id_pkey PRIMARY KEY (kaust_id);


CREATE TABLE klassifikaatori_tyyp (
	klassifikaatori_tyyp_id integer NOT NULL,
	nimetus varchar(1000) NULL
) ;
ALTER TABLE klassifikaatori_tyyp ADD CONSTRAINT klassifikaatori_id_pkey PRIMARY KEY (klassifikaatori_tyyp_id);


CREATE TABLE oigus_objektile (
	oigus_objektile_id integer default nextval('sq_oigus_objektile_id') NOT NULL,
	asutus_id integer NOT NULL,
	ametikoht_id integer NOT NULL,
	dokument_id integer NULL,
	kaust_id integer NULL,
	kehtib_alates timestamp NULL,
	kehtib_kuni timestamp  NULL
) ;
ALTER TABLE oigus_objektile ADD CONSTRAINT oigus_objektile_id_pkey PRIMARY KEY (oigus_objektile_id);


CREATE TABLE transport (
	transport_id integer default nextval('sq_transport_id') NOT NULL,
	dokument_id integer NOT NULL,
	saatmise_algus timestamp NULL,
	saatmise_lopp timestamp NULL,
	staatus_id integer NULL
) ;
ALTER TABLE transport ADD CONSTRAINT transport_id_pkey PRIMARY KEY (transport_id);
CREATE UNIQUE INDEX dokument_id_unq_idx ON transport (dokument_id);


CREATE TABLE konversioon (
	id integer default nextval('sq_konv_id') NOT NULL,	
	version integer NOT NULL,
	result_version integer NOT NULL,
	xslt text NOT NULL
) ;
ALTER TABLE konversioon ADD CONSTRAINT konversioon_id_pkey PRIMARY KEY (id);


CREATE TABLE logi (
	log_id integer default nextval('sq_logi_id') NOT NULL,
	tabel varchar(100) NULL,
	op varchar(100) NULL,
	uidcol varchar(50) NULL,
	tabel_uid integer NULL,
	veerg varchar(50) NULL,
	ctype varchar(50) NULL,
	vana_vaartus varchar(2000) NULL,
	uus_vaartus varchar(2000) NULL,
	muutmise_aeg timestamp NULL,
	ab_kasutaja varchar(20) NULL,
	ef_kasutaja varchar(20) NULL,
	kasutaja_kood varchar(11) NULL,
	comm varchar(1000) NULL,
	created timestamp NULL,
	last_modified timestamp NULL,
	username varchar(11) NULL,
	ametikoht integer NULL,
	xtee_isikukood varchar(20) NULL,
	xtee_asutus varchar(50) NULL
) ;
ALTER TABLE logi ADD CONSTRAINT logi_id_pkey PRIMARY KEY (log_id);


CREATE TABLE server (
	server_id integer NOT NULL,
	andmekogu_nimi varchar(100) NULL,
	aadress varchar(1000) NULL
) ;
ALTER TABLE server ADD CONSTRAINT server_id_pkey PRIMARY KEY (server_id);


CREATE TABLE dokumendi_metaandmed (
	dokument_id integer NOT NULL,
	koostaja_asutuse_nr varchar(20),
	saaja_asutuse_nr varchar(20),
	koostaja_dokumendinimi varchar(2000),
	koostaja_dokumendityyp varchar(250),
	koostaja_dokumendinr varchar(50),
	koostaja_failinimi varchar(250),
	koostaja_kataloog varchar(1000),
	koostaja_votmesona varchar(1000),
	koostaja_kokkuvote varchar(2000),
	koostaja_kuupaev timestamp,
	koostaja_asutuse_nimi varchar(250),
	koostaja_asutuse_kontakt varchar(1000),
	autori_osakond varchar(250),
	autori_isikukood varchar(11),
	autori_nimi varchar(100),
	autori_kontakt varchar(1000),
	seotud_dokumendinr_koostajal varchar(50),
	seotud_dokumendinr_saajal varchar(50),
	saatja_dokumendinr varchar(50),
	saatja_kuupaev timestamp,
	saatja_asutuse_kontakt varchar(1000),
	saaja_isikukood varchar(11),
	saaja_nimi varchar(100),
	saaja_osakond varchar(250),
	seotud_dhl_id integer,
	kommentaar varchar(4000)
) ;
ALTER TABLE dokumendi_metaandmed ADD CONSTRAINT dokument_meta_id_pkey PRIMARY KEY (dokument_id);


ALTER TABLE allkiri ADD CONSTRAINT allkiri_dokument_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE allyksus ADD CONSTRAINT allyksus_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE CASCADE;
ALTER TABLE allyksus ADD CONSTRAINT allyksus_vanem_id_fkey FOREIGN KEY (vanem_id) REFERENCES allyksus(id) ON DELETE CASCADE;

ALTER TABLE vahendaja ADD CONSTRAINT vahendaja_transport_id_fkey FOREIGN KEY (transport_id) REFERENCES transport (transport_id) ON DELETE CASCADE;
ALTER TABLE vahendaja ADD CONSTRAINT vahendaja_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus (asutus_id) ON DELETE CASCADE;
ALTER TABLE vahendaja ADD CONSTRAINT vahendaja_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht (ametikoht_id) ON DELETE CASCADE;

ALTER TABLE oigus_antud ADD CONSTRAINT oigus_antud_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus (asutus_id) ON DELETE CASCADE;
ALTER TABLE oigus_antud ADD CONSTRAINT oigus_antud_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE CASCADE;

ALTER TABLE ametikoht ADD CONSTRAINT ametikoht_allyksus_id_fkey FOREIGN KEY (allyksus_id) REFERENCES allyksus(id) ON DELETE SET NULL;
ALTER TABLE ametikoht ADD CONSTRAINT ametikoht_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE CASCADE;

ALTER TABLE klassifikaator ADD CONSTRAINT klassifikaator_tyyp_id_fkey FOREIGN KEY (klassifikaatori_tyyp_id) REFERENCES klassifikaatori_tyyp(klassifikaatori_tyyp_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE dokumendi_fail ADD CONSTRAINT dokumendi_fail_document_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE vastuvotja_mall ADD CONSTRAINT vastuvotja_mall_saatmisviis_id_fkey FOREIGN KEY (saatmisviis_id) REFERENCES klassifikaator(klassifikaator_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja_mall ADD CONSTRAINT vastuvotja_mall_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja_mall ADD CONSTRAINT vastuvotja_mall_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja_mall ADD CONSTRAINT vastuvotja_mall_allyksus_id_fkey FOREIGN KEY (allyksus_id) REFERENCES allyksus(id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE saatja ADD CONSTRAINT saatja_transport_id_fkey FOREIGN KEY (transport_id) REFERENCES transport(transport_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE saatja ADD CONSTRAINT saatja_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE saatja ADD CONSTRAINT saatja_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_transport_id_fkey FOREIGN KEY (transport_id) REFERENCES transport(transport_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_saatmisviis_id_fkey FOREIGN KEY (saatmisviis_id) REFERENCES klassifikaator(klassifikaator_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_staatus_id_fkey FOREIGN KEY (staatus_id) REFERENCES klassifikaator(klassifikaator_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vastuvotja ADD CONSTRAINT vastuvotja_vastuvotja_staatus_id_fkey FOREIGN KEY (vastuvotja_staatus_id) REFERENCES vastuvotja_staatus(vastuvotja_staatus_id) ON DELETE SET NULL NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE staatuse_ajalugu ADD CONSTRAINT staatuse_ajalugu_vastuvotja_id_fkey FOREIGN KEY (vastuvotja_id) REFERENCES vastuvotja(vastuvotja_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE staatuse_ajalugu ADD CONSTRAINT staatuse_ajalugu_staatus_id_fkey FOREIGN KEY (staatus_id) REFERENCES klassifikaator(klassifikaator_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE dynaamilised_metaandmed ADD CONSTRAINT dynaamilised_metaandmed_dokument_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE ametikoht_taitmine ADD CONSTRAINT ametikoht_taitmine_i_id_fkey FOREIGN KEY (i_id) REFERENCES isik(i_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE ametikoht_taitmine ADD CONSTRAINT ametikoht_taitmine_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE asutus ADD CONSTRAINT asutus_ks_asutus_id_fkey FOREIGN KEY (ks_asutus_id) REFERENCES asutus(asutus_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE dokumendi_ajalugu ADD CONSTRAINT dokumendi_ajalugu_dokument_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE dokument ADD CONSTRAINT dokument_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE dokument ADD CONSTRAINT dokument_kaust_id_fkey FOREIGN KEY (kaust_id) REFERENCES kaust(kaust_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE dokument ADD CONSTRAINT dokument_eelmise_versiooni_id_fkey FOREIGN KEY (eelmise_versiooni_id) REFERENCES dokument(dokument_id) ON DELETE SET NULL NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE kaust ADD CONSTRAINT kaust_ylemkaust_id_fkey FOREIGN KEY (ylemkaust_id) REFERENCES kaust(kaust_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE kaust ADD CONSTRAINT kaust_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE oigus_objektile ADD CONSTRAINT oigus_objektile_asutus_id_fkey FOREIGN KEY (asutus_id) REFERENCES asutus(asutus_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE oigus_objektile ADD CONSTRAINT oigus_objektile_ametikoht_id_fkey FOREIGN KEY (ametikoht_id) REFERENCES ametikoht(ametikoht_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE oigus_objektile ADD CONSTRAINT oigus_objektile_dokument_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE oigus_objektile ADD CONSTRAINT oigus_objektile_kaust_id_fkey FOREIGN KEY (kaust_id) REFERENCES kaust(kaust_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE transport ADD CONSTRAINT transport_dokument_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE transport ADD CONSTRAINT transport_staatus_id_fkey FOREIGN KEY (staatus_id) REFERENCES klassifikaator(klassifikaator_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE dokumendi_metaandmed ADD CONSTRAINT dokumendi_metaandmed_id_fkey FOREIGN KEY (dokument_id) REFERENCES dokument(dokument_id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;


INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) VALUES(-1, NULL, NULL, NULL, NULL);
INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) VALUES(0, '/', NULL, NULL, NULL);

INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (1, 'Dokumente on puudu (Pooleli)');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (2, 'Järjekorras');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (3, 'Ootel');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (4, 'Lõpetatud');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (5, 'Tagasi lükatud');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (6, 'Teha');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (7, 'Töötlemisel');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (8, 'Aktsepteeritud (Võetud töösse)');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (9, 'Salvestatud');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (10, 'Arhiveeritud');
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) VALUES  (11, 'Saadetud');

INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) VALUES  (1,'Saatmisviis');
INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) VALUES  (2,'Dokumendi olek');

INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) VALUES  (1, 'xtee', 1);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) VALUES  (2, 'epost', 1);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) VALUES  (101, 'saatmisel', 2);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) VALUES  (102, 'saadetud', 2);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) VALUES  (103, 'katkestatud', 2);

INSERT INTO parameetrid(aar_viimane_sync) VALUES (current_date);


CREATE OR REPLACE FUNCTION "Add_Allyksus" (
    p_asutus_id integer,
    p_vanem_id integer,
    p_nimetus character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_muutmiste_arv integer,
    p_aar_id integer,
    p_lyhinimetus character varying,
    p_adr_uri character varying)
RETURNS integer AS $$
DECLARE
    asutus_id_ integer := p_asutus_id;
    vanem_id_ integer := p_vanem_id;
    aar_id_ integer := p_aar_id;
    p_id int4;
BEGIN
    IF asutus_id_ = 0 then
        asutus_id_ := null;
    END IF;
    IF vanem_id_ = 0 then
        vanem_id_ := null;
    END IF;
    IF aar_id_ = 0 then
        aar_id_ := null;
    END IF;
    p_id := nextval('sq_allyksus_id');

    INSERT
    INTO    allyksus(
            id,
            asutus_id,
            vanem_id,
            allyksus,
            created,
            last_modified,
            username,
            muutm_arv,
            aar_id,
            lyhinimetus,
            adr_uri)
    VALUES  (p_id,
            asutus_id_,
            vanem_id_,
            p_nimetus,
            p_created,
            p_last_modified,
            p_username,
            p_muutmiste_arv,
            aar_id_,
            p_lyhinimetus,
            adr_uri);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_AmetikohaTaitmine" (
    p_ametikoht_id integer,
    p_isik_id integer,
    p_alates timestamp,
    p_kuni timestamp,
    p_roll character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_peatatud integer,
    p_aar_id integer)
RETURNS integer AS $$
DECLARE
    ametikoht_id_ integer := p_ametikoht_id;
    isik_id_ integer := p_isik_id;
    aar_id_ integer := p_aar_id;
    p_id int4;
BEGIN
    IF ametikoht_id_ = 0 then
        ametikoht_id_ := null;
    END IF;
    IF isik_id_ = 0 then
        isik_id_ := null;
    END IF;
    IF aar_id_ = 0 then
        aar_id_ := null;
    END IF;

    p_id := nextval('sq_ametikoht_taitmine_id');

    INSERT
    INTO    ametikoht_taitmine(
            taitmine_id,
            ametikoht_id,
            i_id,
            alates,
            kuni,
            roll,
            created,
            last_modified,
            username,
            peatatud,
            aar_id)
    VALUES  (p_id,
            ametikoht_id_,
            isik_id_,
            p_alates,
            p_kuni,
            p_roll,
            p_created,
            p_last_modified,
            p_username,
            p_peatatud,
            aar_id_);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Ametikoht" (
    p_ks_ametikoht_id integer,
    p_asutus_id integer,
    p_nimetus character varying,
    p_alates timestamp,
    p_kuni timestamp,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_allyksus_id integer,
    p_params character varying,
    p_lyhinimetus character varying,
    p_aar_id integer)
RETURNS integer AS $$
DECLARE
    ks_ametikoht_id_ integer := p_ks_ametikoht_id;
    asutus_id_ integer := p_asutus_id;
    allyksus_id_ integer := p_allyksus_id;
    aar_id_ integer := p_aar_id;
    p_id int4;
BEGIN
    IF ks_ametikoht_id_ IS NULL THEN
        ks_ametikoht_id_ := 0;
    END IF;
    IF asutus_id_ IS NULL THEN
        asutus_id_ : := 0;
    END IF;
    IF allyksus_id_ IS NULL THEN
        allyksus_id_ := 0;
    END IF;
    IF aar_id_ IS NULL THEN
        aar_id_ := 0;
    END IF;

    p_id := nextval('sq_ametikoht_id');

    INSERT
    INTO    ametikoht(
            ametikoht_id,
            ks_ametikoht_id,
            asutus_id,
            ametikoht_nimetus,
            alates,
            kuni,
            created,
            last_modified,
            username,
            allyksus_id,
            params,
            lyhinimetus,
            aar_id)
    VALUES  (p_id,
            ks_ametikoht_id_,
            asutus_id_,
            p_nimetus,
            p_alates,
            p_kuni,
            p_created,
            p_last_modified,
            p_username,
            allyksus_id_,
            p_params,
            p_lyhinimetus,
            aar_id_);
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION "Add_Asutus"(
    p_registrikood character varying,
    p_registrikood_vana character varying,
    p_ks_asutus_id integer,
    p_ks_asutus_kood character varying,
    p_nimetus character varying,
    p_nime_lyhend character varying,
    p_liik1 character varying,
    p_liik2 character varying,
    p_tegevusala character varying,
    p_tegevuspiirkond character varying,
    p_maakond character varying,
    p_asukoht character varying,
    p_aadress character varying,
    p_postikood character varying,
    p_telefon character varying,
    p_faks character varying,
    p_e_post character varying,
    p_www character varying,
    p_logo character varying,
    p_asutamise_kp timestamp,
    p_mood_akt_nimi character varying,
    p_mood_akt_nr character varying,
    p_mood_akt_kp timestamp,
    p_pm_akt_nimi character varying,
    p_pm_akt_nr character varying,
    p_pm_kinnitamise_kp timestamp,
    p_pm_kande_kp timestamp,
    p_loodud timestamp,
    p_muudetud timestamp,
    p_muutja character varying,
    p_parameetrid character varying,
    p_dhl_saatmine integer,
    p_dhl_otse_saatmine integer,
    p_dhs_nimetus character varying,
    p_toetatav_dvk_versioon character varying,
    p_server_id integer,
    p_aar_id integer,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS integer AS $$
DECLARE
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus =  p_xtee_asutus;
	
    perform *
    from    asutus
    where   registrikood = p_registrikood
    limit 1;

    if (found) then
        select  a.asutus_id
        into    Add_Asutus.id
        from    asutus a
        where   a.registrikood = p_registrikood
                limit 1;
    else
        p_id := nextval('sq_asutus_id');

        insert
        into    asutus(
                asutus_id,
                registrikood,
                e_registrikood,
                ks_asutus_id,
                ks_asutus_kood,
                nimetus,
                lnimi,
                liik1,
                liik2,
                tegevusala,
                tegevuspiirkond,
                maakond,
                asukoht,
                aadress,
                postikood,
                telefon,
                faks,
                e_post,
                www,
                logo,
                asutamise_kp,
                mood_akt_nimi,
                mood_akt_nr,
                mood_akt_kp,
                pm_akt_nimi,
                pm_akt_nr,
                pm_kinnitamise_kp,
                pm_kande_kp,
                created,
                last_modified,
                username,
                params,
                dhl_saatmine,
                dhl_otse_saatmine,
                dhs_nimetus,
                toetatav_dvk_versioon,
                server_id,
                aar_id)
        values  (p_id,
                p_registrikood,
                p_registrikood_vana,
                p_ks_asutus_id,
                p_ks_asutus_kood,
                p_nimetus,
                p_nime_lyhend,
                p_liik1,
                p_liik2,
                p_tegevusala,
                p_tegevuspiirkond,
                p_maakond,
                p_asukoht,
                p_aadress,
                p_postikood,
                p_telefon,
                p_faks,
                p_e_post,
                p_www,
                p_logo,
                p_asutamise_kp,
                p_mood_akt_nimi,
                p_mood_akt_nr,
                p_mood_akt_kp,
                p_pm_akt_nimi,
                p_pm_akt_nr,
                p_pm_kinnitamise_kp,
                p_pm_kande_kp,
                p_loodud,
                p_muudetud,
                p_muutja,
                p_parameetrid,
                p_dhl_saatmine,
                p_dhl_otse_saatmine,
                p_dhs_nimetus,
                p_toetatav_dvk_versioon,
                p_server_id,
                p_aar_id);

    end if;
    return  p_id;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION "Add_Dokument" (
    p_dokument_id integer,
    p_asutus_id integer,
    p_kaust_id integer,
    p_sisu character varying,
    p_sailitustahtaeg timestamp,
    p_suurus bigint,
    p_versioon integer,
    p_guid character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS void AS $$
BEGIN
  -- Set session scope variables
   set dvkxtee.xtee_isikukood = p_xtee_isikukood;
   set dvkxtee.xtee_asutus = p_xtee_asutus;

  INSERT 
  INTO    dokument (
          dokument_id,
          asutus_id,
          kaust_id,
          sisu,
          sailitustahtaeg,
          suurus,
          versioon,
          guid)
  VALUES( p_dokument_id,
          p_asutus_id,
          p_kaust_id,
          decode(p_sisu, 'hex'),
          p_sailitustahtaeg,
          p_suurus,
          p_versioon,
          p_guid);

END; $$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION "Add_Dokument_Fragment" (
    p_fragment_id integer,
    p_sissetulev integer,
    p_asutus_id integer,
    p_edastus_id character varying,
    p_fragment_nr integer,
    p_fragmente_kokku integer,
    p_loodud timestamp,
    p_sisu bytea,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS void AS $$
BEGIN

  -- Set session scope variables
     set dvkxtee.xtee_isikukood = p_xtee_isikukood;
     set dvkxtee.xtee_asutus = p_xtee_asutus;

  INSERT 
  INTO    dokumendi_fragment (
          fragment_id,
          sissetulev,
          asutus_id,
          edastus_id,
          fragment_nr,
          fragmente_kokku,
          loodud,
          sisu)
  VALUES (p_fragment_id,    
          p_sissetulev,
          p_asutus_id,
          p_edastus_id,
          p_fragment_nr,
          p_fragmente_kokku,
          p_loodud,
          p_sisu);
  
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Folder" (
    p_folder_name character varying,
    p_parent_id integer,
    p_org_id integer,
    p_folder_number character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS integer AS $$
DECLARE
    p_id int4;
BEGIN

    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

    p_id := nextval('sq_kaust_id');

    insert
    into    kaust(
			kaust_id
            nimi,
            ylemkaust_id,
            asutus_id,
            kausta_number)
    values  (p_id
            p_folder_name,
            p_parent_id,
            p_org_id,
            p_folder_number);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;







CREATE OR REPLACE FUNCTION "Add_Isik" (
    p_isikukood character varying,
    p_perenimi character varying,
    p_eesnimi character varying,
    p_maakond character varying,
    p_aadress character varying,
    p_postiindeks character varying,
    p_telefon character varying,
    p_epost character varying,
    p_www character varying,
    p_parameetrid character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying)
RETURNS integer AS $$
DECLARE
    p_id int4;
BEGIN

    p_id := nextval('sq_isik_id');

    insert
    into    isik(
            i_id,
            kood,
            perenimi,
            eesnimi,
            maakond,
            aadress,
            postikood,
            telefon,
            e_post,
            www,
            params,
            created,
            last_modified,
            username)
    values  (p_id,
            p_isikukood,
            p_perenimi,
            p_eesnimi,
            p_maakond,
            p_aadress,
            p_postiindeks,
            p_telefon,
            p_epost,
            p_www,
            p_parameetrid,
            p_created,
            p_last_modified,
            p_username);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Proxy" (
    p_sending_id integer,
    p_organization_id integer,
    p_position_id integer,
    p_division_id integer,
    p_personal_id_code character varying,
    p_email character varying,
    p_name character varying,
    p_organization_name character varying,
    p_department_nr character varying,
    p_department_name character varying,
    p_position_short_name character varying,
    p_division_short_name character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS integer AS $$
DECLARE
    organization_id_ integer := p_organization_id;
    position_id_ integer := p_position_id;
    division_id_ integer := p_division_id;
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

    if organization_id_ is null then
        organization_id_ := 0;
    end if;
    if position_id_ is null then
        position_id_ := 0;
    end if;
    if division_id_ is null then
        division_id_ := 0;
    end if;

    p_id := nextval('sq_vahendaja_id');

    insert
    into    vahendaja(
            vahendaja_id,
            transport_id,
            asutus_id,
            ametikoht_id,
            allyksus_id,
            isikukood,
            nimi,
            asutuse_nimi,
            email,
            osakonna_nr,
            osakonna_nimi,
            ametikoha_lyhinimetus,
            allyksuse_lyhinimetus)
    values  (p_id,
            p_sending_id,
            organization_id_,
            position_id_,
            division_id_,
            p_personal_id_code,
            p_name,
            p_organization_name,
            p_email,
            p_department_nr,
            p_department_name,
            p_position_short_name,
            p_division_short_name);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Sender" (
    p_sending_id integer,
    p_organization_id integer,
    p_position_id integer,
    p_division_id integer,
    p_personal_id_code character varying,
    p_email character varying,
    p_name character varying,
    p_organization_name character varying,
    p_department_nr character varying,
    p_department_name character varying,
    p_position_short_name character varying,
    p_division_short_name character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS integer AS $$
DECLARE
    organization_id_ integer := p_organization_id;
    position_id_ integer := p_position_id;
    division_id_ integer := p_division_id;
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;
	
    if organization_id_ = 0 then
        organization_id_ := null;
    end if;
    if position_id_ = 0 then
        position_id_ := null;
    end if;
    if division_id_ = 0 then
        division_id_ := null;
    end if;
	
    p_id := nextval('sq_saatja_id');

    insert
    into    saatja(
            saatja_id,
            transport_id,
            asutus_id,
            ametikoht_id,
            allyksus_id,
            isikukood,
            nimi,
            asutuse_nimi,
            email,
            osakonna_nr,
            osakonna_nimi,
            allyksuse_lyhinimetus,
            ametikoha_lyhinimetus)
    values  (p_id,
            p_sending_id,
            organization_id_,
            position_id_,
            division_id_,
            p_personal_id_code,
            p_name,
            p_organization_name,
            p_email,
            p_department_nr,
            p_department_name,
            p_division_short_name,
            p_position_short_name);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Add_Sending" (
    p_document_id integer,
    p_sending_start_date timestamp,
    p_sending_end_date timestamp,
    p_send_status_id integer,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)

RETURNS integer AS $$
DECLARE
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;
    
	p_id := nextval('sq_transport_id');

    insert
    into    transport(
            transport_id,
            dokument_id,
            saatmise_algus,
            saatmise_lopp,
            staatus_id)
    values  (p_id,
            p_document_id,
            p_sending_start_date,
            p_sending_end_date,
            p_send_status_id);
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Staatuse_Ajalugu" (
	p_staatuse_ajalugu_id integer,
    p_vastuvotja_id integer,
    p_staatus_id integer,
    p_staatuse_muutmise_aeg timestamp,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_vastuvotja_staatus_id integer,
    p_metaxml text,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)	
RETURNS integer AS $$
DECLARE
    p_id int4;	
BEGIN
  -- Set session scope variables
	set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

  p_id := nextval('sq_staatuse_ajalugu_id');

  INSERT 
  INTO     staatuse_ajalugu (
           staatuse_ajalugu_id,
           vastuvotja_id,
           staatus_id,
           staatuse_muutmise_aeg,
           fault_code,
           fault_actor,
           fault_string,
		fault_detail,
           vastuvotja_staatus_id,
           metaxml)
   VALUES (p_id,
           p_vastuvotja_id,
           p_staatus_id,
           p_staatuse_muutmise_aeg,
           p_fault_code,
           p_fault_actor,
           p_fault_string,
           p_fault_detail,
           p_vastuvotja_staatus_id,
           p_metaxml);   

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Add_Vastuvotja" (
    p_vastuvotja_id integer,
    p_transport_id integer,
    p_asutus_id integer,
    p_ametikoht_id integer,  
    p_allyksus_id integer,
	p_isikukood character varying,
	p_nimi character varying,
    p_asutuse_nimi character varying,
    p_email character varying,
    p_osakonna_nr character varying,
    p_osakonna_nimi character varying,
    p_saatmisviis_id integer,
    p_staatus_id integer,
    p_saatmise_algus timestamp,
    p_saatmise_lopp timestamp,	
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,	
    p_vastuvotja_staatus_id integer,
	p_metaxml text,
	p_dok_id_teises_serveris integer,
    p_allyksuse_lyhinimetus character varying,
    p_ametikoha_lyhinimetus character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS void AS $$
BEGIN

   set dvkxtee.xtee_isikukood = p_xtee_isikukood;
   set dvkxtee.xtee_asutus = p_xtee_asutus;

  INSERT 
  INTO    vastuvotja (
          vastuvotja_id,
          transport_id,
          asutus_id,
          ametikoht_id,
		  isikukood,
		  nimi,
		  email,
		  osakonna_nr,
		  osakonna_nimi,
		  saatmisviis_id,
		  staatus_id,
		  saatmise_algus,
		  saatmise_lopp,
		  fault_code,
		  fault_actor,
		  fault_string,
		  fault_detail,
		  vastuvotja_staatus_id,
		  metaxml,
		  asutuse_nimi,
		  allyksus_id,
		  dok_id_teises_serveris,
		  allyksuse_lyhinimetus,
		  ametikoha_lyhinimetus)
   VALUES (p_vastuvotja_id,          
          p_transport_id,
          p_asutus_id,
          p_ametikoht_id,
		  p_isikukood,
		  p_nimi,
		  p_email,
		  p_osakonna_nr,
		  p_osakonna_nimi,
		  p_saatmisviis_id,
		  p_staatus_id,
		  p_saatmise_algus,
		  p_saatmise_lopp,
		  p_fault_code,
		  p_fault_actor,
		  p_fault_string,
		  p_fault_detail,
		  p_vastuvotja_staatus_id,
		  p_metaxml,
		  p_asutuse_nimi,
		  p_allyksus_id,
		  p_dok_id_teises_serveris,
		  p_allyksuse_lyhinimetus,
		  p_ametikoha_lyhinimetus);
  
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "Delete_Document" (
    p_id integer)
RETURNS void AS $$
BEGIN
    delete
    from    dokument
    where   dokument_id = p_id;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION "Delete_DocumentFragments" (
    organization_id integer,
    delivery_session_id character varying,
    is_incoming integer)
 RETURNS void AS $$
BEGIN
    delete
    from    dokumendi_fragment f
    where   f.asutus_id = organization_id
            and f.edastus_id = delivery_session_id
            and f.sissetulev = is_incoming;
end; $$
LANGUAGE PLPGSQL;


create type get_allyksus_by_aar_id as (
    id integer,
    asutus_id integer,
    vanem_id integer,
    nimetus character varying,
    created timestamp,
    last_modified timestamp,
    username character varying,
    muutmiste_arv integer,
    lyhinimetus character varying,
    adr_uri character varying
);

CREATE OR REPLACE FUNCTION "Get_AllyksusByAarID" (
    p_aar_id integer)
 RETURNS SETOF get_allyksus_by_aar_id AS $$
BEGIN
RETURN QUERY
        select  id,
                asutus_id,
                vanem_id,
                allyksus,
                created,
                last_modified,
                username,
                muutm_arv,
                lyhinimetus,
                adr_uri
        from    allyksus
        where   aar_id = p_aar_id
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION "Get_AllyksusIdByAarID" (
    p_aar_id integer)
returns integer as $$
declare
    p_id integer;
begin
    perform *
    from    allyksus a
    where   a.aar_id = p_aar_id
            LIMIT 1;

    if (found) then
        select  a.id
        into    p_id
        from    allyksus a
        where   a.aar_id = p_aar_id
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;



CREATE OR REPLACE FUNCTION "Get_AllyksusIdByShortName" (
    p_org_id integer,
    p_short_name character varying)
 RETURNS integer AS $$
declare
    p_id integer;
BEGIN
    perform *
    from    allyksus a
    where   a.asutus_id = p_org_id
            and a.lyhinimetus = p_short_name
            LIMIT 1;

    if (found) then
        select  a.id
        into    p_id
        from    allyksus a
        where   a.asutus_id = p_org_id
                and a.lyhinimetus = p_short_name
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;




CREATE OR REPLACE FUNCTION "Get_AllyksusList" (
    p_asutus_id integer,
    p_nimetus character varying)
returns refcursor as $$
declare
    RC1 refcursor;

BEGIN
    -- Allolev keeruline union all konstruktsioon on kasulik
    -- OR operaatori vĆ¤ltimiseks (Oracle puhul vĆ¤ga aeglane)
    open RC1 for
    select  a.*,
            null as ks_allyksuse_lyhinimetus,
            o.registrikood as asutuse_kood
    from    allyksus a, asutus o
    where   a.asutus_id = coalesce(p_asutus_id, a.asutus_id)
    		and o.asutus_id = a.asutus_id
            and a.allyksus = p_nimetus
            and coalesce(a.vanem_id::text, '') = '' union all   
    select  a1.*,
            null as ks_allyksuse_lyhinimetus,
            o1.registrikood as asutuse_kood
    from    allyksus a1, asutus o1
    where   a1.asutus_id = coalesce(p_asutus_id, a1.asutus_id)
    		and o1.asutus_id = a1.asutus_id
            and coalesce(p_nimetus::text, '') = ''
            and coalesce(a1.vanem_id::text, '') = '' union all    
    select  a2.*,
            ksa2.lyhinimetus as ks_allyksuse_lyhinimetus,
            o2.registrikood as asutuse_kood
    from    allyksus a2, asutus o2, allyksus ksa2
    where   a2.asutus_id = coalesce(p_asutus_id, a2.asutus_id)
    		and o2.asutus_id = a2.asutus_id
            and a2.allyksus = p_nimetus
            and a2.vanem_id = ksa2.id union all    
    select  a3.*,
            ksa3.lyhinimetus as ks_allyksuse_lyhinimetus,
            o3.registrikood as asutuse_kood
    from    allyksus a3, asutus o3, allyksus ksa3
    where   a3.asutus_id = coalesce(p_asutus_id, a3.asutus_id)
    		and o3.asutus_id = a3.asutus_id
            and coalesce(p_nimetus::text, '') = ''
            and a3.vanem_id = ksa3.id;

    RETURN RC1;
end;$$
LANGUAGE PLPGSQL;



create type get_ametikoha_taitmine_by_aar_id as (
    id integer,
    ametikoht_id integer,
    isik_id integer,
    alates timestamp,
    kuni timestamp,
    roll character varying,
    created timestamp,
    last_modified timestamp,
    username character varying,
    peatatud integer
);


CREATE OR REPLACE FUNCTION "Get_AmetikohaTaitmineByAarID" (
    p_aar_id integer)
 RETURNS SETOF get_ametikoha_taitmine_by_aar_id AS $$
BEGIN
RETURN QUERY
        select  taitmine_id,
                ametikoht_id,
                i_id,
                alates,
                kuni,
                roll,
                created,
                last_modified,
                username,
                peatatud
        from    ametikoht_taitmine
        where   aar_id = p_aar_id
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION "Get_AmetikohaTaitmineList" (
    p_ametikoht_id integer,
    p_isikukood character varying)

returns refcursor as $$
declare
    RC1 refcursor;
BEGIN
    open RC1 for
    select  a.*
    from    ametikoht_taitmine a
    inner join
            isik i on i.i_id = a.i_id
    where   a.ametikoht_id = p_ametikoht_id
            and i.kood = p_isikukood;
    RETURN RC1;
end;$$
LANGUAGE PLPGSQL;



create type get_ametikoht_by_aar_id as (
    id integer,
    ks_ametikoht_id integer,
    asutus_id integer,
    nimetus character varying,
    alates timestamp,
    kuni timestamp,
    created timestamp,
    last_modified timestamp,
    username character varying,
    allyksus_id character varying,
    params character varying,
    lyhinimetus character varying    
);

CREATE OR REPLACE FUNCTION "Get_AmetikohtByAarID" (
   p_aar_id integer)
 RETURNS SETOF get_ametikoht_by_aar_id AS $$
BEGIN
RETURN QUERY
	select  ametikoht_id,
			ks_ametikoht_id,
			asutus_id,
			ametikoht_nimetus,
			alates,
			kuni,
			created,
			last_modified,
			username,
			allyksus_id,
			params,
			lyhinimetus
	from    ametikoht a
	where   a.aar_id = p_aar_id
			LIMIT 1;
end;
$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_AmetikohtIdByAarID" (
    p_aar_id integer)
 RETURNS integer AS $$
declare
    p_id integer;

BEGIN
    perform *    
    from    ametikoht a
    where   a.aar_id = p_aar_id
            LIMIT 1;

    if (found) then
        select  a.ametikoht_id
        into    p_id
        from    ametikoht a
        where   a.aar_id = p_aar_id
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;





CREATE OR REPLACE FUNCTION "Get_AmetikohtIdByShortName" (
    p_org_id integer,
    p_short_name character varying)
 RETURNS integer AS $$
declare
    p_id integer;

BEGIN
    perform *   
    from    ametikoht a
    where   a.asutus_id = Get_AmetikohtIdByShortName.org_id
            and a.lyhinimetus = Get_AmetikohtIdByShortName.short_name
            LIMIT 1;

   if (found) then
        select  a.ametikoht_id
        into    p_id
        from    ametikoht a
        where   a.asutus_id = p_org_id
                and a.lyhinimetus = p_short_name
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION "Get_AmetikohtList" (
    p_asutus_id integer,
    p_nimetus character varying)
    
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    -- Allolev keeruline union all konstruktsioon on kasulik
    -- OR operaatori vĆ¤ltimiseks (Oracle puhul vĆ¤ga aeglane)
    open RC1 for
     select  a.*,
            null as allyksuse_lyhinimetus,
            o.registrikood as asutuse_kood
    from    ametikoht a, asutus o
    where   a.asutus_id = coalesce(p_asutus_id, a.asutus_id)
    		and o.asutus_id = a.asutus_id
            and a.ametikoht_nimetus = p_nimetus
            and coalesce(a.allyksus_id::text, '') = ''
            and coalesce(a.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
            and coalesce(a.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
    union all
    select  a1.*,
            null as allyksuse_lyhinimetus,
            o1.registrikood as asutuse_kood
    from    ametikoht a1, asutus o1
    where   a1.asutus_id = coalesce(p_asutus_id, a1.asutus_id)
    		and o1.asutus_id = a1.asutus_id
            and coalesce(p_nimetus::text, '') = ''
            and coalesce(a1.allyksus_id::text, '') = ''
            and coalesce(a1.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
            and coalesce(a1.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
    union all
    select  a2.*,
            y2.lyhinimetus as allyksuse_lyhinimetus,
            o2.registrikood as asutuse_kood
    from    ametikoht a2, asutus o2, allyksus y2
    where   a2.asutus_id = coalesce(p_asutus_id, a2.asutus_id)
    		and o2.asutus_id = a2.asutus_id
            and a2.ametikoht_nimetus = p_nimetus
            and y2.id = a2.allyksus_id
            and coalesce(a2.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
            and coalesce(a2.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
    union all
    select  a3.*,
            y3.lyhinimetus as allyksuse_lyhinimetus,
            o3.registrikood as asutuse_kood
    from    ametikoht a3, asutus o3, allyksus y3
    where   a3.asutus_id = coalesce(p_asutus_id, a3.asutus_id)
    		and o3.asutus_id = a3.asutus_id
            and coalesce(p_nimetus::text, '') = ''
            and y3.id = a3.allyksus_id
            and coalesce(a3.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
            and coalesce(a3.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP;
    RETURN RC1;
end;$$
LANGUAGE PLPGSQL;



create type get_asutus_by_id as (

    registrikood character varying,
    registrikood_vana character varying,
    ks_asutus_id integer,
    ks_asutus_kood character varying,
    nimetus character varying,
    nime_lyhend character varying,
    liik1 character varying,
    liik2 character varying,
    tegevusala character varying,
    tegevuspiirkond character varying,
    maakond character varying,
    asukoht character varying,
    aadress character varying,
    postikood character varying,
    telefon character varying,
    faks character varying,
    e_post character varying,
    www character varying,
    logo character varying,
    asutamise_kp timestamp,
    mood_akt_nimi character varying,
    mood_akt_nr character varying,
    mood_akt_kp timestamp,
    pm_akt_nimi character varying,
    pm_akt_nr character varying,
    pm_kinnitamise_kp timestamp,
    pm_kande_kp timestamp,
    loodud timestamp,
    muudetud timestamp,
    muutja character varying,
    parameetrid character varying,
    dhl_saatmine smallint,
    dhl_otse_saatmine smallint,
    dhs_nimetus character varying,
    toetatav_dvk_versioon character varying,
    server_id integer,
    aar_id integer
);

CREATE OR REPLACE FUNCTION "Get_AsutusByID" (
    p_id integer)
 RETURNS SETOF get_asutus_by_id AS $$

BEGIN
RETURN QUERY

        select  a.registrikood,
                a.e_registrikood,
                a.ks_asutus_id,
                a.ks_asutus_kood,
                a.nimetus,
                a.lnimi,
                a.liik1,
                a.liik2,
                a.tegevusala,
                a.tegevuspiirkond,
                a.maakond,
                a.asukoht,
                a.aadress,
                a.postikood,
                a.telefon,
                a.faks,
                a.e_post,
                a.www,
                a.logo,
                a.asutamise_kp,
                a.mood_akt_nimi,
                a.mood_akt_nr,
                a.mood_akt_kp,
                a.pm_akt_nimi,
                a.pm_akt_nr,
                a.pm_kinnitamise_kp,
                a.pm_kande_kp,
                a.created,
                a.last_modified,
                a.username,
                a.params,
                a.dhl_saatmine,
                a.dhl_otse_saatmine,
                a.dhs_nimetus,
                a.toetatav_dvk_versioon,
                a.server_id,
                a.aar_id
        from    asutus a
        where   a.asutus_id = p_id
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;


create type get_asutus_by_regnr as (
	id integer,
	e_registrikood character varying,
	ks_asutus_id integer,
	ks_asutus_kood character varying,
	nimetus character varying,
	lnimi character varying,
	liik1 character varying,
	liik2 character varying,
	tegevusala character varying,
	tegevuspiirkond character varying,
	maakond character varying,
	asukoht character varying,
	aadress character varying,
	postikood character varying,
	telefon character varying,
	faks character varying,
	e_post character varying,
	www character varying,
	logo character varying,
	asutamise_kp timestamp,
	mood_akt_nimi character varying,
	mood_akt_nr character varying,
	mood_akt_kp timestamp,
	pm_akt_nimi character varying,
	pm_akt_nr character varying,
	pm_kinnitamise_kp timestamp,
	pm_kande_kp timestamp,
	created timestamp,
	last_modified timestamp,
	username character varying,
	params character varying,
	dhl_otse_saatmine smallint,
	dhl_saatmine smallint,
	dhs_nimetus character varying,
	toetatav_dvk_versioon character varying,
	server_id integer,
	aar_id integer
);


CREATE OR REPLACE FUNCTION "Get_AsutusByRegNr" (
    p_registrikood character varying)
 RETURNS SETOF get_asutus_by_regnr AS $$

BEGIN
RETURN QUERY

        select  asutus_id,
                e_registrikood,
                ks_asutus_id,
                ks_asutus_kood,
                nimetus,
                lnimi,
                liik1,
                liik2,
                tegevusala,
                tegevuspiirkond,
                maakond,
                asukoht,
                aadress,
                postikood,
                telefon,
                faks,
                e_post,
                www,
                logo,
                asutamise_kp,
                mood_akt_nimi,
                mood_akt_nr,
                mood_akt_kp,
                pm_akt_nimi,
                pm_akt_nr,
                pm_kinnitamise_kp,
                pm_kande_kp,
                created,
                last_modified,
                username,
                params,
                dhl_saatmine,
                dhl_otse_saatmine,
                dhs_nimetus,
                toetatav_dvk_versioon,
                server_id,
                aar_id
        from    asutus
        where   registrikood = p_registrikood
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION "Get_AsutusIdByAarID" (
    p_aar_id integer)
 RETURNS integer AS $$
declare
    p_id integer;

BEGIN
    perform *
    from    asutus a
    where   a.aar_id = p_aar_id;

   if (found) then
        select  a.asutus_id
        into    p_id
        from    asutus a
        where   a.aar_id = p_aar_id
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;





CREATE OR REPLACE FUNCTION "Get_AsutusIdByRegNr" (
    p_registrikood character varying,
    p_dvk_voimeline integer)

 RETURNS integer AS $$
declare
    p_id integer;

BEGIN
    perform * 
    from    asutus a
    where   a.registrikood = p_registrikood
            and (p_dvk_voimeline < 1 or a.dhl_saatmine = 1);

   if (found) then
        select  a.asutus_id
        into    p_id
        from    asutus a
        where   a.registrikood = p_registrikood
                and (p_dvk_voimeline < 1 or a.dhl_saatmine = 1)
                LIMIT 1;
    else
       p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;



CREATE OR REPLACE FUNCTION "Get_AsutusList" ()
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select  *
    from    asutus
    where   dhl_saatmine = 1
            and coalesce(server_id::text, '') = '';
    return RC1;
end;
$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_DocumentFragments" (
    p_organization_id integer,
    p_delivery_session_id character varying,
    p_is_incoming integer)
returns refcursor
as $$
declare
    RC1 refcursor;
BEGIN
    open RC1 for
    select  f.*
    from    dokumendi_fragment f
    where   f.asutus_id = p_organization_id
            and f.edastus_id = p_delivery_session_id
            and f.sissetulev = p_is_incoming
    order by
            f.fragment_nr;
    return RC1;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_DocumentsSentTo" (
    p_organization_id integer,
    p_folder_id integer,
    p_user_id integer,
    p_division_id integer,
    p_division_short_name character varying,
    p_occupation_id integer,
    p_occupation_short_name character varying,
    p_result_limit integer)
returns refcursor
as $$
declare
    division_id_ integer := p_division_id;
    occupation_id_ integer := p_occupation_id;
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dokument d,
    (
        -- Dokumendid, mis adresseeriti pĆ¤ringu teostanud isikule (isikukoodi alusel)
        select  t1.dokument_id
        from    transport t1, vastuvotja v1, isik i1
        where   t1.transport_id = v1.transport_id
                and v1.asutus_id = p_organization_id
                and i1.kood = v1.isikukood
                and i1.i_id = p_user_id
                and v1.staatus_id = 101
                and coalesce(division_id_, coalesce(v1.allyksus_id,0)) = coalesce(v1.allyksus_id,0)
                and coalesce(p_division_short_name, coalesce(v1.allyksuse_lyhinimetus,' ')) = coalesce(v1.allyksuse_lyhinimetus,' ')
                and coalesce(occupation_id_, coalesce(v1.ametikoht_id,0)) = coalesce(v1.ametikoht_id,0)
                and coalesce(p_occupation_short_name, coalesce(v1.ametikoha_lyhinimetus,' ')) = coalesce(v1.ametikoha_lyhinimetus,' ')

        -- Dokumendid, mis adresseeriti pĆ¤ringu teostaja ametikohale (ametikoha ID vĆµi lĆ¼hinimetus)
        union
        select  t2.dokument_id
        from    transport t2, vastuvotja v2
        where   t2.transport_id = v2.transport_id
                and v2.asutus_id = p_organization_id
                and coalesce(v2.allyksus_id::text, '') = ''
                and coalesce(v2.isikukood::text, '') = ''
                and v2.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i2, ametikoht_taitmine akt2, ametikoht ak2
                    where   i2.i_id = p_user_id
                            and ak2.ametikoht_id = v2.ametikoht_id
                            and akt2.i_id = i2.i_id
                            and ak2.ametikoht_id = akt2.ametikoht_id
                            and coalesce(akt2.peatatud, 0) = 0
                            and ak2.asutus_id = v2.asutus_id
                            and coalesce(akt2.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(akt2.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and coalesce(ak2.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(ak2.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                )
                and coalesce(division_id_, coalesce(v2.allyksus_id,0)) = coalesce(v2.allyksus_id,0)
                and coalesce(p_division_short_name, coalesce(v2.allyksuse_lyhinimetus,' ')) = coalesce(v2.allyksuse_lyhinimetus,' ')
                and coalesce(occupation_id_, coalesce(v2.ametikoht_id,0)) = coalesce(v2.ametikoht_id,0)
                and coalesce(p_occupation_short_name, coalesce(v2.ametikoha_lyhinimetus,' ')) = coalesce(v2.ametikoha_lyhinimetus,' ')

        -- Dokumendid, mis adresseeriti pĆ¤ringu teostaja allĆ¼ksusele
        union
        select  t3.dokument_id
        from    transport t3, vastuvotja v3
        where   t3.transport_id = v3.transport_id
                and v3.asutus_id = p_organization_id
                and coalesce(v3.ametikoht_id::text, '') = ''
                and coalesce(v3.isikukood::text, '') = ''
                and v3.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i3, ametikoht_taitmine akt3, ametikoht ak3
                    where   i3.i_id = p_user_id
                            and ak3.allyksus_id = v3.allyksus_id
                            and akt3.i_id = i3.i_id
                            and ak3.ametikoht_id = akt3.ametikoht_id
                            and coalesce(akt3.peatatud, 0) = 0
                            and ak3.asutus_id = v3.asutus_id
                            and coalesce(akt3.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(akt3.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and coalesce(ak3.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(ak3.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                )
                and coalesce(division_id_, coalesce(v3.allyksus_id,0)) = coalesce(v3.allyksus_id,0)
                and coalesce(p_division_short_name, coalesce(v3.allyksuse_lyhinimetus,' ')) = coalesce(v3.allyksuse_lyhinimetus,' ')
                and coalesce(occupation_id_, coalesce(v3.ametikoht_id,0)) = coalesce(v3.ametikoht_id,0)
                and coalesce(p_occupation_short_name, coalesce(v3.ametikoha_lyhinimetus,' ')) = coalesce(v3.ametikoha_lyhinimetus,' ')

        -- Dokumendid, mis adresseeriti pĆ¤ringu teostaja ametikohale
        -- pĆ¤ringu teostaja allĆ¼ksuses (vastupidine juhtum oleks, et
        -- dokument saadeti mĆµnele teisele ametikohale samas allĆ¼ksuses).
        union
        select  t4.dokument_id
        from    transport t4, vastuvotja v4
        where   t4.transport_id = v4.transport_id
                and v4.asutus_id = p_organization_id
                and coalesce(v4.isikukood::text, '') = ''
                and v4.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i4, ametikoht_taitmine akt4, ametikoht ak4
                    where   i4.i_id = p_user_id
                            and ak4.allyksus_id = v4.allyksus_id
                            and ak4.ametikoht_id = v4.ametikoht_id
                            and akt4.i_id = i4.i_id
                            and ak4.ametikoht_id = akt4.ametikoht_id
                            and coalesce(akt4.peatatud, 0) = 0
                            and ak4.asutus_id = v4.asutus_id
                            and coalesce(akt4.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(akt4.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and coalesce(ak4.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(ak4.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                )
                and coalesce(division_id_, coalesce(v4.allyksus_id,0)) = coalesce(v4.allyksus_id,0)
                and coalesce(p_division_short_name, coalesce(v4.allyksuse_lyhinimetus,' ')) = coalesce(v4.allyksuse_lyhinimetus,' ')
                and coalesce(occupation_id_, coalesce(v4.ametikoht_id,0)) = coalesce(v4.ametikoht_id,0)
                and coalesce(p_occupation_short_name, coalesce(v4.ametikoha_lyhinimetus,' ')) = coalesce(v4.ametikoha_lyhinimetus,' ')

        -- Juhul kui tegemist on asutuse administraatoriga
        union
        select  t5.dokument_id
        from    transport t5, vastuvotja v5
        where   t5.transport_id = v5.transport_id
                and v5.asutus_id = p_organization_id
                and v5.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i5, ametikoht_taitmine akt5, ametikoht ak5, oigus_antud oa5
                    where   i5.i_id = p_user_id
                            and akt5.i_id = i5.i_id
                            and ak5.ametikoht_id = akt5.ametikoht_id
                            and oa5.ametikoht_id = akt5.ametikoht_id
                            and coalesce(akt5.peatatud, 0) = 0
                            and coalesce(oa5.peatatud, 0) = 0
                            and oa5.asutus_id = v5.asutus_id
                            and ak5.asutus_id = v5.asutus_id
                            and coalesce(akt5.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(akt5.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and coalesce(oa5.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(oa5.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and coalesce(ak5.alates, LOCALTIMESTAMP + '-1 month'::interval) < LOCALTIMESTAMP
                            and coalesce(ak5.kuni, LOCALTIMESTAMP + '1 month'::interval) > LOCALTIMESTAMP
                            and lower(trim(oa5.roll)) = 'dhl: asutuse administraator'
                )
                and coalesce(division_id_, coalesce(v5.allyksus_id,0)) = coalesce(v5.allyksus_id,0)
                and coalesce(p_division_short_name, coalesce(v5.allyksuse_lyhinimetus,' ')) = coalesce(v5.allyksuse_lyhinimetus,' ')
                and coalesce(occupation_id_, coalesce(v5.ametikoht_id,0)) = coalesce(v5.ametikoht_id,0)
                and coalesce(p_occupation_short_name, coalesce(v5.ametikoha_lyhinimetus,' ')) = coalesce(v5.ametikoha_lyhinimetus,' ')
    ) rights_filter
    where   d.dokument_id = rights_filter.dokument_id
            and
            (
                coalesce(p_folder_id::text, '') = ''
                or d.kaust_id = p_folder_id
            )
			LIMIT p_result_limit;
    return RC1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_DocumentStatusHistory" (
    p_document_id integer)    
returns refcursor
as $$
declare
    RC1 refcursor;
BEGIN
    open RC1 for
    select  a.staatuse_ajalugu_id,
            a.vastuvotja_id,
            a.staatus_id,
            a.staatuse_muutmise_aeg,
            a.fault_code,
            a.fault_actor,
            a.fault_string,
            a.fault_detail,
            a.vastuvotja_staatus_id,
            a.metaxml,
            org.registrikood as asutuse_regnr,
            v.isikukood,
            v.allyksuse_lyhinimetus,
            v.ametikoha_lyhinimetus
    from    staatuse_ajalugu a, vastuvotja v, transport t, asutus org
    where   v.vastuvotja_id = a.vastuvotja_id
            and t.transport_id = v.transport_id
            and org.asutus_id = v.asutus_id
            and t.dokument_id = p_document_id;
    return RC1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_ExpiredDocuments" ()
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select  t.dokument_id,
            t.staatus_id,
            d.sailitustahtaeg
    from    dokument d
    inner join
            transport t on t.dokument_id = d.dokument_id
    where   d.sailitustahtaeg < LOCALTIMESTAMP
            or coalesce(d.sailitustahtaeg::text, '') = '';
    return RC1;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_FolderFullPath" (
    p_folder_id integer)    
 RETURNS character varying AS $$
DECLARE
    
    p_folder_name character varying;
    p_marker integer := p_folder_id;
    p_separator character varying := '';
    p_folder_path character varying := '';
BEGIN
    perform * 
    from    kaust a
    where   a.kaust_id = p_marker;

   if (found) then
        while (p_marker IS NOT NULL AND p_marker::text <> '')
        loop
            select  a.nimi,
                    a.ylemkaust_id
            into    p_folder_name,
                    p_marker
            from    kaust a
            where   a.kaust_id = p_marker;

            p_folder_path := p_folder_name || p_separator || p_folder_path;
            if p_marker > 0 then
                p_separator := '/';
            else
                p_separator := '';
            end if;
        end loop;
    else
        p_folder_path := '';
    end if;
    return p_folder_path;
end;
$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_FolderIdByName" (
    p_folder_name character varying,
    p_organization_id integer,
    p_parent_id integer)
 RETURNS integer AS $$
DECLARE
    p_folder_id integer;
BEGIN
    perform * 
    from    kaust k
    where   upper(k.nimi) = upper(p_folder_name)
            and
            (
                k.asutus_id = p_organization_id
                or coalesce(k.asutus_id::text, '') = ''
            )
            and k.ylemkaust_id = p_parent_id
            LIMIT 1;

   if (found) then
        select  k.kaust_id
        into    p_folder_id
        from    kaust k
        where   upper(k.nimi) = upper(p_folder_name)
                and
                (
                    k.asutus_id = p_organization_id
                    or coalesce(k.asutus_id::text, '') = ''
                )
                and k.ylemkaust_id = p_parent_id
                LIMIT 1;
    else
        p_folder_id := 0;
    end if;
    return p_folder_id;
end;
$$
LANGUAGE PLPGSQL;



create type get_isik_by_code as (
	id integer,
	perenimi character varying,
	eesnimi character varying,
	maakond character varying,
	aadress character varying,
	postiindeks character varying,
	telefon character varying,
	epost character varying,
	www character varying,
	parameetrid character varying,
	loodud timestamp,
	muudetud timestamp,
	muutja character varying
);

CREATE OR REPLACE FUNCTION "Get_IsikByCode" (
    p_isikukood character varying)
 RETURNS SETOF isik AS $$
BEGIN
RETURN QUERY
	select  i_id,
			perenimi,
			eesnimi,
			maakond,
			aadress,
			postikood,
			telefon,
			e_post,
			www,
			params,
			created,
			last_modified,
			username
	from    isik
	where   kood = p_isikukood
			LIMIT 1;
end;
$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_IsikIdByCode" (
    p_isikukood character varying)
 RETURNS integer AS $$
declare
    p_id integer;

BEGIN
    perform * 
    from    isik i
    where   i.kood = p_isikukood;

   if (found) then
        select  i.i_id
        into    p_id
        from    isik i
        where   i.kood = p_isikukood
                LIMIT 1;
    else
        p_id := 0;
    end if;
    return p_id;
end;$$
LANGUAGE PLPGSQL;



create type get_last_dending_by_doc_guid as (
	sending_id integer,
	sending_start_date timestamp,
	sending_end_date timestamp,
	send_status_id integer, 
	document_id integer
);


CREATE OR REPLACE FUNCTION "Get_LastSendingByDocGUID" (
    p_document_guid character varying)

 RETURNS SETOF get_last_dending_by_doc_guid AS $$
BEGIN
RETURN QUERY

        select  t.transport_id,
                t.saatmise_algus,
                t.saatmise_lopp,
                t.staatus_id
        from    transport t
        where   t.transport_id =
                (PERFORM  max(t1.transport_id)                    
                from    transport t1, dokument d2
                where   t1.dokument_id = d2.dokument_id and d2.guid = p_document_guid)                                        
                LIMIT 1;

        select dokument_id
        from dokument
        where guid = p_document_guid;
end;$$
LANGUAGE PLPGSQL;



create type get_last_sending_by_doc_id as (
	sending_id integer,
	sending_start_date timestamp,
	sending_end_date timestamp,
	send_status_id integer
);

CREATE OR REPLACE FUNCTION "Get_LastSendingByDocID" (
    p_document_id integer)
 RETURNS SETOF get_last_sending_by_doc_id AS $$
BEGIN
RETURN QUERY

        select  t.transport_id,
                t.saatmise_algus,
                t.saatmise_lopp,
                t.staatus_id
        from    transport t
        where   t.transport_id =
                (select  max(t1.transport_id)                    
                from    transport t1
                where   t1.dokument_id = p_document_id)                
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_Parameters" ()
 RETURNS timestamp AS $$

declare
    p_aar_last_sync timestamp;

BEGIN
    select  aar_viimane_sync
    into    p_aar_last_sync
    from    parameetrid
    LIMIT 1;

    return p_aar_last_sync;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Get_PersonCurrentDivisionIDs" (
    p_person_id integer,
    p_organization_id integer)
returns refcursor
as $$
declare
    RC1 refcursor;
BEGIN
    open RC1 for
	select  distinct
            a.allyksus_id	
    from    ametikoht a, ametikoht_taitmine b
    where   a.asutus_id = p_organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = p_person_id
            and
            (
                coalesce(b.peatatud::text, '') = ''
                or b.peatatud = 0
            )
            and
            (
                coalesce(b.alates::text, '') = ''
                or b.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(b.kuni::text, '') = ''
                or b.kuni >= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.alates::text, '') = ''
                or a.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.kuni::text, '') = ''
                or a.kuni >= LOCALTIMESTAMP
            );
      return RC1;
end;$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION "Get_PersonCurrentPositionIDs" (
    p_person_id integer,
    p_organization_id integer)

returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
	select  a.ametikoht_id
    from    ametikoht a, ametikoht_taitmine b
    where   a.asutus_id = p_organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = p_person_id
            and
            (
                coalesce(b.peatatud::text, '') = ''
                or b.peatatud = 0
            )
            and
            (
                coalesce(b.alates::text, '') = ''
                or b.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(b.kuni::text, '') = ''
                or b.kuni >= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.alates::text, '') = ''
                or a.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.kuni::text, '') = ''
                or a.kuni >= LOCALTIMESTAMP
            );
    return RC1;
end;$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION "Get_PersonCurrentRoles" (
    p_person_id integer,
    p_organization_id integer)
returns refcursor
as $$
declare
    RC1 refcursor;
BEGIN
    open RC1 for    
    select  distinct a.roll	
    from    oigus_antud a, ametikoht_taitmine b
    where   a.asutus_id = p_organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = p_person_id
            and
            (
                coalesce(b.peatatud::text, '') = ''
                or b.peatatud = 0
            )
            and
            (
                coalesce(b.alates::text, '') = ''
                or b.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(b.kuni::text, '') = ''
                or b.kuni >= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.alates::text, '') = ''
                or a.alates <= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.kuni::text, '') = ''
                or a.kuni >= LOCALTIMESTAMP
            )
            and
            (
                coalesce(a.peatatud::text, '') = ''
                or a.peatatud = 0
            );
    return RC1;
end;$$
LANGUAGE PLPGSQL;








create type get_proxy_by_sending_id as (
    proxy_id integer,
    organization_id integer,
    position_id integer,
    division_id integer,
    personal_id_code character varying,
    name character varying,
    organization_name character varying,
    email character varying,
    department_nr character varying,
    department_name character varying,
    position_short_name character varying,
    division_short_name character varying
);

CREATE OR REPLACE FUNCTION "Get_ProxyBySendingID" (
    p_sending_id integer)   
 RETURNS SETOF get_proxy_by_sending_id AS $$

BEGIN
RETURN QUERY
        select  v.vahendaja_id,
                v.asutus_id,
                v.ametikoht_id,
                v.allyksus_id,
                v.isikukood,
                v.nimi,
                v.asutuse_nimi,
                v.email,
                v.osakonna_nr,
                v.osakonna_nimi,
                v.ametikoha_lyhinimetus,
                v.allyksuse_lyhinimetus
        from    vahendaja v
        where   v.transport_id = p_sending_id
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_Recipients" (
    p_sending_id integer)
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select v.*
    from    vastuvotja v
    where   v.transport_id = p_sending_id;
    return RC1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_RecipientTemplates" ()
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
	select  v.*    
    from    vastuvotja_mall v
    order by
            v.vastuvotja_mall_id;
    return RC1;
end;$$
LANGUAGE PLPGSQL;



create type get_sender_by_sending_id as (
	
    sending_id integer,
    organization_id integer,
    position_id integer,
    division_id integer,
    personal_id_code character varying,
    name character varying,
    organization_name character varying,
    email character varying,
    department_nr character varying,
    department_name character varying,
    position_short_name character varying,
    division_short_name character varying
);

CREATE OR REPLACE FUNCTION "Get_SenderBySendingID" (
    p_sending_id integer)
 RETURNS SETOF get_sender_by_sending_id AS $$
BEGIN
RETURN QUERY
    select  s.saatja_id,
            s.asutus_id,
            s.ametikoht_id,
            s.allyksus_id,
            s.isikukood,
            s.nimi,
            s.asutuse_nimi,
            s.email,
            s.osakonna_nr,
            s.osakonna_nimi,
            s.allyksuse_lyhinimetus,
            s.ametikoha_lyhinimetus
    from    saatja s
    where   s.transport_id = p_sending_id
            LIMIT 1;
end;$$
LANGUAGE PLPGSQL;



create type get_server_by_id as (
	andmekogu_nimi character varying,
	aadress character varying
);

CREATE OR REPLACE FUNCTION "Get_ServerByID" (
    p_server_id integer)
 RETURNS SETOF get_server_by_id AS $$
BEGIN
RETURN QUERY
        select  s.andmekogu_nimi,
                s.aadress
        from    server s
        where   s.server_id = p_server_id
                LIMIT 1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Get_Servers" ()
returns refcursor
as $$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select  s.*
    from    server s;
    return RC1;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Save_Parameters" (
    p_aar_last_sync timestamp)
 RETURNS VOID AS $$
BEGIN
    update  parameetrid
    set     aar_viimane_sync = p_aar_last_sync;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Update_Allyksus" (
    p_id integer,
    p_asutus_id integer,
    p_vanem_id integer,
    p_nimetus character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_muutmiste_arv integer,
    p_aar_id integer,
    p_lyhinimetus character varying,
    p_adr_uri character varying)
 RETURNS VOID AS $$
DECLARE

asutus_id_ integer := p_asutus_id;
vanem_id_ integer := p_vanem_id;
aar_id_ integer := p_aar_id;

BEGIN
    if asutus_id_ = 0 then
        asutus_id_ := null;
    end if;
    if vanem_id_ = 0 then
        vanem_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    update  allyksus
    set     asutus_id = asutus_id_,
            vanem_id = vanem_id_,
            allyksus = p_nimetus,
            created = p_created,
            last_modified = p_last_modified,
            username = p_username,
            muutm_arv = p_muutmiste_arv,
            aar_id = aar_id_,
            lyhinimetus = p_lyhinimetus,
            adr_uri = p_adr_uri
    where   id = p_id;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Update_AmetikohaTaitmine" (
    p_id integer,
    p_ametikoht_id integer,
    p_isik_id integer,
    p_alates timestamp,
    p_kuni timestamp,
    p_roll character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_peatatud integer,
    p_aar_id integer)
 RETURNS VOID AS $$
DECLARE

    ametikoht_id_ integer := p_ametikoht_id;
    isik_id_ integer := p_isik_id;
    aar_id_ integer := p_aar_id;

BEGIN
    if ametikoht_id_ = 0 then
        ametikoht_id_ := null;
    end if;
    if isik_id_ = 0 then
        isik_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    update  ametikoht_taitmine
    set     ametikoht_id = ametikoht_id_,
            i_id = isik_id_,
            alates = p_alates,
            kuni = p_kuni,
            roll = p_roll,
            created = p_created,
            last_modified = p_last_modified,
            username = p_username,
            peatatud = p_peatatud,
            aar_id = aar_id_
    where   taitmine_id = p_id;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Update_Ametikoht" (
    p_id integer,
    p_ks_ametikoht_id integer,
    p_asutus_id integer,
    p_nimetus character varying,
    p_alates timestamp,
    p_kuni timestamp,
    p_created timestamp,
    p_last_modified timestamp,
    p_username text,
    p_allyksus_id integer,
    p_params character varying,
    p_lyhinimetus character varying,
    p_aar_id integer)
 RETURNS VOID AS $$
DECLARE

    ks_ametikoht_id_ integer := p_ks_ametikoht_id;
    asutus_id_ integer := p_asutus_id;
    allyksus_id_ integer := p_allyksus_id;
    aar_id_ integer := p_aar_id;

BEGIN
    if ks_ametikoht_id_ is null then
        ks_ametikoht_id_ := 0;
    end if;
    if asutus_id_ is null then
        asutus_id_ := 0;
    end if;
    if allyksus_id_ is null then
        allyksus_id_ := 0;
    end if;
    if aar_id_ is null then
        aar_id_ := 0;
    end if;

    update  ametikoht
    set     ks_ametikoht_id = ks_ametikoht_id_,
            asutus_id = asutus_id_,
            ametikoht_nimetus = p_nimetus,
            alates = p_alates,
            kuni = p_kuni,
            created = p_created,
            last_modified = p_last_modified,
            username = p_username,
            allyksus_id = allyksus_id_,
            params = p_params,
            lyhinimetus = p_lyhinimetus,
            aar_id = aar_id_
    where   ametikoht_id = p_id;
end;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION "Update_Asutus" (
    p_id integer,
    p_registrikood character varying,
    p_registrikood_vana character varying,
    p_ks_asutus_id integer,
    p_ks_asutus_kood character varying,
    p_nimetus character varying,
    p_nime_lyhend character varying,
    p_liik1 character varying,
    p_liik2 character varying,
    p_tegevusala character varying,
    p_tegevuspiirkond character varying,
    p_maakond character varying,
    p_asukoht character varying,
    p_aadress character varying,
    p_postikood character varying,
    p_telefon character varying,
    p_faks character varying,
    p_e_post character varying,
    p_www character varying,
    p_logo character varying,
    p_asutamise_kp timestamp,
    p_mood_akt_nimi character varying,
    p_mood_akt_nr character varying,
    p_mood_akt_kp timestamp,
    p_pm_akt_nimi character varying,
    p_pm_akt_nr character varying,
    p_pm_kinnitamise_kp timestamp,
    p_pm_kande_kp timestamp,
    p_loodud timestamp,
    p_muudetud timestamp,
    p_muutja character varying,
    p_parameetrid character varying,
    p_dhl_saatmine integer,
    p_dhl_otse_saatmine integer,
    p_dhs_nimetus character varying,
    p_toetatav_dvk_versioon character varying,
    p_server_id integer,
    p_aar_id integer,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
 RETURNS VOID AS $$
BEGIN

    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

    update  asutus
    set     registrikood = p_registrikood,
            e_registrikood = p_registrikood_vana,
            ks_asutus_id = p_ks_asutus_id,
            ks_asutus_kood = p_ks_asutus_kood,
            nimetus = p_nimetus,
            lnimi = p_nime_lyhend,
            liik1 = p_liik1,
            liik2 = p_liik2,
            tegevusala = p_tegevusala,
            tegevuspiirkond = p_tegevuspiirkond,
            maakond = p_maakond,
            asukoht = p_asukoht,
            aadress = p_aadress,
            postikood = p_postikood,
            telefon = p_telefon,
            faks = p_faks,
            e_post = p_e_post,
            www = p_www,
            logo = p_logo,
            asutamise_kp = p_asutamise_kp,
            mood_akt_nimi = p_mood_akt_nimi,
            mood_akt_nr = p_mood_akt_nr,
            mood_akt_kp = p_mood_akt_kp,
            pm_akt_nimi = p_pm_akt_nimi,
            pm_akt_nr = p_pm_akt_nr,
            pm_kinnitamise_kp = p_pm_kinnitamise_kp,
            pm_kande_kp = p_pm_kande_kp,
            created = p_loodud,
            last_modified = p_muudetud,
            username = p_muutja,
            params = p_parameetrid,
            dhl_saatmine = p_dhl_saatmine,
            dhl_otse_saatmine = p_dhl_otse_saatmine,
            dhs_nimetus = p_dhs_nimetus,
            toetatav_dvk_versioon = p_toetatav_dvk_versioon,
            server_id = p_server_id,
            aar_id = p_aar_id
    where   asutus_id = p_id;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Update_DocumentExpirationDate" (
    document_id integer,
    expiration_date timestamp)
 RETURNS VOID AS $$
BEGIN
    update  dokument
    set     sailitustahtaeg = p_expiration_date
    where   dokument_id = p_document_id;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Update_Isik" (
    p_id integer,
    p_isikukood character varying,
    p_perenimi character varying,
    p_eesnimi character varying,
    p_maakond character varying,
    p_aadress character varying,
    p_postiindeks character varying,
    p_telefon character varying,
    p_epost character varying,
    p_www character varying,
    p_parameetrid character varying,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying)
 RETURNS VOID AS $$
BEGIN
    update  isik
    set     kood = p_isikukood,
            perenimi = p_perenimi,
            eesnimi = p_eesnimi,
            maakond = p_maakond,
            aadress = p_aadress,
            postikood = p_postiindeks,
            telefon = p_telefon,
            e_post = p_epost,
            www = p_www,
            params = p_parameetrid,
            created = p_created,
            last_modified = p_last_modified,
            username = p_username
    where   i_id = p_id;
end;$$
LANGUAGE PLPGSQL;





CREATE OR REPLACE FUNCTION "Update_Sending" (
    p_sending_id integer,
    p_document_id integer,
    p_sending_start_date timestamp,
    p_sending_end_date timestamp,
    p_send_status_id integer)
 RETURNS VOID AS $$
BEGIN
    update  transport
    set     dokument_id = p_document_id,
            saatmise_algus = p_sending_start_date,
            saatmise_lopp = p_sending_end_date,
            staatus_id = p_send_status_id
    where   transport_id = p_sending_id;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION "Update_Vastuvotja" (
    p_vastuvotja_id integer,
    p_transport_id integer,
    p_asutus_id integer,
    p_ametikoht_id integer,
    p_isikukood character varying,
    p_nimi character varying,
    p_email character varying,
    p_osakonna_nr character varying,
    p_osakonna_nimi character varying,
    p_saatmisviis_id integer,
    p_staatus_id integer,
    p_saatmise_algus timestamp,
    p_saatmise_lopp timestamp,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_vastuvotja_staatus_id integer,
    p_metaxml text,
    p_asutuse_nimi character varying,
    p_allyksus_id integer,
    p_dok_id_teises_serveris integer,
    p_allyksuse_lyhinimetus character varying,
    p_ametikoha_lyhinimetus character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)

  RETURNS VOID AS $$
BEGIN

  -- Set session scope variables
	set dvkxtee.xtee_isikukood = p_xtee_isikukood;
	set dvkxtee.xtee_asutus = p_xtee_asutus;

  UPDATE  vastuvotja set
          transport_id = p_transport_id,
          asutus_id = p_asutus_id,
          ametikoht_id = p_ametikoht_id,
          isikukood = p_isikukood,
		  nimi = p_nimi,
		  email = p_email,
		  osakonna_nr = p_osakonna_nr,
		  osakonna_nimi = p_osakonna_nimi,
		  saatmisviis_id = p_saatmisviis_id,
		  staatus_id = p_staatus_id,
		  saatmise_algus = p_saatmise_algus,
		  saatmise_lopp = p_saatmise_lopp,
		  fault_code =  p_fault_code,
		  fault_actor = p_fault_actor,
		  fault_string = p_fault_string,
		  fault_detail = p_fault_detail,
		  vastuvotja_staatus_id = p_vastuvotja_staatus_id,
		  metaxml = p_metaxml,
		  asutuse_nimi = p_asutuse_nimi,
		  allyksus_id = p_allyksus_id,
		  dok_id_teises_serveris = p_dok_id_teises_serveris,
		  allyksuse_lyhinimetus = p_allyksuse_lyhinimetus,
		  ametikoha_lyhinimetus = p_ametikoha_lyhinimetus
  WHERE vastuvotja_id = p_vastuvotja_id ;

END;$$
LANGUAGE PLPGSQL;



create type get_asutus_status as (
    vastuvotmata_dokumente bigint,
    vahetatud_dokumente bigint
);


CREATE OR REPLACE FUNCTION "Get_AsutusStat" (
    p_asutus_id integer)
 RETURNS get_asutus_status AS $$

 DECLARE
     gas get_asutus_status;
BEGIN
    select  count(*)
    into    gas.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = p_asutus_id
            and staatus_id = 101;

    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = p_asutus_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = p_asutus_id
            )
    into    gas.vahetatud_dokumente;
	return gas;    
end;$$
LANGUAGE PLPGSQL;



create type get_allyksus_stat as (
    vastuvotmata_dokumente bigint,
    vahetatud_dokumente bigint
);


CREATE OR REPLACE FUNCTION "Get_AllyksusStat" (
    p_asutus_id integer,
    p_allyksus_id integer)
 RETURNS get_allyksus_stat AS $$
 DECLARE
     gasl get_allyksus_stat;     
BEGIN
    select  count(*)
    into    gasl.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = p_asutus_id
            and allyksus_id = p_allyksus_id
            and staatus_id = 101;

    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = p_asutus_id
                        and allyksus_id = p_allyksus_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = p_asutus_id
                        and allyksus_id = p_allyksus_id
            )
    into    gasl.vahetatud_dokumente;
	return gasl;
end;$$
LANGUAGE PLPGSQL;



create type get_ametikoht_stat as (
    vastuvotmata_dokumente bigint,
    vahetatud_dokumente bigint
);


CREATE OR REPLACE FUNCTION "Get_AmetikohtStat" (
    p_asutus_id integer,
    p_ametikoht_id integer)
  RETURNS get_ametikoht_stat AS $$

  DECLARE
     gams get_ametikoht_stat;
BEGIN
    select  count(*)
    into    gams.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = p_asutus_id
            and ametikoht_id = p_ametikoht_id
            and staatus_id = 101;

    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = p_asutus_id
                        and ametikoht_id = p_ametikoht_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = p_asutus_id
                        and ametikoht_id = p_ametikoht_id
            )
    into    gams.vahetatud_dokumente;
	return gams;
end;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION dir_temp_konv (
    p_inputFile character varying)    
 RETURNS VOID AS $$

BEGIN
  SET dvkxtee.xtee_asutus = '';
  SET dvkxtee.xtee_isikukood = '';


  INSERT INTO konversioon (
    version,
    result_version,
    xslt
  ) VALUES (
    2,
    1,
    (SELECT bytea_import(p_inputFile))
  ); 
end;$$
LANGUAGE PLPGSQL;


create or replace function bytea_import(p_path text, p_result out bytea) 
returns bytea as $$
declare
  l_oid oid;
  r record;
begin
  p_result := '';
  select lo_import(p_path) into l_oid;
  for r in ( select data 
             from pg_largeobject 
             where loid = l_oid 
             order by pageno ) loop
    p_result = p_result || r.data;
  end loop;
  perform lo_unlink(l_oid);
end;$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Get_NextDocID" ()    
RETURNS integer 
AS $$
DECLARE
    p_id int4;
BEGIN
    select  nextval('sq_dokument_id')
    into    p_id;
	
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION "Get_NextFragmentID" ()
RETURNS integer 
AS $$
DECLARE
    p_id int4;
BEGIN
    select  nextval('sq_dokumendi_fragment_id')
    into    p_id;
	
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION "Get_NextRecipientID" ()
RETURNS integer 
AS $$
DECLARE
    p_id int4;
BEGIN
    select  nextval('sq_vastuvotja_id')
    into    p_id;
	
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION "Create_Log_Triggers" () 
  RETURNS VOID AS $$
 DECLARE
   tbl record;
   clmn record;   
   sql_string character varying;
   pkey_col character varying;
BEGIN
for tbl in
(
	
    SELECT table_name FROM information_schema.tables where table_name <> 'logi' and table_schema = 'dvk'
)
loop
    RAISE NOTICE '%', tbl.table_name;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
	

    sql_string := 'create or replace trigger tr_' || tbl.table_name || '_log
    after insert or update or delete
    on ' || tbl.table_name || '
    referencing old as old new as new
    for each row
    declare
        operation character varying;
        usr character varying;
    begin
        if tg_op = ''INSERT'' then
            operation := ''INSERT'';
        else if tg_op = ''UPDATE'' then
			operation := ''UPDATE'';
		else
			operation := ''DELETE'';
        end if;
        select  user
        into    usr';
        

    for clmn in
    (
        select column_name, data_type from information_schema.columns  where table_name = tbl.table_name
    )
    loop
        if (clmn.data_type <> 'text') and (clmn.data_type <> 'bytea') then
        sql_string := sql_string || '
        insert
        into    logi(log_id,tabel,op,uidcol,tabel_uid,veerg,ctype,vana_vaartus,uus_vaartus,muutmise_aeg,ab_kasutaja,ef_kasutaja,kasutaja_kood,comm,created,last_modified,username,ametikoht)
        values  (0,''' || tbl.table_name || ''',operation,''' || pkey_col || ''',old.' || pkey_col || ',''' || clmn.column_name || ''',''' || clmn.data_type || ''',old.' || clmn.column_name || ',new.' || clmn.column_name || ',current_date,usr,'''','''','''',current_date,current_date,'''',0);
        ';
        end if;
    end loop;

    sql_string := sql_string || 'end;';

	execute sql_string;	    
end loop;
end;$$
LANGUAGE PLPGSQL;







CREATE OR REPLACE FUNCTION tr_vastuvotja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_new vastuvotja%ROWTYPE;
	vastuvotja_old vastuvotja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  vastuvotja_new.VASTUVOTJA_ID := new.VASTUVOTJA_ID;
		  vastuvotja_new.TRANSPORT_ID := new.TRANSPORT_ID;
		  vastuvotja_new.ASUTUS_ID := new.ASUTUS_ID;
		  vastuvotja_new.AMETIKOHT_ID := new.AMETIKOHT_ID;
		  vastuvotja_new.ISIKUKOOD := new.ISIKUKOOD;
		  vastuvotja_new.NIMI := new.NIMI;
		  vastuvotja_new.EMAIL := new.EMAIL;
		  vastuvotja_new.OSAKONNA_NR := new.OSAKONNA_NR;
		  vastuvotja_new.OSAKONNA_NIMI := new.OSAKONNA_NIMI;
		  vastuvotja_new.SAATMISVIIS_ID := new.SAATMISVIIS_ID;
		  vastuvotja_new.STAATUS_ID := new.STAATUS_ID;
		  vastuvotja_new.SAATMISE_ALGUS := new.SAATMISE_ALGUS;
		  vastuvotja_new.SAATMISE_LOPP := new.SAATMISE_LOPP;
		  vastuvotja_new.FAULT_CODE := new.FAULT_CODE;
		  vastuvotja_new.FAULT_ACTOR := new.FAULT_ACTOR;
		  vastuvotja_new.FAULT_STRING := new.FAULT_STRING;
		  vastuvotja_new.FAULT_DETAIL := new.FAULT_DETAIL;
		  vastuvotja_new.VASTUVOTJA_STAATUS_ID := new.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_new.METAXML := new.METAXML;
		  vastuvotja_new.ASUTUSE_NIMI := new.ASUTUSE_NIMI;
		  vastuvotja_new.ALLYKSUS_ID := new.ALLYKSUS_ID;
		  vastuvotja_new.DOK_ID_TEISES_SERVERIS := new.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_new.ALLYKSUSE_LYHINIMETUS := new.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_new.AMETIKOHA_LYHINIMETUS := new.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  vastuvotja_old.VASTUVOTJA_ID := old.VASTUVOTJA_ID;
		  vastuvotja_old.TRANSPORT_ID := old.TRANSPORT_ID;
		  vastuvotja_old.ASUTUS_ID := old.ASUTUS_ID;
		  vastuvotja_old.AMETIKOHT_ID := old.AMETIKOHT_ID;
		  vastuvotja_old.ISIKUKOOD := old.ISIKUKOOD;
		  vastuvotja_old.NIMI := old.NIMI;
		  vastuvotja_old.EMAIL := old.EMAIL;
		  vastuvotja_old.OSAKONNA_NR := old.OSAKONNA_NR;
		  vastuvotja_old.OSAKONNA_NIMI := old.OSAKONNA_NIMI;
		  vastuvotja_old.SAATMISVIIS_ID := old.SAATMISVIIS_ID;
		  vastuvotja_old.STAATUS_ID := old.STAATUS_ID;
		  vastuvotja_old.SAATMISE_ALGUS := old.SAATMISE_ALGUS;
		  vastuvotja_old.SAATMISE_LOPP := old.SAATMISE_LOPP;
		  vastuvotja_old.FAULT_CODE := old.FAULT_CODE;
		  vastuvotja_old.FAULT_ACTOR := old.FAULT_ACTOR;
		  vastuvotja_old.FAULT_STRING := old.FAULT_STRING;
		  vastuvotja_old.FAULT_DETAIL := old.FAULT_DETAIL;
		  vastuvotja_old.VASTUVOTJA_STAATUS_ID := old.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_old.METAXML := old.METAXML;
		  vastuvotja_old.ASUTUSE_NIMI := old.ASUTUSE_NIMI;
		  vastuvotja_old.ALLYKSUS_ID := old.ALLYKSUS_ID;
		  vastuvotja_old.DOK_ID_TEISES_SERVERIS := old.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_old.ALLYKSUSE_LYHINIMETUS := old.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_old.AMETIKOHA_LYHINIMETUS := old.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  vastuvotja_old.VASTUVOTJA_ID := old.VASTUVOTJA_ID;
		  vastuvotja_old.TRANSPORT_ID := old.TRANSPORT_ID;
		  vastuvotja_old.ASUTUS_ID := old.ASUTUS_ID;
		  vastuvotja_old.AMETIKOHT_ID := old.AMETIKOHT_ID;
		  vastuvotja_old.ISIKUKOOD := old.ISIKUKOOD;
		  vastuvotja_old.NIMI := old.NIMI;
		  vastuvotja_old.EMAIL := old.EMAIL;
		  vastuvotja_old.OSAKONNA_NR := old.OSAKONNA_NR;
		  vastuvotja_old.OSAKONNA_NIMI := old.OSAKONNA_NIMI;
		  vastuvotja_old.SAATMISVIIS_ID := old.SAATMISVIIS_ID;
		  vastuvotja_old.STAATUS_ID := old.STAATUS_ID;
		  vastuvotja_old.SAATMISE_ALGUS := old.SAATMISE_ALGUS;
		  vastuvotja_old.SAATMISE_LOPP := old.SAATMISE_LOPP;
		  vastuvotja_old.FAULT_CODE := old.FAULT_CODE;
		  vastuvotja_old.FAULT_ACTOR := old.FAULT_ACTOR;
		  vastuvotja_old.FAULT_STRING := old.FAULT_STRING;
		  vastuvotja_old.FAULT_DETAIL := old.FAULT_DETAIL;
		  vastuvotja_old.VASTUVOTJA_STAATUS_ID := old.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_old.METAXML := old.METAXML;
		  vastuvotja_old.ASUTUSE_NIMI := old.ASUTUSE_NIMI;
		  vastuvotja_old.ALLYKSUS_ID := old.ALLYKSUS_ID;
		  vastuvotja_old.DOK_ID_TEISES_SERVERIS := old.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_old.ALLYKSUSE_LYHINIMETUS := old.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_old.AMETIKOHA_LYHINIMETUS := old.AMETIKOHA_LYHINIMETUS;
	  end if;	
	  
	  execute dvklog.log_vastuvotja(vastuvotja_new, vastuvotja_old, tr_operation);       		  	  
	  IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
END;$$ 
LANGUAGE PLPGSQL;    





CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja (
    vastuvotja_new dvk.vastuvotja,
    vastuvotja_old dvk.vastuvotja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja';
    primary_key_value integer := vastuvotja_old.vastuvotja_id;	
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

		
    -- vastuvotja_id changed
    IF(coalesce(vastuvotja_new.vastuvotja_id, 0) != coalesce(vastuvotja_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');

	  p_id := nextval('sq_logi_id');
	
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.vastuvotja_id,
        vastuvotja_new.vastuvotja_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
		current_setting('dvkxtee.xtee_isikukood'),
		current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- transport_id changed
    IF(coalesce(vastuvotja_new.transport_id, 0) != coalesce(vastuvotja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.transport_id,
        vastuvotja_new.transport_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(vastuvotja_new.asutus_id, 0) != coalesce(vastuvotja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');

      p_id := nextval('sq_logi_id');
	   
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.asutus_id,
        vastuvotja_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(vastuvotja_new.ametikoht_id, 0) != coalesce(vastuvotja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.ametikoht_id,
        vastuvotja_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- isikukood changed
    IF(coalesce(vastuvotja_new.isikukood, ' ') != coalesce(vastuvotja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.isikukood,
        vastuvotja_new.isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(vastuvotja_new.nimi, ' ') != coalesce(vastuvotja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.nimi,
        vastuvotja_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- email changed
    IF(coalesce(vastuvotja_new.email, ' ') != coalesce(vastuvotja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.email,
        vastuvotja_new.email,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nr changed
    IF(coalesce(vastuvotja_new.osakonna_nr, ' ') != coalesce(vastuvotja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.osakonna_nr,
        vastuvotja_new.osakonna_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nimi changed
    IF(coalesce(vastuvotja_new.osakonna_nimi, ' ') != coalesce(vastuvotja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.osakonna_nimi,
        vastuvotja_new.osakonna_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmisviis_id changed
    IF(coalesce(vastuvotja_new.saatmisviis_id, 0) != coalesce(vastuvotja_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
	
	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmisviis_id,
        vastuvotja_new.saatmisviis_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- staatus_id changed
    IF(coalesce(vastuvotja_new.staatus_id, 0) != coalesce(vastuvotja_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.staatus_id,
        vastuvotja_new.staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmise_algus changed
    IF(coalesce(vastuvotja_new.saatmise_algus, LOCALTIMESTAMP) != coalesce(vastuvotja_old.saatmise_algus, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmise_algus,
        vastuvotja_new.saatmise_algus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmise_lopp changed
    IF(coalesce(vastuvotja_new.saatmise_lopp, LOCALTIMESTAMP) != coalesce(vastuvotja_old.saatmise_lopp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');

	   p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmise_lopp,
        vastuvotja_new.saatmise_lopp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_code changed
    IF(coalesce(vastuvotja_new.fault_code, ' ') != coalesce(vastuvotja_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_code,
        vastuvotja_new.fault_code,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
		current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_actor changed
    IF(coalesce(vastuvotja_new.fault_actor, ' ') != coalesce(vastuvotja_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_actor,
        vastuvotja_new.fault_actor,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_string changed
    IF(coalesce(vastuvotja_new.fault_string, ' ') != coalesce(vastuvotja_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_string,
        vastuvotja_new.fault_string,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_detail changed
    IF(coalesce(vastuvotja_new.fault_detail, ' ') != coalesce(vastuvotja_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_detail,
        vastuvotja_new.fault_detail,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vastuvotja_staatus_id changed
    IF(coalesce(vastuvotja_new.vastuvotja_staatus_id, 0) != coalesce(vastuvotja_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.vastuvotja_staatus_id,
        vastuvotja_new.vastuvotja_staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutuse_nimi changed
    IF(coalesce(vastuvotja_new.asutuse_nimi, ' ') != coalesce(vastuvotja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.asutuse_nimi,
        vastuvotja_new.asutuse_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(vastuvotja_new.allyksus_id, 0) != coalesce(vastuvotja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.allyksus_id,
        vastuvotja_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dok_id_teises_serveris changed
    IF(coalesce(vastuvotja_new.dok_id_teises_serveris, 0) != coalesce(vastuvotja_old.dok_id_teises_serveris, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dok_id_teises_serveris');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.dok_id_teises_serveris,
        vastuvotja_new.dok_id_teises_serveris,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vastuvotja_new.allyksuse_lyhinimetus, ' ') != coalesce(vastuvotja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
	  
      p_id := nextval('sq_logi_id');
	
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.allyksuse_lyhinimetus,
        vastuvotja_new.allyksuse_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vastuvotja_new.ametikoha_lyhinimetus, ' ') != coalesce(vastuvotja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.ametikoha_lyhinimetus,
        vastuvotja_new.ametikoha_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_allkiri_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	allkiri_new allkiri%ROWTYPE;
	allkiri_old allkiri%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  allkiri_new.ALLKIRI_ID := NEW.ALLKIRI_ID;
		  allkiri_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  allkiri_new.EESNIMI := NEW.EESNIMI;
		  allkiri_new.PERENIMI := NEW.PERENIMI;
		  allkiri_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  allkiri_new.KUUPAEV := NEW.KUUPAEV;
		  allkiri_new.ROLL := NEW.ROLL;
		  allkiri_new.RIIK := NEW.RIIK;
		  allkiri_new.MAAKOND := NEW.MAAKOND;
		  allkiri_new.LINN := NEW.LINN;
		  allkiri_new.INDEKS := NEW.INDEKS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  allkiri_old.ALLKIRI_ID := OLD.ALLKIRI_ID;
		  allkiri_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  allkiri_old.EESNIMI := OLD.EESNIMI;
		  allkiri_old.PERENIMI := OLD.PERENIMI;
		  allkiri_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  allkiri_old.KUUPAEV := OLD.KUUPAEV;
		  allkiri_old.ROLL := OLD.ROLL;
		  allkiri_old.RIIK := OLD.RIIK;
		  allkiri_old.MAAKOND := OLD.MAAKOND;
		  allkiri_old.LINN := OLD.LINN;
		  allkiri_old.INDEKS := OLD.INDEKS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  allkiri_old.ALLKIRI_ID := OLD.ALLKIRI_ID;
		  allkiri_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  allkiri_old.EESNIMI := OLD.EESNIMI;
		  allkiri_old.PERENIMI := OLD.PERENIMI;
		  allkiri_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  allkiri_old.KUUPAEV := OLD.KUUPAEV;
		  allkiri_old.ROLL := OLD.ROLL;
		  allkiri_old.RIIK := OLD.RIIK;
		  allkiri_old.MAAKOND := OLD.MAAKOND;
		  allkiri_old.LINN := OLD.LINN;
		  allkiri_old.INDEKS := OLD.INDEKS;
	  end if;	
	  
      
	  execute dvklog.log_allkiri(allkiri_new, allkiri_old, tr_operation);       		  
	  IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_allkiri (
    allkiri_new dvk.allkiri,
    allkiri_old dvk.allkiri,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'allkiri';
    primary_key_value integer := allkiri_old.allkiri_id;	
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

		
    -- allkiri_id changed
    IF(coalesce(allkiri_new.allkiri_id, 0) != coalesce(allkiri_old.allkiri_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allkiri_id');
      
	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.allkiri_id,
        allkiri_new.allkiri_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dokument_id changed
    IF(coalesce(allkiri_new.dokument_id, 0) != coalesce(allkiri_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');

	  p_id := nextval('sq_logi_id');
		  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.dokument_id,
        allkiri_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- eesnimi changed
    IF(coalesce(allkiri_new.eesnimi, ' ') != coalesce(allkiri_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.eesnimi,
        allkiri_new.eesnimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- perenimi changed
    IF(coalesce(allkiri_new.perenimi, ' ') != coalesce(allkiri_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
	  
	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.perenimi,
        allkiri_new.perenimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- isikukood changed
    IF(coalesce(allkiri_new.isikukood, ' ') != coalesce(allkiri_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.isikukood,
        allkiri_new.isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kuupaev changed
    IF(coalesce(allkiri_new.kuupaev, LOCALTIMESTAMP) != coalesce(allkiri_old.kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuupaev');

	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.kuupaev,
        allkiri_new.kuupaev,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- roll changed
    IF(coalesce(allkiri_new.roll, ' ') != coalesce(allkiri_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.roll,
        allkiri_new.roll,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- riik changed
    IF(coalesce(allkiri_new.riik, ' ') != coalesce(allkiri_old.riik, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('riik');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.riik,
        allkiri_new.riik,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- maakond changed
    IF(coalesce(allkiri_new.maakond, ' ') != coalesce(allkiri_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.maakond,
        allkiri_new.maakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- linn changed
    IF(coalesce(allkiri_new.linn, ' ') != coalesce(allkiri_old.linn, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('linn');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.linn,
        allkiri_new.linn,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- indeks changed
    IF(coalesce(allkiri_new.indeks, ' ') != coalesce(allkiri_old.indeks, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('indeks');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.indeks,
        allkiri_new.indeks,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_allyksus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	allyksus_new allyksus%ROWTYPE;
	allyksus_old allyksus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  ALLYKSUS_new.ID := NEW.ID;
		  ALLYKSUS_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  ALLYKSUS_new.VANEM_ID := NEW.VANEM_ID;
		  ALLYKSUS_new.ALLYKSUS := NEW.ALLYKSUS;
		  ALLYKSUS_new.CREATED := NEW.CREATED;
		  ALLYKSUS_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  ALLYKSUS_new.USERNAME := NEW.USERNAME;
		  ALLYKSUS_new.MUUTM_ARV := NEW.MUUTM_ARV;
		  ALLYKSUS_new.AAR_ID := NEW.AAR_ID;
		  ALLYKSUS_new.LYHINIMETUS := NEW.LYHINIMETUS;
		  ALLYKSUS_new.ADR_URI := NEW.ADR_URI;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  ALLYKSUS_old.ID := OLD.ID;
		  ALLYKSUS_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  ALLYKSUS_old.VANEM_ID := OLD.VANEM_ID;
		  ALLYKSUS_old.ALLYKSUS := OLD.ALLYKSUS;
		  ALLYKSUS_old.CREATED := OLD.CREATED;
		  ALLYKSUS_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ALLYKSUS_old.USERNAME := OLD.USERNAME;
		  ALLYKSUS_old.MUUTM_ARV := OLD.MUUTM_ARV;
		  ALLYKSUS_old.AAR_ID := OLD.AAR_ID;
		  ALLYKSUS_old.LYHINIMETUS := OLD.LYHINIMETUS;
		  ALLYKSUS_old.ADR_URI := OLD.ADR_URI;	   
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
   		  ALLYKSUS_old.ID := OLD.ID;
		  ALLYKSUS_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  ALLYKSUS_old.VANEM_ID := OLD.VANEM_ID;
		  ALLYKSUS_old.ALLYKSUS := OLD.ALLYKSUS;
		  ALLYKSUS_old.CREATED := OLD.CREATED;
		  ALLYKSUS_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ALLYKSUS_old.USERNAME := OLD.USERNAME;
		  ALLYKSUS_old.MUUTM_ARV := OLD.MUUTM_ARV;
		  ALLYKSUS_old.AAR_ID := OLD.AAR_ID;
		  ALLYKSUS_old.LYHINIMETUS := OLD.LYHINIMETUS;
		  ALLYKSUS_old.ADR_URI := OLD.ADR_URI;		  
	  end if;	
	  
	  execute dvklog.log_allyksus(allyksus_new, allyksus_old, tr_operation);       		  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_allyksus (
    allyksus_new dvk.allyksus,
    allyksus_old dvk.allyksus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'allyksus';
    primary_key_value integer := allyksus_old.id;	
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- id changed
    IF(coalesce(allyksus_new.id, 0) != coalesce(allyksus_old.id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
	  
	  p_id := nextval('sq_logi_id');
	  
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.id,
        allyksus_new.id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(allyksus_new.asutus_id, 0) != coalesce(allyksus_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.asutus_id,
        allyksus_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vanem_id changed
    IF(coalesce(allyksus_new.vanem_id, 0) != coalesce(allyksus_old.vanem_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vanem_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.vanem_id,
        allyksus_new.vanem_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus changed
    IF(coalesce(allyksus_new.allyksus, ' ') != coalesce(allyksus_old.allyksus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.allyksus,
        allyksus_new.allyksus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(allyksus_new.created, LOCALTIMESTAMP) != coalesce(allyksus_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.created,
        allyksus_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(allyksus_new.last_modified, LOCALTIMESTAMP) != coalesce(allyksus_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.last_modified,
        allyksus_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(allyksus_new.username, ' ') != coalesce(allyksus_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.username,
        allyksus_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- muutm_arv changed
    IF(coalesce(allyksus_new.muutm_arv, 0) != coalesce(allyksus_old.muutm_arv, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutm_arv');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.muutm_arv,
        allyksus_new.muutm_arv,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aar_id changed
    IF(coalesce(allyksus_new.aar_id, 0) != coalesce(allyksus_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.aar_id,
        allyksus_new.aar_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- lyhinimetus changed
    IF(coalesce(allyksus_new.lyhinimetus, ' ') != coalesce(allyksus_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.lyhinimetus,
        allyksus_new.lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- adr_uri changed
    IF(coalesce(allyksus_new.adr_uri, ' ') != coalesce(allyksus_old.adr_uri, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('adr_uri');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.adr_uri,
        allyksus_new.adr_uri,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_ametikoht_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ametikoht_new ametikoht%ROWTYPE;
	ametikoht_old ametikoht%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  AMETIKOHT_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  AMETIKOHT_new.KS_AMETIKOHT_ID := NEW.KS_AMETIKOHT_ID;
		  AMETIKOHT_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  AMETIKOHT_new.AMETIKOHT_NIMETUS := NEW.AMETIKOHT_NIMETUS;
		  AMETIKOHT_new.ALATES := NEW.ALATES;
		  AMETIKOHT_new.KUNI := NEW.KUNI;
		  AMETIKOHT_new.CREATED := NEW.CREATED;
		  AMETIKOHT_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  AMETIKOHT_new.USERNAME := NEW.USERNAME;
		  AMETIKOHT_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  AMETIKOHT_new.PARAMS := NEW.PARAMS;
		  AMETIKOHT_new.AAR_ID := NEW.AAR_ID;
		  AMETIKOHT_new.LYHINIMETUS := NEW.LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  AMETIKOHT_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_old.KS_AMETIKOHT_ID := OLD.KS_AMETIKOHT_ID;
		  AMETIKOHT_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  AMETIKOHT_old.AMETIKOHT_NIMETUS := OLD.AMETIKOHT_NIMETUS;
		  AMETIKOHT_old.ALATES := OLD.ALATES;
		  AMETIKOHT_old.KUNI := OLD.KUNI;
		  AMETIKOHT_old.CREATED := OLD.CREATED;
		  AMETIKOHT_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  AMETIKOHT_old.PARAMS := OLD.PARAMS;
		  AMETIKOHT_old.AAR_ID := OLD.AAR_ID;
		  AMETIKOHT_old.LYHINIMETUS := OLD.LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  AMETIKOHT_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_old.KS_AMETIKOHT_ID := OLD.KS_AMETIKOHT_ID;
		  AMETIKOHT_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  AMETIKOHT_old.AMETIKOHT_NIMETUS := OLD.AMETIKOHT_NIMETUS;
		  AMETIKOHT_old.ALATES := OLD.ALATES;
		  AMETIKOHT_old.KUNI := OLD.KUNI;
		  AMETIKOHT_old.CREATED := OLD.CREATED;
		  AMETIKOHT_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  AMETIKOHT_old.PARAMS := OLD.PARAMS;
		  AMETIKOHT_old.AAR_ID := OLD.AAR_ID;
		  AMETIKOHT_old.LYHINIMETUS := OLD.LYHINIMETUS;
	  end if;	

	  execute dvklog.log_ametikoht(ametikoht_new, ametikoht_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_ametikoht (
    ametikoht_new dvk.ametikoht,
    ametikoht_old dvk.ametikoht,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ametikoht';    
    primary_key_value integer := ametikoht_old.ametikoht_id;	
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- ametikoht_id changed
    IF(coalesce(ametikoht_new.ametikoht_id, 0) != coalesce(ametikoht_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ametikoht_id,
        ametikoht_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ks_ametikoht_id changed
    IF(coalesce(ametikoht_new.ks_ametikoht_id, 0) != coalesce(ametikoht_old.ks_ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ks_ametikoht_id,
        ametikoht_new.ks_ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(ametikoht_new.asutus_id, 0) != coalesce(ametikoht_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.asutus_id,
        ametikoht_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_nimetus changed
    IF(coalesce(ametikoht_new.ametikoht_nimetus, ' ') != coalesce(ametikoht_old.ametikoht_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ametikoht_nimetus,
        ametikoht_new.ametikoht_nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- alates changed
    IF(coalesce(ametikoht_new.alates, LOCALTIMESTAMP) != coalesce(ametikoht_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.alates,
        ametikoht_new.alates,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kuni changed
    IF(coalesce(ametikoht_new.kuni, LOCALTIMESTAMP) != coalesce(ametikoht_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.kuni,
        ametikoht_new.kuni,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(ametikoht_new.created, LOCALTIMESTAMP) != coalesce(ametikoht_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.created,
        ametikoht_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(ametikoht_new.last_modified, LOCALTIMESTAMP) != coalesce(ametikoht_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.last_modified,
        ametikoht_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(ametikoht_new.username, ' ') != coalesce(ametikoht_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.username,
        ametikoht_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(ametikoht_new.allyksus_id, 0) != coalesce(ametikoht_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.allyksus_id,
        ametikoht_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- params changed
    IF(coalesce(ametikoht_new.params, ' ') != coalesce(ametikoht_old.params, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.params,
        ametikoht_new.params,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aar_id changed
    IF(coalesce(ametikoht_new.aar_id, 0) != coalesce(ametikoht_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.aar_id,
        ametikoht_new.aar_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- lyhinimetus changed
    IF(coalesce(ametikoht_new.lyhinimetus, ' ') != coalesce(ametikoht_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.lyhinimetus,
        ametikoht_new.lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_ametikoht_taitmine_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ametikoht_taitmine_new ametikoht_taitmine%ROWTYPE;
	ametikoht_taitmine_old ametikoht_taitmine%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  AMETIKOHT_TAITMINE_new.TAITMINE_ID := NEW.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_new.I_ID := NEW.I_ID;
		  AMETIKOHT_TAITMINE_new.ALATES := NEW.ALATES;
		  AMETIKOHT_TAITMINE_new.KUNI := NEW.KUNI;
		  AMETIKOHT_TAITMINE_new.ROLL := NEW.ROLL;
		  AMETIKOHT_TAITMINE_new.CREATED := NEW.CREATED;
		  AMETIKOHT_TAITMINE_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_new.USERNAME := NEW.USERNAME;
		  AMETIKOHT_TAITMINE_new.PEATATUD := NEW.PEATATUD;
		  AMETIKOHT_TAITMINE_new.AAR_ID := NEW.AAR_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  AMETIKOHT_TAITMINE_old.TAITMINE_ID := OLD.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_old.I_ID := OLD.I_ID;
		  AMETIKOHT_TAITMINE_old.ALATES := OLD.ALATES;
		  AMETIKOHT_TAITMINE_old.KUNI := OLD.KUNI;
		  AMETIKOHT_TAITMINE_old.ROLL := OLD.ROLL;
		  AMETIKOHT_TAITMINE_old.CREATED := OLD.CREATED;
		  AMETIKOHT_TAITMINE_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_TAITMINE_old.PEATATUD := OLD.PEATATUD;
		  AMETIKOHT_TAITMINE_old.AAR_ID := OLD.AAR_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  AMETIKOHT_TAITMINE_old.TAITMINE_ID := OLD.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_old.I_ID := OLD.I_ID;
		  AMETIKOHT_TAITMINE_old.ALATES := OLD.ALATES;
		  AMETIKOHT_TAITMINE_old.KUNI := OLD.KUNI;
		  AMETIKOHT_TAITMINE_old.ROLL := OLD.ROLL;
		  AMETIKOHT_TAITMINE_old.CREATED := OLD.CREATED;
		  AMETIKOHT_TAITMINE_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_TAITMINE_old.PEATATUD := OLD.PEATATUD;
		  AMETIKOHT_TAITMINE_old.AAR_ID := OLD.AAR_ID;
	  end if;	

	  execute dvklog.log_ametikoht_taitmine(ametikoht_taitmine_new, ametikoht_taitmine_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_ametikoht_taitmine (
    ametikoht_taitmine_new dvk.ametikoht_taitmine,
    ametikoht_taitmine_old dvk.ametikoht_taitmine,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ametikoht_taitmine';    
    primary_key_value integer := ametikoht_taitmine_old.taitmine_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- taitmine_id changed
    IF(coalesce(ametikoht_taitmine_new.taitmine_id, 0) != coalesce(ametikoht_taitmine_old.taitmine_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('taitmine_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.taitmine_id,
        ametikoht_taitmine_new.taitmine_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(ametikoht_taitmine_new.ametikoht_id, 0) != coalesce(ametikoht_taitmine_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.ametikoht_id,
        ametikoht_taitmine_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- i_id changed
    IF(coalesce(ametikoht_taitmine_new.i_id, 0) != coalesce(ametikoht_taitmine_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.i_id,
        ametikoht_taitmine_new.i_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- alates changed
    IF(coalesce(ametikoht_taitmine_new.alates, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.alates,
        ametikoht_taitmine_new.alates,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kuni changed
    IF(coalesce(ametikoht_taitmine_new.kuni, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.kuni,
        ametikoht_taitmine_new.kuni,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- roll changed
    IF(coalesce(ametikoht_taitmine_new.roll, ' ') != coalesce(ametikoht_taitmine_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.roll,
        ametikoht_taitmine_new.roll,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(ametikoht_taitmine_new.created, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.created,
        ametikoht_taitmine_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(ametikoht_taitmine_new.last_modified, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.last_modified,
        ametikoht_taitmine_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(ametikoht_taitmine_new.username, ' ') != coalesce(ametikoht_taitmine_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.username,
        ametikoht_taitmine_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- peatatud changed
    IF(coalesce(ametikoht_taitmine_new.peatatud, 0) != coalesce(ametikoht_taitmine_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.peatatud,
        ametikoht_taitmine_new.peatatud,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aar_id changed
    IF(coalesce(ametikoht_taitmine_new.aar_id, 0) != coalesce(ametikoht_taitmine_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.aar_id,
        ametikoht_taitmine_new.aar_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
			
  END;$$
LANGUAGE PLPGSQL;
	

CREATE OR REPLACE FUNCTION tr_asutus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	asutus_new asutus%ROWTYPE;
	asutus_old asutus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  asutus_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  asutus_new.REGISTRIKOOD := NEW.REGISTRIKOOD;
		  asutus_new.E_REGISTRIKOOD := NEW.E_REGISTRIKOOD;
		  asutus_new.KS_ASUTUS_ID := NEW.KS_ASUTUS_ID;
		  asutus_new.KS_ASUTUS_KOOD := NEW.KS_ASUTUS_KOOD;
		  asutus_new.NIMETUS := NEW.NIMETUS;
		  asutus_new.LNIMI := NEW.LNIMI;
		  asutus_new.LIIK1 := NEW.LIIK1;
		  asutus_new.LIIK2 := NEW.LIIK2;
		  asutus_new.TEGEVUSALA := NEW.TEGEVUSALA;
		  asutus_new.TEGEVUSPIIRKOND := NEW.TEGEVUSPIIRKOND;
		  asutus_new.MAAKOND := NEW.MAAKOND;
		  asutus_new.ASUKOHT := NEW.ASUKOHT;
		  asutus_new.AADRESS := NEW.AADRESS;
		  asutus_new.POSTIKOOD := NEW.POSTIKOOD;
		  asutus_new.TELEFON := NEW.TELEFON;
		  asutus_new.FAKS := NEW.FAKS;
		  asutus_new.E_POST := NEW.E_POST;
		  asutus_new.WWW := NEW.WWW;
		  asutus_new.LOGO := NEW.LOGO;
		  asutus_new.ASUTAMISE_KP := NEW.ASUTAMISE_KP;
		  asutus_new.MOOD_AKT_NIMI := NEW.MOOD_AKT_NIMI;
		  asutus_new.MOOD_AKT_NR := NEW.MOOD_AKT_NR;
		  asutus_new.MOOD_AKT_KP := NEW.MOOD_AKT_KP;
		  asutus_new.PM_AKT_NIMI := NEW.PM_AKT_NIMI;
		  asutus_new.PM_AKT_NR := NEW.PM_AKT_NR;
		  asutus_new.PM_KINNITAMISE_KP := NEW.PM_KINNITAMISE_KP;
		  asutus_new.PM_KANDE_KP := NEW.PM_KANDE_KP;
		  asutus_new.CREATED := NEW.CREATED;
		  asutus_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  asutus_new.USERNAME := NEW.USERNAME;
		  asutus_new.PARAMS := NEW.PARAMS;
		  asutus_new.DHL_OTSE_SAATMINE := NEW.DHL_OTSE_SAATMINE;
		  asutus_new.DHL_SAATMINE := NEW.DHL_SAATMINE;
		  asutus_new.DHS_NIMETUS := NEW.DHS_NIMETUS;
		  asutus_new.TOETATAV_DVK_VERSIOON := NEW.TOETATAV_DVK_VERSIOON;
		  asutus_new.SERVER_ID := NEW.SERVER_ID;
		  asutus_new.AAR_ID := NEW.AAR_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
		  asutus_old.E_REGISTRIKOOD := OLD.E_REGISTRIKOOD;
		  asutus_old.KS_ASUTUS_ID := OLD.KS_ASUTUS_ID;
		  asutus_old.KS_ASUTUS_KOOD := OLD.KS_ASUTUS_KOOD;
		  asutus_old.NIMETUS := OLD.NIMETUS;
		  asutus_old.LNIMI := OLD.LNIMI;
		  asutus_old.LIIK1 := OLD.LIIK1;
		  asutus_old.LIIK2 := OLD.LIIK2;
		  asutus_old.TEGEVUSALA := OLD.TEGEVUSALA;
		  asutus_old.TEGEVUSPIIRKOND := OLD.TEGEVUSPIIRKOND;
		  asutus_old.MAAKOND := OLD.MAAKOND;
		  asutus_old.ASUKOHT := OLD.ASUKOHT;
		  asutus_old.AADRESS := OLD.AADRESS;
		  asutus_old.POSTIKOOD := OLD.POSTIKOOD;
		  asutus_old.TELEFON := OLD.TELEFON;
		  asutus_old.FAKS := OLD.FAKS;
		  asutus_old.E_POST := OLD.E_POST;
		  asutus_old.WWW := OLD.WWW;
		  asutus_old.LOGO := OLD.LOGO;
		  asutus_old.ASUTAMISE_KP := OLD.ASUTAMISE_KP;
		  asutus_old.MOOD_AKT_NIMI := OLD.MOOD_AKT_NIMI;
		  asutus_old.MOOD_AKT_NR := OLD.MOOD_AKT_NR;
		  asutus_old.MOOD_AKT_KP := OLD.MOOD_AKT_KP;
		  asutus_old.PM_AKT_NIMI := OLD.PM_AKT_NIMI;
		  asutus_old.PM_AKT_NR := OLD.PM_AKT_NR;
		  asutus_old.PM_KINNITAMISE_KP := OLD.PM_KINNITAMISE_KP;
		  asutus_old.PM_KANDE_KP := OLD.PM_KANDE_KP;
		  asutus_old.CREATED := OLD.CREATED;
		  asutus_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  asutus_old.USERNAME := OLD.USERNAME;
		  asutus_old.PARAMS := OLD.PARAMS;
		  asutus_old.DHL_OTSE_SAATMINE := OLD.DHL_OTSE_SAATMINE;
		  asutus_old.DHL_SAATMINE := OLD.DHL_SAATMINE;
		  asutus_old.DHS_NIMETUS := OLD.DHS_NIMETUS;
		  asutus_old.TOETATAV_DVK_VERSIOON := OLD.TOETATAV_DVK_VERSIOON;
		  asutus_old.SERVER_ID := OLD.SERVER_ID;
		  asutus_old.AAR_ID := OLD.AAR_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
		  asutus_old.E_REGISTRIKOOD := OLD.E_REGISTRIKOOD;
		  asutus_old.KS_ASUTUS_ID := OLD.KS_ASUTUS_ID;
		  asutus_old.KS_ASUTUS_KOOD := OLD.KS_ASUTUS_KOOD;
		  asutus_old.NIMETUS := OLD.NIMETUS;
		  asutus_old.LNIMI := OLD.LNIMI;
		  asutus_old.LIIK1 := OLD.LIIK1;
		  asutus_old.LIIK2 := OLD.LIIK2;
		  asutus_old.TEGEVUSALA := OLD.TEGEVUSALA;
		  asutus_old.TEGEVUSPIIRKOND := OLD.TEGEVUSPIIRKOND;
		  asutus_old.MAAKOND := OLD.MAAKOND;
		  asutus_old.ASUKOHT := OLD.ASUKOHT;
		  asutus_old.AADRESS := OLD.AADRESS;
		  asutus_old.POSTIKOOD := OLD.POSTIKOOD;
		  asutus_old.TELEFON := OLD.TELEFON;
		  asutus_old.FAKS := OLD.FAKS;
		  asutus_old.E_POST := OLD.E_POST;
		  asutus_old.WWW := OLD.WWW;
		  asutus_old.LOGO := OLD.LOGO;
		  asutus_old.ASUTAMISE_KP := OLD.ASUTAMISE_KP;
		  asutus_old.MOOD_AKT_NIMI := OLD.MOOD_AKT_NIMI;
		  asutus_old.MOOD_AKT_NR := OLD.MOOD_AKT_NR;
		  asutus_old.MOOD_AKT_KP := OLD.MOOD_AKT_KP;
		  asutus_old.PM_AKT_NIMI := OLD.PM_AKT_NIMI;
		  asutus_old.PM_AKT_NR := OLD.PM_AKT_NR;
		  asutus_old.PM_KINNITAMISE_KP := OLD.PM_KINNITAMISE_KP;
		  asutus_old.PM_KANDE_KP := OLD.PM_KANDE_KP;
		  asutus_old.CREATED := OLD.CREATED;
		  asutus_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  asutus_old.USERNAME := OLD.USERNAME;
		  asutus_old.PARAMS := OLD.PARAMS;
		  asutus_old.DHL_OTSE_SAATMINE := OLD.DHL_OTSE_SAATMINE;
		  asutus_old.DHL_SAATMINE := OLD.DHL_SAATMINE;
		  asutus_old.DHS_NIMETUS := OLD.DHS_NIMETUS;
		  asutus_old.TOETATAV_DVK_VERSIOON := OLD.TOETATAV_DVK_VERSIOON;
		  asutus_old.SERVER_ID := OLD.SERVER_ID;
		  asutus_old.AAR_ID := OLD.AAR_ID;
	  end if;	
	  
	  execute dvklog.log_asutus(asutus_new, asutus_old, tr_operation);       		  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_asutus (
    asutus_new dvk.asutus,
    asutus_old dvk.asutus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'asutus';    
    primary_key_value integer := asutus_old.asutus_id;
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- asutus_id changed
    IF(coalesce(asutus_new.asutus_id, 0) != coalesce(asutus_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutus_id,
        asutus_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- registrikood changed
    IF(coalesce(asutus_new.registrikood, ' ') != coalesce(asutus_old.registrikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('registrikood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.registrikood,
        asutus_new.registrikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- e_registrikood changed
    IF(coalesce(asutus_new.e_registrikood, ' ') != coalesce(asutus_old.e_registrikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_registrikood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_registrikood,
        asutus_new.e_registrikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ks_asutus_id changed
    IF(coalesce(asutus_new.ks_asutus_id, 0) != coalesce(asutus_old.ks_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_id,
        asutus_new.ks_asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ks_asutus_kood changed
    IF(coalesce(asutus_new.ks_asutus_kood, ' ') != coalesce(asutus_old.ks_asutus_kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_kood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_kood,
        asutus_new.ks_asutus_kood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimetus changed
    IF(coalesce(asutus_new.nimetus, ' ') != coalesce(asutus_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.nimetus,
        asutus_new.nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- lnimi changed
    IF(coalesce(asutus_new.lnimi, ' ') != coalesce(asutus_old.lnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lnimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.lnimi,
        asutus_new.lnimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- liik1 changed
    IF(coalesce(asutus_new.liik1, ' ') != coalesce(asutus_old.liik1, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik1');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik1,
        asutus_new.liik1,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- liik2 changed
    IF(coalesce(asutus_new.liik2, ' ') != coalesce(asutus_old.liik2, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik2');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik2,
        asutus_new.liik2,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tegevusala changed
    IF(coalesce(asutus_new.tegevusala, ' ') != coalesce(asutus_old.tegevusala, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevusala');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevusala,
        asutus_new.tegevusala,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tegevuspiirkond changed
    IF(coalesce(asutus_new.tegevuspiirkond, ' ') != coalesce(asutus_old.tegevuspiirkond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevuspiirkond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevuspiirkond,
        asutus_new.tegevuspiirkond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- maakond changed
    IF(coalesce(asutus_new.maakond, ' ') != coalesce(asutus_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.maakond,
        asutus_new.maakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asukoht changed
    IF(coalesce(asutus_new.asukoht, ' ') != coalesce(asutus_old.asukoht, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asukoht');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asukoht,
        asutus_new.asukoht,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aadress changed
    IF(coalesce(asutus_new.aadress, ' ') != coalesce(asutus_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aadress,
        asutus_new.aadress,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- postikood changed
    IF(coalesce(asutus_new.postikood, ' ') != coalesce(asutus_old.postikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('postikood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.postikood,
        asutus_new.postikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- telefon changed
    IF(coalesce(asutus_new.telefon, ' ') != coalesce(asutus_old.telefon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('telefon');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.telefon,
        asutus_new.telefon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- faks changed
    IF(coalesce(asutus_new.faks, ' ') != coalesce(asutus_old.faks, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('faks');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.faks,
        asutus_new.faks,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- e_post changed
    IF(coalesce(asutus_new.e_post, ' ') != coalesce(asutus_old.e_post, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_post');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_post,
        asutus_new.e_post,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- www changed
    IF(coalesce(asutus_new.www, ' ') != coalesce(asutus_old.www, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('www');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.www,
        asutus_new.www,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- logo changed
    IF(coalesce(asutus_new.logo, ' ') != coalesce(asutus_old.logo, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('logo');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.logo,
        asutus_new.logo,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutamise_kp changed
    IF(coalesce(asutus_new.asutamise_kp, LOCALTIMESTAMP) != coalesce(asutus_old.asutamise_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutamise_kp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutamise_kp,
        asutus_new.asutamise_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_nimi changed
    IF(coalesce(asutus_new.mood_akt_nimi, ' ') != coalesce(asutus_old.mood_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nimi,
        asutus_new.mood_akt_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_nr changed
    IF(coalesce(asutus_new.mood_akt_nr, ' ') != coalesce(asutus_old.mood_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nr,
        asutus_new.mood_akt_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_kp changed
    IF(coalesce(asutus_new.mood_akt_kp, LOCALTIMESTAMP) != coalesce(asutus_old.mood_akt_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_kp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_kp,
        asutus_new.mood_akt_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_akt_nimi changed
    IF(coalesce(asutus_new.pm_akt_nimi, ' ') != coalesce(asutus_old.pm_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nimi,
        asutus_new.pm_akt_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_akt_nr changed
    IF(coalesce(asutus_new.pm_akt_nr, ' ') != coalesce(asutus_old.pm_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nr,
        asutus_new.pm_akt_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_kinnitamise_kp changed
    IF(coalesce(asutus_new.pm_kinnitamise_kp, LOCALTIMESTAMP) != coalesce(asutus_old.pm_kinnitamise_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kinnitamise_kp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kinnitamise_kp,
        asutus_new.pm_kinnitamise_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_kande_kp changed
    IF(coalesce(asutus_new.pm_kande_kp, LOCALTIMESTAMP) != coalesce(asutus_old.pm_kande_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kande_kp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kande_kp,
        asutus_new.pm_kande_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(asutus_new.created, LOCALTIMESTAMP) != coalesce(asutus_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.created,
        asutus_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(asutus_new.last_modified, LOCALTIMESTAMP) != coalesce(asutus_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.last_modified,
        asutus_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(asutus_new.username, ' ') != coalesce(asutus_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.username,
        asutus_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- params changed
    IF(coalesce(asutus_new.params, ' ') != coalesce(asutus_old.params, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.params,
        asutus_new.params,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhl_otse_saatmine changed
    IF(coalesce(asutus_new.dhl_otse_saatmine, 0) != coalesce(asutus_old.dhl_otse_saatmine, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_otse_saatmine');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_otse_saatmine,
        asutus_new.dhl_otse_saatmine,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhl_saatmine changed
    IF(coalesce(asutus_new.dhl_saatmine, 0) != coalesce(asutus_old.dhl_saatmine, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_saatmine');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_saatmine,
        asutus_new.dhl_saatmine,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhs_nimetus changed
    IF(coalesce(asutus_new.dhs_nimetus, ' ') != coalesce(asutus_old.dhs_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhs_nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhs_nimetus,
        asutus_new.dhs_nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- toetatav_dvk_versioon changed
    IF(coalesce(asutus_new.toetatav_dvk_versioon, ' ') != coalesce(asutus_old.toetatav_dvk_versioon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('toetatav_dvk_versioon');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.toetatav_dvk_versioon,
        asutus_new.toetatav_dvk_versioon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- server_id changed
    IF(coalesce(asutus_new.server_id, 0) != coalesce(asutus_old.server_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('server_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.server_id,
        asutus_new.server_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aar_id changed
    IF(coalesce(asutus_new.aar_id, 0) != coalesce(asutus_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aar_id,
        asutus_new.aar_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;		
  END;$$
LANGUAGE PLPGSQL;
		
		
		
CREATE OR REPLACE FUNCTION tr_dokumendi_ajalugu_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_ajalugu_new dokumendi_ajalugu%ROWTYPE;
	dokumendi_ajalugu_old dokumendi_ajalugu%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_AJALUGU_new.AJALUGU_ID := NEW.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_new.METAINFO := NEW.METAINFO;
		  DOKUMENDI_AJALUGU_new.TRANSPORT := NEW.TRANSPORT;
		  DOKUMENDI_AJALUGU_new.METAXML := NEW.METAXML;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DOKUMENDI_AJALUGU_old.AJALUGU_ID := OLD.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_old.METAINFO := OLD.METAINFO;
		  DOKUMENDI_AJALUGU_old.TRANSPORT := OLD.TRANSPORT;
		  DOKUMENDI_AJALUGU_old.METAXML := OLD.METAXML;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_AJALUGU_old.AJALUGU_ID := OLD.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_old.METAINFO := OLD.METAINFO;
		  DOKUMENDI_AJALUGU_old.TRANSPORT := OLD.TRANSPORT;
		  DOKUMENDI_AJALUGU_old.METAXML := OLD.METAXML;
	  end if;	

	  execute dvklog.log_dokumendi_ajalugu(dokumendi_ajalugu_new, dokumendi_ajalugu_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    



		
CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_ajalugu (
    dokumendi_ajalugu_new dvk.dokumendi_ajalugu,
    dokumendi_ajalugu_old dvk.dokumendi_ajalugu,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_ajalugu';    
    primary_key_value integer := dokumendi_ajalugu_old.ajalugu_id;
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- ajalugu_id changed
    IF(coalesce(dokumendi_ajalugu_new.ajalugu_id, 0) != coalesce(dokumendi_ajalugu_old.ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ajalugu_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_ajalugu_old.ajalugu_id,
        dokumendi_ajalugu_new.ajalugu_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dokument_id changed
    IF(coalesce(dokumendi_ajalugu_new.dokument_id, 0) != coalesce(dokumendi_ajalugu_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_ajalugu_old.dokument_id,
        dokumendi_ajalugu_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;		
  END;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION tr_dokumendi_fail_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_fail_new dokumendi_fail%ROWTYPE;
	dokumendi_fail_old dokumendi_fail%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_FAIL_new.FAIL_ID := NEW.FAIL_ID;
		  DOKUMENDI_FAIL_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_FAIL_new.NIMI := NEW.NIMI;
		  DOKUMENDI_FAIL_new.SUURUS := NEW.SUURUS;
		  DOKUMENDI_FAIL_new.MIME_TYYP := NEW.MIME_TYYP;
		  DOKUMENDI_FAIL_new.SISU := NEW.SISU;
		  DOKUMENDI_FAIL_new.POHIFAIL := NEW.POHIFAIL;
		  DOKUMENDI_FAIL_new.VALINE_MANUS := NEW.VALINE_MANUS;
	   elsif tg_op = 'UPDATE' then    
	      tr_operation := 'UPDATE'; 		  		  
		  DOKUMENDI_FAIL_old.FAIL_ID := OLD.FAIL_ID;
		  DOKUMENDI_FAIL_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_FAIL_old.NIMI := OLD.NIMI;
		  DOKUMENDI_FAIL_old.SUURUS := OLD.SUURUS;
		  DOKUMENDI_FAIL_old.MIME_TYYP := OLD.MIME_TYYP;
		  DOKUMENDI_FAIL_old.SISU := OLD.SISU;
		  DOKUMENDI_FAIL_old.POHIFAIL := OLD.POHIFAIL;
		  DOKUMENDI_FAIL_old.VALINE_MANUS := OLD.VALINE_MANUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_FAIL_old.FAIL_ID := OLD.FAIL_ID;
		  DOKUMENDI_FAIL_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_FAIL_old.NIMI := OLD.NIMI;
		  DOKUMENDI_FAIL_old.SUURUS := OLD.SUURUS;
		  DOKUMENDI_FAIL_old.MIME_TYYP := OLD.MIME_TYYP;
		  DOKUMENDI_FAIL_old.SISU := OLD.SISU;
		  DOKUMENDI_FAIL_old.POHIFAIL := OLD.POHIFAIL;
		  DOKUMENDI_FAIL_old.VALINE_MANUS := OLD.VALINE_MANUS;
	  end if;	

	  execute dvklog.log_dokumendi_fail(dokumendi_fail_new, dokumendi_fail_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_fail (
    dokumendi_fail_new dvk.dokumendi_fail,
    dokumendi_fail_old dvk.dokumendi_fail,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_fail';    
	primary_key_value integer := dokumendi_fail_old.fail_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;


    -- fail_id changed
    IF(coalesce(dokumendi_fail_new.fail_id, 0) != coalesce(dokumendi_fail_old.fail_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fail_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.fail_id,
        dokumendi_fail_new.fail_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dokument_id changed
    IF(coalesce(dokumendi_fail_new.dokument_id, 0) != coalesce(dokumendi_fail_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.dokument_id,
        dokumendi_fail_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(dokumendi_fail_new.nimi, ' ') != coalesce(dokumendi_fail_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.nimi,
        dokumendi_fail_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- suurus changed
    IF(coalesce(dokumendi_fail_new.suurus, 0) != coalesce(dokumendi_fail_old.suurus, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('suurus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.suurus,
        dokumendi_fail_new.suurus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mime_tyyp changed
    IF(coalesce(dokumendi_fail_new.mime_tyyp, ' ') != coalesce(dokumendi_fail_old.mime_tyyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mime_tyyp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.mime_tyyp,
        dokumendi_fail_new.mime_tyyp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pohifail changed
    IF(coalesce(dokumendi_fail_new.pohifail, 0) != coalesce(dokumendi_fail_old.pohifail, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pohifail');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.pohifail,
        dokumendi_fail_new.pohifail,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- valine_manus changed
    IF(coalesce(dokumendi_fail_new.valine_manus, 0) != coalesce(dokumendi_fail_old.valine_manus, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('valine_manus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.valine_manus,
        dokumendi_fail_new.valine_manus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
  END;$$
LANGUAGE PLPGSQL;






CREATE OR REPLACE FUNCTION tr_dokumendi_metaandmed_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_metaandmed_new dokumendi_metaandmed%ROWTYPE;
	dokumendi_metaandmed_old dokumendi_metaandmed%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_METAANDMED_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NR := NEW.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_new.SAAJA_ASUTUSE_NR := NEW.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINIMI := NEW.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDITYYP := NEW.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINR := NEW.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_FAILINIMI := NEW.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KATALOOG := NEW.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_VOTMESONA := NEW.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KOKKUVOTE := NEW.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KUUPAEV := NEW.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NIMI := NEW.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_KONTAKT := NEW.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_new.AUTORI_OSAKOND := NEW.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_new.AUTORI_ISIKUKOOD := NEW.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_new.AUTORI_NIMI := NEW.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_new.AUTORI_KONTAKT := NEW.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_KOOSTAJAL := NEW.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_SAAJAL := NEW.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_new.SAATJA_DOKUMENDINR := NEW.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_new.SAATJA_KUUPAEV := NEW.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_new.SAATJA_ASUTUSE_KONTAKT := NEW.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_new.SAAJA_ISIKUKOOD := NEW.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_new.SAAJA_NIMI := NEW.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_new.SAAJA_OSAKOND := NEW.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DHL_ID := NEW.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_new.KOMMENTAAR := NEW.KOMMENTAAR;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DOKUMENDI_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NR := OLD.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.SAAJA_ASUTUSE_NR := OLD.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINIMI := OLD.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDITYYP := OLD.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINR := OLD.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_FAILINIMI := OLD.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KATALOOG := OLD.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_VOTMESONA := OLD.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KOKKUVOTE := OLD.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KUUPAEV := OLD.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NIMI := OLD.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_KONTAKT := OLD.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.AUTORI_OSAKOND := OLD.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_old.AUTORI_ISIKUKOOD := OLD.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.AUTORI_NIMI := OLD.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_old.AUTORI_KONTAKT := OLD.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_KOOSTAJAL := OLD.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_SAAJAL := OLD.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_old.SAATJA_DOKUMENDINR := OLD.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.SAATJA_KUUPAEV := OLD.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.SAATJA_ASUTUSE_KONTAKT := OLD.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SAAJA_ISIKUKOOD := OLD.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.SAAJA_NIMI := OLD.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_old.SAAJA_OSAKOND := OLD.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DHL_ID := OLD.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_old.KOMMENTAAR := OLD.KOMMENTAAR;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NR := OLD.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.SAAJA_ASUTUSE_NR := OLD.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINIMI := OLD.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDITYYP := OLD.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINR := OLD.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_FAILINIMI := OLD.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KATALOOG := OLD.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_VOTMESONA := OLD.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KOKKUVOTE := OLD.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KUUPAEV := OLD.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NIMI := OLD.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_KONTAKT := OLD.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.AUTORI_OSAKOND := OLD.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_old.AUTORI_ISIKUKOOD := OLD.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.AUTORI_NIMI := OLD.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_old.AUTORI_KONTAKT := OLD.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_KOOSTAJAL := OLD.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_SAAJAL := OLD.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_old.SAATJA_DOKUMENDINR := OLD.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.SAATJA_KUUPAEV := OLD.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.SAATJA_ASUTUSE_KONTAKT := OLD.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SAAJA_ISIKUKOOD := OLD.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.SAAJA_NIMI := OLD.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_old.SAAJA_OSAKOND := OLD.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DHL_ID := OLD.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_old.KOMMENTAAR := OLD.KOMMENTAAR;
	  end if;	

	  execute dvklog.log_dokumendi_metaandmed(dokumendi_metaandmed_new, dokumendi_metaandmed_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_metaandmed (
    dokumendi_metaandmed_new dvk.dokumendi_metaandmed,
    dokumendi_metaandmed_old dvk.dokumendi_metaandmed,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_metaandmed';    
	primary_key_value integer := dokumendi_metaandmed_old.dokument_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
		
    -- dokument_id changed
    IF(coalesce(dokumendi_metaandmed_new.dokument_id, 0) != coalesce(dokumendi_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.dokument_id,
        dokumendi_metaandmed_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_asutuse_nr changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_nr, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_nr,
        dokumendi_metaandmed_new.koostaja_asutuse_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saaja_asutuse_nr changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_asutuse_nr, ' ') != coalesce(dokumendi_metaandmed_old.saaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_asutuse_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_asutuse_nr,
        dokumendi_metaandmed_new.saaja_asutuse_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_dokumendinimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendinimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendinimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendinimi,
        dokumendi_metaandmed_new.koostaja_dokumendinimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_dokumendityyp changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendityyp, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendityyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendityyp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendityyp,
        dokumendi_metaandmed_new.koostaja_dokumendityyp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_dokumendinr changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendinr, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendinr,
        dokumendi_metaandmed_new.koostaja_dokumendinr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_failinimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_failinimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_failinimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_failinimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_failinimi,
        dokumendi_metaandmed_new.koostaja_failinimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_kataloog changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kataloog, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_kataloog, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kataloog');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kataloog,
        dokumendi_metaandmed_new.koostaja_kataloog,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_votmesona changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_votmesona, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_votmesona, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_votmesona');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_votmesona,
        dokumendi_metaandmed_new.koostaja_votmesona,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_kokkuvote changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kokkuvote, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_kokkuvote, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kokkuvote');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kokkuvote,
        dokumendi_metaandmed_new.koostaja_kokkuvote,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_kuupaev changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kuupaev, LOCALTIMESTAMP) != coalesce(dokumendi_metaandmed_old.koostaja_kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kuupaev');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kuupaev,
        dokumendi_metaandmed_new.koostaja_kuupaev,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_asutuse_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_nimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_nimi,
        dokumendi_metaandmed_new.koostaja_asutuse_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- koostaja_asutuse_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_kontakt');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_kontakt,
        dokumendi_metaandmed_new.koostaja_asutuse_kontakt,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- autori_osakond changed
    IF(coalesce(dokumendi_metaandmed_new.autori_osakond, ' ') != coalesce(dokumendi_metaandmed_old.autori_osakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_osakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_osakond,
        dokumendi_metaandmed_new.autori_osakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- autori_isikukood changed
    IF(coalesce(dokumendi_metaandmed_new.autori_isikukood, ' ') != coalesce(dokumendi_metaandmed_old.autori_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_isikukood,
        dokumendi_metaandmed_new.autori_isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- autori_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.autori_nimi, ' ') != coalesce(dokumendi_metaandmed_old.autori_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_nimi,
        dokumendi_metaandmed_new.autori_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- autori_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.autori_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.autori_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_kontakt');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_kontakt,
        dokumendi_metaandmed_new.autori_kontakt,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- seotud_dokumendinr_koostajal changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dokumendinr_koostajal, ' ') != coalesce(dokumendi_metaandmed_old.seotud_dokumendinr_koostajal, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_koostajal');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dokumendinr_koostajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_koostajal,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- seotud_dokumendinr_saajal changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dokumendinr_saajal, ' ') != coalesce(dokumendi_metaandmed_old.seotud_dokumendinr_saajal, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_saajal');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dokumendinr_saajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_saajal,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatja_dokumendinr changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_dokumendinr, ' ') != coalesce(dokumendi_metaandmed_old.saatja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_dokumendinr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_dokumendinr,
        dokumendi_metaandmed_new.saatja_dokumendinr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatja_kuupaev changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_kuupaev, LOCALTIMESTAMP) != coalesce(dokumendi_metaandmed_old.saatja_kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_kuupaev');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_kuupaev,
        dokumendi_metaandmed_new.saatja_kuupaev,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatja_asutuse_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_asutuse_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.saatja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_asutuse_kontakt');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_asutuse_kontakt,
        dokumendi_metaandmed_new.saatja_asutuse_kontakt,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saaja_isikukood changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_isikukood, ' ') != coalesce(dokumendi_metaandmed_old.saaja_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_isikukood,
        dokumendi_metaandmed_new.saaja_isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saaja_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_nimi, ' ') != coalesce(dokumendi_metaandmed_old.saaja_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_nimi,
        dokumendi_metaandmed_new.saaja_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saaja_osakond changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_osakond, ' ') != coalesce(dokumendi_metaandmed_old.saaja_osakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_osakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_osakond,
        dokumendi_metaandmed_new.saaja_osakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- seotud_dhl_id changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dhl_id, 0) != coalesce(dokumendi_metaandmed_old.seotud_dhl_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dhl_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dhl_id,
        dokumendi_metaandmed_new.seotud_dhl_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kommentaar changed
    IF(coalesce(dokumendi_metaandmed_new.kommentaar, ' ') != coalesce(dokumendi_metaandmed_old.kommentaar, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kommentaar');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.kommentaar,
        dokumendi_metaandmed_new.kommentaar,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_dokument_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokument_new dokument%ROWTYPE;
	dokument_old dokument%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  dokument_new.dokument_id := NEW.dokument_id;
		  dokument_new.asutus_id := NEW.asutus_id;
		  dokument_new.kaust_id := NEW.kaust_id;
		  dokument_new.sailitustahtaeg := NEW.sailitustahtaeg;
		  dokument_new.eelmise_versiooni_id := NEW.eelmise_versiooni_id;
		  dokument_new.versioon := NEW.versioon;
		  dokument_new.suurus := NEW.suurus;
		  dokument_new.guid := NEW.guid;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  dokument_old.dokument_id := OLD.dokument_id;
		  dokument_old.asutus_id := OLD.asutus_id;
		  dokument_old.kaust_id := OLD.kaust_id;
		  dokument_old.sailitustahtaeg := OLD.sailitustahtaeg;
		  dokument_old.eelmise_versiooni_id := OLD.eelmise_versiooni_id;
		  dokument_old.versioon := OLD.versioon;
		  dokument_old.suurus := OLD.suurus;
		  dokument_old.guid := OLD.guid;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  dokument_old.dokument_id := OLD.dokument_id;
		  dokument_old.asutus_id := OLD.asutus_id;
		  dokument_old.kaust_id := OLD.kaust_id;
		  dokument_old.sailitustahtaeg := OLD.sailitustahtaeg;
		  dokument_old.eelmise_versiooni_id := OLD.eelmise_versiooni_id;
		  dokument_old.versioon := OLD.versioon;
		  dokument_old.suurus := OLD.suurus;
		  dokument_old.guid := OLD.guid;
	  end if;	

	  execute dvklog.log_dokument(dokument_new, dokument_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    

		
CREATE OR REPLACE FUNCTION dvklog.log_dokument (
    dokument_new dvk.dokument,
    dokument_old dvk.dokument,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokument';    
	primary_key_value integer := dokument_old.dokument_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
    -- dokument_id changed
    IF(coalesce(dokument_new.dokument_id, 0) != coalesce(dokument_old.dokument_id, 0)) THEN
      --DEBUG('dokument_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.dokument_id,
        dokument_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(dokument_new.asutus_id, 0) != coalesce(dokument_old.asutus_id, 0)) THEN
      --DEBUG('asutus_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('asutus_id');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.asutus_id,
        dokument_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kaust_id changed
    IF(coalesce(dokument_new.kaust_id, 0) != coalesce(dokument_old.kaust_id, 0)) THEN
      --DEBUG('kaust_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('kaust_id');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.kaust_id,
        dokument_new.kaust_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- sailitustahtaeg changed
    IF(coalesce(dokument_new.sailitustahtaeg, LOCALTIMESTAMP) != coalesce(dokument_old.sailitustahtaeg, LOCALTIMESTAMP)) THEN
      --DEBUG('sailitustahtaeg changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('sailitustahtaeg');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.sailitustahtaeg,
        dokument_new.sailitustahtaeg,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- eelmise_versiooni_id changed
    IF(coalesce(dokument_new.eelmise_versiooni_id, 0) != coalesce(dokument_old.eelmise_versiooni_id, 0)) THEN
      --DEBUG('eelmise_versiooni_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('eelmise_versiooni_id');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.eelmise_versiooni_id,
        dokument_new.eelmise_versiooni_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- versioon changed
    IF(coalesce(dokument_new.versioon, 0) != coalesce(dokument_old.versioon, 0)) THEN
      --DEBUG('versioon changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('versioon');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.versioon,
        dokument_new.versioon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- suurus changed
    IF(coalesce(dokument_new.suurus, 0) != coalesce(dokument_old.suurus, 0)) THEN
      --DEBUG('suurus changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('suurus');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.suurus,
        dokument_new.suurus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- guid changed
    IF(coalesce(dokument_new.guid, ' ') != coalesce(dokument_old.guid, ' ')) THEN
      --DEBUG('guid changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('guid');
	  
	  p_id := nextval('sq_logi_id');
      
	  INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.guid,
        dokument_new.guid,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
		current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
			
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_dynaamilised_metaandmed_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dynaamilised_metaandmed_new dynaamilised_metaandmed%ROWTYPE;
	dynaamilised_metaandmed_old dynaamilised_metaandmed%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DYNAAMILISED_METAANDMED_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_new.NIMI := NEW.NIMI;
		  DYNAAMILISED_METAANDMED_new.VAARTUS := NEW.VAARTUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DYNAAMILISED_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_old.NIMI := OLD.NIMI;
		  DYNAAMILISED_METAANDMED_old.VAARTUS := OLD.VAARTUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DYNAAMILISED_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_old.NIMI := OLD.NIMI;
		  DYNAAMILISED_METAANDMED_old.VAARTUS := OLD.VAARTUS;
	  end if;	

	  execute dvklog.log_dynaamilised_metaandmed(dynaamilised_metaandmed_new, dynaamilised_metaandmed_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dynaamilised_metaandmed (
    dynaamilised_metaandmed_new dvk.dynaamilised_metaandmed,
    dynaamilised_metaandmed_old dvk.dynaamilised_metaandmed,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dynaamilised_metaandmed';    
    primary_key_value integer := dynaamilised_metaandmed_old.dokument_id;
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- dokument_id changed
    IF(coalesce(dynaamilised_metaandmed_new.dokument_id, 0) != coalesce(dynaamilised_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.dokument_id,
        dynaamilised_metaandmed_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(dynaamilised_metaandmed_new.nimi, ' ') != coalesce(dynaamilised_metaandmed_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.nimi,
        dynaamilised_metaandmed_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vaartus changed
    IF(coalesce(dynaamilised_metaandmed_new.vaartus, ' ') != coalesce(dynaamilised_metaandmed_old.vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vaartus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        0,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.vaartus,
        dynaamilised_metaandmed_new.vaartus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_ehak_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ehak_new ehak%ROWTYPE;
	ehak_old ehak%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  EHAK_new.EHAK_ID := NEW.EHAK_ID;
		  EHAK_new.NIMI := NEW.NIMI;
		  EHAK_new.ROOPNIMI := NEW.ROOPNIMI;
		  EHAK_new.TYYP := NEW.TYYP;
		  EHAK_new.MAAKOND := NEW.MAAKOND;
		  EHAK_new.VALD := NEW.VALD;
		  EHAK_new.CREATED := NEW.CREATED;
		  EHAK_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  EHAK_new.USERNAME := NEW.USERNAME;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  EHAK_old.EHAK_ID := OLD.EHAK_ID;
		  EHAK_old.NIMI := OLD.NIMI;
		  EHAK_old.ROOPNIMI := OLD.ROOPNIMI;
		  EHAK_old.TYYP := OLD.TYYP;
		  EHAK_old.MAAKOND := OLD.MAAKOND;
		  EHAK_old.VALD := OLD.VALD;
		  EHAK_old.CREATED := OLD.CREATED;
		  EHAK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  EHAK_old.USERNAME := OLD.USERNAME;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  EHAK_old.EHAK_ID := OLD.EHAK_ID;
		  EHAK_old.NIMI := OLD.NIMI;
		  EHAK_old.ROOPNIMI := OLD.ROOPNIMI;
		  EHAK_old.TYYP := OLD.TYYP;
		  EHAK_old.MAAKOND := OLD.MAAKOND;
		  EHAK_old.VALD := OLD.VALD;
		  EHAK_old.CREATED := OLD.CREATED;
		  EHAK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  EHAK_old.USERNAME := OLD.USERNAME;
	  end if;	

	  execute dvklog.log_ehak(ehak_new, ehak_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    

CREATE OR REPLACE FUNCTION dvklog.log_ehak (
    ehak_new dvk.ehak,
    ehak_old dvk.ehak,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ehak';    
    primary_key_value integer := ehak_old.ehak_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- ehak_id changed
    IF(coalesce(ehak_new.ehak_id, ' ') != coalesce(ehak_old.ehak_id, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ehak_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.ehak_id,
        ehak_new.ehak_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(ehak_new.nimi, ' ') != coalesce(ehak_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.nimi,
        ehak_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- roopnimi changed
    IF(coalesce(ehak_new.roopnimi, ' ') != coalesce(ehak_old.roopnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roopnimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.roopnimi,
        ehak_new.roopnimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tyyp changed
    IF(coalesce(ehak_new.tyyp, ' ') != coalesce(ehak_old.tyyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tyyp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.tyyp,
        ehak_new.tyyp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- maakond changed
    IF(coalesce(ehak_new.maakond, ' ') != coalesce(ehak_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.maakond,
        ehak_new.maakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vald changed
    IF(coalesce(ehak_new.vald, ' ') != coalesce(ehak_old.vald, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vald');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.vald,
        ehak_new.vald,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(ehak_new.created, LOCALTIMESTAMP) != coalesce(ehak_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.created,
        ehak_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(ehak_new.last_modified, LOCALTIMESTAMP) != coalesce(ehak_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.last_modified,
        ehak_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(ehak_new.username, ' ') != coalesce(ehak_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.username,
        ehak_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_isik_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	isik_new isik%ROWTYPE;
	isik_old isik%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  ISIK_new.I_ID := NEW.I_ID;
		  ISIK_new.KOOD := NEW.KOOD;
		  ISIK_new.PERENIMI := NEW.PERENIMI;
		  ISIK_new.EESNIMI := NEW.EESNIMI;
		  ISIK_new.MAAKOND := NEW.MAAKOND;
		  ISIK_new.AADRESS := NEW.AADRESS;
		  ISIK_new.POSTIKOOD := NEW.POSTIKOOD;
		  ISIK_new.TELEFON := NEW.TELEFON;
		  ISIK_new.E_POST := NEW.E_POST;
		  ISIK_new.WWW := NEW.WWW;
		  ISIK_new.PARAMS := NEW.PARAMS;
		  ISIK_new.CREATED := NEW.CREATED;
		  ISIK_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  ISIK_new.USERNAME := NEW.USERNAME;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  ISIK_old.I_ID := OLD.I_ID;
		  ISIK_old.KOOD := OLD.KOOD;
		  ISIK_old.PERENIMI := OLD.PERENIMI;
		  ISIK_old.EESNIMI := OLD.EESNIMI;
		  ISIK_old.MAAKOND := OLD.MAAKOND;
		  ISIK_old.AADRESS := OLD.AADRESS;
		  ISIK_old.POSTIKOOD := OLD.POSTIKOOD;
		  ISIK_old.TELEFON := OLD.TELEFON;
		  ISIK_old.E_POST := OLD.E_POST;
		  ISIK_old.WWW := OLD.WWW;
		  ISIK_old.PARAMS := OLD.PARAMS;
		  ISIK_old.CREATED := OLD.CREATED;
		  ISIK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ISIK_old.USERNAME := OLD.USERNAME;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  ISIK_old.I_ID := OLD.I_ID;
		  ISIK_old.KOOD := OLD.KOOD;
		  ISIK_old.PERENIMI := OLD.PERENIMI;
		  ISIK_old.EESNIMI := OLD.EESNIMI;
		  ISIK_old.MAAKOND := OLD.MAAKOND;
		  ISIK_old.AADRESS := OLD.AADRESS;
		  ISIK_old.POSTIKOOD := OLD.POSTIKOOD;
		  ISIK_old.TELEFON := OLD.TELEFON;
		  ISIK_old.E_POST := OLD.E_POST;
		  ISIK_old.WWW := OLD.WWW;
		  ISIK_old.PARAMS := OLD.PARAMS;
		  ISIK_old.CREATED := OLD.CREATED;
		  ISIK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ISIK_old.USERNAME := OLD.USERNAME;
	  end if;	

	  execute dvklog.log_isik(isik_new, isik_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_isik (
    isik_new dvk.isik,
    isik_old dvk.isik,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'isik';    
    primary_key_value integer := isik_old.i_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- i_id changed
    IF(coalesce(isik_new.i_id, 0) != coalesce(isik_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.i_id,
        isik_new.i_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kood changed
    IF(coalesce(isik_new.kood, ' ') != coalesce(isik_old.kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.kood,
        isik_new.kood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- perenimi changed
    IF(coalesce(isik_new.perenimi, ' ') != coalesce(isik_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.perenimi,
        isik_new.perenimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- eesnimi changed
    IF(coalesce(isik_new.eesnimi, ' ') != coalesce(isik_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.eesnimi,
        isik_new.eesnimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- maakond changed
    IF(coalesce(isik_new.maakond, ' ') != coalesce(isik_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.maakond,
        isik_new.maakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aadress changed
    IF(coalesce(isik_new.aadress, ' ') != coalesce(isik_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.aadress,
        isik_new.aadress,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- postikood changed
    IF(coalesce(isik_new.postikood, ' ') != coalesce(isik_old.postikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('postikood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.postikood,
        isik_new.postikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- telefon changed
    IF(coalesce(isik_new.telefon, ' ') != coalesce(isik_old.telefon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('telefon');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.telefon,
        isik_new.telefon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- e_post changed
    IF(coalesce(isik_new.e_post, ' ') != coalesce(isik_old.e_post, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_post');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.e_post,
        isik_new.e_post,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- www changed
    IF(coalesce(isik_new.www, ' ') != coalesce(isik_old.www, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('www');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.www,
        isik_new.www,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- params changed
    IF(coalesce(isik_new.params, ' ') != coalesce(isik_old.params, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.params,
        isik_new.params,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(isik_new.created, LOCALTIMESTAMP) != coalesce(isik_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.created,
        isik_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(isik_new.last_modified, LOCALTIMESTAMP) != coalesce(isik_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.last_modified,
        isik_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(isik_new.username, ' ') != coalesce(isik_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.username,
        isik_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_kaust_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	kaust_new kaust%ROWTYPE;
	kaust_old kaust%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  kaust_new.kaust_id := NEW.kaust_id;
		  kaust_new.nimi := NEW.nimi;
		  kaust_new.ylemkaust_id := NEW.ylemkaust_id;
		  kaust_new.asutus_id := NEW.asutus_id;
		  kaust_new.kausta_number := NEW.kausta_number;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  kaust_old.kaust_id := OLD.kaust_id;
		  kaust_old.nimi := OLD.nimi;
		  kaust_old.ylemkaust_id := OLD.ylemkaust_id;
		  kaust_old.asutus_id := OLD.asutus_id;
		  kaust_old.kausta_number := OLD.kausta_number;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  kaust_old.kaust_id := OLD.kaust_id;
		  kaust_old.nimi := OLD.nimi;
		  kaust_old.ylemkaust_id := OLD.ylemkaust_id;
		  kaust_old.asutus_id := OLD.asutus_id;
		  kaust_old.kausta_number := OLD.kausta_number;
	  end if;	

	  execute dvklog.log_kaust(kaust_new, kaust_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_kaust (
    kaust_new dvk.kaust,
    kaust_old dvk.kaust,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'kaust';    
    primary_key_value integer := kaust_old.kaust_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- kaust_id changed
    IF(coalesce(kaust_new.kaust_id, 0) != coalesce(kaust_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.kaust_id,
        kaust_new.kaust_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(kaust_new.nimi, ' ') != coalesce(kaust_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.nimi,
        kaust_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ylemkaust_id changed
    IF(coalesce(kaust_new.ylemkaust_id, 0) != coalesce(kaust_old.ylemkaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ylemkaust_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.ylemkaust_id,
        kaust_new.ylemkaust_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(kaust_new.asutus_id, 0) != coalesce(kaust_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.asutus_id,
        kaust_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kausta_number changed
    IF(coalesce(kaust_new.kausta_number, ' ') != coalesce(kaust_old.kausta_number, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kausta_number');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.kausta_number,
        kaust_new.kausta_number,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    


		

CREATE OR REPLACE FUNCTION tr_klassifikaatori_tyyp_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	klassifikaatori_tyyp_new klassifikaatori_tyyp%ROWTYPE;
	klassifikaatori_tyyp_old klassifikaatori_tyyp%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KLASSIFIKAATORI_TYYP_new.KLASSIFIKAATORI_TYYP_ID := NEW.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_new.NIMETUS := NEW.NIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KLASSIFIKAATORI_TYYP_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_old.NIMETUS := OLD.NIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KLASSIFIKAATORI_TYYP_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_old.NIMETUS := OLD.NIMETUS;
	  end if;	

	  execute dvklog.log_klassifikaatori_tyyp(klassifikaatori_tyyp_new, klassifikaatori_tyyp_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		

CREATE OR REPLACE FUNCTION dvklog.log_klassifikaatori_tyyp (
    klassifikaatori_tyyp_new dvk.klassifikaatori_tyyp,
    klassifikaatori_tyyp_old dvk.klassifikaatori_tyyp,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'klassifikaatori_tyyp';    
    primary_key_value integer := klassifikaatori_tyyp_old.klassifikaatori_tyyp_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- klassifikaatori_tyyp_id changed
    IF(coalesce(klassifikaatori_tyyp_new.klassifikaatori_tyyp_id, 0) != coalesce(klassifikaatori_tyyp_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaatori_tyyp_old.klassifikaatori_tyyp_id,
        klassifikaatori_tyyp_new.klassifikaatori_tyyp_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimetus changed
    IF(coalesce(klassifikaatori_tyyp_new.nimetus, ' ') != coalesce(klassifikaatori_tyyp_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaatori_tyyp_old.nimetus,
        klassifikaatori_tyyp_new.nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_klassifikaator_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	klassifikaator_new klassifikaator%ROWTYPE;
	klassifikaator_old klassifikaator%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KLASSIFIKAATOR_new.KLASSIFIKAATOR_ID := NEW.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_new.NIMETUS := NEW.NIMETUS;
		  KLASSIFIKAATOR_new.KLASSIFIKAATORI_TYYP_ID := NEW.KLASSIFIKAATORI_TYYP_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KLASSIFIKAATOR_old.KLASSIFIKAATOR_ID := OLD.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_old.NIMETUS := OLD.NIMETUS;
		  KLASSIFIKAATOR_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KLASSIFIKAATOR_old.KLASSIFIKAATOR_ID := OLD.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_old.NIMETUS := OLD.NIMETUS;
		  KLASSIFIKAATOR_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
	  end if;	

	  execute dvklog.log_klassifikaator(klassifikaator_new, klassifikaator_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		

CREATE OR REPLACE FUNCTION dvklog.log_klassifikaator (
    klassifikaator_new dvk.klassifikaator,
    klassifikaator_old dvk.klassifikaator,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'klassifikaator';    
    primary_key_value integer := klassifikaator_old.klassifikaator_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- klassifikaator_id changed
    IF(coalesce(klassifikaator_new.klassifikaator_id, 0) != coalesce(klassifikaator_old.klassifikaator_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaator_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.klassifikaator_id,
        klassifikaator_new.klassifikaator_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimetus changed
    IF(coalesce(klassifikaator_new.nimetus, ' ') != coalesce(klassifikaator_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.nimetus,
        klassifikaator_new.nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- klassifikaatori_tyyp_id changed
    IF(coalesce(klassifikaator_new.klassifikaatori_tyyp_id, 0) != coalesce(klassifikaator_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.klassifikaatori_tyyp_id,
        klassifikaator_new.klassifikaatori_tyyp_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_konversioon_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	konversioon_new konversioon%ROWTYPE;
	konversioon_old konversioon%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KONVERSIOON_new.ID := NEW.ID;
		  KONVERSIOON_new.VERSION := NEW.VERSION;
		  KONVERSIOON_new.RESULT_VERSION := NEW.RESULT_VERSION;
		  KONVERSIOON_new.XSLT := NEW.XSLT;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KONVERSIOON_old.ID := OLD.ID;
		  KONVERSIOON_old.VERSION := OLD.VERSION;
		  KONVERSIOON_old.RESULT_VERSION := OLD.RESULT_VERSION;
		  KONVERSIOON_old.XSLT := OLD.XSLT;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KONVERSIOON_old.ID := OLD.ID;
		  KONVERSIOON_old.VERSION := OLD.VERSION;
		  KONVERSIOON_old.RESULT_VERSION := OLD.RESULT_VERSION;
		  KONVERSIOON_old.XSLT := OLD.XSLT;
	  end if;	

	  execute dvklog.log_konversioon(konversioon_new, konversioon_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_konversioon (
    konversioon_new dvk.konversioon,
    konversioon_old dvk.konversioon,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'konversioon';    
    primary_key_value integer := konversioon_old.id;
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;
	


    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- id changed
    IF(coalesce(konversioon_new.id, 0) != coalesce(konversioon_old.id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.id,
        konversioon_new.id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- version changed
    IF(coalesce(konversioon_new.version, 0) != coalesce(konversioon_old.version, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('version');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.version,
        konversioon_new.version,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- result_version changed
    IF(coalesce(konversioon_new.result_version, 0) != coalesce(konversioon_old.result_version, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('result_version');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.result_version,
        konversioon_new.result_version,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_oigus_antud_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	oigus_antud_new oigus_antud%ROWTYPE;
	oigus_antud_old oigus_antud%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  OIGUS_ANTUD_new.OIGUS_ANTUD_ID := NEW.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  OIGUS_ANTUD_new.MUU_ASUTUS_ID := NEW.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  OIGUS_ANTUD_new.ROLL := NEW.ROLL;
		  OIGUS_ANTUD_new.ALATES := NEW.ALATES;
		  OIGUS_ANTUD_new.KUNI := NEW.KUNI;
		  OIGUS_ANTUD_new.CREATED := NEW.CREATED;
		  OIGUS_ANTUD_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  OIGUS_ANTUD_new.USERNAME := NEW.USERNAME;
		  OIGUS_ANTUD_new.PEATATUD := NEW.PEATATUD;
		  OIGUS_ANTUD_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  OIGUS_ANTUD_old.OIGUS_ANTUD_ID := OLD.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_ANTUD_old.MUU_ASUTUS_ID := OLD.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_ANTUD_old.ROLL := OLD.ROLL;
		  OIGUS_ANTUD_old.ALATES := OLD.ALATES;
		  OIGUS_ANTUD_old.KUNI := OLD.KUNI;
		  OIGUS_ANTUD_old.CREATED := OLD.CREATED;
		  OIGUS_ANTUD_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  OIGUS_ANTUD_old.USERNAME := OLD.USERNAME;
		  OIGUS_ANTUD_old.PEATATUD := OLD.PEATATUD;
		  OIGUS_ANTUD_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  OIGUS_ANTUD_old.OIGUS_ANTUD_ID := OLD.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_ANTUD_old.MUU_ASUTUS_ID := OLD.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_ANTUD_old.ROLL := OLD.ROLL;
		  OIGUS_ANTUD_old.ALATES := OLD.ALATES;
		  OIGUS_ANTUD_old.KUNI := OLD.KUNI;
		  OIGUS_ANTUD_old.CREATED := OLD.CREATED;
		  OIGUS_ANTUD_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  OIGUS_ANTUD_old.USERNAME := OLD.USERNAME;
		  OIGUS_ANTUD_old.PEATATUD := OLD.PEATATUD;
		  OIGUS_ANTUD_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
	  end if;	

	  execute dvklog.log_oigus_antud(oigus_antud_new, oigus_antud_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_oigus_antud (
    oigus_antud_new dvk.oigus_antud,
    oigus_antud_old dvk.oigus_antud,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'oigus_antud';    
    primary_key_value integer := oigus_antud_old.oigus_antud_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- oigus_antud_id changed
    IF(coalesce(oigus_antud_new.oigus_antud_id, 0) != coalesce(oigus_antud_old.oigus_antud_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_antud_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.oigus_antud_id,
        oigus_antud_new.oigus_antud_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(oigus_antud_new.asutus_id, 0) != coalesce(oigus_antud_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.asutus_id,
        oigus_antud_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- muu_asutus_id changed
    IF(coalesce(oigus_antud_new.muu_asutus_id, 0) != coalesce(oigus_antud_old.muu_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muu_asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.muu_asutus_id,
        oigus_antud_new.muu_asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(oigus_antud_new.ametikoht_id, 0) != coalesce(oigus_antud_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.ametikoht_id,
        oigus_antud_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- roll changed
    IF(coalesce(oigus_antud_new.roll, ' ') != coalesce(oigus_antud_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.roll,
        oigus_antud_new.roll,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- alates changed
    IF(coalesce(oigus_antud_new.alates, LOCALTIMESTAMP) != coalesce(oigus_antud_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.alates,
        oigus_antud_new.alates,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kuni changed
    IF(coalesce(oigus_antud_new.kuni, LOCALTIMESTAMP) != coalesce(oigus_antud_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.kuni,
        oigus_antud_new.kuni,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(oigus_antud_new.created, LOCALTIMESTAMP) != coalesce(oigus_antud_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.created,
        oigus_antud_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(oigus_antud_new.last_modified, LOCALTIMESTAMP) != coalesce(oigus_antud_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.last_modified,
        oigus_antud_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(oigus_antud_new.username, ' ') != coalesce(oigus_antud_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.username,
        oigus_antud_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- peatatud changed
    IF(coalesce(oigus_antud_new.peatatud, 0) != coalesce(oigus_antud_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.peatatud,
        oigus_antud_new.peatatud,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(oigus_antud_new.allyksus_id, 0) != coalesce(oigus_antud_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.allyksus_id,
        oigus_antud_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_oigus_objektile_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	oigus_objektile_new oigus_objektile%ROWTYPE;
	oigus_objektile_old oigus_objektile%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  OIGUS_OBJEKTILE_new.OIGUS_OBJEKTILE_ID := NEW.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  OIGUS_OBJEKTILE_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_new.KAUST_ID := NEW.KAUST_ID;
		  OIGUS_OBJEKTILE_new.KEHTIB_ALATES := NEW.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_new.KEHTIB_KUNI := NEW.KEHTIB_KUNI;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  OIGUS_OBJEKTILE_old.OIGUS_OBJEKTILE_ID := OLD.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_OBJEKTILE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_old.KAUST_ID := OLD.KAUST_ID;
		  OIGUS_OBJEKTILE_old.KEHTIB_ALATES := OLD.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_old.KEHTIB_KUNI := OLD.KEHTIB_KUNI;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  OIGUS_OBJEKTILE_old.OIGUS_OBJEKTILE_ID := OLD.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_OBJEKTILE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_old.KAUST_ID := OLD.KAUST_ID;
		  OIGUS_OBJEKTILE_old.KEHTIB_ALATES := OLD.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_old.KEHTIB_KUNI := OLD.KEHTIB_KUNI;
	  end if;	

	  execute dvklog.log_oigus_objektile(oigus_objektile_new, oigus_objektile_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_oigus_objektile (
    oigus_objektile_new dvk.oigus_objektile,
    oigus_objektile_old dvk.oigus_objektile,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'oigus_objektile';    
    primary_key_value integer := oigus_objektile_old.oigus_objektile_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
    -- oigus_objektile_id changed
    IF(coalesce(oigus_objektile_new.oigus_objektile_id, 0) != coalesce(oigus_objektile_old.oigus_objektile_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_objektile_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.oigus_objektile_id,
        oigus_objektile_new.oigus_objektile_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(oigus_objektile_new.asutus_id, 0) != coalesce(oigus_objektile_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.asutus_id,
        oigus_objektile_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(oigus_objektile_new.ametikoht_id, 0) != coalesce(oigus_objektile_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.ametikoht_id,
        oigus_objektile_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dokument_id changed
    IF(coalesce(oigus_objektile_new.dokument_id, 0) != coalesce(oigus_objektile_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.dokument_id,
        oigus_objektile_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kaust_id changed
    IF(coalesce(oigus_objektile_new.kaust_id, 0) != coalesce(oigus_objektile_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kaust_id,
        oigus_objektile_new.kaust_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kehtib_alates changed
    IF(coalesce(oigus_objektile_new.kehtib_alates, LOCALTIMESTAMP) != coalesce(oigus_objektile_old.kehtib_alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_alates');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kehtib_alates,
        oigus_objektile_new.kehtib_alates,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kehtib_kuni changed
    IF(coalesce(oigus_objektile_new.kehtib_kuni, LOCALTIMESTAMP) != coalesce(oigus_objektile_old.kehtib_kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_kuni');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kehtib_kuni,
        oigus_objektile_new.kehtib_kuni,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
				
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_parameetrid_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	parameetrid_new parameetrid%ROWTYPE;
	parameetrid_old parameetrid%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  PARAMEETRID_new.AAR_VIIMANE_SYNC := NEW.AAR_VIIMANE_SYNC;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  PARAMEETRID_old.AAR_VIIMANE_SYNC := OLD.AAR_VIIMANE_SYNC;		  
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  PARAMEETRID_old.AAR_VIIMANE_SYNC := OLD.AAR_VIIMANE_SYNC;		  
	  end if;	

	  execute dvklog.log_parameetrid(parameetrid_new, parameetrid_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_parameetrid (
    parameetrid_new dvk.parameetrid,
    parameetrid_old dvk.parameetrid,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'parameetrid';    
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- aar_viimane_sync changed
    IF(coalesce(parameetrid_new.aar_viimane_sync, LOCALTIMESTAMP) != coalesce(parameetrid_old.aar_viimane_sync, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_viimane_sync');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        null, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        parameetrid_old.aar_viimane_sync,
        parameetrid_new.aar_viimane_sync,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_saatja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	saatja_new saatja%ROWTYPE;
	saatja_old saatja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  saatja_new.saatja_id := NEW.saatja_id;
		  saatja_new.transport_id := NEW.transport_id;
		  saatja_new.asutus_id := NEW.asutus_id;
		  saatja_new.ametikoht_id := NEW.ametikoht_id;
		  saatja_new.isikukood := NEW.isikukood;
		  saatja_new.nimi := NEW.nimi;
		  saatja_new.email := NEW.email;
		  saatja_new.osakonna_nr := NEW.osakonna_nr;
		  saatja_new.osakonna_nimi := NEW.osakonna_nimi;
		  saatja_new.asutuse_nimi := NEW.asutuse_nimi;
		  saatja_new.allyksus_id := NEW.allyksus_id;
		  saatja_new.allyksuse_lyhinimetus := NEW.allyksuse_lyhinimetus;
		  saatja_new.ametikoha_lyhinimetus := NEW.ametikoha_lyhinimetus;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  saatja_old.saatja_id := OLD.saatja_id;
		  saatja_old.transport_id := OLD.transport_id;
		  saatja_old.asutus_id := OLD.asutus_id;
		  saatja_old.ametikoht_id := OLD.ametikoht_id;
		  saatja_old.isikukood := OLD.isikukood;
		  saatja_old.nimi := OLD.nimi;
		  saatja_old.email := OLD.email;
		  saatja_old.osakonna_nr := OLD.osakonna_nr;
		  saatja_old.osakonna_nimi := OLD.osakonna_nimi;
		  saatja_old.asutuse_nimi := OLD.asutuse_nimi;
		  saatja_old.allyksus_id := OLD.allyksus_id;
		  saatja_old.allyksuse_lyhinimetus := OLD.allyksuse_lyhinimetus;
		  saatja_old.ametikoha_lyhinimetus := OLD.ametikoha_lyhinimetus;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  saatja_old.saatja_id := OLD.saatja_id;
		  saatja_old.transport_id := OLD.transport_id;
		  saatja_old.asutus_id := OLD.asutus_id;
		  saatja_old.ametikoht_id := OLD.ametikoht_id;
		  saatja_old.isikukood := OLD.isikukood;
		  saatja_old.nimi := OLD.nimi;
		  saatja_old.email := OLD.email;
		  saatja_old.osakonna_nr := OLD.osakonna_nr;
		  saatja_old.osakonna_nimi := OLD.osakonna_nimi;
		  saatja_old.asutuse_nimi := OLD.asutuse_nimi;
		  saatja_old.allyksus_id := OLD.allyksus_id;
		  saatja_old.allyksuse_lyhinimetus := OLD.allyksuse_lyhinimetus;
		  saatja_old.ametikoha_lyhinimetus := OLD.ametikoha_lyhinimetus;

	  end if;	

	  execute dvklog.log_saatja(saatja_new, saatja_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_saatja (
    saatja_new dvk.saatja,
    saatja_old dvk.saatja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'saatja';  
    primary_key_value integer := saatja_old.saatja_id;		
	p_id int4;	

BEGIN	

	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- saatja_id changed
    IF(coalesce(saatja_new.saatja_id, 0) != coalesce(saatja_old.saatja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.saatja_id,
        saatja_new.saatja_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- transport_id changed
    IF(coalesce(saatja_new.transport_id, 0) != coalesce(saatja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.transport_id,
        saatja_new.transport_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(saatja_new.asutus_id, 0) != coalesce(saatja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.asutus_id,
        saatja_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(saatja_new.ametikoht_id, 0) != coalesce(saatja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.ametikoht_id,
        saatja_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- isikukood changed
    IF(coalesce(saatja_new.isikukood, ' ') != coalesce(saatja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.isikukood,
        saatja_new.isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(saatja_new.nimi, ' ') != coalesce(saatja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.nimi,
        saatja_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- email changed
    IF(coalesce(saatja_new.email, ' ') != coalesce(saatja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.email,
        saatja_new.email,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nr changed
    IF(coalesce(saatja_new.osakonna_nr, ' ') != coalesce(saatja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.osakonna_nr,
        saatja_new.osakonna_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nimi changed
    IF(coalesce(saatja_new.osakonna_nimi, ' ') != coalesce(saatja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.osakonna_nimi,
        saatja_new.osakonna_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutuse_nimi changed
    IF(coalesce(saatja_new.asutuse_nimi, ' ') != coalesce(saatja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.asutuse_nimi,
        saatja_new.asutuse_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(saatja_new.allyksus_id, 0) != coalesce(saatja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.allyksus_id,
        saatja_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksuse_lyhinimetus changed
    IF(coalesce(saatja_new.allyksuse_lyhinimetus, ' ') != coalesce(saatja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.allyksuse_lyhinimetus,
        saatja_new.allyksuse_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoha_lyhinimetus changed
    IF(coalesce(saatja_new.ametikoha_lyhinimetus, ' ') != coalesce(saatja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.ametikoha_lyhinimetus,
        saatja_new.ametikoha_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_server_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	server_new server%ROWTYPE;
	server_old server%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  SERVER_new.SERVER_ID := NEW.SERVER_ID;
		  SERVER_new.ANDMEKOGU_NIMI := NEW.ANDMEKOGU_NIMI;
		  SERVER_new.AADRESS := NEW.AADRESS;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  SERVER_old.SERVER_ID := OLD.SERVER_ID;
		  SERVER_old.ANDMEKOGU_NIMI := OLD.ANDMEKOGU_NIMI;
		  SERVER_old.AADRESS := OLD.AADRESS;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  SERVER_old.SERVER_ID := OLD.SERVER_ID;
		  SERVER_old.ANDMEKOGU_NIMI := OLD.ANDMEKOGU_NIMI;
		  SERVER_old.AADRESS := OLD.AADRESS;
	  end if;	

	  execute dvklog.log_server(server_new, server_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_server (
    server_new dvk.server,
    server_old dvk.server,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'server';  
    primary_key_value integer := server_old.server_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
    -- server_id changed
    IF(coalesce(server_new.server_id, 0) != coalesce(server_old.server_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('server_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.server_id,
        server_new.server_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- andmekogu_nimi changed
    IF(coalesce(server_new.andmekogu_nimi, ' ') != coalesce(server_old.andmekogu_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('andmekogu_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.andmekogu_nimi,
        server_new.andmekogu_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aadress changed
    IF(coalesce(server_new.aadress, ' ') != coalesce(server_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.aadress,
        server_new.aadress,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_staatuse_ajalugu_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	staatuse_ajalugu_new staatuse_ajalugu%ROWTYPE;
	staatuse_ajalugu_old staatuse_ajalugu%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  staatuse_ajalugu_new.STAATUSE_AJALUGU_ID := NEW.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_new.VASTUVOTJA_ID := NEW.VASTUVOTJA_ID;
		  staatuse_ajalugu_new.STAATUS_ID := NEW.STAATUS_ID;
		  staatuse_ajalugu_new.STAATUSE_MUUTMISE_AEG := NEW.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_new.FAULT_CODE := NEW.FAULT_CODE;
		  staatuse_ajalugu_new.FAULT_ACTOR := NEW.FAULT_ACTOR;
		  staatuse_ajalugu_new.FAULT_STRING := NEW.FAULT_STRING;
		  staatuse_ajalugu_new.FAULT_DETAIL := NEW.FAULT_DETAIL;
		  staatuse_ajalugu_new.VASTUVOTJA_STAATUS_ID := NEW.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_new.METAXML := NEW.METAXML;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  staatuse_ajalugu_old.STAATUSE_AJALUGU_ID := OLD.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_old.VASTUVOTJA_ID := OLD.VASTUVOTJA_ID;
		  staatuse_ajalugu_old.STAATUS_ID := OLD.STAATUS_ID;
		  staatuse_ajalugu_old.STAATUSE_MUUTMISE_AEG := OLD.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_old.FAULT_CODE := OLD.FAULT_CODE;
		  staatuse_ajalugu_old.FAULT_ACTOR := OLD.FAULT_ACTOR;
		  staatuse_ajalugu_old.FAULT_STRING := OLD.FAULT_STRING;
		  staatuse_ajalugu_old.FAULT_DETAIL := OLD.FAULT_DETAIL;
		  staatuse_ajalugu_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_old.METAXML := OLD.METAXML;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  staatuse_ajalugu_old.STAATUSE_AJALUGU_ID := OLD.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_old.VASTUVOTJA_ID := OLD.VASTUVOTJA_ID;
		  staatuse_ajalugu_old.STAATUS_ID := OLD.STAATUS_ID;
		  staatuse_ajalugu_old.STAATUSE_MUUTMISE_AEG := OLD.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_old.FAULT_CODE := OLD.FAULT_CODE;
		  staatuse_ajalugu_old.FAULT_ACTOR := OLD.FAULT_ACTOR;
		  staatuse_ajalugu_old.FAULT_STRING := OLD.FAULT_STRING;
		  staatuse_ajalugu_old.FAULT_DETAIL := OLD.FAULT_DETAIL;
		  staatuse_ajalugu_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_old.METAXML := OLD.METAXML;
	  end if;	

	  execute dvklog.log_staatuse_ajalugu(staatuse_ajalugu_new, staatuse_ajalugu_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_staatuse_ajalugu (
    staatuse_ajalugu_new dvk.staatuse_ajalugu,
    staatuse_ajalugu_old dvk.staatuse_ajalugu,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'staatuse_ajalugu';  
    primary_key_value integer := staatuse_ajalugu_old.staatuse_ajalugu_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		

    -- staatuse_ajalugu_id changed
    IF(coalesce(staatuse_ajalugu_new.staatuse_ajalugu_id, 0) != coalesce(staatuse_ajalugu_old.staatuse_ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_ajalugu_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatuse_ajalugu_id,
        staatuse_ajalugu_new.staatuse_ajalugu_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vastuvotja_id changed
    IF(coalesce(staatuse_ajalugu_new.vastuvotja_id, 0) != coalesce(staatuse_ajalugu_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.vastuvotja_id,
        staatuse_ajalugu_new.vastuvotja_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- staatus_id changed
    IF(coalesce(staatuse_ajalugu_new.staatus_id, 0) != coalesce(staatuse_ajalugu_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatus_id,
        staatuse_ajalugu_new.staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- staatuse_muutmise_aeg changed
    IF(coalesce(staatuse_ajalugu_new.staatuse_muutmise_aeg, LOCALTIMESTAMP) != coalesce(staatuse_ajalugu_old.staatuse_muutmise_aeg, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_muutmise_aeg');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatuse_muutmise_aeg,
        staatuse_ajalugu_new.staatuse_muutmise_aeg,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_code changed
    IF(coalesce(staatuse_ajalugu_new.fault_code, ' ') != coalesce(staatuse_ajalugu_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_code,
        staatuse_ajalugu_new.fault_code,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_actor changed
    IF(coalesce(staatuse_ajalugu_new.fault_actor, ' ') != coalesce(staatuse_ajalugu_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_actor,
        staatuse_ajalugu_new.fault_actor,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_string changed
    IF(coalesce(staatuse_ajalugu_new.fault_string, ' ') != coalesce(staatuse_ajalugu_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_string,
        staatuse_ajalugu_new.fault_string,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fault_detail changed
    IF(coalesce(staatuse_ajalugu_new.fault_detail, ' ') != coalesce(staatuse_ajalugu_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_detail,
        staatuse_ajalugu_new.fault_detail,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vastuvotja_staatus_id changed
    IF(coalesce(staatuse_ajalugu_new.vastuvotja_staatus_id, 0) != coalesce(staatuse_ajalugu_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.vastuvotja_staatus_id,
        staatuse_ajalugu_new.vastuvotja_staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
END;$$ 
LANGUAGE PLPGSQL;    

		

CREATE OR REPLACE FUNCTION tr_transport_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	transport_new transport%ROWTYPE;
	transport_old transport%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  transport_new.transport_id := NEW.transport_id;
		  transport_new.dokument_id := NEW.dokument_id;
		  transport_new.saatmise_algus := NEW.saatmise_algus;
		  transport_new.saatmise_lopp := NEW.saatmise_lopp;
		  transport_new.staatus_id := NEW.staatus_id;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  transport_old.transport_id := OLD.transport_id;
		  transport_old.dokument_id := OLD.dokument_id;
		  transport_old.saatmise_algus := OLD.saatmise_algus;
		  transport_old.saatmise_lopp := OLD.saatmise_lopp;
		  transport_old.staatus_id := OLD.staatus_id;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  transport_old.transport_id := OLD.transport_id;
		  transport_old.dokument_id := OLD.dokument_id;
		  transport_old.saatmise_algus := OLD.saatmise_algus;
		  transport_old.saatmise_lopp := OLD.saatmise_lopp;
		  transport_old.staatus_id := OLD.staatus_id;
	  end if;	

	  execute dvklog.log_transport(transport_new, transport_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION dvklog.log_transport (
    transport_new dvk.transport,
    transport_old dvk.transport,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'transport';  
    primary_key_value integer := transport_old.transport_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- transport_id changed
    IF(coalesce(transport_new.transport_id, 0) != coalesce(transport_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.transport_id,
        transport_new.transport_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dokument_id changed
    IF(coalesce(transport_new.dokument_id, 0) != coalesce(transport_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.dokument_id,
        transport_new.dokument_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmise_algus changed
    IF(coalesce(transport_new.saatmise_algus, LOCALTIMESTAMP) != coalesce(transport_old.saatmise_algus, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.saatmise_algus,
        transport_new.saatmise_algus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmise_lopp changed
    IF(coalesce(transport_new.saatmise_lopp, LOCALTIMESTAMP) != coalesce(transport_old.saatmise_lopp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.saatmise_lopp,
        transport_new.saatmise_lopp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- staatus_id changed
    IF(coalesce(transport_new.staatus_id, 0) != coalesce(transport_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.staatus_id,
        transport_new.staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;		
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_vahendaja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vahendaja_new vahendaja%ROWTYPE;
	vahendaja_old vahendaja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  vahendaja_new.VAHENDAJA_ID := NEW.VAHENDAJA_ID;
		  vahendaja_new.TRANSPORT_ID := NEW.TRANSPORT_ID;
		  vahendaja_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  vahendaja_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  vahendaja_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  vahendaja_new.NIMI := NEW.NIMI;
		  vahendaja_new.EMAIL := NEW.EMAIL;
		  vahendaja_new.OSAKONNA_NR := NEW.OSAKONNA_NR;
		  vahendaja_new.OSAKONNA_NIMI := NEW.OSAKONNA_NIMI;
		  vahendaja_new.ASUTUSE_NIMI := NEW.ASUTUSE_NIMI;
		  vahendaja_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  vahendaja_new.ALLYKSUSE_LYHINIMETUS := NEW.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_new.AMETIKOHA_LYHINIMETUS := NEW.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  vahendaja_old.VAHENDAJA_ID := OLD.VAHENDAJA_ID;
		  vahendaja_old.TRANSPORT_ID := OLD.TRANSPORT_ID;
		  vahendaja_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  vahendaja_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  vahendaja_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  vahendaja_old.NIMI := OLD.NIMI;
		  vahendaja_old.EMAIL := OLD.EMAIL;
		  vahendaja_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  vahendaja_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  vahendaja_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  vahendaja_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  vahendaja_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  vahendaja_old.VAHENDAJA_ID := OLD.VAHENDAJA_ID;
		  vahendaja_old.TRANSPORT_ID := OLD.TRANSPORT_ID;
		  vahendaja_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  vahendaja_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  vahendaja_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  vahendaja_old.NIMI := OLD.NIMI;
		  vahendaja_old.EMAIL := OLD.EMAIL;
		  vahendaja_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  vahendaja_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  vahendaja_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  vahendaja_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  vahendaja_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	  end if;	

	  execute dvklog.log_vahendaja(vahendaja_new, vahendaja_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		
CREATE OR REPLACE FUNCTION dvklog.log_vahendaja (
    vahendaja_new dvk.vahendaja,
    vahendaja_old dvk.vahendaja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vahendaja';  
    primary_key_value integer := vahendaja_old.vahendaja_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- vahendaja_id changed
    IF(coalesce(vahendaja_new.vahendaja_id, 0) != coalesce(vahendaja_old.vahendaja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vahendaja_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.vahendaja_id,
        vahendaja_new.vahendaja_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- transport_id changed
    IF(coalesce(vahendaja_new.transport_id, 0) != coalesce(vahendaja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.transport_id,
        vahendaja_new.transport_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(vahendaja_new.asutus_id, 0) != coalesce(vahendaja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.asutus_id,
        vahendaja_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(vahendaja_new.ametikoht_id, 0) != coalesce(vahendaja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.ametikoht_id,
        vahendaja_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;


    -- isikukood changed
    IF(coalesce(vahendaja_new.isikukood, ' ') != coalesce(vahendaja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.isikukood,
        vahendaja_new.isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(vahendaja_new.nimi, ' ') != coalesce(vahendaja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.nimi,
        vahendaja_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- email changed
    IF(coalesce(vahendaja_new.email, ' ') != coalesce(vahendaja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.email,
        vahendaja_new.email,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nr changed
    IF(coalesce(vahendaja_new.osakonna_nr, ' ') != coalesce(vahendaja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.osakonna_nr,
        vahendaja_new.osakonna_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nimi changed
    IF(coalesce(vahendaja_new.osakonna_nimi, ' ') != coalesce(vahendaja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.osakonna_nimi,
        vahendaja_new.osakonna_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutuse_nimi changed
    IF(coalesce(vahendaja_new.asutuse_nimi, ' ') != coalesce(vahendaja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.asutuse_nimi,
        vahendaja_new.asutuse_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(vahendaja_new.allyksus_id, 0) != coalesce(vahendaja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.allyksus_id,
        vahendaja_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vahendaja_new.allyksuse_lyhinimetus, ' ') != coalesce(vahendaja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.allyksuse_lyhinimetus,
        vahendaja_new.allyksuse_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vahendaja_new.ametikoha_lyhinimetus, ' ') != coalesce(vahendaja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.ametikoha_lyhinimetus,
        vahendaja_new.ametikoha_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_vastuvotja_mall_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_mall_new vastuvotja_mall%ROWTYPE;
	vastuvotja_mall_old vastuvotja_mall%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  VASTUVOTJA_MALL_new.VASTUVOTJA_MALL_ID := NEW.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  VASTUVOTJA_MALL_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  VASTUVOTJA_MALL_new.NIMI := NEW.NIMI;
		  VASTUVOTJA_MALL_new.EMAIL := NEW.EMAIL;
		  VASTUVOTJA_MALL_new.OSAKONNA_NR := NEW.OSAKONNA_NR;
		  VASTUVOTJA_MALL_new.OSAKONNA_NIMI := NEW.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_new.SAATMISVIIS_ID := NEW.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_new.ASUTUSE_NIMI := NEW.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_new.TINGIMUS_XPATH := NEW.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_new.ALLYKSUSE_LYHINIMETUS := NEW.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_new.AMETIKOHA_LYHINIMETUS := NEW.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  VASTUVOTJA_MALL_old.VASTUVOTJA_MALL_ID := OLD.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  VASTUVOTJA_MALL_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  VASTUVOTJA_MALL_old.NIMI := OLD.NIMI;
		  VASTUVOTJA_MALL_old.EMAIL := OLD.EMAIL;
		  VASTUVOTJA_MALL_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  VASTUVOTJA_MALL_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_old.SAATMISVIIS_ID := OLD.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_old.TINGIMUS_XPATH := OLD.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  VASTUVOTJA_MALL_old.VASTUVOTJA_MALL_ID := OLD.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  VASTUVOTJA_MALL_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  VASTUVOTJA_MALL_old.NIMI := OLD.NIMI;
		  VASTUVOTJA_MALL_old.EMAIL := OLD.EMAIL;
		  VASTUVOTJA_MALL_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  VASTUVOTJA_MALL_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_old.SAATMISVIIS_ID := OLD.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_old.TINGIMUS_XPATH := OLD.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	  end if;	

	  execute dvklog.log_vastuvotja_mall(vastuvotja_mall_new, vastuvotja_mall_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja_mall (
    vastuvotja_mall_new dvk.vastuvotja_mall,
    vastuvotja_mall_old dvk.vastuvotja_mall,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja_mall';  
    primary_key_value integer := vastuvotja_mall_old.vastuvotja_mall_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
    -- vastuvotja_mall_id changed
    IF(coalesce(vastuvotja_mall_new.vastuvotja_mall_id, 0) != coalesce(vastuvotja_mall_old.vastuvotja_mall_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_mall_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.vastuvotja_mall_id,
        vastuvotja_mall_new.vastuvotja_mall_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(vastuvotja_mall_new.asutus_id, 0) != coalesce(vastuvotja_mall_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.asutus_id,
        vastuvotja_mall_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht_id changed
    IF(coalesce(vastuvotja_mall_new.ametikoht_id, 0) != coalesce(vastuvotja_mall_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.ametikoht_id,
        vastuvotja_mall_new.ametikoht_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- isikukood changed
    IF(coalesce(vastuvotja_mall_new.isikukood, ' ') != coalesce(vastuvotja_mall_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.isikukood,
        vastuvotja_mall_new.isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimi changed
    IF(coalesce(vastuvotja_mall_new.nimi, ' ') != coalesce(vastuvotja_mall_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.nimi,
        vastuvotja_mall_new.nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- email changed
    IF(coalesce(vastuvotja_mall_new.email, ' ') != coalesce(vastuvotja_mall_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.email,
        vastuvotja_mall_new.email,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nr changed
    IF(coalesce(vastuvotja_mall_new.osakonna_nr, ' ') != coalesce(vastuvotja_mall_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.osakonna_nr,
        vastuvotja_mall_new.osakonna_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- osakonna_nimi changed
    IF(coalesce(vastuvotja_mall_new.osakonna_nimi, ' ') != coalesce(vastuvotja_mall_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.osakonna_nimi,
        vastuvotja_mall_new.osakonna_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- saatmisviis_id changed
    IF(coalesce(vastuvotja_mall_new.saatmisviis_id, 0) != coalesce(vastuvotja_mall_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.saatmisviis_id,
        vastuvotja_mall_new.saatmisviis_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutuse_nimi changed
    IF(coalesce(vastuvotja_mall_new.asutuse_nimi, ' ') != coalesce(vastuvotja_mall_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.asutuse_nimi,
        vastuvotja_mall_new.asutuse_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksus_id changed
    IF(coalesce(vastuvotja_mall_new.allyksus_id, 0) != coalesce(vastuvotja_mall_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.allyksus_id,
        vastuvotja_mall_new.allyksus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tingimus_xpath changed
    IF(coalesce(vastuvotja_mall_new.tingimus_xpath, ' ') != coalesce(vastuvotja_mall_old.tingimus_xpath, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tingimus_xpath');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.tingimus_xpath,
        vastuvotja_mall_new.tingimus_xpath,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vastuvotja_mall_new.allyksuse_lyhinimetus, ' ') != coalesce(vastuvotja_mall_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.allyksuse_lyhinimetus,
        vastuvotja_mall_new.allyksuse_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vastuvotja_mall_new.ametikoha_lyhinimetus, ' ') != coalesce(vastuvotja_mall_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.ametikoha_lyhinimetus,
        vastuvotja_mall_new.ametikoha_lyhinimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_vastuvotja_staatus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_staatus_new vastuvotja_staatus%ROWTYPE;
	vastuvotja_staatus_old vastuvotja_staatus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  VASTUVOTJA_STAATUS_new.VASTUVOTJA_STAATUS_ID := NEW.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_new.NIMETUS := NEW.NIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  VASTUVOTJA_STAATUS_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_old.NIMETUS := OLD.NIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  VASTUVOTJA_STAATUS_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_old.NIMETUS := OLD.NIMETUS;
	  end if;	

	  execute dvklog.log_vastuvotja_staatus(vastuvotja_staatus_new, vastuvotja_staatus_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja_staatus (
    vastuvotja_staatus_new dvk.vastuvotja_staatus,
    vastuvotja_staatus_old dvk.vastuvotja_staatus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja_staatus';  
    primary_key_value integer := vastuvotja_staatus_old.vastuvotja_staatus_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
    -- vastuvotja_staatus_id changed
    IF(coalesce(vastuvotja_staatus_new.vastuvotja_staatus_id, 0) != coalesce(vastuvotja_staatus_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_staatus_old.vastuvotja_staatus_id,
        vastuvotja_staatus_new.vastuvotja_staatus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimetus changed
    IF(coalesce(vastuvotja_staatus_new.nimetus, ' ') != coalesce(vastuvotja_staatus_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_staatus_old.nimetus,
        vastuvotja_staatus_new.nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
				
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_logi_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	logi_new logi%ROWTYPE;
	logi_old logi%ROWTYPE;  
BEGIN			
	   if tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  logi_old.LOG_ID := OLD.LOG_ID;
		  logi_old.TABEL := OLD.TABEL;
		  logi_old.OP := OLD.OP;
		  logi_old.UIDCOL := OLD.UIDCOL;
		  logi_old.TABEL_UID := OLD.TABEL_UID;
		  logi_old.VEERG := OLD.VEERG;
		  logi_old.CTYPE := OLD.CTYPE;
		  logi_old.VANA_VAARTUS := OLD.VANA_VAARTUS;
		  logi_old.UUS_VAARTUS := OLD.UUS_VAARTUS;
		  logi_old.MUUTMISE_AEG := OLD.MUUTMISE_AEG;
		  logi_old.AB_KASUTAJA := OLD.AB_KASUTAJA;
		  logi_old.EF_KASUTAJA := OLD.EF_KASUTAJA;
		  logi_old.KASUTAJA_KOOD := OLD.KASUTAJA_KOOD;
		  logi_old.COMM := OLD.COMM;
		  logi_old.CREATED := OLD.CREATED;
		  logi_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  logi_old.USERNAME := OLD.USERNAME;
		  logi_old.AMETIKOHT := OLD.AMETIKOHT;
		  logi_old.XTEE_ISIKUKOOD := OLD.XTEE_ISIKUKOOD;
		  logi_old.XTEE_ASUTUS := OLD.XTEE_ASUTUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  logi_old.LOG_ID := OLD.LOG_ID;
		  logi_old.TABEL := OLD.TABEL;
		  logi_old.OP := OLD.OP;
		  logi_old.UIDCOL := OLD.UIDCOL;
		  logi_old.TABEL_UID := OLD.TABEL_UID;
		  logi_old.VEERG := OLD.VEERG;
		  logi_old.CTYPE := OLD.CTYPE;
		  logi_old.VANA_VAARTUS := OLD.VANA_VAARTUS;
		  logi_old.UUS_VAARTUS := OLD.UUS_VAARTUS;
		  logi_old.MUUTMISE_AEG := OLD.MUUTMISE_AEG;
		  logi_old.AB_KASUTAJA := OLD.AB_KASUTAJA;
		  logi_old.EF_KASUTAJA := OLD.EF_KASUTAJA;
		  logi_old.KASUTAJA_KOOD := OLD.KASUTAJA_KOOD;
		  logi_old.COMM := OLD.COMM;
		  logi_old.CREATED := OLD.CREATED;
		  logi_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  logi_old.USERNAME := OLD.USERNAME;
		  logi_old.AMETIKOHT := OLD.AMETIKOHT;
		  logi_old.XTEE_ISIKUKOOD := OLD.XTEE_ISIKUKOOD;
		  logi_old.XTEE_ASUTUS := OLD.XTEE_ASUTUS;
	  end if;	

	  execute dvklog.log_logi(logi_new, logi_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_logi (
    logi_new dvk.logi,
    logi_old dvk.logi,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'logi';  
    primary_key_value integer := logi_old.log_id;
	p_id int4;	

BEGIN	
	IF current_setting('dvkxtee.xtee_isikukood') = 	null THEN
		SET dvkxtee.xtee_isikukood = '';
	END IF;
	IF current_setting('dvkxtee.xtee_asutus') = null THEN
		SET dvkxtee.xtee_asutus = '';
	END IF;

    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;

    -- log_id changed
    IF(coalesce(logi_new.log_id, 0) != coalesce(logi_old.log_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('log_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.log_id,
        logi_new.log_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tabel changed
    IF(coalesce(logi_new.tabel, ' ') != coalesce(logi_old.tabel, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.tabel,
        logi_new.tabel,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- op changed
    IF(coalesce(logi_new.op, ' ') != coalesce(logi_old.op, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('op');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.op,
        logi_new.op,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- uidcol changed
    IF(coalesce(logi_new.uidcol, ' ') != coalesce(logi_old.uidcol, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uidcol');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.uidcol,
        logi_new.uidcol,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tabel_uid changed
    IF(coalesce(logi_new.tabel_uid, 0) != coalesce(logi_old.tabel_uid, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel_uid');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.tabel_uid,
        logi_new.tabel_uid,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- veerg changed
    IF(coalesce(logi_new.veerg, ' ') != coalesce(logi_old.veerg, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('veerg');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.veerg,
        logi_new.veerg,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ctype changed
    IF(coalesce(logi_new.ctype, ' ') != coalesce(logi_old.ctype, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ctype');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ctype,
        logi_new.ctype,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- vana_vaartus changed
    IF(coalesce(logi_new.vana_vaartus, ' ') != coalesce(logi_old.vana_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vana_vaartus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.vana_vaartus,
        logi_new.vana_vaartus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- uus_vaartus changed
    IF(coalesce(logi_new.uus_vaartus, ' ') != coalesce(logi_old.uus_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uus_vaartus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.uus_vaartus,
        logi_new.uus_vaartus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- muutmise_aeg changed
    IF(coalesce(logi_new.muutmise_aeg, LOCALTIMESTAMP) != coalesce(logi_old.muutmise_aeg, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutmise_aeg');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.muutmise_aeg,
        logi_new.muutmise_aeg,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ab_kasutaja changed
    IF(coalesce(logi_new.ab_kasutaja, ' ') != coalesce(logi_old.ab_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ab_kasutaja');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ab_kasutaja,
        logi_new.ab_kasutaja,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ef_kasutaja changed
    IF(coalesce(logi_new.ef_kasutaja, ' ') != coalesce(logi_old.ef_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ef_kasutaja');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ef_kasutaja,
        logi_new.ef_kasutaja,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- kasutaja_kood changed
    IF(coalesce(logi_new.kasutaja_kood, ' ') != coalesce(logi_old.kasutaja_kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kasutaja_kood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.kasutaja_kood,
        logi_new.kasutaja_kood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- comm changed
    IF(coalesce(logi_new.comm, ' ') != coalesce(logi_old.comm, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('comm');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.comm,
        logi_new.comm,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(logi_new.created, LOCALTIMESTAMP) != coalesce(logi_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.created,
        logi_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(logi_new.last_modified, LOCALTIMESTAMP) != coalesce(logi_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.last_modified,
        logi_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(logi_new.username, ' ') != coalesce(logi_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.username,
        logi_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ametikoht changed
    IF(coalesce(logi_new.ametikoht, 0) != coalesce(logi_old.ametikoht, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ametikoht,
        logi_new.ametikoht,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- xtee_isikukood changed
    IF(coalesce(logi_new.xtee_isikukood, ' ') != coalesce(logi_old.xtee_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_isikukood');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.xtee_isikukood,
        logi_new.xtee_isikukood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- xtee_asutus changed
    IF(coalesce(logi_new.xtee_asutus, ' ') != coalesce(logi_old.xtee_asutus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_asutus');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.xtee_asutus,
        logi_new.xtee_asutus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		
		
END;$$ 
LANGUAGE PLPGSQL;    
		

		
CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_fragment (
    dokumendi_fragment_new dvk.dokumendi_fragment,
    dokumendi_fragment_old dvk.dokumendi_fragment,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_fragment';  
    primary_key_value integer := dokumendi_fragment_old.fragment_id;
	p_id int4;	

BEGIN	
    -- Current user
    SELECT USER INTO usr ;

	select kc.column_name 
	into    pkey_col
	from  
		information_schema.table_constraints tc,  
		information_schema.key_column_usage kc  
	where 
		tc.constraint_type = 'PRIMARY KEY' 
		and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
		and kc.constraint_name = tc.constraint_name limit 1;
		
		
    -- fragment_id changed
    IF(coalesce(dokumendi_fragment_new.fragment_id, 0) != coalesce(dokumendi_fragment_old.fragment_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragment_id,
        dokumendi_fragment_new.fragment_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- sissetulev changed
    IF(coalesce(dokumendi_fragment_new.sissetulev, 0) != coalesce(dokumendi_fragment_old.sissetulev, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('sissetulev');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.sissetulev,
        dokumendi_fragment_new.sissetulev,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutus_id changed
    IF(coalesce(dokumendi_fragment_new.asutus_id, 0) != coalesce(dokumendi_fragment_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.asutus_id,
        dokumendi_fragment_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- edastus_id changed
    IF(coalesce(dokumendi_fragment_new.edastus_id, ' ') != coalesce(dokumendi_fragment_old.edastus_id, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('edastus_id');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.edastus_id,
        dokumendi_fragment_new.edastus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fragment_nr changed
    IF(coalesce(dokumendi_fragment_new.fragment_nr, 0) != coalesce(dokumendi_fragment_old.fragment_nr, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_nr');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragment_nr,
        dokumendi_fragment_new.fragment_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- fragmente_kokku changed
    IF(coalesce(dokumendi_fragment_new.fragmente_kokku, 0) != coalesce(dokumendi_fragment_old.fragmente_kokku, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragmente_kokku');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragmente_kokku,
        dokumendi_fragment_new.fragmente_kokku,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- loodud changed
    IF(coalesce(dokumendi_fragment_new.loodud, LOCALTIMESTAMP) != coalesce(dokumendi_fragment_old.loodud, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('loodud');
	  p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.loodud,
        dokumendi_fragment_new.loodud,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
		

END;$$ 
LANGUAGE PLPGSQL;    
		
		
CREATE TRIGGER tr_logi
AFTER UPDATE OR DELETE ON logi FOR EACH ROW EXECUTE PROCEDURE tr_logi_log();

CREATE TRIGGER tr_vastuvotja_staatus
AFTER INSERT OR UPDATE OR DELETE ON vastuvotja_staatus FOR EACH ROW EXECUTE PROCEDURE tr_vastuvotja_staatus_log();

CREATE TRIGGER tr_vastuvotja_mall
AFTER INSERT OR UPDATE OR DELETE ON vastuvotja_mall FOR EACH ROW EXECUTE PROCEDURE tr_vastuvotja_mall_log();
		
CREATE TRIGGER tr_vahendaja
AFTER INSERT OR UPDATE OR DELETE ON vahendaja FOR EACH ROW EXECUTE PROCEDURE tr_vahendaja_log();
		
CREATE TRIGGER tr_transport
AFTER INSERT OR UPDATE OR DELETE ON transport FOR EACH ROW EXECUTE PROCEDURE tr_transport_log();

CREATE TRIGGER tr_staatuse_ajalugu
AFTER INSERT OR UPDATE OR DELETE ON staatuse_ajalugu FOR EACH ROW EXECUTE PROCEDURE tr_staatuse_ajalugu_log();

CREATE TRIGGER tr_server
AFTER INSERT OR UPDATE OR DELETE ON server FOR EACH ROW EXECUTE PROCEDURE tr_server_log();

CREATE TRIGGER tr_saatja
AFTER INSERT OR UPDATE OR DELETE ON saatja FOR EACH ROW EXECUTE PROCEDURE tr_saatja_log();
		
CREATE TRIGGER tr_parameetrid
AFTER INSERT OR UPDATE OR DELETE ON parameetrid FOR EACH ROW EXECUTE PROCEDURE tr_parameetrid_log();
		
CREATE TRIGGER tr_oigus_objektile
AFTER INSERT OR UPDATE OR DELETE ON oigus_objektile FOR EACH ROW EXECUTE PROCEDURE tr_oigus_objektile_log();

CREATE TRIGGER tr_oigus_antud
AFTER INSERT OR UPDATE OR DELETE ON oigus_antud FOR EACH ROW EXECUTE PROCEDURE tr_oigus_antud_log();
		
CREATE TRIGGER tr_konversioon
AFTER INSERT OR UPDATE OR DELETE ON konversioon FOR EACH ROW EXECUTE PROCEDURE tr_konversioon_log();

CREATE TRIGGER tr_klassifikaator
AFTER INSERT OR UPDATE OR DELETE ON klassifikaator FOR EACH ROW EXECUTE PROCEDURE tr_klassifikaator_log();

CREATE TRIGGER tr_klassifikaatori_tyyp
AFTER INSERT OR UPDATE OR DELETE ON klassifikaatori_tyyp FOR EACH ROW EXECUTE PROCEDURE tr_klassifikaatori_tyyp_log();
		
CREATE TRIGGER tr_kaust
AFTER INSERT OR UPDATE OR DELETE ON kaust FOR EACH ROW EXECUTE PROCEDURE tr_kaust_log();
		
CREATE TRIGGER tr_isik
AFTER INSERT OR UPDATE OR DELETE ON isik FOR EACH ROW EXECUTE PROCEDURE tr_isik_log();

CREATE TRIGGER tr_vastuvotja
AFTER INSERT OR UPDATE OR DELETE ON vastuvotja FOR EACH ROW EXECUTE PROCEDURE tr_vastuvotja_log();

CREATE TRIGGER tr_dokumendi_metaandmed
AFTER INSERT OR UPDATE OR DELETE ON dokumendi_metaandmed FOR EACH ROW EXECUTE PROCEDURE tr_dokumendi_metaandmed_log();
		
CREATE TRIGGER tr_dokumendi_fail
AFTER INSERT OR UPDATE OR DELETE ON dokumendi_fail FOR EACH ROW EXECUTE PROCEDURE tr_dokumendi_fail_log();
		
CREATE TRIGGER tr_ametikoht
AFTER INSERT OR UPDATE OR DELETE ON ametikoht FOR EACH ROW EXECUTE PROCEDURE tr_ametikoht_log();

CREATE TRIGGER tr_allkiri
AFTER INSERT OR UPDATE OR DELETE ON allkiri FOR EACH ROW EXECUTE PROCEDURE tr_allkiri_log();

CREATE TRIGGER tr_allyksus
AFTER INSERT OR UPDATE OR DELETE ON allyksus FOR EACH ROW EXECUTE PROCEDURE tr_allyksus_log();

CREATE TRIGGER tr_ametikoht_taitmine
AFTER INSERT OR UPDATE OR DELETE ON ametikoht_taitmine FOR EACH ROW EXECUTE PROCEDURE tr_ametikoht_taitmine_log();

CREATE TRIGGER tr_asutus
AFTER INSERT OR UPDATE OR DELETE ON asutus FOR EACH ROW EXECUTE PROCEDURE tr_asutus_log();

CREATE TRIGGER tr_dokumendi_ajalugu
AFTER INSERT OR UPDATE OR DELETE ON dokumendi_ajalugu FOR EACH ROW EXECUTE PROCEDURE tr_dokumendi_ajalugu_log();

CREATE TRIGGER tr_dokument
AFTER INSERT OR UPDATE OR DELETE ON dokument FOR EACH ROW EXECUTE PROCEDURE tr_dokument_log();

CREATE TRIGGER tr_dynaamilised_metaandmed
AFTER INSERT OR UPDATE OR DELETE ON dynaamilised_metaandmed FOR EACH ROW EXECUTE PROCEDURE tr_dynaamilised_metaandmed_log();

CREATE TRIGGER tr_ehak
AFTER INSERT OR UPDATE OR DELETE ON ehak FOR EACH ROW EXECUTE PROCEDURE tr_ehak_log();


