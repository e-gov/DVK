
ALTER TABLE
    asutus
ADD (
    kapsel_versioon varchar2(4) default '1.0' not null
);

/

COMMENT ON COLUMN asutus.kapsel_versioon IS 'Asutuse poolt toetatud kapsli versioon.'

/

create or replace
procedure Get_AsutusByID(
    id in number,
    registrikood out varchar2,
    registrikood_vana out varchar2,
    ks_asutuse_id out number,
    ks_asutuse_kood out varchar2,
    nimetus out varchar2,
    nime_lyhend out varchar2,
    liik1 out varchar2,
    liik2 out varchar2,
    tegevusala out varchar2,
    tegevuspiirkond out varchar2,
    maakond out varchar2,
    asukoht out varchar2,
    aadress out varchar2,
    postikood out varchar2,
    telefon out varchar2,
    faks out varchar2,
    e_post out varchar2,
    www out varchar2,
    logo out varchar2,
    asutamise_kp out timestamp,
    mood_akt_nimi out varchar2,
    mood_akt_nr out varchar2,
    mood_akt_kp out timestamp,
    pm_akt_nimi out varchar2,
    pm_akt_nr out varchar2,
    pm_kinnitamise_kp out timestamp,
    pm_kande_kp out timestamp,
    loodud out timestamp,
    muudetud out timestamp,
    muutja out varchar2,
    parameetrid out varchar2,
    dhl_saatmine out number,
    dhl_otse_saatmine out number,
    dhs_nimetus out varchar2,
    toetatav_dvk_versioon out varchar2,
    server_id out number,
    aar_id out number,
    kapsel_versioon out varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.asutus_id = Get_AsutusByID.id
            and rownum < 2;

    if cnt > 0 then
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
                a.kapsel_versioon
        into    Get_AsutusByID.registrikood,
                Get_AsutusByID.registrikood_vana,
                Get_AsutusByID.ks_asutuse_id,
                Get_AsutusByID.ks_asutuse_kood,
                Get_AsutusByID.nimetus,
                Get_AsutusByID.nime_lyhend,
                Get_AsutusByID.liik1,
                Get_AsutusByID.liik2,
                Get_AsutusByID.tegevusala,
                Get_AsutusByID.tegevuspiirkond,
                Get_AsutusByID.maakond,
                Get_AsutusByID.asukoht,
                Get_AsutusByID.aadress,
                Get_AsutusByID.postikood,
                Get_AsutusByID.telefon,
                Get_AsutusByID.faks,
                Get_AsutusByID.e_post,
                Get_AsutusByID.www,
                Get_AsutusByID.logo,
                Get_AsutusByID.asutamise_kp,
                Get_AsutusByID.mood_akt_nimi,
                Get_AsutusByID.mood_akt_nr,
                Get_AsutusByID.mood_akt_kp,
                Get_AsutusByID.pm_akt_nimi,
                Get_AsutusByID.pm_akt_nr,
                Get_AsutusByID.pm_kinnitamise_kp,
                Get_AsutusByID.pm_kande_kp,
                Get_AsutusByID.loodud,
                Get_AsutusByID.muudetud,
                Get_AsutusByID.muutja,
                Get_AsutusByID.parameetrid,
                Get_AsutusByID.dhl_saatmine,
                Get_AsutusByID.dhl_otse_saatmine,
                Get_AsutusByID.dhs_nimetus,
                Get_AsutusByID.toetatav_dvk_versioon,
                Get_AsutusByID.server_id,
                Get_AsutusByID.aar_id,
                Get_AsutusByID.kapsel_versioon
        from    asutus a
        where   a.asutus_id = Get_AsutusByID.id
                and rownum < 2;
    else
        Get_AsutusByID.registrikood := null;
        Get_AsutusByID.registrikood_vana := null;
        Get_AsutusByID.ks_asutuse_id := null;
        Get_AsutusByID.ks_asutuse_kood := null;
        Get_AsutusByID.nimetus := null;
        Get_AsutusByID.nime_lyhend := null;
        Get_AsutusByID.liik1 := null;
        Get_AsutusByID.liik2 := null;
        Get_AsutusByID.tegevusala := null;
        Get_AsutusByID.tegevuspiirkond := null;
        Get_AsutusByID.maakond := null;
        Get_AsutusByID.asukoht := null;
        Get_AsutusByID.aadress := null;
        Get_AsutusByID.postikood := null;
        Get_AsutusByID.telefon := null;
        Get_AsutusByID.faks := null;
        Get_AsutusByID.e_post := null;
        Get_AsutusByID.www := null;
        Get_AsutusByID.logo := null;
        Get_AsutusByID.asutamise_kp := null;
        Get_AsutusByID.mood_akt_nimi := null;
        Get_AsutusByID.mood_akt_nr := null;
        Get_AsutusByID.mood_akt_kp := null;
        Get_AsutusByID.pm_akt_nimi := null;
        Get_AsutusByID.pm_akt_nr := null;
        Get_AsutusByID.pm_kinnitamise_kp := null;
        Get_AsutusByID.pm_kande_kp := null;
        Get_AsutusByID.loodud := null;
        Get_AsutusByID.muudetud := null;
        Get_AsutusByID.muutja := null;
        Get_AsutusByID.parameetrid := null;
        Get_AsutusByID.dhl_saatmine := null;
        Get_AsutusByID.dhl_otse_saatmine := null;
        Get_AsutusByID.dhs_nimetus := null;
        Get_AsutusByID.toetatav_dvk_versioon := null;
        Get_AsutusByID.server_id := null;
        Get_AsutusByID.aar_id := null;
        Get_AsutusByID.kapsel_versioon := null;
    end if;
end;
/

create or replace
procedure Get_AsutusByRegNr(
    registrikood in varchar2,
    id out number,
    registrikood_vana out varchar2,
    ks_asutuse_id out number,
    ks_asutuse_kood out varchar2,
    nimetus out varchar2,
    nime_lyhend out varchar2,
    liik1 out varchar2,
    liik2 out varchar2,
    tegevusala out varchar2,
    tegevuspiirkond out varchar2,
    maakond out varchar2,
    asukoht out varchar2,
    aadress out varchar2,
    postikood out varchar2,
    telefon out varchar2,
    faks out varchar2,
    e_post out varchar2,
    www out varchar2,
    logo out varchar2,
    asutamise_kp out timestamp,
    mood_akt_nimi out varchar2,
    mood_akt_nr out varchar2,
    mood_akt_kp out timestamp,
    pm_akt_nimi out varchar2,
    pm_akt_nr out varchar2,
    pm_kinnitamise_kp out timestamp,
    pm_kande_kp out timestamp,
    loodud out timestamp,
    muudetud out timestamp,
    muutja out varchar2,
    parameetrid out varchar2,
    dhl_saatmine out number,
    dhl_otse_saatmine out number,
    dhs_nimetus out varchar2,
    toetatav_dvk_versioon out varchar2,
    server_id out number,
    aar_id out number,
    kapsel_versioon out varchar2)
as
cnt number(38,0) := 0;
begin
    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Get_AsutusByRegNr.registrikood
            and rownum < 2;

    if cnt > 0 then
        select  a.asutus_id,
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
                a.kapsel_versioon
        into    Get_AsutusByRegNr.id,
                Get_AsutusByRegNr.registrikood_vana,
                Get_AsutusByRegNr.ks_asutuse_id,
                Get_AsutusByRegNr.ks_asutuse_kood,
                Get_AsutusByRegNr.nimetus,
                Get_AsutusByRegNr.nime_lyhend,
                Get_AsutusByRegNr.liik1,
                Get_AsutusByRegNr.liik2,
                Get_AsutusByRegNr.tegevusala,
                Get_AsutusByRegNr.tegevuspiirkond,
                Get_AsutusByRegNr.maakond,
                Get_AsutusByRegNr.asukoht,
                Get_AsutusByRegNr.aadress,
                Get_AsutusByRegNr.postikood,
                Get_AsutusByRegNr.telefon,
                Get_AsutusByRegNr.faks,
                Get_AsutusByRegNr.e_post,
                Get_AsutusByRegNr.www,
                Get_AsutusByRegNr.logo,
                Get_AsutusByRegNr.asutamise_kp,
                Get_AsutusByRegNr.mood_akt_nimi,
                Get_AsutusByRegNr.mood_akt_nr,
                Get_AsutusByRegNr.mood_akt_kp,
                Get_AsutusByRegNr.pm_akt_nimi,
                Get_AsutusByRegNr.pm_akt_nr,
                Get_AsutusByRegNr.pm_kinnitamise_kp,
                Get_AsutusByRegNr.pm_kande_kp,
                Get_AsutusByRegNr.loodud,
                Get_AsutusByRegNr.muudetud,
                Get_AsutusByRegNr.muutja,
                Get_AsutusByRegNr.parameetrid,
                Get_AsutusByRegNr.dhl_saatmine,
                Get_AsutusByRegNr.dhl_otse_saatmine,
                Get_AsutusByRegNr.dhs_nimetus,
                Get_AsutusByRegNr.toetatav_dvk_versioon,
                Get_AsutusByRegNr.server_id,
                Get_AsutusByRegNr.aar_id,
                Get_AsutusByRegNr.kapsel_versioon
        from    asutus a
        where   a.registrikood = Get_AsutusByRegNr.registrikood
                and rownum < 2;
    else
        Get_AsutusByRegNr.id := null;
        Get_AsutusByRegNr.registrikood_vana := null;
        Get_AsutusByRegNr.ks_asutuse_id := null;
        Get_AsutusByRegNr.ks_asutuse_kood := null;
        Get_AsutusByRegNr.nimetus := null;
        Get_AsutusByRegNr.nime_lyhend := null;
        Get_AsutusByRegNr.liik1 := null;
        Get_AsutusByRegNr.liik2 := null;
        Get_AsutusByRegNr.tegevusala := null;
        Get_AsutusByRegNr.tegevuspiirkond := null;
        Get_AsutusByRegNr.maakond := null;
        Get_AsutusByRegNr.asukoht := null;
        Get_AsutusByRegNr.aadress := null;
        Get_AsutusByRegNr.postikood := null;
        Get_AsutusByRegNr.telefon := null;
        Get_AsutusByRegNr.faks := null;
        Get_AsutusByRegNr.e_post := null;
        Get_AsutusByRegNr.www := null;
        Get_AsutusByRegNr.logo := null;
        Get_AsutusByRegNr.asutamise_kp := null;
        Get_AsutusByRegNr.mood_akt_nimi := null;
        Get_AsutusByRegNr.mood_akt_nr := null;
        Get_AsutusByRegNr.mood_akt_kp := null;
        Get_AsutusByRegNr.pm_akt_nimi := null;
        Get_AsutusByRegNr.pm_akt_nr := null;
        Get_AsutusByRegNr.pm_kinnitamise_kp := null;
        Get_AsutusByRegNr.pm_kande_kp := null;
        Get_AsutusByRegNr.loodud := null;
        Get_AsutusByRegNr.muudetud := null;
        Get_AsutusByRegNr.muutja := null;
        Get_AsutusByRegNr.parameetrid := null;
        Get_AsutusByRegNr.dhl_saatmine := null;
        Get_AsutusByRegNr.dhl_otse_saatmine := null;
        Get_AsutusByRegNr.dhs_nimetus := null;
        Get_AsutusByRegNr.toetatav_dvk_versioon := null;
        Get_AsutusByRegNr.server_id := null;
        Get_AsutusByRegNr.aar_id := null;
        Get_AsutusByRegNr.kapsel_versioon := null;
    end if;
end;
/

create or replace
procedure Add_Asutus(
    id out number,
    registrikood in varchar2,
    registrikood_vana in varchar2,
    ks_asutuse_id in number,
    ks_asutuse_kood in varchar2,
    nimetus in varchar2,
    nime_lyhend in varchar2,
    liik1 in varchar2,
    liik2 in varchar2,
    tegevusala in varchar2,
    tegevuspiirkond in varchar2,
    maakond in varchar2,
    asukoht in varchar2,
    aadress in varchar2,
    postikood in varchar2,
    telefon in varchar2,
    faks in varchar2,
    e_post in varchar2,
    www in varchar2,
    logo in varchar2,
    asutamise_kp in timestamp,
    mood_akt_nimi in varchar2,
    mood_akt_nr in varchar2,
    mood_akt_kp in timestamp,
    pm_akt_nimi in varchar2,
    pm_akt_nr in varchar2,
    pm_kinnitamise_kp in timestamp,
    pm_kande_kp in timestamp,
    loodud in timestamp,
    muudetud in timestamp,
    muutja in varchar2,
    parameetrid in varchar2,
    dhl_saatmine in number,
    dhl_otse_saatmine in number,
    dhs_nimetus in varchar2,
    toetatav_dvk_versioon in varchar2,
    server_id in number,
    aar_id in number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2,
    kapsel_versioon in varchar2)
as
cnt number(38,0) := 0;
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Add_Asutus.xtee_isikukood;
    DVKLOG.xtee_asutus := Add_Asutus.xtee_asutus;

    select  count(*)
    into    cnt
    from    asutus a
    where   a.registrikood = Add_Asutus.registrikood
            and rownum < 2;

    if cnt < 1 then
        insert
        into    asutus(
                asutus_id,
                registrikood,
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
                kapsel_versioon)
        values  (0,
                Add_Asutus.registrikood,
                Add_Asutus.registrikood_vana,
                Add_Asutus.ks_asutuse_id,
                Add_Asutus.ks_asutuse_kood,
                Add_Asutus.nimetus,
                Add_Asutus.nime_lyhend,
                Add_Asutus.liik1,
                Add_Asutus.liik2,
                Add_Asutus.tegevusala,
                Add_Asutus.tegevuspiirkond,
                Add_Asutus.maakond,
                Add_Asutus.asukoht,
                Add_Asutus.aadress,
                Add_Asutus.postikood,
                Add_Asutus.telefon,
                Add_Asutus.faks,
                Add_Asutus.e_post,
                Add_Asutus.www,
                Add_Asutus.logo,
                Add_Asutus.asutamise_kp,
                Add_Asutus.mood_akt_nimi,
                Add_Asutus.mood_akt_nr,
                Add_Asutus.mood_akt_kp,
                Add_Asutus.pm_akt_nimi,
                Add_Asutus.pm_akt_nr,
                Add_Asutus.pm_kinnitamise_kp,
                Add_Asutus.pm_kande_kp,
                Add_Asutus.loodud,
                Add_Asutus.muudetud,
                Add_Asutus.muutja,
                Add_Asutus.parameetrid,
                Add_Asutus.dhl_saatmine,
                Add_Asutus.dhl_otse_saatmine,
                Add_Asutus.dhs_nimetus,
                Add_Asutus.toetatav_dvk_versioon,
                Add_Asutus.server_id,
                Add_Asutus.aar_id,
                Add_Asutus.kapsel_versioon);

        Add_Asutus.id := globalPkg.identity;
    else
        select  a.asutus_id
        into    Add_Asutus.id
        from    asutus a
        where   a.registrikood = Add_Asutus.registrikood
                and rownum < 2;
    end if;
end;
/

create or replace
procedure Update_Asutus(
    id in number,
    registrikood in varchar2,
    registrikood_vana in varchar2,
    ks_asutuse_id in number,
    ks_asutuse_kood in varchar2,
    nimetus in varchar2,
    nime_lyhend in varchar2,
    liik1 in varchar2,
    liik2 in varchar2,
    tegevusala in varchar2,
    tegevuspiirkond in varchar2,
    maakond in varchar2,
    asukoht in varchar2,
    aadress in varchar2,
    postikood in varchar2,
    telefon in varchar2,
    faks in varchar2,
    e_post in varchar2,
    www in varchar2,
    logo in varchar2,
    asutamise_kp in timestamp,
    mood_akt_nimi in varchar2,
    mood_akt_nr in varchar2,
    mood_akt_kp in timestamp,
    pm_akt_nimi in varchar2,
    pm_akt_nr in varchar2,
    pm_kinnitamise_kp in timestamp,
    pm_kande_kp in timestamp,
    loodud in timestamp,
    muudetud in timestamp,
    muutja in varchar2,
    parameetrid in varchar2,
    dhl_saatmine in number,
    dhl_otse_saatmine in number,
    dhs_nimetus in varchar2,
    toetatav_dvk_versioon in varchar2,
    server_id in number,
    aar_id in number,
    xtee_isikukood in varchar2,
    xtee_asutus in varchar2,
    kapsel_versioon in varchar2)
as
begin

    -- Set session scope variables
    DVKLOG.xtee_isikukood := Update_Asutus.xtee_isikukood;
    DVKLOG.xtee_asutus := Update_Asutus.xtee_asutus;

    update  asutus
    set     registrikood = Update_Asutus.registrikood,
            e_registrikood = Update_Asutus.registrikood_vana,
            ks_asutus_id = Update_Asutus.ks_asutuse_id,
            ks_asutus_kood = Update_Asutus.ks_asutuse_kood,
            nimetus = Update_Asutus.nimetus,
            lnimi = Update_Asutus.nime_lyhend,
            liik1 = Update_Asutus.liik1,
            liik2 = Update_Asutus.liik2,
            tegevusala = Update_Asutus.tegevusala,
            tegevuspiirkond = Update_Asutus.tegevuspiirkond,
            maakond = Update_Asutus.maakond,
            asukoht = Update_Asutus.asukoht,
            aadress = Update_Asutus.aadress,
            postikood = Update_Asutus.postikood,
            telefon = Update_Asutus.telefon,
            faks = Update_Asutus.faks,
            e_post = Update_Asutus.e_post,
            www = Update_Asutus.www,
            logo = Update_Asutus.logo,
            asutamise_kp = Update_Asutus.asutamise_kp,
            mood_akt_nimi = Update_Asutus.mood_akt_nimi,
            mood_akt_nr = Update_Asutus.mood_akt_nr,
            mood_akt_kp = Update_Asutus.mood_akt_kp,
            pm_akt_nimi = Update_Asutus.pm_akt_nimi,
            pm_akt_nr = Update_Asutus.pm_akt_nr,
            pm_kinnitamise_kp = Update_Asutus.pm_kinnitamise_kp,
            pm_kande_kp = Update_Asutus.pm_kande_kp,
            created = Update_Asutus.loodud,
            last_modified = Update_Asutus.muudetud,
            username = Update_Asutus.muutja,
            params = Update_Asutus.parameetrid,
            dhl_saatmine = Update_Asutus.dhl_saatmine,
            dhl_otse_saatmine = Update_Asutus.dhl_otse_saatmine,
            dhs_nimetus = Update_Asutus.dhs_nimetus,
            toetatav_dvk_versioon = Update_Asutus.toetatav_dvk_versioon,
            server_id = Update_Asutus.server_id,
            aar_id = Update_Asutus.aar_id,
            kapsel_versioon = Update_Asutus.kapsel_versioon
    where   asutus_id = Update_Asutus.id;
end;
/

-- Kompileerib kõik schema objektid, vajalik, sest tabelit muudeti
EXEC DBMS_UTILITY.compile_schema(schema => 'DVK');

/

DECLARE

    v_inputFile VARCHAR2(100) := 'dvk_v2_1_to_v1_0.xsl';
    v_dir VARCHAR2(100) := 'DIR_TEMP_KONV';
    v_conversion_id konversioon.id%TYPE;

    dest_clob   CLOB;
    src_clob    BFILE  := BFILENAME(v_dir, v_inputFile);
    dst_offset  number := 1 ;
    src_offset  number := 1 ;
    lang_ctx    number := DBMS_LOB.DEFAULT_LANG_CTX;
    warning     number;

BEGIN

  -- insert a NULL record to lock
  INSERT INTO konversioon (
    version,
    result_version,
    xslt
  ) VALUES (
    21,
    1,
    EMPTY_CLOB()
  ) RETURNING id INTO v_conversion_id;

  -- lock record
  SELECT xslt
  INTO dest_clob
  FROM konversioon
  WHERE id = v_conversion_id FOR UPDATE;

  DBMS_LOB.OPEN(src_clob, DBMS_LOB.LOB_READONLY);

  DBMS_LOB.LoadCLOBFromFile(
          DEST_LOB     => dest_clob
        , SRC_BFILE    => src_clob
        , AMOUNT       => DBMS_LOB.GETLENGTH(src_clob)
        , DEST_OFFSET  => dst_offset
        , SRC_OFFSET   => src_offset
        , BFILE_CSID   => DBMS_LOB.DEFAULT_CSID
        , LANG_CONTEXT => lang_ctx
        , WARNING      => warning
    );

  -- update the blob field
  UPDATE konversioon
  SET xslt = dest_clob
  WHERE id = v_conversion_id;

  -- close file
  dbms_lob.fileclose(src_clob);

  EXCEPTION
    WHEN OTHERS THEN
      dbms_lob.fileclose(src_clob);

END;
/
