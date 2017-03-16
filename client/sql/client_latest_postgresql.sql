SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
CREATE LANGUAGE plpgsql;

CREATE SCHEMA dvk;

SET search_path = dvk, pg_catalog;

CREATE SEQUENCE sq_dhl_message_id
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

create or replace
function "Add_DhlMessage"(
    p_is_incoming integer,
    p_data text,
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
returns integer
as $$
declare
    p_id int4;
    is_incoming_ int2 := p_is_incoming;
begin
    if is_incoming_ is null then
        is_incoming_ := 0;
    end if;
    p_id:=nextval('sq_dhl_message_id');

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
    values  (p_id,
            is_incoming_,
            p_data,
            p_dhl_id,
            p_title,
            p_sender_org_code,
            p_sender_org_name,
            p_sender_person_code,
            p_sender_name,
            p_recipient_org_code,
            p_recipient_org_name,
            p_recipient_person_code,
            p_recipient_name,
            p_case_name,
            p_dhl_folder_name,
            p_sending_status_id,
            p_unit_id,
            p_sending_date,
            p_received_date,
            p_local_item_id,
            p_recipient_status_id,
            p_fault_code,
            p_fault_actor,
            p_fault_string,
            p_fault_detail,
            p_status_update_needed,
            p_metaxml,
            p_query_id,
            p_proxy_org_code,
            p_proxy_org_name,
            p_proxy_person_code,
            p_proxy_name,
            p_recipient_department_nr,
            p_recipient_department_name,
            p_recipient_email,
            p_recipient_division_id,
            p_recipient_division_name,
            p_recipient_position_id,
            p_recipient_position_name,
            p_recipient_division_code,
            p_recipient_position_code,
            p_dhl_guid);

    return  p_id;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessages"(
    p_incoming integer,
    p_status_id integer,
    p_unit_id integer,
    p_status_update_needed integer,
    p_metadata_only integer)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when p_metadata_only=0 then data else null end) as data,
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
    where   is_incoming = p_incoming
            and
            (
                sending_status_id = p_status_id
                or p_status_id is null
            )
            and unit_id = p_unit_id
            and
            (
                p_status_update_needed <> 1
                or status_update_needed = 1
            );
    return  RC1;
end; $$
language plpgsql;

CREATE FUNCTION "Get_DhlSettingFolders"(p_dhl_settings_id integer) RETURNS refcursor
    AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  folder_name
    from    dhl_settings_folders
    where   dhl_settings_id = p_dhl_settings_id;

    RETURN RC1;
END;
$$
    LANGUAGE plpgsql;

CREATE FUNCTION "Get_DhlSettings"() RETURNS refcursor
    AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dhl_settings;

    RETURN RC1;
END;$$
    LANGUAGE plpgsql;

