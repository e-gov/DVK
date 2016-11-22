# Sisukord
- [Testimise strateegia](#test-strateegia)
- [Testilood](#tests)
	- [1. DHX protokolli teenuste testimine](#dhx-tests)
		- [1.1 Õige kapsli saatmine](#1.1)
		- [1.2.	Õige kapsli saatmine alamsüsteemile](#1.2)
		- [1.3.	Vale kapsli saatmine](#1.3)
		- [1.4.	Faili saatmine (fail ei ole kapsel)](#1.4)
		- [1.5.	Duplikaadi kontroll](#1.5)
		- [1.6.	Valele adressaadile saatmine](#1.6)
		- [1.7.	Vahendatavate nimekirja küsimine DVK-st.](#1.7)
		- [1.8.	DVK süsteemist tulnud dokumentide vastuvõtmine](#1.8)
		- [1.9.	Õige kapsli saatmine. Adressat toetab ainult 1.0 kapsli versiooni](#1.9)
		- [1.10.	Õige kapsli saatmine. Kapslis on määratud ’ARVED’ kaust.](#1.10)
	- [2. DVK protokolli teenuste testimine.](#dvk-tests)
		- [2.1. Õige kapsli saatmine](#2.1)
		- [2.2.	Vale kapsli saatmine](#2.2)
		- [2.3.	Faili saatmine (fail ei ole kapsel)](#2.3)
		- [2.4.	Vahendatavale saatmine](#2.4)
		- [2.5.	Valele adressaadile saatmine](#2.5)
		- [2.6.	DHX süsteemist tulnud dokumendi vastuvõtmine](#2.6)
		- [2.7.	DHX süsteemist tulnud dokumendi vastuvõetuks märkimine](#2.7)
		- [2.8.	DHX süsteemist tulnud dokumendi vastuvõtmine. Dokument on suunatud alamsüsteemile.](#2.8)
		- [2.9. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine.  Dokument on suunatud alamsüsteemile.](#2.9)
		- [2.10. DVK adressaatide nimekirja pärimine.](#2.10)
		- [2.11. DHX-i saadetud dokumendi staatuse pärimine(saatmine õnnestus)](#2.11)
		- [2.12. DHX-i saadetud dokumendi staatuse pärimine(saatmine ebaõnnestus, adressaat ei ole üleval)](#2.12)
		- [2.13. Õige kapsli saatmine DHX alamsüsteemile(DHX. prefiksiga X-tee alamsüsteemile)](#2.13)
		- [2.14. Vana kapsli(korrektselt kapseldatud fail 1.0) saatmine DHX adressaadile](#2.14)
		- [2.15. DHX süsteemist tulnud dokumendi vastuvõtmine. Adressat toetab ainult 1.0 kapsli versiooni](#2.15)
		- [2.16. DHX süsteemist tulnud dokumendi  vastuvõetuks märkimine. Adressat toetab ainult 1.0 kapsli versiooni](#2.16)
		- [2.17. DHX süsteemist tulnud dokumendi vastuvõtmine ’ARVED’ kaustast.](#2.17)
		- [2.18. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine. Dokument on ’ARVED’ kaustas.](#2.18)
	- [3. DHX makettrakenduse testid](#dhx-makett-tests)
	 	- [3.1.	Õige kapsli saatmine](#3.1)
		- [3.2.	Vale kapsli saatmine](#3.2)
		- [3.3.	Faili saatmine (fail ei ole kapsel)](#3.3)
		- [3.4.	Duplikaadi kontroll](#3.4)
		- [3.5.	DVK süsteemist tulnud dokumendi vastuvõtmine](#3.5)
- [Testplaan](#testplaan)

<a name="test-strateegia"></a>
# Testimise strateegia

Käesolev dokument määratleb seoses DHX protokolli kasutuselevõtmisega DVK-s teostatavate muudatuste testimise ulatuse, korralduse ja üksikasjad. DVK-s teostatud muudatuste testimiseks tehakse otse SOAP päringud DVK-sse (nii vastavalt DHX protokollile kui ka vastavalt DVK protokollile). SOAP päringute tegemiseks on soovitatav kasutada SOAP UI-d.

Iga punkti 1 ja punkti 2 testloo juures on olemas näidis-XML, mida võib kasutada testimiseks. Enne XML-i saatmist tuleb veenduda ja vajadusel muuta XML-i header-i _service_ ja _client_ elemendid, täites neid vajalikute andmetega (saatva süsteemi ja adressaadi andmetega). Juhul kui XML-i keha enne saatmist vajab muutmist, siis vastav info on kajastatud testiloos.  SOAP päringu saatmisel tuleb veenduda et päring saadetakse õigele X-tee turvaserverile (saatva süsteemi turvaserverile). Lisaks juhul kui testiloo käigus saadedakse kapsli, siis tuleb veenduda et kapsli adresssaat ja kapsli saatja on õiged(vastavad testiloos kirjeldatud saatja süsteemile ja kapsli adressadile).

<a name="tests"></a>
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


<a name="dhx-tests"></a>
## 1. DHX protokolli teenuste testimine

<a name="1.1"></a>
### 1.1. Õige kapsli saatmine
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline)**:

- Testija saadab päringu DVK teenusesse sendDocument
  - Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
  - SOAP päringu manuseks tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna &#39;doc&#39;.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas receiptId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
         <prod:consignmentId>72c9ef5d-034f-4932-a735-203daf33bfb0</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope>
```

#### **Manus:**
```xml
<DecContainer xmlns=3D"http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
=09<DecRecipient><OrganisationCode>70006317</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infos=C4=86=C2=BCsteemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA<=
/ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer> 
```

<a name="1.2"></a>
### 1.2. Õige kapsli saatmine alamsüsteemile
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3-e DVK-s asutusena registreeritud alamsüsteemi nimi
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
Märkus: Vajadusel (juhul kui testi tehakse mitte selle adressaadiga, kelle andmed on esitatud näites) tuleb muuta ka  recipient ja recipientSystem(asutuse alamsüsteem) elemendid XML-i kehas.
	- SOAP päringu manuseks tuleb panna korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.


#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas receiptId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
           <prod:recipientSystem>adit</prod:recipientSystem>
         <prod:consignmentId>5f25e335-0c0b-4483-abd0-8fc3a8713567</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient><OrganisationCode>adit</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi InfosÄ†Ā¼steemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="1.3"></a>
### 1.3. Vale kapsli saatmine
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3
   **Saadetis** : kapsli fail, mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 (nt puudu kohustuslik väli), aga on XML formaadis fail õige XML vorminguga.
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manuseks  tuleb lisada kapsli fail, mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 (nt puudu kohustuslik väli), aga on XML fail õige XML vorminguga. Manuse ContentId-na tuleb panna 'doc'.


#### **Oodatav tulemus** :

- sendDocument päringu vastuses on DHX.Validation koodiga fault

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
         <prod:consignmentId>1e9d2271-a2f2-42c4-9345-6ff22d1ee856</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi InfosÄ†Ā¼steemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="1.4"></a>
### 1.4. Faili saatmine (fail ei ole kapsel)
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3
   **Saadetis** : fail, mis ei ole XML või XML vale vorminguga.
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manusena tuleb panna fail, mis ei ole XML või XML vale vorminguga. Manuse ContentId-na tuleb panna 'doc'.


#### **Oodatav tulemus** :

- sendDocument päringu vastuses on DHX.Validation koodiga fault

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
         <prod:consignmentId>b9b8d1cb-6cd9-40bb-96f8-30e9fb55d4f2</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope>
```

#### **Manus:**
```xml
Test fail.
```
<a name="1.5"></a>
### 1.5. Duplikaadi kontroll
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **  Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu väärtusega, millisega on eelnevalt dokument juba saadetud.
	- SOAP päringu manuseks tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.


#### **Oodatav tulemus** :

- sendDocument päringu vastuses on DHX.Duplicate koodiga fault

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
         <prod:consignmentId>08a8e6d5-c63c-47d8-8b28-f1faeba803c3</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient><OrganisationCode>70006317</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi InfosÄ†Ā¼steemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="1.6"></a>
### 1.6. Valele adressaadile saatmine
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : puudu olev adressaat
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu vastuses on DHX.InvalidAddressee koodiga fault

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>test</prod:recipient>
         <prod:consignmentId>8287747c-7f80-480e-ba34-1577a6a62f31</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient><OrganisationCode>70006317</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri TammemÄ†Ā¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>TammemÄ†Ā¤e</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>MustamÄ†Ā¤e linnaosa</AdministrativeUnit>
        <SmallPlace>PÄ†Ā¤Ä†Ā¤sukese KÄ†ļæ½</SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamÄ†Ā¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi InfosÄ†Ā¼steemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="1.7"></a>
### 1.7. Vahendatavate nimekirja küsimine DVK-st.
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : 
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse representationList


#### **Oodatav tulemus** :

- representationList päringu saatmisel vigu ei tekkinud ja päringu vastuses on kõik teada olevad DHX protokolli kasutatavad asutused olemas.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>representationList</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:representationList>
      </prod:representationList>
   </soapenv:Body>
</soapenv:Envelope>
```

<a name="1.8"></a>
### 1.8. DVK süsteemist tulnud dokumentide vastuvõtmine
<pre>

   **Saatev süsteem** : 
   **Kapsli adressaat** : DHS 2
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija täidab testi 2.1
- Testija veendub et eelmises sammus saadetud dokument jõudis DHS 2 süsteemi, ehk DVK poolt oli tehtud DHS 2 sendDocument teenuse väljakutse ja vastu võetud kapsel on õige.
Märkus: kui testimisel kasutatakse DHX etalonteostuses tehtud DHS maketti, siis vastav info võib leida vastuvõtva maketti sündmuste logis.

#### **Oodatav tulemus** :

- oli tehtud adressaadi sendDocument teenuse väljakutse ja vastu võetud kapsel on õige

<a name="1.9"></a>
### 1.9. Õige kapsli saatmine. Adressat toetab ainult 1.0 kapsli versiooni
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 4
   **Saadetis** : korrektselt kapseldatud fail 1.0
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manuseks tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas receiptId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>11181967</prod:recipient>
         <prod:consignmentId>6628f47e-89fa-488c-b1db-f8e1246cd731</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns=3D"http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
=09<DecRecipient><OrganisationCode>11181967</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infos=C4=86=C2=BCsteemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA<=
/ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="1.10"></a>
### 1.10. Õige kapsli saatmine. Kapslis on määratud ’ARVED’ kaust.
<pre>

   **Saatev süsteem** : DHS 1
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manuseks tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas receiptId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xro="http://x-road.eu/xsd/xroad.xsd" xmlns:iden="http://x-road.eu/xsd/identifiers" xmlns:prod="http://dhx.x-road.eu/producer">
   <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
    <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>COM</ns3:memberClass>
      <ns3:memberCode>30000001</ns3:memberCode>
      <ns3:subsystemCode>DHX</ns3:subsystemCode>
    </ns4:client>
    <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>DHX.dvk</ns3:subsystemCode>
      <ns3:serviceCode>sendDocument</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <prod:sendDocument>
         <!--Optional:-->
          <prod:DHXVersion>1.0</prod:DHXVersion>
         <prod:documentAttachment>cid:doc</prod:documentAttachment>
           <prod:recipient>70006317</prod:recipient>
         <prod:consignmentId>e8030d31-a501-43a8-8933-f26d1b8b4b47</prod:consignmentId>
      </prod:sendDocument>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns=3D"http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>30000001</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
=09<DecRecipient><OrganisationCode>70006317</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUni=
t>
        <SmallPlace>Pääsukese KÜ</Small=
Place>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infos=C4=86=C2=BCsteemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA<=
/ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>ARVED</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer> 
```
<a name="dvk-tests"></a>
## 2. DVK protokolli teenuste testimine.

<a name="2.1"></a>
### 2.1. Õige kapsli saatmine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 2
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas dhlId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender>
      <OrganisationCode>70006317</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient>
      <OrganisationCode>30000001</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
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
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamĆ¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>30000001</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="2.2"></a>
### 2.2. Vale kapsli saatmine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 2
   **Saadetis** : kapsli fail, mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 (nt puudu kohustuslik väli), aga on XML fail õige XML vorminguga
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb lisada kapsli fail, mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 (nt puudu kohustuslik väli), aga on XML fail õige XML vorminguga. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

-  sendDocument päringu saatmisel tekkis viga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>MustamĆ¤e tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>30000001</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```

<a name="2.3"></a>
### 2.3. Faili saatmine (fail ei ole kapsel)
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 2
   **Saadetis** : fail mis ei ole XML või XML vale vorminguga.
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-   Testija saadab päringu DVK teenusesse sendDocument
	- Testija asendab sendDocument päringu XML-i kehas consignmentId elemendi sisu unikaalse id-ga(näiteks suvalise tekstiga).
	- SOAP päringu manusena tuleb lisada fail,  mis ei ole XML või XML vale vorminguga. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

-  sendDocument päringu saatmisel tekkis viga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
       <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/test</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
Test fail.
```
<a name="2.4"></a>
### 2.4. Vahendatavale saatmine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : Üks DHS 2 vahendatavatest
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

-  sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas dhlId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/test</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender><OrganisationCode>70006317</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient><OrganisationCode>70000001</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri TammemĆ¤e</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>70006317</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="2.5"></a>
### 2.5. Valele adressaadile saatmine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : Puudu olev asutus
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-   Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb panna korrektselt kapseldatud faili. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel tekkis viga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/test</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender>
      <OrganisationCode>70006317</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient>
      <OrganisationCode>wrong</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>wrong</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="2.6"></a>
### 2.6. DHX süsteemist tulnud dokumendi vastuvõtmine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.1
- Testija saadab päringu DVK teenusesse receiveDocuments

#### **Oodatav tulemus** :

-  receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element. Manuses oleva faili sees on olemas esimeses sammus saadetud dokument.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://localhost:8084/dvk/services/dhlHttpSoapPort">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
     <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>receiveDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
    <ns4:userId xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">EE38806190294
    </ns4:userId>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:receiveDocuments soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <keha xsi:type="xsd:anyType">
         <arv>50</arv>
         </keha>
      </dhl:receiveDocuments>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.7"></a>
### 2.7. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : 
   **Saadetis** : 
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.1
- Testija saadab päringu DVK teenusesse markDocumentReceived.v3
	- Testija asendab markDocumentReceived päringu XML-i kehas dhlId elemendi sisu dokumendi saatmisel (test 1.1) saadud ID-ga.

#### **Oodatav tulemus** :

- receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element 'OK' sisuga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
       <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>markDocumentsReceived</ns3:serviceCode>
      <ns3:serviceVersion>v3</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:markDocumentsReceived>
         <keha>
            <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>14320</dhl_id>
        </item>
      </dokumendid>
         </keha>
      </dhl:markDocumentsReceived>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.8"></a>
### 2.8. DHX süsteemist tulnud dokumendi vastuvõtmine. Dokument on suunatud alamsüsteemile.
<pre>

   **Saatev süsteem** : DHS 3 alamsüsteem
   **Kapsli adressaat** : 
   **Saadetis** : 
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.2
- Testija saadab päringu DVK teenusesse receiveDocuments

#### **Oodatav tulemus** :

-  receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element. Manuses oleva faili sees on olemas esimeses sammus saadetud dokument.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://localhost:8084/dvk/services/dhlHttpSoapPort">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>adit</ns3:subsystemCode>

    </ns4:client>
     <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>receiveDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
    <ns4:userId xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">EE38806190294
    </ns4:userId>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:receiveDocuments soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <keha xsi:type="xsd:anyType">
         <arv>50</arv>
         </keha>
      </dhl:receiveDocuments>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.9"></a>
### 2.9. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine.  Dokument on suunatud alamsüsteemile.
<pre>

   **Saatev süsteem** : DHS 3 alamsüsteem
   **Kapsli adressaat** : 
   **Saadetis** : 
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.2
- Testija saadab päringu DVK teenusesse markDocumentReceived.v3
	- Testija asendab markDocumentReceived päringu XML-i kehas dhlId elemendi sisu dokumendi saatmisel (test 1.2) saadud ID-ga.

#### **Oodatav tulemus** :

- receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element 'OK' sisuga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>adit</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>markDocumentsReceived</ns3:serviceCode>
      <ns3:serviceVersion>v3</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:markDocumentsReceived>
         <keha>
            <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>14321</dhl_id>
        </item>
      </dokumendid>
         </keha>
      </dhl:markDocumentsReceived>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.10"></a>
### 2.10. DVK adressaatide nimekirja pärimine.
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija saadab päringu DVK teenusesse getSendingOptions.v1

#### **Oodatav tulemus** :

-  getSendingOptions päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas nii otse DVK-t kasutatavad asutused kui ka DHX-i kasutatavad asutused.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>getSendingOptions</ns3:serviceCode>
      <ns3:serviceVersion>v2</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>

   <soapenv:Body>
      <dhl:getSendingOptions soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <keha xsi:type="xsd:anyType"></keha>
      </dhl:getSendingOptions>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.11"></a>
### 2.11. DHX-i saadetud dokumendi staatuse pärimine(saatmine õnnestus)
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija täidab testi 2.1 
- Testija saadab päringu DVK teenusesse getSendStatus.v2
	- Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip). Manuse sisu näidises tuleb muuta dhl_id, kodeerida base64 kodeeringus ja siis lisada SOAP päringu manusena. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- getSendStatus päringu saatmisel vigu ei tekkinud ja päringu vastuses olemas  manus. Manuses sisus olemas õige dokumendi olek(vastuvõetud).
	- Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip). Manust tuleb esiteks dekodeerida et sisu saaks lugeda. 

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>adit</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>getSendStatus</ns3:serviceCode>
      <ns3:serviceVersion>v2</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
  <dhl:getSendStatus>
    <keha>
      <dokumendid href="cid:doc"/>
      <staatuse_ajalugu>false</staatuse_ajalugu>
      </keha>
  </dhl:getSendStatus>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<item> <dhl_id>14322</dhl_id></item>
```
<a name="2.12"></a>
### 2.12. DHX-i saadetud dokumendi staatuse pärimine(saatmine ebaõnnestus, adressaat ei ole üleval)
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 1
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.
- Testija saadab päringu DVK teenusesse getSendStatus.v2
	- Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip). Manuse sisu näidises tuleb muuta dhl_id, kodeerida base64 kodeeringus ja siis lisada SOAP päringu manusena. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- getSendStatus päringu saatmisel vigu ei tekkinud ja päringu vastuses olemas  manus. Manuses sisus olemas õige dokumendi olek(tagasi lükatud).
	- Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip). Manust tuleb esiteks dekodeerida et sisu saaks lugeda. 

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>adit</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>getSendStatus</ns3:serviceCode>
      <ns3:serviceVersion>v2</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
  <dhl:getSendStatus>
    <keha>
      <dokumendid href="cid:doc"/>
      <staatuse_ajalugu>false</staatuse_ajalugu>
      </keha>
  </dhl:getSendStatus>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml

```
<a name="2.13"></a>
### 2.13. Õige kapsli saatmine DHX alamsüsteemile(DHX. prefiksiga X-tee alamsüsteemile)
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 2-e DVK-s asutusena registreeritud alamsüsteem
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija saadab päringu DVK teenusesse sendDocuments.v4
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas dhlId

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
</soapenv:Envelope> 
```

#### **Manus:**
```xml
<DecContainer xmlns="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
  <Transport>
    <DecSender>
      <OrganisationCode>70006317</OrganisationCode>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
    </DecSender>
	<DecRecipient>
      <OrganisationCode>subsystem.40000001</OrganisationCode>
    </DecRecipient>
  </Transport>
  <RecordCreator>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordCreator>
  <RecordSenderToDec>
    <Person>
      <Name>Lauri Tammemäe</Name>
      <GivenName>Lauri</GivenName>
      <Surname>Tammemäe</Surname>
      <PersonalIdCode>EE38806190294</PersonalIdCode>
      <Residency>EE</Residency>
    </Person>
    <ContactData>
      <Adit>1</Adit>
      <Phone>3726630276</Phone>
      <Email>lauri.tammemae@ria.ee</Email>
      <WebPage>www.hot.ee/lauri</WebPage>
      <MessagingAddress>skype: lauri.tammemae</MessagingAddress>
      <PostalAddress>
        <Country>Eesti</Country>
        <County>Harju maakond</County>
        <LocalGovernment>Tallinna linn</LocalGovernment>
        <AdministrativeUnit>Mustamäe linnaosa</AdministrativeUnit>
        <SmallPlace> Pääsukese KÜ </SmallPlace>
        <LandUnit></LandUnit>
        <Street>Mustamäe tee</Street>
        <HouseNumber>248</HouseNumber>
        <BuildingPartNumber>62</BuildingPartNumber>
        <PostalCode>11212</PostalCode>
      </PostalAddress>
    </ContactData>
  </RecordSenderToDec>
  <Recipient>
    <Organisation>
      <Name>Riigi Infosüsteemi Amet</Name>
      <OrganisationCode>subsystem.40000001</OrganisationCode>
      <Residency>EE</Residency>
    </Organisation>
  </Recipient>
  <RecordMetadata>
    <RecordGuid>25892e17-80f6-415f-9c65-7395632f0234</RecordGuid>
    <RecordType>Kiri</RecordType>
    <RecordOriginalIdentifier>213465</RecordOriginalIdentifier>
    <RecordDateRegistered>2012-11-11T19:18:03</RecordDateRegistered>
    <RecordTitle>Ettepanek</RecordTitle>
    <RecordLanguage>EE</RecordLanguage>
  </RecordMetadata>
  <Access>
    <AccessConditionsCode>Avalik</AccessConditionsCode>
  </Access>
  <File>
    <FileGuid>25892e17-80f6-415f-9c65-7395632f0001</FileGuid>
    <RecordMainComponent>1</RecordMainComponent>
    <FileName>Ettepanek.txt</FileName>
    <MimeType>text/plain</MimeType>
    <FileSize>78</FileSize>
    <ZipBase64Content>H4sIACvlpU0AAwspqszMS1coyVcoTs1LUUjJT+YCALD0cp8TAAAA</ZipBase64Content>
  </File>
  <RecordTypeSpecificMetadata />
  <DecMetadata>
    <DecId>410125</DecId>
    <DecFolder>test</DecFolder>
    <DecReceiptDate>2012-11-11T19:20:42</DecReceiptDate>
  </DecMetadata>
</DecContainer>
```
<a name="2.14"></a>
### 2.14. Vana kapsli(korrektselt kapseldatud fail 1.0) saatmine DHX adressaadile
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** : DHS 2
   **Saadetis** : korrektselt kapseldatud fail 1.0
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija saadab päringu DVK teenusesse sendDocuments.v1
	- SOAP päringu manusena tuleb lisada korrektselt kapseldatud fail 1.0. Manuse ContentId-na tuleb panna 'doc'.

#### **Oodatav tulemus** :

- sendDocument päringu saatmisel tekkis viga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xtee="http://x-tee.riik.ee/xsd/xtee.xsd" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>sendDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v1</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:sendDocuments>
         <keha>
            <dokumendid href="cid:doc"></dokumendid>
            <kaust>/</kaust>
         </keha>
      </dhl:sendDocuments>
   </soapenv:Body>
```

#### **Manus:**
```xml
<dokument xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl">
    <metainfo/>
    <transport>
        <saatja>
            <regnr>70006317</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saatja>
        <saaja>
            <regnr>30000001</regnr>
            <nimi>String</nimi>
            <osakonna_kood>String</osakonna_kood>
            <osakonna_nimi>String</osakonna_nimi>
        </saaja>
        <saaja>
            <regnr>30000001</regnr>
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
<a name="2.15"></a>
### 2.15. DHX süsteemist tulnud dokumendi vastuvõtmine. Adressat toetab ainult 1.0 kapsli versiooni
<pre>

   **Saatev süsteem** : DHS 4
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija täidab testi 1.10
- Testija saadab päringu DVK teenusesse receiveDocuments

#### **Oodatav tulemus** :

- receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element. Manuses oleva faili sees on olemas dokument mis vastab Elektroonilise andmevahetuse metaandmete loendile 1.0(testis 1.10 oli saadetud dokument mis vastab Elektroonilise andmevahetuse metaandmete loendile 2.1). 
Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip).

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://localhost:8084/dvk/services/dhlHttpSoapPort">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
     <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>receiveDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
    <ns4:userId xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">EE38806190294
    </ns4:userId>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:receiveDocuments soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <keha xsi:type="xsd:anyType">
         <arv>50</arv>
         </keha>
      </dhl:receiveDocuments>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.16"></a>
### 2.16. DHX süsteemist tulnud dokumendi  vastuvõetuks märkimine. Adressat toetab ainult 1.0 kapsli versiooni
<pre>

   **Saatev süsteem** : DHS 4
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija täidab testi 1.10
- Testija saadab päringu DVK teenusesse markDocumentReceived.v3
	- Testija asendab markDocumentReceived päringu XML-i kehas dhlId elemendi sisu dokumendi saatmisel (test 1.1) saadud ID-ga.

#### **Oodatav tulemus** :

- receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element 'OK' sisuga.

#### **Päringu näide:**
```xml

<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
       <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>markDocumentsReceived</ns3:serviceCode>
      <ns3:serviceVersion>v3</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:markDocumentsReceived>
         <keha>
            <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>14353</dhl_id>
        </item>
      </dokumendid>
         </keha>
      </dhl:markDocumentsReceived>
   </soapenv:Body>
</soapenv:Envelope>
```

<a name="2.17"></a>
### 2.17. DHX süsteemist tulnud dokumendi vastuvõtmine ’ARVED’ kaustast.
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.10
- Testija saadab päringu DVK teenusesse receiveDocuments

#### **Oodatav tulemus** :

-  receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element. Manuses oleva faili sees on olemas esimeses sammus saadetud dokument.
Märkus: manuses olev fail on kodeeritud kujul(base64 ja gZip).

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://localhost:8084/dvk/services/dhlHttpSoapPort">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
     <ns4:service xmlns:ns2="http://dhx.x-road.eu/producer"
      xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd"
      xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
      ns3:objectType="SERVICE">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>receiveDocuments</ns3:serviceCode>
      <ns3:serviceVersion>v4</ns3:serviceVersion>
    </ns4:service>
    <ns4:userId xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers"
      xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">EE38806190294
    </ns4:userId>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:receiveDocuments soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <keha xsi:type="xsd:anyType">
         <kaust>ARVED</kaust>
         <arv>50</arv>
         </keha>
      </dhl:receiveDocuments>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="2.18"></a>
### 2.18. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine. Dokument on ’ARVED’ kaustas. 
<pre>

   **Saatev süsteem** : DHS 3
   **Kapsli adressaat** :
   **Saadetis** :
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

-  Testija täidab testi 1.10
- Testija saadab päringu DVK teenusesse markDocumentReceived.v3
	- Testija asendab markDocumentReceived päringu XML-i kehas dhlId elemendi sisu dokumendi saatmisel (test 1.10) saadud ID-ga.

#### **Oodatav tulemus** :

- receiveDocuments päringu saatmisel vigu ei tekkinud ja päringu vastuses on olemas keha element 'OK' sisuga.

#### **Päringu näide:**
```xml
<soapenv:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dhl="http://producers.dhl.xtee.riik.ee/producer/dhl" xmlns:xsi="xsi">
    <soapenv:Header>
       <ns4:protocolVersion xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">4.0</ns4:protocolVersion>
    <ns4:id xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">64a3ddbd-1620-42c4-b2fe-60b854c2f32f
    </ns4:id>
         <ns4:client xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
       <ns3:subsystemCode>generic-consumer</ns3:subsystemCode>
    </ns4:client>
        <ns4:service ns3:objectType="SERVICE" xmlns:ns2="http://dhx.x-road.eu/producer" xmlns:ns3="http://x-road.eu/xsd/identifiers" xmlns:ns4="http://x-road.eu/xsd/xroad.xsd" xmlns:ns5="http://www.riik.ee/schemas/deccontainer/vers_2_1/">
      <ns3:xRoadInstance>ee-dev</ns3:xRoadInstance>
      <ns3:memberClass>GOV</ns3:memberClass>
      <ns3:memberCode>70006317</ns3:memberCode>
      <ns3:subsystemCode>dhl</ns3:subsystemCode>
      <ns3:serviceCode>markDocumentsReceived</ns3:serviceCode>
      <ns3:serviceVersion>v3</ns3:serviceVersion>
    </ns4:service>
   </soapenv:Header>
   <soapenv:Body>
      <dhl:markDocumentsReceived>
         <keha>
            <dokumendid xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="dhl:asutus[3]">
        <item>
          <dhl_id>14352</dhl_id>
        </item>
      </dokumendid>
         </keha>
      </dhl:markDocumentsReceived>
   </soapenv:Body>
</soapenv:Envelope>
```
<a name="dhx-makett-tests"></a>
## 3. DHX makettrakenduse testid
<a name="3.1"></a>
### 3.1. Õige kapsli saatmine
<pre>

   **Saatev süsteem** : DHS makett
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Inimene valib Dokumendi saatmine tab-i Tegevused regioonis
- Valib rippmenüüst Vali dokument väärtuse korrektselt kapseldatud
- Valib rippmenüüst Vali adressaat väärtust mis vastab DHS 3 süsteemile(vastava registrikoodiga asutus).
- Vajutab nupule Saada dokument

#### **Oodatav tulemus** :

- dokument on vastu võetud DVK poolt
- saatvale süsteemile on saadetud õige vastuskood
- kajastatud nii saatva süsteemi sündmuste logis

<a name="3.2"></a>
### 3.2. Vale kapsli saatmine
<pre>

   **Saatev süsteem** : DHS makett
   **Kapsli adressaat** : DHS 3
   **Saadetis** : kapsli fail, mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 (nt puudu kohustuslik väli), aga on XML fail õige XML vorminguga
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Inimene valib Dokumendi saatmine tab-i Tegevused regioonis
- Valib rippmenüüst Vali dokument väärtus valesti kapseldatud
- Valib rippmenüüst Vali adressaat väärtust mis vastab DHS 3 süsteemile(vastava registrikoodiga asutus).
- Vajutab nupule Saada dokument.

#### **Oodatav tulemus** :

- dokumendi saatmine ebaõnnestus.
- vastuses on DHX.Validation koodiga fault
- kajastatud sündmuste logis

<a name="3.3"></a>
### 3.3. Faili saatmine (fail ei ole kapsel)
<pre>

   **Saatev süsteem** : DHS makett
   **Kapsli adressaat** : DHS 3
   **Saadetis** : fail mis ei ole XML või XML vale vorminguga.
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Inimene valib Dokumendi saatmine tab-i Tegevused regioonis
- Valib rippmenüüst Vali dokument väärtus vale XML või mitte XML fail
- Valib rippmenüüst Vali adressaat väärtust mis vastab DHS 3 süsteemile(vastava registrikoodiga asutus).
- Vajutab nupule Saada dokument

#### **Oodatav tulemus** :

- dokumendi saatmine ebaõnnestus
- vastuses on DHX.Validation koodiga fault
- kajastatud sündmuste logis

<a name="3.4"></a>
### 3.4. Duplikaadi kontroll
<pre>

   **Saatev süsteem** : DHS makett
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Inimene valib Dokumendi saatmine tab-i Tegevused regioonis
- Eemaldab linnukese märkeruudust 'Genereeri saadetise ID automaatselt'
- Sisestab välja Saadetise ID väärtuse, millega on eelnevalt dokument juba saadetud (väärtuse saab sündmuste logist, sündmuse logist tuleb kopeerida õnnestunud saatmise internalConsignmentId. Sündmuse logi näide: Sending document to: addressee: 30000001, X-road member: ee-dev/COM/30000001/DHX, is representee: false internalConsignmentId:7e8d0dbc-8a04-48c6-a509-6ef25eb38c7b)
- Valib rippmenüüst Vali dokument väärtus korrektselt kapseldatud
- Valib rippmenüüst Vali adressaat väärtust mis vastab DHS 3 süsteemile(vastava registrikoodiga asutus).
- Vajutab nupule Saada dokument
DHS 2 tunneb ära, et on sama saadetise juba edukalt vastu võtnud ja tagastab vastava veateate.

#### **Oodatav tulemus** :

- dokument on tagasi lükatud
- vastuses on DHX.Duplicate koodiga fault
- kajastatud sündmuste logis

<a name="3.5"></a>
### 3.5. DVK süsteemist tulnud dokumendi vastuvõtmine
<pre>

   **Saatev süsteem** : DHS makett
   **Kapsli adressaat** : DHS 3
   **Saadetis** : korrektselt kapseldatud fail
</pre>

#### **Verifitseerija toimimine (samm-sammuline):**

- Testija täidab testi 2.1
- Testija veendub et eelmises sammus saadetud dokument jõudis DHS makettrakendusesse.

#### **Oodatav tulemus** :

- DVK-st tulnud dokumendi info olemas makettrakenduse süsnmuste logis

<a name="testplaan"></a>
## Testplaan
- 24.10.2016	Testimise ettevalmistamine
- 25.10.2016	DHX protokolli teenuste testimise esimene iteratsioon. Läbitakse testlood:
	- 1.1 Õige kapsli saatmine
	- 1.2.	Õige kapsli saatmine alamsüsteemile
	- 1.3.	Vale kapsli saatmine
	- 1.4.	Faili saatmine (fail ei ole kapsel)
	- 1.5.	Duplikaadi kontroll
	- 1.6.	Valele adressaadile saatmine
	- 1.7.	Vahendatavate nimekirja küsimine DVK-st.
	- 1.8.	DVK süsteemist tulnud dokumentide vastuvõtmine
	- 1.9.	Õige kapsli saatmine. Adressat toetab ainult 1.0 kapsli versiooni
	- 1.10.	Õige kapsli saatmine. Kapslis on määratud ’ARVED’ kaust.
- Koostatakse testraport.
- 26.10.2016	DVK protokolli teenuste testimise esimene iteratsioon. Läbitakse testlood:
	- 2.1. Õige kapsli saatmine
	- 2.2.	Vale kapsli saatmine
	- 2.3.	Faili saatmine (fail ei ole kapsel)
	- 2.4.	Vahendatavale saatmine
	- 2.5.	Valele adressaadile saatmine
	- 2.6.	DHX süsteemist tulnud dokumendi vastuvõtmine
	- 2.7.	DHX süsteemist tulnud dokumendi vastuvõetuks märkimine
	- 2.8.	DHX süsteemist tulnud dokumendi vastuvõtmine. Dokument on suunatud alamsüsteemile.
	- 2.9. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine.  Dokument on suunatud alamsüsteemile.
	- 2.10. DVK adressaatide nimekirja pärimine.
	- 2.11. DHX-i saadetud dokumendi staatuse pärimine(saatmine õnnestus)
	- 2.12. DHX-i saadetud dokumendi staatuse pärimine(saatmine ebaõnnestus, adressaat ei ole üleval)
	- 2.13. Õige kapsli saatmine DHX alamsüsteemile(DHX. prefiksiga X-tee alamsüsteemile)
	- 2.14. Vana kapsli(korrektselt kapseldatud fail 1.0) saatmine DHX adressaadile
	- 2.15. DHX süsteemist tulnud dokumendi vastuvõtmine. Adressat toetab ainult 1.0 kapsli versiooni
	- 2.16. DHX süsteemist tulnud dokumendi  vastuvõetuks märkimine. Adressat toetab ainult 1.0 kapsli versiooni
	- 2.17. DHX süsteemist tulnud dokumendi vastuvõtmine ’ARVED’ kaustast.
	- 2.18. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine. Dokument on ’ARVED’ kaustas.
	- 3.1.	Õige kapsli saatmine
	- 3.2.	Vale kapsli saatmine
	- 3.3.	Faili saatmine (fail ei ole kapsel)
	- 3.4.	Duplikaadi kontroll
	- 3.5.	DVK süsteemist tulnud dokumendi vastuvõtmine
- Koostatakse testraport.
- 27.11.2016-01.11.2016	Testiraportide analüüs, tuvastud vigade parandamine
- 02.11.2016	DHX protokolli teenuste testimise teine iteratsioon. Läbitakse testlood:
	- 1.1 Õige kapsli saatmine
	- 1.2.	Õige kapsli saatmine alamsüsteemile
	- 1.3.	Vale kapsli saatmine
	- 1.4.	Faili saatmine (fail ei ole kapsel)
	- 1.5.	Duplikaadi kontroll
	- 1.6.	Valele adressaadile saatmine
	- 1.7.	Vahendatavate nimekirja küsimine DVK-st.
	- 1.8.	DVK süsteemist tulnud dokumentide vastuvõtmine
	- 1.9.	Õige kapsli saatmine. Adressat toetab ainult 1.0 kapsli versiooni
	- 1.10.	Õige kapsli saatmine. Kapslis on määratud ’ARVED’ kaust.
- Koostatakse testraport.
- 03.11.2016	DVK protokolli teenuste testimise teine iteratsioon. Läbitakse testlood:
	- 2.1. Õige kapsli saatmine
	- 2.2.	Vale kapsli saatmine
	- 2.3.	Faili saatmine (fail ei ole kapsel)
	- 2.4.	Vahendatavale saatmine
	- 2.5.	Valele adressaadile saatmine
	- 2.6.	DHX süsteemist tulnud dokumendi vastuvõtmine
	- 2.7.	DHX süsteemist tulnud dokumendi vastuvõetuks märkimine
	- 2.8.	DHX süsteemist tulnud dokumendi vastuvõtmine. Dokument on suunatud alamsüsteemile.
	- 2.9. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine.  Dokument on suunatud alamsüsteemile.
	- 2.10. DVK adressaatide nimekirja pärimine.
	- 2.11. DHX-i saadetud dokumendi staatuse pärimine(saatmine õnnestus)
	- 2.12. DHX-i saadetud dokumendi staatuse pärimine(saatmine ebaõnnestus, adressaat ei ole üleval)
	- 2.13. Õige kapsli saatmine DHX alamsüsteemile(DHX. prefiksiga X-tee alamsüsteemile)
	- 2.14. Vana kapsli(korrektselt kapseldatud fail 1.0) saatmine DHX adressaadile
	- 2.15. DHX süsteemist tulnud dokumendi vastuvõtmine. Adressat toetab ainult 1.0 kapsli versiooni
	- 2.16. DHX süsteemist tulnud dokumendi  vastuvõetuks märkimine. Adressat toetab ainult 1.0 kapsli versiooni
	- 2.17. DHX süsteemist tulnud dokumendi vastuvõtmine ’ARVED’ kaustast.
	- 2.18. DHX süsteemist tulnud dokumendi vastuvõetuks märkimine. Dokument on ’ARVED’ kaustas.
	- 3.1.	Õige kapsli saatmine
	- 3.2.	Vale kapsli saatmine
	- 3.3.	Faili saatmine (fail ei ole kapsel)
	- 3.4.	Duplikaadi kontroll
	- 3.5.	DVK süsteemist tulnud dokumendi vastuvõtmine
- Koostatakse testraport.
- 04.11.2016	Testimise tulemite ülevaatamine
- 07.11.2016	DHX protokolli teenused on testitud