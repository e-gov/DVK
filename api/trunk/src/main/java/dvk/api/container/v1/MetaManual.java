package dvk.api.container.v1;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import dvk.api.container.SaatjaDefineeritud;

public class MetaManual extends dvk.api.container.MetaManual
{
	private Date saatjaKuupaev;
	private List<SaatjaDefineeritud> saatjadDefineeritud;

	public Date getSaatjaKuupaev() {
		return saatjaKuupaev;
	}

	public void setSaatjaKuupaev(Date saatjaKuupaev) {
		this.saatjaKuupaev = saatjaKuupaev;
	}

	public List<SaatjaDefineeritud> getSaatjadDefineeritud() {
		return saatjadDefineeritud;
	}

	public void setSaatjadDefineeritud(List<SaatjaDefineeritud> saatjadDefineeritud) {
		this.saatjadDefineeritud = saatjadDefineeritud;
	}

	public void createList(boolean saatjadDefineeritud) {
		if (saatjadDefineeritud) {
			if (this.saatjadDefineeritud == null) {
				this.saatjadDefineeritud = new ArrayList<SaatjaDefineeritud>();
			}
		}
	}
}
