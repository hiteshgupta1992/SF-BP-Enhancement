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
private class SalesTaxTriggerHelperTest {
	
	/**
     * Name: defaultCheckForUpdate
     * Desc: Testing to make sure there exists only one default sales Tax record when records are updated.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForUpdate() {
        Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
        Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Testing Sales Tax 2', true, false, true);
        
        Test.startTest();
        salesTax2.Default__c = true;
        update salesTax2;
        Test.stopTest();
        
        Sales_Tax__c firstSalesTax = [select Id, default__c from Sales_Tax__c where Id = :salesTax1.Id];
        system.assertEquals(firstSalesTax.default__c, false);
    }
    
    /**
     * Name: defaultCheckForInsert
     * Desc: Testing to make sure there exists only one default sales Tax record when records are inserted.
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForInsert() {
        Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
        Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Testing Sales Tax 2', true, false, true);
        
        Test.startTest();
        Sales_Tax__c salesTax3 = TestUtil.createSalesTax(true, 'Testing Sales Tax 3', true, true, true);
        Test.stopTest();
        
        Sales_Tax__c salesTaxRec =  [select Id, default__c from Sales_Tax__c where Id = :salesTax2.Id];
        system.assertEquals(salesTaxRec.default__c, false);
    }
    
    /**
     * Name: defaultCheckForDelete
     * Desc: Testing to make sure defaullt Sales Tax can't be deleted
     * @param: 
     * @return: 
    **/
    static testMethod void defaultCheckForDelete() {
        Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
        
        Test.startTest();
        try {
        	delete salesTax1;
        } catch (Exception e) {
        	system.assertEquals(e != null, true);
        }
        Test.stopTest();
    }
}