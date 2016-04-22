/* This message should be sent through central server (should not be directly copied tooriginal database) */

delete from dhl_message;
delete from dhl_settings;

declare	@org_code nvarchar(20),
		@org_name nvarchar(250),
		@personal_id_code nvarchar(20),
		@unit_id int,
		@dvk_folder_name nvarchar(1000),
		@subdivision_short_name nvarchar(25),
		@subdivision_name nvarchar(250),
		@occupation_short_name nvarchar(25),
		@occupation_name nvarchar(250);

select	@org_code = '11111111',
		@org_name = 'Asutus',
		@personal_id_code = '38005130332',
		@unit_id = 0,
		@dvk_folder_name = '',
		@subdivision_short_name = '',
		@subdivision_name = '',
		@occupation_short_name = 'ametikoht',
		@occupation_name = 'Ametikoht';

insert into dhl_settings(id, institution_code, institution_name, personal_id_code, unit_id, subdivision_short_name, subdivision_name, occupation_short_name, occupation_name)
values(1, @org_code, @org_name, @personal_id_code, @unit_id, @subdivision_short_name, @subdivision_name, @occupation_short_name, @occupation_name);

INSERT INTO [dhl_message]
           ([is_incoming]
           ,[data]
           ,[title]
           ,[sender_org_code]
           ,[sender_org_name]
           ,[sender_person_code]
           ,[sender_name]
           ,[recipient_org_code]
           ,[recipient_org_name]
           ,[recipient_person_code]
           ,[recipient_name]
           ,[case_name]
           ,[dhl_folder_name]
           ,[sending_status_id]
           ,[unit_id]
           ,[dhl_id]
           ,[sending_date]
           ,[received_date]
           ,[local_item_id]
           ,[recipient_status_id]
           ,[fault_code]
           ,[fault_actor]
           ,[fault_string]
           ,[fault_detail]
           ,[status_update_needed]
           ,[metaxml]
           ,[query_id]
           ,[proxy_org_code]
           ,[proxy_org_name]
           ,[proxy_person_code]
           ,[proxy_name]
           ,[recipient_department_nr]
           ,[recipient_department_name]
           ,[recipient_email]
           ,[recipient_division_id]
           ,[recipient_division_name]
           ,[recipient_position_id]
           ,[recipient_position_name])
     VALUES
           (0,
           '<?xml version="1.0" encoding="utf-8"?>
           <dhl:dokument xmlns:dhl="http://www.riik.ee/schemas/dhl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.riik.ee/schemas/dhl http://localhost:8081/dhl/dhl.xsd">
    <dhl:metainfo xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic" xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual" />
    <dhl:transport>
        <dhl:saatja>
            <dhl:regnr>'+ @org_code +'</dhl:regnr>
            <dhl:nimi>'+ @org_name +'</dhl:nimi>
			<dhl:allyksuse_lyhinimetus>'+ @subdivision_short_name +'</dhl:allyksuse_lyhinimetus>
			<dhl:allyksuse_nimetus>'+ @subdivision_name +'</dhl:allyksuse_nimetus>
			<dhl:ametikoha_lyhinimetus>'+ @occupation_short_name +'</dhl:ametikoha_lyhinimetus>
			<dhl:ametikoha_nimetus>'+ @occupation_name +'</dhl:ametikoha_nimetus>
        </dhl:saatja>
        <dhl:saaja>
            <dhl:regnr>'+ @org_code +'</dhl:regnr>
            <dhl:asutuse_nimi>'+ @org_name +'</dhl:asutuse_nimi>
			<dhl:allyksuse_lyhinimetus>'+ @subdivision_short_name +'</dhl:allyksuse_lyhinimetus>
			<dhl:allyksuse_nimetus>'+ @subdivision_name +'</dhl:allyksuse_nimetus>
			<dhl:ametikoha_lyhinimetus>'+ @occupation_short_name +'</dhl:ametikoha_lyhinimetus>
			<dhl:ametikoha_nimetus>'+ @occupation_name +'</dhl:ametikoha_nimetus>
        </dhl:saaja>
    </dhl:transport>
    <dhl:ajalugu/>
    <dhl:metaxml/>
<SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
<DataFile ContentType="EMBEDDED_BASE64" Filename="ReallySmallImage.jpg" Id="D0" MimeType="image/pjpeg" Size="6733" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">/9j/4AAQSkZJRgABAQEASABIAAD/4gv4SUNDX1BST0ZJTEUAAQEAAAvoAAAAAAIA
AABtbnRyUkdCIFhZWiAH2QADABsAFQAkAB9hY3NwAAAAAAAAAAAAAAAAAAAAAAAA
AAEAAAAAAAAAAAAA9tYAAQAAAADTLQAAAAAp+D3er/JVrnhC+uTKgzkNAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBkZXNjAAABRAAAAHliWFlaAAABwAAA
ABRiVFJDAAAB1AAACAxkbWRkAAAJ4AAAAIhnWFlaAAAKaAAAABRnVFJDAAAB1AAA
CAxsdW1pAAAKfAAAABRtZWFzAAAKkAAAACRia3B0AAAKtAAAABRyWFlaAAAKyAAA
ABRyVFJDAAAB1AAACAx0ZWNoAAAK3AAAAAx2dWVkAAAK6AAAAId3dHB0AAALcAAA
ABRjcHJ0AAALhAAAADdjaGFkAAALvAAAACxkZXNjAAAAAAAAAB9zUkdCIElFQzYx
OTY2LTItMSBibGFjayBzY2FsZWQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAWFlaIAAAAAAAACSgAAAPhAAAts9jdXJ2AAAAAAAABAAAAAAFAAoADwAU
ABkAHgAjACgALQAyADcAOwBAAEUASgBPAFQAWQBeAGMAaABtAHIAdwB8AIEAhgCL
AJAAlQCaAJ8ApACpAK4AsgC3ALwAwQDGAMsA0ADVANsA4ADlAOsA8AD2APsBAQEH
AQ0BEwEZAR8BJQErATIBOAE+AUUBTAFSAVkBYAFnAW4BdQF8AYMBiwGSAZoBoQGp
AbEBuQHBAckB0QHZAeEB6QHyAfoCAwIMAhQCHQImAi8COAJBAksCVAJdAmcCcQJ6
AoQCjgKYAqICrAK2AsECywLVAuAC6wL1AwADCwMWAyEDLQM4A0MDTwNaA2YDcgN+
A4oDlgOiA64DugPHA9MD4APsA/kEBgQTBCAELQQ7BEgEVQRjBHEEfgSMBJoEqAS2
BMQE0wThBPAE/gUNBRwFKwU6BUkFWAVnBXcFhgWWBaYFtQXFBdUF5QX2BgYGFgYn
BjcGSAZZBmoGewaMBp0GrwbABtEG4wb1BwcHGQcrBz0HTwdhB3QHhgeZB6wHvwfS
B+UH+AgLCB8IMghGCFoIbgiCCJYIqgi+CNII5wj7CRAJJQk6CU8JZAl5CY8JpAm6
Cc8J5Qn7ChEKJwo9ClQKagqBCpgKrgrFCtwK8wsLCyILOQtRC2kLgAuYC7ALyAvh
C/kMEgwqDEMMXAx1DI4MpwzADNkM8w0NDSYNQA1aDXQNjg2pDcMN3g34DhMOLg5J
DmQOfw6bDrYO0g7uDwkPJQ9BD14Peg+WD7MPzw/sEAkQJhBDEGEQfhCbELkQ1xD1
ERMRMRFPEW0RjBGqEckR6BIHEiYSRRJkEoQSoxLDEuMTAxMjE0MTYxODE6QTxRPl
FAYUJxRJFGoUixStFM4U8BUSFTQVVhV4FZsVvRXgFgMWJhZJFmwWjxayFtYW+hcd
F0EXZReJF64X0hf3GBsYQBhlGIoYrxjVGPoZIBlFGWsZkRm3Gd0aBBoqGlEadxqe
GsUa7BsUGzsbYxuKG7Ib2hwCHCocUhx7HKMczBz1HR4dRx1wHZkdwx3sHhYeQB5q
HpQevh7pHxMfPh9pH5Qfvx/qIBUgQSBsIJggxCDwIRwhSCF1IaEhziH7IiciVSKC
Iq8i3SMKIzgjZiOUI8Ij8CQfJE0kfCSrJNolCSU4JWgllyXHJfcmJyZXJocmtybo
JxgnSSd6J6sn3CgNKD8ocSiiKNQpBik4KWspnSnQKgIqNSpoKpsqzysCKzYraSud
K9EsBSw5LG4soizXLQwtQS12Last4S4WLkwugi63Lu4vJC9aL5Evxy/+MDUwbDCk
MNsxEjFKMYIxujHyMioyYzKbMtQzDTNGM38zuDPxNCs0ZTSeNNg1EzVNNYc1wjX9
Njc2cjauNuk3JDdgN5w31zgUOFA4jDjIOQU5Qjl/Obw5+To2OnQ6sjrvOy07azuq
O+g8JzxlPKQ84z0iPWE9oT3gPiA+YD6gPuA/IT9hP6I/4kAjQGRApkDnQSlBakGs
Qe5CMEJyQrVC90M6Q31DwEQDREdEikTORRJFVUWaRd5GIkZnRqtG8Ec1R3tHwEgF
SEtIkUjXSR1JY0mpSfBKN0p9SsRLDEtTS5pL4kwqTHJMuk0CTUpNk03cTiVObk63
TwBPSU+TT91QJ1BxULtRBlFQUZtR5lIxUnxSx1MTU19TqlP2VEJUj1TbVShVdVXC
Vg9WXFapVvdXRFeSV+BYL1h9WMtZGllpWbhaB1pWWqZa9VtFW5Vb5Vw1XIZc1l0n
XXhdyV4aXmxevV8PX2Ffs2AFYFdgqmD8YU9homH1YklinGLwY0Njl2PrZEBklGTp
ZT1lkmXnZj1mkmboZz1nk2fpaD9olmjsaUNpmmnxakhqn2r3a09rp2v/bFdsr20I
bWBtuW4SbmtuxG8eb3hv0XArcIZw4HE6cZVx8HJLcqZzAXNdc7h0FHRwdMx1KHWF
deF2Pnabdvh3VnezeBF4bnjMeSp5iXnnekZ6pXsEe2N7wnwhfIF84X1BfaF+AX5i
fsJ/I3+Ef+WAR4CogQqBa4HNgjCCkoL0g1eDuoQdhICE44VHhauGDoZyhteHO4ef
iASIaYjOiTOJmYn+imSKyoswi5aL/IxjjMqNMY2Yjf+OZo7OjzaPnpAGkG6Q1pE/
kaiSEZJ6kuOTTZO2lCCUipT0lV+VyZY0lp+XCpd1l+CYTJi4mSSZkJn8mmia1ZtC
m6+cHJyJnPedZJ3SnkCerp8dn4uf+qBpoNihR6G2oiailqMGo3aj5qRWpMelOKWp
phqmi6b9p26n4KhSqMSpN6mpqhyqj6sCq3Wr6axcrNCtRK24ri2uoa8Wr4uwALB1
sOqxYLHWskuywrM4s660JbSctRO1irYBtnm28Ldot+C4WbjRuUq5wro7urW7Lrun
vCG8m70VvY++Cr6Evv+/er/1wHDA7MFnwePCX8Lbw1jD1MRRxM7FS8XIxkbGw8dB
x7/IPci8yTrJuco4yrfLNsu2zDXMtc01zbXONs62zzfPuNA50LrRPNG+0j/SwdNE
08bUSdTL1U7V0dZV1tjXXNfg2GTY6Nls2fHadtr724DcBdyK3RDdlt4c3qLfKd+v
4DbgveFE4cziU+Lb42Pj6+Rz5PzlhOYN5pbnH+ep6DLovOlG6dDqW+rl63Dr++yG
7RHtnO4o7rTvQO/M8Fjw5fFy8f/yjPMZ86f0NPTC9VD13vZt9vv3ivgZ+Kj5OPnH
+lf65/t3/Af8mP0p/br+S/7c/23//2Rlc2MAAAAAAAAALklFQyA2MTk2Ni0yLTEg
RGVmYXVsdCBSR0IgQ29sb3VyIFNwYWNlIC0gc1JHQgAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAABYWVogAAAAAAAAYpkAALeFAAAY2lhZWiAAAAAAAAAAAABQ
AAAAAAAAbWVhcwAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACWFlaIAAA
AAAAAAMWAAADMwAAAqRYWVogAAAAAAAAb6IAADj1AAADkHNpZyAAAAAAQ1JUIGRl
c2MAAAAAAAAALVJlZmVyZW5jZSBWaWV3aW5nIENvbmRpdGlvbiBpbiBJRUMgNjE5
NjYtMi0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAA
9tYAAQAAAADTLXRleHQAAAAAQ29weXJpZ2h0IEludGVybmF0aW9uYWwgQ29sb3Ig
Q29uc29ydGl1bSwgMjAwOQAAc2YzMgAAAAAAAQxEAAAF3///8yYAAAeUAAD9j///
+6H///2iAAAD2wAAwHX/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8S
EhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4I
CA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4e
Hh4eHh4eHh7/wAARCACCAFYDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAA
BAUAAwYBBwL/xAA6EAACAQMDAgQEBAIJBQAAAAABAgMABBEFEiExQQYTUWEUInGB
BzKRwSNCCDRSYnKhsdHwJEOCwuH/xAAaAQACAwEBAAAAAAAAAAAAAAADBAECBQAG
/8QALxEAAgECBQAJBAIDAAAAAAAAAQIAAxEEEiExQQUTIlFxgZGh8DNhscEU0TI0
Qv/aAAwDAQACEQMRAD8A8Uhh2jcoBxRCbndQq8nrUlkSJMbgGI5FUWd5H8QuCM55
pColrmUJBE1WlWzJASwxkVofDsSNHtkGdpwOazyaoqWhAx0obTNcmS5zEcg9c9KU
ek7UGDSAwvNB4hsI4pzIvCkZ+lILW7kV2jEhx05NM7u+e7iYOwLY/Ss9OoWU84wO
1Bw1FGFm3g2IBvKtSVXuQR8xFUXxZIeGODV0cqmTB5FMbDSJtaultbbCqvzSyt+W
JO7N+w7nin6lBAATsJGbmIrK3LLuwSKJDGPAXNF3slpHdziwBW13YiDHJKjgE+5x
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
SpUr2VD6a+EKu0//2Q==
</DataFile>
</SignedDoc>
</dhl:dokument>
',
           'Local loopback test (should be sent through central server)',
           @org_code,
           @org_name,
           '',
           '',
           @org_code,
           @org_name,
           '',
           '',
           '',
           @dvk_folder_name,
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
           NULL)
GO
