/**
 * Author: Tarun Khandelwal
 * Since: May 20, 2015
 * Name: CustomerOwnedUnit
 * Description: Apex class to handle JSON related oprations of Customer Owned Unit object.
**/
public with sharing class CustomerOwnedUnit {
	
	// VIN Number
    public String VIN;
    
    // Year
    public Decimal Year;
    
    // Make
    public String Make;
    
    // Make
    public String MakeName;
    
    // Model
    public String ModelName;
    
    // Model
    public String Model;
    
    // Sub-Model
    public String SubModel;
    
    // Sub-Model Name
    public String SubModelName;
    
    // Parent model make name
    public String ModelMakeName;
    
    // License Plate
    public String Plate;
    
    // Mileage
    public Decimal Mileage;
    
    // Color
    public String Color;
    
    // Id
    public String Id;
    
    public String Name;
    
    // Constructor
    public CustomerOwnedUnit(Customer_Owned_Unit__c coUnitRec) {
    	this.VIN = coUnitRec.VIN__c;
    	this.Year = coUnitRec.Year__c;
    	this.Make = coUnitRec.Unit_Make__c;
    	this.MakeName = coUnitRec.Unit_Make__r.Name;
    	this.Name = coUnitRec.Name;
    	
    	if(coUnitRec.Unit_Model__c != null) {
    		this.Model = coUnitRec.Unit_Model__c;
    		this.ModelName = coUnitRec.Unit_Model__r.Name__c;
    		this.SubModel = coUnitRec.Unit_Model__c;
    		this.SubModelName = coUnitRec.Unit_Model__r.Sub_Model__c;
    		this.ModelMakeName = coUnitRec.Unit_Model__r.Unit_Make__r.Name;
    	} else {
    		this.Model = '';
    		this.ModelName = '';
    		this.SubModel = '';
    	}
    	this.Plate = coUnitRec.Plate__c;
    	this.Mileage = coUnitRec.Mileage__c;
    	this.Color = coUnitRec.Colour__c;
    	this.Id = coUnitRec.Id;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static List<CustomerOwnedUnit> parse(String json) {
        return (List<CustomerOwnedUnit>) System.JSON.deserialize(json, List<CustomerOwnedUnit>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> COUFields = new List<String>{ 'Id',
                                                    'Name', 
                                                    'VIN__c',
                                                    'Account__c',
                                                    'Colour__c',
                                                    'Mileage__c',
                                                    'Plate__c',
                                                    'Submodel__c',
                                                    'Unit_Make__c',
                                                    'Unit_Make__r.Name',
                                                    'Unit_Model__c',
                                                    'Unit_Model__r.Name__c',
                                                    'Unit_Model__r.Sub_Model__c',
                                                    'Unit_Model__r.Unit_Make__r.Name',
                                                    'Year__c'
                                                };
        return COUFields;
    }
}