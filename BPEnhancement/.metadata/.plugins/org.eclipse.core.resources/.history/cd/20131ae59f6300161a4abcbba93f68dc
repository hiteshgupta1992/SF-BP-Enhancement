/**
 * Author: Tarun Khandelwal
 * Since: June 9, 2015
 * Name: CustomerContact
 * Description: Apex class to handle JSON related oprations of Related Customer entity.
**/
public with sharing class CustomerContact {
	
	// Contact First Name
	public String FirstName;
	
	// Contact Last Name
	public String LastName;
	
    // Email Address
    public String Email;
    
    // Phone Number
    public String Phone;
    
    // Preferred Email
    public Boolean PreferredEmail;
    
    // Preferred Phone
    public Boolean PreferredPhone;
    
    // Preferred Phone
    public Boolean PreferredSMS;
    
    // Preferred Phone
    public Boolean IsSMS;
    
    // Job title
    public String JobTitle;
    
    // Relationship type
    public String Relation;
    
    // Parent Customer
    public String ParentCustomer;
    
    // Id
    public String Id;
    
    // Constructor
    public CustomerContact(Contact customerContactRec) {
    	this.FirstName = customerContactRec.FirstName;
    	this.LastName = customerContactRec.LastName;
    	this.Email = (customerContactRec.Work_Email__c == null) ? '' : customerContactRec.Work_Email__c;
    	this.Phone = (customerContactRec.Phone == null ) ? '' : customerContactRec.Phone;
    	this.PreferredPhone = (customerContactRec.Preferred_Phone__c == null) ? false : customerContactRec.Preferred_Phone__c;
    	this.PreferredEmail = (customerContactRec.Preferred_Email__c == null) ? false : customerContactRec.Preferred_Email__c;
    	this.PreferredSMS = (customerContactRec.Preferred_SMS__c == null) ? false : customerContactRec.Preferred_SMS__c;
    	this.IsSMS = (customerContactRec.Is_SMS__c == null) ? false : customerContactRec.Is_SMS__c;
    	this.JobTitle = (customerContactRec.Job_Title__c == null) ? '' : customerContactRec.Job_Title__c;
    	this.Relation = (customerContactRec.Relationship__c == null) ? '' : customerContactRec.Relationship__c;
    	this.ParentCustomer = customerContactRec.AccountId;
    	this.Id = customerContactRec.Id;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static List<CustomerContact> parse(String JSONString) {
        return (List<CustomerContact>) System.JSON.deserialize(JSONString, List<CustomerContact>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> customerContactFields = new List<String>{ 'Id',
		                                                        'FirstName',
		                                                        'LastName',
		                                                        'Work_Email__c',
		                                                        'Phone',
		                                                        'Preferred_Email__c',
		                                                        'Preferred_Phone__c',
		                                                        'Preferred_SMS__c',
		                                                        'Is_SMS__c',
		                                                        'Job_Title__c',
		                                                        'Relationship__c',
		                                                        'Extension__c',
		                                                        'AccountId'
		                                                };
        return customerContactFields;
    }
}