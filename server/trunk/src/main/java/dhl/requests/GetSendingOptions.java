package dhl.requests;

import dhl.iostructures.getSendingOptionsRequestType;
import dhl.iostructures.getSendingOptionsResponseType;
import dhl.iostructures.getSendingOptionsV2RequestType;
import dhl.iostructures.getSendingOptionsV2ResponseType;
import dhl.iostructures.getSendingOptionsV3RequestType;
import dhl.iostructures.getSendingOptionsV3ResponseType;
import dhl.users.Allyksus;
import dhl.users.Ametikoht;
import dhl.users.Asutus;
import dhl.users.AsutuseStatistika;
import dhl.users.UserProfile;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.core.AttachmentExtractionResult;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import dvk.core.ShortName;

import java.sql.Connection;
import java.util.ArrayList;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

public class GetSendingOptions {
	private static Logger logger = Logger.getLogger(GetSendingOptions.class);
	
    public static getSendingOptionsResponseType V1(org.apache.axis.MessageContext context, Connection conn, OrgSettings hostOrgSettings) throws AxisFault {
    	logger.info("GetSendingOptions.V1 invoked.");
    	
    	getSendingOptionsResponseType result = new getSendingOptionsResponseType();

        // Laeme p�ringu keha endale sobivasse andmestruktuuri
        getSendingOptionsRequestType bodyData = getSendingOptionsRequestType.getFromSOAPBody(context);
        result.paring = bodyData;

        // Leiame andmebaasist soovitud asutused
        ArrayList<Asutus> org = new ArrayList<Asutus>();
        if (Settings.Server_RunOnClientDatabase) {
            UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);
            for (int i = 0; i < credentials.length; ++i) {
                UnitCredential cred = credentials[i];
                if (bodyData != null) {
                    for (int j = 0; j < bodyData.asutused.length; ++j) {
                        if (bodyData.asutused[j].equalsIgnoreCase(cred.getInstitutionCode())) {
                            Asutus tmpOrg = new Asutus();
                            tmpOrg.setDvkOtseSaatmine(true);
                            tmpOrg.setDvkSaatmine(false);
                            tmpOrg.setNimetus(cred.getInstitutionName());
                            tmpOrg.setRegistrikood(cred.getInstitutionCode());
                            tmpOrg.setId(cred.getUnitID());
                            org.add(tmpOrg);
                        }
                    }
                } else {
                    Asutus tmpOrg = new Asutus();
                    tmpOrg.setDvkOtseSaatmine(true);
                    tmpOrg.setDvkSaatmine(false);
                    tmpOrg.setNimetus(cred.getInstitutionName());
                    tmpOrg.setRegistrikood(cred.getInstitutionCode());
                    tmpOrg.setId(cred.getUnitID());
                    org.add(tmpOrg);
                }
            }
        } else {
            if ((bodyData != null) && (bodyData.asutused != null) && (bodyData.asutused.length > 0)) {
                for (int i = 0; i < bodyData.asutused.length; ++i) {
                    Asutus tmpOrg = new Asutus();
                    tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                    org.add(tmpOrg);
                }
            } else {
                // Tagastame nimekirja k�igist seotud asutustest
                org = Asutus.getList(conn);
            }
            
            // Kui k�rgemalseisva asutuse ID on m��ratud, siis
            // kirjutame selle alusel k�rgmalseisva asutuse koodi �le.
            for (Asutus o : org) {
            	if (o.getKsAsutuseID() > 0) {
            		Asutus ks = new Asutus(o.getKsAsutuseID(), conn);
            		o.setKsAsutuseKood(ks.getRegistrikood());
            	}
            }
        }
        result.asutused = org;
        
