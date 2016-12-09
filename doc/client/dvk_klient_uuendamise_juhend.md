# Dokumendivahetuskeskus Klienditarkvara uuendamise juhend

## Sisukord

- [Sissejuhatus](#sissejuhatus)
- [Uuendamine](#uuendamine)
   * [Andmebaas](#andmebaas)
   * [Rakendus](#rakendus)
- [Vanemale versioonile üleminek](#rollback)
   * [Andmebaas](#rollback-baas)
   * [Rakendus](#rollback-rakendus)


## Muudatuste ajalugu


| Kuupäev | Versioon | Kirjeldus | Autor |
| --- | --- | --- | --- |
| 28.02.2010 | 1.0 | Dokumendi esialgne versioon. | Marko Kurm |
| 30.06.2010 | 1.0.1 | Parandatud formaatimist ja viitamiste teistele dokumentidele | Hannes Kiivet |
| 20.01.2016 | 1.0.2 | SVN lingid muudetud Githubi linkideks  | Kertu Hiire |
| 09.12.2016 | 1.0.3 | Dokumentatsioon üle viidud MarkDown fomraati ning parandatud viitamist | Kertu Hiire |


## Sissejuhatus

Käesolev dokument on kirjeldus sellest, kuidas uuendada olemasolevat DVK kliendi tarkvara. Samuti on kirjeldatud seda, kuidas minna tagasi vanemale versioonile, kui selline vajadus tekib. DVK klienditarkvara koosneb paigaldamise mõttes kahest osast: andmebaasist ja rakendusest. Vaatleme neid osasid eraldi punktides.

## Uuendamine

Uuendamiseks lae alla DVK kliendi tarkvarapakett [repositooriumist](https://github.com/e-gov/DVK) ja paki lahti arvuti kõvakettale (edaspidi viitame [dvk_klient]).

### Andmebaas

Andmebaasiskriptid asuvad [client/sql kataloogis](https://github.com/e-gov/DVK/tree/master/client/sql). Skriptid „client_latest_oracle.sql“, „client_latest_mssql.sql“ ja „client_latest_postgresql.sql“ sisaldavad DVK kliendi viimast versiooni täielikust andmebaasiskeemist.
Kui tegemist on DVK kliendi versiooni uuendamisega, siis huvitavad meid kumulatiivsed andmebaasiuuendamise skriptid, mis on kaustas „update_YYYYMM“ ja formaadis „client_update_YYYYMM_DATABASE.sql“.

**NB!** Enne versiooniuuendust on mõistlik teha andmebaasist varukoopia ja/või läbida uuendusprotsess testkeskkonna andmebaasi peal.

Uuendamiseks toimi järgmiselt:

1. Tee kindlaks, milline versioon DVK kliendi tarkvarast on hetkel kasutusel. Selleks vaata konfiguratsioonifailis „dvk_client.properties“ oleva parameetri „client_specification_version“ väärtus. SQL update skriptile vastav versiooninumber on kirjas skripti päises.

2. Käivita vajalikud (uuemad kumulatiivsed uuendusskriptid).

3. Veendu, et skriptide töötlemine lõpetati vigadeta.

### Rakendus

Rakenduse uuendamiseks on vaja Riigi Infosüsteemide koduleheküljelt alla laetud tarkvarapakett lahti pakkida ning kirjutada üle olemasolev DVK kliendi tarkvara.

NB! Enne failide ülekirjutamist oleks mõistlik teha DVK kliendi olemasolevast versioonist varukoopia, et oleks vigade ilmnemisel lihtne algset seisu taastada (konfiguratsioonifailidest võib olla abi uue versiooni seadistamisel).

Uuendamiseks toimi järgmiselt:

1. Kirjuta üle DVK kliendi failid uuema versiooniga.
2. Konfigureeri DVK klient. Seadistamist on kirjeldatud [paigaldusjuhendis](dvk_klient_paigaldusjuhend.md) peatükkides 3,4 ja 5.

<a name="rollback"></a>
## Vanemale versioonile üleminek

Lae alla [repositooriumist](https://github.com/e-gov/DVK) vajaliku versioon DVK kliendi tarkvara lähtekoodi, kompileeri see (vt paigaldusjuhendi [peatükki 6](dvk_klient_paigaldusjuhend.md#rakenduse-ehitamine)).
NB! Enne versiooni vahetust on soovitatav teha varukoopia nii andmebaasist kui rakenduse failidest, et oleks tõrgete korral võimalik esialgne seis lihtsasti taastada.


<a name="rollback-baas"></a>
### Andmebaas

Andmebaasi vanemale versioonile viimiseks toimi järgmiselt:
Käivita DVK kliendi andmebaasis SQL taastamise (rollback) skriptid, mis asuvad [client/sql kataloogis](https://github.com/e-gov/DVK/tree/master/client/sql), kaustas „update_YYYYMM“ ja formaadis „client_rollback_YYYYMM_DATABASE.sql“. Kui üleminek toimub üle mitme versiooninumbri, siis on vaja käivitada kõik SQL taastamise skriptid, mis nende versioonide vahele jäävad. Skriptide kävitamisel alusta uuemast, ehk kõigepealt käivita kõige uuema kuupäevaga skript jne.

<a name="rollback-rakendus"></a>
### Rakendus

Rakenduse puhul on vaja vanemale versioonile üleminekuks teha järgmist:

1. Kirjuta üle DVK kliendi rakenduse failid.
2. Konfigureeri DVK klient. Seadistamist on kirjeldatud [paigaldusjuhendis](dvk_klient_paigaldusjuhend.md) peatükkides 3,4 ja 5.
