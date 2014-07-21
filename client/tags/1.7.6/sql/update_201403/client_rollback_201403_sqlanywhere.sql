----------------------------------------------------------------------
-- March 2014
-- Rollback DVK Client from version 1.6.3 to 1.6.2
----------------------------------------------------------------------

DROP TABLE IF EXISTS dhl_error_log;
DROP TABLE IF EXISTS dhl_request_log;

DROP PROCEDURE IF EXISTS "Add_DhlErrorLog";
DROP PROCEDURE IF EXISTS "Add_DhlRequestLog";
