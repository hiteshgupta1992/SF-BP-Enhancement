/**
 * Author: Tarun Khandelwal
 * Since: Oct. 17, 2014
 * Name: StateTriggerHelper
 * Description: Helper class for triggers on State object
**/
public with sharing class StateTriggerHelper {
	
	// List to store trigger new list
	public static List<State__c> stateNewList = new List<State__c>();
	
	// List to store trigger old list
	public static List<State__c> stateOldList = new List<State__c>();
	
	// List to store trigger new Map
	public static Map<Id, State__c> stateNewMap = new Map<Id, State__c>();
	
	// List to store trigger old Map
	public static Map<Id, State__c> stateOldMap = new Map<Id, State__c>();
	
	// Boolean to check if default field of state is to be updated 
	public static boolean runDefaultCheckBoxUpdate = true;
	
	/**
     * Name: updateDefaultfield
     * Desc: To update the default field of state record
     * @param:  
     * @return: 
    **/
	public static void updateDefaultfield() {
		if(runDefaultCheckBoxUpdate) {
			Boolean defaultFieldUpdated = false;
			for(State__c state : stateNewList) {
				if(Trigger.isInsert) {
					if(state.Default__c) {
						defaultFieldUpdated = true;
					} 
				} else if(Trigger.isUpdate) {
					if( state.Default__c && (!stateOldMap.get(state.Id).Default__c) ) {
						defaultFieldUpdated = true;
					} 
				} 
			}
			
			if(defaultFieldUpdated) {
				if(AccessControl.ifObjectFieldIsUpdateable('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
				List<State__c> statesToBeUpdated = new List<State__c>();
				List<State__c> allStates = [select Id, Default__c from State__c where Default__c = true];
				
				for(State__c state : allStates) {
					state.Default__c = false;
					statesToBeUpdated.add(state);
				}
				
				if(statesToBeUpdated.size() > 0 ) {
					runDefaultCheckBoxUpdate = false;
					update statesToBeUpdated;
				}
			}
		}
	}
	
	/**
     * Name: checkDefaultOnDelete
     * Desc: Method not to delete the default state.
     * @param:  
     * @return: 
    **/
	public static void checkDefaultOnDelete() {
		for(State__c state : stateOldList) {
			if(state.Default__c) {
				state.addError('You cannot delete State Marked as Default');
			}
		}
	}
}