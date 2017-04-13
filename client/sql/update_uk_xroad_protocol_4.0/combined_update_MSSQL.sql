ALTER TABLE dhl_settings
ADD xroad_client_instance nvarchar(6),
ADD xroad_client_member_class nvarchar(50),
ADD xroad_client_subsystem_code nvarchar(50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance nvarchar(6),
ADD xroad_service_member_class nvarchar(50),
ADD xroad_service_member_code nvarchar(50);

ALTER TABLE dhl_organization
ADD xroad_service_instance nvarchar(6),
ADD xroad_service_member_class nvarchar(50),
ADD xroad_service_member_code nvarchar(50);


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

ALTER TABLE dhl_settings
ADD xroad_client_member_code nvarchar(50);


create procedure Save_DhlMessageRecipient
	@dhl_message_recipient_id int out,
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
	@xroad_service_instance nvarchar(2),
    @xroad_service_member_class nvarchar(50),
    @xroad_service_member_code nvarchar(50),
	@producer_name nvarchar(50),
	@service_url nvarchar(100),
	@recipient_division_id int,
	@recipient_division_name nvarchar(100),
	@recipient_position_id int,
	@recipient_position_name nvarchar(100),
	@recipient_division_code nvarchar(25),
	@recipient_position_code nvarchar(25)
as

if @recipient_org_code is null
	set @recipient_org_code = ''
if @recipient_person_code is null
	set @recipient_person_code = ''
if @recipient_division_id is null
	set @recipient_division_id = 0
if @recipient_position_id is null
	set @recipient_position_id = 0
if @recipient_division_code is null
	set @recipient_division_code = ''
if @recipient_position_code is null
	set @recipient_position_code = ''

if exists (select * from dhl_message_recipient where dhl_message_id = @dhl_message_id and recipient_org_code = @recipient_org_code and recipient_person_code = @recipient_person_code and recipient_division_id=@recipient_division_id and recipient_position_id=@recipient_position_id and recipient_division_code = @recipient_division_code and recipient_position_code = @recipient_position_code)
begin
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
		xroad_service_instance = @xroad_service_instance,
		xroad_service_member_class = @xroad_service_member_class,
		xroad_service_member_code = @xroad_service_member_code,
		producer_name = @producer_name,
		service_url = @service_url,
		recipient_division_name = @recipient_division_name,
		recipient_position_name = @recipient_position_name
	where	dhl_message_id = @dhl_message_id
		and recipient_org_code = @recipient_org_code
		and recipient_person_code = @recipient_person_code
		and recipient_division_id = @recipient_division_id
		and recipient_position_id = @recipient_position_id
		and recipient_division_code = @recipient_division_code
		and recipient_position_code = @recipient_position_code

	select	@dhl_message_recipient_id = dhl_message_recipient_id
	from	dhl_message_recipient
	where	dhl_message_id = @dhl_message_id
		and recipient_org_code = @recipient_org_code
		and recipient_person_code = @recipient_person_code
		and recipient_division_id = @recipient_division_id
		and recipient_position_id = @recipient_position_id
		and recipient_division_code = @recipient_division_code
		and recipient_position_code = @recipient_position_code
end
else
begin
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
		xroad_service_instance,
		xroad_service_member_class,
		xroad_service_member_code,
		producer_name,
		service_url,
		recipient_division_id,
		recipient_division_name,
		recipient_position_id,
		recipient_position_name,
		recipient_division_code,
		recipient_position_code)
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
		@xroad_service_instance,
	    @xroad_service_member_class,
	    @xroad_service_member_code,
		@producer_name,
		@service_url,
		@recipient_division_id,
		@recipient_division_name,
		@recipient_position_id,
		@recipient_position_name,
		@recipient_division_code,
		@recipient_position_code)

	set @dhl_message_recipient_id = scope_identity()
end
GO

CREATE PROCEDURE [Update_DhlMessageRecipDhlID]
	@dhl_message_id int,
	@dhl_direct_capable int,
	@xroad_service_instance nvarchar(2),
	@xroad_service_member_class nvarchar(50),
	@xroad_service_member_code nvarchar(50),
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100),
	@dhl_id int,
	@query_id nvarchar(50)
AS
-- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
update	dhl_message_recipient
set	dhl_id = @dhl_id,
	query_id = @query_id,
	xroad_service_instance = @xroad_service_instance,
	xroad_service_member_class = @xroad_service_member_class,
	xroad_service_member_code = @xroad_service_member_code,
	producer_name = @dhl_direct_producer_name,
	service_url = @dhl_direct_service_url
