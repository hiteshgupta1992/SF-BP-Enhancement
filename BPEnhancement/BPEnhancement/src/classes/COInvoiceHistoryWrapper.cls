/**
 * Author: Tarun Khandelwal
 * Since: May 9, 2015
 * Name: COInvoiceHistoryWrapper
 * Description: Apex class to handle JSON related oprations of CO Invoice Header Wrapper Object.
**/
public with sharing class COInvoiceHistoryWrapper {
	
	// Co Invoice Header
	public COInvoiceHeader COInvoiceHeaderRec {get; set;}
	
	// CO Invoice line Item
	public List<COInvoiceItem> COInvoiceItesRecs {get; set;}
	
	public Boolean IsTaxIncludingPricing;
	
	// constructor
	public COInvoiceHistoryWrapper(CO_Invoice_Header__c coInvoiceHeaderRec, List<CO_Invoice_Item__c> coInvoiceItemList ) {
		this.COInvoiceHeaderRec = new COInvoiceHeader(coInvoiceHeaderRec);
		this.COInvoiceItesRecs = new List<COInvoiceItem>();
		for(CO_Invoice_Item__c coInvoiceItemRec : coInvoiceItemList) {
			this.COInvoiceItesRecs.add(new COInvoiceItem(coInvoiceItemRec));
		}
		//system.assert(false, COInvoiceItesRecs);
		this.IsTaxIncludingPricing = GeneralConfiguration.getTaxIncludingPricing();
	}
	
}