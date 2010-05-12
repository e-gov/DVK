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

CREATE OR REPLACE
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

