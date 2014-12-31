SET dvkxtee.xtee_asutus = '';
SET dvkxtee.xtee_isikukood = '';

INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) SELECT -1, NULL, NULL, NULL, NULL WHERE NOT EXISTS ( SELECT kaust_id FROM kaust WHERE kaust_id = -1);
INSERT INTO kaust(kaust_id, nimi, ylemkaust_id, asutus_id, kausta_number) VALUES(0, '/', NULL, NULL, NULL WHERE NOT EXISTS ( SELECT kaust_id FROM kaust WHERE kaust_id = 0);

INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  1, 'Dokumente on puudu (Pooleli)' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 1);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  2, 'Järjekorras' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 2);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  3, 'Ootel' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 3);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  4, 'Lõpetatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 4);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  5, 'Tagasi lükatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 5);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  6, 'Teha' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 6);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  7, 'Töötlemisel' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 7);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  8, 'Aktsepteeritud (Võetud töösse)' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 8);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  9, 'Salvestatud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 9);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  10, 'Arhiveeritud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 1);
INSERT INTO vastuvotja_staatus(vastuvotja_staatus_id, nimetus) SELECT  11, 'Saadetud' WHERE NOT EXISTS ( SELECT vastuvotja_staatus_id FROM vastuvotja_staatus WHERE vastuvotja_staatus_id = 11);

INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) SELECT  1,'Saatmisviis' WHERE NOT EXISTS ( SELECT klassifikaatori_tyyp_id FROM klassifikaatori_tyyp WHERE klassifikaatori_tyyp_id = 1);
INSERT INTO klassifikaatori_tyyp(klassifikaatori_tyyp_id, nimetus) SELECT  2,'Dokumendi olek' WHERE NOT EXISTS ( SELECT klassifikaatori_tyyp_id FROM klassifikaatori_tyyp WHERE klassifikaatori_tyyp_id = 2);

INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  1, 'xtee', 1 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 1);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  2, 'epost', 1 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 2);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  101, 'saatmisel', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 101);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  102, 'saadetud', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 102);
INSERT INTO klassifikaator(klassifikaator_id, nimetus, klassifikaatori_tyyp_id) SELECT  103, 'katkestatud', 2 WHERE NOT EXISTS ( SELECT klassifikaator_id FROM klassifikaator WHERE klassifikaator_id = 103);
    
INSERT INTO parameetrid(aar_viimane_sync) VALUES (current_date);


INSERT INTO dvk.asutus (registrikood, nimetus, liik2, dhl_saatmine, dhs_nimetus) 
VALUES ('70006317', 'RIA', null, '1', null);

INSERT INTO dvk.isik (kood, perenimi, eesnimi) 
VALUES ('38603052255', 'Potapov', 'Aleksandr');

INSERT INTO dvk.isik (kood, perenimi, eesnimi) 
VALUES ('38806190294', 'Tammemäe', 'Lauri');

INSERT INTO dvk.ametikoht (asutus_id, ametikoht_nimetus) 
VALUES ((SELECT asutus_id FROM dvk.asutus 
WHERE registrikood='70006317'),'Raamatupidamine');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='70006317')),(SELECT i_id FROM dvk.isik WHERE kood='38603052255'),'0');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='70006317')),(SELECT i_id FROM dvk.isik WHERE kood='38806190294'),'0');

INSERT INTO dvk.oigus_antud (asutus_id, ametikoht_id, roll, peatatud) 
VALUES ((SELECT asutus_id FROM dvk.asutus WHERE registrikood='70006317'),(SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='70006317')),'DHL: asutuse administraator','0');



INSERT INTO dvk.asutus (registrikood, nimetus, liik2, dhl_saatmine, dhs_nimetus) 
VALUES ('10839212', 'Webware', null, '1', null);

INSERT INTO dvk.ametikoht (asutus_id, ametikoht_nimetus) 
VALUES ((SELECT asutus_id FROM dvk.asutus 
WHERE registrikood='10839212'),'Raamatupidamine');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='10839212')),(SELECT i_id FROM dvk.isik WHERE kood='38603052255'),'0');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='10839212')),(SELECT i_id FROM dvk.isik WHERE kood='38806190294'),'0');

INSERT INTO dvk.oigus_antud (asutus_id, ametikoht_id, roll, peatatud) 
VALUES ((SELECT asutus_id FROM dvk.asutus WHERE registrikood='10839212'),(SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='10839212')),'DHL: asutuse administraator','0');



INSERT INTO dvk.asutus (registrikood, nimetus, liik2, dhl_saatmine, dhs_nimetus) 
VALUES ('adit', 'ADIT', null, '1', null);

INSERT INTO dvk.ametikoht (asutus_id, ametikoht_nimetus) 
VALUES ((SELECT asutus_id FROM dvk.asutus 
WHERE registrikood='adit'),'Raamatupidamine');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='adit')),(SELECT i_id FROM dvk.isik WHERE kood='38603052255'),'0');

INSERT INTO dvk.ametikoht_taitmine (ametikoht_id,i_id, peatatud) 
VALUES ((SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='adit')),(SELECT i_id FROM dvk.isik WHERE kood='38806190294'),'0');

INSERT INTO dvk.oigus_antud (asutus_id, ametikoht_id, roll, peatatud) 
VALUES ((SELECT asutus_id FROM dvk.asutus WHERE registrikood='adit'),(SELECT MAX(ametikoht_id) 
FROM dvk.ametikoht 
WHERE asutus_id=(SELECT asutus_id FROM dvk.asutus WHERE registrikood='adit')),'DHL: asutuse administraator','0');


