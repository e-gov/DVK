# Testimise strateegia

Käesolev dokument määratleb seoses DHX protokolli kasutuselevõtmisega DVK-s teostatavate muudatuste testimise ulatuse, korralduse ja üksikasjad. DVK-s teostatud muudatuste testimiseks tehakse otse SOAP päringud DVK-sse (nii vastavalt DHX protokollile kui ka vastavalt DVK protokollile). SOAP päringute tegemiseks on soovitatav kasutada SOAP UI-d.

Iga punkti 1 ja punkti 2 testloo juures on olemas näidis-XML, mida võib kasutada testimiseks. Enne XML-i saatmist tuleb veenduda ja vajadusel muuta XML-i header-i _service_ ja _client_ elemendid, täites neid vajalikute andmetega (saatva süsteemi ja adressaadi andmetega). Juhul kui XML-i keha enne saatmist vajab muutmist, siis vastav info on kajastatud testiloos.  SOAP päringu saatmisel tuleb veenduda et päring saadetakse õigele X-tee turvaserverile (saatva süsteemi turvaserverile). Lisaks juhul kui testiloo käigus saadedakse kapsli, siis tuleb veenduda et kapsli adresssaat ja kapsli saatja on õiged(vastavad testiloos kirjeldatud saatja süsteemile ja kapsli adressadile).

# Testilood

##### **Tähistused:**

- Korrektselt kapseldatud fail - Elektroonilise andmevahetuse metaandmete loendile 2.1 vastavalt korrektselt kapseldatud fail.
- Korrektselt kapseldatud fail 1.0 - Elektroonilise andmevahetuse metaandmete loendile 1.0 vastavalt korrektselt kapseldatud fail.

Dvk muudatuste testimiseks on vajalikud järgmised X-tee liikmed:

DHS 1 – X-tee liige, kellel on olemas DHX alamsüsteem, aga ta ei paku DHX protokollile vastavaid teenusi või teenuste pakutav rakendus on maas.

DHS 2 – X-tee liige, kellel on olemas DHX alamsüsteem, kes on registreeritud DHX vahendajana ja pakub X-tee teenuseid representationList ja sendDocument vastavalt DHX protokollile. RepresentationList teenus peab tagastama vähemalt ühe vahendatava andmeid. Asutusel on registreeritud vähemalt üks DHX. prefiksiga(ntks DHX.subsystem) alamsüsteem kuhu võib DHX protkolli järgi dokumente saata.

DHS 3 – X-tee liige, kes on võimeline kasutada DVK-t, vastu võtta Elektroonilise andmevahetuse metaandmete loendile 2.1 vastavaid dokumente ja kes omab vähemalt ühe DVK-s asutusena registreeritud X-tee alamsüsteemi.

DHS4 - X-tee liige, kes on võimeline kasutada DVK-t ja vastu võtta ainult Elektroonilise andmevahetuse metaandmete loendile 1.0 vastavaid dokumente.

Iga testiloo juures on kirjas, millised X-tee liikmed on vajalikud konkreetse testloo täitmiseks.

Iga SOAP sõnumi X-tee headeri, service elemendi tuleb täita DVK andmetega, ehk iga SOAP sõnum tuleb saata DVK-sse.

## 1. DHX protokolli teenuste testimine

### 1.1. Õige kapsli saatmine
<pre>
   **Saatev süsteem** : DHS 1

   **Kapsli adressaat** : DHS 3

   **Saadetis** : korrektselt kapseldatud fail
</pre>
#### **  Verifitseerija toimimine (samm-sammuline)**:

- Testija saadab päringu DVK teenusesse sendDocument
  - Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
  - SOAP päringu manuseks tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna &#39;doc&#39;.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas receiptId

#### **Päringu näide:**


#### **Manus:**

