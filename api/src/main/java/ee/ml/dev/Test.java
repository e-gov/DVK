package ee.ml.dev;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Hibernate;
import dvk.api.DVKAPI;
import dvk.api.DVKConstants;
import dvk.api.ICounter;
import dvk.api.IMessageRecipient;
import dvk.api.ISettingsFolderObserver;
import dvk.api.ISetting;
import dvk.api.ISettingsFolder;
import dvk.api.IMessage;
import dvk.api.ISessionCacheBox;
import dvk.api.IOccupation;
import dvk.api.IOrganization;
import dvk.api.ISubdivision;
import dvk.api.MessageRecipientCreateArgs;
import dvk.api.DVKAPI.DvkType;
import dvk.api.ml.Util;

public class Test
{
	private enum Operation {
		Insert, Update, Delete, ListAll
	}

	private static DvkStuff.Company _organization;
	private static DvkStuff.Occupation _occupation;
	private static DvkStuff.Person _personDieter;
	private static DvkStuff.Person _personTomas;
	private static DvkStuff.Subdivision _subdivision;
	private static long _testId = 1000;
	private static BigDecimal _code = new BigDecimal(1000);
	private static boolean _initialized;

	public static void main(String[] args) {
		executeTest(Operation.Insert, 9);
	}

	public static void test9(ISessionCacheBox box) {
		ISettingsFolder sf = box.getSettingsFolder(71);
		sf.setFolderName("123");

		ISettingsFolderObserver sfOrig = sf.getOrigin();

		System.out.println(sf.getFolderName());
		System.out.println(sfOrig.getFolderName());
	}

	public static void test1_Counter(Operation op, ISessionCacheBox box) {
		// INSERT and DELETE are available
		// no UPDATE is available -> exception will be thrown

		boolean hasRows = box.countRows(DvkType.Counter) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		BigDecimal id = new BigDecimal(4);

		// Counter is a standalone element
		//
		// Obtain subdivision
		// 1) EXISTING: box.getCounter(idCounter, false)
		// 2) NEW: box.getCounter(idCounter, true)

		switch (op)
			{
			case Insert:
				ICounter newCounter = box.getCounter(id, true);

				if (newCounter.isNew()) {
					newCounter.save();
				}
				break;
			case Delete:
				boolean callObjDelete = true;

				if (callObjDelete) {
					ICounter counter = box.getCounter(id, false);

					if (counter != null) {
						counter.delete();
					}
				} else {
					box.delete(DvkType.Counter, id);
				}

				break;
			case ListAll:
				List<ICounter> list = box.getAllCounters();

				if (!Util.isEmpty(list)) {
					for (ICounter c : list) {
						System.out.println(c);
					}
				}
				break;
			}
	}

	public static void test2_Organization(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.Organization) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		initDvkStuff();

		// Organization is a descendants' container
		//
		// Obtain organization
		// 1) EXISTING: box.getOrganization(orgCode, false)
		// 2) NEW: box.getOrganization(orgCode, true)

