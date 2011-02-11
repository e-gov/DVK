package dhl.iostructures;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import dvk.core.CommonMethods;
import dvk.core.ShortName;

import javax.xml.soap.SOAPBody;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSendingOptionsV3RequestType {
	static Logger logger = Logger.getLogger(getSendingOptionsV3RequestType.class.getName());
	public String kehaHref;
    public String[] asutused;
    public List<ShortName> allyksused;
    public List<ShortName> ametikohad;
    public String vahetatudDokumenteVahemaltStr;
    public String vahetatudDokumenteKuniStr;
    public String vastuvotmataDokumenteOotelStr;
    public int vahetatudDokumenteVahemalt;
    public int vahetatudDokumenteKuni;
    public boolean vastuvotmataDokumenteOotel;
    
    public boolean getParametesSpecified() {
    	return ((this.asutused != null) && (this.asutused.length > 0))
		|| ((this.allyksused != null) && (this.allyksused.size() > 0))
		|| ((this.ametikohad != null) && (this.ametikohad.size() > 0))
		|| (this.vahetatudDokumenteVahemalt >= 0)
		|| (this.vahetatudDokumenteKuni >= 0)
		|| this.vastuvotmataDokumenteOotel;
    }

    public getSendingOptionsV3RequestType() {
    	kehaHref = "";
        
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
                getSendingOptionsV3RequestType result = new getSendingOptionsV3RequestType();
                result.kehaHref = bodyNode.getAttribute("href");
                if (result.kehaHref.startsWith("cid:")) {
                    result.kehaHref = result.kehaHref.replaceFirst("cid:","");
                }
                return result;
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
            NodeList nodes = xmlDoc.getElementsByTagName("keha");
            if (nodes.getLength() > 0) {
                Element el = (Element)nodes.item(0);
                
                // List of organizations
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
                
                // List of subdivisions
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
                
                // List of occupations
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
                
                // Only organizations that have incoming documents waiting for download
                nodes = el.getElementsByTagName("vastuvotmata_dokumente_ootel");
                if (nodes.getLength() > 0) {
                	Element el1 = (Element)nodes.item(0);
                    this.vastuvotmataDokumenteOotelStr = CommonMethods.getNodeText(el1);
                    if ((!this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("")) && !this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("0") && !this.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("false")) {
                        this.vastuvotmataDokumenteOotel = true;
                    }
                }

                // Only organizations that have exchanged at least N documents
                nodes = el.getElementsByTagName("vahetatud_dokumente_vahemalt");
                if (nodes.getLength() > 0) {
                	Element el1 = (Element)nodes.item(0);
                    this.vahetatudDokumenteVahemaltStr = CommonMethods.getNodeText(el1);
                    this.vahetatudDokumenteVahemalt = Integer.parseInt(this.vahetatudDokumenteVahemaltStr);
                }

                // Only organizations that have exchanged up to N documents
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
