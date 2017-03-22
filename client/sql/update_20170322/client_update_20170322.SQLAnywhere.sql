create procedure "Save_DhlMessageRecipient"
(
	in _dhl_message_id int,
	in _recipient_org_code varchar(20),
	in _recipient_org_name varchar(100),
	in _recipient_person_code varchar(20),
	in _recipient_name varchar(100),
	in _sending_date datetime,
	in _received_date datetime,
	in _sending_status_id int,
	in _recipient_status_id int,
	in _fault_code varchar(50),
	in _fault_actor varchar(250),
	in _fault_string varchar(500),
	in _fault_detail varchar(2000),
	in _metaxml long varchar,
	in _dhl_id int,
	in _xroad_service_instance varchar(2),
    in _xroad_service_member_class varchar(50),
    in _xroad_service_member_code varchar(50),
	in _producer_name varchar(50),
	in _service_url varchar(100),
	in _recipient_division_id int,
	in _recipient_division_name varchar(100),
	in _recipient_position_id int,
	in _recipient_position_name varchar(100),
	in _recipient_division_code varchar(25),
	in _recipient_position_code varchar(25),
	out _dhl_message_recipient_id int
)
begin
    if _recipient_org_code is null then
    	set _recipient_org_code = '';
    end if;
    if _recipient_person_code is null then
    	set _recipient_person_code = '';
    end if;
    if _recipient_division_id is null then
    	set _recipient_division_id = 0;
    end if;
    if _recipient_position_id is null then
    	set _recipient_position_id = 0;
    end if;
    if _recipient_division_code is null then
    	set _recipient_division_code = '';
    end if;
    if _recipient_position_code is null then
    	set _recipient_position_code = '';
    end if;
    	
    if exists (select * from dhl_message_recipient where "dhl_message_id" = _dhl_message_id and "recipient_org_code" = _recipient_org_code and "recipient_person_code" = _recipient_person_code and "recipient_division_id"=_recipient_division_id and "recipient_position_id"=_recipient_position_id and "recipient_division_code" = _recipient_division_code and "recipient_position_code" = _recipient_position_code) then
    	update	dhl_message_recipient
    	set     "recipient_org_name" = _recipient_org_name,
        		"recipient_name" = _recipient_name,
        		"sending_date" = _sending_date,
        		"received_date" = _received_date,
        		"sending_status_id" = _sending_status_id,
        		"recipient_status_id" = _recipient_status_id,
        		"fault_code" = _fault_code,
        		"fault_actor" = _fault_actor,
        		"fault_string" = _fault_string,
        		"fault_detail" = _fault_detail,
        		"metaxml" = _metaxml,
        		"dhl_id" = _dhl_id,
        		"xroad_service_instance" = _xroad_service_instance,
                "xroad_service_member_class" = _xroad_service_member_class,
                "xroad_service_member_code" = _xroad_service_member_code,
        		"producer_name" = _producer_name,
        		"service_url" = _service_url,
        		"recipient_division_name" = _recipient_division_name,
        		"recipient_position_name" = _recipient_position_name
    	where	"dhl_message_id" = _dhl_message_id
        		and "recipient_org_code" = _recipient_org_code
        		and "recipient_person_code" = _recipient_person_code
        		and "recipient_division_id" = _recipient_division_id
        		and "recipient_position_id" = _recipient_position_id
        		and "recipient_division_code" = _recipient_division_code
        		and "recipient_position_code" = _recipient_position_code;
    	
    	set	_dhl_message_recipient_id = isnull((
	    	select	"dhl_message_recipient_id"
	    	from	dhl_message_recipient
	    	where	"dhl_message_id" = _dhl_message_id
	        		and "recipient_org_code" = _recipient_org_code
	        		and "recipient_person_code" = _recipient_person_code
	        		and "recipient_division_id" = _recipient_division_id
	        		and "recipient_position_id" = _recipient_position_id
	        		and "recipient_division_code" = _recipient_division_code
	        		and "recipient_position_code" = _recipient_position_code
        ),0);
    else
    	insert
    	into	dhl_message_recipient(
        		"dhl_message_id",
        		"recipient_org_code",
        		"recipient_org_name",
        		"recipient_person_code",
        		"recipient_name",
        		"sending_date",
        		"received_date",
        		"sending_status_id",
        		"recipient_status_id",
        		"fault_code",
        		"fault_actor",
        		"fault_string",
        		"fault_detail",
        		"metaxml",
        		"dhl_id",
        		"xroad_service_instance",
                "xroad_service_member_class",
                "xroad_service_member_code",
        		"producer_name",
        		"service_url",
        		"recipient_division_id",
        		"recipient_division_name",
        		"recipient_position_id",
        		"recipient_position_name",
        		"recipient_division_code",
        		"recipient_position_code")
    	values	(_dhl_message_id,
        		_recipient_org_code,
        		_recipient_org_name,
        		_recipient_person_code,
        		_recipient_name,
        		_sending_date,
        		_received_date,
        		_sending_status_id,
        		_recipient_status_id,
        		_fault_code,
        		_fault_actor,
        		_fault_string,
        		_fault_detail,
        		_metaxml,
        		_dhl_id,
        		_xroad_service_instance,
			    _xroad_service_member_class,
			    _xroad_service_member_code,
        		_producer_name,
        		_service_url,
        		_recipient_division_id,
        		_recipient_division_name,
        		_recipient_position_id,
        		_recipient_position_name,
        		_recipient_division_code,
        		_recipient_position_code);
    	
    	set _dhl_message_recipient_id = @@identity;
    end if;
end;