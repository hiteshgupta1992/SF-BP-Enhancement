public with sharing class HSSObjectInstance implements Comparable{
	public sObject record {get; private set;}
	
	public HSSObjectInstance(sObject record){
		this.record = record;
	}
	
	// Compare opportunities based on the opportunity amount.
	public Integer compareTo(Object compareToObj) {
		HSSObjectInstance compareToWrapper = (HSSObjectInstance)compareToObj;
		sObject compareTo = compareToWrapper.record;
		//System.assert(false, String.valueOf(record.get('Id'))  + '   ' + String.valueOf(compareTo.get('Id')));
		
		// The return value of 0 indicates that both elements are equal.
		Integer returnValue = 0;
		
		// Object names
		String comparableObjName = String.valueOf(record.getSObjectType());
		String compareToObjName = String.valueOf(compareTo.getSObjectType());
		
		//System.assert(false, Utility.sortMapping);
		List<SortByMapping> sortMapping = new List<SortByMapping>();
		if(HomeSearchUtil.sortMapping != null){
			for(PaginationSorting.SortAttrs sm : HomeSearchUtil.sortMapping) {
				sortMapping.add(new SortByMapping(sm.FieldName, sm.SortDirection));
			}
		}
		System.debug('@@@@@\n\n' + sortMapping);
		for(SortByMapping sortField : sortMapping){
			Integer fieldCompareResult = 0;
			
			if( sortField.fieldName != null && returnValue == 0){
				String comapreableFieldName = getSortFieldNameForObject(comparableObjName, sortField.FieldName);
				List<String> comapreableOwnerFields = comapreableFieldName.split('\\.');
				
				String comapreToFieldName = getSortFieldNameForObject(compareToObjName, sortField.FieldName);
				List<String> comapreToOwnerFields = comapreToFieldName.split('\\.');
				
				System.debug('@#@#@#@#\n\n' + comparableObjName + '\n' + comapreableFieldName + '\n' + comapreableOwnerFields);
				System.debug('@#@#@#@#\n\n' + compareToObjName + '\n' + comapreToFieldName + '\n' + comapreToOwnerFields);
				
				String comparableFieldValue = '';
				String comapreToFieldValue = '';
				
				// Comaparable Field
				if( comapreableFieldName.contains('CreatedBy') ){
					if(comapreableOwnerFields.size() == 1) {
						comparableFieldValue = (String) record.get(comapreableOwnerFields[0]);
					} else if(comapreableOwnerFields.size() == 2 && record.getSObject(comapreableOwnerFields[0]) != null) {
						comparableFieldValue = (String) record.getSObject(comapreableOwnerFields[0]).get(comapreableOwnerFields[1]);
					}
				} else if( !comapreableFieldName.contains('Owner') ){
					comparableFieldValue = String.valueOf(record.get(comapreableFieldName));
				} else if(comapreableOwnerFields.size() == 1) {
					comparableFieldValue = (String) record.get(comapreableOwnerFields[0]);
				} else if(comapreableOwnerFields.size() == 2) {
					if(record.getSObject(comapreableOwnerFields[0]) != null) {
						comparableFieldValue = (String) record.getSObject(comapreableOwnerFields[0]).get(comapreableOwnerFields[1]);
					}
				} else if(comapreableOwnerFields.size() == 3){
					System.debug('$$$$$$\n' + record.getSObject(comapreableOwnerFields[0]));
					System.debug('%%%%%%\n' + record.getSObject(comapreableOwnerFields[0]).getSObject(comapreableOwnerFields[1]));
					if(record.getSObject(comapreableOwnerFields[0]) != null && record.getSObject(comapreableOwnerFields[0]).getSObject(comapreableOwnerFields[1]) != null) {
						comparableFieldValue = (String) record.getSObject(comapreableOwnerFields[0]).getSObject(comapreableOwnerFields[1]).get(comapreableOwnerFields[2]);
					}
				}
				
				// Compare To Field
				if( !comapreToFieldName.contains('Owner') ){
					comapreToFieldValue = String.valueOf(compareTo.get(comapreToFieldName));
				} else if(comapreToOwnerFields.size() == 1) {
					comapreToFieldValue = (String) compareTo.get(comapreToOwnerFields[1]);
				} else if(comapreToOwnerFields.size() == 2) {
					if(compareTo.getSObject(comapreToOwnerFields[0]) != null) {
						comapreToFieldValue = (String) compareTo.getSObject(comapreToOwnerFields[0]).get(comapreToOwnerFields[1]);
					}
				} else if(comapreToOwnerFields.size() == 3){
					if(compareTo.getSObject(comapreToOwnerFields[0]) != null && compareTo.getSObject(comapreToOwnerFields[0]).getSObject(comapreToOwnerFields[1]) != null) {
						comapreToFieldValue = (String) compareTo.getSObject(comapreToOwnerFields[0]).getSObject(comapreToOwnerFields[1]).get(comapreToOwnerFields[2]);
					}
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
	
	private static String getSortFieldNameForObject(String objName, String fieldLabel) {
		String fieldAPIName;
		if(fieldLabel != null 
			&& HomeSearchUtil.searchableObjectToFieldsMap.containsKey(objName) 
			&& HomeSearchUtil.searchableObjectToFieldsMap.get(objName).contains(fieldLabel)
		){
			fieldAPIName = fieldLabel;
		} else if(fieldLabel != null 
					&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.containsKey(objName) 
					&& HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objName).containsKey(fieldLabel)
				) {
			fieldAPIName = HomeSearchUtil.obejctNameToMapOfSortLabelToAPIName.get(objName).get(fieldLabel);
		}
		return (fieldAPIName != null) ? fieldAPIName : fieldLabel;
	}
	
	/**
     * Name: SortByMapping Class
     * Desc: Class used for JSON objects in sorting
    **/
    public class SortByMapping {
    	public String FieldName {get; set;}
    	public String Direction {get; set;}
    	
    	public SortByMapping(String FieldName, String Direction){
    		this.FieldName = FieldName;
    		this.Direction = Direction;
    	}
    }
}