public with sharing class SObjectInstance implements Comparable{
	public sObject record {get; private set;}
	
	public SObjectInstance(sObject record){
		this.record = record;
	}
	
	// Compare opportunities based on the opportunity amount.
	public Integer compareTo(Object compareToObj) {
		SObjectInstance compareToWrapper = (SObjectInstance)compareToObj;
		sObject compareTo = compareToWrapper.record;
		//System.assert(false, String.valueOf(record.get('Id'))  + '   ' + String.valueOf(compareTo.get('Id')));
		
		// The return value of 0 indicates that both elements are equal.
		Integer returnValue = 0;
		
		// Object names
		String comparableObjName = String.valueOf(record.getSObjectType());
		String comparaToObjName = String.valueOf(compareTo.getSObjectType());
		
		//System.assert(false, Utility.sortMapping);
		for(Utility.SortByMapping sortField : Utility.sortMapping){
			Integer fieldCompareResult = 0;
			
			if( sortField.fieldName != null && returnValue == 0){
				String comapreableFieldName = JSONService.searchableObjectJSONToFieldKeyMap.get(comparableObjName).get(sortField.fieldName);
				String comapreToFieldName = JSONService.searchableObjectJSONToFieldKeyMap.get(comparaToObjName).get(sortField.fieldName);
				String comparableFieldValue;
				String comapreToFieldValue;
				
				// Comaparable Field
				if( !comapreableFieldName.contains('Owner') ){
					comparableFieldValue = String.valueOf(record.get(comapreableFieldName));
				} else if( comapreableFieldName.contains('__r') ){
					sObject parentObjOwner = record.getSObject(comapreableFieldName.split('\\.')[0]).getSObject(comapreableFieldName.split('\\.')[1]);
					comparableFieldValue = (String) parentObjOwner.get(comapreableFieldName.split('\\.')[2]);
				} else if( comapreableFieldName.contains('Owner') ) {
					comparableFieldValue = String.valueOf(record.getSObject('Owner').get(comapreableFieldName.split('\\.')[1]));
				}
				
				// Compare To Field
				if( !comapreToFieldName.contains('Owner') ){
					comapreToFieldValue = String.valueOf(compareTo.get(comapreToFieldName));
				} else if( comapreToFieldName.contains('__r') ){
					sObject parentObjOwner = compareTo.getSObject(comapreToFieldName.split('\\.')[0]).getSObject(comapreToFieldName.split('\\.')[1]);
					comapreToFieldValue = (String) parentObjOwner.get(comapreToFieldName.split('\\.')[2]);
				} else if( comapreToFieldName.contains('Owner') ) {
					comapreToFieldValue = String.valueOf(compareTo.getSObject('Owner').get(comapreToFieldName.split('\\.')[1]));
				}
				
				if( comparableFieldValue > comapreToFieldValue ){
					fieldCompareResult = 1;
				} else if( comparableFieldValue < comapreToFieldValue ){
					fieldCompareResult = -1;
				}
				
				if(sortField.direction == 'DESC'){
					fieldCompareResult *= -1;
				}
				
				returnValue += fieldCompareResult;
			}
		}
		
		if(returnValue > 0){
			return 1;
		} else if(returnValue < 0){
			return -1;
		}
		
		return returnValue;       
	}
}