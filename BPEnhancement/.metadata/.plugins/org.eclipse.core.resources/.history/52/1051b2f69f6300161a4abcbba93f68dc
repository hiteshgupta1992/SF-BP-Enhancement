/**
 * Author: Tarun Khandelwal
 * Since: July 22, 2015
 * Name: VendorOrderLineItemGroup
 * Description: Apex class to handle JSON related oprations of VO Line Item group object.
**/
public with sharing class VendorOrderLineItemGroup implements Comparable{
    // Id
    public String Id;
    
    // Part Number + Part desc
    public String ItemDesc;
    
    // Need - Qty Required 
    public Decimal Need;
    
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
    
    // CO Line Item price per Qty
    public Decimal Cost;
    
    // Need * Cost
    public Decimal Total;
    
    // Part Id
    public String PartId;
    
    // Available Part
    public Decimal AvailablePart;
    
    // Related VOLI
    public List<VendorOrderLineItem> VendorOrderLineItemList;
    
    // Is Excess
    public Boolean IsExcess;
    
    // % Received 
    public Decimal PercentRecieved;
    
    // ReceivedQty
    public Decimal ReceivedQty;
    
    // VO Header Name
    public String VOHeaderName;
    
    // UnReceived Qty
    public Decimal UnreceivedQty;
    
    //Expected Date
    public String ExpectedDate;
    
    // Constructor
    public VendorOrderLineItemGroup(Vendor_Order_Line_Item_Group__c VendorOrderLineItemGroupRec, VendorOrderHeader vendorOrderHeader) {
        system.debug('&&&&&&&&&&&&&&&&&&  VendorOrderLineItemGroupRec \n\n' + VendorOrderLineItemGroupRec);
        this.Id = VendorOrderLineItemGroupRec.Id;
        this.VendorOrderLineItemList = new List<VendorOrderLineItem>();
        this.Cost = 0;
        this.IsExcess = false;
        
        Map<Id, VendorOrderLineItem> voliIdToVOLIRecMap = new Map<Id, VendorOrderLineItem>();
        List<VendorReceivingLineItem> vrlis = new List<VendorReceivingLineItem>();
        for(Vendor_Order_Line_Item__c voliRec : VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r) {
        	VendorOrderLineItem voli = new VendorOrderLineItem(voliRec);
            this.VendorOrderLineItemList.add(voli);
            this.Cost = voliRec.Cost__c;
            if(voliRec.Is_Excess__c) {
            	this.IsExcess = true;
            }
            
            vrlis.add( new VendorReceivingLineItem(voliRec) );
            voliIdToVOLIRecMap.put(voliRec.Id, voli);
        }
        vrlis.sort();
        this.VendorOrderLineItemList.clear();
        for(VendorReceivingLineItem vrli : vrlis){
        	this.VendorOrderLineItemList.add(voliIdToVOLIRecMap.get(vrli.voli.Id));
        }
        
        //system.debug('&&&&&&&&&&&&&&&&&&  VendorOrderLineItemList \n\n' + VendorOrderLineItemList);
        this.ItemDesc = VendorOrderLineItemGroupRec.Part__r.Part_Number__c + ' - ' + VendorOrderLineItemGroupRec.Part__r.Description__c;
        this.Need = VendorOrderLineItemGroupRec.Need__c;
        
        Integer leadTime = 0;
        if(vendorOrderHeader.OrderType != null){
        	leadTime = vendorOrderHeader.OrderType.LeadTime;
		}
		
		Map<Id, Vendor_Order_Line_Item__c> voLineItemMap = new Map<Id, Vendor_Order_Line_Item__c>(VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r);
		
        if(VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r.size() > 1) {
            this.NeededFor = 'Multiple Sources';  // Hardcode
            this.NeededBy = null ;// Hardcode
            
            boolean isExcessRec = false;
        	for(VendorOrderLineItem voliRec : VendorOrderLineItemList){
        		if( !voliRec.IsExcess ){
        			voliRec.NeededBy = ( ((Vendor_Order_Line_Item__c)(voLineItemMap.get(voliRec.Id))).CreatedDate.addDays(vendorOrderHeader.OrderType.LeadTime)).format('MM/dd/YYYY');
        		} else {
        			isExcessRec = true;
        		}
            }
            
            if(VendorOrderLineItemList.size() == 2 && isExcessRec){
            	this.NeededBy = (VendorOrderLineItemGroupRec.CreatedDate.addDays(Integer.valueOf(VendorOrderLineItemGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c))).format('MM/dd/YYYY');
            }
        } else if(VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r.size() == 1){
            this.NeededFor = (VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r[0].CO_Header__r.Name != null) ? 'Merch ' + VendorOrderLineItemGroupRec.Vendor_Order_Line_Items__r[0].CO_Header__r.Name : 'Multiple Sources';  // Hardcode
            if(VendorOrderLineItemGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c != null) {
            	this.NeededBy = (VendorOrderLineItemGroupRec.CreatedDate.addDays(Integer.valueOf(VendorOrderLineItemGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c))).format('MM/dd/YYYY');
            } else {
            	this.NeededBy = null;
            }
        }
        
        this.UnitType = VendorOrderLineItemGroupRec.Part__r.Package_Unit__c;
        
        this.OrderType = '';
        this.OrderValue = this.Need;
        if(VendorOrderLineItemGroupRec.Part__r.Packaged_Part__c) {
            this.OrderValue = this.Need / VendorOrderLineItemGroupRec.Part__r.Package_Qty__c;
            this.OrderType = 'Ordered as ' + VendorOrderLineItemGroupRec.Part__r.Package_Qty__c + '/' +VendorOrderLineItemGroupRec.Part__r.Package_Unit__c;
            if(VendorOrderLineItemGroupRec.Part__r.Order_Lots__c > 1) {
                this.OrderType += ' in Lots of ' + VendorOrderLineItemGroupRec.Part__r.Order_Lots__c;
            }
        } else if(VendorOrderLineItemGroupRec.Part__r.Order_Lots__c > 1) {
            this.OrderType += 'Ordered as in Lots of ' + VendorOrderLineItemGroupRec.Part__r.Order_Lots__c;
        }
        //this.Cost = VendorOrderLineItemGroupRec.Cost__c;
        this.Total = this.Cost * this.Need;
        this.AvailablePart = VendorOrderLineItemGroupRec.Part__r.AvailableParts__c;
        this.PartId = VendorOrderLineItemGroupRec.Part__c;
        this.ReceivedQty = VendorOrderLineItemGroupRec.Received_Qty__c;
        
        this.UnreceivedQty = this.Need - this.ReceivedQty;
        if(this.UnreceivedQty < 0) {
        	this.UnreceivedQty = 0;
        }
        
        if(this.Need > 0 && VendorOrderLineItemGroupRec.Received_Qty__c != null) {
        	this.PercentRecieved = (VendorOrderLineItemGroupRec.Received_Qty__c / this.Need ) * 100 ;
        } else {
        	this.PercentRecieved = 100;
        }
        this.ExpectedDate = (datetime.newInstance(Date.Today().year(), Date.Today().month(),Date.Today().day())).format('MM/dd/YYYY');
    }
    
    // Constructor
    public VendorOrderLineItemGroup(List<Vendor_Order_Line_Item__c> VendorOrderLineItemRecList, Vendor_Order_Line_Item_Group__c voliGroupRec, VendorOrderHeader vendorOrderHeader) {
        this.Need = 0;
        this.IsExcess = false;
        this.ItemDesc = voliGroupRec.Part__r.Part_Number__c + ' - ' + voliGroupRec.Part__r.Description__c;
        this.VendorOrderLineItemList = new List<VendorOrderLineItem>();
        
        Map<Id, Vendor_Order_Line_Item__c> voLineItemMap = new Map<Id, Vendor_Order_Line_Item__c>(VendorOrderLineItemRecList);
        Set<String> voHeaderNameSet = new Set<String>();
        List<VendorReceivingLineItem> vrlis = new List<VendorReceivingLineItem>();
        Map<Id, VendorOrderLineItem> voliIdToVOLIRecMap = new Map<Id, VendorOrderLineItem>();
        
        for(Vendor_Order_Line_Item__c voliRec : VendorOrderLineItemRecList) {
        	VendorOrderLineItem voli = new VendorOrderLineItem(voliRec);
            this.VendorOrderLineItemList.add(voli);
            this.Need += voliRec.Qty_Needed__c;
            voHeaderNameSet.add(voliRec.Vendor_Order_Line_Item_Group__r.Vendor_Order_Header__r.Name);
            if(voliRec.Is_Excess__c) {
            	this.IsExcess = true;
            }
            vrlis.add( new VendorReceivingLineItem(voliRec) );
            voliIdToVOLIRecMap.put(voliRec.Id, voli);
        }
        
        // Sorting Order for VOLIs
        vrlis.sort();
        this.VendorOrderLineItemList.clear();
        for(VendorReceivingLineItem vrli : vrlis){
        	this.VendorOrderLineItemList.add(voliIdToVOLIRecMap.get(vrli.voli.Id));
        }
        
        
        if(VendorOrderLineItemRecList.size() > 1) {
            this.NeededFor = 'Multiple Sources';  // Hardcode
            this.NeededBy = null ;// Hardcode
            
            boolean isExcessRec = false;
        	for(VendorOrderLineItem voliRec : VendorOrderLineItemList){
        		if( !voliRec.IsExcess ){
        			voliRec.NeededBy = ( ((Vendor_Order_Line_Item__c)(voLineItemMap.get(voliRec.Id))).CreatedDate.addDays(vendorOrderHeader.OrderType.LeadTime)).format('MM/dd/YYYY');
        		} else {
        			isExcessRec = true;
        		}
            }
            
            if(VendorOrderLineItemList.size() == 2 && isExcessRec){
            	this.NeededBy = (voliGroupRec.CreatedDate.addDays(Integer.valueOf(voliGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c))).format('MM/dd/YYYY');
            }
        } else if(VendorOrderLineItemRecList.size() == 1){
            this.NeededFor = (VendorOrderLineItemRecList[0].CO_Header__r.Name != null) ? 'Merch ' + VendorOrderLineItemRecList[0].CO_Header__r.Name : 'Multiple Sources';  // Hardcode
            if(voliGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c != null) {
            	this.NeededBy = (voliGroupRec.CreatedDate.addDays(Integer.valueOf(voliGroupRec.Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c))).format('MM/dd/YYYY');
            } else {
            	this.NeededBy = null;
            }
        }
        
        this.OrderType = '';
        this.OrderValue = this.Need;
        if(voliGroupRec.Part__r.Packaged_Part__c) {
            this.OrderValue = this.Need / voliGroupRec.Part__r.Package_Qty__c;
            this.OrderType = 'Ordered as ' + voliGroupRec.Part__r.Package_Qty__c + '/' +voliGroupRec.Part__r.Package_Unit__c;
            if(voliGroupRec.Part__r.Order_Lots__c > 1) {
                this.OrderType += ' in Lots of ' + voliGroupRec.Part__r.Order_Lots__c;
            }
        } else if(voliGroupRec.Part__r.Order_Lots__c > 1) {
            this.OrderType += 'Ordered as in Lots of ' + voliGroupRec.Part__r.Order_Lots__c;
        }
        
        if(voHeaderNameSet.size() > 1) {
        	this.VOHeaderName = 'Multiple Sources';
        } else if(voHeaderNameSet.size() == 1){
        	for(String voHeaderName : voHeaderNameSet) {
        		this.VOHeaderName = voHeaderName;
        	}
        }
        
        this.PartId = voliGroupRec.Part__c;
        this.ReceivedQty = voliGroupRec.Received_Qty__c;
        
        if(this.Need > 0) {
        	this.PercentRecieved = (voliGroupRec.Received_Qty__c / this.Need ) * 100 ;
        }
    }
    
    
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> VOLineItemGroupFields = new List<String>{  'Id',
                                                                'Part__c', 
                                                                'Part__r.Name',
                                                                'Part__r.Part_Number__c',
                                                                'Part__r.Description__c',
                                                                'Part__r.Package_Unit__c',
                                                                'Need__c',
                                                                'CreatedDate',
                                                                'Cost__c',
                                                                'Part__r.Packaged_Part__c',
                                                                'Part__r.Package_Qty__c',
                                                                'Part__r.Order_Lots__c',
                                                                'Part__r.AvailableParts__c',
                                                                'Vendor_Order_Header__r.Purchase_Order_Type__r.Lead_Time__c',
                                                                'Vendor_Order_Header__c',
                                                                'Vendor_Order_Header__r.Name',
                                                                'Unreceived_Qty__c',
                                                                'Received_Qty__c'
                                                };
        return VOLineItemGroupFields;
    }
    
    public static List<VendorOrderLineItemGroup> getPaginatedRecords(List<VendorOrderLineItemGroup> allrecords, Integer currentPage, integer pageSize) {
        List<VendorOrderLineItemGroup> objRecords = new List<VendorOrderLineItemGroup>();
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
        VendorOrderLineItemGroup compareToWrapperObj = ((VendorOrderLineItemGroup)compareTo);
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