package integration;

import dvk.client.ClientAPI;
import dvk.client.businesslayer.Occupation;
import dvk.client.businesslayer.Subdivision;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.iostructures.GetSendingOptionsV3ResponseType;
import dvk.core.CommonMethods;
import dvk.core.HeaderVariables;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.junit.Test;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class OrgCapabilityCheckerRequestsIntegration {

    private ClientAPI dvkClient;

    @Test
    public void getOccupationListAndGetSendingOptionsAndGetSubdivionListRequestsTest() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            ArrayList<Occupation> resultOfGetOccupationList = null;
            ArrayList<Subdivision> resultOfGetSubdivisionList = null;
            GetSendingOptionsV3ResponseType resultOfGetSendingOptions = new GetSendingOptionsV3ResponseType();

            // Get a connection to dataBase
            try {
                initClient(path);
            } catch (Exception ex) {
                ex.printStackTrace();
                Assert.fail();
            }

            UnitCredential[] credList = new UnitCredential[] {};

            try {
                credList = UnitCredential.getCredentials(DatabaseSessionService.getInstance().getOrgSettings(),
                        DatabaseSessionService.getInstance().getConnection());
            } catch (Exception ex) {
                System.out.println("Unable to find credential");
                DatabaseSessionService.getInstance().clearSession();
                CommonMethods.safeCloseDatabaseConnection(DatabaseSessionService.getInstance().getConnection());
                Assert.fail();
            }

            Assert.assertNotNull(credList[0]);

            UnitCredential cred = credList[0];
            ArrayList<String> orgCodes = new ArrayList<String>();

            HeaderVariables headerVar = new HeaderVariables(
                    cred.getInstitutionCode(),
                    cred.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(cred.getPersonalIdCode()) ? cred.getPersonalIdCode() : "EE"+cred.getPersonalIdCode()));

            // Execute getSendingOptionsRequest with all necessary parameters
            try {
                resultOfGetSendingOptions = dvkClient.getSendingOptions(headerVar, null, null, null, false, -1, -1,
                        DatabaseSessionService.getInstance().getOrgSettings().getDvkSettings().getGetSendingOptionsRequestVersion());
            } catch (Exception ex) {
                System.out.println("Problems in getSendingOptions request");
                CommonMethods.safeCloseDatabaseConnection(DatabaseSessionService.getInstance().getConnection());
                DatabaseSessionService.getInstance().clearSession();
                Assert.fail();
            }

            // Assert getSendingOptions response
            Assert.assertNotNull(resultOfGetSendingOptions);
            Assert.assertEquals(4, resultOfGetSendingOptions.allyksused.size());
            Assert.assertEquals(4, resultOfGetSendingOptions.asutused.size());
            Assert.assertEquals(5, resultOfGetSendingOptions.ametikohad.size());

            // Get org codes from getSendingOptions response (for getOccupationList)
            for (int i = 0; i < resultOfGetSendingOptions.asutused.size(); ++i) {
                orgCodes.add(resultOfGetSendingOptions.asutused.get(i).getOrgCode());
            }

            // Execute getOccupationList request with all necessary parameters
            try {
                resultOfGetOccupationList = dvkClient.getOccupationList(headerVar, orgCodes,
                        DatabaseSessionService.getInstance().getOrgSettings().getDvkSettings().getGetSendStatusRequestVersion());
            } catch (Exception ex) {
                System.out.println("Problems in getOccupationList request");
                CommonMethods.safeCloseDatabaseConnection(DatabaseSessionService.getInstance().getConnection());
                DatabaseSessionService.getInstance().clearSession();
                Assert.fail();
            }

            // Assert getOccupationList response
            Assert.assertNotNull(resultOfGetOccupationList);
            Assert.assertEquals(5, resultOfGetOccupationList.size());

            // Execute getSubdivisionList request with all necessary parameters
            try {
                resultOfGetSubdivisionList = dvkClient.getSubdivisionList(headerVar, orgCodes);
            } catch (Exception ex) {
                System.out.println("Problems in getSendingOptions request");
                CommonMethods.safeCloseDatabaseConnection(DatabaseSessionService.getInstance().getConnection());
                DatabaseSessionService.getInstance().clearSession();
                Assert.fail();
            }

            // Assert getSubdivisionList response
            Assert.assertNotNull(resultOfGetSubdivisionList);
            Assert.assertEquals(4, resultOfGetSubdivisionList.size());

            CommonMethods.safeCloseDatabaseConnection(DatabaseSessionService.getInstance().getConnection());
            DatabaseSessionService.getInstance().clearSession();
        }
    }

    public void initClient(String propertiesFile) throws Exception {
        Settings.loadProperties(propertiesFile);

        ArrayList<OrgSettings> allKnownDatabases = null;
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);

        // Initialize client
        dvkClient = new ClientAPI();

        Connection connection = null;

        try {
            dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
            dvkClient.setAllKnownDatabases(allKnownDatabases);
            dvkClient.setOrgSettings(allKnownDatabases.get(0).getDvkSettings());
            connection = DBConnection.getConnection(allKnownDatabases.get(0));
            DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));
        } catch (Exception ex) {
            throw new Exception("Can't init the client");
        }
    }
}
