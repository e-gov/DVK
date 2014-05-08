ALTER TABLE dhl_message_recipient ADD opened DATETIME NULL;

CREATE PROCEDURE "Get_NotOpenedInAdit"()
BEGIN
    SELECT  *
    FROM    dhl_message_recipient
    WHERE   LOWER(recipient_org_code)='adit' AND opened IS NULL;
END;

CREATE PROCEDURE "Update_MessageRecipientOpened"
(
	in _p_dhl_id int,
	in _p_recipient_person_code varchar(100),
	in _p_opened datetime 
)
BEGIN
    update  dhl_message_recipient
    set     "opened" = p_opened
    where   "dhl_id" = _p_dhl_id and "recipient_person_code" = _p_recipient_person_code;  
END;