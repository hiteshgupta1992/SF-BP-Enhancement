/**
 * Author: Tarun Khandelwal
 * Since: Oct. 17, 2014
 * Name: CountryTrigger
 * Description: Trigger executes on before insert, before update and before delete events of Country object
**/
trigger CountryTrigger on Country__c (before insert, before update, before delete) {
    
    // Initializes List of helper classes
    CountryTriggerHelper.countryNewList = Trigger.new;
    CountryTriggerHelper.countryOldList = Trigger.old;
    CountryTriggerHelper.countryNewMap = Trigger.newMap;
    CountryTriggerHelper.countryOldMap = Trigger.oldMap;
    
    if(Trigger.isInsert) {
        CountryTriggerHelper.updateDefaultfield();
    }
    
    if(Trigger.isUpdate) {
        CountryTriggerHelper.updateDefaultfield();
    }
    
    if(Trigger.isDelete) {
        CountryTriggerHelper.checkDefaultOnDelete();
    }
    
}