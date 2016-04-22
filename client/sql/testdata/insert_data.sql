-- Kliendi andmebaasi testandmete sisestamise skript
BEGIN
	
	INSERT INTO dhl_settings(
		id,
		institution_code, 
		institution_name, 
		personal_id_code, 
		unit_id, 
		subdivision_code, 
		occupation_code, 
		subdivision_short_name, 
		occupation_short_name, 
		subdivision_name, 
		occupation_name, 
		container_version
	) VALUES (
		1,
		'87654321', 
		'Asutus', 
		'38005130332', 
		0, 
		2, 
		2, 
		'SEPIKODA',
		'INSENER', 
		'Sepikoda', 
		'Insener', 
		2
	);

END;
/
