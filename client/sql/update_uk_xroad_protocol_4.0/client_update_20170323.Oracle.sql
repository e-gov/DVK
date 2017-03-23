create procedure Update_DhlMessageRecipDhlID(
    dhl_message_id in number,
    dhl_direct_capable in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2),
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    dhl_id in number,
    query_id in varchar2
as
begin
    -- salvestab vastuvõtja andmetesse vastuvõtja DVK serveri poolt antud sõnumi ID väärtuse
    update  dhl_message_recipient
    set     dhl_id = Update_DhlMessageRecipDhlID.dhl_id,
            query_id = Update_DhlMessageRecipDhlID.query_id,
            xroad_service_instance = Update_DhlMessageRecipDhlID.xroad_service_instance,
		    xroad_service_member_class = Update_DhlMessageRecipDhlID.xroad_service_member_class,
		    xroad_service_member_code = Update_DhlMessageRecipDhlID.xroad_service_member_code,
		    producer_name = Update_DhlMessageRecipDhlID.dhl_direct_producer_name,
		    service_url = Update_DhlMessageRecipDhlID.dhl_direct_service_url
    where   dhl_message_id = Update_DhlMessageRecipDhlID.dhl_message_id
            and recipient_org_code in
            (
                select  org_code
                from    dhl_organization
                where   nvl(dhl_direct_capable,1) = nvl(Update_DhlMessageRecipDhlID.dhl_direct_capable,1)
						and nvl(xroad_service_instance,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_instance,'')
						and nvl(xroad_service_member_class,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_member_class,'')
						and nvl(xroad_service_member_code,'') = nvl(Update_DhlMessageRecipDhlID.xroad_service_member_code,'')
						and nvl(dhl_direct_producer_name,'') = nvl(Update_DhlMessageRecipDhlID.dhl_direct_producer_name,'')
						and nvl(dhl_direct_service_url,'') = nvl(Update_DhlMessageRecipDhlID.dhl_direct_service_url,'')
            );
end;
/

