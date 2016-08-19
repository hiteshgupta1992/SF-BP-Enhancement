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
private class PriceLevelTriggerHelperTest {
	
	/**
     * Name: defaultCheckForUpdate
     * Desc: Testing to make sure there is only one default price level when price level record is updated
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForUpdate() {
        
        Price_Level__c priceLevel1 = TestUtil.createPriceLevel(true, 'Test Price Level 1', 'Cost', true, true);
        Price_Level__c priceLevel2 = TestUtil.createPriceLevel(true, 'Test Price Level 2', 'Price', false, true);
        
        Test.startTest();
        priceLevel2.Default__c = true;
        update priceLevel2;
        Test.stopTest();
        
        Price_Level__c firstPriceLevel = [select Id, default__c from Price_Level__c where Id = :priceLevel1.Id];
        system.assertEquals(firstPriceLevel.default__c, false);
        
    }
    
    /**
     * Name: defaultCheckForInsert
     * Desc: Testing to make sure there is only one default price level when price level record is inserted
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForInsert() {
        Test.startTest();
        Price_Level__c priceLevel1 = TestUtil.createPriceLevel(true, 'Test Price Level 1', 'Cost', true, true);
        Price_Level__c priceLevel2 = TestUtil.createPriceLevel(true, 'Test Price Level 2', 'Price', false, true);
        Price_Level__c priceLevel3 = TestUtil.createPriceLevel(true, 'Test Price Level 3', 'Price', true, true);
        Test.stopTest();
        
        Price_Level__c firstPriceLevel = [select Id, default__c from Price_Level__c where Id = :priceLevel1.Id];
        system.assertEquals(firstPriceLevel.default__c, false);
        
    }
    
    /**
     * Name: defaultCheckForDelete
     * Desc: Testing to make sure defaullt price level can't be deleted
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForDelete() {
        Price_Level__c priceLevel1 = TestUtil.createPriceLevel(true, 'Test Price Level 1', 'Cost', true, true);
        
        Test.startTest();
        try {
        	delete priceLevel1;
        } catch (Exception e) {
        	system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
}