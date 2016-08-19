public with sharing class SuggestedRecordEntity implements Comparable {
	// sObject instance for the entity
	public sObject record {get; private set;}
	
	// Constructor
	public SuggestedRecordEntity( sObject record ){
		this.record = record;
	}
	
	// Compare the suggested items so as to sort them in a defined order in autocomplete overlay on UI
	// Sort the records by exact text first then partial text match
	// In each case "LastModifiedDate" will be most effective sort criteria
	public Integer compareTo(Object compareToObj) {
		// The return value of 0 indicates that both elements are equal.
		Integer returnValue = 0;
		
		SuggestedRecordEntity compareToWrapper = (SuggestedRecordEntity)compareToObj;
		sObject compareTo = compareToWrapper.record;
		
		// Get object name from record. If Account, 
		// then decide if customer or vendor as in custom setting we are having display field name as per customer/vendor or object name
		String comparableObjName = String.valueOf(record.getSObjectType());
		if(comparableObjName == 'Account'){
			if( Boolean.valueOf(record.get('Is_Customer__c')) ){
				comparableObjName = Constants.customerObjectLabel;
			} else if( Boolean.valueOf(record.get('Is_Vendor__c')) ){
				comparableObjName = Constants.vendorObjectLabel;
			}
		}
		// Display field name for Comparable object
		String comparableDisplayFieldName = Constants.objectToDisplayFieldsMap.get(comparableObjName);
		if(comparableDisplayFieldName == null){
			// Means map has no entry for the record so leave it at the bottom
			return -1;
		}
		String comparableFieldValue = String.valueOf(record.get(comparableDisplayFieldName)).toLowerCase();

		DateTime comparableModifiedDate = DateTime.valueOf(record.get('LastModifiedDate'));
		
		String compareToObjName = String.valueOf(compareTo.getSObjectType());
		if(compareToObjName == 'Account'){
			if( Boolean.valueOf(record.get('Is_Customer__c')) ){
				compareToObjName = Constants.customerObjectLabel;
			} else if( Boolean.valueOf(record.get('Is_Vendor__c')) ){
				compareToObjName = Constants.vendorObjectLabel;
			}
		}
		// Display field name for object
		String compareToDisplayFieldName = Constants.objectToDisplayFieldsMap.get(compareToObjName);
		String compareToFieldValue = String.valueOf(compareTo.get(compareToDisplayFieldName)).toLowerCase();
		DateTime compareToModifiedDate = DateTime.valueOf(compareTo.get('LastModifiedDate'));
		
		// Compare display field value with search term, cases:
		// I) If search text is contained by display field value of any of the record
		// 		1. If both are different values:
		//			A) Exact match one will dominate
		//		2. If both are same values:
		//			B) Recently modified record will dominate
		// II) If search text is not present in any of the display values
		//		1. Recently modified record will dominate
		if( (comparableFieldValue.indexOf(SearchSuggestionUtil.textToSearch) != -1) || (compareToFieldValue.indexOf(SearchSuggestionUtil.textToSearch) != -1) ){
			if( comparableFieldValue.equalsIgnoreCase(compareToFieldValue) ){
				if(comparableModifiedDate == compareToModifiedDate){
					returnValue = (comparableFieldValue > compareToFieldValue) ? -1 : 1;
				} else {
					returnValue = (comparableModifiedDate > compareToModifiedDate) ? -1 : 1;
				}
			} else {
				if((comparableFieldValue.indexOf(SearchSuggestionUtil.textToSearch) != -1) && (comparableFieldValue.length() == SearchSuggestionUtil.textToSearch.length())){
					returnValue = -1;
				} else if((compareToFieldValue.indexOf(SearchSuggestionUtil.textToSearch) != -1) && (compareToFieldValue.length() == SearchSuggestionUtil.textToSearch.length())){
					returnValue = 1;
				} else {
					Integer comparableIndexVal = comparableFieldValue.indexOf(SearchSuggestionUtil.textToSearch);
					Integer compareToIndexVal = compareToFieldValue.indexOf(SearchSuggestionUtil.textToSearch);
					
					returnValue = 	(comparableIndexVal == compareToIndexVal && comparableIndexVal == -1)
										? ((comparableFieldValue.compareTo(compareToFieldValue) <= 0) ? -1 : 1)
										: (comparableIndexVal == -1) 
												? 1 
												: (compareToIndexVal == -1) 
													? -1
													: ((comparableFieldValue.length() > SearchSuggestionUtil.textToSearch.length() + comparableIndexVal) && (comparableFieldValue.charAt(SearchSuggestionUtil.textToSearch.length() + comparableIndexVal - 1) == 32))
														? -1
														: ((compareToFieldValue.length() > SearchSuggestionUtil.textToSearch.length() + comparableIndexVal) && (compareToFieldValue.charAt(SearchSuggestionUtil.textToSearch.length() + compareToIndexVal - 1) == 32))
															? 1
															: ((comparableFieldValue.compareTo(compareToFieldValue) <= 0) ? -1 : 1);
				}
			}
		} else {
			if(comparableModifiedDate == compareToModifiedDate){
				returnValue = (comparableFieldValue > compareToFieldValue) ? -1 : 1;
			} else {
				returnValue = (comparableModifiedDate > compareToModifiedDate) ? -1 : 1;
			}
		}
		
		return returnValue;
	}
}