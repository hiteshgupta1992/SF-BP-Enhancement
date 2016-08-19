@isTest
private class RelatedCustomerTest {

	static testMethod void testRelatedCustomer() {
		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Employee');
 		Map<String, String> accountIdToRelationMap = ViewCustomerCtrl.getRelatedCustomerRelationMap(customer.Id);
 		List<Account> relatedCustomerRecList = SOQLUtil.getRelatedAccountRecs(accountIdToRelationMap.keyset());
 		String JSONString = '{}';
 		RelatedCustomer relatedCus = new RelatedCustomer(relatedCustomerRecList[0], accountIdToRelationMap);  
 		
 		Test.startTest();
 		string relatedCustomers = BPUtility.getDecodedString(ViewCustomerctrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id)));
 		List<RelatedCustomer> relatedCustomersList = (List<RelatedCustomer>) System.JSON.deserialize(relatedCustomers, List<RelatedCustomer>.class);
 		Test.stopTest();
        system.assertEquals(relatedCustomersList.size() , 1);
        system.assertEquals(relatedCustomersList[0].Relation , 'Employer');
	}



	static testMethod void testRelatedCustomerBusiness() {
		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Business', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Business', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Employee');
 		//List<Account> customers = SOQLUtil.getCustomer(customer.Id, 'Customer');
 		Map<String, String> accountIdToRelationMap = ViewCustomerCtrl.getRelatedCustomerRelationMap(customer.Id);
 		List<Account> relatedCustomerRecList = SOQLUtil.getRelatedAccountRecs(accountIdToRelationMap.keyset());
 		String JSONString = '{}';
 		Test.startTest();
 		RelatedCustomer relatedCus = new RelatedCustomer(relatedCustomerRecList[0], accountIdToRelationMap);
 		string relatedCustomers = BPUtility.getDecodedString(ViewCustomerctrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id)));
 		List<RelatedCustomer> relatedCustomersList = (List<RelatedCustomer>) System.JSON.deserialize(relatedCustomers, List<RelatedCustomer>.class);
 		Test.stopTest();
        system.assertEquals(relatedCustomersList.size() , 1);
        system.assertEquals(relatedCustomersList[0].Relation , 'Employer');
	}
	
	static testMethod void testRelatedCustomerNoContactNumberBusiness() {
		Account customer =  TestUtil.createCustomer(true, 'DST', null , 'jaipur', null, null, null, false, true, 'Business', 'ds', 'rathore', null, 'abc', null, null, null,'facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', null , 'jaipur', null, null, null, false, true, 'Business', 'ds', 'rathore', null, 'abc', null, null, null ,'facebook', 'twitter', 'linkedin'  );
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Employee');
 		//List<Account> customers = SOQLUtil.getCustomer(customer.Id, 'Customer');
 		Map<String, String> accountIdToRelationMap = ViewCustomerCtrl.getRelatedCustomerRelationMap(customer.Id);
 		List<Account> relatedCustomerRecList = SOQLUtil.getRelatedAccountRecs(accountIdToRelationMap.keyset());
 		String JSONString = '{}';
 		Test.startTest();
 		RelatedCustomer relatedCus = new RelatedCustomer(relatedCustomerRecList[0], accountIdToRelationMap);
 		string relatedCustomers = BPUtility.getDecodedString(ViewCustomerctrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id)));
 		List<RelatedCustomer> relatedCustomersList = (List<RelatedCustomer>) System.JSON.deserialize(relatedCustomers, List<RelatedCustomer>.class);
 		Test.stopTest();
        system.assertEquals(relatedCustomersList.size() , 1);
        system.assertEquals(relatedCustomersList[0].Relation , 'Employer');
	}


}