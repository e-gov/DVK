ALTER
TABLE	dhl_message
ADD	query_id nvarchar(50) NULL,
	proxy_org_code nvarchar(20) null,
	proxy_org_name nvarchar(100) null,
	proxy_person_code nvarchar(20) null,
	proxy_name nvarchar(100) null,
	recipient_department_nr nvarchar(100) null,
	recipient_department_name nvarchar(500) null,
	recipient_email nvarchar(100) null,
	recipient_division_id int null,
	recipient_division_name nvarchar(100) null,
	recipient_position_id int null,
	recipient_position_name nvarchar(100) null
GO

CREATE
TABLE	dhl_counter
(
	dhl_id int null
)
GO

insert into dhl_counter(dhl_id) values(0)
GO

ALTER
TABLE	dhl_message_recipient
ADD	dhl_id int null,
	query_id nvarchar(50) null,
	producer_name nvarchar(50) null,
	service_url nvarchar(100) null,
	recipient_division_id int not null default 0,
	recipient_division_name nvarchar(100) null,
	recipient_position_id int not null default 0,
	recipient_position_name nvarchar(100) null
GO

ALTER
TABLE	dhl_message_recipient
DROP	CONSTRAINT PK_dhl_message_recipient
GO

alter table dhl_message_recipient
add constraint PK_dhl_message_recipient
primary key (dhl_message_id, recipient_org_code, recipient_person_code, recipient_division_id, recipient_position_id)
GO

ALTER TABLE dhl_organization ADD dhl_direct_service_url nvarchar(100) null
GO

create
table	dhl_occupation
(
	occupation_code int not null primary key,
	occupation_name nvarchar(100) not null,
	org_code nvarchar(20) not null
)
GO

create
table	dhl_subdivision
(
	subdivision_code int not null primary key,
	subdivision_name nvarchar(100) not null,
	org_code nvarchar(20) not null
)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageStatus]
GO
CREATE PROCEDURE Update_DhlMessageStatus
	@dhl_message_id int,
	@status_id int,
	@status_update_needed int,
	@received_date datetime
AS
update	dhl_message
set	sending_status_id = @status_id,
	status_update_needed = @status_update_needed,
	received_date = @received_date
where	dhl_message_id = @dhl_message_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageDhlID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageDhlID]
GO
CREATE PROCEDURE [Update_DhlMessageDhlID]
	@id int,
	@dhl_id int,
	@query_id nvarchar(50) = null
AS

update	dhl_message
set	dhl_id = @dhl_id, query_id = isnull(query_id,@query_id)
where	dhl_message_id = @id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessage]
GO
CREATE PROCEDURE [Update_DhlMessage]
	@id int,
	@is_incoming int,
	@data ntext,
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
	@recipient_position_name nvarchar(100) = null
AS

UPDATE	dhl_message
SET	is_incoming = @is_incoming,
	data = @data,
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
	recipient_position_name = @recipient_position_name
WHERE	dhl_message_id = @id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Add_DhlMessage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Add_DhlMessage]
GO
CREATE PROCEDURE [Add_DhlMessage]
	@id int out,
	@is_incoming int,
	@data ntext,
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
	@recipient_position_name nvarchar(100) = null
AS

IF @is_incoming IS NULL
	SET @is_incoming = 0

INSERT
INTO	dhl_message(
	is_incoming,
	data,
	dhl_id,
	title,
	sender_org_code,
	sender_org_name,
	sender_person_code,
	sender_name,
	recipient_org_code,
	recipient_org_name,
	recipient_person_code,
	recipient_name,
	case_name,
	dhl_folder_name,
	sending_status_id,
	unit_id,
	sending_date,
	received_date,
	local_item_id,
	recipient_status_id,
	fault_code,
	fault_actor,
	fault_string,
	fault_detail,
	status_update_needed,
	metaxml,
	query_id,
	proxy_org_code,
	proxy_org_name,
	proxy_person_code,
	proxy_name,
	recipient_department_nr,
	recipient_department_name,
	recipient_email,
	recipient_division_id,
	recipient_division_name,
	recipient_position_id,
	recipient_position_name)
