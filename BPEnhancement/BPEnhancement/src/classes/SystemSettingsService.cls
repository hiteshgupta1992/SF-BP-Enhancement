/**
 * Author: Tarun Khandelwal
 * Since: Sept. 26, 2014
 * Name: SystemSettingsService
 * Description: Service class to used for data movement.
**/
public with sharing class SystemSettingsService {
    
    /**
     * Name: getJSONForSalesTax
     * Desc: To Convert Sales Tax records into JSON Format 
     * @param: (1) salesTaxIds - List<Id> - Sales Tax records Ids which is to be converted into JSON.
               								If the size of this list is 0(zero). All sales tax records are to be converted into JSON String
     * @return: Converted JSON String for Sales Tax record
    **/
    public static String getJSONForSalesTax(List<Id> salesTaxIds) {
        List<Sales_Tax__c> salesTaxes = SOQLUtil.getSalesTax(salesTaxIds);
        return Utility.createJSON(salesTaxes, Constants.SALES_TAX_FIELDS_TO_JSON_MAPPING, Constants.SALES_TAX_FIELDS_TO_DATA_TYPE_MAPPING, 
                                      new List<Sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForSalesTaxItem
     * Desc: To Convert Sales Tax Item records into JSON Format  
     * @param: (1) salesTaxItemIds - List<Id> - Sales Tax Items record's Ids which is to be converted into JSON.
               									If the size of this list is 0(zero). All sales tax item records are to be converted into JSON String
     * @return: Converted JSON String for Sales Tax Item record(s)
    **/
    public static String getJSONForSalesTaxItem(List<Id> salesTaxItemIds) {
        List<Sales_Tax_Item__c> salesTaxItems = SOQLUtil.getSalesTaxItems(salesTaxItemIds);
        return Utility.createJSON(salesTaxItems, Constants.SALES_TAX_ITEM_FIELDS_TO_JSON_MAPPING, Constants.SALES_TAX_ITEM_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForPriceLevel
     * Desc: To Convert Price Level records into JSON Format  
     * @param: (1) priceLevelIds - List<Id> - Price level record's Ids which is to be converted into JSON.
               								  If the size of this list is 0(zero). All price level records are to be converted into JSON String
     * @return: Converted JSON String for Price Level record(s)
    **/
    public static String getJSONForPriceLevel(List<Id> priceLevelIds) {
        List<Price_Level__c> priceLevels = SOQLUtil.getPriceLevel(priceLevelIds);
        return Utility.createJSON(priceLevels, Constants.PRICE_LEVEL_FIELDS_TO_JSON_MAPPING, Constants.PRICE_LEVEL_FIELDS_TO_DATA_TYPE_MAPPING, 
                                      new List<Sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForCountry
     * Desc: To Convert Country records into JSON Format 
     * @param: (1) countryIdList - List<String> - Country records Ids which is to be converted into JSON.
               									  If the size of this list is 0(zero). All Country records are to be converted into JSON String
               (2) currentNoOfCountry - Integer - Current Number of countries in Grid
     * @return: Converted JSON String for Country record
    **/
    public static String getJSONForCountry(List<String> countryIdList, Integer currentNoOfCountry) {
        List<Country__c> counties = SOQLUtil.getCountry(countryIdList, currentNoOfCountry);
        return Utility.createJSON(counties, Constants.COUNTRY_FIELDS_TO_JSON_MAPPING, Constants.COUNTRY_FIELDS_TO_DATA_TYPE_MAPPING, 
                                      new List<Sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForAllCountries
     * Desc: To Convert All Country records into JSON Format
     * @param :  
     * @return: Converted JSON String for Country record
    **/
    public static String getJSONForAllCountries() {
        List<Country__c> counties = SOQLUtil.getCountry(new List<Id>(), null);
        return Utility.createJSON(counties, Constants.COUNTRY_FIELDS_TO_JSON_MAPPING, Constants.COUNTRY_FIELDS_TO_DATA_TYPE_MAPPING, 
                                      new List<Sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForState
     * Desc: To Convert State records into JSON Format 
     * @param: (1) countryId - String - Country Id which states are to be converted into JSON.
     * @return: Converted JSON String for State record
    **/
    public static String getJSONForState(String countryId) {
        List<State__c> states = SOQLUtil.getStateByCountry(Id.valueOf(countryId));
        return Utility.createJSON(states, Constants.STATE_FIELDS_TO_JSON_MAPPING, Constants.STATE_FIELDS_TO_DATA_TYPE_MAPPING, 
                                      new List<Sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getAutoCompleteJSONForObj
     * Desc: Method used to get a JSON string with Name-Value pair for object records and display values in Autocomplete component on page
     * @param:	(1) sObjName - String - Object API name for which to get records JSON string
     *			(2) filterKey - String - Search string
     * @return: String - SObject records JSON String (Name-Value format)
    **/
    public static String getAutoCompleteJSONForObj(String sObjName, String filterKey) {
        List<sObject> sObjRecords = SOQLUtil.getSObjRecords(sObjName, filterKey);
        return Utility.createAutoCompleteJSONForObj(sObjName, sObjRecords);
    }
    
    /**
     * Name: getJSONForRecentItem
     * Desc: To Convert Recent Item records into JSON Format
     * @param:  
     * @return: Converted JSON String for recent item records
    **/
    public static String getJSONForRecentItem() {
        List<RecentlyViewed> recentItems = SOQLUtil.getRecentItems();
        return Utility.createJSON(recentItems, Constants.RECENT_ITEM_FIELDS_TO_JSON_MAPPING, Constants.RECENT_ITEM_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForCustomer
     * Desc: To Convert Customer records into JSON Format  
     * @param - (1) customerIds - List<Id> - List of customer Ids 
     			(2) currentNoOfCustomer - Integer - Current Number of customers in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String
     * @return: Converted JSON String for Customer record(s)
    **/
    public static String getJSONForCustomer(List<Id> customerIds, Integer currentNoOfCustomer, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Account> customers = SOQLUtil.getAccount(customerIds, currentNoOfCustomer, dropDownNumber, isInactiveIncluded, filterJSON, true);
        List<Id> recentCustomerIdList = SOQLUtil.recentAccountIdList;
        Set<Id> recentCustomerIdSet = new Set<Id>();
        if(recentCustomerIdList.size() > 0) {
        	recentCustomerIdSet.addAll(recentCustomerIdList);
        }
        return Utility.createJsonWithRecentItemsFirst(customers, Constants.CUSTOMER_FIELDS_TO_JSON_MAPPING, Constants.CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING, recentCustomerIdSet, 'Account');
    }
    
	/**
     * Name: getJSONForVendor
     * Desc: To Convert Vendor records into JSON Format  
     * @param - (1) vendorIds - List<Id> - List of Vendor Ids 
     			(2) currentNoOfVendor - Integer - Current Number of Vendors in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String
     * @return: Converted JSON String for Vendor record(s)
    **/
    public static String getJSONForVendor(List<Id> vendorIds, Integer currentNoOfVendor, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Account> vendors = SOQLUtil.getAccount(vendorIds, currentNoOfVendor, dropDownNumber, isInactiveIncluded, filterJSON, false);
        List<Id> recentCustomerIdList = SOQLUtil.recentAccountIdList;
        Set<Id> recentCustomerIdSet = new Set<Id>();
        if(recentCustomerIdList.size() > 0) {
        	recentCustomerIdSet.addAll(recentCustomerIdList);
        }
        return Utility.createJsonWithRecentItemsFirst(vendors, Constants.VENDOR_LIST_FIELDS_TO_JSON_MAPPING, Constants.VENDOR_LIST_FIELDS_TO_DATA_TYPE_MAPPING, recentCustomerIdSet, 'Account');
    }
	
	/**
     * Name: getJSONForPartByPartId
     * Desc: To get Parts into JSON Format of given part (Since part has lookup to itself)
     * @param - (1) partId - String - Part Id in String Format
     * @return: Converted JSON String for Parts Records
    **/
    public static String getJSONForPartByPartId(String partId) {
        String JSONString;
        if(partId != null && partId != '') {
        	Part__c part = (Part__c)SOQLUtil.getPartsByPartId(partId);
        	JSONString = Utility.createJSON(new List<Sobject>{part}, Constants.PART_ALL_FIELDS_TO_JSON_MAPPING, Constants.PART_ALL_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
        } else {
        	JSONString = Utility.createJsonWithDefaultValues();
        }
        return JSONString;
    }
    
	/**
     * Name: getJSONForParts
     * Desc: To get Parts into JSON Format
     * @param - (1) partIds - List<Id> - Part Ids
     			(2) currentNoOfPart - Integer - Current Number of parts in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Parts Records
    **/
    public static String getJSONForParts(List<Id> partIds, Integer currentNoOfPart, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Part__c> parts = SOQLUtil.getParts(partIds, currentNoOfPart, dropDownNumber, isInactiveIncluded, filterJSON);
        
        List<Id> recentPartIdList = SOQLUtil.recentPartIdList;
        Set<Id> recentPartIdSet = new Set<Id>();
        if(recentPartIdList.size() > 0) {
        	recentPartIdSet.addAll(recentPartIdList);
        }
        return Utility.createJsonWithRecentItemsFirst(parts, Constants.PART_FIELDS_TO_JSON_MAPPING, Constants.PART_FIELDS_TO_DATA_TYPE_MAPPING, recentPartIdSet, 'Part__c');
    }
    
    /**
     * Name: getJSONForCategories
     * Desc: To get Categories into JSON Format
     * @param - (1) categoryIds - List<Id> - Category Ids
     			(2) currentNoOfCategory - Integer - Current Number of Categories in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Categories Records
    **/
    public static String getJSONForCategories(List<Id> categoryIds, Integer currentNoOfCategory, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Category__c> categories = SOQLUtil.getCategory(categoryIds, currentNoOfCategory, dropDownNumber, isInactiveIncluded, filterJSON);
        return Utility.createJSON(categories, Constants.CATEGORY_LIST_FIELDS_TO_JSON_MAPPING, Constants.CATEGORY_LIST_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: getJSONForUnitMakes
     * Desc: To get Unit Makes into JSON Format
     * @param - (1) unitMakeIds - List<Id> - Unit Make Ids
     			(2) currentNoOfUnitMakesInGrid - Integer - Current Number of Unit Make records in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Unit Makes Records
    **/
    public static String getJSONForUnitMakes(List<Id> unitMakeIds, Integer currentNoOfUnitMakesInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Unit_Make__c> unitMakes = SOQLUtil.getUnitMakes(unitMakeIds, currentNoOfUnitMakesInGrid, dropDownNumber, isInactiveIncluded, filterJSON);
        return Utility.createJSON(unitMakes, Constants.UNIT_MAKE_LIST_FIELDS_TO_JSON_MAPPING, Constants.UNIT_MAKE_LIST_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
    }
	
	/**
     * Name: getJSONForUnitModelByUnitMakeId
     * Desc: To get Unit Models into JSON Format
     * @param - (1) unitMakeId - String - Parent Unit Make Id
     			(2) currentNoOfUnitModelsInGrid - Integer - Current Number of Unit Models in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Unit Models Records
    **/
    public static String getJSONForUnitModelByUnitMakeId(String unitMakeId, Integer currentNoOfUnitModelsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
        List<Unit_Model__c> unitModels = SOQLUtil.getUnitModelsByUnitMakeId(unitMakeId, currentNoOfUnitModelsInGrid, dropDownNumber, isInactiveIncluded, filterJSON);
        return Utility.createJSON(unitModels, Constants.UNIT_MODEL_LIST_FIELDS_TO_JSON_MAPPING, Constants.UNIT_MODEL_LIST_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>());
    }
    
    /**
     * Name: deleteSalesTax
     * Desc: Method deletes the Sales Tax with Id value
     * @param: (1) stId - Id - Sales Tax Id which is to be deleted
     * @return: If successfull
    **/
    public static boolean deleteSalesTax(Id stId) {
        return SOQLUtil.deleteSalesTax(stId);
    }
    
    /**
     * Name: deleteSalesTaxItem
     * Desc: Method deletes the Sales Tax Item with Id value
     * @param: (1) stiId - Id - Sales Tax Item Id which is to be deleted
     * @return: If successfull
    **/
   public static String deleteSalesTaxItem(Id stiId) {
        SOQLUtil.deleteSalesTaxItem(stiId);
         return getJSONForSalesTax(new List<Id>());
    }
    
    /**
     * Name: deletePriceLevel
     * Desc: Method deletes the Price Level record with Id value
     * @param: (1) plId - Id - Price Level Id which is to be deleted
     * @return: If successfull
    **/
    public static boolean deletePriceLevel(Id plId) {
        return SOQLUtil.deletePriceLevel(plId);
    }
    
    /**
     * Name: getJSONForSalesTaxWrapper
     * Desc: To Convert Wrapper List of Sales Tax Items into JSON Format relating to apllicable taxes records
     * @param: (1) SalesTaxId - String - Sales Tax Id which is to be deleted
     * @return: Converted JSON String for wrapper list of sales tax items
    **/
    public static String getJSONForSalesTaxWrapper(String SalesTaxId) {
        List<Applicable_Taxes__c> applicableTaxes = new List<Applicable_Taxes__c>();
        if(SalesTaxId != null && SalesTaxId.trim().length() != 0){
            applicableTaxes = SOQLUtil.getApplicableTaxes(Id.valueOf(SalesTaxId));
        }
        
        Set<Id> salesTaxItemsIdSet = new Set<Id>();
        for(Applicable_Taxes__c applicableTax : applicableTaxes) {
            salesTaxItemsIdSet.add(applicableTax.Sales_Tax_Item__c);
        }
        List<Sales_Tax_Item__c> salesTaxItems = SOQLUtil.getSalesTaxItems(new List<Id>());
        return createJSONForSalesTaxWrapper(salesTaxItemsIdSet, salesTaxItems, SalesTaxId);
    }
     
    /**
     * Name: createJSONForSalesTaxWrapper
     * Desc: To Convert Wrapper List of Sales Tax Items into JSON Format 
     * @param: (1) salesTaxItemsIdSet - Set<Id> - Set of sales tax Items ids
     		   (2) salesTaxItems - List<Sales_Tax_Item__c> - List of sales tax items records
     		   (3) SalesTaxId - String - Sales Tax Id In String
     * @return: Converted JSON String for wrapper list of sales tax items
    **/
    private static String createJSONForSalesTaxWrapper(Set<Id> salesTaxItemsIdSet, List<Sales_Tax_Item__c> salesTaxItems, String SalesTaxId) {
        List<SalesTaxItemWrapper> sTIWrapperList = new List<SalesTaxItemWrapper>();
        for(Sales_Tax_Item__c salesTaxItemRec : salesTaxItems) {
            if(salesTaxItemsIdSet.contains(salesTaxItemRec.Id)) {
                sTIWrapperList.add(new SalesTaxItemWrapper(true, salesTaxItemRec));   
            } else {
                sTIWrapperList.add(new SalesTaxItemWrapper(false, salesTaxItemRec));
            }
        }
        sTIWrapperList.sort();
        String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        
        Sales_Tax_Item__c salesTaxItemRec = new Sales_Tax_Item__c();
        for(SalesTaxItemWrapper salesTaxItemWrapperRec : sTIWrapperList) {
            salesTaxItemRec = (Sales_Tax_Item__c)salesTaxItemWrapperRec.salesTaxItem;
            generator.writeStartObject();
            generator.writeStringField('ST_Id', SalesTaxId);
            generator.writeStringField('STI_Id', String.valueOf(salesTaxItemRec.Id));
            
            if(salesTaxItemWrapperRec.Is_included) {
                generator.writeBooleanField('Is_included', true);   
            } else {
                generator.writeBooleanField('Is_included', false);
            }
            if(salesTaxItemRec.Name__c == null) {
                salesTaxItemRec.Name__c = '';
            }
            generator.writeStringField('STI_Name', salesTaxItemRec.Name__c);
            generator.writeBooleanField('STI_Active',salesTaxItemRec.Active__c);
            generator.writeNumberField('STI_Rate', salesTaxItemRec.Rate__c);
            generator.writeBooleanField('STI_Tax_Parts',salesTaxItemRec.Tax_Parts__c);
            generator.writeBooleanField('STI_Tax_Labour',salesTaxItemRec.Tax_Labour__c);
            generator.writeBooleanField('STI_Tax_Units',salesTaxItemRec.Tax_Units__c);
            generator.writeBooleanField('STI_Tax_Misc',salesTaxItemRec.Tax_Misc__c);
            generator.writeStringField('STI_Forms_Label', salesTaxItemRec.Forms_Label__c);
            if(salesTaxItemRec.Category__c == null) {
                generator.writeStringField('STI_Category', ' ');
            } else {
                generator.writeStringField('STI_Category', salesTaxItemRec.Category__r.Name);   
            }
            generator.writeEndObject();
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        system.debug(JSONString);
        return JSONString;
    }
    
    /**
     * Name: getPicklistJSONForObjectRecords
     * Desc: Method to generate a JSON string for object record values used in dropdown components
     * @param: (1) objName - String - Object Name
     *		   (2) displayFieldName - String - Display field name in the object
     * @return: Converted JSON String for Object record values
    **/
    public static String getPicklistJSONForObjectRecords(String objName, String displayFieldName) {
        List<sObject> sObjectRecords = SOQLUtil.getRecordsForObj(objName, displayFieldName);
        return Utility.createDropdownJSONForSObjectRecords(sObjectRecords, displayFieldName);
    }
    
    /**
     * Name: getJSONForObjectPicklistField
     * Desc: Method to generate a JSOn string for object picklist field values used in dropdown components
     * @param: (1) objName - String - Object Name
     *		   (2) displayFieldName - String - Display field name in the object
     * @return: Converted JSON String for Object field picklist values
    **/
    public static String getJSONForObjectPicklistField(String objName, String fieldName) {
        List<Schema.PicklistEntry> pick_list_values = SOQLUtil.getPicklistEntryValuesForObjField(objName, fieldName);
        return Utility.createDropdownJSONForPicklistEntries(pick_list_values);
    }
    
    /**
     * Name: ParseJSONForSalesTaxWrapper
     * Desc: To insert Applicable Taxes according to Selected Check Box.
     *       If Selected Check box is true, New Applicable Tax Record is created.
     *       And If Selected Check box is false, Corresponding Applicable Tax Record is deleted.
     * @param: (1) wrapperJsonString - String - JSON formatted String
     		   (2) stiId - Id - Sales Tax Item Id
     * @return: 
    **/
    public static void ParseJSONForSalesTaxWrapper(String wrapperJsonString, Id stiId) {
        JSONParser parser = JSON.createParser(wrapperJsonString);
        while (parser.nextToken() != null) {
            //if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
             //   while (parser.nextToken() !=  JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
                        String salesTaxItemId;
                        String salesTaxId;
                        while (parser.nextToken() !=  JSONToken.END_OBJECT) { 
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                String fieldName = parser.getText();
                                parser.nextToken(); 
                                if(fieldName == 'STI_Id') {
                                    salesTaxItemId = parser.getText();
                                    if(salesTaxItemId == null || salesTaxItemId == ''){
                                        salesTaxItemId = stiId;
                                    }
                                } else if(fieldName == 'ST_Id') {
                                    salesTaxId = parser.getText();
                                } else if(fieldName == 'Is_included') {
                                    if(parser.getBooleanValue()) {
                                        SOQLUtil.addApplicableTax(salesTaxId, salesTaxItemId);
                                    } else {
                                        SOQLUtil.removeApplicableTax(salesTaxId, salesTaxItemId);
                                    }
                                }
                            }
                        }
                    }
              //  }
            //}
        }
    }
    
    
    /**
     * Name: saveSalesTaxJSON
     * Desc: To upsert Sales Tax record into database  
     * @param: (1) JSONString - String - JSON formated String
     * @return: 
    **/
    public static void saveSalesTaxJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	
        Sales_Tax__c salesTax = new Sales_Tax__c();  
        List<Sales_Tax__c> salesTaxList = (List<Sales_Tax__c>)Utility.parseJSON(JSONString, salesTax, Constants.SALES_TAX_JSON_TO_FIELDS_MAPPING, Constants.SALES_TAX_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Sales_Tax__c salesTaxRec : salesTaxList) {
	        if(salesTaxRec != null && salesTaxRec.Name__c != null) {
	            upsert salesTaxRec;
	        }
        }
    }
    
    /**
     * Name: updateCountryJSON
     * Desc: To update Country record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void updateCountryJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsUpdateable('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Country__c country = new Country__c();  
        List<Country__c> countryList = (List<Country__c>) Utility.parseJSON(JSONString, country, Constants.COUNTRY_JSON_TO_FIELDS_MAPPING, Constants.COUNTRY_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Country__c countryRec : countryList) {
	        if(countryRec != null && countryRec.Name__c != null) {
	            update countryRec;
	        }
        }
    }
    
    /**
     * Name: updateStateJSON
     * Desc: To update Country record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void updateStateJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsUpdateable('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        State__c state = new State__c();  
        List<State__c> stateList = (List<State__c>) Utility.parseJSON(JSONString, state, Constants.STATE_JSON_TO_FIELDS_MAPPING, Constants.STATE_FIELDS_TO_DATA_TYPE_MAPPING);
        for(State__c stateRec : stateList) {
	        if(stateRec != null && stateRec.Name__c != null) {
	            update stateRec;
	        }
        }
    }
    
    /**
     * Name: saveSalesTaxItemJSON
     * Desc: To upsert Sales Tax Item record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: String - JSON Formatted String of all Sales Tax rcords
    **/
    public static String saveSalesTaxItemJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Sales_Tax_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Sales_Tax_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Sales_Tax_Item__c salesTaxItem = new Sales_Tax_Item__c();    
        List<Sales_Tax_Item__c> salesTaxItemList = (List<Sales_Tax_Item__c>) Utility.parseJSON(JSONString, salesTaxItem, Constants.SALES_TAX_ITEM_JSON_TO_FIELDS_MAPPING, Constants.SALES_TAX_ITEM_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Sales_Tax_Item__c salesTaxItemRec :salesTaxItemList) {
	        if(salesTaxItemRec != null && salesTaxItemRec.Name__c != null) {
	            upsert salesTaxItemRec;
	        }
	        ParseJSONForSalesTaxWrapper(JSONString,salesTaxItemRec.Id);
        }
        return getJSONForSalesTax(new List<Id>());
    }
    
     /**
     * Name: savePriceLevelJSON
     * Desc: To upsert Price Level record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void savePriceLevelJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Price_Level__c priceLevel = new Price_Level__c();    
        List<Price_Level__c> priceLevelList = (List<Price_Level__c>) Utility.parseJSON(JSONString, priceLevel, Constants.PRICE_LEVEL_JSON_TO_FIELDS_MAPPING, Constants.PRICE_LEVEL_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Price_Level__c priceLevelRec : priceLevelList) {
	        if(priceLevelRec != null && priceLevelRec.Name__c != null) {
	            upsert priceLevelRec;
	        }
        }
    }
    
    /**
     * Name: saveIndividualCustomerJSON
     * Desc: To upsert Individual Customer (Contact) record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: - Id - Id of upserted customer record
    **/
    public static Id saveIndividualCustomerJSON(String JSONString) {
    	if(AccessControl.ifObjectFieldIsAccessible('Contact') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Contact') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); } 
        Contact individualCustomer = new Contact();    
        List<Contact> individualCustomerList = (List<Contact>) Utility.parseJSON(JSONString, individualCustomer, Constants.INDIVIDUAL_CUSTOMER_JSON_TO_FIELDS_MAPPING, Constants.INDIVIDUAL_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING);
        if(individualCustomerList[0] != null) {
            insert individualCustomerList[0];
            return [Select AccountId from Contact where Id =: individualCustomerList[0].Id].AccountId;
        }
        return null;
    }
    
    /**
     * Name: saveComapanyCustomerJSON
     * Desc: To upsert Comapny Customer (Contact) record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: Id - Id of upserted customer record
    **/
    public static Id saveComapanyCustomerJSON(String JSONString) { 
        Account comapnyCustomer = new Account(); 
        
        if(AccessControl.ifObjectFieldIsCreateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }   
        List<Account> comapnyCustomerList = (List<Account>) Utility.parseJSON(JSONString, comapnyCustomer, Constants.COMAPANY_CUSTOMER_JSON_TO_FIELDS_MAPPING, Constants.COMAPANY_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Account comapnyCustomerRec : comapnyCustomerList) {
	        comapnyCustomerRec.Type__c = 'Business';
	        comapnyCustomerRec.Is_Customer__c = true;
	        if(comapnyCustomerRec != null) {
	            upsert comapnyCustomerRec;
	            return comapnyCustomerRec.Id;
	        }
        }
        return null;
    }
    
    /**
     * Name: updateIndividualCustomerJSON
     * Desc: To upsert Individual Customer (Contact) record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: Id - Id of upserted customer record
    **/
    public static Id updateIndividualCustomerJSON(String JSONString) { 
		if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Account individualCustomer = new Account();    
        List<Account> individualCustomerList = (List<Account>) Utility.parseJSON(JSONString, individualCustomer, Constants.COMAPANY_CUSTOMER_JSON_TO_FIELDS_MAPPING, Constants.COMAPANY_CUSTOMER_FIELDS_TO_DATA_TYPE_MAPPING);
       for(Account individualCustomerRec : individualCustomerList) {
	        if(individualCustomerRec != null) {
              individualCustomerRec.Is_Customer__c = true;
              update individualCustomerRec;

              if(AccessControl.ifObjectFieldIsAccessible('Contact') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
              Contact customerContact = [Select Id from Contact where AccountId =: individualCustomer.Id];
              String fName = individualCustomer.Name.split(' ')[0];
              customerContact.FirstName = fName;
              customerContact.LastName = (individualCustomer.Name).substring(fName.length());

              customerContact.MailingStreet = individualCustomer.BillingStreet;
              customerContact.MailingCity = individualCustomer.BillingCity;
              customerContact.MailingState = individualCustomer.BillingState;
              customerContact.MailingCountry = individualCustomer.BillingCountry;
              customerContact.MailingPostalCode = individualCustomer.BillingPostalCode;

              customerContact.OtherStreet = individualCustomer.ShippingStreet;
              customerContact.OtherCity = individualCustomer.ShippingCity;
              customerContact.OtherState = individualCustomer.ShippingState;
              customerContact.OtherCountry = individualCustomer.ShippingCountry;
              customerContact.OtherPostalCode = individualCustomer.ShippingPostalCode;

              customerContact.Phone = individualCustomer.Phone;
              customerContact.Email = individualCustomer.Email__c;
              customerContact.Price_Level__c = individualCustomer.Price_Level__c;
              customerContact.Sales_Tax__c = individualCustomer.Sales_Tax__c;
              if(AccessControl.ifObjectFieldIsUpdateable('Contact') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
              update customerContact;
              return individualCustomer.Id;
         	}
        }
        return null;
    }
    
    /**
     * Name: saveVendorJSON
     * Desc: To upsert Vendor record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: String - Upserted Vendor Record Id 
    **/
    public static String saveVendorJSON(String JSONString) {  
    	if(AccessControl.ifObjectFieldIsCreateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }   
        Account vendor = new Account();
        List<Account> vendorList = (List<Account>) Utility.parseJSON(JSONString, vendor, Constants.VENDOR_LIST_JSON_TO_FIELDS_MAPPING, Constants.VENDOR_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Account vendorRec : vendorList) {
	        vendorRec.Is_Vendor__c = true;
	        if(vendorRec != null && vendorRec.Name != null) {
	            upsert vendorRec;
	            return vendorRec.Id;
	        }
        }
        return null;
    }
    
	/**
     * Name: 
     * Desc: To upsert Part record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: String - Upserted Part Record Id and part Id field in String 
    **/
    public static String savePartJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
        Part__c part = new Part__c();
        List<Part__c> partList = (List<Part__c>) Utility.parseJSON(JSONString, part, Constants.PART_ALL_JSON_TO_FIELDS_MAPPING, Constants.PART_ALL_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Part__c partRec : partList) {
	        try {
	        	upsert partRec;
	        } catch(Exception e) {
	        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
	        	throw e;
	        } 
        }
        if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Part__c> parts = [select Part_ID__c from Part__c where Id = :part.Id];
        return String.valueOf( part.Id)+'|'+ String.valueOf(parts[0].Part_ID__c);
    }
    
    /**
     * Name: saveCategoryJSON
     * Desc: To insert Category record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return:
    **/
    public static void saveCategoryJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Category__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Category__c categoryObj = new Category__c();    
        List<Category__c> categoryObjList = (List<Category__c>) Utility.parseJSON(JSONString, categoryObj, Constants.CATEGORY_LIST_JSON_TO_FIELDS_MAPPING, Constants.CATEGORY_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Category__c categoryObjRec : categoryObjList) {
	        if(categoryObjRec != null && categoryObjRec.Name != null) {
	            try {
	            	upsert categoryObjRec;
	            } catch(Exception e) {
		        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
		        	throw e;
	        	} 
	        }
        }
    }
    
    /**
     * Name: saveUnitMakeJSON
     * Desc: To insert Unit Make record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void saveUnitMakeJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Unit_Make__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Unit_Make__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Unit_Make__c unitMakeObj = new Unit_Make__c();    
        List<Unit_Make__c> unitMakeObjList = (List<Unit_Make__c>) Utility.parseJSON(JSONString, unitMakeObj, Constants.UNIT_MAKE_LIST_JSON_TO_FIELDS_MAPPING , Constants.UNIT_MAKE_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Unit_Make__c unitMakeObjRec : unitMakeObjList) {
	        if(unitMakeObjRec != null && unitMakeObjRec.Name != null) {
	            try {
	            	upsert unitMakeObjRec;
	            } catch(Exception e) {
		        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
		        	throw e;
	        	} 
	        }
        }
    }
    
    /**
     * Name: deleteUnitMakeJSON
     * Desc: To delete Unit Make record from database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void deleteUnitMakeJSON(String JSONString) { 
    	
    	if(AccessControl.ifObjectIsDeletable('Unit_Make__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        Unit_Make__c unitMakeObj = new Unit_Make__c();    
        List<Unit_Make__c> unitMakeObjList = (List<Unit_Make__c>) Utility.parseJSON(JSONString, unitMakeObj, Constants.UNIT_MAKE_LIST_JSON_TO_FIELDS_MAPPING , Constants.UNIT_MAKE_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Unit_Make__c unitMakeObjRec : unitMakeObjList) {
	        if(unitMakeObjRec != null && unitMakeObjRec.Id != null) {
	            try {
	            	delete unitMakeObjRec;
	            } catch(Exception e) {
		        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
		        	throw e;
	        	} 
	        }
        }
    }
    
    /**
     * Name: saveUnitModelJSON
     * Desc: To insert Unit Model record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void saveUnitModelJSON(String JSONString) { 
    	if(AccessControl.ifObjectFieldIsCreateable('Unit_Model__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Unit_Model__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        Unit_Model__c unitModelObj = new Unit_Model__c();    
        
        if(JSONString.contains('Unit_Model_Unit_Make_Id') == false) {
        	Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING.remove('Unit_Model_Unit_Make_Id');
        	Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING.remove('Unit_Model_Unit_Make');
        }
        
        List<Unit_Model__c> unitModelObjList = (List<Unit_Model__c>) Utility.parseJSON(JSONString, unitModelObj, Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING, Constants.UNIT_MODEL_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Unit_Model__c unitModelObjRec : unitModelObjList) {
	        if(unitModelObjRec != null && unitModelObjRec.Name__c != null) {
	            try {
	            	upsert unitModelObjRec;
	            } catch(Exception e) {
		        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
		        	throw e;
	        	}
	        }
        }
    }
    
    /**
     * Name: deleteUnitModelJSON
     * Desc: To delete Unit Model record into database  
     * @param: (1) JSONString - String - JSON formatted String
     * @return: 
    **/
    public static void deleteUnitModelJSON(String JSONString) { 
    	if(AccessControl.ifObjectIsDeletable('Unit_Model__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        Unit_Model__c unitModelObj = new Unit_Model__c();    
        
        Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING.remove('Unit_Model_Unit_Make_Id');
        Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING.remove('Unit_Model_Unit_Make');
        List<Unit_Model__c> unitModelObjList = (List<Unit_Model__c>) Utility.parseJSON(JSONString, unitModelObj, Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING, Constants.UNIT_MODEL_LIST_FIELDS_TO_DATA_TYPE_MAPPING);
        for(Unit_Model__c unitModelObjRec : unitModelObjList) {
	        if(unitModelObjRec != null && unitModelObjRec.Name__c != null) {
	            try {
	            	delete unitModelObjRec;
	            } catch(Exception e) {
		        	e.setMessage(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
		        	throw e;
	        	} 
	        }
        }
    }
    
    /**
     * Name: getJSONForFilteredCustomer
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     		   (3) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Customer records
    **/
	public static String getJSONForFilteredCustomer(String searchingString, String fieldName, Boolean isInactiveIncluded) {
		searchingString = String.escapeSingleQuotes(searchingString);
        String fieldAPIName = Constants.CUSTOMER_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Account> searchedAccounts = SOQLUtil.getFilteredAccount(searchingString, fieldAPIName, false, isInactiveIncluded); 
    	return Utility.createJSONForFilteredResult(searchedAccounts, fieldAPIName);
    }
    
    /**
     * Name: getJSONForFilteredParts
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     * @return: String - JSON Fromatted String of filtered parts records
    **/
	public static String getJSONForFilteredParts(String searchingString, String fieldName) {
		if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		searchingString = String.escapeSingleQuotes(searchingString);
        String query;
        query = 'SELECT '+ Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName) + ' From Part__c Where '+ Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName) +' Like \'' + searchingString +'%\'' ;
    	List<Part__c> searchedParts = Database.query(query);
    	Set<String> partsFilterDataSet = new Set<String>();
    	
    	String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        for(Part__c part : searchedParts) {
        	if(Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName)=='Part_ID__c') {
            	if(!partsFilterDataSet.contains(part.Part_ID__c)) {
            		generator.writeString(part.Part_ID__c); 
            		partsFilterDataSet.add(part.Part_ID__c);
            	}
        	} else if(Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName)=='Description__c') {
        		if(!partsFilterDataSet.contains(part.Description__c)) {
        			generator.writeString(part.Description__c);
        			partsFilterDataSet.add(part.Description__c);
        		}
        	} else if(Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName)=='Location__c') {
        		if(!partsFilterDataSet.contains(part.Location__c)) {
        			generator.writeString(part.Location__c);
        			partsFilterDataSet.add(part.Location__c);
        		}
        	} else if(Constants.PART_JSON_TO_FIELDS_MAPPING.get(fieldName)=='Category__r.Name') {
        		if(!partsFilterDataSet.contains(part.Category__r.Name)) {
        			generator.writeString(part.Category__r.Name);
        			partsFilterDataSet.add(part.Category__r.Name);
        		}
        	}
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    } 
    
    /**
     * Name: getJSONForFilteredCategory
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     * @return: String - JSON Fromatted String of filtered category records
    **/
	public static String getJSONForFilteredCategory(String searchingString, String fieldName) {
		searchingString = String.escapeSingleQuotes(searchingString);
		String fieldAPIName = Constants.CATEGORY_LIST_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Category__c> searchedCategories = SOQLUtil.getFilteredCategory(searchingString, fieldAPIName);
    	return Utility.createJSONForFilteredResult(searchedCategories, fieldAPIName);
    }
    
    /**
     * Name: getJSONForFilteredVendor
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     		   (3) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Vendor records
    **/
	public static String getJSONForFilteredVendor(String searchingString, String fieldName, Boolean isInactiveIncluded) {
		searchingString = String.escapeSingleQuotes(searchingString);
		String fieldAPIName = Constants.VENDOR_LIST_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Account> searchedAccounts = SOQLUtil.getFilteredAccount(searchingString, fieldAPIName, true, isInactiveIncluded); 
    	return Utility.createJSONForFilteredResult(searchedAccounts, fieldAPIName);
    }
    
    /**
     * Name: getJSONForFilteredUnitMakes
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) searchingString - String - Seraching Keywork
     *		   (2) fieldName - Stirng - Field Name for which filter is applied  
     		   (3) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Unit Makes records
    **/
	public static String getJSONForFilteredUnitMakes(String searchingString, String fieldName, Boolean isInactiveIncluded) {
		searchingString = String.escapeSingleQuotes(searchingString);
		String fieldAPIName = Constants.UNIT_MAKE_LIST_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Unit_Make__c> searchedUnitMakes = SOQLUtil.getFilteredUnitMakes(searchingString, fieldAPIName, isInactiveIncluded);
    	return Utility.createJSONForFilteredResult(searchedUnitMakes, fieldAPIName);
    }
    
    /**
     * Name: getJSONForFilteredUnitModels
     * Desc: Method used to return JSON String in case of filtereing
     * @param: (1) unitMakeId - String - Parent Unit Make Id
     		   (2) searchingString - String - Seraching Keywork
     *		   (3) fieldName - Stirng - Field Name for which filter is applied  
     		   (4) isInactiveIncluded - Boolean - true if Inactive records are included 
     * @return: String - JSON Fromatted String of filtered Unit Model records
    **/
	public static String getJSONForFilteredUnitModels(String unitMakeId, String searchingString, String fieldName, Boolean isInactiveIncluded) {
		searchingString = String.escapeSingleQuotes(searchingString);
		String fieldAPIName = Constants.UNIT_MODEL_LIST_JSON_TO_FIELDS_MAPPING.get(fieldName);
		List<Unit_Model__c> searchedUnitModels = SOQLUtil.getFilteredUnitModels(unitMakeId, searchingString, fieldAPIName, isInactiveIncluded);
    	return Utility.createJSONForFilteredResult(searchedUnitModels, fieldAPIName);
    }    
}