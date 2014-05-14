set search_path = dvk, pg_catalog;

create or replace
function "Update_MessageRecipientOpened"(
    p_dhl_id integer,
    p_recipient_person_code character varying,
    p_opened timestamp with time zone)
returns boolean
as $$
begin
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and recipient_person_code = p_recipient_person_code;  
    return found;
end; $$
language plpgsql;

