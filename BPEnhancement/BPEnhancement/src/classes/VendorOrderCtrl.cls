/**
 * Author: Tarun Khandelwal
 * Since: July 22, 2015
 * Name: VendorOrderCtrl
 * Description: Apex class to handle all operations related to Vendor Order Page.
**/
global with sharing class VendorOrderCtrl {
    // Boolean variable indicates weather if the user is able to modify VOHeader details
    public boolean isPermittedToEditVOHeader { get {
                                                    if(AccessControl.ifObjectFieldIsAccessible('PermissionSetAssignment') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                                                    List<PermissionSetAssignment> voHeaderPermissionAssignments = [SELECT PermissionSet.Name, 
                                                                                                                          PermissionSetId, 
                                                                                                                          AssigneeId 
                                                                                                                          FROM PermissionSetAssignment 
                                                                                                                          WHERE PermissionSet.Name = 'Vendor_Order_Header_Updates'
                                                                                                                ];
                                                    if(voHeaderPermissionAssignments.size() != 0){
                                                        return true;
                                                    } else {
                                                        if(AccessControl.ifObjectFieldIsAccessible('Profile') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                                                        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
                                                        return UserInfo.getProfileId() == p.Id;
                                                    }
                                                } 
                                                private set; 
                                            }
    
    public Decimal Related_List_Page_Size { get{return GeneralConfiguration.getRelatedListPageSize();} private set;}
    
    /**
     * Name: groupAllSimilarVOLineItem
     * Desc: Method to merge all similar VO Line item and make one VO Line Item Group record to dispaly in Items subsection
     * @param:  (1) VendorId - String - Vendor Id
     *          (2) partId - String - Part Id
     *          (3) voHeaderId - String - voHeader Id
     *          (4) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (5) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (6)stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    @RemoteAction
    global static String groupAllSimilarVOLineItem(String vendorId, String partId, String voHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
        //system.assert(false,itemsPageSortAttrsJSON +''+ customersPageSortAttrsJSON  + ' ' + stocksPageSortAttrsJSON);
        try{
        	vendorId = BPUtility.getDecodedString(vendorId);
        	partId = BPUtility.getDecodedString(partId);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        	
            return groupAllSimilarVOLineItem(vendorId, partId, voHeaderId, itemsPageSortAttrsJSON, customersPageSortAttrsJSON, stocksPageSortAttrsJSON, null);
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
        
    /**
     * Name: groupAllSimilarVOLineItem
     * Desc: Method to merge all similar VO Line item and make one VO Line Item Group record to dispaly in Items subsection
     * @param:  (1) VendorId - String - Vendor Id
     *          (2) partId - String - Part Id
     *          (3) voHeaderId - String - voHeader Id
     *          (4) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (5) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (6)stocksPageSortAttrsJSON - String -  page sort attributes of stock
     *          (7)addNewLineItemId - String - Line item to be added
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    private static String groupAllSimilarVOLineItem(String vendorId, String partId, String voHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON, String addNewLineItemId){
        List<Vendor_Order_Line_Item__c> voLineItemsWithSimilarParts = SOQLUtil.getVOLineItemWithSimilarParts(vendorId, partId, voHeaderId);
        List<Vendor_Order_Line_Item_Group__c> voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Part__c', partId, voHeaderId);
        Vendor_Order_Line_Item_Group__c voliGroupRec = new Vendor_Order_Line_Item_Group__c();
        List<Part__c> partRecList = SOQLUtil.getPartDetailRecordsByFieldName('Id', partId);
        
        Decimal alreadyOrderedQty = 0;
        
        if(voliGroupList.size() > 0) {
            voliGroupRec.Id = voliGroupList[0].Id;
            for(Vendor_Order_Line_Item__c voli : voliGroupList[0].Vendor_Order_Line_Items__r) {
                if(!(voli.Is_required_For_Customer__c || voli.Is_Service__c)) {
                    alreadyOrderedQty += voli.Qty_Needed__c;
                } 
            }
        } else if(voLineItemsWithSimilarParts.size() > 0) {
            voliGroupRec.Part__c = partId;
            voliGroupRec.Vendor_Order_Header__c = voHeaderId;
        }
        
        
        
        Decimal needForVOLineItem = 0;
        Vendor_Order_Line_Item__c voLineItemForExcessStock;
        for(Vendor_Order_Line_Item__c voliRec : voLineItemsWithSimilarParts) {
            needForVOLineItem += voliRec.Qty_Needed__c;
            if(voliRec.Is_Excess__c) {
                voLineItemForExcessStock = voliRec;
            }
        }
        // Topping Up Need
        Decimal need = toppingUpNeed(partRecList, needForVOLineItem);
        
        voliGroupRec.Need__c = need;
        if(voliGroupRec != null) {
            if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            upsert voliGroupRec;
        }
        
        if(need > needForVOLineItem) {
            Decimal execessNeed = need - needForVOLineItem;
            if(voLineItemForExcessStock == null){
                voLineItemForExcessStock = new Vendor_Order_Line_Item__c();
            }
            voLineItemForExcessStock.Qty_Needed__c = execessNeed;
            voLineItemForExcessStock.Part__c = partId;
            voLineItemForExcessStock.Is_Excess__c = true;
            voLineItemForExcessStock.Vendor_Order_Header__c = voHeaderId;
            voLineItemForExcessStock.Vendor_Order_Line_Item_Group__c = voliGroupRec.Id;
        }
        
        for(Vendor_Order_Line_Item__c voliRec : voLineItemsWithSimilarParts) {
            voliRec.Vendor_Order_Header__c = voHeaderId;
            voliRec.Vendor_Order_Line_Item_Group__c = voliGroupRec.Id;
        }
        if(voLineItemForExcessStock != null && voLineItemForExcessStock.Id == null) {
            voLineItemsWithSimilarParts.add(voLineItemForExcessStock);
        }
        if(voLineItemsWithSimilarParts.size() > 0) {
            if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            upsert voLineItemsWithSimilarParts;
        } 
        
        
        updatePartOrderedQty(vendorId, voHeaderId, voliGroupRec.Id, alreadyOrderedQty);
        
        // Create JSON
        return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(addNewLineItemId), BPUtility.getEncodedString(null));
    }
    
    /**
     * Name: toppingUpNeed
     * Desc: Method to merge all similar VO Line item and make one VO Line Item Group record to dispaly in Items subsection
     * @param:  (1) partRecList - List<Part__c> - Part Record List
     *          (2) needForVOLineItem - Decimal - Line item count
     * @return: Decimal - Nedded 
    **/
    public static Decimal toppingUpNeed(List<Part__c> partRecList, Decimal needForVOLineItem) {
        try{
            Decimal need = needForVOLineItem;
            if(partRecList.size() > 0) {
                Part__c partRec = partRecList[0];
                if(partRec.Packaged_Part__c) {
                    Long packagedPartInNeed = (need / (partRec.Package_Qty__c * partRec.Order_Lots__c)).longValue();
                    if(packagedPartInNeed * (partRec.Package_Qty__c * partRec.Order_Lots__c) < need) {
                        packagedPartInNeed += 1;
                    }
                    need = packagedPartInNeed * partRec.Package_Qty__c * partRec.Order_Lots__c;
                } else if(partRec.Order_Lots__c > 1) {
                    Long orderLotPartInNeed = (needForVOLineItem / partRec.Order_Lots__c).longValue();
                    if(orderLotPartInNeed * partRec.Order_Lots__c < needForVOLineItem) {
                        orderLotPartInNeed += 1;
                    }
                    need = orderLotPartInNeed * partRec.Order_Lots__c;
                }
            }
            return need;
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return null;
    }
    
    /**
     * Name: getPaginatedItemsForVOHeader
     * Desc: Method to handle pagination
     * @param:  (1) gridName - String - Name of Grid
     *          (2) voHeaderId - String - voHeader Id
     *          (3) pageSortAttrsJSON - String - page sort attributes
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    @RemoteAction
    global static String getPaginatedItemsForVOHeader(String gridName, String voHeaderId, String pageSortAttrsJSON){
        try{
        	gridName = BPUtility.getDecodedString(gridName);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	pageSortAttrsJSON = BPUtility.getDecodedString(pageSortAttrsJSON);
        	
            PaginationSorting pageSortAttrs = parsePageAttrs(pageSortAttrsJSON);
            Map<String, String> sortFieldMap = new Map<String, String>{'Items' => '', 'Customers' => '', 'Stocks' => ''};
            if(pageSortAttrs.Sorting != null && pageSortAttrs.Sorting[0].SortDirection.length() != 0){
                sortFieldMap.put(gridName, pageSortAttrs.Sorting[0].SortDirection.toUpperCase());
            }
            
            VendorOrderHeader vendorOrderHeader = new VendorOrderHeader(voHeaderId);
            String vendorId = vendorOrderHeader.VendorId;
            List<Vendor_Order_Line_Item__c> voLineItemsRequiredForStock = new List<Vendor_Order_Line_Item__c>();
            List<Vendor_Order_Line_Item__c> voLineItemsRequiredForCustomer = new List<Vendor_Order_Line_Item__c>();
            List<Vendor_Order_Line_Item_Group__c> voliGroupList = new List<Vendor_Order_Line_Item_Group__c>();
            
            if(gridName == 'Items'){
                voliGroupList = (vendorId == null) ? new List<Vendor_Order_Line_Item_Group__c>() : SOQLUtil.getVOLIGroupsWithItemsInVO('Part__r.Vendor__c', vendorId, voHeaderId);
            }
            
            if(gridName == 'Customers'){
                voLineItemsRequiredForCustomer = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, true);
            }
            
            if(gridName == 'Stocks'){
                voliGroupList = (vendorId == null) ? new List<Vendor_Order_Line_Item_Group__c>() : SOQLUtil.getVOLIGroupByFieldName('Part__r.Vendor__c', vendorId, voHeaderId);
                voLineItemsRequiredForStock = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, false);
            }
            VendorOrderLineItemWrapper voLineItemWrapperObj = new VendorOrderLineItemWrapper(voLineItemsRequiredForStock, 
                                                                                             voLineItemsRequiredForCustomer, 
                                                                                             voliGroupList, 
                                                                                             pageSortAttrs,
                                                                                             pageSortAttrs,
                                                                                             pageSortAttrs,
                                                                                             sortFieldMap,
                                                                                             vendorOrderHeader,
                                                                                             null,
                                                                                             new List<PO_Type__c>(),
                                                                                             new List<Vendor_Order_Line_Item_Group__c>() 
                                                                                            );
            return BPUtility.getEncodedString(System.JSON.serialize(voLineItemWrapperObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    
      /**
     * Name: updateVOHederOrderType
     * Desc: Update VOHeader Order Type
     * @param:  (1) voHeaderId - String - voHeader Id
     *          (2) orderType - String - Type of Order
     *          (3) orderStatus - String - Order Status
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    @RemoteAction
    global static String updateVOHederOrderType(String voHeaderId, String orderType, String orderStatus) {
        try{
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	orderType = BPUtility.getDecodedString(orderType);
        	orderStatus = BPUtility.getDecodedString(orderStatus);
        	
            if(orderStatus == 'Locked'){
                lockVOLineItems(voHeaderId);
            }
            voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Vendor_Order_Header__c> voHeaderList = [select Id, Purchase_Order_Type__c, Status__c from Vendor_Order_Header__c where Id =:voHeaderId] ;
            if(voHeaderList.size() > 0) {
                voHeaderList[0].Purchase_Order_Type__c = orderType;
                voHeaderList[0].Status__c = orderStatus;
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update voHeaderList[0];
            }
            return BPUtility.getEncodedString(orderType);
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
     /**
     * Name: lockVOLineItems
     * Desc: Method to Lock VOLine Items
     * @param:  (1) voHeaderId - String - voHeader Id
     * @return: void
    **/
    private static void lockVOLineItems(String voHeaderId) {
        VendorOrderHeader vendorOrderHeader = new VendorOrderHeader(voHeaderId);
        Id vendorId = vendorOrderHeader.VendorId;
        voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
        if(AccessControl.ifObjectFieldIsAccessible('VO_Locked_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<VO_Locked_Line_Item__c> voLockedItemsList = [Select Id from VO_Locked_Line_Item__c where Vendor_Order_Header__c =: voHeaderId];
        if(voLockedItemsList.size() > 0){
            if(AccessControl.ifObjectIsDeletable('VO_Locked_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            delete voLockedItemsList;
        }
        
        List<Vendor_Order_Line_Item__c> voLineItemsList = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, null);
        voLockedItemsList = new List<VO_Locked_Line_Item__c>();
        
        for(Vendor_Order_Line_Item__c voLineItem : voLineItemsList){
            VO_Locked_Line_Item__c lockedVOLineItem = new VO_Locked_Line_Item__c(Vendor_Order_Header__c = voHeaderId, Locked_Line_Item_Id__c = voLineItem.Id);
            voLockedItemsList.add(lockedVOLineItem);
        }
        
        if(voLockedItemsList.size() > 0){
            if(AccessControl.ifObjectFieldIsCreateable('VO_Locked_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            insert voLockedItemsList;
        }
    }
    
    /**
     * Name: getVOLineItemWrapperJSON
     * Desc: Method which give JSOn string of all VO Line Items Records
     * @param:  (1) VendorId - String - Vendor Id
     *          (3) voHeaderId - String - voHeader Id
     *          (4) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (5) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (6)stocksPageSortAttrsJSON - String -  page sort attributes of stock
     *          (7)addNewLineItemId - String - line item id
     *          (8)editedPartTd - String - part id to be edit
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    @RemoteAction
    global static String getVOLineItemWrapperJSON(String vendorId, String voHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON, String addNewLineItemId, String editedPartTd){
        try{
        	vendorId = BPUtility.getDecodedString(vendorId);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        	addNewLineItemId = BPUtility.getDecodedString(addNewLineItemId);
        	editedPartTd = BPUtility.getDecodedString(editedPartTd);
        	
            PaginationSorting itemsPageSortAttrs = parsePageAttrs(itemsPageSortAttrsJSON);
            PaginationSorting customersPageSortAttrs = parsePageAttrs(customersPageSortAttrsJSON);
            PaginationSorting stocksPageSortAttrs = parsePageAttrs(stocksPageSortAttrsJSON);
            
            Map<String, String> sortFieldMap = new Map<String, String>{'Items' => '', 'Customers' => '', 'Stocks' => ''};
            if(itemsPageSortAttrs.Sorting != null && itemsPageSortAttrs.Sorting[0].SortDirection.length() != 0){
                sortFieldMap.put('Items', itemsPageSortAttrs.Sorting[0].SortDirection.toUpperCase());
            }
            if(customersPageSortAttrs.Sorting != null && customersPageSortAttrs.Sorting[0].SortDirection.length() != 0){
                sortFieldMap.put('Customers', customersPageSortAttrs.Sorting[0].SortDirection.toUpperCase());
            }
            if(stocksPageSortAttrs.Sorting != null && stocksPageSortAttrs.Sorting[0].SortDirection.length() != 0){
                sortFieldMap.put('Stocks', stocksPageSortAttrs.Sorting[0].SortDirection.toUpperCase());
            }
            
            VendorOrderHeader vendorOrderHeader = new VendorOrderHeader(voHeaderId);
            vendorId = vendorOrderHeader.VendorId;
            List<Vendor_Order_Line_Item__c> voLineItemsRequiredForStock = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, false);
            List<Vendor_Order_Line_Item__c> voLineItemsRequiredForCustomer = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, true);
            List<Vendor_Order_Line_Item_Group__c> voliGroupList = (vendorId == null) ? new List<Vendor_Order_Line_Item_Group__c>() : SOQLUtil.getVOLIGroupsWithItemsInVO('Part__r.Vendor__c', vendorId, voHeaderId);
            List<PO_Type__c> poTypesList = (vendorId == null) ? new List<PO_Type__c>() :SOQLUtil.getPOTypesForVendor(vendorId, new Map<String, String>());
            List<Vendor_Order_Line_Item_Group__c> recentlyEditedGroup = (editedPartTd == null) ? new List<Vendor_Order_Line_Item_Group__c>() : SOQLUtil.getVOLIGroupByFieldName('Part__c', editedPartTd, voHeaderId);
            
            /*Set<Id> vrHeaderIdSet = new Set<Id>();
            for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequiredForStock) {
                if(voliRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__c != null) {
                    vrHeaderIdSet.add(voliRec.Vendor_Receiving_Group__r.Vendor_Receiving_Header__c);
                }
            }
            
            List<Vendor_Receiving_Header__c> vrHeaderList = (vrHeaderIdSet.size() == 0) ? new List<Vendor_Receiving_Header__c>() : SOQLUtil.getReceivingHistoryByIdSet('Part__c', editedPartTd, voHeaderId);
            */
            
            VendorOrderLineItemWrapper voLineItemWrapperObj = new VendorOrderLineItemWrapper(voLineItemsRequiredForStock, 
                                                                                             voLineItemsRequiredForCustomer, 
                                                                                             voliGroupList, 
                                                                                             itemsPageSortAttrs,
                                                                                             customersPageSortAttrs,
                                                                                             stocksPageSortAttrs,
                                                                                             sortFieldMap,
                                                                                             vendorOrderHeader,
                                                                                             addNewLineItemId,
                                                                                             poTypesList,
                                                                                             recentlyEditedGroup
                                                                                            );
            return BPUtility.getEncodedString(System.JSON.serialize(voLineItemWrapperObj));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
        /**
     * Name: getVOLineItemWrapperJSON
     * Desc: Method to add Vender
     * @param:  (1) VendorId - String - Vendor Id
     *          (3) voHeaderId - String - voHeader Id
     *          (4) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (5) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (6)stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: String - JSON String of all VO Line Items of VO Header Record
    **/
    @RemoteAction
    global static String addVendor(String vendorId, String voHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
       try{
       		vendorId = BPUtility.getDecodedString(vendorId);
       		voHeaderId = BPUtility.getDecodedString(voHeaderId);
       		itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
       		customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
       		stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
       		
            Vendor_Order_Header__c voHeaderRec = new Vendor_Order_Header__c();
            if(String.isBlank(voHeaderId)) {
                voHeaderId = BPUtility.getDecodedString(BPGlobalHeaderCtrl.createVendorOrder());
            } 
            voHeaderRec.Id = voHeaderId;
            voHeaderRec.Vendor__c = vendorId;
            if(AccessControl.ifObjectFieldIsAccessible('PO_Type__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<PO_Type__c> vendorStandardPOTypes = [Select Id from PO_Type__c where IsDefault__c = true AND Vendor__c =: vendorId];
            if(vendorStandardPOTypes.size() > 0){
                voHeaderRec.Purchase_Order_Type__c = vendorStandardPOTypes[0].Id;
            }
            if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update voHeaderRec;
            return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null));
       }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    /**
     * Name: getPartByPartId
     * Desc: Method which give JSOn string of part Record related to given part Id.
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
        return BPUtility.getEncodedString('');
    }
    
    /**
     * Name: getGroupRecDetail
     * Desc: Method which give JSOn string of CO Header Rec Related to Given CO Header Id
     * @param:  (1)voGroupId - String - voGroup Id
     *          (2)voHeaderId - String - voHeader Id
     * @return: String - JSON String of VO Header Record
    **/
    @RemoteAction
    global static String getGroupRecDetail(String voGroupId, String voHeaderId){
        try{
        	voGroupId = BPUtility.getDecodedString(voGroupId);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	
            List<Vendor_Order_Line_Item_Group__c> vogList = SOQLUtil.getVOLIGroupByFieldName('Id', voGroupId, voHeaderId);
            List<VOGroupDetail> voGroupDetailList = new List<VOGroupDetail>();
            for(Vendor_Order_Line_Item_Group__c vogRec : vogList) {
                voGroupDetailList.add(new VOGroupDetail(vogRec));
            } 
            return BPUtility.getEncodedString(System.JSON.serialize(voGroupDetailList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
        
    }
    
    /**
     * Name: getStockRecDetail
     * Desc: Method which give JSOn string of stock record details
     * @param:  (1) voliId - String - voLine Item Id
     * @return: String - JSON String of CO Header Record
    **/
    @RemoteAction
    global static String getStockRecDetail(String voliId){
        try{
        	voliId = BPUtility.getDecodedString(voliId);
            List<Vendor_Order_Line_Item__c> voliList = SOQLUtil.getVOLineItemById(voliId);
            List<StockRecDetail> voliDetailList = new List<StockRecDetail>();
            for(Vendor_Order_Line_Item__c voliRec : voliList) {
                voliDetailList.add(new StockRecDetail(voliRec));
            } 
            return BPUtility.getEncodedString(System.JSON.serialize(voliDetailList));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    /**
     * Name: removeGroupFromOrder
     * Desc: Method which remove VO group from Items sectios
     * @param:  (1) voLineItemGroupId - String - VO Line Item Group Id which is to be removed
     *          (2) vendorId - String - Vendor Id
     *          (3) voHeaderId - String - VO Header record Id
     *          (4) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (5) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (6)stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: String - JSON String of VO Header Wrapper Record
    **/
    @RemoteAction
    global static String removeGroupFromOrder(String voLineItemGroupId, String vendorId, String voHeaderId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
        try{
        	voLineItemGroupId = BPUtility.getDecodedString(voLineItemGroupId);
        	vendorId = BPUtility.getDecodedString(vendorId);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        	voLineItemGroupId = BPUtility.escapeSingleQuotes(voLineItemGroupId);
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Vendor_Order_Line_Item_Group__c> voliGroupList = [select Id, (select Vendor_Order_Header__c, Is_From_Search__c, Is_Excess__c from Vendor_Order_Line_Items__r) from Vendor_Order_Line_Item_Group__c where Id = :voLineItemGroupId];
            List<Vendor_Order_Line_Item__c> voliListToUpdate = new List<Vendor_Order_Line_Item__c>();
            
            if(voliGroupList.size() > 0) {
                List<sObject> lineItemsToDel = new List<sObject>();
                for(Vendor_Order_Line_Item__c voliRec : voliGroupList[0].Vendor_Order_Line_Items__r) {
                    if(voliRec.Is_From_Search__c || voliRec.Is_Excess__c){
                        lineItemsToDel.add(voliRec);
                    } else {
                        voliRec.Vendor_Order_Header__c = null;
                        voliListToUpdate.add(voliRec);
                    }
                }
                if(voliListToUpdate.size() > 0) {
                    if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update voliListToUpdate;
                }
                
                updatePartOrderedQtyInCaseOfRemovingOfGroup(voLineItemGroupId, voHeaderId);
                
                if(lineItemsToDel.size() > 0) {
                    if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                    delete lineItemsToDel;
                }
                
                if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                delete voliGroupList[0];
            }
            
            return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    /**
     * Name: removeLineItemFromOrder
     * Desc: Method which remove VO group from Items sectios
     * @param:  (1) voLineItemId - String - VO line item Id 
     *          (2) voLineItemGroupId - String - VO Line Item Group Id which is to be removed
     *          (3) voHeaderId - String - VO Header record Id
     *          (4) vendorId - String - Vendor Id
     *          (5) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (6) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (7) stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: String - JSON String of VO Header Wrapper Record
    **/
    @RemoteAction
    global static String removeLineItemFromOrder(String voLineItemId, String voLineItemGroupId, String voHeaderId,  String vendorId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
    	voLineItemId = BPUtility.getDecodedString(voLineItemId);
    	voLineItemGroupId = BPUtility.getDecodedString(voLineItemGroupId);
    	voHeaderId = BPUtility.getDecodedString(voHeaderId);
    	vendorId = BPUtility.getDecodedString(vendorId);
    	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
    	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
    	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
    	
        Savepoint sp = Database.setSavepoint();
        voLineItemGroupId = BPUtility.escapeSingleQuotes(voLineItemGroupId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Line_Item_Group__c> voliGroups = [select Id, (select Qty_Needed__c, Is_Excess__c, Is_required_For_Customer__c, Is_Service__c from Vendor_Order_Line_Items__r) 
                                                                from Vendor_Order_Line_Item_Group__c where Id = :voLineItemGroupId];
        
        Decimal alreadyOrderedQty = 0;
        if(voliGroups.size() > 0) {
            for(Vendor_Order_Line_Item__c voliRec : voliGroups[0].Vendor_Order_Line_Items__r) {
                if(!(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c)) {
                    alreadyOrderedQty += voliRec.Qty_Needed__c;
                }
            }
        }
        voLineItemId = BPUtility.escapeSingleQuotes(voLineItemId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Line_Item__c> voliRecList = [select Id, Part__c, Is_Service__c, Qty_Needed__c, Is_From_Search__c, CO_Line_Item__c, CO_Line_Item__r.Status__c, CO_Line_Item__r.VO_Number__c, CO_Line_Item__r.VO_Status__c, CO_Line_Item__r.Expected_Delivery_Date__c, Is_Excess__c, Is_required_For_Customer__c, Vendor_Order_Line_Item_Group__c from Vendor_Order_Line_Item__c Where Id =:voLineItemId];
        List<Part__c> partRecList = new List<Part__c>();
        
        if(voliRecList.size() > 0) {
            List<sObject> lineItemsToDel = new List<sObject>();
            
            if(voliRecList[0].Is_From_Search__c){
                lineItemsToDel.add(voliRecList[0]);
            } else {
                voliRecList[0].Vendor_Order_Line_Item_Group__c = null;
                voliRecList[0].Vendor_Order_Header__c = null;
            }
            
            if(voliRecList[0].Is_required_For_Customer__c || voliRecList[0].Is_Service__c) {
                Id coliRecId = (voliRecList[0].CO_Line_Item__c != null) ? voliRecList[0].CO_Line_Item__c : null;
                if(coliRecId != null) {
                    CO_Line_Item__c coliRec = new CO_Line_Item__c();
                    coliRec.Id = coliRecId; 
                    coliRec.Status__c = 'Required';
                    coliRec.VO_Number__c = null;
                    coliRec.VO_Status__c = null;
                    coliRec.Expected_Delivery_Date__c = null;
                    coliRec.Id = voliRecList[0].CO_Line_Item__c;
                    if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update coliRec;
                }
            } else {
            
            }
            
            if(lineItemsToDel.size() > 0){
                if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                delete lineItemsToDel;
            } else if(voliRecList.size() > 0){
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update voliRecList;
            }
            partRecList = SOQLUtil.getPartDetailRecordsByFieldName('Id', voliRecList[0].Part__c);
        }
        
        Decimal previousExcessNeed = 0;
        // Calcalute Need and Excess Values Again
        List<Vendor_Order_Line_Item_Group__c> voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Id', voLineItemGroupId, voHeaderId);
        Decimal needForVOLineItem = 0;
        String excessRecId;
        if(voliGroupList.size() > 0) {
            if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
            if(voliGroupList[0].Vendor_Order_Line_Items__r.size() == 0 || (voliGroupList[0].Vendor_Order_Line_Items__r.size() == 1 && voliGroupList[0].Vendor_Order_Line_Items__r[0].Is_Excess__c)){
                List<sObject> sObjToDel = new List<sObject>();
                if(voliGroupList[0].Vendor_Order_Line_Items__r.size() > 0){
                    sObjToDel.addAll((List<sObject>)voliGroupList[0].Vendor_Order_Line_Items__r);
                }
                
                // Update Part Qty
                Decimal qtyToRemove = 0;
                
                for(Vendor_Order_Line_Item__c voliRec : voliGroupList[0].Vendor_Order_Line_Items__r) {
                    if(!(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c)) {
                        qtyToRemove += voliRec.Qty_Needed__c;
                    } 
                }
                if(!(voliRecList[0].Is_required_For_Customer__c || voliRecList[0].Is_Service__c)) {
                    qtyToRemove += voliRecList[0].Qty_Needed__c;
                }
                voLineItemGroupId = BPUtility.escapeSingleQuotes(voLineItemGroupId);
                if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<Vendor_Order_Line_Item_Group__c> voligList = [select Part__c, Part__r.Qty_On_Order__c from Vendor_Order_Line_Item_Group__c where Id = :voLineItemGroupId];
                if(voligList.size() > 0) {
                    Part__c partRec = new Part__c(Id = voligList[0].Part__c);
                    partRec.Qty_On_Order__c = voligList[0].Part__r.Qty_On_Order__c - qtyToRemove;
                    if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update partRec;
                } 
                
                sObjToDel.add(voliGroupList[0]);
                
                delete sObjToDel;
                
                return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null));
            }
            
            for(Vendor_Order_Line_Item__c voliRec : voliGroupList[0].Vendor_Order_Line_Items__r) {
                if(!voliRec.Is_Excess__c) {
                    needForVOLineItem += voliRec.Qty_Needed__c;
                } else {
                    excessRecId = voliRec.Id;
                    previousExcessNeed += voliRec.Qty_Needed__c;
                }
            }
        }
        
        
        //Topping Up In case of Packaged Part or Order Lots
        Decimal need = toppingUpNeed(partRecList, needForVOLineItem);
        
        if(voliGroupList != null) {
            voliGroupList[0].Need__c = need;
            if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            upsert voliGroupList;
        }
        voLineItemGroupId = BPUtility.escapeSingleQuotes(voLineItemGroupId);
        voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Line_Item__c> excessLineItemList = [select Id, Is_Excess__c, Is_Service__c from Vendor_Order_Line_Item__c 
                                                                    Where Vendor_Order_Line_Item_Group__c =:voLineItemGroupId 
                                                                        AND Vendor_Order_Header__c =: voHeaderId 
                                                                        AND Is_Excess__c = true];
        
        if(need - needForVOLineItem > 0) {
            Decimal excessNeed = need - needForVOLineItem;
            if(excessLineItemList.size() > 0) {
                excessLineItemList[0].Qty_Needed__c = excessNeed;
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update excessLineItemList;
            } else {
                Vendor_Order_Line_Item__c voLineItemForExcessStock = new Vendor_Order_Line_Item__c();
                voLineItemForExcessStock.Qty_Needed__c = excessNeed;
                voLineItemForExcessStock.Part__c = voliRecList[0].Part__c;
                voLineItemForExcessStock.Is_Excess__c = true;
                voLineItemForExcessStock.Vendor_Order_Header__c = voHeaderId;
                voLineItemForExcessStock.Vendor_Order_Line_Item_Group__c = voLineItemGroupId;
                if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                insert voLineItemForExcessStock;
            }
        } else {
            if(excessRecId != null) {
                Vendor_Order_Line_Item__c voLineItemForExcessStock = new Vendor_Order_Line_Item__c(Id = excessRecId);
                if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                delete voLineItemForExcessStock;
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        voLineItemGroupId = BPUtility.escapeSingleQuotes(voLineItemGroupId);
        List<Vendor_Order_Line_Item_Group__c> voligList = [select Part__c, Part__r.Qty_On_Order__c, (select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c from Vendor_Order_Line_Items__r) 
                                                                        from Vendor_Order_Line_Item_Group__c where Id = :voLineItemGroupId];
        
        if(voligList.size() > 0) {
            
            Decimal orderedQty = 0;
            for(Vendor_Order_Line_Item__c voliRecord : voligList[0].Vendor_Order_Line_Items__r) {
                if(!(voliRecord.Is_required_For_Customer__c || voliRecord.Is_Service__c)) {
                    orderedQty += voliRecord.Qty_Needed__c;
                }
            }
            
            Part__c partRec = new Part__c(Id = voligList[0].Part__c);
            partRec.Qty_On_Order__c = voligList[0].Part__r.Qty_On_Order__c - alreadyOrderedQty + orderedQty;
            if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
            update partRec;
            
            //Database.rollback(sp);
            //system.assert(false, partRec.Qty_On_Order__c);
        
        }
        
        //system.assert(false, voligList[0].Vendor_Order_Line_Items__r + ' ' + voligList[0].Part__r.Qty_On_Order__c + '   ' + alreadyOrderedQty);
        
        //updatePartOrderedQtyInCaseOfRemovingOfGroup(voLineItemGroupId, voHeaderId);
        
        return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(voliRecList[0].Part__c));
    }
    
    /**
     * Name: groupAllVOLineItem
     * Desc: Method which remove VO group from Items sectios
     * @param:  (1) vendorId - String - Vendor Id
     *          (2) voHeaderId - String - VO Header record Id
     *          (3) isRequiredForCustomer -  Boolean - is Required for Customer or not
     *          (5) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (6) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (7) stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: String - JSON String of VO Header Wrapper Record
    **/
    @RemoteAction
    global static String groupAllVOLineItem(String vendorId, String voHeaderId, Boolean isRequiredForCustomer, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON){
        try{
        	vendorId = BPUtility.getDecodedString(vendorId);
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
   
            Savepoint sp = Database.setSavepoint();
            List<Vendor_Order_Line_Item__c> voLineItemsRequired = (vendorId == null) ? new List<Vendor_Order_Line_Item__c>() : SOQLUtil.getVOLineItem(vendorId, voHeaderId, isRequiredForCustomer);
            
            Set<Id> partIdSet = new Set<Id>();
            Map<Id, List<Vendor_Order_Line_Item_Group__c>> partIdToVOLIGroupRecListMap = new Map<Id, List<Vendor_Order_Line_Item_Group__c>>();
            
            for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequired) {
                partIdSet.add(voliRec.Part__c);
            }
            
            if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            Map<Id, Part__c> partIdToPartRecMap = new Map<Id, Part__c>([select Id, Packaged_Part__c, Order_Lots__c, Last_Cost__c, Package_Qty__c from Part__c where Id IN : partIdSet]);
            List<Vendor_Order_Line_Item_Group__c> voliGroupList = (vendorId == null) ? new List<Vendor_Order_Line_Item_Group__c>() : SOQLUtil.getVOLIGroupByFieldName('Vendor_Order_Header__c', voHeaderId, voHeaderId);
            
            for(Vendor_Order_Line_Item_Group__c vogRec : voliGroupList) {
                List<Vendor_Order_Line_Item_Group__c> voliGroupRecList;
                if(partIdToVOLIGroupRecListMap.containsKey(vogRec.Part__c)) {
                    voliGroupRecList = partIdToVOLIGroupRecListMap.get(vogRec.Part__c);
                } else {
                    voliGroupRecList = new List<Vendor_Order_Line_Item_Group__c>();
                }
                voliGroupRecList.add(vogRec);
                partIdToVOLIGroupRecListMap.put(vogRec.Part__c, voliGroupRecList);
            }
            
            Set<Id> groupPartIdSet = new Set<Id>();
            List<Vendor_Order_Line_Item_Group__c> vogRecListToInsert = new List<Vendor_Order_Line_Item_Group__c>();
            for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequired) {
                Vendor_Order_Line_Item_Group__c vogRec;
                if(partIdToVOLIGroupRecListMap.containsKey(voliRec.Part__c)) {
                    vogRec = partIdToVOLIGroupRecListMap.get(voliRec.Part__c)[0];
                    groupPartIdSet.add(voliRec.Part__c);
                } else if(groupPartIdSet.contains(voliRec.Part__c)) {
                    
                } else {
                    vogRec = new Vendor_Order_Line_Item_Group__c();
                    vogRec.Part__c = voliRec.Part__c;
                    vogRec.Vendor_Order_Header__c = voHeaderId;
                    vogRec.Need__c = 0;
                    vogRecListToInsert.add(vogRec);
                    groupPartIdSet.add(voliRec.Part__c);
                }
            }
            
            if(vogRecListToInsert.size() > 0) {
                if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                insert vogRecListToInsert;
            }
            
            for(Vendor_Order_Line_Item_Group__c vogRec : vogRecListToInsert) {
                if(!partIdToVOLIGroupRecListMap.containsKey(vogRec.Part__c)) {
                    partIdToVOLIGroupRecListMap.put(vogRec.Part__c, new List<Vendor_Order_Line_Item_Group__c>{vogRec});
                }
            }
            
            for(Vendor_Order_Line_Item__c voliRec : voLineItemsRequired) {
                Vendor_Order_Line_Item_Group__c vogRec;
                if(partIdToVOLIGroupRecListMap.containsKey(voliRec.Part__c)) {
                    vogRec = partIdToVOLIGroupRecListMap.get(voliRec.Part__c)[0];
                    voliRec.Vendor_Order_Line_Item_Group__c = vogRec.Id;
                    voliRec.Vendor_Order_Header__c = voHeaderId;
                } 
            }
            
            if(voLineItemsRequired.size() > 0) {
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update voLineItemsRequired;
            }
            
            
            voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Vendor_Order_Header__c', voHeaderId, voHeaderId);
            
            List<Vendor_Order_Line_Item__c> voliListToUpsert = new List<Vendor_Order_Line_Item__c>();
            for(Vendor_Order_Line_Item_Group__c vogRec : voliGroupList) {
                if(partIdToPartRecMap.containsKey(vogRec.Part__c)) {
                    Decimal needForVOLineItem = 0;
                    Vendor_Order_Line_Item__c excessRec;
                    for(Vendor_Order_Line_Item__c voliRec : vogRec.Vendor_Order_Line_Items__r) {
                        if(voliRec.Is_Excess__c) {
                            excessRec = voliRec;
                        } else {
                            needForVOLineItem += voliRec.Qty_Needed__c;
                        }
                    }
                    
                    // Topping Up Need
                    Decimal need = toppingUpNeed(new List<Part__c>{partIdToPartRecMap.get(vogRec.Part__c)}, needForVOLineItem);
                    vogRec.Need__c = need;
                    
                    if(excessRec == null) {
                        excessRec = new Vendor_Order_Line_Item__c();
                        excessRec.Part__c = vogRec.Part__c;
                        excessRec.Is_Excess__c = true;
                        excessRec.Vendor_Order_Header__c = voHeaderId;
                        excessRec.Vendor_Order_Line_Item_Group__c = vogRec.Id;
                    } 
                    excessRec.Qty_Needed__c = need - needForVOLineItem;
                    if(excessRec.Qty_Needed__c != 0) {
                        voliListToUpsert.add(excessRec);    
                    }
                }
            }
            
            if(voliListToUpsert.size() > 0) {
                if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                upsert voliListToUpsert;
            }
            
            if(voliGroupList.size() > 0) {
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update voliGroupList;
            }
            
            // Populate VO number on COLIs + Update Part Ordered Qty.
            updatePartOrderedQty(vendorId, voHeaderId, null, 0);
            
            return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString('');
    }
    
    
    private static void updatePartOrderedQtyInCaseOfRemovingOfGroup(String vogId, String voHeaderId) {
        
        // Update All related CO Line Items Status - "ORDERED"
        List<Vendor_Order_Line_Item_Group__c> voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Id', vogId, voHeaderId);
        List<Id> coLineItemIdList = new List<Id>();
        Map<Id, Decimal> partIdToOrderedQtyMap = new Map<Id, Decimal>();
        
        for(Vendor_Order_Line_Item_Group__c voliGroupRec : voliGroupList) {
            Decimal qtyOrdered = 0;
            for(Vendor_Order_Line_Item__c voliRec : voliGroupRec.Vendor_Order_Line_Items__r) {
                if(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c) {
                    coLineItemIdList.add(voliRec.CO_Line_Item__c);
                } else {
                    qtyOrdered += voliRec.Qty_Needed__c;
                }
            }
            partIdToOrderedQtyMap.put(voliGroupRec.Part__c, qtyOrdered);
        }
        voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Header__c> voHeaderList = [select Id, Name, Status__c, Ordered_Date__c from Vendor_Order_Header__c where Id =:voHeaderId];
        
        if(coLineItemIdList.size() > 0) {
            if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<CO_Line_Item__c> coLineItemList = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c where Id IN : coLineItemIdList];
            for(CO_Line_Item__c coliRec : coLineItemList) {
                coliRec.Status__c = 'Required';
                coliRec.VO_Number__c = null;
                coliRec.VO_Status__c = null;
                coliRec.Expected_Delivery_Date__c = null;
            }
            //System.assert(false, coLineItemList);
            if(coLineItemList.size() > 0) {
                // To Stop COLineItemTrigger to execute
                COLineItemTriggerHelper.isTriggerExecute = true;
                if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update coLineItemList;
            }
        }
        
        // Update Parts Realted List - ON Order and QTY ON ORDER on Part Record
        if(partIdToOrderedQtyMap.size() > 0) {
            if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Part__c> partList = [select Qty_On_Order__c from Part__c where Id IN : partIdToOrderedQtyMap.keySet()];
            for(Part__c partRec : partList) {
                if(partRec.Qty_On_Order__c != null) {
                    partRec.Qty_On_Order__c = partRec.Qty_On_Order__c - partIdToOrderedQtyMap.get(partRec.Id);
                } else {
                    //partRec.Qty_On_Order__c = partIdToOrderedQtyMap.get(partRec.Id);
                }
            }
            if(partList.size() > 0) {
                if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update partList;
            }
        }
    }
    
    
    private static void updatePartOrderedQty(String vendorId, String voHeaderId, String voligRecId, Decimal alreadyOrderedQty) {
        
        // Update All related CO Line Items Status - "ORDERED"
        List<Vendor_Order_Line_Item_Group__c> voliGroupList;
        if(voligRecId == null) {
            voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Part__r.Vendor__c', vendorId, voHeaderId);
        } else {
            voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Id', voligRecId, voHeaderId);
        }
        List<Id> coLineItemIdList = new List<Id>();
        Map<Id, Decimal> partIdToOrderedQtyMap = new Map<Id, Decimal>();
        
        for(Vendor_Order_Line_Item_Group__c voliGroupRec : voliGroupList) {
            Decimal qtyOrdered = 0;
            for(Vendor_Order_Line_Item__c voliRec : voliGroupRec.Vendor_Order_Line_Items__r) {
                if(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c) {
                    coLineItemIdList.add(voliRec.CO_Line_Item__c);
                } else {
                    qtyOrdered += voliRec.Qty_Needed__c;
                }
            }
            partIdToOrderedQtyMap.put(voliGroupRec.Part__c, qtyOrdered - alreadyOrderedQty);
        }
        voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Header__c> voHeaderList = [select Id, Name, Status__c, Ordered_Date__c from Vendor_Order_Header__c where Id =:voHeaderId];
        
        if(coLineItemIdList.size() > 0) {
            if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<CO_Line_Item__c> coLineItemList = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c where Id IN : coLineItemIdList];
            for(CO_Line_Item__c coliRec : coLineItemList) {
                coliRec.Status__c = 'Ordered';
                coliRec.VO_Number__c = voHeaderList[0].Name;
                coliRec.VO_Status__c = 'On Order';
                coliRec.Expected_Delivery_Date__c = Date.Today();
            }
            //System.assert(false, coLineItemList);
            if(coLineItemList.size() > 0) {
                // To Stop COLineItemTrigger to execute
                COLineItemTriggerHelper.isTriggerExecute = true;
                if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update coLineItemList;
            }
        }
        
        // Update Parts Realted List - ON Order and QTY ON ORDER on Part Record
        if(partIdToOrderedQtyMap.size() > 0) {
            if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Part__c> partList = [select Qty_On_Order__c from Part__c where Id IN : partIdToOrderedQtyMap.keySet()];
            for(Part__c partRec : partList) {
                if(partRec.Qty_On_Order__c != null) {
                    partRec.Qty_On_Order__c = partRec.Qty_On_Order__c + partIdToOrderedQtyMap.get(partRec.Id);
                } else {
                    partRec.Qty_On_Order__c = partIdToOrderedQtyMap.get(partRec.Id);
                }
            }
            if(partList.size() > 0) {
                if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update partList;
            }
        }
        if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Part__c> partList2 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        //system.assertEquals(partList2[0].Qty_On_Order__c, 0 );
    }
    
    
    private static String insertSearchToAddLineItem(String partId, String vendorId, String voHeaderId) {
    	partId = BPUtility.escapeSingleQuotes(partId);
    	voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
        List<Vendor_Order_Line_Item_Group__c> voligList = [select Part__c, Part__r.Last_Cost__c, (select Id from Vendor_Order_Line_Items__r where Is_From_Search__c = true) 
                                                                from Vendor_Order_Line_Item_Group__c 
                                                                where Part__c =: partId AND Vendor_Order_Header__c =: voHeaderId];
        
        Vendor_Order_Line_Item_Group__c voligRec = new Vendor_Order_Line_Item_Group__c();
        if(voligList.size() == 0) {
            voligRec.Vendor_Order_Header__c = voHeaderId;
            voligRec.Part__c = partId;
            voligRec.Need__c = 0;
            //voligRec.Cost__c =  
            if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
            insert voligRec;
        } else {
            voligRec = voligList[0];
            if(voligRec.Vendor_Order_Line_Items__r.size() > 0) {
                return voligRec.Vendor_Order_Line_Items__r[0].Id;
            } 
        }                                                       
        
        Vendor_Order_Line_Item__c voliRec = new Vendor_Order_Line_Item__c();
        voliRec.Part__c = voligRec.Part__c;
        voliRec.Vendor_Order_Line_Item_Group__c = voligRec.Id;
        voliRec.Is_From_Search__c = true;
        voliRec.Qty_Needed__c = 0;
        voliRec.Vendor_Order_Header__c = voHeaderId;
        if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
        insert voliRec;
        
        return voliRec.Id;
    }
    
    /**
     * Name: addVOLineItemFromSearchToAdd
     * Desc: Method which add VO Line Item from Search to add text box.
     * @param:  (1)partId - String - Part Id
     *          (2) vendorId - String - Vendor Id
     *          (3) voHeaderId - String - VO Header record Id
     *          (4) qtyRequired- Decimal - Quantity Required 
     *          (5) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (6) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (7) stocksPageSortAttrsJSON - String -  page sort attributes of stock
     *          (8) newVOLIRecId - String - VO List Item Record Id
     *          (9) isFromSearchToAdd - Boolean - is From Search To add or not
     * @return: String - JSON String of VO Header Wrapper Record
    **/
    @RemoteAction
    global static String addVOLineItemFromSearchToAdd(String partId, String vendorId, String voHeaderId, Decimal qtyRequired, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON, String newVOLIRecId, Boolean isFromSearchToAdd){
    	
        partId = BPUtility.getDecodedString(partId);
        vendorId = BPUtility.getDecodedString(vendorId);
        voHeaderId = BPUtility.getDecodedString(voHeaderId);
        itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        newVOLIRecId = BPUtility.getDecodedString(newVOLIRecId);
        
        
        Boolean isVOLIsFoundInOutstandingGrid = false;
        
        Savepoint sp = Database.setSavepoint();
        
        if(isFromSearchToAdd) {
        	partId = BPUtility.escapeSingleQuotes(partId);
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Vendor_Order_Line_Item__c> voLineItemsWithSimilarParts = [select Part__c, Part__r.Last_Cost__c, Vendor_Order_Line_Item_Group__c from Vendor_Order_Line_Item__c
                                                                                where Part__c =: partId AND Vendor_Order_Line_Item_Group__c = null];
            
            
            /*List<Vendor_Order_Line_Item_Group__c> voligList = [select Part__c, Part__r.Last_Cost__c from Vendor_Order_Line_Item_Group__c 
                                                                where Part__c =: partId AND Vendor_Order_Header__c =: voHeaderId];*/
            
            //List<Vendor_Order_Line_Item__c> voLineItemsWithSimilarParts = SOQLUtil.getVOLineItemWithSimilarParts(vendorId, partId, voHeaderId);
            if(voLineItemsWithSimilarParts.size() > 0) {
                isVOLIsFoundInOutstandingGrid = true;
            } 
            
            if(isVOLIsFoundInOutstandingGrid) {
            	
                return groupAllSimilarVOLineItem(vendorId, partId, voHeaderId, itemsPageSortAttrsJSON, customersPageSortAttrsJSON, stocksPageSortAttrsJSON, null);
            } else {
            	
                String newLineItemId = insertSearchToAddLineItem(partId, vendorId, voHeaderId);
                return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(newLineItemId), BPUtility.getEncodedString(partId));
            }
        }  
        
        if(!isFromSearchToAdd) {
            List<Vendor_Order_Line_Item_Group__c> voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Part__c', partId, voHeaderId);
            List<Part__c> partRecList = SOQLUtil.getPartDetailRecordsByFieldName('Id', partId);
            Vendor_Order_Line_Item_Group__c voliGroupRec = new Vendor_Order_Line_Item_Group__c();
            
            if(voliGroupList.size() > 0) {
                voliGroupRec.Id = voliGroupList[0].Id;
                voliGroupRec.Part__c = voliGroupList[0].Part__c;
            } else {
                voliGroupRec.Part__c = partId;
                voliGroupRec.Vendor_Order_Header__c = voHeaderId;
            }
            
            Decimal needForVOLineItem = 0;
            Decimal excessQtyBefore = 0;
            Decimal alreadyOrderedQty = 0;
            String excessRecId;
            if(voliGroupList.size() > 0) {
                for(Vendor_Order_Line_Item__c voliRec : voliGroupList[0].Vendor_Order_Line_Items__r) {
                    if(voliRec.Is_Excess__c) {
                        excessRecId = voliRec.Id;
                        excessQtyBefore = voliRec.Qty_Needed__c;
                    } else if(voliRec.Id != newVOLIRecId){
                        needForVOLineItem += voliRec.Qty_Needed__c;
                    } 
                    
                    if(!(voliRec.Is_required_For_Customer__c || voliRec.Is_Service__c || voliRec.Is_Excess__c)) {
                        alreadyOrderedQty += voliRec.Qty_Needed__c; 
                    }
                }
            }
            
            needForVOLineItem += qtyRequired;
            // Topping Up Need
            Decimal need = toppingUpNeed(partRecList, needForVOLineItem);
            voliGroupRec.Need__c = need;
            if(voliGroupRec != null) {
                if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item_Group__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                upsert voliGroupRec;
            }
            
            List<Vendor_Order_Line_Item__c> voliListToInsert = new List<Vendor_Order_Line_Item__c>();
            Vendor_Order_Line_Item__c voLineItemForExcessStock;
            if(need > needForVOLineItem) {
                Decimal execessNeed = need - needForVOLineItem;
                voLineItemForExcessStock = new Vendor_Order_Line_Item__c();
                if(excessRecId != null) {
                    voLineItemForExcessStock.Id = excessRecId;
                } 
                voLineItemForExcessStock.Qty_Needed__c = execessNeed;
                voLineItemForExcessStock.Part__c = partId;
                voLineItemForExcessStock.Is_Excess__c = true;
                voLineItemForExcessStock.Vendor_Order_Header__c = voHeaderId;
                voLineItemForExcessStock.Vendor_Order_Line_Item_Group__c = voliGroupRec.Id;
                voliListToInsert.add(voLineItemForExcessStock);
            } else {
                if(excessRecId != null) {
                    voLineItemForExcessStock = new Vendor_Order_Line_Item__c(Id = excessRecId);
                    if(AccessControl.ifObjectIsDeletable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_DELETABLE); }
                    delete voLineItemForExcessStock;
                }
            }
            
            Vendor_Order_Line_Item__c voliRec = new Vendor_Order_Line_Item__c();
            voliRec.Qty_Needed__c = qtyRequired;
            voliRec.Part__c = partId;
            if(newVOLIRecId != null) {
                voliRec.Id = newVOLIRecId;
            }
            voliRec.Vendor_Order_Header__c = voHeaderId;
            voliRec.Is_Excess__c = false;
            voliRec.Vendor_Order_Line_Item_Group__c = voliGroupRec.Id;
            if(isFromSearchToAdd) {
                voliRec.Is_From_Search__c = true;
            }
            voliListToInsert.add(voliRec);
            
            if(voliListToInsert.size() > 0) {
                if(AccessControl.ifObjectFieldIsCreateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_CREATEABLE); }
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                upsert voliListToInsert;
            }
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Vendor_Order_Line_Item__c> voliRecList = [select Id from Vendor_Order_Line_Item__c Where Is_Excess__c = false AND Id IN : voliListToInsert];
            String addNewLineItemId = '';
            if(voliRecList.size() > 0) {
                addNewLineItemId = voliRecList[0].Id;
            } 
            
            
            // Update Part Qty
            List<Id> coLineItemIdList = new List<Id>();
            Map<Id, Decimal> partIdToOrderedQtyMap = new Map<Id, Decimal>();
            
            voliGroupList = SOQLUtil.getVOLIGroupByFieldName('Part__c', partId, voHeaderId);
            //voliRecList = [select Id, Is_Service__c, CO_Line_Item__c, Qty_Needed__c, Is_required_For_Customer__c from Vendor_Order_Line_Item__c Where Id =: newVOLIRecId OR Id IN: voliListToInsert];
            Decimal qtyOrdered = 0;
            if(voliGroupList.size() > 0) {
                for(Vendor_Order_Line_Item__c voliRecord : voliGroupList[0].Vendor_Order_Line_Items__r) {
                    if(voliRecord.Is_required_For_Customer__c || voliRecord.Is_Service__c) {
                        coLineItemIdList.add(voliRecord.CO_Line_Item__c);
                    } else {
                        qtyOrdered += voliRecord.Qty_Needed__c;
                    }
                }
                partIdToOrderedQtyMap.put(voliGroupList[0].Part__c, qtyOrdered);
            }
            voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            List<Vendor_Order_Header__c> voHeaderList = [select Id, Name, Status__c, Ordered_Date__c from Vendor_Order_Header__c where Id =:voHeaderId];
            if(coLineItemIdList.size() > 0) {
                if(AccessControl.ifObjectFieldIsAccessible('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<CO_Line_Item__c> coLineItemList = [select Status__c, VO_Number__c, VO_Status__c, Expected_Delivery_Date__c from CO_Line_Item__c where Id IN : coLineItemIdList];
                for(CO_Line_Item__c coliRec : coLineItemList) {
                    coliRec.Status__c = 'Ordered';
                    coliRec.VO_Number__c = voHeaderList[0].Name;
                    coliRec.VO_Status__c = 'On Order';
                    coliRec.Expected_Delivery_Date__c = Date.Today();
                }
                //System.assert(false, coLineItemList);
                if(coLineItemList.size() > 0) {
                    // To Stop COLineItemTrigger to execute
                    COLineItemTriggerHelper.isTriggerExecute = true;
                    if(AccessControl.ifObjectFieldIsUpdateable('CO_Line_Item__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update coLineItemList;
                }
            }
            
            // Update Parts Realted List - ON Order and QTY ON ORDER on Part Record
            if(partIdToOrderedQtyMap.size() > 0) {
                if(AccessControl.ifObjectFieldIsAccessible('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
                List<Part__c> partList = [select Qty_On_Order__c from Part__c where Id IN : partIdToOrderedQtyMap.keySet()];
                for(Part__c partRec : partList) {
                    if(partRec.Qty_On_Order__c != null) {
                        partRec.Qty_On_Order__c = partRec.Qty_On_Order__c + partIdToOrderedQtyMap.get(partRec.Id) - alreadyOrderedQty - excessQtyBefore;
                    } else {
                        partRec.Qty_On_Order__c = partIdToOrderedQtyMap.get(partRec.Id) - alreadyOrderedQty - excessQtyBefore;
                    }
                }
                
                if(partList.size() > 0) {
                    if(AccessControl.ifObjectFieldIsUpdateable('Part__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                    update partList;
                }
                //Database.rollback(sp);
                //system.assert(false, partList);
            }
            return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(addNewLineItemId), BPUtility.getEncodedString(partId));
        }
        return BPUtility.getEncodedString(null);
    }
    
    /**
     * Name: finalizeVendorOrder
     * Desc: Method to do operation realted to finalize vendor Order
     * @param:  (1) voHeaderId - String - vo Header Id
     *          (2) vendorId - String Vendor id
     *          (3) itemsPageSortAttrsJSON - String - page sort attributes of item
     *          (3) customersPageSortAttrsJSON - Sting - page sort attributes of customer
     *          (5) stocksPageSortAttrsJSON - String -  page sort attributes of stock
     * @return: PaginationSorting - Class Object
    **/
    @RemoteAction
    global static String finalizeVendorOrder(String voHeaderId, String vendorId, String itemsPageSortAttrsJSON, String customersPageSortAttrsJSON, String stocksPageSortAttrsJSON) {
        try{
        	voHeaderId = BPUtility.getDecodedString(voHeaderId);
        	vendorId = BPUtility.getDecodedString(vendorId);
        	itemsPageSortAttrsJSON = BPUtility.getDecodedString(itemsPageSortAttrsJSON);
        	customersPageSortAttrsJSON = BPUtility.getDecodedString(customersPageSortAttrsJSON);
        	stocksPageSortAttrsJSON = BPUtility.getDecodedString(stocksPageSortAttrsJSON);
        	
            Savepoint sp = Database.setSavepoint();
            if(AccessControl.ifObjectFieldIsAccessible('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_ACCESSIBLE); }
            voHeaderId = BPUtility.escapeSingleQuotes(voHeaderId);
            List<Vendor_Order_Header__c> voHeaderList = [select Id, Name, Status__c, Ordered_Date__c from Vendor_Order_Header__c where Id =:voHeaderId];
            if(voHeaderList.size() > 0) {
                voHeaderList[0].Status__c = 'On Order';
                voHeaderList[0].Ordered_Date__c = Date.Today();
                if(AccessControl.ifObjectFieldIsUpdateable('Vendor_Order_Header__c') == false) { throw new BlackPurlException(Constants.OBJIECT_NOT_UPDATEABLE); }
                update voHeaderList[0];
            }
            
            //Database.rollback(sp);
            return getVOLineItemWrapperJSON(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(itemsPageSortAttrsJSON), BPUtility.getEncodedString(customersPageSortAttrsJSON), BPUtility.getEncodedString(stocksPageSortAttrsJSON), BPUtility.getEncodedString(null), BPUtility.getEncodedString(null));
        }catch(Exception e){
            throw new BlackPurlException(BlackPurlException.getErrorMessage(e.getMessage(), e.getStackTraceString()));
        }
        return BPUtility.getEncodedString(''); 
    }
    
    /**
     * Name: parsePageAttrs
     * Desc: Method to Parse JSON String to class instance for Pagination and sort attributes
     * @param:  (1) JSONString - String - JSON String 
     * @return: PaginationSorting - Class Object
    **/
    public static PaginationSorting parsePageAttrs(String json) {
        return (PaginationSorting) System.JSON.deserialize(json, PaginationSorting.class);
    }
    
    /**
     * Name: PaginationSorting
     * Description:  Wrapper class for pagination and sorting combination
     **/
    public class PaginationSorting {
        
        // Current page number
        public Integer CurrentPage;
        
        // Current page size
        public Integer PageSize;
        
        // Sorting list
        public List<SortAttrs> Sorting;
    }
    
    // SortAttrs for sorting attributes
    public class SortAttrs {
        // Field name
        public String FieldName;
        
        // Sort direction
        public String SortDirection;
    }
    
    /**
     * Name: VOGroupDetail
     * Description: Wrapper class for Needed For Pop Up
     **/
    public class VOGroupDetail {
        
        public Decimal RequriedForCustomer;
        public Decimal RequriedForStock;
        public Decimal TotalRequried;
        public Decimal OrderQty;
        public Decimal PackageQty;
        public String PackageUnit;
        public Decimal TotalExcess;
        
        /**
         * Name: VOGroupDetail
         * Desc: Constructor 
         * @param:  (1) vogRec - Vendor_Order_Line_Item_Group__c -Vendor Order Line Item Group Record
         * @return: 
         **/
        public VOGroupDetail(Vendor_Order_Line_Item_Group__c vogRec) {
            this.RequriedForCustomer = 0;
            this.RequriedForStock = 0;
            this.PackageQty = 0;
            this.TotalExcess = 0;
            
            for(Vendor_Order_Line_Item__c voliRec : vogRec.Vendor_Order_Line_Items__r) {
                if(voliRec.Is_required_For_Customer__c) {
                    this.RequriedForCustomer += voliRec.Qty_Needed__c;
                } else if(!voliRec.Is_required_For_Customer__c && !voliRec.Is_Excess__c && !voliRec.Is_From_Search__c) {
                    this.RequriedForStock += voliRec.Qty_Needed__c;
                } else if(voliRec.Is_Excess__c) {
                    this.TotalExcess += voliRec.Qty_Needed__c;
                }
            }
            this.TotalRequried = this.RequriedForCustomer + this.RequriedForStock;
            if(vogRec.Part__r.Packaged_Part__c) {
                this.PackageQty = vogRec.Need__c / vogRec.Part__r.Package_Qty__c;
                this.PackageUnit = vogRec.Part__r.Package_Unit__c;
            }
            this.OrderQty = vogRec.Need__c;
        }
    }
    
     /**
     * Name: StockRecDetail
     * Description: Wrapper class for Needed For Pop Up
     **/
    public class StockRecDetail {
        
        public Decimal QtyAvailable;
        public Decimal Incoming;
        public Decimal NetAvailable;
        public Decimal AutoReprderAt;
        public Decimal AutoReprderTo;
        public String PackageUnit;
        public Decimal PackageQty;
        public Decimal TotalNeed;
        
         /**
         * Name: StockRecDetail
         * Desc: Constructor 
         * @param:  (1) voliRec - Vendor_Order_Line_Item__c -Vendor Order Line Item Record
         * @return: 
         **/
        public StockRecDetail(Vendor_Order_Line_Item__c voliRec) {
            this.QtyAvailable = 0;
            this.Incoming = 0;
            
            this.QtyAvailable = voliRec.Part__r.AvailableParts__c;
            this.NetAvailable = this.QtyAvailable + this.Incoming;
            this.AutoReprderAt = voliRec.Part__r.Auto_reorder_Min__c;
            this.AutoReprderTo = voliRec.Part__r.Auto_reorder_Max__c;
            if(voliRec.Part__r.Packaged_Part__c) {
                this.PackageQty = voliRec.Qty_Needed__c / voliRec.Part__r.Package_Qty__c;
                this.PackageUnit = voliRec.Part__r.Package_Unit__c;
            }
            this.TotalNeed = voliRec.Qty_Needed__c;
        }
    }
    
}