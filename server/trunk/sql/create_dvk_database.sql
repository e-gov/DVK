CREATE OR REPLACE 
PACKAGE globalPkg AUTHID CURRENT_USER AS
    identity number(38,0);
    log_identity number(38,0);
    TYPE RCT1 IS REF CURSOR;
END;
/

GRANT EXECUTE ON globalpkg TO public
/


CREATE TABLE allyksus
(
    id number(38,0) NOT NULL,
    asutus_id number(38,0) NOT NULL,
    vanem_id number(38,0),
    allyksus varchar2(200) NOT NULL,
    created timestamp,
    last_modified timestamp,
    username varchar2(11),
    muutm_arv number(38,0) DEFAULT 0 NOT NULL,
    aar_id number(38,0) null,
	lyhinimetus varchar2(25) null,
    adr_uri varchar2(500) null
)
/

create sequence sq_allyksus_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_allyksus_id
    before insert
    on allyksus
    for each row
begin
    select  sq_allyksus_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.id := globalPkg.identity;
end;
/

CREATE TABLE ametikoht
(
    ametikoht_id number(38,0) NOT NULL,
    ks_ametikoht_id number(38,0),
    asutus_id number(38,0) NOT NULL,
    ametikoht_nimetus varchar2(255) NOT NULL,
    alates timestamp(0),
    kuni timestamp(0),
    created timestamp(0),
    last_modified timestamp(0),
    username varchar2(11),
    allyksus_id number(38,0),
    params varchar2(1000),
    aar_id number(38,0) null,
	lyhinimetus varchar2(25) null
)
/

create sequence sq_ametikoht_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_ametikoht_id
    before insert
    on ametikoht
    for each row
begin
    select  sq_ametikoht_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.ametikoht_id := globalPkg.identity;
end;
/

CREATE TABLE ametikoht_taitmine
(
    taitmine_id number(38,0) NOT NULL,
    ametikoht_id number(38,0),
    i_id number(38,0),
    alates timestamp,
    kuni timestamp,
    roll varchar2(10) DEFAULT 'PK',
    created timestamp,
    last_modified timestamp,
    username varchar(11),
    peatatud number(1,0) default 0,
    aar_id number(38,0) null
)
/

create sequence sq_ametikoht_taitmine_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_ametikoht_taitmine_id
    before insert
    on ametikoht_taitmine
    for each row
begin
    select  sq_ametikoht_taitmine_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.taitmine_id := globalPkg.identity;
end;
/

CREATE TABLE isik
(
    i_id number(38,0) NOT NULL,
    kood varchar2(11) NOT NULL,
    perenimi varchar2(30) NOT NULL,
    eesnimi varchar2(30) NOT NULL,
    maakond varchar2(20),
    aadress varchar2(200),
    postikood varchar2(5),
    telefon varchar2(40),
    e_post varchar2(100),
    www varchar2(100),
    params varchar2(1000),
    created timestamp,
    last_modified timestamp,
    username varchar2(11)
)
/

create sequence sq_isik_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_isik_id
    before insert
    on isik
    for each row
begin
    select  sq_isik_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.i_id := globalPkg.identity;
end;
/

COMMENT ON TABLE isik IS 'Sisaldab infot koigi isikute kohta';
COMMENT ON COLUMN isik.i_id IS 'Isikute tabeli unikaalne identifikaator';
COMMENT ON COLUMN isik.kood IS 'Isikukood';
COMMENT ON COLUMN isik.perenimi IS 'Perekonnanimi';
COMMENT ON COLUMN isik.eesnimi IS 'Eesnimi';
COMMENT ON COLUMN isik.maakond IS 'Maakond (vald), EHAK alusel';
COMMENT ON COLUMN isik.aadress IS 'Aadress (tanav, maja)';
COMMENT ON COLUMN isik.postikood IS 'Postiindeks';
COMMENT ON COLUMN isik.telefon IS 'telefon';
COMMENT ON COLUMN isik.e_post IS 'e-posti aadress';
COMMENT ON COLUMN isik.www IS 'kodulehekulg';
COMMENT ON COLUMN isik.params IS 'eelistused';

CREATE TABLE oigus_antud
(
    oigus_antud_id number(38,0) NOT NULL,
    asutus_id number(38,0),
    muu_asutus_id number(38,0),
    ametikoht_id number(38,0),
    roll varchar2(100) NOT NULL,
    alates timestamp(0),
    kuni timestamp(0),
    created timestamp(0),
    last_modified timestamp(0),
    username varchar2(11),
    peatatud number(1,0) default 0,
    allyksus_id number(38,0) null
)
/

create sequence sq_oigus_antud_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_oigus_antud_id
    before insert
    on oigus_antud
    for each row
begin
    select  sq_oigus_antud_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.oigus_antud_id := globalPkg.identity;
end;
/

CREATE TABLE asutus
(
    asutus_id number(38,0) NOT NULL,
    registrikood varchar2(12) NOT NULL,
    e_registrikood varchar2(8),
    ks_asutus_id number(38,0),
    ks_asutus_kood varchar2(20),
    nimetus varchar2(1000) NOT NULL,
    lnimi varchar2(20),
    liik1 varchar2(20),
    liik2 varchar2(20),
    tegevusala varchar2(20),
    tegevuspiirkond varchar2(1000),
    maakond varchar2(20),
    asukoht varchar2(20),
    aadress varchar2(1000),
    postikood varchar2(5),
    telefon varchar2(40),
    faks varchar2(40),
    e_post varchar2(100),
    www varchar2(100),
    logo varchar2(500),
    asutamise_kp timestamp,
    mood_akt_nimi varchar2(1000),
    mood_akt_nr varchar2(100),
    mood_akt_kp timestamp,
    pm_akt_nimi varchar2(1000),
    pm_akt_nr varchar2(100),
    pm_kinnitamise_kp timestamp,
    pm_kande_kp timestamp,
    created timestamp,
    last_modified timestamp,
    username varchar2(20),
    params varchar2(2000),
    dhl_otse_saatmine number(1,0),
    dhl_saatmine number(1,0) default 1 null,
    dhs_nimetus varchar2(150) null,
    toetatav_dvk_versioon varchar2(20) null,
    server_id number(38,0) null,
    aar_id number(38,0) null
)
/

create sequence sq_asutus_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_asutus_id
    before insert
    on asutus
    for each row
begin
    select  sq_asutus_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.asutus_id := globalPkg.identity;
end;
/

COMMENT ON COLUMN asutus.asutus_id IS 'asutuste tabeli primary key';
COMMENT ON COLUMN asutus.registrikood IS 'asutuse registrikood';
COMMENT ON COLUMN asutus.e_registrikood IS 'asutuse varasem registrikood';
COMMENT ON COLUMN asutus.ks_asutus_id IS 'k�rgemalseisva asutuse asutus_id';
COMMENT ON COLUMN asutus.ks_asutus_kood IS 'selle alusel on tekitatud ks_asutus_id. Viitab k�rgemalseisva asutuse v�ljale registrikood';
COMMENT ON COLUMN asutus.nimetus IS 'asutuse nimetus (suurt�htedega)';
COMMENT ON COLUMN asutus.lnimi IS 'asutuse nime l�hend (see v�li on meie enda tekitatud ja kasutame sisemisteks vajadusteks n�it e-vormide jaoks. t�idetud 13 -l asutusel)';
COMMENT ON COLUMN asutus.maakond IS 'asutuse asukoha maakond';
COMMENT ON COLUMN asutus.asukoht IS 'asutuse juriidiline asukoht EHAK klassifikaatori alusel';
COMMENT ON COLUMN asutus.aadress IS 'EHAK klassifikaatori t�psustus (linnas t�nava nimi ja maja nr)';
COMMENT ON COLUMN asutus.postikood IS 'postiindeks';
COMMENT ON COLUMN asutus.telefon IS 'asutuse �ldtelefoni nr';
COMMENT ON COLUMN asutus.faks IS 'asutuse faksi number';
COMMENT ON COLUMN asutus.e_post IS 'asutuse �ldine e-posti aadress';
COMMENT ON COLUMN asutus.www IS 'asutuse veebilehe URL';
COMMENT ON COLUMN asutus.logo IS 'asutuse logo faili nimi RIA failis�steemis (sisemises kasutuses)';
COMMENT ON COLUMN asutus.asutamise_kp IS 'asutuse asutamise kuup�ev';
COMMENT ON COLUMN asutus.mood_akt_nimi IS 'asutuse moodustamise �igusakti nimi';
COMMENT ON COLUMN asutus.mood_akt_nr IS 'asutuse moodustamise akti nr';
COMMENT ON COLUMN asutus.mood_akt_kp IS 'asutuse moodustamise akti kuup�ev';
COMMENT ON COLUMN asutus.pm_akt_nimi IS 'p�him��ruse �igusakti nimi';
COMMENT ON COLUMN asutus.pm_akt_nr IS 'p�him��ruse akti number';
COMMENT ON COLUMN asutus.pm_kinnitamise_kp IS 'p�him��ruse akti kuup�ev';
COMMENT ON COLUMN asutus.pm_kande_kp IS 'Rahandusministeeriumi registrisse kandmise kuup�ev';
COMMENT ON COLUMN asutus.created IS 'selles baasis kirje loomise aeg';
COMMENT ON COLUMN asutus.last_modified IS 'selles baasis kirje viimase muutmise aeg';
COMMENT ON COLUMN asutus.username IS 'selles baasis kirje viimase muutja, selle puudumisel kirje looja isikukood. Isikukoodi puudumisel andmebaasi kasutajanimi';


CREATE TABLE ehak
(
    ehak_id varchar2(20) NOT NULL,
    nimi varchar2(1000) NOT NULL,
    roopnimi varchar2(1000),
    tyyp varchar2(20) NOT NULL,
    maakond varchar2(20) NOT NULL,
    vald varchar2(20),
    created timestamp,
    last_modified timestamp,
    username varchar2(11)
)
/

ALTER TABLE allyksus
ADD CONSTRAINT allyksus_pkey
PRIMARY KEY (id)
/

ALTER TABLE ametikoht
ADD CONSTRAINT ametikoht_pkey
PRIMARY KEY (ametikoht_id)
/

ALTER TABLE ametikoht_taitmine
ADD CONSTRAINT ametikoht_taitmine_pkey
PRIMARY KEY (taitmine_id)
/

ALTER TABLE asutus
ADD CONSTRAINT asutus_pkey
PRIMARY KEY (asutus_id)
/

ALTER TABLE asutus
ADD CONSTRAINT asutus_registrikood
UNIQUE (registrikood)
/

ALTER TABLE ehak
ADD CONSTRAINT ehak_pkey
PRIMARY KEY (ehak_id)
/

ALTER TABLE isik
ADD CONSTRAINT isik_kood_key
UNIQUE (kood)
/

ALTER TABLE isik
ADD CONSTRAINT isik_pkey
PRIMARY KEY (i_id)
/

ALTER TABLE oigus_antud
ADD CONSTRAINT oigus_antud_pkey
PRIMARY KEY (oigus_antud_id)
/

CREATE UNIQUE INDEX allyksus_u
ON allyksus (asutus_id, upper(allyksus))
/

CREATE INDEX ametikoht_asutus_id_idx
ON ametikoht (asutus_id)
/

CREATE INDEX ametikoht_id_idx
ON oigus_antud (ametikoht_id)
/

CREATE INDEX asutus_ks_asutus_id
ON asutus (ks_asutus_id)
/

CREATE INDEX asutuse_nimi
ON asutus (nimetus)
/

CREATE INDEX ehak_maakond_idx
ON ehak (maakond)
/

CREATE INDEX ehak_nimi_idx
ON ehak (nimi)
/

CREATE INDEX ks_ametikoht_id_idx
ON ametikoht (ks_ametikoht_id)
/

CREATE INDEX oigus_antud_asutus_id_idx
ON oigus_antud (asutus_id)
/

CREATE INDEX perenimi_idx
ON isik (perenimi)
/

CREATE INDEX roll_idx
ON oigus_antud (roll)
/

CREATE INDEX taitmine_ametikoht_id_idx
ON ametikoht_taitmine (ametikoht_id)
/

CREATE INDEX taitmine_i_id_idx
ON ametikoht_taitmine (i_id)
/

ALTER TABLE allyksus
ADD CONSTRAINT allyksus_asutus_id_fkey
FOREIGN KEY (asutus_id)
REFERENCES asutus(asutus_id) ON DELETE CASCADE
/

ALTER TABLE allyksus
ADD CONSTRAINT allyksus_vanem_id_fkey
FOREIGN KEY (vanem_id)
REFERENCES allyksus(id) ON DELETE CASCADE
/

ALTER TABLE ametikoht
ADD CONSTRAINT ametikoht_allyksus_id_fkey
FOREIGN KEY (allyksus_id)
REFERENCES allyksus(id) ON DELETE SET NULL
/

ALTER TABLE ametikoht
ADD CONSTRAINT fk_ametikoht_1
FOREIGN KEY (asutus_id)
REFERENCES asutus(asutus_id)
ON DELETE CASCADE
/

alter table ametikoht_taitmine
add constraint fk_ametikoht_taitmine_1
foreign key (i_id)
referencing isik (i_id)
on delete cascade
/

alter table ametikoht_taitmine
add constraint fk_ametikoht_taitmine_2
foreign key (ametikoht_id)
referencing ametikoht (ametikoht_id)
on delete cascade
/

alter table asutus
add constraint fk_asutus_1
foreign key (ks_asutus_id)
referencing asutus (asutus_id)
/

