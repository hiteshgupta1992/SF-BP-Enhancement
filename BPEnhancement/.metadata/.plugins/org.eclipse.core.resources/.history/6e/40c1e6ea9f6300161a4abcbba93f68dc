/**
 * Author: Ashish Garg
 * Since: Dec. 1, 2015
 * Name: KitLineItemtriggerHelper
 * Description: Helper class for triggers on Kit Header Line Item object
**/
global with sharing class KitLineItemtriggerHelper {
	// List to store trigger new list
    public static List<Kit_Header_Line_Item__c> newList = new List<Kit_Header_Line_Item__c>();
    
    // List to store trigger old list
    public static List<Kit_Header_Line_Item__c> oldList = new List<Kit_Header_Line_Item__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Kit_Header_Line_Item__c> newMap = new Map<Id, Kit_Header_Line_Item__c>();

    // Map to store Old Trigger Map
    public static Map<Id, Kit_Header_Line_Item__c> oldMap = new Map<Id, Kit_Header_Line_Item__c>();
    
    // Static variables to handle trigger execution
    public static boolean PermitRun_BeforeInsert = true;
    public static boolean PermitRun_BeforeUpdate = true;
    public static boolean PermitRun_BeforeDelete = true;
    
    /**
     * Name: processBeforeInsert
     * Desc: Process before insert trigger execution
     * @param: 
     * @return: 
    **/
    public static void processBeforeInsert() {
    	if(PermitRun_BeforeInsert) {
    		KitHeaderTriggerHelper.PermitRun_BeforeUpdate = false;
    		PermitRun_BeforeInsert = false;
    		PermitRun_BeforeUpdate = false;		// Prevent update of line items so as to prevent re-assignment of kit price for line items being updated in the process
    		
    		// Assign default Kit Price
    		for(Kit_Header_Line_Item__c khli : newList){
				khli.Kit_Price__c = khli.Retail_Price__c;
	    	}
    		
    		// Distribute the price in all line items according to header price
    		distributePriceOnLineItems(newList);
    	}
    }
    
    /**
     * Name: processBeforeUpdate
     * Desc: Process before update trigger execution
     * @param: 
     * @return: 
    **/
    public static void processBeforeUpdate() {
    	if(PermitRun_BeforeUpdate) {
    		KitHeaderTriggerHelper.PermitRun_BeforeUpdate = false;
    		PermitRun_BeforeUpdate = false;
    		
    		// Distribute the price in all line items according to header price
    		distributePriceOnLineItems(newList);
    	}
    }
    
    /**
     * Name: processBeforeDelete
     * Desc: Process before delete trigger execution
     * @param: 
     * @return: 
    **/
    public static void processBeforeDelete() {
    	if(PermitRun_BeforeDelete) {
    		KitHeaderTriggerHelper.PermitRun_BeforeUpdate = false;
    		PermitRun_BeforeDelete = false;
    		PermitRun_BeforeUpdate = false;		// Prevent update of line items so as to prevent re-assignment of kit price for line items being updated in the process
    		
    		// Distribute the price in all line items according to header price
    		distributePriceOnLineItems(oldList);
    	}
    }
    
    /**
     * Name: distributePriceOnLineItems
     * Desc: Method used to distribute kit header price on all line items. Cases are to be considered: insert, update, delete
     * @param: List<Kit_Header_Line_Item__c> khlisList
     * @return: 
    **/
    private static void distributePriceOnLineItems(List<Kit_Header_Line_Item__c> khlisList) {
    	if(AccessControl.ifObjectFieldIsUpdateable('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	Map<Id, List<Kit_Header_Line_Item__c>> kitHeaderToLineItemsMap = new Map<Id, List<Kit_Header_Line_Item__c>>();
		Map<Id, Double> kitHeaderToNewFixedTotal = new Map<Id, Double>();
		Map<Id, Double> kitHeaderToNewUnfixedTotal = new Map<Id, Double>();
		
		for(Kit_Header_Line_Item__c khli : khlisList){
			// Fixed price line item
			if(khli.Fixed_Price__c == true){
				// make the kit price to default price for unfixed line item record
    			if(khli.Kit_Price__c == null){
    				khli.Kit_Price__c = khli.Retail_Price__c;
    			}
    			
    			Double fixedTotal = (kitHeaderToNewFixedTotal.containsKey(khli.Kit_Header__c)) ? kitHeaderToNewFixedTotal.get(khli.Kit_Header__c) : 0;
    			fixedTotal += khli.Qty_Needed__c * khli.Kit_Price__c;
    			kitHeaderToNewFixedTotal.put(khli.Kit_Header__c, fixedTotal);
			}
			
			// unfixed price line item
			if(khli.Fixed_Price__c == false){
				// make the kit price to default price for unfixed line item record
    			if(!Trigger.isDelete){
    				khli.Kit_Price__c = khli.Retail_Price__c;
    			}
    			
    			Double unfixedTotal = (kitHeaderToNewUnfixedTotal.containsKey(khli.Kit_Header__c)) ? kitHeaderToNewUnfixedTotal.get(khli.Kit_Header__c) : 0;
    			unfixedTotal += khli.Qty_Needed__c * khli.Retail_Price__c;
    			kitHeaderToNewUnfixedTotal.put(khli.Kit_Header__c, unfixedTotal);
			}
			
			// Create map for header kits
			List<Kit_Header_Line_Item__c> khlis = (kitHeaderToLineItemsMap.containsKey(khli.Kit_Header__c)) ? kitHeaderToLineItemsMap.get(khli.Kit_Header__c) : new List<Kit_Header_Line_Item__c>();
			khlis.add(khli);
			kitHeaderToLineItemsMap.put(khli.Kit_Header__c, khlis);
		}

		// Now get Kit Header records for new list khlis
		if(AccessControl.ifObjectFieldIsAccessible('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		Map<Id, Kit_Header__c> kitHeadersMap = new Map<Id, Kit_Header__c>([	SELECT Id, 
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
						    												 		 AND Id NOT IN: khlisList
						    												 )
						    												 FROM  Kit_Header__c
						    												 WHERE Id IN: kitHeaderToLineItemsMap.keySet()
						    											]);
		
		List<Kit_Header__c> kitHeadersToUpdate = new List<Kit_Header__c>();
		List<Kit_Header_Line_Item__c> klisToUpdate = new List<Kit_Header_Line_Item__c>();
		
		// Loop through all Kit header records and check:
		// If Kit Header is of fixed price, then distribute the all unfixed amount line items amount as per calculation logic
		// Else, Kit header is of unfixed price, then add the new line item amount in kit header price
		for(Kit_Header__c kitHeader : kitHeadersMap.values()){
			Double fixedTotal = (kitHeaderToNewFixedTotal.containsKey(kitHeader.Id)) ? kitHeaderToNewFixedTotal.get(kitHeader.Id) : 0;
			Double unfixedTotal = (kitHeaderToNewUnfixedTotal.containsKey(kitHeader.Id)) ? kitHeaderToNewUnfixedTotal.get(kitHeader.Id) : 0;
			
			// In case of delete, set amounts to be negative
			if(Trigger.isDelete){
				fixedTotal = fixedTotal * -1;
				unfixedTotal = unfixedTotal * -1;
			}
			
			if(kitHeader.Fixed_Price_Flag__c){
				List<Kit_Header_Line_Item__c> khLineItems = (kitHeader.Kit_Header_Line_Items__r != null) ? kitHeader.Kit_Header_Line_Items__r : new List<Kit_Header_Line_Item__c>();
				kitHeader.Fixed_Price__c = (kitHeader.Fixed_Price__c != null) ? kitHeader.Fixed_Price__c : 0;
				
				// Assign new effective price on kit header record as per opration mode
				// Add/remove/update kit line items from kit line items list as per operation mode
				if(Trigger.isInsert || Trigger.isUpdate){
					if(kitHeaderToLineItemsMap.containsKey(kitHeader.Id)){
						khLineItems.addAll( kitHeaderToLineItemsMap.get(kitHeader.Id) );
					}
				} else if(Trigger.isDelete){
					// Do not alter line items list as the same header price needs to be distributed among all line items
				}
				
				// Distribute the amount of all remaining line items as per calculation logic
				klisToUpdate.addAll( KitHeaderTriggerHelper.assignPriceForHeaderAndLineItems(kitHeader, khLineItems) );
			} else {
				// Add the new line item amount in Kit header price
				kitHeader.Fixed_Price__c = 0;
				for(Kit_Header_Line_Item__c khli : kitHeader.Kit_Header_Line_Items__r){
					kitHeader.Fixed_Price__c += khli.Total__c;
				}
				
				// If Trigger is in delete mode, 
				// then do not add/update fixed and unfixed amount in header price since these amount are automatically removed from header price calculation
				if(Trigger.isDelete == false){
					kitHeader.Fixed_Price__c += fixedTotal + unfixedTotal;
				}
				kitHeadersToUpdate.add(kitHeader);
			}
		}
		
		if(kitHeadersToUpdate.size() > 0){
			
			update kitHeadersToUpdate;
		}
		
		if(klisToUpdate.size() > 0){
			
			update klisToUpdate;
		}
    }
    
    /**
     * Name: setDefaultFields
     * Desc: set Default fields of Kit Header in case of After Insert/Before Delete
     * @param: 
     * @return: 
    **/
    public static void setDefaultFields() {
    	Set<Id> kitHeaderIdSet = new Set<Id>();
    	List<Kit_Header_Line_Item__c> kitLineItems = (Trigger.isDelete) ? oldList : newList;
    	for(Kit_Header_Line_Item__c kitLitneItemRec : kitLineItems) {
    		kitHeaderIdSet.add(kitLitneItemRec.Kit_Header__c);
    	} 
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Kit_Header__c> kitHeaders = [select Number_of_Labours__c, Service_Kit__c, (select Id from Kit_Header_Line_Items__r WHERE Labour_Code__c != null) 
    											from Kit_Header__c WHERE Id IN : kitHeaderIdSet];
    											
    	for(Kit_Header__c kitHeaderRec : kitHeaders) {										
    		kitHeaderRec.Number_of_Labours__c = kitHeaderRec.Kit_Header_Line_Items__r.size();
    		if(kitHeaderRec.Number_of_Labours__c > 0) {
    			kitHeaderRec.Service_Kit__c = true;
    		}
    	}
    	
    	if(kitHeaders.size() > 0) {
    		if(AccessControl.ifObjectFieldIsUpdateable('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update kitHeaders;
    	}
    }
    
    
    /**
     * Name: updateKitLineItems
     * Desc: Update Kit Line Item if Retail Price of Part is changed.
     * @param: 
     * @return: 
    **/
    @future
    global static void updateRetailofKitLineItems(String objectName, List<Id> recordsId) {
    	String query = '';
    	if(AccessControl.ifObjectFieldIsAccessible('Labour_Code__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = 'SELECT Id, (SELECT Retail_Price__c FROM Kit_Header_Line_Items__r) FROM ' + objectName + ' WHERE Id IN : recordsId';
    	List<Sobject> sobjList = Database.query(query);
    	//system.assert(false, sobjList);
    	
    	List<Kit_Header_Line_Item__c> kitLineItems = new List<Kit_Header_Line_Item__c>();
    	for(Sobject sobj : sobjList) {
    		for(Kit_Header_Line_Item__c kitLineItemRec : sobj.getSobjects('Kit_Header_Line_Items__r')) {
    			kitLineItems.add(kitLineItemRec);
    		}
    	}
    	system.debug('kitLineItems : ->' + kitLineItems);
    	
    	if(kitLineItems.size() > 0) {
    		if(AccessControl.ifObjectFieldIsUpdateable('Kit_Header_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update kitLineItems;
    	}
    }
    
}