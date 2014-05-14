CREATE PROCEDURE [dbo].[Update_MessageRecipientOpened]
    @p_dhl_id int,
    @p_recipient_person_code nvarchar(100),
    @p_opened datetime
AS
    update  dhl_message_recipient
    set     opened = @p_opened
    where   dhl_id = @p_dhl_id and recipient_person_code = @p_recipient_person_code;  
GO