/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: COTrigger
 * Description: Trigger executes on after update event of CO Hearder object
**/
trigger COTrigger on CO_Header__c (before insert, before update, after update) {
    
    COTriggerHelper.COHeaderNewList = Trigger.new;
    COTriggerHelper.COHeaderOldList = Trigger.old;
    COTriggerHelper.COHeaderNewMap = Trigger.newMap;
    COTriggerHelper.COHeaderOldMap = Trigger.oldMap;
    COTriggerHelper.isTriggerExecute = false;
    
    if(trigger.isBefore && trigger.isInsert) {
        COTriggerHelper.beforeInsertOperation();
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
        COTriggerHelper.beforeUpdateOperation();
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
        COTriggerHelper.afterUpdateCalculation();
        COTriggerHelper.updateAccountFields();
    }
    
}