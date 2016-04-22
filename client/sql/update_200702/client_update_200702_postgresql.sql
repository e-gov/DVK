SET search_path = dvk, pg_catalog;

CREATE TABLE dhl_message_recipient (
    dhl_message_id integer NOT NULL,
    recipient_org_code character varying(20) NOT NULL,
    recipient_org_name character varying(100),
    recipient_person_code character varying(20) NOT NULL,
    recipient_name character varying(100),
    sending_date date,
    received_date date,
    sending_status_id integer not null,
    recipient_status_id integer,
    fault_code character varying(50),
    fault_actor character varying(250),
    fault_string character varying(500),
    fault_detail character varying(2000),
    metaxml text
);

ALTER TABLE ONLY dhl_message_recipient
    ADD CONSTRAINT dhl_message_recipient_pkey PRIMARY KEY(dhl_message_id, recipient_org_code, recipient_person_code);

ALTER TABLE dhl_message_recipient
    ADD CONSTRAINT fk_dhl_message_recipient_1 FOREIGN KEY (dhl_message_id) REFERENCES dhl_message (dhl_message_id) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE ONLY dhl_message
    DROP COLUMN error_message;

ALTER TABLE ONLY dhl_message
    ADD COLUMN recipient_status_id integer,
    ADD COLUMN fault_code character varying(50),
    ADD COLUMN fault_actor character varying(250),
    ADD COLUMN fault_string character varying(500),
    ADD COLUMN fault_detail character varying(2000),
    ADD COLUMN status_update_needed boolean,
    ADD COLUMN metaxml text;

CREATE OR REPLACE
FUNCTION "Add_DhlMessage"(
    p_is_incoming integer,
    p_data text,
    p_dhl_id integer,
    p_title character varying,
    p_sender_org_code character varying,
    p_sender_org_name character varying,
    p_sender_person_code character varying,
    p_sender_name character varying,
    p_recipient_org_code character varying,
    p_recipient_org_name character varying,
    p_recipient_person_code character varying,
    p_recipient_name character varying,
    p_case_name character varying,
    p_dhl_folder_name character varying,
    p_sending_status_id integer,
    p_unit_id integer,
    p_sending_date timestamp with time zone,
    p_received_date timestamp with time zone,
    p_local_item_id integer,
    p_recipient_status_id integer,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_status_update_needed boolean,
    p_metaxml text)
RETURNS integer
    AS $$
DECLARE
    p_id int4;
    is_incoming_ int2 := p_is_incoming;
BEGIN
    if is_incoming_ is null then
        is_incoming_ := 0;
    end if;
    p_id:=nextval('dvk.sq_dhl_message_id');

    insert
    into    dhl_message(
            dhl_message_id,
            is_incoming,
            data,
            dhl_id,
            title,
            sender_org_code,
            sender_org_name,
            sender_person_code,
            sender_name,
            recipient_org_code,
            recipient_org_name,
            recipient_person_code,
            recipient_name,
            case_name,
            dhl_folder_name,
            sending_status_id,
            unit_id,
            sending_date,
            received_date,
            local_item_id,
            recipient_status_id,
            fault_code,
            fault_actor,
            fault_string,
            fault_detail,
            status_update_needed,
            metaxml)
    values  (p_id,
            is_incoming_,
            p_data,
            p_dhl_id,
            p_title,
            p_sender_org_code,
            p_sender_org_name,
            p_sender_person_code,
            p_sender_name,
            p_recipient_org_code,
            p_recipient_org_name,
            p_recipient_person_code,
            p_recipient_name,
            p_case_name,
            p_dhl_folder_name,
            p_sending_status_id,
            p_unit_id,
            p_sending_date,
            p_received_date,
            p_local_item_id,
            p_recipient_status_id,
            p_fault_code,
            p_fault_actor,
            p_fault_string,
            p_fault_detail,
            p_status_update_needed,
            p_metaxml);

    RETURN p_id;
END;$$
	LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Update_DhlMessage"(
    p_id integer,
    p_is_incoming integer,
    p_data text,
    p_dhl_id integer,
    p_title character varying,
    p_sender_org_code character varying,
    p_sender_org_name character varying,
    p_sender_person_code character varying,
    p_sender_name character varying,
    p_recipient_org_code character varying,
    p_recipient_org_name character varying,
    p_recipient_person_code character varying,
    p_recipient_name character varying,
    p_case_name character varying,
    p_dhl_folder_name character varying,
    p_sending_status_id integer,
    p_unit_id integer,
    p_sending_date timestamp with time zone,
    p_received_date timestamp with time zone,
    p_local_item_id integer,
    p_recipient_status_id integer,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_status_update_needed boolean,
    p_metaxml text)
