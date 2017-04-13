package dvk.client.iostructures;

import dvk.core.CommonStructures;

/**
 * @author Hendrik Pärna
 * @since 1.04.14
 */
public class AditGetSendStatusV1Body implements SOAPBodyOverride {
    public String keha;

    public AditGetSendStatusV1Body() {
        keha = "";
    }

    /**
     * <amet:getSendStatus>
         <keha>
         <documendid href="dokumendid"/>
         </keha>
       </amet:getSendStatus>
     *
     * @return
     */
    public String getBodyContentsAsText() {
        return "<adit:getSendStatus " + CommonStructures.NS_ADIT_DECLARATION + "><keha><documendid href=\"cid:" + keha + "\"/></keha></adit:getSendStatus>";
    }
}