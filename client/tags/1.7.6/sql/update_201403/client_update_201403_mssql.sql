----------------------------------------------------------------------
-- March 2014
-- Update DVK Client from version 1.6.2 to 1.6.3
----------------------------------------------------------------------

create
table dhl_error_log
(
	dhl_error_log_id int identity(1,1) not null,
	error_datetime datetime not null,
	organization_code nvarchar(20) null,
	user_code nvarchar(20) null,
	action_name nvarchar(200) null,
    error_message nvarchar(500) not null,
	dhl_message_id int null,
)
GO

create
table dhl_request_log
(
	dhl_request_log_id int identity(1,1) not null,
	request_datetime datetime not null,
	organization_code nvarchar(20) not null,
	user_code nvarchar(20) null,
	request_name nvarchar(100) not null,
    response nvarchar(10) null,
	dhl_error_log_id int null,
)
GO

ALTER TABLE dhl_error_log
ADD CONSTRAINT PK_dhl_error_log PRIMARY KEY (dhl_error_log_id)
GO

ALTER TABLE dhl_error_log
ADD CONSTRAINT UQ_dhl_error_id UNIQUE (dhl_error_log_id)
GO

ALTER TABLE dhl_error_log
ADD CONSTRAINT FK_dhl_message_id
FOREIGN KEY (dhl_message_id) REFERENCES dhl_message (dhl_message_id)
GO

ALTER TABLE dhl_request_log
ADD CONSTRAINT PK_dhl_request_log PRIMARY KEY (dhl_request_log_id)
GO

ALTER TABLE dhl_request_log
ADD CONSTRAINT UQ_dhl_request_log__id UNIQUE (dhl_request_log_id)
GO

ALTER TABLE dhl_request_log
ADD CONSTRAINT FK_dhl_error_log_id
FOREIGN KEY (dhl_error_log_id) REFERENCES dhl_error_log (dhl_error_log_id)
GO

create procedure [dbo].[Add_DhlErrorLog]
    @error_log_entry_id int out,
	@error_datetime datetime,
	@organization_code nvarchar(20),
	@user_code nvarchar(20),
	@action_name nvarchar(200),
	@error_message nvarchar(500),
	@dhl_message_id int
AS
    SET @error_log_entry_id = null
	insert
	into	dhl_error_log(
		error_datetime,
		organization_code,
		user_code,
		action_name,
		error_message,
		dhl_message_id)
	values	(@error_datetime,
		@organization_code,
		@user_code,
		@action_name,
		@error_message,
		@dhl_message_id)
    SET @error_log_entry_id = SCOPE_IDENTITY();

GO

CREATE procedure [dbo].[Add_DhlRequestLog]
    @request_log_entry_id int out,
	@request_datetime datetime,
	@organization_code nvarchar(20),
	@user_code nvarchar(20),
	@request_name nvarchar(100),
	@response nvarchar(10),
	@dhl_error_log_id int
AS
    set @request_log_entry_id = null;
	insert
	into	dhl_request_log(
		request_datetime,
		organization_code,
		user_code,
		request_name,
		response,
		dhl_error_log_id)
	values	(@request_datetime,
		@organization_code,
		@user_code,
		@request_name,
		@response,
		@dhl_error_log_id);
SET @request_log_entry_id = SCOPE_IDENTITY();
GO


