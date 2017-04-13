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