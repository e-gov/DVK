----------------------------------------------------------------------
-- February 2011
-- Update DVK Client from version 1.6.0 to 1.6.1
----------------------------------------------------------------------

create or replace
procedure Delete_OldDhlMessages(
	deleted_doc_count out number,
	doc_lifetime_days in number)
as
begin
    Delete_OldDhlMessages.deleted_doc_count := 0;
	
	if (Delete_OldDhlMessages.doc_lifetime_days is not null) and (Delete_OldDhlMessages.doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	is_incoming = 1
				and (sysdate - received_date) >= Delete_OldDhlMessages.doc_lifetime_days;
		Delete_OldDhlMessages.deleted_doc_count := Delete_OldDhlMessages.deleted_doc_count + sql%rowcount;
				
		-- Delete old sent documents
		delete
		from	dhl_message
		where	is_incoming = 0
				and (sysdate - sending_date) >= Delete_OldDhlMessages.doc_lifetime_days;
		Delete_OldDhlMessages.deleted_doc_count := Delete_OldDhlMessages.deleted_doc_count + sql%rowcount;
	end if;
end;
/
