/**
 * Author: Ashish Garg
 * Since: Dec. 1, 2015
 * Name: KitHeaderTriggerHelper
 * Description: Helper class for triggers on Kit Header object
**/
public with sharing class KitHeaderTriggerHelper {
    
    // List to store trigger new list
    public static List<Kit_Header__c> KHNewList = new List<Kit_Header__c>();
    
    // List to store trigger old list
    public static List<Kit_Header__c> KHOldList = new List<Kit_Header__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Kit_Header__c> KHNewMap = new Map<Id, Kit_Header__c>();

    // Map to store Old Trigger Map
    public static Map<Id, Kit_Header__c> KHOldMap = new Map<Id, Kit_Header__c>();
    
    // Static variables to handle trigger execution
    public static boolean PermitRun_BeforeUpdate = true;
    
    /**
     * Name: processBeforeUpdate
     * Desc: Process before update trigger execution
     * @param: 
     * @return: 
    **/ 
    public static void processBeforeUpdate() {
    	if(PermitRun_BeforeUpdate){
    		boolean isValidCondition = false;
    		List<Id> validKHIds = new List<Id>();
    		
    		for(Kit_Header__c kh : KHNewList){
    			if( kh.Fixed_Price_Flag__c != KHOldMap.get(kh.Id).Fixed_Price_Flag__c 
    				|| kh.Fixed_Price__c != KHOldMap.get(kh.Id).Fixed_Price__c ){
    				isValidCondition = true;
    				validKHIds.add(kh.Id);
    			}
    		}
    		
    		if(isValidCondition){
    			reCalculateKitHeadersAndLIPrice(validKHIds);
    		}
    		PermitRun_BeforeUpdate = false;
    	}
    }
    
    /**
     * Name: reCalculateKitHeadersAndLIPrice
     * Desc: Process recalculation logic on Kit header records along with Kit Header line item records
     * @param: List<Id> kitHeaderIds
     * @return: 
    **/
    public static void reCalculateKitHeadersAndLIPrice(List<Id> kitHeaderIds) {
    	// Map to hold Kit Header records along with Kit Header Line Items
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Kit_Header__c> kitHeadersList = [SELECT Id, 
    												 Fixed_Price__c, 
    												 Fixed_Price_Flag__c,
    												 (SELECT Id, 
    												 		 Fixed_Price__c, 
    												 		 Kit_Price__c,
    												 		 Retail_Price__c,
    												 		 Qty_Needed__c,
    												 		 Total__c
    												 		 FROM Kit_Header_Line_Items__r
    												 		 WHERE Qty_Needed__c > 0
    												 )
    												 FROM  Kit_Header__c
    												 WHERE Id IN: kitHeaderIds
    										];
    	
    	List<Kit_Header_Line_Item__c> kitLineItemsToUpdate = new List<Kit_Header_Line_Item__c>();
    	// Iterate for each kit header and related kit header line item records and assign price
    	for(Kit_Header__c kh : kitHeadersList){
    		kitLineItemsToUpdate.addAll( assignPriceForHeaderAndLineItems(KHNewMap.get(kh.Id), kh.Kit_Header_Line_Items__r) );
    	}
    	
    	if(kitLineItemsToUpdate.size() > 0) {
    		if(AccessControl.ifObjectFieldIsUpdateable('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		KitLineItemtriggerHelper.PermitRun_BeforeUpdate = false;
    		update kitLineItemsToUpdate;
    	}
    }
    
    /**
     * Name: assignPriceForHeaderAndLineItems
     * Desc: Assign the kit price for Kith Header and line items
     * @param: Kit_Header__c kitHeader, List<Kit_Header_Line_Item__c> khLineItems
     * @return: List<Kit_Header_Line_Item__c> update list of line items
    **/
    public static List<Kit_Header_Line_Item__c> assignPriceForHeaderAndLineItems(Kit_Header__c kitHeader, List<Kit_Header_Line_Item__c> khLineItems) {
    	List<Kit_Header_Line_Item__c> updateKitLineItems = new List<Kit_Header_Line_Item__c>();
    	
    	// If Kit Header is Fixed Price enabled, then calculate and assign new total value to all line items
    	// Else sum total line items kit price on Kit Header record
    	if(kitHeader.Fixed_Price_Flag__c){
    		Map<Id, Kit_Header_Line_Item__c> unFixedLineItemsMap = new Map<Id, Kit_Header_Line_Item__c>();
    		Double fixedItemTotal = 0;
    		Double unFixedItemTotal = 0;
    		
    		for(Kit_Header_Line_Item__c khli : khLineItems){
    			if(khli.Fixed_Price__c){
    				fixedItemTotal += khli.Total__c;
    			} else {
    				unFixedLineItemsMap.put(khli.Id, khli);
    				unFixedItemTotal += khli.Retail_Price__c * khli.Qty_Needed__c;
    			}
    		}
    		
    		Double desiredUnFixedTotal = kitHeader.Fixed_Price__c - fixedItemTotal;
    		Double Adjustment = (unFixedItemTotal != 0) ? desiredUnFixedTotal / unFixedItemTotal : 1;

    		if(Adjustment != 1){
	    		for(Kit_Header_Line_Item__c khli : unFixedLineItemsMap.values()){
	    			khli.Kit_Price__c = khli.Retail_Price__c * Adjustment;
	    			
	    			// Check for if the line item is not in self trigger context, then do not include record in list to update
	    			// Insert: Id should not null
	    			// Update: Id should not in new map keyset
	    			// Delete: Add all elements
	    			if( (Trigger.isInsert && khli.Id != null) || (Trigger.isUpdate && !Trigger.newMap.containskey(khli.Id)) || Trigger.isDelete ){
	    				updateKitLineItems.add(khli);
	    			}
	    		}
    		} 
    	} else {
    		kitHeader.Fixed_Price__c = 0;
			for(Kit_Header_Line_Item__c khli : khLineItems){
				kitHeader.Fixed_Price__c += khli.Total__c;
			}
    	}
		
    	return updateKitLineItems;
    }
    
}