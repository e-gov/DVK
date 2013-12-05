package dhl;

import dhl.iostructures.XHeader;
import dhl.users.Allyksus;
import dhl.users.Ametikoht;
import dhl.users.Asutus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axis.AxisFault;

public class Proxy {
    private int m_id;
    private int m_sendingID;
    private int m_organizationID;
    private int m_positionID;
    private int m_divisionID;
    private String m_personalIdCode;
    private String m_name;
    private String m_organizationName;
    private String m_email;
    private String m_departmentNumber;
    private String m_departmentName;
    private String m_positionShortName;
    private String m_divisionShortName;

    public Proxy() {
        clear();
    }

    public Proxy(
            int id,
            int sendingID,
            int organizationID,
            int positionID,
            int divisionID,
            String personalIdCode,
            String name,
            String organizationName,
            String email,
            String departmentNumber,
            String departmentName,
            String positionShortName,
            String divisionShortName) {
        m_id = id;
        m_sendingID = sendingID;
        m_organizationID = organizationID;
        m_positionID = positionID;
        m_divisionID = divisionID;
        m_name = name;
        m_organizationName = organizationName;
        m_email = email;
        m_departmentNumber = departmentNumber;
        m_departmentName = departmentName;
        m_personalIdCode = personalIdCode;
        m_positionShortName = positionShortName;
        m_divisionShortName = divisionShortName;
    }

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setSendingID(int sendingID) {
        this.m_sendingID = sendingID;
    }

