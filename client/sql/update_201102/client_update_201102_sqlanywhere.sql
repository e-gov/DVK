----------------------------------------------------------------------
-- February 2011
-- Update DVK Client from version 1.6.0 to 1.6.1
----------------------------------------------------------------------

create procedure "Delete_OldDhlMessages"
(
	in _doc_lifetime_days int,
	out _deleted_doc_count int
)
begin
    set _deleted_doc_count = 0;
	if (_doc_lifetime_days is not null) and (_doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	"is_incoming" = 1
				and datediff(day, "received_date", getdate()) >= _doc_lifetime_days;
		set _deleted_doc_count = _deleted_doc_count + @@rowcount;
				
		-- Delete old sent documents
		delete
		from	dhl_message
		where	"is_incoming" = 0
				and datediff(day, "sending_date", getdate()) >= _doc_lifetime_days;
		set _deleted_doc_count = _deleted_doc_count + @@rowcount;
	end if;
end;
