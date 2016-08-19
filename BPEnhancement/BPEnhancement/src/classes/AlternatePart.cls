/**
 * Author: Ashish Garg
 * Since: Jun 27, 2015
 * Name: AlternatePart
 * Description: Apex class to handle JSON related oprations of Alternate Part object.
**/
global with sharing class AlternatePart {
	// Id
	public String Id;
	
	// Is Preferred Alternate part
	public boolean IsPreferred;
	
	// Item description
	public String Description;
	
	// Status
	public String Status;
	
	// Qty available
	public Decimal Qty;
	
	// Retail price
	public Decimal Retail;
	
	// Relation
	public String Relation;
	
	// Main part Id
	public String PartId;
	
	// Main part number
	public String PartNumber;
	
	// Alternate part Id
	public String AlternatePartId;
	
	// Alternate part number
	public String AlternatePartNumber;
	
	public Boolean isReplacedByPresentOnCurrentPart;
	public Boolean isReplacedByPresentOnAlternatePart;
	
	public AlternatePart(Part_Alternates__c  partAlternate) {
		this.Id					= partAlternate.Id;
        this.Relation			= partAlternate.Relation__c;
		this.IsPreferred		= partAlternate.Preferred__c;
        this.PartId				= partAlternate.Part_ID__c;
        this.PartNumber			= partAlternate.Part_ID__r.Part_Number__c;
        
        this.AlternatePartId	= partAlternate.Alternate_Part_ID__c;
        this.Description		= partAlternate.Alternate_Part_ID__r.Description__c;
        this.Qty				= partAlternate.Alternate_Part_ID__r.AvailableParts__c;
        this.Retail				= partAlternate.Alternate_Part_ID__r.Retail_Price__c;
        this.AlternatePartNumber= partAlternate.Alternate_Part_ID__r.Part_Number__c;
        
        this.isReplacedByPresentOnCurrentPart = partAlternate.Part_ID__r.Is_Replaced_Part_Present__c;
        if(this.isReplacedByPresentOnCurrentPart) {
        	this.isReplacedByPresentOnCurrentPart = (this.Relation != 'Replaced By');
        }
        
        this.isReplacedByPresentOnAlternatePart = partAlternate.Alternate_Part_ID__r.Is_Replaced_Part_Present__c;
        if(this.isReplacedByPresentOnAlternatePart) {
        	this.isReplacedByPresentOnAlternatePart = (this.Relation != 'Replaces');
        }
        
        // Set Status Logic. Refer US - PA 004 - View Part - Left Sidebar
		if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
			this.Status = 'In Stock';
		} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c < partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c || (partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c 
					&& partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c != partAlternate.Alternate_Part_ID__r.Auto_reorder_Max__c) && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
			this.Status = 'Required';
		} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
			this.Status = 'Out of Stock';
		} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0 && partAlternate.Alternate_Part_ID__r.AvailableParts__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0) {
			this.Status = 'Committed';
		} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c > 0 ) {
			this.Status = 'On Order';
		} 
	}
	
	// Constructor
    public AlternatePart(Part_Alternates__c  partAlternate, boolean isDirectRelation) { 
        this.Id				= partAlternate.Id;
        this.Relation		= partAlternate.Relation__c;
        if(!isDirectRelation){
        	this.IsPreferred		= partAlternate.Preferred__c;
	        this.PartId				= partAlternate.Part_ID__c;
	        this.PartNumber			= partAlternate.Part_ID__r.Part_Number__c;
	        
	        this.AlternatePartId	= partAlternate.Alternate_Part_ID__c;
	        this.Description		= partAlternate.Alternate_Part_ID__r.Description__c;
	        this.Qty				= partAlternate.Alternate_Part_ID__r.AvailableParts__c;
	        this.Retail				= partAlternate.Alternate_Part_ID__r.Retail_Price__c;
	        this.AlternatePartNumber= partAlternate.Alternate_Part_ID__r.Part_Number__c;
	        
	        // Set Status Logic. Refer US - PA 004 - View Part - Left Sidebar
			if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'In Stock';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c < partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c || (partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c 
						&& partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c != partAlternate.Alternate_Part_ID__r.Auto_reorder_Max__c) && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'Required';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'Out of Stock';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0 && partAlternate.Alternate_Part_ID__r.AvailableParts__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0) {
				this.Status = 'Committed';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c > 0 ) {
				this.Status = 'On Order';
			} 
        } else {
        	this.IsPreferred		= partAlternate.Alternate_Preferred__c;
        	this.PartId				= partAlternate.Alternate_Part_ID__c;
	        this.PartNumber			= partAlternate.Alternate_Part_ID__r.Part_Number__c;
	        
	        this.AlternatePartId	= partAlternate.Part_ID__c;
	        this.Description		= partAlternate.Part_ID__r.Description__c;
	        this.Qty				= partAlternate.Part_ID__r.AvailableParts__c;
	        this.Retail				= partAlternate.Part_ID__r.Retail_Price__c;
	        this.AlternatePartNumber= partAlternate.Part_ID__r.Part_Number__c;
	        
	        // Set Status Logic. Refer US - PA 004 - View Part - Left Sidebar
			if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'In Stock';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c < partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c || (partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c 
						&& partAlternate.Alternate_Part_ID__r.Auto_reorder_Min__c != partAlternate.Alternate_Part_ID__r.Auto_reorder_Max__c) && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'Required';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0) {
				this.Status = 'Out of Stock';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c == 0 && partAlternate.Alternate_Part_ID__r.AvailableParts__c == 0 && partAlternate.Alternate_Part_ID__r.Qty_In_Stock__c > 0) {
				this.Status = 'Committed';
			} else if(partAlternate.Alternate_Part_ID__r.Qty_On_Order__c > 0 ) {
				this.Status = 'On Order';
			} 
        }
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: AlternatePart - Class Object
    **/
    public static List<AlternatePart> parse(String json) {
        return (List<AlternatePart>) System.JSON.deserialize(json, List<AlternatePart>.class);
    }
    
    /**
     * Name: getAllAlternatePartsForPart
     * Desc: Get all related alternate parts for a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    public static List<AlternatePart> getAllAlternatePartsForPart(Id partId, String pageSortAttrsJSON) {
    	RelatedListPaginationSorting pageSortAttrs = AlternatePart.parsePageAttrs(pageSortAttrsJSON);
    	
    	Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('Alternate_Part_ID__r.Description__c', pageSortAttrs.sorting[0].sortDirection);
    	}
    	List<AlternatePart> alternateParts = new List<AlternatePart>();
    	List<Part_Alternates__c> alternatePartsList = TaxExemption.getPaginatedRecords( SOQLUtil.getAlternatePartRecordsForPart(partId, sortFieldMap), 
    																					pageSortAttrs.alternatePartsCurrentPage, 
    																					pageSortAttrs.alternatePartsPageSize 
    																				);
		
        for(Part_Alternates__c partAlternate : alternatePartsList) {
        	alternateParts.add(new AlternatePart(partAlternate));
        }
		return alternateParts;
    }
    
    /**
     * Name: getTotalAlternatePartsForPart
     * Desc: Get total count for related Active Orders of a part record
     * @param:	(1) partId - String - Part Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalAlternatePartsForPart(Id partId) {
		List<Part_Alternates__c> alternatePartsList = SOQLUtil.getAlternatePartRecords(new Map<String, String>{'Part_ID__c' => partId});
		return alternatePartsList.size();
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> alternatePartsFields = new List<String>{'Id',
	                                                        'Preferred__c', 
	                                                        'Relation__c',
	                                                        'Alternate_Preferred__c',
	                                                        'Alternate_Part_ID__c',
	                                                        'Alternate_Part_ID__r.Description__c',
	                                                        'Alternate_Part_ID__r.AvailableParts__c',
	                                                        'Alternate_Part_ID__r.Retail_Price__c',
	                                                        'Alternate_Part_ID__r.Part_Number__c',
	                                                        'Alternate_Part_ID__r.Qty_In_Stock__c',
	                                                        'Alternate_Part_ID__r.Auto_reorder_Min__c',
															'Alternate_Part_ID__r.Qty_On_Order__c',
															'Alternate_Part_ID__r.Auto_reorder_Max__c',
															'Alternate_Part_ID__r.Is_Replaced_Part_Present__c',
	                                                        'Part_ID__c',
	                                                        'Part_ID__r.Is_Replaced_Part_Present__c',
	                                                        'Part_ID__r.Description__c',
	                                                        'Part_ID__r.AvailableParts__c',
	                                                        'Part_ID__r.Retail_Price__c',
	                                                        'Part_ID__r.Part_Number__c',
	                                                        'Part_ID__r.Qty_In_Stock__c',
	                                                        'Part_ID__r.Auto_reorder_Min__c',
															'Part_ID__r.Qty_On_Order__c',
															'Part_ID__r.Auto_reorder_Max__c'
	                                               		 };
        return alternatePartsFields;
    }
    
    // Wrapper class to hold taxt exemption record and total Alternate Part records in database for a part
    public class AlternatePartWrapper {
    	// AlternatePart record
    	public AlternatePart AlternatePartRecord;
    	
    	// Total count in database for a part
    	public Integer TotalAlternateParts;
    	
    	// Total count in database for a part
    	public boolean isError;
    	
    	// Total count in database for a part
    	public String ErrorMsg;
    	
    	// Constructor
    	public AlternatePartWrapper(Part_Alternates__c partAlternate, Id partId){
    		this.AlternatePartRecord = new AlternatePart(partAlternate);
    		this.TotalAlternateParts = AlternatePart.getTotalAlternatePartsForPart(partId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public AlternatePartWrapper(String ErrorMsg){
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
    	public Integer alternatePartsCurrentPage;
    	
    	// Current page size
    	public Integer alternatePartsPageSize;
    	
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