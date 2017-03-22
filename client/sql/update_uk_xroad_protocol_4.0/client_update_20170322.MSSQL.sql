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