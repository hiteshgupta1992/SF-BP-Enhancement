/**
 * Author: Tarun Khandelwal
 * Since: Oct. 11, 2014
 * Name: recentCustomerTrigger
 * Description: Trigger executes on before insert events of Recent Customer object
**/
trigger RecentPartTrigger on Recent_Part__c (before insert) {
    
    RecentPartTriggerHelper.recentPartNewList = Trigger.new;
    RecentPartTriggerHelper.recentPartOldList = Trigger.old;
    RecentPartTriggerHelper.recentPartNewMap = Trigger.newMap;
    RecentPartTriggerHelper.recentPartOldMap = Trigger.oldMap;
    
    if(Trigger.isInsert) {
        RecentPartTriggerHelper.beforeInsertOperation();
    }
    
}