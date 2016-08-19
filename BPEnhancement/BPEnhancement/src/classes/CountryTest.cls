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
private class CountryTest {
	
	/**
     * Name: CountryInsert
     * Desc: Test the new country record insert.
     * @param: 
     * @return: 
    **/
	
    
    static testMethod void Country() 
    {	
    	Country__c test1 = TestUtil.createCountry(true, 'India', true, true);
    	Test.startTest();
    	country country1 = new country(test1);
    	Test.stopTest();
    	Country__c firstCountry=[Select Id, Name__c, Default__c, Visible__c From Country__c c where Id= :test1.Id];
	   system.assertEquals(firstCountry.Name__c, 'India');
    }
     
     static testMethod void fieldList() 
    {	
    	Country__c test1 = TestUtil.createCountry(true, 'India', true, true);
    	Test.startTest();
		List<String> list1 = country.fieldsList();
    	Test.stopTest();
    	//Country__c firstCountry=[Select Id, Name__c, Default__c, Visible__c From Country__c c where Id= :test1.Id];
	   system.assertEquals(list1[0],'Id');
    }
    
    static testMethod void CountryCreate() 
	{
	
	  	Country__c Country1 = TestUtil.createCountry(true, 'Canada', true, true);
		Country__c firstCountry=[Select Name__c, Id From Country__c c where Id= :Country1.Id];
	   	system.assertEquals(firstCountry.Name__c, 'Canada');
    }
    }