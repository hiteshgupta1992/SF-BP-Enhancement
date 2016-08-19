/**
 * Author: Tarun Khandelwal
 * Since: Nov. 29, 2014
 * Name: PartTriggerHelper
 * Description: Helper class for triggers on Part object
**/
public with sharing class PartTriggerHelper {
    
    // List to store trigger new list
    public static List<Part__c> PartNewList = new List<Part__c>();
    
    // List to store trigger old list
    public static List<Part__c> PartOldList = new List<Part__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Part__c> PartNewMap = new Map<Id, Part__c>();

    // Map to store Old Trigger Map
    public static Map<Id, Part__c> PartOldMap = new Map<Id, Part__c>();
    
    public static Boolean isTriggerExecuted = false;
    public static Boolean isPartFromImport = true;
    
    /**
     * Name: populateDefaults
     * Desc: populates default fields of part
     * @param: 
     * @return: 
    **/
    public static void populateDefaults() {
        for(Part__c part : PartNewList) {
            part.Part_Id_Text__c = part.Part_Number__c + ' ' + Part.Vendor_Code__c;
        }
    }
    
    
    /**
     * Name: AfterInsertOperation
     * Desc: When Part record is inserted this method executes 
     * @param: 
     * @return: 
    **/
    public static void AfterInsertOperation() {
    	if(!isTriggerExecuted) {
    		AfterUpdateOperation();
    		isTriggerExecuted = true;
    	}
    	// Create bucket for the parts after insert.
    	if(isPartFromImport){
    		FIFOTransaction.createFIFOBucketForPartImport(PartNewList);
    	}
    	
    }
    
    /**
     * Name: PartUpdateOperation
     * Desc: When Part record is updated this method executes 
     * @param: 
     * @return: 
    **/
    public static void AfterUpdateOperation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	// Entry Condition for Trigger
    	Boolean isValidTriggerEntry = true;
    	for(Part__c partRec : PartNewList) {
    		if((Trigger.isUpdate) && (PartNewMap.get(partRec.Id).AvailableParts__c == PartOldMap.get(partRec.Id).AvailableParts__c)) {
    			isValidTriggerEntry = false;
    		} 
    	}
    	
    	//system.assert(false, isValidTriggerEntry);
    	// If Not Valid Entry Condition, return from trigger
    	if(!isValidTriggerEntry) {
    		return;
    	}
    	
        List<Vendor_Order_Line_Item__c> voLineItemsToUpsert = new List<Vendor_Order_Line_Item__c>();
        List<Vendor_Order_Line_Item__c> voLineItemsToDelete = new List<Vendor_Order_Line_Item__c>();
        List<Vendor_Order_Line_Item__c> existingVOLineItemList = [select Id, part__c, Qty_Needed__c, Received__c, Vendor_Order_Line_Item_Group__c from Vendor_Order_Line_Item__c where Part__c IN : PartNewList 
        																															AND Is_required_For_Customer__c = false AND Is_Service__c = false AND Is_Excess__c = false];
       	system.debug('####'+existingVOLineItemList);																													
        
        // Map to check if there is already VOLineItem is present for same part.
        Map<Id, Vendor_Order_Line_Item__c> partIdToVOLineItemRecMap = new Map<Id, Vendor_Order_Line_Item__c>();
        for(Vendor_Order_Line_Item__c voLineItemRec : existingVOLineItemList) {
        	voLineItemRec.Received__c = (voLineItemRec.Received__c == null) ? 0 : voLineItemRec.Received__c;
        	if(voLineItemRec.Qty_Needed__c > voLineItemRec.Received__c && !partIdToVOLineItemRecMap.containsKey(voLineItemRec.Part__c)) {
        		partIdToVOLineItemRecMap.put(voLineItemRec.Part__c, voLineItemRec);
        	} 
        }
        
        for(Part__c partRec : PartNewList) {
        	Decimal need = 0;
        	if((partRec.AvailableParts__c + partRec.Qty_On_Order__c) <= partRec.Auto_reorder_Min__c && partRec.Auto_reorder_Min__c < partRec.Auto_reorder_Max__c) {
        		need = toppingUpCalculation(partRec);
	        	Vendor_Order_Line_Item__c voLineItemRec = new Vendor_Order_Line_Item__c();
	        	if(partIdToVOLineItemRecMap.containsKey(partRec.Id)) {
	        		/* DO NOTHING IF THERE IS ALREADY VOLI PRESENT FOR THAT PART */
	        		//voLineItemRec.Id = partIdToVOLineItemRecMap.get(partRec.Id).Id;
	        		//voLineItemRec.Qty_Needed__c = need + partIdToVOLineItemRecMap.get(partRec.Id).Qty_Needed__c;
	        	} else {
	        		voLineItemRec.Qty_Needed__c = need;
	        		voLineItemRec.Part__c = partRec.Id;
	        		voLineItemRec.Is_required_For_Customer__c = false;
	        		voLineItemsToUpsert.add(voLineItemRec);
	        	}
	        } else if(partRec.AvailableParts__c > partRec.Auto_reorder_Min__c){
	        	if(partIdToVOLineItemRecMap.containsKey(partRec.Id)) {
	        		Vendor_Order_Line_Item__c voLineItemRec = partIdToVOLineItemRecMap.get(partRec.Id);
	        		if(voLineItemRec.Vendor_Order_Line_Item_Group__c == null) {
	        			//voLineItemsToDelete.add(voLineItemRec);
	        		}
	        	}
	        }
        }
        
        if(voLineItemsToUpsert.size() > 0 ){
        	upsert voLineItemsToUpsert;
        }
    }
    
    /**
     * Name: toppingUpCalculation
     * Desc: Topping Up Calculation in case of packaged Part.
     * @param: 
     * @return: 
    **/
    private static Decimal toppingUpCalculation(Part__c partRec) {
    	Decimal need = 0;
    	need = partRec.Auto_reorder_Max__c - (partRec.AvailableParts__c + partRec.Qty_On_Order__c); 
		
		if(partRec.Packaged_Part__c) {
    		Long packagedPartInNeed = (need / partRec.Package_Qty__c).longValue();
    		if(packagedPartInNeed * partRec.Package_Qty__c < need) {
    			packagedPartInNeed += 1;
    		}
    		need = packagedPartInNeed * partRec.Package_Qty__c;
    	}
    	
    	if(partRec.Order_Lots__c > 1) {
    		Long orderLotPartInNeed = (need / partRec.Order_Lots__c).longValue();
    		if(orderLotPartInNeed * partRec.Order_Lots__c < need) {
    			orderLotPartInNeed += 1;
    		}
    		need = orderLotPartInNeed * partRec.Order_Lots__c;
    	}
    	return need;
    }
    
    /**
     * Name: updateKitLineItems
     * Desc: Update Kit Line Item if Retail Price of Part is changed.
     * @param: 
     * @return: 
    **/
    public static void updateKitLineItems() {
    	List<Id> partIdList = new List<Id>();
    	for(Part__c partRec : PartNewList) {
    		if(PartNewMap.get(partRec.Id).Retail_Price__c != PartOldMap.get(partRec.Id).Retail_Price__c) {
    			partIdList.add(partRec.Id);
    		}
    	}
    	//system.assert(false, partIdList);
    	if(partIdList.size() > 0) {
    		KitLineItemtriggerHelper.updateRetailofKitLineItems('Part__c', partIdList);
    	}
    }
    
}