set search_path = dvk, pg_catalog;
ALTER TABLE dhl_error_log DROP CONSTRAINT FK_dhl_message_id;
ALTER TABLE dhl_request_log DROP CONSTRAINT FK_dhl_error_log_id;
ALTER TABLE dhl_error_log
    ADD CONSTRAINT FK_dhl_message_id FOREIGN KEY (dhl_message_id) REFERENCES dhl_message(dhl_message_id) ON DELETE CASCADE;
ALTER TABLE dhl_request_log
    ADD CONSTRAINT FK_dhl_error_log_id FOREIGN KEY (dhl_error_log_id) REFERENCES dhl_error_log(dhl_error_log_id) ON DELETE CASCADE;