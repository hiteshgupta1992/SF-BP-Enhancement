/**
 * Author: Ashish Garg
 * Since: Feb 18, 2016
 * Name: COKH_Recalcualtion
 * Description: Apex class to handle Customer Order Kit Header 
**/
public with sharing class COKH_Recalcualtion {

     /**
     * Name: AddCustomerCoForKititemUpdate
     * Desc: updating kit item
     * @param:  (1) CustomerId - String - Customer Id
     *          (2) CoheaderId - String - Customer Header Id
     * @return: void
    **/
    public class SalesTaxItemPart{
        Id  salestaxItemId = null; 
        Decimal salestaxItemTax =0;
        String salesTaxItemName = '';
        public SalesTaxItemPart(Id ApplicableTax,Decimal ApplicaleTaxRate, string SalesTaxItemName ){
            this.salestaxItemId = ApplicableTax;
            this.salestaxItemTax = ApplicaleTaxRate;
            this.salesTaxItemName = SalesTaxItemName;
        }
    }
    
    public static void AddCustomerCoForKititemUpdate(string  CustomerId ,string CoheaderId  ){
         COKHPriceLevelCalculationByMerchandise(null,CustomerId,CoheaderId);
    }
    
    
     /**
     * Name: COKHPriceLevelCalculationByMerchandise
     * Desc: calculate price by merchandise
     * @param:  (1) listkitheaderId - List<Id> - List of kit header id
                (2) CustomerId - String - Customer Id
     *          (3) CoheaderId - String - Customer Header Id
     * @return: String success or not
    **/
    public static String COKHPriceLevelCalculationByMerchandise( List<Id> listkitheaderId,string CustomerId ,string CoheaderId ){
        if(AccessControl.ifObjectFieldIsCreateable('Price_Level__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(AccessControl.ifObjectFieldIsCreateable('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        
        Price_Level__c priceLevel = new Price_Level__c();
        Sales_Tax__c salesTax = new Sales_Tax__c();
        List<Tax_Exemption__c> taxExtemptionList = new List<Tax_Exemption__c>();
        if(CustomerId !=null){  
            if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            
            Account  customer=[SELECT   Id, 
                                Price_Level__c,   
                                Price_Level__r.Active__c, 
                                Price_Level__r.Discount_Markup__c,   
                                Price_Level__r.Labour_Rate__c ,
                                Sales_Tax__c
                                FROM Account
                                WHERE Id =: customerId
          
                            ];
                             
                priceLevel = new Price_Level__c(    Active__c = customer.Price_Level__r.Active__c,
                                                        Discount_Markup__c = (customer.Price_Level__r.Discount_Markup__c != null) ? customer.Price_Level__r.Discount_Markup__c : 0,
                                                        Labour_Rate__c = customer.Price_Level__r.Labour_Rate__c
                                                    );
                 salesTax =new Sales_Tax__c( Id = customer.Sales_Tax__c);                               
        }
        else{
                if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                if(AccessControl.ifObjectFieldIsAccessible('Tax_Exemption__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                                
                             CO_Header__c Coheader = [Select Part_Price_Base_From_Price_Level__c, Discount_Markup_From_Prive_Level__c,Customer__r.Sales_Tax__c,Customer__c 
                                        From CO_Header__c  where Id =: CoheaderId ];
                            
                            if(Coheader.Customer__c !=null ){
                                 taxExtemptionList = [select Id,Sales_Tax_Item__r.Rate__c,Sales_Tax_Item__c from Tax_Exemption__c where Customer__c =: Coheader.Customer__c];
                                 
                            }       
                       
                            //---------------------------- need to remove--------------------------
                            if(Coheader.Customer__r.Sales_Tax__c !=null ){
                                     salesTax =new Sales_Tax__c( Id = Coheader.Customer__r.Sales_Tax__c);   
                            }
                            else{
                                    List<Sales_Tax__c> listDefaultSalesTax = [select Id from Sales_Tax__c where default__c = true];
                                    
                                    //Condition Added by Tarun
                                    if(listDefaultSalesTax.size() > 0) {
                                    	salesTax = new Sales_Tax__c(Id = listDefaultSalesTax[0].Id);   
                                    } else {
                                    	salesTax = new Sales_Tax__c();
                                    }
                            }
                            
                            //-------------------------------------------------------------------------              
            
            
                             priceLevel = new Price_Level__c(   
                                                        Discount_Markup__c = Coheader.Discount_Markup_From_Prive_Level__c 
                                                    );
             }
             
            if( listkitheaderId == null || listkitheaderId.size() < 0){
                 Map<Id,CO_Kit_Header__c>  IdToCokhMap = new  Map<Id,CO_Kit_Header__c> ([Select Id From CO_Kit_Header__c  where CO_Header__c =:CoheaderId ]);
                 listkitheaderId =new List<Id>(IdToCokhMap.KeySet());
            }
            
            
            
            if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<CO_Kit_Header__c> CoKitHeaderList = [Select Id,Price__c,Fixed_Price_Flag__c,(Select Price__c,Part__c,Fixed_Price__c,Qty__c,Tax__c,Part__r.Applicable_Tax__r.Rate__c,Fee__c,Fee__r.Applicable_Tax__r.Rate__c From CO_Line_Items__r)
                                                        From CO_Kit_Header__c where CO_Kit_Header__c.Id IN : listkitheaderId];
            
            if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<CO_Line_Item__c> ColiToUpdate = new List<CO_Line_Item__c>(); 
          
           Set<Id> partIdSet = new Set<Id>(); 
           Set<Id> feeIdSet = new Set<Id>(); 
           Set<Id> ColiSetForIndTax = new  set<Id>();
            
           // Create Set for Part Ids 
           for(CO_Kit_Header__c CoKitHeaderRec : CoKitHeaderList ){
                if(CoKitHeaderRec.CO_Line_Items__r != null &&   CoKitHeaderRec.CO_Line_Items__r .size() > 0){
                    for(CO_Line_Item__c coliRec : CoKitHeaderRec.CO_Line_Items__r){
                        if(coliRec.Part__c !=null){
                            partIdSet.add(coliRec.Part__c);
                            ColiSetForIndTax.add(coliRec.Id);
                        }else if (coliRec.Fee__c  !=null){
                             feeIdSet.add(coliRec.Fee__c);
                             ColiSetForIndTax.add(coliRec.Id);
                        }
                    }
                }
           }
            
          if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Fee__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxes__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          List<Part__c>  listPartSalesTax= new list<Part__c> ([Select Id,Applicable_Tax__r.Rate__c,Applicable_Tax__c From Part__c  where Id IN:partIdSet ]);
           List<Fee__c>  listFeeSalesTax= new list<Fee__c> ([Select Id,Applicable_Tax__r.Rate__c,Applicable_Tax__c From Fee__c  where Id IN:feeIdSet ]);
         
         // List<Individual_Tax__c>  IndividualTaxList = new list<Part__c> ([Select Sales_Tax_Item_Name__c From Individual_Tax__c  where Id IN:partIdSet ]); 
                
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
           
           
           List<Applicable_Taxes__c> applicableTaxJunctionList = [select Id,Sales_Tax__c,Sales_Tax_Item__c,Sales_Tax_Item__r.Rate__c, Sales_Tax_Item__r.Name__c from Applicable_Taxes__c where  Sales_Tax__c IN : SalesTaxIdToPartIdMap.keySet()];
            
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
           
          if(AccessControl.ifObjectFieldIsAccessible('Sales_Tax__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          if(AccessControl.ifObjectFieldIsAccessible('Applicable_Taxe__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
          List<Sales_Tax__c>  salesTaxList   = new list<Sales_Tax__c>([Select Id,(Select Id, Name, Sales_Tax_Item__r.Tax_Parts__c,Sales_Tax_Item__r.Rate__c  From Applicable_Taxes__r) From Sales_Tax__c  where  Id =: salesTax.Id]);
          Decimal SalesTaxRate =0.00;
          for(Sales_Tax__c  saleTaxRec : salesTaxList){
                    for(Applicable_Taxes__c PartTaxItemRec : saleTaxRec.Applicable_Taxes__r){  
                            if( PartTaxItemRec.Sales_Tax_Item__r.Tax_Parts__c){
                                    SalesTaxRate = SalesTaxRate + PartTaxItemRec.Sales_Tax_Item__r.Rate__c;
                        }
                }         
           }
           
            
           for(CO_Kit_Header__c CoKitHeaderRec : CoKitHeaderList ){
                if(CoKitHeaderRec.CO_Line_Items__r != null &&   CoKitHeaderRec.CO_Line_Items__r .size() > 0 && !CoKitHeaderRec.Fixed_Price_Flag__c ){
                     List<CO_Line_Item__c> coliList  =  applyPriceLevelUpdate(CoKitHeaderRec,priceLevel,taxExtemptionList,partIdToPartRateMap,PartIdToSalesTaxItemMap);
                     ColiToUpdate.addAll(coliList);  
                }else{
                        List<CO_Line_Item__c> coliList  =  applyPriceLevelUpdate(CoKitHeaderRec,priceLevel,taxExtemptionList,partIdToPartRateMap,PartIdToSalesTaxItemMap);
                        ColiToUpdate.addAll(coliList);  
                } 
            } 
              
           // System.assert(false,'000000000'+ColiToUpdate +'\n\n\n'+ CoKitHeaderList);
            
            if(ColiToUpdate.size()>0){
                update ColiToUpdate;
                update CoKitHeaderList;
            }  
            return 'Success'; 
        
    }     
    
    /**
     * Name: CoKitInsert
     * Desc: Customer kit insert
     * @param:  (1) kitheaderId - String - Kit Header Record Id
     *          (2) CoheaderId - String - Customer Header Id
     * @return: String success or not
    **/
     public static String CoKitInsert(String kitheaderId, String CoheaderId) {
        
        List<Id> listkitheaderId = new List<Id>();
        listkitheaderId.add(kitheaderId);  
        String Result = COKHPriceLevelCalculationByMerchandise(listkitheaderId,null,CoheaderId);
         
        return 'Success'; 
    } 
    
   public static List<CO_Line_Item__c> applyPriceLevelUpdate(CO_Kit_Header__c CoKitHeaderRec,Price_Level__c PriceLevel, List<Tax_Exemption__c> taxExtemptionList, Map<Id,Decimal> partIdToPartRateMap, Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap){
            Decimal KitHeaderTotal = 0.00;
            Decimal PartRate = 0.00;
            Decimal taxAmount = 0;
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            
            //Call For Invdivdual taxes
           // isTaxIncludingPricing = true;
            
           if(isTaxIncludingPricing) {
                
                for(CO_Line_Item__c  ColiRec : CoKitHeaderRec.CO_Line_Items__r ) {
                    Decimal TotalTaxApplicable =0;
                    PartRate = (ColiRec.Part__r.Applicable_Tax__r.Rate__c)!=null ? (ColiRec.Part__r.Applicable_Tax__r.Rate__c) : 0;
                    partRate = ColiRec.Part__r.Applicable_Tax__r.Rate__c;
                   
                    if(!ColiRec.Fixed_Price__c && ColiRec.Part__c !=null  ){
                        if(CoKitHeaderRec.Fixed_Price_Flag__c){
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                            Decimal preTaxPricing = ColiRec.Price__c/ (1 + (TotalTaxApplicable / 100));
                            ColiRec.Price__c = preTaxPricing.setscale(2);
                            ColiRec.Tax__c = TotalTaxApplicable;
                            KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
                            if(ColiRec.Tax__c != null) {
                                taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                            }
                           
                        }else{
                        	if(PartRate == null || PartRate == -100) {
                        		PartRate = 0;
                        	}
                            Decimal preTaxPricing = ColiRec.Price__c / (1 + (PartRate / 100));
                               
                            ColiRec.Price__c = preTaxPricing + (preTaxPricing *  priceLevel.Discount_Markup__c / 100);
                            
                            ColiRec.Price__c = ColiRec.Price__c.setscale(2);
                            TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                            ColiRec.Tax__c = TotalTaxApplicable;
                            KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c); 
                            if(ColiRec.Tax__c != null) {
                                taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                            }
                           
                        }
                   }else if (ColiRec.Fixed_Price__c && ColiRec.Part__c !=null ){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                        Decimal preTaxPricing = ColiRec.Price__c/ (1 + (TotalTaxApplicable / 100));
                        ColiRec.Price__c = preTaxPricing.setscale(2);
                        ColiRec.Tax__c = TotalTaxApplicable;
                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
                        if(ColiRec.Tax__c != null) {
                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                        }
                   }else if(ColiRec.Fixed_Price__c && ColiRec.Fee__c !=null){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                        Decimal preTaxPricing = ColiRec.Price__c/ (1 + (TotalTaxApplicable / 100));
                        ColiRec.Price__c = preTaxPricing.setscale(2);
                        ColiRec.Tax__c = TotalTaxApplicable;
                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
                        if(ColiRec.Tax__c != null) {
                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                        }
                   
                   }
                    
                }
            
            } else {
                for(CO_Line_Item__c  ColiRec : CoKitHeaderRec.CO_Line_Items__r ) {
                    Decimal TotalTaxApplicable =0;
                     if(!ColiRec.Fixed_Price__c && ColiRec.Part__c !=null ){
                        if(CoKitHeaderRec.Fixed_Price_Flag__c){    
                     		TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
	                        ColiRec.Tax__c = TotalTaxApplicable;
	                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
	                        if(ColiRec.Tax__c != null) {  
	                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
	                        }
                     	
                     	}else{
                     		ColiRec.Price__c =  ColiRec.Price__c + (ColiRec.Price__c * priceLevel.Discount_Markup__c / 100);
	                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
	                        ColiRec.Tax__c = TotalTaxApplicable;
	                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c); 
	                        if(ColiRec.Tax__c != null) {
	                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
	                        }

                     	}	 
                     }else if (ColiRec.Fixed_Price__c && ColiRec.Part__c !=null ){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                        ColiRec.Tax__c = TotalTaxApplicable;
                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
                        if(ColiRec.Tax__c != null) {  
                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                        }
                     }else if (ColiRec.Fixed_Price__c && ColiRec.Part__c !=null ){
                        TotalTaxApplicable = getApplicableTaxes(PartIdToSalesTaxItemMap,ColiRec,taxExtemptionList);
                        ColiRec.Tax__c = TotalTaxApplicable;
                        KitHeaderTotal += (ColiRec.Qty__c * ColiRec.Price__c);  
                        if(ColiRec.Tax__c != null) {  
                            taxAmount +=  (ColiRec.Qty__c * ColiRec.Price__c * ColiRec.Tax__c) / 100;
                        }
                     }
                     
                } 
            }
            
            CoKitHeaderRec.Price__c = KitHeaderTotal.setscale(2);
            CoKitHeaderRec.Tax_Amount__c = taxAmount.setscale(2);
            //system.assert(false,CoKitHeaderRec +'/n/n/n/n'+  CoKitHeaderRec.CO_Line_Items__r);
            return  CoKitHeaderRec.CO_Line_Items__r;  
        
     }
     
      
    public static Decimal getApplicableTaxes(Map<Id,List<Sales_Tax_Item__c>> PartIdToSalesTaxItemMap,CO_Line_Item__c ColiRec, List<Tax_Exemption__c> taxExtemptionList) {
        decimal TotalTaxApplicable = 0;
        List<Sales_Tax_Item__c> SaleTaxItemListForPart = new List<Sales_Tax_Item__c>();
        
        if(ColiRec.part__c !=null){
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(ColiRec.part__c);
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
        if(ColiRec.fee__c !=null){
            SaleTaxItemListForPart = PartIdToSalesTaxItemMap.get(ColiRec.fee__c);
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
    
     /**
     * Name: UpdateKitHeader
     * Desc:  Update Kit Header
     * @param:  (1) CoKitObj - COHeaderWrapper.COKitHeader - Kit Header Record
     * @return: String - Success or Error
    **/  
    public static String UpdateKitHeader(COHeaderWrapper.COKitHeader CoKitObj){
                    Decimal KitHeaderTotal = 0.00;
                    Decimal FixedTotal =0.00;
                    Decimal UnFixedTotal =0.00;
                    Decimal DesiredTotal=0.00;
                    Decimal Adjustment =0.00;
                    Decimal counter = 0; 
                    Decimal TotalTaxAmount = 0;
                    Decimal TotalPrice = 0;
                    
                    if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                    CO_Kit_Header__c CheckToUpdatedHeader =[select Id,Price__c,Tax_Amount__c from CO_Kit_Header__c where Id =:CoKitObj.Id  ];
                    Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
                    if(isTaxIncludingPricing){
                        if((CheckToUpdatedHeader.Price__c +  CheckToUpdatedHeader.Tax_Amount__c).setscale(2) == CoKitObj.Price.setscale(2)){
                            return 'Success';
                        } 
                     
                     }else{
                        if(CheckToUpdatedHeader.Price__c.setscale(2) == CoKitObj.Price.setscale(2)){
                            return 'Success';
                        }
                     }   
                    
                    List<COLineItem> ColiList = CoKitObj.COLIList;    
                               
                    for(COLineItem ColirecItem : ColiList ){
                            if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice))   {
                                UnFixedTotal  += (ColirecItem.Qty *  ColirecItem.Price);
                            }
                            else{
                                FixedTotal +=(ColirecItem.Qty * ColirecItem.Price) ;
                            }
                        }
                        if(CoKitObj.Price < FixedTotal){
                            return 'Kit Header Total cannot Less than Line Item Total';
                        }
                        else if(UnFixedTotal < 0){
                            return 'Incorrect item inserted';
                        }
                        else{
                            UnFixedTotal = UnFixedTotal==0 ? 1 :UnFixedTotal; 
                            Adjustment = (CoKitObj.Price - FixedTotal)/UnFixedTotal;
                            //Adjustment = Adjustment.setScale(2); 
                            for(COLineItem ColirecItem : ColiList ){
                                if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice )){
                                      ColirecItem.Price = (Adjustment *  ColirecItem.Price );
                                      if(isTaxIncludingPricing){
                                            ColirecItem.Price =   (ColirecItem.Price / (1 + (ColirecItem.Tax / 100))).setscale(2);
                                      }
                                      counter = counter + 1;
                                }
                                
                            }
                        
                        }
                        
                if(AccessControl.ifObjectFieldIsUpdateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                             
                CO_Kit_Header__c CoKitHeaderListToUpdate =new CO_Kit_Header__c();
                List<CO_Line_Item__c> ColiToUpdate  =new List<CO_Line_Item__c>(); 
                
                  //  
                
                for(COLineItem ColirecItem : ColiList ){
                        CO_Line_Item__c ObjeToadd= new CO_Line_Item__c();
                        ObjeToadd.Id=ColirecItem.CoLineItemId;
                        if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice )){
                            ObjeToadd.Price__c = ColirecItem.Price.setScale(2);
                            ColiToUpdate.add(ObjeToadd);
                            TotalPrice += (ColirecItem.price * ColirecItem.Qty);
                            TotalTaxAmount +=  (ColirecItem.qty * ((ColirecItem.price * ColirecItem.Tax)/100)); 
                        }
                        else{
                            if(isTaxIncludingPricing){
                                decimal  Currentprice = (ColirecItem.Price / (1 + (ColirecItem.Tax / 100)));
                                TotalPrice += (ColirecItem.qty *  (ColirecItem.Price / (1 + (ColirecItem.Tax / 100))));
                                TotalTaxAmount +=  (ColirecItem.qty * ((Currentprice * ColirecItem.Tax)/100)); 
                            }else{
                                TotalPrice += (ColirecItem.price * ColirecItem.Qty);
                                TotalTaxAmount +=  (ColirecItem.qty * ((ColirecItem.price * ColirecItem.Tax)/100)); 
                            }
                        }  
                }
                
                if(ColiToUpdate.size() > 0  &&  counter > 0){  
                        update ColiToUpdate;
                        CoKitHeaderListToUpdate.Id= CoKitObj.Id;
                        CoKitHeaderListToUpdate.Price__c = TotalPrice.setscale(2);
                        CoKitHeaderListToUpdate.Tax_Amount__c = TotalTaxAmount.setscale(2);
                        CoKitHeaderListToUpdate.CO_Fixed_KitHeader__c =true;
                        update CoKitHeaderListToUpdate;
                }
               
                if( counter ==  0){
                     return 'Error';
                }
        
          
        return 'Success';
    }
    
    
     
     /**
     * Name: UpdateKitLineItem
     * Desc:  Update Kit Header    
     * @param:  (1) CoKitObj - COHeaderWrapper.COKitHeader - Kit Header Record
     *          (2) ColiRec -  COLineItem - Line Item Record
     *          (3) CoheaderId- String  - Header Record
     * @return: String - Success or Error  
     **/
    public static String UpdateKitLineItem(COHeaderWrapper.COKitHeader CoKitObj,COLineItem ColiRec,String CoheaderId ){
            if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            
            CO_Line_Item__c  ColiChecktoUpdate  = [select Id,price__c,Tax__c  from CO_Line_Item__c where Id =:ColiRec.CoLineItemId ];
            Boolean isTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
            if(isTaxIncludingPricing){        
                if((ColiChecktoUpdate.Price__c * (1 + ColiChecktoUpdate.Tax__c /100)).setScale(2) == ColiRec.price.setscale(2)){
                    return 'Success'; 
                }
            }else{
                 if( ColiChecktoUpdate.price__c== ColiRec.price ){
                    return 'Success';
                }
            }
            CO_Header__c Coheader = [Select Part_Price_Base_From_Price_Level__c, Discount_Markup_From_Prive_Level__c 
                                        From CO_Header__c  where Id =: CoheaderId ];
                                        
            List<COLineItem> ColiList = CoKitObj.COLIList;                  
            Decimal KitHeaderTotal = 0.00;
            Decimal FixedTotal =0.00;
            Decimal UnFixedTotal =0.00;
            Decimal DesiredTotal=0.00;
            Decimal Adjustment =0.00;
            Decimal TotalTaxAmount = 0;
            Decimal TotalPrice = 0;
            
            if(CoKitObj.IsFixedPrice  || CoKitObj.IsFixedKitHeaderCO){    
                        for(COLineItem ColirecItem : ColiList ){
                            if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice || ColirecItem.CoLineItemId== ColiRec.CoLineItemId ))   {
                                UnFixedTotal  += (ColirecItem.Qty * ColirecItem.Price);
                            }
                            else{
                                FixedTotal +=(ColirecItem.Qty * ColirecItem.Price) ;
                            }
                        }
                        if(CoKitObj.Price < FixedTotal){
                            return 'Kit Header Total cannot Less than Line Item Total';
                        }
                        else if(UnFixedTotal < 0){
                            return 'Inccorect item inserted';
                        }
                        else{
                            UnFixedTotal = UnFixedTotal==0 ? 1 :UnFixedTotal; 
                            Adjustment = (CoKitObj.Price - FixedTotal)/UnFixedTotal;
                            for(COLineItem ColirecItem : ColiList ){
                                if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice || ColirecItem.CoLineItemId== ColiRec.CoLineItemId )){
                                      ColirecItem.Price = (Adjustment *  ColirecItem.Price);
                                      if(isTaxIncludingPricing){
                                            ColirecItem.Price =   (ColirecItem.Price / (1 + (ColirecItem.Tax / 100))).setscale(2);
                                      }
                                      
                                }else if(ColirecItem.CoLineItemId == ColiRec.CoLineItemId){
                                    ColirecItem.IsFixedPriceForCO =true;
                                }
                            }
                        }
            }
            else{  
                    for(COLineItem ColirecItem : ColiList ){
                            if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice || ColirecItem.CoLineItemId== ColiRec.CoLineItemId )){
                                if(isTaxIncludingPricing){
                                    Decimal preTaxPricing = ColirecItem.Price / (1 + (ColirecItem.Tax / 100));
                                    ColirecItem.Price = preTaxPricing + (preTaxPricing *  Coheader.Discount_Markup_From_Prive_Level__c / 100);
                                    ColirecItem.Price = ColirecItem.Price.setscale(2);
                                }else{
                                    ColirecItem.Price =  ColiRec.ActualKitPrice + (ColiRec.ActualKitPrice * Coheader.Discount_Markup_From_Prive_Level__c / 100);
                                }
                            }
                            else if(ColirecItem.CoLineItemId== ColiRec.CoLineItemId ){
                                  ColirecItem.IsFixedPriceForCO =true;
                            }
                        }  
            }
        
        if(AccessControl.ifObjectFieldIsUpdateable('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
        
        CO_Kit_Header__c CoKitHeaderListToUpdate =new CO_Kit_Header__c();
        List<CO_Line_Item__c> ColiToUpdate  =new List<CO_Line_Item__c>(); 
        
        for(COLineItem ColirecItem : ColiList ){
            CO_Line_Item__c ObjeToadd= new CO_Line_Item__c();
            ObjeToadd.Id=ColirecItem.CoLineItemId;
            if(!(ColirecItem.IsFixedPriceForCO ||  ColirecItem.IsFixedPrice )){
                ObjeToadd.Price__c = ColirecItem.Price.setScale(2);
                ObjeToadd.CO_Fixed_KitLineItem__c = ColirecItem.IsFixedPriceForCO;
                TotalPrice += (ColirecItem.price * ColirecItem.Qty);
                TotalTaxAmount +=  (ColirecItem.qty * ((ColirecItem.price * ColirecItem.Tax)/100)); 
            }
            else{
                ObjeToadd.CO_Fixed_KitLineItem__c = ColirecItem.IsFixedPriceForCO;  
                if(isTaxIncludingPricing){
                    
                    decimal  Currentprice = (ColirecItem.Price / (1 + (ColirecItem.Tax / 100)));
                    ObjeToadd.Price__c = Currentprice.setScale(2);
                    ObjeToadd.CO_Fixed_KitLineItem__c = ColirecItem.IsFixedPriceForCO;    
                    TotalPrice += (ColirecItem.qty *  (ColirecItem.Price / (1 + (ColirecItem.Tax / 100))));
                    TotalTaxAmount +=  (ColirecItem.qty * ((Currentprice * ColirecItem.Tax)/100)); 
                }else{
                    TotalPrice += (ColirecItem.price * ColirecItem.Qty);
                    TotalTaxAmount +=  (ColirecItem.qty * ((ColirecItem.price * ColirecItem.Tax)/100)); 
                }
            }
            ColiToUpdate.add(ObjeToadd);
        }  
        
        CoKitHeaderListToUpdate.Id= CoKitObj.Id;
        CoKitHeaderListToUpdate.Price__c =TotalPrice.setScale(2);
        CoKitHeaderListToUpdate.Tax_Amount__c = TotalTaxAmount.setScale(2);
        
        if(ColiToUpdate.size() > 0 ){
         update ColiToUpdate;
         update CoKitHeaderListToUpdate;
        }
    
        return 'Success'; 
    }
    
    
    


}