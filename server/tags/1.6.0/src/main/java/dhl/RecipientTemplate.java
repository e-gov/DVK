package dhl;

import dhl.users.Asutus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class RecipientTemplate {
	
	private static Logger logger = Logger.getLogger(RecipientTemplate.class);
	
    private int m_id;
    private int m_organizationID;
    private int m_positionID;
    private int m_divisionID;
    private String m_personalIdCode;
    private String m_name;
    private String m_organizationName;
    private String m_email;
    private String m_departmentNumber;
    private String m_departmentName;
    private int m_sendingMethodID;
    private String m_conditionXPath;
    private String m_positionShortName;
    private String m_divisionShortName;

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setOrganizationID(int organizationID) {
        this.m_organizationID = organizationID;
    }

    public int getOrganizationID() {
        return m_organizationID;
    }

    public void setPositionID(int positionID) {
        this.m_positionID = positionID;
    }

    public int getPositionID() {
        return m_positionID;
    }

    public void setDivisionID(int divisionID) {
        this.m_divisionID = divisionID;
    }

    public int getDivisionID() {
        return m_divisionID;
    }

    public void setPersonalIdCode(String personalIdCode) {
        this.m_personalIdCode = personalIdCode;
    }

    public String getPersonalIdCode() {
        return m_personalIdCode;
    }

    public void setName(String name) {
        this.m_name = name;
    }

    public String getName() {
        return m_name;
    }

    public void setOrganizationName(String organizationName) {
        this.m_organizationName = organizationName;
    }

    public String getOrganizationName() {
        return m_organizationName;
    }

    public void setEmail(String email) {
        this.m_email = email;
    }

    public String getEmail() {
        return m_email;
    }

    public void setDepartmentNumber(String departmentNumber) {
        this.m_departmentNumber = departmentNumber;
    }

    public String getDepartmentNumber() {
        return m_departmentNumber;
    }

    public void setDepartmentName(String departmentName) {
        this.m_departmentName = departmentName;
    }

    public String getDepartmentName() {
        return m_departmentName;
    }

    public void setSendingMethodID(int sendingMethodID) {
        this.m_sendingMethodID = sendingMethodID;
    }

    public int getSendingMethodID() {
        return m_sendingMethodID;
    }

    public String getConditionXPath() {
        return m_conditionXPath;
    }

    public void setConditionXPath(String conditionXPath) {
        m_conditionXPath = conditionXPath;
    }

    public String getPositionShortName() {
        return this.m_positionShortName;
    }

    public void setPositionShortName(String value) {
        this.m_positionShortName = value;
    }

    public String getDivisionShortName() {
        return this.m_divisionShortName;
    }

    public void setDivisionShortName(String value) {
        this.m_divisionShortName = value;
    }

    public RecipientTemplate() {
        clear();
    }

    public void clear() {
        m_id = 0;
        m_organizationID = 0;
        m_positionID = 0;
        m_divisionID = 0;
        m_personalIdCode = "";
        m_name = "";
        m_organizationName = "";
        m_email = "";
        m_departmentNumber = "";
        m_departmentName = "";
        m_sendingMethodID = 0;
        m_conditionXPath = "";
        m_positionShortName = "";
        m_divisionShortName = "";
    }
    
    public static Document applyToDocument(Document doc, String xmlPath, Connection conn) {
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        XPathExpression expr = null;
        NodeList nodes = null;
        Recipient newRecipient = null;
        RecipientTemplate template = null;
        Element el = null;
        Element el1 = null;
        Element el2 = null;
        org.w3c.dom.Document xmlDoc = doc.getSimplifiedXmlDoc();
        org.w3c.dom.Document xmlDocNS = CommonMethods.xmlDocumentFromFile(xmlPath, true);
        try {
            ArrayList<RecipientTemplate> templates = getList(conn);
            for (int i = 0; i < templates.size(); ++i) {
                try {
                    template = templates.get(i);
                    expr = xpath.compile(template.m_conditionXPath);
                    nodes = (NodeList) expr.evaluate(xmlDoc, XPathConstants.NODESET);
                    if (nodes.getLength() > 0) {
                        newRecipient = new Recipient();
                        newRecipient.setOrganizationID(template.m_organizationID);
                        newRecipient.setPositionID(template.m_positionID);
                        newRecipient.setDivisionID(template.m_divisionID);
                        newRecipient.setPositionShortName(template.m_positionShortName);
                        newRecipient.setDivisionShortName(template.m_divisionShortName);
                        newRecipient.setPersonalIdCode(template.m_personalIdCode);
                        newRecipient.setName(template.m_name);
                        newRecipient.setOrganizationName(template.m_organizationName);
                        newRecipient.setEmail(template.m_email);
                        newRecipient.setDepartmentNumber(template.m_departmentNumber);
                        newRecipient.setDepartmentName(template.m_departmentName);
                        newRecipient.setSendingMethodID(template.m_sendingMethodID);
                        newRecipient.setSendStatusID(CommonStructures.SendStatus_Sending);
                        if ((doc.getSendingList() == null) || (doc.getSendingList().size() < 1)) {
                            Sending s = new Sending();
                            s.setReceivedMethodID(CommonStructures.SendingMethod_XTee);
                            s.setSendStatusID(CommonStructures.SendStatus_Sending);
                            s.setStartDate(new Date());
                            doc.setSendingList(new ArrayList<Sending>());
                            doc.getSendingList().add(s);
                        }
                        if (doc.getSendingList().get(doc.getSendingList().size()-1).getRecipients() == null) {
                            doc.getSendingList().get(doc.getSendingList().size()-1).setRecipients(new ArrayList<Recipient>());
                        }
                        doc.getSendingList().get(doc.getSendingList().size()-1).getRecipients().add(newRecipient);
                        
                        if(doc.getDvkContainerVersion() == 1) {
                        	
                        	// XML konteineri transport ploki tõiendamine
                            nodes = xmlDocNS.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespace, "transport");
                            if (nodes.getLength() > 0) {
                                el = (Element)nodes.item(0);
                                String defaultPrefix = xmlDocNS.lookupPrefix(CommonStructures.DhlNamespace);
                                if (defaultPrefix == null) {
                                    defaultPrefix = "dhl";
                                    int prefixCounter = 0;
                                    while (xmlDocNS.lookupNamespaceURI(defaultPrefix) != null) {
                                        prefixCounter++;
                                        defaultPrefix = "dhl" + String.valueOf(prefixCounter);
                                    }
                                }

                                el1 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":saaja");
                                el.appendChild(el1);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":regnr");
                                Asutus a = new Asutus(newRecipient.getOrganizationID(), conn);
                                el2.setTextContent(a.getRegistrikood());
                                a = null;
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":isikukood");
                                el2.setTextContent(newRecipient.getPersonalIdCode());
                                el1.appendChild(el2);

                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":ametikoha_kood");
                                el2.setTextContent(String.valueOf(newRecipient.getPositionID()));
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":allyksuse_kood");
                                el2.setTextContent(String.valueOf(newRecipient.getDivisionID()));
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":epost");
                                el2.setTextContent(newRecipient.getEmail());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":nimi");
                                el2.setTextContent(newRecipient.getName());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":asutuse_nimi");
                                el2.setTextContent(newRecipient.getOrganizationName());
                                el1.appendChild(el2);

                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":osakonna_kood");
                                el2.setTextContent(newRecipient.getDepartmentNumber());
                                el1.appendChild(el2);
                                	
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespace, defaultPrefix+":osakonna_nimi");
                                el2.setTextContent(newRecipient.getDepartmentName());
                                el1.appendChild(el2);
                                
                            }
                        	
                        } else if(doc.getDvkContainerVersion() == 2) {
                        	
                        	// XML konteineri transport ploki tõiendamine
                            nodes = xmlDocNS.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespaceV2, "transport");
                            if (nodes.getLength() > 0) {
                                el = (Element)nodes.item(0);
                                String defaultPrefix = xmlDocNS.lookupPrefix(CommonStructures.DhlNamespaceV2);
                                if (defaultPrefix == null) {
                                    defaultPrefix = "dhl";
                                    int prefixCounter = 0;
                                    while (xmlDocNS.lookupNamespaceURI(defaultPrefix) != null) {
                                        prefixCounter++;
                                        defaultPrefix = "dhl" + String.valueOf(prefixCounter);
                                    }
                                }

                                el1 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":saaja");
                                el.appendChild(el1);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":regnr");
                                Asutus a = new Asutus(newRecipient.getOrganizationID(), conn);
                                el2.setTextContent(a.getRegistrikood());
                                a = null;
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":isikukood");
                                el2.setTextContent(newRecipient.getPersonalIdCode());
                                el1.appendChild(el2);                                
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":epost");
                                el2.setTextContent(newRecipient.getEmail());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":nimi");
                                el2.setTextContent(newRecipient.getName());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":asutuse_nimi");
                                el2.setTextContent(newRecipient.getOrganizationName());
                                el1.appendChild(el2);
                                
                                // Versioon 2 - uued elemendid
                                // ametikoha_lyhinimetus
                                // allyksuse_lyhinimetus
                                // teadmiseks
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":ametikoha_lyhinimetus");
                                el2.setTextContent(newRecipient.getPositionShortName());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":allyksuse_lyhinimetus");
                                el2.setTextContent(newRecipient.getDivisionShortName());
                                el1.appendChild(el2);
                                
                                el2 = xmlDocNS.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix+":teadmiseks");
                                el2.setTextContent(new Boolean(newRecipient.isCc()).toString());
                                el1.appendChild(el2);
                                
                            }
                        	
                        } else {
                        	logger.error("Unknown document container version: " + doc.getDvkContainerVersion());
                        }
                        
                        
                    }
                } catch (Exception ex) {
                    CommonMethods.logError(ex, "dhl.RecipientTemplate", "applyToDocument");
                }
            }
        } catch (Exception ex1) {
            CommonMethods.logError(ex1, "dhl.RecipientTemplate", "applyToDocument");
        }

        CommonMethods.xmlElementToFile(xmlDocNS.getDocumentElement(), xmlPath);
        xmlDocNS = null;
        xmlDoc = null;
        newRecipient = null;
        nodes = null;
        expr = null;
        xpath = null;
        factory = null;

        return doc;
    }
    
    public static ArrayList<RecipientTemplate> getList(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_RECIPIENTTEMPLATES(?)}");
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet)cs.getObject("RC1");
                ArrayList<RecipientTemplate> result = new ArrayList<RecipientTemplate>();
                while (rs.next()) {
                    RecipientTemplate item = new RecipientTemplate();
                    item.setId(rs.getInt("vastuvotja_mall_id"));
                    item.setOrganizationID(rs.getInt("asutus_id"));
                    item.setPositionID(rs.getInt("ametikoht_id"));
                    item.setDivisionID(rs.getInt("allyksus_id"));
                    item.setPositionShortName(rs.getString("ametikoha_lyhinimetus"));
                    item.setDivisionShortName(rs.getString("allyksuse_lyhinimetus"));
                    item.setPersonalIdCode(rs.getString("isikukood"));
                    item.setName(rs.getString("nimi"));
                    item.setOrganizationName(rs.getString("asutuse_nimi"));
                    item.setEmail(rs.getString("email"));
                    item.setDepartmentNumber(rs.getString("osakonna_nr"));
                    item.setDepartmentName(rs.getString("osakonna_nimi"));
                    item.setSendingMethodID(rs.getInt("saatmisviis_id"));
                    item.setConditionXPath(rs.getString("tingimus_xpath"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.RecipientTemplate", "getList");
            return null;
        }
    }
}
