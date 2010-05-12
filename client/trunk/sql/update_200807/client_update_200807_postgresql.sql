set search_path = dvk, pg_catalog;

alter table only dhl_message
    add column query_id character varying(50) null,
    add column proxy_org_code character varying(20) null,
    add column proxy_org_name character varying(100) null,
    add column proxy_person_code character varying(20) null,
    add column proxy_name character varying(100) null,
    add column recipient_department_nr character varying(100) null,
    add column recipient_department_name character varying(500) null,
    add column recipient_email character varying(100) null,
    add column recipient_division_id integer null,
    add column recipient_division_name character varying(100) null,
    add column recipient_position_id integer null,
    add column recipient_position_name character varying(100) null;

create table dhl_counter(
    dhl_id integer null
);

insert into dhl_counter(dhl_id) values(0);

alter table only dhl_message_recipient
    add column dhl_id integer null,
    add column query_id character varying(50) null,
    add column producer_name character varying(50) null,
    add column service_url character varying(100) null,
    add column recipient_division_id integer default 0 not null,
    add column recipient_division_name character varying(100) null,
    add column recipient_position_id integer default 0 not null,
    add column recipient_position_name character varying(100) null;

alter table dhl_message_recipient
drop constraint dhl_message_recipient_pkey;

alter table dhl_message_recipient
add constraint dhl_message_recipient_pkey
primary key (dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id);

alter table only dhl_organization
    add column dhl_direct_service_url character varying(100) null;

create table dhl_occupation (
    occupation_code integer not null,
    occupation_name character varying(100) not null,
    org_code character varying(20) not null
);

alter table only dhl_occupation
    add constraint PK_dhl_occupation primary key (occupation_code);

create table dhl_subdivision (
    subdivision_code integer not null,
    subdivision_name character varying(100) not null,
    org_code character varying(20) not null
);

alter table only dhl_subdivision
    add constraint PK_dhl_subdivision primary key (subdivision_code);

CREATE INDEX ix_dhl_occupation_1 ON dhl_occupation USING btree (org_code);
CREATE INDEX ix_dhl_subdivision_1 ON dhl_subdivision USING btree (org_code);


create or replace
function "Update_DhlMessageStatus"(
    p_dhl_message_id integer,
    p_status_id integer,
    p_status_update_needed integer,
    p_received_date timestamp with time zone)
returns boolean
as $$
begin
    update  dhl_message
    set     sending_status_id = p_status_id,
            status_update_needed = p_status_update_needed,
            received_date = p_received_date
    where   dhl_message_id = p_dhl_message_id;
    return  found;
end; $$
language plpgsql;

create or replace
function "Update_DhlMessageDhlID"(
    p_id integer,
    p_dhl_id integer,
    p_query_id character varying)
returns boolean
as $$
begin
    update  dhl_message
    set     dhl_id = p_dhl_id,
            query_id = nvl(query_id, p_query_id)
    where   dhl_message_id = p_id;
    return  found;
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
    p_recipient_position_name character varying)
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
            query_id = nvl(query_id, p_query_id),
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
            recipient_position_name = p_recipient_position_name
    where   dhl_message_id = p_id;
    return found;
end; $$
language plpgsql;

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
    p_recipient_position_name character varying)
returns integer
as $$
declare
    p_id int4;
    is_incoming_ int2 := p_is_incoming;
begin
    if is_incoming_ is null then
        is_incoming_ := 0;
    end if;
	p_id:=nextval('dvk.sq_dhl_message_id');

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
            recipient_position_name)
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
            p_recipient_position_name);

    return  p_id;
end; $$
language plpgsql;

create or replace
function "Save_DhlOrganization"(
    p_org_code character varying,
    p_org_name character varying,
    p_is_dhl_capable integer,
    p_is_dhl_direct_capable integer,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying)
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
                dhl_direct_producer_name,
                dhl_direct_service_url)
        values  (p_org_code,
                p_org_name,
                p_is_dhl_capable,
                p_is_dhl_direct_capable,
                p_dhl_direct_producer_name,
                p_dhl_direct_service_url);
    else
        update  dhl_organization
        set     org_name = p_org_name,
                dhl_capable = p_is_dhl_capable,
                dhl_direct_capable = p_is_dhl_direct_capable,
                dhl_direct_producer_name = p_dhl_direct_producer_name,
                dhl_direct_service_url = p_dhl_direct_service_url
        where   org_code = p_org_code;
    end if;

    return found;
end; $$
language plpgsql;

create or replace
function "Update_DhlMessageRecipDhlID"(
    p_dhl_message_id integer,
    p_dhl_direct_capable integer,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying,
    p_dhl_id integer,
    p_query_id character varying)
