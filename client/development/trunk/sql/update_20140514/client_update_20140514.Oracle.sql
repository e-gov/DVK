create or replace
PROCEDURE Update_MessageRecipientOpened(
  p_dhl_id in number,
  p_recipient_person_code in varchar2,
  p_person_code_with_prefix in varchar2,
  p_opened in timestamp)
AS
  BEGIN
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and
      (recipient_person_code = p_recipient_person_code or p_person_code_with_prefix = p_person_code_with_prefix);
END; 
/
