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
private class VendorOverviewCtrlTest {

    static testMethod void myUnitTest() {
        
        Account testVendor = TestUtil.createVendor(true, 'Test Vendor1');
        Country__c testCountry = TestUtil.createCountry(true, 'India', true, false);
        State__c testState = TestUtil.createState(true, 'Rajasthan', testCountry.Id, false);
        Price_Level__c testPriceLevel = TestUtil.createPriceLevel(true, 'Test Price Level', 'Tax', true, true);
        Sales_Tax__c testSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        
        Test.setCurrentPageReference(new PageReference('Page.VendorOverview'));
        System.currentPageReference().getParameters().put('pageno', '1');
        
        
        VendorOverviewCtrl vOCtrl = new VendorOverviewCtrl();
        System.assertEquals(null, vOCtrl.vendor.Id);
        
        System.currentPageReference().getParameters().put('V_ID', testVendor.Id);
        
        Test.startTest();
        vOCtrl = new VendorOverviewCtrl();
        String customerPreferredContactsOptionsString = vOCtrl.getCustomerPreferredContactsOptions();
        Test.stopTest();
        
        System.assertEquals(testVendor.Id, vOCtrl.vendor.Id);
        System.assertEquals(true, customerPreferredContactsOptionsString.length() > 0);
        System.assertEquals(null, vOCtrl.defaultCountry);
        System.assertEquals(null, vOCtrl.defaultState);
        
        
        testCountry.Default__c = true;
        testState.Default__c = true;
        update testCountry;
        update testState;
        
        System.assertEquals('India', vOCtrl.defaultCountry);
        System.assertEquals('Rajasthan', vOCtrl.defaultState);
        
        
    }
}