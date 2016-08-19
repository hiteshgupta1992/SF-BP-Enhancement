/**
 * Author: Ashish Garg
 * Since: Dec. 1,
 * Name: KitHeaderTrigger
 * Description: Trigger executes on before update event of Kit Header object
**/
trigger KitHeaderTrigger on Kit_Header__c (before update) {
    KitHeaderTriggerHelper.KHNewList    = Trigger.new;
    KitHeaderTriggerHelper.KHOldList    = Trigger.old;
    KitHeaderTriggerHelper.KHNewMap     = Trigger.newMap;
    KitHeaderTriggerHelper.KHOldMap     = Trigger.oldMap;
    
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            KitHeaderTriggerHelper.processBeforeUpdate();
        }
    }
}