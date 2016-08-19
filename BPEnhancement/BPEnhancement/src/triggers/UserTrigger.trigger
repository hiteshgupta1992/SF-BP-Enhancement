trigger UserTrigger on User (after insert) {
	UserTriggerHelper.userNewList = Trigger.new;
	UserTriggerHelper.userOldList = Trigger.old;
	UserTriggerHelper.userNewMap = Trigger.newMap;
	UserTriggerHelper.userOldMap = Trigger.oldMap;
	
	UserTriggerHelper.createWidgetAndFilter();
}