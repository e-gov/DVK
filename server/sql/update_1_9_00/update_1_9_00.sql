--ALTER TABLE vastuvotja ADD dhx_dokument smallint default 0;
ALTER TABLE asutus ADD dhx_asutus smallint DEFAULT 0;
ALTER TABLE vastuvotja ADD dhx_internal_consignment_id character varying(200);
ALTER TABLE vastuvotja ADD dhx_external_consignment_id character varying(200);
ALTER TABLE vastuvotja ADD dhx_external_receipt_id character varying(200);

ALTER TABLE vastuvotja ADD last_send_date timestamp;


-- Function: "Get_NotSentDhxDocuments"(timestamp without time zone)

-- DROP FUNCTION "Get_NotSentDhxDocuments"(timestamp without time zone);

CREATE OR REPLACE FUNCTION "Get_NotSentDhxDocuments"(p_date timestamp without time zone)
  RETURNS refcursor AS
$BODY$
declare
    RC1 refcursor;
BEGIN
    open RC1 for
select  *
    from    dokument d
    where   d.dokument_id in (
     select  t1.dokument_id
        from    transport t1, vastuvotja v1, asutus a1
        where   t1.transport_id = v1.transport_id
                and v1.staatus_id = 101
                and v1.asutus_id=a1.asutus_id
                and a1.dhx_asutus=1
                and v1.dhx_external_consignment_id is null
                and  (v1.dhx_internal_consignment_id is null
			or v1.last_send_date<p_date
                )for update) ;
     
    return RC1;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Get_NotSentDhxDocuments"(timestamp without time zone)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_NotSentDhxDocuments"(timestamp without time zone) TO public;
GRANT EXECUTE ON FUNCTION "Get_NotSentDhxDocuments"(timestamp without time zone) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_NotSentDhxDocuments"(timestamp without time zone) TO dvk_user;



-- Function: "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone)

-- DROP FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone);

CREATE OR REPLACE FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(p_date timestamp without time zone)
  RETURNS void AS
$BODY$
DECLARE
begin
    update vastuvotja set dhx_internal_consignment_id=vastuvotja_id, last_send_date=current_timestamp 
      where vastuvotja_id in (
                        select vastuvotja_id from vastuvotja v1, asutus a1 where
                          staatus_id=101 and dhx_external_consignment_id is null
                            and (dhx_internal_consignment_id is null
                                or last_send_date<p_date
                                  ) and v1.asutus_id=a1.asutus_id and a1.dhx_asutus=1);
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone) TO public;
GRANT EXECUTE ON FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Set_AllDhxNotSentDocumentsInternalConsignment"(timestamp without time zone) TO dvk_user;


-- Function: "Get_AsutusList"(integer)

-- DROP FUNCTION "Get_AsutusList"(integer);

CREATE OR REPLACE FUNCTION "Get_AsutusList"(p_dhx_asutus integer)
  RETURNS refcursor AS
$BODY$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select  *
    from    asutus
    where   dhl_saatmine = 1
            and coalesce(server_id::text, '') = ''
            and  dhx_asutus = coalesce(p_dhx_asutus, dhx_asutus);
    return RC1;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Get_AsutusList"(integer)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusList"(integer) TO public;
GRANT EXECUTE ON FUNCTION "Get_AsutusList"(integer) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusList"(integer) TO dvk_user;





-- Function: "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone)

-- DROP FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone);

CREATE OR REPLACE FUNCTION "Add_Vastuvotja"(
    p_vastuvotja_id integer,
    p_transport_id integer,
    p_asutus_id integer,
    p_ametikoht_id integer,
    p_allyksus_id integer,
    p_isikukood character varying,
    p_nimi character varying,
    p_asutuse_nimi character varying,
    p_email character varying,
    p_osakonna_nr character varying,
    p_osakonna_nimi character varying,
    p_saatmisviis_id integer,
    p_staatus_id integer,
    p_saatmise_algus timestamp without time zone,
    p_saatmise_lopp timestamp without time zone,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_vastuvotja_staatus_id integer,
    p_metaxml text,
    p_dok_id_teises_serveris integer,
    p_allyksuse_lyhinimetus character varying,
    p_ametikoha_lyhinimetus character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying,
    p_dhx_internal_consignment_id character varying,
    p_dhx_external_consignment_id character varying,
    p_dhx_external_receipt_id character varying,
    p_last_send_date timestamp without time zone)
  RETURNS void AS
