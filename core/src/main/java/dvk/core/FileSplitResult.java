package dvk.core;

import java.util.ArrayList;

public class FileSplitResult {
    public String mainFile;
    public ArrayList<String> subFiles;
    
    private int dvkContainerVersion;
    
    public FileSplitResult() {
        mainFile = "";
        subFiles = null;
        this.setDvkContainerVersion(1);
    }

	public int getDvkContainerVersion() {
		return dvkContainerVersion;
	}

	public void setDvkContainerVersion(int dvkContainerVersion) {
		this.dvkContainerVersion = dvkContainerVersion;
	}
}
