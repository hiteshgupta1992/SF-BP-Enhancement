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
private class AccessControlTest {

    static testMethod void objectUnitTest() {
        Account acc = TestUtil.createCustomer(true, 'Test Customer', 'test@test.com', 'NY', '5214789630');
        
        Boolean isAccessible = AccessControl.ifObjectIsAccessible(acc);
        isAccessible = AccessControl.ifObjectIsAccessible('Account');
        system.assertEquals(isAccessible, true);
        
        Boolean isCreateable = AccessControl.ifObjectIsCreateable(acc);
        isCreateable = AccessControl.ifObjectIsCreateable('Account');
        system.assertEquals(isCreateable, true);
        
        Boolean isUpdateable = AccessControl.ifObjectIsUpdateable(acc);
        isUpdateable = AccessControl.ifObjectIsUpdateable('Account');
        system.assertEquals(isUpdateable, true);
        
        Boolean isDeletable = AccessControl.ifObjectIsDeletable(acc);
        isDeletable = AccessControl.ifObjectIsDeletable('Account');
        system.assertEquals(isDeletable, true);
    }
    
    static testMethod void fieldsUnitTest() {
        Account acc = TestUtil.createCustomer(true, 'Test Customer', 'test@test.com', 'NY', '5214789630');
        
        Boolean isAccessible = AccessControl.ifObjectFieldIsAccessible(acc);
        isAccessible = AccessControl.ifObjectFieldIsAccessible('Account');
        isAccessible = AccessControl.ifObjectFieldIsAccessible('Account', 'Name');
        system.assertEquals(isAccessible, true);
        
        Boolean isCreateable = AccessControl.ifObjectFieldIsCreateable(acc);
        isCreateable = AccessControl.ifObjectFieldIsCreateable('Account');
        isCreateable = AccessControl.ifObjectFieldIsCreateable('Account', 'Name');
        system.assertEquals(isCreateable, true);
        
        Boolean isUpdateable = AccessControl.ifObjectFieldIsUpdateable(acc);
        isUpdateable = AccessControl.ifObjectFieldIsUpdateable('Account');
        isUpdateable = AccessControl.ifObjectFieldIsUpdateable('Account', 'Name');
        system.assertEquals(isUpdateable, true);
        
        Boolean isDeletable = AccessControl.ifObjectIsDeletable(acc);
        isDeletable = AccessControl.ifObjectIsDeletable('Account');
        system.assertEquals(isDeletable, true);
    }
}