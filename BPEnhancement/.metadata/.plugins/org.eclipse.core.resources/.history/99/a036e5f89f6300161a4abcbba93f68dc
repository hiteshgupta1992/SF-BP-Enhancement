/**
* Author: Durga Singh
* Since: Nov 27, 2015
* Name: ViewLabourCtrlTest
* Description: Apex Test class which contains all remoted test methods related to View Kit page
**/
@isTest
private class ViewKitCtrlTest {
	
	@testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
	
	
    static testMethod void getKitDetailsTest() {
    	
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
    	
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('lineitems'), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.KitHeaderLineItemList[0].ReatilPrice, 100);
    	System.assertEquals(kitDetails.KitHeaderRec.CanItSplit, true);
    }
    
        static testMethod void getKitDetailsWithNullGridNameTest() {
        	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(null), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.KitHeaderLineItemList[0].ReatilPrice, 100);
    	System.assertEquals(kitDetails.KitHeaderRec.CanItSplit, true);
    }
    
        static testMethod void saveKitHeaderTest() {
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	//Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	//Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.saveKitHeader(BPUtility.getEncodedString('{"CanItSplit":true,"IsActive":true,"Code":"code","Description":"description","Concern":[],"Correction":[],"Cause":[],"TransactionTypeList":[{"TTName":"Code","Id":"'+transactiontype.Id+'"}],"IsServiceKit":true,"MakeId":"'+unitMake.Id+'","ModelId":"'+unitModel.Id+'","SubModelId":"'+unitModel.Id+'"}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.KitHeaderRec.TransactionTypeList[0].TTName, 'Code');
    	System.assertEquals(kitDetails.KitHeaderRec.CanItSplit, true);
    	System.assertEquals(kitDetails.KitHeaderRec.MakeName, 'unitMakeName');
    	
    }
    
        static testMethod void getSimilarKitsTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header__c kitHeader1 = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code1', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String similarKitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getSimilarKits(BPUtility.getEncodedString('{"CanItSplit":false,"IsActive":true,"Code":"code","Description":"Description","Concern":[],"Correction":[],"Cause":[]}')));
    	List<KitHeaderSuggestion> kitDetails = (List<KitHeaderSuggestion>) System.JSON.deserialize(similarKitHeaderDetails, List<KitHeaderSuggestion>.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.size(), 2);
    	//System.assertEquals(kitDetails.KitHeaderRec.CanItSplit, true);
    	//System.assertEquals(kitDetails.KitHeaderRec.MakeName, 'unitMakeName');
    	
    }
    
        static testMethod void getSimilarKitsOnCodeTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'test 1', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header__c kitHeader1 = TestUtil.createKitHeader(true, true, true, 'Cause', 'test1', 'Concern', 'Correction', 'test 2', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String similarKitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getSimilarKits(BPUtility.getEncodedString('{"CanItSplit":false,"IsActive":true,"Code":"code","Description":"Description","Concern":[],"Correction":[],"Cause":[]}')));
    	List<KitHeaderSuggestion> kitDetails = (List<KitHeaderSuggestion>) System.JSON.deserialize(similarKitHeaderDetails, List<KitHeaderSuggestion>.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.size(), 1);
    }
    
        static testMethod void getSimilarKitsOnDescTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 1, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'test1', 'Concern', 'Correction', 'test1', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header__c kitHeader1 = TestUtil.createKitHeader(true, true, true, 'Cause', 'test2', 'Concern', 'Correction', 'Description2', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String similarKitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getSimilarKits(BPUtility.getEncodedString('{"CanItSplit":false,"IsActive":true,"Code":"code","Description":"Description","Concern":[],"Correction":[],"Cause":[]}')));
    	List<KitHeaderSuggestion> kitDetails = (List<KitHeaderSuggestion>) System.JSON.deserialize(similarKitHeaderDetails, List<KitHeaderSuggestion>.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.size(), 1);
    	
    }
    
        static testMethod void ValidationOnUpdateKitLineItemTest() {
        	
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 50, 50, 100, 100);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	//Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	String kitHeaderLineItem = BPUtility.getDecodedString(ViewKitCtrl.insertKitLineItem(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('lineitems'), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	String kitHeaderDetails1 = BPUtility.getDecodedString(ViewKitCtrl.updateKitLineItem(BPUtility.getEncodedString('{"TotalPrice":50,"Status":"Out of Stock","ReatilPrice":20,"QtyNeeded":1,"KitPrice":"60","ItemDesc":"00123VEN187 - newpart","IsFixedPrice":true,"Id":"'+kitDetails.KitHeaderLineItemList[0].Id+'","AvailableParts":0,"$$hashKey":"object:162"}'),BPUtility.getEncodedString( kitHeader.Id), BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails1 = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails1, ViewKitCtrl.KitHeaderWrapper.class);
    	
    	System.assertEquals(kitDetails1.ResponseDetails.ResponseMeassage, 'Line Item total price exceeded from Kit Header price');
    	
}

        static testMethod void ValidationForLesserPriceOnUpdateKitLineItemTest() {
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	//Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	String kitHeaderLineItem = BPUtility.getDecodedString(ViewKitCtrl.insertKitLineItem(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(part.Id), BPUtility.getEncodedString( '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('lineitems'), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	String kitHeaderDetails1 = BPUtility.getDecodedString(ViewKitCtrl.updateKitLineItem(BPUtility.getEncodedString('{"TotalPrice":3,"Status":"Out of Stock","ReatilPrice":3,"QtyNeeded":1,"KitPrice":"3","ItemDesc":"00123VEN187 - newpart","IsFixedPrice":true,"Id":"'+kitDetails.KitHeaderLineItemList[0].Id+'","AvailableParts":0,"$$hashKey":"object:162"}'), BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails1 = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails1, ViewKitCtrl.KitHeaderWrapper.class);

    	System.assertEquals(kitDetails1.ResponseDetails.ResponseMeassage, 'No unfixed price line item present in kit header to adjust exceeded price');
    	
}

        static testMethod void removekitlineitemTest() {
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	String kitlineitem = BPUtility.getDecodedString(ViewKitCtrl.removeKitLineItem(BPUtility.getEncodedString(kitHeaderLineItem.Id), BPUtility.getEncodedString(kitHeader.Id),BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	
    	ViewKitCtrl.KitHeaderWrapper kitDetails1 = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitlineitem, ViewKitCtrl.KitHeaderWrapper.class);
		System.assertEquals(kitDetails1.KitHeaderLineItemList.Size(), 0 );
    }
    
        static testMethod void ValidationOnupdateKitHeaderTest() {
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	String UpdateKitHeader = BPUtility.getDecodedString(ViewKitCtrl.updateKitHeader(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('{"TransactionTypeList":[{"TTName":"Customer Pay","Id":"'+transactionType.Id+'","$$hashKey":"object:136"},{"TTName":"Warranty","Id":"'+transactionType.Id+'","$$hashKey":"object:137"},{"TTName":"Internal","Id":"'+transactionType.Id+'","$$hashKey":"object:138"}],"SubModelName":"2014","SubModelId":"'+unitModel.Id+'","RetailPrice":10,"ModelName":"Cayenne","ModelId":"'+unitModel.Id+'","MakeName":"Porsche","MakeId":"'+unitMake.Id+'","IsServiceKit":true,"IsFixedPrice":true,"IsActive":true,"Id":"'+kitHeader.Id+'","FixedPrice":"40","Description":"Tyre Puncture Kit","Correction":["Tyre puncture kit"],"Concern":["Tyre Puncture"],"Code":"KIT004","Cause":["Normal wear and tear"],"CanItSplit":true}'),BPUtility.getEncodedString( '{"ChangesCount":3,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	//String kitHeaderDetails = ViewKitCtrl.getKitDetails(kitHeader.Id, 'lineitems', null, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}');
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(UpdateKitHeader, ViewKitCtrl.KitHeaderWrapper.class);
    	System.assertEquals(kitDetails.ResponseDetails.ResponseMeassage, 'Kit Header total price should be greater than or equal to Total of fixed price kit line items.');
}
		static testMethod void updateKitHeaderTest() {
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	Test.startTest();
    	KitHeaderTriggerHelper.PermitRun_BeforeUpdate = true;
    	KitLineItemtriggerHelper.PermitRun_BeforeInsert = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeUpdate = true;
	    KitLineItemtriggerHelper.PermitRun_BeforeDelete = true;
	    
    	String UpdateKitHeader = BPUtility.getDecodedString(ViewKitCtrl.updateKitHeader(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('{"TransactionTypeList":[{"TTName":"Customer Pay","Id":"'+transactionType.Id+'","$$hashKey":"object:136"},{"TTName":"Warranty","Id":"'+transactionType.Id+'","$$hashKey":"object:137"},{"TTName":"Internal","Id":"'+transactionType.Id+'","$$hashKey":"object:138"}],"SubModelName":"2014","SubModelId":"'+unitModel.Id+'","RetailPrice":10,"ModelName":"Cayenne","ModelId":"'+unitModel.Id+'","MakeName":"Porsche","MakeId":"'+unitMake.Id+'","IsServiceKit":true,"IsFixedPrice":true,"IsActive":true,"Id":"'+kitHeader.Id+'","FixedPrice":"40","Description":"Tyre Puncture Kit","Correction":["Tyre puncture kit"],"Concern":["Tyre Puncture"],"Code":"KIT004","Cause":["Normal wear and tear"],"CanItSplit":true}'), BPUtility.getEncodedString('{"ChangesCount":3,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	Test.stopTest();
    	//String kitHeaderDetails = ViewKitCtrl.getKitDetails(kitHeader.Id, 'lineitems', null, '{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}');
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(UpdateKitHeader, ViewKitCtrl.KitHeaderWrapper.class);
    	system.assertEquals(kitDetails.KitHeaderLineItemList[0].Totalprice, 40.00);
}

		static testMethod void getMasterDataForKitTest() {
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String masterData = BPUtility.getDecodedString(ViewKitCtrl.getMasterDataForKitCreation());
    	system.assertEquals(masterData.contains('unitModelName'), true);
}

		static testMethod void ActiveOrderListForKit() {
			
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(false, customer.Id);
        coHeader.Order_status__c = 'Open';
        insert coHeader;
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);
    	Kit_Header_Line_Item__c kitHeaderLineItem1 = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, null, 1000, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), null));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), null));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('activeorder'), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	//System.assert(false, kitDetails);
    	System.assertEquals(kitDetails.TotalActiveOrder, 1);
}

		static testMethod void ActiveOrderListForKitA() {
			
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(false, customer.Id);
        coHeader.Order_status__c = 'Open';
        insert coHeader;
    	Unit_Make__c unitMake = TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
    	Unit_Model__c unitModel = TestUtil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
    	
    	Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 5, 5, 5, 5, 5);
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, false, unitMake.Id, unitModel.Id);
    	Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, false, false, KitHeader.Id, 5.0, null, Part.Id, 1, 5.0);
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), null));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems =BPUtility.getDecodedString( CustomerOrderCtrl.insertKitHeaderInMerchGrid(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString(coHeader.Id)));
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), null));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
    	String kitHeaderDetails = BPUtility.getDecodedString(ViewKitCtrl.getKitDetails(BPUtility.getEncodedString(kitHeader.Id), BPUtility.getEncodedString('activeorder'), null, BPUtility.getEncodedString('{"ChangesCount":6,"CurrentPage":1,"PageSize":10,"Sorting":[{"FieldName":"LastModifiedDate","SortDirection":"DESC"}]}'), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewKitCtrl.KitHeaderWrapper kitDetails = (ViewKitCtrl.KitHeaderWrapper) System.JSON.deserialize(kitHeaderDetails, ViewKitCtrl.KitHeaderWrapper.class);
    	System.assertEquals(kitDetails.TotalActiveOrder, 1);
}

}