/**
 * Author: Ashish Garg
 * Since: Aug 8, 2015
 * Name: PaginationSorting
 * Description: Apex class to maintain paginatio nand sorting attributes for various grids
**/
public with sharing class PaginationSorting {
    // Current page number
    public Integer CurrentPage;
    
    // Current page size
    public Integer PageSize;
    
    // Sorting list
    public List<SortAttrs> Sorting;
    
    // Default Constructor
    public PaginationSorting(){
    	CurrentPage = 1;
    	PageSize = (Integer)General_Configurations__c.getInstance().Related_List_Page_Size__c;
    }
    
    /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: PaginationSorting - Class Object
    **/
    public static PaginationSorting parsePageAttrs(String json) {
        return (PaginationSorting) System.JSON.deserialize(json, PaginationSorting.class);
    }
    
    // SortAttrs for sorting attributes
	public class SortAttrs {
	    // Field name
	    public String FieldName;
	    
	    // Sort direction
	    public String SortDirection;
	    
	    public SortAttrs(String FieldName, String SortDirection){
	    	this.FieldName = FieldName;
	    	this.SortDirection = SortDirection;
	    }
	}
}