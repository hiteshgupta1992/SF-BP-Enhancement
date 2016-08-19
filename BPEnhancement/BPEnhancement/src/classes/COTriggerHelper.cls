/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: COTriggerHelper
 * Description: Helper class for triggers on CO Header object
**/
public with sharing class COTriggerHelper {
	
	// List to store trigger new list
    public static List<CO_Header__c> COHeaderNewList = new List<CO_Header__c>();
    
    // List to store trigger old list
    public static List<CO_Header__c> COHeaderOldList = new List<CO_Header__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, CO_Header__c> COHeaderNewMap = new Map<Id, CO_Header__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, CO_Header__c> COHeaderOldMap = new Map<Id, CO_Header__c>();
    
    // Variable to stop nested looping
    public static Boolean isTriggerExecute = false;
    
    // List to store Default sales tax
    public static List<Sales_Tax__c> defaultSalesTax;
    
    public static List<Price_Level__c> defaultPriceLevel;
    
	
	 /**
     * Name: beforeInsertOperation
     * Desc: Before Insert Method
     * @param: 
     * @return: 
    **/
	public static void beforeInsertOperation() {
		populatePriceLevelRelatedField();
	}
	
	 /**
     * Name: beforeUpdateOperation
     * Desc: Before Update Method
     * @param: 
     * @return: 
    **/
	public static void beforeUpdateOperation() {
		if(entryConditionForBeforeUpdate()) {
			populatePriceLevelRelatedField();
			SOTriggerHelper.isTriggerRun = true;
			populateSalesTaxRelatedFieldOnSOHeader();
			//setPriceLevelForRelatedCOLIs();
			populateSearchTag();
		}
	}
	
	 /**
     * Name: entryConditionForBeforeUpdate
     * Desc: Before Update Condition
     * @param: 
     * @return: Boolean is ValidEntry or not
    **/
	private static Boolean entryConditionForBeforeUpdate() {
		Boolean isValidEntry = false;
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(COHeaderNewMap.get(coHeaderRec.Id).Customer__c != COHeaderOldMap.get(coHeaderRec.Id).Customer__c) {
				isValidEntry = true;
			}
		}
		return isValidEntry;
	}
	
	// Search Tag Format - Customer Name, 
	private static void populateSearchTag() {
		if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<CO_Header__c> coHeaderList = [select Customer__r.Name, Search_Tag__c, 
												(select Search_Tag__c from CO_Invoice_Headers__r) from CO_Header__c 
												where Id IN: COHeaderNewList AND Customer__c != null];
		Set<Id> accountIdSet = new Set<Id>();
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(coHeaderRec.Customer__c != null ) {
				accountIdSet.add(coHeaderRec.Customer__c);
			}
		}
		
		Map<Id, Account> customerMap = new Map<Id, Account>([select Id, Name from Account where Id IN: accountIdSet]);
												
		List<CO_Invoice_Header__c> coInvoiceHeaderList = new List<CO_Invoice_Header__c>();
		for(CO_Header__c coHeaderRec : coHeaderList) {
			String newCustomerName = customerMap.get(COHeaderNewMap.get(coHeaderRec.Id).Customer__c).Name;
			COHeaderNewMap.get(coHeaderRec.Id).Search_Tag__c = newCustomerName + ',';
			for(CO_Invoice_Header__c coInvoiceHeaderRec : coHeaderRec.CO_Invoice_Headers__r) {
				coInvoiceHeaderRec.Search_Tag__c = newCustomerName + ',';
				coInvoiceHeaderList.add(coInvoiceHeaderRec);
			}
		}
		if(coInvoiceHeaderList.size() > 0) {
			
			update coInvoiceHeaderList;
		}
	}
	
	 /**
     * Name: setPriceLevelForRelatedCOLIs
     * Desc: Setting Price Level for Related Line Items
     * @param: 
     * @return: 
    **/
	public static void setPriceLevelForRelatedCOLIs() {
		if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		List<CO_Header__c> coHeaderList = [select Customer__c, Discount_Markup_From_Prive_Level__c, Part_Price_Base_From_Price_Level__c,
												(select Part__c, CO_Kit_Header__c, Id from CO_Line_Items__r) from CO_Header__c where Id IN : COHeaderNewList];
		
		List<Id> partIdList = new List<Id>();
		for(CO_Header__c COHeaderRec : coHeaderList) {
    		for(CO_Line_Item__c coLineItemRec : COHeaderRec.CO_Line_Items__r) {
    			if(coLineItemRec.CO_Kit_Header__c != null) {
	                continue;
	            }
    			partIdList.add(coLineItemRec.part__c);
    		}
    	}
    				
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Id, Average_Cost__c, Last_Cost__c, MSRP__c, Retail_Price__c from Part__c where Id IN : partIdList]);
    	List<CO_Line_Item__c> coLineItemListToUpdate = new List<CO_Line_Item__c>();
    	
    	for(CO_Header__c coHeaderRec : coHeaderList) {
    		coLineItemListToUpdate.addAll(TaxCalculation.partPriceCalculation(coHeaderRec.Part_Price_Base_From_Price_Level__c, coHeaderRec.Discount_Markup_From_Prive_Level__c, 
    													coHeaderRec.CO_Line_Items__r, partIdToPartRecordMap));
    	}						
    	
    	if(coLineItemListToUpdate.size() > 0) {
    		update coLineItemListToUpdate;
    	}
	}
	
	/**
     * Name: populatePriceLevelRelatedField
     * Desc: Populating Price Level Releted Field
     * @param: 
     * @return: 
    **/
	private static void populatePriceLevelRelatedField() {
		if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
		List<Id> customerIdList = new List<Id>();
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(coHeaderRec.Customer__c != null) {
				customerIdList.add(coHeaderRec.Customer__c);
			}
		}
		
		Map<Id, Account> customerMap = new Map<Id, Account>();
		if(customerIdList.size() > 0) {
			customerMap = new Map<Id, Account>([select Price_Level__c, Price_Level__r.Discount_Markup__c, Price_Level__r.Part_Price_Base__c, 
													Price_Level__r.Labour_Rate__c from Account where Id IN : customerIdList]);
		}
		
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(coHeaderRec.Customer__c != null && customerMap.containsKey(coHeaderRec.Customer__c) && customerMap.get(coHeaderRec.Customer__c).Price_Level__c != null) {
				coHeaderRec.Discount_Markup_From_Prive_Level__c = customerMap.get(coHeaderRec.Customer__c).Price_Level__r.Discount_Markup__c;
				coHeaderRec.Part_Price_Base_From_Price_Level__c = customerMap.get(coHeaderRec.Customer__c).Price_Level__r.Part_Price_Base__c;
				coHeaderRec.Labour_Rate_From_Price_Level__c = customerMap.get(coHeaderRec.Customer__c).Price_Level__r.Labour_Rate__c;
			} else {
				if(defaultPriceLevel == null) {
					defaultPriceLevel = getDefaultPriceLevel();
				} 
				coHeaderRec.Discount_Markup_From_Prive_Level__c = (defaultPriceLevel.size() > 0) ? defaultPriceLevel[0].Discount_Markup__c : 0;
				coHeaderRec.Part_Price_Base_From_Price_Level__c = (defaultPriceLevel.size() > 0) ? defaultPriceLevel[0].Part_Price_Base__c : null;
				coHeaderRec.Labour_Rate_From_Price_Level__c = (defaultPriceLevel.size() > 0) ? defaultPriceLevel[0].Labour_Rate__c : 0;
			}
		}
	}
	
	/**
     * Name: populateSalesTaxRelatedFieldOnSOHeader
     * Desc: Populating Seles Tax Releted Field
     * @param: 
     * @return: 
    **/
	private static void populateSalesTaxRelatedFieldOnSOHeader() {
		if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		List<Id> customerIdList = new List<Id>();
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(coHeaderRec.Customer__c != null) {
				customerIdList.add(coHeaderRec.Customer__c);
			}
		}
		
		Map<Id, Account> customerMap = new Map<Id, Account>();
		if(customerIdList.size() > 0) {
			customerMap = new Map<Id, Account>([select Sales_Tax__c, Sales_Tax__r.Labour_Tax__c	from Account where Id IN : customerIdList]);
		}
		
		if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		Map<Id, CO_Header__c> coHeaderMap = new Map<Id, CO_Header__c>([select Id, (select Labour_Tax__c from Service_Order_Headers__r) from CO_Header__c where Id IN: COHeaderNewList]);
		List<Service_Order_Header__c> soHeaderListToUpdate = new List<Service_Order_Header__c>();
		
		for(CO_Header__c coHeaderRec : COHeaderNewList) {
			if(coHeaderRec.Customer__c != null && customerMap.containsKey(coHeaderRec.Customer__c) && customerMap.get(coHeaderRec.Customer__c).Sales_Tax__c != null) {
				for(Service_Order_Header__c soHeaderRec : coHeaderMap.get(coHeaderRec.Id).Service_Order_Headers__r) {
					soHeaderRec.Labour_Tax__c = customerMap.get(coHeaderRec.Customer__c).Sales_Tax__r.Labour_Tax__c;
					soHeaderListToUpdate.add(soHeaderRec);
				}
			} else {
				if(defaultSalesTax == null) {
					getDefaultSalesTax();
				}
				for(Service_Order_Header__c soHeaderRec : coHeaderMap.get(coHeaderRec.Id).Service_Order_Headers__r) {
					soHeaderRec.Labour_Tax__c = defaultSalesTax[0].Labour_Tax__c;
					soHeaderListToUpdate.add(soHeaderRec);
				}
			}
		}
		
		if(soHeaderListToUpdate.size() > 0) {
			update soHeaderListToUpdate;
		}
	}
	
    /**
     * Name: afterUpdateCalculation
     * Desc: Method to Calculate Part Price tax when co header record is updated
     * @param: 
     * @return: 
    **/
    public static void afterUpdateCalculation() {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Part_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
    	if(isTriggerExecute) {
    		return;
    	}
    	Boolean isValidEntry = false;
    	for(CO_Header__c coHeaderRec : COHeaderNewList)  {
    		if(COHeaderNewMap.get(coHeaderRec.Id).Customer__c != COHeaderOldMap.get(coHeaderRec.Id).Customer__c) {
    			isValidEntry = true;
    		}	
    	}	
    	
    	if(!isValidEntry) {
    		return;
    	}
    	isTriggerExecute = true;
    	
    	// Set price level in related COLIs.
    	setPriceLevelForRelatedCOLIs();
    	
    	// To get oreder Line Item List
    	Map<Id, Map<Id, Sobject>> COHeaderIdToCOLineItemIdToPartRecordMap = new Map<Id, Map<Id, Sobject>>();
		Map<Id, List<Sobject>> COHeaderIdToCOLineItemRecordsMap = new Map<Id, List<Sobject>>();
		List<Id> partIdList = new List<Id>();
    	List<Id> salesTaxIdList = new List<Id>();
    	
    	List<CO_Header__c> COHeaderList = [select Id, (select Part__c, Retail__c, Price__c From CO_Line_Items__r), Customer__r.Price_Level__r.Part_Price_Base__c, Customer__r.Price_Level__r.Discount_Markup__c, Customer__r.Sales_Tax__c, Customer__r.Sales_Tax__r.Rate__c From CO_Header__c where Id IN : Trigger.new];
    	
    	for(CO_Header__c COHeaderRec : COHeaderList) {
    		for(CO_Line_Item__c coLineItemRec : COHeaderRec.CO_Line_Items__r) {
    			partIdList.add(coLineItemRec.part__c);
    		}
    		if(COHeaderRec.Customer__r.Sales_Tax__c == null) {
    			getDefaultSalesTax();
    			salesTaxIdList.add(defaultSalesTax[0].Id);
    		} else {
    			salesTaxIdList.add(COHeaderRec.Customer__r.Sales_Tax__c);
    		}
    	}
    	
    	Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Id, Average_Cost__c, Last_Cost__c, MSRP__c, Retail_Price__c, (select Sales_Tax_Item__c from Part_Taxes__r) from Part__c where Id IN : partIdList]);
    	
    	for(CO_Header__c COHeaderRec : COHeaderList) {
    		Map<Id, Sobject> coLineItemToPartRecordMap = new Map<Id, Sobject>();
    		for(CO_Line_Item__c coLineItemRec : COHeaderRec.CO_Line_Items__r) {
    			coLineItemToPartRecordMap.put(coLineItemRec.Id, partIdToPartRecordMap.get(coLineItemRec.part__c));
    		}
    		COHeaderIdToCOLineItemIdToPartRecordMap.put(COHeaderRec.Id, coLineItemToPartRecordMap);
			COHeaderIdToCOLineItemRecordsMap.put(COHeaderRec.Id, COHeaderRec.CO_Line_Items__r);
    	}
    	List<CO_Line_Item__c> coLineItemListToUpdate = new List<CO_Line_Item__c>();
    	
    	/*for(CO_Header__c COHeaderRec : COHeaderList) {
    		if(COHeaderRec.Customer__c == null || COHeaderRec.Customer__r.Price_Level__c == null) {
    			
    			coLineItemListToUpdate.addAll(TaxCalculation.partPriceCalculation(defaultPriceLevel[0].Part_Price_Base__c, defaultPriceLevel[0].Discount_Markup__c, COHeaderIdToCOLineItemRecordsMap.get(COHeaderRec.Id), COHeaderIdToCOLineItemIdToPartRecordMap.get(COHeaderRec.Id)));
    		} else { // if(COHeaderOldMap.get(COHeaderRec.Id).Customer__c != COHeaderNewMap.get(COHeaderRec.Id).Customer__c) {
				coLineItemListToUpdate.addAll(TaxCalculation.partPriceCalculation(COHeaderRec.Customer__r.Price_Level__r.Part_Price_Base__c, COHeaderRec.Customer__r.Price_Level__r.Discount_Markup__c, COHeaderIdToCOLineItemRecordsMap.get(COHeaderRec.Id), COHeaderIdToCOLineItemIdToPartRecordMap.get(COHeaderRec.Id)));    			
    		} 
    	}
    	
    	if(coLineItemListToUpdate.size() > 0) {
    		update coLineItemListToUpdate;
    	}*/
		
		
		Map<Id, Set<Id>> partIdToSalesTaxItemIdsMap = new Map<Id, Set<Id>>();
		for(Part__c partRec : partIdToPartRecordMap.values()) {
			Set<Id> salesTaxIdSet = new Set<Id>();
			for(Part_Tax__c partTaxRec : partRec.Part_Taxes__r) {
				salesTaxIdSet.add(partTaxRec.Sales_Tax_Item__c);
			}
			partIdToSalesTaxItemIdsMap.put(partRec.Id, salesTaxIdSet);
		}
		
		coLineItemListToUpdate = new List<CO_Line_Item__c>(); 
		// Sales Tax Calculation
		coLineItemListToUpdate.addAll(TaxCalculation.salesTaxCalculation(salesTaxIdList, partIdToSalesTaxItemIdsMap, COHeaderList, COHeaderIdToCOLineItemRecordsMap, defaultSalesTax)); 
		if(coLineItemListToUpdate.size() > 0) {
			if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update coLineItemListToUpdate;
    	} 
    }
    
    /**
     * Name: getDefaultPriceLevel
     * Desc: Method to get Default Price Level In system
     * @param: 
     * @return:  List<Price_Level__c> - List of default price level. Ideally size of list - 1 
    **/
    private static List<Price_Level__c> getDefaultPriceLevel() {
    	if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	defaultPriceLevel = [select Part_Price_Base__c, Discount_Markup__c, Labour_Rate__c from Price_Level__c where Default__c = true];
    	return defaultPriceLevel;
    }
    
    /**
     * Name: getDefaultSalesTax
     * Desc: Method to populate Default Sales Tax In system
     * @param: 
     * @return:   
    **/
    private static void getDefaultSalesTax() {
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	defaultSalesTax = [select Rate__c, Labour_Tax__c from Sales_Tax__c where default__c = true];
    }
    
    
    /**
     * Name: updateAccountFields
     * Desc: Method to update account fields when CO header is updated.
     * @param: 
     * @return: 
    **/
    public static void updateAccountFields() {
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
    	Boolean isValidEntry = false;
    	for(CO_Header__c coHeaderRec : COHeaderNewList)  {
    		if(COHeaderNewMap.get(coHeaderRec.Id).Customer__c != COHeaderOldMap.get(coHeaderRec.Id).Customer__c) {
    			isValidEntry = true;
    		}	
    	}
    	if(!isValidEntry) {
    		return;
    	}
    	
    	List<Id> customersIdList = new List<Id>();
    	for(CO_Header__c coHeaderRec : COHeaderNewList) {
    		if(coHeaderRec.Customer__c != null) {
    			customersIdList.add(coHeaderRec.Customer__c);
    		}
    	}
    	List<User> currentUserList = SOQLUtil.getCurrentUserInfo();
    	Boolean isAustralianMarket = false;
    	if(currentUserList[0].LocaleSidKey == 'en_AU') {
    		isAustralianMarket = true;
    	}
    	
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Account> customerList = [select Name, Orders_Lifetime__c, Open_Orders__c, Average_Spend_per_Order__c, (select Id, Order_status__c, Total_Order_Value__c, Total_Order_Tax__c from CO_Headers__r) from Account Where Id IN : customersIdList];
    	for(Account customerRec : customerList) {
    		customerRec.Orders_Lifetime__c =  customerRec.CO_Headers__r.size();
    		Integer openOrdersCount = 0;
    		Decimal totalSpendOrder = 0;
    		for(CO_Header__c coHeaderRec : customerRec.CO_Headers__r) {
    			if(coHeaderRec.Order_status__c == 'Open') {
    				openOrdersCount++;
    			}
    			if(!isAustralianMarket) {
    				totalSpendOrder += coHeaderRec.Total_Order_Value__c + coHeaderRec.Total_Order_Tax__c; 
    			} else {
    				totalSpendOrder += coHeaderRec.Total_Order_Value__c;
    			}
    		}
    		customerRec.Average_Spend_per_Order__c = totalSpendOrder / customerRec.Orders_Lifetime__c;
    		customerRec.Open_Orders__c = openOrdersCount;
    	}
    	if(customerList.size() > 0) {
    		if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		update customerList;
    	}
    }
}