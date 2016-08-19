/**
 * Author: Ashish Garg
 * Since: Dec. 18, 2015
 * Name: DataExportService
 * Description: Service class used to export salesforce data 
**/
global with sharing class DataExportService {
	// Separator between data in file
	public static String fileSeparator = '\t';
	
	// File time format for title
	public static String fileDateTimeFormat = 'yyyy-mm-dd\'T\'hh:mm:ss\'Z\'';
	
	// Date Format for data in file
	public static String dateFormat = 'dd/MM/yyyy';
	
	// Boolean to show if to export all records data
	private static boolean exportAllData = false;
	
	public String objectName {get; set;}
    /**
     * Name: exportAccountingData
     * Desc: Method to export salesforce object data to appropriate "Accounting Data Migration" attachment
     * @param: String objectName - depending on object name, exported data file will be attachned in "Accounting Data Migration" record
     * @return:
    **/
    public PageReference exportAccountingData() {
    	if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	Id batchId;
    	objectName = String.escapeSingleQuotes(objectName);
    	
    	// If no objet name is provided, then export all data
    	if(objectName == ''){
    		List<Accounting_Data_Migration__c> admList = [Select Id, Last_Synched_Date__c from Accounting_Data_Migration__c LIMIT : SOQLUtil.getAvailableQueryRowsLimit()];
    		for(Accounting_Data_Migration__c adm : admList){
    			adm.Last_Synched_Date__c = null;
    		}
    		update admList;
    		
    		exportAllData = (objectName == '') ? true : false;
    		batchId = AccountingDataMigrationCustomers.executeCustomerCardsDataMigrationBatch(200, null, exportAllData);
    	}
    	if(objectName == AccountingDataMigrationCustomers.CUSTOMERS_ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationCustomers.executeCustomerCardsDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationVendors.VENDORS_ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationVendors.executeVendorCardsDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationDeposits.DEPOSITS_ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationDeposits.executeDepositsDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationRMPayment.PAYMENT_ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationRMPayment.executePaymentsDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationSalesInvoice.ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationSalesInvoice.executeDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationvendorReceiving.ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationvendorReceiving.executeDataMigrationBatch(200, null, exportAllData);
    	} else if(objectName == AccountingDataMigrationVendorInvoice.ACCOUNTING_OBJECT_NAME){
    		batchId = AccountingDataMigrationVendorInvoice.executeDataMigrationBatch(200, null, exportAllData);
    	}
    	
    	return null;
    }
    
    /**
     * Name: getExportedDataList
     * Desc: Method to get the exported data list for all accounting records
     * @param:
     * @return:
    **/
    public List<ExportedData> getExportedDataList(){
    	if(AccessControl.ifObjectFieldIsAccessible('Accounting_Data_Migration__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsAccessible('Attachment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	List<ExportedData> exportedFiles = new List<ExportedData>();
    	
    	// get all accounting data records with Attachments as inner list
    	for(Accounting_Data_Migration__c adm : [Select Id, Object_Name__c, Last_Synched__c, (Select Id, Name, CreatedDate From Attachments) from Accounting_Data_Migration__c LIMIT : Limits.getLimitQueryRows() - Limits.getQueryRows()]){
    		exportedFiles.add( new ExportedData(adm) );
    	}
    	
    	return exportedFiles;
    }
    
    // Wrapper class to hold the type of record and list of exported files attachment
    public class ExportedData {
    	// Object name
    	public String objectName {get; private set;}
    	
    	// List of attachments
    	public List<Attachment> exportedFiles {get; private set;}
    	
    	/**
	     * Name: ExportedData
	     * Desc: Constructor which takes a Accounting Data Export record and populate values
	    **/
    	public ExportedData(Accounting_Data_Migration__c adm){
    		objectName		= adm.Object_Name__c;
    		exportedFiles	= new List<Attachment>();
    		
    		for(Attachment att : adm.Attachments){
    			if(att.CreatedDate >= adm.Last_Synched__c){
    				exportedFiles.add(att);
    			}
    		}
    	}
    }
}