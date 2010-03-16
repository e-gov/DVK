package dvk.api.container.v1;

public class Metainfo extends dvk.api.container.Metainfo<MetaManual, MetaAutomatic>
{
	public void createDescendants(boolean manual, boolean automatic) {
		if (manual) {
			if (getMetaManual() == null) {
				setMetaManual(new MetaManual());
			}
		}

		if (automatic) {
			if (getMetaAutomatic() == null) {
				setMetaAutomatic(new MetaAutomatic());
			}
		}
	}
}