        return result;
    }
    
    public static getSendingOptionsV2ResponseType V2(org.apache.axis.MessageContext context, Connection conn, OrgSettings hostOrgSettings) throws Exception {
    	logger.info("GetSendingOptions.V2 invoked.");
    	
    	getSendingOptionsV2ResponseType result = new getSendingOptionsV2ResponseType();

    	// Laeme p�ringu keha endale sobivasse andmestruktuuri
        getSendingOptionsV2RequestType bodyData = getSendingOptionsV2RequestType.getFromSOAPBody(context);
        result.paring = bodyData;

        // Leiame andmebaasist soovitud asutused
        ArrayList<Asutus> org = new ArrayList<Asutus>();
        if (Settings.Server_RunOnClientDatabase) {
            // Kui DVK server on seadistatud t��tama kliendi andmebaasi peal,
            // siis ei ole kunagi �htegi dokumenti vastuv�tmise ootel, kuna
            // dokumentide allalaadimise p�ring pole kasutatav.
            if (!bodyData.vastuvotmataDokumenteOotel) {
                UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);
                for (int i = 0; i < credentials.length; ++i) {
                    UnitCredential cred = credentials[i];
                    if (bodyData != null) {
                        for (int j = 0; j < bodyData.asutused.length; ++j) {
                            if (bodyData.asutused[j].equalsIgnoreCase(cred.getInstitutionCode())) {
                                Asutus tmpOrg = new Asutus();
                                tmpOrg.setDvkOtseSaatmine(true);
                                tmpOrg.setDvkSaatmine(false);
                                tmpOrg.setNimetus(cred.getInstitutionName());
                                tmpOrg.setRegistrikood(cred.getInstitutionCode());
                                tmpOrg.setId(cred.getUnitID());
                                org.add(tmpOrg);
                            }
                        }
                    } else {
                        Asutus tmpOrg = new Asutus();
                        tmpOrg.setDvkOtseSaatmine(true);
                        tmpOrg.setDvkSaatmine(false);
                        tmpOrg.setNimetus(cred.getInstitutionName());
                        tmpOrg.setRegistrikood(cred.getInstitutionCode());
                        tmpOrg.setId(cred.getUnitID());
                        org.add(tmpOrg);
                    }
                }
            }
        } else {
            if ((bodyData != null) && (bodyData.asutused != null) && (bodyData.asutused.length > 0)) {
                for (int i = 0; i < bodyData.asutused.length; ++i) {
                    Asutus tmpOrg = new Asutus();
                    tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                    org.add(tmpOrg);
                }
            } else {
                // Tagastame nimekirja k�igist seotud asutustest
                org = Asutus.getList(conn);
            }
            
            // Kui k�rgemalseisva asutuse ID on m��ratud, siis
            // kirjutame selle alusel k�rgmalseisva asutuse koodi �le.
            for (Asutus o : org) {
            	if (o.getKsAsutuseID() > 0) {
            		Asutus ks = new Asutus(o.getKsAsutuseID(), conn);
            		o.setKsAsutuseKood(ks.getRegistrikood());
            	}
            }
        }
        
        // Filtreerime v�lja etteantud kriteeriumitele vastavad asutused
        if (bodyData.vastuvotmataDokumenteOotel || (bodyData.vahetatudDokumenteKuni >= 0) || (bodyData.vahetatudDokumenteVahemalt >= 0)) {
            int i = 0;
            AsutuseStatistika stat = null;
            boolean remove = false;
            while (i < org.size()) {
                if (Settings.Server_RunOnClientDatabase) {
                    stat = new AsutuseStatistika();
                    stat.setVahetatudDokumente(UnitCredential.getExchangedDocumentsCount(org.get(i).getId(), hostOrgSettings));
                    stat.setVastuvotmataDokumente(0);
                } else {
                    stat = AsutuseStatistika.getByOrgID(org.get(i).getId(), conn);
                }
                if (stat == null) {
                    throw new AxisFault("DVK tarkvaraline viga: Viga asutuse statistika lugemisel!");
                } else {
                    remove = false;
                    if (bodyData.vastuvotmataDokumenteOotel) {
                        remove = remove || (stat.getVastuvotmataDokumente() < 1);
                    }
                    if (bodyData.vahetatudDokumenteVahemalt > -1) {
                        remove = remove || (stat.getVahetatudDokumente() < bodyData.vahetatudDokumenteVahemalt);
                    }
                    if (bodyData.vahetatudDokumenteKuni > -1) {
                        remove = remove || (stat.getVahetatudDokumente() > bodyData.vahetatudDokumenteKuni);
                    }
                    
                    if (remove) {
                        org.remove(i);
                    } else {
                        ++i;
                    }
                }
            }
        }
        result.asutused = org;
        
        return result;
    }
    
    public static getSendingOptionsV3ResponseType V3(org.apache.axis.MessageContext context, Connection conn, OrgSettings hostOrgSettings, UserProfile user) throws AxisFault {
    	logger.info("GetSendingOptions.V3 invoked. Parameter values: ");
    	
    	getSendingOptionsV3ResponseType result = new getSendingOptionsV3ResponseType();
    	try
    	{
	        // Laeme p�ringu keha endale sobivasse andmestruktuuri
	        getSendingOptionsV3RequestType bodyData = getSendingOptionsV3RequestType.getFromSOAPBody(context);
	        result.paring = bodyData;
	        
	        logger.debug("vahetatudDokumenteKuni: " + bodyData.vahetatudDokumenteKuni);
	        logger.debug("vahetatudDokumenteVahemalt: " + bodyData.vahetatudDokumenteVahemalt);
	        logger.debug("vastuvotmataDokumenteOotel: " + bodyData.vastuvotmataDokumenteOotel);
	        
	        // Laeme sisendparameetrid SOAP s�numi manuses asuvast XML failist
	        AttachmentExtractionResult exResult = CommonMethods.getExtractedFileFromAttachment(context, bodyData.kehaHref);
	        result.dataMd5Hash = exResult.getAttachmentHash();
	        bodyData.loadParametersFromXML(exResult.getExtractedFileName());
	        
	        // Leiame andmebaasist soovitud asutused
	        ArrayList<Asutus> organizationList = new ArrayList<Asutus>();
	        ArrayList<Allyksus> subdivisionList = new ArrayList<Allyksus>();
	        ArrayList<Ametikoht> occupationList = new ArrayList<Ametikoht>();
	        
	        if (Settings.Server_RunOnClientDatabase) {
	            // Kui DVK server on seadistatud t��tama kliendi andmebaasi peal,
	            // siis ei ole kunagi �htegi dokumenti vastuv�tmise ootel, kuna
	            // dokumentide allalaadimise p�ring pole kasutatav.
	            if (!bodyData.vastuvotmataDokumenteOotel) {
	                UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);
	                for (int i = 0; i < credentials.length; ++i) {
	                    UnitCredential cred = credentials[i];
	                    if ((bodyData.asutused != null) && (bodyData.asutused.length > 0)) {
	                    	logger.debug("BodyData.asutused is not empty.");
	                        for (int j = 0; j < bodyData.asutused.length; ++j) {
	                            if (bodyData.asutused[j].equalsIgnoreCase(cred.getInstitutionCode())) {
	                                Asutus tmpOrg = new Asutus();
	                                tmpOrg.setDvkOtseSaatmine(true);
	                                tmpOrg.setDvkSaatmine(false);
	                                tmpOrg.setNimetus(cred.getInstitutionName());
	                                tmpOrg.setRegistrikood(cred.getInstitutionCode());
	                                tmpOrg.setId(cred.getUnitID());
	                                organizationList.add(tmpOrg);
	                                
	                                if ((cred.getDivisionShortName() != null) && (cred.getDivisionShortName().length() > 0)) {
		                                Allyksus tmpSub = new Allyksus();
		                                tmpSub.setAsutusKood(cred.getInstitutionCode());
		                                tmpSub.setLyhinimetus(cred.getDivisionShortName());
		                                tmpSub.setNimetus(cred.getDivisionName());
		                                if ((bodyData.allyksused != null) && (bodyData.allyksused.size() > 0)) {
		                                	boolean found = false;
		                                	for (ShortName sn : bodyData.allyksused) {
		                                		if (tmpSub.getAsutusKood().equalsIgnoreCase(sn.getOrgCode()) && tmpSub.getLyhinimetus().equalsIgnoreCase(sn.getShortName())) {
		                                			found = true;
		                                			break;
		                                		}
		                                	}
		                                	if (found) {
		                                		subdivisionList.add(tmpSub);
		                                	}
		                                } else {
		                                	// Tagastame all�ksuste nimekirja �ksnes juhul, kui
		                                	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
		                                	if (bodyData.getParametesSpecified()) {
		                                		subdivisionList.add(tmpSub);
		                                	}
		                                }
	                                }
	                                
	                                if (cred.getOccupationID() > 0) {
		                                Ametikoht tmpOccupation = new Ametikoht();
		                                tmpOccupation.setAsutusKood(cred.getInstitutionCode());
		                                tmpOccupation.setNimetus(cred.getOccupationName());
		                                if ((bodyData.ametikohad != null) && (bodyData.ametikohad.size() > 0)) {
		                                	boolean found = false;
		                                	for (ShortName sn : bodyData.ametikohad) {
		                                		if (tmpOccupation.getAsutusKood().equalsIgnoreCase(sn.getOrgCode()) && tmpOccupation.getLyhinimetus().equalsIgnoreCase(sn.getShortName())) {
		                                			found = true;
		                                			break;
		                                		}
		                                	}
		                                	if (found) {
		                                		occupationList.add(tmpOccupation);
		                                	}
		                                } else {
		                                	// Tagastame ametikohtade nimekirja �ksnes juhul, kui
		                                	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
		                                	if (bodyData.getParametesSpecified()) {
		                                		occupationList.add(tmpOccupation);
		                                	}
		                                }
	                                }
	                            }
	                        }
	                    } else {
	                    	logger.debug("BodyData.asutused is empty.");
	                        Asutus tmpOrg = new Asutus();
	                        tmpOrg.setDvkOtseSaatmine(true);
	                        tmpOrg.setDvkSaatmine(false);
	                        tmpOrg.setNimetus(cred.getInstitutionName());
	                        tmpOrg.setRegistrikood(cred.getInstitutionCode());
	                        tmpOrg.setId(cred.getUnitID());
	                        organizationList.add(tmpOrg);
	                        
	                        if ((cred.getDivisionShortName() != null) && (cred.getDivisionShortName().length() > 0)) {
	                            Allyksus tmpSub = new Allyksus();
	                            tmpSub.setAsutusKood(cred.getInstitutionCode());
	                            tmpSub.setLyhinimetus(cred.getDivisionShortName());
	                            tmpSub.setNimetus(cred.getDivisionName());
                                if ((bodyData.allyksused != null) && (bodyData.allyksused.size() > 0)) {
                                	boolean found = false;
                                	for (ShortName sn : bodyData.allyksused) {
                                		if (tmpSub.getAsutusKood().equalsIgnoreCase(sn.getOrgCode()) && tmpSub.getLyhinimetus().equalsIgnoreCase(sn.getShortName())) {
                                			found = true;
                                			break;
                                		}
                                	}
                                	if (found) {
                                		subdivisionList.add(tmpSub);
                                	}
                                } else {
                                	// Tagastame all�ksuste nimekirja �ksnes juhul, kui
                                	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
                                	if (bodyData.getParametesSpecified()) {
                                		subdivisionList.add(tmpSub);
                                	}
                                }
	                        }
	                        
	                        if (cred.getOccupationID() > 0) {
	                            Ametikoht tmpOccupation = new Ametikoht();
	                            tmpOccupation.setAsutusKood(cred.getInstitutionCode());
	                            tmpOccupation.setNimetus(cred.getOccupationName());
                                if ((bodyData.ametikohad != null) && (bodyData.ametikohad.size() > 0)) {
                                	boolean found = false;
                                	for (ShortName sn : bodyData.ametikohad) {
                                		if (tmpOccupation.getAsutusKood().equalsIgnoreCase(sn.getOrgCode()) && tmpOccupation.getLyhinimetus().equalsIgnoreCase(sn.getShortName())) {
                                			found = true;
                                			break;
                                		}
                                	}
                                	if (found) {
                                		occupationList.add(tmpOccupation);
                                	}
                                } else {
                                	// Tagastame ametikohtade nimekirja �ksnes juhul, kui
                                	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
                                	if (bodyData.getParametesSpecified()) {
                                		occupationList.add(tmpOccupation);
                                	}
                                }
	                        }
	                    }
	                }
	            }
	        } else {
	        	logger.debug("Server running on server database.");
	            if ((bodyData != null) && (bodyData.asutused != null) && (bodyData.asutused.length > 0)) {
	            	logger.debug("Request bodyData contains a list of 'asutused'.");
	                for (int i = 0; i < bodyData.asutused.length; ++i) {
	                    Asutus tmpOrg = new Asutus();
	                    tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
	                    organizationList.add(tmpOrg);
	                    
	                    ArrayList<Allyksus> orgSubdivisions = Allyksus.getList(tmpOrg.getId(), "", conn);
	                    for (int j = 0; j < orgSubdivisions.size(); j++) {
	                    	Allyksus tmpSub = orgSubdivisions.get(j);
	                    	tmpSub.setAsutusKood(tmpOrg.getRegistrikood());
	                    	if ((bodyData.allyksused != null) && (bodyData.allyksused.size() > 0)) {
                            	boolean found = false;
                            	for (ShortName sn : bodyData.allyksused) {
                            		if (CommonMethods.stringsEqualIgnoreNull(tmpSub.getAsutusKood(), sn.getOrgCode())
                            			&& CommonMethods.stringsEqualIgnoreNull(tmpSub.getLyhinimetus(), sn.getShortName())) {
                            			found = true;
                            			break;
                            		}
                            	}
                            	if (found) {
                            		subdivisionList.add(tmpSub);
                            	}
                            } else {
                            	// Tagastame all�ksuste nimekirja �ksnes juhul, kui
                            	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
                            	if (bodyData.getParametesSpecified()) {
                            		subdivisionList.add(tmpSub);
                            	}
                            }
	                    }
	                    
	                    ArrayList<Ametikoht> orgOccupations = Ametikoht.getList(tmpOrg.getId(), "", conn);
	                    for (int j = 0; j < orgOccupations.size(); j++) {
		                    Ametikoht tmpOccupation = orgOccupations.get(j);
		                    tmpOccupation.setAsutusKood(tmpOrg.getRegistrikood());
		                    if ((bodyData.ametikohad != null) && (bodyData.ametikohad.size() > 0)) {
	                        	boolean found = false;
	                        	for (ShortName sn : bodyData.ametikohad) {
	                        		if (CommonMethods.stringsEqualIgnoreNull(tmpOccupation.getAsutusKood(), sn.getOrgCode())
	                        			&& CommonMethods.stringsEqualIgnoreNull(tmpOccupation.getLyhinimetus(), sn.getShortName())) {
	                        			found = true;
	                        			break;
	                        		}
	                        	}
	                        	if (found) {
	                        		occupationList.add(tmpOccupation);
	                        	}
	                        } else {
                            	// Tagastame ametikohtade nimekirja �ksnes juhul, kui
                            	// p�ringu sisendparameetrid ei olnud t�iesti t�hjad
                            	if (bodyData.getParametesSpecified()) {
                            		occupationList.add(tmpOccupation);
                            	}
	                        }
	                    }
	                }
	            } else {
	            	logger.debug("Request bodyData does not contain a list of 'asutused'.");
	                // Tagastame nimekirja k�igist seotud asutustest
	            	organizationList = Asutus.getList(conn);
	            	subdivisionList = Allyksus.getList(0, "", conn);
	            	occupationList = Ametikoht.getList(0, "", conn);
	            }
	            
	            // Kui k�rgemalseisva asutuse ID on m��ratud, siis
	            // kirjutame selle alusel k�rgmalseisva asutuse koodi �le.
	            for (Asutus o : organizationList) {
	            	if (o.getKsAsutuseID() > 0) {
	            		Asutus ks = new Asutus(o.getKsAsutuseID(), conn);
	            		o.setKsAsutuseKood(ks.getRegistrikood());
	            	}
	            }
	        }
	        
	        // Filtreerime v�lja etteantud kriteeriumitele vastavad asutused
	        logger.debug("Filtreerime v�lja etteantud kriteeriumitele vastavad asutused.");
	        if (bodyData.vastuvotmataDokumenteOotel || (bodyData.vahetatudDokumenteKuni >= 0) || (bodyData.vahetatudDokumenteVahemalt >= 0)) {
	            int i = 0;
	            AsutuseStatistika stat = null;
	            boolean remove = false;
	            while (i < organizationList.size()) {
	                if (Settings.Server_RunOnClientDatabase) {
	                    stat = new AsutuseStatistika();
	                    stat.setVahetatudDokumente(UnitCredential.getExchangedDocumentsCount(organizationList.get(i).getId(), hostOrgSettings));
	                    stat.setVastuvotmataDokumente(0);
	                } else {
	                	logger.debug("Getting insititution statistics.");
	                    stat = AsutuseStatistika.getByOrgID(organizationList.get(i).getId(), conn);
	                }
	                if (stat == null) {
	                	logger.warn("DVK tarkvaraline viga: Viga asutuse statistika lugemisel!");
	                    throw new AxisFault("DVK tarkvaraline viga: Viga asutuse statistika lugemisel!");
	                } else {
	                	
	                	logger.debug("Checking institution statistics.");
	                	logger.debug("Vahetatud dokumente: " + stat.getVahetatudDokumente());
	                	logger.debug("Vastuvotmata dokumente: " + stat.getVastuvotmataDokumente());
	                	
	                    remove = false;
	                    if (bodyData.vastuvotmataDokumenteOotel) {
	                        remove = remove || (stat.getVastuvotmataDokumente() < 1);
	                    }
	                    if (bodyData.vahetatudDokumenteVahemalt > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() < bodyData.vahetatudDokumenteVahemalt);
	                    }
	                    if (bodyData.vahetatudDokumenteKuni > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() > bodyData.vahetatudDokumenteKuni);
	                    }
	                    
	                    if (remove) {
	                    	organizationList.remove(i);
	                    } else {
	                        ++i;
	                    }
	                }
	            }
	            
	            // All�ksuste listi filtreerimine
	            logger.debug("All�ksuste listi filtreerimine.");
	            i = 0;
	            while (i < subdivisionList.size()) {
	                if (Settings.Server_RunOnClientDatabase) {
	                    stat = new AsutuseStatistika();
	                    stat.setVahetatudDokumente(UnitCredential.getExchangedDocumentsCount(organizationList.get(i).getId(), hostOrgSettings));
	                    stat.setVastuvotmataDokumente(0);
	                } else {
	                	logger.debug("Serveri andmebaasist.");
	                    stat = AsutuseStatistika.getBySubdivisionId(subdivisionList.get(i).getAsutusID(), subdivisionList.get(i).getID(), conn);
	                }
	                if (stat == null) {
	                	logger.warn("DVK tarkvaraline viga: Viga all�ksuse statistika lugemisel!");
	                    throw new AxisFault("DVK tarkvaraline viga: Viga all�ksuse statistika lugemisel!");
	                } else {
	                    remove = false;
	                    if (bodyData.vastuvotmataDokumenteOotel) {
	                        remove = remove || (stat.getVastuvotmataDokumente() < 1);
	                    }
	                    if (bodyData.vahetatudDokumenteVahemalt > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() < bodyData.vahetatudDokumenteVahemalt);
	                    }
	                    if (bodyData.vahetatudDokumenteKuni > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() > bodyData.vahetatudDokumenteKuni);
	                    }
	                    
	                    if (remove) {
	                    	subdivisionList.remove(i);
	                    } else {
	                        ++i;
	                    }
	                }
	            }
	            
	            // Ametikohtade listi filtreerimine
	            i = 0;
	            while (i < occupationList.size()) {
	                if (Settings.Server_RunOnClientDatabase) {
	                    stat = new AsutuseStatistika();
	                    stat.setVahetatudDokumente(UnitCredential.getExchangedDocumentsCount(organizationList.get(i).getId(), hostOrgSettings));
	                    stat.setVastuvotmataDokumente(0);
	                } else {
	                    stat = AsutuseStatistika.getByOccupationId(occupationList.get(i).getAsutusID(), occupationList.get(i).getID(), conn);
	                }
	                if (stat == null) {
	                    throw new AxisFault("DVK tarkvaraline viga: Viga all�ksuse statistika lugemisel!");
	                } else {
	                    remove = false;
	                    if (bodyData.vastuvotmataDokumenteOotel) {
	                        remove = remove || (stat.getVastuvotmataDokumente() < 1);
	                    }
	                    if (bodyData.vahetatudDokumenteVahemalt > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() < bodyData.vahetatudDokumenteVahemalt);
	                    }
	                    if (bodyData.vahetatudDokumenteKuni > -1) {
	                        remove = remove || (stat.getVahetatudDokumente() > bodyData.vahetatudDokumenteKuni);
	                    }
	                    
	                    if (remove) {
	                    	occupationList.remove(i);
	                    } else {
	                        ++i;
	                    }
	                }
	            }
	        }
	        
	        logger.debug("Creating response file.");
	        
	        if(organizationList != null && organizationList.size() > 0) {
	        	for(Asutus a: organizationList) {
	        		logger.debug("Asutuse registrikood: " + a.getRegistrikood());
	        		logger.debug("Asutuse nimetus: " + a.getNimetus());
	        	}
	        }
	        
	        if(subdivisionList != null && subdivisionList.size() > 0) {
	        	for(Allyksus a: subdivisionList) {
	        		logger.debug("All�ksuse l�hinimetus: " + a.getLyhinimetus());
	        		logger.debug("All�ksuse nimetus: " + a.getNimetus());
	        	}
	        }
	        
	        if(occupationList != null && occupationList.size() > 0) {
	        	for(Ametikoht a: occupationList) {
	        		logger.debug("Ametikoha l�hinimetus: " + a.getLyhinimetus());
	        		logger.debug("Ametikoht nimetus: " + a.getNimetus());
	        	}
	        }
	        
	        // Koostame XML faili
	        result.createResponseFile(organizationList, subdivisionList, occupationList, user.getOrganizationCode());
    	} catch (AxisFault fault) {
    		throw fault;
    	} catch (Exception ex) {
    		logger.error(ex.getMessage(), ex);
    	}
    	
        return result;
    }
}
