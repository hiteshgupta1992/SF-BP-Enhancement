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
private class UserTimeZoneTest {

    /**
     * Name: UserTimeZoneTest 
     * Desc: Test SLA functionality.
     * @param: 
     * @return: 
    **/
   static testMethod void createdataforDefaulttimeszoneTest() {
    	
    	User Defaultuser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U');
    	
    	system.runAs(Defaultuser) {
    			Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    			Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    			Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
    			
    			Account insertedVendor = [select createddate from Account where Id = :vendor.id];
    			Category__c insertedCatgory = [select createddate from Category__c where Id = :testCategory.id];
    			Part__c	insertedPart = [select Part_Number__c, createddate from Part__c where Id = :part.id];
	 		
				system.assertEquals(insertedVendor.createddate.day() , system.now().day());
				system.assertEquals(insertedVendor.createddate.hour() , system.now().hour());
				system.assertEquals(insertedCatgory.createddate.hour() , system.now().hour());
				system.assertEquals(insertedPart.createddate.hour(), system.now().hour());
	 	}
   }
        
        static testMethod void createdataforAUtimeszoneTest() {
    	
    	
    	User AUuser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U', 'Australia/Perth');
    	
    	system.runAs(AUuser) {
    			Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    			Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    			Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
    			
    			Account insertedVendor = [select createddate from Account where Id = :vendor.id];
    			Category__c insertedCatgory = [select createddate from Category__c where Id = :testCategory.id];
    			Part__c	insertedPart = [select Part_Number__c, createddate from Part__c where Id = :part.id];
    			
    			user AUuser1 = [select createddate, TimeZoneSidKey from user where Id = :AUuser.id];
    			//system.assert(false, AUuser1.createddate.hour());
    			
				system.assertEquals(insertedVendor.createddate.hour() , system.now().hour());
				system.assertEquals(insertedCatgory.createddate.hour() , system.now().hour());
				system.assertEquals(insertedPart.createddate.hour(), system.now().hour());
				
				
	 	}
  }
        
          
        static testMethod void createdataforUStimeszoneTest() {
    	
    	
    	User USuser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U', 'America/Los_Angeles');
    	
    	system.runAs(USuser) {
    			Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    			Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    			Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
    			
    			part.Part_Number__c = 'Newpart';
    			update part;
    			
    			Account insertedVendor = [select createddate from Account where Id = :vendor.id];
    			Category__c insertedCatgory = [select createddate from Category__c where Id = :testCategory.id];
    			Part__c	insertedPart = [select Part_Number__c, createddate, lastmodifieddate from Part__c where Id = :part.id];
    			
    			user USuser1 = [select createddate, TimeZoneSidKey from user where Id = :USuser.id];
    			
    			//system.assert(false, insertedPart.lastmodifieddate.time());
    			
    			system.assertEquals(insertedVendor.createddate.hour() , system.now().hour());
    			system.assertEquals(insertedCatgory.createddate.hour() , system.now().hour());
				system.assertEquals(insertedPart.createddate.hour(), system.now().hour());
				system.assertEquals(insertedPart.lastmodifieddate.hour(), system.now().hour());
				
				
	 	}
	 	
        }
        
        static testMethod void createdataforEUtimeszoneTest() {
    	
    	
    	User EUuser = TestUtil.createUser(true, 'a@b.com', 'Testing ', 'en_US', 'testUse123r@force.com', 'Test U', 'Europe/Paris');
    	
    	system.runAs(EUuser) {
    			Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    			Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    			Part__c part = TestUtil.createPart(true, '123', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
    			
    			Account insertedVendor = [select createddate from Account where Id = :vendor.id];
    			Category__c insertedCatgory = [select createddate from Category__c where Id = :testCategory.id];
    			Part__c	insertedPart = [select Part_Number__c, createddate from Part__c where Id = :part.id];
    			
    			user EUuser1 = [select createddate, TimeZoneSidKey from user where Id = :EUuser.id];
    			
    			//system.assert(false, EUuser1.createddate.time());
    			
    			
    			system.assertEquals(insertedVendor.createddate.hour() , system.now().hour());
    			system.assertEquals(insertedCatgory.createddate.hour() , system.now().hour());
				system.assertEquals(insertedPart.createddate.hour(), system.now().hour());
				
				
				
	 	}
	 	
        }
}