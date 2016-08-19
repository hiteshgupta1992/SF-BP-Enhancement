/**
 * Author: Tarun Khandelwal
 * Since: Oct. 10, 2014
 * Name: SalesTaxTrigger
 * Description: Trigger executes on before insert and before update events of Price Level object
**/
trigger SalesTaxTrigger on Sales_Tax__c (before insert, before update, before delete) {
    
    // Initializes List of helper classes
    SalesTaxTriggerHelper.salesTaxNewList = Trigger.new;
    SalesTaxTriggerHelper.salesTaxOldList = Trigger.old;
    SalesTaxTriggerHelper.salesTaxNewMap = Trigger.newMap;
    SalesTaxTriggerHelper.salesTaxOldMap = Trigger.oldMap;
    if( Trigger.isBefore ) {
        
        if( Trigger.isInsert ) {
             // Update default field if new record default field is selected
             SalesTaxTriggerHelper.updateDefaultField();
        }
        
        if( Trigger.isUpdate ) {
             // Update default field if new record default field is selected
             SalesTaxTriggerHelper.updateDefaultField();
        }
        
        if( Trigger.isDelete ) {
             // Validate the deleting record before deleting if it default and active record or not
             SalesTaxTriggerHelper.validateBeforeDel();
        }
    }
}