/**
 * Author: Tarun Khandelwal
 * Since: March 08, 2016
 * Name: SOTrigger
 * Description: Trigger executes on after insert and after update events of SO Header object
**/
trigger SOTrigger on Service_Order_Header__c (before insert, before update, after update) {
	
	SOTriggerHelper.soHeaderNewList = Trigger.new;
	SOTriggerHelper.soHeaderOldList = Trigger.old;
	SOTriggerHelper.soHeaderNewMap = Trigger.newMap;
	SOTriggerHelper.soHeaderOldMap = Trigger.oldMap;
	
	if(Trigger.isBefore && Trigger.isInsert){
		SOTriggerHelper.beforeInsertOperation();
	}
	
	if(Trigger.isBefore && Trigger.isUpdate){
		SOTriggerHelper.beforeUpdateOperation();
	}
	
	if(Trigger.isAfter && Trigger.isUpdate){
		SOTriggerHelper.updateLabourRelatedSOLIs();
	}
}