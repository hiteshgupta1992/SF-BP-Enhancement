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
private class NewViewCustomerCtrlTest {
 
    /**
     * Name: getCustomerInfoTest 
     * Desc: Test to fetch customer information on customerId.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getCustomerInfoTest() {
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;  
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, null);
        
 		Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, Customer.Id, null, null, null, 'VIN123');
		String coLineItems = BPUtility.getDecodedString(CustomerOrderCtrl.addCustomer(BPUtility.getEncodedString(coHeader1.Id), BPUtility.getEncodedString(customer.Id)));
		String customerInfo = BPUtility.getDecodedString(NewViewCustomerCtrl.getCustomerInfo(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
         
        
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
 		
 		String similarCOUs = BPUtility.getDecodedString(NewViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN123')));
     	List<CustomerOwnedUnit> CustomerOwnedUnits = (List<CustomerOwnedUnit>) System.JSON.deserialize(similarCOUs, List<CustomerOwnedUnit>.class);
        system.assertEquals(CustomerOwnedUnits.size() , 1);
        
        String similarCOUs1 = BPUtility.getDecodedString(NewViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN1234')));
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
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account Customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		Account Customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
 		
 		Unit_Make__c UnitMake =  TestUtil.createUnitMake(true, 'unitMakeName', 'VIN', true);
 		Unit_Model__c UnitModel = testutil.createUnitModel(true, 'unitModelName', 'VIN', true, unitMake.Id);
 		Customer_Owned_Unit__c  customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, Customer.Id, UnitMake.Id, UnitModel.Id, null, 'VIN123');
 		
 		Test.starttest();
 		String similarCOUs = BPUtility.getDecodedString(NewViewCustomerCtrl.getSimilarCOUs(BPUtility.getEncodedString('VIN123')));
 		String saveCOUs = BPUtility.getDecodedString(NewViewCustomerCtrl.saveCOU(BPUtility.getEncodedString(Customer1.Id), BPUtility.getEncodedString(similarCOUs), BPUtility.getEncodedString(System.JSON.serialize(pageSort)))); 
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
 		
 		
 		string COUList = BPUtility.getDecodedString(NewViewCustomerCtrl.getCOURecordById(BPUtility.getEncodedString(customerOwnedUnit.Id)));
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
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Employee');
 		
 		
 		string relatedCustomers = BPUtility.getDecodedString(NewViewCustomerCtrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		RelatedCustomerJSONWrapper RelatedCustomer = (RelatedCustomerJSONWrapper) System.JSON.deserialize(relatedCustomers, RelatedCustomerJSONWrapper.class);
        system.assertEquals(RelatedCustomer.RelatedCustomerList.size() , 1);
        system.assertEquals(RelatedCustomer.RelatedCustomerList[0].Relation , 'Employer');
        
    }
    
    
   /**
     * Name: updateRelatedCustomerTest 
     * Desc: Test to update information for RelatedCustomer.
     * @param: 
     * @return: 
    **/
    
    
   static testMethod void updateRelatedCustomerTest() {
   		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(false, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Account customerA =  TestUtil.createCustomer(true, 'DST1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		
 		
 		customer.ParentId = customerA.Id ;
 		insert customer;    
 		People__c relationship = TestUtil.createPeople(true, customer.Id, customerA.Id, 'Friend');
 		   
 		String customerInfo = BPUtility.getDecodedString(NewViewCustomerCtrl.getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerA.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		RelatedCustomerJSONWrapper RelatedCustomer = (RelatedCustomerJSONWrapper) System.JSON.deserialize(customerInfo, RelatedCustomerJSONWrapper.class);
 		//List<RelatedCustomer> customers = (List<RelatedCustomer>) System.JSON.deserialize(customerInfo, List<RelatedCustomer>.class);
 		RelatedCustomer.RelatedCustomerList[0].Relation = 'Family' ;
 		  
 		String customersJSONString = System.JSON.serialize(RelatedCustomer.RelatedCustomerList);
 		String updatedCustomerRelationship =  BPUtility.getDecodedString(NewViewCustomerCtrl.updateRelatedCustomer(BPUtility.getEncodedString(customersJSONString), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		RelatedCustomerJSONWrapper customersWithNewRelation = (RelatedCustomerJSONWrapper) System.JSON.deserialize(updatedCustomerRelationship, RelatedCustomerJSONWrapper.class);
 		system.assertEquals(customersWithNewRelation.RelatedCustomerList[0].Relation , 'Family');
 		/*
 		RelatedCustomer.RelatedCustomerList[0].Relation = null ;
 		
 		String customersJSONString1 = System.JSON.serialize(RelatedCustomer);
 		String updatedCustomerRelationship1 =  NewViewCustomerCtrl.updateRelatedCustomer(customersJSONString1, System.JSON.serialize(pageSort));
 		List<RelatedCustomer> customersWithNewRelation1 = (List<RelatedCustomer>) System.JSON.deserialize(updatedCustomerRelationship1, List<RelatedCustomer>.class);
 		//system.assert(false, customersWithNewRelation1);
 		system.assertEquals(customersWithNewRelation1.size() , 0);*/
 		
    }
    
    
   /**
     * Name: getCustomerContactByCustomerIdTest 
     * Desc: Test to ugetCustomerContactByCustomerId.
     * @param: 
     * @return: 
    **/
    
    static testMethod void getCustomerContactByCustomerIdTest() {
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.getCustomerContactByCustomerId(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		CustomerContactJSONWrapper CustomerContact = (CustomerContactJSONWrapper) System.JSON.deserialize(newContact, CustomerContactJSONWrapper.class);
 		//system.assert(false, CustomerContact);
 		system.assertEquals(CustomerContact.TotalContactRecords, 1);
 		system.assertEquals(CustomerContact.ContactList[0].FirstName, 'abc');
 		
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
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
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
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id); 
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		customerContact[0].FirstName = 'DST';
 		String customercontactsJSONString = System.JSON.serialize(customerContact);
 		String CustomerNewContacts = BPUtility.getDecodedString(NewViewCustomerCtrl.updateCustomerContact(BPUtility.getEncodedString(customercontactsJSONString), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		CustomerContactJSONWrapper CustomerContact1 = (CustomerContactJSONWrapper) System.JSON.deserialize(CustomerNewContacts, CustomerContactJSONWrapper.class);
 		//system.assert(false, CustomerContact);
 		system.assertEquals(CustomerContact1.ContactList[0].FirstName, 'DST');
 		
    }
    
    
   /**
     * Name: updateCustomerContactRelationTest 
     * Desc: Test to update  relation for customer contact.
     * @param: 
     * @return: 
    **/
    
    static testMethod void updateCustomerContactRelationTest() {
    	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(false, 'abc', 'last', customer.Id);
 		contact.Relationship__c = 'Friend';
 		insert contact;
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.getCustomerContactById(BPUtility.getEncodedString(contact.Id)));
 		List<CustomerContact> customerContact = (List<CustomerContact>) System.JSON.deserialize(newContact, List<CustomerContact>.class);
 		customerContact[0].Relation = 'Family';
 		String customercontactsJSONString = System.JSON.serialize(customerContact);
 		String CustomerNewContacts = BPUtility.getDecodedString(NewViewCustomerCtrl.updateCustomerContactRelation(BPUtility.getEncodedString(customercontactsJSONString), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		CustomerContactJSONWrapper CustomerContactObject = (CustomerContactJSONWrapper) System.JSON.deserialize(CustomerNewContacts, CustomerContactJSONWrapper.class);
 		system.assertEquals(CustomerContactObject.ContactList[0].Relation, 'Family');
 		
    }
    
   /**
     * Name: removeCustomerContactRecordTest 
     * Desc: Test to remove relation for customer contact.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeCustomerContactRecordTest() {
     	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		Contact contact1 = TestUtil.createContact(true, 'DST', 'last', customer.Id);
 		
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.removeCustomerContactRecord(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(contact.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		CustomerContactJSONWrapper CustomerContact = (CustomerContactJSONWrapper) System.JSON.deserialize(newContact, CustomerContactJSONWrapper.class);
 
 		system.assertEquals(CustomerContact.ContactList.size(), 1);
 		
    }
    
   /**
     * Name: removeCOURecordTest 
     * Desc: Test to remove COUs records.
     * @param: 
     * @return: 
    **/
    
     static testMethod void removeCOURecordTest() {
     	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
 		Account customer =  TestUtil.createCustomer(true, 'DST', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual', 'ds', 'rathore', '9783764669', 'abc', 'work@work.com', 'other@other.com', '1234567890','facebook', 'twitter', 'linkedin'  );
 		Contact contact = TestUtil.createContact(true, 'abc', 'last', customer.Id);
 		Contact contact1 = TestUtil.createContact(true, 'DST', 'last', customer.Id);
 		
 		
 		String newContact = BPUtility.getDecodedString(NewViewCustomerCtrl.removeCOURecord(BPUtility.getEncodedString(customer.Id), BPUtility.getEncodedString(contact.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		CustomerOwnedUnitJSONWrapper CustomerOwnedUnit = (CustomerOwnedUnitJSONWrapper) System.JSON.deserialize(newContact, CustomerOwnedUnitJSONWrapper.class);
 
 		system.assertEquals(CustomerOwnedUnit.CustomerOwnedUnitList.size(), 0);
 		
    }
    
    
    
    /**
     * Name: removeCOURecordTest 
     * Desc: Test to remove COUs records.
     * @param: 
     * @return: 
    **/
    
     static testMethod void getActiveOrdersListByCustomerIdTest() {
     	PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;  
        pageSort.PageSize =  10;
        pageSort.Sorting = new List<SortAttrs>{new SortAttrs('Item', 'ASC')};
        
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, null);
        Account testCustomer = TestUtil.createCustomer(true, 'Test Customer', 'a.b@gmail.com', 'Jaipur', '987456123');
        String coLineItems = BPUtility.getDecodedString(CustomerOrderCtrl.addCustomer(BPUtility.getEncodedString(coHeader1.Id), BPUtility.getEncodedString(testCustomer.Id)));
        
 		
 		String ActiveOrderJSON = BPUtility.getDecodedString(NewViewCustomerCtrl.getActiveOrdersListByCustomerId(BPUtility.getEncodedString(testCustomer.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
 		ActiveOrderJSONWrapper ActiveOrderObj = (ActiveOrderJSONWrapper) System.JSON.deserialize(ActiveOrderJSON, ActiveOrderJSONWrapper.class);
 
 		system.assertEquals(ActiveOrderObj.ActiveSalesOrderList.size(), ActiveOrderObj.TotalActiveSalesOrderRecords);
 		
    }
    
    // Wrapper class for pagination and sorting combination
    public class PaginationSorting {
        
        // Current page number
        public Integer CurrentPage;
        
        // Current page size
        public Integer PageSize;
        
        // Sorting list
        public List<SortAttrs> Sorting;
    }
    
    // SortAttrs for sorting attributes
    public class SortAttrs {
        // Field name
        public String FieldName;
        
        // Sort direction
        public String SortDirection;
        
        public SortAttrs(String FieldName, String SortDirection){
            this.FieldName = FieldName;
            this.SortDirection = SortDirection;
        }
    }
    
    
    public class RelatedCustomerJSONWrapper {
    	public Integer TotalCustomerRecords;
    	public List<RelatedCustomer> RelatedCustomerList;
    	
    	public RelatedCustomerJSONWrapper(Integer TotalCustomerRecords, List<RelatedCustomer> RelatedCustomerList){
    		this.TotalCustomerRecords = TotalCustomerRecords;
    		this.RelatedCustomerList = RelatedCustomerList;
    	}
    }
    
    public class CustomerContactJSONWrapper {
    	public Integer TotalContactRecords;
    	public List<CustomerContact> ContactList;
    	
    	public CustomerContactJSONWrapper(Integer TotalContactRecords, List<CustomerContact> ContactList){
    		this.TotalContactRecords = TotalContactRecords;
    		this.ContactList = ContactList;
    	}
    }
    
    public class CustomerOwnedUnitJSONWrapper {
    	public Integer TotalCOURecords;
    	public List<CustomerOwnedUnit> CustomerOwnedUnitList;
    	
    	public CustomerOwnedUnitJSONWrapper(Integer TotalCOURecords, List<CustomerOwnedUnit> CustomerOwnedUnitList){
    		this.TotalCOURecords = TotalCOURecords;
    		this.CustomerOwnedUnitList = CustomerOwnedUnitList;
    	}
    }
    
    public class ActiveOrderJSONWrapper {
    	public Integer TotalActiveSalesOrderRecords;
    	public List<ActiveSalesOrder> ActiveSalesOrderList;
    	
    	public ActiveOrderJSONWrapper(Integer TotalActiveSalesOrderRecords, List<ActiveSalesOrder> ActiveSalesOrderList){
    		this.TotalActiveSalesOrderRecords = TotalActiveSalesOrderRecords;
    		this.ActiveSalesOrderList = ActiveSalesOrderList;
    	}
    }
    
}