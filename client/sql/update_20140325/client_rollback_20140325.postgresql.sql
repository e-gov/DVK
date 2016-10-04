set search_path = dvk, pg_catalog;

ALTER TABLE dhl_message_recipient DROP COLUMN opened;

DROP FUNCTION "Get_NotOpenedInAdit"();

DROP FUNCTION "Update_MessageRecipientOpened"(integer, character varying, timestamp with time zone);



