/**
 * Author: Richa Mittal
 * Since: August 12, 2016
 * Name: GlobalSearchResultsWrapper
 * Description: Class is used for the Creating Json For Search Results
**/
public with sharing class GlobalSearchResultsWrapper {
    
    
    public Integer TotalRecords;
    public List<GlobalSearchRecordWrapper> searchRecords;
    
    public GlobalSearchResultsWrapper(Integer TotalRecords, List<Sobject> searchedObjList){
    	this.TotalRecords = TotalRecords;
    	this.searchRecords = new List<GlobalSearchRecordWrapper>();
    	for(Sobject sObj : searchedObjList) {
    		this.searchRecords.add(new GlobalSearchRecordWrapper(sObj));
    	}
    }
    
    public class GlobalSearchRecordWrapper{
	    public String Id;
	    public Integer Type;
	    public String ObjectName;
		public String AdditionalInfo1;
		public String AdditionalInfo2;
		public String ItemName;
		
		/**
		 * Name:GlobalSearchResultsWrapper 
		 * Description: Constructor
		**/
		public GlobalSearchRecordWrapper(Sobject searchedObj) {
			
			/*Type = Type;
			AdditionalInfo1 = Email;
			AdditionalInfo2 = Phone_No;
			ItemName = Name;*/
			
			String objName = String.valueOf(searchedObj.getSObjectType());
			
			
			if(objName == 'Account') {
				if(String.valueOf(searchedObj.get('Is_Customer__c')) == 'true') {
					this.Type = 1;
					this.ObjectName = 'Customer';
				} else if(String.valueOf(searchedObj.get('Is_Vendor__c')) == 'true') {
					this.Type = 2;
					this.ObjectName = 'Vendor';
				}
				
				this.Id = String.valueOf(searchedObj.get('Id'));
				this.ItemName = String.valueOf(searchedObj.get('Name'));
				
				if(String.valueOf(searchedObj.get('Preferred_Email__c')) != '' && String.valueOf(searchedObj.get('Preferred_Email__c')) != null) {
					this.AdditionalInfo1 = String.valueOf(searchedObj.get('Preferred_Email__c'));
				} else if(String.valueOf(searchedObj.get('Work_Email__c')) != '' && String.valueOf(searchedObj.get('Work_Email__c')) != null) {
					this.AdditionalInfo1 = String.valueOf(searchedObj.get('Work_Email__c'));
				} else if(String.valueOf(searchedObj.get('Is_Customer__c')) == 'true') {
					if(String.valueOf(searchedObj.get('Email__c')) != '' && String.valueOf(searchedObj.get('Email__c')) != null) {
						this.AdditionalInfo1 = String.valueOf(searchedObj.get('Email__c'));
					}
				} else if(String.valueOf(searchedObj.get('Other_Email__c')) != '' && String.valueOf(searchedObj.get('Other_Email__c')) != null) {
					this.AdditionalInfo1 = String.valueOf(searchedObj.get('Other_Email__c'));
				}
				
				if(String.valueOf(searchedObj.get('Preferred_Phone__c')) != '' && String.valueOf(searchedObj.get('Preferred_Phone__c')) != null) {
					this.AdditionalInfo2 = String.valueOf(searchedObj.get('Preferred_Phone__c'));
				} else if(String.valueOf(searchedObj.get('Work_Number__c')) != '' && String.valueOf(searchedObj.get('Work_Number__c')) != null) {
					this.AdditionalInfo2 = String.valueOf(searchedObj.get('Work_Number__c'));
				} else if(String.valueOf(searchedObj.get('Is_Customer__c')) == 'true') { 
					if(String.valueOf(searchedObj.get('Home_Number__c')) != '' && String.valueOf(searchedObj.get('Home_Number__c')) != null) {
						this.AdditionalInfo2 = String.valueOf(searchedObj.get('Home_Number__c'));
					} 
				}else if(String.valueOf(searchedObj.get('Mobile__c')) != '' && String.valueOf(searchedObj.get('Mobile__c')) != null) {
					this.AdditionalInfo2 = String.valueOf(searchedObj.get('Mobile__c'));
				}
				
	    	} else if(objName == 'Part__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 3;
	    		this.ObjectName = 'Part';
	    		this.ItemName = String.valueOf(searchedObj.get('Part_Number__c')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Qty_In_Stock__c'));
	    		//this.AdditionalInfo2 = '';
	    	} else if(objName == 'Kit_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 4;
	    		
	    		this.ItemName = String.valueOf(searchedObj.get('Code__c')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		if(String.valueOf(searchedObj.get('Service_Kit__c')) == 'true') {
	    			this.AdditionalInfo1 = 'Service';
	    			this.ObjectName = 'Service Kit';
	    		} else {
	    			this.AdditionalInfo1 = 'General';
	    			this.ObjectName = 'Kit';
	    		}
	    	} else if(objName == 'Fee__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 5;
	    		this.ObjectName = 'Fee';
	    		this.ItemName = String.valueOf(searchedObj.get('Code__c')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Price__c'));
	    	} else if(objName == 'Labour_Code__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 6;
	    		this.ObjectName = 'Labor Code';
	    		this.ItemName = String.valueOf(searchedObj.get('Code__c')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Hours__c'));
	    	} else if(objName == 'User') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 7;
	    		this.ObjectName = 'User';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Email'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Phone'));
	    	} else if(objName == 'CO_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 8;
	    		this.ObjectName = 'Customer Order';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('Customer__r').get('Name')); //
	    	} else if(objName == 'CO_Invoice_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 9;
	    		this.ObjectName = 'Customer Invoice';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('CO_Header__r').getSObject('Customer__r').get('Name')); //  
	    	} else if(objName == 'Vendor_Order_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 10;
	    		this.ObjectName = 'Vendor Order';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('Vendor__r').get('Name')); //
	    	} else if(objName == 'Vendor_Receiving_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 11;
	    		this.ObjectName = 'Vendor Receiving';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('Vendor__r').get('Name')); //
	    	} else if(objName == 'Vendor_Invoicing_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 12;
	    		this.ObjectName = 'Vendor Invoice';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('Vendor__r').get('Name')); //
	    	} else if(objName == 'Category__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 13;
	    		this.ObjectName = 'Item Category';
	    		this.ItemName = String.valueOf(searchedObj.get('Name')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Type__c'));
	    	} else if(objName == 'Price_Level__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 14;
	    		this.ObjectName = 'Price Level';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Discount_Markup__c'));
	    	} else if(objName == 'Sales_Tax__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 15;
	    		this.ObjectName = 'Sales Tax';
	    		this.ItemName = String.valueOf(searchedObj.get('Name__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.get('Rate__c'));
	    	} else if(objName == 'Product__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 16;
	    		this.ObjectName = 'Sublet';
	    		this.ItemName = String.valueOf(searchedObj.get('Code__c')) + ' - ' + String.valueOf(searchedObj.get('Description__c'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('Vendor__r').get('Name')); //
	    	} else if(objName == 'CO_Invoice_Payment__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 17;
	    		this.ObjectName = 'Customer Payment';
	    		this.ItemName = String.valueOf(searchedObj.get('Name'));
	    		this.AdditionalInfo1 = String.valueOf(searchedObj.getSObject('CO_Invoice_Header__r').getSObject('CO_Header__r').getSObject('Customer__r').get('Name')); //
	    	}
			
		}
    }	
	/**
     * Name: GlobalQueryJSON
     * Description: Class to represent global search query JSON
    **/
    public class GlobalQueryJSON {
        // Object label selected by user to search in
        public String GlobalSearchKeyword {get; set;}
        
        // Search text
        public String GlobalSearchText {get; set;}
        
    }
}