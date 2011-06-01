package dvk.api.container;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.net.URL;

import org.exolab.castor.mapping.Mapping;
import org.exolab.castor.mapping.MappingException;
import org.exolab.castor.xml.MarshalException;
import org.exolab.castor.xml.Marshaller;
import org.exolab.castor.xml.Unmarshaller;
import org.exolab.castor.xml.ValidationException;

import dvk.api.container.v1.ContainerVer1;
import dvk.api.container.v2.ContainerVer2;
import dvk.api.ml.Util;

public abstract class Container
{
	public enum Version {
		Ver1, Ver2
	}

	private Integer version;
	public final static String CastorMappingsFileVer1 = "castor-mapping/dhl.v1.xml";
	public final static String CastorMappingsFileVer2 = "castor-mapping/dhl.v2.xml";

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	private static Mapping mapping;

	private static void prepareVersion(Version version) throws IOException, MappingException {
		if (mapping == null) {
			mapping = new Mapping();

			switch (version) {
				case Ver1:
				    //mapping.loadMapping("./src/main/resources/" + CastorMappingsFileVer1);
				    URL mappingURL = mapping.getClassLoader().getResource(CastorMappingsFileVer1);
					mapping.loadMapping(mappingURL);
					//mapping.loadMapping(CastorMappingsFileVer1);
					break;
				case Ver2:
					URL mappingURL2 = mapping.getClassLoader().getResource(CastorMappingsFileVer2);
					mapping.loadMapping(mappingURL2);
					//mapping.loadMapping(CastorMappingsFileVer2);
					break;
				default:
					throw new RuntimeException("Unexpected version: " + version);
				}
		}
	}

	protected Marshaller createMarshaller(Writer out) throws MappingException, IOException {
		Marshaller marshaller = new Marshaller(out);
		Version version = getInternalVersion();

		prepareVersion(version);

		switch (version)
			{
			case Ver1:
				marshaller.setNamespaceMapping("mm", "http://www.riik.ee/schemas/dhl-meta-manual");
				marshaller.setNamespaceMapping("", "http://www.sk.ee/DigiDoc/v1.3.0#");
				marshaller.setNamespaceMapping("dhl", "http://www.riik.ee/schemas/dhl");
				marshaller.setNamespaceMapping("rkel", "http://www.riik.ee/schemas/dhl/rkel_letter");
				break;

			case Ver2:
				marshaller.setNamespaceMapping("mm", "http://www.riik.ee/schemas/dhl-meta-manual/2010/2");
				marshaller.setNamespaceMapping("ma", "http://www.riik.ee/schemas/dhl-meta-automatic");
				marshaller.setNamespaceMapping("dhl", "http://www.riik.ee/schemas/dhl/2010/2");
				marshaller.setNamespaceMapping("rkel", "http://www.riik.ee/schemas/dhl/rkel_letter");
				break;
			default:
				throw new RuntimeException("Unexpected version: " + version);
			}

		marshaller.setMapping(mapping);

		return marshaller;
	}

	protected static Unmarshaller createUnmarshaller(Version version) throws MappingException, IOException {
		Unmarshaller unmarshaller = null;

		switch (version)
			{
			case Ver1:
				unmarshaller = new Unmarshaller(ContainerVer1.class);
				break;
			case Ver2:
				unmarshaller = new Unmarshaller(ContainerVer2.class);
				break;
			default:
				throw new RuntimeException("Unexpected version: " + version);
			}

		prepareVersion(version);

		unmarshaller.setMapping(mapping);

		return unmarshaller;
	}

	public abstract String getContent() throws MarshalException, ValidationException, IOException, MappingException;

	public void save2File(String filePath) throws MarshalException, ValidationException, IOException, MappingException {
		Util.writeFileContent(filePath, getContent());
	}

	protected abstract Version getInternalVersion();

	public static Container marshal(Reader reader, Version version) throws MappingException, MarshalException,
		ValidationException, IOException {
		Container dhl = null;

		try {
			Unmarshaller unmarshaller = createUnmarshaller(version);
			unmarshaller.setWhitespacePreserve(true);
			dhl = (Container) unmarshaller.unmarshal(reader);
		} catch (RuntimeException e) {
			throw e;
		} finally {
			reader.close();
		}

		return dhl;
	}

}
