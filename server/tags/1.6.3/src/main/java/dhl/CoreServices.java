package dhl;

import dhl.aar.AarClient;
import dhl.aar.AarSyncronizer;
import dhl.exceptions.IncorrectRequestVersionException;
import dhl.exceptions.ResponseProcessingException;
import dhl.iostructures.SOAPOutputBodyRepresentation;
import dhl.iostructures.XHeader;
import dhl.iostructures.changeOrganizationDataResponseType;
import dhl.iostructures.deleteOldDocumentsResponseType;
import dhl.iostructures.getOccupationListV2ResponseType;
import dhl.iostructures.getSendStatusResponseType;
import dhl.iostructures.getSendStatusV2ResponseType;
import dhl.iostructures.getSendingOptionsV3ResponseType;
import dhl.iostructures.getSubdivisionListV2ResponseType;
import dhl.iostructures.listMethodsResponseType;
import dhl.iostructures.markDocumentsReceivedResponseType;
import dhl.iostructures.markDocumentsReceivedV3ResponseType;
import dhl.iostructures.receiveDocumentsResponseType;
import dhl.iostructures.receiveDocumentsV2ResponseType;
import dhl.iostructures.receiveDocumentsV3ResponseType;
import dhl.iostructures.receiveDocumentsV4ResponseType;
import dhl.iostructures.runSystemCheckResponseType;
import dhl.iostructures.sendDocumentsResponseType;
import dhl.requests.ChangeOrganizationData;
import dhl.requests.DeleteOldDocuments;
import dhl.requests.GetOccupationList;
import dhl.requests.GetSendStatus;
import dhl.requests.GetSendingOptions;
import dhl.requests.GetSubdivisionList;
import dhl.requests.MarkDocumentsReceived;
import dhl.requests.ReceiveDocuments;
import dhl.requests.RequestInternalResult;
import dhl.requests.SendDocuments;
import dhl.sys.TempCleaner;
import dhl.sys.Timer;
import dhl.users.UserProfile;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Vector;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServlet;
import javax.xml.soap.AttachmentPart;
import javax.xml.soap.SOAPBody;
import org.apache.axis.AxisFault;
import org.apache.axis.MessageContext;
import org.apache.axis.message.SOAPEnvelope;
import org.apache.axis.message.SOAPHeaderElement;
import org.apache.axis.transport.http.HTTPConstants;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.apache.log4j.Logger;

public class CoreServices implements Dhl {
    public static String XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";
    static Logger logger = Logger.getLogger(CoreServices.class.getName());

    public CoreServices() throws AxisFault {
        try {
            // Get configuration file location from servlet settings
            HttpServlet httpServlet = (HttpServlet)MessageContext.getCurrentContext().getProperty(HTTPConstants.MC_HTTP_SERVLET);
            String configFileName = httpServlet.getInitParameter("configFile");

            // Make sure the configuration file actually exists
            if (CommonMethods.isNullOrEmpty(configFileName)) {
            	throw new FileNotFoundException("DVK configuration error. Path to configuration file is not set!");
            } else if (!(new File(configFileName)).exists()) {
            	configFileName = httpServlet.getServletContext().getRealPath(configFileName);
            }
            if (!(new File(configFileName)).exists()) {
            	throw new FileNotFoundException("DVK configuration error. Specified configuration file dows not exist!");
            }

            // Load configuration
            File configFile = new File(configFileName);
            Settings.loadProperties(configFile.getAbsolutePath());

            // Start a cleaner object that cleans up temporary files in a separate thread.
            // Temporary files should not be deleted immediately after use because some of them
            // are needed for SOAP response. Deleting such files would cause an error while
            // sending response to client.
            TempCleaner cleaner = new TempCleaner();
            cleaner.init();

            // Get organization, subdivision and occupation data from central database
            if (Settings.Server_UseCentralRightsDatabase) {
                Connection conn = getConnection();
                AarSyncronizer aarSync = new AarSyncronizer();
                aarSync.init(conn, Settings.Server_CentralRightsDatabaseSyncPeriod);
                // Opened database connection will be closed by AarSyncronizer thread when it finishes
            }
        } catch (Exception ex) {
            logger.fatal(ex.getMessage(), ex);
            throw new AxisFault(ex.getMessage());
        }
    }


    protected void finalize() {
        //        Runtime r = Runtime.getRuntime();
        //        r.gc();
    }

