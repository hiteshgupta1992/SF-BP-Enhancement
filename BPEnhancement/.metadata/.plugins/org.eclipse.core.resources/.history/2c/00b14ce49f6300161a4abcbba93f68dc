/**
 * Author: Tarun Khandelwal
 * Since: May 25, 2015
 * Name: CountryWrapper
 * Description: Apex class to handle JSON related oprations of Country object.
**/
public with sharing class CountryWrapper {
	
	public Map<string,List<State>> countryNameToStateMap = new Map<string,List<State>>();
	
	// Constructor
    public CountryWrapper(List<Country__c> countryRecList) {
    	//this.CountryName = countryRec.Name__c;
    	for(Country__c countryRec : countryRecList) {
	    	List<State> stateList = new List<State>();
	    	if(countryRec.States__r.size() > 0) {
	    		for(State__c stateRec : countryRec.States__r) {
	    			stateList.add(new State(stateRec));
	    		}
	    		this.countryNameToStateMap.put(countryRec.Name__c, stateList);
	    	}
    	}
    }
}