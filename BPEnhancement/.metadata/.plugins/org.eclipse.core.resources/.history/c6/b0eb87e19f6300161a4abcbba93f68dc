/**
 * Author: Tarun Khandelwal
 * Since: April 30, 2015
 * Name: COInvoiceItem
 * Description: Apex class to handle JSON related oprations of CO Invoice Header object.
**/
public with sharing class COInvoiceItem {
    
    // CO Line Item Key ( Part Name + Part_Id)
    public String Item {get; set;}
    
    // CO Line Item Qty Committed 
    public Decimal Qty {get; set;}
        
    // CO Line Item Id
    public String COLineItemId {get; set;}
    
    // CO Line Item Price
    public Decimal Price {get; set;}
    
    //CO Line Item Total
    public Decimal Total {get; set;}
    
    // CO Invoice Header Id
    public String COInvoiceHeaderId {get; set;}
    
    // CO Invoice Item Id
    public String COInvoiceItemId {get; set;}
    
    // Active
    public Boolean IsActive {get; set;}
    
    // CO Invoice Item Number
    public String COInvoiceItemNumber {get; set;}
    
    // Tax
    public Decimal TaxAmount {get; set;}
    
    //Qty Required
    public Decimal QtyRequired {get; set;}
    
    // Retail Price
    public Decimal RetailPrice {get; set;}
    
    // Saving
    public Decimal Saving {get; set;}
    
    // Id
    public Boolean IsInvoiceable;
    public String SOStatus;
    public Boolean IsFinalizable;
    
    public String CheckoutType;
    public String ItemType;
    public Boolean isTaxIncludingPricing;
    
    // Constructor
    public COInvoiceItem(CO_Invoice_Item__c  coInvoiceItemRec) { 
    	this.TaxAmount = 0;
    	this.IsInvoiceable = false;
    	this.isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
    	if(coInvoiceItemRec.CO_Line_Item__c != null) {
    		this.Item = coInvoiceItemRec.CO_Line_Item__r.Item_ID__c;
	    	//this.Item = coInvoiceItemRec.CO_Line_Item__r.Part__r.Part_Number__c + ' - ' + coInvoiceItemRec.CO_Line_Item__r.Part__r.Description__c;
	    	this.Qty = coInvoiceItemRec.CO_Line_Item__r.Qty_Committed__c;
	    	this.COLineItemId = coInvoiceItemRec.CO_Line_Item__c;
	        this.Price = (coInvoiceItemRec.CO_Line_Item__r.Price__c != null) ? coInvoiceItemRec.CO_Line_Item__r.Price__c.setScale(2) : 0.00;
	        if(coInvoiceItemRec.CO_Line_Item__r.Price__c == null) {		
	            this.Price = 0;		
	        } else {		
	            if(!isTaxIncludingPricing) {		
	            	this.Price = coInvoiceItemRec.CO_Line_Item__r.Price__c.setScale(2);
	            	if(coInvoiceItemRec.CO_Line_Item__r.Tax__c == null) {
	            		coInvoiceItemRec.CO_Line_Item__r.Tax__c = 0;
	            	} 
	            	this.TaxAmount = ((this.Qty) * (this.Price) * (coInvoiceItemRec.CO_Line_Item__r.Tax__c / 100)).setScale(2);		
	            } else {		
	            	if(coInvoiceItemRec.CO_Line_Item__r.Tax__c == null) {
	            		coInvoiceItemRec.CO_Line_Item__r.Tax__c = 0;
	            	}
	            	this.Price = (coInvoiceItemRec.CO_Line_Item__r.Price__c * (1 + coInvoiceItemRec.CO_Line_Item__r.Tax__c /100)).setScale(2);	
	            	this.TaxAmount = ((this.Qty) * (coInvoiceItemRec.CO_Line_Item__r.Price__c) * (coInvoiceItemRec.CO_Line_Item__r.Tax__c / 100)).setScale(2);	
	            }		
	        }
	        if(coInvoiceItemRec.CO_Line_Item__r.Tax__c == null) {
	        	coInvoiceItemRec.CO_Line_Item__r.Tax__c = 0;
	        }
	        
	        this.Total = ((this.Qty) * (this.Price)).setScale(2);
	        this.isActive = coInvoiceItemRec.isActive__c;
	        this.COInvoiceItemNumber = coInvoiceItemRec.Name;
	        
	        this.QtyRequired = coInvoiceItemRec.CO_Line_Item__r.Qty__c;
	        this.RetailPrice = (coInvoiceItemRec.CO_Line_Item__r.Retail__c != null) ? coInvoiceItemRec.CO_Line_Item__r.Retail__c.setScale(2) : 0.00;
	        if(coInvoiceItemRec.CO_Line_Item__r.Retail__c == null) {
	        	coInvoiceItemRec.CO_Line_Item__r.Retail__c = 0.00;
	        } 
	        if(coInvoiceItemRec.CO_Line_Item__r.Price__c == null) {
	        	coInvoiceItemRec.CO_Line_Item__r.Price__c = 0.00;
	        }
	        this.Saving = (this.QtyRequired) * (coInvoiceItemRec.CO_Line_Item__r.Retail__c - coInvoiceItemRec.CO_Line_Item__r.Price__c);
	        
	        if(coInvoiceItemRec.CO_Line_Item__r.Qty_Committed__c > 0) {
	        	this.IsInvoiceable = true;
	        } else {
	        	this.IsInvoiceable = false;
	        }
	        
	        if(coInvoiceItemRec.CO_Line_Item__r.Qty__c == coInvoiceItemRec.CO_Line_Item__r.Qty_Committed__c && coInvoiceItemRec.isActive__c){
	       		this.IsFinalizable = true;
	        } else {
	        	this.IsFinalizable = false;
	        }
	        
	        if(coInvoiceItemRec.CO_Line_Item__r.Qty__c < 0) {
	        	this.Qty = coInvoiceItemRec.CO_Line_Item__r.Qty__c;
	        	this.Total = ((this.Qty) * (this.Price)).setScale(2);
	        	this.TaxAmount = ((this.Qty) * (this.Price) * (coInvoiceItemRec.CO_Line_Item__r.Tax__c / 100)).setScale(2);
	        	this.IsFinalizable = true;
	        	this.IsInvoiceable = true;
	        }
	        this.CheckoutType = Constants.CHECKOUT_TYPE_CUSTOMER;
	        
	        if(coInvoiceItemRec.CO_Line_Item__r.Part__c != null) {
	        	this.ItemType = Constants.PART_INVOICE_ITEM_TYPE;
	        } else if(coInvoiceItemRec.CO_Line_Item__r.Fee__c != null) {
	        	this.ItemType = Constants.PART_INVOICE_ITEM_TYPE;
	        }
	        
	        
    	} else if(coInvoiceItemRec.Service_Order_Header__c != null) {
    		if(coInvoiceItemRec.SO_Payment_Role__c != null && coInvoiceItemRec.Service_Order_Header__r.Transaction_Type__r.Type__c == 'Third-Party') {
    			populateSOPaymentRoleFields(coInvoiceItemRec);
    		} else {
    			if(coInvoiceItemRec.Service_Order_Header__r.Transaction_Type__r.Type__c == 'Internal') {
    				this.Item = coInvoiceItemRec.Service_Order_Header__r.Name__c + ' - INTERNAL - ' + coInvoiceItemRec.Service_Order_Header__r.Category__r.Name;
    				this.CheckoutType = Constants.CHECKOUT_TYPE_INTERNAL;
    			} else {
	    			this.Item = coInvoiceItemRec.Service_Order_Header__r.Name__c;
	    			this.CheckoutType = Constants.CHECKOUT_TYPE_CUSTOMER;
    			}
	    		this.isActive = coInvoiceItemRec.isActive__c;
	    		this.Total = coInvoiceItemRec.Service_Order_Header__r.Total__c;		
	    		this.TaxAmount = (coInvoiceItemRec.Service_Order_Header__r.Tax_Amount__c != null) ? coInvoiceItemRec.Service_Order_Header__r.Tax_Amount__c.setScale(2) : 0.00;
	    		if(isTaxIncludingPricing) {		
	    			if(this.Total == null) {		
	    				this.Total = 0;		
	    			}		
	    			if(this.TaxAmount == null) {		
	    				this.TaxAmount = 0;		
	    			}		
	    			this.Total = this.Total + this.TaxAmount;		
	    		}		
	    		this.Price = this.Total;
	    		if(coInvoiceItemRec.Service_Order_Header__r.Work_Status__c == 'Signed Out') {
	    			this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
	    		} else {
	    			this.isActive = false;
	    		}
	    		this.SOStatus = coInvoiceItemRec.Service_Order_Header__r.Status__c;
	    		
	    		if(coInvoiceItemRec.isActive__c &&  coInvoiceItemRec.Is_Invoiceable__c && (coInvoiceItemRec.Service_Order_Header__r.Status__c == 'Complete'|| coInvoiceItemRec.Service_Order_Header__r.Status__c == 'Reviewed')){
			 		this.IsFinalizable = true;
	    		} else {
					this.IsFinalizable = false;
	    		}
	    		this.ItemType = Constants.WORK_SERVICE_ORDER_INVOICE_ITEM_TYPE;
    		}
    		
    	} else if(coInvoiceItemRec.CO_Kit_Header__c != null){
    		if(coInvoiceItemRec.CO_Kit_Header__r.Kit_Header__c != null) {
    			this.Item = coInvoiceItemRec.CO_Kit_Header__r.Kit_Header__r.Kit_Unique_Name__c;
    		}
    		this.isActive = coInvoiceItemRec.isActive__c;
    		this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
    		if(!isTaxIncludingPricing) {
    			this.Total = (coInvoiceItemRec.CO_Kit_Header__r.Price__c != null) ? coInvoiceItemRec.CO_Kit_Header__r.Price__c.setScale(2) : 0.00;
    			this.TaxAmount = (coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c != null) ? coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c.setScale(2) : 0.00;
    		}else{
    				this.TaxAmount = (coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c != null) ? coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c.setScale(2) : 0.00;
    				this.Total = ((coInvoiceItemRec.CO_Kit_Header__r.Price__c != null) ? coInvoiceItemRec.CO_Kit_Header__r.Price__c.setScale(2) : 0.00) + ((coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c != null) ? coInvoiceItemRec.CO_Kit_Header__r.Tax_Amount__c.setScale(2) : 0.00);
    		}
    		if(coInvoiceItemRec.isActive__c && coInvoiceItemRec.Is_Invoiceable__c ){
    		 	this.IsFinalizable = true;
    		} else {  
    			this.IsFinalizable = false;
    		}
    		this.CheckoutType = Constants.CHECKOUT_TYPE_CUSTOMER;
    		this.ItemType = Constants.KIT_INVOICE_ITEM_TYPE;
    	}
    	this.COInvoiceHeaderId = coInvoiceItemRec.CO_Invoice_Header__c;
    	this.COInvoiceItemId = coInvoiceItemRec.Id;
    }
     
     
    public void populateSOPaymentRoleFields(CO_Invoice_Item__c  coInvoiceItemRec) {
    	if(coInvoiceItemRec.SO_Payment_Role__r.RecordType.DeveloperName == 'Deductible') {
    		if(coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c > 0) {
    			if(coInvoiceItemRec.SO_Payment_Role__r.Deductible_Status__c == 'Owing') {
    				this.Item = coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Name__c + ' - CLAIM - Deductible Adjustment';
    			} else {
    				this.Item = coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Name__c + ' - CLAIM - Deductible';
    			} 
    			this.isActive = coInvoiceItemRec.isActive__c;
	    		this.Total = (coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c.setScale(2) : 0.00;
	    		this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
	    		this.CheckoutType = Constants.CHECKOUT_TYPE_CUSTOMER;
    		}
    	}
    	
    	if(coInvoiceItemRec.SO_Payment_Role__r.RecordType.DeveloperName == 'Third_Party') {
    		if(coInvoiceItemRec.SO_Payment_Role__r.Claim__c != null && coInvoiceItemRec.SO_Payment_Role__r.Claim__r.Claim_Disposition__c != 'Denied') {
				this.Item = coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Name__c + ' - CLAIM - ' + coInvoiceItemRec.Service_Order_Header__r.Claim_Status__c + ' - ' + coInvoiceItemRec.Service_Order_Header__r.Provider__r.Name;
    			
    			this.isActive = coInvoiceItemRec.isActive__c;
	    		this.Total = (coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c.setScale(2) : 0.00;
	    		if(coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Work_Status__c == 'Signed Out') {
	    			this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
	    		} else {
	    			this.IsInvoiceable = false;
	    		}
	    		this.CheckoutType = Constants.CHECKOUT_TYPE_THIRD_PARTY;
    		}
    	}
    	
    	if(coInvoiceItemRec.SO_Payment_Role__r.RecordType.DeveloperName == 'Internal') {
    		if(coInvoiceItemRec.Service_Order_Header__r != null) {
				this.Item = coInvoiceItemRec.Service_Order_Header__r.Name__c + ' - CLAIM VARIANCE ' + ((coInvoiceItemRec.SO_Payment_Role__r.Category__c != null) ? (' - ' + coInvoiceItemRec.SO_Payment_Role__r.Category__r.Name) : '');
    			this.isActive = coInvoiceItemRec.isActive__c;
	    		this.Total = (coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c.setScale(2) : 0.00;
	    		if(coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Work_Status__c == 'Signed Out' && coInvoiceItemRec.SO_Payment_Role__r.Claim__r.Claim_Disposition__c != 'Denied') {
	    			this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
	    		} else {
	    			this.IsInvoiceable = false;
	    		}
	    		this.CheckoutType = Constants.CHECKOUT_TYPE_INTERNAL;
    		}
    	}
    	
    	if(coInvoiceItemRec.SO_Payment_Role__r.RecordType.DeveloperName == 'Customer') {
    		if(coInvoiceItemRec.Service_Order_Header__r != null) {
				this.Item = coInvoiceItemRec.Service_Order_Header__r.Name__c + ' - CLAIM VARIANCE -  [item/desc from the claim]';
    			this.isActive = coInvoiceItemRec.isActive__c;
    			this.Qty = coInvoiceItemRec.SO_Payment_Role__r.Qty__c;
	    		this.Total = (coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c != null) ? coInvoiceItemRec.SO_Payment_Role__r.Total_Amount__c.setScale(2) : 0.00;
	    		if(coInvoiceItemRec.SO_Payment_Role__r.Service_Order_Header__r.Work_Status__c == 'Signed Out' && coInvoiceItemRec.SO_Payment_Role__r.Claim__r.Claim_Disposition__c != 'Denied') {
	    			this.IsInvoiceable = coInvoiceItemRec.Is_Invoiceable__c;
	    		} else {
	    			this.IsInvoiceable = false;
	    		}
	    		this.CheckoutType = Constants.CHECKOUT_TYPE_CUSTOMER;
    		}
    	}
    	if(this.IsInvoiceable && this.isActive) {
    		this.IsFinalizable = true;
    	} else {
    		this.IsFinalizable = false;
    	}
    	
    	this.TaxAmount = (coInvoiceItemRec.SO_Payment_Role__r.Tax_Amount__c == null) ? 0 : coInvoiceItemRec.SO_Payment_Role__r.Tax_Amount__c;
    	if(this.isTaxIncludingPricing) {
    		if(this.Total == null) {
				this.Total = 0;
			}
    		this.Total = this.Total + this.TaxAmount;
    	}
    	this.ItemType = Constants.CLAIM_SERVICE_ORDER_INVOICE_ITEM_TYPE;
    }
     
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static COInvoiceItem parse(String json) {
        return (COInvoiceItem) System.JSON.deserialize(json, COInvoiceItem.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> coInvoiceItemFields = new List<String>{ 'Id',
	                                                        'Name', 
	                                                        'Qty__c',
	                                                        'CO_Invoice_Header__c',
	                                                        'CO_Line_Item__c',
	                                                        'isActive__c',
	                                                        'Is_Invoiceable__c',
	                                                        'CreatedDate',
	                                                        
	                                                        'CO_Line_Item__r.Part__c',
	                                                        'CO_Line_Item__r.Part__r.Name',
	                                                        'CO_Line_Item__r.Part__r.Part_Number__c',
	                                                        'CO_Line_Item__r.Part__r.Description__c',
	                                                        'CO_Line_Item__r.Item_ID__c',
	                                                        'CO_Line_Item__r.Qty_Committed__c',
	                                                        'CO_Line_Item__r.Price__c',
	                                                        'CO_Line_Item__r.Retail__c',
	                                                        'CO_Line_Item__r.Tax__c',
	                                                        'CO_Line_Item__r.Qty__c',
	                                                        'CO_Line_Item__r.Fee__c',
	                                                        
	                                                        'Service_Order_Header__c',
	                                                        'Service_Order_Header__r.Name__c',
	                                                        'Service_Order_Header__r.Total__c',
	                                                        'Service_Order_Header__r.Tax_Amount__c',
	                                                        'Service_Order_Header__r.Status__c',
	                                                        'Service_Order_Header__r.Work_Status__c',
	                                                        'Service_Order_Header__r.Claim_Status__c',
	                                                        'Service_Order_Header__r.Transaction_Type__r.Type__c',
	                                                        'Service_Order_Header__r.Provider__r.Name',
	                                                        'Service_Order_Header__r.Category__r.Name',
	                                                        
	                                                        'CO_Kit_Header__r.Kit_Header__r.Kit_Unique_Name__c',
	                                                        'CO_Kit_Header__r.Price__c',
	                                                        'CO_Kit_Header__r.Tax_Amount__c',
	                                                        
	                                                        'SO_Payment_Role__c',
															'SO_Payment_Role__r.RecordType.DeveloperName',
															'SO_Payment_Role__r.Total_Amount__c',
															'SO_Payment_Role__r.Tax_Amount__c',
															'SO_Payment_Role__r.Deductible_Status__c',
															'SO_Payment_Role__r.Service_Order_Header__r.Name__c',
															'SO_Payment_Role__r.Service_Order_Header__r.Work_Status__c',
															'SO_Payment_Role__r.Claim__c',
															'SO_Payment_Role__r.Claim__r.Claim_Disposition__c',
															'SO_Payment_Role__r.Qty__c',
															'SO_Payment_Role__r.Category__c',
															'SO_Payment_Role__r.Category__r.Name'
	                                               		 };
        return coInvoiceItemFields;
    }
}