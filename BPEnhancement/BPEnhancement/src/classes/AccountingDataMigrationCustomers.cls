/**
 * Author: Ashish Garg
 * Since: Dec. 18, 2015
 * Name: AccountingDataMigrationCustomers
 * Description: Class is used for migration of Customer object records to  Accounting Software
**/
global with sharing class AccountingDataMigrationCustomers implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "Customers Card" object name
	public static final String CUSTOMERS_ACCOUNTING_OBJECT_NAME = 'Customers Card';
	
	// Batch size
	private static final Integer BATCH_SIZE = 1000;
	
	// Data string for all exporatble customers data
	private String customerCardsData;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Index value to maintain total records count
	private integer indexVal;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	// Get the "Customer card" record from Accounting Data Migration object
    private Accounting_Data_Migration__c dataMigration;
	
	/**
     * Name: AccountingDataMigrationCustomers
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationCustomers(List<Id> recordIds, boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		customerCardsData = '';
		indexVal = 1;
		
		// Get the "Customer card" record from Accounting Data Migration object
		try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: CUSTOMERS_ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationCustomers.CUSTOMERS_ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter Accounts data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: AccountingDataMigrationCustomers
     * Desc: Constructor to start the batch for data export
    **/
	public static Id executeCustomerCardsDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationCustomers(recordIds, exportAllData), batchSize);
		return batchId;
	}
	
	/**
     * Name: start
     * Desc: Batch start method - Create query and execute query locator
     * @param: 
     * @return: Database.QueryLocator
    **/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}
	
	/**
     * Name: execute
     * Desc: Batch execute method to process the exported data records
     * @param:	1. Database.BatchableContext BC
     * 			2. List<sObject> scope
     * @return:
    **/
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Account> customerAccounts = (List<Account>) scope;
		
		if(customerAccounts.size() > 0){
	    	// Map of customer card records for all applicable saleforce customer records (a map of customer sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> customerCardRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// For each customer account, create a customer card entry:
	    	for(Account customer : customerAccounts){
	    		customerCardRecords.put(indexVal, createCustomersCardRecordFromAccount(customer) );
	    		indexVal++;
	    	}
	    	
	    	// Now create a string for list of customer card records so as to convert in format of importable text file for accounting software
    		customerCardsData += createImportableTextForCustomers(customerCardRecords);
    		customerCardsData = (customerCardsData.indexOf('{') != -1) ? customerCardsData.subString(customerCardsData.indexOf('{')) : customerCardsData;
    	}
	}
	
	/**
     * Name: finish
     * Desc: Batch finish method to insert a attachment for exported data in text file
     * @param:	1. Database.BatchableContext BC
     * @return:
    **/
	global void finish(Database.BatchableContext BC) {
		if(AccessControl.ifObjectFieldIsCreateable('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		Attachment attachment = new Attachment();
    	upsert dataMigration;
    	
		attachment.Body = Blob.valueOf(customerCardsData);
    	attachment.Name = 'CUSTOMER_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	insert attachment;
    	
    	// Execute next batch
    	if(exportAllData){
    		AccountingDataMigrationVendors.executeVendorCardsDataMigrationBatch(200, null, exportAllData);
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for customer orders
     * @param: 
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all customer accounts to be synched here
    	String customersQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, Website, Fax, Description, ';
    	standardFieldsQuery += 'BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ';
    	standardFieldsQuery += 'ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry';
    	
    	String customFieldsQuery = '';
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get('Account').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	
    	String whereCondition = ' WHERE Is_Customer__c = true AND LastName__c != null';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds;
    	}
    	
    	customersQuery += standardFieldsQuery + customFieldsQuery + ' FROM Account ' + whereCondition + ' ORDER BY LastName__c';
    	return customersQuery;
	}
    
    /**
     * Name: createCustomersCardRecordFromAccount
     * Desc: Method to create a customer card record by Account record. Customer card record is a map of field name to equivalent value for field
     * @param: Account customer
     * @return: Map<String, String>
    **/
    private static Map<String, String> createCustomersCardRecordFromAccount(Account customer) {
    	Map<String, String> customerCard = new Map<String, String>{ 'Card_Id__c'		=>	customer.Customer_Number__c,
    																'Card_Status__c'	=>	(customer.Active__c) ? 'N' : 'Y',
    																'First_Name__c'		=>	customer.FirstName__c,
    																'Last_Name__c'		=>	customer.LastName__c,
    																'WWW__c'			=>	customer.Website,
    																'Email__c'			=>	customer.Preferred_Email__c,
    																'Phone_No_1__c'		=>	customer.Preferred_Phone__c,
    																'Fax_No__c'			=>	customer.Fax,
    																'Notes__c'			=>	(customer.Description != null) ? customer.Description.mid(0, 255) : '',
    																'SP_Layout__c'		=>	'M',
    																'Use_Cust_Tax__c'	=>	'Y'
    															};
    	
    	// Assign customer email
    	if(customer.Type__c == 'Individual'){
			if(customer.Email__c == null && customer.Email__c == customer.Preferred_Email__c){
    			customer.Email__c = customer.Other_Email__c;
    		}
    		customerCard.put('Other_Email__c', customer.Email__c);
    	} else {
    		if(customer.Work_Email__c == null && customer.Work_Email__c == customer.Preferred_Email__c){
    			customer.Work_Email__c = customer.Other_Email__c;
    		}
    		customerCard.put('Other_Email__c', customer.Work_Email__c);
    	}
    	
    	// Assign customer phone number
    	if(customer.Type__c == 'Individual'){
			if(customer.Home_Number__c == null && customer.Home_Number__c == customer.Preferred_Phone__c){
    			customer.Home_Number__c = customer.Mobile__c;
    		}
    		customerCard.put('Phone_No_2__c', customer.Home_Number__c);
    	} else {
    		if(customer.Work_Number__c == null && customer.Work_Number__c == customer.Preferred_Phone__c){
    			customer.Work_Number__c = customer.Mobile__c;
    		}
    		customerCard.put('Phone_No_2__c', customer.Work_Number__c);
    	}
    	
    	// Assign billing address
    	if(customer.BillingStreet != null){
    		customerCard.put('Addr1_Line_1__c', customer.BillingStreet.mid(0, 255));
    		
    		if(customer.BillingStreet.length() > 255){
    			customerCard.put('Addr1_Line_2__c', customer.BillingStreet.mid(255, 510));
    		}
    		if(customer.BillingStreet.length() > 510){
    			customerCard.put('Addr1_Line_3__c', customer.BillingStreet.mid(510, 765));
    		}
    		if(customer.BillingStreet.length() > 765){
    			customerCard.put('Addr1_Line_4__c', customer.BillingStreet.mid(765, 1020));
    		}
    	}
    	customerCard.put('Addr1_City__c'	,	customer.BillingCity);
    	customerCard.put('Addr1_State__c'	,	customer.BillingState);
    	customerCard.put('Addr1_Postcode__c',	customer.BillingPostalCode);
    	customerCard.put('Addr1_Country__c'	,	customer.BillingCountry);
    	
    	// Assign shipping address
    	if(customer.ShippingStreet != null){
    		customerCard.put('Addr2_Line_1__c', customer.ShippingStreet.mid(0, 255));
    		
    		if(customer.ShippingStreet.length() > 255){
    			customerCard.put('Addr2_Line_2__c', customer.ShippingStreet.mid(255, 510));
    		}
    		if(customer.ShippingStreet.length() > 510){
    			customerCard.put('Addr2_Line_3__c', customer.ShippingStreet.mid(510, 765));
    		}
    		if(customer.ShippingStreet.length() > 765){
    			customerCard.put('Addr2_Line_4__c', customer.ShippingStreet.mid(765, 1020));
    		}
    	}
    	customerCard.put('Addr2_City__c'	,	customer.ShippingCity);
    	customerCard.put('Addr2_State__c'	,	customer.ShippingState);
    	customerCard.put('Addr2_Postcode__c',	customer.ShippingPostalCode);
    	customerCard.put('Addr2_Country__c'	,	customer.ShippingCountry);
    	
    	return customerCard;
    }
    
    /**
     * Name: createImportableTextForCustomers
     * Desc: Method to create a importable file ',' seperated text string for customer card records
     * @param: Map<Integer, Map<String,String>> customerCardRecords
     * @return: String
    **/
    private static String createImportableTextForCustomers(Map<Integer, Map<String,String>> customerCardRecords) {
    	String headerLengthRowString = '';
    	String headerRowString = '';
    	String contentsString = '';
    	
    	// Map of Customer Card fields to Accounting software fields need to be mapped in generated synch file
    	Map<String, String> createCustomersCardSFFieldToAccountingFieldsMap = createCustomersCardSFFieldToAccountingFieldsMap();
    	
    	// Create file header with software customer object fields
    	for(Integer indexVal : customerCardRecords.keySet()){
    		Map<String, String> customerCard = customerCardRecords.get(indexVal);
    		
    		contentsString += '\n';
    		for(String customerFieldSFName : customerCard.keySet()){
    			// Populate 1st row for file which is for purpose of total object fields
	    		if(indexVal == 1){
	    			headerLengthRowString += (headerLengthRowString.length() == 0) ? '{}' : DataExportService.fileSeparator;
	    		}
	    		
	    		// Populate 2nd row for file which is for purpose of object fields display
	    		if(indexVal == 1){
	    			headerRowString += createCustomersCardSFFieldToAccountingFieldsMap.get(customerFieldSFName) + DataExportService.fileSeparator;
	    		}
	    		
	    		// Now populate customer records data text
	    		String value = (customerCard.get(customerFieldSFName) != null) ? customerCard.get(customerFieldSFName) : '';
	    		value = value.replace('\r\n', ' ');
				value = value.replace('\n', ' ');
				value = value.replace('\r', ' ');
	    		contentsString += value + DataExportService.fileSeparator;
    		}
    		contentsString = contentsString.subString(0, contentsString.length() - 1);
    	}
    	
    	return ((headerLengthRowString.length() != 0) ? (headerLengthRowString.subString(0, headerLengthRowString.length()-1) + '\n') : '')
    		   + ((headerRowString.length() != 0) ? (headerRowString.subString(0, headerRowString.length()-1)) : '') 
    		   + contentsString;
    }
    
    /**
     * Name: createCustomersCardSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Customer card Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createCustomersCardSFFieldToAccountingFieldsMap() {
    	Map<String, String> createCustomersCardSFFieldToAccountingFieldsMap = new Map<String, String>{	 'Card_Id__c'		=>	'Card ID',
				    																					 'Card_Status__c'	=>	'Card Status',
				    																					 'First_Name__c'	=>	'First Name',
				    																					 'Last_Name__c'		=>	'Co./Last Name',
				    																					 'Addr1_Line_1__c'	=>	'Addr 1 - Line 1',
				    																					 'Addr1_Line_2__c'	=>	'Addr 1 - Line 2',
				    																					 'Addr1_Line_3__c'	=>	'Addr 1 - Line 3',
				    																					 'Addr1_Line_4__c'	=>	'Addr 1 - Line 4',
				    																					 'Addr1_City__c'	=>	'Addr 1 - City',
				    																					 'Addr1_State__c'	=>	'Addr 1 - State',
				    																					 'Addr1_Postcode__c'=>	'Addr 1 - Postcode',
				    																					 'Addr1_Country__c'	=>	'Addr 1 - Country',
				    																					 'Addr2_Line_1__c'	=>	'Addr 2 - Line 1',
				    																					 'Addr2_Line_2__c'	=>	'Addr 2 - Line 2',
				    																					 'Addr2_Line_3__c'	=>	'Addr 2 - Line 3',
				    																					 'Addr2_Line_4__c'	=>	'Addr 2 - Line 4',
				    																					 'Addr2_City__c'	=>	'Addr 2 - City',
				    																					 'Addr2_State__c'	=>	'Addr 2 - State',
				    																					 'Addr2_Postcode__c'=>	'Addr 2 - Postcode',
				    																					 'Addr2_Country__c'	=>	'Addr 2 - Country',
				    																					 'Addr3_Line_1__c'	=>	'Addr 3 - Line 1',
				    																					 'Addr3_Line_2__c'	=>	'Addr 3 - Line 2',
				    																					 'Addr3_Line_3__c'	=>	'Addr 3 - Line 3',
				    																					 'Addr3_Line_4__c'	=>	'Addr 3 - Line 4',
				    																					 'Addr3_City__c'	=>	'Addr 3 - City',
				    																					 'Addr3_State__c'	=>	'Addr 3 - State',
				    																					 'Addr3_Postcode__c'=>	'Addr 3 - Postcode',
				    																					 'Addr3_Country__c'	=>	'Addr 3 - Country',
				    																					 'Addr4_Line_1__c'	=>	'Addr 4 - Line 1',
				    																					 'Addr4_Line_2__c'	=>	'Addr 4 - Line 2',
				    																					 'Addr4_Line_3__c'	=>	'Addr 4 - Line 3',
				    																					 'Addr4_Line_4__c'	=>	'Addr 4 - Line 4',
				    																					 'Addr4_City__c'	=>	'Addr 4 - City',
				    																					 'Addr4_State__c'	=>	'Addr 4 - State',
				    																					 'Addr4_Postcode__c'=>	'Addr 4 - Postcode',
				    																					 'Addr4_Country__c'	=>	'Addr 4 - Country',
				    																					 'WWW__c'			=>	'Addr 1 - WWW',
				    																					 'Email__c'			=>	'Addr 1 - Email',
				    																					 'Other_Email__c'	=>	'Addr 2 - Email',
				    																					 'Phone_No_1__c'	=>	'Addr 1 - Phone No. 1',
				    																					 'Phone_No_2__c'	=>	'Addr 1 - Phone No. 2',
				    																					 'Phone_No_3__c'	=>	'Addr 1 - Phone No. 3',
				    																					 'Fax_No__c'		=>	'Addr 1 - Fax No.',
				    																					 'Notes__c'			=>	'Notes',
				    																					 'SP_Layout__c'		=>	'Sales/Purchase Layout',
				    																					 'Use_Cust_Tax__c'	=>	'Use Customer\'s Tax Code'
				    																				};
    	
    	return createCustomersCardSFFieldToAccountingFieldsMap;
    }
}