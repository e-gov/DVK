package dvk.client.test;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import dvk.client.ClientAPI;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.conf.OrgDvkSettings;
import dvk.client.db.UnitCredential;
import dvk.client.iostructures.ReceiveDocumentsResult;
import dvk.core.CommonMethods;
import dvk.core.HeaderVariables;
import dvk.core.Settings;

public class CommunicationTestClient {
	private static Logger logger = Logger.getLogger(CommunicationTestClient.class.getName());
	private static ArrayList<Integer> pendingDocuments = new ArrayList<Integer>();
    
    public static void main (String[] args) {
        try {
            // Laeme seaded
            String propertiesFile = "dhlclient.properties";
            for (int i = 0; i < args.length; ++i) {
                if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                    propertiesFile = args[i].substring(6).replaceAll("\"","");
                }
            }
            Settings.loadProperties(propertiesFile);
            
            ClientAPI dvkClient = new ClientAPI();
            try {
                dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
            } catch (Exception ex) {
                ex.printStackTrace();
                return;
            }
            OrgDvkSettings dvkSet = new OrgDvkSettings();
            dvkSet.setDefaultStatusID(1);
            dvkSet.setGetSendingOptionsRequestVersion(1);
            dvkSet.setGetSendStatusRequestVersion(1);
            dvkSet.setMarkDocumentsReceivedRequestVersion(1);
            dvkSet.setReceiveDocumentsRequestVersion(1);
            dvkSet.setSendDocumentsRequestVersion(1);
            dvkClient.setOrgSettings(dvkSet);
            
            // Debug information
            logger.debug("Producer: "+ Settings.Client_ProducerName);
            
            // Create X-Road header
            HeaderVariables header = new HeaderVariables(
                Settings.currentProperties.getProperty("test_org_code"),
                Settings.currentProperties.getProperty("test_person_id_code"),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(Settings.currentProperties.getProperty("test_person_id_code")) ? Settings.currentProperties.getProperty("test_person_id_code") : "EE"+Settings.currentProperties.getProperty("test_person_id_code")));


            // Test variables
            boolean ok = false;
            int okCount = 0;
            int failedCount = 0;
            
