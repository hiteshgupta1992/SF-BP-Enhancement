/**
 * Author: Tarun Khandelwal
 * Since: Oct. 10, 2014
 * Name: SalesTaxTriggerHelper
 * Description: Helper class for triggers on price level object
**/
public with sharing class SalesTaxTriggerHelper {
    
    // List to store trigger new list
    public static List<Sales_Tax__c> salesTaxNewList = new List<Sales_Tax__c>();
    
    // List to store trigger old list
    public static List<Sales_Tax__c> salesTaxOldList = new List<Sales_Tax__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Sales_Tax__c> salesTaxNewMap = new Map<Id, Sales_Tax__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Sales_Tax__c> salesTaxOldMap = new Map<Id, Sales_Tax__c>();
    
    // Boolean variable to check execution of trigger
    public static boolean runDefaultCheckBoxUpdate = true;
    
    /**
     * Name: updateDefaultField
     * Desc: If current record Default field is selected, Unselects Default field of all remaining records.
     * @param: 
     * @return: 
    **/
    public static void updateDefaultField() {
        if(AccessControl.ifObjectFieldIsUpdateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        if( runDefaultCheckBoxUpdate ) {
            Boolean defaultFieldUpdated = false;
            for(Sales_Tax__c salesTax : salesTaxNewList) {
                if( trigger.isInsert ) {
                    if( salesTax.Default__c ) {
                        defaultFieldUpdated = true;
                    }
                }
                else if ( trigger.isUpdate ) {
                	if( salesTax.Default__c && (!salesTaxOldMap.get(salesTax.Id).Default__c) ) {
                    	defaultFieldUpdated = true;
                    }
                }
                
                if( defaultFieldUpdated ) {
                    break;
                }
            }
            
            if( defaultFieldUpdated ) {
            
                List<Sales_Tax__c> salesTaxToUpdate = new List<Sales_Tax__c>();
                if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<Sales_Tax__c> allSalesTax = [select Id, Default__c from Sales_Tax__c limit : Limits.getLimitDMLRows()];
                
                for(Sales_Tax__c salesTax : salesTaxNewList) {
                    if(salesTax.Default__c) {
                        for(Sales_Tax__c oldSalesTax : allSalesTax) {
                            if(oldSalesTax.Default__c) {
                                oldSalesTax.Default__c = false;
                                salesTaxToUpdate.add(oldSalesTax);
                            }
                        }
                    }
                }
                
                if(salesTaxToUpdate.size() > 0) {
                    runDefaultCheckBoxUpdate = false;
                    update salesTaxToUpdate;
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
    	for(Sales_Tax__c ST : salesTaxOldList){
    		if( ST.Default__c == true && ST.Active__c == true ){
    			ST.addError('Cannot delete a default Sales Tax record.');
    		}
    	}
    }
}