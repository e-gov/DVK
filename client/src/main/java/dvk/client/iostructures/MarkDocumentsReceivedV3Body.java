package dvk.client.iostructures;

import java.util.ArrayList;
import java.util.Date;

import org.apache.log4j.Logger;

import dvk.client.businesslayer.DhlMessage;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Fault;

public class MarkDocumentsReceivedV3Body implements SOAPBodyOverride {
	private static Logger logger = Logger.getLogger(MarkDocumentsReceivedV3Body.class);
	
    public ArrayList<Integer> dokumendidIdList;
    public ArrayList<DhlMessage> dokumendidObjectList;
    public int vastuvotjaStaatusId;
    public Fault vastuvotjaVeateade;
    public String metaXml;
    public String kaust;
    public String edastusID;
    public String allyksuseLyhinimetus;
    public String ametikohaLyhinimetus;
    public Date staatuseMuutmiseAeg;

    public MarkDocumentsReceivedV3Body() {
    	dokumendidIdList = null;
    	dokumendidObjectList = null;
    	vastuvotjaStaatusId = 0;
    	vastuvotjaVeateade = null;
    	metaXml = "";
        kaust = "";
        edastusID = "";
        allyksuseLyhinimetus = "";
        ametikohaLyhinimetus = "";
        staatuseMuutmiseAeg = null;
    }

    public String getBodyContentsAsText() {
    	
    	logger.debug("Constructing SOAP body for MarkDocumentsReceivedV3Body.");
    	
        StringBuilder sb = new StringBuilder(10240);
        sb.append("<dhl:markDocumentsReceived " + CommonStructures.NS_DHL_DECLARATION + "><keha>");
        
        if ((dokumendidIdList != null) && (dokumendidIdList.size() > 0)) {
        	logger.debug("Using dokumendidIdList.");
        	sb.append("<dokumendid>");
	        for (int i = 0; i < dokumendidIdList.size(); ++i) {
		        sb.append("<item>");
		        sb.append("<dhl_id>" + String.valueOf(dokumendidIdList.get(i)) + "</dhl_id>");		        
		        sb.append("<vastuvotja_staatus_id>" + String.valueOf(vastuvotjaStaatusId) + "</vastuvotja_staatus_id>");
		        if (vastuvotjaVeateade != null) {
		        	sb.append(vastuvotjaVeateade.toXML());
		        }
		        sb.append("<metaxml>" + metaXml + "</metaxml>");
		        if (staatuseMuutmiseAeg != null) {
		        	sb.append("<staatuse_muutmise_aeg>" + CommonMethods.getDateISO8601(staatuseMuutmiseAeg) + "</staatuse_muutmise_aeg>");
		        }
		        sb.append("</item>");
	        }
	        sb.append("</dokumendid>");
        } else if ((dokumendidObjectList != null) && (dokumendidObjectList.size() > 0)) {
        	logger.debug("Using dokumendidObjectList.");
        	sb.append("<dokumendid>");
	        for (int i = 0; i < dokumendidObjectList.size(); ++i) {
	        	DhlMessage tmpMessage = dokumendidObjectList.get(i);
		        sb.append("<item>");
		        sb.append("<dhl_id>" + String.valueOf(tmpMessage.getDhlID()) + "</dhl_id>");
		        sb.append("<dokument_guid>" + tmpMessage.getDhlGuid() + "</dokument_guid>");
		        sb.append("<vastuvotja_staatus_id>" + String.valueOf(tmpMessage.getRecipientStatusID()) + "</vastuvotja_staatus_id>");
		        if (tmpMessage.getFault() != null) {
		        	sb.append(tmpMessage.getFault().toXML());
		        }
		        sb.append("<metaxml>" + tmpMessage.getMetaXML() + "</metaxml>");
		        if (staatuseMuutmiseAeg != null) {
		        	sb.append("<staatuse_muutmise_aeg>" + CommonMethods.getDateISO8601(staatuseMuutmiseAeg) + "</staatuse_muutmise_aeg>");
		        }
		        sb.append("</item>");
	        }
	        sb.append("</dokumendid>");
        }
        
        if ((kaust != null) && (kaust.length() > 0)) {
        	sb.append("<kaust>" + kaust + "</kaust>");
        }
        
        if ((edastusID != null) && (edastusID.length() > 0)) {
        	sb.append("<edastus_id>" + edastusID + "</edastus_id>");
        }
        
        if ((allyksuseLyhinimetus != null) && (allyksuseLyhinimetus.length() > 0)) {
        	sb.append("<allyksuse_lyhinimetus>" + allyksuseLyhinimetus + "</allyksuse_lyhinimetus>");
        }
        
        if ((ametikohaLyhinimetus != null) && (ametikohaLyhinimetus.length() > 0)) {
        	sb.append("<ametikoha_lyhinimetus>" + ametikohaLyhinimetus + "</ametikoha_lyhinimetus>");
        }
        
        sb.append("</keha></dhl:markDocumentsReceived>");
        return sb.toString();
    }
}
