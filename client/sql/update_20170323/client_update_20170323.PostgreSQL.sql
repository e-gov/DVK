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
