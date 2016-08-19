/**
 * Author: Tarun Khandelwal
 * Since: Feb. 09, 2015
 * Name: JSONService
 * Description: Apex class which is used for JSON related operations.
**/
public with sharing class JSONService {
    // A Map of Objects to associated JSON key to be used in grids
    public static Map<String, Map<String, String>> searchableObjectToJSONKeyMap = new Map<String, Map<String, String>>{
                                                                        'Customer' => new Map<String, String>{'Id' => 'Id', 'Name' => 'Key', 'Is_Customer__c' => 'IsCustomer', 'Is_Vendor__c' => 'IsVendor', 'Active__c' => 'Status' ,'Description' => 'Summary', 'Owner.Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'Account' => new Map<String, String>{'Id' => 'Id', 'Name' => 'Key', 'Is_Customer__c' => 'IsCustomer', 'Is_Vendor__c' => 'IsVendor', 'Active__c' => 'Status' ,'Description' => 'Summary', 'Owner.Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'Vendor' => new Map<String, String>{'Id' => 'Id', 'Name' => 'Key', 'Is_Customer__c' => 'IsCustomer', 'Is_Vendor__c' => 'IsVendor', 'Active__c' => 'Status' ,'Description' => 'Summary', 'Owner.Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'Contact' => new Map<String, String>{'Id' => 'Id', 'Name' => 'Key', 'Active__c' => 'Status' ,'Description' => 'Summary', 'Owner.Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'Part__c' => new Map<String, String>{'Id' => 'Id', 'Part_ID__c' => 'Key', 'Active__c' => 'Status' , 'Description__c' => 'Summary', 'Vendor__r.Owner.Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'User' => new Map<String, String>{'Id' => 'Id', 'UserName' => 'Key', 'IsActive' => 'Status' , 'Title' => 'Summary', 'Name' => 'Assignee', 'LastModifiedDate' => 'Last_Edited', 'CreatedDate' => 'Date_Created'},
                                                                        'Category__c' => new Map<String, String>{'Id' => 'Id', 'Name' => 'Key', 'Active__c' => 'Status' ,'LastModifiedDate' => 'Last_Edited', 'Owner.Name' => 'Assignee', 'CreatedDate' => 'Date_Created'},
                                                                        'Labour_Code__c' => new Map<String, String>{'Id' => 'Id', 'Name__c' => 'Key', 'Active__c' => 'Status' ,'LastModifiedDate' => 'Last_Edited', 'Owner.Name' => 'Assignee', 'CreatedDate' => 'Date_Created'},
                                                                        'Kit_Header__c' => new Map<String, String>{'Id' => 'Id', 'Kit_Unique_Name__c' => 'Key', 'Active__c' => 'Status' ,'LastModifiedDate' => 'Last_Edited', 'Owner.Name' => 'Assignee', 'CreatedDate' => 'Date_Created'},
                                                                        'Fee__c' => new Map<String, String>{'Id' => 'Id', 'Fee_Unique_Name__c' => 'Key', 'Active__c' => 'Status' ,'LastModifiedDate' => 'Last_Edited', 'Owner.Name' => 'Assignee', 'CreatedDate' => 'Date_Created'} };
    
    // A Map of Objects to associated JSON key to be used in grids
    public static Map<String, Map<String, String>> searchableObjectJSONToFieldKeyMap = new Map<String, Map<String, String>>{
                                                                        'Customer' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name', 'IsCustomer' => 'Is_Customer__c', 'IsVendor' => 'Is_Vendor__c', 'Status' => 'Active__c' ,'Summary' => 'Description', 'Assignee' => 'Owner.Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'Account' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name', 'IsCustomer' => 'Is_Customer__c', 'IsVendor' => 'Is_Vendor__c', 'Status' => 'Active__c' ,'Summary' => 'Description', 'Assignee' => 'Owner.Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'Vendor' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name', 'IsCustomer' => 'Is_Customer__c', 'IsVendor' => 'Is_Vendor__c', 'Status' => 'Active__c' ,'Summary' => 'Description', 'Assignee' => 'Owner.Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'Contact' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name', 'Status' => 'Active__c' ,'Summary' => 'Description', 'Assignee' => 'Owner.Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'Part__c' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Part_ID__c', 'Status' => 'Active__c' , 'Summary' => 'Description__c', 'Assignee' => 'Vendor__r.Owner.Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'User' => new Map<String, String>{'Id' => 'Id', 'Key' => 'UserName', 'Status' => 'IsActive' , 'Summary' => 'Title', 'Assignee' => 'Name', 'Last_Edited' => 'LastModifiedDate', 'Date_Created' => 'CreatedDate'},
                                                                        'Category__c' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name', 'Status' => 'Active__c' ,'Last_Edited' => 'LastModifiedDate', 'Assignee' => 'Owner.Name', 'Date_Created' => 'CreatedDate'},
                                                                        'Labour_Code__c' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Name__c', 'Status' => 'Active__c' ,'Last_Edited' => 'LastModifiedDate', 'Assignee' => 'Owner.Name', 'Date_Created' => 'CreatedDate'},
                                                                        'Kit_Header__c' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Kit_Unique_Name__c', 'Status' => 'Active__c' ,'Last_Edited' => 'LastModifiedDate', 'Assignee' => 'Owner.Name', 'Date_Created' => 'CreatedDate'},
                                                                        'Fee__c' => new Map<String, String>{'Id' => 'Id', 'Key' => 'Fee_Unique_Name__c', 'Status' => 'Active__c' ,'Last_Edited' => 'LastModifiedDate', 'Assignee' => 'Owner.Name', 'Date_Created' => 'CreatedDate'}  };
    
    // A Map of Objects to associated ICON to be used in grids
    public static Map<String, Integer> searchableObjectToIconKey = new Map<String, Integer>{
                                                                        'Vendor' => 1,
                                                                        'Customer' => 0,
                                                                        'Account' => 0,
                                                                        'Contact' => 1,
                                                                        'Category__c' => 1,
                                                                        'User' => 1,
                                                                        'Part__c' => 2,
                                                                        'Labour_Code__c' => 3,
                                                                        'Kit_Header__c' => 4,
                                                                        'Fee__c' => 5};
    
    /**
     * Name: getJSONForRecordsList
     * Desc: Method which gives JSON String by Rocord list
     * @param:  (1) searchResultList - List<SObject> - List of reocrds 
     			(2) totalRecordsFound - Integer - Number of records found
     * @return: String - JSON String related to given records
    **/                                                                    
    public static String getJSONForRecordsList(List<SObject> searchResultList, Integer totalRecordsFound) {
        /*JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
		
		system.assert(false, searchResultList);
        // If total records count found, then add it in JSON
        if(totalRecordsFound != null){
        	gen.writeNumberField('Total_Records', totalRecordsFound);
        }
        
        gen.writeFieldName('Records');
        gen.writeStartArray();
        for(SObject sObj : searchResultList ) {
            gen.writeStartObject();
            String objName = String.valueOf(sobj.getSObjectType());
            gen.writeNumberField('T', searchableObjectToIconKey.get(objName));
            for(String objFieldName : Constants.searchableObjectToFieldsMap.get(objName) ) {
                if(objFieldName == 'Owner.Name' && searchableObjectToJSONKeyMap.get(objName).containsKey(objFieldName)) {
                    gen.writeStringField(searchableObjectToJSONKeyMap.get(objName).get(objFieldName), (String)sObj.getSobject('Owner').get('Name'));
                } else if(objFieldName.contains('Owner.Name') && searchableObjectToJSONKeyMap.get(objName).containsKey(objFieldName)) {
                    String parentObjectName = objFieldName.substringBefore('.');
                    gen.writeStringField(searchableObjectToJSONKeyMap.get(objName).get(objFieldName), (String)sObj.getSobject(parentObjectName).getSobject('Owner').get('Name'));
                } else if(objFieldName != 'Owner.name' && sObj.get(objFieldName) != null) {
                    gen.writeStringField(searchableObjectToJSONKeyMap.get(objName).get(objFieldName), String.valueOf(sObj.get(objFieldName)) );
                } 
            }
            gen.writeEndObject();               
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        return gen.getAsString();*/
        FilterResult filterResultObj = new FilterResult(searchResultList, totalRecordsFound);
        return System.JSON.serialize(filterResultObj);
    }
    
    
    public class FilterResult {
    	
    	public Integer Total_Records;
    	public List<FilterRecordData> Records;
    	
    	public FilterResult(List<SObject> searchResultList, Integer totalRecordsFound) {
    		this.Total_Records = totalRecordsFound;
    		this.Records = new List<FilterRecordData>();
    		for(Sobject sobj : searchResultList) {
    			this.Records.add(new FilterRecordData(sobj));
    		}
    	}
    }
    
    public class FilterRecordData {
    	public String Assignee;
    	public String Id;
    	public String Key;
    	public String Date_Created;
    	public String Last_Edited;
    	public String Status;
    	public String Summary;
    	public String IsCustomer;
    	public String IsVendor;
    	public Integer T;
    	
    	public FilterRecordData(Sobject sobj) {
    		String objName = String.valueOf(sobj.getSObjectType());
    		this.T = searchableObjectToIconKey.get(objName);
    		this.Id = String.valueOf(sobj.get('Id'));
    		this.Date_Created = String.valueOf(sobj.get('CreatedDate')); 
    		this.Last_Edited = String.valueOf(sobj.get('LastModifiedDate')); 
    		
    		if(sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Key')) != null) {
    			this.Key = String.valueOf(sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Key')));
    		} 
    		if(sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Status')) != null) {
    			this.Status = String.valueOf(sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Status')));
    		}
    		if(searchableObjectJSONToFieldKeyMap.get(objName).containsKey('Summary') && sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Summary')) != null) {
    			this.Summary = String.valueOf(sobj.get(searchableObjectJSONToFieldKeyMap.get(objName).get('Summary')));
    		}
    		if(objName == 'Part__c') {
    			this.Assignee = (String) sObj.getSobject('Vendor__r').getSobject('Owner').get('Name');
    		} else {
    			this.Assignee = String.valueOf(sObj.getSobject('Owner').get('Name'));
    		}
    		
    		if(objName == 'Account') {
    			this.IsCustomer = String.valueOf(sobj.get('Is_Customer__c')); 
    			this.IsVendor = String.valueOf(sobj.get('Is_Vendor__c')); 
    		}
    	}
    }
}