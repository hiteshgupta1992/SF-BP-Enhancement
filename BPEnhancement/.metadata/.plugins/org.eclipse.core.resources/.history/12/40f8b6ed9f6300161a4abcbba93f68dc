/**
* Author: 
* Since: July 4, 2016
* Name: PriceAndTaxWrapper
* Description: Apex class to wrap variables for price and tax section in user settings page
**/

global with sharing class PriceAndTaxWrapper {
    
    public String regionId;
    public String stateId;
    public String taxId;
    public String timezoneId;
    
    public String defaultLaborTax;
    public String defaultVendorItemTax;
    public String defaultPartTax;
    public String defaultFeeTax;
    public String orderingTaxRate;
    
    public boolean priceIncludeTax;
    public String defaultPriceLevel;
    
    public PriceAndTaxWrapper(Price_Level__c defaultPriceLevelRec){
        setConfigurationData(defaultPriceLevelRec);
    }
        
    public void setConfigurationData(Price_Level__c defaultPriceLevelRec){
        
        defaultLaborTax = Configurations__c.getOrgDefaults().Default_Tax_on_Labor__c == null ? '' : Configurations__c.getOrgDefaults().Default_Tax_on_Labor__c;
        defaultVendorItemTax = Configurations__c.getOrgDefaults().Default_Tax_on_Vendor_Product__c == null ? '' : Configurations__c.getOrgDefaults().Default_Tax_on_Vendor_Product__c;
        defaultPartTax = Configurations__c.getOrgDefaults().Default_Tax_on_Part__c == null ? '' : Configurations__c.getOrgDefaults().Default_Tax_on_Part__c;
        defaultFeeTax = Configurations__c.getOrgDefaults().Default_Tax_on_Fee__c == null ? '' : Configurations__c.getOrgDefaults().Default_Tax_on_Fee__c;
        orderingTaxRate = Configurations__c.getOrgDefaults().Default_Tax_on_Unit__c == null ? '' : Configurations__c.getOrgDefaults().Default_Tax_on_Unit__c;
        priceIncludeTax = Configurations__c.getOrgDefaults().Tax_Included_Pricing__c;
        regionId = Configurations__c.getOrgDefaults().Country_Id__c == null ? '' : Configurations__c.getOrgDefaults().Country_Id__c;
        stateId = Configurations__c.getOrgDefaults().State_Id__c == null ? '' : Configurations__c.getOrgDefaults().State_Id__c;
        timezoneId= Configurations__c.getOrgDefaults().Time_Zone__c == null ? '' : Configurations__c.getOrgDefaults().Time_Zone__c;
        taxId= Configurations__c.getOrgDefaults().Tax_Id__c == null ? '' : Configurations__c.getOrgDefaults().Tax_Id__c;
        defaultPriceLevel = defaultPriceLevelRec.Id == null ? '' : String.valueOf(defaultPriceLevelRec.Id).substring(0, 15);
    }
}