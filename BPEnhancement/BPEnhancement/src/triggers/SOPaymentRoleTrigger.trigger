/**
 * Author: Tarun Khandelwal
 * Since: May 31, 2016
 * Name: SOPaymentRoleTrigger
 * Description: Trigger executes on after insert and before delete events of SO_Payment_Role__c object
**/
trigger SOPaymentRoleTrigger on SO_Payment_Role__c (after insert, before delete) {
	
	SOPaymentRoleTriggerHelper.soPaymentRoleNewList = Trigger.new;
	SOPaymentRoleTriggerHelper.soPaymentRoleOldList = Trigger.old;
	SOPaymentRoleTriggerHelper.soPaymentRoleNewMap = Trigger.newMap;
	SOPaymentRoleTriggerHelper.soPaymentRoleOldMap = Trigger.oldMap;
	SOPaymentRoleTriggerHelper.isTriggerRun = false;
	
	if(Trigger.isAfter && Trigger.isInsert) {
		SOPaymentRoleTriggerHelper.afterInsertOperation();
	}
	if(Trigger.isBefore && Trigger.isDelete) {
		SOPaymentRoleTriggerHelper.beforeDeleteOperation();
	}
}