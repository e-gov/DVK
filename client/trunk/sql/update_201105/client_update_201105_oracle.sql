----------------------------------------------------------------------
-- May 2011
-- Update DVK Client from version 1.6.1 to 1.6.2
----------------------------------------------------------------------

create or replace
procedure Update_DhlMessageMetaData(
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
procedure Get_DhlMessageID(
    dhl_message_id out number,
    dhl_id in number,
    producer_name varchar2,
    service_url varchar2,
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
