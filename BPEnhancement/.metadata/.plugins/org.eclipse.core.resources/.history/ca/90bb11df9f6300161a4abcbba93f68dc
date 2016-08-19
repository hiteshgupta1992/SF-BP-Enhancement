/**
 * Author: Hitesh Gupta
 * Since: Aug. 31, 2015
 * Name: BPGlobalHeaderCtrl
 * Description: Apex class which contains all remoted methods of global header.
**/ 
global with sharing class BPGlobalHeaderCtrl {
    
	public boolean Load_New_UI {get{return GeneralConfiguration.isLoadNewUI();} private set;}
	
	public Boolean IsTrialOrg { get{return GeneralConfiguration.isTrialOrg();} private set;}
 	
    
    /**
     * Name: getCurrentUserImageURL
     * Desc: Method used to get user image url for current user
     * @param:  
     * @return: String - string url for user image
    **/  
    public String getCurrentUserImageURL(){
        return UsersUtility.getUserImageURL(UserInfo.getUserId());
    }
    
    /**
     * Name: createCustomerOrder
     * Desc: Method which creates a customer order header record
     * @param:  
     * @return: String - inserted customer order header record Id
    **/
    @RemoteAction
    global static String createCustomerOrder(){
        CO_Header__c coHeaderToInsert = new CO_Header__c();
        coHeaderToInsert.Order_status__c = 'Open';
    	coHeaderToInsert.Owner__c = UserInfo.getUserId();
    	
    	if(AccessControl.ifObjectFieldIsCreateable('CO_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert coHeaderToInsert;
        return BPUtility.getEncodedString(String.valueOf(coHeaderToInsert.Id));
    }
    
    
    /**
     * Name: createVendorOrder
     * Desc: Method which creates a Vendor order header record
     * @param:  
     * @return: String - inserted Vendor order header record Id
    **/
    @RemoteAction
    global static String createVendorOrder(){
        
        Vendor_Order_Header__c voHeaderToInsert = new Vendor_Order_Header__c();
        voHeaderToInsert.Owner__c = UserInfo.getUserId();
        voHeaderToInsert.Status__c = 'Open';
        
        if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert voHeaderToInsert;
        return BPUtility.getEncodedString(String.valueOf(voHeaderToInsert.Id));
        // return null;
    }
    
    
    /**
     * Name: createVendorOrder
     * Desc: Method which creates a Vendor order header record
     * @param:  
     * @return: String - inserted Vendor order header record Id
    **/
    @RemoteAction
    global static String createVOReceiving(){
        
        Vendor_Receiving_Header__c voHeaderReceivingToInsert = new Vendor_Receiving_Header__c();
        voHeaderReceivingToInsert.Owner__c = UserInfo.getUserId();
        voHeaderReceivingToInsert.Status__c = 'In Progress';
        
        if(AccessControl.ifObjectFieldIsCreateable('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert voHeaderReceivingToInsert;
        return BPUtility.getEncodedString(String.valueOf(voHeaderReceivingToInsert.Id));
        
        //return null;
    }
    
    /**
     * Name: createVOInvoicing
     * Desc: Method which creates a Vendor order header record
     * @param:  
     * @return: String - inserted Vendor order header record Id
    **/
    @RemoteAction
    global static String createVOInvoicing(){
        Vendor_Invoicing_Header__c viHeaderToInsert = new Vendor_Invoicing_Header__c();
        viHeaderToInsert.Owner__c = UserInfo.getUserId();
        viHeaderToInsert.Status__c = 'In Progress';
        
        if(AccessControl.ifObjectFieldIsCreateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert viHeaderToInsert;
        return BPUtility.getEncodedString(String.valueOf(viHeaderToInsert.Id));
    }
}