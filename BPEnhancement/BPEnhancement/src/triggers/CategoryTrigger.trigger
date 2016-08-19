/**
 * Author: Tarun Khandelwal
 * Since: Dec. 17, 2014
 * Name: CategoryTrigger
 * Description: Trigger executes on before insert event of Category object
**/
trigger CategoryTrigger on Category__c (before insert, before update, before delete) {
    
    CategoryTriggerHelper.categoryNewList = Trigger.new;
    CategoryTriggerHelper.categoryOldList = Trigger.old;
    CategoryTriggerHelper.categoryNewMap = Trigger.newMap;
    CategoryTriggerHelper.categoryOldMap = Trigger.oldMap;
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            CategoryTriggerHelper.checkForUniqueNameByType();
        } else if (Trigger.isUpdate) {
            CategoryTriggerHelper.checkForUniqueNameByType();
        } else if (Trigger.isDelete) {
            CategoryTriggerHelper.checkForDefaultDelete();
        } 
    }
}