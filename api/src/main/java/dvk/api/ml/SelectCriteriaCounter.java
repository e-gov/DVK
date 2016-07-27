package dvk.api.ml;

import java.math.BigDecimal;

import dvk.api.SelectCriteria;

public class SelectCriteriaCounter extends SelectCriteria {
    @SuppressWarnings("unused")
    private BigDecimal dhlId;

    public void setDhlId(BigDecimal dhlId) {
        this.dhlId = dhlId;
    }

}
