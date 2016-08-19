/**
 * Author: Tarun Khandelwal
 * Since: Feb. 07, 2015
 * Name: HomeSearchSOSL
 * Description: Apex class which contains all SOSL Methods.
**/
public without sharing class HomeSearchSOSL {
	private static Integer totalRecordsFound;
	
    /**
	 * Name: searchRecords
	 * Description: 
	 * @Param:	(1) objectFiltersMap: 
	 			(2) objectsToSearchSet : Objects to be Searched
	 			(3) pageAndSortMapping : Parameter for pagination and sorting
	 			(4) filterLabelList : Label List for Search Category
	 * @Return:	String - JSON String of searched records
	**/
    public static String searchRecords(	Map<String, List<HomeSearchFilterInterface.FieldFilter>> objectFiltersMap,
    									Set<String> objectsToSearchSet,
    									String searchText,
    									PaginationSorting pageAndSortMapping,
    									List<HomeSearchFilterInterface.FilterLabel> filterLabelList
    								) {
    	List<String> objectsToSearch = new List<String>(objectsToSearchSet);
    	String JSONString = '[]';
    	String textToSearch = (searchText != null) ? searchText : '';
    	textToSearch = formatTextValueToBeSearched(textToSearch);
    	
    	String objectTypeSortDirection;
		Boolean isAnyFilterPresent = false;
		
		Integer indexVal = -1;
		Integer indexForType = -1;
		for(PaginationSorting.SortAttrs sortField : pageAndSortMapping.Sorting) {
			indexVal++;
			if(sortField.FieldName == 'Type') {
				objectTypeSortDirection = sortField.SortDirection;
				indexForType = indexVal;
			} else {
				isAnyFilterPresent = true;
			}
		}
		if(indexForType != -1) {
			pageAndSortMapping.Sorting.remove(indexForType);
		}
    	
    	objectsToSearch = (objectsToSearch == null || objectsToSearch.size() == 0) ? new List<String>(HomeSearchUtil.displayObjectNameToObjectAPINameMap.keySet()) : objectsToSearch;
    	
    	// A list to hold the search result sobjects list
        List<HSSObjectInstance> instanceRecords = new List<HSSObjectInstance>();
        
        // Query and get result records
        Map<String, list<sObject>> soslResultMap;
        List<String> accountObjLabelsList = new List<String>{'Customers', 'Vendors'};
        if( (textToSearch == null || textToSearch.trim().length() == 0)
        	&& (objectsToSearch.size() == 1 && (objectsToSearch[0] == 'Customers' || objectsToSearch[0] == 'Vendors')) 
        	|| (objectsToSearch.size() == 2 && objectsToSearch.sort() == accountObjLabelsList.sort())
        ) {
        	Set<String> accountSpecificFiledLables = new Set<String>{'Name', 
        															 'Preferred_Email__c', 
        															 'Preferred_Phone__c', 
        															 'Email__c', 
        															 'Other_Email__c', 
        															 'Work_Email__c',
        															 'Preferred_Phone__c', 
        															 'Phone', 
        															 'Home_Number__c', 
        															 'Preferred_SMS__c', 
        															 'Work_Number__c',
        															 'Mobile__c'
        														};
        	for(HomeSearchFilterInterface.FieldFilter fieldFilter : objectFiltersMap.get(objectsToSearch[0])) {
        		boolean isValid = false;
        		if(accountSpecificFiledLables.contains(fieldFilter.FieldName)) {
        			isValid = true;
        		} else if(fieldFilter.FieldName == '') {
        			for(String str : accountSpecificFiledLables) {
        				if(accountSpecificFiledLables.contains(str)) {
        					isValid = true;
        					break;
        				}
        			}
        		}
        		
        		if(isValid) {
	        		List<String> valueSplit =  ((String)fieldFilter.FieldValue).split('%');
	    			for(String str : valueSplit) {
					    if(str.indexOf('\'') == -1) {
					        textToSearch += (textToSearch != '') ? ' OR ' : '';
					        textToSearch += '*' + str.trim() + '*';
					    }
					}
	        	}
        	}
        	
        	
        	List<List<sObject>> soslResults = getTextSearchResult( textToSearch, objectsToSearch, objectFiltersMap, pageAndSortMapping );
	        soslResultMap = getObjectNameToObjectRecordsMap(soslResults);
        } else {
	        List<List<sObject>> soslResults = getTextSearchResult( textToSearch, objectsToSearch, objectFiltersMap, pageAndSortMapping );
	        soslResultMap = getObjectNameToObjectRecordsMap(soslResults);
        }
        
        // Merge records based on sorting and objects
        List<sObject> resultRecords = sortTheRecords(objectTypeSortDirection, objectsToSearch, isAnyFilterPresent, soslResultMap, pageAndSortMapping);
		
        // Serialize JSON based on object type
        JSONString = HomeSearchResultWrapper.getJSONForSObjectRecords(resultRecords, 
        															  HomeSearchUtil.getGenericObjectNameBySelectedObject(objectsToSearchSet),
        															  totalRecordsFound,
        															  filterLabelList
        															);
        
    	return JSONString;
    }
    
    /**
     * Name: getTextSearchResult
     * Desc: Method which make dynamic SOSL and provide result
     * @param:  (1) textToSearch - String - The text value which is to be searched 
     			(2) objectsToSearch - List<String>  -List of Objects in which seach is to be performed
     			(3) idsToExclude - List<Id> - List of Ids that are to be excluded
     			(4) offsetValue - Integer - Offset value
     			(5) pageSize - Integer - Page size parameter
     			(2) orderByFieldsMap - List<PaginationSorting.SortAttrs> - List of objects related to sorting
     			(3) filterfieldToSearchedValueMap - Map<String, String> - Map of filter field to seached value
     * @return: List<sObject> - Searched records list
    **/
    private static List<List<sObject>> getTextSearchResult( String textToSearch, 
								                            List<String> objectsToSearch,
								                            Map<String, List<HomeSearchFilterInterface.FieldFilter>> objectFiltersMap,
								                            PaginationSorting pageAndSortMapping
														){
    	// SOSL query string
    	textToSearch = BPUtility.escapeSingleQuotes(textToSearch);
		String soslQuery = 'Find \'';
		if(textToSearch.trim().length() != 0){
			soslQuery += textToSearch + ' OR ' + textToSearch + '* ' + ' OR ' + '*' + textToSearch + '*';
		} else {
			soslQuery += '* * OR  * OR * ';
		}
		soslQuery += '\' IN ALL FIELDS RETURNING ';
			
		// Create returning object fields and where condition
		for(String objName : objectsToSearch){
			if(AccessControl.ifObjectFieldIsAccessible(objName) == false) {continue;}
			
			system.debug('$$$$$$$$$$ objName : ' + objName);
			List<HomeSearchFilterInterface.FieldFilter> filterList = objectFiltersMap.get(objName);
			objName = (HomeSearchUtil.displayObjectNameToObjectAPINameMap.containsKey(objName)) ? HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName) : objName;
			
			soslQuery += objName + ' (';
			for(String objFieldName : HomeSearchUtil.searchableObjectToFieldsMap.get(objName)){
				soslQuery += objFieldName + ', ';
			}
			soslQuery = soslQuery.substring(0, soslQuery.length() - 2);
			
			// WHERE condition: Loop over filterList and add filter fields to sosl query
			String queryWhereClause = (filterList != null && filterList.size() > 0) ? ' WHERE ' : '';
			for(HomeSearchFilterInterface.FieldFilter fieldFilter : filterList) {
				queryWhereClause += (queryWhereClause == ' WHERE ') ? '' : ' AND ';
				if(fieldFilter.FieldName != null && fieldFilter.FieldName.trim().length() != 0) {
					String filterFielName = fieldFilter.FieldName;
					if(filterFielName == 'OwnerId' && HomeSearchUtil.objectToOwnerObjectFieldName.containsKey(objName)) {
						String ownerField = HomeSearchUtil.objectToOwnerObjectFieldName.get(objName);
						ownerField = (ownerField.endsWith('__c')) ? ownerField : (ownerField + '.' + filterFielName);
						filterFielName = ownerField;
					} else if(filterFielName == 'OwnerId' && objName == 'User') {
						filterFielName = 'CreatedById';
					}
					
					queryWhereClause += filterFielName + ' ' + fieldFilter.Operator + ' ' + fieldFilter.FieldValue;
				} else {
					// In else case add the value as whole filter
					queryWhereClause += fieldFilter.FieldValue;
				}
			}
			
			// Order By clause
			String queryOrderByClause = ' ORDER BY ';
			for(PaginationSorting.SortAttrs sortField : pageAndSortMapping.Sorting) {
				String fieldAPIName;
				if(sortField.FieldName != null 
					&& HomeSearchUtil.searchableObjectToFieldsMap.containsKey(objName) 
					&& HomeSearchUtil.searchableObjectToFieldsMap.get(objName).contains(sortField.FieldName)
				){
					fieldAPIName = sortField.FieldName;
				} else if(sortField.FieldName != null 
							&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(objName) 
							&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objName).containsKey(sortField.FieldName)
						) {
					fieldAPIName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objName).get(sortField.FieldName);
				}
				if(fieldAPIName != null) {
					queryOrderByClause += ' ' + fieldAPIName + ' ' + sortField.SortDirection + ',';
				}
			}
			queryOrderByClause = queryOrderByClause.substring(0, queryOrderByClause.length() - 1);
			String dumpOrderClause = '' + queryOrderByClause;
			if(dumpOrderClause.trim() == 'ORDER BY'){
				queryOrderByClause += ' LastModifiedDate DESC';
			}
			
			soslQuery += queryWhereClause + queryOrderByClause + '), ';
		}
		soslQuery = soslQuery.subString(0, soslQuery.length() - 2);
		
		System.debug('#########\n\n'+ soslQuery);
		List<List<sObject>> searchResultList = Search.query(soslQuery);
		//System.assert(false, searchResultList[0].size() + '  ' + searchResultList[1].size());
		
		return searchResultList;
    }
    
    /**
     * Name: sortTheRecords
     * Desc: Method which Sorts the records
     * @param:  (1) objectTypeSortDirection - 
     			(2) objectsToSearch - List<String>  -List of Objects in which seach is to be performed
     			(3) isAnyFilterPresent - Checks That any filter is applied the object or not
     			(4) soslResultMap - Map<String, list<sObject>> - Maps The Result To the String
     			(5) pageAndSortMapping - Integer - Page size parameter
     * @return: List<sObject> - Searched records list
    **/
    public static List<sObject> sortTheRecords(String objectTypeSortDirection,
    											List<String> objectsToSearch,
    											Boolean isAnyFilterPresent,
    											Map<String, list<sObject>> soslResultMap,
    											PaginationSorting pageAndSortMapping
    										){
    	List<sObject> allRecords = new List<sObject>();
    	
    	if(objectTypeSortDirection != null){
        	Map<String, list<sObject>> objectRecords = soslResultMap;
	        
            objectsToSearch.sort();
            objectsToSearch = (objectTypeSortDirection == 'DESC') ? Utility.getReveresedSortList(objectsToSearch) : objectsToSearch;
            
            for(String objName : objectsToSearch){
            	objName = (HomeSearchUtil.displayObjectNameToObjectAPINameMap.containsKey(objName)) ? HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName) : objName;
            	if(objectRecords.containsKey(objName)){
            		List<sObject> objRecords = objectRecords.get(objName);
            		
            		List<HSSObjectInstance> instanceRecords = new List<HSSObjectInstance>();
            		for(sObject sObj : objRecords){
            			instanceRecords.add( new HSSObjectInstance(sObj) );
            		}
            		
            		objRecords.clear();
            		for(HSSObjectInstance sObjIns : instanceRecords){
            			allRecords.add(sObjIns.record);
            		}
            	} 
            }
        } else {
        	Map<String, list<sObject>> objectRecords = soslResultMap;
	        Integer totalObjectsForWhichRecordsFound = 0;
	        
	        //System.debug('@#@#@#@#@#@\n\n' + String.valueOf(objectRecords.get('Account')[0].get('Customer_Number__c')) + '\n' + String.valueOf(objectRecords.get('Account')[49].get('Customer_Number__c')));
            for(String objName : objectsToSearch){
            	objName = (HomeSearchUtil.displayObjectNameToObjectAPINameMap.containsKey(objName)) ? HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName) : objName;
            	if(objectRecords.containsKey(objName)){
            		List<sObject> objRecords = objectRecords.get(objName);
            		allRecords.addAll(objRecords);
            		objectRecords.remove(objName);
            		totalObjectsForWhichRecordsFound++;
            	} 
            }
            //System.debug('@#@#@#@#@#@\n\n' + String.valueOf(allRecords[0].get('Customer_Number__c')) + '\n' + String.valueOf(allRecords[49].get('Customer_Number__c')));
            
			System.debug('#$$#$#$\n\n' + isAnyFilterPresent + '  ' + totalObjectsForWhichRecordsFound);
	        if(isAnyFilterPresent && totalObjectsForWhichRecordsFound > 1){  
	        	List<HSSObjectInstance> instanceRecords = new List<HSSObjectInstance>();
	    		for(sObject sObj : allRecords){
	    			instanceRecords.add( new HSSObjectInstance(sObj) );
	    		}
	    		instanceRecords.sort();
	    		
	    		allRecords.clear();
	    		for(HSSObjectInstance sObjIns : instanceRecords){
	    			allRecords.add(sObjIns.record);
	    		}                                            
	        }
		}
		
		totalRecordsFound = allRecords.size();
		
		if(allRecords.size() > pageAndSortMapping.PageSize) {
			List<sObject> reqRecords = new list<sObject>();
	        Integer indexVal = (pageAndSortMapping.CurrentPage - 1) * pageAndSortMapping.PageSize;
	        while(indexVal < pageAndSortMapping.CurrentPage * pageAndSortMapping.PageSize) {
	        	if(allRecords.size() > indexVal){
	        		reqRecords.add( allRecords[indexVal] );
	        	}else{
	        		break;
	        	}
	        	indexVal++;
	        }
	        allRecords = reqRecords;
		}
    	
        //system.assert(false, allRecords);
        return allRecords;
    }
    
    private static Map<String, list<sObject>> getObjectNameToObjectRecordsMap(List<List<sObject>> soslResults) {
    	Map<String, list<sObject>> soslResultMap = new Map<String, list<sObject>>();
    	for(List<sObject> records : soslResults) {
    		if(records.size() > 0) {
	    		String objectType = String.valueOf(records[0].getSObjectType());
	    		soslResultMap.put(objectType, records);
    		}
    	}
    	return soslResultMap;
    }
    
    /**
     * Name: formatTextValueToBeSearched
     * Desc: Method which formats the seacrhed text
     * @param:  (1) textValueToEscape - String - The text value which is to be formated 
     * @return: String - Formatted Text
    **/
    private static String formatTextValueToBeSearched(String textValueToEscape){
    	// Escape Single Quotes
    	textValueToEscape = (textValueToEscape == null) ? '' : textValueToEscape;
    	textValueToEscape = String.escapeSingleQuotes(textValueToEscape);
    	
    	textValueToEscape = textValueToEscape.replace('&', '\\\\&')
    										 .replace('|', '\\\\|')
    										 .replace('!', '\\\\!')
    										 .replace('{', '\\\\{')
    										 .replace('}', '\\\\}')
    										 .replace('[', '\\\\[')
    										 .replace(']', '\\\\]')
    										 .replace('(', '\\\\(')
    										 .replace(')', '\\\\)')
    										 .replace('^', '\\\\^')
    										 .replace('~', '\\\\~')
    										 .replace(':', '\\\\:')
    										 .replace('\\', '\\\\')
    										 .replace('"', '\\\\"')
    										 .replace('\'', '\\\'')
    										 .replace('+', '\\\\+')
    										 .replace('-', '\\\\-');
		return textValueToEscape;
    }
}