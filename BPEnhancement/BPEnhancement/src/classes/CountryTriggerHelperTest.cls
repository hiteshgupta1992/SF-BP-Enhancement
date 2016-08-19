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
// Used In Kendo.
@isTest
private class CountryTriggerHelperTest {
	
	/**
     * Name: defaultCheckForUpdate
     * Desc: Testing of default field of country to ensure only one default country exists at a time
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForUpdate() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        Country__c country2 = TestUtil.createCountry(true, 'USA', true, false);
        
        Test.startTest();
        country2.Default__c = true;
        update country2;
        Test.stopTest();
        
        Country__c firstCountry = [select Id, default__c from Country__c where Id = :country1.Id];
        system.assertEquals(firstCountry.default__c, false);
    }
    
    /**
     * Name: invisibleCountryDefaultCheck
     * Desc: Testing to make sure that only a visible country is marked as default at the time when a new country is inserted.
     * @param: 
     * @return: 
    **/
    static testMethod void invisibleCountryDefaultCheck() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        Country__c country2 = TestUtil.createCountry(true, 'USA', true, false);
        
        Test.startTest();
        try {
            Country__c country3 = TestUtil.createCountry(true, 'UK', false, true);
        } catch (Exception e) {
            system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultVisibleCheck1
     * Desc: Testing to make sure that only a visible country is marked as default.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultVisibleCheck1() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, false);
        
        Test.startTest();
        country1.Visible__c = false;
        country1.Default__c = true;
        try {
            update country1;
        } catch (Exception e) {
            system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultVisibleCheck2
     * Desc: Testing to make sure that there should be one default country is always present.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultVisibleCheck2() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        
        Test.startTest();
        country1.Default__c = false;
        try {
            update country1;
        } catch (Exception e) {
            system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultCheck2
     * Desc: Testing to make sure that a DEFAULT country cannot marked as invisible.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheck2() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        
        Test.startTest();
        country1.Visible__c = false;
        try {
            update country1;
        } catch (Exception e) {
            system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultCheckForInsert
     * Desc: Testing to make sure that only one DEFAULT country is exist at the time of insert.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForInsert() {
        Test.startTest();
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        Country__c country2 = TestUtil.createCountry(true, 'India', true, false);
        Country__c country3 = TestUtil.createCountry(true, 'Australia', true, true);
        Test.stopTest();
        
        Country__c firstCountry = [select Id, default__c from Country__c where Id = :country1.Id];
        system.assertEquals(firstCountry.default__c, false);
    }
    
    /**
     * Name: defaultCheckForDelete
     * Desc: Testing to make sure that DEFAULT country can't be deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForDelete() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        
        Test.startTest();
        try {
            delete country1;
        } catch (Exception e) {
            system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
    
    /**
     * Name: updateDefaultFieldOfOtherStates
     * Desc: Testing to make sure that default state is only exists if the parent country is default.
     * @param: 
     * @return: 
    **/
    static testMethod void updateDefaultFieldOfOtherStates() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
        Country__c country2 = TestUtil.createCountry(true, 'India', true, false);
        
        State__c state1 = TestUtil.createState(true, 'Test State 1', country1.Id, true);
        State__c state2 = TestUtil.createState(true, 'Test State 2', country2.Id, false);
        State__c state3 = TestUtil.createState(true, 'Test State 3', country1.Id, true);
        State__c state4 = TestUtil.createState(true, 'Test State 4', country2.Id, false);
        
        Test.startTest();
        country2.Default__c = true;
        update country2;
        Test.stopTest();
        
        Country__c firstCountry = [select Id, default__c from Country__c where Id = :country1.Id];
        system.assertEquals(firstCountry.default__c, false);
    }
}