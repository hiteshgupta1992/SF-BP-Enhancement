/**
 * Author: Hitesh Gupta
 * Since: Dec. 23, 2015
 * Name: ServiceOrderLineItemTriggerHelper
 * Description: Helper class for triggers on SOLI.
**/
public class ServiceOrderLineItemTriggerHelper {
    
    // List to store trigger new list
    public static List<Service_Order_Line_Item__c> soliNewList = new List<Service_Order_Line_Item__c>();
    
    // List to store trigger old list
    public static List<Service_Order_Line_Item__c> soliOldList = new List<Service_Order_Line_Item__c>();
    
    // Map to store new Trigger Map
    public static Map<Id, Service_Order_Line_Item__c> soliNewMap = new Map<Id, Service_Order_Line_Item__c>();
    
    // Map to store Old Trigger Map
    public static Map<Id, Service_Order_Line_Item__c> soliOldMap = new Map<Id, Service_Order_Line_Item__c>();
    
    // Boolean to stop trigger
    public static Boolean isTriggerExecuted = false;
    
    
    /**
     * Name: afterInsertCalculation
     * Desc: before update operations
     * @param: 
     * @return: 
    **/
    public static void afterInsertCalculation() {
        if(!isTriggerExecuted) {
            insertCOLIs();
        }
        List<Service_Order_Line_Item__c> soliListHavingFeeAndLabour = new List<Service_Order_Line_Item__c>();
        for(Service_Order_Line_Item__c soliRec : soliNewList) {
            if(soliRec.Service_Order_Kit_Header__c != null) {
                continue;
            }
            if(soliRec.Fee__c != null || soliRec.Labour_Code__c != null) {
                soliListHavingFeeAndLabour.add(soliRec);
            }
        }
        
        if(soliListHavingFeeAndLabour.size() > 0) {
            applySalesTax(soliListHavingFeeAndLabour);
        }
    }
    
    public static void beforeInsertCalculation() {
        List<Service_Order_Line_Item__c> soliListHavingFeeAndLabour = new List<Service_Order_Line_Item__c>();
        for(Service_Order_Line_Item__c soliRec : soliNewList) {
            if(soliRec.Service_Order_Kit_Header__c != null) {
                continue;
            }
            if(soliRec.Fee__c != null || soliRec.Labour_Code__c != null) {
                soliListHavingFeeAndLabour.add(soliRec);
            }
        }
        
        if(soliListHavingFeeAndLabour.size() > 0) {
            applyPriceLevel(soliListHavingFeeAndLabour);
        }
    }
    
