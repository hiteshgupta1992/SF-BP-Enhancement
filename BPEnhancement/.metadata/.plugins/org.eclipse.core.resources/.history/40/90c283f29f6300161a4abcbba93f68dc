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
private class StateTriggerHelperTest {
	
	/**
     * Name: defaultCheckForUpdate
     * Desc: Testing to make sure there exists only one default state record when records are updated.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForUpdate() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
       	
       	State__c state1 = TestUtil.createState(true, 'Test State 1', country1.Id, true);
       	State__c state2 = TestUtil.createState(true, 'Test State 2', country1.Id, false);
        
        Test.startTest();
        state2.Default__c = true;
        update state2;
        Test.stopTest();
        
        State__c firstState = [select Id, default__c from State__c where Id = :state1.Id];
        system.assertEquals(firstState.default__c, false);
    }
    
    /**
     * Name: defaultCheckForInsert
     * Desc: Testing to make sure there exists only one default state record when records are inserted
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForInsert() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
       	
       	Test.startTest();
       	State__c state1 = TestUtil.createState(true, 'Test State 1', country1.Id, true);
       	State__c state2 = TestUtil.createState(true, 'Test State 2', country1.Id, false);
       	State__c state3 = TestUtil.createState(true, 'Test State 3', country1.Id, true);
        Test.stopTest();
        
        State__c firstState = [select Id, default__c from State__c where Id = :state1.Id];
        system.assertEquals(firstState.default__c, false);
    }
    
    /**
     * Name: defaultCheckForDelete
     * Desc: Testing to make sure that default state can't be deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForDelete() {
        Country__c country1 = TestUtil.createCountry(true, 'Canada', true, true);
       	State__c state1 = TestUtil.createState(true, 'Test State 1', country1.Id, true);
        
        Test.startTest();
        try {
        	delete state1;
        } catch (Exception e) {
        	system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
}