package dvk.client.iostructures;

import java.util.ArrayList;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.client.businesslayer.DhlCapability;
import dvk.client.businesslayer.Occupation;
import dvk.client.businesslayer.Subdivision;

public class GetSendingOptionsV3ResponseType {
	public ArrayList<DhlCapability> asutused;
	public ArrayList<Subdivision> allyksused;
	public ArrayList<Occupation> ametikohad;
	
	public GetSendingOptionsV3ResponseType() {
		this.asutused = new ArrayList<DhlCapability>();
		this.allyksused = new ArrayList<Subdivision>();
		this.ametikohad = new ArrayList<Occupation>();
	}
	
	public static GetSendingOptionsV3ResponseType fromXML(Element rootElement) {
		GetSendingOptionsV3ResponseType result = new GetSendingOptionsV3ResponseType();
		
		NodeList nList = rootElement.getElementsByTagName("keha");
        if (nList.getLength() > 0) {
        	Node n = nList.item(0);
        	
        	nList = ((Element) n).getElementsByTagName("asutused");
        	if (nList.getLength() > 0) {
	            Node msgBodyNode = nList.item(0);
	            if (msgBodyNode != null) {
	                nList = ((Element)msgBodyNode).getElementsByTagName("asutus");
	                for (int i = 0; i < nList.getLength(); ++i) {
	                	DhlCapability item = DhlCapability.fromXML((Element)nList.item(i));
	                    if (item != null) {
	                        result.asutused.add(item);
	                    }
	                }
	            }
        	}
        	
        	nList = ((Element) n).getElementsByTagName("allyksused");
        	if (nList.getLength() > 0) {
	            Node msgBodyNode = nList.item(0);
	            if (msgBodyNode != null) {
	                nList = ((Element)msgBodyNode).getElementsByTagName("allyksus");
	                for (int i = 0; i < nList.getLength(); ++i) {
	                    Subdivision item = Subdivision.fromXML((Element)nList.item(i));
	                    if (item != null) {
	                        result.allyksused.add(item);
	                    }
	                }
	            }
        	}
        	
        	nList = ((Element) n).getElementsByTagName("ametikohad");
        	if (nList.getLength() > 0) {
	            Node msgBodyNode = nList.item(0);
	            if (msgBodyNode != null) {
	                nList = ((Element)msgBodyNode).getElementsByTagName("ametikoht");
	                for (int i = 0; i < nList.getLength(); ++i) {
	                    Occupation item = Occupation.fromXML((Element)nList.item(i));
	                    if (item != null) {
	                        result.ametikohad.add(item);
	                    }
	                }
	            }
        	}
        }
        
        return result;
	}
}
