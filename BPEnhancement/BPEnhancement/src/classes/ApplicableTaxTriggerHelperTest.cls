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
private class ApplicableTaxTriggerHelperTest {
	
	/**
     * Name: testRollupCountersForInsert
     * Desc: Test the roll up summery field of sales tax record when appliacable tax record are inserted.
     * @param: 
     * @return: 
    **/
	static testMethod void testRollupCountersForInsert() {
	   Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
	   Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Testing Sales Tax 2', true, false, true);
	   
	   Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 1', 20, 'Testing Form Label 1', true, null);
	   Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 2', 30, 'Testing Form Label 2', true, null);
	   
	   Test.startTest();
	   Applicable_Taxes__c applicableTax1 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem1.Id);
	   Applicable_Taxes__c applicableTax2 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem2.Id);
	   Applicable_Taxes__c applicableTax3 = TestUtil.createApplicableTax(true, salesTax2.Id, salesTaxItem1.Id); 
	   Test.stopTest();
	   
	   salesTax1=[Select Rate__c, Id From Sales_Tax__c s where Id= :salesTax1.Id];
	   salesTax2=[Select Rate__c, Id From Sales_Tax__c s where Id= :salesTax2.Id];
	   
	   system.assertEquals(50,salesTax1.Rate__c);
	   system.assertEquals(20,salesTax2.Rate__c);
    }
    
    /**
     * Name: testRollupCountersForDelete
     * Desc: Test the roll up summery field of sales tax record when appliacable tax record are deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void testRollupCountersForDelete() {
       Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, true, true);
       Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Testing Sales Tax 2', true, false, true);
       
       Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 1', 20, 'Testing Form Label 1', true, null);
       Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test Sales Tax Item 2', 30, 'Testing Form Label 2', true, null);
       
       Applicable_Taxes__c applicableTax1 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem1.Id);
       Applicable_Taxes__c applicableTax2 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem2.Id);
       Applicable_Taxes__c applicableTax3 = TestUtil.createApplicableTax(true, salesTax2.Id, salesTaxItem1.Id); 

       Test.startTest();
       applicableTax2 = [Select Id from Applicable_Taxes__c where Id=:applicableTax2.Id];
   	   delete applicableTax2;
       Test.stopTest();
       
       salesTax1=[Select Rate__c, Id From Sales_Tax__c s where Id= :salesTax1.Id];
       salesTax2=[Select Rate__c, Id From Sales_Tax__c s where Id= :salesTax2.Id];
       
       system.assertEquals(20,salesTax1.Rate__c);
       system.assertEquals(20,salesTax2.Rate__c);
    }
}