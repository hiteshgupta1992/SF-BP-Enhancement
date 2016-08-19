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
private class BlackPurlHeaderCtrlTest {

    static testMethod void myUnitTest() {
        
        BlackPurlHeaderCtrl bpHeaderCtrl = new BlackPurlHeaderCtrl();
        Test.startTest();
        String pageParameterName = bpHeaderCtrl.pageParameterName;
        System.assertEquals(pageParameterName, 'pageName');
        
        String customerMgmtPageParameterName = bpHeaderCtrl.customerMgmtPageParameterName;
        System.assertEquals(customerMgmtPageParameterName, 'CustomerMgmt');
        
        String partsMgmtPageParameterName = bpHeaderCtrl.partsMgmtPageParameterName;
        System.assertEquals(partsMgmtPageParameterName, 'PartsMgmt');
        
        String settingsPageParameterName = bpHeaderCtrl.settingsPageParameterName;
        System.assertEquals(settingsPageParameterName, 'SystemSettings');
        
        String categoryMgmtPageParameterName = bpHeaderCtrl.categoryMgmtPageParameterName;
        String vendorMgmtPageParameterName = bpHeaderCtrl.vendorMgmtPageParameterName;
        String makeMgmtPageParameterName = bpHeaderCtrl.makeMgmtPageParameterName;
        Test.stopTest();
    }
}