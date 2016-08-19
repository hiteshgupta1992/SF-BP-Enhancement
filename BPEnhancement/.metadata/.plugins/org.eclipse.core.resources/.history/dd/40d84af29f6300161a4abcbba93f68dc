/**
 * Author: Tarun Khandelwal
 * Since: May 25, 2015
 * Name: State
 * Description: Apex class to handle JSON related oprations of State object.
**/
public with sharing class State {
        
    // State Name
    public String StateName;
    
    // Default
    public Boolean IsDefault;
    
    // Id
    public String Id;
    
    // Id
    public String contryId;
    
    // Timezone
    public Timezone StateTimezone;
    
    // Constructor
    public State(State__c stateRec) {
        this.StateName = stateRec.Name__c;
        this.IsDefault = stateRec.Default__c;
        this.Id = stateRec.Id;
        this.contryId = stateRec.Country__c;
    }
    
    // Constructor
    public State(State__c stateRec, Timezone StateTimezone) {
        this.StateName = stateRec.Name__c;
        this.IsDefault = stateRec.Default__c;
        this.Id = stateRec.Id;
        this.contryId = stateRec.Country__c;
        this.StateTimezone = StateTimezone;
    }
        
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> stateFields = new List<String>{ 'Id',
                                                    'Name__c', 
                                                    'Default__c',
                                                    'Country__c'
                                                };
        return stateFields;
    }   
        
        
    
}