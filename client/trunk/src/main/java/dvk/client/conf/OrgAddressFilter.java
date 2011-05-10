package dvk.client.conf;

import java.util.ArrayList;
import dvk.client.businesslayer.MessageRecipient;
import dvk.core.CommonMethods;

public class OrgAddressFilter {
	private int m_subdivisionId;
	private String m_subdivisionCode;
	private int m_occupationId;
	private String m_occupationCode;
	
    public int getSubdivisionId() {
        return this.m_subdivisionId;
    }

    public void setSubdivisionId(int subdivisionId) {
        this.m_subdivisionId = subdivisionId;
    }
	
    public String getSubdivisionCode() {
        return this.m_subdivisionCode;
    }

    public void setSubdivisionCode(String subdivisionCode) {
        this.m_subdivisionCode = subdivisionCode;
    }

    public int getOccupationId() {
        return this.m_occupationId;
    }

    public void setOccupationId(int occupationId) {
        this.m_occupationId = occupationId;
    }
    
    public String getOccupationCode() {
        return this.m_occupationCode;
    }

    public void setOccupationCode(String occupationCode) {
        this.m_occupationCode = occupationCode;
    }
    
    public OrgAddressFilter() {
        clear();
    }

    public void clear() {
        m_subdivisionId = 0;
    	m_subdivisionCode = "";
    	m_occupationId = 0;
        m_occupationCode = "";
    }
    
    public ArrayList<MessageRecipient> getMatchingRecipients(ArrayList<MessageRecipient> fullList) {
    	ArrayList<MessageRecipient> result = new ArrayList<MessageRecipient>();
		for (MessageRecipient recipient : fullList) {
			// Aadressandmetes on sõltuvalt konteineri versioonist antud
			// kas allüksuse/ametikoha ID (ver 1) või lühinimetus (ver 2).
			// Filtri andmetes on potentsiaalselt olemas mõlemad variandid.
			//
			// Seega tuvastame aadressandmete järgi, kas filtreerida ID-de
			// või lühinimetuste järgi.
			
			if (CommonMethods.isNullOrEmpty(recipient.getRecipientDivisionCode())
				&& CommonMethods.isNullOrEmpty(recipient.getRecipientPositionCode())
				&& CommonMethods.isNullOrEmpty(this.getSubdivisionCode())
				&& CommonMethods.isNullOrEmpty(this.getOccupationCode())
				&& (recipient.getRecipientDivisionID() <= 0)
				&& (recipient.getRecipientPositionID() <= 0)
				&& (this.getSubdivisionId() <= 0)
				&& (this.getOccupationId() <= 0)) {
			
				result.add(recipient);
				
			} else if (!CommonMethods.isNullOrEmpty(recipient.getRecipientDivisionCode())
				|| !CommonMethods.isNullOrEmpty(recipient.getRecipientPositionCode())) {
    			
				if ((CommonMethods.isNullOrEmpty(this.getSubdivisionCode())
    	        	|| this.getSubdivisionCode().equalsIgnoreCase("*")
    	        	|| CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientDivisionCode(), this.getSubdivisionCode()))
    	        	&& (CommonMethods.isNullOrEmpty(this.getOccupationCode())
     	        	|| this.getOccupationCode().equalsIgnoreCase("*")
     	        	|| CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientPositionCode(), this.getOccupationCode()))) {
    	        	
					result.add(recipient);
    	        }
			} else {
    			if (((this.getSubdivisionId() <= 0) || (recipient.getRecipientDivisionID() == this.getSubdivisionId()))
    	        	&& ((this.getOccupationId() <= 0) || (recipient.getRecipientPositionID() == this.getOccupationId()))) {
    	        	result.add(recipient);
    	        }
	        }
	    }
    	return result;
    }
}
