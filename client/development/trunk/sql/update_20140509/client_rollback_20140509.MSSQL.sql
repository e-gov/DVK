CREATE PROCEDURE [dbo].[Get_NotOpenedInAdit]
@cursor CURSOR VARYING OUTPUT
AS
    SET @cursor = CURSOR FOR
    SELECT  *
    FROM    dhl_message_recipient
    WHERE   LOWER(recipient_org_code)='adit' AND opened IS NULL;
    OPEN @cursor;
GO
