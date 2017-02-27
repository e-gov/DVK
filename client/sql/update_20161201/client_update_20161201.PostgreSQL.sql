ALTER TABLE dhl_settings
ADD xroad_client_instance VARCHAR(6),
ADD xroad_client_member_class VARCHAR(50),
ADD xroad_client_subsystem_code VARCHAR(50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);

ALTER TABLE dhl_organization
ADD xroad_service_instance VARCHAR(6),
ADD xroad_service_member_class VARCHAR(50),
ADD xroad_service_member_code VARCHAR(50);
