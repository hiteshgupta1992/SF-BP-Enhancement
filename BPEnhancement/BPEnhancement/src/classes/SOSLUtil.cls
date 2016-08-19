/**
 * Author: Tarun Khandelwal
 * Since: Feb. 07, 2015
 * Name: SOSLUtil
 * Description: Apex class which contains all the SOSL queries and gives result.
**/
public with sharing class SOSLUtil {
	
	// Variables to use in dynamic Time clause sosl query
	public static Datetime dateTimeToCompare;
    public static Datetime fromDateTime;
    public static Datetime toDateTime;
    public static Integer totalRecordsFound;
    
	/**
     * Name: getOrgSearchResults
     * Desc: Method which perform a SOSL search in whole org in defined objects and returns result for the search
     * @param:  (1) objectsToSearch - List<String>  -List of Objects in which seach is to be performed
     			(2) pageAndSortMapping - Utility.PageAndSortFilter - Object Instance used as JSON object
     			(3) filterfieldToSearchedValueMap - Map<String, String> - Map of filter field to seached value
     * @return: List<sObject> - Searched records list
    **/
    public static List<sObject> getOrgSearchResults(List<String> objectsToSearch, Utility.PageAndSortFilter pageAndSortMapping, Map<String, List<String>> filterfieldToSearchedValueMap){
        String objectTypeSortDirection;
    	Utility.sortMapping = pageAndSortMapping.SortBy;
    	Boolean isAnyFilterPresent = false;
    	totalRecordsFound = 0;
    	
    	if(Utility.sortMapping.size() == 0){
    		Utility.sortMapping.add(new Utility.SortByMapping('Last_Edited', 'DESC'));
    	}
    	/*
    	if(objectTypeSortDirection != null){
    		Utility.sortMapping.add(new Utility.SortByMapping('Type', objectTypeSortDirection));
    	}
    	*/
    	
    	List<String> sortAttrs = Utility.prepareSortMap(objectTypeSortDirection, isAnyFilterPresent);
    	objectTypeSortDirection = sortAttrs[0];
    	isAnyFilterPresent = boolean.valueOf(sortAttrs[1]);
    	//System.assert( false, 'objectTypeSortDirection: ' + objectTypeSortDirection + '\n' + isAnyFilterPresent + '\n' + Utility.sortMapping );
        
        String searchResult;
        String textToSearch = (pageAndSortMapping.SearchText != null) ? pageAndSortMapping.SearchText : '';
        Integer pageNumber = (pageAndSortMapping.PageNumber != null) ? pageAndSortMapping.PageNumber : 1;
        Integer pageSize = (pageAndSortMapping.PageSize != null) ? pageAndSortMapping.PageSize : Constants.searchPageGridSize;
        List<Utility.SortByMapping> orderByFieldsMap = pageAndSortMapping.SortBy;
        
        textToSearch = formatTextValueToBeSearched(textToSearch);
        objectsToSearch = (objectsToSearch == null || objectsToSearch.size() == 0) ? Constants.homeSearchObjectsOrderedList : objectsToSearch;
        Integer offsetValue = pageSize * ( (pageNumber > 0) ? (pageNumber - 1) : pageNumber );
        orderByFieldsMap = (orderByFieldsMap == null || orderByFieldsMap.size() == 0) 
        					? new List<Utility.SortByMapping>{ new Utility.SortByMapping('LastModifiedDate', 'DESC') }
        					: orderByFieldsMap;
        
        // A list to hold the search result sobjects list
        List<SObjectInstance> instanceRecords = new List<SObjectInstance>();
        Map<String, List<sObject>> soslResultMap = getTextSearchResult( textToSearch, objectsToSearch, null, offsetValue, pageSize, orderByFieldsMap, filterfieldToSearchedValueMap, new Map<String, List<sObject>>());
        
        //System.assert(false, soslResultMap);
        List<sObject> soslResultList = sortTheRecords(objectTypeSortDirection, isAnyFilterPresent, soslResultMap, pageAndSortMapping);
		
        return soslResultList;
    }
    
    /**
     * Name: getTextSearchResult
     * Desc: Method which make dynamic SOSL and provide result
     * @param:  (1) textToSearch - String - The text value which is to be searched 
     			(2) objectsToSearch - List<String>  -List of Objects in which seach is to be performed
     			(3) idsToExclude - List<Id> - List of Ids that are to be excluded
     			(4) offsetValue - Integer - Offset value
     			(5) pageSize - Integer - Page size parameter
     			(2) orderByFieldsMap - List<Utility.SortByMapping> - List of objects related to sorting
     			(3) filterfieldToSearchedValueMap - Map<String, String> - Map of filter field to seached value
     * @return: List<sObject> - Searched records list
    **/
    private static Map<String, List<sObject>> getTextSearchResult(  String textToSearch, 
                            List<String> objectsToSearch, 
                            List<Id> idsToExclude, 
                            Integer offsetValue,
                            Integer pageSize,
                            List<Utility.SortByMapping> orderByFieldsMap,
                            Map<String, List<String>> filterfieldToSearchedValueMap,
                            Map<String, List<sObject>> soslResultMap){
		idsToExclude = (idsToExclude == null) ? new List<Id>() : idsToExclude;
		
		// Check for sort order of objects
		for(Utility.SortByMapping sortMap : orderByFieldsMap){
			if(sortMap.fieldName == 'T'){
				objectsToSearch.sort();
				if(sortMap.direction == 'DESC'){
					objectsToSearch = Utility.getReveresedSortList(objectsToSearch);
				}
				break;
			}
		}
		
		// SOSL query string
		String soslQuery = 'Find \'';
		if(textToSearch.trim().length() != 0){
			soslQuery += textToSearch + ' OR ' + textToSearch + '* ' + ' OR ' + '*' + textToSearch + '*';
		} else {
			soslQuery += '* * OR  * OR * ';
		}
		soslQuery += '\' IN ALL FIELDS RETURNING ';
		
		for(String objName : objectsToSearch){

			soslQuery += ((objName == 'Customer' || objName == 'Vendor') ? 'Account' : objName) + ' (';
			for(String objFieldName : Constants.searchableObjectToFieldsMap.get(objName)){
				soslQuery += objFieldName + ', ';
			}
			soslQuery = soslQuery.substring(0, soslQuery.length() - 2);
			soslQuery += ' WHERE Id NOT IN: idsToExclude';
			
			objName = (objName == 'Customer' || objName == 'Vendor') ? 'Account' : objName;
			for(String fiterField : filterfieldToSearchedValueMap.keyset()) {
				if(fiterField == 'OptionNumber') {
					soslQuery += addTimeClause(filterfieldToSearchedValueMap.get(fiterField));
				} else if(fiterField == 'Active__c') {
					soslQuery += ' AND ( ';
					for(String filterValue : filterfieldToSearchedValueMap.get(fiterField)) {
						if(filterValue == 'Open') {
							soslQuery += fiterField + ' = true OR ';
						} else if(filterValue == 'Close') {
							soslQuery += fiterField + ' = false OR ';
						}
					}
					soslQuery = soslQuery.substring(0, soslQuery.length() - 3);
					soslQuery += ' ) ';
					
				} else if(fiterField == 'OwnerId') {
					String ownerField = fiterField;
					if( Constants.objectToMasterOwnerField.containsKey(objName) ) {
						ownerField = Constants.objectToMasterOwnerField.get(objName);
					}
					soslQuery += ' AND ( ';
					for(String filterValue : filterfieldToSearchedValueMap.get(fiterField)) {
						soslQuery += ownerField + ' = \'' + filterValue + '\'' + ' OR ';
					}
					soslQuery = soslQuery.substring(0, soslQuery.length() - 3);
					soslQuery += ' ) ';
				} else if(filterfieldToSearchedValueMap.get(fiterField)[0] == 'true' || filterfieldToSearchedValueMap.get(fiterField)[0] == 'false') {
					if(objName == 'Account') {
						soslQuery += ' AND ' + fiterField + ' = ' + filterfieldToSearchedValueMap.get(fiterField)[0];
					}
				} else {
					soslQuery += ' AND ( ';
					for(String filterValue : filterfieldToSearchedValueMap.get(fiterField)) {
						soslQuery += fiterField + ' = \'' + filterValue + '\'' + ' OR ';
					}
					soslQuery = soslQuery.substring(0, soslQuery.length() - 3);
					soslQuery += ' ) ';
				}
			}
			soslQuery += Utility.getOrderByQueryBySortMap(((objName == 'Account') ? 'Customer' : objName), orderByFieldsMap);
			soslQuery += '), ';
		}
		soslQuery = soslQuery.substring(0, soslQuery.length() - 2);
		
		//system.assert(false, Utility.sortMapping + '\n\n' + soslQuery);
		List<List<sObject>> searchResultList = Search.query(soslQuery);
    	idsToExclude.addAll( getResultRecordIds(searchResultList, soslResultMap, pageSize) );
    	
    	if( offsetValue > 2000 ){
    		getTextSearchResult(textToSearch, objectsToSearch, idsToExclude, (offsetValue - 2000), pageSize, orderByFieldsMap, filterfieldToSearchedValueMap, soslResultMap);
    	}
    	
		return soslResultMap;
    }
    
    /**
     * Name: formatTextValueToBeSearched
     * Desc: Method which formats the seacrhed text
     * @param:  (1) textValueToEscape - String - The text value which is to be formated 
     * @return: String - Formatted Text
    **/
    public static String formatTextValueToBeSearched(String textValueToEscape){
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
    
    /**
     * Name: getResultRecordIds
     * Desc: Method which gives the searched records Id List
     * @param:  (1) searchResultList - List<List<sObject>> - the searched result
     			(2) soslResultList - List<sObject> - sosl Searched result
     			(3) pageSize - Integer - Page size parameter
     * @return: String - Formatted Text
    **/
    private static List<Id> getResultRecordIds(List<List<sObject>> searchResultList, Map<String, List<sObject>> soslResultMap, Integer pageSize){
    	List<Id> idsToExclude = new List<Id>();
    	
    	for(List<sObject> resultList : searchResultList){
    		if(resultList.size() > 0){
    			String objectType = String.valueOf(resultList[0].getSObjectType());
	    		List<sObject> objectRecords = (soslResultMap.containsKey(objectType)) ? soslResultMap.get(objectType) : new List<sObject>();
	    		
	            for(sObject resultRecord : resultList){
	                idsToExclude.add( Id.valueOf(String.valueOf(resultRecord.get('Id'))) );
	            }
	            objectRecords.addAll(resultList);
	            soslResultMap.put(objectType, objectRecords);
	            
	            totalRecordsFound += resultList.size();
    		}
        }
    	return idsToExclude;
    }
    
    private static List<sObject> sortTheRecords(String objectTypeSortDirection,
    											Boolean isAnyFilterPresent,
    											Map<String, List<sObject>> soslResultMap,
    											Utility.PageAndSortFilter pageAndSortMapping){
    	List<sObject> allRecords = new List<sObject>();
    	//System.assert(false, Utility.sortMapping + '\n' + objectTypeSortDirection + '\n' + isAnyFilterPresent + '\n' + pageAndSortMapping + '\n' + soslResultMap);
    	
    	if(objectTypeSortDirection != null){
        	Map<String, list<sObject>> objectRecords = soslResultMap;
	        
	        List<String> sortedObjectsList = Constants.homeSearchObjectsOrderedList;
            sortedObjectsList.sort();
            sortedObjectsList = (objectTypeSortDirection == 'DESC') ? Utility.getReveresedSortList(sortedObjectsList) : sortedObjectsList;
            
            for(String objName : sortedObjectsList){
				String dupObjName = (objName == 'Customer' || objName == 'Vendor') ? 'Account' : objName;
            	if(objectRecords.containsKey(dupObjName)){
            		List<sObject> objRecords = objectRecords.get(dupObjName);
            		
            		List<SObjectInstance> instanceRecords = new List<SObjectInstance>();
            		for(sObject sObj : objRecords){
            			instanceRecords.add( new SObjectInstance(sObj) );
            		}
            		
            		if(isAnyFilterPresent){
            			if(Utility.sortMapping.size() == 1 && Utility.sortMapping[0].fieldName == 'Last_Edited'){
            				
            			} else {
            				//instanceRecords.sort();
            			}
            		}
            		
            		objRecords.clear();
            		for(SObjectInstance sObjIns : instanceRecords){
            			allRecords.add(sObjIns.record);
            		}
            	} 
            }
        } else {
        	Map<String, list<sObject>> objectRecords = soslResultMap;
	        Integer totalObjectsForWhichRecordsFound = 0;
	        
	        List<String> sortedObjectsList = Constants.homeSearchObjectsOrderedList;
            for(String objName : sortedObjectsList){
				String dupObjName = (objName == 'Customer' || objName == 'Vendor') ? 'Account' : objName;
            	if(objectRecords.containsKey(dupObjName)){
            		List<sObject> objRecords = objectRecords.get(dupObjName);
            		allRecords.addAll(objRecords);
            		objectRecords.remove(dupObjName);
            		totalObjectsForWhichRecordsFound++;
            	} 
            }
	        
	        if(isAnyFilterPresent && totalObjectsForWhichRecordsFound > 1){  
	        	List<SObjectInstance> instanceRecords = new List<SObjectInstance>();
	    		for(sObject sObj : allRecords){
	    			instanceRecords.add( new SObjectInstance(sObj) );
	    		}
	    		instanceRecords.sort();
	    		
	    		allRecords.clear();
	    		for(SObjectInstance sObjIns : instanceRecords){
	    			allRecords.add(sObjIns.record);
	    		}                                            
	        }
		}
		
		List<sObject> reqRecords = new list<sObject>();
        Integer indexVal = (pageAndSortMapping.PageNumber - 1) * pageAndSortMapping.PageSize;
        while(indexVal < pageAndSortMapping.PageNumber * pageAndSortMapping.PageSize) {
        	if(allRecords.size() > indexVal){
        		reqRecords.add( allRecords[indexVal] );
        	}else{
        		break;
        	}
        	indexVal++;
        }
        allRecords = reqRecords;
    	
        //system.assert(false, allRecords);
        return allRecords;
    }
    
    /** 
     * Name: addTimeClause
     * Desc: Method to Add Time Where Clause according to filter
     * @param: (1) mapValue - List<String> - Time filter selected value with their option number
     * @return: String - Where Time Clause SOSL query as a string format
    **/
    private static String addTimeClause(List<String> mapValue) {
    	String optionNumber = mapValue[0];
    	String optionValue = mapValue[1];
    	String timeClauseQuery = ' AND ';
    	
    	if(optionNumber == '1' || optionNumber == '2') {
    		List<String> optionValueList = optionValue.split(' ');
    		if(optionValueList[1] == 'minutes') {
    			dateTimeToCompare = Datetime.now().addMinutes(-Integer.valueOf(optionValueList[0]));
    		} else if(optionValueList[1] == 'hours') {
    			dateTimeToCompare = Datetime.now().addHours(-Integer.valueOf(optionValueList[0]));
    		} else if(optionValueList[1] == 'days') {
    			dateTimeToCompare = Datetime.now().addDays(-Integer.valueOf(optionValueList[0]));
    		} else if(optionValueList[1] == 'weeks') {
    			dateTimeToCompare = Datetime.now().addDays(-(Integer.valueOf(optionValueList[0]) * 7 ));
    		}
    		
    		if(optionNumber == '1') {
    			timeClauseQuery += ' LastModifiedDate >= :dateTimeToCompare '; 
    		} else if(optionNumber == '2') {
    			timeClauseQuery += ' LastModifiedDate <= :dateTimeToCompare '; 
    		}
    		
    	} else if(optionNumber == '3') {
    		List<String> dateRangeList = optionValue.split(' To ');
    		Date fromDate = date.parse(dateRangeList[0]);
    		fromDateTime = datetime.newInstance(fromDate.year(), fromDate.month(), fromDate.day()-1, 0, 0, 0);
    		Date toDate = date.parse(dateRangeList[1]);
    		toDateTime = datetime.newInstance(toDate.year(), toDate.month(), toDate.day()+1);
    		//system.assert(false, fromDateTime + '**' + toDateTime);
    		timeClauseQuery += ' LastModifiedDate >= :fromDateTime AND LastModifiedDate <= :toDateTime ';
    		
    	} else if(optionNumber == '4') {
    		List<String> subString = new List<String>();
    		if(optionValue.contains(' @ ')) {
    			subString = optionValue.split(' @ ');
    			optionValue = subString[0];
    		}
    		List<String> rangeList = optionValue.split(' To ');
    		String fromDateInterval = rangeList[0];
    		//system.assert(false, subString.size() + ' ** ' + subString);
    		if(subString.size() == 0) {
    			fromDateTime = parseStringToGetTimeCondition(fromDateInterval, system.now());
    		} else {
    			fromDateTime = parseStringToGetTimeCondition(fromDateInterval, Datetime.valueOf(subString[1]));
    		}
    		
    		String toDateInterval = rangeList[1];
    		if(subString.size() == 0) {
    			toDateTime = parseStringToGetTimeCondition(toDateInterval, system.now());
    		} else {
    			toDateTime = parseStringToGetTimeCondition(toDateInterval, Datetime.valueOf(subString[1]));
    		}
    		timeClauseQuery += ' LastModifiedDate >= :fromDateTime AND LastModifiedDate <= :toDateTime ';
    	}
    	//system.assert(false, timeClauseQuery);
    	return timeClauseQuery; 
    }
    
    /** 
     * Name: parseStringToGetTimeCondition
     * Desc: Method to parse String condition in Date Time Format
     * @param: (1) dateInteval - String - Date Interval in terms of Weeks and days (like - 4w 2d)
     * @return: Datetime - DateTime field related to give time String 
    **/
    private static Datetime parseStringToGetTimeCondition(String dateInteval, DateTime compareDate) {
    	Boolean isPreviousInterval = false;
    	DateTime requiredDate;
		if(dateInteval.contains('-')) {
			isPreviousInterval = true;
			dateInteval = dateInteval.substring(1, dateInteval.length());
		} 
		Integer numberOfDays = 0;
		if(dateInteval.contains('w')) {
			List<String> subStrings = dateInteval.split('w');
			numberOfDays = Integer.valueOf(subStrings[0]) * 7;
			if(subStrings.size() > 1 && subStrings[1].contains('d')) {
				List<String> daysSubString = subStrings[1].split('d');
				daysSubString[0] = daysSubString[0].substring(1, daysSubString[0].length());
				numberOfDays += Integer.valueOf(daysSubString[0]);
			}
		} else {
			List<String> subStrings = dateInteval.split('d');
			numberOfDays = Integer.valueOf(subStrings[0]);
		}
		
		if(isPreviousInterval) {
			requiredDate = compareDate.addDays(-numberOfDays);
		} else {
			requiredDate = compareDate.addDays(numberOfDays);
		}
		return requiredDate;
    }
}