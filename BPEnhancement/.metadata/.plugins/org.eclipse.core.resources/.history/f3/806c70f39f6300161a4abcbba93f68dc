/**
 * Author: Tarun Khandelwal
 * Since: June 27, 2016
 * Name: TaxUtility
 * Description: Controller Class related to Tax 
**/
public with sharing class TaxUtility {
    
    public static String getApplicableList() {
        return getApplicableList(null); 
    }
    
    public static String getApplicableList(String defaultSalesTaxId) {
        List<Sales_Tax__c> salesTaxList = SOQLUtil.getSalesTax(new List<Id>());
        Boolean isTaxIncludingPricing = checkForTaxIncludingPricing();
        return system.JSON.serialize(new Tax(isTaxIncludingPricing, salesTaxList, defaultSalesTaxId));
    }
    
    private static Boolean checkForTaxIncludingPricing() {
        return Configurations__c.getOrgDefaults().Tax_Included_Pricing__c;
    }
    
    public class Tax {
        public Boolean IsTaxIncludingPricing;
        public List<SalesTax> SalesTaxList;
        
        public Tax(Boolean isTaxIncludingPricing, List<Sales_Tax__c> salesTaxList, String defaultSalesTaxId) {
            this.IsTaxIncludingPricing = isTaxIncludingPricing;
            this.SalesTaxList = new List<SalesTax>();
            
            for(Sales_Tax__c salesTaxRec : salesTaxList) {
                String salesTaxId = salesTaxRec.Id;
                if(defaultSalesTaxId != null && salesTaxId.contains(defaultSalesTaxId)) {
                    this.SalesTaxList.add(new SalesTax(salesTaxRec, true));
                } else {
                    this.SalesTaxList.add(new SalesTax(salesTaxRec, false));
                }
            }
        }
    }
    
    
    public class SalesTax {
        
        public String Name;
        public String Id;
        public Decimal TaxRate;
        public Boolean IsDefault;
        
        public SalesTax(Sales_Tax__c salesTaxRec, Boolean isDefault) {
            this.Name = salesTaxRec.Name__c;
            this.Id = salesTaxRec.Id;
            this.IsDefault = isDefault;
            this.TaxRate = (salesTaxRec.Rate__c != null) ? salesTaxRec.Rate__c : 0;
        }
    }
    
}