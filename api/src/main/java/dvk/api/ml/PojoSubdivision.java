package dvk.api.ml;

import java.lang.reflect.Field;
import java.math.BigDecimal;

// Generated 4.02.2010 13:44:05 by Hibernate Tools 3.2.4.GA

import dvk.api.DVKAPI.DvkType;
import dvk.api.ISubdivisionObserver;

/**
 * DhlSubdivision generated by hbm2java
 */
public class PojoSubdivision implements ISubdivisionObserver, java.io.Serializable {
    public static class FieldNames {
        public static final String subdivisionCode = "subdivisionCode";
        public static final String subdivisionName = "subdivisionName";
        public static final String orgCode = "orgCode";
    }

    final static String PojoName = PojoSubdivision.class.getName();

    /**
     *
     */
    private static final long serialVersionUID = -3367114955092643432L;
    protected BigDecimal subdivisionCode;
    protected String subdivisionName;
    protected String orgCode;

    public PojoSubdivision() {
    }

    public PojoSubdivision(BigDecimal subdivisionCode) {
        this.subdivisionCode = subdivisionCode;
    }

    public PojoSubdivision(BigDecimal subdivisionCode, String subdivisionName, String orgCode) {
        this.subdivisionCode = subdivisionCode;
        this.subdivisionName = subdivisionName;
        this.orgCode = orgCode;
    }

    public BigDecimal getSubdivisionCode() {
        return this.subdivisionCode;
    }

    public void setSubdivisionCode(BigDecimal subdivisionCode) {
        this.subdivisionCode = subdivisionCode;
    }

    public String getSubdivisionName() {
        return this.subdivisionName;
    }

    public void setSubdivisionName(String subdivisionName) {
        this.subdivisionName = subdivisionName;
    }

    public String getOrgCode() {
        return this.orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    @Override
    public PojoSubdivision clone() {
        PojoSubdivision ret = new PojoSubdivision();
        ret.subdivisionCode = subdivisionCode;
        ret.subdivisionName = subdivisionName;
        ret.orgCode = orgCode;

        return ret;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }

        if (obj == null || !(obj instanceof PojoSubdivision)) {
            return false;
        }

        PojoSubdivision other = (PojoSubdivision) obj;

        return Util.hasSameValue(subdivisionCode, other.subdivisionCode) && Util.hasSameValue(subdivisionName, other.subdivisionName)
                && Util.hasSameValue(orgCode, other.orgCode);
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

    public BigDecimal getCode() {
        return subdivisionCode;
    }

    public String getName() {
        return subdivisionName;
    }

    public DvkType getType() {
        return DvkType.Subdivision;
    }
}
