/**
 * Author: Tarun Khandelwal
 * Since: Dec 05, 2015
 * Name: FeeSuggestion
 * Description: Apex class to handle JSON related oprations of suggestion of Fee records.
**/
global with sharing class FeeSuggestion implements Comparable {
	
	public String Code;
	public String Description;
	public String Id;
	public Integer PriorityValue;
	public Decimal Price;
	public Boolean IsTaxable;
	
	public FeeSuggestion(Fee__c feeRec, Integer priorityNumber) {
		this.Code = feeRec.Code__c;
		this.Description = feeRec.Description__c;
		this.Id = feeRec.Id;
		this.PriorityValue = priorityNumber;
		this.Price = (feeRec.Price__c == null) ? 0 : feeRec.Price__c;
		this.IsTaxable = feeRec.Taxable__c;
	}
	
	global Integer compareTo(Object compareTo) {
    	FeeSuggestion compareToWrapperObj = ((FeeSuggestion)compareTo);
    	Integer returnValue = 0;
    	if (PriorityValue == compareToWrapperObj.PriorityValue) return 0;
        if (PriorityValue > compareToWrapperObj.PriorityValue) return 1;
        return -1; 
    }
}