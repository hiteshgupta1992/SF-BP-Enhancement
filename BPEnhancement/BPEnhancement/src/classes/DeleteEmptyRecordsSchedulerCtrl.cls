/**
 * Author: Anurag Anand
 * Since: April. 26, 2016
 * Name: DeleteEmptyRecordsSchedulerCtrl
 * Description: Apex class which contains methods to delete Active Blank Records.
**/
public with sharing class DeleteEmptyRecordsSchedulerCtrl {
    /**
     * Name: deleteVendorInvoicing
     * Desc: Method which delete the VendorInvoice which are blank
     * @param:  
     * @return: 
    **/
    public static void deleteVendorInvoicing(){
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectIsDeletable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Vendor_Invoicing_Header__c>  activeInvoicingRecords = [Select Status__c, (Select Id From Vendor_Invoicing_Groups__r) From Vendor_Invoicing_Header__c 
                                                                        where Status__c != 'Invoiced'];
        List<Vendor_Invoicing_Header__c> recordsToDelete = new List<Vendor_Invoicing_Header__c>();
        for(Vendor_Invoicing_Header__c vendorInvoiceRec :activeInvoicingRecords ){                                          
            if(vendorInvoiceRec.Vendor_Invoicing_Groups__r.size() == 0){
                Vendor_Invoicing_Header__c vendInvoiceHeaderObj = new Vendor_Invoicing_Header__c(Id = vendorInvoiceRec.Id);
                recordsToDelete.add(vendInvoiceHeaderObj);
            }
        }
        if(recordsToDelete.size()!=0){
            //system.debug('deleteVendorInvoicing');
            delete recordsToDelete;
        }
                                                                        
    } 
    
    /**
     * Name: deleteVendorRecieving
     * Desc: Method which delete the VendortRecieving which are blank
     * @param:  
     * @return: 
    **/ 
    public  static void deleteVendorRecieving(){
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Vendor_Receiving_Header__c>  activeRecievingRecords = [Select Status__c, In_Progress_VI__c, (Select Id From Vendor_Receiving_Groups__r) From Vendor_Receiving_Header__c  where Status__c Not in ('Invoiced','Stocked' ) ];
    
                                                                        
        List<Vendor_Receiving_Header__c> recordsToDelete = new List<Vendor_Receiving_Header__c>();
        for(Vendor_Receiving_Header__c vendorReceivingRec :activeRecievingRecords ){                                            
            if((vendorReceivingRec.In_Progress_VI__c == null)&&(vendorReceivingRec.Vendor_Receiving_Groups__r.size() == 0)){
                Vendor_Receiving_Header__c VORecevingHeaderObj = new Vendor_Receiving_Header__c(Id = vendorReceivingRec.Id);
                recordsToDelete.add(VORecevingHeaderObj);
            }
        }
        if(recordsToDelete.size()!=0){
            //system.debug('deleteVendorRecieving');
            delete recordsToDelete;     
        }
                                                                        
    } 
    
    /**
     * Name: deleteVendorOrder
     * Desc: Method which delete the VendorOrder which are blank
     * @param:  
     * @return: 
    **/
    public  static void deleteVendorOrder(){
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectIsDeletable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
        List<Vendor_Order_Header__c >  activeVendorOrderRecords = [Select In_Progress_VR__c, Id, Status__c , (Select Id From Vendor_Order_Line_Item_Groups__r)
                                                                 From Vendor_Order_Header__c  where Status__c Not IN ('Received','Deleted' ) ];
    
                                                                        
        List<Vendor_Order_Header__c > recordsToDelete = new List<Vendor_Order_Header__c >();
        for(Vendor_Order_Header__c  vendorHeaderRec :activeVendorOrderRecords ){                                            
            if((vendorHeaderRec.In_Progress_VR__c == null)&&(vendorHeaderRec.Vendor_Order_Line_Item_Groups__r.size() == 0)){
                Vendor_Order_Header__c  VOHeaderObj = new Vendor_Order_Header__c (Id = vendorHeaderRec.Id);
                recordsToDelete.add(VOHeaderObj);
            }
        }
        if(recordsToDelete.size()!=0){
            //system.debug('deleteVendorOrder');
            delete recordsToDelete;
        }                                                               
    } 
    
    /**
     * Name: deleteCustomerOrder
     * Desc: Method which delete the CustomerOrder which are blank
     * @param:  
     * @return: 
    **/ 
    public  static void deleteCustomerOrder(){
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Kit_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Deposit__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }    	
        List<CO_Header__c >  activeCustomerOrderRecords = [Select Status__c, Id, (Select Id From Service_Order_Headers__r), (Select Id From CO_Line_Items__r), 
                                                            (Select Id From CO_Kit_Headers__r), (Select Id,Invoice_Status__c From CO_Invoice_Headers__r), 
                                                            (Select Id From CO_Deposits__r) From CO_Header__c  where Status__c Not IN ('Closed','Deleted')
                                                            ];
                                                                            
        Set<String> activeCOInvoiceHeaderSet =  new Set<String>();
        Set<Id> activeServiceOrderHeaderSet =  new Set<Id>();
        
        Map<Id, CO_Header__c> COHeaderObjMap  = new Map<Id, CO_Header__c>();
                                                                        
        Set<CO_Header__c > recordsToDelete = new Set<CO_Header__c >();
        for(CO_Header__c  COHeaderRec :activeCustomerOrderRecords ){    
            boolean hasRecords = false;
            if((COHeaderRec.CO_Line_Items__r.size() != 0)||(COHeaderRec.CO_Kit_Headers__r.size() != 0)){
                hasRecords = true;
                continue;
            }
            if(COHeaderRec.Service_Order_Headers__r.size() != 0){
                    for(Service_Order_Header__c serviceHeaderRec : COHeaderRec.Service_Order_Headers__r){
                     activeServiceOrderHeaderSet.add(serviceHeaderRec.Id);
                    }
            }
            if(COHeaderRec.CO_Deposits__r.size() != 0){  
                hasRecords = true;
                continue;
            }
            if(COHeaderRec.CO_Invoice_Headers__r.size() != 0){
                for(CO_Invoice_Header__c coInvoiceRec : COHeaderRec.CO_Invoice_Headers__r ){
                    if(coInvoiceRec.Invoice_Status__c == 'Closed'){
                        hasRecords = true;
                        if(activeCOInvoiceHeaderSet.contains(coInvoiceRec.Id)){
                            activeCOInvoiceHeaderSet.remove(coInvoiceRec.Id);
                        }
                        break;
                        
                    }else{
                        activeCOInvoiceHeaderSet.add(coInvoiceRec.Id);
                        system.debug(coInvoiceRec.Id);
                        continue;
                    }
                }
            }
            if(hasRecords == false){
                COHeaderObjMap.put(COHeaderRec.Id, COHeaderRec);
            }
            system.debug('@@@@@@@@' + hasRecords);
        }
        if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<CO_Invoice_Header__c> activeCOInvoiceItemList = [Select Id, CO_Header__c, Invoice_Status__c, (Select Id From CO_Invoice_Payments__r), (Select Id From CO_Invoice_Items__r) From CO_Invoice_Header__c 
                                                                WHERE Id IN :activeCOInvoiceHeaderSet AND Invoice_Status__c != 'Closed'  ];
        
        for(CO_Invoice_Header__c coInvoiceRec : activeCOInvoiceItemList ){
            
            if((coInvoiceRec.CO_Invoice_Items__r.size() == 0) && (coInvoiceRec.CO_Invoice_Payments__r.size() == 0)){
                CO_Header__c  COHeaderObj = new CO_Header__c (Id = coInvoiceRec.CO_Header__c);
                COHeaderObjMap.put(COHeaderObj.Id, COHeaderObj);
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Service_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Hours_Logged__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Service_Order_Header__c> serviceOrderHeaderLineItemList = [Select CO_Header__c, (Select Id From Service_Order_Line_Items__r) ,(Select Id From Hours_Logged__r)  From Service_Order_Header__c where Id IN :activeServiceOrderHeaderSet];
        
        for(Service_Order_Header__c serviceOrderHeaderRec : serviceOrderHeaderLineItemList ){
            CO_Header__c  COHeaderObj = new CO_Header__c (Id = serviceOrderHeaderRec.CO_Header__c);
                if((serviceOrderHeaderRec.Service_Order_Line_Items__r.size() != 0) && (serviceOrderHeaderRec.Hours_Logged__r.size() != 0)){
                    
                    if(COHeaderObjMap.containsKey(COHeaderObj.Id)){
                        COHeaderObjMap.remove(COHeaderObj.Id);
                    }
            }
        }
        
        
            
        
        if(COHeaderObjMap.size() > 0){
            //system.assert(false, recordsToDelete);
            //system.assert(false, COHeaderObjMap.size() );
            if(AccessControl.ifObjectIsDeletable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            delete COHeaderObjMap.values();
        }
                                                                        
    }
}