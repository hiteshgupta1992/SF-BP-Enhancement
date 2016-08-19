/**
 * Name: HomeSearchRecentRecords
 * Description: 
 * 
**/
public with sharing class HomeSearchRecentRecords {
    public static Integer totalRecordsFound = 0;
	
	public static List<SObject> getOrgBlankSearchResults(PaginationSorting pageAndSortMapping) {
		HomeSearchUtil.sortMapping = pageAndSortMapping.Sorting;
		
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
		
		// Get recent records
		List<RecentlyViewed> recentlyViwedRecords = getRecentViewedRecords(pageAndSortMapping, objectTypeSortDirection);
		totalRecordsFound = recentlyViwedRecords.size();
		
		// Get records Ids so as to get record Ids and query for required fields to display on page
		List<Id> recentlyViwedRecIdList = new List<Id>();
        for(RecentlyViewed RecViwedRec : recentlyViwedRecords){
            recentlyViwedRecIdList.add(RecViwedRec.Id);
        }
        
        List<Map<Id, Sobject>> sobjectMapList = new List<Map<Id, Sobject>>();
        for(String objectName : HomeSearchUtil.searchableObjectToFieldsMap.keySet()) {
        	objectName = (objectName == 'Customer' || objectName == 'Vendor') ? 'Account': objectName;
        	if(Limits.getLimitQueries() - Limits.getQueries() == 0) {
                break;
            }
            
            if(AccessControl.ifObjectFieldIsAccessible(objectName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            String query = 'SELECT ';
            for(String FieldName : HomeSearchUtil.searchableObjectToFieldsMap.get(objectName)) {
                query +=  FieldName + ', ' ;
            }
            query = query.substring(0, query.length()-2);
            query += ' FROM ' + objectName + ' WHERE Id IN :recentlyViwedRecIdList' ;
            query += getOrderByQueryBySortMap(objectName, HomeSearchUtil.sortMapping);
           
           System.debug('######\n\n' + query);
            Map<Id, Sobject> sobjectMap = new Map<Id, Sobject>(Database.query(query));
            sobjectMapList.add(sobjectMap);
        }
        
        List<sObject> allRecords = sortTheRecords(objectTypeSortDirection, isAnyFilterPresent, sobjectMapList, recentlyViwedRecIdList, pageAndSortMapping);
        return allRecords;
	}
	
	private static List<RecentlyViewed> getRecentViewedRecords(PaginationSorting pageAndSortMapping, String objectTypeSortDirection){
    	Set<String> objectSet = HomeSearchUtil.searchableObjectToFieldsMap.keySet();
    	List<RecentlyViewed> recentlyViwedRecords = new List<RecentlyViewed>();
    	 if(AccessControl.ifObjectFieldIsAccessible('RecentlyViewed') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String query = 'SELECT Id FROM RecentlyViewed WHERE Type IN : objectSet';
		objectTypeSortDirection = BPUtility.escapeSingleQuotes(objectTypeSortDirection);
		String orderByClause = ' ORDER BY';
		if( objectTypeSortDirection != null ){
			orderByClause += ' Type ' + objectTypeSortDirection;
		}
		for(PaginationSorting.SortAttrs sortField : pageAndSortMapping.Sorting) {
			if(sortField.FieldName == 'LastModifiedDate') {
				orderByClause += (objectTypeSortDirection != null) ? ', ' : '';
				orderByClause += 'LastViewedDate ' + sortField.SortDirection;
			}
		}
		if(orderByClause.indexOf('LastViewedDate') == -1) {
			orderByClause += 'LastViewedDate DESC';
		}
		
    	recentlyViwedRecords = Database.query(query);
    	return recentlyViwedRecords;
    }
    
    private static List<sObject> sortTheRecords(String objectTypeSortDirection,
    											Boolean isAnyFilterPresent,
    											List<Map<Id, Sobject>> sobjectMapList,
    											List<Id> recentlyViwedRecIdList,
    											PaginationSorting pageAndSortMapping
    										){
		List<sObject> allRecords = new List<sObject>();
		List<String> sortedObjectsList = new List<String>(HomeSearchUtil.searchableObjectToFieldsMap.keySet());
        sortedObjectsList.sort();

		if(objectTypeSortDirection != null && isAnyFilterPresent){
        	Map<String, list<sObject>> objectRecords = new Map<String, List<sObject>>();
        	for(Map<Id, sObject> sobjMap : sobjectMapList) {
        		if( sobjMap.size() > 0 ){
        			String objName = String.valueOf(sobjMap.values()[0].getSObjectType());
        			objectRecords.put(objName, sobjMap.values());
        		}
            }
	        
            sortedObjectsList = (objectTypeSortDirection == 'DESC') ? Utility.getReveresedSortList(sortedObjectsList) : sortedObjectsList;
            for(String objName : sortedObjectsList){
            	if(objectRecords.containsKey(objName)){
            		List<sObject> objRecords = objectRecords.get(objName);
            		List<HSSObjectInstance> instanceRecords = new List<HSSObjectInstance>();
            		for(sObject sObj : objRecords){
            			instanceRecords.add( new HSSObjectInstance(sObj) );
            		}
            		instanceRecords.sort();
            		objRecords.clear();
            		for(HSSObjectInstance sObjIns : instanceRecords){
            			allRecords.add(sObjIns.record);
            		}
            	} 
            }
        } else if( objectTypeSortDirection != null && !isAnyFilterPresent ){
        	Map<String, list<sObject>> objectRecords = new Map<String, List<sObject>>();
            for(Id recentlyViwedRecId : recentlyViwedRecIdList){
	            for(Map<Id, Sobject> sobjMap : sobjectMapList) {
	                if(sobjMap.containsKey(recentlyViwedRecId)) {
	                    String objName = String.valueOf(sobjMap.get(recentlyViwedRecId).getSObjectType());
	                    List<sObject> objRecs = (objectRecords.containsKey(objName)) ? objectRecords.get(objName) : new List<sObject>();
	                    objRecs.add(sobjMap.get(recentlyViwedRecId));
	                    objectRecords.put(objName, objRecs);
	                    break;
	                }
	            }
	        }
	        
            sortedObjectsList = (objectTypeSortDirection == 'DESC') ? Utility.getReveresedSortList(sortedObjectsList) : sortedObjectsList;
            for(String objName : sortedObjectsList){
            	if(objectRecords.containsKey(objName)){
            		List<sObject> objRecords = objectRecords.get(objName);
            		allRecords.addAll(objRecords);
            	} 
            }
        } else {
        	for(Id recentlyViwedRecId : recentlyViwedRecIdList){
	            for(Map<Id, Sobject> sobjMap : sobjectMapList) {
	                if(sobjMap.containsKey(recentlyViwedRecId)) {
	                    allRecords.add(sobjMap.get(recentlyViwedRecId));
	                    break;
	                }
	            }
	        }
	        
	        if(isAnyFilterPresent){  
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
		
		return allRecords;
	}
	
	/**
     * Name: getOrderByQueryBySortMap
     * Desc: Method to get Order by query for particular object
     * @param:  (1) objectName - String - Object Name
     			(2) orderByFieldsMap - List<PaginationSorting.SortAttrs> - List of objects used as JSON
     * @return: String - query String                             
    **/
    public static String getOrderByQueryBySortMap(String objectName, List<PaginationSorting.SortAttrs> orderByFieldsMap){
    	orderByFieldsMap = (orderByFieldsMap == null) ? new List<PaginationSorting.SortAttrs>() : orderByFieldsMap;
    	String orderByQuery = '';
		for(PaginationSorting.SortAttrs sortField : orderByFieldsMap){
			String fieldAPIName;
			if(sortField.FieldName != null 
				&& HomeSearchUtil.searchableObjectToFieldsMap.containsKey(objectName) 
				&& HomeSearchUtil.searchableObjectToFieldsMap.get(objectName).contains(sortField.FieldName)
			){
				fieldAPIName = sortField.FieldName;
			} else if(sortField.FieldName != null 
						&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(objectName) 
						&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objectName).containsKey(sortField.FieldName)
					) {
				fieldAPIName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objectName).get(sortField.FieldName);
			}
			if(fieldAPIName != null) {
				orderByQuery += ' ' + fieldAPIName + ' ' + sortField.SortDirection + ',';
			}
		}
		if( orderByQuery.length() != 0 ){
			orderByQuery = ' ORDER BY ' + orderByQuery;
			orderByQuery = orderByQuery.substring(0, orderByQuery.length() - 1);
		}
		return orderByQuery;
    }
}