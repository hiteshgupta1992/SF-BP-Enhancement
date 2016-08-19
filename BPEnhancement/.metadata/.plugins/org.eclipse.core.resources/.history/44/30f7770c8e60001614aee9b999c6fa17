/**
 * Author: Tarun Khandelwal
 * Since: Nov. 13, 2014
 * Name: CustomerTrigger
 * Description: Trigger executes on before insert, before update and before delete events of Customer object
**/
trigger CustomerTrigger on Account (before delete, after insert, after update, before insert, before update) {
    
    CustomerTriggerHelper.accountNewList = Trigger.new;
    CustomerTriggerHelper.accountOldList = Trigger.old;
    CustomerTriggerHelper.accountNewMap = Trigger.newMap;
    CustomerTriggerHelper.accountOldMap = Trigger.oldMap;
    CustomerTriggerHelper.isTriggerRun = false;
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            //CustomerTriggerHelper.populatesFieldsBeforeInsert();
        } else if(Trigger.isUpdate) {
            //CustomerTriggerHelper.populatesFieldsBeforeInsert();
            /*if(!MakeGeoLocationCalloutBatch.isBatchExecuted) {
            	CustomerTriggerHelper.getGeoLocation();
            }*/
        } else if(Trigger.isDelete) {
            //CustomerTriggerHelper.accountDeleteOperation();
        }
        
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            CustomerTriggerHelper.accountInsertOperation();
        } else if(Trigger.isUpdate && !CustomerTriggerHelper.isTriggerRun) {
            //CustomerTriggerHelper.getGeoLocation();
            //CustomerTriggerHelper.isTriggerRun = true;
        }
    }
    
}