create or replace
function "Save_DhlMessageRecipient"(
    p_dhl_message_id integer,
    p_recipient_org_code character varying,
    p_recipient_org_name character varying,
    p_recipient_person_code character varying,
    p_recipient_name character varying,
    p_sending_date timestamp with time zone,
    p_received_date timestamp with time zone,
    p_sending_status_id integer,
    p_recipient_status_id integer,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_metaxml text,
    p_dhl_id integer,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
    p_producer_name character varying,
    p_service_url character varying,
    p_recipient_division_id integer,
    p_recipient_division_name character varying,
    p_recipient_position_id integer,
    p_recipient_position_name character varying,
    p_recipient_division_code character varying,
    p_recipient_position_code character varying)
returns integer
as $$
declare
    recipient_org_code_ character varying := p_recipient_org_code;
    recipient_person_code_ character varying := p_recipient_person_code;
    recipient_division_id_ integer := p_recipient_division_id;
    recipient_position_id_ integer := p_recipient_position_id;
    recipient_division_code_ character varying := p_recipient_division_code;
    recipient_position_code_ character varying := p_recipient_position_code;
    p_id int4;
begin
    if recipient_org_code_ is null then
        recipient_org_code_ := '';
    end if;
    if recipient_person_code_ is null then
        recipient_person_code_ := '';
    end if;
    if recipient_division_id_ is null then
        recipient_division_id_ := 0;
    end if;
    if recipient_position_id_ is null then
        recipient_position_id_ := 0;
    end if;
    if recipient_division_code_ is null then
        recipient_division_code_ := '';
    end if;
    if recipient_position_code_ is null then
        recipient_position_code_ := '';
    end if;

    perform *
    from    dhl_message_recipient
    where   dhl_message_id = p_dhl_message_id
            and recipient_org_code = recipient_org_code_
            and recipient_person_code = recipient_person_code_
            and recipient_division_id = recipient_division_id_
            and recipient_position_id = recipient_position_id_
            and recipient_division_code = recipient_division_code_
            and recipient_position_code = recipient_position_code_;

    if (found) then
        update  dhl_message_recipient
        set     recipient_org_name = p_recipient_org_name,
                recipient_name = p_recipient_name,
                sending_date = p_sending_date,
                received_date = p_received_date,
                sending_status_id = p_sending_status_id,
                recipient_status_id = p_recipient_status_id,
                fault_code = p_fault_code,
                fault_actor = p_fault_actor,
                fault_string = p_fault_string,
                fault_detail = p_fault_detail,
                metaxml = p_metaxml,
                dhl_id = p_dhl_id,
                xroad_service_instance = p_xroad_service_instance,
			    xroad_service_member_class = p_xroad_service_member_class,
			    xroad_service_member_code = p_xroad_service_member_code,
                producer_name = p_producer_name,
                service_url = p_service_url,
                recipient_division_name = p_recipient_division_name,
                recipient_position_name = p_recipient_position_name
        where   dhl_message_id = p_dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;

        select
        into    p_id
                dhl_message_recipient_id
        from    dhl_message_recipient
        where   dhl_message_id = p_dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;
    else
        p_id := nextval('sq_dhl_message_recipient_id');

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
        values  (p_dhl_message_id,
                recipient_org_code_,
                p_recipient_org_name,
                recipient_person_code_,
                p_recipient_name,
                p_sending_date,
                p_received_date,
                p_sending_status_id,
                p_recipient_status_id,
                p_fault_code,
                p_fault_actor,
                p_fault_string,
                p_fault_detail,
                p_metaxml,
                p_dhl_id,
                p_xroad_service_instance,
			    p_xroad_service_member_class,
			    p_xroad_service_member_code,
                p_producer_name,
                p_service_url,
                recipient_division_id_,
                p_recipient_division_name,
                recipient_position_id_,
                p_recipient_position_name,
                recipient_division_code_,
                recipient_position_code_,
                p_id);
    end if;
    return  p_id;
end; $$
language plpgsql;