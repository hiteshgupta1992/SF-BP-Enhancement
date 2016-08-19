/**
 * Author: Tarun Khandelwal
 * Since: Oct. 11, 2014
 * Name: ApplicableTaxTrigger
 * Description: Trigger executes on after insert and after delete events of Applicable Tax object
**/
trigger ApplicableTaxTrigger on Applicable_Taxes__c (after delete, after insert) {
	
	ApplicableTaxTriggerHelper.applicableTaxNewList = Trigger.new;
	ApplicableTaxTriggerHelper.applicableTaxOldList = Trigger.old;
	ApplicableTaxTriggerHelper.applicableTaxNewMap = Trigger.newMap;
	ApplicableTaxTriggerHelper.applicableTaxOldMap = Trigger.oldMap;
	
	if(trigger.isInsert || Trigger.isDelete){
		ApplicableTaxTriggerHelper.updateRateFieldOnSalesTax();
		
	}

}