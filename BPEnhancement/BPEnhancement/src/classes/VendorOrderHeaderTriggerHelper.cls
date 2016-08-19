/** Author: Ashish Garg
 * Since: Aug. 8, 2015
 * Name: VendorOrderHeaderTriggerHelper
 * Description: Helper class for triggers on Vendor_Order_Header__c object
**/
public with sharing class VendorOrderHeaderTriggerHelper {
	// List to store trigger new list
    public static List<Vendor_Order_Header__c> newList = new List<Vendor_Order_Header__c>();
    
    // List to store trigger old list
    public static List<Vendor_Order_Header__c> oldList = new List<Vendor_Order_Header__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Vendor_Order_Header__c> newMap = new Map<Id, Vendor_Order_Header__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Vendor_Order_Header__c> oldMap = new Map<Id, Vendor_Order_Header__c>();
	
	public static boolean isToExecuteRemoveFromReceiving = true;
	
	/** 
     * Name: beforeUpdateOperations
     * Desc: Method used to perform before update operations
     * @param:  
     * @return: 
    **/
	public static void beforeUpdateOperations(){
		updateExpectedDeliveryDate();
		if(isToExecuteRemoveFromReceiving){
			// Remove related Vendor Receiving group records for vendor heeader where In_Progress_VR__c is changed or is null
			removeReceivingGroupForVOH();
		}
	}
	
	/**
     * Name: removeReceivingGroupForVOH
     * Desc: Method used to remove related Vendor Order receiving group records for Vendor Order Headers for which In_Progress_VR__c is changed to
     *		 any other VR or null
     * @param:  
     * @return: 
    **/
	private static void removeReceivingGroupForVOH(){
		boolean isValidTriggerEntry = false;
		
		// Ids set for Vendor Order Header Ids
		Set<Id> vohIds = new Set<Id>();
		
		for(Vendor_Order_Header__c voh : newList){
			if(newMap.get(voh.Id).In_Progress_VR__c != oldMap.get(voh.Id).In_Progress_VR__c){
				if(	newMap.get(voh.Id).In_Progress_VR__c != null && oldMap.get(voh.Id).In_Progress_VR__c != null
					|| newMap.get(voh.Id).In_Progress_VR__c == null){
					vohIds.add(voh.Id);
					isValidTriggerEntry = true;
				}
			}
		}
		
		if(isValidTriggerEntry){
			if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
			List<Vendor_Order_Line_Item__c> voliList = [Select	Id, 
																Vendor_Receiving_Group__c 
																from Vendor_Order_Line_Item__c 
																where Vendor_Order_Header__c IN: vohIds];
			
			Map<Id, Vendor_Receiving_Group__c> vrgMap = new Map<Id, Vendor_Receiving_Group__c>();
			for(Vendor_Order_Line_Item__c voli : voliList){
				if(voli.Vendor_Receiving_Group__c != null) {
					vrgMap.put(voli.Vendor_Receiving_Group__c, new Vendor_Receiving_Group__c(Id = voli.Vendor_Receiving_Group__c));
				}
			}
			if(vrgMap.size() > 0){
				if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
				delete vrgMap.values();
			}
		}
	}
	
	private static void updateExpectedDeliveryDate() {
		Boolean isValidEntry = false;	
		for(Vendor_Order_Header__c voh : newList) {
			if(oldMap.get(voh.Id).Purchase_Order_Type__c != voh.Purchase_Order_Type__c && voh.Purchase_Order_Type__c != null) {
				isValidEntry = true;
			}
		}
		
		if(!isValidEntry) {
			return;
		}
		
		List<Id> POTypeIdList = new List<Id>(); 
		for(Vendor_Order_Header__c voh : newList) {
			POTypeIdList.add(voh.Purchase_Order_Type__c);
		}
		
		if(AccessControl.ifObjectIsAccessible('PO_Type__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		Map<Id, PO_Type__c> poTypeIdToPOTypeRecMap = new Map<Id, PO_Type__c>([select Id, Lead_Time__c from PO_Type__c where Id IN: POTypeIdList]);
		for(Vendor_Order_Header__c voh : newList) {
			if(poTypeIdToPOTypeRecMap.containsKey(voh.Purchase_Order_Type__c)) {
				Decimal leadTime = poTypeIdToPOTypeRecMap.get(voh.Purchase_Order_Type__c).Lead_Time__c;
				voh.Expected_Date__c = new BusinessHoursMath().getEndOfBusinessDayFromDate(voh.CreatedDate, Integer.valueOf(leadTime));
			}
		}
	}
}