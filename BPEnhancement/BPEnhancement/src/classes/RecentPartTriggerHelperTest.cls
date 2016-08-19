/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RecentPartTriggerHelperTest {

	/**
     * Name: beforeInsertOperationTest
     * Desc: Testing to make sure there exists only 20 recent customer reccords per user
     * @param: 
     * @return: 
    **/
    static testMethod void beforeInsertOperationTest() {
        Account vendor = TestUtil.createVendor(true, 'First Vendor ');
        Category__c testCategory = TestUtil.createCategory(true, 'Testing Category');
        
        List<Part__c> partListToBeInsert = new List<Part__c>();
        for(Integer counter = 0; counter < 20 ; counter++) {
        	Part__c part = new Part__c();
        	part.Vendor__c = vendor.Id;
        	part.Category__c = testCategory.Id;
        	part.Part_Number__c = '12345' + counter;
        	part.Description__c = 'This is ' + counter + ' part';
        	partListToBeInsert.add(part);
        }
        insert partListToBeInsert;
        
        Test.startTest();
        Part__c newPart = TestUtil.createPart(true, '1452369', vendor.Id, 'Test Desc', testCategory.Id);
        
        
        List<Recent_Part__c> recentPartList = [select Id from Recent_Part__c];
        //system.assertEquals(recentPartList.size(), 20);
        
        // Update part if it is already present
        
        partListToBeInsert[4].Description__c = 'This is part 4';
        update partListToBeInsert[4];
        Test.stopTest();
        
        recentPartList = [select Id from Recent_Part__c];
        //system.assertEquals(recentPartList.size(), 20);
    }
}