VALUES	(@is_incoming,
	@data,
	@dhl_id,
	@title,
	@sender_org_code,
	@sender_org_name,
	@sender_person_code,
	@sender_name,
	@recipient_org_code,
	@recipient_org_name,
	@recipient_person_code,
	@recipient_name,
	@case_name,
	@dhl_folder_name,
	@sending_status_id,
	@unit_id,
	@sending_date,
	@received_date,
	@local_item_id,
	@recipient_status_id,
	@fault_code,
	@fault_actor,
	@fault_string,
	@fault_detail,
	@status_update_needed,
	@metaxml,
	@query_id,
	@proxy_org_code,
	@proxy_org_name,
	@proxy_person_code,
	@proxy_name,
	@recipient_department_nr,
	@recipient_department_name,
	@recipient_email,
	@recipient_division_id,
	@recipient_division_name,
	@recipient_position_id,
	@recipient_position_name)

SELECT	@id = scope_identity()
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Save_DhlOrganization]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Save_DhlOrganization]
GO
CREATE PROCEDURE [Save_DhlOrganization]
	@org_code nvarchar(20),
	@org_name nvarchar(100),
	@is_dhl_capable int,
	@is_dhl_direct_capable int,
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100) = null
AS

if not exists (select * from dhl_organization where org_code = @org_code)
	insert
	into	dhl_organization(
		org_code,
		org_name,
		dhl_capable,
		dhl_direct_capable,
		dhl_direct_producer_name,
		dhl_direct_service_url)
	values	(@org_code,
		@org_name,
		@is_dhl_capable,
		@is_dhl_direct_capable,
		@dhl_direct_producer_name,
		@dhl_direct_service_url)
else
	update	dhl_organization
	set	org_name = @org_name,
		dhl_capable = @is_dhl_capable,
		dhl_direct_capable = @is_dhl_direct_capable,
		dhl_direct_producer_name = @dhl_direct_producer_name,
		dhl_direct_service_url = @dhl_direct_service_url
	where	org_code = @org_code
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageRecipDhlID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageRecipDhlID]
GO
CREATE PROCEDURE [Update_DhlMessageRecipDhlID]
	@dhl_message_id int,
	@dhl_direct_capable bit,
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100),
	@dhl_id int,
	@query_id nvarchar(50)
AS
-- salvestab vastuvıtja andmetesse vastuvıtja DVK serveri poolt antud sınumi ID v‰‰rtuse
update	dhl_message_recipient
set	dhl_id = @dhl_id,
	query_id = @query_id,
	producer_name = @dhl_direct_producer_name,
	service_url = @dhl_direct_service_url
where	dhl_message_id = @dhl_message_id 
	and recipient_org_code in
	(
		select	org_code
		from	dhl_organization
		where	isnull(dhl_direct_capable,1) = isnull(@dhl_direct_capable,1)
				and isnull(dhl_direct_producer_name,'') = isnull(@dhl_direct_producer_name,'')
				and isnull(dhl_direct_service_url,'')= isnull(@dhl_direct_service_url,'')
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessagesByDhlID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessagesByDhlID]
GO
CREATE PROCEDURE Get_DhlMessagesByDhlID
	@dhl_id int,
	@incoming int,
	@metadata_only int
AS

SELECT	[dhl_message_id],
	[is_incoming],
	(CASE WHEN @metadata_only=0 THEN [data] ELSE NULL END) AS [data],
	[title],
	[sender_org_code],
	[sender_org_name],
	[sender_person_code],
	[sender_name],
	[recipient_org_code],
	[recipient_org_name],
	[recipient_person_code],
	[recipient_name],
	[case_name],
	[dhl_folder_name],
	[sending_status_id],
	[unit_id],
	[dhl_id],
	[sending_date],
	[received_date],
	[local_item_id],
	[recipient_status_id],
	[fault_code],
	[fault_actor],
	[fault_string],
	[fault_detail],
	[status_update_needed],
	[metaxml],
	[query_id],
	[proxy_org_code],
	[proxy_org_name],
	[proxy_person_code],
	[proxy_name],
	[recipient_department_nr],
	[recipient_department_name],
	[recipient_email],
	[recipient_division_id],
	[recipient_division_name],
	[recipient_position_id],
	[recipient_position_name]
