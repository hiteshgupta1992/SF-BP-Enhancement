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
private class COInvoiceItemWrapperTest {

    static testMethod void testCOInvoiceItemWrapper() {
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, false, true);
    	
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, salesTax.Id);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItemRec = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 100);
        
        COLineItemTriggerHelper.isTriggerExecute = true;
        insert coLineItemRec;
        
        CO_Invoice_Header__c coinvoiceHeader1 = TestUtil.createCOInvoiceHeader(true, coHeader.Id, 'Active');
    	CO_Invoice_Item__c coinvoiceitem1  = TestUtil.createCOInvoiceItem(true, testCategory.Id, coinvoiceHeader1.Id, coLineItemRec.Id);
        
        coLineItemRec.Qty_Committed__c = 50;
        coLineItemRec.Price__c = 100;
        
        Map<String, List<SObject>> coLineItemIdToCOInvoiceItemsMap = new Map<String, List<SObject>>();
        coLineItemIdToCOInvoiceItemsMap.put(coLineItemRec.Id, new List<SObject> ());
        COInvoiceItemWrapper wrapperWithBlankMap = new COInvoiceItemWrapper(coLineItemRec, coLineItemIdToCOInvoiceItemsMap);
        
        System.assertEquals(50, wrapperWithBlankMap.Qty);
        System.assert(!wrapperWithBlankMap.isSelected);
        
    	coLineItemIdToCOInvoiceItemsMap.put(coLineItemRec.Id, new List<SObject> {coinvoiceitem1});
        COInvoiceItemWrapper wrapper = new COInvoiceItemWrapper(coLineItemRec, coLineItemIdToCOInvoiceItemsMap);
        
        System.assertEquals(50, wrapper.Qty);
        System.assert(wrapper.isSelected);
    }
}