create procedure Get_DhlCapabilityByMessageID(
    dhl_message_id number,
    RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  distinct
            o.dhl_capable,
            o.dhl_direct_capable,
            o.xroad_service_instance,
		    o.xroad_service_member_class,
		    o.xroad_service_member_code,
            o.dhl_direct_producer_name,
            o.dhl_direct_service_url
    from    dhl_organization o
    inner join
        dhl_message_recipient r on r.recipient_org_code = o.org_code
    where   r.dhl_message_id = Get_DhlCapabilityByMessageID.dhl_message_id
    order by
            o.dhl_direct_service_url desc;
end;
/

create procedure Get_DhlOrgsByCapability(
    dhl_capable in number,
    dhl_direct_capable in number,
    dhl_direct_producer_name in varchar2,
    dhl_direct_service_url in varchar2,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
	RC1 in out globalPkg.RCT1)
as
begin
    open RC1 for
    select  org_code
    from    dhl_organization
    where   nvl(dhl_capable,0) = nvl(Get_DhlOrgsByCapability.dhl_capable,0)
            and nvl(dhl_direct_capable,0) = nvl(Get_DhlOrgsByCapability.dhl_direct_capable,0)
            and ((dhl_direct_producer_name = Get_DhlOrgsByCapability.dhl_direct_producer_name) or ((dhl_direct_producer_name is null) and (Get_DhlOrgsByCapability.dhl_direct_producer_name is null)))
            and ((dhl_direct_service_url = Get_DhlOrgsByCapability.dhl_direct_service_url) or ((dhl_direct_service_url is null) and (Get_DhlOrgsByCapability.dhl_direct_service_url is null)))
            and ((xroad_service_instance = Get_DhlOrgsByCapability.xroad_service_instance) or ((xroad_service_instance is null) and (Get_DhlOrgsByCapability.xroad_service_instance is null)))
            and ((xroad_service_member_class = Get_DhlOrgsByCapability.xroad_service_member_class) or ((xroad_service_member_class is null) and (Get_DhlOrgsByCapability.xroad_service_member_class is null)))
            and ((xroad_service_member_code = Get_DhlOrgsByCapability.xroad_service_member_code) or ((xroad_service_member_code is null) and (Get_DhlOrgsByCapability.xroad_service_member_code is null)));
end;
/

create procedure Get_DhlMessageIDByGuid(
    dhl_message_id out number,
    dhl_guid in varchar2,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    is_incoming in number)
as
cnt number(38,0) := 0;
begin
    if Get_DhlMessageIDByGuid.is_incoming = 0 then
        select  max(m.dhl_message_id)
        into    Get_DhlMessageIDByGuid.dhl_message_id
        from    dhl_message m
        inner join
                dhl_message_recipient r on r.dhl_message_id = m.dhl_message_id
        where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
        		and nvl(r.xroad_service_instance,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_instance,'')
				and nvl(r.xroad_service_member_class,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_member_class,'')
				and nvl(r.xroad_service_member_code,'') = nvl(Get_DhlMessageIDByGuid.xroad_service_member_code,'')
                and nvl(r.producer_name,' ') = nvl(Get_DhlMessageIDByGuid.producer_name,' ')
                and nvl(r.service_url,' ') = nvl(Get_DhlMessageIDByGuid.service_url,' ')
                and m.is_incoming = 0;
    else
        select  count(*)
        into    cnt
        from    dhl_message m
        where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
                and m.is_incoming = Get_DhlMessageIDByGuid.is_incoming;

        if cnt > 0 then
            select  m.dhl_message_id
            into    Get_DhlMessageIDByGuid.dhl_message_id
            from    dhl_message m
            where   m.dhl_guid = Get_DhlMessageIDByGuid.dhl_guid
                    and m.is_incoming = 1;
        else
            Get_DhlMessageIDByGuid.dhl_message_id := 0;
        end if;
    end if;
    Get_DhlMessageIDByGuid.dhl_message_id := nvl(Get_DhlMessageIDByGuid.dhl_message_id, 0);
end;
/

create procedure Get_DhlMessageID(
    dhl_message_id out number,
    dhl_id in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    is_incoming in number)
as
cnt number(38,0) := 0;
begin
    if Get_DhlMessageID.is_incoming = 0 then
        select  max(r.dhl_message_id)
        into    Get_DhlMessageID.dhl_message_id
        from    dhl_message_recipient r
        inner join
                dhl_message m on m.dhl_message_id = r.dhl_message_id
        where   m.is_incoming = 0
                and r.dhl_id = Get_DhlMessageID.dhl_id
                and nvl(r.xroad_service_instance,'') = nvl(Get_DhlMessageID.xroad_service_instance,'')
				and nvl(r.xroad_service_member_class,'') = nvl(Get_DhlMessageID.xroad_service_member_class,'')
				and nvl(r.xroad_service_member_code,'') = nvl(Get_DhlMessageID.xroad_service_member_code,'')
                and nvl(r.producer_name,' ') = nvl(Get_DhlMessageID.producer_name,' ')
                and nvl(r.service_url,' ') = nvl(Get_DhlMessageID.service_url,' ');
    else
        select  count(*)
        into    cnt
        from    dhl_message m
        where   m.dhl_id = Get_DhlMessageID.dhl_id
                and m.is_incoming = Get_DhlMessageID.is_incoming;

        if cnt > 0 then
            select  m.dhl_message_id
            into    Get_DhlMessageID.dhl_message_id
            from    dhl_message m
            where   m.dhl_id = Get_DhlMessageID.dhl_id
                    and m.is_incoming = 1;
        else
		    Get_DhlMessageID.dhl_message_id := 0;
        end if;
    end if;
    Get_DhlMessageID.dhl_message_id := nvl(Get_DhlMessageID.dhl_message_id, 0);
end;
/

