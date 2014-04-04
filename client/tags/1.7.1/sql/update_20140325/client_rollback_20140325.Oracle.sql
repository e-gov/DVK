ALTER TABLE dhl_message_recipient DROP COLUMN opened;

DROP PROCEDURE Get_NotOpenedInAdit;
DROP PROCEDURE Update_MessageRecipientOpened;