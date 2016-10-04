package dhl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;

public class Folder {
    public static final int NONEXISTING_FOLDER = Integer.MIN_VALUE;
    public static final int UNSPECIFIED_FOLDER = -1;
    public static final int GLOBAL_ROOT_FOLDER = 0;
    private static final String DELIMITER = "/";

    private int m_id;
    private String m_nimi;
    private int m_parentFolderID;
    private int m_organizationID;
    private String m_folderNumber;
    private int m_positionID;

    public Folder() {
        clear();
    }

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setNimi(String nimi) {
        this.m_nimi = correctFolderName(nimi);
    }

    public String getNimi() {
        return m_nimi;
    }

    public void setParentFolderID(int parentFolderID) {
        this.m_parentFolderID = parentFolderID;
    }

    public int getParentFolderID() {
        return m_parentFolderID;
    }

    public void setOrganizationID(int organizationID) {
        this.m_organizationID = organizationID;
    }

    public int getOrganizationID() {
        return m_organizationID;
    }

    public void setFolderNumber(String folderNumber) {
        this.m_folderNumber = folderNumber;
    }

    public String getFolderNumber() {
        return m_folderNumber;
    }

    public void setPositionID(int positionID) {
        this.m_positionID = positionID;
    }

    public int getPositionID() {
        return m_positionID;
    }

    public void clear() {
        m_id = 0;
        m_nimi = "";
        m_parentFolderID = 0;
        m_organizationID = 0;
        m_folderNumber = "";
        m_positionID = 0;
    }

    public static int getFolderIdByPath(String path, int organizationID, Connection conn,
                                        boolean allowUnspecified, boolean allowNew, XRoadProtocolHeader xTeePais) {
        if ((path == null) || (path.length() < 1)) {
            return allowUnspecified ? UNSPECIFIED_FOLDER : GLOBAL_ROOT_FOLDER;
        }

        if (path.equalsIgnoreCase(Folder.DELIMITER)) {
            return GLOBAL_ROOT_FOLDER;
        }

        while (path.startsWith(DELIMITER)) {
            path = path.substring(1);
        }
        while (path.endsWith(DELIMITER)) {
            path = path.substring(0, path.length() - 1);
        }

        String[] splitPath = path.split(Folder.DELIMITER);
        int folderMarker = GLOBAL_ROOT_FOLDER;
        for (int i = 0; i < splitPath.length; ++i) {
            if ((splitPath[i] != null) && (splitPath[i].trim().length() > 0)) {
                folderMarker = getFolderIdByName(splitPath[i].trim(), organizationID, folderMarker, conn);
            } else {
                folderMarker = NONEXISTING_FOLDER;
            }

            if (folderMarker == NONEXISTING_FOLDER) {
                return allowNew ? createFolder(path, GLOBAL_ROOT_FOLDER, 0, "", conn, xTeePais) : NONEXISTING_FOLDER;
            }
        }
        return folderMarker;
    }

