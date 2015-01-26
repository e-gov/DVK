package dvk.api.ml;

import dvk.api.DVKAPI.DvkType;
import dvk.api.ISettingsFolderObserver;

import java.lang.reflect.Field;

// Generated 7.02.2010 22:22:31 by Hibernate Tools 3.2.4.GA

/**
 * DhlSettingsFolders generated by hbm2java
 */
public class PojoSettingsFolders implements ISettingsFolderObserver, java.io.Serializable {
    public static class FieldNames {
        public static final String id = "id";
        public static final String settingsId = "settingsId";
        public static final String folderName = "folderName";
    }

    /**
     *
     */
    private static final long serialVersionUID = 6654369459743753823L;
    final static String PojoName = PojoSettingsFolders.class.getName();
    protected long id;
    protected long settingsId;
    protected String folderName;

    public PojoSettingsFolders() {
    }

    public PojoSettingsFolders(long id) {
        this.id = id;
    }

    public long getId() {
        return this.id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFolderName() {
        return this.folderName;
    }

    public void setFolderName(String folderName) {
        this.folderName = folderName;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }

        if (obj == null || !(obj instanceof PojoSettingsFolders)) {
            return false;
        }

        PojoSettingsFolders other = (PojoSettingsFolders) obj;

        return id == other.id;
    }

    public long getSettingsId() {
        return settingsId;
    }

    public void setSettingsId(long settingsId) {
        this.settingsId = settingsId;
    }

    @Override
    public String toString() {
        return Util.getDump(this);
    }

    public void printOutFields() {
        Field[] fields = getClass().getDeclaredFields();
        for (Field f : fields) {
            System.out.println("public final String " + f.getName() + " = \"" + f.getName() + "\";");
        }
    }

    public DvkType getType() {
        return DvkType.SettingsFolder;
    }
}
