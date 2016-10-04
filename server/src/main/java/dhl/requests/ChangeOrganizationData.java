package dhl.requests;

import java.sql.Connection;
import java.util.Date;

import org.apache.axis.AxisFault;

import dhl.iostructures.changeOrganizationDataRequestType;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class ChangeOrganizationData {
    public static RequestInternalResult V1(org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws AxisFault {
        RequestInternalResult result = new RequestInternalResult();

        // Lame SOAP keha endale sobivasse andmestruktuuri
        changeOrganizationDataRequestType bodyData = changeOrganizationDataRequestType.getFromSOAPBody(context);
        if (bodyData == null) {
            throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
        }
        if (bodyData.asutus == null) {
            throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
        }

        // Kui päringuga üritatakse muuta teise asutuse andmeid, siis anname veatete
        if (!bodyData.asutus.getRegistrikood().equalsIgnoreCase(user.getOrganizationCode())) {
            throw new AxisFault("Antud päringuga saab muuta ainult päringu sooritanud asutuse andmeid!");
        }

        // Laeme andmebaasist asutuse andmete olemasoleva seisu.
        // Ennekõike on see vajalik selleks, et teada saada asutuse olemasolevat ID koodi.
        Asutus asutus = new Asutus();
        asutus.loadByRegNr(bodyData.asutus.getRegistrikood(), conn);

        if (bodyData.registrikoodVanaEsitatud) {
            asutus.setRegistrikoodVana(bodyData.asutus.getRegistrikoodVana());
        }

        if (bodyData.ksAsutuseKoodEsitatud) {
            // Kui andmetes sisaldub viide kõrgemalseisvale asutusele, siis üritame
            // tuvastada kõrgemalseisva asutuse ID
            if ((bodyData.asutus.getKsAsutuseKood() != null) && !bodyData.asutus.getKsAsutuseKood().equalsIgnoreCase("")) {
                bodyData.asutus.setKsAsutuseID(Asutus.getIDByRegNr(bodyData.asutus.getKsAsutuseKood(), false, conn));
            }

            asutus.setKsAsutuseID(bodyData.asutus.getKsAsutuseID());
            asutus.setKsAsutuseKood(bodyData.asutus.getKsAsutuseKood());
        }

        if (bodyData.nimetusEsitatud) {
            asutus.setNimetus(bodyData.asutus.getNimetus());
        }

        if (bodyData.nimeLyhendEsitatud) {
            asutus.setNimeLyhend(bodyData.asutus.getNimeLyhend());
        }

        if (bodyData.liik1Esitatud) {
            asutus.setLiik1(bodyData.asutus.getLiik1());
        }

        if (bodyData.liik2Esitatud) {
            asutus.setLiik2(bodyData.asutus.getLiik2());
        }

        if (bodyData.tegevusalaEsitatud) {
            asutus.setTegevusala(bodyData.asutus.getTegevusala());
        }

        if (bodyData.tegevuspiirkondEsitatud) {
            asutus.setTegevuspiirkond(bodyData.asutus.getTegevuspiirkond());
        }

        if (bodyData.maakondEsitatud) {
            asutus.setMaakond(bodyData.asutus.getMaakond());
        }

        if (bodyData.asukohtEsitatud) {
            asutus.setAsukoht(bodyData.asutus.getAsukoht());
        }

        if (bodyData.aadressEsitatud) {
            asutus.setAadress(bodyData.asutus.getAadress());
        }

        if (bodyData.postikoodEsitatud) {
            asutus.setPostikood(bodyData.asutus.getPostikood());
        }

        if (bodyData.telefonEsitatud) {
            asutus.setTelefon(bodyData.asutus.getTelefon());
        }

        if (bodyData.faksEsitatud) {
            asutus.setFaks(bodyData.asutus.getFaks());
        }

        if (bodyData.epostEsitatud) {
            asutus.setEpost(bodyData.asutus.getEpost());
        }

        if (bodyData.wwwEsitatud) {
            asutus.setWww(bodyData.asutus.getWww());
        }

        if (bodyData.logoEsitatud) {
            asutus.setLogo(bodyData.asutus.getLogo());
        }

        if (bodyData.asutamiseKuupaevEsitatud) {
            asutus.setAsutamiseKuupaev(bodyData.asutus.getAsutamiseKuupaev());
        }

        if (bodyData.moodustamiseAktiNimiEsitatud) {
            asutus.setMoodustamiseAktiNimi(bodyData.asutus.getMoodustamiseAktiNimi());
        }

        if (bodyData.moodustamiseAktiNumberEsitatud) {
            asutus.setMoodustamiseAktiNumber(bodyData.asutus.getMoodustamiseAktiNumber());
        }

        if (bodyData.moodustamiseAktiKuupaevEsitatud) {
            asutus.setMoodustamiseAktiKuupaev(bodyData.asutus.getMoodustamiseAktiKuupaev());
        }

        if (bodyData.pohimaaruseAktiNimiEsitatud) {
            asutus.setPohimaaruseAktiNimi(bodyData.asutus.getPohimaaruseAktiNimi());
        }

        if (bodyData.pohimaaruseAktiNumberEsitatud) {
            asutus.setPohimaaruseAktiNumber(bodyData.asutus.getPohimaaruseAktiNumber());
        }

        if (bodyData.pohimaaruseKinnitamiseKuupaevEsitatud) {
            asutus.setPohimaaruseKinnitamiseKuupaev(bodyData.asutus.getPohimaaruseKinnitamiseKuupaev());
        }

        if (bodyData.pohimaaruseKandeKuupaevEsitatud) {
            asutus.setPohimaaruseKandeKuupaev(bodyData.asutus.getPohimaaruseKandeKuupaev());
        }

        if (asutus.getId() < 1) {
            asutus.setLoodud(new Date());
        }
        asutus.setMuudetud(new Date());
        asutus.setMuutja(user.getPersonCode());

        if (bodyData.parameetridEsitatud) {
            asutus.setParameetrid(bodyData.asutus.getParameetrid());
        }

        if (bodyData.dvkOtseSaatmineEsitatud) {
            asutus.setDvkOtseSaatmine(bodyData.asutus.getDvkOtseSaatmine());
        }

        if (bodyData.dhsNimetusEsitatud) {
            asutus.setDHSNimetus(bodyData.asutus.getDHSNimetus());
        }

        if (bodyData.toetatavDVKVersioonEsitatud) {
            asutus.setToetatavDVKVersioon(bodyData.asutus.getToetatavDVKVersioon());
        }

        // Salvestame muudatused. Kasutame X-tee päist lihtsalt mugavaks andmete edastamiseks.
        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);

        asutus.saveToDB(conn, xTeePais);

        return result;
    }
}
