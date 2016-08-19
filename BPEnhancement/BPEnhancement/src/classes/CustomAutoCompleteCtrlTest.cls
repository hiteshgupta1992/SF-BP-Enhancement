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
private class CustomAutoCompleteCtrlTest {
  
    static testMethod void myUnitTest() {
    	Category__c testCategory1 = TestUtil.createCategory(true, 'Test Category 1', 'Tax', 'Test Description', true, true);
        
        Test.startTest();
        String autoCompleteString = BPUtility.getDecodedString(CustomAutoCompleteCtrl.getAutoCompleteJSONForObj(BPUtility.getEncodedString('Category__c'), BPUtility.getEncodedString('Tes')));
        Test.stopTest();
        
        JSONParser parser = JSON.createParser(autoCompleteString);
        String autoCompleteName;
        String autoCompleteId;
        while (parser.nextToken() != null) {
        	if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            	while (parser.nextToken() !=  JSONToken.END_ARRAY) {
		        	if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
		            	while (parser.nextToken() !=  JSONToken.END_OBJECT) {
		            		if(String.valueOf(parser.getText()) == 'Name') {
		            			parser.nextToken();
		            			autoCompleteName = parser.getText();
		            		} else if(String.valueOf(parser.getText()) == 'Value') {
		            			parser.nextToken();
		            			autoCompleteId = parser.getText();
		            		}
		            	}
		        	}
            	}
        	}
        }
        
        system.assertEquals('Test Category 1', autoCompleteName);
        system.assertEquals(testCategory1.Id, autoCompleteId);
    }
}