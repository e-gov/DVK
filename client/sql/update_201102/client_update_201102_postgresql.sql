----------------------------------------------------------------------
-- February 2011
-- Update DVK Client from version 1.6.0 to 1.6.1
----------------------------------------------------------------------

set search_path = dvk, pg_catalog;

create or replace
function "Delete_OldDhlMessages"(p_doc_lifetime_days integer)
returns integer
as $$
declare
    result integer := 0;
    tmp_rc integer := 0;
begin
    if (p_doc_lifetime_days is not null) and (p_doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	is_incoming = 1
				and (current_date - received_date) >= p_doc_lifetime_days;
		GET DIAGNOSTICS tmp_rc = ROW_COUNT;
		result := result + tmp_rc;
				
		-- Delete old sent documents
		delete
		from	dhl_message
		where	is_incoming = 0
				and (current_date - sending_date) >= p_doc_lifetime_days;
		GET DIAGNOSTICS tmp_rc = ROW_COUNT;
		result := result + tmp_rc;
	end if;
    
    return  result;
end; $$
language plpgsql;
