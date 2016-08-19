/**
 * Author: Tarun Khandelwal
 * Since: July 07, 2015
 * Name: VendorDetail
 * Description: Apex class to handle JSON related oprations of Vendor Detail Page.
**/
public with sharing class VendorDetail {
	
	// Vendor Info
	public Vendor VendorDetailRec;
	
	// Vendor related Info
	public VendorRelatedLists VendorRelatedInfo;  
	
 	public Company CompanyName; 
    
 	public VendorDetail(Account vendorRec, List<Tax_Exemption__c> taxExemptionList, List<Business_Profile__c> businessProfileList) {
    	this.VendorDetailRec = new Vendor(vendorRec);
    	
    	this.VendorRelatedInfo = new VendorRelatedLists(vendorRec.Id, taxExemptionList);
    	
    	if(businessProfileList.size() > 0) {
    		this.CompanyName = new Company(businessProfileList[0]);
    	} else {
    		this.CompanyName = new Company(new Business_Profile__c());
    	}
    }
    
    /**  
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VendorDetail - Class Object
    **/
    public static VendorDetail parse(String json) {
        return (VendorDetail) System.JSON.deserialize(json, VendorDetail.class);
    }
    
    // Wrapper class for vendor related info lists
    public class VendorRelatedLists {
    	// List for Active Orders
    	public List<ActiveOrder> ActiveOrders;
    	
    	// Total count for Active Orders
    	public Integer TotalActiveOrders;
    	
    	// List for Purchase Order types
    	public List<POType> POTypes;
    	
    	// Total count for Purchase Order types
    	public Integer TotalPOTypes;
    	
    	// Contacts for vendor
    	public List<VendorContact> Contacts;
    	
    	// Total count for Vendor contact records
    	public Integer TotalContacts;
    	
    	// Products for vendor
    	public List<VendorProduct> Products;
    	
    	// Total count for Vendor Product records
    	public Integer TotalProducts;
    	
    	public Integer TotalTaxExemptionRecords;
    	public List<TaxExemptions> TaxExemptionList;
    	
    	
        // Constructor
    	public VendorRelatedLists(Id vendorId, List<Tax_Exemption__c> taxExemptionList) {
    		// Active Orders
    		this.ActiveOrders		= ActiveOrder.getAllActiveOrdersForVendor(vendorId, System.JSON.serialize(new ActiveOrder.RelatedListPaginationSorting()) );
    		this.TotalActiveOrders	= ActiveOrder.getTotalActiveOrdersForVendor(vendorId);
    		
    		// Purchase Order types
    		this.POTypes		= POType.getAllPOTypesForVendor( vendorId, System.JSON.serialize(new POType.RelatedListPaginationSorting()) );
    		this.TotalPOTypes	= POType.getTotalPOTypesForVendor(vendorId);
    		
    		// Vendor Contacts
    		this.Contacts		= VendorContact.getAllContactsForVendor( vendorId, System.JSON.serialize(new VendorContact.RelatedListPaginationSorting()) );
    		this.TotalContacts	= VendorContact.getTotalContactsForVendor(vendorId);
    		
    		// Vendor Products
    		this.Products		= VendorProduct.getAllProductsForVendor( vendorId, System.JSON.serialize(new VendorProduct.RelatedListPaginationSorting()) );
    		this.TotalProducts	= VendorProduct.getTotalProductsForVendor(vendorId);
    		
    		// Tax Exemptions
    		this.TaxExemptionList = new List<TaxExemptions>();
    		Map<Id, List<String>> salesTaxItemIdToAppliesToList = CustomerDetail.getAppliesToList(taxExemptionList);
    		for(Tax_Exemption__c taxExemptionRec : taxExemptionList) {
    			this.TaxExemptionList.add(new TaxExemptions(taxExemptionRec, salesTaxItemIdToAppliesToList.get(taxExemptionRec.Sales_Tax_Item__c)));
    		}
    		this.TotalTaxExemptionRecords = this.TaxExemptionList.size();
    	}
    }
    
    public class Company {
    	
    	public String Address1;
    	public String Address2;
    	public String State;
    	public String PostalCode;
    	public String Country;
    	public String City;
    	public String Address;
    	
    	public Company(Business_Profile__c businessProfileRec) {
    		this.Address1 = businessProfileRec.Business_Street_Address1__c;
    		this.Address2 = businessProfileRec.Business_Street_Address2__c;
    		this.City = businessProfileRec.Business_City__c;
    		this.State = (businessProfileRec.Business_State__c != null) ? businessProfileRec.Business_State__r.Name__c : '';
    		this.PostalCode = businessProfileRec.Business_Postal_Code__c;
    		this.Country = (businessProfileRec.Business_Country__c != null) ? businessProfileRec.Business_Country__r.Name__c : '';
    		
    		this.Address = '';
    		if(this.Address1 != null) {
    			this.Address += this.Address1 + ', ';
    		}
    		if(this.Address2 != null) {
    			this.Address += this.Address2 + ', ';
    		}
    		if(this.City != null) {
    			this.Address += this.City + ', ';
    		}
    		if(this.State != null) {
    			this.Address += this.State + ', ';
    		}
    		if(this.Country != null) {
    			this.Address += this.Country + ', ';
    		}
    		if(this.PostalCode != null) {
    			this.Address += this.PostalCode + ', ';
    		}
    		if(this.Address.length() > 1) {
    			this.Address = this.Address.subString(0, this.Address.length() - 2);
    		}
    	}
    }
}