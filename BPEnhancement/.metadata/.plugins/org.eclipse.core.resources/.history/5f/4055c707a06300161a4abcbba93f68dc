/**
 * Author: Ashish Garg
 * Since: Aug. 20, 2015
 * Name: VendorOrderLineItemGroupTrigger
 * Description: Trigger for Vendor_Order_Line_Item_Group__c
**/
trigger VendorOrderLineItemGroupTrigger on Vendor_Order_Line_Item_Group__c (before insert, before update, after update, after delete ,after insert) {
    VendorOrderLineItemGroupTriggerHelper.newList	= Trigger.new;
    VendorOrderLineItemGroupTriggerHelper.oldList	= Trigger.old;
    VendorOrderLineItemGroupTriggerHelper.newMap	= Trigger.newMap;
    VendorOrderLineItemGroupTriggerHelper.oldMap	= Trigger.oldMap;
    
    if(trigger.isBefore){
        VendorOrderLineItemGroupTriggerHelper.updateLineItemsReceivedQty();
    }
    if(Trigger.isBefore && Trigger.isDelete) {
    	VendorOrderLineItemGroupTriggerHelper.beforeDeleteOperation(); 
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
    	VendorOrderLineItemGroupTriggerHelper.afterUpdateOperation();
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
    	VendorOrderLineItemGroupTriggerHelper.afterUpdateOperation();
    }
}