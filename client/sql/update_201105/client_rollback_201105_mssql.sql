----------------------------------------------------------------------
-- May 2011
-- Rollback DVK Client from version 1.6.2 to 1.6.1
----------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageMetaData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageMetaData]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessageID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessageID]
GO
create procedure [dbo].[Get_DhlMessageID]
	@dhl_message_id int output,
	@dhl_id int,
	@producer_name nvarchar(50),
	@service_url nvarchar(100),
	@is_incoming int
as
if @is_incoming = 0
begin
	select	@dhl_message_id = max(dhl_message_id)
	from	dhl_message_recipient
	where	dhl_id = @dhl_id
		and isnull(producer_name,'') = isnull(@producer_name,'')
		and isnull(service_url,'') = isnull(@service_url,'')
end
else
begin
	if exists (select * from dhl_message m where m.dhl_id=@dhl_id and m.is_incoming=@is_incoming)
		select	@dhl_message_id = m.dhl_message_id
		from	dhl_message m
		where	m.dhl_id = @dhl_id
			and m.is_incoming = 1
	else
		set @dhl_message_id = 0
end
set @dhl_message_id = isnull(@dhl_message_id, 0)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlOccupationList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlOccupationList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlSubdivisionList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlSubdivisionList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_DhlOccupation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_DhlOccupation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_DhlSubdivision]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_DhlSubdivision]
GO
