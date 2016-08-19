/**
 * Name: AccountingDataMigrationVendorTest
 * Since: 12 February,2016
 * Author: Anurag Anand
 * Description: Test Class is used to test AccountingDataMigrationVendor class
**/
@isTest
private class AccountingDataMigrationVendorsTest {
    /**
     * Name: createTestClassData
     * Desc: Test setup method to create test data going to be used in test methods
     * @param:	
     * @return: 
    **/
	@testSetup
    private static void createTestClassData(){
    	
    	// Records have been Created in order to Test and Verify the Vendors Account
    	List<Account> vendorAccount = TestUtil.createVendorAccount(true, 2);
    	
    	// Account Data Migration have been created 
    	List<Accounting_Data_Migration__c> accountMigrate = TestUtil.createAccountMigration(true, 1, 'Supplier Card', 'Supplier Cards');
    }
    /**
     * Name: executeVendorCardsDataMigrationBatchTest
     * Desc: Test the account Vendor Data Migration Batch 
     * @param:
     * @Return:
    **/
     
    @isTest
    static void executeVendorCardsDataMigrationBatchTest(){
    	Integer batchSize = 500;
		Id batchId;    	
    	Test.startTest();
    	batchId=AccountingDataMigrationVendors.executeVendorCardsDataMigrationBatch(batchSize, null, false);
    	Test.stopTest();
    	system.assertNotEquals(null,batchId);
    }
    
}