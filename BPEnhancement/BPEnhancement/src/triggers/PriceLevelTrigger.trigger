/**
 * Author: Tarun Khandelwal
 * Since: Oct. 10, 2014
 * Name: PriceLevelTrigger
 * Description: Trigger executes on before insert and before update events of Price Level object
**/
trigger PriceLevelTrigger on Price_Level__c (before insert, before update, before delete) {
    
    // Initializes List of helper classes
    PriceLevelTriggerHelper.priceLevelNewList = Trigger.new;
    PriceLevelTriggerHelper.priceLevelOldList = Trigger.old;
    PriceLevelTriggerHelper.priceLevelNewMap = Trigger.newMap;
    PriceLevelTriggerHelper.priceLevelOldMap = Trigger.oldMap;
    if( Trigger.isBefore ) {
        
        if( Trigger.isInsert ) {
             // Update default field if new record default field is selected
             PriceLevelTriggerHelper.updateDefaultField();
        }
        
        if( Trigger.isUpdate ) {
             // Update default field if new record default field is selected
             PriceLevelTriggerHelper.updateDefaultField();
        }
        
        if( Trigger.isDelete ) {
             // Validate the deleting record before deleting if it default and active record or not
             PriceLevelTriggerHelper.validateBeforeDel();
        }
    }
}