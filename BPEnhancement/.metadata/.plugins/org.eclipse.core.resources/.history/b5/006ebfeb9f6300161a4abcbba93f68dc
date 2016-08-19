/**
 * Author: Ashish Garg
 * Since: July 3, 2015
 * Name: POType
 * Description: Apex class to handle JSON related oprations of Purchase Order Type.
**/
global with sharing class POType {
	// Id
	public String Id;
	
	// Vendor Id
	public String VendorId;
	
	// Code value
	public String Code;
	
	// LeadTime ordered
	public Integer LeadTime;
	
	// Discount
	public Decimal Discount;
	
	// Landed Cost Adjustment
	public Decimal LandedCostAdjustment;
	
	// Usage
	public String Usage;
	
	// Id default POType for vendor
	public boolean IsDefault;
	
	// Constructor
    public POType(PO_Type__c purchaseOrderType) { 
        this.Id						= purchaseOrderType.Id;
        this.VendorId				= purchaseOrderType.Vendor__c;
        this.Code					= purchaseOrderType.Code__c;
        this.LeadTime				= (Integer) purchaseOrderType.Lead_Time__c;
        this.Discount				= purchaseOrderType.Discount__c;
        this.LandedCostAdjustment	= purchaseOrderType.Landed_Cost_Adjustment__c;
        this.Usage					= purchaseOrderType.Usage__c;
        this.IsDefault				= purchaseOrderType.IsDefault__c;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: POType - Class Object
    **/
    public static List<POType> parse(String json) {
        return (List<POType>) System.JSON.deserialize(json, List<POType>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> purchaseOrderFields = new List<String>{'Id',
        													'Vendor__c',
	        												'Code__c',
		                                                   	'Lead_Time__c',
		                                                   	'Discount__c',
		                                                   	'Landed_Cost_Adjustment__c',
		                                                   	'Usage__c',
		                                                   	'IsDefault__c'
		                                               	};
        return purchaseOrderFields;
    }
    
    /**
     * Name: getAllPOTypesForVendor
     * Desc: Get all related Purchase Order Types for a Vendor record
     * @param:	(1) vendorId - String - Vendor Id for which records need to retrieved
     * @return: String - JSON format for all the Purchase Order Types
    **/
    public static List<POType> getAllPOTypesForVendor(Id vendorId, String pageSortAttrsJSON) {
		RelatedListPaginationSorting pageSortAttrs = POType.parsePageAttrs(pageSortAttrsJSON);
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Code__c', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<POType> poTypes = new List<POType>();
		List<PO_Type__c> poTypesList = TaxExemption.getPaginatedRecords(SOQLUtil.getPOTypesForVendor(vendorId, sortFieldMap),
																		pageSortAttrs.poTypesCurrentPage, 
		    															pageSortAttrs.poTypesPageSize 
																	);
		for(PO_Type__c purchaseOrderType : poTypesList) {
            poTypes.add(new POType(purchaseOrderType));
        }
        
		return poTypes;
    }
    
    /**
     * Name: getTotalPOTypesForVendor
     * Desc: Get total count for related Purchase Order Types of a Vendor record
     * @param:	(1) vendorId - String - Vendor Id for which records need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalPOTypesForVendor(Id vendorId) {
		List<PO_Type__c> poTypesList = SOQLUtil.getPOTypesForVendor(vendorId, null);
		return poTypesList.size();
    }
    
    // Wrapper class to hold taxt exemption record and total tax exemption records in database for a Vendor
    public class POTypeWrapper {
    	// POType record
    	public POType POTypeRecord;
    	
    	// Total count in database for a Vendor
    	public Integer TotalPOTypes;
    	
    	// Total count in database for a Vendor
    	public boolean isError;
    	
    	// Total count in database for a Vendor
    	public String ErrorMsg;
    	
    	// Constructor
    	public POTypeWrapper(PO_Type__c POTypeRecord, Id vendorId){
    		this.POTypeRecord = new POType(POTypeRecord);
    		this.TotalPOTypes = POType.getTotalPOTypesForVendor(vendorId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public POTypeWrapper(String ErrorMsg){
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
    	public Integer poTypesCurrentPage;
    	
    	// Current page size
    	public Integer poTypesPageSize;
    	
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