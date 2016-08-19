/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: PartPriceCalculation
 * Description: Used for Calculation of part price tax.
**/
public with sharing class PartPriceCalculation {
	
	/**
     * Name: onPriceLevelAssignment
     * Desc: Calculate Tax accroding to Tax logic
     * @param:  (1) priceLevel_baseValueField - String - Picklist Value of Part Price Base field of Price Level
     			(2) priceLevel_discountMarkup - Decimal - Discount Markup field value of Price Level
     			(3) COLineItemRecords - List<CO_Line_Item__c> - List of CO Line Items records.
     			(4) colineItemIdToPartRecordMap - Map<Id, Sobject> - Map of Id and Sobject
     														   Key - Id - Co line Item Id
     														   Value - SObject - Corresponding Part Record.
     * @return: 
    **/
	public static void onPriceLevelAssignment(String priceLevel_baseValueField, Decimal priceLevel_discountMarkup, List<CO_Line_Item__c> COLineItemRecords, Map<Id, Sobject> colineItemIdToPartRecordMap) {
		if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		for(CO_Line_Item__c COlineItem : COLineItemRecords) {
			String pricingField = '';
			if(priceLevel_baseValueField == 'Price') {
				pricingField = 'Retail_Price__c';
			} else if(priceLevel_baseValueField == 'MSRP') {
				pricingField = 'MSRP__c';
			} else if(priceLevel_baseValueField == 'Cost') {
				pricingField = 'Last_Cost__c';
			} else if(priceLevel_baseValueField == 'Average Cost') {
				pricingField = 'Average_Cost__c';
			}
			if(colineItemIdToPartRecordMap.get(COlineItem.Id).get(pricingField) == null) {
				colineItemIdToPartRecordMap.get(COlineItem.Id).put(pricingField, 0);
			}
			Decimal baseValue = Decimal.valueOf(String.valueOf(colineItemIdToPartRecordMap.get(COlineItem.Id).get(pricingField)));
			
			COlineItem.Retail__c = baseValue + (baseValue * priceLevel_discountMarkup / 100);
			COlineItem.Price__c = COlineItem.Retail__c ;
		}
		
		if(COLineItemRecords.size() > 0) {
			update COLineItemRecords;
		}
	}
}