package ee.ria.dhx.dvk;

import com.jcabi.aspects.Loggable;

import ee.ria.dhx.exception.DhxException;
import ee.ria.dhx.exception.DhxExceptionEnum;
import ee.ria.dhx.types.AsyncDhxSendDocumentResult;
import ee.ria.dhx.types.DhxOrganisation;
import ee.ria.dhx.types.DhxRepresentee;
import ee.ria.dhx.types.DhxSendDocumentResult;
import ee.ria.dhx.types.IncomingDhxPackage;
import ee.ria.dhx.types.InternalXroadMember;
import ee.ria.dhx.types.OutgoingDhxPackage;
import ee.ria.dhx.types.ee.riik.schemas.deccontainer.vers_2_1.DecContainer;
import ee.ria.dhx.types.ee.riik.schemas.deccontainer.vers_2_1.DecContainer.Transport.DecRecipient;
import ee.ria.dhx.types.eu.x_road.dhx.producer.SendDocumentResponse;
import ee.ria.dhx.util.StringUtil;
import ee.ria.dhx.ws.DhxOrganisationFactory;
import ee.ria.dhx.ws.config.SoapConfig;
import ee.ria.dhx.ws.service.AddressService;
import ee.ria.dhx.ws.service.AsyncDhxPackageService;
import ee.ria.dhx.ws.service.DhxImplementationSpecificService;
import ee.ria.dhx.ws.service.DhxMarshallerService;
import ee.ria.dhx.ws.service.DhxPackageProviderService;
import ee.ria.dhx.ws.service.DhxPackageService;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import org.apache.axis.AxisFault;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.ws.context.MessageContext;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.naming.Context;
import javax.naming.InitialContext;

import dhl.Document;
import dhl.Folder;
import dhl.Recipient;
import dhl.Sending;
import dhl.exceptions.ContainerValidationException;
import dhl.requests.ReceiveDocuments;
import dhl.requests.SendDocuments;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.ContainerVersion;
import dvk.core.Fault;
import dvk.core.FileSplitResult;
import dvk.core.Settings;
import dvk.core.xroad.XRoadClient;
import dvk.core.xroad.XRoadProtocolHeader;

/**
 * Class is an example implementation of DhxImplementationSpecificService interface. All data that
 * need to be stored is stored in memory.
 * 
 * @author Aleksei Kokarev
 *
 */
@Slf4j
@Service
@Configuration
public class DvkDhxService implements DhxImplementationSpecificService {

  @Value("${server_database_environment_variable}")
  @Setter
  String serverDatabaseEnvironmentVariable;



  @Value("${dhx.resend.timeout}")
  @Setter
  Integer resendTimeout;

  @Autowired
  SoapConfig config;

  @Autowired
  AsyncDhxPackageService asyncDhxPackageService;


  private List<InternalXroadMember> members;


  @Autowired
  DhxPackageService documentService;

  @Autowired
  DhxPackageProviderService packageProvider;

  @Autowired
  AddressService addressService;

  @Autowired
  DhxMarshallerService dhxMarshallerService;

  @Value("${dvk-special-subsystems}")
  String dvkSpecialSubsystems;

