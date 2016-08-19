/**
 * Author: Hitesh Gupta
 * Since: March 30, 2016
 * Name: FilterTrigger
 * Description: Trigger executes on after update and after insert event of filter object
**/
trigger FilterTrigger on Filter__c (before insert, before update) {
	  
	FilterTriggerHelper.FilterNewList = Trigger.new;
    FilterTriggerHelper.FilterOldList = Trigger.old;
    FilterTriggerHelper.FilterNewMap = Trigger.newMap;
    FilterTriggerHelper.FilterOldMap = Trigger.oldMap;
    
    if(!FilterTriggerHelper.runTrigger){
    	return;
    }
    
    if(trigger.isBefore && trigger.isInsert) {
    	FilterTriggerHelper.hashCodeCalculation();
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
    	FilterTriggerHelper.hashCodeCalculation();
    }  
}