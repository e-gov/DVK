CREATE OR REPLACE
PACKAGE globalPkg AUTHID CURRENT_USER AS
    identity number(38,0);
    log_identity number(38,0);
    TYPE RCT1 IS REF CURSOR;
END;
/

CREATE TABLE dhl_message
(
    dhl_message_id number(10,0) NOT NULL,
    is_incoming number(1,0) NOT NULL,
    data clob NOT NULL,
    title varchar2 (1000) NULL,
    sender_org_code varchar2 (20) NULL,
    sender_org_name varchar2 (100) NULL,
    sender_person_code varchar2 (20) NULL,
    sender_name varchar2 (100) NULL,
    recipient_org_code varchar2 (20) NULL,
    recipient_org_name varchar2 (100) NULL,
    recipient_person_code varchar2 (20) NULL,
    recipient_name varchar2 (100) NULL,
    case_name varchar2 (250) NULL,
    dhl_folder_name varchar2 (1000) NULL,
    sending_status_id number(10,0) NOT NULL,
    unit_id number(10,0) NOT NULL,
    dhl_id number(10,0) NULL,
    sending_date date NULL,
    received_date date NULL,
    local_item_id number(10,0) NULL,
    recipient_status_id number(10,0),
    fault_code varchar2(50) NULL,
    fault_actor varchar2(250) NULL,
    fault_string varchar2(500) NULL,
    fault_detail varchar2(2000) NULL,
    status_update_needed number(10,0) NULL,
    metaxml clob NULL,
    query_id varchar2(50) null,
    proxy_org_code varchar2(20) null,
    proxy_org_name varchar2(100) null,
    proxy_person_code varchar2(20) null,
    proxy_name varchar2(100) null,
    recipient_department_nr varchar2(100) null,
    recipient_department_name varchar2(500) null,
    recipient_email varchar2(100) null,
    recipient_division_id number(38,0) null,
    recipient_division_name varchar2(100) null,
    recipient_position_id number(38,0) null,
    recipient_position_name varchar2(100) null,
	recipient_division_code varchar2(25) null,
    recipient_position_code varchar2(25) null,
    dhl_guid varchar2(36) null
)
/

create sequence sq_dhl_message_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create or replace
trigger tr_dhl_message_id
    before insert
    on dhl_message
    for each row
begin
    if (nvl(:new.dhl_message_id, 0) < 1) then
        select  sq_dhl_message_id.nextval
        into    globalPkg.identity
        from    dual;
        :new.dhl_message_id := globalPkg.identity;
    end if;
end;
/

CREATE TABLE dhl_settings
(
    id number(10,0) NOT NULL,
    institution_code varchar2 (20) NOT NULL,
    institution_name varchar2 (250) NOT NULL,
    personal_id_code varchar2 (20) NOT NULL,
    unit_id number(10,0) NOT NULL,
    subdivision_code number(38,0) NULL,
    occupation_code number(38,0) NULL,
	subdivision_short_name varchar2(25) null,
    occupation_short_name varchar2(25) null,
    subdivision_name varchar2(250) null,
    occupation_name varchar2(250) null,
    container_version number(3) NULL,
    xroad_client_instance varchar2 (6) NOT NULL,
    xroad_client_member_class varchar2 (50) NOT NULL,
    xroad_client_subsystem_code varchar2 (50) NOT NULL,
    xroad_client_member_code varchar2 (50) NOT NULL
)
/

create table dhl_organization
(
    org_code varchar2 (30) not null,
    org_name varchar2 (100) not null,
    dhl_capable number (1,0) default 0 not null,
    dhl_direct_capable number (1,0) default 0 not null,
    xroad_service_instance varchar2(2) null,
    xroad_service_member_class varchar2(50) null,
    xroad_service_member_code varchar2(50) null,
    dhl_direct_producer_name varchar2(50) null,
    dhl_direct_service_url varchar2(100) null,
	parent_org_code varchar2(20) null
)
/

create
table   dhl_counter
(
    dhl_id number(38,0) null
)
/

insert into dhl_counter(dhl_id) values(0);

ALTER
TABLE dhl_message
ADD CONSTRAINT PK_dhl_message
PRIMARY KEY (dhl_message_id)
/

ALTER TABLE dhl_settings
ADD CONSTRAINT PK_dhl_settings
PRIMARY KEY (id)
/

ALTER
TABLE dhl_organization
ADD CONSTRAINT PK_dhl_organization
PRIMARY KEY (org_code)
/

CREATE INDEX ix_dhl_message_1
ON dhl_message (unit_id)
/

CREATE INDEX ix_dhl_message_2
ON dhl_message (dhl_id)
/

CREATE INDEX ix_dhl_message_3
ON dhl_message (sending_status_id)
/

CREATE UNIQUE INDEX ix_dhl_settings_1
ON dhl_settings (unit_id)
/

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

create
table	dhl_message_recipient
(
    dhl_message_id number(10,0) not null,
    recipient_org_code varchar2(20) not null,
    recipient_org_name varchar2(100) null,
    recipient_person_code varchar2(20) not null,
    recipient_name varchar2(100) null,
    sending_date date null,
    received_date date null,
    sending_status_id number(10,0) not null,
    recipient_status_id number(10,0) null,
    fault_code varchar2(50) null,
    fault_actor varchar2(250) null,
    fault_string varchar2(500) null,
    fault_detail varchar2(2000) null,
    metaxml clob null,
    dhl_id number(38,0) null,
    query_id varchar2(50) null,
    xroad_service_instance varchar2(2) null,
    xroad_service_member_class varchar2(50) null,
    xroad_service_member_code varchar2(50) null,
    producer_name varchar2(50) null,
    service_url varchar2(100) null,
    recipient_division_id number(38,0) default 0 not null,
    recipient_division_name varchar2(100) null,
    recipient_position_id number(38,0) default 0 not null,
    recipient_position_name varchar2(100) null,
	recipient_division_code varchar2(25) null,
    recipient_position_code varchar2(25) null,
	dhl_message_recipient_id number(38, 0) default 0 not null
)
/

create sequence sq_dhl_message_recipient_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create or replace
trigger tr_dhl_message_recipient_id
    before insert
    on dhl_message_recipient
    for each row
begin
    if (:new.dhl_message_recipient_id < 1) then
        select  sq_dhl_message_recipient_id.nextval
        into    globalPkg.identity
        from    dual;
        :new.dhl_message_recipient_id := globalPkg.identity;
    end if;
end;
/

alter table dhl_message_recipient
add constraint PK_dhl_message_recipient
primary key (dhl_message_recipient_id)
/

alter table dhl_message_recipient
add constraint UN_dhl_message_recipient
unique (dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id, recipient_division_code, recipient_position_code)
/

