ALTER TABLE dhl_message_recipient ADD opened DATETIME NULL;
GO

CREATE PROCEDURE [dbo].[Get_NotOpenedInAdit] 
@cursor CURSOR VARYING OUTPUT
AS
    SET @cursor = CURSOR FOR
    SELECT  *
    FROM    dhl_message_recipient
    WHERE   LOWER(recipient_org_code)='adit' AND opened IS NULL;
    OPEN @cursor;
GO

CREATE PROCEDURE [dbo].[Update_MessageRecipientOpened] 
    @p_dhl_id int,
    @p_recipient_person_code nvarchar(100),
    @p_opened datetime
AS
    update  dhl_message_recipient
    set     opened = @p_opened
    where   dhl_id = @p_dhl_id and recipient_person_code = @p_recipient_person_code;  
GO