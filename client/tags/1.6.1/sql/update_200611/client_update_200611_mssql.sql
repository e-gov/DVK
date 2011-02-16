create
table	dhl_settings_folders
(
	id int not null primary key identity(1, 1),
	dhl_settings_id int not null,
	folder_name nvarchar(4000) null
)
go

ALTER
TABLE	dhl_settings_folders
ADD
CONSTRAINT	FK_dhl_settings_folders
FOREIGN KEY	( dhl_settings_id )
REFERENCES	dhl_settings (id)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Get_DhlSettingFolders]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Get_DhlSettingFolders]
GO
CREATE PROCEDURE Get_DhlSettingFolders
	@dhl_settings_id int
AS

SELECT	folder_name
FROM	dhl_settings_folders
WHERE	dhl_settings_id = @dhl_settings_id
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Update_DhlMessageStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Update_DhlMessageStatus]
GO
CREATE PROCEDURE Update_DhlMessageStatus
	@dhl_id int,
	@status_id int,
	@error_message nvarchar(2000),
	@is_incoming int
AS

update	dhl_message
set	sending_status_id = @status_id,
	error_message = @error_message
where	dhl_id = @dhl_id
	and is_incoming = @is_incoming
GO