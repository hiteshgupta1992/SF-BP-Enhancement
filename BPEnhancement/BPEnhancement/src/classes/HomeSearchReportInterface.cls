/**
 * Author: Tarun Khandelwal
 * Since: April 20, 2016
 * Name: HomeSearchReportInterface
 * Description: Class used to hold utility methods, variables and mapping used in Home Search screen
 * 
**/
public with sharing class HomeSearchReportInterface {
	public static Set<String> validTextTypes = new Set<String>{'STRING', 'PICKLIST', 'URL', 'EMAIL'} ;//MULTIPICKLIST
	public static Set<String> specialFields = new Set<String>{'Name'} ;

	public static Map<String,String> getWhereClauseForObjects(HomeSearchFilterWrapper filterWrapperObj){
		Map<String, String> filterConditionMap = new map<String, String>();

		Map<String, List<HomeSearchFilterInterface.FieldFilter>> objNameToFieldFilterListMap = HomeSearchFilterInterface.getFilterList(filterWrapperObj);
		Map<String, String> objNameToWhereClauseStringMap = new Map<String, String>();

		Set<String> objectSet = new Set<String>();
		if(filterWrapperObj.Type.Objects.size() == 0 || (filterWrapperObj.Type.Objects.size() == 1 && filterWrapperObj.Type.Objects.contains(Label.Generic_Object_Label))) {
			objectSet = HomeSearchUtil.displayObjectNameToTypeNumber.keySet();
		} else {
			objectSet = filterWrapperObj.Type.Objects;
		}
		//system.assert(false, objectSet);
		for(String objName : objectSet) {  
			String whereClause = '';
			if(objNameToFieldFilterListMap.containsKey(objName)) {
				whereClause = getWhereClause(objName, objNameToFieldFilterListMap.get(objName));
			} else {
				whereClause = getWhereClause(objName, new List<HomeSearchFilterInterface.FieldFilter>());
			}
			
			String containsClause = getContainsCondition(objName, filterWrapperObj.SearchText);
			
			if(whereClause != '' && containsClause != '') {
				whereClause = whereClause + ' AND ' + containsClause;
			} else if(whereClause == '' && containsClause != ''){
				whereClause = ' WHERE ' + containsClause;
			}
			objNameToWhereClauseStringMap.put(objName, whereClause);
		}
		//system.assert(false, objNameToWhereClauseStringMap);
		return objNameToWhereClauseStringMap;  
	}
	
	private static String getWhereClause(String objName, List<HomeSearchFilterInterface.FieldFilter> filterList) {
		
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
		return queryWhereClause;
	}
	
	public static String getContainsCondition(String objName, String searchText) {
		List<FieldFilter> fieldFilterList = new List<FieldFilter>();
		
		if(!String.isBlank(searchText)) {
			List<String> textFieldsList = getFieldsByObjectName(HomeSearchUtil.displayObjectNameToObjectAPINameMap.get(objName));
			for(String textFieldStr : textFieldsList) {
				fieldFilterList.add(new FieldFilter(textFieldStr, 'Like', '\'%' + searchText + '%\''));
			}
		}
		
		String containsClause = '( ';
		for(FieldFilter fieldFilterRec : fieldFilterList) {
			containsClause += fieldFilterRec.FieldName + ' ' + fieldFilterRec.Operator + ' ' + fieldFilterRec.FieldValue + ' OR ';
		}
		if(fieldFilterList.size() == 0 || containsClause.length() <= 2) {
			containsClause = '';
		} else {
			containsClause = containsClause.substring(0, containsClause.length() - 3);
			containsClause += ')';
		}
		return containsClause;
	}
	
	public static List<String> getFieldsByObjectName(String objAPIName) {
		List<String> textFieldsList = new List<String>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		objAPIName = objAPIName.contains('__c') ? CONSTANTS.NAMESPACE+objAPIName : objAPIName;
		List<Schema.SObjectField> sfieldList = schemaMap.get(objAPIName).getDescribe().fields.getMap().values();
		for(Schema.SObjectField sField : sfieldList) {
			if(objAPIName=='CO_Invoice_Header__c' &&  sField.getDescribe().getName() == 'Invoice_Number__c'  ){
                textFieldsList.add(sField.getDescribe().getName());
            }
            if(specialFields.contains(sField.getDescribe().getName()) || (validTextTypes.contains(sfield.getDescribe().getType().Name()) && sfield.getDescribe().isUpdateable())) {
                if(objAPIName=='CO_Invoice_Header__c' &&  sField.getDescribe().getName() == 'Name'){
                    continue;
                }
                textFieldsList.add(sField.getDescribe().getName());
            }
        }
        return textFieldsList;
	}
	
	
	public class FieldFilter {
		public String FieldName;
		public String Operator;
		public Object FieldValue;
		
		public FieldFilter(String fieldName, String operator, Object value){
		 	this.FieldName = fieldName;
		 	this.Operator = operator;
		 	this.FieldValue = value;
		 }
	}
}