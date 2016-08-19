/**
 * Author: Durga Singh
 * Since: July 17, 2015
 * Name: HomeSearchpageCtrlTest
 * Description: Controller test Class of Home Search Page.
**/
@isTest
public with sharing class HomeSearchpageCtrlTest {
    /**
     * Name: saveCustomFilterJSON
     * Desc: Testing to save customFilter
     * @param: 
     * @return: 
    **/
    static testMethod void saveCustomFilterJSON() {
        String singleCustomFilterJSON = generateTestJSONForCustomFilter('part', null, false);
        //system.assert(false, singleCustomFilterJSON);
        HomeSearchPageCtrl.saveCustomFilterJSON(BPUtility.getEncodedString('filtersearch'), BPUtility.getEncodedString(null), BPUtility.getEncodedString(singleCustomFilterJSON), false);
        Test.startTest();
        List<Filter__c> Filters = [select Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c limit 1];
        Test.stopTest();
        system.assertEquals(Filters[0].Filter_Label__c, 'filtersearch');
        
        

}
/**
     * Name: deleteCustomFilterJSON
     * Desc: Testing to delete customFilter
     * @param: 
     * @return: 
    **/
   static testMethod void deleteCustomFilterJSON() {
        String singleCustomFilterJSON = generateTestJSONForCustomFilter('part', null, false);
        HomeSearchPageCtrl.saveCustomFilterJSON(BPUtility.getEncodedString('filtersearch'), BPUtility.getEncodedString(null), BPUtility.getEncodedString(singleCustomFilterJSON), false);
        Test.startTest();
        List<Filter__c> Filters = [select id, Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c];
        HomeSearchPageCtrl.deleteCustomFilter(BPUtility.getEncodedString(filters[0].id));
        Test.stopTest();
        List<Filter__c> Filters1 = [select id, Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c];
        system.assertEquals(Filters1.size(), 0);

}

/**
     * Name: renameCustomFilterJSON
     * Desc: Testing to rename customFilter
     * @param: 
     * @return: 
    **/
   static testMethod void renameCustomFilterJSON() {
        String singleCustomFilterJSON = generateTestJSONForCustomFilter('part', null, false);
        HomeSearchPageCtrl.saveCustomFilterJSON(BPUtility.getEncodedString('filtersearch'), BPUtility.getEncodedString(null), BPUtility.getEncodedString(singleCustomFilterJSON), false);
        Test.startTest();
        List<Filter__c> Filters = [select Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c ];
        HomeSearchPageCtrl.renameCustomFilter(BPUtility.getEncodedString(filters[0].id), BPUtility.getEncodedString('filtersearchNew'));
        Test.stopTest();
        List<Filter__c> Filters1 = [select id, Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c];
        system.assertEquals(Filters1[0].Filter_Label__c, 'filtersearchNew');
        }
  /**
     * Name: copyCustomFilterJSON
     * Desc: Testing to copy customFilter
     * @param: 
     * @return: 
    **/
   static testMethod void copyCustomFilterJSON() {
        String singleCustomFilterJSON = generateTestJSONForCustomFilter('part', null, false);
        //system.assert(false, singleCustomFilterJSON);
        HomeSearchPageCtrl.saveCustomFilterJSON(BPUtility.getEncodedString('filtersearch'), BPUtility.getEncodedString(null), BPUtility.getEncodedString(singleCustomFilterJSON), false);
        Test.startTest();
        List<Filter__c> Filters = [select Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c];
        HomeSearchPageCtrl.copyCustomFilter(BPUtility.getEncodedString(filters[0].id), BPUtility.getEncodedString('filtersearchcopy'));
        Test.stopTest();
        List<Filter__c> Filters1 = [select id, Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c];
        system.assertEquals(Filters1.size(), 2);
        }
        
        /**
     * Name: getFieldJSONForFilter
     * Desc: Testing to get field for customFilter
     * @param: 
     * @return: 
    **/
    static testMethod void getFieldJSONForFilter() {
        String singleCustomFilterJSON = generateTestJSONForCustomFilter('part', null, false);
        //system.assert(false, singleCustomFilterJSON);
        HomeSearchPageCtrl.saveCustomFilterJSON(BPUtility.getEncodedString('filtersearch'), BPUtility.getEncodedString(null), BPUtility.getEncodedString(singleCustomFilterJSON), false);
        Test.startTest();
        List<Filter__c> Filters = [select Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c limit 1];
        String Filters1 = BPUtility.getDecodedString(HomeSearchPageCtrl.getFieldJSONForFilter(BPUtility.getEncodedString(filters[0].id)));
        Test.stopTest();
        system.assertEquals(Filters1.contains('SearchText'), true);
        }
        
    /**
     * Name: createCustomerOrderTest
     * Desc: Testing to createcustomer order
     * @param: 
     * @return: 
    **/
    static testmethod void createCustomerOrderTest(){
        HomeSearchPageCtrl.createCustomerOrder();
        List<CO_Header__c> CustomerorderHeader = [select Id from CO_Header__c];
        system.assertEquals(CustomerorderHeader.size(), 1);
        
    }
    
    /**
     * Name: createVendorOrderTest
     * Desc: Testing to create vendor Order
     * @param: 
     * @return: 
    **/
    static testmethod void createVendorOrderTest(){
        HomeSearchPageCtrl.createVendorOrder();
        List<Vendor_Order_Header__c> vendorOrderHeader = [select Id from Vendor_Order_Header__c];
        system.assertEquals(vendorOrderHeader.size(), 1);
        
    }
    
        /**
     * Name: createVOReceivingTest
     * Desc: Testing to create VOReceiving
     * @param: 
     * @return: 
    **/
    static testmethod void createVOReceivingTest(){
        HomeSearchPageCtrl.createVOReceiving();
        List<Vendor_Receiving_Header__c> VRHeader = [select Id from Vendor_Receiving_Header__c];
        system.assertEquals(VRHeader.size(), 1);
        
    }
    
    /**
     * Name: getOrgSearchResultsTest
     * Desc: Testing to serach data from org (part, vendor, customer, customerorder)
     * @param: 
     * @return: 
    **/
    static testmethod void getFilterSearchResultTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        List<Id> fixedSearchResults= new List<Id>{part.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        
        String JSONString = BPUtility.getDecodedString(HomeSearchPageCtrl.getFilterSearchResult( BPUtility.getEncodedString(''), BPUtility.getEncodedString('[{"PageSize":50,"PageNumber":1,"SearchText":"Test","SortBy":[]}]')));
        system.assertEquals(JSONString.contains('Test Vendor'), true );
        
    }
    
        /**
     * Name: getOrgSearchResultsForPartTest
     * Desc: Testing to serach only part data from org 
     * @param: 
     * @return: 
    **/
    static testmethod void getFilterSearchResultForPartTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        List<Id> fixedSearchResults= new List<Id>{part.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        String JSONString = BPUtility.getDecodedString(HomeSearchPageCtrl.getFilterSearchResult( BPUtility.getEncodedString('[{"field":"Type","operator":"eq","value":"Part"}]'), BPUtility.getEncodedString('[{"PageSize":50,"PageNumber":1,"SearchText":"test","SortBy":[]}]')));
        //system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('TestPart'), false);
        //system.assertEquals(JSONString.contains('TestPart'), true);
        
    }
    
            /**
     * Name: getOrgSearchResultsForCategoryTest
     * Desc: Testing to serach only category data from org 
     * @param: 
     * @return: 
    **/
   /* static testmethod void getFilterSearchResultForCategoryTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
        List<Id> fixedSearchResults= new List<Id>{testCategory.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        String JSONString = HomeSearchPageCtrl.getFilterSearchResult( '[{"field":"Type","operator":"eq","value":"Category"}]', '[{"PageSize":50,"PageNumber":1,"SearchText":"test","SortBy":[]}]');
        //system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('Test Category'), false );
        
    }*/
    
                /**
     * Name: getOrgSearchResultsForCustomerTest
     * Desc: Testing to serach only customer data from org 
     * @param: 
     * @return: 
    **/
    static testmethod void getFilterSearchResultForCustomerTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        
        List<Id> fixedSearchResults= new List<Id>{customer.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        String JSONString = BPUtility.getDecodedString(HomeSearchPageCtrl.getFilterSearchResult( BPUtility.getEncodedString('[{"field":"Type","operator":"eq","value":"Customer"}]'), BPUtility.getEncodedString('[{"PageSize":50,"PageNumber":1,"SearchText":"customer","SortBy":[]}]')));
        //system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('customerName'), true );
        
    }
    
                    /**
     * Name: getOrgSearchResultsForVendorTest
     * Desc: Testing to serach only vendor data from org 
     * @param: 
     * @return: 
    **/
    static testmethod void getFilterSearchResultForVendorTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        
        List<Id> fixedSearchResults= new List<Id>{vendor.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        String JSONString = BPUtility.getDecodedString(HomeSearchPageCtrl.getFilterSearchResult( BPUtility.getEncodedString('[{"field":"Type","operator":"eq","value":"Vendor"}]'), BPUtility.getEncodedString('[{"PageSize":50,"PageNumber":1,"SearchText":"customer","SortBy":[]}]')));
        //system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('Test Vendor'), true );
        
    }
    
                        /**
     * Name: getOrgSearchResultsForFeesTest
     * Desc: Testing to serach only fee data from org 
     * @param: 
     * @return: 
    **/
   /* static testmethod void getFilterSearchResultForFeesTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Fee__c fee = TestUtil.createFee(True, True, testCategory.Id, 'FeeCode', CoHeader.Id, 'Description', 100, True);
        List<Id> fixedSearchResults= new List<Id>{fee.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        String JSONString = HomeSearchPageCtrl.getFilterSearchResult( '[{"field":"Type","operator":"eq","value":"Fee"}]', '[{"PageSize":50,"PageNumber":1,"SearchText":"","SortBy":[]}]');
        system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('Test Vendor'), true );
        
    }*/
    
    
        /**
     * Name: getOrgSearchResultsTest
     * Desc: Testing to serach data from org (part, vendor, customer, customerorder)
     * @param: 
     * @return: 
    **/
    static testmethod void getOrgSearchResultsTest(){
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(true, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
        
       /* List<Id> fixedSearchResults= new List<Id>{part.Id, vendor.Id};
        Test.setFixedSearchResults(fixedSearchResults);*/
        
        String JSONString = BPUtility.getDecodedString(HomeSearchPageCtrl.getOrgSearchResults(BPUtility.getEncodedString('test'), 10, 10));
        
        //system.assert(false, JSONString );
        system.assertEquals(JSONString.contains('Records'), true );
        
    }
  
  
  
  private static String generateTestJSONForCustomFilter(String searchStr, String objectName, boolean isObjectAdded)
  {
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        if (isObjectAdded){
          gen.writeStringField('Object', objectName);   
        }
        gen.writeStringField('SearchText', searchStr);
        gen.writeFieldName('DisplayedColumns');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('columnName', 'T');
        gen.writeStringField('type', 'icon');
        gen.writeEndObject();
        gen.writeStartObject();
        gen.writeStringField('columnName', 'Status');
        gen.writeStringField('type', 'boolean');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeFieldName('Filters');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('field', 'Type');
        gen.writeStringField('operator', 'eq');
        gen.writeStringField('value', 'Category');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndArray();
        return gen.getAsString();
    }
}