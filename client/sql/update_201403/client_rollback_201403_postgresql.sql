----------------------------------------------------------------------
-- March 2014
-- Rollback DVK Client from version 1.6.3 to 1.6.2
----------------------------------------------------------------------

DROP TABLE IF EXISTS dvk.dhl_request_log CASCADE;
DROP TABLE IF EXISTS dvk.dhl_error_log CASCADE;

DROP SEQUENCE IF EXISTS dvk.sq_dhl_error_log_id_seq;
DROP SEQUENCE IF EXISTS dvk.sq_dhl_request_log_id_seq;

DROP FUNCTION IF EXISTS dvk."Add_DhlErrorLog"(integer, timestamp, character varying, character varying, character varying, character varying, integer);
DROP FUNCTION IF EXISTS dvk."Add_DhlRequestLog"(integer, timestamp, character varying, character varying, character varying, character varying, integer);
