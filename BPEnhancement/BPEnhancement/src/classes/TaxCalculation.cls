/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: TaxCalculation
 * Description: Used for Calculation of all type of taxes.
**/
public with sharing class TaxCalculation {
	
	private static String PART_PRICE_FIELD_LABEL = 'Price';
	private static String PART_PRICE_FIELD_API_NAME = 'Retail_Price__c';
	
	private static String PART_MSRP_FIELD_LABEL = 'MSRP';
	private static String PART_MSRP_FIELD_API_NAME = 'MSRP__c';
	
	private static String PART_LAST_COST_FIELD_LABEL = 'Cost';
	private static String PART_LAST_COST_FIELD_API_NAME = 'Last_Cost__c';
	
	private static String PART_AVEGARE_COST_FIELD_LABEL = 'Average Cost';
	private static String PART_AVEGARE_COST_FIELD_API_NAME = 'Average_Cost__c';
	
	private static String COLI_TAX_FIELD_API_NAME = 'Tax__c'; 
	private static Set<String> COST_FIELDS_SET = new Set<String>{'Last_Cost__c', 'Average_Cost__c'};
	/**
     * Name: partPriceCalculation
     * Desc: Calculate Tax accroding to Tax logic
     * @param:  (1) priceLevel_baseValueField - String - Picklist Value of Part Price Base field of Price Level
     			(2) priceLevel_discountMarkup - Decimal - Discount Markup field value of Price Level
     			(3) COLineItemRecords - List<CO_Line_Item__c> - List of CO Line Items records.
     			(4) partIdToPartRecordMap -  Map<Id, Part__c> - Map of Id and Part Object
     * @return: List<CO_Line_Item__c>
    **/
	public static List<CO_Line_Item__c> partPriceCalculation(String priceLevel_baseValueField, Decimal priceLevel_discountMarkup, List<CO_Line_Item__c> COLineItemRecords, Map<Id, Part__c> partIdToPartRecordMap) {
		for(CO_Line_Item__c COlineItem : COLineItemRecords) {
			if(COlineItem.CO_Kit_Header__c != null) {
                continue;
            }
			String pricingField = '';
			if(priceLevel_baseValueField == PART_PRICE_FIELD_LABEL) {
				pricingField = PART_PRICE_FIELD_API_NAME;
			} else if(priceLevel_baseValueField == PART_MSRP_FIELD_LABEL) {
				pricingField = PART_MSRP_FIELD_API_NAME;
			} else if(priceLevel_baseValueField == PART_LAST_COST_FIELD_LABEL) {
				pricingField = PART_LAST_COST_FIELD_API_NAME;
			} else if(priceLevel_baseValueField == PART_AVEGARE_COST_FIELD_LABEL) {
				pricingField = PART_AVEGARE_COST_FIELD_API_NAME;
			}
			
			if(COlineItem.Part__c == null) {
				continue;
			}
			
			if(partIdToPartRecordMap.get(COlineItem.Part__c).get(pricingField) == null) {
				partIdToPartRecordMap.get(COlineItem.Part__c).put(pricingField, 0);
				COlineItem.Retail__c = 0;
			} else {
				Decimal baseValue = Decimal.valueOf(String.valueOf(partIdToPartRecordMap.get(COlineItem.Part__c).get(pricingField)));
				COlineItem.Retail__c = baseValue + (baseValue * priceLevel_discountMarkup / 100);
			}
			COlineItem.Price__c = COlineItem.Retail__c ;
		}
		return COLineItemRecords;
	}
	
	/**
     * Name: partPriceCalculation1
     * Desc: Calculate Tax accroding to Tax logic
     * @param:  (1) priceLevel_baseValueField - String - Picklist Value of Part Price Base field of Price Level
                (2) priceLevel_discountMarkup - Decimal - Discount Markup field value of Price Level
                (3) COlineItem - CO_Line_Item__c - CO Line Items record.
                (4) partIdToPartRecordMap -  Map<Id, Part__c> - Map of Id and Part Object
     * @return: void
    **/
    public static void partPriceCalculation1(String priceLevel_baseValueField, Decimal priceLevel_discountMarkup, CO_Line_Item__c COlineItem, 
    											Map<Id, Part__c> partIdToPartRecordMap, Map<Id, Fee__c> feeIdToFeeRecordMap) {
        
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        if(coLineItem.Part__c != null) {
	        String pricingField = '';
	        if(priceLevel_baseValueField == PART_PRICE_FIELD_LABEL) {
	            pricingField = PART_PRICE_FIELD_API_NAME;
	        } else if(priceLevel_baseValueField == PART_MSRP_FIELD_LABEL) {
	            pricingField = PART_MSRP_FIELD_API_NAME;
	        } else if(priceLevel_baseValueField == PART_LAST_COST_FIELD_LABEL) {
	            pricingField = PART_LAST_COST_FIELD_API_NAME;
	        } else if(priceLevel_baseValueField == PART_AVEGARE_COST_FIELD_LABEL) {
	            pricingField = PART_AVEGARE_COST_FIELD_API_NAME;
	        }
	        
	        if(partIdToPartRecordMap.get(coLineItem.Part__c).get(pricingField) == null) {
	            partIdToPartRecordMap.get(coLineItem.Part__c).put(pricingField, 0);
	            COlineItem.Retail__c = 0;
	        } else {
	            Decimal baseValue = Decimal.valueOf(String.valueOf(partIdToPartRecordMap.get(coLineItem.Part__c).get(pricingField)));
	            if(isTaxIncludingPricing && !COST_FIELDS_SET.contains(pricingField) && partIdToPartRecordMap.get(coLineItem.Part__c).Applicable_Tax__c != null) {
	                Decimal appTaxRate = partIdToPartRecordMap.get(coLineItem.Part__c).Applicable_Tax__r.Rate__c;
	                if(appTaxRate == -100 || appTaxRate == null) { // To handle divide by zero error
	                    appTaxRate = 0;
	                }
	                Decimal preTaxPricing = baseValue / (1 + (appTaxRate / 100));
	                COlineItem.Retail__c = preTaxPricing + (preTaxPricing * priceLevel_discountMarkup / 100);
	            } else {
	                COlineItem.Retail__c = baseValue + (baseValue * priceLevel_discountMarkup / 100);
	            }
	        }
        
        } else if(COlineItem.Fee__c != null) {
        	Decimal feePrice = feeIdToFeeRecordMap.get(coLineItem.Fee__c).Price__c;
        	if(isTaxIncludingPricing) {
        		Decimal appTaxRate = feeIdToFeeRecordMap.get(coLineItem.Fee__c).Applicable_Tax__r.Rate__c;
                if(appTaxRate == -100 || appTaxRate == null) { // To handle divide by zero error
                    appTaxRate = 0;
                }
                Decimal preTaxPricing = feePrice / (1 + (appTaxRate / 100));
                //COlineItem.Retail__c = preTaxPricing + (preTaxPricing * priceLevel_discountMarkup / 100);
                COlineItem.Retail__c = preTaxPricing;
        	} else {
        		//COlineItem.Retail__c = feePrice + (feePrice * priceLevel_discountMarkup / 100);
        		COlineItem.Retail__c = feePrice;
        	}
        } 
        
        if(trigger.isInsert) {
            COlineItem.Price__c = COlineItem.Retail__c ;
            COlineItem.Actual_Kit_Price__c = COlineItem.Retail__c ;
        }
    }
    /**
     * Name: salesTaxCalculation
     * Desc: Calculate Sales Tax accroding to logic
     * @param:  (1) salesTaxIdList - List<Id> - List of sales tax records Ids
     			(2) partIdToSalesTaxItemIdsMap - Map<Id, Set<Id>> - Map of part Id and sales tax item records
     											     Key - 			Part Record Id
     											     Value - 		Set of sales tax item ids
     			(3) COHeaderList - List<CO_Header__c> - List of CO Header records.
     			(4) COHeaderIdToCOLineItemRecordsMap - Map<Id, List<Sobject>> - Map of Id and Sobject
     														   Key - Id - CO Header Id
     														   Value - SObject - Corresponding CO line item records
     			(5) defaultSalesTax - List<Sales_Tax__c> - Default sales tax		 									   
     * @return: List<CO_Line_Item__c>
    **/
	public static List<CO_Line_Item__c> salesTaxCalculation(List<Id> salesTaxIdList, Map<Id, Set<Id>> partIdToSalesTaxItemIdsMap, List<CO_Header__c> COHeaderList, Map<Id, List<Sobject>> COHeaderIdToCOLineItemRecordsMap, List<Sales_Tax__c> defaultSalesTax ) {
		if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<Applicable_Taxes__c> applicableTaxList = [select Sales_Tax_Item__c, Sales_Tax__c, Sales_Tax_Item__r.Tax_Parts__c, Sales_Tax_Item__r.Rate__c from Applicable_Taxes__c where Sales_Tax__c IN : salesTaxIdList];
    	Map<Id, List<Applicable_Taxes__c>> salesTaxIdToAppTaxRecordsMap = new Map<Id, List<Applicable_Taxes__c>>();
    	
    	for(Applicable_Taxes__c appTax : applicableTaxList) {
    		List<Applicable_Taxes__c> appTaxRecordList = new List<Applicable_Taxes__c>();
    		if(!appTax.Sales_Tax_Item__r.Tax_Parts__c) {
    			continue;
    		}
    		if(salesTaxIdToAppTaxRecordsMap.containsKey(appTax.Sales_Tax__c)) {
    			appTaxRecordList = salesTaxIdToAppTaxRecordsMap.get(appTax.Sales_Tax__c);
    		} 
    		appTaxRecordList.add(appTax);
    		salesTaxIdToAppTaxRecordsMap.put(appTax.Sales_Tax__c, appTaxRecordList);
    	}
    	
    	Map<Id, Decimal> salesTaxIdToTaxRateMap = new Map<Id, Decimal>();
    	for(Id salesTaxId : salesTaxIdToAppTaxRecordsMap.keyset()) {
    		Decimal salesTaxRate = 0;
    		for(Applicable_Taxes__c appTax : salesTaxIdToAppTaxRecordsMap.get(salesTaxId)) {
    			salesTaxRate += appTax.Sales_Tax_Item__r.Rate__c;
    		}
    		salesTaxIdToTaxRateMap.put(salesTaxId, salesTaxRate);
    	}
    	
    	List<Sobject> coLineItemToUpdate = new List<Sobject>();
    	for(CO_Header__c COHeaderRec : COHeaderList) {
    		Id salesTaxId;
			if(COHeaderRec.Customer__r.Sales_Tax__c == null) {
				salesTaxId = defaultSalesTax[0].Id;
			} else {
				salesTaxId = COHeaderRec.Customer__r.Sales_Tax__c;
			}
			if(COHeaderIdToCOLineItemRecordsMap.containsKey(COHeaderRec.Id)) {
	    		for(Sobject coLineItem : COHeaderIdToCOLineItemRecordsMap.get(COHeaderRec.Id)) {
	    			if(coLineItem.get('Part__c') == null) {
	    				continue;
	    			}
	    			Id partId = Id.valueOf(String.valueOf(coLineItem.get('Part__c')));
	    			Decimal exemptionRate = 0;
	    			if(salesTaxIdToAppTaxRecordsMap.containsKey(salesTaxId)) {
		    			for(Applicable_Taxes__c appTax : salesTaxIdToAppTaxRecordsMap.get(salesTaxId)) {
							if(partIdToSalesTaxItemIdsMap.get(partId).contains(appTax.Sales_Tax_Item__c)) {
								exemptionRate += appTax.Sales_Tax_Item__r.Rate__c;
							}
		    			} 
	    			}
	    			Decimal rate = 0;
	    			if(salesTaxIdToTaxRateMap.containsKey(salesTaxId)) {
						rate = salesTaxIdToTaxRateMap.get(salesTaxId);
	    			}
					coLineItem.put(COLI_TAX_FIELD_API_NAME, rate - exemptionRate);
					coLineItemToUpdate.add(coLineItem);
	    		}
			}
    	}
    	//system.assert(false, coLineItemToUpdate);
    	return coLineItemToUpdate;
	}
    public static List<CO_Line_Item__c> salesTaxCalculation2(List<Id> salesTaxIdList, Map<Id, Set<Id>> customerIdToSalesTaxItemIdsMap, List<CO_Line_Item__c> coLineItemList) {
        if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Applicable_Taxes__c> applicableTaxList = [SELECT Sales_Tax_Item__c, Sales_Tax__c, Sales_Tax_Item__r.Name__c, 
                                                            Sales_Tax_Item__r.Rate__c from Applicable_Taxes__c where Sales_Tax__c IN : salesTaxIdList];
        
        Map<Id, List<Applicable_Taxes__c>> salesTaxIdToAppTaxRecordsMap = new Map<Id, List<Applicable_Taxes__c>>();
        
        for(Applicable_Taxes__c appTax : applicableTaxList) {
            List<Applicable_Taxes__c> appTaxRecordList = new List<Applicable_Taxes__c>();
            if(salesTaxIdToAppTaxRecordsMap.containsKey(appTax.Sales_Tax__c)) {
                appTaxRecordList = salesTaxIdToAppTaxRecordsMap.get(appTax.Sales_Tax__c);
            } 
            appTaxRecordList.add(appTax);
            salesTaxIdToAppTaxRecordsMap.put(appTax.Sales_Tax__c, appTaxRecordList);
        }
        
        Map<Id, Decimal> salesTaxIdToTaxRateMap = new Map<Id, Decimal>();
        for(Id salesTaxId : salesTaxIdToAppTaxRecordsMap.keyset()) {
            Decimal salesTaxRate = 0;
            for(Applicable_Taxes__c appTax : salesTaxIdToAppTaxRecordsMap.get(salesTaxId)) {
                salesTaxRate += appTax.Sales_Tax_Item__r.Rate__c;
            }
            salesTaxIdToTaxRateMap.put(salesTaxId, salesTaxRate);
        }
        
        List<Sobject> coLineItemToUpdate = new List<Sobject>();
        List<Individual_Tax__c> individualTaxToInsert = new List<Individual_Tax__c>();
        for(CO_Line_Item__c coLineItemRec : coLineItemList) {
            Id salesTaxId;
            if(coLineItemRec.Part__r.Applicable_Tax__c != null) {
                salesTaxId = coLineItemRec.Part__r.Applicable_Tax__c;
            } else if(coLineItemRec.Fee__r.Applicable_Tax__c != null) {
                salesTaxId = coLineItemRec.Fee__r.Applicable_Tax__c;
            } 
            if(salesTaxId == null) {
            	continue;
            }
            
            Decimal exemptionRate = 0;
            if(salesTaxIdToAppTaxRecordsMap.containsKey(salesTaxId)) {
                for(Applicable_Taxes__c appTax : salesTaxIdToAppTaxRecordsMap.get(salesTaxId)) {
                    if(coLineItemRec.CO_Header__r.Customer__c != null && customerIdToSalesTaxItemIdsMap.get(coLineItemRec.CO_Header__r.Customer__c).contains(appTax.Sales_Tax_Item__c)) {
                        exemptionRate += appTax.Sales_Tax_Item__r.Rate__c;
                    
                    } else { // Individual sales Taxes
                    	Individual_Tax__c individualTaxRec = new Individual_Tax__c();
                    	individualTaxRec.CO_Line_Item__c = coLineItemRec.Id;
                    	if(coLineItemRec.Service_Order_Line_Item__c != null) {
                    		individualTaxRec.Service_Order_Line_Item__c = coLineItemRec.Service_Order_Line_Item__c;
                    	}
                    	individualTaxRec.Sales_Tax_Item_Name__c = appTax.Sales_Tax_Item__r.Name__c;
                    	individualTaxRec.Tax_Rate__c = appTax.Sales_Tax_Item__r.Rate__c;
                    	individualTaxToInsert.add(individualTaxRec);
                    }
                } 
            }
            Decimal rate = 0;
            if(salesTaxIdToTaxRateMap.containsKey(salesTaxId)) {
                rate = salesTaxIdToTaxRateMap.get(salesTaxId);
            }
            coLineItemRec.Tax__c = rate - exemptionRate;
            coLineItemToUpdate.add(coLineItemRec);
        }
        if(individualTaxToInsert.size() > 0) {
        	insert individualTaxToInsert;
        }
        return coLineItemToUpdate;
    }
}