/*
alter
table   asutus
add     (dhl_saatmine number(1,0) default 1 null);
/
*/

alter
table   asutus
add
(
        dhs_nimetus varchar2(150) null,
        toetatav_dvk_versioon varchar2(20) null,
        server_id number(38,0) null,
        aar_id number(38,0) null
);
/

alter
table   allyksus
add     (aar_id number(38,0) null);
/

alter
table   ametikoht
add     (aar_id number(38,0) null);
/

alter
table   ametikoht_taitmine
add     (aar_id number(38,0) null);
/

alter
table   oigus_antud
add     (allyksus_id number(38,0) null);
/

alter
table   saatja
add
(
    asutuse_nimi varchar2(500) null,
    allyksus_id number(38,0) null
);
/

alter
table   vastuvotja
add
(
    asutuse_nimi varchar2(500) null,
    allyksus_id number(38,0) null,
    dok_id_teises_serveris number(38,0) null
);
/

update  dokument
set     sailitustahtaeg = ADD_MONTHS(sysdate, 1)
where   sailitustahtaeg is null;
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
    PRIMARY KEY (vahendaja_id),
    CONSTRAINT fk_vahendaja_1 FOREIGN KEY (transport_id)
        REFERENCES transport (transport_id) ON DELETE CASCADE,
    CONSTRAINT fk_vahendaja_2 FOREIGN KEY (asutus_id)
        REFERENCES asutus (asutus_id),
    CONSTRAINT fk_vahendaja_3 FOREIGN KEY (ametikoht_id)
        REFERENCES ametikoht (ametikoht_id)
);
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
);
/

create sequence sq_dokumendi_fragment_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

CREATE INDEX IX_DOKUMENDI_FRAGMENT_1 ON DOKUMENDI_FRAGMENT (ASUTUS_ID, EDASTUS_ID, SISSETULEV);
/

create
table   parameetrid
(
    aar_viimane_sync date null
);
/

insert
into    parameetrid(aar_viimane_sync)
values  (sysdate);
/

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
    department_name out varchar2)
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
            s.osakonna_nimi
    into    Get_SenderBySendingID.sender_id,
            Get_SenderBySendingID.organization_id,
            Get_SenderBySendingID.position_id,
            Get_SenderBySendingID.division_id,
            Get_SenderBySendingID.personal_id_code,
            Get_SenderBySendingID.name,
            Get_SenderBySendingID.organization_name,
            Get_SenderBySendingID.email,
            Get_SenderBySendingID.department_nr,
            Get_SenderBySendingID.department_name
    from    saatja s
    where   s.transport_id = Get_SenderBySendingID.sending_id
            and rownum < 2;
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
    department_name in varchar2)
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
            osakonna_nimi)
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
            Add_Sender.department_name);

    Add_Sender.sender_id := globalPkg.identity;
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
    department_name in varchar2)
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
            osakonna_nimi)
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
            Add_Proxy.department_name);

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
    department_name out varchar2)
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
                v.osakonna_nimi
        into    Get_ProxyBySendingID.proxy_id,
                Get_ProxyBySendingID.organization_id,
                Get_ProxyBySendingID.position_id,
                Get_ProxyBySendingID.division_id,
                Get_ProxyBySendingID.personal_id_code,
                Get_ProxyBySendingID.name,
                Get_ProxyBySendingID.organization_name,
                Get_ProxyBySendingID.email,
                Get_ProxyBySendingID.department_nr,
                Get_ProxyBySendingID.department_name
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
                a.muutm_arv
        into    Get_AllyksusByAarID.id,
                Get_AllyksusByAarID.asutus_id,
                Get_AllyksusByAarID.vanem_id,
                Get_AllyksusByAarID.nimetus,
                Get_AllyksusByAarID.created,
                Get_AllyksusByAarID.last_modified,
                Get_AllyksusByAarID.username,
                Get_AllyksusByAarID.muutmiste_arv
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
    open RC1 for
    select  a.*
    from    allyksus a
    where   a.asutus_id = Get_AllyksusList.asutus_id
            and a.allyksus = Get_AllyksusList.nimetus
    union all
    select  a1.*
    from    allyksus a1
    where   a1.asutus_id = Get_AllyksusList.asutus_id
            and Get_AllyksusList.nimetus is null;
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
    aar_id in number)
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
            aar_id)
    values  (0,
            Add_Allyksus.asutus_id_,
            Add_Allyksus.vanem_id_,
            Add_Allyksus.nimetus,
            Add_Allyksus.created,
            Add_Allyksus.last_modified,
            Add_Allyksus.username,
            Add_Allyksus.muutmiste_arv,
            Add_Allyksus.aar_id_);

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
    aar_id in number)
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
            aar_id = Update_Allyksus.aar_id_
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
                a.params
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
                Get_AmetikohtByAarID.params
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
    open RC1 for
    select  a.*
    from    ametikoht a
    where   a.asutus_id = Get_AmetikohtList.asutus_id
            and a.ametikoht_nimetus = Get_AmetikohtList.nimetus
    union all
    select  a1.*
    from    ametikoht a1
    where   a1.asutus_id = Get_AmetikohtList.asutus_id
            and Get_AmetikohtList.nimetus is null;
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
procedure Get_DocumentsSentTo(
    organization_id in number,
    folder_id in number,
    user_id in number,
    result_limit in number,
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dokument d,
    (
        -- Dokumendid, mis adresseeriti päringu teostanud isikule
        select  t1.dokument_id
        from    transport t1, vastuvotja v1, isik i1
        where   t1.transport_id = v1.transport_id
                and v1.asutus_id = Get_DocumentsSentTo.organization_id
                and i1.kood = v1.isikukood
                and i1.i_id = Get_DocumentsSentTo.user_id
                and v1.staatus_id = 101

        -- Dokumendid, mis adresseeriti päringu teostaja ametikohale
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
                            and akt2.peatatud = 0
                            and ak2.asutus_id = v2.asutus_id
                            and nvl(akt2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt2.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak2.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak2.kuni, add_months(sysdate, 1)) > sysdate
                )

        -- Dokumendid, mis adresseeriti päringu teostaja allüksusele
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
                            and akt3.peatatud = 0
                            and ak3.asutus_id = v3.asutus_id
                            and nvl(akt3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt3.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak3.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak3.kuni, add_months(sysdate, 1)) > sysdate
                )

        -- Dokumendid, mis adresseeriti päringu teostaja ametikohale
        -- päringu teostaja allüksuses (vastupidine juhtum oleks, et
        -- dokument saadeti mõnele teisele ametikohale samas allüksuses).
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
                            and akt4.peatatud = 0
                            and ak4.asutus_id = v4.asutus_id
                            and nvl(akt4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(akt4.kuni, add_months(sysdate, 1)) > sysdate
                            and nvl(ak4.alates, add_months(sysdate, -1)) < sysdate
                            and nvl(ak4.kuni, add_months(sysdate, 1)) > sysdate
                )

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
                            and akt5.peatatud = 0
                            and oa5.peatatud = 0
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
