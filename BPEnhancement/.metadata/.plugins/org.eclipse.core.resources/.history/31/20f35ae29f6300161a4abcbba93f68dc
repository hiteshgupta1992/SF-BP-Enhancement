/**
 * Author: Tarun Khandelwal
 * Since: April 10, 2015
 * Name: COLineItem
 * Description: Apex class to handle JSON related oprations of CO Line Item object.
**/
public with sharing class COLineItem {
    
    // CO Line Item Key ( Part Name + Part_Id)
    public String Item {get; set;}
    
    // Qty required by customer
    public Decimal Qty {get; set;}
    
    // Committed Qty
    public Decimal QtyCommitted {get; set;}
    
    // Status to show if requried Qty is avilable or not
    public String Status {get; set;}
    
    // CO Line Item price per Qty
    public Decimal Price {get; set;}
    
    // Price * Qty
    public Decimal SubTotal {get; set;}
    
    // Related Invoice
    public String Invoice {get; set;}
    
    // Full Fill date
    public String FulfillDate {get; set;}
    
    // CO Line Item Id
    public String CoLineItemId {get; set;}
    
    // Related Part Id
    public String partId {get; set;}
    
    // Special Order Flag
    public Boolean isSpecialOrder {get; set;}
    
    // Tax Value
    public Decimal Tax {get; set;}
    
    // Retail Price
    public Decimal Retail {get; set;}
    
    //Avaliable Parts Qty
    public Decimal AvaliablePartsQty {get; set;}
    
    // VO Status
    public String VOStatus;
    
    // VO Number
    public String VONumber;
    
    // Expected Delivery Date
    public String ExpectedDeliveryDate;
    
    // Related VO Headers List
    public List<VOHeader> VOHeaderList;
    
    public String FeeId; 
   
    public Boolean IsPart;
    public Boolean IsFee;
    public String VendorId;
    public Boolean IsFixedPrice;
    public Boolean IsFixedPriceForCO;
    public Decimal ActualKitPrice;
    public Decimal QtyOrder;
    
    // Constructor
    public COLineItem(CO_Line_Item__c coLineItemObj) { 
    	//from trial3 
    	Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
    	
        // Combination of Part Name + Part Id
    	if(coLineItemObj.Part__c != null) {
    		this.Item = coLineItemObj.Part__r.Part_Number__c + ' - ' + coLineItemObj.Part__r.Description__c; 
    	} else if(coLineItemObj.Fee__c != null) {
    		this.Item = coLineItemObj.Fee__r.Fee_Unique_Name__c;
    	} 
    	
        this.Qty = coLineItemObj.Qty__c; // Default Value = 1
        this.QtyCommitted = coLineItemObj.Qty_Committed__c; // Default Value = 0
        if(coLineItemObj.Qty__c == null) {
            coLineItemObj.Qty__c = 0;
        } 
        if(coLineItemObj.Qty_Committed__c == null) {
            coLineItemObj.Qty_Committed__c = 0;
        }
        
        if(coLineItemObj.Closed_CO_Invoice_link__c != null) {
        	this.Status = 'Invoiced'; 
        } else {
			if(coLineItemObj.Qty__c == coLineItemObj.Qty_Committed__c ) {
	  		  this.Status = 'In Stock';   
	        } else if(coLineItemObj.Qty__c > coLineItemObj.Qty_Committed__c ){
	            if(!coLineItemObj.Special_Order__c) {
	                this.Status = 'Required';
	            } else {
	                this.Status = 'Ordered';
	            }
	        } else if(coLineItemObj.Qty__c < 0) {
	        	this.Status = 'RETURN';
	        }
        }
        //from trial3
        if(coLineItemObj.Tax__c == null) {
        	coLineItemObj.Tax__c = 0;
        }
 

        if(coLineItemObj.Price__c == null) {
            this.Price = 0;
        } else { 
        	//from trial3
            if(!isTaxIncludingPricing) {
            this.Price = coLineItemObj.Price__c.setScale(2);
            } else {
            	this.Price = (coLineItemObj.Price__c * (1 + coLineItemObj.Tax__c /100)).setScale(2);
            }
        }
        
                this.SubTotal = (this.Qty * this.price).setScale(2);
        
        if(coLineItemObj.Closed_CO_Invoice_link__c != null) {
        	this.Invoice = coLineItemObj.Closed_CO_Invoice_link__c;
        } else {
        	this.Invoice = '';
        } 
        
        this.FulfillDate = String.valueOf(system.today());
        if(coLineItemObj.Id != null) {
            this.CoLineItemId = coLineItemObj.Id;
        }
        this.partId = coLineItemObj.Part__c;
        this.isSpecialOrder = coLineItemObj.Special_Order__c;
        this.Tax = coLineItemObj.Tax__c;
        this.Retail = (coLineItemObj.Retail__c != null) ? coLineItemObj.Retail__c.setScale(2) : 0.00;
        this.AvaliablePartsQty = coLineItemObj.Part__r.AvailableParts__c;
        
        this.VOStatus = coLineItemObj.VO_Status__c;
        this.VONumber = coLineItemObj.VO_Number__c;
        if(coLineItemObj.Expected_Delivery_Date__c != null) {
        	this.ExpectedDeliveryDate = (datetime.newInstance(coLineItemObj.Expected_Delivery_Date__c.year(), coLineItemObj.Expected_Delivery_Date__c.month(), coLineItemObj.Expected_Delivery_Date__c.day())).format('MM/dd/YYYY');
        }
        this.VOHeaderList = new List<VOHeader>();
        
        this.FeeId = coLineItemObj.Fee__c;
        
        this.IsPart = (coLineItemObj.Part__c != null) ? true : false;
        this.IsFee = (coLineItemObj.Fee__c != null) ? true : false;
        this.IsFixedPrice = (coLineItemObj.Fixed_Price__c == null) ? false : coLineItemObj.Fixed_Price__c;
        if(coLineItemObj.Part__c != null && coLineItemObj.Part__r.Vendor__c != null) {
        	this.VendorId = coLineItemObj.Part__r.Vendor__c;	
        }
        this.ActualKitPrice = (coLineItemObj.Actual_Kit_Price__c != null) ? coLineItemObj.Actual_Kit_Price__c.setScale(2) : 0.00;
        this.IsFixedPriceForCO = coLineItemObj.CO_Fixed_KitLineItem__c;
        this.QtyOrder = (this.Qty != null && this.QtyCommitted != null) ? (this.Qty < 0 ? null :(this.Qty - this.QtyCommitted)) : 0;
        if(this.QtyOrder == null) {
        	this.QtyCommitted = null;
        }
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: COLineItem - Class Object
    **/
    public static COLineItem parse(String json) {
        return (COLineItem) System.JSON.deserialize(json, COLineItem.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> COLineItemFields = new List<String>{	'Id',
	                                                        'Name', 
	                                                        'CO_Header__c',
	                                                        'CO_Header__r.Name',
	                                                        'CO_Header__r.Customer__c',
	                                                        'CO_Header__r.Customer__r.Name',
	                                                        'CO_Header__r.Owner__c',
	                                                        'CO_Header__r.Owner__r.Name',
	                                                        'CO_Header__r.Order_status__c',
	                                                        'Qty__c',
	                                                        'Qty_Committed__c',
	                                                        'Price__c',
	                                                        'Part__r.Name',
	                                                        'Part__r.Part_Id__c',
	                                                        'Part__r.Part_Number__c',
	                                                        'Part__r.Description__c',
	                                                        'Part__r.AvailableParts__c',
	                                                        'Part__r.Vendor__c',
	                                                        'Special_Order__c',
	                                                        'Tax__c',
	                                                        'Retail__c',
	                                                        'Closed_CO_Invoice_link__c',
	                                                        'VO_Number__c',
	                                                        'VO_Status__c',
	                                                        'Expected_Delivery_Date__c',
	                                                        'CreatedDate',
	                                                        'Fee__c',
	                                                        'Fee__r.Fee_Unique_Name__c',
	                                                        'Fixed_Price__c',
	                                                        'CO_Fixed_KitLineItem__c',
	                                                        'Actual_Kit_Price__c',
	                                                        'Kit_Price_With_Price_Level__c',
	                                                        'CO_Kit_Header__r.Id',
	                                                        'Sub_Total_With_Tax__c'
	                                                };
        return COLineItemFields;
    }
    
    
    public class VOHeader{ 
    	
    	public String VOHeaderId;
    	public String VOHeaderName;
    	
    	public VOHeader(Vendor_Order_Header__c voHeaderRec) {
    		this.VOHeaderId = voHeaderRec.Id;
    		this.VOHeaderName = voHeaderRec.Name;
    	}
    }
}