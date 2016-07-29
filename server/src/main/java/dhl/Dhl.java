package dhl;

import org.apache.axis.AxisFault;

public interface Dhl extends java.rmi.Remote {
	
    public void listMethods() throws AxisFault;

    public void runSystemCheck(Object keha) throws AxisFault;

    public void deleteOldDocuments(Object keha) throws AxisFault;

    public void changeOrganizationData(Object keha) throws AxisFault;

    public void getSendingOptions(Object keha) throws AxisFault;
    
    public void getSendingOptionsV2(Object keha) throws AxisFault;
    
    public void getSendingOptionsV3(Object keha) throws AxisFault;
    
    public void getSendingOptionsV4(Object keha) throws AxisFault;

    public void getSendStatus(Object p1, Object keha) throws AxisFault;

    public void markDocumentsReceived(Object p1, Object keha) throws AxisFault;
    
    public void markDocumentsReceivedV2(Object p1, Object keha) throws AxisFault;
    
    public void markDocumentsReceivedV3(Object p1, Object keha) throws AxisFault;

    public void receiveDocuments(Object keha) throws AxisFault;
    
    public void receiveDocumentsV2(Object keha) throws AxisFault;
    
    public void receiveDocumentsV3(Object keha) throws AxisFault;
    
    public void receiveDocumentsV4(Object keha) throws AxisFault;

    public void sendDocuments(Object p1, Object keha) throws AxisFault;
    
    public void sendDocumentsV2(Object p1, Object keha) throws AxisFault;
    
    public void sendDocumentsV3(Object p1, Object keha) throws AxisFault;
    
    public void sendDocumentsV4(Object p1, Object keha) throws AxisFault;

    public void getOccupationList(Object keha) throws AxisFault;

    public void getSubdivisionList(Object keha) throws AxisFault;
    
}
