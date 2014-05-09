set search_path = dvk, pg_catalog;

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
      and message.is_incoming=0;
    RETURN  RC1;
END; $$
    LANGUAGE plpgsql;