		switch (op)
			{
			case Insert:
				IOrganization org = ensureOrganization(box, false);

				if (org.isNew()) {
					org.save();
				}

				break;
			case Update:
				org = box.getOrganization(_organization.getCode(), false);

				if (org == null) {
					System.out.println("Not exists");
					break;
				}

				org.setName("[" + getCurrTime() + "] Kalev ");
				org.save();

				break;
			case Delete:
				boolean callObjDelete = true;

				if (callObjDelete) {
					org = box.getOrganization(_organization.getCode(), false);

					if (org != null) {
						org.delete();
					}
				} else {
					box.delete(DvkType.Organization, _organization.getCode());
				}

				break;
			case ListAll:
				List<IOrganization> orgList = box.getAllOrganizations();
				if (!Util.isEmpty(orgList)) {
					for (IOrganization o : orgList) {
						System.out.println(o);
					}
				}
				break;
			}
	}

	public static void test3_Subdivision(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.Subdivision) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		initDvkStuff();
		BigDecimal subdivisionCode = _subdivision.getCode();

		// Subdivision is a descendant and needs for valid [orgCode]
		//
		// Obtain subdivision
		// 1) EXISTING: box.getSubdivision(subdivisionCode)
		// 2) NEW: organization.createSubdivision(BigDecimal subdivisionCode)

		switch (op)
			{
			case Insert:
				IOrganization org = ensureOrganization(box, false);
				//
				ISubdivision subdiv = org.createSubdivision(subdivisionCode);
				subdiv.setName("Subdivision #" + subdivisionCode);
				subdiv.save();

				break;
			case Update:
				subdiv = box.getSubdivision(subdivisionCode);

				if (subdiv != null) {
					subdiv.setName("[" + getCurrTime() + "] Subdivision ");
					subdiv.save();
				}

				break;
			case Delete:
				boolean callObjDelete = true;

				if (callObjDelete) {
					subdiv = box.getSubdivision(subdivisionCode);

					if (subdiv != null) {
						subdiv.delete();
					}
				} else {
					box.delete(DvkType.Subdivision, subdivisionCode);
				}
				break;
			case ListAll:
				List<ISubdivision> subdivList = box.getAllSubdivisions();

				if (!Util.isEmpty(subdivList)) {
					for (ISubdivision s : subdivList) {
						System.out.println(s);
					}
				}
				break;
			}
	}

	public static void test4_Occupation(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.Occupation) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		initDvkStuff();
		BigDecimal occupationCode = _occupation.getCode();

		// Occupation is a descendant and needs for valid [orgCode]
		//
		// Obtain occupation
		// 1) EXISTING: box.getOccupation(occupationCode)
		// 2) NEW: organization.createOccupation(BigDecimal occupationCode)

		switch (op)
			{
			case Insert:
				IOrganization org = ensureOrganization(box);
				//
				IOccupation occup = org.createOccupation(occupationCode);
				occup.setName("Occupation #" + occupationCode);
				org.save();

				break;
			case Update:
				occup = box.getOccupation(occupationCode);

				if (occup != null) {
					occup.setName("[" + getCurrTime() + "] Occupation");
					occup.save();
				}

				break;
			case Delete:
				boolean callObjDelete = true;

				if (callObjDelete) {
					occup = box.getOccupation(occupationCode);

					if (occup != null) {
						occup.delete();
					}
				} else {
					box.delete(DvkType.Occupation, occupationCode);
				}
				break;
			case ListAll:
				List<IOccupation> occupList = box.getAllOccupations();

				if (!Util.isEmpty(occupList)) {
					for (IOccupation o : occupList) {
						System.out.println(o);
					}
				}
				break;
			}
	}

	public static void test5_Setting(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.Settings) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		// Setting is a descendants' container
		//
		// Obtain setting
		// 1) EXISTING: box.getSetting(Long id, false)
		// 2) NEW: box.getSetting(Long id, true)

		switch (op)
			{
			case Insert:
				ISetting sett = ensureSetting(box, false);
				//
				sett.save();

				break;
			case Update:
				if (!hasRows) {
					break;
				}
				sett = box.getSetting(_testId, false);

				if (sett != null) {
					sett.setInstitutionName("[" + getCurrTime() + "] InstitutionName");
					sett.save();
				}

				break;
			case Delete:
				if (!hasRows) {
					break;
				}
				boolean callObjDelete = true;

				if (callObjDelete) {
					sett = box.getSetting(_testId, false);

					if (sett != null) {
						sett.delete();
					}
				} else {
					box.delete(DvkType.Settings, _testId);
				}
				break;
			case ListAll:
				if (!hasRows) {
					break;
				}
				List<ISetting> settList = box.getAllSettings();

				if (!Util.isEmpty(settList)) {
					for (ISetting s : settList) {
						System.out.println(s);
					}
				}
				break;
			}
	}

	public static void test6_SettingsFolders(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.SettingsFolder) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		// SettingsFolder is a descendant and needs for valid [settingId]
		//
		// Obtain settings folder
		// 1) EXISTING: box.getSettingsFolder(long id)
		// 2) NEW: setting.createSettingsFolder(String folderName)

		switch (op)
			{
			case Insert:
				ISetting setting = ensureSetting(box);
				//
				ISettingsFolder sf1 = setting.createSettingsFolder("Test SettingsFolder 1");
				ISettingsFolder sf2 = setting.createSettingsFolder("Test SettingsFolder 2");
				ISettingsFolder sf3 = setting.createSettingsFolder("Test SettingsFolder 3");

				boolean allAtOnce = true;

				if (allAtOnce) {
					setting.save();
				} else {
					sf1.save();
					sf2.save();
					sf3.save();
				}

				break;
			case Update:
				boolean knowValidId = false;
				ISettingsFolder sf;

				if (knowValidId) {
					long validId = 1000;
					sf = box.getSettingsFolder(validId);
				} else {
					sf = box.getAllSettingsFolders().get(0);
				}

				if (sf != null) {
					sf.setFolderName("[" + getCurrTime() + "] SettingsFolder");
					sf.save();
				}

				break;
			case Delete:
				boolean callObjDelete = true;
				knowValidId = false;

				if (knowValidId) {
					if (callObjDelete) {
						long validId = 1000;
						sf = box.getSettingsFolder(validId);

						if (sf != null) {
							sf.delete();
						}
					} else {
						// case 2
						if (knowValidId) {
							long validId = 1000;
							box.delete(DvkType.SettingsFolder, validId);
						}
					}
				} else {
					sf = box.getAllSettingsFolders().get(0);
					sf.delete();
				}
				break;
			case ListAll:
				List<ISettingsFolder> settFolders = box.getAllSettingsFolders();

				if (!Util.isEmpty(settFolders)) {
					for (ISettingsFolder s : settFolders) {
						System.out.println(s);
					}
				}
				break;
			}
	}

	public static void test7_Message(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.Message) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		IMessage msg;
		initDvkStuff();

		// Message is a descendants' container
		//
		// Obtain message
		// 1) EXISTING: box.getMessage(Long dhlMessageId)
		// 2) NEW: box.createMessage()

		switch (op)
			{
			case Insert:
				msg = ensureMessage(box, false);

				msg.save();
				break;
			case Update:
				boolean knowVallidId = false;

				if (knowVallidId) {
					long id = 100;
					msg = box.getMessage(id);
				} else {
					msg = box.getAllMessages().get(0);
				}

				if (msg != null) {
					msg.setSenderName("[" + getCurrTime() + "] " + _personDieter.getFirstName());
					msg.save();
				}

				break;
			case Delete:
				boolean callObjDelete = true;
				knowVallidId = false;

				if (callObjDelete) {
					if (knowVallidId) {
						long id = 100;
						msg = box.getMessage(id);
					} else {
						msg = box.getAllMessages().get(0);
					}

					if (msg != null) {
						msg.delete();
					}
				} else {
					if (knowVallidId) {
						long id = 100;
						box.delete(DvkType.Message, id);
					}
				}
				break;
			case ListAll:
				List<ISettingsFolder> settFolders = box.getAllSettingsFolders();

				if (!Util.isEmpty(settFolders)) {
					for (ISettingsFolder s : settFolders) {
						System.out.println(s);
					}
				}
				break;
			}
	}

	public static void test8_MessageRecipient(Operation op, ISessionCacheBox box) {
		boolean hasRows = box.countRows(DvkType.MessageRecipient) > 0;

		if (!hasRows) {
			if (op == Operation.Update || op == Operation.Delete || op == Operation.ListAll) {
				return;
			}
		}

		IMessageRecipient recip;
		initDvkStuff();

		// MessageRecipient is a descendant and needs for valid
		// [dhlMessageId, recipientOrgCode, recipientPersonCode, sendingStatusId,
		// recipientDivisionId, recipientPositionId]
		//
		// Obtain message recipient
		// 1) EXISTING: box.getMessageRecipient(BigDecimal id)
		// 2) NEW: message.createMessageRecipient(MessageRecipientCreateArgs createArgs)

		switch (op)
			{
			case Insert:
				IMessage msg = ensureMessage(box);

				MessageRecipientCreateArgs createArgs = new MessageRecipientCreateArgs(msg.getDhlMessageId(), _organization.getCode(),
					_personDieter.getId(), 500, _subdivision.getId(), _occupation.getId());

				recip = msg.createMessageRecipient(createArgs);
				setMessageRecipientValues(recip, msg);

				recip.save();
				break;
			case Update:
				boolean knowValidId = false;

				if (knowValidId) {
					BigDecimal id = new BigDecimal(100);
					recip = box.getMessageRecipient(id);
				} else {
					recip = box.getAllMessageRecipients().get(0);
				}

				if (recip != null) {
					recip.setRecipientName("[" + getCurrTime() + "] " + _personDieter.getFirstName());
					recip.save();
				}

				break;
			case Delete:
				knowValidId = false;

				if (knowValidId) {
					BigDecimal id = new BigDecimal(100);
					recip = box.getMessageRecipient(id);
				} else {
					recip = box.getAllMessageRecipients().get(0);
				}

				boolean callObjDelete = true;

				if (callObjDelete) {
					if (recip != null) {
						recip.delete();
					}
				} else {
					if (knowValidId) {
						BigDecimal id = new BigDecimal(100);
						box.delete(DvkType.MessageRecipient, id);
					}
				}

				break;
			case ListAll:
				List<IMessageRecipient> list = box.getAllMessageRecipients();

				if (!Util.isEmpty(list)) {
					for (IMessageRecipient mr : list) {
						System.out.println(mr);
					}
				}
				break;
			}
	}

	public static void executeTest(Operation op, int testNumber) {
		ISessionCacheBox box = null;

		try {
			box = DVKAPI.createSessionCacheBox(DVKAPI.openGlobalSession(DVKConstants.DefaultConfigFileName));

			switch (testNumber)
				{
				case 1:
					test1_Counter(op, box);
					break;
				case 2:
					test2_Organization(op, box);
					break;
				case 3:
					test3_Subdivision(op, box);
					break;
				case 4:
					test4_Occupation(op, box);
					break;
				case 5:
					test5_Setting(op, box);
					break;
				case 6:
					test6_SettingsFolders(op, box);
					break;
				case 7:
					test7_Message(op, box);
					break;
				case 8:
					test8_MessageRecipient(op, box);
					break;
				case 9:
					test9(box);
					break;
				default:
					test1_Counter(op, box);
					test2_Organization(op, box);
					test3_Subdivision(op, box);
					test4_Occupation(op, box);
					test5_Setting(op, box);
					test6_SettingsFolders(op, box);
					test7_Message(op, box);
					test8_MessageRecipient(op, box);
					break;
				}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (box != null) {
				box.destroy();
			}

			DVKAPI.closeGlobalSession();
		}
	}

	static void setMessageValues(IMessage msg) {
		Date today = new Date();
		//
		msg.setIsIncoming(true);
		msg.setData("Viimane kohtumine oli kell " + getCurrTime());
		msg.setSendingStatusId(100);
		msg.setUnitId(300);
		msg.setTitle("Suur tervist!");
		msg.setSenderOrgCode(_organization.getCode());
		msg.setSenderOrgName(_organization.getName());
		msg.setSenderPersonCode(_personDieter.getId());
		msg.setSenderName(_personDieter.getFirstName());

		msg.setCaseName("CaseName");
		msg.setDhlFolderName("DhlFolderName");
		msg.setSendingStatusId(1);
		msg.setDhlId(new Long(1));
		msg.setSendingDate(today);
		msg.setReceivedDate(today);
		msg.setLocalItemId(new Long(1));
		msg.setRecipientStatusId(new Long(1));
		msg.setFaultCode("FaultCode");
		msg.setFaultActor("FaultActor");
		msg.setFaultString("FaultString");
		msg.setFaultDetail("FaultDetail");
		msg.setStatusUpdateNeeded(new Long(1));
		msg.setMetaxml("Metaxml");
		msg.setQueryId("QueryId");
		msg.setProxyOrgCode("ProxyOrgCode");
		msg.setProxyOrgName("ProxyOrgName");
		msg.setProxyPersonCode("ProxyPersonCode");
		msg.setProxyName("ProxyName");

		msg.setRecipientOrgCode(_organization.getCode());
		msg.setRecipientOrgName(_organization.getName());
		msg.setRecipientPersonCode(_personTomas.getId());
		msg.setRecipientName(_personTomas.getFirstName());
		msg.setRecipientDivisionId(_subdivision.getCode());
		msg.setRecipientDivisionName(_subdivision.getName());
		msg.setRecipientDepartmentNr("DepartmentNr 123");
		msg.setRecipientDepartmentName("DepartmentName Toompea");
		msg.setRecipientEmail("direktor@mail.ee");
		msg.setRecipientPositionId(new BigDecimal(1));
		msg.setRecipientPositionName("PositionName Direktor");
	}

	static void setMessageRecipientValues(IMessageRecipient msgRecip, IMessage msg) {
		Date today = new Date();
		//
		msgRecip.setDhlId(new BigDecimal(msg.getDhlId()));
		msgRecip.setFaultActor("faultActor");
		msgRecip.setFaultCode("faultCode");
		msgRecip.setFaultDetail("faultDetail");
		msgRecip.setFaultString("faultString");
		msgRecip.setMetaxml("metaxml");
		msgRecip.setProducerName("producerName");
		msgRecip.setQueryId("queryId");
		msgRecip.setReceivedDate(today);
		msgRecip.setRecipientDivisionName(_subdivision.getName());
		msgRecip.setRecipientName(_personDieter.getFirstName());
		msgRecip.setRecipientOrgName(_organization.getName());
		msgRecip.setRecipientPositionName(_occupation.getName());
		msgRecip.setRecipientStatusId(new Long(100));
		msgRecip.setSendingDate(today);
		msgRecip.setServiceUrl("www.service.com");
	}

	private static String getCurrTime() {
		return DateFormat.getTimeInstance(DateFormat.MEDIUM).format(new Date());
	}

	private static IMessageRecipient ensureMessageRecipient(ISessionCacheBox box) {

		long count = box.countRows(DvkType.MessageRecipient);

		if (count > 0) {
			return box.getAllMessageRecipients().get(0);
		}

		IMessage msg = ensureMessage(box);

		MessageRecipientCreateArgs createArgs = new MessageRecipientCreateArgs(msg.getDhlMessageId(), _organization.getCode(),
			_personDieter.getId(), 500, _subdivision.getId(), _occupation.getId());

		IMessageRecipient msgRecip = box.createMessageRecipient(createArgs);

		setMessageRecipientValues(msgRecip, msg);

		msgRecip.save();

		return msgRecip;
	}

	private static void confirmMessageRecipient(ISessionCacheBox box) {

		IMessage msg = ensureMessage(box);
		IMessageRecipient msgRecip = ensureMessageRecipient(box);

		MessageRecipientCreateArgs createArgs = new MessageRecipientCreateArgs(msg.getDhlMessageId(), _organization.getCode(),
			_personDieter.getId(), 500, _subdivision.getId(), _occupation.getId());

		IMessageRecipient mr = box.createMessageRecipient(createArgs);

		if (mr.isNew()) {
			System.out.println("Error!");
		} else if (mr == msgRecip) {
			System.out.println("All right!");
		}
	}

	private static IMessage ensureMessage(ISessionCacheBox box) {
		return ensureMessage(box, true);
	}

	private static IMessage ensureMessage(ISessionCacheBox box, boolean save) {

		if (box.countRows(DvkType.Message) > 0) {
			return box.getAllMessages().get(0);
		}

		IMessage msg = box.createMessage();

		if (msg.isNew()) {
			initDvkStuff();
			setMessageValues(msg);

			if (save) {
				msg.save();
			}
		}

		return msg;
	}

	private static ISettingsFolder ensureSettingsFolder(ISessionCacheBox box) {
		long count = box.countRows(DvkType.SettingsFolder);

		if (count == 0) {
			ISetting setting = ensureSetting(box);

			ISettingsFolder sf = setting.createSettingsFolder("Simple settings folder");
			sf.save();

			return sf;
		}

		return box.getAllSettingsFolders().get(0);
	}

	private static ISetting ensureSetting(ISessionCacheBox box) {
		return ensureSetting(box, true);
	}

	private static ISetting ensureSetting(ISessionCacheBox box, boolean save) {
		long count = box.countRows(DvkType.Settings);

		if (count == 0) {
			initDvkStuff();
			ISetting setting = box.getSetting(_testId, true);

			setting.setInstitutionCode(_organization.getCode());
			setting.setInstitutionName(_organization.getName());
			setting.setOccupationCode(_occupation.getCode());
			setting.setPersonalIdCode(_personDieter.getId());
			setting.setSubdivisionCode(_subdivision.getCode());
			setting.setUnitId(500);

			if (save) {
				setting.save();
			}
			return setting;
		}

		return box.getAllSettings().get(0);
	}

	private static ISubdivision ensureSubdivision(ISessionCacheBox box) {
		ISubdivision subdivision = box.getSubdivision(_subdivision.getCode());

		if (subdivision == null) {
			IOrganization org = ensureOrganization(box);

			subdivision = org.createSubdivision(_subdivision.getCode());
			subdivision.setName(_subdivision.getName());
			subdivision.save();
		}

		return subdivision;
	}

	private static IOccupation ensureOccupation(ISessionCacheBox box) {
		IOccupation occupation = box.getOccupation(_occupation.getCode());

		if (occupation.isNew()) {
			occupation.setName(_occupation.getName());

			IOrganization org = box.getOrganization(_organization.getCode(), false);
			org.add(occupation);
			org.save();
		}

		return occupation;
	}

	private static IOrganization ensureOrganization(ISessionCacheBox box) {
		return ensureOrganization(box, false);
	}

	private static IOrganization ensureOrganization(ISessionCacheBox box, boolean save) {
		IOrganization org = box.getOrganization(_organization.getCode(), true);

		if (org.isNew()) {
			org.setName(_organization.getName());
			org.setDhlCapable(true);
			org.setDhlDirectCapable(true);
			org.setDhlDirectProducerName("Peavalmistaja");
			org.setDhlDirectServiceUrl("www.kalev.ee");
			//
			if (save) {
				org.save();
			}
		}

		return org;
	}

	private static void initDvkStuff() {
		if (_initialized) {
			return;
		}
		_organization = new DvkStuff.Company();
		_organization.setCode("AS KALEV");
		_organization.setName("Kalev");
		//
		_subdivision = new DvkStuff.Subdivision();
		_subdivision.setCode(_code);
		_subdivision.setName("Maiustus osakond");
		_subdivision.setId(new BigDecimal(390));
		//
		_occupation = new DvkStuff.Occupation();
		_occupation.setCode(_code);
		_occupation.setName("Kondiiter");
		_occupation.setId(new BigDecimal(300));
		//
		_personDieter = new DvkStuff.Person();
		_personDieter.setFirstName("Dieter");
		_personDieter.setLastName("Bohlen");
		_personDieter.setId("123456789");
		//
		_personTomas = new DvkStuff.Person();
		_personTomas.setFirstName("Tomas");
		_personTomas.setLastName("Anderson");
		_personTomas.setId("987654321");
		//
		_initialized = true;
	}

	public static void createAll(ISessionCacheBox box) {
		ensureOrganization(box);
		ensureSubdivision(box);
		ensureOccupation(box);
		ensureSetting(box);
		ensureSettingsFolder(box);
		ensureMessage(box);
		ensureMessageRecipient(box);
		confirmMessageRecipient(box);
	}
}
