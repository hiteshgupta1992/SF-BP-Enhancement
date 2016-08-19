public with sharing class Timezone {
    // Id
    public String Id;
    
    // Display label
    public String Label;
    
    // Name
    public String Name;
    
    // Country Id
    public String CountryId;
    
    // State Id
    public String StateId;
    
    // Time sift value
    public decimal TimeShift;
    
    // Constructor
    public Timezone(Timezone__c timezoneRec) {
        this.Id = timezoneRec.Id;
        this.Label = timezoneRec.Timezone_Label__c;
        this.Name = timezoneRec.Tz_Name__c;
        this.CountryId = timezoneRec.Country__c;
        this.StateId = timezoneRec.State__c;
        this.TimeShift = timezoneRec.Time_Shift__c;
    }
    
    /**
     * Name: fieldsList
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> timzoneFieldsList = new List<String>{  'Country__c',
                                                        'State__c', 
                                                        'Timezone_Label__c',
                                                        'Time_Shift__c',
                                                        'Tz_Name__c'
                                                    };
        return timzoneFieldsList;
    }
}