package dhl.users;

import java.sql.Connection;
import java.util.ArrayList;

import org.apache.axis.AxisFault;
import org.apache.commons.lang3.StringUtils;

import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;

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

    public static UserProfile getFromHeaders(XRoadProtocolHeader header, Connection conn) throws AxisFault {
        UserProfile result = new UserProfile();

        // Kontrollime, et vajalik X-Tee päis anti kaasa ja et see sisaldaks
        // infot vähemalt sõnumi saatnud asutuse kohta.
        if (header == null) {
            throw new AxisFault(CommonStructures.VIGA_XTEE_PAISED_PUUDU);
        } else if ((header.getConsumer() == null) || (header.getConsumer().length() == 0)) {
            throw new AxisFault(CommonStructures.VIGA_XTEE_ASUTUSE_PAIS_PUUDU);
        }

        // Laeme asutuste registrist esitatud asutuse koodile vastava
        // asutuse andmed.
        Asutus org = new Asutus();
		int organizationId = 0;
		if (header.getXRoadClient() != null && StringUtils.isNotEmpty(header.getXRoadClient().getSubsystemCode())) {
			org.loadByRegNr(header.getProducer(), conn);
			
			if (org.getRegistrikood2().equals(header.getConsumer())) {
				organizationId = org.getId();
			} else {
				org.clear();
			}
		}
		
		if (organizationId == 0) {
			org.loadByRegNr(header.getConsumer(), conn);
			organizationId = org.getId();
		}
		
		if (organizationId == 0) {
			throw new AxisFault(CommonStructures.VIGA_TUNDMATU_ASUTUS
					.replaceFirst("#1", header.getConsumer()));
		}
        result.setOrganizationCode(header.getConsumer());
        result.setOrganizationID(organizationId);

        // Make sure that current users organization has not been disabled.
        if ( ! org.getDvkSaatmine()) {
            throw new AxisFault(CommonStructures.VIGA_ASUTUS_BLOKEERITUD
                    .replaceFirst("#1", result.getOrganizationCode()));
        }

        // Leiame sõnumi saatnud isiku ID oma isikute registrist
        // Kui isikut registrist leida ei õnnestu, siis pole hullu - enamuse
        // päringute puhul võib päringu teostajaks olla iaikute registris registreerimata isik
        if ((header.getUserId() != null) && (header.getUserId().length() > 2)) {
            //result.setPersonCode(header.isikukood.substring(2));
            result.setPersonCode(header.getUserId());
            result.setPersonID(Isik.getIDByCode(header.getUserId().substring(2), conn));
        } else {
            result.setPersonCode(header.official);
            result.setPersonID(Isik.getIDByCode(header.official, conn));
        }
        /*if (result.getPersonID() <= 0) {
            throw new AxisFault( CommonStructures.VIGA_TUNDMATU_ISIK );
        }*/

        // Leiame antud isiku teadaolevad ametid
        // Kui ametikohta registrist leida ei õnnestu, siis pole hullu - enamuse
        // päringute puhul võib päringu teostajaks olla iaikute registris registreerimata
        // või ametikohale registreerimata isik
        result.setPositions(Ametikoht.getPersonCurrentPositions(result.getPersonID(), result.getOrganizationID(), conn));
        /*if (result.getPositions().size() < 1) {
            throw new AxisFault( CommonStructures.VIGA_AMETIKOHATA_ISIK );
        }*/

        // Leiame antud isiku allüksused
        result.setDivisions(Ametikoht.getPersonCurrentDivisions(result.getPersonID(), result.getOrganizationID(), conn));

        // Leiame antud isikule omistatud rollid
        result.setRoles(Kasutusoigus.getPersonCurrentRoles(result.getPersonID(), result.getOrganizationID(), conn));
        return result;
    }
}
