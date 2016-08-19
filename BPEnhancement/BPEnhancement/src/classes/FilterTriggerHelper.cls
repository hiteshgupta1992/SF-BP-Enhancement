/**
 * Author: Hitesh Gupta
 * Since: March 30, 2016
 * Name: FilterTriggerHelper
 * Description: Helper class for FilterTrigger
**/
public with sharing class FilterTriggerHelper {
	
	public static List<Filter__c> FilterNewList = new List<Filter__c>();
    public static List<Filter__c> FilterOldList = new List<Filter__c>();
    public static Map<Id, Filter__c> FilterNewMap = new Map<Id, Filter__c>();
    public static Map<Id, Filter__c> FilterOldMap = new Map<Id, Filter__c>();
    
    public static Boolean runTrigger = true;
    
    
    /**
     * Name: hashCodeCalculation
     * Desc: Method calculate the hash code based on filter JSON
     * @param: 
     * @return: 
    **/  
    public static void hashCodeCalculation() {
    	for(Filter__c filterObj : FilterNewList){
			String hashCodeString = ((filterObj.Field_Filter_Json__c == null) ? '' : filterObj.Field_Filter_Json__c);
			/*
									+ ((filterObj.Summary_Field_Json__c == null) ? '' : filterObj.Summary_Field_Json__c) 
									+ ((filterObj.Export_Field_Json__c == null) ? '' : filterObj.Export_Field_Json__c) 
									+ ((filterObj.Export_File_Format__c == null) ? '' : filterObj.Export_File_Format__c)
									+ ((filterObj.Export_GroupBy_Field__c == null) ? '' : filterObj.Export_GroupBy_Field__c);
			*/
			if(hashCodeString != null && hashCodeString.trim().length() != 0) {
				//hashCodeString += filterObj.Show_All_Records__c;
				
				filterObj.Field_Filter_JSON_Hash_Code__c = hashCodeString.hashCode();
			} else {
				filterObj.Field_Filter_JSON_Hash_Code__c = null;
			}
    	}
    }
}