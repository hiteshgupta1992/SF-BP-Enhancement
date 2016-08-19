/**
 * Author: Tarun Khandelwal
 * Since: Aug. 04, 2014
 * Name: VendorOrderLineItemTriggerHelper
 * Description: Helper class for triggers on VOLI.
**/
public with sharing class VendorOrderLineItemTriggerHelper {
	
	// List to store trigger new list
    public static List<Vendor_Order_Line_Item__c> voliNewList = new List<Vendor_Order_Line_Item__c>();
    
    // List to store trigger old list
    public static List<Vendor_Order_Line_Item__c> voliOldList = new List<Vendor_Order_Line_Item__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Vendor_Order_Line_Item__c> voliNewMap = new Map<Id, Vendor_Order_Line_Item__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Vendor_Order_Line_Item__c> voliOldMap = new Map<Id, Vendor_Order_Line_Item__c>();
    
    public static Boolean isTriggerExecute = true;
    
    /**
     * Name: beforeUpdateCalculation
     * Desc: before update operations
     * @param: 
     * @return: 
    **
    public static void beforeUpdateCalculation() {
    	// Update related vendor order group and received required qty amount
    	Set<Vendor_Receiving_Group__c> vrgToUpdate = new Set<Vendor_Receiving_Group__c>();
    	boolean isValidTriggerEntry = false;
    	if(Trigger.isBefore && Trigger.isUpdate){
    		for(Vendor_Order_Line_Item__c voli : voliNewList){
    			if( (voliNewMap.get(voli.Id).Vendor_Receiving_Group__c != null || voliOldMap.get(voli.Id).Vendor_Receiving_Group__c != null) && voliNewMap.get(voli.Id).Vendor_Receiving_Group__c != voliOldMap.get(voli.Id).Vendor_Receiving_Group__c ){
    				isValidTriggerEntry = true;
    				
    				if(voliNewMap.get(voli.Id).Vendor_Receiving_Group__c == null){
    					vrgToUpdate.add(new Vendor_Receiving_Group__c(Id = voliOldMap.get(voli.Id).Vendor_Receiving_Group__c, Recieved__c = 0));
    				} else  if(voliOldMap.get(voli.Id).Vendor_Receiving_Group__c == null){
    					vrgToUpdate.add(new Vendor_Receiving_Group__c(Id = voliNewMap.get(voli.Id).Vendor_Receiving_Group__c));
    				} else {
    					vrgToUpdate.add(new Vendor_Receiving_Group__c(Id = voliOldMap.get(voli.Id).Vendor_Receiving_Group__c, Recieved__c = 0));
    					vrgToUpdate.add(new Vendor_Receiving_Group__c(Id = voliNewMap.get(voli.Id).Vendor_Receiving_Group__c));
    				}
    			}
    		}
    	}
    	List<Vendor_Receiving_Group__c> vrgListToUpdate = new List<Vendor_Receiving_Group__c>();
    	
    	if(vrgToUpdate.size() > 0) {
    		vrgListToUpdate.addAll(vrgToUpdate);
    	}
    	
    	
    	system.debug('vrgListToUpdatevrgListToUpdate  : ' + vrgListToUpdate);
    	if(isValidtriggerEntry && vrgListToUpdate.size() > 0){
    		update vrgListToUpdate;
    	}
    }
    
    /**
     * Name: afterUpdateCalculation
     * Desc: Update Special order field of COLI in case of require for customer VOLI.
     * @param: 
     * @return: 
    **/
    public static void afterUpdateCalculation() {
    	if(AccessControl.ifObjectIsUpdateable('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
    	List<Id> specialOrderCOLineItemIdList = new List<Id>();
    	List<Id> notSpecialOrderCOLineItemIdList = new List<Id>();
    	for(Vendor_Order_Line_Item__c voliRec : voliNewList) {
    		if(voliRec.Vendor_Order_Header__c != null && (voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c) && voliRec.CO_Line_Item__c != null) {
    			specialOrderCOLineItemIdList.add(voliRec.CO_Line_Item__c);
    		} else if(voliOldMap.get(voliRec.Id).Vendor_Order_Header__c != null && voliRec.Vendor_Order_Header__c == null && (voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c)) {
    			notSpecialOrderCOLineItemIdList.add(voliRec.CO_Line_Item__c);
    		}
    	}
    	 
    	if(specialOrderCOLineItemIdList.size() == 0 && notSpecialOrderCOLineItemIdList.size() == 0) {
    		return;
    	}
    	
    	List<CO_Line_Item__c> coLineItemListToUpdate = new List<CO_Line_Item__c>();
    	if(AccessControl.ifObjectIsAccessible('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		List<CO_Line_Item__c> colIneItemList = [select Special_Order__c from CO_Line_Item__c where Id IN :specialOrderCOLineItemIdList];
		for(CO_Line_Item__c coLineItemRec : colIneItemList) {
			coLineItemRec.Special_Order__c = true;
			coLineItemListToUpdate.add(coLineItemRec);
		}
		if(AccessControl.ifObjectIsAccessible('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		colIneItemList = [select Special_Order__c from CO_Line_Item__c where Id IN :notSpecialOrderCOLineItemIdList];
		for(CO_Line_Item__c coLineItemRec : colIneItemList) {
			coLineItemRec.Special_Order__c = false;
			coLineItemListToUpdate.add(coLineItemRec);
		}
		
		if(coLineItemListToUpdate.size() > 0 && isTriggerExecute) {
			COLineItemTriggerHelper.isTriggerExecute = true;
			update coLineItemListToUpdate;
		}
    }
    
    /**
     * Name: beforeTriggerCalculation
     * Desc: Update Need for all group records for all line items
     * @param: 
     * @return: 
    **
    public static void beforeTriggerCalculation() {
    	Boolean isValidEntry = false;
    	Set<Id> voliGroupIdSet = new Set<Id>(); 
    	List<Vendor_Order_Line_Item__c> triggerRecsList = (Trigger.isDelete) ? voliOldList : voliNewList;
    	
    	for(Vendor_Order_Line_Item__c voliRec : triggerRecsList) {
    		if(trigger.isDelete && voliRec.Vendor_Order_Line_Item_Group__c != null){
    			voliGroupIdSet.add(voliRec.Vendor_Order_Line_Item_Group__c);
				isValidEntry = true;
    		} else if(voliOldMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c != voliNewMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c
    				|| voliOldMap.get(voliRec.Id).Qty_Needed__c != voliNewMap.get(voliRec.Id).Qty_Needed__c ) {
    			
    			if(voliNewMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c != null){
    				voliGroupIdSet.add(voliNewMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c);
    			}
    			if(voliOldMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c != null){
    				voliGroupIdSet.add(voliOldMap.get(voliRec.Id).Vendor_Order_Line_Item_Group__c);
    			}
				isValidEntry = true;
    		}
    	}
    	
    	System.debug('@@@@@@ Inside VOLITrigger ' + isValidEntry);
    	if(isValidEntry) {
    		VendorOrderLineItemTriggerHelper.updateNeedForVOGRecords(voliGroupIdSet);
    	}
    }
    
    /**
     * Name: updateNeedForVOGRecords
     * Desc: Update "Need" on vendor order group records: total of needs of all vendor order line items
     * @param: Set<Id> vonder order group record Ids
     * @return: 
    **
    @future
    public static void updateNeedForVOGRecords(Set<Id> vogIds){
    	List<Vendor_Order_Line_Item_Group__c> voliGroupList = [select Need__c, (select Id, Qty_Needed__c from Vendor_Order_Line_Items__r) from Vendor_Order_Line_Item_Group__c where Id IN: vogIds];
    	for(Vendor_Order_Line_Item_Group__c voliGrpRec : voliGroupList) {
    		Decimal need = 0;
    		for(Vendor_Order_Line_Item__c voliRec : voliGrpRec.Vendor_Order_Line_Items__r) {
    			need += voliRec.Qty_Needed__c;
    		}
    		voliGrpRec.Need__c = need;
    	}
    	
    	if(voliGroupList.size() > 0) {
    		update voliGroupList;
    	}
    }*/
}