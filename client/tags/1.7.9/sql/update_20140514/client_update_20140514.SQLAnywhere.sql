DROP PROCEDURE "Update_MessageRecipientOpened";

CREATE PROCEDURE "Update_MessageRecipientOpened"
(
	in _p_dhl_id int,
	in _p_recipient_person_code varchar(100),
	in _p_person_code_with_prefix varchar(100),
	in _p_opened datetime 
)
BEGIN
    update  dhl_message_recipient
    set     "opened" = p_opened
    where   "dhl_id" = _p_dhl_id and
    ("recipient_person_code" = _p_recipient_person_code or "recipient_person_code" = p_person_code_with_prefix);
END;