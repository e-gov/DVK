set search_path = dvk, pg_catalog;

ALTER TABLE dhl_message_recipient ADD COLUMN opened timestamp without time zone;

CREATE OR REPLACE FUNCTION "Get_NotOpenedInAdit"() RETURNS refcursor
AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dhl_message_recipient
    where   LOWER(recipient_org_code)='adit' and opened is null;
    RETURN  RC1;
END; $$
    LANGUAGE plpgsql;


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

