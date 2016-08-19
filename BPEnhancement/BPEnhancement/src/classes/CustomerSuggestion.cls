/**
 * Author: Tarun Khandelwal
 * Since: May 21, 2015
 * Name: CustomerSuggestion
 * Description: Apex class to handle JSON related oprations of suggestion of Customer records.
**/
global with sharing class CustomerSuggestion implements Comparable {

	// Customer Name
    public String CustomerName;
    
    // Customer First Name
    public String FirstName;
    
    // Customer Last Name
    public String LastName; 
    
    // Type__c
    public String Type;
    
    // Billing Address Fields
    public String BillingStreet1;
    
    // Home Eamil Address
    public String HomeEmail;
    
    // Home Number
    public String HomeNumber;
    
    // Priority Number
    public Integer PriorityValue;
    
    // Id
    public String Id;
    
    // Constructor
    public CustomerSuggestion(Account customerRec, Integer priorityNumber) { 
    	this.CustomerName = customerRec.Name;
    	this.FirstName = customerRec.FirstName__c;
    	this.LastName = customerRec.LastName__c;
    	this.HomeEmail = (customerRec.Email__c == null) ? '' : customerRec.Email__c;
    	this.HomeNumber = (customerRec.Home_Number__c == null ) ? '' : customerRec.Home_Number__c;
    	this.Type = customerRec.Type__c;
    	this.PriorityValue = priorityNumber;
    	this.Id = customerRec.Id;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static CustomerSuggestion parse(String json) {
        return (CustomerSuggestion) System.JSON.deserialize(json, CustomerSuggestion.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> customerSuggestionFields = new List<String>{ 'Id',
                                                        'Name',
                                                        'FirstName__c',
                                                        'LastName__c', 
                                                        'Facebook__c',
                                                        'Email__c',
                                                        'Home_Number__c',
                                                        'Is_Customer__c',
                                                        'LinkedIn__c',
                                                        'Mobile__c',
                                                        'Other_Email__c',
                                                        'Twitter__c',
                                                        'Work_Email__c',
                                                        'Work_Number__c',
                                                        'Type__c',
                                                        'BillingStreet'
                                                };
        return customerSuggestionFields;
    }
    
    
    global Integer compareTo(Object compareTo) {
    	CustomerSuggestion compareToWrapperObj = ((CustomerSuggestion)compareTo);
    	Integer returnValue = 0;
    	if (PriorityValue == compareToWrapperObj.PriorityValue) return 0;
        if (PriorityValue > compareToWrapperObj.PriorityValue) return 1;
        return -1; 
    }
}