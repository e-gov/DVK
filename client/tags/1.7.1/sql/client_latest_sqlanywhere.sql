--
-- NB!
-- Käivita skript selle kasutaja õigustes, kelle kasutajatunnustega
-- universaalklient hiljem andmebaasi poole hakkab pöörduma!
--
-- 
-- Lisaks käesolevale skriptile võib olla vajalik skripti
-- "sqlanywhere_install_jconnect_support.sql" käivitamine. Nimetatud
-- skript lisab andmebaasile jConnect JDBC draiveri jaoks vajaliku
-- metainfo.
-- Sama toiming on teostatav ka Sybase Central haldusliideses
-- "Upgrade database" toimingu koosseisus (ja on ka andmebaasi loomisel
-- vaikimisi valikuna määratud).
--



create table dhl_message
(
	"dhl_message_id" int not null primary key clustered identity,
	"is_incoming" int not null,
	"data" long varchar not null,
	"title" varchar(1000) null,
	"sender_org_code" varchar(20) null,
	"sender_org_name" varchar(100) null,
	"sender_person_code" varchar(20) null,
	"sender_name" varchar(100) null,
	"recipient_org_code" varchar(20) null,
	"recipient_org_name" varchar(100) null,
	"recipient_person_code" varchar(20) null,
	"recipient_name" varchar(100) null,
	"case_name" varchar(250) null,
	"dhl_folder_name" varchar(1000) null,
	"sending_status_id" int not null,
	"unit_id" int not null,
	"dhl_id" int null,
	"sending_date" datetime null,
	"received_date" datetime null,
	"local_item_id" int,
	"recipient_status_id" int,
	"fault_code" varchar(50) null,
	"fault_actor" varchar(250) null,
	"fault_string" varchar(500) null,
	"fault_detail" varchar(2000) null,
	"status_update_needed" int null,
	"metaxml" long varchar null,
	"query_id" varchar(50) null,
	"proxy_org_code" varchar(20) null,
	"proxy_org_name" varchar(100) null,
	"proxy_person_code" varchar(20) null,
	"proxy_name" varchar(100) null,
	"recipient_department_nr" varchar(100) null,
	"recipient_department_name" varchar(500) null,
	"recipient_email" varchar(100) null,
	"recipient_division_id" int null,
	"recipient_division_name" varchar(100) null,
	"recipient_position_id" int null,
	"recipient_position_name" varchar(100) null,
	"recipient_division_code" varchar(25) null,
	"recipient_position_code" varchar(25) null,
	"dhl_guid" varchar(36) null
);

create index ix_dhl_message_1 on dhl_message("unit_id");
create index ix_dhl_message_2 on dhl_message("dhl_id");
create index ix_dhl_message_3 on dhl_message("sending_status_id");

create table dhl_message_recipient
(
	"dhl_message_id" int not null,
	"recipient_org_code" varchar(20) not null,
	"recipient_org_name" varchar(100) null,
	"recipient_person_code" varchar(20) not null,
	"recipient_name" varchar(100) null,
	"sending_date" datetime null,
	"received_date" datetime null,
	"sending_status_id" int not null,
	"recipient_status_id" int null,
	"fault_code" varchar(50) null,
	"fault_actor" varchar(250) null,
	"fault_string" varchar(500) null,
	"fault_detail" varchar(2000) null,
	"metaxml" long varchar null,
	"dhl_id" int null,
	"query_id" varchar(50) null,
	"producer_name" varchar(50) null,
	"service_url" varchar(100) null,
	"recipient_division_id" int not null default 0,
	"recipient_division_name" varchar(100) null,
	"recipient_position_id" int not null default 0,
	"recipient_position_name" varchar(100) null,
	"recipient_division_code" varchar(25) not null default(''),
	"recipient_position_code" varchar(25) not null default(''),
	"dhl_message_recipient_id" int not null primary key clustered identity
);

alter table dhl_message_recipient
add constraint UN_dhl_message_recipient
unique ("dhl_message_id", "recipient_org_code", "recipient_person_code", "recipient_division_id", "recipient_position_id", "recipient_division_code", "recipient_position_code");

alter table dhl_message_recipient
add constraint fk_dhl_message_recipient_1
foreign key ("dhl_message_id")
references dhl_message ("dhl_message_id")
on delete cascade;

