----------------------------------------------------------------------
-- February 2011
-- Rollback DVK Client from version 1.6.1 to 1.6.0
----------------------------------------------------------------------

set search_path = dvk, pg_catalog;

drop function if exists "Delete_OldDhlMessages"(integer);
