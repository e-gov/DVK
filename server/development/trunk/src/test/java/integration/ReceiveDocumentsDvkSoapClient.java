package integration;

import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axis2.client.Options;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Hendrik Pärna
 * @since 18.12.13
 */
public class ReceiveDocumentsDvkSoapClient extends AbstractDvkServiceSoapClient {

    public ReceiveDocumentsDvkSoapClient(Options options) {
       super(options);
    }

    @Override
    protected Map<String, OMNamespace> addNamespaces() {
        return new HashMap<String, OMNamespace>();
    }

    @Override
    protected OMElement createMessageBody() {
        //message body
        OMElement receiveDocuments = fac.createOMElement("receiveDocuments", namespaces.get("dhlNs"));
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement arv = fac.createOMElement("arv", null);
        OMAttribute attID = fac.createOMAttribute("xsi:type", null, "xsd:integer");
        arv.addAttribute(attID);
        arv. setText("1");
        elKeha.addChild(arv);
        receiveDocuments.addChild(elKeha);
        return receiveDocuments;
    }
}
