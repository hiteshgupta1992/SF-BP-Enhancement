/**
 * Author: Tarun Khandelwal
 * Since: March 27, 2014
 * Name: COLineItemTriggerHelper
 * Description: Trigger executes on after insert event of CO Line Item object
**/
public with sharing class COLineItemTriggerHelper {
    
    public static List<CO_Line_Item__c> COLineItemNewList = new List<CO_Line_Item__c>();
    public static List<CO_Line_Item__c> COLineItemOldList = new List<CO_Line_Item__c>();
    public static Map<Id, CO_Line_Item__c> COLineItemNewMap = new Map<Id, CO_Line_Item__c>();
    public static Map<Id, CO_Line_Item__c> COLineItemOldMap = new Map<Id, CO_Line_Item__c>();
    
    // Variable to stop nested looping
    public static Boolean isTriggerExecute = false;
    public static Boolean isVOLIRecToInsert = false;
    
    public static Boolean isVOLIRecToChange = true;
    public static Boolean isVOLIInsertFromVRPage = true;
    
    // List to store default sales tax level.
    public static List<Sales_Tax__c> defaultSalesTax;
    
    /**
     * Name: checkEnteryCondition
     * Desc: check entry condition for method
     * @param: 
     * @return: Boolean - true if entry condition is true
    **/
    public static Boolean checkEnteryCondition() {
        if(isTriggerExecute) {
            return false;
        }
        return true;
    }
    
    /**
     * Name: beforeInsertCalculation
     * Desc: Method executed on before insert operation of COLIs
     * @param: 
     * @return: 
    **/
    public static void beforeInsertCalculation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        Set<Id> partIdSet = new Set<Id>();
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(coLineItemRec.part__c != null) {
            	partIdSet.add(coLineItemRec.part__c);
            } 
        }
        Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Id, Average_Cost__c, Last_Cost__c, MSRP__c, Retail_Price__c, 
        																AvailableParts__c, Qty_Committed__c, Applicable_Tax__c, Applicable_Tax__r.Rate__c
        																from Part__c where Id IN : partIdSet]);
        
        if(entryConditionForBeforeInsertCommittedLogic()) {
            qytComittedLogicInCaseOfInsert(partIdToPartRecordMap);
        } 
        priceLevelCalculation(partIdToPartRecordMap);
    }
    
    
    public static void afterInsertCalculation() {
        /*if(!checkEnteryCondition()) {
            return;
        }*/
        
        salesTaxCalculation();
        insertCOInvoiceLineItem();
        updateCOInvoiceItemOfKitHeader();
        insertVOLineItem();
    }
    
    
    public static void beforeUpdateCalculation() {
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Part_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        List<CO_Line_Item__c> coLineItemList = [select part__c, part__r.Qty_Committed__c, part__r.AvailableParts__c, Qty__c, Retail__c, Price__c, 
                                                    CO_Header__c, CO_Header__r.Customer__r.Sales_Tax__c, CO_Header__r.Customer__r.Price_Level__r.Part_Price_Base__c, CO_Header__r.Customer__r.Price_Level__r.Discount_Markup__c,
                                                    Service_Order_Line_Item__c, Service_Order_Line_Item__r.Fixed_Price__c, Service_Order_Line_Item__r.Service_Order_Kit_Header__c
                                                    from CO_Line_Item__c where Id IN: trigger.new];
        
        Set<Id> partIdSet = new Set<Id>();
        for(CO_Line_Item__c coLineItemRec : coLineItemList) {
        	if(coLineItemRec.part__c != null) {
            	partIdSet.add(coLineItemRec.part__c);
        	}
        }
        Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Id, Average_Cost__c, Applicable_Tax__c, Applicable_Tax__r.Rate__c, 
        																Last_Cost__c, MSRP__c, Retail_Price__c, AvailableParts__c,Qty_In_Stock__c, 
        																Qty_Committed__c, (select Sales_Tax_Item__c from Part_Taxes__r) 
        																from Part__c where Id IN : partIdSet]);
        Map<Id, Sobject> colineItemIdToPartRecordMap = new Map<Id, Sobject>();
        
        for(CO_Line_Item__c coLineItemRec : coLineItemList) {
            colineItemIdToPartRecordMap.put(coLineItemRec.Id, partIdToPartRecordMap.get(coLineItemRec.part__c));
        }
        
        // Entry Condition of Qty Committed Logic.
        if(entryConditionForBeforeUpdateCommittedLogic()) {
            qytComittedLogic(partIdToPartRecordMap);
        }
        
        if(isVOLIRecToChange) {
        	insertVOLineItem();
        }
        priceLevelCalculation(partIdToPartRecordMap);
        //system.assert(false, coLineItemList);
    }
    
    /**
     * Name: beforeDeleteOperation
     * Desc: Returned Committed quantity to the part record before deleting to any CO Line Item
     * @param: 
     * @return: 
    **/
    public static void beforeDeleteOperation() {
        
        returnPartCommittedQty();
        deleteOtherRelatedRecords();
    }
    
    
    public static void afterUpdateCalculation() {
    	if(!isTriggerExecute) {
    		updateCOInvoiceItemOfKitHeader();
    		isTriggerExecute = true;
    	}
    }
    
    public static Boolean entryConditionForBeforeInsertCommittedLogic() {
        Boolean isValidEntry = false;
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(coLineItemRec.Part__c != null && coLineItemRec.Qty__c != null) {
                isValidEntry = true;
            }
        }
        return isValidEntry;
    }
    
    
    public static Boolean entryConditionForBeforeUpdateCommittedLogic() {
        Boolean isValidEntry = false;
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(coLineItemRec.Part__c != null && 
                    ( COLineItemNewMap.get(coLineItemRec.Id).Qty__c != COLineItemOldMap.get(coLineItemRec.Id).Qty__c ||
                      COLineItemNewMap.get(coLineItemRec.Id).Qty_Committed__c != COLineItemOldMap.get(coLineItemRec.Id).Qty_Committed__c)) {
                
                isValidEntry = true;            
            }
        }
        return isValidEntry;
    }
    
    
    
    public static void qytComittedLogicInCaseOfInsert(Map<Id, Part__c> partIdToPartRecordMap) {
    	if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	
        for(CO_Line_Item__c coLineItem : COLineItemNewList) {
            if(coLineItem.Part__c == null) {
                return;
            }
            
            Decimal committedPartQty = partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c;
            Decimal qtyAvailable = partIdToPartRecordMap.get(coLineItem.Part__c).AvailableParts__c;
            Decimal qtyRequried = coLineItem.Qty__c;
            
            // In case of Negative Qty Needed, Don't do anything
            if(qtyRequried < 0) {
            	continue;
            }
            
            if(qtyRequried <= qtyAvailable) {
                coLineItem.Qty_Committed__c = qtyRequried;
            } else {
                coLineItem.Qty_Committed__c = qtyAvailable;
            }
            partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty + coLineItem.Qty_Committed__c);
        }
        if(partIdToPartRecordMap.size() > 0) {
            update partIdToPartRecordMap.values();
        }
    }
    
    
    public static void priceLevelCalculation(Map<Id, Part__c> partIdToPartRecordMap) {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Fee__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        List<CO_Line_Item__c> coLineItemWithDefaultPriceLevel = new List<CO_Line_Item__c>();
        List<CO_Line_Item__c> coLineItemWithPriceLevel = new List<CO_Line_Item__c>();
        
        List<Id> coHeaderIdList = new List<Id>();
        List<Id> soliIdList = new List<Id>();
        Set<Id> feeIdSet = new Set<Id>();
        Boolean isQueryEcecuted = false;
        for(CO_Line_Item__c coliRec : COLineItemNewList) {
            coHeaderIdList.add(coliRec.CO_Header__c); 
            if(coliRec.Service_Order_Line_Item__c != null) {
            	soliIdList.add(coliRec.Service_Order_Line_Item__c);
            	isQueryEcecuted = true;
            }
            if(coliRec.Fee__c != null) {
            	feeIdSet.add(coliRec.Fee__c);
            }
        }
        
        Map<Id, Fee__c> feeIdToFeeRecordMap = new Map<Id, Fee__c>();
        if(feeIdSet.size() > 0) {
        	feeIdToFeeRecordMap = new Map<Id, Fee__c>([select Price__c, Taxable__c, Applicable_Tax__c, Applicable_Tax__r.Rate__c
        																from Fee__c where Id IN: feeIdSet]); 
        }
        Map<Id, CO_Header__c> coHeaderIdToCoHeaderRecMap = new Map<Id, CO_Header__c>([select Discount_Markup_From_Prive_Level__c, Part_Price_Base_From_Price_Level__c
                                                                                            from CO_Header__c Where Id IN : coHeaderIdList]);
        
        Map<Id, Service_Order_Line_Item__c> soliMap;
        if(isQueryEcecuted) {
        	soliMap = new Map<Id, Service_Order_Line_Item__c>([select Service_Order_Kit_Header__c, Service_Order_Header__c, Service_Order_Header__r.Provider__c, 
        																Service_Order_Header__r.Provider_Part_Price_Base__c, Service_Order_Header__r.Provider_Discount_Markup__c 
        																from Service_Order_Line_Item__c where Id IN: soliIdList]);
        }
        
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(coLineItemRec.Service_Order_Line_Item__c != null && soliMap.get(coLineItemRec.Service_Order_Line_Item__c).Service_Order_Kit_Header__c != null) {
                continue;
            }
            if(coLineItemRec.CO_Kit_Header__c != null) {
                continue;
            }
            
            Decimal discount;
            String partPriceBase;
            if(coLineItemRec.Service_Order_Line_Item__c != null && soliMap.containsKey(coLineItemRec.Service_Order_Line_Item__c) 
            		&& soliMap.get(coLineItemRec.Service_Order_Line_Item__c).Service_Order_Header__r.Provider__c != null
            		) {
		        		if(soliMap.get(coLineItemRec.Service_Order_Line_Item__c).Service_Order_Header__r.Provider_Discount_Markup__c != null) {
		        			discount = soliMap.get(coLineItemRec.Service_Order_Line_Item__c).Service_Order_Header__r.Provider_Discount_Markup__c;
		        		} else {
		        			discount = 0;		
		        		}
		        		partPriceBase = soliMap.get(coLineItemRec.Service_Order_Line_Item__c).Service_Order_Header__r.Provider_Part_Price_Base__c;
            } else {
            	discount = (coHeaderIdToCoHeaderRecMap.get(coLineItemRec.CO_Header__c).Discount_Markup_From_Prive_Level__c == null) ? 0 : coHeaderIdToCoHeaderRecMap.get(coLineItemRec.CO_Header__c).Discount_Markup_From_Prive_Level__c;
            	partPriceBase = coHeaderIdToCoHeaderRecMap.get(coLineItemRec.CO_Header__c).Part_Price_Base_From_Price_Level__c;
    		}
            		
            TaxCalculation.partPriceCalculation1(partPriceBase, discount, coLineItemRec, partIdToPartRecordMap, feeIdToFeeRecordMap);
        }
    }
    
    
    public static void qytComittedLogic(Map<Id, Part__c> partIdToPartRecordMap) {
        if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        
        for(CO_Line_Item__c coLineItem : coLineItemNewList) {
            
            if(partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c == null){
                partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c = 0;
            }
            
            Decimal committedPartQty = partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c;
            
            if(coLineItem.Qty__c < 0) {
            	if(coLineItem.Qty_Committed__c != null && coLineItem.Qty_Committed__c > 0) {
            		partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty - coLineItem.Qty_Committed__c);
            		coLineItem.Qty_Committed__c = 0;
            	}
            	continue;
            } 
            
            // changes by subhrant
            Decimal qtyAvailable =  partIdToPartRecordMap.get(coLineItem.Part__c).Qty_In_Stock__c -  partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c;
            if(coLineItem.Qty_Committed__c == null) {
            	coLineItem.Qty_Committed__c = 0;
            }
            Decimal qtyRequried = coLineItem.Qty__c - coLineItem.Qty_Committed__c;
            
            if(COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c != COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c) {
            	if(qtyAvailable <= 0) {
            		if(coLineItem.Oversold_Qty__c == null) {
            			coLineItem.Oversold_Qty__c = 0;
            		}
            		coLineItem.Oversold_Qty__c += (COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c - COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c);
            		
            		if(coLineItem.Oversold_Qty__c < 0) {
            			coLineItem.Oversold_Qty__c = 0;
            		}
            	} else {
            		Decimal qtyCommittedDiff = COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c - COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c;
            		if(qtyCommittedDiff - qtyAvailable > 0) {
            			coLineItem.Oversold_Qty__c = qtyCommittedDiff - qtyAvailable;
            		}
            	}
            }
            
            
            if(COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c < COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c) {
                Decimal qtyCommittedDifference = COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c - COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c;
                partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty - qtyCommittedDifference);
            } else if(COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c > COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c) {
                Decimal qtyDifference = COLineItemNewMap.get(coLineItem.Id).Qty_Committed__c- COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c;
                //if(qtyAvailable >= qtyDifference) {
                    partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty + qtyDifference);
                //} 
            } else if(qtyRequried <= qtyAvailable) {
                coLineItem.Qty_Committed__c = coLineItem.Qty__c;
                partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty + qtyRequried);
            } else {
                coLineItem.Qty_Committed__c = COLineItemOldMap.get(coLineItem.Id).Qty_Committed__c + qtyAvailable;
                partIdToPartRecordMap.get(coLineItem.Part__c).put('Qty_Committed__c', committedPartQty + qtyAvailable);
            }
        }
        //system.assert(false, coLineItemNewList);
        
        if(partIdToPartRecordMap.size() > 0) {
        	if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update partIdToPartRecordMap.values();
        }
    }
    
    
    public static void salesTaxCalculation() {
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        isTriggerExecute = true;
        
        // Tax Exemption List
        List<CO_Line_Item__c> coLineItemList = [SELECT Part__c, Part__r.Applicable_Tax__c, Part__r.Applicable_Tax__r.Rate__c,
        												Fee__c, Fee__r.Applicable_Tax__c, Fee__r.Applicable_Tax__r.Rate__c,
    													CO_Header__c, CO_Header__r.Customer__c, Service_Order_Line_Item__c
    												FROM CO_Line_Item__c where Id IN: trigger.new];
    	
    	Set<Id> customerIdSet = new Set<Id>();
    	for(CO_Line_Item__c coLineItemRec : coLineItemList) {
    		if(coLineItemRec.CO_Header__r.Customer__c != null && !customerIdSet.contains(coLineItemRec.CO_Header__r.Customer__c)) {
    			customerIdSet.add(coLineItemRec.CO_Header__r.Customer__c);
    		}
    	}
        List<Account> customerList = [SELECT Id, (SELECT Sales_Tax_Item__r.Rate__c from Tax_Exemptions__r) from Account where Id IN: customerIdSet];
        
        Map<Id, Set<Id>> customerIdToSalesTaxItemIdsMap = new Map<Id, Set<Id>>();
        for(Account customerRec : customerList) {
            Set<Id> salesTaxItemIdSet = new Set<Id>();
            for(Tax_Exemption__c taxExemptionRec : customerRec.Tax_Exemptions__r) {
                salesTaxItemIdSet.add(taxExemptionRec.Sales_Tax_Item__c);
            }
            customerIdToSalesTaxItemIdsMap.put(customerRec.Id, salesTaxItemIdSet);
        }
        
        // Entity Tax Rate
        List<Id> salesTaxIdList = new List<Id>();
        for(CO_Line_Item__c coLineItemRec : coLineItemList) {
            if(coLineItemRec.Part__r.Applicable_Tax__c != null) {
                salesTaxIdList.add(coLineItemRec.Part__r.Applicable_Tax__c);
            } else if(coLineItemRec.Fee__r.Applicable_Tax__c != null) {
                salesTaxIdList.add(coLineItemRec.Fee__r.Applicable_Tax__c);
            } 
        }
        
        List<CO_Line_Item__c> coLineItemToUpdate = new List<CO_Line_Item__c>();
        coLineItemToUpdate.addAll(TaxCalculation.salesTaxCalculation2(salesTaxIdList, customerIdToSalesTaxItemIdsMap, coLineItemList));
        
        if(coLineItemToUpdate.size() > 0) {
        	if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update coLineItemToUpdate;
        }
        //system.assert(false, coLineItemToUpdate);
    }
    
    /**
     * Name: getDefaultSalesTax
     * Desc: Popualte List of default sales tax by querying from database.
     * @param: 
     * @return: 
    **/
    private static List<Sales_Tax__c> getDefaultSalesTax() {
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        return [select Rate__c from Sales_Tax__c where default__c = true];
    }
    
    
    private static void returnPartCommittedQty() {
    	if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	
        Set<Id> partIdSet = new Set<Id>();
        for(CO_Line_Item__c coLineItem : COLineItemOldList) {
            if(coLineItem.Part__c != null) {
            	partIdSet.add(coLineItem.Part__c);
            }
        }
        Map<Id, Part__c> partIdToPartRecordMap = new Map<Id, Part__c>([select Id, Qty_Committed__c from Part__c where Id IN : partIdSet]);
        
        for(CO_Line_Item__c coLineItem : COLineItemOldList) {
        	if(coLineItem.Part__c == null || coLineItem.Qty__c < 0) {
        		continue;
        	}
            if(partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c == null) {
                partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c = 0;
            } 
            if(coLineItem.Qty_Committed__c == null) {
                coLineItem.Qty_Committed__c = 0;
            }
            partIdToPartRecordMap.get(coLineItem.Part__c).Qty_Committed__c -= coLineItem.Qty_Committed__c;
        }
        if(partIdToPartRecordMap.size() > 0) {
            update partIdToPartRecordMap.values();
        }
    }
    
    
    private static void deleteOtherRelatedRecords() {
    	if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    	
        List<CO_Line_Item__c> coLineItemList = [select Id, (Select Id from Vendor_Order_Line_Items__r ),(Select Id from CO_Invoice_Items__r ) from CO_Line_Item__c where Id IN :COLineItemOldList];
        
        List<Vendor_Order_Line_Item__c> voliListToDel = new List<Vendor_Order_Line_Item__c>();
        List<CO_Invoice_Item__c> coInvoiceItemListToDel = new List<CO_Invoice_Item__c>();
         
        for(CO_Line_Item__c coliRec : coLineItemList) {
            if(coliRec.Vendor_Order_Line_Items__r.size() > 0) {
                voliListToDel.addAll(coliRec.Vendor_Order_Line_Items__r);
            }
            
            if(coliRec.CO_Invoice_Items__r.size() > 0) {
                coInvoiceItemListToDel.addAll(coliRec.CO_Invoice_Items__r);
            }
        }
        
        if(voliListToDel.size() > 0) {
            delete voliListToDel;
        }
        if(coInvoiceItemListToDel.size() > 0){
            delete coInvoiceItemListToDel;
        }
    }
    
    /**
     * Name: insertCOInvoiceLineItem
     * Desc: Insert CO Invoice Item when CO Line Item is inserted
     * @param: 
     * @return: 
    **/
    public static void insertCOInvoiceLineItem() {
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        
        List<Id> coHeaderIdList = new List<Id>();
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            coHeaderIdList.add(coLineItemRec.CO_Header__c);
        }
        
        List<CO_Invoice_Header__c> coInvoiceHeaderList = [select Id, Invoice_Status__c, CO_Header__c, (select Id from CO_Invoice_Payments__r) from CO_Invoice_Header__c where CO_Header__c IN :coHeaderIdList AND Invoice_Status__c = 'Active'];
        Map<Id, CO_Invoice_Header__c> coHeaderIdToCOInvoiceHeaderRecMap = new Map<Id, CO_Invoice_Header__c>();
        for(CO_Invoice_Header__c coInvoiceHeaderRec : coInvoiceHeaderList) {
            coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
        }
        
        List<CO_Invoice_Item__c> coInvoiceItemToInsert = new List<CO_Invoice_Item__c>();
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(coLineItemRec.Service_Order_Line_Item__c != null || coLineItemRec.CO_Kit_Header__c != null) {
                continue;
            }
            CO_Invoice_Item__c coInvoiceItemRec = new CO_Invoice_Item__c();
            if(coHeaderIdToCOInvoiceHeaderRecMap.containsKey(coLineItemRec.CO_Header__c)) {
                coInvoiceItemRec.CO_Invoice_Header__c = coHeaderIdToCOInvoiceHeaderRecMap.get(coLineItemRec.CO_Header__c).Id;
            } else {
                CO_Invoice_Header__c coInvoiceHeaderRec = insertCOInvoiceHeader(coLineItemRec.CO_Header__c);
                coInvoiceItemRec.CO_Invoice_Header__c = coInvoiceHeaderRec.Id;
                coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
            }
            coInvoiceItemRec.CO_Line_Item__c = coLineItemRec.Id;
            
            if((coLineItemRec.Qty_Committed__c == 0 && coLineItemRec.Qty__c > 0) || coHeaderIdToCOInvoiceHeaderRecMap.get(coLineItemRec.CO_Header__c).CO_Invoice_Payments__r.size() > 0) {
                coInvoiceItemRec.isActive__c = false;
            } else {
                coInvoiceItemRec.isActive__c = true;
            }
            coInvoiceItemToInsert.add(coInvoiceItemRec);
        }
        
        if(coInvoiceItemToInsert.size() > 0) {
            insert coInvoiceItemToInsert;
        }
    }
    
    
    /**
     * Name: updateCOInvoiceItemOfKitHeader
     * Desc: Insert CO Invoice Item when CO Line Item is inserted
     * @param: 
     * @return: 
    **/
    private static void updateCOInvoiceItemOfKitHeader() {
    	boolean isValidEntry = false;
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
        	if(coLineItemRec.CO_Kit_Header__c != null){
        		isValidEntry = true;
        	}
        }
        if(!isValidEntry){
        	return;
        }
        
        List<Id> cokhIdList = new List<Id>();
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            cokhIdList.add(coLineItemRec.CO_Kit_Header__c);
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<CO_Kit_Header__c> cokitHeaderList = [select Id, (select Id, Part__c, Qty_To_Order__c from CO_Line_Items__r), (select Is_Invoiceable__c from CO_Invoice_Items__r) from CO_Kit_Header__c where Id IN: cokhIdList];
        List<CO_Invoice_Item__c> coInvoiceItemListToUpdate = new List<CO_Invoice_Item__c>();
        
        for(CO_Kit_Header__c cokhRec : cokitHeaderList) {
        	Boolean isInvoiceable = true;
        	for(CO_Line_Item__c coliRec : cokhRec.CO_Line_Items__r) {
        		if(coliRec.Part__c != null && coliRec.Qty_To_Order__c > 0) {
        			isInvoiceable = false;
        			break;
        		}
        	}
        	if(cokhRec.CO_Invoice_Items__r.size() > 0) {
        		cokhRec.CO_Invoice_Items__r[0].Is_Invoiceable__c = isInvoiceable;
        		coInvoiceItemListToUpdate.add(cokhRec.CO_Invoice_Items__r[0]);
        	}
        }
        
        if(coInvoiceItemListToUpdate.size() > 0) {
        	if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update coInvoiceItemListToUpdate;
        }
    }
    
    
    /**
     * Name: insertCOInvoiceHeader
     * Desc: Insert CO Invoice Header rec
     * @param: (1) coHeaderId - Id - CO Header Id 
     * @return: CO_Invoice_Header__c - inserted record of CO Invoice Header
    **/
    public static CO_Invoice_Header__c insertCOInvoiceHeader(Id coHeaderId) {
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
    	
        CO_Invoice_Header__c coInvoiceHeaderRec = new CO_Invoice_Header__c();
        coInvoiceHeaderRec.CO_Header__c = coHeaderId;
        coInvoiceHeaderRec.Invoice_Status__c = 'Active';
        insert coInvoiceHeaderRec;
        return coInvoiceHeaderRec;
    }
    
    
    private static Boolean entryConditionForChangingVOLI() {
        Boolean isValidEntry = false;
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            if(Trigger.isInsert && coLineItemRec.Part__c != null && coLineItemRec.Qty__c > coLineItemRec.Qty_Committed__c) {
                isValidEntry = true;
            }
            if(Trigger.isUpdate 
                && COLineItemNewMap.get(coLineItemRec.Id).Part__c != null 
                && (COLineItemNewMap.get(coLineItemRec.Id).Qty__c != COLineItemOldMap.get(coLineItemRec.Id).Qty__c ||
                    COLineItemNewMap.get(coLineItemRec.Id).Qty_Committed__c != COLineItemOldMap.get(coLineItemRec.Id).Qty_Committed__c)
                ) {
                    
                isValidEntry = true;
                if(!isVOLIInsertFromVRPage) {
		        	isValidEntry = false;
		        }
            }
        }
        return isValidEntry;
    }
    
    /**
     * Name: insertVOLineItem
     * Desc: Insert VO Line Item if Status is required
     * @param: 
     * @return: 
    **/
    public static void insertVOLineItem() {
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	
        // Entry Condition
        if(!entryConditionForChangingVOLI()) {
            return;
        }
        
        
        List<Vendor_Order_Line_Item__c> voLineItemsToUpsert = new List<Vendor_Order_Line_Item__c>();
        List<Vendor_Order_Line_Item__c> voLineItemsToDelete = new List<Vendor_Order_Line_Item__c>();
        List<Vendor_Order_Line_Item__c> existingVOLineItem = [select Id, 
                                                                     CO_Line_Item__c, Is_Received__c
                                                                     from Vendor_Order_Line_Item__c 
                                                                     where CO_Line_Item__c IN : COLineItemNewList AND (Vendor_Order_Header__c = null OR Vendor_Order_Header__r.Status__c = 'Open') AND Is_Received__c = false];
        
        Map<Id, Id> coLineItemIdToVOLineItemIdMap = new Map<Id, Id>();
        for(Vendor_Order_Line_Item__c voLineItemRec : existingVOLineItem) {
            if(!coLineItemIdToVOLineItemIdMap.containsKey(voLineItemRec.CO_Line_Item__c)) {
                coLineItemIdToVOLineItemIdMap.put(voLineItemRec.CO_Line_Item__c, voLineItemRec.Id);
            }
        }
        
        Vendor_Order_Line_Item__c voLineItemRec;
        for(CO_Line_Item__c coLineItemRec : COLineItemNewList) {
            voLineItemRec = new Vendor_Order_Line_Item__c();
            
            if(coLineItemRec.Part__c != null && coLineItemRec.Qty__c > coLineItemRec.Qty_Committed__c) {
                voLineItemRec.CO_Header__c = coLineItemRec.CO_Header__c;
                voLineItemRec.CO_Line_Item__c = coLineItemRec.Id;
                voLineItemRec.Part__c = coLineItemRec.Part__c;
                voLineItemRec.Qty_Needed__c = coLineItemRec.Qty__c - coLineItemRec.Qty_Committed__c;
                
                if(coLineItemRec.Service_Order_Line_Item__c != null){
                    voLineItemRec.Is_Service__c = true;
                } else {
                    voLineItemRec.Is_required_For_Customer__c = true;
                }
                
                if(coLineItemIdToVOLineItemIdMap.containsKey(coLineItemRec.Id)) {
                    voLineItemRec.Id = coLineItemIdToVOLineItemIdMap.get(coLineItemRec.Id);
                }
                voLineItemsToUpsert.add(voLineItemRec);
            } else {
                if(coLineItemIdToVOLineItemIdMap.containsKey(coLineItemRec.Id)) {
                    voLineItemRec.Id = coLineItemIdToVOLineItemIdMap.get(coLineItemRec.Id);
                    voLineItemsToDelete.add(voLineItemRec);
                }
            }
        }
        
        if(voLineItemsToUpsert.size() > 0) {
        	if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
			if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            upsert voLineItemsToUpsert;
        }
        
        if(voLineItemsToDelete.size() > 0) {
        	if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            delete voLineItemsToDelete;
        }
    }
}