    private Connection getConnection() throws AxisFault {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            javax.sql.DataSource ds = (javax.sql.DataSource) envContext.lookup(Settings.Server_DatabaseEnvironmentVariable);
            return ds.getConnection();
        } catch (Exception ex) {
        	logger.fatal(ex.getMessage(), ex);
            throw new AxisFault("DVK Internal error. Error connecting to database: " + ex.getMessage());
        }
    }

    /**
     * @webmethod
     */
    public void listMethods() throws AxisFault {
        try {
            String producer = Settings.Server_ProducerName;
            String[] keha = null;
            if (Settings.Server_RunOnClientDatabase) {
                keha = new String[]
                {
                    producer + ".sendDocuments.v1",
                    producer + ".sendDocuments.v2",
                    producer + ".sendDocuments.v3",
                    producer + ".getSendStatus.v1",
                    producer + ".getSendStatus.v2",
                    producer + ".getSendingOptions.v1",
                    producer + ".getSendingOptions.v2",
                    producer + ".getSendingOptions.v3"
                };
            } else {
                keha = new String[]
                {
                    producer + ".sendDocuments.v1",
                    producer + ".sendDocuments.v2",
                    producer + ".sendDocuments.v3",
                    producer + ".getSendStatus.v1",
                    producer + ".getSendStatus.v2",
                    producer + ".receiveDocuments.v1",
                    producer + ".receiveDocuments.v2",
                    producer + ".receiveDocuments.v3",
                    producer + ".receiveDocuments.v4",
                    producer + ".markDocumentsReceived.v1",
                    producer + ".markDocumentsReceived.v2",
                    producer + ".markDocumentsReceived.v3",
                    producer + ".getSendingOptions.v1",
                    producer + ".getSendingOptions.v2",
                    producer + ".getSendingOptions.v3",
                    producer + ".deleteOldDocuments.v1",
                    producer + ".changeOrganizationData.v1",
                    producer + ".runSystemCheck.v1",
                    producer + ".getOccupationList.v1",
                    producer + ".getOccupationList.v2",
                    producer + ".getSubdivisionList.v1",
                    producer + ".getSubdivisionList.v2"
                };
            }
            org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
            org.apache.axis.Message response = context.getResponseMessage();
            listMethodsResponseType body = new listMethodsResponseType(keha);
            body.addToSOAPBody(response);
            response.saveChanges();
        } catch (Exception ex) {
        	logger.error(ex.getMessage(), ex);
            throw new AxisFault(ex.getMessage());
        }
    }

    /**
     * @webmethod
     */
    public void runSystemCheck(Object keha) throws AxisFault {
        Connection conn = null;
        try {
            // Kontrollime, kas konfiguratsioonifail on edukalt sisse loetud
            if ((Settings.currentProperties == null) || (Settings.currentProperties.size() < 1)) {
                throw new AxisFault("DVK tarkvaraline viga: Rakenduse seadistuse laadimine ebaõnnestus!");
            }

            // Proovime avada andmebaasiühendust
            try {
                conn = getConnection();
            } catch (Exception ex) {
                throw new AxisFault("DVK tarkvaraline viga: Andmebaasiühenduse loomine ebaõnnestus!");
            }

            // Proovime andmebaasiühenduse peal päringut käivitada
            Statement stmt = conn.createStatement();
            try {
                boolean stmtResult = stmt.execute("SELECT COUNT(*) FROM klassifikaatori_tyyp");
                if (!stmtResult) {
                    throw new AxisFault("DVK tarkvaraline viga: Andmete lugemine andmebaasist ebaõnnestus!");
                }
            } catch (AxisFault a) {
                throw a;
            } catch (Exception ex) {
                throw new AxisFault("DVK tarkvaraline viga: Andmete lugemine andmebaasist ebaõnnestus!");
            } finally {
                stmt.close();
                stmt = null;
            }

            // Proovime kettale kirjutada
            String tmpFile = CommonMethods.createPipelineFile(0);
            if (tmpFile == null) {
                throw new AxisFault("DVK tarkvaraline viga: Failisüsteemi kirjutamine ebaõnnestus!");
            } else {
                (new File(tmpFile)).delete();
            }

            // Proovime, kas õiguste kesksüsteemi liides toimib
            if (Settings.Server_UseCentralRightsDatabase) {
                try {
                    AarClient aarClient = new AarClient(Settings.Server_CentralRightsDatabaseURL, Settings.Server_CentralRightsDatabaseOrgCode, Settings.Server_CentralRightsDatabasePersonCode);
                    ArrayList<String> orgs = new ArrayList<String>();
                    orgs.add("70006317");
                    aarClient.asutusedRequest(orgs, null);
                } catch (Exception ex) {
                	logger.error(ex.getMessage(), ex);
                    throw new AxisFault("DVK tarkvaraline viga: Keskse õiguste andmekoguga ühendamine ebaõnnestus!");
                }
            }

            org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
            org.apache.axis.Message response = context.getResponseMessage();
            String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
            if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
            }
            response.getSOAPEnvelope().removeHeaders();
            Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
            for (int i = 0; i < headers.size(); ++i) {
                response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
            }
            response.getSOAPEnvelope().removeBody();
            response.getSOAPEnvelope().addBody();
            runSystemCheckResponseType body = new runSystemCheckResponseType();
            body.setRequestElement(getXRoadRequestBodyElement(context, "runSystemCheck"));
            body.addToSOAPBody(response);
            response.saveChanges();
        } catch (AxisFault a) {
            CommonMethods.logError(a, this.getClass().getName(), "runSystemCheck");
            throw a;
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "runSystemCheck");
            throw new AxisFault(ex.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception ex1) {
                    CommonMethods.logError(ex1, this.getClass().getName(), "runSystemCheck");
                } finally {
                    conn = null;
                }
            }
        }
    }

    /**
     * @webmethod
     */
    public void deleteOldDocuments(Object keha) throws AxisFault {
        // Antud meetod on kasutatav ainult juhul, kui DVK server ei ole seadistatud
        // töötama kliendi andmebaasi peal.
        if (!Settings.Server_RunOnClientDatabase) {
            Connection conn = null;
            try {
                conn = getConnection();
                DeleteOldDocuments.V1(conn);
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                deleteOldDocumentsResponseType body = new deleteOldDocumentsResponseType();
                body.setRequestElement(getXRoadRequestBodyElement(context, "deleteOldDocuments"));
                org.apache.axis.Message response = context.getResponseMessage();
                String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                    response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                }
                response.getSOAPEnvelope().removeHeaders();
                Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                for (int i = 0; i < headers.size(); ++i) {
                    response.getSOAPEnvelope().addHeader((SOAPHeaderElement) headers.get(i));
                }
                response.getSOAPEnvelope().removeBody();
                response.getSOAPEnvelope().addBody();
                body.addToSOAPBody(response);
                response.saveChanges();
            } catch (Exception ex) {
            	logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
            	CommonMethods.safeCloseDatabaseConnection(conn);
            	conn = null;
            }
        }
    }

    /**
     * @webmethod
     */
    public void changeOrganizationData(Object keha) throws AxisFault {
        if (!Settings.Server_RunOnClientDatabase) {
            Connection conn = null;
            try {
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                if (context != null) {
                    conn = getConnection();

                    // Laeme sõnumi X-Tee päised endale sobivasse andmestruktuuri
                    XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                    // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                    // autenditud kasutaja kohta.
                    UserProfile user = UserProfile.getFromHeaders(xTeePais, conn);

                    // Käivitame päringu keha
                    ChangeOrganizationData.V1(context, conn, user);

                    // Koostame vastuse
                    org.apache.axis.Message response = context.getResponseMessage();
                    changeOrganizationDataResponseType body = new changeOrganizationDataResponseType();
                    body.setRequestElement(getXRoadRequestBodyElement(context, "changeOrganizationData"));
                    String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                    if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                        response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                    }
                    response.getSOAPEnvelope().removeHeaders();
                    Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                    for (int i = 0; i < headers.size(); ++i) {
                        response.getSOAPEnvelope().addHeader((SOAPHeaderElement) headers.get(i));
                    }
                    response.getSOAPEnvelope().removeBody();
                    response.getSOAPEnvelope().addBody();
                    body.addToSOAPBody(response);
                    response.saveChanges();
                }
            } catch (AxisFault fault) {
            	logger.error(fault.getMessage(), fault);
            	throw fault;
            } catch (Exception ex) {
            	logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
            	CommonMethods.safeCloseDatabaseConnection(conn);
            	conn = null;
            }
        }
    }

    /**
     * @webmethod
     */
    public void getSendingOptions(Object keha) throws AxisFault {
    	Connection conn = null;
        try {
            org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
            if (context != null) {
                // Hangime andmebaasiühenduse
                OrgSettings hostOrgSettings = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // loeme kliendi konfiguratsioonifailist kasutatava andmebaasi andmed
                    // (andmebaasiplatvorm ja ühendusparameetrid)
                    ArrayList<OrgSettings> databases = OrgSettings.getSettings(Settings.Client_ConfigFile);
                    if (databases.size() != 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    hostOrgSettings = databases.get(0);
                    UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings, conn);
                    if (credentials.length < 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    conn = DBConnection.getConnection(hostOrgSettings);
                } else {
                    conn = getConnection();
                }

                // Laeme sõnumi X-Tee päised endale sobivasse andmestruktuuri
                XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                // Tuvastame, millist päringu versiooni välja kutsuti
                String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);

                // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                // autenditud kasutaja kohta.
                UserProfile user = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // ei ole meil mingit infot süsteemi kasutajate kohta.
                    user = new UserProfile();
                    user.setOrganizationCode(xTeePais.asutus);
                    if ((xTeePais.isikukood != null) && (xTeePais.isikukood.length() > 2)) {
                        user.setPersonCode(xTeePais.isikukood.substring(2));
                    } else {
                        user.setPersonCode(xTeePais.ametnik);
                    }
                } else {
                    user = UserProfile.getFromHeaders(xTeePais, conn);
                }

                // Käivitame päringust vajaliku versiooni
                SOAPOutputBodyRepresentation result = null;
                if (ver.equalsIgnoreCase("v1")) {
                    result = GetSendingOptions.V1(context, conn, hostOrgSettings);
                } else if (ver.equalsIgnoreCase("v2")) {
                    result = GetSendingOptions.V2(context, conn, hostOrgSettings);
                } else if (ver.equalsIgnoreCase("v3")) {
                    result = GetSendingOptions.V3(context, conn, hostOrgSettings, user);
                } else {
                    // Vale versioon
                    throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                }

                // Koostame väljundsõnumi keha
                 org.apache.axis.Message response = context.getResponseMessage();
                 String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                 if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                     response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                 }
                 response.getSOAPEnvelope().removeHeaders();
                 Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                 for (int i = 0; i < headers.size(); ++i) {
                     response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                 }
                 response.getSOAPEnvelope().removeBody();
                 response.getSOAPEnvelope().addBody();

                 if (ver.equalsIgnoreCase("v3")) {
	                 FileDataSource ds = new FileDataSource(((getSendingOptionsV3ResponseType)result).responseFile);
	                 DataHandler d1 = new DataHandler(ds);
	                 org.apache.axis.attachments.AttachmentPart a1 = new org.apache.axis.attachments.AttachmentPart(d1);
	                 a1.setMimeHeader("Content-Transfer-Encoding", "base64");
	                 a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
	                 a1.addMimeHeader("Content-Encoding", "gzip");
	                 response.addAttachmentPart(a1);
	                 ((getSendingOptionsV3ResponseType)result).kehaHref = a1.getContentId();
                 }

                 result.addToSOAPBody(response);
                 response.saveChanges();
            } else {
                throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
            }
        } catch (AxisFault fault) {
        	logger.error(fault.getMessage(), fault);
        	throw fault;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            throw new AxisFault(ex.getMessage());
        } finally {
            CommonMethods.safeCloseDatabaseConnection(conn);
            conn = null;
        }
    }

    /**
     * @webmethod
     */
    public void sendDocuments(Object p1, Object keha) throws AxisFault {
        Timer t1 = new Timer();
        t1.reset();
        Timer t = new Timer();
        t.reset();
        t.markElapsed("\r\nStarting request sendDocuments");
        Connection conn = null;
        try {
            t.reset();
            org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
            t.markElapsed("Getting message context");
            if (context != null) {
                t.reset();
                OrgSettings hostOrgSettings = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // loeme kliendi konfiguratsioonifailist kasutatava andmebaasi andmed
                    // (andmebaasiplatvorm ja ühendusparameetrid)
                    ArrayList<OrgSettings> databases = OrgSettings.getSettings(Settings.Client_ConfigFile);
                    if (databases.size() != 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    hostOrgSettings = databases.get(0);
                    UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings, conn);
                    if (credentials.length < 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    conn = DBConnection.getConnection(hostOrgSettings);
                } else {
                    conn = getConnection();
                }
                t.markElapsed("Getting DB connection");

                // Laeme sõnumi X-Tee päised endale sobivasse andmestruktuuri
                t.reset();
                XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);
                t.markElapsed("Getting XRoad header");

                // Tuvastame, millist päringu versiooni välja kutsuti
                t.reset();
                String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);
                t.markElapsed("Getting request version");

                // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                // autenditud kasutaja kohta.
                t.reset();
                UserProfile user = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // ei ole meil mingit infot süsteemi kasutajate kohta.
                    user = new UserProfile();
                    user.setOrganizationCode(xTeePais.asutus);
                    if ((xTeePais.isikukood != null) && (xTeePais.isikukood.length() > 2)) {
                        user.setPersonCode(xTeePais.isikukood.substring(2));
                    } else {
                        user.setPersonCode(xTeePais.ametnik);
                    }
                } else {
                    user = UserProfile.getFromHeaders(xTeePais, conn);
                }
                t.markElapsed("Getting User profile");

                // Execute request business logic
                t.reset();
                RequestInternalResult result = new RequestInternalResult();
                if (ver.equalsIgnoreCase("v1")) {
                    result = SendDocuments.V1(context, conn, user, hostOrgSettings, xTeePais);
                } else if (ver.equalsIgnoreCase("v2")) {
                    result = SendDocuments.V2(context, conn, user, hostOrgSettings, xTeePais);
                } else if (ver.equalsIgnoreCase("v3")) {
                    result = SendDocuments.V3(context, conn, user, hostOrgSettings, xTeePais);
                } else {
                    // Unknown request version
                    throw new IncorrectRequestVersionException("Vigane päringu versioon \""+ ver +"\"! Lubatud versioonid on \"v1\", \"v2\" ja \"v3\".");
                }
                t.markElapsed("Executing Query body");

                try {
                    t.reset();
                    org.apache.axis.Message response = context.getResponseMessage();
                    String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                    if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                        response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                    }
                    response.getSOAPEnvelope().removeHeaders();
                    Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                    for (int i = 0; i < headers.size(); ++i) {
                        response.getSOAPEnvelope().addHeader((SOAPHeaderElement) headers.get(i));
                    }
                    response.getSOAPEnvelope().removeBody();
                    response.getSOAPEnvelope().addBody();

                    FileDataSource ds = new FileDataSource(result.responseFile);
                    DataHandler d1 = new DataHandler(ds);
                    org.apache.axis.attachments.AttachmentPart a1 = new org.apache.axis.attachments.AttachmentPart(d1);
                    a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                    a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                    a1.addMimeHeader("Content-Encoding", "gzip");
                    response.addAttachmentPart(a1);

                    sendDocumentsResponseType responseBody = new sendDocumentsResponseType();
                    responseBody.paring.dokumendid = result.dataMd5Hash;
                    responseBody.paring.kaust = result.folder;
                    responseBody.kehaHref = a1.getContentId();
                    responseBody.addToSOAPBody(response);

                    response.saveChanges();
                    t.markElapsed("Creating response message");
                } catch (Exception ex) {
                	logger.error(ex.getMessage(), ex);
                	logResponseFileProblems(result);
                    throw new ResponseProcessingException(CommonStructures.VIGA_VASTUSSONUMI_KOOSTAMISEL, ex);
                }
            } else {
                throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
            }
        } catch (AxisFault fault) {
        	logger.error(fault.getMessage(), fault);
            throw fault;
        } catch (Exception ex) {
        	logger.error(ex.getMessage(), ex);
            throw new AxisFault(ex.getMessage());
        } finally {
        	CommonMethods.safeCloseDatabaseConnection(conn);
            conn = null;
        }
        t1.markElapsed("Entire request duration");
    }


    /**
     *
     * @webmethod
     */
    public void receiveDocuments(Object keha) throws AxisFault {
        if (!Settings.Server_RunOnClientDatabase) {
        	Timer t1 = new Timer();
            t1.reset();
            Timer t = new Timer();
            t.reset();
            t.markElapsed("\r\nStarting request receiveDocuments");

            Connection conn = null;
            try {
                t.reset();
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                t.markElapsed("Getting message context");
                if (context != null) {
                    // Hangime andmebaasiühenduse
                    t.reset();
                    conn = getConnection();
                    t.markElapsed("Getting DB connection");

                    // Loeme SOAP sõnumi detailandmetest välja X-Tee päise andmed ja
                    // sõnumiga MIME lisadena kaasa pandud andmed.
                    t.reset();
                    XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);
                    t.markElapsed("Getting XRoad header");

                    // Tuvastame, millist päringu versiooni välja kutsuti
                    t.reset();
                    String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);
                    t.markElapsed("Getting request version");

                    // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                    // autenditud kasutaja kohta.
                    t.reset();
                    UserProfile user = UserProfile.getFromHeaders(xTeePais, conn);
                    t.markElapsed("Getting User profile");

                    // Käivitame päringu äriloogika
                    t.reset();
                    RequestInternalResult result = new RequestInternalResult();
                    if (ver.equalsIgnoreCase("v1")) {
                        result = ReceiveDocuments.V1(context, conn, user);
                    } else if (ver.equalsIgnoreCase("v2")) {
                        result = ReceiveDocuments.V2(context, conn, user);
                    } else if (ver.equalsIgnoreCase("v3")) {
                        result = ReceiveDocuments.V3(context, conn, user);
                    } else if (ver.equalsIgnoreCase("v4")) {
                        result = ReceiveDocuments.V4(context, conn, user);
                    } else {
                        // Vale versioon
                        throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                    }
                    t.markElapsed("Executing Query body");

                    try {
                        t.reset();
                        org.apache.axis.Message response = context.getResponseMessage();
                        String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                        if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                            response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                        }
                        response.getSOAPEnvelope().removeHeaders();
                        Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                        for (int i = 0; i < headers.size(); ++i) {
                            response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                        }
                        response.getSOAPEnvelope().removeBody();
                        response.getSOAPEnvelope().addBody();

                        FileDataSource ds = new FileDataSource(result.responseFile);
                        DataHandler d1 = new DataHandler(ds);
                        org.apache.axis.attachments.AttachmentPart a1 = new org.apache.axis.attachments.AttachmentPart(d1);
                        a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                        a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                        a1.addMimeHeader("Content-Encoding", "gzip");
                        response.addAttachmentPart(a1);

                        if (ver.equalsIgnoreCase("v1")) {
                            receiveDocumentsResponseType responseBody = new receiveDocumentsResponseType();
                            responseBody.paring.arv = result.count;
                            responseBody.paring.kaust = result.folders;
                            responseBody.kehaHref = a1.getContentId();
                            responseBody.addToSOAPBody(response);
                        } else if (ver.equalsIgnoreCase("v2")) {
                            receiveDocumentsV2ResponseType responseBody = new receiveDocumentsV2ResponseType();
                            responseBody.paring.arv = result.count;
                            responseBody.paring.kaust = result.folders;
                            responseBody.paring.edastusID = result.deliverySessionID;
                            responseBody.paring.fragmentNr = result.fragmentNr;
                            responseBody.paring.fragmentSizeBytesOrig = result.fragmentSizeBytes;
                            responseBody.dokumendidHref = a1.getContentId();
                            responseBody.edastusID = result.deliverySessionID;
                            responseBody.fragmenteKokku = result.totalFragments;
                            responseBody.fragmentNr = result.fragmentNr;
                            responseBody.addToSOAPBody(response);
                        } else if (ver.equalsIgnoreCase("v3")) {
                            receiveDocumentsV3ResponseType responseBody = new receiveDocumentsV3ResponseType();
                            responseBody.paring = getXRoadRequestBodyElement(context, "receiveDocuments");
                            responseBody.dokumendidHref = a1.getContentId();
                            responseBody.edastusID = result.deliverySessionID;
                            responseBody.fragmenteKokku = result.totalFragments;
                            responseBody.fragmentNr = result.fragmentNr;
                            responseBody.addToSOAPBody(response);
                        } else if (ver.equalsIgnoreCase("v4")) {
                            receiveDocumentsV4ResponseType responseBody = new receiveDocumentsV4ResponseType();
                            responseBody.paring = getXRoadRequestBodyElement(context, "receiveDocuments");
                            responseBody.dokumendidHref = a1.getContentId();
                            responseBody.edastusID = result.deliverySessionID;
                            responseBody.fragmenteKokku = result.totalFragments;
                            responseBody.fragmentNr = result.fragmentNr;
                            responseBody.addToSOAPBody(response);
                        }

                        response.saveChanges();
                        t.markElapsed("Creating response message");
                    } catch (Exception ex) {
                    	logger.error(ex.getMessage(), ex);
                    	logResponseFileProblems(result);
                        throw new AxisFault(CommonStructures.VIGA_VASTUSSONUMI_KOOSTAMISEL);
                    }
                } else {
                    throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
                }
            } catch (AxisFault fault) {
            	logger.error(fault.getMessage(), fault);
                throw fault;
            } catch (Exception ex) {
            	logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
            	CommonMethods.safeCloseDatabaseConnection(conn);
            	conn = null;
            }
            t1.markElapsed("Entire request duration");
        }
    }

    /**
     *
     * @webmethod
     */
    public void markDocumentsReceived(Object p1, Object keha) throws AxisFault {
        if (!Settings.Server_RunOnClientDatabase) {
            Connection conn = null;
            try {
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                if (context != null) {
                    // Hangime andmebaasiühenduse
                    conn = getConnection();

                    // Loeme SOAP sõnumi detailandmetest välja X-Tee päise andmed ja
                    // sõnumiga MIME lisadena kaasa pandud andmed.
                    XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                    // Tuvastame, millist päringu versiooni välja kutsuti
                    String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);

                    // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                    // autenditud kasutaja kohta.
                    UserProfile user = UserProfile.getFromHeaders(xTeePais, conn);

                    // Käivitame päringust vajaliku versiooni
                    RequestInternalResult result = new RequestInternalResult();
                    if (ver.equalsIgnoreCase("v1")) {
                        result = MarkDocumentsReceived.V1(context, conn, user);
                    } else if (ver.equalsIgnoreCase("v2")) {
                        result = MarkDocumentsReceived.V2(context, conn, user);
                    } else if (ver.equalsIgnoreCase("v3")) {
                        result = MarkDocumentsReceived.V3(context, conn, user);
                    } else {
                        // Vale versioon
                        throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                    }

                    // Koostame vastussõnumi keha
                    try {
                        org.apache.axis.Message response = context.getResponseMessage();
                        String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                        if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                            response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                        }
                        response.getSOAPEnvelope().removeHeaders();
                        Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                        for (int i = 0; i < headers.size(); ++i) {
                            response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                        }
                        response.getSOAPEnvelope().removeBody();
                        response.getSOAPEnvelope().addBody();

                        if (ver.equalsIgnoreCase("v3")) {
	                        markDocumentsReceivedV3ResponseType responseBody = new markDocumentsReceivedV3ResponseType();
	                        responseBody.paring = result.requestElement;
	                        responseBody.keha = "OK";
	                        responseBody.addToSOAPBody(response);
                        } else {
	                        markDocumentsReceivedResponseType responseBody = new markDocumentsReceivedResponseType();
	                        responseBody.paring.dokumendid = result.dataMd5Hash;
	                        responseBody.paring.kaust = result.folder;
	                        responseBody.keha = "OK";
	                        responseBody.addToSOAPBody(response);
                        }
                        response.saveChanges();
                    } catch (Exception ex) {
                    	logger.error(ex.getMessage(), ex);
                    	logResponseFileProblems(result);
                        throw new AxisFault(CommonStructures.VIGA_VASTUSSONUMI_KOOSTAMISEL);
                    }
                } else {
                    throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
                }
            } catch (AxisFault fault) {
                logger.error(fault.getMessage(), fault);
                throw fault;
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
                CommonMethods.safeCloseDatabaseConnection(conn);
                conn = null;
            }
        }
    }

    /**
     *
     * @webmethod
     */
    public void getSendStatus(Object p1, Object keha) throws AxisFault {
        Connection conn = null;
        try {
            org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
            if (context != null) {
                // Hangime andmebaasiühenduse
                OrgSettings hostOrgSettings = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // loeme kliendi konfiguratsioonifailist kasutatava andmebaasi andmed
                    // (andmebaasiplatvorm ja ühendusparameetrid)
                    ArrayList<OrgSettings> databases = OrgSettings.getSettings(Settings.Client_ConfigFile);
                    if (databases.size() != 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    hostOrgSettings = databases.get(0);
                    UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings, conn);
                    if (credentials.length < 1) {
                        throw new AxisFault("Viga DVK seadistuses!");
                    }
                    conn = DBConnection.getConnection(hostOrgSettings);
                } else {
                    conn = getConnection();
                }

                // Loeme SOAP sõnumi detailandmetest välja X-Tee päise andmed ja
                // sõnumiga MIME lisadena kaasa pandud andmed.
                XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                // Tuvastame, millist päringu versiooni välja kutsuti
                String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);

                // Laeme päises asunud andmete järgi süsteemi tööks vajalikud andmed
                // autenditud kasutaja kohta.
                UserProfile user = null;
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui server on seadistatud toimima kliendi andmetabelite peal, siis
                    // ei ole meil mingit infot süsteemi kasutajate kohta.
                    user = new UserProfile();
                    user.setOrganizationCode(xTeePais.asutus);
                    if ((xTeePais.isikukood != null) && (xTeePais.isikukood.length() > 2)) {
                        user.setPersonCode(xTeePais.isikukood.substring(2));
                    } else {
                        user.setPersonCode(xTeePais.ametnik);
                    }
                } else {
                    user = UserProfile.getFromHeaders(xTeePais, conn);
                }

                RequestInternalResult result = null;
                if (ver.equalsIgnoreCase("v1")) {
                	result = GetSendStatus.V1(context, conn, user, hostOrgSettings);
                } else if (ver.equalsIgnoreCase("v2")) {
                    result = GetSendStatus.V2(context, conn, user, hostOrgSettings);
                } else {
                    // Vale versioon
                    throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                }

                try {
                    org.apache.axis.Message response = context.getResponseMessage();
                    String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                    if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                        response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                    }
                    response.getSOAPEnvelope().removeHeaders();
                    Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                    for (int i = 0; i < headers.size(); ++i) {
                        response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                    }
                    response.getSOAPEnvelope().removeBody();
                    response.getSOAPEnvelope().addBody();

                    FileDataSource ds = new FileDataSource(result.responseFile);
                    DataHandler d1 = new DataHandler(ds);
                    AttachmentPart a1 = response.createAttachmentPart(d1);
                    a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                    a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                    a1.addMimeHeader("Content-Encoding", "gzip");
                    response.addAttachmentPart(a1);

                    if (ver.equalsIgnoreCase("v1")) {
	                    getSendStatusResponseType responseBody = new getSendStatusResponseType();
	                    responseBody.paringKehaHash = result.dataMd5Hash;
	                    responseBody.kehaHref = a1.getContentId();
	                    responseBody.addToSOAPBody(response);
                    } else if (ver.equalsIgnoreCase("v2")) {
	                    getSendStatusV2ResponseType responseBody = new getSendStatusV2ResponseType();
	                    responseBody.paring = CommonMethods.getXRoadRequestBodyElement(context, "getSendStatus");
	                    responseBody.dataMd5Hash = result.dataMd5Hash;
	                    responseBody.kehaHref = a1.getContentId();
	                    responseBody.addToSOAPBody(response);
                    }

                    response.saveChanges();
                } catch (Exception ex) {
                	logger.error(ex.getMessage(), ex);
                	logResponseFileProblems(result);
                    throw new AxisFault(CommonStructures.VIGA_VASTUSSONUMI_KOOSTAMISEL);
                }
            } else {
                throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
            }
        } catch (AxisFault fault) {
            logger.error(fault.getMessage(), fault);
            throw fault;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            throw new AxisFault(ex.getMessage());
        } finally {
        	CommonMethods.safeCloseDatabaseConnection(conn);
        	conn = null;
        }
    }

    /**
     *
     * @webmethod
     */
    public void getOccupationList(Object keha) throws AxisFault {
        if (!Settings.Server_RunOnClientDatabase) {
            Connection conn = null;
            try {
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                if (context != null) {
                    // Hangime andmebaasiühenduse
                    conn = getConnection();

                    // Laeme sõnumi X-Tee päised endale sobivasse andmestruktuuri
                    XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                    // Tuvastame, millist päringu versiooni välja kutsuti
                    String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);

                    // Tuvastame kasutaja
                    UserProfile user = UserProfile.getFromHeaders(xTeePais, conn);

                    // Käivitame päringust vajaliku versiooni
                    SOAPOutputBodyRepresentation result = null;
                    if (ver.equalsIgnoreCase("v1")) {
                    	result = GetOccupationList.V1(context, conn);
                    } else if (ver.equalsIgnoreCase("v2")) {
                        result = GetOccupationList.V2(context, conn, user);
                    } else {
                        // Vale versioon
                        throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                    }

                    // Koostame väljundsõnumi keha
                    org.apache.axis.Message response = context.getResponseMessage();
                    String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                    if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                        response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                    }
                    response.getSOAPEnvelope().removeHeaders();
                    Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                    for (int i = 0; i < headers.size(); ++i) {
                        response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                    }
                    response.getSOAPEnvelope().removeBody();
                    response.getSOAPEnvelope().addBody();

                    if (ver.equalsIgnoreCase("v2")) {
	   	                FileDataSource ds = new FileDataSource(((getOccupationListV2ResponseType)result).responseFile);
	   	                DataHandler d1 = new DataHandler(ds);
	   	                org.apache.axis.attachments.AttachmentPart a1 = new org.apache.axis.attachments.AttachmentPart(d1);
	   	                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
	   	                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
	   	                a1.addMimeHeader("Content-Encoding", "gzip");
	   	                response.addAttachmentPart(a1);
	   	                ((getOccupationListV2ResponseType) result).ametikohadHref = a1.getContentId();
                    }

                    result.addToSOAPBody(response);
                    response.saveChanges();
                } else {
                    throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
                }
            } catch (AxisFault fault) {
            	logger.error(fault.getMessage(), fault);
            	throw fault;
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
                CommonMethods.safeCloseDatabaseConnection(conn);
                conn = null;
            }
        }
    }

    /**
     *
     * @webmethod
     */
    public void getSubdivisionList(Object keha) throws AxisFault {
        if (!Settings.Server_RunOnClientDatabase) {
            Connection conn = null;
            try {
                org.apache.axis.MessageContext context = org.apache.axis.MessageContext.getCurrentContext();
                if (context != null) {
                    // Hangime andmebaasiühenduse
                    conn = getConnection();

                    // Laeme sõnumi X-Tee päised endale sobivasse andmestruktuuri
                    XHeader xTeePais = XHeader.getFromSOAPHeaderAxis(context);

                    // Tuvastame, millist päringu versiooni välja kutsuti
                    String ver = CommonMethods.getXRoadRequestVersion(xTeePais.nimi);

                    // Tuvastame kasutaja
                    UserProfile user = UserProfile.getFromHeaders(xTeePais, conn);

                    // Käivitame päringust vajaliku versiooni
                    SOAPOutputBodyRepresentation result = null;
                    if (ver.equalsIgnoreCase("v1")) {
                    	result = GetSubdivisionList.V1(context, conn);
                    } else if (ver.equalsIgnoreCase("v2")) {
                        result = GetSubdivisionList.V2(context, conn, user);
                    } else {
                        // Vale versioon
                        throw new AxisFault(CommonStructures.VIGA_PARINGU_VERSIOONIS);
                    }

                    // Koostame väljundsõnumi keha
                    org.apache.axis.Message response = context.getResponseMessage();
                    String xroadNamespacePrefix = getXroadNamespacePrefix(context.getRequestMessage());
                    if ((xroadNamespacePrefix != null) && (xroadNamespacePrefix.length() > 0)) {
                        response.getSOAPEnvelope().addNamespaceDeclaration(xroadNamespacePrefix, XTEE_URI);
                    }
                    response.getSOAPEnvelope().removeHeaders();
                    Vector headers = context.getRequestMessage().getSOAPEnvelope().getHeaders();
                    for (int i = 0; i < headers.size(); ++i) {
                        response.getSOAPEnvelope().addHeader((SOAPHeaderElement)headers.get(i));
                    }
                    response.getSOAPEnvelope().removeBody();
                    response.getSOAPEnvelope().addBody();

                    if (ver.equalsIgnoreCase("v2")) {
	   	                FileDataSource ds = new FileDataSource(((getSubdivisionListV2ResponseType)result).responseFile);
	   	                DataHandler d1 = new DataHandler(ds);
	   	                org.apache.axis.attachments.AttachmentPart a1 = new org.apache.axis.attachments.AttachmentPart(d1);
	   	                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
	   	                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
	   	                a1.addMimeHeader("Content-Encoding", "gzip");
	   	                response.addAttachmentPart(a1);
	   	                ((getSubdivisionListV2ResponseType)result).allyksusedHref = a1.getContentId();
                    }

                    result.addToSOAPBody(response);
                    response.saveChanges();
                } else {
                    throw new AxisFault("Süsteemi sisemine viga! Päringu konteksti laadimine ebaõnnestus!");
                }
            } catch (AxisFault fault) {
            	logger.error(fault.getMessage(), fault);
            	throw fault;
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            } finally {
                CommonMethods.safeCloseDatabaseConnection(conn);
                conn = null;
            }
        }
    }

    private Element getXRoadRequestBodyElement(org.apache.axis.MessageContext context, String requestName) {
        Element result = null;
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody b = msg.getSOAPBody();
            NodeList nodes = b.getElementsByTagName(requestName);
            if (nodes.getLength() > 0) {
                Element el = (Element) nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    result = (Element) nodes.item(0);
                }
            }
        } catch (Exception ex) {
            result = null;
        }
        return result;
    }

    private String getXroadNamespacePrefix(org.apache.axis.Message msg) {
        try {
            SOAPEnvelope env = msg.getSOAPEnvelope();
            Iterator prefixes = env.getNamespacePrefixes();
            while (prefixes.hasNext()) {
                String prefix = String.valueOf(prefixes.next());
                if (env.getNamespaceURI(prefix).equalsIgnoreCase(XTEE_URI)) {
                    return prefix;
                }
            }
            return "";
        } catch (Exception ex) {
            return "";
        }
    }

    /**
     * Writes detailed information about a response file to error log.
     * Should be used when creating the response message fails.
     *
     * @param result
     * 		Result of DVK request.
     */
    private void logResponseFileProblems(RequestInternalResult result) {
    	if (result != null) {
	    	String errorMessage = "Failed to create response message based on file: \"" + result.responseFile + "\".";
	    	if (!CommonMethods.isNullOrEmpty(result.responseFile)) {
	    		File responseFile = new File(result.responseFile);
	    		if (!responseFile.exists()) {
	    			errorMessage += " File does not exist!";
	    		} else {
	    			errorMessage += " File size " + String.valueOf(responseFile.length()) + " bytes.";
	    		}
	    	}
	    	logger.error(errorMessage);
    	}
    }
}
