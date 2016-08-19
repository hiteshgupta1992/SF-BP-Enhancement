/**
 * Author: Tarun Khandelwal
 * Since: July 22, 2015
 * Name: VendorOrderLineItem
 * Description: Apex class to handle JSON related oprations of VO Line Item object.
**/
public with sharing class VendorOrderLineItem implements Comparable{
	// Id
	public String Id;
	
	// VO Line Item Key ( Part Name + Part_Id)
    public String Item;
    
    // Qty required by customer
    public String NeededFor;
    
    // Customer 
    public String Customer;
    
    // Needed By - Date
    public String NeededBy;
    
    // Need - Qty Required For Customer
    public Decimal Need;
    
    // CO Line Item price per Qty
    public Decimal Cost;
    
    // Need * Cost
    public Decimal Total;
    
    // Part Id
    public String PartId;
    
    // CO Header Id
    public String CoHeaderId;
    
    // Required for customer
    public Boolean IsRequiredForCustomer;
    
    // Is Service
    public Boolean IsService;
    
    // Item Desc
    public String ItemDesc;
    
    // Part Location
    public String Location;
    
    // Qty Available
    public Decimal QtyAvailable;
    
    // Incoming Qty
    public Decimal Incoming;
    
    // Is excess
    public Boolean IsExcess;
    
    // Is from search to add
    public Boolean IsSearchAdded;
    
    // Vendor Order Header Name
    public String VendorOrderHeaderName;
    
    // Received Qty
    public Decimal ReceivedQty;
    
    // Constructor
    public VendorOrderLineItem(Vendor_Order_Line_Item__c VendorOrderLineItemRec) { 
        //system.assert(false, VendorOrderLineItemRec);
        // Combination of Part Name + Part Id
        this.Id = VendorOrderLineItemRec.Id;
    	this.Item = VendorOrderLineItemRec.Part__r.Part_Number__c + ' - ' + VendorOrderLineItemRec.Part__r.Description__c; 
    	this.ItemDesc = VendorOrderLineItemRec.Part__r.Part_Number__c + ' - ' + VendorOrderLineItemRec.Part__r.Description__c;
    	this.Location = VendorOrderLineItemRec.Part__r.Location__c;
    	this.QtyAvailable = VendorOrderLineItemRec.Part__r.AvailableParts__c;
    	this.Incoming = VendorOrderLineItemRec.Part__r.Qty_On_Order__c;
        
        if(VendorOrderLineItemRec.Is_required_For_Customer__c || VendorOrderLineItemRec.Is_Service__c) {
        	this.NeededFor = (VendorOrderLineItemRec.CO_Header__r.Name != null) ? 'Merch ' + VendorOrderLineItemRec.CO_Header__r.Name : ''; 
        } else {
        	this.NeededFor = 'Stock';
        }
        if(VendorOrderLineItemRec.CO_Header__r.Customer__r.Name != null) {
        	this.Customer = VendorOrderLineItemRec.CO_Header__r.Customer__r.Name;
        } else {
        	this.Customer = '';
        }
        this.NeededBy = DateTime.now().format('MM/dd/YYYY');  // Hardcode
        this.Need = VendorOrderLineItemRec.Qty_Needed__c;
        this.Cost = VendorOrderLineItemRec.Cost__c;
        //system.assert(false, Cost +  '  ' + Need);
        this.Total = this.Cost * this.Need;
        this.PartId = VendorOrderLineItemRec.Part__c;
        this.CoHeaderId = VendorOrderLineItemRec.CO_Header__c;
        this.IsRequiredForCustomer = VendorOrderLineItemRec.Is_required_For_Customer__c;
        this.IsService = VendorOrderLineItemRec.Is_Service__c;
        this.IsExcess = VendorOrderLineItemRec.Is_Excess__c;
        this.IsSearchAdded = VendorOrderLineItemRec.Is_From_Search__c;
        if(VendorOrderLineItemRec.Vendor_Order_Line_Item_Group__c != null) {	
        	this.VendorOrderHeaderName = VendorOrderLineItemRec.Vendor_Order_Line_Item_Group__r.Vendor_Order_Header__r.Name;
        } else {
        	this.VendorOrderHeaderName = '';
        }
        this.ReceivedQty = VendorOrderLineItemRec.Received__c;
    }
    
    // Constructor
    public VendorOrderLineItem(Vendor_Receiving_Stock_Excess__c vrseRec) { 
        this.Need = vrseRec.Received_Qty__c;
        this.VendorOrderHeaderName = vrseRec.OrderName__c;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VendorOrderLineItem - Class Object
    **/
    public static VendorOrderLineItem parse(String json) {
        return (VendorOrderLineItem) System.JSON.deserialize(json, VendorOrderLineItem.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> VOLineItemFields = new List<String>{ 	'Id',
	                                                        'Part__c', 
	                                                        'CO_Header__c',
	                                                        'Part__r.Name',
	                                                        'Part__r.Part_Id__c',
	                                                        'Part__r.Vendor__c',
	                                                        'CO_Header__r.Name',
	                                                        'Qty_Needed__c',
	                                                        'Cost__c',
	                                                        'Status__c',
	                                                        'Vendor_Order_Header__r.Status__c',
	                                                        'CO_Header__r.Customer__r.Name',
	                                                        'Is_required_For_Customer__c',
	                                                        'Part__r.Description__c',
	                                                        'Part__r.Location__c',
	                                                        'Part__r.Part_Number__c',
	                                                        'Part__r.AvailableParts__c',
	                                                        'Part__r.Auto_reorder_Min__c',
	                                                        'Part__r.Auto_reorder_Max__c',
	                                                        'Part__r.Packaged_Part__c',
	                                                        'Part__r.Package_Qty__c',
	                                                        'Part__r.Package_Unit__c',
	                                                        'Part__r.Qty_On_Order__c',
	                                                        'Is_Excess__c',
	                                                        'Is_From_Search__c',
	                                                        'Is_Service__c',
	                                                        'CreatedDate',
	                                                        'LastModifiedDate',
	                                                        'CO_Line_Item__c',
	                                                        'CO_Line_Item__r.Status__c',
	                                                        'CO_Line_Item__r.VO_Number__c',
	                                                        'CO_Line_Item__r.Expected_Delivery_Date__c',
	                                                        'CO_Line_Item__r.VO_Status__c',
	                                                        'Vendor_Order_Line_Item_Group__c',
	                                                        'Vendor_Order_Line_Item_Group__r.Vendor_Order_Header__r.Name',
	                                                        'Vendor_Order_Header__c',
	                                                        'Vendor_Order_Header__r.Name',
	                                                        'Received__c',
	                                                        'Vendor_Receiving_Group__r.Vendor_Receiving_Header__c'
                                                };
        return VOLineItemFields;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> stockExcessFieldsList(){
        List<String> stockExcessFields = new List<String>{ 	'Id',
	                                                        'OrderName__c', 
	                                                        'Received_Qty__c',
	                                                        'Vendor_Order_Line_Item_Group__c'
                                                };
        return stockExcessFields;
    }
    
    public static List<VendorOrderLineItem> getPaginatedRecords(List<VendorOrderLineItem> allrecords, Integer currentPage, integer pageSize) {
    	List<VendorOrderLineItem> objRecords = new List<VendorOrderLineItem>();
    	if(currentPage == null || currentPage == 0){
    		currentPage = 1;
    	}
    	if(pageSize == null || pageSize == 0){
    		pageSize = (Integer) General_Configurations__c.getInstance().Related_List_Page_Size__c;
    	}
    	
    	for(Integer i = (currentPage * pageSize - pageSize); i < (currentPage * pageSize); i++){
    		if(allrecords.size() > i){
    			objRecords.add(allrecords.get(i));
    		}
    	}
    	return objRecords;
    }
    
    public Integer compareTo(object compareTo){
		VendorOrderLineItem compareToWrapperObj = ((VendorOrderLineItem)compareTo);
    	Integer returnVal = (compareToWrapperObj.Item < this.Item) ? 1 : ((compareToWrapperObj.Item == this.Item) ? 0 : -1);
    	
    	String sortMapKey = (this.IsRequiredForCustomer) ? 'Customers' : 'Stocks';
    	if( VendorOrderLineItemWrapper.sortFieldMap != null &&
    		VendorOrderLineItemWrapper.sortFieldMap.containsKey(sortMapKey) &&
    		VendorOrderLineItemWrapper.sortFieldMap.get(sortMapKey) == 'DESC'){
    		returnVal *= -1;
    	}
    	
    	return returnVal; 
	}
}