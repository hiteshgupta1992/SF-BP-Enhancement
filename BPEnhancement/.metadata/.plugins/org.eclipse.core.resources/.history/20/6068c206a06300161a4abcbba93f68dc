/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: COLineItemTrigger
 * Description: Trigger executes on after update event of CO Line Item object
**/
trigger COLineItemTrigger on CO_Line_Item__c (before insert, after insert, before update, after update, before delete) {
    
    // Initialize List and Maps
    COLineItemTriggerHelper.COLineItemNewList = Trigger.new;
    COLineItemTriggerHelper.COLineItemOldList = Trigger.old;
    COLineItemTriggerHelper.COLineItemNewMap = Trigger.newMap;
    COLineItemTriggerHelper.COLineItemOldMap = Trigger.oldMap;
    
    if(trigger.isBefore && trigger.isInsert) {
    	COLineItemTriggerHelper.beforeInsertCalculation();
    }
    
    if(trigger.isAfter && trigger.isInsert) {
    	COLineItemTriggerHelper.afterInsertCalculation();
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
    	COLineItemTriggerHelper.beforeUpdateCalculation();
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
		COLineItemTriggerHelper.afterUpdateCalculation();
    }
    
    if(trigger.isBefore && trigger.isDelete) {
    	COLineItemTriggerHelper.beforeDeleteOperation();
    }
    
}