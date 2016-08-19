/**
 * Name: PreviewGridRecordsCtrl
 * Description: 
 * 
**/
public with sharing class PreviewGridRecordsCtrl {
    /**
     * Name: getFilterJSONData
     * Description:Function get filter item by Id
     * @Param:  (1) String filterId - FilterId passed from the Front panel
     * @Return: String  JSON String
     **/
    @RemoteAction
    public static String getFilterJSONData(String filterIdStr){
        filterIdStr = BPUtility.getDecodedString(filterIdStr);
        if(AccessControl.ifObjectFieldIsAccessible('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        Id filterId;
        try{
            filterId = filterIdStr;
        } catch(Exception e) {
            filterIdStr = ApexPages.currentPage().getParameters().get('filterId');
            filterIdStr = BPUtility.escapeSingleQuotes(filterIdStr);
        }
        
        if(filterIdStr != null) {
            List<String> filterObjFieldsList = new List<String>{'Additional_Field_Json__c', 'Common__c', 'CommonFilterCategory__c', 'Custom__c',
                                                                'Display_Hidden_Column__c', 'Export_Field_Json__c', 'Export_File_Format__c',
                                                                'Export_GroupBy_Field__c', 'favorite__c', 'Field_Filter_Json__c', 'Field_Filter_JSON_Hash_Code__c',
                                                                'Filter_JSON__c', 'Filter_Label__c', 'Last_Modified_Date_Filter__c',
                                                                'Show_All_Records__c', 'Sort_Json__c', 'Summary_Field_Json__c'
                                                            };
            String filterQuery = 'SELECT Id';
            for(String fieldStr : filterObjFieldsList) {
                filterQuery += ', ' + fieldStr;
            }
            filterQuery += ' FROM Filter__c';
            filterQuery += ' WHERE Id =: filterIdStr';
            List<Filter__c> listfilter = (List<Filter__c>)Database.query(filterQuery);
            
            HomeSearchCtrl.GenericFilterWrapper GenericfilterWrapperObj;
            if(listfilter.size() > 0) {
                Filter__c FilterJsonReturn = listfilter[0];     
                GenericfilterWrapperObj = new HomeSearchCtrl.GenericFilterWrapper(FilterJsonReturn);
                GenericfilterWrapperObj.ObjectList = CustomMetadataTypeUtil.getFilterObjectTypes();
                
                // Delete the filter record
                PreviewGridRecordsCtrl.deleteRawFiltersData(new List<Id>{filterId});
            }
            
            return BPUtility.getEncodedString(System.Json.serialize(GenericfilterWrapperObj));
        }
        return BPUtility.getEncodedString('{}');
    }
    
    /**
     * Name: getReportData
     * Description: Getting report result data for grid filters applied
     * @Param:  (1) filterJSON - String  - Filter JSON String 
     * @Return: String
     * 
    **/
    @RemoteAction
    public static String getReportData(String filterJSON, String selectedObjName, String uniqueValueFieldLastValue) {
        return HomeSearchCtrl.getReportData(filterJSON, selectedObjName, uniqueValueFieldLastValue);
    }
    
    /**
     * Name: printData
     * Description: Getting report result data for grid filters applied
     * @Param:  (1) filterJSON - String  - Filter JSON String 
     * @Return: String
     * 
    **/
    @RemoteAction
    public static String printData(String dataJSON) {
        System.assert(false, dataJSON.length());
        return BPUtility.getEncodedString('');
    }
    
    /**
     * Name: deleteRawFilterData
     * Description: Delete filter raw data
     * @Param:  (1) filterId - String  - Filter Id to del 
     * @Return: String
     * 
    **/
    @RemoteAction
    public static String deleteRawFilterData(String filterIdStr) {
        Id filterId;
        filterIdStr = BPUtility.getDecodedString(filterIdStr);
        try{
            filterId = filterIdStr;
        } catch(Exception e) {
            filterIdStr = ApexPages.currentPage().getParameters().get('filterId');
            filterIdStr = String.escapeSingleQuotes(filterIdStr);
        }
        
        if(filterId != null) {
            PreviewGridRecordsCtrl.deleteRawFiltersData(new List<Id>{filterId});
        }
        return BPUtility.getEncodedString('true');
    }
    
    /**
     * Name: deleteRawFilterData
     * Description: Delete filter raw data
     * @Param:  
     * @Return: 
     * 
    **/
    @future
    public static void deleteRawFiltersData(List<Id> filterIds) {
        if(AccessControl.ifObjectIsDeletable('Filter__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Filter__c> filtersToDel = new List<Filter__c>();
        for(Id filterId : filterIds) {
            filtersToDel.add(new Filter__c(Id = filterId));
        }
        
        if(filtersToDel.size() > 0) {
            delete filtersToDel;
        }
    }
}