FROM	dhl_message
WHERE	is_incoming = @incoming
	AND dhl_id = @dhl_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_AsutusStat]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_AsutusStat]
GO
CREATE PROCEDURE Get_AsutusStat
    @vahetatud_dokumente int out,
	@asutus_id int
AS
SELECT	@vahetatud_dokumente = COUNT(*)
FROM	dhl_message
WHERE	unit_id = @asutus_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlCapabilityByMessageID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlCapabilityByMessageID]
GO
CREATE PROCEDURE Get_DhlCapabilityByMessageID
	@dhl_message_id int
AS
SELECT	DISTINCT
	o.dhl_capable,
	o.dhl_direct_capable,
	o.dhl_direct_producer_name,
	o.dhl_direct_service_url
FROM	dhl_organization o
INNER JOIN
	dhl_message_recipient r ON r.recipient_org_code = o.org_code
WHERE	r.dhl_message_id = @dhl_message_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlOrgsByCapability]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlOrgsByCapability]
GO
CREATE PROCEDURE Get_DhlOrgsByCapability
	@dhl_capable int,
	@dhl_direct_capable int,
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100)
AS
SELECT	org_code
FROM	dhl_organization
WHERE	isnull(dhl_capable,0) = isnull(@dhl_capable,0)
	AND isnull(dhl_direct_capable,0) = isnull(@dhl_direct_capable,0)
	AND isnull(dhl_direct_producer_name,'') = isnull(@dhl_direct_producer_name,'')
	AND isnull(dhl_direct_service_url,'') = isnull(@dhl_direct_service_url,'')
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_NextDhlID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_NextDhlID]
GO
create procedure Get_NextDhlID
	@dhl_id int out
as
begin transaction
update	dhl_counter
set	dhl_id = isnull(dhl_id,0) + 1

select	@dhl_id = dhl_id
from	dhl_counter
commit
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageStatus]
GO
create procedure Update_DhlMessageStatus
	@dhl_message_id int,
	@status_id int,
	@status_update_needed int,
	@received_date datetime
AS
update	dhl_message
set	sending_status_id = @status_id,
	status_update_needed = @status_update_needed,
	received_date = @received_date
where	dhl_message_id = @dhl_message_id
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessages]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessages]
GO
CREATE PROCEDURE Get_DhlMessages
	@incoming int,
	@status_id int,
	@unit_id int,
	@status_update_needed int,
	@metadata_only int
AS
SELECT	[dhl_message_id],
	[is_incoming],
	(CASE WHEN @metadata_only=0 THEN [data] ELSE NULL END) AS [data],
	[title],
	[sender_org_code],
	[sender_org_name],
	[sender_person_code],
	[sender_name],
	[recipient_org_code],
	[recipient_org_name],
	[recipient_person_code],
	[recipient_name],
	[case_name],
	[dhl_folder_name],
	[sending_status_id],
	[unit_id],
	[dhl_id],
	[sending_date],
	[received_date],
	[local_item_id],
	[recipient_status_id],
	[fault_code],
	[fault_actor],
	[fault_string],
	[fault_detail],
	[status_update_needed],
	[metaxml],
	[query_id],
	[proxy_org_code],
	[proxy_org_name],
	[proxy_person_code],
	[proxy_name],
	[recipient_department_nr],
	[recipient_department_name],
	[recipient_email],
	[recipient_division_id],
	[recipient_division_name],
	[recipient_position_id],
	[recipient_position_name]
FROM	dhl_message
WHERE	is_incoming = @incoming
	AND
	(
		sending_status_id = @status_id
		OR @status_id IS NULL
	)
	AND unit_id = @unit_id
	AND
	(
		@status_update_needed <> 1
		OR status_update_needed = 1
	)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Save_DhlMessageRecipient]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Save_DhlMessageRecipient]
GO
create procedure Save_DhlMessageRecipient
	@dhl_message_id int,
	@recipient_org_code nvarchar(20),
	@recipient_org_name nvarchar(100),
	@recipient_person_code nvarchar(20),
	@recipient_name nvarchar(100),
	@sending_date datetime,
	@received_date datetime,
	@sending_status_id int,
	@recipient_status_id int,
	@fault_code nvarchar(50),
	@fault_actor nvarchar(250),
	@fault_string nvarchar(500),
	@fault_detail nvarchar(2000),
	@metaxml ntext,
	@dhl_id int,
	@producer_name nvarchar(50),
	@service_url nvarchar(100),
	@recipient_division_id int,
	@recipient_division_name nvarchar(100),
	@recipient_position_id int,
	@recipient_position_name nvarchar(100)
as

if @recipient_org_code is null
	set @recipient_org_code = ''
if @recipient_person_code is null
	set @recipient_person_code = ''
if @recipient_division_id is null
	set @recipient_division_id = 0
if @recipient_position_id is null
	set @recipient_position_id = 0

if exists (select * from dhl_message_recipient where dhl_message_id = @dhl_message_id and recipient_org_code = @recipient_org_code and recipient_person_code = @recipient_person_code and recipient_division_id=@recipient_division_id and recipient_position_id=@recipient_position_id)
	update	dhl_message_recipient
	set	recipient_org_name = @recipient_org_name,
		recipient_name = @recipient_name,
		sending_date = @sending_date,
		received_date = @received_date,
		sending_status_id = @sending_status_id,
		recipient_status_id = @recipient_status_id,
		fault_code = @fault_code,
		fault_actor = @fault_actor,
		fault_string = @fault_string,
		fault_detail = @fault_detail,
		metaxml = @metaxml,
		dhl_id = @dhl_id,
		producer_name = @producer_name,
		service_url = @service_url,
		recipient_division_name = @recipient_division_name,
		recipient_position_name = @recipient_position_name
	where	dhl_message_id = @dhl_message_id
		and recipient_org_code = @recipient_org_code
		and recipient_person_code = @recipient_person_code
		and recipient_division_id = @recipient_division_id
		and recipient_position_id = @recipient_position_id
else
	insert
	into	dhl_message_recipient(
		dhl_message_id,
		recipient_org_code,
		recipient_org_name,
		recipient_person_code,
		recipient_name,
		sending_date,
		received_date,
		sending_status_id,
		recipient_status_id,
		fault_code,
		fault_actor,
		fault_string,
		fault_detail,
		metaxml,
		dhl_id,
		producer_name,
		service_url,
		recipient_division_id,
		recipient_division_name,
		recipient_position_id,
		recipient_position_name)
	values	(@dhl_message_id,
		@recipient_org_code,
		@recipient_org_name,
		@recipient_person_code,
		@recipient_name,
		@sending_date,
		@received_date,
		@sending_status_id,
		@recipient_status_id,
		@fault_code,
		@fault_actor,
		@fault_string,
		@fault_detail,
		@metaxml,
		@dhl_id,
		@producer_name,
		@service_url,
		@recipient_division_id,
		@recipient_division_name,
		@recipient_position_id,
		@recipient_position_name)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessageID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessageID]
GO
create procedure Get_DhlMessageID
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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlCapability]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlCapability]
GO
create procedure Get_DhlCapability
	@org_code nvarchar(20)
as
select	*
from	dhl_organization
where	org_code = @org_code
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Save_DhlSubdivision]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Save_SaveDhlSubdivision]
GO
CREATE PROCEDURE [Save_DhlSubdivision]
	@id int,
	@name nvarchar(100),
	@org_code nvarchar(20)
AS
if not exists (select * from dhl_subdivision where subdivision_code = @id)
	insert
	into	dhl_subdivision(
		subdivision_code,
		subdivision_name,
		org_code)
	values	(@id,
		@name,
		@org_code)
else
	update	dhl_subdivision
	set	subdivision_name = @name,
		org_code = @org_code
	where	subdivision_code = @id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Save_DhlOccupation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Save_SaveDhlOccupation]
GO
CREATE PROCEDURE [Save_DhlOccupation]
	@id int,
	@name nvarchar(100),
	@org_code nvarchar(20)
AS
if not exists (select * from dhl_occupation where occupation_code = @id)
	insert
	into	dhl_occupation(
		occupation_code,
		occupation_name,
		org_code)
	values	(@id,
		@name,
		@org_code)
else
	update	dhl_occupation
	set	occupation_name = @name,
		org_code = @org_code
	where	occupation_code = @id
GO