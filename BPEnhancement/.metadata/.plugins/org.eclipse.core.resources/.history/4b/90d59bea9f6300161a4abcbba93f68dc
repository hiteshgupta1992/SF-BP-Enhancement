/**
 * Author: Tarun Khandelwal
 * Since: Nov 23, 2015
 * Name: KitHeaderSuggestion
 * Description: Apex class to handle JSON related oprations of suggestion of Kit Header records.
**/
global with sharing class KitHeaderSuggestion implements Comparable {
	
	public String Code;
	public String Description;
	public String Id;
	public Integer PriorityValue;
	public Boolean CanItSplit;
	public Boolean IsServiceKit;
	
	public KitHeaderSuggestion(Kit_Header__c kitHeaderRec, Integer priorityNumber) {
		this.Code = kitHeaderRec.Code__c;
		this.Description = kitHeaderRec.Description__c;
		this.Id = kitHeaderRec.Id;
		this.PriorityValue = priorityNumber;
		this.CanItSplit = kitHeaderRec.Can_Split__c;
		this.IsServiceKit = kitHeaderRec.Service_Kit__c;
	}
	
	global Integer compareTo(Object compareTo) {
    	KitHeaderSuggestion compareToWrapperObj = ((KitHeaderSuggestion)compareTo);
    	Integer returnValue = 0;
    	if (PriorityValue == compareToWrapperObj.PriorityValue) return 0;
        if (PriorityValue > compareToWrapperObj.PriorityValue) return 1;
        return -1; 
    }
}