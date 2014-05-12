set search_path = dvk, pg_catalog;

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

