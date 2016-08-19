/**
 * Author: Ashish Garg
 * Since: June 26, 2015
 * Name: ViewPartRelatedListCtrl
 * Description: Controller Class of Part Related List Component.
**/
global with sharing class ViewPartRelatedListCtrl {
    
    public Decimal Home_Search_Grid_Page_Size { get{return GeneralConfiguration.getHomeSearchGridPageSize();} private set;}
    public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
    public boolean Is_Widget_Removeable {get{return GeneralConfiguration.isWidgetRemoveable();}}
    public boolean Load_New_Customer_Order {get{return GeneralConfiguration.isLoadNewCustomerOrder();} private set;}
    public boolean Load_New_UI {get{return GeneralConfiguration.isLoadNewUI();} private set;}
    public boolean Load_New_View_Customer {get{return GeneralConfiguration.isLoadNewViewCustomer();} private set;}
    public Decimal Sales_Tax_Rate {get{return GeneralConfiguration.getAustralianMarketSalesTaxRate();} private set;}
    
    /*****************************  START: ACTIVE ORDERS SECTION    *****************************************/
    /**
     * Name: getAllActiveOrdersForPart
     * Desc: Get all related active orders for a part record
     * @param:  (1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the active order records
    **/
    private static List<ActiveOrder> getAllActiveOrdersForPart(String partId, String pageSortAttrsJSON) {
        List<ActiveOrder> activeOrders = ActiveOrder.getAllActiveOrdersForPart(partId, pageSortAttrsJSON);
        return activeOrders;
    }
    
    /**
     * Name: getPaginatedActiveOrdersForPart
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedActiveOrdersForPart(String partId, String pageSortAttrsJSON) {
        pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        partId = Id.valueOf(BPUtility.getDecodedString(partId));
        return BPUtility.getEncodedString(System.JSON.serialize( new AllActiveOrdersWrapper(partId, pageSortAttrsJSON) ));
    }
    
    public class AllActiveOrdersWrapper {
        // All records
        public List<ActiveOrder> activeOrders;
        
        // Total records
        public Integer TotalActiveOrders;
        
        public AllActiveOrdersWrapper(String partId, String pageSortAttrsJSON){
            this.activeOrders = ViewPartRelatedListCtrl.getAllActiveOrdersForPart(partId, pageSortAttrsJSON);
            this.TotalActiveOrders = ActiveOrder.getTotalActiveOrdersForPart(partId);
        }
    }
    /*****************************  END: ACTIVE ORDERS SECTION  *****************************************/
    
    
    /*****************************  START: ACTIVE SALES ORDERS SECTION  *****************************************/
    /**
     * Name: getAllActiveSalesOrdersForPart
     * Desc: Get all related active sales orders for a part record
     * @param:  (1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the active sales order records
    **/
    private static List<ActiveSalesOrder> getAllActiveSalesOrdersForPart(String partId, String pageSortAttrsJSON) {
        List<ActiveSalesOrder> activeSalesOrders = ActiveSalesOrder.getAllActiveSalesOrdersForPart(partId, pageSortAttrsJSON);
        return activeSalesOrders;
    }
    
    /**
     * Name: getPaginatedActiveSalesOrdersForPart
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedActiveSalesOrdersForPart(String partId, String pageSortAttrsJSON) {
        pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        partId = Id.valueOf(BPUtility.getDecodedString(partId));
        return BPUtility.getEncodedString(System.JSON.serialize( new AllActiveSalesOrdersWrapper(partId, pageSortAttrsJSON) ));
    }
    
    public class AllActiveSalesOrdersWrapper {
        // All records
        public List<ActiveSalesOrder> activeSalesOrders;
        
        // Total records
        public Integer TotalActiveSalesOrders;
        
        public AllActiveSalesOrdersWrapper(String partId, String pageSortAttrsJSON){
            this.activeSalesOrders = ViewPartRelatedListCtrl.getAllActiveSalesOrdersForPart(partId, pageSortAttrsJSON);
            this.TotalActiveSalesOrders = ActiveSalesOrder.getTotalActiveSalesOrdersForPart(partId);
        }
    }
    /*****************************  END: ACTIVE ORDERS SECTION  *****************************************/
    
    
    /*****************************  START: ALTERNATE PARTS SECTION  *****************************************/
    /**
     * Name: getAllAlternatePartsForPart
     * Desc: Get all related alternate parts for a part record
     * @param:  (1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    private static List<AlternatePart> getAllAlternatePartsForPart(String partId, String pageSortAttrsJSON) {
        List<AlternatePart> alternateParts = AlternatePart.getAllAlternatePartsForPart(partId, pageSortAttrsJSON);
        return alternateParts;
    }
    
    /**
     * Name: getTotalAlternatePartsForPart
     * Desc: Get total count for related Active Orders of a part record
     * @param: (1) partId - String - Part Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    @RemoteAction
    global static Integer getTotalAlternatePartsForPart(String partId) {
        //return 500;
        partId = Id.valueOf(BPUtility.getDecodedString(partId));
        return AlternatePart.getTotalAlternatePartsForPart(partId);
    }
    
    /**
     * Name: addAlternatePartToPart
     * Desc: Add a Alternate part record with supplied values
     * @param:  (1) alternatePartsJSON - String - JSON formatted array of Alternate part records need to be inserted
     * @return: String - If a single record is inserted, then return value will be detailed record in JSON format
    **/
    @RemoteAction
    global static String addAlternatePartToPart(String alternatePartsJSON) {
        alternatePartsJSON = BPUtility.getDecodedString(alternatePartsJSON);
        try{
            List<AlternatePart> alternatePartsList = AlternatePart.parse(alternatePartsJSON);
            if(alternatePartsList.size() == 0){
                return BPUtility.getEncodedString('');
            }
            
            if(AccessControl.ifObjectIsAccessible('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
            
            // Check if any alternate part is already added for the part record
            List<Part_Alternates__c> partAlternateRecords = [SELECT Id, Part_ID__r.Part_Number__c, Alternate_Part_ID__r.Part_Number__c
                                                             FROM Part_Alternates__c 
                                                             WHERE (Part_ID__c =: alternatePartsList[0].PartId 
                                                                    AND Alternate_Part_ID__c =: alternatePartsList[0].AlternatePartId)
                                                            ];
            if(partAlternateRecords.size() > 0) {
                String errorMsg = 'Part is already added as Alternate Part.';
                return BPUtility.getEncodedString(System.JSON.serialize( new List<AlternatePart.AlternatePartWrapper>{new AlternatePart.AlternatePartWrapper(errorMsg)} ));
            }                               
                
            // Else add the record in database
            List<Part_Alternates__c> alternatePartsToInsert = new List<Part_Alternates__c>();

            for(AlternatePart partAlternate : alternatePartsList){
                alternatePartsToInsert.add(new Part_Alternates__c(  Part_ID__c = partAlternate.PartId,
                                                                    Alternate_Part_ID__c = partAlternate.AlternatePartId,
                                                                    Relation__c = partAlternate.Relation
                                                                ));
                alternatePartsToInsert.add(new Part_Alternates__c(  Part_ID__c = partAlternate.AlternatePartId,
                                                                    Alternate_Part_ID__c = partAlternate.PartId,
                                                                    Relation__c = partAlternate.Relation
                                                                ));                                             
            }
                
            if(AccessControl.ifObjectIsCreateable('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
            insert alternatePartsToInsert;
            
            alternatePartsToInsert = SOQLUtil.getAlternatePartRecords(new List<Id>{alternatePartsToInsert[0].Id});
            return BPUtility.getEncodedString(System.JSON.serialize( new List<AlternatePart.AlternatePartWrapper>{new AlternatePart.AlternatePartWrapper(alternatePartsToInsert[0], alternatePartsToInsert[0].Part_ID__c)} ));
        }catch(exception ex){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
            return BPUtility.getEncodedString('');
        } 
    }
    
    /**
     * Name: updateDefaultAlternatePart
     * Desc: method to update record as preffered record
     * @param: (1) alternateVendorJunctionId - String - Id of Alternate Vendor junction object record
     * @return: String
    **/
    @RemoteAction
    global static String updateDefaultAlternatePart(String partId, String alternatePartJunctionId, boolean preferredValToUpdate) {
        partId = BPUtility.getDecodedString(partId) ;
        alternatePartJunctionId = BPUtility.getDecodedString(alternatePartJunctionId);
        
        try{
            List<Part_Alternates__c> alternatePartstoUpdate = new List<Part_Alternates__c>();
            Part_Alternates__c recToUpdate = new Part_Alternates__c(Id = alternatePartJunctionId);
            List<Part_Alternates__c> alternatePartsList = SOQLUtil.getAlternatePartRecords(new List<Id>{alternatePartJunctionId});
                

            // Preferred field: In case Alternate and original part record
            if( String.valueOf(partId).substring(0, 15) == String.valueOf(alternatePartsList[0].Alternate_Part_ID__c).substring(0, 15) ){
                recToUpdate.Alternate_Preferred__c = preferredValToUpdate;
            } else {
                recToUpdate.Preferred__c = preferredValToUpdate;
            }

            alternatePartstoUpdate.add(recToUpdate);
            if(AccessControl.ifObjectIsAccessible('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}

            if(preferredValToUpdate){
                List<Part_Alternates__c> prevDefaultPOTypes = [Select   Id, 
                                                                        Preferred__c, 
                                                                        Part_ID__c,

                                                                        Alternate_Preferred__c 
                                                                        from Part_Alternates__c 
                                                                        where Id !=: alternatePartsList[0].Id
                                                                        AND ( (Part_ID__c =: partId AND Preferred__c = true) 
                                                                                OR (Alternate_Part_ID__c =: partId AND Alternate_Preferred__c = true)
                                                                            )
                                                            ];


                if(prevDefaultPOTypes.size() > 0){
                    for(Part_Alternates__c poTypeRec : prevDefaultPOTypes){
                        if(poTypeRec.Part_ID__c == partId){
                            poTypeRec.Preferred__c = false;
                        } else {
                            poTypeRec.Alternate_Preferred__c = false;
                        }
                        alternatePartstoUpdate.add(poTypeRec);
                    }
                }
            }
            if(AccessControl.ifObjectIsUpdateable('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
            update alternatePartstoUpdate;
                
            if(alternatePartstoUpdate.size() > 1){
                String infoMsg = '';
                return BPUtility.getEncodedString(String.valueOf(getTotalAlternatePartsForPart(BPUtility.getEncodedString(partId)) + ',' + infoMsg));
            }
            return BPUtility.getEncodedString(String.valueOf(getTotalAlternatePartsForPart(BPUtility.getEncodedString(partId))));
                
        }catch(exception ex){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
            return BPUtility.getEncodedString('');
        }
    }
    
    /**
     * Name: updateAlternatePartRelation
     * Desc: Update the record with supplied relation value
     * @param:  (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     *          (2) alternateOrderRelation - String - Relation value record to be updated with
     * @return: String
    **/
    @RemoteAction
    global static String updateAlternatePartRelation(String partId, String alternatePartJunctionId, String alternateOrderRelation) {
        partId = BPUtility.getDecodedString(partId);
        alternatePartJunctionId = BPUtility.getDecodedString(alternatePartJunctionId);
        alternateOrderRelation = BPUtility.getDecodedString(alternateOrderRelation);
        
        try{
	    	List<Part_Alternates__c> recsToUpdate = SOQLUtil.getAlternatePartRecords(new List<Id>{alternatePartJunctionId});
	    	if(recsToUpdate.size() == 0) {
	    		return BPUtility.getEncodedString('[]');
	    	}
	    	List<Part_Alternates__c> alternatePartRecordListToUpdate = new List<Part_Alternates__c>();
	    	Part_Alternates__c recToUpdate = recsToUpdate[0];
	    	recToUpdate.Relation__c = alternateOrderRelation;
	    	alternatePartRecordListToUpdate.add(recToUpdate);
	    	
	    	String referencedPartRelation;
	    	if(alternateOrderRelation == 'Replaces') {
	    		referencedPartRelation = 'Replaced By';
	    	} else if(alternateOrderRelation == 'Replaced By'){
	    		referencedPartRelation = 'Replaces';
	    	} else if(alternateOrderRelation == 'Alternate') {
	    		referencedPartRelation = 'Alternate';
	    	}
	    	
	    	if(AccessControl.ifObjectIsAccessible('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	List<Part_Alternates__c> partAlternateRecords = [SELECT Id, Part_ID__c, Alternate_Part_ID__c
	    													 FROM Part_Alternates__c 
	    													 WHERE Part_ID__c =: recToUpdate.Alternate_Part_ID__c 
	    													 AND Alternate_Part_ID__c =: recToUpdate.Part_ID__c
	    													];
	    	if(partAlternateRecords.size() > 0) {
	    		Part_Alternates__c alternateRecToUpdate = partAlternateRecords[0];
	    		alternateRecToUpdate.Relation__c = referencedPartRelation;
	    		alternatePartRecordListToUpdate.add(alternateRecToUpdate);
	    	}
	    	
		    if(AccessControl.ifObjectIsUpdateable('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
		    update alternatePartRecordListToUpdate;
		    
		    // Return All alternate part JSON for this Part
		    //AllAlternatePartsWrapper alternatePartObj = new AllAlternatePartsWrapper(partId, pageSortAttrsJSON);
		    //return system.JSON.serialize(alternatePartObj);
		    return BPUtility.getEncodedString('{}');
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
    
    
    /* Deprecated */
    global static String changeAlternatePartRelation(Id partId, String alternatePartJunctionId, String alternateOrderRelation, String pageSortAttrsJSON) {
    	return '' ;
    }
    
    @RemoteAction
    global static String changeAlternatePartRelation(String partId, String alternatePartJunctionId, String alternateOrderRelation, String pageSortAttrsJSON) {
    	partId = BPUtility.getDecodedString(partId);
        alternatePartJunctionId = BPUtility.getDecodedString(alternatePartJunctionId);
        alternateOrderRelation = BPUtility.getDecodedString(alternateOrderRelation);
        pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        
    	try{
	    	List<Part_Alternates__c> recsToUpdate = SOQLUtil.getAlternatePartRecords(new List<Id>{alternatePartJunctionId});
	    	if(recsToUpdate.size() == 0) {
	    		return BPUtility.getEncodedString('{}');
	    	}
	    	List<Part_Alternates__c> alternatePartRecordListToUpdate = new List<Part_Alternates__c>();
	    	Part_Alternates__c recToUpdate = recsToUpdate[0];
	    	recToUpdate.Relation__c = alternateOrderRelation;
	    	alternatePartRecordListToUpdate.add(recToUpdate);
	    	
	    	String referencedPartRelation;
	    	if(alternateOrderRelation == 'Replaces') {
	    		referencedPartRelation = 'Replaced By';
	    	} else if(alternateOrderRelation == 'Replaced By'){
	    		referencedPartRelation = 'Replaces';
	    	} else if(alternateOrderRelation == 'Alternate') {
	    		referencedPartRelation = 'Alternate';
	    	}
	    	
	    	if(AccessControl.ifObjectIsAccessible('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	List<Part_Alternates__c> partAlternateRecords = [SELECT Id, Part_ID__c, Alternate_Part_ID__c
	    													 FROM Part_Alternates__c 
	    													 WHERE Part_ID__c =: recToUpdate.Alternate_Part_ID__c 
	    													 AND Alternate_Part_ID__c =: recToUpdate.Part_ID__c
	    													];
	    	if(partAlternateRecords.size() > 0) {
	    		Part_Alternates__c alternateRecToUpdate = partAlternateRecords[0];
	    		alternateRecToUpdate.Relation__c = referencedPartRelation;
	    		alternatePartRecordListToUpdate.add(alternateRecToUpdate);
	    	}
	    	
		    if(AccessControl.ifObjectIsUpdateable('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
		    update alternatePartRecordListToUpdate;
		    
		    // Return All alternate part JSON for this Part
		    AllAlternatePartsWrapper alternatePartObj = new AllAlternatePartsWrapper(partId, pageSortAttrsJSON);
		    return BPUtility.getEncodedString(system.JSON.serialize(alternatePartObj));
		    
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    		return BPUtility.getEncodedString('');
    	}
    }
    
    /**
     * Name: removeAlternatePartRelation
     * Desc: Delete the record
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String removeAlternatePartRelation(String partId, String alternatePartJunctionId, String pageSortAttrsJSON) {
        partId = Id.valueOf(BPUtility.getDecodedString(partId));
        alternatePartJunctionId = Id.valueOf(BPUtility.getDecodedString(alternatePartJunctionId));
        pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        
        try{
            Part_Alternates__c recToDel = new Part_Alternates__c(Id = alternatePartJunctionId);
            if(AccessControl.ifObjectIsDeletable('Part_Alternates__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
            delete recToDel;
            return BPUtility.getEncodedString(System.JSON.serialize( new AllAlternatePartsWrapper(partId, pageSortAttrsJSON) ));
        }catch(exception ex){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
            return BPUtility.getEncodedString('');
        }    
    }
    
    /**
     * Name: getPaginatedAlternatePartsForPart
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedAlternatePartsForPart(String partId, String pageSortAttrsJSON) {
        partId = Id.valueOf(BPUtility.getDecodedString(partId));
        pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        
        return BPUtility.getEncodedString(System.JSON.serialize( new AllAlternatePartsWrapper(partId, pageSortAttrsJSON) ));
    }
    
    public class AllAlternatePartsWrapper {
        // All records
        public List<AlternatePart> alternateParts;
        
        // Total records
        public Integer TotalAlternateParts;
        
        public AllAlternatePartsWrapper(String partId, String pageSortAttrsJSON){
            this.alternateParts = ViewPartRelatedListCtrl.getAllAlternatePartsForPart(partId, pageSortAttrsJSON);
            this.TotalAlternateParts = AlternatePart.getTotalAlternatePartsForPart(partId);
        }
    }
    /*****************************  END: ALTERNATE PARTS SECTION    *****************************************/
    
    /*****************************  START: TAX EXEMPTION SECTION    *****************************************/
    /**
     * Name: getAllTaxExemptionsForPart
     * Desc: Get all related tax exemptions for a part record
     * @param:  (1) partId - String - Part Id for which parts need to retrieved
     * @return: String - JSON format for all the tax exemptions
    **/
    private static List<TaxExemption> getAllTaxExemptionsForPart(String partId, String pageSortAttrsJSON) {
        /*List<TaxExemption> taxExemptions = TaxExemption.getAllTaxExemptionsForPart(partId, pageSortAttrsJSON);
        return taxExemptions;*/
        return new List<TaxExemption>();
    }
    
    /**
     * Name: getTotalTaxExemptionsForPart
     * Desc: Get total count for related Tax Exemptions of a part record
     * @param:  (1) partId - String - Part Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    @RemoteAction
    global static Integer getTotalTaxExemptionsForPart(String partId) {
        return 500;
        //return TaxExemption.getTotalTaxExemptionsForPart(partId);
    }
    
    /**
     * Name: addTaxExemptionToPart
     * Desc: Add a Tax Exemption record with supplied values
     * @param:  (1) taxExemptionsJSON - String - JSON formatted array of Tax records need to be inserted
     * @return: String - If a single record is inserted, then return value will be detailed record in JSON format
    **/
    @RemoteAction
    global static String addTaxExemptionToPart(String taxExemptionsJSON) {
        /*try{
            List<TaxExemption> taxExemptionsList = TaxExemption.parse(taxExemptionsJSON);
            if(taxExemptionsList.size() == 0){
                return '';
            }
            if(AccessControl.ifObjectIsAccessible('Part_Tax__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
            // Check if any alternate part is already added for the part record
            List<Part_Tax__c> partTaxRecords = [SELECT Id 
                                                FROM Part_Tax__c 
                                                WHERE Part_ID__c =: taxExemptionsList[0].PartId 
                                                AND Sales_Tax_Item__c =: taxExemptionsList[0].SalesTaxId
                                            ];
            if(partTaxRecords.size() > 0){
                return System.JSON.serialize( new List<TaxExemption.TaxExemptionWrapper>{new TaxExemption.TaxExemptionWrapper('Sales tax is already added as Tax Exemption for part.')} );
            }
            
            // Else add records in database
            List<Part_Tax__c> taxExemptionsToInsert = new List<Part_Tax__c>();
            for(TaxExemption partTax : taxExemptionsList){
                taxExemptionsToInsert.add(new Part_Tax__c(  Part_ID__c = partTax.PartId,
                                                            Sales_Tax_Item__c = partTax.SalesTaxId,
                                                            Description__c = partTax.Description
                                                        ));
            }
            
            if(AccessControl.ifObjectIsCreateable('Part_Tax__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
            insert taxExemptionsToInsert;
            
            if(taxExemptionsList.size() == 1){
                taxExemptionsToInsert = SOQLUtil.getPartTaxesWithSalesTaxesForPart(taxExemptionsToInsert[0].Part_ID__c, null);
                return System.JSON.serialize( new List<TaxExemption.TaxExemptionWrapper>{new TaxExemption.TaxExemptionWrapper(taxExemptionsToInsert[0], taxExemptionsToInsert[0].Part_ID__c)} );
            }
            return '';
        }catch(exception ex){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
            return '';
        }*/
        return BPUtility.getEncodedString('[]');
    }
    
    /**
     * Name: getPaginatedTaxExemptionsForPart
     * Desc: Method to get records as per pagination and sorting attributes
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String getPaginatedTaxExemptionsForPart(String partId, String pageSortAttrsJSON) {
        //return System.JSON.serialize( new AllTaxExemptionsWrapper(partId, pageSortAttrsJSON) );
        return BPUtility.getEncodedString('{}');
    }
    
    /**
     * Name: removeTaxExemption
     * Desc: Delete the record
     * @param: (1) alternatePartJunctionId - String - Id of Alternate Part junction object record
     * @return: String
    **/
    @RemoteAction
    global static String removeTaxExemption(String partId, String taxExemptionId, String pageSortAttrsJSON) {
        /*try{
            Part_Tax__c recToDel = new Part_Tax__c(Id = taxExemptionId);
            if(AccessControl.ifObjectIsDeletable('Part_Tax__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
            delete recToDel;
            return System.JSON.serialize( new AllTaxExemptionsWrapper(partId, pageSortAttrsJSON) );
        }catch(exception ex){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
            return '';
        } */
        return BPUtility.getEncodedString('');
    }
    
    public class AllTaxExemptionsWrapper {
        // All records
        //public List<TaxExemption> taxExemptions;
        
        // Total records
        //public Integer TotalTaxExemptions;
        
        public AllTaxExemptionsWrapper(String partId, String pageSortAttrsJSON){
            //this.taxExemptions = ViewPartRelatedListCtrl.getAllTaxExemptionsForPart(partId, pageSortAttrsJSON);
            //this.TotalTaxExemptions = TaxExemption.getTotalTaxExemptionsForPart(partId);
        }
        
    }
    /*****************************  END: TAX EXEMPTION SECTION  *****************************************/
}