alter table oigus_antud
add constraint fk_oigus_antud_1
foreign key (asutus_id)
referencing asutus (asutus_id)
on delete cascade
/

alter table oigus_antud
add constraint fk_oigus_antud_2
foreign key (ametikoht_id)
referencing ametikoht (ametikoht_id)
on delete cascade
/

-- Kui andmebaas on tekitatud skriptiga "create_dvk_database.sql",
-- siis ei ole seda skripti vaja käivitada kuna sellisel juhul
-- on need kirjed juba andmebaasis olemas.

create table kaust
(
    kaust_id number(38,0) not null primary key,
    nimi varchar2(1000) null,
    ylemkaust_id number(38,0) null,
    asutus_id number(38,0) null,
    kausta_number varchar2(50) null
)
/

insert into kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) values(-1, null, null, null, null);
insert into kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) values(0, '/', null, null, null);

create sequence sq_kaust_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_kaust_id
    before insert
    on kaust
    for each row
begin
    select  sq_kaust_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.kaust_id := globalPkg.identity;
end;
/

alter table kaust
add constraint fk_kaust_1
foreign key (ylemkaust_id)
referencing kaust (kaust_id)
/

alter table kaust
add constraint fk_kaust_2
foreign key (asutus_id)
referencing asutus (asutus_id)
/

create table klassifikaatori_tyyp
(
    klassifikaatori_tyyp_id number(38,0) not null primary key,
    nimetus varchar2(1000) null
)
/

create table klassifikaator
(
    klassifikaator_id number(38,0) not null primary key,
    nimetus varchar2(1000) null,
    klassifikaatori_tyyp_id number(38,0) not null
)
/

alter table klassifikaator
add constraint fk_klassifikaator_1
foreign key (klassifikaatori_tyyp_id)
referencing klassifikaatori_tyyp (klassifikaatori_tyyp_id)
on delete cascade
/

create table dokument
(
    dokument_id number(38,0) not null primary key,
    asutus_id number(38,0) not null,
    kaust_id number(38,0) not null,
    sisu clob not null,
    sailitustahtaeg date null,
    eelmise_versiooni_id number(38,0) null,
	suurus number(20) null,
	GUID varchar2(36) null,
    versioon number(10) default 1
)
/

COMMENT ON COLUMN dokument.suurus IS 'Dokumendi suurus baitides.'
/

COMMENT ON COLUMN dokument.GUID IS 'Dokumendi Globaalselt Unikaalne Identifikaator.'
/

alter table dokument
add constraint fk_dokument_1
foreign key (asutus_id)
referencing asutus (asutus_id)
on delete cascade
/

alter table dokument
add constraint fk_dokument_2
foreign key (kaust_id)
referencing kaust (kaust_id)
on delete cascade
/

alter table dokument
add constraint fk_dokument_3
foreign key (eelmise_versiooni_id)
referencing dokument (dokument_id)
on delete set null
/

create sequence sq_dokument_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create table transport
(
    transport_id number(38,0) not null primary key,
    dokument_id number(38,0) not null,
    saatmise_algus date null,
    saatmise_lopp date null,
    staatus_id number(38,0) null
)
/

alter table transport
add constraint fk_transport_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

alter table transport
add constraint fk_transport_2
foreign key (staatus_id)
referencing klassifikaator (klassifikaator_id)
on delete cascade
/

create sequence sq_transport_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_transport_id
    before insert
    on transport
    for each row
begin
    select  sq_transport_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.transport_id := globalPkg.identity;
end;
/

