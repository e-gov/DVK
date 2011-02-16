package dhl;

import dhl.iostructures.FragmentationResult;
import dhl.iostructures.XHeader;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import org.apache.axis.AxisFault;

public class DocumentFragment {
    private int m_id;
    private boolean m_isIncoming;
    private int m_organizationID;
    private String m_deliverySessionID;
    private int m_fragmentNr;
    private int m_fragmentCount;
    private Date m_dateCreated;
    private String m_fileName;
    
    public void setID(int id) {
        this.m_id = id;
    }

    public int getID() {
        return m_id;
    }

    public boolean getIsIncoming() {
        return m_isIncoming;
    }

    public void setIsIncoming(boolean value) {
        m_isIncoming = value;
    }

    public void setOrganizationID(int organizationID) {
        this.m_organizationID = organizationID;
    }

    public int getOrganizationID() {
        return m_organizationID;
    }

    public void setDeliverySessionID(String deliverySessionID) {
        this.m_deliverySessionID = deliverySessionID;
    }

    public String getDeliverySessionID() {
        return m_deliverySessionID;
    }

    public void setFragmentNr(int fragmentNr) {
        this.m_fragmentNr = fragmentNr;
    }

    public int getFragmentNr() {
        return m_fragmentNr;
    }

    public void setFragmentCount(int fragmentCount) {
        this.m_fragmentCount = fragmentCount;
    }

    public int getFragmentCount() {
        return m_fragmentCount;
    }
    
    public void setDateCreated(Date dateCreated) {
        this.m_dateCreated = dateCreated;
    }

    public Date getDateCreated() {
        return m_dateCreated;
    }

    public void setFileName(String fileName) {
        this.m_fileName = fileName;
    }

    public String getFileName() {
        return m_fileName;
    }
    
    public DocumentFragment() {
        clear();
    }
    
    public DocumentFragment(int orgID, String deliverySessionID, int fragmentNr, Connection conn) throws AxisFault {
        clear();
        loadFromDB (orgID, deliverySessionID, fragmentNr, conn);
    }
    
    public void clear() {
        m_id = 0;
        m_isIncoming = true;
        m_organizationID = 0;
        m_deliverySessionID = "";
        m_fragmentNr = -1;
        m_fragmentCount = 0;
        m_dateCreated = new Date();
        m_fileName = "";
    }
    
