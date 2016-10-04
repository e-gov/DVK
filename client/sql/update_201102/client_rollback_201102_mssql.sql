----------------------------------------------------------------------
-- February 2011
-- Rollback DVK Client from version 1.6.1 to 1.6.0
----------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Delete_OldDhlMessages]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Delete_OldDhlMessages]
GO
