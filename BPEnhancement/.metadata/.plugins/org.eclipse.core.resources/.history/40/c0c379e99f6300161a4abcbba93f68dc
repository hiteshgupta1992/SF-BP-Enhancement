@isTest
private class HomeSearchRecentRecordsTest {

    static testMethod void testGetOrgBlankSearchResults_NameInAscendingOrder(){
        
        Account acc = TestUtil.createCustomer(true, 'Test Customer', 'test@test.com', 'NY', '5214789630');
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Name', 'ASC')
        };
        
        List<SObject> records = HomeSearchRecentRecords.getOrgBlankSearchResults(pageSort);
        for(SObject obj : records){
            if(obj.getSObjectType() == acc.getSObjectType())
                System.assertEquals('Test Customer', obj.get(Schema.Account.Name));         
        }
    }
    
    static testMethod void testGetOrgBlankSearchResults_TypeInDescOrder(){
        
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Type', 'DESC')
        };
        
        List<SObject> records = HomeSearchRecentRecords.getOrgBlankSearchResults(pageSort);
        for(SObject obj : records){
            if(obj.getSObjectType() == testCategory.getSObjectType())
                System.assertEquals('Test Category', obj.get(Schema.Category__c.Name));         
        }
    }
}