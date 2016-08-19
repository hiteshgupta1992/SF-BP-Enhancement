/**
 * Author: Ashish Garg
 * Since: Sept. 24, 2014
 * Name: BlackPurlContentCtrl
 * Description: Conroller class for BlackPurlContent page
**/
global with sharing class BlackPurlContentCtrl {
    
    // Boolean variables to control display of top level links related contents
    public boolean displaySystemWideSettings        {get; private set;}
    public boolean displayDefaultsANDCustomization  {get; private set;}
    public boolean displayTools                     {get; private set;}
    public boolean displaySecurityANDPermission     {get; private set;}
    
    // Boolean variables to control display of list items panel within top level link toggles
    public boolean displaySalesTaxes    {get; private set;}
    public boolean displaypriceLevels   {get; private set;}
    public boolean displayCountries     {get; private set;}
    public boolean displayCustomers 	{get; set;}
    public boolean displayParts 		{get; set;}
    
    // Boolean variable to check if more link is clicked of country sections
    public static Boolean isIncreaseCountriesMethodExecuted = false;
    
    // Boolean variable to check if more link is clicked of Customers sections
    public static Boolean isIncreaseCustomersMethodExecuted = false;
    
	// Boolean variable to check if more link is clicked of Vendor sections
    public static Boolean isIncreaseVendorsMethodExecuted = false;
	
    // Boolean variable to check if more link is clicked of Parts sections
    public static Boolean isIncreasePartsMethodExecuted = false;
    
    // Boolean variable to check if more link is clicked of Category sections
    public static Boolean isIncreaseCateoriesMethodExecuted = false;
    
    // Boolean variable to check if more link is clicked of Unit Make sections
    public static Boolean isIncreaseUnitMakesMethodExecuted = false;
    
    // Boolean variable to check if more link is clicked of Unit Model sections
    public static Boolean isIncreaseUnitModelsMethodExecuted = false;
    
    // Integer property to store number of country
    public static Integer currentNoOfCountry;
    
    // Integer property to store number of customers
    public static Integer currentNoOfCustomers;
    
    // Variable to store drop down selected value
    public static Integer dropDownSelectedNumber {get; set;}
    
    // Variable to store selected customer id in string format
    public static String selectedCustomerId {get; set;}
    
	// Variable to store selected vendor id in string format
    public static String selectedVendorId {get; set;}

    // Variable to store selected part id in string format
    public static String selectedPartId {get; set;}
    
    // Selected list links to open
    public String selectedSWSLink       {get; set;}
    
    // To store the result If user is system admin
    public Boolean isUserSystemAdmin {get; set;} 
    
    // Variables to check if user has permission to access grids
    public Boolean isUserHasPermissionToAccessSalesTax {get; set;}
    public Boolean isUserHasPermissionToAccessSalesTaxItem {get; set;}
    public Boolean isUserHasPermissionToAccessPriceLevel {get; set;}
    public Boolean isUserHasPermissionToAccessCountry {get; set;}
    
    // To store the number of parts retrived in case of filter of parts
    public static String partsRetrived;
    
    // To store the number of customers retrived in case of filter of customers
    public static String customersRetrived;
    
    // To store the number of parts retrived in case of filter 
    public static String filterRecordsRetrived;
    
    // Integer property to store current number of page size
    public static Integer currentNoOfCustomerByCustomSetting {
        get {
            if(dropDownSelectedNumber != null) {
                return dropDownSelectedNumber;
            }
            Configurations__c config = Configurations__c.getInstance();
            if(config.NumberOfCustomersRecordPageSize__c == null) {
                config.NumberOfCustomersRecordPageSize__c = 0;
            }
            Integer noOfCustomer = Integer.valueOf(config.NumberOfCustomersRecordPageSize__c);
            if(noOfCustomer < 20) {
                noOfCustomer = 20;
            } else if(noOfCustomer > 100){
                noOfCustomer = 100;
            }
            return noOfCustomer;
            }
        set; 
    }
        
    /**
     * Name: BlackPurlContentCtrl
     * Desc: Constructor
    **/
    global BlackPurlContentCtrl(){
        
        // On page load, defaul show system wide defaults content
        setDisplayVars(true, false, false, false);
        checkUserProfile();
        checkUserPermission();
        setDropDownVariable();
    }
    
    /**
     * Name: setDropDownVariable
     * Desc: Method to set dropdown number at the time of loading of grid..
     * @param: 
     * @return: 
    **/
    private void setDropDownVariable() {
    	List<Customer_Page_Size__c> customerPageSize = SOQLUtil.getCustomerPageSize(); 
		if(customerPageSize.size() > 0) {
			dropDownSelectedNumber = (Integer)customerPageSize[0].Drop_Down_Number__c;
		}
    }
    
    /**
     * Name: checkUserPermission
     * Desc: Method to check User's permission regarding object.
     * @param: 
     * @return: 
    **/
    private void checkUserPermission() {
        isUserHasPermissionToAccessSalesTax = SOQLUtil.checkUserToAccessOnObject(Constants.NAMESPACE + 'Sales_Tax__c');
        isUserHasPermissionToAccessSalesTaxItem = SOQLUtil.checkUserToAccessOnObject(Constants.NAMESPACE + 'Sales_Tax_Item__c');
        isUserHasPermissionToAccessPriceLevel = SOQLUtil.checkUserToAccessOnObject(Constants.NAMESPACE + 'Price_Level__c'); 
        isUserHasPermissionToAccessCountry = SOQLUtil.checkUserToAccessOnObject(Constants.NAMESPACE + 'Country__c');
    }
    
    /**
     * Name: checkUserProfile
     * Desc: Set boolean property if user is system admin.
     * @param: 
     * @return: 
    **/
    private void checkUserProfile() {
         isUserSystemAdmin = SOQLUtil.checkUserProfile(); 
    }
    
    /**
     * Name: setDisplaySystemWideSettings
     * Desc: Set boolean properties so to display only "System wide defaults" content on page
     * @param: 
     * @return: PageReference
    **/
    public PageReference setDisplaySystemWideSettings(){
        setDisplayVars(true, false, false, false);
        displaySalesTaxes = displaypriceLevels = displayCountries = false;
        displayCustomers = false;
        displayParts = false;
        return null;
    }
    
    /**
     * Name: initDisplaySWSContent
     * Desc: Method initialize the System Wide Settings link contents
     * @param: 
     * @return: PageReference
    **/
    public PageReference initDisplaySWSContent(){
        if(selectedSWSLink == Label.SystemWideSetting_SalesTaxesLabel){
            displaySalesTaxes = true;
        }else if(selectedSWSLink == Label.SystemWideSetting_PriceLevelsLabel){
            displaypriceLevels = true;
        } else if(selectedSWSLink == Label.SystemWideSetting_CountryLabel){
            displayCountries = true;
        } 
        return null;
    }
    
    /**
     * Name: initDisplayCustomers
     * Desc: Method to initialize Customers Grid
     * @param: 
     * @return: PageReference
    **/
	public PageReference initDisplayCustomers(){
		displaySalesTaxes = displaypriceLevels = displayCountries = false;
		displaySystemWideSettings = false;
		displayParts = false;
		return null;
	}
	
	/**
     * Name: initDisplayParts
     * Desc: Method to initialize Parts Grid
     * @param: 
     * @return: PageReference
    **/
	public PageReference initDisplayParts(){
		displaySalesTaxes = displaypriceLevels = displayCountries = false;
		displaySystemWideSettings = false;
		displayCustomers = false;
		return null;
	}
	
	/**
     * Name: setCustomerCustomSetting
     * Desc: Method to initialize the the drop down number
     * @param: 
     * @return: PageReference
    **/
	public PageReference setCustomerCustomSetting() {
		if(AccessControl.ifObjectFieldIsCreateable('Customer_Page_Size__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(AccessControl.ifObjectFieldIsUpdateable('Customer_Page_Size__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		List<Customer_Page_Size__c> customerPageSize = SOQLUtil.getCustomerPageSize();
		if(customerPageSize.size() > 0) {
			customerPageSize[0].Drop_Down_Number__c = dropDownSelectedNumber;
			update customerPageSize;
		} else {
			Customer_Page_Size__c currentCustPageSize = new Customer_Page_Size__c();
			currentCustPageSize.User__c = UserInfo.getUserId();
			currentCustPageSize.Drop_Down_Number__c = dropDownSelectedNumber;
			insert currentCustPageSize;
		}
		return null;
	}
    
    /**
     * Name: setDisplayDefaultsANDCustomization
     * Desc: Set boolean properties so to display only "Defaults & Customizations" content on page
     * @param: 
     * @return: PageReference
    **/
    public PageReference setDisplayDefaultsANDCustomization(){
        setDisplayVars(false, true, false, false);
        return null;
    }
    
    /**
     * Name: setDisplayDefaultsANDCustomization
     * Desc: Set boolean properties so to display only "Tools" content on page
     * @param: 
     * @return: PageReference
    **/
    public PageReference setDisplayTools(){
        setDisplayVars(false, false, true, false);
        return null;
    }
    
    /**
     * Name: setDisplaySecurityANDPermission
     * Desc: Set boolean properties so to display only "Security & Permissions" content on page
     * @param: 
     * @return: PageReference
    **/
    public PageReference setDisplaySecurityANDPermission(){
        setDisplayVars(false, false, false, true);
        return null;
    }
    
    /**
     * Name: getCategoryPicklistValues
     * Desc: Method returns picklist values for all categories available.
     * @param: 
     * @return: String
    **/
    @RemoteAction
    global static String getCategoryPicklistValues(){
        return BPUtility.getEncodedString(Utility.getPicklistValues(SOQLUtil.getAllCategories(), false, 'Name', 'Name'));
    }
    
    /**
     * Name: getPriceLevelPriceBookPicklistValues
     * Desc: Method returns picklist values for field part price base of price level object.
     * @param: 
     * @return: String
    **/
    @RemoteAction
    global static String getPriceLevelPriceBookPicklistValues(){
        return BPUtility.getEncodedString(Utility.getPicklistValues('Price_Level__c.Part_Price_Base__c'));
    }
    
    /**
     * Name: getCategoryTypePicklistValues
     * Desc: Method returns picklist values for field type of category object.
     * @param: 
     * @return: String
    **/
    @RemoteAction
    global static String getCategoryTypePicklistValues(){
        return BPUtility.getEncodedString(Utility.getPicklistValues('Category__c.Type__c'));
    }
    
    /**
     * Name: setDisplayVars
     * Desc: Method used to set the display boolean values by parameter values
     * @param: (1) displaySystemWideSettings - boolean - true if system wide settings is displayed
     		   (2) displayDefaultsANDCustomization - boolean - true if Defaults AND Customization is displayed
     		   (3) displayTools - boolean - true if tools section is displayed
     		   (4) displaySecurityANDPermission - boolean - true if Security AND Permissions section is displayed
     * @return: PageReference
    **/
    private void setDisplayVars(boolean displaySystemWideSettings, 
                                boolean displayDefaultsANDCustomization, 
                                boolean displayTools, 
                                boolean displaySecurityANDPermission
                                ){
        this.displaySystemWideSettings          = displaySystemWideSettings;
        this.displayDefaultsANDCustomization    = displayDefaultsANDCustomization;
        this.displayTools                       = displayTools;
        this.displaySecurityANDPermission       = displaySecurityANDPermission;
    }
    
    /**
     * Name: getJSONForAllSalesTax
     * Desc: To get all Sales Tax into JSON Format 
     * @param : 
     * @return: Converted JSON String for All Sales Tax records
    **/
    @RemoteAction
    global static String getJSONForAllSalesTax() {
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTax(new List<Id>()));
    }
    
    /**
     * Name: getJSONForSalesTaxWrapper
     * Desc: To Convert Sales Tax Item into JSON Format 
     * @param : SalesTaxId - String - Sales Tax Id
     * @return: Converted JSON String for Sales Tax Item Records
    **/
    @RemoteAction
    global static String getJSONForSalesTaxWrapper(String SalesTaxId) {
    	SalesTaxId = BPUtility.getDecodedString(SalesTaxId);
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTaxWrapper(SalesTaxId));
    }
    
    /**
     * Name: generateJSONForCountries
     * Desc: To get Country Records into JSON Format
     * @param :  currentNoOfCountryInGrid - Integer - Cuurent Number of country records in Grid
     * @return: Converted JSON String for Country Object
    **/
    @RemoteAction
    global static String generateJSONForCountries(Integer currentNoOfCountryInGrid) {
        currentNoOfCountry = currentNoOfCountryInGrid;
        if(currentNoOfCountry == null) {
            currentNoOfCountry = 0;
        }
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForCountry(new List<Id>(), currentNoOfCountry)); 
    }
    
    /**
     * Name: getJSONForStateByCountry
     * Desc: To Convert State Records into JSON Format of given country
     * @param: countryId - String - Country Id in String
     * @return: Converted JSON String for State Records
    **/
    @RemoteAction
    global static String getJSONForStateByCountry(String countryId) {
    	countryId = BPUtility.getDecodedString(countryId);
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForState(countryId));
    }
    
    /**
     * Name: generateJSONForAllCountries
     * Desc: To Convert All Country Records into JSON Format
     * @param :  
     * @return: Converted JSON String for Country Records
    **/
    @RemoteAction
    global static String generateJSONForAllCountries() {
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForAllCountries()); 
    }
    
    /**
     * Name: getJSONForAllPriceLevels
     * Desc: To get All Price Levels into JSON Format 
     * @param: 
     * @return: Converted JSON String for Price Level Records
    **/
    @RemoteAction
    global static String getJSONForAllPriceLevels() {
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForPriceLevel(new List<Id>()));
    }
    
    /**
     * Name: getJSONForAllCustomer
     * Desc: To Convert Customers into JSON Format
     * @param - (1) currentNoOfCustomersInGrid - Integer - Current Number of customers in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: Converted JSON String for Customers Records
    **/
    @RemoteAction
    global static String getJSONForAllCustomer(Integer currentNoOfCustomersInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
   		return BPUtility.getEncodedString(SystemSettingsService.getJSONForCustomer(new List<Id>(), currentNoOfCustomersInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
    
    /**
     * Name: getJSONForParts
     * Desc: To get Parts into JSON Format
     * @param - (1) currentNoOfPartsInGrid - Integer - Current Number of parts in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Parts Records
    **/
    @RemoteAction
    global static String getJSONForParts(Integer currentNoOfPartsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForParts(new List<Id>(), currentNoOfPartsInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
    
    /**
     * Name: getJSONForPartByPartId
     * Desc: To get Parts into JSON Format of given part (Since part has lookup to itself)
     * @param - (1) partId - String - Part Id in String Format
     * @return: Converted JSON String for Parts Records
    **/
    @RemoteAction
    public static String getJSONForPartByPartId(String partId) {
    	partId = BPUtility.getDecodedString(partId);
        return BPUtility.getEncodedString(SystemSettingsService.getJSONForPartByPartId(partId));
    }
    
    /**
     * Name: getJSONForObjectPicklistField
     * Desc: Method to generate a JSON string for object picklist field values used in dropdown components
     * @param: (1) objName - String - Object Name
     *		   (2) fieldName - String - Picklist type field name in the object
     * @return: Converted JSON String for Object field picklist values
    **/
    @RemoteAction
    global static String getJSONForObjectPicklistField(String objName, String fieldName) {
    	objName = BPUtility.getDecodedString(objName);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForObjectPicklistField(objName, fieldName));
    }
    
    /**
     * Name: getJSONForObjectRecordsPicklist
     * Desc: Method to generate a JSON string for object record values used in dropdown components
     * @param: (1) objName - String - Object Name
     *		   (2) displayFieldName - String - Display field name in the object
     * @return: Converted JSON String for Object record values
    **/
    @RemoteAction
    global static String getJSONForObjectRecordsPicklist(String objName, String displayFieldName) {
    	objName = BPUtility.getDecodedString(objName);
    	displayFieldName = BPUtility.getDecodedString(displayFieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getPicklistJSONForObjectRecords(objName, displayFieldName));
    }
    
    /**
     * Name: getJSONForCategories
     * Desc: To get Category records into JSON Format 
	 * @param - (1) currentNoOfCategoriesInGrid - Integer - Current Number of Categories in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Categories records
    **/
    @RemoteAction
    global static String getJSONForCategories(Integer currentNoOfCategoriesInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForCategories(new List<Id>(), currentNoOfCategoriesInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
    
	/**
     * Name: getJSONForVendor
     * Desc: To get Vendors Records into JSON Format
     * @param - (1) currentNoOfVendorsInGrid - Integer - Current Number of Vendors in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Vendors Records
    **/
    @RemoteAction
	global static String getJSONForVendor(Integer currentNoOfVendorsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
		filterJSON = BPUtility.getDecodedString(filterJSON);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForVendor(new List<Id>(), currentNoOfVendorsInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
    
    /**
     * Name: getJSONForUnitMakes
     * Desc: To get Unit Makes Records into JSON Format 
     * @param - (1) currentNoOfUnitMakesInGrid - Integer - Current Number of Unit Makes in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Unit Makes Records
    **/
    @RemoteAction
	global static String getJSONForUnitMakes(Integer currentNoOfUnitMakesInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
		filterJSON = BPUtility.getDecodedString(filterJSON);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForUnitMakes(new List<Id>(), currentNoOfUnitMakesInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
    
    /**
     * Name: getJSONForUnitModelByUnitMakeId
     * Desc: To get Unit Makes Records into JSON Format 
     * @param - (1) unitMakeId - String - Parent Unit Make Id in String Format
     			(2) currentNoOfUnitModelsInGrid - Integer - Current Number of Unit Models in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String 
     * @return: Converted JSON String for Unit Models Records
    **/
    @RemoteAction
	global static String getJSONForUnitModelByUnitMakeId(String unitMakeId, Integer currentNoOfUnitModelsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
		unitMakeId = BPUtility.getDecodedString(unitMakeId);
		filterJSON = BPUtility.getDecodedString(filterJSON);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForUnitModelByUnitMakeId(unitMakeId, currentNoOfUnitModelsInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
	
    /**
     * Name: deleteSalesTax
     * Desc: Method deletes the Sales Tax with Id value
     * @param: (1) stId - Id - Sales Tax Id which is to be deleted
     * @return: If successfull
    **/
    @RemoteAction
    global static boolean deleteSalesTax(String stId) {
    	stId = Id.valueOf(BPUtility.getDecodedString(stId));
        return SystemSettingsService.deleteSalesTax(stId);
    }
    
     /**
     * Name: deleteSalesTaxItem
     * Desc: Method deletes the Sales Tax Item with Id value
     * @param: (1) stiId - Id - Sales Tax Item Id which is to be deleted
     * @return: If successfull
    **/
    @RemoteAction 
    global static String deleteSalesTaxItem(String stiId) {
    	stiId = Id.valueOf(BPUtility.getDecodedString(stiId));
        return BPUtility.getEncodedString(SystemSettingsService.deleteSalesTaxItem(stiId));
    }
    
    /**
     * Name: deletePriceLevel
     * Desc: Method deletes the Price Level record with Id value
     * @param: (1) plId - Id - Price Level Id which is to be deleted
     * @return: If successfull
    **/
    @RemoteAction
    global static boolean deletePriceLevel(String plId) {
    	plId = Id.valueOf(BPUtility.getDecodedString(plId));
        return SystemSettingsService.deletePriceLevel(plId); 
    }
    
    /**
     * Name: saveSalesTaxJSON
     * Desc: Method saves the Sales Tax record that is provided by JSON
     * @param: JSONString - JSON formated String of Sales Tax record 
     * @return: 
    **/
    @RemoteAction
    global static void saveSalesTaxJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.saveSalesTaxJSON(JSONString); 
    }
    
    /**
     * Name: savePriceLevelJSON
     * Desc: Method saves the Price Level record that is provided by JSON
     * @param: JSONString - JSON formated String of Price Level record 
     * @return: 
    **/
    @RemoteAction
    global static void savePriceLevelJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.savePriceLevelJSON(JSONString); 
    }
    
    /**
     * Name: saveSalesTaxItemJSON
     * Desc: Method saves the Sales Tax Item record that is provided by JSON
     * @param: JSONString - JSON formated String of Sales Tax Item record 
     * @return: 
    **/
    @RemoteAction
    global static String saveSalesTaxItemJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         return BPUtility.getEncodedString(SystemSettingsService.saveSalesTaxItemJSON(JSONString));   
    }
    
    /**
     * Name: saveCountryJSON
     * Desc: Method saves the Country record that is provided by JSON
     * @param: JSONString - JSON formated String of Country record 
     * @return: 
    **/
    @RemoteAction
    global static void saveCountryJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.updateCountryJSON(JSONString); 
    }
    
    /**
     * Name: saveStateJSON
     * Desc: Method saves the State record that is provided by JSON
     * @param: JSONString - JSON formated String of State record 
     * @return: 
    **/
    @RemoteAction
    global static void saveStateJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.updateStateJSON(JSONString); 
    }
    
    /**
     * Name: savePartJSON
     * Desc: Method saves the Part record that is provided by JSON
     * @param: JSONString - JSON formatted String of Part record 
     * @return: 
    **/
    @RemoteAction
    global static string savePartJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
         return BPUtility.getEncodedString(SystemSettingsService.savePartJSON(JSONString)); 
    }
    
    /**
     * Name: saveCustomerJSON
     * Desc: Method saves the Customer record that is provided by JSON
     * @param: (1) customerId - String - Customer Id in String
     		   (2) typeOfCustomer - String - type of customer - Individual or Comapny 
     		   (3) JSONString - String - JSON formatted String of Customer record
     * @return: Id - Id of inserted or updated record
    **/
    @RemoteAction
    global static Id saveCustomerJSON(String customerId, String typeOfCustomer, String JSONString) {
    	customerId = BPUtility.getDecodedString(customerId);
    	typeOfCustomer = BPUtility.getDecodedString(typeOfCustomer);
    	JSONString = BPUtility.getDecodedString(JSONString);
		Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
    	if(typeOfCustomer == 'Business') {
			return BPUtility.getEncodedString(SystemSettingsService.saveComapanyCustomerJSON(JSONString));
		} else if(customerId != null && customerId.length() != 0){
		 	return BPUtility.getEncodedString(SystemSettingsService.updateIndividualCustomerJSON(JSONString));
		} else{
		 	return BPUtility.getEncodedString(SystemSettingsService.saveIndividualCustomerJSON(JSONString));
		}
    }
    
    /**
     * Name: saveVendorJSON
     * Desc: Method saves the Vendor record that is provided by JSON
     * @param: (1) JSONString - String - JSON formated String of Vendor record
     * @return: Id - Id of upserted record
    **/
    @RemoteAction
    global static Id saveVendorJSON(String JSONString) {
    	JSONString = BPUtility.getDecodedString(JSONString);
    	Constants.IS_RECENT_VENDOR_TO_BE_CREATED = true;
		return BPUtility.getEncodedString(SystemSettingsService.saveVendorJSON(JSONString));    	 
    }
    
    /**
     * Name: saveCategoryJSON
     * Desc: Method saves the Category record that is provided by JSON
     * @param: (1) JSONString - String - JSON formated String of Category record 
     * @return: 
    **/
    @RemoteAction
    global static void saveCategoryJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.saveCategoryJSON(JSONString); 
    }
    
    /**
     * Name: saveUnitMakeJSON
     * Desc: Method saves the Unit Make record that is provided by JSON
     * @param: (1) JSONString - String - JSON formatted String of Unit Make record 
     * @return: 
    **/
    @RemoteAction
    global static void saveUnitMakeJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.saveUnitMakeJSON(JSONString); 
    }
    
    /**
     * Name: deleteUnitMakeJSON
     * Desc: Method deletes the Unit Make record that is provided by JSON
     * @param: (1) JSONString - String - JSON formatted String of Unit Make record 
     * @return: 
    **/
    @RemoteAction
    global static void deleteUnitMakeJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.deleteUnitMakeJSON(JSONString); 
    }
    
    /**
     * Name: saveUnitModelJSON
     * Desc: Method saves the Category record that is provided by JSON
     * @param: (1) JSONString - String - JSON formatted String of Unit Model record 
     * @return: 
    **/
    @RemoteAction
    global static void saveUnitModelJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.saveUnitModelJSON(JSONString); 
    }
    
    /**
     * Name: deleteUnitModelJSON
     * Desc: Method deletes the model record that is provided by JSON
     * @param: (1) JSONString - String - JSON formatted String of Unit Model record 
     * @return: 
    **/
    @RemoteAction
    global static void deleteUnitModelJSON(String JSONString) {
    	 JSONString = BPUtility.getDecodedString(JSONString);
         SystemSettingsService.deleteUnitModelJSON(JSONString); 
    }
    
    /**
     * Name: increaseCountries
     * Desc: Method to get some more countries records from that are present in grid
     * @param: (1) currentCountryInGrid - Integer - Current Number of Coutries records in Grid  
     * @return: String - Converted JSON String for Coutries Records
    **/
    @RemoteAction
    global static String increaseCountries(Integer currentCountryInGrid) {
    	isIncreaseCountriesMethodExecuted = true;
    	return generateJSONForCountries(currentCountryInGrid);
    }
    
    /**
     * Name: increaseCustomer
     * Desc: Method to get more customer records that are present in grid
     * @param - (1) currentCustomerInGrid - Integer - Current Number of customers in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Coutries Records
    **/
    @RemoteAction
    global static String increaseCustomer(Integer currentCustomerInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	isIncreaseCustomersMethodExecuted = true;
    	return BPUtility.getEncodedString(getJSONForAllCustomer(currentCustomerInGrid, dropDownNumber, isInactiveIncluded, filterJSON));
    }
	
	/**
     * Name: increaseVendor
     * Desc: Method to get more vendor records that are present in grid
     * @param - (1) currentVendorInGrid - Integer - Current Number of vendors in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Vendor Records
    **/
    @RemoteAction
    global static String increaseVendor(Integer currentVendorInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	isIncreaseVendorsMethodExecuted = true;
    	return getJSONForVendor(currentVendorInGrid, dropDownNumber, isInactiveIncluded, filterJSON);
    }
    
    /**
     * Name: increaseParts
     * Desc: Method to get more parts records that are present in grid
     * @param - (1) currentPartsInGrid - Integer - Current Number of parts in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Part Records
    **/
    @RemoteAction
    global static String increaseParts(Integer currentPartsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	isIncreasePartsMethodExecuted = true;
    	return getJSONForParts(currentPartsInGrid, dropDownNumber, isInactiveIncluded, BPUtility.getEncodedString(filterJSON));
    }
    
    /**
     * Name: increaseCategory
     * Desc: Method to get more categories records that are present in grid
     * @param - (1) currentCategoriesInGrid - Integer - Current Number of Categories in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Category Records
    **/
    @RemoteAction
    global static String increaseCategories(Integer currentCategoriesInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	isIncreaseCateoriesMethodExecuted = true;
    	return getJSONForCategories(currentCategoriesInGrid, dropDownNumber, isInactiveIncluded, BPUtility.getEncodedString(filterJSON)); 
    }
    
    /**
     * Name: increaseUnitMakes
     * Desc: Method to get more Unit makes records that are present in grid
     * @param - (1) currentUnitMakesInGrid - Integer - Current Number of Unit Make in Grid
     			(2) dropDownNumber - Integer - Drop Down selected Number
     			(3) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(4) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Unit Make Records
    **/
    @RemoteAction
    global static String increaseUnitMakes(Integer currentUnitMakesInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	isIncreaseUnitMakesMethodExecuted = true;
    	return getJSONForUnitMakes(currentUnitMakesInGrid, dropDownNumber, isInactiveIncluded, filterJSON); 
    }
    
    /**
     * Name: increaseUnitModels
     * Desc: Method to get more Unit makes records that are present in grid
     * @param - (1) unitMakeId - String - Unit Make Id in String 
     			(2) currentUnitModelsInGrid - Integer - Current Number of parts in Grid
     			(3) dropDownNumber - Integer - Drop Down selected Number
     			(4) isInactiveIncluded - Boolean - true if Inactive reccords are to be included
     			(5) filterJSON - String - Filter JSON String
     * @return: String - Converted JSON String for Unit Model Records
    **/
    @RemoteAction
    global static String increaseUnitModels(String unitMakeId, Integer currentUnitModelsInGrid, Integer dropDownNumber, Boolean isInactiveIncluded, String filterJSON) {
    	isIncreaseUnitModelsMethodExecuted = true;
    	return getJSONForUnitModelByUnitMakeId(unitMakeId, currentUnitModelsInGrid, dropDownNumber, isInactiveIncluded, filterJSON); 
    }
    
    /**
     * Name: createRecentCustomerRecord
     * Desc: Method creates a recent customer record when any customer is seen.
     * @param: 
     * @return: 
    **/
    @future
    public static void createRecentCustomerRecord() {
    	if(AccessControl.ifObjectFieldIsCreateable('Recent_Customer__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Recent_Customer__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Recent_Customer__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
        Recent_Customer__c recentCustomerToBeInsert = new Recent_Customer__c();
        selectedCustomerId = BPUtility.escapeSingleQuotes(selectedCustomerId);
        recentCustomerToBeInsert.Customer__c = selectedCustomerId;
		Constants.IS_RECENT_CUSTOMER_TO_BE_CREATED = true;
		
		
        List<Recent_Customer__c> recentCustomerList = [select Id, Customer__c from Recent_Customer__c where Customer__c =:selectedCustomerId and createdById = :UserInfo.getUserId()];
        if(recentCustomerList.size() > 0) {
        	recentCustomerToBeInsert.Id = recentCustomerList[0].Id;
        }
        upsert recentCustomerToBeInsert;
    }
    
	/**
     * Name: createRecentVendorRecord
     * Desc: Method creates a recent Vendor record when any Vendor is viewed.
     * @param: 
     * @return: 
    **/
    @future
    public static void createRecentVendorRecord() {
    	
    	if(AccessControl.ifObjectFieldIsCreateable('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Recent_Vendor__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
        Recent_Vendor__c recentVendorToBeInsert = new Recent_Vendor__c();
        selectedVendorId = BPUtility.escapeSingleQuotes(selectedVendorId);
        recentVendorToBeInsert.Vendor__c = selectedVendorId;
        Constants.IS_RECENT_VENDOR_TO_BE_CREATED = true;
        
        
        List<Recent_Vendor__c> recentVendorList = [select Id, Vendor__c from Recent_Vendor__c where Vendor__c =:selectedVendorId and createdById = :UserInfo.getUserId()];
        if(recentVendorList.size() > 0) {
        	recentVendorToBeInsert.Id = recentVendorList[0].Id;
        }
        upsert recentVendorToBeInsert;
    }
	
    /**
     * Name: createRecentPartRecord
     * Desc: Method creates a recent customer record when any customer is viewed.
     * @param: 
     * @return: 
    **/
    @future
    public static void createRecentPartRecord() {
    	if(AccessControl.ifObjectFieldIsCreateable('Recent_Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Recent_Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Recent_Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        Recent_Part__c recentPartToBeInsert = new Recent_Part__c();
        selectedPartId = BPUtility.escapeSingleQuotes(selectedPartId);
        recentPartToBeInsert.Part__c = selectedPartId;
        
        List<Recent_Part__c> recentPartList = [select Id, Part__c from Recent_Part__c where part__c =:selectedPartId and createdById = :UserInfo.getUserId()];
        if(recentPartList.size() > 0) {
        	recentPartToBeInsert.Id = recentPartList[0].Id;
        }
        upsert recentPartToBeInsert;
    }
    
    /**   
     * Name: getJSONForFilteredCustomer
     * Desc: Method to get Filtered Customer in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     		   (3) isInactiveIncluded - boolean - true if inactive records are to be included
     * @return: String - Converted JSON Sring for Filtered Customer
    **/
    @RemoteAction
    global static String getJSONForFilteredCustomer(String searchString, String fieldName, Boolean isInactiveIncluded) {
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredCustomer(searchString, fieldName, isInactiveIncluded));    
    }
    
    /**
     * Name: getJSONForFilteredParts
     * Desc: Method to get Filtered Parts in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     * @return: String - Converted JSON Sring for Filtered Parts
    **/
    @RemoteAction
    global static String getJSONForFilteredParts(String searchString, String fieldName) {
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredParts(searchString, fieldName));    
    }
    
    /**
     * Name: getJSONForFilteredCategory
     * Desc: Method to get Filtered Category in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     * @return: String - Converted JSON Sring for Filtered Category
    **/
    @RemoteAction
    global static String getJSONForFilteredCategory(String searchString, String fieldName) {
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredCategory(searchString, fieldName));    
    }
    
	/**
     * Name: getJSONForFilteredVendor
     * Desc: Method to get Filtered Vendor in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     		   (3) isInactiveIncluded - boolean - true if inactive records are to be included
     * @return: String - Converted JSON Sring for Filtered Vendor
    **/
    @RemoteAction
    global static String getJSONForFilteredVendor(String searchString, String fieldName, Boolean isInactiveIncluded) {
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredVendor(searchString, fieldName, isInactiveIncluded));   
    }
    
    /**
     * Name: getJSONForFilteredUnitMakes
     * Desc: Method to get Filtered Unit Make records in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     		   (3) isInactiveIncluded - boolean - true if inactive records are to be included
     * @return: String - Converted JSON Sring for Filtered Unit Make records
    **/
    @RemoteAction
    global static String getJSONForFilteredUnitMakes(String searchString, String fieldName, Boolean isInactiveIncluded) {
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredUnitMakes(searchString, fieldName, isInactiveIncluded));    
    }
    
    /**
     * Name: getJSONForFilteredUnitModels
     * Desc: Method to get Filtered Unit Model records in JSON Format
     * @param: (1) searchingString - String - Seraching Keyword
     		   (2) fieldName - String - Field Name on which filter is applied
     		   (3) isInactiveIncluded - boolean - true if inactive records are to be included
     * @return: String - Converted JSON Sring for Filtered Unit Model records
    **/
    @RemoteAction
    global static String getJSONForFilteredUnitModels(String unitMakeId, String searchString, String fieldName, Boolean isInactiveIncluded) {
    	unitMakeId = BPUtility.getDecodedString(unitMakeId);
    	searchString = BPUtility.getDecodedString(searchString);
    	fieldName = BPUtility.getDecodedString(fieldName);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForFilteredUnitModels(unitMakeId, searchString, fieldName, isInactiveIncluded));    
    } 
}