create table dhl_settings
(
	"id" int not null primary key clustered,
	"institution_code" varchar(20) not null,
	"institution_name" varchar(250) not null,
	"personal_id_code" varchar(20)not null,
	"unit_id" int not null,
	"subdivision_code" int null,
	"occupation_code" int null,
	"subdivision_short_name" varchar(25) null,
	"occupation_short_name" varchar(25) null,
	"subdivision_name" varchar(250) null,
	"occupation_name" varchar(250) null,
	"container_version" int null
);

create unique index ix_dhl_settings_1 on dhl_settings("unit_id");

create table dhl_organization
(
	"org_code" varchar(20) not null primary key,
	"org_name" varchar(100) not null,
	"dhl_capable" int not null default 0,
	"dhl_direct_capable" int not null default 0,
	"dhl_direct_producer_name" varchar(50),
	"dhl_direct_service_url" varchar(100),
	"parent_org_code" varchar(20) null
);

create table dhl_settings_folders
(
	"id" int not null primary key clustered identity,
	"dhl_settings_id" int not null,
	"folder_name" varchar(4000) null
);

alter table dhl_settings_folders
add constraint FK_dhl_settings_folders
foreign key ("dhl_settings_id")
references dhl_settings ("id")
on update cascade
on delete cascade;

create table dhl_counter
(
	"dhl_id" int null
);

insert into dhl_counter("dhl_id") values(0);

create table dhl_occupation
(
	"occupation_code" int not null primary key,
	"occupation_name" varchar(100) not null,
	"org_code" varchar(20) not null,
	"occupation_short_name" varchar(25) null,
	"parent_subdivision_short_name" varchar(25) null
);

create table dhl_subdivision
(
	"subdivision_code" int not null primary key,
	"subdivision_name" varchar(100) not null,
	"org_code" varchar(20) not null,
	"subdivision_short_name" varchar(25) null,
	"parent_subdivision_short_name" varchar(25) null
);

create table dhl_classifier
(
	"dhl_classifier_code" varchar(20) not null primary key,
	"dhl_classifier_id" int not null
);

if not exists (select * from "dhl_classifier" where "dhl_classifier_code"='STATUS_WAITING') then
	insert into "dhl_classifier"("dhl_classifier_code","dhl_classifier_id") values('STATUS_WAITING', 1);
end if;
if not exists (select * from "dhl_classifier" where "dhl_classifier_code"='STATUS_SENDING') then
	insert into "dhl_classifier"("dhl_classifier_code","dhl_classifier_id") values('STATUS_SENDING', 2);
end if;
if not exists (select * from "dhl_classifier" where "dhl_classifier_code"='STATUS_SENT') then
	insert into "dhl_classifier"("dhl_classifier_code","dhl_classifier_id") values('STATUS_SENT', 3);
end if;
if not exists (select * from "dhl_classifier" where "dhl_classifier_code"='STATUS_CANCELED') then
	insert into "dhl_classifier"("dhl_classifier_code","dhl_classifier_id") values('STATUS_CANCELED', 4);
end if;
if not exists (select * from "dhl_classifier" where "dhl_classifier_code"='STATUS_RECEIVED') then
	insert into "dhl_classifier"("dhl_classifier_code","dhl_classifier_id") values('STATUS_RECEIVED', 5);
end if;

create table "dhl_status_history"
(
    "dhl_status_history_id" int not null primary key identity,
	"server_side_id" int not null,
    "dhl_message_recipient_id" int not null,
    "sending_status_id" int not null,
    "status_date" datetime null,
    "fault_code" varchar(50) null,
    "fault_actor" varchar(250) null,
    "fault_string" varchar(500) null,
    "fault_detail" varchar(2000) null,
    "recipient_status_id" int null,
    "metaxml" long varchar null
);

alter table "dhl_status_history"
add constraint "fk_dhl_status_history_1"
foreign key ("dhl_message_recipient_id")
references "dhl_message_recipient" ("dhl_message_recipient_id")
on delete cascade;