$BODY$
BEGIN

   set dvkxtee.xtee_isikukood = p_xtee_isikukood;
   set dvkxtee.xtee_asutus = p_xtee_asutus;

  INSERT 
  INTO    vastuvotja (
          vastuvotja_id,
          transport_id,
          asutus_id,
          ametikoht_id,
		  isikukood,
		  nimi,
		  email,
		  osakonna_nr,
		  osakonna_nimi,
		  saatmisviis_id,
		  staatus_id,
		  saatmise_algus,
		  saatmise_lopp,
		  fault_code,
		  fault_actor,
		  fault_string,
		  fault_detail,
		  vastuvotja_staatus_id,
		  metaxml,
		  asutuse_nimi,
		  allyksus_id,
		  dok_id_teises_serveris,
		  allyksuse_lyhinimetus,
		  ametikoha_lyhinimetus,
		  dhx_internal_consignment_id,
		  dhx_external_consignment_id,
		  dhx_external_receipt_id,
		  last_send_date
		  )
   VALUES (p_vastuvotja_id,          
          p_transport_id,
          p_asutus_id,
          p_ametikoht_id,
		  p_isikukood,
		  p_nimi,
		  p_email,
		  p_osakonna_nr,
		  p_osakonna_nimi,
		  p_saatmisviis_id,
		  p_staatus_id,
		  p_saatmise_algus,
		  p_saatmise_lopp,
		  p_fault_code,
		  p_fault_actor,
		  p_fault_string,
		  p_fault_detail,
		  p_vastuvotja_staatus_id,
		  p_metaxml,
		  p_asutuse_nimi,
		  p_allyksus_id,
		  p_dok_id_teises_serveris,
		  p_allyksuse_lyhinimetus,
		  p_ametikoha_lyhinimetus,
                  p_dhx_internal_consignment_id,
                  p_dhx_external_consignment_id,
                  p_dhx_external_receipt_id,
                  p_last_send_date);
  
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone) TO public;
GRANT EXECUTE ON FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Add_Vastuvotja"(integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying,  timestamp without time zone) TO dvk_user;






-- Function: "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, timestamp without time zone)

-- DROP FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, timestamp without time zone);

CREATE OR REPLACE FUNCTION "Update_Vastuvotja"(
    p_vastuvotja_id integer,
    p_transport_id integer,
    p_asutus_id integer,
    p_ametikoht_id integer,
    p_isikukood character varying,
    p_nimi character varying,
    p_email character varying,
    p_osakonna_nr character varying,
    p_osakonna_nimi character varying,
    p_saatmisviis_id integer,
    p_staatus_id integer,
    p_saatmise_algus timestamp without time zone,
    p_saatmise_lopp timestamp without time zone,
    p_fault_code character varying,
    p_fault_actor character varying,
    p_fault_string character varying,
    p_fault_detail character varying,
    p_vastuvotja_staatus_id integer,
    p_metaxml text,
    p_asutuse_nimi character varying,
    p_allyksus_id integer,
    p_dok_id_teises_serveris integer,
    p_allyksuse_lyhinimetus character varying,
    p_ametikoha_lyhinimetus character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying,
    p_dhx_internal_consignment_id character varying,
    p_dhx_external_consignment_id character varying,
    p_dhx_external_receipt_id character varying,
    p_last_send_date timestamp without time zone)
  RETURNS void AS
$BODY$
BEGIN

  -- Set session scope variables
	set dvkxtee.xtee_isikukood = p_xtee_isikukood;
	set dvkxtee.xtee_asutus = p_xtee_asutus;

  UPDATE  vastuvotja set
          transport_id = p_transport_id,
          asutus_id = p_asutus_id,
          ametikoht_id = p_ametikoht_id,
          isikukood = p_isikukood,
		  nimi = p_nimi,
		  email = p_email,
		  osakonna_nr = p_osakonna_nr,
		  osakonna_nimi = p_osakonna_nimi,
		  saatmisviis_id = p_saatmisviis_id,
		  staatus_id = p_staatus_id,
		  saatmise_algus = p_saatmise_algus,
		  saatmise_lopp = p_saatmise_lopp,
		  fault_code =  p_fault_code,
		  fault_actor = p_fault_actor,
		  fault_string = p_fault_string,
		  fault_detail = p_fault_detail,
		  vastuvotja_staatus_id = p_vastuvotja_staatus_id,
		  metaxml = p_metaxml,
		  asutuse_nimi = p_asutuse_nimi,
		  allyksus_id = p_allyksus_id,
		  dok_id_teises_serveris = p_dok_id_teises_serveris,
		  allyksuse_lyhinimetus = p_allyksuse_lyhinimetus,
		  ametikoha_lyhinimetus = p_ametikoha_lyhinimetus,
		  dhx_internal_consignment_id = p_dhx_internal_consignment_id,
		  dhx_external_consignment_id = p_dhx_external_consignment_id,
		  dhx_external_receipt_id = p_dhx_external_receipt_id,
    	  last_send_date = p_last_send_date
  WHERE vastuvotja_id = p_vastuvotja_id ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone) TO public;
GRANT EXECUTE ON FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Update_Vastuvotja"(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, integer, text, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone) TO dvk_user;


CREATE OR REPLACE FUNCTION "Update_Asutus"(
    p_id integer,
    p_registrikood character varying,
    p_registrikood2 character varying,
    p_registrikood_vana character varying,
    p_ks_asutus_id integer,
    p_ks_asutus_kood character varying,
    p_nimetus character varying,
    p_nime_lyhend character varying,
    p_liik1 character varying,
    p_liik2 character varying,
    p_tegevusala character varying,
    p_tegevuspiirkond character varying,
    p_maakond character varying,
    p_asukoht character varying,
    p_aadress character varying,
    p_postikood character varying,
    p_telefon character varying,
    p_faks character varying,
    p_e_post character varying,
    p_www character varying,
    p_logo character varying,
    p_asutamise_kp timestamp without time zone,
    p_mood_akt_nimi character varying,
    p_mood_akt_nr character varying,
    p_mood_akt_kp timestamp without time zone,
    p_pm_akt_nimi character varying,
    p_pm_akt_nr character varying,
    p_pm_kinnitamise_kp timestamp without time zone,
    p_pm_kande_kp timestamp without time zone,
    p_loodud timestamp without time zone,
    p_muudetud timestamp without time zone,
    p_muutja character varying,
    p_parameetrid character varying,
    p_dhl_saatmine integer,
    p_dhl_otse_saatmine integer,
    p_dhs_nimetus character varying,
    p_toetatav_dvk_versioon character varying,
    p_server_id integer,
    p_aar_id integer,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying,
    p_kapsel_versioon character varying,
    p_dhx_asutus integer)
  RETURNS void AS
