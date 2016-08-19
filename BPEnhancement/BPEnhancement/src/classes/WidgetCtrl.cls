global with sharing class WidgetCtrl {
    
    public static string StatusValue = 'Open';
    
    @RemoteAction
    global static String getWidgetRecord() {
    	try{
	        String UserId = UserInfo.getUserId();
	        Map<String, String> fieldNameToFieldValueMap = new Map<String, String>();
	        fieldNameToFieldValueMap.put('User__c', UserId);
	        
	        List<Widget_User_Junction__c> widgetUserJunctionList = SOQLUtil.getWidgetRecords(fieldNameToFieldValueMap);
	        
	        List<WidgetWrapper> widgetWrapperList = new List<WidgetWrapper>();
	        for(Widget_User_Junction__c widUserJunRec : widgetUserJunctionList) {
	            widgetWrapperList.add(new WidgetWrapper(widUserJunRec));
	        }
	        return BPUtility.getEncodedString(System.Json.serialize(widgetWrapperList));
    	}catch(exception ex){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
    	} 
    }
    
    @RemoteAction
    global static String showHideWidget( String widgetJunctionId , boolean isVisible ) {
  	  widgetJunctionId = BPUtility.getDecodedString(widgetJunctionId);
        
  	  try{	
	        Widget_User_Junction__c widgetUserJunctionObject = null;
	        String UserId = UserInfo.getUserId();
	        if(isVisible == false){
	            widgetUserJunctionObject = new Widget_User_Junction__c(Id = widgetJunctionId, Is_Visible__c = false, WidgetOrder__c = null);
	            if(AccessControl.ifObjectIsUpdateable(widgetUserJunctionObject) == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}	 
	            Integer counter = 1;
	            Map<String, String> fieldNameToFieldValueMap = new Map<String, String>();
	            fieldNameToFieldValueMap.put('User__c', UserId);
	            List<Widget_User_Junction__c> widgetUserJunctionList =  SOQLUtil.getWidgetRecords(fieldNameToFieldValueMap); 
	            List<Widget_User_Junction__c> widgetUserJunctionListToUpdate = new List<Widget_User_Junction__c>();
	            for(Widget_User_Junction__c widChangedJsonRec : widgetUserJunctionList) {
	                widgetUserJunctionListToUpdate.add(new Widget_User_Junction__c(Id = widChangedJsonRec.Id, WidgetOrder__c = counter++));
	            }
	            if(AccessControl.ifObjectIsUpdateable('Widget_User_Junction__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	            update widgetUserJunctionListToUpdate;
	            
	        } else {
	            if(AccessControl.ifObjectIsUpdateable('Widget_User_Junction__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	            if(AccessControl.ifObjectFieldIsAccessible('Widget_User_Junction__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	            Integer counter = [SELECT COUNT() FROM Widget_User_Junction__c WHERE  WidgetOrder__c != NULL AND Is_Visible__c = true ];
	            widgetUserJunctionObject = new Widget_User_Junction__c(Id = widgetJunctionId, Is_Visible__c = isVisible, WidgetOrder__c =  ++counter);
	          	if(AccessControl.ifObjectIsUpdateable('Widget_User_Junction__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	            update widgetUserJunctionObject;
	        }
	        
        return getWidgetRecord();
  	  }catch(exception ex){
  		  throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
  		  return BPUtility.getEncodedString('');
  	  }
    }
    
    @RemoteAction
    global static String widgetOrderUpdate( String changedOrderJson ) {
    	changedOrderJson = BPUtility.getDecodedString(changedOrderJson);
      
    	try{
	        Integer counter = 1;
	        System.debug(changedOrderJson);
	        List<WidgetWrapper> widgetChangeWrapperList = (List<WidgetWrapper>) System.JSON.deserialize(changedOrderJson, List<WidgetWrapper>.class);
	        List<Widget_User_Junction__c> widgetUserJunctionList = new List<Widget_User_Junction__c>();
	        
	        for(WidgetWrapper widChangedJsonRec : widgetChangeWrapperList) {
	            widgetUserJunctionList.add(new Widget_User_Junction__c(Id = widChangedJsonRec.Id, WidgetOrder__c = counter++));
	        }
	       	if(AccessControl.ifObjectIsUpdateable('Widget_User_Junction__c') == false){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        update widgetUserJunctionList;
	        return getWidgetRecord();
    	}catch(exception ex){
  		  throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
  		  return BPUtility.getEncodedString('');
  	  }
    }
    
    @RemoteAction
     global static String getCustomerOrderWidgetUpdate() {
        try{
	        String UserId = UserInfo.getUserId();
	        Map<String, String> fieldNameToFieldValueMap = new Map<String, String>();
	        fieldNameToFieldValueMap.put('owner__c', UserId);
	        List<CO_Header__c> customerOrderRecordsList = SOQLUtil.getCustomerOrderWidgetRecords(fieldNameToFieldValueMap);
	        Integer activeCustomerOrderRecords = customerOrderRecordsList.size();
	        Integer updatedCustomerOrderRecords = 0;
	        
	         List<CO_Header__c> customerOrderUpdatedList = SOQLUtil.getCustomerOrderUpdatedRecords(fieldNameToFieldValueMap);
	        for(CO_Header__c  coHeaderRec : customerOrderUpdatedList){
	            if((coHeaderRec.LastModifiedDate > coHeaderRec.Owner_Last_Visited__c ) && (coHeaderRec.LastModifiedById != coHeaderRec.owner__c )){
	                updatedCustomerOrderRecords++;
	            }
	        }
	        List<Vendor_Order_Header__c> vendorOrderActiveRecordList = SOQLUtil.getVendorOrderWidgetRecords(fieldNameToFieldValueMap);
	        Integer activevendorOrderActiveRecord = vendorOrderActiveRecordList.size();
	        List<Vendor_Receiving_Header__c> vendorRecievingActiveRecordList = SOQLUtil.getVendorRecievingWidgetRecords(fieldNameToFieldValueMap);
	        Integer activevendorRecievingActiveRecord = vendorRecievingActiveRecordList.size();
	        List<Vendor_Invoicing_Header__c> vendorInvoicingActiveRecordList = SOQLUtil.getVendorInvoicingWidgetRecords(fieldNameToFieldValueMap);
	        Integer activevendorInvoicingActiveRecord = vendorInvoicingActiveRecordList.size();
	        
	        return  BPUtility.getEncodedString(System.Json.serialize(new CustomerOrderWidgetWrapper(activeCustomerOrderRecords, updatedCustomerOrderRecords, activevendorOrderActiveRecord, activevendorRecievingActiveRecord, activevendorInvoicingActiveRecord)));
        }catch(exception ex){
  		  throw new BlackPurlException(BlackPurlException.getErrorMessage(ex.getMessage(), ex.getStackTraceString()));
  		  return BPUtility.getEncodedString('');
  	  	}  
     }
    
    
    
    
    public class WidgetWrapper{
        public String Id;
        public String WidgetId;
        public String WidgetName;  
        public Decimal WidgetOrder; 
        public Boolean IsVisible;
        
        public WidgetWrapper(Widget_User_Junction__c widgetUserJunctionRec) {
            this.Id = widgetUserJunctionRec.Id;
            this.WidgetId = widgetUserJunctionRec.Widget__r.Name;
            this.WidgetName = widgetUserJunctionRec.Widget__r.Widget_Name__c;
            this.IsVisible = widgetUserJunctionRec.Is_Visible__c;
            this.WidgetOrder = widgetUserJunctionRec.WidgetOrder__c;
        }
        
    }
    
    
    
    public class CustomerOrderWidgetWrapper{
        public Integer CountActiveOrder;
        public Integer UpdatedCutsomerOrder;
        public Integer CountActiveVendorOrder;
        public Integer CountActiveVendorInvoicing;
        public Integer CountActiveVendorRecieving;
        
        public  CustomerOrderWidgetWrapper(Integer CountOrder, Integer updatedCustomerOrder, Integer CountActiveVendorOrder, Integer CountActiveVendorRecieving, Integer CountActiveVendorInvoicing )
        {
            this.CountActiveOrder =  CountOrder;
            this.UpdatedCutsomerOrder = updatedCustomerOrder;
            this.CountActiveVendorOrder = CountActiveVendorOrder;
            this.CountActiveVendorInvoicing = CountActiveVendorInvoicing;
            this.CountActiveVendorRecieving = CountActiveVendorRecieving;
        }
    }
}