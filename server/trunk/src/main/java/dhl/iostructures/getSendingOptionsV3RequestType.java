package dhl.iostructures;

import java.io.File;
import java.util.ArrayList;

import dvk.core.CommonMethods;
import dvk.core.ShortName;

import javax.xml.soap.SOAPBody;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSendingOptionsV3RequestType {
	static Logger logger = Logger.getLogger(getSendingOptionsV3RequestType.class.getName());
	public String parameetridHref;
    public String[] asutused;
    public ArrayList<ShortName> allyksused;
    public ArrayList<ShortName> ametikohad;
    public String vahetatudDokumenteVahemaltStr;
    public String vahetatudDokumenteKuniStr;
    public String vastuvotmataDokumenteOotelStr;
    public int vahetatudDokumenteVahemalt;
    public int vahetatudDokumenteKuni;
    public boolean vastuvotmataDokumenteOotel;
    

    public getSendingOptionsV3RequestType() {
    	parameetridHref = "";
        
        asutused = new String[] { };
        allyksused = new ArrayList<ShortName>();
        ametikohad = new ArrayList<ShortName>();
        vahetatudDokumenteVahemalt = -1;
        vahetatudDokumenteKuni = -1;
        vastuvotmataDokumenteOotel = false;
    }

    public static getSendingOptionsV3RequestType getFromSOAPBody(org.apache.axis.MessageContext context) throws Exception {
        org.apache.axis.Message msg = context.getRequestMessage();
        SOAPBody body = msg.getSOAPBody();
        NodeList msgNodes = body.getElementsByTagName("getSendingOptions");
        if (msgNodes.getLength() > 0) {
            Element msgNode = (Element)msgNodes.item(0);
            NodeList bodyNodes = msgNode.getElementsByTagName("keha");
            if (bodyNodes.getLength() > 0) {
                Element bodyNode = (Element)bodyNodes.item(0);
                NodeList docRefNodes = bodyNode.getElementsByTagName("parameetrid");
                if (docRefNodes.getLength() > 0) {
                    Element docRefNode = (Element)docRefNodes.item(0);
                    getSendingOptionsV3RequestType result = new getSendingOptionsV3RequestType();
                    result.parameetridHref = docRefNode.getAttribute("href");
                    if (result.parameetridHref.startsWith("cid:")) {
                        result.parameetridHref = result.parameetridHref.replaceFirst("cid:","");
                    }
                    return result;
                } else {
                	throw new Exception("Vigane päringu getSendingOptions.V3 keha - puudub element \"parameetrid\".");
                }                
            } else {
            	throw new Exception("Vigane päringu getSendingOptions.V3 keha - puudub element \"keha\".");
            }
        } else {
        	throw new Exception("Vigane päringu getSendingOptions.V3 keha - puudub element \"getSendingOptions\".");
        }
    }
    
    public void loadParametersFromXML(String xmlFile) {
    	if ((xmlFile != null) && (xmlFile.length() > 0) && (new File(xmlFile)).exists()) {
    		Document xmlDoc = CommonMethods.xmlDocumentFromFile(xmlFile, true);
            NodeList nodes = xmlDoc.getElementsByTagName("parameetrid");
            if (nodes.getLength() > 0) {
                Element el = (Element)nodes.item(0);
                
                // Asutuste nimekiri
                nodes = el.getElementsByTagName("asutused");
                if (nodes.getLength() > 0) {
                    Element el1 = (Element)nodes.item(0);
                    nodes = el1.getElementsByTagName("asutus");
                    if (nodes.getLength() > 0) {
                        this.asutused = new String[nodes.getLength()];
                        for (int i = 0; i < nodes.getLength(); ++i) {
                            this.asutused[i] = CommonMethods.getNodeText(nodes.item(i));
                        }
                    }
                }
                
                // Allüksuste nimekiri
                nodes = el.getElementsByTagName("allyksused");
                if (nodes.getLength() > 0) {
                    Element el1 = (Element)nodes.item(0);
                    nodes = el1.getElementsByTagName("allyksus");
                    if (nodes.getLength() > 0) {
                        for (int i = 0; i < nodes.getLength(); ++i) {
                        	ShortName item = new ShortName();
                        	Element el2 = (Element)nodes.item(i);
                        	nodes = el2.getElementsByTagName("asutuse_kood");
                        	if ((nodes != null) && (nodes.getLength() > 0)) {
                        		item.setOrgCode(CommonMethods.getNodeText(nodes.item(0)));
                        	}
                        	nodes = el2.getElementsByTagName("lyhinimetus");
                        	if ((nodes != null) && (nodes.getLength() > 0)) {
                        		item.setOrgCode(CommonMethods.getNodeText(nodes.item(0)));
                        	}
                        	if ((item.getOrgCode() != null) && (item.getOrgCode().length() > 0) && (item.getShortName() != null) && (item.getShortName().length() > 0)) {
                        		this.allyksused.add(item);
                        	}
                        }
                    }
                }
                
                // Ametikohtade nimekiri
                nodes = el.getElementsByTagName("ametikohad");
                if (nodes.getLength() > 0) {
                    Element el1 = (Element)nodes.item(0);
                    nodes = el1.getElementsByTagName("ametikoht");
                    if (nodes.getLength() > 0) {
                        for (int i = 0; i < nodes.getLength(); ++i) {
                        	ShortName item = new ShortName();
                        	Element el2 = (Element)nodes.item(i);
                        	nodes = el2.getElementsByTagName("asutuse_kood");
                        	if ((nodes != null) && (nodes.getLength() > 0)) {
                        		item.setOrgCode(CommonMethods.getNodeText(nodes.item(0)));
                        	}
                        	nodes = el2.getElementsByTagName("lyhinimetus");
                        	if ((nodes != null) && (nodes.getLength() > 0)) {
                        		item.setOrgCode(CommonMethods.getNodeText(nodes.item(0)));
                        	}
                        	if ((item.getOrgCode() != null) && (item.getOrgCode().length() > 0) && (item.getShortName() != null) && (item.getShortName().length() > 0)) {
                        		this.allyksused.add(item);
                        	}
                        }
                    }
                }
                
                // Ainult vastuvõtmist ootavate dokumentidega asutused
                nodes = el.getElementsByTagName("vastuvotmata_dokumente_ootel");
                if (nodes.getLength() > 0) {
                	Element el1 = (Element)nodes.item(0);
                    this.vastuvotmataDokumenteOotelStr = CommonMethods.getNodeText(el1);
                    if ((!this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("")) && !this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("0") && !this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("false")) {
                        this.vastuvotmataDokumenteOotel = true;
                    }
                }

                // Ainult asutused, kes on vahetanud vähemalt N dokumenti
                nodes = el.getElementsByTagName("vahetatud_dokumente_vahemalt");
                if (nodes.getLength() > 0) {
                	Element el1 = (Element)nodes.item(0);
                    this.vahetatudDokumenteVahemaltStr = CommonMethods.getNodeText(el1);
                    this.vahetatudDokumenteVahemalt = Integer.parseInt(this.vahetatudDokumenteVahemaltStr);
                }

                // Ainult asutused, kes on vahetanud kuni N dokumenti
                nodes = el.getElementsByTagName("vahetatud_dokumente_kuni");
                if (nodes.getLength() > 0) {
                	Element el1 = (Element)nodes.item(0);
                    this.vahetatudDokumenteKuniStr = CommonMethods.getNodeText(el1);
                    this.vahetatudDokumenteKuni = Integer.parseInt(this.vahetatudDokumenteKuniStr);
                }
            }
    	}
    }
}