$BODY$
BEGIN

    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

    update  asutus
    set     registrikood = p_registrikood,
            registrikood2 = p_registrikood2,
            e_registrikood = p_registrikood_vana,
            ks_asutus_id = p_ks_asutus_id,
            ks_asutus_kood = p_ks_asutus_kood,
            nimetus = p_nimetus,
            lnimi = p_nime_lyhend,
            liik1 = p_liik1,
            liik2 = p_liik2,
            tegevusala = p_tegevusala,
            tegevuspiirkond = p_tegevuspiirkond,
            maakond = p_maakond,
            asukoht = p_asukoht,
            aadress = p_aadress,
            postikood = p_postikood,
            telefon = p_telefon,
            faks = p_faks,
            e_post = p_e_post,
            www = p_www,
            logo = p_logo,
            asutamise_kp = p_asutamise_kp,
            mood_akt_nimi = p_mood_akt_nimi,
            mood_akt_nr = p_mood_akt_nr,
            mood_akt_kp = p_mood_akt_kp,
            pm_akt_nimi = p_pm_akt_nimi,
            pm_akt_nr = p_pm_akt_nr,
            pm_kinnitamise_kp = p_pm_kinnitamise_kp,
            pm_kande_kp = p_pm_kande_kp,
            created = p_loodud,
            last_modified = p_muudetud,
            username = p_muutja,
            params = p_parameetrid,
            dhl_saatmine = p_dhl_saatmine,
            dhl_otse_saatmine = p_dhl_otse_saatmine,
            dhs_nimetus = p_dhs_nimetus,
            toetatav_dvk_versioon = p_toetatav_dvk_versioon,
            server_id = p_server_id,
            aar_id = p_aar_id,
            kapsel_versioon = p_kapsel_versioon,
            dhx_asutus = p_dhx_asutus
    where   asutus_id = p_id;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Update_Asutus"(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Update_Asutus"(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO public;
GRANT EXECUTE ON FUNCTION "Update_Asutus"(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Update_Asutus"(integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO dvk_user;


CREATE OR REPLACE FUNCTION "Add_Asutus"(
    p_registrikood character varying,
    p_registrikood2 character varying,
    p_registrikood_vana character varying,
    p_ks_asutus_id integer,
    p_ks_asutus_kood character varying,
    p_nimetus character varying,
    p_nime_lyhend character varying,
    p_liik1 character varying,
    p_liik2 character varying,
    p_tegevusala character varying,
    p_tegevuspiirkond character varying,
    p_maakond character varying,
    p_asukoht character varying,
    p_aadress character varying,
    p_postikood character varying,
    p_telefon character varying,
    p_faks character varying,
    p_e_post character varying,
    p_www character varying,
    p_logo character varying,
    p_asutamise_kp timestamp without time zone,
    p_mood_akt_nimi character varying,
    p_mood_akt_nr character varying,
    p_mood_akt_kp timestamp without time zone,
    p_pm_akt_nimi character varying,
    p_pm_akt_nr character varying,
    p_pm_kinnitamise_kp timestamp without time zone,
    p_pm_kande_kp timestamp without time zone,
    p_loodud timestamp without time zone,
    p_muudetud timestamp without time zone,
    p_muutja character varying,
    p_parameetrid character varying,
    p_dhl_saatmine integer,
    p_dhl_otse_saatmine integer,
    p_dhs_nimetus character varying,
    p_toetatav_dvk_versioon character varying,
    p_server_id integer,
    p_aar_id integer,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying,
    p_kapsel_versioon character varying,
    p_dhx_asutus integer)
  RETURNS integer AS
$BODY$
DECLARE
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus =  p_xtee_asutus;
    
    perform *
    from    asutus
    where   registrikood = p_registrikood
    limit 1;

    if (found) then
        select  a.asutus_id
        into    p_id
        from    asutus a
        where   a.registrikood = p_registrikood
                limit 1;
    else
        p_id := nextval('sq_asutus_id');

        insert
        into    asutus(
                asutus_id,
                registrikood,
                registrikood2,
                e_registrikood,
                ks_asutus_id,
                ks_asutus_kood,
                nimetus,
                lnimi,
                liik1,
                liik2,
                tegevusala,
                tegevuspiirkond,
                maakond,
                asukoht,
                aadress,
                postikood,
                telefon,
                faks,
                e_post,
                www,
                logo,
                asutamise_kp,
                mood_akt_nimi,
                mood_akt_nr,
                mood_akt_kp,
                pm_akt_nimi,
                pm_akt_nr,
                pm_kinnitamise_kp,
                pm_kande_kp,
                created,
                last_modified,
                username,
                params,
                dhl_saatmine,
                dhl_otse_saatmine,
                dhs_nimetus,
                toetatav_dvk_versioon,
                server_id,
                aar_id,
                kapsel_versioon,
		dhx_asutus)
        values  (p_id,
                p_registrikood,
                p_registrikood2,
                p_registrikood_vana,
                p_ks_asutus_id,
                p_ks_asutus_kood,
                p_nimetus,
                p_nime_lyhend,
                p_liik1,
                p_liik2,
                p_tegevusala,
                p_tegevuspiirkond,
                p_maakond,
                p_asukoht,
                p_aadress,
                p_postikood,
                p_telefon,
                p_faks,
                p_e_post,
                p_www,
                p_logo,
                p_asutamise_kp,
                p_mood_akt_nimi,
                p_mood_akt_nr,
                p_mood_akt_kp,
                p_pm_akt_nimi,
                p_pm_akt_nr,
                p_pm_kinnitamise_kp,
                p_pm_kande_kp,
                p_loodud,
                p_muudetud,
                p_muutja,
                p_parameetrid,
                p_dhl_saatmine,
                p_dhl_otse_saatmine,
                p_dhs_nimetus,
                p_toetatav_dvk_versioon,
                p_server_id,
                p_aar_id,
                p_kapsel_versioon,
		p_dhx_asutus);

    end if;
    return  p_id;
end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Add_Asutus"(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Add_Asutus"(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO public;
GRANT EXECUTE ON FUNCTION "Add_Asutus"(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Add_Asutus"(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, character varying, character varying, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying, character varying, integer) TO dvk_user;


ALTER TYPE get_asutus_by_id ADD ATTRIBUTE dhx_asutus smallint; 

CREATE OR REPLACE FUNCTION "Get_AsutusByID"(p_id integer)
  RETURNS SETOF get_asutus_by_id AS
$BODY$

BEGIN
RETURN QUERY

        select  a.registrikood,     
                a.e_registrikood,
                a.ks_asutus_id,
                a.ks_asutus_kood,
                a.nimetus,
                a.lnimi,
                a.liik1,
                a.liik2,
                a.tegevusala,
                a.tegevuspiirkond,
                a.maakond,
                a.asukoht,
                a.aadress,
                a.postikood,
                a.telefon,
                a.faks,
                a.e_post,
                a.www,
                a.logo,
                a.asutamise_kp,
                a.mood_akt_nimi,
                a.mood_akt_nr,
                a.mood_akt_kp,
                a.pm_akt_nimi,
                a.pm_akt_nr,
                a.pm_kinnitamise_kp,
                a.pm_kande_kp,
                a.created,
                a.last_modified,
                a.username,
                a.params,
                a.dhl_saatmine,
                a.dhl_otse_saatmine,
                a.dhs_nimetus,
                a.toetatav_dvk_versioon,
                a.server_id,
                a.aar_id,
                a.kapsel_versioon,
                a.registrikood2,
                a.dhx_asutus
        from    asutus a
        where   a.asutus_id = p_id
                LIMIT 1;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "Get_AsutusByID"(integer)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusByID"(integer) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusByID"(integer) TO public;
GRANT EXECUTE ON FUNCTION "Get_AsutusByID"(integer) TO dvk_user;



ALTER TYPE get_asutus_by_regnr ADD ATTRIBUTE dhx_asutus smallint; 

CREATE OR REPLACE FUNCTION "Get_AsutusByRegNr"(p_registrikood character varying)
  RETURNS SETOF get_asutus_by_regnr AS
$BODY$

BEGIN
RETURN QUERY

        select  asutus_id,      
                e_registrikood,
                ks_asutus_id,
                ks_asutus_kood,
                nimetus,
                lnimi,
                liik1,
                liik2,
                tegevusala,
                tegevuspiirkond,
                maakond,
                asukoht,
                aadress,
                postikood,
                telefon,
                faks,
                e_post,
                www,
                logo,
                asutamise_kp,
                mood_akt_nimi,
                mood_akt_nr,
                mood_akt_kp,
                pm_akt_nimi,
                pm_akt_nr,
                pm_kinnitamise_kp,
                pm_kande_kp,
                created,
                last_modified,
                username,
                params,
                dhl_otse_saatmine,
                dhl_saatmine,                
                dhs_nimetus,
                toetatav_dvk_versioon,
                server_id,
                aar_id,
                kapsel_versioon,
                registrikood2,
		dhx_asutus		
        from    asutus
        where   registrikood = p_registrikood
                LIMIT 1;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "Get_AsutusByRegNr"(character varying)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusByRegNr"(character varying) TO public;
GRANT EXECUTE ON FUNCTION "Get_AsutusByRegNr"(character varying) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_AsutusByRegNr"(character varying) TO dvk_user;



CREATE OR REPLACE FUNCTION tr_asutus_log()
  RETURNS trigger AS
$BODY$
DECLARE
    tr_operation character varying;
    asutus_new asutus%ROWTYPE;
    asutus_old asutus%ROWTYPE;  
BEGIN           
      if tg_op = 'INSERT' then
          tr_operation := 'INSERT';             
          asutus_new.ASUTUS_ID := NEW.ASUTUS_ID;
          asutus_new.REGISTRIKOOD := NEW.REGISTRIKOOD;
          asutus_new.REGISTRIKOOD2 := NEW.REGISTRIKOOD2;
          asutus_new.E_REGISTRIKOOD := NEW.E_REGISTRIKOOD;
          asutus_new.KS_ASUTUS_ID := NEW.KS_ASUTUS_ID;
          asutus_new.KS_ASUTUS_KOOD := NEW.KS_ASUTUS_KOOD;
          asutus_new.NIMETUS := NEW.NIMETUS;
          asutus_new.LNIMI := NEW.LNIMI;
          asutus_new.LIIK1 := NEW.LIIK1;
          asutus_new.LIIK2 := NEW.LIIK2;
          asutus_new.TEGEVUSALA := NEW.TEGEVUSALA;
          asutus_new.TEGEVUSPIIRKOND := NEW.TEGEVUSPIIRKOND;
          asutus_new.MAAKOND := NEW.MAAKOND;
          asutus_new.ASUKOHT := NEW.ASUKOHT;
          asutus_new.AADRESS := NEW.AADRESS;
          asutus_new.POSTIKOOD := NEW.POSTIKOOD;
          asutus_new.TELEFON := NEW.TELEFON;
          asutus_new.FAKS := NEW.FAKS;
          asutus_new.E_POST := NEW.E_POST;
          asutus_new.WWW := NEW.WWW;
          asutus_new.LOGO := NEW.LOGO;
          asutus_new.ASUTAMISE_KP := NEW.ASUTAMISE_KP;
          asutus_new.MOOD_AKT_NIMI := NEW.MOOD_AKT_NIMI;
          asutus_new.MOOD_AKT_NR := NEW.MOOD_AKT_NR;
          asutus_new.MOOD_AKT_KP := NEW.MOOD_AKT_KP;
          asutus_new.PM_AKT_NIMI := NEW.PM_AKT_NIMI;
          asutus_new.PM_AKT_NR := NEW.PM_AKT_NR;
          asutus_new.PM_KINNITAMISE_KP := NEW.PM_KINNITAMISE_KP;
          asutus_new.PM_KANDE_KP := NEW.PM_KANDE_KP;
          asutus_new.CREATED := NEW.CREATED;
          asutus_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
          asutus_new.USERNAME := NEW.USERNAME;
          asutus_new.PARAMS := NEW.PARAMS;
          asutus_new.DHL_OTSE_SAATMINE := NEW.DHL_OTSE_SAATMINE;
          asutus_new.DHL_SAATMINE := NEW.DHL_SAATMINE;
          asutus_new.DHS_NIMETUS := NEW.DHS_NIMETUS;
          asutus_new.TOETATAV_DVK_VERSIOON := NEW.TOETATAV_DVK_VERSIOON;
          asutus_new.SERVER_ID := NEW.SERVER_ID;
          asutus_new.AAR_ID := NEW.AAR_ID;
          asutus_new.KAPSEL_VERSIOON := NEW.KAPSEL_VERSIOON;
	  asutus_new.dhx_asutus := NEW.dhx_asutus;
       elsif tg_op = 'UPDATE' then    
          tr_operation := 'UPDATE';               
          asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
          asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
          asutus_old.REGISTRIKOOD2 := OLD.REGISTRIKOOD2;
          asutus_old.E_REGISTRIKOOD := OLD.E_REGISTRIKOOD;
          asutus_old.KS_ASUTUS_ID := OLD.KS_ASUTUS_ID;
          asutus_old.KS_ASUTUS_KOOD := OLD.KS_ASUTUS_KOOD;
          asutus_old.NIMETUS := OLD.NIMETUS;
          asutus_old.LNIMI := OLD.LNIMI;
          asutus_old.LIIK1 := OLD.LIIK1;
          asutus_old.LIIK2 := OLD.LIIK2;
          asutus_old.TEGEVUSALA := OLD.TEGEVUSALA;
          asutus_old.TEGEVUSPIIRKOND := OLD.TEGEVUSPIIRKOND;
          asutus_old.MAAKOND := OLD.MAAKOND;
          asutus_old.ASUKOHT := OLD.ASUKOHT;
          asutus_old.AADRESS := OLD.AADRESS;
          asutus_old.POSTIKOOD := OLD.POSTIKOOD;
          asutus_old.TELEFON := OLD.TELEFON;
          asutus_old.FAKS := OLD.FAKS;
          asutus_old.E_POST := OLD.E_POST;
          asutus_old.WWW := OLD.WWW;
          asutus_old.LOGO := OLD.LOGO;
          asutus_old.ASUTAMISE_KP := OLD.ASUTAMISE_KP;
          asutus_old.MOOD_AKT_NIMI := OLD.MOOD_AKT_NIMI;
          asutus_old.MOOD_AKT_NR := OLD.MOOD_AKT_NR;
          asutus_old.MOOD_AKT_KP := OLD.MOOD_AKT_KP;
          asutus_old.PM_AKT_NIMI := OLD.PM_AKT_NIMI;
          asutus_old.PM_AKT_NR := OLD.PM_AKT_NR;
          asutus_old.PM_KINNITAMISE_KP := OLD.PM_KINNITAMISE_KP;
          asutus_old.PM_KANDE_KP := OLD.PM_KANDE_KP;
          asutus_old.CREATED := OLD.CREATED;
          asutus_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
          asutus_old.USERNAME := OLD.USERNAME;
          asutus_old.PARAMS := OLD.PARAMS;
          asutus_old.DHL_OTSE_SAATMINE := OLD.DHL_OTSE_SAATMINE;
          asutus_old.DHL_SAATMINE := OLD.DHL_SAATMINE;
          asutus_old.DHS_NIMETUS := OLD.DHS_NIMETUS;
          asutus_old.TOETATAV_DVK_VERSIOON := OLD.TOETATAV_DVK_VERSIOON;
          asutus_old.SERVER_ID := OLD.SERVER_ID;
          asutus_old.AAR_ID := OLD.AAR_ID;
          asutus_old.KAPSEL_VERSIOON := OLD.KAPSEL_VERSIOON;
	  asutus_old.dhx_asutus := OLD.dhx_asutus;
       elsif tg_op = 'DELETE' then    
          tr_operation := 'DELETE';                   
          asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
          asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
          asutus_old.REGISTRIKOOD2 := OLD.REGISTRIKOOD2;
          asutus_old.E_REGISTRIKOOD := OLD.E_REGISTRIKOOD;
          asutus_old.KS_ASUTUS_ID := OLD.KS_ASUTUS_ID;
          asutus_old.KS_ASUTUS_KOOD := OLD.KS_ASUTUS_KOOD;
          asutus_old.NIMETUS := OLD.NIMETUS;
          asutus_old.LNIMI := OLD.LNIMI;
          asutus_old.LIIK1 := OLD.LIIK1;
          asutus_old.LIIK2 := OLD.LIIK2;
          asutus_old.TEGEVUSALA := OLD.TEGEVUSALA;
          asutus_old.TEGEVUSPIIRKOND := OLD.TEGEVUSPIIRKOND;
          asutus_old.MAAKOND := OLD.MAAKOND;
          asutus_old.ASUKOHT := OLD.ASUKOHT;
          asutus_old.AADRESS := OLD.AADRESS;
          asutus_old.POSTIKOOD := OLD.POSTIKOOD;
          asutus_old.TELEFON := OLD.TELEFON;
          asutus_old.FAKS := OLD.FAKS;
          asutus_old.E_POST := OLD.E_POST;
          asutus_old.WWW := OLD.WWW;
          asutus_old.LOGO := OLD.LOGO;
          asutus_old.ASUTAMISE_KP := OLD.ASUTAMISE_KP;
          asutus_old.MOOD_AKT_NIMI := OLD.MOOD_AKT_NIMI;
          asutus_old.MOOD_AKT_NR := OLD.MOOD_AKT_NR;
          asutus_old.MOOD_AKT_KP := OLD.MOOD_AKT_KP;
          asutus_old.PM_AKT_NIMI := OLD.PM_AKT_NIMI;
          asutus_old.PM_AKT_NR := OLD.PM_AKT_NR;
          asutus_old.PM_KINNITAMISE_KP := OLD.PM_KINNITAMISE_KP;
          asutus_old.PM_KANDE_KP := OLD.PM_KANDE_KP;
          asutus_old.CREATED := OLD.CREATED;
          asutus_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
          asutus_old.USERNAME := OLD.USERNAME;
          asutus_old.PARAMS := OLD.PARAMS;
          asutus_old.DHL_OTSE_SAATMINE := OLD.DHL_OTSE_SAATMINE;
          asutus_old.DHL_SAATMINE := OLD.DHL_SAATMINE;
          asutus_old.DHS_NIMETUS := OLD.DHS_NIMETUS;
          asutus_old.TOETATAV_DVK_VERSIOON := OLD.TOETATAV_DVK_VERSIOON;
          asutus_old.SERVER_ID := OLD.SERVER_ID;
          asutus_old.AAR_ID := OLD.AAR_ID;
          asutus_old.KAPSEL_VERSIOON := OLD.KAPSEL_VERSIOON; 
	  asutus_old.dhx_asutus := OLD.dhx_asutus;          
      end if;   
      
      execute dvklog.log_asutus(asutus_new, asutus_old, tr_operation);                
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tr_asutus_log()
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION tr_asutus_log() TO dvk_admin;
GRANT EXECUTE ON FUNCTION tr_asutus_log() TO public;
GRANT EXECUTE ON FUNCTION tr_asutus_log() TO dvk_user;


-- Function: dvklog.log_asutus(asutus, asutus, character varying)

-- DROP FUNCTION dvklog.log_asutus(asutus, asutus, character varying);

CREATE OR REPLACE FUNCTION dvklog.log_asutus(
    asutus_new asutus,
    asutus_old asutus,
    tr_operation character varying)
  RETURNS void AS
$BODY$        
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'asutus';    
    primary_key_value integer := asutus_old.asutus_id;
    p_id int4;  
    xtee_isikukood character varying;   
    xtee_asutus character varying;  

BEGIN   
    BEGIN
        SELECT current_setting('dvkxtee.xtee_isikukood') INTO xtee_isikukood;
        SELECT current_setting('dvkxtee.xtee_asutus') INTO xtee_asutus;
        IF xtee_isikukood = null THEN
            SET dvkxtee.xtee_isikukood = '';
        END IF;
        IF xtee_asutus = null THEN
            SET dvkxtee.xtee_asutus = '';
        END IF;
        EXCEPTION WHEN syntax_error_or_access_rule_violation THEN
            SET dvkxtee.xtee_isikukood = '';
            SET dvkxtee.xtee_asutus = '';
    END;
    
    -- Current user
    SELECT USER INTO usr ;

    select kc.column_name 
    into    pkey_col
    from  
        information_schema.table_constraints tc,  
        information_schema.key_column_usage kc  
    where 
        tc.constraint_type = 'PRIMARY KEY' 
        and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
        and kc.constraint_name = tc.constraint_name limit 1;

    -- asutus_id changed
    IF(coalesce(asutus_new.asutus_id, 0) != coalesce(asutus_old.asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutus_id');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutus_id,
        asutus_new.asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- registrikood changed
    IF(coalesce(asutus_new.registrikood, ' ') != coalesce(asutus_old.registrikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('registrikood');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.registrikood,
        asutus_new.registrikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- registrikood2 changed
    IF(coalesce(asutus_new.registrikood2, ' ') != coalesce(asutus_old.registrikood2, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('registrikood2');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.registrikood2,
        asutus_new.registrikood2,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
    
    -- e_registrikood changed
    IF(coalesce(asutus_new.e_registrikood, ' ') != coalesce(asutus_old.e_registrikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_registrikood');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_registrikood,
        asutus_new.e_registrikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ks_asutus_id changed
    IF(coalesce(asutus_new.ks_asutus_id, 0) != coalesce(asutus_old.ks_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_id');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_id,
        asutus_new.ks_asutus_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- ks_asutus_kood changed
    IF(coalesce(asutus_new.ks_asutus_kood, ' ') != coalesce(asutus_old.ks_asutus_kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_asutus_kood');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.ks_asutus_kood,
        asutus_new.ks_asutus_kood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- nimetus changed
    IF(coalesce(asutus_new.nimetus, ' ') != coalesce(asutus_old.nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimetus');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.nimetus,
        asutus_new.nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- lnimi changed
    IF(coalesce(asutus_new.lnimi, ' ') != coalesce(asutus_old.lnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lnimi');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.lnimi,
        asutus_new.lnimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- liik1 changed
    IF(coalesce(asutus_new.liik1, ' ') != coalesce(asutus_old.liik1, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik1');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik1,
        asutus_new.liik1,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- liik2 changed
    IF(coalesce(asutus_new.liik2, ' ') != coalesce(asutus_old.liik2, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('liik2');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.liik2,
        asutus_new.liik2,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tegevusala changed
    IF(coalesce(asutus_new.tegevusala, ' ') != coalesce(asutus_old.tegevusala, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevusala');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevusala,
        asutus_new.tegevusala,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- tegevuspiirkond changed
    IF(coalesce(asutus_new.tegevuspiirkond, ' ') != coalesce(asutus_old.tegevuspiirkond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tegevuspiirkond');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.tegevuspiirkond,
        asutus_new.tegevuspiirkond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- maakond changed
    IF(coalesce(asutus_new.maakond, ' ') != coalesce(asutus_old.maakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('maakond');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.maakond,
        asutus_new.maakond,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asukoht changed
    IF(coalesce(asutus_new.asukoht, ' ') != coalesce(asutus_old.asukoht, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asukoht');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asukoht,
        asutus_new.asukoht,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aadress changed
    IF(coalesce(asutus_new.aadress, ' ') != coalesce(asutus_old.aadress, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aadress');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aadress,
        asutus_new.aadress,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- postikood changed
    IF(coalesce(asutus_new.postikood, ' ') != coalesce(asutus_old.postikood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('postikood');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.postikood,
        asutus_new.postikood,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- telefon changed
    IF(coalesce(asutus_new.telefon, ' ') != coalesce(asutus_old.telefon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('telefon');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.telefon,
        asutus_new.telefon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- faks changed
    IF(coalesce(asutus_new.faks, ' ') != coalesce(asutus_old.faks, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('faks');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.faks,
        asutus_new.faks,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- e_post changed
    IF(coalesce(asutus_new.e_post, ' ') != coalesce(asutus_old.e_post, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('e_post');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.e_post,
        asutus_new.e_post,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- www changed
    IF(coalesce(asutus_new.www, ' ') != coalesce(asutus_old.www, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('www');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.www,
        asutus_new.www,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- logo changed
    IF(coalesce(asutus_new.logo, ' ') != coalesce(asutus_old.logo, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('logo');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.logo,
        asutus_new.logo,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- asutamise_kp changed
    IF(coalesce(asutus_new.asutamise_kp, LOCALTIMESTAMP) != coalesce(asutus_old.asutamise_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutamise_kp');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.asutamise_kp,
        asutus_new.asutamise_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_nimi changed
    IF(coalesce(asutus_new.mood_akt_nimi, ' ') != coalesce(asutus_old.mood_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nimi');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nimi,
        asutus_new.mood_akt_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_nr changed
    IF(coalesce(asutus_new.mood_akt_nr, ' ') != coalesce(asutus_old.mood_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_nr');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_nr,
        asutus_new.mood_akt_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- mood_akt_kp changed
    IF(coalesce(asutus_new.mood_akt_kp, LOCALTIMESTAMP) != coalesce(asutus_old.mood_akt_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mood_akt_kp');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.mood_akt_kp,
        asutus_new.mood_akt_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_akt_nimi changed
    IF(coalesce(asutus_new.pm_akt_nimi, ' ') != coalesce(asutus_old.pm_akt_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nimi');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nimi,
        asutus_new.pm_akt_nimi,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_akt_nr changed
    IF(coalesce(asutus_new.pm_akt_nr, ' ') != coalesce(asutus_old.pm_akt_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_akt_nr');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_akt_nr,
        asutus_new.pm_akt_nr,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_kinnitamise_kp changed
    IF(coalesce(asutus_new.pm_kinnitamise_kp, LOCALTIMESTAMP) != coalesce(asutus_old.pm_kinnitamise_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kinnitamise_kp');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kinnitamise_kp,
        asutus_new.pm_kinnitamise_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- pm_kande_kp changed
    IF(coalesce(asutus_new.pm_kande_kp, LOCALTIMESTAMP) != coalesce(asutus_old.pm_kande_kp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pm_kande_kp');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.pm_kande_kp,
        asutus_new.pm_kande_kp,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- created changed
    IF(coalesce(asutus_new.created, LOCALTIMESTAMP) != coalesce(asutus_old.created, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('created');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.created,
        asutus_new.created,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- last_modified changed
    IF(coalesce(asutus_new.last_modified, LOCALTIMESTAMP) != coalesce(asutus_old.last_modified, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('last_modified');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.last_modified,
        asutus_new.last_modified,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- username changed
    IF(coalesce(asutus_new.username, ' ') != coalesce(asutus_old.username, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('username');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.username,
        asutus_new.username,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- params changed
    IF(coalesce(asutus_new.params, ' ') != coalesce(asutus_old.params, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('params');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.params,
        asutus_new.params,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhl_otse_saatmine changed
    IF(coalesce(asutus_new.dhl_otse_saatmine, 0) != coalesce(asutus_old.dhl_otse_saatmine, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_otse_saatmine');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_otse_saatmine,
        asutus_new.dhl_otse_saatmine,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhl_saatmine changed
    IF(coalesce(asutus_new.dhl_saatmine, 0) != coalesce(asutus_old.dhl_saatmine, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhl_saatmine');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhl_saatmine,
        asutus_new.dhl_saatmine,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- dhs_nimetus changed
    IF(coalesce(asutus_new.dhs_nimetus, ' ') != coalesce(asutus_old.dhs_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhs_nimetus');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhs_nimetus,
        asutus_new.dhs_nimetus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- toetatav_dvk_versioon changed
    IF(coalesce(asutus_new.toetatav_dvk_versioon, ' ') != coalesce(asutus_old.toetatav_dvk_versioon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('toetatav_dvk_versioon');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.toetatav_dvk_versioon,
        asutus_new.toetatav_dvk_versioon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- server_id changed
    IF(coalesce(asutus_new.server_id, 0) != coalesce(asutus_old.server_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('server_id');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.server_id,
        asutus_new.server_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;

    -- aar_id changed
    IF(coalesce(asutus_new.aar_id, 0) != coalesce(asutus_old.aar_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_id');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.aar_id,
        asutus_new.aar_id,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;     
    
    -- kapsel_versioon changed
    IF(coalesce(asutus_new.kapsel_versioon, ' ') != coalesce(asutus_old.kapsel_versioon, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kapsel_versioon');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.kapsel_versioon,
        asutus_new.kapsel_versioon,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF; 
 -- dhx_asutus changed
    IF(coalesce(asutus_new.dhx_asutus, -1) != coalesce(asutus_old.dhx_asutus, -1)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dhx_asutus');
      p_id := nextval('sq_logi_id');
      INSERT INTO logi(
        log_id,
        tabel,
        op,
        uidcol,
        tabel_uid,
        veerg,
        ctype,
        vana_vaartus,
        uus_vaartus,
        muutmise_aeg,
        ab_kasutaja,
        ef_kasutaja,
        kasutaja_kood,
        comm,
        created,
        last_modified,
        username,
        ametikoht,
        xtee_isikukood,
        xtee_asutus
      ) VALUES (
        p_id,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        asutus_old.dhx_asutus,
        asutus_new.dhx_asutus,
        LOCALTIMESTAMP,
        usr,
        '''',
        '''',
        '''',
        LOCALTIMESTAMP,
        LOCALTIMESTAMP,
        '''',
        0,
        current_setting('dvkxtee.xtee_isikukood'),
        current_setting('dvkxtee.xtee_asutus')
      );
    END IF;
  END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dvklog.log_asutus(asutus, asutus, character varying)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION dvklog.log_asutus(asutus, asutus, character varying) TO public;
GRANT EXECUTE ON FUNCTION dvklog.log_asutus(asutus, asutus, character varying) TO dvk_admin;
GRANT EXECUTE ON FUNCTION dvklog.log_asutus(asutus, asutus, character varying) TO dvk_user;



-- Function: "Get_Recipient_By_Id"(integer)

-- DROP FUNCTION "Get_Recipient_By_Id"(integer);

CREATE OR REPLACE FUNCTION "Get_Recipient_By_Id"(p_id integer)
  RETURNS refcursor AS
$BODY$
declare
    RC1 refcursor;

BEGIN
    open RC1 for
    select v.*
    from    vastuvotja v
    where   v.vastuvotja_id = p_id;
    return RC1;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "Get_Recipient_By_Id"(integer)
  OWNER TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_Recipient_By_Id"(integer) TO public;
GRANT EXECUTE ON FUNCTION "Get_Recipient_By_Id"(integer) TO dvk_admin;
GRANT EXECUTE ON FUNCTION "Get_Recipient_By_Id"(integer) TO dvk_user;



