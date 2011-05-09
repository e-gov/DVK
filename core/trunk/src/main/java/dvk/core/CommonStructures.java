package dvk.core;

public class CommonStructures {
    public static final int SendingMethod_XTee = 1;
    public static final int SendingMethod_EMail = 2;
    public static final String SendingMethod_XTee_Name = "xtee";
    public static final String SendingMethod_EMail_Name = "epost";

    public static final int SendStatus_Sending = 101;
    public static final int SendStatus_Sent = 102;
    public static final int SendStatus_Canceled = 103;
    public static final String SendStatus_Sending_Name = "saatmisel";
    public static final String SendStatus_Sent_Name = "saadetud";
    public static final String SendStatus_Canceled_Name = "katkestatud";
    
    public static final String AutomaticMetadataNamespace = "http://www.riik.ee/schemas/dhl-meta-automatic";
    public static final String ManualMetadataNamespace = "http://www.riik.ee/schemas/dhl-meta-manual";
    public static final String DhlNamespace = "http://www.riik.ee/schemas/dhl";
    
    public static final String AutomaticMetadataNamespaceV2 = "http://www.riik.ee/schemas/dhl-meta-automatic.v2";
    public static final String ManualMetadataNamespaceV2 = "http://www.riik.ee/schemas/dhl-meta-manual.v2";
    public static final String DhlNamespaceV2 = "http://www.riik.ee/schemas/dhl/2010/2"; 
    
    // Veateadete tekstid
    public static final String VIGA_XTEE_PAISED_PUUDU = "Esitatud sõnumil puuduvad vajalikud X-Tee päised!";
    public static final String VIGA_XTEE_ASUTUSE_PAIS_PUUDU = "Esitatud sõnumi X-Tee päised ei sisalda informatsiooni sõnumi saatnud asutuse kohta!";
    public static final String VIGA_XTEE_ISIKU_PAIS_PUUDU = "Esitatud sõnumi X-Tee päised ei sisalda informatsiooni sõnumi saatnud isiku kohta!";
    public static final String VIGA_TUNDMATU_ASUTUS = "Esitatud sõnumi saatjaks märgitud asutus (#1) ei kuulu DVK-d kasutavate asutuste hulka!";
    public static final String VIGA_TUNDMATU_ISIK = "Esitatud sõnumi saatjaks märgitud isik ei kuulu DVK-s registreeritud isikute hulka!";
    public static final String VIGA_PUUDUV_MIME_LISA = "Viga MIME lisade töötlemisel! Sõnumi kehas märgitud ID-le vastavat MIME lisa ei õnnestunud leida!";
    public static final String VIGA_VIGANE_MIME_LISA = "Sonumi lisas edastatud andmed on vigase XML struktuuriga!";
    public static final String VIGA_VIGANE_KEHA = "Viga sõnumi keha töötlemisel!";
    public static final String VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL = "DVK serveri tarkvaraline viga! Saadetud dokumenti ei õnnestunud salvestada!";
    public static final String VIGA_SAADETUD_DOKUMENDI_TOOTLEMISEL = "Viga saadetud dokumendi andmete töötlemisel! Palume kontrollida, et saadetud dokument vastaks kokkulepitud struktuurile!";
    public static final String VIGA_PUUDUV_TAG = "Puuduv kohustuslik XML-tag: #1";
    public static final String VIGA_VASTUSSONUMI_KOOSTAMISEL = "DVK serveri tarkvaraline viga! Viga vastussõnumi koostamisel!";
    public static final String VIGA_PUUDULIKUD_VASTUVOTJA_KONTAKTID = "Antud dokumenti ei ole võimalik saajale edastada, kuna asutus #1 ei ole DVK-ga liitunud või ei suuda DVK kaudu andmeid vahetada!";
    public static final String VIGA_AADRESSANDMED_PUUDU = "Viga saadetud sõnumi andmetes! Dokumendi saatja ja saajate andmed on puudu!";
    public static final String VIGA_VALE_ARV_SAATJAID = "Viga saadetud sõnumi andmetes! Kui transpordi plokk on täidetud, siis peab dokumendi olema täpselt üks saatja!";
    public static final String VIGA_VALE_ARV_VASTUVOTJAID = "Viga saadetud sõnumi andmetes! Kui transpordi plokk on täidetud, siis peab dokumendi olema vähemalt üks saaja!";
    public static final String VIGA_AMETIKOHATA_ISIK = "Esitatud sõnumi saatjaks märgitud isik ei täida oma asutuses ühtegi ametikohta!";
    public static final String VIGA_TUNDMATU_SAATJA_ASUTUS = "Dokumendi saatjaks märgitud asutus (#1) ei kuulu DVK-d kasutavate asutuste hulka!";
    public static final String VIGA_TUNDMATU_VAHENDAJA_ASUTUS = "Dokumendi vahendajaks märgitud asutus (#1) ei kuulu DVK-d kasutavate asutuste hulka!";
    public static final String VIGA_SAATJA_ASUTUSED_ERINEVAD = "X-Tee kaudu dokumendi saatnud asutus erineb dokumendi sisus saatjaks m�rgitud asutusest!";
    public static final String VIGA_ANDMEBAASIGA_YHENDAMISEL = "DVK serveri tarkvaraline viga! Viga andmebaasiga ühendamisel!";
    public static final String VIGA_ANDMEBAASI_SALVESTAMISEL = "DVK serveri tarkvaraline viga! Viga andmete andmebaasi salvestamisel!";
    public static final String VIGA_ANDMEBAASIYHENDUSE_LOOMISEL = "DVK serveri tarkvaraline viga! Viga andmebaasiühenduse loomisel!";
    public static final String VIGA_PARINGU_VERSIOONIS = "X-Tee päises nimetatud päringu versiooni ei eksisteeri!";
    public static final String VIGA_ASUTUS_BLOKEERITUD = "DVK päringud on asutusele #1 blokeeritud. Blokeeringu eemaldamiseks pöörduge palun DVK halduri poole.";
    
