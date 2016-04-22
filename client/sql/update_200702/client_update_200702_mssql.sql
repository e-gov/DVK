create
table	dhl_message_recipient
(
	dhl_message_id int not null,
	recipient_org_code nvarchar(20) not null,
	recipient_org_name nvarchar(100) null,
	recipient_person_code nvarchar(20) not null,
	recipient_name nvarchar(100) null,
	sending_date datetime null,
	received_date datetime null,
	sending_status_id int not null,
	recipient_status_id int null,
	fault_code nvarchar(50) null,
	fault_actor nvarchar(250) null,
	fault_string nvarchar(500) null,
	fault_detail nvarchar(2000) null,
	metaxml ntext null
)
GO

alter table dhl_message_recipient
add constraint PK_dhl_message_recipient
primary key (dhl_message_id, recipient_org_code, recipient_person_code)
GO

alter table dhl_message_recipient
add constraint fk_dhl_message_recipient_1
foreign key (dhl_message_id)
references dhl_message (dhl_message_id)
on delete cascade
GO

alter
table   dhl_message
drop
column  error_message
GO

alter
table   dhl_message
add	recipient_status_id int,
	fault_code nvarchar(50) null,
	fault_actor nvarchar(250) null,
	fault_string nvarchar(500) null,
	fault_detail nvarchar(2000) null,
	status_update_needed int null,
	metaxml ntext null
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Add_DhlMessage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Add_DhlMessage]
GO
CREATE PROCEDURE Add_DhlMessage
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
	@metaxml ntext
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
	metaxml)
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
	@metaxml)

SELECT	@id = scope_identity()
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessage]
GO
CREATE PROCEDURE Update_DhlMessage
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
	@metaxml ntext
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
	metaxml = @metaxml
WHERE	dhl_message_id = @id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessages]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessages]
GO
CREATE PROCEDURE Get_DhlMessages
	@incoming int,
	@status_id int,
	@unit_id int,
	@status_update_needed int
AS

SELECT	*
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


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMsgStatusUpdateNeed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMsgStatusUpdateNeed]
GO
CREATE PROCEDURE Update_DhlMsgStatusUpdateNeed
	@message_id int,
	@status_update_needed int
AS

UPDATE	dhl_message
SET	status_update_needed = @status_update_needed
WHERE	dhl_message_id = @message_id
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessageRecipients]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessageRecipients]
GO
create procedure Get_DhlMessageRecipients
	@message_id int
as
select	r.*
from	dhl_message_recipient r
where	r.dhl_message_id = @message_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlMessageID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlMessageID]
GO
create procedure Get_DhlMessageID
	@dhl_message_id int output,
	@dhl_id int,
	@is_incoming int
as

if exists (select * from dhl_message m where m.dhl_id=@dhl_id and m.is_incoming=@is_incoming)
	select	@dhl_message_id = m.dhl_message_id
	from	dhl_message m
	where	m.dhl_id = @dhl_id
		and m.is_incoming = @is_incoming
else
	set @dhl_message_id = 0
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
	@metaxml ntext
as

if @recipient_org_code is null
	set @recipient_org_code = ''
if @recipient_person_code is null
	set @recipient_person_code = ''

if exists (select * from dhl_message_recipient where dhl_message_id = @dhl_message_id and recipient_org_code = @recipient_org_code and recipient_person_code = @recipient_person_code)
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
		metaxml = @metaxml
	where	dhl_message_id = @dhl_message_id
		and recipient_org_code = @recipient_org_code
		and recipient_person_code = @recipient_person_code;
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
		metaxml)
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
		@metaxml)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageStatus]
GO
CREATE PROCEDURE Update_DhlMessageStatus
	@dhl_message_id int,
	@status_id int
AS

update	dhl_message
set	sending_status_id = @status_id,
	status_update_needed = NULL
where	dhl_message_id = @dhl_message_id
GO

