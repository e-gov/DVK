package dvk.core.xroad;

/**
 * This class models XRoadIdentifierType as defined in the related
 * <a href="http://x-road.eu/xsd/identifiers.xsd">XML schema</a>.
 * 
 * @author Levan Kekelidze
 *
 */
public abstract class XRoadIdentifier {
	
	public static final String NAMESPACE_URI = "http://x-road.eu/xsd/identifiers";
	
    public static final String NAMESPACE_PREFIX = "id";
    
    public static final String OBJECT_TYPE_ATTRIBUTE = "objectType";

	protected String xRoadInstance;
	
	protected String memberClass;
	
	protected String memberCode;
	
	protected String subsystemCode;
	
	protected String groupCode;
	
	protected String serviceCode;
	
	protected String serviceVersion;
	
	protected String securityCategoryCode;
	
	protected String serverCode;
	
	/**
	 * Checks if the required fields are filled with data. Each subclass must define its own list of required fields.
	 * <p>
	 * The <b>default</b> list of required fields (XML elements) for each instance of XRoadIdentifier can be checked in the related
	 * <em>XML Schema Definition</em> <a href="http://x-road.eu/xsd/identifiers.xsd">file</a>. But each subclass <em>may</em> define a
	 * custom list according to its requirements.
	 * </p>
	 * 
	 * @return {@code true} if the required fields are filled with data, {@code false} otherwise
	 */
	public abstract boolean isValid();
	
	/**
	 * Checks if <em>all</em> required fields are NOT filled with data.
	 * 
	 * @return {@code true} if the required fields are either empty or {@code null}, {@code false} otherwise
	 */
	public abstract boolean isEmpty();
	
}
