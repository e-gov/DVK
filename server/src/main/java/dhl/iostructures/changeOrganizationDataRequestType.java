package dhl.iostructures;

import javax.xml.soap.SOAPBody;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dhl.users.Asutus;
import dvk.core.CommonMethods;

public class changeOrganizationDataRequestType {
    public Asutus asutus;
    public boolean registrikoodEsitatud;
    public boolean registrikoodVanaEsitatud;
    public boolean ksAsutuseKoodEsitatud;
    public boolean nimetusEsitatud;
    public boolean nimeLyhendEsitatud;
    public boolean liik1Esitatud;
    public boolean liik2Esitatud;
    public boolean tegevusalaEsitatud;
    public boolean tegevuspiirkondEsitatud;
    public boolean maakondEsitatud;
    public boolean asukohtEsitatud;
    public boolean aadressEsitatud;
    public boolean postikoodEsitatud;
    public boolean telefonEsitatud;
    public boolean faksEsitatud;
    public boolean epostEsitatud;
    public boolean wwwEsitatud;
    public boolean logoEsitatud;
    public boolean asutamiseKuupaevEsitatud;
    public boolean moodustamiseAktiNimiEsitatud;
    public boolean moodustamiseAktiNumberEsitatud;
    public boolean moodustamiseAktiKuupaevEsitatud;
    public boolean pohimaaruseAktiNimiEsitatud;
    public boolean pohimaaruseAktiNumberEsitatud;
    public boolean pohimaaruseKinnitamiseKuupaevEsitatud;
    public boolean pohimaaruseKandeKuupaevEsitatud;
    public boolean parameetridEsitatud;
    public boolean dvkSaatmineEsitatud;
    public boolean dvkOtseSaatmineEsitatud;
    public boolean dhsNimetusEsitatud;
    public boolean toetatavDVKVersioonEsitatud;

    public changeOrganizationDataRequestType() {
        asutus = null;
        registrikoodEsitatud = false;
        registrikoodVanaEsitatud = false;
        ksAsutuseKoodEsitatud = false;
        nimetusEsitatud = false;
        nimeLyhendEsitatud = false;
        liik1Esitatud = false;
        liik2Esitatud = false;
        tegevusalaEsitatud = false;
        tegevuspiirkondEsitatud = false;
        maakondEsitatud = false;
        asukohtEsitatud = false;
        aadressEsitatud = false;
        postikoodEsitatud = false;
        telefonEsitatud = false;
        faksEsitatud = false;
        epostEsitatud = false;
        wwwEsitatud = false;
        logoEsitatud = false;
        asutamiseKuupaevEsitatud = false;
        moodustamiseAktiNimiEsitatud = false;
        moodustamiseAktiNumberEsitatud = false;
        moodustamiseAktiKuupaevEsitatud = false;
        pohimaaruseAktiNimiEsitatud = false;
        pohimaaruseAktiNumberEsitatud = false;
        pohimaaruseKinnitamiseKuupaevEsitatud = false;
        pohimaaruseKandeKuupaevEsitatud = false;
        parameetridEsitatud = false;
        dvkSaatmineEsitatud = false;
        dvkOtseSaatmineEsitatud = false;
        dhsNimetusEsitatud = false;
        toetatavDVKVersioonEsitatud = false;
    }

    public static changeOrganizationDataRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        org.apache.axis.Message msg = null;
        SOAPBody body = null;
        NodeList nodes = null;
        Element el = null;
        Element el1 = null;
        changeOrganizationDataRequestType result = null;

