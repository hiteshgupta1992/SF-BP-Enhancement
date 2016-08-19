/**
 * Author: Tarun Khandelwal
 * Since: June 05, 2015
 * Name: CustomerViewCtrl
 * Description: Controller Class of Customer Detail Page.
**/
global with sharing class ViewCustomerCtrl {
	public Decimal Home_Search_Grid_Page_Size { get{return GeneralConfiguration.getHomeSearchGridPageSize();} private set;}
    public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
    public boolean Is_Widget_Removeable {get{return GeneralConfiguration.isWidgetRemoveable();}}
    public boolean Load_New_Customer_Order {get{return GeneralConfiguration.isLoadNewCustomerOrder();} private set;}
    public boolean Load_New_UI {get{return GeneralConfiguration.isLoadNewUI();} private set;}
    public boolean Load_New_View_Customer {get{return GeneralConfiguration.isLoadNewViewCustomer();} private set;}
    public Decimal Sales_Tax_Rate {get{return GeneralConfiguration.getAustralianMarketSalesTaxRate();} private set;}
    /**
     * Name: getCustomerInfo
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getCustomerInfo(String customerId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	
        List<Account> customers = SOQLUtil.getCustomer(customerId, 'Customer');
        Map<String, String> accountIdToRelationMap = getRelatedCustomerRelationMap(customerId);
        List<Account> relatedCustomerRecList = SOQLUtil.getRelatedAccountRecs(accountIdToRelationMap.keyset());
        List<Customer_Owned_Unit__c> COUList = SOQLUtil.getCOURecordByFieldName('Account__c', customerId);
        List<Contact> customerContactList = SOQLUtil.getCustomerContactByFieldName('AccountId', customerId);
        List<Business_Profile__c> businessProfileList = SOQLUtil.getBusinessProfileData(new List<Id>());
        String JSONString = '{}';
        //system.assert(false, ActiveOrder.getAllActiveOrdersForCustomer(customerId, null));
        if(customers.size() > 0) {
            JSONString = System.JSON.serialize(new CustomerDetail(customers[0], relatedCustomerRecList, accountIdToRelationMap, COUList, new List<CO_Header__c>(), 
            										customerContactList, getLastVisitOrderByCustomerId(customerId),
            										new List<Tax_Exemption__c>(), businessProfileList));
        }
        return BPUtility.getEncodedString(JSONString);
    }
    
    /**
     * Name: getOtherSimilarCustomer
     * Desc: 
     * @param:  
     * @return:  
    **/
   @RemoteAction
    global static String getSimilarCOUs(String VINNumber){
    	VINNumber = BPUtility.getDecodedString(VINNumber);
    	
        List<Customer_Owned_Unit__c> custOwnedUnits = SOQLUtil.getSimilarCOUs(VINNumber);
        List<CustomerOwnedUnit> custOwnedUnitList = new List<CustomerOwnedUnit>();
        for(Customer_Owned_Unit__c custOwnedUnitRec : custOwnedUnits) {
            if(custOwnedUnitRec.VIN__c != null && custOwnedUnitRec.VIN__c != '') {
                custOwnedUnitList.add(new CustomerOwnedUnit(custOwnedUnitRec));
            }
        }
        return BPUtility.getEncodedString(System.JSON.serialize(custOwnedUnitList));
    }
    
    /**
     * Name: saveCOU
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String saveCOU(String customerId, String couJSONString) {
    	customerId = BPUtility.getDecodedString(customerId);
    	couJSONString = BPUtility.getDecodedString(couJSONString);
    	
        List<CustomerOwnedUnit> couObjList = CustomerOwnedUnit.parse(couJSONString);
        List<Customer_Owned_Unit__c> couListToInsert = new List<Customer_Owned_Unit__c>();
        for(CustomerOwnedUnit couObj : couObjList) {
            Customer_Owned_Unit__c couRec = new Customer_Owned_Unit__c();
            couRec.VIN__c = couObj.VIN;
            couRec.Account__c = customerId;    
            couRec.Colour__c = couObj.Color;
            couRec.Mileage__c = (couObj.Mileage ==  null ) ? 0 : couObj.Mileage ;
            couRec.Plate__c = couObj.Plate;
            couRec.Submodel__c = (couObj.SubModel != '') ? couObj.SubModel : null;
            couRec.Unit_Make__c = (couObj.Make != '') ? couObj.Make : null;
            couRec.Unit_Model__c = (couObj.Model != '') ? couObj.Model : null;
            couRec.Year__c = couObj.Year;
            if(couObj.Id != null) {
                couRec.Id = couObj.Id;
            } 
            couListToInsert.add(couRec);
        }
         
        if(couListToInsert.size() > 0) {
        	if(AccessControl.ifObjectIsUpdateable('Customer_Owned_Unit__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
        	if(AccessControl.ifObjectIsCreateable('Customer_Owned_Unit__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
            upsert couListToInsert ;
        }
        
        return getCOUListByCustomerId(BPUtility.getEncodedString(customerId));
    }
    
    /**
     * Name: getCOUListByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getCOUListByCustomerId(String customerId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	
        List<Customer_Owned_Unit__c> COUList = SOQLUtil.getCOURecordByFieldName('Account__c', customerId);
        List<CustomerOwnedUnit> couObjList = new List<CustomerOwnedUnit>();
        for(Customer_Owned_Unit__c couRec : COUList) {
            couObjList.add(new CustomerOwnedUnit(couRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(couObjList));
    }
    
    /**
     * Name: getCOURecordById
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getCOURecordById(String couId) {
    	couId = BPUtility.getDecodedString(couId);
    	
        List<Customer_Owned_Unit__c> COUList = SOQLUtil.getCOURecordByFieldName('Id', couId);
        List<CustomerOwnedUnit> couObjList = new List<CustomerOwnedUnit>();
        for(Customer_Owned_Unit__c couRec : COUList) {
            couObjList.add(new CustomerOwnedUnit(couRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(couObjList));
    }
    
    /**
     * Name: getRelatedCustomerByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getRelatedCustomerByCustomerId1(String customerId) {
        customerId = BPUtility.getDecodedString(customerId);
        return BPUtility.getEncodedString('[]');
    }
    
    /**
     * Name: getRelatedCustomerByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getRelatedCustomerByCustomerId(String customerId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	
        Map<String, String> accountIdToRelationMap = getRelatedCustomerRelationMap(customerId);
        List<Account> relatedCustomerRecList = SOQLUtil.getRelatedAccountRecs(accountIdToRelationMap.keyset());
        List<RelatedCustomer> relatedCustomerObjList = new List<RelatedCustomer>();
        for(Account relatedCustomerRec : relatedCustomerRecList) {
            relatedCustomerObjList.add(new RelatedCustomer(relatedCustomerRec, accountIdToRelationMap));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(relatedCustomerObjList));
    }
    
    /**
     * Name: getRelatedCustomerByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page (Used in Test class)
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    public static Map<String, String> getRelatedCustomerRelationMap(String customerId) {
    	List<People__c> parentRelatedCustomerList = SOQLUtil.getRelatedCustomer(customerId, true);
        Map<String, String> accountIdToRelationMap = new Map<String, String>();
        for(People__c peopleRec : parentRelatedCustomerList) {
        	accountIdToRelationMap.put(peopleRec.Parent_Customer2__c, peopleRec.Relationship__c);
        }
        
        List<People__c> childRelatedCustomerList = SOQLUtil.getRelatedCustomer(customerId, false);
        for(People__c peopleRec : childRelatedCustomerList) {
        	if(peopleRec.Relationship__c == 'Employee') {
        		peopleRec.Relationship__c = 'Employer';
        	} 
        	accountIdToRelationMap.put(peopleRec.Parent_Customer1__c, peopleRec.Relationship__c);
        }
        return accountIdToRelationMap;
    }
    
    /**
     * Name: addRelatedCustomer
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String updateRelatedCustomer(String relatedCustomerString) {
    	if(AccessControl.ifObjectFieldIsCreateable('People__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('People__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectIsDeletable('People__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('People__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	relatedCustomerString = BPUtility.getDecodedString(relatedCustomerString);
    	
        List<RelatedCustomer> relatedCustomerObjList = RelatedCustomer.parse(relatedCustomerString);
        List<Account> relatedCustomerListToUpsert = new List<Account>();
        List<People__c> peopleRecToInsert = new List<People__c>();
        
        for(RelatedCustomer relatedCustomerObj : relatedCustomerObjList) {
            Account relatedCustomerRec = new Account();
            relatedCustomerRec.Id = relatedCustomerObj.Id;
            List<People__c> peopleList = [select Id from People__c Where (Parent_Customer1__c = :relatedCustomerObj.ParentCustomer AND Parent_Customer2__c = :relatedCustomerObj.Id) OR 
            															(Parent_Customer2__c = :relatedCustomerObj.ParentCustomer AND Parent_Customer1__c = :relatedCustomerObj.Id)]; 
	        if(relatedCustomerObj.Relation != null && relatedCustomerObj.Relation != '') {
	            People__c peopleRec = new People__c();
	            if(peopleList.size() > 0) {
	            	peopleRec.Id = peopleList[0].Id;
	            }
	            peopleRec.Parent_Customer1__c = relatedCustomerObj.ParentCustomer;
	            peopleRec.Parent_Customer2__c = relatedCustomerObj.Id;
	            peopleRec.Relationship__c = relatedCustomerObj.Relation;
	            peopleRecToInsert.add(peopleRec);
	        } else {
	            if(peopleList.size() > 0) {
	            	
	            	delete peopleList[0];
	            }
	        }
	    	relatedCustomerListToUpsert.add(relatedCustomerRec);
        }
        if(relatedCustomerListToUpsert.size() > 0) {
            upsert relatedCustomerListToUpsert;
        }
        if(peopleRecToInsert.size() > 0) {
        	upsert peopleRecToInsert;
        }
        String customerId = '';
        if(relatedCustomerObjList.size() > 0) {
            customerId = relatedCustomerObjList[0].ParentCustomer ;
        }
       
        return getRelatedCustomerByCustomerId(BPUtility.getEncodedString(customerId));
    }
    
    /**
     * Name: getCustomerContactByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getCustomerContactByCustomerId(String customerId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	
        List<Contact> customerContactList = SOQLUtil.getCustomerContactByFieldName('AccountId', customerId);
        List<CustomerContact> customerContactObjList = new List<CustomerContact>();
        for(Contact customerContactRec : customerContactList) {
            customerContactObjList.add(new CustomerContact(customerContactRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(customerContactObjList));
    }
    
    /**
     * Name: getCustomerContactById
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String getCustomerContactById(String customerContactId) {
    	customerContactId = BPUtility.getDecodedString(customerContactId);
    	
        List<Contact> customerContactList = SOQLUtil.getCustomerContactByFieldName('Id', customerContactId);
        List<CustomerContact> customerContactObjList = new List<CustomerContact>();
        for(Contact customerContactRec : customerContactList) {
            customerContactObjList.add(new CustomerContact(customerContactRec));
        }
        return BPUtility.getEncodedString(System.JSON.serialize(customerContactObjList));
    }
    
    
    /**     
     * Name: updateCustomerContact
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String updateCustomerContact(String jsonString) {
    	jsonString = BPUtility.getDecodedString(jsonString);
    	
    	//system.assert(false, jsonString);
        List<CustomerContact> customerContactObjList = CustomerContact.parse(jsonString);
        
        List<Contact> customerContactListToInsert = new List<Contact>();
        for(CustomerContact customerContactObj : customerContactObjList) {
            Contact customerContactRec = new Contact();
            
            customerContactRec.FirstName = customerContactObj.FirstName;
            customerContactRec.LastName = customerContactObj.LastName;
            customerContactRec.Work_Email__c = customerContactObj.Email;
            customerContactRec.Phone = customerContactObj.Phone;
            customerContactRec.Preferred_Email__c = (customerContactObj.PreferredEmail == null) ? false : customerContactObj.PreferredEmail;
            customerContactRec.Preferred_Phone__c = (customerContactObj.PreferredPhone == null) ? false : customerContactObj.PreferredPhone;
            customerContactRec.Preferred_SMS__c = (customerContactObj.PreferredSMS == null)? false : customerContactObj.PreferredSMS;
            customerContactRec.Is_SMS__c = (customerContactObj.IsSMS == null) ? false : customerContactObj.IsSMS;
            customerContactRec.Job_Title__c = customerContactObj.JobTitle;
            customerContactRec.Relationship__c = customerContactObj.Relation;
            customerContactRec.AccountId = customerContactObj.ParentCustomer;
            if(customerContactObj.Id != null) {
            	customerContactRec.Id = customerContactObj.Id;
            }
            customerContactListToInsert.add(customerContactRec);
        }
        //system.assert(false, customerContactListToInsert);
        if(customerContactListToInsert.size() > 0) {
        	if(AccessControl.ifObjectIsCreateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
        	if(AccessControl.ifObjectIsUpdateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
            upsert customerContactListToInsert;
        }
        String customerId = '';
        if(customerContactListToInsert.size() > 0) {
            customerId = customerContactListToInsert[0].AccountId ;
        }
       
        return getCustomerContactByCustomerId(BPUtility.getEncodedString(customerId));
    }
    
    /**
     * Name: updateCustomerContactRelation
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String updateCustomerContactRelation(String jsonString) {
    	jsonString = BPUtility.getDecodedString(jsonString);
    	
    	//system.assert(false, jsonString);
        List<CustomerContact> customerContactObjList = CustomerContact.parse(jsonString);
        List<Contact> customerContactListToInsert = new List<Contact>();
        for(CustomerContact customerContactObj : customerContactObjList) {
            Contact customerContactRec = new Contact();
            customerContactRec.Relationship__c = customerContactObj.Relation;
            customerContactRec.AccountId = customerContactObj.ParentCustomer;
            if(customerContactObj.Id != null) {
            	customerContactRec.Id = customerContactObj.Id;
            }
            customerContactListToInsert.add(customerContactRec);
        }
        //system.assert(false, customerContactListToInsert);
        if(customerContactListToInsert.size() > 0) {
        	if(AccessControl.ifObjectIsCreateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	       	if(AccessControl.ifObjectIsUpdateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
            upsert customerContactListToInsert;
        }
        String customerId = '';
        if(customerContactListToInsert.size() > 0) {
            customerId = customerContactListToInsert[0].AccountId ;
        }
        return getCustomerContactByCustomerId(BPUtility.getEncodedString(customerId));
    }
    
    /**
     * Name: getCustomerContactByCustomerId
     * Desc: To get Customer Inforamtion used in View Customer Page
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    public static String getLastVisitOrderByCustomerId(String customerId) {
        List<CO_Header__c> coHeaderList = SOQLUtil.getLastVisitOrderByCustomerId(customerId);
        String lastTime = '';
        if(coHeaderList.size() > 0) {
        	Long createdDateValue = coHeaderList[0].CreatedDate.getTime();
        	Long currentDateValue = system.now().getTime();
        	lastTime = String.valueOf(Integer.valueOf(((currentDateValue - createdDateValue)/ (1000 * 60 * 60 * 24)) / 30 )) + 'm ';
        	lastTime += String.valueOf(Integer.valueOf( Math.mod(((currentDateValue - createdDateValue)/ (1000 * 60 * 60 * 24)), 30))) + 'd ';
        	lastTime += String.valueOf(Integer.valueOf( Math.mod(((currentDateValue - createdDateValue)/ (1000 * 60 * 60)), 24))) + 'h';
        }
        return lastTime;
    }
    
    /**
     * Name: removeCustomerContactRecord
     * Desc: Remove Record with given Id
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String removeCustomerContactRecord(String customerId, String recordId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	recordId = BPUtility.getDecodedString(recordId);
    	
        List<Sobject> sobjectListToDel = SOQLUtil.getReocrdByGivenId(recordId);
        if(sobjectListToDel.size() > 0) {
        	String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        	if(AccessControl.ifObjectIsDeletable(sObjName) == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
        	delete sobjectListToDel[0];
        }
        return getCustomerContactByCustomerId(BPUtility.getEncodedString(customerId));
    }
    
    /**
     * Name: removeCOURecord
     * Desc: Remove Record with given Id
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Customer info. 
    **/
    @RemoteAction
    global static String removeCOURecord(String customerId, String recordId) {
    	customerId = BPUtility.getDecodedString(customerId);
    	recordId = BPUtility.getDecodedString(recordId);
    	
        List<Sobject> sobjectListToDel = SOQLUtil.getReocrdByGivenId(recordId);
        if(sobjectListToDel.size() > 0) {
        	String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        	if(AccessControl.ifObjectIsDeletable(sObjName) == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
        	delete sobjectListToDel[0];
        }
        return getCOUListByCustomerId(BPUtility.getEncodedString(customerId));
    }
}