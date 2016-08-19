/**
 * Author: Tarun Khandelwal
 * Since: Sept. 26, 2014
 * Name: SystemSettingsController 
 * Description: Conroller class which contains all the remote methods that interacts with VF Pages.
**/
global with sharing class SystemSettingsController {
	
	
	/**
     * Name: getJSONForAllSalesTax
     * Desc: To Convert All Sales Tax records into JSON Format 
     * @param: 
     * @return: Converted JSON String for All Sales Tax records
    **/
    @RemoteAction
    global static String getJSONForAllSalesTax() {
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTax(new List<Id>()));
    }
    
    /**
     * Name: getJSONForSalesTax
     * Desc: To Convert Sales Tax record into JSON Format 
     * @param: Sales Tax record Id which is to be converted into JSON
     * @return: Converted JSON String for Sales Tax Record
    **/
    @RemoteAction
    global static String getJSONForSalesTax(String salesTaxId) {
    	salesTaxId = BPUtility.getDecodedString(salesTaxId);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTax(new List<Id>{salesTaxId}));
    }
    
    
    /**
     * Name: getJSONForAllSalesTaxItem
     * Desc: To Convert All Sales Tax Item records into JSON Format 
     * @param: 
     * @return: Converted JSON String for All Sales Tax Item Record
    **/
    @RemoteAction
    global static String getJSONForAllSalesTaxItem() {
		return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTaxItem(new List<Id>()));
    }
    
    /**
     * Name: getJSONForSalesTaxItem
     * Desc: To Convert one Sales Tax Item record into JSON Format 
     * @param: Sales Tax Item record Id which is to be converted into JSON
     * @return: Converted JSON String for Sales Tax Item record
    **/
    @RemoteAction
    global static String getJSONForSalesTaxItem(String salesTaxItemId) {
    	salesTaxItemId = BPUtility.getDecodedString(salesTaxItemId);
		return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTaxItem(new List<Id>{salesTaxItemId}));
    }
    
    /**
     * Name: getJSONForAllPriceLevels
     * Desc: To Convert All Price Levels into JSON Format 
     * @param: 
     * @return: Converted JSON String for Price Level Record
    **/
    @RemoteAction
    global static String getJSONForAllPriceLevels() {
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForPriceLevel(new List<Id>()));
    }
    
    /**
     * Name: getJSONForRecentItem
     * Desc: To Convert Recent Items records into JSON Format 
     * @param: 
     * @return: Converted JSON String for recent items reocrds
    **/
    @RemoteAction
    global static String getJSONForRecentItem() {
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForRecentItem());
    }
    
    /**
     * Name: getJSONForSalesTaxWrapper
     * Desc: To Convert Sales Tax Id with related Sales Tax Items records into JSON Format 
     * @param: Sales Tax Id
     * @return: Converted JSON String for Sales Taxes with related Sales tax items
    **/
    @RemoteAction
    global static String getJSONForSalesTaxWrapper(String salesTaxId) {
    	salesTaxId = BPUtility.getDecodedString(salesTaxId);
    	return BPUtility.getEncodedString(SystemSettingsService.getJSONForSalesTaxWrapper(SalesTaxId));
    }
    
}