RETURNS boolean
AS $$
BEGIN
    update  dhl_message
    set     is_incoming = p_is_incoming,
            data = p_data,
            dhl_id = p_dhl_id,
            title = p_title,
            sender_org_code = p_sender_org_code,
            sender_org_name = p_sender_org_name,
            sender_person_code = p_sender_person_code,
            sender_name = p_sender_name,
            recipient_org_code = p_recipient_org_code,
            recipient_org_name = p_recipient_org_name,
            recipient_person_code = p_recipient_person_code,
            recipient_name = p_recipient_name,
            case_name = p_case_name,
            dhl_folder_name = p_dhl_folder_name,
            sending_status_id = p_sending_status_id,
            unit_id = p_unit_id,
            sending_date = p_sending_date,
            received_date = p_received_date,
            local_item_id = p_local_item_id,
            recipient_status_id = p_recipient_status_id,
            fault_code = p_fault_code,
            fault_actor = p_fault_actor,
            fault_string = p_fault_string,
            fault_detail = p_fault_detail,
            status_update_needed = p_status_update_needed,
            metaxml = p_metaxml
    where   dhl_message_id = p_id;
    return  FOUND;
END; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Get_DhlMessages"(
    p_incoming integer,
    p_status_id integer,
    p_unit_id integer,
    p_status_update_needed boolean)
RETURNS refcursor
AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dhl_message
    where   is_incoming = p_incoming
            and
            (
                sending_status_id = p_status_id
                or p_status_id is null
            )
            and unit_id = p_unit_id
            and
            (
                p_status_update_needed <> 1
                or status_update_needed = true
            );
    RETURN  RC1;
end; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Update_DhlMsgStatusUpdateNeed"(p_message_id integer, p_status_update_needed boolean) RETURNS boolean
AS $$
BEGIN
    if (p_status_update_needed = 1) then
        update  dhl_message
        set     status_update_needed = true
        where   dhl_message_id = p_message_id;
    else
        update  dhl_message
        set     status_update_needed = null
        where   dhl_message_id = p_message_id;
    end if;
    RETURN  FOUND;
END; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Get_DhlMessageRecipients"(p_message_id integer) RETURNS refcursor
AS $$
DECLARE
    RC1 refcursor;
BEGIN
    open RC1 for
    select  *
    from    dhl_message_recipient
    where   dhl_message_id = p_message_id;
    RETURN  RC1;
END; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Get_DhlMessageID"(dhl_id integer, is_incoming integer) RETURNS integer
AS $$
DECLARE
    dhl_message_id_ integer;
begin
    perform *
    from    dhl_message
    where   dhl_id = p_dhl_id
            and is_incoming = p_is_incoming;
    
    if (FOUND) then
        select  dhl_message_id
        into    dhl_message_id_
        from    dhl_message
        where   dhl_id = p_dhl_id
                and is_incoming = p_is_incoming;
    else
        dhl_message_id_ := 0;
    end if;
    
    RETURN  dhl_message_id_;
END; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Save_DhlMessageRecipient"(
    p_dhl_message_id integer,
    p_recipient_org_code character varying,
    p_recipient_org_name character varying,
    p_recipient_person_code character varying,
    p_recipient_name character varying,
    p_sending_date timestamp with time zone,
    p_received_date timestamp with time zone,
    p_sending_status_id integer,
    p_recipient_status_id integer,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_metaxml text)
RETURNS boolean
AS $$
DECLARE
    recipient_org_code_ character varying := p_recipient_org_code;
    recipient_person_code_ character varying := p_recipient_person_code;
BEGIN
    if recipient_org_code_ is null then
        recipient_org_code_ := '';
    end if;
    if recipient_person_code_ is null then
        recipient_person_code_ := '';
    end if;
	
    perform *
    from    dhl_message_recipient
    where   dhl_message_id = p_dhl_message_id
            and recipient_org_code = p_recipient_org_code
            and recipient_person_code = p_recipient_person_code;
    
    if (FOUND) then
        update  dhl_message_recipient
        set     recipient_org_name = p_recipient_org_name,
                recipient_name = p_recipient_name,
                sending_date = p_sending_date,
                received_date = p_received_date,
                sending_status_id = p_sending_status_id,
                recipient_status_id = p_recipient_status_id,
                fault_code = p_fault_code,
                fault_actor = p_fault_actor,
                fault_string = p_fault_string,
                fault_detail = p_fault_detail,
                metaxml = p_metaxml
        where   dhl_message_id = p_dhl_message_id
                and recipient_org_code = p_recipient_org_code
                and recipient_person_code = p_recipient_person_code;
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
                metaxml)
       values  (p_dhl_message_id,
                p_recipient_org_code,
                p_recipient_org_name,
                p_recipient_person_code,
                p_recipient_name,
                p_sending_date,
                p_received_date,
                p_sending_status_id,
                p_recipient_status_id,
                p_fault_code,
                p_fault_actor,
                p_fault_string,
                p_fault_detail,
                p_metaxml);
	end if;
    RETURN  FOUND;
END; $$
    LANGUAGE plpgsql;

CREATE OR REPLACE
FUNCTION "Update_DhlMessageStatus"(p_dhl_message_id integer, p_status_id integer) RETURNS boolean
AS $$
BEGIN
    update  dhl_message
    set     sending_status_id = p_status_id
    where   dhl_message_id = p_dhl_message_id;
    RETURN  FOUND;
END; $$
    LANGUAGE plpgsql;

