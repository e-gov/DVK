create or replace
function "Save_DhlOrganization"(
    p_org_code character varying,
    p_org_name character varying,
    p_is_dhl_capable integer,
    p_is_dhl_direct_capable integer,
    p_xroad_service_instance character varying,
    p_xroad_service_member_class character varying,
    p_xroad_service_member_code character varying,
    p_dhl_direct_producer_name character varying,
    p_dhl_direct_service_url character varying,
    p_parent_org_code character varying)
returns boolean
as $$
begin
    perform *
    from    dhl_organization o
    where   o.org_code = p_org_code;

    if (not found) then
        insert
        into    dhl_organization(
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
        values  (p_org_code,
                p_org_name,
                p_is_dhl_capable,
                p_is_dhl_direct_capable,
                p_xroad_service_instance,
			    p_xroad_service_member_class,
			    p_xroad_service_member_code,
                p_dhl_direct_producer_name,
                p_dhl_direct_service_url,
                p_parent_org_code);
    else
        update  dhl_organization
        set     org_name = p_org_name,
                dhl_capable = p_is_dhl_capable,
                dhl_direct_capable = p_is_dhl_direct_capable,
                xroad_service_instance = p_xroad_service_instance,
                xroad_service_member_class = p_xroad_service_member_class,
                xroad_service_member_code = p_xroad_service_member_code,
                dhl_direct_producer_name = p_dhl_direct_producer_name,
                dhl_direct_service_url = p_dhl_direct_service_url,
                parent_org_code = p_parent_org_code
        where   org_code = p_org_code;
    end if;

    return found;
end; $$
language plpgsql;