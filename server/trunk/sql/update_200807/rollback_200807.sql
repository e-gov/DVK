alter
table   asutus
drop
(
        dhs_nimetus,
        toetatav_dvk_versioon,
        server_id,
        aar_id
);

alter
table   allyksus
drop column aar_id;

alter
table   ametikoht
drop column aar_id;

alter
table   ametikoht_taitmine
drop column aar_id;

alter
table   oigus_antud
drop column allyksus_id;

alter
table   saatja
drop
(
    asutuse_nimi,
    allyksus_id
);

alter
table   vastuvotja
drop
(
    asutuse_nimi,
    allyksus_id,
    dok_id_teises_serveris
);

drop trigger tr_vastuvotja_mall_id;
drop table vastuvotja_mall cascade constraints;
drop sequence sq_vastuvotja_mall_id;
drop table server cascade constraints;
drop trigger tr_vahendaja_id;
drop sequence sq_vahendaja_id;
drop table vahendaja cascade constraints;
drop table dokumendi_fragment cascade constraints;
drop sequence sq_dokumendi_fragment_id;
drop table parameetrid cascade constraints;
drop procedure Get_Parameters;
drop procedure Save_Parameters;
drop procedure Get_ExpiredDocuments;
drop procedure Update_DocumentExpirationDate;
drop procedure Delete_Document;
drop procedure Get_SenderBySendingID;
drop procedure Add_Sender;
drop procedure Get_AsutusByID;
drop procedure Get_AsutusByRegNr;
drop procedure Get_AsutusList;
drop procedure Add_Asutus;
drop procedure Update_Asutus;
drop procedure Get_PersonCurrentDivisionIDs;
drop procedure Get_AsutusStat;
drop procedure Get_RecipientTemplates;
drop procedure Get_ServerByID;
drop procedure Add_Proxy;
drop procedure Get_ProxyBySendingID;
drop procedure Get_Servers;
drop procedure Get_NextFragmentID;
drop procedure Get_DocumentFragments;
drop procedure Delete_DocumentFragments;
drop procedure Get_AsutusIDByAarID;
drop procedure Get_AllyksusByAarID;
drop procedure Get_AllyksusIdByAarID;
drop procedure Get_AllyksusList;
drop procedure Add_Allyksus;
drop procedure Update_Allyksus;
drop procedure Get_AmetikohaTaitmineByAarID;
drop procedure Get_AmetikohaTaitmineList;
drop procedure Add_AmetikohaTaitmine;
drop procedure Update_AmetikohaTaitmine;
drop procedure Get_AmetikohtByAarID;
drop procedure Get_AmetikohtIdByAarID;
drop procedure Get_AmetikohtList;
drop procedure Add_Ametikoht;
drop procedure Update_Ametikoht;
drop procedure Get_IsikByCode;
drop procedure Add_Isik;
drop procedure Update_Isik;
/


create or replace
procedure Get_SenderBySendingID(
    sending_id in number,
    sender_id out number,
    organization_id out number,
    position_id out number,
    personal_id_code out varchar2,
    name out varchar2,
    email out varchar2,
    department_nr out varchar2,
    department_name out varchar2)
as
begin
    select  s.saatja_id,
            s.asutus_id,
            s.ametikoht_id,
            s.isikukood,
            s.nimi,
            s.email,
            s.osakonna_nr,
            s.osakonna_nimi
    into    Get_SenderBySendingID.sender_id,
            Get_SenderBySendingID.organization_id,
            Get_SenderBySendingID.position_id,
            Get_SenderBySendingID.personal_id_code,
            Get_SenderBySendingID.name,
            Get_SenderBySendingID.email,
            Get_SenderBySendingID.department_nr,
            Get_SenderBySendingID.department_name
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
    personal_id_code in varchar2,
    email in varchar2,
    name in varchar2,
    department_nr in varchar2,
    department_name in varchar2)
as
organization_id_ number(38,0) := organization_id;
position_id_ number(38,0) := position_id;
begin
    if organization_id_ = 0 then
        organization_id_ := null;
    end if;
    if position_id_ = 0 then
        position_id_ := null;
    end if;

    insert
    into    saatja(
            saatja_id,
            transport_id,
            asutus_id,
            ametikoht_id,
            isikukood,
            nimi,
            email,
            osakonna_nr,
            osakonna_nimi)
    values  (0,
            Add_Sender.sending_id,
            Add_Sender.organization_id_,
            Add_Sender.position_id_,
            Add_Sender.personal_id_code,
            Add_Sender.name,
            Add_Sender.email,
            Add_Sender.department_nr,
            Add_Sender.department_name);
    
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
    RC1 out globalPkg.RCT1)
as
begin
    open RC1 for
    select  a.*
    from    dokument a, transport b, vastuvotja c
    where   a.dokument_id = b.dokument_id
            and b.transport_id = c.transport_id
            and c.asutus_id = Get_DocumentsSentTo.organization_id
            and c.staatus_id = 101
            and
            (
                Get_DocumentsSentTo.folder_id is null
                or a.kaust_id = Get_DocumentsSentTo.folder_id
            );
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
    dhl_otse_saatmine out number)
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
                a.dhl_otse_saatmine
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
                Get_AsutusByRegNr.dhl_otse_saatmine
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
        Get_AsutusByRegNr.dhl_otse_saatmine := null;
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
    dhl_otse_saatmine out number)
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
                a.dhl_otse_saatmine
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
                Get_AsutusByID.dhl_otse_saatmine
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
        Get_AsutusByID.dhl_otse_saatmine := null;
    end if;
end;
/

create or replace
procedure Get_AsutusIDByRegNr(
    registrikood in varchar2,
    id out number)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Get_AsutusIDByRegNr.registrikood;
    
    if cnt > 0 then
        select  a.asutus_id
        into    Get_AsutusIDByRegNr.id
        from    asutus a
        where   a.registrikood = Get_AsutusIDByRegNr.registrikood
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
    where   dhl_saatmine = 1;
end;
/
