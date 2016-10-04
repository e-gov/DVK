ALTER TABLE [dbo].[dhl_message_recipient] DROP COLUMN opened;
GO

DROP PROCEDURE [dbo].[Get_NotOpenedInAdit] 
GO

DROP PROCEDURE [dbo].[Update_MessageRecipientOpened]
GO