package dvk.client.businesslayer;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;

public class Classifier {
	private String m_code;
	private int m_id;
	
    public String getCode() {
        return this.m_code;
    }

    public void setCode(String value) {
        this.m_code = value;
    }

    public int getId() {
        return this.m_id;
    }

    public void setId(int value) {
        this.m_id = value;
    }
    
    public Classifier() {
    	clear();
    }
    
    public Classifier(String code, int id) {
    	this.m_code = code;
    	this.m_id = id;
    }
    
    public Classifier(String code, OrgSettings db, Connection dbConnection) {
    	clear();
    	loadFromDB(code, db, dbConnection);
    }
    
    public void clear() {
    	this.m_code = "";
    	this.m_id = 0;
    }
    
    public void loadFromDB(String classifierCode, OrgSettings db, Connection dbConnection) {
        clear();
        try {
        	if (dbConnection != null) {
        		boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	        		dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlClassifier", 1, db, dbConnection);
	                cs.setString(parNr++, classifierCode);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
	                if (rs.next()) {
	                    m_code = rs.getString("dhl_classifier_code");
	                    m_id = rs.getInt("dhl_classifier_id");
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "loadFromDB");
        }
    }
    
    public boolean saveToDB(OrgSettings db, Connection dbConnection) throws Exception {
    	boolean result = false;
    	try {
    		if (dbConnection != null) {
                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Save_DhlClassifier(?,?)}");
                if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())) {
                    cs = dbConnection.prepareCall("{? = call \"Save_DhlClassifier\"(?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }
                cs.setString(parNr++, m_code);
                cs.setInt(parNr++, m_id);
                cs.execute();
                cs.close();
                dbConnection.commit();
                result = true;
            } else {
            	result = false;
            }
        } catch (Exception ex) {
            try { dbConnection.rollback(); }
            catch(SQLException ex1) { CommonMethods.logError(ex1, this.getClass().getName(), "saveToDB"); }
            CommonMethods.logError(ex, this.getClass().getName(), "saveToDB");
            result = false;
        }
        return result;
    }
    
    public static ArrayList<Classifier> getList(OrgSettings db, Connection dbConnection) {
    	ArrayList<Classifier> result = new ArrayList<Classifier>();
    	try {
            if (dbConnection != null) {
        		boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlClassifierList", 0, db, dbConnection);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 0);
	                while (rs.next()) {
	                	Classifier item = new Classifier();
	                    item.setCode(rs.getString("dhl_classifier_code"));
	                    item.setId(rs.getInt("dhl_classifier_id"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.Classifier", "getList");
        }
        return result;
    }
    
    public static void duplicateSettingsToDB(OrgSettings db, Connection dbConnection) throws Exception {
        Classifier classif = new Classifier("STATUS_CANCELED", Settings.Client_StatusCanceled);
        classif.saveToDB(db, dbConnection);
        classif = new Classifier("STATUS_RECEIVED", Settings.Client_StatusReceived);
        classif.saveToDB(db, dbConnection);
        classif = new Classifier("STATUS_SENDING", Settings.Client_StatusSending);
        classif.saveToDB(db, dbConnection);
        classif = new Classifier("STATUS_SENT", Settings.Client_StatusSent);
        classif.saveToDB(db, dbConnection);
        classif = new Classifier("STATUS_WAITING", Settings.Client_StatusWaiting);
        classif.saveToDB(db, dbConnection);
    }
}
