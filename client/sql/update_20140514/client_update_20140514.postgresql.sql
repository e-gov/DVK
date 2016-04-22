set search_path = dvk, pg_catalog;

ALTER TABLE dhl_message ALTER COLUMN sending_date TYPE timestamp, ALTER COLUMN received_date TYPE timestamp;
ALTER TABLE dhl_message_recipient ALTER COLUMN sending_date TYPE timestamp, ALTER COLUMN received_date TYPE timestamp;
ALTER TABLE dhl_status_history ALTER COLUMN status_date TYPE timestamp;

create or replace
function "Update_MessageRecipientOpened"(
    p_dhl_id integer,
    p_recipient_person_code character varying,
    p_person_code_with_prefix character varying,
    p_opened timestamp)
returns boolean
as $$
begin
    update  dhl_message_recipient
    set     opened = p_opened
    where   dhl_id = p_dhl_id and
      (recipient_person_code = p_recipient_person_code or recipient_person_code = p_person_code_with_prefix);
    return found;
end; $$
language plpgsql;

