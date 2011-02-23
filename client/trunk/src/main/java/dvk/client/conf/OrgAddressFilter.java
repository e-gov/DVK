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
    
    private boolean getCodesSet() {
    	return ((this.m_subdivisionCode != null) && (this.m_subdivisionCode.length() > 0)
    			|| (this.m_occupationCode != null) && (this.m_occupationCode.length() > 0));
    }
    
    private boolean getIdsSet() {
    	return ((this.m_subdivisionId > 0) || (this.m_occupationId > 0));
    }
    
    /**
     * Näitab, kas antud filter on reaalselt kasutatav (korrektselt seadistatud)
     */
    public boolean isValidFilter() {
    	return (this.getCodesSet() || this.getIdsSet());
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
    	if (this.isValidFilter() == true) {
    		for (MessageRecipient recipient : fullList) {
    			// Aadressandmetes on sõltuvalt konteineri versioonist antud
    			// kas allüksuse/ametikoha ID (ver 1) või lühinimetus (ver 2).
    			// Filtri andmetes on potentsiaalselt olemas mõlemad variandid.
    			//
    			// Seega tuvastame aadressandmete järgi, kas filtreerida ID-de
    			// või lühinimetuste järgi.
    			
    			if (((recipient.getRecipientDivisionCode() != null) && (recipient.getRecipientDivisionCode().length() > 0))
    				|| ((recipient.getRecipientPositionCode() != null) && (recipient.getRecipientPositionCode().length() > 0))) {
        			
    				if (((this.getSubdivisionCode() == null) || (this.getSubdivisionCode().length() < 1)
        	        	|| this.getSubdivisionCode().equalsIgnoreCase("*")
        	        	|| CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientDivisionCode(), this.getSubdivisionCode()))
        	        	&& ((this.getOccupationCode() == null) || (this.getOccupationCode().length() < 1)
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
    	}
    	return result;
    }
}