create procedure "Save_DhlOrganization"
(
	in _org_code varchar(20),
	in _org_name varchar(100),
	in _is_dhl_capable int,
	in _is_dhl_direct_capable int,
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
    		    "dhl_direct_producer_name",
    		    "dhl_direct_service_url",
    		    "parent_org_code")
    	values	(_org_code,
        		_org_name,
        		_is_dhl_capable,
        		_is_dhl_direct_capable,
        		_dhl_direct_producer_name,
        		_dhl_direct_service_url,
        		_parent_org_code);
    else
    	update	dhl_organization
    	set     "org_name" = _org_name,
        		"dhl_capable" = _is_dhl_capable,
        		"dhl_direct_capable" = _is_dhl_direct_capable,
        		"dhl_direct_producer_name" = _dhl_direct_producer_name,
        		"dhl_direct_service_url" = _dhl_direct_service_url,
        		"parent_org_code" = _parent_org_code
    	where	"org_code" = _org_code;
    end if;
end;

create procedure "Get_DhlMessages"
(
	in _incoming int,
	in _status_id int,
	in _unit_id int,
	in _status_update_needed int,
	in _metadata_only int
)
begin
    select  "dhl_message_id",
    	    "is_incoming",
        	(case _metadata_only when 0 then "data" else null end) as "data",
        	"title",
        	"sender_org_code",
        	"sender_org_name",
        	"sender_person_code",
        	"sender_name",
        	"recipient_org_code",
        	"recipient_org_name",
        	"recipient_person_code",
        	"recipient_name",
        	"case_name",
        	"dhl_folder_name",
        	"sending_status_id",
        	"unit_id",
        	"dhl_id",
        	"sending_date",
        	"received_date",
        	"local_item_id",
        	"recipient_status_id",
        	"fault_code",
        	"fault_actor",
        	"fault_string",
        	"fault_detail",
        	"status_update_needed",
        	"metaxml",
        	"query_id",
        	"proxy_org_code",
        	"proxy_org_name",
        	"proxy_person_code",
        	"proxy_name",
        	"recipient_department_nr",
        	"recipient_department_name",
        	"recipient_email",
        	"recipient_division_id",
        	"recipient_division_code",
        	"recipient_division_name",
        	"recipient_position_id",
        	"recipient_position_code",
        	"recipient_position_name",
        	"dhl_guid"
    from	dhl_message
    where	"is_incoming" = _incoming
        	and
        	(
        		"sending_status_id" = _status_id
        		or _status_id is null
        	)
        	and "unit_id" = _unit_id
        	and
        	(
        		_status_update_needed <> 1
        		or "status_update_needed" = 1
        	)
end;

create procedure "Add_DhlMessage"
(
	in _is_incoming int,
	in _data long varchar,
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
	in _dhl_guid varchar(36),
	out _id int
)
begin
    if _is_incoming is null then
    	set _is_incoming = 0;
    end if;
    
    insert
    into	dhl_message(
        	"is_incoming",
        	"data",
        	"dhl_id",
        	"title",
        	"sender_org_code",
        	"sender_org_name",
        	"sender_person_code",
        	"sender_name",
        	"recipient_org_code",
        	"recipient_org_name",
        	"recipient_person_code",
        	"recipient_name",
        	"case_name",
        	"dhl_folder_name",
        	"sending_status_id",
        	"unit_id",
        	"sending_date",
        	"received_date",
        	"local_item_id",
        	"recipient_status_id",
        	"fault_code",
        	"fault_actor",
        	"fault_string",
        	"fault_detail",
        	"status_update_needed",
        	"metaxml",
        	"query_id",
        	"proxy_org_code",
        	"proxy_org_name",
        	"proxy_person_code",
        	"proxy_name",
        	"recipient_department_nr",
        	"recipient_department_name",
        	"recipient_email",
        	"recipient_division_id",
        	"recipient_division_name",
        	"recipient_position_id",
        	"recipient_position_name",
        	"recipient_division_code",
        	"recipient_position_code",
        	"dhl_guid")
    VALUES	(_is_incoming,
        	_data,
        	_dhl_id,
        	_title,
        	_sender_org_code,
        	_sender_org_name,
        	_sender_person_code,
        	_sender_name,
        	_recipient_org_code,
        	_recipient_org_name,
        	_recipient_person_code,
        	_recipient_name,
        	_case_name,
        	_dhl_folder_name,
        	_sending_status_id,
        	_unit_id,
        	_sending_date,
        	_received_date,
        	_local_item_id,
        	_recipient_status_id,
        	_fault_code,
        	_fault_actor,
        	_fault_string,
        	_fault_detail,
        	_status_update_needed,
        	_metaxml,
        	_query_id,
        	_proxy_org_code,
        	_proxy_org_name,
        	_proxy_person_code,
        	_proxy_name,
        	_recipient_department_nr,
        	_recipient_department_name,
        	_recipient_email,
        	_recipient_division_id,
        	_recipient_division_name,
        	_recipient_position_id,
        	_recipient_position_name,
        	_recipient_division_code,
        	_recipient_position_code,
        	_dhl_guid);
    
    set _id = @@identity;
