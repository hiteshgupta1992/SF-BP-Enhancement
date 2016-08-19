/**
 * Author: Durga Singh
 * Since: August 26, 2015
 * Name: VendorOrderReceivingCtrlTest
 * Description: test Class for complete vendorOrderReceive functionality .
 **/
 @ isTest
private class VendorOrderReceivingCtrlTest {
    
	/**
     * Name: receiveVendorOrderItemsTest 
     * Desc: test to check vendor orders are on vendorOrderReceive page according to selected vendor.
     * @param: 
     * @return: 
    **/
	static testMethod void receiveVendorOrderItemsTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
		CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), 
        								BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        								BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        								BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), 
        									BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        									BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        									BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
		String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
		String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), 
													BPUtility.getEncodedString(vorId), true));
        
        system.assertEquals(VendorOrderReceiveItems, 'true');
    }

/**
     * Name: addToItemSubsectionTest 
     * Desc: test to check vendor orders are added in item subsection.
     * @param: 
     * @return: 
    **/
static testMethod void addToItemSubsectionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), 
        							BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        							BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        							BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), 
        								BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        								BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        								BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));
        String addItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id), BPUtility.getEncodedString(part.Id), 
        											BPUtility.getEncodedString(vendor.Id), false, BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(addItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups[0].Need, 176);
    }

/**
     * Name: addToItemSubsectionAfterConfirmationTest 
     * Desc: test to check vendor orders are added in item subsection with stock excess true.
     * @param: 
     * @return: 
    **/
static testMethod void addToItemSubsectionAfterConfirmationTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = BPUtility.getDecodedString(VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(part.Id), 
        										BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        										BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        										BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String finalizedLineItems = BPUtility.getDecodedString(VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vendor.Id), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        String vorId = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(null)));
        String VendorOrderReceiveItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true));

        String addItems = BPUtility.getDecodedString(VendorOrderReceivingCtrl.addToItemSubsectionAfterConfimation(BPUtility.getEncodedString(vor.id), BPUtility.getEncodedString(part.Id), true, 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort)), 
        											BPUtility.getEncodedString(System.JSON.serialize(pageSort))));
        											
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(addItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups[0].Need, 176);
    }

/**
     * Name: addToItemSubsectionAfterConfimationTestA 
     * Desc: test to check vendor orders are added in item subsection with stock excess false.
     * @param: 
     * @return: 
    **/    
static testMethod void addToItemSubsectionAfterConfimationTestA() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 166);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);

        String addItems = VendorOrderReceivingCtrl.addToItemSubsectionAfterConfimation(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part.Id), false,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups[0].Need, 176);
    }

/**
     * Name: updateItemsSectionTest 
     * Desc: test to update receiving items for vendor order.
     * @param: 
     * @return: 
    **/ 
static testMethod void updateItemsSectionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
		Test.startTest();
        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);

        String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part.id),BPUtility.getEncodedString(voLineReceiveItems.VORGroupList[0].Id), 5, 8000,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveUpdatedItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(UpdatedItemsSubsection), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.stopTest();
        system.assertEquals(voLineReceiveUpdatedItems.VORGroupList[0].ReceivedQty, 5.000);
    }
/**
     * Name: updateLineItemsOfItemsSectionTest 
     * Desc: test to update line items for vendor order.
     * @param: 
     * @return: 
    **/ 
        
static testMethod void updateLineItemsOfItemsSectionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
		Test.startTest();
        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);

        String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.stopTest();
        String UpdatedLineItemSubsection = VendorOrderReceivingCtrl.updateLineItemsOfItemsSection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part.id),BPUtility.getEncodedString(voLineReceiveItems.VORGroupList[0].Id),BPUtility.getEncodedString('[{"VendorOrderLineItemList":[{"VendorOrderHeaderName":"' + voLineReceiveItems.RecentlyEditedVORGroupList[0].VendorOrderLineItemList[0].VendorOrderHeaderName + '","Total":500,"ReceivedQty":15,"QtyAvailable":0,"PartId":"' + voLineReceiveItems.RecentlyEditedVORGroupList[0].PartId + '","NeededFor":"MerchCO-0000004985","NeededBy":"08/28/2015","Need":50,"Location":"Houston","ItemDesc":"P-00002819 - part create by Durga to test","Item":"P-00002819 - New PartTSS204","IsSearchAdded":false,"IsRequiredForCustomer":true,"IsExcess":false,"Incoming":50,"Id":"' + voLineReceiveItems.VORGroupList[0].Id + '","Customer":"Honda Motors Inc","Cost":10,"CoHeaderId":"a0Ko0000004sQnTEAU"}],"UnitType":"NULL","Total":0,"ReceivedQty":15,"PartId":"' + voLineReceiveItems.RecentlyEditedVORGroupList[0].PartId + '","PackageQty":1,"OtherVOHeaderNameList":[],"OrderValue":50,"OrderType":"","NeededFor":"Merch CO-0000004985","NeededBy":"08/30/2015","Need":50,"ItemDesc":"New PartTSS204 - part create by Durga to test","IsExcess":false,"Id":"' + voLineReceiveItems.VORGroupList[0].Id + '","Cost":0}]'), BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveUpdatedItems1 = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(UpdatedLineItemSubsection), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
      	
        system.assertEquals(voLineReceiveUpdatedItems1.RecentlyEditedVORGroupList[0].ReceivedQty, 50.000);
    }

/**
     * Name: addAllLineItemsToItemSubsectionTest 
     * Desc: test to add all line items to itemsubsection.
     * @param: 
     * @return: 
    **/ 
            
static testMethod void addAllLineItemsToItemSubsectionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id), BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        List < Vendor_Order_Line_Item_Group__c > voligList = [Select Id from Vendor_Order_Line_Item_Group__c where Vendor_Order_Header__c =  : voHeader.Id];

        Id voligId = (voligList.size() > 0) ? voligList[0].Id : null;
        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);

        Test.startTest();
        String addItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(voHeader.id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.stopTest();
        //system.assert(false, voLineReceiveItems);
        system.assertEquals(voLineReceiveItems.VORGroupList[0].ReceivedQty, 50.000);
        system.assertEquals(voLineReceiveItems.VORGroupList[1].ReceivedQty, 30.000);
    }

/**
     * Name: addAllLineItemsToItemSubsectionTestA 
     * Desc: test to add all line items to itemsubsection where vedor order generated for different customers.
     * @param: 
     * @return: 
    **/   
static testMethod void addAllLineItemsToItemSubsectionTestA() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true, BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        List < Vendor_Order_Line_Item_Group__c > voligList = [Select Id from Vendor_Order_Line_Item_Group__c where Vendor_Order_Header__c =  : voHeader.Id];

        Id voligId = (voligList.size() > 0) ? voligList[0].Id : null;
        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);

        Test.startTest();
        String addItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(voligId),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);

        system.assertEquals(voLineReceiveItems.VORGroupList.size(), 2);
    }
    
/**
     * Name: removeItemTest 
     * Desc: test to remove item from  itemsubsection.
     * @param: 
     * @return: 
    **/
static testMethod void removeItemTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);
                
        Test.startTest();
        String addItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        
        List < Vendor_Receiving_Group__c > vorgList = [Select Id from Vendor_Receiving_Group__c where Vendor_Receiving_Header__c =  : vor.Id];
        Id vorgId = (vorgList.size() > 0) ? vorgList[0].Id : null;
        
        // VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving) System.JSON.deserialize(addItems, VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        String removedItems = VendorOrderReceivingCtrl.removeItem(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(vorgId),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(removedItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
       
        Test.stopTest();

        //system.assert(false, voGroupDetails);
        system.assertEquals(1, voLineReceiveItems.VORGroupList.size());
    }

/**
     * Name: removeAllItemsFromItemSubSectionTest 
     * Desc: test to remove all line items from  itemsubsection.
     * @param: 
     * @return: 
    **/   
static testMethod void removeAllItemsFromItemSubSectionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part.Packaged_Part__c = false;
        part.Qty_On_Order__c = 0;
        part.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true, BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        List < Vendor_Order_Line_Item_Group__c > voligList = [Select Id from Vendor_Order_Line_Item_Group__c where Vendor_Order_Header__c =  : voHeader.Id];

        Id voligId = (voligList.size() > 0) ? voligList[0].Id : null;
        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);

        Test.startTest();
        String addItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(voligId),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String removedItems = VendorOrderReceivingCtrl.removeAllItemsFromItemSubSection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(removedItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.stopTest();

        //system.assert(false, voLineReceiveItems);
        system.assertEquals(voLineReceiveItems.VORGroupList.size(), 0);
    }