            // Running tests
            logger.debug("\nRunning tests:");
            logger.debug("1) SEND correct document to organization (v1):\t");
            ok = runTest1(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("2) SEND correct document to division (v1):\t");
            ok = runTest2(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("3) SEND correct document to occupation (v1):\t");
            ok = runTest3(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("4) SEND correct document to division and occupation (v1):\t");
            ok = runTest4(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("5) Receiving all documents as administrator (v3):\t");
            ok = runTest5(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("6) Receiving division documents as administrator (v3):\t");
            ok = runTest6(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("7) Receiving occupation documents as administrator (v3):\t");
            ok = runTest7(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("8) Receiving division and occupation documents as administrator (v3):\t");
            ok = runTest8(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("9) Receiving all documents as employee with specific occupation (v3):\t");
            ok = runTest9(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;

            logger.debug("10) Receiving all documents as employee in specific division (v3):\t");
            ok = runTest10(dvkClient, header);
            logger.debug(ok ? "OK" : "Failed!");
            okCount += ok ? 1 : 0;
            failedCount += ok ? 0 : 1;            
            
            // Cleanup
            logger.debug("\nCleaning up:\t");
            try {
                //dvkClient.markDocumentsReceived(header, pendingDocuments, 0, null, "", "", false, null, null);
                logger.debug("OK");
            } catch (Exception ex) {
                logger.debug("Failed!");
                ex.printStackTrace();
            }
        }
        catch (Exception ex) {
            logger.error(ex);
            CommonMethods.writeLog( ex.toString(), true );
            CommonMethods.writeLog( ex.getMessage(), true );
        }
    }
    
    private static boolean runTest1(ClientAPI dvkClient, HeaderVariables header) {
        try {
            DhlMessage message = new DhlMessage();
            message.setFilePath(buildTestFile1(0, 0, null));
            message.setIsIncoming(false);
            int id = dvkClient.sendDocuments(header, message, 1);
            if (id > 0) {
                pendingDocuments.add(id);
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest2(ClientAPI dvkClient, HeaderVariables header) {
        try {
            DhlMessage message = new DhlMessage();
            message.setFilePath(buildTestFile1(1, 0, null));
            message.setIsIncoming(false);
            int id = dvkClient.sendDocuments(header, message, 1);
            if (id > 0) {
                pendingDocuments.add(id);
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest3(ClientAPI dvkClient, HeaderVariables header) {
        try {
            DhlMessage message = new DhlMessage();
            message.setFilePath(buildTestFile1(0, 2, null));
            message.setIsIncoming(false);
            int id = dvkClient.sendDocuments(header, message, 1);
            if (id > 0) {
                pendingDocuments.add(id);
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest4(ClientAPI dvkClient, HeaderVariables header) {
        try {
            DhlMessage message = new DhlMessage();
            message.setFilePath(buildTestFile1(1, 2, null));
            message.setIsIncoming(false);
            int id = dvkClient.sendDocuments(header, message, 1);
            if (id > 0) {
                pendingDocuments.add(id);
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest5(ClientAPI dvkClient, HeaderVariables header) {
        try {
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 0, "", 0, "", 3);
            if (result.documents.size() == 4) {
                return true;
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 4)\t");
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest6(ClientAPI dvkClient, HeaderVariables header) {
        try {
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 1, "", 0, "", 3);
            if (result.documents.size() == 2) {
                UnitCredential unit = new UnitCredential();
                DhlMessage msg1 = new DhlMessage(result.documents.get(0), unit);
                DhlMessage msg2 = new DhlMessage(result.documents.get(1), unit);
                if ((msg1.getDhlID() != pendingDocuments.get(1)) && (msg1.getDhlID() != pendingDocuments.get(3))) {
                    return false;
                }
                if ((msg2.getDhlID() != pendingDocuments.get(1)) && (msg2.getDhlID() != pendingDocuments.get(3))) {
                    return false;
                }
                if (msg1.getDhlID() == msg2.getDhlID()) {
                    return false;
                }
                return true;
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 2)\t");
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }

    private static boolean runTest7(ClientAPI dvkClient, HeaderVariables header) {
        try {
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 0, "", 2, "", 3);
            if (result.documents.size() == 2) {
                UnitCredential unit = new UnitCredential();
                DhlMessage msg1 = new DhlMessage(result.documents.get(0), unit);
                DhlMessage msg2 = new DhlMessage(result.documents.get(1), unit);
                if ((msg1.getDhlID() != pendingDocuments.get(2)) && (msg1.getDhlID() != pendingDocuments.get(3))) {
                    return false;
                }
                if ((msg2.getDhlID() != pendingDocuments.get(2)) && (msg2.getDhlID() != pendingDocuments.get(3))) {
                    return false;
                }
                if (msg1.getDhlID() == msg2.getDhlID()) {
                    return false;
                }
                return true;
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 2)\t");
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest8(ClientAPI dvkClient, HeaderVariables header) {
        try {
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 1, "", 2, "", 3);
            if (result.documents.size() == 1) {
                UnitCredential unit = new UnitCredential();
                DhlMessage msg = new DhlMessage(result.documents.get(0), unit);
                if (msg.getDhlID() != pendingDocuments.get(3)) {
                    return false;
                }
                return true;
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 1)\t");
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            return false;
        }
    }
    
    private static boolean runTest9(ClientAPI dvkClient, HeaderVariables header) {
        boolean success = false;
        String defaultPersonalID = header.getPersonalIDCode();
        String defaultPersonalIDCC = header.getPIDWithCountryCode();
        try {
            header.setPersonalIDCode("11111111111");
            header.setPIDWithCountryCode("EE11111111111");
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 0, "", 0, "", 3);
            if (result.documents.size() == 1) {
                UnitCredential unit = new UnitCredential();
                DhlMessage msg = new DhlMessage(result.documents.get(0), unit);
                if (msg.getDhlID() != pendingDocuments.get(2)) {
                    success = false;
                } else {
                    success = true;
                }
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 1)\t");
                success = false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            success = false;
        } finally {
            header.setPersonalIDCode(defaultPersonalID);
            header.setPIDWithCountryCode(defaultPersonalIDCC);
        }
        return success;
    }
    
    private static boolean runTest10(ClientAPI dvkClient, HeaderVariables header) {
        boolean success = false;
        String defaultPersonalID = header.getPersonalIDCode();
        String defaultPersonalIDCC = header.getPIDWithCountryCode();
        try {
            header.setPersonalIDCode("22222222222");
            header.setPIDWithCountryCode("EE22222222222");
            ReceiveDocumentsResult result = dvkClient.receiveDocuments(header, 10, null, 0, "", 0, "", 3);
            if (result.documents.size() == 1) {
                UnitCredential unit = new UnitCredential();
                DhlMessage msg = new DhlMessage(result.documents.get(0), unit);
                if (msg.getDhlID() != pendingDocuments.get(1)) {
                    success = false;
                } else {
                    success = true;
                }
            } else {
                logger.error("Incorrect amount of documents received (got "+ String.valueOf(result.documents.size()) +", expected 1)\t");
                success = false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage()+"\t");
            success = false;
        } finally {
            header.setPersonalIDCode(defaultPersonalID);
            header.setPIDWithCountryCode(defaultPersonalIDCC);
        }
        return success;
    }
    
    private static String buildTestFile1(int recipientDivision, int recipientOccupation, String recipientPersonalID) {
        String fileName = CommonMethods.createPipelineFile(0);
        StringBuilder dvkContainer = new StringBuilder(4096);
        dvkContainer.append("<dhl:dokument xmlns:dhl=\"http://www.riik.ee/schemas/dhl\">\n");
        dvkContainer.append("    <dhl:metainfo xmlns:mm=\"http://www.riik.ee/schemas/dhl-meta-manual\" xmlns:ma=\"http://www.riik.ee/schemas/dhl-meta-automatic\">\n");
        dvkContainer.append("    </dhl:metainfo>\n");
        dvkContainer.append("    <dhl:transport>\n");
        dvkContainer.append("        <dhl:saatja>\n");
        dvkContainer.append("            <dhl:regnr>"+ Settings.currentProperties.getProperty("test_org_code") +"</dhl:regnr>\n");
        dvkContainer.append("        </dhl:saatja>\n");
        dvkContainer.append("        <dhl:saaja>\n");
        dvkContainer.append("            <dhl:regnr>"+ Settings.currentProperties.getProperty("test_org_code") +"</dhl:regnr>\n");
        if (recipientDivision > 0) {
            dvkContainer.append("            <dhl:allyksuse_kood>").append(recipientDivision).append("</dhl:allyksuse_kood>\n");
        }
        if (recipientOccupation > 0) {
            dvkContainer.append("            <dhl:ametikoha_kood>").append(recipientOccupation).append("</dhl:ametikoha_kood>\n");
        }
        if ((recipientPersonalID != null) && (recipientPersonalID.length() > 0)) {
            dvkContainer.append("            <dhl:isikukood>").append(recipientPersonalID).append("</dhl:isikukood>\n");
        }
        dvkContainer.append("        </dhl:saaja>\n");
        dvkContainer.append("    </dhl:transport>\n");
        dvkContainer.append("    <dhl:ajalugu/>\n");
        dvkContainer.append("    <dhl:metaxml/>\n");
        dvkContainer.append("<SignedDoc format=\"DIGIDOC-XML\" version=\"1.3\" xmlns=\"http://www.sk.ee/DigiDoc/v1.3.0#\">\n");
        dvkContainer.append("<DataFile ContentType=\"EMBEDDED_BASE64\" Filename=\"test.txt\" Id=\"D0\" MimeType=\"text/plain\" Size=\"6\" xmlns=\"http://www.sk.ee/DigiDoc/v1.3.0#\">dGVzdA0K\n");
        dvkContainer.append("</DataFile>\n");
        dvkContainer.append("</SignedDoc>\n");
        dvkContainer.append("</dhl:dokument>");
        CommonMethods.writeToFile(fileName, dvkContainer.toString().getBytes());
        return fileName;
    }
}
