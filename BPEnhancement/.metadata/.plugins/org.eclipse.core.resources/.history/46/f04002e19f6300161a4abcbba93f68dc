/**
 * Author: Tarun Khandelwal
 * Since: April 9, 2014
 * Name: COHeader
 * Description: Used to convert COHeader serialize and deserialize operations
**/
public with sharing class COHeader { 
    
    // Customer Id 
    public String CustomerId {get; set;}
    
    // Customer Name
    public String CustomerName {get; set;}
    
    // COHeader Id
    public String COHeaderId{get; set;}
    
    // Assignee
    public String Assignee{get; set;}
    
    // Assignee Name
    public String AssigneeName{get; set;}
    
    //Order Status
    public String OrderStatus{get; set;}
    
    // Owner
    public String Owner{get; set;}
    
    // Owner Name
    public String OwnerName{get; set;}
    
    // Order Name
    public String OrderName{get; set;}
    
    //Promised By
    public String PromisedBy;
    
    // Created Date
    public String CreatedDate;
    
    // Modified Date
    public String ModifiedDate;

    // Constructor
    public COHeader(CO_Header__c coHeaderObj) {
        this.CustomerId = coHeaderObj.Customer__c;
        this.CustomerName = coHeaderObj.Customer__r.Name;
        this.COHeaderId = coHeaderObj.Id;
        this.Assignee = coHeaderObj.Assignee__c;
        this.AssigneeName = coHeaderObj.Assignee__r.Name;
        this.OrderStatus = coHeaderObj.Order_status__c;
        this.Owner = coHeaderObj.Owner__c;
        this.OwnerName = coHeaderObj.Owner__r.Name;
        if(this.Owner == null) {
            this.Owner = '';
        }
        this.OrderName = coHeaderObj.Name;
        this.PromisedBy = (datetime.newInstance(coHeaderObj.CreatedDate.year(), coHeaderObj.CreatedDate.month(), coHeaderObj.CreatedDate.day() + 5)).format('MMMM dd, yyyy');
        this.CreatedDate = coHeaderObj.CreatedDate.format('MMMM dd, yyyy hh:mm a');
        this.ModifiedDate = coHeaderObj.LastModifiedDate.format('MMMM dd, yyyy hh:mm a');
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> COHeaderFieldList = new List<String>{ 'Id', 
                                                        'Customer__c',
                                                        'Assignee__c',
                                                        'Order_status__c',
                                                        'Owner__c',
                                                        'Customer__r.Name',
                                                        'Assignee__r.Name',
                                                        'Owner__r.Name',
                                                        'Name',
                                                        'CreatedDate',
                                                        'LastModifiedDate',
                                                        'Status__c',
                                                        'Total_Deposit__c',
                                                        'Total_Order_Value__c',
                                                        'Total_Payment__c'
                                                };
        return COHeaderFieldList;
    }
    
}