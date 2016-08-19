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
 //commented because recent parts are discarded now.
@isTest
private class PartTriggerHelperTest {
	
	/**
     * Name: partInsertOperationTest
     * Desc: Testing of reccent part record when part are created
     * @param: 
     * @return: 
    **/
  /*  static testMethod void partInsertOperationTest() {
        Account vendor = TestUtil.createVendor(true, 'First Vendor ');
        Category__c testCategory = TestUtil.createCategory(true, 'Testing Category');
        
        Test.startTest();
        Part__c testPart1 = TestUtil.createPart(true, '1452369', vendor.Id, 'Test Desc', testCategory.Id);
        Part__c testPart2 = TestUtil.createPart(true, '1452369ds', vendor.Id, 'Test Desc', testCategory.Id);
        Test.stopTest();
        
        List<Recent_Part__c> reccentParts = [select Id from Recent_Part__c];
        system.assertEquals(reccentParts.size(), 2);
    }
    */
    /**
     * Name: PartUpdateOperationTest
     * Desc: Testing of reccent Part record when Part record is updated
     * @param: 
     * @return: 
    **/
   /* static testMethod void PartUpdateOperationTest() {
        Account vendor = TestUtil.createVendor(true, 'First Vendor ');
        Category__c testCategory = TestUtil.createCategory(true, 'Testing Category');
        
        Part__c testPart1 = TestUtil.createPart(true, '1452369', vendor.Id, 'Test Desc', testCategory.Id);
        Part__c testPart2 = TestUtil.createPart(true, '145236912', vendor.Id, 'Test Desc', testCategory.Id);
        
        Test.startTest();
        testPart2.Description__c = 'C-153, Near Railway Station';
        update testPart2;
        Test.stopTest();
        
       List<Recent_Part__c> reccentParts = [select Id from Recent_Part__c];
       //List<Part__c> reccentParts = [select Id from Part__c];
        system.assertEquals(reccentParts.size(), 2);
    }
    */
    /**
     * Name: PartDeleteOperationTest
     * Desc: Testing of reccent Part record when Part record is deleted
     * @param: 
     * @return: 
    **/
   /* static testMethod void PartDeleteOperationTest() {
        Account vendor = TestUtil.createVendor(true, 'First Vendor ');
        Category__c testCategory = TestUtil.createCategory(true, 'Testing Category');
        
        Part__c testPart1 = TestUtil.createPart(true, '14523692', vendor.Id, 'Test Desc', testCategory.Id);
        Part__c testPart2 = TestUtil.createPart(true, '145236912', vendor.Id, 'Test Desc', testCategory.Id);
        
        Test.startTest();
        delete testPart2;
        Test.stopTest();
        
        List<Recent_Part__c> reccentParts = [select Id from Recent_Part__c];
        system.assertEquals(reccentParts.size(), 1);
    }*/
}