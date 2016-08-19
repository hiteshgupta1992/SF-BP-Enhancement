/**
* Author: Durga Singh
* Since: Nov 26, 2015
* Name: ViewLabourCtrlTest
* Description: Apex class which contains all remoted test methods related to View Labour page
**/
@isTest
private class ViewLabourCtrlTest {

    @testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
    
    static testMethod void getLabourDetailsTest() {
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
    	
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	
    	String labourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getLabourDetails(BPUtility.getEncodedString(labourCode.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewLabourCtrl.LabourHeaderWrapper labourCodeDetails = (ViewLabourCtrl.LabourHeaderWrapper) System.JSON.deserialize(labourDetails, ViewLabourCtrl.LabourHeaderWrapper.class);
    	//System.assert(False, labourCodeDetails);
    	System.assertEquals(labourCodeDetails.LabourRecord.LabourCode, 'Code');
    }
    
        static testMethod void SaveLabourTest() {
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour', 'Labour', 'Description', true, true);
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	String labourDetails = BPUtility.getDecodedString(ViewLabourCtrl.saveLabour(BPUtility.getEncodedString('[{"LabourCategory":{"Id":"'+testcategory.Id+'","Name":"labour"},"LabourCode":"Code","LabourDescription":"Description","LabourHours":"10.0","LabourFixedRate":true,"LabourRate":"10.00","LabourCategoryId":"a01o000000547kMAAQ","LabourCategoryName":"Labour_A1_Category","LabourTaxable":true}]')));
		String labourDetails1 = BPUtility.getDecodedString(ViewLabourCtrl.getLabourDetails(BPUtility.getEncodedString(labourDetails), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewLabourCtrl.LabourHeaderWrapper labourCodeDetails2 = (ViewLabourCtrl.LabourHeaderWrapper) System.JSON.deserialize(labourDetails1, ViewLabourCtrl.LabourHeaderWrapper.class);
    	System.assertEquals(labourCodeDetails2.LabourRecord.LabourCode, 'Code');
    }
    
	static testMethod void getSimilarRecordsDetailsTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code1', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Labour_Code__c labourCode1 = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description1', True, 11, 'LabourCodeName', 11, true);
    	
    	String similarlabourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getSimilarLabourRecords(BPUtility.getEncodedString('Code1'), BPUtility.getEncodedString('Description1')));
    	List<LabourRecord> labourCodeDetails = (List<LabourRecord>) System.JSON.deserialize(similarlabourDetails, List<LabourRecord>.class);
    	System.assertEquals(labourCodeDetails.size(), 2);
    }
    
    static testMethod void getSimilarRecordsDetailsForCodeTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code1', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Labour_Code__c labourCode1 = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description1', True, 11, 'LabourCodeName', 11, true);
    	
    	String similarlabourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getSimilarLabourRecords(BPUtility.getEncodedString('Code1'), BPUtility.getEncodedString('NoDescription')));
    	List<LabourRecord> labourCodeDetails = (List<LabourRecord>) System.JSON.deserialize(similarlabourDetails, List<LabourRecord>.class);
    	System.assertEquals(labourCodeDetails.size(), 1);
    }
    
        static testMethod void getSimilarRecordsDetailsForDescriptionTest() {
    	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code1', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
    	Labour_Code__c labourCode1 = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description1', True, 11, 'LabourCodeName', 11, true);
    	
    	String similarlabourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getSimilarLabourRecords(BPUtility.getEncodedString('NoCode'), BPUtility.getEncodedString('Description')));
    	List<LabourRecord> labourCodeDetails = (List<LabourRecord>) System.JSON.deserialize(similarlabourDetails, List<LabourRecord>.class);
    	System.assertEquals(labourCodeDetails.size(), 2);
    }
    
static testMethod void ActiveOrderListForLabour() {
			
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
    	Transaction_Type__c transactionType = TestUtil.createTransactionType(true, 'Code', 'Customer');
    	
    	String soHeader = BPUtility.getDecodedString(CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id)));
        String SOHeaderDetails = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null)));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = BPUtility.getDecodedString(CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(labourCode.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(customer.Id)));
    	String SOHeaderDetails1 = BPUtility.getDecodedString(CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), null));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        //system.assert(false, soHeaderDetailsObj1);
    	String labourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getLabourDetails(BPUtility.getEncodedString(labourCode.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
    	ViewLabourCtrl.LabourHeaderWrapper labourCodeDetails = (ViewLabourCtrl.LabourHeaderWrapper) System.JSON.deserialize(labourDetails, ViewLabourCtrl.LabourHeaderWrapper.class);
		system.assertEquals(labourCodeDetails.TotalActiveOrder, 1);
}

   	    static testMethod void getDefaultLabourDataTest() {
    	
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Category__c testCategory1 = TestUtil.createCategory(true, 'categoryName', 'Labour', 'categoryDescription', true, true);
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Fee__c fee = TestUtil.createFee(True, True, testCategory1.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
    	String labourDetails = BPUtility.getDecodedString(ViewLabourCtrl.getDefaultLabourData());
    	system.assertEquals(labourDetails.contains('categoryName'), true);
    }
}