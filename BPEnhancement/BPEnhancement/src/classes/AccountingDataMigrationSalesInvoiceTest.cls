@isTest
public with sharing class AccountingDataMigrationSalesInvoiceTest {

    @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    
    @isTest
    static void executePaymentsDataMigrationBatchTest(){
    
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        //Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 50);
        //CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);
        
        List<Accounting_Data_Migration__c> accountMigrate = TestUtil.createAccountMigration(true, 1, 'Customer Order Sales Invoices', 'Sales - Miscellaneous Sales, Receive Payments, General Journal Entries');
        
        
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
        Id batchId = AccountingDataMigrationSalesInvoice.executeDataMigrationBatch(200, null, false);
        Test.stopTest();
        List<Accounting_Data_Migration__c>  accountMigrateId = [ SELECT Id FROM Accounting_Data_Migration__c WHERE  Object_Name__c = 'Customer Order Sales Invoices' ];
        List<Attachment> attachmentList = [SELECT Id FROM Attachment WHERE ParentId in :accountMigrateId ];
        system.assertEquals(3, attachmentList.size());
    }

}