returns boolean
as $$
begin
    -- salvestab vastuvıtja andmetesse vastuvıtja DVK serveri poolt antud sınumi ID v‰‰rtuse
    update  dhl_message_recipient
    set     dhl_id = p_dhl_id,
            query_id = p_query_id 
    where   dhl_message_id = p_dhl_message_id 
            and recipient_org_code in
            (
                select  org_code
                from    dhl_organization
                where   nvl(dhl_direct_capable,1) = nvl(p_dhl_direct_capable,1)
                        and nvl(dhl_direct_producer_name,'') = nvl(p_dhl_direct_producer_name,'')
                        and nvl(dhl_direct_service_url,'') = nvl(p_dhl_direct_service_url,'')
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
            recipient_position_name
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
            o.dhl_direct_producer_name,
            o.dhl_direct_service_url
    from    dhl_organization o
    inner join
        dhl_message_recipient r on r.recipient_org_code = o.org_code
    where   r.dhl_message_id = p_dhl_message_id;

    return  RC1;
end; $$
language plpgsql;

create or replace
function "Get_DhlOrgsByCapability"(
    p_dhl_capable integer,
    p_dhl_direct_capable integer,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  org_code
    from    dhl_organization
    where   nvl(dhl_capable,0) = nvl(p_dhl_capable,0)
            and nvl(dhl_direct_capable,0) = nvl(p_dhl_direct_capable,0)
            and nvl(dhl_direct_producer_name,'') = nvl(p_dhl_direct_producer_name,'')
            and nvl(dhl_direct_service_url,'') = nvl(p_dhl_direct_service_url,'');

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
    set     dhl_id = nvl(dhl_id,0) + 1;

    select  dhl_id
    into    p_dhl_id
    from    dhl_counter;

    return  p_dhl_id;
end; $$
language plpgsql;

create or replace
function "Update_DhlMessageStatus"(
    p_dhl_message_id integer,
    p_status_id integer,
    p_status_update_needed integer,
    p_received_date timestamp with time zone)
returns boolean
as $$
begin
    update  dhl_message
    set     sending_status_id = p_status_id,
            status_update_needed = p_status_update_needed,
            received_date = p_received_date
    where   dhl_message_id = p_dhl_message_id;
    return  found;
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
            recipient_division_name,
            recipient_position_id,
            recipient_position_name
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
    p_producer_name character varying,
    p_service_url character varying,
    p_recipient_division_id integer,
    p_recipient_division_name character varying,
    p_recipient_position_id integer,
    p_recipient_position_name character varying)
returns boolean
as $$
declare
    recipient_org_code_ character varying := p_recipient_org_code;
    recipient_person_code_ character varying := p_recipient_person_code;
    recipient_division_id_ integer := p_recipient_division_id;
    recipient_position_id_ integer := p_recipient_position_id;
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

    perform *
    from    dhl_message_recipient
    where   dhl_message_id = p_dhl_message_id
            and recipient_org_code = recipient_org_code_
            and recipient_person_code = recipient_person_code_
            and recipient_division_id=recipient_division_id_
            and recipient_position_id=recipient_position_id_;

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
                producer_name = p_producer_name,
                service_url = p_service_url,
                recipient_division_name = p_recipient_division_name,
                recipient_position_name = p_recipient_position_name
        where   dhl_message_id = p_dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_;
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
                recipient_position_name)
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
                p_producer_name,
                p_service_url,
                recipient_division_id_,
                p_recipient_division_name,
                recipient_position_id_,
                p_recipient_position_name);
    end if;
    return  found;
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
        select  max(dhl_message_id)
        into    p_dhl_message_id
        from    dhl_message_recipient
        where   dhl_id = p_dhl_id
                and nvl(producer_name,'') = nvl(p_producer_name,'')
                and nvl(service_url,'') = nvl(p_service_url,'');
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
    p_dhl_message_id := nvl(p_dhl_message_id, 0);
    return  p_dhl_message_id;
end; $$
language plpgsql;

create or replace
function "Get_DhlCapability"(org_code character varying)
returns refcursor
as $$
declare
    RC1 refcursor;
begin
    open RC1 for
    select  *
    from    dhl_organization
    where   org_code = p_org_code;
end; $$
language plpgsql;

create or replace
function "Save_DhlSubdivision"(
    p_id integer,
    p_name character varying,
    p_org_code character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_subdivision a
    where   a.subdivision_code = p_id;

    if (found) then
        update  dhl_subdivision
        set     subdivision_name = p_name,
                org_code = p_org_code
        where   subdivision_code = p_id;
    else
        insert
        into    dhl_subdivision(
                subdivision_code,
                subdivision_name,
                org_code)
        values  (p_id,
                p_name,
                p_org_code);
    end if;
    return found;
end; $$
language plpgsql;

create or replace
function "Save_DhlOccupation"(
    p_id integer,
    p_name character varying,
    p_org_code character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_occupation a
    where   a.occupation_code = p_id;

    if (found) then
        update  dhl_occupation
        set     occupation_name = p_name,
                org_code = p_org_code
        where   occupation_code = p_id;
    else
        insert
        into    dhl_occupation(
                occupation_code,
                occupation_name,
                org_code)
        values  (p_id,
                p_name,
                p_org_code);
    end if;
    return found;
end; $$
language plpgsql;
