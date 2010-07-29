package dvk.api.container.v2;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;

import org.apache.log4j.Logger;
import org.exolab.castor.mapping.MappingException;
import org.exolab.castor.xml.MarshalException;
import org.exolab.castor.xml.Marshaller;
import org.exolab.castor.xml.ValidationException;
import dvk.api.container.Container;
import dvk.api.container.Metaxml;
import dvk.api.ml.Util;

public class ContainerVer2 extends Container
{
	
	private static Logger LOG = Logger.getLogger(ContainerVer2.class);
	
	private Transport transport;
	private Metainfo metainfo;
	private Ajalugu ajalugu;
	private Metaxml metaxml;
	private FailideKonteiner failideKonteiner;

	public Transport getTransport() {
		return transport;
	}

	public void setTransport(Transport transport) {
		this.transport = transport;
	}

	public Metainfo getMetainfo() {
		return metainfo;
	}

	public void setMetainfo(Metainfo metainfo) {
		this.metainfo = metainfo;
	}

	public Ajalugu getAjalugu() {
		return ajalugu;
	}

	public void setAjalugu(Ajalugu ajalugu) {
		this.ajalugu = ajalugu;
	}

	public Metaxml getMetaxml() {
		return metaxml;
	}

	public void setMetaxml(Metaxml metaxml) {
		this.metaxml = metaxml;
	}

	public FailideKonteiner getFailideKonteiner() {
		return failideKonteiner;
	}

	public void setFailideKonteiner(FailideKonteiner failid) {
		this.failideKonteiner = failid;
	}

	@Override
	public String getContent() throws MarshalException, ValidationException, IOException, MappingException {
		StringWriter sw = new StringWriter();

		try {
			Marshaller marshaller = createMarshaller(sw);
			pushVersion();
			marshaller.marshal(this);

			return sw.toString();
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw e;
		} finally {
			sw.close();
		}
	}

	@Override
	protected Version getInternalVersion() {
		return Version.Ver2;
	}

	public static ContainerVer2 parse(String xml) throws MappingException, MarshalException, ValidationException, IOException {
		if (Util.isEmpty(xml)) {
			return null;
		}

		StringReader in = new StringReader(xml);

		try {
			return (ContainerVer2) Container.marshal(in, Version.Ver2);
		} finally {
			in.close();
		}
	}

	public static ContainerVer2 parse(Reader reader) throws MappingException, MarshalException, ValidationException, IOException {
		if (reader == null || !reader.ready()) {
			LOG.error("Cannot parse DVK Container: reader not initialized.");
			return null;
		}
		
		return (ContainerVer2) Container.marshal(reader, Version.Ver2);		
	}
	
	public void createDescendants(boolean metainfo, boolean transport, boolean ajalugu, boolean metaxml, boolean failid) {
		if (metainfo) {
			if (this.metainfo == null) {
				this.metainfo = new Metainfo();
			}
		}

		if (transport) {
			if (this.transport == null) {
				this.transport = new Transport();
			}
		}

		if (ajalugu) {
			if (this.ajalugu == null) {
				this.ajalugu = new Ajalugu();
			}
		}

		if (metaxml) {
			if (this.metaxml == null) {
				this.metaxml = new Metaxml();
			}
		}

		if (failid) {
			if (this.failideKonteiner == null) {
				this.failideKonteiner = new FailideKonteiner();
			}
		}
	}

	@Override
	public void setVersion(Integer version) {
		pushVersion();
	}

	private void pushVersion() {
		super.setVersion(2);
	}

	public boolean hasFailideKonteiner() {
		return failideKonteiner != null;
	}
}
