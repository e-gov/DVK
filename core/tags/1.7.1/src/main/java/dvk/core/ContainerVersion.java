package dvk.core;

/**
 * @author Hendrik Pärna
 * @since 5.12.13
 */
public enum ContainerVersion {
    VERSION_1_0("1.0"), VERSION_2_0("2.0"), VERSION_2_1("2.1");

    private String version;

    ContainerVersion(String version) {
        this.version = version;
    }

    @Override
    public String toString() {
        return version;
    }

    /**
     * Get corresponding container version enum.
     * @param version input
     * @return correct version
     */
    public static ContainerVersion from(String version) {
        for (ContainerVersion containerVersion: ContainerVersion.values()) {
          if (containerVersion.version.equals(version)) {
             return containerVersion;
          }
        }
        throw new IllegalArgumentException("There is no version " + version + " defined!");
    }
}


