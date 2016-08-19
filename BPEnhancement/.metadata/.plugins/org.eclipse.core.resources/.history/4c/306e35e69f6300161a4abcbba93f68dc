/**
 * Author: Tarun Khandelwal
 * Since: May 22, 2015
 * Name: CustomerWrapper
 * Description: Apex class to handle JSON related oprations of Customer and COU objects.
**/
public with sharing class CustomerWrapper {
	
	// Customer Name
    public Customer CustomerRecord;
    
    // Customer First Name
    public List<CustomerOwnedUnit> COURecords;
    
    // Constructor
    public CustomerWrapper(Account customerRec, List<Customer_Owned_Unit__c> coUnitRecList) {
    	this.CustomerRecord = new Customer(customerRec);
    	
    	this.COURecords = new List<CustomerOwnedUnit>();
    	for(Customer_Owned_Unit__c couRec : coUnitRecList) {
    		this.COURecords.add(new CustomerOwnedUnit(couRec));
    	}
    }
    
    public static CustomerWrapper parse(String json) {
        return (CustomerWrapper) System.JSON.deserialize(json, CustomerWrapper.class);
    }
}