create table saatja
(
    saatja_id number(38,0) not null primary key,
    transport_id number(38,0) not null,
    asutus_id number(38,0) null,
    ametikoht_id number(38,0) null,
    isikukood varchar2(20) null,
    nimi varchar2(500) null,
    email varchar2(100) null,
    osakonna_nr varchar2(100) null,
    osakonna_nimi varchar2(500) null,
    asutuse_nimi varchar2(500) null,
    allyksus_id number(38,0) null,
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

alter table saatja
add constraint fk_saatja_1
foreign key (transport_id)
referencing transport (transport_id)
on delete cascade
/

alter table saatja
add constraint fk_saatja_2
foreign key (asutus_id)
referencing asutus (asutus_id)
/

alter table saatja
add constraint fk_saatja_3
foreign key (ametikoht_id)
referencing ametikoht (ametikoht_id)
/

create sequence sq_saatja_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_saatja_id
    before insert
    on saatja
    for each row
begin
    select  sq_saatja_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.saatja_id := globalPkg.identity;
end;
/

create table vastuvotja
(
    vastuvotja_id number(38,0) not null primary key,
    transport_id number(38,0) not null,
    asutus_id number(38,0) not null,
    ametikoht_id number(38,0) null,
    isikukood varchar2(20) null,
    nimi varchar2(500) null,
    email varchar2(100) null,
    osakonna_nr varchar2(100) null,
    osakonna_nimi varchar2(500) null,
    saatmisviis_id number(38,0) not null,
    staatus_id number(38,0) not null,
    saatmise_algus date null,
    saatmise_lopp date null,
    fault_code varchar2(50) null,
    fault_actor varchar2(250) null,
    fault_string varchar2(500) null,
    fault_detail varchar2(2000) null,
    vastuvotja_staatus_id number(38,0) null,
    metaxml clob null,
    asutuse_nimi varchar2(500) null,
    allyksus_id number(38,0) null,
    dok_id_teises_serveris number(38,0) null
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

create sequence sq_vastuvotja_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

alter table vastuvotja
add constraint fk_vastuvotja_1
foreign key (transport_id)
referencing transport (transport_id)
on delete cascade
/

alter table vastuvotja
add constraint fk_vastuvotja_2
foreign key (saatmisviis_id)
referencing klassifikaator (klassifikaator_id)
/

alter table vastuvotja
add constraint fk_vastuvotja_3
foreign key (staatus_id)
referencing klassifikaator (klassifikaator_id)
/

alter table vastuvotja
add constraint fk_vastuvotja_4
foreign key (asutus_id)
referencing asutus (asutus_id)
/

alter table vastuvotja
add constraint fk_vastuvotja_5
foreign key (ametikoht_id)
referencing ametikoht (ametikoht_id)
/

CREATE
TABLE   VASTUVOTJA_STAATUS
(
        VASTUVOTJA_STAATUS_ID NUMBER(38,0) NOT NULL PRIMARY KEY,
        NIMETUS VARCHAR2(100) NOT NULL
)
/

ALTER TABLE VASTUVOTJA
ADD CONSTRAINT FK_VASTUVOTJA_6
FOREIGN KEY (VASTUVOTJA_STAATUS_ID)
REFERENCING VASTUVOTJA_STAATUS (VASTUVOTJA_STAATUS_ID)
ON DELETE SET NULL
/


/* Vastuv�tja staatuse v�imalike v��rtuste sisestamine */
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (1, 'Dokumente on puudu (Pooleli)');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (2, 'J�rjekorras');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (3, 'Ootel');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (4, 'L�petatud');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (5, 'Tagasi l�katud');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (6, 'Teha');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (7, 'T��tlemisel');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (8, 'Aktsepteeritud (V�etud t��sse)');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (9, 'Salvestatud');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (10, 'Arhiveeritud');
INSERT
INTO    VASTUVOTJA_STAATUS(VASTUVOTJA_STAATUS_ID, NIMETUS)
VALUES  (11, 'Saadetud');


insert
into    klassifikaatori_tyyp(
        klassifikaatori_tyyp_id,
        nimetus)
values  (1,
        'Saatmisviis');

insert
into    klassifikaatori_tyyp(
        klassifikaatori_tyyp_id,
        nimetus)
values  (2,
        'Dokumendi olek');
        
insert
into    klassifikaator(
        klassifikaator_id,
        nimetus,
        klassifikaatori_tyyp_id)
values  (1,
        'xtee',
        1);

insert
into    klassifikaator(
        klassifikaator_id,
        nimetus,
        klassifikaatori_tyyp_id)
values  (2,
        'epost',
        1);

insert
into    klassifikaator(
        klassifikaator_id,
        nimetus,
        klassifikaatori_tyyp_id)
values  (101,
        'saatmisel',
        2);

insert
into    klassifikaator(
        klassifikaator_id,
        nimetus,
        klassifikaatori_tyyp_id)
values  (102,
        'saadetud',
        2);

insert
into    klassifikaator(
        klassifikaator_id,
        nimetus,
        klassifikaatori_tyyp_id)
values  (103,
        'katkestatud',
        2);




create table dokumendi_metaandmed
(
    dokument_id number(38,0) primary key not null,
    koostaja_asutuse_nr varchar2(20) null,
    saaja_asutuse_nr varchar2(20) null,
    koostaja_dokumendinimi varchar2(2000) null,
    koostaja_dokumendityyp varchar2(250) null,
    koostaja_dokumendinr varchar2(50) null,
    koostaja_failinimi varchar2(250) null,
    koostaja_kataloog varchar2(1000) null,
    koostaja_votmesona varchar2(1000) null,
    koostaja_kokkuvote varchar2(2000) null,
    koostaja_kuupaev timestamp(0) null,
    koostaja_asutuse_nimi varchar2(250) null,
    koostaja_asutuse_kontakt varchar2(1000) null,
    autori_osakond varchar2(250) null,
    autori_isikukood varchar2(11) null,
    autori_nimi varchar2(100) null,
    autori_kontakt varchar2(1000) null,
    seotud_dokumendinr_koostajal varchar2(50) null,
    seotud_dokumendinr_saajal varchar2(50) null,
    saatja_dokumendinr varchar2(50) null,
    saatja_kuupaev timestamp(0) null,
    saatja_asutuse_kontakt varchar2(1000) null,
    saaja_isikukood varchar2(11) null,
    saaja_nimi varchar2(100) null,
    saaja_osakond varchar2(250) null,
    seotud_dhl_id number(38,0) null,
    kommentaar varchar2(4000) null
)
/

alter table dokumendi_metaandmed
add constraint fk_dokumendi_metaandmed_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

create table dynaamilised_metaandmed
(
    dokument_id number(38,0) not null,
    nimi varchar2(50) not null,
    vaartus varchar2(2000) null
)
/

alter table dynaamilised_metaandmed
add constraint fk_dynaamilised_metaandmed_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

alter table dynaamilised_metaandmed
add constraint pk_dynaamilised_metaandmed
primary key (dokument_id,nimi)
/

create table dokumendi_fail
(
    fail_id number(38,0) not null primary key,
    dokument_id number(38,0) not null,
    nimi varchar2(250) null,
    suurus number(38,0) null,
    mime_tyyp varchar2(50) null,
    sisu clob null,
    pohifail number(1,0) default 0 not null,
    valine_manus number(1,0) default 0 not null
)
/

create sequence sq_dokumendi_fail_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_dokumendi_fail_id
    before insert
    on dokumendi_fail
    for each row
begin
    select  sq_dokumendi_fail_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.fail_id := globalPkg.identity;
end;
/

alter table dokumendi_fail
add constraint fk_dokumendi_fail_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

create table oigus_objektile
(
    oigus_objektile_id number(38,0) not null primary key,
    asutus_id number(38,0) not null,
    ametikoht_id number(38,0) not null,
    dokument_id number(38,0) null,
    kaust_id number(38,0) null,
    kehtib_alates date null,
    kehtib_kuni date null
)
/

create sequence sq_oigus_objektile_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_oigus_objektile_id
    before insert
    on oigus_objektile
    for each row
begin
    select  sq_oigus_objektile_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.oigus_objektile_id := globalPkg.identity;
end;
/

alter table oigus_objektile
add constraint fk_oigus_objektile_1
foreign key (asutus_id)
referencing asutus (asutus_id)
on delete cascade
/

alter table oigus_objektile
add constraint fk_oigus_objektile_2
foreign key (ametikoht_id)
referencing ametikoht (ametikoht_id)
on delete cascade
/

alter table oigus_objektile
add constraint fk_oigus_objektile_3
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

alter table oigus_objektile
add constraint fk_oigus_objektile_4
foreign key (kaust_id)
referencing kaust (kaust_id)
on delete cascade
/

create table allkiri
(
    allkiri_id number(38,0) not null primary key,
    dokument_id number(38,0) not null,
    eesnimi varchar2(50) null,
    perenimi varchar2(50) null,
    isikukood varchar2(20) null,
    kuupaev date null,
    roll varchar2(1000) null,
    riik varchar2(100) null,
    maakond varchar2(100) null,
    linn varchar2(100) null,
    indeks varchar2(20) null
)
/

create sequence sq_allkiri_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_allkiri_id
    before insert
    on allkiri
    for each row
begin
    select  sq_allkiri_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.allkiri_id := globalPkg.identity;
end;
/

alter table allkiri
add constraint fk_allkiri_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

create table dokumendi_ajalugu
(
    ajalugu_id number(38,0) not null primary key,
    dokument_id number(38,0) not null,
    metainfo clob null,
    transport clob null,
    metaxml clob null)
/

create sequence sq_dokumendi_ajalugu_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_dokumendi_ajalugu_id
    before insert
    on dokumendi_ajalugu
    for each row
begin
    select  sq_dokumendi_ajalugu_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.ajalugu_id := globalPkg.identity;
end;
/

alter table dokumendi_ajalugu
add constraint fk_dokumendi_ajalugu_1
foreign key (dokument_id)
referencing dokument (dokument_id)
on delete cascade
/

create table konversioon
(
	id number(38,0) primary key not null,
	version number(10,0) not null,
	result_version number(10,0) not null,
	xslt clob not null
)
/

create sequence sq_konv_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_konv_id
    before insert
    on konversioon
    for each row
begin
    select  sq_konv_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.id := globalPkg.identity;
end;
/

create table logi
(
    log_id number(38,0) primary key not null,
    tabel varchar2(100),
    op varchar2(100),
    uidcol varchar2(50),
    tabel_uid number(38,0),
    veerg varchar2(50),
    ctype varchar2(50),
    vana_vaartus varchar2(2000),
    uus_vaartus varchar2(2000),
    muutmise_aeg timestamp(0),
    ab_kasutaja varchar2(20),
    ef_kasutaja varchar2(20),
    kasutaja_kood varchar2(11),
    comm varchar2(1000),
    created timestamp,
    last_modified timestamp,
    username varchar2(11),
    ametikoht number(38,0)
)
/

create sequence sq_logi_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_logi_id
    before insert
    on logi
    for each row
begin
    select  sq_logi_id.nextval
    into    globalPkg.log_identity
    from    dual;
    :new.log_id := globalPkg.log_identity;
end;
/

create
table   vastuvotja_mall
(
    vastuvotja_mall_id number(38,0) not null,
    asutus_id number(38,0) not null,
    ametikoht_id number(38,0),
    isikukood varchar2(20),
    nimi varchar2(500),
    email varchar2(100),
    osakonna_nr varchar2(100),
    osakonna_nimi varchar2(500),
    saatmisviis_id number(38,0) not null,
    asutuse_nimi varchar2(500), 
    allyksus_id number(38,0),
    tingimus_xpath varchar2(4000),
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null,
    primary key (vastuvotja_mall_id),
    constraint fk_vastuvotja_mall_1 foreign key (saatmisviis_id) references klassifikaator (klassifikaator_id),
    constraint fk_vastuvotja_mall_2 foreign key (asutus_id) references asutus (asutus_id),
    constraint fk_vastuvotja_mall_3 foreign key (ametikoht_id) references ametikoht (ametikoht_id),
    constraint fk_vastuvotja_mall_4 foreign key (allyksus_id) references allyksus (id)
)
/

create sequence sq_vastuvotja_mall_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_vastuvotja_mall_id
    before insert
    on vastuvotja_mall
    for each row
begin
    select  sq_vastuvotja_mall_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.vastuvotja_mall_id := globalPkg.identity;
end;
/

create
table   server
(
    server_id number(38,0) not null,
    andmekogu_nimi varchar2(100),
    aadress varchar2(1000),
    primary key (server_id)
)
/

create sequence sq_vahendaja_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create
table   vahendaja
(
    vahendaja_id NUMBER(38,0) NOT NULL,
    transport_id NUMBER(38,0) NOT NULL,
    asutus_id NUMBER(38,0),
    ametikoht_id NUMBER(38,0),
    isikukood VARCHAR2(20),
    nimi VARCHAR2(500),
    email VARCHAR2(100),
    osakonna_nr VARCHAR2(100),
    osakonna_nimi VARCHAR2(500),
    asutuse_nimi VARCHAR2(500),
    allyksus_id NUMBER(38,0),
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
    PRIMARY KEY (vahendaja_id),
    CONSTRAINT fk_vahendaja_1 FOREIGN KEY (transport_id)
        REFERENCES transport (transport_id) ON DELETE CASCADE,
    CONSTRAINT fk_vahendaja_2 FOREIGN KEY (vahendaja_id)
        REFERENCES asutus (asutus_id),
    CONSTRAINT fk_vahendaja_3 FOREIGN KEY (ametikoht_id)
        REFERENCES ametikoht (ametikoht_id)
)
/

create or replace
trigger tr_vahendaja_id
    before insert
    on vahendaja
    for each row
begin
    select  sq_vahendaja_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.vahendaja_id := globalPkg.identity;
end;
/

create
table   dokumendi_fragment
(
    fragment_id number(38,0) not null,
    sissetulev number(1,0) not null,
    asutus_id number(38,0) not null,
    edastus_id varchar2(50) not null,
    fragment_nr number(38,0) not null,
    fragmente_kokku number(38,0) not null,
    loodud date,
    sisu blob null,
    primary key (fragment_id)
)
/

create sequence sq_dokumendi_fragment_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

CREATE INDEX IX_DOKUMENDI_FRAGMENT_1 ON DOKUMENDI_FRAGMENT (ASUTUS_ID, EDASTUS_ID, SISSETULEV)
/

create
table   parameetrid
(
    aar_viimane_sync date null
)
/

insert
into    parameetrid(aar_viimane_sync)
values  (sysdate)
/

create table staatuse_ajalugu
(
    staatuse_ajalugu_id number(38,0) not null primary key,
    vastuvotja_id number(38,0) not null,
    staatus_id number(38,0) not null,
    staatuse_muutmise_aeg date null,
    fault_code varchar2(50) null,
    fault_actor varchar2(250) null,
    fault_string varchar2(500) null,
    fault_detail varchar2(2000) null,
    vastuvotja_staatus_id number(38,0) null,
    metaxml clob null
)
/

create sequence sq_staatuse_ajalugu_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create trigger tr_staatuse_ajalugu_id
    before insert
    on staatuse_ajalugu
    for each row
begin
    select  sq_staatuse_ajalugu_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.staatuse_ajalugu_id := globalPkg.identity;
end;
/

alter table staatuse_ajalugu
add constraint fk_staatuse_ajalugu_1
foreign key (vastuvotja_id)
referencing vastuvotja (vastuvotja_id)
on delete cascade
/

alter table staatuse_ajalugu
add constraint fk_staatuse_ajalugu_2
foreign key (staatus_id)
referencing klassifikaator (klassifikaator_id)
/

CREATE INDEX "STAATUSE_AJALUGU_FK1_IDX" ON "STAATUSE_AJALUGU" ("VASTUVOTJA_ID") 
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/


/* PROTSEDUURID */

create or replace
procedure Get_Parameters(aar_last_sync out date)
as
begin
    select  aar_viimane_sync
    into    Get_Parameters.aar_last_sync
    from    parameetrid
    where   rownum < 2;
end;
/

create or replace
procedure Save_Parameters(aar_last_sync in date)
as
begin
    update  parameetrid
    set     aar_viimane_sync = Save_Parameters.aar_last_sync;
end;
/

create or replace
procedure Get_ExpiredDocuments(RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  t.dokument_id,
            t.staatus_id,
            d.sailitustahtaeg
    from    dokument d
    inner join
            transport t on t.dokument_id = d.dokument_id
    where   d.sailitustahtaeg < sysdate
            or d.sailitustahtaeg is null;
end;
/

create or replace
procedure Update_DocumentExpirationDate(
    document_id in number,
    expiration_date in date)
as
begin
    update  dokument
    set     sailitustahtaeg = Update_DocumentExpirationDate.expiration_date
    where   dokument_id = Update_DocumentExpirationDate.document_id;
end;
/

create or replace
procedure Delete_Document(document_id in number)
as
begin
    delete
    from    dokument
    where   dokument_id = Delete_Document.document_id;
end;
/

create or replace
procedure Get_SenderBySendingID(
    sending_id in number,
    sender_id out number,
    organization_id out number,
    position_id out number,
    division_id out number,
    personal_id_code out varchar2,
    name out varchar2,
    organization_name out varchar2,
    email out varchar2,
    department_nr out varchar2,
    department_name out varchar2,
    position_short_name out varchar2,
    division_short_name out varchar2)
as
begin
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
    into    Get_SenderBySendingID.sender_id,
            Get_SenderBySendingID.organization_id,
            Get_SenderBySendingID.position_id,
            Get_SenderBySendingID.division_id,
            Get_SenderBySendingID.personal_id_code,
            Get_SenderBySendingID.name,
            Get_SenderBySendingID.organization_name,
            Get_SenderBySendingID.email,
            Get_SenderBySendingID.department_nr,
            Get_SenderBySendingID.department_name,
            Get_SenderBySendingID.division_short_name,
            Get_SenderBySendingID.position_short_name
    from    saatja s
    where   s.transport_id = Get_SenderBySendingID.sending_id
            and rownum < 2;
end;
/

create or replace
procedure Get_LastSendingByDocID(
    document_id in number,
    sending_id out number,
    sending_start_date out date,
    sending_end_date out date,
    send_status_id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    transport t
    where   t.dokument_id = Get_LastSendingByDocID.document_id;
    
    if cnt > 0 then    
        select  t.transport_id,
                t.saatmise_algus,
                t.saatmise_lopp,
                t.staatus_id
        into    Get_LastSendingByDocID.sending_id,
                Get_LastSendingByDocID.sending_start_date,
                Get_LastSendingByDocID.sending_end_date,
                Get_LastSendingByDocID.send_status_id
        from    transport t
        where   t.transport_id =
                (
                    select  max(t1.transport_id)
                    from    transport t1
                    where   t1.dokument_id = Get_LastSendingByDocID.document_id
                )
                and rownum < 2;
    else
        Get_LastSendingByDocID.sending_id := null;
        Get_LastSendingByDocID.sending_start_date := null;
        Get_LastSendingByDocID.sending_end_date := null;
        Get_LastSendingByDocID.send_status_id := null;
    end if;
end;
/

create or replace
procedure Get_Recipients(
    sending_id in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  v.*
    from    vastuvotja v
    where   v.transport_id = Get_Recipients.sending_id;
end;
/

create or replace
procedure Add_Sender(
    sender_id out number,
    sending_id in number,
    organization_id in number,
    position_id in number,
    division_id in number,
    personal_id_code in varchar2,
    email in varchar2,
    name in varchar2,
    organization_name in varchar2,
    department_nr in varchar2,
    department_name in varchar2,
    position_short_name in varchar2,
    division_short_name in varchar2)
as
organization_id_ number(38,0) := organization_id;
position_id_ number(38,0) := position_id;
division_id_ number(38,0) := division_id;
cnt number(38,0) := 0;
begin
    if organization_id_ = 0 then
        organization_id_ := null;
    end if;
    if position_id_ = 0 then
        position_id_ := null;
    end if;
    if division_id_ = 0 then
        division_id_ := null;
    end if;

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
    values  (0,
            Add_Sender.sending_id,
            Add_Sender.organization_id_,
            Add_Sender.position_id_,
            Add_Sender.division_id_,
            Add_Sender.personal_id_code,
            Add_Sender.name,
            Add_Sender.organization_name,
            Add_Sender.email,
            Add_Sender.department_nr,
            Add_Sender.department_name,
            Add_Sender.division_short_name,
            Add_Sender.position_short_name);
    
    Add_Sender.sender_id := globalPkg.identity;
end;
/

create or replace
procedure Add_Sending(
    sending_id out number,
    document_id in number,
    sending_start_date in date,
    sending_end_date in date,
    send_status_id in number)
as
begin
    insert
    into    transport(
            transport_id,
            dokument_id,
            saatmise_algus,
            saatmise_lopp,
            staatus_id)
    values  (0,
            Add_Sending.document_id,
            Add_Sending.sending_start_date,
            Add_Sending.sending_end_date,
            Add_Sending.send_status_id);
    
    Add_Sending.sending_id := globalPkg.identity;
end;
/

create or replace
procedure Get_DocumentsSentTo(
    organization_id in number,
    folder_id in number,
    user_id in number,
    division_id in number,
    division_short_name in varchar2,
    occupation_id in number,
    occupation_short_name in varchar2,
    result_limit in number,
    RC1 out globalPkg.RCT1)
as
division_id_ number(38, 0) := Get_DocumentsSentTo.division_id;
occupation_id_ number(38, 0) := Get_DocumentsSentTo.occupation_id;
begin
    open RC1 for
    select  *
    from    dokument d,
    (
        -- Dokumendid, mis adresseeriti p�ringu teostanud isikule (isikukoodi alusel)
        select  t1.dokument_id
        from    transport t1, vastuvotja v1, isik i1
        where   t1.transport_id = v1.transport_id
                and v1.asutus_id = Get_DocumentsSentTo.organization_id
                and i1.kood = v1.isikukood
                and i1.i_id = Get_DocumentsSentTo.user_id
                and v1.staatus_id = 101
                and nvl(Get_DocumentsSentTo.division_id_, nvl(v1.allyksus_id,0)) = nvl(v1.allyksus_id,0)
                and nvl(Get_DocumentsSentTo.division_short_name, nvl(v1.allyksuse_lyhinimetus,' ')) = nvl(v1.allyksuse_lyhinimetus,' ')
                and nvl(Get_DocumentsSentTo.occupation_id_, nvl(v1.ametikoht_id,0)) = nvl(v1.ametikoht_id,0)
                and nvl(Get_DocumentsSentTo.occupation_short_name, nvl(v1.ametikoha_lyhinimetus,' ')) = nvl(v1.ametikoha_lyhinimetus,' ')
                
        -- Dokumendid, mis adresseeriti p�ringu teostaja ametikohale (ametikoha ID v�i l�hinimetus)
        union
        select  t2.dokument_id
        from    transport t2, vastuvotja v2
        where   t2.transport_id = v2.transport_id
                and v2.asutus_id = Get_DocumentsSentTo.organization_id
                and v2.allyksus_id is null
                and v2.isikukood is null
                and v2.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i2, ametikoht_taitmine akt2, ametikoht ak2
                    where   i2.i_id = Get_DocumentsSentTo.user_id
                            and ak2.ametikoht_id = v2.ametikoht_id
                            and akt2.i_id = i2.i_id
                            and ak2.ametikoht_id = akt2.ametikoht_id
                            and nvl(akt2.peatatud, 0) = 0
                            and ak2.asutus_id = v2.asutus_id
                            and nvl(akt2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt2.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak2.kuni, add_months(sysdate, 1)) > sysdate
                )
                and nvl(Get_DocumentsSentTo.division_id_, nvl(v2.allyksus_id,0)) = nvl(v2.allyksus_id,0)
                and nvl(Get_DocumentsSentTo.division_short_name, nvl(v2.allyksuse_lyhinimetus,' ')) = nvl(v2.allyksuse_lyhinimetus,' ')
                and nvl(Get_DocumentsSentTo.occupation_id_, nvl(v2.ametikoht_id,0)) = nvl(v2.ametikoht_id,0)
                and nvl(Get_DocumentsSentTo.occupation_short_name, nvl(v2.ametikoha_lyhinimetus,' ')) = nvl(v2.ametikoha_lyhinimetus,' ')
        
        -- Dokumendid, mis adresseeriti p�ringu teostaja all�ksusele
        union
        select  t3.dokument_id
        from    transport t3, vastuvotja v3
        where   t3.transport_id = v3.transport_id
                and v3.asutus_id = Get_DocumentsSentTo.organization_id
                and v3.ametikoht_id is null
                and v3.isikukood is null
                and v3.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i3, ametikoht_taitmine akt3, ametikoht ak3
                    where   i3.i_id = Get_DocumentsSentTo.user_id
                            and ak3.allyksus_id = v3.allyksus_id
                            and akt3.i_id = i3.i_id
                            and ak3.ametikoht_id = akt3.ametikoht_id
                            and nvl(akt3.peatatud, 0) = 0
                            and ak3.asutus_id = v3.asutus_id
                            and nvl(akt3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt3.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak3.kuni, add_months(sysdate, 1)) > sysdate
                )
                and nvl(Get_DocumentsSentTo.division_id_, nvl(v3.allyksus_id,0)) = nvl(v3.allyksus_id,0)
                and nvl(Get_DocumentsSentTo.division_short_name, nvl(v3.allyksuse_lyhinimetus,' ')) = nvl(v3.allyksuse_lyhinimetus,' ')
                and nvl(Get_DocumentsSentTo.occupation_id_, nvl(v3.ametikoht_id,0)) = nvl(v3.ametikoht_id,0)
                and nvl(Get_DocumentsSentTo.occupation_short_name, nvl(v3.ametikoha_lyhinimetus,' ')) = nvl(v3.ametikoha_lyhinimetus,' ')
        
        -- Dokumendid, mis adresseeriti p�ringu teostaja ametikohale
        -- p�ringu teostaja all�ksuses (vastupidine juhtum oleks, et
        -- dokument saadeti m�nele teisele ametikohale samas all�ksuses).
        union
        select  t4.dokument_id
        from    transport t4, vastuvotja v4
        where   t4.transport_id = v4.transport_id
                and v4.asutus_id = Get_DocumentsSentTo.organization_id
                and v4.isikukood is null
                and v4.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i4, ametikoht_taitmine akt4, ametikoht ak4
                    where   i4.i_id = Get_DocumentsSentTo.user_id
                            and ak4.allyksus_id = v4.allyksus_id
                            and ak4.ametikoht_id = v4.ametikoht_id
                            and akt4.i_id = i4.i_id
                            and ak4.ametikoht_id = akt4.ametikoht_id
                            and nvl(akt4.peatatud, 0) = 0
                            and ak4.asutus_id = v4.asutus_id
                            and nvl(akt4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt4.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak4.kuni, add_months(sysdate, 1)) > sysdate
                )
                and nvl(Get_DocumentsSentTo.division_id_, nvl(v4.allyksus_id,0)) = nvl(v4.allyksus_id,0)
                and nvl(Get_DocumentsSentTo.division_short_name, nvl(v4.allyksuse_lyhinimetus,' ')) = nvl(v4.allyksuse_lyhinimetus,' ')
                and nvl(Get_DocumentsSentTo.occupation_id_, nvl(v4.ametikoht_id,0)) = nvl(v4.ametikoht_id,0)
                and nvl(Get_DocumentsSentTo.occupation_short_name, nvl(v4.ametikoha_lyhinimetus,' ')) = nvl(v4.ametikoha_lyhinimetus,' ')
        
        -- Juhul kui tegemist on asutuse administraatoriga
        union
        select  t5.dokument_id
        from    transport t5, vastuvotja v5
        where   t5.transport_id = v5.transport_id
                and v5.asutus_id = Get_DocumentsSentTo.organization_id
                and v5.staatus_id = 101
                and exists
                (
                    select  1
                    from    isik i5, ametikoht_taitmine akt5, ametikoht ak5, oigus_antud oa5
                    where   i5.i_id = Get_DocumentsSentTo.user_id
                            and akt5.i_id = i5.i_id
                            and ak5.ametikoht_id = akt5.ametikoht_id
                            and oa5.ametikoht_id = akt5.ametikoht_id
                            and nvl(akt5.peatatud, 0) = 0
                            and nvl(oa5.peatatud, 0) = 0
                            and oa5.asutus_id = v5.asutus_id
                            and ak5.asutus_id = v5.asutus_id
                            and nvl(akt5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt5.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(oa5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(oa5.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak5.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak5.kuni, add_months(sysdate, 1)) > sysdate
                            and lower(trim(oa5.roll)) = 'dhl: asutuse administraator'
                )
                and nvl(Get_DocumentsSentTo.division_id_, nvl(v5.allyksus_id,0)) = nvl(v5.allyksus_id,0)
                and nvl(Get_DocumentsSentTo.division_short_name, nvl(v5.allyksuse_lyhinimetus,' ')) = nvl(v5.allyksuse_lyhinimetus,' ')
                and nvl(Get_DocumentsSentTo.occupation_id_, nvl(v5.ametikoht_id,0)) = nvl(v5.ametikoht_id,0)
                and nvl(Get_DocumentsSentTo.occupation_short_name, nvl(v5.ametikoha_lyhinimetus,' ')) = nvl(v5.ametikoha_lyhinimetus,' ')
    ) rights_filter
    where   d.dokument_id = rights_filter.dokument_id
            and
            (
                Get_DocumentsSentTo.folder_id is null
                or d.kaust_id = Get_DocumentsSentTo.folder_id
            )
            and rownum <= Get_DocumentsSentTo.result_limit;
end;
/

create or replace
procedure Get_NextDocID(
    document_id out number)
as
begin
    select  sq_dokument_id.nextval
    into    Get_NextDocID.document_id
    from    dual;
end;
/

create or replace
procedure Update_Sending(
    sending_id in number,
    document_id in number,
    sending_start_date in date,
    sending_end_date in date,
    send_status_id in number)
as
begin
    update  transport
    set     dokument_id = Update_Sending.document_id,
            saatmise_algus = Update_Sending.sending_start_date,
            saatmise_lopp = Update_Sending.sending_end_date,
            staatus_id = Update_Sending.send_status_id
    where   transport_id = Update_Sending.sending_id;
end;
/

create or replace
procedure Get_AsutusByRegNr(
    registrikood in varchar2,
    id out number,
    registrikood_vana out varchar2,
    ks_asutuse_id out number,
    ks_asutuse_kood out varchar2,
    nimetus out varchar2,
    nime_lyhend out varchar2,
    liik1 out varchar2,
    liik2 out varchar2,
    tegevusala out varchar2,
    tegevuspiirkond out varchar2,
    maakond out varchar2,
    asukoht out varchar2,
    aadress out varchar2,
    postikood out varchar2,
    telefon out varchar2,
    faks out varchar2,
    e_post out varchar2,
    www out varchar2,
    logo out varchar2,
    asutamise_kp out timestamp,
    mood_akt_nimi out varchar2,
    mood_akt_nr out varchar2,
    mood_akt_kp out timestamp,
    pm_akt_nimi out varchar2,
    pm_akt_nr out varchar2,
    pm_kinnitamise_kp out timestamp,
    pm_kande_kp out timestamp,
    loodud out timestamp,
    muudetud out timestamp,
    muutja out varchar2,
    parameetrid out varchar2,
    dhl_saatmine out number,
    dhl_otse_saatmine out number,
    dhs_nimetus out varchar2,
    toetatav_dvk_versioon out varchar2,
    server_id out number,
    aar_id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Get_AsutusByRegNr.registrikood
            and rownum < 2;
    
    if cnt > 0 then
        select  a.asutus_id,
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
        into    Get_AsutusByRegNr.id,
                Get_AsutusByRegNr.registrikood_vana,
                Get_AsutusByRegNr.ks_asutuse_id,
                Get_AsutusByRegNr.ks_asutuse_kood,
                Get_AsutusByRegNr.nimetus,
                Get_AsutusByRegNr.nime_lyhend,
                Get_AsutusByRegNr.liik1,
                Get_AsutusByRegNr.liik2,
                Get_AsutusByRegNr.tegevusala,
                Get_AsutusByRegNr.tegevuspiirkond,
                Get_AsutusByRegNr.maakond,
                Get_AsutusByRegNr.asukoht,
                Get_AsutusByRegNr.aadress,
                Get_AsutusByRegNr.postikood,
                Get_AsutusByRegNr.telefon,
                Get_AsutusByRegNr.faks,
                Get_AsutusByRegNr.e_post,
                Get_AsutusByRegNr.www,
                Get_AsutusByRegNr.logo,
                Get_AsutusByRegNr.asutamise_kp,
                Get_AsutusByRegNr.mood_akt_nimi,
                Get_AsutusByRegNr.mood_akt_nr,
                Get_AsutusByRegNr.mood_akt_kp,
                Get_AsutusByRegNr.pm_akt_nimi,
                Get_AsutusByRegNr.pm_akt_nr,
                Get_AsutusByRegNr.pm_kinnitamise_kp,
                Get_AsutusByRegNr.pm_kande_kp,
                Get_AsutusByRegNr.loodud,
                Get_AsutusByRegNr.muudetud,
                Get_AsutusByRegNr.muutja,
                Get_AsutusByRegNr.parameetrid,
                Get_AsutusByRegNr.dhl_saatmine,
                Get_AsutusByRegNr.dhl_otse_saatmine,
                Get_AsutusByRegNr.dhs_nimetus,
                Get_AsutusByRegNr.toetatav_dvk_versioon,
                Get_AsutusByRegNr.server_id,
                Get_AsutusByRegNr.aar_id
        from    asutus a
        where   a.registrikood = Get_AsutusByRegNr.registrikood
                and rownum < 2;
    else
        Get_AsutusByRegNr.id := null;
        Get_AsutusByRegNr.registrikood_vana := null;
        Get_AsutusByRegNr.ks_asutuse_id := null;
        Get_AsutusByRegNr.ks_asutuse_kood := null;
        Get_AsutusByRegNr.nimetus := null;
        Get_AsutusByRegNr.nime_lyhend := null;
        Get_AsutusByRegNr.liik1 := null;
        Get_AsutusByRegNr.liik2 := null;
        Get_AsutusByRegNr.tegevusala := null;
        Get_AsutusByRegNr.tegevuspiirkond := null;
        Get_AsutusByRegNr.maakond := null;
        Get_AsutusByRegNr.asukoht := null;
        Get_AsutusByRegNr.aadress := null;
        Get_AsutusByRegNr.postikood := null;
        Get_AsutusByRegNr.telefon := null;
        Get_AsutusByRegNr.faks := null;
        Get_AsutusByRegNr.e_post := null;
        Get_AsutusByRegNr.www := null;
        Get_AsutusByRegNr.logo := null;
        Get_AsutusByRegNr.asutamise_kp := null;
        Get_AsutusByRegNr.mood_akt_nimi := null;
        Get_AsutusByRegNr.mood_akt_nr := null;
        Get_AsutusByRegNr.mood_akt_kp := null;
        Get_AsutusByRegNr.pm_akt_nimi := null;
        Get_AsutusByRegNr.pm_akt_nr := null;
        Get_AsutusByRegNr.pm_kinnitamise_kp := null;
        Get_AsutusByRegNr.pm_kande_kp := null;
        Get_AsutusByRegNr.loodud := null;
        Get_AsutusByRegNr.muudetud := null;
        Get_AsutusByRegNr.muutja := null;
        Get_AsutusByRegNr.parameetrid := null;
        Get_AsutusByRegNr.dhl_saatmine := null;
        Get_AsutusByRegNr.dhl_otse_saatmine := null;
        Get_AsutusByRegNr.dhs_nimetus := null;
        Get_AsutusByRegNr.toetatav_dvk_versioon := null;
        Get_AsutusByRegNr.server_id := null;
        Get_AsutusByRegNr.aar_id := null;
    end if;
end;
/

create or replace
procedure Get_AsutusByID(
    id in number,
    registrikood out varchar2,
    registrikood_vana out varchar2,
    ks_asutuse_id out number,
    ks_asutuse_kood out varchar2,
    nimetus out varchar2,
    nime_lyhend out varchar2,
    liik1 out varchar2,
    liik2 out varchar2,
    tegevusala out varchar2,
    tegevuspiirkond out varchar2,
    maakond out varchar2,
    asukoht out varchar2,
    aadress out varchar2,
    postikood out varchar2,
    telefon out varchar2,
    faks out varchar2,
    e_post out varchar2,
    www out varchar2,
    logo out varchar2,
    asutamise_kp out timestamp,
    mood_akt_nimi out varchar2,
    mood_akt_nr out varchar2,
    mood_akt_kp out timestamp,
    pm_akt_nimi out varchar2,
    pm_akt_nr out varchar2,
    pm_kinnitamise_kp out timestamp,
    pm_kande_kp out timestamp,
    loodud out timestamp,
    muudetud out timestamp,
    muutja out varchar2,
    parameetrid out varchar2,
    dhl_saatmine out number,
    dhl_otse_saatmine out number,
    dhs_nimetus out varchar2,
    toetatav_dvk_versioon out varchar2,
    server_id out number,
    aar_id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.asutus_id = Get_AsutusByID.id
            and rownum < 2;
    
    if cnt > 0 then
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
        into    Get_AsutusByID.registrikood,
                Get_AsutusByID.registrikood_vana,
                Get_AsutusByID.ks_asutuse_id,
                Get_AsutusByID.ks_asutuse_kood,
                Get_AsutusByID.nimetus,
                Get_AsutusByID.nime_lyhend,
                Get_AsutusByID.liik1,
                Get_AsutusByID.liik2,
                Get_AsutusByID.tegevusala,
                Get_AsutusByID.tegevuspiirkond,
                Get_AsutusByID.maakond,
                Get_AsutusByID.asukoht,
                Get_AsutusByID.aadress,
                Get_AsutusByID.postikood,
                Get_AsutusByID.telefon,
                Get_AsutusByID.faks,
                Get_AsutusByID.e_post,
                Get_AsutusByID.www,
                Get_AsutusByID.logo,
                Get_AsutusByID.asutamise_kp,
                Get_AsutusByID.mood_akt_nimi,
                Get_AsutusByID.mood_akt_nr,
                Get_AsutusByID.mood_akt_kp,
                Get_AsutusByID.pm_akt_nimi,
                Get_AsutusByID.pm_akt_nr,
                Get_AsutusByID.pm_kinnitamise_kp,
                Get_AsutusByID.pm_kande_kp,
                Get_AsutusByID.loodud,
                Get_AsutusByID.muudetud,
                Get_AsutusByID.muutja,
                Get_AsutusByID.parameetrid,
                Get_AsutusByID.dhl_saatmine,
                Get_AsutusByID.dhl_otse_saatmine,
                Get_AsutusByID.dhs_nimetus,
                Get_AsutusByID.toetatav_dvk_versioon,
                Get_AsutusByID.server_id,
                Get_AsutusByID.aar_id
        from    asutus a
        where   a.asutus_id = Get_AsutusByID.id
                and rownum < 2;
    else
        Get_AsutusByID.registrikood := null;
        Get_AsutusByID.registrikood_vana := null;
        Get_AsutusByID.ks_asutuse_id := null;
        Get_AsutusByID.ks_asutuse_kood := null;
        Get_AsutusByID.nimetus := null;
        Get_AsutusByID.nime_lyhend := null;
        Get_AsutusByID.liik1 := null;
        Get_AsutusByID.liik2 := null;
        Get_AsutusByID.tegevusala := null;
        Get_AsutusByID.tegevuspiirkond := null;
        Get_AsutusByID.maakond := null;
        Get_AsutusByID.asukoht := null;
        Get_AsutusByID.aadress := null;
        Get_AsutusByID.postikood := null;
        Get_AsutusByID.telefon := null;
        Get_AsutusByID.faks := null;
        Get_AsutusByID.e_post := null;
        Get_AsutusByID.www := null;
        Get_AsutusByID.logo := null;
        Get_AsutusByID.asutamise_kp := null;
        Get_AsutusByID.mood_akt_nimi := null;
        Get_AsutusByID.mood_akt_nr := null;
        Get_AsutusByID.mood_akt_kp := null;
        Get_AsutusByID.pm_akt_nimi := null;
        Get_AsutusByID.pm_akt_nr := null;
        Get_AsutusByID.pm_kinnitamise_kp := null;
        Get_AsutusByID.pm_kande_kp := null;
        Get_AsutusByID.loodud := null;
        Get_AsutusByID.muudetud := null;
        Get_AsutusByID.muutja := null;
        Get_AsutusByID.parameetrid := null;
        Get_AsutusByID.dhl_saatmine := null;
        Get_AsutusByID.dhl_otse_saatmine := null;
        Get_AsutusByID.dhs_nimetus := null;
        Get_AsutusByID.toetatav_dvk_versioon := null;
        Get_AsutusByID.server_id := null;
        Get_AsutusByID.aar_id := null;
    end if;
end;
/

create or replace
procedure Get_AsutusIDByRegNr(
    registrikood in varchar2,
    dvk_voimeline in number,
    id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Get_AsutusIDByRegNr.registrikood
            and (Get_AsutusIDByRegNr.dvk_voimeline < 1 or a.dhl_saatmine = 1);
    
    if cnt > 0 then
        select  a.asutus_id
        into    Get_AsutusIDByRegNr.id
        from    asutus a
        where   a.registrikood = Get_AsutusIDByRegNr.registrikood
                and (Get_AsutusIDByRegNr.dvk_voimeline < 1 or a.dhl_saatmine = 1)
                and rownum < 2;
    else
        Get_AsutusIDByRegNr.id := 0;
    end if;
end;
/

create or replace
procedure Get_FolderIdByName(
    folder_name in varchar2,
    organization_id in number,
    parent_id in number,
    folder_id out number)
as
cnt number(38,20);
begin
    select  count(*)
    into    cnt
    from    kaust k
    where   upper(k.nimi) = upper(Get_FolderIdByName.folder_name)
            and
            (
                k.asutus_id = Get_FolderIdByName.organization_id
                or k.asutus_id is null
            )
            and k.ylemkaust_id = Get_FolderIdByName.parent_id
            and rownum < 2;
    
    if cnt > 0 then
        select  k.kaust_id
        into    Get_FolderIdByName.folder_id
        from    kaust k
        where   upper(k.nimi) = upper(Get_FolderIdByName.folder_name)
                and
                (
                    k.asutus_id = Get_FolderIdByName.organization_id
                    or k.asutus_id is null
                )
                and k.ylemkaust_id = Get_FolderIdByName.parent_id
                and rownum < 2;
    else
        Get_FolderIdByName.folder_id := null;
    end if;
end;
/

create or replace
procedure Get_IsikIDByCode(
    isikukood in varchar2,
    id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    isik i
    where   i.kood = Get_IsikIDByCode.isikukood;
    
    if cnt > 0 then
        select  i.i_id
        into    Get_IsikIDByCode.id
        from    isik i
        where   i.kood = Get_IsikIDByCode.isikukood
                and rownum < 2;
    else
        Get_IsikIDByCode.id := 0;
    end if;
end;
/

create or replace
procedure Get_PersonCurrentPositionIDs(
    person_id in number,
    organization_id in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  a.ametikoht_id
    from    ametikoht a, ametikoht_taitmine b
    where   a.asutus_id = Get_PersonCurrentPositionIDs.organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = Get_PersonCurrentPositionIDs.person_id
            and
            (
                b.peatatud is null
                or b.peatatud = 0
            )
            and
            (
                b.alates is null
                or b.alates <= sysdate
            )
            and
            (
                b.kuni is null
                or b.kuni >= sysdate
            )
            and
            (
                a.alates is null
                or a.alates <= sysdate
            )
            and
            (
                a.kuni is null
                or a.kuni >= sysdate
            );
end;
/

create or replace
procedure Get_PersonCurrentRoles(
    person_id in number,
    organization_id in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  distinct a.roll
    from    oigus_antud a, ametikoht_taitmine b
    where   a.asutus_id = Get_PersonCurrentRoles.organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = Get_PersonCurrentRoles.person_id
            and
            (
                b.peatatud is null
                or b.peatatud = 0
            )
            and
            (
                b.alates is null
                or b.alates <= sysdate
            )
            and
            (
                b.kuni is null
                or b.kuni >= sysdate
            )
            and
            (
                a.alates is null
                or a.alates <= sysdate
            )
            and
            (
                a.kuni is null
                or a.kuni >= sysdate
            )
            and
            (
                a.peatatud is null
                or a.peatatud = 0
            );
end;
/

CREATE OR REPLACE
PROCEDURE create_log_triggers
as
    sql_string long;
    pkey_col varchar2(50);
begin
for tbl in
(
    select table_name from user_tables where table_name <> 'LOGI'
)
loop
    dbms_output.put_line(tbl.table_name);
    
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and cc.table_name = tbl.table_name
            and rownum < 2;
    
    sql_string := 'create or replace trigger TR_' || tbl.table_name || '_LOG
    after insert or update or delete
    on ' || tbl.table_name || '
    referencing old as old new as new
    for each row
    declare
        operation varchar2(100);
        usr varchar2(20);
    begin
        if inserting then
            operation := ''INSERT'';
        else
            if updating then
                operation := ''UPDATE'';
            else
                operation := ''DELETE'';
            end if;
        end if;
        
        select  user
        into    usr
        from    dual;
        ';
    
    for clmn in
    (
        select column_name, data_type, data_length from user_tab_columns where table_name = tbl.table_name
    )
    loop
        if (clmn.data_type <> 'CLOB') and (clmn.data_type <> 'BLOB') then
        sql_string := sql_string || '
        insert
        into    logi(log_id,tabel,op,uidcol,tabel_uid,veerg,ctype,vana_vaartus,uus_vaartus,muutmise_aeg,ab_kasutaja,ef_kasutaja,kasutaja_kood,comm,created,last_modified,username,ametikoht)
        values  (0,''' || tbl.table_name || ''',operation,''' || pkey_col || ''',:old.' || pkey_col || ',''' || clmn.column_name || ''',''' || clmn.data_type || ''',:old.' || clmn.column_name || ',:new.' || clmn.column_name || ',sysdate,usr,'''','''','''',sysdate,sysdate,'''',0);
        ';
        end if;
    end loop;
    
    sql_string := sql_string || 'end;';

    execute immediate sql_string;
end loop;
end;
/

CREATE OR REPLACE
PROCEDURE GET_FOLDERFULLPATH(
    folder_id in number,
    folder_path out varchar2)
as
cnt number(1,0) := 0;
folder_name varchar2(4000);
marker number(38,0) := folder_id;
separator varchar2(1) := '';
begin
    select  count(*)
    into    cnt
    from    kaust a
    where   a.kaust_id = GET_FOLDERFULLPATH.marker;
    
    if cnt > 0 then
        while GET_FOLDERFULLPATH.marker is not null
        loop
            select  a.nimi,
                    a.ylemkaust_id
            into    GET_FOLDERFULLPATH.folder_name,
                    GET_FOLDERFULLPATH.marker
            from    kaust a
            where   a.kaust_id = GET_FOLDERFULLPATH.marker;
            
            GET_FOLDERFULLPATH.folder_path := GET_FOLDERFULLPATH.folder_name || separator || GET_FOLDERFULLPATH.folder_path;
            if GET_FOLDERFULLPATH.marker > 0 then
                separator := '/';
            else
                separator := '';
            end if;
        end loop;
    else
        GET_FOLDERFULLPATH.folder_path := '';
    end if;
end;
/

CREATE OR REPLACE
PROCEDURE ADD_FOLDER(
    folder_name in varchar2,
    parent_id in number,
    org_id in number,
    folder_number in varchar2,
    folder_id out number)
as
begin
    insert
    into    kaust(
            nimi,
            ylemkaust_id,
            asutus_id,
            kausta_number)
    values  (folder_name,
            parent_id,
            org_id,
            folder_number);
    
    ADD_FOLDER.folder_id := globalPkg.identity;
end;
/

create or replace
procedure Get_AsutusList (
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    asutus
    where   dhl_saatmine = 1
            and server_id is null;
end;
/

create or replace
procedure Add_Asutus(
    id out number,
    registrikood in varchar2,
    registrikood_vana in varchar2,
    ks_asutuse_id in number,
    ks_asutuse_kood in varchar2,
    nimetus in varchar2,
    nime_lyhend in varchar2,
    liik1 in varchar2,
    liik2 in varchar2,
    tegevusala in varchar2,
    tegevuspiirkond in varchar2,
    maakond in varchar2,
    asukoht in varchar2,
    aadress in varchar2,
    postikood in varchar2,
    telefon in varchar2,
    faks in varchar2,
    e_post in varchar2,
    www in varchar2,
    logo in varchar2,
    asutamise_kp in timestamp,
    mood_akt_nimi in varchar2,
    mood_akt_nr in varchar2,
    mood_akt_kp in timestamp,
    pm_akt_nimi in varchar2,
    pm_akt_nr in varchar2,
    pm_kinnitamise_kp in timestamp,
    pm_kande_kp in timestamp,
    loodud in timestamp,
    muudetud in timestamp,
    muutja in varchar2,
    parameetrid in varchar2,
    dhl_saatmine in number,
    dhl_otse_saatmine in number,
    dhs_nimetus in varchar2,
    toetatav_dvk_versioon in varchar2,
    server_id in number,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Add_Asutus.registrikood
            and rownum < 2;
    
    if cnt < 1 then
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
        values  (0,
                Add_Asutus.registrikood,
                Add_Asutus.registrikood_vana,
                Add_Asutus.ks_asutuse_id,
                Add_Asutus.ks_asutuse_kood,
                Add_Asutus.nimetus,
                Add_Asutus.nime_lyhend,
                Add_Asutus.liik1,
                Add_Asutus.liik2,
                Add_Asutus.tegevusala,
                Add_Asutus.tegevuspiirkond,
                Add_Asutus.maakond,
                Add_Asutus.asukoht,
                Add_Asutus.aadress,
                Add_Asutus.postikood,
                Add_Asutus.telefon,
                Add_Asutus.faks,
                Add_Asutus.e_post,
                Add_Asutus.www,
                Add_Asutus.logo,
                Add_Asutus.asutamise_kp,
                Add_Asutus.mood_akt_nimi,
                Add_Asutus.mood_akt_nr,
                Add_Asutus.mood_akt_kp,
                Add_Asutus.pm_akt_nimi,
                Add_Asutus.pm_akt_nr,
                Add_Asutus.pm_kinnitamise_kp,
                Add_Asutus.pm_kande_kp,
                Add_Asutus.loodud,
                Add_Asutus.muudetud,
                Add_Asutus.muutja,
                Add_Asutus.parameetrid,
                Add_Asutus.dhl_saatmine,
                Add_Asutus.dhl_otse_saatmine,
                Add_Asutus.dhs_nimetus,
                Add_Asutus.toetatav_dvk_versioon,
                Add_Asutus.server_id,
                Add_Asutus.aar_id);
        
        Add_Asutus.id := globalPkg.identity;
    else
        select  a.asutus_id
        into    Add_Asutus.id
        from    asutus a
        where   a.registrikood = Add_Asutus.registrikood
                and rownum < 2;
    end if;
end;
/

create or replace
procedure Update_Asutus(
    id in number,
    registrikood in varchar2,
    registrikood_vana in varchar2,
    ks_asutuse_id in number,
    ks_asutuse_kood in varchar2,
    nimetus in varchar2,
    nime_lyhend in varchar2,
    liik1 in varchar2,
    liik2 in varchar2,
    tegevusala in varchar2,
    tegevuspiirkond in varchar2,
    maakond in varchar2,
    asukoht in varchar2,
    aadress in varchar2,
    postikood in varchar2,
    telefon in varchar2,
    faks in varchar2,
    e_post in varchar2,
    www in varchar2,
    logo in varchar2,
    asutamise_kp in timestamp,
    mood_akt_nimi in varchar2,
    mood_akt_nr in varchar2,
    mood_akt_kp in timestamp,
    pm_akt_nimi in varchar2,
    pm_akt_nr in varchar2,
    pm_kinnitamise_kp in timestamp,
    pm_kande_kp in timestamp,
    loodud in timestamp,
    muudetud in timestamp,
    muutja in varchar2,
    parameetrid in varchar2,
    dhl_saatmine in number,
    dhl_otse_saatmine in number,
    dhs_nimetus in varchar2,
    toetatav_dvk_versioon in varchar2,
    server_id in number,
    aar_id in number)
as
begin
    update  asutus
    set     registrikood = Update_Asutus.registrikood,
            e_registrikood = Update_Asutus.registrikood_vana,
            ks_asutus_id = Update_Asutus.ks_asutuse_id,
            ks_asutus_kood = Update_Asutus.ks_asutuse_kood,
            nimetus = Update_Asutus.nimetus,
            lnimi = Update_Asutus.nime_lyhend,
            liik1 = Update_Asutus.liik1,
            liik2 = Update_Asutus.liik2,
            tegevusala = Update_Asutus.tegevusala,
            tegevuspiirkond = Update_Asutus.tegevuspiirkond,
            maakond = Update_Asutus.maakond,
            asukoht = Update_Asutus.asukoht,
            aadress = Update_Asutus.aadress,
            postikood = Update_Asutus.postikood,
            telefon = Update_Asutus.telefon,
            faks = Update_Asutus.faks,
            e_post = Update_Asutus.e_post,
            www = Update_Asutus.www,
            logo = Update_Asutus.logo,
            asutamise_kp = Update_Asutus.asutamise_kp,
            mood_akt_nimi = Update_Asutus.mood_akt_nimi,
            mood_akt_nr = Update_Asutus.mood_akt_nr,
            mood_akt_kp = Update_Asutus.mood_akt_kp,
            pm_akt_nimi = Update_Asutus.pm_akt_nimi,
            pm_akt_nr = Update_Asutus.pm_akt_nr,
            pm_kinnitamise_kp = Update_Asutus.pm_kinnitamise_kp,
            pm_kande_kp = Update_Asutus.pm_kande_kp,
            created = Update_Asutus.loodud,
            last_modified = Update_Asutus.muudetud,
            username = Update_Asutus.muutja,
            params = Update_Asutus.parameetrid,
            dhl_saatmine = Update_Asutus.dhl_saatmine,
            dhl_otse_saatmine = Update_Asutus.dhl_otse_saatmine,
            dhs_nimetus = Update_Asutus.dhs_nimetus,
            toetatav_dvk_versioon = Update_Asutus.toetatav_dvk_versioon,
            server_id = Update_Asutus.server_id,
            aar_id = Update_Asutus.aar_id
    where   asutus_id = Update_Asutus.id;
end;
/

create or replace
procedure Get_PersonCurrentDivisionIDs(
    person_id in number,
    organization_id in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  distinct
            a.allyksus_id
    from    ametikoht a, ametikoht_taitmine b
    where   a.asutus_id = Get_PersonCurrentDivisionIDs.organization_id
            and a.ametikoht_id = b.ametikoht_id
            and b.i_id = Get_PersonCurrentDivisionIDs.person_id
            and
            (
                b.peatatud is null
                or b.peatatud = 0
            )
            and
            (
                b.alates is null
                or b.alates <= sysdate
            )
            and
            (
                b.kuni is null
                or b.kuni >= sysdate
            )
            and
            (
                a.alates is null
                or a.alates <= sysdate
            )
            and
            (
                a.kuni is null
                or a.kuni >= sysdate
            );
end;
/

create or replace
procedure Get_AsutusStat(
    asutus_id in number,
    vastuvotmata_dokumente out number,
    vahetatud_dokumente out number)
as
begin
    select  count(*)
    into    Get_AsutusStat.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = Get_AsutusStat.asutus_id
            and staatus_id = 101;
    
    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = Get_AsutusStat.asutus_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = Get_AsutusStat.asutus_id
            )
    into    Get_AsutusStat.vahetatud_dokumente
    from    dual;
end;
/

create or replace
procedure Get_RecipientTemplates(RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  v.*
    from    vastuvotja_mall v
    order by
            v.vastuvotja_mall_id;
end;
/

create or replace
procedure Get_ServerByID(
    server_id in number,
    andmekogu_nimi out varchar2,
    aadress out varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    server s
    where   s.server_id = Get_ServerByID.server_id
            and rownum < 2;
    
    if cnt > 0 then
        select  s.andmekogu_nimi,
                s.aadress
        into    Get_ServerByID.andmekogu_nimi,
                Get_ServerByID.aadress
        from    server s
        where   s.server_id = Get_ServerByID.server_id
                and rownum < 2;
    else
        Get_ServerByID.andmekogu_nimi := null;
        Get_ServerByID.aadress := null;
    end if;
end;
/

create or replace
procedure Add_Proxy(
    proxy_id out number,
    sending_id in number,
    organization_id in number,
    position_id in number,
    division_id in number,
    personal_id_code in varchar2,
    email in varchar2,
    name in varchar2,
    organization_name in varchar2,
    department_nr in varchar2,
    department_name in varchar2,
    position_short_name in varchar2,
    division_short_name in varchar2)
as
organization_id_ number(38,0) := organization_id;
position_id_ number(38,0) := position_id;
division_id_ number(38,0) := division_id;
begin
    if organization_id_ = 0 then
        organization_id_ := null;
    end if;
    if position_id_ = 0 then
        position_id_ := null;
    end if;
    if division_id_ = 0 then
        division_id_ := null;
    end if;

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
    values  (0,
            Add_Proxy.sending_id,
            Add_Proxy.organization_id_,
            Add_Proxy.position_id_,
            Add_Proxy.division_id_,
            Add_Proxy.personal_id_code,
            Add_Proxy.name,
            Add_Proxy.organization_name,
            Add_Proxy.email,
            Add_Proxy.department_nr,
            Add_Proxy.department_name,
            Add_Proxy.position_short_name,
            Add_Proxy.division_short_name);
    
    Add_Proxy.proxy_id := globalPkg.identity;
end;
/

create or replace
procedure Get_ProxyBySendingID(
    sending_id in number,
    proxy_id out number,
    organization_id out number,
    position_id out number,
    division_id out number,
    personal_id_code out varchar2,
    name out varchar2,
    organization_name out varchar2,
    email out varchar2,
    department_nr out varchar2,
    department_name out varchar2,
    position_short_name out varchar2,
    division_short_name out varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    vahendaja v
    where   v.transport_id = Get_ProxyBySendingID.sending_id
            and rownum < 2;
    
    if cnt > 0 then
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
        into    Get_ProxyBySendingID.proxy_id,
                Get_ProxyBySendingID.organization_id,
                Get_ProxyBySendingID.position_id,
                Get_ProxyBySendingID.division_id,
                Get_ProxyBySendingID.personal_id_code,
                Get_ProxyBySendingID.name,
                Get_ProxyBySendingID.organization_name,
                Get_ProxyBySendingID.email,
                Get_ProxyBySendingID.department_nr,
                Get_ProxyBySendingID.department_name,
                Get_ProxyBySendingID.position_short_name,
                Get_ProxyBySendingID.division_short_name
        from    vahendaja v
        where   v.transport_id = Get_ProxyBySendingID.sending_id
                and rownum < 2;
    else
        Get_ProxyBySendingID.proxy_id := null;
        Get_ProxyBySendingID.organization_id := null;
        Get_ProxyBySendingID.position_id := null;
        Get_ProxyBySendingID.division_id := null;
        Get_ProxyBySendingID.personal_id_code := null;
        Get_ProxyBySendingID.name := null;
        Get_ProxyBySendingID.organization_name := null;
        Get_ProxyBySendingID.email := null;
        Get_ProxyBySendingID.department_nr := null;
        Get_ProxyBySendingID.department_name := null;
        Get_ProxyBySendingID.position_short_name := null;
        Get_ProxyBySendingID.division_short_name := null;
    end if;
end;
/

create or replace
procedure Get_Servers(RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  s.*
    from    server s;
end;
/

create or replace
procedure Get_NextFragmentID(fragment_id out number)
as
begin
    select  sq_dokumendi_fragment_id.nextval
    into    Get_NextFragmentID.fragment_id
    from    dual;
end;
/

create or replace
procedure Get_DocumentFragments(
    organization_id in number,
    delivery_session_id in varchar2,
    is_incoming in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  f.*
    from    dokumendi_fragment f
    where   f.asutus_id = Get_DocumentFragments.organization_id
            and f.edastus_id = Get_DocumentFragments.delivery_session_id
            and f.sissetulev = Get_DocumentFragments.is_incoming
    order by
            f.fragment_nr;
end;
/

create or replace
procedure Delete_DocumentFragments(
    organization_id in number,
    delivery_session_id in varchar2,
    is_incoming in number)
as
begin
    delete
    from    dokumendi_fragment f
    where   f.asutus_id = Delete_DocumentFragments.organization_id
            and f.edastus_id = Delete_DocumentFragments.delivery_session_id
            and f.sissetulev = Delete_DocumentFragments.is_incoming;
end;
/

create or replace
procedure Get_AsutusIDByAarID(
    aar_id in number,
    id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.aar_id = Get_AsutusIDByAarID.aar_id;
    
    if cnt > 0 then
        select  a.asutus_id
        into    Get_AsutusIDByAarID.id
        from    asutus a
        where   a.aar_id = Get_AsutusIDByAarID.aar_id
                and rownum < 2;
    else
        Get_AsutusIDByAarID.id := 0;
    end if;
end;
/

create or replace
procedure Get_AllyksusByAarID(
    id out number,
    asutus_id out number,
    vanem_id out number,
    nimetus out varchar2,
    created out date,
    last_modified out date,
    username out varchar2,
    muutmiste_arv out number,
    lyhinimetus out varchar2,
    adr_uri out varchar2,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    allyksus a
    where   a.aar_id = Get_AllyksusByAarID.aar_id
            and rownum < 2;
    
    if cnt > 0 then
        select  a.id,
                a.asutus_id,
                a.vanem_id,
                a.allyksus,
                a.created,
                a.last_modified,
                a.username,
                a.muutm_arv,
                a.lyhinimetus,
                a.adr_uri
        into    Get_AllyksusByAarID.id,
                Get_AllyksusByAarID.asutus_id,
                Get_AllyksusByAarID.vanem_id,
                Get_AllyksusByAarID.nimetus,
                Get_AllyksusByAarID.created,
                Get_AllyksusByAarID.last_modified,
                Get_AllyksusByAarID.username,
                Get_AllyksusByAarID.muutmiste_arv,
                Get_AllyksusByAarID.lyhinimetus,
                Get_AllyksusByAarID.adr_uri
        from    allyksus a
        where   a.aar_id = Get_AllyksusByAarID.aar_id
                and rownum < 2;
    else
        Get_AllyksusByAarID.id := null;
        Get_AllyksusByAarID.asutus_id := null;
        Get_AllyksusByAarID.vanem_id := null;
        Get_AllyksusByAarID.nimetus := null;
        Get_AllyksusByAarID.created := null;
        Get_AllyksusByAarID.last_modified := null;
        Get_AllyksusByAarID.username := null;
        Get_AllyksusByAarID.muutmiste_arv := null;
        Get_AllyksusByAarID.lyhinimetus := null;
        Get_AllyksusByAarID.adr_uri := null;
    end if;
end;
/

create or replace
procedure Get_AllyksusIdByAarID(
    id out number,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    allyksus a
    where   a.aar_id = Get_AllyksusIdByAarID.aar_id
            and rownum < 2;
    
    if cnt > 0 then
        select  a.id
        into    Get_AllyksusIdByAarID.id
        from    allyksus a
        where   a.aar_id = Get_AllyksusIdByAarID.aar_id
                and rownum < 2;
    else
        Get_AllyksusIdByAarID.id := null;
    end if;
end;
/

create or replace
procedure Get_AllyksusList(
    asutus_id in number,
    nimetus in varchar2,
    RC1 out globalPkg.RCT1)
as
begin
    -- Allolev keeruline union all konstruktsioon on kasulik
    -- OR operaatori v�ltimiseks (Oracle puhul v�ga aeglane)
    open RC1 for
    select  a.*,
            null as ks_allyksuse_lyhinimetus
    from    allyksus a
    where   a.asutus_id = nvl(Get_AllyksusList.asutus_id, a.asutus_id)
            and a.allyksus = Get_AllyksusList.nimetus
            and a.vanem_id is null
    union all
    select  a1.*,
            null as ks_allyksuse_lyhinimetus
    from    allyksus a1
    where   a1.asutus_id = nvl(Get_AllyksusList.asutus_id, a1.asutus_id)
            and Get_AllyksusList.nimetus is null
            and a1.vanem_id is null
    union all
    select  a2.*,
            ksa2.lyhinimetus as ks_allyksuse_lyhinimetus
    from    allyksus a2, allyksus ksa2
    where   a2.asutus_id = nvl(Get_AllyksusList.asutus_id, a2.asutus_id)
            and a2.allyksus = Get_AllyksusList.nimetus
            and a2.vanem_id = ksa2.id
    union all
    select  a3.*,
            ksa3.lyhinimetus as ks_allyksuse_lyhinimetus
    from    allyksus a3, allyksus ksa3
    where   a3.asutus_id = nvl(Get_AllyksusList.asutus_id, a3.asutus_id)
            and Get_AllyksusList.nimetus is null
            and a3.vanem_id = ksa3.id;
end;
/

create or replace
procedure Add_Allyksus(
    id out number,
    asutus_id in number,
    vanem_id in number,
    nimetus in varchar2,
    created in date,
    last_modified in date,
    username in varchar2,
    muutmiste_arv in number,
    aar_id in number,
    lyhinimetus in varchar2,
    adr_uri in varchar2)
as
asutus_id_ number(38,0) := asutus_id;
vanem_id_ number(38,0) := vanem_id;
aar_id_ number(38,0) := aar_id;
begin
    if asutus_id_ = 0 then
        asutus_id_ := null;
    end if;
    if vanem_id_ = 0 then
        vanem_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    insert
    into    allyksus(
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
    values  (0,
            Add_Allyksus.asutus_id_,
            Add_Allyksus.vanem_id_,
            Add_Allyksus.nimetus,
            Add_Allyksus.created,
            Add_Allyksus.last_modified,
            Add_Allyksus.username,
            Add_Allyksus.muutmiste_arv,
            Add_Allyksus.aar_id_,
            Add_Allyksus.lyhinimetus,
            Add_Allyksus.adr_uri);
    
    Add_Allyksus.id := globalPkg.identity;
end;
/

create or replace
procedure Update_Allyksus(
    id in number,
    asutus_id in number,
    vanem_id in number,
    nimetus in varchar2,
    created in date,
    last_modified in date,
    username in varchar2,
    muutmiste_arv in number,
    aar_id in number,
    lyhinimetus in varchar2,
    adr_uri in varchar2)
as
asutus_id_ number(38,0) := asutus_id;
vanem_id_ number(38,0) := vanem_id;
aar_id_ number(38,0) := aar_id;
begin
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
    set     asutus_id = Update_Allyksus.asutus_id_,
            vanem_id = Update_Allyksus.vanem_id,
            allyksus = Update_Allyksus.nimetus,
            created = Update_Allyksus.created,
            last_modified = Update_Allyksus.last_modified,
            username = Update_Allyksus.username,
            muutm_arv = Update_Allyksus.muutmiste_arv,
            aar_id = Update_Allyksus.aar_id_,
            lyhinimetus = Update_Allyksus.lyhinimetus,
            adr_uri = Update_Allyksus.adr_uri
    where   id = Update_Allyksus.id;
end;
/

create or replace
procedure Get_AmetikohaTaitmineByAarID(
    id out number,
    ametikoht_id out number,
    isik_id out number,
    alates out date,
    kuni out date,
    roll out varchar2,
    created out date,
    last_modified out date,
    username out varchar2,
    peatatud out number,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    ametikoht_taitmine a
    where   a.aar_id = Get_AmetikohaTaitmineByAarID.aar_id
            and rownum < 2;
    
    if cnt > 0 then
        select  a.taitmine_id,
                a.ametikoht_id,
                a.i_id,
                a.alates,
                a.kuni,
                a.roll,
                a.created,
                a.last_modified,
                a.username,
                a.peatatud
        into    Get_AmetikohaTaitmineByAarID.id,
                Get_AmetikohaTaitmineByAarID.ametikoht_id,
                Get_AmetikohaTaitmineByAarID.isik_id,
                Get_AmetikohaTaitmineByAarID.alates,
                Get_AmetikohaTaitmineByAarID.kuni,
                Get_AmetikohaTaitmineByAarID.roll,
                Get_AmetikohaTaitmineByAarID.created,
                Get_AmetikohaTaitmineByAarID.last_modified,
                Get_AmetikohaTaitmineByAarID.username,
                Get_AmetikohaTaitmineByAarID.peatatud
        from    ametikoht_taitmine a
        where   a.aar_id = Get_AmetikohaTaitmineByAarID.aar_id
                and rownum < 2;
    else
        Get_AmetikohaTaitmineByAarID.id := null;
        Get_AmetikohaTaitmineByAarID.ametikoht_id := null;
        Get_AmetikohaTaitmineByAarID.isik_id := null;
        Get_AmetikohaTaitmineByAarID.alates := null;
        Get_AmetikohaTaitmineByAarID.kuni := null;
        Get_AmetikohaTaitmineByAarID.roll := null;
        Get_AmetikohaTaitmineByAarID.created := null;
        Get_AmetikohaTaitmineByAarID.last_modified := null;
        Get_AmetikohaTaitmineByAarID.username := null;
        Get_AmetikohaTaitmineByAarID.peatatud := null;
    end if;
end;
/

create or replace
procedure Get_AmetikohaTaitmineList(
    ametikoht_id in number,
    isikukood in varchar2,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  a.*
    from    ametikoht_taitmine a
    inner join
            isik i on i.i_id = a.i_id
    where   a.ametikoht_id = Get_AmetikohaTaitmineList.ametikoht_id
            and i.kood = Get_AmetikohaTaitmineList.isikukood;
end;
/

create or replace
procedure Add_AmetikohaTaitmine(
    id out number,
    ametikoht_id in number,
    isik_id in number,
    alates in date,
    kuni in date,
    roll in varchar2,
    created in date,
    last_modified in date,
    username in varchar2,
    peatatud in number,
    aar_id in number)
as
ametikoht_id_ number(38,0) := ametikoht_id;
isik_id_ number(38,0) := isik_id;
aar_id_ number(38,0) := aar_id;
begin
    if ametikoht_id_ = 0 then
        ametikoht_id_ := null;
    end if;
    if isik_id_ = 0 then
        isik_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    insert
    into    ametikoht_taitmine(
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
    values  (0,
            Add_AmetikohaTaitmine.ametikoht_id_,
            Add_AmetikohaTaitmine.isik_id_,
            Add_AmetikohaTaitmine.alates,
            Add_AmetikohaTaitmine.kuni,
            Add_AmetikohaTaitmine.roll,
            Add_AmetikohaTaitmine.created,
            Add_AmetikohaTaitmine.last_modified,
            Add_AmetikohaTaitmine.username,
            Add_AmetikohaTaitmine.peatatud,
            Add_AmetikohaTaitmine.aar_id_);
    
    Add_AmetikohaTaitmine.id := globalPkg.identity;
end;
/

create or replace
procedure Update_AmetikohaTaitmine(
    id in number,
    ametikoht_id in number,
    isik_id in number,
    alates in date,
    kuni in date,
    roll in varchar2,
    created in date,
    last_modified in date,
    username in varchar2,
    peatatud in number,
    aar_id in number)
as
ametikoht_id_ number(38,0) := ametikoht_id;
isik_id_ number(38,0) := isik_id;
aar_id_ number(38,0) := aar_id;
begin
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
    set     ametikoht_id = Update_AmetikohaTaitmine.ametikoht_id_,
            i_id = Update_AmetikohaTaitmine.isik_id_,
            alates = Update_AmetikohaTaitmine.alates,
            kuni = Update_AmetikohaTaitmine.kuni,
            roll = Update_AmetikohaTaitmine.roll,
            created = Update_AmetikohaTaitmine.created,
            last_modified = Update_AmetikohaTaitmine.last_modified,
            username = Update_AmetikohaTaitmine.username,
            peatatud = Update_AmetikohaTaitmine.peatatud,
            aar_id = Update_AmetikohaTaitmine.aar_id_
    where   taitmine_id = Update_AmetikohaTaitmine.id;
end;
/

create or replace
procedure Get_AmetikohtByAarID(
    id out number,
    ks_ametikoht_id out number,
    asutus_id out number,
    nimetus out varchar2,
    alates out date,
    kuni out date,
    created out date,
    last_modified out date,
    username out varchar2,
    allyksus_id out number,
    params out varchar2,
    lyhinimetus out varchar2,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    ametikoht a
    where   a.aar_id = Get_AmetikohtByAarID.aar_id
            and rownum < 2;
    
    if cnt > 0 then
        select  a.ametikoht_id,
                a.ks_ametikoht_id,
                a.asutus_id,
                a.ametikoht_nimetus,
                a.alates,
                a.kuni,
                a.created,
                a.last_modified,
                a.username,
                a.allyksus_id,
                a.params,
                a.lyhinimetus
        into    Get_AmetikohtByAarID.id,
                Get_AmetikohtByAarID.ks_ametikoht_id,
                Get_AmetikohtByAarID.asutus_id,
                Get_AmetikohtByAarID.nimetus,
                Get_AmetikohtByAarID.alates,
                Get_AmetikohtByAarID.kuni,
                Get_AmetikohtByAarID.created,
                Get_AmetikohtByAarID.last_modified,
                Get_AmetikohtByAarID.username,
                Get_AmetikohtByAarID.allyksus_id,
                Get_AmetikohtByAarID.params,
                Get_AmetikohtByAarID.lyhinimetus
        from    ametikoht a
        where   a.aar_id = Get_AmetikohtByAarID.aar_id
                and rownum < 2;
    else
        Get_AmetikohtByAarID.id := null;
        Get_AmetikohtByAarID.ks_ametikoht_id := null;
        Get_AmetikohtByAarID.asutus_id := null;
        Get_AmetikohtByAarID.nimetus := null;
        Get_AmetikohtByAarID.alates := null;
        Get_AmetikohtByAarID.kuni := null;
        Get_AmetikohtByAarID.created := null;
        Get_AmetikohtByAarID.last_modified := null;
        Get_AmetikohtByAarID.username := null;
        Get_AmetikohtByAarID.allyksus_id := null;
        Get_AmetikohtByAarID.params := null;
        Get_AmetikohtByAarID.lyhinimetus := null;
    end if;
end;
/

create or replace
procedure Get_AmetikohtIdByAarID(
    id out number,
    aar_id in number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    ametikoht a
    where   a.aar_id = Get_AmetikohtIdByAarID.aar_id
            and rownum < 2;
    
    if cnt > 0 then
        select  a.ametikoht_id
        into    Get_AmetikohtIdByAarID.id
        from    ametikoht a
        where   a.aar_id = Get_AmetikohtIdByAarID.aar_id
                and rownum < 2;
    else
        Get_AmetikohtIdByAarID.id := null;
    end if;
end;
/

create or replace
procedure Get_AmetikohtList(
    asutus_id in number,
    nimetus in varchar2,
    RC1 out globalPkg.RCT1)
as
begin
    -- Allolev keeruline union all konstruktsioon on kasulik
    -- OR operaatori v�ltimiseks (Oracle puhul v�ga aeglane)
    open RC1 for
    select  a.*,
            null as allyksuse_lyhinimetus
    from    ametikoht a
    where   a.asutus_id = nvl(Get_AmetikohtList.asutus_id, a.asutus_id)
            and a.ametikoht_nimetus = Get_AmetikohtList.nimetus
            and a.allyksus_id is null
    union all
    select  a1.*,
            null as allyksuse_lyhinimetus
    from    ametikoht a1
    where   a1.asutus_id = nvl(Get_AmetikohtList.asutus_id, a1.asutus_id)
            and Get_AmetikohtList.nimetus is null
            and a1.allyksus_id is null
    union all
    select  a2.*,
            y2.lyhinimetus as allyksuse_lyhinimetus
    from    ametikoht a2, allyksus y2
    where   a2.asutus_id = nvl(Get_AmetikohtList.asutus_id, a2.asutus_id)
            and a2.ametikoht_nimetus = Get_AmetikohtList.nimetus
            and y2.id = a2.allyksus_id
    union all
    select  a3.*,
            y3.lyhinimetus as allyksuse_lyhinimetus
    from    ametikoht a3, allyksus y3
    where   a3.asutus_id = nvl(Get_AmetikohtList.asutus_id, a3.asutus_id)
            and Get_AmetikohtList.nimetus is null
            and y3.id = a3.allyksus_id;
end;
/

create or replace
procedure Add_Ametikoht(
    id out number,
    ks_ametikoht_id in number,
    asutus_id in number,
    nimetus in varchar2,
    alates in date,
    kuni in date,
    created in date,
    last_modified in date,
    username in varchar2,
    allyksus_id in number,
    params in varchar2,
    lyhinimetus in varchar2,
    aar_id in number)
as
ks_ametikoht_id_ number(38,0) := ks_ametikoht_id;
asutus_id_ number(38,0) := asutus_id;
allyksus_id_ number(38,0) := allyksus_id;
aar_id_ number(38,0) := aar_id;
begin
    if ks_ametikoht_id_ = 0 then
        ks_ametikoht_id_ := null;
    end if;
    if asutus_id_ = 0 then
        asutus_id_ := null;
    end if;
    if allyksus_id_ = 0 then
        allyksus_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    insert
    into    ametikoht(
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
    values  (0,
            Add_Ametikoht.ks_ametikoht_id_,
            Add_Ametikoht.asutus_id_,
            Add_Ametikoht.nimetus,
            Add_Ametikoht.alates,
            Add_Ametikoht.kuni,
            Add_Ametikoht.created,
            Add_Ametikoht.last_modified,
            Add_Ametikoht.username,
            Add_Ametikoht.allyksus_id_,
            Add_Ametikoht.params,
            Add_Ametikoht.lyhinimetus,
            Add_Ametikoht.aar_id_);
    
    Add_Ametikoht.id := globalPkg.identity;
end;
/

create or replace
procedure Update_Ametikoht(
    id in number,
    ks_ametikoht_id in number,
    asutus_id in number,
    nimetus in varchar2,
    alates in date,
    kuni in date,
    created in date,
    last_modified in date,
    username in varchar2,
    allyksus_id in number,
    params in varchar2,
    lyhinimetus in varchar2,
    aar_id in number)
as
ks_ametikoht_id_ number(38,0) := ks_ametikoht_id;
asutus_id_ number(38,0) := asutus_id;
allyksus_id_ number(38,0) := allyksus_id;
aar_id_ number(38,0) := aar_id;
begin
    if ks_ametikoht_id_ = 0 then
        ks_ametikoht_id_ := null;
    end if;
    if asutus_id_ = 0 then
        asutus_id_ := null;
    end if;
    if allyksus_id_ = 0 then
        allyksus_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    update  ametikoht
    set     ks_ametikoht_id = Update_Ametikoht.ks_ametikoht_id_,
            asutus_id = Update_Ametikoht.asutus_id_,
            ametikoht_nimetus = Update_Ametikoht.nimetus,
            alates = Update_Ametikoht.alates,
            kuni = Update_Ametikoht.kuni,
            created = Update_Ametikoht.created,
            last_modified = Update_Ametikoht.last_modified,
            username = Update_Ametikoht.username,
            allyksus_id = Update_Ametikoht.allyksus_id_,
            params = Update_Ametikoht.params,
            lyhinimetus = Update_Ametikoht.lyhinimetus,
            aar_id = Update_Ametikoht.aar_id_
    where   ametikoht_id = Update_Ametikoht.id;
end;
/

create or replace
procedure Get_IsikByCode(
    id out number,
    isikukood in varchar2,
    perenimi out varchar2,
    eesnimi out varchar2,
    maakond out varchar2,
    aadress out varchar2,
    postiindeks out varchar2,
    telefon out varchar2,
    epost out varchar2,
    www out varchar2,
    parameetrid out varchar2,
    loodud out date,
    muudetud out date,
    muutja out date)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    isik i
    where   i.kood = Get_IsikByCode.isikukood
            and rownum < 2;
    
    if cnt > 0 then
        select  i.i_id,
                i.perenimi,
                i.eesnimi,
                i.maakond,
                i.aadress,
                i.postikood,
                i.telefon,
                i.e_post,
                i.www,
                i.params,
                i.created,
                i.last_modified,
                i.username
        into    Get_IsikByCode.id,
                Get_IsikByCode.perenimi,
                Get_IsikByCode.eesnimi,
                Get_IsikByCode.maakond,
                Get_IsikByCode.aadress,
                Get_IsikByCode.postiindeks,
                Get_IsikByCode.telefon,
                Get_IsikByCode.epost,
                Get_IsikByCode.www,
                Get_IsikByCode.parameetrid,
                Get_IsikByCode.loodud,
                Get_IsikByCode.muudetud,
                Get_IsikByCode.muutja
        from    isik i
        where   i.i_id = Get_IsikByCode.id
                and rownum < 2;
    else
        Get_IsikByCode.id := null;
        Get_IsikByCode.perenimi := null;
        Get_IsikByCode.eesnimi := null;
        Get_IsikByCode.maakond := null;
        Get_IsikByCode.aadress := null;
        Get_IsikByCode.postiindeks := null;
        Get_IsikByCode.telefon := null;
        Get_IsikByCode.epost := null;
        Get_IsikByCode.www := null;
        Get_IsikByCode.parameetrid := null;
        Get_IsikByCode.loodud := null;
        Get_IsikByCode.muudetud := null;
        Get_IsikByCode.muutja := null;
    end if;
end;
/

create or replace
procedure Add_Isik(
    id out number,
    isikukood in varchar2,
    perenimi in varchar2,
    eesnimi in varchar2,
    maakond in varchar2,
    aadress in varchar2,
    postiindeks in varchar2,
    telefon in varchar2,
    epost in varchar2,
    www in varchar2,
    parameetrid in varchar2,
    created in date,
    last_modified in date,
    username in varchar2)
as
begin
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
    values  (0,
            Add_Isik.isikukood,
            Add_Isik.perenimi,
            Add_Isik.eesnimi,
            Add_Isik.maakond,
            Add_Isik.aadress,
            Add_Isik.postiindeks,
            Add_Isik.telefon,
            Add_Isik.epost,
            Add_Isik.www,
            Add_Isik.parameetrid,
            Add_Isik.created,
            Add_Isik.last_modified,
            Add_Isik.username);
    
    Add_Isik.id := globalPkg.identity;
end;
/

create or replace
procedure Update_Isik(
    id in number,
    isikukood in varchar2,
    perenimi in varchar2,
    eesnimi in varchar2,
    maakond in varchar2,
    aadress in varchar2,
    postiindeks in varchar2,
    telefon in varchar2,
    epost in varchar2,
    www in varchar2,
    parameetrid in varchar2,
    created in date,
    last_modified in date,
    username in varchar2)
as
begin
    update  isik
    set     kood = Update_Isik.isikukood,
            perenimi = Update_Isik.perenimi,
            eesnimi = Update_Isik.eesnimi,
            maakond = Update_Isik.maakond,
            aadress = Update_Isik.aadress,
            postikood = Update_Isik.postiindeks,
            telefon = Update_Isik.telefon,
            e_post = Update_Isik.epost,
            www = Update_Isik.www,
            params = Update_Isik.parameetrid,
            created = Update_Isik.created,
            last_modified = Update_Isik.last_modified,
            username = Update_Isik.username
    where   i_id = Update_Isik.id;
end;
/

create or replace
procedure Get_NextRecipientID(
    recipient_id out number)
as
begin
    select  sq_vastuvotja_id.nextval
    into    Get_NextRecipientID.recipient_id
    from    dual;
end;
/

create or replace
procedure Get_AmetikohtIdByShortName(
    id out number,
    org_id in number,
    short_name in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    ametikoht a
    where   a.asutus_id = Get_AmetikohtIdByShortName.org_id
            and a.lyhinimetus = Get_AmetikohtIdByShortName.short_name
            and rownum < 2;
    
    if cnt > 0 then
        select  a.ametikoht_id
        into    Get_AmetikohtIdByShortName.id
        from    ametikoht a
        where   a.asutus_id = Get_AmetikohtIdByShortName.org_id
                and a.lyhinimetus = Get_AmetikohtIdByShortName.short_name
                and rownum < 2;
    else
        Get_AmetikohtIdByShortName.id := null;
    end if;
end;
/

create or replace
procedure Get_AllyksusIdByShortName(
    id out number,
    org_id in number,
    short_name in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    allyksus a
    where   a.asutus_id = Get_AllyksusIdByShortName.org_id
            and a.lyhinimetus = Get_AllyksusIdByShortName.short_name
            and rownum < 2;
    
    if cnt > 0 then
        select  a.id
        into    Get_AllyksusIdByShortName.id
        from    allyksus a
        where   a.asutus_id = Get_AllyksusIdByShortName.org_id
                and a.lyhinimetus = Get_AllyksusIdByShortName.short_name
                and rownum < 2;
    else
        Get_AllyksusIdByShortName.id := null;
    end if;
end;
/

create or replace
procedure Get_AllyksusStat(
    asutus_id in number,
    allyksus_id in number,
    vastuvotmata_dokumente out number,
    vahetatud_dokumente out number)
as
begin
    select  count(*)
    into    Get_AllyksusStat.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = Get_AllyksusStat.asutus_id
            and allyksus_id = Get_AllyksusStat.allyksus_id
            and staatus_id = 101;
    
    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = Get_AllyksusStat.asutus_id
                        and allyksus_id = Get_AllyksusStat.allyksus_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = Get_AllyksusStat.asutus_id
                        and allyksus_id = Get_AllyksusStat.allyksus_id
            )
    into    Get_AllyksusStat.vahetatud_dokumente
    from    dual;
end;
/

create or replace
procedure Get_AmetikohtStat(
    asutus_id in number,
    ametikoht_id in number,
    vastuvotmata_dokumente out number,
    vahetatud_dokumente out number)
as
begin
    select  count(*)
    into    Get_AmetikohtStat.vastuvotmata_dokumente
    from    vastuvotja
    where   asutus_id = Get_AmetikohtStat.asutus_id
            and ametikoht_id = Get_AmetikohtStat.ametikoht_id
            and staatus_id = 101;
    
    select  (
                select  count(*)
                from    vastuvotja
                where   asutus_id = Get_AmetikohtStat.asutus_id
                        and ametikoht_id = Get_AmetikohtStat.ametikoht_id
                        and staatus_id = 102
            ) + (
                select  count(*)
                from    saatja
                where   asutus_id = Get_AmetikohtStat.asutus_id
                        and ametikoht_id = Get_AmetikohtStat.ametikoht_id
            )
    into    Get_AmetikohtStat.vahetatud_dokumente
    from    dual;
end;
/

create or replace
procedure Get_DocumentStatusHistory(
    document_id in number,
    RC1 out globalPkg.RCT1)
as
begin
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
            and t.dokument_id = Get_DocumentStatusHistory.document_id;
end;
/

create or replace procedure Get_LastSendingByDocGUID(
    document_guid in varchar,
    sending_id out number,
    sending_start_date out date,
    sending_end_date out date,
    send_status_id out number,
    document_id out number)
as
cnt number(38,0) := 0;
begin

    select  count(*)
    into    cnt
    from    transport t, dokument d
    where   t.dokument_id = d.dokument_id and
            d.guid = Get_LastSendingByDocGUID.document_guid;
    
    if cnt > 0 then    
        select  t.transport_id,
                t.saatmise_algus,
                t.saatmise_lopp,
                t.staatus_id
        into    Get_LastSendingByDocGUID.sending_id,
                Get_LastSendingByDocGUID.sending_start_date,
                Get_LastSendingByDocGUID.sending_end_date,
                Get_LastSendingByDocGUID.send_status_id
        from    transport t
        where   t.transport_id =
                (
                    select  max(t1.transport_id)
                    from    transport t1, dokument d2
                    where   t1.dokument_id = d2.dokument_id and
                            d2.guid = Get_LastSendingByDocGUID.document_guid
                )
                and rownum < 2;
                
        select dokument_id into Get_LastSendingByDocGUID.document_id
        from dokument
        where guid = Get_LastSendingByDocGUID.document_guid;
    else
        Get_LastSendingByDocGUID.sending_id := null;
        Get_LastSendingByDocGUID.sending_start_date := null;
        Get_LastSendingByDocGUID.sending_end_date := null;
        Get_LastSendingByDocGUID.send_status_id := null;
    end if;
end;
/


------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:06:34 -------

  CREATE INDEX "ASUTUS_ID_IDX" ON "SAATJA" ("ASUTUS_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/
------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:06:51 -------

  CREATE INDEX "ASUTUS_ID_IDX1" ON "DOKUMENT" ("ASUTUS_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/
------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:07:09 -------

  CREATE INDEX "ASUTUS_ID_IDX2" ON "VASTUVOTJA" ("ASUTUS_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/
------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:07:29 -------

  CREATE UNIQUE INDEX "DOKUMENT_ID_IDX" ON "TRANSPORT" ("DOKUMENT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/
------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:08:00 -------

  CREATE UNIQUE INDEX "TRANSPORT_ID_IDX" ON "SAATJA" ("TRANSPORT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/
------- Generated by SYS.DBMS_METADATA on 6-juuni-2008 at 16:08:15 -------

  CREATE INDEX "TRANSPORT_ID_IDX1" ON "VASTUVOTJA" ("TRANSPORT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/


create index "ALLYKSUS_LYHINIMETUS_IDX" on "ALLYKSUS"(nvl(lyhinimetus,' '))
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/

create index "AMETIKOHT_LYHINIMETUS_IDX" on "AMETIKOHT"(nvl(lyhinimetus,' '))
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/

