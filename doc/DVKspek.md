#Dokumendivahetuskeskuse (DVK) Liideste spetsifikatsioon

##Sisukord
- [Muudatuste ajalugu](#muudatuste-ajalugu)
- [Sissejuhatus](#sissejuhatus)
- [Üldskeem: dokumendid, metainfo, dokumendivahetus](#Üldskeem-dokumendid-metainfo-dokumendivahetus)
- [Vahetatava dokumendi üldine XML kirjeldus](#vahetatava-dokumendi-üldine-xml-kirjeldus)
    - [Dokumendi üldine ümbrik](#dokumendi-üldine-ümbrik)
    - [Metainfo blokk dokumendis](#metainfo-blokk-dokumendis)
    - [Transport blokk dokumendis](#transport-blokk-dokumendis)
    - [DVK konteineri versioon 2 puhul on kasutusel järgmine struktuur](#dvk-konteineri-versioon-2-puhul-on-kasutusel-järgmine-struktuur)
    - [Ajalugu blokk dokumendis](#ajalugu-blokk-dokumendis)
    - [Metaxml blokk dokumendis](#metaxml-blokk-dokumendis)
    - [Taustinfoks: DigiDoci konteiner](#taustinfoksdigidoci-konteiner)
    - [Taustinfoks: `<failid>` konteiner](#taustinfoksfailid-konteiner)
- [Dokumentide logistika](#dokumentide-logistika)
    - [Üldist](#Üldist)
    - [Tööskeem](tööskeem)
        - [DVK loogiline ülesehitus](#dvk-loogiline-ülesehitus)
        - [Kaustade kasutamine](#kaustade-kasutamine)
        - [Dokumentide edastamine](#dokumentide-edastamine)
        - [Edastatud dokumentide staatuse kontroll](#edastatud-dokumentide-staatuse-kontroll)
        - [Dokumentide vastuvõtt](#dokumentide-vastuvõtt)
- [X-Tee päringute kirjeldused](#x-tee-päringute-kirjeldused)
    - [Üldinfo](#xroad-general-info)
    - [X-tee sõnumiprotokoll versioon 4.0](#xroad-message-protocol-v4)
    - [sendDocuments](#senddocuments)
        - [sendDocuments.v1](#senddocumentsv1)
        - [sendDocuments.v2](#senddocumentsv2)
        - [sendDocuments.v3](#senddocumentsv3)
        - [sendDocuments.v4](#senddocumentsv4)
    - [getSendStatus](#getsendstatus)
        - [getSendStatus.v1](#getsendstatusv1)
        - [getSendStatus.v2](#getsendstatusv2)
    - [receiveDocuments](#receivedocuments)
        - [receiveDocuments.v1](#receivedocumentsv1)
        - [receiveDocuments.v2](#receivedocumentsv2)
        - [receiveDocuments.v3](#receivedocumentsv3)
        - [receiveDocuments.v4](#receivedocumentsv4)
    - [markDocumentsReceived](#markdocumentsreceived)
        - [markDocumentsReceived.v1](#markdocumentsreceivedv1)
        - [ markDocumentsReceived.v2](#markdocumentsreceivedv2)
        - [markDocumentsReceived.v3](#markdocumentsreceivedv3)
    - [getSendingOptions](#getsendingoptions)
        - [getSendingOptions.v1](#getsendingoptionsv1)
        - [getSendingOptions.v2](#getsendingoptionsv2)
        - [getSendingOptions.v3](#getsendingoptionsv3)
    - [changeOrganizationData](#changeorganizationdata)
    - [deleteOldDocuments](#deleteolddocuments)
    - [runSystemCheck](#runsystemcheck)
    - [getSubdivisionList](#getsubdivisionlist)
        - [getSubdivisionList.v1](#getsubdivisionlistv1)
        - [getSubdivisionList.v2](#getsubdivisionlistv2)
    - [getOccupationList](#getoccupationlist)
        - [getOccupationList.v1](#getoccupationlistv1)
        - [getOccupationList.v2](#getoccupationlistv2)
- [Kasutusõiguste süsteem DVK rakenduses](#kasutusõiguste-süsteem-dvk-rakenduses)
- [Edastatavate dokumentide valideerimine DVK serveris](#edastavate-dokumentide-valideerimine-dvk-serveris)
- [Adressaatide automaatne lisamine DVK serveris](#adressaatide-automaatne-lisamine-dvk-serveris)
    - [Adressaatide automaatse lisamise seadistamine](#adressaatide-automaatse-lisamise-seadistamine)
- [Dokumentide edastamine DVK serverite vahel (DVK lüüsid)](#dokumentide-edastamine-dvk-serverite-vahel-dvk-lüüsid)
    - [Sissejuhatus](#sissejuhatus-1)
    - [Tehnilised piirangud DVK lüüside kasutamisele](#tehnilised-piirangud-dvk-lüüside-kasutamisele)
    - [DVK lüüside lahendusest tingitud muudatused DVK spetsifikatsioonis](#dvk-lüüside-lahendusest-tingitud-muudatused-dvk-spetsifikatsioonis)
        - [Vahendaja kirje DVK konteineri transport andmestruktuuris](#vahendaja-kirje-dvk-konteineri-transport-andmestruktuuris)
        - [DVK serveri täiendavad seadistused](#dvk-serveri-täiendavad-seadistused)
- [Dokumentide edastamine fragmentidena](#dokumentide-edastamine-fragmentidena)
- [Teadaolevad vead DVK rakenduses](#teadaolevad-vead-dvk-rakenduses)
    - [Content-Transfer-Encoding päise vigane esitus](#content-transfer-encoding-päise-vigane-esitus)
    - [Tundlikkus Content-Type päise kirjapildi suhtes](#tundlikkus-content-type-päise-kirjapildi-suhtes)
- [LISA 1: Kasutatavate andmete XML Schema kirjeldused](#lisa-1-kasutatavate-andmete-xml-schema-kirjeldused)
    - [Automaatsed metaandmed](#automaatsed-metaandmed)
    - [Manuaalsed metaandmed](#manuaalsed-metaandmed)
    - [DVK dokument](#dvk-dokument)
    - [Päringute WSDL kirjeldus](#päringute-wsdl-kirjeldus)
- [LISA 2: <dokument> XML struktuuri kasutusnäide (DVK konteineri versioon 1)](#lisa-2-dokument-xml-struktuuri-kasutusnäide-dvk-konteineri-versioon-1)
- [LISA 3: <dokument> XML struktuuri kasutusnäide (DVK konteineri versioon 2)](#lisa-3-dokument-xml-struktuuri-kasutusnäide-dvk-konteineri-versioon-2)



##Muudatuste ajalugu

| Kuupäev | Versioon | Kirjeldus | Autor |
|-------|----------|----------------|----------------------|
| 26.11.2005  | 1.1 | Dokumendi esialgne versioon | OÜ Degeetia |
| 17.04.2006 | 1.3.1 | Terminid „dokumendirepositoorium”, „dokumendihoidla” ning vastavad lühendid „DR” ja „DHL” on asendatud (v.a tehniline osa päringute kirjeldustes) „dokumendivahetuskeskus” ja „DVK”-ga | Rauno Temmer (RIA) |
| 13.06.2006 | 1.3.2 | Lisatud päringu „getSendingOptions” kirjeldus. | Jaak Lember (Carlsman OÜ) |
| 27.11.2006 | 1.3.3 | Uuendatud DVK tööskeemi kirjeldust, eemaldatud INBOX ja OUTBOX kasutamist kirjeldavad osad, lisatud teadaolevate vigade peatükk, tehtud rida pisiparandusi päringute ja XML skeemide (schema) kirjeldustes. Lisatud peatükk „Kaustade kasutamine“. | Jaak Lember (Carlsman OÜ) |
| 13.02.2007 | 1.4 | Lisatud päringu „dhl.markDocumentsReceived.v2” kirjeldus. Täiendatud päringu „getSendStatus” kirjeldust. Uuendatud failide dhl.xsd ja dhl.wsdl listinguid. | Jaak Lember (Carlsman OÜ) |
| 21.07.2008 | 1.5 | Restruktureeritud dokumendi muudatuste ajaloo osa. Täiendatud päringu sendDocuments kasutusnäidet. Lisatud peatükile „Kaustade kasutamine“ alapunkt „Kaustade kasutamine e-vormide andmevahetuses“ (kopeeritud RIA dokumendist „E-vormide rakenduse andmevahetusviiside kirjeldus“). Lisatud „transport“ elemendi kirjelduse alla uute alamelementide „vahendaja“, „asutuse_nimi“ ja „allyksuse_kood“ näited ja kirjeldused. Täiendatud päringute sendDocuments, receiveDocuments ja getSendingOptions kirjeldusi päringute versioonide v2 kirjeldustega. Lisatud päringute changeOrganizationData, deleteOldDocuments ja runSystemCheck kirjeldused. Lisatud peatükid „Adressaatide automaatne lisamine DVK serveris“, „Dokumentide edastamine DVK serverite vahel (DVK lüüsid)“ ja „Dokumentide edastamine fragmentidena“. Uuendatud faili dhl.xsd näidet. Uuendatud faili dhl.wsdl näidet. Uuendatud DVK XML konteineri näidet. | Jaak Lember (Carlsman OÜ) |
| 30.07.2008 | 1.5.1 | Lisatud päringute getSubdivisionList ja getOccupationList kirjeldused. Täiendatud „transport“ bloki kirjeldust. Uuendatud faili dhl.xsd näidet. Uuendatud DVK XML konteineri näidet. | Jaak Lember (Carlsman OÜ) |
| 12.01.2009 | 1.5.2 | Dokumentatsiooni kohendamine TEST kausta kasutamise kirjeldus | Hannes Linno (RIA) |
| 03.02.2009 | 1.5.3 | Lisatud päringu receiveDocuments.v3 kirjeldus. Täiendatud päringute receiveDocuments.v2 ja sendDocuments.v2 kirjeldust. Vormindatud päringute parameetrite kirjelduste osa paremini loetavaks. Uuendatud DVK XML konteineri näidet. | Jaak Lember (Carlsman OÜ) |
| 08.02.2010 | 1.5.3.1 | Täiendatud päringute getSendingOptions.v1, getSendingOptions.v2, getSubdivisionList.v1, getOccupationList.v1 kirjeldusi ja näiteid. | Jaak Lember |
| 10.02.2010 | 1.5.3.2 | Lisatud päringute markDocumentsReceived.v3, getSubdivisionList.v2 ja getOccupationList.v2 kirjeldused ja näited. Täiendatud päringute getSubdivisionList.v1 ja getOccupationList.v1 kirjeldused ja näited. | Jaak Lember |
| 15.02.2010 | 1.5.3.3 | Lisatud päringu getSendingOptions.v3 kirjeldus. Lisatud päringu receiveDoruments.v4 kirjeldus. Parandatud päringute receiveDocuments.v3 ja receiveDocuments.v2 kirjeldusi. | Jaak Lember |
| 13.04.2010 | 1.6.0 | Muudetud päringu getSendStatus.v1 kirjeldust. Lisatud päringu getSendStatus.v2 kirjeldus. Muudetud päringute markDocumentsReceived.v2 ja markDocumentsReceived.v3 kirjeldusi. Muudetud päringu getSendingOptions.v3 kirjeldust ja näiteid. Parandatud vead päringu getSubdivisionList.v2 näidetes. Parandatud vead päringu getOccupationList.v2 näidetes. Lisatud peatükk „Edastatavate dokumentide valideerimine DVK serveris“. Täiendatud päringute „sendDocuments.v1“ ja  „sendDocuments.v2“ kirjeldusi. | Jaak Lember |
| 08.04.2010 | 1.6.00 | Eemaldatud vananenud tekst | Hannes Kiivet |
| 14.04.2014 | 1.7 | Lisatud sendDocuments.v4 päringu kirjeldus. Täiendatud receiveDocuments päringu kirjeldust. | Hendrik Pärna |
| 26.09.2016 | 1.8 | Dokumendi sisu üle viidud MarkDown formaati (sisulisi muudatusi tegemata) | Kertu Hiire |



##Sissejuhatus
------

Dokumendivahetuskeskus (DVK) on erinevatele dokumendihaldussüsteemidele ja muudele dokumente käsitlevatele infosüsteemidele ühine keskset dokumendivahetuse teenust pakkuv infosüsteem. DVK ülesanne on hajutatult paiknevate infosüsteemide liidestamine X-tee vahendusel, dokumentide lühiajaline säilitamine ja lähimas tulevikus ka dokumentide menetlemist toetavate teenuste pakkumine.

Spetsifikatsioonile on eraldi lisatud kolm lisa:
- [Lisa 1. Viited kasutatavatele nimeruumidele ja XML skeemikirjeldustele](#lisa-1-kasutatavate-andmete-xml-schema-kirjeldused)
- [Lisa 2. DVK dokumendi näide (DVK konteineri versioon 1)](#lisa-2-dokument-xml-struktuuri-kasutusnäide-dvk-konteineri-versioon-1)
- [Lisa 3. DVK dokumendi näide (DVK konteineri versioon 2)](#lisa-2-dokument-xml-struktuuri-kasutusnäide-dvk-konteineri-versioon-2)

##Üldskeem: dokumendid, metainfo, dokumendivahetus

Dokumendivahetus DHS ja DVK vahel toimub järgmiste põhikonteinerite kaudu:
- Väline XTEE SOAP-ümbrik sisaldab gzip-ga kokkupakitud, seejärel base64 kodeeritud XML  konteinerit "dokument"
    - "dokument" konteiner sisaldab (peale base64-dekodeerimist ja gzip-lahtipakkimist):
        - eri tüüpi metainfo- ja transpordi-info konteinereid
        - DigiDoc formaadis dokumenti (DVK konteiner versioon 1), mis omakorda:
            - sisaldab suvalise hulga base64 kodeeringus ja minimaalse formaadi-metainfoga varustatud faile
            - sisaldab suvalise hulga allkirja-blokke nimetatud failide jaoks. Allkirja-blokkidesse ei tule kopeerida konteineris olevate eraldi allkirjastatud dokumentide allkirja-blokke. NB! DVK kontekstis on lubatud allkirja-blokkide puudumine!
        - <failid> formaadis konteinerit (DVK konteiner versioon 2), mis omakorda:
            - Sisaldab suvalise hulga faile zip-itud ja seejärel Base64 kodeeringusse panduna. Lisaks failide metaandmed.

Dokumendi ("dokument" konteiner) struktuuri kirjeldame järgmises peatükis, SOAP-konteinerit ja X-Tee päringut aga edasises "Dokumentide logistika" peatükis.

##Vahetatava dokumendi üldine XML kirjeldus

Dokumendi formaat põhineb kas DigiDoc formaadil (DVK konteineri versioon 1) või `<failid>` konteineril. Dokumendi kohta on olemas erinevat tüüpi metainfo pluss suvaline hulk DigiDoc/failid konteinereid. Muud kaalutlused:

- Osa dokumendi XML formaadi välju on kriitilised dokumentide logistika ja/või kasutajaliidese põhifunktsionaalsuse jaoks, osa aga ei ole DVK tööks otseselt vajalikud. Pakutav formaat fikseerib konkreetsete tagidena (st sisaldab nimeruumis) ainult kriitilised tagid, kõiki muid metaandmeid võib formaati samuti lisada - suvaliste nimedega, nn kasutaja-poolt defineeritud väljadena, mis ei ole otseselt meie formaadi nimeruumis.

- XML formaadi kasutamise korral ei ole väga oluline, mis on konkreetselt tagide ja atribuutide nimed: oluline on, et tagide oodatav sisu oleks piisavalt lahti selgitatud, ning oleks suhteliselt kerge mõista, mida mingisse tagi panna. Seetõttu oleme läbivalt kasutanud võimalikult selgelt mõistetavaid eestikeelseid nimesid tagidele, mitte aga näiteks Dublin Core ingliskeelseid nimesid.

- Kõik metainfo väljad moodustavad sisuliselt "lameda", struktuurita loetelu rdf-ideoloogiaga sobivatest nimi-väärtus paaridest, mida on lihtne realiseerida ja laiendada.

- Metainfo väljad ei ole allkirjastatud. Allkirjad on ainult dokumentide küljes DigiDoc konteineris. Seejuures on allkirjastatud dokumendil DigiDoc formaadis siiski olemas väike hulk spetsiaalseid metainfo-välju (dokumendi formaat jne), mis on alati allkirjastatud. NB! DigiDoc formaati kasutatakse ainult DVK konteineri versiooni 1 puhul. DVK konteineri versioon 2 kasutab <failid> konteinerit, millel ei ole allkirja hoidmiseks spetsiaalset struktuuri. Allkirjastatud dokumentide edastamiseks saab sellisel juhul lisada allkirjastatud dokumendi <failid> konteinerisse.

- Kuupäevi ja kellaaegu esitatakse XML struktuuris ISO8601 standardile vastavalt (http://www.w3.org/TR/NOTE-datetime). S.t. kuupäev+kellaaeg kujul YYYY-MM-DDThh:mm:ssTZD (näit: 2006-03-20T17:25:00+02:00) ning kuupäev kujul YYY-MM-DD (näit: 2006-03-20)

Juhime veel tähelepanu, et DVK konteineri versiooni 1 (kasutab failide kirjeldamiseks DigiDoc konteinerit):

- DigiDoc ei pea sisaldama allkirja.
- Üks DigiDoc võib sisaldada mitmeid konkreetseid dokumente.
- DigiDoc sees olevate konkreetsete dokumentide allkirja-blokke hoitakse dokumendi juures, mitte „dokument“ konteineri DigiDoc-is
- Iga sisalduv konkreetne dokument võib sisaldada metadata atribuute, mis signeeritakse.
- Lisatavaid metadata blokke ei signeerita.


Alates DVK versioonist 1.6.0 on toetatud ka DVK konteineri versioon 2, milles faile hoitakse `<failid>` konteineris. `<failid>` konteiner sisaldab omakorda suvalise arvu faile ja nende metaandmeid. DVK konteineri versioon 2 ei toeta otse failide konteineri küljes olevat digiallkirja. Digiallkirjastatud dokumentide edastamiseks tuleb `<failid>` konteinerisse lisada allkirjastatud DigiDoc fail.


###Dokumendi üldine ümbrik

DVK-le saadetavad ja sealt loetavad dokumendid on järgmisel kujul XML-tekstid (detailsemalt kirjeldatakse infoblokke järgmistes peatükkides):

```xml
<?xml version="1.0" encoding="UTF-8" ?><dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl">

 <!-- Konkreetse struktuuri/semantikaga metainfo blokk,
      Sisaldab nii DVK tarkvara kui kasutaja poolt sisestatut.
      Siia blokki pannakse metainfo, millest teised süsteemid
      peavad aru saama.
      Võib saatja poolt jääda tühjaks/puududa.            
 -->
 <dhl:metainfo/>

 <!-- Konkreetse semantikaga transpordiblokk, sisaldab konkreetset kust/kuhu
      infot, mille kaudu DVK tarkvara dokumendi edasi saadab.
      Edasisaatmiseks mõeldud dokumentide juures kohustuslik osa.
 -->
 <dhl:transport/>

 <!-- Informatsioon dokumendi senise liikumistee ja muutumiste kohta.
      Blokk sisaldab lihtsalt varasemaid metainfo, transport ja metaxml
      blokke, järjestikuselt. Dokumendi edasisaatmisel kopeeritakse viimased
      nimetatud blokid ajaloo bloki lõppu. Tarkvara võib kopeerimise käigus
      otsustada mõned bloki osad (või terved blokid) kopeerimata jätta.
      Esialgse saatja poolt jäetakse üldjuhul tühjaks.
 -->
 <dhl:ajalugu/>

 <!—- Järgnevad dokumendi liigist sõltuva struktuuriga metaandmed.
      Soovituslik oleks igal konkreetsel juhul viidata metaandmete struktuuri
      kirjeldavale XML skeemile (schema), kasutada selleks xmlns ja schemaLocation
      atribuute. Vaikimisi eeldatakse, et metaxml blokis sisalduvad andmed vastavad
      Riigikantselei poolt fikseeritud kirja metaandmete vormingule:
      (http://www.riik.ee/schemas/dhl/rkel_letter.xsd)
 -->
 <dhl:metaxml xmlns="http://www.riik.ee/schemas/dhl/rkel_letter"
   schemaLocation="http://www.riik.ee/schemas/dhl/rkel_letter
   http://www.riik.ee/schemas/dhl/rkel_letter.xsd"/>

 <!-- Järgneb üks SignedDoc struktuur, kas siis signatuuridega või ei.
      SignedDoc blokk sisaldab konkreetseid dokumente.
      Kirjeldus vastab täpselt AS Sertifitseerimiskeskuse antud
      kirjeldusele, täiendavat infot järgnevas.
 -->

 <!-- DVK konteiner versioon 1 -->
 <SignedDoc/>

 <!-- DVK konteiner versioon 2 -->
 <dhl:failid/>

</dhl:dokument>
```

Järgnev on DigiDoc formaadi ümbriku ülemise taseme kirjeldus AS Sertifitseerimiskeskuselt (SK). DataFile ja Signature blokkide sisu struktuuri saab lugeda SK kodulehe kaudu leitavalt DigiDoc lehelt.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<SignedDoc format="DIGIDOC-XML" version="1.3"           
           xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">       
    <!-- Optsionaalsed algandmefailid: DigiDoc formaadi järgi -->
    <DataFile/>
    .....
    <DataFile/>
    <!-- Optsionaalsed: kliendi allkirjad koos kehtivuskinnitustega,
         DigiDoc formaadi järgi -->
    <Signature/>
    ....
    <Signature/>
</SignedDoc>

Kui kasutatakse DVK konteineri versiooni 2, siis hoitakse faile <failid> konteineris, mille struktuur on järgmine:

<dhl:failid xmlns="http://www.riik.ee/schemas/dhl/2010/2">       
<fail>
        <jrknr/>
      <fail_pealkiri/>
      <fail_suurus/>
      <fail_tyyp/>
      <fail_nimi/>
      <zip_base64_sisu/>
      <krypteering/>
      <pohi_dokument/>
      <pohi_dokument_konteineris/>
    </fail>
</dhl:failid>
```

Kui kasutatakse DVK konteineri versiooni 2, siis hoitakse faile `<failid>` konteineris, mille struktuur on järgmine:

```
<dhl:failid xmlns="http://www.riik.ee/schemas/dhl/2010/2">       
<fail>
        <jrknr/>
      <fail_pealkiri/>
      <fail_suurus/>
      <fail_tyyp/>
      <fail_nimi/>
      <zip_base64_sisu/>
      <krypteering/>
      <pohi_dokument/>
      <pohi_dokument_konteineris/>
    </fail>
</dhl:failid>
```

###Metainfo blokk dokumendis

MetaInfo bloki struktuur on lame: ta sisaldab hulgaliselt rdf-ideoloogia järgi väli-väärtus paare, kus iga paar annab kogu dokumendi ümbriku jaoks mingi väärtuse.

Metainfo väljade nimede juures otsustasime lähtuda esmajoones Eesti dokumendihaldussüsteemide ja ametiasutuste tüüpvajadustes ja asjaajamiskorrast ning -printsiipidest, mitte aga otseselt Dublin Core väljadest. Rõhutame, et vajadusel on XML-süntaksis välju väga lihtne automaatselt tõlkida teistes keeltes väljadeks.

-   Ükski metainfo bloki väli (erinevalt transpordi bloki väljadest) ei ole kohustuslik.
-   Osa metainfo välju tuleb kasutajalt/DHS-st, osa aga täidab DVK automaatselt.
-   DVK peaks pakkuma võimalust teostada dokumentide otsingut ja võib-olla ka muid teenuseid, baseerudes nimetatud väljade sisule (DVK realisatsioonilt võiks oodata, et nimetatud väljade sisu paigutatakse igaüks eraldi andmebaasiväljale).
-   Väljade üks eesmärk on olla nö vahekeeleks, mille kaudu erinevad DHS-s oma metainfot ekspordivad ja impordivad.

Metainfo väljad jaotuvad järgmiselt:

-   DVK tarkvara poolt automaatselt täidetavad väljad. Need väljad on nimeruumis [http://www.riik.ee/schemas/dhl-meta-automatic](http://www.riik.ee/schemas/dhl-meta-automatic)
-   DVK tarkvara poolt automaatselt täidetavad väljad, mis on võetud e-kirja päistest: ainult juhul, kui dokument on DVK-le saadetud e-postiga. Need väljad on nimeruumis http://www.riik.ee/schemas/dhl-meta-automatic.
-   Väljad, mille olemasolu korral omavad välja sisu konkreetset tähendust repositooriumi jaoks. Need väljad on järgmistes nimeruumides sõltuvalt kasutatavast DVK konteineri versioonist:
    - DVK konteiner versioon 1 - [http://www.riik.ee/schemas/dhl-meta-manual](http://www.riik.ee/schemas/dhl-meta-manual)
    - DVK konteiner versioon 2 - [http://www.riik.ee/schemas/dhl-meta-manual/2010/2](http://www.riik.ee/schemas/dhl-meta-manual/2010/2)
-   Mistahes muud väljad, mida dokumendi DVK-sse lisav tarkvara soovib metainfosse lisada. Nende väljade kodeeringu viis on erinev, kui eelmistel, DVK jaoks tähendust omavatel väljadel. Ainus siin kasutatav tag on nimeruumis [http://www.riik.ee/schemas/dhl-meta-manual](http://www.riik.ee/schemas/dhl-meta-manual) (DVK konteineri versioon 1)

```xml
<dhl:metainfo xmlns:dhl="http://www.riik.ee/schemas/dhl"
              xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic"  
              xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual">  

<!-- DVK tarkvara poolt alati,
     automaatselt täidetavad väljad, kusjuures
     teine blokk on kasutusel xteega saadud/saadetud
     dokumentide, kolmas aga epostiga saadud/saadetud
     dokumentide jaoks -->

 <ma:dhl_id>DVK sisene unikaalne id</ma:dhl_id>
 <ma:dhl_kaust>Kausta, kus antud dokumenti DVK-s hoitakse, nimi</ma:dhl_kaust>
 <ma:dhl_saabumisviis>esialgu string email või string xtee</ma:dhl_saabumisviis>
 <ma:dhl_saabumisaeg>DVK -sse saabumise aeg CCYY-MM-DDThh:mm:ss</ma:dhl_saabumisaeg>  
 <ma:dhl_saatmisviis>esialgu string email või string xtee</ma:dhl_saatmisviis>
 <ma:dhl_saatmisaeg>DVKst saatmise aeg CCYY-MM-DDThh:mm:ss</ma:dhl_saatmisaeg>

 <ma:dhl_saatja_asutuse_nr>
   registrinr turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_asutuse_nr>
 <ma:dhl_saatja_asutuse_nimi>
   asutuse nimi turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_asutuse_nr>
 <ma:dhl_saatja_isikukood>
  isikukood turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_isikukood>
 <ma:dhl_saaja_asutuse_nr>
   registrinr turvaserverile (xteega saadetud)
 </ma:dhl_saaja_asutuse_nr>
 <ma:dhl_saaja_asutuse_nimi>
   asutuse nimi turvaserverile (xteega saadetud)
 </ma:dhl_saaja_asutuse_nr>
 <ma:dhl_saaja_isikukood>
  saaja kood turvaserverile (xteega saadetud)
 </ma:dhl_saaja_isikukood>

 <ma:dhl_saatja_epost>
  saatja eposti aadress (tulnud epostiga)
 </ma:dhl_saatja_epost>
 <ma:dhl_saaja_epost>
  epost, kellele saadeti (saadetud epostiga)
 </ma:dhl_saaja_epost>


<!-- DVK tarkvara poolt automaatselt täidetavad väljad,
     mis on võetud emaili headeritest: ainult juhul, kui
     dokument on DVK -sse saadetud mailiga -->

 <ma:dhl_email_header  ma:name="E-posti headeri välja nimi">
   Sisu
 </ma:dhl_email_header>


<!-- väljad, mille olemasolu korral metainfo blokis
     omab välja sisu konkreetset tähendust DVK jaoks
     ning seda saab kasutada mh otsingutes ja kasutajaliideses.

    Siin on toodud eraldi info koostaja kohta ja info
    saatja kohta: viimast tuleb kasutada, kui saatja (asutus)
    on erinev koostajast (asutusest)

 -->

 <mm:koostaja_asutuse_nr>
    algse koostaja (autori) asutuse number
 </mm:koostaja_asutuse_nr>
 <mm:saaja_asutuse_nr>
   asutuse nr, kellele saata (kui tühi, ei saadeta)
 </mm:saaja_asutuse_nr>

 <mm:koostaja_dokumendinimi>
   dokumendi nimi koostajal
 </mm:koostaja_doknimi>
 <mm:koostaja_dokumendityyp>
  dokumendi tüüp koostajal (leping vms)
 </mm:koostaja_doktyyp>
 <mm:koostaja_dokumendinr>
   koostaja asutuse dokumendinumber
 </mm:koostaja_dokumendinr>
 <mm:koostaja_failinimi>
   failinimi koostajal (ilma kataloogide-teeta)
 </mm:koostaja_kataloog>
 <mm:koostaja_kataloog>
   kataloog, kus koostaja dokumenti hoidis (täistee, ilma dokumendifaili nimeta)
 </mm:koostaja_kataloog>
 <mm:koostaja_votmesona>
  dokumendi võtmesõna koostajal
 </mm:koostaja_votmesona>
 <mm:koostaja_kokkuvote>
   dokumendi sisu/eesmärgi lühike kokkuvõte (abstract)
 </mm:koostaja_kokkuvote>
 <mm:koostaja_kuupaev>
   koostamiskuupäev
 </mm:koostaja_kuupaev>
 <mm:koostaja_asutuse_nimi>
  algse koostaja asutuse nimi
 </mm:koostaja_asutuse_nimi>
 <mm:koostaja_asutuse_kontakt>
  algse koostaja asutuse kontaktinfo
 </mm:koostaja_asutuse_kontakt>

 <mm:autori_osakond>
   osakond, kus autor ehk ametlik saatja peaks töötama
 </mm:autori_osakond>
 <mm:autori_isikukood>
  autori ehk ametliku saatja isikukood
 </mm:autori_isikukood>
 <mm:autori_nimi>
  autori ehk ametliku saatja nimi
 </mm:autori_nimi>
 <mm:autori_kontakt>
  autori ehk ametliku saatja kontaktinfo
 </mm:autori_kontakt>

 <mm:seotud_dokumendinr_koostajal>
  Koostaja dokument, mis on praegusega seotud
 </mm:seotud_dokumendinr_koostajal>
 <mm:seotud_dokumendinr_saajal>
  Saaja dokument, mis on praegusega seotud
  </mm:seotud_dokumendinr_saajal>

 <mm:saatja_dokumendinr>
  saatja asutuse dokumendinumber (kui erineb koostajast)
 </mm:saatja_dokumendinr>
 <mm:saatja_kuupaev>
  saatmiskuupäev (kui erineb koostamiskuupäevast)
 </mm:saatja_kuupaev>
 <mm:saatja_asutuse_kontakt>
  saatja asutuse kontakt
 </mm:saatja_asutuse_kontakt>

 <mm:saaja_isikukood>
  isikukood, kellele dokument saadetakse
 </mm:saaja_isikukood>
 <mm:saaja_nimi>
  isiku nimi, kellele dokument saadetakse
 </mm:saaja_nimi>
 <mm:saaja_osakond>
  osakonna nimi, kus vastav isik peaks töötama
 </mm:saaja_osakond>
 <mm:seotud_dhl_id>
  Seotud dokumendi DVK ID.
 </mm:seotud_dhl_id>
 <mm:sisu_id>
  Põhifaili ID, kui SignedDoc konteineris saadetakse mitu faili.
  Vajalik selleks, et saaks eristada põhifaili ja lisafaile.
 </mm:sisu_id>
<!--
  mistahes muud väljad, mida dokumendi DVK-sse lisav
  tarkvara soovib metainfosse lisada. Nende väljade kodeeringu
  viis on erinev, kui eelmistel, DVK jaoks tähendust
  omavatel väljadel.
-->

  <mm:saatja_defineeritud mm:valjanimi="Mingi nimi">
   Mingi väärtus
  </mm:saatja_defineeritud>

</dhl:metainfo>
```

Kui kasutusel on DVK konteineri versioon 2, siis on kasutatavaks nimeruumiks [http://www.riik.ee/schemas/dhl-meta-manual/2010/2](http://www.riik.ee/schemas/dhl-meta-manual/2010/2).
DVK konteineri versioon 2 metainfo blokk näeb välja järgmine:

```xml
<dhl:metainfo xmlns:dhl="http://www.riik.ee/schemas/dhl/2010/2"
              xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic"  
              xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual/2010/2">  

<!-- DVK tarkvara poolt alati,
     automaatselt täidetavad väljad, kusjuures
     teine blokk on kasutusel xteega saadud/saadetud
     dokumentide, kolmas aga epostiga saadud/saadetud
     dokumentide jaoks -->

 <ma:dhl_id>DVK sisene unikaalne id</ma:dhl_id>
 <ma:dhl_kaust>Kausta, kus antud dokumenti DVK-s hoitakse, nimi</ma:dhl_kaust>
 <ma:dhl_saabumisviis>esialgu string email või string xtee</ma:dhl_saabumisviis>
 <ma:dhl_saabumisaeg>DVK -sse saabumise aeg CCYY-MM-DDThh:mm:ss</ma:dhl_saabumisaeg>  
 <ma:dhl_saatmisviis>esialgu string email või string xtee</ma:dhl_saatmisviis>
 <ma:dhl_saatmisaeg>DVKst saatmise aeg CCYY-MM-DDThh:mm:ss</ma:dhl_saatmisaeg>

 <ma:dhl_saatja_asutuse_nr>
   registrinr turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_asutuse_nr>
 <ma:dhl_saatja_asutuse_nimi>
   asutuse nimi turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_asutuse_nr>
 <ma:dhl_saatja_isikukood>
  isikukood turvaserverist (ainult xteest tulnud)
 </ma:dhl_saatja_isikukood>
 <ma:dhl_saaja_asutuse_nr>
   registrinr turvaserverile (xteega saadetud)
 </ma:dhl_saaja_asutuse_nr>
 <ma:dhl_saaja_asutuse_nimi>
   asutuse nimi turvaserverile (xteega saadetud)
 </ma:dhl_saaja_asutuse_nr>
 <ma:dhl_saaja_isikukood>
  saaja kood turvaserverile (xteega saadetud)
 </ma:dhl_saaja_isikukood>

 <ma:dhl_saatja_epost>
  saatja eposti aadress (tulnud epostiga)
 </ma:dhl_saatja_epost>
 <ma:dhl_saaja_epost>
  epost, kellele saadeti (saadetud epostiga)
 </ma:dhl_saaja_epost>


<!-- DVK tarkvara poolt automaatselt täidetavad väljad,
     mis on võetud emaili headeritest: ainult juhul, kui
     dokument on DVK -sse saadetud mailiga -->

 <ma:dhl_email_header  ma:name="E-posti headeri välja nimi">
   Sisu
 </ma:dhl_email_header>


<!-- väljad, mille olemasolu korral metainfo blokis
     omab välja sisu konkreetset tähendust DVK jaoks
     ning seda saab kasutada mh otsingutes ja kasutajaliideses.

    Siin on toodud eraldi info koostaja kohta ja info
    saatja kohta: viimast tuleb kasutada, kui saatja (asutus)
    on erinev koostajast (asutusest)

 -->

 <mm:koostaja_asutuse_nr>
    algse koostaja (autori) asutuse number
 </mm:koostaja_asutuse_nr>
 <mm:saaja_asutuse_nr>
   asutuse nr, kellele saata (kui tühi, ei saadeta)
 </mm:saaja_asutuse_nr>

 <mm:koostaja_dokumendinimi>
   dokumendi nimi koostajal
 </mm:koostaja_doknimi>
 <mm:koostaja_dokumendityyp>
  dokumendi tüüp koostajal (leping vms)
 </mm:koostaja_doktyyp>
 <mm:koostaja_dokumendinr>
   koostaja asutuse dokumendinumber
 </mm:koostaja_dokumendinr>
 <mm:koostaja_failinimi>
   failinimi koostajal (ilma kataloogide-teeta)
 </mm:koostaja_kataloog>
 <mm:koostaja_kataloog>
   kataloog, kus koostaja dokumenti hoidis (täistee, ilma dokumendifaili nimeta)
 </mm:koostaja_kataloog>
 <mm:koostaja_votmesona>
  dokumendi võtmesõna koostajal
 </mm:koostaja_votmesona>
 <mm:koostaja_kokkuvote>
   dokumendi sisu/eesmärgi lühike kokkuvõte (abstract)
 </mm:koostaja_kokkuvote>
 <mm:koostaja_kuupaev>
   koostamiskuupäev
 </mm:koostaja_kuupaev>
 <mm:koostaja_asutuse_nimi>
  algse koostaja asutuse nimi
 </mm:koostaja_asutuse_nimi>
 <mm:koostaja_asutuse_kontakt>
  algse koostaja asutuse kontaktinfo
 </mm:koostaja_asutuse_kontakt>

 <mm:autori_osakond>
   osakond, kus autor ehk ametlik saatja peaks töötama
 </mm:autori_osakond>
 <mm:autori_isikukood>
  autori ehk ametliku saatja isikukood
 </mm:autori_isikukood>
 <mm:autori_nimi>
  autori ehk ametliku saatja nimi
 </mm:autori_nimi>
 <mm:autori_kontakt>
  autori ehk ametliku saatja kontaktinfo
 </mm:autori_kontakt>

 <mm:seotud_dokumendinr_koostajal>
  Koostaja dokument, mis on praegusega seotud
 </mm:seotud_dokumendinr_koostajal>
 <mm:seotud_dokumendinr_saajal>
  Saaja dokument, mis on praegusega seotud
  </mm:seotud_dokumendinr_saajal>

 <mm:saatja_dokumendinr>
  saatja asutuse dokumendinumber (kui erineb koostajast)
 </mm:saatja_dokumendinr>
 <mm:saatja_kuupaev>
  saatmiskuupäev (kui erineb koostamiskuupäevast)
 </mm:saatja_kuupaev>
 <mm:saatja_asutuse_kontakt>
  saatja asutuse kontakt
 </mm:saatja_asutuse_kontakt>

 <mm:saaja_isikukood>
  isikukood, kellele dokument saadetakse
 </mm:saaja_isikukood>
 <mm:saaja_nimi>
  isiku nimi, kellele dokument saadetakse
 </mm:saaja_nimi>
 <mm:saaja_osakond>
  osakonna nimi, kus vastav isik peaks töötama
 </mm:saaja_osakond>
 <mm:seotud_dhl_id>
  Seotud dokumendi DVK ID.
 </mm:seotud_dhl_id>
 <mm:sisu_id>
  Põhifaili ID, kui SignedDoc konteineris saadetakse mitu faili.
  Vajalik selleks, et saaks eristada põhifaili ja lisafaile.
 </mm:sisu_id>
<!--
  mistahes muud väljad, mida dokumendi DVK-sse lisav
  tarkvara soovib metainfosse lisada. Nende väljade kodeeringu
  viis on erinev, kui eelmistel, DVK jaoks tähendust
  omavatel väljadel.
-->

  <mm:saatja_defineeritud mm:valjanimi="Mingi nimi">
   Mingi väärtus
  </mm:saatja_defineeritud>

    <mm:test>
Näitab, kas tegu on testsõnumiga
</mm:test>
    <mm:dokument_liik>
Dokumendi liik (kiri, õigusakt, arve jne.)
</mm:dokument_liik>
    <mm:dokument_keel>
Keel, milles dokument on koostatud
</mm:dokument_keel>
    <mm:dokument_pealkiri>
Dokumendi pealkiri
</mm:dokument_pealkiri>
<mm:versioon_number>
Dokumendi versiooninumber
</mm:versioon_number>
<mm:dokument_guid>
Dokumendi globaalselt unikaalne identifikaator
</mm:dokument_guid>
<mm:dokument_viit>
Dokumendi viit. Dokumendi registreerimisnumber dokumendihaldussüsteemis(DHS) (Nt. "1.2/4-6")
</mm:dokument_viit>
<mm:kuupaev_registreerimine>
Dokumendi DHS-is registreerimise kuupäev ja kellaaeg
</mm:kuupaev_registreerimine>
<mm:kuupaev_saatmine>
Dokumendi DHS-ist väljasaatmise kuupäev ja kellaaeg
</mm:kuupaev_saatmine>
<mm:tahtaeg>
Dokumendiga seotud toimingu täitmise tähtaeg. Nt. kirja puhul vastamise tähtaeg
</mm:tahtaeg>
<mm:saatja_kontekst>
    <mm:seosviit>
Dokumendi registreerimisnumber algse dokumendi saatja süsteemis
</mm:seosviit>
    <mm:kuupaev_saatja_registreerimine>
Dokumendi registreerimise kuupäev ja kellaaeg algse dokumendi saatja süsteemis
</mm:kuupaev_saatja_registreerimine>
    <mm:dokument_saatja_guid>
Algse dokumendi GUID
</mm:dokument_saatja_guid>
</mm:saatja_kontekst>

    <mm:ipr>
        <mm:ipr_tahtaeg>
Intellektuaalse omandi lõpptähtaeg
</mm:ipr_tahtaeg>
        <mm:ipr_omanik>
Intellektuaalse omandi omaja nimetus
</mm:ipr_omanik>
        <mm:reprodutseerimine_keelatud>
Näitab, kas dokumendi sisu on keelatud taasesitada
</mm:reprodutseerimine_keelatud>
</mm:ipr>

<mm:juurdepaas_piirang>
    <mm:piirang>
Juurdepääsupiirangu kirjeldus
</mm:piirang>
<mm:piirang_algus>
Juurdepääsupiirangu algus
</mm:piirang_algus>
<mm:piirang_lopp>
Juurdepääsupiirangu lõpp
</mm:piirang_lopp>
<mm:piirang_alus>
Juurdepääsupiirangu alus
</mm:piirang_alus>
</mm:juurdepaas_piirang>

<mm:koostajad>
    <mm:koostaja>
        <mm:eesnimi>
Dokumendi koostaja eesnimi
</mm:eesnimi>
        <mm:perenimi>
Dokumendi koostaja perenimi
</mm:perenimi>
        <mm:ametinimetus>
Dokumendi koostaja ametinimetus
</mm:ametinimetus>
        <mm:epost>
Dokumendi koostaja e-posti aadress
</mm:epost>
        <mm:telefon>
Dokumendi koostaja kontakttelefon
</mm:telefon>
</mm:koostaja>
…
<mm:koostaja/>
</mm:koostajad>

</dhl:metainfo>
```


###Transport blokk dokumendis

Transport blokk sisaldab dokumendi edasisaatmiseks kriitilist vajalikku infot. Blokk on kohustuslik, kui dokument on mõeldud edasisaatmiseks. Täpsemalt vaata dokumentide logistika peatükist ja dhl.xsd schemast edasises. Ka siin sõltub bloki struktuur kasutatavast DVK konteineri versioonist. **Versioon 1** puhul on kasutusel järgmine struktuur:

```xml
<dhl:transport xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <!-- üks saatja info blokk -->
 <dhl:saatja>
   <dhl:regnr>Saatja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Saatja isikukood<dhl:isikukood>
   <dhl:epost>Saatja eposti aadress<dhl:epost>
   <dhl:nimi>Saatja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Saatja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_kood>Saatja ametikoha kood (DVK ID)<dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Saatja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_kood>Saatja allüksuse kood (DVK ID)<dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>Saatja allüksuse nimetus<dhl:allyksuse_nimetus>
   <dhl:osakonna_kood>Saatja struktuuriüksuse asutusesisene kood<dhl:osakonna_kood>
   <dhl:osakonna_nimi> Saatja struktuuriüksuse nimi<dhl:osakonna_nimi>
 </dhl:saatja>

 <!-- piiramatu arv saaja info blokke -->
 <dhl:saaja>
   <dhl:regnr>Saaja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Saatja isikukood<dhl:isikukood>
   <dhl:epost>Saaja eposti aadress<dhl:epost>
   <dhl:nimi>Saaja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Saaja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_kood>Saaja ametikoha kood (DVK ID)<dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Saaja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_kood>Saaja allüksuse kood (DVK ID)<dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>Saaja allüksuse nimetus<dhl:allyksuse_nimetus>
   <dhl:osakonna_kood>Saaja struktuuriüksuse asutusesisene kood<dhl:osakonna_kood>
   <dhl:osakonna_nimi> Saaja struktuuriüksuse nimi<dhl:osakonna_nimi>
 </dhl:saaja>
   ....
 <dhl:saaja/>

 <!-- kuni üks vahendaja info blokk -->
 <dhl:vahendaja>
   <dhl:regnr>Vahendaja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Vahendaja isikukood<dhl:isikukood>
   <dhl:epost>Vahendaja eposti aadress<dhl:epost>
   <dhl:nimi>Vahendaja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Vahendaja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_kood>Vahendaja ametikoha kood (DVK ID)<dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Vahendaja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_kood>Vahendaja allüksuse kood (DVK ID)<dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>vahendaja allüksuse nimetus<dhl:allyksuse_nimetus>
   <dhl:osakonna_kood>Vahendaja struktuuriüksuse asutusesisene kood<dhl:osakonna_kood>
   <dhl:osakonna_nimi>Vahendaja struktuuriüksuse nimi<dhl:osakonna_nimi>
 </dhl:vahendaja>
</dhl:transport>
```
###DVK konteineri versioon 2 puhul on kasutusel järgmine struktuur:

```xml
<dhl:transport xmlns:dhl="http://www.riik.ee/schemas/dhl/2010/2">
  <!-- üks saatja info blokk -->
 <dhl:saatja>
     <dhl:teadmiseks>
Näitab, kas antud dokument on adressaadile teadmiseks või täitmiseks
 <dhl:teadmiseks>
   <dhl:regnr>Saatja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Saatja isikukood<dhl:isikukood>
   <dhl:epost>Saatja eposti aadress<dhl:epost>
   <dhl:nimi>Saatja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Saatja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_lyhinimetus>Saatja ametikoha lühinimetus<dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Saatja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_lyhinimetus>Saatja allüksuse lühinimetus<dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>Saatja allüksuse nimetus<dhl:allyksuse_nimetus>
</dhl:saatja>

 <!-- piiramatu arv saaja info blokke -->
 <dhl:saaja>
   <dhl:teadmiseks>
Näitab, kas antud dokument on adressaadile teadmiseks või täitmiseks
 <dhl:teadmiseks>
   <dhl:regnr>Saaja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Saatja isikukood<dhl:isikukood>
   <dhl:epost>Saaja eposti aadress<dhl:epost>
   <dhl:nimi>Saaja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Saaja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_lyhinimetus>Saaja ametikoha lühinimetus<dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Saaja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_lyhinimetus>Saaja allüksuse lühinimetus<dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>Saaja allüksuse nimetus<dhl:allyksuse_nimetus>
 </dhl:saaja>
   ....
 <dhl:saaja/>

 <!-- kuni üks vahendaja info blokk -->
 <dhl:vahendaja>
   <dhl:teadmiseks>
Näitab, kas antud dokument on adressaadile teadmiseks või täitmiseks
 <dhl:teadmiseks>
   <dhl:regnr>Vahendaja asutuse registreerimisnumber<dhl:regnr>
   <dhl:isikukood>Vahendaja isikukood<dhl:isikukood>
   <dhl:epost>Vahendaja eposti aadress<dhl:epost>
   <dhl:nimi>Vahendaja nimi<dhl:nimi>
   <dhl:asutuse_nimi>Vahendaja asutuse nimi<dhl:asutuse_nimi>
   <dhl:ametikoha_lyhinimetus>
     Vahendaja ametikoha lühinimetus
   <dhl:ametikoha_kood>
   <dhl:ametikoha_nimetus>Vahendaja ametikoha nimetus<dhl:ametikoha_nimetus>
   <dhl:allyksuse_lyhinimetus>
     Vahendaja allüksuse lühinimetus
   <dhl:allyksuse_kood>
   <dhl:allyksuse_nimetus>vahendaja allüksuse nimetus<dhl:allyksuse_nimetus>
</dhl:vahendaja>
</dhl:transport>
```
###Ajalugu blokk dokumendis

Ajalugu blokk sisaldab kas täielikke või osalisi koopiaid dokumendi varasematest metainfo-, transport- ja metaxml blokkidest. Ajalugu blokki lisab seniste vastavate blokkide koopiaid dokumenti edasisaatev rakendus, lisades kas tervikblokid või nende osad ajalugu bloki lõppu:

```xml
<dhl:ajalugu xmlns:dhl="http://www.riik.ee/schemas/dhl">
   <dhl:metainfo/>
   <dhl:transport/>
   <dhl:metaxml/>
      ...
   <dhl:metainfo/>
   <dhl:transport/>
   <dhl:metaxml/>
<dhl:ajalugu/>
```
###Metaxml blokk dokumendis
Metaxml bloki sisuks on dokumendi liigist sõltuva struktuuriga metaandmed. Soovituslik oleks igal konkreetsel juhul viidata metaandmete struktuuri kirjeldavale XML skeemile (schema), kasutades selleks xmlns ja schemaLocation atribuute. Vaikimisi eeldatakse, et metaxml blokis sisalduvad andmed vastavad Riigikantselei poolt fikseeritud kirja metaandmete vormingule: (http://www.riik.ee/schemas/dhl/rkel\_letter.xsd)

```xml
<dhl:metaxml xmlns="http://www.riik.ee/schemas/dhl/rkel_letter"
  schemaLocation="http://www.riik.ee/schemas/dhl/rkel_letter
  http://www.riik.ee/schemas/dhl/rkel_letter.xsd">

  <!—- Järgnevad dokumendi liigist sõltuva struktuuriga metaandmed.
     Soovituslik oleks igal konkreetsel juhul viidata metaandmete struktuuri
     kirjeldavale XML skeemile (schema), kasutades selleks xmlns ja schemaLocation
     atribuute. Vaikimisi eeldatakse, et metaxml blokis sisalduvad andmed vastavad
     Riigikantselei poolt fikseeritud kirja metaandmete vormingule:
     (http://www.riik.ee/schemas/dhl/rkel_letter.xsd)
  -->

<dhl:metaxml/>
```
###Taustinfoks:DigiDoci konteiner
Selline on DigiDoc konteineri üldstruktuur:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<SignedDoc format="DIGIDOC-XML" version="1.3"
           xmlns="http://www.sk.ee/DigiDoc/v1.3.0#"                     
    <!-- algandmefailid -->
    <DataFile />
    <!-- kliendi allkirjad koos kehtivuskinnitustega -->
    <Signature />
</SignedDoc>
```

DigiDoc fail sisaldab ühe või enama algandmefaili või viite väliselt salvestatud failile.

Iga faili kohta tehakse kirje `<DataFile>`, mis omab järgmisi atribuute:

    Id - faili sisemine unikaalne tunnus.
    Andmefailide tunnused algavad sümboliga 'D', millele järgneb faili järjekorranumber.

    Filename - faili tegelik (väline) nimi ilma teekonnata.

    ContentType - dokumendi salvestamise meetod (DETATCHED, EMBEDDED\_BASE64 või EMBEDDED)

    EMBEDDED - faili andmed on sisestatud algkujul antud kirjes.
Kasutatav vaid XML kujul algandmete jaoks. Tähelepanu tuleb osutada sellel, et algandmete XML fail ei sisaldaks XML päist (`<?xml ... ?>`) ega DTD-d. Siin kirjeldatud XML elemendid ei ole keelatud. Võmalik on ühe faili sisse salvestada algkujul teist DigiDoc faili.

    EMBEDDED\_BASE64 - faili andmed on sisestatud Base64 kujul antud kirjes.

    DETATCHED - algandmed sisalduvad failis, mille nimi on salvestatud atribuudis Filename.

    MimeType - algandmete andmetüüp.

    Size - tegeliku algandmefaili suurus baitides.

    DigestType - algandmefaili räsikoodi tüüp. Esialgu toetatakse vaid sha1 tüüpi. Nõutud vaid DETATCHED tüüpi faili puhul.

    DigestValue - algandmefaili räsikoodi väärtus Base64 kujul. Räsi arvutatakse algandmete üle nende originaalkujul. Nõutud vaid DETATCHED tüüpi faili puhul.

    Suvaline hulk muid atribuute (metaandmed) kujul `<nimi>`="`<väärtus>`".

    xmlns - peab kasutama SignedDoc namespacet: http://www.sk.ee/DigiDoc/v1.3.0\#.


###Taustinfoks:`<failid>` konteiner
DVK konteineri versioon 2 kasutab failide edastamiseks <SignedDoc> (DigiDoc) konteineri asemel `<failid>` konteinerit, mille struktuur on järgmine:

```xml
<dhl:failid xmlns=“http://www.riik.ee/schemas/dhl/2010/2“>
    <dhl:kokku>Failide arv</dhl:kokku>
    <dhl:fail>
        <dhl:jrknr>Faili järjekorranumber</dhl:jrknr>
        <dhl:fail_pealkiri>Faili pealkiri</dhl:fail_pealkiri>
        <dhl:fail_suurus>Faili suurus baitides</dhl:fail_suurus>
        <dhl:fail_tyyp>Faili MIME tüüp</dhl:fail_tyyp>
        <dhl:fail_nimi>Faili nimi</dhl:fail_nimi>
        <dhl:zip_base64_sisu>
ZIP-itud ja Base64 kodeeringusse pandud faili sisu
</dhl:zip_base64_sisu>
        <dhl:krypteering>Näitab, kas fail on krüpteeritud</dhl:krypteering>
<dhl:pohi_dokument>Näitab, kas tegemist on põhifailiga</dhl:pohi_dokument>
<dhl:pohi_dokument_konteineris>
Kui tegemist on konteinerfailiga (BDOC, DDOC, ZIP), siis annab põhifaili nime
</dhl:pohi_dokument_konteineris>
    </dhl:fail>
</dhl:failid>
```

##Dokumentide logistika
------

###Üldist
Kahe erineva asutuse dokumendihaldussüsteemide (DHS) vaheline automaatne elektrooniline dokumendivahetus realiseeritakse üle X-tee dokumendivahetuskeskuse (DVK) kaasabil. DHS-ile paistab DVK kätte kui X-tee infrastruktuuris asuv andmekogu ning ka sellega suhtlus realiseeritakse standardsel viisil – DHS-i juurde realiseeritakse X-tee adapterserver, mis suhtleb läbi asutuse turvaserveri DVK-ga.

###Tööskeem

####DVK loogiline ülesehitus
Dokumentide logistika teenuste seisukohast omab DVK järgmist loogilist ülesehitust:

-   Kõik DVK-d üle X-Tee kasutavad asutused on ära kirjeldatud suhtluspartneritena. Iga suhtluspartner omab DVK-s kontot, mille kaudu saab teistele asutustele dokumente saata ja endale saadetud dokumente vastu võtta.
-   Dokumente on DVK poolel võimalik vastavalt funktsioonile või dokumendiliigile paigutada kaustadesse. Iga dokument asub DVK-s mingis kaustas. Kui dokumendi saatmisel kausta ei määrata, paigutatakse dokument DVK-s nn. juurkausta.
-   Iga DVK-sse saadetava dokumendi puhul määratakse ära dokumendi saatja ning ühe või mitme adressaadi andmed. Adressaatide andmete alusel otsustatakse, millistele asutustele antud dokumenti üleslaadimiseks pakutakse.
-   DVK-sse saabumisel fikseeritakse iga adressaadi kohta dokumendi olekuks „saatmisel”. Kui adressaat on dokumendi DVK-st vastu võtnud ja dokumendi kättesaamist kinnitanud, saab dokument antud adressaadi seisukohast olekuks „saadetud”. Iga dokumendi kohta hoitakse DVK-s ka koondolekut. Kui dokument ootab saatmist vähemalt ühele adressaadile, on dokumendi koondolek „saatmisel”. Kui dokument on kõigi adressaatide poolt vastu võetud, saab dokumendi koondolekuks „saadetud”.

####Kaustade kasutamine
Juhul, kui tekib vajadus vahetada asutuste vahel mitut erinevat liiki dokumente või kui samas asutuses vahetavad DVK kaudu dokumente mitu erinevat rakendust, on otstarbekas kasutada dokumentide organiseerimiseks DVK poolel kaustade funktsionaalsust. S.t. näiteks e-arveid vahetavad asutused kausta /FINANTS kaudu ja kirju kausta /KIRJAD kaudu.

Vaikimisi võiks DVK rakendus sisaldada järgmisi kaustu:

-   FINANTS
-   PKD
-   KIRJAVAHETUS
-   OIGUSAKT
-   EVORMID

##### Kaustade kasutamine testimisel

Testimiseks on loodud eraldi testkeskkond. Toodangukeskkonnas tohib teostada vaid minimaalset testimist, kindlustamaks et DHS on suuteline DVK-ga andmeid vahetama.

Toodangukeskkonnas testimiseks tuleb test dokumente edastada kausta TEST. Selleks, et test dokumendid ei segaks asutuse kirjavahetust on väljaspool testperioodi soovitatav pärida dokumente kaustast „/“, mis tagastab vaid juurkataloogis olevad dokumendid.

##### Kaustade kasutamine e-vormide andmevahetuses

E-vorme kasutaval asutusel on võimalik vormid kätte saada ja neile vastata DVK kaudu.

E-vorm edastatakse e-vormide rakenduse (edaspidi EV) poolt asutusele ja asutuselt EV-le DVK dokumendikonteineris oleva failina "evorm.xml". Samas konteineris on ka vorm HTML vormingus.

Kui saadetava e-vormi adressaadiks olev asutus on DVK andmetel võimeline dokumente vastu võtma DVK vahendusel, siis toimetatakse vorm DVK kausta "EVORMID" või EV rakenduses vormi jaoks määratud kausta. Kuni vormi kättesaamiseni adressaadi poolt on vormi võimalik alla laadida ka eCommunity andmevahetusliidese kaudu, kuid allalaadimine eCommunity liidese kaudu ei tühista saatmist DVK kaudu.

Kui asutusel töötleb sama dokumendihaldussüsteem (edaspidi: DHS) kõiki DVK kaudu saabuvaid dokumente (mh vorme ja kirju), siis peaks DVK päringul jätma kausta nime määramata. Sellisel juhul laaditakse asutuse DHS –i kõik DVK –s asuvad dokumendid (sh vormid).

Kui asutusel töötleb vorme ja muid DVK dokumente erinev IS, peaks e-vorme töötlev rakendus dokumentide DVK –st allalaadimisel määrama kaustaks "EVORMID" (või EV rakenduses määratud kausta). Muude dokumentidega (peale e-vormide) tegelev asutuse DHS võib:

-   laadida DVK –st alla laadida kõik dokumendid (jättes määramata kausta), märkides neist kättesaaduks ainult need, mida ei töötle vormidega tegelev IS;
-   laadida dokumendid alla DVK juurkaustast või DVK päringu receiveDocuments parameetris "kaust" esitatud loetelus ette antud kaustadest (v.a vorme sisaldav kaust).

Vormile vastuse saatmisel peaks vastus olema adresseeritud samasse kausta, kuhu oli paigutatud algne EV rakenduse kasutaja poolt saadetud dokument. DVK-st allalaaditava dokumendi kaust on määratud elemendiga "ma:dhl\_kaust".

####Dokumentide edastamine

![Dokumentide edastamine](/docs/img/image1.png "Dokumentide edastamine")

Dokumentide edastamiseks teis(t)ele asutus(t)ele käivitab DHS päringu *dhl.sendDocuments*. Päringu kehasse paigutatakse massiivina kõik edastamist nõudvad dokumendid. Dokumendid peavad olema esitatud „dhlDokumentType“ XML tüübile vastavas formaadis (vt punkti „Dokumentide formaat“) ning omama elemendi „Transport“ all järgmisi kohustuslikke elemente:

-   saatja – element määrab dokumenti väljasaatva asutuse (üldjuhul sama, mis dokumenti edastav asutus)
-   saaja – üks kuni mitu elementi määravad asutused, millele tuleb antud dokument edastada. Kui saaja aadressinfos on määratud väli „epost“, siis edastatakse see dokument näidatud e-posti aadressile. Kui aadressinfos on määratud väli „regnr“ ning sellise registreerimisnumbriga asutus on DVK-s suhtluspartnerina kirjeldatud, toimub dokumendi üleandmine DVK siseselt.

Kui DVK server tuvastab, et mõne adressaadi jaoks tuleb dokument edastada mõnda teise DVK serverisse, siis lisab DVK server automaatselt dokumendi konteineri „transport“ elemendi alla elemendi:

-   vahendaja – element määrab selle asutuse andmed, mille nimel dokument ühest DVK serverist teise edastati.

DVK poolel saavad dokumendid staatuse „saatmisel” ja jäävad ootama *dhl.receiveDocuments* päringut. Päring tagastab vea, kui edastatud dokumentide struktuur sisaldab olulisi vigu. Päring ei tagasta viga juhul, kui mingite dokumentide adressaadile edastamine ei õnnestunud – edastamine toimub asünkroonselt. Edastamise õnnestumist saab kontrollida päringuga *dhl.getSendStatus*.

Antud päringuga saab dokumente salvestada ka DVK-sse selliselt, et edastamist saaja(te)le ei toimu. Sellisel juhul peab olema päringu parameeter „kaust“ olema väärtustatud selle kaustateega, kuhu soovitakse dokumendid salvestada ning „transport“ element ei tohi sisaldada ühtegi elementi „saaja“.

Päringuga on võimalik edastada ka dokumente, mis asuvad DVK dokumendikontol. Sellisel juhul tuleb tegeliku dokumendi asemel esitada dokumendi kehas element „ref“ vajaliku atribuudi väärtusega (kas atribuut „dhl\_id“ dokumendi ID väärtusega või siis „dhl\_taisnimi“ DVK kaustapuu dokumendi täispika nimega). Sealjuures on lubatud esitada ka element „Transport“, mis kirjutab dokumendil esineda võiva „Transport“ elemendi üle.

Päring tagastab resultaadina massiivi, mille vastavatel positsioonidel on edastatud dokumentide DVK seesmised ID-id.

####Edastatud dokumentide staatuse kontroll
Päringuga *dhl.getSendStatus* küsitakse päringu *dhl.sendDocuments* abil edastatud dokumentide olekuinfot. Päringu kehas esitatakse massiiv dokumentide ID-idest(DVK konteineri versioonis 2 on võimalik leida dokumendi staatus ka dokumendi GUID abil), mille olekut soovitakse teada saada. Päring tagastab massiivi, mille elementideks on dokumentide saatmisinfo. Saatmisinfo sisaldab iga saaja kohta elementi „edastus“, mille alamelementide tähendused on:

- „saaja“ element on samasuguse sisuga, nagu dokumendi saaja element oli algselt määratud.
- „saadud“ väärtuseks on kuupäev ja kellaaeg, mil DVK dokumendi saatjalt kätte sai.
- „meetod“ sisaldab edastusmeetodi väärtust: kas „xtee“ või „epost“.
- „edastatud“ väärtuseks on kuupäev ja kellaaeg, mil DVK kas saatis dokumendi e-posti aadressile või kui adressaat märkis dokumendi vastuvõetuks.
- „loetud“ väärtuseks on kuupäev ja kellaeg, mil teise osapoole DHS märkis päringuga *dhl.markDocumentsReceived* kättesaaduks. Saaja tohib dokumendi märkiga kättesaaduks siis, kui dokument on ametnikule nähtavaks tehtud. Dokumendi saabumine süsteemi ei ole võrdne dokumendi kätte saamisega vastuvõtja poolel. Juhul, kui dokument saabub DHS süsteemi, kuid selle kuvamine kasutajale ei ole võimalik, tuleb dokumendi staatuseks määrata „katkestatud“ (e-posti teel edastuse korral jääb see väli väärtustamata).
- „fault“ element on väärtustatud ainult juhul, kui edastamise käigus juhtus viga
- „staatus“ element näitab, mis **seisus antud saajale edastus on**. Võimalikud väärtused on:
    - „saatmisel“ – dokumenti üritatakse veel antud saajale edastada
    - „saadetud“ – dokument sai edukalt antud saajale saadetud
    - „katkestatud“ – dokumenti ei õnnestunud antud saajale saata.
- „vastuvotja\_staatus\_id“ element sisaldab adressaadi poolel dokumendile antud staatuse identifikaatorit. Element on väärtustatud ainult juhul, kui adressaat on omalt poolt dokumendile antud staatuse DVK-le edastanud.
- „metaxml” element sisaldab vaba struktuuriga XML- või tekstiandmeid vastuvõetud dokumenti puudutavate andmete saatmiseks dokumendi saatjale.

Saatmisinfo kirje sisaldab ka elemendi „olek“, **mille väärtus määrab dokumendi edastuse koondoleku**. Võimalikud väärtused on:

- „saatmisel“ – leidub vähemalt üks saaja, kellele veel üritatakse antud dokumenti saata.
- „saadetud“ – dokument õnnestus kõigile saajatele edastada.
- „katkestatud“ – vähemalt ühele saajale ei õnnestunud dokumenti edastada.

####Dokumentide vastuvõtt

![Dokumentide vastuvõtt](/docs/img/image2.png "Dokumentide vastuvõtt")

DHS-i poolne teiste asutuste poolt antud asutusele saadetud dokumentide vastuvõtt toimub päringu *dhl.receiveDocuments* abil. Päring tagastab kõik DVK-s antud asutusele teiste asutuste poolt edastatud dokumendid. Päringule saab elemendi „arv“ abil määrata piirangu, mitu dokumenti maksimaalselt tohib vastuses tagastada. Lisaks saab elemendi „kaust“ abil määrata kausta(d), kust dokumente loetakse.
Päring tagastab loetud dokumentide massiivi.
Peale edukat dokumentide vastuvõttu peab DHS käivitama päringu *dhl.markDocumentsReceived*, mille abil signaliseeritakse DVK-le, et näidatud dokumendid said edukalt alla laetud. Sellest päringust eksisteerib 3 versiooni:

- Päringu esimene versioon (v1) nõuab elemendi „dokumendid“ väärtuseks loetud dokumentide ID-ide massiivi.
- Päringu teine versioon (v2) nõuab elemendi „dokumendid“ väärtuseks loetud dokumentide kohta massiivi järgmise struktuuriga andmeelementidest:
    - „dhl\_id” element sisaldab loetud dokumendi DVK ID-d.
    - „vastuvotja\_staatus\_id” element sisaldab vastuvõtja poolel dokumendile omistatud staatuse identifikaatorit.
    - „fault” element sisaldab andmeid vastuvõtja poolel ilmnenud vea kohta.
    - „metaxml” vaba struktuuriga XML- või tekstiandmed vastuvõetud dokumenti puudutavate andmete saatmiseks dokumendi saatjale.
-   Päringu kolmandas versioonis
    Päring märgib esitatud ID-dele vastavad dokumendid DVK-s päringu teinud asutuse poolt vastuvõetuks. Kui päringul on väärtustatud parameeter „kaust“, siis toimub märgitakse vastuvõetuks ainult märgitud kaustas asuvad dokumendid.

Päring tagastab oma kehas väärtuse „OK“.

##X-Tee päringute kirjeldused

<a name="xroad-general-info"></a>
### Üldinfo
DVK veebiteenused kasutatakse üle X-Tee (DVK eeldab, et päringus on defineeritud X-Tee päised). Päringute kirjelduse juures on toodud välja päringu parameetrid ning päringu vastuse kuju X-Tee sõnumiprotokolli versioon 2.0 jaoks (veebiteenused stiilis „RPC/encoded”).

<a name="xroad-message-protocol-v4"></a>
### X-tee sõnumiprotokoll versioon 4.0
Vana sõnumiprotokolli (versioon 2.0) asemel võib kasutada X-tee sõnumiprotokolli versioon 4.0 (veebiteenused stiilis „Document/Literal wrapped”). Selleks on vaja teha järgmist:<br>
 1) vahetada vana protokolli nimeruumi defineerimist (`xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"`) järgmise kahe defineerimistega:
- `xmlns:xrd="http://x-road.eu/xsd/xroad.xsd"`
- `xmlns:id="http://x-road.eu/xsd/identifiers"`

2) panna SOAP päringu *header* elemendi sisse X-tee sõnumiprotikolli versioonile 4 vastavad elemendid. **Päringu keha (SOAP body) sisu jääb samaks.**

Päringu parameetritena on eeldatud alati järgmiste päiste olemasolu:

```xml
<xrd:client id:objectType="SUBSYSTEM">
    <id:xRoadInstance>tavaliselt riigi ISO kood</id:xRoadInstance>
    <id:memberClass>kliendi tüüp (kas riik,  asutus, ettevõtte, eraisik jne)</id:memberClass>
    <id:memberCode>päringut tegeva asutuse kood</id:memberCode>
    
    <!-- Optional (mittekohustuslik) -->
    <id:subsystemCode>allasutus, kelle nimel kasutaja päringut teostab</id:subsystemCode>
</xrd:client>
<xrd:service id:objectType="SERVICE">
    <id:xRoadInstance>tavaliselt riigi ISO kood</id:xRoadInstance>
    <id:memberClass>teenuse pakkuja tüüp (kas riik,  asutus, ettevõtte vms)</id:memberClass>
    <id:memberCode>teenuse pakkuja kood</id:memberCode>
    
    <id:subsystemCode>andmekogu nimi – „dhl“</id:subsystemCode>
    <id:serviceCode>päringu nimi (Nt. „sendDocuments”)</id:serviceCode>
    <id:serviceVersion>päringu versioon (Nt. „v1”)</id:serviceVersion>
</xrd:service>
<xrd:userId>päringu teinud isiku kood</xrd:userId>
<xrd:id>päringu ID</xrd:id>
<xrd:protocolVersion>sõnumiprotokolli versioon (peab olema 4.0)</xrd:protocolVersion>
```
<br>
Siin on standadse SOAP **päringu näide** *sendDocuments* teenuse jaoks, mis annab ettekujutuse X-tee sõnumiprotokolli v4.0 kasutamisest:
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"

        xmlns:xrd="http://x-road.eu/xsd/xroad.xsd"
        xmlns:id="http://x-road.eu/xsd/identifiers">
    <soapenv:Header>
        <xrd:client id:objectType="SUBSYSTEM">
            <id:xRoadInstance>EE</id:xRoadInstance>
            <id:memberClass>GOV</id:memberClass>
            <id:memberCode>70000562</id:memberCode>
        </xrd:client>
        <xrd:service id:objectType="SERVICE">
            <id:xRoadInstance>EE</id:xRoadInstance>
            <id:memberClass>GOV</id:memberClass>
            <id:memberCode>70006317</id:memberCode>

            <id:subsystemCode>dhl</id:subsystemCode>
            <id:serviceCode>sendDocuments</id:serviceCode>
            <id:serviceVersion>v4</id:serviceVersion>
        </xrd:service>
        <xrd:userId>EE38806190294</xrd:userId>
        <xrd:id>6cae248568b3db7e97ff784673a4d38c5906bee0</xrd:id>
        <xrd:protocolVersion>4.0</xrd:protocolVersion>
    </soapenv:Header>
    <soapenv:Body>
        <dhl:sendDocuments>
            <keha>
                <dokumendid href="cid:uus_kapsel_1.xml.gz.b64"/>
            </keha>
        </dhl:sendDocuments>
    </soapenv:Body>
</soapenv:Envelope>
```

Rohkem infot X-tee sõnumiprotokolli v4.0 kasutamise kohta saab vastavast [*tehnilisest spetsifikatsioonist*](http://x-road.eu/docs/x-road_message_protocol_v4.0.pdf).

##DVK teenused
Järgmisena on näidatud kõik DVK poolt pakutavad teenused koos kirjelduste ja näidetega.

###sendDocuments

###sendDocuments.v1
------

<pre>
Päringu nimi: dhl.sendDocuments.v1  
Sisendi keha: Struct  
        base64Binary - dokumendid  
        string - kaust  
Väljundi keha: base64Binary  
</pre>

Päring tuleb realiseerida vastavalt X-Tee dokumentatsioonis MIME manuseid sisaldavate teadete realiseerimise skeemile.
Element „dokumendid“ on base64 kodeeringus documentsArrayType tüüpi massiiv DVK-sse saadetavatest dokumentidest.
Element „kaust“ määrab ära kataloogitee, kuhu tuleb dokumendid paigutada. Element võib ka puududa, sellisel juhul on kataloogiks üldine juurkataloog „/”. Kui elemendiga „kaust” antud kausta ei eksisteeri DVK-s, siis luuakse see automaatselt.
Väljundi kehaks on base64 kodeeringus documentRefsArrayType tüüpi massiiv, mis sisaldab DVK poolt dokumentidele omistatud unikaalseid ID-e.  
Dokumentide saatmisel sendDocuments päringuga teostatakse DVK konteineri ning saadetavate XML, DDOC ja BDOC failide valideerimine. Täpsem info failide valideerimise kohta asub käesoleva dokumendi peatükis „[Edastatavate dokumentide valideerimine DVK serveris](#edastatavate-dokumentide-valideerimine-dvk-serveris)“.

####Näide

#####Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v1</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocuments>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <kaust/>
    </keha>
  </dhl:sendDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocumentsResponse>
    <paring>
      <dokumendid xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <kaust/>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:sendDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```


##### Päringu „dokumendid“ elemendi sisu
Elemendi „dokumendid“ sisu kodeerimata kujul on:
```xml
<dokument xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <metainfo/>
    <transport>
        <saatja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saatja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
    </transport>
    <ajalugu/>
    <metaxml>
        <p>Siin sees võib olla suvaline XML jada</p>
        <item>Mingeid piiraguid elementidele pole</item>
    </metaxml>
    <SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl.xsd" Id="D0" MimeType="text/xml" Size="3075" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl-aadress.xsd" Id="D1" MimeType="text/xml" Size="2679" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
    </SignedDoc>
</dokument>
```

##### Päringu vastuses „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on: `<dhl_id>54365435</dhl>`

Kui saadeti korraga mitu dokumenti, siis on elemendi „keha“ sisu kodeerimata kujul selline:

```xml
<dhl_id>54365435</dhl_id>
<dhl_id>54365436</dhl_id>
<dhl_id>54365437</dhl_id>
```

###sendDocuments.v2
------

Päringu sendDocuments versioon v2 erineb eelmisest versioonist selle poolest, et võimaldab dokumente DVK serverisse saata fragmenteeritud kujul.
<pre>
Päringu nimi: dhl.sendDocuments.v2
Sisendi keha: Struct
        base64Binary - dokumendid
        string - kaust
        date - sailitustahtaeg
        string - edastus_id
        integer - fragment_nr
        integer - fragmente_kokku
Väljundi keha: base64Binary
</pre>

Päring tuleb realiseerida vastavalt X-Tee dokumentatsioonis MIME manuseid sisaldavate teadete realiseerimise skeemile.
Element „dokumendid“ on base64 kodeeringus documentsArrayType tüüpi massiiv DVK-sse saadetavatest dokumentidest.

Element „kaust“ määrab ära kataloogitee, kuhu tuleb dokumendid paigutada. Element võib ka puududa, sellisel juhul on kataloogiks üldine juurkataloog „/”. Kui elemendiga „kaust” antud kausta ei eksisteeri DVK-s, siis luuakse see automaatselt.

Element „sailitustahtaeg“ määrab ära, kui kaua DVK server peaks saadetavat dokumenti säilitama, enne kui see kettaruumi vabastamiseks serverist maha kustutatakse.

Element „edastus\_id“ määrab edastussessiooni identifikaatori, kui dokumente saadetakse tükkhaaval. Tükkhaaval saatmisel loeb DVK server kõik sama „edastus\_id“ väärtusega saadetud andmed ühe ja sama dokumendi fragmentideks. Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragment\_nr“ määrab tükkhaaval saadetavate andmete puhul, mitmenda tükiga on antud juhul tegu (loendamine algab 0-st). Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragmente\_kokku“ määrab tükkhaaval saadetavate andmete puhul, mitmeks tükiks on saadetavad andmed jaotatud. Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Väljundi kehaks on base64 kodeeringus documentRefsArrayType tüüpi massiiv, mis sisaldab DVK poolt dokumentidele omistatud unikaalseid ID-e.

Dokumentide saatmisel sendDocuments päringuga teostatakse DVK konteineri ning saadetavate XML, DDOC ja BDOC failide valideerimine. Täpsem info failide valideerimise kohta asub käesoleva dokumendi peatükis „[Edastatavate dokumentide valideerimine DVK serveris](#)“.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v2</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocuments>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <kaust/>
      <sailitustahtaeg>2009-01-25T23:59:59</sailitustahtaeg>
      <edastus_id>123456789_1201</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmente_kokku>0</fragmente_kokku>
    </keha>
  </dhl:sendDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocumentsResponse>
    <paring>
      <dokumendid xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <kaust/>
      <sailitustahtaeg>2009-01-25T23:59:59</sailitustahtaeg>
      <edastus_id>123456789_1201</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmente_kokku>0</fragmente_kokku>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:sendDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```


##### Päringu „dokumendid“ elemendi sisu

Elemendi „dokumendid“ sisu kodeerimata kujul on:

```xml
<dokument xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <metainfo/>
    <transport>
        <saatja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saatja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
    </transport>
    <ajalugu/>
    <metaxml>
        <p>Siin sees võib olla suvaline XML jada</p>
        <item>Mingeid piiraguid elementidele pole</item>
    </metaxml>
    <SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl.xsd" Id="D0" MimeType="text/xml" Size="3075" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl-aadress.xsd" Id="D1" MimeType="text/xml" Size="2679" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
    </SignedDoc>
</dokument>
```

##### Päringu vastuses „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dhl_id>54365435</dhl_id>
```

Kui saadeti korraga mitu dokumenti, siis on elemendi „keha“ sisu kodeerimata kujul selline:

```xml
<dhl_id>54365435</dhl_id>
<dhl_id>54365436</dhl_id>
<dhl_id>54365437</dhl_id>
```

###sendDocuments.v3
------

Päring erineb versioonist 2 selle poolest, et kasutusele on võetud asutuse ja allüksuse lühinimetused.
Päring tuleb realiseerida vastavalt X-Tee dokumentatsioonis MIME manuseid sisaldavate teadete realiseerimise skeemile.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v2</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocuments>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <kaust/>
      <sailitustahtaeg>2009-01-25T23:59:59</sailitustahtaeg>
      <edastus_id>123456789_1201</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmente_kokku>0</fragmente_kokku>
    </keha>
  </dhl:sendDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:sendDocumentsResponse>
    <paring>
      <dokumendid xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <kaust/>
      <sailitustahtaeg>2009-01-25T23:59:59</sailitustahtaeg>
      <edastus_id>123456789_1201</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmente_kokku>0</fragmente_kokku>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:sendDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu „dokumendid“ elemendi sisu

```xml
<dokument xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl/2010/2">
    <metainfo/>
    <transport>
        <saatja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saatja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
    </transport>
    <ajalugu/>
    <metaxml>
        <p>Siin sees võib olla suvaline XML jada</p>
        <item>Mingeid piiraguid elementidele pole</item>
    </metaxml>
    <failid>
        <kokku>2</kokku>
        <fail>
            <jrknr>1</jrknr>
            <fail_pealkiri>DVK skeem</fail_pealkiri>
            <fail_suurus>3075</fail_suurus>
            <fail_tyyp>text/xml</fail_tyyp>
            <fail_nimi>dhl.xsd</fail_nimi>
            <zip_base64_sisu>
    PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt </zip_base64_sisu>
<pohi_dokument>true</pohi_dokument>
        </fail>
        <fail>
            <jrknr>2</jrknr>
            <fail_pealkiri>DVK skeem</fail_pealkiri>
            <fail_suurus>2679</fail_suurus>
            <fail_tyyp>text/xml</fail_tyyp>
            <fail_nimi>dhl-aadress.xsd</fail_nimi>
            <zip_base64_sisu>
    PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt </zip_base64_sisu>
        </fail>
    </failid>
</dokument>
```

##### Päringu vastuses „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:
```xml
<dhl_id>54365435</dhl_id>
```
Kui saadeti korraga mitu dokumenti, siis on elemendi „keha“ sisu kodeerimata kujul selline:
```xml
<dhl_id>54365435</dhl_id>
<dhl_id>54365436</dhl_id>
<dhl_id>54365437</dhl_id>
```


###sendDocuments.v4
------

Päring erineb versioonist 3 selle poolest, et teenus võtab vastu kapsli versiooni 2.1.

####Näide:

#####Päring
```xml
POST dhl/services/dhlHttpSoapPort HTTP/1.1
Accept-Encoding: gzip,deflate
Content-Type: multipart/related; type="text/xml"; start="<rootpart@soapui.org>"; boundary="----=_Part_0_316047069.1405334028041"
SOAPAction: ""
MIME-Version: 1.0
Content-Length: 19154

<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:dhl="http://localhost:8080/services/dhlHttpSoapPort"
xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">
   <soapenv:Header>
  <xtee:asutus xsi:type="xsd:string">87654321</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v4</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</soapenv:Header>
<soapenv:Body>
  <dhl:sendDocuments>
    <keha>
      <dokumendid href="cid:uus_kapsel_1.xml.gz.b64"/>
      <kaust/>
    </keha>
  </dhl:sendDocuments>
</soapenv:Body>
</soapenv:Envelope>
```

#####Päringu keha sisu, mis on base64 dekodeeritud ning seejärel Gzip'ist lahti pakitud:

```xml
<?xml version="1.0" encoding="utf-8"?>
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender>
      <OrganisationCode>87654321</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
    <DecRecipient>
      <OrganisationCode>87654321</OrganisationCode>
    </DecRecipient>
  </Transport>
  <Initiator>
    <InitiatorRecordOriginalIdentifier>213465</InitiatorRecordOriginalIdentifier>
    <InitiatorRecordDate>2012-11-11T19:18:03</InitiatorRecordDate>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>+3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace>Pääsukese KÜ</SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </Initiator>
  <RecordCreator>
    <Organisation>
      <Name>Majandus- ja Kommunikatsiooniministeerium</Name>
      <OrganisationCode>EE70003158</OrganisationCode>
      <StructuralUnit>Infoühiskonna teenuste arendamise osakond</StructuralUnit>
      <PositionTitle>nõunik</PositionTitle>
      <Residency>EE</Residency>
    </Organisation>
    <Person>
      <Name>Liivi Karpištšenko</Name>
      <GivenName>Liivi</GivenName>
      <Surname>Karpištšenko</Surname>
      <PersonalIdCode></PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>0</Adit>
      <Phone>6256342</Phone>
      <Email>info@mkm.ee</Email>
      <WebPage>www.mkm.ee</WebPage>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Kesklinna linnaosa</AdministrativeUnit>
        <SmallPlace></SmallPlace>
        <LandUnit></LandUnit>
        <Street>Harju tänav</Street>
        <HouseNumber>11</HouseNumber>
        <BuildingPartNumber>126</BuildingPartNumber>
        <PostalCode>15072</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Liivi Karpištšenko</Name>
      <GivenName>Liivi</GivenName>
      <Surname>Karpištšenko</Surname>
      <PersonalIdCode></PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>0</Adit>
      <Phone>6256342</Phone>
      <Email>info@mkm.ee</Email>
      <WebPage>www.mkm.ee</WebPage>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Kesklinna linnaosa</AdministrativeUnit>
        <SmallPlace></SmallPlace>
        <LandUnit></LandUnit>
        <Street>Harju tänav</Street>
        <HouseNumber>11</HouseNumber>
        <BuildingPartNumber>126</BuildingPartNumber>
        <PostalCode>15072</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <RecipientRecordGuid>25892e17-80f6-415f-9c65-7395632f0223</RecipientRecordGuid>
    <RecipientRecordOriginalIdentifier>1.3P-41</RecipientRecordOriginalIdentifier>
    <MessageForRecipient>Teadmiseks</MessageForRecipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>EE70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
    <Person>
      <Name>Kadi Krull</Name>
      <GivenName>Kadi</GivenName>
      <Surname>Krull</Surname>
      <Residency>EE</Residency>
    </Person>
  </Recipient>
  <Recipient>
    <RecipientRecordOriginalIdentifier>213465</RecipientRecordOriginalIdentifier>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>+3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace>Pääsukese KÜ</SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0211</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>12.1/125</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-20T09:45:55</RecordDateRegistered>
    <RecordTitle>Vastus kodaniku ettepanekule</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
    <RecordAbstract>Kodaniku ettepanek registreeritud...</RecordAbstract>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <SignatureMetadata>
    <SignatureType>Digitaalallkiri</SignatureType>
    <Signer>Juhan Parts</Signer>
    <Verified>allkiri on kehtiv</Verified>
    <SignatureVerificationDate>2012-11-20T12:12:12</SignatureVerificationDate>
  </SignatureMetadata>
  <File>
    <FileGuid>30891e17-66f4-468f-9c79-8315632f0314</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Vastus ettepanekule.ddoc</FileName>
    <FileSize>415998</FileSize>
    <ZipBase64Content>...</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
</DecContainer>
```

#####Päringu vastus:

```xml
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Content-Type: multipart/related; type="text/xml"; start="<5574F4BD89CBE8B76D6026DA6266F8AC>";   boundary="----=_Part_0_49658970.1405334024943"
Transfer-Encoding: chunked
Date: Mon, 14 Jul 2014 10:33:45 GMT


------=_Part_0_49658970.1405334024943
Content-Type: text/xml; charset=UTF-8
Content-Transfer-Encoding: binary
Content-Id: <5574F4BD89CBE8B76D6026DA6266F8AC>

<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                                 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                 xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">
    <soapenv:Header>
        <xtee:asutus xsi:type="xsd:string">87654321</xtee:asutus>
        <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
        <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
        <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
        <xtee:nimi xsi:type="xsd:string">dhl.sendDocuments.v4</xtee:nimi>
        <xtee:toimik xsi:type="xsd:string"/>
        <xtee:amet xsi:type="xsd:string"/>
    </soapenv:Header>
    <soapenv:Body>
        <sendDocumentsResponse xmlns="">
            <paring xmlns="">
                <dokumendid>F295F2F85CA72412D08F04165B813700</dokumendid>
                <kaust></kaust>
            </paring>
            <keha href="cid:14ABD2D6837F5F3FC8C201A39BB4AA62" xmlns=""/>
        </sendDocumentsResponse>
    </soapenv:Body>
</soapenv:Envelope>

------=_Part_0_49658970.1405334024943
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <14ABD2D6837F5F3FC8C201A39BB4AA62>
Content-Encoding: gzip

H4sIAAAAAAAAALPJTs1ItLNJyciJz0yxMzMxMrbRh3Js9MFyAK8AUnUiAAAA
------=_Part_0_49658970.1405334024943--
```

Vastuse keha sisu pärast base64 dekodeerimise ning Gzip'ist lahti
pakkimist:
```xml
<keha><dhl_id>6423</dhl_id></keha>
```

###getSendStatus

###getSendStatus.v1
------

<pre>
Päringu nimi: dhl.getSendStatus.v1  
Sisendi keha: base64Binary  
Väljundi keha: base64Binary  
</pre>

Sisendi kehaks on base64 kodeeringus documentRefsArrayType tüüpi massiiv, mis sisaldab DVK poolt dokumentidele omistatud unikaalseid ID-e, mille kohta saatmisinfot soovitakse saada.  
Väljundi kehaks on base64 kodeeringus massiiv, mille elemendid „item“ on struktuurid elementidega:

- dhl\_id – dokumendile DVK poolt omistatud unikaalne id
- edastus – null kuni mitu elementi, millest igaüks kirjeldab konkreetse edastuse infot (vt punkt „Edastatud dokumentide staatuse kontroll“)
- olek – dokumendi edastamise koondolek

Olekute täpsema kirjelduse leiad käesoleva dokumendi peatüki „Dokumentide logistika” alampeatükist „[Edastatud dokumentide staatuse kontroll](#Edastatud-dokumentide-staatuse-kontroll)”.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.getSendStatus.v1</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:getSendStatus>
    <keha href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
  </dhl:getSendStatus>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.getSendStatus.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:getSendStatusResponse>
    <paring xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:getSendStatusResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dhl_id>54365435</dhl_id>
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<item>
  <dhl_id>54365435</dhl_id>
  <edastus>
    <saaja>
      <regnr>12345678</regnr>
      <nimi>Saaja asutuse nimi</nimi>
      <osakona_kood></osakona_kood>
      <osakonna_nimi></osakonna_nimi>
      <isikukood>30101010001</isikukood>
      <epost>isik1@asutus1.ee</epost>
    </saaja>
    <saadud>2005-09-01T12:34:02</saadud>
    <meetod>xtee</meetod>
    <edastatud>2005-09-01T12:34:21</edastatud>
    <loetud>2005-09-01T12:35:11</loetud>
    <staatus>saadetud</staatus>
    <vastuvotja_staatus_id>10</vastuvotja_staatus_id>
    <fault>
      <faultcode>100</faultcode>
      <faultactor>CLIENT</faultactor>
      <faultstring>Veateade</faultstring>
      <faultdetail>Vea kirjeldus</faultdetail>
    </fault>
    <metaxml>
      <andmevali1>1. andmevälja väärtus</andmevali1>
      <andmevali2>2. andmevälja väärtus</andmevali2>
    </metaxml>
  </edastus>
  <edastus>
    <saaja>
      <regnr>87654321</regnr>
      <nimi>Teise saaja nimi</nimi>
      <osakona_kood></osakona_kood>
      <osakonna_nimi></osakonna_nimi>
      <isikukood>40101010001</isikukood>
      <epost>isik2@asutus2.ee</epost>
    </saaja>
    <saadud>2005-09-01T12:34:02</saadud>
    <meetod>xtee</meetod>
    <staatus>saatmisel</staatus>
    <metaxml>Teksti kujul metaandmed</metaxml>
  </edastus>
  <olek>saatmisel</olek>
</item>
```

###getSendStatus.v2
------

<pre>
Päringu nimi: dhl.getSendStatus.v2  
Sisendi keha: Struct  
        dokumendid  - base64Binary  
        taatuse\_ajalugu  - boolean  
Väljundi keha: base64Binary
</pre>

„dokumendid“ element sisendi kehas on base64 kodeeringus documentRefsArrayType tüüpi massiiv, mis sisaldab DVK poolt dokumentidele omistatud unikaalseid ID-e, mille kohta saatmisinfot soovitakse saada. „staatuse\_ajalugu“ parameetriga (true või false) saab määrata, kas päringu vastus sisaldab ka dokumentide staatuse ajalugu. Alternatiiv on kasutada dokumendi identifitseerimiseks dokumendi GUID-i.
Selleks kasutatakse päringu sisendiks massiivi kujul:

```xml
<item>
  <dokument_guid>25892e17-80f6-415f-9c65-7395632f0223</dokument_guid>
</item>
```

Väljundi kehaks on base64 kodeeringus massiiv, mille elemendid „item“ on struktuurid elementidega:

- dhl\_id – dokumendile DVK poolt omistatud unikaalne id
- edastus – null kuni mitu elementi, millest igaüks kirjeldab konkreetse edastuse infot (vt punkt „Edastatud dokumentide staatuse kontroll“)
- staatuse\_ajalugu – massiiv dokumendi kõigi seniste staatuse muudatuste andmetega adressaatide lõikes.
- olek – dokumendi edastamise koondolek

Olekute täpsema kirjelduse leiad käesoleva dokumendi peatüki „Dokumentide logistika” alampeatükist „[Edastatud dokumentide staatuse
kontroll](#Edastatud-dokumentide-staatuse-kontroll)”.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.getSendStatus.v2</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:getSendStatus>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <staatuse_ajalugu>true</staatuse_ajalugu>
  </dhl:getSendStatus>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.getSendStatus.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:getSendStatusResponse>
    <paring>
      <dokumendid>52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <staatuse_ajalugu>true</staatuse_ajalugu>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:getSendStatusResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu „dokumendid“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on (kasutatakse dokumendi DVK
unikaalset ID-d):

```xml
<item>
  <dhl_id>54365435</dhl_id>
</item>
```

Elemendi „keha“ sisu kodeerimata kujul on (kasutatakse dokumendi
GUID-i):

```xml
<item>
  <dokument_guid>25892e17-80f6-415f-9c65-7395632f0223</dokument_guid>
</item>
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<item>
  <dhl_id>54365435</dhl_id>
  <dokument_guid>25892e17-80f6-415f-9c65-7395632f0223</dokument_guid>
  <edastus>
    <saaja>
      <regnr>12345678</regnr>
      <nimi>Saaja asutuse nimi</nimi>
      <osakona_kood></osakona_kood>
      <osakonna_nimi></osakonna_nimi>
      <isikukood>30101010001</isikukood>
      <epost>isik1@asutus1.ee</epost>
    </saaja>
    <saadud>2005-09-01T12:34:02</saadud>
    <meetod>xtee</meetod>
    <edastatud>2005-09-01T12:34:21</edastatud>
    <loetud>2005-09-01T12:35:11</loetud>
    <staatus>saadetud</staatus>
    <vastuvotja_staatus_id>10</vastuvotja_staatus_id>
    <fault>
      <faultcode>100</faultcode>
      <faultactor>CLIENT</faultactor>
      <faultstring>Veateade</faultstring>
      <faultdetail>Vea kirjeldus</faultdetail>
    </fault>
    <metaxml>
      <andmevali1>1. andmevälja väärtus</andmevali1>
      <andmevali2>2. andmevälja väärtus</andmevali2>
    </metaxml>
  </edastus>
  <edastus>
    <saaja>
      <regnr>87654321</regnr>
      <nimi>Teise saaja nimi</nimi>
      <osakona_kood></osakona_kood>
      <osakonna_nimi></osakonna_nimi>
      <isikukood>40101010001</isikukood>
      <epost>isik2@asutus2.ee</epost>
    </saaja>
    <saadud>2005-09-01T12:34:02</saadud>
    <meetod>xtee</meetod>
    <staatus>saatmisel</staatus>
    <metaxml>Teksti kujul metaandmed</metaxml>
  </edastus>
  <staatuse_ajalugu>
    <staatus>
      <saaja>
        <regnr>12345678</regnr>
      </saaja>
      <staatuse_ajalugu_id>28</staatuse_ajalugu_id>
      <staatuse_muutmise_aeg>2005-09-01T12:34:02</staatuse_muutmise_aeg>
      <staatus>saatmisel</staatus>
      <vastuvotja_staatus_id>0</vastuvotja_staatus_id>
    </staatus>
    <staatus>
      <saaja>
        <regnr> 12345678</regnr>
      </saaja>
      <staatuse_ajalugu_id>29</staatuse_ajalugu_id>
      <staatuse_muutmise_aeg>2005-09-01T12:34:21</staatuse_muutmise_aeg>
      <staatus>saadetud</staatus>
      <vastuvotja_staatus_id>0</vastuvotja_staatus_id>
    </staatus>
    <staatus>
      <saaja>
        <regnr>87654321</regnr>
      </saaja>
      <staatuse_ajalugu_id>26</staatuse_ajalugu_id>
      <staatuse_muutmise_aeg>2005-09-01T12:34:02</staatuse_muutmise_aeg>
      <staatus>saatmisel</staatus>
      <vastuvotja_staatus_id>0</vastuvotja_staatus_id>
    </staatus>
  </staatuse_ajalugu>
  <olek>saatmisel</olek>
</item>
```

###receiveDocuments
Kui vastuvõtjale on saadetud 2.1 versioon kapslist ja asutuse toetatav kapsli versioon on 1.0, siis kapsel konverteeritakse kapsli versioonist
2.1 versiooni 1.0. **NB! Teistpidi konverteerimist ei eksisteeri.**

###receiveDocuments.v1
------

<pre>
Päringu nimi: dhl.receiveDocuments.v1  
Sisendi keha: Struct  
        integer -  arv  
        string [] - kaust  
Väljundi keha: base64Binary
</pre>

Element „arv“ määrab ära maksimaalse loetavate dokumentide arvu. Element võib puududa, sellisel juhul tagastatakse vaikimisi 10 dokumenti.

Element „kaust“ määrab ära, millisest DVK kaustast dokumendid loetakse. Element võib ka puududa (või olla väärtustamata), sellisel juhul tagastatakse vaikimisi dokumendid kõigist kaustadest. Kui elemendiga „kaust” on ette antud kaust, mida DVK-s ei eksisteeri, siis ei tagastata ühtegi dokumenti.

Väljund on base64 kodeeringus documentsArrayType tüüpi massiiv, mille iga element on tagastatud dokument.

####Näide

#####Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml
SOAPAction: ""

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v1</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocuments>
    <keha>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust/>
    </keha>
  </dhl:receiveDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päring mitmest kaustast vastuvõtmise korral

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml
SOAPAction: ""

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v1</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocuments>
    <keha>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust>/ARVED</kaust>
      <kaust>/EVORMID</kaust>
      <kaust>/PKD</kaust>
    </keha>
  </dhl:receiveDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocumentsResponse>
    <paring>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust/>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:receiveDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dokument>
  <metainfo>
    <dhl_id>54365435</dhl_id>
  </metainfo>
  <transport>
    <saatja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saatja>
    <saaja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saaja>
    <saaja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saaja>
  </transport>
  <ajalugu/>
  <metaxml>
    <p>Siin sees võib olla suvaline XML jada</p>
    <item>Mingeid piiraguid elementidele pole</item>
  </metaxml>
  <SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
    <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl.xsd" Id="D0" MimeType="text/xml" Size="3075" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
    <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl-aadress.xsd" Id="D1" MimeType="text/xml" Size="2679" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
  </SignedDoc>
</dokument>
```

###receiveDocuments.v2
------

Päringu receiveDocuments versioon v2 erineb eelmisest versioonist selle poolest, et võimaldab dokumente DVK serverist alla laadida fragmenteeritud kujul.

<pre>
Päringu nimi: dhl.receiveDocuments.v2  
Sisendi keha: Struct  
        integer  - arv  
        string[] - kaust  
        string - edastus_id  
        integer - fragment_nr  
        long - fragmendi_suurus_baitides  
Väljundi keha: base64Binary
</pre>

Element „arv“ määrab ära maksimaalse loetavate dokumentide arvu. Element võib puududa, sellisel juhul tagastatakse vaikimisi 10 dokumenti.

Element „kaust“ määrab ära, millisest DVK kaustast dokumendid loetakse. Element võib ka puududa (või olla väärtustamata), sellisel juhul tagastatakse vaikimisi dokumendid kõigist kaustadest. Kui elemendiga „kaust” on ette antud kaust, mida DVK-s ei eksisteeri, siis ei tagastata ühtegi dokumenti.

Element „edastus\_id“ määrab edastussessiooni identifikaatori, kui dokumente võetakse vastu tükkhaaval. Tükkhaaval saatmisel loeb DVK server kõik sama „edastus\_id“ väärtusega tükid ühe ja sama edastussessiooni andmete osadeks. Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragment\_nr“ määrab tükkhaaval vastuvõetavate andmete puhul, mitmendat tükki klientrakendus järgmisena soovib serverilt saada (loendamine algab 0-st). Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragmendi\_suurus\_baitides“ määrab tükkhaaval vastuvõetavate andmete puhul, kui suurteks tükkideks peaks server kliendile saadetavad andmed jaotama. Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Väljund on base64 kodeeringus documentsArrayType tüüpi massiiv, mille iga element on tagastatud dokument.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml
SOAPAction: ""

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v2</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocuments>
    <keha>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust/>
    </keha>
  </dhl:receiveDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v2</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocumentsResponse>
    <paring>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust/>
      <edastus_id>12345678_1234</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmendi_suurus_baiides>0</fragmendi_suurus_baitides>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:receiveDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dokument>
  <metainfo>
    <dhl_id>54365435</dhl_id>
  </metainfo>
  <transport>
    <saatja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saatja>
    <saaja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saaja>
    <saaja>
      <regnr>00000000</regnr>
      <nimi>String</nimi>
      <osakonna_kood>String</osakonna_kood>
      <osakonna_nimi>String</osakonna_nimi>
    </saaja>
  </transport>
  <ajalugu/>
  <metaxml>
    <p>Siin sees võib olla suvaline XML jada</p>
    <item>Mingeid piiraguid elementidele pole</item>
  </metaxml>
  <SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
    <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl.xsd" Id="D0" MimeType="text/xml" Size="3075" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
    <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl-aadress.xsd" Id="D1" MimeType="text/xml" Size="2679" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
  </SignedDoc>
</dokument>
```

###receiveDocuments.v3
------

Päringu receiveDocuments versioon v3 erineb eelmisest versioonist selle poolest, et võimaldab parameetritena ette anda allüksuse koodi ja ametikoha koodi. See võimaldab vastu võtta ainult konkreetsele allüksusele ja/või ametikohale adresseeritud dokumendid.

<pre>
Päringu nimi: dhl.receiveDocuments.v3
Sisendi keha: Struct
        integer - arv
        integer - allyksus
        integer - ametikoht
        string[] - kaust
        string - edastus_id
        integer - fragment_nr
        long - fragmendi_suurus_baitides
Väljundi keha: base64Binary
</pre>

Element „arv“ määrab ära maksimaalse loetavate dokumentide arvu. Element võib puududa, sellisel juhul tagastatakse vaikimisi 10 dokumenti.

Element „allyksus“ määrab ära, millisele allüksusele adresseeritud dokumente soovitakse vastu võtta. Parameetri väärtuseks saavad olla DVK-s registreeritud allüksuste ID koodid. Kui lisaks parameetrile „allyksus“ on väärtustatud ka parameeter „ametikoht“, siis võetakse vastu ainult need dokumendid, mis on adresseeritud ühtaegu etteantud allüksusele ja ametikohale.

Element „ametikoht“ määrab ära, millisele ametikohale adresseeritud dokumente soovitakse vastu võtta. Parameetri väärtuseks saavad olla DVK-s registreeritud ametikohtade ID koodid. Kui lisaks parameetrile „ametikoht“ on väärtustatud ka parameeter „allyksus“, siis võetakse vastu ainult need dokumendid, mis on adresseeritud ühtaegu etteantud allüksusele ja ametikohale.

Element „kaust“ määrab ära, millisest DVK kaustast dokumendid loetakse. Element võib ka puududa (või olla väärtustamata), sellisel juhul tagastatakse vaikimisi dokumendid kõigist kaustadest. Kui elemendiga „kaust” on ette antud kaust, mida DVK-s ei eksisteeri, siis ei tagastata ühtegi dokumenti.

Element „edastus\_id“ määrab edastussessiooni identifikaatori, kui dokumente võetakse vastu tükkhaaval. Tükkhaaval saatmisel loeb DVK server kõik sama „edastus\_id“ väärtusega tükid ühe ja sama edastussessiooni andmete osadeks. Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragment\_nr“ määrab tükkhaaval vastuvõetavate andmete puhul, mitmendat tükki klientrakendus järgmisena soovib serverilt saada (loendamine algab 0-st). Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragmendi\_suurus\_baitides“ määrab tükkhaaval vastuvõetavate andmete puhul, kui suurteks tükkideks peaks server kliendile saadetavad andmed jaotama. Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Väljund on base64 kodeeringus documentsArrayType tüüpi massiiv, mille iga element on tagastatud dokument.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml
SOAPAction: ""

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v3</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocuments>
    <keha>
      <arv xsi:type="xsd:integer">10</arv>
      <kaust/>
    </keha>
  </dhl:receiveDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v3</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocumentsResponse>
    <paring>
      <arv>10</arv>
      <allyksus>1</allyksus>
      <ametikoht>0</ametikoht>
      <kaust/>
      <edastus_id>12345678_1234</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmendi_suurus_baiides>0</fragmendi_suurus_baitides>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:receiveDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dokument>
    <metainfo>
        <dhl_id>54365435</dhl_id>
    </metainfo>
    <transport>
        <saatja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saatja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <allyksuse_kood>1</allyksuse_kood>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
    </transport>
    <ajalugu/>
    <metaxml>
        <p>Siin sees võib olla suvaline XML jada</p>
        <item>Mingeid piiraguid elementidele pole</item>
    </metaxml>
    <SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl.xsd" Id="D0" MimeType="text/xml" Size="3075" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
        <DataFile ContentType="EMBEDDED_BASE64" Filename="dhl-aadress.xsd" Id="D1" MimeType="text/xml" Size="2679" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt
</DataFile>
    </SignedDoc>
</dokument>
```

###receiveDocuments.v4
------

Päringu receiveDocuments versioon v4 erineb versioonist V3 selle poolest, et võimaldab allüskuse ja ametikoha parameetritena kasutada lühinimetusi (versioon V3 kasutas numbrilisi ID koode). See võimaldab vastu võtta ainult konkreetsele allüksusele ja/või ametikohale adresseeritud dokumente. Vastussõnumis olevad dokumendid kasutavad DVK konteineri versioon 2.

<pre>
Päringu nimi: dhl.receiveDocuments.v4
        Sisendi keha: Struct
        integer - arv
        string - allyksuse_lyhinimetus
        string - ametikoha_lyhinimetus
        string[] - kaust
        string - edastus_id
        integer - fragment_nr
        long - fragmendi_suurus_baitides
Väljundi keha: base64Binary
</pre>

Element „arv“ määrab ära maksimaalse loetavate dokumentide arvu. Element võib puududa, sellisel juhul tagastatakse vaikimisi 10 dokumenti.

Element „allyksuse\_lyhinimetus“ määrab ära, millisele allüksusele adresseeritud dokumente soovitakse vastu võtta. Parameetri väärtuseks saavad olla teksti kujul allüksuste lühinimetused. Kui lisaks parameetrile „allyksuse\_lyhinimetus“ on väärtustatud ka parameeter „ametikoha\_lyhinimetus“, siis võetakse vastu ainult need dokumendid, mis on adresseeritud ühtaegu etteantud allüksusele ja ametikohale.

Element „ametikoha\_lyhinimetus“ määrab ära, millisele ametikohale adresseeritud dokumente soovitakse vastu võtta. Parameetri väärtuseks saavad olla teksti kujul ametikohtade lühinimetused. Kui lisaks parameetrile „ametikoha\_lyhinimetus“ on väärtustatud ka parameeter „allyksuse\_lyhinimetus“, siis võetakse vastu ainult need dokumendid, mis on adresseeritud ühtaegu etteantud allüksusele ja ametikohale.

Element „kaust“ määrab ära, millisest DVK kaustast dokumendid loetakse. Element võib ka puududa (või olla väärtustamata), sellisel juhul tagastatakse vaikimisi dokumendid kõigist kaustadest. Kui elemendiga „kaust” on ette antud kaust, mida DVK-s ei eksisteeri, siis ei tagastata ühtegi dokumenti.

Element „edastus\_id“ määrab edastussessiooni identifikaatori, kui dokumente võetakse vastu tükkhaaval. Tükkhaaval saatmisel loeb DVK server kõik sama „edastus\_id“ väärtusega tükid ühe ja sama edastussessiooni andmete osadeks. Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragment\_nr“ määrab tükkhaaval vastuvõetavate andmete puhul, mitmendat tükki klientrakendus järgmisena soovib serverilt saada (loendamine algab 0-st). Kui andmeid ei soovita vastu võtta tükkhaaval, siis pole seda parameetrit vaja määrata.

Element „fragmendi\_suurus\_baitides“ määrab tükkhaaval vastuvõetavate andmete puhul, kui suurteks tükkideks peaks server kliendile saadetavad andmed jaotama. Kui andmeid ei saadeta tükkhaaval, siis pole seda parameetrit vaja määrata.

Väljund on base64 kodeeringus documentsArrayType tüüpi massiiv, mille iga element on tagastatud dokument.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml
SOAPAction: ""

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v4</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocuments>
    <keha>
      <arv>10</arv>
      <allyksuse_lyhinimetus>RMTP</allyksuse_lyhinimetus>
      <ametikoha_lyhinimetus>RAAMATUPIDAJA</ametikoha_lyhinimetus>
      <kaust/>
      <edastus_id>12345678_1234</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmendi_suurus_baiides>0</fragmendi_suurus_baitides>
    </keha>
  </dhl:receiveDocuments>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: multipart/related; type=text/xml;
    boundary="=_9d665408f43f4698f71029c2df2b834e"

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.receiveDocuments.v4</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:receiveDocumentsResponse>
    <paring>
      <arv>10</arv>
      <allyksuse_lyhinimetus>RMTP</allyksuse_lyhinimetus>
      <ametikoha_lyhinimetus>RAAMATUPIDAJA</ametikoha_lyhinimetus>
      <kaust/>
      <edastus_id>12345678_1234</edastus_id>
      <fragment_nr>-1</fragment_nr>
      <fragmendi_suurus_baiides>0</fragmendi_suurus_baitides>
    </paring>
    <keha href="cid:793340a8216da081f3d785bcc74c0f74"/>
  </dhl:receiveDocumentsResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_9d665408f43f4698f71029c2df2b834e
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<793340a8216da081f3d785bcc74c0f74>

VMO1ZWxpbmUgdGFsdiB2w7VpYiBzYWFidWRhIGhpbGplbSBrdWkgdGF2YWxpc2Vs
dC4K

--=_9d665408f43f4698f71029c2df2b834e
```

##### Päringu vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dokument>
    <metainfo>
        <dhl_id>54365435</dhl_id>
    </metainfo>
    <transport>
        <saatja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <allyksuse_lyhinimetus>String</allyksuse_lyhinimetus>
            <allüksuse_nimetus>String</allüksuse_nimetus>
        </saatja>
        <saaja>
            <regnr>00000000</regnr>
            <nimi>String</nimi>
            <allyksuse_lyhinimetus>String</allyksuse_lyhinimetus>
            <allüksuse_nimetus>String</allüksuse_nimetus>
        </saaja>
    </transport>
    <ajalugu/>
    <metaxml>
        <p>Siin sees võib olla suvaline XML jada</p>
        <item>Mingeid piiraguid elementidele pole</item>
    </metaxml>
    <failid>
        <kokku>2</kokku>
        <fail>
            <jrknr>1</jrknr>
            <fail_pealkiri>DVK skeem</fail_pealkiri>
            <fail_suurus>3075</fail_suurus>
            <fail_tyyp>text/xml</fail_tyyp>
            <fail_nimi>dhl.xsd</fail_nimi>
            <zip_base64_sisu>
    PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt </zip_base64_sisu>
<pohi_dokument>true</pohi_dokument>
        </fail>
        <fail>
            <jrknr>2</jrknr>
            <fail_pealkiri>DVK skeem</fail_pealkiri>
            <fail_suurus>2679</fail_suurus>
            <fail_tyyp>text/xml</fail_tyyp>
            <fail_nimi>dhl-aadress.xsd</fail_nimi>
            <zip_base64_sisu>
    PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pg0KPCEt </zip_base64_sisu>
<pohi_dokument>true</pohi_dokument>
        </fail>
    </failid>
</dokument>
```

###markDocumentsReceived

###markDocumentsReceived.v1
------

<pre>
Päringu nimi: dhl.markDocumentsReceived.v1
Sisendi keha: Struct
        base64Binary - dokumendid
        string - kaust
Väljundi keha: string
</pre>

Element „dokumendid“ on base64 kodeeringus documentRefsArrayType tüüpi massiiv, mille iga element sisaldab loetud dokumendile DVK poolt omistatud unikaalset ID-d. Kõik massiiviga antud dokumendid parameetriga „kaust” näidatud kaustast märgitakse kättesaaduks.

Element „kaust“ väärtuseks saab olla DVK kausta täispikk nimi. Vaikimisi märgitakse dokumendid kättesaaduks dokumendi ID põhjal sõltumata sellest, millises kaustas ükski dokument asub.

Päring tagastab väljundi kehaks stringi sisuga „OK“.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v1</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl: markDocumentsReceived>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <kaust/>
    </keha>
  </dhl: markDocumentsReceived>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: text/xml

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v1</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:markDocumentsReceivedResponse>
    <paring>
      <dokumendid xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <kaust/>
    </paring>
    <keha xsi:type="xsd:string">OK</keha>
  </dhl: markDocumentsReceivedResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<dhl_id>54365435</dhl_id>
```

###markDocumentsReceived.v2
------

Element „dokumendid“ on base64 kodeeringus massiiv, mille iga element „item” on alljärgneva struktuuriga:

-   „dhl\_id” element sisaldab loetud dokumendi DVK ID-d.
-   „vastuvotja\_staatus\_id” element sisaldab vastuvõtja poolel dokumendile omistatud staatuse identifikaatorit.
-   „fault” element sisaldab andmeid vastuvõtja poolel ilmnenud
    vea kohta.

    -   „faultcode” element sisaldab vea koodi.
    -   „faultactor” element sisaldab infot vea ilmnemise asukoha kohta (näit. kas viga ilmnes serveri või kliendi poolel)
    -   „faultstring” element sisaldab veateadet.
    -   „faultdetail” element sisaldab pikemat vea kirjeldust.
-   „metaxml” element sisaldab vaba struktuuriga XML- või tekstiandmed vastuvõetud dokumenti puudutavate andmete saatmiseks dokumendi saatjale.
-   „staatuse\_muutmise\_aeg“ sisaldab staatuse muutmise aega. Tegemist on mittekohustusliku parameetriga, mis võimaldab vajadusel täpsustada, et staatuse muutumise kuupäev oli päringu sooritamise hetkest varasem aeg. Kui antud parameetri väärtuseks anda tulevikus olev kuupäev, siis asendab DVK server selle päringu käivitamise ajaga.

Kõik massiiviga antud dokumendid parameetriga „kaust” näidatud kaustast märgitakse kättesaaduks.

Element „kaust“ väärtuseks saab olla DVK kausta täispikk nimi. Vaikimisi märgitakse dokumendid kättesaaduks dokumendi ID põhjal sõltumata sellest, millises kaustas ükski dokument asub.

Päring tagastab väljundi kehaks stringi sisuga „OK“.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v2</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl: markDocumentsReceived>
    <keha>
      <dokumendid href="cid:b8fdc418df27ba3095a2d21b7be6d802"/>
      <kaust/>
    </keha>
  </dhl: markDocumentsReceived>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Disposition:php5hmCiX
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:base64
Content-Encoding: gzip
Content-ID:<b8fdc418df27ba3095a2d21b7be6d802>

a29ybmkJa3cNCmtvcnNpa2EJY28NCmtyZWVrYQllbA0Ka3JpaQn1ZA0Ka3Vt9Wtp
…
dg0KbmVwYWxpCW5lDQpuaXZoaQnkdA0KbmphbmT+YQlueQ0Kbm9nYWkJ9ncNCg==
--=_b5a8d09eeeb161be29def84633d6f6fc
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: text/xml

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id
xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v2</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:markDocumentsReceivedResponse>
    <paring>
      <dokumendid xsi:type="xsd:string">52ed0ffbf27fc34759dce05d0e7bed2302876cec</dokumendid>
      <kaust/>
    </paring>
    <keha xsi:type="xsd:string">OK</keha>
  </dhl: markDocumentsReceivedResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<item>
    <dhl_id>54365435</dhl_id>
    <vastuvotja_staatus_id>10</vastuvotja_staatus_id>
    <fault>
        <faultcode>100</faultcode>
        <faultactor>CLIENT</faultactor>
        <faultstring>Veateade</faultstring>
        <faultdetail>vea kirjeldus</faultdetail>
    </fault>
    <metaxml>
        <andmed_1>väärtus 1</andmed_1>
        <andmed_2>väärtus 2</andmed_2>
        <andmed_n>väärtus n</andmed_n>
    </metaxml>
    <staatuse_muutmise_aeg>2005-09-01T12:35:11</staatuse_muutmise_aeg>
</item>
<item>
    <dhl_id>54365436</dhl_id>
    <vastuvotja_staatus_id>7</vastuvotja_staatus_id>
    <staatuse_muutmise_aeg>2005-09-02T14:15:00</staatuse_muutmise_aeg>
</item>
<item>
    <dhl_id>54365437</dhl_id>
</item>
```

###markDocumentsReceived.v3
------

Päringu markDogumentsReceived versioon v3 eelneb varasematest versioonidest selle poolest, et elemendi „dokumendid“ sisu asub nüüd SOAP sõnumi kehas (varasemates versioonides asus base64 kodeeritud kujul SOAP sõnumi manuses). Samuti on lisatud võimalus märkida dokumendid vastuvõetuks kasutades dokumendi GUID tüüpi identifikaatorit (sellisel juhul asendab element &lt;dokument\_guid&gt; elemendi &lt;dhl\_id&gt;).

Element „dokumendid“ on SOAP massiiv, mille iga element „item” on alljärgneva struktuuriga:

-   „dhl\_id” element sisaldab loetud dokumendi DVK ID-d.
-   „vastuvotja\_staatus\_id” element sisaldab vastuvõtja poolel dokumendile omistatud staatuse identifikaatorit.
-   „fault” element sisaldab andmeid vastuvõtja poolel ilmnenud
    vea kohta.

    -   „faultcode” element sisaldab vea koodi.
    -   „faultactor” element sisaldab infot vea ilmnemise asukoha kohta (näit. kas viga ilmnes serveri või kliendi poolel)
    -   „faultstring” element sisaldab veateadet.
    -   „faultdetail” element sisaldab pikemat vea kirjeldust.
-   „metaxml” element sisaldab vaba struktuuriga XML- või tekstiandmed vastuvõetud dokumenti puudutavate andmete saatmiseks dokumendi saatjale.
-   „staatuse\_muutmise\_aeg“ sisaldab staatuse muutmise aega. Tegemist on mittekohustusliku parameetriga, mis võimaldab vajadusel täpsustada, et staatuse muutumise kuupäev oli päringu sooritamise hetkest varasem aeg. Kui antud parameetri väärtuseks anda tulevikus olev kuupäev, siis asendab DVK server selle päringu käivitamise ajaga.

Kõik massiiviga antud dokumendid parameetriga „kaust” näidatud kaustast märgitakse kättesaaduks.

Element „kaust“ väärtuseks saab olla DVK kausta täispikk nimi. Vaikimisi märgitakse dokumendid kättesaaduks dokumendi ID põhjal sõltumata sellest, millises kaustas ükski dokument asub.

Päring tagastab väljundi kehaks stringi sisuga „OK“.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; type=text/xml;
    boundary="=_b5a8d09eeeb161be29def84633d6f6fc"
SOAPAction: ""

--=_b5a8d09eeeb161be29def84633d6f6fc
Content-Type:text/xml; charset="UTF-8"
Content-Transfer-Encoding:8bit

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
  xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
  <xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
  <xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
  <xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
  <xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
  <xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v3</xtee:nimi>
  <xtee:toimik xsi:type="xsd:string"></xtee:toimik>
  <xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:markDocumentsReceived>
    <keha>
      <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>54365435</dhl_id>
          <vastuvotja_staatus_id>10</vastuvotja_staatus_id>
          <fault>
            <faultcode>100</faultcode>
            <faultactor>CLIENT</faultactor>
            <faultstring>Veateade</faultstring>
            <faultdetail>vea kirjeldus</faultdetail>
          </fault>
          <metaxml>
            <andmed_1>väärtus 1</andmed_1>
            <andmed_2>väärtus 2</andmed_2>
            <andmed_n>väärtus n</andmed_n>
          </metaxml>
          <staatuse_muutmise_aeg>2005-09-01T12:35:11</staatuse_muutmise_aeg>
        </item>
        <item>
          <dhl_id>54365436</dhl_id>
          <vastuvotja_staatus_id>7</vastuvotja_staatus_id>
          <staatuse_muutmise_aeg>2005-09-02T14:15:00</staatuse_muutmise_aeg>
        </item>
        <item>
          <dhl_id>54365437</dhl_id>
        </item>
      </dokumendid>
      <kaust/>
    </keha>
  </dhl:markDocumentsReceived>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
Content-Type: text/xml

<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAPENV="
  http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<SOAP-ENV:Header>
<xtee:asutus xsi:type="xsd:string">12345678</xtee:asutus>
<xtee:andmekogu xsi:type="xsd:string">dhl</xtee:andmekogu>
<xtee:isikukood xsi:type="xsd:string">EE12345678901</xtee:isikukood>
<xtee:id xsi:type="xsd:string">6cae248568b3db7e97ff784673a4d38c5906bee0</xtee:id>
<xtee:nimi xsi:type="xsd:string">dhl.markDocumentsReceived.v2</xtee:nimi>
<xtee:toimik xsi:type="xsd:string"></xtee:toimik>
<xtee:amet xsi:type="xsd:string"></xtee:amet>
</SOAP-ENV:Header>
<SOAP-ENV:Body>
  <dhl:markDocumentsReceivedResponse>
    <paring>
      <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>54365435</dhl_id>
          <vastuvotja_staatus_id>10</vastuvotja_staatus_id>
          <fault>
            <faultcode>100</faultcode>
            <faultactor>CLIENT</faultactor>
            <faultstring>Veateade</faultstring>
            <faultdetail>vea kirjeldus</faultdetail>
          </fault>
          <metaxml>
            <andmed_1>väärtus 1</andmed_1>
            <andmed_2>väärtus 2</andmed_2>
            <andmed_n>väärtus n</andmed_n>
          </metaxml>
          <staatuse_muutmise_aeg>2005-09-01T12:35:11</staatuse_muutmise_aeg>
        </item>
        <item>
          <dhl_id>54365436</dhl_id>
          <vastuvotja_staatus_id>7</vastuvotja_staatus_id>
          <staatuse_muutmise_aeg>2005-09-02T14:15:00</staatuse_muutmise_aeg>
        </item>
        <item>
          <dhl_id>54365437</dhl_id>
        </item>
      </dokumendid>
      <kaust/>
    </paring>
    <keha xsi:type="xsd:string">OK</keha>
  </dhl:markDocumentsReceivedResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

###getSendingOptions

###getSendingOptions.v1
------

<pre>
Päringu nimi: dhl.getSendingOptions.v1
Sisendi keha: stringide massiiv
Väljundi keha: massiiv andmetüübist „asutus”:
        regnr - string
        nimi - string
        saatmine - massiiv
        saatmisviis - string   (väärtused: dhl | dhl_otse)
        ks_asutuse_regnr - string    (kõrgemalseisva asutuse registrikood)
</pre>
Päring annab teada, kas ja kui siis millisel moel on asutused võimelised DVK-d kasutama. Ilma sisendparameetriteta käivitamise korral tagastab päring nimekirja kõigist DVK-ga liitunud asutustest. Kui aga päringule anda sisendparameetriks nimekiri asutuste registrikoodidest, tagastab päring info nimekirjas sisaldunud asutuste võimekuse kohta DVK kaudu andmeid vahetada.

Antud päringu puhul esitatakse nii sisend- kui väljundandmed pakkimata ja kodeerimata kujul.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getSendingOptions>
      <keha>
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
      </keha>
    </dhl:getSendingOptions>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">

  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>

  <soapenv:Body>
    <dhl:getSendingOptionsResponse>
      <paring xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[3]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
      </paring>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <asutus>
          <regnr>12345678</regnr>
          <nimi>ASUTUS 1</nimi>
          <saatmine>
            <saatmisviis>dhl</saatmisviis>
          </saatmine>
          <ks_asutuse_regnr/>
        </asutus>
        <asutus>
          <regnr>23456789</regnr>
          <nimi>ASUTUS 2</nimi>
          <saatmine>
            <saatmisviis>dhl</saatmisviis>
            <saatmisviis>dhl_otse</saatmisviis>
          </saatmine>
          <ks_asutuse_regnr>12345678</ks_asutuse_regnr>
        </asutus>
        <asutus>
          <regnr>34567890</regnr>
          <nimi/>
          <saatmine/>
          <ks_asutuse_regnr/>
        </asutus>
      </keha>
    </dhl:getSendingOptionsResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###getSendingOptions.v2  
------

<pre>
Päringu nimi: dhl.getSendingOptions.v2

Sisendi keha: andmestruktuur:

        asutused  - stringide massiiv
        vahetatud_dokumente_vahemalt - number
        vahetatud_dokumente_kuni - number
        vastuvotmata_dokumente_ootel - tõeväärtus (jah/ei)

Väljundi keha: massiiv andmetüübist „asutus”:

        regnr - string
        nimi - string
        saatmine - massiiv
                saatmisviis - string    (väärtused: dhl | dhl_otse)
        ks_asutuse_regnr - string    (kõrgemalseisva asutuse registrikood)
</pre>

Päring annab teada, kas ja kui siis millisel moel on asutused võimelised DVK-d kasutama. Ilma sisendparameetriteta käivitamise korral tagastab päring nimekirja kõigist DVK-ga liitunud asutustest.

Päringu parameetrite otstarve on järgmine:

-   **asutused**\
    Võimaldab ette anda nimekirja asutuste registrikoodidest. DVK tagastab vastuses info ainult nimekirjas loetletud asutuste DVK-võimekuse kohta. Käesoleva parameetriga etteantud nimekiri toimib täiendava filtrina ka järgmiste parameetrite puhul.
-   **vahetatud\_dokumente\_vahemalt**\ DVK tagastab nimekirja asutustest, mis on vahetanud vähemalt etteantud arvu (kaasa arvatud) dokumente.
-   **vahetatud\_dokumente\_kuni**\ DVK tagastab nimekirja asutustest, mis on vahetanud kuni etteantud arvu (kaasa arvatud) dokumente.
-   **vastuvotmata\_dokumente\_ootel**\ Kui antud parameetri väärtus on true, siis tagastab DVK nimekirja asutustest, millel on hetkel allalaadimist ootavaid dokumente.

Antud päringu puhul esitatakse nii sisend- kui väljundandmed pakkimata ja kodeerimata kujul.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getSendingOptions>
      <keha>
        <asutused>
          <asutus>12345678</asutus>
          <asutus>23456789</asutus>
          <asutus>34567890</asutus>
        </asutused>
        <vahetatud_dokumente_vahemalt>0</vahetatud_dokumente_vahemalt>
        <vahetatud_dokumente_kuni>1000</vahetatud_dokumente_kuni>
        <vastuvotmata_dokumente_ootel>true</vastuvotmata_dokumente_ootel>
      </keha>
    </dhl:getSendingOptions>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">

  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>

  <soapenv:Body>
    <dhl:getSendingOptionsResponse>
      <paring xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[3]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
      </paring>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <asutus>
          <regnr>12345678</regnr>
          <nimi>ASUTUS 1</nimi>
          <saatmine>
            <saatmisviis>dhl</saatmisviis>
          </saatmine>
          <ks_asutuse_regnr/>
        </asutus>
        <asutus>
          <regnr>23456789</regnr>
          <nimi>ASUTUS 2</nimi>
          <saatmine>
            <saatmisviis>dhl</saatmisviis>
            <saatmisviis>dhl_otse</saatmisviis>
          </saatmine>
          <ks_asutuse_regnr>12345678</ks_asutuse_regnr>
        </asutus>
        <asutus>
          <regnr>34567890</regnr>
          <nimi/>
          <saatmine/>
          <ks_asutuse_regnr/>
        </asutus>
      </keha>
    </dhl:getSendingOptionsResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###getSendingOptions.v3
------

<pre>
Päringu nimi: dhl.getSendingOptions.v3

Sisendi keha: base64Binary
Sisendi keha kodeerimata kujul:

    keha - Struct
        asutused - massiiv
            asutus - string
        allyksused - massiiv
            asutuse_kood - string
            lyhinimetus - string
        ametikohad - massiiv
            asutuse_kood - string
            lyhinimetus - string
        vahetatud_dokumente_vahemalt - number
        vahetatud_dokumente_kuni - number
        vastuvotmata_dokumente_ootel - tõeväärtus (jah/ei)

Väljundi keha:base64Binary
Väljundi keha kodeerimata kujul:

    keha - Struct
        asutused - massiiv
            asutus - Struct
                regnr - string
                nimi - string
                saatmine - massiiv
                saatmisviis - string    (väärtused: dhl | dhl_otse)
                ks_asutuse_regnr - string    (kõrgemalseisva asutuse registrikood)
        allyksused - massiiv
            allyksus - Struct
                kood - string
                nimetus - string
                asutuse_kood - string
                lyhinimetus - string
                ks_allyksuse_lyhinimetus - string
        ametikohad - massiiv
            ametikoht - Struct
                kood - string
                nimetus - string
                asutuse_kood - string
                lyhinimetus - string
                ks_allyksuse_lyhinimetus -  string
</pre>

Päring annab teada, kas ja kui siis millisel moel on asutused võimelised DVK-d kasutama. Ilma sisendparameetriteta käivitamise korral tagastab päring nimekirja kõigist DVK-ga liitunud asutustest.

Päringu parameetrite otstarve on järgmine:

-   **asutused**\
    Võimaldab ette anda nimekirja asutuste registrikoodidest. DVK tagastab vastuses info ainult nimekirjas loetletud asutuste DVK-võimekuse kohta. Käesoleva parameetriga etteantud nimekiri toimib täiendava filtrina ka parameetrite „vahetatud\_dokumente\_vahemalt“, „vahetatud\_dokumente\_kuni“ ja „vastuvotmata\_dokumente\_ootel“ puhul.
-   **allyksused**\
    Võimaldab ette anda nimekirja asutuste allüksustest. Allüksuste nimekiri esitatakse asutuse registrikoodi ja allüksuse lühinime paaridena. DVK tagastab vastuses info ainult nimekirjas loetletud allüksuste kohta. Käesoleva parameetriga etteantud nimekiri toimib täiendava filtrina ka parameetrite „vahetatud\_dokumente\_vahemalt“, „vahetatud\_dokumente\_kuni“ ja „vastuvotmata\_dokumente\_ootel“ puhul.
-   **ametikohad**\
    Võimaldab ette anda nimekirja asutuste ametikohtadest. Ametikohtade nimekiri esitatakse asutuse registrikoodi ja ametikoha lühinime paaridena. DVK tagastab vastuses info ainult nimekirjas loetletud ametikohtade kohta. Käesoleva parameetriga etteantud nimekiri toimib täiendava filtrina ka parameetrite „vahetatud\_dokumente\_vahemalt“, „vahetatud\_dokumente\_kuni“ ja „vastuvotmata\_dokumente\_ootel“ puhul.
-   **vahetatud\_dokumente\_vahemalt**\
    DVK tagastab nimekirja asutustest, allüksustest ja ametikohtadest, mis on vahetanud vähemalt etteantud arvu (kaasa arvatud) dokumente.
-   **vahetatud\_dokumente\_kuni**\
    DVK tagastab nimekirja asutustest, allüksustest ja ametikohtadest, mis on vahetanud kuni etteantud arvu (kaasa arvatud) dokumente.
-   **vastuvotmata\_dokumente\_ootel**\
    Kui antud parameetri väärtus on true, siis tagastab DVK nimekirja asutustest, allüksustest ja ametikohtadest, millel on hetkel allalaadimist ootavaid dokumente.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v3</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getSendingOptions>
      <keha href="cid:1266238098953"/>
    </dhl:getSendingOptions>
  </env:Body>
</env:Envelope>

------=_Part_0_32961147.1266238098984
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <1266238098953>
Content-Encoding: gzip

H4sIAAAAAAAAAH2PSwrDMAxEj2T670L4BoVSujcCC2psR8WWArl9mpAEl0J3w/DmCcEbC2YiKcFb6LGK9iw
...
ZDbzrTXjHtuyN3z7yv/AAAAA==
------=_Part_0_32961147.1266238098984—
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.getSendingOptions.v3</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:getSendingOptionsResponse>
      <paring>7EC4A81438DC484DE15A2DD2D371323B</paring>
      <keha href="cid:514E5DB49902EC1EC1BCBA442FF37A02"/>
    </dhl:getSendingOptionsResponse>
  </soapenv:Body>
</soapenv:Envelope>

------=_Part_2_33268061.1266238099109
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <514E5DB49902EC1EC1BCBA442FF37A02>
Content-Encoding: gzip

H4sIAAAAAAAAAG2P3QrCMAyFHyk4fy9CYaAX4oWCD1AKLa6s68ayCXt7287OVr1qzslp8gUFjcNISjL8rhj
...
W9+AXNEgoqqAQAA
------=_Part_2_33268061.1266238099109--
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<keha>
    <asutused>
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
    </asutused>
    <allyksused>
        <allyksus>
            <asutuse_kood>12345678</asutuse_kood>
            <lyhinimetus>RMTP</lyhinimetus>
        </allyksus>
        <allyksus>
            <asutuse_kood>23456789</asutuse_kood>
            <lyhinimetus>DH</lyhinimetus>
        </allyksus>
        <allyksus>
            <asutuse_kood>23456789</asutuse_kood>
            <lyhinimetus>YLD</lyhinimetus>
        </allyksus>
    </allyksused>
    <ametikohad>
        <ametikoht>
            <asutuse_kood>12345678</asutuse_kood>
            <lyhinimetus>PEARAAMAT</lyhinimetus>
        </ametikoht>
        <ametikoht>
            <asutuse_kood>12345678</asutuse_kood>
            <lyhinimetus>RAAMATUPIDAJA</lyhinimetus>
        </ametikoht>
    </ametikohad>
    <vahetatud_dokumente_vahemalt>0</vahetatud_dokumente_vahemalt>
    <vahetatud_dokumente_kuni>1000</vahetatud_dokumente_kuni>
    <vastuvotmata_dokumente_ootel>true</vastuvotmata_dokumente_ootel>
</keha>
```

##### Vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<keha>
    <asutused>
        <asutus>
            <regnr>12345678</regnr>
            <nimi>ASUTUS 1</nimi>
            <saatmine>
                <saatmisviis>dhl</saatmisviis>
            </saatmine>
            <ks_asutuse_regnr/>
        </asutus>
        <asutus>
            <regnr>23456789</regnr>
            <nimi>ASUTUS 2</nimi>
            <saatmine>
                <saatmisviis>dhl</saatmisviis>
                <saatmisviis>dhl_otse</saatmisviis>
            </saatmine>
            <ks_asutuse_regnr>12345678</ks_asutuse_regnr>
        </asutus>
        <asutus>
            <regnr>34567890</regnr>
            <nimi/>
            <saatmine/>
            <ks_asutuse_regnr/>
        </asutus>
    </asutused>
    <allyksused>
        <allyksus>
            <kood>47</kood>
            <nimetus>Raamatupidamine</nimetus>
            <asutuse_kood>12345678</asutuse_kood>
            <lyhinimetus>RMTP</lyhinimetus>
            <ks_allyksuse_lyhinimetus>YLD</ks_allyksuse_lyhinimetus>
        </allyksus>
        <allyksus>
            <kood>17</kood>
            <nimetus>Üldosakond</nimetus>
            <asutuse_kood>23456789</asutuse_kood>
            <lyhinimetus>YLD</lyhinimetus>
            <ks_allyksuse_lyhinimetus/>
        </allyksus>
    </allyksused>
    <ametikohad>
        <ametikoht>
            <kood>92</kood>
            <nimetus>Raamatupidaja</nimetus>
            <asutuse_kood>12345678</asutuse_kood>
            <lyhinimetus>RAAMATUPIDAJA</lyhinimetus>
            <ks_allyksuse_lyhinimetus>RMTP</ks_allyksuse_lyhinimetus>
        </ametikoht>
    </ametikohad>
</keha>
```

###changeOrganizationData
------

<pre>
Päringu nimi: dhl.changeOrganizationData.v1

Sisendi keha: Struct:

        string registrikood
        string endine_registrikood
        string korgemalseisva_asutuse_registrikood
        string nimi
        string nime_lyhend
        string liik1
        string liik2
        string tegevusala
        string tegevuspiirkond
        string maakond
        string asukoht
        string aadress
        string postikood
        string telefon
        string faks
        string e_post
        string www
        string logo
        date asutamise_kuupaev
        string moodustamise_akti_nimi
        string moodustamise_akti_number
        date moodustamise_akti_kuupaev
        string pohimaaruse_akti_nimi
        string pohimaaruse_akti_number
        date pohimaaruse_kinnitamise_kuupaev
        date pohimaaruse_kande_kuupaev
        string parameetrid
        boolean dvk_saatmine
        boolean dvk_otse_saatmine
        string toetatav_dvk_versioon
        string dokumendihaldussysteemi_nimetus

Väljundi keha: string
</pre>

Päringuga saab uuendada DVK serveri asutuste registris salvestatud andmeid asutuse kohta. Päringuga saab uuendada ainult selle asutuse andmeid, mille nimel päring käivitati (s.t. mille registrikood oli märgitud X-Tee päringu päistesse).

Kui andmete uuendamine õnnestub, siis tagastab päring vastussõnumi kehas väärtuse „OK“

Antud päringu puhul esitatakse nii sisend- kui väljundandmed pakkimata ja kodeerimata kujul.

####Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.changeOrganizationData.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:changeOrganizationData>
      <keha>
        <registrikood>12345678</registrikood>
        <endine_registrikood>12345</endine_registrikood>
        <korgemalseisva_asutuse_registrikood>12322332 </korgemalseisva_asutuse_registrikood>
        <nimi>Asutus AS</nimi>
        <nime_lyhend>AAS</nime_lyhend>
        <liik1>L1</liik1>
        <liik2>L2</liik2>
        <tegevusala>Kaubandus</tegevusala>
        <tegevuspiirkond>Tallinn</tegevuspiirkond>
        <maakond>Harjumaa</maakond>
        <asukoht>Tallinn</asukoht>
        <aadress>Akadeemia tee 21</aadress>
        <postikood>12618</postikood>
        <telefon>6543210</telefon>
        <faks>6543211</faks>
        <e_post>info@asutus.ee</e_post>
        <www>http://www.asutus.ee</www>
        <logo/>
        <asutamise_kuupaev>2008-01-11</asutamise_kuupaev>
        <moodustamise_akti_nimi>Moodustamise akt</moodustamise_akti_nimi>
        <moodustamise_akti_number>1A2</moodustamise_akti_number>
        <moodustamise_akti_kuupaev>2008-02-01</moodustamise_akti_kuupaev>
        <pohimaaruse_akti_nimi>Põhimäärus</pohimaaruse_akti_nimi>
        <pohimaaruse_akti_number>2A3</pohimaaruse_akti_number>
        <pohimaaruse_kinnitamise_kuupaev>2008-03-01 </pohimaaruse_kinnitamise_kuupaev>
        <pohimaaruse_kande_kuupaev>2008-03-05</pohimaaruse_kande_kuupaev>
        <parameetrid>Parameetrid 123</parameetrid>
        <dvk_saatmine>1</dvk_saatmine>
        <dvk_otse_saatmine>0</dvk_otse_saatmine>
        <toetatav_dvk_versioon>1.5</toetatav_dvk_versioon>
        <dokumendihaldussysteemi_nimetus>SuperDoc 2000 </dokumendihaldussysteemi_nimetus>
      </keha>
    </dhl:changeOrganizationData>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.changeOrganizationData.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:changeOrganizationDataResponse>
      <paring xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[3]">
        <registrikood>12345678</registrikood>
        <endine_registrikood>12345</endine_registrikood>
        <korgemalseisva_asutuse_registrikood>12322332 </korgemalseisva_asutuse_registrikood>
        <nimi>Asutus AS</nimi>
        <nime_lyhend>AAS</nime_lyhend>
        <liik1>L1</liik1>
        <liik2>L2</liik2>
        <tegevusala>Kaubandus</tegevusala>
        <tegevuspiirkond>Tallinn</tegevuspiirkond>
        <maakond>Harjumaa</maakond>
        <asukoht>Tallinn</asukoht>
        <aadress>Akadeemia tee 21</aadress>
        <postikood>12618</postikood>
        <telefon>6543210</telefon>
        <faks>6543211</faks>
        <e_post>info@asutus.ee</e_post>
        <www>http://www.asutus.ee</www>
        <logo/>
        <asutamise_kuupaev>2008-01-11</asutamise_kuupaev>
        <moodustamise_akti_nimi>Moodustamise akt</moodustamise_akti_nimi>
        <moodustamise_akti_number>1A2</moodustamise_akti_number>
        <moodustamise_akti_kuupaev>2008-02-01</moodustamise_akti_kuupaev>
        <pohimaaruse_akti_nimi>Põhimäärus</pohimaaruse_akti_nimi>
        <pohimaaruse_akti_number>2A3</pohimaaruse_akti_number>
        <pohimaaruse_kinnitamise_kuupaev>2008-03-01 </pohimaaruse_kinnitamise_kuupaev>
        <pohimaaruse_kande_kuupaev>2008-03-05</pohimaaruse_kande_kuupaev>
        <parameetrid>Parameetrid 123</parameetrid>
        <dvk_saatmine>1</dvk_saatmine>
        <dvk_otse_saatmine>0</dvk_otse_saatmine>
        <toetatav_dvk_versioon>1.5</toetatav_dvk_versioon>
        <dokumendihaldussysteemi_nimetus>SuperDoc 2000 </dokumendihaldussysteemi_nimetus>
      </paring>
      <keha>OK</keha>
    </dhl:changeOrganizationDataResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###deleteOldDocuments
------
<pre>
Päringu nimi: dhl.deleteOldDocuments.v1
Sisendi keha: -
Väljundi keha: string
</pre>

Päring kustutab DVK andmebaasist säilitustähtaja ületanud dokumendid. Kui säilitustähtaja ületanud dokument on osadele adressaatidele veel saatmata, siis märgib DVK server dokumendi andmetesse, et dokumendi edastamine on katkestatud ning lükkab dokumendi säilitustähtaega mõnevõrra edasi (sõltub serveri seadistusest), et info saatmise katkestamisest jõuaks kindlasti ka dokumendi saatjale.

Kui säilitustähtaja ületanud dokumentide kustutamine õnnestub, siis tagastab päring vastussõnumi kehas väärtuse „OK“.

####Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.deleteOldDocuments.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:deleteOldDocuments>
      <keha/>
    </dhl:deleteOldDocuments>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.deleteOldDocuments.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:deleteOldDocumentsResponse>
      <paring/>
      <keha>OK</keha>
    </dhl:deleteOldDocumentsResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###runSystemCheck
------

<pre>
Päringu nimi: dhl.runSystemCheck.v1
Sisendi keha: -
Väljundi keha: string
</pre>

Päring kontrollib DVK serveri kriitiliste funktsioonide toimimist (andmebaasi ligipääs, kettale kirjutamine, jne.). Kui kõik kontrollitavad funktsioonid toimivad, siis tagastab päring väärtuse „OK“. Avastatud vea korral tagastab päring veateate SOAP veateate kujul.

####Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.runSystemCheck.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:runSystemCheck>
      <keha/>
    </dhl:runSystemCheck>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>11181967</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>38005130332</xtee:ametnik>
    <xtee:nimi>dhl.runSystemCheck.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE38005130332</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:runSystemCheckResponse>
      <paring/>
      <keha>OK</keha>
    </dhl:runSystemCheckResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###getSubdivisionList

###getSubdivisionList.v1
------

<pre>
Päringu nimi: dhl.getSubdivisionList.v1

Sisendi keha: stringide massiiv

Väljundi keha: massiiv andmetüübist „allyksus”:

        kood string
        nimetus string
        asutuse_kood string
        lyhinimetus string
        ks_allyksuse_lyhinimetus string    (kõrgemalseisva allüksuse lühinimetus)
</pre>

Päring tagastab sisendparameetriga etteantud asutuste allüksuste nimekirja. Päring on vajalik selleks, et oleks võimalik dokumente adresseerida asutuse allüksusele (et oleks teada, millisele allüksusele DVK serveris milline unikaalne kood vastab).

Antud päringu puhul esitatakse nii sisend- kui väljundandmed pakkimata ja kodeerimata kujul.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/">  
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getSubdivisionList.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getSubdivisionList>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[3]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
      </keha>
    </dhl:getSubdivisionList>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getSubdivisionList.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:getSubdivisionListResponse>
      <paring xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[3]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
        <asutus>34567890</asutus>
      </paring>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:allyksus[4]">
        <allyksus>
          <kood>1</kood>
          <nimetus>IT osakond</nimetus>
          <asutuse_kood>12345678</asutuse_kood>
          <lyhinimetus>IT</lyhinimetus>
          <ks_allyksuse_lyhinimetus>YLD</ks_allyksuse_lyhinimetus>
        </allyksus>
        <allyksus>
          <kood>2</kood>
          <nimetus>Üldosakond</nimetus>
          <asutuse_kood>12345678</asutuse_kood>
          <lyhinimetus>YLD</lyhinimetus>
          <ks_allyksuse_lyhinimetus/>
        </allyksus>
        <allyksus>
          <kood>12</kood>
          <nimetus>Raamatupidamisosakond</nimetus>
          <asutuse_kood>23456789</asutuse_kood>
          <lyhinimetus>RMTP</lyhinimetus>
          <ks_allyksuse_lyhinimetus/>
        </allyksus>
        <allyksus>
          <kood>28</kood>
          <nimetus>Haldusosakond</nimetus>
          <asutuse_kood>34567890</asutuse_kood>
          <lyhinimetus>haldus</lyhinimetus>
          <ks_allyksuse_lyhinimetus/>
        </allyksus>
      </keha>
    </dhl:getSubdivisionListResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###getSubdivisionList.v2
------

Päringu getSubdivisionList versioon v2 eelneb varasematest versioonidest selle poolest, et päringu ja vastuse andmed asuvad nüüd SOAP sõnumi manustes (varasemates versioonides asusid andmed SOAP sõnumi kehas).

<pre>
Päringu nimi: dhl.getSubdivisionList.v2

Sisendi keha:

        asutused    stringide massiiv päringu MIME manuses base64 kujul

Väljundi keha:

        allyksused    massiiv andmetüübist allyksus päringu MIME manuses base64 kujul
        kood    string
        nimetus    string
        asutuse_kood    string
        lyhinimetus    string
        ks_allyksuse_lyhinimetus    string(kõrgemalseisva allüksuse lühinimetus)
</pre>

Päring tagastab sisendparameetriga etteantud asutuste allüksuste nimekirja. Päring on vajalik selleks, et oleks võimalik dokumente adresseerida asutuse allüksusele (et oleks teada, millisele allüksusele DVK serveris milline unikaalne kood vastab).

Antud päringu sisend- ja väljundandmed saadetakse SOAP sõnumi MIME manustes. Enne SOAP sõnumi manusesse paigutamist pakitakse XML gzip-ga kokku ja kodeeritakse base64 kujule.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getSubdivisionList.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getSubdivisionList>
      <keha>
        <asutused href="cid:1265809289328"/>
      </keha>
    </dhl:getSubdivisionList>
  </env:Body>
</env:Envelope>

------=_Part_1_16862753.1265809289328
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <1265809289328>
Content-Encoding: gzip

H4sIAAAAAAAAALNJLC4tKS1OTbGzgbDsLMzNTE2MjQxt9KECMAlDI2MTUzNzC4SEPlwzAG7f6Q9HAAAA
------=_Part_1_16862753.1265809289328—
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getSubdivisionList.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:getSubdivisionListResponse>
      <paring>
        <asutused>142E7683AA18F590EFEC96751000D91F</asutused>
      </paring>
      <keha>
        <allyksused href="cid:B6EBE21AD4CC96D41942366EFADCFEFF"/>
      </keha>
    </dhl:getSubdivisionListResponse>
  </soapenv:Body>
</soapenv:Envelope>

------=_Part_22_9158501.1265809289375
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <B6EBE21AD4CC96D41942366EFADCFEFF>
Content-Encoding: gzip

H4sIAAAAAAAAALXSzQqDMAwA4FfxDWTqfg5B2GGHocJwY1cJNGyltZXVDnz7FcWyyUAQPCVNmvAVCihlJ4w...
Y6n+7x3eNW8N/z64R9dnckT7gIAAA==
------=_Part_22_9158501.1265809289375--
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<asutused>
    <asutus>87654321</asutus>
    <asutus>12345678</asutus>
</asutused>
```

##### Vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<allyksused>
    <allyksus>
        <kood>1</kood>
        <nimetus>IT osakond</nimetus>
        <asutuse_kood>12345678</asutuse_kood>
        <lyhinimetus>IT</lyhinimetus>
        <ks_allyksuse_lyhinimetus>YLD</ks_allyksuse_lyhinimetus>
    </allyksus>
    <allyksus>
        <kood>2</kood>
        <nimetus>Üldosakond</nimetus>
        <asutuse_kood>12345678</asutuse_kood>
        <lyhinimetus>YLD</lyhinimetus>
        <ks_allyksuse_lyhinimetus/>
    </allyksus>
    <allyksus>
        <kood>12</kood>
        <nimetus>Raamatupidamisosakond</nimetus>
        <asutuse_kood>87654321</asutuse_kood>
        <lyhinimetus>RMTP</lyhinimetus>
        <ks_allyksuse_lyhinimetus/>
    </allyksus>
    <allyksus>
        <kood>28</kood>
        <nimetus>Haldusosakond</nimetus>
        <asutuse_kood>87654321</asutuse_kood>
        <lyhinimetus>haldus</lyhinimetus>
        <ks_allyksuse_lyhinimetus/>
    </allyksus>
</allyksused>
```

###getOccupationList

###getOccupationList.v1
------

<pre>
Päringu nimi: dhl.getOccupationList.v1

Sisendi keha: stringide massiiv

Väljundi keha: massiiv andmetüübist „ametikoht”:

        kood   string
        nimetus     string
        asutuse_kood   string
        lyhinimetus     string
        ks_allyksuse_lyhinimetus string    (kõrgemalseisva allüksuse lühinimetus)
</pre>

Päring tagastab sisendparameetriga etteantud asutuste ametikohtade
nimekirja. Päring on vajalik selleks, et oleks võimalik dokumente
adresseerida asutuse ametikohtadele (et oleks teada, millisele
ametikohale DVK serveris milline unikaalne kood vastab).

Antud päringu puhul esitatakse nii sisend- kui väljundandmed pakkimata
ja kodeerimata kujul.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/">  
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getOccupationList.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getOccupationList>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[2]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
      </keha>
    </dhl:getOccupationList>
  </env:Body>
</env:Envelope>
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getOccupationList.v1</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:getOccupationListResponse>
      <paring xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="xsd:string[2]">
        <asutus>12345678</asutus>
        <asutus>23456789</asutus>
      </paring>
      <keha xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:ametikoht[4]">
        <ametikoht>
          <kood>2</kood>
          <nimetus>Peadirektor</nimetus>
          <asutuse_kood>12345678</asutuse_kood>
          <lyhinimetus>DIR</lyhinimetus>
          <ks_allyksuse_lyhinimetus/>
        </ametikoht>
        <ametikoht>
          <kood>7</kood>
          <nimetus>Finantsdirektor</nimetus>
          <asutuse_kood>12345678</asutuse_kood>
          <lyhinimetus>FIN-DIR</lyhinimetus>
          <ks_allyksuse_lyhinimetus/>
        </ametikoht>
        <ametikoht>
          <kood>46</kood>
          <nimetus>Dokumendihaldusosakonna juhataja</nimetus>
          <asutuse_kood>23456789</asutuse_kood>
          <lyhinimetus>DH-JUH</lyhinimetus>
          <ks_allyksuse_lyhinimetus>DH</ks_allyksuse_lyhinimetus>
        </ametikoht>
        <ametikoht>
          <kood>92</kood>
          <nimetus>Raamatupidaja</nimetus>
          <asutuse_kood>23456789</asutuse_kood>
          <lyhinimetus>RMTP</lyhinimetus>
          <ks_allyksuse_lyhinimetus>RMTP</ks_allyksuse_lyhinimetus>
        </ametikoht>
      </keha>
    </dhl:getOccupationListResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

###getOccupationList.v2
------

Päringu getOccupationList versioon v2 eelneb varasematest versioonidest selle poolest, et päringu ja vastuse andmed asuvad nüüd SOAP sõnumi manustes (varasemates versioonides asusid andmed SOAP sõnumi kehas).

<pre>
Päringu nimi: dhl. getOccupationList.v2

Sisendi keha:

        asutused    stringide massiiv päringu MIME manuses base64 kujul
Väljundi keha:

        ametikohad  massiiv andmetüübist allyksus päringu MIME manuses base64 kujul
        kood    string
        nimetus     string
        asutuse_kood   string
        lyhinimetus     string
        ks_allyksuse_lyhinimetus  string    (kõrgemalseisva allüksuse lühinimetus)
</pre>

Päring tagastab sisendparameetriga etteantud asutuste ametikohtade nimekirja. Päring on vajalik selleks, et oleks võimalik dokumente adresseerida asutuse ametikohtadele (et oleks teada, millisele ametikohale DVK serveris milline unikaalne kood vastab).

Antud päringu sisend- ja väljundandmed saadetakse SOAP sõnumi MIME manustes. Enne SOAP sõnumi manusesse paigutamist pakitakse XML gzip-ga kokku ja kodeeritakse base64 kujule.

#### Näide

##### Päring

```xml
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: text/xml; charset=utf-8

<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd">  
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getOccupationList.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <env:Body>
    <dhl:getOccupationList>
      <keha>
        <asutused href="cid:1265809289390"/>
      </keha>
    </dhl:getOccupationList>
  </env:Body>
</env:Envelope>

------=_Part_2_11235685.1265809289406
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: <1265809289390>
Content-Encoding: gzip

H4sIAAAAAAAAALNJLC4tKS1OTbGzgbDsLMzNTE2MjQxt9KECMAlDI2MTUzNzC4SEPlwzAG7f6Q9HAAAA
------=_Part_2_11235685.1265809289406—
```

##### Päringu vastus

```xml
HTTP/1.1 200 OK
SOAPAction: ""
Content-Type: text/xml

<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd"
  xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:dhl="http://www.riik.ee/schemas/dhl">
  <env:Header>
    <xtee:asutus>12345678</xtee:asutus>
    <xtee:andmekogu>dhl</xtee:andmekogu>
    <xtee:ametnik>12345678901</xtee:ametnik>
    <xtee:nimi>dhl.getOccupationList.v2</xtee:nimi>
    <xtee:id>dhl_client_1</xtee:id>
    <xtee:toimik/>
    <xtee:isikukood>EE12345678901</xtee:isikukood>
  </env:Header>
  <soapenv:Body>
    <dhl:getOccupationListResponse>
      <paring>
        <asutused>142E7683AA18F590EFEC96751000D91F</asutused>
      </paring>
      <keha>
        <ametikohad href="cid: DD284357A5C7762760F2BA30D7AD3B48"/>
      </keha>
    </dhl:getOccupationListResponse>
  </soapenv:Body>
</soapenv:Envelope>

------=_Part_22_9158501.1265809289375
Content-Type: {http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding: binary
Content-Id: < DD284357A5C7762760F2BA30D7AD3B48>
Content-Encoding: gzip

H4sIAAAAAAAAALNJzE0tyczOz0hMsbOBsUvsbLLz81PsDG30wbRNXiZQprTYLvjwnpyUTIWy/KLczKxEG32...
Y4VR/JCwDpUv8hzwAAAA==
------=_Part_22_9158501.1265809289375--
```

##### Päringu „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<asutused>
    <asutus>87654321</asutus>
    <asutus>12345678</asutus>
</asutused>
```

##### Vastuse „keha“ elemendi sisu

Elemendi „keha“ sisu kodeerimata kujul on:

```xml
<ametikohad>
    <ametikoht>
        <kood>2</kood>
        <nimetus>Peadirektor</nimetus>
        <asutuse_kood>12345678</asutuse_kood>
        <lyhinimetus>DIR</lyhinimetus>
        <ks_allyksuse_lyhinimetus/>
    </ametikoht>
    <ametikoht>
        <kood>7</kood>
        <nimetus>Finantsdirektor</nimetus>
        <asutuse_kood>12345678</asutuse_kood>
        <lyhinimetus>FIN-DIR</lyhinimetus>
        <ks_allyksuse_lyhinimetus/>
    </ametikoht>
    <ametikoht>
        <kood>46</kood>
        <nimetus>Dokumendihaldusosakonna juhataja</nimetus>
        <asutuse_kood>87654321</asutuse_kood>
        <lyhinimetus>DH-JUH</lyhinimetus>
        <ks_allyksuse_lyhinimetus>DH</ks_allyksuse_lyhinimetus>
    </ametikoht>
    <ametikoht>
        <kood>92</kood>
        <nimetus>Raamatupidaja</nimetus>
        <asutuse_kood>87654321</asutuse_kood>
        <lyhinimetus>RMTP</lyhinimetus>
        <ks_allyksuse_lyhinimetus>RMTP</ks_allyksuse_lyhinimetus>
    </ametikoht>
</ametikohad>
```

##Kasutusõiguste süsteem DVK rakenduses
------

Dokumendivahetuskeskuses kasutatakse kahetasemelist kasutusõiguste süsteemi:

-   X-Tee vahenditega autentimine ja autoriseerimine
-   DVK kasutajate andmebaasi põhjal autentimine ja autoriseerimine

DVK serveri kasutamiseks peavad seega esmajoones olema RIA turvaserveris asutusele avatud DVK päringud. Vastasel juhul ei jõua DVK serverile saadetud päringud DVK serverisse kohale.

Kui DVK päringud on RIA turvaserveris lubatud, siis jõuavad päringud DVK serverisse ja läbivad seal järgmise kontrolli:

-   **Kas päringu saatnud asutus on registreeritud DVK asutuste registris?**  
    Kui asutus ei ole DVK asutuste registris registreeritud, siis päringu töötlemine katkestatakse, kuna päringu töötlemiseks (näit. adresseerimiseks) vajalikke andmeid ei ole olemas.

-   **Kas päringu saatnud isik on registreeritud DVK isikute registris?**  
    Kui päringu saatja ei ole isikute registris registreeritud, siis päringu töötlemine katkestatakse, kuna pole võimalik määrata konkreetse isiku kasutajaõigusi.

Sõltuvalt tehtavast päringust kontrollib DVK server veel järgmisi tingimusi:

-   **sendDocuments**

-   -   Saadetava dokumendi adressaadiks olev asutus peab olema registreeritud DVK asutuste registrisse.

-   **receiveDocuments**

    -   Kui päringu teinud isik täidab oma asutuses ametikohta, mille rolliks on „DHL: Asutuse administraator“, siis saab ta alla laadida kõik antud asutusele adresseeritud dokumendid.
    -   Kui päringu teinud isik töötab oma asutuses mingis allüksuses, siis saab ta alla laadida kõik antud allüksusele adresseeritud dokumendid.
    -   Kui päringu teinud isik täidab oma asutuses mingit ametikohta, siis saab ta alla laadida kõik antud ametikohale adresseeritud dokumendid.
    -   Päringu teinud isik saab alla laadida kõik isiklikult talle adresseeritud dokumendid.

-   **getSendStatus**

   -   Dokumendi staatust saab pärida ainult nende dokumentide kohta, mille on saatnud antud päringu teinud asutus (s.t. teiste asutuste poolt saadetud dokumentide kohta tagasisidet küsida ei saa).

Üldjuhul, kus DVK andmevahetuse eest hoolitseb tarkvara ja reaalsed isikud otseselt DVK-le päringuid ei esita, on DVK andmevahetuse korrektseks toimimiseks seega vaja, et isik, kelle nimel DVK-le päringuid esitatakse, täidaks DVK ametikohtade registris ametikohta, mille rolliks on määratud „DHL: Asutuse administraator“.

## Edastavate dokumentide valideerimine DVK serveris
------

Päringuga sendDocuments dokumentide saatmisel toimub DVK serveris dokumentide valideerimine. DVK server teostab järgmised kontrollid:

1.  DVK konteineri XML struktuuri korrektse vorminduse *(well formed)* kontroll
2.  DVK konteineri XML struktuuri vastavus konteineri XML skeemile (teostatakse juhul, kui DVK konteineri XML-s on viidatud konteineri XML skeemile)
3.  DVK konteineri &lt;metaxml&gt; elemendis sisalduva XML-i struktuuri vastavus XML skeemile (teostatakse juhul, kui &lt;metaxml&gt; elemendis on viidatud vastavale XML skeemile.
4.  &lt;SignedDoc&gt; või &lt;Failid&gt; elemendis edastatavate digiallkirja konteinerite (.DDOC või .BDOC failid) allkirjade kehtivuse kontroll.
5.  &lt;SignedDoc&gt; või &lt;Failid&gt; elemendis edastatava XML faili korrektse vorminduse *(well formed)* kontroll.
6.  &lt;SignedDoc&gt; või &lt;Failid&gt; elemendis edastatava XML faili struktuuri vastavus vastavale XML skeemile (teostatakse juhul, kui XML failis on viidatud vastavale XML skeemile).
7.  &lt;SignedDoc&gt; või &lt;Failid&gt; elemendis edastatava digiallkirja konteinerite (.DDOC või .BDOC failid) sisus asuvate XML failide korrektse vorminduse *(well formed)* kontroll.
8.  &lt;SignedDoc&gt; või &lt;Failid&gt; elemendis edastatava digiallkirja konteinerite (.DDOC või .BDOC failid) sisus asuvate XML failide vastavus vastavale XML skeemile (teostatakse juhul, kui XML failis on viidatud vastavale XML skeemile).

Valideerimisel avastatud vea puhul tagastab sendDocuments päring dokumendi saatjale veateate vea võimalikult detailse kirjeldusega. Veateade tagastatakse päringu käivitajale SOAP Fault sõnumina. Vea kirjeldus sisaldab sõltuvalt teostatud kontrollist järgmisi andmeid:

-   XML failide valideerimisel vea kirjeldust, XML faili nime ja vea asukohta failis (rida, veerg)
-   Digitaalallkirjade puhul vea kirjeldust ja faili nime.

Nii XML failide kui ka digitaalallkirjade valideerimist saab DVK serveri konfiguratsioonis vajadusel välja lülitada. Selleks tuleb serveri konfiguratsioonifailis dhl.properties muuta parameetrite „server\_validate\_container“, „server\_validate\_xml“ ja „server\_validate\_signatures“ väärtusi.

**Faili dhl.properties näidis:**

```
# Konteineri valideerimise seaded
server_validate_container = no
server_ignore_invalid_containers = no

# Määrab, kas DVK server üritab valideerida konteineri sisus
# edastatavaid XML faile.
server_validate_xml_files = no

# Määrab, kas DVK server üritab valideerida digiallkirja
# konteinerite küljes olevaid allkirju.
server_validate_signatures = no
```


##Adressaatide automaatne lisamine DVK serveris
------

DVK serverit on võimalik seadistada nii, et kui saadetav dokumendikonteiner vastab etteantud tingimustele, siis lisatakse dokumendi adressaatide hulka üks või mitu täiendavat adressaati. Nimetatud lahendus on vajalik näiteks selleks, et garanteerida mingi projektiga seotud dokumentide jõudmine kõigile asjassepuutuvatele osapooltele.

Automaatse adressaatide lisamise korral muudab DVK server saadetava dokumendikonteineri XML andmeid, s.t. lisatud adressaadid on nähtavad ka kõigile teistele adressaatidele ja dokumendi esialgsele saatjale.

###Adressaatide automaatse lisamise seadistamine

DVK serveri poolt automaatselt lisatavaid aadressaate saab seadistada DVK serveri andmetabelis VASTUVOTJA\_MALL. Nimetatud andmetabeli struktuur näeb välja järgmine:

| Andmevälja nimi | Kirjeldus |
|-------|----------------------|
| vastuvotja_mall_id | Kirje unikaalne ID. Selle määrab andmebaas automaatselt. |
| asutus_id | Lisatava adressaadi asutuse ID. Viitab tabelisse ASUTUS. Vähemalt see lahter peaks adressaadi puhul alati täidetud olema. |
| asutuse_nimi | Lisatava adressaadi asutuse nimi. |
| ametikoht_id | Lisatava adressaadi ametikoha ID. Viitab tabelisse AMETIKOHT. |
| isikukood | Lisatava adressaadi isikukood. |
| nimi | Lisatava adressaadi nimi (isiku nimi) |
| email | Lisatava adressaadi e-posti aadress. |
| osakonna_nr | Lisatava adressaadi osakonna kood. Selle lahtri väärtust DVK server dokumentide edastamisel otseselt ei kasuta ja see on mõeldud pigem dokumendi vastuvõtnud infosüsteemile. |
| osakonna_nimi | Lisatava adressaadi osakonna nimetus. Selle lahtri väärtust DVK server dokumentide edastamisel otseselt ei kasuta ja see on mõeldud pigem dokumendi vastuvõtnud infosüsteemile. |
| saatmisviis_id | Saatmisviisi ID. Viitab tabelisse KLASSIFIKAATOR. DVK kaudu saatmise korral on selle lahtri väärtuseks 1. |
| allyksus_id | Lisatava adressaadi allüksuse ID. Viitab tabelisse ALLYKSUS. |
| tingimus_xpath | XPATH tingimus, millele vastavale XML konteinerile lisatakse ülejäänud lahtrites kirjeldatud adressaat. XPATH tingimuse kirjeldamisel tuleks ignoreerida DVK konteineri XML nimeruumide lühendeid ning kasutada XPATH stringis ainult elementide ja atribuutide lokaalseid nimesid. DVK server lisab adressaadi dokumendile siis, kui konteineri XML struktuurist õnnestub leida XPATH tingimusele vastav element. |


XPATH tingimuse näiteid:

1.  Oletame, et adressaat tuleks lisada dokumendile, mille adressaatide hulgas on juba olemas asutus registrikoodiga 12345678. Sellisel juhul näeks andmevälja TINGIMUS\_XPATH väärtus välja järgmine: <pre>/dokument/transport/saaja[regnr='12345678']</pre>
2.  Oletame, et adressaat tuleks lisada dokumendile, mille saatjaks on asutus registrikoodiga 23456789. Sellisel juhul näeks andmevälja TINGIMUS\_XPATH väärtus välja järgmine: <pre>/dokument/transport/saatja[regnr='23456789']</pre>
3.  Oletame, et adressaat tuleks lisada dokumendile, mille metainfo blokis on saatja defineeritud andmeväli „Lisa mulle aadress“ ja väärtusega „Jah“. Sellisel juhul näeks andmeväli TINGIMUS\_XPATH väärtus välja järgmine: <pre>/dokument/metainfo[saatja_defineeritud='Jah']/saatja_defineeritud[@valjanimi='Lisa mulle aadress']</pre>
4.  Oletame, et adressaat tuleks lisada dokumendile, mille metainfo blokis on saatja defineeritud andmeväli „Projekt“ ja väärtusega „DVK“. Sellisel juhul näeks andmeväli TINGIMUS\_XPATH väärtus välja järgmine:<pre>/dokument/metainfo[saatja_defineeritud='DVK']/saatja_defineeritud[@valjanimi='Projekt']</pre>
5.  Oletame, et adressaat tuleks lisada dokumendile, mille metaxml blokk sisaldab järgmises XML näites paksemas kirjas esitatud väärtust:

```xml
<dokument>
    ...
    <metaxml>
        <lepingu_andmed>
            <osapooled>
                <osapool>
                    <registrikood><b>12345678</b></registrikood>
                    <nimetus>Ettevote1 AS</nimetus>
                </osapool>
            </osapooled>
        </lepingu_andmed>
    </metaxml>
    ...
</dokument>
```

Sellisel juhul näeks andmeväli TINGIMUS\_XPATH väärtus välja järgmine:<pre>/dokument/metaxml/lepingu_andmed/osapooled/osapool[registrikood='12345678']</pre>



##Dokumentide edastamine DVK serverite vahel (DVK lüüsid)
------

###Sissejuhatus
DVK lüüsid kujutavad endast võimalust edastada DVK serverisse saadetud dokumente mõnda teise DVK serverisse või mõnda teise dokumendivahetussüsteemi. Esmases tehnilises lahenduses toetab DVK dokumentide edastamist DVK andmevahetusspetsifikatsioonile vastavatesse dokumendivahetussüsteemidesse.

Sellise dokumentide edastamise peamiseks eesmärgiks on, et saaks eksisteerida eraldi dokumendivahetuskeskkonnad näiteks riigisektori ja erasektori jaoks. Dokumentide vahetamine kirjeldatud juhul toimiks siis joonisel 1 toodud skeemi alusel:

![Joonis 1](/docs/img/image3.PNG "Joonis 1")

DVK serverisse saadetud dokumendi (päring *sendDocuments*) edastamise
protsess on esitatud joonisel 2.

![Joonis 2](/docs/img/image4.PNG "Joonis 2")

Analoogilist protsessi rakendatakse ka olukorras, kus dokumendi saatja
pärib andmeid dokumendi staatuse kohta (päring *getSendStatus*).

###Tehnilised piirangud DVK lüüside kasutamisele

DVK arhitektuurist tingitult on DVK lüüsidele seatud järgmised
tehnilised piirangud:

  1.  Dokumendivahetussüsteem, kuhu DVK server dokumente edastab, peab toetama DVK andmevahetusspetsifikatsioonile sarnast transaktsiooniloogikat. S.t. DVK-ga liidestatav dokumendivahetussüsteem peab suutma anda ja vastu võtta andmeid dokumendi kohaletoimetamise kohta.\ Vastasel juhul puudub DVK kaudu dokumendi välja saatnud asutusel või isikul võimalus teada saada, kas tema poolt saadetud dokument on edukalt kohale toimetatud.
  2.  Dokumendivahetussüsteem, kuhu DVK server dokumente edastab, peab toetama DVK dokumendikonteineri spetsifikatsioonile vastavate XML andmevahetuskonteinerite kasutamist. Alternatiivina võib liidestatav dokumendivahetussüsteem kasutada andmevahetuskonteinerit, mis on andmevahetuse toimimise seisukohast kriitiliste andmete osas teisendatav DVK andmevahetuskonteineriks (ja vastupidi).
  3.  Iga DVK server peab omama kõigi teiste liidestatud dokumendivahetusserverite nimekirja ning omama ligipääsu nendes serverites seadistatud asutuste nimekirjale.\ Kui eeldada, et iga DVK server ei ole teadlik kõigist teistest DVK serveritest, siis tuleks dokumendi edastamisel arvestada vajadusega edastada dokument adressaadile läbi mitme serveri. Iga serveritevaheline edastus tähendaks aga saatmisele kuluva aja täiendavat kasvu (dokumendi edastamine läbi 10 serveri oleks kõigi serverite vahel sama andmesidekiirust eeldades ca. 11 korda aeglasem kui otse saatmine).\ Kui eeldada, et iga DVK server ei oma ligipääsu võimalike adressaatide nimekirjale, siis ei ole võimalik dokumente edastada.
  4.  Iga DVK server, mis on võimeline dokumente edastama, peab omama asutuse registrikoodi ja isikukoodi, mida kasutades dokumente edasi saadetakse.\ Vastasel juhul ei ole võimalik DVK serverist andmeid üle X-Tee

###DVK lüüside lahendusest tingitud muudatused DVK spetsifikatsioonis

Tehniline lahendus jääb dokumendi saatja seisukohast täpselt samasuguseks nagu varem. S.t. saatja koostab saadetavatest dokumentidest DVK konteineri, lisab enda andmed ja adressaatide andmed ning saadab konteineri oma DVK serverisse. Dokumendi kohaletoimetamine on sellest hetkest alates DVK serverite omavaheline asi.

####Vahendaja kirje DVK konteineri transport andmestruktuuris

Vastuvõtja seisukohast lisandub käesoleva lahendusega täiendav kirje „vahendaja“ DVK konteineri transport plokis. Antud kirje näol on tegemist automaatselt täidetavate andmetega, mille lisab DVK dokumendikonteinerisse dokumendi edastanud DVK server.

```xml
<dhl:transport>
        <dhl:saatja>
            <dhl:regnr>11111111</dhl:regnr>
            <dhl:asutuse_nimi>Asutuse nimi</dhl:asutuse_nimi>
            <dhl:allyksuse_kood>10</dhl:allyksuse_kood>
            <dhl:allyksuse_nimetus>Saatmisosakond</dhl:allyksuse_nimetus>
            <dhl:ametikoha_kood>20</dhl:ametikoha_kood>
            <dhl:ametikoha_nimetus>Saatja</dhl:ametikoha_nimetus>
            <dhl:isikukood>30000000001</dhl:isikukood>
            <dhl:nimi>Isiku nimi</dhl:nimi>
            <dhl:epost>epost@saatja.ee</dhl:epost>
            <dhl:osakonna_kood>Osakonna kood</dhl:osakonna_kood>
            <dhl:osakonna_nimi>Osakonna nimi</dhl:osakonna_nimi>
        </dhl:saatja>
        <dhl:saaja>
            <dhl:regnr>33333333</dhl:regnr>
            <dhl:asutuse_nimi>Asutuse nimi</dhl:asutuse_nimi>
            <dhl:allyksuse_kood>11</dhl:allyksuse_kood>
            <dhl:allyksuse_nimetus>Vastuvõtuosakond</dhl:allyksuse_nimetus>
            <dhl:ametikoha_kood>21</dhl:ametikoha_kood>
            <dhl:ametikoha_nimetus>Vastuvõtja</dhl:ametikoha_nimetus>
            <dhl:isikukood>31111111112</dhl:isikukood>
            <dhl:nimi>Isiku nimi</dhl:nimi>
            <dhl:epost>epost@vastuvotja.ee</dhl:epost>
            <dhl:osakonna_kood>Osakonna kood</dhl:osakonna_kood>
            <dhl:osakonna_nimi>Osakonna nimi</dhl:osakonna_nimi>
        </dhl:saaja>
        <b><dhl:vahendaja>
            <dhl:regnr>22222222</dhl:regnr>
            <dhl:asutuse_nimi>Asutuse nimi</dhl:asutuse_nimi>
            <dhl:allyksuse_kood/>
            <dhl:allyksuse_nimetus/>
            <dhl:ametikoha_kood/>
            <dhl:ametikoha_nimetus/>
            <dhl:isikukood>40000000001</dhl:isikukood>
            <dhl:nimi>Isiku nimi</dhl:nimi>
            <dhl:epost>epost@vahendaja.ee</dhl:epost>
            <dhl:osakonna_kood/>
            <dhl:osakonna_nimi/>
        </dhl:vahendaja> </b>
    </dhl:transport>
```

Vahendaja kirje on ennekõike vajalik selleks, et DVK server lubaks dokumendiedastuse vahendajaks olnud asutusel teostada dokumendi edastuse staatust puudutavaid päringuid (üldjuhul on see õigus üksnes dokumendi saatjal).

Teine oluline põhjus vahendaja kirje lisamiseks on asjaolu, et vastasel juhul peaks DVK server olema valmis vastu võtma dokumente, mille saatja andmed ei klapi X-tee päringu teinud asutuse andmetega. See aga annaks võimaluse tahtmatuteks (või ka tahtlikeks) identiteedivargusteks, mille lahendamine oleks võimalik üksnes X-Tee logide abil.

####DVK serveri täiendavad seadistused
Et DVK server saaks teistesse serveritesse dokumente edastada, peavad olema täidetud järgmised tingimused:

1.  Server peab saama teostada X-Tee päringuid
2.  Server peab teadma teiste dokumendivahetussüsteemide serverite aadresse (s.t. peab teadma, kuhu dokumente saata saab)
3.  Asutuse turvaserver peab lubama DVK päringuid teistest DVK serveritest ja teiste DVK serverite turvaserverid peavad lubama päringuid antud asutuse turvaserverist.

**DVK serveri seadistamine X-Tee päringute teostamiseks**

Kuna dokumentide edastamine ühest DVK serverist teise toimub X-Tee päringutega, siis peab DVK serveril olema seadistatud asutuse registrikood ja isikukood, mille nimel X-Tee päringuid teostatakse.

Selleks tuleb DVK serveri konfiguratsioonifaili dhl.properties lisada järgmised read:

```
client_default_org_code = 12345678
client_default_person_code = 11111111111
```

**Väliste serverite aadresside lisamine DVK serverisse**

Et DVK server teaks, millised teised DVK serverid olemas on ja kus need asuvad, tuleb DVK serverile ette anda teadaolevate teiste DVK serverite nimekiri.

Selleks tuleks iga teadaoleva teise DVK serveri kohta lisada andmetabelisse „Server“ järgmised andmed:

-   andmekogu nimetusnäiteks „dhl“. Ei pea olema täidetud, kui server ei kasuta andmevahetuseks X-Teed.
-   aadressX-Tee andmevahetuse puhul reeglina:\ http://\[TURVASERVER\]/cgi-bin/consumer\_proxy\ Ilma X-Tee vahenduseta andmevahetuse puhul oleks siin serveri reaalne URL.

##Dokumentide edastamine fragmentidena
------

DVK päringuid sendDocuments.v2 ja receiveDocuments.v2 saab kasutada nii, et dokumendid edastataks kliendilt serverile või serverilt kliendile tükkhaaval.

Dokumentide tükkhaaval saatmine ja vastuvõtmine on kasulik ennekõike suuremahuliste dokumentide puhul, kui:

-   suuremahulise dokumendi saatmine või vastuvõtmine võtab kaua aega, mistõttu DVK server, infosüsteem või mõni vahepealne X-Tee turvaserver võib timeout’i tõttu andmete edastamise katkestada.
-   suuremahulise dokumendi jaotamine väiksemateks tükkideks aitab vähendada DVK serveri või klientrakenduse töökoormust.

Dokumentide tükkhaaval saatmisel on eeldatud, et saadetavad andmed on esmalt GZIP-iga kokku pakitud ja alles seejärel tükkideks jaotatud.
Analoogilist loogikat on rakendatud ka dokumentide vastuvõtmisel, s.t. DVK server pakib andmed esmalt kokku ning jaotab alles seejärel tükkideks.

Dokumentide tükkhaaval saatmisel tuleks kasutada järgmisi päringu sendDocuments.v2 parameetreid:

-   fragmente\_kokkuEdastatavate fragmentide hulk (s.t. mitmeks tükiks dokument on jagatud)
-   fragment\_nrEdastatava fragmendi järjekorranumber alates 0-st (s.t. 0, 1, 2, jne.)
-   edastus\_idEdastussessiooni ID. Saatja poolt vabalt valitav võimalikult unikaalne string, mis on ühiseks nimetajaks kõigile edastatavatele tükkidele.

Dokumentide tükkhaaval vastuvõtmiseks tuleks kasutada järgmisi päringu receiveDocuments.v2 parameetreid:

-   fragmendi\_suurus\_baitidesFragmendi soovitav suurus baitides. Annab DVK serverile teada, kui suurteks tükkideks see peaks kliendile saadetavad andmed jaotama.
-   fragment\_nrJärgmise oodatava fragmendi järjekorranumber alates 0-st (s.t. 0, 1, 2, jne.)
-   edastus\_idEdastussessiooni ID. Vastuvõtja poolt vabalt valitav võimalikult unikaalne string, mis on ühiseks nimetajaks kõigile edastatavatele tükkidele (ja mille alusel saab hiljem kõik tükid tuvastada ja kokku panna).


##Teadaolevad vead DVK rakenduses
------

###Content-Transfer-Encoding päise vigane esitus

DVK rakendus sisaldab kasutatavatest tarkvarakomponentidest (Axis 1.3 teegist) tingituna järgmist viga MIME sõnumimanuste
Content-Transfer-Encoding päises:

Et MIME manustena saadetakse Base64 kodeeritud binaarfaile, siis peaks manused saama endale järgmise päise:

<pre>
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:<b>base64</b>
Content-Encoding: gzip
Content-ID: ...
</pre>

DVK rakendus väljastab aga kõik MIME manused järgmise päisega:

<pre>
Content-Type:{http://www.w3.org/2001/XMLSchema}base64Binary
Content-Transfer-Encoding:<b>binary</b>
Content-Encoding: gzip
Content-ID: ...
</pre>

Antud juhul tuleks arvestada, et hoolimata päises märgitud *binary* kodeeringust saadab DVK MIME manuseid ikkagi Base64 kodeeritult. Samuti ignoreerib DVK rakendus antud päist saabuvate sõnumite puhul ning eeldab, et manus on saadetud Base64 kodeeritud kujul.

###Tundlikkus Content-Type päise kirjapildi suhtes
DVK rakendus ei suuda päringut korrektselt vastu võtta, kui saadetava sõnumi HTTP päises puuduvad jutumärgid *Content-Type* päises parameetri *type* väärtuse ümber. Puuduvate jutumärkide korral ei suuda DVK rakendus sõnumit töödelda ning tagastab veateate.

DVK päringud töötavad korrektselt näiteks järgmise päise korral:

<pre>
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; <b>type="text/xml";</b> start="<FC392E97EB481BFCEB435125AA3B5B51>";   boundary="----=_Part_0_20230270.1171971312715"
User-Agent: Axis/1.3
...
</pre>

DVK päringud ei tööta aga korrektselt näiteks järgmise päise korral:

<pre>
POST /cgi-bin/consumer_proxy HTTP/1.0
Content-Type: multipart/related; <b>type=text/xml;</b> start="<FC392E97EB481BFCEB435125AA3B5B51>";     boundary="----=_Part_0_20230270.1171971312715"
User-Agent: Axis/1.3
...
</pre>



Antud viga põhjustab Apache Axis 1.3 koosseisus kasutatav JavaMail teek, mis eeldab nimetatud jutumärkide olemasolu.



##LISA 1: Kasutatavate andmete XML Schema kirjeldused

Alates versioonist 1.6.0 on kasutusel uus versioon DVK konteinerist. Seoses uue versiooni kasutuselevõtuga tekkisid ka uued nimeruumid
manuaalsete metaandmete ja dokumenti kirjeldavate elementide jaoks. DVK konteineri uus versioon (2) töötab paralleelselt vanema versiooniga (1).
Olenevalt päringu versioonist on kasutusel kas DVK konteineri versioon 1 või 2.

###Automaatsed metaandmed
Automaatsete metaandmete koosseis ei muutunud seoses DVK konteineri versiooni 2 kasutuselevõtuga.

Nimeruumi väärtuseks on: *http://www.riik.ee/schemas/dhl-meta-automatic*

XML skeemifaili asukoht on:
*http://www.riik.ee/schemas/dhl/dhl-meta-automatic.xsd*

###Manuaalsed metaandmed
Manuaalsete metaandmete koosseis muutus seoses DVK konteineri versiooni 2 kasutuselevõtuga:

DVK konteineri versioon 1 puhul:

-   Nimeruumi väärtuseks on:  *http://www.riik.ee/schemas/dhl-meta-manual*
-   XML skeemifaili asukoht on: *http://www.riik.ee/schemas/dhl/dhl-meta-manual.xsd*

DVK konteineri versioon 2 puhul:

-   Nimeruumi väärtuseks on: *http://www.riik.ee/schemas/dhl-meta-manual/2010/r1*
-   XML skeemifaili asukoht on: *http://www.riik.ee/schemas/dhl/dhl-meta-manual.2010.r1.xsd*

###DVK dokument
Dokumendi andmete koosseis muutus seoses DVK konteineri versiooni 2 kasutuselevõtuga. Toimivad järgmised nimeruumid:

DVK konteineri versioon 1 puhul:

-   Nimeruumi väärtuseks on: *http://www.riik.ee/schemas/dhl*

-   XML skeemifaili asukoht on: *http://www.riik.ee/schemas/dhl/dhl.xsd*

DVK konteineri versioon 2 puhul:

-   Nimeruumi väärtuseks on: *http://www.riik.ee/schemas/dhl/2010/r1*

-   XML skeemifaili asukoht on:  *http://www.riik.ee/schemas/dhl/dhl.2010.r1.xsd*

###Päringute WSDL kirjeldus

Päringute WSDL kirjeldus asub failis dhl.wsdl. See fail asub DVK serveri paketis juurkaustas. SVN-is:
https://svn.eesti.ee/projektid/dvk/server/trunk/src/main/webapp/

##LISA 2: &lt;dokument&gt; XML struktuuri kasutusnäide (DVK konteineri versioon 1)

```xml
<dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl" dhl:schemaLocation=““>
  <dhl:metainfo xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic" ma:schemaLocation=“ http://www.riik.ee/schemas/dhl/dhl-meta-automatic.xsd“
 xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual" mm:schemaLocation=“ http://www.riik.ee/schemas/dhl/dhl-meta-manual.xsd“>

    <!— Seda osa pole ise vaja täita, selle täidab DVK väljuval sõnumil ise -->
    <ma:dhl_id>100</ma:dhl_id>
    <ma:dhl_saabumisviis>xtee</ma:dhl_saabumisviis>
    <ma:dhl_saabumisaeg>2006-03-16T14:11:23+02:00</ma:dhl_saabumisaeg>
    <ma:dhl_saatmisviis>xtee</ma:dhl_saatmisviis>
    <ma:dhl_saatmisaeg>2006-03-15T18:17:00+02:00</ma:dhl_saatmisaeg>
    <ma:dhl_saatja_asutuse_nr>12345678</ma:dhl_saatja_asutuse_nr>
    <ma:dhl_saatja_isikukood>37501010001</ma:dhl_saatja_isikukood>
    <ma:dhl_saaja_asutuse_nr>87654321</ma:dhl_saaja_asutuse_nr>
    <ma:dhl_saaja_isikukood>37005050005</ma:dhl_saaja_isikukood>
    <ma:dhl_saatja_epost>hunt.kriimsilm@kuivendus.ee</ma:dhl_saatja_epost>
    <ma:dhl_saaja_epost>karupoeg.puhh@vallavalitsus.ee</ma:dhl_saaja_epost>
    <ma:dhl_kaust>/KIRJAD</ma:dhl_kaust>
    <!— Automaatselt täidetava osa lõpp -->

    <mm:koostaja_asutuse_nr>12345678</mm:koostaja_asutuse_nr>
    <mm:saaja_asutuse_nr>87654321</mm:saaja_asutuse_nr>
    <mm:koostaja_dokumendinimi>Kaeveloa taotlus, H. Kriimsilm</mm:koostaja_dokumendinimi>
    <mm:koostaja_dokumendityyp>Taotlus</mm:koostaja_dokumendityyp>
    <mm:koostaja_dokumendinr>A-101</mm:koostaja_dokumendinr>
    <mm:koostaja_failinimi>taotlus_hkriimsilm_110306.doc</mm:koostaja_failinimi>
    <mm:koostaja_kataloog>/home/users/kriimsilm/dokumendid</mm:koostaja_kataloog>
    <mm:koostaja_votmesona>taotlus, kraav</mm:koostaja_votmesona>
    <mm:koostaja_kokkuvote>
      Kaeveloa taotlus 200m kraavi kaevamiseks kahe kinnistu
      piirile N maakonna X vallas.
    </mm:koostaja_kokkuvote>
    <mm:koostaja_kuupaev>2006-02-11T14:11:23+02:00</mm:koostaja_kuupaev>
    <mm:koostaja_asutuse_nimi>Kuivendusekspert OÜ</mm:koostaja_asutuse_nimi>
    <mm:koostaja_asutuse_kontakt>6 543 210</mm:koostaja_asutuse_kontakt>
    <mm:autori_osakond>Projekteerimisosakond</mm:autori_osakond>
    <mm:autori_isikukood>37501010001</mm:autori_isikukood>
    <mm:autori_nimi>Hunt Kriimsilm</mm:autori_nimi>
    <mm:autori_kontakt>56 123 456</mm:autori_kontakt>
    <mm:seotud_dokumendinr_koostajal>B-005</mm:seotud_dokumendinr_koostajal>
    <mm:seotud_dokumendinr_saajal>KT-2006-14</mm:seotud_dokumendinr_saajal>
    <mm:saatja_dokumendinr>A-101</mm:saatja_dokumendinr>
    <mm:saatja_kuupaev>2006-02-12T01:02:03+02:00</mm:saatja_kuupaev>
    <mm:saatja_asutuse_kontakt>6 543 210</mm:saatja_asutuse_kontakt>
    <mm:saaja_isikukood>37005050005</mm:saaja_isikukood>
    <mm:saaja_nimi>Karupoeg Puhh</mm:saaja_nimi>
    <mm:saaja_osakond>Maaparandusosakond</mm:saaja_osakond>
    <mm:saatja_defineeritud mm:valjanimi="PlaneeringuNr">1825/1</mm:saatja_defineeritud>
    <mm:saatja_defineeritud mm:valjanimi="EhitusloaNr">2005-195</mm:saatja_defineeritud>
  </dhl:metainfo>
  <dhl:transport>
    <dhl:saatja>
      <dhl:regnr>12345678</dhl:regnr>
      <dhl:isikukood>37501010001</dhl:isikukood>
      <dhl:ametikoha_kood>171</dhl:ametikoha_kood>
      <dhl:ametikoha_nimetus>Noorembrigadir</dhl:ametikoha_nimetus>
      <dhl:epost>hunt.kriimsilm@kuivendus.ee</dhl:epost>
      <dhl:nimi>Hunt Kriimsilm</dhl:nimi>
      <dhl:asutuse_nimi>Kuivendusekspert OÜ</dhl:asutuse_nimi>
      <dhl:allyksuse_kood>10</dhl:allyksuse_kood>
      <dhl:allyksuse_nimetus>Planeerimisosakond</dhl:allyksuse_nimetus>
      <dhl:osakonna_kood>1</dhl:osakonna_kood>
      <dhl:osakonna_nimi>Planeerimisosakond</dhl:osakonna_nimi>
    </dhl:saatja>
    <dhl:saaja>
      <dhl:regnr>87654321</dhl:regnr>
      <dhl:isikukood>37005050005</dhl:isikukood>
      <dhl:ametikoha_kood>411</dhl:ametikoha_kood>
      <dhl:ametikoha_kood>Peaspetsialist</dhl:ametikoha_kood>
      <dhl:epost>karupoeg.puhh@vallavalitsus.ee</dhl:epost>
      <dhl:nimi>Karupoeg Puhh</dhl:nimi>
      <dhl:asutuse_nimi>Vallavalitsus</dhl:asutuse_nimi>
      <dhl:allyksuse_kood>7</dhl:allyksuse_kood>
      <dhl:allyksuse_nimetus>Maaparandusosakond</dhl:allyksuse_nimetus>
      <dhl:osakonna_kood>MP</dhl:osakonna_kood>
      <dhl:osakonna_nimi>Maaparandusosakond</dhl:osakonna_nimi>
    </dhl:saaja>
  </dhl:transport>
  <dhl:ajalugu/>
  <dhl:metaxml xmlns="http://www.riik.ee/schemas/dhl/rkel_letter"
    schemaLocation="http://www.riik.ee/schemas/dhl/rkel_letter
    http://www.riik.ee/schemas/dhl/rkel_letter.xsd">
    <Addressees>
      <Addressee>
        <Organisation>
          <organisationName>Vallavalitsus</organisationName>
          <departmentName>Maaparandusosakond</departmentName>
        </Organisation>
        <Person>
          <firstname>Karupoeg</firstname>
          <surname>Puhh</surname>
          <jobtitle>Peaspetsialist</jobtitle>
          <email>karupoeg.puhh@vallavalitsus.ee</email>
          <telephone>53 535 353</telephone>
        </Person>
      </Addressee>
    </Addressees>
    <Author>
      <Organisation>
        <organisationName>Kuivendusekspert OÜ</organisationName>
        <departmentName>Planeerimisosakond</departmentName>
      </Organisation>
      <Person>
        <firstname>Hunt</firstname>
        <surname>Kriimsilm</surname>
        <jobtitle>Noorembrigadir</jobtitle>
        <email>hunt.kriimsilm@kuivendus.ee</email>
        <telephone>6 543 210</telephone>
      </Person>
    </Author>
    <Signatures>
      <Signature>
        <Person>
          <firstname>Krokodill</firstname>
          <surname>Gena</surname>
          <jobtitle>Tegevjuht</jobtitle>
          <email>krokodill.gena@kuivendus.ee</email>
          <telephone>6 543 200</telephone>
        </Person>
        <SignatureData>
          <SignatureDate>2006-03-11</SignatureDate>
          <SignatureTime>18:11:10</SignatureTime>
        </SignatureData>
      </Signature>
      <Signature>
        <Person>
          <firstname>Piilupart</firstname>
          <surname>Donald</surname>
          <jobtitle>Ehitusjärelvalve inspektor</jobtitle>
          <email>piilupart.donald@maavalitsus.ee</email>
          <telephone>77 43 210</telephone>
        </Person>
        <SignatureData>
          <SignatureDate>2006-03-14</SignatureDate>
          <SignatureTime>23:59:59</SignatureTime>
        </SignatureData>
      </Signature>
    </Signatures>
    <Compilators>
      <Compilator>
        <firstname>Hunt</firstname>
          <surname>Kriimsilm</surname>
          <jobtitle>Noorembrigadir</jobtitle>
          <email>hunt.kriimsilm@kuivendus.ee</email>
          <telephone>6 543 210</telephone>
        </Compilator>
      </Compilators>
      <LetterMetaData>
        <SignDate>2006-02-11</SignDate>
        <SenderIdentifier>A-101</SenderIdentifier>
        <OriginalIdentifier>A-101</OriginalIdentifier>
        <Type>Taotlus</Type>
        <Language>Eesti keel</Language>
        <Title>Kaeveloa taotlus, H. Kriimsilm</Title>
        <Deadline>2006-04-20</Deadline>
        <Enclosures>
          <EnclosureTitle>Kraavi projekt</EnclosureTitle>
          <EnclosureTitle>Ehitusjärelvalve osakonna luba</EnclosureTitle>
        </Enclosures>
        <AccessRights>
          <Restriction>Asutusesiseseks kasutamiseks</Restriction>
          <BeginDate>2006-03-16</BeginDate>
          <EndDate>2011-03-16</EndDate>
          <Reason>Seadus §67 lg. 3</Reason>
        </AccessRights>
      </LetterMetaData>
    </dhl:metaxml>
    <SignedDoc/>
</dhl:dokument>
```

##LISA 3: &lt;dokument&gt; XML struktuuri kasutusnäide (DVK konteineri versioon 2)

```xml
<dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl/2010/r1" dhl:schemaLocation=“http://www.riik.ee/schemas/dhl.2010.r1.xsd“>
    <dhl:metainfo xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic" ma:schemaLocation=“ http://www.riik.ee/schemas/dhl/dhl-meta-automatic.2010.r1.xsd“
 xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual" mm:schemaLocation=“ http://www.riik.ee/schemas/dhl/dhl-meta-manual.2010.r1.xsd“>
        <mm:koostaja_asutuse_nr>87654321</mm:koostaja_asutuse_nr>
        <mm:saaja_asutuse_nr>99954321</mm:saaja_asutuse_nr>
        <mm:koostaja_dokumendinimi>Avaldus üritus</mm:koostaja_dokumendinimi>
        <mm:koostaja_dokumendityyp>Avaldus</mm:koostaja_dokumendityyp>
        <mm:koostaja_dokumendinr>A-101</mm:koostaja_dokumendinr>
        <mm:koostaja_failinimi>document.doc</mm:koostaja_failinimi>
        <mm:koostaja_kataloog>C:\Dokumendid</mm:koostaja_kataloog>
        <mm:koostaja_votmesona>avaldus</mm:koostaja_votmesona>
        <mm:koostaja_kokkuvote>Avaldus massiürituse korraldamiseks</mm:koostaja_kokkuvote>
        <mm:koostaja_kuupaev>2006-02-11T14:11:23+02:00</mm:koostaja_kuupaev>
        <mm:koostaja_asutuse_nimi>Asutus AS</mm:koostaja_asutuse_nimi>
        <mm:koostaja_asutuse_kontakt>Lauteri 21a</mm:koostaja_asutuse_kontakt>
        <mm:autori_osakond>Haldusosakond</mm:autori_osakond>
        <mm:autori_isikukood>45604020013</mm:autori_isikukood>
        <mm:autori_nimi>Jaana Lind</mm:autori_nimi>
        <mm:autori_kontakt>51 22 762</mm:autori_kontakt>
        <mm:seotud_dokumendinr_koostajal>XY-123</mm:seotud_dokumendinr_koostajal>
        <mm:seotud_dokumendinr_saajal>?Õ-ZŠ//Ä</mm:seotud_dokumendinr_saajal>
        <mm:saatja_dokumendinr>AB-123</mm:saatja_dokumendinr>
        <mm:saatja_kuupaev>2006-02-12T01:02:03+02:00</mm:saatja_kuupaev>
        <mm:saatja_asutuse_kontakt>Pärnu mnt. 176a</mm:saatja_asutuse_kontakt>
        <mm:saaja_isikukood>38802280237</mm:saaja_isikukood>
        <mm:saaja_nimi>Eino Muidugi</mm:saaja_nimi>
        <mm:saaja_osakond>Sanitaarosakond</mm:saaja_osakond>
        <mm:saatja_defineeritud mm:valjanimi="Koosolekul osaleja 1">Aksel</mm:saatja_defineeritud>
        <mm:saatja_defineeritud mm:valjanimi="Koosolekul osaleja 2">Heldur</mm:saatja_defineeritud>
        <mm:saatja_defineeritud mm:valjanimi="Koosolekul osaleja 3">Mari</mm:saatja_defineeritud>
        <mm:saatja_defineeritud mm:valjanimi="Koosolekul osaleja 4">Loreida</mm:saatja_defineeritud>
        <mm:test>false</mm:test>
        <mm:dokument_liik>Kiri</mm:dokument_liik>
        <mm:dokument_keel>Eesti</mm:dokument_keel>
        <mm:dokument_pealkiri>Test dokument</mm:dokument_pealkiri>
        <mm:versioon_number>1</mm:versioon_number>
        <mm:dokument_guid>cd171f7c-560d-4a62-8d65-16b87419a58c</mm:dokument_guid>
        <mm:dokument_viit>1.2/4-6</mm:dokument_viit>
        <mm:kuupaev_registreerimine>2010-02-12T01:02:03+02:00</mm:kuupaev_registreerimine>
        <mm:kuupaev_saatmine>2010-02-14T01:02:03+02:00</mm:kuupaev_saatmine>
        <mm:tahtaeg>2010-02-28T01:02:03+02:00</mm:tahtaeg>
        <mm:saatja_kontekst>
          <mm:seosviit>1.1/5-7</mm:seosviit>
          <mm:kuupaev_saatja_registreerimine>2010-02-04T01:02:03+02:00</mm:kuupaev_saatja_registreerimine>
          <mm:dokument_saatja_guid>17084b40-08f5-4bcd-a739-c0d08c176bad</mm:dokument_saatja_guid>
        </mm:saatja_kontekst>
        <mm:ipr>
          <mm:ipr_tahtaeg>2012-01-01T00:00:00+02:00</mm:ipr_tahtaeg>
          <mm:ipr_omanik></mm:ipr_omanik>
          <mm:reprodutseerimine_keelatud>true</mm:reprodutseerimine_keelatud>
        </mm:ipr>
        <mm:juurdepaas_piirang>
          <mm:piirang>Salastatud</mm:piirang>
          <mm:piirang_algus>2009-01-01T00:00:00+02:00</mm:piirang_algus>
          <mm:piirang_lopp>2020-01-01T00:00:00+02:00</mm:piirang_lopp>
          <mm:piirang_alus>Riigisaladus</mm:piirang_alus>
        </mm:juurdepaas_piirang>
        <mm:koostajad>
          <mm:koostaja>
            <mm:eesnimi>Marko</mm:eesnimi>
            <mm:perenimi>Kurm</mm:perenimi>
            <mm:ametinimetus>Arendaja</mm:ametinimetus>
            <mm:epost>marko.kurm@microlink.ee</mm:epost>
            <mm:telefon>543322556</mm:telefon>
          </mm:koostaja>
        </mm:koostajad>
    </dhl:metainfo>
    <dhl:transport>
        <dhl:saatja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:nimi>Jaak Lember</dhl:nimi>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:ametikoha_nimetus>Insenser</dhl:ametikoha_nimetus>
            <dhl:ametikoha_lyhinimetus>INSENER</dhl:ametikoha_lyhinimetus>
            <dhl:allyksuse_nimetus>Sepikoda</dhl:allyksuse_nimetus>
            <dhl:allyksuse_lyhinimetus>SEPIKODA</dhl:allyksuse_lyhinimetus>
        </dhl:saatja>
        <dhl:saaja>
            <dhl:regnr>99954321</dhl:regnr>
            <dhl:asutuse_nimi>Maa-amet</dhl:asutuse_nimi>
            <dhl:allyksuse_lyhinimetus>SEPIKODA</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Sepikoda</dhl:allyksuse_nimetus>
            <dhl:teadmiseks>teadmiseks</dhl:teadmiseks>
            <dhl:ametikoha_nimetus>Sepp</dhl:ametikoha_nimetus>
            <dhl:ametikoha_lyhinimetus>SEPP</dhl:ametikoha_lyhinimetus>
        </dhl:saaja>
    </dhl:transport>
    <dhl:ajalugu/>
    <dhl:metaxml>
        ...
    </dhl:metaxml>
    <dhl:failid>
      <dhl:kokku>1</dhl:kokku>
      <dhl:fail>
        <dhl:jrknr>1</dhl:jrknr>
        <dhl:fail_pealkiri>Test dokument</dhl:fail_pealkiri>
        <dhl:fail_suurus>779</dhl:fail_suurus>
        <dhl:fail_tyyp>text/plain</dhl:fail_tyyp>
        <dhl:fail_nimi>testdoc.txt</dhl:fail_nimi>
        <dhl:zip_base64_sisu>...</dhl:zip_base64_sisu>
        <dhl:krypteering>false</dhl:krypteering>
        <dhl:pohi_dokument>true</dhl:pohi_dokument>
      </dhl:fail>
    </dhl:failid>
    <dhl:konteineri_versioon>2</dhl:konteineri_versioon>
</dhl:dokument>
```
