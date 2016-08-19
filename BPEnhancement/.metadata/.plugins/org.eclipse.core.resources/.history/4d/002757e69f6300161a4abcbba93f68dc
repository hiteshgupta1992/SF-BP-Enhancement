@isTest
private class CustomerWrapperTest {

	static testMethod void testCreateCustomerWrapper() {
		
		Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
        
        CustomerWrapper wrapper = new CustomerWrapper(customer, new List<Customer_Owned_Unit__c> {customerOwnedUnit});
        
        System.assertEquals(1, wrapper.COURecords.size());
	}
	
	static testMethod void testParseCustomerWrapper() {
		
		Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
        
        CustomerWrapper wrapper = new CustomerWrapper(customer, new List<Customer_Owned_Unit__c> {customerOwnedUnit});
        
        CustomerWrapper parsedCustomerWrapper = CustomerWrapper.parse(JSON.serialize(wrapper));
        
        System.assertEquals(1, parsedCustomerWrapper.COURecords.size());
	}
}