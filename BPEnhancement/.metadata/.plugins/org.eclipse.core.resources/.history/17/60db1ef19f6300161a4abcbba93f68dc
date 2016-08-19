/**
 * Author: Tarun Khandelwal
 * Since: Oct. 16, 2014
 * Name: SalesTaxItemTriggerHelper
 * Description: Helper class for triggers on Sales Tax Item object
**/
public with sharing class SalesTaxItemTriggerHelper {
	
	public static Map<Id,Sales_Tax_Item__c> oldMap = new Map<Id,Sales_Tax_Item__c>();
	
	public static Map<Id,Sales_Tax_Item__c> newMap = new Map<Id,Sales_Tax_Item__c>();
	
	public static List<Sales_Tax_Item__c> oldList = new List<Sales_Tax_Item__c>();
	
	public static List<Sales_Tax_Item__c> newList = new List<Sales_Tax_Item__c>();
	
	/**
     * Name: beforeDeleteOperations
     * Desc: Delete all related Applicable Tax records.
     * @param: 
     * @return: 
    **/
	public static void beforeDeleteOperations(){
		if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Applicable_Taxes__c> listOfAssociatedTaxes = [Select ID from Applicable_Taxes__c where Sales_Tax_Item__c IN :oldMap.keyset()];
		if(listOfAssociatedTaxes.size() > 0){
			if(AccessControl.ifObjectIsDeletable('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
			delete listOfAssociatedTaxes;	
		}
	}
	
	/**
     * Name: afterUpdateOperation
     * Desc: Delete all related Applicable Tax records and insert them again to the related Sales Tax Item record.
     * @param: 
     * @return: 
    **/
	public static void afterUpdateOperation() {
		insertApplicableTaxes();
		List<Sales_Tax_Item__c> validSalesTaxItemList = checkForPartExemptionsList();
		if(validSalesTaxItemList.size() > 0) {
			deleteRelatedTaxExemptoins(validSalesTaxItemList);
		}
	}
	
	private static List<Sales_Tax_Item__c> checkForPartExemptionsList() {
		List<Sales_Tax_Item__c> validSalesTaxItemList = new List<Sales_Tax_Item__c>();
		for(Sales_Tax_Item__c salesTaxItemRec : newList) {
			if(oldMap.get(salesTaxItemRec.Id).Active__c && !newMap.get(salesTaxItemRec.Id).Active__c) {
				validSalesTaxItemList.add(salesTaxItemRec);
			}
		}
		return validSalesTaxItemList;
	}
	
	private static void deleteRelatedTaxExemptoins(List<Sales_Tax_Item__c> validSalesTaxItemList) {
		List<Id> salesTaxItemIdList = new List<Id>();
		for(Sales_Tax_Item__c salesTaxItemRec : validSalesTaxItemList) {
			salesTaxItemIdList.add(salesTaxItemRec.Id);
		}
		if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Tax_Exemption__c> taxExemptionList = [select Id from Tax_Exemption__c where Sales_Tax_Item__c IN: salesTaxItemIdList];
		
		if(taxExemptionList.size() > 0) {
			if(AccessControl.ifObjectIsDeletable('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
			delete taxExemptionList;
		}
	}
	
	private static void insertApplicableTaxes() {
     
		if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Applicable_Taxes__c> listOfAssociatedTaxes = [Select ID, Sales_Tax__c from Applicable_Taxes__c where Sales_Tax_Item__c IN :oldMap.keyset()];
		
		// If there is no applicable Tax, No need to check further
		if(listOfAssociatedTaxes.size() == 0) {
			return;
		}
		
		Boolean isUpdateAppTax = false;
		for(Sales_Tax_Item__c salesTaxItem : newList) {
			if(salesTaxItem.Rate__c != oldMap.get(salesTaxItem.Id).Rate__c) {
				isUpdateAppTax = true;
			}
		}
		
		// If there is no change in rate field, no need to move ahead
		if(!isUpdateAppTax) {
			return;
		}
		
		Set<Id> salesTaxIdSet = new Set<Id>();
		for(Applicable_Taxes__c appTax : listOfAssociatedTaxes) {
			salesTaxIdSet.add(appTax.Sales_Tax__c);
		}
		if(AccessControl.ifObjectIsDeletable('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
		delete listOfAssociatedTaxes;
		
		List<Applicable_Taxes__c> appTaxToBeInsert = new List<Applicable_Taxes__c>();
		
		for(Sales_Tax_Item__c salesTaxItem : newList) {
			for(Id salesTaxId : salesTaxIdSet) {
				Applicable_Taxes__c appTax = new Applicable_Taxes__c();
				appTax.Sales_Tax__c = salesTaxId;
				appTax.Sales_Tax_Item__c = salesTaxItem.Id;
				appTaxToBeInsert.add(appTax);
			}
		}
		
		if(appTaxToBeInsert.size() > 0) {
			if(AccessControl.ifObjectFieldIsCreateable('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
			insert appTaxToBeInsert;
		}
	}

}