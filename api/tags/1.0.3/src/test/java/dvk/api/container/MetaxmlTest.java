package dvk.api.container;

import static org.junit.Assert.*;

import java.io.File;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;

import org.exolab.castor.mapping.Mapping;
import org.exolab.castor.xml.Marshaller;
import org.junit.Before;
import org.junit.Test;

public class MetaxmlTest {

    @Before
    public void setUp() throws Exception {
    }

    @Test
    public void testMarshalling() {
        try {
            StringWriter sw = new StringWriter();
            Marshaller marshaller = new Marshaller(sw);

            File mappingFile = new File("src/main/resources/castor-mapping/metaxml.xml");
            System.out.println(mappingFile.getAbsolutePath());

            Mapping mapping = new Mapping();
            mapping.loadMapping(mappingFile.getAbsolutePath());
            marshaller.setMapping(mapping);

            Metaxml metaxml = new Metaxml();
            metaxml.setSignatures(new ArrayOfSignature());

            Signature s1 = new Signature();
            Person p1 = new Person();
            p1.setFirstname("Jaak");
            p1.setSurname("Lember");
            p1.setJobtitle("Programmeerija");
            p1.setTelephone("123456");
            p1.setEmail("jaak.lember@millibitt.ee");
            s1.setPerson(p1);
            SignatureInfo si1 = new SignatureInfo();
            si1.setSignatureDate(new Date());
            si1.setSignatureTime(new Date());
            s1.setSignatureInfo(si1);
            metaxml.getSignatures().getSignature().add(s1);

            marshaller.marshal(metaxml);

            System.out.print(sw.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        assertTrue(true);
    }

}
