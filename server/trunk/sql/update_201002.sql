------------------------------------------------------------------------
-- Versioon 1.6.0 - 2010/02
------------------------------------------------------------------------

ALTER TABLE
    dokument
ADD
    suurus NUMBER(20)
/

COMMENT ON COLUMN dokument.suurus IS 'Dokumendi suurus baitides.'
/

ALTER TABLE
    dokument
ADD (
    GUID VARCHAR2(36)
);

COMMENT ON COLUMN dokument.GUID IS 'Dokumendi Globaalselt Unikaalne Identifikaator.'
/

ALTER TABLE
    dokument
ADD (
    versioon number(10) default 1
);

alter
table   allyksus
add
(
    lyhinimetus varchar2(25) null,
    adr_uri varchar2(500) null
)
/

create index "ALLYKSUS_LYHINIMETUS_IDX" on "ALLYKSUS"(nvl(lyhinimetus,' '))
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/

alter
table   ametikoht
add
(
    lyhinimetus varchar2(25) null
)
/

alter
table   saatja
add
(
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

alter
table   vastuvotja
add
(
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

alter
table   vahendaja
add
(
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

alter
table   vastuvotja_mall
add
(
    allyksuse_lyhinimetus varchar2(25) null,
    ametikoha_lyhinimetus varchar2(25) null
)
/

create index "AMETIKOHT_LYHINIMETUS_IDX" on "AMETIKOHT"(nvl(lyhinimetus,' '))
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/

alter table logi add (
  xtee_isikukood VARCHAR2(20),
  xtee_asutus VARCHAR2(50)
)
/

CREATE INDEX "AMETIKOHT_ID_SN_IDX" ON "AMETIKOHT" ("ASUTUS_ID", "LYHINIMETUS") 
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
/

CREATE INDEX "ALLYKSUS_ID_SN_IDX" ON "ALLYKSUS" ("ASUTUS_ID", "LYHINIMETUS") 
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
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

insert
into    staatuse_ajalugu(
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
select  0,
        v.vastuvotja_id,
        101,
        t.saatmise_algus,
        null,
        null,
        null,
        null,
        null,
        null
from    vastuvotja v, transport t
where   v.transport_id = t.transport_id;

insert
into    staatuse_ajalugu(
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
select  0,
        vastuvotja_id,
        staatus_id,
        saatmise_lopp,
        fault_code,
        fault_actor,
        fault_string,
        fault_detail,
        vastuvotja_staatus_id,
        metaxml
from    vastuvotja
where   staatus_id <> 101;





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
procedure Get_AmetikohtList(
    asutus_id in number,
    nimetus in varchar2,
    RC1 out globalPkg.RCT1)
as
begin
    -- Allolev keeruline union all konstruktsioon on kasulik
    -- OR operaatori vältimiseks (Oracle puhul väga aeglane)
    open RC1 for
    select  a.*,
            null as allyksuse_lyhinimetus
    from    ametikoht a
    where   a.asutus_id = nvl(Get_AmetikohtList.asutus_id, a.asutus_id)
            and a.ametikoht_nimetus = Get_AmetikohtList.nimetus
            and a.allyksus_id is null
            and nvl(a.alates, add_months(sysdate, -1)) < sysdate
            and nvl(a.kuni, add_months(sysdate, 1)) > sysdate
    union all
    select  a1.*,
            null as allyksuse_lyhinimetus
    from    ametikoht a1
    where   a1.asutus_id = nvl(Get_AmetikohtList.asutus_id, a1.asutus_id)
            and Get_AmetikohtList.nimetus is null
            and a1.allyksus_id is null
            and nvl(a1.alates, add_months(sysdate, -1)) < sysdate
            and nvl(a1.kuni, add_months(sysdate, 1)) > sysdate
    union all
    select  a2.*,
            y2.lyhinimetus as allyksuse_lyhinimetus
    from    ametikoht a2, allyksus y2
    where   a2.asutus_id = nvl(Get_AmetikohtList.asutus_id, a2.asutus_id)
            and a2.ametikoht_nimetus = Get_AmetikohtList.nimetus
            and y2.id = a2.allyksus_id
            and nvl(a2.alates, add_months(sysdate, -1)) < sysdate
            and nvl(a2.kuni, add_months(sysdate, 1)) > sysdate
    union all
    select  a3.*,
            y3.lyhinimetus as allyksuse_lyhinimetus
    from    ametikoht a3, allyksus y3
    where   a3.asutus_id = nvl(Get_AmetikohtList.asutus_id, a3.asutus_id)
            and Get_AmetikohtList.nimetus is null
            and y3.id = a3.allyksus_id
            and nvl(a3.alates, add_months(sysdate, -1)) < sysdate
            and nvl(a3.kuni, add_months(sysdate, 1)) > sysdate;
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
    -- OR operaatori vältimiseks (Oracle puhul väga aeglane)
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
        -- Dokumendid, mis adresseeriti päringu teostanud isikule (isikukoodi alusel)
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
                
        -- Dokumendid, mis adresseeriti päringu teostaja ametikohale (ametikoha ID või lühinimetus)
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
    division_short_name in varchar2,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
organization_id_ number(38,0) := organization_id;
position_id_ number(38,0) := position_id;
division_id_ number(38,0) := division_id;
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Add_Sender.xtee_isikukood;
    DVKLOG.xtee_asutus := Add_Sender.xtee_asutus;

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
    division_short_name in varchar2,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
organization_id_ number(38,0) := organization_id;
position_id_ number(38,0) := position_id;
division_id_ number(38,0) := division_id;
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Add_Proxy.xtee_isikukood;
    DVKLOG.xtee_asutus := Add_Proxy.xtee_asutus;

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

create or replace
PROCEDURE ADD_DOKUMENT(
  dokument_id IN NUMBER,
  asutus_id IN NUMBER,
  kaust_id IN NUMBER,
  sisu IN CLOB,
  sailitustahtaeg IN DATE,
  suurus IN NUMBER,
  versioon IN NUMBER,
  guid IN VARCHAR2,
  xtee_isikukood IN VARCHAR2,
  xtee_asutus IN VARCHAR2
) AS

BEGIN

  -- Set session scope variables
  DVKLOG.xtee_isikukood := ADD_DOKUMENT.xtee_isikukood;
  DVKLOG.xtee_asutus := ADD_DOKUMENT.xtee_asutus;

  INSERT INTO dokument (
    dokument_id,
    asutus_id,
    kaust_id,
    sisu,
    sailitustahtaeg,
    suurus,
    versioon,
    guid
  ) VALUES (
    ADD_DOKUMENT.dokument_id,
    ADD_DOKUMENT.asutus_id,
    ADD_DOKUMENT.kaust_id,
    ADD_DOKUMENT.sisu,
    ADD_DOKUMENT.sailitustahtaeg,
    ADD_DOKUMENT.suurus,
    ADD_DOKUMENT.versioon,
    ADD_DOKUMENT.guid
  );

END;
/

create or replace
procedure Add_Sending(
    sending_id out number,
    document_id in number,
    sending_start_date in date,
    sending_end_date in date,
    send_status_id in number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Add_Sending.xtee_isikukood;
    DVKLOG.xtee_asutus := Add_Sending.xtee_asutus;

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
    aar_id in number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
cnt number(38,0) := 0;
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Add_Asutus.xtee_isikukood;
    DVKLOG.xtee_asutus := Add_Asutus.xtee_asutus;

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
    aar_id in number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Update_Asutus.xtee_isikukood;
    DVKLOG.xtee_asutus := Update_Asutus.xtee_asutus;

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
PROCEDURE ADD_DOKUMENT_FRAGMENT(
  fragment_id in number,
  sissetulev in number,
  asutus_id in number,
  edastus_id in varchar2,
  fragment_nr in number,
  fragmente_kokku in number,
  loodud in date,
  sisu in blob,
  xtee_isikukood in varchar2,
  xtee_asutus in varchar2
) AS 
BEGIN

  -- Set session scope variables
  DVKLOG.xtee_isikukood := ADD_DOKUMENT_FRAGMENT.xtee_isikukood;
  DVKLOG.xtee_asutus := ADD_DOKUMENT_FRAGMENT.xtee_asutus;
  
  INSERT INTO dokumendi_fragment (
    fragment_id,
    sissetulev,
    asutus_id,
    edastus_id,
    fragment_nr,
    fragmente_kokku,
    loodud,
    sisu
  ) VALUES (
    ADD_DOKUMENT_FRAGMENT.fragment_id,
    ADD_DOKUMENT_FRAGMENT.sissetulev,
    ADD_DOKUMENT_FRAGMENT.asutus_id,
    ADD_DOKUMENT_FRAGMENT.edastus_id,
    ADD_DOKUMENT_FRAGMENT.fragment_nr,
    ADD_DOKUMENT_FRAGMENT.fragmente_kokku,
    ADD_DOKUMENT_FRAGMENT.loodud,
    ADD_DOKUMENT_FRAGMENT.sisu
  );

  NULL;
END ADD_DOKUMENT_FRAGMENT;
/

create or replace
PROCEDURE ADD_FOLDER(
    folder_name in varchar2,
    parent_id in number,
    org_id in number,
    folder_number in varchar2,
    folder_id out number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2)
as
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := ADD_FOLDER.xtee_isikukood;
    DVKLOG.xtee_asutus := ADD_FOLDER.xtee_asutus;

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

CREATE OR REPLACE PROCEDURE ADD_STAATUSE_AJALUGU(
  staatuse_ajalugu_id in number,
  vastuvotja_id in number,
  staatus_id in number,
  staatuse_muutmise_aeg in date,
  fault_code in varchar2,
  fault_actor in varchar2,
  fault_string in varchar2,
  fault_detail in varchar2,
  vastuvotja_staatus_id in number,
  metaxml in clob,
  xtee_isikukood in varchar2,
  xtee_asutus in varchar2,
  staatuse_ajalugu_id_out out number
) AS
BEGIN

  -- Set session scope variables
  DVKLOG.xtee_isikukood := ADD_STAATUSE_AJALUGU.xtee_isikukood;
  DVKLOG.xtee_asutus := ADD_STAATUSE_AJALUGU.xtee_asutus;

  INSERT INTO staatuse_ajalugu (
    staatuse_ajalugu_id,
    vastuvotja_id,
    staatus_id,
    staatuse_muutmise_aeg,
    fault_code,
    fault_actor,
    fault_string,
    fault_detail,
    vastuvotja_staatus_id,
    metaxml
  ) VALUES (
    ADD_STAATUSE_AJALUGU.staatuse_ajalugu_id,
    ADD_STAATUSE_AJALUGU.vastuvotja_id,
    ADD_STAATUSE_AJALUGU.staatus_id,
    ADD_STAATUSE_AJALUGU.staatuse_muutmise_aeg,
    ADD_STAATUSE_AJALUGU.fault_code,
    ADD_STAATUSE_AJALUGU.fault_actor,
    ADD_STAATUSE_AJALUGU.fault_string,
    ADD_STAATUSE_AJALUGU.fault_detail,
    ADD_STAATUSE_AJALUGU.vastuvotja_staatus_id,
    ADD_STAATUSE_AJALUGU.metaxml
  ) RETURNING staatuse_ajalugu_id INTO staatuse_ajalugu_id_out;

END;
/

CREATE OR REPLACE
PROCEDURE ADD_VASTUVOTJA (
  vastuvotja_id in vastuvotja.vastuvotja_id%TYPE, 
  transport_id in vastuvotja.transport_id%TYPE, 
  asutus_id in vastuvotja.asutus_id%TYPE, 
  ametikoht_id in vastuvotja.ametikoht_id%TYPE, 
  allyksus_id in vastuvotja.allyksus_id%TYPE, 
  isikukood in vastuvotja.isikukood%TYPE, 
  nimi in vastuvotja.nimi%TYPE, 
  asutuse_nimi in vastuvotja.asutuse_nimi%TYPE, 
  email in vastuvotja.email%TYPE, 
  osakonna_nr in vastuvotja.osakonna_nr%TYPE, 
  osakonna_nimi in vastuvotja.osakonna_nimi%TYPE, 
  saatmisviis_id in vastuvotja.saatmisviis_id%TYPE, 
  staatus_id in vastuvotja.staatus_id%TYPE, 
  saatmise_algus in vastuvotja.saatmise_algus%TYPE, 
  saatmise_lopp in vastuvotja.saatmise_lopp%TYPE, 
  fault_code in vastuvotja.fault_code%TYPE, 
  fault_actor in vastuvotja.fault_actor%TYPE, 
  fault_string in vastuvotja.fault_string%TYPE, 
  fault_detail in vastuvotja.fault_detail%TYPE, 
  vastuvotja_staatus_id in vastuvotja.vastuvotja_staatus_id%TYPE, 
  metaxml in vastuvotja.metaxml%TYPE, 
  dok_id_teises_serveris in vastuvotja.dok_id_teises_serveris%TYPE, 
  allyksuse_lyhinimetus in vastuvotja.allyksuse_lyhinimetus%TYPE, 
  ametikoha_lyhinimetus in vastuvotja.ametikoha_lyhinimetus%TYPE,
  xtee_isikukood in varchar2,
  xtee_asutus in varchar2
) AS 
BEGIN
  
  -- Set session scope variables
  DVKLOG.xtee_isikukood := ADD_VASTUVOTJA.xtee_isikukood;
  DVKLOG.xtee_asutus := ADD_VASTUVOTJA.xtee_asutus;
  
  INSERT INTO vastuvotja (
    VASTUVOTJA_ID,
    TRANSPORT_ID,
    ASUTUS_ID,
    AMETIKOHT_ID,
    ISIKUKOOD,
    NIMI,
    EMAIL,
    OSAKONNA_NR,
    OSAKONNA_NIMI,
    SAATMISVIIS_ID,
    STAATUS_ID,
    SAATMISE_ALGUS,
    SAATMISE_LOPP,
    FAULT_CODE,
    FAULT_ACTOR,
    FAULT_STRING,
    FAULT_DETAIL,
    VASTUVOTJA_STAATUS_ID,
    METAXML,
    ASUTUSE_NIMI,
    ALLYKSUS_ID,
    DOK_ID_TEISES_SERVERIS,
    ALLYKSUSE_LYHINIMETUS,
    AMETIKOHA_LYHINIMETUS
  ) VALUES (
    ADD_VASTUVOTJA.VASTUVOTJA_ID,
    ADD_VASTUVOTJA.TRANSPORT_ID,
    ADD_VASTUVOTJA.ASUTUS_ID,
    ADD_VASTUVOTJA.AMETIKOHT_ID,
    ADD_VASTUVOTJA.ISIKUKOOD,
    ADD_VASTUVOTJA.NIMI,
    ADD_VASTUVOTJA.EMAIL,
    ADD_VASTUVOTJA.OSAKONNA_NR,
    ADD_VASTUVOTJA.OSAKONNA_NIMI,
    ADD_VASTUVOTJA.SAATMISVIIS_ID,
    ADD_VASTUVOTJA.STAATUS_ID,
    ADD_VASTUVOTJA.SAATMISE_ALGUS,
    ADD_VASTUVOTJA.SAATMISE_LOPP,
    ADD_VASTUVOTJA.FAULT_CODE,
    ADD_VASTUVOTJA.FAULT_ACTOR,
    ADD_VASTUVOTJA.FAULT_STRING,
    ADD_VASTUVOTJA.FAULT_DETAIL,
    ADD_VASTUVOTJA.VASTUVOTJA_STAATUS_ID,
    ADD_VASTUVOTJA.METAXML,
    ADD_VASTUVOTJA.ASUTUSE_NIMI,
    ADD_VASTUVOTJA.ALLYKSUS_ID,
    ADD_VASTUVOTJA.DOK_ID_TEISES_SERVERIS,
    ADD_VASTUVOTJA.ALLYKSUSE_LYHINIMETUS,
    ADD_VASTUVOTJA.AMETIKOHA_LYHINIMETUS
  );
  
END ADD_VASTUVOTJA;
/

create or replace
PROCEDURE UPDATE_VASTUVOTJA (
  vastuvotja_id in vastuvotja.vastuvotja_id%TYPE, 
  transport_id in vastuvotja.transport_id%TYPE, 
  asutus_id in vastuvotja.asutus_id%TYPE, 
  ametikoht_id in vastuvotja.ametikoht_id%TYPE, 
  allyksus_id in vastuvotja.allyksus_id%TYPE, 
  isikukood in vastuvotja.isikukood%TYPE, 
  nimi in vastuvotja.nimi%TYPE, 
  asutuse_nimi in vastuvotja.asutuse_nimi%TYPE, 
  email in vastuvotja.email%TYPE, 
  osakonna_nr in vastuvotja.osakonna_nr%TYPE, 
  osakonna_nimi in vastuvotja.osakonna_nimi%TYPE, 
  saatmisviis_id in vastuvotja.saatmisviis_id%TYPE, 
  staatus_id in vastuvotja.staatus_id%TYPE, 
  saatmise_algus in vastuvotja.saatmise_algus%TYPE, 
  saatmise_lopp in vastuvotja.saatmise_lopp%TYPE, 
  fault_code in vastuvotja.fault_code%TYPE, 
  fault_actor in vastuvotja.fault_actor%TYPE, 
  fault_string in vastuvotja.fault_string%TYPE, 
  fault_detail in vastuvotja.fault_detail%TYPE, 
  vastuvotja_staatus_id in vastuvotja.vastuvotja_staatus_id%TYPE, 
  metaxml in vastuvotja.metaxml%TYPE, 
  dok_id_teises_serveris in vastuvotja.dok_id_teises_serveris%TYPE, 
  allyksuse_lyhinimetus in vastuvotja.allyksuse_lyhinimetus%TYPE, 
  ametikoha_lyhinimetus in vastuvotja.ametikoha_lyhinimetus%TYPE,
  xtee_isikukood in varchar2,
  xtee_asutus in varchar2
) AS 
BEGIN
  
  -- Set session scope variables
  DVKLOG.xtee_isikukood := UPDATE_VASTUVOTJA.xtee_isikukood;
  DVKLOG.xtee_asutus := UPDATE_VASTUVOTJA.xtee_asutus;
  
  UPDATE vastuvotja set
    TRANSPORT_ID = UPDATE_VASTUVOTJA.TRANSPORT_ID,
    ASUTUS_ID = UPDATE_VASTUVOTJA.ASUTUS_ID,
    AMETIKOHT_ID = UPDATE_VASTUVOTJA.AMETIKOHT_ID,
    ISIKUKOOD = UPDATE_VASTUVOTJA.ISIKUKOOD,
    NIMI = UPDATE_VASTUVOTJA.NIMI,
    EMAIL = UPDATE_VASTUVOTJA.EMAIL,
    OSAKONNA_NR = UPDATE_VASTUVOTJA.OSAKONNA_NR,
    OSAKONNA_NIMI = UPDATE_VASTUVOTJA.OSAKONNA_NIMI,
    SAATMISVIIS_ID = UPDATE_VASTUVOTJA.SAATMISVIIS_ID,
    STAATUS_ID = UPDATE_VASTUVOTJA.STAATUS_ID,
    SAATMISE_ALGUS = UPDATE_VASTUVOTJA.SAATMISE_ALGUS,
    SAATMISE_LOPP = UPDATE_VASTUVOTJA.SAATMISE_LOPP,
    FAULT_CODE = UPDATE_VASTUVOTJA.FAULT_CODE,
    FAULT_ACTOR = UPDATE_VASTUVOTJA.FAULT_ACTOR,
    FAULT_STRING = UPDATE_VASTUVOTJA.FAULT_STRING,
    FAULT_DETAIL = UPDATE_VASTUVOTJA.FAULT_DETAIL,
    VASTUVOTJA_STAATUS_ID = UPDATE_VASTUVOTJA.VASTUVOTJA_STAATUS_ID,
    METAXML = UPDATE_VASTUVOTJA.METAXML,
    ASUTUSE_NIMI = UPDATE_VASTUVOTJA.ASUTUSE_NIMI,
    ALLYKSUS_ID = UPDATE_VASTUVOTJA.ALLYKSUS_ID,
    DOK_ID_TEISES_SERVERIS = UPDATE_VASTUVOTJA.DOK_ID_TEISES_SERVERIS,
    ALLYKSUSE_LYHINIMETUS = UPDATE_VASTUVOTJA.ALLYKSUSE_LYHINIMETUS,
    AMETIKOHA_LYHINIMETUS = UPDATE_VASTUVOTJA.AMETIKOHA_LYHINIMETUS
  WHERE VASTUVOTJA_ID = UPDATE_VASTUVOTJA.VASTUVOTJA_ID;
  
END UPDATE_VASTUVOTJA;
/

CREATE OR REPLACE PACKAGE DVKLOG AS 

  -- Enable debugging
  debug_on BOOLEAN := TRUE;
  
  -- Logimise muutujad
  xtee_isikukood VARCHAR2(100);
  xtee_asutus VARCHAR2(100);  

  PROCEDURE LOG_DOKUMENT (
    dokument_new IN dokument%ROWTYPE,
    dokument_old IN dokument%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_TRANSPORT (
    transport_new IN transport%ROWTYPE,
    transport_old IN transport%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_ASUTUS (
    asutus_new IN asutus%ROWTYPE,
    asutus_old IN asutus%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_DOKUMENDI_FRAGMENT (
    dokumendi_fragment_new IN dokumendi_fragment%ROWTYPE,
    dokumendi_fragment_old IN dokumendi_fragment%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_KAUST (
    kaust_new IN kaust%ROWTYPE,
    kaust_old IN kaust%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_SAATJA (
    saatja_new IN saatja%ROWTYPE,
    saatja_old IN saatja%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_STAATUSE_AJALUGU (
    staatuse_ajalugu_new IN staatuse_ajalugu%ROWTYPE,
    staatuse_ajalugu_old IN staatuse_ajalugu%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_VAHENDAJA (
    vahendaja_new IN vahendaja%ROWTYPE,
    vahendaja_old IN vahendaja%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_VASTUVOTJA (
    vastuvotja_new IN vastuvotja%ROWTYPE,
    vastuvotja_old IN vastuvotja%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_ALLKIRI (
    allkiri_new IN allkiri%ROWTYPE,
    allkiri_old IN allkiri%ROWTYPE,
    operation IN VARCHAR2
  );
  
  
  PROCEDURE LOG_ALLYKSUS (
    allyksus_new IN allyksus%ROWTYPE,
    allyksus_old IN allyksus%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_AMETIKOHT (
    ametikoht_new IN ametikoht%ROWTYPE,
    ametikoht_old IN ametikoht%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_AMETIKOHT_TAITMINE (
    ametikoht_taitmine_new IN ametikoht_taitmine%ROWTYPE,
    ametikoht_taitmine_old IN ametikoht_taitmine%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_DOKUMENDI_AJALUGU (
    dokumendi_ajalugu_new IN dokumendi_ajalugu%ROWTYPE,
    dokumendi_ajalugu_old IN dokumendi_ajalugu%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_DOKUMENDI_FAIL (
    dokumendi_fail_new IN dokumendi_fail%ROWTYPE,
    dokumendi_fail_old IN dokumendi_fail%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_DOKUMENDI_METAANDMED (
    dokumendi_metaandmed_new IN dokumendi_metaandmed%ROWTYPE,
    dokumendi_metaandmed_old IN dokumendi_metaandmed%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_DYNAAMILISED_METAANDMED (
    dynaamilised_metaandmed_new IN dynaamilised_metaandmed%ROWTYPE,
    dynaamilised_metaandmed_old IN dynaamilised_metaandmed%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_EHAK (
    ehak_new IN ehak%ROWTYPE,
    ehak_old IN ehak%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_ISIK (
    isik_new IN isik%ROWTYPE,
    isik_old IN isik%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_KLASSIFIKAATOR (
    klassifikaator_new IN klassifikaator%ROWTYPE,
    klassifikaator_old IN klassifikaator%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_KLASSIFIKAATORI_TYYP (
    klassifikaatori_tyyp_new IN klassifikaatori_tyyp%ROWTYPE,
    klassifikaatori_tyyp_old IN klassifikaatori_tyyp%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_KONVERSIOON (
    konversioon_new IN konversioon%ROWTYPE,
    konversioon_old IN konversioon%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_OIGUS_ANTUD (
    oigus_antud_new IN oigus_antud%ROWTYPE,
    oigus_antud_old IN oigus_antud%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_OIGUS_OBJEKTILE (
    oigus_objektile_new IN oigus_objektile%ROWTYPE,
    oigus_objektile_old IN oigus_objektile%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_PARAMEETRID (
    parameetrid_new IN parameetrid%ROWTYPE,
    parameetrid_old IN parameetrid%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_SERVER (
    server_new IN server%ROWTYPE,
    server_old IN server%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_VASTUVOTJA_MALL (
    vastuvotja_mall_new IN vastuvotja_mall%ROWTYPE,
    vastuvotja_mall_old IN vastuvotja_mall%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_VASTUVOTJA_STAATUS (
    vastuvotja_staatus_new IN vastuvotja_staatus%ROWTYPE,
    vastuvotja_staatus_old IN vastuvotja_staatus%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE LOG_LOGI (
    logi_new IN logi%ROWTYPE,
    logi_old IN logi%ROWTYPE,
    operation IN VARCHAR2
  );
  
  PROCEDURE debug (
    message IN VARCHAR2
  );

END DVKLOG;
/


CREATE OR REPLACE PACKAGE BODY DVKLOG AS

  PROCEDURE debug(
    message IN VARCHAR2
  ) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    IF(DVKLOG.debug_on) THEN
      INSERT INTO debug VALUES (message);
    END IF;
    COMMIT;
  END debug;

  PROCEDURE LOG_DOKUMENT(
    dokument_new IN dokument%ROWTYPE,
    dokument_old IN dokument%ROWTYPE,
    operation IN VARCHAR2
  ) AS  
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DOKUMENT';
  
  BEGIN
  
    DEBUG('DVKLOG.LOG_DOKUMENT started...');
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- dokument_id changed
    IF(NVL(dokument_new.dokument_id, 0) != NVL(dokument_old.dokument_id, 0)) THEN    
      DEBUG('dokument_id changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.dokument_id,
        dokument_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(dokument_new.asutus_id, 0) != NVL(dokument_old.asutus_id, 0)) THEN    
      DEBUG('asutus_id changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.asutus_id,
        dokument_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kaust_id changed
    IF(NVL(dokument_new.kaust_id, 0) != NVL(dokument_old.kaust_id, 0)) THEN    
      DEBUG('kaust_id changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('kaust_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.kaust_id,
        dokument_new.kaust_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- sailitustahtaeg changed
    IF(NVL(dokument_new.sailitustahtaeg, sysdate) != NVL(dokument_old.sailitustahtaeg, sysdate)) THEN    
      DEBUG('sailitustahtaeg changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('sailitustahtaeg');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.sailitustahtaeg,
        dokument_new.sailitustahtaeg,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- eelmise_versiooni_id changed
    IF(NVL(dokument_new.eelmise_versiooni_id, 0) != NVL(dokument_old.eelmise_versiooni_id, 0)) THEN    
      DEBUG('eelmise_versiooni_id changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('eelmise_versiooni_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.eelmise_versiooni_id,
        dokument_new.eelmise_versiooni_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- versioon changed
    IF(NVL(dokument_new.versioon, 0) != NVL(dokument_old.versioon, 0)) THEN    
      DEBUG('versioon changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('versioon');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.versioon,
        dokument_new.versioon,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- suurus changed
    IF(NVL(dokument_new.suurus, 0) != NVL(dokument_old.suurus, 0)) THEN    
      DEBUG('suurus changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('suurus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.suurus,
        dokument_new.suurus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- guid changed
    IF(NVL(dokument_new.guid, ' ') != NVL(dokument_old.guid, ' ')) THEN    
      DEBUG('guid changed');
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('guid');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.guid,
        dokument_new.guid,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_DOKUMENT;

  PROCEDURE LOG_TRANSPORT (
    transport_new IN transport%ROWTYPE,
    transport_old IN transport%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'TRANSPORT';
    primary_key_value NUMBER(38,0) := transport_old.transport_id;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- transport_id changed
    IF(NVL(transport_new.transport_id, 0) != NVL(transport_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.transport_id,
        transport_new.transport_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- dokument_id changed
    IF(NVL(transport_new.dokument_id, 0) != NVL(transport_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.dokument_id,
        transport_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- saatmise_algus changed
    IF(NVL(transport_new.saatmise_algus, sysdate) != NVL(transport_old.saatmise_algus, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.saatmise_algus,
        transport_new.saatmise_algus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- saatmise_lopp changed
    IF(NVL(transport_new.saatmise_lopp, sysdate) != NVL(transport_old.saatmise_lopp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.saatmise_lopp,
        transport_new.saatmise_lopp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- staatus_id changed
    IF(NVL(transport_new.staatus_id, 0) != NVL(transport_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        transport_old.staatus_id,
        transport_new.staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_TRANSPORT;

  PROCEDURE LOG_ASUTUS (
    asutus_new IN asutus%ROWTYPE,
    asutus_old IN asutus%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'ASUTUS';
    primary_key_value NUMBER(38,0) := asutus_old.asutus_id;
  
  BEGIN
  
    -- asutus_id changed
    IF(NVL(asutus_new.asutus_id, 0) != NVL(asutus_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutus_id,
        asutus_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- registrikood changed
    IF(NVL(asutus_new.registrikood, ' ') != NVL(asutus_old.registrikood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('registrikood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.registrikood,
        asutus_new.registrikood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- e_registrikood changed
    IF(NVL(asutus_new.e_registrikood, ' ') != NVL(asutus_old.e_registrikood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_registrikood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_registrikood,
        asutus_new.e_registrikood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- ks_asutus_id changed
    IF(NVL(asutus_new.ks_asutus_id, 0) != NVL(asutus_old.ks_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_id,
        asutus_new.ks_asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ks_asutus_kood changed
    IF(NVL(asutus_new.ks_asutus_kood, ' ') != NVL(asutus_old.ks_asutus_kood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_kood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_kood,
        asutus_new.ks_asutus_kood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimetus changed
    IF(NVL(asutus_new.nimetus, ' ') != NVL(asutus_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.nimetus,
        asutus_new.nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- lnimi changed
    IF(NVL(asutus_new.lnimi, ' ') != NVL(asutus_old.lnimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lnimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.lnimi,
        asutus_new.lnimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- liik1 changed
    IF(NVL(asutus_new.liik1, ' ') != NVL(asutus_old.liik1, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik1');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik1,
        asutus_new.liik1,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- liik2 changed
    IF(NVL(asutus_new.liik2, ' ') != NVL(asutus_old.liik2, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik2');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik2,
        asutus_new.liik2,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- tegevusala changed
    IF(NVL(asutus_new.tegevusala, ' ') != NVL(asutus_old.tegevusala, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevusala');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevusala,
        asutus_new.tegevusala,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- tegevuspiirkond changed
    IF(NVL(asutus_new.tegevuspiirkond, ' ') != NVL(asutus_old.tegevuspiirkond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevuspiirkond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevuspiirkond,
        asutus_new.tegevuspiirkond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- maakond changed
    IF(NVL(asutus_new.maakond, ' ') != NVL(asutus_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.maakond,
        asutus_new.maakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asukoht changed
    IF(NVL(asutus_new.asukoht, ' ') != NVL(asutus_old.asukoht, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asukoht');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asukoht,
        asutus_new.asukoht,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aadress changed
    IF(NVL(asutus_new.aadress, ' ') != NVL(asutus_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aadress,
        asutus_new.aadress,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- postikood changed
    IF(NVL(asutus_new.postikood, ' ') != NVL(asutus_old.postikood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('postikood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.postikood,
        asutus_new.postikood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- telefon changed
    IF(NVL(asutus_new.telefon, ' ') != NVL(asutus_old.telefon, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('telefon');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.telefon,
        asutus_new.telefon,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- faks changed
    IF(NVL(asutus_new.faks, ' ') != NVL(asutus_old.faks, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('faks');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.faks,
        asutus_new.faks,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- e_post changed
    IF(NVL(asutus_new.e_post, ' ') != NVL(asutus_old.e_post, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_post');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_post,
        asutus_new.e_post,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- www changed
    IF(NVL(asutus_new.www, ' ') != NVL(asutus_old.www, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('www');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.www,
        asutus_new.www,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- logo changed
    IF(NVL(asutus_new.logo, ' ') != NVL(asutus_old.logo, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('logo');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.logo,
        asutus_new.logo,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutamise_kp changed
    IF(NVL(asutus_new.asutamise_kp, sysdate) != NVL(asutus_old.asutamise_kp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutamise_kp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutamise_kp,
        asutus_new.asutamise_kp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- mood_akt_nimi changed
    IF(NVL(asutus_new.mood_akt_nimi, ' ') != NVL(asutus_old.mood_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nimi,
        asutus_new.mood_akt_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- mood_akt_nr changed
    IF(NVL(asutus_new.mood_akt_nr, ' ') != NVL(asutus_old.mood_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nr,
        asutus_new.mood_akt_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- mood_akt_kp changed
    IF(NVL(asutus_new.mood_akt_kp, sysdate) != NVL(asutus_old.mood_akt_kp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_kp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_kp,
        asutus_new.mood_akt_kp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- pm_akt_nimi changed
    IF(NVL(asutus_new.pm_akt_nimi, ' ') != NVL(asutus_old.pm_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nimi,
        asutus_new.pm_akt_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- pm_akt_nr changed
    IF(NVL(asutus_new.pm_akt_nr, ' ') != NVL(asutus_old.pm_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nr,
        asutus_new.pm_akt_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- pm_kinnitamise_kp changed
    IF(NVL(asutus_new.pm_kinnitamise_kp, sysdate) != NVL(asutus_old.pm_kinnitamise_kp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kinnitamise_kp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kinnitamise_kp,
        asutus_new.pm_kinnitamise_kp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- pm_kande_kp changed
    IF(NVL(asutus_new.pm_kande_kp, sysdate) != NVL(asutus_old.pm_kande_kp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kande_kp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kande_kp,
        asutus_new.pm_kande_kp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(asutus_new.created, sysdate) != NVL(asutus_old.created, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.created,
        asutus_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(asutus_new.last_modified, sysdate) != NVL(asutus_old.last_modified, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.last_modified,
        asutus_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(asutus_new.username, ' ') != NVL(asutus_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.username,
        asutus_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- params changed
    IF(NVL(asutus_new.params, ' ') != NVL(asutus_old.params, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.params,
        asutus_new.params,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dhl_otse_saatmine changed
    IF(NVL(asutus_new.dhl_otse_saatmine, 0) != NVL(asutus_old.dhl_otse_saatmine, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_otse_saatmine');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_otse_saatmine,
        asutus_new.dhl_otse_saatmine,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dhl_saatmine changed
    IF(NVL(asutus_new.dhl_saatmine, 0) != NVL(asutus_old.dhl_saatmine, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_saatmine');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_saatmine,
        asutus_new.dhl_saatmine,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- dhs_nimetus changed
    IF(NVL(asutus_new.dhs_nimetus, ' ') != NVL(asutus_old.dhs_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhs_nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhs_nimetus,
        asutus_new.dhs_nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- toetatav_dvk_versioon changed
    IF(NVL(asutus_new.toetatav_dvk_versioon, ' ') != NVL(asutus_old.toetatav_dvk_versioon, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('toetatav_dvk_versioon');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.toetatav_dvk_versioon,
        asutus_new.toetatav_dvk_versioon,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- server_id changed
    IF(NVL(asutus_new.server_id, 0) != NVL(asutus_old.server_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('server_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.server_id,
        asutus_new.server_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aar_id changed
    IF(NVL(asutus_new.aar_id, 0) != NVL(asutus_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aar_id,
        asutus_new.aar_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_ASUTUS;

  PROCEDURE LOG_DOKUMENDI_FRAGMENT (
    dokumendi_fragment_new IN dokumendi_fragment%ROWTYPE,
    dokumendi_fragment_old IN dokumendi_fragment%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DOKUMENDI_FRAGMENT';
    primary_key_value NUMBER(38,0) := dokumendi_fragment_old.fragment_id;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- fragment_id changed
    IF(NVL(dokumendi_fragment_new.fragment_id, 0) != NVL(dokumendi_fragment_old.fragment_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragment_id,
        dokumendi_fragment_new.fragment_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
            
    -- sissetulev changed
    IF(NVL(dokumendi_fragment_new.sissetulev, 0) != NVL(dokumendi_fragment_old.sissetulev, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('sissetulev');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.sissetulev,
        dokumendi_fragment_new.sissetulev,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(dokumendi_fragment_new.asutus_id, 0) != NVL(dokumendi_fragment_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.asutus_id,
        dokumendi_fragment_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- edastus_id changed
    IF(NVL(dokumendi_fragment_new.edastus_id, ' ') != NVL(dokumendi_fragment_old.edastus_id, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('edastus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.edastus_id,
        dokumendi_fragment_new.edastus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fragment_nr changed
    IF(NVL(dokumendi_fragment_new.fragment_nr, 0) != NVL(dokumendi_fragment_old.fragment_nr, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragment_nr,
        dokumendi_fragment_new.fragment_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fragmente_kokku changed
    IF(NVL(dokumendi_fragment_new.fragmente_kokku, 0) != NVL(dokumendi_fragment_old.fragmente_kokku, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragmente_kokku');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.fragmente_kokku,
        dokumendi_fragment_new.fragmente_kokku,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- loodud changed
    IF(NVL(dokumendi_fragment_new.loodud, sysdate) != NVL(dokumendi_fragment_old.loodud, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('loodud');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fragment_old.loodud,
        dokumendi_fragment_new.loodud,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_DOKUMENDI_FRAGMENT;

  PROCEDURE LOG_KAUST (
    kaust_new IN kaust%ROWTYPE,
    kaust_old IN kaust%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'KAUST';
    primary_key_value NUMBER(38,0) := kaust_old.kaust_id;
  
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
  
    -- kaust_id changed
    IF(NVL(kaust_new.kaust_id, 0) != NVL(kaust_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.kaust_id,
        kaust_new.kaust_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(kaust_new.nimi, ' ') != NVL(kaust_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.nimi,
        kaust_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ylemkaust_id changed
    IF(NVL(kaust_new.ylemkaust_id, 0) != NVL(kaust_old.ylemkaust_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ylemkaust_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.ylemkaust_id,
        kaust_new.ylemkaust_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(kaust_new.asutus_id, 0) != NVL(kaust_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.asutus_id,
        kaust_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kausta_number changed
    IF(NVL(kaust_new.kausta_number, ' ') != NVL(kaust_old.kausta_number, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kausta_number');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        kaust_old.kausta_number,
        kaust_new.kausta_number,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_KAUST;

  PROCEDURE LOG_SAATJA (
    saatja_new IN saatja%ROWTYPE,
    saatja_old IN saatja%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'SAATJA';
    primary_key_value NUMBER(38,0) := saatja_old.saatja_id;
  
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- saatja_id changed
    IF(NVL(saatja_new.saatja_id, 0) != NVL(saatja_old.saatja_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.saatja_id,
        saatja_new.saatja_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- transport_id changed
    IF(NVL(saatja_new.transport_id, 0) != NVL(saatja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.transport_id,
        saatja_new.transport_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(saatja_new.asutus_id, 0) != NVL(saatja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.asutus_id,
        saatja_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(saatja_new.ametikoht_id, 0) != NVL(saatja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.ametikoht_id,
        saatja_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- isikukood changed
    IF(NVL(saatja_new.isikukood, ' ') != NVL(saatja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.isikukood,
        saatja_new.isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(saatja_new.nimi, ' ') != NVL(saatja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.nimi,
        saatja_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- email changed
    IF(NVL(saatja_new.email, ' ') != NVL(saatja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.email,
        saatja_new.email,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nr changed
    IF(NVL(saatja_new.osakonna_nr, ' ') != NVL(saatja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.osakonna_nr,
        saatja_new.osakonna_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nimi changed
    IF(NVL(saatja_new.osakonna_nimi, ' ') != NVL(saatja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.osakonna_nimi,
        saatja_new.osakonna_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutuse_nimi changed
    IF(NVL(saatja_new.asutuse_nimi, ' ') != NVL(saatja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.asutuse_nimi,
        saatja_new.asutuse_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus_id changed
    IF(NVL(saatja_new.allyksus_id, 0) != NVL(saatja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.allyksus_id,
        saatja_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksuse_lyhinimetus changed
    IF(NVL(saatja_new.allyksuse_lyhinimetus, ' ') != NVL(saatja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.allyksuse_lyhinimetus,
        saatja_new.allyksuse_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoha_lyhinimetus changed
    IF(NVL(saatja_new.ametikoha_lyhinimetus, ' ') != NVL(saatja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        saatja_old.ametikoha_lyhinimetus,
        saatja_new.ametikoha_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_SAATJA;

  PROCEDURE LOG_STAATUSE_AJALUGU (
    staatuse_ajalugu_new IN staatuse_ajalugu%ROWTYPE,
    staatuse_ajalugu_old IN staatuse_ajalugu%ROWTYPE,
    operation IN VARCHAR2
  ) AS
    
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'STAATUSE_AJALUGU';
    primary_key_value NUMBER(38,0) := staatuse_ajalugu_old.staatuse_ajalugu_id;
  
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
         
    -- staatuse_ajalugu_id changed
    IF(NVL(staatuse_ajalugu_new.staatuse_ajalugu_id, 0) != NVL(staatuse_ajalugu_old.staatuse_ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_ajalugu_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatuse_ajalugu_id,
        staatuse_ajalugu_new.staatuse_ajalugu_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
            
    -- vastuvotja_id changed
    IF(NVL(staatuse_ajalugu_new.vastuvotja_id, 0) != NVL(staatuse_ajalugu_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.vastuvotja_id,
        staatuse_ajalugu_new.vastuvotja_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- staatus_id changed
    IF(NVL(staatuse_ajalugu_new.staatus_id, 0) != NVL(staatuse_ajalugu_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatus_id,
        staatuse_ajalugu_new.staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
            
    -- staatuse_muutmise_aeg changed
    IF(NVL(staatuse_ajalugu_new.staatuse_muutmise_aeg, sysdate) != NVL(staatuse_ajalugu_old.staatuse_muutmise_aeg, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_muutmise_aeg');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.staatuse_muutmise_aeg,
        staatuse_ajalugu_new.staatuse_muutmise_aeg,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_code changed
    IF(NVL(staatuse_ajalugu_new.fault_code, ' ') != NVL(staatuse_ajalugu_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_code,
        staatuse_ajalugu_new.fault_code,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_actor changed
    IF(NVL(staatuse_ajalugu_new.fault_actor, ' ') != NVL(staatuse_ajalugu_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_actor,
        staatuse_ajalugu_new.fault_actor,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_string changed
    IF(NVL(staatuse_ajalugu_new.fault_string, ' ') != NVL(staatuse_ajalugu_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_string,
        staatuse_ajalugu_new.fault_string,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_detail changed
    IF(NVL(staatuse_ajalugu_new.fault_detail, ' ') != NVL(staatuse_ajalugu_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.fault_detail,
        staatuse_ajalugu_new.fault_detail,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vastuvotja_staatus_id changed
    IF(NVL(staatuse_ajalugu_new.vastuvotja_staatus_id, 0) != NVL(staatuse_ajalugu_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        staatuse_ajalugu_old.vastuvotja_staatus_id,
        staatuse_ajalugu_new.vastuvotja_staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
            
  END LOG_STAATUSE_AJALUGU;

  PROCEDURE LOG_VAHENDAJA (
    vahendaja_new IN vahendaja%ROWTYPE,
    vahendaja_old IN vahendaja%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'VAHENDAJA';
    primary_key_value NUMBER(38,0) := vahendaja_old.vahendaja_id;
  
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
  
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- vahendaja_id changed
    IF(NVL(vahendaja_new.vahendaja_id, 0) != NVL(vahendaja_old.vahendaja_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vahendaja_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.vahendaja_id,
        vahendaja_new.vahendaja_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- transport_id changed
    IF(NVL(vahendaja_new.transport_id, 0) != NVL(vahendaja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.transport_id,
        vahendaja_new.transport_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(vahendaja_new.asutus_id, 0) != NVL(vahendaja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.asutus_id,
        vahendaja_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(vahendaja_new.ametikoht_id, 0) != NVL(vahendaja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.ametikoht_id,
        vahendaja_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    
    -- isikukood changed
    IF(NVL(vahendaja_new.isikukood, ' ') != NVL(vahendaja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.isikukood,
        vahendaja_new.isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(vahendaja_new.nimi, ' ') != NVL(vahendaja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.nimi,
        vahendaja_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- email changed
    IF(NVL(vahendaja_new.email, ' ') != NVL(vahendaja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.email,
        vahendaja_new.email,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nr changed
    IF(NVL(vahendaja_new.osakonna_nr, ' ') != NVL(vahendaja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.osakonna_nr,
        vahendaja_new.osakonna_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nimi changed
    IF(NVL(vahendaja_new.osakonna_nimi, ' ') != NVL(vahendaja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.osakonna_nimi,
        vahendaja_new.osakonna_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutuse_nimi changed
    IF(NVL(vahendaja_new.asutuse_nimi, ' ') != NVL(vahendaja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.asutuse_nimi,
        vahendaja_new.asutuse_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;    
    
    -- allyksus_id changed
    IF(NVL(vahendaja_new.allyksus_id, 0) != NVL(vahendaja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.allyksus_id,
        vahendaja_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- allyksuse_lyhinimetus changed
    IF(NVL(vahendaja_new.allyksuse_lyhinimetus, ' ') != NVL(vahendaja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.allyksuse_lyhinimetus,
        vahendaja_new.allyksuse_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoha_lyhinimetus changed
    IF(NVL(vahendaja_new.ametikoha_lyhinimetus, ' ') != NVL(vahendaja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vahendaja_old.ametikoha_lyhinimetus,
        vahendaja_new.ametikoha_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END;
  
  PROCEDURE LOG_VASTUVOTJA (
    vastuvotja_new IN vastuvotja%ROWTYPE,
    vastuvotja_old IN vastuvotja%ROWTYPE,
    operation IN VARCHAR2
  ) AS
    
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'VASTUVOTJA';
    primary_key_value NUMBER(38,0) := vastuvotja_old.vastuvotja_id;
  
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- vastuvotja_id changed
    IF(NVL(vastuvotja_new.vastuvotja_id, 0) != NVL(vastuvotja_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.vastuvotja_id,
        vastuvotja_new.vastuvotja_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- transport_id changed
    IF(NVL(vastuvotja_new.transport_id, 0) != NVL(vastuvotja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.transport_id,
        vastuvotja_new.transport_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(vastuvotja_new.asutus_id, 0) != NVL(vastuvotja_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.asutus_id,
        vastuvotja_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(vastuvotja_new.ametikoht_id, 0) != NVL(vastuvotja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.ametikoht_id,
        vastuvotja_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- isikukood changed
    IF(NVL(vastuvotja_new.isikukood, ' ') != NVL(vastuvotja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.isikukood,
        vastuvotja_new.isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(vastuvotja_new.nimi, ' ') != NVL(vastuvotja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.nimi,
        vastuvotja_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- email changed
    IF(NVL(vastuvotja_new.email, ' ') != NVL(vastuvotja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.email,
        vastuvotja_new.email,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nr changed
    IF(NVL(vastuvotja_new.osakonna_nr, ' ') != NVL(vastuvotja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.osakonna_nr,
        vastuvotja_new.osakonna_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nimi changed
    IF(NVL(vastuvotja_new.osakonna_nimi, ' ') != NVL(vastuvotja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.osakonna_nimi,
        vastuvotja_new.osakonna_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatmisviis_id changed
    IF(NVL(vastuvotja_new.saatmisviis_id, 0) != NVL(vastuvotja_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmisviis_id,
        vastuvotja_new.saatmisviis_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- staatus_id changed
    IF(NVL(vastuvotja_new.staatus_id, 0) != NVL(vastuvotja_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.staatus_id,
        vastuvotja_new.staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatmise_algus changed
    IF(NVL(vastuvotja_new.saatmise_algus, sysdate) != NVL(vastuvotja_old.saatmise_algus, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmise_algus,
        vastuvotja_new.saatmise_algus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatmise_lopp changed
    IF(NVL(vastuvotja_new.saatmise_lopp, sysdate) != NVL(vastuvotja_old.saatmise_lopp, sysdate)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.saatmise_lopp,
        vastuvotja_new.saatmise_lopp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_code changed
    IF(NVL(vastuvotja_new.fault_code, ' ') != NVL(vastuvotja_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_code,
        vastuvotja_new.fault_code,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_actor changed
    IF(NVL(vastuvotja_new.fault_actor, ' ') != NVL(vastuvotja_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_actor,
        vastuvotja_new.fault_actor,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_string changed
    IF(NVL(vastuvotja_new.fault_string, ' ') != NVL(vastuvotja_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_string,
        vastuvotja_new.fault_string,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- fault_detail changed
    IF(NVL(vastuvotja_new.fault_detail, ' ') != NVL(vastuvotja_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.fault_detail,
        vastuvotja_new.fault_detail,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vastuvotja_staatus_id changed
    IF(NVL(vastuvotja_new.vastuvotja_staatus_id, 0) != NVL(vastuvotja_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.vastuvotja_staatus_id,
        vastuvotja_new.vastuvotja_staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutuse_nimi changed
    IF(NVL(vastuvotja_new.asutuse_nimi, ' ') != NVL(vastuvotja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.asutuse_nimi,
        vastuvotja_new.asutuse_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus_id changed
    IF(NVL(vastuvotja_new.allyksus_id, 0) != NVL(vastuvotja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.allyksus_id,
        vastuvotja_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dok_id_teises_serveris changed
    IF(NVL(vastuvotja_new.dok_id_teises_serveris, 0) != NVL(vastuvotja_old.dok_id_teises_serveris, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dok_id_teises_serveris');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.dok_id_teises_serveris,
        vastuvotja_new.dok_id_teises_serveris,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksuse_lyhinimetus changed
    IF(NVL(vastuvotja_new.allyksuse_lyhinimetus, ' ') != NVL(vastuvotja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.allyksuse_lyhinimetus,
        vastuvotja_new.allyksuse_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoha_lyhinimetus changed
    IF(NVL(vastuvotja_new.ametikoha_lyhinimetus, ' ') != NVL(vastuvotja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_old.ametikoha_lyhinimetus,
        vastuvotja_new.ametikoha_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_VASTUVOTJA;

  PROCEDURE LOG_ALLKIRI (
    allkiri_new IN allkiri%ROWTYPE,
    allkiri_old IN allkiri%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'VASTUVOTJA';
    primary_key_value NUMBER(38,0) := allkiri_old.allkiri_id;
    
    d DATE := sysdate;
    
  BEGIN
  
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    
    -- allkiri_id changed
    IF(NVL(allkiri_new.allkiri_id, 0) != NVL(allkiri_old.allkiri_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allkiri_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.allkiri_id,
        allkiri_new.allkiri_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dokument_id changed
    IF(NVL(allkiri_new.dokument_id, 0) != NVL(allkiri_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.dokument_id,
        allkiri_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- eesnimi changed
    IF(NVL(allkiri_new.eesnimi, ' ') != NVL(allkiri_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.eesnimi,
        allkiri_new.eesnimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- perenimi changed
    IF(NVL(allkiri_new.perenimi, ' ') != NVL(allkiri_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.perenimi,
        allkiri_new.perenimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- isikukood changed
    IF(NVL(allkiri_new.isikukood, ' ') != NVL(allkiri_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.isikukood,
        allkiri_new.isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kuupaev changed
    IF(NVL(allkiri_new.kuupaev, d) != NVL(allkiri_old.kuupaev, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuupaev');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.kuupaev,
        allkiri_new.kuupaev,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- roll changed
    IF(NVL(allkiri_new.roll, ' ') != NVL(allkiri_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.roll,
        allkiri_new.roll,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- riik changed
    IF(NVL(allkiri_new.riik, ' ') != NVL(allkiri_old.riik, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('riik');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.riik,
        allkiri_new.riik,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- maakond changed
    IF(NVL(allkiri_new.maakond, ' ') != NVL(allkiri_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.maakond,
        allkiri_new.maakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- linn changed
    IF(NVL(allkiri_new.linn, ' ') != NVL(allkiri_old.linn, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('linn');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.linn,
        allkiri_new.linn,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- indeks changed
    IF(NVL(allkiri_new.indeks, ' ') != NVL(allkiri_old.indeks, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('indeks');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allkiri_old.indeks,
        allkiri_new.indeks,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_ALLKIRI;

  PROCEDURE LOG_ALLYKSUS (
    allyksus_new IN allyksus%ROWTYPE,
    allyksus_old IN allyksus%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'ALLYKSUS';
    primary_key_value NUMBER(38,0) := allyksus_old.id;
    
    d DATE := sysdate;
    
  BEGIN
  
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- id changed
    IF(NVL(allyksus_new.id, 0) != NVL(allyksus_old.id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.id,
        allyksus_new.id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- asutus_id changed
    IF(NVL(allyksus_new.asutus_id, 0) != NVL(allyksus_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.asutus_id,
        allyksus_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vanem_id changed
    IF(NVL(allyksus_new.vanem_id, 0) != NVL(allyksus_old.vanem_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vanem_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.vanem_id,
        allyksus_new.vanem_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus changed
    IF(NVL(allyksus_new.allyksus, ' ') != NVL(allyksus_old.allyksus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.allyksus,
        allyksus_new.allyksus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(allyksus_new.created, d) != NVL(allyksus_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.created,
        allyksus_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(allyksus_new.last_modified, d) != NVL(allyksus_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.last_modified,
        allyksus_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(allyksus_new.username, ' ') != NVL(allyksus_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.username,
        allyksus_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- muutm_arv changed
    IF(NVL(allyksus_new.muutm_arv, 0) != NVL(allyksus_old.muutm_arv, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutm_arv');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.muutm_arv,
        allyksus_new.muutm_arv,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aar_id changed
    IF(NVL(allyksus_new.aar_id, 0) != NVL(allyksus_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.aar_id,
        allyksus_new.aar_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- lyhinimetus changed
    IF(NVL(allyksus_new.lyhinimetus, ' ') != NVL(allyksus_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.lyhinimetus,
        allyksus_new.lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- adr_uri changed
    IF(NVL(allyksus_new.adr_uri, ' ') != NVL(allyksus_old.adr_uri, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('adr_uri');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        allyksus_old.adr_uri,
        allyksus_new.adr_uri,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_ALLYKSUS;

  PROCEDURE LOG_AMETIKOHT (
    ametikoht_new IN ametikoht%ROWTYPE,
    ametikoht_old IN ametikoht%ROWTYPE,
    operation IN VARCHAR2
  ) AS
    
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'AMETIKOHT';
    primary_key_value NUMBER(38,0) := ametikoht_old.ametikoht_id;
    
    d DATE := sysdate;
    
  BEGIN
  
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    
    -- ametikoht_id changed
    IF(NVL(ametikoht_new.ametikoht_id, 0) != NVL(ametikoht_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ametikoht_id,
        ametikoht_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ks_ametikoht_id changed
    IF(NVL(ametikoht_new.ks_ametikoht_id, 0) != NVL(ametikoht_old.ks_ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ks_ametikoht_id,
        ametikoht_new.ks_ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(ametikoht_new.asutus_id, 0) != NVL(ametikoht_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.asutus_id,
        ametikoht_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_nimetus changed
    IF(NVL(ametikoht_new.ametikoht_nimetus, ' ') != NVL(ametikoht_old.ametikoht_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.ametikoht_nimetus,
        ametikoht_new.ametikoht_nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- alates changed
    IF(NVL(ametikoht_new.alates, d) != NVL(ametikoht_old.alates, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.alates,
        ametikoht_new.alates,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kuni changed
    IF(NVL(ametikoht_new.kuni, d) != NVL(ametikoht_old.kuni, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.kuni,
        ametikoht_new.kuni,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(ametikoht_new.created, d) != NVL(ametikoht_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.created,
        ametikoht_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(ametikoht_new.last_modified, d) != NVL(ametikoht_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.last_modified,
        ametikoht_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(ametikoht_new.username, ' ') != NVL(ametikoht_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.username,
        ametikoht_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus_id changed
    IF(NVL(ametikoht_new.allyksus_id, 0) != NVL(ametikoht_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.allyksus_id,
        ametikoht_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- params changed
    IF(NVL(ametikoht_new.params, ' ') != NVL(ametikoht_old.params, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.params,
        ametikoht_new.params,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aar_id changed
    IF(NVL(ametikoht_new.aar_id, 0) != NVL(ametikoht_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.aar_id,
        ametikoht_new.aar_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- lyhinimetus changed
    IF(NVL(ametikoht_new.lyhinimetus, ' ') != NVL(ametikoht_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_old.lyhinimetus,
        ametikoht_new.lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_AMETIKOHT;


  PROCEDURE LOG_AMETIKOHT_TAITMINE (
    ametikoht_taitmine_new IN ametikoht_taitmine%ROWTYPE,
    ametikoht_taitmine_old IN ametikoht_taitmine%ROWTYPE,
    operation IN VARCHAR2
  ) AS
    
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'AMETIKOHT_TAITMINE';
    primary_key_value NUMBER(38,0) := ametikoht_taitmine_old.taitmine_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- taitmine_id changed
    IF(NVL(ametikoht_taitmine_new.taitmine_id, 0) != NVL(ametikoht_taitmine_old.taitmine_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('taitmine_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.taitmine_id,
        ametikoht_taitmine_new.taitmine_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(ametikoht_taitmine_new.ametikoht_id, 0) != NVL(ametikoht_taitmine_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.ametikoht_id,
        ametikoht_taitmine_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- i_id changed
    IF(NVL(ametikoht_taitmine_new.i_id, 0) != NVL(ametikoht_taitmine_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.i_id,
        ametikoht_taitmine_new.i_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- alates changed
    IF(NVL(ametikoht_taitmine_new.alates, d) != NVL(ametikoht_taitmine_old.alates, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.alates,
        ametikoht_taitmine_new.alates,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kuni changed
    IF(NVL(ametikoht_taitmine_new.kuni, d) != NVL(ametikoht_taitmine_old.kuni, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.kuni,
        ametikoht_taitmine_new.kuni,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- roll changed
    IF(NVL(ametikoht_taitmine_new.roll, ' ') != NVL(ametikoht_taitmine_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.roll,
        ametikoht_taitmine_new.roll,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(ametikoht_taitmine_new.created, d) != NVL(ametikoht_taitmine_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.created,
        ametikoht_taitmine_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(ametikoht_taitmine_new.last_modified, d) != NVL(ametikoht_taitmine_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.last_modified,
        ametikoht_taitmine_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(ametikoht_taitmine_new.username, ' ') != NVL(ametikoht_taitmine_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.username,
        ametikoht_taitmine_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- peatatud changed
    IF(NVL(ametikoht_taitmine_new.peatatud, 0) != NVL(ametikoht_taitmine_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.peatatud,
        ametikoht_taitmine_new.peatatud,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aar_id changed
    IF(NVL(ametikoht_taitmine_new.aar_id, 0) != NVL(ametikoht_taitmine_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ametikoht_taitmine_old.aar_id,
        ametikoht_taitmine_new.aar_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_AMETIKOHT_TAITMINE;

  PROCEDURE LOG_DOKUMENDI_AJALUGU (
    dokumendi_ajalugu_new IN dokumendi_ajalugu%ROWTYPE,
    dokumendi_ajalugu_old IN dokumendi_ajalugu%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DOKUMENDI_AJALUGU';
    primary_key_value NUMBER(38,0) := dokumendi_ajalugu_old.ajalugu_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
    
    -- ajalugu_id changed
    IF(NVL(dokumendi_ajalugu_new.ajalugu_id, 0) != NVL(dokumendi_ajalugu_old.ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ajalugu_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_ajalugu_old.ajalugu_id,
        dokumendi_ajalugu_new.ajalugu_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dokument_id changed
    IF(NVL(dokumendi_ajalugu_new.dokument_id, 0) != NVL(dokumendi_ajalugu_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_ajalugu_old.dokument_id,
        dokumendi_ajalugu_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_DOKUMENDI_AJALUGU;

  PROCEDURE LOG_DOKUMENDI_FAIL (
    dokumendi_fail_new IN dokumendi_fail%ROWTYPE,
    dokumendi_fail_old IN dokumendi_fail%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DOKUMENDI_FAIL';
    primary_key_value NUMBER(38,0) := dokumendi_fail_old.fail_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- fail_id changed
    IF(NVL(dokumendi_fail_new.fail_id, 0) != NVL(dokumendi_fail_old.fail_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fail_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.fail_id,
        dokumendi_fail_new.fail_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dokument_id changed
    IF(NVL(dokumendi_fail_new.dokument_id, 0) != NVL(dokumendi_fail_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.dokument_id,
        dokumendi_fail_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(dokumendi_fail_new.nimi, ' ') != NVL(dokumendi_fail_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.nimi,
        dokumendi_fail_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- suurus changed
    IF(NVL(dokumendi_fail_new.suurus, 0) != NVL(dokumendi_fail_old.suurus, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('suurus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.suurus,
        dokumendi_fail_new.suurus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- mime_tyyp changed
    IF(NVL(dokumendi_fail_new.mime_tyyp, ' ') != NVL(dokumendi_fail_old.mime_tyyp, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mime_tyyp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.mime_tyyp,
        dokumendi_fail_new.mime_tyyp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- pohifail changed
    IF(NVL(dokumendi_fail_new.pohifail, 0) != NVL(dokumendi_fail_old.pohifail, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pohifail');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.pohifail,
        dokumendi_fail_new.pohifail,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- valine_manus changed
    IF(NVL(dokumendi_fail_new.valine_manus, 0) != NVL(dokumendi_fail_old.valine_manus, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('valine_manus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_fail_old.valine_manus,
        dokumendi_fail_new.valine_manus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_DOKUMENDI_FAIL;

  PROCEDURE LOG_DOKUMENDI_METAANDMED (
    dokumendi_metaandmed_new IN dokumendi_metaandmed%ROWTYPE,
    dokumendi_metaandmed_old IN dokumendi_metaandmed%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DOKUMENDI_METAANDMED';
    primary_key_value NUMBER(38,0) := dokumendi_metaandmed_old.dokument_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- dokument_id changed
    IF(NVL(dokumendi_metaandmed_new.dokument_id, 0) != NVL(dokumendi_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.dokument_id,
        dokumendi_metaandmed_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_asutuse_nr changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_asutuse_nr, ' ') != NVL(dokumendi_metaandmed_old.koostaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_nr,
        dokumendi_metaandmed_new.koostaja_asutuse_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saaja_asutuse_nr changed
    IF(NVL(dokumendi_metaandmed_new.saaja_asutuse_nr, ' ') != NVL(dokumendi_metaandmed_old.saaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_asutuse_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_asutuse_nr,
        dokumendi_metaandmed_new.saaja_asutuse_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_dokumendinimi changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_dokumendinimi, ' ') != NVL(dokumendi_metaandmed_old.koostaja_dokumendinimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendinimi,
        dokumendi_metaandmed_new.koostaja_dokumendinimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_dokumendityyp changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_dokumendityyp, ' ') != NVL(dokumendi_metaandmed_old.koostaja_dokumendityyp, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendityyp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendityyp,
        dokumendi_metaandmed_new.koostaja_dokumendityyp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_dokumendinr changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_dokumendinr, ' ') != NVL(dokumendi_metaandmed_old.koostaja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_dokumendinr,
        dokumendi_metaandmed_new.koostaja_dokumendinr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_failinimi changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_failinimi, ' ') != NVL(dokumendi_metaandmed_old.koostaja_failinimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_failinimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_failinimi,
        dokumendi_metaandmed_new.koostaja_failinimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_kataloog changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_kataloog, ' ') != NVL(dokumendi_metaandmed_old.koostaja_kataloog, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kataloog');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kataloog,
        dokumendi_metaandmed_new.koostaja_kataloog,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_votmesona changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_votmesona, ' ') != NVL(dokumendi_metaandmed_old.koostaja_votmesona, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_votmesona');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_votmesona,
        dokumendi_metaandmed_new.koostaja_votmesona,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_kokkuvote changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_kokkuvote, ' ') != NVL(dokumendi_metaandmed_old.koostaja_kokkuvote, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kokkuvote');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kokkuvote,
        dokumendi_metaandmed_new.koostaja_kokkuvote,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_kuupaev changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_kuupaev, d) != NVL(dokumendi_metaandmed_old.koostaja_kuupaev, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kuupaev');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_kuupaev,
        dokumendi_metaandmed_new.koostaja_kuupaev,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_asutuse_nimi changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_asutuse_nimi, ' ') != NVL(dokumendi_metaandmed_old.koostaja_asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_nimi,
        dokumendi_metaandmed_new.koostaja_asutuse_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- koostaja_asutuse_kontakt changed
    IF(NVL(dokumendi_metaandmed_new.koostaja_asutuse_kontakt, ' ') != NVL(dokumendi_metaandmed_old.koostaja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_kontakt');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.koostaja_asutuse_kontakt,
        dokumendi_metaandmed_new.koostaja_asutuse_kontakt,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- autori_osakond changed
    IF(NVL(dokumendi_metaandmed_new.autori_osakond, ' ') != NVL(dokumendi_metaandmed_old.autori_osakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_osakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_osakond,
        dokumendi_metaandmed_new.autori_osakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- autori_isikukood changed
    IF(NVL(dokumendi_metaandmed_new.autori_isikukood, ' ') != NVL(dokumendi_metaandmed_old.autori_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_isikukood,
        dokumendi_metaandmed_new.autori_isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- autori_nimi changed
    IF(NVL(dokumendi_metaandmed_new.autori_nimi, ' ') != NVL(dokumendi_metaandmed_old.autori_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_nimi,
        dokumendi_metaandmed_new.autori_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- autori_kontakt changed
    IF(NVL(dokumendi_metaandmed_new.autori_kontakt, ' ') != NVL(dokumendi_metaandmed_old.autori_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_kontakt');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.autori_kontakt,
        dokumendi_metaandmed_new.autori_kontakt,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- seotud_dokumendinr_koostajal changed
    IF(NVL(dokumendi_metaandmed_new.seotud_dokumendinr_koostajal, ' ') != NVL(dokumendi_metaandmed_old.seotud_dokumendinr_koostajal, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_koostajal');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dokumendinr_koostajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_koostajal,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- seotud_dokumendinr_saajal changed
    IF(NVL(dokumendi_metaandmed_new.seotud_dokumendinr_saajal, ' ') != NVL(dokumendi_metaandmed_old.seotud_dokumendinr_saajal, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_saajal');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dokumendinr_saajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_saajal,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatja_dokumendinr changed
    IF(NVL(dokumendi_metaandmed_new.saatja_dokumendinr, ' ') != NVL(dokumendi_metaandmed_old.saatja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_dokumendinr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_dokumendinr,
        dokumendi_metaandmed_new.saatja_dokumendinr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatja_kuupaev changed
    IF(NVL(dokumendi_metaandmed_new.saatja_kuupaev, d) != NVL(dokumendi_metaandmed_old.saatja_kuupaev, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_kuupaev');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_kuupaev,
        dokumendi_metaandmed_new.saatja_kuupaev,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatja_asutuse_kontakt changed
    IF(NVL(dokumendi_metaandmed_new.saatja_asutuse_kontakt, ' ') != NVL(dokumendi_metaandmed_old.saatja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_asutuse_kontakt');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saatja_asutuse_kontakt,
        dokumendi_metaandmed_new.saatja_asutuse_kontakt,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saaja_isikukood changed
    IF(NVL(dokumendi_metaandmed_new.saaja_isikukood, ' ') != NVL(dokumendi_metaandmed_old.saaja_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_isikukood,
        dokumendi_metaandmed_new.saaja_isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saaja_nimi changed
    IF(NVL(dokumendi_metaandmed_new.saaja_nimi, ' ') != NVL(dokumendi_metaandmed_old.saaja_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_nimi,
        dokumendi_metaandmed_new.saaja_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saaja_osakond changed
    IF(NVL(dokumendi_metaandmed_new.saaja_osakond, ' ') != NVL(dokumendi_metaandmed_old.saaja_osakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_osakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.saaja_osakond,
        dokumendi_metaandmed_new.saaja_osakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- seotud_dhl_id changed
    IF(NVL(dokumendi_metaandmed_new.seotud_dhl_id, 0) != NVL(dokumendi_metaandmed_old.seotud_dhl_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dhl_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.seotud_dhl_id,
        dokumendi_metaandmed_new.seotud_dhl_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kommentaar changed
    IF(NVL(dokumendi_metaandmed_new.kommentaar, ' ') != NVL(dokumendi_metaandmed_old.kommentaar, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kommentaar');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokumendi_metaandmed_old.kommentaar,
        dokumendi_metaandmed_new.kommentaar,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_DOKUMENDI_METAANDMED;

  PROCEDURE LOG_DYNAAMILISED_METAANDMED (
    dynaamilised_metaandmed_new IN dynaamilised_metaandmed%ROWTYPE,
    dynaamilised_metaandmed_old IN dynaamilised_metaandmed%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'DYNAAMILISED_METAANDMED';
    primary_key_value NUMBER(38,0) := dynaamilised_metaandmed_old.dokument_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- dokument_id changed
    IF(NVL(dynaamilised_metaandmed_new.dokument_id, 0) != NVL(dynaamilised_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.dokument_id,
        dynaamilised_metaandmed_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(dynaamilised_metaandmed_new.nimi, ' ') != NVL(dynaamilised_metaandmed_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.nimi,
        dynaamilised_metaandmed_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vaartus changed
    IF(NVL(dynaamilised_metaandmed_new.vaartus, ' ') != NVL(dynaamilised_metaandmed_old.vaartus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vaartus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.vaartus,
        dynaamilised_metaandmed_new.vaartus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_DYNAAMILISED_METAANDMED;

  PROCEDURE LOG_EHAK (
    ehak_new IN ehak%ROWTYPE,
    ehak_old IN ehak%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'EHAK';
    primary_key_value NUMBER(38,0) := ehak_old.ehak_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- ehak_id changed
    IF(NVL(ehak_new.ehak_id, ' ') != NVL(ehak_old.ehak_id, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ehak_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.ehak_id,
        ehak_new.ehak_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(ehak_new.nimi, ' ') != NVL(ehak_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.nimi,
        ehak_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- roopnimi changed
    IF(NVL(ehak_new.roopnimi, ' ') != NVL(ehak_old.roopnimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roopnimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.roopnimi,
        ehak_new.roopnimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- tyyp changed
    IF(NVL(ehak_new.tyyp, ' ') != NVL(ehak_old.tyyp, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tyyp');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.tyyp,
        ehak_new.tyyp,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- maakond changed
    IF(NVL(ehak_new.maakond, ' ') != NVL(ehak_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.maakond,
        ehak_new.maakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vald changed
    IF(NVL(ehak_new.vald, ' ') != NVL(ehak_old.vald, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vald');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.vald,
        ehak_new.vald,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(ehak_new.created, d) != NVL(ehak_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.created,
        ehak_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(ehak_new.last_modified, d) != NVL(ehak_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.last_modified,
        ehak_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(ehak_new.username, ' ') != NVL(ehak_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        ehak_old.username,
        ehak_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_EHAK;

  PROCEDURE LOG_ISIK (
    isik_new IN isik%ROWTYPE,
    isik_old IN isik%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'ISIK';
    primary_key_value NUMBER(38,0) := isik_old.i_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;

    -- i_id changed
    IF(NVL(isik_new.i_id, 0) != NVL(isik_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.i_id,
        isik_new.i_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kood changed
    IF(NVL(isik_new.kood, ' ') != NVL(isik_old.kood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.kood,
        isik_new.kood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- perenimi changed
    IF(NVL(isik_new.perenimi, ' ') != NVL(isik_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.perenimi,
        isik_new.perenimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- eesnimi changed
    IF(NVL(isik_new.eesnimi, ' ') != NVL(isik_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.eesnimi,
        isik_new.eesnimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- maakond changed
    IF(NVL(isik_new.maakond, ' ') != NVL(isik_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.maakond,
        isik_new.maakond,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aadress changed
    IF(NVL(isik_new.aadress, ' ') != NVL(isik_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.aadress,
        isik_new.aadress,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- postikood changed
    IF(NVL(isik_new.postikood, ' ') != NVL(isik_old.postikood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('postikood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.postikood,
        isik_new.postikood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- telefon changed
    IF(NVL(isik_new.telefon, ' ') != NVL(isik_old.telefon, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('telefon');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.telefon,
        isik_new.telefon,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- e_post changed
    IF(NVL(isik_new.e_post, ' ') != NVL(isik_old.e_post, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_post');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.e_post,
        isik_new.e_post,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- www changed
    IF(NVL(isik_new.www, ' ') != NVL(isik_old.www, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('www');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.www,
        isik_new.www,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- params changed
    IF(NVL(isik_new.params, ' ') != NVL(isik_old.params, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.params,
        isik_new.params,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(isik_new.created, d) != NVL(isik_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.created,
        isik_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(isik_new.last_modified, d) != NVL(isik_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.last_modified,
        isik_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(isik_new.username, ' ') != NVL(isik_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        isik_old.username,
        isik_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;

  END LOG_ISIK;

  PROCEDURE LOG_KLASSIFIKAATOR (
    klassifikaator_new IN klassifikaator%ROWTYPE,
    klassifikaator_old IN klassifikaator%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'KLASSIFIKAATOR';
    primary_key_value NUMBER(38,0) := klassifikaator_old.klassifikaator_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- klassifikaator_id changed
    IF(NVL(klassifikaator_new.klassifikaator_id, 0) != NVL(klassifikaator_old.klassifikaator_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaator_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.klassifikaator_id,
        klassifikaator_new.klassifikaator_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimetus changed
    IF(NVL(klassifikaator_new.nimetus, ' ') != NVL(klassifikaator_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.nimetus,
        klassifikaator_new.nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- klassifikaatori_tyyp_id changed
    IF(NVL(klassifikaator_new.klassifikaatori_tyyp_id, 0) != NVL(klassifikaator_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaator_old.klassifikaatori_tyyp_id,
        klassifikaator_new.klassifikaatori_tyyp_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_KLASSIFIKAATOR;

  PROCEDURE LOG_KLASSIFIKAATORI_TYYP (
    klassifikaatori_tyyp_new IN klassifikaatori_tyyp%ROWTYPE,
    klassifikaatori_tyyp_old IN klassifikaatori_tyyp%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'KLASSIFIKAATORI_TYYP';
    primary_key_value NUMBER(38,0) := klassifikaatori_tyyp_old.klassifikaatori_tyyp_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- klassifikaatori_tyyp_id changed
    IF(NVL(klassifikaatori_tyyp_new.klassifikaatori_tyyp_id, 0) != NVL(klassifikaatori_tyyp_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaatori_tyyp_old.klassifikaatori_tyyp_id,
        klassifikaatori_tyyp_new.klassifikaatori_tyyp_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimetus changed
    IF(NVL(klassifikaatori_tyyp_new.nimetus, ' ') != NVL(klassifikaatori_tyyp_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        klassifikaatori_tyyp_old.nimetus,
        klassifikaatori_tyyp_new.nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_KLASSIFIKAATORI_TYYP;

  PROCEDURE LOG_KONVERSIOON (
    konversioon_new IN konversioon%ROWTYPE,
    konversioon_old IN konversioon%ROWTYPE,
    operation IN VARCHAR2
  ) AS 
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'KONVERSIOON';
    primary_key_value NUMBER(38,0) := konversioon_old.id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- id changed
    IF(NVL(konversioon_new.id, 0) != NVL(konversioon_old.id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.id,
        konversioon_new.id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- version changed
    IF(NVL(konversioon_new.version, 0) != NVL(konversioon_old.version, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('version');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.version,
        konversioon_new.version,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- result_version changed
    IF(NVL(konversioon_new.result_version, 0) != NVL(konversioon_old.result_version, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('result_version');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        konversioon_old.result_version,
        konversioon_new.result_version,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_KONVERSIOON;

  PROCEDURE LOG_OIGUS_ANTUD (
    oigus_antud_new IN oigus_antud%ROWTYPE,
    oigus_antud_old IN oigus_antud%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'OIGUS_ANTUD';
    primary_key_value NUMBER(38,0) := oigus_antud_old.oigus_antud_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- oigus_antud_id changed
    IF(NVL(oigus_antud_new.oigus_antud_id, 0) != NVL(oigus_antud_old.oigus_antud_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_antud_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.oigus_antud_id,
        oigus_antud_new.oigus_antud_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(oigus_antud_new.asutus_id, 0) != NVL(oigus_antud_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.asutus_id,
        oigus_antud_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- muu_asutus_id changed
    IF(NVL(oigus_antud_new.muu_asutus_id, 0) != NVL(oigus_antud_old.muu_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muu_asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.muu_asutus_id,
        oigus_antud_new.muu_asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(oigus_antud_new.ametikoht_id, 0) != NVL(oigus_antud_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.ametikoht_id,
        oigus_antud_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- roll changed
    IF(NVL(oigus_antud_new.roll, ' ') != NVL(oigus_antud_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.roll,
        oigus_antud_new.roll,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- alates changed
    IF(NVL(oigus_antud_new.alates, d) != NVL(oigus_antud_old.alates, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.alates,
        oigus_antud_new.alates,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kuni changed
    IF(NVL(oigus_antud_new.kuni, d) != NVL(oigus_antud_old.kuni, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.kuni,
        oigus_antud_new.kuni,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(oigus_antud_new.created, d) != NVL(oigus_antud_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.created,
        oigus_antud_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(oigus_antud_new.last_modified, d) != NVL(oigus_antud_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.last_modified,
        oigus_antud_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(oigus_antud_new.username, ' ') != NVL(oigus_antud_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.username,
        oigus_antud_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- peatatud changed
    IF(NVL(oigus_antud_new.peatatud, 0) != NVL(oigus_antud_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.peatatud,
        oigus_antud_new.peatatud,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus_id changed
    IF(NVL(oigus_antud_new.allyksus_id, 0) != NVL(oigus_antud_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_antud_old.allyksus_id,
        oigus_antud_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_OIGUS_ANTUD;

  PROCEDURE LOG_OIGUS_OBJEKTILE (
    oigus_objektile_new IN oigus_objektile%ROWTYPE,
    oigus_objektile_old IN oigus_objektile%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'OIGUS_OBJEKTILE';
    primary_key_value NUMBER(38,0) := oigus_objektile_old.oigus_objektile_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- oigus_objektile_id changed
    IF(NVL(oigus_objektile_new.oigus_objektile_id, 0) != NVL(oigus_objektile_old.oigus_objektile_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_objektile_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.oigus_objektile_id,
        oigus_objektile_new.oigus_objektile_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(oigus_objektile_new.asutus_id, 0) != NVL(oigus_objektile_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.asutus_id,
        oigus_objektile_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(oigus_objektile_new.ametikoht_id, 0) != NVL(oigus_objektile_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.ametikoht_id,
        oigus_objektile_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- dokument_id changed
    IF(NVL(oigus_objektile_new.dokument_id, 0) != NVL(oigus_objektile_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.dokument_id,
        oigus_objektile_new.dokument_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kaust_id changed
    IF(NVL(oigus_objektile_new.kaust_id, 0) != NVL(oigus_objektile_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kaust_id,
        oigus_objektile_new.kaust_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kehtib_alates changed
    IF(NVL(oigus_objektile_new.kehtib_alates, d) != NVL(oigus_objektile_old.kehtib_alates, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_alates');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kehtib_alates,
        oigus_objektile_new.kehtib_alates,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kehtib_kuni changed
    IF(NVL(oigus_objektile_new.kehtib_kuni, d) != NVL(oigus_objektile_old.kehtib_kuni, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_kuni');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        oigus_objektile_old.kehtib_kuni,
        oigus_objektile_new.kehtib_kuni,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_OIGUS_OBJEKTILE;

  PROCEDURE LOG_PARAMEETRID (
    parameetrid_new IN parameetrid%ROWTYPE,
    parameetrid_old IN parameetrid%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'PARAMEETRID';
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- aar_viimane_sync changed
    IF(NVL(parameetrid_new.aar_viimane_sync, d) != NVL(parameetrid_old.aar_viimane_sync, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_viimane_sync');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        null, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        parameetrid_old.aar_viimane_sync,
        parameetrid_new.aar_viimane_sync,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_PARAMEETRID;

  PROCEDURE LOG_SERVER (
    server_new IN server%ROWTYPE,
    server_old IN server%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'SERVER';
    primary_key_value NUMBER(38,0) := server_old.server_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- server_id changed
    IF(NVL(server_new.server_id, 0) != NVL(server_old.server_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('server_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.server_id,
        server_new.server_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- andmekogu_nimi changed
    IF(NVL(server_new.andmekogu_nimi, ' ') != NVL(server_old.andmekogu_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('andmekogu_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.andmekogu_nimi,
        server_new.andmekogu_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- aadress changed
    IF(NVL(server_new.aadress, ' ') != NVL(server_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        server_old.aadress,
        server_new.aadress,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_SERVER;

  PROCEDURE LOG_VASTUVOTJA_MALL (
    vastuvotja_mall_new IN vastuvotja_mall%ROWTYPE,
    vastuvotja_mall_old IN vastuvotja_mall%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'VASTUVOTJA_MALL';
    primary_key_value NUMBER(38,0) := vastuvotja_mall_old.vastuvotja_mall_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- vastuvotja_mall_id changed
    IF(NVL(vastuvotja_mall_new.vastuvotja_mall_id, 0) != NVL(vastuvotja_mall_old.vastuvotja_mall_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_mall_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.vastuvotja_mall_id,
        vastuvotja_mall_new.vastuvotja_mall_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutus_id changed
    IF(NVL(vastuvotja_mall_new.asutus_id, 0) != NVL(vastuvotja_mall_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.asutus_id,
        vastuvotja_mall_new.asutus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht_id changed
    IF(NVL(vastuvotja_mall_new.ametikoht_id, 0) != NVL(vastuvotja_mall_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.ametikoht_id,
        vastuvotja_mall_new.ametikoht_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- isikukood changed
    IF(NVL(vastuvotja_mall_new.isikukood, ' ') != NVL(vastuvotja_mall_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.isikukood,
        vastuvotja_mall_new.isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimi changed
    IF(NVL(vastuvotja_mall_new.nimi, ' ') != NVL(vastuvotja_mall_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.nimi,
        vastuvotja_mall_new.nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- email changed
    IF(NVL(vastuvotja_mall_new.email, ' ') != NVL(vastuvotja_mall_old.email, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.email,
        vastuvotja_mall_new.email,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nr changed
    IF(NVL(vastuvotja_mall_new.osakonna_nr, ' ') != NVL(vastuvotja_mall_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.osakonna_nr,
        vastuvotja_mall_new.osakonna_nr,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- osakonna_nimi changed
    IF(NVL(vastuvotja_mall_new.osakonna_nimi, ' ') != NVL(vastuvotja_mall_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.osakonna_nimi,
        vastuvotja_mall_new.osakonna_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- saatmisviis_id changed
    IF(NVL(vastuvotja_mall_new.saatmisviis_id, 0) != NVL(vastuvotja_mall_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.saatmisviis_id,
        vastuvotja_mall_new.saatmisviis_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- asutuse_nimi changed
    IF(NVL(vastuvotja_mall_new.asutuse_nimi, ' ') != NVL(vastuvotja_mall_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.asutuse_nimi,
        vastuvotja_mall_new.asutuse_nimi,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksus_id changed
    IF(NVL(vastuvotja_mall_new.allyksus_id, 0) != NVL(vastuvotja_mall_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.allyksus_id,
        vastuvotja_mall_new.allyksus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- tingimus_xpath changed
    IF(NVL(vastuvotja_mall_new.tingimus_xpath, ' ') != NVL(vastuvotja_mall_old.tingimus_xpath, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tingimus_xpath');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.tingimus_xpath,
        vastuvotja_mall_new.tingimus_xpath,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- allyksuse_lyhinimetus changed
    IF(NVL(vastuvotja_mall_new.allyksuse_lyhinimetus, ' ') != NVL(vastuvotja_mall_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.allyksuse_lyhinimetus,
        vastuvotja_mall_new.allyksuse_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoha_lyhinimetus changed
    IF(NVL(vastuvotja_mall_new.ametikoha_lyhinimetus, ' ') != NVL(vastuvotja_mall_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_mall_old.ametikoha_lyhinimetus,
        vastuvotja_mall_new.ametikoha_lyhinimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_VASTUVOTJA_MALL;

  PROCEDURE LOG_VASTUVOTJA_STAATUS (
    vastuvotja_staatus_new IN vastuvotja_staatus%ROWTYPE,
    vastuvotja_staatus_old IN vastuvotja_staatus%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'VASTUVOTJA_STAATUS';
    primary_key_value NUMBER(38,0) := vastuvotja_staatus_old.vastuvotja_staatus_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
            
    -- vastuvotja_staatus_id changed
    IF(NVL(vastuvotja_staatus_new.vastuvotja_staatus_id, 0) != NVL(vastuvotja_staatus_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_staatus_old.vastuvotja_staatus_id,
        vastuvotja_staatus_new.vastuvotja_staatus_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- nimetus changed
    IF(NVL(vastuvotja_staatus_new.nimetus, ' ') != NVL(vastuvotja_staatus_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        vastuvotja_staatus_old.nimetus,
        vastuvotja_staatus_new.nimetus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
  END LOG_VASTUVOTJA_STAATUS;

  PROCEDURE LOG_LOGI (
    logi_new IN logi%ROWTYPE,
    logi_old IN logi%ROWTYPE,
    operation IN VARCHAR2
  ) AS
  
    clmn      user_tab_columns%ROWTYPE;
    usr       varchar2(20);
    pkey_col  varchar2(50);
    tablename varchar2(50) := 'LOGI';
    primary_key_value NUMBER(38,0) := logi_old.log_id;
    
    d DATE := sysdate;
    
  BEGIN
  
    -- Current user
    SELECT USER INTO usr FROM dual;
    
    -- Current table primary key column
    select  cc.column_name
    into    pkey_col
    from    user_cons_columns cc, user_constraints c
    where   cc.constraint_name = c.constraint_name
            and c.constraint_type = 'P'
            and upper(cc.table_name) = tablename
            and rownum < 2;
  
    -- log_id changed
    IF(NVL(logi_new.log_id, 0) != NVL(logi_old.log_id, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('log_id');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.log_id,
        logi_new.log_id,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
  
    -- tabel changed
    IF(NVL(logi_new.tabel, ' ') != NVL(logi_old.tabel, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.tabel,
        logi_new.tabel,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- op changed
    IF(NVL(logi_new.op, ' ') != NVL(logi_old.op, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('op');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.op,
        logi_new.op,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- uidcol changed
    IF(NVL(logi_new.uidcol, ' ') != NVL(logi_old.uidcol, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uidcol');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.uidcol,
        logi_new.uidcol,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- tabel_uid changed
    IF(NVL(logi_new.tabel_uid, 0) != NVL(logi_old.tabel_uid, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel_uid');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.tabel_uid,
        logi_new.tabel_uid,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- veerg changed
    IF(NVL(logi_new.veerg, ' ') != NVL(logi_old.veerg, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('veerg');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.veerg,
        logi_new.veerg,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ctype changed
    IF(NVL(logi_new.ctype, ' ') != NVL(logi_old.ctype, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ctype');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ctype,
        logi_new.ctype,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- vana_vaartus changed
    IF(NVL(logi_new.vana_vaartus, ' ') != NVL(logi_old.vana_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vana_vaartus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.vana_vaartus,
        logi_new.vana_vaartus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- uus_vaartus changed
    IF(NVL(logi_new.uus_vaartus, ' ') != NVL(logi_old.uus_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uus_vaartus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.uus_vaartus,
        logi_new.uus_vaartus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- muutmise_aeg changed
    IF(NVL(logi_new.muutmise_aeg, d) != NVL(logi_old.muutmise_aeg, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutmise_aeg');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.muutmise_aeg,
        logi_new.muutmise_aeg,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ab_kasutaja changed
    IF(NVL(logi_new.ab_kasutaja, ' ') != NVL(logi_old.ab_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ab_kasutaja');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ab_kasutaja,
        logi_new.ab_kasutaja,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ef_kasutaja changed
    IF(NVL(logi_new.ef_kasutaja, ' ') != NVL(logi_old.ef_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ef_kasutaja');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ef_kasutaja,
        logi_new.ef_kasutaja,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- kasutaja_kood changed
    IF(NVL(logi_new.kasutaja_kood, ' ') != NVL(logi_old.kasutaja_kood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kasutaja_kood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.kasutaja_kood,
        logi_new.kasutaja_kood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- comm changed
    IF(NVL(logi_new.comm, ' ') != NVL(logi_old.comm, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('comm');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.comm,
        logi_new.comm,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- created changed
    IF(NVL(logi_new.created, d) != NVL(logi_old.created, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.created,
        logi_new.created,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- last_modified changed
    IF(NVL(logi_new.last_modified, d) != NVL(logi_old.last_modified, d)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.last_modified,
        logi_new.last_modified,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- username changed
    IF(NVL(logi_new.username, ' ') != NVL(logi_old.username, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.username,
        logi_new.username,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- ametikoht changed
    IF(NVL(logi_new.ametikoht, 0) != NVL(logi_old.ametikoht, 0)) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.ametikoht,
        logi_new.ametikoht,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- xtee_isikukood changed
    IF(NVL(logi_new.xtee_isikukood, ' ') != NVL(logi_old.xtee_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_isikukood');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.xtee_isikukood,
        logi_new.xtee_isikukood,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
    -- xtee_asutus changed
    IF(NVL(logi_new.xtee_asutus, ' ') != NVL(logi_old.xtee_asutus, ' ')) THEN
      SELECT * INTO clmn FROM user_tab_columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_asutus');
    
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
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
        operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        logi_old.xtee_asutus,
        logi_new.xtee_asutus,
        sysdate,
        usr,
        '''',
        '''',
        '''',
        sysdate,
        sysdate,
        '''',
        0,
        DVKLOG.xtee_isikukood,
        DVKLOG.xtee_asutus
      );
    END IF;
    
  END LOG_LOGI;
  
END DVKLOG;
/


  CREATE OR REPLACE TRIGGER TR_ALLKIRI_LOG 
  after insert or update or delete
  on ALLKIRI referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  allkiri_new allkiri%ROWTYPE;
  allkiri_old allkiri%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  allkiri_new.ALLKIRI_ID := :new.ALLKIRI_ID;
  allkiri_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  allkiri_new.EESNIMI := :new.EESNIMI;
  allkiri_new.PERENIMI := :new.PERENIMI;
  allkiri_new.ISIKUKOOD := :new.ISIKUKOOD;
  allkiri_new.KUUPAEV := :new.KUUPAEV;
  allkiri_new.ROLL := :new.ROLL;
  allkiri_new.RIIK := :new.RIIK;
  allkiri_new.MAAKOND := :new.MAAKOND;
  allkiri_new.LINN := :new.LINN;
  allkiri_new.INDEKS := :new.INDEKS;

  allkiri_old.ALLKIRI_ID := :old.ALLKIRI_ID;
  allkiri_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  allkiri_old.EESNIMI := :old.EESNIMI;
  allkiri_old.PERENIMI := :old.PERENIMI;
  allkiri_old.ISIKUKOOD := :old.ISIKUKOOD;
  allkiri_old.KUUPAEV := :old.KUUPAEV;
  allkiri_old.ROLL := :old.ROLL;
  allkiri_old.RIIK := :old.RIIK;
  allkiri_old.MAAKOND := :old.MAAKOND;
  allkiri_old.LINN := :old.LINN;
  allkiri_old.INDEKS := :old.INDEKS;

  DVKLOG.LOG_ALLKIRI(
    allkiri_new,
    allkiri_old,
    operation
  );

END;
/
ALTER TRIGGER TR_ALLKIRI_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_ALLYKSUS_LOG 
  after insert or update or delete
  on ALLYKSUS referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  ALLYKSUS_new ALLYKSUS%ROWTYPE;
  ALLYKSUS_old ALLYKSUS%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  ALLYKSUS_new.ID := :new.ID;
  ALLYKSUS_new.ASUTUS_ID := :new.ASUTUS_ID;
  ALLYKSUS_new.VANEM_ID := :new.VANEM_ID;
  ALLYKSUS_new.ALLYKSUS := :new.ALLYKSUS;
  ALLYKSUS_new.CREATED := :new.CREATED;
  ALLYKSUS_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  ALLYKSUS_new.USERNAME := :new.USERNAME;
  ALLYKSUS_new.MUUTM_ARV := :new.MUUTM_ARV;
  ALLYKSUS_new.AAR_ID := :new.AAR_ID;
  ALLYKSUS_new.LYHINIMETUS := :new.LYHINIMETUS;
  ALLYKSUS_new.ADR_URI := :new.ADR_URI;
  
  ALLYKSUS_old.ID := :old.ID;
  ALLYKSUS_old.ASUTUS_ID := :old.ASUTUS_ID;
  ALLYKSUS_old.VANEM_ID := :old.VANEM_ID;
  ALLYKSUS_old.ALLYKSUS := :old.ALLYKSUS;
  ALLYKSUS_old.CREATED := :old.CREATED;
  ALLYKSUS_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  ALLYKSUS_old.USERNAME := :old.USERNAME;
  ALLYKSUS_old.MUUTM_ARV := :old.MUUTM_ARV;
  ALLYKSUS_old.AAR_ID := :old.AAR_ID;
  ALLYKSUS_old.LYHINIMETUS := :old.LYHINIMETUS;
  ALLYKSUS_old.ADR_URI := :old.ADR_URI;



  DVKLOG.LOG_ALLYKSUS(
    ALLYKSUS_new,
    ALLYKSUS_old,
    operation
  );

END;
/
ALTER TRIGGER TR_ALLYKSUS_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_AMETIKOHT_LOG 
  after insert or update or delete
  on AMETIKOHT referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  AMETIKOHT_new AMETIKOHT%ROWTYPE;
  AMETIKOHT_old AMETIKOHT%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  AMETIKOHT_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  AMETIKOHT_new.KS_AMETIKOHT_ID := :new.KS_AMETIKOHT_ID;
  AMETIKOHT_new.ASUTUS_ID := :new.ASUTUS_ID;
  AMETIKOHT_new.AMETIKOHT_NIMETUS := :new.AMETIKOHT_NIMETUS;
  AMETIKOHT_new.ALATES := :new.ALATES;
  AMETIKOHT_new.KUNI := :new.KUNI;
  AMETIKOHT_new.CREATED := :new.CREATED;
  AMETIKOHT_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  AMETIKOHT_new.USERNAME := :new.USERNAME;
  AMETIKOHT_new.ALLYKSUS_ID := :new.ALLYKSUS_ID;
  AMETIKOHT_new.PARAMS := :new.PARAMS;
  AMETIKOHT_new.AAR_ID := :new.AAR_ID;
  AMETIKOHT_new.LYHINIMETUS := :new.LYHINIMETUS;
  
  AMETIKOHT_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  AMETIKOHT_old.KS_AMETIKOHT_ID := :old.KS_AMETIKOHT_ID;
  AMETIKOHT_old.ASUTUS_ID := :old.ASUTUS_ID;
  AMETIKOHT_old.AMETIKOHT_NIMETUS := :old.AMETIKOHT_NIMETUS;
  AMETIKOHT_old.ALATES := :old.ALATES;
  AMETIKOHT_old.KUNI := :old.KUNI;
  AMETIKOHT_old.CREATED := :old.CREATED;
  AMETIKOHT_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  AMETIKOHT_old.USERNAME := :old.USERNAME;
  AMETIKOHT_old.ALLYKSUS_ID := :old.ALLYKSUS_ID;
  AMETIKOHT_old.PARAMS := :old.PARAMS;
  AMETIKOHT_old.AAR_ID := :old.AAR_ID;
  AMETIKOHT_old.LYHINIMETUS := :old.LYHINIMETUS;

  DVKLOG.LOG_AMETIKOHT(
    AMETIKOHT_new,
    AMETIKOHT_old,
    operation
  );

END;
/
ALTER TRIGGER TR_AMETIKOHT_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_AMETIKOHT_TAITMINE_LOG 
  after insert or update or delete
  on AMETIKOHT_TAITMINE referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  AMETIKOHT_TAITMINE_new AMETIKOHT_TAITMINE%ROWTYPE;
  AMETIKOHT_TAITMINE_old AMETIKOHT_TAITMINE%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  AMETIKOHT_TAITMINE_new.TAITMINE_ID := :new.TAITMINE_ID;
  AMETIKOHT_TAITMINE_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  AMETIKOHT_TAITMINE_new.I_ID := :new.I_ID;
  AMETIKOHT_TAITMINE_new.ALATES := :new.ALATES;
  AMETIKOHT_TAITMINE_new.KUNI := :new.KUNI;
  AMETIKOHT_TAITMINE_new.ROLL := :new.ROLL;
  AMETIKOHT_TAITMINE_new.CREATED := :new.CREATED;
  AMETIKOHT_TAITMINE_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  AMETIKOHT_TAITMINE_new.USERNAME := :new.USERNAME;
  AMETIKOHT_TAITMINE_new.PEATATUD := :new.PEATATUD;
  AMETIKOHT_TAITMINE_new.AAR_ID := :new.AAR_ID;

  AMETIKOHT_TAITMINE_old.TAITMINE_ID := :old.TAITMINE_ID;
  AMETIKOHT_TAITMINE_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  AMETIKOHT_TAITMINE_old.I_ID := :old.I_ID;
  AMETIKOHT_TAITMINE_old.ALATES := :old.ALATES;
  AMETIKOHT_TAITMINE_old.KUNI := :old.KUNI;
  AMETIKOHT_TAITMINE_old.ROLL := :old.ROLL;
  AMETIKOHT_TAITMINE_old.CREATED := :old.CREATED;
  AMETIKOHT_TAITMINE_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  AMETIKOHT_TAITMINE_old.USERNAME := :old.USERNAME;
  AMETIKOHT_TAITMINE_old.PEATATUD := :old.PEATATUD;
  AMETIKOHT_TAITMINE_old.AAR_ID := :old.AAR_ID;

  DVKLOG.LOG_AMETIKOHT_TAITMINE(
    AMETIKOHT_TAITMINE_new,
    AMETIKOHT_TAITMINE_old,
    operation
  );

END;
/
ALTER TRIGGER TR_AMETIKOHT_TAITMINE_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_ASUTUS_LOG 
  after insert or update or delete
  on ASUTUS referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  asutus_new asutus%ROWTYPE;
  asutus_old asutus%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;
  
  asutus_new.ASUTUS_ID := :new.ASUTUS_ID;
  asutus_new.REGISTRIKOOD := :new.REGISTRIKOOD;
  asutus_new.E_REGISTRIKOOD := :new.E_REGISTRIKOOD;
  asutus_new.KS_ASUTUS_ID := :new.KS_ASUTUS_ID;
  asutus_new.KS_ASUTUS_KOOD := :new.KS_ASUTUS_KOOD;
  asutus_new.NIMETUS := :new.NIMETUS;
  asutus_new.LNIMI := :new.LNIMI;
  asutus_new.LIIK1 := :new.LIIK1;
  asutus_new.LIIK2 := :new.LIIK2;
  asutus_new.TEGEVUSALA := :new.TEGEVUSALA;
  asutus_new.TEGEVUSPIIRKOND := :new.TEGEVUSPIIRKOND;
  asutus_new.MAAKOND := :new.MAAKOND;
  asutus_new.ASUKOHT := :new.ASUKOHT;
  asutus_new.AADRESS := :new.AADRESS;
  asutus_new.POSTIKOOD := :new.POSTIKOOD;
  asutus_new.TELEFON := :new.TELEFON;
  asutus_new.FAKS := :new.FAKS;
  asutus_new.E_POST := :new.E_POST;
  asutus_new.WWW := :new.WWW;
  asutus_new.LOGO := :new.LOGO;
  asutus_new.ASUTAMISE_KP := :new.ASUTAMISE_KP;
  asutus_new.MOOD_AKT_NIMI := :new.MOOD_AKT_NIMI;
  asutus_new.MOOD_AKT_NR := :new.MOOD_AKT_NR;
  asutus_new.MOOD_AKT_KP := :new.MOOD_AKT_KP;
  asutus_new.PM_AKT_NIMI := :new.PM_AKT_NIMI;
  asutus_new.PM_AKT_NR := :new.PM_AKT_NR;
  asutus_new.PM_KINNITAMISE_KP := :new.PM_KINNITAMISE_KP;
  asutus_new.PM_KANDE_KP := :new.PM_KANDE_KP;
  asutus_new.CREATED := :new.CREATED;
  asutus_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  asutus_new.USERNAME := :new.USERNAME;
  asutus_new.PARAMS := :new.PARAMS;
  asutus_new.DHL_OTSE_SAATMINE := :new.DHL_OTSE_SAATMINE;
  asutus_new.DHL_SAATMINE := :new.DHL_SAATMINE;
  asutus_new.DHS_NIMETUS := :new.DHS_NIMETUS;
  asutus_new.TOETATAV_DVK_VERSIOON := :new.TOETATAV_DVK_VERSIOON;
  asutus_new.SERVER_ID := :new.SERVER_ID;
  asutus_new.AAR_ID := :new.AAR_ID;

  asutus_old.ASUTUS_ID := :old.ASUTUS_ID;
  asutus_old.REGISTRIKOOD := :old.REGISTRIKOOD;
  asutus_old.E_REGISTRIKOOD := :old.E_REGISTRIKOOD;
  asutus_old.KS_ASUTUS_ID := :old.KS_ASUTUS_ID;
  asutus_old.KS_ASUTUS_KOOD := :old.KS_ASUTUS_KOOD;
  asutus_old.NIMETUS := :old.NIMETUS;
  asutus_old.LNIMI := :old.LNIMI;
  asutus_old.LIIK1 := :old.LIIK1;
  asutus_old.LIIK2 := :old.LIIK2;
  asutus_old.TEGEVUSALA := :old.TEGEVUSALA;
  asutus_old.TEGEVUSPIIRKOND := :old.TEGEVUSPIIRKOND;
  asutus_old.MAAKOND := :old.MAAKOND;
  asutus_old.ASUKOHT := :old.ASUKOHT;
  asutus_old.AADRESS := :old.AADRESS;
  asutus_old.POSTIKOOD := :old.POSTIKOOD;
  asutus_old.TELEFON := :old.TELEFON;
  asutus_old.FAKS := :old.FAKS;
  asutus_old.E_POST := :old.E_POST;
  asutus_old.WWW := :old.WWW;
  asutus_old.LOGO := :old.LOGO;
  asutus_old.ASUTAMISE_KP := :old.ASUTAMISE_KP;
  asutus_old.MOOD_AKT_NIMI := :old.MOOD_AKT_NIMI;
  asutus_old.MOOD_AKT_NR := :old.MOOD_AKT_NR;
  asutus_old.MOOD_AKT_KP := :old.MOOD_AKT_KP;
  asutus_old.PM_AKT_NIMI := :old.PM_AKT_NIMI;
  asutus_old.PM_AKT_NR := :old.PM_AKT_NR;
  asutus_old.PM_KINNITAMISE_KP := :old.PM_KINNITAMISE_KP;
  asutus_old.PM_KANDE_KP := :old.PM_KANDE_KP;
  asutus_old.CREATED := :old.CREATED;
  asutus_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  asutus_old.USERNAME := :old.USERNAME;
  asutus_old.PARAMS := :old.PARAMS;
  asutus_old.DHL_OTSE_SAATMINE := :old.DHL_OTSE_SAATMINE;
  asutus_old.DHL_SAATMINE := :old.DHL_SAATMINE;
  asutus_old.DHS_NIMETUS := :old.DHS_NIMETUS;
  asutus_old.TOETATAV_DVK_VERSIOON := :old.TOETATAV_DVK_VERSIOON;
  asutus_old.SERVER_ID := :old.SERVER_ID;
  asutus_old.AAR_ID := :old.AAR_ID;

  DVKLOG.LOG_ASUTUS(
    asutus_new,
    asutus_old,
    operation
  );

END;
/
ALTER TRIGGER TR_ASUTUS_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_DOKUMENDI_AJALUGU_LOG 
  after insert or update or delete
  on DOKUMENDI_AJALUGU referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  DOKUMENDI_AJALUGU_new DOKUMENDI_AJALUGU%ROWTYPE;
  DOKUMENDI_AJALUGU_old DOKUMENDI_AJALUGU%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  DOKUMENDI_AJALUGU_new.AJALUGU_ID := :new.AJALUGU_ID;
  DOKUMENDI_AJALUGU_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  DOKUMENDI_AJALUGU_new.METAINFO := :new.METAINFO;
  DOKUMENDI_AJALUGU_new.TRANSPORT := :new.TRANSPORT;
  DOKUMENDI_AJALUGU_new.METAXML := :new.METAXML;

  DOKUMENDI_AJALUGU_old.AJALUGU_ID := :old.AJALUGU_ID;
  DOKUMENDI_AJALUGU_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  DOKUMENDI_AJALUGU_old.METAINFO := :old.METAINFO;
  DOKUMENDI_AJALUGU_old.TRANSPORT := :old.TRANSPORT;
  DOKUMENDI_AJALUGU_old.METAXML := :old.METAXML;

  DVKLOG.LOG_DOKUMENDI_AJALUGU(
    DOKUMENDI_AJALUGU_new,
    DOKUMENDI_AJALUGU_old,
    operation
  );

END;
/
ALTER TRIGGER TR_DOKUMENDI_AJALUGU_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_DOKUMENDI_FAIL_LOG 
  after insert or update or delete
  on DOKUMENDI_FAIL referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  DOKUMENDI_FAIL_new DOKUMENDI_FAIL%ROWTYPE;
  DOKUMENDI_FAIL_old DOKUMENDI_FAIL%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  DOKUMENDI_FAIL_new.FAIL_ID := :new.FAIL_ID;
  DOKUMENDI_FAIL_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  DOKUMENDI_FAIL_new.NIMI := :new.NIMI;
  DOKUMENDI_FAIL_new.SUURUS := :new.SUURUS;
  DOKUMENDI_FAIL_new.MIME_TYYP := :new.MIME_TYYP;
  DOKUMENDI_FAIL_new.SISU := :new.SISU;
  DOKUMENDI_FAIL_new.POHIFAIL := :new.POHIFAIL;
  DOKUMENDI_FAIL_new.VALINE_MANUS := :new.VALINE_MANUS;

  DOKUMENDI_FAIL_old.FAIL_ID := :old.FAIL_ID;
  DOKUMENDI_FAIL_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  DOKUMENDI_FAIL_old.NIMI := :old.NIMI;
  DOKUMENDI_FAIL_old.SUURUS := :old.SUURUS;
  DOKUMENDI_FAIL_old.MIME_TYYP := :old.MIME_TYYP;
  DOKUMENDI_FAIL_old.SISU := :old.SISU;
  DOKUMENDI_FAIL_old.POHIFAIL := :old.POHIFAIL;
  DOKUMENDI_FAIL_old.VALINE_MANUS := :old.VALINE_MANUS;

  DVKLOG.LOG_DOKUMENDI_FAIL(
    DOKUMENDI_FAIL_new,
    DOKUMENDI_FAIL_old,
    operation
  );

END;
/
ALTER TRIGGER TR_DOKUMENDI_FAIL_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_DOKUMENT_LOG 
  after insert or update or delete
  on DOKUMENT referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  dokument_new dokument%ROWTYPE;
  dokument_old dokument%ROWTYPE;
BEGIN

  DVKLOG.debug('TR_DOKUMENT_LOG started...');

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  dokument_new.dokument_id := :new.dokument_id;
  dokument_new.asutus_id := :new.asutus_id;
  dokument_new.kaust_id := :new.kaust_id;
  dokument_new.sailitustahtaeg := :new.sailitustahtaeg;
  dokument_new.eelmise_versiooni_id := :new.eelmise_versiooni_id;
  dokument_new.versioon := :new.versioon;
  dokument_new.suurus := :new.suurus;
  dokument_new.guid := :new.guid;

  dokument_old.dokument_id := :old.dokument_id;
  dokument_old.asutus_id := :old.asutus_id;
  dokument_old.kaust_id := :old.kaust_id;
  dokument_old.sailitustahtaeg := :old.sailitustahtaeg;
  dokument_old.eelmise_versiooni_id := :old.eelmise_versiooni_id;
  dokument_old.versioon := :old.versioon;
  dokument_old.suurus := :old.suurus;
  dokument_old.guid := :old.guid;

  DVKLOG.LOG_DOKUMENT(
    dokument_new,
    dokument_old,
    operation
  );

END;
/
ALTER TRIGGER TR_DOKUMENT_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_DOKUMENDI_METAANDMED_LOG 
  after insert or update or delete
  on DOKUMENDI_METAANDMED referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  DOKUMENDI_METAANDMED_new DOKUMENDI_METAANDMED%ROWTYPE;
  DOKUMENDI_METAANDMED_old DOKUMENDI_METAANDMED%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  DOKUMENDI_METAANDMED_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NR := :new.KOOSTAJA_ASUTUSE_NR;
  DOKUMENDI_METAANDMED_new.SAAJA_ASUTUSE_NR := :new.SAAJA_ASUTUSE_NR;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINIMI := :new.KOOSTAJA_DOKUMENDINIMI;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDITYYP := :new.KOOSTAJA_DOKUMENDITYYP;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINR := :new.KOOSTAJA_DOKUMENDINR;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_FAILINIMI := :new.KOOSTAJA_FAILINIMI;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_KATALOOG := :new.KOOSTAJA_KATALOOG;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_VOTMESONA := :new.KOOSTAJA_VOTMESONA;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_KOKKUVOTE := :new.KOOSTAJA_KOKKUVOTE;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_KUUPAEV := :new.KOOSTAJA_KUUPAEV;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NIMI := :new.KOOSTAJA_ASUTUSE_NIMI;
  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_KONTAKT := :new.KOOSTAJA_ASUTUSE_KONTAKT;
  DOKUMENDI_METAANDMED_new.AUTORI_OSAKOND := :new.AUTORI_OSAKOND;
  DOKUMENDI_METAANDMED_new.AUTORI_ISIKUKOOD := :new.AUTORI_ISIKUKOOD;
  DOKUMENDI_METAANDMED_new.AUTORI_NIMI := :new.AUTORI_NIMI;
  DOKUMENDI_METAANDMED_new.AUTORI_KONTAKT := :new.AUTORI_KONTAKT;
  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_KOOSTAJAL := :new.SEOTUD_DOKUMENDINR_KOOSTAJAL;
  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_SAAJAL := :new.SEOTUD_DOKUMENDINR_SAAJAL;
  DOKUMENDI_METAANDMED_new.SAATJA_DOKUMENDINR := :new.SAATJA_DOKUMENDINR;
  DOKUMENDI_METAANDMED_new.SAATJA_KUUPAEV := :new.SAATJA_KUUPAEV;
  DOKUMENDI_METAANDMED_new.SAATJA_ASUTUSE_KONTAKT := :new.SAATJA_ASUTUSE_KONTAKT;
  DOKUMENDI_METAANDMED_new.SAAJA_ISIKUKOOD := :new.SAAJA_ISIKUKOOD;
  DOKUMENDI_METAANDMED_new.SAAJA_NIMI := :new.SAAJA_NIMI;
  DOKUMENDI_METAANDMED_new.SAAJA_OSAKOND := :new.SAAJA_OSAKOND;
  DOKUMENDI_METAANDMED_new.SEOTUD_DHL_ID := :new.SEOTUD_DHL_ID;
  DOKUMENDI_METAANDMED_new.KOMMENTAAR := :new.KOMMENTAAR;

  DOKUMENDI_METAANDMED_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NR := :old.KOOSTAJA_ASUTUSE_NR;
  DOKUMENDI_METAANDMED_old.SAAJA_ASUTUSE_NR := :old.SAAJA_ASUTUSE_NR;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINIMI := :old.KOOSTAJA_DOKUMENDINIMI;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDITYYP := :old.KOOSTAJA_DOKUMENDITYYP;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINR := :old.KOOSTAJA_DOKUMENDINR;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_FAILINIMI := :old.KOOSTAJA_FAILINIMI;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_KATALOOG := :old.KOOSTAJA_KATALOOG;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_VOTMESONA := :old.KOOSTAJA_VOTMESONA;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_KOKKUVOTE := :old.KOOSTAJA_KOKKUVOTE;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_KUUPAEV := :old.KOOSTAJA_KUUPAEV;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NIMI := :old.KOOSTAJA_ASUTUSE_NIMI;
  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_KONTAKT := :old.KOOSTAJA_ASUTUSE_KONTAKT;
  DOKUMENDI_METAANDMED_old.AUTORI_OSAKOND := :old.AUTORI_OSAKOND;
  DOKUMENDI_METAANDMED_old.AUTORI_ISIKUKOOD := :old.AUTORI_ISIKUKOOD;
  DOKUMENDI_METAANDMED_old.AUTORI_NIMI := :old.AUTORI_NIMI;
  DOKUMENDI_METAANDMED_old.AUTORI_KONTAKT := :old.AUTORI_KONTAKT;
  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_KOOSTAJAL := :old.SEOTUD_DOKUMENDINR_KOOSTAJAL;
  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_SAAJAL := :old.SEOTUD_DOKUMENDINR_SAAJAL;
  DOKUMENDI_METAANDMED_old.SAATJA_DOKUMENDINR := :old.SAATJA_DOKUMENDINR;
  DOKUMENDI_METAANDMED_old.SAATJA_KUUPAEV := :old.SAATJA_KUUPAEV;
  DOKUMENDI_METAANDMED_old.SAATJA_ASUTUSE_KONTAKT := :old.SAATJA_ASUTUSE_KONTAKT;
  DOKUMENDI_METAANDMED_old.SAAJA_ISIKUKOOD := :old.SAAJA_ISIKUKOOD;
  DOKUMENDI_METAANDMED_old.SAAJA_NIMI := :old.SAAJA_NIMI;
  DOKUMENDI_METAANDMED_old.SAAJA_OSAKOND := :old.SAAJA_OSAKOND;
  DOKUMENDI_METAANDMED_old.SEOTUD_DHL_ID := :old.SEOTUD_DHL_ID;
  DOKUMENDI_METAANDMED_old.KOMMENTAAR := :old.KOMMENTAAR;

  DVKLOG.LOG_DOKUMENDI_METAANDMED(
    DOKUMENDI_METAANDMED_new,
    DOKUMENDI_METAANDMED_old,
    operation
  );

END;
/
ALTER TRIGGER TR_DOKUMENDI_METAANDMED_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_DYNAAMILISED_METAANDMED_LOG 
  after insert or update or delete
  on DYNAAMILISED_METAANDMED referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  DYNAAMILISED_METAANDMED_new DYNAAMILISED_METAANDMED%ROWTYPE;
  DYNAAMILISED_METAANDMED_old DYNAAMILISED_METAANDMED%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  DYNAAMILISED_METAANDMED_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  DYNAAMILISED_METAANDMED_new.NIMI := :new.NIMI;
  DYNAAMILISED_METAANDMED_new.VAARTUS := :new.VAARTUS;

  DYNAAMILISED_METAANDMED_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  DYNAAMILISED_METAANDMED_old.NIMI := :old.NIMI;
  DYNAAMILISED_METAANDMED_old.VAARTUS := :old.VAARTUS;

  DVKLOG.LOG_DYNAAMILISED_METAANDMED(
    DYNAAMILISED_METAANDMED_new,
    DYNAAMILISED_METAANDMED_old,
    operation
  );

END;
/
ALTER TRIGGER TR_DYNAAMILISED_METAANDMED_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_EHAK_LOG 
  after insert or update or delete
  on EHAK referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  EHAK_new EHAK%ROWTYPE;
  EHAK_old EHAK%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  EHAK_new.EHAK_ID := :new.EHAK_ID;
  EHAK_new.NIMI := :new.NIMI;
  EHAK_new.ROOPNIMI := :new.ROOPNIMI;
  EHAK_new.TYYP := :new.TYYP;
  EHAK_new.MAAKOND := :new.MAAKOND;
  EHAK_new.VALD := :new.VALD;
  EHAK_new.CREATED := :new.CREATED;
  EHAK_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  EHAK_new.USERNAME := :new.USERNAME;

  EHAK_old.EHAK_ID := :old.EHAK_ID;
  EHAK_old.NIMI := :old.NIMI;
  EHAK_old.ROOPNIMI := :old.ROOPNIMI;
  EHAK_old.TYYP := :old.TYYP;
  EHAK_old.MAAKOND := :old.MAAKOND;
  EHAK_old.VALD := :old.VALD;
  EHAK_old.CREATED := :old.CREATED;
  EHAK_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  EHAK_old.USERNAME := :old.USERNAME;

  DVKLOG.LOG_EHAK(
    EHAK_new,
    EHAK_old,
    operation
  );

END;
/
ALTER TRIGGER TR_EHAK_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_ISIK_LOG 
  after insert or update or delete
  on ISIK referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  ISIK_new ISIK%ROWTYPE;
  ISIK_old ISIK%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  ISIK_new.I_ID := :new.I_ID;
  ISIK_new.KOOD := :new.KOOD;
  ISIK_new.PERENIMI := :new.PERENIMI;
  ISIK_new.EESNIMI := :new.EESNIMI;
  ISIK_new.MAAKOND := :new.MAAKOND;
  ISIK_new.AADRESS := :new.AADRESS;
  ISIK_new.POSTIKOOD := :new.POSTIKOOD;
  ISIK_new.TELEFON := :new.TELEFON;
  ISIK_new.E_POST := :new.E_POST;
  ISIK_new.WWW := :new.WWW;
  ISIK_new.PARAMS := :new.PARAMS;
  ISIK_new.CREATED := :new.CREATED;
  ISIK_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  ISIK_new.USERNAME := :new.USERNAME;

  ISIK_old.I_ID := :old.I_ID;
  ISIK_old.KOOD := :old.KOOD;
  ISIK_old.PERENIMI := :old.PERENIMI;
  ISIK_old.EESNIMI := :old.EESNIMI;
  ISIK_old.MAAKOND := :old.MAAKOND;
  ISIK_old.AADRESS := :old.AADRESS;
  ISIK_old.POSTIKOOD := :old.POSTIKOOD;
  ISIK_old.TELEFON := :old.TELEFON;
  ISIK_old.E_POST := :old.E_POST;
  ISIK_old.WWW := :old.WWW;
  ISIK_old.PARAMS := :old.PARAMS;
  ISIK_old.CREATED := :old.CREATED;
  ISIK_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  ISIK_old.USERNAME := :old.USERNAME;

  DVKLOG.LOG_ISIK(
    ISIK_new,
    ISIK_old,
    operation
  );

END;
/
ALTER TRIGGER TR_ISIK_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_KAUST_LOG 
  after insert or update or delete
  on KAUST referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  kaust_new kaust%ROWTYPE;
  kaust_old kaust%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  kaust_new.kaust_id := :new.kaust_id;
  kaust_new.nimi := :new.nimi;
  kaust_new.ylemkaust_id := :new.ylemkaust_id;
  kaust_new.asutus_id := :new.asutus_id;
  kaust_new.kausta_number := :new.kausta_number;

  kaust_old.kaust_id := :old.kaust_id;
  kaust_old.nimi := :old.nimi;
  kaust_old.ylemkaust_id := :old.ylemkaust_id;
  kaust_old.asutus_id := :old.asutus_id;
  kaust_old.kausta_number := :old.kausta_number;

  DVKLOG.LOG_KAUST(
    kaust_new,
    kaust_old,
    operation
  );

END;
/
ALTER TRIGGER TR_KAUST_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_KLASSIFIKAATOR_LOG 
  after insert or update or delete
  on KLASSIFIKAATOR referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  KLASSIFIKAATOR_new KLASSIFIKAATOR%ROWTYPE;
  KLASSIFIKAATOR_old KLASSIFIKAATOR%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  KLASSIFIKAATOR_new.KLASSIFIKAATOR_ID := :new.KLASSIFIKAATOR_ID;
  KLASSIFIKAATOR_new.NIMETUS := :new.NIMETUS;
  KLASSIFIKAATOR_new.KLASSIFIKAATORI_TYYP_ID := :new.KLASSIFIKAATORI_TYYP_ID;

  KLASSIFIKAATOR_old.KLASSIFIKAATOR_ID := :old.KLASSIFIKAATOR_ID;
  KLASSIFIKAATOR_old.NIMETUS := :old.NIMETUS;
  KLASSIFIKAATOR_old.KLASSIFIKAATORI_TYYP_ID := :old.KLASSIFIKAATORI_TYYP_ID;

  DVKLOG.LOG_KLASSIFIKAATOR(
    KLASSIFIKAATOR_new,
    KLASSIFIKAATOR_old,
    operation
  );

END;
/
ALTER TRIGGER TR_KLASSIFIKAATOR_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_KLASSIFIKAATORI_TYYP_LOG 
  after insert or update or delete
  on KLASSIFIKAATORI_TYYP referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  KLASSIFIKAATORI_TYYP_new KLASSIFIKAATORI_TYYP%ROWTYPE;
  KLASSIFIKAATORI_TYYP_old KLASSIFIKAATORI_TYYP%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  KLASSIFIKAATORI_TYYP_new.KLASSIFIKAATORI_TYYP_ID := :new.KLASSIFIKAATORI_TYYP_ID;
  KLASSIFIKAATORI_TYYP_new.NIMETUS := :new.NIMETUS;

  KLASSIFIKAATORI_TYYP_old.KLASSIFIKAATORI_TYYP_ID := :old.KLASSIFIKAATORI_TYYP_ID;
  KLASSIFIKAATORI_TYYP_old.NIMETUS := :old.NIMETUS;
  
  DVKLOG.LOG_KLASSIFIKAATORI_TYYP(
    KLASSIFIKAATORI_TYYP_new,
    KLASSIFIKAATORI_TYYP_old,
    operation
  );

END;
/
ALTER TRIGGER TR_KLASSIFIKAATORI_TYYP_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_KONVERSIOON_LOG 
  after insert or update or delete
  on KONVERSIOON referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  KONVERSIOON_new KONVERSIOON%ROWTYPE;
  KONVERSIOON_old KONVERSIOON%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  KONVERSIOON_new.ID := :new.ID;
  KONVERSIOON_new.VERSION := :new.VERSION;
  KONVERSIOON_new.RESULT_VERSION := :new.RESULT_VERSION;
  KONVERSIOON_new.XSLT := :new.XSLT;

  KONVERSIOON_old.ID := :old.ID;
  KONVERSIOON_old.VERSION := :old.VERSION;
  KONVERSIOON_old.RESULT_VERSION := :old.RESULT_VERSION;
  KONVERSIOON_old.XSLT := :old.XSLT;

  DVKLOG.LOG_KONVERSIOON(
    KONVERSIOON_new,
    KONVERSIOON_old,
    operation
  );

END;
/
ALTER TRIGGER TR_KONVERSIOON_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_OIGUS_ANTUD_LOG 
  after insert or update or delete
  on OIGUS_ANTUD referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  OIGUS_ANTUD_new OIGUS_ANTUD%ROWTYPE;
  OIGUS_ANTUD_old OIGUS_ANTUD%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  OIGUS_ANTUD_new.OIGUS_ANTUD_ID := :new.OIGUS_ANTUD_ID;
  OIGUS_ANTUD_new.ASUTUS_ID := :new.ASUTUS_ID;
  OIGUS_ANTUD_new.MUU_ASUTUS_ID := :new.MUU_ASUTUS_ID;
  OIGUS_ANTUD_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  OIGUS_ANTUD_new.ROLL := :new.ROLL;
  OIGUS_ANTUD_new.ALATES := :new.ALATES;
  OIGUS_ANTUD_new.KUNI := :new.KUNI;
  OIGUS_ANTUD_new.CREATED := :new.CREATED;
  OIGUS_ANTUD_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  OIGUS_ANTUD_new.USERNAME := :new.USERNAME;
  OIGUS_ANTUD_new.PEATATUD := :new.PEATATUD;
  OIGUS_ANTUD_new.ALLYKSUS_ID := :new.ALLYKSUS_ID;

  OIGUS_ANTUD_old.OIGUS_ANTUD_ID := :old.OIGUS_ANTUD_ID;
  OIGUS_ANTUD_old.ASUTUS_ID := :old.ASUTUS_ID;
  OIGUS_ANTUD_old.MUU_ASUTUS_ID := :old.MUU_ASUTUS_ID;
  OIGUS_ANTUD_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  OIGUS_ANTUD_old.ROLL := :old.ROLL;
  OIGUS_ANTUD_old.ALATES := :old.ALATES;
  OIGUS_ANTUD_old.KUNI := :old.KUNI;
  OIGUS_ANTUD_old.CREATED := :old.CREATED;
  OIGUS_ANTUD_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  OIGUS_ANTUD_old.USERNAME := :old.USERNAME;
  OIGUS_ANTUD_old.PEATATUD := :old.PEATATUD;
  OIGUS_ANTUD_old.ALLYKSUS_ID := :old.ALLYKSUS_ID;

  DVKLOG.LOG_OIGUS_ANTUD(
    OIGUS_ANTUD_new,
    OIGUS_ANTUD_old,
    operation
  );

END;
/
ALTER TRIGGER TR_OIGUS_ANTUD_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_OIGUS_OBJEKTILE_LOG 
  after insert or update or delete
  on OIGUS_OBJEKTILE referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  OIGUS_OBJEKTILE_new OIGUS_OBJEKTILE%ROWTYPE;
  OIGUS_OBJEKTILE_old OIGUS_OBJEKTILE%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  OIGUS_OBJEKTILE_new.OIGUS_OBJEKTILE_ID := :new.OIGUS_OBJEKTILE_ID;
  OIGUS_OBJEKTILE_new.ASUTUS_ID := :new.ASUTUS_ID;
  OIGUS_OBJEKTILE_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  OIGUS_OBJEKTILE_new.DOKUMENT_ID := :new.DOKUMENT_ID;
  OIGUS_OBJEKTILE_new.KAUST_ID := :new.KAUST_ID;
  OIGUS_OBJEKTILE_new.KEHTIB_ALATES := :new.KEHTIB_ALATES;
  OIGUS_OBJEKTILE_new.KEHTIB_KUNI := :new.KEHTIB_KUNI;

  OIGUS_OBJEKTILE_old.OIGUS_OBJEKTILE_ID := :old.OIGUS_OBJEKTILE_ID;
  OIGUS_OBJEKTILE_old.ASUTUS_ID := :old.ASUTUS_ID;
  OIGUS_OBJEKTILE_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  OIGUS_OBJEKTILE_old.DOKUMENT_ID := :old.DOKUMENT_ID;
  OIGUS_OBJEKTILE_old.KAUST_ID := :old.KAUST_ID;
  OIGUS_OBJEKTILE_old.KEHTIB_ALATES := :old.KEHTIB_ALATES;
  OIGUS_OBJEKTILE_old.KEHTIB_KUNI := :old.KEHTIB_KUNI;

  DVKLOG.LOG_OIGUS_OBJEKTILE(
    OIGUS_OBJEKTILE_new,
    OIGUS_OBJEKTILE_old,
    operation
  );

END;
/
ALTER TRIGGER TR_OIGUS_OBJEKTILE_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_PARAMEETRID_LOG 
  after insert or update or delete
  on PARAMEETRID referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  PARAMEETRID_new PARAMEETRID%ROWTYPE;
  PARAMEETRID_old PARAMEETRID%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  PARAMEETRID_new.AAR_VIIMANE_SYNC := :new.AAR_VIIMANE_SYNC;
  
  PARAMEETRID_old.AAR_VIIMANE_SYNC := :old.AAR_VIIMANE_SYNC;

  DVKLOG.LOG_PARAMEETRID(
    PARAMEETRID_new,
    PARAMEETRID_old,
    operation
  );

END;
/
ALTER TRIGGER TR_PARAMEETRID_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_SAATJA_LOG 
  after insert or update or delete
  on SAATJA referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  saatja_new saatja%ROWTYPE;
  saatja_old saatja%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  saatja_new.saatja_id := :new.saatja_id;
  saatja_new.transport_id := :new.transport_id;
  saatja_new.asutus_id := :new.asutus_id;
  saatja_new.ametikoht_id := :new.ametikoht_id;
  saatja_new.isikukood := :new.isikukood;
  saatja_new.nimi := :new.nimi;
  saatja_new.email := :new.email;
  saatja_new.osakonna_nr := :new.osakonna_nr;
  saatja_new.osakonna_nimi := :new.osakonna_nimi;
  saatja_new.asutuse_nimi := :new.asutuse_nimi;
  saatja_new.allyksus_id := :new.allyksus_id;
  saatja_new.allyksuse_lyhinimetus := :new.allyksuse_lyhinimetus;
  saatja_new.ametikoha_lyhinimetus := :new.ametikoha_lyhinimetus;

  saatja_old.saatja_id := :old.saatja_id;
  saatja_old.transport_id := :old.transport_id;
  saatja_old.asutus_id := :old.asutus_id;
  saatja_old.ametikoht_id := :old.ametikoht_id;
  saatja_old.isikukood := :old.isikukood;
  saatja_old.nimi := :old.nimi;
  saatja_old.email := :old.email;
  saatja_old.osakonna_nr := :old.osakonna_nr;
  saatja_old.osakonna_nimi := :old.osakonna_nimi;
  saatja_old.asutuse_nimi := :old.asutuse_nimi;
  saatja_old.allyksus_id := :old.allyksus_id;
  saatja_old.allyksuse_lyhinimetus := :old.allyksuse_lyhinimetus;
  saatja_old.ametikoha_lyhinimetus := :old.ametikoha_lyhinimetus;

  DVKLOG.LOG_SAATJA(
    saatja_new,
    saatja_old,
    operation
  );

END;
/
ALTER TRIGGER TR_SAATJA_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_SERVER_LOG 
  after insert or update or delete
  on SERVER referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  SERVER_new SERVER%ROWTYPE;
  SERVER_old SERVER%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  SERVER_new.SERVER_ID := :new.SERVER_ID;
  SERVER_new.ANDMEKOGU_NIMI := :new.ANDMEKOGU_NIMI;
  SERVER_new.AADRESS := :new.AADRESS;

  SERVER_old.SERVER_ID := :old.SERVER_ID;
  SERVER_old.ANDMEKOGU_NIMI := :old.ANDMEKOGU_NIMI;
  SERVER_old.AADRESS := :old.AADRESS;

  DVKLOG.LOG_SERVER(
    SERVER_new,
    SERVER_old,
    operation
  );

END;
/
ALTER TRIGGER TR_SERVER_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_STAATUSE_AJALUGU_LOG 
  after insert or update or delete
  on STAATUSE_AJALUGU referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  staatuse_ajalugu_new staatuse_ajalugu%ROWTYPE;
  staatuse_ajalugu_old staatuse_ajalugu%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  staatuse_ajalugu_new.STAATUSE_AJALUGU_ID := :new.STAATUSE_AJALUGU_ID;
  staatuse_ajalugu_new.VASTUVOTJA_ID := :new.VASTUVOTJA_ID;
  staatuse_ajalugu_new.STAATUS_ID := :new.STAATUS_ID;
  staatuse_ajalugu_new.STAATUSE_MUUTMISE_AEG := :new.STAATUSE_MUUTMISE_AEG;
  staatuse_ajalugu_new.FAULT_CODE := :new.FAULT_CODE;
  staatuse_ajalugu_new.FAULT_ACTOR := :new.FAULT_ACTOR;
  staatuse_ajalugu_new.FAULT_STRING := :new.FAULT_STRING;
  staatuse_ajalugu_new.FAULT_DETAIL := :new.FAULT_DETAIL;
  staatuse_ajalugu_new.VASTUVOTJA_STAATUS_ID := :new.VASTUVOTJA_STAATUS_ID;
  staatuse_ajalugu_new.METAXML := :new.METAXML;

  staatuse_ajalugu_old.STAATUSE_AJALUGU_ID := :old.STAATUSE_AJALUGU_ID;
  staatuse_ajalugu_old.VASTUVOTJA_ID := :old.VASTUVOTJA_ID;
  staatuse_ajalugu_old.STAATUS_ID := :old.STAATUS_ID;
  staatuse_ajalugu_old.STAATUSE_MUUTMISE_AEG := :old.STAATUSE_MUUTMISE_AEG;
  staatuse_ajalugu_old.FAULT_CODE := :old.FAULT_CODE;
  staatuse_ajalugu_old.FAULT_ACTOR := :old.FAULT_ACTOR;
  staatuse_ajalugu_old.FAULT_STRING := :old.FAULT_STRING;
  staatuse_ajalugu_old.FAULT_DETAIL := :old.FAULT_DETAIL;
  staatuse_ajalugu_old.VASTUVOTJA_STAATUS_ID := :old.VASTUVOTJA_STAATUS_ID;
  staatuse_ajalugu_old.METAXML := :old.METAXML;

  DVKLOG.LOG_STAATUSE_AJALUGU(
    staatuse_ajalugu_new,
    staatuse_ajalugu_old,
    operation
  );

END;
/
ALTER TRIGGER TR_STAATUSE_AJALUGU_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_TRANSPORT_LOG 
  after insert or update or delete
  on TRANSPORT referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  transport_new transport%ROWTYPE;
  transport_old transport%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  transport_new.transport_id := :new.transport_id;
  transport_new.dokument_id := :new.dokument_id;
  transport_new.saatmise_algus := :new.saatmise_algus;
  transport_new.saatmise_lopp := :new.saatmise_lopp;
  transport_new.staatus_id := :new.staatus_id;

  transport_old.transport_id := :old.transport_id;
  transport_old.dokument_id := :old.dokument_id;
  transport_old.saatmise_algus := :old.saatmise_algus;
  transport_old.saatmise_lopp := :old.saatmise_lopp;
  transport_old.staatus_id := :old.staatus_id;

  DVKLOG.LOG_TRANSPORT(
    transport_new,
    transport_old,
    operation
  );

END;
/
ALTER TRIGGER TR_TRANSPORT_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_VAHENDAJA_LOG 
  after insert or update or delete
  on VAHENDAJA referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  vahendaja_new vahendaja%ROWTYPE;
  vahendaja_old vahendaja%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  vahendaja_new.VAHENDAJA_ID := :new.VAHENDAJA_ID;
  vahendaja_new.TRANSPORT_ID := :new.TRANSPORT_ID;
  vahendaja_new.ASUTUS_ID := :new.ASUTUS_ID;
  vahendaja_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  vahendaja_new.ISIKUKOOD := :new.ISIKUKOOD;
  vahendaja_new.NIMI := :new.NIMI;
  vahendaja_new.EMAIL := :new.EMAIL;
  vahendaja_new.OSAKONNA_NR := :new.OSAKONNA_NR;
  vahendaja_new.OSAKONNA_NIMI := :new.OSAKONNA_NIMI;
  vahendaja_new.ASUTUSE_NIMI := :new.ASUTUSE_NIMI;
  vahendaja_new.ALLYKSUS_ID := :new.ALLYKSUS_ID;
  vahendaja_new.ALLYKSUSE_LYHINIMETUS := :new.ALLYKSUSE_LYHINIMETUS;
  vahendaja_new.AMETIKOHA_LYHINIMETUS := :new.AMETIKOHA_LYHINIMETUS;

  vahendaja_old.VAHENDAJA_ID := :old.VAHENDAJA_ID;
  vahendaja_old.TRANSPORT_ID := :old.TRANSPORT_ID;
  vahendaja_old.ASUTUS_ID := :old.ASUTUS_ID;
  vahendaja_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  vahendaja_old.ISIKUKOOD := :old.ISIKUKOOD;
  vahendaja_old.NIMI := :old.NIMI;
  vahendaja_old.EMAIL := :old.EMAIL;
  vahendaja_old.OSAKONNA_NR := :old.OSAKONNA_NR;
  vahendaja_old.OSAKONNA_NIMI := :old.OSAKONNA_NIMI;
  vahendaja_old.ASUTUSE_NIMI := :old.ASUTUSE_NIMI;
  vahendaja_old.ALLYKSUS_ID := :old.ALLYKSUS_ID;
  vahendaja_old.ALLYKSUSE_LYHINIMETUS := :old.ALLYKSUSE_LYHINIMETUS;
  vahendaja_old.AMETIKOHA_LYHINIMETUS := :old.AMETIKOHA_LYHINIMETUS;

  DVKLOG.LOG_VAHENDAJA(
    vahendaja_new,
    vahendaja_old,
    operation
  );

END;
/
ALTER TRIGGER TR_VAHENDAJA_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_VASTUVOTJA_LOG 
  after insert or update or delete
  on VASTUVOTJA referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  vastuvotja_new vastuvotja%ROWTYPE;
  vastuvotja_old vastuvotja%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  vastuvotja_new.VASTUVOTJA_ID := :new.VASTUVOTJA_ID;
  vastuvotja_new.TRANSPORT_ID := :new.TRANSPORT_ID;
  vastuvotja_new.ASUTUS_ID := :new.ASUTUS_ID;
  vastuvotja_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  vastuvotja_new.ISIKUKOOD := :new.ISIKUKOOD;
  vastuvotja_new.NIMI := :new.NIMI;
  vastuvotja_new.EMAIL := :new.EMAIL;
  vastuvotja_new.OSAKONNA_NR := :new.OSAKONNA_NR;
  vastuvotja_new.OSAKONNA_NIMI := :new.OSAKONNA_NIMI;
  vastuvotja_new.SAATMISVIIS_ID := :new.SAATMISVIIS_ID;
  vastuvotja_new.STAATUS_ID := :new.STAATUS_ID;
  vastuvotja_new.SAATMISE_ALGUS := :new.SAATMISE_ALGUS;
  vastuvotja_new.SAATMISE_LOPP := :new.SAATMISE_LOPP;
  vastuvotja_new.FAULT_CODE := :new.FAULT_CODE;
  vastuvotja_new.FAULT_ACTOR := :new.FAULT_ACTOR;
  vastuvotja_new.FAULT_STRING := :new.FAULT_STRING;
  vastuvotja_new.FAULT_DETAIL := :new.FAULT_DETAIL;
  vastuvotja_new.VASTUVOTJA_STAATUS_ID := :new.VASTUVOTJA_STAATUS_ID;
  vastuvotja_new.METAXML := :new.METAXML;
  vastuvotja_new.ASUTUSE_NIMI := :new.ASUTUSE_NIMI;
  vastuvotja_new.ALLYKSUS_ID := :new.ALLYKSUS_ID;
  vastuvotja_new.DOK_ID_TEISES_SERVERIS := :new.DOK_ID_TEISES_SERVERIS;
  vastuvotja_new.ALLYKSUSE_LYHINIMETUS := :new.ALLYKSUSE_LYHINIMETUS;
  vastuvotja_new.AMETIKOHA_LYHINIMETUS := :new.AMETIKOHA_LYHINIMETUS;

  vastuvotja_old.VASTUVOTJA_ID := :old.VASTUVOTJA_ID;
  vastuvotja_old.TRANSPORT_ID := :old.TRANSPORT_ID;
  vastuvotja_old.ASUTUS_ID := :old.ASUTUS_ID;
  vastuvotja_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  vastuvotja_old.ISIKUKOOD := :old.ISIKUKOOD;
  vastuvotja_old.NIMI := :old.NIMI;
  vastuvotja_old.EMAIL := :old.EMAIL;
  vastuvotja_old.OSAKONNA_NR := :old.OSAKONNA_NR;
  vastuvotja_old.OSAKONNA_NIMI := :old.OSAKONNA_NIMI;
  vastuvotja_old.SAATMISVIIS_ID := :old.SAATMISVIIS_ID;
  vastuvotja_old.STAATUS_ID := :old.STAATUS_ID;
  vastuvotja_old.SAATMISE_ALGUS := :old.SAATMISE_ALGUS;
  vastuvotja_old.SAATMISE_LOPP := :old.SAATMISE_LOPP;
  vastuvotja_old.FAULT_CODE := :old.FAULT_CODE;
  vastuvotja_old.FAULT_ACTOR := :old.FAULT_ACTOR;
  vastuvotja_old.FAULT_STRING := :old.FAULT_STRING;
  vastuvotja_old.FAULT_DETAIL := :old.FAULT_DETAIL;
  vastuvotja_old.VASTUVOTJA_STAATUS_ID := :old.VASTUVOTJA_STAATUS_ID;
  vastuvotja_old.METAXML := :old.METAXML;
  vastuvotja_old.ASUTUSE_NIMI := :old.ASUTUSE_NIMI;
  vastuvotja_old.ALLYKSUS_ID := :old.ALLYKSUS_ID;
  vastuvotja_old.DOK_ID_TEISES_SERVERIS := :old.DOK_ID_TEISES_SERVERIS;
  vastuvotja_old.ALLYKSUSE_LYHINIMETUS := :old.ALLYKSUSE_LYHINIMETUS;
  vastuvotja_old.AMETIKOHA_LYHINIMETUS := :old.AMETIKOHA_LYHINIMETUS;

  DVKLOG.LOG_VASTUVOTJA(
    vastuvotja_new,
    vastuvotja_old,
    operation
  );

END;
/
ALTER TRIGGER TR_VASTUVOTJA_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_VASTUVOTJA_MALL_LOG 
  after insert or update or delete
  on VASTUVOTJA_MALL referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  VASTUVOTJA_MALL_new VASTUVOTJA_MALL%ROWTYPE;
  VASTUVOTJA_MALL_old VASTUVOTJA_MALL%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  VASTUVOTJA_MALL_new.VASTUVOTJA_MALL_ID := :new.VASTUVOTJA_MALL_ID;
  VASTUVOTJA_MALL_new.ASUTUS_ID := :new.ASUTUS_ID;
  VASTUVOTJA_MALL_new.AMETIKOHT_ID := :new.AMETIKOHT_ID;
  VASTUVOTJA_MALL_new.ISIKUKOOD := :new.ISIKUKOOD;
  VASTUVOTJA_MALL_new.NIMI := :new.NIMI;
  VASTUVOTJA_MALL_new.EMAIL := :new.EMAIL;
  VASTUVOTJA_MALL_new.OSAKONNA_NR := :new.OSAKONNA_NR;
  VASTUVOTJA_MALL_new.OSAKONNA_NIMI := :new.OSAKONNA_NIMI;
  VASTUVOTJA_MALL_new.SAATMISVIIS_ID := :new.SAATMISVIIS_ID;
  VASTUVOTJA_MALL_new.ASUTUSE_NIMI := :new.ASUTUSE_NIMI;
  VASTUVOTJA_MALL_new.ALLYKSUS_ID := :new.ALLYKSUS_ID;
  VASTUVOTJA_MALL_new.TINGIMUS_XPATH := :new.TINGIMUS_XPATH;
  VASTUVOTJA_MALL_new.ALLYKSUSE_LYHINIMETUS := :new.ALLYKSUSE_LYHINIMETUS;
  VASTUVOTJA_MALL_new.AMETIKOHA_LYHINIMETUS := :new.AMETIKOHA_LYHINIMETUS;

  VASTUVOTJA_MALL_old.VASTUVOTJA_MALL_ID := :old.VASTUVOTJA_MALL_ID;
  VASTUVOTJA_MALL_old.ASUTUS_ID := :old.ASUTUS_ID;
  VASTUVOTJA_MALL_old.AMETIKOHT_ID := :old.AMETIKOHT_ID;
  VASTUVOTJA_MALL_old.ISIKUKOOD := :old.ISIKUKOOD;
  VASTUVOTJA_MALL_old.NIMI := :old.NIMI;
  VASTUVOTJA_MALL_old.EMAIL := :old.EMAIL;
  VASTUVOTJA_MALL_old.OSAKONNA_NR := :old.OSAKONNA_NR;
  VASTUVOTJA_MALL_old.OSAKONNA_NIMI := :old.OSAKONNA_NIMI;
  VASTUVOTJA_MALL_old.SAATMISVIIS_ID := :old.SAATMISVIIS_ID;
  VASTUVOTJA_MALL_old.ASUTUSE_NIMI := :old.ASUTUSE_NIMI;
  VASTUVOTJA_MALL_old.ALLYKSUS_ID := :old.ALLYKSUS_ID;
  VASTUVOTJA_MALL_old.TINGIMUS_XPATH := :old.TINGIMUS_XPATH;
  VASTUVOTJA_MALL_old.ALLYKSUSE_LYHINIMETUS := :old.ALLYKSUSE_LYHINIMETUS;
  VASTUVOTJA_MALL_old.AMETIKOHA_LYHINIMETUS := :old.AMETIKOHA_LYHINIMETUS;

  DVKLOG.LOG_VASTUVOTJA_MALL(
    VASTUVOTJA_MALL_new,
    VASTUVOTJA_MALL_old,
    operation
  );

END;
/
ALTER TRIGGER TR_VASTUVOTJA_MALL_LOG ENABLE;
 

  CREATE OR REPLACE TRIGGER TR_VASTUVOTJA_STAATUS_LOG 
  after insert or update or delete
  on VASTUVOTJA_STAATUS referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  VASTUVOTJA_STAATUS_new VASTUVOTJA_STAATUS%ROWTYPE;
  VASTUVOTJA_STAATUS_old VASTUVOTJA_STAATUS%ROWTYPE;
BEGIN

  if inserting then
    operation := 'INSERT';
  else
    if updating then
      operation := 'UPDATE';
    else
      operation := 'DELETE';
    end if;
  end if;

  VASTUVOTJA_STAATUS_new.VASTUVOTJA_STAATUS_ID := :new.VASTUVOTJA_STAATUS_ID;
  VASTUVOTJA_STAATUS_new.NIMETUS := :new.NIMETUS;

  VASTUVOTJA_STAATUS_old.VASTUVOTJA_STAATUS_ID := :old.VASTUVOTJA_STAATUS_ID;
  VASTUVOTJA_STAATUS_old.NIMETUS := :old.NIMETUS;

  DVKLOG.LOG_VASTUVOTJA_STAATUS(
    VASTUVOTJA_STAATUS_new,
    VASTUVOTJA_STAATUS_old,
    operation
  );

END;
/

create or replace
TRIGGER TR_LOGI_LOG
  after update or delete
  on LOGI referencing old as old new as new
  for each row
DECLARE
  operation varchar2(100);
  logi_new logi%ROWTYPE;
  logi_old logi%ROWTYPE;
BEGIN

  if updating then
    operation := 'UPDATE';
  else
    operation := 'DELETE';
  end if;

  logi_new.LOG_ID := :new.LOG_ID;
  logi_new.TABEL := :new.TABEL;
  logi_new.OP := :new.OP;
  logi_new.UIDCOL := :new.UIDCOL;
  logi_new.TABEL_UID := :new.TABEL_UID;
  logi_new.VEERG := :new.VEERG;
  logi_new.CTYPE := :new.CTYPE;
  logi_new.VANA_VAARTUS := :new.VANA_VAARTUS;
  logi_new.UUS_VAARTUS := :new.UUS_VAARTUS;
  logi_new.MUUTMISE_AEG := :new.MUUTMISE_AEG;
  logi_new.AB_KASUTAJA := :new.AB_KASUTAJA;
  logi_new.EF_KASUTAJA := :new.EF_KASUTAJA;
  logi_new.KASUTAJA_KOOD := :new.KASUTAJA_KOOD;
  logi_new.COMM := :new.COMM;
  logi_new.CREATED := :new.CREATED;
  logi_new.LAST_MODIFIED := :new.LAST_MODIFIED;
  logi_new.USERNAME := :new.USERNAME;
  logi_new.AMETIKOHT := :new.AMETIKOHT;
  logi_new.XTEE_ISIKUKOOD := :new.XTEE_ISIKUKOOD;
  logi_new.XTEE_ASUTUS := :new.XTEE_ASUTUS;
  
  logi_old.LOG_ID := :old.LOG_ID;
  logi_old.TABEL := :old.TABEL;
  logi_old.OP := :old.OP;
  logi_old.UIDCOL := :old.UIDCOL;
  logi_old.TABEL_UID := :old.TABEL_UID;
  logi_old.VEERG := :old.VEERG;
  logi_old.CTYPE := :old.CTYPE;
  logi_old.VANA_VAARTUS := :old.VANA_VAARTUS;
  logi_old.UUS_VAARTUS := :old.UUS_VAARTUS;
  logi_old.MUUTMISE_AEG := :old.MUUTMISE_AEG;
  logi_old.AB_KASUTAJA := :old.AB_KASUTAJA;
  logi_old.EF_KASUTAJA := :old.EF_KASUTAJA;
  logi_old.KASUTAJA_KOOD := :old.KASUTAJA_KOOD;
  logi_old.COMM := :old.COMM;
  logi_old.CREATED := :old.CREATED;
  logi_old.LAST_MODIFIED := :old.LAST_MODIFIED;
  logi_old.USERNAME := :old.USERNAME;
  logi_old.AMETIKOHT := :old.AMETIKOHT;
  logi_old.XTEE_ISIKUKOOD := :old.XTEE_ISIKUKOOD;
  logi_old.XTEE_ASUTUS := :old.XTEE_ASUTUS;

  DVKLOG.LOG_LOGI(
    logi_new,
    logi_old,
    operation
  );

END;
/

ALTER TRIGGER TR_VASTUVOTJA_STAATUS_LOG ENABLE;
/ 
