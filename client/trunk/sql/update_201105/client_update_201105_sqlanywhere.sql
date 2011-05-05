----------------------------------------------------------------------
-- May 2011
-- Update DVK Client from version 1.6.1 to 1.6.2
----------------------------------------------------------------------

drop procedure if exists "Update_DhlMessageMetaData";
create procedure "Update_DhlMessageMetaData"
(
	in _id int,
	in _is_incoming int,
	in _dhl_id int,
	in _title varchar(1000),
	in _sender_org_code varchar(20),
	in _sender_org_name varchar(100),
	in _sender_person_code varchar(20),
	in _sender_name varchar(100),
	in _recipient_org_code varchar(20),
	in _recipient_org_name varchar(100),
	in _recipient_person_code varchar(20),
	in _recipient_name varchar(100),
	in _case_name varchar(250),
	in _dhl_folder_name varchar(1000),
	in _sending_status_id int,
	in _unit_id int,
	in _sending_date datetime,
	in _received_date datetime,
	in _local_item_id int,
	in _recipient_status_id int,
	in _fault_code varchar(50),
	in _fault_actor varchar(250),
	in _fault_string varchar(500),
	in _fault_detail varchar(2000),
	in _status_update_needed int,
	in _metaxml long varchar,
	in _query_id varchar(50),
	in _proxy_org_code varchar(20),
	in _proxy_org_name varchar(100),
	in _proxy_person_code varchar(20),
	in _proxy_name varchar(100),
	in _recipient_department_nr varchar(100),
	in _recipient_department_name varchar(500),
	in _recipient_email varchar(100),
	in _recipient_division_id int,
	in _recipient_division_name varchar(100),
	in _recipient_position_id int,
	in _recipient_position_name varchar(100),
	in _recipient_division_code varchar(25),
	in _recipient_position_code varchar(25),
	in _dhl_guid varchar(36)
)
begin
    update	dhl_message
    set	    "is_incoming" = _is_incoming,
        	"dhl_id" = _dhl_id,
        	"title" = _title,
        	"sender_org_code" = _sender_org_code,
        	"sender_org_name" = _sender_org_name,
        	"sender_person_code" = _sender_person_code,
        	"sender_name" = _sender_name,
        	"recipient_org_code" = _recipient_org_code,
        	"recipient_org_name" = _recipient_org_name,
        	"recipient_person_code" = _recipient_person_code,
        	"recipient_name" = _recipient_name,
        	"case_name" = _case_name,
        	"dhl_folder_name" = _dhl_folder_name,
        	"sending_status_id" = _sending_status_id,
        	"unit_id" = _unit_id,
        	"sending_date" = _sending_date,
        	"received_date" = _received_date,
        	"local_item_id" = _local_item_id,
        	"recipient_status_id" = _recipient_status_id,
        	"fault_code" = _fault_code,
        	"fault_actor" = _fault_actor,
        	"fault_string" = _fault_string,
        	"fault_detail" = _fault_detail,
        	"status_update_needed" = _status_update_needed,
        	"metaxml" = _metaxml,
        	"query_id" = isnull(query_id,_query_id),
        	"proxy_org_code" = _proxy_org_code,
        	"proxy_org_name" = _proxy_org_name,
        	"proxy_person_code" = _proxy_person_code,
        	"proxy_name" = _proxy_name,
        	"recipient_department_nr" = _recipient_department_nr,
        	"recipient_department_name" = _recipient_department_name,
        	"recipient_email" = _recipient_email,
        	"recipient_division_id" = _recipient_division_id,
        	"recipient_division_name" = _recipient_division_name,
        	"recipient_position_id" = _recipient_position_id,
        	"recipient_position_name" = _recipient_position_name,
        	"recipient_division_code" = _recipient_division_code,
        	"recipient_position_code" = _recipient_position_code,
        	"dhl_guid" = _dhl_guid
    where	"dhl_message_id" = _id;
end;

drop procedure if exists "Get_DhlMessageID";
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
	    	select  max(r."dhl_message_id")
	    	from    dhl_message_recipient r
            inner join
                    dhl_message m on m."dhl_message_id" = r."dhl_message_id"
	    	where   m."is_incoming" = 0
	    	        and r."dhl_id" = _dhl_id
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

drop procedure if exists "Get_DhlOccupationList";
create procedure "Get_DhlOccupationList" ()
begin
    select	*
    from	dhl_occupation;
end;

drop procedure if exists "Get_DhlSubdivisionList";
create procedure "Get_DhlSubdivisionList" ()
begin
    select	*
    from	dhl_subdivision;
end;

drop procedure if exists "Delete_DhlOccupation";
create procedure "Delete_DhlOccupation"
(
	in _id int
)
begin
	delete
	from	dhl_occupation
	where	"occupation_code" = _id;
end;

drop procedure if exists "Delete_DhlSubdivision";
create procedure "Delete_DhlSubdivision"
(
	in _id int
)
begin
	delete
	from	dhl_subdivision
	where	"subdivision_code" = _id;
end;