where	dhl_message_id = @dhl_message_id
	and recipient_org_code in
	(
		select	org_code
		from	dhl_organization
		where	isnull(dhl_direct_capable,1) = isnull(@dhl_direct_capable,1)
				and isnull(xroad_service_instance,'') = isnull(@xroad_service_instance,'')
				and isnull(xroad_service_member_class,'') = isnull(@xroad_service_member_class,'')
				and isnull(xroad_service_member_code,'') = isnull(@xroad_service_member_code,'')
				and isnull(dhl_direct_producer_name,'') = isnull(@dhl_direct_producer_name,'')
				and isnull(dhl_direct_service_url,'') = isnull(@dhl_direct_service_url,'')
	)
GO

create procedure [dbo].[Get_DhlCapabilityByMessageID]
	@dhl_message_id int
AS
SELECT	DISTINCT
	o.dhl_capable,
	o.dhl_direct_capable,
	o.xroad_service_instance,
	o.xroad_service_member_class,
	o.xroad_service_member_code,
	o.dhl_direct_producer_name,
	o.dhl_direct_service_url
FROM	dhl_organization o
INNER JOIN
	dhl_message_recipient r ON r.recipient_org_code = o.org_code
WHERE	r.dhl_message_id = @dhl_message_id
ORDER BY
	o.dhl_direct_service_url desc
GO

CREATE PROCEDURE Get_DhlOrgsByCapability
	@dhl_capable int,
	@dhl_direct_capable int,
	@dhl_direct_producer_name nvarchar(50),
	@dhl_direct_service_url nvarchar(100),
	@xroad_service_instance nvarchar(2),
	@xroad_service_member_class nvarchar(50),
	@xroad_service_member_code nvarchar(50)
AS
SELECT	org_code
FROM	dhl_organization
WHERE	isnull(dhl_capable,0) = isnull(@dhl_capable,0)
	AND isnull(dhl_direct_capable,0) = isnull(@dhl_direct_capable,0)
	AND isnull(dhl_direct_producer_name,'') = isnull(@dhl_direct_producer_name,'')
	AND isnull(dhl_direct_service_url,'') = isnull(@dhl_direct_service_url,'')
	AND isnull(xroad_service_instance,'') = isnull(@xroad_service_instance,'')
	AND isnull(xroad_service_member_class,'') = isnull(@xroad_service_member_class,'')
	AND isnull(xroad_service_member_code,'') = isnull(@xroad_service_member_code,'')
GO

create procedure [dbo].[Get_DhlMessageIDByGuid]
	@dhl_message_id int output,
	@dhl_guid varchar(36),
	@xroad_service_instance nvarchar(2),
	@xroad_service_member_class nvarchar(50),
	@xroad_service_member_code nvarchar(50),
	@producer_name nvarchar(50),
	@service_url nvarchar(100),
	@is_incoming int
as
if @is_incoming = 0
begin
	select	@dhl_message_id = max(m.dhl_message_id)
	from	dhl_message m
	inner join
			dhl_message_recipient r on r.dhl_message_id = m.dhl_message_id
	where	m.dhl_guid = @dhl_guid
		and isnull(r.xroad_service_instance,'') = isnull(@xroad_service_instance,'')
		and isnull(r.xroad_service_member_class,'') = isnull(@xroad_service_member_class,'')
		and isnull(r.xroad_service_member_code,'') = isnull(@xroad_service_member_code,'')
		and isnull(r.producer_name,'') = isnull(@producer_name,'')
		and isnull(r.service_url,'') = isnull(@service_url,'')
		and m.is_incoming = 0
end
else
begin
	if exists (select * from dhl_message m where m.dhl_guid=@dhl_guid and m.is_incoming=@is_incoming)
		select	@dhl_message_id = m.dhl_message_id
		from	dhl_message m
		where	m.dhl_guid = @dhl_guid
			and m.is_incoming = 1
	else
		set @dhl_message_id = 0
end
set @dhl_message_id = isnull(@dhl_message_id, 0)
GO

create procedure Get_DhlMessageID
	@dhl_message_id int output,
	@dhl_id int,
	@xroad_service_instance nvarchar(2),
	@xroad_service_member_class nvarchar(50),
	@xroad_service_member_code nvarchar(50),
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
            and isnull(r.xroad_service_instance,'') = isnull(@xroad_service_instance,'')
			and isnull(r.xroad_service_member_class,'') = isnull(@xroad_service_member_class,'')
			and isnull(r.xroad_service_member_code,'') = isnull(@xroad_service_member_code,'')
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