    // Rollid
    public static final String ROLL_ASUTUSE_ADMIN = "DHL: asutuse administraator";
    public static final String ROLL_ALLYKSUSE_ADMIN = "DHL: allyksuse administraator";
    
    // Nimeruumid
    public static final String NS_XTEE_PREFIX = "xtee";
    public static final String NS_XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";
    public static final String NS_SOAPENC_PREFIX = "SOAP-ENC";
    public static final String NS_SOAPENC_URI = "http://schemas.xmlsoap.org/soap/encoding/";
    public static final String NS_XSI_PREFIX = "xsi";
    public static final String NS_XSI_URI = "http://www.w3.org/2001/XMLSchema-instance";
    public static final String NS_DHL_PREFIX = "dhl";
    public static final String NS_DHL_URI = "http://www.riik.ee/schemas/dhl";
    public static final String NS_DVK_MAIN = "http://producers.dhl.xtee.riik.ee/producer/dhl";
    public static final String NS_AAR_MAIN = "http://producers.aar.xtee.riik.ee/producer/aar";
    
    // Saatmisviisid
    public static final String SENDING_DHL = "dhl";
    public static final String SENDING_DHL_DIRECT = "dhl_otse";
    
    // Veakoodid
    public static final String FAULT_ACTOR = "http://producers.dhl.xtee.riik.ee/producer/dhl";
    public static final String FAULT_EXPIRED_CODE = "DVK-ERR-001";
    public static final String FAULT_INVALID_CONTAINER_CODE = "DVK-ERR-002";
    
    // Andmebaasiplatvormid
    public static final String PROVIDER_TYPE_MSSQL = "MSSQL";
    public static final String PROVIDER_TYPE_MSSQL_2005 = "MSSQL2005";
    public static final String PROVIDER_TYPE_ORACLE = "ORACLE";
    public static final String PROVIDER_TYPE_POSTGRE = "POSTGRE";
	public static final String PROVIDER_TYPE_SQLANYWHERE = "SQLANYWHERE";
}
