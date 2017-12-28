
CREATE USER dvk_admin WITH PASSWORD 'postgres';
ALTER USER dvk_admin SET search_path = dvk, dvklog, public;

GRANT ALL PRIVILEGES ON DATABASE postgres TO dvk_admin;
GRANT ALL PRIVILEGES ON SCHEMA dvk TO dvk_admin;
GRANT ALL PRIVILEGES ON SCHEMA dvklog TO dvk_admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO dvk_admin;
GRANT ALL PRIVILEGES ON SCHEMA pg_catalog TO dvk_admin;
GRANT ALL PRIVILEGES ON SCHEMA information_schema TO dvk_admin;

ALTER TABLE dvk.allkiri OWNER TO dvk_admin;
ALTER TABLE dvk.allyksus OWNER TO dvk_admin;
ALTER TABLE dvk.ametikoht OWNER TO dvk_admin;
ALTER TABLE dvk.ametikoht_taitmine OWNER TO dvk_admin;
ALTER TABLE dvk.asutus OWNER TO dvk_admin;
ALTER TABLE dvk.dokumendi_ajalugu OWNER TO dvk_admin;
ALTER TABLE dvk.dokumendi_fail OWNER TO dvk_admin;
ALTER TABLE dvk.dokumendi_fragment OWNER TO dvk_admin;
ALTER TABLE dvk.dokumendi_metaandmed OWNER TO dvk_admin;
ALTER TABLE dvk.dokument OWNER TO dvk_admin;
ALTER TABLE dvk.dynaamilised_metaandmed OWNER TO dvk_admin;
ALTER TABLE dvk.ehak OWNER TO dvk_admin;
ALTER TABLE dvk.isik OWNER TO dvk_admin;
ALTER TABLE dvk.kaust OWNER TO dvk_admin;
ALTER TABLE dvk.klassifikaator OWNER TO dvk_admin;
ALTER TABLE dvk.klassifikaatori_tyyp OWNER TO dvk_admin;
ALTER TABLE dvk.konversioon OWNER TO dvk_admin;
ALTER TABLE dvk.logi OWNER TO dvk_admin;
ALTER TABLE dvk.oigus_antud OWNER TO dvk_admin;
ALTER TABLE dvk.oigus_objektile OWNER TO dvk_admin;
ALTER TABLE dvk.parameetrid OWNER TO dvk_admin;
ALTER TABLE dvk.saatja OWNER TO dvk_admin;
ALTER TABLE dvk.server OWNER TO dvk_admin;
ALTER TABLE dvk.staatuse_ajalugu OWNER TO dvk_admin;
ALTER TABLE dvk.transport OWNER TO dvk_admin;
ALTER TABLE dvk.vahendaja OWNER TO dvk_admin;
ALTER TABLE dvk.vastuvotja OWNER TO dvk_admin;
ALTER TABLE dvk.vastuvotja_mall OWNER TO dvk_admin;
ALTER TABLE dvk.vastuvotja_staatus OWNER TO dvk_admin;


ALTER SEQUENCE dvk.sq_allkiri_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_allyksus_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_ametikoht_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_ametikoht_taitmine_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_asutus_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_dokumendi_ajalugu_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_dokumendi_fail_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_dokumendi_fragment_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_dokument_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_isik_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_kaust_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_konv_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_logi_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_oigus_antud_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_oigus_objektile_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_saatja_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_staatuse_ajalugu_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_transport_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_vahendaja_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_vastuvotja_id OWNER TO dvk_admin;
ALTER SEQUENCE dvk.sq_vastuvotja_mall_id OWNER TO dvk_admin;


ALTER FUNCTION tr_allkiri_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_allyksus_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_ametikoht_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_ametikoht_taitmine_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_asutus_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_dokumendi_ajalugu_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_dokumendi_fail_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_dokumendi_metaandmed_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_dokument_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_dynaamilised_metaandmed_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_ehak_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_isik_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_kaust_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_klassifikaator_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_klassifikaatori_tyyp_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_konversioon_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_logi_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_oigus_antud_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_oigus_objektile_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_parameetrid_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_saatja_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_server_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_staatuse_ajalugu_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_transport_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_vahendaja_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_vastuvotja_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_vastuvotja_mall_log() OWNER TO dvk_admin;
ALTER FUNCTION tr_vastuvotja_staatus_log() OWNER TO dvk_admin;


