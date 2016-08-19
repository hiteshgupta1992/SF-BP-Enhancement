/**
 * Author: Tarun Khandelwal
 * Since: Dec 23, 2015
 * Name: ServiceOrderLineItemTrigger
 * Description: Trigger executes on after update event of SO Line Item object
**/
trigger ServiceOrderLineItemTrigger on Service_Order_Line_Item__c (before insert, after insert, before update, after update, before delete, after delete) {
    
    ServiceOrderLineItemTriggerHelper.soliNewList = Trigger.new;
    ServiceOrderLineItemTriggerHelper.soliOldList = Trigger.old;
    ServiceOrderLineItemTriggerHelper.soliNewMap = Trigger.newMap;
    ServiceOrderLineItemTriggerHelper.soliOldMap = Trigger.oldMap; 
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        ServiceOrderLineItemTriggerHelper.afterUpdateCalculation();
    }
    
    if(Trigger.isBefore && Trigger.isInsert) {
        ServiceOrderLineItemTriggerHelper.beforeInsertCalculation();
    }
    
    if(ServiceOrderLineItemTriggerHelper.isTriggerExecuted) {
        return;
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        ServiceOrderLineItemTriggerHelper.afterInsertCalculation();
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        ServiceOrderLineItemTriggerHelper.beforeUpdateCalculation();
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        ServiceOrderLineItemTriggerHelper.beforeDeleteCalculation();
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        ServiceOrderLineItemTriggerHelper.processCOInvoiceItem();
    }
}