    public static int getNextID(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_NEXTFRAGMENTID(?)}");
                cs.registerOutParameter("fragment_id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("fragment_id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.DocumentFragment", "getNextID");
            return 0;
        }
    }
    
    public void loadFromDB (int orgID, String deliverySessionID, int fragmentNr, Connection conn) throws AxisFault {
        try {
            Calendar cal = Calendar.getInstance();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT fragment_id, sissetulev, asutus_id, edastus_id, fragment_nr, fragmente_kokku, loodud, sisu FROM dokumendi_fragment WHERE asutus_id="+ String.valueOf(orgID) +" AND edastus_id='"+ deliverySessionID.replace("'","''") +"' AND fragment_nr=" + String.valueOf(fragmentNr));
            if (rs.next()) {
                m_id = rs.getInt("fragment_id");
                m_isIncoming = (rs.getInt("sissetulev") > 0);
                m_organizationID = rs.getInt("asutus_id");
                m_deliverySessionID = rs.getString("edastus_id").trim();
                m_fragmentNr = rs.getInt("fragment_nr");
                m_fragmentCount = rs.getInt("fragmente_kokku");
                m_dateCreated = rs.getTimestamp("loodud", cal);
                
                // Fail
                m_fileName = CommonMethods.createPipelineFile(0);
                FileOutputStream fos = new FileOutputStream(m_fileName);
                try {
                    Blob tmpBlob = rs.getBlob("sisu");
                    InputStream blobStream = tmpBlob.getBinaryStream();
                    int readLen = 0;
                    try {
                        byte[] buf = new byte[Settings.getDBBufferSize()];
                        while ((readLen = blobStream.read(buf)) > 0) {
                            fos.write(buf, 0, readLen);
                        }
                    } catch (Exception e) {
                        CommonMethods.logError(e, "dhl.DocumentFragment", "loadFromDB");
                        throw e;
                    } finally {
                        blobStream.close();
                    }
                } finally {
                    CommonMethods.safeCloseStream(fos);
                }
            }
            stmt.close();
        } catch (Exception ex) {
            throw new AxisFault(ex.getMessage());
        }
    }
    
    public int addToDBProc(Connection conn, XHeader xTeePais) throws AxisFault {
    	try {
    		FileInputStream inStream = null;
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                boolean defaultAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                FileInputStream fis = null;
                try {
                    m_id = getNextID(conn);
                    
                    CallableStatement cs = conn.prepareCall("{call ADD_DOKUMENT_FRAGMENT(?,?,?,?,?,?,?,?,?,?)}");
		    		cs.setInt(1, m_id);
		    		if(m_isIncoming) {
		    			cs.setInt(2, 1);
		    		} else {
		    			cs.setInt(2, 0);
		    		}		    		
		    		cs.setInt(3, m_organizationID);
		    		cs.setString(4, m_deliverySessionID);
		    		cs.setInt(5, m_fragmentNr);
		    		cs.setInt(6, m_fragmentCount);
		    		cs.setTimestamp(7, CommonMethods.sqlDateFromDate(m_dateCreated), cal);
		    		if(xTeePais != null) {
		    			cs.setString(9, xTeePais.isikukood);
		    			cs.setString(10, xTeePais.asutus);
		    		} else {
		    			cs.setString(9, null);
		    			cs.setString(10, null);
		    		}
		    		
		    		// BINARY TO BLOB
		    		if ((new File(m_fileName)).exists()) {
			    		int fileCharsCount = CommonMethods.getCharacterCountInFile(m_fileName);
			    		inStream = new FileInputStream(m_fileName);
			    		cs.setBlob(8, inStream, fileCharsCount);
		    		}
                    
		    		// Execute
		    		cs.execute();
		    		cs.close();
		    		conn.commit();
                } catch (Exception ex) {
                    conn.rollback();
                    CommonMethods.logError(ex, this.getClass().getName(), "addToDB");
                    throw ex;
                } finally {
                    CommonMethods.safeCloseStream(fis);
                    fis = null;
                }

                // Anname auto-commit seadistusele uuesti vaikimisi võõrtuse
                conn.setAutoCommit(defaultAutoCommit);

                // Väljastame lisatud dokumendi ID
                return m_id;
            } else {
                throw new AxisFault(CommonStructures.VIGA_ANDMEBAASIGA_YHENDAMISEL);
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            throw new AxisFault(CommonStructures.VIGA_ANDMEBAASI_SALVESTAMISEL + " : " + e.getMessage());
        }
    }
    
    public int addToDB(Connection conn) throws AxisFault {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                boolean defaultAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                FileInputStream fis = null;
                try {
                    m_id = getNextID(conn);
                    String sql = "INSERT INTO dokumendi_fragment(fragment_id, sissetulev, asutus_id, edastus_id, fragment_nr, fragmente_kokku, loodud, sisu) VALUES(?,?,?,?,?,?,?,EMPTY_BLOB())";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, m_id);
                    pstmt.setInt(2, m_isIncoming ? 1 : 0);
                    pstmt.setInt(3, m_organizationID);
                    pstmt.setString(4, m_deliverySessionID);
                    pstmt.setInt(5, m_fragmentNr);
                    pstmt.setInt(6, m_fragmentCount);
                    pstmt.setTimestamp(7, CommonMethods.sqlDateFromDate(m_dateCreated), cal);
                    pstmt.execute();
                    pstmt.close();

                    if ((new File(m_fileName)).exists()) {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT sisu FROM dokumendi_fragment WHERE fragment_id=" + String.valueOf(m_id) + " FOR UPDATE");
                        if (rs.next()) {
                            Blob sisu = rs.getBlob(1);
                            OutputStream blobStream = sisu.setBinaryStream(0);
                            fis = new FileInputStream(m_fileName);
                            byte[] buffer = new byte[Settings.getDBBufferSize()];
                            int nread = 0;
                            while ((nread = fis.read(buffer)) > 0) {
                                blobStream.write(buffer, 0, nread);
                            }
                            CommonMethods.safeCloseStream(fis);
                            blobStream.flush();
                            blobStream.close();
                        }
                        stmt.close();
                    }
                    conn.commit();
                } catch (Exception ex) {
                    conn.rollback();
                    CommonMethods.logError(ex, this.getClass().getName(), "addToDB");
                    throw ex;
                } finally {
                    CommonMethods.safeCloseStream(fis);
                    fis = null;
                }

                // Anname auto-commit seadistusele uuesti vaikimisi võõrtuse
                conn.setAutoCommit(defaultAutoCommit);

                // Võljastame lisatud dokumendi ID
                return m_id;
            } else {
                throw new AxisFault(CommonStructures.VIGA_ANDMEBAASIGA_YHENDAMISEL);
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            throw new AxisFault(CommonStructures.VIGA_ANDMEBAASI_SALVESTAMISEL + " : " + e.getMessage());
        }
    }
    
    public static String getFullDocument(int orgID, String deliverySessionID, boolean isIncoming, Connection conn) {
        try {
            if (conn != null) {
                boolean defaultAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                CallableStatement cs = conn.prepareCall("{call GET_DOCUMENTFRAGMENTS(?,?,?,?)}");
                cs.setInt("organization_id", orgID);
                cs.setString("delivery_session_id", deliverySessionID);
                cs.setInt("is_incoming", isIncoming ? 1 : 0);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet)cs.getObject("RC1");
                String resultFile = CommonMethods.createPipelineFile(0);
                FileOutputStream fos = new FileOutputStream(resultFile);
                try {
                    while (rs.next()) {
                        // Loeme BLOB-ist dokumendi andmed
                        Blob tmpBlob = rs.getBlob("sisu");
                        InputStream blobStream = tmpBlob.getBinaryStream();
                        int readLen = 0;
                        try {
                            byte[] buf = new byte[Settings.getDBBufferSize()];
                            while ((readLen = blobStream.read(buf)) > 0) {
                                fos.write(buf, 0, readLen);
                            }
                        } catch (Exception e) {
                            CommonMethods.logError(e, "dhl.DocumentFragment", "getFullDocument");
                            throw e;
                        } finally {
                            blobStream.close();
                        }
                    }
                } finally {
                    fos.flush();
                    fos.close();
                }
                rs.close();
                cs.close();
                conn.setAutoCommit(defaultAutoCommit);
                return resultFile;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.DocumentFragment", "getDocumentsSentTo");
            return null;
        }
    }
    
    public static boolean deleteFragments(int orgID, String deliverySessionID, boolean isIncoming, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs =  conn.prepareCall("{call DELETE_DOCUMENTFRAGMENTS(?,?,?)}");
                cs.setInt(1, orgID);
                cs.setString(2, deliverySessionID);
                cs.setInt(3, isIncoming ? 1 : 0);
                boolean result = cs.execute();
                cs.close();
                return result;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.DocumentFragment",  "deleteFragments");
            return false;
        }
    }
    
    public static FragmentationResult getFragments(String fileName, long fragmentMaxSize, int orgID, String deliverySessionID, boolean isIncoming, Connection conn, XHeader xTeePais) throws AxisFault {
        String firstFragment = null;
        FragmentationResult result = new FragmentationResult();
        try {
            ArrayList<String> fragmentFiles = CommonMethods.splitFileBySize(fileName, fragmentMaxSize);
            if ((fragmentFiles != null) && !fragmentFiles.isEmpty()) {
                firstFragment = fragmentFiles.get(0);
                for (int i = 0; i < fragmentFiles.size(); ++i) {
                    DocumentFragment fragment = new DocumentFragment();
                    fragment.setDateCreated(new Date());
                    fragment.setDeliverySessionID(deliverySessionID);
                    fragment.setFileName(fragmentFiles.get(i));
                    fragment.setFragmentCount(fragmentFiles.size());
                    fragment.setFragmentNr(i);
                    fragment.setOrganizationID(orgID);
                    fragment.setIsIncoming(isIncoming);
                    fragment.addToDBProc(conn,xTeePais);
                    
                    // Kustutame kettalt kõik fragmendid peale esimese
                    if (i > 0) {
                        (new File(fragmentFiles.get(i))).delete();
                    }
                }
                result.totalFragments = fragmentFiles.size();
            }
        } catch (Exception ex) {
            throw new AxisFault(ex.getMessage());
        }
        result.firstFragmentFile = firstFragment;
        return result;
    }
}
