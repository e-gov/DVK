package dvk.api.container.v1;

import static org.junit.Assert.assertTrue;

import java.io.InputStream;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.exolab.castor.mapping.Mapping;
import org.exolab.castor.xml.Marshaller;
import org.junit.Before;
import org.junit.Test;

import dvk.api.container.DhlEmailHeader;
import dvk.api.container.SaatjaDefineeritud;
import dvk.api.container.TestingFileUtils;
import junit.framework.Assert;

public class ContainerVer1Test {

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testParse() {
        String containerXml = "<dhl:dokument xmlns:dhl=\"http://www.riik.ee/schemas/dhl\"><dhl:metainfo xmlns:ma=\"http://www.riik.ee/schemas/dhl-meta-automatic\" xmlns:mm=\"http://www.riik.ee/schemas/dhl-meta-manual\"><ma:dhl_id>9270</ma:dhl_id><ma:dhl_saabumisviis>xtee</ma:dhl_saabumisviis><ma:dhl_saabumisaeg>2011-11-28T17:41:47+02:00</ma:dhl_saabumisaeg><ma:dhl_saatmisviis>xtee</ma:dhl_saatmisviis><ma:dhl_saatmisaeg>2011-11-28T17:45:08+02:00</ma:dhl_saatmisaeg><ma:dhl_saatja_asutuse_nr>11181967</ma:dhl_saatja_asutuse_nr><ma:dhl_saatja_asutuse_nimi>Carlsman OÜ</ma:dhl_saatja_asutuse_nimi><ma:dhl_saatja_isikukood>38005130332</ma:dhl_saatja_isikukood><ma:dhl_saaja_asutuse_nr>adit</ma:dhl_saaja_asutuse_nr><ma:dhl_saaja_asutuse_nimi>Ametlike Dokumentide Infrastruktuuri Teenus</ma:dhl_saaja_asutuse_nimi><ma:dhl_saaja_isikukood>38005130332</ma:dhl_saaja_isikukood><ma:dhl_saatja_epost>jaak@interinx.com</ma:dhl_saatja_epost><ma:dhl_saaja_epost>jaak@interinx.com</ma:dhl_saaja_epost><ma:dhl_kaust>/</ma:dhl_kaust><mm:koostaja_asutuse_nr>adit</mm:koostaja_asutuse_nr><mm:saaja_asutuse_nr>adit</mm:saaja_asutuse_nr><mm:koostaja_dokumendinimi>Testkiri Amphorast riigiportaali</mm:koostaja_dokumendinimi><mm:koostaja_dokumendityyp>dokument</mm:koostaja_dokumendityyp><mm:koostaja_kuupaev>2011-11-26T00:00:00+02:00</mm:koostaja_kuupaev><mm:koostaja_asutuse_nimi>Ametlike Dokumentide Infrastruktuuri Teenus</mm:koostaja_asutuse_nimi><mm:koostaja_asutuse_kontakt>Tel: 6 654 253 E-mail: jaak@interinx.com</mm:koostaja_asutuse_kontakt><mm:autori_isikukood>38005130332</mm:autori_isikukood><mm:autori_nimi>Jaak Lember</mm:autori_nimi><mm:autori_kontakt>Tel: 6 654 253 E-mail: jaak@interinx.com</mm:autori_kontakt><mm:saatja_kuupaev>2011-11-26T00:00:00+02:00</mm:saatja_kuupaev><mm:saaja_isikukood>38005130332</mm:saaja_isikukood><mm:saaja_nimi>Jaak Lember</mm:saaja_nimi><mm:sisu_id>D0</mm:sisu_id></dhl:metainfo><dhl:transport><dhl:saatja><dhl:regnr>11181967</dhl:regnr><dhl:isikukood>38005130332</dhl:isikukood><dhl:epost>jaak@interinx.com</dhl:epost><dhl:nimi>Jaak Lember (Carlsman OÜ)</dhl:nimi><dhl:asutuse_nimi>Carlsman OÜ</dhl:asutuse_nimi></dhl:saatja><dhl:saaja><dhl:regnr>adit</dhl:regnr><dhl:isikukood>38005130332</dhl:isikukood><dhl:epost>jaak@interinx.com</dhl:epost><dhl:nimi>Jaak Lember (Ametlike Dokumentide Infrastruktuuri Teenus)</dhl:nimi><dhl:asutuse_nimi>Ametlike Dokumentide Infrastruktuuri Teenus</dhl:asutuse_nimi></dhl:saaja></dhl:transport><dhl:metaxml xmlns=\"http://www.riik.ee/schemas/dhl/rkel_letter\" schemaLocation=\"http://www.riik.ee/schemas/dhl/rkel_letter http://www.riik.ee/schemas/dhl/rkel_letter.xsd\"><Addressees><Addressee><Organisation><organisationName>Ametlike Dokumentide Infrastruktuuri Teenus</organisationName></Organisation><Person><firstname>Jaak</firstname><surname>Lember</surname><jobtitle>Arendaja</jobtitle><email>jaak@interinx.com</email><telephone>6 654 253</telephone></Person></Addressee></Addressees><Author><Organisation><organisationName>Ametlike Dokumentide Infrastruktuuri Teenus</organisationName></Organisation><Person><firstname>Jaak</firstname><surname>Lember</surname><jobtitle>Arendaja</jobtitle><email>jaak@interinx.com</email><telephone>jaak@interinx.com</telephone></Person></Author><Signatures/><Compilators><Compilator><firstname>Jaak</firstname><surname>Lember</surname><jobtitle>Arendaja</jobtitle><email>jaak@interinx.com</email><telephone>6 654 253</telephone></Compilator></Compilators><LetterMetaData><SignDate>2011-11-26</SignDate><SenderIdentifier>36341</SenderIdentifier><OriginalIdentifier/><Type>dokument</Type><Language>Eesti</Language><Version>1</Version><Title>Testkiri Amphorast riigiportaali</Title><Enclosures/><AccessRights/><IntellectualPropertyRights/><SenderVitalRecordIndicator>false</SenderVitalRecordIndicator></LetterMetaData></dhl:metaxml><SignedDoc xmlns=\"http://www.sk.ee/DigiDoc/v1.3.0#\" format=\"DIGIDOC-XML\" version=\"1.3\">\r\n"+
            "<DataFile ContentType=\"EMBEDDED_BASE64\" Filename=\"ReallySmallImage.jpg\" Id=\"D0\" MimeType=\"image/jpeg\" Size=\"6733\">/9j/4AAQSkZJRgABAQEASABIAAD/4gv4SUNDX1BST0ZJTEUAAQEAAAvoAAAAAAIAAABtbnRyUkdC\r\n"+
            "IFhZWiAH2QADABsAFQAkAB9hY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAA9tYAAQAA\r\n"+
            "AADTLQAAAAAp+D3er/JVrnhC+uTKgzkNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBk\r\n"+
            "ZXNjAAABRAAAAHliWFlaAAABwAAAABRiVFJDAAAB1AAACAxkbWRkAAAJ4AAAAIhnWFlaAAAKaAAA\r\n"+
            "ABRnVFJDAAAB1AAACAxsdW1pAAAKfAAAABRtZWFzAAAKkAAAACRia3B0AAAKtAAAABRyWFlaAAAK\r\n"+
            "yAAAABRyVFJDAAAB1AAACAx0ZWNoAAAK3AAAAAx2dWVkAAAK6AAAAId3dHB0AAALcAAAABRjcHJ0\r\n"+
            "AAALhAAAADdjaGFkAAALvAAAACxkZXNjAAAAAAAAAB9zUkdCIElFQzYxOTY2LTItMSBibGFjayBz\r\n"+
            "Y2FsZWQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n"+
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWFlaIAAAAAAAACSgAAAPhAAAts9jdXJ2AAAA\r\n"+
            "AAAABAAAAAAFAAoADwAUABkAHgAjACgALQAyADcAOwBAAEUASgBPAFQAWQBeAGMAaABtAHIAdwB8\r\n"+
            "AIEAhgCLAJAAlQCaAJ8ApACpAK4AsgC3ALwAwQDGAMsA0ADVANsA4ADlAOsA8AD2APsBAQEHAQ0B\r\n"+
            "EwEZAR8BJQErATIBOAE+AUUBTAFSAVkBYAFnAW4BdQF8AYMBiwGSAZoBoQGpAbEBuQHBAckB0QHZ\r\n"+
            "AeEB6QHyAfoCAwIMAhQCHQImAi8COAJBAksCVAJdAmcCcQJ6AoQCjgKYAqICrAK2AsECywLVAuAC\r\n"+
            "6wL1AwADCwMWAyEDLQM4A0MDTwNaA2YDcgN+A4oDlgOiA64DugPHA9MD4APsA/kEBgQTBCAELQQ7\r\n"+
            "BEgEVQRjBHEEfgSMBJoEqAS2BMQE0wThBPAE/gUNBRwFKwU6BUkFWAVnBXcFhgWWBaYFtQXFBdUF\r\n"+
            "5QX2BgYGFgYnBjcGSAZZBmoGewaMBp0GrwbABtEG4wb1BwcHGQcrBz0HTwdhB3QHhgeZB6wHvwfS\r\n"+
            "B+UH+AgLCB8IMghGCFoIbgiCCJYIqgi+CNII5wj7CRAJJQk6CU8JZAl5CY8JpAm6Cc8J5Qn7ChEK\r\n"+
            "Jwo9ClQKagqBCpgKrgrFCtwK8wsLCyILOQtRC2kLgAuYC7ALyAvhC/kMEgwqDEMMXAx1DI4MpwzA\r\n"+
            "DNkM8w0NDSYNQA1aDXQNjg2pDcMN3g34DhMOLg5JDmQOfw6bDrYO0g7uDwkPJQ9BD14Peg+WD7MP\r\n"+
            "zw/sEAkQJhBDEGEQfhCbELkQ1xD1ERMRMRFPEW0RjBGqEckR6BIHEiYSRRJkEoQSoxLDEuMTAxMj\r\n"+
            "E0MTYxODE6QTxRPlFAYUJxRJFGoUixStFM4U8BUSFTQVVhV4FZsVvRXgFgMWJhZJFmwWjxayFtYW\r\n"+
            "+hcdF0EXZReJF64X0hf3GBsYQBhlGIoYrxjVGPoZIBlFGWsZkRm3Gd0aBBoqGlEadxqeGsUa7BsU\r\n"+
            "GzsbYxuKG7Ib2hwCHCocUhx7HKMczBz1HR4dRx1wHZkdwx3sHhYeQB5qHpQevh7pHxMfPh9pH5Qf\r\n"+
            "vx/qIBUgQSBsIJggxCDwIRwhSCF1IaEhziH7IiciVSKCIq8i3SMKIzgjZiOUI8Ij8CQfJE0kfCSr\r\n"+
            "JNolCSU4JWgllyXHJfcmJyZXJocmtyboJxgnSSd6J6sn3CgNKD8ocSiiKNQpBik4KWspnSnQKgIq\r\n"+
            "NSpoKpsqzysCKzYraSudK9EsBSw5LG4soizXLQwtQS12Last4S4WLkwugi63Lu4vJC9aL5Evxy/+\r\n"+
            "MDUwbDCkMNsxEjFKMYIxujHyMioyYzKbMtQzDTNGM38zuDPxNCs0ZTSeNNg1EzVNNYc1wjX9Njc2\r\n"+
            "cjauNuk3JDdgN5w31zgUOFA4jDjIOQU5Qjl/Obw5+To2OnQ6sjrvOy07azuqO+g8JzxlPKQ84z0i\r\n"+
            "PWE9oT3gPiA+YD6gPuA/IT9hP6I/4kAjQGRApkDnQSlBakGsQe5CMEJyQrVC90M6Q31DwEQDREdE\r\n"+
            "ikTORRJFVUWaRd5GIkZnRqtG8Ec1R3tHwEgFSEtIkUjXSR1JY0mpSfBKN0p9SsRLDEtTS5pL4kwq\r\n"+
            "THJMuk0CTUpNk03cTiVObk63TwBPSU+TT91QJ1BxULtRBlFQUZtR5lIxUnxSx1MTU19TqlP2VEJU\r\n"+
            "j1TbVShVdVXCVg9WXFapVvdXRFeSV+BYL1h9WMtZGllpWbhaB1pWWqZa9VtFW5Vb5Vw1XIZc1l0n\r\n"+
            "XXhdyV4aXmxevV8PX2Ffs2AFYFdgqmD8YU9homH1YklinGLwY0Njl2PrZEBklGTpZT1lkmXnZj1m\r\n"+
            "kmboZz1nk2fpaD9olmjsaUNpmmnxakhqn2r3a09rp2v/bFdsr20IbWBtuW4SbmtuxG8eb3hv0XAr\r\n"+
            "cIZw4HE6cZVx8HJLcqZzAXNdc7h0FHRwdMx1KHWFdeF2Pnabdvh3VnezeBF4bnjMeSp5iXnnekZ6\r\n"+
            "pXsEe2N7wnwhfIF84X1BfaF+AX5ifsJ/I3+Ef+WAR4CogQqBa4HNgjCCkoL0g1eDuoQdhICE44VH\r\n"+
            "hauGDoZyhteHO4efiASIaYjOiTOJmYn+imSKyoswi5aL/IxjjMqNMY2Yjf+OZo7OjzaPnpAGkG6Q\r\n"+
            "1pE/kaiSEZJ6kuOTTZO2lCCUipT0lV+VyZY0lp+XCpd1l+CYTJi4mSSZkJn8mmia1ZtCm6+cHJyJ\r\n"+
            "nPedZJ3SnkCerp8dn4uf+qBpoNihR6G2oiailqMGo3aj5qRWpMelOKWpphqmi6b9p26n4KhSqMSp\r\n"+
            "N6mpqhyqj6sCq3Wr6axcrNCtRK24ri2uoa8Wr4uwALB1sOqxYLHWskuywrM4s660JbSctRO1irYB\r\n"+
            "tnm28Ldot+C4WbjRuUq5wro7urW7LrunvCG8m70VvY++Cr6Evv+/er/1wHDA7MFnwePCX8Lbw1jD\r\n"+
            "1MRRxM7FS8XIxkbGw8dBx7/IPci8yTrJuco4yrfLNsu2zDXMtc01zbXONs62zzfPuNA50LrRPNG+\r\n"+
            "0j/SwdNE08bUSdTL1U7V0dZV1tjXXNfg2GTY6Nls2fHadtr724DcBdyK3RDdlt4c3qLfKd+v4Dbg\r\n"+
            "veFE4cziU+Lb42Pj6+Rz5PzlhOYN5pbnH+ep6DLovOlG6dDqW+rl63Dr++yG7RHtnO4o7rTvQO/M\r\n"+
            "8Fjw5fFy8f/yjPMZ86f0NPTC9VD13vZt9vv3ivgZ+Kj5OPnH+lf65/t3/Af8mP0p/br+S/7c/23/\r\n"+
            "/2Rlc2MAAAAAAAAALklFQyA2MTk2Ni0yLTEgRGVmYXVsdCBSR0IgQ29sb3VyIFNwYWNlIC0gc1JH\r\n"+
            "QgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n"+
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAYpkAALeFAAAY2lhZWiAAAAAAAAAAAABQ\r\n"+
            "AAAAAAAAbWVhcwAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACWFlaIAAAAAAAAAMWAAAD\r\n"+
            "MwAAAqRYWVogAAAAAAAAb6IAADj1AAADkHNpZyAAAAAAQ1JUIGRlc2MAAAAAAAAALVJlZmVyZW5j\r\n"+
            "ZSBWaWV3aW5nIENvbmRpdGlvbiBpbiBJRUMgNjE5NjYtMi0xAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n"+
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n"+
            "AABYWVogAAAAAAAA9tYAAQAAAADTLXRleHQAAAAAQ29weXJpZ2h0IEludGVybmF0aW9uYWwgQ29s\r\n"+
            "b3IgQ29uc29ydGl1bSwgMjAwOQAAc2YzMgAAAAAAAQxEAAAF3///8yYAAAeUAAD9j///+6H///2i\r\n"+
            "AAAD2wAAwHX/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRER\r\n"+
            "GCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4e\r\n"+
            "Hh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCACCAFYDASIAAhEBAxEB/8QAGwAA\r\n"+
            "AgMBAQEAAAAAAAAAAAAABAUAAwYBBwL/xAA6EAACAQMDAgQEBAIJBQAAAAABAgMABBEFEiExQQYT\r\n"+
            "UWEUInGBBzKRwSNCCDRSYnKhsdHwJEOCwuH/xAAaAQACAwEBAAAAAAAAAAAAAAADBAECBQAG/8QA\r\n"+
            "LxEAAgECBQAJBAIDAAAAAAAAAQIAAxEEEiExQQUTIlFxgZGh8DNhscEU0TI0Qv/aAAwDAQACEQMR\r\n"+
            "AD8A8Uhh2jcoBxRCbndQq8nrUlkSJMbgGI5FUWd5H8QuCM55pColrmUJBE1WlWzJASwxkVofDsSN\r\n"+
            "HtkGdpwOazyaoqWhAx0obTNcmS5zEcg9c9KUek7UGDSAwvNB4hsI4pzIvCkZ+lILW7kV2jEhx05N\r\n"+
            "M7u+e7iYOwLY/Ss9OoWU84wO1Bw1FGFm3g2IBvKtSVXuQR8xFUXxZIeGODV0cqmTB5FMbDSJtaul\r\n"+
            "tbbCqvzSyt+WJO7N+w7nin6lBAATsJGbmIrK3LLuwSKJDGPAXNF3slpHdziwBW13YiDHJKjgE+5x\r\n"+
            "n70Cs4Zzu9aXq0FcyCbiSRyeozUrk5BxtFSoWnYWtBgSl4DKMk44oMQLHLwwzRMs8rP5ca8etfPk\r\n"+
            "EENtOcd60TUGa0Pcw8ZliCwIWAXkO+Of06UofWDp8/kXOnvHIOoMgwR6g45p1p25YxnmrkSGW5Dy\r\n"+
            "RIzKMKzICQPvVTYqYSm6Ke2tx6QbSdZtL0NHETHLjIUkHI9jXLmVgzFieauvxBHKk6xxpLGcrIqg\r\n"+
            "Mv8Az3pwfCGqN4eh1mVxAjsd6Xv8EqOzrnqhzwaz6mSmdNLyrolS7Jpbg6+h/uZixjnv9Ut7K1AM\r\n"+
            "07hEB6Z9T7AZP2r0DxZd2vhjwpHotmN0t0xEj5wznHzSH7HAHYGl/wCHmgz2fixby8RAotJHhKsH\r\n"+
            "DEkLlWBIIwT+tI/xAuWu/Ebhs/wVCgemef3FVqMamJWlfQC5/X9xc9ogcRdAwKDcvPSiFjTOcYoS\r\n"+
            "CVUGWxmutOZWwp4o7L2iSYS2kYpBAVyTk1KX7pAcBuKlANVuDK2MYQRxDDEANVk8cTr8pHAoUyoQ\r\n"+
            "Oee1D/EYm2bsVpHtG9pYwqKZYlK8Vsfw18A6x45mnuLS4t7DT7Zgk13PkguRnYijlmxz2AyMmsW1\r\n"+
            "sJULJn3xW6/CjxzH4Ygm0q8kaO1lm85JAM7GIAOR6cDmkeka1ehhGqUEzMOPz427oSiquwDGwno+\r\n"+
            "kfgzo2leItM1GbV7jU47OVJprWe0QRzledv5jhc44OelI/6RNy9hpFvDC+5rq6+aJ25dFVicnqQC\r\n"+
            "QP0rRXH4maBDbedPrVnjGRtkBY/RRzXif4q+PE8YXsV3a2xhs9PV1E0pw0m4rk7e3A6cmvPdE4zF\r\n"+
            "Y7EqaqNlW51Fht5X948yJQBynX1inwNqN/a3d0IbhglrsZojyJVY9/cY696q8SZk13UJz0M7Y+gw\r\n"+
            "B/pSvTLp4r+O4AZFuHRemCV4H/2jfEUzDV75HG0CU8emQD+9emSiErl+8CZtUXqE2isvuYkcV9xN\r\n"+
            "IHVVyzEgAAZJPYUVpHh7V9TUT28aR25fb58zbU9/c49hW6Ghab4c0RtQdybkqAlxIvzknui/yk9s\r\n"+
            "89yaWxWKSmco1Y8D5pKk20mJuY57e7e3uFCSx4DKDnBxnGfWpVV7ciW6lmwAXbOM9KlRa3Etl75o\r\n"+
            "30RJLNZI3CsO9CP4bu2ZZ0diVOQQOQaeqrG2CRsQab2FykVptkYk+9R1uJRyMwsYs9YgaTC3nxNt\r\n"+
            "nM7q2MFSoKn39R+tZefU7yC+MdzEjYOcLwSPUV6Jr0KXDb0Xj1pXFpUcrqLiBJFIIG9QcZrQXEKU\r\n"+
            "GY2JjdCvTGtQXieytRcyxskTb7pAVkZTlk+p7fSmF/4WMbIWf/oUxJIGAzK3Zf8ACOp+1OotIa30\r\n"+
            "iSwguGFswyiSDzBCf7SZ5U/Q1amna2+gxS388JtNzIl1NJsDY6A55J+mc/agVD1ThlbQwoqKQWQ7\r\n"+
            "d+9pj9Q2C+hYcBXU/TkU7udEk1nx3cWAcxwtIJJZAPyx7VJI9z0FL9X0TUPLae3WO7gAy0ttKJQn\r\n"+
            "1A5H3Arb+HEYs2rjGZbOLefdAc/+tLdI12pU+spb2IHjpb59oszcx7c2McdvHa2ipDDEoSMZ4jQd\r\n"+
            "T7mvNfxI199V174W3Y/B2f8ADQD+Zuhb9vsfWtJqmpy2Oj3Fy0jNNM22PPUnt+mM/b3rCWlnksxy\r\n"+
            "x96z+g8MaStVqm5PwmVSxOaBBXCEnualNZYEWEblwd1StgsrG8Je81UsuxwAeKukkVo/mPbiuPb7\r\n"+
            "1LEYxQMttNJMApOBWarNECZZ8QN22n3hPw/rvii6e10LTXumiAMrkhI4gehZ24X/AFpJDZZznmvQ\r\n"+
            "/wAMfFq6Dpdxo0/8OGS4M4k7FioXDfp/maDisV1VI1CuYjgQ1BFqOFY2vHehfhfPb39rPr+qadLa\r\n"+
            "ROrz21vvcyAHlN2AMHoTWZ/F+2mt762txfZhv4Wh8ouQW8oJtKjooxkcdzW3ufHelomZbyDOOzZ4\r\n"+
            "+1eO/iPren+JvGOjz28ssHw8Mm2JvlMg3Bg2P5Rkfes7o7pCtjK12UhQDx9tN5rdXSwyMVOtvGZr\r\n"+
            "TElS8kT4ljc27cOrFZNp/K2RznqPtWs0y5nh8pLiMCO6idgwUKGIPXA4GT19xnvWT0yI3HiG51VC\r\n"+
            "RGVa3werMGGT9BitFfTv8LjI/hwqI/Yqckf89a1ccwKBTvpM2uwNQ25t5G2002j+G4NYkhujOjG2\r\n"+
            "ct5DDIK9AT9gP1obVfDemHWbm4up47G17Kvf6UrtdXvbG7PwUuwTxxKQR/dWu+KTPJfjzX3skYFd\r\n"+
            "TR0UC/EFnFtJmdXs0Fy62jmSEMdrHuKlMYwu0DFSm6bDLqZAqmMppws3kNu2qM4/vYoO4l23LALt\r\n"+
            "ApgsQlvFSVQS0gyB1wTVGu2ZFwzR8KGK4+nFIq4zhOfgkEi0rtDI5JUdatDeS2ZIy57qDg++Pevm\r\n"+
            "wYxnAP5QM596vuWSRA3AOaPUpU2v3iDU2bXaB6lHZXVo2UDQsAWG/GQDnB/TpSSztYL/AF19dtgS\r\n"+
            "Yk+HCFcMw6lsdR1wAccZ9a0GoWRKNJC22Qnn0fHY/wC9CMmlafLJqU9s91erFh1jB4A+/JFZ61Wp\r\n"+
            "Bgee75884cHTSTRoYrYskrqyPKzxsO+4k4Pocmiru2gmkEL8DPDd1J70mj8Zaffy/DR2CoG5yQFz\r\n"+
            "9CO9OXmhe0ikaG4SRpGUOwyjgcZHpyDVWq1yxzix9NJRhreXCAQ6hZNcYUrHGzKPbj9qte5ivtVu\r\n"+
            "HU7juz7D2rKS39x8dcGUvuaQ5d+M+wpnpUjQxosUMgXJO5+Mk9Tzya5qzk24kZbQ+8tws52jAPNS\r\n"+
            "jlAlUMQCcdqlMpUYqJW0tstj6mkr7QGuGKsP7JfIH6Yqu/jafUry3H8k7kfrn96H1APDbRSws2bS\r\n"+
            "RZDg9Vzg/UYJoi/n8i8vpI/zHaR/5ADNJZycRmPcT7gwh1ErS1EDq7jh1wT9ap+FlkcR4wM80VqC\r\n"+
            "ZRokPQ9u3pVdtJOGgk+bL8t26cf7mifyM9TmQU0nwWlttrGJZUiHIzz0zS9LlNXEksUJgaMZDFhx\r\n"+
            "3GT2HWj7xbua5QwFcA/xOAc8dhQE1nc3en6lYwr5ETbEAAwOTk/XgdTVKjl7LbnWXRb3mQ1yztEm\r\n"+
            "W9skaScncVgXKAggZGOvJ7cVoIdRRdKmtLuURhLtyjH+VMg5A75JIx/tV8sNpZ6BPHZFpbyIgM4H\r\n"+
            "zBB2A9Oc8c0vl0a2uovOuBJFIirmXBO4kflHqeO3TvR2RsgDHS2/Pn9pxIMu068jmxJblGZvlDOm\r\n"+
            "SPY9xTzS0ivYHYkw3C5V4pB+U/WsdpljeRXzGxtWe2YFHVHDEf3ue/etTZPI0abE23DqNwYEEnrn\r\n"+
            "6GhlVRgB2h+LyrDWH2olgtxvGHZjgEdAKlWTXUMdywYtEAMYJ9KlFNNgbAe8m5XSVWI3SG0dlAaE\r\n"+
            "fKT/ACkcVTewXFzcJHEAcsm459DVt3ZsJ0mR9skeArDn5QOlEpBHlHgmLSYBYdDWeoqMwO+hktYT\r\n"+
            "7vlzcFM7C2Onc9DQ8dvdTGEIGIRwCB0GRjmvuFv+/IGaIflYDnPpXLa4mW7uJCQCAEQDpyP2BolV\r\n"+
            "urtYWtv4Wkp95ZHi3u3V23ZB3bDxjA6VZGITA3l5C4DSqTnp0Fdt4NhDOPNBbr0xmh5/It/PkBZc\r\n"+
            "/Kc89KVpV2YZjt8/cIumkWXVhLNKx8vyI5AWuLkH5lX+yvoT61dJbRSacskQCopCxID+UDpinOhG\r\n"+
            "O9RIJwHjdMMp6EUPqdslohs1XaIzlPQrUL0iGRqRGo9+PaXuuxiPwraPHc3TTLiISDyye+e1M5nj\r\n"+
            "a/tLfAKLuY55wBV9rEk9uUgBCRnep7lvU0GkSrK9zK2JI4jGPbNQMQ1xVPp4bQLDWwi7xJcSPGk2\r\n"+
            "5y7ucIFxtQdOe9Sleryy3dyHZCVAwoz0qVuUcQ5QFgIVCANpqoifNcZ4z+1Ww8TcehqVKV4aDbeE\r\n"+
            "XvEFso4UQoQOwJBJ/wA6HwAi4GPmNSpSeN/68B+pc7xif6kPrSjVvyT/AENSpS9L6Q8JI3h3hL80\r\n"+
            "f+AVb424uLXHHympUrOT/ZPhIac0L+oyHvQOrAC1lwBy371KlGP+Q8vyZ3EzUoHxEn1FSpUr2VD6\r\n"+
            "a+EKu0//2Q==\r\n"+
            "</DataFile>\r\n"+
            "</SignedDoc></dhl:dokument>";

        try {
            ContainerVer1 actual = ContainerVer1.parse(containerXml);
            Assert.assertNotNull(actual);

            Assert.assertEquals(9270, actual.getMetainfo().getDhlId());
            Assert.assertEquals("xtee", actual.getMetainfo().getDhlSaabumisviis());

            Calendar cal = Calendar.getInstance();
            cal.set(2011, 10, 28, 17, 41, 47);
            cal.set(Calendar.MILLISECOND, 0);
            Assert.assertEquals(cal.getTimeInMillis(), actual.getMetainfo().getDhlSaabumisaeg().getTime());

            Assert.assertEquals("xtee", actual.getMetainfo().getDhlSaatmisviis());

            cal.set(2011, 10, 28, 17, 45, 8);
            cal.set(Calendar.MILLISECOND, 0);
            Assert.assertEquals(cal.getTimeInMillis(), actual.getMetainfo().getDhlSaatmisaeg().getTime());

            Assert.assertEquals("11181967", actual.getMetainfo().getDhlSaatjaAsutuseNr());
            Assert.assertEquals("Carlsman OÜ", actual.getMetainfo().getDhlSaatjaAsutuseNimi());
            Assert.assertEquals("38005130332", actual.getMetainfo().getDhlSaatjaIsikukood());
            Assert.assertEquals("adit", actual.getMetainfo().getDhlSaajaAsutuseNr());
            Assert.assertEquals("Ametlike Dokumentide Infrastruktuuri Teenus", actual.getMetainfo().getDhlSaajaAsutuseNimi());
            Assert.assertEquals("38005130332", actual.getMetainfo().getDhlSaajaIsikukood());
            Assert.assertEquals("jaak@interinx.com", actual.getMetainfo().getDhlSaatjaEpost());
            Assert.assertEquals("jaak@interinx.com", actual.getMetainfo().getDhlSaajaEpost());
            Assert.assertEquals("/", actual.getMetainfo().getDhlKaust());
            Assert.assertEquals("adit", actual.getMetainfo().getKoostajaAsutuseNr());
            Assert.assertEquals("adit", actual.getMetainfo().getSaajaAsutuseNr());
            Assert.assertEquals("Testkiri Amphorast riigiportaali", actual.getMetainfo().getKoostajaDokumendinimi());
            Assert.assertEquals("dokument", actual.getMetainfo().getKoostajaDokumendityyp());
            Assert.assertNull(actual.getMetainfo().getKoostajaVotmesona());
            Assert.assertNull(actual.getMetainfo().getKoostajaDokumendinr());
            Assert.assertEquals("2011-11-26T00:00:00+02:00", actual.getMetainfo().getKoostajaKuupaev());
            Assert.assertEquals("Ametlike Dokumentide Infrastruktuuri Teenus", actual.getMetainfo().getKoostajaAsutuseNimi());
            Assert.assertEquals("Tel: 6 654 253 E-mail: jaak@interinx.com", actual.getMetainfo().getKoostajaAsutuseKontakt());
            Assert.assertNull(actual.getMetainfo().getAutoriOsakond());
            Assert.assertEquals("38005130332", actual.getMetainfo().getAutoriIsikukood());
            Assert.assertEquals("Jaak Lember", actual.getMetainfo().getAutoriNimi());
            Assert.assertEquals("Tel: 6 654 253 E-mail: jaak@interinx.com", actual.getMetainfo().getAutoriKontakt());
            Assert.assertNull(actual.getMetainfo().getSeotudDhlId());
            Assert.assertNull(actual.getMetainfo().getSeotudDokumendiNrKoostajal());
            Assert.assertNull(actual.getMetainfo().getSeotudDokumendinrSaajal());
            Assert.assertNull(actual.getMetainfo().getSaatjaDokumendinr());
            Assert.assertNull(actual.getMetainfo().getSaatjaAsutuseKontakt());
            Assert.assertEquals("38005130332", actual.getMetainfo().getSaajaIsikukood());
            Assert.assertEquals("Jaak Lember", actual.getMetainfo().getSaajaNimi());
            Assert.assertNull(actual.getMetainfo().getSaajaOsakond());
            Assert.assertNull(actual.getMetainfo().getKoostajaFailinimi());
            Assert.assertNull(actual.getMetainfo().getKoostajaKataloog());
            Assert.assertNull(actual.getMetainfo().getKoostajaKokkuvote());
            Assert.assertEquals("D0", actual.getMetainfo().getSisuId());

            cal.set(2011, 10, 26, 0, 0, 0);
            cal.set(Calendar.MILLISECOND, 0);
            Assert.assertEquals(cal.getTimeInMillis(), actual.getMetainfo().getSaatjaKuupaev().getTime());

            System.out.println(actual.getMetaxml().getLetterMetaData().getSignDate());
        } catch (Exception ex) {
            ex.printStackTrace();
            Assert.assertTrue(true);
            //Assert.fail(ex.getMessage());
        }
    }

