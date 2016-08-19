/**
 * Author: Ashish Garg
 * Since: Aug 21, 2015
 * Name: VendorReceivingLineItem
 * Description: Line Item instance class basically used to sort the line items for a group in order:
 *				1. special orders for Service Sections are always allocated to first 
 *				2. followed by special orders for Merch sections
 *				3. followed by Stock Replenishment orders which are NOT �Excess�
 *				4. followed by Stock Excess components
**/
public with sharing class VendorReceivingLineItem implements Comparable {
	
	// Vendor order line item instance records based on sorting to be performed
	public Vendor_Order_Line_Item__c voli;
	
	/**
     * Name: VendorReceivingLineItem
     * Desc: Cosntructor to initialize line item instance
     * @param:  (1) Vendor_Order_Line_Item__c voli 
     * @return: 
    **/
	public VendorReceivingLineItem(Vendor_Order_Line_Item__c voli){
		this.voli = voli;
	}
	
	/**
     * Name: compareTo
     * Desc: Overridden "compareTo" from Comparable class to sort list of line item records
     *		 		1. special orders for Service Sections are always allocated to first (Is_Service__c = true)
	 *				2. followed by special orders for Merch sections (Is_required_For_Customer__c = true)
	 *				3. followed by Stock Replenishment orders which are NOT �Excess� (Is_Excess__c = false)
	 *				4. followed by Stock Excess components (Is_Excess__c = true)
     * @param:  (1) object compareTo : An object instance of VendorReceivingLineItem class
     * @return: (1) Campared Integer value
    **/
	public Integer compareTo(object compareTo){
		VendorReceivingLineItem compareToObj = ((VendorReceivingLineItem)compareTo);
		
		Integer returnVal = (this.voli.Is_Service__c != compareToObj.voli.Is_Service__c) 
							? ((this.voli.Is_Service__c) ? -1 : ((compareToObj.voli.Is_Service__c) ? 1 : 100))
							: 100;
		
		if(returnVal == 100){
			returnVal = (this.voli.Is_required_For_Customer__c != compareToObj.voli.Is_required_For_Customer__c) 
						? ((this.voli.Is_required_For_Customer__c) ? -1 : ((compareToObj.voli.Is_required_For_Customer__c) ? 1 : 100))
						: 100;
		}
		if(returnVal == 100){
			returnVal = (this.voli.Is_Excess__c != compareToObj.voli.Is_Excess__c) 
						? ((this.voli.Is_Excess__c == false) ? -1 : ((compareToObj.voli.Is_Excess__c == false) ? 1 : 100))
						: 100;
		}
		if(returnVal == 100){
			returnVal = (this.voli.Is_Excess__c != compareToObj.voli.Is_Excess__c) 
						? ((this.voli.Is_Excess__c == true) ? -1 : ((compareToObj.voli.Is_Excess__c == true) ? 1 : 100))
						: 100;
		}
		if(returnVal == 100){
			returnVal = (this.voli.LastModifiedDate.getTime() <= compareToObj.voli.LastModifiedDate.getTime())
						? -1
						: 1;
		}
		
		return returnVal;
	}
}