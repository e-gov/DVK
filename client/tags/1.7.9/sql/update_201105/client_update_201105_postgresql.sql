----------------------------------------------------------------------
-- May 2011
-- Update DVK Client from version 1.6.1 to 1.6.2
----------------------------------------------------------------------

set search_path = dvk, pg_catalog;

create or replace
function "Update_DhlMessageMetaData"(
    p_id integer,
    p_is_incoming integer,
    p_dhl_id integer,
    p_title character varying,
    p_sender_org_code character varying,
    p_sender_org_name character varying,
    p_sender_person_code character varying,
    p_sender_name character varying,
    p_recipient_org_code character varying,
    p_recipient_org_name character varying,
    p_recipient_person_code character varying,
    p_recipient_name character varying,
    p_case_name character varying,
    p_dhl_folder_name character varying,
    p_sending_status_id integer,
    p_unit_id integer,
    p_sending_date timestamp with time zone,
    p_received_date timestamp with time zone,
    p_local_item_id integer,
    p_recipient_status_id integer,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_status_update_needed integer,
    p_metaxml text,
    p_query_id character varying,
    p_proxy_org_code character varying,
    p_proxy_org_name character varying,
    p_proxy_person_code character varying,
    p_proxy_name character varying,
    p_recipient_department_nr character varying,
    p_recipient_department_name character varying,
    p_recipient_email character varying,
    p_recipient_division_id integer,
    p_recipient_division_name character varying,
    p_recipient_position_id integer,
    p_recipient_position_name character varying,
    p_recipient_division_code character varying,
    p_recipient_position_code character varying,
    p_dhl_guid character varying)
returns boolean
as $$
begin
    update  dhl_message
    set     is_incoming = p_is_incoming,
            dhl_id = p_dhl_id,
            title = p_title,
            sender_org_code = p_sender_org_code,
            sender_org_name = p_sender_org_name,
            sender_person_code = p_sender_person_code,
            sender_name = p_sender_name,
            recipient_org_code = p_recipient_org_code,
            recipient_org_name = p_recipient_org_name,
            recipient_person_code = p_recipient_person_code,
            recipient_name = p_recipient_name,
            case_name = p_case_name,
            dhl_folder_name = p_dhl_folder_name,
            sending_status_id = p_sending_status_id,
            unit_id = p_unit_id,
            sending_date = p_sending_date,
            received_date = p_received_date,
            local_item_id = p_local_item_id,
            recipient_status_id = p_recipient_status_id,
            fault_code = p_fault_code,
            fault_actor = p_fault_actor,
            fault_string = p_fault_string,
            fault_detail = p_fault_detail,
            status_update_needed = p_status_update_needed,
            metaxml = p_metaxml,
            query_id = coalesce(query_id, p_query_id),
            proxy_org_code = p_proxy_org_code,
            proxy_org_name = p_proxy_org_name,
            proxy_person_code = p_proxy_person_code,
            proxy_name = p_proxy_name,
            recipient_department_nr = p_recipient_department_nr,
            recipient_department_name = p_recipient_department_name,
            recipient_email = p_recipient_email,
            recipient_division_id = p_recipient_division_id,
            recipient_division_name = p_recipient_division_name,
            recipient_position_id = p_recipient_position_id,
            recipient_position_name = p_recipient_position_name,
            recipient_division_code = p_recipient_division_code,
            recipient_position_code = p_recipient_position_code,
            dhl_guid = p_dhl_guid
    where   dhl_message_id = p_id;
    return found;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessageID"(
    p_dhl_id integer,
    p_producer_name character varying,
    p_service_url character varying,
    p_is_incoming integer)
returns integer
as $$
declare
    p_dhl_message_id integer;
begin
    if p_is_incoming = 0 then
        select  max(r.dhl_message_id)
        into    p_dhl_message_id
        from    dhl_message_recipient r
        inner join
                dhl_message m on m.dhl_message_id = r.dhl_message_id
        where   m.is_incoming = 0
                and r.dhl_id = p_dhl_id
                and coalesce(r.producer_name,'') = coalesce(p_producer_name,'')
                and coalesce(r.service_url,'') = coalesce(p_service_url,'');
    else
        perform *
        from    dhl_message m
        where   m.dhl_id = p_dhl_id
                and m.is_incoming = p_is_incoming;

        if (found) then
            select  m.dhl_message_id
            into    p_dhl_message_id
            from    dhl_message m
            where   m.dhl_id = p_dhl_id
                    and m.is_incoming = 1;
        else
            p_dhl_message_id := 0;
        end if;
    end if;
    p_dhl_message_id := coalesce(p_dhl_message_id, 0);
    return  p_dhl_message_id;
end; $$
language plpgsql;

create or replace
function "Get_DhlOccupationList"()
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_occupation;
	
	return RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlSubdivisionList"()
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_subdivision;
	
	return RC1;
end; $$
language plpgsql;

create or replace
function "Delete_DhlOccupation"(p_id integer)
returns boolean
as $$
begin
	delete
    from    dhl_occupation
    where   occupation_code = p_id;
    return found;
end; $$
language plpgsql;

create or replace
function "Delete_DhlSubdivision"(p_id integer)
returns boolean
as $$
begin
	delete
    from    dhl_subdivision
    where   subdivision_code = p_id;
    return found;
end; $$
language plpgsql;
