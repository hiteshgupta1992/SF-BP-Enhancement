/**
 * Author: Tarun Khandelwal
 * Since: Oct. 11, 2014
 * Name: ApplicableTaxTriggerHelper
 * Description: Helper class for triggers on Applicable Tax object (Used In Kendo)
**/
public with sharing class ApplicableTaxTriggerHelper {
    
     // List to store trigger new list
    public static List<Applicable_Taxes__c> applicableTaxNewList = new List<Applicable_Taxes__c>();
    
    // List to store trigger old list
    public static List<Applicable_Taxes__c> applicableTaxOldList = new List<Applicable_Taxes__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Applicable_Taxes__c> applicableTaxNewMap = new Map<Id, Applicable_Taxes__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Applicable_Taxes__c> applicableTaxOldMap = new Map<Id, Applicable_Taxes__c>();
    
    /**
     * Name: updateRateFieldOnSalesTax
     * Desc: Update Rate field of Sales Tax object to the sum of corresponding Sales Tax Item Rate 
     * @param: 
     * @return: 
    **/
    public static void  updateRateFieldOnSalesTax() {
        Set<Id> salesTaxSet = new Set<Id>();
        
        Map<Id,Sales_Tax__c> mapOfST;
        if(trigger.isInsert){
            for(Applicable_Taxes__c appTax : applicableTaxNewList){
                salesTaxSet.add(appTax.Sales_Tax__c);
            }
        } else if(trigger.isDelete){
            for(Applicable_Taxes__c appTax :applicableTaxOldList){
                salesTaxSet.add(appTax.Sales_Tax__c);
            }
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__r') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        mapOfST = new Map<Id,Sales_Tax__c>([Select Rate__c, 
                                                  (select Id, Sales_Tax_Item__c,
                                                          Sales_Tax_Item__r.Rate__c,
                                                          Sales_Tax_Item__r.Tax_Labour__c,
                                                          Sales_Tax__c 
                                                   from Applicable_Taxes__r 
                                                   ) 
                                            From Sales_Tax__c limit : Limits.getLimitDMLRows()]);
        
        for(Id salesTaxId : mapOfST.keyset()) {
        	Sales_Tax__c tax = mapOfST.get(salesTaxId);
            tax.Rate__c = 0;
            tax.Labour_Tax__c = 0;
            if( tax.Applicable_Taxes__r != null ) {
                for( Applicable_Taxes__c app : tax.Applicable_Taxes__r) {
                    tax.Rate__c += app.Sales_Tax_Item__r.Rate__c;      
                    if(app.Sales_Tax_Item__r.Tax_Labour__c) {
                    	tax.Labour_Tax__c += app.Sales_Tax_Item__r.Rate__c;
                    }        
                } 
            }
        	mapOfST.put(salesTaxId, tax);
        }
        
        if(AccessControl.ifObjectFieldIsUpdateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        update mapOfST.values();
    }
}