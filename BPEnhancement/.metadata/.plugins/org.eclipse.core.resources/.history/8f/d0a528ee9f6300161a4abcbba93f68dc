/**
 * Author: Tarun Khandelwal
 * Since: Oct. 10, 2014
 * Name: PriceLevelTriggerHelper
 * Description: Helper class for triggers on price level object
**/
public with sharing class PriceLevelTriggerHelper {
    
    // List to store trigger new list
    public static List<Price_Level__c> priceLevelNewList = new List<Price_Level__c>();
    
    // List to store trigger old list
    public static List<Price_Level__c> priceLevelOldList = new List<Price_Level__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Price_Level__c> priceLevelNewMap = new Map<Id, Price_Level__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Price_Level__c> priceLevelOldMap = new Map<Id, Price_Level__c>();
    
    // Boolean variable to check execution of trigger
    public static boolean runDefaultCheckBoxUpdate = true;
    
    /**
     * Name: updateDefaultField
     * Desc: If current record Default field is selected, Unselects Default field of all remaining records.
     * @param: 
     * @return: 
    **/
    public static void updateDefaultField() {
    	if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsUpdateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        
        if( runDefaultCheckBoxUpdate ) {
            Boolean defaultFieldUpdated = false;
            for(Price_Level__c priceLevel : priceLevelNewList) {
                if( trigger.isInsert ) {
                    if( priceLevel.Default__c ) {
                        defaultFieldUpdated = true;
                    }
                }
                else if ( trigger.isUpdate ) {
                    if( priceLevel.Default__c && (!priceLevelOldMap.get(priceLevel.Id).Default__c) ) {
                        defaultFieldUpdated = true;
                    }
                }
                
                if( defaultFieldUpdated ) {
                    break;
                }
            }
            
            if( defaultFieldUpdated ) {
            	
                List<Price_Level__c> priceLeveleToUpdate = new List<Price_Level__c>();
                List<Price_Level__c> allPriceLevel = [select Id, Default__c from Price_Level__c limit : Limits.getLimitDMLRows()];
                
                for(Price_Level__c priceLevel : priceLevelNewList) {
                    if(priceLevel.Default__c) {
                        for(Price_Level__c oldPriceLevel : allPriceLevel) {
                            if(oldPriceLevel.Default__c) {
                                oldPriceLevel.Default__c = false;
                                priceLeveleToUpdate.add(oldPriceLevel);
                            }
                        }
                    }
                }
                
                if(priceLeveleToUpdate.size() > 0) {
                    runDefaultCheckBoxUpdate = false;
                    update priceLeveleToUpdate;
                }
            }
        }
    }
    
    /**
     * Name: validateBeforeDel
     * Desc: Validate the deleting record before deleting if it default and active record or not
     * @param: 
     * @return: 
    **/
    public static void validateBeforeDel() {
    	for(Price_Level__c PL : priceLevelOldList){
    		if( PL.Default__c == true && PL.Active__c == true ){
    			PL.addError('Cannot delete a default Price Level record.');
    		}
    	}
    }
}