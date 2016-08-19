/**
 * Author: Tarun Khandelwal
 * Since: July 09, 2015
 * Name: VendorSuggestion
 * Description: Apex class to handle JSON related oprations of suggestion of Vendor records.
**/
global with sharing class VendorSuggestion implements Comparable {

	// Vendor Name
    public String VendorName;
    
    // Vendor Account Number
    public String VendorCode;
    
    // Billing Address Fields
    public String BillingStreet1;
    
    // Home Eamil Address
    public String WorkEmail;
    
    // Home Number
    public String WorkNumber;
    
    // Priority Number
    public Integer PriorityValue;
    
    // Id
    public String Id;
    
    // Constructor
    public VendorSuggestion(Account vendorRec, Integer priorityNumber) { 
    	this.VendorName = vendorRec.Name;
    	this.WorkEmail = (vendorRec.Work_Email__c == null) ? '' : vendorRec.Work_Email__c;
    	this.WorkNumber = (vendorRec.Work_Number__c == null ) ? '' : vendorRec.Work_Number__c;
    	this.PriorityValue = priorityNumber;
    	this.VendorCode = (vendorRec.Vendor_Code__c == null ) ? '' : vendorRec.Vendor_Code__c;
    	this.Id = vendorRec.Id;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static VendorSuggestion parse(String json) {
        return (VendorSuggestion) System.JSON.deserialize(json, VendorSuggestion.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> vendorSuggestionFields = new List<String>{ 'Id',
                                                        'Name',
                                                        'Facebook__c',
                                                        'Is_Vendor__c',
                                                        'LinkedIn__c',
                                                        'Mobile__c',
                                                        'Other_Email__c',
                                                        'Twitter__c',
                                                        'Vendor_Code__c',
                                                        'Work_Email__c',
                                                        'Work_Number__c',
                                                        'BillingStreet'
                                                };
        return vendorSuggestionFields;
    }
    
    
    global Integer compareTo(Object compareTo) {
    	VendorSuggestion compareToWrapperObj = ((VendorSuggestion)compareTo);
    	Integer returnValue = 0;
    	if (PriorityValue == compareToWrapperObj.PriorityValue) return 0;
        if (PriorityValue > compareToWrapperObj.PriorityValue) return 1;
        return -1; 
    }
}