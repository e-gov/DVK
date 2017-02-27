create procedure [dbo].[Save_DhlOrganization]
	@org_code nvarchar(20),
	@org_name nvarchar(100),
	@is_dhl_capable int,
	@is_dhl_direct_capable int,
	@xroad_service_instance nvarchar(2),
    @xroad_service_member_class nvarchar(50),
    @xroad_service_member_code nvarchar(50),
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100),
	@parent_org_code nvarchar(20)
AS

if not exists (select * from dhl_organization where org_code = @org_code)
	insert
	into	dhl_organization(
		org_code,
		org_name,
		dhl_capable,
		dhl_direct_capable,
		xroad_service_instance,
		xroad_service_member_class,
		xroad_service_member_code,
		dhl_direct_producer_name,
		dhl_direct_service_url,
		parent_org_code)
	values	(
	    @org_code,
		@org_name,
		@is_dhl_capable,
		@is_dhl_direct_capable,
		@xroad_service_instance,
	    @xroad_service_member_class,
	    @xroad_service_member_code,
		@dhl_direct_producer_name,
		@dhl_direct_service_url,
		@parent_org_code)
else
	update	dhl_organization
	set	org_name = @org_name,
		dhl_capable = @is_dhl_capable,
		dhl_direct_capable = @is_dhl_direct_capable,
		xroad_service_instance = @xroad_service_instance,
		xroad_service_member_class =  @xroad_service_member_class,
		xroad_service_member_code  = @xroad_service_member_code,
		dhl_direct_producer_name = @dhl_direct_producer_name,
		dhl_direct_service_url = @dhl_direct_service_url,
		parent_org_code = @parent_org_code
	where	org_code = @org_code
GO