/**
 * Author: Ashish Garg
 * Since: Sept. 24, 2014
 * Name: BlackPurlHeaderCtrl
 * Description: Conroller class for BlackPurlHeader page (Used in Kendo).
**/
global with sharing class BlackPurlHeaderCtrl {
	// Variables related to page parameters:
	public String pageParameterName {public get{return Constants.pageParameterName;} private set;}
	public String settingsPageParameterName {public get{return Constants.settingsPageParameterName;} private set;}
	public String customerMgmtPageParameterName {public get{return Constants.customerMgmtPageParameterName;} private set;}
	public String partsMgmtPageParameterName {public get{return Constants.partsMgmtPageParameterName;} private set;}
	public String categoryMgmtPageParameterName {public get{return Constants.categoryMgmtPageParameterName;} private set;}
	public String vendorMgmtPageParameterName {public get{return Constants.vendorMgmtPageParameterName;} private set;}
	public String makeMgmtPageParameterName {public get{return Constants.makeMgmtPageParameterName;} private set;}
	
	
	
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
    /*@future
	global static void createExcessTestData(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 2, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
        List<Vendor_Order_Header__c> vohList = [select Status__c from Vendor_Order_Header__c];
       	system.assert(false, vohList);
       	
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
         
        system.assertEquals(partList[0].Qty_In_Stock__c, 144.00);
        system.assertEquals(partList[0].Qty_Committed__c, 144.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 16);
        
        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c];
        //system.assert(false, colineitem12);
        system.assertEquals(colineitem12[0].Qty_Committed__c, 144.00);
        system.assertEquals(colineitem12[1].Qty_Committed__c, 0);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 1, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
		
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
		
		List<Vendor_Order_Line_Item_Group__c> vogList = [select Need__c, Received_Qty__c from Vendor_Order_Line_Item_Group__c];
       	//system.assert(false, vogList);
       	
		List<Vendor_Order_Line_Item__c> oldVolis = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c];
        system.assert(false, oldVolis);
	}*/
	
		//@future
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
	/*global static void createExcessTestDataforStock(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 8, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 100.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 44);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 2, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
	}
	
			@future*/
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
	/*global static void createExcessTestDataforBothStockAndCustomer(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 8, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 110);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
	}
	
				@future*/
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
	/*global static void createExcessTestDataforBothStockAndCustomerforMultipleCO(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 8, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 250.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 198);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 9, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
	}*/
	
	/*global static void createExcessTestDataforVOGDetails(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 8, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 110);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        String removedItems = VendorOrderReceivingCtrl.removeAllItemsFromItemSubSection(vor1Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItemsfordetails = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(removedItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
       	List<Vendor_Order_Line_Item_Group__c> volig = [select Need__c, Received_Qty__c, Part__c from Vendor_Order_Line_Item_Group__c];
        system.assert(false, volig);

        
        String allLineItems2 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems12 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems2, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
		VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection2 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
	}
	
	@future
	global static void createExcessTestDataforVOGDetails12(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 8, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
       	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 110);

		

        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
		
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
       	VendorReceivingGroupTriggerHelper.isProcessed = false;
        String removedItems = VendorOrderReceivingCtrl.removeAllItemsFromItemSubSection(vor1Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItemsfordetails = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(removedItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
		
		allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));		
		
		List<Vendor_Order_Line_Item__c> voliPartial = [select Qty_Needed__c, Received__c, Part__c from Vendor_Order_Line_Item__c];
		system.assert(false, voliPartial);
		
		
       	List<Vendor_Order_Line_Item_Group__c> volig = [select Need__c, Received_Qty__c, Part__c from Vendor_Order_Line_Item_Group__c];
        system.assertEquals(volig[0].Need__c, 286);
		system.assertEquals(volig[0].Received_Qty__c, 176);
		
        
        String allLineItems2 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems12 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems2, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
		VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection2 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
	}*/
}