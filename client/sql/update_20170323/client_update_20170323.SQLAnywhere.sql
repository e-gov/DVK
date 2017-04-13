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