        try {
            msg = context.getRequestMessage();
            body = msg.getSOAPBody();
            nodes = body.getElementsByTagName("changeOrganizationData");
            if (nodes.getLength() > 0) {
                el = (Element) nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    result = new changeOrganizationDataRequestType();
                    result.asutus = new Asutus();
                    el = (Element) nodes.item(0);

                    nodes = el.getElementsByTagName("registrikood");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.registrikoodEsitatud = true;
                        result.asutus.setRegistrikood(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("endine_registrikood");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.registrikoodVanaEsitatud = true;
                        result.asutus.setRegistrikoodVana(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("korgemalseisva_asutuse_registrikood");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.ksAsutuseKoodEsitatud = true;
                        result.asutus.setKsAsutuseKood(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("nimi");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.nimetusEsitatud = true;
                        result.asutus.setNimetus(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("nime_lyhend");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.nimeLyhendEsitatud = true;
                        result.asutus.setNimeLyhend(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("liik1");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.liik1Esitatud = true;
                        result.asutus.setLiik1(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("liik2");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.liik2Esitatud = true;
                        result.asutus.setLiik2(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("tegevusala");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.tegevusalaEsitatud = true;
                        result.asutus.setTegevusala(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("tegevuspiirkond");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.tegevuspiirkondEsitatud = true;
                        result.asutus.setTegevuspiirkond(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("maakond");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.maakondEsitatud = true;
                        result.asutus.setMaakond(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("asukoht");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.asukohtEsitatud = true;
                        result.asutus.setAsukoht(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("aadress");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.aadressEsitatud = true;
                        result.asutus.setAadress(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("postikood");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.postikoodEsitatud = true;
                        result.asutus.setPostikood(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("telefon");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.telefonEsitatud = true;
                        result.asutus.setTelefon(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("faks");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.faksEsitatud = true;
                        result.asutus.setFaks(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("e_post");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.epostEsitatud = true;
                        result.asutus.setEpost(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("www");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.wwwEsitatud = true;
                        result.asutus.setWww(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("logo");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.logoEsitatud = true;
                        result.asutus.setLogo(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("asutamise_kuupaev");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.asutamiseKuupaevEsitatud = true;
                        result.asutus.setAsutamiseKuupaev(CommonMethods.getDateFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("moodustamise_akti_nimi");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.moodustamiseAktiNimiEsitatud = true;
                        result.asutus.setMoodustamiseAktiNimi(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("moodustamise_akti_number");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.moodustamiseAktiNumberEsitatud = true;
                        result.asutus.setMoodustamiseAktiNumber(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("moodustamise_akti_kuupaev");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.moodustamiseAktiKuupaevEsitatud = true;
                        result.asutus.setMoodustamiseAktiKuupaev(CommonMethods.getDateFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("pohimaaruse_akti_nimi");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.pohimaaruseAktiNimiEsitatud = true;
                        result.asutus.setPohimaaruseAktiNimi(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("pohimaaruse_akti_number");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.pohimaaruseAktiNumberEsitatud = true;
                        result.asutus.setPohimaaruseAktiNumber(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("pohimaaruse_kinnitamise_kuupaev");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.pohimaaruseKinnitamiseKuupaevEsitatud = true;
                        result.asutus.setPohimaaruseKinnitamiseKuupaev(CommonMethods.getDateFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("pohimaaruse_kande_kuupaev");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.pohimaaruseKandeKuupaevEsitatud = true;
                        result.asutus.setPohimaaruseKandeKuupaev(CommonMethods.getDateFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("parameetrid");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.parameetridEsitatud = true;
                        result.asutus.setParameetrid(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("dvk_saatmine");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.dvkSaatmineEsitatud = true;
                        result.asutus.setDvkSaatmine(CommonMethods.booleanFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("dvk_otse_saatmine");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.dvkOtseSaatmineEsitatud = true;
                        result.asutus.setDvkOtseSaatmine(CommonMethods.booleanFromXML(CommonMethods.getNodeText(el1)));
                    }

                    nodes = el.getElementsByTagName("toetatav_dvk_versioon");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.toetatavDVKVersioonEsitatud = true;
                        result.asutus.setToetatavDVKVersioon(CommonMethods.getNodeText(el1));
                    }

                    nodes = el.getElementsByTagName("dokumendihaldussysteemi_nimetus");
                    if (nodes.getLength() > 0) {
                        el1 = (Element) nodes.item(0);
                        result.dhsNimetusEsitatud = true;
                        result.asutus.setDHSNimetus(CommonMethods.getNodeText(el1));
                    }
                }
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.changeOrganizationDataRequestType", "getFromSOAPBody");
            result = null;
        } finally {
            msg = null;
            body = null;
            nodes = null;
            el = null;
            el1 = null;
        }

        return result;
    }
}
