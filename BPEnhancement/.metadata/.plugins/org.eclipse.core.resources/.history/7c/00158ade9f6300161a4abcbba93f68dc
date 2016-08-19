/**
 * Author: Ashish Garg
 * Since: Jun 27, 2015
 * Name: ActiveOrder
 * Description: Apex class to handle JSON related oprations of Active Order object.
**/
global with sharing class ActiveOrder {
	// Id
	public String Id;
	
	// Part Id
	public Decimal TotalOrder;
	
	// Part Id
	public Decimal ReceivedOrder;
	
	// Part Id
	public Decimal OutstandingOrder;
	
	// Needed Qty
	public Decimal Qty;
	
	// Vendor Id
	public String VendorId;
	
	// Purchase Order number
	public String PONumber;
	
	// Status
	public String Status;
	
	// Projected Delivery date
	public String ProjectedDelivery;
	
	// Constructor
    public ActiveOrder(Vendor_Order_Header__c activeOrder) { 
        this.Id	= activeOrder.Id;
        this.PONumber = activeOrder.Name;
        this.Status	= activeOrder.Status__c;
        this.ProjectedDelivery = (activeOrder.Expected_Date__c != null) 
        						  ? DateTime.newInstance(activeOrder.Expected_Date__c.year(), activeOrder.Expected_Date__c.month(), activeOrder.Expected_Date__c.day()).format('MMMM d, yyyy') 
        						  : '';
        this.VendorId = activeOrder.Vendor__c;
        this.Qty = 0;
        this.TotalOrder = 0;
        this.ReceivedOrder = 0;
        this.OutstandingOrder = 0;
        for(Vendor_Order_Line_Item_Group__c vog : activeOrder.Vendor_Order_Line_Item_Groups__r) {
        	if(vog.Part__c != null) {
        		vog.Cost__c = vog.Part__r.Last_Cost__c;
        	} else {
        		vog.Cost__c = 0; 
        	}
        	
        	if(vog.Need__c != null && vog.Cost__c != null) {
        		this.TotalOrder += (vog.Need__c * vog.Cost__c);
        	}
        	if(vog.Received_Qty__c != null && vog.Cost__c != null) {
        		this.ReceivedOrder += (vog.Received_Qty__c * vog.Cost__c);
        	}
        	if(vog.Unreceived_Qty__c != null && vog.Cost__c != null) {
        		this.OutstandingOrder += (vog.Unreceived_Qty__c * vog.Cost__c);
        	}
        	if(vog.Need__c != null) {
        		this.Qty += vog.Need__c;
        	}
        }
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: ActiveOrder - Class Object
    **/
    public static List<ActiveOrder> parse(String json) {
        return (List<ActiveOrder>) System.JSON.deserialize(json, List<ActiveOrder>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getFieldsListUsedInPart(){
        List<String> fieldsListUsedInPart = new List<String>{	'Id',
		        												'Part__c',
		        												'Vendor_Order_Header__c'
			                                               	};
        return fieldsListUsedInPart;
    }
    
    /**
     * Name: getFieldsListUsedInCOHeader
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getFieldsListUsedInCustomer(){
        List<String> fieldsListUsedInPart = new List<String>{	'Id',
		        												'( Select Vendor_Order_Header__c from Vendor_Order_Line_Items__r )',
		        												'CO_Header__c',
		        												'CO_Header__r.Customer__c'
			                                               	};
        return fieldsListUsedInPart;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getActiveOrderfieldsList(){
        List<String> activeOrderfieldsList = new List<String>{	'Id',
			                                                   	'(Select Need__c, Unreceived_Qty__c, Part__r.Last_Cost__c, Received_Qty__c, Cost__c from Vendor_Order_Line_Item_Groups__r )',
			                                                   	'Vendor__c',
			                                                   	'Status__c',
			                                                   	'Name',
			                                                   	'Expected_Date__c'
			                                               	};
        return activeOrderfieldsList;
    }
    
     /** Added by Ankit
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> getActiveOrderfieldsListNew(){
        List<String> activeOrderfieldsList = new List<String>{	'Id',
			                                                   	'(Select Need__c, Unreceived_Qty__c, Part__r.Last_Cost__c, Received_Qty__c, Cost__c from Vendor_Order_Line_Item_Groups__r where Part__c = : partId)',
			                                                   	'Vendor__c',
			                                                   	'Status__c',
			                                                   	'Name',
			                                                   	'Expected_Date__c'
			                                               	};
        return activeOrderfieldsList;
    }
    
    /**
     * Name: getAllActiveOrdersForPart
     * Desc: Get all related Active Orders for a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the active orders
    **/
    public static List<ActiveOrder> getAllActiveOrdersForPart(Id partId, String pageSortAttrsJSON) {
		RelatedListPaginationSorting pageSortAttrs = ActiveOrder.parsePageAttrs(pageSortAttrsJSON);
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Name', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<ActiveOrder> activeOrders = new List<ActiveOrder>();
		List<Vendor_Order_Line_Item_Group__c> vogList = SOQLUtil.getPartActiveOrderGroupsForPart(partId, null);
		Set<Id> vohIdSet = new Set<Id>();
		for(Vendor_Order_Line_Item_Group__c vog : vogList) {
			vohIdSet.add(vog.Vendor_Order_Header__c);
		}
		
		List<Vendor_Order_Header__c> activeOrdersList = TaxExemption.getPaginatedRecords(SOQLUtil.getPartActiveOrdersForPart(vohIdSet, sortFieldMap,partId),
																							pageSortAttrs.activeOrdersCurrentPage, 
							    															pageSortAttrs.activeOrdersPageSize 
																						);
		for(Vendor_Order_Header__c activeOrder : activeOrdersList) {
            activeOrders.add(new ActiveOrder(activeOrder));
        }
        
		return activeOrders;
    }
    
    /**
     * Name: getAllActiveOrdersForCOHeader
     * Desc: Get all related Active Orders for a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the active orders
    **/
    public static List<ActiveOrder> getAllActiveOrdersForCustomer(Id customerId, String pageSortAttrsJSON) {
		RelatedListPaginationSorting pageSortAttrs;
		if(pageSortAttrsJSON != null) {
			pageSortAttrs = ActiveOrder.parsePageAttrs(pageSortAttrsJSON);
		} else {
			pageSortAttrs = ActiveOrder.parsePageAttrs('{}');
		}
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Name', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<ActiveOrder> activeOrders = new List<ActiveOrder>();
		List<CO_Line_Item__c> coliList = SOQLUtil.getActiveOrdersForCustomer(customerId, null);
		Set<Id> vohIdSet = new Set<Id>();
		for(CO_Line_Item__c coliRec : coliList) {
			for(Vendor_Order_Line_Item__c voliRec : coliRec.Vendor_Order_Line_Items__r) {
				vohIdSet.add(voliRec.Vendor_Order_Header__c);
			}
		}
		
		List<Vendor_Order_Header__c> activeOrdersList = TaxExemption.getPaginatedRecords(SOQLUtil.getPartActiveOrdersForPart(vohIdSet, sortFieldMap),
																							pageSortAttrs.activeOrdersCurrentPage, 
							    															pageSortAttrs.activeOrdersPageSize 
																						);
		for(Vendor_Order_Header__c activeOrder : activeOrdersList) {
            activeOrders.add(new ActiveOrder(activeOrder));
        }
        
		return activeOrders;
    }
    
    /**
     * Name: getAllActiveOrdersForVendor
     * Desc: Get all related Active Orders for a part record
     * @param:	(1) vendorId - String - vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the active orders
    **/
    public static List<ActiveOrder> getAllActiveOrdersForVendor(Id vendorId, String pageSortAttrsJSON) {
		RelatedListPaginationSorting pageSortAttrs = ActiveOrder.parsePageAttrs(pageSortAttrsJSON);
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Vendor_Order_Header__r.Name', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<ActiveOrder> activeOrders = new List<ActiveOrder>();
		List<Vendor_Order_Header__c> activeOrdersList = TaxExemption.getPaginatedRecords(SOQLUtil.getVendorActiveOrders(vendorId, sortFieldMap),
																							pageSortAttrs.activeOrdersCurrentPage, 
							    															pageSortAttrs.activeOrdersPageSize 
																						);
		for(Vendor_Order_Header__c activeOrder : activeOrdersList) {
            activeOrders.add(new ActiveOrder(activeOrder));
        }
        
		return activeOrders;
    }
    
    /**
     * Name: getTotalActiveOrdersForPart
     * Desc: Get total count for related Active Orders of a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalActiveOrdersForPart(Id partId) {
    	List<Vendor_Order_Line_Item_Group__c> vogList = SOQLUtil.getPartActiveOrderGroupsForPart(partId, null);
		Set<Id> vohIdSet = new Set<Id>();
		for(Vendor_Order_Line_Item_Group__c vog : vogList) {
			vohIdSet.add(vog.Vendor_Order_Header__c);
		}
		List<Vendor_Order_Header__c> activeOrdersList = SOQLUtil.getPartActiveOrdersForPart(vohIdSet, null);
		return activeOrdersList.size();
    }
    
    /**
     * Name: getTotalActiveOrdersForVendor
     * Desc: Get total count for related Active Orders of a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: Integer - Total count
    **/ 
    public static Integer getTotalActiveOrdersForVendor(Id vendorId) {
		List<Vendor_Order_Header__c> activeOrdersList = SOQLUtil.getVendorActiveOrders(vendorId, null);
		return activeOrdersList.size();
    }
    
    // Wrapper class to hold taxt exemption record and total tax exemption records in database for a part
    public class ActiveOrderWrapper {
    	// ActiveOrder record
    	public ActiveOrder ActiveOrderRecord;
    	
    	// Total count in database for a part
    	public Integer TotalActiveOrders;
    	
    	// Total count in database for a part
    	public boolean isError;
    	
    	// Total count in database for a part
    	public String ErrorMsg;
    	
    	// Constructor
    	public ActiveOrderWrapper(Vendor_Order_Line_Item_Group__c ActiveOrderRecord, Id partId){
    		//this.ActiveOrderRecord = new ActiveOrder(ActiveOrderRecord);
    		this.TotalActiveOrders = ActiveOrder.getTotalActiveOrdersForPart(partId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public ActiveOrderWrapper(Vendor_Order_Line_Item_Group__c ActiveOrderRecord, Id vendorId, boolean isVendor){
    		//this.ActiveOrderRecord = new ActiveOrder(ActiveOrderRecord);
    		this.TotalActiveOrders = ActiveOrder.getTotalActiveOrdersForVendor(vendorId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public ActiveOrderWrapper(String ErrorMsg){
    		this.isError = true;
    		this.ErrorMsg = ErrorMsg;
    	}
    }
    
    /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: RelatedListPaginationSorting - Class Object
    **/
    public static RelatedListPaginationSorting parsePageAttrs(String json) {
        return (RelatedListPaginationSorting) System.JSON.deserialize(json, RelatedListPaginationSorting.class);
    }
    
    // Wrapper class for related list pagination and sorting combination
    public class RelatedListPaginationSorting {
    	// Current page number
    	public Integer activeOrdersCurrentPage;
    	
    	// Current page size
    	public Integer activeOrdersPageSize;
    	
    	// Sorting list
    	public List<SortAttrs> sorting;
    }
    
    // SortAttrs for sorting attributes
    public class SortAttrs {
    	// Field name
    	public String fieldName;
    	
    	// Sort direction
    	public String sortDirection;
    }
}