/**
     * Name: getGroupRecDetailTest 
     * Desc: test to get details of vendorOrderReceive group.
     * @param: 
     * @return: 
    **/    
static testMethod void getGroupRecDetailTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        //String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String groupLineItems = VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), 120,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(null), true);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);
                
        Test.startTest();
        String addItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        
        List < Vendor_Receiving_Group__c > vorgList = [Select Id from Vendor_Receiving_Group__c where Vendor_Receiving_Header__c =  : vor.Id];
        Id vorgId = (vorgList.size() > 0) ? vorgList[0].Id : null;
        
        String grpRecordsDetails = VendorOrderReceivingCtrl.getGroupRecDetail(BPUtility.getEncodedString(vorgId));
       	List<VendorOrderReceivingCtrl.VRGroupDetail> groupDetails = (List<VendorOrderReceivingCtrl.VRGroupDetail>)System.JSON.deserialize(BPUtility.getDecodedString(grpRecordsDetails), List<VendorOrderReceivingCtrl.VRGroupDetail>.class);
       	Test.stopTest();
        
        //system.assert(false,groupDetails );
       	system.assertEquals(groupDetails[0].RequriedForCustomer, 50);
       	system.assertEquals(groupDetails[0].RequriedForStock, 110);
       	system.assertEquals(groupDetails[0].TotalExcess, 16);
       	system.assertEquals(groupDetails[0].PackageQty, 8);
    }

/**
     * Name: updateVORHeaderDetailsTest 
     * Desc: test to update VORHeader details.
     * @param: 
     * @return: 
    **/     
static testMethod void updateVORHeaderDetailsTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        //String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String groupLineItems = VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), 120,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(null), true);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);
                
        Test.startTest();
        String updatedVORHeader = VendorOrderReceivingCtrl.updateVORHeaderDetails(BPUtility.getEncodedString(vor.Id),BPUtility.getEncodedString('{"VORName":"VR-000761","VORId":"'+vor.Id+'","VendorName":"Test Vendor","VendorId":"'+vendor.Id+'","Status":"In Progress","ReceivingTotal":null,"ReceivingFromInvoiceTotal":null,"PackagingSlipNumber":"1234567","OwnerName":"Durga Singh","OwnerId":"005o00000023bUpAAI","IsReceivingFromInvoice":false}') ); 
        Test.stopTest();
        system.assertEquals(BPUtility.getDecodedString(updatedVORHeader).contains('1234567'), true);
       }
       
/**
     * Name: getOtherDetailsTest 
     * Desc: test to get other details likepart and coheader information.
     * @param: 
     * @return: 
    **/
static testMethod void getOtherDetailsTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)
		General_Configurations__c genConfig = Testutil.createGeneralConfig(10, true);
        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        insert part;

        Part__c part1 = TestUtil.createPart(false, 'partNumberP02', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        //Part.Packaged_Part__c = true ;
        part1.Packaged_Part__c = false;
        part1.Qty_On_Order__c = 0;
        part1.Order_Lots__c = 2;
        //insert part;
        //part.Qty_On_Order__c = 0;
        insert part1;

        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        Account customer1 = TestUtil.createCustomer(true, 'customerName1', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader1 = TestUtil.createCOHeader(true, customer1.Id);

        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader1.Id, part1.Id, 130);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        //String groupLineItems = VendorOrderCtrl.groupAllVOLineItem(vendor.Id, voHeader.Id, true, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String groupLineItems = VendorOrderCtrl.addVOLineItemFromSearchToAdd(BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), 120,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(null), true);
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vor.Id), true);
                
        Test.startTest();
        String partDetail = VendorOrderReceivingCtrl.getPartByPartId(BPUtility.getEncodedString(part.Id )); 
        String coHeaderDetail = VendorOrderReceivingCtrl.getCoHeaderById(BPUtility.getEncodedString(coHeader.Id));
        Test.stopTest();
        system.assertEquals(BPUtility.getDecodedString(partDetail).contains('Test Part'), true);
        system.assertEquals(BPUtility.getDecodedString(coHeaderDetail).contains('CustomerName'), true);
       }

