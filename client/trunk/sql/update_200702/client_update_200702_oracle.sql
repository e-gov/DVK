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
    metaxml clob null
)
/

alter table dhl_message_recipient
add constraint PK_dhl_message_recipient
primary key (dhl_message_id, recipient_org_code, recipient_person_code)
/

alter table dhl_message_recipient
add constraint fk_dhl_message_recipient_1
foreign key (dhl_message_id)
referencing dhl_message (dhl_message_id)
on delete cascade
/

alter
table   dhl_message
drop
column  error_message
/

alter
table   dhl_message
add
(
    recipient_status_id number(10,0) null,
    fault_code varchar2(50) null,
    fault_actor varchar2(250) null,
    fault_string varchar2(500) null,
    fault_detail varchar2(2000) null,
    status_update_needed number(10,0) null,
    metaxml clob null
)
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
    metaxml in clob)
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
            metaxml)
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
            Add_DhlMessage.metaxml);

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
    metaxml in clob)
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
            metaxml = Update_DhlMessage.metaxml
    where   dhl_message_id = Update_DhlMessage.id;
end;
/

create or replace
procedure Get_DhlMessages(
    incoming in number,
    status_id in number,
    unit_id in number,
    status_update_needed in number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  m.*
    from    dhl_message m
    where   m.is_incoming = Get_DhlMessages.incoming
            and
            (
                m.sending_status_id = Get_DhlMessages.status_id
                or Get_DhlMessages.status_id is null
            )
            and m.unit_id = Get_DhlMessages.unit_id
            and
            (
                Get_DhlMessages.status_update_needed <> 1
                or status_update_needed = 1
            );
end;
/

create or replace
procedure Update_DhlMsgStatusUpdateNeed(
    message_id in number,
    status_update_needed in number)
as
begin
    update  dhl_message
    set     status_update_needed = Update_DhlMsgStatusUpdateNeed.status_update_needed
    where   dhl_message_id = Update_DhlMsgStatusUpdateNeed.message_id;
end;
/

create or replace
procedure Get_DhlMessageRecipients(
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

create or replace
procedure Get_DhlMessageID(
    dhl_message_id out number,
    dhl_id in number,
    is_incoming in number)
as
cnt number(38,0);
begin
    select  count(*)
    into    cnt
    from    dhl_message m
    where   m.dhl_id = Get_DhlMessageID.dhl_id
            and m.is_incoming = Get_DhlMessageID.is_incoming;
    
    if (cnt > 0) then
        select  m.dhl_message_id
        into    Get_DhlMessageID.dhl_message_id
        from    dhl_message m
        where   m.dhl_id = Get_DhlMessageID.dhl_id
                and m.is_incoming = Get_DhlMessageID.is_incoming;
    else
        Get_DhlMessageID.dhl_message_id := 0;
    end if;
end;
/

create or replace
procedure Save_DhlMessageRecipient(
    dhl_message_id in number,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    sending_date in date,
    received_date in date,
    sending_status_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    metaxml in clob)
as
cnt number(10,0);
recipient_org_code_ varchar2(20) := Save_DhlMessageRecipient.recipient_org_code;
recipient_person_code_ varchar2(20) := Save_DhlMessageRecipient.recipient_person_code;
begin
    if recipient_org_code_ is null then
        recipient_org_code_ := '';
    end if;
    if recipient_person_code_ is null then
        recipient_person_code_ := '';
    end if;
	
    select  count(*)
    into    cnt
    from    dhl_message_recipient
    where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
            and recipient_org_code = Save_DhlMessageRecipient.recipient_org_code
            and recipient_person_code = Save_DhlMessageRecipient.recipient_person_code;
    
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
                metaxml = Save_DhlMessageRecipient.metaxml
        where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
                and recipient_org_code = Save_DhlMessageRecipient.recipient_org_code
                and recipient_person_code = Save_DhlMessageRecipient.recipient_person_code;
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
                metaxml)
       values  (Save_DhlMessageRecipient.dhl_message_id,
                Save_DhlMessageRecipient.recipient_org_code,
                Save_DhlMessageRecipient.recipient_org_name,
                Save_DhlMessageRecipient.recipient_person_code,
                Save_DhlMessageRecipient.recipient_name,
                Save_DhlMessageRecipient.sending_date,
                Save_DhlMessageRecipient.received_date,
                Save_DhlMessageRecipient.sending_status_id,
                Save_DhlMessageRecipient.recipient_status_id,
                Save_DhlMessageRecipient.fault_code,
                Save_DhlMessageRecipient.fault_actor,
                Save_DhlMessageRecipient.fault_string,
                Save_DhlMessageRecipient.fault_detail,
                Save_DhlMessageRecipient.metaxml);
	end if;
end;
/

create or replace
procedure Update_DhlMessageStatus(
    dhl_message_id in number,
    status_id in number)
AS
begin
    update  dhl_message
    set     sending_status_id = Update_DhlMessageStatus.status_id
    where   dhl_message_id = Update_DhlMessageStatus.dhl_message_id;
end;
/