    /**
     * Name: afterUpdateCalculation
     * Desc: before update operations
     * @param: 
     * @return: 
    **/
    public static void beforeUpdateCalculation() {
        insertCOLIs();
    }
    
    
    public static void afterUpdateCalculation() {
        updateTotalOnSOHeader(soliNewList);
    }
    
    
    private static void updateTotalOnSOHeader(List<Service_Order_Line_Item__c> soliList) {
        Set<Id> soHeaderIdSet = new Set<Id>();
        for(Service_Order_Line_Item__c soliRec : soliList) {
            soHeaderIdSet.add(soliRec.Service_Order_Header__c);
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Service_Order_Header__c> soHeaderList = [select Total__c, Tax_Amount__c, (select Total__c, Tax_Percent__c from Service_Order_Line_Items__r) 
                                                                    from Service_Order_Header__c
                                                                    where Id IN : soHeaderIdSet];
        
        for(Service_Order_Header__c soHeaderRec : soHeaderList) {                                                           
            Decimal total = 0;
            Decimal taxAmount = 0;
            for(Service_Order_Line_Item__c soliRec : soHeaderRec.Service_Order_Line_Items__r) {
                total += soliRec.Total__c;
                if(soliRec.Tax_Percent__c == null) {
                    soliRec.Tax_Percent__c = 0;
                }
                taxAmount += (soliRec.Total__c * soliRec.Tax_Percent__c) / 100;
            }
            soHeaderRec.Total__c = total;
            soHeaderRec.Tax_Amount__c = taxAmount;
        }
        
        if(soHeaderList.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update soHeaderList;
        }
    }
    
    /**
     * Name: afterInsertCalculation
     * Desc: before update operations
     * @param: 
     * @return: 
    **/
    public static void beforeDeleteCalculation() {
        if(isTriggerExecuted) {
            return;
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Service_Order_Line_Item__c> soliList = [select Id, (select Id from CO_Line_Items__r) from Service_Order_Line_Item__c where Id =: soliOldList];
        List<CO_Line_Item__c> coliListToDelete = new List<CO_Line_Item__c>();
        for(Service_Order_Line_Item__c soliRec : soliList) {
            if(soliRec.CO_Line_Items__r != null && soliRec.CO_Line_Items__r.size() > 0) {
                coliListToDelete.add(soliRec.CO_Line_Items__r[0]);
            }
        }
        
        if(coliListToDelete.size() > 0) {
            if(AccessControl.ifObjectIsDeletable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            delete coliListToDelete;
        }
    }
    
    /**
     * Name: insertCOLIs
     * Desc: create Coli on create of Soli
     * @param: Set<Id> soliIds
     * @return: 
    **/
    public static void insertCOLIs() {
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        Map<Id, Service_Order_Line_Item__c> soliMap = new Map<Id, Service_Order_Line_Item__c>([select Service_Order_Header__c, Service_Order_Kit_Header__c, Service_Order_Header__r.CO_Header__c from Service_Order_Line_Item__c where Id in: soliNewList]);
        List<CO_Line_Item__c> coliList = new List<CO_Line_Item__c>();
        CO_Line_Item__c coli;
        
        for(Service_Order_Line_Item__c soli : soliNewList) {
            if(soli.Part__c != null) {
                coli = new CO_Line_Item__c();
                if(soli.CO_Line_Item__c != null) {
                    coli.Id = soli.CO_Line_Item__c;
                }
                coli.Service_Order_Line_Item__c = soli.Id;
                coli.Part__c = soli.Part__c;
                coli.Qty__c = soli.Qty_Needed__c;
                if(soli.Qty_Needed__c > 0) {
                    coli.Qty_Committed__c = soli.Qty_Committed__c;
                } 
                    
                if(soliMap.get(soli.Id).Service_Order_Kit_Header__c != null) {
                    coli.Price__c = soli.Kit_Price__c;
                }
                //coli.Retail__c = soli.Retail_Price__c;
                coli.CO_Header__c =  (soliMap.get(soli.Id).Service_Order_Header__c != null && soliMap.get(soli.Id).Service_Order_Header__r.CO_Header__c != null) 
                                        ? soliMap.get(soli.Id).Service_Order_Header__r.CO_Header__c : null;
                coliList.add(coli);
            }
        }
        if(coliList.size() > 0) {
            system.debug('%%%%%%%'+coliList);
            if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            upsert coliList;
            if(trigger.isInsert) {
                populateSOLIsField();
            } else if(trigger.IsUpdate) {
                populateSOLIsFieldBeforeUpdate();
            }
        }
        
        List<Service_Order_Line_Item__c> soliList = [select Qty_To_Order__c, Service_Order_Header__c, Service_Order_Header__r.CO_Header__c from Service_Order_Line_Item__c where Id IN :trigger.New];
        
        List<Id> soHeaderIdList = new List<Id>();
        List<Id> coHeaderIdList = new List<Id>();
        
        for(Service_Order_Line_Item__c soliRec : soliList) {
            if(soliRec.Service_Order_Header__c != null) {
                soHeaderIdList.add(soliRec.Service_Order_Header__c);
                if(soliRec.Service_Order_Header__r.CO_Header__c != null) {
                    coHeaderIdList.add(soliRec.Service_Order_Header__r.CO_Header__c);
                }
            }
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        List<Service_Order_Header__c> soHeaderList = [select Id, CO_Header__c, (select isActive__c, Is_Invoiceable__c from CO_Invoice_Items__r), 
                                                            (select Qty_To_Order__c, Tax__c, Total__c from Service_Order_Line_Items__r) 
                                                            from Service_Order_Header__c where Id IN : soHeaderIdList AND Transaction_Type__r.Type__c != 'Third-Party'];
        List<CO_Invoice_Header__c> coInvoiceHeaderList = [select Id, Invoice_Status__c, CO_Header__c from CO_Invoice_Header__c where CO_Header__c IN :coHeaderIdList AND Invoice_Status__c = 'Active'];
        
        Map<Id, CO_Invoice_Header__c> coHeaderIdToCOInvoiceHeaderRecMap = new Map<Id, CO_Invoice_Header__c>();
        for(CO_Invoice_Header__c coInvoiceHeaderRec : coInvoiceHeaderList) {
            coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
        }
        
        Map<Id, CO_Invoice_Item__c> coInvoiceItemMap = new Map<Id,CO_Invoice_Item__c>();
        
        for(Service_Order_Header__c soHeaderRec : soHeaderList) {
            Boolean IsInvoiceable = true;
            Decimal total = 0;
            Decimal taxAmount = 0;
            for(Service_Order_Line_Item__c soliRec : soHeaderRec.Service_Order_Line_Items__r) {
                if(soliRec.Qty_To_Order__c > 0) {
                    IsInvoiceable = false;
                }
                total += soliRec.Total__c;
                taxAmount += (soliRec.Total__c * soliRec.Tax__c) / 100;
            }
            soHeaderRec.Total__c = total;
            soHeaderRec.Tax_Amount__c = taxAmount;
            CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
            if(soHeaderRec.CO_Invoice_Items__r.size() == 1) {
                coInvoiceItem.Id = soHeaderRec.CO_Invoice_Items__r[0].Id;
                coInvoiceItem.Is_Invoiceable__c = IsInvoiceable;
                //coInvoiceItem.Service_Order_Header__c = soHeaderRec.Id;
            } else {
                if(coHeaderIdToCOInvoiceHeaderRecMap.containsKey(soHeaderRec.CO_Header__c)) {
                    coInvoiceItem.CO_Invoice_Header__c = coHeaderIdToCOInvoiceHeaderRecMap.get(soHeaderRec.CO_Header__c).Id;
                } else {
                    CO_Invoice_Header__c coInvoiceHeaderRec = COLineItemTriggerHelper.insertCOInvoiceHeader(soHeaderRec.CO_Header__c);
                    coInvoiceItem.CO_Invoice_Header__c = coInvoiceHeaderRec.Id;
                    coHeaderIdToCOInvoiceHeaderRecMap.put(coInvoiceHeaderRec.CO_Header__c, coInvoiceHeaderRec);
                }
                coInvoiceItem.isActive__c = true; 
                coInvoiceItem.Is_Invoiceable__c = IsInvoiceable;
                coInvoiceItem.Service_Order_Header__c = soHeaderRec.Id;
                
            }
            coInvoiceItemMap.put(coInvoiceItem.Id, coInvoiceItem);
        }
        
        if(soHeaderList.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update soHeaderList;
        }
        
        if(coInvoiceItemMap.size() > 0 ) {
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            if(AccessControl.ifObjectFieldIsCreateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            upsert coInvoiceItemMap.values();
        } 
    }
    
    /**
     * Name: populateSOLIsFieldBeforeUpdate
     * Desc: update Soli based on Coli create operations
     * @param: Set<Id> soliIds
     * @return: 
    **/
    public static void populateSOLIsFieldBeforeUpdate() {
        List<Service_Order_Line_Item__c> soliList = [select CO_Line_Item__c, Service_Order_Kit_Header__c, Kit_Price__c, 
                                                        (Select Id, Tax__c, Qty_Committed__c, Price__c from CO_Line_Items__r) 
                                                        from Service_Order_Line_Item__c where Id in: soliNewList];
                                                    
        for(Service_Order_Line_Item__c soliRec : soliList) {
            if(soliRec.CO_Line_Items__r != null && soliRec.CO_Line_Items__r.size() > 0) {
                soliNewMap.get(soliRec.Id).CO_Line_Item__c = soliRec.CO_Line_Items__r[0].Id;
                soliNewMap.get(soliRec.Id).Qty_Committed__c = soliRec.CO_Line_Items__r[0].Qty_Committed__c;
                soliNewMap.get(soliRec.Id).Tax_Percent__c = soliRec.CO_Line_Items__r[0].Tax__c;
                if(soliRec.Service_Order_Kit_Header__c == null) {
                    //soliNewMap.get(soliRec.Id).Kit_Price__c = soliRec.CO_Line_Items__r[0].Price__c;
                    //soliNewMap.get(soliRec.Id).Actual_Kit_Price__c = soliRec.CO_Line_Items__r[0].Price__c;
                }
                system.debug('$$$$$$$$$$'+soliNewMap);
            }
        }
    }
    
    /**
     * Name: populateSOLIsField
     * Desc: update Soli based on Coli create operations
     * @param: Set<Id> soliIds
     * @return: 
    **/
    public static void populateSOLIsField() {
        List<Service_Order_Line_Item__c> soliList = [select CO_Line_Item__c, Kit_Price__c, Service_Order_Kit_Header__c, 
                                                        (Select Id, Tax__c, Qty_Committed__c, Price__c from CO_Line_Items__r) 
                                                        from Service_Order_Line_Item__c where Id in: soliNewList];
                                                    
        for(Service_Order_Line_Item__c soliRec : soliList) {
            if(soliRec.CO_Line_Items__r != null && soliRec.CO_Line_Items__r.size() > 0) {
                soliRec.CO_Line_Item__c = soliRec.CO_Line_Items__r[0].Id;
                soliRec.Qty_Committed__c = soliRec.CO_Line_Items__r[0].Qty_Committed__c;
                soliRec.Tax_Percent__c = soliRec.CO_Line_Items__r[0].Tax__c;
                if(soliRec.Service_Order_Kit_Header__c == null) {
                    soliRec.Kit_Price__c = soliRec.CO_Line_Items__r[0].Price__c;
                    soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
                }
            }
        }
        
        if(soliList.size() > 0) {
            isTriggerExecuted = true;
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update soliList;    
        }
    }
    
    /**
     * Name: processCOInvoiceItem
     * Desc: update CO Invoice Item Accoring to SOLI
     * @param: 
     * @return: 
    **/ 
    public static void processCOInvoiceItem() {
        List<Service_Order_Line_Item__c> soliList = [select Qty_To_Order__c, Service_Order_Header__c, Service_Order_Header__r.CO_Header__c from Service_Order_Line_Item__c where Id IN :soliOldList];
        
        List<Id> soHeaderIdList = new List<Id>();
        List<Id> coHeaderIdList = new List<Id>();
        
        for(Service_Order_Line_Item__c soliRec : soliList) {
            if(soliRec.Service_Order_Header__c != null) {
                soHeaderIdList.add(soliRec.Service_Order_Header__c);
                if(soliRec.Service_Order_Header__r.CO_Header__c != null) {
                    coHeaderIdList.add(soliRec.Service_Order_Header__r.CO_Header__c);
                }
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        List<Service_Order_Header__c> soHeaderList = [select Id, CO_Header__c, (select isActive__c, Is_Invoiceable__c from CO_Invoice_Items__r), 
                                                                    (select Qty_To_Order__c from Service_Order_Line_Items__r where Id NOT IN: soliList) 
                                                                    from Service_Order_Header__c where Id IN : soHeaderIdList];
        
        List<CO_Invoice_Item__c> coInvoiceItemList = new List<CO_Invoice_Item__c>();
        List<CO_Invoice_Item__c> coInvoiceItemListToDel = new List<CO_Invoice_Item__c>();
        
        for(Service_Order_Header__c soHeaderRec : soHeaderList) {
            Boolean IsInvoiceable = true;
            for(Service_Order_Line_Item__c soliRec : soHeaderRec.Service_Order_Line_Items__r) {
                if(soliRec.Qty_To_Order__c > 0) {
                    IsInvoiceable = false;
                }
            }
            CO_Invoice_Item__c coInvoiceItem = new CO_Invoice_Item__c();
            if(soHeaderRec.Service_Order_Line_Items__r.size() == 0 && soHeaderRec.CO_Invoice_Items__r.size() > 0) {
                coInvoiceItemListToDel.add(soHeaderRec.CO_Invoice_Items__r[0]);
            } else if(soHeaderRec.CO_Invoice_Items__r.size() == 1) {
                coInvoiceItem.Id = soHeaderList[0].CO_Invoice_Items__r[0].Id;
                coInvoiceItem.Is_Invoiceable__c = IsInvoiceable;
                coInvoiceItem.Service_Order_Header__c = soHeaderRec.Id;
                coInvoiceItemList.add(coInvoiceItem);
            } 
        }
        
        if(coInvoiceItemListToDel.size() > 0) {
            if(AccessControl.ifObjectIsDeletable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            delete coInvoiceItemListToDel;
        }
        
        if(coInvoiceItemList.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update coInvoiceItemList;
        }
        
        // Update Total
        updateTotalOnSOHeader(soliOldList);
    }
    
    
    private static void applyPriceLevel(List<Service_Order_Line_Item__c> soliListHavingFeeAndLabour) {
        Set<Id> soHeaderIdSet = new Set<Id>();
        Set<Id> feeIdSet = new Set<Id>();
        Set<Id> labourIdSet = new Set<Id>();
        for(Service_Order_Line_Item__c soliRec : soliListHavingFeeAndLabour) {
            soHeaderIdSet.add(soliRec.Service_Order_Header__c);
            feeIdSet.add(soliRec.Fee__c);
            labourIdSet.add(soliRec.Labour_Code__c);
        }
        soHeaderIdSet.remove(null);
        feeIdSet.remove(null);
        labourIdSet.remove(null);
        Map<Id, Fee__c> feeIdToFeeRecordMap = new Map<Id, Fee__c>();
        Map<Id, Labour_Code__c> labourIdToLabourRecordMap = new Map<Id, Labour_Code__c>();
        
        if(feeIdSet.size() > 0) {
        	if(AccessControl.ifObjectFieldIsAccessible('Fee__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            feeIdToFeeRecordMap = new Map<Id, Fee__c>([select Price__c, Taxable__c, Applicable_Tax__c, Applicable_Tax__r.Rate__c
                                                                        from Fee__c where Id IN: feeIdSet]);
        }
        
        if(labourIdSet.size() > 0) {
        	if(AccessControl.ifObjectFieldIsAccessible('Labour_Code__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            labourIdToLabourRecordMap = new Map<Id, Labour_Code__c>([select Rate__c, Taxable__c, Applicable_Tax__c, Applicable_Tax__r.Rate__c,
                                                                        Fixed_Rate__c
                                                                        from Labour_Code__c where Id IN: labourIdSet]);
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        Map<Id, Service_Order_Header__c> soHeaderIdToSOHeaderRecMap = 
                    new Map<Id, Service_Order_Header__c>([select CO_Header__c, CO_Header__r.Discount_Markup_From_Prive_Level__c, CO_Header__r.Part_Price_Base_From_Price_Level__c,
                                                           CO_Header__r.Labour_Rate_From_Price_Level__c,
                                                           Provider__c, Provider_Part_Price_Base__c, Provider_Discount_Markup__c
                                                           from Service_Order_Header__c Where Id IN : soHeaderIdSet]);
        
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        for(Service_Order_Line_Item__c soliRec : soliListHavingFeeAndLabour) {
            Decimal discount;
            Decimal laborRate;
            String partPriceBase;
            if(soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).Provider__c != null) {
                discount = soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).Provider_Discount_Markup__c;
                partPriceBase = soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).Provider_Part_Price_Base__c;
            } else {
                discount = soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).CO_Header__r.Discount_Markup_From_Prive_Level__c;
                partPriceBase = soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).CO_Header__r.Part_Price_Base_From_Price_Level__c;
                laborRate = soHeaderIdToSOHeaderRecMap.get(soliRec.Service_Order_Header__c).CO_Header__r.Labour_Rate_From_Price_Level__c;
            }
            
            Decimal price;
            Decimal appTaxRate;
            if(soliRec.Fee__c != null) {
                price = feeIdToFeeRecordMap.get(soliRec.Fee__c).Price__c;
                appTaxRate = feeIdToFeeRecordMap.get(soliRec.Fee__c).Applicable_Tax__r.Rate__c;
            } else if(soliRec.Labour_Code__c != null) {
                if(labourIdToLabourRecordMap.get(soliRec.Labour_Code__c).Fixed_Rate__c) {
                    price = labourIdToLabourRecordMap.get(soliRec.Labour_Code__c).Rate__c;
                } else {
                	if(laborRate == null || laborRate == 0) {
                		price = labourIdToLabourRecordMap.get(soliRec.Labour_Code__c).Rate__c;
                	} else {
                    	price = laborRate;
                	}
                }
                appTaxRate = labourIdToLabourRecordMap.get(soliRec.Labour_Code__c).Applicable_Tax__r.Rate__c;
            }
            
            if(isTaxIncludingPricing) {
                if(appTaxRate == null || appTaxRate == -100) { // To handle divide by zero error
                    appTaxRate = 0;
                }
                Decimal preTaxPricing = price / (1 + (appTaxRate / 100));
                //soliRec.Kit_Price__c = preTaxPricing + (preTaxPricing * discount / 100);
                if(soliRec.Labour_Code__c != null) {
                	soliRec.Kit_Price__c = price;
                } else {
					soliRec.Kit_Price__c = preTaxPricing;                	
                }
            } else {
                //soliRec.Kit_Price__c = price + (price * discount / 100);
				soliRec.Kit_Price__c = price;
            }
            soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
        }
        //system.assert(false, soliListHavingFeeAndLabour);
    }
    
    private static void applySalesTax(List<Service_Order_Line_Item__c> soliListHavingFeeAndLabour) {
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Service_Order_Line_Item__c> soLineItemList = [SELECT Service_Order_Header__c, Service_Order_Header__r.CO_Header__r.Customer__c,
                                                                Fee__c, Fee__r.Applicable_Tax__c, Fee__r.Applicable_Tax__r.Rate__c, Kit_Price__c,
                                                                Labour_Code__c, Labour_Code__r.Applicable_Tax__c, Labour_Code__r.Applicable_Tax__r.Rate__c 
                                                            FROM Service_Order_Line_Item__c where Id IN: soliListHavingFeeAndLabour];
        
        Set<Id> customerIdSet = new Set<Id>();
        for(Service_Order_Line_Item__c soliRec : soLineItemList) {
            if(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c != null && 
                    !customerIdSet.contains(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c)) 
            {
                customerIdSet.add(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c);
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
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
        for(Service_Order_Line_Item__c soliRec : soLineItemList) {
            if(soliRec.Fee__r.Applicable_Tax__c != null) {
                salesTaxIdList.add(soliRec.Fee__r.Applicable_Tax__c);
            } else if(soliRec.Labour_Code__r.Applicable_Tax__c != null) {
                salesTaxIdList.add(soliRec.Labour_Code__r.Applicable_Tax__c);
            } 
        }
        
        List<Service_Order_Line_Item__c> soliListToUpdate = new List<Service_Order_Line_Item__c>();
        
        if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Applicable_Taxes__c> applicableTaxList = [SELECT Sales_Tax_Item__c, Sales_Tax__c, Sales_Tax_Item__r.Tax_Parts__c, 
                                                            Sales_Tax_Item__r.Name__c, Sales_Tax_Item__r.Rate__c 
                                                            from Applicable_Taxes__c where Sales_Tax__c IN : salesTaxIdList];
        
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
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        List<Individual_Tax__c> individualTaxToInsert = new List<Individual_Tax__c>();
        for(Service_Order_Line_Item__c soliRec : soLineItemList) {
            Id salesTaxId;
            if(soliRec.Fee__r.Applicable_Tax__c != null) {
                salesTaxId = soliRec.Fee__r.Applicable_Tax__c;
            } else if(soliRec.Labour_Code__r.Applicable_Tax__c != null) {
                salesTaxId = soliRec.Labour_Code__r.Applicable_Tax__c;
            } 
            if(salesTaxId == null) {
                continue;
            }
            
            Decimal exemptionRate = 0;
            if(salesTaxIdToAppTaxRecordsMap.containsKey(salesTaxId)) {
                for(Applicable_Taxes__c appTax : salesTaxIdToAppTaxRecordsMap.get(salesTaxId)) {
                    if(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c != null && 
                        customerIdToSalesTaxItemIdsMap.get(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c).contains(appTax.Sales_Tax_Item__c)) 
                    {
                        exemptionRate += appTax.Sales_Tax_Item__r.Rate__c;
                    } else if(soliRec.Service_Order_Header__r.CO_Header__r.Customer__c != null){
                        Individual_Tax__c individualTaxRec = new Individual_Tax__c();
                        individualTaxRec.Service_Order_Line_Item__c = soliRec.Id;
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
            soliRec.Tax_Percent__c = rate - exemptionRate;
            if(isTaxIncludingPricing && soliRec.Labour_Code__c != null) {
            	soliRec.Kit_Price__c = (soliRec.Kit_Price__c / (1 + (soliRec.Tax_Percent__c / 100))).setScale(2);
            	soliRec.Actual_Kit_Price__c = soliRec.Kit_Price__c;
            }
            soliListToUpdate.add(soliRec);
        }
        
        if(individualTaxToInsert.size() > 0) {
            if(AccessControl.ifObjectFieldIsCreateable('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            insert individualTaxToInsert;
        }
        
        if(soliListToUpdate.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update soliListToUpdate;
        }
    }
}