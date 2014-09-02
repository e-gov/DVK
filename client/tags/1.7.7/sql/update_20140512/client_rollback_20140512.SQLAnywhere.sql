DROP PROCEDURE "Get_NotOpenedInAdit";

CREATE PROCEDURE "Get_NotOpenedInAdit"()
BEGIN
    SELECT  *
    FROM    dhl_message_recipient
    WHERE   LOWER(recipient_org_code)='adit' AND opened IS NULL;
END;