ALTER TABLE dhl_error_log drop constraint FK_dhl_message_id;
ALTER TABLE dhl_request_log drop constraint FK_dhl_error_log_id;

alter table dhl_error_log
add constraint FK_dhl_message_id
foreign key ("dhl_message_id")
references dhl_message ("dhl_message_id") on delete cascade;

alter table dhl_request_log
add constraint FK_dhl_error_log_id
foreign key ("dhl_error_log_id")
references dhl_error_log ("dhl_error_log_id") on delete cascade;