ALTER TABLE vahendaja
DROP CONSTRAINT fk_vahendaja_2
/

ALTER TABLE vahendaja
ADD CONSTRAINT fk_vahendaja_2
FOREIGN KEY (asutus_id)
REFERENCES asutus (asutus_id)
/