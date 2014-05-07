﻿INSERT
INTO    dvk.dhl_message(
        dhl_message_id,
        is_incoming,
        data,
        title,
        sender_org_code,
        sender_org_name,
        sender_person_code,
        sender_name,
        recipient_org_code,
        recipient_org_name,
        recipient_person_code,
        recipient_name,
        case_name,
        dhl_folder_name,
        sending_status_id,
        unit_id,
        dhl_id,
        sending_date,
        received_date,
        local_item_id,
        recipient_status_id,
        fault_code,
        fault_actor,
        fault_string,
        fault_detail,
        status_update_needed,
        metaxml,
        query_id,
        proxy_org_code,
        proxy_org_name,
        proxy_person_code,
        proxy_name,
        recipient_department_nr,
        recipient_department_name,
        recipient_email,
        recipient_division_id,
        recipient_division_name,
        recipient_position_id,
        recipient_position_name,
        recipient_division_code,
        recipient_position_code,
        dhl_guid)
VALUES  (13,
        1,
        '<?xml version="1.0" encoding="utf-8"?>
<dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl">
    <dhl:metainfo xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic" xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual">
        <mm:koostaja_asutuse_nr>87654321</mm:koostaja_asutuse_nr>
        <mm:saaja_asutuse_nr>87654321</mm:saaja_asutuse_nr>
        <mm:koostaja_dokumendinimi>Testdokument</mm:koostaja_dokumendinimi>
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
    </dhl:metainfo>
    <dhl:transport>
        <dhl:saatja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:nimi>Jaak Lember</dhl:nimi>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:ametikoha_lyhinimetus>SEPP</dhl:ametikoha_lyhinimetus>
            <dhl:ametikoha_nimetus>Sepp</dhl:ametikoha_nimetus>
            <dhl:allyksuse_lyhinimetus>SEPIKODA</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Sepikoda</dhl:allyksuse_nimetus>
        </dhl:saatja>
        <dhl:saaja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:allyksuse_lyhinimetus>RMTP</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Raamatupidamisosakond</dhl:allyksuse_nimetus>
            <dhl:ametikoha_lyhinimetus>RMTP-123</dhl:ametikoha_lyhinimetus>
            <dhl:ametikoha_nimetus>Raamatupidaja</dhl:ametikoha_nimetus>
        </dhl:saaja>
        <dhl:saaja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:allyksuse_lyhinimetus>SEPIKODA</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Sepikoda</dhl:allyksuse_nimetus>
            <dhl:ametikoha_lyhinimetus>INSENER</dhl:ametikoha_lyhinimetus>
            <dhl:ametikoha_nimetus>Insener</dhl:ametikoha_nimetus>
        </dhl:saaja>
        <dhl:saaja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:allyksuse_lyhinimetus>POSTGRE</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Postgre SQL kasutajad</dhl:allyksuse_nimetus>
        </dhl:saaja>
        <dhl:saaja>
            <dhl:regnr>87654321</dhl:regnr>
            <dhl:asutuse_nimi>Asutus</dhl:asutuse_nimi>
            <dhl:allyksuse_lyhinimetus>ORACLE</dhl:allyksuse_lyhinimetus>
            <dhl:allyksuse_nimetus>Oracle kasutajad</dhl:allyksuse_nimetus>
        </dhl:saaja>
    </dhl:transport>
    <dhl:ajalugu/>
    <dhl:metaxml/>
<SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
<DataFile ContentType="EMBEDDED_BASE64" Filename="hello_original.ddoc" Id="D0" MimeType="application/unknown" Size="7517" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPFNpZ25lZERv
YyBmb3JtYXQ9IkRJR0lET0MtWE1MIiB2ZXJzaW9uPSIxLjMiIHhtbG5zPSJodHRw
Oi8vd3d3LnNrLmVlL0RpZ2lEb2MvdjEuMy4wIyI+CjxEYXRhRmlsZSBDb250ZW50
VHlwZT0iRU1CRURERURfQkFTRTY0IiBGaWxlbmFtZT0ibGVwaW5nLnR4dCIgSWQ9
IkQwIiBNaW1lVHlwZT0iZmlsZSIgU2l6ZT0iOTIiIHhtbG5zPSJodHRwOi8vd3d3
LnNrLmVlL0RpZ2lEb2MvdjEuMy4wIyI+UzhPa1pYTnZiR1YyWVdkaElIVER0Vzkw
WVc0Z2NNTzhhR0ZzYVd0MWJIUXNDbVYwSUd0MWN5QnBaMkZ1WlhNZwpiV0VnZG1s
bllTQnV3NlJsYmlCc1lXbDBZU3dLYzJWaGJDQnN3NlJvWlc0Z2FtRWdiR0ZwWkdG
dUlRbz0KPC9EYXRhRmlsZT4KPFNpZ25hdHVyZSBJZD0iUzAiIHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KPFNpZ25lZEluZm8geG1s
bnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPgo8Q2Fub25p
Y2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RS
LzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ij4KPC9DYW5vbmljYWxpemF0aW9u
TWV0aG9kPgo8U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53
My5vcmcvMjAwMC8wOS94bWxkc2lnI3JzYS1zaGExIj4KPC9TaWduYXR1cmVNZXRo
b2Q+CjxSZWZlcmVuY2UgVVJJPSIjRDAiPgo8RGlnZXN0TWV0aG9kIEFsZ29yaXRo
bT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3NoYTEiPgo8L0Rp
Z2VzdE1ldGhvZD4KPERpZ2VzdFZhbHVlPllaL1NCUWlVcjBnRURVOXRqTkROVllM
Y28zaz08L0RpZ2VzdFZhbHVlPgo8L1JlZmVyZW5jZT4KPFJlZmVyZW5jZSBUeXBl
PSJodHRwOi8vdXJpLmV0c2kub3JnLzAxOTAzL3YxLjEuMSNTaWduZWRQcm9wZXJ0
aWVzIiBVUkk9IiNTMC1TaWduZWRQcm9wZXJ0aWVzIj4KPERpZ2VzdE1ldGhvZCBB
bGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGEx
Ij4KPC9EaWdlc3RNZXRob2Q+CjxEaWdlc3RWYWx1ZT5LM0FzekVESDFwQmdWM0tR
ZjEvVXFaRnprYXc9CjwvRGlnZXN0VmFsdWU+CjwvUmVmZXJlbmNlPgo8L1NpZ25l
ZEluZm8+PFNpZ25hdHVyZVZhbHVlIElkPSJTMC1TSUciPgpoUGFPeGtVeXVORzJi
YSt1amF5QnEzU1pvb0lzMm5pRVNFTHBBZG13SUxKdkhhdHI2VnRyWFZLYUw1c3Jm
M1JJCk55OGpJdGVaZ2xhVVZoZHc3bGNsbHdaR0VIMW12a3VYeGdpSlJseWtScVdz
OTJBcm1PdVJtbDV0eFJ1QmttS1UKOVV3VTU5V2xFMUJQT0EwSTVhK2FocDNkUVFK
SXIxWGdtUEplRmJaOEFhdz0KPC9TaWduYXR1cmVWYWx1ZT4KPEtleUluZm8+CjxL
ZXlWYWx1ZT4KPFJTQUtleVZhbHVlPgo8TW9kdWx1cz5qdFlmR2hQd3JtZkVNeVMz
UHVrYURaUVZKTFhHMVFhVGVYS0dEdEZlNEdwOVRydWxnZFBxWEdYaFRSUVJSa2g5
CjhRcVVUR2V5RWJrUkFyc3ZuZnBaM3ZDK0pSMHpjclNpTUVuNzBxQWt3WXphUXVv
ZitZTHhHaVF2R1pGZFZreWwKdWhaMHJEOUMxdUxkb3ZGNDJJdDk4OHNnSHhOMVhj
aHF6SGYva1VjVmNlYz08L01vZHVsdXM+CjxFeHBvbmVudD5EUnJqPC9FeHBvbmVu
dD4KPC9SU0FLZXlWYWx1ZT4KPC9LZXlWYWx1ZT4KPFg1MDlEYXRhPjxYNTA5Q2Vy
dGlmaWNhdGU+Ck1JSUQ0akNDQXNxZ0F3SUJBZ0lFU0RVeldqQU5CZ2txaGtpRzl3
MEJBUVVGQURCYk1Rc3dDUVlEVlFRR0V3SkYKUlRFaU1DQUdBMVVFQ2hNWlFWTWdV
MlZ5ZEdsbWFYUnpaV1Z5YVcxcGMydGxjMnQxY3pFUE1BMEdBMVVFQ3hNRwpSVk5V
UlVsRU1SY3dGUVlEVlFRREV3NUZVMVJGU1VRdFUwc2dNakF3TnpBZUZ3MHdPREEx
TWpJd09EUTRNalZhCkZ3MHhNakExTVRReU1UQXdNREJhTUlHY01Rc3dDUVlEVlFR
R0V3SkZSVEVQTUEwR0ExVUVDaE1HUlZOVVJVbEUKTVJvd0dBWURWUVFMRXhGa2FX
ZHBkR0ZzSUhOcFoyNWhkSFZ5WlRFbE1DTUdBMVVFQXhNY1FVNUVVa1ZKVFVGTwpU
aXhCVGxSVVNTd3pOemd4TURFd01ESTFPREVUTUJFR0ExVUVCQk1LUVU1RVVrVkpU
VUZPVGpFT01Bd0dBMVVFCktoTUZRVTVVVkVreEZEQVNCZ05WQkFVVEN6TTNPREV3
TVRBd01qVTRNSUdmTUEwR0NTcUdTSWIzRFFFQkFRVUEKQTRHTkFEQ0JpUUtCZ1FD
TzFoOGFFL0N1WjhRekpMYys2Um9ObEJVa3RjYlZCcE41Y29ZTzBWN2dhbjFPdTZX
QgowK3BjWmVGTkZCRkdTSDN4Q3BSTVo3SVJ1UkVDdXkrZCtsbmU4TDRsSFROeXRL
SXdTZnZTb0NUQmpOcEM2aC81Cmd2RWFKQzhaa1YxV1RLVzZGblNzUDBMVzR0Mmk4
WGpZaTMzenl5QWZFM1ZkeUdyTWQvK1JSeFZ4NXdJRERScmoKbzRIdk1JSHNNQTRH
QTFVZER3RUIvd1FFQXdJR1FEQThCZ05WSFI4RU5UQXpNREdnTDZBdGhpdG9kSFJ3
T2k4dgpkM2QzTG5OckxtVmxMMk55YkhNdlpYTjBaV2xrTDJWemRHVnBaREl3TURj
dVkzSnNNRkVHQTFVZElBUktNRWd3ClJnWUxLd1lCQkFIT0h3RUJBUUV3TnpBU0Jn
Z3JCZ0VGQlFjQ0FqQUdHZ1J1YjI1bE1DRUdDQ3NHQVFVRkJ3SUIKRmhWb2RIUndP
aTh2ZDNkM0xuTnJMbVZsTDJOd2N5OHdId1lEVlIwakJCZ3dGb0FVU0FiZXZveUhW
NVdBZUdQNgpuQ01ySzZBNkdIVXdIUVlEVlIwT0JCWUVGRkhnY245S2hzbW12RkJH
bFBpYVJMb1hhV0xYTUFrR0ExVWRFd1FDCk1BQXdEUVlKS29aSWh2Y05BUUVGQlFB
RGdnRUJBTUdYdENRTTl1c0lFejEyazRSbjNpalJJVlRZaVFSLzZZWHcKRis2a3pk
U1I1K0lGTzJnYWxWY1lvdlV1UGM2dlltRlFicGVBZWtmNUtiQzdkOXVvRzdDV2tl
OFluazJ0VG4yMgpyY1ZJWWdTcm5NN2IzV0szdWVkS1lhZmlBV3VNM2hOYnRqN1lX
Qm1Idkx3emhYcTRTTUpEUmJyS0lzWVdIUXNnCnIvRCtQU0tuWmVnV1VRaWdzRC9C
NmVkbDFGRG8xY2RNZ0l5ZXQxMzUwK3doMFhGdzNpWWdaSUlia0JZcjZ0TUsKUEFn
MGxTbS9OUThROVlXbGZ3WHJhZ2pCSGZnMEdCUVFWVlhlYldKUVJZRUdNRU5NWktS
QlpKd0pkMmJFbm9WMQo4N2NubHBMREZ6cUdTTDlsNVBqUThFRVBOUjNMMEdoOHly
OUd1T2cxc0wyMDR5QXpPeWM9PC9YNTA5Q2VydGlmaWNhdGU+PC9YNTA5RGF0YT48
L0tleUluZm8+CjxPYmplY3Q+PFF1YWxpZnlpbmdQcm9wZXJ0aWVzIHhtbG5zPSJo
dHRwOi8vdXJpLmV0c2kub3JnLzAxOTAzL3YxLjEuMSMiIFRhcmdldD0iI1MwIj4K
RFJyajxTaWduZWRQcm9wZXJ0aWVzIHhtbG5zPSJodHRwOi8vdXJpLmV0c2kub3Jn
LzAxOTAzL3YxLjEuMSMiIElkPSJTMC1TaWduZWRQcm9wZXJ0aWVzIj4KPFNpZ25l
ZFNpZ25hdHVyZVByb3BlcnRpZXM+CjxTaWduaW5nVGltZT4yMDA5LTEwLTEzVDE2
OjE3OjU5WjwvU2lnbmluZ1RpbWU+CjxTaWduaW5nQ2VydGlmaWNhdGU+CjxDZXJ0
Pgo8Q2VydERpZ2VzdD4KPERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93
d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIj4KPC9EaWdlc3RNZXRob2Q+
CjxEaWdlc3RWYWx1ZT5kS0JvNjFwcU5yVFdTbG02WTNwYVIvaytUNTA9PC9EaWdl
c3RWYWx1ZT4KPC9DZXJ0RGlnZXN0Pgo8SXNzdWVyU2VyaWFsPgo8WDUwOUlzc3Vl
ck5hbWUgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMi
PkM9RUUvTz1BUyBTZXJ0aWZpdHNlZXJpbWlza2Vza3VzL09VPUVTVEVJRC9DTj1F
U1RFSUQtU0sgMjAwNzwvWDUwOUlzc3Vlck5hbWU+CjxYNTA5U2VyaWFsTnVtYmVy
IHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4xMjEx
NDQ2MTA2PC9YNTA5U2VyaWFsTnVtYmVyPgo8L0lzc3VlclNlcmlhbD48L0NlcnQ+
PC9TaWduaW5nQ2VydGlmaWNhdGU+CjxTaWduYXR1cmVQb2xpY3lJZGVudGlmaWVy
Pgo8U2lnbmF0dXJlUG9saWN5SW1wbGllZD4KPC9TaWduYXR1cmVQb2xpY3lJbXBs
aWVkPgo8L1NpZ25hdHVyZVBvbGljeUlkZW50aWZpZXI+CjxTaWduYXR1cmVQcm9k
dWN0aW9uUGxhY2U+CjxDaXR5PjwvQ2l0eT4KPFN0YXRlT3JQcm92aW5jZT48L1N0
YXRlT3JQcm92aW5jZT4KPFBvc3RhbENvZGU+PC9Qb3N0YWxDb2RlPgo8Q291bnRy
eU5hbWU+PC9Db3VudHJ5TmFtZT4KPC9TaWduYXR1cmVQcm9kdWN0aW9uUGxhY2U+
CjxTaWduZXJSb2xlPgo8Q2xhaW1lZFJvbGVzPgo8Q2xhaW1lZFJvbGU+PC9DbGFp
bWVkUm9sZT4KPC9DbGFpbWVkUm9sZXM+CjwvU2lnbmVyUm9sZT4KPC9TaWduZWRT
aWduYXR1cmVQcm9wZXJ0aWVzPgo8U2lnbmVkRGF0YU9iamVjdFByb3BlcnRpZXM+
CjwvU2lnbmVkRGF0YU9iamVjdFByb3BlcnRpZXM+CjwvU2lnbmVkUHJvcGVydGll
cz48VW5zaWduZWRQcm9wZXJ0aWVzPgo8VW5zaWduZWRTaWduYXR1cmVQcm9wZXJ0
aWVzPjxDb21wbGV0ZUNlcnRpZmljYXRlUmVmcz48Q2VydFJlZnM+PENlcnQ+PENl
cnREaWdlc3Q+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMu
b3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+CjxEaWdlc3RWYWx1ZT4vZGNxa3k2
UGU0WDg1V00yb1FtRjEyb3JncjQ9CjwvRGlnZXN0VmFsdWU+CjwvQ2VydERpZ2Vz
dD4KPElzc3VlclNlcmlhbD4KPFg1MDlJc3N1ZXJOYW1lIHhtbG5zPSJodHRwOi8v
d3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj5DPUVFL089RVNURUlEL09VPU9D
U1AvQ049RVNURUlELVNLIDIwMDcgT0NTUCBSRVNQT05ERVIvZW1haWxBZGRyZXNz
PXBraUBzay5lZTwvWDUwOUlzc3Vlck5hbWU+CjxYNTA5U2VyaWFsTnVtYmVyIHht
bG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4xMTY3OTIz
ODI2PC9YNTA5U2VyaWFsTnVtYmVyPgo8L0lzc3VlclNlcmlhbD4KPC9DZXJ0Pjwv
Q2VydFJlZnM+PC9Db21wbGV0ZUNlcnRpZmljYXRlUmVmcz48Q29tcGxldGVSZXZv
Y2F0aW9uUmVmcz4KPE9DU1BSZWZzPgo8T0NTUFJlZj4KPE9DU1BJZGVudGlmaWVy
IFVSST0iI04wIj48UmVzcG9uZGVySUQ+Qz1FRS9PPUVTVEVJRC9PVT1PQ1NQL0NO
PUVTVEVJRC1TSyAyMDA3IE9DU1AgUkVTUE9OREVSL2VtYWlsQWRkcmVzcz1wa2lA
c2suZWU8L1Jlc3BvbmRlcklEPgo8UHJvZHVjZWRBdD4yMDA5LTEwLTEzVDE2OjE4
OjE1WjwvUHJvZHVjZWRBdD4KPC9PQ1NQSWRlbnRpZmllcj4KPERpZ2VzdEFsZ0Fu
ZFZhbHVlPgo8RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5v
cmcvMjAwMC8wOS94bWxkc2lnI3NoYTEiPjwvRGlnZXN0TWV0aG9kPgo8RGlnZXN0
VmFsdWU+SVloRndFV2hkbTN5b3ZWV244dy8vZXFNRHpZPTwvRGlnZXN0VmFsdWU+
CjwvRGlnZXN0QWxnQW5kVmFsdWU+PC9PQ1NQUmVmPgo8L09DU1BSZWZzPgo8L0Nv
bXBsZXRlUmV2b2NhdGlvblJlZnM+CjxDZXJ0aWZpY2F0ZVZhbHVlcz4KPEVuY2Fw
c3VsYXRlZFg1MDlDZXJ0aWZpY2F0ZSBJZD0iUzAtUkVTUE9OREVSX0NFUlQiPgpN
SUlEbkRDQ0FvU2dBd0lCQWdJRVJaMGFjakFOQmdrcWhraUc5dzBCQVFVRkFEQmJN
UXN3Q1FZRFZRUUdFd0pGClJURWlNQ0FHQTFVRUNoTVpRVk1nVTJWeWRHbG1hWFJ6
WldWeWFXMXBjMnRsYzJ0MWN6RVBNQTBHQTFVRUN4TUcKUlZOVVJVbEVNUmN3RlFZ
RFZRUURFdzVGVTFSRlNVUXRVMHNnTWpBd056QWVGdzB3TnpBeE1EUXhOVEUzTURa
YQpGdzB4TURBeE1EZ3hOVEUzTURaYU1HOHhDekFKQmdOVkJBWVRBa1ZGTVE4d0RR
WURWUVFLRXdaRlUxUkZTVVF4CkRUQUxCZ05WQkFzVEJFOURVMUF4SmpBa0JnTlZC
QU1USFVWVFZFVkpSQzFUU3lBeU1EQTNJRTlEVTFBZ1VrVlQKVUU5T1JFVlNNUmd3
RmdZSktvWklodmNOQVFrQkZnbHdhMmxBYzJzdVpXVXdnWjh3RFFZSktvWklodmNO
QVFFQgpCUUFEZ1kwQU1JR0pBb0dCQUptb0IzU0pDcFB6Y29ITnFLMUowdFJOUWpn
cjVpdUIyN3VFMVZhY0liSVRqRC9OCmMxQWVmS3o1eWROUElhQk5laG00eUt4QllH
eEVlV09TSkhWWHloSk1nNTNFQVVPdy80NWM0Nmd2em5YdXBIdUoKNlRFaUdqaDFw
eGFYVGVMU25UcXpORFpEQUdRc09UZ0lid0dMYTVVNWFkOHJYWXUyWWtKS3NBZm82
alQ1QWdNQgpBQUdqZ2Rjd2dkUXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUhBd2t3
RWdZSkt3WUVCUVVITUFFRkJBVXdBd1FCCk1EQ0JpUVlEVlIwakJJR0JNSCtBRkVn
RzNyNk1oMWVWZ0hoaitwd2pLeXVnT2hoMW9XR2tYekJkTVJnd0ZnWUoKS29aSWh2
Y05BUWtCRmdsd2EybEFjMnN1WldVeEN6QUpCZ05WQkFZVEFrVkZNU0l3SUFZRFZR
UUtFeGxCVXlCVApaWEowYVdacGRITmxaWEpwYldsemEyVnphM1Z6TVJBd0RnWURW
UVFERXdkS2RYVnlMVk5MZ2dSRm02QU5NQjBHCkExVWREZ1FXQkJSSi9zbncxR0RM
M2ZVSDluOUNwbjh5aFhpQzdEQU5CZ2txaGtpRzl3MEJBUVVGQUFPQ0FRRUEKWXpH
a1pEL3VhWGxXUGV5ZTF6NUlpSTgzbm1BamlKeXZvai9yM0JCOVpGV01YK1pZNEZ6
Ni9WL2Z6RDB4WG9lRApwV2JCS3hjdWN0UFh6WFl4RUgxN24wLzN5R096OGpoZEpO
QlVDd1JtZCs5Nm9Ic1U5YVdTZitEMnRpcTFqUHc2CkhWQ2lVWU9oQy9PV2pnLytK
cEZsV3NCVjRnVFc4LzJQU0dpZzg1WGxFc1dMSzdpN3RJZTYwbm53L3JXbmZiQ2MK
a01SY2JyQUYxTC9KSWxuVVlVZGtHT0dROUtQVnF3Ui9NeVdyd0ZJY1N5MlFJYmNJ
YVdNdWlVYzFudDhibUlYSwpvRlp4Ykx6WFlDMDB6YmE5Y1k3bFNDNFdQdWhCdHJR
SjlKV2I0T2VvWGQ1ajZPNDVVYUg2WGJhcmZyaEVSMUdICkwwNmNUeWtzVDE4cDJM
MkdyTXVFSmc9PTwvRW5jYXBzdWxhdGVkWDUwOUNlcnRpZmljYXRlPgo8L0NlcnRp
ZmljYXRlVmFsdWVzPgo8UmV2b2NhdGlvblZhbHVlcz48T0NTUFZhbHVlcz48RW5j
YXBzdWxhdGVkT0NTUFZhbHVlIElkPSJOMCI+Ck1JSUJ0Z29CQUtDQ0FhOHdnZ0dy
QmdrckJnRUZCUWN3QVFFRWdnR2NNSUlCbURDQ0FRR2hjVEJ2TVFzd0NRWUQKVlFR
R0V3SkZSVEVQTUEwR0ExVUVDaE1HUlZOVVJVbEVNUTB3Q3dZRFZRUUxFd1JQUTFO
UU1TWXdKQVlEVlFRRApFeDFGVTFSRlNVUXRVMHNnTWpBd055QlBRMU5RSUZKRlUx
QlBUa1JGVWpFWU1CWUdDU3FHU0liM0RRRUpBUllKCmNHdHBRSE5yTG1WbEdBOHlN
REE1TVRBeE16RTJNVGd4TlZvd1ZEQlNNRDB3Q1FZRkt3NERBaG9GQUFRVVJRaWsK
SERWY0NuSklYK0xmZTJwbmlNYWxVQ0lFRkVnRzNyNk1oMWVWZ0hoaitwd2pLeXVn
T2hoMUFnUklOVE5hZ0FBWQpEekl3TURreE1ERXpNVFl4T0RFMVdxRWxNQ013SVFZ
Skt3WUJCUVVITUFFQ0JCU29JZXIxNmpkYURtSmFSdmtoCmdBSDZ4Um9ROURBTkJn
a3Foa2lHOXcwQkFRVUZBQU9CZ1FDRUMzay85bGlNVFVlelpvRTdYQW4xTDI2QUtG
cVkKRHY5Q1VFWGJpb3ltK0ZHdFUzdTdkR3dXYWJmL040T3JURFY0TFVsT2lIdHpH
YlpIUDh6bzdTWmxITGdtZzJOUApuQWhMcXBVZVlPclJlbzQxYlBwK0lZSjFPSUIy
a01RZkkyM1U1SktEN044Vm5iY0pwMnNZYlZXV0JBdk80akI3CktMZkJwYjZ0cTlo
cWVBPT0KPC9FbmNhcHN1bGF0ZWRPQ1NQVmFsdWU+CjwvT0NTUFZhbHVlcz48L1Jl
dm9jYXRpb25WYWx1ZXM+PC9VbnNpZ25lZFNpZ25hdHVyZVByb3BlcnRpZXM+Cjwv
VW5zaWduZWRQcm9wZXJ0aWVzPjwvUXVhbGlmeWluZ1Byb3BlcnRpZXM+PC9PYmpl
Y3Q+CjwvU2lnbmF0dXJlPgo8L1NpZ25lZERvYz4=
</DataFile>
</SignedDoc>
</dhl:dokument>
',
           'Testdokument',
           '87654321',
           'Asutus',
           '',
           'Jaak Lember',
           '87654321',
           'Asutus',
           '',
           '',
           '',
           '',
           1,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           0,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL);