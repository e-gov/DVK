package dvk.api.container;

import java.util.Date;

public class SignatureInfo
{
	private Date sigantureDate;
	private Date signatureTime;

	public Date getSigantureDate() {
		return sigantureDate;
	}

	public void setSigantureDate(Date sigantureDate) {
		this.sigantureDate = sigantureDate;
	}

	public Date getSignatureTime() {
		return signatureTime;
	}

	public void setSignatureTime(Date signatureTime) {
		this.signatureTime = signatureTime;
	}

}
