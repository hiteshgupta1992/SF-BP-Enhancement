/**
 * Author: Ashish Garg
 * Since: July 9, 2015
 * Name: VendorProduct
 * Description: Apex class to handle JSON related oprations of Product.
**/
global with sharing class VendorProduct {
	// Id
	public String Id;
	
	// Vendor Id
	public String VendorId;
	
	// Code value
	public String Code;
	
	// Cost
	public decimal Cost;
	
	// Description
	public String Description;
	
	// Price
	public decimal Price;
	
	// Term
	public decimal Term;
	
	// Mileage
	public decimal Mileage;
	
	// Deductible
	public decimal Deductible;
	
	// Type
	public String Type;
	
	// Category Id value
	public Id CategoryId;
	
	// Category Name value
	public String CategoryName;
	
	// Constructor
    public VendorProduct(Product__c productRecord) { 
        this.Id				= productRecord.Id;
        this.VendorId		= productRecord.Vendor__c;
        this.Code			= productRecord.Code__c;
        this.Cost			= productRecord.Cost__c;
        this.Description	= productRecord.Description__c;
        this.Price			= productRecord.Price__c;
        this.Type			= productRecord.Type__c;
        this.Deductible		= productRecord.Deductible__c;
        this.Term			= productRecord.Term__c;
        this.Mileage		= productRecord.Mileage__c;
        this.CategoryId		= productRecord.Category__c;
        this.CategoryName	= productRecord.Category__r.Name;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VendorProduct - Class Object
    **/
    public static List<VendorProduct> parse(String json) {
        return (List<VendorProduct>) System.JSON.deserialize(json, List<VendorProduct>.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> productFields = new List<String>{	'Id',
    													'Vendor__c',
        												'Code__c',
	                                                   	'Cost__c',
	                                                   	'Description__c',
	                                                   	'Price__c',
	                                                   	'Type__c',
	                                                   	'Term__c',
	                                                   	'Mileage__c',
	                                                   	'Deductible__c',
	                                                   	'Category__c',
	                                                   	'Category__r.Name'
	                                               	};
        return productFields;
    }
    
    /**
     * Name: getAllProductsForVendor
     * Desc: Get all related Products for a Vendor record
     * @param:	(1) vendorId - String - Vendor Id for which records need to retrieved
     * @return: String - JSON format for all the Products
    **/
    public static List<VendorProduct> getAllProductsForVendor(Id vendorId, String pageSortAttrsJSON) {
		RelatedListPaginationSorting pageSortAttrs = VendorProduct.parsePageAttrs(pageSortAttrsJSON);
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Type__c', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<VendorProduct> productRecs = new List<VendorProduct>();
		List<Product__c> productRecsList = TaxExemption.getPaginatedRecords(SOQLUtil.getProductsForVendor(vendorId, sortFieldMap),
																			pageSortAttrs.productsCurrentPage, 
			    															pageSortAttrs.productsPageSize 
																		);
		for(Product__c productRecord : productRecsList) {
            productRecs.add(new VendorProduct(productRecord));
        }
        
		return productRecs;
    }
    
    /**
     * Name: getTotalProductsForVendor
     * Desc: Get total count for related Products of a Vendor record
     * @param:	(1) vendorId - String - Vendor Id for which records need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalProductsForVendor(Id vendorId) {
		List<Product__c> productRecsList = SOQLUtil.getProductsForVendor(vendorId, null);
		return productRecsList.size();
    }
    
    // Wrapper class to hold taxt exemption record and total tax exemption records in database for a Vendor
    public class ProductWrapper {
    	// VendorProduct record
    	public VendorProduct ProductRecord;
    	
    	// Total count in database for a Vendor
    	public Integer TotalProducts;
    	
    	// If any error occurs
    	public boolean isError;
    	
    	// Error message
    	public String ErrorMsg;
    	
    	// Constructor
    	public ProductWrapper(Product__c ProductRecord, Id vendorId){
    		this.ProductRecord = new VendorProduct(ProductRecord);
    		this.TotalProducts = VendorProduct.getTotalProductsForVendor(vendorId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public ProductWrapper(String ErrorMsg){
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
    	public Integer productsCurrentPage;
    	
    	// Current page size
    	public Integer productsPageSize;
    	
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