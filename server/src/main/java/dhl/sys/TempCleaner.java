package dhl.sys;

import java.io.File;
import java.io.FilenameFilter;

import dvk.core.CommonMethods;

public class TempCleaner implements Runnable {
    Thread t;

    public void init() {
        t = new Thread(this);
        t.start();
    }

    public void run() {
        // Kustutame üle 10 minuti vanused failid
        File tempPath = new File(System.getProperty("java.io.tmpdir", ""));
        if ((tempPath != null) && tempPath.exists() && tempPath.isDirectory()) {
            FilenameFilter filter = new FilenameFilter() {
                    public boolean accept(final File dir, final String name) {
                        return name.startsWith("dhl_");
                    }
                };

            File[] files = tempPath.listFiles(filter);
            if ((files != null) && (files.length > 0)) {
                for (int i = 0; i < files.length; ++i) {
                    try {
                        if ((System.currentTimeMillis() - files[i].lastModified()) > (1000 * 60 * 10)) {
                            files[i].delete();
                        }
                    } catch (Exception ex) {
                        CommonMethods.logError(ex, this.getClass().getName(), "run");
                    }
                }
            }
        }
    }
}