create or replace
function "Save_DhlOrganization"(
    p_org_code character varying,
    p_org_name character varying,
    p_is_dhl_capable integer,
    p_is_dhl_direct_capable integer,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying,
    p_parent_org_code character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_organization o
    where   o.org_code = p_org_code;

    if (not found) then
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
        values  (p_org_code,
                p_org_name,
                p_is_dhl_capable,
                p_is_dhl_direct_capable,
                p_xroad_service_instance,
			    p_xroad_service_member_class,
			    p_xroad_service_member_code,
                p_dhl_direct_producer_name,
                p_dhl_direct_service_url,
                p_parent_org_code);
    else
        update  dhl_organization
        set     org_name = p_org_name,
                dhl_capable = p_is_dhl_capable,
                dhl_direct_capable = p_is_dhl_direct_capable,
                xroad_service_instance = p_xroad_service_instance,
                xroad_service_member_class = p_xroad_service_member_class,
                xroad_service_member_code = p_xroad_service_member_code,
                dhl_direct_producer_name = p_dhl_direct_producer_name,
                dhl_direct_service_url = p_dhl_direct_service_url,
                parent_org_code = p_parent_org_code
        where   org_code = p_org_code;
    end if;

    return found;
end; $$
language plpgsql;

create or replace
function "Update_DhlMessage"(
    p_id integer,
    p_is_incoming integer,
    p_data text,
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
            data = p_data,
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
function "Update_DhlMessageDhlID"(
    p_id integer,
    p_dhl_id integer,
    p_query_id character varying,
    p_dhl_guid character varying)
returns boolean
as $$
begin
    update  dhl_message
    set     dhl_id = p_dhl_id,
            query_id = coalesce(query_id, p_query_id),
            dhl_guid = coalesce(dhl_guid, p_dhl_guid)
    where   dhl_message_id = p_id;
    return  found;
end; $$
language plpgsql;

create or replace
function "Update_DhlMessageStatus"(
    p_dhl_message_id integer,
    p_status_id integer,
    p_status_update_needed integer,
    p_received_date timestamp with time zone,
    p_sending_date timestamp with time zone)
returns boolean
as $$
begin
    update  dhl_message
    set     sending_status_id = p_status_id,
            status_update_needed = p_status_update_needed,
            received_date = coalesce(received_date, p_received_date),
            sending_date = coalesce(sending_date, p_sending_date)
    where   dhl_message_id = p_dhl_message_id;
    return  found;
end; $$
language plpgsql;

create or replace
function "Update_DhlMsgStatusUpdateNeed"(p_message_id integer, p_status_update_needed integer) RETURNS boolean
AS $$
BEGIN
    if (p_status_update_needed = 1) then
        update  dhl_message
        set     status_update_needed = true
        where   dhl_message_id = p_message_id;
    else
        update  dhl_message
        set     status_update_needed = null
        where   dhl_message_id = p_message_id;
    end if;
    RETURN  FOUND;
END; $$
language plpgsql;

CREATE FUNCTION "Get_DhlMessageRecipients"(p_message_id integer) RETURNS refcursor
AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dhl_message_recipient
    where   dhl_message_id = p_message_id;
    RETURN  RC1;
END; $$
    LANGUAGE plpgsql;

create or replace
function "Get_DhlMessageID"(
    p_dhl_id integer,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
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
                and coalesce(r.xroad_service_instance,'') = coalesce(p_xroad_service_instance,'')
	            and coalesce(r.xroad_service_member_class,'') = coalesce(p_xroad_service_member_class,'')
	            and coalesce(r.xroad_service_member_code,'') = coalesce(p_xroad_service_member_code,'')
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

create or replace
function "Update_DhlMessageRecipDhlID"(
    p_dhl_message_id integer,
    p_dhl_direct_capable integer,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying,
    p_dhl_id integer,
    p_query_id character varying,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying)
returns boolean
as $$
begin
    -- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
    update  dhl_message_recipient
    set     dhl_id = p_dhl_id,
            query_id = p_query_id,
            xroad_service_instance = p_xroad_service_instance,
		    xroad_service_member_class = p_xroad_service_member_class,
		    xroad_service_member_code = p_dhl_direct_producer_name,
		    producer_name = p_dhl_direct_producer_name,
		    service_url = p_dhl_direct_service_url
    where   dhl_message_id = p_dhl_message_id
            and recipient_org_code in
            (
                select  org_code
                from    dhl_organization
                where   coalesce(dhl_direct_capable,1) =coalesce(p_dhl_direct_capable,1)
                        and coalesce(xroad_service_instance,'') = coalesce(p_xroad_service_instance,'')
			            and coalesce(xroad_service_member_class,'') = coalesce(p_xroad_service_member_class,'')
			            and coalesce(xroad_service_member_code,'') = coalesce(p_xroad_service_member_code,'')
                        and coalesce(dhl_direct_producer_name,'') = coalesce(p_dhl_direct_producer_name,'')
                        and coalesce(dhl_direct_service_url,'') = coalesce(p_dhl_direct_service_url,'')
            );

    return found;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessagesByDhlID"(
    p_dhl_id integer,
    p_incoming integer,
    p_metadata_only integer)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when p_metadata_only=0 then data else null end) as data,
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
    where   is_incoming = p_incoming
            and dhl_id = p_dhl_id;

    return  RC1;
end; $$
language plpgsql;

create or replace
function "Get_AsutusStat"(p_asutus_id in integer)
returns integer
as $$
declare
    p_vahetatud_dokumente integer;
begin
    select  count(*)
    into    p_vahetatud_dokumente
    from    dhl_message
    where   unit_id = p_asutus_id;

    return  p_vahetatud_dokumente;
end; $$
language plpgsql;

create or replace
function "Get_DhlCapabilityByMessageID"(p_dhl_message_id integer)
returns refcursor
as $$
declare
    RC1 refcursor;
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
    where   r.dhl_message_id = p_dhl_message_id
    order by
            o.dhl_direct_service_url desc;

    return  RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlOrgsByCapability"(
    p_dhl_capable integer,
    p_dhl_direct_capable integer,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  org_code
    from    dhl_organization
    where   coalesce(dhl_capable,0) = coalesce(p_dhl_capable,0)
            and coalesce(dhl_direct_capable,0) = coalesce(p_dhl_direct_capable,0)
            and coalesce(dhl_direct_producer_name,'') = coalesce(p_dhl_direct_producer_name,'')
            and coalesce(dhl_direct_service_url,'') = coalesce(p_dhl_direct_service_url,'')
            and coalesce(xroad_service_instance,'') = coalesce(p_xroad_service_instance,'')
            and coalesce(xroad_service_member_class,'') = coalesce(p_xroad_service_member_class,'')
            and coalesce(xroad_service_member_code,'') = coalesce(p_xroad_service_member_code,'');

    return  RC1;
end; $$
language plpgsql;

create or replace
function "Get_NextDhlID"()
returns integer
as $$
declare
    p_dhl_id integer;
begin
    update  dhl_counter
    set     dhl_id = coalesce(dhl_id,0) + 1;

    select  dhl_id
    into    p_dhl_id
    from    dhl_counter;

    return  p_dhl_id;
end; $$
language plpgsql;

create or replace
function "Get_DhlCapability"(p_org_code in character varying)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_organization
    where   org_code = p_org_code;

	return  RC1;
end; $$
language plpgsql;

create or replace
function "Save_DhlSubdivision"(
    p_id integer,
    p_name character varying,
    p_org_code character varying,
    p_short_name character varying,
    p_parent_subdivision_short_name character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_subdivision a
    where   a.subdivision_code = p_id;

    if (found) then
        update  dhl_subdivision
        set     subdivision_name = p_name,
                org_code = p_org_code,
                subdivision_short_name = p_short_name,
                parent_subdivision_short_name = p_parent_subdivision_short_name
        where   subdivision_code = p_id;
    else
        insert
        into    dhl_subdivision(
                subdivision_code,
                subdivision_name,
                org_code,
                subdivision_short_name,
                parent_subdivision_short_name)
        values  (p_id,
                p_name,
                p_org_code,
                p_short_name,
                p_parent_subdivision_short_name);
    end if;
    return found;
end; $$
language plpgsql;

create or replace
function "Save_DhlOccupation"(
    p_id integer,
    p_name character varying,
    p_org_code character varying,
    p_short_name character varying,
    p_parent_subdivision_short_name character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_occupation a
    where   a.occupation_code = p_id;

    if (found) then
        update  dhl_occupation
        set     occupation_name = p_name,
                org_code = p_org_code,
                occupation_short_name = p_short_name,
                parent_subdivision_short_name = p_parent_subdivision_short_name
        where   occupation_code = p_id;
    else
        insert
        into    dhl_occupation(
                occupation_code,
                occupation_name,
                org_code,
                occupation_short_name,
                parent_subdivision_short_name)
        values  (p_id,
                p_name,
                p_org_code,
                p_short_name,
                p_parent_subdivision_short_name);
    end if;
    return found;
end; $$
language plpgsql;

create or replace
function "Get_DhlCapabilityList"()
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_organization;

	return RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlClassifierList"()
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_classifier;

    return RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlClassifier"(
    p_code character varying)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_classifier
    where   dhl_classifier_code = p_code;

    return RC1;
end; $$
language plpgsql;

create or replace
function "Save_DhlClassifier"(
    p_code character varying,
    p_id int)
returns boolean
as $$
begin
    perform    *
    from    dhl_classifier
    where   dhl_classifier_code = p_code;

    if not found then
        insert into dhl_classifier(dhl_classifier_code, dhl_classifier_id)
        values (p_code, p_id);
    else
        update  dhl_classifier
        set     dhl_classifier_id = p_id
        where   dhl_classifier_code = p_code;
    end if;

    return found;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessageByID"(
    p_id integer,
    p_metadata_only integer)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when p_metadata_only=0 then data else null end) as data,
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
    where   dhl_message_id = p_id;

    return  RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessageIDByGuid"(
    p_dhl_guid character varying,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
    p_producer_name character varying,
    p_service_url character varying,
    p_is_incoming integer)
