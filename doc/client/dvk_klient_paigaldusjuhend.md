# Dokumendivahetuskeskuse Universaalkliendi paigaldamisjuhend

## Sisukord

- [Nõudmised arvutile](#nõudmised-arvutile)
- [Paigaldamine](#paigaldamine)
- [Konfiguratsioonifail _dvk_client.properties_](#konf1)
   * [Konfiguratsioonimuutujate selgitused](#konf1-1)
- [Konfiguratsioonifail _client_config.xml_](#konf2)
- [Universaalkliendi seadistamine HTTPS protokolli kasutamiseks](#https)
- [Universaalkliendi seadistamine andmete edastamiseks otse andmebaaside vahel](#baasid)
- [Vanade dokumentide kustutamine universaalkliendi andmetabelitest](#kustutamine)
- [Rakenduse ehitamine](#rakenduse-ehitamine)
- [Logimise seadistamine](#logimise-seadistamine)

## Muutelugu

| Muutmiskuupäev | Versioon | Kirjeldus | Autor |
|---|---|---|---|
| 11.05.2006 | 1.0 | Dokumendi esialgne versioon. | Jaak Lember |
| 02.11.2006 | 1.1 | Lisatud PostgreSQL tuge puudutavad andmed. Konfiguratsioonifaili näidisesse lisatud veateadete e-kirja teel raporteerimise seaded. Seoses andmekogu nime muutumisega asendatud tekstis „Dokumendihoidla” -> „Dokumendivahetuskeskus” ja lühendid „DHL” -> „DVK” | Jaak Lember |
| 12.02.2007 | 1.2 | Lisatud config.xml faili kirjeldusele instance_name parameetri näide MSSQL 2005 instantside kasutamiseks. Lisatud config.xml parameetrite loetelu ja selgitused. Lisatud config.xml faili kirjeldusele DVK ühendusega seotud parameetrite kirjeldused ja kasutamise näide. | Jaak Lember |
| 03.05.2007 | 1.2.1 | Lisatud config.xml faili kirjeldusele schema_name parameetri näide PostgreSQL andmebaasi skeemi täpsustamiseks. | Jaak Lember |
| 17.07.2008 | 1.3 | Asendatud tekstis konfiguratsioonifaili nimi „dhlclient.properties“ „dvk_client.properties“ vastu. Asendatud tekstis konfiguratsioonifaili nimi „config.xml“ „client_config.properties“ vastu. Täiendatud konfiguratsioonifaili dvk_client.properties näidist. Lisatud konfiguratsioonifailis dvk_client.properties kasutatavate muutujate selgitused. | Jaak Lember |
| 30.07.2008 | 1.3.1 | Lisatud tabeli DHL_SETTINGS täitmise juhis. Täiendatud konfiguratsioonifaili dvk_client.properties näidet ja konfiguratsioonimuutujate kirjeldusi. | Jaak Lember |
| 25.02.2010 | 1.4 | Täiendatud konfiguratsioonifaili client_config.xml kirjeldust. Lisatud peatükk „Universaalkliendi seadistamine andmete edastamiseks otse andmebaaside vahel“. Kaasajastatud ja lihtsustatud paigaldusprotsessi kirjeldust peatükis „Paigaldamine“. | Jaak Lember |
| 03.03.2010 | 1.4.1 | Täiendatud paigaldusprotsessi kirjeldust peatükis „Paigaldamine“. Täiendatud konfiguratsioonifaili dvk_client.properties kirjeldust. Täiendatud konfiguratsioonifaili client_config.xml kirjeldust. Täiendatud peatükki „Universaalkliendi seadistamine andmete edastamiseks otse andmebaaside vahel“ Lisatud punkt 6 – „Rakenduse ehitamine“. Lisatud punkt 7 – „Logimise seadistamine“. | Jaak Lember |
| 30.06.2010 | 1.4.2 | Parandatud formaatimist ja viitamiste teistele dokumentidele | Hannes Kiivet |
| 30.08.2010 | 1.4.3 | Lisatud juhised universaalkliendi paigaldamiseks ja kasutamiseks SQL Anywhere andmebaasiplatvormil. | Jaak Lember |
| 03.11.2010 | 1.4.4 | Lisatud juhised universaalkliendi seadistamiseks, kui andmevahetuseks turvaserveriga kasutatakse HTTPS protokolli. Lisatud dokumendile sisukord. | Jaak Lember |
| 11.02.2011 | 1.6.1 | Viidud dokumendi versiooninumber vastavusse rakenduse versiooninumbriga. Lisatud peatükk „Vanade dokumentide kustutamine universaalkliendi andmetabelitest“. Täiendatud client_config.xml faili näiteid. Täiendatud skriptide automaatse käivitamise kirjeldust paigaldamise peatüki lõpus. | Jaak Lember |
| 10.05.2011 | 1.6.2 | Täiendatud peatükki „Rakenduse ehitamine“. | Jaak Lember |
| 17.03.2014 | 1.7.1 | Täiendatud client_config.xml faili näiteid ja konfiguratsiooni. | Hendrik Pärna |
| 08.04.2014 | 1.7.3 | ReceiveDocuments päringu vastuvõetavate dokumentide arvu on võimalik client_config.xml'is seadistada parameetriga receive_documents_amount | Hendrik Pärna |
| 03.07.2014 | 1.7.6 | Täiendatud paigalduse järeltingimusi | Hendrik Pärna |
| 26.01.2015 | 1.7.8 | Logimise parameetrid ja fail uuendatud | Aleksei Kokarev |
| 20.01.2016 | 1.7.9 | Muudetud SVN lingid Githubi linkideks | Kertu Hiire |
| 05.12.2016 | 1.7.10 | Dokumentatsioon üle viidud MarkDown formaati ilma sisulisi muudatusi teostamata | Kertu Hiire |

## Nõudmised arvutile

- Arvutis, kuhu dokumendivahetuskeskuse (DVK) klient paigaldatakse, peab olema installeeritud Java Runtime Environment (JRE) 1.6.0 või uuem.
- Liidestatav infosüsteem peab kasutama ühte järgmistest andmebaasiplatvormidest:
   * Microsoft SQL Server 2000 või uuem
   * Oracle 10g või uuem
   * PostgreSQL 8.0 või uuem
   * SQL Anywhere 9.0 või uuem

## Paigaldamine

1. Lae alla kliendi kompileeritud kood (https://github.com/e-gov/DVK/blob/master/installers/dvk_client-[kliendi-versioon].zip ) või ehita rakendus ise lähtekoodist (vt. peatükki [Rakenduse ehitamine](#rakenduse-ehitamine) ).
2. Paki kaust **dvk_client** lahti arvuti kõvakettale.
3. Ava lahtipakitud kaust **dvk_client** ja kontrolli, et selles asuvatel .cmd (Windows) ja .sh (Unix/Linux) failidele oleks antud käivitamisõigus (_Execute_).
4. Ava fail **dvk_client.properties** ja kirjuta konfiguratsioonimuutuja **service_url** väärtuseks oma turvaserveri aadress. X-Tee turvaserveri aadress näeb välja järgmine:
   ```
   http://[turvaserveri siseliidese IP]/cgi-bin/consumer_proxy
   ```
5. Failis **dvk_client.properties** oleks kasulik ära muuta kõik teile vajalikud seaded (vt 3. peatükki).
6. Ava fail **client_config.xml** ja määra seal ära liidestatava rakenduse andmebaasiühenduse parameetrid (vt. 4. peatükki). Kui vajalik on universaalklientide ühendamine otsesuhtluseks, siis tuleb ka see samas failis ära seadistada (vt. 5. peatükki).
7. Vajadusel muuda logimise astet või väljundfaili redigeerides faili **log4j.properties** (vt. 7. peatükki).
8. Sõltuvalt sellest, millisel platvormil töötab liidestatav infosüsteem, käivita vastava andmebaasiplatvormi andmebaasi paigaldusskript. Andmebaasi paigaldusskriptid leiad kliendi paigalduspaketi /sql kaustast või aadressilt https://github.com/e-gov/DVK/tree/master/client/tags/[kliendi-versioon]/sql .
   * Microsoft SQL Serveri puhul käivita **client_latest_mssql.sql**
   * Oracle puhul käivita **client_latest_oracle.sql**
   * Postggre SQL puhul käivita **client_latest_postgresql.sql**
   * SQL Anywhere puhul käivita **client_latest_sqlanywhere.sql**. SQL Anywhere puhul võib täiendavalt osutuda vajalikuks skripti **sqlanywhere_install_jconnect_support.sql** käivitamine, kui andmebaasi loomisel ei ole jConnect JDBC draiveri jaoks vajalikke metaandmeid. Kõnealused metaandmed saab andmebaasile lisada ka andmebaasi haldusliidese kaudu.

   1) Lisa DVK kliendi andmetabelisse **dhl_settings** X-Tee päringu teostaja andmed (s.t. asutuse ja isiku andmed, kelle nimel DVK klient X-Tee päringuid teostab). Selleks sobib näiteks järgmine SQL lause (näitesse tuleb panna asutuse info, mis on kindlasti ka DVKs registreeritud):
   ```
   INSERT INTO dhl_settings (id, institution_code, institution_name, personal_id_code, unit_id)
   VALUES (1, '<asutuse registrikood>', '<asutuse nimi>', '<vastutaja isikukood>', 0);
   ```

9. Käivita kataloogis **dvk_client** sõltuvalt operatsioonisüsteemist *start_orgcheck.cmd* või **start_orgcheck.sh**. Juhul, kui rakenduse töös esineb vigu, logitakse need faili **error_log.txt** (või faili, mis on sul määratud **log4j.properties** failis).
10. Käivita kataloogis **dvk_client** sõltuvalt operatsioonisüsteemist *start_all.cmd* või **start_all.sh**. Juhul, kui rakenduse töös esineb vigu, logitakse need faili **dvk_client.log** (või faili, mis on sul määratud **log4j2.xml** failis).

Järeltegevused, kui punktides 9. ja 10. loetletud tegevused toimisid vigadeta:

1. Seadista **start_orgcheck** skript automaatselt käivituma (nt cron tööna) kord ööpäevas ja öisel ajal.
2. Seadista **start_all** skript automaatselt käivituma iga 15 minuti tagant ja ainult tööajal (st 8.00-18.00).
3. Kui soovid, et universaalkliendi andmetabelitest vanad andmed perioodiliselt kustutataks, siis seadista **start_delete** skript automaatselt käivituma näiteks kord ööpäevas.
   Pikema kirjelduse vanade andmete kustutamise kohta leiad käesoleva dokumendi peatükist „Vanade dokumentide kustutamine universaalkliendi andmetabelitest“
4. Kui soovid, et universaalkliendi andmetabelites uuendatakse ADIT'isse saadetud dokumentide avamise staatus ehk DocumentRecipient.OPENED veergu, siis on vaja käivitada start_get_send_status skript. Soovitav on seadistada ka **start_get_send_status** käivituma automaaselt sarnase loogika alusel nagu **start_all** skript.

<a name="konf1"></a>
## Konfiguratsioonifail _dvk_client.properties_

Konfiguratsioonifail dvk_client.properties asub DVK kliendi juurkataloogis ja sisaldab rakenduse peamisi seadeid. Faili näidislisting näeb välja järgmine:

```
# Andmekogu nimi, mille poole klient vaikimisi pöördub
client_producer_name = dhl

# DVK spetsifikatsiooni versioon, millega universaalklient peaks oma töös ühilduma.
# Siin kirjeldatud spetsifikatsiooni versioonist uuemaid päringuid UK ei kasuta.
client_specification_version = 1.5

# Adit andmekogu nimi mille poole klient vaikimisi pöördub
adit_producer_name = ametlikud-dokumendid

# Aditis registreeritud infosüsteemi nimi, kellena pöördutakse ADIT'i poole
client_adit_information_system_name = DHS

# DVK kliendi andmebaasiühenduste konfiguratsioonifaili asukoht.
# vaikimisi client_config.xml (s.t. fail client_config.xml kataloogis,
# kust rakendus käivitati)
client_config_file = client_config.xml

# Aadress, millele rakendus päringud saadab
# Üldjuhul kujul http://[TURVASERVER]/cgi-bin/consumer_proxy
client_service_url = http://192.168.0.1/cgi-bin/consumer_proxy

# Anonüümsete päringute tegemisel kasutatavad andmed
client_default_org_code = 12345678
client_default_person_code = 12345678901

# SSL ühenduse kasutamine
# Keystore parameetrid viitavad asutuse võtmepaari (või võtmepaare) sisaldavale võtmehoidlale
client_keystore_file = Asutus.p12
client_keystore_password = parool
client_keystore_type = pkcs12
# Truststore parameetrid viitavad turvaserveri avalikku võtit sisaldavale võtmehoidlale
client_truststore_file = XTeeTurvaserverKeystore.jks
client_truststore_password = parool
client_truststore_type = jks

# Sõnumite edastamine fragmenteeritud kujul
client_use_fragmenting = yes
client_fragment_size_bytes = 102400

# Vealogi faili asukoht.
# Vaikimisi error_log.xml (s.t. fail error_log.txt kataloogis, kust rakendus käivitati)
log_errors = yes
error_log_file = error_log.txt

# Dokumendi staatuse identifikaatorid
# Vastavaid identifikaatoreid kasutatakse andmebaasis DHL_MESSAGE tabelis
# dokumendi staatuse määramiseks.
# Lubatud väärtused: 32 bit täisarvud
client_status_waiting_id = 1
client_status_sending_id = 2
client_status_sent_id = 3
client_status_canceled_id = 4
client_status_received_id = 5

# Määrab, kas klient üritab andmeid otse Amphora registritesse kirjutada
# Kui rakendust kasutatakse mõne muu tarkvara liidestamiseks dokumendivahetuskeskusega,
# siis peaks selle seade väärtus olema "no".
# Lubatud väärtused: "yes" ja "no" (ilma jutumärkideta)
client_integrated_amphora_functions = no

# Kettalt lugemise ja kirjutamise puhvrite suurus baitides
binary_buffer_size = 65536

# Andmebaasist lugemise ja kirjutamise puhvrite suurus baitides
database_buffer_size = 65536

# Veateadete e-mailiga administraatorile saatmise seaded
# Kui järgnevad seaded on määratud, siis saadetakse kõigi DVK
# kliendi töö käigus tekkivate vigade andmed administraatorile
mail.host = mail.asutus.ee
mail.from = dvkclient@asutus.ee
mail.to = administraator@asutus.ee
```

<a name="konf1-1"></a>
### Konfiguratsioonimuutujate selgitused

- **client_producer_name** - Andmekogu nimetus, mille poole DVK klient vaikimisi pöördub. Kui klient peaks vaikimisi andmeid vahetama DVK keskserveriga, siis on selle parameetri väärtuseks „dhl“.

- **client_specification_version** - DVK spetsifikatsiooni versioon, millega universaalklient peaks oma töös ühilduma. Universaalklient ei kasuta oma töös uuemaid päringuid, kui siin märgitud spetsifikatsiooni versioon sisaldas.

- **adit_producer_name** - Adit andmekogu nimi, mille poole DVK klient vaikimisi pöördub.

- **client_adit_information_system_name** - Adit_infosüsteem parameeter, mis lisatakse päringute tegemisel päisesse. Süsteemi nimetus millena on registreeritud aditisse.

- **client_config_file** - DVK kliendi andmebaasiühenduste faili asukoht (näiteks _C:\dvk_client\client_config.xml_ või _/home/users/dvk_client/client_config.xml_).

   Antud parameeter peab viitama XML failile, kus on kirjas kliendi poolt kasutatavate andmebaasiühenduste parameetrid. Andmebaasiühenduste all on siin silmas peetud andmebaase, milles asuvaid dokumente DVK klient DVK serverisse edastab või vastu võtab.

- **client_service_url** -  DVK serveri poole pöördumiseks kasutatav veebiaadress. Reeglina kujul http://TURVASERVER/cgi-bin/consumer_proxy.

- **client_default_org_code** - DVK kliendi poolt X-Tee päringute tegemisel vaikimisi kasutatav asutuse registrikood. Antud registrikoodiga käivitab DVK klient selliseid X-Tee päringuid, mida ei pruugi olla päris korrektne sooritada infosüsteemis salvestatud vastutaja andmetega.

   Asutusespetsiifilised päringud (dokumendi saatmine, vastuvõtmine jne) käivitab DVK klient andmetabelis DHL_SETTINGS salvestatud registrikoodiga.

- **client_default_person_code** - DVK kliendi poolt X-Tee päringute tegemisel vaikimisi kasutatav isikukood. Antud isikukoodiga käivitab DVK klient selliseid X-Tee päringuid, mida ei pruugi olla päris korrektne sooritada infosüsteemis salvestatud vastutaja andmetega.

   Asutusespetsiifilised päringud (dokumendi saatmine, vastuvõtmine jne) käivitab DVK klient andmetabelis DHL_SETTINGS salvestatud isikukoodiga.

- **client_keystore_file** - Asutuse võtmepaari sisaldava võtmehoidla faili nimi (või täielik failiteekond, kui võtmehoidla asub mujal kui universaalkliendi juurkaustas).

   Võib olla JKS võtmehoidla või PKCS12 konteiner. Kui universaalklienti kasutatakse mitme asutuse andmete vahetamiseks, siis peaks võtmehoidla sisaldama kõigi asutuste võtmepaare.  
   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_keystore_password** - Asutuse võtmepaari sisaldava võtmehoidla avamiseks vajalik parool.  
   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_keystore_type** - Asutuse võtmepaari sisaldava võtmehoidla tüüp. Võimalikud väärtused on:
   * jks
   * pkcs12

   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_truststore_file** - Turvaserveri avalikku võtit (sertifikaati) sisaldava võtmehoidla faili nimi (või täielik failiteekond, kui võtmehoidla asub mujal kui universaalkliendi juurkaustas). Peaks olema JKS võtmehoidla.  
   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_truststore_password** - Turvaserveri avalikku võtit (sertifikaati) sisaldava võtmehoidla avamiseks vajalik parool.
   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_truststore_type** - Turvaserveri avalikku võtit (sertifikaati) sisaldava võtmehoidla tüüp. Peaks olema „jks“ (ilma jutumärkideta).
   Kasutatakse ainult juhul, kui universaalklient suhtleb turvaserveriga HTTPS protokolli kasutades.

- **client_use_fragmenting** - Määrab, kas klient kasutab suurte dokumentide puhul andmete tükeldamist. Kui antud parameeter on aktiveeritud, siis jaotatakse suured failid enne saatmist tükkideks ning seejärel saadetakse tükid ükshaaval serverisse.

   Suurte dokumentide tükeldamine on kasulik selleks, et klient ega server ei peaks suuri andmehulki ühekorraga töötlema ja et andmete edastamisel DVK server või mõni vahepealne X-Tee turvaserver timeout-i tõttu tööd ei katkestaks.

- **client_fragment_size_bytes** - Määrab, kui suurteks tükkideks andmed saatmisel ja vastuvõtmisel tükeldatakse.

- **client_status_waiting_id** - Dokumendi staatuse „Ootel“ numbriline vaste kliendi andmetabelites.

- **client_status_sending_id** - Dokumendi staatuse „Saatmisel“ numbriline vaste kliendi andmetabelites.

- **client_status_sent_id** - Dokumendi staatuse „Saadetud“ numbriline vaste kliendi andmetabelites.

- **client_status_canceled_id** - Dokumendi staatuse „Katkestatud“ numbriline vaste kliendi andmetabelites.

- **client_status_received_id** - Dokumendi staatuse „Saabunud“ numbriline vaste kliendi andmetabelites.

- **client_integrated_amphora_functions** - Lülitab sisse või välja teatud Amphora dokumendihaldustarkvarale spetsiifilised asutuste andmete sünkroniseerimise funktsioonid.

- **log_errors** - Määrab, kas serveri töö käigus tekkivad vead kirjutatakse logifaili.

- **error_log_file** - Vigade logifaili asukoht.

- **binary_buffer_size** - Kõvakettalt andmete lugemiseks ja kõvakettale andmete kirjutamiseks kasutatava puhvri suurus baitides. Üldjuhul pole seda vaja muuta, aga teataval määral võimaldab see DVK serveri töökiirust ja mälukasutust mõjutada.

- **database_buffer_size** - Andmebaasist andmete lugemiseks ja andmebaasi andmete kirjutamiseks kasutatava puhvri suurus baitides.    
   Üldjuhul pole seda vaja muuta, aga teataval määral võimaldab see DVK serveri töökiirust ja mälukasutust mõjutada.

- **mail.host** - E-posti serveri nimi või aadress. Kasutatakse administraatorile veateadete saatmiseks ja süsteemsete teadete saatmiseks DVK serveri kasutajatele.

- **mail.from** - E-posti aadress, mille nimel DVK klient või server e-kirju välja saadab.

- **mail.to** - E-posti aadress, kuhu DVK klient või server töös tekkinud vigade kohta e-kirju saadab.

- **test_config_file** - DVK testkliendi konfiguratsioonifaili asukoht.  
   Reaalses töös ei lähe seda seadistust vaja.

- **test_person_id_code** - DVK testkliendi poolt X-Tee päringute saatmisel kasutatav isikukood.  
   Reaalses töös ei lähe seda seadistust vaja.

- **test_org_code** - DVK testkliendi poolt X-Tee päringute saatmisel kasutatav asutuse registrikood.  
   Reaalses töös ei lähe seda seadistust vaja.

- **test_log_file** - DVK testkliendi logifaili asukoht.  
   Reaalses töös ei lähe seda seadistust vaja.

- **performance_log_file** - DVK serveri või kliendi jõudlusandemete logi asukoht.  
   Üldjuhul peaks see parameeter määramata olema.

<a name="konf2"></a>
## Konfiguratsioonifail _client_config.xml_

Konfiguratsioonifail client_config.xml asub DVK kliendi juurkataloogis ja sisaldab nimekirja andmebaasidest, milles paiknevate andmetega DVK klient töötab.
Andmebaasi kohta saab kirjeldada järgmisi parameetreid:

| Parameeter | Selgitus |
| --- | --- |
| provider | Andmebaasi tüüp. Valikud: MSSQL, MSSQL2005, ORACLE_10G, ORACLE_11G, POSTGRE, SQLANYWHERE. MSSQL = Microsoft SQL Server 2000;  MSSQL2005 = Microsoft SQL Server 2005, 2008 või 2008 R2;  ORACLE_10G = Oracle 10g;  ORACLE_11G = Oracle 11g; POSTGRE = Postgre SQL 8.0 või uuem; SQLANYWHERE = SQL Anywhere 9.0 või uuem |
| server_name | Andmebaasiserveri nimi või IP aadress. |
| server_port | Andmebaasiserveriga ühendamiseks kasutatava pordi number |
| database_name | kasutatava andmebaasi nimi |
| username | andmebaasi kasutaja kasutajanimi |
| password | andmebaasi kasutaja parool |
| process_name | andmebaasi protsessi nimi (vajalik näit. Oracle andmebaaside puhul) |
| instance_name | andmebaasi instantsi nimi (võib olla vajalik MsSql andmebaaside puhul) |
| schema_name | andmebaasiskeemi nimi (kasutatakse PostgreSQL andmebaaside puhul) |
| db_to_db_communication_only | Määrab, kas antud andmebaasiühendus on mõeldud ainult selleks, et mõne teise kohaliku andmebaasiga dokumente vahetada. Võimalikud väärtused: **true** – sellisel juhul kasutab universaalklient antud andmebaasiühendust ainult selleks, et sinna oma põhiandmebaasi(de)st vajadusel dokumente saata. Universaalklient ei ürita selles andmebaasis olevaid dokumente DVK keskserveriga sünkroniseerida ega ühelgi muul viisil välja saata. Kasulik juhul, kui antud andmebaasil on oma eraldiseisev universaalklient juba olemas.  **false**  – sellisel juhul kasutab universaalklient antud andmebaasiühendust dokumentide sünkroniseerimiseks nii DVK keskserveriga kui ka teiste kohalike andmebaasidega. _Antud parameetri vaikeväärtuseks on false_. |
| delete_old_documents_after_days | Määrab, mitmest päevast vanemad dokumendid kustutatakse juhul, kui start_delete.cmd või start_delete.sh skript käivitatakse ilma parameetriteta. Kui antud parameeter jätta määramata või määrata parameetri väärtuseks 1-st väiksem arv, siis ei kustutata start_delete.cmd või start_delete.sh skripti käivitamisel ühtegi dokumenti. |

Järgnev näidislisting demonstreerib konfiguratsiooniseadeid MsSQL 2000, MsSQL 2005/2008, Oracle 10g, PostgreSQL ja SQL Anywhere andmebaaside puhul.

```xml
<?xml version="1.0" encoding="utf-8"?>
<databases>
  <database>
    <provider>MSSQL</provider>
    <server_name>mssql2k</server_name>
    <server_port>1433</server_port>
    <database_name>dh_database</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name/>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>MSSQL2005</provider>
    <server_name>192.168.0.100</server_name>
    <server_port/>
    <database_name>dh_database_new</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name>SQLEXPRESS</instance_name>
    <schema_name/>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>ORACLE_10G</provider>
    <server_name>oracleserver</server_name>
    <server_port>1521</server_port>
    <database_name/>
    <username>scott</username>
    <password>tiger</password>
    <process_name>ORCL</process_name>
    <instance_name/>
    <schema_name/>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>POSTGRE</provider>
    <server_name>postgreserver</server_name>
    <server_port>5432</server_port>
    <database_name>dh_database_postgre</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name>dvk_client</schema_name>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>SQLANYWHERE</provider>
    <server_name>localhost</server_name>
    <server_port>2638</server_port>
    <database_name>dh_database</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name/>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
</databases>
```
Lisaks otseselt andmebaasiühendusega seotud parameetritele saab konfiguratsioonifailis client_config.xml määrata iga andmebaasi jaoks ka DVK ühendusega seotud parameetreid.
Kirjeldada on võimalik järgmisi parameetreid:

| Parameeter | Selgitus |
|---|---|
| service_url | turvaserveri aadress (või aadress DVK rakenduse või DVK rakendusega sama funktsionaalsust pakkuva lahendus poole pöördumiseks ilma turvaserveri vahenduseta). Võimaldab antud andmebaasi jaoks üle kirjutada dvk_client.properties failis määratud vaikimisi aadressi. |
| send_documents_ver | kasutatava sendDocuments päringu versiooni number. |
| receive_documents_ver | kasutatava receiveDocuments päringu versiooni number. |
| mark_documents_received_ver | kasutatava markDocumentsReceived päringu versiooni number. |
| get_send_status_ver | kasutatava getSendStatus päringu versiooni number. |
| get_sending_options_ver | kasutatava getSendingOptions päringu versiooni number. |
| default_status_id | saabunud dokumendile vaikimisi määratava staatuse väärtus (ID). |
| adit_get_send_status | kasutatava aditGetSendStatus päringu versiooni number |
| receive_documents_amount | receiveDocuments päringuga vastuvõetavate dokumentide arv. |

Järgnev näidislisting demonstreerib DVK ühenduse konfiguratsiooniseadete määramist.

```xml
<?xml version="1.0" encoding="utf-8"?>
<databases>
  <database>
    <provider>ORACLE_10G</provider>
    <server_name>oracleserver</server_name>
    <server_port>1521</server_port>
    <database_name/>
    <username>scott</username>
    <password>tiger</password>
    <process_name>ORCL</process_name>
    <instance_name/>
    <delete_old_documents_after_days>30</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
    <dvk_settings>
      <service_url>http://TURVASERVER/cgi-bin/consumer_proxy</service_url>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>9</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
  </database>
</databases>
```

<a name="https"></a>
## Universaalkliendi seadistamine HTTPS protokolli kasutamiseks

Kui andmevahetuseks X-Tee turvaserveriga kasutatakse HTTPS protokolli, siis tähendab see sisuliselt, et:

- turvaserver tõendab ennast universaalkliendile turvaserveri sertifikaadi abil;
- universaalklient tõendab päringu käivitanud asutuse turvaserverile asutuse sertifikaadi abil.

See erineb mõnevõrra veebis kohatavast HTTPS kasutusest, kus ainult server peab oma identiteeti tõendama.

Seega on universaalkliendi ja turvaserveri HTTPS andmevahetuse seadistamiseks vaja:

- turvaserveri avalikku võtit (sertifikaati)
- asutuse avalikku ja privaatvõtit (võtmepaari konteinerit)

Turvaserveri sertifikaat genereeritakse turvaserveris ja avaliku võtme saab eksportida „Konfiguratsioon“ -> „Serverid“ -> „Infosüsteemi serverid“ alajaotuses „Ekspordi sertifikaat“ käsuga.
Asutuse võtmepaar koostatakse tüüpiliselt sertifitseerimisteenuse pakkuja poolt. Võimalik on muidugi kasutada ka ise genereeritud asutuse sertifikaate (http://en.wikipedia.org/wiki/Self-signed_certificate). Igal juhul läheb vaja sama võtmepaari, mille avalik võti on turvaserveris asutusega seotud.

Universaalkliendi seadistamisel on vaja koostada vähemalt üks java võtmehoidla (keystore) fail. Selleks saab kasutada:
Java bin kasutas asuvat käsurea programmi keytool
graafilise kasutajaliidesega rakendust, näiteks Portecle (http://sourceforge.net/projects/portecle/)

Universaalkliendi seadistamiseks toimi nii:

1. Ekspordi turvaserveri sertifikaadi avalik võti ja paiguta see java võtmehoidla faili. Sertifikaadi eksportimisel väljastab turvaserver sertifikaadi PEM ja DER failidena. Võtmehoidla koostamiseks sobib neist ükskõik kumb.

   Keytool käsk võtmehoidla koostamiseks on järgmine:
   keytool -import -noprompt -trustcacerts -alias **turvaserver** -file **cert.pem** -keystore **XTeeTurvaserverKeystore.jks** -storepass **parool**

2. Paiguta loodud võtmehoidla fail universaalkliendi juurkausta.

3. Paiguta asutuse võtmepaari fail universaalkliendi juurkausta. Siin sobivad nii JKS kui ka PKCS12 failid (.pfx, pk12)

   Kui kasutad sama universaalklienti mitme asutuse andmete vahetamiseks, siis tuleks kõik võtmepaari failid importida kokku ühtsesse võtmehoidla faili (võib kasutada 1. sammul loodud võtmehoidla faili)
   Keytool käsk võtmepaari importimiseks võtmehoidlasse on järgmine:
   keytool -importkeystore -srckeystore **asutus.p12** -destkeystore **XTeeTurvaserverKeystore.jks** -srcstoretype **pkcs12** -srcstorepass **parool** -deststorepass **parool**

4. Väärtusta universaalkliendi konfiguratsioonifailis dvk_client.properties SSL ühenduse seaded.
   Kui asutuse võtmepaar asub eraldi failis, siis näeb seadistus välja umbes järgmine:

   ```
   # SSL ühenduse kasutamine
# Keystore parameetrid viitavad asutuse võtmepaari (või võtmepaare) sisaldavale võtmehoidlale
client_keystore_file = Asutus.p12
client_keystore_password = parool
client_keystore_type = pkcs12
# Truststore parameetrid viitavad turvaserveri avalikku võtit sisaldavale võtmehoidlale
client_truststore_file = XTeeTurvaserverKeystore.jks
client_truststore_password = parool
client_truststore_type = jks
   ```

   Kui mitme asutuse võtmepaarid imporditi ühte võtmehoidlasse kokku, siis näeb seadistus välja umbes järgmine:

   ```
   # SSL ühenduse kasutamine
# Keystore parameetrid viitavad asutuse võtmepaari (või võtmepaare) sisaldavale võtmehoidlale
client_keystore_file = XTeeTurvaserverKeystore.jks
client_keystore_password = parool
client_keystore_type = jks
# Truststore parameetrid viitavad turvaserveri avalikku võtit sisaldavale võtmehoidlale
client_truststore_file = XTeeTurvaserverKeystore.jks
client_truststore_password = parool
client_truststore_type = jks
   ```
5. Kontrolli üle, et kasutatav turvaserveri URL algab https:// prefiksiga.


<a name="baasid"></a>
## Universaalkliendi seadistamine andmete edastamiseks otse andmebaaside vahel

Kui samas asutuses on mitu infosüsteemi, mis vahetavad omavahel dokumente DVK kaudu, siis võib olla otstarbekas universaalkliendid seadistada nii, et asutusesiseselt saadetavad dokumendid liiguksid infosüsteemide vahel ilma DVK keskserveri vahenduseta. Selleks tuleb lihtsalt igale universaalkliendile teatavaks teha, kus asuvad teiste universaalklientide andmebaasid.

1. Universaalkliendi kaustast leiad faili **client_config.xml**. Kirjelda selles failis ära kõik teadaolevad andmebaasid, mis peaksid suutma omavahel andmeid vahetada.

   ```xml
<?xml version="1.0" encoding="utf-8"?>
<databases>
  <database>
    <provider>MSSQL</provider>
    <server_name>mssql2k</server_name>
    <server_port>1433</server_port>
    <database_name>dh_database</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name/>
    <dvk_settings>
      <service_url/>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>0</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
    <delete_old_documents_after_days>-1</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>MSSQL2005</provider>
    <server_name>192.168.0.100</server_name>
    <server_port/>
    <database_name>dh_database_new</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name>SQLEXPRESS</instance_name>
    <schema_name/>
    <dvk_settings>
      <service_url/>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>0</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
    <delete_old_documents_after_days>-1</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>POSTGRE</provider>
    <server_name>postgreserver</server_name>
    <server_port>5432</server_port>
    <database_name>dh_database</database_name>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name>dvk_client</schema_name>
    <dvk_settings>
      <service_url/>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>0</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
    <delete_old_documents_after_days>-1</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>ORACLE_10G</provider>
    <server_name>oracleserver</server_name>
    <server_port>1521</server_port>
    <database_name/>
    <username>scott</username>
    <password>tiger</password>
    <process_name>orcl</process_name>
    <instance_name/>
    <schema_name/>
    <dvk_settings>
      <service_url/>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>0</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
    <delete_old_documents_after_days>-1</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
  <database>
    <provider>SQLANYWHERE</provider>
    <server_name>localhost</server_name>
    <server_port>2638</server_port>
    <database_name/>
    <username>dh_user</username>
    <password>kala</password>
    <process_name/>
    <instance_name/>
    <schema_name/>
    <dvk_settings>
      <service_url/>
      <send_documents_ver>3</send_documents_ver>
      <receive_documents_ver>4</receive_documents_ver>
      <receive_documents_amount>10</receive_documents_amount>
      <mark_documents_received_ver>3</mark_documents_received_ver>
      <get_send_status_ver>2</get_send_status_ver>
      <get_sending_options_ver>3</get_sending_options_ver>
      <get_subdivision_list_ver>2</get_subdivision_list_ver>
      <get_occupation_list_ver>2</get_occupation_list_ver>
      <default_status_id>0</default_status_id>
      <adit_get_send_status>1</adit_get_send_status>
    </dvk_settings>
    <delete_old_documents_after_days>-1</delete_old_documents_after_days>
    <db_to_db_communication_only>false</db_to_db_communication_only>
  </database>
</databases>
   ```

   Kui mõnel loetletud andmebaasidest on oma universaalklient juba olemas (s.t antud UK ei tohiks selle baasi andmeid DVK keskserveriga vahetada), siis tuleks selle andmebaasi kirjelduses elemendi **db_to_db_communication_only** väärtuseks määrata _true_. Kui tegemist on teise UK andmebaasiga, siis võib konfiguratsioonifailis tühjaks jätta alajaotuse **dvk_settings**.

2. Asutusesiseselt saadetavate dokumentide puhul saab adressaati määrata allüksuse ja ametikoha põhiselt. S.t. kui soovime sama asutuse piires dokumendi ühest infosüsteemist teise saata, siis peavad infosüsteemide aadressid erinema allüksuse või ametikoha (või mõlema) poolest.

   Määramaks, millise allüksuse ja/või ametikoha dokumente ükski infosüsteem vastu võtab, ava igas kirjeldatud andmebaasis tabel **dhl_settings** ning kirjuta seal väljadele **institution_code**, **subdivision_code**, **occupation_code**, **subdivision_short_name** ja **occupation_short_name**, millisele asutusele, allüksusele ja ametikohale adresseeritud dokumendid peavad sellesse andmebaasi jõudma.
   Allüksuste ja ametikohtade puhul tuleks võimalusel määrata nii ID-kood kui lühinimetus. Seda põhjusel, et DVK konteineri versioonis 1 toimub allüksustele ja ametikohtadele adresseerimine ID-koodi põhiselt, versioonis 2 aga lühinimetuse põhiselt.
   Kui aga allüksus või ametikoht pole DVK keskserveris registreeritud, siis pole võimalik dokumente ID-koodi järgi allüksusele või ametikohale adresseerida ning dokumentide otse saatmiseks tuleks eelistada DVK konteineri versiooni 2 ja lühinimetusi.


<a name="kustutamine"></a>
## Vanade dokumentide kustutamine universaalkliendi andmetabelitest

DVK universaalklient säilitab oma andmetabelites (dhl_message, dhl_message_recipient, dhl_status_history) asuvaid andmeid vaikimisi lõpmata kaua. Kui soovite universaalkliendi andmetabeleid vanadest andmetest perioodiliselt puhastada, siis saab selleks kasutada rakenduse juurkataloogis asuvaid skripte **start_delete.cmd** ja **start_delete.sh**.

Mõlemale skriptile saab parameetrina ette anda, mitmest päevast vanemad dokumendid kustutatakse. Saadetud dokumendi vanust arvestatakse alates saatmise kuupäevast (andmeväli sending_date tabelis dhl_message). Saabunud dokumendi vanust arvestatakse alates vastuvõtmise kuupäevast (andmeväli received_date tabelis dhl_message).

Näiteks järgmine käsk kustutab kõik vähemalt 30 päeva vanused dokumendid:

```
start_delete.cmd 30
```

Kui sama universaalklient teenindab mitut erinevat andmebaasi (infosüsteemi), siis rakendatakse kõigi andmebaaside puhul ühte ja seda sama parameetrina etteantud päevade arvu.
Kui soovite andmebaaside kaupa eristada, kui kaua universaalkliendi andmetabelites andmeid säilitatakse (sh kas andmeid üldse kustutatakse), siis saate seda teha järgnevalt:

1. Määrake konfiguratsioonifailis client_config.xml parameetri **delete_old_documents_after_days** väärtuseks soovitud päevade arv (kui väärtus on määramata või < 1, siis vaikimisi andmeid ei kustutata).

2. Käivitage start_delete.cmd või start_delete.sh ilma parameetriteta

Näiteks järgmine käsk käivitab andmete kustutamise client_config.xml failis määratud säilitustähtajaga:

```
start_delete.cmd
```

**NB!** Kui andmete säilitustähtaeg on määratud nii konfiguratsioonifailis kui ka andmete kustutamise skripti parameetrina, siis arvestab universaalklient skripti käivitamisel kasutatud parameetrit.


## Rakenduse ehitamine

Rakenduse ehitamiseks on alates DVK versioonist 1.6.0 kasutusel Maven raamistik (http://maven.apache.org/). Eelnevate versioonide ehitamiseks vaadata https://github.com/e-gov/DVK/tree/master/doc/client/arhiiv/1.6.2  paigaldusjuhendit. Alates 1.7.1 versioonist ehitamisskript ise asub projekti juurkataloogis ja kannab nime „pom.xml“. Selles failis on kirjeldatud ära rakenduse kasutatavad teegid (dependencies) ja rakenduse ehitamise juhised (build) ning ehitamisprofiilid (profile). Ehitamiseks toimi järgnevalt:

1. Lae Githubist alla DVK projekt https://github.com/e-gov/DVK

2. Ava tekstiredaktoriga projekti „dvk“ juurkaustas asuv fail **pom.xml** ning lisa endale või muuda olemas olevat ehitusprofiili. Modules bloki abil saad kirjeldada ehitatava DVK versiooni komponentide suhtelised teekonnad (relativePathid).

   Lisaks on muuta **dvkCoreDir'i, dvkClientDir'i** väärtusteks täisteekond konkreetse projekti juurkataloogini (näiteks „/home/kasutaja/projektid/dvk/core“). **ListOfTestConfigs** ja **dvkServerJettyEnvLocation** on vajalikud seadistada vaid siis, kui soovitakse käivitada ka serveri ja clienti integratsiooniteste.

3. Lae alla Apache Maven versioon 3.x.x (http://maven.apache.org/download.html ja vali sealt .zip fail).

4. Paki allalaetud pakett lahti.

5. Lisa [MAVEN_HOME]/bin kataloog keskkonnamuutujasse „PATH“.

6. Mine DVK projekti juurkataloogi ja käivita käsurealt järgmine käsklus:

   ```
CMD> mvn -P [PROFILE_NAME] package
   ```

Kui edaspidi on mingil põhjusel vaja projekti uuesti kompilleerida, siis tasuks järgnevatel kompilleerimiskordadel enne pakendamist käivitada ka varasemate kompilleerimistulemuste puhastamine:

   ```
CMD> mvn clean
CMD> mvn -P [PROFILE_NAME] package
   ```

7. Maven ehitab ja paketeerib rakenduse. Kataloogi [DVK_CLIENT_HOME]/target tekib fail „dvk-client.jar“.


## Logimise seadistamine

Logimine on alates versioonist 1.6.0 realiseeritud kasutades raamistikku Apache Log4J (http://logging.apache.org/log4j/). Logimise seadistamiseks ava tekstiredaktoriga fail „log4j2.xml“. Selles failis on kirjeldatud logimise seadistus:

```
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
  <CustomLevels>
    <CustomLevel name="SERVICEINFO" intLevel="450" />
  </CustomLevels>
  <Appenders>
    <Console name="console" target="SYSTEM_OUT">
      <PatternLayout pattern="%-5p %d %c{1} - %m%n"/>
    </Console>
     <RollingFile name="file" fileName="dvk_client.log"
     filePattern="dvk_client-%d{MM-dd-yyyy}-%i.log">
      <PatternLayout>
        <Pattern>%d %5p %C.%M - %m%n</Pattern>
      </PatternLayout>
      <Policies>
        <TimeBasedTriggeringPolicy />
        <SizeBasedTriggeringPolicy size="100 MB"/>
      </Policies>
    </RollingFile>
  </Appenders>   
    <Root level="info">
      <AppenderRef ref="file"/>
    </Root>
  </Loggers>
</Configuration>
```

1. Logifaili asukoht – logifaili asukoht on määratud järgmiselt:

   ```
   <RollingFile name="file" fileName="dvk_client.log"
     filePattern="dvk_client-%d{MM-dd-yyyy}-%i.log">
   ```

2. Logimise sügavus – logimise sügavuse  väärtusteks võib olla: OFF, FATAL, ERROR, WARN, INFO, DEBUG, ALL – kus DEBUG puhul kirjutatakse logisse väga detailselt ning ERROR puhul ainult veateated.

   ```
<Root level="info">
	<AppenderRef ref="file"/>
</Root>
   ```
