----------------------------------------------------------------------
-- March 2014
-- Update DVK Client from version 1.6.2 to 1.6.3
----------------------------------------------------------------------

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