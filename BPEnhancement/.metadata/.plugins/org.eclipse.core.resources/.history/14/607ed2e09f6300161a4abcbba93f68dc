/**
* Author: 
* Since: July 6, 2016
* Name: BusinessProfileWrapper
* Description: Apex class to wrap variables for business profile section in user settings page
**/

global with sharing class BusinessProfileWrapper {
    
    public String Id;
    public String BusinessName;
    public String BusinessPhone;
    public String BusinessEmail;
    
    public String BusinessStreetAddress1;
    public String BusinessStreetAddress2;
    public String BusinessCity;
    public String BusinessZipCode;
    public String BusinessCountryId;
    public String BusinessStateId;
    
    public Boolean IsSameAsBusinessAddress;
	public String ShippingCompanyName;    
    public String ShippingStreetAddress1;
    public String ShippingStreetAddress2;
    public String ShippingCity;
    public String ShippingZipCode;
    public String ShippingCountryId;
    public String ShippingStateId;
    
    public BusinessProfileWrapper(Business_Profile__c businessProfileObj){
    	
    	if(businessProfileObj.Id != null){
	    	Id = businessProfileObj.Id;
    	}
     	BusinessName = businessProfileObj.Business_Name__c == null ? '': businessProfileObj.Business_Name__c;
        BusinessPhone = businessProfileObj.Business_Phone__c == null ? '': businessProfileObj.Business_Phone__c;
        BusinessEmail = businessProfileObj.Business_Email__c == null ? '': businessProfileObj.Business_Email__c;
        BusinessStreetAddress1 = businessProfileObj.Business_Street_Address1__c == null ? '': businessProfileObj.Business_Street_Address1__c;
        BusinessStreetAddress2 = businessProfileObj.Business_Street_Address2__c == null ? '': businessProfileObj.Business_Street_Address2__c;
        BusinessCity = businessProfileObj.Business_City__c == null ? '': businessProfileObj.Business_City__c;
        BusinessZipCode = businessProfileObj.Business_Postal_Code__c == null ? '': businessProfileObj.Business_Postal_Code__c;
        BusinessCountryId = businessProfileObj.Business_Country__c == null ? '': businessProfileObj.Business_Country__c;
        BusinessStateId = businessProfileObj.Business_State__c == null ? '': businessProfileObj.Business_State__c;
        
        IsSameAsBusinessAddress = businessProfileObj.Id == null ? true : businessProfileObj.Same_As_Business_Address__c;
        ShippingCompanyName = businessProfileObj.Company_Name_Optional__c == null ? '': businessProfileObj.Company_Name_Optional__c;
        ShippingStreetAddress1 = businessProfileObj.Shipping_Street_Address1__c == null ? '': businessProfileObj.Shipping_Street_Address1__c;
        ShippingStreetAddress2 = businessProfileObj.Shipping_Street_Address2__c == null ? '': businessProfileObj.Shipping_Street_Address2__c;
        ShippingCity = businessProfileObj.Shipping_City__c == null ? '': businessProfileObj.Shipping_City__c;
        ShippingZipCode = businessProfileObj.Shipping_Postal_Code__c == null ? '': businessProfileObj.Shipping_Postal_Code__c;
        ShippingCountryId = businessProfileObj.Shipping_Country__c == null ? '': businessProfileObj.Shipping_Country__c;
        ShippingStateId = businessProfileObj.Shipping_State__c == null ? '': businessProfileObj.Shipping_State__c;
    }
        
}