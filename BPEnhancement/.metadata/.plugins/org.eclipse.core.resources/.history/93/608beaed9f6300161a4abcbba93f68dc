/**
 * Author: Tarun Khandelwal
 * Since: May 25, 2015
 * Name: PriceLevel
 * Description: Apex class to handle JSON related oprations of PriceLevel object.
**/
public with sharing class PriceLevel {

	// Actve
	public Boolean IsActive;
	
	// Default
	public Boolean IsDefault;
	
	// Name
	public String PriceLevelName;
	
	// Part_Price_Base__c
	public String PartPriceBase;
	
	// Discount_Markup__c
	public Decimal Discount;
	
	// Labour_Rate__c
	public Decimal LabourRate;
	
	// Description__c
	public String Description;
	
	// Id
	public String Id;
	
	// // Constructor
    public PriceLevel(Price_Level__c priceLevelRec) {
    	this.PriceLevelName = priceLevelRec.Name__c ;
    	this.Id = priceLevelRec.Id;
    	this.IsDefault = priceLevelRec.Default__c;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> priceLevelFields = new List<String>{ 'Id',
	                                                    'Name__c', 
	                                                    'Default__c',
	                                                    'Active__c'
                                               		 };
        return priceLevelFields;
    }
}