/**
 * Author: Hitesh Gupta
 * Since: Feb 05, 2016
 * Name: COKitHeaderTriggerHelper
 * Description: Helper class for triggers on COKH.
**/
public with sharing class COKitHeaderTriggerHelper {
	
	// List to store trigger new list
    public static List<CO_Kit_Header__c> cokhNewList = new List<CO_Kit_Header__c>();
    
    // List to store trigger old list
    public static List<CO_Kit_Header__c> cokhOldList = new List<CO_Kit_Header__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, CO_Kit_Header__c> cokhNewMap = new Map<Id, CO_Kit_Header__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, CO_Kit_Header__c> cokhOldMap = new Map<Id, CO_Kit_Header__c>();
    
    // Boolean to stop trigger
    public static Boolean isTriggerExecuted = false;
    
    
    public static void afterInsertCalculation() {
    	insertCOInvoiceItem();
    }
    
    public static void beforeDeleteOperation() {
    	deleteCOInvoiceItem();
    }
    
    /**
     * Name: insertCOInvoiceLineItem
     * Desc: Insert CO Invoice Item when CO Line Item is inserted
     * @param: 
     * @return: 
    **/
    public static void insertCOInvoiceItem() {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        List<Id> coHeaderIdList = new List<Id>();
        for(CO_Kit_Header__c cokhRec : cokhNewList) {
            coHeaderIdList.add(cokhRec.CO_Header__c);
        }
        
    	List<CO_Invoice_Header__c> coInvoiceHeaderList = [select Id, Invoice_Status__c, CO_Header__c from CO_Invoice_Header__c where CO_Header__c IN :coHeaderIdList AND Invoice_Status__c = 'Active'];
    	Map<Id, CO_Invoice_Header__c> coHeaderIdToCOInvoiceHeaderRecMap = new Map<Id, CO_Invoice_Header__c>();
        for(CO_Invoice_Header__c coInvoiceHeaderRec : coInvoiceHeaderList) {
            coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
        }
        
    	Map<Id, CO_Invoice_Item__c> coInvoiceItemMap = new Map<Id,CO_Invoice_Item__c>();
    	
    	List<CO_Invoice_Item__c> coInvoiceItemToInsert = new List<CO_Invoice_Item__c>();
        for(CO_Kit_Header__c cokhRec : cokhNewList) {
            CO_Invoice_Item__c coInvoiceItemRec = new CO_Invoice_Item__c();
            if(coHeaderIdToCOInvoiceHeaderRecMap.containsKey(cokhRec.CO_Header__c)) {
                coInvoiceItemRec.CO_Invoice_Header__c = coHeaderIdToCOInvoiceHeaderRecMap.get(cokhRec.CO_Header__c).Id;
            } else {
                CO_Invoice_Header__c coInvoiceHeaderRec = insertCOInvoiceHeader(cokhRec.CO_Header__c);
                coInvoiceItemRec.CO_Invoice_Header__c = coInvoiceHeaderRec.Id;
                coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
            }
            coInvoiceItemRec.CO_Kit_Header__c = cokhRec.Id;
            coInvoiceItemRec.isActive__c = true;
            
            coInvoiceItemRec.Is_Invoiceable__c = true;
            coInvoiceItemToInsert.add(coInvoiceItemRec);
        }
        
        if(coInvoiceItemToInsert.size() > 0) {
            insert coInvoiceItemToInsert;
        }
    }
	
	/**
     * Name: insertCOInvoiceHeader
     * Desc: Insert CO Invoice Header rec
     * @param: (1) coHeaderId - Id - CO Header Id 
     * @return: CO_Invoice_Header__c - inserted record of CO Invoice Header
    **/
    public static CO_Invoice_Header__c insertCOInvoiceHeader(Id coHeaderId) {
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	
        CO_Invoice_Header__c coInvoiceHeaderRec = new CO_Invoice_Header__c();
        coInvoiceHeaderRec.CO_Header__c = coHeaderId;
        coInvoiceHeaderRec.Invoice_Status__c = 'Active';
        insert coInvoiceHeaderRec;
        return coInvoiceHeaderRec;
    }
    
    
    public static void deleteCOInvoiceItem() {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	
        List<CO_Kit_Header__c> cokhList = [select Id, (Select Id from CO_Invoice_Items__r ) from CO_Kit_Header__c where Id IN :cokhOldList];
        List<CO_Invoice_Item__c> coInvoiceItemListToDel = new List<CO_Invoice_Item__c>();
         
        for(CO_Kit_Header__c cokhRec : cokhList) {	
            if(cokhRec.CO_Invoice_Items__r.size() > 0) {
                coInvoiceItemListToDel.addAll(cokhRec.CO_Invoice_Items__r);
            }
        }
        
        if(coInvoiceItemListToDel.size() > 0){
            delete coInvoiceItemListToDel;
        }
    }
}