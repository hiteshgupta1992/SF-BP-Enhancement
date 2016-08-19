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
private class SalesTaxItemTriggerHelperTest {
	
	/**
     * Name: beforeDeleteOperationsTest
     * Desc: Testing of applicable Tex records if corresponding sales tax items records are deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void beforeDeleteOperationsTest() {
    	Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test STI 1');
    	Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test STI 2');
    	
    	Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Test ST 1', true, true, true);
    	Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Test ST 2', true, false, true);
    	
    	Applicable_Taxes__c appTax1 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem1.Id);
    	Applicable_Taxes__c appTax2 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem2.Id);
    	
    	Test.startTest();
    	delete salesTaxItem1;
    	Test.stopTest();
    	
    	List<Applicable_Taxes__c> appTaxesList = [select Id from Applicable_Taxes__c];
    	system.assertEquals(appTaxesList.size(), 1);
    }
    
    /**
     * Name: afterUpdateOperationTest
     * Desc: Test the sales tax Rate if the rate of related sales tax item reccord is changed.
     * @param: 
     * @return: 
    **/
    static testMethod void afterUpdateOperationTest() {
    	Sales_Tax_Item__c salesTaxItem1 = TestUtil.createSalesTaxItem(true, 'Test STI 1', 12, 'Test Label1', true, null);
    	Sales_Tax_Item__c salesTaxItem2 = TestUtil.createSalesTaxItem(true, 'Test STI 2', 10, 'Test Label2', true, null);
    	
    	Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Test ST 1', true, true, true);
    	Sales_Tax__c salesTax2 = TestUtil.createSalesTax(true, 'Test ST 2', true, false, true);
    	
    	Applicable_Taxes__c appTax1 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem1.Id);
    	
    	Test.startTest();
    	salesTaxItem2.Rate__c = 8;
    	update salesTaxItem2;
    	
    	List<Sales_Tax__c> salesTaxList = [select Id, Rate__c from Sales_Tax__c where Name__c = 'Test ST 1'];
    	system.assertEquals(salesTaxList[0].Rate__c, 12);
    	
    	Applicable_Taxes__c appTax2 = TestUtil.createApplicableTax(true, salesTax1.Id, salesTaxItem2.Id);
    	
    	salesTaxItem1.Name__c = 'STI 1';
    	update salesTaxItem1;
    	
    	salesTaxItem2.Rate__c = 18;
    	update salesTaxItem2;
    	Test.stopTest();
    	
    	salesTaxList = [select Id, Rate__c from Sales_Tax__c where Name__c = 'Test ST 1'];
    	system.assertEquals(salesTaxList[0].Rate__c, 30);
    }
    
    
}