  @Override
  @Loggable
  public boolean isDuplicatePackage(InternalXroadMember from,
      String consignmentId) throws DhxException {
    log.debug("Checking for duplicates. from memberCode: {}",
        from.toString() + " from consignmentId:" + consignmentId);
    Asutus asutus = new Asutus();
    Connection conn = null;
    try {
      conn = getConnection();
      asutus.loadByRegNr(createDvkRegCode(from), conn);
      return Recipient.isDuplicate(conn, consignmentId, asutus.getId());
    } catch (Exception ex) {
      log.error(ex.getMessage(), ex);
      throw new DhxException(DhxExceptionEnum.TECHNICAL_ERROR,
          "Error occured while checking for duplicates.", ex);
    } finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
    }
  }

  @Override
  @Loggable
  public String receiveDocument(IncomingDhxPackage document,
      MessageContext context) throws DhxException {
    log.debug(
        "String receiveDocument(DhxDocument document) externalConsignmentId: {}",
        document.getExternalConsignmentId());
    String pipelineDataFile = CommonMethods.createPipelineFile(0);

    Connection conn = null;
    ArrayList<Document> serverDocuments = new ArrayList<Document>();
    try {
      conn = getConnection();
      String dvkRegCode = createDvkRegCodeFromRepresentee(document
          .getRecipient().getCode(), document.getRecipient()
              .getSystem());
      Asutus recipientAsutus = new Asutus();
      recipientAsutus.loadByRegNr(dvkRegCode, conn);
      
      DhxOrganisation senderDhxOrg = DhxOrganisationFactory.createDhxOrganisation(document.getClient());
      String senderDvkRegCode = toDvkCapsuleAddressee(senderDhxOrg.getCode(), senderDhxOrg
            .getSystem());
    Asutus senderAsutus = new Asutus();
    senderAsutus.loadByRegNr(senderDvkRegCode, conn);
    
      if (StringUtil.isNullOrEmpty(recipientAsutus.getRegistrikood())) {
        throw new DhxException(DhxExceptionEnum.WRONG_RECIPIENT,
            "Unable to find recipient oraganisation in DVK. dvkRegCode: " + dvkRegCode);
      }
      // if we are dealing with subsystem, then maybe we need to replace DVK adressee(subsytem name)
      // with DHX(membercode)
      if (recipientAsutus.getRegistrikood2() != null || (senderAsutus != null && senderAsutus.getRegistrikood2() != null)) {
        DecContainer container =
            (DecContainer) document.getParsedContainer();
        if (recipientAsutus.getRegistrikood2() != null) {
          for (DecRecipient decRecipient : container.getTransport().getDecRecipient()) {
            if (recipientAsutus.getRegistrikood2().equals(decRecipient.getOrganisationCode())) {
              decRecipient.setOrganisationCode(recipientAsutus.getRegistrikood());

            }
          }
        }
        if (senderAsutus != null && senderAsutus.getRegistrikood2() != null) {
          container.getTransport().getDecSender()
              .setOrganisationCode(senderAsutus.getRegistrikood2());
        }
        File capsuleFile = dhxMarshallerService.marshall(container);
        DataSource source = new FileDataSource(capsuleFile);
        document.setDocumentFile(new DataHandler(source));
      }



      DataHandler data = document.getDocumentFile();
      CommonMethods.getDataFromDataSource(data.getDataSource(), "base64",
          pipelineDataFile, false);
      FileSplitResult docFiles = CommonMethods.splitOutTags(pipelineDataFile,
          "DecContainer", true, false, true);
      XRoadClient client = new XRoadClient(document.getClient()
          .getXroadInstance(), document.getClient().getMemberClass(),
          document.getClient().getMemberCode());
      client.setSubsystemCode(trimPrefix(document.getClient().getSubsystemCode()));
      XRoadProtocolHeader xroadHeader = new XRoadProtocolHeader(client,
          null, null, null, null);
      UserProfile user = UserProfile.getFromHeaders(xroadHeader, conn);
      int senderTargetFolder = Folder.GLOBAL_ROOT_FOLDER;
      if (document.getParsedContainer() != null) {
        DecContainer container =
            (DecContainer) document.getParsedContainer();
        if (container.getDecMetadata() != null
            && container.getDecMetadata().getDecFolder() != null) {
          senderTargetFolder =
              Folder.getFolderIdByPath(container.getDecMetadata().getDecFolder(),
                  user.getOrganizationID(), conn, false, true, null);
        }
      }
      for (int i = 0; i < docFiles.subFiles.size(); ++i) {
        // Valideerime XML dokumendi
        Fault validationFault = CommonMethods
            .validateDVKContainer(docFiles.subFiles.get(i));
        Document doc = Document
            .fromXML(
                docFiles.subFiles.get(i),
                user.getOrganizationID(),
                (Settings.Server_ValidateXmlFiles || Settings.Server_ValidateSignatures),
                conn, xroadHeader);

        SendDocuments.fillRecipientDataFor2_1ContainerIfNecessary(
            docFiles, i, doc);

        // Vajadusel valideerime saadetavad XML dokumendid
        // validateXmlFiles(doc.getFiles());
        SendDocuments.validateXmlFiles(doc.getFiles());
        // Vajadusel kontrollime saadetavate .ddoc ja .bdoc failide
        // allkirjad üle
        SendDocuments.validateSignedFileSignatures(doc.getFiles());

        doc.setOrganizationID(user.getOrganizationID());
        doc.setContainerVersion(ContainerVersion.VERSION_2_1.toString());
        doc.setFolderID(senderTargetFolder);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DATE,
            Settings.Server_DocumentDefaultLifetime);
        doc.setConservationDeadline(calendar.getTime());
        calendar = null;

        if ((doc.getSendingList() != null)) {
          Sending tmpSending;
          for (int j = 0; j < doc.getSendingList().size(); ++j) {
            tmpSending = doc.getSendingList().get(j);
            if (Settings.Server_DocumentSenderMustMatchXroadHeader) {
              if ((tmpSending.getSender() != null)
                  && (tmpSending.getSender()
                      .getOrganizationID() != user
                          .getOrganizationID())
                  && (tmpSending.getProxy() != null)
                  && (tmpSending.getProxy()
                      .getOrganizationID() != user
                          .getOrganizationID())) {
                throw new ContainerValidationException(
                    CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD);
              }
            }
            // remove unneeded recipient. DVK adds all recipients
            // from capsule, DHX sends to only
            // one recipient
            ArrayList<Recipient> recipients = new ArrayList<Recipient>();
            for (int k = 0; k < tmpSending.getRecipients().size(); ++k) {
              Recipient recipient = tmpSending.getRecipients()
                  .get(k);
              if (recipient.getOrganizationID() == recipientAsutus
                  .getId()) {
                recipient.setDhxExternalConsignmentId(document
                    .getExternalConsignmentId());
                recipients.add(recipient);
              }
            }
            if (recipients.isEmpty()) {
              throw new DhxException(
                  DhxExceptionEnum.WRONG_RECIPIENT,
                  "Unable to find recipient among capsule recipients added by DVK");
            }
            tmpSending.setRecipients(recipients);
            if (validationFault != null) {
              for (int k = 0; k < tmpSending.getRecipients()
                  .size(); ++k) {
                tmpSending.getRecipients().get(k)
                    .setFault(validationFault);
              }
            }
          }
        }
        serverDocuments.add(doc);
        doc.addToDB(conn, xroadHeader);

      }
    } catch (ContainerValidationException fault) {
      log.error(fault.getMessage(), fault);
      throw new DhxException(DhxExceptionEnum.CAPSULE_VALIDATION_ERROR,
          "Error occured while recieving the document. "
              + fault.getMessage(),
          fault);
    } catch (DhxException ex) {
      throw ex;
    } catch (Exception fault) {
      log.error(fault.getMessage(), fault);
      throw new DhxException(DhxExceptionEnum.TECHNICAL_ERROR,
          "Error occured while recieving the document. "
              + fault.getMessage(),
          fault);
    } finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
      conn = null;
      for (int i = 0; i < serverDocuments.size(); ++i) {
        (new File(serverDocuments.get(i).getFilePath())).delete();
      }
    }

    return String.valueOf(serverDocuments.get(0).getId());

  }

  @Override
  @Loggable
  public List<DhxRepresentee> getRepresentationList() {
    Connection conn = null;

    try {
      conn = getConnection();
      ArrayList<Asutus> asutused = Asutus.getList(conn, false);
      return toDhxRepresentees(asutused);
    } catch (AxisFault ex) {
      log.error(ex.getMessage(), ex);
    } finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
      conn = null;
    }
    return new ArrayList<DhxRepresentee>();
  }

  @Loggable
  private List<DhxRepresentee> toDhxRepresentees(List<Asutus> asutuss) {
    List<DhxRepresentee> representees = new ArrayList<DhxRepresentee>();
    if (asutuss != null) {
      for (Asutus asutus : asutuss) {
        representees.add(toDhxRepresentee(asutus));
      }
    }
    return representees;
  }

  @Loggable
  private DhxRepresentee toDhxRepresentee(Asutus asutus) {
    DhxRepresentee representee = new DhxRepresentee(
        getDhxRegCode(asutus),
        (asutus.getLoodud() == null ? new Date() : asutus.getLoodud()),
        null, asutus.getNimetus(),
        getDhxSubsystem(asutus));
    return representee;
  }

  private void saveOrUpdateAsutuss(Connection conn,
      List<InternalXroadMember> members) throws DhxException {
    List<InternalXroadMember> selfRepresentees = new ArrayList<InternalXroadMember>();
    InternalXroadMember selfMember = null;
    Boolean needToUpdateSelfRepresentees = false;
    for (InternalXroadMember member : members) {
      // if own representees, then they are not DHX members.
      if (member.getRepresentee() != null
          && config.getMemberCode().equals(member.getMemberCode())) {
        selfRepresentees.add(member);
        continue;
      }
      if (member.getMemberCode().equals(config.getMemberCode())
          && member.getSubsystemCode().equals(config.getDefaultSubsystem())) {
        selfMember = member;
      }
      Asutus asutus = new Asutus();
      String regCode = createDvkRegCode(member);
      asutus.loadByRegNr(regCode, conn);
      if (!asutus.getDhxAsutus()) {
        needToUpdateSelfRepresentees = true;
      }
      asutus.setDhxAsutus(true);
      asutus.setRegistrikood(regCode);
      asutus.setRegistrikood2(createDvkRegCode2(member));
      asutus.setDvkSaatmine(true);
      asutus.setKapselVersioon("2.1");
      if (member.getRepresentee() == null) {
        asutus.setNimetus(member.getName());
      } else {
        asutus.setNimetus(member.getRepresentee().getRepresenteeName());
      }
      asutus.saveToDB(conn, null);
    }
    // remove dhx flag from asutuss that are not present in DHX address list
    List<Asutus> dvkDhxAsutuss = Asutus.getList(conn, true);
    for (Asutus dvkAsutus : dvkDhxAsutuss) {
      Boolean asutusFound = false;
      for (InternalXroadMember member : members) {
        // own representees are also
        if (!(member.getRepresentee() != null && config.getMemberCode().equals(
            member.getMemberCode()))
            && dvkAsutus.getRegistrikood().toUpperCase()
                .equals(createDvkRegCode(member).toUpperCase())) {
          asutusFound = true;
          break;
        }
      }
      if (!asutusFound) {
        dvkAsutus.setDvkSaatmine(false);
        dvkAsutus.saveToDB(conn, null);
      }
    }

    // if some organosations were updated, then delete and readd own representees
    if (needToUpdateSelfRepresentees && selfRepresentees != null && selfRepresentees.size() > 0) {
      // first remove all selfrepresentees from address list
      members.removeAll(selfRepresentees);
      // then find and reinitialize representees
      List<DhxRepresentee> representees = getRepresentationList();
      if (selfMember == null) {
        throw new DhxException(DhxExceptionEnum.TECHNICAL_ERROR,
            "Unable to find own member in address list to add representees.");
      }
      if (representees != null && representees.size() > 0) {
        for (DhxRepresentee representee : representees) {
          members.add(new InternalXroadMember(selfMember, representee));
        }
      }

    }
    this.members = members;
  }

  @Override
  public List<InternalXroadMember> getAdresseeList() {
    return members;
  }

  @Override
  public void saveAddresseeList(List<InternalXroadMember> members) throws DhxException {
    // this.members = members;
    Connection conn = null;
    try {
      conn = getConnection();
      saveOrUpdateAsutuss(conn, members);

    } catch (AxisFault ex) {
      log.error(ex.getMessage(), ex);
    }

    finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
      conn = null;
    }
  }

  public String getDhxRegCode(Asutus dvkAsutus) {
    if (dvkAsutus.getRegistrikood2() == null) {
      return dvkAsutus.getRegistrikood();
    } else {
      return dvkAsutus.getRegistrikood2();
    }
  }

  public String getDhxSubsystem(Asutus dvkAsutus) {
    if (dvkAsutus.getRegistrikood2() == null) {
      return null;
    } else {
      String subsystem = dvkAsutus.getRegistrikood();
      if (subsystem.lastIndexOf(".") > 0) {
        subsystem = subsystem.substring(0, subsystem.lastIndexOf("."));
      }
      /*
       * if(!subsystem.startsWith(config.getDhxSubsystemPrefix())) { subsystem =
       * config.getDhxSubsystemPrefix() + "." + subsystem; }
       */
      return subsystem;
    }
  }

  // returns true if given subsystem is special DVK subsystem with which registrikood equals
  // subsystemname, not subsystemname.membercode
  private Boolean isSpecialSubsystem(String subSystem) {
    String specialSubsystems = "," + dvkSpecialSubsystems + ",";
    if (specialSubsystems.contains("," + subSystem + ",")) {
      return true;
    }
    return false;
  }

  public String createDvkRegCode(InternalXroadMember member) {
    String regCode = "";
    if (member.getRepresentee() != null) {
      if (member.getRepresentee().getRepresenteeSystem() != null) {
        if (isSpecialSubsystem(member.getRepresentee().getRepresenteeSystem())) {
          regCode = member.getRepresentee().getRepresenteeSystem();
        } else {
          regCode =
              member.getRepresentee().getRepresenteeSystem() + "."
                  + member.getRepresentee().getRepresenteeCode();
        }
      } else {
        regCode = member.getRepresentee().getRepresenteeCode();
      }
    } else {
      String subSystem = trimPrefix(member.getSubsystemCode());
      if (subSystem != null) {
        if (isSpecialSubsystem(subSystem)) {
          regCode = subSystem;
        } else {
          regCode = subSystem + "." + member.getMemberCode();
        }
      } else {
        regCode = member.getMemberCode();
      }
    }
    return regCode;
  }

  public String createDvkRegCode2(InternalXroadMember member) {
    String regCode = "";
    if (member.getRepresentee() != null) {
      if (member.getRepresentee().getRepresenteeSystem() != null) {
        regCode = member.getRepresentee().getRepresenteeCode();
      } else {
        regCode = null;
      }
    } else {
      String subSystem = trimPrefix(member.getSubsystemCode());
      if (subSystem != null) {
        regCode = member.getMemberCode();
      } else {
        regCode = null;
      }
    }
    return regCode;
  }

  private String trimPrefix(String subsystem) {
    if (subsystem == null) {
      return null;
    }
    if (subsystem.equals(config.getDhxSubsystemPrefix())) {
      return null;
    } else if (subsystem.startsWith(config.getDhxSubsystemPrefix() + ".")) {
      return subsystem.substring(4);
    }
    return subsystem;

  }

  public String createDvkRegCodeFromRepresentee(String representeeCode,
      String representeeSystem) throws DhxException {
    String regCode = "";
    if (representeeCode == null) {
      throw new DhxException(DhxExceptionEnum.WRONG_RECIPIENT,
          "DVK can only get document for representees.");
    }
    if (representeeSystem != null && !representeeSystem.equals("")) {
      if (isSpecialSubsystem(representeeSystem)) {
        regCode = representeeSystem;
      } else {
        regCode = trimPrefix(representeeSystem) + "." + representeeCode;
      }
    } else {
      regCode = representeeCode;
    }
    return regCode;
  }
  
  /**
   * Sometimes DHX addressee and DVK addresse might be different. In DHX there must be always
   * registration code, in DVK there might be system also.
   * 
   * @param memberCode memberCode to use to transform to DVK capsule addressee
   * @param subsystem subsystem to use to transform to DVK capsule addressee
   * @return capsule addressee accordinbg to DVK
   */
  @Loggable
  public String toDvkCapsuleAddressee(String memberCode, String subsystem) {
    String dvkCode = null;
    if (!StringUtil.isNullOrEmpty(subsystem)
        && subsystem.startsWith(config.getDhxSubsystemPrefix() + ".")) {
      String system = subsystem.substring(config.getDhxSubsystemPrefix().length() + 1);
      // String perfix = subsystem.substring(0, index);
      log.debug("found system with subsystem: " + system);
      if (isSpecialSubsystem(system)) {
        dvkCode = system;
      } else {
        dvkCode = system + "." + memberCode;
      }

    } else if (!StringUtil.isNullOrEmpty(subsystem)
        && !subsystem.equals(config.getDhxSubsystemPrefix())) {
      if (isSpecialSubsystem(subsystem)) {
        dvkCode = subsystem;
      } else {
        dvkCode = subsystem + "." + memberCode;
      }
    } else {

      dvkCode = memberCode;
    }
    return dvkCode;
  }


  public void sendSingleDocument(dhl.Document doc, Connection conn) throws SQLException {
    log.debug("sendSingleDocument docId:" + doc.getId());
    String pipelineDataFile = null;
    Sending tmpSending = new Sending();
    tmpSending.loadByDocumentID(doc.getId(), conn);
    Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
    for (Recipient recipient : tmpSending.getRecipients()) {
      if (recipient.getSendStatusID() == CommonStructures.SendStatus_Sending
          && Asutus.isDhxAsutus(conn,
              recipient.getOrganizationID())) {
        log.debug("found document and recipient to send to DHX. recipient: " + recipient.getId());
        String consignmentId = String.valueOf(recipient.getId());
        FileOutputStream out = null;
        OutputStreamWriter ow = null;
        BufferedWriter bw = null;
        try {
          pipelineDataFile = CommonMethods.createPipelineFile(0);
          out = new FileOutputStream(pipelineDataFile, false);
          ow = new OutputStreamWriter(out, "UTF-8");
          bw = new BufferedWriter(ow);
          Asutus asutus = new Asutus(
              recipient.getOrganizationID(), conn);
          // if internal consignment id is set, means that document is sent to DHX
          if (recipient.getDhxInternalConsignmentId() == null) {
            recipient
                .setDhxInternalConsignmentId(consignmentId);
          }
          if (ReceiveDocuments.isContainerConversionNeeded(
              asutus.getKapselVersioon(), doc.getContainerVersion())) {
            doc.setFilePath(ReceiveDocuments.convertContainer(conn, doc, 21, 1).getOutputFile());
          }

          // Viskame XML failist välja suure mahuga SignedDoc elemendid
          // CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);
          CommonMethods.splitOutTags(doc.getFilePath(), "failid", false, false, true);

          // Täidame DHL poolt automaatselt täidetavad väljad
          ReceiveDocuments.appendAutomaticMetaData(
              doc.getFilePath(),
              tmpSending,
              recipient,
              doc,
              senderOrg,
              asutus,
              conn,
              doc.getDvkContainerVersion(),
              doc.getContainerVersion());

          // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
          // faili koosseisu tagasi.
          CommonMethods.joinSplitXML(doc.getFilePath(), bw, false);
          log.debug("Sending document to DHX. to:" + asutus
              .getRegistrikood());
          CommonMethods.safeCloseWriter(bw);
          CommonMethods.safeCloseWriter(ow);
          CommonMethods.safeCloseStream(out);
          recipient.setLastSendDate(new Date());
          OutgoingDhxPackage pkg = packageProvider.getOutgoingPackage(new File(pipelineDataFile),
              consignmentId, getDhxRegCode(asutus),
              getDhxSubsystem(asutus),
              getDhxRegCode(senderOrg), getDhxSubsystem(senderOrg));
          // if we are dealing with subsystem, then maybe we need to replace DVK adressee(subsytem
          // name) or DVK sender with DHX(membercode)
          if (asutus.getRegistrikood2() != null || senderOrg.getRegistrikood2() != null) {
            Object containerObj = null;
            containerObj = dhxMarshallerService.unmarshall(new File(pipelineDataFile));
            DecContainer container =
                (DecContainer) containerObj;
            if (asutus.getRegistrikood2() != null) {
              for (DecRecipient decRecipient : container.getTransport().getDecRecipient()) {
                if (asutus.getRegistrikood().equals(decRecipient.getOrganisationCode())) {
                  decRecipient.setOrganisationCode(asutus.getRegistrikood2());

                }
              }
            }
            if (senderOrg.getRegistrikood2() != null) {
              container.getTransport().getDecSender()
                  .setOrganisationCode(senderOrg.getRegistrikood2());
            }
            File capsuleFile = dhxMarshallerService.marshall(container);
            DataSource source = new FileDataSource(capsuleFile);
            pkg.setDocumentFile(new DataHandler(source));
          }
          asyncDhxPackageService.sendPackage(pkg);

        } catch (DhxException ex) {
          log.debug("Error occured while sending document to DHX");
          log.error(ex.getMessage(), ex);
          dvk.core.Fault fault = new Fault();
          fault.setFaultCode(ex.getExceptionCode().toString());
          fault.setFaultString("Error occured before sendind the document." + ex.getMessage());
          recipient.setFault(fault);
          recipient.setRecipientStatusId(5);
          recipient.setSendStatusID(103);
          recipient.setSendingEndDate(new Date());
        } catch (Exception ex) {
          log.debug("Error occured while sending document to DHX");
          log.error(ex.getMessage(), ex);
          dvk.core.Fault fault = new Fault();
          fault.setFaultString("Error occured before sendind the document." + ex.getMessage());
          recipient.setFault(fault);
          recipient.setRecipientStatusId(5);
          recipient.setSendStatusID(103);
          recipient.setSendingEndDate(new Date());
        } finally {
          recipient.update(conn, null);
          CommonMethods.safeCloseWriter(bw);
          CommonMethods.safeCloseWriter(ow);
          CommonMethods.safeCloseStream(out);
          bw = null;
          ow = null;
          out = null;
          // dhx component sends documents asynchronously and we dont know when it will be safe to
          // delete attachment file, therefore, we wont delete it

        }
      }
    }
  }

  @Loggable
  public void sendDvkToDhx() {
    log.info("sendDvkToDhx invoked.");
    Connection conn = null;
    try {
      conn = getConnection();
      Date resendDate = new Date();
      resendDate = new Date(resendDate.getTime() - resendTimeout * 60 * 1000);
      ArrayList<Document> documents = Document
          .getNotSentDhxDocumentsForSending(resendDate, conn);
      for (Document doc : documents) {
        try {
          sendSingleDocument(doc, conn);
        } finally {
          if (doc.getFilePath() != null) {
            new File(doc.getFilePath()).delete();
          }
        }
      }
    } catch (Exception ex) {
      log.error("Error occured while sending DVk documents to DHX" + ex.getMessage(), ex);
    } finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
      conn = null;
    }

  }

  public Connection getConnection() throws AxisFault {
    try {
      Context initContext = new InitialContext();
      Context envContext = (Context) initContext.lookup("java:/comp/env");
      javax.sql.DataSource ds = (javax.sql.DataSource) envContext
          .lookup(serverDatabaseEnvironmentVariable);
      return ds.getConnection();
    } catch (Exception ex) {
      log.error(ex.getMessage(), ex);
      throw new AxisFault(
          "DVK Internal error. Error connecting to database: "
              + ex.getMessage());
    }
  }

  @Override
  public void saveSendResult(DhxSendDocumentResult finalResult,
      List<AsyncDhxSendDocumentResult> retryResults) {
    log.info("sendDvkToDhx invoked.");
    Connection conn = null;
    Boolean allSent = true;
    try {
      conn = getConnection();
      String recipientIdStr = finalResult.getSentPackage().getInternalConsignmentId();
      Integer recipientId = Integer.parseInt(recipientIdStr);
      Recipient recipient = Recipient.getById(recipientId, conn);
      SendDocumentResponse docResponse = finalResult.getResponse();
      recipient.setSendingEndDate(new Date());
      if (docResponse.getFault() == null) {
        log.debug("Document was succesfuly sent to DHX");
        recipient.setDhxExternalReceiptId(docResponse
            .getReceiptId());
        recipient.setRecipientStatusId(11);
        recipient.setSendStatusID(102);
        recipient.setSendingEndDate(new Date());
      } else {
        log.debug("Fault occured while sending document to DHX");
        log.debug("All attempts to send documents were done. Saving document as failed.");
        recipient.setRecipientStatusId(5);
        recipient.setSendStatusID(103);
        recipient.setSendingEndDate(new Date());
        dvk.core.Fault fault = new Fault();
        String faultString = "";
        if (retryResults != null && retryResults.size() > 0) {
          faultString = faultString + " Total retries count: " + retryResults.size()
              + " Results for individual retries: ";
          for (AsyncDhxSendDocumentResult result : retryResults) {
            faultString = faultString + "\n Retry date: " + result.getTryDate()
                + " Technical error:";
            if (result.getResult().getOccuredException() != null) {
              faultString =
                  faultString + " Error message:"
                      + result.getResult().getOccuredException().getMessage()
                      + " Stacktrace: "
                      + ExceptionUtils.getStackTrace(result.getResult().getOccuredException());
            }
          }
        }
        faultString = docResponse.getFault()
            .getFaultString() + faultString;
        fault.setFaultCode(docResponse.getFault()
            .getFaultCode());
        fault.setFaultString(docResponse.getFault().getFaultString());
        fault.setFaultDetail(faultString.substring(0, (faultString.length() > 1900
            ? 1900
            : faultString.length())));
        recipient.setFault(fault);
      }
      recipient.update(conn, null);
      List<Recipient> recipients = Recipient.getList(recipient.getSendingID(), conn);
      for (Recipient docRecipient : recipients) {
        if (docRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
          allSent = false;
        }
      }
      if (allSent) {
        Sending.updateStatus(recipient.getSendingID(), CommonStructures.SendStatus_Sent,
            new Date(), conn);
      }
    } catch (Exception ex) {
      log.error("Error occured while saving send results. " + ex.getMessage(), ex);
    } finally {
      CommonMethods.safeCloseDatabaseConnection(conn);
      conn = null;
    }
  }

}
