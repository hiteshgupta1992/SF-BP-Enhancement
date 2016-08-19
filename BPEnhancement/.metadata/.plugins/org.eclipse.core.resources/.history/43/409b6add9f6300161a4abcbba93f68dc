@isTest
public with sharing class AccountingDataMigrationDepositsTest {
	
	@testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
	
	 @isTest
	static void executeDataMigrationBatchTest(){
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	
    	CO_Header__c coHeader1 = TestUtil.createCOHeader(true, null);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItemRec = TestUtil.createCOLineItem(true, coHeader1.Id, part.Id, 50);
        CO_Deposit__c coDeposit = TestUtil.createCODeposit(true, coHeader1.Id, 'Debit', 500);
        
        String coDepositJSON = BPUtility.getDecodedString(CustomerOrderCtrl.getCODepositByCOHeaderId(BPUtility.getEncodedString((coHeader1.Id))));
        
        coDepositJSON = BPUtility.getDecodedString(CustomerOrderCtrl.saveCODeposit(BPUtility.getEncodedString(coDepositJSON)));
        
         List<Accounting_Data_Migration__c> accountMigrate = TestUtil.createAccountMigration(true, 1, 'ReceiveMoneyTxn_Deposit', 'Receive Money');
        
        
        List<GL_Account__c> GLAccountList =  new List<GL_Account__c>();
        
        GL_Account__c  gla  = new GL_Account__c(MYOB_Account_Name__c =  'A/P Accrual - Inventory', MYOB_Account_Number__c = '2-1530',  Type__c = 'Received Inventory Accrual');
        GLAccountList.add(gla);
        
        GL_Account__c  gla1  = new GL_Account__c(MYOB_Account_Name__c =  'BP Customer Deposits', MYOB_Account_Number__c = '1-1250',  Type__c = 'Deposit Allocation Account');
        GLAccountList.add(gla1);
        GL_Account__c  gla2  = new GL_Account__c(MYOB_Account_Name__c =  'Other Income', MYOB_Account_Number__c = '4-4200',  Type__c = '    Sales Invoice Account');
        GLAccountList.add(gla2);
        GL_Account__c  gla3 = new GL_Account__c(MYOB_Account_Name__c =  'Undeposited Funds Account', MYOB_Account_Number__c = '1-1210',  Type__c = 'Deposit Account');
        GLAccountList.add(gla3);
        
        if(GLAccountList.size() > 0){
            insert GLAccountList;
        }
        Test.startTest();
        Id batchId = AccountingDataMigrationDeposits.executeDepositsDataMigrationBatch(200, null, false);
        Test.stopTest();
        List<Accounting_Data_Migration__c>  accountMigrateId = [ SELECT Id FROM Accounting_Data_Migration__c WHERE  Object_Name__c = 'ReceiveMoneyTxn_Deposit' ];
        List<Attachment> attachmentList = [SELECT Id FROM Attachment WHERE ParentId in :accountMigrateId ];
        system.assertEquals(1, attachmentList.size());
	}
    
}