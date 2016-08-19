/**
 * Author: Tarun Khandelwal
 * Since: May 26, 2015
 * Name: UnitMake
 * Description: Apex class to handle JSON related oprations of UnitMake object.
**/
public with sharing class UnitMake {
	
	// Id
	public String Id;
	
	// Name
	public String UnitMakeName;
	
	// Constructor
    public UnitMake(Unit_Make__c UnitMakeRec) {
    	this.UnitMakeName = UnitMakeRec.Name ;
    	this.Id = UnitMakeRec.Id;
    }
    
    /**
     * Name: fieldsList
     * Desc: Method Which contains all the field list to be quried
     * @param:  
     * @return: List<String> - Fields List
    **/
    public static List<String> fieldsList(){
        List<String> unitMakeFields = new List<String>{ 'Id',
	                                                    'Name'
                                               		 };
        return unitMakeFields;
    }
}