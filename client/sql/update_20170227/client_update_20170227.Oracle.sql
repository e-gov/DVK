create procedure Save_DhlOrganization(
    org_code in varchar2,
    org_name in varchar2,
    is_dhl_capable in number,
    is_dhl_direct_capable in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    parent_org_code in varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    dhl_organization o
    where   o.org_code = Save_DhlOrganization.org_code;

    if (cnt = 0) then
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
        values  (Save_DhlOrganization.org_code,
                Save_DhlOrganization.org_name,
                Save_DhlOrganization.is_dhl_capable,
                Save_DhlOrganization.is_dhl_direct_capable,
                Save_DhlOrganization.xroad_service_instance,
                Save_DhlOrganization.xroad_service_member_class,
                Save_DhlOrganization.xroad_service_member_code,
                Save_DhlOrganization.dhl_direct_producer_name,
                Save_DhlOrganization.dhl_direct_service_url,
                Save_DhlOrganization.parent_org_code);
    else
        update  dhl_organization
        set     org_name = Save_DhlOrganization.org_name,
                dhl_capable = Save_DhlOrganization.is_dhl_capable,
                dhl_direct_capable = Save_DhlOrganization.is_dhl_direct_capable,
                xroad_service_instance = Save_DhlOrganization.xroad_service_instance,
                xroad_service_member_class = Save_DhlOrganization.xroad_service_member_class,
                xroad_service_member_code = Save_DhlOrganization.xroad_service_member_code,
                dhl_direct_producer_name = Save_DhlOrganization.dhl_direct_producer_name,
                dhl_direct_service_url = Save_DhlOrganization.dhl_direct_service_url,
                parent_org_code = Save_DhlOrganization.parent_org_code
        where   org_code = Save_DhlOrganization.org_code;
    end if;
end;
/