alter table dhl_message_recipient
add constraint fk_dhl_message_recipient_1
foreign key (dhl_message_id)
referencing dhl_message (dhl_message_id)
on delete cascade
/

create
table   dhl_occupation
(
    occupation_code number(38,0) not null,
    occupation_name varchar2(100) not null,
    org_code varchar2(20) not null,
	occupation_short_name varchar2(25) null,
	parent_subdivision_short_name varchar2(25) null
)
/

alter
table dhl_occupation
add constraint PK_dhl_occupation
primary key (occupation_code)
/

create
table   dhl_subdivision
(
    subdivision_code number(38,0) not null,
    subdivision_name varchar2(100) not null,
    org_code varchar2(20) not null,
	subdivision_short_name varchar2(25) null,
	parent_subdivision_short_name varchar2(25) null
)
/

alter
table dhl_subdivision
add constraint PK_dhl_subdivision
primary key (subdivision_code)
/

create
table   dhl_classifier
(
    dhl_classifier_code varchar2(20) not null,
    dhl_classifier_id int null
)
/

alter
table dhl_classifier
add constraint PK_dhl_classifier
primary key (dhl_classifier_code)
/

INSERT INTO dhl_classifier(dhl_classifier_code,dhl_classifier_id) VALUES('STATUS_WAITING', 1);
INSERT INTO dhl_classifier(dhl_classifier_code,dhl_classifier_id) VALUES('STATUS_SENDING', 2);
INSERT INTO dhl_classifier(dhl_classifier_code,dhl_classifier_id) VALUES('STATUS_SENT', 3);
INSERT INTO dhl_classifier(dhl_classifier_code,dhl_classifier_id) VALUES('STATUS_CANCELED', 4);
INSERT INTO dhl_classifier(dhl_classifier_code,dhl_classifier_id) VALUES('STATUS_RECEIVED', 5);

create table dhl_status_history
(
    dhl_status_history_id number(38,0) not null,
    server_side_id number(38,0) not null,
    dhl_message_recipient_id number(38,0) not null,
    sending_status_id number(38,0) not null,
    status_date date null,
    fault_code varchar2(50) null,
    fault_actor varchar2(250) null,
    fault_string varchar2(500) null,
    fault_detail varchar2(2000) null,
    recipient_status_id number(38,0) null,
    metaxml clob null
)
/

alter table dhl_status_history
add constraint PK_dhl_status_history
primary key (dhl_status_history_id)
/

alter table dhl_status_history
add constraint fk_dhl_status_history_1
foreign key (dhl_message_recipient_id)
referencing dhl_message_recipient (dhl_message_recipient_id)
on delete cascade
/

create sequence sq_dhl_status_history_id
start with 1
increment by 1
minvalue 1
nomaxvalue
nocache
/

create or replace
trigger tr_dhl_status_history_id
    before insert
    on dhl_status_history
    for each row
begin
    if (:new.dhl_status_history_id < 1) then
        select  sq_dhl_status_history_id.nextval
        into    globalPkg.identity
        from    dual;
        :new.dhl_status_history_id := globalPkg.identity;
    end if;
end;
/


