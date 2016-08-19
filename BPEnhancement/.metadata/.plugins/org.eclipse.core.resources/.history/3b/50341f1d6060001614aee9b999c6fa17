/**
 * Author: Ashish Garg
 * Since: March 13, 2015
 * Name: SearchSuggestionUtil
 * Description: Utility class to hold methods related to search methods
**/
public with sharing class SearchSuggestionUtil {
    // Text to be searched
    public static String textToSearch {get; private set;}
    
    public static String getSearchSuggestionJSON(SearchSuggestionJSON.QueryJSON searchQueryJSON){
        textToSearch = String.escapeSingleQuotes(searchQueryJSON.SearchText.toLowerCase());

        List<sObject> searchObjRecords = new List<sObject>();
        if(searchQueryJSON.SearchText != null && searchQueryJSON.SearchText.length() != 0){
            searchObjRecords = getRecordsWithOrgSearch(searchQueryJSON.ObjectLabel, searchQueryJSON.SearchText, searchQueryJSON.SearchableObjects, searchQueryJSON.FilterValues);
        }
        //system.assert(false, searchObjRecords);
        
        // Grouped result as per objects
        // Create a list of SuggestedRecordEntity with each object and process sorting
        map<String, List<SuggestedRecordEntity>> groupedSortedRecords = getGroupedSortedRecords(searchQueryJSON.ObjectLabel, searchObjRecords);
        
        // Create JSON for the result with suggested object records first
        String searchJSONString = createSuggestedItemsJSON(groupedSortedRecords, searchQueryJSON.PreferredObject, searchQueryJSON.ObjectLabel, searchQueryJSON.SearchableObjects);

        //system.assert(false, searchJSONString);
        return searchJSONString;
    }
    
    /** 
     * Name: getRecordsWithOrgSearch
     * Desc: Method to Get filter record by filter record Id
     * @param: 
     * @return: List<Sobject> - List of filter object's record 
    **/
    private static List<Sobject> getRecordsWithOrgSearch(String objectLabel, String searchText, String SearchableObjects, List<SearchSuggestionJSON.FilterJSON> FilterValues) {
        String soslQuery = '';
        
        // Object name to which search in
        String objectName = (objectLabel != null && objectLabel.trim().length() != 0) ? String.escapeSingleQuotes(Constants.objectDisplayLabelToObjectName.get(objectLabel)) : null;
        searchText = (searchText != null) ? searchText : '';
        searchText = SOSLUtil.formatTextValueToBeSearched(searchText);
        
        // Searchable ordered list
        List<String> objectsOrderedList = new List<String>();
        if(SearchableObjects != null && SearchableObjects.trim().length() != 0){
            for(String objName : SearchableObjects.split(',')) {
                objName = objName.contains('__c') ? Constants.NAMESPACE + objName : objName;
                objectsOrderedList.add(objName);
            }
        } else {
            objectsOrderedList = Constants.objectsOrderedList;
        }
        
        String customerSearchText = '';
        String vendorSearchText = '';
        
        // Set searchable fields here
        soslQuery += ' IN ALL FIELDS RETURNING ';
        
        String additionalAccountFields = ',Is_Customer__c,Is_Vendor__c';
        String customerVendorQueryString = '';
        
        List<String> searchableObjNameList = new List<String>();
        for(String objName : objectsOrderedList) {
            String whereCondition = '';
            if(objectName != null && objectName != objName){
                continue;
            } else if(objectName != null) {
                if(FilterValues != null){
                    for(SearchSuggestionJSON.FilterJSON FilterJSON : FilterValues){
                        if(objectName ==  FilterJSON.FilterObject ) {
                            if(whereCondition != ''){
                                whereCondition += ' OR ';
                            } else {
                                whereCondition = ' WHERE ';
                            }
                            whereCondition += FilterJSON.Field + '=\'' + FilterJSON.Value + '\'';
                        }   
                    }
                }
                if(objectName == 'User') {
                    if(whereCondition != ''){
                        whereCondition += ' AND ';
                    } else {
                        whereCondition = ' WHERE ';
                    }
                    whereCondition += 'IsActive = true';
                }
            }
            else if(objName != null) {
                if(FilterValues != null){
                    for(SearchSuggestionJSON.FilterJSON FilterJSON : FilterValues){
                        if(objName ==  FilterJSON.FilterObject )    {
                            if(whereCondition != ''){
                                whereCondition += ' OR ';
                            } else {
                                whereCondition = ' WHERE ';
                            }
                            whereCondition += FilterJSON.Field + '=\'' + FilterJSON.Value + '\'';
                        }   
                    }
                }
                if(objectName == 'User') {
                    if(whereCondition != ''){
                        whereCondition += ' AND ';
                    } else {
                        whereCondition = ' WHERE ';
                    }
                    
                    whereCondition += 'IsActive = true';
                }
            }
            
            // Search fields depending on deisplay field and display additional info maps defined in constant class based on use custom setting
            String searchFields = '';
            //system.assert(false, Constants.objectToSearchableFieldsMap);
            for(String searchField : Constants.objectToSearchableFieldsMap.get(objName)){
                searchField = String.escapeSingleQuotes(searchField);
                if(searchField.contains('__c'))
                    searchFields += CONSTANTS.NAMESPACE + searchField + ',';
                else
                    searchFields += searchField + ',';
            }
            searchFields= searchFields.replaceAll( '\\s+', '');
            searchFields = searchFields.substring(0, searchFields.length() - 1);

            // Set object returning fields here
            if( !objName.equalsIgnoreCase(Constants.customerObjectLabel) && !objName.equalsIgnoreCase(Constants.vendorObjectLabel) ){
                soslQuery += objName + ' (LastModifiedDate,' + searchFields + whereCondition;
                soslQuery += ' ORDER BY LastModifiedDate DESC';
                soslQuery += '),';
            } else if(objName.equalsIgnoreCase(Constants.customerObjectLabel)){
                customerSearchText = 'IsCustomer';
                if(customerVendorQueryString != ''){
                    //customerVendorQueryString += ' OR Is_Customer__c=true';
                } else if(customerVendorQueryString == ''){
                    customerVendorQueryString = 'Account (LastModifiedDate,Is_Customer__c,Is_Vendor__c,' + searchFields + whereCondition;
                }
            } else if(objName.equalsIgnoreCase(Constants.vendorObjectLabel)){
                vendorSearchText = 'IsVendor';
                if(customerVendorQueryString != ''){
                    //customerVendorQueryString += ' OR Is_Vendor__c=true';
                } else if(customerVendorQueryString == ''){
                    customerVendorQueryString = 'Account (LastModifiedDate,Is_Customer__c,Is_Vendor__c,' + searchFields + whereCondition;
                }
            }
        }
        
        String soslQueryFind = 'Find \'*' + searchText + '*\'' ;
        if(customerVendorQueryString.length() == 0){
            soslQuery = soslQueryFind + soslQuery.substring(0, soslQuery.length() - 1);
        } else {
            customerVendorQueryString += ' ORDER BY LastModifiedDate DESC)';
            soslQueryFind = 'Find \'*';
            
            if(objectLabel == null || objectLabel == ''){
                soslQueryFind += searchText + '* OR (';
            }
            soslQueryFind += searchText + '*'
                                        + (( customerSearchText != '' || vendorSearchText != '' )
                                            ? (' AND (' 
                                                + ((customerSearchText != '') ? customerSearchText : '')
                                                + ((vendorSearchText != '') ? ((customerSearchText != '') ? (' OR ' + vendorSearchText) : ('' + vendorSearchText)) : '')
                                                + ')'
                                            )
                                            : ''
                                          );
            if(objectLabel == null || objectLabel == ''){
                soslQueryFind += ')';
            }
            soslQueryFind += '\'';
            soslQuery = soslQueryFind + soslQuery + ' ' + customerVendorQueryString;
        }
        //system.assert(false, searchableObjNameList);
        for(String objName : searchableObjNameList) {
            if(objName == 'Customer' || objName == 'Vendor') {
                objName = 'Account';
            }
            if(AccessControl.ifObjectFieldIsAccessible(objName) == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        }
        
        //system.assert(false, soslQuery);
        List<List<Sobject>> sobjectList = Search.query(soslQuery);
        //system.assert(false, soslQuery + '\n\n\n\n' + sobjectList);
        
        List<sObject> searchObjRecords = new List<sObject>();
        for(List<sObject> sObjList : sobjectList){
            searchObjRecords.addAll(sObjList);
        }
        
        //System.assert(false, soslQuery + '\n' + searchObjRecords);
        return searchObjRecords;
    }
        
    private static map<String, List<SuggestedRecordEntity>> getGroupedSortedRecords(String objLabel, List<sObject> searchObjRecords){
        //system.assert(false, objLabel);
        map<String, List<SuggestedRecordEntity>> groupedRecords = new map<String, List<SuggestedRecordEntity>>();
        
        if(searchObjRecords != null && searchObjRecords.size() != 0){
            // Group the records with each object
            for(sObject sObj : searchObjRecords){
                String objName = String.valueOf(sObj.getSObjecttype());
                
                // Check for Customer/vendor object
                if( objName == 'Account' ){
                    if((objLabel == '' || objLabel == 'customer') && Boolean.valueOf(sObj.get('Is_Customer__c')) ){
                        objName = Constants.customerObjectLabel;
                        List<SuggestedRecordEntity> objRecords = (groupedRecords.containsKey(objName)) ? groupedRecords.get(objName) : new List<SuggestedRecordEntity>();
                        objRecords.add(new SuggestedRecordEntity(sObj));
                        groupedRecords.put(objName, objRecords);
                    }
                    if( (objLabel == '' || objLabel == 'vendor') &&  Boolean.valueOf(sObj.get('Is_Vendor__c')) ){
                        objName = Constants.vendorObjectLabel;
                        List<SuggestedRecordEntity> objRecords = (groupedRecords.containsKey(objName)) ? groupedRecords.get(objName) : new List<SuggestedRecordEntity>();
                        objRecords.add(new SuggestedRecordEntity(sObj));
                        groupedRecords.put(objName, objRecords);
                    }
                    if( objLabel == '' && !Boolean.valueOf(sObj.get('Is_Vendor__c')) && !Boolean.valueOf(sObj.get('Is_Customer__c')) ){
                        List<SuggestedRecordEntity> objRecords = (groupedRecords.containsKey(objName)) ? groupedRecords.get(objName) : new List<SuggestedRecordEntity>();
                        objRecords.add(new SuggestedRecordEntity(sObj));
                        groupedRecords.put(objName, objRecords);
                    }
                } else {
                    List<SuggestedRecordEntity> objRecords = (groupedRecords.containsKey(objName)) ? groupedRecords.get(objName) : new List<SuggestedRecordEntity>();
                    objRecords.add(new SuggestedRecordEntity(sObj));
                    groupedRecords.put(objName, objRecords);
                }
            }
            
            // Sort each object related records
            for(String objName : groupedRecords.keySet()){
                List<SuggestedRecordEntity> objRecords = groupedRecords.get(objName);
                objRecords.sort();
            }
        }
        
        return groupedRecords;
    }
    
    private static String createSuggestedItemsJSON(map<String, List<SuggestedRecordEntity>> groupedSortedRecords, String preferredObject, String objLabel, String SearchableObjects){
        List<SearchSuggestionJSON.ResultJSON> resultSuggestionRecords = new List<SearchSuggestionJSON.ResultJSON>();
        
        // Add default suggested objects in the result JSON
        if(objLabel == null || objLabel == ''){
            resultSuggestionRecords.addAll(addDefaultSugegstedObjects(textToSearch, SearchableObjects));
        }
        if(groupedSortedRecords != null && groupedSortedRecords.size() != 0){
            // Prepare a list of object names so aj to sort the object records grouping (Preferred object name will be at first position)
            List<String> sortedObjectNameList = new List<String>();
            if(SearchableObjects != null && SearchableObjects.trim().length() != 0){
                for(String objName : SearchableObjects.split(',')) {
                    objName = objName.contains('__c') ? Constants.NAMESPACE + objName : objName;
                    sortedObjectNameList.add(objName);
                }
            } else {
                sortedObjectNameList = Constants.objectsOrderedList;
            }

            if(preferredObject != null && preferredObject.trim().length() != 0){
                sortedObjectNameList.add(0, preferredObject);
            }
            
            if(groupedSortedRecords.containsKey('Account')){
                sortedObjectNameList.add(0, 'Account');
            }
            
            // Make Set of SearchableObjects List - Adding NameSpace.
            Set<String> searchableObjectsSet = new Set<String>();
            if(SearchableObjects != null) {
                for(String searchableObjectStr : SearchableObjects.split(',')) {
                    searchableObjectsSet.add(searchableObjectStr.contains('__c') ? CONSTANTS.NAMESPACE + searchableObjectStr : searchableObjectStr);
                }
            }
            
            // Add sorted result in SearchSuggestionJSON.ResultJSON list so to format for JSON
            for(String objName : sortedObjectNameList){
                if(groupedSortedRecords.containsKey(objName) && (SearchableObjects == null || searchableObjectsSet.contains(objName))){
                    String displayFieldName = Constants.objectToDisplayFieldsMap.get(objName);
                    displayFieldName = displayFieldName.contains('__c') ? CONSTANTS.NAMESPACE + displayFieldName : displayFieldName;
                    
                    if(objName != CONSTANTS.NAMESPACE + 'Part__c') {
                        for(SuggestedRecordEntity sObjItem : groupedSortedRecords.get(objName)){
                            resultSuggestionRecords.add( new SearchSuggestionJSON.ResultJSON( sObjItem.record,
                                                                                              String.valueOf(sObjItem.record.get(displayFieldName)), 
                                                                                              String.valueOf(sObjItem.record.get('Id')),
                                                                                              Constants.objectToAdditionalInfoDisplayMap.get(objName),
                                                                                              objName,
                                                                                              '', '', '' 
                                                                                            ));
                        }
                    } else {
                        for(SuggestedRecordEntity sObjItem : groupedSortedRecords.get(objName)){
                            //system.assert(false, objName);
                            resultSuggestionRecords.add( new SearchSuggestionJSON.ResultJSON( sObjItem.record,
                                                                                              String.valueOf(sObjItem.record.get(displayFieldName)), 
                                                                                              String.valueOf(sObjItem.record.get('Id')),
                                                                                              Constants.objectToAdditionalInfoDisplayMap.get(objName),
                                                                                              objName,
                                                                                              String.valueOf(sObjItem.record.get(CONSTANTS.NAMESPACE+'Qty_In_Stock__c')),
                                                                                              String.valueOf(sObjItem.record.get(CONSTANTS.NAMESPACE+'Qty_Committed__c')),
                                                                                              String.valueOf(sObjItem.record.get(CONSTANTS.NAMESPACE+'Retail_Price__c'))
                                                                                            ));
                        }
                    }
                    
                    groupedSortedRecords.remove(objName);
                    if(groupedSortedRecords.size() == 0){
                        break;
                    }
                }
            }
        }
        //system.assert(false, System.JSON.serialize(resultSuggestionRecords));
        return System.JSON.serialize(resultSuggestionRecords);
    }
    
    // Add default suggested objects in the result JSON
    private static List<SearchSuggestionJSON.ResultJSON> addDefaultSugegstedObjects(String searchText, String SearchableObjects){
        List<SearchSuggestionJSON.ResultJSON> resultSuggestionRecords = new List<SearchSuggestionJSON.ResultJSON>();
        
        // Map for object/section name to its related type (Object/Section) in Customer Order page
        // Map is used in search suggestions list for all page realted objects and sections to display
        Map<String,String> coPageObjSectionsMap = new Map<String, String>{ 
                                                                            Label.Customer_Object_Display_Label => 'Object',
                                                                            Label.User_Object_Display_Label => 'Object',
                                                                            Label.Part_Object_Display_Label => 'Object',
                                                                            Label.Category_Object_Display_Label => 'Object',
                                                                            Label.Vendor_Object_Display_Label => 'Object',
                                                                            Label.Kit_Object_Display_Label => 'Object',
                                                                            Label.Fee_Object_Display_Label => 'Object',
                                                                            Label.Payment_Section_Display_Label => 'section',
                                                                            Label.Suggested_Items_Section_Display_Label => 'section' 
                                                                        };
        if(SearchableObjects.indexOf('Part__c') > -1) {
            SearchableObjects += ',' + Label.Part_Object_Display_Label;
        }
        //system.assert(false, SearchableObjects);
        for( String nameKey : coPageObjSectionsMap.keySet()){
            if( (searchText.length() == 0 || nameKey.toLowerCase().indexOf(searchText.toLowerCase()) > -1) &&
                        SearchableObjects.toLowerCase().indexOf(searchText.toLowerCase()) > -1){
                String value = (Constants.objectDisplayLabelToObjectName.containsKey(nameKey)) ? Constants.objectDisplayLabelToObjectName.get(nameKey) : nameKey;
                String info = coPageObjSectionsMap.get(nameKey);
                nameKey = (coPageObjSectionsMap.get(nameKey) == 'Object') ? (nameKey + ':') : nameKey;
                resultSuggestionRecords.add( new SearchSuggestionJSON.ResultJSON( null, nameKey, value, null, info, '','','') );
            }
        }
        //system.assert(false, resultSuggestionRecords);
        return resultSuggestionRecords;
    }
}