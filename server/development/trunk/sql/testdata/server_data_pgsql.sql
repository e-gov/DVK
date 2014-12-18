SET dvkxtee.xtee_asutus = '';
SET dvkxtee.xtee_isikukood = '';

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


