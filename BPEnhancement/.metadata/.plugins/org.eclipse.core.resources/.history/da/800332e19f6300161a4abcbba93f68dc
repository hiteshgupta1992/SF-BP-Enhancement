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
private class COHeaderWrapperTest {
    
    @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }

    static testMethod void testCOHeaderWrapperTest() {
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, false, true);
        List<User> userList = new List<User>();
        //User currentUser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U');
        //userList.add(currentUser);
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
        Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, salesTax.Id);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
        
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItemRec1 = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 100);
        Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
        CO_Deposit__c coDeposit = TestUtil.createCODeposit(true, coHeader.Id, 'Debit', 500);
        CO_Invoice_Header__c coinvoiceHeader1 = TestUtil.createCOInvoiceHeader(true, coHeader.Id, 'Active');
        CO_Invoice_Item__c coinvoiceitem1  = TestUtil.createCOInvoiceItem(true, testCategory.Id, coinvoiceHeader1.Id, coLineItemRec1.Id);
        CO_Invoice_Payment__c coinvoicepayment1  = TestUtil.createCOInvoicePayment(true, coinvoiceHeader1.Id );
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        List<CO_Line_Item__c> coLineItemList = new List<CO_Line_Item__c>();
        List<CO_Deposit__c> coDepositList = new  List<CO_Deposit__c>();
        List<CO_Header__c> coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeader.Id) ;
        List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeader.Id);
        List<CO_Kit_Header__c> coKitHeaders = SOQLUtil.getCOKHByCOHeaderId(coHeader.Id);
        List<Vendor_Order_Line_Item__c> specialOrders = SOQLUtil.getSpecialOrderByCOHeaderId(coHeader.Id);   
        List<User> currentUser = SOQLUtil.getCurrentUserInfo();
        List<CO_Deposit__c> coDeposits = SOQLUtil.getCODepositByCOHeaderId(coHeader.Id);
        List<CO_Invoice_Header__c> coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeader.Id);     
        List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
        List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
        List<CO_Invoice_Header__c> closedCOInvoiceHeaders = SOQLUtil.getInvoiceHistory(coHeader.Id);
        
        List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
        if(coHeaderRec.size() > 0 && coHeaderRec[0].Customer__c != null) {
            couRecords = SOQLUtil.getCOUListByCustomerId(coHeaderRec[0].Customer__c);
        }
        
        if(coLineItems == null) {
            coLineItems = new List<CO_Line_Item__c>();
        }
        if(coDeposits == null) {
            coDeposits = new List<CO_Deposit__c>();
        }
        if(coInvoiceHeaders == null) {
            coInvoiceHeaders = new List<CO_Invoice_Header__c>();
        } else if(coInvoiceHeaders.size() > 0) {
            coInvoicePayments = SOQLUtil.getCOInvoicePaymentsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
            coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
        }
        
        List<Id> vendorIdList = new List<Id>();
        for(CO_Line_Item__c coLineItemRec : coLineItems) {
            if(coLineItemRec.Part__r != null && coLineItemRec.Part__r.Vendor__c != null) {
                vendorIdList.add(coLineItemRec.Part__r.Vendor__c);
            }
        }
        
        List<Vendor_Order_Header__c> voHeaderList = SOQLUtil.getVOHeaderByFieldName(new Map<String, List<String>>{'Vendor__c'=> vendorIdList});
        Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap = new Map<Id, List<Vendor_Order_Header__c>>();
        List<Vendor_Order_Header__c> voHeadersList;
        
        for(Vendor_Order_Header__c voHeaderRec : voHeaderList) {
            if(!vendorIdToVOHeadesListMap.containsKey(voHeaderRec.Vendor__c)) {
                voHeadersList = new List<Vendor_Order_Header__c>();
            } else {
                voHeadersList = vendorIdToVOHeadesListMap.get(voHeaderRec.Vendor__c);
            }
            voHeadersList.add(voHeaderRec);
            vendorIdToVOHeadesListMap.put(voHeaderRec.Vendor__c, voHeadersList);
        }
        
        
        
        Test.startTest();
        COHeaderWrapper coHeaderWrapperObj;
        if(coHeaderRec.size() > 0) {
            coHeaderWrapperObj = new COHeaderWrapper(coHeaderRec[0], coLineItems, coKitHeaders, currentUser[0].LocaleSidKey, coDeposits, coInvoiceHeaders, 
                                                     coInvoicePayments, coInvoiceItems, closedCOInvoiceHeaders, vendorIdToVOHeadesListMap, couRecords, specialOrders);
        }
        if(coHeaderRec.size() > 0 && coHeaderRec[0].Owner__c == currentUser[0].Id){
            CO_Header__c currentCOHeader = new CO_Header__c(Id = coHeader.Id);
            currentCOHeader.Owner_Last_Visited__c = System.now();
            update currentCOHeader;
            
        }
        
        //CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
        Test.stopTest();
        System.assertNotEquals(null, coHeaderWrapperObj);
    }
    
    static testMethod void testCOHeaderWrapperTestWithoutKit() {
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, false, true);
        List<User> userList = new List<User>();
        //User currentUser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U');
        //userList.add(currentUser);
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
        Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, salesTax.Id);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
        Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
        
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItemRec1 = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 100);
        CO_Deposit__c coDeposit = TestUtil.createCODeposit(true, coHeader.Id, 'Debit', 500);
        CO_Invoice_Header__c coinvoiceHeader1 = TestUtil.createCOInvoiceHeader(true, coHeader.Id, 'Active');
        CO_Invoice_Item__c coinvoiceitem1  = TestUtil.createCOInvoiceItem(true, testCategory.Id, coinvoiceHeader1.Id, coLineItemRec1.Id);
        CO_Invoice_Payment__c coinvoicepayment1  = TestUtil.createCOInvoicePayment(true, coinvoiceHeader1.Id );
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        List<CO_Line_Item__c> coLineItemList = new List<CO_Line_Item__c>();
        List<CO_Deposit__c> coDepositList = new  List<CO_Deposit__c>();
        List<CO_Header__c> coHeaderRec = SOQLUtil.getCOHeaderDetails(coHeader.Id) ;
        List<CO_Line_Item__c> coLineItems = SOQLUtil.getCOLineItemByCOHeaderId(coHeader.Id);
        List<CO_Kit_Header__c> coKitHeaders = SOQLUtil.getCOKHByCOHeaderId(coHeader.Id);
        List<Vendor_Order_Line_Item__c> specialOrders = SOQLUtil.getSpecialOrderByCOHeaderId(coHeader.Id);   
        List<User> currentUser = SOQLUtil.getCurrentUserInfo();
        List<CO_Deposit__c> coDeposits = SOQLUtil.getCODepositByCOHeaderId(coHeader.Id);
        List<CO_Invoice_Header__c> coInvoiceHeaders = SOQLUtil.getCOInvoiceHeaderByCOHeaderId(coHeader.Id);     
        List<CO_Invoice_Payment__c> coInvoicePayments = new List<CO_Invoice_Payment__c>();
        List<CO_Invoice_Item__c> coInvoiceItems = new List<CO_Invoice_Item__c>();
        List<CO_Invoice_Header__c> closedCOInvoiceHeaders = SOQLUtil.getInvoiceHistory(coHeader.Id);
        
        List<Customer_Owned_Unit__c> couRecords = new List<Customer_Owned_Unit__c>();
        if(coHeaderRec.size() > 0 && coHeaderRec[0].Customer__c != null) {
            couRecords = SOQLUtil.getCOUListByCustomerId(coHeaderRec[0].Customer__c);
        }
        
        if(coLineItems == null) {
            coLineItems = new List<CO_Line_Item__c>();
        }
        if(coDeposits == null) {
            coDeposits = new List<CO_Deposit__c>();
        }
        if(coInvoiceHeaders == null) {
            coInvoiceHeaders = new List<CO_Invoice_Header__c>();
        } else if(coInvoiceHeaders.size() > 0) {
            coInvoicePayments = SOQLUtil.getCOInvoicePaymentsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
            coInvoiceItems = SOQLUtil.getCOInvoiceItemsByCOInvoiceHeaderId(coInvoiceHeaders[0].Id);
        }
        
        List<Id> vendorIdList = new List<Id>();
        for(CO_Line_Item__c coLineItemRec : coLineItems) {
            if(coLineItemRec.Part__r != null && coLineItemRec.Part__r.Vendor__c != null) {
                vendorIdList.add(coLineItemRec.Part__r.Vendor__c);
            }
        }
        
        List<Vendor_Order_Header__c> voHeaderList = SOQLUtil.getVOHeaderByFieldName(new Map<String, List<String>>{'Vendor__c'=> vendorIdList});
        Map<Id, List<Vendor_Order_Header__c>> vendorIdToVOHeadesListMap = new Map<Id, List<Vendor_Order_Header__c>>();
        List<Vendor_Order_Header__c> voHeadersList;
        
        for(Vendor_Order_Header__c voHeaderRec : voHeaderList) {
            if(!vendorIdToVOHeadesListMap.containsKey(voHeaderRec.Vendor__c)) {
                voHeadersList = new List<Vendor_Order_Header__c>();
            } else {
                voHeadersList = vendorIdToVOHeadesListMap.get(voHeaderRec.Vendor__c);
            }
            voHeadersList.add(voHeaderRec);
            vendorIdToVOHeadesListMap.put(voHeaderRec.Vendor__c, voHeadersList);
        }
        
        
        
        Test.startTest();
        COHeaderWrapper coHeaderWrapperObj;
        if(coHeaderRec.size() > 0) {
            coHeaderWrapperObj = new COHeaderWrapper(coHeaderRec[0], coLineItems, coLineItems, currentUser[0].LocaleSidKey, coDeposits, coInvoiceHeaders, 
                                                     coInvoicePayments, coInvoiceItems, closedCOInvoiceHeaders, vendorIdToVOHeadesListMap, couRecords);
        }
        if(coHeaderRec.size() > 0 && coHeaderRec[0].Owner__c == currentUser[0].Id){
            CO_Header__c currentCOHeader = new CO_Header__c(Id = coHeader.Id);
            currentCOHeader.Owner_Last_Visited__c = System.now();
            update currentCOHeader;
            
        }
        
        //CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
       Test.stopTest();
       System.assertNotEquals(null, coHeaderWrapperObj); 
        
        
    }
}