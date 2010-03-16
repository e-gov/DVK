package dvk.api.container.v1;

import dvk.api.container.XmlBlock;

public class SignedDoc extends XmlBlock
{
	protected String fileFormat;
	protected String version;
	protected String format;
	protected String fileContentType;
	protected String fileId;
	protected String fileMimeType;
	protected String fileSize;
	protected String fileBase64Content;
	private final static String ddocNamesapce = "http://www.sk.ee/DigiDoc/v1.3.0#";

	public boolean isContentNull() {
		return fileBase64Content == null;
	}

	public String getFileFormat() {
		return fileFormat;
	}

	public void setFileFormat(String format) {
		this.fileFormat = format;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String getFileContentType() {
		return fileContentType;
	}

	public void setFileContentType(String fileContentType) {
		this.fileContentType = fileContentType;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String getFileMimeType() {
		return fileMimeType;
	}

	public void setFileMimeType(String fileMimeType) {
		this.fileMimeType = fileMimeType;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileBase64Content() {
		return fileBase64Content;
	}

	public void setFileBase64Content(String fileBase64Content) {
		this.fileBase64Content = fileBase64Content;
	}

	public String getDdocNamespace() {
		return ddocNamesapce;
	}

	public void setDdocNamespace(String xmlns) {
	}

	public String getDdocNamespaceCopy() {
		return ddocNamesapce;
	}

	public void setDdocNamespaceCopy(String xmlns) {
	}
}
