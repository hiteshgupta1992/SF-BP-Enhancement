/**
 * Author: Tarun Khandelwal
 * Since: Aug. 11, 2015
 * Name: VendorOrderStockExcess
 * Description: Apex class to handle JSON related oprations of Stock Excess grid on Vendor Order.
**/
public with sharing class VendorOrderStockExcess implements Comparable{	
	
	// Id
    public String Id;
    
    // Part Number + Part desc
    public String ItemDesc;
    
    // Need - Qty Required 
    public Decimal Need;
    
    // Package Qty
    public Decimal PackageQty;
    
    // Order 
    public String OrderType;
    
    // Qty Unit Type
    public String UnitType;
    
    // Order Value
    public Decimal OrderValue;
    
    // Order Lot
    public Decimal OrderLot;
    
    // CO Line Item price per Qty
    public Decimal Cost;
    
    // Need * Cost
    public Decimal Total;
    
    // Part Id
    public String PartId;
    
    // Available Part
    public Decimal ExcessQty;
    
    // Is Excess
    public Boolean IsExcess;
    
    // VOLI Group Id
    public String VOLIGroupId;
    
    // Constructor
    public VendorOrderStockExcess(Vendor_Order_Line_Item_Group__c VendorOrderLineItemGroupRec) {
        this.Cost = 0;
        this.IsExcess = false;
        this.Need = 0;
        for(Vendor_Order_Line_Item__c voliRec : VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r) {
        	if(voliRec.Is_Excess__c) {
        		this.IsExcess = true;
        		this.Id = voliRec.id;
        		this.Cost = voliRec.Cost__c;
        		this.Need = VendorOrderLineItemGroupRec.Need__c - voliRec.Qty_Needed__c;
        		this.ExcessQty = voliRec.Qty_Needed__c;
        	} else {
        		
        	}
        }
        
        this.ItemDesc = VendorOrderLineItemGroupRec.Part__r.Part_Number__c + ' - ' + VendorOrderLineItemGroupRec.Part__r.Description__c;
        this.UnitType = VendorOrderLineItemGroupRec.Part__r.Package_Unit__c;
        this.OrderType = '';
        this.PackageQty = VendorOrderLineItemGroupRec.Part__r.Package_Qty__c;
        this.OrderValue = this.Need;
        this.OrderLot = VendorOrderLineItemGroupRec.Part__r.Order_Lots__c;
        
        if(VendorOrderLineItemGroupRec.Part__r.Packaged_Part__c) {
            this.OrderValue = this.Need / VendorOrderLineItemGroupRec.Part__r.Package_Qty__c;
            this.OrderType = 'Ordered as ' + VendorOrderLineItemGroupRec.Part__r.Package_Qty__c + '/' +VendorOrderLineItemGroupRec.Part__r.Package_Unit__c;
            if(VendorOrderLineItemGroupRec.Part__r.Order_Lots__c > 1) {
                this.OrderType += ' in Lots of ' + VendorOrderLineItemGroupRec.Part__r.Order_Lots__c;
            }
        } else if(VendorOrderLineItemGroupRec.Part__r.Order_Lots__c > 1) {
            this.OrderType += 'Ordered as in Lots of ' + VendorOrderLineItemGroupRec.Part__r.Order_Lots__c;
        }
        this.Total = this.Cost * this.Need;
        this.PartId = VendorOrderLineItemGroupRec.Part__c;
        this.VOLIGroupId = VendorOrderLineItemGroupRec.Id;
    }
    
    public Integer compareTo(object compareTo){
		VendorOrderStockExcess compareToWrapperObj = ((VendorOrderStockExcess)compareTo);
    	Integer returnVal = (compareToWrapperObj.ItemDesc < this.ItemDesc) ? 1 : ((compareToWrapperObj.ItemDesc == this.ItemDesc) ? 0 : -1);
    	
    	String sortMapKey = 'Stocks';
    	if( VendorOrderLineItemWrapper.sortFieldMap != null &&
    		VendorOrderLineItemWrapper.sortFieldMap.containsKey(sortMapKey) &&
    		VendorOrderLineItemWrapper.sortFieldMap.get(sortMapKey) == 'DESC'){
    		returnVal *= -1;
    	}
    	
    	return returnVal; 
	}
}