/**
 * Author: Tarun Khandelwal
 * Since: Nov. 29, 2014
 * Name: PartTrigger
 * Description: Trigger executes on before insert, before update and before delete events of Part object
**/
trigger PartTrigger on Part__c (before insert, after insert, before update, after update) {
    
    PartTriggerHelper.PartNewList = Trigger.new;
    PartTriggerHelper.PartOldList = Trigger.old;
    PartTriggerHelper.PartNewMap = Trigger.newMap;
    PartTriggerHelper.PartOldMap = Trigger.oldMap;
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            PartTriggerHelper.populateDefaults();
        } else if(Trigger.isUpdate) {
             PartTriggerHelper.populateDefaults();
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            PartTriggerHelper.AfterUpdateOperation();
            PartTriggerHelper.updateKitLineItems();
        } 
        if(Trigger.isInsert) {
        	PartTriggerHelper.AfterInsertOperation();
        }
    }
    
}