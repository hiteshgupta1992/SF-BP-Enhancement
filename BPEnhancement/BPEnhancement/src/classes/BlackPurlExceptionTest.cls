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
private class BlackPurlExceptionTest {

    static testMethod void myUnitTest() {
        String triggerError = 'Assertion Failed: Delete failed. First exception on row 0 with id 001c000000a1SnlAAE; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, AccountTrigger: execution of BeforeDelete caused by: System.MathException: Divide by 0 Trigger.AccountTrigger: line 2, column 1: ';
        String errorString = BlackPurlException.getErrorMessage(triggerError,'');
        //system.assertEquals(errorString,'Trigger error :AccountTrigger');
        
        String duplicateError = 'Update failed. First exception on row 0 with id 001c000000a2TG0AAM; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Custom Valdation Error: []';
        BlackPurlException.getErrorMessage(duplicateError,'');
            
        String validationError = 'Assertion Failed: Insert failed. First exception on row 0; first error: DUPLICATE_VALUE, duplicate value found: User_Contact_Uniq_Id__c duplicates value on record with id: 0039000000zED8uAAG:'; 
        BlackPurlException.getErrorMessage(validationError,'');
        
        String nullError = 'Class.SearchMergeControllerToDeploy.doMerge: line 953, column 1';
        BlackPurlException.getErrorMessage('Attempt to de-reference a null object',nullError);
        
        String error = 'Undefined Error';
        BlackPurlException.getErrorMessage(error,error);
        
        String deleteFailedError = 'DELETE_FAILED  due to DML Exception    ';
        errorString = BlackPurlException.getErrorMessage(deleteFailedError, deleteFailedError);
        //system.assertEquals(errorString,'Delete Failed. <br/>due to DML Exception');
    }
}