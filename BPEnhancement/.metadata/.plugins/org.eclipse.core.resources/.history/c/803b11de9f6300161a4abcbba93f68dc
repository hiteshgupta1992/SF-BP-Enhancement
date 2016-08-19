/**
 * Author: Ashish Garg
 * Since: Jan. 13, 2015
 * Name: AccountingDataMigrationVendorInvoice
 * Description: Class is used for migration of Vendor Invoice (Vendor Order Invoice) records to  Accounting Software
**/
global with sharing class AccountingDataMigrationVendorInvoice implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "MiscellaneousPurchases" object name
	public static final String ACCOUNTING_OBJECT_NAME = 'Vendor Invoicing';
	
	// Batch size
	private static final Integer BATCH_SIZE = 200;
	
	// Data string for all MiscellaneousPurchases exporatble data
	private String miscPurchasesExportTextData;
	
	// Index value to maintain total records count for MiscellaneousPurchases
	private integer miscPurchasesIndexVal;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Accounting Data Migration object
	private Accounting_Data_Migration__c dataMigration;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	/**
     * Name: AccountingDataMigrationVendorInvoice
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationVendorInvoice(List<Id> recordIds, boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		miscPurchasesExportTextData = '';
		miscPurchasesIndexVal = 1;
		
		// Get the Accounting Data Migration object record
    	try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationVendorInvoice.ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	
		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: executeDataMigrationBatch
     * Desc: Method to initiate the coInvoiceItems export
     * @param:
     * @return: Id
    **/
	public static Id executeDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationVendorInvoice(recordIds, exportAllData), batchSize);
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
		List<Vendor_Invoicing_Group__c> voInvoiceList = (List<Vendor_Invoicing_Group__c>) scope;
		
		if(voInvoiceList.size() > 0){
	    	// Map of MiscellaneousPurchases records for all applicable saleforce VO Invoice records (a map of VO Invoice sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> voInvoiceRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// GL Accounts for voInvoice
	    	List<GL_Account__c> glAccounts = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c Where Type__c LIKE '%Inventory%'];
	    	Map<String, String> GLAccountMap = new Map<String, String>();
	    	for(GL_Account__c glAcc : glAccounts){
	    		GLAccountMap.put(glAcc.Type__c, glAcc.MYOB_Account_Number__c);
	    	}
	    	
	    	// Map of MiscellaneousPurchases fields to Accounting software fields need to be mapped in generated synch file
    		Map<String, String> miscellaneousPurchasesSFFieldToAccountingFieldsMap = createMiscellaneousPurchasesSFFieldToAccountingFieldsMap();
    		
	    	// For each co voInvoice account, create a MiscellaneousPurchases entry:
	    	String lastInvoiceNumber = '';
	    	Integer loopIndex = 0;
	    	
	    	for(Vendor_Invoicing_Group__c voInvoice : voInvoiceList){
	    		loopIndex++;
	    		decimal totalInvoicePayment = voInvoice.VI_SubTotal__c;
	    		decimal receivingGroupTotalAmount = 0;
	    		if(voInvoice.Vendor_Receiving_Group__r.Recieved__c != null && voInvoice.Vendor_Receiving_Group__r.Cost__c != null) {
	    			receivingGroupTotalAmount = voInvoice.Vendor_Receiving_Group__r.Recieved__c * voInvoice.Vendor_Receiving_Group__r.Cost__c;
	    		}
	    		
	    		if(lastInvoiceNumber != '' && lastInvoiceNumber != String.valueOf(voInvoice.Vendor_Invoicing_Header__c)){
	    			miscPurchasesExportTextData += createImportableTextForInvoiceItemRecord(miscPurchasesIndexVal++, 
		    																				new Map<String, String>(),
		    																				miscellaneousPurchasesSFFieldToAccountingFieldsMap
		    																			);
	    		}
	    		
	    		// Add the data for a record in export text string
	    		miscPurchasesExportTextData += createImportableTextForInvoiceItemRecord(miscPurchasesIndexVal++, 
	    																				createMiscellaneousPurchasesRecordFromInvoiceItem(voInvoice, GLAccountMap),
		    																			miscellaneousPurchasesSFFieldToAccountingFieldsMap
		    																		);
	    		
	    		// If total of Invoice Items is different from receiving total, then add a Variance record for the difference value
	    		if((voInvoice.Vendor_Receiving_Group__r.Cost__c != voInvoice.VI_Cost__c || voInvoice.VI_Discount__c != 0) && totalInvoicePayment != receivingGroupTotalAmount ){
	    			decimal varianceAmount = receivingGroupTotalAmount - totalInvoicePayment;
	    			miscPurchasesExportTextData += createImportableTextForInvoiceItemRecord(miscPurchasesIndexVal++, 
		    																				createMiscellaneousPurchasesRecordFromAdjustment(voInvoice, GLAccountMap, varianceAmount, 'Receiving Adjustment'),
			    																			miscellaneousPurchasesSFFieldToAccountingFieldsMap
			    																		);
	    			
	    			decimal discountAmount = totalInvoicePayment - receivingGroupTotalAmount;
	    			miscPurchasesExportTextData += createImportableTextForInvoiceItemRecord(miscPurchasesIndexVal++, 
		    																				createMiscellaneousPurchasesRecordFromAdjustment(voInvoice, GLAccountMap, discountAmount, 'Inventory Adjustment'),
			    																			miscellaneousPurchasesSFFieldToAccountingFieldsMap
			    																		);
	    		}
	    		
	    		// Process to include new line for new invoice included
	    		if(lastInvoiceNumber != String.valueOf(voInvoice.Vendor_Invoicing_Header__c)){
	    			lastInvoiceNumber = voInvoice.Vendor_Invoicing_Header__c;
	    		}
	    	}
	    	
	    	if(miscPurchasesExportTextData.indexOf('{') != -1){
	    		miscPurchasesExportTextData = miscPurchasesExportTextData.subString(miscPurchasesExportTextData.indexOf('{'));
	    	}
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
    	
    	// Insert export file for MiscellaneousPurchases
		Attachment attachment = new Attachment();
		attachment.Body = Blob.valueOf(miscPurchasesExportTextData);
    	attachment.Name = 'MISCPURCHASE_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	attachmentsList.add(attachment);
    	
    	if(attachmentsList.size() > 0){
    		insert attachmentsList;
    	}
    	
    	if(exportAllData){
    		if(AccessControl.ifSingleEmailSendAllowed() == false) { throw new BlackPurlException(Constants.EMAIL_SEND_NOT_PERMIT); }
    		
	    	// Send the acknowledge mail to user
	  		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	
	  		// Who you are sending the email to
	  		mail.setTargetObjectId(UserInfo.getUserId());
	
	  		// The email template ID used for the email
	  		List<EmailTemplate> emailtemplates = [Select Id From EmailTemplate Where DeveloperName = 'Accounting_Data_Export_Process_Complete'];
	  		if(emailtemplates.size() != 0){
	  			mail.setTemplateId(emailtemplates[0].Id);
		  		mail.setBccSender(false);
		  		mail.setUseSignature(false);
		  		mail.setSaveAsActivity(false);
		  		Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	  		}
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for voInvoice orders
     * @param: 
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all voInvoice accounts to be synched here
    	String voInvoiceQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, CreatedDate ';
    	
    	String customFieldsQuery = '';
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(Constants.NAMESPACE + 'Vendor_Invoicing_Group__c').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	customFieldsQuery += ', Vendor_Receiving_Group__r.Recieved__c, Vendor_Receiving_Group__r.Cost__c, Vendor_Receiving_Group__r.Part__c, Vendor_Receiving_Group__r.Part__r.Part_Number__c, Vendor_Receiving_Group__r.Part__r.Description__c';
    	customFieldsQuery += ', Vendor_Invoicing_Header__r.Name, Vendor_Invoicing_Header__r.Status__c, Vendor_Invoicing_Header__r.Invoice_Number__c, Vendor_Invoicing_Header__r.Invoice_Date__c';
    	customFieldsQuery += ', Vendor_Invoicing_Header__r.Vendor__r.Name, Vendor_Invoicing_Header__r.Vendor__r.LastName__c, Vendor_Invoicing_Header__r.Vendor__r.Vendor_Code__c, Vendor_Invoicing_Header__r.Vendor__r.Type__c';
    	customFieldsQuery += ', Vendor_Receiving_Group__r.Part__r.Category__r.COGS_GL__c, Vendor_Receiving_Group__r.Part__r.Category__r.Income_GL__c, Vendor_Receiving_Group__r.Part__r.Category__r.Inventory_GL__c';
    	customFieldsQuery += ', Vendor_Receiving_Group__r.Part__r.Package_Qty__c, Vendor_Receiving_Group__r.Part__r.Packaged_Part__c';
    	customFieldsQuery += ', Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Name__c, Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c';
    	
    	String whereCondition = ' WHERE VI_Cost__c != 0 AND VI_Qty__c != 0 AND Vendor_Receiving_Group__c != null';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds;
    	}
    	
    	voInvoiceQuery += standardFieldsQuery + customFieldsQuery + ' FROM Vendor_Invoicing_Group__c ' + whereCondition + ' ORDER BY Vendor_Invoicing_Header__r.Invoice_Number__c';
    	return voInvoiceQuery;
	}
    
    /**
     * Name: createImportableTextForInvoiceItemRecord
     * Desc: Method to create a importable file ',' seperated text string for MiscellaneousPurchases records
     * @param:	1) Integer indexVal
     *			2) Map<String,String> miscPurchases
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
    	
    	// Create file header with software voInvoice object fields
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
	    		
	    		// Now populate voInvoice records data text
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
     * Name: createMiscellaneousPurchasesSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of MiscellaneousPurchases Purchasesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createMiscellaneousPurchasesSFFieldToAccountingFieldsMap() {
    	Map<String, String> miscPurchaseSFFieldToAccountingFieldsMap = new Map<String, String>{ 'Last_Name__c'			=>	'Co./Last Name',
																								'Date__c'				=>	'Date',
																								'Supplier_Invoice_No__c'=>	'Supplier Invoice No.',
																								'Inclusive__c'			=>	'Inclusive',
																								'Memo__c'				=>	'Memo',
																								'Description__c'		=>	'Description',
																								'Account_No__c'			=>	'Account Number',
																								'Amount__c'				=>	'Amount',
																								'Tax_Code__c'			=>	'Tax Code',
																								'Tax_Amount__c'			=>	'Tax Amount',
																								'Payment_Status__c'		=>	'Payment Status',
		    																					'Card_ID__c'			=>	'Card ID'
		    																				};
    	
    	return miscPurchaseSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createMiscellaneousPurchasesRecordFromInvoiceItem
     * Desc: Method to create a MiscellaneousPurchases record by cocoInvoiceItem record. MiscellaneousPurchases record is a map of field name to equivalent value for field
     * @param: Vendor_Invoicing_Group__c voInvoice, Map<String, String> GLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createMiscellaneousPurchasesRecordFromInvoiceItem(Vendor_Invoicing_Group__c voInvoice, Map<String, String> GLAccountMap) {
    	DateTime invoiceDate = (voInvoice.Vendor_Invoicing_Header__r.Status__c == 'Invoiced') ? datetime.newInstance(voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.year(), voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.month(), voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.day()) : voInvoice.CreatedDate;
    	
    	decimal taxAmount = (voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c != null) ? (voInvoice.VI_SubTotal__c * voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c / 100) : 0;
    	Map<String, String> miscPurchases = new Map<String, String>{'Last_Name__c'			=>	(voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Type__c == 'Individual') ? voInvoice.Vendor_Invoicing_Header__r.Vendor__r.LastName__c : voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Name,
    																'Date__c'				=>	invoiceDate.format(DataExportService.dateFormat),
    																'Supplier_Invoice_No__c'=>	voInvoice.Vendor_Invoicing_Header__r.Invoice_Number__c,
    																'Inclusive__c'			=>	(voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c != null) ? 'X' : 'N',
    																'Memo__c'				=>	voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Name + ';' + voInvoice.Vendor_Invoicing_Header__r.Name.replace('VI-', '') + ';Purchase',
    																'Description__c'		=>	voInvoice.Vendor_Receiving_Group__r.Part__r.Part_Number__c + '-' + voInvoice.Vendor_Receiving_Group__r.Part__r.Description__c + ' ' + voInvoice.VI_Qty__c + '@$' + voInvoice.VI_Cost__c,
    																'Account_No__c'			=>	(GLAccountMap.containsKey('Received Inventory Accrual')) ? GLAccountMap.get('Received Inventory Accrual') : '',
	    															'Amount__c'				=>	((voInvoice.VI_SubTotal__c >= 0) ? '$' : '-$') + ((voInvoice.VI_SubTotal__c >= 0) ? voInvoice.VI_SubTotal__c.setScale(2) : (voInvoice.VI_SubTotal__c * -1).setScale(2)),
																	'Tax_Code__c'			=>	voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Name__c,
																	'Tax_Amount__c'			=>	((taxAmount >= 0) ? '$' : '-$') + ((taxAmount >= 0) ? taxAmount.setScale(2) : (taxAmount * -1).setScale(2)),
																	'Payment_Status__c'		=>	'B',
																	'Card_ID__c'			=>	voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Vendor_Code__c
																};
    	return miscPurchases;
    }
    
    /**
     * Name: createMiscellaneousPurchasesRecordFromAdjustment
     * Desc: Method to create a MiscellaneousPurchases record by cocoInvoiceItem Adjustment record. MiscellaneousPurchases record is a map of field name to equivalent value for field
     * @param: Vendor_Invoicing_Group__c voInvoice, Map<String, String> GLAccountMap
     * @return: Map<String, String>
    **/
    private static Map<String, String> createMiscellaneousPurchasesRecordFromAdjustment(Vendor_Invoicing_Group__c voInvoice, 
    																					Map<String, String> GLAccountMap,
    																					decimal amount, 
    																					String description) {
    	DateTime invoiceDate = (voInvoice.Vendor_Invoicing_Header__r.Status__c == 'Invoiced') ? datetime.newInstance(voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.year(), voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.month(), voInvoice.Vendor_Invoicing_Header__r.Invoice_Date__c.day()) : voInvoice.CreatedDate;
    	Map<String, String> miscPurchases = new Map<String, String>{'Last_Name__c'			=>	(voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Type__c == 'Individual') ? voInvoice.Vendor_Invoicing_Header__r.Vendor__r.LastName__c : voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Name,
    																'Date__c'				=>	invoiceDate.format(DataExportService.dateFormat),
    																'Supplier_Invoice_No__c'=>	voInvoice.Vendor_Invoicing_Header__r.Invoice_Number__c,
    																'Inclusive__c'			=>	'X',
    																'Memo__c'				=>	voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Name + ';' + voInvoice.Vendor_Invoicing_Header__r.Name.replace('VI-', '') + ';Purchase',
    																'Description__c'		=>	voInvoice.Vendor_Receiving_Group__r.Part__r.Part_Number__c + '-' + voInvoice.Vendor_Receiving_Group__r.Part__r.Description__c + ' ' + description,
    																'Account_No__c'			=>	(GLAccountMap.containsKey('Received Inventory Accrual')) ? GLAccountMap.get('Received Inventory Accrual') : '',
	    															'Amount__c'				=>	((amount >= 0) ? '$' : '-$') + ((amount >= 0) ? amount.setScale(2) : (amount * -1).setScale(2)),
																	'Tax_Code__c'			=>	'N-T',
																	'Tax_Amount__c'			=>	'$0',
																	'Payment_Status__c'		=>	'B',
																	'Card_ID__c'			=>	voInvoice.Vendor_Invoicing_Header__r.Vendor__r.Vendor_Code__c
																};
    	
    	if(description == 'Receiving Adjustment'){
    		miscPurchases.put('Account_No__c', (GLAccountMap.containsKey('Received Inventory Accrual')) ? GLAccountMap.get('Received Inventory Accrual') : '');
    	} else if(description == 'Inventory Adjustment'){
    		miscPurchases.put('Account_No__c', ((voInvoice.Vendor_Receiving_Group__r.Part__r.Category__r != null && voInvoice.Vendor_Receiving_Group__r.Part__r.Category__r.Inventory_GL__c != null) ? voInvoice.Vendor_Receiving_Group__r.Part__r.Category__r.Inventory_GL__c : ''));
    	}
    	
    	return miscPurchases;
    }
}