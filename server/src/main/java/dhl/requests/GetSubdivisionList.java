package dhl.requests;

import java.sql.Connection;
import java.util.ArrayList;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

import dhl.exceptions.RequestProcessingException;
import dhl.iostructures.getSubdivisionListRequestType;
import dhl.iostructures.getSubdivisionListResponseType;
import dhl.iostructures.getSubdivisionListV2RequestType;
import dhl.iostructures.getSubdivisionListV2ResponseType;
import dhl.users.Allyksus;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.core.AttachmentExtractionResult;
import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolVersion;

public class GetSubdivisionList {

    private static Logger logger = Logger.getLogger(GetSubdivisionList.class);

    public static getSubdivisionListResponseType V1(org.apache.axis.MessageContext context, Connection conn,
    		XRoadProtocolVersion xRoadProtocolVersion) throws AxisFault, RequestProcessingException {

        logger.info("GetSubdivisionList.V1 invoked.");

        getSubdivisionListResponseType result = new getSubdivisionListResponseType();

        // Laeme päringu keha endale sobivasse andmestruktuuri
        getSubdivisionListRequestType bodyData = getSubdivisionListRequestType.getFromSOAPBody(context);
        if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
        	result.paring = bodyData;
        }

        // Leiame andmebaasist soovitud ametikohad
        ArrayList<Allyksus> list = new ArrayList<Allyksus>();
        if (bodyData != null) {
            for (int i = 0; i < bodyData.asutused.length; ++i) {
                Asutus tmpOrg = new Asutus();
                tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                ArrayList<Allyksus> subList = Allyksus.getList(tmpOrg.getId(), null, conn);
                for (int j = 0; j < subList.size(); ++j) {
                    subList.get(j).setAsutusKood(bodyData.asutused[i]);
                }
                list.addAll(subList);
            }
        }

        result.allyksused = list;
        
        return result;
    }

    public static getSubdivisionListV2ResponseType V2(org.apache.axis.MessageContext context, Connection conn,
    		UserProfile user, XRoadProtocolVersion xRoadProtocolVersion) throws Exception {

        logger.info("GetSubdivisionList.V2 invoked.");

        getSubdivisionListV2ResponseType result = new getSubdivisionListV2ResponseType();

        // Laeme päringu keha endale sobivasse andmestruktuuri
        getSubdivisionListV2RequestType bodyData = getSubdivisionListV2RequestType.getFromSOAPBody(context);
        if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
        	result.paring = bodyData;
        }

        // Laeme sisendparameetrid SOAP sõnumi manuses asuvast XML failist
        AttachmentExtractionResult exResult = CommonMethods.getExtractedFileFromAttachment(context, bodyData.asutusedHref);
        result.dataMd5Hash = exResult.getAttachmentHash();
        bodyData.loadParametersFromXML(exResult.getExtractedFileName());

        // Leiame andmebaasist soovitud ametikohad
        ArrayList<Allyksus> list = new ArrayList<Allyksus>();
        if (bodyData != null) {
            for (int i = 0; i < bodyData.asutused.length; ++i) {
                Asutus tmpOrg = new Asutus();
                tmpOrg.loadByRegNr(bodyData.asutused[i], conn);
                ArrayList<Allyksus> subList = Allyksus.getList(tmpOrg.getId(), null, conn);
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
