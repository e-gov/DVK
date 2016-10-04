----------------------------------------------------------------------
-- March 2014
-- Rollback DVK Client from version 1.6.3 to 1.6.2
----------------------------------------------------------------------

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='dhl_request_log' AND TABLE_SCHEMA = 'dbo')
BEGIN
    ALTER TABLE [dbo].dhl_request_log
    DROP CONSTRAINT FK_dhl_error_log_id
	DROP TABLE [dbo].dhl_request_log
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='dhl_error_log' AND TABLE_SCHEMA = 'dbo')
BEGIN
    ALTER TABLE [dbo].dhl_error_log
    DROP CONSTRAINT FK_dhl_message_id
	DROP TABLE [dbo].dhl_error_log
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Add_DhlErrorLog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Add_DhlErrorLog]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Add_DhlRequestLog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Add_DhlRequestLog]
GO


