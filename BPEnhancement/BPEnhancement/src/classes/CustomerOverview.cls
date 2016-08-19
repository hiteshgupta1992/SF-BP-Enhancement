/**
 * Author: Ashish Garg
 * Since: Nov. 7, 2014
 * Name: CustomerOverview
 * Description: Conroller class for CustomerOverview page
**/
public with sharing class CustomerOverview {
	// Customer record
	public Account customer {get; private set;}
	
	// Current page number, mainly used as unique Id in page
	public String currentPN {get; private set;}
	
	// Default country
	public String defaultCountry {get; private set;}
	
	// Default state
	public String defaultState {get; private set;}
	
	// Default price level Id
	public String defaultPriceLId {get; private set;}
	
	// Default sales tax Id
	public String defaultSalesTId {get; private set;}
	
	// Default price level name
	public String defaultPriceLName {get; private set;}
	
	// Default sales tax name
	public String defaultSalesTName {get; private set;}
	
	// Map of Account JSON fields
	public String INDIVIDUAL_CUSTOMER_FIELDS_TO_JSON_MAPPING {get; private set;}
	
	// Map of Account JSON fields
	public String COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING {get; private set;}
	
	/**
     * Name: CustomerOverview
     * Desc: Constructor used to get the customer data
    **/
	public CustomerOverview(){
		if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		currentPN = ApexPages.currentPage().getParameters().get('pageno');
		currentPN = String.escapeSingleQuotes(currentPN);
		
		INDIVIDUAL_CUSTOMER_FIELDS_TO_JSON_MAPPING = JSON.serialize(Constants.INDIVIDUAL_CUSTOMER_FIELDS_TO_JSON_MAPPING);
		COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING = JSON.serialize(Constants.COMAPANY_CUSTOMER_FIELDS_TO_JSON_MAPPING);
		
		Id Customer_ID = ApexPages.currentPage().getParameters().get('C_ID');
		if(Customer_ID != null) {
			Customer_ID = BPUtility.escapeSingleQuotes(Customer_ID);
		}
		
		if(Customer_ID != null && String.valueOf(Customer_ID).length() != 0){
			List<String> customerFields = new List<String>{ 'VIP__c', 'Active__c', 'Is_Vendor__c', 'Type__c',
															'ShippingStreet', 'ShippingState', 'ShippingPostalCode', 'ShippingCountry', 'ShippingCity', 'ShippingAddress', 
															'Sales_Tax__r.Name__c', 'Price_Level__r.Name__c', 'Preferred_Contact__c', 'Mobile__c', 'Fax', 'Email__c', 'Phone',
															'BillingStreet', 'BillingState', 'BillingPostalCode', 'BillingCountry', 'BillingCity', 'BillingAddress',
															'SA_same_as_BA__c'
														};
			String customerQuery = 'Select Id, Name';
			for(String qFields : customerFields){
				customerQuery += ', ' + qFields;
			}
			customerQuery += ' From Account where Id =: Customer_ID';
			customer = (Account)Database.query(customerQuery);
		}else{
			customer = new Account();
		}
	}
	
	/**
     * Name: getCustomerPreferredContactsOptions
     * Desc: Method used to return a list of Preferred contact list item values
     * @param: 
     * @return: String
    **/
    public String getCustomerPreferredContactsOptions(){
		String ObjectApi_name = 'Account';
		String fieldName = 'Preferred_Contact__c';
		String liElementsForPreferredContacts = '';
		
		Map<String, Schema.SObjectType> globalDesMap = Schema.getGlobalDescribe();
        Schema.SObjectType targetType = globalDesMap.get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
        	liElementsForPreferredContacts += '<li><a value="' + a.getValue() + '">' + a.getValue() + '</a></li>';
        }
        
        return liElementsForPreferredContacts;
	}
	
	/**
     * Name: getPriceLevelListItems
     * Desc: Method used to return a list of all Price Level records
     * @param: 
     * @return: String
    **/
    public String getPriceLevelListItems(){
    	if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String PriceLevelListItems = '';
		
		List<Price_Level__c> priceLevels = [Select Id, Name__c, Default__c from Price_Level__c limit : Limits.getLimitDMLRows() - Limits.getDMLRows()];
        
        for (Price_Level__c pl : priceLevels) {
        	PriceLevelListItems += '<li><a value="' + pl.Id + '">' + pl.Name__c + '</a></li>';
        	
        	if(pl.Default__c){
        		defaultPriceLId = pl.Id;
        		defaultPriceLName = pl.Name__c;
        	}
        }
        
        return PriceLevelListItems;
	}
	
	/**
     * Name: getSalesTaxListItems
     * Desc: Method used to return a list of all Price Level records
     * @param: 
     * @return: String
    **/
    public String getSalesTaxListItems(){
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String SalesTaxListItems = '';
		
		List<Sales_Tax__c> salesTaxes = [Select Id, Name__c, Default__c from Sales_Tax__c limit : Limits.getLimitDMLRows() - Limits.getDMLRows()];
        
        for (Sales_Tax__c st : salesTaxes) {
        	SalesTaxListItems += '<li><a value="' + st.Id + '">' + st.Name__c + '</a></li>';
        	
        	if(st.Default__c){
        		defaultSalesTId = st.Id;
        		defaultSalesTName = st.Name__c;
        	}
        }
        
        return SalesTaxListItems;
	}
	
	/**
     * Name: getOrgCountries
     * Desc: Method used to return a list of all Country records
     * @param: 
     * @return: String
    **/
    public String getOrgCountries(){
    	if(AccessControl.ifObjectFieldIsAccessible('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String allCountries = '';
		
		List<Country__c> countryList = [Select Id, Name__c, Default__c from Country__c limit : Limits.getLimitDMLRows() - Limits.getDMLRows()];
        
        for (Country__c ct : countryList) {
        	allCountries += '<li><a value="' + ct.Name__c + '">' + ct.Name__c + '</a></li>';
        	
        	if(ct.Default__c){
        		defaultCountry = ct.Name__c;
        	}
        }
        
        return allCountries;
	}
	
	/**
     * Name: getOrgStates
     * Desc: Method used to return a Map string for of all State records associated with respective countries
     * @param: 
     * @return: String
    **/
    public String getOrgStates(){
    	if(AccessControl.ifObjectFieldIsAccessible('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	Map<String, String> countryToStatesHtmlMap = new Map<String, String>();
		Map<String, List<State__c>> countryToStatesMap = new Map<String, List<State__c>>();
		
		List<State__c> stateRecords = [Select Id, Name__c, Default__c, Country__r.Name__c from State__c limit : Limits.getLimitDMLRows() - Limits.getDMLRows()];
        
        for(State__c st : stateRecords){
        	List<State__c> statesList = (countryToStatesMap.containsKey(st.Country__r.Name__c)) ? countryToStatesMap.get(st.Country__r.Name__c): new List<State__c>();
        	statesList.add(st);
        	countryToStatesMap.put(st.Country__r.Name__c, statesList);
        }
        
        for(String countryName : countryToStatesMap.keySet()){
        	String statesHtmlStr ='';
        	for(State__c st : countryToStatesMap.get(countryName)) {
	        	statesHtmlStr += '<li><a value="' + st.Name__c + '">' + st.Name__c + '</a></li>';
	        	
	        	if(st.Default__c){
	        		defaultState = st.Name__c;
	        	}
	        }
	        countryToStatesHtmlMap.put(countryName, statesHtmlStr);
        }
        
        return JSON.serialize(countryToStatesHtmlMap);
	}
}