/**
 * Author: Ashish Garg
 * Since: Aug 6, 2015
 * Name: VendorOrderReceivingCtrl
 * Description: Apex class to handle all operations related to Vendor Order Receiving Page.
**/
global with sharing class VendorOrderReceivingCtrl {
	// Static variable to use current Vendor Order receiving Id
	public static Id Vendor_Order_Receiving_Id;
	 

	// Vendor Orders sort order
	public static String VO_Sort_Order;  
	
	// Sort order map
	public static Map<String, String> sortingMap;
	
	public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
	
	/**
     * Name: addVendor
     * Desc: Method to add selected vendor to vendor receiving order
     * @param: 		(1)	selectedVendorId - Id - Vendor Id
     *				(2) vorId - String - Vendor Order Receiving Id
     * @return: String - Vendor_Receiving_Header__c Id if successfully selected
    **/
    @RemoteAction
    global static String addVendor(String selectedVendorId, String vorId){
    	try{
    		selectedVendorId = BPUtility.getDecodedString(selectedVendorId);
    		vorId = BPUtility.getDecodedString(vorId);
    		Vendor_Receiving_Header__c vrHeader = new Vendor_Receiving_Header__c();
	    	if(vorId != null){
	    		vrHeader.Id = vorId;
	    	}
	    	vrHeader.Vendor__c = selectedVendorId;
	    	vrHeader.Owner__c = UserInfo.getUserId();
	    	vrHeader.Status__c = 'In Progress';
	    	
	    	try{
            	if(AccessControl.ifObjectIsCreateable('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	    		if(AccessControl.ifObjectIsUpdateable('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	    		upsert vrHeader;
	    		
	    		// After Insert, Update all Vendor Order Header for the vendor which are unreceived
	    		updateVendorOrdersReceiving(vrHeader.Id, true);
	    	} catch(Exception e){
	    		//system.assert(false, e);
	    		return BPUtility.getEncodedString(null);
	    	}
	    	return BPUtility.getEncodedString(vrHeader.Id);
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
	/**
     * Name: getVORDetails
     * Desc: Method to get all page details for a Vendor Order Receiving record
     * @param:  (1) vorId - String - Vendor Order Receiving Id
     *			(2) gridName - String - Grid Name
     *			(3) lastEditedPartId - Id - Edited Part Id Recently
     *			(4) vendorOrdersPageSortAttrsJSON - String -Vendor Order Headers Grid Paging and sorting JSON
     *			(5) groupItemsPageSortAttrsJSON - String - Items Grid Paging and sorting JSON
     *			(6) outstandingVOGPageSortAttrsJSON - String - Outstanding Grid Paging and sorting JSON
     * @return: String - JSON String of all CO Line Items of CO Header Record
    **/
    @RemoteAction
    global static String getVORDetails(	String vorId, 
    									String gridName,
    									String lastEditedPartId,
    									String vendorOrdersPageSortAttrsJSON, 
    									String groupItemsPageSortAttrsJSON, 
    									String outstandingVOGPageSortAttrsJSON){
    	try{
    		vorId = BPUtility.getDecodedString(vorId);
    		gridName = BPUtility.getDecodedString(gridName);
    		lastEditedPartId = BPUtility.getDecodedString(lastEditedPartId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
	    	Vendor_Order_Receiving_Id = vorId;
	    	PaginationSorting vendorOrdersPageSortAttrs = PaginationSorting.parsePageAttrs(vendorOrdersPageSortAttrsJSON);
	    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
	    	PaginationSorting outstandingVOGPageSortAttrs = PaginationSorting.parsePageAttrs(outstandingVOGPageSortAttrsJSON);
	    	
	    	VendorOrderReceiving voReceiving = new VendorOrderReceiving(vorId, gridName, lastEditedPartId, vendorOrdersPageSortAttrs, groupItemsPageSortAttrs, outstandingVOGPageSortAttrs);
	    	return BPUtility.getEncodedString(System.JSON.serialize(voReceiving));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
	/**
     * Name: updateVORHeaderDetails
     * Desc: Method to update various details of vendor receiving header
     * @param:  (1) vorId - String - Vendor Order Receiving Id
     *			(2) VORHeaderJSON- String - Vendor Receiving Header Records JSON String
     * @return:  JSON String of ids of Vendor Receiving Header Record
    **/
    @RemoteAction
    global static String updateVORHeaderDetails(String vorId, String VORHeaderJSON){
    	vorId = BPUtility.getDecodedString(vorId);
		VORHeaderJSON = BPUtility.getDecodedString(VORHeaderJSON);
    	
    	VORHeader VORHeaderRec = VORHeader.parse(VORHeaderJSON);
    	Vendor_Receiving_Header__c vorHeaderToUpdate = new Vendor_Receiving_Header__c(	Id = vorId,
		    																			Packing_Slip_Number__c = VORHeaderRec.PackagingSlipNumber,
		    																			Is_Receiving_From_Invoice__c = VORHeaderRec.IsReceivingFromInvoice,
		    																			Receiving_From_Invoice_Total__c = VORHeaderRec.ReceivingFromInvoiceTotal);
    	try{
    		if(AccessControl.ifObjectIsUpdateable('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	    	update vorHeaderToUpdate;
	    	return BPUtility.getEncodedString(System.JSON.serialize(VORHeader.getVORDetails(vorId)));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
	
    /**
     * Name: receiveVendorOrderItems
     * Desc: Method to add/remove slelected vendor order items for receiving
     * @param:  (1) vohId - Selected vendor order Id
     *			(2) vorId - String - Vendor Order Receiving Id
 	 *			(3) isSelected - boolean - is Selected or not
     * @return: String - boolean if successfully selected
    **/
    @RemoteAction
    global static String receiveVendorOrderItems(String vohId, String vorId, boolean isSelected){
    	try{
    		vohId = BPUtility.getDecodedString(vohId);
			vorId = BPUtility.getDecodedString(vorId);
	    	if(vohId != null){
	    		return updateVendorOrdersReceiving(vohId, vorId);
	    	} else {
	    		return updateVendorOrdersReceiving(vorId, isSelected);
	    	}
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: updateVendorOrdersReceiving
     * Desc: Method to add/remove selected vendor order items for receiving
     * @param:  (1) vohId - Selected vendor order Id
     *			(2) vorId - String - Vendor Order Receiving Id
     * @return: String - boolean if successfully selected
    **/
    private static String updateVendorOrdersReceiving(String vohId, String vorId){
    	if(vorId != null) {
	    	In_Progress_VR__c inProgressVRRec = new In_Progress_VR__c();
	    	inProgressVRRec.Vendor_Order_Header__c = vohId;
			inProgressVRRec.Vendor_Receiving_Header__c = vorId;
			
			try{
				if(AccessControl.ifObjectIsCreateable('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);} 
	    		insert inProgressVRRec;
	    	} catch(Exception e){
	    		return BPUtility.getEncodedString('false');
	    	}
    	} else {
    		if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		List<In_Progress_VR__c>	inProgressVRList = [select Vendor_Receiving_Header__c from In_Progress_VR__c 
    														Where Vendor_Receiving_Header__r.Status__c = 'In Progress' 
    																AND Vendor_Order_Header__c = :vohId];
    		//system.assert(false,inProgressVRList);
    		if(inProgressVRList.size() > 0) {
    			if(AccessControl.ifObjectIsDeletable('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
    			delete inProgressVRList;
    		}														
    	}
    	return BPUtility.getEncodedString('true');
    }
    
    /**
     * Name: updateVendorOrdersReceiving
     * Desc: Method to update selected vendor order items for receiving
     * @param:  (1) vorId - String - Vendor Order Receiving Id
     *			(2) isSelected - boolean  - is Selected or not
     * @return: String - boolean if successfully selected
    **/
    private static String updateVendorOrdersReceiving(String vorId, boolean isSelected){
    	List<In_Progress_VR__c> inProgressVRList = new List<In_Progress_VR__c>();
    	if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}

    	if(isSelected){
    		List<In_Progress_VR__c> inProgressList = [select Vendor_Receiving_Header__c,
    													   Vendor_Order_Header__c
														   from In_Progress_VR__c  
														   Where Vendor_Receiving_Header__r.Status__c = 'In Progress' 
												  ];
    		List<Vendor_Receiving_Header__c> vorHeaderRecords = SOQLUtil.getVORDetails('Id', vorId);
    		if(vorHeaderRecords.size() > 0){
    			Set<Id> inProgressVOIds = new Set<id>();
    			for(In_Progress_VR__c ipvr : inProgressList){
    				inProgressVOIds.add(ipvr.Vendor_Order_Header__c);
    			}
    			
	    		List<Vendor_Order_Header__c> voList = SOQLUtil.getVendorOrderHeaderRecords('Vendor__c', vorHeaderRecords[0].Vendor__c, null, true);
	    		In_Progress_VR__c inProgressVRRec;
	    		for(Vendor_Order_Header__c vo : voList){
	    			inProgressVRRec = new In_Progress_VR__c();
	    			if( !inProgressVOIds.contains(vo.Id) ){
	    				inProgressVRRec.Vendor_Order_Header__c = vo.Id;
	    				inProgressVRRec.Vendor_Receiving_Header__c = vorId;
	    				inProgressVRList.add(inProgressVRRec);
	    			}
	    		}
	    		if(inProgressVRList.size() > 0) {
	    			if(AccessControl.ifObjectIsCreateable('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
		    		insert inProgressVRList;
		    	}
    		}
    	} else {
    		inProgressVRList = [select Vendor_Receiving_Header__c,
    													   Vendor_Order_Header__c
														   from In_Progress_VR__c  
														   Where Vendor_Receiving_Header__r.Status__c = 'In Progress' 
														   AND Vendor_Receiving_Header__c = :vorId
												  ];
    		if(inProgressVRList.size() > 0) {
    			if(AccessControl.ifObjectIsDeletable('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
    			delete inProgressVRList;
    		}														
    	}
    	return BPUtility.getEncodedString(String.valueOf(true));
    }
    
    /**
     * Name: addToItemSubsection
     * Desc: Method to add/remove selected vendor order items for receiving
     * @param:  (1) vorId - Id - Selected vendor Receiving Id
     * 			(2) partId - Id- Part Id
     *			(3) vendorId - String - Vendor Id
     *			(4) isFromSearchToAdd - Boolean - Search from Add
   	 *			(5) vendorOrdersPageSortAttrsJSON - String - Vendor Order Headers Grid Paging and sorting JSON
     *			(6) groupItemsPageSortAttrsJSON - String - Items Grid Paging and sorting JSON
     *			(7) outstandingVOGPageSortAttrsJSON - String - Outstanding Grid Paging and sorting JSON
     * @return: String - Json String of Vendor Receiving Header Records 
    **/
    @RemoteAction 
    global static String addToItemSubsection(String vorId, 
    										 String partId, 
    										 String vendorId,
    										 boolean isFromSearchToAdd,
    										 String vendorOrdersPageSortAttrsJSON, 
    										 String groupItemsPageSortAttrsJSON, 
    										 String outstandingVOGPageSortAttrsJSON
    										){
    	try{
    		vorId = BPUtility.getDecodedString(vorId);
    		partId = BPUtility.getDecodedString(partId);
    		vendorId = BPUtility.getDecodedString(vendorId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		vorId = BPUtility.escapeSingleQuotes(vorId);
    		partId = BPUtility.escapeSingleQuotes(partId);
    		vendorId = BPUtility.escapeSingleQuotes(vendorId);
	    	List<Vendor_Order_Line_Item__c> voLineItems = SOQLUtil.getVOLineItemsForGivenPartAndVendorReceiving(partId, vorId);
	    	if(voLineItems.size() == 0 && isFromSearchToAdd) {
	    		if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		if(AccessControl.ifObjectIsAccessible('Vendor_Order_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		voLineItems = [select Id from Vendor_Order_Line_Item__c where Vendor_Order_Header__r.In_Progress_VR__c != :vorId 
	    																		AND Part__c =: partId 
	    																		AND Vendor_Order_Header__r.Vendor__c =: vendorId
	    																		];
	    		if(voLineItems.size() > 0) {																
	    			PaginationSorting vendorOrdersPageSortAttrs = PaginationSorting.parsePageAttrs(vendorOrdersPageSortAttrsJSON);
			    	PaginationSorting groupItemsPageSortAttrs = PaginationSorting.parsePageAttrs(groupItemsPageSortAttrsJSON);
			    	PaginationSorting outstandingVOGPageSortAttrs = PaginationSorting.parsePageAttrs(outstandingVOGPageSortAttrsJSON);
			    	
	    			VendorOrderReceiving voReceiving = new VendorOrderReceiving(vorId, null, null, vendorOrdersPageSortAttrs, groupItemsPageSortAttrs, outstandingVOGPageSortAttrs);
	    			voReceiving.isFoundPartInOtherVOHeader = true;
	    			return BPUtility.getEncodedString(System.JSON.serialize(voReceiving));
	    		} else {
	    			addToItemSubsectionAfterConfimation(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(partId), true, BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON),BPUtility.getEncodedString(groupItemsPageSortAttrsJSON),BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
	    		} 
	    	} else {
	    		return addToItemSubsectionAfterConfimation(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(partId), false,BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON),BPUtility.getEncodedString(groupItemsPageSortAttrsJSON),BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
	    	}
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(partId), 
	    							BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), 
	    							BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: addToItemSubsectionAfterConfimation
     * Desc: Method to add/remove slelected vendor order items for receiving
     * @param:  (1) vorId - Selected vendor Receiving Id
 			    (2) partId - Id- Part Id
     *			(3) isStockExcessGenerated - Boolean - Stock Excess or not 
   	 *			(4) vendorOrdersPageSortAttrsJSON - String - Vendor Order Headers Grid Paging and sorting JSON
     *			(5) groupItemsPageSortAttrsJSON - String - Items Grid Paging and sorting JSON
     *			(6) outstandingVOGPageSortAttrsJSON - String - Outstanding Grid Paging and sorting JSON
     * @return: String - Json String of Vendor Receiving Header Records
    **/
    @RemoteAction
    global static String addToItemSubsectionAfterConfimation(String vorId, String partId, Boolean isStockExcessGenerated, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON) {
    	try{
    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		if(AccessControl.ifObjectFieldIsAccessible('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
    		
    		vorId = BPUtility.getDecodedString(vorId);
    		partId = BPUtility.getDecodedString(partId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		partId = BPUtility.escapeSingleQuotes(partId);
    		vorId = BPUtility.escapeSingleQuotes(vorId);
    		List<Vendor_Receiving_Group__c> vrGroupList = [select Id,Part__r.Last_Cost__c ,Part__r.Packaged_Part__c, Part__r.Package_Qty__c from Vendor_Receiving_Group__c where Part__c = :partId AND Vendor_Receiving_Header__c = :vorId];
    		List<Part__c> PartList = [select Last_Cost__c ,Packaged_Part__c,Package_Qty__c from Part__c where ID = :partId ];
	    	Vendor_Receiving_Group__c vrGroupRec = new Vendor_Receiving_Group__c();
	    	if(vrGroupList.size() > 0) {
	    		vrGroupRec.Id = vrGroupList[0].Id;
	    	} else {
	    		vrGroupRec.Part__c = partId;
	    		vrGroupRec.Vendor_Receiving_Header__c = vorId;
	    		if(isStockExcessGenerated) {
	    			vrGroupRec.Recieved__c = 0;
	    			vrGroupRec.Order__c = 0;
	    		}
	    	}
	    	
	    	if(vrGroupRec.Id == null) {
	    		//if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		if(AccessControl.ifObjectIsCreateable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	    		insert vrGroupRec;
	    	}
	    	
	    	if(!isStockExcessGenerated) {
		    	List<Vendor_Order_Line_Item__c> voLineItems = SOQLUtil.getVOLineItemsForGivenPartAndVendorReceiving(partId, vorId);
		    	Decimal qty = 0;
		    	
		    	for(Vendor_Order_Line_Item__c voliRec : voLineItems) {
		    		voliRec.Vendor_Receiving_Group__c = vrGroupRec.Id;
		    		qty += voliRec.Qty_Needed__c;
		    	}
		    	if(voLineItems.size() == 0) {
		    		//system.assert(false, vrGroupRec);
		    		//update vrGroupRec; 
		    	} else {
			    	if(voLineItems.size() > 0) {
			    		if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
			    		update voLineItems;
			    	}
			    	
			    	if(vrGroupRec.Recieved__c == null) {
			    		vrGroupRec.Recieved__c = 0;	
			    	}	
			    	
			    	vrGroupRec.Recieved__c = vrGroupRec.Recieved__c + qty;
			    	vrGroupRec.Cost__c = voLineItems[0].Cost__c;
			    	if(vrGroupRec.Id != null) {
			    		
			    		update vrGroupRec;
			    	}
		    	}
	    	} else {
	    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		vrGroupList = [select Id, Recieved__c, Part__r.Last_Cost__c, Part__r.Packaged_Part__c, Part__r.Package_Qty__c from Vendor_Receiving_Group__c where Id =:vrGroupRec.Id];
				if(vrGroupList.size() > 0) {
					if(vrGroupList[0].Part__r.Packaged_Part__c) {
						vrGroupList[0].Recieved__c = vrGroupList[0].Recieved__c + vrGroupList[0].Part__r.Package_Qty__c;
					} else {
						vrGroupList[0].Recieved__c = vrGroupList[0].Recieved__c + 1;
					}
					vrGroupRec.Cost__c = vrGroupList[0].Part__r.Last_Cost__c;
	    		}
	    		if(vrGroupList.size() > 0) {
	    			
	    			if(AccessControl.ifObjectIsCreateable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	    			update vrGroupList;
	    		}
	    		/*Vendor_Receiving_Stock_Excess__c vrseRec = new Vendor_Receiving_Stock_Excess__c();
		    	vrseRec.Vendor_Receiving_Group__c = vrGroupRec.Id;
		    	if(partIdList.size() > 0) {
					if(partIdList[0].Packaged_Part__c) {
	    				vrseRec.Received_Qty__c = partIdList[0].Package_Qty__c;
					} else {
						vrseRec.Received_Qty__c = 1;
					}
		    	}
		    	if(vrseRec.Id == null) {
		    		insert vrseRec;
		    	}*/
	    	}
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(partId), 
	    						BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    						BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
	    }catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    
    /**
     * Name: updateItemsSection
     * Desc: Method to update VR Group record qty and cost.
     * @param:  (1) vorId - Vendor Receiving Header Id
     *			(2) partId - Part Id
     *			(3) vrGroupId - Vendor Receiving Group Id which is to be updated
     *			(4) qty - Qtantity Receiving
     *			(5) cost - Cost
     *			(6) vendorOrdersPageSortAttrsJSON - Vendor Order Headers Grid Paging and sorting JSON
     *			(7) groupItemsPageSortAttrsJSON - Items Grid Paging and sorting JSON
     *			(8) outstandingVOGPageSortAttrsJSON - Outstanding Grid Paging and sorting JSON
     * @return: String - JSON String
    **/
    @RemoteAction 
    global static String updateItemsSection(String vorId, String partId, String vrGroupId, Decimal qty, Decimal cost, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON){
    	try{
    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
    		
    		vorId = BPUtility.getDecodedString(vorId);
    		partId = BPUtility.getDecodedString(partId);
    		vrGroupId = BPUtility.getDecodedString(vrGroupId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		vrGroupId = BPUtility.escapeSingleQuotes(vrGroupId);
    		List<Vendor_Receiving_Group__c> vrGroupList = [select Id, Part__r.Packaged_Part__c, Part__r.Package_Qty__c from Vendor_Receiving_Group__c where Id = :vrGroupId];
	    	if(vrGroupList.size() > 0) {
		    	Vendor_Receiving_Group__c vrGroupRec = vrGroupList[0];
		    	if(qty <= 0) {
		    		delete vrGroupRec;
		    	} else {
		    		vrGroupRec.Cost__c = cost;
		    		if(vrGroupRec.Part__r.Packaged_Part__c) {
		    			vrGroupRec.Recieved__c = qty * vrGroupRec.Part__r.Package_Qty__c ;
		    		} else {
		    			vrGroupRec.Recieved__c = qty;
		    		}
		    		update vrGroupRec;
		    	}
	    	}
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(partId),
	    	 						BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), 
	    	 						BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    	 						BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: updateLineItemsOfItemsSection
     * Desc: Method to update VR Group line items (VOLIs) qty.
     * @param:  (1) vorId - Vendor Receiving Header Id
     *			(2) partId - Part Id
     *			(3) vrGroupId - Vendor Receiving Group Id which is to be updated
     *			(4) groupJSONString - JSON String of VR Group record.
     *			(5) vendorOrdersPageSortAttrsJSON - Vendor Order Headers Grid Paging and sorting JSON
     *			(6) groupItemsPageSortAttrsJSON - Items Grid Paging and sorting JSON
     *			(7) outstandingVOGPageSortAttrsJSON - Outstanding Grid Paging and sorting JSON
     * @return: String - JSON String
    **/
    @RemoteAction 
    global static String updateLineItemsOfItemsSection(String vorId, String partId, String vrGroupId, String groupJSONString, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON){
    	try{
    		vorId = BPUtility.getDecodedString(vorId);
    		partId = BPUtility.getDecodedString(partId);
    		vrGroupId = BPUtility.getDecodedString(vrGroupId);
    		groupJSONString = BPUtility.getDecodedString(groupJSONString);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
	    	List<VORGroup> vorGrpList = (List<VORGroup>) System.JSON.deserialize(groupJSONString, List<VORGroup>.class);
	    	Map<Id, Decimal> voliIdToReceivingQtyMap = new Map<Id, Decimal>();
	    	for(VORGroup vrgObj : vorGrpList) {
	    		for(VendorOrderLineItem voliRec : vrgObj.VendorOrderLineItemList) {
	    			if(!voliIdToReceivingQtyMap.containsKey(voliRec.Id)) {
	    				voliIdToReceivingQtyMap.put(voliRec.Id, voliRec.ReceivedQty);
	    			} 
	    		}
	    	}
	    	
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	vrGroupId = BPUtility.escapeSingleQuotes(vrGroupId);
	    	List<Vendor_Receiving_Group__c> vrGroupList = [select Id, (select Id, Received__c from Vendor_Order_Line_Items__r) from Vendor_Receiving_Group__c where Id = :vrGroupId];
	    	
	    	List<Vendor_Order_Line_Item__c> voliListToUpdate = new List<Vendor_Order_Line_Item__c>();
	    	for(Vendor_Receiving_Group__c vrgRec : vrGroupList) {
	    		for(Vendor_Order_Line_Item__c voliRec : vrgRec.Vendor_Order_Line_Items__r) {
	    			if(voliIdToReceivingQtyMap.containsKey(voliRec.Id)) {
	    				voliRec.Received__c = voliIdToReceivingQtyMap.get(voliRec.Id);
	    				voliListToUpdate.add(voliRec);
	    			}
	    		}
	    	}
	    	
	    	if(voliListToUpdate.size() > 0) {
	    		if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	    		update voliListToUpdate;
	    	}
	    	
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(partId), 
	    							BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    							BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    
    /**
     * Name: addAllLineItemsToItemSubsection
     * Desc: Method to add all vendor order items form outstanding Grid to Items Section
     * @param:  (1) vorId - Vendor Receiving Header Id
     *			(2) voHeaderId -  Vendor Order Header Record Id
     *			(3) voGroupId -  Vendor Order Group Record Id
     *			(4) vendorOrdersPageSortAttrsJSON - Vendor Order Headers Grid Paging and sorting JSON
     *			(5) groupItemsPageSortAttrsJSON - Items Grid Paging and sorting JSON
     *			(6) outstandingVOGPageSortAttrsJSON - Outstanding Grid Paging and sorting JSON
     * @return: String - Json String
    **/
    @RemoteAction 
    global static String addAllLineItemsToItemSubsection(String vorId, String voHeaderId, String voGroupId, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON){
    	try{
    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Receiving_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
    		
    		vorId = BPUtility.getDecodedString(vorId);
    		voHeaderId = BPUtility.getDecodedString(voHeaderId);
    		voGroupId = BPUtility.getDecodedString(voGroupId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
    		List<Vendor_Order_Line_Item__c> voLineItems = new List<Vendor_Order_Line_Item__c>();
	    	if(vorId != null) {
	    		if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		vorId = BPUtility.escapeSingleQuotes(vorId);
	    		List<In_Progress_VR__c> inProgressVRList = [select Vendor_Order_Header__c from In_Progress_VR__c Where Vendor_Receiving_Header__c =: vorId AND Vendor_Receiving_Header__r.Status__c = 'In Progress'];
	    		
	    		List<String> voHeaderIdList = new List<String>();
	    		for(In_Progress_VR__c inProgreeVIRec : inProgressVRList) {

	    			voHeaderIdList.add(inProgreeVIRec.Vendor_Order_Header__c);
	    		}
	    		voLineItems = SOQLUtil.getVOLineItemByFieldValue(new Map<String, List<String>> {'Vendor_Order_Header__c' => voHeaderIdList});
	    		
	    		List<Vendor_Order_Line_Item__c> tempVOLIItems = new List<Vendor_Order_Line_Item__c>(voLineItems);
	    		voLineItems.clear();
	    		for(Vendor_Order_Line_Item__c voli : tempVOLIItems){
	    			if(voli.Vendor_Receiving_Group__c == null){
	    				voLineItems.add(voli);
	    			}
	    		}
	    	} else if(voHeaderId != null) {
	    		voLineItems = SOQLUtil.getVOLineItemByFieldValue(new Map<String, String> {'Vendor_Order_Header__c' => voHeaderId});
	    	} else if(voGroupId != null) {
	    		voLineItems = SOQLUtil.getVOLineItemByFieldValue(new Map<String, String> {'Vendor_Order_Line_Item_Group__c' => voGroupId, 'Vendor_Order_Header__c' => null});
	    	}
	    	
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
			vorId = BPUtility.escapeSingleQuotes(vorId);
	    	List<Vendor_Receiving_Group__c> vrGroupList = [select Id, Part__c from Vendor_Receiving_Group__c where Vendor_Receiving_Header__c = :vorId];
	    	
	    	//Savepoint sp = Database.setSavepoint();
	    	
	    	Map<Id, Id> partIdToVRGroupIdMap = new Map<Id, Id>();
	    	for(Vendor_Receiving_Group__c vrGroup : vrGroupList) {
	    		if(!partIdToVRGroupIdMap.containsKey(vrGroup.Part__c)) {
	    			partIdToVRGroupIdMap.put(vrGroup.Part__c, vrGroup.Id);
	    		}
	    	}
	    	
	    	List<Vendor_Receiving_Group__c> vrGroupListToInsert = new List<Vendor_Receiving_Group__c>(); 
	    	Vendor_Receiving_Group__c vrGroupRec;
	    	for(Vendor_Order_Line_Item__c voliRec : voLineItems) {
	    		if(!partIdToVRGroupIdMap.containsKey(voliRec.Part__c)) {
	    			vrGroupRec = new Vendor_Receiving_Group__c();
	    			vrGroupRec.Part__c = voliRec.Part__c;
	    			vrGroupRec.Cost__c = voliRec.Cost__c;
	    			vrGroupRec.Vendor_Receiving_Header__c = vorId;
	    			vrGroupListToInsert.add(vrGroupRec);
	    			partIdToVRGroupIdMap.put(voliRec.Part__c, null);
	    		}
	    	}
	    	
	    	if(vrGroupListToInsert.size() > 0) {
	    		if(AccessControl.ifObjectIsCreateable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE);}
	    		insert vrGroupListToInsert;
	    	}
	    	
	    	for(Vendor_Receiving_Group__c vrgRec : vrGroupListToInsert) {
	    		if(partIdToVRGroupIdMap.containsKey(vrgRec.Part__c)) {
	    			partIdToVRGroupIdMap.put(vrgRec.Part__c, vrgRec.Id);
	    		}
	    	}
	    	
	    	for(Vendor_Order_Line_Item__c voliRec : voLineItems) {
	    		voliRec.Vendor_Receiving_Group__c = partIdToVRGroupIdMap.get(voliRec.Part__c);
	    	}
	    	
	    	if(voLineItems.size() > 0) {
	    		update voLineItems;
	    	}
	    	
	    	vrGroupList = [select Id, Recieved__c, (select Qty_Needed__c from Vendor_Order_Line_Items__r) from Vendor_Receiving_Group__c where Id IN :vrGroupListToInsert];
	    	for(Vendor_Receiving_Group__c vrgRec : vrGroupList) {
	    		Decimal need = 0;
	    		for(Vendor_Order_Line_Item__c voliRec : vrgRec.Vendor_Order_Line_Items__r) {
	    			need += voliRec.Qty_Needed__c;
	    		}
	    		vrgRec.Recieved__c = need;
	    	}
	    	
	    	if(vrGroupList.size() > 0) {
	    		update vrGroupList;
	    	}
	    	
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null), 
	    						BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    						BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    
    /**
     * Name: removeItem
     * Desc: Method to remove VR Group Record
     * @param:  (1) vorId - Selected vendor Receiving Id
     *			(2) vrGroupId - VR Group Id which is to be removed
     *			(3) vendorOrdersPageSortAttrsJSON - Vendor Order Headers Grid Paging and sorting JSON
     *			(4) groupItemsPageSortAttrsJSON - Items Grid Paging and sorting JSON
     *			(5) outstandingVOGPageSortAttrsJSON - Outstanding Grid Paging and sorting JSON
     * @return: String - JSON String
    **/
    @RemoteAction 
    global static String removeItem(String vorId, String vrGroupId, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON){
    	try{
    		vorId = BPUtility.getDecodedString(vorId);
    		vrGroupId = BPUtility.getDecodedString(vrGroupId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		vrGroupId = BPUtility.escapeSingleQuotes(vrGroupId);
    		List<Vendor_Receiving_Group__c> vrGroupList = [select Id from Vendor_Receiving_Group__c where Id = :vrGroupId];
	    	if(vrGroupList.size() > 0) {
	    		if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	    		delete vrGroupList[0];
	    	}
	    	
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null), 
	    						BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    						BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: removeAllItemsFromItemSubSection
     * Desc: Method to remove all VR Group
     * @param:  (1) vorId - Selected vendor Receiving Id
     *			(2) vendorOrdersPageSortAttrsJSON - Vendor Order Headers Grid Paging and sorting JSON
     *			(3) groupItemsPageSortAttrsJSON - Items Grid Paging and sorting JSON
     *			(4) outstandingVOGPageSortAttrsJSON - Outstanding Grid Paging and sorting JSON
     * @return: String - JSON String
    **/
    @RemoteAction 
    global static String removeAllItemsFromItemSubSection(String vorId, String vendorOrdersPageSortAttrsJSON, String groupItemsPageSortAttrsJSON, String outstandingVOGPageSortAttrsJSON){
    	try{
    		vorId = BPUtility.getDecodedString(vorId);
    		vendorOrdersPageSortAttrsJSON = BPUtility.getDecodedString(vendorOrdersPageSortAttrsJSON);
    		groupItemsPageSortAttrsJSON = BPUtility.getDecodedString(groupItemsPageSortAttrsJSON);
    		outstandingVOGPageSortAttrsJSON = BPUtility.getDecodedString(outstandingVOGPageSortAttrsJSON);
    		
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		vorId = BPUtility.escapeSingleQuotes(vorId);
    		List<Vendor_Receiving_Group__c> vrGroupList = [select Id from Vendor_Receiving_Group__c where Vendor_Receiving_Header__c = :vorId];
	    	if(vrGroupList.size() > 0) {
	    		if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
	    		delete vrGroupList;
	    	}
	    	return getVORDetails(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null), 
	    						BPUtility.getEncodedString(vendorOrdersPageSortAttrsJSON), BPUtility.getEncodedString(groupItemsPageSortAttrsJSON), 
	    						BPUtility.getEncodedString(outstandingVOGPageSortAttrsJSON));
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
    	return null;
    }
    
    /**
     * Name: getCoHeaderById
     * Desc: Method which give JSOn string of CO Header Rec Related to Given CO Header Id
     * @param:  (1) coHeaderId - String - CO Header record Id
     * @return: String - JSON String of CO Header Record
    **/
    @RemoteAction
    global static String getCoHeaderById(String coHeaderId){
    	try{
    		coHeaderId = BPUtility.getDecodedString(coHeaderId);
	        List<CO_Header__c> coHeaderList = SOQLUtil.getCOHeaderDetails(coHeaderId);
	        List<COHeader> coHeaderObjList = new List<COHeader>();
	        for(CO_Header__c coHeaderRec : coHeaderList) {
	            coHeaderObjList.add(new COHeader(coHeaderRec));
	        } 
	        return BPUtility.getEncodedString(System.JSON.serialize(coHeaderObjList));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: getGroupRecDetail
     * Desc: Method which give JSOn string of CO Header Rec Related to Given CO Header Id
     * @param:  (1) coHeaderId - String - CO Header record Id
     * @return: String - JSON String of CO Header Record
    **/
    @RemoteAction
    global static String getGroupRecDetail(String vrGroupId){
    	try{
    		vrGroupId = BPUtility.getDecodedString(vrGroupId);
	        List<Vendor_Receiving_Group__c> vrGroupList = SOQLUtil.getVORGroupsWithItems('Id', vrGroupId);
	        List<VRGroupDetail> vrGroupDetailList = new List<VRGroupDetail>();
	        for(Vendor_Receiving_Group__c vrGroupRec : vrGroupList) {
	            vrGroupDetailList.add(new VRGroupDetail(vrGroupRec));
	        } 
	        return BPUtility.getEncodedString(System.JSON.serialize(vrGroupDetailList));
    	}catch(Exception e){
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: commitRecevingAction
     * Desc: Method to do action after commit receive button is clicked. 
     * @param:  (1) vrHeaderId - String - VR Header record Id
     * @return: String - JSON String of CO Header Record
    **/
    @RemoteAction
    global static String commitRecevingAction(String vrHeaderId){
    	vrHeaderId = BPUtility.getDecodedString(vrHeaderId);
        // Change Status of VR Header to Stocked.
        //system.assert(false, 'Hello - ' + vrHeaderId);
        Savepoint sp = Database.setSavepoint();
        try{
        	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
        	if(AccessControl.ifObjectIsAccessible('Service_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
        	if(AccessControl.ifObjectIsAccessible('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
        	if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
        	if(AccessControl.ifObjectIsUpdateable('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
        	if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	if(AccessControl.ifObjectFieldIsCreateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        	
	        Vendor_Receiving_Header__c vrHeaderRec = new Vendor_Receiving_Header__c(Id = vrHeaderId);
	        vrHeaderRec.Status__c = 'Stocked';
	        vrHeaderRec.Finalized_Date__c = Date.today();
	        if(vrHeaderId != null) {
	        	//if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	       		if(AccessControl.ifObjectIsUpdateable('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        	update vrHeaderRec;
	        }
	        
	        
	        if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
			vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
	        List<Vendor_Receiving_Group__c> vrGroupList = [select Recieved__c, Cost__c, Part__c, Part__r.Qty_On_Order__c, Part__r.Last_Cost__c, Part__r.Qty_In_Stock__c, 
	        														(select Received__c, Is_required_For_Customer__c, Is_Service__c from Vendor_Order_Line_Items__r)
	        														from Vendor_Receiving_Group__c 
	        														where Vendor_Receiving_Header__c =: vrHeaderId];
	        List<Part__c> partListToUpdate = new List<Part__c>();
	        List<Part__c> partListForBucket = new List<Part__c>();
			Map<Id,Part__c> updateOnOrderMap = new  Map<Id,Part__c>();
	        Part__c partRec;
	        Part__c bucketPartRec;
	        for(Vendor_Receiving_Group__c vrGroupRec : vrGroupList) {
	        	partRec = new Part__c(Id = vrGroupRec.Part__c);
	        	partRec.Last_Cost__c = vrGroupRec.Cost__c;
	        	if(vrGroupRec.Part__r.Qty_In_Stock__c == null) {
	        		vrGroupRec.Part__r.Qty_In_Stock__c = 0;
	        	}
	        	Decimal receiviedStockQty = 0;
	        	bucketPartRec = new Part__c(Id = vrGroupRec.Part__c);
	        	bucketPartRec.Qty_In_Stock__c = 0;
	        	for(Vendor_Order_Line_Item__c voliRecord : vrGroupRec.Vendor_Order_Line_Items__r) {
	        		if(!voliRecord.Is_required_For_Customer__c && !voliRecord.Is_Service__c) {
	        			receiviedStockQty += voliRecord.Received__c;
	        		}
	        		//bucketPartRec.Qty_In_Stock__c += voliRecord.Received__c;
	        	}
	        	partRec.Qty_On_Order__c = vrGroupRec.Part__r.Qty_On_Order__c - receiviedStockQty;
	        	bucketPartRec.Qty_On_Order__c = vrGroupRec.Part__r.Qty_On_Order__c - receiviedStockQty;
	        	if(partRec.Qty_On_Order__c < 0) {
	        		partRec.Qty_On_Order__c = 0;
	        		bucketPartRec.Qty_On_Order__c =0;
	        	}
	        	partRec.Qty_In_Stock__c = vrGroupRec.Recieved__c;
	        	


	        	// part record for bucket
	        	bucketPartRec.Qty_In_Stock__c=  vrGroupRec.Recieved__c;
	        	bucketPartRec.Last_Cost__c = vrGroupRec.Cost__c; 
	        	partListToUpdate.add(partRec);
	        	if(!updateOnOrderMap.containsKey(partRec.Id)){
	        		updateOnOrderMap.put(partRec.Id,partRec);
	        	}
	        	partListForBucket.add(bucketPartRec);
	        }
	        
	        if(partListToUpdate.size() > 0) {
	        	
	        	//update partListToUpdate;
	        }
	        if(partListForBucket.size() > 0) {
	        	
	        	FIFOTransaction.createFIFOBucketForVendorReceiving(partListForBucket, vrHeaderId,updateOnOrderMap);
	        }
	        
	        
	        // Find all VOLIs from Items subsections
	       vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
	        List<Vendor_Order_Line_Item__c> volis = [select Part__c, Is_Received__c, CO_Header__c, Vendor_Order_Line_Item_Group__c, Vendor_Order_Header__c, Is_Excess__c, Vendor_Order_Header__r.In_Progress_VR__c, CO_Line_Item__c, CO_Line_Item__r.Qty_Committed__c, Is_required_For_Customer__c, Qty_Needed__c, Received__c, Vendor_Receiving_Group__c, 
	        												Is_Service__c from Vendor_Order_Line_Item__c Where Vendor_Receiving_Group__r.Vendor_Receiving_Header__c =: vrHeaderId];
	        
	        Map<Id, Decimal> coliIdToReceivedQtyMap = new Map<Id, Decimal>();
	        for(Vendor_Order_Line_Item__c voliRec : volis) {
	        	if(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c) {
	        		if(!coliIdToReceivedQtyMap.containsKey(voliRec.CO_Line_Item__c)) {
	        			coliIdToReceivedQtyMap.put(voliRec.CO_Line_Item__c, voliRec.Received__c);
	        		}
	        	}
	        }
	        
	       

	        List<CO_Line_Item__c> coLineItems = [select Name, Qty_Committed__c, Special_Order__c, CO_Kit_Header__c, CO_Header__c, Qty__c, Part__c, Price__c, Tax__c, Service_Order_Line_Item__c,
	        											(select Vendor_Order_Line_Item_Group__c, Status__c, Is_Received__c, Vendor_Order_Header__c from Vendor_Order_Line_Items__r where Is_Received__c = false)
	        											from CO_Line_Item__c where Id IN: coliIdToReceivedQtyMap.keyset()];
	        
	        
	        List<CO_Line_Item__c> coliListToUpdate = new List<CO_Line_Item__c>();
	        List<CO_Line_Item__c> coliListToInsert = new List<CO_Line_Item__c>();
	        Map<Id, List<CO_Line_Item__c>> vogIdToCOLIListMap = new Map<Id, List<CO_Line_Item__c>>();
	        Map<Id, Id> vogIdToVOHeaderIdMap = new Map<Id, Id>();
	        List<Service_Order_Line_Item__c> soListToUpdate = new List<Service_Order_Line_Item__c>();
	        Set<Id> voliIdSetForSO = new Set<Id>();
	        
	        //system.assert(false, coLineItems);
	        List<Vendor_Order_Line_Item__c> voliToUpdate = new List<Vendor_Order_Line_Item__c>();
	        
	        for(CO_Line_Item__c coliRec : coLineItems) {
	        	Decimal receivedQty = coliIdToReceivedQtyMap.get(coliRec.Id);
	        	Decimal requiredQty = coliRec.Qty__c - coliRec.Qty_Committed__c;
	        	
	        	if(receivedQty > 0 && receivedQty < requiredQty && coliRec.Service_Order_Line_Item__c == null && coliRec.CO_Kit_Header__c == null) {
	        		CO_Line_Item__c newCOLIRec = new CO_Line_Item__c();
	    			newCOLIRec = coliRec.clone(false, false, false, false);
	    			newCOLIRec.Qty_Committed__c = 0;
	    			system.debug('QtyRequired'+','+ requiredQty +','+ receivedQty);
	    			newCOLIRec.Qty__c = requiredQty - receivedQty;
	    			newCOLIRec.Status__c= 'Ordered';
	    			newCOLIRec.VO_Status__c= 'On Order';
	    		//	for(Vendor_Order_Line_Item  )
	    		//newCOLIRec.VO_Number__c = coliRec.Vendor_Order_Line_Item__r[0].Vendor_Order_Header__c;  
	    			//Need to Vo Header Name to VO number;

	    			if(coliRec.Vendor_Order_Line_Items__r.size() > 0) {
	    				Vendor_Order_Line_Item__c voliRecord = coliRec.Vendor_Order_Line_Items__r[0];
	    				
	    				if(!vogIdToCOLIListMap.containsKey(voliRecord.Vendor_Order_Line_Item_Group__c)) {
	    					vogIdToCOLIListMap.put(voliRecord.Vendor_Order_Line_Item_Group__c, new List<CO_Line_Item__c>{newCOLIRec});
	    				} else {
	    					List<CO_Line_Item__c> coliList = vogIdToCOLIListMap.get(voliRecord.Vendor_Order_Line_Item_Group__c);
	    					coliList.add(newCOLIRec);
	    					vogIdToCOLIListMap.put(voliRecord.Vendor_Order_Line_Item_Group__c, coliList);
	    				}
	    				vogIdToVOHeaderIdMap.put(voliRecord.Vendor_Order_Line_Item_Group__c, voliRecord.Vendor_Order_Header__c);
	    				
	    			}

	    			coliRec.Qty__c = coliRec.Qty_Committed__c + receivedQty;
	    			coliRec.Status__c  =  'Received';
	    			coliRec.VO_Status__c= 'Received';
	    			for(Vendor_Order_Line_Item__c voliRec : coliRec.Vendor_Order_Line_Items__r) {
	    				voliRec.Status__c = 'Received';
	    				voliToUpdate.add(voliRec);
	    			}
	    			
	        	} else if(coliRec.Service_Order_Line_Item__c == null && coliRec.CO_Kit_Header__c == null) {
	        		for(Vendor_Order_Line_Item__c voliRec : coliRec.Vendor_Order_Line_Items__r) {
	    				voliRec.Status__c = 'Received';
	    				voliToUpdate.add(voliRec);
	    			}
	    			coliRec.Status__c  =  'Received';
	    			coliRec.VO_Status__c= 'Received';
	    			//coliRec.Qty__c = coliRec.Qty_Committed__c + receivedQty;
	    			coliRec.Qty_Committed__c = coliRec.Qty_Committed__c + receivedQty;
	        	} else if(receivedQty > 0){
	        		coliRec.Qty_Committed__c = coliRec.Qty_Committed__c + receivedQty;

	        		if(coliRec.Service_Order_Line_Item__c != null) {
	        			Service_Order_Line_Item__c soliRec = new Service_Order_Line_Item__c(Id = coliRec.Service_Order_Line_Item__c);
	        			soliRec.Qty_Committed__c = coliRec.Qty_Committed__c;
	        			soListToUpdate.add(soliRec);
	        			
	        			if(coliRec.Vendor_Order_Line_Items__r.size() > 0) {
	        				voliIdSetForSO.add(coliRec.Vendor_Order_Line_Items__r[0].Id);
	        			}
	        		}
	        		else if( coliRec.CO_Kit_Header__c != null && coliRec.Vendor_Order_Line_Items__r.size() > 0){
	        			voliIdSetForSO.add(coliRec.Vendor_Order_Line_Items__r[0].Id);
	        		}
	        	} 
	        	
	    		coliRec.Special_Order__c = false;
	    		coliListToUpdate.add(coliRec);
	        }
	       	
	       	
	        	
	        if(soListToUpdate.size() > 0) {
	        	ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
	        	COLineItemTriggerHelper.isVOLIInsertFromVRPage = false;
	        	if(AccessControl.ifObjectIsUpdateable('Service_Order_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        	update soListToUpdate;

	        	// To update Is Invoicable check box.
	        	update soListToUpdate;
	        }
	        
	        //List<CO_Invoice_Item__c> co = [select Service_Order_Header__c, Is_Invoiceable__c, isActive__c from CO_Invoice_Item__c where Id = 'a0Mo0000007N1X1'];
	        //Database.rollback(sp);
	        //system.assert(false, co);
	        
	      
	        List<Service_Order_Line_Item__c> soli = [select Name, Service_Order_Header__c from Service_Order_Line_Item__c];
	        
	        if(vogIdToCOLIListMap.size() > 0) {
		        for(List<CO_Line_Item__c> coliList : vogIdToCOLIListMap.values()) {
		     		coliListToInsert.addAll(coliList);
		        }
		        
	        }
	        
	     
	        if(coliListToUpdate.size() > 0) {
	        	COLineItemTriggerHelper.isTriggerExecute = false;
	        	COLineItemTriggerHelper.isVOLIInsertFromVRPage = false;
	        	//COTriggerHelper.isTriggerExecute = false;
	        	
	        	/// Called  insert isVoliinsert automatically add new item
	        	//update coliListToUpdate;
	        	
	        	// Update Is invoicable Flag of Co Invoice Item in case of CO Kit Header.
	        	if(AccessControl.ifObjectIsUpdateable('CO_Line_Item__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	        	update coliListToUpdate;
	        	if(voliToUpdate.size() > 0) {
	        		
	        		update voliToUpdate;
	        	}
	        }
	        
	        // SO RELATED CHANGES
	        List<Vendor_Order_Line_Item__c> voliListInCaseOfSO = new List<Vendor_Order_Line_Item__c>();
	        
	        // Update Old VOLI's QTY NEEDED in case of Partial Receiving
	        
	        List<Vendor_Order_Line_Item__c> oldVOLIList = [select Qty_Needed__c, CO_Header__c,Status__c, CO_Line_Item__c,CO_Line_Item__r.Status__c,CO_Line_Item__r.VO_Status__c, Is_Excess__c, Is_From_Search__c, Is_Received__c, Is_required_For_Customer__c, Is_Service__c, 
	        													Part__c, Qty_Ordered__c, Vendor_Order_Header__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c,
	        													Received__c from Vendor_Order_Line_Item__c where CO_Line_Item__c IN :coliListToUpdate];
	        													
	        
	        List<Vendor_Order_Line_Item__c> voliListToInsertInCaseOfSO = new List<Vendor_Order_Line_Item__c>();
	        List<CO_Line_Item__c> coliListToupdateStatus = new List<CO_Line_Item__c>();
	        
	         

	        for(Vendor_Order_Line_Item__c oldVOLI : oldVOLIList) {
	        		if(oldVOLI.Received__c != null && (oldVOLI.Qty_Needed__c > oldVOLI.Received__c) && oldVOLI.Received__c > 0) {
	        			if(voliIdSetForSO.contains(oldVOLI.Id)) {
	        				    voliListInCaseOfSO.add(oldVOLI);
	        					oldVOLI.Is_Received__c = true;
	        					oldVOLI.Status__c = 'Received';
				        		Vendor_Order_Line_Item__c voliRecForSO = oldVOLI.clone(false, false, false, false);
				        		voliRecForSO.Vendor_Order_Line_Item_Group__c = oldVOLI.Vendor_Order_Line_Item_Group__c;
					        	voliRecForSO.Received__c = 0;
					        	voliRecForSO.Qty_Needed__c = oldVOLI.Qty_Needed__c - oldVOLI.Received__c;
					        	voliRecForSO.Is_Received__c = false;
					        	
					        	CO_Line_Item__c colirec =  new CO_Line_Item__c( Id = voliRecForSO.CO_Line_Item__c);
					        	colirec.Status__c = 'Ordered';
					        	colirec.Status__c = 'On Order';
	    						voliRecForSO.Status__c = 'On Order';
					        	voliListToInsertInCaseOfSO.add(voliRecForSO);
					        	coliListToupdateStatus.add(colirec);
	        			}
			        	oldVOLI.Qty_Needed__c = oldVOLI.Received__c ;	
	        		}
	        		else if( oldVOLI.Qty_Needed__c == oldVOLI.Received__c){  
	        				if(voliIdSetForSO.contains(oldVOLI.Id)) {
	        						oldVOLI.Status__c = 'Received';
	        						oldVOLI.Is_Received__c = true;
	        						voliListInCaseOfSO.add(oldVOLI);
	        						
	        				}
	        		
	        		}
	        }
	        
	        if(oldVOLIList.size() > 0) { 
	        	VendorOrderLineItemTriggerHelper.isTriggerExecute = false;
	        	update oldVOLIList;
	        }
	        
	        if(voliListToInsertInCaseOfSO.size() > 0) {
	        	VendorOrderLineItemTriggerHelper.isTriggerExecute = true;
	        	insert voliListToInsertInCaseOfSO;
	        	update coliListToupdateStatus;
	        }
	        
			
	        if(coliListToInsert.size() > 0) {
	        	insert coliListToInsert;
	        	//COLineItemTriggerHelper.isVOLIRecToInsert = true;
	        	//update coliListToInsert;
	        }
	        
	        // Find all VOLIs from Items subsections
	    
	      
	        
	        
	        Map<Id, Id> coliIdToVogIdMap = new Map<Id, Id>();
	        for(Id vogId : vogIdToCOLIListMap.keySet()) {
	        	for(CO_Line_Item__c coli : vogIdToCOLIListMap.get(vogId)) {
	        		if(!coliIdToVogIdMap.containsKey(coli.Id)) {
	        			coliIdToVogIdMap.put(coli.Id, vogId);
	        		} 
	        	}
	        }
	        
	        List<Vendor_Order_Line_Item__c> newInsertedVOLIList = [select Vendor_Order_Header__c,Status__c, Part__c, CO_Line_Item__c, Vendor_Receiving_Group__c
	        															from Vendor_Order_Line_Item__c Where CO_Line_Item__c IN : coliListToInsert];
	        
	        
	        List<Id> partIdList = new List<Id>();
	        //To Be changed by 
	        for(Vendor_Order_Line_Item__c voliRec : newInsertedVOLIList) {
	        	//partIdList.add(voliRec.Part__c);
	        	voliRec.Vendor_Order_Line_Item_Group__c = coliIdToVogIdMap.get(voliRec.CO_Line_Item__c);
	        	voliRec.Vendor_Order_Header__c = vogIdToVOHeaderIdMap.get(coliIdToVogIdMap.get(voliRec.CO_Line_Item__c));
	        	voliRec.Status__c = 'On Order';
	        }
	        
	        if(newInsertedVOLIList.size() > 0) {
	    		update newInsertedVOLIList;
	    	}
	    	vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
	    	volis = [select Part__c, CO_Header__c, Vendor_Order_Line_Item_Group__c, Vendor_Order_Header__c, Is_Service__c, Is_Excess__c, Vendor_Order_Header__r.In_Progress_VR__c, CO_Line_Item__c, CO_Line_Item__r.Qty_Committed__c, Is_required_For_Customer__c, Qty_Needed__c, Received__c, Vendor_Receiving_Group__c
	        												from Vendor_Order_Line_Item__c Where Vendor_Receiving_Group__r.Vendor_Receiving_Header__c =: vrHeaderId];
	       	
	        // Stocking Partial Receiving
	        List<Vendor_Order_Line_Item__c> stockVOLIListToInsert = new List<Vendor_Order_Line_Item__c>();
	        for(Vendor_Order_Line_Item__c voliRec : volis) {
	        	if(!voliRec.Is_required_For_Customer__c && voliRec.Qty_Needed__c > voliRec.Received__c && voliRec.Received__c > 0) {
	        		Vendor_Order_Line_Item__c newVoliRec = new Vendor_Order_Line_Item__c();
	        		newVoliRec = voliRec.clone(false, true, false, false);
	        		newVoliRec.Received__c = 0;
	        		newVoliRec.Qty_Needed__c = voliRec.Qty_Needed__c - voliRec.Received__c;
	        		newVoliRec.Vendor_Receiving_Group__c = null;
	        		stockVOLIListToInsert.add(newVoliRec);
	        		
	        		voliRec.Qty_Needed__c = voliRec.Received__c;
	        	}
	        	if(voliRec.Received__c == 0) {
	        		voliRec.Vendor_Receiving_Group__c = null;
	        	}  
	        }
	        
	        
	        if(stockVOLIListToInsert.size() > 0) {
	        	insert stockVOLIListToInsert;
	        } 
	        
	        if(volis.size() > 0) {
	        	update volis;
	        }
	        
	        // Updataion of status of Vendor Order Header
	        if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	        vrHeaderId = BPUtility.escapeSingleQuotes(vrHeaderId);
	        List<In_Progress_VR__c> ipvrList = [select Vendor_Order_Header__c from In_Progress_VR__c Where Vendor_Receiving_Header__c =: vrHeaderId];
	        List<Id> voHeaderIdList = new List<Id>();
	        
	        for(In_Progress_VR__c ipvrRec : ipvrList) {
	        	voHeaderIdList.add(ipvrRec.Vendor_Order_Header__c);
	        }
	        
	        if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}

	    	List<Vendor_Order_Line_Item_Group__c> voliGroupList = [select Vendor_Order_Header__c, Need__c, Received_Qty__c, (Select Received__c, Qty_Needed__c from Vendor_Order_Line_Items__r) 
	    																from Vendor_Order_Line_Item_Group__c 
	    																where Vendor_Order_Header__c IN :voHeaderIdList];
	    	
	    	Map<Id, Vendor_Order_Header__c> voHeaderMapToUpdate = new Map<Id, Vendor_Order_Header__c>();
	
	    	for(Vendor_Order_Line_Item_Group__c volig : voliGroupList) {
	    		Decimal receivedQty = 0;
	    		String voStatus;
	    		for(Vendor_Order_Line_Item__c voliRec : volig.Vendor_Order_Line_Items__r) {
	    			if(voliRec.Received__c != null) {
	    				receivedQty += voliRec.Received__c;
	    			}
	    		}
	    		volig.Received_Qty__c = receivedQty;
	    		
	    		if(volig.Received_Qty__c == volig.Need__c) {
	    			voStatus = 'Received';
	    		} else {
	    			voStatus = 'Partially Received';
	    		}
	    		Vendor_Order_Header__c voHeaderRec = new Vendor_Order_Header__c(Id = volig.Vendor_Order_Header__c);
		    	voHeaderRec.Status__c = voStatus;
		    	if(!voHeaderMapToUpdate.containsKey(voHeaderRec.Id)) {
		    		voHeaderMapToUpdate.put(voHeaderRec.Id, voHeaderRec);
		    	} else if(voStatus == 'Partially Received'){
	    			voHeaderMapToUpdate.put(voHeaderRec.Id, voHeaderRec);
		    	} 
	    	}
	    	
	    	if(voliGroupList.size() > 0) {
	    		if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Line_Item_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	    		update voliGroupList;
	    	}
	    	
	    	if(voHeaderMapToUpdate.size() > 0) {
	    		if(AccessControl.ifObjectIsUpdateable('Vendor_Order_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE);}
	    		update voHeaderMapToUpdate.values();
	    	}
	    	
	    	/*Map<Id, Vendor_Order_Header__c> voHeaderMapToUpdate = new Map<Id, Vendor_Order_Header__c>();
	    	for(Vendor_Order_Line_Item_Group__c volig : voliGroupList) {
	    		String voStatus;
	    		for(Vendor_Order_Line_Item__c voliRec : volig.Vendor_Order_Line_Items__r) {
	    			if(voliRec.Qty_Needed__c == voliRec.Received__c) {
	    				voStatus = 'Received';
	    			} else {
	    				voStatus = 'Partially Received';
	    				break;
	    			}
	    		}
	    		Vendor_Order_Header__c voHeaderRec = new Vendor_Order_Header__c(Id = volig.Vendor_Order_Header__c);
		    	voHeaderRec.Status__c = voStatus;
		    	voHeaderMapToUpdate.put(voHeaderRec.Id, voHeaderRec);
	    	}*/
	    	
	    	
	    	// Changed VOG received Qty.
	    	
	    	/*List<Service_Order_Line_Item__c> voliAssert1 = [select Qty_Needed__c, CO_Header__c, CO_Line_Item__c, Is_Excess__c, Is_From_Search__c, Is_Received__c, Is_required_For_Customer__c, Is_Service__c, 
	        													Part__c, Qty_Ordered__c, Vendor_Order_Header__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c,
	        													Received__c from Vendor_Order_Line_Item__c WHERE Part__r.Vendor__c = '001o000000jQxXTAA0'];*/
	        
	        /*List<Service_Order_Line_Item__c> soliAssert1 = [select Qty_Needed__c, Qty_Committed__c, Qty_To_Order__c from Service_Order_Line_Item__c 
	        													where Service_Order_Header__r.CO_Header__c = 'a0Io000000aF1NUEA0'];	*/	
	        
	        /*List<Part__c> partList = [select Qty_In_Stock__c, Qty_Committed__c, Qty_On_Order__c from Part__c where Id = 'a0Ao000000h4u2NEAQ'];
	        
	        List<CO_Line_Item__c> coHeaderList = [select Qty__c, Qty_Committed__c from CO_Line_Item__c where CO_Header__c = 'a0Io000000aF3HXEA0'];																						
	        													
	        Database.rollback(sp);
	        system.assert(false, coHeaderList + '\n\n\n' + partList); */
	        
	        //system.assert(false, partListToUpdate);     
	        
	        
	         /* List<Vendor_Order_Line_Item__c> volis1 = [select Part__c, Is_Received__c, CO_Header__c, Vendor_Order_Line_Item_Group__c, Vendor_Order_Header__c, Is_Excess__c, Vendor_Order_Header__r.In_Progress_VR__c, CO_Line_Item__c, CO_Line_Item__r.Qty_Committed__c, Is_required_For_Customer__c, Qty_Needed__c, Received__c, Vendor_Receiving_Group__c, 
	        												Is_Service__c from Vendor_Order_Line_Item__c Where Vendor_Receiving_Group__r.Vendor_Receiving_Header__c =: vrHeaderId];
	        												
	      	 List<CO_Line_Item__c> coLineItems1 = [select Name, Qty_Committed__c, Special_Order__c, CO_Header__c, Qty__c, Part__c, Price__c, Tax__c, Service_Order_Line_Item__c
	        											from CO_Line_Item__c where   CO_Header__c= 'a0Io000000aG9siEAC'];
	        
			Database.rollback( sp );
			system.assert(false,volis1 +'\n\n'+ coLineItems1); */
			       
	        return BPUtility.getEncodedString(System.JSON.serialize(vrHeaderRec));
	    }catch(Exception e){
	    	Database.rollback( sp );
    		throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	return BPUtility.getEncodedString(null);
    }
    
    @RemoteAction
    global static String deleteVendorOrderRecieving(String vorId){
    	try{ 
    		vorId = BPUtility.getDecodedString(vorId);
    		vorId = BPUtility.escapeSingleQuotes(vorId);
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
    		List<Vendor_Receiving_Header__c> vorHeaderRecList = [Select Status__c, In_Progress_VI__c, (Select Id From Vendor_Receiving_Groups__r) From Vendor_Receiving_Header__c  where ID =: vorId  ];

    		if(((vorHeaderRecList[0].Status__c != 'Invoiced ') && (vorHeaderRecList[0].Status__c != 'Stocked '))&&((vorHeaderRecList[0].In_Progress_VI__c == null)&&(vorHeaderRecList[0].Vendor_Receiving_Groups__r.size() == 0))){
    			Vendor_Receiving_Header__c viRecieverHeader = new Vendor_Receiving_Header__c(Id = vorId);
    			if(AccessControl.ifObjectIsDeletable('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE);}
    			delete viRecieverHeader;
    		}else{
    			return BPUtility.getEncodedString('error');
    		}
    		
		}catch(Exception e){
			throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
    	}
    	
    	return BPUtility.getEncodedString('Success');
    }
    
	 /**
	 * Name: VendorOrderReceiving
	 * Description: Vendor Order Receiving Wrapper Class
	 **/
    // Wrapper class for Vendor Order Receiving attributes
    public class VendorOrderReceiving {
        // Vendor Order Receiving Header details
        public VORHeader VOR_Header;
        
        // Checkbox value if all vendor orders are selected
        public boolean isAllVOSelected;
        
        // Total number of vendor Orders found for selected vendor
        public Integer totalVendorOrders;
        
        // vendor orders list for selected vendor
        public List<VendorOrderHeader> vendorOrdersList;
        
        // List of selected Vendor Order Names list for current receiving record
        public Set<String> SelectedVendorOrdersList;
        
        // Total number of outstanding Items found for selected vendor
        public Integer totalOutstandingItems;
        
        // List of Outstanding Vendor Order Groups with respective Line Items list
        public List<VendorOrderLineItemGroup> outstandingVOGList;
        
        // Total number of group Items found for selected vendor
        public Integer totalGroupItems;
        
        // List of Vendor Receiving group
        public List<VORGroup> VORGroupList;
        
        // Total cost of Receiving items and groups
        public Decimal GroupTotalCost;
        
        // Invoicing History List
        public List<VIHistory> VIHistoryList;
        
        // Set to hold part ids
        private transient Set<Id> vendorAllPartIdsSet;
        
        // Is Found Record 
        public Boolean isFoundPartInOtherVOHeader = false;
        
        // List of Last Edited Vendor Receiving group
        public List<VORGroup> RecentlyEditedVORGroupList;
        
        /**
	     * Name: VendorOrderReceiving
	     * Desc: Constructor
	     * @param:  (1) vorId - String - Vendor Order Receiving Id
	     *			(2) gridName - String - Grid Name
	     *			(3) lastEditedPartId - Id - Edited Part Id Recently
	     *			(4) vendorOrdersPageSortAttrsJSON - PaginationSorting -Vendor Order Headers Grid Paging and sorting JSON
	     *			(5) groupItemsPageSortAttrsJSON - PaginationSorting - Items Grid Paging and sorting JSON
	     *			(6) outstandingVOGPageSortAttrsJSON - PaginationSorting - Outstanding Grid Paging and sorting JSON
	     * @return: 
	     **/
        public VendorOrderReceiving(Id vorId, String gridName, Id lastEditedPartId,
        							PaginationSorting vendorOrdersPageSortAttrs, 
        							PaginationSorting groupItemsPageSortAttrs,
        							PaginationSorting outstandingVOGPageSortAttrs
        						){
        	VOR_Header = VORHeader.getVORDetails(vorId);
        	GroupTotalCost = 0;
        	totalVendorOrders = 0;
        	isAllVOSelected = true;
        	vendorOrdersList = new List<VendorOrderHeader>();
        	SelectedVendorOrdersList = new Set<String>();
        	outstandingVOGList = new List<VendorOrderLineItemGroup>();
        	VORGroupList = new List<VORGroup>();
        	vendorAllPartIdsSet = new Set<Id>();
        	RecentlyEditedVORGroupList = new List<VORGroup>();
        	VIHistoryList = new List<VIHistory>();
        	
        	// populate vendor orders
        	if(VOR_Header != null && (gridName == null || gridName.toLowerCase() == 'vendororder')){
        		populateVendorOrderDetails(vorId, vendorOrdersPageSortAttrs);
        	}
        	
        	// populate outstanding vendor order groups list
        	if(VOR_Header != null && (gridName == null || gridName.toLowerCase() == 'outstanding')){
        		populateOutstandingItems(vorId, outstandingVOGPageSortAttrs);
        	}
        	
        	// populate outstanding vendor order groups list
        	if(VOR_Header != null && (gridName == null || gridName.toLowerCase() == 'groupitems')){
        		populateItemsSubsection(vorId, VOR_Header.VendorId, groupItemsPageSortAttrs);
        	}
        	
        	if(lastEditedPartId != null) {
        		for(VORGroup vorGroupObj : VORGroupList) {
        			if(vorGroupObj.PartId == lastEditedPartId) {
        				RecentlyEditedVORGroupList.add(vorGroupObj);
        			}
        		}
        	}
        	
        	for(VORGroup vrGroupObj : VORGroupList) {
        		this.GroupTotalCost += vrGroupObj.Total;
        	}
        	
        	populateVIHistoryList(vorId);
        }
        
        /**
	     * Name: populateVendorOrderDetails
	     * Desc: Method to populate only vendor Orders for vendor receiving
	     * @param:  (1) vorId - String - Vendor Order Receiving Id
	     *			(2) vendorOrdersPageSortAttrsJSON - PaginationSorting -Vendor Order Headers Grid Paging and sorting JSON
	     * @return: 
	    **/
        private void populateVendorOrderDetails(Id vorId, PaginationSorting vendorOrdersPageSortAttrs){
        	// If there is a vendor assigned to VRO record, then populate the lists
        	if(VOR_Header.VendorId != null){
        		Map<String, String> sortFieldMap = new Map<String, String>();
		    	if(vendorOrdersPageSortAttrs.sorting != null && vendorOrdersPageSortAttrs.sorting[0].sortDirection.length() != 0){
		    		sortFieldMap.put('Name', vendorOrdersPageSortAttrs.sorting[0].sortDirection);
		    		VO_Sort_Order = vendorOrdersPageSortAttrs.sorting[0].sortDirection;
		    	}
		    	
        		List<Vendor_Order_Header__c> voList = SOQLUtil.getVendorOrderHeaderRecords('Vendor__c', VOR_Header.VendorId, sortFieldMap, true);
        		totalVendorOrders = voList.size();
				
				Integer rowCount = 0;
				
        		for(Vendor_Order_Header__c vo : voList){
        			VendorOrderHeader voh = new VendorOrderHeader(vo);
        			voh.populateVendorOrderGroups(vo);
        			vendorOrdersList.add(voh);
        			voh.ExpectedDate = (datetime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day())).format('MM/dd/YYYY');
        			
        			// Set isAllVOSelected flag
        			//if(vo.In_Progress_VR__c == null || (vo.In_Progress_VR__c != null && vo.In_Progress_VR__c != vorId))
        			for(In_Progress_VR__c inProgressVRRec : vo.In_Progress_VRs__r) {
        				if(inProgressVRRec.Vendor_Receiving_Header__c != vorId) {
        					isAllVOSelected = false;
        					rowCount++;
        					break;
        				}
        			}
        			
        			if(vo.In_Progress_VRs__r == null || vo.In_Progress_VRs__r.size() == 0){
        				isAllVOSelected = false;
        			}
        			
        			// Populate partIdToVOHNameMap
        			for( VendorOrderLineItemGroup vog : voh.VOLIGroups){
        				vendorAllPartIdsSet.add(vog.PartId);
        			}
        		}
        		if(isAllVOSelected == false && rowCount == voList.size()){
        			isAllVOSelected = null;
        		}

        		// get paginated records
        		vendorOrdersList.sort();	// Sorting implication to move all those vendor orders in last which are already part of any other vendor receiving records
        		vendorOrdersList = VendorOrderHeader.getPaginatedRecords(vendorOrdersList, vendorOrdersPageSortAttrs.CurrentPage, vendorOrdersPageSortAttrs.PageSize);
        	}
        	//system.assert(false, vendorOrdersList);
        	for(VendorOrderHeader voh : vendorOrdersList){
        		if(voh.InProgressVR != null && voh.InProgressVRId == vorId){
        			SelectedVendorOrdersList.add(voh.VOName);
        		}
        	}
        }
        
        /**
	     * Name: populateOutstandingItems
	     * Desc: Method to add/remove slelected vendor order items for receiving
	     * @param:  (1) vorId - Selected vendor Receiving Id
	     *			(2) outstandingVOGPageSortAttrsJSON - PaginationSorting - Outstanding Grid Paging and sorting JSON
	     * @return: void
	    **/
	    private void populateOutstandingItems(String vorId, PaginationSorting outstandingVOGPageSortAttrs){
	    	if(VOR_Header.VendorId != null){
	    		if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    		if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
		    	List<In_Progress_VR__c> inProgressVRList = [select Vendor_Order_Header__c, Vendor_Receiving_Header__c 
		    													from In_Progress_VR__c where Vendor_Receiving_Header__r.Status__c = 'In Progress'];
		    	
		    	List<Id> selectedVOHeaderIdList = new List<Id>();
		    	
		    	Map<String, String> sortFieldMap = new Map<String, String>{'Items' => ''};
		        if(outstandingVOGPageSortAttrs.Sorting != null && outstandingVOGPageSortAttrs.Sorting[0].SortDirection.length() != 0){
		            sortFieldMap.put('Items', outstandingVOGPageSortAttrs.Sorting[0].SortDirection.toUpperCase());
		        }
		        VendorOrderLineItemWrapper.sortFieldMap = sortFieldMap;
		        
	    		for(In_Progress_VR__c inProgressVrRec : inProgressVRList){
	    			if(inProgressVrRec.Vendor_Receiving_Header__c ==  vorId ){
	    				selectedVOHeaderIdList.add(inProgressVrRec.Vendor_Order_Header__c);	
	    			}
	    			
	    		}
		    	List<Vendor_Order_Line_Item_Group__c> voLineItemGroupList = SOQLUtil.getVOLIGroupsWithItems('Vendor_Order_Header__r.Vendor__c', VOR_Header.VendorId, selectedVOHeaderIdList);
		    	Map<Id, List<Vendor_Order_Line_Item__c>> partIdToListOfVOLIRecMap = new Map<Id, List<Vendor_Order_Line_Item__c>>();
		    	Map<Id, Vendor_Order_Line_Item_Group__c> partIdToVOLIGroupRecMap = new Map<Id, Vendor_Order_Line_Item_Group__c>();
		    	
		    	for(Vendor_Order_Line_Item_Group__c voliGroup : voLineItemGroupList) {
		    		List<Vendor_Order_Line_Item__c> voliList = (partIdToListOfVOLIRecMap.containsKey(voliGroup.Part__c)) ? partIdToListOfVOLIRecMap.get(voliGroup.Part__c) : new List<Vendor_Order_Line_Item__c>();
		    		voliList.addAll(voliGroup.Vendor_Order_Line_Items__r);
		    		
		    		partIdToListOfVOLIRecMap.put(voliGroup.Part__c, voliList);
		    		partIdToVOLIGroupRecMap.put(voliGroup.Part__c, voliGroup);
		    	}
		    	
		    	for(Id partId : partIdToListOfVOLIRecMap.keyset()) {
		    		VendorOrderHeader vendorOrderHeader = new VendorOrderHeader(partIdToVOLIGroupRecMap.get(partId).Vendor_Order_Header__c);
		    		
		    		if(partIdToListOfVOLIRecMap.get(partId).size() > 0){
		    			outstandingVOGList.add(new VendorOrderLineItemGroup(partIdToListOfVOLIRecMap.get(partId), partIdToVOLIGroupRecMap.get(partId), vendorOrderHeader));
		    		}
		    	}
		    	
		    	totalOutstandingItems = outstandingVOGList.size();
		    	
		    	// Sort and paginate list
		    	outstandingVOGList.sort();
		    	outstandingVOGList = VendorOrderLineItemGroup.getPaginatedRecords(outstandingVOGList, outstandingVOGPageSortAttrs.CurrentPage, outstandingVOGPageSortAttrs.PageSize);
	    	}
	    }
	    
	    
	    /**
	     * Name: populateItemsSubsection
	     * Desc: populate items Sub Section
	     * @param:  (1) vorId - Selected vendor Receiving Id
	     *			(2)vendorId - Vendor Record Id
	     *			(3) groupItemsPageSortAttrsJSON - PaginationSorting - Items Grid Paging and sorting JSON
	     * @return: void 
	    **/
	    private void populateItemsSubsection(Id vorId, String vendorId, PaginationSorting groupItemsPageSortAttrs){
	    	Map<Id, List<String>> partIdToOtherVOHeaderNameListMap = getPartIdToUnreceivedVOHNamesMap(vorId, vendorAllPartIdsSet, vendorId);
	    	List<Vendor_Receiving_Group__c> vrGroupList = SOQLUtil.getVORGroupsWithItems('Vendor_Receiving_Header__c', vorId);
	    	for(Vendor_Receiving_Group__c vrgRec : vrGroupList) {
	    		VORGroupList.add(new VORGroup(vrgRec, partIdToOtherVOHeaderNameListMap));
	    	} 
	    	
	    	VendorOrderReceivingCtrl.sortingMap = new Map<String, String>();
	    	if(groupItemsPageSortAttrs.sorting != null && groupItemsPageSortAttrs.sorting[0].sortDirection.length() != 0){
	    		VendorOrderReceivingCtrl.sortingMap.put('Items', groupItemsPageSortAttrs.sorting[0].sortDirection);
	    		VO_Sort_Order = groupItemsPageSortAttrs.sorting[0].sortDirection;
	    	}
	    	
	    	totalGroupItems = VORGroupList.size();
	    	
	    	// Sort and paginate list
	    	VORGroupList.sort();
	    	VORGroupList = VORGroup.getPaginatedRecords(VORGroupList, groupItemsPageSortAttrs.CurrentPage, groupItemsPageSortAttrs.PageSize);
	    }
	    
	    
	    /**
	     * Name: getPartIdToUnreceivedVOHNamesMap
	     * Desc: Method used to populate a map of vendor related parts Ids used in all Vendor Orders to all unreceived VO names
	     * @param:  (1) vorId - Selected vendor Receiving Id
	     *			(2) partIdSet - Set Of Part Id
	     *			(3) vendorId - String - Vendor Id
	     * @return: Map<Id, List<String>>
	    **/
	    private Map<Id, List<String>> getPartIdToUnreceivedVOHNamesMap(String vorId, Set<Id> partIdSet, Id vendorId){
	    	List<Id> vohIdsToExclude = new List<Id>();
	    	vendorId = BPUtility.escapeSingleQuotes(vendorId);
	    	if(AccessControl.ifObjectIsAccessible('In_Progress_VR__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	for(In_Progress_VR__c ivr : [SELECT Vendor_Order_Header__c 
	    										FROM In_Progress_VR__c 
	    										WHERE Vendor_Order_Header__r.Vendor__c =: vendorId]){
				vohIdsToExclude.add(ivr.Vendor_Order_Header__c);
			}

	    	Map<Id, List<String>> partIdToVOHeaderNameListMap = new Map<Id, List<String>>();
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Order_Line_Item_Group__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	List<Vendor_Order_Line_Item_Group__c> voLineItemGroupList = [select Part__c, Vendor_Order_Header__r.Name from Vendor_Order_Line_Item_Group__c Where Part__c IN: partIdSet 
	    																							AND Vendor_Order_Header__c NOT IN: vohIdsToExclude 
	    																							AND Vendor_Order_Header__r.Vendor__c =: vendorId];
	    	List<String> voHeaderNameList;
	    	for(Vendor_Order_Line_Item_Group__c voliGroupRec : voLineItemGroupList) {
	    		if(partIdToVOHeaderNameListMap.containsKey(voliGroupRec.Part__c)) {
	    			voHeaderNameList = partIdToVOHeaderNameListMap.get(voliGroupRec.Part__c);
	    			voHeaderNameList.add(voliGroupRec.Vendor_Order_Header__r.Name);
	    		} else {
	    			voHeaderNameList = new List<String>();
	    			voHeaderNameList.add(voliGroupRec.Vendor_Order_Header__r.Name);
	    		}
	    		partIdToVOHeaderNameListMap.put(voliGroupRec.Part__c, voHeaderNameList);
	    	}
	    	return partIdToVOHeaderNameListMap;
	    }
	    
	    /**
	     * Name: populateVIHistoryList
	     * Desc: Method used to populate a map of vendor related parts Ids used in all Vendor Orders to all unreceived VO names
	     * @param:  (1) vorId - Selected vendor Receiving Id
	     * @return: Map<Id, List<String>>
	    **/
	    private void populateVIHistoryList(String vorId){
	    	vorId = BPUtility.escapeSingleQuotes(vorId);
	    	if(AccessControl.ifObjectIsAccessible('Vendor_Receiving_Header__c') == false ){throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE);}
	    	List<Vendor_Receiving_Header__c> vrHeaderList = [select In_Progress_VI__c from Vendor_Receiving_Header__c where Id =: vorId];
	    	if(vrHeaderList.size() > 0 && vrHeaderList[0].In_Progress_VI__c != null) {
	    		List<Vendor_Invoicing_Header__c> viHeaderList = SOQLUtil.getVIHeaderDetailsByFieldName(new Map<String, String>{'Id' => vrHeaderList[0].In_Progress_VI__c});
	    		for(Vendor_Invoicing_Header__c viHeaderRec : viHeaderList) {
	    			this.VIHistoryList.add(new VIHistory(viHeaderRec));
	    		}
	    	}
	    }
    }
    
     /**
	 * Name: VRGroupDetail
	 * Description: Wrapper class for Needed For Pop Up
	 **/
    public class VRGroupDetail {
        
        public Decimal RequriedForCustomer;
        public Decimal RequriedForStock;
        public Decimal TotalRequried;
        public Decimal OrderQty;
        public Decimal PackageQty;
        public String PackageUnit;
        public Decimal TotalExcess;
        
         /**
	     * Name: VRGroupDetail
	     * Desc: Constructor
	     * @param:  (1) vrgRec - Vendor Receiving Group Record
	     * @return:
	     **/
        public VRGroupDetail(Vendor_Receiving_Group__c vrgRec) {
        	this.RequriedForCustomer = 0;
        	this.RequriedForStock = 0;
        	this.PackageQty = 0;
        	this.TotalExcess = 0;
        	
        	for(Vendor_Order_Line_Item__c voliRec : vrgRec.Vendor_Order_Line_Items__r) {
        		if(voliRec.Is_required_For_Customer__c) {
        			this.RequriedForCustomer += voliRec.Qty_Needed__c;
        		} else if(!voliRec.Is_required_For_Customer__c && !voliRec.Is_Excess__c && !voliRec.Is_From_Search__c) {
        			this.RequriedForStock += voliRec.Qty_Needed__c;
        		} else if(voliRec.Is_Excess__c) {
        			this.TotalExcess += voliRec.Qty_Needed__c;
        		}
        	}
        	this.TotalRequried = this.RequriedForCustomer + this.RequriedForStock;
        	if(vrgRec.Part__r.Packaged_Part__c) {
        		this.PackageQty = (this.TotalRequried + this.TotalExcess) / vrgRec.Part__r.Package_Qty__c;
        		this.PackageUnit = vrgRec.Part__r.Package_Unit__c;
        	}
        	this.OrderQty = vrgRec.Part__r.Order_Lots__c;
        }
    }
    
	 /**
	 * Name: VIHistory
	 * Description: Wrapper class for Vendor Invoice History Section
	 **/
    public class VIHistory {
    	
    	public String InvoiceNumber;
    	public String InvoiceDate;
    	public String InvoicedByName;
    	public String InvoicedById;
    	public String VIHeaderId;
    	public Decimal TotalLineItems;
    	public Decimal TotalCost;
    	public String Status;
        
         /**
	     * Name: VIHistory
	     * Desc: Constructor
	     * @param:  (1) viHeaderRec -Vendor Invoice Header Record 
	     * @return:
	     **/
        public VIHistory(Vendor_Invoicing_Header__c viHeaderRec) {
        	
        	this.InvoiceNumber = viHeaderRec.Invoice_Number__c;
    		if(viHeaderRec.Invoice_Date__c != null) {
    			this.InvoiceDate = (datetime.newInstance(viHeaderRec.Invoice_Date__c.year(), viHeaderRec.Invoice_Date__c.month(), viHeaderRec.Invoice_Date__c.day())).format('MM/dd/YYYY');
    		}
    		this.InvoicedByName = viHeaderRec.Owner__r.Name;
    		this.InvoicedById = viHeaderRec.Owner__c;
    		this.VIHeaderId = viHeaderRec.Id;
    		
    		this.TotalLineItems = 0;
    		this.TotalCost = 0;
    		for(Vendor_Invoicing_Group__c viGroupRec : viHeaderRec.Vendor_Invoicing_Groups__r ) {
    			this.TotalLineItems += 1;
    			this.TotalCost += viGroupRec.VI_SubTotal__c;
    		}
    		this.TotalCost = this.TotalCost.setScale(2);
    		this.Status = viHeaderRec.Status__c;
        }
    }
}