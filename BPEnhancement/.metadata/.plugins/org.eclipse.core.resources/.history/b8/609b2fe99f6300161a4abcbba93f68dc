/**
 * Author: Tarun Khandelwal
 * Since: Feb. 07, 2015
 * Name: HomeSearchPageCtrl
 * Description: Apex class which contains all remoted methods.
**/
global with sharing class HomeSearchPageCtrl {
	
	/**
     * Name: getOrgSearchResults
     * Desc: Method which perform a SOSL search in whole org in defined objects and returns a JSON result for the search
     * @param:  (1) textToSearch - String - text value to be searched in the org
     			(2) pageNumber - Integer - Page Number
     			(3) pageSize - Integer - Page Size
     * @return: String - JSON String of searched records
    **/
    @RemoteAction
    global static String getOrgSearchResults(String textToSearch, Integer pageNumber, integer pageSize){
    	textToSearch = BPUtility.getDecodedString(textToSearch);
        
    	List<sObject> searchResults = new List<sObject>();
    	String JSONString = JSONService.getJSONForRecordsList(searchResults, null);
        return BPUtility.getEncodedString(JSONString);
    }
    
    /**
     * Name: getFilterJSON
     * Desc: Method which gets All filter records in JSON format
     * @param: 
     * @return: String - JSON String of filter records
    **/
    @RemoteAction
    global static String getFilterJSON(){
    	List<sObject> filterRecords = SOQLUtil.getFilterRecords();
    	return BPUtility.getEncodedString(Utility.createJSON(filterRecords, Constants.FILTER_FIELDS_TO_JSON_MAPPING, Constants.FILTER_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>()));
    }
    
    /**
     * Name: getFieldJSONForFilter
     * Desc: Method which gets given filter records in JSON format 
     * @param:  (1) filterRecId - String - Filter Record Id
     * @return: String - JSON String of given filter record
    **/
    @RemoteAction
    global static String getFieldJSONForFilter(String filterRecId){
    	filterRecId = BPUtility.getDecodedString(filterRecId);
        List<sObject> filterRecordJSON = SOQLUtil.getFieldFilterRecords(filterRecId);
    	return BPUtility.getEncodedString(Utility.createJSON(filterRecordJSON, Constants.FILTER_FIELDS_TO_JSON_MAPPING, Constants.FILTER_FIELDS_TO_DATA_TYPE_MAPPING, new List<sobject>(), new Map<String, String>(), new Map<String, String>()));
    }
    
    
    /**
     * Name: getFilterSearchResult
     * Desc: Method which performs filtering and gives required result 
     * @param:  (1) filterJSONData - String - JSON Sting of filter applied
     `			(2) pageAndSortFiltersJSON - String - JSON String related to Paging and sorting
     * @return: String - JSON String of searched records
    **/
    @RemoteAction
    global static String getFilterSearchResult(String filterJSONData, String pageAndSortFiltersJSON){
    	filterJSONData = BPUtility.getDecodedString(filterJSONData);
        pageAndSortFiltersJSON = BPUtility.getDecodedString(pageAndSortFiltersJSON);
        
    	Map<String, List<String>> filterFieldToSearchedValueMap = Utility.parseFilterJSONInSOSL(filterJSONData);
    	Utility.PageAndSortFilter pageAndSortMapping = Utility.parsePageAndSortFilters(pageAndSortFiltersJSON);
    	
    	String JSONString;
    	List<sObject> searchResults;
    	List<String> objectNameSet = new List<String>();
    	
    	if(filterFieldToSearchedValueMap.containsKey('Object')) {
    		objectNameSet.addAll(filterFieldToSearchedValueMap.get('Object'));
    		filterFieldToSearchedValueMap.remove('Object');
    	} 
    	
    	Integer totalRecordsFound;
    	if(pageAndSortMapping.SearchText == '' && filterFieldToSearchedValueMap.size() == 0 && objectNameSet.size() == 0) {
    		searchResults = RecentViewRecordsUtil.getOrgBlankSearchResults(pageAndSortMapping);
    		totalRecordsFound = RecentViewRecordsUtil.totalRecordsFound;
    	} else {
    		searchResults = SOSLUtil.getOrgSearchResults(objectNameSet, pageAndSortMapping, filterFieldToSearchedValueMap);
    		totalRecordsFound = SOSLUtil.totalRecordsFound;
    	}
    	JSONString = JSONService.getJSONForRecordsList(searchResults, totalRecordsFound);
    	return BPUtility.getEncodedString(JSONString);
    }
    
    /**
     * Name: saveCustomFilterJSON
     * Desc: Method which saves Cumtom filter to the database
     * @param:  (1) customFilterLabel - String - name of custom filter
     			(2) filterId - String - Custom Filter Id
     			(3) customFilterJSONString - String - filter Field JSON String
     			(4) isDateFilterChanged - Boolean - Checks if the  date filter is changed 
     * @return: String - JSON String of all filter rcords
    **/
    @RemoteAction
    global static String saveCustomFilterJSON(String customFilterLabel, String filterId, String customFilterJSONString, Boolean isDateFilterChanged){
    	customFilterLabel = BPUtility.getDecodedString(customFilterLabel);
        filterId = BPUtility.getDecodedString(filterId);
        filterId = BPUtility.escapeSingleQuotes(filterId);
        customFilterJSONString = BPUtility.getDecodedString(customFilterJSONString);
        
    	Filter__c customFilter = new Filter__c();
    	if(filterId != null) {
    		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		customFilter = [select Filter_Label__c, Filter_JSON__c, Custom__c from Filter__c where Id = :filterId];
    	} else {
    		customFilter.Filter_Label__c = customFilterLabel;
    		customFilter.Custom__c = true;
    	}
    	customFilter.Filter_JSON__c = customFilterJSONString;
    	if(isDateFilterChanged) {
    		customFilter.Last_Modified_Date_Filter__c = system.now();
    	}
    	if(AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	upsert customFilter;
    	return getFilterJSON();
    }
    
    /**
     * Name: deleteCustomFilter
     * Desc: Method which deletes filter record of given filter Id
     * @param:  (1) filterId - String - Filter Record Id which is to be deleted
     * @return: String - JSON String of all filter rcords
    **/
    @RemoteAction
    global static String deleteCustomFilter(String filterId){
    	filterId = BPUtility.getDecodedString(filterId);
        filterId = BPUtility.escapeSingleQuotes(filterId);
    	if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		Filter__c filterRecToDelete = [select Id From Filter__c where Id = : filterId];
		if(filterRecToDelete != null){
			if(AccessControl.ifObjectIsDeletable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
			delete filterRecToDelete;
		}
    	return getFilterJSON();
    }
    
    /**
     * Name: renameCustomFilter
     * Desc: Method which renames custom filter
     * @param:  (1) filterId - String - Filter Record Id which is to be renamed
     			(2) filterNewName - String - Name of Filter
     * @return: String - JSON String of all filter rcords
    **/
    @RemoteAction
    global static String renameCustomFilter(String filterId, String filterNewName){
    	filterId = BPUtility.getDecodedString(filterId);
        filterNewName = BPUtility.getDecodedString(filterNewName);
        filterId = BPUtility.escapeSingleQuotes(filterId);
    	if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		Filter__c filterRec = [select Id From Filter__c where Id = : filterId];
		if(filterRec != null){
			if(AccessControl.ifObjectFieldIsUpdateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
			filterRec.Filter_Label__c = filterNewName;
			update filterRec;
		}
    	return getFilterJSON();
    }
    
    /**
     * Name: copyCustomFilter
     * Desc: Method which create one copy of record
     * @param:  (1) filterId - String - Filter Record Id which is to be deleted
     			(2) filterCopyName - String - Name of Filter
     * @return: String - JSON String of all filter rcords
    **/
    @RemoteAction
    global static String copyCustomFilter(String filterId, String filterCopyName){
    	filterId = BPUtility.getDecodedString(filterId);
        filterCopyName = BPUtility.getDecodedString(filterCopyName);
        filterId = BPUtility.escapeSingleQuotes(filterId);
    	if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		Filter__c filterRec = [select Id, Filter_JSON__c From Filter__c where Id = : filterId];
		Filter__c copyFilter = new Filter__c();
		copyFilter.Filter_Label__c = filterCopyName;
		copyFilter.Filter_JSON__c = filterRec.Filter_JSON__c;
		copyFilter.Custom__c = true;
		copyFilter.Filter_User__c = UserInfo.getUserId();
		insert copyFilter;
    	return getFilterJSON();
    }
    
    /**
     * Name: createCustomerOrder
     * Desc: Method which creates a customer order header record
     * @param:  
     * @return: String - inserted customer order header record Id
    **/
    @RemoteAction
    global static String createCustomerOrder(){
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	CO_Header__c coHeaderToInsert = new CO_Header__c();
    	coHeaderToInsert.Order_status__c = 'Open';
    	coHeaderToInsert.Owner__c = UserInfo.getUserId();
    	insert coHeaderToInsert;
    	return BPUtility.getEncodedString(coHeaderToInsert.Id);
    }
    
    /**
     * Name: createVendorOrder
     * Desc: Method which creates a Vendor order header record
     * @param:  
     * @return: String - inserted Vendor order header record Id
    **/
    @RemoteAction
    global static String createVendorOrder(){
    	if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	Vendor_Order_Header__c voHeaderToInsert = new Vendor_Order_Header__c();
    	voHeaderToInsert.Owner__c = UserInfo.getUserId();
    	voHeaderToInsert.Status__c = 'Open';
    	insert voHeaderToInsert;
    	return BPUtility.getEncodedString(voHeaderToInsert.Id);
    }
    
    /**
     * Name: createVOReceiving
     * Desc: Method which creates a Vendor order Recieving record
     * @param:  
     * @return: String - inserted voHeaderReceiving record Id
    **/
    @RemoteAction
    global static String createVOReceiving(){
    	if(AccessControl.ifObjectFieldIsCreateable('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	Vendor_Receiving_Header__c voHeaderReceivingToInsert = new Vendor_Receiving_Header__c();
    	voHeaderReceivingToInsert.Owner__c = UserInfo.getUserId();
    	voHeaderReceivingToInsert.Status__c = 'In Progress';
    	insert voHeaderReceivingToInsert;
    	return BPUtility.getEncodedString(voHeaderReceivingToInsert.Id);
    }
}