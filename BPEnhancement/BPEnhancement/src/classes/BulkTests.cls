/**
 * Author: Durga Singh
 * Since: Sep 30, 2015
 * Name: BulkTests
 * Description: bulk tests.
**/

@isTest
private class BulkTests {

/**
     * Name: getOrgSearchResultsForPartTest
     * Desc: Testing to serach only part data from org 
     * @param: 
     * @return: 
    **/
/*static testmethod void getFilterSearchResultForPartTest(){
    	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c,Last_Cost__c, Qty_On_Order__c from Part__c];
        List<Id> fixedSearchResults= new List<Id>();
        for(Part__c p : partList){
        	fixedSearchResults.add(p.Id);
        }
        Test.setFixedSearchResults(fixedSearchResults);

    	String JSONString = HomeSearchPageCtrl.getFilterSearchResult( '[{"field":"Type","operator":"eq","value":"Part"}]', '[{"PageSize":50,"PageNumber":1,"SearchText":"test","SortBy":[]}]');
    	
    	system.assertEquals(JSONString.contains('true'), true );
    	
    }*/
    
    
 /**
     * Name: getOrgSearchResultsForCustomerTest
     * Desc: Testing to serach only customer data from org 
     * @param: 
     * @return: 
    **/
    /*static testmethod void getFilterSearchResultForCustomerTest(){
    	List<Account> customerList = [select Id from Account where Is_Customer__c = true];
    	
        //system.assert(false, customerList.size() );
        List<Id> fixedSearchResults= new List<Id>();
        for(Account a : customerList){
        	fixedSearchResults.add(a.Id);
        }
       	Test.setFixedSearchResults(fixedSearchResults);

    	//String JSONString = HomeSearchPageCtrl.getFilterSearchResult( '[{"field":"Type","operator":"eq","value":"Customer"}]', '[{"PageSize":50,"PageNumber":1,"SearchText":"customer","SortBy":[]}]');
    	//system.assert(false, JSONString );
    	//system.assertEquals(JSONString.contains('customerName'), true );
    	
    	Test.startTest();
        String searchresults = CustomerOrderCtrl.getSearchResults('{"ObjectLabel":"Customer","SearchText":"honda","PreferredObject":"Customer"}');
        Test.stopTest();
        system.assert(false, searchresults );
        system.assertEquals(searchresults.contains('Honda'), true );
    	
    }*/
    
/**
     * Name: getPartTest
     * Desc: Testing to get single part and view it among bulk part data
     * @param: 
     * @return: 
    **/    
/*static testMethod void getPartTest() {
 	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c,Last_Cost__c, Qty_On_Order__c from Part__c where name = 'P-00001264'];
    
    Test.startTest();
    String partsJSONString = ViewPartCtrl.getPartInfo(partList[0].Id);
	Test.stopTest();
   
    PartDetailWrapper partObjRec = (PartDetailWrapper) System.JSON.deserialize(partsJSONString, PartDetailWrapper.class);
   	system.assertEquals(partObjRec.PartDetailRec.QtyAvailable, 100);
    }*/
    
/**
     * Name: getCOLineItemByCOHeaderIdTest
     * Desc: Test the roll up summery field of sales tax record when appliacable tax record are inserted.
     * @param: 
     * @return: 
    **/
    /*static testMethod void getCOLineItemByCOHeaderIdTest() {
		
		List<Account> customer = [select Id from Account where name = 'honda'];
		
		List<Account> vendor = [select Id from Account where name = 'Tsst'];
		
    	CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer[0].id);
       	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c,Last_Cost__c, Qty_On_Order__c from Part__c LIMIT 90];
       	
       	List<CO_Line_Item__c> coLineItemsToInsert = new List<CO_Line_Item__c>();
       	for(Part__c part : partList){
       		coLineItemsToInsert.add(TestUtil.createCOLineItem(false, coHeader1.Id, part.Id, 50));
       	}
       	insert coLineItemsToInsert;
       	
        Test.startTest();
        String coLineItemJSON = CustomerOrderCtrl.getCOLineItemByCOHeaderId(coHeader1.Id);
        Test.stopTest();
        //system.assert(false, coLineItemJSON);
        
        List<COLineItem> coLineItems = (List<COLineItem>) System.JSON.deserialize(coLineItemJSON, List<COLineItem>.class);
        system.assertEquals(coLineItems[0].QtyCommitted, 0.000 );
    }*/

}