/**
     * Name: addToItemSubsectionFromSearchToAddTest 
     * Desc: test to create vendor order from search to add and add to item subsection.
     * @param: 
     * @return: 
    **/       
static testMethod void addToItemSubsectionFromSearchToAddTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
		Part__c part1 = TestUtil.createPart(true, 'partNumberP02', vendor.Id, 'Test Part02', testCategory.Id, 10, 20, 50, 100, 50);


        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
        String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part1.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems);
        system.assertEquals(voLineReceiveItems.RecentlyEditedVORGroupList[0].ReceivedQty, 1.000);
    }
    
/**
     * Name: updateItemsSectionAfterItemAddedFromSearchToAddTest 
     * Desc: test to create and update vendor order from search to add and add to item subsection.
     * @param: 
     * @return: 
    **/  
static testMethod void updateItemsSectionAfterItemAddedFromSearchToAddTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
		Part__c part1 = TestUtil.createPart(true, 'partNumberP02', vendor.Id, 'Test Part02', testCategory.Id, 10, 20, 50, 100, 50);


        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);

        String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part1.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part1.id),BPUtility.getEncodedString(voLineReceiveItems.VORGroupList[0].Id), 5, 8000,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveUpdatedItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(UpdatedItemsSubsection), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
 
        system.assertEquals(voLineReceiveUpdatedItems.VORGroupList[0].ReceivedQty, 5.000);
    }
    
    /**
     * Name: updateItemsSectionWithNegativeQuantityAfterItemAddedFromSearchToAddTest 
     * Desc: test to create vendor order from search to add and update with negative quantity.
     * @param: 
     * @return: 
    **/
    static testMethod void updateItemsSectionWithNegativeQuantityAfterItemAddedFromSearchToAddTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
		Part__c part1 = TestUtil.createPart(true, 'partNumberP02', vendor.Id, 'Test Part02', testCategory.Id, 10, 20, 50, 100, 50);


        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;

        Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');

        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true);
		Test.StartTest();
        String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part1.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(addItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(BPUtility.getEncodedString(vor.id),BPUtility.getEncodedString(part1.id),BPUtility.getEncodedString(voLineReceiveItems.VORGroupList[0].Id), -5, 8000,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveUpdatedItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(UpdatedItemsSubsection), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		Test.StopTest();
        system.assertEquals(voLineReceiveUpdatedItems.VORGroupList.size(), 0);
    }

   /**
     * Name: addToItemSubsectionMultipleLineItemsFromSearchToAddTest 
     * Desc: test to create multiple line item from search to add and add to item subsection.
     * @param: 
     * @return: 
    **/    
static testMethod void addToItemSubsectionMultipleLineItemsFromSearchToAddTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
		Part__c part1 = TestUtil.createPart(true, 'partNumberP02', vendor.Id, 'Test Part02', testCategory.Id, 10, 20, 50, 100, 50);
		Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);


        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.StartTest();
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
       	String addItems = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(part1.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String addItems1 = VendorOrderReceivingCtrl.addToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(part2.Id),BPUtility.getEncodedString(vendor.Id), true,BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.StopTest();
        system.assertEquals(voLineReceiveItems.VORGroupList.size(), 2);
    }
 /**
     * Name: addToItemSubsectionMultipleLineItemGenratedFromSpecialOrderTest 
     * Desc: test to create multiple line item in vendor receive group generated from special order and add to item subsection.
     * @param: 
     * @return: 
    **/  
    
