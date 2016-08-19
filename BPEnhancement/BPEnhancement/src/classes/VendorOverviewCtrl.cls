/**
 * Author: Tarun Khandelwal
 * Since: Dec. 30, 2014
 * Name: VendorOverviewCtrl
 * Description: Conroller class for VendorOverview page
**/
public with sharing class VendorOverviewCtrl {
	
	// Vendor record
	public Account vendor {get; private set;}
	
	// Current page number, mainly used as unique Id in page
	public String currentPN {get; private set;}
	
	// Default country  
	public String defaultCountry {get{
										if(AccessControl.ifObjectIsAccessible('Country__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
										List<Country__c> countryList = [Select Id, Name__c, Default__c from Country__c where Default__c = true];
								        if(countryList.size() > 0){
								        	return countryList[0].Name__c;
								        }else{
								        	return null;
								        }
								} private set;}
	
	// Default state
	public String defaultState {get{
									if(AccessControl.ifObjectIsAccessible('State__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
									List<State__c> statesList = [Select Id, Name__c, Default__c from State__c where Default__c = true];
							        if(statesList.size() > 0){
							        	return statesList[0].Name__c;
							        }else{
							        	return null;
							        }
								} private set;}
	
	// Default price level Id
	public String defaultPriceLId {get; private set;}
	
	// Default sales tax Id
	public String defaultSalesTId {get; private set;}
	
	// Default price level name
	public String defaultPriceLName {get; private set;}
	
	// Default sales tax name
	public String defaultSalesTName {get; private set;}
	
	// Map of Account JSON fields
	public String VENDOR_LIST_FIELDS_TO_JSON_MAPPING {get; private set;}
	
	
	/**
     * Name: VendorOverviewCtrl
     * Desc: Constructor used to get the vendor data
    **/
	public VendorOverviewCtrl(){
		currentPN = ApexPages.currentPage().getParameters().get('pageno');
		currentPN = String.escapeSingleQuotes(currentPN);
		
		VENDOR_LIST_FIELDS_TO_JSON_MAPPING = JSON.serialize(Constants.VENDOR_LIST_FIELDS_TO_JSON_MAPPING);
		
		Id vendorID = ApexPages.currentPage().getParameters().get('V_ID');
		if(vendorID != null){
		vendorID = String.escapeSingleQuotes(vendorID);
		}	
		if(vendorID != null && String.valueOf(vendorID).length() != 0){
			List<String> vendorFields = new List<String>{ 'VIP__c', 'Active__c', 'Is_Customer__c',
															'ShippingStreet', 'ShippingState', 'ShippingPostalCode', 'ShippingCountry', 'ShippingCity', 'ShippingAddress', 
															'Sales_Tax__r.Name__c', 'Price_Level__r.Name__c', 'Preferred_Contact__c', 'Mobile__c', 'Fax', 'Email__c', 'Phone',
															'BillingStreet', 'BillingState', 'BillingPostalCode', 'BillingCountry', 'BillingCity', 'BillingAddress',
															'SA_same_as_BA__c', 'Purchase_Tax__c', 'Website', 'Vendor_Code__c'
														};
			String customerQuery = 'Select Id, Name';
			for(String qFields : vendorFields){
				customerQuery += ', ' + qFields;
			}
			vendorID = BPUtility.escapeSingleQuotes(vendorID);
			customerQuery += ' From Account where Id =: vendorID';
			
			if(AccessControl.ifObjectIsAccessible('Account') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
			vendor = (Account)Database.query(customerQuery);
		} else {
			vendor = new Account();
		}
		
		// Populate Default Price Level values
		populateDefaultPriceLevelValues();
		
		// Populate Default Sales Tax values
		populateDefaultSalesTaxValues();
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
     * Name: populateDefaultPriceLevelValues
     * Desc: Method used to populate default Price Level values
     * @param: 
     * @return:
    **/
    public void populateDefaultPriceLevelValues(){
    	if(AccessControl.ifObjectIsAccessible('Price_Level__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		List<Price_Level__c> priceLevels = [Select Id, Name__c, Default__c from Price_Level__c where Default__c = true];
        
        if(priceLevels.size() == 1) {
    		defaultPriceLId = priceLevels[0].Id;
    		defaultPriceLName = priceLevels[0].Name__c;
        }
	}
	
	/**
     * Name: populateDefaultSalesTaxValues
     * Desc: Method used to populate default Sales Tax values
     * @param: 
     * @return:
    **/
    public void populateDefaultSalesTaxValues(){
    	if(AccessControl.ifObjectIsAccessible('Sales_Tax__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		List<Sales_Tax__c> salesTaxes = [Select Id, Name__c, Default__c from Sales_Tax__c where Default__c = true];
        
        if(salesTaxes.size() == 1) {
    		defaultSalesTId = salesTaxes[0].Id;
    		defaultSalesTName = salesTaxes[0].Name__c;
        }
	}
}