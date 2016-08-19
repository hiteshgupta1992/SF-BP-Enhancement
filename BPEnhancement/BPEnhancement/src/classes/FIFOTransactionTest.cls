@isTest
private class FIFOTransactionTest {

     @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    static testMethod void createFIFOBucketForPartTest() {
         Account vendor = TestUtil.createVendor(true, 'testvendor');
         Category__c categoryObject = TestUtil.createCategory(true, 'Test', '   Miscellaneous', 'Test description', true, true);
         Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
         Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
         Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
         List<Part__c> partList = new List<Part__c> ();
         partList.add(partObject1);
         partList.add(partObject2);
         partList.add(partObject3);
         Test.startTest();
         List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id from Part_FIFO_Bucket__c where Source_Name__c='Part Created'];
         Test.stopTest();
         List<String> partidList = new List<String>{partObject1.id,partObject2.id,partObject3.id};
         partFIFOBucketList=[Select id from Part_FIFO_Bucket__c  where Part__c in :partidList];
         System.assertEquals(3,partFIFOBucketList.size());
         FIFOTransaction.createFIFOBucketForPartImport(partList);
         partFIFOBucketList=[Select id from Part_FIFO_Bucket__c  where Source_Name__c='Part Imported'];
         System.assertEquals(6,partFIFOBucketList.size());
    }
    
    
    static testmethod void createFIFOBucketForVendorReceivingTest(){
         Account vendor = TestUtil.createVendor(true, 'testvendor');
         Category__c categoryObject = TestUtil.createCategory(true, 'Test', '   Miscellaneous', 'Test description', true, true);
         Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
         Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
         Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
         List<Part__c> partList = [select Id, Qty_In_Stock__c, Qty_Committed__c, Last_Cost__c, Average_Cost__c, Qty_On_Order__c from Part__c]; 
         Vendor_Receiving_Header__c vendorReceiveingheaderObject = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'Stocked');
         Map<Id, Part__c> updateOnOrderIdtoPartMap = new Map<Id, Part__c>();
         for(part__c p : partList){
         	updateOnOrderIdtoPartMap.put(p.Id, p);
         }
         Test.startTest();
         FIFOTransaction.createFIFOBucketForVendorReceiving(partList, vendorReceiveingheaderObject.id, updateOnOrderIdtoPartMap);
         Test.stopTest();
         List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id from Part_FIFO_Bucket__c];
         System.assertEquals(6,partFIFOBucketList.size());
         
    }
    
    static testmethod void updateFIFOBucketForVendorInvoicingTest(){
        Account vendor = TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject = TestUtil.createCategory(true, 'Test', '    Miscellaneous', 'Test description', true, true);
        Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
        Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
        Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
        List<Part__c> partList = new List<Part__c> ();
        partList.add(partObject1);
        partList.add(partObject2);
        partList.add(partObject3);
        FIFOTransaction.createFIFOBucketForPartCreate(partList);
        Vendor_Receiving_Header__c vendorReceiveingheaderObject = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Vendor_Invoicing_Header__c vendorInvoiceHeaderObject = TestUtil.createVendorInvoiceHeader(true, vendor.Id, 'Stocked');
        Map<Id, List<Part__c>> vendorReceivingHeaderToPartMap=new Map<Id, List<Part__c>>();
        vendorReceivingHeaderToPartMap.put(vendorReceiveingheaderObject.id,partList);
        Test.startTest();
        FIFOTransaction.updateFIFOBucketForVendorInvoicing(vendorReceivingHeaderToPartMap, vendorInvoiceHeaderObject.id);
        Test.stopTest();
        List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id from Part_FIFO_Bucket__c];
        System.assertEquals(6,partFIFOBucketList.size());
    }
    static testmethod void updatePartInStockTest(){
        Account vendor = TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject = TestUtil.createCategory(true, 'Test', '    Miscellaneous', 'Test description', true, true);
        Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
        Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
        Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
        List<Part__c> partList = new List<Part__c> ();
        partList.add(partObject1);
        partList.add(partObject2);
        partList.add(partObject3);
        List<String> partidList = new List<String>{partObject1.id,partObject2.id,partObject3.id};
        Test.startTest();
        FIFOTransaction.updatePartInStock(partidList);
        List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id from Part_FIFO_Bucket__c];
        System.assertEquals(3,partFIFOBucketList.size());
        Test.stopTest();
    }
    
    static testmethod void insertBucketActivityTest(){
        FIFOTransaction FIFOTransactionObject = new FIFOTransaction();
        System.assertEquals(null,FIFOTransactionObject.insertBucketActivity());
    }
    static testmethod void getBucketTest(){
        FIFOTransaction FIFOTransactionObject = new FIFOTransaction();
        System.assertEquals(null,FIFOTransactionObject.getBucket(null,null));
    }
    
    static testmethod void CreateFiFoBucketActivityForInvoiceTest(){
        Account customer = TestUtil.createCustomer(true, 'testcustomer', 'customer@gmail.com', 'Jaipur', '8058704475');
        Account vendor = TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject = TestUtil.createCategory(true, 'Test', '    Miscellaneous', 'Test description', true, true);
        Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
        Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
        Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
        List<Part__c> partList = new List<Part__c> ();
        partList.add(partObject1);
        partList.add(partObject2);
        partList.add(partObject3);
        List<String> partidList = new List<String>{partObject1.id,partObject2.id,partObject3.id};
        CO_Header__c coheaderobject =  TestUtil.createCOHeader(true, customer.id);
        CO_Invoice_Header__c  coInvoiceHeaderObject = TestUtil.createCOInvoiceHeader(true, coheaderobject.id, 'Stocked');
        Map<Id, List<Part_FIFO_Bucket__c>> PartToFIFOBucketMap=new Map<Id, List<Part_FIFO_Bucket__c>>();
        Map<Id,Part__c> updateStockedMap= new   Map<Id,Part__c>();
        updateStockedMap.put(partObject1.id,partObject1);
        updateStockedMap.put(partObject2.id,partObject2);
        updateStockedMap.put(partObject3.id,partObject3);   
        Test.startTest();
        String invoiceHeaderId = coInvoiceHeaderObject.id;
        List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id,Remaining_Qty__c from Part_FIFO_Bucket__c  where Part__c in :partidList];
        PartToFIFOBucketMap.put(partObject1.id,partFIFOBucketList);
        FIFOTransaction.CreateFiFoBucketActivityForInvoice(PartToFIFOBucketMap,  invoiceHeaderId, partList, updateStockedMap);
        System.assertEquals(3,partFIFOBucketList.size());
        Test.stopTest();
    }
    
    static testmethod  void createFIFOBucketForCustomerReturnTest(){
        Account customer = TestUtil.createCustomer(true, 'testcustomer', 'customer@gmail.com', 'Jaipur', '8058704475');
        CO_Header__c coheaderobject =  TestUtil.createCOHeader(true, customer.id);
        CO_Invoice_Header__c  coInvoiceHeaderObject = TestUtil.createCOInvoiceHeader(true, coheaderobject.id, 'Stocked');
        Account vendor = TestUtil.createVendor(true, 'testvendor');
        Category__c categoryObject = TestUtil.createCategory(true, 'Test', '    Miscellaneous', 'Test description', true, true);
        Part__c partObject1 = TestUtil.createPart(true, '101', vendor.id, 'test1', categoryObject.id, 200, 200, 100, 20, 20);
        Part__c partObject2 = TestUtil.createPart(true, '102', vendor.id, 'test2', categoryObject.id, 201, 200, 100, 20, 20);
        Part__c partObject3 = TestUtil.createPart(true, '103', vendor.id, 'test3', categoryObject.id, 202, 100, 10, 2, 2);
        List<Part__c> partList = new List<Part__c> ();
        partList.add(partObject1);
        partList.add(partObject2);
        partList.add(partObject3);
        Test.startTest();
        FIFOTransaction.createFIFOBucketForCustomerReturn(partList, coInvoiceHeaderObject.id);
        Test.stopTest();
        List<String> partidList = new List<String>{partObject1.id,partObject2.id,partObject3.id};
        List<Part_FIFO_Bucket__c> partFIFOBucketList=[Select id,Remaining_Qty__c from Part_FIFO_Bucket__c  where Part__c in :partidList];
        System.assertEquals(6,partFIFOBucketList.size());
    }
}