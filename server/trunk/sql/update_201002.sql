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