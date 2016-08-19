/**
 * Author: Tarun Khandelwal
 * Since: May 31, 2016
 * Name: SOPaymentRoleTriggerHelper
 * Description: Helper class for triggers on SO_Payment_Role__c object
**/
public with sharing class SOPaymentRoleTriggerHelper {
	
	// List to store trigger new list
    public static List<SO_Payment_Role__c> soPaymentRoleNewList = new List<SO_Payment_Role__c>();
    
    // List to store trigger old list
    public static List<SO_Payment_Role__c> soPaymentRoleOldList = new List<SO_Payment_Role__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, SO_Payment_Role__c> soPaymentRoleNewMap = new Map<Id, SO_Payment_Role__c>();

    // Map to store Old Trigger Map
    public static Map<Id, SO_Payment_Role__c> soPaymentRoleOldMap = new Map<Id, SO_Payment_Role__c>();
    
    // Trigger run boolean
    public static Boolean isTriggerRun;
    
    public static void afterInsertOperation() {
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	Set<Id> soHeaderIdSet = new Set<Id>();
    	for(SO_Payment_Role__c soPaymentRoleRec : soPaymentRoleNewList) {
    		soHeaderIdSet.add(soPaymentRoleRec.Service_Order_Header__c);
    	}
    	
    	Map<Id, Id> soHeaderIdToCOHeaderIdMap = populateMap(soHeaderIdSet);
    	
    	Map<Id, Id> coHeaderIdToActiveCOInvoiceHeaderIdMap = populateCOHeaderIdToActiveCOInvoiceHeaderIdMap(soHeaderIdToCOHeaderIdMap.values());
    	
    	List<CO_Invoice_Item__c> coInvoiceItemListToInsert = new List<CO_Invoice_Item__c>();
    	for(SO_Payment_Role__c soPaymentRoleRec : soPaymentRoleNewList) {
    		CO_Invoice_Item__c coInvoiceItemRec = new CO_Invoice_Item__c();
    		coInvoiceItemRec.SO_Payment_Role__c = soPaymentRoleRec.Id;
    		coInvoiceItemRec.Service_Order_Header__c = soPaymentRoleRec.Service_Order_Header__c;
    		coInvoiceItemRec.CO_Invoice_Header__c = coHeaderIdToActiveCOInvoiceHeaderIdMap.get(soHeaderIdToCOHeaderIdMap.get(soPaymentRoleRec.Service_Order_Header__c));
    		coInvoiceItemRec.Is_Invoiceable__c = true;
    		coInvoiceItemListToInsert.add(coInvoiceItemRec);
    	}
    	if(coInvoiceItemListToInsert.size() > 0) {
    		insert coInvoiceItemListToInsert;
    	}
    }
    
    public static void beforeDeleteOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<CO_Invoice_Item__c> coInvoiceItemListToDelete = [select Id from CO_Invoice_Item__c where SO_Payment_Role__c IN : soPaymentRoleOldList 
    																AND Service_Order_Header__c != null]; 
    	
    	if(coInvoiceItemListToDelete.size() > 0) {
    		if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    		delete coInvoiceItemListToDelete;
    	}
    }
    
    private static Map<Id, Id> populateMap(Set<Id> soHeaderIdSet) {
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Service_Order_Header__c> soHeaderList = [select CO_Header__c from Service_Order_Header__c where Id IN: soHeaderIdSet];
    	Map<Id, Id> soHeaderIdToCOHeaderIdMap = new Map<Id, Id>();
    	for(Service_Order_Header__c soHeaderRec : soHeaderList) {
    		soHeaderIdToCOHeaderIdMap.put(soHeaderRec.id, soHeaderRec.CO_Header__c);
    	}
    	return soHeaderIdToCOHeaderIdMap;
    }
    
    private static Map<Id, Id> populateCOHeaderIdToActiveCOInvoiceHeaderIdMap(List<Id> coHeaderIdList) {
    	Map<Id, Id> coHeaderIdToActiveCOInvoiceHeaderIdMap = new Map<Id, Id>();
    	
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
    	List<CO_Header__c> coHeaderList = [Select Id, (select Id from CO_Invoice_Headers__r where Invoice_Status__c = 'Active') From CO_Header__c where Id =: coHeaderIdList];
    	List<Id> coHeaderIdListHavingNoActiveInvoiceHeader = new List<Id>();
    	for(CO_Header__c coHeaderRec : coHeaderList) {
    		if(coHeaderRec.CO_Invoice_Headers__r.size() > 0) {
    			coHeaderIdToActiveCOInvoiceHeaderIdMap.put(coHeaderRec.Id, coHeaderRec.CO_Invoice_Headers__r[0].Id);
    		} else {
    			coHeaderIdListHavingNoActiveInvoiceHeader.add(coHeaderRec.Id);
    		}
    	}
    	
    	if(coHeaderIdListHavingNoActiveInvoiceHeader.size() > 0) {
    		createActiveCOInvoiceHeaderRec(coHeaderIdListHavingNoActiveInvoiceHeader, coHeaderIdToActiveCOInvoiceHeaderIdMap);
    	}
    	
    	return coHeaderIdToActiveCOInvoiceHeaderIdMap;
    }
    
    private static void createActiveCOInvoiceHeaderRec(List<Id> coHeaderIdListHavingNoActiveInvoiceHeader, Map<Id, Id> coHeaderIdToActiveCOInvoiceHeaderIdMap) {
    	List<CO_Invoice_Header__c> coInvoiceHeaderListToInsert = new List<CO_Invoice_Header__c>();
    	for(Id coHeaderId : coHeaderIdListHavingNoActiveInvoiceHeader) {
    		CO_Invoice_Header__c coInvoiceHeaderRec = new CO_Invoice_Header__c(CO_Header__c = coHeaderId, Invoice_Status__c = 'Active');
    		coInvoiceHeaderListToInsert.add(coInvoiceHeaderRec);
    	}
    	if(coInvoiceHeaderListToInsert.size() > 0) {
    		if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	insert coInvoiceHeaderListToInsert;
    	}
    	for(CO_Invoice_Header__c coInvoiceHeaderRec : coInvoiceHeaderListToInsert) {
    		coHeaderIdToActiveCOInvoiceHeaderIdMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec.Id);
    	}
    }
}