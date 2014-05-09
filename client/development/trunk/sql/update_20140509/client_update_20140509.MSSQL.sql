
CREATE PROCEDURE [dbo].[Get_NotOpenedInAdit] 
@cursor CURSOR VARYING OUTPUT
AS
    SET @cursor = CURSOR FOR
    select  recipient.*
    from    dhl_message_recipient as recipient, dhl_message as message
    where   LOWER(recipient.recipient_org_code)='adit'
      and recipient.opened is null
      and recipient.dhl_message_id = message.dhl_message_id
      and message.is_incoming=0
      and recipient.dhl_id is not null
      and message.dhl_id is not null;
    OPEN @cursor;
GO
