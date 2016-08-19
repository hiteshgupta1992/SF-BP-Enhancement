/**
 * Author: Tarun Khandelwal
 * Since: July 01, 2016
 * Name: TaxExemptions
 * Description: Apex class to handle JSON related oprations of Tax Exemptions object.
**/
public with sharing class TaxExemptions {
    
    public String TaxExemptionId;
	public String CustomerId;
	public String CustomerName;
	public String SalesTaxItemId;
	public String SalesTaxName;
	public String Description;
	public Decimal Rate;
	public Boolean IsSelected;
	
	public TaxExemptions(Tax_Exemption__c taxExemptionRec, List<String> appliesToList) {
		this.TaxExemptionId = taxExemptionRec.Id;
		this.CustomerName = taxExemptionRec.Customer__r.Name;
		this.CustomerId = taxExemptionRec.Customer__c;
		this.SalesTaxItemId = taxExemptionRec.Sales_Tax_Item__c;
		this.SalesTaxName = taxExemptionRec.Sales_Tax_Item__r.Name__c;
		this.Rate = taxExemptionRec.Sales_Tax_Item__r.Rate__c;
		this.Description = '';
		if(appliesToList != null) {
			for(String appliesTo : appliesToList) {
				this.Description += appliesTo + ', ';
			}
		}
		if(this.Description.length() > 0) {
			this.Description = this.Description.subString(0, this.Description.length() - 2);
		}
	}
	
	public TaxExemptions(Sales_Tax_Item__c salesTaxItemRec, List<String> appliesToList) {  
		this.SalesTaxItemId = salesTaxItemRec.Id;
		this.SalesTaxName = salesTaxItemRec.Name__c;
		//this.Description = salesTaxItemRec.Forms_Label__c;
		this.Rate = salesTaxItemRec.Rate__c;
		if(salesTaxItemRec.Tax_Exemptions__r.size() > 0) {
			this.IsSelected = true;
			this.TaxExemptionId = salesTaxItemRec.Tax_Exemptions__r[0].Id;
		} else {
			this.IsSelected = false;
		}
		this.Description = '';
		if(appliesToList != null) {
			for(String appliesTo : appliesToList) {
				this.Description += appliesTo + ', ';
			}
		}
		if(this.Description.length() > 0) {
			this.Description = this.Description.subString(0, this.Description.length() - 2);
		}
	}
	
	
	/**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/ 
    public static List<String> fieldsList(){
        List<String> taxExemptionFields = new List<String>{	'Id',
	        												'Customer__c',
	        												'Customer__r.Name',
		                                                   	'Description__c',
		                                                   	'Sales_Tax_Item__c',
		                                                   	'Sales_Tax_Item__r.Name__c',
		                                                   	'Sales_Tax_Item__r.Forms_Label__c',
		                                                   	'Sales_Tax_Item__r.Rate__c'
		                                               	};
        return taxExemptionFields;
    }
}