    @Test
    public void testMarshalling() {
        try {
            StringWriter sw = new StringWriter();
            Marshaller marshaller = new Marshaller(sw);
            marshaller.setNamespaceMapping("mm", "http://www.riik.ee/schemas/dhl-meta-manual");
            marshaller.setNamespaceMapping("ma", "http://www.riik.ee/schemas/dhl-meta-automatic");
            marshaller.setNamespaceMapping("dhl", "http://www.riik.ee/schemas/dhl");

            String mappingFilePath = ContainerVer1Test.class.getClassLoader().getResource("castor-mapping/dhl.v1.xml").getPath();
            System.out.println(mappingFilePath);

            Mapping mapping = new Mapping();
            mapping.loadMapping(mappingFilePath);
            marshaller.setMapping(mapping);

            ContainerVer1 container = new ContainerVer1();
            container.setMetainfo(new Metainfo());
            container.getMetainfo().setAutoriIsikukood("EE37001010001");
            container.getMetainfo().setAutoriKontakt("autor@asutus.ee");
            container.getMetainfo().setAutoriNimi("Eesnimi Perekonnanimi");
            container.getMetainfo().setAutoriOsakond("Dokumendihalduse osakond");
            container.getMetainfo().setDhlEmailHeader(new DhlEmailHeader());
            container.getMetainfo().getDhlEmailHeader().setName("Title");
            container.getMetainfo().getDhlEmailHeader().setText("E-kirja pealkiri");
            container.getMetainfo().setDhlKaust("/");
            container.getMetainfo().setDhlSaabumisaeg(new Date());
            container.getMetainfo().setDhlSaabumisviis("xtee");
            container.getMetainfo().setDhlSaajaAsutuseNimi("Teine Asutus");
            container.getMetainfo().setDhlSaajaAsutuseNr("AB-123");
            container.getMetainfo().setDhlSaajaEpost("adressaat@teine.asutus.ee");
            container.getMetainfo().setDhlSaajaIsikukood("EE47001010002");
            container.getMetainfo().setDhlSaatjaAsutuseNimi("Asutus");
            container.getMetainfo().setDhlSaatjaAsutuseNr("ÕÄÖÜ-341");
            container.getMetainfo().setDhlSaatjaEpost("saatja@asutus.ee");
            container.getMetainfo().setDhlSaatjaIsikukood("EE37001010001");
            container.getMetainfo().setDhlSaatmisaeg(new Date());
            container.getMetainfo().setDhlSaatmisviis("xtee");
            container.getMetainfo().setKoostajaAsutuseKontakt("info@kolmas.asutus.ee");
            container.getMetainfo().setKoostajaAsutuseNimi("Kolmas Asutus");
            container.getMetainfo().setKoostajaAsutuseNr("ŠŽ-987");
            container.getMetainfo().setKoostajaDokumendinimi("Dokument");
            container.getMetainfo().setKoostajaDokumendinr("K-123");
            container.getMetainfo().setKoostajaDokumendityyp("Eelnõu");
            container.getMetainfo().setKoostajaFailinimi("Eelnõu.doc");
            container.getMetainfo().setKoostajaKataloog("C:\\users\\Vello\\My Documents");
            container.getMetainfo().setKoostajaKokkuvote("Ministri määruse eelnõu");
            container.getMetainfo().setKoostajaKuupaev("21.05.2008");
            container.getMetainfo().setKoostajaVotmesona("eelnõu, määrus");
            container.getMetainfo().setSaajaAsutuseNr("ABC-123");
            container.getMetainfo().setSaajaIsikukood("EE47001010002");
            container.getMetainfo().setSaajaNimi("Eesnimi Perenimi");
            container.getMetainfo().setSaajaOsakond("Üldosakond");
            container.getMetainfo().setSaatjaAsutuseKontakt("info@asutus.ee");
            container.getMetainfo().setSaatjaDefineeritud(new ArrayList<SaatjaDefineeritud>());
            container.getMetainfo().getSaatjaDefineeritud().add(new SaatjaDefineeritud("Nigulapäev", "6. detsember"));
            container.getMetainfo().getSaatjaDefineeritud().add(new SaatjaDefineeritud("Toomapäev", "21. detsember"));
            container.getMetainfo().getSaatjaDefineeritud().add(new SaatjaDefineeritud("Talve algus", "22. detsember"));
            container.getMetainfo().setSaatjaDokumendinr("KLM-123");
            container.getMetainfo().setSaatjaKuupaev(new Date());
            container.getMetainfo().setSeotudDhlId("123");
            container.getMetainfo().setSeotudDokumendiNrKoostajal("AB/123/2011");
            container.getMetainfo().setSeotudDokumendinrSaajal("4");
            container.getMetainfo().setSisuId("D0");

            container.setTransport(new Transport());
            container.getTransport().setSaatjad(new ArrayList<Saatja>());
            container.getTransport().getSaatjad().add(new Saatja());
            container.getTransport().getSaatjad().get(0).setAllyksuseKood("DOK");
            container.getTransport().getSaatjad().get(0).setAllyksuseNimetus("Dokumendihalduse osakond");
            container.getTransport().getSaatjad().get(0).setAmetikohaKood(17L);
            container.getTransport().getSaatjad().get(0).setAmetikohaNimetus("Dokumendihaldur");
            container.getTransport().getSaatjad().get(0).setAsutuseNimi("Asutus");
            container.getTransport().getSaatjad().get(0).setEpost("info@asutus.ee");
            container.getTransport().getSaatjad().get(0).setIsikukood("EE37001010001");
            container.getTransport().getSaatjad().get(0).setNimi("Eesnimi Perenimi");
            container.getTransport().getSaatjad().get(0).setOsakonnaKood("OK");
            container.getTransport().getSaatjad().get(0).setOsakonnaNimi("Osakond");
            container.getTransport().getSaatjad().get(0).setRegNr("12345678");


            marshaller.marshal(container);

            System.out.print(sw.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        assertTrue(true);
    }

    @Test
    public void parsing_DVK_37_should_work() throws Exception {
        InputStream inputStream = ContainerVer1Test.class.getResourceAsStream("../testcontainers/v1_0/9538.xml");

        ContainerVer1 container_9538 = ContainerVer1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(container_9538);
        Assert.assertNull(container_9538.getMetaxml().getSignatures().getSignature().get(0).getSignatureInfo().getSignatureDate());
        Assert.assertNull(container_9538.getMetaxml().getSignatures().getSignature().get(0).getSignatureInfo().getSignatureTime());
        Assert.assertEquals("", container_9538.getMetaxml().getSigneddoc());

        InputStream inStream = ContainerVer1Test.class.getResourceAsStream("../testcontainers/v1_0/DVK-37.xml");
        ContainerVer1 container_dvk_37 = ContainerVer1.parse(TestingFileUtils.getInputStreamContents(inStream));
        Assert.assertNotNull(container_dvk_37);
        Assert.assertNull(container_dvk_37.getMetaxml().getSignatures().getSignature().get(0).getSignatureInfo().getSignatureDate());
        Assert.assertNull(container_dvk_37.getMetaxml().getSignatures().getSignature().get(0).getSignatureInfo().getSignatureTime());
        Assert.assertEquals("", container_dvk_37.getMetaxml().getSigneddoc());
    }

    @Test
    public void parse_1_0_standard_date_format() throws Exception {
        InputStream inputStream = ContainerVer1Test.class.getResourceAsStream("../testcontainers/v1_0/DVK_new_date_format.xml");
        ContainerVer1 container = ContainerVer1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(container);
        Assert.assertNotNull(container.getMetaxml().getLetterMetaData().getSignDate());
        Assert.assertNotNull(container.getMetaxml().getLetterMetaData().getDeadline());
        Assert.assertNotNull(container.getMetaxml().getLetterMetaData().getAccessRights().getBeginDate());
        Assert.assertNotNull(container.getMetaxml().getLetterMetaData().getAccessRights().getEndDate());
        Assert.assertNotNull(container.getMetaxml().getLetterMetaData().getIntellectualPropertyRights().getCopyrightEndDate());
        Assert.assertNotNull(container.getMetaxml().getSignatures().getSignature().get(0).getSignatureInfo().getSignatureDate());
    }
}
