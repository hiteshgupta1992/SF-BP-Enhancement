/**
 * Author: Ashish Garg
 * Since: Jan. 12, 2016
 * Name: AccountingDataMigrationVendors
 * Description: Class is used for migration of Supplier object records to  Accounting Software
**/
global with sharing class AccountingDataMigrationVendors implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "Supplier Card" object name
	public static final String VENDORS_ACCOUNTING_OBJECT_NAME = 'Supplier Card';
	
	// Batch size
	private static final Integer BATCH_SIZE = 1000;
	
	// Data string for all exporatble suppliers data
	private String supplierCardsData;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Index value to maintain total records count
	private integer indexVal;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	/**
     * Name: AccountingDataMigrationVendors
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationVendors(List<Id> recordIds, boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		supplierCardsData = '';
		indexVal = 1;
		
		// Get the "Supplier card" record from Accounting Data Migration object
    	Accounting_Data_Migration__c dataMigration;
    	try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: VENDORS_ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationVendors.VENDORS_ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter Accounts data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	upsert dataMigration;
    	
    	if(AccessControl.ifObjectFieldIsAccessible('Account') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: executeVendorCardsDataMigrationBatch
     * Desc: Method to start execution of batch process
     * Param: 1) Integer batchSize
     *		  2) List<Id> recordIds
     *		  3) boolean exportAllData
     * Return:
    **/
	public static Id executeVendorCardsDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationVendors(recordIds, exportAllData), batchSize);
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
		List<Account> supplierAccounts = (List<Account>) scope;
		
		if(supplierAccounts.size() > 0){
	    	// Map of supplier card records for all applicable saleforce supplier records (a map of supplier sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> supplierCardRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// For each supplier account, create a supplier card entry:
	    	for(Account supplier : supplierAccounts){
	    		supplierCardRecords.put(indexVal, createVendorsCardRecordFromAccount(supplier) );
	    		indexVal++;
	    	}
	    	
	    	// Now create a string for list of supplier card records so as to convert in format of importable text file for accounting software
    		supplierCardsData += createImportableTextForVendors(supplierCardRecords);
    		supplierCardsData = (supplierCardsData.indexOf('{') != -1) ? supplierCardsData.subString(supplierCardsData.indexOf('{')) : supplierCardsData;
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
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
		Attachment attachment = new Attachment();
    	
		Accounting_Data_Migration__c dataMigration;
		try{
    		dataMigration = [Select Id from Accounting_Data_Migration__c where Object_Name__c =: AccountingDataMigrationVendors.VENDORS_ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationVendors.VENDORS_ACCOUNTING_OBJECT_NAME);
    		insert dataMigration;
    	}
    	
		attachment.Body = Blob.valueOf(supplierCardsData);
    	attachment.Name = 'SUPPLIER_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	insert attachment;
    	
    	// Execute next batch
    	if(exportAllData){
    		AccountingDataMigrationDeposits.executeDepositsDataMigrationBatch(200, null, exportAllData);
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for supplier orders
     * @param: 
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all supplier accounts to be synched here
    	String suppliersQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, Website, Fax, Description, Purchase_Tax__r.Name__c, ';
    	standardFieldsQuery += 'BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ';
    	standardFieldsQuery += 'ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry';
    	
    	String customFieldsQuery = '';
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get('Account').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	
    	String whereCondition = ' WHERE Is_Vendor__c = true';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds;
    	}
    	
    	suppliersQuery += standardFieldsQuery + customFieldsQuery + ' FROM Account ' + whereCondition + ' ORDER BY LastName__c';
    	return suppliersQuery;
	}
    
    /**
     * Name: createVendorsCardRecordFromAccount
     * Desc: Method to create a supplier card record by Account record. Supplier card record is a map of field name to equivalent value for field
     * @param: Account supplier
     * @return: Map<String, String>
    **/
    private static Map<String, String> createVendorsCardRecordFromAccount(Account supplier) {
    	Map<String, String> supplierCard = new Map<String, String>{ 'Card_Id__c'		=>	supplier.Vendor_Code__c,
    																'Last_Name__c'		=>	(supplier.Type__c == 'Individual') ? (((supplier.FirstName__c != null) ? (supplier.FirstName__c + ' ') : '') + supplier.LastName__c) : supplier.Name,
    																'WWW__c'			=>	supplier.Website,
    																'Email__c'			=>	(supplier.Preferred_Email__c != null) ? supplier.Preferred_Email__c : supplier.Work_Email__c,
    																'Phone_No_1__c'		=>	(supplier.Preferred_Phone__c != null) ? supplier.Preferred_Phone__c : supplier.Work_Number__c,
    																'Phone_No_2__c'		=>	(supplier.Preferred_Phone__c != null) ? supplier.Work_Number__c : '',
    																'Fax_No__c'			=>	supplier.Fax,
    																'Tax_Code__c'		=>	(supplier.Purchase_Tax__r.Name__c != null) ? supplier.Purchase_Tax__r.Name__c : '',
    																'SP_Layout__c'		=>	'M',
    																'Use_Supp_Tax__c'	=>	'Y'
    															};
    	
    	// Assign billing address
    	if(supplier.BillingStreet != null){
    		supplierCard.put('Addr1_Line_1__c', supplier.BillingStreet.mid(0, 255));
    		
    		if(supplier.BillingStreet.length() > 255){
    			supplierCard.put('Addr1_Line_2__c', supplier.BillingStreet.mid(255, 510));
    		}
    	}
    	supplierCard.put('Addr1_City__c'	,	supplier.BillingCity);
    	supplierCard.put('Addr1_State__c'	,	supplier.BillingState);
    	supplierCard.put('Addr1_Postcode__c',	supplier.BillingPostalCode);
    	supplierCard.put('Addr1_Country__c'	,	supplier.BillingCountry);
    	
    	// Assign shipping address
    	if(supplier.ShippingStreet != null){
    		supplierCard.put('Addr2_Line_1__c', supplier.ShippingStreet.mid(0, 255));
    		
    		if(supplier.ShippingStreet.length() > 255){
    			supplierCard.put('Addr2_Line_2__c', supplier.ShippingStreet.mid(255, 510));
    		}
    	}
    	supplierCard.put('Addr2_City__c'	,	supplier.ShippingCity);
    	supplierCard.put('Addr2_State__c'	,	supplier.ShippingState);
    	supplierCard.put('Addr2_Postcode__c',	supplier.ShippingPostalCode);
    	supplierCard.put('Addr2_Country__c'	,	supplier.ShippingCountry);
    	
    	return supplierCard;
    }
    
    /**
     * Name: createImportableTextForVendors
     * Desc: Method to create a importable file ',' seperated text string for supplier card records
     * @param: Map<Integer, Map<String,String>> supplierCardRecords
     * @return: String
    **/
    private static String createImportableTextForVendors(Map<Integer, Map<String,String>> supplierCardRecords) {
    	String headerLengthRowString = '';
    	String headerRowString = '';
    	String contentsString = '';
    	
    	// Map of Supplier Card fields to Accounting software fields need to be mapped in generated synch file
    	Map<String, String> createVendorsCardSFFieldToAccountingFieldsMap = createVendorsCardSFFieldToAccountingFieldsMap();
    	
    	// Create file header with software supplier object fields
    	for(Integer indexVal : supplierCardRecords.keySet()){
    		Map<String, String> supplierCard = supplierCardRecords.get(indexVal);
    		
    		contentsString += '\n';
    		for(String supplierFieldSFName : supplierCard.keySet()){
    			// Populate 1st row for file which is for purpose of total object fields
	    		if(indexVal == 1){
	    			headerLengthRowString += (headerLengthRowString.length() == 0) ? '{}' : DataExportService.fileSeparator;
	    		}
	    		
	    		// Populate 2nd row for file which is for purpose of object fields display
	    		if(indexVal == 1){
	    			headerRowString += createVendorsCardSFFieldToAccountingFieldsMap.get(supplierFieldSFName) + DataExportService.fileSeparator;
	    		}
	    		
	    		// Now populate supplier records data text
	    		String value = (supplierCard.get(supplierFieldSFName) != null) ? supplierCard.get(supplierFieldSFName) : ' ';
	    		value = value.replace('\r\n', ' ');
				value = value.replace('\n', ' ');
				value = value.replace('\r', ' ');
	    		contentsString += value + DataExportService.fileSeparator;
    		}
    		contentsString = contentsString.subString(0, contentsString.length() - 1);
    	}
    	
    	return headerLengthRowString.subString(0, headerLengthRowString.length()-1) + '\n' 
    		   + headerRowString.subString(0, headerRowString.length()-1) 
    		   + contentsString;
    }
    
    /**
     * Name: createVendorsCardSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Supplier card Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createVendorsCardSFFieldToAccountingFieldsMap() {
    	Map<String, String> createVendorsCardSFFieldToAccountingFieldsMap = new Map<String, String>{	 'Last_Name__c'		=>	'Co./Last Name',
    																									 'Card_Id__c'		=>	'Card ID',
				    																					 'Addr1_Line_1__c'	=>	'Addr 1 - Line 1',
				    																					 'Addr1_Line_2__c'	=>	'Addr 1 - Line 2',
				    																					 'Addr1_City__c'	=>	'Addr 1 - City',
				    																					 'Addr1_State__c'	=>	'Addr 1 - State',
				    																					 'Addr1_Postcode__c'=>	'Addr 1 - Postcode',
				    																					 'Addr1_Country__c'	=>	'Addr 1 - Country',
				    																					 'Phone_No_1__c'	=>	'Addr 1 - Phone No. 1',
				    																					 'Phone_No_2__c'	=>	'Addr 1 - Phone No. 2',
				    																					 'Fax_No__c'		=>	'Addr 1 - Fax No.',
				    																					 'Email__c'			=>	'Addr 1 - Email',
				    																					 'WWW__c'			=>	'Addr 1 - WWW',
				    																					 'Addr2_Line_1__c'	=>	'Addr 2 - Line 1',
				    																					 'Addr2_Line_2__c'	=>	'Addr 2 - Line 2',
				    																					 'Addr2_City__c'	=>	'Addr 2 - City',
				    																					 'Addr2_State__c'	=>	'Addr 2 - State',
				    																					 'Addr2_Postcode__c'=>	'Addr 2 - Postcode',
				    																					 'Addr2_Country__c'	=>	'Addr 2 - Country',
				    																					 'Tax_Code__c'		=>	'Tax Code',
				    																					 'SP_Layout__c'		=>	'Sales/Purchase Layout',
				    																					 'Use_Supp_Tax__c'	=>	'Use Supplier\'s Tax Code'
				    																				};
    	
    	return createVendorsCardSFFieldToAccountingFieldsMap;
    }
}