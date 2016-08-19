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
private class UnitMakeTest {
	
	/**
     * Name: UnitMakeCreate
     * Desc: Test the unit create.
     * @param: 
     * @return: 
    **/
	
    
    static testMethod void UnitMake() 
    {	
    	Unit_Make__c UnitMake1 = TestUtil.createUnitMake(true, 'lit', 'AAA', true);
    	//Test.startTest();
    	UnitMake UnitM = new UnitMake(UnitMake1);
    	//Test.stopTest();
    	Unit_Make__c firstUnit=[Select Id, Name From Unit_Make__c u where Id= :UnitMake1.Id];
	     system.assertEquals(firstUnit.Name, 'lit');
    }
     
     static testMethod void fieldList() 
    {	
    	Unit_Make__c test1 = TestUtil.createUnitMake(true, 'lit', 'AAA', true);
    	Test.startTest();
		List<String> list1 = UnitMake.fieldsList();
    	Test.stopTest();
	   system.assertEquals(list1[0],'Id');
	   system.assertEquals(list1[1],'Name');
    }
    
    }