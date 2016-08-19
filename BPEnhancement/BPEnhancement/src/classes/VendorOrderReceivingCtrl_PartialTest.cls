global with sharing class VendorOrderReceivingCtrl_PartialTest {
	
	
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
    @future
	global static void createExcessTestData(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 2, 8000,  BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
         
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, voliList);
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 144.00);
        system.assertEquals(partList[0].Qty_Committed__c, 144.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 16);
        
        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c limit 100];
        //system.assert(false, colineitem12);
        system.assertEquals(colineitem12[0].Qty_Committed__c, 144.00);
        system.assertEquals(colineitem12[1].Qty_Committed__c, 0);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        
        String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 1, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vor1Id)));
	}	
		@future
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
	global static void createExcessTestDataforStock(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 8, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 100.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 44);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        
        String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 2, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vor1Id)));
	}
	
			@future
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/  
	global static void createExcessTestDataforBothStockAndCustomer(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 8, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 110);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
       	String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), 
        													BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), 
        													BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        													BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        													BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 5, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vor1Id)));

	}
	
				@future
	/**
     * Name: BlackPurlHeaderCtrl
     * Desc: Constructor
    **/
	global static void createExcessTestDataforBothStockAndCustomerforMultipleCO(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 8, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     
       	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
        
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 250.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 198);

        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 9, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;  
		String commitLineItems1 =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vor1Id)));
	}
	
	    @future
	global static void createExcessTestDataMultiParts(Id vendorId, Id vorId, Id voHeaderId, Id partId, Id part2Id){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 2, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		VendorReceivingGroupTriggerHelper.isProcessed = false;
		String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[1].Id), 50, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
         
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, voliList);
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 144.00);
        system.assertEquals(partList[0].Qty_Committed__c, 144.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 16);
        
        system.assertEquals(partList[1].Qty_In_Stock__c, 100.00);
        system.assertEquals(partList[1].Qty_Committed__c, 100.00);
        system.assertEquals(partList[1].Qty_On_Order__c, 0);

        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
       	String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection2 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 1, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection3 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(part2Id), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[1].Id), 16, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
		
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		//String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id); 
	}
	
	@future
	global static void createExcessTestDataforVOGDetails(Id vendorId, Id vorId, Id voHeaderId, Id partId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems1);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 8, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
        
       	List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList[0].Qty_In_Stock__c, 276.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 110);


        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
       String vor1Id = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
       
       	String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(vor1Id), true));
        
        String allLineItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems11.VORGroupList[0].Id), 5, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
       	VendorReceivingGroupTriggerHelper.isProcessed = false;
        String removedItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.removeAllItemsFromItemSubSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItemsfordetails = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(removedItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
       	List<Vendor_Order_Line_Item_Group__c> volig = [select Need__c, Received_Qty__c, Part__c from Vendor_Order_Line_Item_Group__c limit 100];
        system.assertEquals(volig[0].Need__c, 286);
		system.assertEquals(volig[0].Received_Qty__c, 176);
		
		List<Vendor_Order_Line_Item__c> voliPartial = [select Qty_Needed__c, Received__c, Part__c from Vendor_Order_Line_Item__c limit 100];
		system.assertEquals(voliPartial[0].Qty_Needed__c, 126);
		system.assertEquals(voliPartial[0].Received__c, 126);
		system.assertEquals(voliPartial[1].Qty_Needed__c, 50);
		system.assertEquals(voliPartial[1].Received__c, 50);
		system.assertEquals(voliPartial[2].Qty_Needed__c, 16);
		system.assertEquals(voliPartial[2].Received__c, 0);
		system.assertEquals(voliPartial[3].Qty_Needed__c, 94);
		system.assertEquals(voliPartial[3].Received__c, 0);


        String allLineItems2 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems12 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems2, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
		VendorReceivingGroupTriggerHelper.isProcessed = false;
		String UpdatedItemsSubsection2 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor1Id), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems12.VORGroupList[0].Id), 5, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		
		String commitLineItems1 =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vor1Id)));
		
		List<Vendor_Order_Line_Item__c> voliPartial1 = [select Qty_Needed__c, Received__c, Part__c from Vendor_Order_Line_Item__c limit 100];
		system.assertEquals(voliPartial1[0].Qty_Needed__c, 126);
		system.assertEquals(voliPartial1[0].Received__c, 126);
		system.assertEquals(voliPartial1[1].Qty_Needed__c, 50);
		system.assertEquals(voliPartial1[1].Received__c, 50);
		system.assertEquals(voliPartial1[2].Qty_Needed__c, 16);
		system.assertEquals(voliPartial1[2].Received__c, 16);
		system.assertEquals(voliPartial1[3].Qty_Needed__c, 94);
		system.assertEquals(voliPartial1[3].Received__c, 94);
        
	}
	
	@future
	global static void createExcessTestDataA(Id vendorId, Id vorId, Id voHeaderId, Id partId, Id coHeaderId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeaderId), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems1.VORGroupList[0].Id), 200, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
	}
	
	/*@future
	global static void createExcessTestDataABCD(Id vendorId, Id vorId, Id voHeaderId, Id partId, Id coHeaderId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
     	
       	//system.assert(false, partList);
        //system.assertEquals(colineitem12[0].Qty_Committed__c, 150.00);
         
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, voliList);
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 300.00);
        system.assertEquals(partList[0].Qty_Committed__c, 300.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        
        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c limit 100];
        //system.assert(false, colineitem12);
        system.assertEquals(colineitem12[0].Qty_Committed__c, 300.00);
        system.assertEquals(colineitem12[0].Qty_Committed__c, 300);
        
        List<Service_Order_Line_Item__c> SOli1 = [select Id, Qty_Committed__c, Fixed_Price__c, Total__c from Service_Order_Line_Item__c limit 100];
        //system.assert(false, SOli1);
        system.assertEquals(SOli1[0].Qty_Committed__c, 300.00);
        system.assertEquals(SOli1[0].Total__c, 27500.00);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 200, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
		
		List<Vendor_Order_Header__c> voHeader13 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader13[0].Status__c, 'Received');
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 500.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 500.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
        List<CO_Line_Item__c> colineitem13 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c limit 100];
        //system.assert(false, colineitem12);
        system.assertEquals(colineitem13[0].Qty_Committed__c, 500.00);
        system.assertEquals(colineitem13[0].Qty_Committed__c, 500);
        
        String details = CustomerOrderCtrl.getCOHeaderDetails(coHeaderId);
   		COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
   		//system.assert(false, coHeaderDetails);
   		system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 27500.000);
   		
   		String savedCOInvoicePayment = CustomerOrderCtrl.saveCOInvoicePayment('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]');
   		//system.assert(false, savedCOInvoicePayment);
   		   
   		//String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[0].COInvoiceItemId+'","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeaderId, 'Customer');
   		String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction(System.JSON.serialize(coHeaderDetails.COInvoiceItemRecs), coHeaderId, 'Customer');
	}*/

	/*@future
	global static void createExcessTestDataTK(){
		Account vendor = TestUtil.createVendor(true, 'Test Vendor');
    	Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
    	Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10 , true, true);
    	Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Part__c part = TestUtil.createPart(false, 'TestPart', vendor.Id, 'TestPart', testCategory.Id, 10, 20, 50, 100, 100);
    	Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        insert part;
        
    	Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'Agra', '1111111112', null, null, false, true,'Individual','firstname1', 'lastname', '9999999999', 'BillingStreet');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        //Labour_Code__c labourCode = TestUtil.createLabourCode(true, true, testCategory.Id, 'Code', coHeader.Id, 'Description', True, 10, 'LabourCodeName', 10, true);
        Unit_Make__c unitmake = TestUtil.createUnitMake(true, 'unitMakeName', '12A', true);
 		Unit_Model__c unitmodel = TestUtil.createUnitModel(true, 'unitModelName', '12A', true, unitMake.Id);
        Customer_Owned_Unit__c customerOwnedUnit = TestUtil.createCustomerOwnedUnit(true, customer.Id, UnitMake.Id, UnitModel.Id, null);
        //Kit_Header__c kitHeader = TestUtil.createKitHeader(true, true, true, 'Cause', 'Code', 'Concern', 'Correction', 'Description', 10.0, true, true, unitMake.Id, unitModel.Id);
    	//Kit_Header_Line_Item__c kitHeaderLineItem = TestUtil.createKitHeaderLineItem(true, true, true, KitHeader.Id, 5.0, LabourCode.Id, Part.Id, 1, 5.0);	
    	
    	String soHeader = CustomerOrderCtrl.createSOHeader(coHeader.Id);
        String SOHeaderDetails = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, 'soHeader');
        SOHeaderWrapper soHeaderDetailsObj = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails, SOHeaderWrapper.class);
        
        String lineitems = CustomerOrderCtrl.addLineItems(part.Id, soHeaderDetailsObj.SOList[0].SOHeaderInfo.Id, coHeader.Id, customer.Id);
        
    	String SOHeaderDetails1 = CustomerOrderCtrl.getSOHeaderDetails(coHeader.Id, null);
        SOHeaderWrapper soHeaderDetailsObj1 = (SOHeaderWrapper) System.JSON.deserialize(SOHeaderDetails1, SOHeaderWrapper.class);
        soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0].QtyNeeded = 500.00 ;
		
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		
        String updatedSOLI = CustomerOrderCtrl.updateSOLineItems(System.JSON.serialize(soHeaderDetailsObj1.SOList[0].SOGridItems[0].SOKH.SOLIList[0]), coHeader.Id);

   		
   		
   		

   		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        
        String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendor.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));

        
       	Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendor.Id, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        
	

	 	String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);

		
		String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);

         
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList[0].Qty_In_Stock__c, 500.00);
        system.assertEquals(partList[0].Qty_Committed__c, 500.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        
        String details = CustomerOrderCtrl.getCOHeaderDetails(coHeader.Id);
   		COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
   		//system.assert(false, coHeaderDetails);
   		system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 27500.000);
   		
   		String savedCOInvoicePayment = CustomerOrderCtrl.saveCOInvoicePayment('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]');
   		//system.assert(false, savedCOInvoicePayment);
       
   		
   		
   		String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[0].COInvoiceItemId+'","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeader.Id, 'Customer');
   		
   		COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(closedInvoiceAction, COHeaderWrapper.class);
   		//system.assert(false, coHeaderDetails1);
   		system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 1);
   		system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 27500);
   		system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
   		system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);
   		
   		 List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 0.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 0.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
   		
   		
        
	}*/
	
	 @future
	global static void SamePartInMultipleSO_partialReceive(Id vendorId, Id partId, Id coHeaderId){

   		
   		//CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 200);
   		
   		//list<Service_Order_Header__c> solist = [select id, name__c from Service_Order_Header__c ];
   		//system.assert(false, solist );
   		//List<Vendor_Order_Line_Item__c> volis = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c];
       	//system.assert(false, volis);
   		
   		
   		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendorId, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendorId);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        
        //String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendorId, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        //VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
        /*List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);*/
        
       	Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
       String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems1 = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
	
		String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        //String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems.VORGroupList[0].Id, 200, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));

       	
        String commitLineItems =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
       	
       	
       	List<CO_Invoice_Item__c>  coinvoice = [select isActive__c, 	Is_Invoiceable__c, Qty__c,	SO_Payment_Role__c, Service_Order_Header__c, CO_Line_Item__c, CO_Kit_Header__c  from CO_Invoice_Item__c];
 		//system.assert(false, coinvoice);
        
        String details = BPUtility.getDecodedString(CustomerOrderCtrl.getCOHeaderDetailsByGridName(BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString(null)));
        COHeaderWrapper coHeaderDetails = (COHeaderWrapper) System.JSON.deserialize(details, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetails);
        
        
        
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[0].Total, 27500.000);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[1].Total, 11000.000);
        system.assertEquals(coHeaderDetails.COInvoiceItemRecs[2].Total, 16500.000);
        
                
        String savedCOInvoicePayment = BPUtility.getDecodedString(CustomerOrderCtrl.saveCOInvoicePayment(BPUtility.getEncodedString('[{"ReverseLink":null,"PaymentMethod":"Cash","Amount":"27500.000","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'"}]')));
        //system.assert(false, savedCOInvoicePayment);
       //String updatedCOInvoicePayment = CustomerOrderCtrl.updateCOInvoiceItem(true, '{"COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[1].COInvoiceItemId+'","COLineItemId":"'+coHeaderDetails.allcoLineItemRecs[0].CoLineItemId+'"}', 'b');
        /*for(COInvoiceItem coInvoiceItemObj : coHeaderDetails.COInvoiceItemRecs) {
        	CustomerOrderCtrl.updateCOInvoiceItem(System.JSON.Serialize(coInvoiceItemObj), coHeaderId );
        }*/
        
        String closedInvoiceAction = BPUtility.getDecodedString(CustomerOrderCtrl.closedInvoiceAction(BPUtility.getEncodedString(System.JSON.Serialize(coHeaderDetails.COInvoiceItemRecs)), BPUtility.getEncodedString(coHeaderId), BPUtility.getEncodedString('Customer')));
        //String closedInvoiceAction = CustomerOrderCtrl.closedInvoiceAction('[{"Total":27500.000,"TaxAmount":null,"Saving":null,"RetailPrice":null,"QtyRequired":null,"Qty":null,"Price":null,"Item":"Service Order 1","IsInvoiceable":true,"IsActive":true,"COLineItemId":null,"COInvoiceItemNumber":null,"COInvoiceItemId":"'+coHeaderDetails.coInvoiceItemRecs[0].COInvoiceItemId+'","COInvoiceHeaderId":"'+coHeaderDetails.coInvoiceHeaderRec.COInvoiceHeaderId+'","$$hashKey":"object:56"}]', coHeader.Id);
        
        COHeaderWrapper coHeaderDetails1 = (COHeaderWrapper) System.JSON.deserialize(closedInvoiceAction, COHeaderWrapper.class);
        //system.assert(false, coHeaderDetails1);
        /*system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].NumberOfItems, 2);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Total, 55000);
        system.assertEquals(coHeaderDetails1.COInvoiceHistoryRecs[0].Tax, 0);
        system.assertEquals(coHeaderDetails1.COInvoiceItemRecs.size(), 0);*/

   		
   		
        
	}
	
	/* @future
	global static void SamePartInMultipleSO_partialReceiveA(Id vendorId, Id partId, Id coHeaderId){

   		
   		//CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 200);
   		
   		//list<Service_Order_Header__c> solist = [select id, name__c from Service_Order_Header__c ];
   		//system.assert(false, solist );
   		//List<Vendor_Order_Line_Item__c> volis = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c];
       	//system.assert(false, volis);
   		
   		
   		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendorId, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendorId);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        
        //String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(vendorId, voHeader.Id, true,  System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(vendorId, partId, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        //VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(similarlineitem, VendorOrderLineItemWrapper.class);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendorId, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        //List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
       	Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        
	

	 	String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems.VORGroupList[0].Id, 200, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));

       	
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
       	
       List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];

        system.assertEquals(partList[0].Qty_On_Order__c, 100);
        
        List<Vendor_Order_Line_Item__c> volis = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, volis);
        system.assertequals(volis.size(), 5);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 800, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
		
		//List<CO_Line_Item__c> colis12 = [select Name, Qty__c, Qty_Committed__c, Service_Order_Line_Item__c from CO_Line_Item__c];
   		//system.assert(false, colis12);
	
   		//VendorOrderReceivingCtrl.isAssertShown = true;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id); 
		
		//List<Service_Order_Header__c> soh123 = [select Name, (select Id from CO_Invoice_Items__r) from Service_Order_Header__c];
   		//system.assert(false, soh123[0].CO_Invoice_Items__r + '\n\n\n\n' + soh123[1].CO_Invoice_Items__r);
		
		List<Vendor_Order_Line_Item__c> volis123 = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	system.assertequals(volis123.size(), 5);
       	
       	
		List<Vendor_Order_Header__c> voHeader13 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader13[0].Status__c, 'Received');
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 1100.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 1000.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        



   		
   		
        
	}*/
	
		@future
	global static void ScenarioForMecrhsection_partialReceive(Id vendorId, Id partId, Id coHeaderId){


   		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendorId, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendorId);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        
       	Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendorId), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        
	
		String allLineItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(null), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = BPUtility.getDecodedString(VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(partId), BPUtility.getEncodedString(voLineReceiveItems.VORGroupList[0].Id), 200, 8000, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
		
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
       	
        String commitLineItems =  BPUtility.getDecodedString(VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId)));
       	
       	/*List<Vendor_Order_Line_Item__c> volis1 = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	system.assert(false, volis1);*/
       	
       	
       	/*
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];

        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        List<Vendor_Order_Line_Item__c> volis = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, volis);
        
        system.assertequals(volis.size(), 3);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 500, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
		
   		
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id); 
		

		
		List<Vendor_Order_Line_Item__c> volis123 = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	system.assertequals(volis123.size(), 3);
       	
       	
		List<Vendor_Order_Header__c> voHeader13 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader13[0].Status__c, 'Received');
        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 800.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 800.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        */

   		
   		  
        
	}
	
	/*		@future
	global static void ScenarioForMecrhsection_partialReceiveA(Id vendorId, Id partId, Id coHeaderId){


   		PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendorId, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendorId);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
        
        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        
        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(vendorId, partId, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(voHeader.Id, vendorId, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
       	Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vorId = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vorId, true);
        
	

	 	String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems.VORGroupList[0].Id, 200, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
		
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;
       	
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
       	
       	/*List<Vendor_Order_Line_Item__c> volis1 = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	system.assert(false, volis1);*/
       	
       	
       	/*
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];

        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        List<Vendor_Order_Line_Item__c> volis = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, volis);
        
        system.assertequals(volis.size(), 4);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeader.Id, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 1000, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		ServiceOrderLineItemTriggerHelper.isTriggerExecuted = false;*/
		/*
   		
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id); 
		

		
		List<Vendor_Order_Line_Item__c> volis123 = [select Qty_Needed__c, Is_Service__c, Is_required_For_Customer__c, Received__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, CO_Line_Item__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, volis123);
       	system.assertequals(volis123.size(), 4);
       	
       	
		List<Vendor_Order_Header__c> voHeader13 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader13[0].Status__c, 'Received');
        

        
        List<Part__c> partList1 = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList1[0].Qty_In_Stock__c, 1300.00);
        system.assertEquals(partList1[0].Qty_Committed__c, 1300.00);
        system.assertEquals(partList1[0].Qty_On_Order__c, 0);
        
        List<CO_Invoice_Item__c> COII = [select Is_Invoiceable__c from CO_Invoice_Item__c  where CO_Kit_Header__c != null limit 100];
        system.assertEquals(COII[0].Is_Invoiceable__c, true);
        */

   		
   		
     /*   
	}*/
	
	 /*@future
	 
	global static void createExcessTestDataSpecialOrder(Id vendorId, Id vorId, Id voHeaderId, Id partId, Id coHeaderId){
		PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1; 
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vorId, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, partId, voLineReceiveItems1.VORGroupList[0].Id, 200, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(UpdatedItemsSubsection, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c limit 100];
        system.assertEquals(partList[0].Qty_In_Stock__c, 300.00);
        system.assertEquals(partList[0].Qty_Committed__c, 300.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        
         
       	List<Vendor_Order_Line_Item__c> voliList = [select Qty_Needed__c, Received__c, Status__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, Qty_Ordered__c, 	Is_Service__c, Is_Received__c from Vendor_Order_Line_Item__c limit 100];
       	//system.assert(false, voliList);
       	system.assertEquals(voliList[0].Received__c, 200.00);
       	system.assertEquals(voliList[1].Received__c, 0);
       	system.assertEquals(voliList[0].Is_Service__c, true);
       	system.assertEquals(voliList[1].Is_Service__c, true);
       	system.assertEquals(voliList[0].Is_Received__c, true);
       	system.assertEquals(voliList[1].Is_Received__c, false);
       	system.assertEquals(voliList[1].Qty_Needed__c, 200);

        List<CO_Line_Item__c> colineitem12 = [select Part__c, Qty_Committed__c, Qty__c, Status__c from CO_Line_Item__c limit 100];
        //system.assert(false, colineitem12);
        system.assertEquals(colineitem12[0].Qty_Committed__c, 300.00);
        system.assertEquals(colineitem12[0].Qty__c, 500);
        
        List<Service_Order_Line_Item__c> SOli1 = [select Id, Qty_Committed__c, Qty_Needed__c, Qty_To_Order__c,Fixed_Price__c, Total__c from Service_Order_Line_Item__c limit 100];
        //system.assert(false, SOli1);
        system.assertEquals(SOli1[0].Qty_Committed__c, 300.00);
        system.assertEquals(SOli1[0].Qty_Needed__c, 500.00);
        system.assertEquals(SOli1[0].Qty_To_Order__c, 200.00);
        system.assertEquals(SOli1[0].Total__c, 27500.00);
        
        List<Vendor_Order_Header__c> voHeader12 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader12[0].Status__c, 'Partially Received');
        
        Vendor_Receiving_Header__c vrh1 = TestUtil.createVendorOrderReceiveHeader(true, vendorId, 'In Progress');
        Id vor1Id = VendorOrderReceivingCtrl.addVendor(vendorId, null);
        String VendorOrderReceiveItems1 = VendorOrderReceivingCtrl.receiveVendorOrderItems(voHeaderId, vor1Id, true);
        
        String allLineItems1 = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(vor1Id, voHeaderId, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems11 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(allLineItems1, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        VendorReceivingGroupTriggerHelper.isProcessed = false;
        String UpdatedItemsSubsection1 = VendorOrderReceivingCtrl.updateItemsSection(vor1Id, partId, voLineReceiveItems11.VORGroupList[0].Id, 100, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
		COLineItemTriggerHelper.isTriggerExecute = false;
		COTriggerHelper.isTriggerExecute = false;
		String commitLineItems1 = VendorOrderReceivingCtrl.commitRecevingAction(vor1Id);
		
		List<Vendor_Order_Line_Item__c> voliList1 = [select Qty_Needed__c, Received__c, Status__c, Vendor_Order_Line_Item_Group__c, Vendor_Receiving_Group__c, Qty_Ordered__c, 	Is_Service__c, Is_Received__c from Vendor_Order_Line_Item__c limit 100];
       	system.assertEquals(voliList1.size(), 3);
       	system.assertEquals(voliList1[2].Qty_Needed__c, 100 );
       	system.assertEquals(voliList1[2].Received__c, 0 );
       	system.assertEquals(voliList1[2].Status__c, 'On Order' );
		
		List<Vendor_Order_Header__c> voHeader13 = [select Status__c, 	Vendor__c from Vendor_Order_Header__c limit 100];
        system.assertEquals(voHeader13[0].Status__c, 'Partially Received');
        
	}*/
}