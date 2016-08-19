/**
 * Author: Durga Singh
 * updated: Nov 6, 2015
 * Name: ScenarioBasedTests
 * Description: It includes scenario based test cases.
**/
@isTest
private class COLineItemTriggerHelperTest {
	
    static testMethod void defaultPriceLevelCalculation() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
    	Applicable_Taxes__c appTax = TestUtil.createApplicableTax(true, defaultSalesTax.Id, salesTaxItem.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', defaultPriceLevel.Id, null);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, null);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 50);
        
        Test.startTest();
        insert coLineItem;
        Test.stopTest();
        
        List<CO_Line_Item__c> coLineItemList = [select Retail__c, Price__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Retail__c, 55);
        system.assertEquals(coLineItemList[0].Price__c, 55);
    }
    
    static testMethod void priceLevelCalculation() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Price_Level__c priceLevel = TestUtil.createPriceLevel(true, 'Test Price Level', 'MSRP', -10 , false, true);
    	
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
    	Applicable_Taxes__c appTax = TestUtil.createApplicableTax(true, defaultSalesTax.Id, salesTaxItem.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', priceLevel.Id, null);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 50);
        
        Test.startTest();
        insert coLineItem;
        Test.stopTest();
        
        List<CO_Line_Item__c> coLineItemList = [select Retail__c, Price__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Retail__c, 45);
        system.assertEquals(coLineItemList[0].Price__c, 45);
    }
    
    static testMethod void priceLevelCalculation1() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Price_Level__c priceLevel = TestUtil.createPriceLevel(true, 'Test Price Level', 'Average Cost', -10 , false, true);
    	
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
    	Applicable_Taxes__c appTax = TestUtil.createApplicableTax(true, defaultSalesTax.Id, salesTaxItem.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', priceLevel.Id, null);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 50);
        
        Test.startTest();
        insert coLineItem;
        Test.stopTest();
        
        List<CO_Line_Item__c> coLineItemList = [select Retail__c, Price__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Retail__c, 9);
        system.assertEquals(coLineItemList[0].Price__c, 9);
    }
    
    static testMethod void defaultSalesTaxCalculation() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem = TestUtil.createSalesTaxItem(true, 'Test Item', 8.0, 'Testing ', true, testCategory.Id);
    	Applicable_Taxes__c appTax = TestUtil.createApplicableTax(true, defaultSalesTax.Id, salesTaxItem.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, null);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Applicable_Tax__c = defaultSalesTax.Id;
        insert part;
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 50);
        Test.startTest();
        insert coLineItem;
        Test.stopTest();
        
        List<CO_Line_Item__c> coLineItemList = [select Tax__c From CO_Line_Item__c where Id = :coLineItem.Id];
        //system.assert(false, coLineItemList);
        system.assertEquals(coLineItemList[0].Tax__c, 8);
    }
   
    static testMethod void salesTaxCalculation() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax1', true, true, true);
    	Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, false, true);
    	
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test Item1', 10.0, 'Testing ', true, testCategory.Id);
    	Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test Item2', 5.0, 'Testing ', true, testCategory.Id, false);
    	Applicable_Taxes__c appTax1 = TestUtil.createApplicableTax(true, salesTax.Id, salesTaxItem1.Id);
    	Applicable_Taxes__c appTax2 = TestUtil.createApplicableTax(true, salesTax.Id, salesTaxItem2.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, salesTax.Id);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        part.Applicable_Tax__c = SalesTax.Id;
        insert part;
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 50);
        COLineItemTriggerHelper.isTriggerExecute = false;
        Test.startTest();
        update coLineItem;
        system.debug(+ coLineItem);
        Test.stopTest();
        
        //List<CO_Line_Item__c> coLineItemList = [select Tax__c From CO_Line_Item__c where Id = :coLineItem.Id];
        //system.assertEquals(coLineItemList[0].Tax__c, 10);
        
        
        
        //COLineItemTriggerHelper.isTriggerExecute = false;
        //system.assert(false, coLineItem);
        List<CO_Line_Item__c> coLineItemList = [select Tax__c From CO_Line_Item__c where Id = :coLineItem.Id];
        //system.debug('$$$$$$ ' + coLineItemList);
        system.assertEquals(coLineItemList[0].Tax__c, 15);
    }
    
    static testMethod void qtyCommittedLogicTest() {
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax1', true, true, true);
    	Sales_Tax__c salesTax = TestUtil.createSalesTax(true, 'Test Sales Tax2', true, false, true);
    	
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test Item1', 10.0, 'Testing ', true, testCategory.Id);
    	Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test Item2', 5.0, 'Testing ', true, testCategory.Id, false);
    	Applicable_Taxes__c appTax1 = TestUtil.createApplicableTax(true, salesTax.Id, salesTaxItem1.Id);
    	Applicable_Taxes__c appTax2 = TestUtil.createApplicableTax(true, salesTax.Id, salesTaxItem2.Id);
    	
    	Account customer = TestUtil.createCustomer(true, 'Test Cust', 'a@b.c', 'Jaipur', '1800111265', null, salesTax.Id);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(false, coHeader.Id, part.Id, 50);
        
        Test.startTest();
        insert coLineItem;
        Test.stopTest();
        
        List<CO_Line_Item__c> coLineItemList = [select Qty_Committed__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Qty_Committed__c, 50);
        
        List<Part__c> partList = [select Qty_In_Stock__c, Qty_Committed__c from Part__c where Id =: part.Id ];
        system.assertEquals(partList[0].Qty_Committed__c, 50);
        system.assertEquals(partList[0].Qty_In_Stock__c, 100);
        
        COLineItemTriggerHelper.isTriggerExecute = false;
        coLineItem.Qty__c = 120;
        update coLineItem;
        
        
        /*coLineItemList = [select Qty_Committed__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Qty_Committed__c, 100);
        
        partList = [select Qty_In_Stock__c, Qty_Committed__c from Part__c where Id =: part.Id ];
        system.assertEquals(partList[0].Qty_Committed__c, 100);
        
        COLineItemTriggerHelper.isTriggerExecute = false;
        coLineItem.Qty__c = 130;
        try{
        	update coLineItem;
        } catch(Exception e) {
        	system.assertEquals(BlackPurlException.getErrorMessage(e.getMessage(), '') , 'Validation Error :  Quantity Out of Stock');
        }
        
        COLineItemTriggerHelper.isTriggerExecute = false;
        coLineItem.Qty__c = 80;
        update coLineItem;
        
        coLineItemList = [select Qty_Committed__c From CO_Line_Item__c where Id = :coLineItem.Id];
        system.assertEquals(coLineItemList[0].Qty_Committed__c, 80);
        
        partList = [select Qty_In_Stock__c, Qty_Committed__c from Part__c where Id =: part.Id ];
        system.assertEquals(partList[0].Qty_Committed__c, 80);
        system.assertEquals(partList[0].Qty_In_Stock__c, 100);*/
    }
}