returns integer
as $$
declare
    p_dhl_message_id integer;
begin
    if p_is_incoming = 0 then
        select  max(m.dhl_message_id)
        into    p_dhl_message_id
        from    dhl_message m
        inner join
                dhl_message_recipient r on r.dhl_message_id = m.dhl_message_id
        where   m.dhl_guid = p_dhl_guid
        		and coalesce(r.xroad_service_instance,'') = coalesce(p_xroad_service_instance,'')
	            and coalesce(r.xroad_service_member_class,'') = coalesce(p_xroad_service_member_class,'')
	            and coalesce(r.xroad_service_member_code,'') = coalesce(p_xroad_service_member_code,'')
                and coalesce(r.producer_name,'') = coalesce(p_producer_name,'')
                and coalesce(r.service_url,'') = coalesce(p_service_url,'')
                and m.is_incoming = 0;
    else
        perform *
        from    dhl_message m
        where   m.dhl_id = p_dhl_id
                and m.is_incoming = p_is_incoming;

        if (found) then
            select  m.dhl_message_id
            into    p_dhl_message_id
            from    dhl_message m
            where   m.dhl_guid = p_dhl_guid
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
function "Get_DhlMessageRecipientId"(
    p_dhl_message_id integer,
    p_recipient_org_code character varying,
    p_recipient_person_code character varying,
    p_recipient_division_code character varying,
    p_recipient_position_code character varying)
