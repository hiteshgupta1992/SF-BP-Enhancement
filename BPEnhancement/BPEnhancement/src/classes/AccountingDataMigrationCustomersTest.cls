/**
 * Name:AccountingDataMigrationCustomersTest
 * Since: 12 February,2016
 * Author: Anurag Anand
 * Description: Test Class is used to test AccountingDataMigrationCustomers class
**/
@isTest
private class AccountingDataMigrationCustomersTest {
    
    @testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
    
    /**
     * Name: executeCustomerCardsDataMigrationBatchTest
     * Desc: Test the account Customer Data Migration Batch 
     * @param:
     * @Return:
    **/
     
    @isTest
    static void executeCustomerCardsDataMigrationBatchTest(){
    	List<Account> CustAccount = TestUtil.createCustomerAccount(true, 2);
    	Integer batchSize = 500;
		List<Accounting_Data_Migration__c> accountMigrate = TestUtil.createAccountMigration(true, 1, 'Customers Card', 'Customers Cards');
    	Test.startTest();
    	Id batchId = AccountingDataMigrationCustomers.executeCustomerCardsDataMigrationBatch(batchSize, null, false);
    	Test.stopTest();
    	List<Accounting_Data_Migration__c>  accountMigrateId = [ SELECT Id FROM Accounting_Data_Migration__c WHERE  Object_Name__c = 'Customers Card' ];
    	List<Attachment> attachmentList = [SELECT Id FROM Attachment WHERE ParentId in :accountMigrateId ];
    	system.assertEquals(1, attachmentList.Size());
    }
    
    
    
}