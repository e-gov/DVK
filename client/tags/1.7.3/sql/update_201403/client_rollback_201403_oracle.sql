----------------------------------------------------------------------
-- March 2014
-- Rollback DVK Client from version 1.6.3 to 1.6.2
----------------------------------------------------------------------

DROP SEQUENCE sq_dhl_error_log_id;
/
DROP SEQUENCE sq_dhl_request_log_id;
/
DROP TRIGGER tr_dhl_error_log_id;
/
DROP TRIGGER tr_dhl_request_log_id;
/
ALTER TABLE dhl_request_log
DROP CONSTRAINT FK_dhl_error_log_id;
/
ALTER TABLE dhl_request_log
DROP CONSTRAINT PK_dhl_request_log;
/
ALTER TABLE dhl_error_log
DROP CONSTRAINT FK_dhl_message_id;
/
ALTER TABLE dhl_error_log
DROP CONSTRAINT PK_dhl_error_log;
/
DROP TABLE dhl_request_log CASCADE CONSTRAINTS;
/
DROP TABLE dhl_error_log CASCADE CONSTRAINTS;
/
DROP PROCEDURE Add_DhlErrorLog;
/
DROP PROCEDURE Add_DhlRequestLog;
