/**
 * Author: Tarun Khandelwal
 * Since: Nov 19, 2015
 * Name: KitHeader
 * Description: Apex class to handle JSON related oprations of Kit Header Object
**/
public with sharing class Fee {
	
	public String Code;
	public String Description;
	public Decimal Price;
	public String CategoryName;
	public String CategoryId;
	public Boolean IsTaxable;
	public Boolean IsActive;
	public String Id;
	public String ApplicableTaxId;
	public String ApplicableTaxName;
	
	public Fee() {
		this.Price = 0.00;
		this.IsActive = true;
	}
	
	public Fee(Fee__c feeRec) {
		this.Code = feeRec.Code__c;
		this.Description = feeRec.Description__c;
		this.Price = (feeRec.Price__c == null) ? 0 : feeRec.Price__c;
		this.CategoryName = feeRec.Category__r.Name;
		this.CategoryId = feeRec.Category__c;
		this.IsTaxable = feeRec.Taxable__c;
		this.IsActive = feeRec.Active__c;
		this.Id = feeRec.Id;
		this.ApplicableTaxId = feeRec.Applicable_Tax__c;
		this.ApplicableTaxName = feeRec.Applicable_Tax__r.Name__c;
	}
	
	/**
     * Name: getFeeFields
     * Desc: Method to get all fields related to Fee Object.
     * @param:  
     * @return: List<String> - Fee fields list
    **/
	public static List<String> getFeeFields() {
		List<String> feeFields = new List<String>{	'Code__c',
													'Description__c',
													'Price__c',
													'Category__c',
													'Category__r.Name',
													'Taxable__c',
													'Active__c',
													'(Select Id, CO_Header__c, CO_Header__r.Name, CO_Header__r.Customer__c, CO_Header__r.Customer__r.Name, CO_Header__r.Owner__c, CO_Header__r.Owner__r.Name, CO_Header__r.Order_status__c From CO_Line_Items__r WHERE Special_Order__c = false AND CO_Header__r.Order_status__c = \'Open\' )',
													'Applicable_Tax__r.Name__c',
													'Applicable_Tax__c'
											};
		return feeFields;
	}
	
	/**
     * Name: parse
     * Desc: Method to Parse JSON String to class instance
     * @param:  (1) JSONString - String - JSON String 
     * @return: Fee - Class Object
    **/
    public static Fee parse(String json) {
        return (Fee) System.JSON.deserialize(json, Fee.class);
    }
	
}