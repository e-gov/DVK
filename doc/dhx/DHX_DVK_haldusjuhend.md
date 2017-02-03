![](EL_Regionaalarengu_Fond_horisontaalne.jpg)
## DVK haldustegevuse muutused (seoses DHX kasutuselevõtuga)

* DHX-iga liitunud asutused lisatakse DVK andmebaasi tabelisse ASUTUS automaatselt (DHX aadressiraamatu uuendaja poolt).

* ASUTUS.DHX_ASUTUS väli väärtustatakse DHX-iga liitunud asutusel 1. Vanadel DVK-ga liitunud asutusel on selle väärtus 0. 

* Kui asutus liigub DVK kasutamise pealt üle DHX kasutajaks, siis muudetakse DVK andmebaasis ASUTUS.DHX_ASUTUS välja väärtus automaatselt 0 -> 1

* Kui on tarvis lisada uus DVK-d kasutav asutus, siis tuleb selle kirje lisamisel väärtustada ASUTUS.DHX_ASUTUS=0

* Juhul, kui kõik DHX saatmise üritused ebaõnnestuvad mingil põhjusel, aga soovitakse ikkagi uuesti saata (näiteks järgmine päev), siis tuleb andmebaasis väärtustada VASTUVOTJA.dhx_internal_consignment_id=NULL ja VASTUVOTJA.staatus_id=101 

Teades DOKUMENT.ID väärtust, võib seda teha SQL lausega:

```sql
UPDATE vastuvotja v SET
    v.dhx_internal_consignment_id = NULL,
    v.staatus_id = 101
WHERE v.staatus_id = 103
  AND v.transport_id IN (
    SELECT t.transport_id FROM transport t, dokument d
    WHERE t.dokument_id = d.dokument_id
      AND d.dokument_id = <VALUE> 
  ) 
```


## Lisainfo DHX saatmise jälgimiseks:

* ASUTUS tabelisse lisatud väli DHX_INTERNAL_CONSIGNMENT_ID (character varying(200)), mis sisaldab DVK poolt DHX-i saatmisel genereeritud saadetise id väärtust (DHX sendDocument teenuse sisendis).

* ASUTUS tabelisse lisatud väli DHX_EXTERNAL_CONSIGNMENT_ID (character varying(200)), mis sisaldab DHX-ist DVK-sse saabunud dokumendi saadetise id väärtust.

* ASUTUS tabelisse lisatud väli DHX_EXTERNAL_RECEIPT_ID (character varying(200)), mis sisaldab DHX-ist DVK-sse saabunud sendDocument pärgingu vastuseks genereeritud recepient id väärtust.

* VASTUVOTJA tabelisse lisatud väli LAST_SEND_DATE (timestamp). See sisaldab kuupäeva ja kellaaeg, millel tehti viimane DHX edasi saatmise üritus.

* Kui DHX adressaat saadab DVK-le dokumendi kapsli, mis ei valideeru või sisaldab valet adressaati, siis selline viga logitakse ainult DVK Serveri logi failis. Selle kohta DVK andmebaasi kirjeid ei teki.
