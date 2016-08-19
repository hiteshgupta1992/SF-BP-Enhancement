/**
 * Author: Tarun Khandelwal
 * Since: June 05, 2015
 * Name: CustomerDetail
 * Description: Apex class to handle JSON related oprations of Customer Detail Page.
**/
public with sharing class CustomerDetail {
	
    public Customer CustomerInfo;
    
    // open orders
    public Decimal OpenOrders;
    
    // Average Life Time
    public Decimal OrdersLifetime;
    
    // Average Spend per Hours
    public Decimal AverageSpendPerHour;
    
    // Last Visited Order Time
    public String LastVisit;
    
    // Related Customer
    public Integer TotalCustomerRecords;
    public List<RelatedCustomer> RelatedCustomerList;
    
    // COU list
    public Integer TotalCOURecords;
    public List<CustomerOwnedUnit> CustomerOwnedUnitList;
    
    // Contacts List
    public Integer TotalContactRecords;
    public List<CustomerContact> ContactList;
    
    // Active Orders
    public Integer TotalActiveOrderRecords;
    public List<ActiveOrder> ActiveOrderList;
    
    // Active Sales Order (Customer Header)
    public Integer TotalActiveSalesOrderRecords;
    public List<ActiveSalesOrder> ActiveSalesOrderList;
    
    // Tax Exemptions
    public Integer TotalTaxExemptionRecords;
    public List<TaxExemptions> TaxExemptionList;
    
    public Company CompanyName; 
    
    // Constructor
    public CustomerDetail(Account customerRec, List<Account> relatedCustomersList, Map<String, String> accountIdToRelationMap, List<Customer_Owned_Unit__c> couList, 
    						List<CO_Header__c> ActiveSalesOrdersList, List<Contact> customerContactList, String lastVisitedValue,
    						List<Tax_Exemption__c> taxExemptionList, List<Business_Profile__c> businessProfileList) {
    	this.customerInfo = new Customer(customerRec);
    	this.RelatedCustomerList = new List<RelatedCustomer>();
    	this.CustomerOwnedUnitList = new List<CustomerOwnedUnit>();
    	this.ContactList = new List<CustomerContact>();
    	this.ActiveOrderList = new List<ActiveOrder>();
    	this.ActiveSalesOrderList = new List<ActiveSalesOrder>();
    	this.TaxExemptionList = new List<TaxExemptions>();
    	
    	this.OpenOrders = customerRec.Open_Orders__c;
    	this.OrdersLifetime = customerRec.Orders_Lifetime__c;
    	this.AverageSpendPerHour = customerRec.Average_Spend_per_Order__c;
    	this.LastVisit = lastVisitedValue; 
    	
    	for(Account relatedCustomerRec : relatedCustomersList) {
    		this.RelatedCustomerList.add(new RelatedCustomer(relatedCustomerRec, accountIdToRelationMap));
    	}
    	
    	for(Customer_Owned_Unit__c couRec : couList) {
    		this.CustomerOwnedUnitList.add(new CustomerOwnedUnit(couRec));
    	}
    	
    	for(CO_Header__c coh : ActiveSalesOrdersList) {
    		this.ActiveSalesOrderList.add(new ActiveSalesOrder(coh));
    	}
    	
    	for(Contact contactRec : customerContactList) {
    		this.ContactList.add(new CustomerContact(contactRec));
    	}
    	
    	Map<Id, List<String>> salesTaxItemIdToAppliesToList = getAppliesToList(taxExemptionList);
    	for(Tax_Exemption__c taxExemptionRec : taxExemptionList) {
    		this.TaxExemptionList.add(new TaxExemptions(taxExemptionRec, salesTaxItemIdToAppliesToList.get(taxExemptionRec.Sales_Tax_Item__c)));
    	}
    	
    	ActiveOrder.RelatedListPaginationSorting pageSort = new ActiveOrder.RelatedListPaginationSorting();
		pageSort.activeOrdersCurrentPage = 1;
		pageSort.activeOrdersPageSize = 1;

    	this.ActiveOrderList = ActiveOrder.getAllActiveOrdersForCustomer(customerRec.Id, system.JSON.serialize(pageSort));  
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
     * @return: CustomerDetail - Class Object
    **/
    public static CustomerDetail parse(String json) {
        return (CustomerDetail) System.JSON.deserialize(json, CustomerDetail.class);
    }
    
    public static Map<Id, List<String>> getAppliesToList(List<Tax_Exemption__c> taxExemptionList) {
    	Set<Id> salesTaxItemIdSet = new Set<Id>();
     	for(Tax_Exemption__c taxExemptionRec : taxExemptionList) {
    		salesTaxItemIdSet.add(taxExemptionRec.Sales_Tax_Item__c);
    	}
    	
    	if(salesTaxItemIdSet.size() == 0) {
    		return new Map<Id, List<String>>();
    	}
    	
    	Map<Id, List<String>> salesTaxItemIdToAppliesToList = new Map<Id, List<String>>(); 
    	if(AccessControl.ifObjectIsAccessible('Applicable_Taxes__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	List<Applicable_Taxes__c> appTaxList = [select Sales_Tax_Item__c, Sales_Tax__c, Sales_Tax__r.Name__c from Applicable_Taxes__c
    												where Sales_Tax_Item__c IN: salesTaxItemIdSet];
    	
    	for(Applicable_Taxes__c appTaxRec : appTaxList) {
    		if(appTaxRec.Sales_Tax__c != null) {
	    		List<String> appliesToList;
	    		if(!salesTaxItemIdToAppliesToList.containsKey(appTaxRec.Sales_Tax_Item__c)) {
	    			salesTaxItemIdToAppliesToList.put(appTaxRec.Sales_Tax_Item__c, new List<String>());
	    		}
    			salesTaxItemIdToAppliesToList.get(appTaxRec.Sales_Tax_Item__c).add(appTaxRec.Sales_Tax__r.Name__c);
	    	}
    	}
    	return salesTaxItemIdToAppliesToList;
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