/**
* Author: Durga Singh
* Since: Dec 4, 2015
* Name: KitLineItemTriggerHelperTest
* Description: Apex Test class which contains all remoted test methods related recalculation logic for kit header and line item price.
**/
@isTest
private class KitLineItemTriggerHelperTest {

    static testMethod void processBeforeInsertTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(False, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 1000.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void processBeforeInsertTestA() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(False, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 100.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void processBeforeInsertTestB() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, False, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(False, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 100.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void processBeforeInsertTestC() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, False, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(False, true, false, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 1000.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void updateKitHeaderTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        //insert kitHeaderLineItem;
        kitHeader.Fixed_Price__c = 2000;
        update kitHeader;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 2000.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 2000.00 );
    }
    
        static testMethod void deleteKitHeaderTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        //insert kitHeaderLineItem;
        //kitHeader.Fixed_Price__c = 2000;
        delete kitHeader;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList.size(), 0 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList.size(), 0 );
    }
    
        static testMethod void updateKitHeaderLineItemTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
	    kitHeaderLineItem.Fixed_Price__c = false;
        Update kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 1000.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList.size(), 1 );
    }
    
        static testMethod void deleteKitHeaderLineItemTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        delete kitHeaderLineItem;
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Kit_Price__c From Kit_Header_Line_Item__c where Id = :kitHeaderLineItem.Id];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList.size(), 0 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        //system.assert(false, kitHeaderList );
        System.assertEquals(kitHeaderList.size(), 1 );
    }
    
        static testMethod void RecalcultionLogicOnNonFixedKitLineItemPriceTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 100, 100, 100);
    	Part__c part1 = TestUtil.createPart(true, '1234', vendor.Id, 'Test Par4t', testCategory.Id, 10, 50, 50, 50, 50);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(False, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part1.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem1;
        
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Item_Desc__c, Part__c, Qty_Needed__c, Retail_Price__c, Kit_Price__c, Total__c From Kit_Header_Line_Item__c];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 666.6666666666667 );
        System.assertEquals(kitHeaderLineItemList[1].Kit_Price__c, 333.33333333333335 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void RecalcultionLogicOnOneKitLineItemWithFixedPriceTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 100, 100, 100);
    	Part__c part1 = TestUtil.createPart(true, '1234', vendor.Id, 'Test Par4t', testCategory.Id, 10, 50, 50, 50, 50);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(False, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part1.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem1;
        
        Test.stopTest();
    	
    	List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Item_Desc__c, Part__c, Qty_Needed__c, Retail_Price__c, Kit_Price__c, Total__c From Kit_Header_Line_Item__c];
        //system.assert(false, kitHeaderLineItemList );
        System.assertEquals(kitHeaderLineItemList[0].Kit_Price__c, 100.00 );
        System.assertEquals(kitHeaderLineItemList[1].Kit_Price__c, 900.00 );
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 1000.00 );
    }
    
        static testMethod void RecalcultionLogicOnNonfixKitHeaderPriceTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 100, 100, 100);
    	Part__c part1 = TestUtil.createPart(true, '1234', vendor.Id, 'Test Par4t', testCategory.Id, 10, 50, 50, 50, 50);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 1000.0, false, false, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(False, true, False, KitHeader.Id, 5.0, LabourCode.Id, Part1.Id, 1, 5.0);

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem1;
        
        Test.stopTest();
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 150.00 );
    }
    
        static testMethod void RecalcultionLogicOnLesserPriceTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 100, 100, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 50, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 50.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(false, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    

    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
        insert kitHeaderLineItem;
        
        Test.stopTest();
        List<Kit_Header__c> kitHeaderList = [select Fixed_Price__c From Kit_Header__c where Id = :kitHeader.Id];
        System.assertEquals(kitHeaderList[0].Fixed_Price__c, 50.00 );
        /*List<Kit_Header_Line_Item__c> kitHeaderLineItemList = [select Item_Desc__c, Part__c, Qty_Needed__c, Retail_Price__c, Kit_Price__c, Total__c From Kit_Header_Line_Item__c];
        system.assert(false, kitHeaderLineItemList );*/
    }
}