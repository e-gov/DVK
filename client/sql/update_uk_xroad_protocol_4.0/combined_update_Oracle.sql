ALTER TABLE dhl_settings
ADD xroad_client_instance VARCHAR2 (6),
ADD xroad_client_member_class VARCHAR2 (50),
ADD xroad_client_subsystem_code VARCHAR2 (50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance VARCHAR2 (6),
ADD xroad_service_member_class VARCHAR2 (50),
ADD xroad_service_member_code VARCHAR2 (50);

ALTER TABLE dhl_organization
ADD xroad_service_instance VARCHAR2 (6),
ADD xroad_service_member_class VARCHAR2 (50),
ADD xroad_service_member_code VARCHAR2 (50);


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

ALTER TABLE dhl_settings
ADD xroad_client_member_code VARCHAR2 (50);


create procedure Save_DhlMessageRecipient(
    dhl_message_recipient_id out number,
    dhl_message_id in number,
    recipient_org_code in varchar2,
    recipient_org_name in varchar2,
    recipient_person_code in varchar2,
    recipient_name in varchar2,
    sending_date date,
    received_date date,
    sending_status_id in number,
    recipient_status_id in number,
    fault_code in varchar2,
    fault_actor in varchar2,
    fault_string in varchar2,
    fault_detail in varchar2,
    metaxml clob,
    dhl_id in number,
    xroad_service_instance in varchar2,
    xroad_service_member_class in varchar2,
    xroad_service_member_code in varchar2,
    producer_name in varchar2,
    service_url in varchar2,
    recipient_division_id in number,
    recipient_division_name in varchar2,
    recipient_position_id in number,
    recipient_position_name in varchar2,
    recipient_division_code in varchar2,
    recipient_position_code in varchar2)
as
cnt number(10,0) := 0;
recipient_org_code_ varchar2(20) := nvl(Save_DhlMessageRecipient.recipient_org_code, ' ');
recipient_person_code_ varchar2(20) := nvl(Save_DhlMessageRecipient.recipient_person_code, ' ');
recipient_division_id_ number(38,0) := nvl(Save_DhlMessageRecipient.recipient_division_id, 0);
recipient_position_id_ number(38,0) := nvl(Save_DhlMessageRecipient.recipient_position_id, 0);
recipient_division_code_ varchar2(25) := nvl(Save_DhlMessageRecipient.recipient_division_code, ' ');
recipient_position_code_ varchar2(25) := nvl(Save_DhlMessageRecipient.recipient_position_code, ' ');
begin
    select  count(*)
    into    cnt
    from    dhl_message_recipient
    where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
            and recipient_org_code = recipient_org_code_
            and recipient_person_code = recipient_person_code_
            and recipient_division_id = recipient_division_id_
            and recipient_position_id = recipient_position_id_
            and recipient_division_code = recipient_division_code_
            and recipient_position_code = recipient_position_code_;

    if (cnt > 0) then
        update  dhl_message_recipient
        set     recipient_org_name = Save_DhlMessageRecipient.recipient_org_name,
                recipient_name = Save_DhlMessageRecipient.recipient_name,
                sending_date = Save_DhlMessageRecipient.sending_date,
                received_date = Save_DhlMessageRecipient.received_date,
                sending_status_id = Save_DhlMessageRecipient.sending_status_id,
                recipient_status_id = Save_DhlMessageRecipient.recipient_status_id,
                fault_code = Save_DhlMessageRecipient.fault_code,
                fault_actor = Save_DhlMessageRecipient.fault_actor,
                fault_string = Save_DhlMessageRecipient.fault_string,
                fault_detail = Save_DhlMessageRecipient.fault_detail,
                metaxml = Save_DhlMessageRecipient.metaxml,
                dhl_id = Save_DhlMessageRecipient.dhl_id,
                xroad_service_instance = Save_DhlMessageRecipient.xroad_service_instance,
                xroad_service_member_class = Save_DhlMessageRecipient.xroad_service_member_class,
                xroad_service_member_code = Save_DhlMessageRecipient.xroad_service_member_code,
                producer_name = Save_DhlMessageRecipient.producer_name,
                service_url = Save_DhlMessageRecipient.service_url,
                recipient_division_name = Save_DhlMessageRecipient.recipient_division_name,
                recipient_position_name = Save_DhlMessageRecipient.recipient_position_name
        where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;

        select    dhl_message_recipient_id
        into    Save_DhlMessageRecipient.dhl_message_recipient_id
        from    dhl_message_recipient
        where   dhl_message_id = Save_DhlMessageRecipient.dhl_message_id
                and recipient_org_code = recipient_org_code_
                and recipient_person_code = recipient_person_code_
                and recipient_division_id = recipient_division_id_
                and recipient_position_id = recipient_position_id_
                and recipient_division_code = recipient_division_code_
                and recipient_position_code = recipient_position_code_;
    else
        insert
        into    dhl_message_recipient(
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
                recipient_position_code,
                dhl_message_recipient_id)
        values  (Save_DhlMessageRecipient.dhl_message_id,
                recipient_org_code_,
                Save_DhlMessageRecipient.recipient_org_name,
                recipient_person_code_,
                Save_DhlMessageRecipient.recipient_name,
                Save_DhlMessageRecipient.sending_date,
                Save_DhlMessageRecipient.received_date,
                Save_DhlMessageRecipient.sending_status_id,
                Save_DhlMessageRecipient.recipient_status_id,
                Save_DhlMessageRecipient.fault_code,
                Save_DhlMessageRecipient.fault_actor,
                Save_DhlMessageRecipient.fault_string,
                Save_DhlMessageRecipient.fault_detail,
                Save_DhlMessageRecipient.metaxml,
                Save_DhlMessageRecipient.dhl_id,
                Save_DhlMessageRecipient.xroad_service_instance,
                Save_DhlMessageRecipient.xroad_service_member_class,
                Save_DhlMessageRecipient.xroad_service_member_code,
                Save_DhlMessageRecipient.producer_name,
                Save_DhlMessageRecipient.service_url,
                recipient_division_id_,
                Save_DhlMessageRecipient.recipient_division_name,
                recipient_position_id_,
                Save_DhlMessageRecipient.recipient_position_name,
                recipient_division_code_,
                recipient_position_code_,
                0);

        Save_DhlMessageRecipient.dhl_message_recipient_id := globalPkg.identity;
    end if;
end;
/

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



