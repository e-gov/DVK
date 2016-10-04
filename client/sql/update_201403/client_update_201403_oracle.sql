----------------------------------------------------------------------
-- March 2014
-- Update DVK Client from version 1.6.2 to 1.6.3
----------------------------------------------------------------------

CREATE SEQUENCE sq_dhl_error_log_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOMAXVALUE
NOCACHE;
/

CREATE SEQUENCE sq_dhl_request_log_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOMAXVALUE
NOCACHE;
/

CREATE TABLE dhl_error_log
(
    dhl_error_log_id number(10,0) NOT NULL,
    error_datetime timestamp NOT NULL,
    organization_code varchar2(20) NULL,
    user_code varchar2(20) NULL,
    action_name varchar2(200) NULL,
    error_message varchar2(500) NOT NULL,
    dhl_message_id number(10,0) NULL
);
/

CREATE TABLE dhl_request_log
(
    dhl_request_log_id number(10,0) NOT NULL,
    request_datetime timestamp NOT NULL,
    organization_code varchar2(20) NOT NULL,
    user_code varchar2(20) NULL,
    request_name varchar2(100) NOT NULL,
    response varchar2(10) NULL,
    dhl_error_log_id number(10,0) NULL
);
/

ALTER
TABLE dhl_error_log
ADD CONSTRAINT PK_dhl_error_log
PRIMARY KEY (dhl_error_log_id);
/

ALTER TABLE dhl_error_log
ADD CONSTRAINT FK_dhl_message_id
FOREIGN KEY (dhl_message_id)
REFERENCES dhl_message(dhl_message_id);
/

CREATE OR REPLACE
TRIGGER tr_dhl_error_log_id
    BEFORE INSERT
    ON dhl_error_log
    FOR EACH ROW
BEGIN
    IF (:new.dhl_error_log_id < 1) THEN
        SELECT  sq_dhl_error_log_id.nextval
        INTO    globalPkg.identity
        FROM    dual;
        :new.dhl_error_log_id := globalPkg.identity;
    END IF;
END;
/

ALTER
TABLE dhl_request_log
ADD CONSTRAINT PK_dhl_request_log
PRIMARY KEY (dhl_request_log_id);
/

ALTER TABLE dhl_request_log
ADD CONSTRAINT FK_dhl_error_log_id
FOREIGN KEY (dhl_error_log_id)
REFERENCES dhl_error_log(dhl_error_log_id);
/

CREATE OR REPLACE
TRIGGER tr_dhl_request_log_id
    BEFORE INSERT
    ON dhl_request_log
    FOR EACH ROW
BEGIN
    IF (:new.dhl_request_log_id < 1) THEN
        SELECT  sq_dhl_request_log_id.nextval
        INTO    globalPkg.identity
        FROM    dual;
        :new.dhl_request_log_id := globalPkg.identity;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE Add_DhlErrorLog(
    dhl_error_log_id out number,
    error_datetime in timestamp,
    organization_code in varchar2,
    user_code in varchar2,
    action_name in varchar2,
    error_message in varchar2,
    dhl_message_id in number)
AS
BEGIN
        INSERT
        INTO	dhl_error_log(
              dhl_error_log_id,
              error_datetime,
              organization_code,
              user_code,
              action_name,
              error_message,
              dhl_message_id)
        VALUES  (0,
                Add_DhlErrorLog.error_datetime,
                Add_DhlErrorLog.organization_code,
                Add_DhlErrorLog.user_code,
                Add_DhlErrorLog.action_name,
                Add_DhlErrorLog.error_message,
                Add_DhlErrorLog.dhl_message_id);

        Add_DhlErrorLog.dhl_error_log_id := globalPkg.identity;
END;
/

CREATE OR REPLACE PROCEDURE Add_DhlRequestLog(
    dhl_request_log_id out number,
    request_datetime in timestamp,
    organization_code in varchar2,
    user_code in varchar2,
    request_name in varchar2,
    response in varchar2,
    dhl_error_log_id in number)
AS
BEGIN
        INSERT
        INTO  dhl_request_log(
              dhl_request_log_id,
              request_datetime,
              organization_code,
              user_code,
              request_name,
              response,
              dhl_error_log_id)
        VALUES  (0,
                Add_DhlRequestLog.request_datetime,
                Add_DhlRequestLog.organization_code,
                Add_DhlRequestLog.user_code,
                Add_DhlRequestLog.request_name,
                Add_DhlRequestLog.response,
                Add_DhlRequestLog.dhl_error_log_id);

        Add_DhlRequestLog.dhl_request_log_id := globalPkg.identity;
END;

