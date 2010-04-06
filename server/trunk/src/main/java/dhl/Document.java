package dhl;

import dhl.iostructures.ExpiredDocumentData;
import dhl.iostructures.XHeader;
import dvk.core.Settings;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamReader;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.impl.builder.StAXOMBuilder;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Document {
	static Logger logger = Logger.getLogger(Document.class.getName());
	private int m_id;
    private int m_organizationID;
    private String m_filePath;
    private int m_folderID;
    private ArrayList<Sending> m_sendingList;
    private Date m_conservationDeadline;
    
    // DVK konteineri versioon
    private int m_dvkContainerVersion;
    private String m_guid;
    
    // Abimuutujad, mida kasutatakse andmetõõtlusel,
    // aga mida andmebaasi ei salvestata.
    private org.w3c.dom.Document m_simplifiedXmlDoc;
    private ArrayList<DocumentFile> m_files;

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

    public void setFilePath(String filePath) {
        this.m_filePath = filePath;
    }

    public String getFilePath() {
        return m_filePath;
    }

    public org.w3c.dom.Document getSimplifiedXmlDoc() {
        return m_simplifiedXmlDoc;
    }

    public void setSimplifiedXmlDoc(org.w3c.dom.Document simplifiedXmlDoc) {
        m_simplifiedXmlDoc = simplifiedXmlDoc;
    }

    public void setFolderID(int folderID) {
        this.m_folderID = folderID;
    }

    public int getFolderID() {
        return m_folderID;
    }

    public void setSendingList(ArrayList<Sending> sendingList) {
        this.m_sendingList = sendingList;
    }

    public ArrayList<Sending> getSendingList() {
        return m_sendingList;
    }
    
    public void setConservationDeadline(Date conservationDeadline) {
        this.m_conservationDeadline = conservationDeadline;
    }

    public Date getConservationDeadline() {
        return m_conservationDeadline;
    }

    public ArrayList<DocumentFile> getFiles() {
        return this.m_files;
    }

    public void setFiles(ArrayList<DocumentFile> value) {
        this.m_files = value;
    }
    
    public Document() {
        clear();
    }

    public Document(int id, int organizationID, int folderID, String filePath, ArrayList<Sending> sendingList, Date conservationDeadline) {
        m_id = id;
        m_organizationID = organizationID;
        m_folderID = folderID;
        m_filePath = filePath;
        m_sendingList = sendingList;
        m_conservationDeadline = conservationDeadline;
        m_dvkContainerVersion = 1;
        m_files = new ArrayList<DocumentFile>();
    }

    public Document(int id, int organizationID, int folderID, String filePath, ArrayList<Sending> sendingList, Date conservationDeadline, int dvkContainerVersion) {
        m_id = id;
        m_organizationID = organizationID;
        m_folderID = folderID;
        m_filePath = filePath;
        m_sendingList = sendingList;
        m_conservationDeadline = conservationDeadline;
        m_dvkContainerVersion = dvkContainerVersion;
        m_files = new ArrayList<DocumentFile>();
    }
    
    public void clear() {
        m_id = 0;
        m_organizationID = 0;
        m_folderID = Folder.GLOBAL_ROOT_FOLDER;
        m_filePath = "";
        m_simplifiedXmlDoc = null;
        if (m_sendingList == null) {
            m_sendingList = new ArrayList<Sending>();
        } else {
            m_sendingList.clear();
        }
        m_conservationDeadline = null;
        m_dvkContainerVersion = 1;
        if (m_files == null) {
        	m_files = new ArrayList<DocumentFile>();
        } else {
        	m_files.clear();
        }
    }

    public static int getNextID(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_NEXTDOCID(?)}");
                cs.registerOutParameter("document_id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("document_id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document", "getNextID");
            return 0;
        }
    }

    public int addToDB(Connection conn, XHeader xTeePais) throws AxisFault {
    	int result = 0;
    	FileInputStream inStream = null;
        InputStreamReader inReader = null;
        BufferedReader reader = null;
        try {
	    	if (conn != null) {
	    		boolean defaultAutoCommit = conn.getAutoCommit();
	            conn.setAutoCommit(false);
		    	try {
		    		
		    		Calendar cal = Calendar.getInstance();
		    		m_id = getNextID(conn);
		    		
		    		File file = new File(m_filePath);
		        	long fileSize = 0;
		        	if(file.exists()) {
		        		fileSize = file.length();
		        	}
		    		
		    		CallableStatement cs = conn.prepareCall("{call ADD_DOKUMENT(?,?,?,?,?,?,?,?,?,?)}");
		    		cs.setInt(1, m_id);
		    		cs.setInt(2, m_organizationID);
		    		cs.setInt(3, m_folderID);
		    		cs.setTimestamp(5, CommonMethods.sqlDateFromDate(m_conservationDeadline), cal);
		    		
		    		if(fileSize > 0) {
		    			cs.setLong(6, fileSize);
		            } else {
		            	cs.setNull(6, java.sql.Types.BIGINT);
		            }
		    		
		    		cs.setInt(7, m_dvkContainerVersion);
		    		cs.setString(8, m_guid);
		    		
		    		if(xTeePais != null) {
		    			cs.setString(9, xTeePais.isikukood);
		    			cs.setString(10, xTeePais.asutus);
		    		} else {
		    			cs.setString(9, null);
		    			cs.setString(10, null);
		    		}
		    		
		    		// XML to CLOB
		    		int fileCharsCount = CommonMethods.getCharacterCountInFile(m_filePath);
		    		inStream = new FileInputStream(m_filePath);
		            inReader = new InputStreamReader(inStream, "UTF-8");
		            reader = new BufferedReader(inReader);
		    		cs.setCharacterStream(4, reader, fileCharsCount);
		    		
		    		// Execute
		    		cs.execute();
		    		cs.close();
		    		conn.commit();
		    		
	    		} catch(Exception e) {
	    			logger.error("Exception while saving document to database: ", e);
	    			conn.rollback();
                    conn.setAutoCommit(defaultAutoCommit);
	    		} finally {
	    			CommonMethods.safeCloseReader(reader);
	                CommonMethods.safeCloseReader(inReader);
	                CommonMethods.safeCloseStream(inStream);
	                inStream = null;
	                inReader = null;
	                reader = null;
	    		}
	    		
	    		// Salvestame dokumendi transpordiinfo
	            for (Sending tmpSending: m_sendingList) {
	                tmpSending.setDocumentID(m_id);
	                logger.debug("Saving transport info for document: " + m_id);
	                int sendingResult = tmpSending.addToDB(conn, xTeePais);
	                if (sendingResult <= 0) {
	                    conn.rollback();
	                    conn.setAutoCommit(defaultAutoCommit);
	                    throw new AxisFault("Error saving addressing information to database!");
	                }
	            }
	
	            // Kinnitame andmebaasis tehtud muudatused
	            conn.commit();
	            conn.setAutoCommit(defaultAutoCommit);
	    		
	    	} else {
	    		logger.error("Database connection is null.");
	    	}
        } catch (Exception e) {
        	logger.error(CommonStructures.VIGA_ANDMEBAASI_SALVESTAMISEL + ": ", e);
            throw new AxisFault(CommonStructures.VIGA_ANDMEBAASI_SALVESTAMISEL + " : " + e.getMessage());
        }
    	return m_id;
    }

    public static boolean deleteFromDB(int id, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs =  conn.prepareCall("{call DELETE_DOCUMENT(?)}");
                cs.setInt(1, id);
                boolean result = cs.execute();
                cs.close();
                return result;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document",  "deleteFromDB");
            return false;
        }
    }
    
    public static boolean updateExpirationDate(int id, Date expirationDate, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs =  conn.prepareCall("{call UPDATE_DOCUMENTEXPIRATIONDATE(?,?)}");
                cs.setInt(1, id);
                cs.setTimestamp(2, CommonMethods.sqlDateFromDate(expirationDate), cal);
                boolean result = cs.execute();
                cs.close();
                cal = null;
                return result;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document",  "updateExpirationDate");
            return false;
        }
    }

    /**
     * Tagastab nimekirja etteantud dokumentidest, mille allalaadimiseks
     * on etteantud isikul õigus.
     * 
     * @param organizationID			asutuse ID
     * @param folderID					kausta ID
     * @param userID					isiku ID
     * @param divisionID				allõksuse ID
     * @param divisionShortName			allõksuse lõhinimetus
     * @param occupationID				ametikoha ID
     * @param occupationShortName		ametikoha lõhinimetus
     * @param resultLimit				maksimaalne lubatud tulemuste arv
     * @param conn						andmebaasiõhenduse objekt
     * @return							nimekiri allalaadimist ootavatest dokumentidest
     */
    public static ArrayList<Document> getDocumentsSentTo(
        int organizationID,
        int folderID,
        int userID,
        int divisionID,
        String divisionShortName,
        int occupationID,
        String occupationShortName,
        int resultLimit,
        Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                boolean defaultAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                
                CallableStatement cs = conn.prepareCall("{call GET_DOCUMENTSSENTTO(?,?,?,?,?,?,?,?,?)}");
                cs.setInt("organization_id", organizationID);
                if (folderID >= 0) {
                    cs.setInt("folder_id", folderID);
                } else {
                    cs.setNull("folder_id", Types.INTEGER);
                }
                cs.setInt("user_id", userID);
                if (divisionID > 0) {
                    cs.setInt("division_id", divisionID);
                } else {
                    cs.setNull("division_id", Types.INTEGER);
                }
                if ((divisionShortName != null) && (divisionShortName.length() > 0)) {
                    cs.setString("division_short_name", divisionShortName);
                } else {
                    cs.setNull("division_short_name", Types.VARCHAR);
                }
                if (occupationID > 0) {
                    cs.setInt("occupation_id", occupationID);
                } else {
                    cs.setNull("occupation_id", Types.INTEGER);
                }
                if ((occupationShortName != null) && (occupationShortName.length() > 0)) {
                    cs.setString("occupation_short_name", occupationShortName);
                } else {
                    cs.setNull("occupation_short_name", Types.VARCHAR);
                }
                cs.setInt("result_limit", resultLimit);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet)cs.getObject("RC1");
                ArrayList<Document> result = new ArrayList<Document>();
                int docCounter = 0;
                while (rs.next()) {
                    ++docCounter;

                    Document item = new Document();
                    item.setId(rs.getInt("dokument_id"));
                    item.setOrganizationID(rs.getInt("asutus_id"));
                    item.setFolderID(rs.getInt("kaust_id"));
                    item.setConservationDeadline(rs.getTimestamp("sailitustahtaeg", cal));
                    item.setDvkContainerVersion(rs.getInt("versioon"));
                    
                    // Loeme CLOB-ist dokumendi andmed
                    Clob tmpBlob = rs.getClob("sisu");
                    Reader r = tmpBlob.getCharacterStream();
                    String itemDataFile = CommonMethods.createPipelineFile(docCounter);
                    item.setFilePath(itemDataFile);
                    FileOutputStream fos = new FileOutputStream(itemDataFile);
                    OutputStreamWriter out = new OutputStreamWriter(fos, "UTF-8");
                    int actualReadLength = 0;
                    int totalReadLength = 0;
                    try {
                        char[] charbuf = new char[Settings.getDBBufferSize()];
                        while ((actualReadLength = r.read(charbuf)) > 0) {
                            out.write(charbuf, 0, actualReadLength);
                            totalReadLength += actualReadLength;
                        }
                    } catch (Exception e) {
                        CommonMethods.logError(e, "dhl.Document", "getDocumentsSentTo");
                        throw e;
                    } finally {
                        out.flush();
                        out.close();
                        fos.close();
                    }
                    
                    if (totalReadLength < 1) {
                        (new File(itemDataFile)).delete();
                        item.setFilePath(null);
                    }

                    result.add(item);
                }
                rs.close();
                cs.close();
                
                conn.commit();
                conn.setAutoCommit(defaultAutoCommit);
                
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document", "getDocumentsSentTo");
            return null;
        }
    }

    /**
     * Loob XML-i põhjal <code>Document</code> objekti.
     * 
     * @param dataFile XML fail
     * @param organizationID organisatsiooni ID
     * @param conn andmebaasiõhendus
     * @return dokument
     * @throws AxisFault
     */
    public static Document fromXML(String dataFile, int organizationID, boolean extractFiles, Connection conn, XHeader xTeePais) throws AxisFault {
        try {
            Document result = new Document();
            result.setFilePath(dataFile);
            result.setOrganizationID(organizationID);

            XMLInputFactory inputFactory = XMLInputFactory.newInstance();
            XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");

            // TEST
            //OMElement omElement = new StAXOMBuilder(reader).getDocumentElement(); 
            //String xml = omElement.toStringWithConsume();
            //logger.debug("XML: " + xml);
            
            // Teeme kindlaks, mis versiooni DVK konteinerist kasutatakse
            //int containerVersion = CommonMethods.determineContainerVersion(reader);
            //result.setDvkContainerVersion(containerVersion);
            
            ArrayList<String> fileExtensionFilter = new ArrayList<String>(3);
            fileExtensionFilter.add("xml");
            fileExtensionFilter.add("ddoc");
            fileExtensionFilter.add("bdoc");
            
            try {
            	int guidElementCount = 0;
                while (reader.hasNext()) {
                    reader.next();

                    if (reader.hasName()) {
                    	logger.debug("Element: <" + reader.getLocalName() + ">");
                        if (reader.getLocalName().equalsIgnoreCase("dokument") && reader.isEndElement()) {
                            break;
                        } else if (reader.getLocalName().equalsIgnoreCase("transport") && reader.isStartElement()) {
                            Sending s = Sending.fromXML(reader, conn, xTeePais);
                            if (s != null) {
                                s.setIsNewlyAdded(true);
                                result.getSendingList().add(s);
                            }
                        } else if (reader.getLocalName().equalsIgnoreCase("signeddoc") && reader.isStartElement() && extractFiles) {
                            result.m_files = DocumentFile.getListFromContainerV1(reader, fileExtensionFilter);
                        } else if (reader.getLocalName().equalsIgnoreCase("failid") && reader.isStartElement() && extractFiles) {
                            result.m_files = DocumentFile.getListFromContainerV2(reader, fileExtensionFilter);
                        } else if (reader.getLocalName().equalsIgnoreCase("konteineri_versioon") && reader.isStartElement()) {
                        	reader.next();
                        	if(reader.isCharacters()) {
                        		String version = reader.getText().trim();
                        		try {
                        			Integer versionAsInteger = Integer.parseInt(version);
                        			result.setDvkContainerVersion(versionAsInteger.intValue());
                        		} catch (Exception e) {
                        			result.setDvkContainerVersion(1);
                        			logger.warn("Could not parse container version as Integer. Assuming container version = 1: ", e);
                        		}
                        	}
                        } else if (reader.getLocalName().equalsIgnoreCase("dokument_guid") && reader.isStartElement()) {
                        	logger.debug("Found element <dokument_guid>. Reading contents...");
                        	reader.next();
                        	if(guidElementCount == 0) {
                        		if(reader.isCharacters()) {
                        			String dokumentGuidTmp = reader.getText().trim();
                        			logger.debug("Found dokument GUID: " + dokumentGuidTmp);
                        			result.setGuid(dokumentGuidTmp);
                        			guidElementCount++;
                        		}
                        	}
                        }
                    }
                }
                	
            } finally {
                reader.close();
            }
            return result;
        } catch (AxisFault fault) {
        	CommonMethods.logError(fault, "dhl.Document", "fromXML");
        	throw fault;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document", "fromXML");
            throw new AxisFault(ex.getMessage());
        }
    }

    public static ArrayList<Document> sendingStatusFromXML(String dataFile, int requestVersion) {
        ArrayList<Document> result = new ArrayList<Document>();
        try {
        	
        	if(requestVersion == 1) {
        		XMLInputFactory inputFactory = XMLInputFactory.newInstance();
                XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");                
                try {
                	
                		while (reader.hasNext()) {
                            reader.next();

                            if (reader.hasName()) {
                                if (reader.getLocalName().equalsIgnoreCase("dhl_id") && reader.isStartElement() && reader.hasNext()) {
                                    reader.next();
                                    if (reader.isCharacters()) {
                                    	Document tmpDoc = new Document();
                                    	tmpDoc.setId(Integer.parseInt(reader.getText().trim()));
                                        result.add(tmpDoc);
                                    }
                                }
                            }
                        }
                    
                } finally {
                    reader.close();
                }
                
        	} else {
                org.w3c.dom.Document xmlDoc = CommonMethods.xmlDocumentFromFile(dataFile, true);
                NodeList itemNodeList = xmlDoc.getElementsByTagName("item");
                
                if(itemNodeList != null) {
                	for(int i = 0; i < itemNodeList.getLength(); i++) {
                		Document tmpDoc = new Document();
                		boolean documentFilled = false;
                		Node node = itemNodeList.item(i);
                		NodeList childNodes = node.getChildNodes();
                		if(childNodes != null) {
                			for(int j = 0; j < childNodes.getLength(); j++) {
                				Node childNode = childNodes.item(j);
                				if(childNode.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE && childNode.getLocalName() != null && childNode.getLocalName().equalsIgnoreCase("dhl_id")) {
                					tmpDoc.setId(Integer.parseInt(childNode.getTextContent()));
                					documentFilled = true;
                				}
                				if(childNode.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE && childNode.getLocalName() != null && childNode.getLocalName().equalsIgnoreCase("dokument_guid")) {
                					tmpDoc.setGuid(childNode.getTextContent());
                					documentFilled = true;
                				}
                			}
                			if(documentFilled) {
                				result.add(tmpDoc);
                			}
                		}
                	}
                }
        	}
        	return result;
            
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document", "sendingStatusFromXML");
            return null;
        }
    }
    
    public static ArrayList<ExpiredDocumentData> getExpiredDocuments(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = null;
                ResultSet rs = null;
                ArrayList<ExpiredDocumentData> result = new ArrayList<ExpiredDocumentData>();
                try {
                    cs = conn.prepareCall("{call GET_EXPIREDDOCUMENTS(?)}");
                    cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                    cs.execute();
                    rs = (ResultSet)cs.getObject("RC1");
                    while (rs.next()) {
                        ExpiredDocumentData item = new ExpiredDocumentData();
                        item.setDocumentID(rs.getInt("dokument_id"));
                        item.setSendStatusID(rs.getInt("staatus_id"));
                        item.setConservationDeadline(rs.getTimestamp("sailitustahtaeg", cal));
                        result.add(item);
                    }
                }
                finally {
                    rs.close();
                    cs.close();
                }
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Document", "getExpiredDocuments");
            return null;
        }
    }

	public int getDvkContainerVersion() {
		return m_dvkContainerVersion;
	}

	public void setDvkContainerVersion(int containerVersion) {
		m_dvkContainerVersion = containerVersion;
	}

	public String getGuid() {
		return m_guid;
	}

	public void setGuid(String mGuid) {
		m_guid = mGuid;
	}
}
