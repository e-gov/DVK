CREATE OR REPLACE FUNCTION tr_vastuvotja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_new vastuvotja%ROWTYPE;
	vastuvotja_old vastuvotja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  vastuvotja_new.VASTUVOTJA_ID := new.VASTUVOTJA_ID;
		  vastuvotja_new.TRANSPORT_ID := new.TRANSPORT_ID;
		  vastuvotja_new.ASUTUS_ID := new.ASUTUS_ID;
		  vastuvotja_new.AMETIKOHT_ID := new.AMETIKOHT_ID;
		  vastuvotja_new.ISIKUKOOD := new.ISIKUKOOD;
		  vastuvotja_new.NIMI := new.NIMI;
		  vastuvotja_new.EMAIL := new.EMAIL;
		  vastuvotja_new.OSAKONNA_NR := new.OSAKONNA_NR;
		  vastuvotja_new.OSAKONNA_NIMI := new.OSAKONNA_NIMI;
		  vastuvotja_new.SAATMISVIIS_ID := new.SAATMISVIIS_ID;
		  vastuvotja_new.STAATUS_ID := new.STAATUS_ID;
		  vastuvotja_new.SAATMISE_ALGUS := new.SAATMISE_ALGUS;
		  vastuvotja_new.SAATMISE_LOPP := new.SAATMISE_LOPP;
		  vastuvotja_new.FAULT_CODE := new.FAULT_CODE;
		  vastuvotja_new.FAULT_ACTOR := new.FAULT_ACTOR;
		  vastuvotja_new.FAULT_STRING := new.FAULT_STRING;
		  vastuvotja_new.FAULT_DETAIL := new.FAULT_DETAIL;
		  vastuvotja_new.VASTUVOTJA_STAATUS_ID := new.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_new.METAXML := new.METAXML;
		  vastuvotja_new.ASUTUSE_NIMI := new.ASUTUSE_NIMI;
		  vastuvotja_new.ALLYKSUS_ID := new.ALLYKSUS_ID;
		  vastuvotja_new.DOK_ID_TEISES_SERVERIS := new.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_new.ALLYKSUSE_LYHINIMETUS := new.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_new.AMETIKOHA_LYHINIMETUS := new.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  vastuvotja_old.VASTUVOTJA_ID := old.VASTUVOTJA_ID;
		  vastuvotja_old.TRANSPORT_ID := old.TRANSPORT_ID;
		  vastuvotja_old.ASUTUS_ID := old.ASUTUS_ID;
		  vastuvotja_old.AMETIKOHT_ID := old.AMETIKOHT_ID;
		  vastuvotja_old.ISIKUKOOD := old.ISIKUKOOD;
		  vastuvotja_old.NIMI := old.NIMI;
		  vastuvotja_old.EMAIL := old.EMAIL;
		  vastuvotja_old.OSAKONNA_NR := old.OSAKONNA_NR;
		  vastuvotja_old.OSAKONNA_NIMI := old.OSAKONNA_NIMI;
		  vastuvotja_old.SAATMISVIIS_ID := old.SAATMISVIIS_ID;
		  vastuvotja_old.STAATUS_ID := old.STAATUS_ID;
		  vastuvotja_old.SAATMISE_ALGUS := old.SAATMISE_ALGUS;
		  vastuvotja_old.SAATMISE_LOPP := old.SAATMISE_LOPP;
		  vastuvotja_old.FAULT_CODE := old.FAULT_CODE;
		  vastuvotja_old.FAULT_ACTOR := old.FAULT_ACTOR;
		  vastuvotja_old.FAULT_STRING := old.FAULT_STRING;
		  vastuvotja_old.FAULT_DETAIL := old.FAULT_DETAIL;
		  vastuvotja_old.VASTUVOTJA_STAATUS_ID := old.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_old.METAXML := old.METAXML;
		  vastuvotja_old.ASUTUSE_NIMI := old.ASUTUSE_NIMI;
		  vastuvotja_old.ALLYKSUS_ID := old.ALLYKSUS_ID;
		  vastuvotja_old.DOK_ID_TEISES_SERVERIS := old.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_old.ALLYKSUSE_LYHINIMETUS := old.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_old.AMETIKOHA_LYHINIMETUS := old.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  vastuvotja_old.VASTUVOTJA_ID := old.VASTUVOTJA_ID;
		  vastuvotja_old.TRANSPORT_ID := old.TRANSPORT_ID;
		  vastuvotja_old.ASUTUS_ID := old.ASUTUS_ID;
		  vastuvotja_old.AMETIKOHT_ID := old.AMETIKOHT_ID;
		  vastuvotja_old.ISIKUKOOD := old.ISIKUKOOD;
		  vastuvotja_old.NIMI := old.NIMI;
		  vastuvotja_old.EMAIL := old.EMAIL;
		  vastuvotja_old.OSAKONNA_NR := old.OSAKONNA_NR;
		  vastuvotja_old.OSAKONNA_NIMI := old.OSAKONNA_NIMI;
		  vastuvotja_old.SAATMISVIIS_ID := old.SAATMISVIIS_ID;
		  vastuvotja_old.STAATUS_ID := old.STAATUS_ID;
		  vastuvotja_old.SAATMISE_ALGUS := old.SAATMISE_ALGUS;
		  vastuvotja_old.SAATMISE_LOPP := old.SAATMISE_LOPP;
		  vastuvotja_old.FAULT_CODE := old.FAULT_CODE;
		  vastuvotja_old.FAULT_ACTOR := old.FAULT_ACTOR;
		  vastuvotja_old.FAULT_STRING := old.FAULT_STRING;
		  vastuvotja_old.FAULT_DETAIL := old.FAULT_DETAIL;
		  vastuvotja_old.VASTUVOTJA_STAATUS_ID := old.VASTUVOTJA_STAATUS_ID;
		  vastuvotja_old.METAXML := old.METAXML;
		  vastuvotja_old.ASUTUSE_NIMI := old.ASUTUSE_NIMI;
		  vastuvotja_old.ALLYKSUS_ID := old.ALLYKSUS_ID;
		  vastuvotja_old.DOK_ID_TEISES_SERVERIS := old.DOK_ID_TEISES_SERVERIS;
		  vastuvotja_old.ALLYKSUSE_LYHINIMETUS := old.ALLYKSUSE_LYHINIMETUS;
		  vastuvotja_old.AMETIKOHA_LYHINIMETUS := old.AMETIKOHA_LYHINIMETUS;
	  end if;	
	  
	  execute dvklog.log_vastuvotja(vastuvotja_new, vastuvotja_old, tr_operation);       		  	  
	  IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
END;$$ 
LANGUAGE PLPGSQL;    





CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja (
    vastuvotja_new dvk.vastuvotja,
    vastuvotja_old dvk.vastuvotja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja';
    primary_key_value integer := vastuvotja_old.vastuvotja_id;	
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

		
    -- vastuvotja_id changed
    IF(coalesce(vastuvotja_new.vastuvotja_id, 0) != coalesce(vastuvotja_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');

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
        vastuvotja_old.vastuvotja_id,
        vastuvotja_new.vastuvotja_id,
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

    -- transport_id changed
    IF(coalesce(vastuvotja_new.transport_id, 0) != coalesce(vastuvotja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');

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
        vastuvotja_old.transport_id,
        vastuvotja_new.transport_id,
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

    -- asutus_id changed
    IF(coalesce(vastuvotja_new.asutus_id, 0) != coalesce(vastuvotja_old.asutus_id, 0)) THEN
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
        vastuvotja_old.asutus_id,
        vastuvotja_new.asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(vastuvotja_new.ametikoht_id, 0) != coalesce(vastuvotja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');

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
        vastuvotja_old.ametikoht_id,
        vastuvotja_new.ametikoht_id,
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

    -- isikukood changed
    IF(coalesce(vastuvotja_new.isikukood, ' ') != coalesce(vastuvotja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');

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
        vastuvotja_old.isikukood,
        vastuvotja_new.isikukood,
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

    -- nimi changed
    IF(coalesce(vastuvotja_new.nimi, ' ') != coalesce(vastuvotja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');

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
        vastuvotja_old.nimi,
        vastuvotja_new.nimi,
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

    -- email changed
    IF(coalesce(vastuvotja_new.email, ' ') != coalesce(vastuvotja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');

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
        vastuvotja_old.email,
        vastuvotja_new.email,
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

    -- osakonna_nr changed
    IF(coalesce(vastuvotja_new.osakonna_nr, ' ') != coalesce(vastuvotja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');

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
        vastuvotja_old.osakonna_nr,
        vastuvotja_new.osakonna_nr,
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

    -- osakonna_nimi changed
    IF(coalesce(vastuvotja_new.osakonna_nimi, ' ') != coalesce(vastuvotja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');

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
        vastuvotja_old.osakonna_nimi,
        vastuvotja_new.osakonna_nimi,
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

    -- saatmisviis_id changed
    IF(coalesce(vastuvotja_new.saatmisviis_id, 0) != coalesce(vastuvotja_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
	
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
        vastuvotja_old.saatmisviis_id,
        vastuvotja_new.saatmisviis_id,
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

    -- staatus_id changed
    IF(coalesce(vastuvotja_new.staatus_id, 0) != coalesce(vastuvotja_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');

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
        vastuvotja_old.staatus_id,
        vastuvotja_new.staatus_id,
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

    -- saatmise_algus changed
    IF(coalesce(vastuvotja_new.saatmise_algus, LOCALTIMESTAMP) != coalesce(vastuvotja_old.saatmise_algus, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');

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
        vastuvotja_old.saatmise_algus,
        vastuvotja_new.saatmise_algus,
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

    -- saatmise_lopp changed
    IF(coalesce(vastuvotja_new.saatmise_lopp, LOCALTIMESTAMP) != coalesce(vastuvotja_old.saatmise_lopp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');

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
        vastuvotja_old.saatmise_lopp,
        vastuvotja_new.saatmise_lopp,
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

    -- fault_code changed
    IF(coalesce(vastuvotja_new.fault_code, ' ') != coalesce(vastuvotja_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');

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
        vastuvotja_old.fault_code,
        vastuvotja_new.fault_code,
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

    -- fault_actor changed
    IF(coalesce(vastuvotja_new.fault_actor, ' ') != coalesce(vastuvotja_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');

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
        vastuvotja_old.fault_actor,
        vastuvotja_new.fault_actor,
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

    -- fault_string changed
    IF(coalesce(vastuvotja_new.fault_string, ' ') != coalesce(vastuvotja_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');

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
        vastuvotja_old.fault_string,
        vastuvotja_new.fault_string,
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

    -- fault_detail changed
    IF(coalesce(vastuvotja_new.fault_detail, ' ') != coalesce(vastuvotja_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');

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
        vastuvotja_old.fault_detail,
        vastuvotja_new.fault_detail,
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

    -- vastuvotja_staatus_id changed
    IF(coalesce(vastuvotja_new.vastuvotja_staatus_id, 0) != coalesce(vastuvotja_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');

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
        vastuvotja_old.vastuvotja_staatus_id,
        vastuvotja_new.vastuvotja_staatus_id,
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

    -- asutuse_nimi changed
    IF(coalesce(vastuvotja_new.asutuse_nimi, ' ') != coalesce(vastuvotja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');

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
        vastuvotja_old.asutuse_nimi,
        vastuvotja_new.asutuse_nimi,
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

    -- allyksus_id changed
    IF(coalesce(vastuvotja_new.allyksus_id, 0) != coalesce(vastuvotja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');

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
        vastuvotja_old.allyksus_id,
        vastuvotja_new.allyksus_id,
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

    -- dok_id_teises_serveris changed
    IF(coalesce(vastuvotja_new.dok_id_teises_serveris, 0) != coalesce(vastuvotja_old.dok_id_teises_serveris, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dok_id_teises_serveris');

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
        vastuvotja_old.dok_id_teises_serveris,
        vastuvotja_new.dok_id_teises_serveris,
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

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vastuvotja_new.allyksuse_lyhinimetus, ' ') != coalesce(vastuvotja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
	  
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
        vastuvotja_old.allyksuse_lyhinimetus,
        vastuvotja_new.allyksuse_lyhinimetus,
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

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vastuvotja_new.ametikoha_lyhinimetus, ' ') != coalesce(vastuvotja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');

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
        vastuvotja_old.ametikoha_lyhinimetus,
        vastuvotja_new.ametikoha_lyhinimetus,
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
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_allkiri_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	allkiri_new allkiri%ROWTYPE;
	allkiri_old allkiri%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  allkiri_new.ALLKIRI_ID := NEW.ALLKIRI_ID;
		  allkiri_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  allkiri_new.EESNIMI := NEW.EESNIMI;
		  allkiri_new.PERENIMI := NEW.PERENIMI;
		  allkiri_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  allkiri_new.KUUPAEV := NEW.KUUPAEV;
		  allkiri_new.ROLL := NEW.ROLL;
		  allkiri_new.RIIK := NEW.RIIK;
		  allkiri_new.MAAKOND := NEW.MAAKOND;
		  allkiri_new.LINN := NEW.LINN;
		  allkiri_new.INDEKS := NEW.INDEKS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  allkiri_old.ALLKIRI_ID := OLD.ALLKIRI_ID;
		  allkiri_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  allkiri_old.EESNIMI := OLD.EESNIMI;
		  allkiri_old.PERENIMI := OLD.PERENIMI;
		  allkiri_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  allkiri_old.KUUPAEV := OLD.KUUPAEV;
		  allkiri_old.ROLL := OLD.ROLL;
		  allkiri_old.RIIK := OLD.RIIK;
		  allkiri_old.MAAKOND := OLD.MAAKOND;
		  allkiri_old.LINN := OLD.LINN;
		  allkiri_old.INDEKS := OLD.INDEKS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  allkiri_old.ALLKIRI_ID := OLD.ALLKIRI_ID;
		  allkiri_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  allkiri_old.EESNIMI := OLD.EESNIMI;
		  allkiri_old.PERENIMI := OLD.PERENIMI;
		  allkiri_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  allkiri_old.KUUPAEV := OLD.KUUPAEV;
		  allkiri_old.ROLL := OLD.ROLL;
		  allkiri_old.RIIK := OLD.RIIK;
		  allkiri_old.MAAKOND := OLD.MAAKOND;
		  allkiri_old.LINN := OLD.LINN;
		  allkiri_old.INDEKS := OLD.INDEKS;
	  end if;	
	  
      
	  execute dvklog.log_allkiri(allkiri_new, allkiri_old, tr_operation);       		  
	  IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_allkiri (
    allkiri_new dvk.allkiri,
    allkiri_old dvk.allkiri,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'allkiri';
    primary_key_value integer := allkiri_old.allkiri_id;	
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

		
    -- allkiri_id changed
    IF(coalesce(allkiri_new.allkiri_id, 0) != coalesce(allkiri_old.allkiri_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allkiri_id');
      
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
        allkiri_old.allkiri_id,
        allkiri_new.allkiri_id,
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

    -- dokument_id changed
    IF(coalesce(allkiri_new.dokument_id, 0) != coalesce(allkiri_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');

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
        allkiri_old.dokument_id,
        allkiri_new.dokument_id,
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

    -- eesnimi changed
    IF(coalesce(allkiri_new.eesnimi, ' ') != coalesce(allkiri_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
	  
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
        allkiri_old.eesnimi,
        allkiri_new.eesnimi,
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

    -- perenimi changed
    IF(coalesce(allkiri_new.perenimi, ' ') != coalesce(allkiri_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
	  
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
        allkiri_old.perenimi,
        allkiri_new.perenimi,
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

    -- isikukood changed
    IF(coalesce(allkiri_new.isikukood, ' ') != coalesce(allkiri_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
	  
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
        allkiri_old.isikukood,
        allkiri_new.isikukood,
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

    -- kuupaev changed
    IF(coalesce(allkiri_new.kuupaev, LOCALTIMESTAMP) != coalesce(allkiri_old.kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuupaev');

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
        allkiri_old.kuupaev,
        allkiri_new.kuupaev,
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

    -- roll changed
    IF(coalesce(allkiri_new.roll, ' ') != coalesce(allkiri_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
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
        allkiri_old.roll,
        allkiri_new.roll,
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

    -- riik changed
    IF(coalesce(allkiri_new.riik, ' ') != coalesce(allkiri_old.riik, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('riik');
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
        allkiri_old.riik,
        allkiri_new.riik,
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
    IF(coalesce(allkiri_new.maakond, ' ') != coalesce(allkiri_old.maakond, ' ')) THEN
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
        allkiri_old.maakond,
        allkiri_new.maakond,
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

    -- linn changed
    IF(coalesce(allkiri_new.linn, ' ') != coalesce(allkiri_old.linn, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('linn');
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
        allkiri_old.linn,
        allkiri_new.linn,
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

    -- indeks changed
    IF(coalesce(allkiri_new.indeks, ' ') != coalesce(allkiri_old.indeks, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('indeks');
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
        allkiri_old.indeks,
        allkiri_new.indeks,
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

  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_allyksus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	allyksus_new allyksus%ROWTYPE;
	allyksus_old allyksus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  ALLYKSUS_new.ID := NEW.ID;
		  ALLYKSUS_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  ALLYKSUS_new.VANEM_ID := NEW.VANEM_ID;
		  ALLYKSUS_new.ALLYKSUS := NEW.ALLYKSUS;
		  ALLYKSUS_new.CREATED := NEW.CREATED;
		  ALLYKSUS_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  ALLYKSUS_new.USERNAME := NEW.USERNAME;
		  ALLYKSUS_new.MUUTM_ARV := NEW.MUUTM_ARV;
		  ALLYKSUS_new.AAR_ID := NEW.AAR_ID;
		  ALLYKSUS_new.LYHINIMETUS := NEW.LYHINIMETUS;
		  ALLYKSUS_new.ADR_URI := NEW.ADR_URI;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  ALLYKSUS_old.ID := OLD.ID;
		  ALLYKSUS_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  ALLYKSUS_old.VANEM_ID := OLD.VANEM_ID;
		  ALLYKSUS_old.ALLYKSUS := OLD.ALLYKSUS;
		  ALLYKSUS_old.CREATED := OLD.CREATED;
		  ALLYKSUS_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ALLYKSUS_old.USERNAME := OLD.USERNAME;
		  ALLYKSUS_old.MUUTM_ARV := OLD.MUUTM_ARV;
		  ALLYKSUS_old.AAR_ID := OLD.AAR_ID;
		  ALLYKSUS_old.LYHINIMETUS := OLD.LYHINIMETUS;
		  ALLYKSUS_old.ADR_URI := OLD.ADR_URI;	   
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
   		  ALLYKSUS_old.ID := OLD.ID;
		  ALLYKSUS_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  ALLYKSUS_old.VANEM_ID := OLD.VANEM_ID;
		  ALLYKSUS_old.ALLYKSUS := OLD.ALLYKSUS;
		  ALLYKSUS_old.CREATED := OLD.CREATED;
		  ALLYKSUS_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ALLYKSUS_old.USERNAME := OLD.USERNAME;
		  ALLYKSUS_old.MUUTM_ARV := OLD.MUUTM_ARV;
		  ALLYKSUS_old.AAR_ID := OLD.AAR_ID;
		  ALLYKSUS_old.LYHINIMETUS := OLD.LYHINIMETUS;
		  ALLYKSUS_old.ADR_URI := OLD.ADR_URI;		  
	  end if;	
	  
	  execute dvklog.log_allyksus(allyksus_new, allyksus_old, tr_operation);       		  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_allyksus (
    allyksus_new dvk.allyksus,
    allyksus_old dvk.allyksus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'allyksus';
    primary_key_value integer := allyksus_old.id;	
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

    -- id changed
    IF(coalesce(allyksus_new.id, 0) != coalesce(allyksus_old.id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
	  
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
        allyksus_old.id,
        allyksus_new.id,
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

    -- asutus_id changed
    IF(coalesce(allyksus_new.asutus_id, 0) != coalesce(allyksus_old.asutus_id, 0)) THEN
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
        allyksus_old.asutus_id,
        allyksus_new.asutus_id,
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

    -- vanem_id changed
    IF(coalesce(allyksus_new.vanem_id, 0) != coalesce(allyksus_old.vanem_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vanem_id');
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
        allyksus_old.vanem_id,
        allyksus_new.vanem_id,
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

    -- allyksus changed
    IF(coalesce(allyksus_new.allyksus, ' ') != coalesce(allyksus_old.allyksus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus');
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
        allyksus_old.allyksus,
        allyksus_new.allyksus,
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
    IF(coalesce(allyksus_new.created, LOCALTIMESTAMP) != coalesce(allyksus_old.created, LOCALTIMESTAMP)) THEN
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
        allyksus_old.created,
        allyksus_new.created,
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
    IF(coalesce(allyksus_new.last_modified, LOCALTIMESTAMP) != coalesce(allyksus_old.last_modified, LOCALTIMESTAMP)) THEN
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
        allyksus_old.last_modified,
        allyksus_new.last_modified,
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
    IF(coalesce(allyksus_new.username, ' ') != coalesce(allyksus_old.username, ' ')) THEN
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
        allyksus_old.username,
        allyksus_new.username,
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

    -- muutm_arv changed
    IF(coalesce(allyksus_new.muutm_arv, 0) != coalesce(allyksus_old.muutm_arv, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutm_arv');
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
        allyksus_old.muutm_arv,
        allyksus_new.muutm_arv,
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
    IF(coalesce(allyksus_new.aar_id, 0) != coalesce(allyksus_old.aar_id, 0)) THEN
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
        allyksus_old.aar_id,
        allyksus_new.aar_id,
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

    -- lyhinimetus changed
    IF(coalesce(allyksus_new.lyhinimetus, ' ') != coalesce(allyksus_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
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
        allyksus_old.lyhinimetus,
        allyksus_new.lyhinimetus,
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

    -- adr_uri changed
    IF(coalesce(allyksus_new.adr_uri, ' ') != coalesce(allyksus_old.adr_uri, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('adr_uri');
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
        allyksus_old.adr_uri,
        allyksus_new.adr_uri,
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
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_ametikoht_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ametikoht_new ametikoht%ROWTYPE;
	ametikoht_old ametikoht%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  AMETIKOHT_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  AMETIKOHT_new.KS_AMETIKOHT_ID := NEW.KS_AMETIKOHT_ID;
		  AMETIKOHT_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  AMETIKOHT_new.AMETIKOHT_NIMETUS := NEW.AMETIKOHT_NIMETUS;
		  AMETIKOHT_new.ALATES := NEW.ALATES;
		  AMETIKOHT_new.KUNI := NEW.KUNI;
		  AMETIKOHT_new.CREATED := NEW.CREATED;
		  AMETIKOHT_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  AMETIKOHT_new.USERNAME := NEW.USERNAME;
		  AMETIKOHT_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  AMETIKOHT_new.PARAMS := NEW.PARAMS;
		  AMETIKOHT_new.AAR_ID := NEW.AAR_ID;
		  AMETIKOHT_new.LYHINIMETUS := NEW.LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  AMETIKOHT_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_old.KS_AMETIKOHT_ID := OLD.KS_AMETIKOHT_ID;
		  AMETIKOHT_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  AMETIKOHT_old.AMETIKOHT_NIMETUS := OLD.AMETIKOHT_NIMETUS;
		  AMETIKOHT_old.ALATES := OLD.ALATES;
		  AMETIKOHT_old.KUNI := OLD.KUNI;
		  AMETIKOHT_old.CREATED := OLD.CREATED;
		  AMETIKOHT_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  AMETIKOHT_old.PARAMS := OLD.PARAMS;
		  AMETIKOHT_old.AAR_ID := OLD.AAR_ID;
		  AMETIKOHT_old.LYHINIMETUS := OLD.LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  AMETIKOHT_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_old.KS_AMETIKOHT_ID := OLD.KS_AMETIKOHT_ID;
		  AMETIKOHT_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  AMETIKOHT_old.AMETIKOHT_NIMETUS := OLD.AMETIKOHT_NIMETUS;
		  AMETIKOHT_old.ALATES := OLD.ALATES;
		  AMETIKOHT_old.KUNI := OLD.KUNI;
		  AMETIKOHT_old.CREATED := OLD.CREATED;
		  AMETIKOHT_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  AMETIKOHT_old.PARAMS := OLD.PARAMS;
		  AMETIKOHT_old.AAR_ID := OLD.AAR_ID;
		  AMETIKOHT_old.LYHINIMETUS := OLD.LYHINIMETUS;
	  end if;	

	  execute dvklog.log_ametikoht(ametikoht_new, ametikoht_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_ametikoht (
    ametikoht_new dvk.ametikoht,
    ametikoht_old dvk.ametikoht,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ametikoht';    
    primary_key_value integer := ametikoht_old.ametikoht_id;	
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

    -- ametikoht_id changed
    IF(coalesce(ametikoht_new.ametikoht_id, 0) != coalesce(ametikoht_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        ametikoht_old.ametikoht_id,
        ametikoht_new.ametikoht_id,
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

    -- ks_ametikoht_id changed
    IF(coalesce(ametikoht_new.ks_ametikoht_id, 0) != coalesce(ametikoht_old.ks_ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ks_ametikoht_id');
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
        ametikoht_old.ks_ametikoht_id,
        ametikoht_new.ks_ametikoht_id,
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

    -- asutus_id changed
    IF(coalesce(ametikoht_new.asutus_id, 0) != coalesce(ametikoht_old.asutus_id, 0)) THEN
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
        ametikoht_old.asutus_id,
        ametikoht_new.asutus_id,
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

    -- ametikoht_nimetus changed
    IF(coalesce(ametikoht_new.ametikoht_nimetus, ' ') != coalesce(ametikoht_old.ametikoht_nimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_nimetus');
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
        ametikoht_old.ametikoht_nimetus,
        ametikoht_new.ametikoht_nimetus,
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

    -- alates changed
    IF(coalesce(ametikoht_new.alates, LOCALTIMESTAMP) != coalesce(ametikoht_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
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
        ametikoht_old.alates,
        ametikoht_new.alates,
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

    -- kuni changed
    IF(coalesce(ametikoht_new.kuni, LOCALTIMESTAMP) != coalesce(ametikoht_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
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
        ametikoht_old.kuni,
        ametikoht_new.kuni,
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
    IF(coalesce(ametikoht_new.created, LOCALTIMESTAMP) != coalesce(ametikoht_old.created, LOCALTIMESTAMP)) THEN
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
        ametikoht_old.created,
        ametikoht_new.created,
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
    IF(coalesce(ametikoht_new.last_modified, LOCALTIMESTAMP) != coalesce(ametikoht_old.last_modified, LOCALTIMESTAMP)) THEN
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
        ametikoht_old.last_modified,
        ametikoht_new.last_modified,
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
    IF(coalesce(ametikoht_new.username, ' ') != coalesce(ametikoht_old.username, ' ')) THEN
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
        ametikoht_old.username,
        ametikoht_new.username,
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

    -- allyksus_id changed
    IF(coalesce(ametikoht_new.allyksus_id, 0) != coalesce(ametikoht_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
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
        ametikoht_old.allyksus_id,
        ametikoht_new.allyksus_id,
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
    IF(coalesce(ametikoht_new.params, ' ') != coalesce(ametikoht_old.params, ' ')) THEN
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
        ametikoht_old.params,
        ametikoht_new.params,
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
    IF(coalesce(ametikoht_new.aar_id, 0) != coalesce(ametikoht_old.aar_id, 0)) THEN
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
        ametikoht_old.aar_id,
        ametikoht_new.aar_id,
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

    -- lyhinimetus changed
    IF(coalesce(ametikoht_new.lyhinimetus, ' ') != coalesce(ametikoht_old.lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('lyhinimetus');
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
        ametikoht_old.lyhinimetus,
        ametikoht_new.lyhinimetus,
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
		
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_ametikoht_taitmine_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ametikoht_taitmine_new ametikoht_taitmine%ROWTYPE;
	ametikoht_taitmine_old ametikoht_taitmine%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  AMETIKOHT_TAITMINE_new.TAITMINE_ID := NEW.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_new.I_ID := NEW.I_ID;
		  AMETIKOHT_TAITMINE_new.ALATES := NEW.ALATES;
		  AMETIKOHT_TAITMINE_new.KUNI := NEW.KUNI;
		  AMETIKOHT_TAITMINE_new.ROLL := NEW.ROLL;
		  AMETIKOHT_TAITMINE_new.CREATED := NEW.CREATED;
		  AMETIKOHT_TAITMINE_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_new.USERNAME := NEW.USERNAME;
		  AMETIKOHT_TAITMINE_new.PEATATUD := NEW.PEATATUD;
		  AMETIKOHT_TAITMINE_new.AAR_ID := NEW.AAR_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  AMETIKOHT_TAITMINE_old.TAITMINE_ID := OLD.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_old.I_ID := OLD.I_ID;
		  AMETIKOHT_TAITMINE_old.ALATES := OLD.ALATES;
		  AMETIKOHT_TAITMINE_old.KUNI := OLD.KUNI;
		  AMETIKOHT_TAITMINE_old.ROLL := OLD.ROLL;
		  AMETIKOHT_TAITMINE_old.CREATED := OLD.CREATED;
		  AMETIKOHT_TAITMINE_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_TAITMINE_old.PEATATUD := OLD.PEATATUD;
		  AMETIKOHT_TAITMINE_old.AAR_ID := OLD.AAR_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  AMETIKOHT_TAITMINE_old.TAITMINE_ID := OLD.TAITMINE_ID;
		  AMETIKOHT_TAITMINE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  AMETIKOHT_TAITMINE_old.I_ID := OLD.I_ID;
		  AMETIKOHT_TAITMINE_old.ALATES := OLD.ALATES;
		  AMETIKOHT_TAITMINE_old.KUNI := OLD.KUNI;
		  AMETIKOHT_TAITMINE_old.ROLL := OLD.ROLL;
		  AMETIKOHT_TAITMINE_old.CREATED := OLD.CREATED;
		  AMETIKOHT_TAITMINE_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  AMETIKOHT_TAITMINE_old.USERNAME := OLD.USERNAME;
		  AMETIKOHT_TAITMINE_old.PEATATUD := OLD.PEATATUD;
		  AMETIKOHT_TAITMINE_old.AAR_ID := OLD.AAR_ID;
	  end if;	

	  execute dvklog.log_ametikoht_taitmine(ametikoht_taitmine_new, ametikoht_taitmine_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_ametikoht_taitmine (
    ametikoht_taitmine_new dvk.ametikoht_taitmine,
    ametikoht_taitmine_old dvk.ametikoht_taitmine,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ametikoht_taitmine';    
    primary_key_value integer := ametikoht_taitmine_old.taitmine_id;
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
		
    -- taitmine_id changed
    IF(coalesce(ametikoht_taitmine_new.taitmine_id, 0) != coalesce(ametikoht_taitmine_old.taitmine_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('taitmine_id');
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
        ametikoht_taitmine_old.taitmine_id,
        ametikoht_taitmine_new.taitmine_id,
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

    -- ametikoht_id changed
    IF(coalesce(ametikoht_taitmine_new.ametikoht_id, 0) != coalesce(ametikoht_taitmine_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        ametikoht_taitmine_old.ametikoht_id,
        ametikoht_taitmine_new.ametikoht_id,
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

    -- i_id changed
    IF(coalesce(ametikoht_taitmine_new.i_id, 0) != coalesce(ametikoht_taitmine_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
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
        ametikoht_taitmine_old.i_id,
        ametikoht_taitmine_new.i_id,
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

    -- alates changed
    IF(coalesce(ametikoht_taitmine_new.alates, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
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
        ametikoht_taitmine_old.alates,
        ametikoht_taitmine_new.alates,
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

    -- kuni changed
    IF(coalesce(ametikoht_taitmine_new.kuni, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
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
        ametikoht_taitmine_old.kuni,
        ametikoht_taitmine_new.kuni,
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

    -- roll changed
    IF(coalesce(ametikoht_taitmine_new.roll, ' ') != coalesce(ametikoht_taitmine_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
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
        ametikoht_taitmine_old.roll,
        ametikoht_taitmine_new.roll,
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
    IF(coalesce(ametikoht_taitmine_new.created, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.created, LOCALTIMESTAMP)) THEN
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
        ametikoht_taitmine_old.created,
        ametikoht_taitmine_new.created,
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
    IF(coalesce(ametikoht_taitmine_new.last_modified, LOCALTIMESTAMP) != coalesce(ametikoht_taitmine_old.last_modified, LOCALTIMESTAMP)) THEN
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
        ametikoht_taitmine_old.last_modified,
        ametikoht_taitmine_new.last_modified,
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
    IF(coalesce(ametikoht_taitmine_new.username, ' ') != coalesce(ametikoht_taitmine_old.username, ' ')) THEN
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
        ametikoht_taitmine_old.username,
        ametikoht_taitmine_new.username,
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

    -- peatatud changed
    IF(coalesce(ametikoht_taitmine_new.peatatud, 0) != coalesce(ametikoht_taitmine_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
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
        ametikoht_taitmine_old.peatatud,
        ametikoht_taitmine_new.peatatud,
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
    IF(coalesce(ametikoht_taitmine_new.aar_id, 0) != coalesce(ametikoht_taitmine_old.aar_id, 0)) THEN
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
        ametikoht_taitmine_old.aar_id,
        ametikoht_taitmine_new.aar_id,
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
			
  END;$$
LANGUAGE PLPGSQL;
	

CREATE OR REPLACE FUNCTION tr_asutus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	asutus_new asutus%ROWTYPE;
	asutus_old asutus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  asutus_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  asutus_new.REGISTRIKOOD := NEW.REGISTRIKOOD;
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
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';		  		  
		  asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
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
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  asutus_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  asutus_old.REGISTRIKOOD := OLD.REGISTRIKOOD;
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
	  end if;	
	  
	  execute dvklog.log_asutus(asutus_new, asutus_old, tr_operation);       		  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 
	  
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_asutus (
    asutus_new dvk.asutus,
    asutus_old dvk.asutus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
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
  END;$$
LANGUAGE PLPGSQL;
		
		
		
CREATE OR REPLACE FUNCTION tr_dokumendi_ajalugu_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_ajalugu_new dokumendi_ajalugu%ROWTYPE;
	dokumendi_ajalugu_old dokumendi_ajalugu%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_AJALUGU_new.AJALUGU_ID := NEW.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_new.METAINFO := NEW.METAINFO;
		  DOKUMENDI_AJALUGU_new.TRANSPORT := NEW.TRANSPORT;
		  DOKUMENDI_AJALUGU_new.METAXML := NEW.METAXML;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DOKUMENDI_AJALUGU_old.AJALUGU_ID := OLD.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_old.METAINFO := OLD.METAINFO;
		  DOKUMENDI_AJALUGU_old.TRANSPORT := OLD.TRANSPORT;
		  DOKUMENDI_AJALUGU_old.METAXML := OLD.METAXML;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_AJALUGU_old.AJALUGU_ID := OLD.AJALUGU_ID;
		  DOKUMENDI_AJALUGU_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_AJALUGU_old.METAINFO := OLD.METAINFO;
		  DOKUMENDI_AJALUGU_old.TRANSPORT := OLD.TRANSPORT;
		  DOKUMENDI_AJALUGU_old.METAXML := OLD.METAXML;
	  end if;	

	  execute dvklog.log_dokumendi_ajalugu(dokumendi_ajalugu_new, dokumendi_ajalugu_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    



		
CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_ajalugu (
    dokumendi_ajalugu_new dvk.dokumendi_ajalugu,
    dokumendi_ajalugu_old dvk.dokumendi_ajalugu,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_ajalugu';    
    primary_key_value integer := dokumendi_ajalugu_old.ajalugu_id;
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

    -- ajalugu_id changed
    IF(coalesce(dokumendi_ajalugu_new.ajalugu_id, 0) != coalesce(dokumendi_ajalugu_old.ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ajalugu_id');
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
        dokumendi_ajalugu_old.ajalugu_id,
        dokumendi_ajalugu_new.ajalugu_id,
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

    -- dokument_id changed
    IF(coalesce(dokumendi_ajalugu_new.dokument_id, 0) != coalesce(dokumendi_ajalugu_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        dokumendi_ajalugu_old.dokument_id,
        dokumendi_ajalugu_new.dokument_id,
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
  END;$$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION tr_dokumendi_fail_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_fail_new dokumendi_fail%ROWTYPE;
	dokumendi_fail_old dokumendi_fail%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_FAIL_new.FAIL_ID := NEW.FAIL_ID;
		  DOKUMENDI_FAIL_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_FAIL_new.NIMI := NEW.NIMI;
		  DOKUMENDI_FAIL_new.SUURUS := NEW.SUURUS;
		  DOKUMENDI_FAIL_new.MIME_TYYP := NEW.MIME_TYYP;
		  DOKUMENDI_FAIL_new.SISU := NEW.SISU;
		  DOKUMENDI_FAIL_new.POHIFAIL := NEW.POHIFAIL;
		  DOKUMENDI_FAIL_new.VALINE_MANUS := NEW.VALINE_MANUS;
	   elsif tg_op = 'UPDATE' then    
	      tr_operation := 'UPDATE'; 		  		  
		  DOKUMENDI_FAIL_old.FAIL_ID := OLD.FAIL_ID;
		  DOKUMENDI_FAIL_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_FAIL_old.NIMI := OLD.NIMI;
		  DOKUMENDI_FAIL_old.SUURUS := OLD.SUURUS;
		  DOKUMENDI_FAIL_old.MIME_TYYP := OLD.MIME_TYYP;
		  DOKUMENDI_FAIL_old.SISU := OLD.SISU;
		  DOKUMENDI_FAIL_old.POHIFAIL := OLD.POHIFAIL;
		  DOKUMENDI_FAIL_old.VALINE_MANUS := OLD.VALINE_MANUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_FAIL_old.FAIL_ID := OLD.FAIL_ID;
		  DOKUMENDI_FAIL_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_FAIL_old.NIMI := OLD.NIMI;
		  DOKUMENDI_FAIL_old.SUURUS := OLD.SUURUS;
		  DOKUMENDI_FAIL_old.MIME_TYYP := OLD.MIME_TYYP;
		  DOKUMENDI_FAIL_old.SISU := OLD.SISU;
		  DOKUMENDI_FAIL_old.POHIFAIL := OLD.POHIFAIL;
		  DOKUMENDI_FAIL_old.VALINE_MANUS := OLD.VALINE_MANUS;
	  end if;	

	  execute dvklog.log_dokumendi_fail(dokumendi_fail_new, dokumendi_fail_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_fail (
    dokumendi_fail_new dvk.dokumendi_fail,
    dokumendi_fail_old dvk.dokumendi_fail,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_fail';    
	primary_key_value integer := dokumendi_fail_old.fail_id;
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


    -- fail_id changed
    IF(coalesce(dokumendi_fail_new.fail_id, 0) != coalesce(dokumendi_fail_old.fail_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fail_id');
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
        dokumendi_fail_old.fail_id,
        dokumendi_fail_new.fail_id,
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

    -- dokument_id changed
    IF(coalesce(dokumendi_fail_new.dokument_id, 0) != coalesce(dokumendi_fail_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        dokumendi_fail_old.dokument_id,
        dokumendi_fail_new.dokument_id,
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

    -- nimi changed
    IF(coalesce(dokumendi_fail_new.nimi, ' ') != coalesce(dokumendi_fail_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        dokumendi_fail_old.nimi,
        dokumendi_fail_new.nimi,
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

    -- suurus changed
    IF(coalesce(dokumendi_fail_new.suurus, 0) != coalesce(dokumendi_fail_old.suurus, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('suurus');
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
        dokumendi_fail_old.suurus,
        dokumendi_fail_new.suurus,
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

    -- mime_tyyp changed
    IF(coalesce(dokumendi_fail_new.mime_tyyp, ' ') != coalesce(dokumendi_fail_old.mime_tyyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('mime_tyyp');
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
        dokumendi_fail_old.mime_tyyp,
        dokumendi_fail_new.mime_tyyp,
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

    -- pohifail changed
    IF(coalesce(dokumendi_fail_new.pohifail, 0) != coalesce(dokumendi_fail_old.pohifail, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('pohifail');
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
        dokumendi_fail_old.pohifail,
        dokumendi_fail_new.pohifail,
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

    -- valine_manus changed
    IF(coalesce(dokumendi_fail_new.valine_manus, 0) != coalesce(dokumendi_fail_old.valine_manus, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('valine_manus');
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
        dokumendi_fail_old.valine_manus,
        dokumendi_fail_new.valine_manus,
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
		
  END;$$
LANGUAGE PLPGSQL;






CREATE OR REPLACE FUNCTION tr_dokumendi_metaandmed_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokumendi_metaandmed_new dokumendi_metaandmed%ROWTYPE;
	dokumendi_metaandmed_old dokumendi_metaandmed%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DOKUMENDI_METAANDMED_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NR := NEW.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_new.SAAJA_ASUTUSE_NR := NEW.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINIMI := NEW.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDITYYP := NEW.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_DOKUMENDINR := NEW.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_FAILINIMI := NEW.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KATALOOG := NEW.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_VOTMESONA := NEW.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KOKKUVOTE := NEW.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_KUUPAEV := NEW.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_NIMI := NEW.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_new.KOOSTAJA_ASUTUSE_KONTAKT := NEW.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_new.AUTORI_OSAKOND := NEW.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_new.AUTORI_ISIKUKOOD := NEW.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_new.AUTORI_NIMI := NEW.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_new.AUTORI_KONTAKT := NEW.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_KOOSTAJAL := NEW.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DOKUMENDINR_SAAJAL := NEW.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_new.SAATJA_DOKUMENDINR := NEW.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_new.SAATJA_KUUPAEV := NEW.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_new.SAATJA_ASUTUSE_KONTAKT := NEW.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_new.SAAJA_ISIKUKOOD := NEW.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_new.SAAJA_NIMI := NEW.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_new.SAAJA_OSAKOND := NEW.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_new.SEOTUD_DHL_ID := NEW.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_new.KOMMENTAAR := NEW.KOMMENTAAR;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DOKUMENDI_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NR := OLD.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.SAAJA_ASUTUSE_NR := OLD.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINIMI := OLD.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDITYYP := OLD.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINR := OLD.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_FAILINIMI := OLD.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KATALOOG := OLD.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_VOTMESONA := OLD.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KOKKUVOTE := OLD.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KUUPAEV := OLD.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NIMI := OLD.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_KONTAKT := OLD.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.AUTORI_OSAKOND := OLD.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_old.AUTORI_ISIKUKOOD := OLD.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.AUTORI_NIMI := OLD.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_old.AUTORI_KONTAKT := OLD.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_KOOSTAJAL := OLD.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_SAAJAL := OLD.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_old.SAATJA_DOKUMENDINR := OLD.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.SAATJA_KUUPAEV := OLD.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.SAATJA_ASUTUSE_KONTAKT := OLD.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SAAJA_ISIKUKOOD := OLD.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.SAAJA_NIMI := OLD.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_old.SAAJA_OSAKOND := OLD.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DHL_ID := OLD.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_old.KOMMENTAAR := OLD.KOMMENTAAR;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DOKUMENDI_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NR := OLD.KOOSTAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.SAAJA_ASUTUSE_NR := OLD.SAAJA_ASUTUSE_NR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINIMI := OLD.KOOSTAJA_DOKUMENDINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDITYYP := OLD.KOOSTAJA_DOKUMENDITYYP;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_DOKUMENDINR := OLD.KOOSTAJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_FAILINIMI := OLD.KOOSTAJA_FAILINIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KATALOOG := OLD.KOOSTAJA_KATALOOG;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_VOTMESONA := OLD.KOOSTAJA_VOTMESONA;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KOKKUVOTE := OLD.KOOSTAJA_KOKKUVOTE;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_KUUPAEV := OLD.KOOSTAJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_NIMI := OLD.KOOSTAJA_ASUTUSE_NIMI;
		  DOKUMENDI_METAANDMED_old.KOOSTAJA_ASUTUSE_KONTAKT := OLD.KOOSTAJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.AUTORI_OSAKOND := OLD.AUTORI_OSAKOND;
		  DOKUMENDI_METAANDMED_old.AUTORI_ISIKUKOOD := OLD.AUTORI_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.AUTORI_NIMI := OLD.AUTORI_NIMI;
		  DOKUMENDI_METAANDMED_old.AUTORI_KONTAKT := OLD.AUTORI_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_KOOSTAJAL := OLD.SEOTUD_DOKUMENDINR_KOOSTAJAL;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DOKUMENDINR_SAAJAL := OLD.SEOTUD_DOKUMENDINR_SAAJAL;
		  DOKUMENDI_METAANDMED_old.SAATJA_DOKUMENDINR := OLD.SAATJA_DOKUMENDINR;
		  DOKUMENDI_METAANDMED_old.SAATJA_KUUPAEV := OLD.SAATJA_KUUPAEV;
		  DOKUMENDI_METAANDMED_old.SAATJA_ASUTUSE_KONTAKT := OLD.SAATJA_ASUTUSE_KONTAKT;
		  DOKUMENDI_METAANDMED_old.SAAJA_ISIKUKOOD := OLD.SAAJA_ISIKUKOOD;
		  DOKUMENDI_METAANDMED_old.SAAJA_NIMI := OLD.SAAJA_NIMI;
		  DOKUMENDI_METAANDMED_old.SAAJA_OSAKOND := OLD.SAAJA_OSAKOND;
		  DOKUMENDI_METAANDMED_old.SEOTUD_DHL_ID := OLD.SEOTUD_DHL_ID;
		  DOKUMENDI_METAANDMED_old.KOMMENTAAR := OLD.KOMMENTAAR;
	  end if;	

	  execute dvklog.log_dokumendi_metaandmed(dokumendi_metaandmed_new, dokumendi_metaandmed_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_metaandmed (
    dokumendi_metaandmed_new dvk.dokumendi_metaandmed,
    dokumendi_metaandmed_old dvk.dokumendi_metaandmed,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_metaandmed';    
	primary_key_value integer := dokumendi_metaandmed_old.dokument_id;
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
		
		
		
    -- dokument_id changed
    IF(coalesce(dokumendi_metaandmed_new.dokument_id, 0) != coalesce(dokumendi_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        dokumendi_metaandmed_old.dokument_id,
        dokumendi_metaandmed_new.dokument_id,
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

    -- koostaja_asutuse_nr changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_nr, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nr');
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
        dokumendi_metaandmed_old.koostaja_asutuse_nr,
        dokumendi_metaandmed_new.koostaja_asutuse_nr,
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

    -- saaja_asutuse_nr changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_asutuse_nr, ' ') != coalesce(dokumendi_metaandmed_old.saaja_asutuse_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_asutuse_nr');
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
        dokumendi_metaandmed_old.saaja_asutuse_nr,
        dokumendi_metaandmed_new.saaja_asutuse_nr,
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

    -- koostaja_dokumendinimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendinimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendinimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinimi');
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
        dokumendi_metaandmed_old.koostaja_dokumendinimi,
        dokumendi_metaandmed_new.koostaja_dokumendinimi,
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

    -- koostaja_dokumendityyp changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendityyp, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendityyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendityyp');
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
        dokumendi_metaandmed_old.koostaja_dokumendityyp,
        dokumendi_metaandmed_new.koostaja_dokumendityyp,
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

    -- koostaja_dokumendinr changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_dokumendinr, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_dokumendinr');
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
        dokumendi_metaandmed_old.koostaja_dokumendinr,
        dokumendi_metaandmed_new.koostaja_dokumendinr,
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

    -- koostaja_failinimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_failinimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_failinimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_failinimi');
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
        dokumendi_metaandmed_old.koostaja_failinimi,
        dokumendi_metaandmed_new.koostaja_failinimi,
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

    -- koostaja_kataloog changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kataloog, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_kataloog, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kataloog');
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
        dokumendi_metaandmed_old.koostaja_kataloog,
        dokumendi_metaandmed_new.koostaja_kataloog,
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

    -- koostaja_votmesona changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_votmesona, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_votmesona, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_votmesona');
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
        dokumendi_metaandmed_old.koostaja_votmesona,
        dokumendi_metaandmed_new.koostaja_votmesona,
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

    -- koostaja_kokkuvote changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kokkuvote, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_kokkuvote, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kokkuvote');
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
        dokumendi_metaandmed_old.koostaja_kokkuvote,
        dokumendi_metaandmed_new.koostaja_kokkuvote,
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

    -- koostaja_kuupaev changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_kuupaev, LOCALTIMESTAMP) != coalesce(dokumendi_metaandmed_old.koostaja_kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_kuupaev');
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
        dokumendi_metaandmed_old.koostaja_kuupaev,
        dokumendi_metaandmed_new.koostaja_kuupaev,
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

    -- koostaja_asutuse_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_nimi, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_nimi');
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
        dokumendi_metaandmed_old.koostaja_asutuse_nimi,
        dokumendi_metaandmed_new.koostaja_asutuse_nimi,
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

    -- koostaja_asutuse_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.koostaja_asutuse_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.koostaja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('koostaja_asutuse_kontakt');
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
        dokumendi_metaandmed_old.koostaja_asutuse_kontakt,
        dokumendi_metaandmed_new.koostaja_asutuse_kontakt,
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

    -- autori_osakond changed
    IF(coalesce(dokumendi_metaandmed_new.autori_osakond, ' ') != coalesce(dokumendi_metaandmed_old.autori_osakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_osakond');
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
        dokumendi_metaandmed_old.autori_osakond,
        dokumendi_metaandmed_new.autori_osakond,
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

    -- autori_isikukood changed
    IF(coalesce(dokumendi_metaandmed_new.autori_isikukood, ' ') != coalesce(dokumendi_metaandmed_old.autori_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_isikukood');
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
        dokumendi_metaandmed_old.autori_isikukood,
        dokumendi_metaandmed_new.autori_isikukood,
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

    -- autori_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.autori_nimi, ' ') != coalesce(dokumendi_metaandmed_old.autori_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_nimi');
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
        dokumendi_metaandmed_old.autori_nimi,
        dokumendi_metaandmed_new.autori_nimi,
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

    -- autori_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.autori_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.autori_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('autori_kontakt');
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
        dokumendi_metaandmed_old.autori_kontakt,
        dokumendi_metaandmed_new.autori_kontakt,
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

    -- seotud_dokumendinr_koostajal changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dokumendinr_koostajal, ' ') != coalesce(dokumendi_metaandmed_old.seotud_dokumendinr_koostajal, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_koostajal');
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
        dokumendi_metaandmed_old.seotud_dokumendinr_koostajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_koostajal,
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

    -- seotud_dokumendinr_saajal changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dokumendinr_saajal, ' ') != coalesce(dokumendi_metaandmed_old.seotud_dokumendinr_saajal, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dokumendinr_saajal');
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
        dokumendi_metaandmed_old.seotud_dokumendinr_saajal,
        dokumendi_metaandmed_new.seotud_dokumendinr_saajal,
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

    -- saatja_dokumendinr changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_dokumendinr, ' ') != coalesce(dokumendi_metaandmed_old.saatja_dokumendinr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_dokumendinr');
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
        dokumendi_metaandmed_old.saatja_dokumendinr,
        dokumendi_metaandmed_new.saatja_dokumendinr,
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

    -- saatja_kuupaev changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_kuupaev, LOCALTIMESTAMP) != coalesce(dokumendi_metaandmed_old.saatja_kuupaev, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_kuupaev');
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
        dokumendi_metaandmed_old.saatja_kuupaev,
        dokumendi_metaandmed_new.saatja_kuupaev,
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

    -- saatja_asutuse_kontakt changed
    IF(coalesce(dokumendi_metaandmed_new.saatja_asutuse_kontakt, ' ') != coalesce(dokumendi_metaandmed_old.saatja_asutuse_kontakt, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_asutuse_kontakt');
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
        dokumendi_metaandmed_old.saatja_asutuse_kontakt,
        dokumendi_metaandmed_new.saatja_asutuse_kontakt,
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

    -- saaja_isikukood changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_isikukood, ' ') != coalesce(dokumendi_metaandmed_old.saaja_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_isikukood');
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
        dokumendi_metaandmed_old.saaja_isikukood,
        dokumendi_metaandmed_new.saaja_isikukood,
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

    -- saaja_nimi changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_nimi, ' ') != coalesce(dokumendi_metaandmed_old.saaja_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_nimi');
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
        dokumendi_metaandmed_old.saaja_nimi,
        dokumendi_metaandmed_new.saaja_nimi,
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

    -- saaja_osakond changed
    IF(coalesce(dokumendi_metaandmed_new.saaja_osakond, ' ') != coalesce(dokumendi_metaandmed_old.saaja_osakond, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saaja_osakond');
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
        dokumendi_metaandmed_old.saaja_osakond,
        dokumendi_metaandmed_new.saaja_osakond,
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

    -- seotud_dhl_id changed
    IF(coalesce(dokumendi_metaandmed_new.seotud_dhl_id, 0) != coalesce(dokumendi_metaandmed_old.seotud_dhl_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('seotud_dhl_id');
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
        dokumendi_metaandmed_old.seotud_dhl_id,
        dokumendi_metaandmed_new.seotud_dhl_id,
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

    -- kommentaar changed
    IF(coalesce(dokumendi_metaandmed_new.kommentaar, ' ') != coalesce(dokumendi_metaandmed_old.kommentaar, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kommentaar');
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
        dokumendi_metaandmed_old.kommentaar,
        dokumendi_metaandmed_new.kommentaar,
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
		
  END;$$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION tr_dokument_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dokument_new dokument%ROWTYPE;
	dokument_old dokument%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  dokument_new.dokument_id := NEW.dokument_id;
		  dokument_new.asutus_id := NEW.asutus_id;
		  dokument_new.kaust_id := NEW.kaust_id;
		  dokument_new.sailitustahtaeg := NEW.sailitustahtaeg;
		  dokument_new.eelmise_versiooni_id := NEW.eelmise_versiooni_id;
		  dokument_new.versioon := NEW.versioon;
		  dokument_new.suurus := NEW.suurus;
		  dokument_new.guid := NEW.guid;
		  dokument_new.kapsli_versioon := NEW.kapsli_versioon;		  
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  dokument_old.dokument_id := OLD.dokument_id;
		  dokument_old.asutus_id := OLD.asutus_id;
		  dokument_old.kaust_id := OLD.kaust_id;
		  dokument_old.sailitustahtaeg := OLD.sailitustahtaeg;
		  dokument_old.eelmise_versiooni_id := OLD.eelmise_versiooni_id;
		  dokument_old.versioon := OLD.versioon;
		  dokument_old.suurus := OLD.suurus;
		  dokument_old.guid := OLD.guid;
		  dokument_old.kapsli_versioon := OLD.kapsli_versioon;		  		  
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  dokument_old.dokument_id := OLD.dokument_id;
		  dokument_old.asutus_id := OLD.asutus_id;
		  dokument_old.kaust_id := OLD.kaust_id;
		  dokument_old.sailitustahtaeg := OLD.sailitustahtaeg;
		  dokument_old.eelmise_versiooni_id := OLD.eelmise_versiooni_id;
		  dokument_old.versioon := OLD.versioon;
		  dokument_old.suurus := OLD.suurus;
		  dokument_old.guid := OLD.guid;
		  dokument_old.kapsli_versioon := OLD.kapsli_versioon;		  		  
	  end if;	

	  execute dvklog.log_dokument(dokument_new, dokument_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    

		
CREATE OR REPLACE FUNCTION dvklog.log_dokument (
    dokument_new dvk.dokument,
    dokument_old dvk.dokument,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokument';    
	primary_key_value integer := dokument_old.dokument_id;
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
		
		
    -- dokument_id changed
    IF(coalesce(dokument_new.dokument_id, 0) != coalesce(dokument_old.dokument_id, 0)) THEN
      --DEBUG('dokument_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.dokument_id,
        dokument_new.dokument_id,
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

    -- asutus_id changed
    IF(coalesce(dokument_new.asutus_id, 0) != coalesce(dokument_old.asutus_id, 0)) THEN
      --DEBUG('asutus_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('asutus_id');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.asutus_id,
        dokument_new.asutus_id,
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

    -- kaust_id changed
    IF(coalesce(dokument_new.kaust_id, 0) != coalesce(dokument_old.kaust_id, 0)) THEN
      --DEBUG('kaust_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('kaust_id');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.kaust_id,
        dokument_new.kaust_id,
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

    -- sailitustahtaeg changed
    IF(coalesce(dokument_new.sailitustahtaeg, LOCALTIMESTAMP) != coalesce(dokument_old.sailitustahtaeg, LOCALTIMESTAMP)) THEN
      --DEBUG('sailitustahtaeg changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('sailitustahtaeg');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.sailitustahtaeg,
        dokument_new.sailitustahtaeg,
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

    -- eelmise_versiooni_id changed
    IF(coalesce(dokument_new.eelmise_versiooni_id, 0) != coalesce(dokument_old.eelmise_versiooni_id, 0)) THEN
      --DEBUG('eelmise_versiooni_id changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('eelmise_versiooni_id');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.eelmise_versiooni_id,
        dokument_new.eelmise_versiooni_id,
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

    -- versioon changed
    IF(coalesce(dokument_new.versioon, 0) != coalesce(dokument_old.versioon, 0)) THEN
      --DEBUG('versioon changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('versioon');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.versioon,
        dokument_new.versioon,
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

    -- suurus changed
    IF(coalesce(dokument_new.suurus, 0) != coalesce(dokument_old.suurus, 0)) THEN
      --DEBUG('suurus changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('suurus');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.suurus,
        dokument_new.suurus,
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

    -- guid changed
    IF(coalesce(dokument_new.guid, ' ') != coalesce(dokument_old.guid, ' ')) THEN
      --DEBUG('guid changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('guid');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.guid,
        dokument_new.guid,
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

    -- kapsli_versioon changed
    IF(coalesce(dokument_new.kapsli_versioon, ' ') != coalesce(dokument_old.kapsli_versioon, ' ')) THEN
      --DEBUG('kapsli_versioon changed');
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = upper('dokument') AND upper(column_name) = upper('kapsli_versioon');
	  
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
        dokument_old.dokument_id, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dokument_old.kapsli_versioon,
        dokument_new.kapsli_versioon,
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
	
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_dynaamilised_metaandmed_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	dynaamilised_metaandmed_new dynaamilised_metaandmed%ROWTYPE;
	dynaamilised_metaandmed_old dynaamilised_metaandmed%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  DYNAAMILISED_METAANDMED_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_new.NIMI := NEW.NIMI;
		  DYNAAMILISED_METAANDMED_new.VAARTUS := NEW.VAARTUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  DYNAAMILISED_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_old.NIMI := OLD.NIMI;
		  DYNAAMILISED_METAANDMED_old.VAARTUS := OLD.VAARTUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  DYNAAMILISED_METAANDMED_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  DYNAAMILISED_METAANDMED_old.NIMI := OLD.NIMI;
		  DYNAAMILISED_METAANDMED_old.VAARTUS := OLD.VAARTUS;
	  end if;	

	  execute dvklog.log_dynaamilised_metaandmed(dynaamilised_metaandmed_new, dynaamilised_metaandmed_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_dynaamilised_metaandmed (
    dynaamilised_metaandmed_new dvk.dynaamilised_metaandmed,
    dynaamilised_metaandmed_old dvk.dynaamilised_metaandmed,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dynaamilised_metaandmed';    
    primary_key_value integer := dynaamilised_metaandmed_old.dokument_id;
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
		
    -- dokument_id changed
    IF(coalesce(dynaamilised_metaandmed_new.dokument_id, 0) != coalesce(dynaamilised_metaandmed_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        dynaamilised_metaandmed_old.dokument_id,
        dynaamilised_metaandmed_new.dokument_id,
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

    -- nimi changed
    IF(coalesce(dynaamilised_metaandmed_new.nimi, ' ') != coalesce(dynaamilised_metaandmed_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        dynaamilised_metaandmed_old.nimi,
        dynaamilised_metaandmed_new.nimi,
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

    -- vaartus changed
    IF(coalesce(dynaamilised_metaandmed_new.vaartus, ' ') != coalesce(dynaamilised_metaandmed_old.vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vaartus');
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
        0,
        tablename,
        tr_operation,
        pkey_col, -- primary key column name
        primary_key_value, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        dynaamilised_metaandmed_old.vaartus,
        dynaamilised_metaandmed_new.vaartus,
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
		
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_ehak_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	ehak_new ehak%ROWTYPE;
	ehak_old ehak%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  EHAK_new.EHAK_ID := NEW.EHAK_ID;
		  EHAK_new.NIMI := NEW.NIMI;
		  EHAK_new.ROOPNIMI := NEW.ROOPNIMI;
		  EHAK_new.TYYP := NEW.TYYP;
		  EHAK_new.MAAKOND := NEW.MAAKOND;
		  EHAK_new.VALD := NEW.VALD;
		  EHAK_new.CREATED := NEW.CREATED;
		  EHAK_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  EHAK_new.USERNAME := NEW.USERNAME;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  EHAK_old.EHAK_ID := OLD.EHAK_ID;
		  EHAK_old.NIMI := OLD.NIMI;
		  EHAK_old.ROOPNIMI := OLD.ROOPNIMI;
		  EHAK_old.TYYP := OLD.TYYP;
		  EHAK_old.MAAKOND := OLD.MAAKOND;
		  EHAK_old.VALD := OLD.VALD;
		  EHAK_old.CREATED := OLD.CREATED;
		  EHAK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  EHAK_old.USERNAME := OLD.USERNAME;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  EHAK_old.EHAK_ID := OLD.EHAK_ID;
		  EHAK_old.NIMI := OLD.NIMI;
		  EHAK_old.ROOPNIMI := OLD.ROOPNIMI;
		  EHAK_old.TYYP := OLD.TYYP;
		  EHAK_old.MAAKOND := OLD.MAAKOND;
		  EHAK_old.VALD := OLD.VALD;
		  EHAK_old.CREATED := OLD.CREATED;
		  EHAK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  EHAK_old.USERNAME := OLD.USERNAME;
	  end if;	

	  execute dvklog.log_ehak(ehak_new, ehak_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    

CREATE OR REPLACE FUNCTION dvklog.log_ehak (
    ehak_new dvk.ehak,
    ehak_old dvk.ehak,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'ehak';    
    primary_key_value integer := ehak_old.ehak_id;
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

    -- ehak_id changed
    IF(coalesce(ehak_new.ehak_id, ' ') != coalesce(ehak_old.ehak_id, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ehak_id');
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
        ehak_old.ehak_id,
        ehak_new.ehak_id,
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

    -- nimi changed
    IF(coalesce(ehak_new.nimi, ' ') != coalesce(ehak_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        ehak_old.nimi,
        ehak_new.nimi,
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

    -- roopnimi changed
    IF(coalesce(ehak_new.roopnimi, ' ') != coalesce(ehak_old.roopnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roopnimi');
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
        ehak_old.roopnimi,
        ehak_new.roopnimi,
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

    -- tyyp changed
    IF(coalesce(ehak_new.tyyp, ' ') != coalesce(ehak_old.tyyp, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tyyp');
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
        ehak_old.tyyp,
        ehak_new.tyyp,
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
    IF(coalesce(ehak_new.maakond, ' ') != coalesce(ehak_old.maakond, ' ')) THEN
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
        ehak_old.maakond,
        ehak_new.maakond,
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

    -- vald changed
    IF(coalesce(ehak_new.vald, ' ') != coalesce(ehak_old.vald, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vald');
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
        ehak_old.vald,
        ehak_new.vald,
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
    IF(coalesce(ehak_new.created, LOCALTIMESTAMP) != coalesce(ehak_old.created, LOCALTIMESTAMP)) THEN
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
        ehak_old.created,
        ehak_new.created,
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
    IF(coalesce(ehak_new.last_modified, LOCALTIMESTAMP) != coalesce(ehak_old.last_modified, LOCALTIMESTAMP)) THEN
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
        ehak_old.last_modified,
        ehak_new.last_modified,
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
    IF(coalesce(ehak_new.username, ' ') != coalesce(ehak_old.username, ' ')) THEN
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
        ehak_old.username,
        ehak_new.username,
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
		
		END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_isik_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	isik_new isik%ROWTYPE;
	isik_old isik%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  ISIK_new.I_ID := NEW.I_ID;
		  ISIK_new.KOOD := NEW.KOOD;
		  ISIK_new.PERENIMI := NEW.PERENIMI;
		  ISIK_new.EESNIMI := NEW.EESNIMI;
		  ISIK_new.MAAKOND := NEW.MAAKOND;
		  ISIK_new.AADRESS := NEW.AADRESS;
		  ISIK_new.POSTIKOOD := NEW.POSTIKOOD;
		  ISIK_new.TELEFON := NEW.TELEFON;
		  ISIK_new.E_POST := NEW.E_POST;
		  ISIK_new.WWW := NEW.WWW;
		  ISIK_new.PARAMS := NEW.PARAMS;
		  ISIK_new.CREATED := NEW.CREATED;
		  ISIK_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  ISIK_new.USERNAME := NEW.USERNAME;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  ISIK_old.I_ID := OLD.I_ID;
		  ISIK_old.KOOD := OLD.KOOD;
		  ISIK_old.PERENIMI := OLD.PERENIMI;
		  ISIK_old.EESNIMI := OLD.EESNIMI;
		  ISIK_old.MAAKOND := OLD.MAAKOND;
		  ISIK_old.AADRESS := OLD.AADRESS;
		  ISIK_old.POSTIKOOD := OLD.POSTIKOOD;
		  ISIK_old.TELEFON := OLD.TELEFON;
		  ISIK_old.E_POST := OLD.E_POST;
		  ISIK_old.WWW := OLD.WWW;
		  ISIK_old.PARAMS := OLD.PARAMS;
		  ISIK_old.CREATED := OLD.CREATED;
		  ISIK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ISIK_old.USERNAME := OLD.USERNAME;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  ISIK_old.I_ID := OLD.I_ID;
		  ISIK_old.KOOD := OLD.KOOD;
		  ISIK_old.PERENIMI := OLD.PERENIMI;
		  ISIK_old.EESNIMI := OLD.EESNIMI;
		  ISIK_old.MAAKOND := OLD.MAAKOND;
		  ISIK_old.AADRESS := OLD.AADRESS;
		  ISIK_old.POSTIKOOD := OLD.POSTIKOOD;
		  ISIK_old.TELEFON := OLD.TELEFON;
		  ISIK_old.E_POST := OLD.E_POST;
		  ISIK_old.WWW := OLD.WWW;
		  ISIK_old.PARAMS := OLD.PARAMS;
		  ISIK_old.CREATED := OLD.CREATED;
		  ISIK_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  ISIK_old.USERNAME := OLD.USERNAME;
	  end if;	

	  execute dvklog.log_isik(isik_new, isik_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_isik (
    isik_new dvk.isik,
    isik_old dvk.isik,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'isik';    
    primary_key_value integer := isik_old.i_id;
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

    -- i_id changed
    IF(coalesce(isik_new.i_id, 0) != coalesce(isik_old.i_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('i_id');
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
        isik_old.i_id,
        isik_new.i_id,
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

    -- kood changed
    IF(coalesce(isik_new.kood, ' ') != coalesce(isik_old.kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kood');
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
        isik_old.kood,
        isik_new.kood,
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

    -- perenimi changed
    IF(coalesce(isik_new.perenimi, ' ') != coalesce(isik_old.perenimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('perenimi');
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
        isik_old.perenimi,
        isik_new.perenimi,
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

    -- eesnimi changed
    IF(coalesce(isik_new.eesnimi, ' ') != coalesce(isik_old.eesnimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('eesnimi');
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
        isik_old.eesnimi,
        isik_new.eesnimi,
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
    IF(coalesce(isik_new.maakond, ' ') != coalesce(isik_old.maakond, ' ')) THEN
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
        isik_old.maakond,
        isik_new.maakond,
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
    IF(coalesce(isik_new.aadress, ' ') != coalesce(isik_old.aadress, ' ')) THEN
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
        isik_old.aadress,
        isik_new.aadress,
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
    IF(coalesce(isik_new.postikood, ' ') != coalesce(isik_old.postikood, ' ')) THEN
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
        isik_old.postikood,
        isik_new.postikood,
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
    IF(coalesce(isik_new.telefon, ' ') != coalesce(isik_old.telefon, ' ')) THEN
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
        isik_old.telefon,
        isik_new.telefon,
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
    IF(coalesce(isik_new.e_post, ' ') != coalesce(isik_old.e_post, ' ')) THEN
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
        isik_old.e_post,
        isik_new.e_post,
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
    IF(coalesce(isik_new.www, ' ') != coalesce(isik_old.www, ' ')) THEN
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
        isik_old.www,
        isik_new.www,
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
    IF(coalesce(isik_new.params, ' ') != coalesce(isik_old.params, ' ')) THEN
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
        isik_old.params,
        isik_new.params,
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
    IF(coalesce(isik_new.created, LOCALTIMESTAMP) != coalesce(isik_old.created, LOCALTIMESTAMP)) THEN
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
        isik_old.created,
        isik_new.created,
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
    IF(coalesce(isik_new.last_modified, LOCALTIMESTAMP) != coalesce(isik_old.last_modified, LOCALTIMESTAMP)) THEN
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
        isik_old.last_modified,
        isik_new.last_modified,
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
    IF(coalesce(isik_new.username, ' ') != coalesce(isik_old.username, ' ')) THEN
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
        isik_old.username,
        isik_new.username,
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
		
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_kaust_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	kaust_new kaust%ROWTYPE;
	kaust_old kaust%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  kaust_new.kaust_id := NEW.kaust_id;
		  kaust_new.nimi := NEW.nimi;
		  kaust_new.ylemkaust_id := NEW.ylemkaust_id;
		  kaust_new.asutus_id := NEW.asutus_id;
		  kaust_new.kausta_number := NEW.kausta_number;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  kaust_old.kaust_id := OLD.kaust_id;
		  kaust_old.nimi := OLD.nimi;
		  kaust_old.ylemkaust_id := OLD.ylemkaust_id;
		  kaust_old.asutus_id := OLD.asutus_id;
		  kaust_old.kausta_number := OLD.kausta_number;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  kaust_old.kaust_id := OLD.kaust_id;
		  kaust_old.nimi := OLD.nimi;
		  kaust_old.ylemkaust_id := OLD.ylemkaust_id;
		  kaust_old.asutus_id := OLD.asutus_id;
		  kaust_old.kausta_number := OLD.kausta_number;
	  end if;	

	  execute dvklog.log_kaust(kaust_new, kaust_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_kaust (
    kaust_new dvk.kaust,
    kaust_old dvk.kaust,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'kaust';    
    primary_key_value integer := kaust_old.kaust_id;
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

    -- kaust_id changed
    IF(coalesce(kaust_new.kaust_id, 0) != coalesce(kaust_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
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
        kaust_old.kaust_id,
        kaust_new.kaust_id,
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

    -- nimi changed
    IF(coalesce(kaust_new.nimi, ' ') != coalesce(kaust_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        kaust_old.nimi,
        kaust_new.nimi,
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

    -- ylemkaust_id changed
    IF(coalesce(kaust_new.ylemkaust_id, 0) != coalesce(kaust_old.ylemkaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ylemkaust_id');
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
        kaust_old.ylemkaust_id,
        kaust_new.ylemkaust_id,
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

    -- asutus_id changed
    IF(coalesce(kaust_new.asutus_id, 0) != coalesce(kaust_old.asutus_id, 0)) THEN
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
        kaust_old.asutus_id,
        kaust_new.asutus_id,
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

    -- kausta_number changed
    IF(coalesce(kaust_new.kausta_number, ' ') != coalesce(kaust_old.kausta_number, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kausta_number');
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
        kaust_old.kausta_number,
        kaust_new.kausta_number,
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
		
END;$$ 
LANGUAGE PLPGSQL;    


		

CREATE OR REPLACE FUNCTION tr_klassifikaatori_tyyp_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	klassifikaatori_tyyp_new klassifikaatori_tyyp%ROWTYPE;
	klassifikaatori_tyyp_old klassifikaatori_tyyp%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KLASSIFIKAATORI_TYYP_new.KLASSIFIKAATORI_TYYP_ID := NEW.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_new.NIMETUS := NEW.NIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KLASSIFIKAATORI_TYYP_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_old.NIMETUS := OLD.NIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KLASSIFIKAATORI_TYYP_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
		  KLASSIFIKAATORI_TYYP_old.NIMETUS := OLD.NIMETUS;
	  end if;	

	  execute dvklog.log_klassifikaatori_tyyp(klassifikaatori_tyyp_new, klassifikaatori_tyyp_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		

CREATE OR REPLACE FUNCTION dvklog.log_klassifikaatori_tyyp (
    klassifikaatori_tyyp_new dvk.klassifikaatori_tyyp,
    klassifikaatori_tyyp_old dvk.klassifikaatori_tyyp,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'klassifikaatori_tyyp';    
    primary_key_value integer := klassifikaatori_tyyp_old.klassifikaatori_tyyp_id;
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
		
    -- klassifikaatori_tyyp_id changed
    IF(coalesce(klassifikaatori_tyyp_new.klassifikaatori_tyyp_id, 0) != coalesce(klassifikaatori_tyyp_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
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
        klassifikaatori_tyyp_old.klassifikaatori_tyyp_id,
        klassifikaatori_tyyp_new.klassifikaatori_tyyp_id,
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
    IF(coalesce(klassifikaatori_tyyp_new.nimetus, ' ') != coalesce(klassifikaatori_tyyp_old.nimetus, ' ')) THEN
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
        klassifikaatori_tyyp_old.nimetus,
        klassifikaatori_tyyp_new.nimetus,
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
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_klassifikaator_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	klassifikaator_new klassifikaator%ROWTYPE;
	klassifikaator_old klassifikaator%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KLASSIFIKAATOR_new.KLASSIFIKAATOR_ID := NEW.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_new.NIMETUS := NEW.NIMETUS;
		  KLASSIFIKAATOR_new.KLASSIFIKAATORI_TYYP_ID := NEW.KLASSIFIKAATORI_TYYP_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KLASSIFIKAATOR_old.KLASSIFIKAATOR_ID := OLD.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_old.NIMETUS := OLD.NIMETUS;
		  KLASSIFIKAATOR_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KLASSIFIKAATOR_old.KLASSIFIKAATOR_ID := OLD.KLASSIFIKAATOR_ID;
		  KLASSIFIKAATOR_old.NIMETUS := OLD.NIMETUS;
		  KLASSIFIKAATOR_old.KLASSIFIKAATORI_TYYP_ID := OLD.KLASSIFIKAATORI_TYYP_ID;
	  end if;	

	  execute dvklog.log_klassifikaator(klassifikaator_new, klassifikaator_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		

CREATE OR REPLACE FUNCTION dvklog.log_klassifikaator (
    klassifikaator_new dvk.klassifikaator,
    klassifikaator_old dvk.klassifikaator,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'klassifikaator';    
    primary_key_value integer := klassifikaator_old.klassifikaator_id;
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
		
    -- klassifikaator_id changed
    IF(coalesce(klassifikaator_new.klassifikaator_id, 0) != coalesce(klassifikaator_old.klassifikaator_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaator_id');
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
        klassifikaator_old.klassifikaator_id,
        klassifikaator_new.klassifikaator_id,
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
    IF(coalesce(klassifikaator_new.nimetus, ' ') != coalesce(klassifikaator_old.nimetus, ' ')) THEN
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
        klassifikaator_old.nimetus,
        klassifikaator_new.nimetus,
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

    -- klassifikaatori_tyyp_id changed
    IF(coalesce(klassifikaator_new.klassifikaatori_tyyp_id, 0) != coalesce(klassifikaator_old.klassifikaatori_tyyp_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('klassifikaatori_tyyp_id');
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
        klassifikaator_old.klassifikaatori_tyyp_id,
        klassifikaator_new.klassifikaatori_tyyp_id,
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
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_konversioon_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	konversioon_new konversioon%ROWTYPE;
	konversioon_old konversioon%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  KONVERSIOON_new.ID := NEW.ID;
		  KONVERSIOON_new.VERSION := NEW.VERSION;
		  KONVERSIOON_new.RESULT_VERSION := NEW.RESULT_VERSION;
		  KONVERSIOON_new.XSLT := NEW.XSLT;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  KONVERSIOON_old.ID := OLD.ID;
		  KONVERSIOON_old.VERSION := OLD.VERSION;
		  KONVERSIOON_old.RESULT_VERSION := OLD.RESULT_VERSION;
		  KONVERSIOON_old.XSLT := OLD.XSLT;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  KONVERSIOON_old.ID := OLD.ID;
		  KONVERSIOON_old.VERSION := OLD.VERSION;
		  KONVERSIOON_old.RESULT_VERSION := OLD.RESULT_VERSION;
		  KONVERSIOON_old.XSLT := OLD.XSLT;
	  end if;	

	  execute dvklog.log_konversioon(konversioon_new, konversioon_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_konversioon (
    konversioon_new dvk.konversioon,
    konversioon_old dvk.konversioon,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'konversioon';    
    primary_key_value integer := konversioon_old.id;
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
		
    -- id changed
    IF(coalesce(konversioon_new.id, 0) != coalesce(konversioon_old.id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('id');
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
        konversioon_old.id,
        konversioon_new.id,
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

    -- version changed
    IF(coalesce(konversioon_new.version, 0) != coalesce(konversioon_old.version, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('version');
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
        konversioon_old.version,
        konversioon_new.version,
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

    -- result_version changed
    IF(coalesce(konversioon_new.result_version, 0) != coalesce(konversioon_old.result_version, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('result_version');
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
        konversioon_old.result_version,
        konversioon_new.result_version,
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
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_oigus_antud_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	oigus_antud_new oigus_antud%ROWTYPE;
	oigus_antud_old oigus_antud%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  OIGUS_ANTUD_new.OIGUS_ANTUD_ID := NEW.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  OIGUS_ANTUD_new.MUU_ASUTUS_ID := NEW.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  OIGUS_ANTUD_new.ROLL := NEW.ROLL;
		  OIGUS_ANTUD_new.ALATES := NEW.ALATES;
		  OIGUS_ANTUD_new.KUNI := NEW.KUNI;
		  OIGUS_ANTUD_new.CREATED := NEW.CREATED;
		  OIGUS_ANTUD_new.LAST_MODIFIED := NEW.LAST_MODIFIED;
		  OIGUS_ANTUD_new.USERNAME := NEW.USERNAME;
		  OIGUS_ANTUD_new.PEATATUD := NEW.PEATATUD;
		  OIGUS_ANTUD_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  OIGUS_ANTUD_old.OIGUS_ANTUD_ID := OLD.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_ANTUD_old.MUU_ASUTUS_ID := OLD.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_ANTUD_old.ROLL := OLD.ROLL;
		  OIGUS_ANTUD_old.ALATES := OLD.ALATES;
		  OIGUS_ANTUD_old.KUNI := OLD.KUNI;
		  OIGUS_ANTUD_old.CREATED := OLD.CREATED;
		  OIGUS_ANTUD_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  OIGUS_ANTUD_old.USERNAME := OLD.USERNAME;
		  OIGUS_ANTUD_old.PEATATUD := OLD.PEATATUD;
		  OIGUS_ANTUD_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  OIGUS_ANTUD_old.OIGUS_ANTUD_ID := OLD.OIGUS_ANTUD_ID;
		  OIGUS_ANTUD_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_ANTUD_old.MUU_ASUTUS_ID := OLD.MUU_ASUTUS_ID;
		  OIGUS_ANTUD_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_ANTUD_old.ROLL := OLD.ROLL;
		  OIGUS_ANTUD_old.ALATES := OLD.ALATES;
		  OIGUS_ANTUD_old.KUNI := OLD.KUNI;
		  OIGUS_ANTUD_old.CREATED := OLD.CREATED;
		  OIGUS_ANTUD_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  OIGUS_ANTUD_old.USERNAME := OLD.USERNAME;
		  OIGUS_ANTUD_old.PEATATUD := OLD.PEATATUD;
		  OIGUS_ANTUD_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
	  end if;	

	  execute dvklog.log_oigus_antud(oigus_antud_new, oigus_antud_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_oigus_antud (
    oigus_antud_new dvk.oigus_antud,
    oigus_antud_old dvk.oigus_antud,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'oigus_antud';    
    primary_key_value integer := oigus_antud_old.oigus_antud_id;
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
		
    -- oigus_antud_id changed
    IF(coalesce(oigus_antud_new.oigus_antud_id, 0) != coalesce(oigus_antud_old.oigus_antud_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_antud_id');
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
        oigus_antud_old.oigus_antud_id,
        oigus_antud_new.oigus_antud_id,
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

    -- asutus_id changed
    IF(coalesce(oigus_antud_new.asutus_id, 0) != coalesce(oigus_antud_old.asutus_id, 0)) THEN
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
        oigus_antud_old.asutus_id,
        oigus_antud_new.asutus_id,
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

    -- muu_asutus_id changed
    IF(coalesce(oigus_antud_new.muu_asutus_id, 0) != coalesce(oigus_antud_old.muu_asutus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muu_asutus_id');
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
        oigus_antud_old.muu_asutus_id,
        oigus_antud_new.muu_asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(oigus_antud_new.ametikoht_id, 0) != coalesce(oigus_antud_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        oigus_antud_old.ametikoht_id,
        oigus_antud_new.ametikoht_id,
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

    -- roll changed
    IF(coalesce(oigus_antud_new.roll, ' ') != coalesce(oigus_antud_old.roll, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('roll');
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
        oigus_antud_old.roll,
        oigus_antud_new.roll,
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

    -- alates changed
    IF(coalesce(oigus_antud_new.alates, LOCALTIMESTAMP) != coalesce(oigus_antud_old.alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('alates');
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
        oigus_antud_old.alates,
        oigus_antud_new.alates,
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

    -- kuni changed
    IF(coalesce(oigus_antud_new.kuni, LOCALTIMESTAMP) != coalesce(oigus_antud_old.kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kuni');
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
        oigus_antud_old.kuni,
        oigus_antud_new.kuni,
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
    IF(coalesce(oigus_antud_new.created, LOCALTIMESTAMP) != coalesce(oigus_antud_old.created, LOCALTIMESTAMP)) THEN
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
        oigus_antud_old.created,
        oigus_antud_new.created,
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
    IF(coalesce(oigus_antud_new.last_modified, LOCALTIMESTAMP) != coalesce(oigus_antud_old.last_modified, LOCALTIMESTAMP)) THEN
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
        oigus_antud_old.last_modified,
        oigus_antud_new.last_modified,
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
    IF(coalesce(oigus_antud_new.username, ' ') != coalesce(oigus_antud_old.username, ' ')) THEN
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
        oigus_antud_old.username,
        oigus_antud_new.username,
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

    -- peatatud changed
    IF(coalesce(oigus_antud_new.peatatud, 0) != coalesce(oigus_antud_old.peatatud, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('peatatud');
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
        oigus_antud_old.peatatud,
        oigus_antud_new.peatatud,
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

    -- allyksus_id changed
    IF(coalesce(oigus_antud_new.allyksus_id, 0) != coalesce(oigus_antud_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
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
        oigus_antud_old.allyksus_id,
        oigus_antud_new.allyksus_id,
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
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_oigus_objektile_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	oigus_objektile_new oigus_objektile%ROWTYPE;
	oigus_objektile_old oigus_objektile%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  OIGUS_OBJEKTILE_new.OIGUS_OBJEKTILE_ID := NEW.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  OIGUS_OBJEKTILE_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_new.DOKUMENT_ID := NEW.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_new.KAUST_ID := NEW.KAUST_ID;
		  OIGUS_OBJEKTILE_new.KEHTIB_ALATES := NEW.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_new.KEHTIB_KUNI := NEW.KEHTIB_KUNI;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  OIGUS_OBJEKTILE_old.OIGUS_OBJEKTILE_ID := OLD.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_OBJEKTILE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_old.KAUST_ID := OLD.KAUST_ID;
		  OIGUS_OBJEKTILE_old.KEHTIB_ALATES := OLD.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_old.KEHTIB_KUNI := OLD.KEHTIB_KUNI;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 		  		  
		  OIGUS_OBJEKTILE_old.OIGUS_OBJEKTILE_ID := OLD.OIGUS_OBJEKTILE_ID;
		  OIGUS_OBJEKTILE_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  OIGUS_OBJEKTILE_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  OIGUS_OBJEKTILE_old.DOKUMENT_ID := OLD.DOKUMENT_ID;
		  OIGUS_OBJEKTILE_old.KAUST_ID := OLD.KAUST_ID;
		  OIGUS_OBJEKTILE_old.KEHTIB_ALATES := OLD.KEHTIB_ALATES;
		  OIGUS_OBJEKTILE_old.KEHTIB_KUNI := OLD.KEHTIB_KUNI;
	  end if;	

	  execute dvklog.log_oigus_objektile(oigus_objektile_new, oigus_objektile_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_oigus_objektile (
    oigus_objektile_new dvk.oigus_objektile,
    oigus_objektile_old dvk.oigus_objektile,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'oigus_objektile';    
    primary_key_value integer := oigus_objektile_old.oigus_objektile_id;
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
		
		
    -- oigus_objektile_id changed
    IF(coalesce(oigus_objektile_new.oigus_objektile_id, 0) != coalesce(oigus_objektile_old.oigus_objektile_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('oigus_objektile_id');
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
        oigus_objektile_old.oigus_objektile_id,
        oigus_objektile_new.oigus_objektile_id,
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

    -- asutus_id changed
    IF(coalesce(oigus_objektile_new.asutus_id, 0) != coalesce(oigus_objektile_old.asutus_id, 0)) THEN
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
        oigus_objektile_old.asutus_id,
        oigus_objektile_new.asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(oigus_objektile_new.ametikoht_id, 0) != coalesce(oigus_objektile_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        oigus_objektile_old.ametikoht_id,
        oigus_objektile_new.ametikoht_id,
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

    -- dokument_id changed
    IF(coalesce(oigus_objektile_new.dokument_id, 0) != coalesce(oigus_objektile_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        oigus_objektile_old.dokument_id,
        oigus_objektile_new.dokument_id,
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

    -- kaust_id changed
    IF(coalesce(oigus_objektile_new.kaust_id, 0) != coalesce(oigus_objektile_old.kaust_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kaust_id');
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
        oigus_objektile_old.kaust_id,
        oigus_objektile_new.kaust_id,
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

    -- kehtib_alates changed
    IF(coalesce(oigus_objektile_new.kehtib_alates, LOCALTIMESTAMP) != coalesce(oigus_objektile_old.kehtib_alates, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_alates');
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
        oigus_objektile_old.kehtib_alates,
        oigus_objektile_new.kehtib_alates,
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

    -- kehtib_kuni changed
    IF(coalesce(oigus_objektile_new.kehtib_kuni, LOCALTIMESTAMP) != coalesce(oigus_objektile_old.kehtib_kuni, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kehtib_kuni');
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
        oigus_objektile_old.kehtib_kuni,
        oigus_objektile_new.kehtib_kuni,
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
				
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_parameetrid_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	parameetrid_new parameetrid%ROWTYPE;
	parameetrid_old parameetrid%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  PARAMEETRID_new.AAR_VIIMANE_SYNC := NEW.AAR_VIIMANE_SYNC;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  PARAMEETRID_old.AAR_VIIMANE_SYNC := OLD.AAR_VIIMANE_SYNC;		  
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  PARAMEETRID_old.AAR_VIIMANE_SYNC := OLD.AAR_VIIMANE_SYNC;		  
	  end if;	

	  execute dvklog.log_parameetrid(parameetrid_new, parameetrid_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_parameetrid (
    parameetrid_new dvk.parameetrid,
    parameetrid_old dvk.parameetrid,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'parameetrid';    
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

    -- aar_viimane_sync changed
    IF(coalesce(parameetrid_new.aar_viimane_sync, LOCALTIMESTAMP) != coalesce(parameetrid_old.aar_viimane_sync, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('aar_viimane_sync');
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
        null, -- primary key value
        clmn.column_name, -- column name
        clmn.data_type,
        parameetrid_old.aar_viimane_sync,
        parameetrid_new.aar_viimane_sync,
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
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_saatja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	saatja_new saatja%ROWTYPE;
	saatja_old saatja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  saatja_new.saatja_id := NEW.saatja_id;
		  saatja_new.transport_id := NEW.transport_id;
		  saatja_new.asutus_id := NEW.asutus_id;
		  saatja_new.ametikoht_id := NEW.ametikoht_id;
		  saatja_new.isikukood := NEW.isikukood;
		  saatja_new.nimi := NEW.nimi;
		  saatja_new.email := NEW.email;
		  saatja_new.osakonna_nr := NEW.osakonna_nr;
		  saatja_new.osakonna_nimi := NEW.osakonna_nimi;
		  saatja_new.asutuse_nimi := NEW.asutuse_nimi;
		  saatja_new.allyksus_id := NEW.allyksus_id;
		  saatja_new.allyksuse_lyhinimetus := NEW.allyksuse_lyhinimetus;
		  saatja_new.ametikoha_lyhinimetus := NEW.ametikoha_lyhinimetus;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  saatja_old.saatja_id := OLD.saatja_id;
		  saatja_old.transport_id := OLD.transport_id;
		  saatja_old.asutus_id := OLD.asutus_id;
		  saatja_old.ametikoht_id := OLD.ametikoht_id;
		  saatja_old.isikukood := OLD.isikukood;
		  saatja_old.nimi := OLD.nimi;
		  saatja_old.email := OLD.email;
		  saatja_old.osakonna_nr := OLD.osakonna_nr;
		  saatja_old.osakonna_nimi := OLD.osakonna_nimi;
		  saatja_old.asutuse_nimi := OLD.asutuse_nimi;
		  saatja_old.allyksus_id := OLD.allyksus_id;
		  saatja_old.allyksuse_lyhinimetus := OLD.allyksuse_lyhinimetus;
		  saatja_old.ametikoha_lyhinimetus := OLD.ametikoha_lyhinimetus;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  saatja_old.saatja_id := OLD.saatja_id;
		  saatja_old.transport_id := OLD.transport_id;
		  saatja_old.asutus_id := OLD.asutus_id;
		  saatja_old.ametikoht_id := OLD.ametikoht_id;
		  saatja_old.isikukood := OLD.isikukood;
		  saatja_old.nimi := OLD.nimi;
		  saatja_old.email := OLD.email;
		  saatja_old.osakonna_nr := OLD.osakonna_nr;
		  saatja_old.osakonna_nimi := OLD.osakonna_nimi;
		  saatja_old.asutuse_nimi := OLD.asutuse_nimi;
		  saatja_old.allyksus_id := OLD.allyksus_id;
		  saatja_old.allyksuse_lyhinimetus := OLD.allyksuse_lyhinimetus;
		  saatja_old.ametikoha_lyhinimetus := OLD.ametikoha_lyhinimetus;

	  end if;	

	  execute dvklog.log_saatja(saatja_new, saatja_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_saatja (
    saatja_new dvk.saatja,
    saatja_old dvk.saatja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'saatja';  
    primary_key_value integer := saatja_old.saatja_id;		
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
		
    -- saatja_id changed
    IF(coalesce(saatja_new.saatja_id, 0) != coalesce(saatja_old.saatja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatja_id');
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
        saatja_old.saatja_id,
        saatja_new.saatja_id,
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

    -- transport_id changed
    IF(coalesce(saatja_new.transport_id, 0) != coalesce(saatja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
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
        saatja_old.transport_id,
        saatja_new.transport_id,
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

    -- asutus_id changed
    IF(coalesce(saatja_new.asutus_id, 0) != coalesce(saatja_old.asutus_id, 0)) THEN
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
        saatja_old.asutus_id,
        saatja_new.asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(saatja_new.ametikoht_id, 0) != coalesce(saatja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        saatja_old.ametikoht_id,
        saatja_new.ametikoht_id,
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

    -- isikukood changed
    IF(coalesce(saatja_new.isikukood, ' ') != coalesce(saatja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
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
        saatja_old.isikukood,
        saatja_new.isikukood,
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

    -- nimi changed
    IF(coalesce(saatja_new.nimi, ' ') != coalesce(saatja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        saatja_old.nimi,
        saatja_new.nimi,
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

    -- email changed
    IF(coalesce(saatja_new.email, ' ') != coalesce(saatja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
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
        saatja_old.email,
        saatja_new.email,
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

    -- osakonna_nr changed
    IF(coalesce(saatja_new.osakonna_nr, ' ') != coalesce(saatja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
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
        saatja_old.osakonna_nr,
        saatja_new.osakonna_nr,
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

    -- osakonna_nimi changed
    IF(coalesce(saatja_new.osakonna_nimi, ' ') != coalesce(saatja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
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
        saatja_old.osakonna_nimi,
        saatja_new.osakonna_nimi,
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

    -- asutuse_nimi changed
    IF(coalesce(saatja_new.asutuse_nimi, ' ') != coalesce(saatja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
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
        saatja_old.asutuse_nimi,
        saatja_new.asutuse_nimi,
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

    -- allyksus_id changed
    IF(coalesce(saatja_new.allyksus_id, 0) != coalesce(saatja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
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
        saatja_old.allyksus_id,
        saatja_new.allyksus_id,
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

    -- allyksuse_lyhinimetus changed
    IF(coalesce(saatja_new.allyksuse_lyhinimetus, ' ') != coalesce(saatja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
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
        saatja_old.allyksuse_lyhinimetus,
        saatja_new.allyksuse_lyhinimetus,
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

    -- ametikoha_lyhinimetus changed
    IF(coalesce(saatja_new.ametikoha_lyhinimetus, ' ') != coalesce(saatja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
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
        saatja_old.ametikoha_lyhinimetus,
        saatja_new.ametikoha_lyhinimetus,
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
		
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_server_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	server_new server%ROWTYPE;
	server_old server%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  SERVER_new.SERVER_ID := NEW.SERVER_ID;
		  SERVER_new.ANDMEKOGU_NIMI := NEW.ANDMEKOGU_NIMI;
		  SERVER_new.AADRESS := NEW.AADRESS;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  SERVER_old.SERVER_ID := OLD.SERVER_ID;
		  SERVER_old.ANDMEKOGU_NIMI := OLD.ANDMEKOGU_NIMI;
		  SERVER_old.AADRESS := OLD.AADRESS;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  SERVER_old.SERVER_ID := OLD.SERVER_ID;
		  SERVER_old.ANDMEKOGU_NIMI := OLD.ANDMEKOGU_NIMI;
		  SERVER_old.AADRESS := OLD.AADRESS;
	  end if;	

	  execute dvklog.log_server(server_new, server_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_server (
    server_new dvk.server,
    server_old dvk.server,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'server';  
    primary_key_value integer := server_old.server_id;
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
		
		
    -- server_id changed
    IF(coalesce(server_new.server_id, 0) != coalesce(server_old.server_id, 0)) THEN
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
        server_old.server_id,
        server_new.server_id,
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

    -- andmekogu_nimi changed
    IF(coalesce(server_new.andmekogu_nimi, ' ') != coalesce(server_old.andmekogu_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('andmekogu_nimi');
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
        server_old.andmekogu_nimi,
        server_new.andmekogu_nimi,
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
    IF(coalesce(server_new.aadress, ' ') != coalesce(server_old.aadress, ' ')) THEN
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
        server_old.aadress,
        server_new.aadress,
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
		
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_staatuse_ajalugu_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	staatuse_ajalugu_new staatuse_ajalugu%ROWTYPE;
	staatuse_ajalugu_old staatuse_ajalugu%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  staatuse_ajalugu_new.STAATUSE_AJALUGU_ID := NEW.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_new.VASTUVOTJA_ID := NEW.VASTUVOTJA_ID;
		  staatuse_ajalugu_new.STAATUS_ID := NEW.STAATUS_ID;
		  staatuse_ajalugu_new.STAATUSE_MUUTMISE_AEG := NEW.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_new.FAULT_CODE := NEW.FAULT_CODE;
		  staatuse_ajalugu_new.FAULT_ACTOR := NEW.FAULT_ACTOR;
		  staatuse_ajalugu_new.FAULT_STRING := NEW.FAULT_STRING;
		  staatuse_ajalugu_new.FAULT_DETAIL := NEW.FAULT_DETAIL;
		  staatuse_ajalugu_new.VASTUVOTJA_STAATUS_ID := NEW.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_new.METAXML := NEW.METAXML;

	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  staatuse_ajalugu_old.STAATUSE_AJALUGU_ID := OLD.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_old.VASTUVOTJA_ID := OLD.VASTUVOTJA_ID;
		  staatuse_ajalugu_old.STAATUS_ID := OLD.STAATUS_ID;
		  staatuse_ajalugu_old.STAATUSE_MUUTMISE_AEG := OLD.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_old.FAULT_CODE := OLD.FAULT_CODE;
		  staatuse_ajalugu_old.FAULT_ACTOR := OLD.FAULT_ACTOR;
		  staatuse_ajalugu_old.FAULT_STRING := OLD.FAULT_STRING;
		  staatuse_ajalugu_old.FAULT_DETAIL := OLD.FAULT_DETAIL;
		  staatuse_ajalugu_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_old.METAXML := OLD.METAXML;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  staatuse_ajalugu_old.STAATUSE_AJALUGU_ID := OLD.STAATUSE_AJALUGU_ID;
		  staatuse_ajalugu_old.VASTUVOTJA_ID := OLD.VASTUVOTJA_ID;
		  staatuse_ajalugu_old.STAATUS_ID := OLD.STAATUS_ID;
		  staatuse_ajalugu_old.STAATUSE_MUUTMISE_AEG := OLD.STAATUSE_MUUTMISE_AEG;
		  staatuse_ajalugu_old.FAULT_CODE := OLD.FAULT_CODE;
		  staatuse_ajalugu_old.FAULT_ACTOR := OLD.FAULT_ACTOR;
		  staatuse_ajalugu_old.FAULT_STRING := OLD.FAULT_STRING;
		  staatuse_ajalugu_old.FAULT_DETAIL := OLD.FAULT_DETAIL;
		  staatuse_ajalugu_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  staatuse_ajalugu_old.METAXML := OLD.METAXML;
	  end if;	

	  execute dvklog.log_staatuse_ajalugu(staatuse_ajalugu_new, staatuse_ajalugu_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_staatuse_ajalugu (
    staatuse_ajalugu_new dvk.staatuse_ajalugu,
    staatuse_ajalugu_old dvk.staatuse_ajalugu,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'staatuse_ajalugu';  
    primary_key_value integer := staatuse_ajalugu_old.staatuse_ajalugu_id;
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
		

    -- staatuse_ajalugu_id changed
    IF(coalesce(staatuse_ajalugu_new.staatuse_ajalugu_id, 0) != coalesce(staatuse_ajalugu_old.staatuse_ajalugu_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_ajalugu_id');
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
        staatuse_ajalugu_old.staatuse_ajalugu_id,
        staatuse_ajalugu_new.staatuse_ajalugu_id,
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

    -- vastuvotja_id changed
    IF(coalesce(staatuse_ajalugu_new.vastuvotja_id, 0) != coalesce(staatuse_ajalugu_old.vastuvotja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_id');
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
        staatuse_ajalugu_old.vastuvotja_id,
        staatuse_ajalugu_new.vastuvotja_id,
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

    -- staatus_id changed
    IF(coalesce(staatuse_ajalugu_new.staatus_id, 0) != coalesce(staatuse_ajalugu_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
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
        staatuse_ajalugu_old.staatus_id,
        staatuse_ajalugu_new.staatus_id,
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

    -- staatuse_muutmise_aeg changed
    IF(coalesce(staatuse_ajalugu_new.staatuse_muutmise_aeg, LOCALTIMESTAMP) != coalesce(staatuse_ajalugu_old.staatuse_muutmise_aeg, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatuse_muutmise_aeg');
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
        staatuse_ajalugu_old.staatuse_muutmise_aeg,
        staatuse_ajalugu_new.staatuse_muutmise_aeg,
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

    -- fault_code changed
    IF(coalesce(staatuse_ajalugu_new.fault_code, ' ') != coalesce(staatuse_ajalugu_old.fault_code, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_code');
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
        staatuse_ajalugu_old.fault_code,
        staatuse_ajalugu_new.fault_code,
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

    -- fault_actor changed
    IF(coalesce(staatuse_ajalugu_new.fault_actor, ' ') != coalesce(staatuse_ajalugu_old.fault_actor, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_actor');
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
        staatuse_ajalugu_old.fault_actor,
        staatuse_ajalugu_new.fault_actor,
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

    -- fault_string changed
    IF(coalesce(staatuse_ajalugu_new.fault_string, ' ') != coalesce(staatuse_ajalugu_old.fault_string, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_string');
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
        staatuse_ajalugu_old.fault_string,
        staatuse_ajalugu_new.fault_string,
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

    -- fault_detail changed
    IF(coalesce(staatuse_ajalugu_new.fault_detail, ' ') != coalesce(staatuse_ajalugu_old.fault_detail, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fault_detail');
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
        staatuse_ajalugu_old.fault_detail,
        staatuse_ajalugu_new.fault_detail,
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

    -- vastuvotja_staatus_id changed
    IF(coalesce(staatuse_ajalugu_new.vastuvotja_staatus_id, 0) != coalesce(staatuse_ajalugu_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
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
        staatuse_ajalugu_old.vastuvotja_staatus_id,
        staatuse_ajalugu_new.vastuvotja_staatus_id,
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
		
		
END;$$ 
LANGUAGE PLPGSQL;    

		

CREATE OR REPLACE FUNCTION tr_transport_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	transport_new transport%ROWTYPE;
	transport_old transport%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  transport_new.transport_id := NEW.transport_id;
		  transport_new.dokument_id := NEW.dokument_id;
		  transport_new.saatmise_algus := NEW.saatmise_algus;
		  transport_new.saatmise_lopp := NEW.saatmise_lopp;
		  transport_new.staatus_id := NEW.staatus_id;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  transport_old.transport_id := OLD.transport_id;
		  transport_old.dokument_id := OLD.dokument_id;
		  transport_old.saatmise_algus := OLD.saatmise_algus;
		  transport_old.saatmise_lopp := OLD.saatmise_lopp;
		  transport_old.staatus_id := OLD.staatus_id;

	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  transport_old.transport_id := OLD.transport_id;
		  transport_old.dokument_id := OLD.dokument_id;
		  transport_old.saatmise_algus := OLD.saatmise_algus;
		  transport_old.saatmise_lopp := OLD.saatmise_lopp;
		  transport_old.staatus_id := OLD.staatus_id;
	  end if;	

	  execute dvklog.log_transport(transport_new, transport_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION dvklog.log_transport (
    transport_new dvk.transport,
    transport_old dvk.transport,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'transport';  
    primary_key_value integer := transport_old.transport_id;
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
		
    -- transport_id changed
    IF(coalesce(transport_new.transport_id, 0) != coalesce(transport_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
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
        transport_old.transport_id,
        transport_new.transport_id,
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

    -- dokument_id changed
    IF(coalesce(transport_new.dokument_id, 0) != coalesce(transport_old.dokument_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('dokument_id');
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
        transport_old.dokument_id,
        transport_new.dokument_id,
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

    -- saatmise_algus changed
    IF(coalesce(transport_new.saatmise_algus, LOCALTIMESTAMP) != coalesce(transport_old.saatmise_algus, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_algus');
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
        transport_old.saatmise_algus,
        transport_new.saatmise_algus,
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

    -- saatmise_lopp changed
    IF(coalesce(transport_new.saatmise_lopp, LOCALTIMESTAMP) != coalesce(transport_old.saatmise_lopp, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmise_lopp');
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
        transport_old.saatmise_lopp,
        transport_new.saatmise_lopp,
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

    -- staatus_id changed
    IF(coalesce(transport_new.staatus_id, 0) != coalesce(transport_old.staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('staatus_id');
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
        transport_old.staatus_id,
        transport_new.staatus_id,
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
		
END;$$ 
LANGUAGE PLPGSQL;    
		


CREATE OR REPLACE FUNCTION tr_vahendaja_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vahendaja_new vahendaja%ROWTYPE;
	vahendaja_old vahendaja%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  vahendaja_new.VAHENDAJA_ID := NEW.VAHENDAJA_ID;
		  vahendaja_new.TRANSPORT_ID := NEW.TRANSPORT_ID;
		  vahendaja_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  vahendaja_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  vahendaja_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  vahendaja_new.NIMI := NEW.NIMI;
		  vahendaja_new.EMAIL := NEW.EMAIL;
		  vahendaja_new.OSAKONNA_NR := NEW.OSAKONNA_NR;
		  vahendaja_new.OSAKONNA_NIMI := NEW.OSAKONNA_NIMI;
		  vahendaja_new.ASUTUSE_NIMI := NEW.ASUTUSE_NIMI;
		  vahendaja_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  vahendaja_new.ALLYKSUSE_LYHINIMETUS := NEW.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_new.AMETIKOHA_LYHINIMETUS := NEW.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  vahendaja_old.VAHENDAJA_ID := OLD.VAHENDAJA_ID;
		  vahendaja_old.TRANSPORT_ID := OLD.TRANSPORT_ID;
		  vahendaja_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  vahendaja_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  vahendaja_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  vahendaja_old.NIMI := OLD.NIMI;
		  vahendaja_old.EMAIL := OLD.EMAIL;
		  vahendaja_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  vahendaja_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  vahendaja_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  vahendaja_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  vahendaja_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  vahendaja_old.VAHENDAJA_ID := OLD.VAHENDAJA_ID;
		  vahendaja_old.TRANSPORT_ID := OLD.TRANSPORT_ID;
		  vahendaja_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  vahendaja_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  vahendaja_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  vahendaja_old.NIMI := OLD.NIMI;
		  vahendaja_old.EMAIL := OLD.EMAIL;
		  vahendaja_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  vahendaja_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  vahendaja_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  vahendaja_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  vahendaja_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  vahendaja_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	  end if;	

	  execute dvklog.log_vahendaja(vahendaja_new, vahendaja_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    
		
CREATE OR REPLACE FUNCTION dvklog.log_vahendaja (
    vahendaja_new dvk.vahendaja,
    vahendaja_old dvk.vahendaja,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vahendaja';  
    primary_key_value integer := vahendaja_old.vahendaja_id;
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
		
    -- vahendaja_id changed
    IF(coalesce(vahendaja_new.vahendaja_id, 0) != coalesce(vahendaja_old.vahendaja_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vahendaja_id');
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
        vahendaja_old.vahendaja_id,
        vahendaja_new.vahendaja_id,
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

    -- transport_id changed
    IF(coalesce(vahendaja_new.transport_id, 0) != coalesce(vahendaja_old.transport_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('transport_id');
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
        vahendaja_old.transport_id,
        vahendaja_new.transport_id,
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

    -- asutus_id changed
    IF(coalesce(vahendaja_new.asutus_id, 0) != coalesce(vahendaja_old.asutus_id, 0)) THEN
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
        vahendaja_old.asutus_id,
        vahendaja_new.asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(vahendaja_new.ametikoht_id, 0) != coalesce(vahendaja_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        vahendaja_old.ametikoht_id,
        vahendaja_new.ametikoht_id,
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


    -- isikukood changed
    IF(coalesce(vahendaja_new.isikukood, ' ') != coalesce(vahendaja_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
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
        vahendaja_old.isikukood,
        vahendaja_new.isikukood,
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

    -- nimi changed
    IF(coalesce(vahendaja_new.nimi, ' ') != coalesce(vahendaja_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        vahendaja_old.nimi,
        vahendaja_new.nimi,
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

    -- email changed
    IF(coalesce(vahendaja_new.email, ' ') != coalesce(vahendaja_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
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
        vahendaja_old.email,
        vahendaja_new.email,
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

    -- osakonna_nr changed
    IF(coalesce(vahendaja_new.osakonna_nr, ' ') != coalesce(vahendaja_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
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
        vahendaja_old.osakonna_nr,
        vahendaja_new.osakonna_nr,
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

    -- osakonna_nimi changed
    IF(coalesce(vahendaja_new.osakonna_nimi, ' ') != coalesce(vahendaja_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
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
        vahendaja_old.osakonna_nimi,
        vahendaja_new.osakonna_nimi,
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

    -- asutuse_nimi changed
    IF(coalesce(vahendaja_new.asutuse_nimi, ' ') != coalesce(vahendaja_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
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
        vahendaja_old.asutuse_nimi,
        vahendaja_new.asutuse_nimi,
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

    -- allyksus_id changed
    IF(coalesce(vahendaja_new.allyksus_id, 0) != coalesce(vahendaja_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
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
        vahendaja_old.allyksus_id,
        vahendaja_new.allyksus_id,
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

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vahendaja_new.allyksuse_lyhinimetus, ' ') != coalesce(vahendaja_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
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
        vahendaja_old.allyksuse_lyhinimetus,
        vahendaja_new.allyksuse_lyhinimetus,
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

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vahendaja_new.ametikoha_lyhinimetus, ' ') != coalesce(vahendaja_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
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
        vahendaja_old.ametikoha_lyhinimetus,
        vahendaja_new.ametikoha_lyhinimetus,
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
		
		
END;$$ 
LANGUAGE PLPGSQL;    



CREATE OR REPLACE FUNCTION tr_vastuvotja_mall_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_mall_new vastuvotja_mall%ROWTYPE;
	vastuvotja_mall_old vastuvotja_mall%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  VASTUVOTJA_MALL_new.VASTUVOTJA_MALL_ID := NEW.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_new.ASUTUS_ID := NEW.ASUTUS_ID;
		  VASTUVOTJA_MALL_new.AMETIKOHT_ID := NEW.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_new.ISIKUKOOD := NEW.ISIKUKOOD;
		  VASTUVOTJA_MALL_new.NIMI := NEW.NIMI;
		  VASTUVOTJA_MALL_new.EMAIL := NEW.EMAIL;
		  VASTUVOTJA_MALL_new.OSAKONNA_NR := NEW.OSAKONNA_NR;
		  VASTUVOTJA_MALL_new.OSAKONNA_NIMI := NEW.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_new.SAATMISVIIS_ID := NEW.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_new.ASUTUSE_NIMI := NEW.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_new.ALLYKSUS_ID := NEW.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_new.TINGIMUS_XPATH := NEW.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_new.ALLYKSUSE_LYHINIMETUS := NEW.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_new.AMETIKOHA_LYHINIMETUS := NEW.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  VASTUVOTJA_MALL_old.VASTUVOTJA_MALL_ID := OLD.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  VASTUVOTJA_MALL_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  VASTUVOTJA_MALL_old.NIMI := OLD.NIMI;
		  VASTUVOTJA_MALL_old.EMAIL := OLD.EMAIL;
		  VASTUVOTJA_MALL_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  VASTUVOTJA_MALL_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_old.SAATMISVIIS_ID := OLD.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_old.TINGIMUS_XPATH := OLD.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  VASTUVOTJA_MALL_old.VASTUVOTJA_MALL_ID := OLD.VASTUVOTJA_MALL_ID;
		  VASTUVOTJA_MALL_old.ASUTUS_ID := OLD.ASUTUS_ID;
		  VASTUVOTJA_MALL_old.AMETIKOHT_ID := OLD.AMETIKOHT_ID;
		  VASTUVOTJA_MALL_old.ISIKUKOOD := OLD.ISIKUKOOD;
		  VASTUVOTJA_MALL_old.NIMI := OLD.NIMI;
		  VASTUVOTJA_MALL_old.EMAIL := OLD.EMAIL;
		  VASTUVOTJA_MALL_old.OSAKONNA_NR := OLD.OSAKONNA_NR;
		  VASTUVOTJA_MALL_old.OSAKONNA_NIMI := OLD.OSAKONNA_NIMI;
		  VASTUVOTJA_MALL_old.SAATMISVIIS_ID := OLD.SAATMISVIIS_ID;
		  VASTUVOTJA_MALL_old.ASUTUSE_NIMI := OLD.ASUTUSE_NIMI;
		  VASTUVOTJA_MALL_old.ALLYKSUS_ID := OLD.ALLYKSUS_ID;
		  VASTUVOTJA_MALL_old.TINGIMUS_XPATH := OLD.TINGIMUS_XPATH;
		  VASTUVOTJA_MALL_old.ALLYKSUSE_LYHINIMETUS := OLD.ALLYKSUSE_LYHINIMETUS;
		  VASTUVOTJA_MALL_old.AMETIKOHA_LYHINIMETUS := OLD.AMETIKOHA_LYHINIMETUS;
	  end if;	

	  execute dvklog.log_vastuvotja_mall(vastuvotja_mall_new, vastuvotja_mall_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja_mall (
    vastuvotja_mall_new dvk.vastuvotja_mall,
    vastuvotja_mall_old dvk.vastuvotja_mall,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja_mall';  
    primary_key_value integer := vastuvotja_mall_old.vastuvotja_mall_id;
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
		
    -- vastuvotja_mall_id changed
    IF(coalesce(vastuvotja_mall_new.vastuvotja_mall_id, 0) != coalesce(vastuvotja_mall_old.vastuvotja_mall_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_mall_id');
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
        vastuvotja_mall_old.vastuvotja_mall_id,
        vastuvotja_mall_new.vastuvotja_mall_id,
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

    -- asutus_id changed
    IF(coalesce(vastuvotja_mall_new.asutus_id, 0) != coalesce(vastuvotja_mall_old.asutus_id, 0)) THEN
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
        vastuvotja_mall_old.asutus_id,
        vastuvotja_mall_new.asutus_id,
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

    -- ametikoht_id changed
    IF(coalesce(vastuvotja_mall_new.ametikoht_id, 0) != coalesce(vastuvotja_mall_old.ametikoht_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht_id');
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
        vastuvotja_mall_old.ametikoht_id,
        vastuvotja_mall_new.ametikoht_id,
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

    -- isikukood changed
    IF(coalesce(vastuvotja_mall_new.isikukood, ' ') != coalesce(vastuvotja_mall_old.isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('isikukood');
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
        vastuvotja_mall_old.isikukood,
        vastuvotja_mall_new.isikukood,
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

    -- nimi changed
    IF(coalesce(vastuvotja_mall_new.nimi, ' ') != coalesce(vastuvotja_mall_old.nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('nimi');
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
        vastuvotja_mall_old.nimi,
        vastuvotja_mall_new.nimi,
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

    -- email changed
    IF(coalesce(vastuvotja_mall_new.email, ' ') != coalesce(vastuvotja_mall_old.email, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('email');
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
        vastuvotja_mall_old.email,
        vastuvotja_mall_new.email,
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

    -- osakonna_nr changed
    IF(coalesce(vastuvotja_mall_new.osakonna_nr, ' ') != coalesce(vastuvotja_mall_old.osakonna_nr, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nr');
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
        vastuvotja_mall_old.osakonna_nr,
        vastuvotja_mall_new.osakonna_nr,
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

    -- osakonna_nimi changed
    IF(coalesce(vastuvotja_mall_new.osakonna_nimi, ' ') != coalesce(vastuvotja_mall_old.osakonna_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('osakonna_nimi');
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
        vastuvotja_mall_old.osakonna_nimi,
        vastuvotja_mall_new.osakonna_nimi,
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

    -- saatmisviis_id changed
    IF(coalesce(vastuvotja_mall_new.saatmisviis_id, 0) != coalesce(vastuvotja_mall_old.saatmisviis_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('saatmisviis_id');
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
        vastuvotja_mall_old.saatmisviis_id,
        vastuvotja_mall_new.saatmisviis_id,
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

    -- asutuse_nimi changed
    IF(coalesce(vastuvotja_mall_new.asutuse_nimi, ' ') != coalesce(vastuvotja_mall_old.asutuse_nimi, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('asutuse_nimi');
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
        vastuvotja_mall_old.asutuse_nimi,
        vastuvotja_mall_new.asutuse_nimi,
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

    -- allyksus_id changed
    IF(coalesce(vastuvotja_mall_new.allyksus_id, 0) != coalesce(vastuvotja_mall_old.allyksus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksus_id');
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
        vastuvotja_mall_old.allyksus_id,
        vastuvotja_mall_new.allyksus_id,
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

    -- tingimus_xpath changed
    IF(coalesce(vastuvotja_mall_new.tingimus_xpath, ' ') != coalesce(vastuvotja_mall_old.tingimus_xpath, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tingimus_xpath');
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
        vastuvotja_mall_old.tingimus_xpath,
        vastuvotja_mall_new.tingimus_xpath,
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

    -- allyksuse_lyhinimetus changed
    IF(coalesce(vastuvotja_mall_new.allyksuse_lyhinimetus, ' ') != coalesce(vastuvotja_mall_old.allyksuse_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('allyksuse_lyhinimetus');
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
        vastuvotja_mall_old.allyksuse_lyhinimetus,
        vastuvotja_mall_new.allyksuse_lyhinimetus,
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

    -- ametikoha_lyhinimetus changed
    IF(coalesce(vastuvotja_mall_new.ametikoha_lyhinimetus, ' ') != coalesce(vastuvotja_mall_old.ametikoha_lyhinimetus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoha_lyhinimetus');
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
        vastuvotja_mall_old.ametikoha_lyhinimetus,
        vastuvotja_mall_new.ametikoha_lyhinimetus,
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
		
		
END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION tr_vastuvotja_staatus_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	vastuvotja_staatus_new vastuvotja_staatus%ROWTYPE;
	vastuvotja_staatus_old vastuvotja_staatus%ROWTYPE;  
BEGIN			
	  if tg_op = 'INSERT' then
		  tr_operation := 'INSERT';		  		
		  VASTUVOTJA_STAATUS_new.VASTUVOTJA_STAATUS_ID := NEW.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_new.NIMETUS := NEW.NIMETUS;
	   elsif tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  VASTUVOTJA_STAATUS_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_old.NIMETUS := OLD.NIMETUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  VASTUVOTJA_STAATUS_old.VASTUVOTJA_STAATUS_ID := OLD.VASTUVOTJA_STAATUS_ID;
		  VASTUVOTJA_STAATUS_old.NIMETUS := OLD.NIMETUS;
	  end if;	

	  execute dvklog.log_vastuvotja_staatus(vastuvotja_staatus_new, vastuvotja_staatus_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_vastuvotja_staatus (
    vastuvotja_staatus_new dvk.vastuvotja_staatus,
    vastuvotja_staatus_old dvk.vastuvotja_staatus,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'vastuvotja_staatus';  
    primary_key_value integer := vastuvotja_staatus_old.vastuvotja_staatus_id;
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
		
		
    -- vastuvotja_staatus_id changed
    IF(coalesce(vastuvotja_staatus_new.vastuvotja_staatus_id, 0) != coalesce(vastuvotja_staatus_old.vastuvotja_staatus_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vastuvotja_staatus_id');
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
        vastuvotja_staatus_old.vastuvotja_staatus_id,
        vastuvotja_staatus_new.vastuvotja_staatus_id,
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
    IF(coalesce(vastuvotja_staatus_new.nimetus, ' ') != coalesce(vastuvotja_staatus_old.nimetus, ' ')) THEN
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
        vastuvotja_staatus_old.nimetus,
        vastuvotja_staatus_new.nimetus,
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
				
END;$$ 
LANGUAGE PLPGSQL;    




CREATE OR REPLACE FUNCTION tr_logi_log() RETURNS TRIGGER AS $$
DECLARE
	tr_operation character varying;
	logi_new logi%ROWTYPE;
	logi_old logi%ROWTYPE;  
BEGIN			
	   if tg_op = 'UPDATE' then    
		  tr_operation := 'UPDATE';
		  logi_old.LOG_ID := OLD.LOG_ID;
		  logi_old.TABEL := OLD.TABEL;
		  logi_old.OP := OLD.OP;
		  logi_old.UIDCOL := OLD.UIDCOL;
		  logi_old.TABEL_UID := OLD.TABEL_UID;
		  logi_old.VEERG := OLD.VEERG;
		  logi_old.CTYPE := OLD.CTYPE;
		  logi_old.VANA_VAARTUS := OLD.VANA_VAARTUS;
		  logi_old.UUS_VAARTUS := OLD.UUS_VAARTUS;
		  logi_old.MUUTMISE_AEG := OLD.MUUTMISE_AEG;
		  logi_old.AB_KASUTAJA := OLD.AB_KASUTAJA;
		  logi_old.EF_KASUTAJA := OLD.EF_KASUTAJA;
		  logi_old.KASUTAJA_KOOD := OLD.KASUTAJA_KOOD;
		  logi_old.COMM := OLD.COMM;
		  logi_old.CREATED := OLD.CREATED;
		  logi_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  logi_old.USERNAME := OLD.USERNAME;
		  logi_old.AMETIKOHT := OLD.AMETIKOHT;
		  logi_old.XTEE_ISIKUKOOD := OLD.XTEE_ISIKUKOOD;
		  logi_old.XTEE_ASUTUS := OLD.XTEE_ASUTUS;
	   elsif tg_op = 'DELETE' then    
		  tr_operation := 'DELETE'; 	
		  logi_old.LOG_ID := OLD.LOG_ID;
		  logi_old.TABEL := OLD.TABEL;
		  logi_old.OP := OLD.OP;
		  logi_old.UIDCOL := OLD.UIDCOL;
		  logi_old.TABEL_UID := OLD.TABEL_UID;
		  logi_old.VEERG := OLD.VEERG;
		  logi_old.CTYPE := OLD.CTYPE;
		  logi_old.VANA_VAARTUS := OLD.VANA_VAARTUS;
		  logi_old.UUS_VAARTUS := OLD.UUS_VAARTUS;
		  logi_old.MUUTMISE_AEG := OLD.MUUTMISE_AEG;
		  logi_old.AB_KASUTAJA := OLD.AB_KASUTAJA;
		  logi_old.EF_KASUTAJA := OLD.EF_KASUTAJA;
		  logi_old.KASUTAJA_KOOD := OLD.KASUTAJA_KOOD;
		  logi_old.COMM := OLD.COMM;
		  logi_old.CREATED := OLD.CREATED;
		  logi_old.LAST_MODIFIED := OLD.LAST_MODIFIED;
		  logi_old.USERNAME := OLD.USERNAME;
		  logi_old.AMETIKOHT := OLD.AMETIKOHT;
		  logi_old.XTEE_ISIKUKOOD := OLD.XTEE_ISIKUKOOD;
		  logi_old.XTEE_ASUTUS := OLD.XTEE_ASUTUS;
	  end if;	

	  execute dvklog.log_logi(logi_new, logi_old, tr_operation);       		  	  
      IF tg_op = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF; 

END;$$ 
LANGUAGE PLPGSQL;    


CREATE OR REPLACE FUNCTION dvklog.log_logi (
    logi_new dvk.logi,
    logi_old dvk.logi,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'logi';  
    primary_key_value integer := logi_old.log_id;
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

    -- log_id changed
    IF(coalesce(logi_new.log_id, 0) != coalesce(logi_old.log_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('log_id');
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
        logi_old.log_id,
        logi_new.log_id,
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

    -- tabel changed
    IF(coalesce(logi_new.tabel, ' ') != coalesce(logi_old.tabel, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel');
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
        logi_old.tabel,
        logi_new.tabel,
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

    -- op changed
    IF(coalesce(logi_new.op, ' ') != coalesce(logi_old.op, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('op');
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
        logi_old.op,
        logi_new.op,
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

    -- uidcol changed
    IF(coalesce(logi_new.uidcol, ' ') != coalesce(logi_old.uidcol, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uidcol');
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
        logi_old.uidcol,
        logi_new.uidcol,
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

    -- tabel_uid changed
    IF(coalesce(logi_new.tabel_uid, 0) != coalesce(logi_old.tabel_uid, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('tabel_uid');
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
        logi_old.tabel_uid,
        logi_new.tabel_uid,
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

    -- veerg changed
    IF(coalesce(logi_new.veerg, ' ') != coalesce(logi_old.veerg, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('veerg');
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
        logi_old.veerg,
        logi_new.veerg,
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

    -- ctype changed
    IF(coalesce(logi_new.ctype, ' ') != coalesce(logi_old.ctype, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ctype');
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
        logi_old.ctype,
        logi_new.ctype,
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

    -- vana_vaartus changed
    IF(coalesce(logi_new.vana_vaartus, ' ') != coalesce(logi_old.vana_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('vana_vaartus');
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
        logi_old.vana_vaartus,
        logi_new.vana_vaartus,
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

    -- uus_vaartus changed
    IF(coalesce(logi_new.uus_vaartus, ' ') != coalesce(logi_old.uus_vaartus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('uus_vaartus');
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
        logi_old.uus_vaartus,
        logi_new.uus_vaartus,
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

    -- muutmise_aeg changed
    IF(coalesce(logi_new.muutmise_aeg, LOCALTIMESTAMP) != coalesce(logi_old.muutmise_aeg, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('muutmise_aeg');
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
        logi_old.muutmise_aeg,
        logi_new.muutmise_aeg,
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

    -- ab_kasutaja changed
    IF(coalesce(logi_new.ab_kasutaja, ' ') != coalesce(logi_old.ab_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ab_kasutaja');
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
        logi_old.ab_kasutaja,
        logi_new.ab_kasutaja,
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

    -- ef_kasutaja changed
    IF(coalesce(logi_new.ef_kasutaja, ' ') != coalesce(logi_old.ef_kasutaja, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ef_kasutaja');
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
        logi_old.ef_kasutaja,
        logi_new.ef_kasutaja,
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

    -- kasutaja_kood changed
    IF(coalesce(logi_new.kasutaja_kood, ' ') != coalesce(logi_old.kasutaja_kood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('kasutaja_kood');
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
        logi_old.kasutaja_kood,
        logi_new.kasutaja_kood,
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

    -- comm changed
    IF(coalesce(logi_new.comm, ' ') != coalesce(logi_old.comm, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('comm');
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
        logi_old.comm,
        logi_new.comm,
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
    IF(coalesce(logi_new.created, LOCALTIMESTAMP) != coalesce(logi_old.created, LOCALTIMESTAMP)) THEN
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
        logi_old.created,
        logi_new.created,
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
    IF(coalesce(logi_new.last_modified, LOCALTIMESTAMP) != coalesce(logi_old.last_modified, LOCALTIMESTAMP)) THEN
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
        logi_old.last_modified,
        logi_new.last_modified,
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
    IF(coalesce(logi_new.username, ' ') != coalesce(logi_old.username, ' ')) THEN
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
        logi_old.username,
        logi_new.username,
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

    -- ametikoht changed
    IF(coalesce(logi_new.ametikoht, 0) != coalesce(logi_old.ametikoht, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('ametikoht');
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
        logi_old.ametikoht,
        logi_new.ametikoht,
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

    -- xtee_isikukood changed
    IF(coalesce(logi_new.xtee_isikukood, ' ') != coalesce(logi_old.xtee_isikukood, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_isikukood');
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
        logi_old.xtee_isikukood,
        logi_new.xtee_isikukood,
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

    -- xtee_asutus changed
    IF(coalesce(logi_new.xtee_asutus, ' ') != coalesce(logi_old.xtee_asutus, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('xtee_asutus');
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
        logi_old.xtee_asutus,
        logi_new.xtee_asutus,
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
		
		
END;$$ 
LANGUAGE PLPGSQL;    
		

		
CREATE OR REPLACE FUNCTION dvklog.log_dokumendi_fragment (
    dokumendi_fragment_new dvk.dokumendi_fragment,
    dokumendi_fragment_old dvk.dokumendi_fragment,
    tr_operation character varying)	
      RETURNS VOID AS $$	  	  
DECLARE    
    clmn      information_schema.columns;
    usr       character varying;
    pkey_col  character varying;
    tablename character varying := 'dokumendi_fragment';  
    primary_key_value integer := dokumendi_fragment_old.fragment_id;
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
		
		
    -- fragment_id changed
    IF(coalesce(dokumendi_fragment_new.fragment_id, 0) != coalesce(dokumendi_fragment_old.fragment_id, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_id');
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
        dokumendi_fragment_old.fragment_id,
        dokumendi_fragment_new.fragment_id,
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

    -- sissetulev changed
    IF(coalesce(dokumendi_fragment_new.sissetulev, 0) != coalesce(dokumendi_fragment_old.sissetulev, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('sissetulev');
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
        dokumendi_fragment_old.sissetulev,
        dokumendi_fragment_new.sissetulev,
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

    -- asutus_id changed
    IF(coalesce(dokumendi_fragment_new.asutus_id, 0) != coalesce(dokumendi_fragment_old.asutus_id, 0)) THEN
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
        dokumendi_fragment_old.asutus_id,
        dokumendi_fragment_new.asutus_id,
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

    -- edastus_id changed
    IF(coalesce(dokumendi_fragment_new.edastus_id, ' ') != coalesce(dokumendi_fragment_old.edastus_id, ' ')) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('edastus_id');
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
        dokumendi_fragment_old.edastus_id,
        dokumendi_fragment_new.edastus_id,
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

    -- fragment_nr changed
    IF(coalesce(dokumendi_fragment_new.fragment_nr, 0) != coalesce(dokumendi_fragment_old.fragment_nr, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragment_nr');
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
        dokumendi_fragment_old.fragment_nr,
        dokumendi_fragment_new.fragment_nr,
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

    -- fragmente_kokku changed
    IF(coalesce(dokumendi_fragment_new.fragmente_kokku, 0) != coalesce(dokumendi_fragment_old.fragmente_kokku, 0)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('fragmente_kokku');
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
        dokumendi_fragment_old.fragmente_kokku,
        dokumendi_fragment_new.fragmente_kokku,
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

    -- loodud changed
    IF(coalesce(dokumendi_fragment_new.loodud, LOCALTIMESTAMP) != coalesce(dokumendi_fragment_old.loodud, LOCALTIMESTAMP)) THEN
      SELECT * INTO clmn FROM information_schema.columns WHERE upper(table_name) = tablename AND upper(column_name) = upper('loodud');
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
        dokumendi_fragment_old.loodud,
        dokumendi_fragment_new.loodud,
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
		

END;$$ 
LANGUAGE PLPGSQL;