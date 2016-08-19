/**
 * Author: Tarun Khandelwal
 * Since: Oct. 17, 2014
 * Name: CountryTriggerHelper
 * Description: Helper class for triggers on Country object(Used In Kendo)
**/
public with sharing class CountryTriggerHelper {
	
	// List to store trigger new list
	public static List<Country__c> countryNewList = new List<Country__c>();
	
	// List to store trigger old list
	public static List<Country__c> countryOldList = new List<Country__c>();
	
	// List to store trigger new Map
	public static Map<Id, Country__c> countryNewMap = new Map<Id, Country__c>();
	
	// List to store trigger old Map
	public static Map<Id, Country__c> countryOldMap = new Map<Id, Country__c>();
	
	// boolean variable to check if default field is to be updated
	public static boolean runDefaultCheckBoxUpdate = true;
	
	/**
     * Name: updateDefaultfield
     * Desc: Method to update default field of country
     * @param: 
     * @return: 
    **/
	public static void updateDefaultfield() {
		if(AccessControl.ifObjectFieldIsUpdateable('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('Country__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		if(runDefaultCheckBoxUpdate) {
			Boolean defaultFieldUpdated = false;
			for(Country__c country : countryNewList) {
				if(Trigger.isInsert) {
					if(country.Default__c && country.Visible__c) {
						defaultFieldUpdated = true;
					} else if(country.Default__c && !country.Visible__c){
						country.addError('You cannot make a Invisible Country As Default');
					}
				} else if(Trigger.isUpdate) {
					if( country.Default__c && (!countryOldMap.get(country.Id).Default__c) && country.Visible__c) {
						defaultFieldUpdated = true;
					} else if( country.Default__c && (!countryOldMap.get(country.Id).Default__c) && !country.Visible__c) {
						country.addError('You cannot make a Invisible Country As Default');
					} else if( !country.Default__c && (countryOldMap.get(country.Id).Default__c) && country.Visible__c) {
						country.addError('You cannot deselect a Default Country');
					} else if( country.Default__c && (countryOldMap.get(country.Id).Visible__c) && !country.Visible__c) {
						country.addError('You cannot deselect visible of a Default Country');
					} 
				} 
			}
			
			if(defaultFieldUpdated) {
				List<Country__c> countriesToBeUpdated = new List<Country__c>();
				List<Country__c> allCountries = [select Id, Default__c from Country__c where Default__c = true];
				
				for(Country__c country : allCountries) {
					country.Default__c = false;
					countriesToBeUpdated.add(country);
				}
				
				if(countriesToBeUpdated.size() > 0 ) {
					runDefaultCheckBoxUpdate = false;
					updateDefaultFieldOfOtherStates();
					update countriesToBeUpdated;
				}
			}
		}
	}
	
	/**
     * Name: updateDefaultFieldOfOtherStates
     * Desc: Method to deselect default field of other country's state if default country is changed
     * @param: 
     * @return: 
    **/
	private static void updateDefaultFieldOfOtherStates() {
		if(AccessControl.ifObjectFieldIsUpdateable('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		if(AccessControl.ifObjectFieldIsAccessible('State__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
		List<State__c> allStates = [select Id, Default__c from State__c where Default__c = true AND Country__c NOT IN :countryNewList];
		if(allStates.size() == 0) {
			return;
		}   
		 
		List<State__c> statesToBeUpdated = new List<State__c>();

		for(State__c state : allStates) {
			state.Default__c = false;
			statesToBeUpdated.add(state);
		}
		if(statesToBeUpdated.size() > 0) {
			update statesToBeUpdated;
		}
	}
	
	/**
     * Name: checkDefaultOnDelete
     * Desc: Method for not deleting the default country
     * @param: 
     * @return: 
    **/
	public static void checkDefaultOnDelete() {
		for(Country__c country : countryOldList) {
			if(country.Default__c) {
				country.addError('You cannot delete Country Marked as Default');
			}
		}
	}
}