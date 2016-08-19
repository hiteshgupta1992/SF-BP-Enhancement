/**
 * Author: Ashish Garg
 * Since: Dec. 25, 2015
 * Name: SO_KLI_Recalculation
 * Description: Class is used for relacultaion logic perform for Service Order Kits line item recalculation
**/
public with sharing class SO_KLI_Recalculation {
    /**
     * Name: SOPriceCalcultaionByPriceLevel
     * Desc: Method to calculate kit price for all Service Orders under csutomer order Id passed in parameters.
     *       Kit price is as per the price level declared on customer added to customer order
     * @param:  1. Id customerId
     *          2. Id customerOrderId
     * @return:
    **/
    public static void SOPriceCalcultaionByPriceLevel(Id customerId, Id customerOrderId) {
        SOPriceCalcultaionByPriceLevel(null, customerId, customerOrderId, null, null, null, null);
    }
    
    /**
     * Name: SOPriceCalcultaionByPriceLevelForServiceOrders
     * Desc: Method to calculate kit price for all Service Orders under csutomer order Id passed in parameters.
     *       Kit price is as per the price level declared on customer added to customer order
     * @param:  1. Id customerId
     *          2. Id customerOrderId
     *          3. List<Id> sohIds
     * @return:
    **/
    public static void SOPriceCalcultaionByPriceLevelForServiceOrders(Id customerId, Id customerOrderId, List<Id> sohIds) {
        SOPriceCalcultaionByPriceLevel(null, customerId, customerOrderId, sohIds, null, null, null);
    }
    
    /**
     * Name: SOPriceCalcultaionByPriceLevelForSOKitHeaders
     * Desc: Method to calculate kit price for all Service Orders Kit Header records under csutomer order Id passed in parameters.
     *       Kit price is as per the price level declared on customer added to customer order
     * @param:  1. Id customerId
     *          2. Id customerOrderId
     *          3. List<Id> sokhIds
     * @return:
    **/
    
    public static void SOPriceCalcultaionByPriceLevelForSOKitHeaders(Id customerId, Id customerOrderId, List<Id> sokhIds, String soHeaderId) {
        SOPriceCalcultaionByPriceLevel(null, customerId, customerOrderId, null, sokhIds, null, soHeaderId);
    }
    
    /**
     * Name: SOPriceCalcultaionByPriceLevelForSOKitHeaderLIs
     * Desc: Method to calculate kit price for all Service Orders Kit Header Line Item records under csutomer order Id passed in parameters.
     *       Kit price is as per the price level declared on customer added to customer order
     * @param:  1. Id customerId
     *          2. Id customerOrderId
     *          3. List<Id> sokhIds
     * @return:
    **/
    public static void SOPriceCalcultaionByPriceLevelForSOKitHeaderLIs(Id customerId, Id customerOrderId, List<Id> sokhliIds) {
        SOPriceCalcultaionByPriceLevel(null, customerId, customerOrderId, null, null, sokhliIds, null);
    }
    
    /**
     * Name: SOPriceCalcultaionByPriceLevel
     * Desc: Method to calculate kit price for all Service Orders under csutomer order Id passed in parameters.
     *       Kit price is as per the price level declared on customer added to customer order
     * @param:  1. Account customer     - Cutomer record associated with customer order
     *          2. Id customerId        - Customer Id
     *          3. Id customerOrderId   - Customer Order record Id
     *          4. List<Id> sohIds      - Ids list of service order header records for which price need to be calculated
     *          5. List<Id> sokhIds     - Ids list of service order Kit header records for which price need to be calculated
     *          6. List<Id> sokhliIds   - Ids list of service order Kit header Line Items records for which price need to be calculated
     * @return:
    **/
    private static void SOPriceCalcultaionByPriceLevel(Account customer, Id customerId, Id customerOrderId, List<Id> sohIds, List<Id> sokhIds, List<Id> sokhliIds, String soHeaderId) {
        List<Service_Order_Header__c> soHeaderList = new List<Service_Order_Header__c>();
        List<Tax_Exemption__c> taxExtemptionList = new List<Tax_Exemption__c>(); 
        if(soHeaderId != null) {
            if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            soHeaderList = [select Provider__c, Provider__r.Price_Level__r.Active__c, Provider__r.Price_Level__r.Discount_Markup__c, Provider__r.Price_Level__r.Labour_Rate__c  
                                                    from Service_Order_Header__c where Id = :soHeaderId];
        }
        
        // Get the custoemr record by customer id
        if(customer == null){
            if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            customer = [SELECT  Id, 
                                Price_Level__c, 
                                Price_Level__r.Active__c, 
                                Price_Level__r.Discount_Markup__c, 
                                Price_Level__r.Labour_Rate__c 
                                FROM Account
                                WHERE Id =: customerId
                        ];
        }
        
        Price_Level__c priceLevel;
        if(soHeaderList.size() > 0 && soHeaderList[0].Provider__c != null && soHeaderList[0].Provider__r.Price_Level__c != null) {
            priceLevel = new Price_Level__c(Active__c = soHeaderList[0].Provider__r.Price_Level__r.Active__c,
                                            Discount_Markup__c = soHeaderList[0].Provider__r.Price_Level__r.Discount_Markup__c,
                                            Labour_Rate__c = soHeaderList[0].Provider__r.Price_Level__r.Labour_Rate__c
                                        );
            
            if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            taxExtemptionList = [select Id,Sales_Tax_Item__r.Rate__c,Sales_Tax_Item__c from Tax_Exemption__c where Customer__c =: soHeaderList[0].Provider__c];
                                        
        } else if(customer.Price_Level__r != null) {
            
            priceLevel = new Price_Level__c(Active__c = customer.Price_Level__r.Active__c,
                                                        Discount_Markup__c = customer.Price_Level__r.Discount_Markup__c,
                                                        Labour_Rate__c = customer.Price_Level__r.Labour_Rate__c
                                                    );
			if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }                                                    
            taxExtemptionList = [select Id,Sales_Tax_Item__r.Rate__c,Sales_Tax_Item__c from Tax_Exemption__c where Customer__c =: customerId];
            
        } else {
            if(AccessControl.ifObjectFieldIsAccessible('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Price_Level__c> defaultPriceLevel = [select Discount_Markup__c, Labour_Rate__c, Active__c from Price_Level__c where Default__c = true];
            if(defaultPriceLevel.size() == 0) {
                return;
            }
            if(customerId !=null){
            	if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            	taxExtemptionList = [select Id,Sales_Tax_Item__r.Rate__c,Sales_Tax_Item__c from Tax_Exemption__c where Customer__c =: customerId];
            }
            priceLevel = defaultPriceLevel[0];
        }
        
        // Get all service order records for customer orders
        String serviceOrderKitHeaderQuery = 'SELECT Id, Fixed_Price__c, Fixed_Price_Flag__c,';
        String sokhlisQuery = ' (SELECT Id, Actual_Kit_Price__c,Fixed_Price__c, Kit_Price__c, Retail_Price__c, Qty_Needed__c, Part__r.Retail_Price__c,Part__r.Applicable_Tax__r.Rate__c,Fee__c,Labour_Code__c,Labour_Code__r.Fixed_Rate__c,Labour_Code__r.Rate__c, Total__c, Service_Order_Kit_Header__c FROM Service_Order_Line_Items__r' + ( (sokhliIds != null && sokhliIds.size() > 0) ? ' AND Id IN: sokhliIds': '' ) + ')';
        serviceOrderKitHeaderQuery += sokhlisQuery + ' FROM Service_Order_Kit_Header__c WHERE Service_Order_Header__r.CO_Header__c =: customerOrderId' 
                                      + ( (sohIds != null && sohIds.size() > 0) ? ' AND Service_Order_Header__c IN: sohIds' : '' )
                                      + ( (sokhIds != null && sokhIds.size() > 0) ? ' AND Id IN: sokhIds': '' );
        
        //System.assert( false, serviceOrderKitHeaderQuery );
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Service_Order_Kit_Header__c> sokhList = Database.query(serviceOrderKitHeaderQuery);
        // List of all service order kit headers to update due to price recalculation:
        List<sObject> soKitHeadersToUpdate = new List<sObject>();
        
        // List of all service order kit header Line Items to update due to price recalculation:
        List<sObject> soKHLineItemsToUpdate = new List<sObject>();
        
        Set<Id> partIdSet = new Set<Id>(); 
        Set<Id> feeIdSet = new Set<Id>();
        Set<Id> laborIdSet = new Set<Id>();
        Set<Id> soliIdSet = new Set<Id>();
       
        for(Service_Order_Kit_Header__c soKitHeader : sokhList){
            for(Service_Order_Line_Item__c soli : soKitHeader.Service_Order_Line_Items__r){
                if(soli.Part__c !=null){
                    partIdSet.add(soli.Part__c);
                }else if (soli.Fee__c  !=null){
                     feeIdSet.add(soli.Fee__c);
                }else if (soli.Labour_Code__c  !=null){
                    laborIdSet.add(soli.Labour_Code__c);
                }
                soliIdSet.add(soli.Id);
            }
        }  
        
         
          if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Fee__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Labour_Code__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          List<Part__c>  listPartSalesTax= new list<Part__c> ([Select Id,Applicable_Tax__r.Rate__c,Applicable_Tax__c From Part__c  where Id IN:partIdSet ]);
          List<Fee__c>  listFeeSalesTax= new list<Fee__c> ([Select Id,Applicable_Tax__r.Rate__c,Applicable_Tax__c From Fee__c  where Id IN:feeIdSet ]);
          List<Labour_Code__c>  listLaborPrices = new list<Labour_Code__c> ([Select Id,Fixed_Rate__c,Applicable_Tax__r.Rate__c,Applicable_Tax__c From Labour_Code__c  where Id IN:laborIdSet ]);
          
           Map<Id,Decimal> partIdToPartRateMap = new  Map<Id,Decimal>();
           Map<Id,List<Id>> SalesTaxIdToPartIdMap = new Map<Id,List<Id>>();
           Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap = new Map<Id,List<Sales_Tax_Item__c>>();
           for(Part__c  partRec : listPartSalesTax){
                partIdToPartRateMap.put(partRec.Id,partRec.Applicable_Tax__r.Rate__c);  
                if(SalesTaxIdToPartIdMap.containsKey(partRec.Applicable_Tax__c)){
                    SalesTaxIdToPartIdMap.get(partRec.Applicable_Tax__c).add(partRec.Id);
                }else{
                    SalesTaxIdToPartIdMap.put(partRec.Applicable_Tax__c, new List<Id>{partRec.Id});
                }
           } 
           
           for(Fee__c  feeRec : listFeeSalesTax){
                partIdToPartRateMap.put(feeRec.Id,feeRec.Applicable_Tax__r.Rate__c);
                if(SalesTaxIdToPartIdMap.containsKey(feeRec.Applicable_Tax__c)){
                    SalesTaxIdToPartIdMap.get(feeRec.Applicable_Tax__c).add(feeRec.Id);
                }else{
                    SalesTaxIdToPartIdMap.put(feeRec.Applicable_Tax__c, new List<Id>{feeRec.Id});
                }
           }
            for(Labour_Code__c  laborRec : listLaborPrices){
                partIdToPartRateMap.put(laborRec.Id,laborRec.Applicable_Tax__r.Rate__c);
                if(SalesTaxIdToPartIdMap.containsKey(laborRec.Applicable_Tax__c)){
                    SalesTaxIdToPartIdMap.get(laborRec.Applicable_Tax__c).add(laborRec.Id);
                }else{
                    SalesTaxIdToPartIdMap.put(laborRec.Applicable_Tax__c, new List<Id>{laborRec.Id});
                }
           }
       
          if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          List<Applicable_Taxes__c> applicableTaxJunctionList = [select Id,Sales_Tax__c,Sales_Tax_Item__c,Sales_Tax_Item__r.Rate__c, Sales_Tax_Item__r.Name__c from Applicable_Taxes__c where  Sales_Tax__c IN : SalesTaxIdToPartIdMap.keySet()];
          List<Individual_Tax__c> IndividualTaxToinsert = new List<Individual_Tax__c>();
          for(Applicable_Taxes__c ApplicableTaxRec :  applicableTaxJunctionList){
                    List<Id> PartSalesTaxList = SalesTaxIdToPartIdMap.get(ApplicableTaxRec.Sales_Tax__c);
                    for(Id PartSalesTaxRecId  :  PartSalesTaxList){
                        if(PartSalesTaxRecId != null ){
                            if(PartIdToSalesTaxItemMap.containsKey(PartSalesTaxRecId)){
                                Sales_Tax_Item__c objSalesTaxItem = new Sales_Tax_Item__c( Id = ApplicableTaxRec.Sales_Tax_Item__c,Rate__c =ApplicableTaxRec.Sales_Tax_Item__r.Rate__c, Name__c = ApplicableTaxRec.Sales_Tax_Item__r.Name__c);
                                PartIdToSalesTaxItemMap.get(PartSalesTaxRecId).add(objSalesTaxItem);
                            }else{
                                    Sales_Tax_Item__c objSalesTaxItem = new Sales_Tax_Item__c( Id = ApplicableTaxRec.Sales_Tax_Item__c,Rate__c =ApplicableTaxRec.Sales_Tax_Item__r.Rate__c, Name__c = ApplicableTaxRec.Sales_Tax_Item__r.Name__c);
                                    PartIdToSalesTaxItemMap.put(PartSalesTaxRecId,new List<Sales_Tax_Item__c>{objSalesTaxItem});
                            }  
                        }
                    } 
           }
           
           
            // Iterate all service order kit header records, and recalculate price for kit line items
            for(Service_Order_Kit_Header__c soKitHeader : sokhList){
                if(soKitHeader.Service_Order_Line_Items__r != null && soKitHeader.Service_Order_Line_Items__r.size() > 0){
                    List<sObject> solis = new List<sObject>();
                    // Different logics as per kit header fixed-unfixed price
                    if(soKitHeader.Fixed_Price_Flag__c == false){
                        solis = (List<sObject>) unfixedKHRecalculationOnSOKHLineItems( soKitHeader,  priceLevel , taxExtemptionList, partIdToPartRateMap,PartIdToSalesTaxItemMap,IndividualTaxToinsert);
                    } else {
                        solis = (List<sObject>) unfixedKHRecalculationOnSOKHLineItems( soKitHeader,  priceLevel , taxExtemptionList, partIdToPartRateMap,PartIdToSalesTaxItemMap,IndividualTaxToinsert);
                    }
                    
                    if(solis.size() > 0){
                        soKHLineItemsToUpdate.addAll(solis);
                        soKitHeadersToUpdate.add(new Service_Order_Kit_Header__c(Id = soKitHeader.Id, Fixed_Price__c = soKitHeader.Fixed_Price__c,Tax_amount__c =soKitHeader.Tax_amount__c ));
                    }
                }
            }  
         
        // A list of records being updated
       	// system.assert(false,IndividualTaxToinsert);
        
        List<sObject> recordsToUpdate = new List<sObject>();
        
        
        if(soKitHeadersToUpdate.size() > 0){
            recordsToUpdate.addAll(soKitHeadersToUpdate);
        }
        if(soKHLineItemsToUpdate.size() > 0){
            recordsToUpdate.addAll(soKHLineItemsToUpdate);
        }
        
        if(recordsToUpdate.size() > 0){
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted =true; 
            update recordsToUpdate;
        }
        
        if(AccessControl.ifObjectFieldIsAccessible('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Individual_Tax__c> IndividualListTodelete	=new List<Individual_Tax__c>([select Id, Sales_Tax_Item_Name__c,Service_Order_Line_Item__c,Tax_Rate__c from Individual_Tax__c where Id IN :soliIdSet]);
        //system.assert(false,IndividualListTodelete  + '   ' + soliIdSet + ' ' +IndividualTaxToinsert); 
        
        if(AccessControl.ifObjectIsDeletable('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        if(IndividualListTodelete.size()>0 ){
			delete IndividualListTodelete;        
        }
        if(AccessControl.ifObjectIsCreateable('Individual_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(IndividualTaxToinsert.size()>0){
        	insert IndividualTaxToinsert;
        }
    }
    
    
    private static List<Service_Order_Line_Item__c> unfixedKHRecalculationOnSOKHLineItems(Service_Order_Kit_Header__c soKitHeader, Price_Level__c priceLevel , List<Tax_Exemption__c> taxExtemptionList, Map<Id,Decimal> partIdToPartRateMap, Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap, List<Individual_Tax__c> IndividualTaxToinsert) {
        List<Service_Order_Line_Item__c> solisList = new List<Service_Order_Line_Item__c>();
        decimal exTotalUnfixed = 0;
        decimal plAppliedTotalUnfixed = 0;
        decimal withoutPLUnfixedTotal = 0;
        decimal PartRate = 0.00;
        decimal TotalTaxApplicable=0.00;
        decimal KitHeaderTotal = 0.00;
        decimal taxAmount=0.00; 
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
         
        if(isTaxIncludingPricing){
            for(Service_Order_Line_Item__c soli : soKitHeader.Service_Order_Line_Items__r){
                system.debug('$$$$$$$$$' + soli.Retail_Price__c  + ' ' +  soli.Actual_Kit_Price__c + ' ' +  ''+soli.Kit_Price__c+   soli.Part__c + ' ' + soli.Labour_Code__c );
                if(soli.Part__c !=null){
                    soli.Kit_Price__c = (soli.Part__c != null) ? soli.Actual_Kit_Price__c : soli.Retail_Price__c;
                    PartRate = (soli.Part__r.Applicable_Tax__r.Rate__c)!=null ? (soli.Part__r.Applicable_Tax__r.Rate__c) : 0;
                }
                
                if(!soli.Fixed_Price__c && soli.Part__c !=null  ){
                    if(soKitHeader.Fixed_Price_Flag__c ){  
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        Decimal preTaxPricing = soli.Kit_Price__c/ (1 + (TotalTaxApplicable / 100));
                        soli.Kit_Price__c = preTaxPricing.setscale(2);
                        soli.Tax_Percent__c = TotalTaxApplicable;  
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c);  
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                        system.debug('#######' +  soli.Kit_Price__c  + ' ' + soli.Tax_Percent__c);
                  }else{
                        Decimal preTaxPricing = soli.Kit_Price__c / (1 + (PartRate / 100));
                        soli.Kit_Price__c = preTaxPricing + (preTaxPricing *  priceLevel.Discount_Markup__c / 100);
                        soli.Kit_Price__c = soli.Kit_Price__c.setscale(2);
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        soli.Tax_Percent__c = TotalTaxApplicable;
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c); 
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                      
                    }       
                }else if(soli.Fixed_Price__c && soli.Part__c !=null){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        Decimal preTaxPricing = soli.Kit_Price__c/ (1 + (TotalTaxApplicable / 100));
                        soli.Kit_Price__c = preTaxPricing.setscale(2);
                        soli.Tax_Percent__c = TotalTaxApplicable;
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c); 
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                         system.debug('#######fixed' +  soli.Kit_Price__c  + ' ' + soli.Tax_Percent__c);
                }else if(soli.Fee__c !=null){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        Decimal preTaxPricing = soli.Kit_Price__c/ (1 + (TotalTaxApplicable / 100));
                        soli.Kit_Price__c = preTaxPricing.setscale(2);
                        soli.Tax_Percent__c = TotalTaxApplicable;  
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c);   
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                 }else if(soli.Labour_Code__c !=null){ 
                      if(!(soli.Fixed_Price__c || soli.Labour_Code__r.Fixed_Rate__c || soKitHeader.Fixed_Price_Flag__c ) ){ // Add Price Level 0 Condition
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        
                         Decimal preTaxPricing = priceLevel.Labour_Rate__c/ (1 + (TotalTaxApplicable / 100));
                        soli.Kit_Price__c = preTaxPricing.setscale(2);
                        soli.Tax_Percent__c = TotalTaxApplicable;
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c); 
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                          
                    } else{
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                        Decimal preTaxPricing = soli.Kit_Price__c/ (1 + (TotalTaxApplicable / 100));
                        soli.Kit_Price__c = preTaxPricing.setscale(2);
                        soli.Tax_Percent__c = TotalTaxApplicable;
                        KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c); 
                        if(soli.Tax_Percent__c != null) {
                            taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                        }
                          
                      }
                      
                    
                 }
                 solisList.add(soli);
            }
         }else{
                for(Service_Order_Line_Item__c soli : soKitHeader.Service_Order_Line_Items__r){
                    if(!soli.Fixed_Price__c && soli.Part__c !=null ){
                         if(soKitHeader.Fixed_Price_Flag__c ){  
                                    TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                                    soli.Tax_Percent__c = TotalTaxApplicable;  
                                    KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2);  
                                    if(soli.Tax_Percent__c != null) {
                                        (taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                                    }
                              }else{
                                    soli.Kit_Price__c = soli.Kit_Price__c + (soli.Kit_Price__c *  priceLevel.Discount_Markup__c / 100);
                                    soli.Kit_Price__c = soli.Kit_Price__c.setscale(2);
                                    TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                                    soli.Tax_Percent__c = TotalTaxApplicable;
                                    KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2); 
                                    if(soli.Tax_Percent__c != null) {
                                        taxAmount +=  ((soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                                    }
                            }  
                       } else if (soli.Fixed_Price__c && soli.Part__c !=null ){
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                            soli.Tax_Percent__c = TotalTaxApplicable;
                            KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c);  
                            if(soli.Tax_Percent__c != null) {  
                                taxAmount +=  (soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100;
                            }
                       } else if (soli.Fixed_Price__c && soli.Part__c !=null ){
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                            soli.Tax_Percent__c = TotalTaxApplicable;
                            KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2);
                            if(soli.Tax_Percent__c != null) {  
                                taxAmount +=  ((soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                            }
                       } else if(soli.Fee__c !=null){
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                            soli.Tax_Percent__c = TotalTaxApplicable;
                            KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2);
                            if(soli.Tax_Percent__c != null) {  
                                taxAmount +=  ((soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                            }
                       }
                       else if(soli.Labour_Code__c !=null){
                        if(!(soli.Fixed_Price__c || soli.Labour_Code__r.Fixed_Rate__c )){
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                            soli.Tax_Percent__c = TotalTaxApplicable;
                            KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2);  
                            if(soli.Tax_Percent__c != null) {  
                                taxAmount +=  ((soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                            }
                        }else{
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,soli,taxExtemptionList,IndividualTaxToinsert);
                            soli.Tax_Percent__c = TotalTaxApplicable;
                            KitHeaderTotal += (soli.Qty_Needed__c * soli.Kit_Price__c).setscale(2);  
                            if(soli.Tax_Percent__c != null) {  
                                taxAmount +=  ((soli.Qty_Needed__c * soli.Kit_Price__c * soli.Tax_Percent__c) / 100).setscale(2);
                            }
                        }
                        
                       }    
                       solisList.add(soli);             
                }  
                
            }
            
         
          
            soKitHeader.Fixed_Price__c = KitHeaderTotal;
            soKitHeader.Tax_amount__c = taxAmount;
            return solisList;
    }
    /**
     * Name: unfixedKHRecalculationOnSOKHLineItems
     * Desc: Method to calculate kit price for all service order kit line items for UNFIXED PRICE Service Order Kit Header record passed
     * @param:  1. Service_Order_Kit_Header__c soKitHeader
     *          2. Price_Level__c priceLevel
     * @return: List<Service_Order_Line_Item__c>
    **/
    private static List<Service_Order_Line_Item__c> unfixedKHRecalculationOnSOKHLineItems(Service_Order_Kit_Header__c soKitHeader, Price_Level__c priceLevel) {
        List<Service_Order_Line_Item__c> solisList = new List<Service_Order_Line_Item__c>();
        
        decimal exTotalUnfixed = 0;
        decimal plAppliedTotalUnfixed = 0;
        decimal withoutPLUnfixedTotal = 0;

        // Calculate total of ex and desired kit price of all solis
        for(Service_Order_Line_Item__c soli : soKitHeader.Service_Order_Line_Items__r){
            //soli.Kit_Price__c = soli.Qty_Needed__c * ( (soli.Part__c != null) ? soli.Actual_Kit_Price__c : soli.Retail_Price__c );
            soli.Kit_Price__c = (soli.Part__c != null) ? soli.Actual_Kit_Price__c : soli.Retail_Price__c;
            
            // Calculate kit price of service order line item as per assigned price level
            if(soli.Part__c != null){
                withoutPLUnfixedTotal += (soli.Kit_Price__c * soli.Qty_Needed__c);
                exTotalUnfixed += (soli.Kit_Price__c + (soli.Kit_Price__c * priceLevel.Discount_Markup__c / 100)) * soli.Qty_Needed__c;
                soli.Kit_Price__c = soli.Kit_Price__c + (soli.Kit_Price__c * priceLevel.Discount_Markup__c / 100);
            } else {
                withoutPLUnfixedTotal += soli.Kit_Price__c * soli.Qty_Needed__c;
                exTotalUnfixed += priceLevel.Labour_Rate__c;
                
                if(!soli.Labour_Code__r.Fixed_Rate__c) {
                    soli.Kit_Price__c = priceLevel.Labour_Rate__c;
                } else {
                    soli.Kit_Price__c = soli.Labour_Code__r.Rate__c;
                }
            }
            soli.Kit_Price_With_Price_Level__c = soli.Kit_Price__c;
            plAppliedTotalUnfixed += soli.Kit_Price__c * soli.Qty_Needed__c;
        }
        //system.assert(false, plAppliedTotalUnfixed + ' ' + withoutPLUnfixedTotal + ' ' + exTotalUnfixed);
        // The difference factor of desired total kit price to actual kit price total
        decimal differenceFactor = plAppliedTotalUnfixed / exTotalUnfixed;
         
        // Difference amount in both totals and this will be adjusted in kit header total amount
        decimal difference = exTotalUnfixed - plAppliedTotalUnfixed;
        
        if(soKitHeader.Fixed_Price_Flag__c == true) {
            soKitHeader.Fixed_Price__c = soKitHeader.Fixed_Price__c + (soKitHeader.Fixed_Price__c * priceLevel.Discount_Markup__c / 100);
        } else {
            soKitHeader.Fixed_Price__c -= withoutPLUnfixedTotal;
            soKitHeader.Fixed_Price__c += plAppliedTotalUnfixed;
        }
        soKitHeader.Fixed_Price__c -= difference;
        
        // The difference factor is need to be applied to kit price for all kit line items as recalculation logic
        for(Service_Order_Line_Item__c soli : soKitHeader.Service_Order_Line_Items__r){
            soli.Kit_Price__c = soli.Kit_Price__c * differenceFactor;
            solisList.add(soli);
        }
        
        return solisList;
    }
    
    /**
     * Name: updateSOKitHeader
     * Desc: Update Service order Kit header
     * @param: SOHeaderWrapper.SOKitHeader soKitHeaderObj
     * @return: String - get Main JSON data.
     **/
    public static Errorhandler updateSOKitHeader(SOHeaderWrapper.SOKitHeader soKitHeaderObj) {
        Service_Order_Kit_Header__c sokitHeaderRec = new Service_Order_Kit_Header__c();
        sokitHeaderRec.Id = soKitHeaderObj.Id;
        sokitHeaderRec.Fixed_Price__c = soKitHeaderObj.FixedPrice;

        Errorhandler error = validateSOKitHeader(soKitHeaderObj, sokitHeaderRec);
        if (sokitHeaderRec.Id != null && error.ResponseCode == '200' && sokitHeaderRec.Is_Fixed_Kit_Header_SO__c) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            set<Id> ServiceOrderHeaderSet = new Set<Id>();
            List<Service_Order_Kit_Header__c> ServiceOrderKitHeaderList = [select  Id,Service_Order_Header__c from  Service_Order_Kit_Header__c where Id =:soKitHeaderObj.Id];
            for(Service_Order_Kit_Header__c soKitHeaderRecItem : ServiceOrderKitHeaderList){
                ServiceOrderHeaderSet.add(soKitHeaderRecItem.Service_Order_Header__c);
            }
            UpdateSoTotals(ServiceOrderHeaderSet);                                  
            //update sokitHeaderRec;
        }
                        
        
        return error;
    }
    
    public static void UpdateSoTotals(set<Id> ServiceOrderHeaderSet){
        List<Service_Order_Header__c>   serviceOrderHeaderList = ([select Id,Total__c,Tax_Amount__c,(SELECT Kit_Price__c,Qty_Needed__c ,Total__c,Tax_Percent__c ,Qty_To_Order__c FROM Service_Order_Line_Items__r) from Service_Order_Header__c where Id IN: ServiceOrderHeaderSet]);
        for(Service_Order_Header__c soHeaderRec : serviceOrderHeaderList){
            decimal total =0;
            decimal taxAmount =0;
            boolean IsInvoiceable = true; 
            for(Service_Order_Line_Item__c soliRec : soHeaderRec.Service_Order_Line_Items__r) {
                if(soliRec.Qty_To_Order__c > 0) {
                    IsInvoiceable = false;
                }
                total += (soliRec.Kit_Price__c * soliRec.Qty_Needed__c).setscale(2);
                taxAmount += ((soliRec.Kit_Price__c * soliRec.Kit_Price__c * soliRec.Tax_Percent__c) / 100).setscale(2);
            }
            soHeaderRec.Total__c = total;
            soHeaderRec.Tax_Amount__c = taxAmount;
        }
        if(serviceOrderHeaderList.size() > 0){
            update serviceOrderHeaderList;
        }   
    }
    
    /**
     * Name: updateSOKitLineItem
     * Desc: Method related to updation of service order kit line items fixed price value
     * @param: SOHeaderWrapper.SOLineItem sokitLineItemObj - SOHeaderWrapper.SOLineItem JSON
     * @return: String - get Main JSON data.
     **/
    public static Errorhandler updateSOKitLineItem(SOHeaderWrapper.SOLineItem sokitLineItemObj) {
        Service_Order_Line_Item__c sokitLineItemRec = new Service_Order_Line_Item__c();
        sokitLineItemRec.Id = sokitLineItemObj.Id;
        sokitLineItemRec.Qty_Needed__c = sokitLineItemObj.QtyNeeded;
        sokitLineItemRec.Kit_Price__c = sokitLineItemObj.KitPrice;
        
        
        String errorMessage = '';
        Id sokitHeaderId = sokitLineItemObj.SOkitHeaderId;
        if(sokitHeaderId != null){
            Errorhandler error = validateSOKitLineItemOnUpdate(sokitHeaderId, sokitLineItemObj, sokitLineItemRec);
            if (sokitHeaderId != null && error.ResponseCode == '200' && sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c) {
                update sokitLineItemRec;
            }
            
            errorMessage = (error.ResponseCode != '200') ? error.ResponseMeassage : '';
        }
        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
    }
    
    /**
     * Name: validateSOKitHeader
     * Desc: Validate Service Order kit Header record being updated here
     * @param: SOHeaderWrapper.SOHeader soKitHeaderObj
     * @return: Errorhandler response result by validation
     **/
    private static Errorhandler validateSOKitHeader(SOHeaderWrapper.SOKitHeader soKitHeaderObj, Service_Order_Kit_Header__c sokitHeaderRec) {
        // Get all service order records for customer orders
        String serviceOrderKitHeaderQuery = 'SELECT Id, Fixed_Price__c, Fixed_Price_Flag__c, Is_Fixed_Kit_Header_SO__c,Tax_Amount__c,';
        String sokhlisQuery = ' (SELECT Id, Fixed_Price__c, Actual_Kit_Price__c, Kit_Price__c,Tax_Amount__c, Qty_Needed__c,Tax_Percent__c, Total__c, Is_Fixed_Kit_LineItem_SO__c FROM Service_Order_Line_Items__r)';
        serviceOrderKitHeaderQuery += sokhlisQuery + ' FROM Service_Order_Kit_Header__c WHERE Id = \'' + soKitHeaderObj.Id + '\'';
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        List<Service_Order_Kit_Header__c> sokhList = Database.query(serviceOrderKitHeaderQuery);
        Service_Order_Kit_Header__c databseSOKHRecoord = (sokhList.size() > 0) ? sokhList[0] : null;
        
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        String errorMessage = '';
        if (databseSOKHRecoord != null) {  
            Integer countUnfixedLineItems = 0;
            Decimal totalFixedPrice = 0;
            
            if(databseSOKHRecoord.Fixed_Price_Flag__c == false && databseSOKHRecoord.Service_Order_Line_Items__r != null){
                if(isTaxIncludingPricing){
                    if((sokitHeaderRec.Fixed_Price__c).setscale(2)  !=  (databseSOKHRecoord.Fixed_Price__c + databseSOKHRecoord.Tax_Amount__c).setscale(2)) {
                        sokitHeaderRec.Is_Fixed_Kit_Header_SO__c = true;
                        databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c = true;
                    }else{
                        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
                    }
                }else{
                    if(sokitHeaderRec.Fixed_Price__c != databseSOKHRecoord.Fixed_Price__c) {
                        sokitHeaderRec.Is_Fixed_Kit_Header_SO__c = true;
                        databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c = true;
                    }else{
                        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
                    }
                        
                }
                
                for (Service_Order_Line_Item__c sokhLineItemRec : databseSOKHRecoord.Service_Order_Line_Items__r) {
                    if (!sokhLineItemRec.Fixed_Price__c && !sokhLineItemRec.Is_Fixed_Kit_LineItem_SO__c) {
                        countUnfixedLineItems++;
                    } else {
                        totalFixedPrice += sokhLineItemRec.Total__c;
                    }
                }
                
            
                if(soKitHeaderObj.FixedPrice < totalFixedPrice ){
                    return  new Errorhandler('300', 'Cannot update item Fixed price must be equal to total');
                } 
                  
                //system.assert(false,countUnfixedLineItems);
                if(soKitHeaderObj.FixedPrice == totalFixedPrice && countUnfixedLineItems == 0){
                    errorMessage = '';
                } else if(soKitHeaderObj.FixedPrice != totalFixedPrice && countUnfixedLineItems == 0){
                    errorMessage = Label.Kit_Header_Less_fixed_price_amount;
                } else if(countUnfixedLineItems == 0) {
                    errorMessage = Label.Kit_Header_No_unfixed_Line_Items;
                } 
                
                //system.assert(false,errorMessage);
                // If update is valid, then recalculate all line items price
                if(errorMessage.length() == 0){
                    databseSOKHRecoord.Fixed_Price__c = soKitHeaderObj.FixedPrice;
                    
                    recalculateSOKHLineItems(databseSOKHRecoord,true);
                    
                }
            }
        }
        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
    }
    
    /**
     * Name: recalculateSOKHLineItems
     * Desc: Method to recalculate service order kit heder line items price after updations in service order kit header fixed price value
     * @param: Service_Order_Kit_Header__c databseSOKHRecoord
     * @return: 
     **/
    private static void recalculateSOKHLineItems(Service_Order_Kit_Header__c databseSOKHRecoord,boolean KitHeader ) {
        
        List<Service_Order_Line_Item__c> updateKitLineItems = new List<Service_Order_Line_Item__c>();
        Map<Id, Service_Order_Line_Item__c> unFixedLineItemsMap = new Map<Id, Service_Order_Line_Item__c>();
        List<Service_Order_Line_Item__c> ServicelineItemlist = new List<Service_Order_Line_Item__c>();
        Double fixedItemTotal = 0;
        Double unFixedItemTotal = 0;
        Decimal TotalPrice = 0;
        Decimal TotalTaxAmount = 0;
        //system.assert(false,databseSOKHRecoord);
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        for(Service_Order_Line_Item__c khli : databseSOKHRecoord.Service_Order_Line_Items__r){
            if(khli.Fixed_Price__c || khli.Is_Fixed_Kit_LineItem_SO__c){
                if(isTaxIncludingPricing){
                    //system.assert(false,khli);
                    fixedItemTotal += (khli.Kit_Price__c * khli.Qty_Needed__c ) + khli.Tax_Amount__c;
                    ServicelineItemlist.add(khli);
                }else{
                    fixedItemTotal += (khli.Kit_Price__c * khli.Qty_Needed__c );   
                }
                system.debug('%%%%%%%%' + khli.Kit_Price__c  +' '+  khli.Qty_Needed__c +' '+ khli.Tax_Amount__c);
            } else { 
                unFixedLineItemsMap.put(khli.Id, khli);
                if(isTaxIncludingPricing){
                    unFixedItemTotal += (khli.Kit_Price__c  *  khli.Qty_Needed__c) + khli.Tax_Amount__c;
                }else{
                    unFixedItemTotal += (khli.Kit_Price__c  *  khli.Qty_Needed__c);
                }
                
            }
        } 
        Double desiredUnFixedTotal = 0; 
        if(KitHeader){
            desiredUnFixedTotal = databseSOKHRecoord.Fixed_Price__c  - fixedItemTotal;
        }else{
            if((isTaxIncludingPricing)){
                desiredUnFixedTotal = (databseSOKHRecoord.Fixed_Price__c + databseSOKHRecoord.Tax_Amount__c )  - fixedItemTotal;
            }else{
                desiredUnFixedTotal = databseSOKHRecoord.Fixed_Price__c - fixedItemTotal;
            }
            
        }
           
        Double Adjustment = (unFixedItemTotal != 0) ? desiredUnFixedTotal / unFixedItemTotal : 1;
        //system.assert( false, ServicelineItemlist + 'KitFixed price:'+ databseSOKHRecoord.Fixed_Price__c  +'SalesTax'+ databseSOKHRecoord.Tax_Amount__c );
        
        if(Adjustment != 1){ 
            for(Service_Order_Line_Item__c khli : unFixedLineItemsMap.values()){
                if(isTaxIncludingPricing){    
                      khli.Kit_Price__c = ((khli.Kit_Price__c + ( khli.Kit_Price__c * (khli.Tax_Percent__c / 100))) * Adjustment).setscale(2);
                      khli.Kit_Price__c =  (khli.Kit_Price__c / (1 + ( (khli.Tax_Percent__c / 100))));
                }else{
                     khli.Kit_Price__c =  khli.Kit_Price__c  * Adjustment;
                }
               
                updateKitLineItems.add(khli);
                ServicelineItemlist.add(khli);
                
            }
        } 
        
        
        for(Service_Order_Line_Item__c khli : ServicelineItemlist){   
            if(!(khli.Fixed_Price__c || khli.Is_Fixed_Kit_LineItem_SO__c)){
                decimal Price = khli.Kit_Price__c;
                TotalPrice +=  (khli.Qty_Needed__c * khli.Kit_Price__c);
                TotalTaxAmount +=  (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2); 
            }
            else{  
                if(isTaxIncludingPricing){
                    TotalPrice += (khli.Qty_Needed__c *  khli.Kit_Price__c).setscale(2);
                    TotalTaxAmount += (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2);
                }else{
                    TotalPrice += (khli.Qty_Needed__c * khli.Kit_Price__c).setscale(2);
                    TotalTaxAmount +=  (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2);
                }
            }  
        } 
        
        if(updateKitLineItems.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c = true;
            databseSOKHRecoord.Fixed_Price__c= TotalPrice;
            databseSOKHRecoord.Tax_amount__c = TotalTaxAmount;
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted =true;
            if(!(databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c || databseSOKHRecoord.Fixed_Price_Flag__c )){
                update databseSOKHRecoord;
            }
             
            update updateKitLineItems;
        } 
    }
    
    /**
     * Name: validateSOKitLineItemOnUpdate
     * Desc: Validate service order kit Line Item record being updated here
     * @param: 1. Id sokitHeaderId
     *         2. SOHeaderWrapper.SOLineItem sokitLineItemObj
     * @return: Errorhandler response result by validation
     **/
    private static Errorhandler validateSOKitLineItemOnUpdate(Id sokitHeaderId, SOHeaderWrapper.SOLineItem sokitLineItemObj, Service_Order_Line_Item__c sokitLineItemRec) {
        // Get all service order records for customer orders
        String serviceOrderKitHeaderQuery = 'SELECT Id, Fixed_Price__c, Fixed_Price_Flag__c, Is_Fixed_Kit_Header_SO__c,Tax_amount__c,';
        String sokhlisQuery = ' (SELECT Id, Fixed_Price__c, Actual_Kit_Price__c,Tax_Amount__c, Kit_Price__c,Tax_Percent__c, Qty_Needed__c, Total__c, Is_Fixed_Kit_LineItem_SO__c FROM Service_Order_Line_Items__r)';
        serviceOrderKitHeaderQuery += sokhlisQuery + ' FROM Service_Order_Kit_Header__c WHERE Id =: sokitHeaderId';
        
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        //System.assert( false, serviceOrderKitHeaderQuery );  
        List<Service_Order_Kit_Header__c> sokhList = Database.query(serviceOrderKitHeaderQuery); 
        Service_Order_Kit_Header__c databseSOKHRecoord = (sokhList.size() > 0) ? sokhList[0] : null;
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        decimal TotalAmount =0;
        decimal TotalTaxAmount =0;
        List<Service_Order_Line_Item__c> serviceOrderLineItemList = new List<Service_Order_Line_Item__c>();
        String errorMessage = '';
        if (databseSOKHRecoord != null) {
            Integer countUnfixedLineItems = 0;  
            Decimal totalFixedPrice = 0;

            if(databseSOKHRecoord.Fixed_Price_Flag__c  && databseSOKHRecoord.Service_Order_Line_Items__r != null){
                for (Service_Order_Line_Item__c khLineItemRec : databseSOKHRecoord.Service_Order_Line_Items__r) {
                    // Update current updating record
                    if(khLineItemRec.Id == sokitLineItemObj.Id){
                        // Add Tax Included Pricing
                        if(khLineItemRec.Kit_Price__c != sokitLineItemRec.Kit_Price__c) {
                            sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                            khLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                        }
                        khLineItemRec.Qty_Needed__c = sokitLineItemObj.QtyNeeded;
                        khLineItemRec.Kit_Price__c = sokitLineItemObj.KitPrice;
                    }
                    if (!khLineItemRec.Fixed_Price__c && !khLineItemRec.Is_Fixed_Kit_LineItem_SO__c) {
                        countUnfixedLineItems++;
                    } else {
                        totalFixedPrice += khLineItemRec.Qty_Needed__c * khLineItemRec.Kit_Price__c;
                    }
                }
                if(totalFixedPrice <= databseSOKHRecoord.Fixed_Price__c && countUnfixedLineItems > 0){
                    errorMessage = '';
                } else if(totalFixedPrice > databseSOKHRecoord.Fixed_Price__c){
                    errorMessage = Label.Kit_Line_Item_Exceeded_Total_Price;
                } else if(countUnfixedLineItems <= 1) {
                    errorMessage = Label.Kit_Line_Item_No_Unfixed_Line_Item;
                }
                
                // If no error, then perform recalculation logic for line item records of Kit
                if(errorMessage.length() == 0){
                    recalculateSOKHLineItems(databseSOKHRecoord,sokitLineItemObj);
                }
                
            } 
            else if (databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c   && databseSOKHRecoord.Service_Order_Line_Items__r != null){
                
                for (Service_Order_Line_Item__c khLineItemRec : databseSOKHRecoord.Service_Order_Line_Items__r) {
                    // Update current updating record
                    if(khLineItemRec.Id == sokitLineItemObj.Id){
                        if(khLineItemRec.Kit_Price__c != sokitLineItemRec.Kit_Price__c) {
                            sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                            khLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                        }
                        khLineItemRec.Qty_Needed__c = sokitLineItemObj.QtyNeeded;
                        khLineItemRec.Kit_Price__c = sokitLineItemObj.KitPrice;
                    }
                    if (!khLineItemRec.Fixed_Price__c && !khLineItemRec.Is_Fixed_Kit_LineItem_SO__c) {
                        countUnfixedLineItems++;
                    } else {
                        totalFixedPrice += khLineItemRec.Qty_Needed__c * khLineItemRec.Kit_Price__c;
                    }
                }
                
                //system.assert(false, totalFixedPrice+'/n/n/n/n'+  countUnfixedLineItems + '/n/n/n'+ databseSOKHRecoord.Fixed_Price__c);
                if(totalFixedPrice <= databseSOKHRecoord.Fixed_Price__c && countUnfixedLineItems > 0){
                    errorMessage = '';
                } else if(totalFixedPrice > databseSOKHRecoord.Fixed_Price__c){
                    errorMessage = Label.Kit_Line_Item_Exceeded_Total_Price;
                } else if(countUnfixedLineItems < 1) {
                    errorMessage = Label.Kit_Line_Item_No_Unfixed_Line_Item;
                }
                
                
                // If no error, then perform recalculation logic for line ite  records of Kit
                if(errorMessage.length() == 0){
                    recalculateSOKHLineItems(databseSOKHRecoord,sokitLineItemObj);
                }
            
            }
            else {
                databseSOKHRecoord.Fixed_Price__c = 0;
                if(databseSOKHRecoord.Service_Order_Line_Items__r != null) {
                    for (Service_Order_Line_Item__c khLineItemRec : databseSOKHRecoord.Service_Order_Line_Items__r) {
                        // Update current updating record
                        if(khLineItemRec.Id == sokitLineItemObj.Id){
                            if(isTaxIncludingPricing ){
                                if((sokitLineItemRec.Kit_Price__c * (1 + (khLineItemRec.Tax_Percent__c/100))).setscale(2) != khLineItemRec.Kit_Price__c.setscale(2)) {
                                    sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                                    sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                                }
                            }else{
                                if(sokitLineItemRec.Kit_Price__c != khLineItemRec.Kit_Price__c) {
                                    sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                                    sokitLineItemRec.Is_Fixed_Kit_LineItem_SO__c = true;
                                } 
                            }
                            khLineItemRec.Kit_Price__c =(sokitLineItemObj.KitPrice / (1 + (khLineItemRec.Tax_Percent__c / 100)));
                            khLineItemRec.Qty_Needed__c =  sokitLineItemObj.QtyNeeded;
                            serviceOrderLineItemList.add(khLineItemRec);
                        }
                        TotalAmount += khLineItemRec.Qty_Needed__c * khLineItemRec.Kit_Price__c  ;
                        TotalTaxAmount +=  (khLineItemRec.Qty_Needed__c * ((khLineItemRec.Kit_Price__c * khLineItemRec.Tax_Percent__c)/100));
                    }
                    databseSOKHRecoord.Fixed_Price__c= TotalAmount;
                    databseSOKHRecoord.Tax_amount__c = TotalTaxAmount;
                }
                
                if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                ServiceOrderLineItemTriggerHelper.isTriggerExecuted =true;
                update serviceOrderLineItemList;
                update databseSOKHRecoord;
            }
            //system.assert(false,sokitLineItemRec);
        }
        return (errorMessage.length() != 0) ? new Errorhandler('300', errorMessage) : new Errorhandler('200', 'Success');
    }
    
    /**
     * Name: recalculateSOKHLineItems
     * Desc: Method to recalculate service order kit heder line items price after updations in service order kit header fixed price value
     * @param: Service_Order_Kit_Header__c databseSOKHRecoord, SOHeaderWrapper.SOLineItem sokitLineItemObj
     * @return: 
     **/
    private static void recalculateSOKHLineItems(Service_Order_Kit_Header__c databseSOKHRecoord,SOHeaderWrapper.SOLineItem sokitLineItemObj) {

        List<Service_Order_Line_Item__c> updateKitLineItems = new List<Service_Order_Line_Item__c>();
        Map<Id, Service_Order_Line_Item__c> unFixedLineItemsMap = new Map<Id, Service_Order_Line_Item__c>();
        List<Service_Order_Line_Item__c> ServicelineItemlist = new List<Service_Order_Line_Item__c>();
        Double fixedItemTotal = 0;
        Double unFixedItemTotal = 0;
        Decimal TotalPrice = 0;
        Decimal TotalTaxAmount = 0;
        //system.assert(false,databseSOKHRecoord);
        Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
        
        for(Service_Order_Line_Item__c khli : databseSOKHRecoord.Service_Order_Line_Items__r){
            if(khli.Fixed_Price__c || khli.Is_Fixed_Kit_LineItem_SO__c){
                if(isTaxIncludingPricing){
                    //system.assert(false,khli);
                    if(sokitLineItemObj.Id == khli.Id){
                        fixedItemTotal += (khli.Kit_Price__c * khli.Qty_Needed__c );
                    }
                    else{
                        fixedItemTotal += (khli.Kit_Price__c * khli.Qty_Needed__c ) + khli.Tax_Amount__c;
                    }
                    
                }else{
                    fixedItemTotal += (khli.Kit_Price__c * khli.Qty_Needed__c );   
                }
                ServicelineItemlist.add(khli);
                system.debug('%%%%%%%%' + khli.Kit_Price__c  +' '+  khli.Qty_Needed__c +' '+ khli.Tax_Amount__c);
            } else { 
                unFixedLineItemsMap.put(khli.Id, khli);
                if(isTaxIncludingPricing){
                    unFixedItemTotal += (khli.Kit_Price__c  *  khli.Qty_Needed__c) + khli.Tax_Amount__c;
                }else{
                    unFixedItemTotal += (khli.Kit_Price__c  *  khli.Qty_Needed__c);
                }
                
            }
        } 
        
        Double desiredUnFixedTotal = 0; 
       
	    if((isTaxIncludingPricing)){
	        desiredUnFixedTotal = (databseSOKHRecoord.Fixed_Price__c + databseSOKHRecoord.Tax_Amount__c )  - fixedItemTotal;
	    }else{
	        desiredUnFixedTotal = databseSOKHRecoord.Fixed_Price__c - fixedItemTotal;
	    }
        
        
        Double Adjustment = (unFixedItemTotal != 0) ? desiredUnFixedTotal / unFixedItemTotal : 1;
        //system.assert( false, ServicelineItemlist + 'KitFixed price:'+ databseSOKHRecoord.Fixed_Price__c  +'SalesTax'+ databseSOKHRecoord.Tax_Amount__c  + 'adjustment: '+ Adjustment);
        
        if(Adjustment != 1){ 
            for(Service_Order_Line_Item__c khli : unFixedLineItemsMap.values()){
                if(isTaxIncludingPricing){    
                      khli.Kit_Price__c = ((khli.Kit_Price__c + ( khli.Kit_Price__c * (khli.Tax_Percent__c / 100))) * Adjustment).setscale(2);
                      khli.Kit_Price__c =  (khli.Kit_Price__c / (1 + ( (khli.Tax_Percent__c / 100))));
                }else{
                     khli.Kit_Price__c =  khli.Kit_Price__c  * Adjustment;
                }
               
                updateKitLineItems.add(khli);
                ServicelineItemlist.add(khli);
                
            }
        } 
        
        
        for(Service_Order_Line_Item__c khli : ServicelineItemlist){   
            if(!(khli.Fixed_Price__c || khli.Is_Fixed_Kit_LineItem_SO__c)){
                decimal Price = khli.Kit_Price__c;
                TotalPrice +=  (khli.Qty_Needed__c * khli.Kit_Price__c);
                TotalTaxAmount +=  (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2); 
            }
            else{  
                if(isTaxIncludingPricing){
                    TotalPrice += (khli.Qty_Needed__c *  khli.Kit_Price__c).setscale(2);
                    TotalTaxAmount += (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2);
                }else{
                    TotalPrice += (khli.Qty_Needed__c * khli.Kit_Price__c).setscale(2);
                    TotalTaxAmount +=  (khli.Qty_Needed__c * ((khli.Kit_Price__c * khli.Tax_Percent__c)/100)).setscale(2);
                }
            }  
        } 
        
        if(updateKitLineItems.size() > 0) {
            if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c = true;
            databseSOKHRecoord.Fixed_Price__c= TotalPrice;
            databseSOKHRecoord.Tax_amount__c = TotalTaxAmount;
            ServiceOrderLineItemTriggerHelper.isTriggerExecuted =true;
            if(!(databseSOKHRecoord.Is_Fixed_Kit_Header_SO__c || databseSOKHRecoord.Fixed_Price_Flag__c )){
                if(AccessControl.ifObjectFieldIsUpdateable('Service_Order_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update databseSOKHRecoord;
            }
             
            update updateKitLineItems;
        } 

    }
    
    // error handling class
    public class Errorhandler {
        public string ResponseCode;
        public string ResponseMeassage;
        
        public Errorhandler(string ResponseCode, string ResponseMeassage){
            this.ResponseCode = ResponseCode;
            this.ResponseMeassage = ResponseMeassage;
        }
        
        public Errorhandler(Errorhandler errorHandler){
            this.ResponseCode = errorHandler.ResponseCode;
            this.ResponseMeassage = errorHandler.ResponseMeassage;
        }
    }
    
    
    
    
     public static String UpdateKitHeader(COHeaderWrapper.COKitHeader CoKitObj){
                    Decimal KitHeaderTotal = 0.00;
                    Decimal FixedTotal =0.00;
                    Decimal UnFixedTotal =0.00;
                    Decimal DesiredTotal=0.00;
                    Decimal Adjustment =0.00;
                 
                    CO_Kit_Header__c CheckToUpdatedHeader =[select Id,Price__c from CO_Kit_Header__c where Id =:CoKitObj.Id  ];
                        
                    if(CheckToUpdatedHeader.Price__c == CoKitObj.Price){
                            return 'sucess';
                    } 
                    
                    List<COLineItem> ColiList = CoKitObj.COLIList;               
                    for(COLineItem ColirecItem : ColiList ){
                            if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice))   {
                                UnFixedTotal  += (ColirecItem.Qty * ColirecItem.Price);
                            }
                            else{
                                FixedTotal +=(ColirecItem.Qty * ColirecItem.Price) ;
                            }
                        }
                        if(CoKitObj.Price < FixedTotal){
                            return 'Kit Header Total cannot Less than Line Item Total';
                        }else{
                            
                            Adjustment = (CoKitObj.Price - FixedTotal)/UnFixedTotal;
                            //Adjustment = Adjustment.setScale(2);
                            for(COLineItem ColirecItem : ColiList ){
                                if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice )){
                                      ColirecItem.Price = (Adjustment *  ColirecItem.Price);
                                }
                            }
                        
                        }
                        
                CO_Kit_Header__c CoKitHeaderListToUpdate =new CO_Kit_Header__c();
                List<CO_Line_Item__c> ColiToUpdate  =new List<CO_Line_Item__c>(); 
                
                for(COLineItem ColirecItem : ColiList ){
                        CO_Line_Item__c ObjeToadd= new CO_Line_Item__c();
                        ObjeToadd.Id=ColirecItem.CoLineItemId;
                        ObjeToadd.CO_Fixed_KitLineItem__c = ColirecItem.IsFixedPriceForCO;
                        ObjeToadd.Price__c = ColirecItem.Price.setScale(2);
                        ColiToUpdate.add(ObjeToadd);
                }
                
                if(ColiToUpdate.size() > 0 ){
                // system.assert(false,ColiToUpdate +'\n\n'+ CoKitHeaderListToUpdate);
                        if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                        update ColiToUpdate;
                        CoKitHeaderListToUpdate.Id= CoKitObj.Id;
                        CoKitHeaderListToUpdate.Price__c = CoKitObj.Price.setScale(2);
                        CoKitHeaderListToUpdate.CO_Fixed_KitHeader__c =true;
                        if(AccessControl.ifObjectFieldIsUpdateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                        update CoKitHeaderListToUpdate;
                }
        
        
        return 'sucess';
    }
    /*
    To calculate Tax  or exeptions
    */
    public static Decimal getApplicableTaxes(Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap,Service_Order_Line_Item__c SoliRec, List<Tax_Exemption__c> taxExtemptionList) {
        decimal TotalTaxApplicable = 0;
        List<Sales_Tax_Item__c> SaleTaxItemListForPart = new List<Sales_Tax_Item__c>();
        if(SoliRec.part__c !=null){
          
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.part__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                        }
                   }
            }  
        }
        else if(SoliRec.fee__c !=null){
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.fee__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                        }
                   }
            }  
        }else if(SoliRec.Labour_Code__c !=null ){
             SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.Labour_Code__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                        }
                   }
            }   
        
        }       
        return TotalTaxApplicable;
    } 
    
   public static Decimal getApplicableTaxes(Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap,Service_Order_Line_Item__c SoliRec, List<Tax_Exemption__c> taxExtemptionList,List<Individual_Tax__c> IndividualTaxToinsert ) {
        
        decimal TotalTaxApplicable = 0;
       
        List<Sales_Tax_Item__c> SaleTaxItemListForPart = new List<Sales_Tax_Item__c>();
        if(SoliRec.part__c !=null){
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.part__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                            Individual_Tax__c IndividualTaxItem = new Individual_Tax__c(Service_Order_Line_Item__c = SoliRec.Id,Tax_Rate__c = SalestaxItemRec.Rate__c,Sales_Tax_Item_Name__c= SalestaxItemRec.Name__c );
                            IndividualTaxToinsert.add(IndividualTaxItem);   
                        }
                   }
            }  
        }
        else if(SoliRec.fee__c !=null){
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.fee__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                            Individual_Tax__c IndividualTaxItem = new Individual_Tax__c(Service_Order_Line_Item__c = SoliRec.Id,Tax_Rate__c = SalestaxItemRec.Rate__c,Sales_Tax_Item_Name__c= SalestaxItemRec.Name__c );
                            IndividualTaxToinsert.add(IndividualTaxItem);
                        }
                   }
            }  
        }else if(SoliRec.Labour_Code__c !=null ){
             SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(SoliRec.Labour_Code__c);
            if(SaleTaxItemListForPart != null ){
                   for(Sales_Tax_Item__c SalestaxItemRec :  SaleTaxItemListForPart){
                        boolean taxExtempt = false;
                        for(Tax_Exemption__c TaxExptemRec :  taxExtemptionList){  
                            if(SalestaxItemRec.Id == TaxExptemRec.Sales_Tax_Item__c){
                                taxExtempt = true;                      
                            }                           
                        }if(taxExtempt == false){  
                            TotalTaxApplicable += SalestaxItemRec.Rate__c !=null ? SalestaxItemRec.Rate__c : 0;
                            Individual_Tax__c IndividualTaxItem = new Individual_Tax__c(Service_Order_Line_Item__c = SoliRec.Id,Tax_Rate__c = SalestaxItemRec.Rate__c,Sales_Tax_Item_Name__c= SalestaxItemRec.Name__c );
                            IndividualTaxToinsert.add(IndividualTaxItem);
                        }
                   }
            }   
        
        }    
        return TotalTaxApplicable;
   }
}