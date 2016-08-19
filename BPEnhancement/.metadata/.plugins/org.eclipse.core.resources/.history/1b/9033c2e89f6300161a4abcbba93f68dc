/**
 * Author: 
 * Since: 
 * Name: HomeSearchCtrl
 * Description: Controller class to handle methods for Home Search page
**/
global with sharing class HomeSearchCtrl {
	private static List<String> filterObjFieldsList = new List<String>{	'Additional_Field_Json__c', 'Common__c', 'CommonFilterCategory__c', 'Custom__c',
																		'Display_Hidden_Column__c', 'Export_Field_Json__c', 'Export_File_Format__c',
																		'Export_GroupBy_Field__c', 'favorite__c', 'Field_Filter_Json__c', 'Field_Filter_JSON_Hash_Code__c',
																		'Filter_JSON__c', 'Filter_Label__c', 'Last_Modified_Date_Filter__c',
																		'Show_All_Records__c', 'Sort_Json__c', 'Summary_Field_Json__c', 'Filter_User__c'
																	};
	
	
	public Decimal Home_Search_Grid_Page_Size { get{return GeneralConfiguration.getHomeSearchGridPageSize();} private set;}
	/**
	 * Name: getFilterObjectTypes
	 * Description: Method to get the object labels which can be filtered on home search screen filter diaplog box
	 * @Param:	
	 * @Return:	String - JSON Sting
	 * 
	**/
	@RemoteAction
    global static String getFilterObjectTypes() {
    		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
			String filterQuery = 'SELECT Id';
			for(String fieldStr : filterObjFieldsList) {
				filterQuery += ', ' + fieldStr;
			}
			filterQuery += ' FROM Filter__c';
			filterQuery += ' WHERE Filter_User__c = \'' + UserInfo.getUserId() + '\'';
			filterQuery += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
			List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
			
    	 	HomeSearchMasterData hsMasterDataRec = new HomeSearchMasterData(CustomMetadataTypeUtil.getFilterObjectTypes(), 
    	 																	new HomeSearchFilterWrapper(),
    	 																	new HomeSearchAllFilter(listfilter),
    	 																	false								// Default false. Not used on page. Can be removed
    	 																);
			return BPUtility.getEncodedString(System.Json.serialize(hsMasterDataRec));
	}
	
	/**
	 * Name: updateUserReportMode
	 * Description: Method to update report mode check variable on user
	 * @Param:	
	 * @Return:	String - JSON Sting
	 * 
	**/
	@RemoteAction
    global static String updateUserReportMode(Boolean isPortModeOn) {
    		/*String filterQuery = 'SELECT Id';
			for(String fieldStr : filterObjFieldsList) {
				filterQuery += ', ' + fieldStr;
			}
			filterQuery += ' FROM Filter__c';
			filterQuery += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
			List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
			
			User currentUser = new User( Id = UserInfo.getUserId());
			currentUser.Is_Report_Mode_On__c = isPortModeOn;
    	 	update currentUser;
    	 	*/
			return BPUtility.getEncodedString('True');
	}
	
    /**
	 * Name: getGridFilterConfigurations
	 * Description: Method to get the home search grid filter settings based on Obejct name
	 * @Param:	1) String objectName - Obejct name selected in home search filter panel
	 * @Return:	String - Serialized string for grid filter settings respective to object name
	 * 
	**/
	@RemoteAction
    global static String getGridFilterConfigurations(String objectNamesStr) {
    	objectNamesStr = BPUtility.getDecodedString(objectNamesStr);
        
    	Set<String> objectNames = (Set<String>)System.JSON.deserialize(objectNamesStr, Set<String>.class);
    	if(objectNames == null || objectNames.size() == 0) {
    		objectNames = new Set<String>{Label.Generic_Object_Label};
    	}
		return BPUtility.getEncodedString(CustomMetadataTypeUtil.getGridFilterConfigurations(objectNames));
	}
	
	/**
	 * Name: getGridColumnsConfiguration
	 * Description: Method to get the home search grid columns configurations based on object name seldcted from UI
	 * @Param:	1) String objectName - Obejct name selected in home search filter panel
	 * @Return:	String - Serialized string for grid columns configurations respective to object name
	 * 
	**/
	@RemoteAction
    global static String getGridColumnsConfiguration(String objectNamesStr, String filterJSON) {
    	objectNamesStr = BPUtility.getDecodedString(objectNamesStr);
        filterJSON = BPUtility.getDecodedString(filterJSON);
        
    	Set<String> objectNames = (Set<String>)System.JSON.deserialize(objectNamesStr, Set<String>.class);
    	if(objectNames == null || objectNames.size() == 0) {
    		objectNames = new Set<String>{Label.Generic_Object_Label};
    	}
		return BPUtility.getEncodedString(CustomMetadataTypeUtil.getGridColumnsConfiguration(objectNames, filterJSON));
	}
	
	@RemoteAction
	@readOnly
    global static String getReportingRecords(String filterJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
        
    	HomeSearchFilterWrapper filterWrapperObj = (HomeSearchFilterWrapper) System.JSON.deserialize(filterJSON, HomeSearchFilterWrapper.class);
    	return BPUtility.getEncodedString(HomeSearchReportUtil.getReportingResult(filterWrapperObj));
    }
	
	
	/**
	 * Name: getFilteredRecords
	 * Description: Getting Records According to given filter parameter 
	 * @Param:	(1) filterJSON - String  - Filter JSON String 
	 *			(2) pageAndSortFiltersJSON - String - 
	 * @Return:	
	 * 
	**/ 
	@RemoteAction
	@readOnly
    global static String getFilteredRecords(String filterJSON, String pageAndSortFiltersJSON) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	pageAndSortFiltersJSON = BPUtility.getDecodedString(pageAndSortFiltersJSON);
    	
    	HomeSearchFilterWrapper filterWrapperObj = (HomeSearchFilterWrapper) System.JSON.deserialize(filterJSON, HomeSearchFilterWrapper.class);
		Map<String, List<HomeSearchFilterInterface.FieldFilter>> objectFiltersMap = HomeSearchFilterInterface.getFilterList(filterWrapperObj);
		//system.assert(false, objectFiltersMap + '\n\n' + filterWrapperObj.Type.Objects);
		System.debug('filterWrapperObj::: \n\n' + filterWrapperObj);
		System.debug('objectFiltersMap: \n\n' + objectFiltersMap);
		System.debug('####\n\n' + objectFiltersMap);
		
		Boolean isRecentSearch = true;
		Set<String> fixedResultObjects = new Set<String>{'Customers', 'Vendors'};
		for(String mapKey : objectFiltersMap.keySet()) {
			if(	( !fixedResultObjects.contains(mapKey) && objectFiltersMap.get(mapKey).size() != 0) 
				|| (fixedResultObjects.contains(mapKey) && objectFiltersMap.get(mapKey).size() > 1) 
			) {
				isRecentSearch = false;
			}
		}
		
		List<HomeSearchFilterInterface.FilterLabel> filterLabelList = HomeSearchFilterInterface.getFilterLabelList(filterWrapperObj);
		//system.assert(false, filterWrapperObj + '  ' + filterLabelList);
		PaginationSorting pageAndSortMapping = (PaginationSorting) System.JSON.deserialize(pageAndSortFiltersJSON, PaginationSorting.class);

		Integer totalRecordsFound;
		String JSONString = '[]';
		
		if(	(filterWrapperObj.SearchText == '' || filterWrapperObj.SearchText == null)
			&& isRecentSearch && filterWrapperObj.Type.Objects.contains(Label.Generic_Object_Label)
		) {
    		List<sObject> searchResults = HomeSearchRecentRecords.getOrgBlankSearchResults(pageAndSortMapping);
        	JSONString = HomeSearchResultWrapper.getJSONForSObjectRecords(searchResults, Label.Generic_Object_Label, HomeSearchRecentRecords.totalRecordsFound, filterLabelList);
    	} else {
    		if(objectFiltersMap.size() == 1 && objectFiltersMap.containsKey(Label.Generic_Object_Label)) {
    			for(String objName : HomeSearchUtil.searchableObjectToFieldsMap.keySet()) {
    				objectFiltersMap.put(objName, objectFiltersMap.get(Label.Generic_Object_Label));
    			}
    			objectFiltersMap.remove(Label.Generic_Object_Label);
    		}
    		
    		// Get records with SOQL approach for all selected objects
    		Map<String, List<sObject>> resultRecordsMap = HomeSearchReportUtil.getRportRecordsByHomeSearchFilters(	filterWrapperObj, 
    																												objectFiltersMap.keySet(), 
    																												null,
    																												pageAndSortMapping
    																											);
    		
    		// Loop over records so as to get last page size records so as paginate records
    		// we have already applied sorting on SOQL and limited records to current page size so as to minimize more efforts in pagination and sorting
    		Map<String, List<sObject>> paginatedRecordsMap = new Map<String, List<sObject>>();
    		/*
    		for(Integer i = ((pageAndSortMapping.CurrentPage - 1) * pageAndSortMapping.PageSize); i < (pageAndSortMapping.CurrentPage * pageAndSortMapping.PageSize); i++) {
    			for(String objAPIName : resultRecordsMap.keySet()) {
    				List<sObject> recordsList = resultRecordsMap.get(objAPIName);
    				List<sObject> paginatedRecordsList = (paginatedRecordsMap.containsKey(objAPIName)) ? paginatedRecordsMap.get(objAPIName) : new List<sObject>();
    				
    				if(i < recordsList.size()) {
    					paginatedRecordsList.add(recordsList[i]);
    					paginatedRecordsMap.put(objAPIName, paginatedRecordsList);
    				}
    				
    			}
    		}
    		*/
    		System.debug('### pageAndSortMapping: \n\n' + pageAndSortMapping);
    		System.debug('### resultRecordsMap: \n\n' + resultRecordsMap);
    		for(Integer i = 1; i <= pageAndSortMapping.PageSize; i++) {
    			for(String objAPIName : resultRecordsMap.keySet()) {
    				List<sObject> recordsList = resultRecordsMap.get(objAPIName);
    				List<sObject> paginatedRecordsList = (paginatedRecordsMap.containsKey(objAPIName)) ? paginatedRecordsMap.get(objAPIName) : new List<sObject>();
    				
    				if(recordsList.size() - i >= 0) {
    					if(paginatedRecordsList.size() > 0) {
    						paginatedRecordsList.add(0, recordsList[recordsList.size() - i]);
    					} else {
    						paginatedRecordsList.add(recordsList[recordsList.size() - i]);
    					}
    					paginatedRecordsMap.put(objAPIName, paginatedRecordsList);
    				}
    				
    			}
    		}
    		System.debug('### paginatedRecordsMap: \n\n' + paginatedRecordsMap);
    		
    		// sort records and get JSON result
    		List<String> objectsToSearch = new List<String>(paginatedRecordsMap.keySet());
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
			
			System.debug('### objectTypeSortDirection: \n\n' + objectTypeSortDirection);
			System.debug('### objectsToSearch: \n\n' + objectsToSearch);
			System.debug('### isAnyFilterPresent: \n\n' + isAnyFilterPresent);
			System.debug('### paginatedRecordsMap: \n\n' + paginatedRecordsMap);
			System.debug('### pageAndSortMapping: \n\n' + pageAndSortMapping);
			
        	List<sObject> resultRecords = HomeSearchSOSL.sortTheRecords(objectTypeSortDirection, objectsToSearch, isAnyFilterPresent, paginatedRecordsMap, pageAndSortMapping);
        	//System.debug('### resultRecords: \n\n' + resultRecords);
        	
        	// Serialize JSON based on object type
	        JSONString = HomeSearchResultWrapper.getJSONForSObjectRecords(resultRecords, 
	        															  HomeSearchUtil.getGenericObjectNameBySelectedObject(filterWrapperObj.Type.Objects),
	        															  -1,
	        															  filterLabelList
	        															);
    	}
		
		/*if(objectFiltersMap.size() != 0 && (filterWrapperObj.Type.Objects != null && filterWrapperObj.Type.Objects.size() != 0)) {
			JSONString = HomeSearchSOSL.searchRecords(objectFiltersMap, filterWrapperObj.Type.Objects, filterWrapperObj.SearchText);
		}*/
		//System.assert(false, JSONString);
        return BPUtility.getEncodedString(JSONString);
	}
	
	/**
	 * Name: saveFilterRecord
	 * Description: Save and Edit the record based On the value passed
	 * @Param:  (1) String filterId - FilterId passed from the Front panel
	 *          (2) String filterName - FilterName passed from the FrontPanel
	 *          (3) String fieldFilterJson - 
	 *			(4) String displayHiddenColumn - 
	 *			(5) String additionalFieldJson - 
	 * @Return: String
	**/
	@RemoteAction
	global static String saveFilterRecord(	String filterId, 
											String filterName, 
											String fieldFilterJson, 
											String sortJson, 
											String displayHiddenColumn, 
											String additionalFieldJson,
											String summaryFieldsJSON,
											String exportFieldsJSON,
											String exportFileFormat,
											String exportGroupFieldType,
											Boolean showAllrecords
										) {
		filterId = BPUtility.getDecodedString(filterId);
    	filterName = BPUtility.getDecodedString(filterName);
    	fieldFilterJson = BPUtility.getDecodedString(fieldFilterJson);
    	sortJson = BPUtility.getDecodedString(sortJson);
    	displayHiddenColumn = BPUtility.getDecodedString(displayHiddenColumn);
    	additionalFieldJson = BPUtility.getDecodedString(additionalFieldJson);
    	summaryFieldsJSON = BPUtility.getDecodedString(summaryFieldsJSON);
    	exportFieldsJSON = BPUtility.getDecodedString(exportFieldsJSON);
    	exportFileFormat = BPUtility.getDecodedString(exportFileFormat);
    	exportGroupFieldType = BPUtility.getDecodedString(exportGroupFieldType);
    	
		if(AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }									
		if(AccessControl.ifObjectFieldIsUpdateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		Filter__c filterRecordToSave = new Filter__c();
		if(filterId != null){
			filterRecordToSave.Id = filterId;
		} else {
			filterRecordToSave.Custom__c = true;
		}
		
		if(filterName != '') {
			filterRecordToSave.Filter_Label__c = (filterName == null) ? '' : filterName;
		}
		if(FieldFilterJson != '') {
			filterRecordToSave.Field_Filter_Json__c = (FieldFilterJson == null) ? '' : FieldFilterJson ;
		}
		if(sortJson != '') {
			filterRecordToSave.Sort_Json__c = (sortJson == null) ? '' : sortJson;
		}
		if(DisplayHiddenColumn != '') {
			filterRecordToSave.Display_Hidden_Column__c = (DisplayHiddenColumn == null) ? '' : DisplayHiddenColumn;
		}
		if(AdditionalFieldJson != '') {
			filterRecordToSave.Additional_Field_Json__c = (AdditionalFieldJson == null) ? '' : AdditionalFieldJson;
		}
		
		if(summaryFieldsJSON != null && summaryFieldsJSON != '' && summaryFieldsJSON.trim().length() != 2) {
			filterRecordToSave.Summary_Field_Json__c = (summaryFieldsJSON == null) ? '' : summaryFieldsJSON;
		}
		if(exportFieldsJSON != null && exportFieldsJSON != '' && exportFieldsJSON.trim().length() != 2) {
			filterRecordToSave.Export_Field_Json__c = (exportFieldsJSON == null) ? '' : exportFieldsJSON;
		}
		if(exportFileFormat != '') {
			filterRecordToSave.Export_File_Format__c = (exportFileFormat == null) ? '' : exportFileFormat;
		}
		if(exportGroupFieldType != '') {
			filterRecordToSave.Export_GroupBy_Field__c = (exportGroupFieldType == null) ? '' : exportGroupFieldType;
		}
		
		filterRecordToSave.Show_All_Records__c = showAllrecords;
		
		filterRecordToSave.Filter_User__c = UserInfo.getUserId();
		
		upsert filterRecordToSave;
		
		return 	getSavedFilterList(filterRecordToSave.Id);		
	}
	
	/**
	 * Name: previewExportRecords
	 * Description: Save and Edit the record based On the value passed
	 * @Param:  (1) String filterId - FilterId passed from the Front panel
	 *          (2) String filterName - FilterName passed from the FrontPanel
	 *          (3) String fieldFilterJson - 
	 *			(4) String displayHiddenColumn - 
	 *			(5) String additionalFieldJson - 
	 * @Return: String
	**/
	@RemoteAction
	global static String previewExportRecords(	String fieldFilterJson, 
												String sortJson, 
												String displayHiddenColumn, 
												String summaryFieldJSON,
												String exportFileFormat,
												String exportGroupFieldType
											) {
		fieldFilterJson = BPUtility.getDecodedString(fieldFilterJson);
    	sortJson = BPUtility.getDecodedString(sortJson);
    	displayHiddenColumn = BPUtility.getDecodedString(displayHiddenColumn);
    	summaryFieldJSON = BPUtility.getDecodedString(summaryFieldJSON);
    	exportFileFormat = BPUtility.getDecodedString(exportFileFormat);
    	exportGroupFieldType = BPUtility.getDecodedString(exportGroupFieldType);
    	
		
		if(AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		
		Filter__c filterRecordToSave = new Filter__c();
		filterRecordToSave.Filter_Label__c = 'Preview Report';
		filterRecordToSave.Field_Filter_Json__c = (FieldFilterJson == null) ? '' : FieldFilterJson ;
		filterRecordToSave.Sort_Json__c = (sortJson == null) ? '' : sortJson;
		filterRecordToSave.Display_Hidden_Column__c = (DisplayHiddenColumn == null) ? '' : DisplayHiddenColumn;
		filterRecordToSave.Summary_Field_Json__c = (summaryFieldJSON == null) ? '' : summaryFieldJSON;
		filterRecordToSave.Export_File_Format__c = (exportFileFormat == null) ? '' : exportFileFormat;
		filterRecordToSave.Export_GroupBy_Field__c = (exportGroupFieldType == null) ? '' : exportGroupFieldType;
		filterRecordToSave.Filter_User__c = UserInfo.getUserId();
		insert filterRecordToSave;
		return 	BPUtility.getEncodedString(filterRecordToSave.Id);		
	}
	
	
	/**
	 * Name: checkForSimilarFilter
	 * Description: Getting Similar Filter
	 * @Param:  (1) String fieldFilterJson - 
	 * @Return: String Filter Name
	**/
	@RemoteAction
	global static String checkForSimilarFilter(String fieldFilterJson) {
		fieldFilterJson = BPUtility.getDecodedString(fieldFilterJson);
    	
		Decimal fieldJSONHashCode = (fieldFilterJson != null) ? fieldFilterJson.hashCode() : 0;
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Filter__c> filterList = [select Id, 
											 Filter_Label__c 
											 from Filter__c 
											 where Field_Filter_JSON_Hash_Code__c = :fieldJSONHashCode
											 And Filter_User__c =: UserInfo.getUserId()
									];
		
		String filterName;
		if(filterList.size() > 0) {
			filterName = filterList[0].Filter_Label__c;
		} 
		return BPUtility.getEncodedString(filterName);
	}
	
	 /**
	 * Name: getFilterFields
	 * Description:Function get filter item by Id
	 * @Param:  (1) String filterId - FilterId passed from the Front panel
	 * @Return: String  JSON String
	 **/
	@RemoteAction
	global static String getFilterFields(String filterId){
		filterId = BPUtility.getDecodedString(filterId);
    	filterId = BPUtility.escapeSingleQuotes(filterId);
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String filterQuery = 'SELECT Id';
		for(String fieldStr : filterObjFieldsList) {
			filterQuery += ', ' + fieldStr;
		}
		filterQuery += ' FROM Filter__c';
		filterQuery += ' WHERE Id =: filterId';
		filterQuery += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
		List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
		
		Filter__c FilterJsonReturn = listfilter[0];		
	 	GenericFilterWrapper GenericfilterWrapperObj =new GenericFilterWrapper( FilterJsonReturn);
		return BPUtility.getEncodedString(System.Json.serialize(GenericfilterWrapperObj));   
	}
	
	 /**
	 * Name: GenericFilterWrapper
 	 * Description:  Generic Filter WrapperClass return Json Of  Filter Clicked
	 **/
	public class GenericFilterWrapper{
		public String FilterLabel;
		public String FieldFilterJson;
		public Decimal FieldFilterJsonHashCode;
		public String SortJson;
		public String DisplayHiddenColumn;
		public String AdditionalFieldJson;
		public Boolean Favorite;
		public Boolean Custom;
		public Boolean Common;
		
		public String SummaryFieldsJSON;
		public String ExportFieldsJSON;
		public String ExportFileFormat;
		public String ExportGroupField;
		public Boolean IsReportOn;
		
		public List<String> ObjectList;
		
		 /**
		 * Name: GenericFilterWrapper
		 * Description: Constructor
		 * @Param: 1) Filter__c filterRec - Filter Record
		 * @Return: 
		 **/
		public GenericFilterWrapper(Filter__c filterRec) {
			this.FilterLabel =  filterRec.Filter_Label__c;
			this.FieldFilterJson = filterRec.Field_Filter_Json__c;
			this.FieldFilterJsonHashCode = filterRec.Field_Filter_JSON_Hash_Code__c;
			this.SortJson=  filterRec.Sort_Json__c;
			this.DisplayHiddenColumn = filterRec.Display_Hidden_Column__c;
			this.AdditionalFieldJson =  filterRec.Additional_Field_Json__c;
			this.Favorite = filterRec.favorite__c;
			this.Custom = filterRec.Custom__c;
			this.Common = filterRec.Common__c;
			
			this.SummaryFieldsJSON =  filterRec.Summary_Field_Json__c;
			this.ExportFieldsJSON =  filterRec.Export_Field_Json__c;
			this.ExportFileFormat =  filterRec.Export_File_Format__c;
			this.ExportGroupField =  filterRec.Export_GroupBy_Field__c;
			this.IsReportOn =  filterRec.Show_All_Records__c;
		}
	} 
	
	
	
	/**
	 * Name: deleteFilterRecord
	 * Description: Delete the record based on the Id passed
	 * @Param: 		(1) String filterId - filterId Passed to delete The Record from the Front Panel
	 * @Return: String  - Filter List String 
	**/
	@RemoteAction
	global static String deleteFilterRecord(String filterId) {
		filterId = BPUtility.getDecodedString(filterId);
    	
		if(filterId != null){
			if(AccessControl.ifObjectIsDeletable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
			Filter__c filterRecordToDelete = new Filter__c(Id = filterId);
			delete filterRecordToDelete;
		}
		return BPUtility.getEncodedString(getAllfilterList());
	}
	/**
	 * Name: renameCopyFilterRecord
	 * Description: Rename the copy filter record based On the Id passed
	 * @Param: 	(1) String filterId - filterId Passed to delete The Record from the Front Panel
	 *         	(2) String filterName - filterName passed from front panel
	 *			(3) Boolean Iscopy - Copied Or Not
	 * @Return:  String  - Filter List String 
	**/

	@RemoteAction
	global static String renameCopyFilterRecord(String filterId, String filterName, Boolean Iscopy) {
		filterId = BPUtility.getDecodedString(filterId);
    	filterName = BPUtility.getDecodedString(filterName);
    	filterId = BPUtility.escapeSingleQuotes(filterId);
		if(AccessControl.ifObjectFieldIsCreateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }									
		if(AccessControl.ifObjectFieldIsUpdateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(filterId != null){
			Filter__c filterRecordToRename ;
			if(!Iscopy) {
				filterRecordToRename = new Filter__c(Id = filterId, Filter_Label__c = filterName );	
			} else {
				if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
				String filterQuery = 'SELECT Id';
				for(String fieldStr : filterObjFieldsList) {
					filterQuery += ', ' + fieldStr;
				}
				filterQuery += ' FROM Filter__c';
				filterQuery += ' WHERE Id =: filterId';
				List<Filter__c> filterList = (List<Filter__c>)Database.query(filterQuery);
				
				if(filterList.size() > 0) {
					filterRecordToRename = filterList[0].clone(false, false, false, false);	
					filterRecordToRename.Filter_Label__c = filterName;
					filterRecordToRename.Custom__c = true;
					filterRecordToRename.Common__c = false;
					filterRecordToRename.Favorite__c = false;
				}
			}
			upsert filterRecordToRename;
		}
		return BPUtility.getEncodedString(getAllfilterList());
	}
	
	/**
	 * Name: markFilterAsFavorite
	 * Description: Mark the record  as favourite based on the Id passed
	 * @Param: 	(1) String filterId - filterId Passed to delete The Record from the Front Panel
	 *			(2) Boolean Favorite - Favorite Or Not
	 * @Return: 
	**/
	@RemoteAction
	global static String markFilterAsFavorite(String filterId , Boolean Favorite) {
		filterId = BPUtility.getDecodedString(filterId);
    	
		if(filterId != null){
			if(AccessControl.ifObjectFieldIsUpdateable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
			Filter__c filterRecordToChange = new filter__c(Id = filterId, favorite__c= Favorite );
			update filterRecordToChange;
		}
		return BPUtility.getEncodedString(getAllfilterList());
	}
	
	
	/**
	 * Name: getAllfilterList
	 * Description: Function get records for the filter list
	 * @Param: 
	 * @Return: String - Filter List String 
	**/
	public static String getAllfilterList( ){
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		String filterQuery = 'SELECT Id';
		for(String fieldStr : filterObjFieldsList) {
			filterQuery += ', ' + fieldStr;
		}
		filterQuery += ' FROM Filter__c';
		filterQuery += ' WHERE Filter_User__c = \'' + UserInfo.getUserId() + '\'';
		filterQuery += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
		List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
		
		HomeSearchAllFilter hsMasterDataRec = new HomeSearchAllFilter(listfilter);
	   	return System.Json.serialize(hsMasterDataRec);                     
	}
	
	
	/**
	 * Name: getSavedFilterList
	 * Description: function return fiter after saving records
	 * @Param: (1) filterId - String - filterId Passed to delete The Record from the Front Panel
	 * @Return: String - Filter JSON String 
	**/
	public static String getSavedFilterList( String  filterId){
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		filterId = BPUtility.escapeSingleQuotes(filterId);
		String filterQuery = 'SELECT Id';
		for(String fieldStr : filterObjFieldsList) {
			filterQuery += ', ' + fieldStr;
		}
		filterQuery += ' FROM Filter__c';
		filterQuery += ' WHERE Filter_User__c = \'' + UserInfo.getUserId() + '\'';
		filterQuery += ' LIMIT ' + SOQLUtil.getAvailableQueryRowsLimit();
		List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
		
		if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		filterQuery = 'SELECT Id';
		for(String fieldStr : filterObjFieldsList) {
			filterQuery += ', ' + fieldStr;
		}
		filterQuery += ' FROM Filter__c';
		filterQuery += ' WHERE Id=: filterId';
		List<Filter__c> listCurrentFilter = (List<Filter__c>)Database.query(filterQuery);
      
      	Filter__c Currentfilter = listCurrentFilter[0];
                           
       	HomeSearchAllFilter hsMasterDataRec = new HomeSearchAllFilter(listfilter);
       	FilterItem currentFilterRec =new FilterItem(Currentfilter);
       	
       	FilterItemWrapper SavedFilterJson = new FilterItemWrapper(currentFilterRec,hsMasterDataRec);
	  	return BPUtility.getEncodedString(System.Json.serialize(SavedFilterJson));                     
                            
	}
	
	/**
	 * Name: getReportData
	 * Description: Getting report result data for grid filters applied
	 * @Param:	(1) filterJSON - String  - Filter JSON String 
	 * @Return:	String
	 * 
	**/
	@RemoteAction
    global static String getReportData(String filterJSON, String selectedObjName, String uniqueValueFieldLastValue) {
    	filterJSON = BPUtility.getDecodedString(filterJSON);
    	selectedObjName = BPUtility.getDecodedString(selectedObjName);
    	uniqueValueFieldLastValue = BPUtility.getDecodedString(uniqueValueFieldLastValue);
    	
    	HomeSearchFilterWrapper filterWrapperObj = (HomeSearchFilterWrapper) System.JSON.deserialize(filterJSON, HomeSearchFilterWrapper.class);
    	return BPUtility.getEncodedString(HomeSearchReportUtil.getRportingDataByHomeSearchFilters(filterWrapperObj, selectedObjName, uniqueValueFieldLastValue));
	}
	
	 /**
	 * Name: FilterItem
	 * Description: Current filter record Wrapper Class
	 **/
	public class FilterItem{
		public String Id;
		public String Name;
		public String Type;
		
		public String GridDisplayHiddenColumnsJSON;
		public String SummaryDisplayHiddenColumnsJSON;
		public String ExportDisplayHiddenColumnsJSON;
		
		/**
		 * Name: FilterItem
		 * Description: Constructor
		 * @Param: (1) currentfilter - Filter__c - Filter Record
		 * @Return:  
		**/
		public FilterItem( Filter__c currentfilter) {
			this.Id = currentfilter.Id;
			this.Name = currentfilter.Filter_Label__c;
			this.GridDisplayHiddenColumnsJSON = currentfilter.Display_Hidden_Column__c;
			this.SummaryDisplayHiddenColumnsJSON = currentfilter.Summary_Field_Json__c;
			this.ExportDisplayHiddenColumnsJSON = currentfilter.Export_Field_Json__c;
			
			if(currentfilter.favorite__c) {
				this.Type = 'favorite';
			} else if(currentfilter.Common__c) {
				this.Type = 'Common';
			} else if(currentfilter.Custom__c){
				this.Type = 'Custom';
			}
		}
	}
	
	/**
	 * Name: FilterItemWrapper
	 * Description:  Wrapper Class to get current filter and list of all filter
	**/
	public class FilterItemWrapper {
		public FilterItem CurrentFilter;
		public HomeSearchAllFilter AllFilterJSON;
		
		public FilterItemWrapper(FilterItem currentFilter,HomeSearchAllFilter allFilterJSON ) {
			this.CurrentFilter =currentFilter;
			this.AllFilterJSON =allFilterJSON;
		}
		
	}
	
	/**
	 * Name: HomeSearchMasterData
	 * Description:  Wrapper Class Home Search Master Data
	**/
	public class HomeSearchMasterData {
		  
		public List<String> ObjectList;
		public HomeSearchFilterWrapper FilterFormJSON;
		public HomeSearchAllFilter AllFilterJSON;
		public Boolean IsReportOn;
		
		/**
		 * Name: HomeSearchMasterData
		 * Description: Constructor
		 * @Param: 	(1) objects - List<String> - object list string
		 *			(2) hsFilterWrapperRec - HomeSearchFilterWrapper - HomeSearchFilterWrapper Record
		 *			(3) allfilterJsonObj - HomeSearchAllFilter - HomeSearchAllFilter Record
		 * @Return:  
		**/
		public HomeSearchMasterData(List<String> objects, HomeSearchFilterWrapper hsFilterWrapperRec, HomeSearchAllFilter allfilterJsonObj, Boolean IsReportOn) {
			this.ObjectList = new List<String>();
			this.ObjectList.addAll(objects);
			this.AllFilterJSON = allfilterJsonObj;
			this.FilterFormJSON = hsFilterWrapperRec;
			this.IsReportOn = IsReportOn;
		}
	}
}