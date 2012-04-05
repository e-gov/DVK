----------------------------------------------------------------------
-- February 2011
-- Update DVK Client from version 1.6.0 to 1.6.1
----------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_OldDhlMessages]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_OldDhlMessages]
GO
create procedure [dbo].[Delete_OldDhlMessages]
	@deleted_doc_count int out,
	@doc_lifetime_days int
as
	set @deleted_doc_count = 0;
	
	if (@doc_lifetime_days is not null) and (@doc_lifetime_days > 0)
	begin
		-- Delete old received documents
		delete
		from	[dhl_message]
		where	[is_incoming] = 1
				and datediff(day, [received_date], getdate()) >= @doc_lifetime_days;
		set @deleted_doc_count = @deleted_doc_count + isnull(@@rowcount, 0);
				
		-- Delete old sent documents
		delete
		from	[dhl_message]
		where	[is_incoming] = 0
				and datediff(day, [sending_date], getdate()) >= @doc_lifetime_days;
		set @deleted_doc_count = @deleted_doc_count + isnull(@@rowcount, 0);
	end
GO
