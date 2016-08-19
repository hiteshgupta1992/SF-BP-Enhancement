/**
 * Author: Tarun Khandelwal
 * Since: Aug. 04, 2015
 * Name: VendorOrderLineItemTrigger
 * Description: Trigger executes on after update events of VOLI
**/
trigger VendorOrderLineItemTrigger on Vendor_Order_Line_Item__c (before insert, before update, after update, before delete) {
	
	VendorOrderLineItemTriggerHelper.voliNewList = Trigger.new;
	VendorOrderLineItemTriggerHelper.voliOldList = Trigger.old;
	VendorOrderLineItemTriggerHelper.voliNewMap = Trigger.newMap;
	VendorOrderLineItemTriggerHelper.voliOldMap = Trigger.oldMap;
	
	if(trigger.isAfter && trigger.isUpdate){
		VendorOrderLineItemTriggerHelper.afterUpdateCalculation();
	}
	if(trigger.isBefore && trigger.isUpdate){
		//VendorOrderLineItemTriggerHelper.beforeUpdateCalculation();
		//VendorOrderLineItemTriggerHelper.beforeTriggerCalculation();
	}
}