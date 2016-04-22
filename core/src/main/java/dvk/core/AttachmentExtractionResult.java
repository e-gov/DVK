package dvk.core;

public class AttachmentExtractionResult {
	private String m_extractedFileName;
	private String m_attachmentHash;
	
    public String getExtractedFileName() {
        return this.m_extractedFileName;
    }

    public void setExtractedFileName(String value) {
        this.m_extractedFileName = value;
    }

    public String getAttachmentHash() {
        return this.m_attachmentHash;
    }

    public void setAttachmentHash(String value) {
        this.m_attachmentHash = value;
    }
}
