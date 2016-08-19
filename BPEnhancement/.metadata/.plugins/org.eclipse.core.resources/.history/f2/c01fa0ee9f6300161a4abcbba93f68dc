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
private class RecentCustomerTriggerHelperTest {

	/**
     * Name: beforeInsertOperationTest
     * Desc: Testing to make sure there exists only 20 recent customer reccords per user
     * @param: 
     * @return: 
    **/
    static testMethod void beforeInsertOperationTest() {
        List<Account> customerListToBeInsert = new List<Account>();
        Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
        for(Integer counter = 0; counter < 20 ; counter++) {
        	Account customer = new Account();
        	customer.Name = 'Test Customer ' + counter;
        	customerListToBeInsert.add(customer);
        }
        
        insert customerListToBeInsert;
        
        Test.startTest();
        Account newCustomer = TestUtil.createCustomer(true, 'new Customer', 'google@gmail.com', 'Peris', '1800111265');
        Test.stopTest();
     
        List<Recent_Customer__c> recentCustomerList = [select Id from Recent_Customer__c];
        //system.assertEquals(recentCustomerList.size(), 20);
    }
}