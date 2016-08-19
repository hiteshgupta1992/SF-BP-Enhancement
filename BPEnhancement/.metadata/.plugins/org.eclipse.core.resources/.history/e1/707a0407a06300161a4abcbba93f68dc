/**
 * Author: Ashish Garg
 * Since: Dec. 1,
 * Name: KitLineItemtrigger
 * Description: Trigger executes on before delete, before insert, before update events of Kit Header Line Item object records
**/
trigger KitLineItemtrigger on Kit_Header_Line_Item__c (before insert, before update, before delete, after insert, after delete) {
	KitLineItemtriggerHelper.newList	= Trigger.new;
	KitLineItemtriggerHelper.oldList	= Trigger.old;
	KitLineItemtriggerHelper.newMap		= Trigger.newMap;
	KitLineItemtriggerHelper.oldMap		= Trigger.oldMap;

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			KitLineItemtriggerHelper.processBeforeInsert();
		} else if (Trigger.isUpdate) {
			KitLineItemtriggerHelper.processBeforeUpdate();
		} else if (Trigger.isDelete) {
			KitLineItemtriggerHelper.processBeforeDelete();
		}
	}
	
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			KitLineItemtriggerHelper.setDefaultFields();
		} else if (Trigger.isDelete) {
			KitLineItemtriggerHelper.setDefaultFields();
		}
	}
}