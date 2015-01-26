DROP PROCEDURE [dbo].[Update_MessageRecipientOpened]
GO

CREATE PROCEDURE [dbo].[Update_MessageRecipientOpened]
    @p_dhl_id int,
    @p_recipient_person_code nvarchar(100),
    @p_person_code_w_prefix nvarchar(100),
    @p_opened datetime
AS
    update  dhl_message_recipient
    set     opened = @p_opened
    where   dhl_id = @p_dhl_id and
      (recipient_person_code = @p_recipient_person_code or recipient_person_code = @p_person_code_w_prefix);
GO