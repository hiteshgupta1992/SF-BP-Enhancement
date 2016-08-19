@isTest
private class PreviewGridRecordsCtrlTest {

    static testMethod void getFilterJSONDataTest() {
        Filter__c filterObject =   TestUtil.createFilter(true, 'TestFilter', 'testCategory', true, true, true);
        Test.startTest();
        String filterObjectjson = BPUtility.getDecodedString(PreviewGridRecordsCtrl.getFilterJSONData(BPUtility.getEncodedString(filterObject.id)));
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(0,filterList.size());
    }
      static testMethod void getReportDataTest() {
        Account customer = TestUtil.createCustomer(true, 'Harley', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part__c part1 = TestUtil.createPart(true, '56', vendor.Id, 'Test Part1', testCategory.Id, 10, 20, 50, 100, 100);
        List<Id> fixedSearchResults = new List<Id>{part.Id, part1.Id, customer.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        HomeSearchFilterWrapper filterWrapper = new HomeSearchFilterWrapper();
        filterWrapper.Type.objects = new Set<String>{'Parts'};
        Test.startTest();
        String reportData1 =  PreviewGridRecordsCtrl.getReportData(BPUtility.getEncodedString(System.Json.serialize(filterWrapper)), BPUtility.getEncodedString('Parts'), BPUtility.getEncodedString(null));
        Test.stopTest();
        List<Part__c> partList= [Select id from Part__c];
        System.assertEquals(2, partList.size());
      }
      
      static testmethod void deleteRawFilterDataTest(){
        Filter__c filterObject =   TestUtil.createFilter(true, 'TestFilter', 'testCategory', true, true, true);
        Test.startTest();
        PreviewGridRecordsCtrl.deleteRawFilterData(BPUtility.getEncodedString(filterObject.id));
        Test.stopTest();
        List<Filter__c> filterList = [Select id from Filter__c];
        System.assertEquals(0,filterList.size());
      }
    
}