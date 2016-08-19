/**
 * Author: Ashish Garg
 * Since: Aug. 20, 2015
 * Name: VendorReceivingGroupTrigger
 * Description: Trigger for Vendor_Receiving_Group__c
**/
trigger VendorReceivingGroupTrigger on Vendor_Receiving_Group__c (before delete, before update, after update, after insert) {
    VendorReceivingGroupTriggerHelper.newList   = Trigger.new;
    VendorReceivingGroupTriggerHelper.oldList   = Trigger.old;
    VendorReceivingGroupTriggerHelper.newMap    = Trigger.newMap;
    VendorReceivingGroupTriggerHelper.oldMap    = Trigger.oldMap;
    
    if(trigger.isBefore){
        VendorReceivingGroupTriggerHelper.updateLineItemsReceivedQty();
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
    	VendorReceivingGroupTriggerHelper.beforeUpdateOperation();
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
    	VendorReceivingGroupTriggerHelper.beforeDeleteOperation(); 
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
    	VendorReceivingGroupTriggerHelper.afterUpdateOperation();
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
    	VendorReceivingGroupTriggerHelper.afterUpdateOperation();
    }
}