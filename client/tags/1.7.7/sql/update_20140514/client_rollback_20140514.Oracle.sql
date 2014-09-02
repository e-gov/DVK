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
