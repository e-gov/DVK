----------------------------------------------------------------------
-- March 2014
-- Update DVK Client from version 1.6.2 to 1.6.3
----------------------------------------------------------------------

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--This string can get warning "The language already exists" on postgreSQL 9.x
--Nevertheless, works correctly
CREATE LANGUAGE plpgsql;

SET search_path = dvk, pg_catalog;

CREATE SEQUENCE sq_dhl_error_log_id_seq
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO MINVALUE
CACHE 1;

CREATE SEQUENCE sq_dhl_request_log_id_seq
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO MINVALUE
CACHE 1;

CREATE TABLE dhl_error_log
(
dhl_error_log_id integer DEFAULT nextval('sq_dhl_error_log_id_seq') NOT NULL,
error_datetime timestamp NOT NULL,
organization_code character varying(20),
user_code character varying(20),
action_name character varying(200),
error_message character varying(500) NOT NULL,
dhl_message_id integer
);

CREATE TABLE dhl_request_log
(
dhl_request_log_id integer DEFAULT nextval('sq_dhl_request_log_id_seq') NOT NULL,
request_datetime timestamp NOT NULL,
organization_code character varying(20) NOT NULL,
user_code character varying(20),
request_name character varying(100) NOT NULL,
response character varying(10),
dhl_error_log_id integer
);

ALTER TABLE dhl_error_log
    ADD CONSTRAINT PK_dhl_error_log PRIMARY KEY (dhl_error_log_id);

ALTER TABLE dhl_error_log
    ADD CONSTRAINT FK_dhl_message_id FOREIGN KEY (dhl_message_id) REFERENCES dhl_message(dhl_message_id);

ALTER TABLE dhl_error_log ADD CONSTRAINT UQ_dhl_error_log_id UNIQUE (dhl_error_log_id);

ALTER TABLE dhl_request_log
    ADD CONSTRAINT PK_dhl_request_log PRIMARY KEY (dhl_request_log_id);

ALTER TABLE dhl_request_log
    ADD CONSTRAINT FK_dhl_error_log_id FOREIGN KEY (dhl_error_log_id) REFERENCES dhl_error_log(dhl_error_log_id);

ALTER TABLE dhl_request_log ADD CONSTRAINT UQ_dhl_request_log_id UNIQUE (dhl_request_log_id);

create or replace
function "Add_DhlErrorLog"(
    p_dhl_error_log_id integer,
    p_error_datetime timestamp,
    p_organization_code character varying,
    p_user_code character varying,
    p_action_name character varying,
    p_error_message character varying,
    p_dhl_message_id integer
)
returns integer
as $$
declare
    p_id int4;
begin
    p_id:=nextval('sq_dhl_error_log_id_seq');

    insert
    into    dhl_error_log(
            dhl_error_log_id,
            error_datetime,
            organization_code,
            user_code,
            action_name,
            error_message,
            dhl_message_id)
    values  (p_id,
            p_error_datetime,
            p_organization_code,
            p_user_code,
            p_action_name,
            p_error_message,
            p_dhl_message_id);

    return  p_id;
end; $$
language plpgsql;

create or replace
function "Add_DhlRequestLog"(
    p_dhl_request_log_id integer,
    p_request_datetime timestamp,
    p_organization_code character varying,
    p_user_code character varying,
    p_request_name character varying,
    p_response character varying,
    p_dhl_error_log_id integer
)
returns integer
as $$
declare
    p_id int4;
begin
    p_id:=nextval('sq_dhl_request_log_id_seq');

    insert
    into    dhl_request_log(
            dhl_request_log_id,
            request_datetime,
            organization_code,
            user_code,
            request_name,
            response,
            dhl_error_log_id)
    values  (p_id,
            p_request_datetime,
            p_organization_code,
            p_user_code,
            p_request_name,
            p_response,
            p_dhl_error_log_id);

    return  p_id;
end; $$
language plpgsql;










