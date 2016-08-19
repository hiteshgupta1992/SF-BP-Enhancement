/**
 * Author: Tarun Khandelwal
 * Since: Aug 19, 2015
 * Name: VORGroup
 * Description: Apex class to handle all operations related to Vendor Order Receiving Group record.
**/
public with sharing class VORGroup  implements Comparable {
	
	// Id
    public String Id;
    
    // Part Number + Part desc
    public String ItemDesc;
    
    // Qty required by customer
    public String NeededFor;
    
    // Needed By - Date
    public String NeededBy;
    
    // Order 
    public String OrderType;
    
    // Qty Unit Type
    public String UnitType;
    
    // Order Value
    public Decimal OrderValue;
    
    // Received Order
    public Decimal ReceivedQty;
    
    // CO Line Item price per Qty
    public Decimal Cost;
    
    // Need * Cost
    public Decimal Total;
    
    // Part Id
    public String PartId;
    
    // Related VOLI
    public List<VendorOrderLineItem> VendorOrderLineItemList;
    
    // Is Excess
    public Boolean IsExcess;
    
    // Package Qty
    public Decimal PackageQty;
    
    // Need
    public Decimal Need;
    
    // List of Name of matching parts Vendor Order Header Name
    public List<String> OtherVOHeaderNameList;

    
    // Constructor
    public VORGroup(Vendor_Receiving_Group__c vrGroupRec, Map<Id, List<String>> partIdToOtherVOHeaderNameListMap) {
        this.VendorOrderLineItemList = new List<VendorOrderLineItem>();
        this.OtherVOHeaderNameList = new List<String>();
        this.IsExcess = false;
        
        this.Id = vrGroupRec.Id;
        this.ItemDesc = vrGroupRec.Part__r.Part_Id__c + ' - ' + vrGroupRec.Part__r.Description__c;
        if(vrGroupRec.Cost__c != null) {
        	this.Cost = vrGroupRec.Cost__c;
        } else {
        	this.Cost = vrGroupRec.Part__r.Last_Cost__c;
        }
        this.Need = 0;
        
        Map<Id, VendorOrderLineItem> voliIdToVOLIRecMap = new Map<Id, VendorOrderLineItem>();
        List<VendorReceivingLineItem> vrlis = new List<VendorReceivingLineItem>();
        
        for(Vendor_Order_Line_Item__c voliRec : vrGroupRec.Vendor_Order_Line_Items__r) {
        	VendorOrderLineItem voli = new VendorOrderLineItem(voliRec);
            this.VendorOrderLineItemList.add(voli);
            if(voliRec.Is_Excess__c) {
            	this.IsExcess = true;
            }  
            this.Need += voliRec.Qty_Needed__c;
            
            vrlis.add( new VendorReceivingLineItem(voliRec) );
        	voliIdToVOLIRecMap.put(voliRec.Id, voli);
        }
        vrlis.sort();
        this.VendorOrderLineItemList.clear();
        for(VendorReceivingLineItem vrli : vrlis){
        	this.VendorOrderLineItemList.add(voliIdToVOLIRecMap.get(vrli.voli.Id));
        }
        
        for(Vendor_Receiving_Stock_Excess__c vrseRec : vrGroupRec.Vendor_Receiving_Stock_Excesses__r) {
            this.VendorOrderLineItemList.add(new VendorOrderLineItem(vrseRec));
        }
        
		Map<Id, Vendor_Order_Line_Item__c> voLineItemMap = new Map<Id, Vendor_Order_Line_Item__c>(vrGroupRec.Vendor_Order_Line_Items__r);
		
        if(vrGroupRec.Vendor_Order_Line_Items__r.size() > 1) {
            this.NeededFor = 'Multiple Sources';  // Hardcode
            this.NeededBy = null ;// Hardcode
            
            boolean isExcessRec = false;
        	for(VendorOrderLineItem voliRec : VendorOrderLineItemList){
        		if(voliRec.IsExcess != null && !voliRec.IsExcess ){
        			voliRec.NeededBy = ( ((Vendor_Order_Line_Item__c)(voLineItemMap.get(voliRec.Id))).CreatedDate.addDays(2)).format('MM/dd/YYYY');
        		} else {
        			isExcessRec = true;
        		}
            }
        } else if(vrGroupRec.Vendor_Order_Line_Items__r.size() == 1){
            if(!vrGroupRec.Vendor_Order_Line_Items__r[0].Is_required_For_Customer__c && !vrGroupRec.Vendor_Order_Line_Items__r[0].Is_Service__c) {
            	this.NeededFor = 'Stock';
            } else {
            	this.NeededFor = (vrGroupRec.Vendor_Order_Line_Items__r[0].CO_Header__r.Name != null) ? 'Merch ' + vrGroupRec.Vendor_Order_Line_Items__r[0].CO_Header__r.Name : 'Multiple Sources';  // Hardcode
            }
            this.NeededBy = (vrGroupRec.CreatedDate.addDays(2)).format('MM/dd/YYYY');
        }
        
        this.UnitType = vrGroupRec.Part__r.Package_Unit__c;
        this.OrderType = '';
        this.OrderValue = this.Need;
        if(vrGroupRec.Part__r.Packaged_Part__c) {
            this.OrderValue = this.Need / vrGroupRec.Part__r.Package_Qty__c;
            this.OrderType = 'Ordered as ' + vrGroupRec.Part__r.Package_Qty__c + '/' +vrGroupRec.Part__r.Package_Unit__c;
            if(vrGroupRec.Part__r.Order_Lots__c > 1) {
                this.OrderType += ' in Lots of ' + vrGroupRec.Part__r.Order_Lots__c;
            }
        } else if(vrGroupRec.Part__r.Order_Lots__c > 1) {
            this.OrderType += 'Ordered as in Lots of ' + vrGroupRec.Part__r.Order_Lots__c;
        }
        
        this.Total = (vrGroupRec.Recieved__c != null) ? (this.Cost * vrGroupRec.Recieved__c) : 0;
        this.PartId = vrGroupRec.Part__c;
        
        if(partIdToOtherVOHeaderNameListMap.containsKey(vrGroupRec.Part__c)) {
        	this.OtherVOHeaderNameList = partIdToOtherVOHeaderNameListMap.get(vrGroupRec.Part__c);
        }
        
        if(vrGroupRec.Part__r.Packaged_Part__c) {
        	this.ReceivedQty = (vrGroupRec.Recieved__c / vrGroupRec.Part__r.Package_Qty__c);
        } else {
        	this.ReceivedQty = vrGroupRec.Recieved__c;
        }
        this.PackageQty = vrGroupRec.Part__r.Package_Qty__c;
    }
    
    public static List<VORGroup> getPaginatedRecords(List<VORGroup> allrecords, Integer currentPage, integer pageSize) {
        List<VORGroup> objRecords = new List<VORGroup>();
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
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){ 
        List<String> VORGroupFields = new List<String>{ 'Id',
        												'CreatedDate',
                                                        'Cost__c',
                                                        'Part__c', 
                                                        'Part__r.Name',
                                                        'Part__r.Part_Id__c',
                                                        'Part__r.Description__c',
                                                        'Part__r.Package_Unit__c',
                                                        'Part__r.Packaged_Part__c',
                                                        'Part__r.Package_Qty__c',
                                                        'Part__r.Order_Lots__c',
                                                        'Part__r.Last_Cost__c',
                                                        'Vendor_Receiving_Header__c',
                                                        'Recieved__c',
                                                        'Vendor_Receiving_Header__r.Vendor__r.Purchase_Tax__r.Rate__c'
                                                };
        return VORGroupFields;
    } 
    
    public Integer compareTo(object compareTo){ 
        VORGroup compareToWrapperObj = ((VORGroup)compareTo);
        Integer returnVal = (compareToWrapperObj.ItemDesc < this.ItemDesc) ? 1 : ((compareToWrapperObj.ItemDesc == this.ItemDesc) ? 0 : -1);
        
        String sortMapKey = 'Items';
        if( VendorOrderLineItemWrapper.sortFieldMap != null &&
            VendorOrderLineItemWrapper.sortFieldMap.containsKey(sortMapKey) &&
            VendorOrderLineItemWrapper.sortFieldMap.get(sortMapKey) == 'DESC'){
            returnVal *= -1;
        }
        
        return returnVal;
    }
}