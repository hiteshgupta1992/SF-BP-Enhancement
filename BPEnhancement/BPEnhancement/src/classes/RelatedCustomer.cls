/**
 * Author: Tarun Khandelwal
 * Since: June 9, 2015
 * Name: RelatedCustomer
 * Description: Apex class to handle JSON related oprations of Related Customer entity.
**/
public with sharing class RelatedCustomer {
    
    // Customer Id
    public String Id;
    
    // Customer Number
    public String CustomerNumber;
    
    // Customer Name
    public String CustomerName;
    
    // Email Address
    public String Email;
    
    // Is Preferred Email
    public boolean IsPreferredEmail;
    
    // Phone Number
    public String PhoneNumber;
    
    // Is Preferred Phone
    public boolean IsPreferredPhone;
    
    // Relationship type
    public String Relation;
    
    // Parent Account
    public String ParentCustomer;
    
    // Constructor
    public RelatedCustomer(Account customerRec, Map<String, String> accountIdToRelationMap) {
        this.CustomerNumber = customerRec.Customer_Number__c;
        this.CustomerName = customerRec.Name ;
        
        // Set the email and IsPreferredEmail for customer
        if(customerRec.Preferred_Email__c == null || customerRec.Preferred_Email__c == ''){
            IsPreferredEmail = false;
            
            // Set order for Individual and business Customers
            if(customerRec.Type__c == 'Individual'){
                Email = (customerRec.Email__c != null) 
                            ? customerRec.Email__c 
                            : ((customerRec.Other_Email__c != null) 
                                ? customerRec.Other_Email__c
                                : ((customerRec.Work_Email__c != null) 
                                    ? customerRec.Work_Email__c
                                    : '')
                                );
            } else if(customerRec.Type__c == 'Business'){
                Email = (customerRec.Work_Email__c != null) 
                            ? customerRec.Work_Email__c 
                            : ((customerRec.Other_Email__c != null) 
                                ? customerRec.Other_Email__c
                                : ((customerRec.Email__c != null) 
                                    ? customerRec.Email__c
                                    : '')
                                );
            }
        } else {
            IsPreferredEmail = true;
            Email = customerRec.Preferred_Email__c;
        }
        
        // Set the phone number and IsPreferredPhone for customer
        if(customerRec.Preferred_Phone__c == null || customerRec.Preferred_Phone__c == ''){
            IsPreferredPhone = false;
            
            // Set order for Individual and business Customers
            if(customerRec.Type__c == 'Individual'){
                PhoneNumber = (customerRec.Home_Number__c != null) 
                            ? customerRec.Home_Number__c 
                            : ((customerRec.Mobile__c != null) 
                                ? customerRec.Mobile__c
                                : ((customerRec.Work_Number__c != null) 
                                    ? customerRec.Work_Number__c
                                    : '')
                                );
            } else if(customerRec.Type__c == 'Business'){
                PhoneNumber = (customerRec.Work_Number__c != null) 
                            ? customerRec.Work_Number__c 
                            : ((customerRec.Mobile__c != null) 
                                ? customerRec.Mobile__c
                                : ((customerRec.Home_Number__c != null) 
                                    ? customerRec.Home_Number__c
                                    : '')
                                );
            }
        } else {
            IsPreferredPhone = true;
            PhoneNumber = customerRec.Preferred_Phone__c;
        }
        if(accountIdToRelationMap.containsKey(customerRec.Id)) {
            this.Relation = accountIdToRelationMap.get(customerRec.Id); 
        } else {
            this.Relation = '';
        }
        this.ParentCustomer = customerRec.ParentId;
        this.Id = customerRec.Id;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static List<RelatedCustomer> parse(String JSONString) {
        return (List<RelatedCustomer>) System.JSON.deserialize(JSONString, List<RelatedCustomer>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> relatedCustomerFields = new List<String>{ 'Id',
                                                                'Name',
                                                                'Customer_Number__c',
                                                                'Email__c',
                                                                'Home_Number__c',
                                                                'Mobile__c',
                                                                'Other_Email__c',
                                                                'Preferred_Email__c',
                                                                'Preferred_Phone__c',
                                                                'Work_Email__c',
                                                                'Work_Number__c',
                                                                'Relationship__c',
                                                                'ParentId',
                                                                'Is_Customer__c',
                                                                'Is_Vendor__c',
                                                                'Type__c'
                                                        };
        return relatedCustomerFields;
    }
}