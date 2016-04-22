
INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) SELECT -1, NULL, NULL, NULL, NULL WHERE NOT EXISTS ( SELECT kaust_id FROM kaust WHERE kaust_id = -1);
INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) SELECT 0, '/', NULL, NULL, NULL WHERE NOT EXISTS ( SELECT kaust_id FROM kaust WHERE kaust_id = 0);

INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  1, 'Dokumente on puudu (Pooleli)' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 1);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  2, 'Järjekorras' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 2);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  3, 'Ootel' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 3);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  4, 'Lõpetatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 4);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  5, 'Tagasi lükatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 5);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  6, 'Teha' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 6);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  7, 'Töötlemisel' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 7);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  8, 'Aktsepteeritud (Võetud töösse)' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 8);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  9, 'Salvestatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 9);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  10, 'Arhiveeritud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 10);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  11, 'Saadetud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 11);

INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) SELECT  1,'Saatmisviis' WHERE NOT EXISTS ( SELECT klassifikaatori_tyyp_id FROM klassifikaatori_tyyp WHERE klassifikaatori_tyyp_id = 1);
INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) SELECT  2,'Dokumendi olek' WHERE NOT EXISTS ( SELECT klassifikaatori_tyyp_id FROM klassifikaatori_tyyp WHERE klassifikaatori_tyyp_id = 2);

INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  1, 'xtee', 1 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 1);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  2, 'epost', 1 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 2);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  101, 'saatmisel', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 101);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  102, 'saadetud', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 102);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  103, 'katkestatud', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 103);
    

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
		'38005130332',
		'Lember',
		'Jaak',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null);


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
		'87654321',
		null,
		null,
		null,
		'Asutus',
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
		null);

	
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
		'12345678',
		null,
		1,
		'87654321',
		'Asutus 2',
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
		0,
		1,
		null,
		'1.6',
		null,
		null);

	
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
		1,
		null,
		'Raamatupidamine',
		null,
		null,
		null,
		0,
		null,
		'RMTP',
		null);

		
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
		1,
		null,
		'Sepikoda',
		null,
		null,
		null,
		0,
		null,
		'SEPIKODA',
		null);
	 
	
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
		1,
		null,
		'Dokumendihalduse osakond',
		null,
		null,
		null,
		0,
		null,
		'DH',
		null);

		
		
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
		1,
		3,
		'Ä†ļæ½ldosakond',
		null,
		null,
		null,
		0,
		null,
		'YLD',
		null);

	
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
		1,
		'Pearaamatupidaja',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		'PEARMTP');

		
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
		1,
		'Sepp',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		'SEPP');

	
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
		1,
		'Dokumendihaldur',
		null,
		null,
		null,
		null,
		null,
		3,
		null,
		null,
		'DOKHALDUR');

	
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
		3,
		1,
		null,
		null,
		'PK',
		null,
		null,
		null,
		null,
		null);

	
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
		1,
		null,
		3,
		'DHL: asutuse administraator',
		null,
		null,
		null,
		null,
		null,
		null,
		null);
