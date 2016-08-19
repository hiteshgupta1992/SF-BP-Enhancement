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
private class UnitModelOverviewCtrlTest {

    static testMethod void myUnitTest() {
        UnitModelOverviewCtrl uMOCtrl = new UnitModelOverviewCtrl();
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Testing Description', false, true);
        
        Test.startTest();
        //String categoryNameString = UnitModelOverviewCtrl.getCategoryPicklistValues();
        uMOCtrl.setCustomerCustomSetting();
        
       // System.assertEquals(true, categoryNameString.length() > 0);
        
        List<Customer_Page_Size__c> customerPageSizeList = [select User__c, Drop_Down_Number__c from Customer_Page_Size__c ];
        System.assertEquals(null, customerPageSizeList[0].Drop_Down_Number__c);
        Test.stopTest();
        
        Customer_Page_Size__c cpsRec = new Customer_Page_Size__c(User__c = UserInfo.getUserId(), Drop_Down_Number__c = 20);
        insert cpsRec;
        
        uMOCtrl.setCustomerCustomSetting();
       
        customerPageSizeList = [select User__c, Drop_Down_Number__c from Customer_Page_Size__c ];
        System.assertEquals(20, customerPageSizeList[1].Drop_Down_Number__c);
    }
}