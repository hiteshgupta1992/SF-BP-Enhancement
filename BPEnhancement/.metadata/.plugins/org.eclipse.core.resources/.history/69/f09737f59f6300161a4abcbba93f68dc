/**
 * Author: Ashish Garg
 * Since: Aug 8, 2015
 * Name: VORHeader
 * Description: Apex class to handle all operations related to Vendor Order Receiving Header record.
**/
public with sharing class VORHeader {
	public String VORId;
	public String VORName;
	
	public String VendorId;
    public String VendorName;
    
    public String OwnerId;
    public String OwnerName;
    
    public boolean IsReceivingFromInvoice;
    public decimal ReceivingFromInvoiceTotal;
    
    public String Status;
	public String PackagingSlipNumber;
	public decimal ReceivingTotal;
	/**
     * Name: VORHeader
     * Desc: Constructor
     * @param:  (1) vorId - String - Vendor Order Receiving Id
     * @return: 
    **/
	public VORHeader(Vendor_Receiving_Header__c vorRecord){
		this.VORId = vorRecord.Id;
		this.VORName = vorRecord.Name;
		this.VendorId = vorRecord.Vendor__c;
		this.VendorName = vorRecord.Vendor__r.Name;
		this.OwnerId = vorRecord.Owner__c;
		this.OwnerName = vorRecord.Owner__r.Name;
		this.IsReceivingFromInvoice = false;
		this.IsReceivingFromInvoice = vorRecord.Is_Receiving_From_Invoice__c;
		this.ReceivingFromInvoiceTotal = vorRecord.Receiving_From_Invoice_Total__c;
		this.Status = vorRecord.Status__c;
		this.PackagingSlipNumber = vorRecord.Packing_Slip_Number__c;
		this.ReceivingTotal = vorRecord.Receiving_Total__c;
	}
	
	/**
     * Name: getVORDetails
     * Desc: Method to get Vendor Order Receiving record by Id value passed in arguments
     * @param:  (1) vorId - Id - VOR Id
     * @return: VORHeader - Class Object
    **/
	public static VORHeader getVORDetails(Id vorId){
		List<Vendor_Receiving_Header__c> vorHeaderRecords = SOQLUtil.getVORDetails('Id', vorId);
		if(vorHeaderRecords.size() > 0){
			return new VORHeader(vorHeaderRecords[0]);
		}
		return null;
	}
	
	/**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VORHeader - Class Object
    **/
    public static VORHeader parse(String json) {
        return (VORHeader) System.JSON.deserialize(json, VORHeader.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> vorHeaderFieldsList = new List<String>{'Id', 
        													'Vendor__c',
        													'Vendor__r.Name', 
        													'Status__c', 
        													'Owner__c',
        													'Owner__r.Name', 
        													'Name',
        													'Is_Receiving_From_Invoice__c',
        													'Packing_Slip_Number__c',
        													'Receiving_From_Invoice_Total__c',
        													'Receiving_Total__c'
        												};
        return vorHeaderFieldsList;
    }
}