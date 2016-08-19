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
private class CustomerOverviewTest {
	
	/**
     * Name: CustomerOverviewFunctionalTest
     * Desc: Testing to check the opertaions on customer View Page
     * @param: 
     * @return: 
    **/
    
    static testMethod void CustomerOverviewFunctionalTest() {
        
        Account customer1 = TestUtil.createCustomer(true, 'Test Customer 1', 'test1@gmail.com', 'Jaipur', '1800111265');
        Account customer2 = TestUtil.createCustomer(true, 'Test Customer 2', 'test2@gmail.com', 'Kota', '18001112365');
        Account customer3 = TestUtil.createCustomer(true, 'Test Customer 3', 'test3@gmail.com', 'Chennai', '1800111266');
        Account customer4 = TestUtil.createCustomer(true, 'Test Customer 4', 'test4@gmail.com', 'Kolkata', '1800111255');
        Account customer5 = TestUtil.createCustomer(true, 'Test Customer 5', 'test5@gmail.com', 'Jodhpur', '1800111275');
        Account customer6 = TestUtil.createCustomer(true, 'Test Customer 6', 'test6@gmail.com', 'Jaipur', '1800111285');
        Price_Level__c priceLevel1 = TestUtil.createPriceLevel(true, 'Test Price Level 1', 'Cost', true, true);
        Sales_Tax__c salesTax1 = TestUtil.createSalesTax(true, 'Testing Sales Tax 1', true, false, true);
        Country__c country = TestUtil.createCountry(true, 'India ', true, true);
        State__c state = TestUtil.createState(true, 'Gujrat ', country.Id, true); 
        
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.CustomerOverview'));
        System.currentPageReference().getParameters().put('pageno', '1');
        System.currentPageReference().getParameters().put('C_ID', customer1.Id);
        
        CustomerOverview custOverview = new CustomerOverview();
        
        String preferredContacts = custOverview.getCustomerPreferredContactsOptions();
        System.assertEquals(preferredContacts.length() > 0, true);
        
        String priceLevels = custOverview.getPriceLevelListItems();
        System.assertEquals(priceLevels.length() > 0, true);
        
        String salesTaxes = custOverview.getSalesTaxListItems();
        System.assertEquals(salesTaxes.length() > 0, true);
        
        String coutries = custOverview.getOrgCountries();
        System.assertEquals(salesTaxes.length() > 0, true);
        
        String states = custOverview.getOrgStates();
        System.assertEquals(salesTaxes.length() > 0, true);
        
        System.currentPageReference().getParameters().put('C_ID', null);
        CustomerOverview custOverviewWithWrongParameter = new CustomerOverview();
        Test.stopTest();
    }
    
}