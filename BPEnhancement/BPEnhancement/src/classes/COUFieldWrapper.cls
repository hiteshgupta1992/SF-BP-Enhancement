/**
 * Author: Tarun Khandelwal
 * Since: May 26, 2015
 * Name: COUFieldWrapper
 * Description: Apex class to handle JSON related oprations of COUField Wrapper.
**/
public with sharing class COUFieldWrapper {
	
	// Country List
	public List<Country> CountryList;
    
    // Country Wrapper / State
    public List<CountryWrapper> StateList;
    
    // Price Level
    public List<PriceLevel> PriceLevelList;
    
    // Sales Tax
    public List<SalesTax> SalesTaxList;
    
    // Unit Make
    public List<UnitMake> UnitMakeList; 
    
    // Unit Model
    public List<UnitMakeWrapper> UnitModelList;
    
    // Unit Sub Model
    public List<UnitMakeWrapper> UnitSubModelList;
    
    // Category List
    public List<Category> CategoryList;
    
    // Transaction type List
    public List<KitHeader.TransactionType> TransactionTypeList;
    
    // Constructor
    public COUFieldWrapper(List<Country__c> countryList, List<Country__c> countryWrapperList, List<Sales_Tax__c> salesTaxList, 
    							List<Price_Level__c> priceLevelList, List<Unit_Make__c> unitMakeList, List<Unit_Make__c> unitMakeWrapperList, 
    							List<Category__c> categoryList) {
        
        // Initilaize all list and objects
        this.CountryList = new List<Country>();
        this.StateList = new List<CountryWrapper>();
        this.PriceLevelList = new List<PriceLevel>();
        this.SalesTaxList = new List<SalesTax>();
        this.UnitMakeList = new List<UnitMake>();
        this.UnitModelList = new List<UnitMakeWrapper>();
        this.UnitSubModelList = new List<UnitMakeWrapper>();
        this.CategoryList = new List<Category>();
        
        for(Country__c countryRec : countryList) {
            this.CountryList.add(new Country(countryRec));
        }
        
        this.StateList.add(new CountryWrapper(countryWrapperList));
        
        for(Price_Level__c priceLevelRec : priceLevelList) {
        	this.PriceLevelList.add(new PriceLevel(priceLevelRec));
        }
        
        for(Sales_Tax__c salesTaxRec : salesTaxList) {
            this.SalesTaxList.add(new SalesTax(salesTaxRec));
        }
        for(Unit_Make__c unitMakeRec  : unitMakeList) {
            this.UnitMakeList.add(new UnitMake(unitMakeRec));
        }
        this.UnitModelList.add(new UnitMakeWrapper(unitMakeWrapperList));
        this.UnitSubModelList.addAll(this.UnitModelList);
        for(Category__c categoryRec : categoryList) {
        	this.CategoryList.add(new Category(categoryRec));
        }
    }
    
    
    public COUFieldWrapper(List<Unit_Make__c> unitMakeList, List<Unit_Make__c> unitMakeWrapperList, 
    							List<Category__c> categoryList, List<Transaction_Type__c> ttList ) {
        
        // Initilaize all list and objects
        this.UnitMakeList = new List<UnitMake>();
        this.UnitModelList = new List<UnitMakeWrapper>();
        this.UnitSubModelList = new List<UnitMakeWrapper>();
        this.CategoryList = new List<Category>();
        this.TransactionTypeList = new List<KitHeader.TransactionType>();
        
        for(Unit_Make__c unitMakeRec  : unitMakeList) {
            this.UnitMakeList.add(new UnitMake(unitMakeRec));
        }
        this.UnitModelList.add(new UnitMakeWrapper(unitMakeWrapperList));
        this.UnitSubModelList.addAll(this.UnitModelList);
        for(Category__c categoryRec : categoryList) {
        	this.CategoryList.add(new Category(categoryRec));
        }
        
        for(Transaction_Type__c ttRec : ttList) {
        	this.TransactionTypeList.add(new KitHeader.TransactionType(ttRec));
        }
        
    }
    
}