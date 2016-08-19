/**
 * Author: Ashish Garg
 * Since: Dec. 23, 2015
 * Name: AccountingDataMigrationRMPayment
 * Description: Class is used for migration of Payment records to  Accounting Software
**/
global with sharing class AccountingDataMigrationRMPayment implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "ReceiveMoneyTxn_Payment" object name
	public static final String PAYMENT_ACCOUNTING_OBJECT_NAME = 'ReceiveMoneyTxn_Payment';
	
	// Batch size
	private static final Integer BATCH_SIZE = 1000;
	
	// Data string for all exporatble customers data
	private String paymentsTextData;
	
	// Get the "Customer card" record from Accounting Data Migration object
    private	Accounting_Data_Migration__c dataMigration;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Map to hold GL Account type to GL Account record
	private Map<String, String> paymentToGLAccountMap;
	
	// Index value to maintain total records count
	private integer indexVal;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	/**
     * Name: AccountingDataMigrationRMPayment
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationRMPayment(List<Id> recordIds, boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		paymentsTextData = '';
		indexVal = 1;
		
		// GL Accounts for payment
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		
		paymentToGLAccountMap = new Map<String, String>();
    	List<GL_Account__c> glAccounts = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c Where Type__c LIKE 'Deposit%'];
    	for(GL_Account__c glAcc : glAccounts){
    		paymentToGLAccountMap.put(glAcc.Type__c, glAcc.MYOB_Account_Number__c);
    	}
    	
    	try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: PAYMENT_ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationRMPayment.PAYMENT_ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter Accounts data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	
    	if(AccessControl.ifObjectFieldIsAccessible('CO_Invoice_Payment__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: executePaymentsDataMigrationBatch
     * Desc: Method to initiate the payments export
     * @param: 
     * @return: Id
    **/
	public static Id executePaymentsDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationRMPayment(recordIds, exportAllData), batchSize);
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
		List<CO_Invoice_Payment__c> coDeposits = (List<CO_Invoice_Payment__c>) scope;
		
		if(coDeposits.size() > 0){
	    	// Map of ReceiveMoneyTxn records for all applicable saleforce CODeposit records (a map of CODeposit sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> coDepositRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// For each co payment account, create a ReceiveMoneyTxn entry:
	    	for(CO_Invoice_Payment__c coInvoicePayment : coDeposits){
	    		coDepositRecords.put(indexVal, createReceiveMoneyTxnRecordFromPayment(coInvoicePayment) );
	    		coDepositRecords.put(++indexVal, createReverseReceiveMoneyTxnRecordFromPayment(coInvoicePayment) );
	    		coDepositRecords.put(++indexVal, new Map<String,String>() );		// Add empty record to provide a empty line
	    		indexVal++;
	    	}
	    	
	    	// Now create a string for list of ReceiveMoneyTxn records so as to convert in format of importable text file for accounting software
    		paymentsTextData += createImportableTextForCODeposits(coDepositRecords);
    		paymentsTextData = (paymentsTextData.indexOf('{') != -1) ? paymentsTextData.subString(paymentsTextData.indexOf('{')) : paymentsTextData;
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
    	
    	// Update the data migration record with time instance value
    	upsert dataMigration;
    	
		attachment.Body = Blob.valueOf(paymentsTextData);
    	attachment.Name = 'RECEIVEMONEY_PAYMENT_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	insert attachment;
    	
    	// Execute next batch
    	if(exportAllData){
    		AccountingDataMigrationSalesInvoice.executeDataMigrationBatch(200, null, exportAllData);
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for coInvoicePayment orders
     * @param: 
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all coInvoicePayment accounts to be synched here
    	String coDepositQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, CreatedDate ';
    	
    	String customFieldsQuery = '';
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(Constants.NAMESPACE + 'CO_Invoice_Payment__c').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	customFieldsQuery += ', CO_Invoice_Header__r.CO_Header__r.Customer__r.Name, CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c, CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c, CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c';
    	customFieldsQuery += ', CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name, CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Rate__c';
    	
    	String whereCondition = ' WHERE Payment_Method__c != \'Deposit\' AND Amount__c != 0';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds; 
    	}
    	
    	coDepositQuery += standardFieldsQuery + customFieldsQuery + ' FROM CO_Invoice_Payment__c ' + whereCondition + ' ORDER BY Amount__c';
    	return coDepositQuery;
	}
    
    /**
     * Name: createReceiveMoneyTxnRecordFromPayment
     * Desc: Method to create a ReceiveMoneyTxn record by copayment record. ReceiveMoneyTxn record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Payment__c coInvoicePayment
     * @return: Map<String, String>
    **/
    private Map<String, String> createReceiveMoneyTxnRecordFromPayment(CO_Invoice_Payment__c coInvoicePayment) {
    	decimal taxAmount = (coInvoicePayment.Amount__c != null && coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Rate__c != null) ? (coInvoicePayment.Amount__c * coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Rate__c) : 0;
    	Map<String, String> receiveMoneyTxn = new Map<String, String>{	'Deposit_Account__c'		=>	(paymentToGLAccountMap.containsKey('Deposit Account')) ? paymentToGLAccountMap.get('Deposit Account') : '',
	    																'Amount__c'					=>	((coInvoicePayment.Amount__c < 0) ? '-': '') + '$' + ((coInvoicePayment.Amount__c < 0) ? (coInvoicePayment.Amount__c * -1).setScale(2) : coInvoicePayment.Amount__c.setScale(2)),
	    																'Date__c'					=>	coInvoicePayment.CreatedDate.format(DataExportService.dateFormat),
	    																'Memo__c'					=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ' - ' + coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c,
	    																'Last_Name__c'				=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c,
	    																'First_Name__c'				=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c,
	    																'Allocation_Account_No__c'	=>	(paymentToGLAccountMap.containsKey('Deposit Account')) ? paymentToGLAccountMap.get('Deposit Account') : '',
	    																'Tax_Code__c'				=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Sales_Tax__r.Name,
	    																'Tax_Amount__c'				=>	((taxAmount > 0) ? '$' : '-$') + ((taxAmount > 0) ? taxAmount.setScale(2) : (taxAmount * -1).setScale(2)),
	    																'Payment_Method__c'			=>	coInvoicePayment.Payment_Method__c,
	    																'Name_On_Card__c'			=>	'',
	    																'Card_ID__c'				=>	(coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c : ''
	    															};
    	// 'Deposit_Account__c'		=>	(coInvoicePayment.Amount__c > 0) ? paymentToGLAccountMap.get('Make Deposit') : paymentToGLAccountMap.get('Reverse Deposit'),
    	return receiveMoneyTxn;
    }
    
    /**
     * Name: createReverseReceiveMoneyTxnRecordFromPayment
     * Desc: Method to create a Reverse ReceiveMoneyTxn record by copayment record. ReceiveMoneyTxn record is a map of field name to equivalent value for field
     * @param: CO_Invoice_Payment__c coInvoicePayment
     * @return: Map<String, String>
    **/
    private Map<String, String> createReverseReceiveMoneyTxnRecordFromPayment(CO_Invoice_Payment__c coInvoicePayment) {
    	Map<String, String> receiveMoneyTxn = new Map<String, String>{	'Deposit_Account__c'		=>	(paymentToGLAccountMap.containsKey('Deposit Allocation Account')) ? paymentToGLAccountMap.get('Deposit Allocation Account') : '',
	    																'Amount__c'					=>	((coInvoicePayment.Amount__c < 0) ? '-': '') + '$' + ((coInvoicePayment.Amount__c < 0) ? (coInvoicePayment.Amount__c * -1).setScale(2) : coInvoicePayment.Amount__c.setScale(2)),
	    																'Date__c'					=>	coInvoicePayment.CreatedDate.format(DataExportService.dateFormat),
	    																'Memo__c'					=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Name + ' - ' + coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c,
	    																'Last_Name__c'				=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.LastName__c,
	    																'First_Name__c'				=>	coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.FirstName__c,
	    																'Allocation_Account_No__c'	=>	(paymentToGLAccountMap.containsKey('Deposit Allocation Account')) ? paymentToGLAccountMap.get('Deposit Allocation Account') : '',
	    																'Tax_Code__c'				=>	'N-T',
	    																'Tax_Amount__c'				=>	'$0.00',
	    																'Payment_Method__c'			=>	coInvoicePayment.Payment_Method__c,
	    																'Name_On_Card__c'			=>	'',
	    																'Card_ID__c'				=>	(coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r != null) ? coInvoicePayment.CO_Invoice_Header__r.CO_Header__r.Customer__r.Customer_Number__c : ''
	    															};
    	// 'Deposit_Account__c'		=>	(coInvoicePayment.Amount__c > 0) ? paymentToGLAccountMap.get('Make Deposit') : paymentToGLAccountMap.get('Reverse Deposit'),
    	return receiveMoneyTxn;
    }
    
    /**
     * Name: createImportableTextForCODeposits
     * Desc: Method to create a importable file ',' seperated text string for ReceiveMoneyTxn records
     * @param: Map<Integer, Map<String,String>> receiveMoneyTxnRecords
     * @return: String
    **/
    private String createImportableTextForCODeposits(Map<Integer, Map<String,String>> receiveMoneyTxnRecords) {
    	String headerLengthRowString = '';
    	String headerRowString = '';
    	String contentsString = '';
    	
    	// Map of Customer Card fields to Accounting software fields need to be mapped in generated synch file
    	Map<String, String> createReceiveMoneyTxnSFFieldToAccountingFieldsMap = createReceiveMoneyTxnSFFieldToAccountingFieldsMap();
    	
    	// Create file header with software coInvoicePayment object fields
    	for(Integer indexVal : receiveMoneyTxnRecords.keySet()){
    		Map<String, String> receiveMoneyTxn = receiveMoneyTxnRecords.get(indexVal);
    		
    		contentsString += '\n';
    		if(receiveMoneyTxn.size() > 0){
	    		for(String receiveMoneyTxnFieldSFName : receiveMoneyTxn.keySet()){
	    			// Populate 1st row for file which is for purpose of total object fields
		    		if(indexVal == 1){
		    			headerLengthRowString += (headerLengthRowString.length() == 0) ? '{}' : DataExportService.fileSeparator;
		    		}
		    		
		    		// Populate 2nd row for file which is for purpose of object fields display
		    		if(indexVal == 1){
		    			headerRowString += createReceiveMoneyTxnSFFieldToAccountingFieldsMap.get(receiveMoneyTxnFieldSFName) + DataExportService.fileSeparator;
		    		}
		    		
		    		// Now populate coInvoicePayment records data text
		    		String value = (receiveMoneyTxn.get(receiveMoneyTxnFieldSFName) != null) ? receiveMoneyTxn.get(receiveMoneyTxnFieldSFName) : '';
		    		value = value.replace('\r\n', ' ');
					value = value.replace('\n', ' ');
					value = value.replace('\r', ' ');
		    		contentsString += value + DataExportService.fileSeparator;
	    		}
	    		contentsString = contentsString.subString(0, contentsString.length() - 1);
    		}
    	}
    	
    	return headerLengthRowString.subString(0, headerLengthRowString.length()-1) + '\n' 
    		   + headerRowString.subString(0, headerRowString.length()-1) 
    		   + contentsString;
    }
    
    /**
     * Name: createReceiveMoneyTxnSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Customer card Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private Map<String, String> createReceiveMoneyTxnSFFieldToAccountingFieldsMap() {
    	Map<String, String> createReceiveMoneyTxnSFFieldToAccountingFieldsMap = new Map<String, String>{ 'Deposit_Account__c'		=>	'Deposit Account',
				    																					 'Date__c'					=>	'Date',
				    																					 'Last_Name__c'				=>	'Co./Last Name',
				    																					 'First_Name__c'			=>	'First Name',
				    																					 'Memo__c'					=>	'Memo',
				    																					 'Allocation_Account_No__c'	=>	'Allocation Account No.',
				    																					 'Amount__c'				=>	'Amount',
				    																					 'Tax_Code__c'				=>	'Tax Code',
				    																					 'Tax_Amount__c'			=>	'Tax Amount',
				    																					 'Payment_Method__c'		=>	'Payment Method',
				    																					 'Name_On_Card__c'			=>	'Name On Card',
				    																					 'Card_ID__c'				=>	'Card ID'
				    																					};
    	
    	return createReceiveMoneyTxnSFFieldToAccountingFieldsMap;
    }
}