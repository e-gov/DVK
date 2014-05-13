create or replace
PROCEDURE Get_NotOpenedInAdit(RC1 in out globalPkg.RCT1)
AS
  BEGIN
    OPEN RC1 FOR
    SELECT  *
    FROM    dhl_message_recipient
    WHERE   LOWER(recipient_org_code)='adit' AND opened IS NULL;
  END; 
/  