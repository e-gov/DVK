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