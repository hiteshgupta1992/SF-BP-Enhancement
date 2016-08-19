/**
 * Author: Tarun Khandelwal
 * Since: Oct. 13, 2014
 * Name: SalesTaxItemWrapper
 * Description: Service class which .
**/
global with sharing class SalesTaxItemWrapper implements Comparable {
	public Boolean Is_included;
	public Sales_Tax_Item__c salesTaxItem;
	
	public SalesTaxItemWrapper(Boolean Is_included, Sales_Tax_Item__c salesTaxItem) {
		this.Is_included = Is_included;
		this.salesTaxItem = salesTaxItem;
	}
	
	global Integer compareTo(Object compareTo) {
		SalesTaxItemWrapper compareToWrap = ((SalesTaxItemWrapper)compareTo);
		Integer returnValue = 0;
		
		Sales_Tax_Item__c salesTaxItemCompareTo = compareToWrap.salesTaxItem;
		if( (this.Is_included && compareToWrap.Is_included) || this.Is_included == compareToWrap.Is_included){
			
			// Check Active
			if( (salesTaxItem.Active__c && salesTaxItemCompareTo.Active__c) || salesTaxItem.Active__c == salesTaxItemCompareTo.Active__c ){
				// Check Name
				if(salesTaxItem.Name__c > salesTaxItemCompareTo.Name__c){
					returnValue = -1;
				}else{
					returnValue = 1;
				}
			}else if(salesTaxItem.Active__c){
				returnValue = 1;
			}else{
				returnValue = -1;
			}
			
		}else if(this.Is_included){
			returnValue = 1;
		}else{
			returnValue = -1;
		}
		
		return returnValue * -1;
	}
}