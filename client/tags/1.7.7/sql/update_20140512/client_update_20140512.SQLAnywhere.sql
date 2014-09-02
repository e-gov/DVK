DROP PROCEDURE "Get_NotOpenedInAdit";

CREATE PROCEDURE "Get_NotOpenedInAdit"()
BEGIN
    select  recipient.*
    from    dhl_message_recipient as recipient, dhl_message as msg
    where   LOWER(recipient.recipient_org_code)='adit'
      and recipient.opened is null
      and recipient.dhl_message_id = msg.dhl_message_id
      and msg.is_incoming=0
      and recipient.dhl_id is not null
      and msg.dhl_id is not null;
END;