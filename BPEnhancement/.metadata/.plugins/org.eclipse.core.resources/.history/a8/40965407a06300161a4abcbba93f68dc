/**
 * Author: Tarun Khandelwal
 * Since: Oct. 11, 2014
 * Name: SalesTaxItemTrigger
 * Description: Trigger executes on before delete and after update events of Sales Tax Item object
**/
trigger SalesTaxItemTrigger on Sales_Tax_Item__c (before delete, after update) {
	
	SalesTaxItemTriggerHelper.oldMap = trigger.oldMap;
	SalesTaxItemTriggerHelper.newMap = trigger.newMap;
	SalesTaxItemTriggerHelper.newList = trigger.new;
	SalesTaxItemTriggerHelper.oldList = trigger.old;
	
	if(trigger.isDelete) {
		SalesTaxItemTriggerHelper.beforeDeleteOperations();
	}
	
	if(trigger.isUpdate) {
		SalesTaxItemTriggerHelper.afterUpdateOperation();
	}
}