ALTER TABLE dhl_settings
ADD xroad_client_instance nvarchar(2),
ADD xroad_client_member_class nvarchar(50),
ADD xroad_client_subsystem_code nvarchar(50);

ALTER TABLE dhl_message_recipient
ADD xroad_service_instance nvarchar(2),
ADD xroad_service_member_class nvarchar(50),
ADD xroad_service_member_code nvarchar(50);

ALTER TABLE dhl_organization
ADD xroad_service_instance nvarchar(2),
ADD xroad_service_member_class nvarchar(50),
ADD xroad_service_member_code nvarchar(50);
