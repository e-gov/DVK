ALTER TABLE dhl_message_recipient ADD opened TIMESTAMP NULL;

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
create or replace
PROCEDURE Update_MessageRecipientOpened(
  p_dhl_id in number,
  p_recipient_person_code in varchar2,
  p_opened in timestamp with time zone)
AS
  BEGIN
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and recipient_person_code = p_recipient_person_code;
END; 
/


