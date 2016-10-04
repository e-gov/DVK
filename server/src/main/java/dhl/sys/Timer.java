package dhl.sys;

import dvk.core.CommonMethods;
import dvk.core.Settings;

public class Timer {
    private long startTime;

    public Timer() {
        startTime = 0;
    }

    public void reset() {
        startTime = System.currentTimeMillis();
    }

    public void markElapsed(String message) {
        if ((Settings.PerformanceLogFile != null) && (Settings.PerformanceLogFile.length() > 0)) {
            String elapsed = String.valueOf(System.currentTimeMillis() - startTime) + " ms";
            Runtime r = Runtime.getRuntime();
            String memUsed = "; Used memory: " + String.valueOf((r.totalMemory() - r.freeMemory()) / 1024 / 1024) + " MB";
            CommonMethods.writeToFile(Settings.PerformanceLogFile, (message + ": " + elapsed + memUsed + "\r\n").getBytes());
        }
    }
}
