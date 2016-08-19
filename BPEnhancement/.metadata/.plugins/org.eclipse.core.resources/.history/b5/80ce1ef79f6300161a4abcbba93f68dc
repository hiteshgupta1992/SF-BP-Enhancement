/**
 * Author: Tarun Khandelwal
 * Since: July 24, 2015
 * Name: VendorOrderLineItemWrapper
 * Description: Apex class to handle JSON related oprations of Wrapper of VO Line Item object.
**/
public with sharing class VendorOrderLineItemWrapper{
    public Integer TotalLineItemGroups;
    public List<VendorOrderLineItemGroup> VendorOrderLineItemGroupList;
    
    public List<VendorOrderLineItemGroup> RecentlyEditedGroupList;
    
    public Integer TotalRequiredForStocks;
    public List<VendorOrderLineItem> VOLineItemRequiredForStock;
    
    public Integer TotalRequiredForCustomers;
    public List<VendorOrderLineItem> VOLineItemRequiredForCustomer;
    
    public decimal GroupTotalCost;
    
    public static Map<String, String> sortFieldMap;
    
    public VendorOrderHeader VendorOrderHeader;
    
    public String NewLineItemId;
    
    public List<POTypes> OrderTypes;  
    
    public List<VendorOrderStockExcess> StockExcessList;
    
    public List<VRHistory> VRHistoryList;
    
    public VendorOrderLineItemWrapper(  List<Vendor_Order_Line_Item__c> voLineItemsRequiredForStock, 
                                        List<Vendor_Order_Line_Item__c> voLineItemsRequiredForCustomer, 
                                        List<Vendor_Order_Line_Item_Group__c> voliGroupList,
                                        VendorOrderCtrl.PaginationSorting itemsPageSortAttrs,
                                        VendorOrderCtrl.PaginationSorting customersPageSortAttrs,
                                        VendorOrderCtrl.PaginationSorting stocksPageSortAttrs,
                                        Map<String, String> listsSortFieldMap,
                                        VendorOrderHeader vendorOrderHeader,
                                        String newLineItemId,
                                        List<PO_Type__c> poTypesList,
                                        List<Vendor_Order_Line_Item_Group__c> recentlyEditedGroup
                                    ) {
        VendorOrderLineItemGroupList = new List<VendorOrderLineItemGroup>();
        RecentlyEditedGroupList = new List<VendorOrderLineItemGroup>();
        VOLineItemRequiredForStock = new List<VendorOrderLineItem>();
        VOLineItemRequiredForCustomer = new List<VendorOrderLineItem>();
        StockExcessList = new List<VendorOrderStockExcess>();
        OrderTypes = new List<POTypes>();
        VRHistoryList = new List<VRHistory>();
        
        sortFieldMap = listsSortFieldMap;
        GroupTotalCost = 0;
        for(Vendor_Order_Line_Item_Group__c voliGroupRec : voliGroupList) {
        	VendorOrderLineItemGroup voGroupItem = new VendorOrderLineItemGroup(voliGroupRec, vendorOrderHeader);
            this.VendorOrderLineItemGroupList.add(voGroupItem);
            
            VendorOrderStockExcess vendorOrderStockExcessObj = new VendorOrderStockExcess(voliGroupRec);
            if(vendorOrderStockExcessObj.Need > 0) {
            	this.StockExcessList.add(new VendorOrderStockExcess(voliGroupRec));	
            }
            GroupTotalCost += voGroupItem.Total;
        }
		
        if(sortFieldMap.containsKey('Stocks') && String.valueOf(sortFieldMap.get('Stocks')).length() != 0){
        	StockExcessList.sort();
        }

        for(Vendor_Order_Line_Item_Group__c voliGroupRec : recentlyEditedGroup) {
            this.RecentlyEditedGroupList.add(new VendorOrderLineItemGroup(voliGroupRec, vendorOrderHeader));
        }
        
        if(sortFieldMap.containsKey('Items') && String.valueOf(sortFieldMap.get('Items')).length() != 0){
        	VendorOrderLineItemGroupList.sort();
        }
        TotalLineItemGroups = VendorOrderLineItemGroupList.size();
        VendorOrderLineItemGroupList = new List<VendorOrderLineItemGroup>(VendorOrderLineItemGroup.getPaginatedRecords(VendorOrderLineItemGroupList, itemsPageSortAttrs.CurrentPage, itemsPageSortAttrs.PageSize));
        
        //system.assert(false, '1\n\n' + voLineItems);
        for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequiredForStock) {
        	VendorOrderLineItem voLineItem = new VendorOrderLineItem(voliRec);
        	if(vendorOrderHeader.OrderType != null){
        		voLineItem.NeededBy = (voliRec.CreatedDate.addDays(vendorOrderHeader.OrderType.LeadTime)).format('MM/dd/YYYY');
        	}
            this.VOLineItemRequiredForStock.add(voLineItem);
        }
        
        if(sortFieldMap.containsKey('Stocks') && String.valueOf(sortFieldMap.get('Stocks')).length() != 0){
        	VOLineItemRequiredForStock.sort();
        }
        TotalRequiredForStocks = VOLineItemRequiredForStock.size();
        VOLineItemRequiredForStock = new List<VendorOrderLineItem>(VendorOrderLineItem.getPaginatedRecords(VOLineItemRequiredForStock, customersPageSortAttrs.CurrentPage, customersPageSortAttrs.PageSize));
        
        for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequiredForCustomer) {
        	VendorOrderLineItem voLineItem = new VendorOrderLineItem(voliRec);
        	if(vendorOrderHeader.OrderType != null){
        		voLineItem.NeededBy = (voliRec.CreatedDate.addDays(vendorOrderHeader.OrderType.LeadTime)).format('MM/dd/YYYY');
        	}
            this.VOLineItemRequiredForCustomer.add(voLineItem);
        }
        if(sortFieldMap.containsKey('Customers') && String.valueOf(sortFieldMap.get('Customers')).length() != 0){
        	VOLineItemRequiredForCustomer.sort();
        }
        TotalRequiredForCustomers = VOLineItemRequiredForCustomer.size();
        VOLineItemRequiredForCustomer = new List<VendorOrderLineItem>(VendorOrderLineItem.getPaginatedRecords(VOLineItemRequiredForCustomer, stocksPageSortAttrs.CurrentPage, stocksPageSortAttrs.PageSize));
        
        this.VendorOrderHeader = vendorOrderHeader;
        this.NewLineItemId = newLineItemId;
        
        for(PO_Type__c poTypeRec : poTypesList) {
        	this.OrderTypes.add(new POTypes(poTypeRec));
        }
        populateVRHistoryList(vendorOrderHeader.Id);
    }
    
    
    private void populateVRHistoryList(Id voHeaderId) {
    	voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
    	if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	List<In_Progress_VR__c> inProgressVRList = [select Vendor_Receiving_Header__c from In_Progress_VR__c where Vendor_Order_Header__c =: voHeaderId];
    	Set<Id> vrHeaderIdSet = new Set<Id>();
    	for(In_Progress_VR__c inProgressVRRec : inProgressVRList) {
    		vrHeaderIdSet.add(inProgressVRRec.Vendor_Receiving_Header__c);
    	}
    	
    	if(vrHeaderIdSet.size() == 0) {
    		return;
    	}
    	//system.assert(false, 'Hello' + vrHeaderIdSet);
    	
    	List<Vendor_Receiving_Header__c> vrHeaderList = Database.query(getQuery(vrHeaderIdSet));
		
		for(Vendor_Receiving_Header__c vrHeaderRec : vrHeaderList) {
			this.VRHistoryList.add(new VRHistory(vrHeaderRec));
		}
    	
    }
    
    private String getQuery(Set<Id> vrHeaderIdSet) {
    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	String query = '';
    	query += 'SELECT ';
    	
    	for(String fieldName : VendorInvoicingCtrl.voReceivingFieldsList()){
            query += fieldName + ', ';
        } 
        
        // Child Query
        query += '(SELECT '; 
        for(String fieldName : VendorInvoicingCtrl.vrGroupFieldsList()){
            query += fieldName + ', ';
        }
        query = query.substring(0, query.length()-2);
        query += ' FROM Vendor_Receiving_Groups__r ), In_Progress_VI__r.Invoice_Number__c ';
        
        query += ' FROM ' + Constants.NAMESPACE + 'Vendor_Receiving_Header__c WHERE ID IN : vrHeaderIdSet';
        return query;
    }
    
    public class POTypes {
    	public String Id;
    	public String Name;
    	public Boolean IsDefault;
    	
    	public POTypes(PO_Type__c poTypeRec) {
    		this.Id = poTypeRec.Id;
    		this.Name = poTypeRec.Code__c;
    		this.IsDefault = poTypeRec.IsDefault__c;
    	}
    }
    
    // Wrapper class for Vendor Invoice History Section
    public class VRHistory {
    	
    	public String PackingSlipNumber;
    	public String ReceivedDate;
    	public String ReceivedByName;
    	public String ReceivedById;
    	public String VRHeaderId;
    	public Decimal TotalLineItems;
    	public Decimal TotalCost;
    	public String Status;
        
        public VRHistory(Vendor_Receiving_Header__c vrHeaderRec) {
        	
        	this.PackingSlipNumber = vrHeaderRec.Packing_Slip_Number__c;
    		if(vrHeaderRec.Finalized_Date__c != null) {
    			this.ReceivedDate = (datetime.newInstance(vrHeaderRec.Finalized_Date__c.year(), vrHeaderRec.Finalized_Date__c.month(), vrHeaderRec.Finalized_Date__c.day())).format('MM/dd/YYYY');
    		}
    		this.ReceivedByName = vrHeaderRec.Owner__r.Name;
    		this.ReceivedById = vrHeaderRec.Owner__c;
    		this.VRHeaderId = vrHeaderRec.Id;
    		
    		this.TotalLineItems = 0;
    		this.TotalCost = 0;
    		for(Vendor_Receiving_Group__c vrGroupRec : vrHeaderRec.Vendor_Receiving_Groups__r ) {
    			this.TotalLineItems += 1;
    			this.TotalCost += (vrGroupRec.Recieved__c * vrGroupRec.Cost__c);
    		}
    		
    		if(vrHeaderRec.In_Progress_VI__c != null) {
    			this.Status = vrHeaderRec.In_Progress_VI__r.Invoice_Number__c;
    		} else {
    			this.Status = 'Pending Invoice';
    		}
        }
    }
}