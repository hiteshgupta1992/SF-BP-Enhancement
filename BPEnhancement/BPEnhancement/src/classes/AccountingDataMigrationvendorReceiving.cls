/**
 * Author: Ashish Garg
 * Since: Jan. 13, 2015
 * Name: AccountingDataMigrationvendorReceiving
 * Description: Class is used for migration of Vendor Receiving object records to  Accounting Software
**/
global with sharing class AccountingDataMigrationvendorReceiving implements Database.batchable<sObject>,Database.Stateful {
	// Accounting synch data migration "General Journal Entries" object name
	public static final String ACCOUNTING_OBJECT_NAME = 'General Journal Entries';
	
	// Batch size
	private static final Integer BATCH_SIZE = 1000;
	
	// Data string for all exporatble Vendor Receiving data
	private String generalJournalEntriesData;
	
	// Query string
	private string query;
	
	// DateTime value for last synched
	private DateTime Last_Synched_Date;
	
	// Index value to maintain total records count
	private integer indexVal;
	
	// "Vendor Receiving card" record of Accounting Data Migration object
	private Accounting_Data_Migration__c dataMigration;
	
	// Boolean to show if to export all records data
	private boolean exportAllData = false;
	
	/**
     * Name: AccountingDataMigrationvendorReceiving
     * Desc: Constructor to start the batch for data export
    **/
	global AccountingDataMigrationvendorReceiving(List<Id> recordIds,boolean exportAllData) {
		if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(AccessControl.ifObjectFieldIsCreateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		this.exportAllData = exportAllData;
		generalJournalEntriesData = '';
		indexVal = 1;
		
		// Get the "Vendor Receiving card" record from Accounting Data Migration object
    	try{
    		dataMigration = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c where Object_Name__c =: ACCOUNTING_OBJECT_NAME];
    	} catch(QueryException e) {
    		dataMigration = new Accounting_Data_Migration__c(Object_Name__c = AccountingDataMigrationvendorReceiving.ACCOUNTING_OBJECT_NAME);
    	}
    	
    	// Last synched date value by which we need to filter Accounts data
		// Set Last Synched date for migration record
		Last_Synched_Date = dataMigration.Last_Synched_Date__c;
    	dataMigration.Last_Synched_Date__c = Datetime.now();
    	
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	query = createQuery(recordIds);
	}
	
	/**
     * Name: executeDataMigrationBatch
     * Desc: Constructor to start the batch for data export
    **/
	public static Id executeDataMigrationBatch(Integer batchSize, List<Id> recordIds, boolean exportAllData) {
		Id batchId = Database.executeBatch(new AccountingDataMigrationvendorReceiving(recordIds, exportAllData), batchSize);
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
		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('GL_Account__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<Vendor_Receiving_Group__c> vrRecords = (List<Vendor_Receiving_Group__c>) scope;
		
		if(vrRecords.size() > 0){
	    	// Map of General Journal Entries records for all applicable saleforce customer records (a map of VR sf fields to equivalent values)
	    	Map<Integer, Map<String,String>> generalJournalEntryRecords = new Map<Integer, Map<String, String>>();
	    	
	    	// GL Accounts for deposit
	    	List<GL_Account__c> glAccounts = [Select Id, MYOB_Account_Name__c, MYOB_Account_Number__c, Type__c from GL_Account__c Where Type__c LIKE '%Inventory%'];
	    	Map<String, String> GLAccountMap = new Map<String, String>();
	    	for(GL_Account__c glAcc : glAccounts){
	    		GLAccountMap.put(glAcc.Type__c, glAcc.MYOB_Account_Number__c);
	    	}
	    	
	    	// For each VR, create a General Journal Entries entry:
	    	String preVRHeaderName = '';
	    	Vendor_Receiving_Group__c prevVR;
	    	decimal totalAmountForSingleReceivingHeader = 0;
	    	Integer loopIndex = 0;
	    	
	    	for(Vendor_Receiving_Group__c vr : vrRecords){
	    		loopIndex++;
	    		vr.Total__c = vr.Recieved__c * vr.Cost__c;
	    		
	    		// Create entry for total receiving amount
	    		if(preVRHeaderName != '' && preVRHeaderName != vr.Vendor_Receiving_Header__r.Name){
	    			generalJournalEntryRecords.put(indexVal++, createTotalGeneralJournalEntryRecordFromAccount((loopIndex == vrRecords.size()) ? vr : prevVr, totalAmountForSingleReceivingHeader, GLAccountMap) );
	    			totalAmountForSingleReceivingHeader = 0;
	    		}
	    		
	    		// Empty line
	    		if(preVRHeaderName != '' && preVRHeaderName != vr.Vendor_Receiving_Header__r.Name){
	    			generalJournalEntryRecords.put(indexVal++, new Map<String, String>() );
	    		}
	    		
	    		totalAmountForSingleReceivingHeader += vr.Total__c;
	    		generalJournalEntryRecords.put(indexVal++, createGeneralJournalEntriesRecordFromAccount(vr) );
	    		
	    		if(preVRHeaderName == vr.Vendor_Receiving_Header__r.Name && loopIndex == vrRecords.size()) {
	    			generalJournalEntryRecords.put(indexVal++, createTotalGeneralJournalEntryRecordFromAccount((loopIndex == vrRecords.size()) ? vr : prevVr, totalAmountForSingleReceivingHeader, GLAccountMap) );
	    			totalAmountForSingleReceivingHeader = 0;
	    		}
	    		
	    		// Determine if from different Receiving, then enter a new line
	    		if(preVRHeaderName != vr.Vendor_Receiving_Header__r.Name){
	    			preVRHeaderName = vr.Vendor_Receiving_Header__r.Name;
	    		}
	    		prevVR = vr;
	    	}
	    	
	    	// Now create a string for list of General Journal Entries records so as to convert in format of importable text file for accounting software
    		generalJournalEntriesData += createImportableTextForGeneralJournalEntries(generalJournalEntryRecords);
    		generalJournalEntriesData = (generalJournalEntriesData.indexOf('{') != -1) ? generalJournalEntriesData.subString(generalJournalEntriesData.indexOf('{')) : generalJournalEntriesData;
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
    	
		attachment.Body = Blob.valueOf(generalJournalEntriesData);
    	attachment.Name = 'GENERAL_JOURNAL_' + DateTime.now().format(DataExportService.fileDateTimeFormat) + '.TXT';
    	attachment.ParentId = dataMigration.Id;
    	attachment.ContentType = 'text/plain';
    	insert attachment;
    	
    	// Execute next batch
    	if(exportAllData){
    		AccountingDataMigrationVendorInvoice.executeDataMigrationBatch(200, null, exportAllData);
    	}
	}
	
	/**
     * Name: createQuery
     * Desc: Method to create a query string for customer orders
     * @param:
     * @return: String
    **/
	private String createQuery(List<Id> recordIds) {
		// Get all vr to be synched here
    	String vrsQuery = 'SELECT ';
    	
    	String standardFieldsQuery = 'Id, Name, CreatedDate';
    	
    	String customFieldsQuery = ' , Vendor_Receiving_Header__r.Name, Vendor_Receiving_Header__r.Vendor__r.Name, Vendor_Receiving_Header__r.Packing_Slip_Number__c, Vendor_Receiving_Header__r.CreatedDate';
    	customFieldsQuery += ' , Part__r.Part_Number__c, Part__r.Description__c';
    	customFieldsQuery += ', Part__r.Category__r.Inventory_GL__c, Vendor_Receiving_Header__r.Vendor__r.Sales_Tax__r.Name__c';
    	
    	Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(CONSTANTS.NAMESPACE + 'Vendor_Receiving_Group__c').getDescribe().Fields.getMap();
    	for( String fieldName : objectFieldsMap.keySet() ) {
    		if(fieldName.endsWith('__c')){
    			customFieldsQuery += ' , ' + fieldName;
    		}
    	}
    	
    	String whereCondition = ' WHERE Cost__c != 0 AND Recieved__c != 0 AND Vendor_Receiving_Header__r.Status__c = \'Stocked\'';
    	if(Last_Synched_Date != null){
    		whereCondition += ' AND LastModifiedDate >: Last_Synched_Date';
    	}
    	if(recordIds != null && recordIds.size() > 0){
    		whereCondition += ' AND Id IN ' + recordIds;
    	}
    	
    	vrsQuery += standardFieldsQuery + customFieldsQuery + ' FROM Vendor_Receiving_Group__c ' + whereCondition + ' ORDER BY Vendor_Receiving_Header__r.Name';
    	return vrsQuery;
	}
    
    /**
     * Name: createImportableTextForGeneralJournalEntries
     * Desc: Method to create a importable file ',' seperated text string for General Journal Entries records
     * @param: Map<Integer, Map<String,String>> generalJournalEntryRecords
     * @return: String
    **/
    private static String createImportableTextForGeneralJournalEntries(Map<Integer, Map<String,String>> generalJournalEntryRecords) {
    	String headerLengthRowString = '';
    	String headerRowString = '';
    	String contentsString = '';
    	
    	// Map of Vendor Receiving Card fields to Accounting software fields need to be mapped in generated synch file
    	Map<String, String> createGeneralJournalEntriesSFFieldToAccountingFieldsMap = createGeneralJournalEntriesSFFieldToAccountingFieldsMap();
    	
    	// Create file header with software customer object fields
    	for(Integer indexVal : generalJournalEntryRecords.keySet()){
    		Map<String, String> generalJournalEntry = generalJournalEntryRecords.get(indexVal);
    		
    		contentsString += '\n';
    		if(generalJournalEntry.size() > 0){
	    		for(String customerFieldSFName : generalJournalEntry.keySet()){
	    			// Populate 1st row for file which is for purpose of total object fields
		    		if(indexVal == 1){
		    			headerLengthRowString += (headerLengthRowString.length() == 0) ? '{}' : DataExportService.fileSeparator;
		    		}
		    		
		    		// Populate 2nd row for file which is for purpose of object fields display
		    		if(indexVal == 1){
		    			headerRowString += createGeneralJournalEntriesSFFieldToAccountingFieldsMap.get(customerFieldSFName) + DataExportService.fileSeparator;
		    		}
		    		
		    		// Now populate customer records data text
		    		String value = (generalJournalEntry.get(customerFieldSFName) != null) ? generalJournalEntry.get(customerFieldSFName) : '';
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
     * Name: createGeneralJournalEntriesSFFieldToAccountingFieldsMap
     * Desc: Method to create a map of Vendor Receiving card Salesforce fields to Accounting field map so as to map in generated TXT file
     * @param: 
     * @return: Map<String, String>
    **/
    private static Map<String, String> createGeneralJournalEntriesSFFieldToAccountingFieldsMap() {
    	Map<String, String> generalJournalEntriesSFFieldToAccountingFieldsMap = new Map<String, String>{  'Journal_Number__c'	=>	'Journal Number',
																										  'Date__c'				=>	'Date',
																										  'Memo__c'				=>	'Memo',
																										  'Reporting__c'		=>	'GST (BAS) Reporting',
																										  'Inclusive__c'		=>	'Inclusive',
																										  'Account_No__c'		=>	'Account Number',
																										  'Is_Credit__c'		=>	'Is Credit',
																										  'Amount__c'			=>	'Amount',
																										  'Tax_Code__c'			=>	'Tax Code',
																										  'Allocation_Memo__c'	=>	'Allocation Memo'
					    																				};
    	
    	return generalJournalEntriesSFFieldToAccountingFieldsMap;
    }
    
    /**
     * Name: createGeneralJournalEntriesRecordFromAccount
     * Desc: Method to create a General Journal Entries record by Vendor_Receiving_Group__c record. Vendor Receiving card record is a map of field name to equivalent value for field
     * @param: Vendor_Receiving_Group__c vrGroup
     * @return: Map<String, String>
    **/
    private static Map<String, String> createGeneralJournalEntriesRecordFromAccount(Vendor_Receiving_Group__c vrGroup) {
    	Map<String, String> generalJournalEntry = new Map<String, String>{	'Journal_Number__c'	=>	vrGroup.Vendor_Receiving_Header__r.Name.replace('VR-', ''),
																			'Date__c'			=>	vrGroup.CreatedDate.format(DataExportService.dateFormat),
																			'Memo__c'			=>	vrGroup.Vendor_Receiving_Header__r.Vendor__r.Name + ';' + vrGroup.Vendor_Receiving_Header__r.Packing_Slip_Number__c + ';Receiving',
																			'Reporting__c'		=>	'P',
																			'Inclusive__c'		=>	'X',
																			'Account_No__c'		=>	(vrGroup.Part__r.Category__r != null && vrGroup.Part__r.Category__r.Inventory_GL__c != null) ? vrGroup.Part__r.Category__r.Inventory_GL__c : '',
				    														'Is_Credit__c'		=>	(vrGroup.Recieved__c > 0) ? 'N' : 'Y',
				    														'Amount__c'			=>	((vrGroup.Total__c >= 0) ? '$' : '-$') + ((vrGroup.Total__c >= 0) ? vrGroup.Total__c.setScale(2) : (vrGroup.Total__c * -1).setScale(2)),
				    														'Tax_Code__c'		=>	'N-T',
																			'Allocation_Memo__c'=>	vrGroup.Part__r.Part_Number__c + ' - ' + vrGroup.Part__r.Description__c + ' ' + vrGroup.Recieved__c + '@$' + vrGroup.Cost__c
																		};
    	return generalJournalEntry;
    }
    
    /**
     * Name: createTotalGeneralJournalEntryRecordFromAccount
     * Desc: Method to create a TOTAL General Journal Entry record by Vendor_Receiving_Header__c record. Vendor Receiving card record is a map of field name to equivalent value for field
     * @param: Vendor_Receiving_Group__c vrGroup
     * @return: Map<String, String>
    **/
    private static Map<String, String> createTotalGeneralJournalEntryRecordFromAccount(Vendor_Receiving_Group__c vrGroup, decimal amount, Map<String, String> GLAccountMap) {
    	Map<String, String> generalJournalEntry = new Map<String, String>{	'Journal_Number__c'	=>	vrGroup.Vendor_Receiving_Header__r.Name.replace('VR-', ''),
																			'Date__c'			=>	vrGroup.Vendor_Receiving_Header__r.CreatedDate.format(DataExportService.dateFormat),
																			'Memo__c'			=>	vrGroup.Vendor_Receiving_Header__r.Vendor__r.Name + ';' + vrGroup.Vendor_Receiving_Header__r.Packing_Slip_Number__c + ';Receiving',
																			'Reporting__c'		=>	'P',
																			'Inclusive__c'		=>	'X',
																			'Account_No__c'		=>	(GLAccountMap.containsKey('Received Inventory Accrual')) ? GLAccountMap.get('Received Inventory Accrual') : '',
				    														'Is_Credit__c'		=>	(vrGroup.Recieved__c > 0) ? 'Y' : 'N',
				    														'Amount__c'			=>	((amount >= 0) ? '$' : '-$') + ((amount >= 0) ? amount.setScale(2) : (amount * -1).setScale(2)),
				    														'Tax_Code__c'		=>	'N-T',
																			'Allocation_Memo__c'=>	'Total Receiving'
																		};
    	return generalJournalEntry;
    }
}