package dvk.api.ml;

import java.math.BigDecimal;

import dvk.api.SelectCriteria;

public class SelectCriteriaSubdivision extends SelectCriteria {
    @SuppressWarnings("unused")
    private BigDecimal subdivisionCode;
    @SuppressWarnings("unused")
    private String subdivisionName;
    @SuppressWarnings("unused")
    private String orgCode;

    public void setSubdivisionCode(BigDecimal subdivisionCode) {
        this.subdivisionCode = subdivisionCode;
    }

    public void setSubdivisionName(String subdivisionName) {
        this.subdivisionName = subdivisionName;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }
}
