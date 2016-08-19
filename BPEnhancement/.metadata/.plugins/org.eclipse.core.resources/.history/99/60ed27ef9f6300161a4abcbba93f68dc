public with sharing class RecentViewRecordsUtil {
	public static Integer totalRecordsFound = 0;
	
	public static List<Sobject> getOrgBlankSearchResults(Utility.PageAndSortFilter pageAndSortMapping) {		
    	String objectTypeSortDirection;
    	Utility.sortMapping = pageAndSortMapping.SortBy;
    	Boolean isAnyFilterPresent = false;
    	
    	List<String> sortAttrs = Utility.prepareSortMap(objectTypeSortDirection, isAnyFilterPresent);
    	objectTypeSortDirection = sortAttrs[0];
    	isAnyFilterPresent = boolean.valueOf(sortAttrs[1]);
    	//System.assert( false, 'objectTypeSortDirection: ' + objectTypeSortDirection + '\n' + isAnyFilterPresent + '\n' + Utility.sortMapping );
    	
        List<RecentlyViewed> recentlyViwedRecords = getRecentViewedRecords(objectTypeSortDirection, isAnyFilterPresent);
        List<Id> recentlyViwedRecIdList = new List<Id>();
        for(RecentlyViewed RecViwedRec : recentlyViwedRecords){
            recentlyViwedRecIdList.add(RecViwedRec.Id);
        }

        totalRecordsFound = recentlyViwedRecIdList.size();
        List<Map<Id, Sobject>> sobjectMapList = new List<Map<Id, Sobject>>();
        
        for(String objectName : Constants.homeSearchObjectsOrderedList) {
        	objectName = (objectName == 'Customer' || objectName == 'Vendor') ? 'Account': objectName;
        	if(Limits.getLimitQueries() - Limits.getQueries() == 0) {
                break;
            }
            if(AccessControl.ifObjectFieldIsAccessible(objectName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            String query = 'SELECT ';
            for(String fieldName : Constants.searchableObjectToFieldsMap.get(objectName)) {
                query +=  fieldName + ', ' ;
            }
            query = query.substring(0, query.length()-2);
            query += ' FROM ' + objectName + ' WHERE Id IN :recentlyViwedRecIdList' ;
            query += Utility.getOrderByQueryBySortMap(objectName, Utility.sortMapping);
            
            Map<Id, Sobject> sobjectMap = new Map<Id, Sobject>(Database.query(query));
            sobjectMapList.add(sobjectMap);
        }
        
        List<sObject> allRecords = sortTheRecords(objectTypeSortDirection, isAnyFilterPresent, sobjectMapList, recentlyViwedRecIdList, pageAndSortMapping);
        return allRecords;
    }
    
    private static List<RecentlyViewed> getRecentViewedRecords(String objectTypeSortDirection, Boolean isAnyFilterPresent){
    	if(AccessControl.ifObjectFieldIsAccessible('RecentlyViewed') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<String> objectSet = Constants.homeSearchObjectsOrderedList;
    	List<RecentlyViewed> recentlyViwedRecords = new List<RecentlyViewed>();
    	
		String query = 'SELECT Id FROM RecentlyViewed WHERE Type IN : objectSet ';
		objectTypeSortDirection = BPUtility.escapeSingleQuotes(objectTypeSortDirection);
		if( objectTypeSortDirection != null ){
			query += ' ORDER BY Type ' + objectTypeSortDirection + ', LastViewedDate DESC';
		} else if( !isAnyFilterPresent ){
			query += ' ORDER BY LastViewedDate DESC';
		}
    	recentlyViwedRecords = Database.query(query);
    	return recentlyViwedRecords;
    }
    
    private static List<sObject> sortTheRecords(String objectTypeSortDirection,
    											Boolean isAnyFilterPresent,
    											List<Map<Id, Sobject>> sobjectMapList,
    											List<Id> recentlyViwedRecIdList,
    											Utility.PageAndSortFilter pageAndSortMapping){
    	List<sObject> allRecords = new List<sObject>();
        
        if(objectTypeSortDirection != null && isAnyFilterPresent){
        	Map<String, list<sObject>> objectRecords = new Map<String, List<sObject>>();
        	for(Map<Id, sObject> sobjMap : sobjectMapList) {
        		if( sobjMap.size() > 0 ){
        			String objName = String.valueOf(sobjMap.values()[0].getSObjectType());
        			objectRecords.put(objName, sobjMap.values());
        		}
            }
	        
	        List<String> sortedObjectsList = Constants.homeSearchObjectsOrderedList;
            sortedObjectsList.sort();
            sortedObjectsList = (objectTypeSortDirection == 'DESC') ? Utility.getReveresedSortList(sortedObjectsList) : sortedObjectsList;
            for(String objName : sortedObjectsList){
            	if(objectRecords.containsKey(objName)){
            		List<sObject> objRecords = objectRecords.get(objName);
            		List<SObjectInstance> instanceRecords = new List<SObjectInstance>();
            		for(sObject sObj : objRecords){
            			instanceRecords.add( new SObjectInstance(sObj) );
            		}
            		instanceRecords.sort();
            		objRecords.clear();
            		for(SObjectInstance sObjIns : instanceRecords){
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
	        
	        List<String> sortedObjectsList = Constants.homeSearchObjectsOrderedList;
            sortedObjectsList.sort();
            //System.assert(false, sortedObjectsList);
            
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
		
		//System.assert(false, allRecords[0].get('Id'));
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
}