static testMethod void addToItemSubsectionMultipleLineItemGenratedFromSpecialOrderTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.StartTest();
		String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true,BPUtility.getEncodedString( System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true);
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
   		Test.StopTest();
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups.Size(), 2);
    }
    
    /**
     * Name: addToItemSubsectionMultipleLineItemGenratedFromSpecialOrderTestA 
     * Desc: test to create multiple line item in vendor receive group generated from special order and add to item subsection, asserted more items.
     * @param: 
     * @return: 
    **/  
    
    static testMethod void addToItemSubsectionMultipleLineItemGenratedFromSpecialOrderTestA() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		
		Test.StartTest();
        //Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
		String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), false, BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        //String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(vendor.Id, part.Id, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
		
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
        //String addItems = VendorOrderReceivingCtrl.addToItemSubsection(vor.id, part.Id, vendor.Id, false, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        //system.assert(false, voLineReceiveItems);
        Test.StopTest();
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups.Size(), 1);
        system.assertEquals(voLineReceiveItems.VORGroupList[0].ReceivedQty, 5.000);
    }

    /**
     * Name: addVendorOrderToItemSubsectionMergedTest 
     * Desc: test to add line item having null for VOLineItemgroup to item subsection.
     * @param: 
     * @return: 
    **/  
        
static testMethod void addVendorOrderToItemSubsectionMergedTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 100;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.StartTest();
        //Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
		String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), false, BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        //String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(vendor.Id, part.Id, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));

        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
        //String addItems = VendorOrderReceivingCtrl.addToItemSubsection(vor.id, part.Id, vendor.Id, false, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.StopTest();
        system.assertEquals(voLineReceiveItems.vendorOrdersList[0].VOLIGroups.Size(), 1);
        system.assertEquals(voLineReceiveItems.VORGroupList[0].ReceivedQty, 5.000);
    }
    
    /**
     * Name: commitRecevingActionTest 
     * Desc: test to commit and stock data update after receiving different parts from Vendor
     * @param: 
     * @return: 
    **/ 
     
