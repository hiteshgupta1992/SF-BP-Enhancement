/**
 * Author: Tarun Khandelwal
 * Since: July 06, 2015
 * Name: Vendor
 * Description: Apex class to handle JSON related oprations of Vendor object.
**/
public with sharing class Vendor {
	
	// Customer Name
    public String VendorName;
    
    // Active Customer
    public Boolean Active;
    
    // Vendor Account Number
    public String VendorAccountNumber;
    
    // FaceBook Link
    public String FacebookLink;
    
    // Twitter Link 
    public String TwitterLink;
    
    // Linkedin Link
    public String LinkedInLink;
    
    // Vendor Code
    public String VendorCode;
    
    // Home Eamil Address
    public String HomeEmail;
    
    // Work Email Address
    public String WorkEmail;
    
    // Other Email Address
    public String OtherEmail;
    
    // Home Number
    public String HomeNumber;
    
    // Mobile Number
    public String OtherPhone;
    
    // Work Number
    public String WorkNumber;
    
    // Is Home Number is treated as SMS ?
    public Boolean HomeNumberSMS;
    
    // Is Mobile Number is treated as SMS ?
    public Boolean MobileNumberSMS;
    
    // Is Work Number is treated as SMS ?
    public Boolean WorkNumberSMS;
    
    // Is vendor
    public Boolean IsVendor;
    
    // Preferred Email
    public String PreferredEmail;
    
    // Preferred Phone
    public String PreferredPhone;
    
    // Preferred SMS
    public String PreferredSMS;
    
    // Is Both Address Same - Shipping Address and Billing Address?
    public Boolean IsBothAddressSame;
    
    // Billing Address Fields
    public String BillingStreet1;
    public String BillingStreet2;
    public String BillingCity;
    public String BillingState;
    public String BillingCountry;
    public String BillingPostalCode;
    
    // Shipping Address Fields
    public String ShippingStreet1;
    public String ShippingStreet2;
    public String ShippingCity;
    public String ShippingState;
    public String ShippingCountry;
    public String ShippingPostalCode;
    
    // Id
    public String Id;
    
    // Website
    public String Website;
    
    // Fax 
    public String Fax; 
    
    // Is Claims for Service Work
    public Boolean IsClaimsForServiceWork;
    
    // Is Flooring Company
    public Boolean IsFlooringCompany;
    
    // Is Part Purchases
    public Boolean IsPartPurchases;
    
    // Is Sublet Purchases
    public Boolean IsSubletPurchases;
    
    // Is Unit Purchases
    public Boolean IsUnitPurchases;
    
    // Is Warranty Plan Sales on Unit Deals
    public Boolean IsWarrantyPlans;
    
    // Part Category Name
    public String PartCategoryName;
    
    // Part Category Id
    public String PartCategoryId;
    
    // SalesTax ID
    public String PurchaseTaxLevelId;
    
    // Price Leel Name
    public String PurchaseTaxLevelName;
    
    // Price Level ID
    public String SalesPriceLevelId;
    
    // Price Leel Name
    public String SalsePriceLevelName;
    
    // SalesTax ID
    public String SalesTaxLevelId;
    
    // Price Leel Name
    public String SalesTaxLevelName;
    
    // Customer Number
    public String VendorNumber;
    
    // Constructor
    public Vendor(Account vendorRec) { 
    	this.VendorName = vendorRec.Name;
    	this.Active = vendorRec.Active__c;
    	this.VendorAccountNumber = vendorRec.AccountNumber;
    	
    	// Emails
    	this.HomeEmail = (vendorRec.Email__c == null) ? '' : vendorRec.Email__c;
    	this.WorkEmail = (vendorRec.Work_Email__c == null) ? '' : vendorRec.Work_Email__c;
    	this.OtherEmail = (vendorRec.Other_Email__c == null) ? '' : vendorRec.Other_Email__c;
    	
    	// Phone
    	this.HomeNumber = (vendorRec.Home_Number__c == null ) ? '' : vendorRec.Home_Number__c;
    	this.OtherPhone = (vendorRec.Mobile__c == null) ? '' : vendorRec.Mobile__c;
    	this.WorkNumber = (vendorRec.Work_Number__c == null) ? '' : vendorRec.Work_Number__c;
    	
    	// SMS
    	this.HomeNumberSMS = vendorRec.Home_Number_SMS__c;
    	this.MobileNumberSMS = vendorRec.Mobile_Number_SMS__c;
    	this.WorkNumberSMS = vendorRec.Work_Number_SMS__c;
    	
    	// Social Links
    	this.FacebookLink = (vendorRec.Facebook__c == null) ? '' : vendorRec.Facebook__c;
    	this.TwitterLink = (vendorRec.Twitter__c == null) ? '' : vendorRec.Twitter__c;
    	this.LinkedInLink = (vendorRec.LinkedIn__c == null) ? '' : vendorRec.LinkedIn__c;
    	
    	// Billing Address fields
    	String billingStreet = (vendorRec.BillingStreet == null ) ? '' : vendorRec.BillingStreet;
    	List<String> bsList = billingStreet.split('\n');
    	this.BillingStreet1 = (bsList.size() > 0) ? bsList[0] : '';
    	this.BillingStreet2 = (bsList.size() > 1) ? bsList[1] : '';
    	this.BillingCity = (vendorRec.BillingCity == null) ? '' : vendorRec.BillingCity;
    	this.BillingState = (vendorRec.BillingState == null) ? '' : vendorRec.BillingState;
    	this.BillingCountry = (vendorRec.BillingCountry == null) ? '' : vendorRec.BillingCountry;
    	this.BillingPostalCode = (vendorRec.BillingPostalCode == null) ? '' : vendorRec.BillingPostalCode;
    	
    	// Shipping Address fields
    	String shippingStreet = (vendorRec.ShippingStreet == null ) ? '' : vendorRec.ShippingStreet;
    	List<String> ssList = shippingStreet.split('\n');
    	this.ShippingStreet1 = (ssList.size() > 0) ? ssList[0] : '';
    	this.ShippingStreet2 = (ssList.size() > 1) ? ssList[1] : '';
    	this.ShippingCity = (vendorRec.ShippingCity == null) ? '' : vendorRec.ShippingCity;
    	this.ShippingState = (vendorRec.ShippingState == null) ? '' : vendorRec.ShippingState;
    	this.ShippingCountry = (vendorRec.ShippingCountry == null) ? '' : vendorRec.ShippingCountry;
    	this.ShippingPostalCode = (vendorRec.ShippingPostalCode == null) ? '' : vendorRec.ShippingPostalCode;

    	// Phone And Email Preffered
    	if(vendorRec.Preferred_Email__c != null) {
    		if(vendorRec.Preferred_Email__c == vendorRec.Email__c) {
    			this.PreferredEmail = 'HomeEmail';
    		} else if(vendorRec.Preferred_Email__c == vendorRec.Work_Email__c) {
    			this.PreferredEmail = 'WorkEmail';
    		} else if(vendorRec.Preferred_Email__c == vendorRec.Other_Email__c) {
    			this.PreferredEmail = 'OtherEmail';
    		}
    	} else {
    		this.PreferredEmail = '';
    	}
    	
    	if(vendorRec.Preferred_Phone__c != null) {
    		if(vendorRec.Preferred_Phone__c == vendorRec.Home_Number__c) {
    			this.PreferredPhone = 'HomeNumber';
    		} else if(vendorRec.Preferred_Phone__c == vendorRec.Mobile__c) {
    			this.PreferredPhone = 'OtherPhone';
    		} else if(vendorRec.Preferred_Phone__c == vendorRec.Work_Number__c) {
    			this.PreferredPhone = 'WorkNumber';
    		}
    	} else {
    		this.PreferredPhone = '';
    	}
    	
    	if(vendorRec.Preferred_SMS__c != null) {
    		if(vendorRec.Preferred_SMS__c == vendorRec.Home_Number__c) {
    			this.PreferredSMS = 'HomeNumber';
    		} else if(vendorRec.Preferred_SMS__c == vendorRec.Mobile__c) {
    			this.PreferredSMS = 'OtherPhone';
    		} else if(vendorRec.Preferred_SMS__c == vendorRec.Work_Number__c) {
    			this.PreferredSMS = 'WorkNumber';
    		}
    	} else {
    		this.PreferredSMS = '';
    	}
    	
    	// Look up fields
    	this.SalesPriceLevelId = vendorRec.Price_Level__c;
    	this.SalsePriceLevelName = (vendorRec.Price_Level__c == null) ? '' : vendorRec.Price_Level__r.Name__c;
    	this.SalesTaxLevelId = vendorRec.Sales_Tax__c;
    	this.SalesTaxLevelName = (vendorRec.Sales_Tax__c == null) ? '' : vendorRec.Sales_Tax__r.Name__c;
    	this.PurchaseTaxLevelId = vendorRec.Purchase_Tax__c;
    	this.PurchaseTaxLevelName = (vendorRec.Purchase_Tax__c == null) ? '' : vendorRec.Purchase_Tax__r.Name__c;
    	this.PartCategoryId = (vendorRec.Part_Category_Default__c == null) ? '' : vendorRec.Part_Category_Default__c;
    	this.PartCategoryName = (vendorRec.Part_Category_Default__c == null) ? '' : vendorRec.Part_Category_Default__r.Name;
    	
    	// Boolean Checkbox
    	this.IsClaimsForServiceWork = vendorRec.Claims_for_Service_Work__c;
    	this.IsFlooringCompany = vendorRec.Flooring_Company__c;
    	this.IsPartPurchases = vendorRec.Part_Purchases__c;
    	this.IsSubletPurchases = vendorRec.Sublet_Purchases__c;
    	this.IsUnitPurchases = vendorRec.Unit_Purchases__c;
    	this.IsWarrantyPlans = vendorRec.Warranty_Plan_Sales_on_Unit_Deals__c;
    	
    	// Some more fields
    	this.IsBothAddressSame = vendorRec.SA_same_as_BA__c;
    	this.IsVendor = vendorRec.Is_Vendor__c;
    	this.VendorNumber = vendorRec.Vendor_Number__c;
    	this.Id = (vendorRec.Id == null) ? '' : vendorRec.Id;
    	this.VendorCode = vendorRec.Vendor_Code__c; 
    	this.Website = (vendorRec.Website == null) ? '' : vendorRec.Website;
    	this.Fax = (vendorRec.Fax == null) ? '' : vendorRec.Fax;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: Vendor - Class Object
    **/
    public static Vendor parse(String json) {
        return (Vendor) System.JSON.deserialize(json, Vendor.class);
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> customerFields = new List<String>{ 'Id',
                                                        'Name',
                                                        'Active__c',
                                                        'AccountNumber',
                                                        'Company_Name__c',
                                                        'Facebook__c',
                                                        'Email__c',
                                                        'Home_Number__c',
                                                        'Home_Number_SMS__c',
                                                        'Is_Vendor__c',
                                                        'LinkedIn__c',
                                                        'Mobile__c',
                                                        'Mobile_Number_SMS__c', 
                                                        'Other_Email__c',
                                                        'Preferred_Email__c',
                                                        'Preferred_Phone__c',
                                                        'Preferred_SMS__c',
                                                        'Twitter__c',
                                                        'Work_Email__c',
                                                        'Work_Number__c',
                                                        'Work_Number_SMS__c',
                                                        'SA_same_as_BA__c',
                                                        'BillingStreet',
                                                        'BillingCity',
                                                        'BillingState',
                                                        'BillingCountry',
                                                        'BillingPostalCode',
                                                        'ShippingStreet',
                                                        'ShippingCity',
                                                        'ShippingState',
                                                        'ShippingCountry',
                                                        'ShippingPostalCode',
                                                        'LastModifiedDate',
                                                        'Sales_Tax__c',
                                                        'Sales_Tax__r.Name__c',
                                                        'Price_Level__c',
                                                        'Price_Level__r.Name__c',
                                                        'Purchase_Tax__c',
                                                        'Purchase_Tax__r.Name__c',
                                                        'Part_Category_Default__c',
                                                        'Part_Category_Default__r.Name',
                                                        'Vendor_Number__c',
                                                        'Claims_for_Service_Work__c',
														'Flooring_Company__c',
														'Part_Purchases__c',
														'Sublet_Purchases__c',
														'Unit_Purchases__c',
														'Warranty_Plan_Sales_on_Unit_Deals__c',
														'Vendor_Code__c',
														'Website',
														'Fax'
												};
        return customerFields;
    }
}