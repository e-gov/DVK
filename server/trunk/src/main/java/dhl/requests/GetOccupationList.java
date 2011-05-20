package dhl.requests;

import dhl.iostructures.getOccupationListRequestType;
import dhl.iostructures.getOccupationListResponseType;
import dhl.iostructures.getOccupationListV2RequestType;
import dhl.iostructures.getOccupationListV2ResponseType;
import dhl.users.Ametikoht;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.core.AttachmentExtractionResult;
import dvk.core.CommonMethods;
import java.sql.Connection;
import java.util.ArrayList;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

public class GetOccupationList {

	private static Logger logger = Logger.getLogger(GetOccupationList.class);

	public static getOccupationListResponseType V1(org.apache.axis.MessageContext context, Connection conn) throws AxisFault {

		logger.info("GetOccupationList.V1 invoked.");

		getOccupationListResponseType result = new getOccupationListResponseType();

        // Laeme päringu keha endale sobivasse andmestruktuuri
        getOccupationListRequestType bodyData = getOccupationListRequestType.getFromSOAPBody(context);
        result.paring = bodyData;

        // Leiame andmebaasist soovitud ametikohad
        ArrayList<Ametikoht> list = new ArrayList<Ametikoht>();
        if (bodyData != null) {
            for (int i = 0; i < bodyData.asutused.length; ++i) {
                Asutus tmpOrg = new Asutus();
                tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                ArrayList<Ametikoht> subList = Ametikoht.getList(tmpOrg.getId(), null, conn);
                for (int j = 0; j < subList.size(); ++j) {
                    subList.get(j).setAsutusKood(bodyData.asutused[i]);
                }
                list.addAll(subList);
            }
        }

        result.ametikohad = list;
        return result;
    }

    public static getOccupationListV2ResponseType V2(org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws Exception {

    	logger.info("GetOccupationList.V2 invoked.");

    	getOccupationListV2ResponseType result = new getOccupationListV2ResponseType();

        // Laeme päringu keha endale sobivasse andmestruktuuri
        getOccupationListV2RequestType bodyData = getOccupationListV2RequestType.getFromSOAPBody(context);
        result.paring = bodyData;

        // Laeme sisendparameetrid SOAP sõnumi manuses asuvast XML failist
        AttachmentExtractionResult exResult = CommonMethods.getExtractedFileFromAttachment(context, bodyData.asutusedHref);
        result.dataMd5Hash = exResult.getAttachmentHash();
        bodyData.loadParametersFromXML(exResult.getExtractedFileName());

        // Leiame andmebaasist soovitud ametikohad
        ArrayList<Ametikoht> list = new ArrayList<Ametikoht>();
        if (bodyData != null) {
            for (int i = 0; i < bodyData.asutused.length; ++i) {
                Asutus tmpOrg = new Asutus();
                tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                ArrayList<Ametikoht> subList = Ametikoht.getList(tmpOrg.getId(), null, conn);
                for (int j = 0; j < subList.size(); ++j) {
                    subList.get(j).setAsutusKood(bodyData.asutused[i]);
                }
                list.addAll(subList);
            }
        }

        // Koostame XML faili
        result.createResponseFile(list, user.getOrganizationCode());
        return result;
    }
}
