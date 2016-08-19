/**
 * Author: Tarun Khandelwal
 * Since: Dec. 31, 2014
 * Name: RecentVendorTriggerHelper
 * Description: Helper class for triggers on Recent Vendor object
**/
public with sharing class RecentVendorTriggerHelper {
	
	// List to store trigger new list
    public static List<Recent_Vendor__c> recentVendorNewList = new List<Recent_Vendor__c>();
    
    // List to store trigger old list
    public static List<Recent_Vendor__c> recentVendorOldList = new List<Recent_Vendor__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Recent_Vendor__c> recentVendorNewMap = new Map<Id, Recent_Vendor__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Recent_Vendor__c> recentVendorOldMap = new Map<Id, Recent_Vendor__c>();
    
    // Variable to store number of recent records that are to be displayed on grid.
    private static Integer numberOfRecentRecordsInGridToShow = 20;
    
    /**
     * Name: beforeInsertOperation
     * Desc: Method to insure that recent vendor Records should not be more than 20. 
     * @param: 
     * @return: 
    **/
    public static void beforeInsertOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Recent_Vendor__c> currentlyExistingRecentVendor = [select Id, Vendor__c From Recent_Vendor__c Where CreatedById = :UserInfo.getUserId() order by LastModifiedDate Desc];
    	if(recentVendorNewList.size() + currentlyExistingRecentVendor.size() <= numberOfRecentRecordsInGridToShow ) {
    		return;
    	} else {
			Integer NumberOfRecordsToDel =  recentVendorNewList.size() + currentlyExistingRecentVendor.size() - numberOfRecentRecordsInGridToShow;
			deleteLastRecentVendorRecords(NumberOfRecordsToDel, currentlyExistingRecentVendor);
    	}
    }
    
    /**
     * Name: deleteLastRecentVendorRecords
     * Desc: Method to delete recent vendor Records. 
     * @param: noOfRecords - Integer - Number of records to be deleted
     *		   currentRecVendors - List<Recent_Vendor__c> - presentaly existing recent vendor records list from which reccords are to be deleted
     * @return: 
    **/
    private static void deleteLastRecentVendorRecords(Integer noOfRecords, List<Recent_Vendor__c> currentRecVendors) {
    	if(AccessControl.ifObjectIsDeletable('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	List<Recent_Vendor__c> recentVendorListToBeDel = new List<Recent_Vendor__c>(); 
    	
    	for(Integer counter = 0; counter < noOfRecords; counter++) {
			Recent_Vendor__c recentVendorToBeDel = currentRecVendors.remove(currentRecVendors.size() - 1);
			recentVendorListToBeDel.add(recentVendorToBeDel);
		}
		
		if(recentVendorListToBeDel.size() > 0) {
			delete recentVendorListToBeDel;
		}
    }
}