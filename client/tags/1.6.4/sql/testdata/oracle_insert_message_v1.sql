INSERT INTO dhl_message
           (is_incoming
           ,data
           ,title
           ,sender_org_code
           ,sender_org_name
           ,sender_person_code
           ,sender_name
           ,recipient_org_code
           ,recipient_org_name
           ,recipient_person_code
           ,recipient_name
           ,case_name
           ,dhl_folder_name
           ,sending_status_id
           ,unit_id
           ,dhl_id
           ,sending_date
           ,received_date
           ,local_item_id
           ,recipient_status_id
           ,fault_code
           ,fault_actor
           ,fault_string
           ,fault_detail
           ,status_update_needed
           ,metaxml
           ,query_id
           ,proxy_org_code
           ,proxy_org_name
           ,proxy_person_code
           ,proxy_name
           ,recipient_department_nr
           ,recipient_department_name
           ,recipient_email
           ,recipient_division_id
           ,recipient_division_name
           ,recipient_position_id
           ,recipient_position_name)
     VALUES
           (1,
           '<?xml version="1.0" encoding="utf-8"?>
           <dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl">
    <dhl:metainfo xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic" xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual">
    </dhl:metainfo>
    <dhl:transport>
        <dhl:saatja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:nimi>Jaak Lember</dhl:nimi>
			<dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
			<dhl:ametikoha_lyhinimetus>SEPP</dhl:ametikoha_lyhinimetus>
			<dhl:ametikoha_nimetus>Sepp</dhl:ametikoha_nimetus>
			<dhl:allyksuse_lyhinimetus>SEPIKODA</dhl:allyksuse_lyhinimetus>
			<dhl:allyksuse_nimetus>Sepikoda</dhl:allyksuse_nimetus>
        </dhl:saatja>
        <dhl:saaja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
			<dhl:allyksuse_lyhinimetus>RMTP</dhl:allyksuse_lyhinimetus>
			<dhl:allyksuse_nimetus>Raamatupidamisosakond</dhl:allyksuse_nimetus>
			<dhl:ametikoha_lyhinimetus>RMTP-123</dhl:ametikoha_lyhinimetus>
			<dhl:ametikoha_nimetus>Raamatupidaja</dhl:ametikoha_nimetus>
        </dhl:saaja>
    </dhl:transport>
    <dhl:ajalugu/>
    <dhl:metaxml/>
<SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
<DataFile ContentType="EMBEDDED_BASE64" Filename="hello_original.ddoc" Id="D0" MimeType="application/unknown" Size="0" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
</DataFile>
</SignedDoc>
</dhl:dokument>
',
           'Testdokument',
           '87654321',
           'Asutus',
           '',
           'Jaak Lember',
           '87654321',
           'Asutus',
           '',
           '',
           '',
           '',
           1,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL);