static testMethod void commitRecevingActionTest() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        Part__c part2 = TestUtil.createPart(true, 'partNumberP03', vendor.Id, 'Test Part03', testCategory.Id, 10, 20, 50, 100, 50);
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        CO_Line_Item__c coLineItem1 = TestUtil.createCOLineItem(true, coHeader.Id, part2.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.StartTest();
        //Vendor_Receiving_Header__c vor = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
		String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), false,BPUtility.getEncodedString( System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        //String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(vendor.Id, part.Id, voHeader.Id, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
        //String addItems = VendorOrderReceivingCtrl.addToItemSubsection(vor.id, part.Id, vendor.Id, false, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        //String allLineItems = VendorOrderReceivingCtrl.addVendorOrderToItemSubsection(vorId, voHeader.Id, null, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        //String UpdatedItemsSubsection = VendorOrderReceivingCtrl.updateItemsSection(vorId, part.id, null, 5, 8000, System.JSON.serialize(pageSort), System.JSON.serialize(pageSort), System.JSON.serialize(pageSort));
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        Test.StopTest();
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList);
        system.assertEquals(partList[0].Qty_In_Stock__c, 320.00);
        system.assertEquals(partList[0].Qty_Committed__c, 100.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        system.assertEquals(partList[1].Qty_In_Stock__c, 50.00);
        system.assertEquals(partList[1].Qty_Committed__c, 50.00);
        system.assertEquals(partList[1].Qty_On_Order__c, 0);
    }
    
    /**
     * Name: commitRecevingActionTestA 
     * Desc: test to commit and stock data update after receiving single type of part from Vendor
     * @param: 
     * @return: 
    **/ 
    
	static testMethod void commitRecevingActionTestA() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);
        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.StartTest();
        String groupLineItems = VendorOrderCtrl.groupAllSimilarVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(part.Id),BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        VendorOrderLineItemWrapper voLineItems = (VendorOrderLineItemWrapper) System.JSON.deserialize(BPUtility.getDecodedString(finalizedLineItems), VendorOrderLineItemWrapper.class);

        
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vorId), true);
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId),BPUtility.getEncodedString(null),BPUtility.getEncodedString(voLineItems.VendorOrderLineItemGroupList[0].Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
		//String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(vorId);
		Test.StopTest();
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
        //system.assert(false, partList);
        system.assertEquals(partList[0].Qty_In_Stock__c, 100.00);
        //system.assertEquals(partList[0].Qty_In_Stock__c, 386.00);
        //system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        // system.assertEquals(partList[0].Qty_On_Order__c, 0); 

    }
    
    /**
     * Name: commitRecevingActionTestB 
     * Desc: test to commit and stock data update after receiving parts required for customer from Vendor
     * @param: 
     * @return: 
    **/ 	
	    static testMethod void commitRecevingActionTestB() {

        PaginationSorting pageSort = new PaginationSorting();
        pageSort.CurrentPage = 1;
        pageSort.PageSize = 10;
        pageSort.Sorting = new List < PaginationSorting.SortAttrs > {
            new PaginationSorting.SortAttrs('Item', 'ASC')
        };
        //System.JSON.serialize(pageSort)

        Account vendor = TestUtil.createVendor(true, 'Test Vendor');
        Category__c testCategory = TestUtil.createCategory(true, 'Test Category');
        Price_Level__c defaultPriceLevel = TestUtil.createPriceLevel(true, 'Default Price Level', 'MSRP', 10, true, true);
        Sales_Tax__c defaultSalesTax = TestUtil.createSalesTax(true, 'Test Sales Tax', true, true, true);
        Account customer = TestUtil.createCustomer(true, 'customerName', 'abc@abc.com', 'jaipur', '1111111111', null, null, false, true, 'Individual');
        CO_Header__c coHeader = TestUtil.createCOHeader(true, customer.Id);
        Part__c part = TestUtil.createPart(false, 'partNumberP01', vendor.Id, 'Test Part', testCategory.Id, 10, 20, 50, 100, 100);
        Part.Packaged_Part__c = true;
        Part.Package_Qty__c = 22;
        Part.Auto_reorder_Min__c = 0;
        part.Auto_reorder_Max__c = 200;
        part.Order_Lots__c = 1;
        //part.Qty_On_Order__c = 0;
        insert part;
        
        CO_Line_Item__c coLineItem = TestUtil.createCOLineItem(true, coHeader.Id, part.Id, 150);

        PO_Type__c POType = TestUtil.createPurchaseOrder(true, 'purchaseOrderCode', vendor.Id, true, 2);
        Vendor_Order_Header__c voHeader = TestUtil.createVendorOrderHeader(false, vendor.Id);
        voHeader.Purchase_Order_Type__c = POType.Id;
        insert voHeader;
		Test.startTest();
		String similarlineitem = VendorOrderCtrl.groupAllVOLineItem(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(voHeader.Id), true, BPUtility.getEncodedString( System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        String finalizedLineItems = VendorOrderCtrl.finalizeVendorOrder(BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        Vendor_Receiving_Header__c vrh = TestUtil.createVendorOrderReceiveHeader(true, vendor.Id, 'In Progress');
        Id vorId = Id.valueOf(BPUtility.getDecodedString(VendorOrderReceivingCtrl.addVendor(BPUtility.getEncodedString(vendor.Id),BPUtility.getEncodedString(null))));
        String VendorOrderReceiveItems = VendorOrderReceivingCtrl.receiveVendorOrderItems(BPUtility.getEncodedString(voHeader.Id), BPUtility.getEncodedString(vorId), true);
        
        String allLineItems = VendorOrderReceivingCtrl.addAllLineItemsToItemSubsection(BPUtility.getEncodedString(vorId), BPUtility.getEncodedString(voHeader.Id),BPUtility.getEncodedString(null),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)),BPUtility.getEncodedString(System.JSON.serialize(pageSort)));
        Test.stopTest();
        String commitLineItems = VendorOrderReceivingCtrl.commitRecevingAction(BPUtility.getEncodedString(vorId));
        VendorOrderReceivingCtrl.VendorOrderReceiving voLineReceiveItems = (VendorOrderReceivingCtrl.VendorOrderReceiving)System.JSON.deserialize(BPUtility.getDecodedString(allLineItems), VendorOrderReceivingCtrl.VendorOrderReceiving.class);
        
        List<Part__c> partList = [select Id, Part_Number__c, Qty_Committed__c, Qty_In_Stock__c, Qty_On_Order__c from Part__c];
       	
        system.assertEquals(partList[0].Qty_In_Stock__c, 166.00);
        system.assertEquals(partList[0].Qty_Committed__c, 150.00);
        system.assertEquals(partList[0].Qty_On_Order__c, 0);
        
         List<CO_Line_Item__c> colineitems = [select  Qty_Committed__c, Qty__c from CO_Line_Item__c];
         system.assertEquals(colineitems[0].Qty_Committed__c, 150.00);
    }
}