@isTest
private class DataLoadForCountryStateTest {

    static testMethod void myUnitTest() {
        DataLoadForCountryState DataLoadForCountryStateCtrl = new DataLoadForCountryState();
        List<Country__c> countryList = [select Id from Country__c];
        system.assertEquals(true, countryList.size() > 0);
    }
}