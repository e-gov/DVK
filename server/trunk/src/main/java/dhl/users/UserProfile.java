package dhl.users;

import dvk.core.CommonStructures;
import dhl.iostructures.XHeader;
import java.sql.Connection;
import java.util.ArrayList;
import org.apache.axis.AxisFault;

public class UserProfile {
    private int m_organizationID;
    private String m_organizationCode;
    private int m_personID;
    private String m_personCode;
    private ArrayList<String> m_roles;
    private ArrayList<Integer> m_positions;
    private ArrayList<Integer> m_divisions;

    public void setOrganizationID(int organizationID) {
        this.m_organizationID = organizationID;
    }

    public int getOrganizationID() {
        return m_organizationID;
    }

    public void setOrganizationCode(String organizationCode) {
        this.m_organizationCode = organizationCode;
    }

    public String getOrganizationCode() {
        return m_organizationCode;
    }

    public void setPersonID(int personID) {
        this.m_personID = personID;
    }

    public int getPersonID() {
        return m_personID;
    }

    public void setPersonCode(String personCode) {
        this.m_personCode = personCode;
    }

    public String getPersonCode() {
        return m_personCode;
    }

    public void setRoles(ArrayList<String> roles) {
        this.m_roles = roles;
    }

    public ArrayList<String> getRoles() {
        return m_roles;
    }

    public void setPositions(ArrayList<Integer> positions) {
        this.m_positions = positions;
    }

    public ArrayList<Integer> getPositions() {
        return m_positions;
    }

    public void setDivisions(ArrayList<Integer> divisions) {
        this.m_divisions = divisions;
    }

    public ArrayList<Integer> getDivisions() {
        return m_divisions;
    }

    public UserProfile() {
        clear();
    }

    public void clear() {
        m_organizationID = 0;
        m_organizationCode = "";
        m_personID = 0;
        m_personCode = "";
        m_roles = new ArrayList<String>();
        m_positions = new ArrayList<Integer>();
        m_divisions = new ArrayList<Integer>();
    }

    public static UserProfile getFromHeaders(XHeader header, Connection conn) throws AxisFault {
        UserProfile result = new UserProfile();

        // Kontrollime, et vajalik X-Tee p�is anti kaasa ja et see sisaldaks
        // infot v�hemalt s�numi saatnud asutuse kohta.
        if (header == null) {
            throw new AxisFault(CommonStructures.VIGA_XTEE_PAISED_PUUDU);
        } else if ((header.asutus == null) || (header.asutus.length() == 0)) {
            throw new AxisFault(CommonStructures.VIGA_XTEE_ASUTUSE_PAIS_PUUDU);
        }

        // Laeme asutuste registrist esitatud asutuse koodile vastava asutuse andmed.
        result.setOrganizationCode(header.asutus);
        result.setOrganizationID(Asutus.getIDByRegNr(header.asutus, false, conn));
        if (result.getOrganizationID() <= 0) {
            throw new AxisFault(CommonStructures.VIGA_TUNDMATU_ASUTUS.replaceFirst("#1", header.asutus));
        }

        // Leiame s�numi saatnud isiku ID oma isikute registrist
        // Kui isikut registrist leida ei �nnestu, siis pole hullu - enamuse
        // p�ringute puhul v�ib p�ringu teostajaks olla iaikute registris registreerimata isik
        if ((header.isikukood != null) && (header.isikukood.length() > 2)) {
            result.setPersonCode(header.isikukood.substring(2));
            result.setPersonID(Isik.getIDByCode(header.isikukood.substring(2), conn));
        } else {
            result.setPersonCode(header.ametnik);
            result.setPersonID(Isik.getIDByCode(header.ametnik, conn));
        }
        /*if (result.getPersonID() <= 0) {
            throw new AxisFault( CommonStructures.VIGA_TUNDMATU_ISIK );
        }*/

        // Leiame antud isiku teadaolevad ametid
        // Kui ametikohta registrist leida ei �nnestu, siis pole hullu - enamuse
        // p�ringute puhul v�ib p�ringu teostajaks olla iaikute registris registreerimata
        // v�i ametikohale registreerimata isik
        result.setPositions(Ametikoht.getPersonCurrentPositions(result.getPersonID(), result.getOrganizationID(), conn));
        /*if (result.getPositions().size() < 1) {
            throw new AxisFault( CommonStructures.VIGA_AMETIKOHATA_ISIK );
        }*/

        // Leiame antud isiku all�ksused
        result.setDivisions(Ametikoht.getPersonCurrentDivisions(result.getPersonID(), result.getOrganizationID(), conn));

        // Leiame antud isikule omistatud rollid
        result.setRoles(Kasutusoigus.getPersonCurrentRoles(result.getPersonID(), result.getOrganizationID(), conn));
        return result;
    }
}
