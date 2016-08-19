/**
 * Author: Tarun Khandelwal
 * Since: May 25, 2015
 * Name: SalesTax
 * Description: Apex class to handle JSON related oprations of SalesTax object.
**/
public with sharing class SalesTax {
	
	// Default
	public Boolean IsDefault;
	
	// Id
	public String Id;
	
	// Name
	public String SalesTaxName;
	
	// Constructor
    public SalesTax(Sales_Tax__c salesTaxRec) {
    	this.SalesTaxName = salesTaxRec.Name__c ;
    	this.Id = salesTaxRec.Id;
    	this.IsDefault = salesTaxRec.Default__c;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> salesTaxFields = new List<String>{ 'Id',
	                                                    'Name__c', 
	                                                    'Default__c',
	                                                    'Active__c'
                                               		 };
        return salesTaxFields;
    }
}