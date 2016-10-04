alter table [dbo].[dhl_error_log] drop FK_dhl_message_id;
alter table [dbo].[dhl_request_log] drop FK_dhl_error_log_id;
ALTER TABLE [dbo].[dhl_error_log]
ADD CONSTRAINT FK_dhl_message_id
FOREIGN KEY (dhl_message_id) REFERENCES dhl_message (dhl_message_id)
GO

ALTER TABLE [dbo].[dhl_request_log]
ADD CONSTRAINT FK_dhl_error_log_id
FOREIGN KEY (dhl_error_log_id) REFERENCES dhl_error_log (dhl_error_log_id)
GO