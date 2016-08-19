/**
* Author: Ashish Garg
* Since: Nov 20, 2015
* Name: ViewLabourCtrl
* Description: Apex class which contains all remoted methods related to View Labour page
**/
global with sharing class ViewLabourCtrl {
	
	
	public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}

	/**
     * Name: getDefaultLabourData  
     * Desc: Get default data for new Labour records
     * @param:  (1)
     * @return: String - Labour JSON String.
    **/
    @remoteAction
    global static String getDefaultLabourData() {
        try{
            List<Category__c> defaultFeeCategories = SOQLUtil.getDefaultCategoryRecords(new Map<String, String>{'Type__c' => 'Labour', 'Status__c' => 'Active'});
            if(defaultFeeCategories.size() > 0) {
                Category__c defaultCategory = defaultFeeCategories[0];
                
                Labour_Code__c newLabourCode;
                LabourRecord newLabour = new LabourRecord(newLabourCode);
                newLabour.LabourCategory = new LabourRecord.Category(defaultCategory);
                newLabour.LabourTaxable = true;
                return BPUtility.getEncodedString(System.JSON.serialize(newLabour));
            }
        }
        catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        
        return BPUtility.getEncodedString('{}');
    }
    
    /**
     * Name: getLabourDetails
     * Desc: Method to return all related data as per Labour Id
     * @param:  (1) labourId - Id - Id for related labour record
     *			(2)activeOrderPageSortAttrsJSON- String - sort attributes of active order
     * @return: String - JSON String
    **/
    @RemoteAction
    global static String getLabourDetails(String labourId, String activeOrderPageSortAttrsJSON){
    	try{
    		labourId = BPUtility.getDecodedString(labourId);
    		activeOrderPageSortAttrsJSON = BPUtility.getDecodedString(activeOrderPageSortAttrsJSON);
    		
    		PaginationSorting activeOrderPageSortAttrs = PaginationSorting.parsePageAttrs(activeOrderPageSortAttrsJSON);
    	
        	List<Service_Order_Line_Item__c> soliList = SOQLUtil.getActiveOrders(labourId);
        	LabourHeaderWrapper labourHeader = new LabourHeaderWrapper(labourId, soliList, activeOrderPageSortAttrs);
        
        	return BPUtility.getEncodedString(System.JSON.serialize(labourHeader));
    	}
    	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}');
    }
    
    /**
     * Name: getApplicableTaxList
     * Desc: To get Labour Details on Edit Labour Pop Up window
     * @param: 
     * @return: String - JSON string of Part info. 
    **/
    @RemoteAction
    global static String getApplicableTaxList() {
        String defaultLaborTaxId = Configurations__c.getOrgDefaults().Default_Tax_on_Labor__c;
        return BPUtility.getEncodedString(TaxUtility.getApplicableList(defaultLaborTaxId));
    }
    
    /**
     * Name: saveLabour
     * Desc: To save Labour Record in database 
     * @param: (1) labourJSONString - String - JSON String of Labour Record
     * @return: String - Id of Inserted or updated Labour Record. 
    **/
    @RemoteAction
    global static String saveLabour(String labourJSONString) {
    	try{
    		labourJSONString = BPUtility.getDecodedString(labourJSONString);
    		
    		List<LabourRecord> LabourRecords = LabourRecord.parse(labourJSONString);
	        List<Labour_Code__c> labourRecordsToDML = new List<Labour_Code__c>();
	        for(LabourRecord labourObj : LabourRecords) {
	            Labour_Code__c labourRec = new Labour_Code__c(  Active__c = (labourObj.LabourStatus != null) ? labourObj.LabourStatus : false,
	                                                            Category__c = (labourObj.LabourCategory != null && labourObj.LabourCategory.Id != null) ? labourObj.LabourCategory.Id : null,
	                                                            Code__c = labourObj.LabourCode,
	                                                            CO_Header__c = null,
	                                                            Description__c = labourObj.LabourDescription,
	                                                            Fixed_Rate__c = (labourObj.LabourFixedRate != null) ? labourObj.LabourFixedRate : false,
	                                                            Hours__c = (labourObj.LabourHours != null) ? Decimal.valueOf(labourObj.LabourHours) : 0,
	                                                            Name__c = labourObj.LabourDescription,
	                                                            Rate__c = (labourObj.LabourRate != null) ? Decimal.valueOf(labourObj.LabourRate) : 0,
	                                                            Taxable__c = (labourObj.LabourTaxable != null) ? labourObj.LabourTaxable : false
	                                                        );
	            if(labourRec.Taxable__c) {
	            	labourRec.Applicable_Tax__c = labourObj.ApplicableTaxId;
	            } else {
	            	labourRec.Applicable_Tax__c = null;
	            }
	            if(labourObj.Id != null) {
	                labourRec.Id = labourObj.Id;
	            }
	            labourRecordsToDML.add(labourRec);
	        }
	
	        if(labourRecordsToDML.size() > 0) {
	        	if(AccessControl.ifObjectIsUpdateable('Labour_Code__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        	if(AccessControl.ifObjectIsCreateable('Labour_Code__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	            try{
	            	upsert labourRecordsToDML;
            	}catch(exception e){ 
	        		if(e.getMessage().contains('duplicate value found: Code__c duplicates value')){
	        			throw new BlackPurlException('This Code already exists, please enter unique code');
	        		}
	       		}
	            return BPUtility.getEncodedString(labourRecordsToDML[0].Id);
	        }
	        return BPUtility.getEncodedString(null);
    	}
        catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}');
    }
    
    /**
     * Name: getSimilarLabourRecords
     * Desc: Method to return all similar labour records
     * @param:  (1) labourCode - String - Code value by which to search
     *          (2) labourDescription - String - Description value by which to search
     * @return: String - JSON String  
    **/
    @RemoteAction
    global static String getSimilarLabourRecords(String labourCode, String labourDescription){
    	try{
    		labourCode = BPUtility.getDecodedString(labourCode);
    		labourDescription = BPUtility.getDecodedString(labourDescription);
    		
    		List<LabourRecord> SimilarLabourRecords = new List<LabourRecord>();
        
	        // Get list of similar labour code records
	        List<Labour_Code__c> labourCodeRecords = SOQLUtil.getSimilarLabourRecords(labourCode, labourDescription);
	        for(Labour_Code__c labourCodeRecord : labourCodeRecords){
	            if(labourCodeRecord.Code__c.equalsIgnoreCase(labourCode)) {
	        		SimilarLabourRecords.add(new LabourRecord(labourCodeRecord, 1));
	        	}
	        	else {
	            	SimilarLabourRecords.add(new LabourRecord(labourCodeRecord, 2));
	        	}
	        }
	        
	        return BPUtility.getEncodedString(System.JSON.serialize(SimilarLabourRecords));
    	}
    	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('{}');
       
    }
    
     /**
     * Name: getPaginatedRecords
     * Desc: Getting Records According  to required page
     * @param:  (1) allrecords - List<ViewLabourCtrl.ActiveOrder> - List of Active Order
     *          (2) labourDescription - String - Description value by which to search
     *			(3) currentPage - Integer - Current Page Number
     *			(4) pageSize - Integer - No Of Records in a page
     * @return: List<ViewLabourCtrl.ActiveOrder> - List of Active Order
    **/
    public static List<ViewLabourCtrl.ActiveOrder> getPaginatedRecords(List<ViewLabourCtrl.ActiveOrder> allrecords, Integer currentPage, integer pageSize) {
    	try{
    		List<ViewLabourCtrl.ActiveOrder> objRecords = new List<ViewLabourCtrl.ActiveOrder>();
    	if(currentPage == null || currentPage == 0){
    		currentPage = 1;
    	}
    	if(pageSize == null || pageSize == 0){
    		pageSize = (Integer) General_Configurations__c.getInstance().Related_List_Page_Size__c;
    	}
    	
    	for(Integer i = (currentPage * pageSize - pageSize); i < (currentPage * pageSize); i++){
    		if(allrecords.size() > i){
    			objRecords.add(allrecords.get(i));
    		}
    	}
    	return objRecords;
    	}
    	catch(Exception e){
        	throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return null;
    	
    }
    
	/**
	* Name: LabourHeaderWrapper
	* Description: Wrapper class for Labour Header record and related records
	**/
    public class LabourHeaderWrapper {
        // Labour record instance
        public LabourRecord LabourRecord {get; private set;}
        
        public List<ViewLabourCtrl.ActiveOrder> ActiveOrderList;
        
        public Integer TotalActiveOrder;
        
	     /**
	     * Name: LabourHeaderWrapper
	     * Desc: Constructor
	     * @param:  (1) labourId - Id - Labour Record Id
	     *          (2) soliList - List<Service_Order_Line_Item__c> - List of Service Order Line item Record
	     *			(3) activeOrderPageSortAttrs - PaginationSorting - sort attributes of active order
	     * @return: 
	    **/
        public LabourHeaderWrapper(Id labourId, List<Service_Order_Line_Item__c> soliList, PaginationSorting activeOrderPageSortAttrs) {
            LabourRecord = new LabourRecord(labourId);
            this.ActiveOrderList = new List<ViewLabourCtrl.ActiveOrder>();
            Set<Id> coHeaderIdSet = new Set<Id>();
            for(Service_Order_Line_Item__c soliRec : soliList) {
                if(soliRec.Service_Order_Header__c == null || soliRec.Service_Order_Header__r.CO_Header__c == null) {
                    continue;
                }
                
                if(!coHeaderIdSet.contains(soliRec.Service_Order_Header__r.CO_Header__c) && soliRec.Service_Order_Header__r.CO_Header__r.Order_status__c == 'Open') {
                    this.ActiveOrderList.add(new ViewLabourCtrl.ActiveOrder(soliRec));
                    coHeaderIdSet.add(soliRec.Service_Order_Header__r.CO_Header__c);
                }
            }
            this.TotalActiveOrder = this.ActiveOrderList.size();
            this.ActiveOrderList = getPaginatedRecords(this.ActiveOrderList, activeOrderPageSortAttrs.CurrentPage, activeOrderPageSortAttrs.PageSize);
            
        }
    }
    
    /**
	* Name: ActiveOrder
	* Description: Wrapper class Active Order
	**/
    public class ActiveOrder {
        
        public String COHeaderNumber;
        public String COHeaderId;
        public String CustomerName;
        public String OwnerName;
        public String Status;
        
         /**  
	     * Name: ActiveOrder
	     * Desc: Constructor
	     * @param:  (1) soliRec - Service_Order_Line_Item__c - Service Order Line item Record
	     * @return: 
	    **/
        public ActiveOrder(Service_Order_Line_Item__c soliRec) {
            this.COHeaderNumber = soliRec.Service_Order_Header__r.CO_Header__r.Name;
            this.COHeaderId = soliRec.Service_Order_Header__r.CO_Header__c;
            this.CustomerName = (soliRec.Service_Order_Header__r.CO_Header__r.Customer__c != null) ? soliRec.Service_Order_Header__r.CO_Header__r.Customer__r.Name : null;
            this.OwnerName = (soliRec.Service_Order_Header__r.CO_Header__r.Owner__c != null) ? soliRec.Service_Order_Header__r.CO_Header__r.Owner__r.Name : null;
            this.Status = soliRec.Service_Order_Header__r.CO_Header__r.Order_status__c;
        }
    }
}