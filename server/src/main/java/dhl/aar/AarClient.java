package dhl.aar;

import dhl.aar.iostructures.AarAmetikohaTaitmine;
import dhl.aar.iostructures.AarAmetikoht;
import dhl.aar.iostructures.AarAsutus;
import dhl.aar.iostructures.AarIsik;
import dhl.aar.iostructures.AarOigus;
import dhl.aar.iostructures.asutusedRequestType;
import dhl.aar.iostructures.ametikohadRequestType;
import dhl.aar.iostructures.isikudRequestType;
import dhl.aar.iostructures.taitmisedRequestType;
import dhl.iostructures.XHeader;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;

import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAP11Constants;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axis2.AxisFault;
import org.apache.axis2.Constants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.OperationClient;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.transport.http.HTTPConstants;
import org.apache.axis2.wsdl.WSDLConstants;
import org.apache.commons.httpclient.Header;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Ühtse õiguste allsüsteemi klient.
 */
public class AarClient {
    private String orgCode;
    private String personCode;
    private EndpointReference sevrviceEndpoint;
    private ServiceClient serviceClient;
    static Logger logger = LogManager.getLogger(AarClient.class.getName());
    public AarClient(String serverURL, String requestOrgCode, String requestPersonCode) throws Exception {
        this.orgCode = requestOrgCode;
        this.personCode = requestPersonCode;

        sevrviceEndpoint = new EndpointReference(serverURL);
        Options options = new Options();
        options.setTo(sevrviceEndpoint);
        options.setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        options.setSoapVersionURI(SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        options.setTimeOutInMilliSeconds(30000);
        options.setProperty(HTTPConstants.HTTP_PROTOCOL_VERSION, HTTPConstants.HEADER_PROTOCOL_11);
        options.setProperty(HTTPConstants.CHUNKED, Boolean.FALSE);
        ArrayList<Header> customHeaders = new ArrayList<Header>();
        customHeaders.add(new Header("Connection", "close"));
        customHeaders.add(new Header("Cache-control", "no-cache"));
        customHeaders.add(new Header("Pragma", "no-cache"));
        options.setProperty(HTTPConstants.HTTP_HEADERS, customHeaders);
        options.setAction("http://producers.aar.xtee.riik.ee/producer/aar");
        serviceClient = new ServiceClient();
        serviceClient.setOptions(options);
    }

    public ArrayList<AarAsutus> asutusedRequest(ArrayList<String> orgCodes, ArrayList<Integer> orgIDs) throws Exception {
        // Manuse ID
        String attachmentName = String.valueOf((new Date()).getTime());

        // Päringu nimi
        String requestName = "aar.asutused.v1";

        // Päringu ID koostamine
        String queryId = "aar" + orgCode + String.valueOf((new Date()).getTime());
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele Asutused(xtee teenus:"+requestName+"). Asutusest:" + orgCode 
        		+" isikukood:" + this.personCode);
        // Saadetava sõnumi päisesse kantavad parameetrid
        XHeader header = new XHeader(
                orgCode, "aar", personCode, queryId, requestName, "",
                CommonMethods.personalIDCodeHasCountryCode(this.personCode) ? this.personCode : "EE" + this.personCode);

        // Koodtame päringu faili
        String requestFile = asutusedRequestType.createRequestFile(orgCodes, orgIDs, false);

        // SOAP sõnumi saatmine
        serviceClient.getOptions().setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        OperationClient mepClient = serviceClient.createClient(ServiceClient.ANON_OUT_IN_OP);
        MessageContext requestMsg = new MessageContext();
        FileDataSource fileDataSource = new FileDataSource(requestFile);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        requestMsg.addAttachment(attachmentName, dataHandler);

        // Koostame SOAP sõnumi keha
        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
        SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace omNs = fac.createOMNamespace("http://producers.aar.xtee.riik.ee/producer/aar", "aar");
        env.declareNamespace(omNs);
        OMElement elRequest = fac.createOMElement("asutused", omNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement elAsutused = fac.createOMElement("asutused", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        elAsutused.addAttribute(attID);
        elKeha.addChild(elAsutused);
        elRequest.addChild(elKeha);
        env.getBody().addChild(elRequest);
        env = header.appendToSOAPHeader(env, fac);
        requestMsg.setEnvelope(env);

        // Käivitame päringu
        mepClient.addMessageContext(requestMsg);
        mepClient.execute(true);
        MessageContext response = mepClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);

        // Vastuse töötlemine
        ArrayList<AarAsutus> orgs = null;
        DataHandler dh = response.getAttachment("vastus_xml");
        if (dh != null) {
            DataSource ds = dh.getDataSource();
            String attachmentFile = CommonMethods.createPipelineFile(1111);
            String md5Hash = CommonMethods.getDataFromDataSource(ds, "base64", attachmentFile, false);
            if (md5Hash == null) {
                throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            // Laeme andmed XML failist andmestruktuuridesse
            orgs = AarAsutus.getListFromXML(attachmentFile);

            // Kustutame päringu ja vastuse failid
            (new File(attachmentFile)).delete();
        } else {
            throw new AxisFault("Õiguste kesksüsteemi vastus ei sisaldanud vastuse faili!");
        }

        return orgs;
    }

    public ArrayList<AarAmetikoht> ametikohadRequest() throws Exception {
        // Manuse ID
        String attachmentName = String.valueOf((new Date()).getTime());

        // Päringu nimi
        String requestName = "aar.ametikohad.v1";
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele Ametikohad(xtee teenus:"+requestName+"). Asutusest:" + orgCode 
        		+" isikukood:" + this.personCode);
        // Päringu ID koostamine
        String queryId = "aar" + orgCode + String.valueOf((new Date()).getTime());

        // Saadetava sõnumi päisesse kantavad parameetrid
        XHeader header = new XHeader(
                orgCode, "aar", personCode, queryId, requestName, "",
                CommonMethods.personalIDCodeHasCountryCode(this.personCode) ? this.personCode : "EE" + this.personCode);

        // Koodtame päringu faili
        String requestFile = ametikohadRequestType.createRequestFile();

        // SOAP sõnumi saatmine
        serviceClient.getOptions().setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        OperationClient mepClient = serviceClient.createClient(ServiceClient.ANON_OUT_IN_OP);
        MessageContext requestMsg = new MessageContext();
        FileDataSource fileDataSource = new FileDataSource(requestFile);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        requestMsg.addAttachment(attachmentName, dataHandler);

        // Koostame SOAP sõnumi keha
        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
        SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace omNs = fac.createOMNamespace("http://producers.aar.xtee.riik.ee/producer/aar", "aar");
        env.declareNamespace(omNs);
        OMElement elRequest = fac.createOMElement("ametikohad", omNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement elMain = fac.createOMElement("ametikohad", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        elMain.addAttribute(attID);
        elKeha.addChild(elMain);
        elRequest.addChild(elKeha);
        env.getBody().addChild(elRequest);
        env = header.appendToSOAPHeader(env, fac);
        requestMsg.setEnvelope(env);

        // Käivitame päringu
        mepClient.addMessageContext(requestMsg);
        mepClient.execute(true);
        MessageContext response = mepClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);

        // Vastuse töötlemine
        ArrayList<AarAmetikoht> jobs = null;
        DataHandler dh = response.getAttachment("vastus_xml");
        if (dh != null) {
            DataSource ds = dh.getDataSource();

            String attachmentFile = CommonMethods.createPipelineFile(0);
            String md5Hash = CommonMethods.getDataFromDataSource(ds, "base64", attachmentFile, false);
            if (md5Hash == null) {
                throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            jobs = AarAmetikoht.getListFromXML(attachmentFile);

            // Kustutame päringu ja vastuse failid
            (new File(attachmentFile)).delete();
        } else {
            throw new AxisFault("Õiguste kesksüsteemi vastus ei sisaldanud vastuse faili!");
        }
        return jobs;
    }

    public ArrayList<AarIsik> isikudRequest() throws Exception {
        // Manuse ID
        String attachmentName = String.valueOf((new Date()).getTime());

        // Päringu nimi
        String requestName = "aar.isikud.v1";
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele Isikud(xtee teenus:"+requestName+"). Asutusest:" + orgCode 
        		+" isikukood:" + personCode);
        // Päringu ID koostamine
        String queryId = "aar" + orgCode + String.valueOf((new Date()).getTime());

        // Saadetava sõnumi päisesse kantavad parameetrid
        XHeader header = new XHeader(
                orgCode, "aar", personCode, queryId, requestName, "",
                CommonMethods.personalIDCodeHasCountryCode(this.personCode) ? this.personCode : "EE" + this.personCode);

        // Koodtame päringu faili
        String requestFile = isikudRequestType.createRequestFile();

        // SOAP sõnumi saatmine
        serviceClient.getOptions().setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        OperationClient mepClient = serviceClient.createClient(ServiceClient.ANON_OUT_IN_OP);
        MessageContext requestMsg = new MessageContext();
        FileDataSource fileDataSource = new FileDataSource(requestFile);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        requestMsg.addAttachment(attachmentName, dataHandler);

        // Koostame SOAP sõnumi keha
        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
        SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace omNs = fac.createOMNamespace("http://producers.aar.xtee.riik.ee/producer/aar", "aar");
        env.declareNamespace(omNs);
        OMElement elRequest = fac.createOMElement("isikud", omNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement elMain = fac.createOMElement("isikud", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        elMain.addAttribute(attID);
        elKeha.addChild(elMain);
        elRequest.addChild(elKeha);
        env.getBody().addChild(elRequest);
        env = header.appendToSOAPHeader(env, fac);
        requestMsg.setEnvelope(env);

        // Käivitame päringu
        mepClient.addMessageContext(requestMsg);
        mepClient.execute(true);
        MessageContext response = mepClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);

        // Vastuse töötlemine
        ArrayList<AarIsik> people = null;
        DataHandler dh = response.getAttachment("vastus_xml");
        if (dh != null) {
            DataSource ds = dh.getDataSource();

            String attachmentFile = CommonMethods.createPipelineFile(0);
            String md5Hash = CommonMethods.getDataFromDataSource(ds, "base64", attachmentFile, false);
            if (md5Hash == null) {
                throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            people = AarIsik.getListFromXML(attachmentFile);

            // Kustutame päringu ja vastuse failid
            (new File(attachmentFile)).delete();
        } else {
            throw new AxisFault("Õiguste kesksüsteemi vastus ei sisaldanud vastuse faili!");
        }
        return people;
    }

    public ArrayList<AarAmetikohaTaitmine> taitmisedRequest() throws Exception {
        // Manuse ID
        String attachmentName = String.valueOf((new Date()).getTime());

        // Päringu nimi
        String requestName = "aar.taitmised.v1";
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele Taitmised(xtee teenus:"+requestName+"). Asutusest:" + orgCode 
        		+" isikukood:" + personCode);
        // Päringu ID koostamine
        String queryId = "aar" + orgCode + String.valueOf((new Date()).getTime());

        // Saadetava sõnumi päisesse kantavad parameetrid
        XHeader header = new XHeader(
                orgCode, "aar", personCode, queryId, requestName, "",
                CommonMethods.personalIDCodeHasCountryCode(this.personCode) ? this.personCode : "EE" + this.personCode);

        // Koodtame päringu faili
        String requestFile = taitmisedRequestType.createRequestFile();

        // SOAP sõnumi saatmine
        serviceClient.getOptions().setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        OperationClient mepClient = serviceClient.createClient(ServiceClient.ANON_OUT_IN_OP);
        MessageContext requestMsg = new MessageContext();
        FileDataSource fileDataSource = new FileDataSource(requestFile);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        requestMsg.addAttachment(attachmentName, dataHandler);

        // Koostame SOAP sõnumi keha
        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
        SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace omNs = fac.createOMNamespace("http://producers.aar.xtee.riik.ee/producer/aar", "aar");
        env.declareNamespace(omNs);
        OMElement elRequest = fac.createOMElement("taitmised", omNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement elMain = fac.createOMElement("taitmised", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        elMain.addAttribute(attID);
        elKeha.addChild(elMain);
        elRequest.addChild(elKeha);
        env.getBody().addChild(elRequest);
        env = header.appendToSOAPHeader(env, fac);
        requestMsg.setEnvelope(env);

        // Käivitame päringu
        mepClient.addMessageContext(requestMsg);
        mepClient.execute(true);
        MessageContext response = mepClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);

        // Vastuse töötlemine
        ArrayList<AarAmetikohaTaitmine> result = null;
        DataHandler dh = response.getAttachment("vastus_xml");
        if (dh != null) {
            DataSource ds = dh.getDataSource();

            String attachmentFile = CommonMethods.createPipelineFile(0);
            String md5Hash = CommonMethods.getDataFromDataSource(ds, "base64", attachmentFile, false);
            if (md5Hash == null) {
                throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            result = AarAmetikohaTaitmine.getListFromXML(attachmentFile);

            // Kustutame päringu ja vastuse failid
            (new File(attachmentFile)).delete();
        } else {
            throw new AxisFault("Õiguste kesksüsteemi vastus ei sisaldanud vastuse faili!");
        }
        return result;
    }

    public ArrayList<AarOigus> oigusedRequest(String queryOrgCode, int jobID, String queryPersonCode) throws Exception {
        // Päringu nimi
        String requestName = "aar.oigused.v1";
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele oigused(xtee teenus:"+requestName+"). Asutusest:" + orgCode 
        		+" isikukood:" + personCode);
        // Päringu ID koostamine
        String queryId = "aar" + this.orgCode + String.valueOf((new Date()).getTime());

        // Saadetava sõnumi päisesse kantavad parameetrid
        XHeader header = new XHeader(
                this.orgCode, "aar", this.personCode, queryId, requestName, "",
                CommonMethods.personalIDCodeHasCountryCode(this.personCode) ? this.personCode : "EE" + this.personCode);

        // SOAP sõnumi saatmine
        serviceClient.getOptions().setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_FALSE);
        OperationClient mepClient = serviceClient.createClient(ServiceClient.ANON_OUT_IN_OP);
        MessageContext requestMsg = new MessageContext();

        // Koostame SOAP sõnumi keha
        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
        SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace omNs = fac.createOMNamespace("http://producers.aar.xtee.riik.ee/producer/aar", "aar");
        env.declareNamespace(omNs);
        OMElement elRequest = fac.createOMElement("oigused", omNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement elMain = fac.createOMElement("oigused", null);
        if ((queryOrgCode != null) && !queryOrgCode.equalsIgnoreCase("")) {
            OMElement elRegKood = fac.createOMElement("registrikood", null);
            elRegKood.setText(queryOrgCode);
            elMain.addChild(elRegKood);
        }
        if (jobID > 0) {
            OMElement elAmetID = fac.createOMElement("ametikohtId", null);
            elAmetID.setText(String.valueOf(jobID));
            elMain.addChild(elAmetID);
        }
        if ((queryPersonCode != null) && !queryPersonCode.equalsIgnoreCase("")) {
            OMElement elIsikukood = fac.createOMElement("isikukood", null);
            elIsikukood.setText(queryPersonCode);
            elMain.addChild(elIsikukood);
        }
        elKeha.addChild(elMain);
        elRequest.addChild(elKeha);
        env.getBody().addChild(elRequest);
        env = header.appendToSOAPHeader(env, fac);
        requestMsg.setEnvelope(env);

        // Käivitame päringu
        mepClient.addMessageContext(requestMsg);
        mepClient.execute(true);
        MessageContext response = mepClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);

        // Vastuse töötlemine
        ArrayList<AarOigus> result = AarOigus.getListFromSOAP(response.getEnvelope().getBody());

        return result;
    }
}
