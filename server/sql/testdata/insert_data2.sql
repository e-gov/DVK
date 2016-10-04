-- Inserts test data into DVK Server database
DECLARE
	
	i_id_tmp isik.i_id%TYPE;
	
	asutus1_id_tmp asutus.asutus_id%TYPE;
	asutus2_id_tmp asutus.asutus_id%TYPE;
	
	allyksus1_id_tmp allyksus.id%TYPE;
	allyksus2_id_tmp allyksus.id%TYPE;
	allyksus3_id_tmp allyksus.id%TYPE;
	allyksus4_id_tmp allyksus.id%TYPE;
	
	ametikoht1_id_tmp ametikoht.ametikoht_id%TYPE;
	ametikoht2_id_tmp ametikoht.ametikoht_id%TYPE;
	ametikoht3_id_tmp ametikoht.ametikoht_id%TYPE;
	
	taitmine_id_tmp ametikoht_taitmine.taitmine_id%TYPE;
	
	OIGUS_ANTUD_ID_tmp oigus_antud.OIGUS_ANTUD_ID%TYPE;
	
BEGIN
	
	Insert into ISIK (
		KOOD,
		PERENIMI,
		EESNIMI,
		MAAKOND,
		AADRESS,
		POSTIKOOD,
		TELEFON,
		E_POST,
		WWW,
		PARAMS,
		CREATED,
		LAST_MODIFIED,
		USERNAME
	) values (
		'38407054999',
		'Marko',
		'Kurm',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null
	) returning i_id into i_id_tmp;

	Insert into ASUTUS (
		REGISTRIKOOD,
		E_REGISTRIKOOD,
		KS_ASUTUS_ID,
		KS_ASUTUS_KOOD,
		NIMETUS,
		LNIMI,
		LIIK1,
		LIIK2,
		TEGEVUSALA,
		TEGEVUSPIIRKOND,
		MAAKOND,
		ASUKOHT,
		AADRESS,
		POSTIKOOD,
		TELEFON,
		FAKS,
		E_POST,
		WWW,
		LOGO,
		ASUTAMISE_KP,
		MOOD_AKT_NIMI,
		MOOD_AKT_NR,
		MOOD_AKT_KP,
		PM_AKT_NIMI,
		PM_AKT_NR,
		PM_KINNITAMISE_KP,
		PM_KANDE_KP,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		PARAMS,
		DHL_OTSE_SAATMINE,
		DHL_SAATMINE,
		DHS_NIMETUS,
		TOETATAV_DVK_VERSIOON,
		SERVER_ID,
		AAR_ID
	) values (
		'99954321',
		null,
		null,
		null,
		'Maa-amet',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		1,
		null,
		'1.6',
		null,
		null
	) returning asutus_id into asutus1_id_tmp;
	
	Insert into ALLYKSUS (
		ASUTUS_ID,
		VANEM_ID,
		ALLYKSUS,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		MUUTM_ARV,
		AAR_ID,
		LYHINIMETUS,
		ADR_URI
	) values (
		asutus1_id_tmp,
		null,
		'Raamatupidamine',
		null,
		null,
		null,
		0,
		null,
		'RMTP',
		null
	) returning id into allyksus1_id_tmp;
		
	Insert into ALLYKSUS (
		ASUTUS_ID,
		VANEM_ID,
		ALLYKSUS,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		MUUTM_ARV,
		AAR_ID,
		LYHINIMETUS,
		ADR_URI
	) values (
		asutus1_id_tmp,
		null,
		'Sepikoda',
		null,
		null,
		null,
		0,
		null,
		'SEPIKODA',
		null
	) returning id into allyksus2_id_tmp;
	
	Insert into ALLYKSUS (
		ASUTUS_ID,
		VANEM_ID,
		ALLYKSUS,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		MUUTM_ARV,
		AAR_ID,
		LYHINIMETUS,
		ADR_URI
	) values (
		asutus1_id_tmp,
		null,
		'Dokumendihalduse osakond',
		null,
		null,
		null,
		0,
		null,
		'DH',
		null
	) returning id into allyksus3_id_tmp;
		
		
	Insert into ALLYKSUS (
		ASUTUS_ID,
		VANEM_ID,
		ALLYKSUS,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		MUUTM_ARV,
		AAR_ID,
		LYHINIMETUS,
		ADR_URI
	) values (
		asutus1_id_tmp,
		allyksus3_id_tmp,
		'Üldosakond',
		null,
		null,
		null,
		0,
		null,
		'YLD',
		null
	) returning id into allyksus4_id_tmp;
	
	Insert into AMETIKOHT (
		KS_AMETIKOHT_ID,
		ASUTUS_ID,
		AMETIKOHT_NIMETUS,
		ALATES,
		KUNI,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		ALLYKSUS_ID,
		PARAMS,
		AAR_ID,
		LYHINIMETUS
	) values (
		null,
		asutus1_id_tmp,
		'Pearaamatupidaja',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		'PEARMTP'
	) returning ametikoht_id into ametikoht1_id_tmp;
		
	Insert into AMETIKOHT (
		KS_AMETIKOHT_ID,
		ASUTUS_ID,
		AMETIKOHT_NIMETUS,
		ALATES,
		KUNI,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		ALLYKSUS_ID,
		PARAMS,
		AAR_ID,
		LYHINIMETUS
	) values (
		null,
		asutus1_id_tmp,
		'Sepp',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		'SEPP'
	) returning ametikoht_id into ametikoht2_id_tmp;
	
	Insert into AMETIKOHT (
		KS_AMETIKOHT_ID,
		ASUTUS_ID,
		AMETIKOHT_NIMETUS,
		ALATES,
		KUNI,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		ALLYKSUS_ID,
		PARAMS,
		AAR_ID,
		LYHINIMETUS
	) values (
		null,
		asutus1_id_tmp,
		'Dokumendihaldur',
		null,
		null,
		null,
		null,
		null,
		allyksus3_id_tmp,
		null,
		null,
		'DOKHALDUR'
	) returning ametikoht_id into ametikoht3_id_tmp;
	
	Insert into AMETIKOHT_TAITMINE (
		AMETIKOHT_ID,
		I_ID,
		ALATES,
		KUNI,
		ROLL,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		PEATATUD,
		AAR_ID
	) values (
		ametikoht3_id_tmp,
		i_id_tmp,
		null,
		null,
		'PK',
		null,
		null,
		null,
		null,
		null
	) returning taitmine_id into taitmine_id_tmp;
	
	Insert into OIGUS_ANTUD (
		ASUTUS_ID,
		MUU_ASUTUS_ID,
		AMETIKOHT_ID,
		ROLL,
		ALATES,
		KUNI,
		CREATED,
		LAST_MODIFIED,
		USERNAME,
		PEATATUD,
		ALLYKSUS_ID
	) values (
		asutus1_id_tmp,
		null,
		ametikoht3_id_tmp,
		'DHL: asutuse administraator',
		null,
		null,
		null,
		null,
		null,
		null,
		null
	) returning OIGUS_ANTUD_ID into OIGUS_ANTUD_ID_tmp;

END;
/