create procedure Save_DhlOrganization(
    org_code in varchar2,
    org_name in varchar2,
    is_dhl_capable in number,
    is_dhl_direct_capable in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    parent_org_code in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_organization o
    where   o.org_code = Save_DhlOrganization.org_code;

    if (cnt = 0) then
        insert
        into    dhl_organization(
                org_code,
                org_name,
                dhl_capable,
                dhl_direct_capable,
                xroad_service_instance,
		        xroad_service_member_class,
		        xroad_service_member_code,
                dhl_direct_producer_name,
                dhl_direct_service_url,
                parent_org_code)
        values  (Save_DhlOrganization.org_code,
                Save_DhlOrganization.org_name,
                Save_DhlOrganization.is_dhl_capable,
                Save_DhlOrganization.is_dhl_direct_capable,
                Save_DhlOrganization.xroad_service_instance,
                Save_DhlOrganization.xroad_service_member_class,
                Save_DhlOrganization.xroad_service_member_code,
                Save_DhlOrganization.dhl_direct_producer_name,
                Save_DhlOrganization.dhl_direct_service_url,
                Save_DhlOrganization.parent_org_code);
    else
        update  dhl_organization
        set     org_name = Save_DhlOrganization.org_name,
                dhl_capable = Save_DhlOrganization.is_dhl_capable,
                dhl_direct_capable = Save_DhlOrganization.is_dhl_direct_capable,
                xroad_service_instance = Save_DhlOrganization.xroad_service_instance,
                xroad_service_member_class = Save_DhlOrganization.xroad_service_member_class,
                xroad_service_member_code = Save_DhlOrganization.xroad_service_member_code,
                dhl_direct_producer_name = Save_DhlOrganization.dhl_direct_producer_name,
                dhl_direct_service_url = Save_DhlOrganization.dhl_direct_service_url,
                parent_org_code = Save_DhlOrganization.parent_org_code
        where   org_code = Save_DhlOrganization.org_code;
    end if;
end;
/

create procedure Get_DhlMessages(
    incoming in number,
    status_id in number,
    unit_id in number,
    status_update_needed in number,
    metadata_only in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when Get_DhlMessages.metadata_only=0 then data else null end) as data,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            dhl_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml,
            query_id,
            proxy_org_code,
            proxy_org_name,
            proxy_person_code,
            proxy_name,
            recipient_department_nr,
            recipient_department_name,
            recipient_email,
            recipient_division_id,
            recipient_division_code,
            recipient_division_name,
            recipient_position_id,
            recipient_position_name,
            recipient_position_code,
            dhl_guid
    from    dhl_message
    where   is_incoming = Get_DhlMessages.incoming
            and
            (
                sending_status_id = Get_DhlMessages.status_id
                or Get_DhlMessages.status_id is null
            )
            and unit_id = Get_DhlMessages.unit_id
            and
            (
                Get_DhlMessages.status_update_needed <> 1
                or status_update_needed = 1
            );
end;
/

create procedure Add_DhlMessage(
    id out number,
    is_incoming in number,
    data in clob,
    dhl_id in number,
    title in varchar2,
    sender_org_code in varchar2,
    sender_org_name in varchar2,
    sender_person_code in varchar2,
    sender_name in varchar2,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    case_name in varchar2,
    dhl_folder_name in varchar2,
    sending_status_id in number,
    unit_id in number,
    sending_date in date,
    received_date in date,
    local_item_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    status_update_needed in number,
    metaxml in clob,
    query_id in varchar2,
    proxy_org_code in varchar2,
    proxy_org_name in varchar2,
    proxy_person_code in varchar2,
    proxy_name in varchar2,
    recipient_department_nr in varchar2,
    recipient_department_name in varchar2,
    recipient_email in varchar2,
    recipient_division_id in number,
    recipient_division_name in varchar2,
    recipient_position_id in number,
    recipient_position_name in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2,
    dhl_guid in varchar2)
as
is_incoming_ number(1,0) := Add_DhlMessage.is_incoming;
begin
    if is_incoming_ is null then
        is_incoming_ := 0;
    end if;

    insert
    into    dhl_message(
            dhl_message_id,
            is_incoming,
            data,
            dhl_id,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml,
            query_id,
            proxy_org_code,
            proxy_org_name,
            proxy_person_code,
            proxy_name,
            recipient_department_nr,
            recipient_department_name,
            recipient_email,
            recipient_division_id,
            recipient_division_name,
            recipient_position_id,
            recipient_position_name,
            recipient_division_code,
            recipient_position_code,
            dhl_guid)
    values  (0,
            is_incoming_,
            Add_DhlMessage.data,
            Add_DhlMessage.dhl_id,
            Add_DhlMessage.title,
            Add_DhlMessage.sender_org_code,
            Add_DhlMessage.sender_org_name,
            Add_DhlMessage.sender_person_code,
            Add_DhlMessage.sender_name,
            Add_DhlMessage.recipient_org_code,
            Add_DhlMessage.recipient_org_name,
            Add_DhlMessage.recipient_person_code,
            Add_DhlMessage.recipient_name,
            Add_DhlMessage.case_name,
            Add_DhlMessage.dhl_folder_name,
            Add_DhlMessage.sending_status_id,
            Add_DhlMessage.unit_id,
            Add_DhlMessage.sending_date,
            Add_DhlMessage.received_date,
            Add_DhlMessage.local_item_id,
            Add_DhlMessage.recipient_status_id,
            Add_DhlMessage.fault_code,
            Add_DhlMessage.fault_actor,
            Add_DhlMessage.fault_string,
            Add_DhlMessage.fault_detail,
            Add_DhlMessage.status_update_needed,
            Add_DhlMessage.metaxml,
            Add_DhlMessage.query_id,
            Add_DhlMessage.proxy_org_code,
            Add_DhlMessage.proxy_org_name,
            Add_DhlMessage.proxy_person_code,
            Add_DhlMessage.proxy_name,
            Add_DhlMessage.recipient_department_nr,
            Add_DhlMessage.recipient_department_name,
            Add_DhlMessage.recipient_email,
            Add_DhlMessage.recipient_division_id,
            Add_DhlMessage.recipient_division_name,
            Add_DhlMessage.recipient_position_id,
            Add_DhlMessage.recipient_position_name,
            Add_DhlMessage.recipient_division_code,
            Add_DhlMessage.recipient_position_code,
            Add_DhlMessage.dhl_guid);

    Add_DhlMessage.id := globalPkg.identity;
end;
/

create procedure Update_DhlMessage(
    id in number,
    is_incoming in number,
    data in clob,
    dhl_id in number,
    title in varchar2,
    sender_org_code in varchar2,
    sender_org_name in varchar2,
    sender_person_code in varchar2,
    sender_name in varchar2,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    case_name in varchar2,
    dhl_folder_name in varchar2,
    sending_status_id in number,
    unit_id in number,
    sending_date in date,
    received_date in date,
    local_item_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    status_update_needed in number,
    metaxml in clob,
    query_id in varchar2,
    proxy_org_code in varchar2,
    proxy_org_name in varchar2,
    proxy_person_code in varchar2,
    proxy_name in varchar2,
    recipient_department_nr in varchar2,
    recipient_department_name in varchar2,
    recipient_email in varchar2,
    recipient_division_id in number,
    recipient_division_name in varchar2,
    recipient_position_id in number,
    recipient_position_name in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2,
    dhl_guid in varchar2)
as
begin
    update  dhl_message
    set     is_incoming = Update_DhlMessage.is_incoming,
            data = Update_DhlMessage.data,
            dhl_id = Update_DhlMessage.dhl_id,
            title = Update_DhlMessage.title,
            sender_org_code = Update_DhlMessage.sender_org_code,
            sender_org_name = Update_DhlMessage.sender_org_name,
            sender_person_code = Update_DhlMessage.sender_person_code,
            sender_name = Update_DhlMessage.sender_name,
            recipient_org_code = Update_DhlMessage.recipient_org_code,
            recipient_org_name = Update_DhlMessage.recipient_org_name,
            recipient_person_code = Update_DhlMessage.recipient_person_code,
            recipient_name = Update_DhlMessage.recipient_name,
            case_name = Update_DhlMessage.case_name,
            dhl_folder_name = Update_DhlMessage.dhl_folder_name,
            sending_status_id = Update_DhlMessage.sending_status_id,
            unit_id = Update_DhlMessage.unit_id,
            sending_date = Update_DhlMessage.sending_date,
            received_date = Update_DhlMessage.received_date,
            local_item_id = Update_DhlMessage.local_item_id,
            recipient_status_id = Update_DhlMessage.recipient_status_id,
            fault_code = Update_DhlMessage.fault_code,
            fault_actor = Update_DhlMessage.fault_actor,
            fault_string = Update_DhlMessage.fault_string,
            fault_detail = Update_DhlMessage.fault_detail,
            status_update_needed = Update_DhlMessage.status_update_needed,
            metaxml = Update_DhlMessage.metaxml,
            query_id = nvl(query_id, Update_DhlMessage.query_id),
            proxy_org_code = Update_DhlMessage.proxy_org_code,
            proxy_org_name = Update_DhlMessage.proxy_org_name,
            proxy_person_code = Update_DhlMessage.proxy_person_code,
            proxy_name = Update_DhlMessage.proxy_name,
            recipient_department_nr = Update_DhlMessage.recipient_department_nr,
            recipient_department_name = Update_DhlMessage.recipient_department_name,
            recipient_email = Update_DhlMessage.recipient_email,
            recipient_division_id = Update_DhlMessage.recipient_division_id,
            recipient_division_name = Update_DhlMessage.recipient_division_name,
            recipient_position_id = Update_DhlMessage.recipient_position_id,
            recipient_position_name = Update_DhlMessage.recipient_position_name,
            recipient_division_code = Update_DhlMessage.recipient_division_code,
            recipient_position_code = Update_DhlMessage.recipient_position_code,
            dhl_guid = Update_DhlMessage.dhl_guid
    where   dhl_message_id = Update_DhlMessage.id;
end;
/

create procedure Update_DhlMsgStatusUpdateNeed(
    message_id in number,
    status_update_needed in number)
as
begin
    update  dhl_message
    set     status_update_needed = Update_DhlMsgStatusUpdateNeed.status_update_needed
    where   dhl_message_id = Update_DhlMsgStatusUpdateNeed.message_id;
end;
/

create procedure Update_DhlMessageDhlID(
    id in number,
    dhl_id in number,
    query_id in varchar2,
    dhl_guid in varchar2)
as
begin
    update  dhl_message
    set     dhl_id = Update_DhlMessageDhlID.dhl_id,
            query_id = nvl(query_id, Update_DhlMessageDhlID.query_id),
            dhl_guid = nvl(dhl_guid, Update_DhlMessageDhlID.dhl_guid)
    where   dhl_message_id = Update_DhlMessageDhlID.id;
end;
/

create procedure Update_DhlMessageStatus(
    dhl_message_id in number,
    status_id in number,
    status_update_needed in number,
    received_date in date,
    sending_date in date)
as
begin
    update  dhl_message
    set     sending_status_id = Update_DhlMessageStatus.status_id,
            status_update_needed = Update_DhlMessageStatus.status_update_needed,
            received_date = nvl(received_date, Update_DhlMessageStatus.received_date),
            sending_date = nvl(sending_date, Update_DhlMessageStatus.sending_date)
    where   dhl_message_id = Update_DhlMessageStatus.dhl_message_id;
end;
/

create procedure Get_DhlMessageRecipients(
    message_id in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  r.*
    from    dhl_message_recipient r
    where   r.dhl_message_id = Get_DhlMessageRecipients.message_id;
end;
/

create procedure Get_DhlMessageID(
    dhl_message_id out number,
    dhl_id in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    is_incoming in number)
as
cnt number(38,0) := 0;
begin
    if Get_DhlMessageID.is_incoming = 0 then
        select  max(r.dhl_message_id)
        into    Get_DhlMessageID.dhl_message_id
        from    dhl_message_recipient r
        inner join
                dhl_message m on m.dhl_message_id = r.dhl_message_id
        where   m.is_incoming = 0
                and r.dhl_id = Get_DhlMessageID.dhl_id
                and nvl(r.xroad_service_instance,'') = nvl(Get_DhlMessageID.xroad_service_instance,'')
				and nvl(r.xroad_service_member_class,'') = nvl(Get_DhlMessageID.xroad_service_member_class,'')
				and nvl(r.xroad_service_member_code,'') = nvl(Get_DhlMessageID.xroad_service_member_code,'')
                and nvl(r.producer_name,' ') = nvl(Get_DhlMessageID.producer_name,' ')
                and nvl(r.service_url,' ') = nvl(Get_DhlMessageID.service_url,' ');
    else
        select  count(*)
        into    cnt
        from    dhl_message m
        where   m.dhl_id = Get_DhlMessageID.dhl_id
                and m.is_incoming = Get_DhlMessageID.is_incoming;

        if cnt > 0 then
            select  m.dhl_message_id
            into    Get_DhlMessageID.dhl_message_id
            from    dhl_message m
            where   m.dhl_id = Get_DhlMessageID.dhl_id
                    and m.is_incoming = 1;
        else
		    Get_DhlMessageID.dhl_message_id := 0;
        end if;
    end if;
    Get_DhlMessageID.dhl_message_id := nvl(Get_DhlMessageID.dhl_message_id, 0);
end;
/

create procedure Save_DhlMessageRecipient(
    dhl_message_recipient_id out number,
    dhl_message_id in number,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    sending_date date,
    received_date date,
    sending_status_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    metaxml clob,
    dhl_id in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    recipient_division_id in number,
    recipient_division_name in varchar2,
    recipient_position_id in number,
    recipient_position_name in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2)
as
cnt number(10,0) := 0;
recipient_org_code_ varchar2(20) := nvl(Save_DhlMessageRecipient.recipient_org_code, ' ');
recipient_person_code_ varchar2(20) := nvl(Save_DhlMessageRecipient.recipient_person_code, ' ');
recipient_division_id_ number(38,0) := nvl(Save_DhlMessageRecipient.recipient_division_id, 0);
recipient_position_id_ number(38,0) := nvl(Save_DhlMessageRecipient.recipient_position_id, 0);
recipient_division_code_ varchar2(25) := nvl(Save_DhlMessageRecipient.recipient_division_code, ' ');
recipient_position_code_ varchar2(25) := nvl(Save_DhlMessageRecipient.recipient_position_code, ' ');
begin
    select  count(*)
    into    cnt
    from    dhl_message_recipient
    where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
            and recipient_org_code = recipient_org_code_
            and recipient_person_code = recipient_person_code_
            and recipient_division_id = recipient_division_id_
            and recipient_position_id = recipient_position_id_
            and recipient_division_code = recipient_division_code_
            and recipient_position_code = recipient_position_code_;

    if (cnt > 0) then
        update  dhl_message_recipient
        set     recipient_org_name = Save_DhlMessageRecipient.recipient_org_name,
                recipient_name = Save_DhlMessageRecipient.recipient_name,
                sending_date = Save_DhlMessageRecipient.sending_date,
                received_date = Save_DhlMessageRecipient.received_date,
                sending_status_id = Save_DhlMessageRecipient.sending_status_id,
                recipient_status_id = Save_DhlMessageRecipient.recipient_status_id,
                fault_code = Save_DhlMessageRecipient.fault_code,
                fault_actor = Save_DhlMessageRecipient.fault_actor,
                fault_string = Save_DhlMessageRecipient.fault_string,
                fault_detail = Save_DhlMessageRecipient.fault_detail,
                metaxml = Save_DhlMessageRecipient.metaxml,
                dhl_id = Save_DhlMessageRecipient.dhl_id,
                xroad_service_instance = Save_DhlMessageRecipient.xroad_service_instance,
                xroad_service_member_class = Save_DhlMessageRecipient.xroad_service_member_class,
                xroad_service_member_code = Save_DhlMessageRecipient.xroad_service_member_code,
                producer_name = Save_DhlMessageRecipient.producer_name,
                service_url = Save_DhlMessageRecipient.service_url,
                recipient_division_name = Save_DhlMessageRecipient.recipient_division_name,
                recipient_position_name = Save_DhlMessageRecipient.recipient_position_name
        where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;

        select    dhl_message_recipient_id
        into    Save_DhlMessageRecipient.dhl_message_recipient_id
        from    dhl_message_recipient
        where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;
    else
        insert
        into    dhl_message_recipient(
                dhl_message_id,
                recipient_org_code,
                recipient_org_name,
                recipient_person_code,
                recipient_name,
                sending_date,
                received_date,
                sending_status_id,
                recipient_status_id,
                fault_code,
                fault_actor,
                fault_string,
                fault_detail,
                metaxml,
                dhl_id,
                xroad_service_instance,
		        xroad_service_member_class,
		        xroad_service_member_code,
                producer_name,
                service_url,
                recipient_division_id,
                recipient_division_name,
                recipient_position_id,
                recipient_position_name,
                recipient_division_code,
                recipient_position_code,
                dhl_message_recipient_id)
        values  (Save_DhlMessageRecipient.dhl_message_id,
                recipient_org_code_,
                Save_DhlMessageRecipient.recipient_org_name,
                recipient_person_code_,
                Save_DhlMessageRecipient.recipient_name,
                Save_DhlMessageRecipient.sending_date,
                Save_DhlMessageRecipient.received_date,
                Save_DhlMessageRecipient.sending_status_id,
                Save_DhlMessageRecipient.recipient_status_id,
                Save_DhlMessageRecipient.fault_code,
                Save_DhlMessageRecipient.fault_actor,
                Save_DhlMessageRecipient.fault_string,
                Save_DhlMessageRecipient.fault_detail,
                Save_DhlMessageRecipient.metaxml,
                Save_DhlMessageRecipient.dhl_id,
                Save_DhlMessageRecipient.xroad_service_instance,
                Save_DhlMessageRecipient.xroad_service_member_class,
                Save_DhlMessageRecipient.xroad_service_member_code,
                Save_DhlMessageRecipient.producer_name,
                Save_DhlMessageRecipient.service_url,
                recipient_division_id_,
                Save_DhlMessageRecipient.recipient_division_name,
                recipient_position_id_,
                Save_DhlMessageRecipient.recipient_position_name,
                recipient_division_code_,
                recipient_position_code_,
                0);

        Save_DhlMessageRecipient.dhl_message_recipient_id := globalPkg.identity;
    end if;
end;
/

create procedure Get_DhlSettings(
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dhl_settings;
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

create procedure Update_DhlMessageRecipDhlID(
    dhl_message_id in number,
    dhl_direct_capable in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2),
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    dhl_id in number,
    query_id in varchar2)
as
begin
    -- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
    update  dhl_message_recipient
    set     dhl_id = Update_DhlMessageRecipDhlID.dhl_id,
            query_id = Update_DhlMessageRecipDhlID.query_id,
            xroad_service_instance = Update_DhlMessageRecipDhlID.xroad_service_instance,
		    xroad_service_member_class = Update_DhlMessageRecipDhlID.xroad_service_member_class,
		    xroad_service_member_code = Update_DhlMessageRecipDhlID.xroad_service_member_code,
		    producer_name = Update_DhlMessageRecipDhlID.dhl_direct_producer_name,
		    service_url = Update_DhlMessageRecipDhlID.dhl_direct_service_url
    where   dhl_message_id = Update_DhlMessageRecipDhlID.dhl_message_id
            and recipient_org_code in
            (
                select  org_code
                from    dhl_organization
                where   nvl(dhl_direct_capable,1) = nvl(Update_DhlMessageRecipDhlID.dhl_direct_capable,1)
						and nvl(xroad_service_instance,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_instance,'')
						and nvl(xroad_service_member_class,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_member_class,'')
						and nvl(xroad_service_member_code,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_member_code,'')
						and nvl(dhl_direct_producer_name,'') = nvl(Update_DhlMessageRecipDhlID.dhl_direct_producer_name,'')
						and nvl(dhl_direct_service_url,'') = nvl(Update_DhlMessageRecipDhlID.dhl_direct_service_url,'')
            );
end;
/

create procedure Get_DhlMessagesByDhlID(
    dhl_id in number,
    incoming in number,
    metadata_only in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when Get_DhlMessagesByDhlID.metadata_only=0 then data else null end) as data,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            dhl_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml,
            query_id,
            proxy_org_code,
            proxy_org_name,
            proxy_person_code,
            proxy_name,
            recipient_department_nr,
            recipient_department_name,
            recipient_email,
            recipient_division_id,
            recipient_division_name,
            recipient_position_id,
            recipient_position_name,
            recipient_division_code,
            recipient_position_code,
            dhl_guid
    from    dhl_message
    where   is_incoming = Get_DhlMessagesByDhlID.incoming
            and dhl_id = Get_DhlMessagesByDhlID.dhl_id;
end;
/

create procedure Get_AsutusStat(
    vahetatud_dokumente out number,
    asutus_id in number)
as
begin
    select  count(*)
    into    Get_AsutusStat.vahetatud_dokumente
    from    dhl_message
    where   unit_id = Get_AsutusStat.asutus_id;
end;
/

create procedure Get_DhlCapabilityByMessageID(
    dhl_message_id number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  distinct
            o.dhl_capable,
            o.dhl_direct_capable,
            o.xroad_service_instance,
		    o.xroad_service_member_class,
		    o.xroad_service_member_code,
            o.dhl_direct_producer_name,
            o.dhl_direct_service_url
    from    dhl_organization o
    inner join
        dhl_message_recipient r on r.recipient_org_code = o.org_code
    where   r.dhl_message_id = Get_DhlCapabilityByMessageID.dhl_message_id
    order by
            o.dhl_direct_service_url desc;
end;
/

create procedure Get_DhlOrgsByCapability(
    dhl_capable in number,
    dhl_direct_capable in number,
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
	RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  org_code
    from    dhl_organization
    where   nvl(dhl_capable,0) = nvl(Get_DhlOrgsByCapability.dhl_capable,0)
            and nvl(dhl_direct_capable,0) = nvl(Get_DhlOrgsByCapability.dhl_direct_capable,0)
            and ((dhl_direct_producer_name = Get_DhlOrgsByCapability.dhl_direct_producer_name) or ((dhl_direct_producer_name is null) and (Get_DhlOrgsByCapability.dhl_direct_producer_name is null)))
            and ((dhl_direct_service_url = Get_DhlOrgsByCapability.dhl_direct_service_url) or ((dhl_direct_service_url is null) and (Get_DhlOrgsByCapability.dhl_direct_service_url is null)))
            and ((xroad_service_instance = Get_DhlOrgsByCapability.xroad_service_instance) or ((xroad_service_instance is null) and (Get_DhlOrgsByCapability.xroad_service_instance is null)))
            and ((xroad_service_member_class = Get_DhlOrgsByCapability.xroad_service_member_class) or ((xroad_service_member_class is null) and (Get_DhlOrgsByCapability.xroad_service_member_class is null)))
            and ((xroad_service_member_code = Get_DhlOrgsByCapability.xroad_service_member_code) or ((xroad_service_member_code is null) and (Get_DhlOrgsByCapability.xroad_service_member_code is null)));
end;
/

create procedure Get_NextDhlID(
    dhl_id out number)
as
begin
    update  dhl_counter
    set     dhl_id = nvl(dhl_id,0) + 1;

    select  dhl_id
	into    Get_NextDhlID.dhl_id
    from    dhl_counter;
end;
/

create procedure Get_DhlCapability(
	org_code in varchar2,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dhl_organization
    where   org_code = Get_DhlCapability.org_code;
end;
/

create procedure Save_DhlSubdivision(
    id in number,
    name in varchar2,
    org_code in varchar2,
    short_name in varchar2,
    parent_subdivision_short_name in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_subdivision a
    where   a.subdivision_code = Save_DhlSubdivision.id;

    if cnt <= 0 then
        insert
        into    dhl_subdivision(
                subdivision_code,
                subdivision_name,
                org_code,
                subdivision_short_name,
                parent_subdivision_short_name)
        values  (Save_DhlSubdivision.id,
                Save_DhlSubdivision.name,
                Save_DhlSubdivision.org_code,
                Save_DhlSubdivision.short_name,
                Save_DhlSubdivision.parent_subdivision_short_name);
    else
        update  dhl_subdivision
        set     subdivision_name = Save_DhlSubdivision.name,
                org_code = Save_DhlSubdivision.org_code,
                subdivision_short_name = Save_DhlSubdivision.short_name,
                parent_subdivision_short_name = Save_DhlSubdivision.parent_subdivision_short_name
        where   subdivision_code = Save_DhlSubdivision.id;
    end if;
end;
/

create procedure Save_DhlOccupation(
    id in number,
    name in varchar2,
    org_code in varchar2,
    short_name in varchar2,
    parent_subdivision_short_name in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_occupation a
    where   a.occupation_code = Save_DhlOccupation.id;

    if cnt <= 0 then
        insert
        into    dhl_occupation(
                occupation_code,
                occupation_name,
                org_code,
                occupation_short_name,
                parent_subdivision_short_name)
        values  (Save_DhlOccupation.id,
                Save_DhlOccupation.name,
                Save_DhlOccupation.org_code,
                Save_DhlOccupation.short_name,
                Save_DhlOccupation.parent_subdivision_short_name);
    else
        update  dhl_occupation
        set     occupation_name = Save_DhlOccupation.name,
                org_code = Save_DhlOccupation.org_code,
                parent_subdivision_short_name = Save_DhlOccupation.parent_subdivision_short_name,
                occupation_short_name = Save_DhlOccupation.short_name
        where   occupation_code = Save_DhlOccupation.id;
    end if;
end;
/

create procedure Get_DhlCapabilityList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select    *
    from    dhl_organization;
end;
/

create procedure Get_DhlClassifierList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select    *
    from    dhl_classifier;
end;
/

create procedure Get_DhlClassifier(
    code in varchar2,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select    *
    FROM    dhl_classifier
    WHERE    dhl_classifier_code = Get_DhlClassifier.code;
end;
/

create procedure Save_DhlClassifier(
    code in varchar2,
    id in int)
as
cnt number(10,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_classifier
    where   dhl_classifier_code = Save_DhlClassifier.code;

    if (cnt < 1) then
        insert into dhl_classifier(dhl_classifier_code, dhl_classifier_id)
        values (Save_DhlClassifier.code, Save_DhlClassifier.id);
    else
        update    dhl_classifier
        set        dhl_classifier_id = Save_DhlClassifier.id
        where    dhl_classifier_code = Save_DhlClassifier.code;
    end if;
end;
/

create procedure Get_DhlMessageByID(
    id in number,
    metadata_only in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when Get_DhlMessageByID.metadata_only=0 then data else null end) as data,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            dhl_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml,
            query_id,
            proxy_org_code,
            proxy_org_name,
            proxy_person_code,
            proxy_name,
            recipient_department_nr,
            recipient_department_name,
            recipient_email,
            recipient_division_id,
            recipient_division_name,
            recipient_position_id,
            recipient_position_name,
            recipient_division_code,
            recipient_position_code,
            dhl_guid
    from    dhl_message
    where   dhl_message_id = Get_DhlMessageByID.id;
end;
/

create procedure Get_DhlMessageIDByGuid(
    dhl_message_id out number,
    dhl_guid in varchar2,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    is_incoming in number)
as
cnt number(38,0) := 0;
begin
    if Get_DhlMessageIDByGuid.is_incoming = 0 then
        select  max(m.dhl_message_id)
        into    Get_DhlMessageIDByGuid.dhl_message_id
        from    dhl_message m
        inner join
                dhl_message_recipient r on r.dhl_message_id = m.dhl_message_id
        where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
        		and nvl(r.xroad_service_instance,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_instance,'')
				and nvl(r.xroad_service_member_class,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_member_class,'')
				and nvl(r.xroad_service_member_code,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_member_code,'')
                and nvl(r.producer_name,' ') = nvl(Get_DhlMessageIDByGuid.producer_name,' ')
                and nvl(r.service_url,' ') = nvl(Get_DhlMessageIDByGuid.service_url,' ')
                and m.is_incoming = 0;
    else
        select  count(*)
        into    cnt
        from    dhl_message m
        where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
                and m.is_incoming = Get_DhlMessageIDByGuid.is_incoming;

        if cnt > 0 then
            select  m.dhl_message_id
            into    Get_DhlMessageIDByGuid.dhl_message_id
            from    dhl_message m
            where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
                    and m.is_incoming = 1;
        else
            Get_DhlMessageIDByGuid.dhl_message_id := 0;
        end if;
    end if;
    Get_DhlMessageIDByGuid.dhl_message_id := nvl(Get_DhlMessageIDByGuid.dhl_message_id, 0);
end;
/

create procedure Get_DhlMessageRecipientId(
    dhl_message_recipient_id out number,
    dhl_message_id in number,
    recipient_org_code in varchar2,
    recipient_person_code in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2)
as
cnt number(10,0) := 0;
recipient_org_code_ varchar2(20) := nvl(Get_DhlMessageRecipientId.recipient_org_code, ' ');
recipient_person_code_ varchar2(20) := nvl(Get_DhlMessageRecipientId.recipient_person_code, ' ');
recipient_division_code_ varchar2(25) := nvl(Get_DhlMessageRecipientId.recipient_division_code, ' ');
recipient_position_code_ varchar2(25) := nvl(Get_DhlMessageRecipientId.recipient_position_code, ' ');
begin
    select  count(*)
    into    cnt
    from    dhl_message_recipient
    where   dhl_message_id = Get_DhlMessageRecipientId.dhl_message_id
            and recipient_org_code = recipient_org_code_
            and recipient_person_code = recipient_person_code_
            and recipient_division_code = recipient_division_code_
            and recipient_position_code = recipient_position_code_;

    if (cnt > 0) then
        select  dhl_message_recipient_id
        into    Get_DhlMessageRecipientId.dhl_message_recipient_id
        from    dhl_message_recipient
        where   dhl_message_id = Get_DhlMessageRecipientId.dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;
    else
        Get_DhlMessageRecipientId.dhl_message_recipient_id := 0;
    end if;
end;
/

create procedure Save_DhlStatusHistory(
    dhl_status_history_id out number,
    dhl_message_recipient_id in number,
    server_side_id in number,
    sending_status_id in number,
    status_date in date,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    recipient_status_id in number,
    metaxml in clob)
as
cnt number(10,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_status_history
    where   dhl_message_recipient_id = Save_DhlStatusHistory.dhl_message_recipient_id
            and server_side_id = Save_DhlStatusHistory.server_side_id;

    if (cnt > 0) then
        select  dhl_status_history_id
        into    Save_DhlStatusHistory.dhl_status_history_id
        from    dhl_status_history
        where   dhl_message_recipient_id = Save_DhlStatusHistory.dhl_message_recipient_id
                and server_side_id = Save_DhlStatusHistory.server_side_id;
    else
        insert
        into    dhl_status_history(
                dhl_status_history_id,
                dhl_message_recipient_id,
                server_side_id,
                sending_status_id,
                status_date,
                fault_code,
                fault_actor,
                fault_string,
                fault_detail,
                recipient_status_id,
                metaxml)
        values  (0,
                Save_DhlStatusHistory.dhl_message_recipient_id,
                Save_DhlStatusHistory.server_side_id,
                Save_DhlStatusHistory.sending_status_id,
                Save_DhlStatusHistory.status_date,
                Save_DhlStatusHistory.fault_code,
                Save_DhlStatusHistory.fault_actor,
                Save_DhlStatusHistory.fault_string,
                Save_DhlStatusHistory.fault_detail,
                Save_DhlStatusHistory.recipient_status_id,
                Save_DhlStatusHistory.metaxml);

        Save_DhlStatusHistory.dhl_status_history_id := globalPkg.identity;
    end if;
end;
/

create procedure Get_DhlMessageByGUID(
    guid in varchar,
    metadata_only in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when Get_DhlMessageByGUID.metadata_only=0 then data else null end) as data,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            dhl_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml,
            query_id,
            proxy_org_code,
            proxy_org_name,
            proxy_person_code,
            proxy_name,
            recipient_department_nr,
            recipient_department_name,
            recipient_email,
            recipient_division_id,
            recipient_division_name,
            recipient_position_id,
            recipient_position_name,
            recipient_division_code,
            recipient_position_code,
            dhl_guid
    from    dhl_message
    where   guid = Get_DhlMessageByGUID.guid;
end;
/

create procedure Delete_OldDhlMessages(
	deleted_doc_count out number,
	doc_lifetime_days in number)
as
begin
    Delete_OldDhlMessages.deleted_doc_count := 0;

	if (Delete_OldDhlMessages.doc_lifetime_days is not null) and (Delete_OldDhlMessages.doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	is_incoming = 1
				and (sysdate - received_date) >= Delete_OldDhlMessages.doc_lifetime_days;
		Delete_OldDhlMessages.deleted_doc_count := Delete_OldDhlMessages.deleted_doc_count + sql%rowcount;

		-- Delete old sent documents
		delete
		from	dhl_message
		where	is_incoming = 0
				and (sysdate - sending_date) >= Delete_OldDhlMessages.doc_lifetime_days;
		Delete_OldDhlMessages.deleted_doc_count := Delete_OldDhlMessages.deleted_doc_count + sql%rowcount;
	end if;
end;
/

create procedure Update_DhlMessageMetaData(
    id in number,
    is_incoming in number,
    dhl_id in number,
    title in varchar2,
    sender_org_code in varchar2,
    sender_org_name in varchar2,
    sender_person_code in varchar2,
    sender_name in varchar2,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    case_name in varchar2,
    dhl_folder_name in varchar2,
    sending_status_id in number,
    unit_id in number,
    sending_date in date,
    received_date in date,
    local_item_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    status_update_needed in number,
    metaxml in clob,
    query_id in varchar2,
    proxy_org_code in varchar2,
    proxy_org_name in varchar2,
    proxy_person_code in varchar2,
    proxy_name in varchar2,
    recipient_department_nr in varchar2,
    recipient_department_name in varchar2,
    recipient_email in varchar2,
    recipient_division_id in number,
    recipient_division_name in varchar2,
    recipient_position_id in number,
    recipient_position_name in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2,
    dhl_guid in varchar2)
as
begin
    update  dhl_message
    set     is_incoming = Update_DhlMessageMetaData.is_incoming,
            dhl_id = Update_DhlMessageMetaData.dhl_id,
            title = Update_DhlMessageMetaData.title,
            sender_org_code = Update_DhlMessageMetaData.sender_org_code,
            sender_org_name = Update_DhlMessageMetaData.sender_org_name,
            sender_person_code = Update_DhlMessageMetaData.sender_person_code,
            sender_name = Update_DhlMessageMetaData.sender_name,
            recipient_org_code = Update_DhlMessageMetaData.recipient_org_code,
            recipient_org_name = Update_DhlMessageMetaData.recipient_org_name,
            recipient_person_code = Update_DhlMessageMetaData.recipient_person_code,
            recipient_name = Update_DhlMessageMetaData.recipient_name,
            case_name = Update_DhlMessageMetaData.case_name,
            dhl_folder_name = Update_DhlMessageMetaData.dhl_folder_name,
            sending_status_id = Update_DhlMessageMetaData.sending_status_id,
            unit_id = Update_DhlMessageMetaData.unit_id,
            sending_date = Update_DhlMessageMetaData.sending_date,
            received_date = Update_DhlMessageMetaData.received_date,
            local_item_id = Update_DhlMessageMetaData.local_item_id,
            recipient_status_id = Update_DhlMessageMetaData.recipient_status_id,
            fault_code = Update_DhlMessageMetaData.fault_code,
            fault_actor = Update_DhlMessageMetaData.fault_actor,
            fault_string = Update_DhlMessageMetaData.fault_string,
            fault_detail = Update_DhlMessageMetaData.fault_detail,
            status_update_needed = Update_DhlMessageMetaData.status_update_needed,
            metaxml = Update_DhlMessageMetaData.metaxml,
            query_id = nvl(query_id, Update_DhlMessageMetaData.query_id),
            proxy_org_code = Update_DhlMessageMetaData.proxy_org_code,
            proxy_org_name = Update_DhlMessageMetaData.proxy_org_name,
            proxy_person_code = Update_DhlMessageMetaData.proxy_person_code,
            proxy_name = Update_DhlMessageMetaData.proxy_name,
            recipient_department_nr = Update_DhlMessageMetaData.recipient_department_nr,
            recipient_department_name = Update_DhlMessageMetaData.recipient_department_name,
            recipient_email = Update_DhlMessageMetaData.recipient_email,
            recipient_division_id = Update_DhlMessageMetaData.recipient_division_id,
            recipient_division_name = Update_DhlMessageMetaData.recipient_division_name,
            recipient_position_id = Update_DhlMessageMetaData.recipient_position_id,
            recipient_position_name = Update_DhlMessageMetaData.recipient_position_name,
            recipient_division_code = Update_DhlMessageMetaData.recipient_division_code,
            recipient_position_code = Update_DhlMessageMetaData.recipient_position_code,
            dhl_guid = Update_DhlMessageMetaData.dhl_guid
    where   dhl_message_id = Update_DhlMessageMetaData.id;
end;
/

create or replace
procedure Get_DhlOccupationList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dhl_occupation;
end;
/

create or replace
procedure Get_DhlSubdivisionList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dhl_subdivision;
end;
/

create or replace
procedure Delete_DhlOccupation(id in number)
as
begin
    delete
    from    dhl_occupation
    where   occupation_code = Delete_DhlOccupation.id;
end;
/

create or replace
procedure Delete_DhlSubdivision(id in number)
as
begin
    delete
    from    dhl_subdivision
    where   subdivision_code = Delete_DhlSubdivision.id;
end;
/

CREATE SEQUENCE sq_dhl_error_log_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOMAXVALUE
NOCACHE;
/

CREATE SEQUENCE sq_dhl_request_log_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOMAXVALUE
NOCACHE;
/

CREATE TABLE dhl_error_log
(
    dhl_error_log_id number(10,0) NOT NULL,
    error_datetime timestamp NOT NULL,
    organization_code varchar2(20) NULL,
    user_code varchar2(20) NULL,
    action_name varchar2(200) NULL,
    error_message varchar2(500) NOT NULL,
    dhl_message_id number(10,0) NULL
);
/

CREATE TABLE dhl_request_log
(
    dhl_request_log_id number(10,0) NOT NULL,
    request_datetime timestamp NOT NULL,
    organization_code varchar2(20) NOT NULL,
    user_code varchar2(20) NULL,
    request_name varchar2(100) NOT NULL,
    response varchar2(10) NULL,
    dhl_error_log_id number(10,0) NULL
);
/

ALTER
TABLE dhl_error_log
ADD CONSTRAINT PK_dhl_error_log
PRIMARY KEY (dhl_error_log_id);
/

ALTER TABLE dhl_error_log
ADD CONSTRAINT FK_dhl_message_id
FOREIGN KEY (dhl_message_id)
REFERENCES dhl_message(dhl_message_id)
ON DELETE CASCADE;
/

CREATE OR REPLACE
TRIGGER tr_dhl_error_log_id
    BEFORE INSERT
    ON dhl_error_log
    FOR EACH ROW
BEGIN
    IF (:new.dhl_error_log_id < 1) THEN
        SELECT  sq_dhl_error_log_id.nextval
        INTO    globalPkg.identity
        FROM    dual;
        :new.dhl_error_log_id := globalPkg.identity;
    END IF;
END;
/

ALTER
TABLE dhl_request_log
ADD CONSTRAINT PK_dhl_request_log
PRIMARY KEY (dhl_request_log_id);
/

ALTER TABLE dhl_request_log
ADD CONSTRAINT FK_dhl_error_log_id
FOREIGN KEY (dhl_error_log_id)
REFERENCES dhl_error_log(dhl_error_log_id)
ON DELETE CASCADE;
/

CREATE OR REPLACE
TRIGGER tr_dhl_request_log_id
    BEFORE INSERT
    ON dhl_request_log
    FOR EACH ROW
BEGIN
    IF (:new.dhl_request_log_id < 1) THEN
        SELECT  sq_dhl_request_log_id.nextval
        INTO    globalPkg.identity
        FROM    dual;
        :new.dhl_request_log_id := globalPkg.identity;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE Add_DhlErrorLog(
    dhl_error_log_id out number,
    error_datetime in timestamp,
    organization_code in varchar2,
    user_code in varchar2,
    action_name in varchar2,
    error_message in varchar2,
    dhl_message_id in number)
AS
BEGIN
        INSERT
        INTO	dhl_error_log(
              dhl_error_log_id,
              error_datetime,
              organization_code,
              user_code,
              action_name,
              error_message,
              dhl_message_id)
        VALUES  (0,
                Add_DhlErrorLog.error_datetime,
                Add_DhlErrorLog.organization_code,
                Add_DhlErrorLog.user_code,
                Add_DhlErrorLog.action_name,
                Add_DhlErrorLog.error_message,
                Add_DhlErrorLog.dhl_message_id);

        Add_DhlErrorLog.dhl_error_log_id := globalPkg.identity;
END;
/

CREATE OR REPLACE PROCEDURE Add_DhlRequestLog(
    dhl_request_log_id out number,
    request_datetime in timestamp,
    organization_code in varchar2,
    user_code in varchar2,
    request_name in varchar2,
    response in varchar2,
    dhl_error_log_id in number)
AS
BEGIN
        INSERT
        INTO  dhl_request_log(
              dhl_request_log_id,
              request_datetime,
              organization_code,
              user_code,
              request_name,
              response,
              dhl_error_log_id)
        VALUES  (0,
                Add_DhlRequestLog.request_datetime,
                Add_DhlRequestLog.organization_code,
                Add_DhlRequestLog.user_code,
                Add_DhlRequestLog.request_name,
                Add_DhlRequestLog.response,
                Add_DhlRequestLog.dhl_error_log_id);

        Add_DhlRequestLog.dhl_request_log_id := globalPkg.identity;
END;

/

ALTER TABLE dhl_message_recipient ADD opened TIMESTAMP NULL;

create or replace
PROCEDURE Get_NotOpenedInAdit(RC1 in out globalPkg.RCT1)
AS
  BEGIN
    OPEN RC1 FOR
    select  recipient.*
    from    dhl_message_recipient recipient, dhl_message message
    where   LOWER(recipient.recipient_org_code)='adit'
      and recipient.opened is null
      and recipient.dhl_message_id = message.dhl_message_id
      and message.is_incoming=0
      and recipient.dhl_id is not null
      and message.dhl_id is not null;
  END;
/
create or replace
PROCEDURE Update_MessageRecipientOpened(
  p_dhl_id in number,
  p_recipient_person_code in varchar2,
  p_person_code_with_prefix in varchar2,
  p_opened in timestamp)
AS
  BEGIN
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and
      (recipient_person_code = p_recipient_person_code or p_person_code_with_prefix = p_person_code_with_prefix);
END;
/





