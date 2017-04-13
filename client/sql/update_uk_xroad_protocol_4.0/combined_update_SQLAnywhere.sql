ALTER TABLE dhl_settings
ADD xroad_client_instance VARCHAR(6),
ADD xroad_client_member_class VARCHAR(50),
ADD xroad_client_subsystem_code VARCHAR(50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);

ALTER TABLE dhl_organization
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);



create procedure "Save_DhlOrganization"
(
	in _org_code varchar(20),
	in _org_name varchar(100),
	in _is_dhl_capable int,
	in _is_dhl_direct_capable int,
	in _xroad_service_instance varchar(2),
    in _xroad_service_member_class varchar(50),
    in _xroad_service_member_code varchar(50),
	in _dhl_direct_producer_name varchar(50),
	in _dhl_direct_service_url varchar(100),
	in _parent_org_code varchar(20)
)
begin
    if not exists (select * from dhl_organization where "org_code" = _org_code) then
        insert
    	into	dhl_organization(
    		    "org_code",
    		    "org_name",
    		    "dhl_capable",
    		    "dhl_direct_capable",
    		    "xroad_service_instance",
    		    "xroad_service_member_class",
    		    "xroad_service_member_code",
    		    "dhl_direct_producer_name",
    		    "dhl_direct_service_url",
    		    "parent_org_code")
    	values	(_org_code,
        		_org_name,
        		_is_dhl_capable,
        		_is_dhl_direct_capable,
        		_xroad_service_instance,
			    _xroad_service_member_class,
			    _xroad_service_member_code,
        		_dhl_direct_producer_name,
        		_dhl_direct_service_url,
        		_parent_org_code);
    else
    	update	dhl_organization
    	set     "org_name" = _org_name,
        		"dhl_capable" = _is_dhl_capable,
        		"dhl_direct_capable" = _is_dhl_direct_capable,
        		"xroad_service_instance" = _xroad_service_instance,
                "xroad_service_member_class" = _xroad_service_member_class,
                "xroad_service_member_code" = _xroad_service_member_code,
        		"dhl_direct_producer_name" = _dhl_direct_producer_name,
        		"dhl_direct_service_url" = _dhl_direct_service_url,
        		"parent_org_code" = _parent_org_code
    	where	"org_code" = _org_code;
    end if;
end;

ALTER TABLE dhl_settings
ADD xroad_client_member_code VARCHAR(50);


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

create procedure "Update_DhlMessageRecipDhlID"
(
	in _dhl_message_id int,
	in _dhl_direct_capable int,
	in _xroad_service_instance varchar(2),
	in _xroad_service_member_class varchar(50),
	in _xroad_service_member_code varchar(50),
	in _dhl_direct_producer_name varchar(50),
	in _dhl_direct_service_url varchar(100),
	in _dhl_id int,
	in _query_id varchar(50)
)
begin
    -- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
    update	dhl_message_recipient
    set     "dhl_id" = _dhl_id,
        	"query_id" = _query_id,
        	"xroad_service_instance" = _xroad_service_instance,
            "xroad_service_member_class" = _xroad_service_member_class,
            "xroad_service_member_code" = _xroad_service_member_code,
        	"producer_name" = _dhl_direct_producer_name,
        	"service_url" = _dhl_direct_service_url
    where	"dhl_message_id" = _dhl_message_id 
        	and "recipient_org_code" in
        	(
        		select	"org_code"
        		from	dhl_organization
        		where	isnull("dhl_direct_capable",1) = isnull(_dhl_direct_capable,1)
        				and isnull("xroad_service_instance",'') = isnull(_xroad_service_instance,'')
			        	and isnull("xroad_service_member_class",'') = isnull(_xroad_service_member_class,'')
			        	and isnull("xroad_service_member_code",'') = isnull(_xroad_service_member_code,'')
        				and isnull("dhl_direct_producer_name",'') = isnull(_dhl_direct_producer_name,'')
        				and isnull("dhl_direct_service_url",'') = isnull(_dhl_direct_service_url,'')
        	);
end;

create procedure "Get_DhlCapabilityByMessageID"
(
	in _dhl_message_id int
)
begin
    select  distinct
        	o."dhl_capable",
        	o."dhl_direct_capable",
        	o."xroad_service_instance",
		    o."xroad_service_member_class",
		    o."xroad_service_member_code",
        	o."dhl_direct_producer_name",
        	o."dhl_direct_service_url"
    from	dhl_organization o
    inner join
    	    dhl_message_recipient r ON r."recipient_org_code" = o."org_code"
    where	r."dhl_message_id" = _dhl_message_id
    order by
    	    o.dhl_direct_service_url desc;
