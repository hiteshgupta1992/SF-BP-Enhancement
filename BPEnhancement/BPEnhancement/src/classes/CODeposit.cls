/**
 * Author: Tarun Khandelwal
 * Since: April 22, 2014
 * Name: CODeposit
 * Description: Used to convert CODeposit JSON serialize and deserialize operations
**/
public with sharing class CODeposit {
    
     // Deposit Name
    public String DepositName{get; set;}
    
    // COHeader Id
    public String COHeaderId{get; set;}
    
    // Assignee
    public String PaymentMethod{get; set;}
    
    // Assignee Name
    public Decimal Amount{get; set;}
    
    // Created Date
    public String CreatedDate {get; set;}
    
    // CO Deposit Id
    public String CODepositId {get; set;}
    
    // CO invoice Number
    public String COInvoiceNumber {get; set;}
    
    // Constructor
    public CODeposit(CO_Deposit__c coDepositObj) {
        this.DepositName = coDepositObj.Name;
        this.COHeaderId = coDepositObj.CO_Header__c;
        this.PaymentMethod = coDepositObj.Payment_Method__c;
        this.Amount = (coDepositObj.Amount__c != null) ? coDepositObj.Amount__c.setScale(2) : 0.00;
        if(coDepositObj.Id != null) {
            this.CODepositId = coDepositObj.Id;
            this.CreatedDate = String.valueOf(DateTime.valueOf(coDepositObj.CreatedDate).format('dd/MMM/yyyy')); 
        } else {
            this.CreatedDate = '';
        }
        if(coDepositObj.CO_Invoice_Header__c != null) {
        	this.COInvoiceNumber = coDepositObj.CO_Invoice_Header__r.Name;
        } else {
        	this.COInvoiceNumber = '';
        }
    }     
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: CODeposit - Class Object
    **/
      public static List<CODeposit> parse(String json) {
        return (List<CODeposit>) System.JSON.deserialize(json, List<CODeposit>.class);
      }
  
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> CODepositFields = new List<String>{ 'Id',
                            'Name', 
                            'CO_Header__c',
                            'Amount__c',
                            'Payment_Method__c',
                            'CreatedDate',
                            'CO_Invoice_Header__c',
                            'CO_Invoice_Header__r.Name'
                           };
        return CODepositFields;
    }
}