returns integer
as $$
declare
    recipient_org_code_ character varying := p_recipient_org_code;
    recipient_person_code_ character varying := p_recipient_person_code;
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
            and recipient_division_code = recipient_division_code_
            and recipient_position_code = recipient_position_code_;

    if (found) then
        select
        into    p_id
                dhl_message_recipient_id
        from    dhl_message_recipient
        where   dhl_message_id = p_dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;
    else
        p_id := 0;
    end if;
    return  p_id;
end; $$
language plpgsql;

create or replace
function "Save_DhlStatusHistory"(
    p_dhl_message_recipient_id integer,
    p_server_side_id integer,
    p_sending_status_id integer,
    p_status_date timestamp with time zone,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_recipient_status_id integer,
    p_metaxml text)
returns integer
as $$
declare p_id int4;
begin
    perform *
    from    dhl_status_history
    where   dhl_message_recipient_id = p_dhl_message_recipient_id
            and server_side_id = p_server_side_id;

    if (found) then
        select
        into    p_id
                dhl_status_history_id
        from    dhl_status_history
        where   dhl_message_recipient_id = p_dhl_message_recipient_id
                and server_side_id = p_server_side_id;
    else
        p_id := nextval('sq_dhl_status_history_id');

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
        values  (p_id,
                p_dhl_message_recipient_id,
                p_server_side_id,
                p_sending_status_id,
                p_status_date,
                p_fault_code,
                p_fault_actor,
                p_fault_string,
                p_fault_detail,
                p_recipient_status_id,
                p_metaxml);
    end if;
    return  p_id;
end; $$
language plpgsql;

create or replace
function "Get_DhlMessageByGUID"(
    p_guid character varying,
    p_metadata_only integer)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  dhl_message_id,
            is_incoming,
            (case when p_metadata_only=0 then data else null end) as data,
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
    where   guid = p_guid;

    return RC1;
end; $$
language plpgsql;

create or replace
function "Delete_OldDhlMessages"(p_doc_lifetime_days integer)
returns integer
as $$
declare
    result integer := 0;
    tmp_rc integer := 0;
