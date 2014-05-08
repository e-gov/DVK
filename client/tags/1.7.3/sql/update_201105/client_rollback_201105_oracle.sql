----------------------------------------------------------------------
-- May 2011
-- Rollback DVK Client from version 1.6.2 to 1.6.1
----------------------------------------------------------------------

drop procedure Update_DhlMessageMetaData
/

create or replace
procedure Get_DhlMessageID(
    dhl_message_id out number,
    dhl_id in number,
    producer_name varchar2,
    service_url varchar2,
    is_incoming in number)
as
cnt number(38,0) := 0;
begin
    if Get_DhlMessageID.is_incoming = 0 then
        select  max(dhl_message_id)
        into    Get_DhlMessageID.dhl_message_id
        from    dhl_message_recipient
        where   dhl_id = Get_DhlMessageID.dhl_id
                and nvl(producer_name,' ') = nvl(Get_DhlMessageID.producer_name,' ')
                and nvl(service_url,' ') = nvl(Get_DhlMessageID.service_url,' ');
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

drop procedure Get_DhlOccupationList
/

drop procedure Get_DhlSubdivisionList
/

drop procedure Delete_DhlOccupation
/

drop procedure Delete_DhlSubdivision
/