end;

create procedure "Update_DhlMessage"
(
	in _id int,
	in _is_incoming int,
	in _data long varchar,
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
        	"data" = _data,
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

create procedure "Update_DhlMessageDhlID"
(
	in _id int,
	in _dhl_id int,
	in _query_id varchar(50),
	in _dhl_guid varchar(36)
)
begin
    update	dhl_message
    set		"dhl_id" = _dhl_id,
    		"query_id" = isnull(query_id, _query_id),
    		"dhl_guid" = isnull(dhl_guid, _dhl_guid)
    where	"dhl_message_id" = _id;
end;

create procedure "Update_DhlMsgStatusUpdateNeed"
(
	in _message_id int,
	in _status_update_needed int
)
begin
    update	dhl_message
    set 	"status_update_needed" = _status_update_needed
    where	"dhl_message_id" = _message_id;
end;

create procedure "Get_DhlMessageRecipients"
(
	in _message_id int
)
begin
    select	r.*
    from	dhl_message_recipient r
    where	r."dhl_message_id" = _message_id;
end;

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

create procedure "Get_DhlSettings" ()
begin
    select	*
    from	dhl_settings;
end;

create procedure "Get_DhlSettingFolders"
(
	in _dhl_settings_id int
)
begin
    select	folder_name
    from	dhl_settings_folders
    where	"dhl_settings_id" = _dhl_settings_id;
end;

create procedure "Update_DhlMessageRecipDhlID"
(
	in _dhl_message_id int,
	in _dhl_direct_capable int,
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
        	"producer_name" = _dhl_direct_producer_name,
        	"service_url" = _dhl_direct_service_url
    where	"dhl_message_id" = _dhl_message_id 
        	and "recipient_org_code" in
        	(
        		select	"org_code"
        		from	dhl_organization
        		where	isnull("dhl_direct_capable",1) = isnull(_dhl_direct_capable,1)
        				and isnull("dhl_direct_producer_name",'') = isnull(_dhl_direct_producer_name,'')
        				and isnull("dhl_direct_service_url",'')= isnull(_dhl_direct_service_url,'')
        	);
end;

create procedure "Get_DhlMessagesByDhlID"
(
	in _dhl_id int,
	in _incoming int,
	in _metadata_only int
)
begin
    select	"dhl_message_id",
        	"is_incoming",
        	(case _metadata_only when 0 then "data" else null end) as "data",
        	"title",
        	"sender_org_code",
        	"sender_org_name",
        	"sender_person_code",
        	"sender_name",
        	"recipient_org_code",
        	"recipient_org_name",
        	"recipient_person_code",
        	"recipient_name",
        	"case_name",
        	"dhl_folder_name",
        	"sending_status_id",
        	"unit_id",
        	"dhl_id",
        	"sending_date",
        	"received_date",
        	"local_item_id",
        	"recipient_status_id",
        	"fault_code",
        	"fault_actor",
        	"fault_string",
        	"fault_detail",
        	"status_update_needed",
        	"metaxml",
        	"query_id",
        	"proxy_org_code",
        	"proxy_org_name",
        	"proxy_person_code",
        	"proxy_name",
        	"recipient_department_nr",
        	"recipient_department_name",
        	"recipient_email",
        	"recipient_division_id",
        	"recipient_division_name",
        	"recipient_position_id",
        	"recipient_position_name",
        	"recipient_division_code",
        	"recipient_position_code",
        	"dhl_guid"
    from	dhl_message
    where	"is_incoming" = _incoming
    	    and "dhl_id" = _dhl_id;
end;

create procedure "Get_AsutusStat"
(
	in _asutus_id int,
	out _vahetatud_dokumente int
)
begin
    set	_vahetatud_dokumente = isnull((
	    select	count(*)
	    from	dhl_message
	    where	"unit_id" = _asutus_id
    ),0);
end;

create procedure "Get_DhlCapabilityByMessageID"
(
	in _dhl_message_id int
)
begin
    select  distinct
        	o."dhl_capable",
        	o."dhl_direct_capable",
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
	in _dhl_direct_service_url varchar(100)
)
begin
    select	"org_code"
    from	dhl_organization
    where	isnull("dhl_capable",0) = isnull(_dhl_capable,0)
        	and isnull("dhl_direct_capable",0) = isnull(_dhl_direct_capable,0)
        	and isnull("dhl_direct_producer_name",'') = isnull(_dhl_direct_producer_name,'')
        	and isnull("dhl_direct_service_url",'') = isnull(_dhl_direct_service_url,'');
end;

create procedure "Get_NextDhlID"
(
	out _dhl_id int
)
begin
    update	dhl_counter
    set     dhl_id = isnull(dhl_id,0) + 1;
    
    set	_dhl_id = isnull((
	    select	dhl_id
	    from	dhl_counter
    ),0);
end;

create procedure "Update_DhlMessageStatus"
(
	in _dhl_message_id int,
	in _status_id int,
	in _status_update_needed int,
	in _received_date datetime,
	in _sending_date datetime
)
begin
    update	dhl_message
    set     "sending_status_id" = _status_id,
        	"status_update_needed" = _status_update_needed,
        	"received_date" = isnull("received_date", _received_date),
        	"sending_date" = isnull("sending_date", _sending_date)
    where	"dhl_message_id" = _dhl_message_id;
end;

create procedure "Get_DhlCapability"
(
	in _org_code varchar(20)
)
begin
    select	*
    from	dhl_organization
    where	"org_code" = _org_code;
end;

create procedure "Save_DhlSubdivision"
(
	in _id int,
	in _name varchar(100),
	in _org_code varchar(20),
	in _short_name varchar(25),
	in _parent_subdivision_short_name varchar(25)
)
begin
    if not exists (select * from dhl_subdivision where "subdivision_code" = _id) then
    	insert
    	into	dhl_subdivision(
        		"subdivision_code",
        		"subdivision_name",
        		"org_code",
        		"subdivision_short_name",
        		"parent_subdivision_short_name")
    	values	(_id,
        		_name,
        		_org_code,
        		_short_name,
        		_parent_subdivision_short_name);
    else
    	update	dhl_subdivision
    	set     "subdivision_name" = _name,
        		"org_code" = _org_code,
        		"subdivision_short_name" = _short_name,
        		"parent_subdivision_short_name" = _parent_subdivision_short_name
    	where	"subdivision_code" = _id;
    end if;
end;

create procedure "Save_DhlOccupation"
(
	in _id int,
	in _name varchar(100),
	in _org_code varchar(20),
	in _short_name varchar(25),
	in _parent_subdivision_short_name varchar(25)
)
begin
    if not exists (select * from dhl_occupation where "occupation_code" = _id) then
    	insert
    	into	dhl_occupation(
        		"occupation_code",
        		"occupation_name",
        		"org_code",
        		"occupation_short_name",
        		"parent_subdivision_short_name")
    	values	(_id,
        		_name,
        		_org_code,
        		_short_name,
        		_parent_subdivision_short_name);
    else
    	update	dhl_occupation
    	set     "occupation_name" = _name,
        		"org_code" = _org_code,
        		"occupation_short_name" = _short_name,
        		"parent_subdivision_short_name" = _parent_subdivision_short_name
    	where	"occupation_code" = _id;
    end if;
end;

create procedure "Get_DhlCapabilityList" ()
begin
    select	*
    from	dhl_organization;
end;

create procedure "Get_DhlClassifierList" ()
begin
	select	*
	from	dhl_classifier;
end;

create procedure "Get_DhlClassifier"
(
	in _code varchar(20)
)
begin
	select	*
	from	dhl_classifier
	where	"dhl_classifier_code" = _code;
end;

create procedure "Save_DhlClassifier"
(
	in _code varchar(20),
	in _id int
)
begin
	if not exists (select * from dhl_classifier where "dhl_classifier_code" = _code) then
		insert into dhl_classifier("dhl_classifier_code", "dhl_classifier_id")
		values (_code, _id);
	else
		update	dhl_classifier
		set		"dhl_classifier_id" = _id
		where	"dhl_classifier_code" = _code;
    end if;
end;

create procedure "Get_DhlMessageByID"
(
	in _id int,
	in _metadata_only int
)
begin
    select	"dhl_message_id",
        	"is_incoming",
        	(case _metadata_only when 0 then "data" else null end) as "data",
        	"title",
        	"sender_org_code",
        	"sender_org_name",
        	"sender_person_code",
        	"sender_name",
        	"recipient_org_code",
        	"recipient_org_name",
        	"recipient_person_code",
        	"recipient_name",
        	"case_name",
        	"dhl_folder_name",
        	"sending_status_id",
        	"unit_id",
        	"dhl_id",
        	"sending_date",
        	"received_date",
        	"local_item_id",
        	"recipient_status_id",
        	"fault_code",
        	"fault_actor",
        	"fault_string",
        	"fault_detail",
        	"status_update_needed",
        	"metaxml",
        	"query_id",
        	"proxy_org_code",
        	"proxy_org_name",
        	"proxy_person_code",
        	"proxy_name",
        	"recipient_department_nr",
        	"recipient_department_name",
        	"recipient_email",
        	"recipient_division_id",
        	"recipient_division_name",
        	"recipient_position_id",
        	"recipient_position_name"
    from	dhl_message
    where	"dhl_message_id" = _id;
end;

create procedure "Get_DhlMessageIDByGuid"
(
	in _dhl_guid varchar(36),
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

create procedure "Get_DhlMessageRecipientId"
(
	in _dhl_message_id int,
	in _recipient_org_code varchar(20),
	in _recipient_person_code varchar(20),
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
    if _recipient_division_code is null then
    	set _recipient_division_code = '';
    end if;
    if _recipient_position_code is null then
    	set _recipient_position_code = '';
    end if;
    
    set	_dhl_message_recipient_id = isnull((
	    select	"dhl_message_recipient_id"
	    from	dhl_message_recipient
	    where	"dhl_message_id" = _dhl_message_id
	    		and "recipient_org_code" = _recipient_org_code
	    		and "recipient_person_code" = _recipient_person_code
	    		and "recipient_division_code" = _recipient_division_code
	    		and "recipient_position_code" = _recipient_position_code
    ),0);
end;

create procedure "Save_DhlStatusHistory"
(
	in _dhl_message_recipient_id int,
	in _server_side_id int,
	in _sending_status_id int,
	in _status_date datetime,
	in _fault_code varchar(50),
	in _fault_actor varchar(250),
	in _fault_string varchar(500),
	in _fault_detail varchar(2000),
	in _recipient_status_id int,
	in _metaxml long varchar,
	out _dhl_status_history_id int
)
begin
    set _dhl_status_history_id = null;
    
    set	_dhl_status_history_id = (
	    select	"dhl_status_history_id"
	    from	"dhl_status_history"
	    where	"dhl_message_recipient_id" = _dhl_message_recipient_id
	    		and "server_side_id" = _server_side_id
    );
    
    if _dhl_status_history_id is null then
    	insert
    	into	"dhl_status_history"(
    			"dhl_message_recipient_id",
    			"server_side_id",
    			"sending_status_id",
    			"status_date",
    			"fault_code",
    			"fault_actor",
    			"fault_string",
    			"fault_detail",
    			"recipient_status_id",
    			"metaxml")
    	values	(_dhl_message_recipient_id,
    			_server_side_id,
    			_sending_status_id,
    			_status_date,
    			_fault_code,
    			_fault_actor,
    			_fault_string,
    			_fault_detail,
    			_recipient_status_id,
    			_metaxml);

    	set _dhl_status_history_id = @@identity;
    end if;
end;

create procedure "Get_DhlMessageByGUID"
(
    in _guid varchar(36),
    in _metadata_only int
)
begin
    select  "dhl_message_id",
            "is_incoming",
            (case _metadata_only when 0 then "data" else null end) as "data",
            "title",
            "sender_org_code",
            "sender_org_name",
            "sender_person_code",
            "sender_name",
            "recipient_org_code",
            "recipient_org_name",
            "recipient_person_code",
            "recipient_name",
            "case_name",
            "dhl_folder_name",
            "sending_status_id",
            "unit_id",
            "dhl_id",
            "sending_date",
            "received_date",
            "local_item_id",
            "recipient_status_id",
            "fault_code",
            "fault_actor",
            "fault_string",
            "fault_detail",
            "status_update_needed",
            "metaxml",
            "query_id",
            "proxy_org_code",
            "proxy_org_name",
            "proxy_person_code",
            "proxy_name",
            "recipient_department_nr",
            "recipient_department_name",
            "recipient_email",
            "recipient_division_id",
            "recipient_division_name",
            "recipient_position_id",
            "recipient_position_name",
            "recipient_division_code",
            "recipient_position_code",
            "dhl_guid"
    from    dhl_message
    where   "dhl_guid" = _guid;
end;

create procedure "Delete_OldDhlMessages"
(
	in _doc_lifetime_days int,
	out _deleted_doc_count int
)
begin
    set _deleted_doc_count = 0;
	if (_doc_lifetime_days is not null) and (_doc_lifetime_days > 0) then
		-- Delete old received documents
		delete
		from	dhl_message
		where	"is_incoming" = 1
				and datediff(day, "received_date", getdate()) >= _doc_lifetime_days;
		set _deleted_doc_count = _deleted_doc_count + @@rowcount;
				
		-- Delete old sent documents
		delete
		from	dhl_message
		where	"is_incoming" = 0
				and datediff(day, "sending_date", getdate()) >= _doc_lifetime_days;
		set _deleted_doc_count = _deleted_doc_count + @@rowcount;
	end if;
end;

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

create procedure "Get_DhlOccupationList" ()
begin
    select	*
    from	dhl_occupation;
end;

create procedure "Get_DhlSubdivisionList" ()
begin
    select	*
    from	dhl_subdivision;
end;

create procedure "Delete_DhlOccupation"
(
	in _id int
)
begin
	delete
	from	dhl_occupation
	where	"occupation_code" = _id;
end;

create procedure "Delete_DhlSubdivision"
(
	in _id int
)
begin
	delete
	from	dhl_subdivision
	where	"subdivision_code" = _id;
end;

create table dhl_error_log
(
	"dhl_error_log_id" int not null primary key clustered identity,
	"error_datetime" datetime not null,
	"organization_code" varchar(20) null,
	"user_code" varchar(20) null,
	"action_name" varchar(200) null,
	"error_message" varchar(500) null,
	"dhl_message_id" int null
);

create table dhl_request_log
(
	"dhl_request_log_id" int not null primary key clustered identity,
	"request_datetime" datetime not null,
	"organization_code" varchar(20) not null,
	"user_code" varchar(20) null,
	"request_name" varchar(100) not null,
	"response" varchar(10) null,
	"dhl_error_log_id" int null
);

alter table dhl_error_log
add constraint UQ_dhl_error_log_id
unique ("dhl_error_log_id");

alter table dhl_error_log
add constraint FK_dhl_message_id
foreign key ("dhl_message_id")
references dhl_message ("dhl_message_id");

alter table dhl_request_log
add constraint UQ_dhl_request_log_id
unique ("dhl_request_log_id");

alter table dhl_request_log
add constraint FK_dhl_error_log_id
foreign key ("dhl_error_log_id")
references dhl_error_log ("dhl_error_log_id");

create procedure "Add_DhlErrorLog"
(
	in _error_datetime datetime,
	in _org_code varchar(20),
	in _user_code varchar(20),
	in _action_name varchar(200),
	in _error_message varchar(500),
	in _dhl_message_id int,
	out _id int
)
begin
        insert
    	into	dhl_error_log(
    		    "error_datetime",
    		    "organization_code",
    		    "user_code",
    		    "action_name",
    		    "error_message",
    		    "dhl_message_id")
    	values	(_error_datetime,
        		_org_code,
        		_user_code,
        		_action_name,
        		_error_message,
        		_dhl_message_id);
        set _id = @@identity;
end;

create procedure "Add_DhlRequestLog"
(
	in _request_datetime datetime,
	in _org_code varchar(20),
	in _user_code varchar(20),
	in _request_name varchar(100),
	in _response varchar(10),
	in _dhl_error_log_id int,
	out _id int
)
begin
        insert
    	into	dhl_request_log(
    		    "request_datetime",
    		    "organization_code",
    		    "user_code",
    		    "request_name",
    		    "response",
    		    "dhl_error_log_id")
    	values	(_request_datetime,
        		_org_code,
        		_user_code,
        		_request_name,
        		_response,
        		_dhl_error_log_id);
        set _id = @@identity;
end;