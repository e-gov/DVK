create table dhl_settings_folders
(
    id number(10,0) not null,
    dhl_settings_id number(10,0) not null,
    folder_name varchar2(4000) null
)
/

ALTER TABLE dhl_settings_folders
ADD CONSTRAINT PK_dhl_settings_folders
PRIMARY KEY (id)
/

ALTER TABLE dhl_settings_folders
ADD CONSTRAINT FK_dhl_settings_folders
FOREIGN KEY (dhl_settings_id)
REFERENCES dhl_settings(id) ON DELETE CASCADE
/

create sequence sq_dhl_setfldr_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create or replace
trigger tr_dhl_setfldr_id
    before insert
    on dhl_settings_folders
    for each row
begin
    if (:new.id < 1) then
        select  sq_dhl_setfldr_id.nextval
        into    globalPkg.identity
        from    dual;
        :new.id := globalPkg.identity;
    end if;
end;
/

create or replace
procedure Update_DhlMessageStatus(
    dhl_id in number,
    status_id in number,
    error_message in varchar2,
    is_incoming in number)
as
begin
    update  dhl_message
    set     sending_status_id = Update_DhlMessageStatus.status_id,
            error_message = Update_DhlMessageStatus.error_message
    where   dhl_id = Update_DhlMessageStatus.dhl_id
            and is_incoming = Update_DhlMessageStatus.is_incoming;
end;
/

create procedure Get_DhlSettingFolders(
    dhl_settings_id in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  folder_name
    from    dhl_settings_folders
    where   dhl_settings_id = Get_DhlSettingFolders.dhl_settings_id;
end;
/
