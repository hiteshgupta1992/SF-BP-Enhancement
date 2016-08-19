/**
 * Author: Tarun Khandelwal
 * Since: Sept 4, 2015
 * Name: VendorInvoicingCtrl
 * Description: Apex class to handle all operations related to Vendor Invoicing Page.
**/
global with sharing class VendorInvoicingCtrl {
	
	
	public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
	
	/**
     * Name: addVendor
     * Desc: Method to add selected vendor to vendor Invoicing order
     * @param:  (1) vendorId - Id - Vendor Id
     *			(2) viHeaderId - Id -  VI Header Id
     * 			(3) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(4) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String - Vendor_Receiving_Header__c Id if successfully selected
    **/
    @RemoteAction
    global static String addVendor(String vendorId, String viHeaderId, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	try{
    		vendorId = BPUtility.getDecodedString(vendorId);
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
	    	PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	
	    	Vendor_Invoicing_Header__c viHeaderRec = new Vendor_Invoicing_Header__c();
	    	if(!String.isBlank(viHeaderId)){
	    		viHeaderRec.Id = viHeaderId;
	    	}
	    	viHeaderRec.Vendor__c = vendorId;
	    	viHeaderRec.Owner__c = UserInfo.getUserId(); 
	    	viHeaderRec.Status__c = 'In Progress';
	    	
	    	try{
	    		if(AccessControl.ifObjectFieldIsCreateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
				if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    		upsert viHeaderRec;
	    		
	    		// After update, recalculate invoicing group total amount with new purchase order tax amount
	    		
	    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    		List<Vendor_Invoicing_Group__c> vigList = [Select Id, VI_Qty__c, VI_Cost__c, VI_Discount__c, VI_SubTotal__c, Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c FROM Vendor_Invoicing_Group__c WHERE Vendor_Invoicing_Header__c =: viHeaderRec.Id];
	    		for(Vendor_Invoicing_Group__c vig : vigList){
	    			vig.VI_SubTotal__c = (vig.VI_Qty__c * vig.VI_Cost__c) - (vig.VI_Qty__c * vig.VI_Cost__c * vig.VI_Discount__c / 100);
	    			vig.VI_SubTotal__c = (vig.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c != null) ? (vig.VI_SubTotal__c + vig.VI_SubTotal__c * vig.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c / 100) : vig.VI_SubTotal__c;
	    		}
	    		if(vigList.size() > 0){
	    			if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    			update vigList;
	    		}
	    		
	    		// After Insert, Update all Vendor Order Header for the vendor which are received
	    		//updateVendorOrdersReceiving(vrHeader.Id, true);
	    	} catch(Exception e){
	    		return BPUtility.getEncodedString(null);
	    	}
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderRec.Id), BPUtility.getEncodedString(null), 
	    										BPUtility.getEncodedString(receivingPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return null;
    }
    
	/**
     * Name: getVendorInvoicingDetails
     * Desc: Method to add selected vendor to vendor Invoicing order
     * @param:  (1) viHeaderId - Id -  VI Header Id
     			(2) vrHeaderId - String - Vendor Order Receiving Id
     * 			(3) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(4) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String -  Vendor Invoice Details
    **/
    @RemoteAction
    global static String getVendorInvoicingDetails(String viHeaderId, String vrHeaderId, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	
    	try{
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	
	    	List<Vendor_Invoicing_Header__c> viHeaderList = new List<Vendor_Invoicing_Header__c>();
	    	List<Vendor_Receiving_Header__c> vrHeaderList = new List<Vendor_Receiving_Header__c>();
	    	List<Vendor_Invoicing_Group__c> viGroupList = new List<Vendor_Invoicing_Group__c>();
	    	
	    	if(viHeaderId != null) {
	    		viHeaderList =  SOQLUtil.getVIHeaderByFieldName(new Map<String, String>{'Id' => viHeaderId});
	    	}
	    	
	    	if(viHeaderList.size() > 0 && viHeaderList[0].Vendor__c != null) {
	    		Map<String, String> sortFieldMap = new Map<String, String>();
		    	if(receivingPageSortAttrs.sorting != null && receivingPageSortAttrs.sorting[0].sortDirection.length() != 0){
		    		sortFieldMap.put('Packing_Slip_Number__c', receivingPageSortAttrs.sorting[0].sortDirection);
		    	}
		    	
	    		vrHeaderList = SOQLUtil.getVRByVendorId(viHeaderList[0].Vendor__c, viHeaderId, sortFieldMap);
	    	} 
	    	
	    	if(viHeaderList.size() > 0 && viHeaderList[0].Vendor_Receiving_Headers__r.size() > 0) {
	    		Map<String, String> sortFieldMap = new Map<String, String>();
		    	if(groupItemsPageSortAttrs.sorting != null && groupItemsPageSortAttrs.sorting[0].sortDirection.length() != 0){
		    		sortFieldMap.put('Vendor_Receiving_Group__r.Part__r.Part_ID__c', groupItemsPageSortAttrs.sorting[0].sortDirection);
		    		sortFieldMap.put('Vendor_Receiving_Group__r.Part__r.Description__c', groupItemsPageSortAttrs.sorting[0].sortDirection);
		    	}
		    	
	    		List<Id> InProgressReceivingHeadersIdList = new List<Id>();
	    		for(Vendor_Receiving_Header__c vrHeaderRec: viHeaderList[0].Vendor_Receiving_Headers__r) {
	    			InProgressReceivingHeadersIdList.add(vrHeaderRec.Id);
	    		}
	    		viGroupList = SOQLUtil.getVIGroupByFieldName('Vendor_Receiving_Group__r.Vendor_Receiving_Header__c', InProgressReceivingHeadersIdList, sortFieldMap);
	    	}
	    	
	    	VendorInvoicingCtrl.VIHeaderWrapper viHeaderWrapperObj = new VendorInvoicingCtrl.VIHeaderWrapper(viHeaderList, vrHeaderList, viGroupList, receivingPageSortAttrs, groupItemsPageSortAttrs);
	    	return BPUtility.getEncodedString(System.JSON.serialize(viHeaderWrapperObj));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return null;
    }
    
    /**
     * Name: updateVIGroup
     * Desc: Method to add selected vendor to vendor Invoicing order
     * @param: 	(1) viHeaderId - Id -  VI Header Id
     			(2) vrHeaderId - String - Vendor Order Receiving Id
     			(3)jsonString  - String  -  JSON String
     * 			(4) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(5) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String -  Vendor Invoice Details
    **/
    @RemoteAction
    global static String updateVIGroup(String viHeaderId, String vrHeaderId, String jsonString, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	try{
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
    		jsonString = BPUtility.getDecodedString(jsonString);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	
	    	VendorInvoicingCtrl.VIGroup viGroupObj = (VendorInvoicingCtrl.VIGroup) System.JSON.deserialize(jsonString, VendorInvoicingCtrl.VIGroup.class);
	    	if(viGroupObj.VIGroupId == null) {
	    		return getVendorInvoicingDetails(viHeaderId, null, receivingPageSortAttrsJSON, groupItemsPageSortAttrsJSON);
	    	}
	    	String viGroupId = viGroupObj.VIGroupId;
	    	
			viGroupId = BPUtility.escapeSingleQuotes(viGroupId);
	    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    	List<Vendor_Invoicing_Group__c> viGroupList = [select VI_Qty__c, VI_Cost__c, VI_Discount__c, VI_SubTotal__c from Vendor_Invoicing_Group__c Where Id =: viGroupId];
	    	if(viGroupList.size() > 0) {
	    		Vendor_Invoicing_Group__c viGroupRec = viGroupList[0];
	    		viGroupRec.VI_Cost__c = viGroupObj.InvoiceCost;
	    		viGroupRec.VI_Discount__c = viGroupObj.Discount;
	    		viGroupRec.VI_SubTotal__c = viGroupRec.VI_Qty__c * viGroupRec.VI_Cost__c * (1 - (viGroupRec.VI_Discount__c / 100 ));
	    		viGroupRec.VI_SubTotal__c = (viGroupRec.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c != null) ? (viGroupRec.VI_SubTotal__c + viGroupRec.VI_SubTotal__c * viGroupRec.Vendor_Invoicing_Header__r.Vendor__r.Purchase_Tax__r.Rate__c / 100) : viGroupRec.VI_SubTotal__c;
	    		
	    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    		update viGroupList;
	    	}
	    	updateVendorInvoicingTotal(viHeaderId);
	    	
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderId), BPUtility.getEncodedString(vrHeaderId), 
	    										BPUtility.getEncodedString(receivingPageSortAttrsJSON), 
	    										BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return null;
    }
    
    /**
     * Name: updateVendorInvoicingTotal
     * Desc: Method to update total to vendor Invoicing order
     * @param: 	(1) viHeaderId - Id -  VI Header Id
     * @return: 
    **/
    private static void updateVendorInvoicingTotal(String viHeaderId){
    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    	viHeaderId = BPUtility.escapeSingleQuotes(viHeaderId);
    	List<Vendor_Invoicing_Group__c> viGroupList = [select VI_SubTotal__c from Vendor_Invoicing_Group__c Where Vendor_Invoicing_Header__c =: viHeaderId];
    	if(viGroupList.size() > 0) {
    		Decimal total = 0;
    		for(Vendor_Invoicing_Group__c vendorInvoicingRec : viGroupList){
    			if(vendorInvoicingRec.VI_SubTotal__c == null){
    				vendorInvoicingRec.VI_SubTotal__c = 0;
    			}
    			total += vendorInvoicingRec.VI_SubTotal__c;
    		}
    		Vendor_Invoicing_Header__c vendorInvoicingRec =  new Vendor_Invoicing_Header__c(Id = viHeaderId, Total__c = total);
    		
    		update vendorInvoicingRec;
    	}
    }
    
    /**
     * Name: updateVIHeader
     * Desc: Method to add selected vendor to vendor Invoicing order
     * @param:  (1) viHeaderId - Id -  VI Header Id
     			(2) InvoiceNumber - String - Invoice Number
     			(3)InvoiceDateString  - String  -  Invoice Date String
     * 			(4) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(5) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String - Vendor Invoice Details
    **/
    @RemoteAction
    global static String updateVIHeader(String viHeaderId, String InvoiceNumber, String InvoiceDateString, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	try{
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		InvoiceNumber = BPUtility.getDecodedString(InvoiceNumber);
    		InvoiceDateString = BPUtility.getDecodedString(InvoiceDateString);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	
	    	Vendor_Invoicing_Header__c viHeaderRec = new Vendor_Invoicing_Header__c();
	    	if(viHeaderId != null){
	    		viHeaderRec.Id = viHeaderId;
	    	}
	    	viHeaderRec.Invoice_Number__c = InvoiceNumber;
	    	if(InvoiceDateString != null) {
	    		viHeaderRec.Invoice_Date__c = Date.parse(InvoiceDateString);
	    	} else {
	    		viHeaderRec.Invoice_Date__c = null;
	    	}
	    	if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    	update viHeaderRec;
	    	
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderId), BPUtility.getEncodedString(null), 
	    										BPUtility.getEncodedString(receivingPageSortAttrsJSON), 
	    										BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return null;
    }
    
    /**
     * Name: getPartByPartId
     * Desc: Method which give JSON string of part Record related to given part Id.
     * @param:  (1) partId - String - Part record Id
     * @return: String - JSON String of part Record.
    **/
    @RemoteAction
    global static String getPartByPartId(String partId){
    	try{
        	return ViewPartCtrl.getPartInfo(partId);
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: getVRDetailForPopUp
     * Desc: Method which give JSON string of VR Header Record related to given VR Header Record Id.
     * @param:  (1) vrHeaderId - String - VR Header Record Id
     * @return: String - JSON String of VR Header Record.
    **/
    @RemoteAction
    global static String getVRDetailForPopUp(String vrHeaderId){
    	try{
    		vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
	        List<Vendor_Receiving_Header__c> vrHeaderList = SOQLUtil.getVRHeaderList(vrHeaderId);
	        String jsonString;
	        if(vrHeaderList.size() == 0) {
	        	jsonString = '{}';
	        } else {
	        	jsonString = System.JSON.serialize(new VendorInvoicingCtrl.VRInPopUp(vrHeaderList[0]));
	        }
	        return BPUtility.getEncodedString(jsonString);
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: addToItemsSubsection
     * Desc: Method to add selected vendor to vendor Invoicing order
     * @param:  (1) viHeaderId - Id -  VI Header Id
     			(2) vrHeaderId - String - Vendor Order Receiving Id
     * 			(3) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(4) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String -  Vendor Invoice Details
    **/
    @RemoteAction
    global static String addToItemsSubsection(String viHeaderId, String vrHeaderId, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	try{
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
    		vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	
	    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    	List<Vendor_Order_Header__c> voHeaderList = [select Purchase_Order_Type__c, Purchase_Order_Type__r.Discount__c from Vendor_Order_Header__c Where In_Progress_VR__c =: vrHeaderId];
	    	String poTypeId;
	    	Decimal poTypeDiscount = 0;
	    	if(voHeaderList.size() > 0) {
	    		poTypeId = voHeaderList[0].Purchase_Order_Type__c;
	    		poTypeDiscount = voHeaderList[0].Purchase_Order_Type__r.Discount__c;
	    	}

	    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    	List<Vendor_Receiving_Header__c> vrHeaderList = [select In_Progress_VI__c from Vendor_Receiving_Header__c Where Id =: vrHeaderId];
	    	if(vrHeaderList.size() > 0) {
	    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    		vrHeaderList[0].In_Progress_VI__c = viHeaderId;
	    		update vrHeaderList[0];
	    	}
	    	
	     	List<Vendor_Receiving_Group__c> vrGroupList = SOQLUtil.getVORGroupsWithItems('Vendor_Receiving_Header__c', vrHeaderId);
	    	List<Vendor_Invoicing_Group__c> viGroupListToInsert = new List<Vendor_Invoicing_Group__c>();
	    	Vendor_Invoicing_Group__c viGroupRec;
	    	for(Vendor_Receiving_Group__c vrGroupRec : vrGroupList) {
	    		viGroupRec = new Vendor_Invoicing_Group__c();
		    	viGroupRec.Vendor_Invoicing_Header__c = viHeaderId;
		    	viGroupRec.Vendor_Receiving_Group__c = vrGroupRec.Id;	
		    	
		    	if(vrGroupRec.Cost__c == null) {
		    		vrGroupRec.Cost__c = 10;
		    	}
		    	viGroupRec.VI_Cost__c = vrGroupRec.Cost__c;
		    	viGroupRec.VI_Qty__c = vrGroupRec.Recieved__c;
		    	viGroupRec.Packaged_Unit__c = vrGroupRec.Part__r.Package_Unit__c;
		    	viGroupRec.PO_Type__c = poTypeId;
		    	viGroupRec.VI_Discount__c = poTypeDiscount;
		    	viGroupRec.VI_SubTotal__c = vrGroupRec.Recieved__c * vrGroupRec.Cost__c * (1 - (poTypeDiscount / 100 ));
		    	viGroupRec.VI_SubTotal__c = (vrGroupRec.Vendor_Receiving_Header__r.Vendor__r.Purchase_Tax__r.Rate__c != null) ? (viGroupRec.VI_SubTotal__c + viGroupRec.VI_SubTotal__c * vrGroupRec.Vendor_Receiving_Header__r.Vendor__r.Purchase_Tax__r.Rate__c / 100) : viGroupRec.VI_SubTotal__c;
		    	viGroupListToInsert.add(viGroupRec);
	    	}
	    	
	    	if(viGroupListToInsert.size() > 0) {
	    		//system.assert(false, viGroupListToInsert);
	    		if(AccessControl.ifObjectFieldIsCreateable('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
	    		insert viGroupListToInsert;
	    	}
	    	
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderId), BPUtility.getEncodedString(vrHeaderId), 
	    										BPUtility.getEncodedString(receivingPageSortAttrsJSON), 
	    										BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    
    /**
     * Name: removeFromItemSubSection
     * Desc: Method to remove selected vendor to vendor Invoicing order
     * @param:  (1) viHeaderId - Id -  VI Header Id
     			(2) vrHeaderId - String - Vendor Order Receiving Id
     * 			(3) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(4) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String - Vendor Invoice Details
    **/
    @RemoteAction
    global static String removeFromItemSubSection(String viHeaderId, String vrHeaderId, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	try{
    		if(AccessControl.ifObjectIsDeletable('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    		
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		PaginationSorting receivingPageSortAttrs = PaginationSorting.parsePageAttrs(receivingPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	viHeaderId = BPUtility.escapeSingleQuotes(viHeaderId);
	    	vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
	    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    	List<Vendor_Invoicing_Group__c> viGroupList = [select Id from Vendor_Invoicing_Group__c Where Vendor_Invoicing_Header__c =: viHeaderId
	    																AND Vendor_Receiving_Group__r.Vendor_Receiving_Header__c =: vrHeaderId];
	    	if(viGroupList.size() > 0) {
	    		delete viGroupList;
	    	}															
	    	
	    	if(AccessControl.ifObjectFieldIsAccessible('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
	    	List<Vendor_Receiving_Header__c> vrHeaderList = [select In_Progress_VI__c from Vendor_Receiving_Header__c Where Id =: vrHeaderId];
	    	if(vrHeaderList.size() > 0) {
	    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    		vrHeaderList[0].In_Progress_VI__c = null;
	    		update vrHeaderList[0];
	    	}
	    	
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderId), BPUtility.getEncodedString(vrHeaderId), 
	    										BPUtility.getEncodedString(receivingPageSortAttrsJSON), 
	    										BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: finalizeInvoiceAction
     * Desc: Method to Finalize Invoice Action
     * @param:  (1) viHeaderId - Id -  VI Header Id
     * 			(2) receivingPageSortAttrsJSON - String  - page sort attribute 
     * 			(3) groupItemsPageSortAttrsJSON -String  - page sort attribute group items
     * @return: String - Vendor Invoice Details
    **/
    @RemoteAction
    global static String finalizeInvoiceAction(String viHeaderId, String receivingPageSortAttrsJSON, String groupItemsPageSortAttrsJSON){
    	Savepoint sp = Database.setSavepoint();
    	try{
			viHeaderId = BPUtility.escapeSingleQuotes(viHeaderId);
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		receivingPageSortAttrsJSON = BPUtility.getDecodedString(receivingPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		
    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		List<Vendor_Invoicing_Header__c> viHeaderList = [select Id, Status__c, (select VI_Qty__c, Vendor_Receiving_Group__r.Part__c, Vendor_Receiving_Group__r.Vendor_Receiving_Header__c, Vendor_Receiving_Group__r.Part__r.Qty_In_Stock__c, Vendor_Receiving_Group__r.Part__r.Average_Cost__c, VI_Cost__c from Vendor_Invoicing_Groups__r) 
    																from Vendor_Invoicing_Header__c Where Id =: viHeaderId];
    	
	    	Map<Id, Decimal> partIdToCostMap = new Map<Id, Decimal>();
	    	Map<Id, Decimal> partIdToTotalQtyMap = new Map<Id, Decimal>();
	    	Map<Id, Decimal> partIdToQtyMap = new Map<Id, Decimal>();
	    	Map<Id, Decimal> partIdToAvgCostMap = new Map<Id, Decimal>();
	    	Map<Id, List<Part__c>> vendorReceivingHeaderToPartMap = new Map<Id, List<Part__c>>();
	    	
	    	if(viHeaderList.size() > 0) {															
		    	Vendor_Invoicing_Header__c viHeaderRec = viHeaderList[0];
		    	viHeaderRec.Status__c = 'Invoiced';
		    	for(Vendor_Invoicing_Group__c viGroupRec : viHeaderRec.Vendor_Invoicing_Groups__r) {
		    		Part__c bucketPart = new Part__c();
		    		if(!partIdToCostMap.containsKey(viGroupRec.Vendor_Receiving_Group__r.Part__c)) {
		    			if(viGroupRec.VI_Cost__c == null) {
		    				viGroupRec.VI_Cost__c = 0;
		    			}
		    			partIdToCostMap.put(viGroupRec.Vendor_Receiving_Group__r.Part__c, viGroupRec.VI_Cost__c);
		    		}
		    		if(!partIdToTotalQtyMap.containsKey(viGroupRec.Vendor_Receiving_Group__r.Part__c)) {
		    			if(viGroupRec.Vendor_Receiving_Group__r.Part__r.Qty_In_Stock__c == null) {
		    				viGroupRec.Vendor_Receiving_Group__r.Part__r.Qty_In_Stock__c = 0;
		    			}
		    			partIdToTotalQtyMap.put(viGroupRec.Vendor_Receiving_Group__r.Part__c, viGroupRec.Vendor_Receiving_Group__r.Part__r.Qty_In_Stock__c);
		    		}
		    		
		    		decimal qty = (partIdToQtyMap.containsKey(viGroupRec.Vendor_Receiving_Group__r.Part__c)) ? partIdToQtyMap.get(viGroupRec.Vendor_Receiving_Group__r.Part__c) : 0;
		    		qty += viGroupRec.VI_Qty__c;
		    		partIdToQtyMap.put(viGroupRec.Vendor_Receiving_Group__r.Part__c, qty);
		    		
		    		if(!partIdToAvgCostMap.containsKey(viGroupRec.Vendor_Receiving_Group__r.Part__c)) {
		    			if(viGroupRec.Vendor_Receiving_Group__r.Part__r.Average_Cost__c == null) {
		    				viGroupRec.Vendor_Receiving_Group__r.Part__r.Average_Cost__c = 0;
		    			}
		    			partIdToAvgCostMap.put(viGroupRec.Vendor_Receiving_Group__r.Part__c, viGroupRec.Vendor_Receiving_Group__r.Part__r.Average_Cost__c);
		    		}
		    		
		    		// creating part list for fifo bucket
		    		bucketPart.Id = viGroupRec.Vendor_Receiving_Group__r.Part__c;
		    		bucketPart.Last_Cost__c = viGroupRec.VI_Cost__c;
		    		if(!vendorReceivingHeaderToPartMap.containsKey(viGroupRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__c)){
		    			vendorReceivingHeaderToPartMap.put(viGroupRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__c, new List<Part__c>());
		    		}
		    		vendorReceivingHeaderToPartMap.get(viGroupRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__c).add(bucketPart);
		    	}
		    	if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
		    	update viHeaderRec; 
	    	}
	    	
	    	if(vendorReceivingHeaderToPartMap.size() > 0){
	    		FIFOTransaction.updateFIFOBucketForVendorInvoicing(vendorReceivingHeaderToPartMap, viHeaderId);
	    	}
	    	
	    	if(partIdToCostMap.size() > 0) {
	    		List<Part__c> partList = new List<Part__c>();
	    		for(Id partId : partIdToCostMap.keySet()) {
	    			Part__c partRec = new Part__c();
	    			partRec.Id = partId;
	    			partRec.Last_Cost__c = partIdToCostMap.get(partRec.Id);
	    			
	    			// Update logic for average cost
	    			/*partRec.Average_Cost__c = ( (partIdToAvgCostMap.get(partRec.Id) * (partIdToTotalQtyMap.get(partRec.Id) - partIdToQtyMap.get(partRec.Id)))
	    									  + (partIdToCostMap.get(partRec.Id) * partIdToQtyMap.get(partRec.Id)) )
	    									  / partIdToTotalQtyMap.get(partRec.Id);*/
	    			
	    			partList.add(partRec);
	    		}
	    		if(partList.size() > 0) {
	    			if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
	    			update partList;
	    		} 
	    	}
	    	updateVendorInvoicingTotal(viHeaderId);
	    	return getVendorInvoicingDetails(BPUtility.getEncodedString(viHeaderId), BPUtility.getEncodedString(null), 
	    									BPUtility.getEncodedString(receivingPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON));
    	}catch(Exception e){
    		Database.rollback( sp );
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    // Created By Anurag
    /**
     * Name: deleteVendorOrderInvoicing
     * Desc: Method to delete Vendor Order Invoicing
     * @param:  (1) viHeaderId - Id -  VI Header Id
     * @return: 
    **/
    @RemoteAction
    global static String deleteVendorOrderInvoicing(String viHeaderId){
    	try{
    		if(AccessControl.ifObjectIsDeletable('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    		
    		viHeaderId = BPUtility.getDecodedString(viHeaderId);
    		viHeaderId = BPUtility.escapeSingleQuotes(viHeaderId);
    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Invoicing_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		List<Vendor_Invoicing_Header__c> viGroupList = [Select (Select Id From Vendor_Invoicing_Groups__r) From Vendor_Invoicing_Header__c   where ID =: viHeaderId ];
    		if(viGroupList[0].Vendor_Invoicing_Groups__r.size() == 0){
    			Vendor_Invoicing_Header__c viInvoiceHeader = new Vendor_Invoicing_Header__c(Id = viHeaderId);
    			delete viInvoiceHeader;
    		}
    		
		}catch(Exception e){
			throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	
    	return BPUtility.getEncodedString('Success');
    }
    	
    
    
    
    public static List<String> viHeaderFieldsList() {
		List<String> viHeaderFields = new List<String>{ 'Id',
														'Name',
                                                        'Vendor__r.Name',
                                                        'Vendor__c',
                                                        'Owner__c',
                                                        'Owner__r.Name',
                                                        'Invoice_Number__c',
                                                        'Status__c',
                                                        'Invoice_Date__c',
                                                        'Vendor__r.Purchase_Tax__r.Rate__c'
                                            };
    	return viHeaderFields;
	}
	
	public static List<String> viGroupFieldsList() {
		List<String> viGroupFields = new List<String>{ 'Id',
                                                        'Vendor_Invoicing_Header__c',
                                                        'Vendor_Receiving_Group__c',
                                                        'Vendor_Receiving_Group__r.Part__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Part_ID__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Packaged_Part__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Package_Qty__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Package_Unit__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Order_Lots__c',
                                                        'Vendor_Receiving_Group__r.Part__r.Description__c',
                                                        'Vendor_Receiving_Group__r.Vendor_Receiving_Header__r.Packing_Slip_Number__c',
                                                        'Vendor_Receiving_Group__r.Recieved__c',
                                                        'Vendor_Receiving_Group__r.Cost__c',
                                                        'VI_Cost__c',
                                                        'VI_Discount__c',
                                                        'VI_Qty__c',
                                                        'VI_SubTotal__c',
                                                        'PO_Type__c',
                                                        'PO_Type__r.Landed_Cost_Adjustment__c',
                                                        'Packaged_Unit__c'
                                            };
    	return viGroupFields;
	}
    
    public static List<String> voReceivingFieldsList() {
		List<String> voReceivingFields = new List<String>{ 	'Id',
															'Packing_Slip_Number__c',
	                                                        'Status__c',
	                                                        'Finalized_Date__c',
	                                                        'In_Progress_VI__c',
	                                                        'Owner__c',
	                                                        'Owner__r.Name'
                                            };
    	return voReceivingFields;
	}
    
    public static List<String> vrGroupFieldsList() {
		List<String> vrGroupFields = new List<String>{ 	'Id',
														'Cost__c',
                                                        'Recieved__c',
                                                        'Total__c',
                                                        'Part__c',
                                                        'Order__c',
														'Part__r.Part_Id__c',
														'Part__r.Description__c'
                                            };
    	return vrGroupFields;
	}
	
	public static List<String> voHeaderFieldsList() {
		List<String> voHeaderFields = new List<String>{ 'Id',
														'Name',
                                                        'In_Progress_VR__c'
                                            };
    	return voHeaderFields;
	}
    
	/**
	 * Name: VIHeader
	 * Description: Vendor Invoice Header  class
	**/
    public class VIHeader {
    	
    	public String VendorName;
    	public String VendorId;
    	public String OwnerName;
    	public String OwnerId;
    	public String Status;
    	public String InvoiceNumber;
    	public String InvoiceDate;
    	public String VIHeaderId;
    	public String VIHeaderNumber;
    	
    	 /**
	     * Name: VIHeader
	     * Desc: Constructor
	     * @param:  (1) viHeaderRec - Vendor_Invoicing_Header__c -  Vendor Invoice Header Record
	     * @return: 
	     **/
    	public VIHeader(Vendor_Invoicing_Header__c viHeaderRec) {
    		
    		this.VendorName = viHeaderRec.Vendor__r.Name;
    		this.VendorId = viHeaderRec.Vendor__c;
    		this.OwnerName = viHeaderRec.Owner__r.Name;
    		this.OwnerId = viHeaderRec.Owner__c;
    		this.Status = viHeaderRec.Status__c;
    		this.InvoiceNumber = viHeaderRec.Invoice_Number__c;
    		if(viHeaderRec.Invoice_Date__c != null) {
    			this.InvoiceDate = (datetime.newInstance(viHeaderRec.Invoice_Date__c.year(), viHeaderRec.Invoice_Date__c.month(), viHeaderRec.Invoice_Date__c.day())).format('MM/dd/YYYY');
    		}
    		this.VIHeaderId = viHeaderRec.Id;
    		this.VIHeaderNumber = viHeaderRec.Name;
    	}
    }
    
    /**
	 * Name: VRHeader
	 * Description: Vendor Order Receiving Header  Class
	**/
    public class VRHeader {
    	
    	public String PackingSlipNumber;
    	public String OrderType;
    	public String FinalizeDate;
    	public Decimal TotalNumberOfLineItems;
    	public Decimal TotalCost;
    	public String ReceivedById;
    	public String ReceivedByName;
    	public String VRHeaderId;
    	public String InProgressVIHeaderId;
    	
    	 /**
	     * Name: VRHeader
	     * Desc: Constructor
	     * @param:  (1) vrHeaderRec - Vendor_Receiving_Header__c -  Vendor Receiving Header Record
	     * @return: 
	     **/
    	public VRHeader(Vendor_Receiving_Header__c vrHeaderRec) {
    		
    		this.PackingSlipNumber = vrHeaderRec.Packing_Slip_Number__c;
    		if(vrHeaderRec.Finalized_Date__c != null) {
    			this.FinalizeDate = (datetime.newInstance(vrHeaderRec.Finalized_Date__c.year(), vrHeaderRec.Finalized_Date__c.month(), vrHeaderRec.Finalized_Date__c.day())).format('MMMM dd, YYYY');
    		} else {
    			this.FinalizeDate = '';
    		}
    		this.ReceivedByName = vrHeaderRec.Owner__r.Name;
    		this.ReceivedById = vrHeaderRec.Owner__c;
    		
    		this.TotalNumberOfLineItems = 0;
    		this.TotalCost = 0;
    		for(Vendor_Receiving_Group__c vrGroupRec : vrHeaderRec.Vendor_Receiving_Groups__r) {
    			this.TotalNumberOfLineItems += 1;
    			if(vrGroupRec.Cost__c != null && vrGroupRec.Recieved__c != null) {
    				this.TotalCost += vrGroupRec.Cost__c * vrGroupRec.Recieved__c;
    			}
    		}
    		this.TotalCost = this.TotalCost.setScale(2);
    		if(vrHeaderRec.In_Progress_VRs__r != null && vrHeaderRec.In_Progress_VRs__r.size() == 1) {
    			this.OrderType = vrHeaderRec.In_Progress_VRs__r[0].Vendor_Order_Header__r.Name;
    		} else if(vrHeaderRec.In_Progress_VRs__r != null && vrHeaderRec.In_Progress_VRs__r.size() > 1) {
    			this.OrderType = 'Multiple Orders';
    		}
    		
    		this.VRHeaderId = vrHeaderRec.Id;
    		this.InProgressVIHeaderId = vrHeaderRec.In_Progress_VI__c;
    	}
    }
    
     /**
	 * Name: VIGroup
	 * Description: Vendor Invoice Group Class
	**/
    public class VIGroup {
    	
    	public String Item;
    	public String PackingNumber;
    	public Decimal ReceivingQty;
    	public Decimal ReceivingCost;
    	public Decimal InvoiceQty;
    	public Decimal InvoiceCost;
    	public Decimal Discount;
    	public Decimal SubTotal;
    	public String VIGroupId;
    	public String OrderType;
    	public String PackageUnit;
    	public Decimal PackageQty;
    	public Decimal DiscountAmout;
    	public Decimal LcaAmount;
    	public String PartId;
    	
    	
    	 /**
	     * Name: VIGroup
	     * Desc: Constructor
	     * @param:  (1) viGroupRec - Vendor_Invoicing_Group__c -  Vendor Invoice Group Record
	     * @return: 
	     **/
    	public VIGroup(Vendor_Invoicing_Group__c viGroupRec) {
    		
    		this.Item = viGroupRec.Vendor_Receiving_Group__r.Part__r.Part_ID__c + ' - ' + viGroupRec.Vendor_Receiving_Group__r.Part__r.Description__c;
    		this.PackingNumber = viGroupRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__r.Packing_Slip_Number__c;
    		this.ReceivingQty = viGroupRec.Vendor_Receiving_Group__r.Recieved__c;
    		this.ReceivingCost = (viGroupRec.Vendor_Receiving_Group__r.Cost__c != null) ? viGroupRec.Vendor_Receiving_Group__r.Cost__c.setScale(2) : 0.00;
    		this.InvoiceCost = (viGroupRec.VI_Cost__c != null) ? viGroupRec.VI_Cost__c.setScale(2) : 0.00;
    		this.Discount = viGroupRec.VI_Discount__c;
    		this.SubTotal = (viGroupRec.VI_SubTotal__c != null) ? viGroupRec.VI_SubTotal__c.setScale(2) : 0.00;
    		this.VIGroupId = viGroupRec.Id;
    		if(viGroupRec.VI_Cost__c == null || this.ReceivingQty == null || this.Discount == null) {
    			this.DiscountAmout = 0.00;
    		} else {
    			this.DiscountAmout = ((viGroupRec.VI_Cost__c * this.ReceivingQty * this.Discount) / 100).setScale(2);
    		}
    		
    		this.OrderType = '';
	        if(viGroupRec.Vendor_Receiving_Group__r.Part__r.Packaged_Part__c) {
	            this.ReceivingQty = this.ReceivingQty / viGroupRec.Vendor_Receiving_Group__r.Part__r.Package_Qty__c;
	            this.OrderType = 'Ordered as ' + viGroupRec.Vendor_Receiving_Group__r.Part__r.Package_Qty__c + '/' + viGroupRec.Vendor_Receiving_Group__r.Part__r.Package_Unit__c;
	            if(viGroupRec.Vendor_Receiving_Group__r.Part__r.Order_Lots__c > 1) {
	                this.OrderType += ' in Lots of ' + viGroupRec.Vendor_Receiving_Group__r.Part__r.Order_Lots__c;
	            }
	        } else if(viGroupRec.Vendor_Receiving_Group__r.Part__r.Order_Lots__c > 1) {
	            this.OrderType += 'Ordered as in Lots of ' + viGroupRec.Vendor_Receiving_Group__r.Part__r.Order_Lots__c;
	        }
	        this.InvoiceQty = this.ReceivingQty;
	        this.PackageUnit = viGroupRec.Vendor_Receiving_Group__r.Part__r.Package_Unit__c;
	        this.PackageQty = viGroupRec.Vendor_Receiving_Group__r.Part__r.Package_Qty__c;
	        this.LcaAmount = viGroupRec.PO_Type__r.Landed_Cost_Adjustment__c;
	        this.PartId = viGroupRec.Vendor_Receiving_Group__r.Part__c;
    	}
    }
    
    /**
	 * Name: VIHeaderWrapper
	 * Description: Vendor Invoice Header Wrapper Class
	**/
    public class VIHeaderWrapper {
    	
    	public List<VendorInvoicingCtrl.VIHeader> VIHeaderRec;
    	public List<VendorInvoicingCtrl.VRHeader> VRHeaderList;
    	public List<VendorInvoicingCtrl.VIGroup> VIGroupList;
    	public Decimal ItemsTotal;
    	public Decimal PurchaseTax;
    	public Decimal Total;
    	
    	public Integer totalVendorOrderInvoicing;
    	public Integer totalGroupItems;
		
		 /**
	     * Name: VIHeaderWrapper
	     * Desc: Constructor
	     * @param:  (1) viHeaderList - List<Vendor_Invoicing_Header__c> -  Vendor Invoice Group Record
	     *			(2)vrHeaderList - List<Vendor_Receiving_Header__c> - List of Vendor Receiving Header Record
	     *			(3)viGroupList - List<Vendor_Invoicing_Group__c> - List of Vendor Receiving Group Record
	     *			(4)receivingPageSortAttrs - PaginationSorting - Page Sort Attributes
	     *			(5)groupItemsPageSortAttrs - PaginationSorting - Group Item Page Sort Attributes
	     * @return: 
	     **/
    	public VIHeaderWrapper(	List<Vendor_Invoicing_Header__c> viHeaderList, 
    							List<Vendor_Receiving_Header__c> vrHeaderList, 
    							List<Vendor_Invoicing_Group__c> viGroupList,
    							PaginationSorting receivingPageSortAttrs,
    							PaginationSorting groupItemsPageSortAttrs
    						) {
    		this.VIHeaderRec = new List<VendorInvoicingCtrl.VIHeader>();
    		this.VRHeaderList = new List<VendorInvoicingCtrl.VRHeader>();
    		this.VIGroupList = new List<VendorInvoicingCtrl.VIGroup>();
    		this.ItemsTotal = 0;
    		this.PurchaseTax = 0;
    		this.Total = 0;
    		this.totalVendorOrderInvoicing = vrHeaderList.size();
    		this.totalGroupItems = viGroupList.size();
    		
    		for(Vendor_Invoicing_Header__c vihRec : viHeaderList) {
    			this.VIHeaderRec.add(new VendorInvoicingCtrl.VIHeader(vihRec));
    		}
    		
    		for(Vendor_Receiving_Header__c vrhRec : vrHeaderList) {
    			this.VRHeaderList.add(new VendorInvoicingCtrl.VRHeader(vrhRec));
    		}
    		this.VRHeaderList = getReceivingPaginatedRecords(this.VRHeaderList, receivingPageSortAttrs.CurrentPage, receivingPageSortAttrs.PageSize);
    		
    		for(Vendor_Invoicing_Group__c viGroupRec : viGroupList) {
    			VendorInvoicingCtrl.VIGroup viGroupObj = new VendorInvoicingCtrl.VIGroup(viGroupRec);
    			this.VIGroupList.add(viGroupObj);
    			this.ItemsTotal += viGroupObj.SubTotal;
    		}
    		this.ItemsTotal = this.ItemsTotal.setScale(2);
    		this.VIGroupList = getGroupPaginatedRecords(this.VIGroupList, groupItemsPageSortAttrs.CurrentPage, groupItemsPageSortAttrs.PageSize);
    		
    		if(viHeaderList.size() > 0) {
    			Vendor_Invoicing_Header__c vihRec = viHeaderList[0];
    			if(vihRec.Vendor__r.Purchase_Tax__r.Rate__c != null) {
    				this.PurchaseTax = 0; //(this.ItemsTotal) * (vihRec.Vendor__r.Purchase_Tax__r.Rate__c / 100); 
    			}
    			this.Total = this.ItemsTotal + this.PurchaseTax;
    		}
    		this.Total = this.Total.setScale(2);
    	}
    	
    	/**
	     * Name: getReceivingPaginatedRecords
	     * Desc: Method to paginate entity records list
	     * @param:  (1) allrecords - List<VendorInvoicingCtrl.VRHeader> - Vendor Receiving Header Records
	     *			(2) currentPage - Integer - Page Number
	     *			(3) pageSize - Integer - No of Record in a page
	     * @return: List of Vendor Receiving Header Record
	    **/
	    private List<VendorInvoicingCtrl.VRHeader> getReceivingPaginatedRecords(List<VendorInvoicingCtrl.VRHeader> allrecords, Integer currentPage, integer pageSize) {
	    	List<VendorInvoicingCtrl.VRHeader> objRecords = new List<VendorInvoicingCtrl.VRHeader>();
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
	    
    	/**
	     * Name: getGroupPaginatedRecords
	     * Desc: Method to paginate entity records list
	     * @param:  (1) allrecords - List<VendorInvoicingCtrl.VIGroup> - Vendor Invoice Group Records
	     *			(2) currentPage - Integer - Page Number
	     *			(3) pageSize - Integer - No of Record in a page
	     * @return: List of Vendor Invoice Group  Record
	    **/
	    private List<VendorInvoicingCtrl.VIGroup> getGroupPaginatedRecords(List<VendorInvoicingCtrl.VIGroup> allrecords, Integer currentPage, integer pageSize) {
	    	List<VendorInvoicingCtrl.VIGroup> objRecords = new List<VendorInvoicingCtrl.VIGroup>();
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
    }
    
    
     /**
	 * Name: VRInPopUp
	 * Description: Vendor Receiving Header Pop up Class
	**/
    public class VRInPopUp {
    	
    	public String Id;
    	public String InvoiceDate;
    	public String PackingNumber;
    	public String PrintDate;
    	public String Status;
    	public List<VRGroupInPopUp> VRGroupList;
    	public Decimal SubTotal;
    	public Decimal Tax;
    	public Decimal Total;
    	
    	/**
	     * Name: VRInPopUp
	     * Desc: Constructor
	     * @param:  (1)vrHeaderRec - Vendor_Receiving_Header__c  - Vendor Receiving Header Record
	     * @return: 
	    **/
    	public VRInPopUp(Vendor_Receiving_Header__c vrHeaderRec) {
    		this.Id = vrHeaderRec.Id;
    		if(vrHeaderRec.Finalized_Date__c != null) {
    			this.InvoiceDate = (datetime.newInstance(vrHeaderRec.Finalized_Date__c.year(), vrHeaderRec.Finalized_Date__c.month(), vrHeaderRec.Finalized_Date__c.day())).format('MM/dd/YYYY');
    		} else {
    			this.InvoiceDate = null;
    		}
    		this.PackingNumber = vrHeaderRec.Packing_Slip_Number__c;
    		this.PrintDate = this.InvoiceDate;
    		this.Status = vrHeaderRec.Status__c;
    		this.VRGroupList = new List<VRGroupInPopUp>();
    		for(Vendor_Receiving_Group__c vrg : vrHeaderRec.Vendor_Receiving_Groups__r) {
    			this.VRGroupList.add(new VRGroupInPopUp(vrg));
    		}
    		
    		this.SubTotal = 0;
    		this.Tax = 0;
    		 
    		for(VRGroupInPopUp vrGroupObj : VRGroupList) {
    			this.SubTotal += vrGroupObj.Total;
    			this.Tax += vrGroupObj.TaxAmount;
    		}
    		this.SubTotal = this.SubTotal.setScale(2);
    		this.Tax = this.Tax.setScale(2);
    		this.Total = this.SubTotal + this.Tax;
    	}
    }
    
     /**
	 * Name: VRGroupInPopUp
	 * Description: Vendor Receiving Group Pop up Class
	**/
    public class VRGroupInPopUp {
    	
    	public String Item;
    	public String Id;
    	public Decimal QtyOrdered;
    	public Decimal QtyReceived;
    	public Decimal Price;
    	public Decimal TaxAmount;
    	public Decimal Total;
    	
    	/**
	     * Name: VRGroupInPopUp
	     * Desc: Constructor
	     * @param:  (1)vrGroupRec - Vendor_Receiving_Group__c  - Vendor Receiving Group Record
	     * @return: 
	    **/
    	public VRGroupInPopUp(Vendor_Receiving_Group__c vrGroupRec) {
    		this.Item = vrGroupRec.Part__r.Part_Id__c + ' - ' + vrGroupRec.Part__r.Description__c;
    		this.Id = vrGroupRec.Id;
    		this.QtyOrdered = vrGroupRec.Order__c;
    		this.QtyReceived = vrGroupRec.Recieved__c;
    		this.Price = (vrGroupRec.Cost__c != null) ? vrGroupRec.Cost__c.setScale(2) : 0.00;
    		this.TaxAmount = 0;
    		this.Total = (this.Price * this.QtyReceived).setScale(2);
    	}
    }
}