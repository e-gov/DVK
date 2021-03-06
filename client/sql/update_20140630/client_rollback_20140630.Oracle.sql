ALTER TABLE DHL_ERROR_LOG
DROP CONSTRAINT FK_DHL_MESSAGE_ID;

ALTER TABLE DHL_REQUEST_LOG
DROP CONSTRAINT FK_DHL_ERROR_LOG_ID;

ALTER TABLE dhl_error_log
ADD CONSTRAINT FK_dhl_message_id
FOREIGN KEY (dhl_message_id)
REFERENCES dhl_message(dhl_message_id);

ALTER TABLE dhl_request_log
ADD CONSTRAINT FK_dhl_error_log_id
FOREIGN KEY (dhl_error_log_id)
REFERENCES dhl_error_log(dhl_error_log_id);