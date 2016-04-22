package dvk.api.container.v2;

import dvk.api.container.Metaxml;

public class Ajalugu extends dvk.api.container.Ajalugu<Metainfo, Transport, Metaxml>
{
	public void createDescendants(boolean metainfo, boolean transport, boolean metaxml) {
		if (metainfo) {
			if (getMetainfo() == null) {
				setMetainfo(new Metainfo());
			}
		}

		if (transport) {
			if (getTransport() == null) {
				setTransport(new Transport());
			}
		}

		if (metaxml) {
			if (getMetaxml() == null) {
				setMetaxml(new Metaxml());
			}
		}
	}
}
