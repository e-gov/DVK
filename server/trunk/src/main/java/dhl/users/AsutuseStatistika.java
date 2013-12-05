package dhl.users;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

import org.apache.log4j.Logger;

public class AsutuseStatistika {

    private static Logger logger = Logger.getLogger(AsutuseStatistika.class);

    private int m_vastuvotmataDokumente;
    private int m_vahetatudDokumente;

    public AsutuseStatistika() {
        m_vastuvotmataDokumente = 0;
        m_vahetatudDokumente = 0;
    }

    public int getVastuvotmataDokumente() {
        return m_vastuvotmataDokumente;
    }

    public void setVastuvotmataDokumente(int value) {
        m_vastuvotmataDokumente = value;
    }

    public int getVahetatudDokumente() {
        return m_vahetatudDokumente;
    }

    public void setVahetatudDokumente(int value) {
        m_vahetatudDokumente = value;
    }

    public static AsutuseStatistika getByOrgID(int orgID, Connection conn) throws Exception {

        logger.debug("AsutuseStatistika.getByOrgID invoked. Parameters: ");
        logger.debug("orgID: " + orgID);

        AsutuseStatistika stat = null;
        if (conn != null) {
            CallableStatement cs = conn.prepareCall("{call GET_ASUTUSSTAT(?,?,?)}");
            cs.setInt("asutus_id", orgID);
            cs.registerOutParameter("vastuvotmata_dokumente", Types.INTEGER);
            cs.registerOutParameter("vahetatud_dokumente", Types.INTEGER);
            cs.executeUpdate();
            stat = new AsutuseStatistika();
            stat.setVastuvotmataDokumente(cs.getInt("vastuvotmata_dokumente"));
            stat.setVahetatudDokumente(cs.getInt("vahetatud_dokumente"));
            cs.close();
            return stat;
        } else {
            throw new Exception("DB Connection is NULL!");
        }
    }

    public static AsutuseStatistika getBySubdivisionId(int orgId, int subdivisionId, Connection conn) throws Exception {
        AsutuseStatistika stat = null;
        if (conn != null) {
            CallableStatement cs = conn.prepareCall("{call GET_ALLYKSUSSTAT(?,?,?,?)}");
            cs.setInt("asutus_id", orgId);
            cs.setInt("allyksus_id", subdivisionId);
            cs.registerOutParameter("vastuvotmata_dokumente", Types.INTEGER);
            cs.registerOutParameter("vahetatud_dokumente", Types.INTEGER);
            cs.executeUpdate();
            stat = new AsutuseStatistika();
            stat.setVastuvotmataDokumente(cs.getInt("vastuvotmata_dokumente"));
            stat.setVahetatudDokumente(cs.getInt("vahetatud_dokumente"));
            cs.close();
            return stat;
        } else {
            throw new Exception("DB Connection is NULL!");
        }
    }

    public static AsutuseStatistika getByOccupationId(int orgId, int occupationId, Connection conn) throws Exception {
        AsutuseStatistika stat = null;
        if (conn != null) {
            CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHTSTAT(?,?,?,?)}");
            cs.setInt("asutus_id", orgId);
            cs.setInt("ametikoht_id", occupationId);
            cs.registerOutParameter("vastuvotmata_dokumente", Types.INTEGER);
            cs.registerOutParameter("vahetatud_dokumente", Types.INTEGER);
            cs.executeUpdate();
            stat = new AsutuseStatistika();
            stat.setVastuvotmataDokumente(cs.getInt("vastuvotmata_dokumente"));
            stat.setVahetatudDokumente(cs.getInt("vahetatud_dokumente"));
            cs.close();
            return stat;
        } else {
            throw new Exception("DB Connection is NULL!");
        }
    }
}
