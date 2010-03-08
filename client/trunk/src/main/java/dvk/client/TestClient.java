package dvk.client;

import dvk.client.iostructures.GetSendStatusBody;
import dvk.client.iostructures.MarkDocumentsReceivedBody;
import dvk.client.iostructures.ReceiveDocumentsBody;
import dvk.client.iostructures.SendDocumentsBody;
import dvk.client.iostructures.SoapMessageBuilder;
import dvk.client.iostructures.XHeader;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.apache.axis.Message;
import org.apache.axis.attachments.AttachmentPart;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class TestClient {
    public static void main( String[] args )
    {
        try
        {
            // Laeme seaded
            String propertiesFile = "dhlclient.properties";
            for (int i = 0; i < args.length; ++i) {
                if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                    propertiesFile = args[i].substring(6).replaceAll("\"","");
                }
            }
            Settings.loadProperties(propertiesFile);
            
            // Loome proksiklassi objekti
            Service service;
            Call call;
            try
            {
                service = new Service();
                call = (Call) service.createCall();
                call.setTargetEndpointAddress( new URL(Settings.Client_ServiceUrl) );
                call.setUseSOAPAction( true );
                call.setSOAPActionURI( "http://producers.dhl.xtee.riik.ee/producer/dhl" );
                call.setTimeout(60*60*1000);
            }
            catch( Exception ex )
            {
                CommonMethods.logError( ex, "clnt.DhlTestClient", "main" );
                System.out.println("Viga teenuse proksi loomisel: " + ex.getMessage());
                System.out.println("Katkestan töö...");
                return;
            }
            
            // Debug information
            System.out.println("Producer: "+ Settings.Client_ProducerName);
            
            FileInputStream configStream = new FileInputStream(Settings.currentProperties.getProperty("test_config_file"));
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document conf = builder.parse( configStream );
            configStream.close();
            
            Element rootElement = conf.getDocumentElement();
            String inputFile = "";
            String outputFile = "";
            String action = "";
            String tmpFile = "";
            String attachmentName = "dhl_attachment_1";
            NodeList actionsList = rootElement.getElementsByTagName("action");
            long globalStart = (new Date()).getTime();
            long testCaseDuration = 0;
            for (int i = 0; i < actionsList.getLength(); ++i) {
                // Clean-up
                inputFile = "";
                outputFile = "";
                action = "";
                tmpFile = "";
                
                if ((i % 5) == 0) {
                    CommonMethods.writeLog("Starting step " + String.valueOf((int)Math.floor(i/5)+1), true );
                }
                CommonMethods.writeLog("Preparing request...", true);
                
                Element actionItem = (Element)actionsList.item(i);
                action = actionItem.getAttribute("method");
                
                // Read input file name from file
                NodeList inputFileNodes = actionItem.getElementsByTagName("input_file");
                if (inputFileNodes.getLength() == 1) {
                    inputFile = CommonMethods.getNodeText( inputFileNodes.item(0) );
                }
                
                // Read output file name from file
                NodeList outputFileNodes = actionItem.getElementsByTagName("output_file");
                if (inputFileNodes.getLength() == 1) {
                    outputFile = CommonMethods.getNodeText( outputFileNodes.item(0) );
                }
                
                if ((inputFile != null) && !inputFile.equalsIgnoreCase("")) {
                    tmpFile = CommonMethods.gzipPackXML(inputFile, Settings.currentProperties.getProperty("test_org_code"), "test");
                }
                
                XHeader header = new XHeader();
                header.setAmetnik(Settings.currentProperties.getProperty("test_person_id_code"));
                if (CommonMethods.personalIDCodeHasCountryCode(Settings.currentProperties.getProperty("test_person_id_code"))) {
                    header.setIsikukood(Settings.currentProperties.getProperty("test_person_id_code"));
                } else {
                    header.setIsikukood("EE" + Settings.currentProperties.getProperty("test_person_id_code"));
                }
                header.setAndmekogu(Settings.Client_ProducerName);
                header.setAsutus(Settings.currentProperties.getProperty("test_org_code"));
                header.setToimik("");
                header.setId("dhl_" + String.valueOf((new Date()).getTime()) + "_" + String.valueOf(i) );
                
                Message msg = null;
                String messageData;
                CommonMethods.writeLog("Executing request...", true);
                long operationStart = (new Date()).getTime();
                try
                {
                    if( action.equalsIgnoreCase("sendDocuments") )
                    {
                        SendDocumentsBody b = new SendDocumentsBody();
                        b.dokumendid = attachmentName;
                        b.kaust = "";
                        header.setNimi(Settings.Client_ProducerName+".sendDocuments.v1");
                        messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "sendDocuments" ));
                        FileDataSource ds = new FileDataSource( tmpFile );
                        DataHandler d1 = new DataHandler( ds );
                        AttachmentPart a1 = new AttachmentPart( d1 );
                        a1.setContentId( attachmentName );
                        a1.setMimeHeader("Content-Transfer-Encoding","base64");
                        a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                        a1.addMimeHeader("Content-Encoding","gzip");
                        msg.addAttachmentPart(a1);
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("getSendStatus") )
                    {
                        GetSendStatusBody b = new GetSendStatusBody();
                        b.keha = attachmentName;
                        header.setNimi(Settings.Client_ProducerName+".getSendStatus.v1");
                        messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "getSendStatus" ));
                        FileDataSource ds = new FileDataSource( tmpFile );
                        DataHandler d1 = new DataHandler( ds );
                        AttachmentPart a1 = new AttachmentPart( d1 );
                        a1.setContentId( attachmentName );
                        a1.setMimeHeader("Content-Transfer-Encoding","base64");
                        a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                        a1.addMimeHeader("Content-Encoding","gzip");
                        msg.addAttachmentPart(a1);
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("receiveDocuments") )
                    {
                        ReceiveDocumentsBody b = new ReceiveDocumentsBody();
                        b.arv = 10;
                        b.kaust = new ArrayList<String>();
                        //b.kaust.add("/TEST");
                        header.setNimi(Settings.Client_ProducerName+".receiveDocuments.v1");
                        messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "receiveDocuments" ));
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("markDocumentsReceived") )
                    {
                        MarkDocumentsReceivedBody b = new MarkDocumentsReceivedBody();
                        b.dokumendid = attachmentName;
                        b.kaust = "";
                        header.setNimi(Settings.Client_ProducerName+".markDocumentsReceived.v1");
                        messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "markDocumentsReceived" ));
                        FileDataSource ds = new FileDataSource( tmpFile );
                        DataHandler d1 = new DataHandler( ds );
                        AttachmentPart a1 = new AttachmentPart( d1 );
                        a1.setContentId( attachmentName );
                        a1.setMimeHeader("Content-Transfer-Encoding","base64");
                        a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                        a1.addMimeHeader("Content-Encoding","gzip");
                        msg.addAttachmentPart(a1);
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("deleteOldDocuments") )
                    {
                        header.setNimi(Settings.Client_ProducerName+".deleteOldDocuments.v1");
                        messageData = (new SoapMessageBuilder(header, "<dhl:deleteOldDocuments><keha></keha></dhl:deleteOldDocuments>")).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "deleteOldDocuments" ));
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("runSystemCheck") )
                    {
                        header.setNimi(Settings.Client_ProducerName+".runSystemCheck.v1");
                        messageData = (new SoapMessageBuilder(header, "<dhl:runSystemCheck><keha></keha></dhl:runSystemCheck>")).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "runSystemCheck" ));
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("changeOrganizationData") )
                    {
                        header.setNimi(Settings.Client_ProducerName+".changeOrganizationData.v1");
                        messageData = (new SoapMessageBuilder(header, "<dhl:changeOrganizationData>"+ getFileContents(inputFile) +"</dhl:changeOrganizationData>")).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "changeOrganizationData" ));
                        call.invoke( msg );
                    }
                    else if( action.equalsIgnoreCase("getSendingOptions.v2") )
                    {
                        header.setNimi(Settings.Client_ProducerName+".getSendingOptions.v2");
                        messageData = (new SoapMessageBuilder(header, "<dhl:getSendingOptions>"+ getFileContents(inputFile) +"</dhl:getSendingOptions>")).getMessageAsText();
                        msg = new Message( messageData );
                        call.setOperationName( new QName("http://producers.dhl.xtee.riik.ee/producer/dhl", "getSendingOptions" ));
                        call.invoke( msg );
                    }
                }
                catch (Exception ex) {
                    CommonMethods.logError( ex, "clnt.DhlTestClient", "main" );
                    CommonMethods.writeLog( ex.toString(), true );
                    CommonMethods.writeLog( ex.getMessage(), true );
                    continue;
                }
                
                try
                {
                    Message responseMessage = call.getResponseMessage();
                    Iterator attachments = responseMessage.getAttachments();
                    while (attachments.hasNext()) {
                        AttachmentPart a = (AttachmentPart) attachments.next();
                        DataHandler dh = a.getDataHandler();
                        DataSource ds = dh.getDataSource();
                        CommonMethods.getDataFromDataSource(ds, "", outputFile, false);
                        CommonMethods.gzipUnpackXML(outputFile, false);
                    }
                }
                catch(Exception ex) {
                    throw ex;
                }
                long operationEnd = (new Date()).getTime();
                testCaseDuration += (operationEnd - operationStart);
                CommonMethods.writeLog( action + ": " + String.valueOf((double)(((double)operationEnd - (double)operationStart) / 1000f)), true );
                if( (i % 5) == 4 )
                {
                    CommonMethods.writeLog("Test case total: " + String.valueOf((double)((double)testCaseDuration / 1000f)) + "\r\n", true );
                    testCaseDuration = 0;
                }
            }
            long globalEnd = (new Date()).getTime();
            CommonMethods.writeLog( "Process total duration: " + String.valueOf((double)(((double)globalEnd - (double)globalStart) / 1000f)), true );
        }
        catch( Exception ex )
        {
            CommonMethods.logError( ex, "clnt.DhlTestClient", "main" );
            CommonMethods.writeLog( ex.toString(), true );
            CommonMethods.writeLog( ex.getMessage(), true );
        }
    }
    
    private static String getFileContents(String fileName) {
        String result = "";
        StringBuilder sb = null;
        FileInputStream stream = null;
        InputStreamReader reader = null;
        char[] buffer = null;
        try {
            sb = new StringBuilder("");
            stream = new FileInputStream(fileName);
            reader = new InputStreamReader(stream, "UTF-8");
            buffer = new char[65536];
            int len = 0;
            while ((len = reader.read(buffer, 0, buffer.length)) > 0) {
                sb.append(buffer, 0, len);
            }
            result = sb.toString();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            CommonMethods.safeCloseReader(reader);
            CommonMethods.safeCloseStream(stream);
            reader = null;
            stream = null;
            buffer = null;
            sb = null;
        }
        return result;
    }
    
}
