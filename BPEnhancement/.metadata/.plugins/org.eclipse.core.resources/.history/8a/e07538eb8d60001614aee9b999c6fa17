/**
 * Author: Tarun Khandelwal
 * Since: Nov. 13, 2014
 * Name: AccountTriggerHelper
 * Description: Helper class for triggers on Account object
**/
public with sharing class CustomerTriggerHelper {
    
    // List to store trigger new list
    public static List<Account> accountNewList = new List<Account>();
    
    // List to store trigger old list
    public static List<Account> accountOldList = new List<Account>();
    
    // Map to store new Trigger Map
    public static Map<Id, Account> accountNewMap = new Map<Id, Account>();

    // Map to store Old Trigger Map
    public static Map<Id, Account> accountOldMap = new Map<Id, Account>();
    
    // Trigger run boolean
    public static Boolean isTriggerRun;
    
    /**
     * Name: accountInsertOperation
     * Desc: When account record is inserted this method executes
     * @param: 
     * @return: 
    **/
    public static void accountInsertOperation() {
        //insertRecentAccountRecord();
        insertDefaultPOTypRecord();
    }
    
    /**
     * Name: accountUpdateOperation
     * Desc: When account record is updated this method executes 
     * @param: 
     * @return: 
    **/
    public static void accountUpdateOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Customer__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        List<Sobject> alreadyPresentRecentlyAccounts = new List<Sobject>();
        
        if(Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED) {
            alreadyPresentRecentlyAccounts = [select Id, Customer__c From Recent_Customer__c Where Customer__c IN : accountNewList AND CreatedById = :UserInfo.getUserId()];
        } else if(Constants.IS_RECENT_VENDOR_TO_BE_CREATED){
            alreadyPresentRecentlyAccounts = [select Id, Vendor__c From Recent_Vendor__c Where Vendor__c IN : accountNewList AND CreatedById = :UserInfo.getUserId()];
        }
        
        if(alreadyPresentRecentlyAccounts.size() > 0) {
        	if(AccessControl.ifObjectFieldIsUpdateable(alreadyPresentRecentlyAccounts[0]) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update alreadyPresentRecentlyAccounts;
        }
    }
    
    /**
     * Name: accountDeleteOperation
     * Desc: When account record is deleted this method executes and deletes the corresponding recent account records.
     * @param: 
     * @return: 
    **/
    public static void accountDeleteOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Customer__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('Sobject') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Sobject> recentAccountsTobeDeleted = new List<Sobject>();
        if(Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED) {
            recentAccountsTobeDeleted = [select Id, Customer__c From Recent_Customer__c Where Customer__c IN : accountOldList AND CreatedById = :UserInfo.getUserId()];
        } else if(Constants.IS_RECENT_VENDOR_TO_BE_CREATED){
            recentAccountsTobeDeleted = [select Id, Vendor__c From Recent_Vendor__c Where Vendor__c IN : accountOldList AND CreatedById = :UserInfo.getUserId()];
        }
        if(recentAccountsTobeDeleted.size() > 0) {
            delete recentAccountsTobeDeleted;
        }
    }
    
    /**
     * Name: insertDefaultPOTypRecord
     * Desc: create a default Purchase Order Type record
     * @param: 
     * @return: 
    **/
    private static void insertDefaultPOTypRecord() {
    	if(AccessControl.ifObjectFieldIsCreateable('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	List<PO_Type__c> poTypes = new List<PO_Type__c>();
    	
    	for(Account account : accountNewList){
    		if(account.Is_Vendor__c){
	    		PO_Type__c poType = new PO_Type__c(	Code__c = 'STANDARD',
	    											Discount__c = 0,
	    											IsDefault__c = true,
	    											Landed_Cost_Adjustment__c = 0,
	    											Lead_Time__c = 5,
	    											Usage__c = 'Standard for vendor',
	    											Vendor__c = account.Id);
	    		poTypes.add(poType);
    		}
    	}
    	
    	if(poTypes.size() > 0){
    		insert poTypes;
    	}
    }
    
    /**
     * Name: insertRecentAccountRecord
     * Desc: create Recent Account record
     * @param: 
     * @return: 
    **/
    private static void insertRecentAccountRecord() {
    	if(AccessControl.ifObjectFieldIsCreateable('Sobject') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        List<Sobject> recentSobjList = new List<Sobject>();
        for(Account account : accountNewList) {
            Sobject recentAccount;  
            if(Constants.IS_RECENT_VENDOR_TO_BE_CREATED) {
                recentAccount = new Recent_Vendor__c();
                recentAccount.put('Vendor__c', account.Id);
            } else if(Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED){
                recentAccount = new Recent_Customer__c();
                recentAccount.put('Customer__c', account.Id);
            }
            if(recentAccount != null) {
                recentSobjList.add(recentAccount);
            }
        }
        
        if(recentSobjList.size() > 0) {
            insert recentSobjList;
        }
    }
    
    /**
     * Name: populatesFieldsBeforeInsert
     * Desc: create Recent Account record
     * @param: 
     * @return: 
    **/
    public static void populatesFieldsBeforeInsert() {
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Account> vendorList = [select Name, Vendor_Count__c from Account where Is_Vendor__c = true AND Vendor_Count__c != null order by Vendor_Count__c desc limit 1];
        Integer lastVendorCount; 
        if(vendorList.size() > 0) {
            if(vendorList[0].Vendor_Count__c == null) {
                vendorList[0].Vendor_Count__c = 0;
            }
            lastVendorCount = Integer.valueOf(vendorList[0].Vendor_Count__c);
        } else {
            lastVendorCount = 0;
        }
        //system.assert(false, lastVendorCount);
        for(Account vendor : accountNewList) {
            if(vendor.Is_Vendor__c) {
            	if((trigger.isUpdate && vendor.Vendor_Count__c == null) || trigger.isInsert) {
                	vendor.Vendor_Count__c = ++lastVendorCount;
                }
                String firstThreeLettersOfName = (vendor.Name).substring(0,3).toUpperCase();
                String vendorUniqueCount = String.valueOf(vendor.Vendor_Count__c);
                vendorUniqueCount = (vendorUniqueCount.length() == 1) ? ('00' + vendorUniqueCount) : (vendorUniqueCount.length() == 2 ? ('0' + vendorUniqueCount) : vendorUniqueCount);
                vendor.Vendor_Code__c = firstThreeLettersOfName + vendorUniqueCount;
            }
        }
        populatesVendorNumberBeforeInsert();
    }
    
    /**
     * Name: populatesVendorNumberBeforeInsert
     * Desc: create Recent Account record
     * @param: 
     * @return: 
    **/
    public static void populatesVendorNumberBeforeInsert() {
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Account> vendorList = [select Name, Vendor_Number_Count__c from Account where Is_Vendor__c = true AND Vendor_Number_Count__c != null order by Vendor_Number_Count__c desc limit 1];
        Integer lastVendorNumberCount; 
        if(vendorList.size() > 0) {
            if(vendorList[0].Vendor_Number_Count__c == null) {
                vendorList[0].Vendor_Number_Count__c = 0;
            }
            lastVendorNumberCount = Integer.valueOf(vendorList[0].Vendor_Number_Count__c);
        } else {
            lastVendorNumberCount = 0;
        }
        //system.assert(false, lastVendorCount);
        for(Account vendor : accountNewList) {
            if(vendor.Is_Vendor__c) {
            	if((trigger.isUpdate && vendor.Vendor_Number_Count__c == null) || trigger.isInsert) {
                	vendor.Vendor_Number_Count__c = ++lastVendorNumberCount;
                }
                String prefix = 'VDR-';
                String vendorNumberUniqueCount = String.valueOf(vendor.Vendor_Number_Count__c);
                vendorNumberUniqueCount = (vendorNumberUniqueCount.length() == 1) ? ('000' + vendorNumberUniqueCount) : (vendorNumberUniqueCount.length() == 2 ? ('00' + vendorNumberUniqueCount) : (vendorNumberUniqueCount.length() == 3 ? ('0' + vendorNumberUniqueCount) : vendorNumberUniqueCount));
                vendor.Vendor_Number__c = prefix + vendorNumberUniqueCount;
            }
        }
    }
    
    /**
     * Name: getGeoLocation
     * Desc: create Recent Account record
     * @param: 
     * @return: 
    **/
    public static void getGeoLocation(){
    	/*Set<Id> insertedCustomerIdSet = accountNewMap.keySet();
	    String query = 'Select BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Billing_GeoLocation__c, Billing_GeoLocation__Longitude__s, Billing_GeoLocation__Latitude__s, ';
	    query += ' ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, SA_same_as_BA__c From Account where Id IN :insertedCustomerIdSet';
	    //system.assert(false, query);
	    MakeGeoLocationCalloutBatch newMake = new MakeGeoLocationCalloutBatch(query, insertedCustomerIdSet);
	    DataBase.executeBatch(newMake, 1);*/
	  }
    
    /**
     * Name: populatesFieldsBeforeUpdate
     * Desc: create Recent Account record
     * @param: 
     * @return: 
    **/
    /*public static void populatesFieldsBeforeUpdate() {
        for(Account vendor : accountNewList) {
            if(vendor.Is_Vendor__c) {
            	String vendorName = (vendor.Name).replace(' ', '');
                String firstThreeLettersOfName = vendorName.substring(0,3).toUpperCase();
                if(vendor.Vendor_Count__c == null) {
                	vendor.Vendor_Count__c = 1;
                }
                String vendorUniqueCount = String.valueOf(vendor.Vendor_Count__c);
                vendorUniqueCount = (vendorUniqueCount.length() == 1) ? ('00' + vendorUniqueCount) : (vendorUniqueCount.length() == 2 ? ('0' + vendorUniqueCount) : vendorUniqueCount);
                vendor.Vendor_Code__c = firstThreeLettersOfName + vendorUniqueCount;
            }
        }
    }*/
    
}