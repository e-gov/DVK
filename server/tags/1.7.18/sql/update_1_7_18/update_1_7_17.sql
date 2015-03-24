CREATE OR REPLACE FUNCTION "Add_Proxy" (
    p_sending_id integer,
    p_organization_id integer,
    p_position_id integer,
    p_division_id integer,
    p_personal_id_code character varying,
    p_email character varying,
    p_name character varying,
    p_organization_name character varying,
    p_department_nr character varying,
    p_department_name character varying,
    p_position_short_name character varying,
    p_division_short_name character varying,
    p_xtee_isikukood character varying,
    p_xtee_asutus character varying)
RETURNS integer AS $$
DECLARE
    organization_id_ integer := p_organization_id;
    position_id_ integer := p_position_id;
    division_id_ integer := p_division_id;
    p_id int4;
BEGIN
    -- Set session scope variables
    set dvkxtee.xtee_isikukood = p_xtee_isikukood;
    set dvkxtee.xtee_asutus = p_xtee_asutus;

    if organization_id_ = 0 then
        organization_id_ := null;
    end if;
    if position_id_ = 0 then
        position_id_ := null;
    end if;
    if division_id_ = 0 then
        division_id_ := null;
    end if;

    p_id := nextval('sq_vahendaja_id');

    insert
    into    vahendaja(
            vahendaja_id,
            transport_id,
            asutus_id,
            ametikoht_id,
            allyksus_id,
            isikukood,
            nimi,
            asutuse_nimi,
            email,
            osakonna_nr,
            osakonna_nimi,
            ametikoha_lyhinimetus,
            allyksuse_lyhinimetus)
    values  (p_id,
            p_sending_id,
            organization_id_,
            position_id_,
            division_id_,
            p_personal_id_code,
            p_name,
            p_organization_name,
            p_email,
            p_department_nr,
            p_department_name,
            p_position_short_name,
            p_division_short_name);

    RETURN  p_id;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Add_Ametikoht" (
    p_ks_ametikoht_id integer,
    p_asutus_id integer,
    p_nimetus character varying,
    p_alates timestamp,
    p_kuni timestamp,
    p_created timestamp,
    p_last_modified timestamp,
    p_username character varying,
    p_allyksus_id integer,
    p_params character varying,
    p_lyhinimetus character varying,
    p_aar_id integer)
RETURNS integer AS $$
DECLARE
    ks_ametikoht_id_ integer := p_ks_ametikoht_id;
    asutus_id_ integer := p_asutus_id;
    allyksus_id_ integer := p_allyksus_id;
    aar_id_ integer := p_aar_id;
    p_id int4;
BEGIN
    IF ks_ametikoht_id_ = 0 then
        ks_ametikoht_id_ := null;
    END IF;
    IF asutus_id_ = 0 then
        asutus_id_ := null;
    END IF;
    IF allyksus_id_ = 0 then
        allyksus_id_ := null;
    END IF;
    IF aar_id_ = 0 then
        aar_id_ := null;
    END IF;

    p_id := nextval('sq_ametikoht_id');

    INSERT
    INTO    ametikoht(
            ametikoht_id,
            ks_ametikoht_id,
            asutus_id,
            ametikoht_nimetus,
            alates,
            kuni,
            created,
            last_modified,
            username,
            allyksus_id,
            params,
            lyhinimetus,
            aar_id)
    VALUES  (p_id,
            ks_ametikoht_id_,
            asutus_id_,
            p_nimetus,
            p_alates,
            p_kuni,
            p_created,
            p_last_modified,
            p_username,
            allyksus_id_,
            p_params,
            p_lyhinimetus,
            aar_id_);
    RETURN  p_id;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "Update_Ametikoht" (
    p_id integer,
    p_ks_ametikoht_id integer,
    p_asutus_id integer,
    p_nimetus character varying,
    p_alates timestamp,
    p_kuni timestamp,
    p_created timestamp,
    p_last_modified timestamp,
    p_username text,
    p_allyksus_id integer,
    p_params character varying,
    p_lyhinimetus character varying,
    p_aar_id integer)
 RETURNS VOID AS $$
DECLARE

    ks_ametikoht_id_ integer := p_ks_ametikoht_id;
    asutus_id_ integer := p_asutus_id;
    allyksus_id_ integer := p_allyksus_id;
    aar_id_ integer := p_aar_id;

BEGIN
    if ks_ametikoht_id_ = 0 then
        ks_ametikoht_id_ := null;
    end if;
    if asutus_id_ = 0 then
        asutus_id_ := null;
    end if;
    if allyksus_id_ = 0 then
        allyksus_id_ := null;
    end if;
    if aar_id_ = 0 then
        aar_id_ := null;
    end if;

    update  ametikoht
    set     ks_ametikoht_id = ks_ametikoht_id_,
            asutus_id = asutus_id_,
            ametikoht_nimetus = p_nimetus,
            alates = p_alates,
            kuni = p_kuni,
            created = p_created,
            last_modified = p_last_modified,
            username = p_username,
            allyksus_id = allyksus_id_,
            params = p_params,
            lyhinimetus = p_lyhinimetus,
            aar_id = aar_id_
    where   ametikoht_id = p_id;
end;$$
LANGUAGE PLPGSQL;
