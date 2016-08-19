/**
 * Author: Ashish Garg
 * Since: Aug 21, 2015
 * Name: VendorOrderLineItemGroupTriggerHelper
 * Description: Trigger Helper
**/
public with sharing class VendorOrderLineItemGroupTriggerHelper {
	// List to store trigger new list
    public static List<Vendor_Order_Line_Item_Group__c> newList = new List<Vendor_Order_Line_Item_Group__c>();
    
    // List to store trigger old list
    public static List<Vendor_Order_Line_Item_Group__c> oldList = new List<Vendor_Order_Line_Item_Group__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Vendor_Order_Line_Item_Group__c> newMap = new Map<Id, Vendor_Order_Line_Item_Group__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Vendor_Order_Line_Item_Group__c> oldMap = new Map<Id, Vendor_Order_Line_Item_Group__c>();
    
	/**
     * Name: updateLineItemsReceivedQty
     * Desc: Update the Qty Received for line items received in case Vendor Receiving group insert/update/delete 
     * @param: 
     * @return: 
    **/
    public static void updateLineItemsReceivedQty(){
    	boolean isValidUpdateTrigger = false;
    	List<Id> validGroupIdsList = new List<Id>();
    	
    	List<Id> partIdList = new List<Id>();
		for(Vendor_Order_Line_Item_Group__c volig : newList){
    		partIdList.add(volig.Part__c);
		}
		
		if(AccessControl.ifObjectIsAccessible('Part__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Last_Cost__c from Part__c where Id IN: partIdList]);
    	
    	for(Vendor_Order_Line_Item_Group__c volig : newList){
    		if(volig.Received_Qty__c == 0){
    			validGroupIdsList.add(volig.Id);
    			isValidUpdateTrigger = true;
    		}
    		if(volig.Cost__c == null) {
    			volig.Cost__c = partIdToPartRecordMap.get(volig.Part__c).Last_Cost__c;
    		}
    		
    		if(volig.Need__c != null && volig.Cost__c != null) {
    			volig.Total__c = volig.Need__c * volig.Cost__c ;	
    		}
    	}
    	
    	if(isValidUpdateTrigger){
    		if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		List<Vendor_Order_Line_Item__c> volis = [Select Id, Received__c from Vendor_Order_Line_Item__c where Vendor_Order_Line_Item_Group__c IN: validGroupIdsList];
    		for(Vendor_Order_Line_Item__c voli : volis){
    			voli.Received__c = 0;
    		}
    		
    		if(volis.size() > 0){
    			if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
    			update volis;
    		}
    	}
    }
    
    public static void beforeDeleteOperation() {
    	updateVOTotalByVOLIG(oldList);
    }
    
    public static void afterUpdateOperation() {
    	updateVOTotalByVOLIG(newList);
    }
    public static void afterInsertOperation() {
    	updateVOTotalByVOLIG(newList);
    }
    
   
    
    private static void updateVOTotalByVOLIG(List<Vendor_Order_Line_Item_Group__c> voligList) {
    	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	List<Vendor_Order_Line_Item_Group__c> voligRecList = [Select Vendor_Order_Header__c From Vendor_Order_Line_Item_Group__c where Id IN: voligList];
    	Set<Id> voHeaderIdSet = new Set<Id>();
    	Set<Id> deletedVOLIGSet = new Set<Id>();
    	
    	for(Vendor_Order_Line_Item_Group__c voligRec : voligRecList){
    		voHeaderIdSet.add(voligRec.Vendor_Order_Header__c);
    		if(trigger.isDelete){
    			deletedVOLIGSet.add(voligRec.Id);
    		}
    	}
    	
    	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	List<Vendor_Order_Header__c> voHeaderList = [Select Total__c, Total_Recieved__c, (select Total__c, Received_Qty__c, Cost__c from Vendor_Order_Line_Item_Groups__r) from Vendor_Order_Header__c 
    																WHERE Id IN : voHeaderIdSet];
    																
    	for(Vendor_Order_Header__c voHeaderRec : voHeaderList) {
    		Decimal total = 0;
    		Decimal recieved = 0;
    		for(Vendor_Order_Line_Item_Group__c voligRec : voHeaderRec.Vendor_Order_Line_Item_Groups__r) {
    			if(Trigger.isDelete && deletedVoligSet.contains(voligRec.Id)) {
    				continue;
    			}
    			if(voligRec.Total__c != null) {
    				total += voligRec.Total__c;
    			}
    			
    			if(voligRec.Received_Qty__c != null && voligRec.Cost__c != null) {
    				recieved += voligRec.Received_Qty__c * voligRec.Cost__c;
    			}
    		}
    		
    		voHeaderRec.Total__c = total; 
    		voHeaderRec.Total_Recieved__c = recieved;
    	}														
    	
    	if(voHeaderList.size() > 0) {
    		if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
    		update voHeaderList;
    	}
    }
}