ALTER FUNCTION "Add_Allyksus"(integer, integer, character varying, timestamp without time zone, timestamp without time zone, character varying, integer, integer, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_AmetikohaTaitmine"(integer, integer, timestamp without time zone, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, integer, integer) OWNER TO dvk_admin;  
ALTER FUNCTION "Add_Ametikoht"(integer, integer, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, integer, character varying, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Asutus"(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Dokument"(integer, integer, integer, character varying, timestamp without time zone, bigint, integer, character varying, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Dokument_Fragment"(integer, integer, integer, character varying, integer, integer, timestamp without time zone, bytea, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Folder"(character varying, integer, integer, character varying, character varying, character varying) OWNER TO dvk_admin;  
ALTER FUNCTION "Add_Isik"(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Proxy"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Sender"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Sending"(integer, timestamp without time zone, timestamp without time zone, integer, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Staatuse_Ajalugu"(integer, integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Create_Log_Triggers"() OWNER TO dvk_admin;
ALTER FUNCTION "Delete_Document"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Delete_DocumentFragments"(integer, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AllyksusByAarID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AllyksusIdByAarID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AllyksusIdByShortName"(integer, character varying) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_AllyksusList"(integer, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AllyksusStat"(integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AmetikohaTaitmineByAarID"(integer) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_AmetikohaTaitmineList"(integer, character varying) OWNER TO dvk_admin;  
ALTER FUNCTION "Get_AmetikohtByAarID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AmetikohtIdByAarID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AmetikohtIdByShortName"(integer, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AmetikohtList"(integer, character varying) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_AmetikohtStat"(integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AsutusByID"(integer) OWNER TO dvk_admin;  
ALTER FUNCTION "Get_AsutusByRegNr"(character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AsutusIdByAarID"(integer) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_AsutusIdByRegNr"(character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AsutusList"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_AsutusStat"(integer) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_DocumentFragments"(integer, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_DocumentStatusHistory"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_DocumentsSentTo"(integer, integer, integer, integer, character varying, integer, character varying, integer) OWNER TO dvk_admin; 
ALTER FUNCTION "Get_ExpiredDocuments"() OWNER TO dvk_admin;
ALTER FUNCTION "Get_FolderFullPath"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_FolderIdByName"(character varying, integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_IsikByCode"(character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_IsikIdByCode"(character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_LastSendingByDocGUID"(character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_LastSendingByDocID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_NextDocID"() OWNER TO dvk_admin; 
ALTER FUNCTION "Get_NextFragmentID"() OWNER TO dvk_admin;  
ALTER FUNCTION "Get_NextRecipientID"() OWNER TO dvk_admin;
ALTER FUNCTION "Get_Parameters"() OWNER TO dvk_admin;  
ALTER FUNCTION "Get_PersonCurrentDivisionIDs"(integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_PersonCurrentPositionIDs"(integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_PersonCurrentRoles"(integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_ProxyBySendingID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_RecipientTemplates"() OWNER TO dvk_admin;
ALTER FUNCTION "Get_Recipient_By_Id"() OWNER TO dvk_admin;
ALTER FUNCTION "Get_Recipients"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_SenderBySendingID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_ServerByID"(integer) OWNER TO dvk_admin;
ALTER FUNCTION "Get_Servers"() OWNER TO dvk_admin;
ALTER FUNCTION "Save_Parameters"(timestamp without time zone) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Allyksus"(integer, integer, integer, character varying, timestamp without time zone, timestamp without time zone, character varying, integer, integer, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Update_AmetikohaTaitmine"(integer, integer, integer, timestamp without time zone, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, integer, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Ametikoht"(integer, integer, integer, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, text, integer, character varying, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Asutus"(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Update_DocumentExpirationDate"(integer, timestamp without time zone) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Isik"(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Sending"(integer, integer, timestamp without time zone, timestamp without time zone, integer) OWNER TO dvk_admin;
ALTER FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO dvk_admin;
ALTER FUNCTION "Get_NotSentDhxDocuments"() OWNER TO dvk_admin;
ALTER FUNCTION bytea_import(text) OWNER TO dvk_admin;
ALTER FUNCTION dir_temp_konv(character varying) OWNER TO dvk_admin;  


ALTER FUNCTION dvklog.log_allkiri(allkiri, allkiri, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_allyksus(allyksus, allyksus, character varying) OWNER TO dvk_admin; 
ALTER FUNCTION dvklog.log_ametikoht(ametikoht, ametikoht, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_ametikoht_taitmine(ametikoht_taitmine, ametikoht_taitmine, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_asutus(asutus, asutus, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dokumendi_ajalugu(dokumendi_ajalugu, dokumendi_ajalugu, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dokumendi_fail(dokumendi_fail, dokumendi_fail, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dokumendi_fragment(dokumendi_fragment, dokumendi_fragment, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dokumendi_metaandmed(dokumendi_metaandmed, dokumendi_metaandmed, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dokument(dokument, dokument, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_dynaamilised_metaandmed(dynaamilised_metaandmed, dynaamilised_metaandmed, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_ehak(ehak, ehak, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_isik(isik, isik, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_kaust(kaust, kaust, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_klassifikaator(klassifikaator, klassifikaator, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_klassifikaatori_tyyp(klassifikaatori_tyyp, klassifikaatori_tyyp, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_konversioon(konversioon, konversioon, character varying) OWNER TO dvk_admin;  
ALTER FUNCTION dvklog.log_logi(logi, logi, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_oigus_antud(oigus_antud, oigus_antud, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_oigus_objektile(oigus_objektile, oigus_objektile, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_parameetrid(parameetrid, parameetrid, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_saatja(saatja, saatja, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_server(server, server, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_staatuse_ajalugu(staatuse_ajalugu, staatuse_ajalugu, character varying) OWNER TO dvk_admin;  
ALTER FUNCTION dvklog.log_transport(transport, transport, character varying) OWNER TO dvk_admin;
ALTER FUNCTION dvklog.log_vahendaja(vahendaja, vahendaja, character varying) OWNER TO dvk_admin;  
ALTER FUNCTION dvklog.log_vastuvotja(vastuvotja, vastuvotja, character varying) OWNER TO dvk_admin; 
ALTER FUNCTION dvklog.log_vastuvotja_mall(vastuvotja_mall, vastuvotja_mall, character varying) OWNER TO dvk_admin; 
ALTER FUNCTION dvklog.log_vastuvotja_staatus(vastuvotja_staatus, vastuvotja_staatus, character varying) OWNER TO dvk_admin;  
