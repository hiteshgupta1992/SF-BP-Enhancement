/**
 * Author: Tarun Khandelwal
 * Since: Jan. 10, 2015
 * Name: UnitModelOverviewCtrl
 * Description: Conroller class for UnitModelOverview page
**/
global with sharing class UnitModelOverviewCtrl {
	
    // Current page number mainly used as unique Id in page
	public String currentPN {get; private set;}
	
	// Unit Make Id
	public String unitMakeId {get; private set;}
    
    /**
     * Name: UnitModelOverviewCtrl 
     * Desc: Default constructor
     * @param: 
     * @return: 
    **/
    public UnitModelOverviewCtrl(){
    	currentPN = ApexPages.currentPage().getParameters().get('pageno');
    	if(currentPN != null) {
    		currentPN = String.escapeSingleQuotes(currentPN);
    	}
    	unitMakeId = ApexPages.currentPage().getParameters().get('Unit_Make_Id');
    	if(unitMakeId != null) {
    		unitMakeId = String.escapeSingleQuotes(unitMakeId);
    	}
    }
    
	/**
     * Name: getDropDownSelectedNumber
     * Desc: Method to get dropdown number at the time of loading of grid.
     * @param: 
     * @return: 
    **/
    public Integer getDropDownSelectedNumber() {
    	Integer dropDownSelectedNumber;
    	List<Customer_Page_Size__c> customerPageSize = SOQLUtil.getCustomerPageSize(); 
		if(customerPageSize.size() > 0) {
			dropDownSelectedNumber = (Integer)customerPageSize[0].Drop_Down_Number__c;
		}
		return dropDownSelectedNumber;
    }
    
    /**
     * Name: setCustomerCustomSetting
     * Desc: Method to initialize the the drop down number
     * @param: 
     * @return: PageReference
    **/
	public PageReference setCustomerCustomSetting() {
		if(AccessControl.ifObjectFieldIsCreateable('Customer_Page_Size__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
		if(AccessControl.ifObjectFieldIsUpdateable('Customer_Page_Size__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		
		List<Customer_Page_Size__c> customerPageSize = SOQLUtil.getCustomerPageSize();
		if(customerPageSize.size() > 0) {
			customerPageSize[0].Drop_Down_Number__c = getDropDownSelectedNumber();
			update customerPageSize;
		} else {
			Customer_Page_Size__c currentCustPageSize = new Customer_Page_Size__c();
			currentCustPageSize.User__c = UserInfo.getUserId();
			currentCustPageSize.Drop_Down_Number__c = getDropDownSelectedNumber();
			insert currentCustPageSize;
		}
		return null;
	}
}