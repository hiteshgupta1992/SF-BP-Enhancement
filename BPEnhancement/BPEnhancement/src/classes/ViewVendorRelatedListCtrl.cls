/**
 * Author: Ashish Garg
 * Since: July 3, 2015
 * Name: ViewVendorRelatedListCtrl
 * Description: Controller Class of Vendor Related List Component.
**/
global with sharing class ViewVendorRelatedListCtrl {
	public Decimal Home_Search_Grid_Page_Size { get{return GeneralConfiguration.getHomeSearchGridPageSize();} private set;}
    public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
    public boolean Is_Widget_Removeable {get{return GeneralConfiguration.isWidgetRemoveable();}}
    public boolean Load_New_Customer_Order {get{return GeneralConfiguration.isLoadNewCustomerOrder();} private set;}
    public boolean Load_New_UI {get{return GeneralConfiguration.isLoadNewUI();} private set;}
    public boolean Load_New_View_Customer {get{return GeneralConfiguration.isLoadNewViewCustomer();} private set;}
    public Decimal Sales_Tax_Rate {get{return GeneralConfiguration.getAustralianMarketSalesTaxRate();} private set;}
    
	/*****************************	START: PURCHASE ORDER TYPES SECTION	*****************************************/
	/**
     * Name: addPOTypeToVendor
     * Desc: Add a Purchase Order record with supplied values
     * @param:	(1) poTypesJSON - String - JSON formatted array of Purchase Order records need to be inserted
     * @return: String - If a single record is inserted, then return value will be detailed record in JSON format
     *Comments : Try catch and FLS Done
    **/
    @RemoteAction
    global static String addUpdatePOTypeToVendor(String poTypesJSON) {

    	poTypesJSON = BPUtility.getDecodedString(poTypesJSON);
  
    	try{
	    	List<POType> poTypesList = POType.parse(poTypesJSON);
	    	if(poTypesList.size() == 0){
	    		return BPUtility.getEncodedString('[]');
	    	}
			if(getSimilarPOType(BPUtility.getEncodedString(poTypesList[0].Code), BPUtility.getEncodedString(poTypesList[0].VendorId), BPUtility.getEncodedString(poTypesList[0].Id)) == 'true') {
				return 'Same VO Type Code already present for vendor';
			}
			
	    	// Else add the record in database
	    	List<PO_Type__c> poTypesToUpsert = new List<PO_Type__c>();
	    	for(POType poType : poTypesList){
	    		PO_Type__c poTypeRec = new PO_Type__c(	Vendor__c = poType.VendorId,
														Code__c = poType.Code,
														Lead_Time__c = poType.LeadTime,
														Discount__c = poType.Discount,
														Landed_Cost_Adjustment__c = poType.LandedCostAdjustment,
														Usage__c = poType.Usage
													);
	    		if(poType.Id != null) {
	    			poTypeRec.Id = poType.Id;
	    		}
	    		poTypesToUpsert.add(poTypeRec);
	    	}
	    	if(AccessControl.ifObjectFieldIsCreateable('PO_Type__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	    	if(AccessControl.ifObjectIsUpdateable('PO_Type__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
			upsert poTypesToUpsert;
			
			if(poTypesList.size() == 1){
				return BPUtility.getEncodedString(System.JSON.serialize( new List<POType.POTypeWrapper>{new POType.POTypeWrapper(poTypesToUpsert[0], poTypesToUpsert[0].Vendor__c)} ));
			}
	        return BPUtility.getEncodedString('[]');
    	}catch(exception ex){
  		  throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
  		  return BPUtility.getEncodedString('[]');
  	  }
    }
    @RemoteAction
    global static String getSimilarPOType(String poTypeCode, String vendorId, String poTypeId) {
    	poTypeCode = BPUtility.getDecodedString(poTypeCode);
		vendorId = BPUtility.getDecodedString(vendorId);
		poTypeId = BPUtility.getDecodedString(poTypeId);
		poTypeCode = BPUtility.escapeSingleQuotes(poTypeCode);
		vendorId = BPUtility.escapeSingleQuotes(vendorId);
		poTypeId = BPUtility.escapeSingleQuotes(poTypeId);
		if(AccessControl.ifObjectFieldIsAccessible('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<PO_Type__c> poTypeList = [select Id from PO_Type__c where Code__c =: poTypeCode AND Vendor__c =: vendorId AND Id != :poTypeId];
    	String isSimilarPresent;
    	if(poTypeList.size() > 0) {
    		isSimilarPresent = 'true';
    	} else {
    		isSimilarPresent = 'false';
    	}
    	return BPUtility.getEncodedString(isSimilarPresent);

    }
    /**
     * Name: updateDefaultPOType
     * Desc: method to update record as preffered record
     * @param: (1) poTypeId - String - Id of Alternate Vendor junction object record
     * @return: String
     * Comments : Try catch and FLS Done
    **/
    @RemoteAction
    global static String updateDefaultPOType(String vendorId, String poTypeId, boolean defaultValToUpdate) {

    	vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
        poTypeId = Id.valueOf(BPUtility.getDecodedString(poTypeId));
        poTypeId = BPUtility.escapeSingleQuotes(poTypeId);
    	try{
	    	List<PO_Type__c> poTypestoUpdate = new List<PO_Type__c>();
	    	if(defaultValToUpdate){
	    		if(AccessControl.ifObjectFieldIsAccessible('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    		List<PO_Type__c> prevDefaultPOTypes = [Select Id, IsDefault__c from PO_Type__c where IsDefault__c = true AND Id !=: poTypeId AND Vendor__c =: vendorId];
	    		if(prevDefaultPOTypes.size() > 0){
	    			for(PO_Type__c poTypeRec : prevDefaultPOTypes){
	    				poTypeRec.IsDefault__c = false;
	    				poTypestoUpdate.add(poTypeRec);
	    			}
	    		}
	    	}
	        PO_Type__c recToUpdate = new PO_Type__c(Id = poTypeId, IsDefault__c = defaultValToUpdate);
	        poTypestoUpdate.add(recToUpdate);
	        
	        if(AccessControl.ifObjectIsUpdateable('PO_Type__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        update poTypestoUpdate;
	        
	        if(poTypestoUpdate.size() > 1){
	    		String infoMsg = '';
	    		return BPUtility.getEncodedString(String.valueOf(getTotalPOTypesForVendor(vendorId)) + ',' + infoMsg);
	    	}
       		return BPUtility.getEncodedString(String.valueOf(getTotalPOTypesForVendor(vendorId)));
    	}catch(exception ex){
  		  throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
  		  return BPUtility.getEncodedString('');
  	  } 
    }
    
    /**
     * Name: getPOTypeInfoById
     * Desc: Method to get POType record information for POType Id in parameters
     * @param:	(1) poTypeId - Id
     * @return: String - List JSON format for record
    **/
    @RemoteAction
    global static String getPOTypeInfoById(String poTypeId) {
    	poTypeId = Id.valueOf(BPUtility.getDecodedString(poTypeId));
    	try{
	    	if(poTypeId == null){
	    		return '[]';
	    	}
	    	// Else add the record in database
	    	List<PO_Type__c> poTypeRecords = SOQLUtil.getPOTypeRecordsById(new List<Id>{poTypeId} );
			if(poTypeRecords.size() != 0){
				return BPUtility.getEncodedString(System.JSON.serialize( new List<POType>{new POType(poTypeRecords[0])} ));
			}
	        return BPUtility.getEncodedString('[]');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
	/**
     * Name: removePOType
     * Desc: Delete the record
     * @param: (1) poTypeId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String removePOType(String vendorId, String poTypeId, String pageSortAttrsJSON) {
    	vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	poTypeId = Id.valueOf(BPUtility.getDecodedString(poTypeId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	
    	try{
	        PO_Type__c recToDel = new PO_Type__c(Id = poTypeId);
	        if(AccessControl.ifObjectIsDeletable('PO_Type__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	        delete recToDel;
	        return BPUtility.getEncodedString(System.JSON.serialize( new AllPOTypesWrapper(vendorId, pageSortAttrsJSON) ));
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
    /**
     * Name: getPaginatedPOTypesForVendor
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) poTypeId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedPOTypesForVendor(String vendorId, String pageSortAttrsJSON) {
        vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	
        return BPUtility.getEncodedString(System.JSON.serialize( new AllPOTypesWrapper(vendorId, pageSortAttrsJSON) ));
    }
    
    /**
     * Name: getAllPOTypesForVendor
     * Desc: Get all related alternate parts for a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    private static List<POType> getAllPOTypesForVendor(Id vendorId, String pageSortAttrsJSON) {
		List<POType> poTypes = POType.getAllPOTypesForVendor(vendorId, pageSortAttrsJSON);
		return poTypes;
    }
    
    /**
     * Name: getTotalPOTypesForVendor
     * Desc: Get total count for related PO Types of a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    private static Integer getTotalPOTypesForVendor(Id vendorId) {
        //return 500;
        return POType.getTotalPOTypesForVendor(vendorId);
    }
    
    public class AllPOTypesWrapper {
    	// All records
    	public List<POType> POTypes;
    	
    	// Total records
    	public Integer TotalPOTypes;
    	
    	public AllPOTypesWrapper(Id vendorId, String pageSortAttrsJSON){
    		this.poTypes = ViewVendorRelatedListCtrl.getAllPOTypesForVendor(vendorId, pageSortAttrsJSON);
    		this.TotalPOTypes = POType.getTotalPOTypesForVendor(vendorId);
    	}
    }
    /*****************************	END: PURCHASE ORDER TYPES SECTION	*****************************************/
    
    /*****************************	START: ACTIVE ORDERS SECTION	*****************************************/
	/**
     * Name: getAllActiveOrdersForVendor
     * Desc: Get all related active orders for a part record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the active order records
    **/
    private static List<ActiveOrder> getAllActiveOrdersForVendor(Id vendorId, String pageSortAttrsJSON) {
		List<ActiveOrder> activeOrders = ActiveOrder.getAllActiveOrdersForVendor(vendorId, pageSortAttrsJSON);
		return activeOrders;
    }
    
    /**
     * Name: getPaginatedActiveOrdersForVendor
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) vendorId - String
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedActiveOrdersForVendor(String vendorId, String pageSortAttrsJSON) {
        vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	
        return BPUtility.getEncodedString(System.JSON.serialize( new AllActiveOrdersWrapper(vendorId, pageSortAttrsJSON) ));
    }
    
    public class AllActiveOrdersWrapper {
    	// All records
    	public List<ActiveOrder> activeOrders;
    	
    	// Total records
    	public Integer TotalActiveOrders;
    	
    	public AllActiveOrdersWrapper(Id vendorId, String pageSortAttrsJSON){
    		this.activeOrders = ViewVendorRelatedListCtrl.getAllActiveOrdersForVendor(vendorId, pageSortAttrsJSON);
    		this.TotalActiveOrders = ActiveOrder.getTotalActiveOrdersForVendor(vendorId);
    	}
    }
    /*****************************	END: ACTIVE ORDERS SECTION	*****************************************/
    
    /*****************************	START: CONTACT TYPES SECTION	*****************************************/
    /**
     * Name: getVendorContactById
     * Desc: Method to get Contact record information for contact Id in parameters
     * @param:	(1) contactId - Id
     * @return: String - List JSON format for record
    **/
    @RemoteAction
    global static String getVendorContactById(String contactId) {
    	contactId = Id.valueOf(BPUtility.getDecodedString(contactId));
    	
    	if(contactId == null){
    		return BPUtility.getEncodedString('[]');
    	}
    	
    	// Else add the record in database
    	Contact contactRecord = VendorContact.getContactDetailsById(contactId);
		if(contactRecord != null){
			return BPUtility.getEncodedString(System.JSON.serialize( new List<VendorContact>{new VendorContact(contactRecord)} ));
		}

        return BPUtility.getEncodedString('[]');
    }
    
    /**
     * Name: updateContactRelation
     * Desc: method to update record as preffered record
     * @param: (1) vendorId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String updateContactRelation(String vendorId, String contactId, String relationValToUpdate) {
    	vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	contactId = Id.valueOf(BPUtility.getDecodedString(contactId));
    	relationValToUpdate = BPUtility.getDecodedString(relationValToUpdate);
    	try{
	        Contact recToUpdate = new Contact(Id = contactId, Relationship__c = relationValToUpdate);
	        if(AccessControl.ifObjectIsUpdateable('Contact') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        update recToUpdate;

	        
	        return BPUtility.getEncodedString(String.valueOf(getTotalContactsForVendor(vendorId)));
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
	/**
     * Name: removeContact
     * Desc: Delete the record
     * @param: (1) contactId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String removeContact(String vendorId, String contactId, String pageSortAttrsJSON) {
    	vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	contactId = Id.valueOf(BPUtility.getDecodedString(contactId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	try{
        	Contact recToDel = new Contact(Id = contactId);
        	if(AccessControl.ifObjectIsDeletable('Contact') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
        	delete recToDel;
        	return BPUtility.getEncodedString(System.JSON.serialize( new AllContactsWrapper(vendorId, pageSortAttrsJSON) ));
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
    /**
     * Name: getPaginatedContactsForVendor
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) contactId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedContactsForVendor(String vendorId, String pageSortAttrsJSON) {
        vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	
        return BPUtility.getEncodedString(System.JSON.serialize( new AllContactsWrapper(vendorId, pageSortAttrsJSON) ));
    }
    
    /**
     * Name: getAllContactsForVendor
     * Desc: Get all related alternate parts for a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    private static List<VendorContact> getAllContactsForVendor(Id vendorId, String pageSortAttrsJSON) {
		List<VendorContact> contacts = VendorContact.getAllContactsForVendor(vendorId, pageSortAttrsJSON);
		return contacts;
    }
    
    /**
     * Name: saveVendorContact
     * Desc: Save details of contact for vendor
     * @param: (1) contactsJSON - String - Id of Vendor 
     * @return: String - JSON string of Vendor info. 
    **/
    @RemoteAction
    global static String saveVendorContact(String contactsJSON) {
    	contactsJSON = BPUtility.getDecodedString(contactsJSON);
    	
    	try{
	        List<VendorContact> vendorContactObjList = VendorContact.parse(contactsJSON);

	        
	        List<Contact> vendorContactListToInsert = new List<Contact>();
	        for(VendorContact vendorContactObj : vendorContactObjList) {
	            Contact vendorContactRec = new Contact();
	            vendorContactRec.FirstName = vendorContactObj.FirstName;
	            vendorContactRec.LastName = vendorContactObj.LastName;
	            vendorContactRec.Work_Email__c = vendorContactObj.Email;
	            vendorContactRec.Phone = vendorContactObj.Phone;
	            vendorContactRec.Preferred_Email__c = (vendorContactObj.PreferredEmail == null) ? false : vendorContactObj.PreferredEmail;
	            vendorContactRec.Preferred_Phone__c = (vendorContactObj.PreferredPhone == null) ? false : vendorContactObj.PreferredPhone;
	            vendorContactRec.Preferred_SMS__c = (vendorContactObj.PreferredSMS == null)? false : vendorContactObj.PreferredSMS;
	            vendorContactRec.Is_SMS__c = (vendorContactObj.IsSMS == null) ? false : vendorContactObj.IsSMS;
	            vendorContactRec.Job_Title__c = vendorContactObj.JobTitle;
	            vendorContactRec.Extension__c = vendorContactObj.Extension;
	            vendorContactRec.Relationship__c = vendorContactObj.Relation;
	            vendorContactRec.AccountId = vendorContactObj.ParentVendor;
	            if(vendorContactObj.Id != null) {
	            	vendorContactRec.Id = vendorContactObj.Id;

	            }
	            vendorContactListToInsert.add(vendorContactRec);
	        }
	        if(AccessControl.ifObjectFieldIsCreateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	       	if(AccessControl.ifObjectIsUpdateable('Contact') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	        upsert vendorContactListToInsert;
	        if(vendorContactListToInsert.size() > 0) {
	        	return BPUtility.getEncodedString(System.JSON.serialize( new List<VendorContact.VendorContactWrapper>{new VendorContact.VendorContactWrapper(vendorContactListToInsert[0], vendorContactListToInsert[0].AccountId)} ));
	        }
	        return BPUtility.getEncodedString('[]');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
    /**
     * Name: getTotalContactsForVendor
     * Desc: Get total count for related PO Types of a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    private static Integer getTotalContactsForVendor(Id vendorId) {
        return VendorContact.getTotalContactsForVendor(vendorId);
    }
    
    public class AllContactsWrapper {
    	// All records
    	public List<VendorContact> Contacts;
    	
    	// Total records
    	public Integer TotalContacts;
    	
    	public AllContactsWrapper(Id vendorId, String pageSortAttrsJSON){
    		this.contacts = ViewVendorRelatedListCtrl.getAllContactsForVendor(vendorId, pageSortAttrsJSON);
    		this.TotalContacts = VendorContact.getTotalContactsForVendor(vendorId);
    	}
    }
    /*****************************	END: CONTACT TYPES SECTION	*****************************************/
    
    /*****************************	START: PRODUCTS SECTION	*****************************************/
	/**
     * Name: addProductToVendor
     * Desc: Add a Purchase Order record with supplied values
     * @param:	(1) poTypesJSON - String - JSON formatted array of Purchase Order records need to be inserted
     * @return: String - If a single record is inserted, then return value will be detailed record in JSON format
    **/
    @RemoteAction
    global static String addUpdateProductToVendor(String productsJSON) {
    	productsJSON = BPUtility.getDecodedString(productsJSON);
    	try{
	    	List<VendorProduct> productsList = VendorProduct.parse(productsJSON);
	    	if(productsList.size() == 0){
	    		return BPUtility.getEncodedString('[]');
	    	}
	    	
	    	// Else add the record in database
	    	List<Product__c> productsToUpsert = new List<Product__c>();
	    	for(VendorProduct productRec : productsList){
	    		Product__c productRecord = new Product__c(	Vendor__c		= productRec.VendorId,
															Code__c 		= productRec.Code,
															Cost__c 		= productRec.Cost,
															Description__c 	= productRec.Description,
															Price__c 		= productRec.Price,
															Type__c 		= productRec.Type,
															Category__c		= productRec.CategoryId,
															Deductible__c	= productRec.Deductible,
															Mileage__c		= productRec.Mileage,
															Term__c			= productRec.Term
														);
	    		if(productRec.Id != null) {
	    			productRecord.Id = productRec.Id;
	    		}
	    		
	    	
	    		productsToUpsert.add(productRecord);
	    	}
	    	
	    	if(AccessControl.ifObjectFieldIsCreateable('Product__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	       	if(AccessControl.ifObjectIsUpdateable('Product__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
			upsert productsToUpsert;
			
			if(productsList.size() == 1) {
				List<Product__c> productRecords = SOQLUtil.getProductRecordsById(new List<Id>{productsToUpsert[0].Id});
				return BPUtility.getEncodedString(System.JSON.serialize( new List<VendorProduct.ProductWrapper>{new VendorProduct.ProductWrapper(productRecords[0], productsToUpsert[0].Vendor__c)} ));
			}
	        return BPUtility.getEncodedString('[]');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	} 
    }
     /**
     * Name: getSimilarProduct
     * Desc: Method to get similar Products
     * @param:	(1) productCode - Code of Product
     * @return: String - List JSON format for similar record
    **/
    @RemoteAction
    global static String getSimilarProduct(String productCode, String vendorId, String productId) {
    	productCode = BPUtility.getDecodedString(productCode);
		vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
		productId = Id.valueOf(BPUtility.getDecodedString(productId));
		productCode = BPUtility.escapeSingleQuotes(productCode);
		vendorId = BPUtility.escapeSingleQuotes(vendorId);
		productId = BPUtility.escapeSingleQuotes(productId);
		if(AccessControl.ifObjectFieldIsAccessible('Product__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Product__c> productList = [select Id from Product__c where Code__c =: productCode AND Vendor__c =: vendorId AND Id != :productId];
    	String isSimilarPresent;
    	if(productList.size() > 0) {
    		isSimilarPresent = 'true';
    	} else {
    		isSimilarPresent = 'false';
    	}
    	return BPUtility.getEncodedString(isSimilarPresent);

    }


    /**
     * Name: getProductInfoById
     * Desc: Method to get VendorProduct record information for VendorProduct Id in parameters
     * @param:	(1) productId - Id
     * @return: String - List JSON format for record
    **/
    @RemoteAction
    global static String getProductInfoById(String productId) {
    	productId = Id.valueOf(BPUtility.getDecodedString(productId));
    	try{
	    	if(productId == null){
	    		return BPUtility.getEncodedString('[]');
	    	}
	    	
	    	// Else add the record in database
	    	List<Product__c> productRecords = SOQLUtil.getProductRecordsById(new List<Id>{productId} );
			if(productRecords.size() != 0){
				return BPUtility.getEncodedString(System.JSON.serialize( new List<VendorProduct>{new VendorProduct(productRecords[0])} ));
			}
	        return '[]';
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	} 
    }
    
    /**
     * Name: getSystemDefaultCategory
     * Desc: Method to get system default category value as per vendor id
     * @param:	(1) vendorId - Id
     * @return: String - List JSON format for record
    **/
    @RemoteAction
    global static String getSystemDefaultCategory(String vendorId) {
    	vendorId = BPUtility.getDecodedString(vendorId);
    	return PartOverviewCtrl.getDefaultCategory(BPUtility.getEncodedString(vendorId));
    }
    
	/**
     * Name: removeProduct  
     * Desc: Delete the record
     * @param: (1) productId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String removeProduct(String vendorId, String productId, String pageSortAttrsJSON) {
    	vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	productId = Id.valueOf(BPUtility.getDecodedString(productId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	try{
	        Product__c recToDel = new Product__c(Id = productId);
	        if(AccessControl.ifObjectIsDeletable('Product__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	        delete recToDel;
	        return BPUtility.getEncodedString(System.JSON.serialize( new AllProductsWrapper(vendorId, pageSortAttrsJSON) ));
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	} 
    }
    
    /**
     * Name: getPaginatedProductsForVendor
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) productId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedProductsForVendor(String vendorId, String pageSortAttrsJSON) {
        vendorId = Id.valueOf(BPUtility.getDecodedString(vendorId));
    	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
    	
        return BPUtility.getEncodedString(System.JSON.serialize( new AllProductsWrapper(vendorId, pageSortAttrsJSON) ));
    }
    
    /**
     * Name: getAllProductsForVendor
     * Desc: Get all related alternate parts for a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    private static List<VendorProduct> getAllProductsForVendor(Id vendorId, String pageSortAttrsJSON) {
		List<VendorProduct> products = VendorProduct.getAllProductsForVendor(vendorId, pageSortAttrsJSON);
		return products;
    }
    
    /**
     * Name: getTotalProductsForVendor
     * Desc: Get total count for related PO Types of a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    private static Integer getTotalProductsForVendor(Id vendorId) {
        return VendorProduct.getTotalProductsForVendor(vendorId);
    }
    
    public class AllProductsWrapper {
    	// All records
    	public List<VendorProduct> Products;
    	
    	// Total records
    	public Integer TotalProducts;
    	
    	public AllProductsWrapper(Id vendorId, String pageSortAttrsJSON){
    		this.products = ViewVendorRelatedListCtrl.getAllProductsForVendor(vendorId, pageSortAttrsJSON);
    		this.TotalProducts = VendorProduct.getTotalProductsForVendor(vendorId);
    	}
    }
    /*****************************	END: PRODUCTS SECTION	*****************************************/
    
    
    
    /*****************************	START: TAX EXEMPTIONS SECTION	*****************************************/
    /**
     * Name: getAllActiveSalesTax
     * Desc: get all active sales tax list used for tax exemption edit box
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Sales Tax. 
    **/
    @RemoteAction
    global static String getAllActiveSalesTax(String vendorId) {
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Sales_Tax_Item__c> salesTaxItemList = SOQLUtil.getAllSalesTaxItemWithExemptions(vendorId, new Map<String, String>());
        List<TaxExemptions> taxExemptionsList = new List<TaxExemptions>();
        Map<Id, List<String>> salesTaxItemIdToAppliesToList = NewViewCustomerCtrl.getAppliesToList(salesTaxItemList);
        
        for(Sales_Tax_Item__c salesTaxItemRec : salesTaxItemList) {
        	taxExemptionsList.add(new TaxExemptions(salesTaxItemRec, salesTaxItemIdToAppliesToList.get(salesTaxItemRec.Id)));
        }
        return system.JSON.serialize(taxExemptionsList);
    }
    
    /**
     * Name: saveTaxExeptionList
     * Desc: save tax exemption records
     * @param: (1) customerId - String - Id of Customer 
     * @return: String - JSON string of Sales Tax. 
    **/
    @RemoteAction
    global static String saveTaxExeptionList(String vendorId, String taxExemptionJSONString, String taxExemptionPageSortAttrsJSON) {
        List<Tax_Exemption__c> taxExemptionListToInsert = new List<Tax_Exemption__c>();
        List<Tax_Exemption__c> taxExemptionListToDelete = new List<Tax_Exemption__c>();
        PaginationSorting taxExemptionPageSortAttrs = parsePageAttrs(taxExemptionPageSortAttrsJSON);
        
        List<TaxExemptions> taxExemptionObjList = (List<TaxExemptions>) System.JSON.deserialize(taxExemptionJSONString, List<TaxExemptions>.class);
        for(TaxExemptions taxExemptionObj : taxExemptionObjList) {
        	Tax_Exemption__c taxExemptionRec = new Tax_Exemption__c();
        	if(taxExemptionObj.IsSelected && taxExemptionObj.TaxExemptionId == null) {
   				taxExemptionRec.Customer__c = vendorId;
   				taxExemptionRec.Sales_Tax_Item__c = taxExemptionObj.SalesTaxItemId;
   				taxExemptionListToInsert.add(taxExemptionRec);
        	} else if(taxExemptionObj.TaxExemptionId != null) {
        		taxExemptionRec.Id = taxExemptionObj.TaxExemptionId;
        		taxExemptionListToDelete.add(taxExemptionRec);
        	}
        }
        
        if(taxExemptionListToInsert.size() > 0) {
        	if(AccessControl.ifObjectFieldIsCreateable('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	insert taxExemptionListToInsert;
        }
        
        if(taxExemptionListToDelete.size() > 0) {
        	if(AccessControl.ifObjectIsDeletable('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        	delete taxExemptionListToDelete;
        }
        
        // Get all JSON List
        List<Tax_Exemption__c> taxExemptionList = SOQLUtil.getTaxExemptionList(vendorId, new Map<String, String>());
        Integer TotalTaxExemptionRecords = taxExemptionList.size(); 
        taxExemptionList = TaxExemption.getPaginatedRecords(taxExemptionList, taxExemptionPageSortAttrs.CurrentPage, taxExemptionPageSortAttrs.PageSize);
        taxExemptionObjList = new List<TaxExemptions>();
        Map<Id, List<String>> salesTaxItemIdToAppliesToList = CustomerDetail.getAppliesToList(taxExemptionList);
        for(Tax_Exemption__c taxExemptionRec : taxExemptionList) {
    		taxExemptionObjList.add(new TaxExemptions(taxExemptionRec, salesTaxItemIdToAppliesToList.get(taxExemptionRec.Sales_Tax_Item__c)));
    	}
        return system.JSON.serialize(new TaxExemptionJSONWrapper(TotalTaxExemptionRecords, taxExemptionObjList));
    }
    
    
    public class TaxExemptionJSONWrapper {
        public Integer TotalTaxExemptionRecords;
        public List<TaxExemptions> TaxExemptionList;
        
        public TaxExemptionJSONWrapper(Integer TotalTaxExemptionRecords, List<TaxExemptions> TaxExemptionList){
            this.TotalTaxExemptionRecords = TotalTaxExemptionRecords;
            this.TaxExemptionList = TaxExemptionList;
        }
    }
    
    /*****************************	END: TAX EXEMPTIONS SECTION	*****************************************/
    
    /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: PaginationSorting - Class Object
    **/
    public static PaginationSorting parsePageAttrs(String json) {
        return (PaginationSorting) System.JSON.deserialize(json, PaginationSorting.class);
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
    }
}