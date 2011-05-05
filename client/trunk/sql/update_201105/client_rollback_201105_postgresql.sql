----------------------------------------------------------------------
-- May 2011
-- Rollback DVK Client from version 1.6.2 to 1.6.1
----------------------------------------------------------------------

set search_path = dvk, pg_catalog;

drop function if exists "Update_DhlMessageMetaData"
(
    integer,
    integer,
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
    character varying,
    character varying,
    character varying,
    character varying
);

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

drop function if exists "Get_DhlOccupationList" ();
drop function if exists "Get_DhlSubdivisionList" ();
drop function if exists "Delete_DhlOccupation" (integer);
drop function if exists "Delete_DhlSubdivision" (integer);
