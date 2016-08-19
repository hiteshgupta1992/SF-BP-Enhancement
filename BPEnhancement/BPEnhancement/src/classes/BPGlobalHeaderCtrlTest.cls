@isTest
public with sharing class BPGlobalHeaderCtrlTest {
    
    @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    
    static testMethod void getCurrentUserImageURLTest(){
    	BPGlobalHeaderCtrl BPGHCtrl = new BPGlobalHeaderCtrl();
    	System.assertEquals(BPGHCtrl.Load_New_UI, false);
    	String imageURL = BPGHCtrl.getCurrentUserImageURL();
    	System.assertNotEquals(imageURL, null);
    }
    
    static testMethod void createCustomerOrderTest(){
    	BPGlobalHeaderCtrl.createCustomerOrder();
    	List<CO_Header__c> coHeaderList = [select id from CO_Header__c];
    	System.assertEquals(coHeaderList.size(), 1);
    }
    
    
    static testMethod void createVendorOrderTest(){
    	BPGlobalHeaderCtrl.createVendorOrder();
    	List<Vendor_Order_Header__c> voHeaderList = [select id from Vendor_Order_Header__c];
    	System.assertEquals(voHeaderList.size(), 1);
    }
    
    static testMethod void createVOReceivingTest(){
    	BPGlobalHeaderCtrl.createVOReceiving();
    	List<Vendor_Receiving_Header__c> vrHeaderList = [select id from Vendor_Receiving_Header__c];
    	System.assertEquals(vrHeaderList.size(), 1);
    }
     
    static testMethod void createVOInvoicingTest(){
    	BPGlobalHeaderCtrl.createVOInvoicing();
    	List<Vendor_Invoicing_Header__c> viHeaderList = [select id from Vendor_Invoicing_Header__c];
    	System.assertEquals(viHeaderList.size(), 1);
    }
}