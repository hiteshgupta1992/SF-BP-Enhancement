/**
 * Author: Ashish Garg
 * Since: Aug. 8, 2015
 * Name: VendorOrderHeaderTrigger
 * Description: Trigger executes on before insert, before update events of Vendor_Order_Line_Item_Group__c object
**/
trigger VendorOrderHeaderTrigger on Vendor_Order_Header__c (before update) {
    
    VendorOrderHeaderTriggerHelper.newList = Trigger.new;
    VendorOrderHeaderTriggerHelper.oldList = Trigger.old;
    VendorOrderHeaderTriggerHelper.newMap = Trigger.newMap;
    VendorOrderHeaderTriggerHelper.oldMap = Trigger.oldMap;
    
    if(trigger.isBefore && trigger.isUpdate){
        VendorOrderHeaderTriggerHelper.beforeUpdateOperations();
    }
}