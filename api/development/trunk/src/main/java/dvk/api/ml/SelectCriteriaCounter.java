package dvk.api.ml;

import dvk.api.SelectCriteria;

import java.math.BigDecimal;

public class SelectCriteriaCounter extends SelectCriteria {
    @SuppressWarnings("unused")
    private BigDecimal dhlId;

    public void setDhlId(BigDecimal dhlId) {
        this.dhlId = dhlId;
    }

}
