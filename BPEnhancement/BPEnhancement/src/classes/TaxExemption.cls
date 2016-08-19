/**
 * Author: Ashish Garg
 * Since: Jun 27, 2015
 * Name: TaxExemption
 * Description: Apex class to handle JSON related oprations of Sales Tax object.
**/
global with sharing class TaxExemption {
	// Id
	public String Id;
	
	// Part Id
	public String PartId;
	
	// Sales Tax Id
	public String SalesTaxId;
	
	// Sales Tax name
	public String SalesTaxName;
	
	// Description
	public String Description;
	
	// Rate applied
	public Decimal Rate;
	
	// Constructor
    public TaxExemption(Part_Tax__c partTax) { 
        this.Id				= partTax.Id;
        this.PartId			= partTax.Part_ID__c;
        this.SalesTaxId		= partTax.Sales_Tax_Item__c;
        this.SalesTaxName	= partTax.Sales_Tax_Item__r.Name__c;
        this.Description	= partTax.Description__c;
        this.Rate			= partTax.Sales_Tax_Item__r.Rate__c;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: List of TaxExemption - Class Object
    **/
    /*public static List<TaxExemption> parse(String json) {
        return (List<TaxExemption>) System.JSON.deserialize(json, List<TaxExemption>.class);
    }*/
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> partTaxFields = new List<String>{	'Id',
        												'Part_ID__c',
	                                                   	'Description__c',
	                                                   	'Sales_Tax_Item__c',
	                                                   	'Sales_Tax_Item__r.Name__c',
	                                                   	'Sales_Tax_Item__r.Rate__c'
	                                               	};
        return partTaxFields;
    }
    
    /**
     * Name: getAllTaxExemptionsForPart
     * Desc: Get all related Tax Exemptions for a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     *			(2)pageSortAttrsJSON - String - Page Sort Attributes
     * @return: List of TaxExemption - Class Object
    **/
    /*public static List<TaxExemption> getAllTaxExemptionsForPart(Id partId, String pageSortAttrsJSON) {
    	RelatedListPaginationSorting pageSortAttrs = TaxExemption.parsePageAttrs(pageSortAttrsJSON);
		
		Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Sales_Tax_Item__r.Name__c', pageSortAttrs.sorting[0].sortDirection);
    	}
		
		List<TaxExemption> taxExemptions = new List<TaxExemption>();
		
		List<Part_Tax__c> partTaxesList = getPaginatedRecords(	SOQLUtil.getPartTaxesWithSalesTaxesForPart(partId, sortFieldMap),
																pageSortAttrs.taxExemptionsCurrentPage, 
    															pageSortAttrs.taxExemptionsPageSize 
															);
		for(Part_Tax__c partTax : partTaxesList) {
            taxExemptions.add(new TaxExemption(partTax));
        }
        
		return taxExemptions;
    }*/
    
    /**
     * Name: getPaginatedRecords
     * Desc: Get all related Tax Exemptions for a part record
     * @param:	(1) allrecords - List<sObject> - List of sObjects
     *			(2)currentPage - Integer - Current page Number
     *			(3)pageSize- Integer - No Of Records In a page
     * @return: List of Sobject
    **/
    public static List<sObject> getPaginatedRecords(List<sObject> allrecords, Integer currentPage, integer pageSize) {
    	List<sObject> objRecords = new List<sObject>();
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
     * Name: getTotalTaxExemptionsForPart
     * Desc: Get total count for related Tax Exemptions of a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalTaxExemptionsForPart(Id partId) {
		List<Part_Tax__c> partTaxesList = SOQLUtil.getPartTaxesWithSalesTaxesForPart(partId, null);
		return partTaxesList.size();
    }
    
    // Wrapper class to hold taxt exemption record and total tax exemption records in database for a part
    public class TaxExemptionWrapper {
    	// TaxExemption record
    	public TaxExemption TaxExemptionRecord;
    	
    	// Total count in database for a part
    	public Integer TotalTaxExemptions;
    	
    	// Total count in database for a part
    	public boolean isError;
    	
    	// Total count in database for a part
    	public String ErrorMsg;
    	
    	// Constructor
    	public TaxExemptionWrapper(Part_Tax__c TaxExemptionRecord, Id partId){
    		this.TaxExemptionRecord = new TaxExemption(TaxExemptionRecord);
    		this.TotalTaxExemptions = TaxExemption.getTotalTaxExemptionsForPart(partId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public TaxExemptionWrapper(String ErrorMsg){
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
    /*public static RelatedListPaginationSorting parsePageAttrs(String json) {
        return (RelatedListPaginationSorting) System.JSON.deserialize(json, RelatedListPaginationSorting.class);
    }*/
    
	 /**
	 * Name: RelatedListPaginationSorting
	 * Description: Wrapper class for related list pagination and sorting combination
	 **/
	 public class RelatedListPaginationSorting {
    	// Current page number
    	public Integer taxExemptionsCurrentPage;
    	
    	// Current page size
    	public Integer taxExemptionsPageSize;
    	
    	// Sorting list
    	public List<SortAttrs> sorting;
	}
    
     /**
	 * Name: SortAttrs
	 * Description: Wrapper class  SortAttrs for sorting attributes
	 **/
    // SortAttrs for sorting attributes
    public class SortAttrs {
    	// Field name
    	public String fieldName;
    	
    	// Sort direction
    	public String sortDirection;
    }
}