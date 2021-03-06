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
