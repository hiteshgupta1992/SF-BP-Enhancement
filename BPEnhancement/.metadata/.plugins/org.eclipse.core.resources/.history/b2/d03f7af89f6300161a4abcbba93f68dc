/**
 * Author: Durga Singh
 * Since: July 17, 2015
 * Name: ViewCustomerCtrlTest
 * Description: Test for Controller Class of view customer.
**/
@isTest
private class ViewCustomerCtrlTest {


    /**
     * Name: getCustomerInfoTest 
     * Desc: Test to fetch customer information on customerId.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getCustomerInfoTest() {
 		Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, Customer.Id, null, null, null, 'VIN123');
		String customerInfo = BPUtility.getDecodedString(ViewCustomerCtrl.getCustomerInfo(BPUtility.getEncodedString(customer.Id)));
        
        
		CustomerDetail customers = (CustomerDetail) System.JSON.deserialize(customerInfo, CustomerDetail.class);
        system.assertEquals(customers.CustomerInfo.BusinessName , 'customerName');
        system.assertEquals(customers.CustomerInfo.HomeEmail , 'abc@abc.com');
    }
    
    /**
     * Name: getSimilarCOUsTest 
     * Desc: Test to fetch similar COUs on VIN.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getSimilarCOUsTest() {
 		Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		
 		Unit_Make__c unitMake =  TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
 		Unit_Model__c unitModel = testutil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, unitMake.Id, unitModel.Id, null, 'VIN123');
 		
 		String similarCOUs = BPUtility.getDecodedString(ViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN123')));
     	List<CustomerOwnedUnit> CustomerOwnedUnits = (List<CustomerOwnedUnit>) System.JSON.deserialize(similarCOUs, List<CustomerOwnedUnit>.class);
        system.assertEquals(CustomerOwnedUnits.size() , 1);
        
        String similarCOUs1 = BPUtility.getDecodedString(ViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN1234')));
     	List<CustomerOwnedUnit> CustomerOwnedUnits1 = (List<CustomerOwnedUnit>) System.JSON.deserialize(similarCOUs1, List<CustomerOwnedUnit>.class);
        system.assertEquals(CustomerOwnedUnits1.size() , 0);
    }
    
    /**
     * Name: getsaveCOUTest 
     * Desc: Test to save COU.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getsaveCOUTest() {
 		Account Customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Account Customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		
 		Unit_Make__c UnitMake =  TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
 		Unit_Model__c UnitModel = testutil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, Customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
 		
 		Test.starttest();
 		String similarCOUs = BPUtility.getDecodedString(ViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN123')));
 		String saveCOUs = BPUtility.getDecodedString(ViewCustomerCtrl.saveCOU(BPUtility.getEncodedString(Customer1.Id), BPUtility.getEncodedString(similarCOUs)));
 		Test.stoptest();
     	
     	List<CustomerOwnedUnit> CustomerOwnedUnits = (List<CustomerOwnedUnit>) System.JSON.deserialize(similarCOUs, List<CustomerOwnedUnit>.class);
        system.assertEquals(CustomerOwnedUnits[0].VIN , 'VIN123');
    }
    
      /**
     * Name: getCOURecordByIdTest 
     * Desc: Test to getCOURecordById.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void getCOURecordByIdTest() {
 		Account Customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Unit_Make__c UnitMake =  TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
 		Unit_Model__c UnitModel = testutil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, Customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
 		
 		
 		string COUList = BPUtility.getDecodedString(ViewCustomerctrl.getCOURecordById(BPUtility.getEncodedString(customerOwnedUnit.Id)));
 		List<CustomerOwnedUnit> CustomerOwnedUnits = (List<CustomerOwnedUnit>) System.JSON.deserialize(COUList, List<CustomerOwnedUnit>.class);
        system.assertEquals(CustomerOwnedUnits[0].VIN , 'VIN123');
    }
    
     /**
     * Name: getRelatedCustomerByCustomerIdTest 
     * Desc: Test to getRelatedCustomerByCustomerId.
     * @param: 
     * @return: 
    **/
    
    
	static testMethod void getRelatedCustomerByCustomerIdTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Employee');
 		
 		
 		string relatedCustomers = BPUtility.getDecodedString(ViewCustomerctrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id)));
 		List<RelatedCustomer> relatedCustomersList = (List<RelatedCustomer>) System.JSON.deserialize(relatedCustomers, List<RelatedCustomer>.class);
        system.assertEquals(relatedCustomersList.size() , 1);
        system.assertEquals(relatedCustomersList[0].Relation , 'Employer');
        
    }
    
    /**
     * Name: updateRelatedCustomerTest 
     * Desc: Test to update information for RelatedCustomer.
     * @param: 
     * @return: 
    **/
    
    
   static testMethod void updateRelatedCustomerTest() {
 		Account customer =  TestUtil.createCustomer(false, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		
 		
 		customer.ParentId = customerA.Id ;
 		insert customer;
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Friend');
 		
 		String customerInfo = BPUtility.getDecodedString(ViewCustomerCtrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id)));
 		List<RelatedCustomer> customers = (List<RelatedCustomer>) System.JSON.deserialize(customerInfo, List<RelatedCustomer>.class);
 		customers[0].Relation = 'Family' ;
 		
 		String customersJSONString = System.JSON.serialize(customers);
 		String updatedCustomerRelationship =  BPUtility.getDecodedString(ViewCustomerCtrl.updateRelatedCustomer(BPUtility.getEncodedString(customersJSONString)));
 		List<RelatedCustomer> customersWithNewRelation = (List<RelatedCustomer>) System.JSON.deserialize(updatedCustomerRelationship, List<RelatedCustomer>.class);
 		system.assertEquals(customersWithNewRelation[0].Relation , 'Family');
 		
 		customers[0].Relation = null ;
 		
 		String customersJSONString1 = System.JSON.serialize(customers);
 		String updatedCustomerRelationship1 =  BPUtility.getDecodedString(ViewCustomerCtrl.updateRelatedCustomer(BPUtility.getEncodedString(customersJSONString1)));
 		List<RelatedCustomer> customersWithNewRelation1 = (List<RelatedCustomer>) System.JSON.deserialize(updatedCustomerRelationship1, List<RelatedCustomer>.class);
 		//system.assert(false, customersWithNewRelation1);
 		system.assertEquals(customersWithNewRelation1.size() , 0);
 		
    }
    
     /**
     * Name: getCustomerContactByCustomerIdTest 
     * Desc: Test to ugetCustomerContactByCustomerId.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getCustomerContactByCustomerIdTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.getCustomerContactByCustomerId(BPUtility.getEncodedString(customer.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		//system.assert(false, newContact);
 		system.assertEquals(newContact.contains('abc'), true);
 		system.assertEquals(customerContact[0].FirstName, 'abc');
 		
    }
    
     /**
     * Name: getCustomerContactByIdTest 
     * Desc: Test to getCustomerContactById.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getCustomerContactByIdTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		//system.assert(false, newContact);
 		system.assertEquals(newContact.contains('abc'), true);
 		system.assertEquals(customerContact[0].FirstName, 'abc');
 		
    }
    
    /**
     * Name: updateCustomerContactTest 
     * Desc: Test to update information for customer contact.
     * @param: 
     * @return: 
    **/
    
    
    static testMethod void updateCustomerContactTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		customerContact[0].FirstName = 'DST';
 		String customercontactsJSONString = System.JSON.serialize(customerContact);
 		String CustomerNewContacts = BPUtility.getDecodedString(ViewCustomerCtrl.updateCustomerContact(BPUtility.getEncodedString(customercontactsJSONString)));
 		List<CustomerContact> customerNewContact = (List<CustomerContact>) System.JSON.deserialize(CustomerNewContacts, List<CustomerContact>.class);
 		system.assertEquals(customerNewContact[0].FirstName, 'DST');
 		
    }
    
    /**
     * Name: updateCustomerContactRelationTest 
     * Desc: Test to update  relation for customer contact.
     * @param: 
     * @return: 
    **/
    
    static testMethod void updateCustomerContactRelationTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(false, 'abc', 'last', customer.Id);
 		contact.Relationship__c = 'Friend';
 		insert contact;
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		customerContact[0].Relation = 'Family';
 		String customercontactsJSONString = System.JSON.serialize(customerContact);
 		String CustomerNewContacts = BPUtility.getDecodedString(ViewCustomerCtrl.updateCustomerContactRelation(BPUtility.getEncodedString(customercontactsJSONString)));
 		List<CustomerContact> customerNewContact = (List<CustomerContact>) System.JSON.deserialize(CustomerNewContacts, List<CustomerContact>.class);
 		system.assertEquals(customerNewContact[0].Relation, 'Family');
 		
    }
    
     /**
     * Name: removeCustomerContactRecordTest 
     * Desc: Test to remove relation for customer contact.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeCustomerContactRecordTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		Contact contact1 = TestUtil.createContact(true, 'DST', 'last', customer.Id);
 		
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.removeCustomerContactRecord(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 
 		system.assertEquals(customerContact.size(), 1);
 		
    }
    
     /**
     * Name: removeCOURecordTest 
     * Desc: Test to remove COUs records.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeCOURecordTest() {
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		Contact contact1 = TestUtil.createContact(true, 'DST', 'last', customer.Id);
 		
 		
 		String newContact = BPUtility.getDecodedString(ViewCustomerCtrl.removeCOURecord(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 
 		system.assertEquals(customerContact.size(), 0);
 		
    }
}