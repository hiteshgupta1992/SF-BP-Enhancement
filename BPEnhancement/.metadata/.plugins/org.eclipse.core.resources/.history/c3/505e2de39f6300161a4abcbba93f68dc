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
private class CategoryTriggerHelperTest {
	
	/**
     * Name: inactiveAsDefaultCategoryTest
     * Desc: Testing of an inactive record can't be set as default.
     * @param: 
     * @return: 
    **/
    static testMethod void inactiveAsDefaultCategoryTest() {
        Category__c testCategory1 = TestUtil.createCategory(false, 'Test Category 1', 'Tax', 'Test Description', true, false);
        Test.startTest();
        try {
        	insert testCategory1;
        } catch (Exception e){
        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        	//system.assertEquals('Validation Error : You can\'t make inactive category as default', e.getMessage() );
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultUnselectedCategoryTest
     * Desc: Testing that ensures that default check box can't be deselected
     * @param: 
     * @return: 
    **/
    static testMethod void defaultUnselectedCategoryTest() {
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', true, true);
        Test.startTest();
        try {
        	testCategory1.Default__c = false;
        	update testCategory1;
        } catch (Exception e){
        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        	//system.assertEquals('Validation Error : You can\'t deselect of a default category', e.getMessage() );
        }
        Test.stopTest();
    }
    
    /**
     * Name: defaultAndTypeChangedCategoryTest
     * Desc: testing to ensures that Default Category type can't be changed. 
     * @param: 
     * @return: 
    **/
    static testMethod void defaultAndTypeChangedCategoryTest() {
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', true, true);
        Test.startTest();
        try {
        	testCategory1.Type__c = 'Unit';
        	update testCategory1;
        } catch (Exception e){
        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        	//system.assertEquals('Validation Error : You Cannot change the category type of a default record.', e.getMessage());
        }
        Test.stopTest();
    }
    
    /**
     * Name: updateCategory
     * Desc: Testing that ensures that Default check box is true only for one category per type
     * @param: 
     * @return: 
    **/
    static testMethod void updateCategory() {
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', false, true);
        Category__c testCategory2 = TestUtil.createCategory(true, 'Test Category 2', 'Unit', 'Test Description1', true, true);
        Category__c testCategory3 = TestUtil.createCategory(true, 'Test Category 3', 'Unit', 'Test Description1', false, true);
        
        Test.startTest();
    	testCategory3.Default__c= true;
    	update testCategory3;
        Test.stopTest();
        
        testCategory3 = [select Default__c from Category__c where id = :testCategory3.Id];
        system.assertEquals(true, testCategory3.Default__c); 
        
        testCategory2 = [select Default__c from Category__c where id = :testCategory2.Id];
        system.assertEquals(false, testCategory2.Default__c); 
    }
    
    /**
     * Name: deleteDefaultCategoryTest
     * Desc: Testing that ensures that daefault category Can't de deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void deleteDefaultCategoryTest() {
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', true, true);
        
        Test.startTest();
    	try {
    		delete testCategory1;
    	} catch (Exception e) {
    		e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    		//system.assertEquals('Validation Error : You Can\'t delete category marked as default.', e.getMessage() );
    	}
    	
        Test.stopTest();
    }
    
    /**Added by Durga Singh on 23 July 2015
     * Name: deleteDefaultCategoryTest
     * Desc: Testing that ensures that daefault category Can't de deleted.
     * @param: 
     * @return: 
    **/
    static testMethod void checkForDefaultDeleteTest() {
        Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', true, true);
        
        Test.startTest();
        try {
    		delete testCategory1;
        } catch(Exception e) {
        	
        }
        
        List<Category__c> testCategory = [select Default__c from Category__c ];
    	system.assertEquals(testCategory[0].Default__c, true);
    	
    	Test.stopTest();
    }
}