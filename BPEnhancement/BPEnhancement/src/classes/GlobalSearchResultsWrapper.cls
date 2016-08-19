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
		public String AdditionalInfoLabel1;
		public String AdditionalInfoLabel2;
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
				if(((searchedObj.get(Constants.NAMESPACE +'Is_Customer__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Customer__c')) : null) == 'true') {
					this.Type = 1;
					this.ObjectName = 'Customer';
				} else if(((searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c')) : null) == 'true') {
					this.Type = 2;
					this.ObjectName = 'Vendor';
				}
				
				this.Id = String.valueOf(searchedObj.get('Id'));
				this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
				this.AdditionalInfoLabel1 = 'Email';
				this.AdditionalInfoLabel2 = 'Phone';
				
				if(searchedObj.get(Constants.NAMESPACE +'Preferred_Email__c') != '' && searchedObj.get(Constants.NAMESPACE +'Preferred_Email__c') != null) {
					this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Preferred_Email__c'));
				} else if(searchedObj.get(Constants.NAMESPACE +'Work_Email__c') != '' && searchedObj.get(Constants.NAMESPACE +'Work_Email__c') != null) {
					this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Work_Email__c'));
				} else {
					if(((searchedObj.get(Constants.NAMESPACE +'Is_Customer__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Customer__c')) : null) == 'true') {
						if(searchedObj.get(Constants.NAMESPACE +'Email__c') != '' && searchedObj.get(Constants.NAMESPACE +'Email__c') != null) {
							this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Email__c'));
						} else if(searchedObj.get(Constants.NAMESPACE +'Other_Email__c') != '' && searchedObj.get(Constants.NAMESPACE +'Other_Email__c') != null) {
							this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Other_Email__c'));
						}
					} else if(((searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c')) : null) == 'true') {
						if(searchedObj.get(Constants.NAMESPACE +'Other_Email__c') != '' && searchedObj.get(Constants.NAMESPACE +'Other_Email__c') != null) {
							this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Other_Email__c'));
						}
					}
				} 
				
				if(searchedObj.get(Constants.NAMESPACE +'Preferred_Phone__c') != '' && searchedObj.get(Constants.NAMESPACE +'Preferred_Phone__c') != null) {
					this.AdditionalInfo2 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Preferred_Phone__c'));
				} else if(searchedObj.get(Constants.NAMESPACE +'Work_Number__c') != '' && searchedObj.get(Constants.NAMESPACE +'Work_Number__c') != null) {
					this.AdditionalInfo2 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Work_Number__c'));
				} else {
					if(((searchedObj.get(Constants.NAMESPACE +'Is_Customer__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Customer__c')) : null) == 'true') { 
						if(searchedObj.get(Constants.NAMESPACE +'Home_Number__c') != '' && searchedObj.get(Constants.NAMESPACE +'Home_Number__c') != null) {
							this.AdditionalInfo2 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Home_Number__c'));
						} else if(searchedObj.get(Constants.NAMESPACE +'Mobile__c') != '' && searchedObj.get(Constants.NAMESPACE +'Mobile__c') != null) {
							this.AdditionalInfo2 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Mobile__c'));
						}
					} else if(((searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Is_Vendor__c')) : null) == 'true') {
						if(searchedObj.get(Constants.NAMESPACE +'Mobile__c') != '' && searchedObj.get(Constants.NAMESPACE +'Mobile__c') != null) {
							this.AdditionalInfo2 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Mobile__c'));
						}
					}
				}
				
	    	} else if(objName == Constants.NAMESPACE + 'Part__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 3;
	    		this.ObjectName = 'Part';
	    		this.ItemName = ((searchedObj.get(Constants.NAMESPACE +'Part_Number__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Part_Number__c')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		//this.AdditionalInfo1 = String.valueOf(searchedObj.get(Constants.NAMESPACE +'Qty_In_Stock__c'));
	    		this.AdditionalInfo1 = (searchedObj.get(Constants.NAMESPACE +'Qty_In_Stock__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Qty_In_Stock__c')) : null;
	    		//this.AdditionalInfo2 = '';
	    		this.AdditionalInfoLabel1 = 'Qty Available';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Kit_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 4;
	    		
	    		this.ItemName = ((searchedObj.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Code__c')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		if(((searchedObj.get(Constants.NAMESPACE +'Service_Kit__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Service_Kit__c')) : null) == 'true') {
	    			this.AdditionalInfo1 = 'Service';
	    			this.ObjectName = 'Service Kit';
	    		} else {
	    			this.AdditionalInfo1 = 'General';
	    			this.ObjectName = 'Kit';
	    		}
	    		this.AdditionalInfoLabel1 = 'Type';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Fee__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 5;
	    		this.ObjectName = 'Fee';
	    		this.ItemName = ((searchedObj.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Code__c')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		this.AdditionalInfo1 = '$'+ ((searchedObj.get(Constants.NAMESPACE +'Price__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Price__c')) : null);
	    		this.AdditionalInfoLabel1 = 'Price';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Labour_Code__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 6;
	    		this.ObjectName = 'Labor Code';
	    		this.ItemName = ((searchedObj.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Code__c')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		this.AdditionalInfo1 = (searchedObj.get(Constants.NAMESPACE +'Hours__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Hours__c')) : null;
	    		this.AdditionalInfoLabel1 = 'Hours'; 
	    		
	    	} else if(objName == 'User') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 7;
	    		this.ObjectName = 'User';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.get('Email') != null) ? String.valueOf(searchedObj.get('Email')) : null;
	    		this.AdditionalInfo2 = (searchedObj.get('Phone') != null) ? String.valueOf(searchedObj.get('Phone')) : null;
	    		this.AdditionalInfoLabel1 = 'Email';
	    		this.AdditionalInfoLabel2 = 'Phone';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'CO_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 8;
	    		this.ObjectName = 'Customer Order';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'Customer__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'Customer__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Customer Name';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'CO_Invoice_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 9;
	    		this.ObjectName = 'Customer Invoice';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'CO_Header__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Customer__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'CO_Header__r').getSObject(Constants.NAMESPACE +'Customer__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Customer Name';
	    		  
	    	} else if(objName == Constants.NAMESPACE + 'Vendor_Order_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 10;
	    		this.ObjectName = 'Vendor Order';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'Vendor__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Vendor Name';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Vendor_Receiving_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 11;
	    		this.ObjectName = 'Vendor Receiving';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'Vendor__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Vendor Name';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Vendor_Invoicing_Header__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 12;
	    		this.ObjectName = 'Vendor Invoice';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'Vendor__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Vendor Name';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Category__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 13;
	    		this.ObjectName = 'Item Category';
	    		this.ItemName = ((searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		this.AdditionalInfo1 = (searchedObj.get(Constants.NAMESPACE +'Type__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Type__c')) : null;
	    		this.AdditionalInfoLabel1 = 'Category Type';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Price_Level__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 14;
	    		this.ObjectName = 'Price Level';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = ((searchedObj.get(Constants.NAMESPACE +'Discount_Markup__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Discount_Markup__c')) : null)+ '%';
	    		this.AdditionalInfoLabel1 = 'Discount Markup';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Sales_Tax__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 15;
	    		this.ObjectName = 'Sales Tax';
	    		this.ItemName = (searchedObj.get(Constants.NAMESPACE +'Name__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Name__c')) : null;
	    		this.AdditionalInfo1 = ((searchedObj.get(Constants.NAMESPACE +'Rate__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Rate__c')) : null)+ '%';
	    		this.AdditionalInfoLabel1 = 'Rate';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'Product__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 16;
	    		this.ObjectName = 'Sublet';
	    		this.ItemName = ((searchedObj.get(Constants.NAMESPACE +'Code__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Code__c')) : null) + ' - ' + ((searchedObj.get(Constants.NAMESPACE +'Description__c') != null) ? String.valueOf(searchedObj.get(Constants.NAMESPACE +'Description__c')) : null);
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Vendor__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'Vendor__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Vendor Name';
	    		
	    	} else if(objName == Constants.NAMESPACE + 'CO_Invoice_Payment__c') {
	    		this.Id = String.valueOf(searchedObj.get('Id'));
	    		this.Type = 17;
	    		this.ObjectName = 'Customer Payment';
	    		this.ItemName = (searchedObj.get('Name') != null) ? String.valueOf(searchedObj.get('Name')) : null;
	    		this.AdditionalInfo1 = (searchedObj.getSobject(Constants.NAMESPACE +'CO_Invoice_Header__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'CO_Header__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Customer__r') != null && searchedObj.getSobject(Constants.NAMESPACE +'Customer__r').get('Name') != null) ? String.valueOf(searchedObj.getSObject(Constants.NAMESPACE +'CO_Invoice_Header__r').getSObject(Constants.NAMESPACE +'CO_Header__r').getSObject(Constants.NAMESPACE +'Customer__r').get('Name')) : null;
	    		this.AdditionalInfoLabel1 = 'Customer Name';
	    		
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