    /**
     * Leiab kausta nime alusel kausta ID.
     *
     * @param folderName     kausta nimi
     * @param organizationID asutuse ID
     * @param parentID       otsitava kausta ülemkausta ID
     * @param conn           andmebaasiühenduse objekt
     * @return kausta ID
     */   
    public static int getFolderIdByName(String folderName, int organizationID, int parentID, Connection conn) {    	
        if ((folderName == null) || (folderName.length() < 1)) {
            return UNSPECIFIED_FOLDER;
        }

        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{? = call \"Get_FolderIdByName\"(?,?,?)}");
                cs.registerOutParameter(1, Types.INTEGER);
                
                cs.setString(2, folderName);
                cs.setInt(3, organizationID);
                cs.setInt(4, parentID);
                cs.executeUpdate();
                int result = cs.getInt(1);
                if (cs.getObject(1) == null) {
                    result = NONEXISTING_FOLDER;
                }
                cs.close();
                return result;
            } else {
                return NONEXISTING_FOLDER;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "getFolderIdByName");
            return NONEXISTING_FOLDER;
        }
    }
    
    /**
     * Leiab kataloogi ID järgi kausta täisnime (täisteekonna alustades juurkaustast).
     *
     * @param folderID Kausta ID
     * @param conn     Andmebaasiühenduse objekt
     * @return Kausta täisnimi
     */
    public static String getFolderFullPath(int folderID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{? = call \"Get_FolderFullPath\"(?)}");
                cs.registerOutParameter(1, Types.VARCHAR);
                cs.setInt(2, folderID);
                cs.executeUpdate();
                String result = cs.getString(1);
                cs.close();
                return result;
            } else {
                return "";
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "getFolderFullPath");
            return "";
        }
    }


    
    public static int createFolder(String fullPath, int parentID, int orgID, String folderNumber, Connection conn, XRoadProtocolHeader xTeePais) {
    	try {
            if (conn != null) {
                while (fullPath.startsWith(DELIMITER)) {
                    fullPath = fullPath.substring(1);
                }
                while (fullPath.endsWith(DELIMITER)) {
                    fullPath = fullPath.substring(0, fullPath.length() - 2);
                }

                int id = GLOBAL_ROOT_FOLDER;
                String[] splitPath = fullPath.split(DELIMITER);
                if ((splitPath.length > 0) && (splitPath[0] != null) && (splitPath[0].trim().length() > 0)) {
                    id = getFolderIdByName(splitPath[0].trim(), orgID, parentID, conn);
                    if (id == NONEXISTING_FOLDER) {
                        CallableStatement cs = conn.prepareCall("{? = call \"Add_Folder\"(?,?,?,?,?,?)}");
                        cs.registerOutParameter(1, Types.INTEGER);
                        
                        cs.setString(2, splitPath[0].trim());
                        cs.setInt(3, parentID);

                        if (orgID > 0) {
                            cs.setInt(4, orgID);
                        } else {
                            cs.setNull(4, Types.INTEGER);
                        }

                        if (splitPath.length == 1) {
                            cs.setString(5, folderNumber);
                        } else {
                            cs.setNull(5, Types.VARCHAR);
                        }

                        if (xTeePais != null) {
                            cs.setString(6, xTeePais.getUserId());
                            cs.setString(7, xTeePais.getConsumer());
                        } else {
                            cs.setString(6, null);
                            cs.setString(7, null);
                        }
                        cs.executeUpdate();
                        id = cs.getInt(1);
                        cs.close();
                    }
                }

                if (splitPath.length > 1) {
                    String subPath = "";
                    for (int i = 1; i < splitPath.length; ++i) {
                        if (i > 1) {
                            subPath += DELIMITER;
                        }
                        subPath += splitPath[i];
                    }
                    return createFolder(subPath, id, orgID, folderNumber, conn, xTeePais);
                } else {
                    return id;
                }
            } else {
                return GLOBAL_ROOT_FOLDER;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "createFolder");
            return GLOBAL_ROOT_FOLDER;
        }
    }
    
    /**
     * Muudab etteantud kausta nimetust nii, et see sisaldaks ainult ASCII sümboleid
     * A-Z, 0-9, /, _.
     *
     * @param initialName Kliendi poolt etteantud kausta nimetus
     * @return DVK jaoks sobilikule kujule viidud kausta nimetus
     */
    public String correctFolderName(String initialName) {
        if ((initialName == null) || (initialName.length() < 1)) {
            return initialName;
        }
        try {
            return initialName.toUpperCase().replaceAll("[^A-Z_/0-9]", "");
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.Folder", "correctFolderName");
            return initialName;
        }
    }
    
    
    /*
    public static int getFolderIdByName(String folderName, int organizationID, int parentID, Connection conn) {
        if ((folderName == null) || (folderName.length() < 1)) {
            return UNSPECIFIED_FOLDER;
        }

        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_FOLDERIDBYNAME(?,?,?,?)}");
                cs.setString("folder_name", folderName);
                cs.setInt("organization_id", organizationID);
                cs.setInt("parent_id", parentID);
                cs.registerOutParameter("folder_id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("folder_id");
                if (cs.getObject("folder_id") == null) {
                    result = NONEXISTING_FOLDER;
                }
                cs.close();
                return result;
            } else {
                return NONEXISTING_FOLDER;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "getFolderIdByName");
            return NONEXISTING_FOLDER;
        }
    }
    */
    /*
    public static int createFolder(String fullPath, int parentID, int orgID, String folderNumber, Connection conn, XHeader xTeePais) {
        try {
            if (conn != null) {
                while (fullPath.startsWith(DELIMITER)) {
                    fullPath = fullPath.substring(1);
                }
                while (fullPath.endsWith(DELIMITER)) {
                    fullPath = fullPath.substring(0, fullPath.length() - 2);
                }

                int id = GLOBAL_ROOT_FOLDER;
                String[] splitPath = fullPath.split(DELIMITER);
                if ((splitPath.length > 0) && (splitPath[0] != null) && (splitPath[0].trim().length() > 0)) {
                    id = getFolderIdByName(splitPath[0].trim(), orgID, parentID, conn);
                    if (id == NONEXISTING_FOLDER) {
                        CallableStatement cs = conn.prepareCall("{call ADD_FOLDER(?,?,?,?,?,?,?)}");
                        cs.setString("folder_name", splitPath[0].trim());
                        cs.setInt("parent_id", parentID);

                        if (orgID > 0) {
                            cs.setInt("org_id", orgID);
                        } else {
                            cs.setNull("org_id", Types.INTEGER);
                        }

                        if (splitPath.length == 1) {
                            cs.setString("folder_number", folderNumber);
                        } else {
                            cs.setNull("folder_number", Types.VARCHAR);
                        }

                        if (xTeePais != null) {
                            cs.setString("xtee_isikukood", xTeePais.isikukood);
                            cs.setString("xtee_asutus", xTeePais.asutus);
                        } else {
                            cs.setString("xtee_isikukood", null);
                            cs.setString("xtee_asutus", null);
                        }


                        cs.registerOutParameter("folder_id", Types.INTEGER);
                        cs.executeUpdate();
                        id = cs.getInt("folder_id");
                        cs.close();
                    }
                }

                if (splitPath.length > 1) {
                    String subPath = "";
                    for (int i = 1; i < splitPath.length; ++i) {
                        if (i > 1) {
                            subPath += DELIMITER;
                        }
                        subPath += splitPath[i];
                    }
                    return createFolder(subPath, id, orgID, folderNumber, conn, xTeePais);
                } else {
                    return id;
                }
            } else {
                return GLOBAL_ROOT_FOLDER;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "createFolder");
            return GLOBAL_ROOT_FOLDER;
        }
    }
    */
    
    
    /*
    public static String getFolderFullPath(int folderID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_FOLDERFULLPATH(?,?)}");
                cs.setInt("folder_id", folderID);
                cs.registerOutParameter("folder_path", Types.VARCHAR);
                cs.executeUpdate();
                String result = cs.getString("folder_path");
                cs.close();
                return result;
            } else {
                return "";
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.Folder", "getFolderFullPath");
            return "";
        }
    }
    */
}
