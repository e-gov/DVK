package dvk.api.ml;

import dvk.api.SelectCriteria;

import java.math.BigDecimal;

public class SelectCriteriaOccupation extends SelectCriteria {
    @SuppressWarnings("unused")
    private BigDecimal occupationCode;
    @SuppressWarnings("unused")
    private String occupationName;
    @SuppressWarnings("unused")
    private String orgCode;

    public void setOccupationCode(BigDecimal occupationCode) {
        this.occupationCode = occupationCode;
    }

    public void setOccupationName(String occupationName) {
        this.occupationName = occupationName;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

}
