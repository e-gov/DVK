ALTER TABLE
    dokument
DROP (
    suurus,
    GUID,
    versioon
)
/

alter
table   allyksus
drop
(
    lyhinimetus,
    adr_uri
)
/

drop index "ALLYKSUS_LYHINIMETUS_IDX";
/

alter
table   ametikoht
drop
(
    lyhinimetus
)
/

alter
table   saatja
drop
(
    allyksuse_lyhinimetus,
    ametikoha_lyhinimetus
)
/

alter
table   vastuvotja
drop
(
    allyksuse_lyhinimetus,
    ametikoha_lyhinimetus
)
/

alter
table   vahendaja
drop
(
    allyksuse_lyhinimetus,
    ametikoha_lyhinimetus
)
/

alter
table   vastuvotja_mall
drop
(
    allyksuse_lyhinimetus,
    ametikoha_lyhinimetus
)
/

drop index "AMETIKOHT_LYHINIMETUS_IDX";

alter table logi drop (
  xtee_isikukood,
  xtee_asutus
)
/

drop INDEX "AMETIKOHT_ID_SN_IDX";
/

drop INDEX "ALLYKSUS_ID_SN_IDX";
/

drop trigger tr_staatuse_ajalugu_id;
/

drop sequence sq_staatuse_ajalugu_id;
/

drop table staatuse_ajalugu;
/

drop INDEX "STAATUSE_AJALUGU_FK1_IDX";
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

drop procedure Get_AmetikohtIdByShortName;
/

drop procedure Get_AllyksusIdByShortName;
/

drop procedure Get_AllyksusStat;
/

drop procedure Get_AmetikohtStat;
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

drop procedure Get_DocumentStatusHistory;
/

drop procedure Get_LastSendingByDocGUID;
/

drop PROCEDURE ADD_DOKUMENT;
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

drop PROCEDURE ADD_DOKUMENT_FRAGMENT;
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

drop PROCEDURE ADD_STAATUSE_AJALUGU;
/

DROP PROCEDURE ADD_VASTUVOTJA;
/

drop PROCEDURE UPDATE_VASTUVOTJA;
/

DROP PACKAGE DVKLOG;

DROP TRIGGER TR_ALLKIRI_LOG;
/


DROP TRIGGER TR_ALLYKSUS_LOG;
/


DROP TRIGGER TR_AMETIKOHT_LOG;
/

DROP TRIGGER TR_AMETIKOHT_TAITMINE_LOG;
/

DROP TRIGGER TR_ASUTUS_LOG;
/

DROP TRIGGER TR_DOKUMENDI_AJALUGU_LOG;
/

DROP TRIGGER TR_DOKUMENDI_FAIL_LOG;
/

DROP TRIGGER TR_DOKUMENT_LOG;

DROP TRIGGER TR_DOKUMENDI_METAANDMED_LOG;
/

DROP TRIGGER TR_DYNAAMILISED_METAANDMED_LOG;
/

DROP TRIGGER TR_EHAK_LOG;
/

DROP TRIGGER TR_ISIK_LOG;
/

DROP TRIGGER TR_KAUST_LOG;
/

DROP TRIGGER TR_KLASSIFIKAATOR_LOG;
/

DROP TRIGGER TR_KLASSIFIKAATORI_TYYP_LOG;
/

DROP TRIGGER TR_KONVERSIOON_LOG;
/

DROP TRIGGER TR_OIGUS_ANTUD_LOG;
/

DROP TRIGGER TR_OIGUS_OBJEKTILE_LOG;
/

DROP TRIGGER TR_PARAMEETRID_LOG;
/

DROP TRIGGER TR_SAATJA_LOG;
/

DROP TRIGGER TR_SERVER_LOG;
/

DROP TRIGGER TR_STAATUSE_AJALUGU_LOG;
/

DROP TRIGGER TR_TRANSPORT_LOG;
/

DROP TRIGGER TR_VAHENDAJA_LOG;
/

DROP TRIGGER TR_VASTUVOTJA_LOG;
/

DROP TRIGGER TR_VASTUVOTJA_MALL_LOG;
/

DROP TRIGGER TR_VASTUVOTJA_STAATUS_LOG;
/

DROP TRIGGER TR_LOGI_LOG;
/
