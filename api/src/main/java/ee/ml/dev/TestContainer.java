package ee.ml.dev;

import java.io.File;
import java.util.List;

import dvk.api.container.v1.ContainerVer1;
import dvk.api.container.v2.ContainerVer2;
import dvk.api.container.v2.Fail;
import dvk.api.ml.Util;

public class TestContainer {
	/**
	 * @param args
	 */
	public static void main(String[] args) {
	    testXmlContainerVer1();
	    //testXmlContainerVer2();
	}

	public static void testXmlContainerVer1() {
		//final String file = "./test/dvk_container_v1_sample.xml";
		final String file = "./test/dvk_container_v1_sample_multifile.xml";
		final String outfile = "./test/dvk_container_v1.test.xml";

		try {
			String xml = Util.readFileContent(file);
			//
			ContainerVer1 container = ContainerVer1.parse(xml);
			container.save2File(outfile);
			// String xml = container.getContent();
			//
			System.out.println("Success");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void testXmlContainerVer2() {
		final String outfile = "./test/generated_container_v2.out.xml";
		final String filePlainText = "./test/PlainText.txt";
		final String fileDecoded = "./test/PlainText.decoded.txt";

		boolean generateOutput = false;

		if (generateOutput) {
			System.out.println("Encode file");
			ContainerVer2 container2 = new ContainerVer2();
			container2.createDescendants(false, false, false, false, true);
			List<Fail> files = container2.getFailideKonteiner().createList();
			//
			Fail fail = new Fail();
			fail.setFile(new File(filePlainText));
			files.add(fail);
			//
			try {
				// String str = container2.getContent();
				container2.save2File(outfile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			System.out.println("Success");
		} else {
			File file = new File(outfile);

			if (!file.exists()) {
				System.out.println("File was not found " + file);
				return;
			}

			System.out.println("Decode file");

			try {
				ContainerVer2 container2 = ContainerVer2.parse(Util.readFileContent(outfile));

				if (container2.hasFailideKonteiner() && container2.getFailideKonteiner().hasFailid()) {
					Fail fail = container2.getFailideKonteiner().getFailid().get(0);

					System.out.println("decode file " + fail.getFailNimi());
					Util.writeFileContent(fileDecoded, fail.getDecodedContent());
				}

				System.out.println("Success");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

}
