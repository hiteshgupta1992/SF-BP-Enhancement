/**
 * Author: Ashish Garg
 * Since: July 9, 2015
 * Name: VendorContact
 * Description: Apex class to handle JSON related oprations of Related vendor entity.
**/
public with sharing class VendorContact {
	
	// Contact First Name
	public String FirstName;
	
	// Contact Last Name
	public String LastName;
	
	// Contact Extension #
	public Integer Extension;
	
    // Email Address
    public String Email;
    
    // Phone Number
    public String Phone;
    
    // Preferred Phone
    public Boolean IsSMS;
    
    // Preferred Phone
    public Boolean PreferredSMS;
    
    // Preferred Email
    public Boolean PreferredEmail;
    
    // Preferred Phone
    public Boolean PreferredPhone;
    
    // Job title
    public String JobTitle;
    
    // Relationship type
    public String Relation;
    
    // Parent vendor
    public String Parentvendor;
    
    // Id
    public String Id;
    
    // Constructor
    public VendorContact(Contact vendorContactRec) {
		this.Id 			= vendorContactRec.Id;
    	this.Parentvendor	= vendorContactRec.AccountId;
    	this.FirstName		= vendorContactRec.FirstName;
    	this.LastName		= vendorContactRec.LastName;
    	this.JobTitle		= (vendorContactRec.Job_Title__c == null) ? '' : vendorContactRec.Job_Title__c;
    	this.Relation		= (vendorContactRec.Relationship__c == null) ? '' : vendorContactRec.Relationship__c;
    	this.Extension		= (Integer)vendorContactRec.Extension__c;
    	
    	this.IsSMS			= (vendorContactRec.Is_SMS__c == null) ? false : vendorContactRec.Is_SMS__c;
    	this.Email 			= (vendorContactRec.Work_Email__c == null) ? '' : vendorContactRec.Work_Email__c;
    	this.Phone 			= (vendorContactRec.Phone == null ) ? '' : vendorContactRec.Phone;
    	this.PreferredPhone = (vendorContactRec.Preferred_Phone__c == null) ? false : vendorContactRec.Preferred_Phone__c;
    	this.PreferredEmail = (vendorContactRec.Preferred_Email__c == null) ? false : vendorContactRec.Preferred_Email__c;
    	this.PreferredSMS	= (vendorContactRec.Preferred_SMS__c == null) ? false : vendorContactRec.Preferred_SMS__c;
    }
    
    /**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: VendorContact - Class Object
    **/
    public static List<VendorContact> parse(String JSONString) {
        return (List<VendorContact>) System.JSON.deserialize(JSONString, List<VendorContact>.class);
    }
    
    /**
     * Name: getAllContactsForVendor
     * Desc: Get all related alternate parts for a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: String - JSON format for all the alternate parts
    **/
    public static List<VendorContact> getAllContactsForVendor(Id vendorId, String pageSortAttrsJSON) {
    	RelatedListPaginationSorting pageSortAttrs = VendorContact.parsePageAttrs(pageSortAttrsJSON);
    	
    	Map<String, String> sortFieldMap = new Map<String, String>();
    	if(pageSortAttrs.sorting != null && pageSortAttrs.sorting[0].sortDirection.length() != 0){
    		sortFieldMap.put('FirstName', pageSortAttrs.sorting[0].sortDirection);
    		sortFieldMap.put('LastName', pageSortAttrs.sorting[0].sortDirection);
    	}
    	List<VendorContact> contacts = new List<VendorContact>();
    	List<Contact> contactsList = TaxExemption.getPaginatedRecords(	SOQLUtil.getContactsForVendor(vendorId, sortFieldMap), 
																		pageSortAttrs.contactsCurrentPage, 
																		pageSortAttrs.contactsPageSize 
																	);
		
        for(Contact vendorContact : contactsList) {
    		contacts.add(new VendorContact(vendorContact));
        }
        
		return contacts;
    }
    
    /**
     * Name: getTotalContactsForVendor
     * Desc: Get total count for related Active Orders of a vendor record
     * @param:	(1) vendorId - String - Vendor Id for which parts need to retrieved
     * @return: Integer - Total count
    **/
    public static Integer getTotalContactsForVendor(Id vendorId) {
		List<Contact> contactsList = SOQLUtil.getContactsForVendor(vendorId, new Map<String, String>());
		return contactsList.size();
    }
    
    /**
     * Name: getContactDetailsById
     * Desc: Get Contact record details by id
     * @param:	(1) contactId - Id - Contact Id
     * @return: Contact
    **/
    public static Contact getContactDetailsById(Id contactId) {
    	if(contactId != null){
			List<Contact> contactsList = SOQLUtil.getCustomerContactByFieldName('Id', contactId);
			return contactsList[0];
    	} else {
    		return null;
    	}
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> vendorContactFields = new List<String>{'Id',
	                                                        'FirstName',
	                                                        'LastName',
	                                                        'Work_Email__c',
	                                                        'Preferred_Email__c',
	                                                        'Phone',
	                                                        'Preferred_Phone__c',
	                                                        'Is_SMS__c',
	                                                        'Preferred_SMS__c',
	                                                        'Job_Title__c',
	                                                        'Relationship__c',
	                                                        'Extension__c',
	                                                        'AccountId'
		                                                };
        return vendorContactFields;
    }
    
    // Wrapper class to hold contact record and total contact records in database for a vendor
    public class VendorContactWrapper {
    	// VendorContact record
    	public VendorContact ContactRecord;
    	
    	// Total count in database for a vendor
    	public Integer TotalContacts;
    	
    	// Total count in database for a vendor
    	public boolean isError;
    	
    	// Total count in database for a vendor
    	public String ErrorMsg;
    	
    	// Constructor
    	public VendorContactWrapper(Contact ContactRecord, Id vendorId){
    		this.ContactRecord = new  VendorContact(ContactRecord);
    		this.TotalContacts = VendorContact.getTotalContactsForVendor(vendorId);
    		this.isError = false;
    	}
    	
    	// Constructor
    	public VendorContactWrapper(String ErrorMsg){
    		this.isError = true;
    		this.ErrorMsg = ErrorMsg;
    	}
    }
    
    /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: RelatedListPaginationSorting - Class Object
    **/
    public static RelatedListPaginationSorting parsePageAttrs(String json) {
        return (RelatedListPaginationSorting) System.JSON.deserialize(json, RelatedListPaginationSorting.class);
    }
    
    // Wrapper class for related list pagination and sorting combination
    public class RelatedListPaginationSorting {
    	// Current page number
    	public Integer contactsCurrentPage;
    	
    	// Current page size
    	public Integer contactsPageSize;
    	
    	// Sorting list
    	public List<SortAttrs> sorting;
    }
    
    // SortAttrs for sorting attributes
    public class SortAttrs {
    	// Field name
    	public String fieldName;
    	
    	// Sort direction
    	public String sortDirection;
    }
}