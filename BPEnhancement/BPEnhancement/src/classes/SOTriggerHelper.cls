/**
 * Author: Tarun Khandelwal
 * Since: March 08, 2016
 * Name: SOTriggerHelper
 * Description: Helper class for triggers on SO Header object
**/
public with sharing class SOTriggerHelper {
	
	// List to store trigger new list
    public static List<Service_Order_Header__c> soHeaderNewList = new List<Service_Order_Header__c>();
     
    // List to store trigger old list
    public static List<Service_Order_Header__c> soHeaderOldList = new List<Service_Order_Header__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Service_Order_Header__c> soHeaderNewMap = new Map<Id, Service_Order_Header__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Service_Order_Header__c> soHeaderOldMap = new Map<Id, Service_Order_Header__c>();
    
    public static Boolean isTriggerRun = false;
    
    public static List<Price_Level__c> defaultPriceLevel;
    
    public static String CLAIM_UNSUBMITTED_STATUS = 'Unsubmitted';
    
    public static String COMPLETE_STATUS = 'Complete';
    public static String REVIEWED_STATUS = 'Reviewed';
    public static String SIGNEDOUT_STATUS = 'Signed Out';
    
     /**
     * Name: beforeInsertOperation
     * Desc: Before Insert Method
     * @param:  
     * @return: 
    **/
    public static void beforeInsertOperation() {
    	populateLabourSalesTaxField();
    }
    
    public static void beforeUpdateOperation() {
    	if(entryConditionForProviderPriceLevel()) {
    		updatePriceLevelFieldsOfProvider();
    	}
    	if(entryConditionForSOHeaderStatus()) {
    		updateStatusFieldForSOHeader();
    	}
    	updateClaimStatus();
    }
    
    private static void updateClaimStatus() {
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		if(soHeaderNewMap.get(soHeaderRec.Id).Provider__c != null && soHeaderOldMap.get(soHeaderRec.Id).Provider__c == null && 
    					soHeaderNewMap.get(soHeaderRec.Id).Claim_Status__c == null) 
    		{
    			soHeaderRec.Claim_Status__c = CLAIM_UNSUBMITTED_STATUS;
    		}			
    	}
    }
    
    private static Boolean entryConditionForProviderPriceLevel() {
    	Boolean isValidEntry = false;
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		if(soHeaderNewMap.get(soHeaderRec.Id).Provider__c != soHeaderOldMap.get(soHeaderRec.Id).Provider__c) {
    			isValidEntry = true;
    		}
    		
    	}
    	return isValidEntry;
    }
    
    private static Boolean entryConditionForSOHeaderStatus(){
    	Boolean isValidEntry = false;
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
	    	if((soHeaderNewMap.get(soHeaderRec.Id).Work_Status__c != soHeaderOldMap.get(soHeaderRec.Id).Work_Status__c) &&
				 (soHeaderNewMap.get(soHeaderRec.Id).Work_Status__c == COMPLETE_STATUS 
                 || soHeaderNewMap.get(soHeaderRec.Id).Work_Status__c == REVIEWED_STATUS || 
                 soHeaderNewMap.get(soHeaderRec.Id).Work_Status__c == SIGNEDOUT_STATUS )){
				 isValidEntry = true;
	    	}
    	}
    	return isValidEntry;
    }
    
    
    
    private static void updateStatusFieldForSOHeader(){
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		if(soHeaderRec.Work_Status__c != null){
    			if(soHeaderRec.Work_Status__c == SIGNEDOUT_STATUS) {
    				soHeaderRec.Status__c = COMPLETE_STATUS ;
    			} else {
    				soHeaderRec.Status__c = soHeaderRec.Work_Status__c;
    			}
    		}
    	}
    }
    
    private static void updatePriceLevelFieldsOfProvider() {
    	List<Id> providerIdList = new List<Id>();
		for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
			if(soHeaderRec.Provider__c != null) {
				providerIdList.add(soHeaderRec.Provider__c);
			}
		}
		
		Map<Id, Account> vendorMap = new Map<Id, Account>();
		if(providerIdList.size() > 0) {
			if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			vendorMap = new Map<Id, Account>([select Price_Level__c, Price_Level__r.Discount_Markup__c, Price_Level__r.Part_Price_Base__c from Account where Id IN : providerIdList]);
		}
		
		for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
			if(soHeaderRec.Provider__c == null) {
				soHeaderRec.Provider_Discount_Markup__c = null;
				soHeaderRec.Provider_Part_Price_Base__c = null;
			
			} else if(vendorMap.containsKey(soHeaderRec.Provider__c) && vendorMap.get(soHeaderRec.Provider__c).Price_Level__c != null) {
				soHeaderRec.Provider_Discount_Markup__c = vendorMap.get(soHeaderRec.Provider__c).Price_Level__r.Discount_Markup__c;
				soHeaderRec.Provider_Part_Price_Base__c = vendorMap.get(soHeaderRec.Provider__c).Price_Level__r.Part_Price_Base__c;
			} else {
				if(defaultPriceLevel == null) {
					defaultPriceLevel = getDefaultPriceLevel();
				} 
				soHeaderRec.Provider_Discount_Markup__c = (defaultPriceLevel.size() > 0) ? defaultPriceLevel[0].Discount_Markup__c : 0;
				soHeaderRec.Provider_Part_Price_Base__c = (defaultPriceLevel.size() > 0) ? defaultPriceLevel[0].Part_Price_Base__c : null;
			}
		}
    }
    
    /**
     * Name: getDefaultPriceLevel
     * Desc: Method to get Default Price Level In system
     * @param: 
     * @return:  List<Price_Level__c> - List of default price level. Ideally size of list - 1 
    **/
    private static List<Price_Level__c> getDefaultPriceLevel() {
    	if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	defaultPriceLevel = [select Part_Price_Base__c, Discount_Markup__c from Price_Level__c where Default__c = true];
    	return defaultPriceLevel;
    }
    
    
    private static void updateCOHeaders() {
    	if(isTriggerRun) {
    		return;
    	}
    	
    	Set<Id> coHeaderIdSet = new Set<Id>();
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		coHeaderIdSet.add(soHeaderRec.CO_Header__c);
    	}
    	
    	List<CO_Header__c> coHeaderList = new List<CO_Header__c>();
    	for(Id coHeaderId : coHeaderIdSet) {
    		coHeaderList.add(new CO_Header__c(Id = coHeaderId));
    	}
    	
    	if(coHeaderList.size() > 0) {
    		if(AccessControl.ifObjectFieldIsUpdateable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update coHeaderList;
    	}
    }
    
    /**
     * Name: updateLabourRelatedSOLIs
     * Desc: Update Labour Related Service Order List Items
     * @param:  
     * @return: 
    **/
    public static void updateLabourRelatedSOLIs() {
    	
    	updateCOHeaders();
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Service_Order_Line_Item__c> solis = [select Labour_Code__c from Service_Order_Line_Item__c where Service_Order_Header__c =: soHeaderNewList AND Labour_Code__c != null];
    	Boolean isValidEntry = false;
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		if(soHeaderNewMap.get(soHeaderRec.Id).Labour_Tax__c != soHeaderOldMap.get(soHeaderRec.Id).Labour_Tax__c) {
    			isValidEntry = true;
    		}
    	}
    	if(isTriggerRun || !isValidEntry) {
    		return;
    	}
    	
    	if(solis.size() > 0) {
    		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = true;
    		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update solis;
    	}
    	isTriggerRun = true;
    }
    
     /**
     * Name: populateLabourSalesTaxField
     * Desc: Populate Labour Sales Tax Field
     * @param:  
     * @return: 
     **/
    private static void populateLabourSalesTaxField() {
    	List<Id> coHeaderIdList = new List<Id>();
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		coHeaderIdList.add(soHeaderRec.CO_Header__c);
    	}
    	Sales_Tax__c defaultSalesTax;  
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Service_Order_Header__c> soHeaderList = [select CO_Header__r.Customer__r.Sales_Tax__r.Labour_Tax__c from Service_Order_Header__c where CO_Header__c IN: coHeaderIdList];
    	Map<Id, Decimal> coHeaderIdToLabourRateMap = new Map<Id, Decimal>();
    	for(Service_Order_Header__c soHeaderRec : soHeaderList) {
    		if(!coHeaderIdToLabourRateMap.containsKey(soHeaderRec.CO_Header__c)) {
    			if(soHeaderRec.CO_Header__r.Customer__r.Sales_Tax__r.Labour_Tax__c != null) {
    				coHeaderIdToLabourRateMap.put(soHeaderRec.CO_Header__c, soHeaderRec.CO_Header__r.Customer__r.Sales_Tax__r.Labour_Tax__c);
    			} else {
    				if(defaultSalesTax == null) {
    					defaultSalesTax = getDefaultSalesTax();
    				}
    				coHeaderIdToLabourRateMap.put(soHeaderRec.CO_Header__c, defaultSalesTax.Labour_Tax__c);
    			}
    		}
    	}
    	
    	for(Service_Order_Header__c soHeaderRec : soHeaderNewList) {
    		if(coHeaderIdToLabourRateMap.containsKey(soHeaderRec.CO_Header__c)) {
    			soHeaderRec.Labour_Tax__c = coHeaderIdToLabourRateMap.get(soHeaderRec.CO_Header__c);
    		} else {
    			soHeaderRec.Labour_Tax__c = 0;
    		}
    	}
    }
    
      /**
     * Name: getDefaultSalesTax
     * Desc: Getting Default Sales Tax
     * @param: (1) getDefaultSalesTax - Sales_Tax__c - Sales Tax Record 
     * @return: 
     **/
    private static Sales_Tax__c getDefaultSalesTax() {
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Sales_Tax__c> salesTaxList = [select Id, Default__c, Labour_Tax__c from Sales_Tax__c where Default__c = true];
    	Sales_Tax__c salesTax = new Sales_Tax__c(Labour_Tax__c = 0);
    	if(salesTaxList.size() > 0) {
    		salesTax = salesTaxList[0]; 
    	}
    	return salesTax;
    }
}