    public int getSendingID() {
        return m_sendingID;
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

    public void clear() {
        m_id = 0;
        m_sendingID = 0;
        m_organizationID = 0;
        m_positionID = 0;
        m_divisionID = 0;
        m_personalIdCode = "";
        m_name = "";
        m_organizationName = "";
        m_email = "";
        m_departmentNumber = "";
        m_departmentName = "";
        m_positionShortName = "";
        m_divisionShortName = "";
    }

    public void LoadBySendingID(int sendingID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_PROXYBYSENDINGID(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("sending_id", sendingID);
                cs.registerOutParameter("proxy_id", Types.INTEGER);
                cs.registerOutParameter("organization_id", Types.INTEGER);
                cs.registerOutParameter("position_id", Types.INTEGER);
                cs.registerOutParameter("division_id", Types.INTEGER);
                cs.registerOutParameter("personal_id_code", Types.VARCHAR);
                cs.registerOutParameter("name", Types.VARCHAR);
                cs.registerOutParameter("organization_name", Types.VARCHAR);
                cs.registerOutParameter("email", Types.VARCHAR);
                cs.registerOutParameter("department_nr", Types.VARCHAR);
                cs.registerOutParameter("department_name", Types.VARCHAR);
                cs.registerOutParameter("position_short_name", Types.VARCHAR);
                cs.registerOutParameter("division_short_name", Types.VARCHAR);
                cs.executeUpdate();
                m_id = cs.getInt("proxy_id");
                m_sendingID = sendingID;
                m_organizationID = cs.getInt("organization_id");
                m_positionID = cs.getInt("position_id");
                m_divisionID = cs.getInt("division_id");
                m_personalIdCode = cs.getString("personal_id_code");
                m_name = cs.getString("name");
                m_organizationName = cs.getString("organization_name");
                m_email = cs.getString("email");
                m_departmentNumber = cs.getString("department_nr");
                m_departmentName = cs.getString("department_name");
                m_positionShortName = cs.getString("position_short_name");
                m_divisionShortName = cs.getString("division_short_name");
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadBySendingID");
            clear();
        }
    }

    public int addToDB(Connection conn, XHeader xTeePais) throws IllegalArgumentException, SQLException {
        if (conn != null) {
            CallableStatement cs = conn.prepareCall("{call ADD_PROXY(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.registerOutParameter("proxy_id", Types.INTEGER);
            cs.setInt("sending_id", m_sendingID);
            cs.setInt("organization_id", m_organizationID);
            cs.setInt("position_id", m_positionID);
            cs.setInt("division_id", m_divisionID);
            cs.setString("personal_id_code", m_personalIdCode);
            cs.setString("email", m_email);
            cs.setString("name", m_name);
            cs.setString("organization_name", m_organizationName);
            cs.setString("department_nr", m_departmentNumber);
            cs.setString("department_name", m_departmentName);
            cs.setString("position_short_name", m_positionShortName);
            cs.setString("division_short_name", m_divisionShortName);

            if (xTeePais != null) {
                cs.setString("xtee_isikukood", xTeePais.isikukood);
                cs.setString("xtee_asutus", xTeePais.asutus);
            } else {
                cs.setString("xtee_isikukood", null);
                cs.setString("xtee_asutus", null);
            }

            cs.executeUpdate();
            m_id = cs.getInt("proxy_id");
            cs.close();
            return m_id;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }

    public static Proxy fromXML(XMLStreamReader xmlReader, Connection conn) throws AxisFault {
        try {
            Proxy result = new Proxy();

            // Jätame järgnevas väärtustamata järgmised andmeväljad:
            //   ID - sest see saab väärtuse andmebaasi salvestamisel
            //   SendingID - sest see saab väärtuse alles siis, kuin saatmisinfo on
            //       andmebaasi salvatstaud
            int orgID = 0;
            int positionID = 0;
            int divisionID = 0;
            String orgCode = "";
            String occupationShortName = "";
            String subdivisionShortName = "";

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase("vahendaja") && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud vahendaja elemendi lõppu, siis katkestame tsükli
                        break;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("regnr") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame vahendaja asutuse
                            orgCode = xmlReader.getText().trim();
                            orgID = Asutus.getIDByRegNr(orgCode, false, conn);
                            result.setOrganizationID(orgID);

                            // Vahendaja asutuse andmeid teistest serveritest otsima ei lähe,
                            // kuna see peaks kindlasti antud serveris seadistatud olema.
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoha_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame vahendaja ametikoha
                            String positionIDText = xmlReader.getText().trim();
                            if ((positionIDText != null) && (positionIDText.length() > 0)) {
                                try {
                                    positionID = Integer.parseInt(positionIDText);
                                    result.setPositionID(positionID);
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.Proxy", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoha_lyhinimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            occupationShortName = xmlReader.getText().trim();
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("allyksuse_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame vahendaja allüksuse
                            String divisionIDText = xmlReader.getText().trim();
                            if ((divisionIDText != null) && (divisionIDText.length() > 0)) {
                                try {
                                    divisionID = Integer.parseInt(divisionIDText);
                                    result.setDivisionID(divisionID);
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.Proxy", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("allyksuse_lyhinimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            subdivisionShortName = xmlReader.getText().trim();
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("epost") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setEmail(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setName(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutuse_nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setOrganizationName(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("isikukood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setPersonalIdCode(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("osakonna_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setDepartmentNumber(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("osakonna_nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setDepartmentName(xmlReader.getText().trim());
                        }
                    }
                }
            }

            // Kui vahendajaks märgitud asutus ei kuulu DVK kasutajate hulka,
            // siis teavitame sellest kasutajat.
            if (orgID < 1) {
                throw new AxisFault(CommonStructures.VIGA_TUNDMATU_VAHENDAJA_ASUTUS.replaceFirst("#1", orgCode));
            }

            // Tuvastame osakonna lühinime järgi osakonna ID
            // Seda ei saa enne teha, kui kogu XML on läbi käidud, kuna ametikoha
            // leidmiseks peab lisaks lühinimele tedma ka asutuse ID-d.
            if ((occupationShortName != null) && (occupationShortName.length() > 0)) {
                int occupationId = Ametikoht.getIdByShortName(orgID, occupationShortName, conn);
                if (occupationId > 0) {
                    result.setPositionID(occupationId);
                }
            }

            // Tuvastame allüksuse lühinime järgi allüksuse ID
            // Seda ei saa enne teha, kui kogu XML on läbi käidud, kuna allüksuse
            // leidmiseks peab lisaks lühinimele tedma ka asutuse ID-d.
            if ((subdivisionShortName != null) && (subdivisionShortName.length() > 0)) {
                int subdivisionId = Allyksus.getIdByShortName(orgID, subdivisionShortName, conn);
                if (subdivisionId > 0) {
                    result.setDivisionID(subdivisionId);
                }
            }

            return result;
        } catch (XMLStreamException ex) {
            CommonMethods.logError(ex, "dhl.Proxy", "fromXML");
            throw new AxisFault("Exception parsing DVK message proxy section: " + ex.getMessage());
        }
    }
}
