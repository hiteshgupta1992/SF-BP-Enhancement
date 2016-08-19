/**
 * Author: Richa Mittal
 * Since: August 12, 2016
 * Name: GlobalSearchCtrl
 * Description: Controller class to handle methods for global Search
**/
global with sharing class GlobalSearchCtrl {
    
    
    public Static Integer MAX_RECORDS_TO_DISPLAY = 10;
    
    /**
	 * Name: getGlobalSearchResults
	 * Description: Function get records for the search
	 * @Param: 
	 * @Return: String - Search List String 
	**/
    @RemoteAction 
    global static String getGlobalSearchResults(String searchQueryJson) {
    	searchQueryJson = BPUtility.getDecodedString(searchQueryJson);
    	GlobalSearchResultsWrapper.GlobalQueryJSON globalQueryJSON = (GlobalSearchResultsWrapper.GlobalQueryJSON)System.JSON.deserialize(searchQueryJson, GlobalSearchResultsWrapper.GlobalQueryJSON.class);
		
		// serach text entered by the user
    	String searchText = globalQueryJSON.GlobalSearchText;
    	// keyword to search given by the user
    	String searchKeyword = globalQueryJSON.GlobalSearchKeyword;
    	// List to Hold all the query record
    	List<Sobject> searchedResultsList = new List<Sobject>();
    	// query to SOQL records
    	String query;
    	// variable to Hold object API Name
    	String objectAPIName;
    	
    	Set<String> objectNameSetToSearch = HomeSearchUtil.displayObjectNameToObjectAPINameMap.keySet();
    	
    	for(String objectName : objectNameSetToSearch){
    		if(objectName == 'People'){
    			continue;
    		}
    		objectAPIName = HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objectName);
    		query = 'SELECT '; 
	        for(String fieldsName : HomeSearchUtil.searchableObjectToFieldsMap.get(objectAPIName)){
	        	fieldsName = BPUtility.escapeSingleQuotes(fieldsName);
	            query += fieldsName + ', ';
	        }
	        query = query.substring(0, query.length()-2);
	        query += ' FROM ' + Constants.NAMESPACE + objectAPIName;
	        query += ' WHERE '+ HomeSearchReportInterface.getContainsCondition(objectName, searchText);
	        //System.assert(false, query);
	        
	        if(objectName == 'Customers') {
	            query += 'AND (Is_Customer__c = true) '; 
	        }else if(objectName == 'Vendors'){
	        	query += 'AND (Is_Vendor__c = true) '; 
	        }
	        /*query += ' ORDER BY Default__c DESC, Name__c ASC';*/
	        if(AccessControl.ifObjectFieldIsAccessible(objectAPIName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	        searchedResultsList.addAll((List<Sobject>)Database.query(query));
    	}
    	
    	//System.assert(false, searchedResultsList);
    	
    	// Sorting Code START HERE
    	List<HSSObjectInstance> HSSObjectList = sortSobjectList(searchedResultsList);
    	//System.assert(false, HSSObjectList);
    	searchedResultsList = new List<Sobject>();
    	for(Integer i=0; i<MAX_RECORDS_TO_DISPLAY && i<HSSObjectList.size() ; i++){
			searchedResultsList.add(HSSObjectList[i].record);
		}
		// Sorting Code END HERE
		
		//System.assert(false, searchedResultsList);
    	// List to return the result 
    	GlobalSearchResultsWrapper globalSearchResults = new GlobalSearchResultsWrapper(HSSObjectList.size(), searchedResultsList);
    	return BPUtility.getEncodedString(System.JSON.serialize(globalSearchResults));
    }
    
    /**
	 * Name: sortSobjectList
	 * Description: Function to Sort the list of sObjects
	 * @Param: List<Sobject> sObjectList
	 * @Return: List<HSSObjectInstance> - HSSObjectInstance List 
	**/
    private static List<HSSObjectInstance> sortSobjectList(List<Sobject> sObjectList){
    	List<HSSObjectInstance> HSSObjectList = new List<HSSObjectInstance>();
    	for(Sobject sObj : sObjectList) {
    		HSSObjectList.add(new HSSObjectInstance(sObj));
    	}
    	if(HSSObjectList.size() > 0){
    		HSSObjectList.sort();
    	}
    	return HSSObjectList;
    }
}