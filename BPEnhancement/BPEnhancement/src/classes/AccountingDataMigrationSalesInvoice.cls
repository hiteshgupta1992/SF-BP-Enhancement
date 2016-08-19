/**
 * Author: Ashish Garg
 * Since: Dec. 18, 2015
 * Name: AccountingDataMigrationSalesInvoice
 * Description: Class is used for migration of Sales Invoice (Customer Order Invoice) records to  Accounting Software
**/
global with sharing class AccountingDataMigrationSalesInvoice implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "MiscellaneousSales" object name
	public static final String ACCOUNTING_OBJECT_NAME = 'Customer Order Sales Invoices';
	
	// Batch size
	private static final Integer BATCH_SIZE = 200;
	
	// Data string for all MiscellaneousSales exporatble data
	private String miscSalesExportTextData;
	
	// Index value to maintain total records count for MiscellaneousSales
	private integer miscSalesIndexVal;
	
	// Data string for all Payment Invoice exporatble data
	private String invoicePaymentExportTextData;
	
	// Index value to maintain total records count for Payment Invoice
	private integer invoicePaymentIndexVal;
	
	// Data string for all Inventory GL exporatble data
	private String inventoryGLExportTextData;
	
	// Index value to maintain total records count for Inventory GL
	private integer inventoryGLIndexVal;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Accounting Data Migration object
	private Accounting_Data_Migration__c dataMigration;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	/**
     * Name: AccountingDataMigrationSalesInvoice
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationSalesInvoice(List<Id> recordIds, boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		miscSalesExportTextData = '';
		miscSalesIndexVal = 0;
		
		invoicePaymentExportTextData = '';
		invoicePaymentIndexVal = 1;
		
		inventoryGLExportTextData = '';
		inventoryGLIndexVal = 0;
		
		// Get the Accounting Data Migration object record
    	try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationSalesInvoice.ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	
		if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: executeDataMigrationBatch
     * Desc: Method to initiate the coInvoiceItems export
     * @param: 
     * @return: Id
    **/
	public static Id executeDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationSalesInvoice(recordIds, exportAllData), batchSize);
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
		List<CO_Invoice_Item__c> coInvoiceItemsList = (List<CO_Invoice_Item__c>) scope;
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(coInvoiceItemsList.size() > 0){
	    	// Map of MiscellaneousSales records for all applicable saleforce CODeposit records (a map of CODeposit sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> coDepositRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// GL Accounts for coInvoiceItem
	    	List<GL_Account__c> glAccounts = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c Where Type__c = 'Deposit Account'];
	    	Map<String, String> coInvoiceItemToGLAccountMap = new Map<String, String>();
	    	for(GL_Account__c glAcc : glAccounts){
	    		coInvoiceItemToGLAccountMap.put(glAcc.Type__c, glAcc.MYOB_Account_Number__c);
	    	}
	    	
	    	// Map of MiscellaneousSales fields to Accounting software fields need to be mapped in generated synch file
    		Map<String, String> miscellaneousSalesSFFieldToAccountingFieldsMap = createMiscellaneousSalesSFFieldToAccountingFieldsMap();
    		
    		// Map of Invoice Payment fields to Accounting software fields need to be mapped in generated synch file
    		Map<String, String> invoicePaymentSFFieldToAccountingFieldsMap = createInvoicePaymentSFFieldToAccountingFieldsMap();
	    	
	    	// Map of Inventory GL fields to Accounting software fields need to be mapped in generated synch file
    		Map<String, String> inventoryGLSFFieldToAccountingFieldsMap = createInventoryGLSFFieldToAccountingFieldsMap();
    		
    		// Map of COGS GL fields to Accounting software fields need to be mapped in generated synch file
    		Map<String, String> COGSGLSFFieldToAccountingFieldsMap = createCOGSGLSFFieldToAccountingFieldsMap();
    		
	    	// For each co coInvoiceItem account, create a MiscellaneousSales entry:
	    	String lastInvoiceHeaderName = '';
	    	decimal totalInvoicePaymentForSingleInvoiceHeader = 0;
	    	
	    	Integer loopIndex = 0;
	    	for(CO_Invoice_Item__c coInvoiceItem : coInvoiceItemsList){
	    		loopIndex++;
	    		//---- START: Create a string for list of MiscellaneousSales records so as to convert in format of importable text file for accounting software ----//
		    		// Process to include new line for new invoice included
		    		if(lastInvoiceHeaderName != coInvoiceItem.CO_Invoice_Header__r.Name){
		    			miscSalesExportTextData += createImportableTextForInvoiceItemRecord(miscSalesIndexVal++, 
		    																				new Map<String, String>(),
		    																				miscellaneousSalesSFFieldToAccountingFieldsMap
		    																			);
		    		}
		    		
		    		// Add the data for a record in export text string
		    		miscSalesExportTextData += createImportableTextForInvoiceItemRecord(miscSalesIndexVal++, 
		    																			createMiscellaneousSalesRecordFromInvoiceItem(coInvoiceItem),
		    																			miscellaneousSalesSFFieldToAccountingFieldsMap
		    																		);
	    		//---- END: Create a string for list of MiscellaneousSales records so as to convert in format of importable text file for accounting software ----//
	    		
	    		//---- START: Create a string for list of Invoice Payment records so as to convert in format of importable text file for accounting software ----//
		    		totalInvoicePaymentForSingleInvoiceHeader += coInvoiceItem.Price__c * coInvoiceItem.Qty__c;
		    		if((lastInvoiceHeaderName != '' && lastInvoiceHeaderName != coInvoiceItem.CO_Invoice_Header__r.Name) || (loopIndex == coInvoiceItemsList.size() && totalInvoicePaymentForSingleInvoiceHeader != 0)){
		    			invoicePaymentExportTextData += createImportableTextForInvoiceItemRecord(invoicePaymentIndexVal++, 
				    																			 createInvoicePaymentRecordFromInvoiceItem(coInvoiceItem, coInvoiceItemToGLAccountMap, totalInvoicePaymentForSingleInvoiceHeader),
				    																			 invoicePaymentSFFieldToAccountingFieldsMap
				    																			);
		    			totalInvoicePaymentForSingleInvoiceHeader = 0;
		    		}
	    		//---- END: Create a string for list of Invoice Payment records so as to convert in format of importable text file for accounting software ----//
	    		
	    		//---- START: Create a string for list of Inventory GL records so as to convert in format of importable text file for accounting software ----//
		    		// Process to include new line for new invoice included
		    		if(lastInvoiceHeaderName != coInvoiceItem.CO_Invoice_Header__r.Name){
		    			inventoryGLExportTextData += createImportableTextForInvoiceItemRecord(inventoryGLIndexVal++, 
		    																				  new Map<String, String>(),
		    																				  inventoryGLSFFieldToAccountingFieldsMap
		    																				);
		    		}
		    		
		    		// Add the data for a record in export text string
		    		inventoryGLExportTextData += createImportableTextForInvoiceItemRecord(inventoryGLIndexVal++, 
		    																			  createInventoryGLRecordFromInvoiceItem(coInvoiceItem),
		    																			  inventoryGLSFFieldToAccountingFieldsMap
		    																			);
	    		//---- END: Create a string for list of Inventory GL records so as to convert in format of importable text file for accounting software ----//
	    		
	    		//---- START: Create a string for list of COGS GL records so as to convert in format of importable text file for accounting software ----//
	    			// Add the data for a record in export text string
		    		inventoryGLExportTextData += createImportableTextForInvoiceItemRecord(inventoryGLIndexVal++, 
			    																		  createCOGSGLRecordFromInvoiceItem(coInvoiceItem),
			    																		  COGSGLSFFieldToAccountingFieldsMap
			    																		);
	    		//---- END: Create a string for list of COGS GL records so as to convert in format of importable text file for accounting software ----//
	    		
	    		if(lastInvoiceHeaderName != coInvoiceItem.CO_Invoice_Header__r.Name){
	    			lastInvoiceHeaderName = coInvoiceItem.CO_Invoice_Header__r.Name;
	    		}
	    	}
	    	
	    	miscSalesExportTextData = (miscSalesExportTextData.indexOf('{') != -1) ? miscSalesExportTextData.subString(miscSalesExportTextData.indexOf('{')) : miscSalesExportTextData;
	    	invoicePaymentExportTextData = (invoicePaymentExportTextData.indexOf('{') != -1) ? invoicePaymentExportTextData.subString(invoicePaymentExportTextData.indexOf('{')) : invoicePaymentExportTextData;
	    	inventoryGLExportTextData = (inventoryGLExportTextData.indexOf('{') != -1) ? inventoryGLExportTextData.subString(inventoryGLExportTextData.indexOf('{')) : inventoryGLExportTextData;
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
		
		List<Attachment> attachmentsList = new List<Attachment>();
    	String fileName = '';
    	
    	// Update the data migration record
    	upsert dataMigration;
    	
    	// Insert export file for MiscellaneousSales
		Attachment attachment = new Attachment();
		attachment.Body = Blob.valueOf(miscSalesExportTextData);
    	attachment.Name = 'MISCSALE_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	attachmentsList.add(attachment);
    	
    	// Insert export file for Invoice Payment
		attachment = new Attachment();
		attachment.Body = Blob.valueOf(invoicePaymentExportTextData);
    	attachment.Name = 'INVOICE_PAYMENT_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	attachmentsList.add(attachment);
    	
    	// Insert export file for Inventory GL
		attachment = new Attachment();
		attachment.Body = Blob.valueOf(inventoryGLExportTextData);
    	attachment.Name = 'INVENTORY_GL_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	attachmentsList.add(attachment);
    	
    	if(attachmentsList.size() > 0){
    		insert attachmentsList;
    	}
    	
    	// Execute next batch
    	if(exportAllData){
    		AccountingDataMigrationvendorReceiving.executeDataMigrationBatch(200, null, exportAllData);
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for coInvoiceItem orders
     * @param: 
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all coInvoiceItem accounts to be synched here
    	String coDepositQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, CreatedDate ';
    	
    	String customFieldsQuery = '';
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(Constants.NAMESPACE + 'CO_Invoice_Item__c').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	customFieldsQuery += ', CO_Invoice_Header__r.Name, CO_Invoice_Header__r.Invoice_Status__c, CO_Invoice_Header__r.Invoice_Date__c, CO_Invoice_Header__r.CO_Header__r.Name, CO_Invoice_Header__r.CO_Header__r.Customer__r.Name, CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c, CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c, CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c';
    	customFieldsQuery += ', CO_Line_Item__r.Tax__c, CO_Line_Item__r.Part__r.Part_Number__c, CO_Line_Item__r.Part__r.Description__c, CO_Line_Item__r.Part__r.Last_Cost__c, CO_Line_Item__r.CO_Header__r.Name';
    	customFieldsQuery += ', CO_Line_Item__r.Part__r.Category__r.COGS_GL__c, CO_Line_Item__r.Part__r.Category__r.Income_GL__c, CO_Line_Item__r.Part__r.Category__r.Inventory_GL__c';
    	customFieldsQuery += ', CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name__c';
    	
    	String whereCondition = ' WHERE Price__c != 0 AND Qty__c != 0';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds;
    	}
    	
    	coDepositQuery += standardFieldsQuery + customFieldsQuery + ' FROM CO_Invoice_Item__c ' + whereCondition + ' ORDER BY CO_Invoice_Header__r.Name';
    	return coDepositQuery;
	}
    
    /**
     * Name: createImportableTextForInvoiceItemRecord
     * Desc: Method to create a importable file ',' seperated text string for MiscellaneousSales records
     * @param:	1) Integer indexVal
     *			2) Map<String,String> miscSales
     *			3) Map<String, String> invoiceItemSFFieldToAccountingFieldsMap
     * @return: String
    **/
    private static String createImportableTextForInvoiceItemRecord(Integer indexVal, 
    															 Map<String,String> invoiceItemRecord, 
    															 Map<String, String> invoiceItemSFFieldToAccountingFieldsMap
    															){
    	String headerLengthRowString = '';
    	String headerRowString = '';
    	String contentsString = '';
    	contentsString += '\n';
    	
    	// Create file header with software coInvoiceItem object fields
		if(invoiceItemRecord.size() > 0){
    		for(String invoiceItemFieldSFName : invoiceItemRecord.keySet()){
    			// Populate 1st row for file which is for purpose of total object fields
	    		if(indexVal == 1){
	    			headerLengthRowString += (headerLengthRowString.length() == 0) ? '{}' : DataExportService.fileSeparator;
	    		}
	    		
	    		// Populate 2nd row for file which is for purpose of object fields display
	    		if(indexVal == 1){
	    			headerRowString += invoiceItemSFFieldToAccountingFieldsMap.get(invoiceItemFieldSFName) + DataExportService.fileSeparator;
	    		}
	    		
	    		// Now populate coInvoiceItem records data text
	    		String value = (invoiceItemRecord.get(invoiceItemFieldSFName) != null) ? invoiceItemRecord.get(invoiceItemFieldSFName) : '';
	    		value = value.replace('\r\n', ' ');
				value = value.replace('\n', ' ');
				value = value.replace('\r', ' ');
	    		contentsString += value + DataExportService.fileSeparator;
    		}
    		
    		headerLengthRowString = (indexVal == 1) ? headerLengthRowString.subString(0, headerLengthRowString.length()-1) + '\n' : headerLengthRowString;
    		headerRowString = (indexVal == 1) ? headerRowString.subString(0, headerRowString.length()-1) : headerRowString;
    		contentsString = contentsString.subString(0, contentsString.length() - 1);
		}
    	
    	return headerLengthRowString + headerRowString + contentsString;
    }
    
    /**
     * Name: createMiscellaneousSalesSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of MiscellaneousSales Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createMiscellaneousSalesSFFieldToAccountingFieldsMap() {
    	Map<String, String> miscellaneousSalesSFFieldToAccountingFieldsMap = new Map<String, String>{'Last_Name__c'			=>	'Co./Last Name',
																								 	 'First_Name__c'		=>	'First Name',
																								 	 'Invoice_No__c'		=>	'Invoice No.',
																									 'Date__c'				=>	'Date',
																									 'Inclusive__c'			=>	'Inclusive',
																									 'Memo__c'				=>	'Memo',
																									 'Description__c'		=>	'Description',
																									 'Account_No__c'		=>	'Account No.',
																									 'Amount__c'			=>	'Amount',
																									 'Tax_Code__c'			=>	'Tax Code',
																									 'Tax_Amount__c'		=>	'Tax Amount',
			    																					 'Card_ID__c'			=>	'Card ID'
			    																				};
    	
    	return miscellaneousSalesSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createMiscellaneousSalesRecordFromInvoiceItem
     * Desc: Method to create a MiscellaneousSales record by cocoInvoiceItem record. MiscellaneousSales record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Item__c coInvoiceItem, Map<String, String> coInvoiceItemToGLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createMiscellaneousSalesRecordFromInvoiceItem(CO_Invoice_Item__c coInvoiceItem) {
    	decimal taxAmount = (coInvoiceItem.Price__c != null && coInvoiceItem.Qty__c != null && coInvoiceItem.CO_Line_Item__r.Tax__c != null) ? coInvoiceItem.Price__c * coInvoiceItem.Qty__c * coInvoiceItem.CO_Line_Item__r.Tax__c / 100 : 0;
    	Map<String, String> miscSales = new Map<String, String>{'Last_Name__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c,
    															'First_Name__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c,
    															'Invoice_No__c'		=>	coInvoiceItem.CO_Invoice_Header__r.Name,
    															'Date__c'			=>	(coInvoiceItem.CO_Invoice_Header__r.Invoice_Status__c == 'Closed') ? coInvoiceItem.CO_Invoice_Header__r.Invoice_Date__c.format(DataExportService.dateFormat) : coInvoiceItem.CreatedDate.format(DataExportService.dateFormat),
    															'Inclusive__c'		=>	'',
    															'Memo__c'			=>	((coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? (coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ';') : '') + coInvoiceItem.CO_Line_Item__r.CO_Header__r.Name + ';Invoice',
    															'Description__c'	=>	coInvoiceItem.CO_Line_Item__r.Part__r.Part_Number__c + '-' + coInvoiceItem.CO_Line_Item__r.Part__r.Description__c + ' ' + coInvoiceItem.Qty__c + '@$' + coInvoiceItem.Price__c,
    															'Account_No__c'		=>	(coInvoiceItem.CO_Line_Item__r.Part__r.Category__r != null && coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.Income_GL__c != null) ? coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.Income_GL__c : '',
	    														'Amount__c'			=>	((coInvoiceItem.Price__c < 0) ? '-': '') + '$' + ((coInvoiceItem.Price__c < 0) ? (coInvoiceItem.Price__c * -1 * coInvoiceItem.Qty__c).setScale(2) : (coInvoiceItem.Price__c * coInvoiceItem.Qty__c).setScale(2)),
																'Tax_Code__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name__c,
																'Tax_Amount__c'		=>	((taxAmount >= 0) ? '$' : '-$') + ((taxAmount >= 0) ? taxAmount.setScale(2) : (taxAmount * -1).setScale(2)),
																'Card_ID__c'		=>	(coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c : ''
															};
    	return miscSales;
    }
    
    /**
     * Name: createInvoicePaymentSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Invoice Payment Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createInvoicePaymentSFFieldToAccountingFieldsMap() {
    	Map<String, String> invoicePaymentSFFieldToAccountingFieldsMap = new Map<String, String>{'Last_Name__c'			=>	'Co./Last Name',
																							 	 'First_Name__c'		=>	'First Name',
																							 	 'Account_No__c'		=>	'Deposit Account No.',
																							 	 'Id_No__c'				=>	'ID No.',
																								 'Date__c'				=>	'Receipt Date',
																								 'Invoice_No__c'		=>	'Invoice No.',
																								 'Amount__c'			=>	'Amount Applied',
																								 'Memo__c'				=>	'Memo',
		    																					 'Card_ID__c'			=>	'Card ID'
		    																					};
    	
    	return invoicePaymentSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createInvoicePaymentRecordFromInvoiceItem
     * Desc: Method to create a Invoice Payment record by cocoInvoiceItem record. Invoice Payment record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Item__c coInvoiceItem, Map<String, String> coInvoiceItemToGLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createInvoicePaymentRecordFromInvoiceItem(CO_Invoice_Item__c coInvoiceItem, 
    																			 Map<String, String> coInvoiceItemToGLAccountMap,
    																			 decimal amount
    																			) {
    	Map<String, String> invoicePaymentRecord = new Map<String, String>{	'Last_Name__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c,
    																		'First_Name__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c,
    																		'Account_No__c'		=>	(coInvoiceItemToGLAccountMap.containsKey('Deposit Account')) ? coInvoiceItemToGLAccountMap.get('Deposit Account') : '',
				    														'Id_No__c'			=>	coInvoiceItem.CO_Invoice_Header__r.Name.replace('INV', 'P'),
				    														'Date__c'			=>	(coInvoiceItem.CO_Invoice_Header__r.Invoice_Status__c == 'Closed') ? coInvoiceItem.CO_Invoice_Header__r.Invoice_Date__c.format(DataExportService.dateFormat) : coInvoiceItem.CreatedDate.format(DataExportService.dateFormat),
				    														'Invoice_No__c'		=>	coInvoiceItem.CO_Invoice_Header__r.Name,
				    														'Amount__c'			=>	((amount < 0) ? '-': '') + '$' + ((amount < 0) ? (amount * -1).setScale(2) : amount.setScale(2)),
																			'Memo__c'			=>	((coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? (coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ';') : '') + coInvoiceItem.CO_Invoice_Header__r.Name + ';Payment',
																			'Card_ID__c'		=>	(coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c : ''
																		};
    	return invoicePaymentRecord;
    }
    
    /**
     * Name: createInventoryGLSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Inventory GL Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createInventoryGLSFFieldToAccountingFieldsMap() {
    	Map<String, String> inventoryGLSFFieldToAccountingFieldsMap = new Map<String, String>{'Journal_Number__c'	=>	'Journal Number',
    																						  'Date__c'				=>	'Date',
    																						  'Memo__c'				=>	'Memo',
    																						  'Reporting__c'		=>	'GST (BAS) Reporting',
    																						  'Inclusive__c'		=>	'Inclusive',
																							  'Account_No__c'		=>	'Account Number',
																							  'Amount__c'			=>	'Amount',
																							  'Is_Credit__c'		=>	'Is Credit',
																							  'Tax_Code__c'			=>	'Tax Code',
																							  'Allocation_Memo__c'	=>	'Allocation Memo'
		    																				};
    	
    	return inventoryGLSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createInventoryGLRecordFromInvoiceItem
     * Desc: Method to create a Inventory GL record by cocoInvoiceItem record. Invoice Payment record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Item__c coInvoiceItem, Map<String, String> coInvoiceItemToGLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createInventoryGLRecordFromInvoiceItem(CO_Invoice_Item__c coInvoiceItem) {
    	Map<String, String> inventoryGLRecord = new Map<String, String>{'Journal_Number__c'	=>	coInvoiceItem.CO_Invoice_Header__r.Name.replace('INV-', ''),
    																	'Date__c'			=>	(coInvoiceItem.CO_Invoice_Header__r.Invoice_Status__c == 'Closed') ? coInvoiceItem.CO_Invoice_Header__r.Invoice_Date__c.format(DataExportService.dateFormat) : coInvoiceItem.CreatedDate.format(DataExportService.dateFormat),
    																	'Memo__c'			=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ';' + coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Name + ';Costing',
    																	'Reporting__c'		=>	'S',
    																	'Inclusive__c'		=>	'X',
																		'Account_No__c'		=>	(coInvoiceItem.CO_Line_Item__r.Part__r.Category__r != null && coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.Inventory_GL__c != null) ? coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.Inventory_GL__c : '',
			    														'Amount__c'			=>	((coInvoiceItem.Price__c < 0) ? '-': '') + '$' + ((coInvoiceItem.Price__c < 0) ? (coInvoiceItem.Price__c * -1 * coInvoiceItem.Qty__c).setScale(2) : (coInvoiceItem.Price__c * coInvoiceItem.Qty__c).setScale(2)),
			    														'Is_Credit__c'		=>	(coInvoiceItem.Qty__c > 0) ? 'Y' : 'N',
			    														'Tax_Code__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name__c,
																		'Allocation_Memo__c'=>	coInvoiceItem.CO_Line_Item__r.Part__r.Part_Number__c + ' - ' + coInvoiceItem.CO_Line_Item__r.Part__r.Description__c + ' ' + coInvoiceItem.Qty__c + '@$' + coInvoiceItem.CO_Line_Item__r.Part__r.Last_Cost__c
																	};
    	return inventoryGLRecord;
    }
    
    /**
     * Name: createCOGSGLSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of COGS GL Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createCOGSGLSFFieldToAccountingFieldsMap() {
    	Map<String, String> COGSGLSFFieldToAccountingFieldsMap = new Map<String, String>{ 'Journal_Number__c'	=>	'Journal Number',
																						  'Date__c'				=>	'Date',
																						  'Memo__c'				=>	'Memo',
																						  'Reporting__c'		=>	'GST (BAS) Reporting',
																						  'Inclusive__c'		=>	'Inclusive',
																						  'Account_No__c'		=>	'Account Number',
																						  'Amount__c'			=>	'Amount',
																						  'Is_Credit__c'		=>	'Is Credit',
																						  'Tax_Code__c'			=>	'Tax Code',
																						  'Allocation_Memo__c'	=>	'Allocation Memo'
	    																				};
    	
    	return COGSGLSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createCOGSGLRecordFromInvoiceItem
     * Desc: Method to create a Inventory GL record by cocoInvoiceItem record. Invoice Payment record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Item__c coInvoiceItem, Map<String, String> coInvoiceItemToGLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createCOGSGLRecordFromInvoiceItem(CO_Invoice_Item__c coInvoiceItem) {
    	Map<String, String> COGSGLRecord = new Map<String, String>{ 'Journal_Number__c'	=>	coInvoiceItem.CO_Invoice_Header__r.Name.replace('INV-', ''),
																	'Date__c'			=>	(coInvoiceItem.CO_Invoice_Header__r.Invoice_Status__c == 'Closed') ? coInvoiceItem.CO_Invoice_Header__r.Invoice_Date__c.format(DataExportService.dateFormat) : coInvoiceItem.CreatedDate.format(DataExportService.dateFormat),
																	'Memo__c'			=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ';' + coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Name + ';Costing',
																	'Reporting__c'		=>	'S',
																	'Inclusive__c'		=>	'X',
																	'Account_No__c'		=>	(coInvoiceItem.CO_Line_Item__r.Part__r.Category__r != null && coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.COGS_GL__c != null) ? coInvoiceItem.CO_Line_Item__r.Part__r.Category__r.COGS_GL__c : '',
		    														'Amount__c'			=>	((coInvoiceItem.Price__c < 0) ? '-': '') + '$' + ((coInvoiceItem.Price__c < 0) ? (coInvoiceItem.Price__c * -1 * coInvoiceItem.Qty__c).setScale(2) : (coInvoiceItem.Price__c * coInvoiceItem.Qty__c).setScale(2)),
		    														'Is_Credit__c'		=>	(coInvoiceItem.Qty__c > 0) ? 'N' : 'Y',
		    														'Tax_Code__c'		=>	coInvoiceItem.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name__c,
																	'Allocation_Memo__c'=>	coInvoiceItem.CO_Line_Item__r.Part__r.Part_Number__c + ' - ' + coInvoiceItem.CO_Line_Item__r.Part__r.Description__c + ' ' + coInvoiceItem.Qty__c + '@$' + coInvoiceItem.CO_Line_Item__r.Part__r.Last_Cost__c
																};
    	return COGSGLRecord;
    }
}