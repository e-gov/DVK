----------------------------------------------------------------------
-- DVK Client 1.6.0 - 2010/01
----------------------------------------------------------------------
alter
table   dhl_message_recipient
add
(    
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

create trigger tr_dhl_message_recipient_id
    before update
    on dhl_message_recipient
    for each row
begin
    select  sq_dhl_message_recipient_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.dhl_message_recipient_id := globalPkg.identity;
end;
/

update dhl_message_recipient set recipient_position_code = recipient_position_code;

create or replace
trigger tr_dhl_message_recipient_id
    before insert
    on dhl_message_recipient
    for each row
begin
    select  sq_dhl_message_recipient_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.dhl_message_recipient_id := globalPkg.identity;
end;
/

alter table dhl_message_recipient
drop constraint PK_dhl_message_recipient
/

alter table dhl_message_recipient
add constraint PK_dhl_message_recipient
primary key (dhl_message_recipient_id)
/

alter table dhl_message_recipient
add constraint UN_dhl_message_recipient
unique (dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id, recipient_division_code, recipient_position_code)
/


alter
table   dhl_message
add
(    
    recipient_division_code varchar2(25) null,
    recipient_position_code varchar2(25) null,
    dhl_guid varchar2(36) null,
    var_text varchar2(4000) null,
    var_int number(38,0) null,
    var_date DATE null
)
/

alter
table   dhl_settings
add
(    
    subdivision_short_name varchar2(25) null,
    occupation_short_name varchar2(25) null,
    subdivision_name varchar2(250) null,
    occupation_name varchar2(250) null,
    container_version number(3) null
)
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

alter
table   dhl_subdivision
add
( 
    subdivision_short_name varchar2(25) null,
    parent_subdivision_short_name varchar2(25) null
)
/

alter
table   dhl_occupation
add
( 
    occupation_short_name varchar2(25) null,
    parent_subdivision_short_name varchar2(25) null
)
/

alter
table   dhl_organization
add
( 
    parent_org_code varchar2(20) null
)
/

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

create trigger tr_dhl_status_history_id
    before insert
    on dhl_status_history
    for each row
begin
    select  sq_dhl_status_history_id.nextval
    into    globalPkg.identity
    from    dual;
    :new.dhl_status_history_id := globalPkg.identity;
end;
/



create or replace
procedure Get_DhlCapabilityList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select    *
    from    dhl_organization;
end;
/

create or replace
procedure Save_DhlMessageRecipient(
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

create or replace
procedure Get_DhlClassifierList(RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    from    dhl_classifier;
end;
/

create or replace
procedure Get_DhlClassifier(
    code in varchar2,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  *
    FROM    dhl_classifier
    WHERE   dhl_classifier_code = Get_DhlClassifier.code;
end;
/

create or replace
procedure Save_DhlClassifier(
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
        update  dhl_classifier
        set     dhl_classifier_id = Save_DhlClassifier.id
        where   dhl_classifier_code = Save_DhlClassifier.code;
    end if;
end;
/


create or replace
procedure Get_DhlMessages(
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

create or replace
procedure Add_DhlMessage(
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

create or replace
procedure Update_DhlMessage(
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

create or replace
procedure Get_DhlMessagesByDhlID(
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

create or replace
procedure Update_DhlMessageDhlID(
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

create or replace
procedure Update_DhlMessageStatus(
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

create or replace
procedure Get_DhlMessageByID(
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

create or replace
procedure Get_DhlMessageIDByGuid(
    dhl_message_id out number,
    dhl_guid in varchar2,
    producer_name varchar2,
    service_url varchar2,
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

create or replace
procedure Save_DhlSubdivision(
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

create or replace
procedure Save_DhlOccupation(
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

create or replace
procedure Save_DhlOrganization(
    org_code in varchar2,
    org_name in varchar2,
    is_dhl_capable in number,
    is_dhl_direct_capable in number,
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
                dhl_direct_producer_name,
                dhl_direct_service_url,
                parent_org_code)
        values  (Save_DhlOrganization.org_code,
                Save_DhlOrganization.org_name,
                Save_DhlOrganization.is_dhl_capable,
                Save_DhlOrganization.is_dhl_direct_capable,
                Save_DhlOrganization.dhl_direct_producer_name,
                Save_DhlOrganization.dhl_direct_service_url,
                Save_DhlOrganization.parent_org_code);
    else
        update  dhl_organization
        set     org_name = Save_DhlOrganization.org_name,
                dhl_capable = Save_DhlOrganization.is_dhl_capable,
                dhl_direct_capable = Save_DhlOrganization.is_dhl_direct_capable,
                dhl_direct_producer_name = Save_DhlOrganization.dhl_direct_producer_name,
                dhl_direct_service_url = Save_DhlOrganization.dhl_direct_service_url,
                parent_org_code = Save_DhlOrganization.parent_org_code
        where   org_code = Save_DhlOrganization.org_code;
    end if;
end;
/

create or replace
procedure Get_DhlCapabilityByMessageID(
    dhl_message_id number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  distinct
            o.dhl_capable,
            o.dhl_direct_capable,
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

create or replace
procedure Get_DhlMessageRecipientId(
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

create or replace
procedure Save_DhlStatusHistory(
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

create or replace procedure Get_DhlMessageByGUID(
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
