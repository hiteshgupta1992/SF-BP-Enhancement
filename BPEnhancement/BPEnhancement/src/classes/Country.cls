/**
 * Author: Tarun Khandelwal
 * Since: May 25, 2015
 * Name: Country
 * Description: Apex class to handle JSON related oprations of Country object. (Used In Kendo)
**/
public with sharing class Country {
    
    // Country Name
    public String CountryName;
    
    // Default
    public Boolean IsDefault;
    
    // Id
    public String Id;
    
    // States list for the country
    public List<State> StateList;
    
    // Timezone for the country
    public List<Timezone> TimezoneList;
    
    // Constructor
    public Country(Country__c countryRec) {
        this.CountryName = countryRec.Name__c;
        this.IsDefault = countryRec.Default__c;
        this.Id = countryRec.Id;
        
        Map<Id, Timezone> stateTimeZonesMap = new Map<Id, Timezone>();
        this.TimezoneList = new List<Timezone>();
        if(countryRec.TimeZones__r != null) {
            for(Timezone__c tz : countryRec.TimeZones__r) {
                Timezone timeZ = new Timezone(tz);
                this.TimezoneList.add(timeZ);
                stateTimeZonesMap.put(tz.State__c, timeZ);
            }
        }
          
        this.StateList = new List<State>();
        if(countryRec.States__r != null) {
            for(State__c state : countryRec.States__r) {
                this.StateList.add(new State(state, stateTimeZonesMap.get(state.Id)));
            }
        }
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> countryFields = new List<String>{ 'Id',
                                                    'Name__c', 
                                                    'Default__c',
                                                    'Visible__c'
                                                };
        return countryFields;
    }
}