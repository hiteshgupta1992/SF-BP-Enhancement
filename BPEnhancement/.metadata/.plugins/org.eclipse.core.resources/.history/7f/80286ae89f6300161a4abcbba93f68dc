@isTest
private class HSSObjectInstanceTest {
 // Prefix name for object fields used in JSON
    private static String CATEGORY_LIST_NAME_PREFIX = 'Cat_';
     @testSetup
    private static void setupTestData() {
        TestUtil.createNameSpaceInGeneralConfig();
    }
    static testMethod void comparableTest() {
        Category__c categoryObject1 =   TestUtil.createCategory(true, 'Test');    
        Category__c categoryObject2 =   TestUtil.createCategory(true, 'Test1');   
        List<Category__c> categoryList = new List<Category__c>();
        categoryList.add(categoryObject1);
        categoryList.add(categoryObject2);
        HSSObjectInstance  hSSObjectInstanceObject1 = new  HSSObjectInstance(categoryObject1);
        HSSObjectInstance  hSSObjectInstanceObject2 = new  HSSObjectInstance(categoryObject2);
        List<HSSObjectInstance> HSSObjectInstanceList = new List<HSSObjectInstance>{hSSObjectInstanceObject1,hSSObjectInstanceObject2};
        List<PaginationSorting.SortAttrs> sortAttrsList = new List<PaginationSorting.SortAttrs>();
        Test.startTest();
        sortAttrsList.add(new  PaginationSorting.SortAttrs('id','DESC'));
        sortAttrsList.add(new  PaginationSorting.SortAttrs('CreatedDate','DESC'));
        HomeSearchUtil.sortMapping= sortAttrsList;
        HSSObjectInstanceList.sort();
        sortAttrsList.add(new  PaginationSorting.SortAttrs('Name','ASC'));
        sortAttrsList.add(new  PaginationSorting.SortAttrs('CreatedDate','ASC'));
        HomeSearchUtil.sortMapping= sortAttrsList;
        HSSObjectInstanceList.sort();
        sortAttrsList.clear();
        sortAttrsList.add(new  PaginationSorting.SortAttrs(Constants.NAMESPACE + 'Status__c','ASC'));
        sortAttrsList.add(new  PaginationSorting.SortAttrs(Constants.NAMESPACE + 'Type__c','ASC'));
        sortAttrsList.add(new  PaginationSorting.SortAttrs('Owner.id','ASC'));
        HSSObjectInstanceList.sort();
        Test.stopTest();
        System.assertEquals(sortAttrsList.size(),3);
    }
}