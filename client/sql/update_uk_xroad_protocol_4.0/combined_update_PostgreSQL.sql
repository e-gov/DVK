ALTER TABLE dhl_settings
ADD xroad_client_instance VARCHAR(6),
ADD xroad_client_member_class VARCHAR(50),
ADD xroad_client_subsystem_code VARCHAR(50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);

ALTER TABLE dhl_organization
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);


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

ALTER TABLE dhl_settings
ADD xroad_client_member_code VARCHAR(50);


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
    p_query_id character varying)
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


