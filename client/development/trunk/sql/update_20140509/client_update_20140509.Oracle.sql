
create or replace
PROCEDURE Get_NotOpenedInAdit(RC1 in out globalPkg.RCT1)
AS
  BEGIN
    OPEN RC1 FOR
    select  recipient.*
    from    dhl_message_recipient as recipient, dhl_message as message
    where   LOWER(recipient.recipient_org_code)='adit'
      and recipient.opened is null
      and recipient.dhl_message_id = message.dhl_message_id
      and message.is_incoming=0;
  END; 
/


