@isTest
private class VendorOrderHeaderTriggerTest {

    static testMethod void testUpdateVendorOrderHeader(){
    	
        Vendor_Order_Header__c voHeader = new Vendor_Order_Header__c(Status__c = 'Open');
        insert voHeader;
        
        voHeader.Status__c = 'Locked';
        update voHeader;
        
        voHeader = [Select id, Name, Status__c from Vendor_Order_Header__c Limit 1];
        System.assert(String.valueOf(voHeader.Status__c).equalsIgnoreCase('Locked'), 'Record not updated successfully');
    }
}