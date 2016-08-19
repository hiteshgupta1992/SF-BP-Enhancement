/**
 * Author: Tarun Khandelwal
 * Since: May 8, 2015
 * Name: InvoiceHistory
 * Description: Apex class to handle JSON related oprations of Invoice History.
**/
public with sharing class InvoiceHistory {
	
	// Invoice Header Number
	public String InvoiceNumber {get; set;}
	
	// Closed Invoice Date
	public String ClosedInvoiceDate {get; set;}
	
	// Number Of CO Invoice Items
	public Decimal NumberOfItems {get; set;}
	
	// SubTotal (Without Tax)
	public Decimal SubTotal {get; set;}
	
	// Tax Included
	public Decimal Tax {get; set;}
	
	// Total
	public Decimal Total {get; set;}
	
	// Invoice id
	public String COInvoiceHeaderId {get; set;}
	
	public String CheckoutType;
	
	// Constructor
    public InvoiceHistory(CO_Invoice_Header__c  coInvoiceHeaderRec) {
    	this.InvoiceNumber = coInvoiceHeaderRec !=null ? coInvoiceHeaderRec.Invoice_Number__c : '';	
    	this.ClosedInvoiceDate = String.valueOf(Date.valueOf(coInvoiceHeaderRec.Invoice_Date__c).format());
    	
    	Decimal noOfItems = 0;
    	Decimal totalPrice = 0;
    	Decimal totalTax = 0;
    	Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
     	
     	// Calculation on CO Invoice Items
     	for(CO_Invoice_Item__c coInvoiceItemRec : coInvoiceHeaderRec.CO_Invoice_Items__r) {
    		noOfItems += 1;
    		if(coInvoiceItemRec.CO_Line_Item__c != null) {
    			if(coInvoiceItemRec.CO_Line_Item__r.Tax__c == null) {
    				coInvoiceItemRec.CO_Line_Item__r.Tax__c = 0;
    			}
	    		totalPrice += coInvoiceItemRec.CO_Line_Item__r.Qty__c * coInvoiceItemRec.CO_Line_Item__r.Price__c;
	    		totalTax += coInvoiceItemRec.CO_Line_Item__r.Qty__c * coInvoiceItemRec.CO_Line_Item__r.Price__c * (coInvoiceItemRec.CO_Line_Item__r.Tax__c / 100);
    		
    		} else if(coInvoiceItemRec.Service_Order_Header__c != null) {
    			if(coInvoiceItemRec.Service_Order_Header__r.Transaction_Type__c != null && coInvoiceItemRec.Service_Order_Header__r.Transaction_Type__r.Type__c == 'Third-Party') {
					totalPrice += (coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c : 0;
					totalTax += (coInvoiceItemRec.SO_Payment_Role__r.Tax_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Tax_Amount__c : 0;
    			} else {
    				totalPrice += (coInvoiceItemRec.Service_Order_Header__r.Total__c != null) ? coInvoiceItemRec.Service_Order_Header__r.Total__c : 0;
    				totalTax += (coInvoiceItemRec.Service_Order_Header__r.Tax_Amount__c != null) ? coInvoiceItemRec.Service_Order_Header__r.Tax_Amount__c : 0;
    			}
    		} else if(coInvoiceItemRec.CO_Kit_Header__c != null) {
	    		totalPrice += coInvoiceItemRec.CO_Kit_Header__r.Price__c;
	    		totalTax += coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c;
    		}
    	} 
    	
    	this.NumberOfItems = noOfItems;
    	
    	if(!isTaxIncludingPricing) {
	    	this.SubTotal = totalPrice.setScale(2);
	    	this.Tax = totalTax.setScale(2);
	    	this.Total = this.SubTotal + this.Tax; 
    	} else {
    		this.Tax = totalTax.setScale(2);
    		this.SubTotal = totalPrice.setScale(2) + this.Tax;
    		this.Total = this.SubTotal;
    	}
    	this.COInvoiceHeaderId = coInvoiceHeaderRec.Id;
    	this.CheckoutType = coInvoiceHeaderRec.Checkout_Type__c;
    } 
    
    /**
     * Name: coInvoiceHeaderFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> coInvoiceHeaderFieldsList(){
        List<String> COInvoiceHeaderFields = new List<String>{ 'Id',
                                                        	'Name', 
                                                        	'CO_Header__c',
                                                        	'Invoice_Date__c',
                                                        	'Invoice_Status__c',
                                                        	'Checkout_Type__c',
                                                        	'Invoice_Number__c'
                                               			 };
        return COInvoiceHeaderFields;
    }
    
    /**
     * Name: coInvoiceItemsFieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> coInvoiceItemsFieldsList(){
        List<String> COInvoiceHeaderFields = new List<String>{ 'Id',
                                                        	'Name', 
                                                        	'CO_Line_Item__r.Tax__c',
                                                        	'CO_Line_Item__r.Price__c',
                                                        	'CO_Line_Item__r.Qty__c',
                                                        	'Service_Order_Header__c',
                                                        	'Service_Order_Header__r.Total__c',
                                                        	'Service_Order_Header__r.Tax_Amount__c',
                                                        	'CO_Kit_Header__c',
                                                        	'CO_Kit_Header__r.Price__c',
                                                        	'CO_Kit_Header__r.Tax_Amount__c',
                                                        	'SO_Payment_Role__r.Total_Amount__c',
                                                        	'SO_Payment_Role__r.Tax_Amount__c',
                                                        	'Service_Order_Header__r.Transaction_Type__r.Type__c',
                                                        	'Service_Order_Header__r.Transaction_Type__c'
                                               			 };
        return COInvoiceHeaderFields;
    }
}