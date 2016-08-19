/**
* Author: Durga Singh
* Since: Dec 11, 2015
* Name: ViewFeeCtrltest
* Description: Apex Test class which contains all remoted test methods related to View fee page
**/
@isTest
private class ViewFeeCtrltest {

    @testSetup
	private static void setupTestData() {
		TestUtil.createNameSpaceInGeneralConfig();
	}
    
    static testMethod void getFeeDetailsTest() {
    	
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
    	Fee__c fee = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
    	String feeDetails = ViewFeeCtrl.getFeeDetails(BPUtility.getEncodedString(fee.Id), BPUtility.getEncodedString('lineitems'),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
    	ViewFeeCtrl.FeeWrapper FeeDetailsFetch = (ViewFeeCtrl.FeeWrapper) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), ViewFeeCtrl.FeeWrapper.class);
    	//system.assert(false, FeeDetailsFetch);
    	system.assertEquals(FeeDetailsFetch.FeeRec.Code,'FeeCode' );
    }
     
     static testMethod void getSimilarFeesTest() {
     	
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
    	
    	Fee__c fee1 = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode1', CoHeader.Id, 'Description123', 100, True);
    	Fee__c fee2 = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description23456', 110, True);
    	
    	String feeDetails = ViewFeeCtrl.getFeeDetails(BPUtility.getEncodedString(fee1.Id), BPUtility.getEncodedString('lineitems'), BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
    	ViewFeeCtrl.FeeWrapper FeeDetailsFetch = (ViewFeeCtrl.FeeWrapper) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), ViewFeeCtrl.FeeWrapper.class);
    	
    	FeeDetailsFetch.FeeRec.Code = 'FeeCode';
    	String feeJSON = System.JSON.serialize(FeeDetailsFetch.FeeRec);
    	//system.assert(false, feeJSON);
    	String similarFeeJSON = ViewFeeCtrl.getSimilarFees(BPUtility.getEncodedString(feeJSON));
    	
    	List<FeeSuggestion> similarFeeDetailsFetch = (List<FeeSuggestion>) System.JSON.deserialize(BPUtility.getDecodedString(similarFeeJSON), List<FeeSuggestion>.class);
    	
    	system.assertEquals(similarFeeDetailsFetch[0].Code,'FeeCode');
    	system.assertEquals(similarFeeDetailsFetch[0].Description,'Description23456');
     }
     
        static testMethod void saveFeeTest() {
        	
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
    	//Fee__c fee = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
    	String feeDetails = ViewFeeCtrl.saveFee(BPUtility.getEncodedString('{"IsTaxable":true,"IsActive":true,"CategoryId":"'+testCategory.Id+'","CategoryName":"Misc Category 1","Code":"code","Description":"Description","Price":"23.00"}'),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
    	ViewFeeCtrl.FeeWrapper FeeDetailsFetch = (ViewFeeCtrl.FeeWrapper) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), ViewFeeCtrl.FeeWrapper.class);
    	//system.assert(false, FeeDetailsFetch);
    	system.assertEquals(FeeDetailsFetch.FeeRec.Code,'code' );
    }
     
        static testMethod void getSimilarFeesOnDescTest() {
     	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	Fee__c fee1 = TestUtil.createFee(True, True, testCategory.Id, 'test1', CoHeader.Id, 'Description', 100, True);
    	Fee__c fee2 = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 110, True);
    	
		String SimilarFee = ViewFeeCtrl.getSimilarFees(BPUtility.getEncodedString('{"IsTaxable":false,"IsActive":true,"CategoryId":"'+testCategory.Id+'","CategoryName":"Labour","Code":"ABCD","Description":"desc"}'));
    	List<FeeSuggestion> similarFeeDetailsFetch = (List<FeeSuggestion>) System.JSON.deserialize(BPUtility.getDecodedString(SimilarFee), List<FeeSuggestion>.class);
    	//System.assert(false, FeeDetailsFetch);
    	System.assertEquals(similarFeeDetailsFetch.size(), 2);
     }
     
        static testMethod void getfeeSuggestionListLimitTest() {
     	Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	
    	Fee__c fee1 = TestUtil.createFee(True, True, testCategory.Id, 'test1', CoHeader.Id, 'Description', 100, True);
    	Fee__c fee2 = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 110, True);
    	Fee__c fee3 = TestUtil.createFee(True, True, testCategory.Id, 'Fee1', CoHeader.Id, 'Description', 120, True);
    	Fee__c fee4 = TestUtil.createFee(True, True, testCategory.Id, 'Fee2', CoHeader.Id, 'Description', 130, True);
        Fee__c fee5 = TestUtil.createFee(True, True, testCategory.Id, 'Fee3', CoHeader.Id, 'Description', 140, True);
    	Fee__c fee6 = TestUtil.createFee(True, True, testCategory.Id, 'Fee4', CoHeader.Id, 'Description', 150, True);
        Fee__c fee7 = TestUtil.createFee(True, True, testCategory.Id, 'Fee5', CoHeader.Id, 'Description', 160, True);
    	Fee__c fee8 = TestUtil.createFee(True, True, testCategory.Id, 'Fee6', CoHeader.Id, 'Description', 170, True);
        Fee__c fee9 = TestUtil.createFee(True, True, testCategory.Id, 'Fee7', CoHeader.Id, 'Description', 180, True);
    	Fee__c fee10 = TestUtil.createFee(True, True, testCategory.Id, 'Fee8', CoHeader.Id, 'Description', 190, True);
        Fee__c fee11 = TestUtil.createFee(True, True, testCategory.Id, 'Fee9', CoHeader.Id, 'Description', 200, True);
    	Fee__c fee12 = TestUtil.createFee(True, True, testCategory.Id, 'Fee10', CoHeader.Id, 'Description', 210, True);
        Fee__c fee13 = TestUtil.createFee(True, True, testCategory.Id, 'Fee11', CoHeader.Id, 'Description', 220, True);
    	Fee__c fee14 = TestUtil.createFee(True, True, testCategory.Id, 'Fee12', CoHeader.Id, 'Description', 230, True);
        Fee__c fee15 = TestUtil.createFee(True, True, testCategory.Id, 'Fee13', CoHeader.Id, 'Description', 240, True);
    	Fee__c fee16 = TestUtil.createFee(True, True, testCategory.Id, 'Fee14', CoHeader.Id, 'Description', 250, True);
    	
    	String SimilarFee = ViewFeeCtrl.getSimilarFees(BPUtility.getEncodedString('{"IsTaxable":false,"IsActive":true,"CategoryId":"'+testCategory.Id+'","CategoryName":"Labour","Code":"ABCD","Description":"desc"}'));
    	List<FeeSuggestion> similarFeeDetailsFetch = (List<FeeSuggestion>) System.JSON.deserialize(BPUtility.getDecodedString(SimilarFee), List<FeeSuggestion>.class);
    	//System.assert(false, similarFeeDetailsFetch);
    	System.assertEquals(similarFeeDetailsFetch.size(), 15);
    	
      }
      
         	    /*
    * Name: getPaginatedRecords
     * Desc: Test to fetch active order list for fee
     * @param: 
     * @return: 
    **/
     static testMethod void getPaginatedActiveRecords() {
     	
     	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Name', 'ASC')};
        
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(false, customer.Id);
        coHeader.Order_status__c = 'Open';
        insert coHeader;
        
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
    	Fee__c fee1 = TestUtil.createFee(True, True, testCategory.Id, 'test1', CoHeader.Id, 'Description', 100, True);
    	String soHeader = CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id));
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id),BPUtility.getEncodedString(null));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(BPUtility.getDecodedString(SOHeaderDetails), SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = CustomerOrderCtrl.addLineItems(BPUtility.getEncodedString(fee1.Id), BPUtility.getEncodedString(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id), BPUtility.getEncodedString(coHeader.Id),BPUtility.getEncodedString(customer.Id));
        list<service_order_line_item__c> soh = [select id, fee__C from service_order_line_item__c];
    	String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(BPUtility.getDecodedString(SOHeaderDetails1), SOHeaderWrapper.class);
       	String feeDetails = ViewFeeCtrl.getFeeDetails(BPUtility.getEncodedString(fee1.Id), BPUtility.getEncodedString('activeorder'), BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
    	ViewFeeCtrl.FeeWrapper FeeDetailsFetch = (ViewFeeCtrl.FeeWrapper) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), ViewFeeCtrl.FeeWrapper.class);
    	system.assertEquals(FeeDetailsFetch.TotalActiveOrder, 1);
   	}
   	
   	    static testMethod void getDefaultFeeDataTest() {
    	
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Item', 'ASC')};
        
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Labour');
    	Category__c testCategory1 = TestUtil.createCategory(true, 'categoryName', 'Fee', 'categoryDescription', true, true);
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
    	Account customer = 	TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true,'Individual');
    	CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
    	Fee__c fee = TestUtil.createFee(True, True, testCategory1.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
    	String feeDetails = ViewFeeCtrl.getDefaultFeeData();
    	Category FeeDetailsFetch = (Category) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), Category.class);
    	system.assertEquals(FeeDetailsFetch.CategoryName, 'categoryName');
    }
    
             	    /*
    * Name: getPaginatedRecords
     * Desc: Test to fetch active order list for fee
     * @param: 
     * @return: 
    **/
     static testMethod void getPaginatedActiveRecordsA() {
     	
     	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<PaginationSorting.SortAttrs>{new PaginationSorting.SortAttrs('Name', 'ASC')};
        
   		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
    	
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(false, customer.Id);
        coHeader.Order_status__c = 'Open';
        insert coHeader;
        
        Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
    	Fee__c fee1 = TestUtil.createFee(True, True, testCategory.Id, 'test1', CoHeader.Id, 'Description', 100, True);
    	String soHeader = CustomerOrderCtrl.createSOHeader(BPUtility.getEncodedString(coHeader.Id));
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null));
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(BPUtility.getDecodedString(SOHeaderDetails), SOHeaderWrapper.class);
        System.assertEquals(soHeaderDetailsObj.SOList[0].SOHeaderInfo.Name, 'Service Order 1');
        
        String lineitems = CustomerOrderCtrl.insertFeeInMerchGrid(BPUtility.getEncodedString(fee1.Id), BPUtility.getEncodedString(coHeader.Id));
        list<service_order_line_item__c> soh = [select id, fee__C from service_order_line_item__c];
    	String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(BPUtility.getEncodedString(coHeader.Id), BPUtility.getEncodedString(null));
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(BPUtility.getDecodedString(SOHeaderDetails1), SOHeaderWrapper.class);
       	String feeDetails = ViewFeeCtrl.getFeeDetails(BPUtility.getEncodedString(fee1.Id), BPUtility.getEncodedString('activeorder'), BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
    	ViewFeeCtrl.FeeWrapper FeeDetailsFetch = (ViewFeeCtrl.FeeWrapper) System.JSON.deserialize(BPUtility.getDecodedString(feeDetails), ViewFeeCtrl.FeeWrapper.class);
    	system.assertEquals(FeeDetailsFetch.TotalActiveOrder, 1);
   	}
}