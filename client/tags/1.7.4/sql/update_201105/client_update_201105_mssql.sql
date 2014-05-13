----------------------------------------------------------------------
-- May 2011
-- Update DVK Client from version 1.6.1 to 1.6.2
----------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageMetaData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageMetaData]
GO
create procedure [dbo].[Update_DhlMessageMetaData]
	@id int,
	@is_incoming int,
	@dhl_id int,
	@title nvarchar(1000),
	@sender_org_code nvarchar(20),
	@sender_org_name nvarchar(100),
	@sender_person_code nvarchar(20),
	@sender_name nvarchar(100),
	@recipient_org_code nvarchar(20),
	@recipient_org_name nvarchar(100),
	@recipient_person_code nvarchar(20),
	@recipient_name nvarchar(100),
	@case_name nvarchar(250),
	@dhl_folder_name nvarchar(1000),
	@sending_status_id int,
	@unit_id int,
	@sending_date datetime,
	@received_date datetime,
	@local_item_id int,
	@recipient_status_id int,
	@fault_code nvarchar(50),
	@fault_actor nvarchar(250),
	@fault_string nvarchar(500),
	@fault_detail nvarchar(2000),
	@status_update_needed int,
	@metaxml ntext,
	@query_id nvarchar(50) = null,
	@proxy_org_code nvarchar(20) = null,
	@proxy_org_name nvarchar(100) = null,
	@proxy_person_code nvarchar(20) = null,
	@proxy_name nvarchar(100) = null,
	@recipient_department_nr nvarchar(100) = null,
	@recipient_department_name nvarchar(500) = null,
	@recipient_email nvarchar(100) = null,
	@recipient_division_id int = null,
	@recipient_division_name nvarchar(100) = null,
	@recipient_position_id int = null,
	@recipient_position_name nvarchar(100) = null,
	@recipient_division_code nvarchar(25) = null,
	@recipient_position_code nvarchar(25) = null,
	@dhl_guid varchar(36) = null
AS

UPDATE	dhl_message
SET	is_incoming = @is_incoming,
	dhl_id = @dhl_id,
	title = @title,
	sender_org_code = @sender_org_code,
	sender_org_name = @sender_org_name,
	sender_person_code = @sender_person_code,
	sender_name = @sender_name,
	recipient_org_code = @recipient_org_code,
	recipient_org_name = @recipient_org_name,
	recipient_person_code = @recipient_person_code,
	recipient_name = @recipient_name,
	case_name = @case_name,
	dhl_folder_name = @dhl_folder_name,
	sending_status_id = @sending_status_id,
	unit_id = @unit_id,
	sending_date = @sending_date,
	received_date = @received_date,
	local_item_id = @local_item_id,
	recipient_status_id = @recipient_status_id,
	fault_code = @fault_code,
	fault_actor = @fault_actor,
	fault_string = @fault_string,
	fault_detail = @fault_detail,
	status_update_needed = @status_update_needed,
	metaxml = @metaxml,
	query_id = isnull(query_id,@query_id),
	proxy_org_code = @proxy_org_code,
	proxy_org_name = @proxy_org_name,
	proxy_person_code = @proxy_person_code,
	proxy_name = @proxy_name,
	recipient_department_nr = @recipient_department_nr,
	recipient_department_name = @recipient_department_name,
	recipient_email = @recipient_email,
	recipient_division_id = @recipient_division_id,
	recipient_division_name = @recipient_division_name,
	recipient_position_id = @recipient_position_id,
	recipient_position_name = @recipient_position_name,
	recipient_division_code = @recipient_division_code,
	recipient_position_code = @recipient_position_code,
	dhl_guid = @dhl_guid
WHERE	dhl_message_id = @id
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
    select  @dhl_message_id = max(r.dhl_message_id)
    from    dhl_message_recipient r
    inner join
            dhl_message m on m.dhl_message_id = r.dhl_message_id
    where   m.is_incoming = 0
            and r.dhl_id = @dhl_id
            and isnull(r.producer_name,'') = isnull(@producer_name,'')
            and isnull(r.service_url,'') = isnull(@service_url,'')
end
else
begin
    if exists (select * from dhl_message m where m.dhl_id=@dhl_id and m.is_incoming=@is_incoming)
        select  @dhl_message_id = m.dhl_message_id
        from    dhl_message m
        where   m.dhl_id = @dhl_id
                and m.is_incoming = 1
    else
        set @dhl_message_id = 0
end
set @dhl_message_id = isnull(@dhl_message_id, 0)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlOccupationList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlOccupationList]
GO
create procedure [dbo].[Get_DhlOccupationList]
as
select  *
from    [dhl_occupation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlSubdivisionList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlSubdivisionList]
GO
create procedure [dbo].[Get_DhlSubdivisionList]
as
select  *
from    [dhl_subdivision]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_DhlOccupation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_DhlOccupation]
GO
create procedure [dbo].[Delete_DhlOccupation]
	@id int
as
delete
from    [dhl_occupation]
where   [occupation_code] = @id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_DhlSubdivision]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_DhlSubdivision]
GO
create procedure [dbo].[Delete_DhlSubdivision]
	@id int
as
delete
from    [dhl_subdivision]
where   [subdivision_code] = @id
GO
