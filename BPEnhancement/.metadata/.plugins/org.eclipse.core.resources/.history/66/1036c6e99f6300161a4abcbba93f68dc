/**
 * Author: Tarun Khandelwal
 * Since: April 15, 2016
 * Name: HomeSearchReportUtil
 * Description: Apex class to handle all operations related to Home Search Reporting Data
**/
public with sharing class HomeSearchReportUtil {
	
	public Static String NUMERIC_TYPE_1 = 'Number';
	public Static String NUMERIC_TYPE_2 = 'Currency';
	public Static Set<String> textFieldTypes = new Set<String>{'Text', 'Date'};
	public static String COUNT_RECORD_ALIASE = 'TotalRecords';
	public static String COUNT_RECORD_LABEL = 'Total Records';
	public static final Integer QUERY_LIMIT_RECORDS = 2500;
	
	public static Set<String> fieldLabelSet = new Set<String>();
	public static Map<String, String> fieldLabelToTypeMap = new Map<String, String>();
	
	public static String getReportingResult(HomeSearchFilterWrapper filterWrapperObj) {
		String seachableObject = HomeSearchUtil.getGenericObjectNameBySelectedObject(filterWrapperObj.Type.Objects);
		Boolean isGroup = checkForGroup(seachableObject);
		
		Map<String, List<String>> objeNameToNumericFieldAPINameMap = new Map<String, List<String>>();
		List<AggregateResult> aggregateResultList = new List<AggregateResult>();
		Set<String> NumericFieldAPINameSet = new Set<String>();
		List<HomeSearchReportResultWrapper> hsResultWrapper = new List<HomeSearchReportResultWrapper>();
		fieldLabelSet.add(COUNT_RECORD_ALIASE);
		
		Map<String, String> objNameToWhereClauseMap = HomeSearchReportInterface.getWhereClauseForObjects(filterWrapperObj);
		//system.assert(false, objNameToWhereClauseMap);
		//Map<String, List<HomeSearchFilterInterface.FieldFilter>> objNameToFieldFilterListMap = HomeSearchFilterInterface.getFilterList(filterWrapperObj);
		
		//List<HomeSearchFilterInterface.FieldFilter> filterList = objectFiltersMap.get(objName);
		
		if(!isGroup) {
			objeNameToNumericFieldAPINameMap = getNumericColumns(seachableObject);
			//system.assert(false, objeNameToNumericFieldAPINameMap);
			for(String objName : filterWrapperObj.Type.Objects) {
				if(objeNameToNumericFieldAPINameMap.containsKey(seachableObject)) {
					aggregateResultList.addAll(getAggregateResultByObjName(objName, objeNameToNumericFieldAPINameMap.get(seachableObject), objNameToWhereClauseMap.get(objName)));
				} else {
					aggregateResultList.addAll(getAggregateResultByObjName(objName, new List<String>(), objNameToWhereClauseMap.get(objName)));
				}
			}
		} else {
			if(seachableObject != Label.Generic_Object_Label) {
				for(String objName : filterWrapperObj.Type.Objects) {
					List<String> fieldAPINameList = HomeSearchUtil.objectToCommonNumericFieldAPIName.get(objName);
					
					for(Integer i = 0; i < fieldAPINameList.size(); i++) {
						fieldAPINameToFieldLabelMap.put(fieldAPINameList[i], HomeSearchUtil.objectToCommonNumericFieldLabelName.get(objName)[i]);
						fieldLabelSet.add(HomeSearchUtil.objectToCommonNumericFieldLabelName.get(objName)[i]);
						fieldLabelToTypeMap.put(HomeSearchUtil.objectToCommonNumericFieldLabelName.get(objName)[i], HomeSearchUtil.objectToCommonNumericFieldTypeMap.get(objName)[i]);
					}
					aggregateResultList.addAll(getAggregateResultByObjName(objName, HomeSearchUtil.objectToCommonNumericFieldAPIName.get(objName), objNameToWhereClauseMap.get(objName)));
				}
			} else {
				Set<String> objectSet = new Set<String>();
				if(filterWrapperObj.Type.Objects.size() == 0 || (filterWrapperObj.Type.Objects.size() == 1 && filterWrapperObj.Type.Objects.contains(Label.Generic_Object_Label))) {
					objectSet = HomeSearchUtil.displayObjectNameToTypeNumber.keySet();
				} else {
					objectSet = filterWrapperObj.Type.Objects;
				}
				//system.debug('objectSet  objectSet ' + objectSet);
				for(String objName : objectSet) {
					aggregateResultList.addAll(getAggregateResultByObjName(objName, new List<String>(), objNameToWhereClauseMap.get(objName)));
				}
			}
		}
		
		hsResultWrapper = getWrapperList(fieldLabelSet, aggregateResultList);
		
		String objNameSelected = HomeSearchUtil.getGenericObjectNameBySelectedObject(filterWrapperObj.Type.Objects);
		List<HomeSearch_Grid_Column__mdt> hsColumnsSetting = CustomMetadataTypeUtil.getGridColumnsMetadataTypeSettings(objNameSelected);
		for(HomeSearch_Grid_Column__mdt hsColumn : hsColumnsSetting) {
			if(textFieldTypes.contains(hsColumn.Type__c) && hsColumn.Field_API_Name__c != null) {
				hsResultWrapper.add(new HomeSearchReportResultWrapper(null, hsColumn.Label.replaceAll(' ', '_'), hsColumn.Type__c));
			}
		}
		
		//system.assert(false, hsResultWrapper);
		return system.Json.serialize(hsResultWrapper);
	} 
	
	private static List<HomeSearchReportResultWrapper> getWrapperList(Set<String> fieldLabelNameSet, List<AggregateResult> aggregateResultList) {
		List<HomeSearchReportResultWrapper> hsResultWrapper = new List<HomeSearchReportResultWrapper>();
		for(String fieldLabelName : fieldLabelNameSet) {
			Decimal value = 0;
			for(AggregateResult aggregate : aggregateResultList) {
				try {
					if(aggregate.get(fieldLabelName) != null) {
						value += (Decimal)aggregate.get(fieldLabelName);
					}
				} catch(exception e) {
					
				}
			}
			hsResultWrapper.add(new HomeSearchReportResultWrapper(value, fieldLabelName, fieldLabelToTypeMap.get(fieldLabelName)));
		}
		return hsResultWrapper;
	}
	
	private static Boolean checkForGroup(String objName) {
		Boolean isGroup = false;
		if(HomeSearchUtil.groupNameToGroupObjectsMap.containsKey(objName) || objName == Label.Generic_Object_Label) {
			isGroup = true;
		}
		return isGroup;
	}
	
	private static Map<String, String> fieldAPINameToFieldLabelMap = new Map<String, String>();
	
	private static Map<String, List<String>> getNumericColumns(String objName) {
		Map<String, List<String>> objeNameToNumericFieldAPINameMap = new Map<String, List<String>>();
		List<HomeSearch_Grid_Column__mdt> hsColumnsSetting = CustomMetadataTypeUtil.getGridColumnsMetadataTypeSettings(objName);
		
		for(HomeSearch_Grid_Column__mdt hsColumn : hsColumnsSetting) {
			if((hsColumn.Type__c == NUMERIC_TYPE_1 || hsColumn.Type__c == NUMERIC_TYPE_2) && hsColumn.Field_API_Name__c != null) {
				if(!objeNameToNumericFieldAPINameMap.containsKey(hsColumn.Display_Object_Name__c)) {
					objeNameToNumericFieldAPINameMap.put(hsColumn.Display_Object_Name__c, new List<String>{hsColumn.Field_API_Name__c});
				} else {
					List<String> numericFieldAPINameList = objeNameToNumericFieldAPINameMap.get(hsColumn.Display_Object_Name__c);
					numericFieldAPINameList.add(hsColumn.Field_API_Name__c);
				}
				if(hsColumn.Label != null) {
					fieldAPINameToFieldLabelMap.put(hsColumn.Field_API_Name__c, hsColumn.Label.replaceAll(' ', '_'));
					fieldLabelSet.add(hsColumn.Label.replaceAll(' ', '_'));
					fieldLabelToTypeMap.put(hsColumn.Label.replaceAll(' ', '_'), hsColumn.Type__c);
				}
			}
		}
		fieldAPINameToFieldLabelMap.put('Id', COUNT_RECORD_ALIASE);
		return objeNameToNumericFieldAPINameMap;
	}
	
	public static List<AggregateResult> getAggregateResultByObjName(String objName, List<String> numericFieldAPINameList) {
		List<AggregateResult> aggregateResultList = new List<AggregateResult>();
		String query = '';
		
		query += 'SELECT COUNT(Id) ' + COUNT_RECORD_ALIASE + ', ';
		for(String fieldName : numericFieldAPINameList) {
			query += 'SUM(' + fieldName + ') ' + fieldAPINameToFieldLabelMap.get(fieldName) + ', ';
		}
		query = query.substring(0, query.length() - 2);
		query += ' FROM ' + HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName);
		//system.debug('Aggregate Query BY TARUN : ' + query);
		
		//system.assert(false, query);
		if(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName) != null){
			if(AccessControl.ifObjectFieldIsAccessible(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName)) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		}
		aggregateResultList = Database.query(query);
		return aggregateResultList;
	}
	
	public static List<AggregateResult> getAggregateResultByObjName(String objName, List<String> numericFieldAPINameList, String whereClauseString) {
		List<AggregateResult> aggregateResultList = new List<AggregateResult>();
		String query = '';
		
		query += 'SELECT COUNT(Id) ' + COUNT_RECORD_ALIASE + ', ';
		for(String fieldName : numericFieldAPINameList) {
			query += 'SUM(' + fieldName + ') ' + fieldAPINameToFieldLabelMap.get(fieldName) + ', ';
		}
		query = query.substring(0, query.length() - 2);
		query += ' FROM ' + HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName);
		
		// get where clause
		//String whereClauseString = getWhereClause(objName, filterList);
		if(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName) != null){
			if(AccessControl.ifObjectFieldIsAccessible(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName)) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		}
		query += ' ' + whereClauseString;
		
		//system.debug('Aggregate Query BY TARUN : ' + query);
		
		//system.assert(false, query);
		aggregateResultList = Database.query(query);
		return aggregateResultList;
	}
	
	public static String getRportingDataByHomeSearchFilters(HomeSearchFilterWrapper filterWrapperObj, String selectedObjName, String uniqueValueFieldLastValue) {
		List<HomeSearchFilterInterface.FilterLabel> filterLabelList = HomeSearchFilterInterface.getFilterLabelList(filterWrapperObj);
		return getRportingDataByHomeSearchFilters(filterWrapperObj, selectedObjName, uniqueValueFieldLastValue, filterLabelList);
    }
    
    public static String getRportingDataByHomeSearchFilters(HomeSearchFilterWrapper filterWrapperObj, 
    														String selectedObjName, 
    														String uniqueValueFieldLastValue,
    														List<HomeSearchFilterInterface.FilterLabel> filterLabelList
    													) {
    	Set<String> previousSelectedObjects = filterWrapperObj.Type.Objects;
    	String objAPIName = HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(selectedObjName);
    	
    	Map<String, List<sObject>> resultRecordsMap = getRportRecordsByHomeSearchFilters(filterWrapperObj, new Set<String>{selectedObjName}, uniqueValueFieldLastValue, null);
    	List<sObject> resultRecords = resultRecordsMap.get(objAPIName);
    	
    	// Get JSON string for result records in ResultWrapper instance
    	Integer totalRecordsFound = 0;
    	HomeSearchResultWrapper.getJSONForSObjectRecords( resultRecords, 
														  HomeSearchUtil.getGenericObjectNameBySelectedObject(previousSelectedObjects),
														  totalRecordsFound,
														  null,
														  false
														);
    	String lastRecordUniqueFieldValue = '';
    	if(resultRecords.size() > 0) {
    		lastRecordUniqueFieldValue = String.valueOf(resultRecords[resultRecords.size() - 1].get(HomeSearchUtil.searchableObjectToUniqueValueFieldMap.get(objAPIName)));
    	}
    	ReportWrapper ResultData = new ReportWrapper(HomeSearchResultWrapper.result, 
    												 lastRecordUniqueFieldValue,
    												 (resultRecords.size() < QUERY_LIMIT_RECORDS),
    												 resultRecords.size(),
    												 filterLabelList
    												);
    	return System.Json.serialize(ResultData);
    }
    
    public static Map<String, List<sObject>> getRportRecordsByHomeSearchFilters(HomeSearchFilterWrapper filterWrapperObj, 
    														Set<String> selectedObjNames, 
    														String uniqueValueFieldLastValue,
    														PaginationSorting pageAndSortMapping
    													) {
    	Map<String, List<sObject>> resultRecordsMap = new Map<String, List<sObject>>();
    	// Ensure the filter wrapper contains only single object
    	// Since, we are not querying the result in loop in apex, so we need to have only 1 object name in filter wrapper
    	// Next, remaining results of remaining objects will be queried in next context call by page so as to avoid governor limits
		filterWrapperObj.Type.Objects = selectedObjNames;
		
    	// Get objects where clause from Home Search screen
    	Map<String,String> objectsWhereConditions = HomeSearchReportInterface.getWhereClauseForObjects(filterWrapperObj);
    	
    	// Create query string:
    	for(String selectedObjName : filterWrapperObj.Type.Objects) {
    		String objAPIName = HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(selectedObjName);
	    	String objQuery = createSOQLForObject(	objAPIName, 
	    											objectsWhereConditions.get(selectedObjName),
	    											HomeSearchUtil.searchableObjectToUniqueValueFieldMap.get(objAPIName),
	    											uniqueValueFieldLastValue,
	    											pageAndSortMapping
	    										);
	    	System.debug('QUERYYYYYYY objAPIName: \n' + objQuery);
	    	List<sObject> resultRecords = Database.query(objQuery);
	    	resultRecordsMap.put(objAPIName, resultRecords);
    	}
    	
    	return resultRecordsMap;
    }
    
    private static String createSOQLForObject(	String objName, 
    											String whereClause, 
    											String uniqueValueOrderByField, 
    											String uniqueValueFieldLastValue,
    											PaginationSorting pageAndSortMapping
    										) {
    	if(AccessControl.ifObjectFieldIsAccessible(objName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }	
    	String query = 'SELECT ';
    	for(String fieldName : HomeSearchUtil.searchableObjectToFieldsMap.get(objName)) {
    		query += fieldName + ',';
    	}
    	query = query.subString(0, query.length() - 1);
    	query += ' FROM ' + objName;
    	
    	if(whereClause != null && whereClause.trim().length() != 0) {
    		query += ' ' + whereClause;
    	}
    	
    	if(uniqueValueFieldLastValue != null && uniqueValueFieldLastValue.trim().length() != 0) {
    		if(whereClause != null && whereClause.trim().length() != 0) {
    			query += ' AND ';
    		} else {
    			query += ' WHERE ';
    		}
    		query += uniqueValueOrderByField + '>\'' + uniqueValueFieldLastValue + '\'';
    	}
    	
    	if(pageAndSortMapping != null) {
    		if(pageAndSortMapping.Sorting != null && pageAndSortMapping.Sorting.size() > 0) {
    			String sortClause = ' ORDER BY ';
    			for(PaginationSorting.SortAttrs sortAttr : pageAndSortMapping.Sorting) {
    				//System.assert(false, '###################' +objName +'  -- '+ sortAttr.FieldName);
    				String sortFieldAPIName = getSortFieldNameForObject(objName, sortAttr.FieldName);
    				if(sortFieldAPIName != null && sortFieldAPIName != '' && sortFieldAPIName != 'Type') {
    					sortClause += sortFieldAPIName + ' ' + sortAttr.SortDirection + ' NULLS LAST, ';
    				}
    			}
    			
    			if(sortClause != ' ORDER BY ') {
    				sortClause = sortClause.subString(0, sortClause.length() - 2);
    				query += sortClause;
    			}
    		}
    		
    		query += ' LIMIT ' + (pageAndSortMapping.CurrentPage * pageAndSortMapping.PageSize);
    	} else if(uniqueValueOrderByField != null && uniqueValueOrderByField.trim().length() != 0) {
    		query += ' ORDER BY ' + uniqueValueOrderByField + ' ASC';
    		query += ' LIMIT ' + QUERY_LIMIT_RECORDS;
    	}
    	
    	return query;
    }
    
    /**
     * Name: getSortFieldNameForObject
     * Desc: Method to Get sort Field for object
     * @param:  (1) objName - String - Object Name
     *			(2) fieldLabel - String - Field Label
     * @return: String  
     **/
	private static String getSortFieldNameForObject(String objAPIName, String fieldLabel) {
		String fieldAPIName;
		if(fieldLabel != null 
            && HomeSearchUtil.searchableObjectToFieldsMap.containsKey(objAPIName) 
            && HomeSearchUtil.searchableObjectToFieldsMap.get(objAPIName).contains(fieldLabel)
        ){
            fieldAPIName = fieldLabel;
        } else if(fieldLabel != null 
                    && HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(objAPIName) 
                    && HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objAPIName).containsKey(fieldLabel)
                ) {
            fieldAPIName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objAPIName).get(fieldLabel);
        } else if(fieldLabel != null 
                    && HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(CONSTANTS.NAMESPACE + objAPIName) 
                    && HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(CONSTANTS.NAMESPACE + objAPIName).containsKey(fieldLabel)
                ) {
            fieldAPIName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(CONSTANTS.NAMESPACE + objAPIName).get(fieldLabel);
        } else if(fieldLabel != null 
                    && HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(CONSTANTS.NAMESPACE + objAPIName) 
                    && !HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(CONSTANTS.NAMESPACE + objAPIName).containsKey(fieldLabel)
                ) {
            fieldAPIName = '';
        }
		
		//System.debug('@@@@ fieldAPIName: ' + fieldAPIName);
		return (fieldAPIName != null) ? fieldAPIName : fieldLabel;
	}
    
    public class ReportWrapper {
    	public HomeSearchResultWrapper.ResultWrapper ResultData {private set; get;}
    	public String UniqueFieldName {private set; get;}
    	public Boolean IsProcessCompleted {private set; get;}
    	public Integer TotalRecords {private set; get;}
    	public List<HomeSearchFilterInterface.FilterLabel> FilterLabelList {private set; get;}
    	
    	public ReportWrapper(HomeSearchResultWrapper.ResultWrapper ResultData, 
    						 String UniqueFieldName, 
    						 Boolean IsProcessCompleted, 
    						 Integer TotalRecords,
    						 List<HomeSearchFilterInterface.FilterLabel> filterLabelList
    					) {
    		this.ResultData = ResultData;
    		this.UniqueFieldName = UniqueFieldName;
    		this.IsProcessCompleted = IsProcessCompleted;
    		this.TotalRecords = TotalRecords;
    		this.FilterLabelList = filterLabelList;
    	}
    }
}