begin
    if (p_doc_lifetime_days is not null) and (p_doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	is_incoming = 1
				and (current_date - received_date) >= p_doc_lifetime_days;
		GET DIAGNOSTICS tmp_rc = ROW_COUNT;
		result := result + tmp_rc;

		-- Delete old sent documents
		delete
		from	dhl_message
		where	is_incoming = 0
				and (current_date - sending_date) >= p_doc_lifetime_days;
		GET DIAGNOSTICS tmp_rc = ROW_COUNT;
		result := result + tmp_rc;
	end if;

    return  result;
end; $$
language plpgsql;

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



CREATE TABLE dhl_message (
    dhl_message_id integer DEFAULT nextval('sq_dhl_message_id'::regclass) NOT NULL,
    is_incoming smallint NOT NULL,
    data text NOT NULL,
    title character varying(1000),
    sender_org_code character varying(20),
    sender_org_name character varying(100),
    sender_person_code character varying(20),
    sender_name character varying(100),
    recipient_org_code character varying(20),
    recipient_org_name character varying(100),
    recipient_person_code character varying(20),
    recipient_name character varying(100),
    case_name character varying(250),
    dhl_folder_name character varying(1000),
    sending_status_id integer NOT NULL,
    unit_id integer NOT NULL,
    dhl_id integer,
    sending_date timestamp,
    received_date timestamp,
    local_item_id integer,
    recipient_status_id integer,
    fault_code character varying(50),
    fault_actor character varying(250),
    fault_string character varying(500),
    fault_detail character varying(2000),
    status_update_needed integer,
    metaxml text,
    query_id character varying(50) null,
    proxy_org_code character varying(20) null,
    proxy_org_name character varying(100) null,
    proxy_person_code character varying(20) null,
    proxy_name character varying(100) null,
    recipient_department_nr character varying(100) null,
    recipient_department_name character varying(500) null,
    recipient_email character varying(100) null,
    recipient_division_id integer null,
    recipient_division_name character varying(100) null,
    recipient_position_id integer null,
    recipient_position_name character varying(100) null,
    recipient_division_code character varying(25) null,
    recipient_position_code character varying(25) null,
    dhl_guid character varying(36) null
);

CREATE TABLE dhl_organization (
    org_code character varying(30) NOT NULL,
    org_name character varying(100) NOT NULL,
    dhl_capable smallint DEFAULT 0 NOT NULL,
    dhl_direct_capable smallint DEFAULT 0 NOT NULL,
    xroad_service_instance character varying(2),
    xroad_service_member_class character varying(50),
    xroad_service_member_code character varying(50),
    dhl_direct_producer_name character varying(50),
    dhl_direct_service_url character varying(100) null,
	parent_org_code character varying(20) null
);

CREATE TABLE dhl_settings (
    id integer NOT NULL,
    institution_code character varying(20) NOT NULL,
    institution_name character varying(250) NOT NULL,
    personal_id_code character varying(20) NOT NULL,
    unit_id integer NOT NULL,
    subdivision_code integer NULL,
    occupation_code integer NULL,
	subdivision_short_name character varying(25) null,
    occupation_short_name character varying(25) null,
    subdivision_name character varying(250) null,
    occupation_name character varying(250) null,
    container_version integer NULL,
    xroad_client_instance VARCHAR(6) NOT NULL,
    xroad_client_member_class VARCHAR(50) NOT NULL,
    xroad_client_subsystem_code VARCHAR(50) NOT NULL,
    xroad_client_member_code VARCHAR(50) NOT NULL
);

CREATE TABLE dhl_settings_folders (
    id integer NOT NULL,
    dhl_settings_id integer NOT NULL,
    folder_name character varying(4000)
);

create sequence sq_dhl_message_recipient_id
    increment by 1
    no maxvalue
    no minvalue
    cache 1;

CREATE TABLE dhl_message_recipient (
    dhl_message_id integer NOT NULL,
    recipient_org_code character varying(20) NOT NULL,
    recipient_org_name character varying(100),
    recipient_person_code character varying(20) NOT NULL,
    recipient_name character varying(100),
    sending_date timestamp,
    received_date timestamp,
    sending_status_id integer not null,
    recipient_status_id integer,
    fault_code character varying(50),
    fault_actor character varying(250),
    fault_string character varying(500),
    fault_detail character varying(2000),
    metaxml text,
    dhl_id integer null,
    query_id character varying(50) null,
    xroad_service_instance character varying(2),
	xroad_service_member_class character varying(50),
	xroad_service_member_code character varying(50),
    producer_name character varying(50) null,
    service_url character varying(100) null,
    recipient_division_id integer default 0 not null,
    recipient_division_name character varying(100) null,
    recipient_position_id integer default 0 not null,
    recipient_position_name character varying(100) null,
	recipient_division_code character varying(25) default '' not null,
    recipient_position_code character varying(25) default '' not null,
	dhl_message_recipient_id int default nextval('sq_dhl_message_recipient_id'::regclass) not null
);

create table dhl_counter(
    dhl_id integer null
);

insert into dhl_counter(dhl_id) values(0);

create table dhl_occupation (
    occupation_code integer not null,
    occupation_name character varying(100) not null,
    org_code character varying(20) not null,
	occupation_short_name character varying(25) null,
	parent_subdivision_short_name character varying(25) null
);

alter table only dhl_occupation
    add constraint PK_dhl_occupation primary key (occupation_code);

create table dhl_subdivision (
    subdivision_code integer not null,
    subdivision_name character varying(100) not null,
    org_code character varying(20) not null,
	subdivision_short_name character varying(25) null,
    parent_subdivision_short_name character varying(25) null
);

alter table only dhl_subdivision
    add constraint PK_dhl_subdivision primary key (subdivision_code);

create table dhl_classifier(
    dhl_classifier_code character varying(20) not null,
	dhl_classifier_id int null
);

alter table only dhl_classifier
	add constraint dhl_classifier_pkey primary key (dhl_classifier_code);

insert into dhl_classifier(dhl_classifier_code,dhl_classifier_id) values('STATUS_WAITING', 1);
insert into dhl_classifier(dhl_classifier_code,dhl_classifier_id) values('STATUS_SENDING', 2);
insert into dhl_classifier(dhl_classifier_code,dhl_classifier_id) values('STATUS_SENT', 3);
insert into dhl_classifier(dhl_classifier_code,dhl_classifier_id) values('STATUS_CANCELED', 4);
insert into dhl_classifier(dhl_classifier_code,dhl_classifier_id) values('STATUS_RECEIVED', 5);

create sequence sq_dhl_status_history_id
    increment by 1
    no maxvalue
    no minvalue
    cache 1;

create table dhl_status_history(
    dhl_status_history_id int not null default nextval('sq_dhl_status_history_id'::regclass),
    server_side_id int not null,
    dhl_message_recipient_id int not null,
    sending_status_id int not null,
    status_date timestamp null,
    fault_code character varying(50) null,
    fault_actor character varying(250) null,
    fault_string character varying(500) null,
    fault_detail character varying(2000) null,
    recipient_status_id int null,
    metaxml text null
);

alter table only dhl_status_history
    add constraint dhl_status_history_pkey primary key (dhl_status_history_id);

CREATE SEQUENCE dhl_settings_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE dhl_settings_folders ALTER COLUMN id SET DEFAULT nextval('dhl_settings_folders_id_seq'::regclass);

ALTER TABLE ONLY dhl_message
    ADD CONSTRAINT dhl_message_pkey PRIMARY KEY (dhl_message_id);

ALTER TABLE ONLY dhl_organization
    ADD CONSTRAINT dhl_organization_pkey PRIMARY KEY (org_code);

ALTER TABLE ONLY dhl_settings_folders
    ADD CONSTRAINT dhl_settings_folders_pkey PRIMARY KEY (id);

ALTER TABLE ONLY dhl_settings
    ADD CONSTRAINT dhl_settings_pkey PRIMARY KEY (id);

ALTER TABLE ONLY dhl_settings_folders
    ADD CONSTRAINT fk_dhl_settings_folders FOREIGN KEY (dhl_settings_id) REFERENCES dhl_settings(id) ON UPDATE RESTRICT ON DELETE CASCADE;

alter table only dhl_message_recipient
    add constraint dhl_message_recipient_pkey primary key(dhl_message_recipient_id);

alter table only dhl_message_recipient
    add constraint dhl_message_recipient_un unique(dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id, recipient_division_code, recipient_position_code);

ALTER TABLE dhl_message_recipient
    ADD CONSTRAINT fk_dhl_message_recipient_1 FOREIGN KEY (dhl_message_id) REFERENCES dhl_message (dhl_message_id) ON UPDATE RESTRICT ON DELETE CASCADE;

alter table only dhl_status_history
    add constraint fk_dhl_status_history_1 foreign key (dhl_message_recipient_id) references dhl_message_recipient (dhl_message_recipient_id) on delete cascade;

CREATE INDEX ix_dhl_message_1 ON dhl_message USING btree (unit_id);
CREATE INDEX ix_dhl_message_2 ON dhl_message USING btree (dhl_id);
CREATE INDEX ix_dhl_message_3 ON dhl_message USING btree (sending_status_id);
CREATE UNIQUE INDEX ix_dhl_settings_1 ON dhl_settings USING btree (unit_id);
CREATE INDEX ix_dhl_occupation_1 ON dhl_occupation USING btree (org_code);
CREATE INDEX ix_dhl_subdivision_1 ON dhl_subdivision USING btree (org_code);

CREATE SEQUENCE sq_dhl_error_log_id_seq
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO MINVALUE
CACHE 1;

CREATE SEQUENCE sq_dhl_request_log_id_seq
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO MINVALUE
CACHE 1;

CREATE TABLE dhl_error_log
(
dhl_error_log_id integer DEFAULT nextval('sq_dhl_error_log_id_seq') NOT NULL,
error_datetime timestamp NOT NULL,
organization_code character varying(20),
user_code character varying(20),
action_name character varying(200),
error_message character varying(500) NOT NULL,
dhl_message_id integer
);

CREATE TABLE dhl_request_log
(
dhl_request_log_id integer DEFAULT nextval('sq_dhl_request_log_id_seq') NOT NULL,
request_datetime timestamp NOT NULL,
organization_code character varying(20) NOT NULL,
user_code character varying(20),
request_name character varying(100) NOT NULL,
response character varying(10),
dhl_error_log_id integer
);

ALTER TABLE dhl_error_log
    ADD CONSTRAINT PK_dhl_error_log PRIMARY KEY (dhl_error_log_id);

ALTER TABLE dhl_error_log
    ADD CONSTRAINT FK_dhl_message_id FOREIGN KEY (dhl_message_id) REFERENCES dhl_message(dhl_message_id) ON DELETE CASCADE;

ALTER TABLE dhl_error_log ADD CONSTRAINT UQ_dhl_error_log_id UNIQUE (dhl_error_log_id);

ALTER TABLE dhl_request_log
    ADD CONSTRAINT PK_dhl_request_log PRIMARY KEY (dhl_request_log_id);

ALTER TABLE dhl_request_log
    ADD CONSTRAINT FK_dhl_error_log_id FOREIGN KEY (dhl_error_log_id) REFERENCES dhl_error_log(dhl_error_log_id) ON DELETE CASCADE;

ALTER TABLE dhl_request_log ADD CONSTRAINT UQ_dhl_request_log_id UNIQUE (dhl_request_log_id);

create or replace
function "Add_DhlErrorLog"(
    p_dhl_error_log_id integer,
    p_error_datetime timestamp,
    p_organization_code character varying,
    p_user_code character varying,
    p_action_name character varying,
    p_error_message character varying,
    p_dhl_message_id integer
)
returns integer
as $$
declare
    p_id int4;
begin
    p_id:=nextval('sq_dhl_error_log_id_seq');

    insert
    into    dhl_error_log(
            dhl_error_log_id,
            error_datetime,
            organization_code,
            user_code,
            action_name,
            error_message,
            dhl_message_id)
    values  (p_id,
            p_error_datetime,
            p_organization_code,
            p_user_code,
            p_action_name,
            p_error_message,
            p_dhl_message_id);

    return  p_id;
end; $$
language plpgsql;

create or replace
function "Add_DhlRequestLog"(
    p_dhl_request_log_id integer,
    p_request_datetime timestamp,
    p_organization_code character varying,
    p_user_code character varying,
    p_request_name character varying,
    p_response character varying,
    p_dhl_error_log_id integer
)
returns integer
as $$
declare
    p_id int4;
begin
    p_id:=nextval('sq_dhl_request_log_id_seq');

    insert
    into    dhl_request_log(
            dhl_request_log_id,
            request_datetime,
            organization_code,
            user_code,
            request_name,
            response,
            dhl_error_log_id)
    values  (p_id,
            p_request_datetime,
            p_organization_code,
            p_user_code,
            p_request_name,
            p_response,
            p_dhl_error_log_id);

    return  p_id;
end; $$
language plpgsql;

ALTER TABLE dhl_message_recipient ADD COLUMN opened timestamp;

CREATE OR REPLACE FUNCTION "Get_NotOpenedInAdit"() RETURNS refcursor
AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  recipient.*
    from    dhl_message_recipient as recipient, dhl_message as message
    where   LOWER(recipient.recipient_org_code)='adit'
      and recipient.opened is null
      and recipient.dhl_message_id = message.dhl_message_id
      and message.is_incoming=0
      and recipient.dhl_id is not null
      and message.dhl_id is not null;
    RETURN  RC1;
END; $$
    LANGUAGE plpgsql;

create or replace
function "Update_MessageRecipientOpened"(
    p_dhl_id integer,
    p_recipient_person_code character varying,
    p_person_code_with_prefix character varying,
    p_opened timestamp)
returns boolean
as $$
begin
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and
      (recipient_person_code = p_recipient_person_code or recipient_person_code = p_person_code_with_prefix);
    return found;
end; $$
language plpgsql;












