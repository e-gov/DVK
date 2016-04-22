----------------------------------------------------------------------
-- May 2011
-- Rollback DVK Client from version 1.6.2 to 1.6.1
----------------------------------------------------------------------

drop procedure "Update_DhlMessageMetaData";

drop procedure "Get_DhlMessageID";
create procedure "Get_DhlMessageID"
(
	in _dhl_id int,
	in _producer_name varchar(50),
	in _service_url varchar(100),
	in _is_incoming int,
	out _dhl_message_id int
)
begin
    if _is_incoming = 0 then
    	set	_dhl_message_id = isnull((
	    	select max("dhl_message_id")
	    	from	dhl_message_recipient
	    	where	"dhl_id" = _dhl_id
	        		and isnull("producer_name",'') = isnull(_producer_name,'')
	        		and isnull("service_url",'') = isnull(_service_url,'')
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

drop procedure "Get_DhlOccupationList";
drop procedure "Get_DhlSubdivisionList";
drop procedure "Delete_DhlOccupation";
drop procedure "Delete_DhlSubdivision";
