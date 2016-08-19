/**
 * Author: Tarun Khandelwal
 * Since: July 08, 2015
 * Name: Category
 * Description: Apex class to handle JSON related oprations of Category object.
**/
public with sharing class Category {
	
	// Id
	public String Id;
	
	// Name
	public String CategoryName;
	
	// Default
	public Boolean IsDefault;
	
	// Constructor
    public Category(Category__c categoryRec) {
    	this.CategoryName = categoryRec.Name;
    	this.IsDefault = categoryRec.Default__c;
    	this.Id = categoryRec.Id;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> categoryFields = new List<String>{ 'Id',
	                                                    'Name', 
	                                                    'Active__c',
	                                                    'Default__c'
                                               		 };
        return categoryFields;
    }
}