end;

create procedure "Get_DhlOrgsByCapability"
(
	in _dhl_capable int,
	in _dhl_direct_capable int,
	in _dhl_direct_producer_name varchar(50),
	in _dhl_direct_service_url varchar(100),
	in _xroad_service_instance varchar(2),
	in _xroad_service_member_class varchar(50),
	in _xroad_service_member_code varchar(50)
)
begin
    select	"org_code"
    from	dhl_organization
    where	isnull("dhl_capable",0) = isnull(_dhl_capable,0)
        	and isnull("dhl_direct_capable",0) = isnull(_dhl_direct_capable,0)
        	and isnull("dhl_direct_producer_name",'') = isnull(_dhl_direct_producer_name,'')
        	and isnull("dhl_direct_service_url",'') = isnull(_dhl_direct_service_url,'')
        	and isnull("xroad_service_instance",'') = isnull(_xroad_service_instance,'')
        	and isnull("xroad_service_member_class",'') = isnull(_xroad_service_member_class,'')
        	and isnull("xroad_service_member_code",'') = isnull(_xroad_service_member_code,'');
end;

create procedure "Get_DhlMessageIDByGuid"
(
	in _dhl_guid varchar(36),
	in _xroad_service_instance varchar(2),
    in _xroad_service_member_class varchar(50),
    in _xroad_service_member_code varchar(50),
	in _producer_name varchar(50),
	in _service_url varchar(100),
	in _is_incoming int,
	out _dhl_message_id int
)
begin
    if _is_incoming = 0 then
    	set	_dhl_message_id = isnull((
	    	select	max(m."dhl_message_id")
	    	from	dhl_message m
	    	inner join
	    			dhl_message_recipient r on r."dhl_message_id" = m."dhl_message_id"
	    	where	m."dhl_guid" = _dhl_guid
	    	        and isnull(r."xroad_service_instance",'') = isnull(_xroad_service_instance,'')
                    and isnull(r."xroad_service_member_class",'') = isnull(_xroad_service_member_class,'')
                    and isnull(r."xroad_service_member_code",'') = isnull(_xroad_service_member_code,'')
	        		and isnull(r."producer_name",'') = isnull(_producer_name,'')
	        		and isnull(r."service_url",'') = isnull(_service_url,'')
	        		and m."is_incoming" = 0
        ),0);
    else
    	if exists (select * from dhl_message m where m."dhl_guid"=_dhl_guid and m."is_incoming"=_is_incoming) then
    		set	_dhl_message_id = isnull((
	    		select	m."dhl_message_id"
	    		from	dhl_message m
	    		where	m."dhl_guid" = _dhl_guid
	    			    and m."is_incoming" = 1
    		),0);
    	else
    		set _dhl_message_id = 0;
        end if;
    end if;

    set _dhl_message_id = isnull(_dhl_message_id, 0);
end;

create procedure "Get_DhlMessageID"
(
	in _dhl_id int,
	in _xroad_service_instance varchar(2),
	in _xroad_service_member_class varchar(50),
	in _xroad_service_member_code varchar(50),
	in _producer_name varchar(50),
	in _service_url varchar(100),
	in _is_incoming int,
	out _dhl_message_id int
)
begin
    if _is_incoming = 0 then
    	set	_dhl_message_id = isnull((
	    	select  max(r."dhl_message_id")
	    	from    dhl_message_recipient r
            inner join
                    dhl_message m on m."dhl_message_id" = r."dhl_message_id"
	    	where   m."is_incoming" = 0
	    	        and r."dhl_id" = _dhl_id
	    	        and isnull(r."xroad_service_instance",'') = isnull(_xroad_service_instance,'')
                    and isnull(r."xroad_service_member_class",'') = isnull(_xroad_service_member_class,'')
                    and isnull(r."xroad_service_member_code",'') = isnull(_xroad_service_member_code,'')
	        		and isnull(r."producer_name",'') = isnull(_producer_name,'')
	        		and isnull(r."service_url",'') = isnull(_service_url,'')
	    ),0);
    else
    	if exists (select * from dhl_message m where m."dhl_id"=_dhl_id and m."is_incoming"=_is_incoming) then
    		set	_dhl_message_id = isnull((
	    		select	m."dhl_message_id"
	    		from	dhl_message m
	    		where	m."dhl_id" = _dhl_id
	    			    and m."is_incoming" = 1
	    	),0);
    	else
    		set _dhl_message_id = 0;
        end if;
    end if;
    
    set _dhl_message_id = isnull(_dhl_message_id, 0);
end;


