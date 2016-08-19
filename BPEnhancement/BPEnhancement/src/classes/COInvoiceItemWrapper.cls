/**
 * Author: Tarun Khandelwal
 * Since: May 1, 2015
 * Name: COInvoiceItem
 * Description: Apex class to handle JSON related oprations of CO Invoice Header object.
**/
public with sharing class COInvoiceItemWrapper {
    
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
    
    // CO Item Selected
    public Boolean isSelected {get; set;}
    
    // CO Invoice Header Id
    public String coInvoiceHeaderId {get; set;}
    
    // CO Invoice Item Id
    public String coInvoiceItemId {get; set;}
    
    
    // Constructor
    public COInvoiceItemWrapper(CO_Line_Item__c coLineItemObj, Map<String, List<SObject>> coLineItemIdToCOInvoiceItemsMap) { 
        this.Item = coLineItemObj.Part__r.Name + ' - ' + coLineItemObj.Item_ID__c;
        this.Qty = coLineItemObj.Qty_Committed__c;
        this.COLineItemId = coLineItemObj.Id;
        this.Price = coLineItemObj.Price__c;
        this.Total = (this.Qty) * (this.Price);
        if(coLineItemIdToCOInvoiceItemsMap.containsKey(coLineItemObj.Id)) {
        	if(coLineItemIdToCOInvoiceItemsMap.get(coLineItemObj.Id).size() > 0) {
        		this.isSelected = true;
        		this.coInvoiceItemId = String.valueOf(coLineItemIdToCOInvoiceItemsMap.get(coLineItemObj.Id)[0].get('Id'));
        		this.coInvoiceHeaderId = String.valueOf(coLineItemIdToCOInvoiceItemsMap.get(coLineItemObj.Id)[0].get('CO_Invoice_Header__c'));
        	} else {
        		this.isSelected = false;
        	}
        }
    }
    
}