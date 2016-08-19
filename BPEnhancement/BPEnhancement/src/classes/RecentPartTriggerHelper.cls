/**
 * Author: Tarun Khandelwal
 * Since: Nov. 13, 2014
 * Name: RecentPartTriggerHelper
 * Description: Helper class for triggers on Recent Part object
**/
public with sharing class RecentPartTriggerHelper {
    
    // List to store trigger new list
    public static List<Recent_Part__c> recentPartNewList = new List<Recent_Part__c>();
    
    // List to store trigger old list
    public static List<Recent_Part__c> recentPartOldList = new List<Recent_Part__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Recent_Part__c> recentPartNewMap = new Map<Id, Recent_Part__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Recent_Part__c> recentPartOldMap = new Map<Id, Recent_Part__c>();
    
    // Variable to store number of recent records that are to be displayed on grid.
    private static Integer numberOfRecentRecordsInGridToShow = 20;
    
    /**
     * Name: beforeInsertOperation
     * Desc: Method to insure that recent Part Records should not be more than 20. 
     * @param: 
     * @return: 
    **/
    public static void beforeInsertOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Recent_Part__c> currentlyExistingRecentPart = [select Id, Part__c From Recent_Part__c Where CreatedById = :UserInfo.getUserId() order by LastModifiedDate Desc];
       // Integer NumberOfDeletedRecords = deleteRecentPartIfAlreadyPresent(currentlyExistingRecentPart);
        if(recentPartNewList.size() + currentlyExistingRecentPart.size() <= numberOfRecentRecordsInGridToShow ) {
            return;
        } else {
            Integer NumberOfRecordsToDel =  recentPartNewList.size() + currentlyExistingRecentPart.size() - numberOfRecentRecordsInGridToShow;
            deleteLastRecentPartRecords(NumberOfRecordsToDel, currentlyExistingRecentPart);
        }
    }
    
    /**
     * Name: deleteLastRecentPartRecords
     * Desc: Method to delete recent Part Records. 
     * @param: noOfRecords - Integer - Number of records to be deleted
     *         currentRecParts - List<Recent_Part__c> - presentaly existing recent Part records list from which reccords are to be deleted
     * @return: 
    **/
    private static void deleteLastRecentPartRecords(Integer noOfRecords, List<Recent_Part__c> currentRecParts) {
    	if(AccessControl.ifObjectIsDeletable('Recent_Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Recent_Part__c> recentPartListToBeDel = new List<Recent_Part__c>(); 
        
        for(Integer counter = 0; counter < noOfRecords; counter++) {
            Recent_Part__c recentPartToBeDel = currentRecParts.remove(currentRecParts.size() - 1);
            recentPartListToBeDel.add(recentPartToBeDel);
        }
        
        if(recentPartListToBeDel.size() > 0) {           
            delete recentPartListToBeDel;
        }
    }
    
    /**
     * Name: deleteRecentPartIfAlreadyPresent
     * Desc: Method to delete recent Part Records if the same record is already present. 
     * @param: currentRecParts - List<Recent_Part__c> - presentaly existing recent Part records list from which reccords are to be deleted
     * @return: Integer - number of recent Part reccords that are to be deleted.
    **/
   /* private static Integer deleteRecentPartIfAlreadyPresent(List<Recent_Part__c> currentRecParts) {
        List<Recent_Part__c> recentPartListToBeDel = new List<Recent_Part__c>(); 
        Map<Id, Recent_Part__c> PartIdToRecentPartRecMap = new Map<Id, Recent_Part__c>();
        
        for(Recent_Part__c recPart : currentRecParts) {
            PartIdToRecentPartRecMap.put(recPart.Part__c, recPart);
        }
        for(Recent_Part__c newRecPart : recentPartNewList) {
            if(PartIdToRecentPartRecMap.containsKey(newRecPart.Part__c)) {
                recentPartListToBeDel.add(PartIdToRecentPartRecMap.get(newRecPart.Part__c));
            }
        }
        
        if(recentPartListToBeDel.size() > 0) {
            delete recentPartListToBeDel;
        }
        return recentPartListToBeDel.size();
    }*/
}