/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CustomerTriggerHelperTest {
	
	/**
     * Name: customerInsertOperationTest
     * Desc: Testing of reccent customer record when customer are created
     * @param: 
     * @return: 
    **/
  /*  static testMethod void customerInsertOperationTest() {
        Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
        Test.startTest();
        Account testCustomer1 = TestUtil.createCustomer(true, 'Test Customer 1', 'test1@gmail.com', 'Jaipur', '147258369');
        Account testCustomer2 = TestUtil.createCustomer(true, 'Test Customer 2', 'test2@gmail.com', 'Delhi', '147252569');
        Test.stopTest();
        
        List<Account> reccentCustomers = [select Id from Account];
        system.assertEquals(reccentCustomers.size(), 2);
    }
    
    /**
     * Name: customerUpdateOperationTest
     * Desc: Testing of reccent customer record when customer record is updated
     * @param: 
     * @return: 
    **/
   /* static testMethod void customerUpdateOperationTest() {
    	Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
    	
        Account testCustomer1 = TestUtil.createCustomer(true, 'Test Customer 1', 'test1@gmail.com', 'Jaipur', '147258369');
        Account testCustomer2 = TestUtil.createCustomer(true, 'Test Customer 2', 'test2@gmail.com', 'Delhi', '147252569');
        
        Test.startTest();
        testCustomer2.BillingStreet = 'C-153, Near Railway Station';
        update testCustomer2;
        Test.stopTest();
        
        List<Recent_Customer__c> reccentCustomers = [select Id from Recent_Customer__c];
        system.assertEquals(reccentCustomers.size(), 2);
    }
    
    /**
     * Name: customerDeleteOperationTest
     * Desc: Testing of reccent customer record when customer record is deleted
     * @param: 
     * @return: 
    **/
   /* static testMethod void customerDeleteOperationTest() {
    	Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
    	
        Account testCustomer1 = TestUtil.createCustomer(true, 'Test Customer 1', 'test1@gmail.com', 'Jaipur', '147258369');
        Account testCustomer2 = TestUtil.createCustomer(true, 'Test Customer 2', 'test2@gmail.com', 'Delhi', '147252569');
        
        Test.startTest();
        delete testCustomer2;
        Test.stopTest();
        
        List<Recent_Customer__c> reccentCustomers = [select Id from Recent_Customer__c];
        system.assertEquals(reccentCustomers.size(), 1);
    }*/
    /**
     * Name: populatesFieldsBeforeInsert
     * Desc: Testing of field populate for vendor
     * @param: 
     * @return: 
    **/
    /*
    static testMethod void populatesFieldsBeforeInsert() {
        
        
        Price_Level__c priceleveltest = TestUtil.createPriceLevel(true, 'priceleveltest', 'MSRP', 10, true, true);
        Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, true, true);
        Account testCustomer1 = TestUtil.createCustomer(false, 'Test', 'abc@test.com', 'Jaipur', '1111111111', priceLeveltest.Id, salesTax.Id, true);
        Test.startTest();
        Insert testCustomer1;
        Test.stopTest();
        
        List<Account> vendorList = [select Vendor_Code__c, Vendor_Count__c from Account where Id = :testCustomer1.Id];
        system.assertEquals(vendorList[0].Vendor_Count__c, 001);
        system.assertEquals(vendorList[0].Vendor_Code__c, 'TES001');
    }
    */
    /**
     * Name: populatesFieldsBeforeInsert
     * Desc: Testing of field populate for vendor in case Isvendor set to false
     * @param: 
     * @return: 
    **/
    /*
    static testMethod void populatesFieldsBeforeInsertNegativeTest() {
        
        
        Price_Level__c priceleveltest = TestUtil.createPriceLevel(true, 'priceleveltest', 'MSRP', 10, true, true);
        Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, true, true);
        Account testCustomer1 = TestUtil.createCustomer(false, 'Test', 'abc@test.com', 'Jaipur', '1111111111', priceLeveltest.Id, salesTax.Id, false);
        Test.startTest();
        Insert testCustomer1;
        Test.stopTest();
        
        List<Account> vendorList = [select Vendor_Code__c, Vendor_Count__c from Account where Id = :testCustomer1.Id];
        system.assertEquals(vendorList[0].Vendor_Count__c, null);
        system.assertEquals(vendorList[0].Vendor_Code__c, null);
    }
    */
}