package dvk.api.container.v2_1;

import dvk.api.container.TestingFileUtils;
import org.apache.log4j.Logger;
import org.junit.Assert;
import org.junit.Test;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Container version 2.1 unit tests for converting from xml to objects.
 *
 * @author Hendrik Pärna
 * @since 27.01.14
 */
public class ContainerVer2_1Test {
    private static Logger logger = Logger.getLogger(ContainerVer2_1Test.class);

    @Test
    public void testParseTransportBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide1.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));

        Assert.assertNotNull(containerVer2_1.getTransport());
        DecSender sender = containerVer2_1.getTransport().getDecSender();
        Assert.assertNotNull(sender);
        Assert.assertEquals("87654321", sender.getOrganisationCode());
        Assert.assertEquals("EE38806190294", sender.getPersonalIdCode());
        Assert.assertNotNull(containerVer2_1.getTransport().getDecRecipient());
        DecRecipient recipient = containerVer2_1.getTransport().getDecRecipient().get(0);
        Assert.assertEquals("87654321", recipient.getOrganisationCode());
        DecMetadata decMetadata = containerVer2_1.getDecMetadata();
        Assert.assertNotNull(decMetadata);
        Assert.assertEquals("410125", decMetadata.getDecId());
        Assert.assertEquals("/", decMetadata.getDecFolder());
    }

    @Test
    public void testParseFromStringInitiatorBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));

        Assert.assertNotNull(containerVer2_1.getInitiator());
        Initiator initiator = containerVer2_1.getInitiator();
        Assert.assertEquals("213465", initiator.getInitiatorRecordOriginalIdentifier());
        Assert.assertEquals("Sun Nov 11 19:18:03 EET 2012", initiator.getInitiatorRecordDate().toString());
        Assert.assertNull(initiator.getOrganisation());
        Assert.assertNotNull(initiator.getPerson());
        PersonType person = initiator.getPerson();
        Assert.assertEquals("Lauri Tammemäe", person.getName());
        Assert.assertEquals("Lauri", person.getGivenName());
        Assert.assertEquals("Tammemäe", person.getSurname());
        Assert.assertEquals("EE30006190200", person.getPersonalIdCode());
        Assert.assertEquals("EE", person.getResidency());

        Assert.assertNotNull(initiator.getContactData());
        ContactDataType contactData = initiator.getContactData();
        Assert.assertEquals(true, contactData.getAdit());
        Assert.assertEquals("+3726630000", contactData.getPhone());
        Assert.assertEquals("laur.ae@rrr.ee", contactData.getEmail());
        Assert.assertEquals("www.hot.ee/lauri", contactData.getWebPage());
        Assert.assertEquals("skype: lauri.te", contactData.getMessagingAddress());

        Assert.assertNotNull(contactData.getPostalAddress());
        PostalAddressType postalAddress = contactData.getPostalAddress();
        Assert.assertEquals("Eesti", postalAddress.getCountry());
        Assert.assertEquals("Harju maakond", postalAddress.getCounty());
        Assert.assertEquals("Tallinna linn", postalAddress.getLocalGovernment());
        Assert.assertEquals("Mustamäe linnaosa", postalAddress.getAdministrativeUnit());
        Assert.assertEquals("Linnu KÜ", postalAddress.getSmallPlace());
        Assert.assertEquals("", postalAddress.getLandUnit());
        Assert.assertEquals("Mustamäe tee", postalAddress.getStreet());
        Assert.assertEquals("148", postalAddress.getHouseNumber());
        Assert.assertEquals("32", postalAddress.getBuildingPartNumber());
        Assert.assertEquals("11212", postalAddress.getPostalCode());

    }

    @Test
    public void testParseFromStringRecordCreatorBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));

        Assert.assertNotNull(containerVer2_1.getRecordCreator());
        RecordCreator recordCreator = containerVer2_1.getRecordCreator();
        Assert.assertNotNull(recordCreator.getPerson());
        PersonType person = recordCreator.getPerson();
        Assert.assertEquals("Kadi Krull", person.getName());
        Assert.assertEquals("Kadi", person.getGivenName());
        Assert.assertEquals("Krull", person.getSurname());
        Assert.assertEquals("EE48210024718", person.getPersonalIdCode());
        Assert.assertEquals("EE", person.getResidency());

        Assert.assertNotNull(recordCreator.getContactData());
        ContactDataType contactData = recordCreator.getContactData();
        Assert.assertEquals(false, contactData.getAdit());
        Assert.assertEquals("+3726630230", contactData.getPhone());
        Assert.assertEquals("help@ria.ee", contactData.getEmail());
        Assert.assertEquals("www.ria.ee", contactData.getWebPage());
        Assert.assertEquals("skype: kadi.krull", contactData.getMessagingAddress());

        Assert.assertNotNull(contactData.getPostalAddress());
        PostalAddressType postalAddress = contactData.getPostalAddress();
        Assert.assertEquals("Eesti", postalAddress.getCountry());
        Assert.assertEquals("Harju maakond", postalAddress.getCounty());
        Assert.assertEquals("Tallinna linn", postalAddress.getLocalGovernment());
        Assert.assertEquals("Kesklinna linnaosa", postalAddress.getAdministrativeUnit());
        Assert.assertEquals("", postalAddress.getSmallPlace());
        Assert.assertEquals("", postalAddress.getLandUnit());
        Assert.assertEquals("Rävala puiestee", postalAddress.getStreet());
        Assert.assertEquals("5", postalAddress.getHouseNumber());
        Assert.assertEquals("512", postalAddress.getBuildingPartNumber());
        Assert.assertEquals("15169", postalAddress.getPostalCode());

        Assert.assertNotNull(recordCreator.getOrganisation());
        OrganisationType organisation = recordCreator.getOrganisation();
        Assert.assertEquals("Riigi Infosüsteemi Amet", organisation.getName());
        Assert.assertEquals("EE70006317", organisation.getOrganisationCode());
        Assert.assertEquals("Arendusosakond", organisation.getStructuralUnit());
        Assert.assertEquals("DVK valdkonnajuht", organisation.getPositionTitle());
        Assert.assertEquals("EE", organisation.getResidency());
    }

    @Test
    public void testParseFromStringRecordSenderToDecBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getRecordSenderToDec());
        RecordSenderToDec recordSenderToDec = containerVer2_1.getRecordSenderToDec();
        Assert.assertNotNull(recordSenderToDec.getContactData());
        Assert.assertNotNull(recordSenderToDec.getOrganisation());
        Assert.assertNotNull(recordSenderToDec.getPerson());
    }

    @Test
    public void testParseFromStringRecipientBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getRecipient());
        Recipient recipient = containerVer2_1.getRecipient().get(0);
        Assert.assertNull(recipient.getRecipientRecordGuid());
        Assert.assertNull(recipient.getRecipientRecordOriginalIdentifier());
        Assert.assertEquals("Edastame ekslikult adresseeritud dokumendi.", recipient.getMessageForRecipient());
        Assert.assertNotNull(recipient.getContactData());
        Assert.assertNotNull(recipient.getPerson());
        Assert.assertNotNull(recipient.getOrganisation());
    }

    @Test
    public void testParseFromStringRecordMetadataBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getRecordMetadata());
        RecordMetadata recordMetadata = containerVer2_1.getRecordMetadata();
        Assert.assertEquals("Kiri", recordMetadata.getRecordType());
        Assert.assertEquals("1.3P-41", recordMetadata.getRecordOriginalIdentifier());
        Assert.assertEquals("Thu Nov 15 10:51:54 EET 2012", recordMetadata.getRecordDateRegistered().toString());
        Assert.assertEquals("Kodaniku ettepanek", recordMetadata.getRecordTitle());
        Assert.assertEquals("EE", recordMetadata.getRecordLanguage());
        Assert.assertEquals("Kodaniku ettepanek seoses ....", recordMetadata.getRecordAbstract());
        Assert.assertEquals("Fri Nov 23 00:00:00 EET 2012", recordMetadata.getReplyDueDate().toString());
    }

    @Test
    public void testParseFromStringAccessBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getAccess());
        Access access = containerVer2_1.getAccess();
        Assert.assertEquals("AK", access.getAccessConditionsCode());
        Assert.assertNotNull(access.getAccessRestriction().get(0));
        AccessRestriction accessRestriction = access.getAccessRestriction().get(0);
        Assert.assertEquals("AS01", accessRestriction.getRestrictionIdentifier());
        Assert.assertEquals("Thu Nov 15 00:00:00 EET 2012", accessRestriction.getRestrictionBeginDate().toString());
        Assert.assertEquals("Wed Nov 15 00:00:00 EET 2017", accessRestriction.getRestrictionEndDate().toString());
        Assert.assertEquals("Dokumendi vastuvõtmine või allkirjastamine", accessRestriction.getRestrictionEndEvent());
        Assert.assertEquals("Mon Nov 19 00:00:00 EET 2012", accessRestriction.getRestrictionInvalidSince().toString());
        Assert.assertEquals("Avaliku teabe seadus, § 35 (10)", accessRestriction.getRestrictionBasis());
        Assert.assertEquals("Riigi Infosüsteemi Amet", accessRestriction.getInformationOwner());
    }

    @Test
    public void testParseFromStringSignatureMetadata() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getSignatureMetadata().get(0));
        SignatureMetadata signatureMetadata = containerVer2_1.getSignatureMetadata().get(0);
        Assert.assertEquals("Digitaalallkiri", signatureMetadata.getSignatureType());
        Assert.assertEquals("Jaan Priisalu", signatureMetadata.getSigner());
        Assert.assertEquals("allkiri on kehtiv", signatureMetadata.getVerified());
        Assert.assertEquals("Thu Nov 15 10:51:51 EET 2012", signatureMetadata.getSignatureVerificationDate().toString());
    }

    @Test
    public void testParseFromStringFileBlock() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide2.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1.getFile().get(0));
        File file = containerVer2_1.getFile().get(0);
        Assert.assertEquals("25892e17-80f6-415f-9c65-7395632f0223", file.getFileGuid());
        Assert.assertEquals(true, file.getRecordMainComponent());
        Assert.assertEquals("Ettepaneku edastus.ddoc", file.getFileName());
        Assert.assertEquals(new Integer(355690), file.getFileSize());
        Assert.assertEquals("application/x-ddoc", file.getMimeType());
        String expectedZipBase64Content = "H4sIAAAAAAAAA+28V7OrSJcg+s6vqKh+VNSHB9FRVXPxQgIkvOBlAu+N8OLXX7T3MfuYqq7uvnNj" +
                "ImZ0jhBkJivXyuUXyf79f6x19csc90PeNn/8Cv8L+vWXuAnbKG/SP361TOG346//40/gdyNPmzji" +
                "2vCXpO1rf/zjV04SJe7K/nZX5F8/AkB//WUH2Qx//JqNY/fvILgsy7+G8l9xDHJ5mu8gwHkf9S/o" +
                "337d4XL+6At5Ff/Cts0YN6P57OI/fuUVhuc4nvufDG3wBPbrL68hjV+/usYx7vwmLv8VteGvv0jR" +
                "jsmOs5LX8fu9ftdVeeiPOzpgG47x+Nsw9rFf//qLkW97/5Egsf8EihY/cAyj0TSd0vStGjP+HK+F" +
                "pJyXvYkN9wMtvQ6BU43eXcdD0c7CEzP4jppFYjUDQU4hQa1NASJs/l2ZApSpglqfXdQePQeH5Eav" +
                "4pOuGYvCCy+Y+/fgILyWl1VZFDpA7zNBmvKOAc28ZsnkJhsDbgFjER6kk1eFjdoFCEZJBT8prJTu" +
                "gIsA0bugDilAqmxLzyFMKo4Htlhnr/Y6F7EIT6SKyIGroNHGwLEh12CwwFmncOs+j6Gkxn4CQdHN" +
                "7l3t9o7J3W/YfyF3H7TTOn0AQrywCRqFCBCv3umvrp+wAT53xOK6ozRQUp1B0Ykm5CeFRmg4Rdtr" +
                "Xc6NvPH41SznT+Ny6bSTKeIbcK314mac2+ikL9f8OIcn+xmw+BzW4eyJyuw5a7WTMEUnZVYMbJWf" +
                "UvoFm500wDWhPLqfp2tNZSFSbdcaz/aO7droxd627AtWBogKvwHhus/r8LbYLzKAFx1f6aPmj9i8" +
                "s5SqvboqPOMdK6WgF5WlPi9kDnym5VpHT0/Uh48Aon0V5Cbc5Jp6es/jU+HoTUZepAk7V2DEd2wU" +
                "kHaavqxs8x3Pc+lwEz9hYL6jfSvWd/Rr9ek5AgT4DjXJjr6LpXXY0VuVJ7SjuH8FbVWLFlK3dlVy" +
                "DLpyy/wmD2ZXhLX9JsZBDpeAe9erHWq58758P5cWxVRGhdP2r24ppkuoXEioJj+phXuUkdfivk94" +
                "E+EKiESe8By92yFO3hMud468Qy9wTeG1/Qa4+usx2BH4hFbliRXkO3gjOyruIusukdh6Y6lP9Nql" +
                "f3+T/dFFqyIQ7e3zWrwE6avm3VVoJ6MLUb1zn++KtctD5tZrtQOeo33MzZAWKf/UV1cj4DrRX3RS" +
                "uV/bRcTCRYC+hAjKXzLzCePl833ApxvXLzc2TBbWQrN/F//jzcaXm9FdN8rPkwLf3FyrrbsvkIvq" +
                "VZh/vVn9evNueLAxQrJ9Qe0tFIUC8Ay48EXh6Toq5N2l0UUoeFffXZCsXN6w46cbm32Nqh0rKECl" +
                "gynuRrW2by9xBnZ5npUnBp+FqHuZsghVk5hLEYlfO7c5V+YnKb2jzDNAuspFtXmXDdg1Q9w1IBRQ" +
                "OAtXuBKWHWtVkHOubOHo1XatbFW2SySumvTmcTz2laXRrmD2c+fWHL7kQEa+l/VdZD/rxkcWO28C" +
                "dfhsxVk6lV5WHMj4N6v98fOysHSI2NCb5KHK9FL30e6DcOwk/oQmPcp1J1cdsQo2ATWvGQ267KJv" +
                "Yf2ABhJnLQQlQn7tldj1gOqL7LDHNNNmlW+tOenmGSLcINiOo9TICANA2VY192i9z7erRrtuWNTk" +
                "ESdPTdgl6JTUJzLEmkSixZwXDc00bE5zNQxsFbSLiNJDgMMRlytxSSF4Qc/SSKvQpi1MUeL9XTwQ" +
                "YfAI5OFZnZfDvW82FzmL1P3h9jx2h59Ri3f2voj4FDz6Dg2Rgg7brlmR/tLMxGx0PMo+njJiip3S" +
                "Tj5pE2oyT42PqAkT+wZxwPPwJgJgHIxOeUKsmBelbAoG0K586hHpzzYI1sVBiAzPKJIEtwEkTlVC" +
                "62NBiuhUC7YSkSkE3HsVcSjkHsqbdSqfKk3y840zNw2VexWnHg1EmKCGYsGJ1Ahl6g+Dk6yuccP7" +
                "1NXKAgeYGMLL7aZdl7bO6YtLnTvxbDOKDseIwGLQTZSkOLo05jUvVjvMhSrGOJE/Y3di4HaHABxS" +
                "ws7sNhJAYZrE60Nt2yeMzP5NxoakO+P5PYpmMu3kwmmMC/4Yw0vtF5hunR5eJ8gyIE+VRXDsfK23" +
                "DraOBmqdC0V59PN1zIfmmOv11RjPYx3CRoPZ7K036TXQ9fP5FPeTsXWAHJp3aOjw2xOLhCyzMgQB" +
                "H4wDzY/xJLH0wp9c625k6aEVZRLhKxJ0/ccuCBqDrgeG8IG7lVoKZegJEXt87/bYMxSbw1Wr7S0x" +
                "jwyGOorJ36L+OPGpvBJeHcQuM06PRBF2/BQKWHW0Ox+9B6HwQS4f8VygwXPE89a0zChRMk/Tcjw6" +
                "UYx4otZnCKGrOh5Opi2RCcRuyQboT9c8Vx1/sbFoOhvx5mWqngYF7XSTRdrHlZLpwhE6ppUEhQ/1" +
                "Jcfj6npSBsw/sAJcAxo36nkm401WIm28Tu6qrXWoUI8h4RkNzu50Ygf98SHbcCDcTneufJg1cWj8" +
                "nG4ifo0BTgkp5tmJvH7NN0eiaMbWiEvz7B9UNEWX+sqWFlf2gVY8YMNmLaXn2cCNIWiueGJQUODU" +
                "ummwu+eHyQb9hR1AJhGwMVOb+x2mn0XnH8lSOouMEWWnRdAdph+k+ry6uBjwBhljAH5ZjBkyVsds" +
                "HmY0mSQEHlqbGePWKmre6eIkS6rZqnzDsbnKUMmIV8KEpwdurquTOwEayfRiVIz80/F6LEwf3Bb7" +
                "AtfzTQRrgfKUD5uE5zk5FOdS8fPrUqf8uRFW8US4nH6jAMIz3UkaBymFOHru9I2+PApOrJHIEjH/" +
                "UnnKlSmi0G2rFBN1U2qelExUDyPXieUoqQ/gBp4G/an7yykOr7R6smSXIJWHbeRGkKMqojfqhaJ7" +
                "2D/3ZznUbAhqjqBpka12NSnExYDbwEd3qIV8O1Eq+KDptQbFGQLpBNsyLH71dk9yP6lpOGmM3Y+P" +
                "XFQTGB5DpbeIojw0gJqBfEEdLdiDz7bKZUY2kHl9l5DOvmbLYKVtOnUiGqatL/BlAjNT1yXE+ASv" +
                "nFFFpg6Y9GCrcQkjXFl4lL46hcltjFbHhOo4loJyelpbd3ZGpIubTbj8oGx1OuAmfnFZYSFp4NqS" +
                "Qt52dyQRoeQmlBNOTTfy7Euc1x5RVaTE5zSR8mnU58PM6gKdLHwWGedkFHmzKzcA0efj84QdieOE" +
                "aFc0P6hXnux3jgcOimdpNyaZQHqQtGtqeOu6e97Os6RNp+jstqtO1kC13pt+c7cbkkWrj84IjxRP" +
                "EBnkJU2tPJb4wNldI40112xIUOWE9f4yp49wuCIEYksFIGB67u2+5QbF7uPK8moXGzQ3FgfzPLCW" +
                "h1jHbJjVTmGkahk9C5tF9ziwRwL3Ymy88SqQGm7GPuODEraEvpinIB2jK2tj5HUepeF5pwPBYoWj" +
                "dfNbwu2cqzeQbbI87lzPpTTTk4BXG+6lYEUcJHNbRckTFMLkepy2+5HZPfGJFfLVKOzmlVZJz93v" +
                "CoxML5q1Zzi7xeNwIHB19nv3zL4SLlGdgz1f2qOVN+/c2YFajO3CyyR68c8WMcBYans+YNWM/fA7" +
                "34+rrLXPJKW2V+dm3/xi4NFHNENZ3JM6bTrKWcT683BTj6gC4vU6B3vAHWHA8Lj7Cms3xJ1Zqqdn" +
                "uaXj3hXQOBHDjHE4VcsH71GsTS16PGafNV8THKjvk1UWq6fT94DMIvAuec9N1AzWaZ/5ptqWWi9D" +
                "4RIseXoIzg2duZBK1XEw0BiRqaowyaKd7mBJi8QG5JZn33dJu1angBI2+BwfFYasno92YJ2776wu" +
                "th3ukxM8llFJ8/6RdRaGnQx/y0OTdRfAEW/s9Xq5WPOVlrLMMBtoobGYk5znkla9pW6HW+CHpQEK" +
                "SuRQXclb86N+IASFRYMNo4AhKahxS6ZCow9yfHApFpxr2cDpsVJ1CJ2wUPIWHBQwkr+P1zR4Iuqt" +
                "Uy6+ECCo498CILnYlqlaJpHyKuGSEzmS3KGfhP5BspcjNMAGhM1pf8qv13ZiLnf9dMWkuyZp+2ym" +
                "cyuA+CkoDMLzPqrwIiV3hynJQ7dE7Qtd1DJ0ZcrFzw+6Lu7rtyfSJgdzplaXQRY25AnPJ8B5XF3k" +
                "6F7QAp3QsaNh/KHlMHvfspyA7jHHkL5i19RtG249aLIMrWtBBZ9ik2/4U+9xQLTc9yTxyIfRUdKY" +
                "tKnr4Wo72khNtfdQnKnZ5oSX+hJfyVuWKoFC+ndVSCnNOXJg2S1ARmGZNQ2P0+W+4SPRe8eAns4s" +
                "eVjAkhVU+nL16tsDvfVkHsLq8UDCNaGdLuqBY1SUP9mARpvF4egbyzQfq2jajIA0L01l0EMpJyOR" +
                "aV1988iMUCz4ej8NR0e4ddlJLx4aeCjanAWceLn2OWrIgolXkXa46jlYCuyGZqhvK3sWAEnJeB0s" +
                "yun3IFqw0N3JuT6iPGv0yaJIBfSyUntkGqtBSY1Py3yCZ6OGTK7f4xV4TUO4Erq7E3lZeVqg9RF6" +
                "0B05htcb2iw+Wht7nJg30bLt6X9f75blzprKST89CmNqQ5WJ1oiNCSk8KPEmWzS6pXMRWRNt2NRU" +
                "hLizOQEwD4h8AKP6jIN7xGi0mhw9dAs6P1uV08mMzHNGhfrmSOGhHj/o+wr1TufSje1KUQ+SOLC7" +
                "CplZiuPBjEB+2S0O5+4H5idFF83j2MV71VzEV82Feau5WIB/ske3xrNd7zYZ1dvIgfOgFrqAxZeg" +
                "js8Wj584rfXZ13gaPhu8brzOxlflSKMl4K14c3qFQC87JqeGpTP2KQ/JyB9NTaVFicskhLc0hq5T" +
                "unlcU8f2tDRkarNHLrQI1BJz1RjWuofdbZCfueSKGn6szxN8TeLTFQdjGLke6OBAHin6dPBveUG0" +
                "15xr08PldQ58vPjxHLwUDXREz89xnWAIZdBrQeC1S4oueF1dkOFJgLoJRIh62GAS1JyBhRftNq1W" +
                "iMQrxruOz6cpPN22Yzojj4Y63Mrk8rwLxKyCyWk7UuoTOCT6Oq5EoCTmih42bT0Kx+GeJQ04n3Fx" +
                "RqPYT47moSKkHSWs3dF7pB/Pgb/q+KfnwH/n5tc58N+5+f+S8H8SCbcnM7fZhXi6ex4/vYUwfCWY" +
                "pTFpNcsC31ck/qogETjC5DteFaLaFNZ6vXk3NWiVBeAlc75JdrWNGS0vlhDmxWVyHsnCOaJDW/Ox" +
                "aw20J64l7Ondpd9V0iz60t1QjIDqA5wBJyWXh0fB2JxeXIz7xRBzmDAGYnoSeBcNBDLmyGU9+KdE" +
                "2OlxkkvfoUHe4nfcF2QzVIBAOWxtnmH1rBxNcsmXyMJCK1XW3riydBkX1rmjYv0oFs0VS6vahgWI" +
                "IFgtTsL05s4RcH3U6ZB22VhdqIx009IV6EKrlGerQ+n6JMxyFhQ82CyzYdoYzVeEpSDsmt9Ebrlg" +
                "5A1AVELiLkF1n1hquOJhSlHHyskIslaJKLoJx+hYVCIbKhN+I/qBjBOwAXPyBq5Nvsd/CKCLK709" +
                "1ObQcc14kxLbiue3CFU2UV+VhN100+nyMUJ9Vfs5/HOACnzk1+ll2fk9Qq29zkPfqlVdgOCbklPd" +
                "zsbGuyuzVlfQfr6ET+rN+QDfeJ/0Owlg2teB24HUvhPBr2Lcq4gbbtIcitQS3ZkR8BwcluGfo/fx" +
                "I6Y/xw7Y0YMChBpCUZg8Z5l/fOLxg2T6r4OGUJNXVw3wpULb7Fkq+lZThUPknIU59aOD/YHE5bWI" +
                "f0Hj6Tx76HmXfTV379JfYvaRC+5H1L7FTJ8DZP0poJ+VA/8aEPJ62mF/Awj4GzVu/hqQULiIPXh7" +
                "GxCJ1N6gwmFz/pLe0MsrQgk/QfwK+GfrAHw369+g7w0BIrwqv/NHIwT8BfqX1yFEdfxVR3977qTC" +
                "vuWCgZqdDzNMZQ85I1vk7gHEYfM338UEDoG0s8Ih48bddAfShfpoXc60NbrEDBJix2b6MOn2QI5U" +
                "yLiSq+CLNxcqwImRRMzQzdz2JZByrWLimxboIaONxso9szXh14MCNgkhnjApvCXofINwU/TO4DIp" +
                "3RloPcbyoKCkd+aE9eFcQHyVF+ipHDoqve+C/uzjIy5ZwSjHOIUF9j3g2fNAoiZHDquNA1ajND5F" +
                "xvfT0+2pcjmQipnGE15u1uxeu5sJNuHTOhitZxT1NazsRk9X/VqsXnKShOsDQKUou0eJHPe3Essy" +
                "caKgSVVNB5OL6vKcGU4IjQzT9N56ipApXU4OdRXOeN8cAtg0Hg8A5Dk+EPNlyaK48pOClNI9qYvT" +
                "3FQGb4hFNybICL8p0eFYH+OkdkTLvDWldFtkHbwlKwA/MUfn8Ht1CEZNt2RnwONuuiM4ers68A1m" +
                "zlO6jhvsN9YdGY9xhCL2rHsWH4vrCice4B63XGjEuMB4MRF46STlYXROieDB329GhYtLZ4QPwdco" +
                "GRdXIx2QPSGBFbzekznz7gyAjvNlS6zplvu8Lam0/owuxEQRhyMFg6c4c52Oc4aHKo639RBEGoRz" +
                "MZaz5xpGHYRq7sCixWjhh+E409a6aNVZDJ4LOgXJhC7LTDoSB4knVFhXdrkIHdMUudOQ16XV7hkF" +
                "1uEFsNjjobz3q3ikVsWQmxNZlMd5YJoVUoQC1evsGBkWz2d+ahTB89oS2iPrF9K1eNVXDi5AlVTq" +
                "PhVxSoQODi611eN85N6i8yW7V96hkvZEeFRVN1Qqc0zSGewazfCOykEMMPzqIABokRtKTKsilmeZ" +
                "smLzYTMKQgQiElU7QeHgB1XoSUGJYWy11ip9TAKQ96uU15y8PNPAq5ZzTtI7XTqX0M8v6IYMlHBY" +
                "IA5lbg9HGT0NOydJp1Z5mQgH7qLoshdcUIwvwOARSADHxke9Zscz3VI3ze9xI7jqWNPQtsAU1k3j" +
                "M7o01pXTMOkpT9l9NzDbFuwpttIdoXa6ADJcZRwO9ZR7hnXR5ZRWhWFBr56yh12cwMhxzGCRbSEf" +
                "wmic2wSzurXXVDbf2e7AgQI804VkQl9Jn7SL5NHC78auPaR+V6NyrMlmbXEPiB4eTq7zwkJG7DzJ" +
                "oeUSInLqs77IgC7SdRWBkSdBjnOVqWetoS0xn8XJVofdiPC60nkVZ/QI040sYYvOdclhE2P5G88N" +
                "xhG4dAYd3opuD1xwnRczvTpIF2nr7AeLGjlkakHDTw0xVOP0XMP4HFHGXPsKFGdbtkKHO8A3zrwO" +
                "uTmgbjr4dh2x+XZO0OclTundSjTNRR9vOhNyhkXL5nQXjXrZyhMfniXaGVwHKHFWwXsNTpCAfz2G" +
                "fxzbC0yX6gPTYRrsbxmhyWdP1wxlZS+Y6M8tQiTX8hRoVRoNzRPgvFM1OUheylRFirUtt5mozuSd" +
                "g5BikJClNPpj3O8Ltnqrc3QXNDXPioFot87BWmFMAOXs2BvtDjKUKgiSEfEaFsmwucfDgWFx6HQd" +
                "svSJ+ZIb5Na1PSePLD3f04O1HNNUIo8aYOWyUED70rVspxwwfA1IthuuNMjXiyHJ5yLk8QLhu8Vc" +
                "pSYnbHm6U+aJy/GELa9M1gIkRGoTWwtbdU0wU1FAWYjB+yl93hulv8bIwCy7KzzSQyXfYXKCHz4Y" +
                "HSS+7zQqsk6PAogs5SmeJ8LBcyKHa3UDL/gcmsHl3CNxQFPoyTqH+CmrQLTVL48bO5em489NBJ6e" +
                "5vmpAK52IINjsyDJbZeQGFxvSUKqQS93CIUKh2w4bfL1QfAXVcm9o65ux6QXTeKK52CvI08fIIQE" +
                "4i8rh3EHL7ZhwnScePImSEXiusP10TNpC1prLCfvdsR5V0G0yK6O6HA5j1d99QGvmGltPGv6079d" +
                "kSwmE83aJUdcneUGLhf1oCr9oQv92E6oA7SvymRZitzhXfzUcfrSAAk8XhSRKXFedxeEGOFFTXV7" +
                "sh7Z1hlQqKw+K+h+hCioI+UQmJddd2VcGsmeZr5VJgbQorkcyZNmI1ThpuFQOMtW83KwOJPRKjcv" +
                "KGRNXoz42HteNHdwMyJg+KxalOfUYwytgMYRlWHhojXaKnGn47upax3IhnliEl3HXqvH3KJGYezW" +
                "6TSy1+M1ugQipBKvh1ARP7gAJm4ium71tE5cHEyH+sji7fKkx1ZDdbQjXahI0I1SJBXWmTILlm4o" +
                "wJioSwGbbXxegXDKzLhMyVdHcqcK43JM1mFvXMt0V5i5mE2uMETqFB3q2x424Qc4GcpmDtKtPlCQ" +
                "BWwZXNHyPpJrDCh+1K2KDTaaFFTENtSFQbJzRKNGgh+YKOS1soGMS7VCD9c4ZIIBcSpwMJvqfm0S" +
                "lyCkOrsH69EyveyunxGNJFjvwi3yVkyn2xBGDzBiMzyoZhXUCRwepbw2L/sidlPLXGc+LgdRULbY" +
                "qNIGMVU1Xid4Q4PicjL3pdQgGR992ZCypIqNLQLRekLKyKUAd5r60GPO7kGTyKIvWJUUPZCZQPxK" +
                "K+2B5f2AQb1LBnOm3mzxiEU5kndtqkqGAonXGjiiCDqfqdD1FZYWDIld2n5xkX6yadY6WILqFg+G" +
                "rHGzmzAjm2dnfnBtISzEWA1H1esBbD1Vh0sV1SQ+kQGe+kxaXjwIy4/Qxey1W6PLqC+FV+ZML+C5" +
                "bZzSKm5cYQeIWsgCdABuqW8oVB/fr6cywW1LzbuhV7OVtppxlu9UDIatZx5R51yBaXLEbrGHjtRD" +
                "cW8o5KIEvwMw490FpXIpzRopZbiQI0rVjZvPOtHtDq994rGvPQpLkC+geHNM8Hh6qwDuPGDBO0Bo" +
                "r41bS/+hBCjtMfBfZCivtIpRdVtnZKu66jn12gWCd15tbxGLY4HzHCtFmHZJVrKJovK26AU1I+qK" +
                "M095P7JBe3IV/VyGDO9e+pq04hxQQwSxq0eN9uwKHkFX6OYIiZqc2RlYrDaJhYeBVo2DOmYOeUMX" +
                "uyee6N2HQ61TafxUArjNlTfpaToBb1mn1jY9oz3x+tmZ2+twc4mrxRro4VYZ58fgaEI/VpBtw3gh" +
                "nzX8Bpp3wKdj2DLu8MnWlciDYKc6XYU8Hg52yjb4KyRvpsEnp3NVBVH7uAq6qsiXLqOl4jiP4wPg" +
                "ymLFEl/fHZJ0bIt8wRxYXx/+WG33q+qwhMxS8n3BznPMPMe0JU5yqYHa87mLZesQMUD2CfU8RhvM" +
                "y2Kw57Pr0Ycu7jZMjHfxSVYz9QNv5qdjjwwgtYX1SdAxpdpu6f3QEwFPAnqPCH6oINgYJsMN4t8y" +
                "98uNZHQpe2Xut1R7z9w1yaJ/socP+H4T348fZvRfW0hO1eLZPwJ65Y3d2ZOwt/15Ks/9FBAP0d/s" +
                "2/uA0Ye88ewOVgt7yy5trFLQn8o/3wLS+B3QtgN62/wUPnEMCJx1F2Ge3UX4y/OzV/oP3ko0WZUX" +
                "Rsjr8Pb47JsPV7E7JYC754iRaE/vovwR2NdawpkpFZkpX3DeS+MfwHxOPPdIkqZtMYMD5zy5TjWE" +
                "Twr6WjZfplDEm51DDJ1p9EeFA7T+u2IL/QOudMrsBxHOgrqqvbsKyc259Kr3hQTov69WJD9Ak4/6" +
                "x5oD8LHosPM785A91YXOXbTPGJ6U+QPaP61kvK/BW7Xm2w/I8H9VEloClIFD8VVLsGbgP5rhryZQ" +
                "GeltAuAnM3xf1fmvkRB8muEnE2yRKEDR/b048w9J+JG13d+QsIQ11YS7of1aT/pROr8lgf5WPN8/" +
                "XMyn/3FZ6B+S8H3Dy8Yof0nCax8a7NbC861I90nvfygXpV9JaH4Az7fmX5XIXEctXptfP+3TmwF3" +
                "n31fsL9V5+/h/0Sd2Yxf/lH96Cfq/PAUmUq6F6s5dtiB/ShU8Lov2EmF4hfqz28xBT6asRYcBD7n" +
                "X9p/eB0E7QfWYuI+kWnZlmbAZ7N0dy58qJm/6mg7msInrun0rpHhy9IIS/QO4I8/gN/Bz/vQP211" +
                "98epj982lxvQzzaLL+i/2j4FEQiCQIgC9wHRkKdvO9rfd8pLTdL+5+5j/aZt8tCv8u1t87oSj1kb" +
                "/UJXadvnY1b/DI6pv0DBoM6zv+2wfgthrPnt1QKhMP4CCv4c6kcq/8k83+PbD/5vQ+bDb1N8B2lv" +
                "0uMk7uMmjH+xdOmPX/+Ng962+udpPIz/lem+TPURxBeItl9N8Z9JdSk7SzUabgd7vp4vvnYJlMnJ" +
                "NvqPzze+j9zhfEHwG2Tf3x/4hM7U5/+KxyF/QwiCKQh9vROw//u3dwbf+raL+3EPmH79RKUB/fZD" +
                "1/9ysl21xdRtYA/9gT6fS5rnmd7mlsQkhz+Av6Ub/Cqof36VhrehnwT/N0MSf/3TxJsLW92ZDMIy" +
                "+J6AG9Zro/pMGrUTjep+vN/kmhPBNipv6nxPt7aFh0ucX8gnE1qufAPUg55yfYtcFXF9broiRaWK" +
                "VMyMt3LeyifS9Dj7Blljldj7GJJb+kpgeeQ2paBT8j0BCLzgsH6vszNZVasotF7j3V3Qt7pZU5K8" +
                "HNFZ95QnsSYvVn9Lyk7oJX6+Efl29rlRN+gPV0obTdU0/FnlikZDDArHfpHy+J4J9ZlDI1OolNpy" +
                "GxjbJYXBL+GSZ1j1iE4tIUtty7APkmXudEUBhkBJg3KZ77JDkg+vAMuwcM4gDwc7nu0Y+MrA49lE" +
                "5EzSPwPhbsv6ah/RQiEbc8r1FphWn7xG6TSO8oxg3hGL2qZfOD6/Rku1Ek555ZWNKKlYg3ZaP+MN" +
                "/M6vXdvEzfgn7Ban38Evly+mf0Mq+OH8jkPUy/D9+XbGvmQ2eb06s/cpksTTJsvSU53Si8TsJpk3" +
                "nACetz3kSMtHVuYitUAMrVkCzTGBog0Lq7mcrWkiv5wFQDf5fE8wRRq2eDZTPM1WUguxn7sbqf27" +
                "vnmO/dxDrS5Exmr/wuHG3xQaeh+/KiKg26qlWxWv6OEivEPm+AUXLFgXDEsbLWhI316y2OhYWKDl" +
                "atJ7uFs+X20Kx/jA3riq3KvR/dKoSCLxPao7pl9nzhTx88SAoreLSL8NlPlVKHffu0eEwiCd1M5D" +
                "8Cw62U/P5CmFG95uplcMejkoTWPUV9AP6K+TXaJ0jR7o3Z/uHTYtSLTxuuYU+krTGL0H1WpKrzRX" +
                "viL+5+tX5XhPYUIReEFlGEz7CPULUJO/KvTyNvMlUwSTF2yrLFeBow0mVW2GtkyA3RTsytGIYpaL" +
                "UpTQTn/6opU1HqIhBSin8S8W7niI191ZM3l6YVKNdaQdH+2U2AD+uNJmlV8fk+ByPr48dY4+LIJd" +
                "DM76MB1N4yV0i4miHfI85S/9IAkhe4elO5Qvy4MKgTGYp66+HfSn6jZH0x4PFyOHx/a5mLVIPiTh" +
                "MJ8HO7LGk3DfYmWboitxFnNS6AccYQkEgCYwyJotQ/J4phVDwlH2fup8DdO228OEcU7bJVXdMSau" +
                "DLmxDMnR1xf9J+3I0MmRBxhaYZmSXm4vVupQwnDWomz02rKHVHbd3j/pUMi1s4xGaPTEN/+JV55B" +
                "FWG9bvKeCAB7dtR5LLWHE3rlO9rr7RxUrtVnwDH620wGzRsFIym8K7LPXRZ2Vm3ZPvu+uAoXLgCf" +
                "utJlcRlGs067Ii1M1vJBvYdWJp0xadozKS8wWsjSumv/DBvgDZ3Xq03M8cXvSFo0V2F8WuBTEe0J" +
                "JYNjOz1lxaFbistzSq9ZBivMm0hHXKo5AMOYKTHFo4aUF3MsQwFOwW5B20Qk2Gqjz29k6ApPF6+8" +
                "81v52LHeo0JstwEac5DX4bwm7dUe2aSWtEAxymgyON6HesUpBgiLN426ZmPIOwwHHhB9NSvtNlrA" +
                "6bG00eCwbtOr1j0NHNQfJiU4XB/YrdwkDjGcLTQeQnNQdpIpJhDxuSN4vCtdT7w2OlAjCrcSq3zm" +
                "GdnIET/vPOxxLzluzhuDJ4+4roXNenLvqZPISokX2OV8gCOuhIaAxJYCCCyvIAa1K4VaiE5EnfF8" +
                "7C+8aKZH0yHdJoInEOpyOCRusBnaHLydeB0U+LtcZGg1QYAu6MVZxbgnIYsz099QMOaTkMQ7w6XX" +
                "Uy+YkwVGFR5axOE4C86NU+Pd5M2FCUfnBdxD6/JZ6/e27PUGWYptDhtsRa9xdHLddfkd/N4Gv7e8" +
                "22fwqxO7BkUcjn/+rk17UJc88yb9Gm98F3H+dQzz6y+m36fx+Ba2fI1a/0uQPgcLP4l93tu+eOSv" +
                "nZ/6duTNvI7/RCAY/Q3C9v8mjP47dvx35Oi9e/LPI76M/8ZL/f66+vTzHur8Lw+4irPx6Ky8x+3H" +
                "UPqVXGDFQBptdBqGH+PMb/CShmGKeyPuc7/65Hzfm1S/jv8zuQL7B8+D1z9o4xfjfTHGId6h1vlQ" +
                "xkM5DeDV+oM3TF7iQFb9dPabcfllh0S+C9XXeT8h8o6VOtVB3P9nUIERFMaOGIrD74A/wnktwDc0" +
                "v6/Hn18Y+y0rv0pJW+XhU4r28GXvfYPzfV/dVXkcfZN8/Ic9P4fX7xFU+EqMbpX/Fhaz+fh8Yfr6" +
                "2QeOO3LXfh+2W5nwpZPftwC/39ph9Cu2jV7dHy52WO3UjP3zbZ13kB+uvsHvBxze1KbX27d0lK38" +
                "XQGi19Xw7eUL5ocr4JvL4UuI/xkQ+B9pYxy9jM27ffmmE/wnvR/afrea4fs24EvjzxDYl2rnXDzG" +
                "H2RiT1ZeHXvD17M/P6r6f1fTwe9Ue42aZiKEqavkC22aclKfhDiEiwJy/3dS7Str3H5U7F9ezb/o" +
                "vHG77uGjvrfBEBjXfl7RUdTHu3Xqyvz/eXvJ/f9zG4BTBAljGPUPbADwxQh8ZSz418z/1KHHc/v+" +
                "Sv9b++4Ed2K/Pf109lXNP2Xl6u7e9hx/2POhKO4l7v+vJf445W4j3nQ8jujxR1+HQbuv+zBgX6Jv" +
                "KfkipruI0030WQT/u37ub92cx6z0QD08xLk3U9dejFOLjo3c3rzwR134Ebt3Et7ZAn5gFviXHP3A" +
                "+zcQb0ltE/rdMFV7W/RddPQ56vjCjf/J8rr565+vvLUs9rwVfXzNW1frVpv/++at/J5R8KtSaPDX" +
                "vLWgMaVwV2WTtk956+kneetXTNPlC6bA36CqKvR7rsouC29CqmlxfK+w5Xv+uiz5C3vghb5sq7LE" +
                "SXvWHKZvA1nG2Ds1E8J53ZbStz8gwPF7GuJ+zBbOew5zBkJx7LST2su1Xe0cYaTi+9V/PXK9srR2" +
                "pF/9bHrZz3kaO3ZPBdQSIM4t+BJMGB2FtHW5M/kSuAFTYSlbjd6JxROPJJNLgdSP5HZHwLsD848t" +
                "sGcRurlS6XdAqW1Mj+qwQVj+msGczCJseGT05lFn95aH0PbIN6RKrZ1KRaLIMacO8fmKCW3ba+hZ" +
                "ALAiDW4cqwp03KLh3BXSCh8byNJz++oJfLRys3C8CS0Yr5f7WOjKoSjRC3GgovbkzsYdaKiyEgLz" +
                "6KTxkdSiqkJTbfN4VD5qyl2ANmwNmBNcPc3alkf86UHJuuNVqJUnzHt+gAA811gYe0mk6LgQXhHh" +
                "ZbS2dbhwmzhN8hbl56q6jRBuGefQxYRTQ7m0fXHqNnFdsCVW4Gpt1jGhN+JJw6MmcbRGM+2ex8nb" +
                "rh/GsPDLW0JcMTvj2Y8p6lIu/i5owN6ZMqK0D2NiZrcve57K0yGWMDTPKgK9nLVv81pRb+8v8d4F" +
                "cPQM5pU5C2P49nccmCVA1s5Fy+W8fLyJd0Tk278FEiLD5DnW7Drda1esvQOwhx1lJtfe0N0TbZFR" +
                "Toe/TX5bRyzvGxMBip4uQuqeL60nZXOo0lrJCGm1+EhFf5ppZT8lwAztmnRpC8rrzzq8130uAL9W" +
                "jPVkTO9+hnzH66LTzqH7uQucavMRe/NRe1N0euHSz6oeXaK7/XzpT5rqAlATtPoxF98Jx+iMXqba" +
                "I/i7fpUqfNfd+27huqvA/WilgHdF4ekzKM83K55VPWS6w5k8Jp7eJlkJ5slFlVfWarOjiSrFaFET" +
                "rkOXttCrZ3yAAdU6Ko8TuPWXrCfM2zrdOSjUe0GjTk8CkiRS2jY/TnvNVtMHaaWapM7spK6Ot+sx" +
                "76NA4FMKOTKdFgvro0PZjnmOYmxP94bAs8eVuUQduLm7NbKs0lVpE6cJw7i5Mn1NaZ2VQOAZMesh" +
                "XKAKShZ3XkhEuHg+olQjztV3JgzZsdewChwCCl8TWmXVGG/wgZmZbBfswyABjmfZ52Ni2hmZi759" +
                "M/ynlsQ0HedQDWJgOeR3ZklW4pFtTwZ9PsLGKLEj1TJ9z8bp5APgeEDlfEtOnerNXJddlNtEe9iU" +
                "xXKi0X/sPu1vnM3nqOV7//TViX1qegtBPp9/BPil/c1vvWKSV4WVtZaWoS+7NpbLkqZnaef952LQ" +
                "srOcT1MJf41TX5VYHclSt11SN3yTWOCvRJZj/oHEatACsMt7bZOj9ZsGq5qy24TLJ4/FsecfPdaT" +
                "eRsnCa8+5gaYpS5YOf1yX8s/UDSX297+XsyicjS0/0LAldMWp2AsRZCWm/nSQqvnUoUVU4tmGF1g" +
                "L1qo2sslLLMEGylyD1al9WFrUqpZBh3EwNw+Tzbu0LF4IxpW6S8ETYin3VfxVU0Fh9fD2tubp9r2" +
                "GTlt/9UwdfenrREuZ5MugG9XXOKFHXII9/mzFuc0rVrmckXIpAr1zH6CeLtw2kcSeQFgNJpLU56h" +
                "FaqaZRBrOTJ9sFYyZ1Hrnq7HmHo+Sgp51sygklKg43gQIznTYLG+ZuppAxoegobnE7zuKbGacbmH" +
                "KalhBgnzPNuJN99WiaUS3sk0Jq6Qw2xJ0tHuwZm6ndgHeaIfQBdR9OnELsdDi9uLBzbI5eldd6E5" +
                "xSEIOnLYe4q4H7ry6moReKomtr8+xX43WnnXVy1QPipfiHOUbQfT2u4PT6rLRaqPY5kSqnulbdaG" +
                "nsWJqpOWmbm5BJVBEvW0JiINnIJzC3RsZJm3Y3Ap3C5Xhatr8R7vwmsWFlg6xmVMsNMVSnTesvlQ" +
                "0wMq0NkL3TdyNlANSZUAp3VVXcPXJr5MU6h5UJiEj6GrW6dizg/l9STrp9r0Obr8rHLgjxoJ/l3a" +
                "CXzt/piMgj+rrb1i2vfS28fk/UN23IZ//r+NAm9NTk0AAA==";
        Assert.assertEquals(expectedZipBase64Content.length(), file.getZipBase64Content().length());
        Assert.assertEquals(expectedZipBase64Content, file.getZipBase64Content());
    }

    @Test
    public void parse_2_1_container_for_issue_DVK_36() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/pp.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1);
    }

    @Test
    public void parse_2_1_standard_date_format() throws Exception {
        InputStream inputStream = ContainerVer2_1Test.class.getResourceAsStream("../testcontainers/v2_1/2_1_n2ide1_new_date_format.xml");
        ContainerVer2_1 containerVer2_1 = ContainerVer2_1.parse(TestingFileUtils.getInputStreamContents(inputStream));
        Assert.assertNotNull(containerVer2_1);
        Assert.assertNotNull(containerVer2_1.getRecordMetadata().getReplyDueDate());
        Assert.assertNotNull(containerVer2_1.getAccess().getAccessRestriction().get(0).getRestrictionBeginDate());
        Assert.assertNotNull(containerVer2_1.getAccess().getAccessRestriction().get(0).getRestrictionEndDate());
        Assert.assertNotNull(containerVer2_1.getAccess().getAccessRestriction().get(0).getRestrictionInvalidSince());
    }
}
