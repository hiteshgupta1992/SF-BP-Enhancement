/**
 * Author: Ashish Garg
 * Since: Sept. 11, 2014
 * Name: Utility
 * Description: Utility class which holds common and geenral methods used in system
**/
public with sharing class Utility {
    public static List<Utility.SortByMapping> sortMapping;
    
    /**
     * Name: createJSON
     * Desc: To create JSON String for given list 
     * @param: sobjectList - List of Sobjects that are to be converted into the JSON
     *         fieldsAPINameToJsonMap - Map<String, String>
     *                                  Key - Fields API Name
     *                                  Value - Their JSON resentation name
     *         fieldsAPINameToDataTypeMap - Map<String, String>
     *                                      Key - Fields API Name
     *                                      Value - Field's Data Type
     *         sobjectChildernList - List of children Sobjects that are to be converted into the JSON 
     *         childrenFieldsAPINameToJsonMap - Map<String, String>
     *                                          Key - Fields API Name of children sobject
     *                                          Value - Their JSON repreantation Name
     *         childrenFieldsAPINameToDataTypeMap - Map<String, String>
     *                                              Key - Fields API Name of children sobject
     *                                              Value - Field's Data Type of children Sobjects                              
     * @return: String - converted JSON string                              
    **/
    public static String createJSON(List<Sobject> sobjectList, Map<String, String> fieldsAPINameToJsonMap, Map<String, String> fieldsAPINameToDataTypeMap,
                                    List<Sobject> sobjectChildernList, Map<String, String> childrenFieldsAPINameToJsonMap, Map<String, String> childrenFieldsAPINameToDataTypeMap) {
        
        String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        for(Sobject sobj : sobjectList) {
            //generator.writeObject(sobj);
            generator.writeStartObject();
            for(String fieldAPIName : fieldsAPINameToJsonMap.keySet()) {
                addFieldToJsonGenerator(generator, fieldAPIName, fieldsAPINameToJsonMap, fieldsAPINameToDataTypeMap, sobj);
            }
            if(BlackPurlContentCtrl.filterRecordsRetrived != null) {
            	generator.writeStringField('TotalFilteredRecords', BlackPurlContentCtrl.filterRecordsRetrived);
            }
            
            // If Children List have some values.
            if(sobjectChildernList.size() != 0) {
                generator.writeFieldName('Sales Tax Item');
                generator.writeStartArray();
                for(Sobject childSobj : sobjectChildernList) {
                    generator.writeStartObject();
                    for(String childFieldAPIName : childrenFieldsAPINameToJsonMap.keySet()) {
                        addFieldToJsonGenerator(generator, childFieldAPIName, childrenFieldsAPINameToJsonMap, childrenFieldsAPINameToDataTypeMap, childSobj);
                    }
                    generator.writeEndObject();
                }
                generator.writeEndArray();
            }
            generator.writeEndObject();
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: createAutoCompleteJSONForObj
     * Desc: To create JSON String for given list of sObject records in an autocomplete specially
     * @param:	sObjName - sObejct type name for which JSON to be created
     *			sObjRecords - List of sObejct records that are to be converted into the JSON
     * @return: String - converted JSON string                              
    **/
    public static String createAutoCompleteJSONForObj(String sObjName, List<sObject> sObjRecords) {
        String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        
        if(sObjRecords.size() > 0){
	        Map<String, String> fieldsAPINameToJsonMap = Constants.OBJ_TO_JSON_FIELDS_MAP.get(sObjName);
	    	Map<String, String> fieldsAPINameToDataJsonMap = Constants.OBJ_TO_JSON_DATA_MAP.get(sObjName);
	        for(sObject sObj : sObjRecords) {
	            generator.writeStartObject();
	            for(String fieldApiName : fieldsAPINameToDataJsonMap.keySet()) {
		            String dataDisplay = fieldsAPINameToDataJsonMap.get(fieldApiName);
		            
		            // replace any field api name occurrence with respective value:
		            for(String fieldName : fieldsAPINameToJsonMap.keySet()) {
		            	if(dataDisplay.contains(fieldName)){
		            		String dataStr = (sObj.get(fieldName) != null) ? String.valueOf(sObj.get(fieldName)) : '';
		            		dataDisplay = dataDisplay.replaceAll(fieldName, dataStr);
		            	}
		            }
		            generator.writeStringField(fieldsAPINameToJsonMap.get(fieldApiName), dataDisplay);
	            }
	            generator.writeEndObject();
	        }
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: createJsonWithRecentItemsFirst
     * Desc: To create JSON String for given list. Recent Items are in first and one more flag is to be added.
     * @param: sobjectList - List of Sobjects that are to be converted into the JSON
     *         fieldsAPINameToJsonMap - Map<String, String>
     *                                  Key - Fields API Name
     *                                  Value - Their JSON resentation name
     *         fieldsAPINameToDataTypeMap - Map<String, String>
     *                                      Key - Fields API Name
     *                                      Value - Field's Data Type
     *         sobjectChildernList - List of children Sobjects that are to be converted into the JSON 
     * @return: String - converted JSON string                              
    **/
    public static String createJsonWithRecentItemsFirst(List<Sobject> sobjectList, Map<String, String> fieldsAPINameToJsonMap, 
    													Map<String, String> fieldsAPINameToDataTypeMap, Set<Id> recentIdSet, String objectName) {
        
        String JSONString = '';
        Integer counter = 0;
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        for(Sobject sobj : sobjectList) {
            generator.writeStartObject();
            for(String fieldAPIName : fieldsAPINameToJsonMap.keySet()) {
                addFieldToJsonGenerator(generator, fieldAPIName, fieldsAPINameToJsonMap, fieldsAPINameToDataTypeMap, sobj);
            } 
            
            if(!BlackPurlContentCtrl.isIncreaseCustomersMethodExecuted && recentIdSet.contains(sobj.Id)) {
            	generator.writeBooleanField('Is_recent', true);
            } else {
            	generator.writeBooleanField('Is_recent', false);
            }

			if(BlackPurlContentCtrl.partsRetrived != null) {
            	generator.writeStringField('TotalFilteredRecords', BlackPurlContentCtrl.partsRetrived);
            } else if (BlackPurlContentCtrl.customersRetrived != null) {
            	generator.writeStringField('TotalFilteredRecords', BlackPurlContentCtrl.customersRetrived);
            }
            generator.writeEndObject();
            counter++;
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: createDropdownJSONForPicklistEntries
     * Desc: To create JSON String for given list of sObject picklist field values in an piklist specially
     * @param:	pick_list_values - List of Schema.PicklistEntry values for which to create JSON string
     * @return: String - converted JSON string                              
    **/
    public static String createDropdownJSONForPicklistEntries(List<Schema.PicklistEntry> pick_list_values) {
        String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        
        if(pick_list_values.size() > 0){
            for (Schema.PicklistEntry a : pick_list_values) {
            	generator.writeStartObject();
	        	generator.writeStringField('Name', a.getValue());
	        	generator.writeStringField('Value', a.getValue());
	        	generator.writeEndObject();
	        }
        }
        
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: createDropdownJSONForSObjectRecords
     * Desc: To create JSON String for given list of sObject records in an piklist specially
     * @param:	sObjectRecords - List of sObejct records for which to create JSON string
     *			displayFieldName - field API name whose value will be displayed as picklist value
     * @return: String - converted JSON string                              
    **/
    public static String createDropdownJSONForSObjectRecords(List<sObject> sObjectRecords, String displayFieldName) {
        String JSONString = '';
        System.JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        
        if(sObjectRecords.size() > 0){
            for (sObject sObj : sObjectRecords) {
            	generator.writeStartObject();
	        	generator.writeStringField('Value', String.valueOf(sObj.get('Id')) );
	        	generator.writeStringField('Name', String.valueOf(sObj.get(displayFieldName)) );
	        	generator.writeEndObject();
	        }
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: addFieldToJsonGenerator
     * Desc: Add the Fields according to their data types to the JSON generator
     * @param: generator - JSON generator
     *         fieldApiName - API Name of field that is to be added to the JSON generator
     *         apiNameToJsonMap - Map<String, String>                           
     *                            Key - Fields API Name
     *                            Value - Their JSON resentation Name
     *         apiNameToDataTypeMap - Map<String, String>
     *                                Key - Fields API Name
     *                                Value - Field's Data Type
     *         currentSObj - Current SObject which fields are to be converted into JSON Format                              
    **/
    private static void addFieldToJsonGenerator(System.JSONGenerator generator, String fieldApiName, Map<String, String> apiNameToJsonMap, Map<String, String> apiNameToDataTypeMap, Sobject currentSObj) {
        if(apiNameToDataTypeMap.get(fieldApiName) == 'String') {            
            if(currentSObj.get(fieldApiName) == null) {
                currentSObj.put(fieldApiName, '');
            }            
            generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(currentSObj.get(fieldApiName)));
        } else if(apiNameToDataTypeMap.get(fieldApiName) == 'Boolean') {
            if(currentSObj.get(fieldApiName) == null) {
                currentSObj.put(fieldApiName, false);
            }
            generator.writeBooleanField(apiNameToJsonMap.get(fieldApiName), Boolean.valueOf(currentSObj.get(fieldApiName)));
        } else if(apiNameToDataTypeMap.get(fieldApiName) == 'Number') {
        	if(currentSObj.get(fieldApiName) != null) {
            	generator.writeNumberField(apiNameToJsonMap.get(fieldApiName), Decimal.valueOf(String.valueOf(currentSObj.get(fieldApiName))));
        	} else {
        		generator.writeNumberField(apiNameToJsonMap.get(fieldApiName), 0);
        	}
        } else if(apiNameToDataTypeMap.get(fieldApiName) == 'Id') {
            generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(currentSObj.get(fieldApiName)));
        } else if(apiNameToDataTypeMap.get(fieldApiName) == 'Date') {
        	if(currentSObj.get(fieldApiName) != null) {
           		generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(Date.valueOf(currentSObj.get(fieldApiName)).format()));
        	} else {
        		generator.writeStringField(apiNameToJsonMap.get(fieldApiName), '');
        	}
        } else if(apiNameToDataTypeMap.get(fieldApiName) == 'Reference') {
        	String parentObjectName = fieldApiName.substringBefore('.');
            if(currentSObj.getSobject(parentObjectName) != null) {
				if(parentObjectName == 'Superseded_By__r') {
            		generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(currentSObj.getSobject(parentObjectName).get('Part_ID__c')));
				} else {
            		generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(currentSObj.getSobject(parentObjectName).get('Name')));
            	}
        	} else {
            		generator.writeStringField(apiNameToJsonMap.get(fieldApiName), '');
        	}
        } if(apiNameToDataTypeMap.get(fieldApiName) == 'Formula') {            
            if(currentSObj.get(fieldApiName) != null) {
            	generator.writeStringField(apiNameToJsonMap.get(fieldApiName), String.valueOf(currentSObj.get(fieldApiName)));
            }
        }

    }
    
    /**
     * Name: parseJSON
     * Desc: convert JSON to fields values of sobjects and returns sobject
     * @param: JSONString - JSON String to be parsed
     *         sobj - Sobject refernce in which all fields according to JSON are added
     *         JSONLabelToFieldsApiName - Map<String, String>                           
     *                                    Key - JSON Label (JSON key)
     *                                    Value - Field API Name
     *         fieldsAPINameToDataTypeMap - Map<String, String>
     *                                      Key - Fields API Name
     *                                      Value - Field's Data Type
     * @return: SObject which have fields values according to JSON                              
    **/
    public static List<sobject> parseJSON(String JSONString, Sobject sobj, Map<String, String> JSONLabelToFieldsApiName, Map<String, String> fieldsAPINameToDataTypeMap) {
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
            //if (parser.getCurrentToken() == JSONToken.START_ARRAY) { 
             //   while (parser.nextToken() !=  JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
                        while (parser.nextToken() !=  JSONToken.END_OBJECT) { 

                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {

                                String fieldName = parser.getText();

                                parser.nextToken();
                                for(String JsonFieldName : JSONLabelToFieldsApiName.keyset()) {
                                    if(JsonFieldName == fieldName) {
                                        if(fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName)) == 'String') {
                                            sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), parser.getText());
                                        } else if(fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName)) == 'Number') {
											decimal decimalValue = 0.00;
                                        	if(parser.getText() != null && parser.getText() != '' && parser.getText() != 'null'){
                                        		decimalValue = Decimal.valueOf(parser.getText());
                                        		sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), decimalValue);
                                        	} else {
                                        		sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), 0);
                                        	}	
                                        } else if(fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName)) == 'Boolean') {
                                            sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), parser.getBooleanValue());
                                        } else if(fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName)) == 'Id') {
                                            if(parser.getText() != null && parser.getText() != '') {
                                                sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), parser.getText());
                                            }

                                        } else if(fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName)) == 'Reference') {
                                        	if(JSONLabelToFieldsApiName.get(JsonFieldName).contains('.')) { 
						    					String parentObjectName = JSONLabelToFieldsApiName.get(JsonFieldName).substringBefore('.');
						    					parentObjectName = parentObjectName.replace('__r', '__c');
												if(parentObjectName == 'Superseded_By__c') {
													continue;
												}
						    					String recordId = SOQLUtil.getObjectIdByItsName(parser.getText(), parentObjectName);
						    					SYSTEM.debug(recordId);
						    					sobj.put(parentObjectName, recordId);
						    				}
                                        } else if (fieldsAPINameToDataTypeMap.get(JSONLabelToFieldsApiName.get(JsonFieldName))=='Date'){
	                                        if(parser.getText() !='' && parser.getText() !=null){
												String Dt = parser.getText();
												String[] dts = Dt.split('/');
												Date Customdate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
	                                        	sobj.put(JSONLabelToFieldsApiName.get(JsonFieldName), Customdate);
	                                        }
                                        }
                                    }
                                }
                            }
                        }
                    }
              //  }
            //}
        }
        List<Sobject> sobjList = new List<Sobject>();
        sobjList.add(sobj);
        return sobjList;
    }
    
    /**
     * Name: getPicklistValues
     * Desc: Method returns picklist values for a field.
     * @param: objFieldStr - String value for field name (Syntax objectAPIName.FieldAPIName)
     * @return: String
    **/
    public static String getPicklistValues(String objFieldStr){
        JSONGenerator gen = JSON.createGenerator(true);
        // Get a map for Object name to picklist fields name list from parameter map
        Map<String, Set<String>> objNameToPicklistFieldsName = new Map<String, Set<String>>();
        String ObjectApi_name;
        String fieldName;
        if(objFieldStr.contains('.')){
            ObjectApi_name = objFieldStr.split('\\.')[0];
            fieldName = objFieldStr.split('\\.')[1];
        }
        Map<String, Schema.SObjectType> globalDesMap = Schema.getGlobalDescribe();
        ObjectApi_name = ObjectApi_name.contains('__c') ? CONSTANTS.NAMESPACE+ObjectApi_name : ObjectApi_name;
        Schema.SObjectType targetType = globalDesMap.get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        gen.writeStartArray();
        for (Schema.PicklistEntry a : pick_list_values) {
            gen.writeStartObject();
            gen.writeStringField('Value', a.getValue());
            gen.writeStringField('Name', a.getValue());
            gen.writeEndObject();
    	}
        gen.writeEndArray();
        String pretty = gen.getAsString();
        return pretty;
    }
    
    /**
     * Name: getPicklistValues
     * Desc: Method returns picklist values for all categoriess available.
     * @param:
     * @return: String
    **/
    public static String getPicklistValues(List<sObject> pickListRecords, boolean required, String valueField, String displayField){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        if( !required ){
	        gen.writeStringField('Value', '');
	        gen.writeStringField('Name', '');
        }
        gen.writeEndObject();
        for (sObject cat : pickListRecords) {
            gen.writeStartObject();
            gen.writeStringField('Value', String.valueOf(cat.get(valueField)));
            gen.writeStringField('Name', String.valueOf(cat.get(displayField)));
            gen.writeEndObject();
        }
        gen.writeEndArray();
        String categoryJSONStr = gen.getAsString();
        return categoryJSONStr;
    }
    

    /**
     * Name: parseFilterJSON
     * Desc: create map from given JSON 
     * @param: JSONString - JSON String to be parsed
     *         JSONLabelToFieldsApiName - Map<String, String>                           
     *                                    Key - JSON Label (JSON key)
     *                                    Value - Field API Name
     * @return: Map<String, String> - filter field name to searched keyword                              
    **/
    public static Map<String, String> parseFilterJSON(String JSONString, Map<String, String> JSONLabelToFieldsApiName) {
        Map<String, String> filterFieldToSearchedStringMap = new Map<String, String>();
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() ==	 JSONToken.START_ARRAY) {
                while (parser.nextToken() !=  JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
                        String searchedFieldAPIName = '';
                        String searchedKeyword = '';
                        while (parser.nextToken() !=  JSONToken.END_OBJECT) { 
                            if(String.valueOf(parser.getText()) == 'field') {
                            	parser.nextToken();
                            	if(parser.getText() == 'Is_Available'){
                            		searchedFieldAPIName = 'Is_Available';
                            	} else {
                                	searchedFieldAPIName = JSONLabelToFieldsApiName.get(parser.getText());
                            	}
                            } else if (String.valueOf(parser.getText()) == 'value') {
                                parser.nextToken();
                                searchedKeyword = parser.getText();
                       		} 
                        }
                        filterFieldToSearchedStringMap.put(searchedFieldAPIName, searchedKeyword);
                    }
                }
            }
        }
        system.debug(' Final  Map  ' + filterFieldToSearchedStringMap);
        return filterFieldToSearchedStringMap;
    }
    
	/**
     * Name: parseFilterJSON
     * Desc: create map from given JSON 
     * @param: JSONString - JSON String to be parsed
     *         JSONLabelToFieldsApiName - Map<String, String>                           
     *                                    Key - JSON Label (JSON key)
     *                                    Value - Field API Name
     * @return: Map<String, String> - filter field name to searched keyword                              
    **/
    public static Map<String, String> parseFilterJSONOperator(String JSONString, Map<String, String> JSONLabelToFieldsApiName) {
        Map<String, String> filterFieldToSearchedStringMap = new Map<String, String>();
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() ==	 JSONToken.START_ARRAY) {
                while (parser.nextToken() !=  JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
                        String searchedFieldAPIName = '';
                        String searchedKeyword = '';
                        while (parser.nextToken() !=  JSONToken.END_OBJECT) { 
                            if(String.valueOf(parser.getText()) == 'field') {
                            	parser.nextToken();
                                if(parser.getText() == 'Is_Available'){
                            		searchedFieldAPIName = 'Is_Available';
                            	} else {
                                	searchedFieldAPIName = JSONLabelToFieldsApiName.get(parser.getText());
                            	}
                            } else if (String.valueOf(parser.getText()) == 'operator') {
                                parser.nextToken();
                                searchedKeyword = parser.getText();
                       		}
                        }
                        system.debug(searchedFieldAPIName + '  ' + searchedKeyword);
                        filterFieldToSearchedStringMap.put(searchedFieldAPIName, searchedKeyword);
                    }
                }
            }
        }
        system.debug(' Final  Map  ' + filterFieldToSearchedStringMap);
        return filterFieldToSearchedStringMap;
    }

    /**
     * Name: createJsonWithDefaultValues
     * Desc: To create JSON String for given list. Recent Items are in first and one more flag is to be added.
     * @param: sobjectList - List of Sobjects that are to be converted into the JSON
     *         fieldsAPINameToJsonMap - Map<String, String>
     *                                  Key - Fields API Name
     *                                  Value - Their JSON resentation name
     *         fieldsAPINameToDataTypeMap - Map<String, String>
     *                                      Key - Fields API Name
     *                                      Value - Field's Data Type
     *         sobjectChildernList - List of children Sobjects that are to be converted into the JSON 
     * @return: String - converted JSON string                              
    **/
    public static String createJsonWithDefaultValues() {
        String JSONString = '';
        Integer counter = 0;
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        generator.writeStartObject();
        
        for(String fieldApiName : Constants.PART_ALL_FIELDS_TO_JSON_MAPPING.keyset()) {
        	if(Constants.PART_FIELDS_TO_DEFAULT_VALUE_MAPPING.containsKey(fieldApiName)) {
        		generator.writeNumberField(Constants.PART_ALL_FIELDS_TO_JSON_MAPPING.get(fieldApiName) , Constants.PART_FIELDS_TO_DEFAULT_VALUE_MAPPING.get(fieldApiName));
        	} else if(Constants.PART_ALL_FIELDS_TO_DATA_TYPE_MAPPING.get(fieldApiName) == 'Boolean') {
        		if(fieldApiName == 'Packaged_Part__c') {
        			generator.writeBooleanField(Constants.PART_ALL_FIELDS_TO_JSON_MAPPING.get(fieldApiName), false);
        		} else {
	            	generator.writeBooleanField(Constants.PART_ALL_FIELDS_TO_JSON_MAPPING.get(fieldApiName), true);
        		}
        	} else if(Constants.PART_ALL_FIELDS_TO_DATA_TYPE_MAPPING.get(fieldApiName) != 'Id'){
        		generator.writeStringField(Constants.PART_ALL_FIELDS_TO_JSON_MAPPING.get(fieldApiName), '');
        	}
        }
        
        generator.writeEndObject();
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
	/**
     * Name: createJsonWithDefaultValues
     * Desc: To create JSON String for given list. Recent Items are in first and one more flag is to be added.
     * @param: sobjectList - List of Sobjects that are to be converted into the JSON
     *         fieldsAPINameToJsonMap - Map<String, String>
     *                                  Key - Fields API Name
     *                                  Value - Their JSON resentation name
     *         fieldsAPINameToDataTypeMap - Map<String, String>
     *                                      Key - Fields API Name
     *                                      Value - Field's Data Type
     *         sobjectChildernList - List of children Sobjects that are to be converted into the JSON 
     * @return: String - converted JSON string                              
    **/
    public static String createJSONForFilteredResult(List<sobject> sobjectList, String fieldAPIName) {
    	String JSONString = '';
    	Set<String> filterDataSet = new Set<String>();
        System.JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartArray();
        for(Sobject sobj : sobjectList) {
        	String fieldValue = '';
        	if(fieldAPIName.contains('.')) {
        		String parentObjectName = fieldApiName.substringBefore('.');
        		String fieldName = fieldApiName.substringAfter('.');
        		fieldValue= String.valueOf(sobj.getSobject(parentObjectName).get(fieldName));
        	} else {
        		fieldValue= String.valueOf(sobj.get(fieldAPIName));
        	}
        	
        	if(!filterDataSet.contains(fieldValue)) {
        		generator.writeString(fieldValue); 
        		filterDataSet.add(fieldValue);
        	}
        }
        generator.writeEndArray();
        JSONString = generator.getAsString();
        return JSONString;
    }
    
    /**
     * Name: parseFilterJSONInSOSL
     * Desc: create map from given JSON 
     * @param: JSONString - JSON String to be parsed
     * @return: Map<String, String> - filter field name to searched keyword                              
    **/
    public static Map<String, List<String>> parseFilterJSONInSOSL(String JSONString) {
    	if(AccessControl.ifObjectFieldIsAccessible('User') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        Map<String, List<String>> filterFieldToSearchedValueMap = new Map<String, List<String>>();
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() ==	 JSONToken.START_ARRAY) {
                while (parser.nextToken() !=  JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { 
                        String mapKey = '';
                        String mapValue = '';
                        Set<String> mapValues = new Set<String>();
                        while (parser.nextToken() !=  JSONToken.END_OBJECT) { 
                            if(String.valueOf(parser.getText()) == 'field') {
                            	parser.nextToken();
                            	if(parser.getText() == 'Type'){
                            		mapKey = 'Object';
                            	} else if(Constants.FILTER_FIELD_TO_FIELD_API_NAME_MAPPING.containsKey(parser.getText())){
                                	mapKey = Constants.FILTER_FIELD_TO_FIELD_API_NAME_MAPPING.get(parser.getText());
                            	} else {
                            		mapKey = parser.getText();
                            	}
                            } else if (String.valueOf(parser.getText()) == 'value') {
                                parser.nextToken();
                                List<String> mapValuesList = parser.getText().split(',');
                                if(mapKey == 'Object') {
                                	for(String value : mapValuesList) {
                                		mapValue = Constants.FILTER_FIELD_TO_FIELD_API_NAME_MAPPING.get(value);
                                		mapValues.add(mapValue);
                                		
	                                	if( mapKey == 'Object' && value == 'Vendor' ){
	                                		filterFieldToSearchedValueMap.put('Is_Vendor__c', new List<String>{'true'});
	                                	} else if( mapKey == 'Object' && value == 'Customer' ){
	                                		filterFieldToSearchedValueMap.put('Is_Customer__c', new List<String>{'true'});
	                                	}
                                	}
                                } else {
                                	mapValues.addAll(mapValuesList);
                                }
                       		} 
                        }
                        
                        if(mapKey.length() != 0){
                        	List<String> valuesList = new List<String>();
                        	valuesList.addAll(mapValues);
                        	filterFieldToSearchedValueMap.put(mapKey, valuesList);
                        }	
                    }
                }
            }
        }
        if( filterFieldToSearchedValueMap.containsKey('OwnerId') ){
        	List<String> userName = filterFieldToSearchedValueMap.get('OwnerId');
        	List<User> userList = [Select Id from User where Name IN :userName LIMIT 3];
        	List<String> userIds = new List<String>();
        	for(User userRec : userList) {
				userIds.add(userRec.Id);	        		
        	}
        	filterFieldToSearchedValueMap.put('OwnerId', userIds);
        }
        
        if(filterFieldToSearchedValueMap.containsKey('OptionNumber')) {
        	List<String> optionNumber = filterFieldToSearchedValueMap.get('OptionNumber');
        	optionNumber.addAll(filterFieldToSearchedValueMap.get('OptionValue'));
        	filterFieldToSearchedValueMap.remove('OptionValue');
        	
        }
        
        //system.assert(false,' Final  Map  ' + filterFieldToSearchedValueMap);
        return filterFieldToSearchedValueMap;
    }
    
    /**
     * Name: getReveresedSortList
     * Desc: Method to get reverse sort list 
     * @param: listToRev - List<String> - List that is to be reversed 
     * @return: List<String> - reversed list                              
    **/
    public static List<String> getReveresedSortList(List<String> listToRev){
    	listToRev.sort();
    	List<String> reversedList = new List<String>(listToRev);
		listToRev.clear();
		while(reversedList.size() != 0){
			listToRev.add(reversedList[reversedList.size() - 1]);
			reversedList.remove(reversedList.size() - 1);
		}
		return listToRev;
    }
    
    /**
     * Name: getOrderByQueryBySortMap
     * Desc: Method to get Order by query for particular object
     * @param:  (1) objectName - String - Object Name
     			(2) orderByFieldsMap - List<Utility.SortByMapping> - List of objects used as JSON
     * @return: String - query String                             
    **/
    public static String getOrderByQueryBySortMap(String objectName, List<Utility.SortByMapping> orderByFieldsMap){
    	orderByFieldsMap = (orderByFieldsMap == null) ? new List<Utility.SortByMapping>() : orderByFieldsMap;
    	String orderByQuery = '';
		for(Utility.SortByMapping sortField : orderByFieldsMap){
			if(sortField.fieldName != null && JSONService.searchableObjectJSONToFieldKeyMap.get(objectName).containsKey(sortField.fieldName)){
				orderByQuery += ' ' + JSONService.searchableObjectJSONToFieldKeyMap.get(objectName).get(sortField.fieldName) + ' ' + sortField.direction + ',';
			}
		}
		if( orderByQuery.length() != 0 ){
			orderByQuery = ' ORDER BY ' + orderByQuery;
			orderByQuery = orderByQuery.substring(0, orderByQuery.length() - 1);
		}
		return orderByQuery;
    }
    
    /**
     * Name: parsePageAndSortFilters
     * Desc: create map from given JSON 
     * @param: JSONString - String - JSON String to be parsed
     * @return: Map<String, String> - filter field name to searched keyword                              
    **/
    public static PageAndSortFilter parsePageAndSortFilters(String JSONString) {
        PageAndSortFilter pageAndSortMapping;
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
        	if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
        		while (parser.nextToken() != null) {
        			if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
        				pageAndSortMapping = (PageAndSortFilter)parser.readValueAs(PageAndSortFilter.class);
        			}
        		}
        	}
        }
        return pageAndSortMapping;
    }
    
    public static List<String> prepareSortMap(String objectTypeSortDirection, Boolean isAnyFilterPresent){
    	List<Utility.SortByMapping> newSortCriteria = new List<Utility.SortByMapping>();
    	for(Utility.SortByMapping sortCriteria : sortMapping){
    		if(sortCriteria.fieldName == 'T'){
    			objectTypeSortDirection = sortCriteria.direction;
    		} else if( sortCriteria.fieldName != null ){
    			isAnyFilterPresent = true;
    			newSortCriteria.add(sortCriteria);
    		}
    	}
    	sortMapping = newSortCriteria;
    	
    	List<String> sortAttrs = new List<String>{objectTypeSortDirection, String.valueOf(isAnyFilterPresent)};
    	return sortAttrs;
    }
    
    /**
     * Name: PageAndSortFilter Class
     * Desc: Class used for JSON objects
    **/
    public class PageAndSortFilter {
    	public Integer PageSize {get{
										if(PageSize == null){
											PageSize = Constants.searchPageGridSize;
										}
										return PageSize;
									} set; }
									
    	public Integer PageNumber {get{
										if(PageNumber == null){
											PageNumber = 1;
										}
										return PageNumber;
									} set;}
									
    	public String SearchText {get{
    									if(SearchText == null){
    										SearchText = '';
    									}
    									return SearchText;
    								} set;}
    								
    	public List<SortByMapping> SortBy {get; set;}
    }
    
    /**
     * Name: SortByMapping Class
     * Desc: Class used for JSON objects in sorting
    **/
    public class SortByMapping {
    	public String fieldName {get; set;}
    	public String direction {get; set;}
    	
    	public SortByMapping(String fieldName, String direction){
    		this.fieldName = fieldName;
    		this.direction = direction;
    	}
    }
}