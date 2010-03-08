set search_path = dvk, pg_catalog;



create sequence sq_dhl_message_recipient_id
    increment by 1
    no maxvalue
    no minvalue
    cache 1;

alter table only dhl_message_recipient
    add column recipient_division_code character varying(25) default '' not null,
    add column recipient_position_code character varying(25) default '' not null,
    add column dhl_message_recipient_id int default nextval('sq_dhl_message_recipient_id'::regclass) not null;

alter table only dhl_message_recipient
    drop constraint dhl_message_recipient_pkey;

alter table only dhl_message_recipient
    add constraint dhl_message_recipient_pkey primary key(dhl_message_recipient_id);

alter table only dhl_message_recipient
    add constraint dhl_message_recipient_un unique(dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id, recipient_division_code, recipient_position_code);


alter table only dhl_message
    add column recipient_division_code character varying(25) null,
    add column recipient_position_code character varying(25) null,
    add column dhl_guid character varying(36) null;

alter table only dhl_settings
    add column subdivision_short_name character varying(25) null,
    add column occupation_short_name character varying(25) null,
    add column subdivision_name character varying(250) null,
    add column occupation_name character varying(250) null,
    add column container_version int null;

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

alter table only dhl_subdivision
    add column subdivision_short_name character varying(25) null,
    add column parent_subdivision_short_name character varying(25) null;

alter table only dhl_occupation
    add column occupation_short_name character varying(25) null,
    add column parent_subdivision_short_name character varying(25) null;

alter table only dhl_organization
    add column parent_org_code character varying(20) null;


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
    status_date date null,
    fault_code character varying(50) null,
    fault_actor character varying(250) null,
    fault_string character varying(500) null,
    fault_detail character varying(2000) null,
    recipient_status_id int null,
    metaxml text null
);

alter table only dhl_status_history
    add constraint dhl_status_history_pkey primary key (dhl_status_history_id);

alter table only dhl_status_history
    add constraint fk_dhl_status_history_1 foreign key (dhl_message_recipient_id) references dhl_message_recipient (dhl_message_recipient_id) on delete cascade;




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

drop function if exists "Save_DhlMessageRecipient"(
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    timestamp with time zone,
    timestamp with time zone,
    integer,
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    text,
    integer,
    character varying,
    character varying,
    integer,
    character varying,
    integer,
    character varying);

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

drop function if exists "Add_DhlMessage"(
    integer,
    text,
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    integer,
    timestamp with time zone,
    timestamp with time zone,
    integer,
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    text,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    character varying,
    integer,
    character varying);

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


drop function if exists "Update_DhlMessage"(
    integer,
    integer,
    text,
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    integer,
    timestamp with time zone,
    timestamp with time zone,
    integer,
    integer,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    text,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    character varying,
    integer,
    character varying,
    integer,
    character varying);

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


drop function if exists "Update_DhlMessageDhlID"(integer, integer, character varying);

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


drop function if exists "Update_DhlMessageStatus"(integer, integer, integer, timestamp with time zone);

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

drop function if exists "Update_DhlMsgStatusUpdateNeed"(integer, boolean);

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
                and coalesce(producer_name,'') = coalesce(p_producer_name,'')
                and coalesce(service_url,'') = coalesce(p_service_url,'');
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
    -- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
    update  dhl_message_recipient
    set     dhl_id = p_dhl_id,
            query_id = p_query_id 
    where   dhl_message_id = p_dhl_message_id 
            and recipient_org_code in
            (
                select  org_code
                from    dhl_organization
                where   coalesce(dhl_direct_capable,1) =coalesce(p_dhl_direct_capable,1)
                        and coalesce(dhl_direct_producer_name,'') = coalesce(p_dhl_direct_producer_name,'')
                        and coalesce(dhl_direct_service_url,'') = coalesce(p_dhl_direct_service_url,'')
            );

    return found;
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
    where   coalesce(dhl_capable,0) = coalesce(p_dhl_capable,0)
            and coalesce(dhl_direct_capable,0) = coalesce(p_dhl_direct_capable,0)
            and coalesce(dhl_direct_producer_name,'') = coalesce(p_dhl_direct_producer_name,'')
            and coalesce(dhl_direct_service_url,'') = coalesce(p_dhl_direct_service_url,'');

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


drop function if exists "Save_DhlSubdivision"(integer, character varying, character varying);

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


drop function if exists "Save_DhlOccupation"(integer, character varying, character varying);

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


drop function if exists "Save_DhlOrganization"(character varying, character varying, integer, integer, character varying, character varying);

create or replace
function "Save_DhlOrganization"(
    p_org_code character varying,
    p_org_name character varying,
    p_is_dhl_capable integer,
    p_is_dhl_direct_capable integer,
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
                dhl_direct_producer_name,
                dhl_direct_service_url,
                parent_org_code)
        values  (p_org_code,
                p_org_name,
                p_is_dhl_capable,
                p_is_dhl_direct_capable,
                p_dhl_direct_producer_name,
                p_dhl_direct_service_url,
                p_parent_org_code);
    else
        update  dhl_organization
        set     org_name = p_org_name,
                dhl_capable = p_is_dhl_capable,
                dhl_direct_capable = p_is_dhl_direct_capable,
                dhl_direct_producer_name = p_dhl_direct_producer_name,
                dhl_direct_service_url = p_dhl_direct_service_url,
                parent_org_code = p_parent_org_code
        where   org_code = p_org_code;
    end if;

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
            o.dhl_direct_producer_name,
            o.dhl_direct_service_url
    from    dhl_organization o
    inner join
        dhl_message_recipient r on r.recipient_org_code = o.org_code
    where   r.dhl_message_id = p_dhl_message_id
    order by
            o.direct_service_url desc;

    return  RC1;
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
