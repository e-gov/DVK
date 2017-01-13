# SoapUI testide käivitamise juhend

## Sissejuhatus

SoapUI on tarkvara mis võimaldab lihtsal viisil teha SOAP päringuid. SoapUI allalaadida ja leida rohkem infot võib [https://www.soapui.org/](https://www.soapui.org/) leheküljel.

Antud juhend kirjeldab DVK-s DHX protokolliga seotud muudatuste testimiseks tehtud SoapUI testide konfigureerimist ja käivitamist. 

SoapUi testid on tehtud ja nimetatud vastavalt [testilugudele](../dvk_dhx_testilod.md).

## SoapUI testide konfigureerimine

* Importida SoapUI project.(SoapUI projekti importimise kohta rohkem infot võib leida [siin](https://www.soapui.org/articles/import-project.html))

* Muuta DVK_DHX SoapUi projekti parameetrid(SoapUI parameetrite kohta rohkem infot võib leida [siin](https://www.soapui.org/functional-testing/properties/working-with-properties.html)):


| Parameetri nimi | Näidis väärtus | Kommentaar |
|-------|----------|----------------|
| dvkEndpoint | http://10.0.13.198/cgi-bin/consumer_proxy  | endpoint kuhu tuleb saata DVK päringud. Tavaliselt turvaserveri aadress. |
| dhxEndpoint | http://10.0.13.198/cgi-bin/consumer_proxy  | endpoint kuhu tuleb saata DHX päringud. Tavaliselt turvaserveri aadress. |
| xroadInstance | ee-dev | SOAP headeri Xtee parameetri xroadInstance väärtus |
| dhs2MemberClass | GOV | testilugudes kirjeldatud DHS2 Xtee liikme memberClass |
| dhs2MemberCode | 30000001 | testilugudes kirjeldatud DHS2 Xtee liikme memberCode |
| dhs2Subsystem | DHX | testilugudes kirjeldatud DHS2 Xtee liikme subsystemCode |
| dhs2RepresenteeCode | 70000001 | testilugudes kirjeldatud DHS2 Xtee liikme vahendatava registrikood |
| dhs2Subsystem2 | subsystem |  testilugudes kirjeldatud DHS2 Xtee liikme alamsüsteemi nimi |
| dvkMemberClass | GOV | DVK Xtee liikme memberClass |
| dvkMemberCode | 40000001 | DVK Xtee liikme memberCode |
| dvkDhxSubsystem | DHX | DVK Xtee liikme subsystemCode |
| dhs3MemberClass | GOV | testilugudes kirjeldatud DHS3 Xtee liikme memberClass |
| dhs3MemberCode | 70006317 | testilugudes kirjeldatud DHS3 Xtee liikme memberCode |
| dhs3Subsystem | generic-consumer | testilugudes kirjeldatud DHS3 Xtee liikme subsystemCode |
| dhs3AdminUserId | EE38806190294 | testilugudes kirjeldatud DHS3 admin kasutaja isikukood(pannakse Xtee header-sse) |
| dhs3Subsystem2 | adit | testilugudes kirjeldatud DHS3 Xtee liikme alamsüsteemi nimi |
| goodCapsule | C:\Users\alex\Desktop\xmls/kapsel_21.xml | viide failile mis sisaldab Elektroonilise andmevahetuse metaandmete loendile 2.1 vastavalt korrektselt kapseldatud fail.|
| badCapsule | C:\Users\alex\Desktop\xmls/kapsel_21_wrong.xml | viide failile mis sisaldab XML-i mis ei vasta Elektroonilise andmevahetuse metaandmete loendile 2.1 |
| notCapsule | C:\Users\alex\Desktop\xmls/kapsel_21_not_kapsel.xml | viide failile mis ei ole XML või XML vale vorminguga.  |
| goodCapsule10 | C:\Users\alex\Desktop\xmls/test.xml | viide failile mis sisaldab Elektroonilise andmevahetuse metaandmete loendile 1.0 vastavalt korrektselt kapseldatud fail. |
| dhs4MemberCode | 70006317 | testilugudes kirjeldatud DHS4 Xtee liikme memberCode |
| dhs4MemberClass | GOV | testilugudes kirjeldatud DHS4 Xtee liikme memberClass |
| dhs4Subsystem | generic-consumer | testilugudes kirjeldatud DHS4 Xtee liikme subsystemCode |
| dhs4AdminUserId | EE38806190294 | testilugudes kirjeldatud DHS4 admin kasutaja isikukood(pannakse Xtee header-sse) |
| dhs1MemberCode | 70000004 | testilugudes kirjeldatud DHS1 Xtee liikme memberCode |

**Failid asuvad [xmls](xmls) kaustas. Faili viidetega parameetrid(goodCapsule, badCapsule, notCapsule, goodCapsule10) tuleb muuta igas keskkonnas kus teste käivitatakse. Faili viide peab olema absolute path failini.**  

## SoapUI testide käivitamine
Testide struktuuri ja käivitamise kirjeldust võib leida [siin](https://www.soapui.org/functional-testing/structuring-and-running-tests.html). 

Kui testid on tehtud, tuleb veenduda et kõik testid on õnnestunud.

